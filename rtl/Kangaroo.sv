//============================================================================
//
//  Kangaroo top-level module
//  Copyright (C) 2026 Rodimus
//  Based on MAME kangaroo.cpp
//
//============================================================================

module Kangaroo
(
    input                reset,
    input                clk_10m,

    // Player inputs (active HIGH, per MAME port definitions)
    input          [4:0] in0,              // {coin_r, coin_l, start2, start1, service}
    // GAMESEL-2026-06-21: in1 widened 5->8 (bit5/0x20 = Funky Fish 2nd button). Original: input [4:0] in1,
    input          [7:0] in1,              // {2'b0, ff_btn2(0x20), punch, down, up, left, right} P1
    input          [7:0] in2,              // {punch, down, up, left, right} P2
    input          [7:0] dsw0,             // 8-bit DIP switch

    // Video outputs
    output               video_hsync, video_vsync,
    output               video_hblank, video_vblank,
    output               ce_pix,
    output         [7:0] video_r, video_g, video_b,

    // Audio
    output signed [15:0] sound_l,
    output signed [15:0] sound_r,

    // ROM loading
    input         [24:0] ioctl_addr,
    input          [7:0] ioctl_data,
    input                ioctl_wr,
    input          [7:0] ioctl_index,

    input                pause,

    // MB8841 MCU present (original Kangaroo HW). From MRA index-5 game-select byte bit1.
    input                mcu_present,

    // Hiscore (stubbed)
    input         [15:0] hs_address,
    input          [7:0] hs_data_in,
    output         [7:0] hs_data_out,
    input                hs_write
);

//------------------------------------------------------- ROM Selectors -------------------------------------------------------//

// Main CPU ROMs (index 0)
wire rom0_cs, rom1_cs, rom2_cs, rom3_cs, rom4_cs, rom5_cs;
wire idx0_wr = ioctl_wr & (ioctl_index == 8'd0);
selector main_sel
(
    .ioctl_addr(ioctl_addr),
    .rom0_cs(rom0_cs), .rom1_cs(rom1_cs), .rom2_cs(rom2_cs),
    .rom3_cs(rom3_cs), .rom4_cs(rom4_cs), .rom5_cs(rom5_cs)
);

// Sound ROM (index 1) — single 4KB, no selector needed
wire sndrom_cs = (ioctl_index == 8'd1);
wire idx1_wr = ioctl_wr & sndrom_cs;

// MCU ROMs (index 6: MB8841 prog 0x000-0x7FF + protection PROM 0x800-0xFFF)
wire idx6_wr = ioctl_wr & (ioctl_index == 8'd6);

// Blitter ROMs (index 2)
wire blit0_cs, blit1_cs, blit2_cs, blit3_cs;
wire idx2_wr = ioctl_wr & (ioctl_index == 8'd2);
blit_selector blit_sel
(
    .ioctl_addr(ioctl_addr),
    .blit0_cs(blit0_cs), .blit1_cs(blit1_cs),
    .blit2_cs(blit2_cs), .blit3_cs(blit3_cs)
);

//------------------------------------------------------- CPU Board -----------------------------------------------------------//

wire [7:0] cpu_sound_latch;
wire       cpu_sound_latch_wr;
wire [2:0] raw_r, raw_g;
wire [1:0] raw_b;

Kangaroo_CPU cpu_board
(
    .reset(reset),
    .clk_10m(clk_10m),

    .video_r(raw_r),
    .video_g(raw_g),
    .video_b(raw_b),
    .video_hsync(video_hsync),
    .video_vsync(video_vsync),
    .video_hblank(video_hblank),
    .video_vblank(video_vblank),
    .ce_pix(ce_pix),

    .dsw0(dsw0),
    .in0(in0),
    .in1(in1),
    .in2(in2),

    .sound_latch(cpu_sound_latch),
    .sound_latch_wr(cpu_sound_latch_wr),

    .rom0_cs_i(rom0_cs & idx0_wr),
    .rom1_cs_i(rom1_cs & idx0_wr),
    .rom2_cs_i(rom2_cs & idx0_wr),
    .rom3_cs_i(rom3_cs & idx0_wr),
    .rom4_cs_i(rom4_cs & idx0_wr),
    .rom5_cs_i(rom5_cs & idx0_wr),

    .blit0_cs_i(blit0_cs & idx2_wr),
    .blit1_cs_i(blit1_cs & idx2_wr),
    .blit2_cs_i(blit2_cs & idx2_wr),
    .blit3_cs_i(blit3_cs & idx2_wr),

    .ioctl_addr(ioctl_addr),
    .ioctl_data(ioctl_data),
    .ioctl_wr(ioctl_wr),

    .mcu_present(mcu_present),
    .mcurom_wr(idx6_wr),

    .pause(pause),

    .hs_address(hs_address),
    .hs_data_in(hs_data_in),
    .hs_data_out(hs_data_out),
    .hs_write(hs_write)
);

//------------------------------------------------------- Sound Board ---------------------------------------------------------//

wire signed [15:0] snd_mono;

Kangaroo_SND snd_board
(
    .reset(reset),
    .clk_10m(clk_10m),

    .sound_latch(cpu_sound_latch),
    .sound_latch_wr(cpu_sound_latch_wr),

    .vblank(video_vblank),

    .ioctl_addr(ioctl_addr),
    .ioctl_data(ioctl_data),
    .ioctl_wr(idx1_wr),
    .sndrom_cs_i(sndrom_cs),

    .sound_out(snd_mono),

    .pause(pause)
);

// Mono → stereo
assign sound_l = snd_mono;
assign sound_r = snd_mono;

//------------------------------------------------------ RGB Expansion --------------------------------------------------------//

// Expand BGR 3-bit (3R, 3G, 2B) to 8-bit per channel for MiSTer
// R: 3 bits → 8 bits (replicate)
// G: 3 bits → 8 bits (replicate)
// B: 2 bits → 8 bits (replicate)
assign video_r = {raw_r, raw_r, raw_r[2:1]};
assign video_g = {raw_g, raw_g, raw_g[2:1]};
assign video_b = {raw_b, raw_b, raw_b, raw_b};

endmodule
