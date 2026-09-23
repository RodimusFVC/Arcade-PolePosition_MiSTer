//============================================================================
//  pp_steering.sv — Pole Position steering from MiSTer controllers
//
//  MAME polepos.cpp: STEER is an 8-bit IPT_DIAL (relative encoder); the 53xx
//  turns each change of that counter into left/right ticks (steering_changed_r).
//  This module produces that counter (`steer_pos`) from any mix of:
//    - spinner_0  (hps_io): relative, bit 8 toggles per event, [7:0] signed delta
//    - ps2_mouse  (hps_io): relative X, bit 24 toggles, {[4],[15:8]} signed
//    - joystick_l_analog_0 X / paddle_0 (mode 1 / 2): ABSOLUTE — the counter
//      tracks the device, so turning a wheel emits ticks and re-centring it emits
//      the return ticks (±64 counts at full lock, times Sensitivity)
//    - D-pad left/right (mode 0): the legacy 750 counts/s ramp
//  Relative sources are always live. Everything feeds one pending-counts
//  accumulator that moves steer_pos by at most one count per 3 kHz tick, so the
//  signed-8-bit delta the 53xx computes can never alias.
//  Sensitivity/Direction follow Tempest's OSD options (Arcade-Tempest_MiSTer).
//============================================================================
`default_nettype none

module pp_steering
(
    input  wire        clk,            // clk_sys 49.152 MHz
    input  wire        reset,

    input  wire  [1:0] mode,           // 0 = D-pad, 1 = analog stick/wheel, 2 = paddle
    input  wire  [2:0] sensitivity,    // 1.0 .75 .5 .25 .125 1.25 1.5 2.0 x
    input  wire        reverse,

    input  wire        left,
    input  wire        right,
    input  wire  [8:0] spinner,
    input  wire [24:0] mouse,
    input  wire  [7:0] analog_x,       // signed
    input  wire  [7:0] paddle,         // 0..255

    output reg   [7:0] steer_pos
);

    // ---- 3 kHz tick: clk / 16384 ----------------------------------------------
    reg [13:0] tdiv = 14'd0;
    always @(posedge clk) tdiv <= tdiv + 14'd1;
    wire tick = (tdiv == 14'd0);

    // ---- value * sensitivity, result in 1/8 counts (Q3) --------------------------
    function automatic signed [15:0] scale_q3(input signed [9:0] v, input [2:0] s);
        reg signed [15:0] e;
        begin
            e = {{6{v[9]}}, v};
            case (s)
                3'd0:    scale_q3 = e <<< 3;                  // 1.0x
                3'd1:    scale_q3 = (e <<< 2) + (e <<< 1);    // 0.75x
                3'd2:    scale_q3 = e <<< 2;                  // 0.5x
                3'd3:    scale_q3 = e <<< 1;                  // 0.25x
                3'd4:    scale_q3 = e;                        // 0.125x
                3'd5:    scale_q3 = (e <<< 3) + (e <<< 1);    // 1.25x
                3'd6:    scale_q3 = (e <<< 3) + (e <<< 2);    // 1.5x
                default: scale_q3 = e <<< 4;                  // 2.0x
            endcase
        end
    endfunction

    // ---- relative events ---------------------------------------------------------
    reg        spin_seen = 1'b0, mouse_seen = 1'b0;
    wire       spin_ev   = (spinner[8] != spin_seen);
    wire       mouse_ev  = (mouse[24]  != mouse_seen);
    wire signed [9:0] spin_d  = spin_ev  ? $signed({{2{spinner[7]}}, spinner[7:0]}) : 10'sd0;
    wire signed [9:0] mouse_d = mouse_ev ? $signed({mouse[4], mouse[4], mouse[15:8]}) : 10'sd0;

    // ---- absolute sources: ±128 raw -> ±64 counts at 1.0x ------------------------
    wire signed [8:0] ana_raw = $signed({analog_x[7], analog_x});
    wire signed [8:0] pad_raw = $signed({1'b0, paddle}) - 9'sd128;
    wire signed [8:0] abs_raw = (mode == 2'd2) ? pad_raw :
                                ((ana_raw > 9'sd6) || (ana_raw < -9'sd6)) ? ana_raw : 9'sd0;   // stick dead zone
    wire              abs_on  = (mode == 2'd1) || (mode == 2'd2);
    wire signed [15:0] abs_tgt = abs_on ? (scale_q3({abs_raw[8], abs_raw}, sensitivity) >>> 1) : 16'sd0;
    reg  signed [15:0] abs_last = 16'sd0;

    // ---- D-pad ramp: 2/8 count per tick = 750 counts/s (the pre-existing feel) --
    wire signed [15:0] pad_step = (mode == 2'd0 && (left ^ right)) ? (right ? 16'sd2 : -16'sd2) : 16'sd0;

    wire signed [15:0] rel_q3  = scale_q3(spin_d, sensitivity) + (scale_q3(mouse_d, sensitivity) >>> 1);
    wire signed [15:0] abs_d   = abs_tgt - abs_last;
    wire signed [15:0] in_q3   = rel_q3 + (tick ? pad_step : 16'sd0) + abs_d;
    wire signed [15:0] dir_q3  = reverse ? -in_q3 : in_q3;

    reg  signed [15:0] pending = 16'sd0;                   // Q3 counts still to be emitted
    wire signed [15:0] pend_in = pending + dir_q3;
    localparam signed [15:0] PEND_MAX = 16'sd2048;        // ±256 counts backlog

    reg  [1:0] mode_q = 2'd0;
    reg        rev_q  = 1'b0;

    always @(posedge clk) begin
        if (reset) begin
            steer_pos  <= 8'h80;
            pending    <= 16'sd0;
            abs_last   <= abs_tgt;
            spin_seen  <= spinner[8];
            mouse_seen <= mouse[24];
            mode_q     <= mode;
            rev_q      <= reverse;
        end else begin
            spin_seen  <= spinner[8];
            mouse_seen <= mouse[24];
            mode_q     <= mode;
            rev_q      <= reverse;
            abs_last   <= abs_tgt;
            if (mode != mode_q || reverse != rev_q) begin
                pending <= 16'sd0;                            // no jump when the OSD mode changes
            end else if (tick && pend_in >= 16'sd8) begin
                steer_pos <= steer_pos + 8'd1;
                pending   <= (pend_in - 16'sd8 > PEND_MAX) ? PEND_MAX : pend_in - 16'sd8;
            end else if (tick && pend_in <= -16'sd8) begin
                steer_pos <= steer_pos - 8'd1;
                pending   <= (pend_in + 16'sd8 < -PEND_MAX) ? -PEND_MAX : pend_in + 16'sd8;
            end else begin
                pending   <= (pend_in > PEND_MAX) ? PEND_MAX : (pend_in < -PEND_MAX) ? -PEND_MAX : pend_in;
            end
        end
    end

endmodule

`default_nettype wire
