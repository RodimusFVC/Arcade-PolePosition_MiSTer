//============================================================================
//  pp_noise54_snd.sv — Namco 54xx noise-generator analog output stage
//
//  NOISE54-2026-08-11. Companion to pp_voice52_snd.sv. namco_54xx.sv's three
//  discrete outputs (discrete_o0/o1/r1) were tied to `open` in
//  poleposition.vhd:965-967, so the 54xx's contribution — tyre screech, crash
//  and the low rumble — was inaudible by construction, exactly as the 52xx
//  voice was.
//
//  Ground truth: MAME src/mame/namco/polepos_a.cpp CHANL1/2/3 (:444-490) and
//  the ladder at :360-369. Unlike a discrete noise board, the 54xx MCU
//  generates the waveform itself and simply presents 4-bit levels; the analog
//  side is only DAC + bandpass. So, as with the 52xx, nothing is synthesised
//  here.
//
//  ---- channel map (do not shuffle these) -----------------------------------
//  MAME feeds a DIFFERENT 54xx port to each filter, and the bands are far
//  apart, so a mix-up is very audible:
//      CHANL1 <- NAMCO_54XX_2_DATA = R1 out   -> ~1330 Hz, Q 1.10
//      CHANL2 <- NAMCO_54XX_1_DATA = O4-O7    -> ~157 Hz,  Q 1.30
//      CHANL3 <- NAMCO_54XX_0_DATA = O0-O3    -> ~51 Hz,   Q 1.35
//  Centres derived from the multiple-feedback bandpass in polepos_a.cpp's
//  discrete_op_amp_filt_info structs: fc = 1/(2*pi*sqrt(R1*R3*C1*C2)) with
//  R1 = POLEPOS_54XX_DAC_R (2.635K) + the per-channel series resistor.
//
//  ---- the 54xx ladder is NOT the 52xx ladder -------------------------------
//  R118/R119/R120/R124 = 4.7K/10K/22K/47K (bit3..bit0), giving step weights
//  0.0561 / 0.1198 / 0.2635 / 0.5607 of full scale. Close to the 52xx's ratios
//  but not identical, so it gets its own LUT — same Q12-volts convention
//  (1.0 V = 4096), 4 V reference, POLEPOS_VREF = 2.0 V folded in, symmetric
//  about zero.
//
//  ---- DEVIATION: crude bandpass --------------------------------------------
//  MAME's sections are true 2nd-order multiple-feedback bandpasses with midband
//  gain 2.4-3.7. Here each channel is a 1-pole highpass followed by a 1-pole
//  lowpass at the same corner — a Q~0.5 bandpass with ~6 dB loss at centre,
//  power-of-two coefficients, no multipliers. It places each channel in
//  roughly the right band but is broader and quieter than the real thing.
//  Per-channel shifts are parameters on the instances below; OUT_SHIFT is the
//  single level knob and is deliberately CONSERVATIVE (see there).
//============================================================================
`default_nettype none

// ---- one bandpass channel --------------------------------------------------
module pp_noise54_chan #(parameter HP_SHIFT = 6, parameter LP_SHIFT = 6)
(
    input  wire        clk,
    input  wire        reset,
    input  wire        tick,
    input  wire  [3:0] level,       // 4-bit code from the 54xx
    output wire signed [27:0] band  // Q12 volts << 12
);
    // 54xx R1 ladder: 4V * SUM(bit_i*g_i)/SUM(g_i) - 2.0V, g = 1/{47,22,10,4.7}K
    reg signed [15:0] dac_q12;
    always @(*) begin
        case (level)
            4'h0: dac_q12 = -16'sd8192;   // -2.000 V
            4'h1: dac_q12 = -16'sd7273;   // -1.776 V
            4'h2: dac_q12 = -16'sd6230;   // -1.521 V
            4'h3: dac_q12 = -16'sd5311;   // -1.297 V
            4'h4: dac_q12 = -16'sd3875;   // -0.946 V
            4'h5: dac_q12 = -16'sd2956;   // -0.722 V
            4'h6: dac_q12 = -16'sd1912;   // -0.467 V
            4'h7: dac_q12 = -16'sd994;    // -0.243 V
            4'h8: dac_q12 =  16'sd994;    // +0.243 V
            4'h9: dac_q12 =  16'sd1912;   // +0.467 V
            4'hA: dac_q12 =  16'sd2956;   // +0.722 V
            4'hB: dac_q12 =  16'sd3875;   // +0.946 V
            4'hC: dac_q12 =  16'sd5311;   // +1.297 V
            4'hD: dac_q12 =  16'sd6230;   // +1.521 V
            4'hE: dac_q12 =  16'sd7273;   // +1.776 V
            4'hF: dac_q12 =  16'sd8192;   // +2.000 V
        endcase
    end

    reg signed [27:0] hp_acc, lp_acc;
    wire signed [27:0] dac_ext = $signed({dac_q12, 12'd0});
    wire signed [27:0] hp_out  = dac_ext - hp_acc;   // x - LP(x) = HP(x)

    always @(posedge clk) begin
        if (reset) begin
            hp_acc <= 28'sd0;
            lp_acc <= 28'sd0;
        end
        else if (tick) begin
            hp_acc <= hp_acc + ((dac_ext - hp_acc) >>> HP_SHIFT);
            lp_acc <= lp_acc + ((hp_out  - lp_acc) >>> LP_SHIFT);
        end
    end

    assign band = lp_acc;
endmodule


// ---- the three channels, summed --------------------------------------------
module pp_noise54_snd
(
    input  wire        clk,        // CLK_49M 49.152 MHz (poleposition.vhd's clock_18)
    input  wire        reset,
    input  wire        pause,

    input  wire  [3:0] o0_data,    // discrete_o0 -> CHANL3
    input  wire  [3:0] o1_data,    // discrete_o1 -> CHANL2
    input  wire  [3:0] r1_data,    // discrete_r1 -> CHANL1

    output reg signed [15:0] audio
);

    // LEVEL KNOB: the only gain term. Three channels summed, each up to +-8192
    // in Q12, so >>>12 keeps the worst case inside 16-bit signed with no
    // clipping. My crude bandpass is already ~6 dB down at centre where MAME's
    // has 2.4-3.7x GAIN, so this will likely sit too quiet against the engine —
    // drop to 11 to roughly double it once the character is judged correct.
    // Starting conservative on purpose: too quiet is diagnosable, clipping is
    // not.
    localparam OUT_SHIFT = 12;

    // ---- 48 kHz tick, same grid as the WSG / engine / 52xx voice -----------
    reg [9:0] tick_div;
    reg       tick;
    always @(posedge clk) begin
        tick <= 1'b0;
        if (reset) begin
            tick_div <= 10'd0;
        end
        else if (!pause) begin
            tick_div <= tick_div + 10'd1;
            if (tick_div == 10'd1023) tick <= 1'b1;
        end
    end

    // ---- CHANL3 ~51 Hz, CHANL2 ~157 Hz, CHANL1 ~1330 Hz --------------------
    // Nearest power-of-two alphas at 48 kHz: 1/128 -> ~60 Hz, 1/64 -> ~120 Hz,
    // 1/8 -> ~1020 Hz.
    wire signed [27:0] band3, band2, band1;

    pp_noise54_chan #(.HP_SHIFT(7), .LP_SHIFT(7)) u_chanl3
        (.clk(clk), .reset(reset), .tick(tick), .level(o0_data), .band(band3));

    pp_noise54_chan #(.HP_SHIFT(6), .LP_SHIFT(6)) u_chanl2
        (.clk(clk), .reset(reset), .tick(tick), .level(o1_data), .band(band2));

    pp_noise54_chan #(.HP_SHIFT(3), .LP_SHIFT(3)) u_chanl1
        (.clk(clk), .reset(reset), .tick(tick), .level(r1_data), .band(band1));

    wire signed [29:0] band_sum = $signed({{2{band1[27]}}, band1})
                                + $signed({{2{band2[27]}}, band2})
                                + $signed({{2{band3[27]}}, band3});
    wire signed [29:0] out_shifted = band_sum >>> OUT_SHIFT;

    always @(posedge clk) begin
        if (reset)      audio <= 16'sd0;
        else if (tick)  audio <= out_shifted[15:0];
    end

endmodule

`default_nettype wire
