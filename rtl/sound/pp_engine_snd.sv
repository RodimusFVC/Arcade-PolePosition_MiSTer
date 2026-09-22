//============================================================================
//  pp_engine_snd.sv — Pole Position engine ("car") sound generator
//
//  Ground truth: MAME src/mame/namco/polepos_a.cpp, polepos_sound_device.
//  Machine wiring from polepos.cpp:
//    :452  map(0xa200) -> polepos_engine_sound_lsb_w   (lsb_wr here)
//    :453  map(0xa300) -> polepos_engine_sound_msb_w   (msb_wr here)
//    :938  m_latch->q_out_cb<2> -> clson_w             (clson here = sound_en)
//    :975  POLEPOS_SOUND(config, "engine", MASTER_CLOCK/8)  = 24.576MHz/8 = 3.072MHz
//  Waveform data = the 0x4000 "engine" ROM region (pp1_15.6a + pp1_16.5a),
//  addressed as 8 slots x 0x800 bytes.
//
//  ---- MAME's sound_stream_update, transcribed ------------------------------
//      if (!m_sample_enable) return;                       // silence, no advance
//      clock = (unscaled_clock()/16) * ((msb+1)*64 + lsb+1) / (64*64);
//      step  = (clock << 12) / OUTPUT_RATE;
//      slot  = (msb >> 3) & 7;   volume = volume_table[slot];
//      base  = &m_data[slot * 0x800];
//      x0    = (3.4/255 * base[(pos >> 12) & 0x7ff] - 2) * volume;
//      pos  += step;
//
//  ---- why step is exactly 4*N here -----------------------------------------
//  We run the output tick at 48 kHz (CLK_49M/1024, the same divider namco_wsg8
//  uses, so both voices update on the same cadence). With N = (msb+1)*64+lsb+1:
//      clock = (3.072e6/16) * N / 4096 = 192000*N/4096
//      step  = clock * 4096 / 48000    = 192000*N/48000 = 4*N       (exact)
//  No approximation and no divider — that is the whole reason for picking
//  48 kHz rather than an arbitrary rate.
//
//  ---- DC offset ------------------------------------------------------------
//  MAME's (3.4/255)*b - 2 is zero at b = 2*255/3.4 = 150 exactly, so the signed
//  sample is simply (rom_data - 150) scaled by volume.
//
//  ---- SCOPE: the 3-pole analog filter chain is NOT modelled -----------------
//  polepos_a.cpp runs x0 through two op-amp multiple-feedback bandpass sections
//  and one 950 Hz highpass, clips each at [-2, +1.5] V, and sums them through
//  4.7k/7.5k/10k. That shapes the engine timbre; it is deliberately left out of
//  this first pass so there is something audible to judge. Expect the tone to be
//  harsher/buzzier than a real board. Adding the biquads is the obvious next
//  step if the pitch/behaviour prove correct.
//============================================================================
`default_nettype none

module pp_engine_snd
(
    input  wire        clk,        // CLK_49M 49.152 MHz (poleposition.vhd's clock_18)
    input  wire        reset,
    input  wire        pause,      // PAUSE-GATE: freeze the sample tick, as namco_wsg8 does

    input  wire        clson,      // LS259 q2 (sound_en). Falling edge clears the regs.
    input  wire        lsb_wr,     // 0xA200 write strobe
    input  wire        msb_wr,     // 0xA300 write strobe
    input  wire  [7:0] din,

    output wire [13:0] rom_addr,   // engine ROM: {slot[2:0], index[10:0]} = 0x4000
    input  wire  [7:0] rom_data,

    output reg signed [15:0] audio
);

    // ---- control registers (polepos_a.cpp lsb_w / msb_w) -------------------
    //  lsb_w: m_sample_lsb = data & 62;  m_sample_enable = data & 1;
    //  msb_w: m_sample_msb = data & 63;
    reg [5:0] sample_msb;
    reg [5:0] sample_lsb;
    reg       sample_en;

    // clson_w(state) only acts on the 1->0 transition, and the register writes
    // themselves are NOT gated by clson in MAME — a CPU write while clson is low
    // still lands. Hence an edge detect rather than a level hold.
    reg  clson_r;
    wire clson_fall = clson_r & ~clson;

    always @(posedge clk) begin
        clson_r <= clson;
        if (reset) begin
            sample_msb <= 6'd0;
            sample_lsb <= 6'd0;
            sample_en  <= 1'b0;
        end else begin
            if (lsb_wr) begin
                sample_lsb <= din[5:0] & 6'b111110;   // data & 62
                sample_en  <= din[0];                 // data & 1
            end
            if (msb_wr) sample_msb <= din[5:0];       // data & 63
            if (clson_fall) begin                     // lsb_w(0) + msb_w(0)
                sample_lsb <= 6'd0;
                sample_en  <= 1'b0;
                sample_msb <= 6'd0;
            end
        end
    end

    // ---- rate: N = (msb+1)*64 + lsb + 1 = (msb<<6) + lsb + 65, step = 4*N --
    wire [12:0] n_val = {1'b0, sample_msb, 6'd0} + {7'd0, sample_lsb} + 13'd65;
    wire [14:0] step  = {n_val, 2'b00};

    // ---- 48 kHz sample tick: CLK_49M/1024 = 48,000 Hz exactly --------------
    //  Free-running divider, same shape as namco_wsg8's ce_div.
    reg [9:0] ce_div;
    always @(posedge clk) ce_div <= ce_div + 1'b1;
    wire tick = (ce_div == 10'd0) & ~pause;

    // ---- phase accumulator -------------------------------------------------
    //  23 bits so that position[22:12] IS the 11-bit table index and the wrap
    //  at 2^23 performs MAME's "& 0x7ff" for free.
    reg [22:0] position;
    always @(posedge clk) begin
        if (reset)                        position <= 23'd0;
        // MAME returns early when disabled, so the position does NOT advance.
        else if (tick && sample_en)       position <= position + {8'd0, step};
    end

    assign rom_addr = {sample_msb[5:3], position[22:12]};   // {slot, index}

    // ---- volume_table[8], polepos_a.cpp:27-37, as Q8 -----------------------
    //  (R168t + R167t + R166t + 2200)/10000, each R either full or shunted.
    //  Shunt value is 1/(1/1000 + 1/250) = 200 for all three — polepos_a.cpp
    //  uses POLEPOS_R166 in all three _SHUNT macros. That looks like a copy-paste
    //  slip in MAME, but MAME is the reference we are matching, so it is
    //  reproduced deliberately. Do not "fix" it without a real board to compare.
    //    0.28 0.36 0.48 0.56 0.73 0.81 0.93 1.01   (x256, rounded)
    reg [8:0] volq8;
    always @(*) case (sample_msb[5:3])
        3'd0: volq8 = 9'd72;    3'd1: volq8 = 9'd92;
        3'd2: volq8 = 9'd123;   3'd3: volq8 = 9'd143;
        3'd4: volq8 = 9'd187;   3'd5: volq8 = 9'd207;
        3'd6: volq8 = 9'd238;   default: volq8 = 9'd259;
    endcase

    // ---- sample: (rom_data - 150) * volume ---------------------------------
    wire signed [8:0]  raw    = $signed({1'b0, rom_data}) - 9'sd150;   // -150..+105
    wire signed [18:0] scaled = raw * $signed({1'b0, volq8});          // -38850..+27195

    // LEVEL KNOB: >>>1 puts the peak at -19425..+13597, which fits 16-bit signed
    // with headroom to mix against the WSG. If the engine sits too low or too
    // high against the melody on real hardware, change this ONE shift — it is
    // the only gain term in the module.
    wire signed [18:0] halved = scaled >>> 1;

    always @(posedge clk) begin
        if (reset)           audio <= 16'sd0;
        else if (!sample_en) audio <= 16'sd0;      // MAME: not enabled -> fill with 0
        else                 audio <= halved[15:0];
    end

endmodule

`default_nettype wire
