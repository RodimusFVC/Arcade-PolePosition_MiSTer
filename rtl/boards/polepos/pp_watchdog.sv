//  Based on MAME polepos.cpp, watchdog.cpp (Ernesto Corvi, Juergen Buchmueller, Alex Pasadyn, Aaron Giles, Nicola Salmoria; Aaron Giles, BSD-3-Clause)
`default_nettype none

module pp_watchdog #(
    parameter PULSE_CYCLES = 32
)
(
    input  wire       clk,
    input  wire        reset,
    input  wire        wdog_en,     // 1 = watchdog live, 0 = permanently defeated
    input  wire  [8:0] vpos,
    input  wire        kick,
    input  wire        pause,
    output reg         wdog_reset
);

    reg [8:0] vpos_d;
    always @(posedge clk) vpos_d <= vpos;
    wire vblank_start = (vpos == 9'd240) & (vpos_d != 9'd240);

    reg [3:0] vbl_count;
    reg [4:0] pulse_cnt;
    reg       pulsing;

    always @(posedge clk) begin
        if (reset || !wdog_en) begin
            vbl_count  <= 4'd0;
            pulsing    <= 1'b0;
            pulse_cnt  <= 5'd0;
            wdog_reset <= 1'b0;
        end else if (pulsing) begin
            if (pulse_cnt == PULSE_CYCLES-1) begin
                pulsing    <= 1'b0;
                wdog_reset <= 1'b0;
                vbl_count  <= 4'd0;
            end else begin
                pulse_cnt <= pulse_cnt + 5'd1;
            end
        end else if (pause) begin
            vbl_count <= 4'd0;  // pause clears the count, never freezes it
        end else if (kick) begin
            vbl_count <= 4'd0;
        end else if (vblank_start) begin
            if (vbl_count == 4'd15) begin
                wdog_reset <= 1'b1;
                pulsing    <= 1'b1;
                pulse_cnt  <= 5'd0;
            end else begin
                vbl_count <= vbl_count + 4'd1;
            end
        end
    end

endmodule

`default_nettype wire
