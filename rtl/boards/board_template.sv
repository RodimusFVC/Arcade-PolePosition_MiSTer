//============================================================================
//  board_template.sv - Pole Position board template (NOT in files.qip, never compiled).
//  Copyright (C) 2026 Rodimus
//
//  Boards never instantiate a CPU, sound chip, ROM store or board RAM. Drive the pool ports. Copy this file to start a board.
//  Pools: rtl/polepos_dispatcher.sv (chip_pool_pkg slots, Shared ROM blocks, Shared RAM pool rpool).
//  Boards go in rtl/boards/<board>/; add the board's instance and bus muxes in the dispatcher.
//  CRT Flip is mandatory: flip mirrors the picture 180 degrees inside the board (HDMI follows).
//============================================================================

module board_template
(
    input  logic        clk,
    input  logic        reset,
    input  logic        pause,

    input  logic  [7:0] steer_in,
    input  logic  [7:0] accel_in,
    input  logic  [7:0] brake_in,
    input  logic  [7:0] dip_switch_a,
    input  logic  [7:0] dip_switch_b,

    output logic [13:0] prog_rom_a,
    input  logic  [7:0] prog_rom_d,
    output logic [13:0] sub1_rom_a,
    input  logic [15:0] sub1_rom_d,
    output logic [13:0] sub2_rom_a,
    input  logic [15:0] sub2_rom_d,
    output logic [12:0] gfx_addr,
    input  logic  [7:0] gfx_data,
    output logic [12:0] view_gfx_addr,
    input  logic  [7:0] view_gfx_data,
    output logic [14:0] road_rom_addr,
    input  logic  [7:0] road_rom_data,
    output logic [11:0] scalelut_addr,
    input  logic  [7:0] scalelut_data,
    output logic [16:0] sprgfx_addr,
    input  logic  [7:0] sprgfx_data,
    output logic [14:0] sample52_addr,
    input  logic  [7:0] sample52_data,
    output logic [13:0] engine_addr,
    input  logic  [7:0] engine_data,

    input  logic        flip,
    output logic  [3:0] video_r,
    output logic  [3:0] video_g,
    output logic  [3:0] video_b,
    output logic        video_hs,
    output logic        video_vs,
    output logic        video_en,
    output logic        blank_h,
    output logic        blank_v,

    output logic [15:0] audio,

    input  logic [10:0] hs_address,
    output logic  [7:0] hs_data_out,
    input  logic  [7:0] hs_data_in,
    input  logic        hs_write,

    output chip_pool_pkg::z80r_i_t       z80r_0_i,
    input  chip_pool_pkg::z80r_o_t       z80r_0_o,
    output chip_pool_pkg::z80r_i_t       z80r_1_i,
    input  chip_pool_pkg::z80r_o_t       z80r_1_o,
    output chip_pool_pkg::z8002_i_t      z8002_0_i,
    input  chip_pool_pkg::z8002_o_t      z8002_0_o,
    output chip_pool_pkg::z8002_i_t      z8002_1_i,
    input  chip_pool_pkg::z8002_o_t      z8002_1_o,
    output chip_pool_pkg::namco_06xx_i_t namco_06xx_0_i,
    input  chip_pool_pkg::namco_06xx_o_t namco_06xx_0_o,
    output chip_pool_pkg::namco_51xx_i_t namco_51xx_0_i,
    input  chip_pool_pkg::namco_51xx_o_t namco_51xx_0_o,
    output chip_pool_pkg::namco_52xx_i_t namco_52xx_0_i,
    input  chip_pool_pkg::namco_52xx_o_t namco_52xx_0_o,
    output chip_pool_pkg::namco_53xx_i_t namco_53xx_0_i,
    input  chip_pool_pkg::namco_53xx_o_t namco_53xx_0_o,
    output chip_pool_pkg::namco_54xx_i_t namco_54xx_0_i,
    input  chip_pool_pkg::namco_54xx_o_t namco_54xx_0_o,
    output chip_pool_pkg::namco_54xx_snd_i_t namco_54xx_snd_0_i,
    input  chip_pool_pkg::namco_54xx_snd_o_t namco_54xx_snd_0_o,

    output chip_pool_pkg::namco_wsg8_i_t  namco_wsg8_0_i,
    input  chip_pool_pkg::namco_wsg8_o_t  namco_wsg8_0_o,
    output chip_pool_pkg::adc0804_i_t     adc0804_0_i,
    input  chip_pool_pkg::adc0804_o_t     adc0804_0_o,
    output chip_pool_pkg::tms5220rsws_i_t tms5220rsws_0_i,
    input  chip_pool_pkg::tms5220rsws_o_t tms5220rsws_0_o,

    output ram_pool_pkg::pram_i_t [10:0] pr_i,
    input  ram_pool_pkg::pram_o_t [10:0] pr_o
);

assign prog_rom_a     = '0;
assign sub1_rom_a     = '0;
assign sub2_rom_a     = '0;
assign gfx_addr       = '0;
assign view_gfx_addr  = '0;
assign road_rom_addr  = '0;
assign scalelut_addr  = '0;
assign sprgfx_addr    = '0;
assign sample52_addr  = '0;
assign engine_addr    = '0;
assign video_r        = 4'd0;
assign video_g        = 4'd0;
assign video_b        = 4'd0;
assign video_hs       = 1'b0;
assign video_vs       = 1'b0;
assign video_en       = 1'b0;
assign blank_h        = 1'b1;
assign blank_v        = 1'b1;
assign audio          = 16'd0;
assign hs_data_out    = 8'd0;
assign z80r_0_i       = '0;
assign z80r_1_i       = '0;
assign z8002_0_i      = '0;
assign z8002_1_i      = '0;
assign namco_06xx_0_i = '0;
assign namco_51xx_0_i = '0;
assign namco_52xx_0_i = '0;
assign namco_53xx_0_i = '0;
assign namco_54xx_0_i = '0;
assign namco_54xx_snd_0_i = '0;
assign namco_wsg8_0_i.reset    = 1'b1;
assign namco_wsg8_0_i.sound_en = 1'b0;
assign namco_wsg8_0_i.reg_addr = '0;
assign namco_wsg8_0_i.reg_din  = '0;
assign namco_wsg8_0_i.reg_wr   = 1'b0;
assign adc0804_0_i.reset       = 1'b1;
assign adc0804_0_i.wr          = 1'b0;
assign adc0804_0_i.rd          = 1'b0;
assign adc0804_0_i.vin         = '0;
assign tms5220rsws_0_i      = '{rs_n: 1'b1, ws_n: 1'b1, default: '0};
assign pr_i           = '0;

endmodule
