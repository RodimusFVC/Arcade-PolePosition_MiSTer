//============================================================================
//  sound_lpf.sv -- 1:1 transliteration of rtl/sound_lpf.vhd. NOTE: the VHDL
//  entity/architecture inside that file is named `lpf` (not `sound_lpf`) --
//  this module is named `lpf` to match, per the "keep exact entity name"
//  rule; only the containing FILE is named sound_lpf.sv to mirror the .vhd
//  filename. Mechanical VHDL -> SystemVerilog port, 2026-08-05. Original
//  header + ASCII schematic + design-derivation comments preserved verbatim
//  below (translated `--` -> `//` only).
//
//  ---- Uncertainties / things worth a second look (not fixed, per the "zero
//  behavior change" rule -- flagging only) -----------------------------------
//
//  1) du3/du4 LIVE coefficients (VHDL lines 120-121, here in the clock_div==0
//     branch) are 109 / 109 / 1432 / 1027, with NO overall negation. Neither
//     matches the LPF1 derivation (11/256/34, negated) nor the LPF2
//     derivation (34/589/109, negated) documented immediately above them in
//     the original comments. This looks like a THIRD, undocumented coefficient
//     set (or a dropped sign) -- transliterated exactly as written; the
//     comment/code mismatch is preserved verbatim, not reconciled.
//
//  2) `uin`'s source expression (VHDL: `to_integer(unsigned(audio_in)-128)`)
//     is an UNSIGNED subtraction: if audio_in ever drops below 128, this
//     WRAPS modulo 1024 (giving a large positive value, e.g. audio_in=0 ->
//     896) rather than going negative -- matching numeric_std's defined
//     UNSIGNED-INTEGER "-" behavior. `uin`'s declared range (-256..255)
//     implies the design assumes audio_in never actually goes below 128 in
//     real operation (otherwise the VHDL's own range constraint on `uin`
//     would be violated in simulation). Replicated bit-for-bit below (the
//     wrap, if it ever occurs, is reproduced identically); not verified
//     against the real audio_in driver in poleposition.vhd (out of scope
//     here).
//
//  3) Only `clock_div` is covered by the synchronous `reset`. u3, u4, du3,
//     du4, uout, uout_lim and audio_out have NO VHDL initializer and are
//     never touched by the reset branch -- they simply hold whatever value
//     falls out of the clock_div-gated update logic. Translated with no SV
//     initializer either (matches: no change). Given this whole conversion's
//     purpose is closing sim/HW variance, note that Verilator will start
//     these at X while real Quartus silicon's power-up value for an
//     uninitialized register is tool-default (commonly 0, NOT verified here
//     since running Quartus is out of scope) -- a plausible source of
//     first-few-sample transient mismatch between sim and HW that pre-dates
//     this conversion (same ambiguity exists in the original VHDL).
//
//  4) div, r1, r2, dt_over_c3, dt_over_c4, r5 are ALL dead ports: each is
//     referenced only inside commented-out VHDL (the div-1 compare, and the
//     r1/r2/dt_over_c3/dt_over_c4/r5-based du3/du4 formulas). Preserved in
//     the port list unchanged per the no-cruft-removal rule; not wired to
//     anything internally, exactly as in the .vhd.
//
//  5) VHDL's process is `process(clock)` with `if reset='1' then ... else if
//     rising_edge(clock) then ... end if; end if;` -- sensitive to BOTH clock
//     edges, so a held-high reset re-asserts clock_div<=0 on the falling edge
//     too (the main logic itself only ever runs on rising_edge). Since no
//     other signal is touched while reset is high, this is observably
//     equivalent to a plain posedge-only synchronous reset; translated as
//     `always_ff @(posedge clock)` below.
//
//  6) `du3/scale`, `du4/scale`, `(u4-u3)/2` are VHDL native-INTEGER division
//     (truncates toward zero). Kept as SV signed "/" (also truncates toward
//     zero for signed operands) -- deliberately NOT rewritten as a shift
//     (`>>>`) even though `scale`=8192 is a power of 2, since arithmetic
//     right-shift rounds toward -infinity for negative values, which would
//     silently change behavior at the negative boundary.
//============================================================================
// ---------------------------------------------------------------------------------
// Galaga audio lpf filters based on Burnin' Rubber sources
// ---------------------------------------------------------------------------------
`default_nettype none

module lpf (
    input  wire        clock,
    input  wire        reset,

    input  wire signed [31:0] div,
    input  wire [9:0]         audio_in,

    input  wire signed [31:0] gain_in,
    input  wire signed [31:0] r1,
    input  wire signed [31:0] r2,
    input  wire signed [31:0] dt_over_c3,
    input  wire signed [31:0] dt_over_c4,
    input  wire signed [31:0] r5,

    output logic [15:0] audio_out
);

    logic [9:0] clock_div = 10'b0000000000;

    // to_integer(unsigned(audio_in)-128): unsigned subtract (wraps mod 1024
    // if audio_in<128, matching numeric_std's UNSIGNED-INTEGER "-" exactly),
    // then reinterpreted as a plain nonnegative integer -- see note (2) above.
    wire [9:0] audio_diff = audio_in - 10'd128;

    logic signed [8:0]  uin;       // integer range -256 to 255
    logic signed [15:0] u3;        // integer range -32768 to 32767
    logic signed [15:0] u4;        // integer range -32768 to 32767
    logic signed [27:0] du3;       // integer range -32768*4096 to 32767*4096
    logic signed [27:0] du4;       // integer range -32768*4096 to 32767*4096

    logic signed [15:0] uout;      // integer range -32768 to 32767
    logic signed [7:0]  uout_lim;  // integer range -128 to 127

    // integer scale for fixed point
    localparam int scale = 8192;

    // uout_lim+128 always lands in 0..255 (uout_lim is -128..127) -- widened
    // add first (matches VHDL's native-integer arithmetic, no overflow risk),
    // low 8 bits are then the exact to_unsigned(uout_lim+128, 8) result.
    wire signed [15:0] uout_lim_biased_wide = 16'(uout_lim) + 16'sd128;
    wire [7:0] uout_lim_biased = uout_lim_biased_wide[7:0];

    //                 ----------o------------
    //            u4^  |         |           |
    //              | --- C4    | | R5       |
    //              | ---       | |          |
    //              |  |    C3   |           |
    //     --| R1 |----o----||---o------|\   |
    //     ^           |  ------> u3    | \__o---
    //     |           |                | /     ^
    //     |uin       | | R2          --|/      |
    //     |          | |             |         | uout
    //     |           |              |         |
    //     ------------o--------------o----------
    //
    //
    // i1 = (sin+u3)/R1
    // i2 = -u3/R2
    // i3 = (u4-u3)/R5
    // i4 = i2-i1-i3
    //
    // u3(t+dt) = u3(t) + i3(t)*dt/C3;
    // u4(t+dt) = u4(t) + i4(t)*dt/C4;

    // uout = u4-u3

    // dt = 1/f_ech = 1/23437
    // dt/C3 = dt/C4 = 4267

    // LPF 1 calculations
    //
    // R1 = 150000;
    // R2 = 22000;
    // C3 = 0.01e-6;
    // C4 = 0.01e-6;
    // R5 = 470000;
    //
    // (i3(t)*dt/C3)*scale = du3*scale = ((u4-u3)/470000*4267)*scale
    //                               = (u4-u3)*11
    //
    // (i4(t)*dt/C4)*scale = du4*scale = (-u3/22000 -(uin+u3)/150000 -(u4-u3)/470000)*4267*scale
    //                               = -u3*(233+34-11) - uin*34 - u4*11
    //                               = -(u4*11 + u3*256 + uin*34)

    // LPF 2 calculations
    //
    // R1 = 47000;
    // R2 = 10000;
    // C3 = 0.01e-6;
    // C4 = 0.01e-6;
    // R5 = 150000;
    //
    // (i3(t)*dt/C3)*scale = du3*scale = ((u4-u3)/150000*4267)*scale
    //                               = (u4-u3)*34
    //
    // (i4(t)*dt/C4)*scale = du4*scale = (-u3/10000 -(uin+u3)/47000 -(u4-u3)/150000)*4267*scale
    //                               = -u3*(514+109-34) - uin*109 - u4*34
    //                               = -(u4*34 + u3*589 + uin*109)


    assign uin = 9'(32'(audio_diff) * gain_in);

    always_ff @(posedge clock) begin
        if (reset) begin
            clock_div <= 10'b0000000000;
        end else begin
            // divide 18 MHz clock by 768 = 23.437kHz downsampling
            //if clock_div = div-1 then -- "1011111111"
            if (clock_div == 10'b1011111111) begin
                clock_div <= 10'b0000000000;
            end else begin
                clock_div <= clock_div + 10'd1;
            end

            if (clock_div == 10'b0000000000) begin
                du3 <= u4*109 - u3*109;
                du4 <= u4*109 + u3*1432 + uin*1027;
                //  du3 <= (u4-u3)*scale*dt_over_c3/r5;
                // 	du4 <= u3*(scale*dt_over_c4/r2+scale*dt_over_c4/r1-scale*dt_over_c4/r5)
                // 	       + u4*scale*dt_over_c4/r5
                // 	       + uin*scale*dt_over_c4/r1;

                // 	du4 <= -u3*scale*dt_over_c4/r2
                // 	       -(uin+u3)*scale*dt_over_c4/r1
                // 	       -(u4-u3)*scale*dt_over_c4/r5;
            end

            if (clock_div == 10'b0000000001) begin
                // widen explicitly to 32 bits for the divide+add/sub (matches
                // VHDL's native 32-bit INTEGER arithmetic with headroom to
                // spare -- see width analysis in the header note); truncated
                // back to u3/u4's own 16-bit range on assignment, same as the
                // VHDL range-constrained integer signal's register storage.
                u3 <= 16'(32'(u3) + 32'(du3)/scale);
                u4 <= 16'(32'(u4) - 32'(du4)/scale);
            end

            if (clock_div == 10'b0000000010) begin
                uout <= (u4 - u3) / 2; // adjust output gain
            end

            // clamp
            if (clock_div == 10'b0000000011) begin
                if (uout > 127) begin
                    uout_lim <= 8'sd127;
                end else if (uout < -127) begin
                    uout_lim <= -8'sd127;
                end else begin
                    uout_lim <= 8'(uout);
                end
            end

            if (clock_div == 10'b0000000100) begin
                // audio_out <= std_logic_vector(to_unsigned(uout,10));
                audio_out <= {1'b0, uout_lim_biased, 7'b0000000};
            end
        end
    end

endmodule

`default_nettype wire
