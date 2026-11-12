//============================================================================
//  namco_wsg8.sv -- Namco WSG (Waveform Sound Generator), Pole Position's 8-voice / quad-gain variant.
//  SPDX-License-Identifier: BSD-3-Clause
//  Copyright (C) 2026 Rodimus
//  Based on MAME src/devices/sound/namco.cpp, polepos_wsg_device
//  (license:BSD-3-Clause, copyright-holders: Nicola Salmoria, Aaron Giles).
//
//  Registers (0x83C0-0x83FF), per voice ch: base = ch*4
//    base+0/1   frequency (16-bit)
//    base+2     [7:4] GAIN2 (rear right)
//    base+3     [7:4] GAIN3 (front left), [3:0] GAIN4 (front right)
//    ch*4+0x23  [7:4] GAIN1 (rear left), [3] external source (voice muted), [2:0] waveform
//  Waveform ROM: 8 x 32 4-bit samples (ioctl index 2 +0x1040), value = nibble - 8.
//  48 kHz tick, 20-bit accumulator per voice (waveform index = counter[19:15]).
//  Output: mono = sum of (sample * (front + rear volume)) per side, both sides, * 8 (MAME OUTPUT_LEVEL / 4).
//  Register file and ROM are distributed logic (40 register + 8 waveform reads per tick).
//============================================================================
`default_nettype none

module namco_wsg8
(
    input  wire        clk,          // CLK_49M fabric clock (49.152 MHz)
    input  wire        reset,
    input  wire        sound_en,     // LS259 q2, MAME sound_enable_w (active-high, NOT inverted)
    input  wire        pause,

    // ---- Z80-side register bus (PolePosition_CPU.sv wsg_* ports) -----------
    input  wire  [5:0] reg_addr,     // = cpu_A[5:0], offset within 0x83C0-0x83FF
    input  wire  [7:0] reg_din,      // write data from CPU (wsg_dout)
    input  wire        reg_wr,       // single clk_sys pulse per Z80 write (cs_wsg & wr_s)
    output wire  [7:0] reg_dout,     // read data back to CPU (-> wsg_din)

    // ---- waveform PROM load (ioctl index 2, region-relative address from the top level)
    input  wire        wave_wr,
    input  wire  [7:0] wave_addr,
    input  wire  [7:0] wave_data,

    output reg  [15:0] audio         // mono sample, signed two's-complement bits
);

    // ---- 64-byte register file (distributed logic; see header) ------------
    reg [7:0] regs [0:63];
    always @(posedge clk) if (reg_wr) regs[reg_addr] <= reg_din;
    assign reg_dout = regs[reg_addr];

    // ---- 256-byte waveform ROM (distributed logic; see header) -------------
    reg [3:0] wave_rom [0:255];
    always @(posedge clk) if (wave_wr) wave_rom[wave_addr] <= wave_data[3:0];

    // ---- 48 kHz sample tick: 49.152 MHz / 1024 (MAME MASTER_CLOCK/512)
    reg [9:0] ce_div;
    wire ce_wsg = (ce_div == 10'd0) & ~pause;
    always @(posedge clk) ce_div <= ce_div + 10'd1;

    // ---- per-voice state (flat arrays; see header re: distributed logic) --
    reg  [19:0] counter    [0:7];
    wire [15:0] freq       [0:7];
    wire  [7:0] g23        [0:7];   // regs[ch*4+0x23]: GAIN1 | ext-select | waveform_select
    wire  [7:0] g03        [0:7];   // regs[ch*4+0x03]: GAIN3 (hi) / GAIN4 (lo)
    wire  [7:0] g02        [0:7];   // regs[ch*4+0x02]: GAIN2 (hi)
    wire  [2:0] wsel       [0:7];
    wire        extsel     [0:7];
    wire  [4:0] wpos       [0:7];
    wire  [7:0] waddr      [0:7];
    wire  [3:0] wnib       [0:7];
    wire signed [4:0] wsig [0:7];   // wnib - 8, range -8..+7
    wire  [4:0] vol_l      [0:7];
    wire  [4:0] vol_r      [0:7];
    wire signed [10:0] contrib_l [0:7];
    wire signed [10:0] contrib_r [0:7];

    genvar v;
    generate
        for (v = 0; v < 8; v = v + 1) begin : g_voice
            assign freq[v]   = {regs[v*4+1], regs[v*4+0]};
            assign g23[v]    = regs[v*4+8'h23];
            assign g03[v]    = regs[v*4+3];
            assign g02[v]    = regs[v*4+2];
            assign wsel[v]   = g23[v][2:0];
            assign extsel[v] = g23[v][3];

            always @(posedge clk) begin
                if (reset)       counter[v] <= 20'd0;
                else if (ce_wsg) counter[v] <= counter[v] + freq[v];
            end

            assign wpos[v]  = counter[v][19:15];
            assign waddr[v] = {wsel[v], wpos[v]};
            assign wnib[v]  = wave_rom[waddr[v]];
            assign wsig[v]  = $signed({1'b0, wnib[v]}) - 5'sd8;

            // front + rear volume per side (MAME drives FL/FR/RL/RR separately; the music uses one speaker per voice)
            assign vol_l[v] = extsel[v] ? 5'd0 : ({1'b0,g03[v][7:4]} + {1'b0,g23[v][7:4]});
            assign vol_r[v] = extsel[v] ? 5'd0 : ({1'b0,g03[v][3:0]} + {1'b0,g02[v][7:4]});

            assign contrib_l[v] = wsig[v] * $signed({1'b0, vol_l[v]});
            assign contrib_r[v] = wsig[v] * $signed({1'b0, vol_r[v]});
        end
    endgenerate

    // ---- sum across voices, then MIXLEVEL scale + L/R->mono average --------
    integer i;
    reg signed [12:0] sum_l, sum_r;
    always @(*) begin
        sum_l = 13'sd0;
        sum_r = 13'sd0;
        for (i = 0; i < 8; i = i + 1) begin
            sum_l = sum_l + contrib_l[i];
            sum_r = sum_r + contrib_r[i];
        end
    end

    wire signed [13:0] mix_sum     = sum_l + sum_r;
    // * 32 (OUTPUT_LEVEL) / 2 (L/R average) / 2 (front/rear volume sum) = <<3; max 30720
    wire signed [17:0] mix_shifted = mix_sum <<< 3;
    wire signed [15:0] mono        = mix_shifted[15:0];

    always @(posedge clk) audio <= sound_en ? mono : 16'd0;

endmodule

`default_nettype wire
