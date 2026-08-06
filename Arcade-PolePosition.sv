//============================================================================
//  Arcade: Pole Position
//
//  Port to MiSTer
//  Copyright (C) 2017 Sorgelig
//
//  This program is free software; you can redistribute it and/or modify it
//  under the terms of the GNU General Public License as published by the Free
//  Software Foundation; either version 2 of the License, or (at your option)
//  any later version.
//
//  This program is distributed in the hope that it will be useful, but WITHOUT
//  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
//  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
//  more details.
//
//  You should have received a copy of the GNU General Public License along
//  with this program; if not, write to the Free Software Foundation, Inc.,
//  51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
//============================================================================

module emu
(
	//Master input clock
	input         CLK_50M,

	//Async reset from top-level module.
	//Can be used as initial reset.
	input         RESET,

	//Must be passed to hps_io module
	inout  [48:0] HPS_BUS,

	//Base video clock. Usually equals to CLK_SYS.
	output        CLK_VIDEO,

	//Multiple resolutions are supported using different CE_PIXEL rates.
	//Must be based on CLK_VIDEO
	output        CE_PIXEL,

	//Video aspect ratio for HDMI. Most retro systems have ratio 4:3.
	//if VIDEO_ARX[12] or VIDEO_ARY[12] is set then [11:0] contains scaled size instead of aspect ratio.
	output [12:0] VIDEO_ARX,
	output [12:0] VIDEO_ARY,

	output  [7:0] VGA_R,
	output  [7:0] VGA_G,
	output  [7:0] VGA_B,
	output        VGA_HS,
	output        VGA_VS,
	output        VGA_DE,    // = ~(VBlank | HBlank)
	output        VGA_F1,
	output [1:0]  VGA_SL,
	output        VGA_SCALER, // Force VGA scaler
	output	      VGA_DISABLE,

	input  [11:0] HDMI_WIDTH,
	input  [11:0] HDMI_HEIGHT,
	output        HDMI_FREEZE,
	output        HDMI_BLACKOUT,
	output        HDMI_BOB_DEINT,

`ifdef MISTER_FB
	// Use framebuffer in DDRAM (USE_FB=1 in qsf)
	// FB_FORMAT:
	//    [2:0] : 011=8bpp(palette) 100=16bpp 101=24bpp 110=32bpp
	//    [3]   : 0=16bits 565 1=16bits 1555
	//    [4]   : 0=RGB  1=BGR (for 16/24/32 modes)
	//
	// FB_STRIDE either 0 (rounded to 256 bytes) or multiple of pixel size (in bytes)
	output        FB_EN,
	output  [4:0] FB_FORMAT,
	output [11:0] FB_WIDTH,
	output [11:0] FB_HEIGHT,
	output [31:0] FB_BASE,
	output [13:0] FB_STRIDE,
	input         FB_VBL,
	input         FB_LL,
	output        FB_FORCE_BLANK,

`ifdef MISTER_FB_PALETTE
	// Palette control for 8bit modes.
	// Ignored for other video modes.
	output        FB_PAL_CLK,
	output  [7:0] FB_PAL_ADDR,
	output [23:0] FB_PAL_DOUT,
	input  [23:0] FB_PAL_DIN,
	output        FB_PAL_WR,
`endif
`endif

	output        LED_USER,  // 1 - ON, 0 - OFF.

	// b[1]: 0 - LED status is system status OR'd with b[0]
	//       1 - LED status is controled solely by b[0]
	// hint: supply 2'b00 to let the system control the LED.
	output  [1:0] LED_POWER,
	output  [1:0] LED_DISK,

	// I/O board button press simulation (active high)
	// b[1]: user button
	// b[0]: osd button
	output  [1:0] BUTTONS,

	input         CLK_AUDIO, // 24.576 MHz
	output [15:0] AUDIO_L,
	output [15:0] AUDIO_R,
	output        AUDIO_S,   // 1 - signed audio samples, 0 - unsigned
	output  [1:0] AUDIO_MIX, // 0 - no mix, 1 - 25%, 2 - 50%, 3 - 100% (mono)

	//ADC
	inout   [3:0] ADC_BUS,

	//SD-SPI
	output        SD_SCK,
	output        SD_MOSI,
	input         SD_MISO,
	output        SD_CS,
	input         SD_CD,

	//High latency DDR3 RAM interface
	//Use for non-critical time purposes
	output        DDRAM_CLK,
	input         DDRAM_BUSY,
	output  [7:0] DDRAM_BURSTCNT,
	output [28:0] DDRAM_ADDR,
	input  [63:0] DDRAM_DOUT,
	input         DDRAM_DOUT_READY,
	output        DDRAM_RD,
	output [63:0] DDRAM_DIN,
	output  [7:0] DDRAM_BE,
	output        DDRAM_WE,

	//SDRAM interface with lower latency
	output        SDRAM_CLK,
	output        SDRAM_CKE,
	output [12:0] SDRAM_A,
	output  [1:0] SDRAM_BA,
	inout  [15:0] SDRAM_DQ,
	output        SDRAM_DQML,
	output        SDRAM_DQMH,
	output        SDRAM_nCS,
	output        SDRAM_nCAS,
	output        SDRAM_nRAS,
	output        SDRAM_nWE,

`ifdef MISTER_DUAL_SDRAM
	//Secondary SDRAM
	//Set all output SDRAM_* signals to Z ASAP if SDRAM2_EN is 0
	input         SDRAM2_EN,
	output        SDRAM2_CLK,
	output [12:0] SDRAM2_A,
	output  [1:0] SDRAM2_BA,
	inout  [15:0] SDRAM2_DQ,
	output        SDRAM2_nCS,
	output        SDRAM2_nCAS,
	output        SDRAM2_nRAS,
	output        SDRAM2_nWE,
`endif

	input         UART_CTS,
	output        UART_RTS,
	input         UART_RXD,
	output        UART_TXD,
	output        UART_DTR,
	input         UART_DSR,

	// Open-drain User port.
	// 0 - D+/RX
	// 1 - D-/TX
	// 2..6 - USR2..USR6
	// Set USER_OUT to 1 to read from USER_IN.
	input   [6:0] USER_IN,
	output  [6:0] USER_OUT,

	input         OSD_STATUS
);

assign {SD_SCK, SD_MOSI, SD_CS} = 'Z;
assign {UART_RTS, UART_TXD, UART_DTR} = 0;
assign {SDRAM_DQ, SDRAM_A, SDRAM_BA, SDRAM_CLK, SDRAM_CKE, SDRAM_DQML, SDRAM_DQMH, SDRAM_nWE, SDRAM_nCAS, SDRAM_nRAS, SDRAM_nCS} = 'Z;

assign VGA_F1    = 0;
assign VGA_SCALER= 0;
assign USER_OUT  = '1;
assign LED_USER  = rom_download;
assign LED_DISK  = 0;
assign LED_POWER = 0;
assign BUTTONS   = 0;
assign AUDIO_MIX = 0;

assign FB_FORCE_BLANK = '0;
assign HDMI_FREEZE = 0;
assign HDMI_BLACKOUT = 0;
assign HDMI_BOB_DEINT = 0;
assign VGA_DISABLE = 0;

wire [1:0] ar = status[20:19];

// Pole Position is a HORIZONTAL (ROT0) game. Force landscape aspect; the portrait
// branch keyed on status[2] was inherited from the Xevious (ROT90) scaffold and
// removed. status[2] was reclaimed below for the watchdog defeat switch (wdog_en).
assign VIDEO_ARX = (!ar) ? 12'd2880 : (ar - 1'd1);
assign VIDEO_ARY = (!ar) ? 12'd2191 : 12'd0;

// Status Bit Map:
//              Upper                          Lower
// 0         1         2         3          4         5         6
// 01234567890123456789012345678901 23456789012345678901234567890123
// 0123456789ABCDEFGHIJKLMNOPQRSTUV 0123456789ABCDEFGHIJKLMNOPQRSTUV
// X XXXXX X XXX      XX   XXXXXXXX

`include "build_id.v"
localparam CONF_STR = {
	"Pole Position;;",
	"P1,Video Settings;",
	"P1-;",
	"P1OOR,CRT H-sync adjust,0,1,2,3,4,5,6,7,-8,-7,-6,-5,-4,-3,-2,-1;",
	"P1OSV,CRT V-sync adjust,0,1,2,3,4,5,6,7,-8,-7,-6,-5,-4,-3,-2,-1;",
	"P1O8,Flip Screen,Off,On;",
	"P1O35,Scandoubler Fx,None,HQ2x,CRT 25%,CRT 50%,CRT 75%;",
	"P1-;",
	"H0P1OJK,Aspect ratio,Original,Full Screen,[ARC1],[ARC2];",
	"DIP;",
	"-;",
	"H1OC,Autosave Hiscores,Off,On;",
	"P2,Pause options;",
	"P2OA,Pause when OSD is open,On,Off;",
	"P2OB,Dim video after 10s,On,Off;",
	"-;",
	"O2,Watchdog,On,Off;",
	"O6,Service Mode,Off,On;",
	"R0,Reset;",
	// 2026-08-05: 8-slot list, names + physical order copied from the MRA
	// <buttons> element so core and MRA agree (they did not: CONF_STR had 6
	// slots with Pause on joy[9], the MRA has 8 with Pause on joy[11]/L).
	// Accelerate/Brake are ANALOG on the real cabinet -- digital placeholders
	// for now (also on the D-pad); move to L2/R2 when analog input is wired.
	"J1,Accelerate,Brake,Gear,Not Used,Coin,Start 1P,Start 2P,Pause;",
	"jn,A,B,X,Y,Select,Start,R,L;",

	"V,v",`BUILD_DATE
};

reg [7:0] dsw[2];
always @(posedge clk_sys)
	if (ioctl_wr && (ioctl_index==254) && !ioctl_addr[24:1])
		dsw[ioctl_addr[0]] <= ~ioctl_dout;

////////////////////   CLOCKS   ///////////////////

wire clk_sys,clk_12,clk_24,clk_36,clk_48;
wire pll_locked;

pll pll
(
	.refclk(CLK_50M),
	.rst(0),
	.outclk_0(clk_sys),
	//.outclk_1(clk_48) removed — PLL is single-output (49.152 MHz); clk_48 tied to clk_sys below
	//.outclk_2(clk_12),
	//.outclk_3(clk_24),
	//.outclk_4(clk_36),
	.locked(pll_locked)
);

// clk_48 is a legacy scaffold name still used by the ce_pix divider + arcade_video
// (.clk_video). This core is a single 49.152 MHz domain, so tie clk_48 to clk_sys:
// clk_sys/8 = 49.152/8 = 6.144 MHz ce_pix = Pole Position's exact pixel clock.
assign clk_48 = clk_sys;

///////////////////////////////////////////////////

wire [31:0] status;
wire  [1:0] buttons;
wire [10:0] ps2_key;

wire        forced_scandoubler;
wire        direct_video;

wire        ioctl_download;
wire        ioctl_upload;
wire        ioctl_upload_req;
wire        ioctl_wr;
wire [24:0] ioctl_addr;
wire  [7:0] ioctl_dout;
wire  [7:0] ioctl_din;
wire  [7:0] ioctl_index;

wire [15:0] joystick_0, joystick_1;
wire [15:0] joy = joystick_0 | joystick_1;

wire [21:0] gamma_bus;

hps_io #(.CONF_STR(CONF_STR)) hps_io
(
	.clk_sys(clk_sys),
	.HPS_BUS(HPS_BUS),

	.buttons(buttons),
	.status(status),
	.status_menumask({~hs_configured,direct_video}),
	.forced_scandoubler(forced_scandoubler),
	.gamma_bus(gamma_bus),
	.direct_video(direct_video),

	.ioctl_upload(ioctl_upload),
	.ioctl_upload_req(ioctl_upload_req),
	.ioctl_download(ioctl_download),
	.ioctl_wr(ioctl_wr),
	.ioctl_addr(ioctl_addr),
	.ioctl_dout(ioctl_dout),
	.ioctl_din(ioctl_din),
	.ioctl_index(ioctl_index),

	.ps2_key(ps2_key),
	.joystick_0(joystick_0),
	.joystick_1(joystick_1)
);

wire key_start1, key_start2;
wire key_coin1, key_coin2, key_coin3, key_coin4;
wire key_reset, key_service;

wire key_p1_up, key_p1_left, key_p1_down, key_p1_right, key_p1_fire, key_p1_bomb;
wire key_p2_up, key_p2_left, key_p2_down, key_p2_right, key_p2_fire, key_p2_bomb;

wire pressed = ps2_key[9];
always @(posedge clk_sys) begin
	reg old_state;

	old_state <= ps2_key[10];
	if(old_state ^ ps2_key[10]) begin
		casex(ps2_key[8:0])
			'h016: key_start1   <= pressed; // 1
			'h01e: key_start2   <= pressed; // 2
			'h02E: key_coin1    <= pressed; // 5
			'h036: key_coin2    <= pressed; // 6
			'h004: key_reset    <= pressed; // F3
			'h046: key_service  <= pressed; // 9

			'hX75: key_p1_up    <= pressed; // up
			'hX6b: key_p1_left  <= pressed; // left
			'hX72: key_p1_down  <= pressed; // down
			'hX74: key_p1_right <= pressed; // right
			'h014: key_p1_fire  <= pressed; // lctrl
			'h011: key_p1_bomb  <= pressed; // lalt

			'h02d: key_p2_up    <= pressed; // r
			'h023: key_p2_left  <= pressed; // d
			'h02b: key_p2_down  <= pressed; // f
			'h034: key_p2_right <= pressed; // g
			'h01c: key_p2_fire  <= pressed; // a
			'h01b: key_p2_bomb  <= pressed; // s
		endcase
	end
end


wire m_start1 = joystick_0[9] | key_start1;                    // MRA slot 6 'Start 1P'
wire m_coin1  = joystick_0[8] | key_coin1;
wire m_up1    = joystick_0[3] | key_p1_up;
wire m_down1  = joystick_0[2] | key_p1_down;
wire m_left1  = joystick_0[1] | key_p1_left;
wire m_right1 = joystick_0[0] | key_p1_right;
wire m_fire1  = joystick_0[4] | key_p1_fire;
wire m_bomb1  = joystick_0[6] | key_p1_bomb;                   // MRA slot 3 'Gear' (-> dip_switch_b bit0)

wire m_start2 = joystick_1[9] | joystick_0[10] | key_start2;   // MRA slot 7 'Start 2P'
wire m_coin2  = joystick_1[8] | key_coin2;
wire m_up2    = joystick_1[3] | key_p2_up;
wire m_down2  = joystick_1[2] | key_p2_down;
wire m_left2  = joystick_1[1] | key_p2_left;
wire m_right2 = joystick_1[0] | key_p2_right;
wire m_fire2  = joystick_1[4] | key_p2_fire;
wire m_bomb2  = joystick_1[6] | key_p2_bomb;                   // MRA slot 3 'Gear' (-> dip_switch_b bit4)

// PAUSE-BIT-FIX-2026-08-05: was joy[9], which is the MRA's 6th button name
// ("Start"), so START paused the game and the L shoulder did nothing.
// MRA <buttons> names map to joy[4] upward in order, so with
//   names="-,Gear,Start,Start 2,Coin,-,Pause"  ->  Pause is the 7th = joy[10],
// which defaults to "L" (left shoulder) per the MRA's default= list.
wire m_pause  = joy[11];                                       // MRA slot 8 'Pause' = L


// PAUSE SYSTEM
wire				pause_cpu;
pause #(4,4,4,12) pause (
	.*,
	.user_button(m_pause),
	.pause_request(hs_pause),
	.options(~status[11:10])
);

wire hblank, vblank;
wire ce_vid;
wire hs, vs;
wire rde, rhs, rvs;
wire [3:0] r,g,b;
wire [11:0] rgb_out;

// The core emits pixels on its OWN enable (ce_vid = poleposition.video_en =
// ena_vidgen, the gen_video/renderer pixel-slot machine). arcade_video MUST sample
// on that same enable — an independent free-running clk/8 sampler disagrees with the
// slot machine's non-uniform cadence and double-taps/drops pixels ("2x fat / half
// char"). ce_vid was declared+driven but left orphaned; wire it straight through.
wire ce_pix = ce_vid;

wire flip_screen = status[8];
wire rotate_ccw = flip_screen;
// Pole Position is horizontal (ROT0) — never rotate the framebuffer. The Xevious
// scaffold defaulted to Vert (status[2]=0 -> rotated); that toggle is now removed.
wire no_rotate = 1'b1;
wire video_rotated;
wire flip = 0;

screen_rotate screen_rotate (.*);

arcade_video #(288,12) arcade_video
(
	.*,

	.clk_video(clk_48),
	.RGB_in(rgb_out),
	.HBlank(hblank),
	.VBlank(vblank),
	.HSync(hs),
	.VSync(vs),

	.fx(status[5:3])
);

wire [15:0] audio;
assign AUDIO_L = audio;
assign AUDIO_R = AUDIO_L;
// `audio` is the Namco WSG mixer's signed two's-complement sum (namco_wsg8.sv,
// MAME namco.cpp mixing math) -- was 0 (arbitrary) while audio was tied off.
assign AUDIO_S = 1;

wire service, service_r, service_trigger;
always @(posedge clk_sys) begin
	service <= status[6];
	service_r <= service;
	service_trigger <= service & !service_r;
end

wire rom_download = ioctl_download & !ioctl_index;
// Per vault Common-Pitfalls/"Core reset must include ioctl_download": hold the core
// in reset for the WHOLE multi-index PP download (ioctl_download, not just index-0
// rom_download), + ~pll_locked as the next-line cold-boot defense.
wire reset = RESET | status[0] | buttons[1] | ioctl_download | ~pll_locked | service_trigger | key_reset;

// Watchdog defeat switch (rtl/pp_watchdog.sv wdog_en, MAME polepos.cpp:925
// set_vblank_count(...,16)). status[2]=0 (default) -> watchdog ON, matching MAME;
// status[2]=1 -> OFF. See "O2,Watchdog,On,Off;" above and pp_watchdog.sv header
// for why a one-place defeat switch exists (self-test hang -> ~4Hz reboot loop
// with the watchdog live, which is useful signal but hampers on-screen diagnosis).
wire wdog_en = ~status[2];

// INCR-1a (DIAG-REVERT-2026-07-13): chars (alpha) gfx ROM. MAME polepos "chars" =
// ioctl INDEX 1, offset 0x0000, 0x1000 bytes (pp3_28.1f, crc 2e77187e). ioctl write
// gate per vault: index==1 & addr<0x1000; write addr region-relative (ioctl_addr
// resets to 0 at each index). Sync 1-clk read feeds the alpha renderer's gfx port.
wire [11:0] chars_gfx_addr;
reg  [7:0]  chars_gfx_data;
reg  [7:0]  chars_rom [0:4095];
wire        chars_wr = ioctl_wr & (ioctl_index == 8'd1) & (ioctl_addr < 25'h1000);
always @(posedge clk_sys) begin
	if (chars_wr) chars_rom[ioctl_addr[11:0]] <= ioctl_dout;
	chars_gfx_data <= chars_rom[chars_gfx_addr];
end

// TILES (view/bg) gfx ROM — ioctl INDEX 1, offset 0x1000-0x1FFF (sibling of the
// chars ROM above; idx1 = chars@0x000 then tiles@0x1000). ioctl_addr[11:0] maps
// 0x1000->0 within the region. Sync 1-clk read feeds the view renderer. 2026-07-18.
wire [11:0] tiles_gfx_addr;
reg  [7:0]  tiles_gfx_data;
reg  [7:0]  tiles_rom [0:4095];
wire        tiles_wr = ioctl_wr & (ioctl_index == 8'd1) & (ioctl_addr >= 25'h1000) & (ioctl_addr < 25'h2000);
always @(posedge clk_sys) begin
	if (tiles_wr) tiles_rom[ioctl_addr[11:0]] <= ioctl_dout;
	tiles_gfx_data <= tiles_rom[tiles_gfx_addr];
end

// RESTORED-2026-07-28: STARTUP-STRIP-2026-07-27 had these commented out
// (105KB combined, dead weight while pp_road_gen/pp_sprite_gen were disabled
// in pp_video_composite.sv). Restored alongside re-enabling those generators.
wire [14:0] road_rom_addr;
reg  [7:0]  road_rom_data;
reg  [7:0]  road_rom [0:20479];    // 0x5000
wire        road_wr = ioctl_wr & (ioctl_index == 8'd1) & (ioctl_addr >= 25'h14000) & (ioctl_addr < 25'h19000);
always @(posedge clk_sys) begin
	if (road_wr) road_rom[ioctl_addr - 25'h14000] <= ioctl_dout;
	road_rom_data <= road_rom[road_rom_addr];
end

wire [11:0] scalelut_addr;
reg  [7:0]  scalelut_data;
reg  [7:0]  scalelut_rom [0:4095];
wire        scalelut_wr = ioctl_wr & (ioctl_index == 8'd1) & (ioctl_addr >= 25'h19000) & (ioctl_addr < 25'h1A000);
always @(posedge clk_sys) begin
	if (scalelut_wr) scalelut_rom[ioctl_addr[11:0]] <= ioctl_dout;
	scalelut_data <= scalelut_rom[scalelut_addr];
end

wire [16:0] sprgfx_addr;
reg  [7:0]  sprgfx_data;
reg  [7:0]  sprite_rom [0:81919];  // 0x14000
wire        sprite_wr = ioctl_wr & (ioctl_index == 8'd1) & (ioctl_addr >= 25'h2000) & (ioctl_addr < 25'h14000);
always @(posedge clk_sys) begin
	if (sprite_wr) sprite_rom[ioctl_addr - 25'h2000] <= ioctl_dout;
	sprgfx_data <= sprite_rom[sprgfx_addr];
end

// Palette PROMs — ioctl INDEX 2, offset 0x000-0xFFF (R@0x000 G@0x100 B@0x200
// alpha@0x300 view@0x400 vpos-mod@0x500/600/700 road@0x800 sprite@0xC00). Each
// palette/generator decodes prom_addr[11:8] or [11:10]. Region-relative addr.
wire        pp_prom_wr   = ioctl_wr & (ioctl_index == 8'd2) & (ioctl_addr < 25'h1000);
wire [11:0] pp_prom_addr = ioctl_addr[11:0];
wire [7:0]  pp_prom_data = ioctl_dout;

// Namco WSG waveform PROM — ioctl INDEX 2, region-relative 0x1040-0x113F (256
// bytes, right after the 0x1040-byte "proms" block; MAME polepos "namco"
// region, pp1-5.3b crc 8568decc; 8 waveforms x 32 4-bit samples). 0x1040 isn't
// power-of-2-aligned, so the relative address needs an actual subtract (NOT a
// plain bit-slice like pp_prom_addr above) — 8-bit unsigned wraparound still
// gives the correct 0-255 result across the bit-8 boundary inside the region
// (modular arithmetic: (A-B) mod 256 only depends on A,B mod 256).
wire        wsg_prom_wr   = ioctl_wr & (ioctl_index == 8'd2) & (ioctl_addr >= 25'h1040) & (ioctl_addr < 25'h1140);
wire [7:0]  wsg_prom_addr = ioctl_addr[7:0] - 8'h40;
wire [7:0]  wsg_prom_data = ioctl_dout;

// STEP-3b-2: Namco 5xxx MCU internal ROMs — ioctl INDEX 6, region-relative
// (resets to 0 at this index): 51xx.bin@0x000 53xx.bin@0x400 54xx.bin@0x800
// 52xx.bin@0xC00, each 0x400 (2026-07-28: extended 0xC00-0xFFF to cover 52xx once
// its firmware was sourced -- was previously excluded, gate stopped at 0xC00).
// poleposition.vhd decodes addr[11:10] internally per-wrapper (namco_51xx.sv
// claims 00, namco_53xx.sv claims 01, namco_54xx.sv claims 10, namco_52xx.sv
// claims 11).
wire        mcu_rom_wr   = ioctl_wr & (ioctl_index == 8'd6) & (ioctl_addr < 25'h1000);
wire [11:0] mcu_rom_addr = ioctl_addr[11:0];
wire [7:0]  mcu_rom_data = ioctl_dout;

// namco_52xx sample ("voice") ROM — ioctl INDEX 5, region-relative 0x4000-0xBFFF
// (0x8000 bytes; the "engine" slice 0x0000-0x3FFF is a separate unbuilt device,
// not loaded here -- see PolePosition_CPU.sv's engine_* TODO). 2026-07-28.
wire [14:0] sample52_addr;
reg  [7:0]  sample52_data;
reg  [7:0]  sample52_rom [0:32767]; // 0x8000
wire        sample52_wr = ioctl_wr & (ioctl_index == 8'd5) & (ioctl_addr >= 25'h4000) & (ioctl_addr < 25'hC000);
always @(posedge clk_sys) begin
	if (sample52_wr) sample52_rom[ioctl_addr - 25'h4000] <= ioctl_dout;
	sample52_data <= sample52_rom[sample52_addr];
end

// Steering (MAME "STEER" IPT_DIAL) — no real spinner/analog input is wired at
// this top level yet (#unverified / KNOWN ITERATION POINT). Placeholder: a
// digital up/down counter driven by m_left1/m_right1 (both otherwise DEAD in
// this Namco scaffold's entity, per poleposition.vhd's gutted CPU section) so
// the 53xx's steering_changed/delta logic has SOMETHING to react to for a
// first HW bring-up. Swap for a real spinner/paddle mapping later.
reg [15:0] steer_div;
reg  [7:0] steer_pos = 8'h80;
always @(posedge clk_sys) begin
	steer_div <= steer_div + 1'b1;
	if (steer_div == 16'd0) begin  // clk_sys(49.152MHz)/65536 ~= 750 Hz update rate
		if (m_left1  & ~m_right1) steer_pos <= steer_pos - 1'b1;
		if (m_right1 & ~m_left1)  steer_pos <= steer_pos + 1'b1;
	end
end

// ADC0804 accelerator/brake pedal inputs (rtl/adc0804.sv via poleposition.vhd's
// accel_in/brake_in ports) — DIGITAL PLACEHOLDER, no real analog/pedal input is
// wired at this top level yet (#unverified / KNOWN ITERATION POINT, same status
// as steer_pos above). up1/down1 double as full-on/off accel/brake so the ADC
// path has SOMETHING to convert for first HW bring-up; m_fire1 is reserved for
// the Gear Change input (IN0 bit1, see poleposition.vhd in0_byte), which is why
// up/down were chosen here instead. Full scale is 0x90, NOT 0xFF, per MAME
// PORT_MINMAX(0,0x90) on both ACCEL and BRAKE. Swap for real pedal mapping later.
// Accept the MRA's Accelerate/Brake buttons (slots 1/2 = A/B) as well as the
// existing D-pad placeholder. Both are digital until analog input is wired.
wire m_accel1 = m_up1   | joystick_0[4];
wire m_brake1 = m_down1 | joystick_0[5];
wire [7:0] pp_accel = m_accel1 ? 8'h90 : 8'h00;
wire [7:0] pp_brake = m_brake1 ? 8'h90 : 8'h00;

poleposition poleposition
(
	.clock_18(clk_sys),
	.reset(reset),
	.wdog_en(wdog_en),

	.dn_addr(ioctl_addr[16:0]),
	.dn_data(ioctl_dout),
	.dn_wr(ioctl_wr & rom_download),

	.gfx_addr(chars_gfx_addr),
	.gfx_data(chars_gfx_data),

	.view_gfx_addr(tiles_gfx_addr),
	.view_gfx_data(tiles_gfx_data),

	.road_rom_addr(road_rom_addr),
	.road_rom_data(road_rom_data),
	.scalelut_addr(scalelut_addr),
	.scalelut_data(scalelut_data),
	.sprgfx_addr(sprgfx_addr),
	.sprgfx_data(sprgfx_data),

	.sample52_addr(sample52_addr),
	.sample52_data(sample52_data),

	.prom_wr(pp_prom_wr),
	.prom_addr(pp_prom_addr),
	.prom_data(pp_prom_data),

	.wsg_prom_wr(wsg_prom_wr),
	.wsg_prom_addr(wsg_prom_addr),
	.wsg_prom_data(wsg_prom_data),

	.video_r(r),
	.video_g(g),
	.video_b(b),
	.video_en(ce_vid),
	.video_hs(hs),
	.video_vs(vs),
	.blank_h(hblank),
	.blank_v(vblank),

	.flip(flip_screen),
	.h_offset(status[27:24]),
	.v_offset(status[31:28]),

	.audio(audio),

	.self_test(status[6]),

	.service(key_service),
	.coin1(m_coin1),
	.coin2(m_coin2),
	.start1(m_start1),
	.start2(m_start2),
	.up1(m_up1),
	.down1(m_down1),
	.left1(m_left1),
	.right1(m_right1),
	.fire1(m_fire1),
	.up2(m_up2),
	.down2(m_down2),
	.left2(m_left2),
	.right2(m_right2),
	.fire2(m_fire2),

	.dip_switch_a(dsw[0]),
	.dip_switch_b({dsw[1][7:5], ~m_bomb2, dsw[1][3:1], ~m_bomb1}),

	.pause(pause_cpu),

	.steer_in(steer_pos),
	.mcu_rom_wr(mcu_rom_wr),
	.mcu_rom_addr(mcu_rom_addr),
	.mcu_rom_data(mcu_rom_data),

	.accel_in(pp_accel),
	.brake_in(pp_brake),

	.hs_address(hs_address),
	.hs_data_out(hs_data_out),
	.hs_data_in(hs_data_in),
	.hs_write(hs_write_enable)
);


// HISCORE SYSTEM
// --------------

wire [11:0]hs_address;
wire [7:0] hs_data_in;
wire [7:0] hs_data_out;
wire hs_write_enable;
wire hs_pause;
wire hs_configured;

hiscore #(
	.HS_ADDRESSWIDTH(11),
	.CFG_ADDRESSWIDTH(2),		// 2 entries max (zaxxon/szaxxon)
	.CFG_LENGTHWIDTH(2)
) hi (
	.*,
	.clk(clk_sys),
	.paused(pause_cpu),
	.autosave(status[12]),
	.ram_address(hs_address),
	.data_from_ram(hs_data_out),
	.data_to_ram(hs_data_in),
	.data_from_hps(ioctl_dout),
	.data_to_hps(ioctl_din),
	.ram_write(hs_write_enable),
	.ram_intent_read(),
	.ram_intent_write(),
	.pause_cpu(hs_pause),
	.configured(hs_configured)
);

endmodule
