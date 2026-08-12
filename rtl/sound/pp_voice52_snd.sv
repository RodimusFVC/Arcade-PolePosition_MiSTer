//============================================================================
//  pp_voice52_snd.sv — Namco 52xx voice ("sample player") analog output stage
//
//  VOICE52-2026-08-11. Until now namco_52xx.sv's audio output (discrete_p =
//  the chip's OUT0-OUT3 pins) was tied to `open` in poleposition.vhd:985, so
//  the voice samples were inaudible BY CONSTRUCTION — the MCU ran, addressed
//  its 0x8000 voice ROM and emitted PCM, and nothing listened. This module is
//  the missing listener: it is MAME's CHANL4 discrete chain.
//
//  Ground truth: MAME src/mame/namco/polepos_a.cpp, CHANL4 (:496-523), plus
//  the DAC ladder definition at :371-380. namco52.cpp's pinout comment (:14,
//  :25-28) is what establishes that P0-P3 *are* the sound output:
//      OUT0-OUT3 = sound output ... (OUT0) P0|9 ... (OUT3) P3|12
//  So the 4-bit P port is already-decoded PCM. Nothing has to be synthesised
//  here — this is only DAC + filter + level.
//
//  ---- MAME's CHANL4, transcribed -------------------------------------------
//      NODE_50 = DAC_R1(52xx P data, 4V, polepos_52xx_dac)   // R1 ladder
//      NODE_51 = NODE_50 - POLEPOS_VREF                      // centre on 0
//      NODE_52 = FILTER2(NODE_51,  100 Hz, damp 1/0.3, HIGHPASS)
//      NODE_53 = FILTER2(NODE_52, 1200 Hz, damp 1/0.8, LOWPASS)
//      NODE_54 = GAIN(NODE_53, 0.5)
//      CHANL4  = CLAMP(NODE_54, 0, 5.0 - VP_RAIL_OFFSET - VREF)
//      DISCRETE_OUTPUT(CHANL4, 32767/2)
//  polepos_a.cpp:495 notes the real circuit was SPICE-simulated and reduced to
//  this equivalent, so MAME is already an approximation — matching MAME's
//  topology is the right fidelity target, not the schematic.
//
//  ---- the DAC ladder is NOT plain binary -----------------------------------
//  R160=100K R159=47K R155=22K R154=10K (bits 0..3). Conductance-weighted, so
//  the step sizes are 0.0566 / 0.1204 / 0.2572 / 0.5658 of full scale, not
//  1/15 / 2/15 / 4/15 / 8/15. The 16-entry LUT below is that exact ladder
//  evaluated at 4 V and offset by POLEPOS_VREF (= 5*1K/(1.5K+1K) = 2.0 V),
//  expressed in Q12 volts (1.0 V = 4096). It comes out symmetric about zero,
//  -2.000 V at 0x0 to +2.000 V at 0xF, which is the "fake it so 0 is now vRef"
//  step folded in for free.
//
//  ---- DEVIATION: the two FILTER2 sections are 1-pole approximations ---------
//  MAME uses state-variable 2nd-order sections (Q = 0.3 highpass, Q = 0.8
//  lowpass). Here the highpass is one pole used as a DC blocker, and the
//  lowpass is two cascaded 1-pole sections, both with power-of-two
//  coefficients so this costs no multipliers (LE budget: MiSTer Pi).
//      HP_SHIFT 6 -> alpha 1/64  -> ~120 Hz  (MAME  100 Hz)
//      LP_SHIFT 3 -> alpha 1/8   -> ~1020 Hz per pole, Q=0.5 (MAME 1200, Q=0.8)
//  Net effect: very slightly darker than MAME. BOTH are localparams — if the
//  speech sounds muffled on hardware, drop LP_SHIFT to 2 (~2200 Hz per pole)
//  and it brightens; that is a one-character change. The DC blocker matters
//  regardless of fidelity: the 52xx parks P at a non-zero code between samples,
//  and without the highpass that lands in the mix as a constant DC offset.
//
//  ---- clamp -----------------------------------------------------------------
//  MAME's CLAMP guards its op-amp rail. After the highpass the signal here is
//  already centred and cannot exceed the LUT range, so the explicit clamp is
//  redundant; the saturating adder in poleposition.vhd is the real backstop.
//============================================================================
`default_nettype none

module pp_voice52_snd
(
    input  wire        clk,        // CLK_49M 49.152 MHz (poleposition.vhd's clock_18)
    input  wire        reset,
    input  wire        pause,      // PAUSE-GATE: freeze the tick, as the other voices do

    input  wire  [3:0] p_data,     // namco_52xx discrete_p — OUT0-OUT3, 4-bit PCM

    output reg signed [15:0] audio
);

    // ---- filter coefficients + level, all in one place ---------------------
    localparam HP_SHIFT  = 6;   // DC blocker,  alpha = 1/64
    localparam LP_SHIFT  = 3;   // 2x 1-pole,   alpha = 1/8
    // LEVEL KNOB: the ONLY gain term in this module. Q12 volts -> 16-bit, and
    // >>>11 (rather than >>>12) folds in MAME's GAIN(0.5) + DISCRETE_OUTPUT
    // scale of 32767/2, putting +-2.0 V at +-16384 — the same order as
    // pp_engine_snd's post->>>1 peak, so the two sit together in the mix.
    // Too loud against the melody: raise to 12. Too quiet: drop to 10.
    localparam OUT_SHIFT = 11;

    // ---- 48 kHz output tick: CLK_49M / 1024 --------------------------------
    // Same divider as namco_wsg8 and pp_engine_snd, so all three voices land on
    // one update grid and the mix has no beating between them.
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

    // ---- R1 ladder DAC, 4 V, offset by VREF, in Q12 volts ------------------
    //  value(v) = 4.0 * SUM(bit_i * g_i)/SUM(g_i) - 2.0,  g = 1/{100,47,22,10}K
    reg signed [15:0] dac_q12;
    always @(*) begin
        case (p_data)
            4'h0: dac_q12 = -16'sd8192;   // -2.000 V
            4'h1: dac_q12 = -16'sd7265;   // -1.774 V
            4'h2: dac_q12 = -16'sd6220;   // -1.518 V
            4'h3: dac_q12 = -16'sd5293;   // -1.292 V
            4'h4: dac_q12 = -16'sd3978;   // -0.971 V
            4'h5: dac_q12 = -16'sd3051;   // -0.745 V
            4'h6: dac_q12 = -16'sd2006;   // -0.490 V
            4'h7: dac_q12 = -16'sd1079;   // -0.263 V
            4'h8: dac_q12 =  16'sd1079;   // +0.263 V
            4'h9: dac_q12 =  16'sd2006;   // +0.490 V
            4'hA: dac_q12 =  16'sd3051;   // +0.745 V
            4'hB: dac_q12 =  16'sd3978;   // +0.971 V
            4'hC: dac_q12 =  16'sd5293;   // +1.292 V
            4'hD: dac_q12 =  16'sd6220;   // +1.518 V
            4'hE: dac_q12 =  16'sd7265;   // +1.774 V
            4'hF: dac_q12 =  16'sd8192;   // +2.000 V
        endcase
    end

    // ---- filter state, Q12 volts carried with 12 extra fraction bits -------
    // The extra fraction is what stops a >>>SHIFT IIR from stalling on small
    // signals: at Q12 alone, (x-acc)>>>6 truncates to 0 well before the filter
    // has settled, and the tail of every sample would freeze at a DC step.
    reg signed [27:0] hp_acc, lp1_acc, lp2_acc;

    wire signed [27:0] dac_ext = $signed({dac_q12, 12'd0});
    wire signed [27:0] hp_out  = dac_ext - hp_acc;   // x - LP(x) = HP(x)

    // |lp2_acc| <= 8192<<12 = 2^25, so >>>11 peaks at 2^14 = 16384 and the low
    // 16 bits carry the sign correctly with room to spare.
    wire signed [27:0] out_shifted = lp2_acc >>> OUT_SHIFT;

    always @(posedge clk) begin
        if (reset) begin
            hp_acc  <= 28'sd0;
            lp1_acc <= 28'sd0;
            lp2_acc <= 28'sd0;
            audio   <= 16'sd0;
        end
        else if (tick) begin
            hp_acc  <= hp_acc  + ((dac_ext - hp_acc)  >>> HP_SHIFT);
            lp1_acc <= lp1_acc + ((hp_out  - lp1_acc) >>> LP_SHIFT);
            lp2_acc <= lp2_acc + ((lp1_acc - lp2_acc) >>> LP_SHIFT);
            audio   <= out_shifted[15:0];
        end
    end

endmodule

`default_nettype wire
