//============================================================================
//
// Kangaroo for MiSTer
// Copyright (C) 2026 Rodimus
// Based on Tutankham core structure
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation
//  the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
//  DEALINGS IN THE SOFTWARE.
//
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
	output        VGA_DISABLE, // analog out is off

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

assign ADC_BUS  = 'Z;
assign USER_OUT = '1;
assign {UART_RTS, UART_TXD, UART_DTR} = 0;
assign {SD_SCK, SD_MOSI, SD_CS} = 'Z;
assign {SDRAM_DQ, SDRAM_A, SDRAM_BA, SDRAM_CLK, SDRAM_CKE, SDRAM_DQML, SDRAM_DQMH, SDRAM_nWE, SDRAM_nCAS, SDRAM_nRAS, SDRAM_nCS} = 'Z;

assign VGA_F1 = 0;
assign VGA_SCALER = 0;
assign VGA_DISABLE = 0;
assign FB_FORCE_BLANK = 0;
assign HDMI_FREEZE = 0;
assign HDMI_BLACKOUT = 0;
assign HDMI_BOB_DEINT = 0;

wire signed [15:0] audio_l, audio_r;
assign AUDIO_L = pause_cpu ? 16'd0 : audio_l;
assign AUDIO_R = pause_cpu ? 16'd0 : audio_r;
assign AUDIO_S = 1;   // signed
assign AUDIO_MIX = 0; // no mix, true stereo

assign LED_DISK  = 0;
assign LED_POWER = 0;
assign LED_USER  = ioctl_download;
assign BUTTONS = 0;

///////////////////////////////////////////////////

wire [1:0] ar = status[14:13];

assign VIDEO_ARX = status[12] ? ((!ar) ? 12'd4 : (ar - 1'd1)) : ((!ar) ? 12'd3 : (ar - 1'd1));
assign VIDEO_ARY = status[12] ? ((!ar) ? 12'd3 : 12'd0) : ((!ar) ? 12'd4 : 12'd0);

`include "build_id.v"
localparam CONF_STR = {
	"KANGAROO;;",
	"ODE,Aspect Ratio,Original,Full screen,[ARC1],[ARC2];",
	"OC,Orientation,Vert,Horz;",
	"OB,Flip Vertical,Off,On;",
	"OFH,Scandoubler Fx,None,HQ2x,CRT 25%,CRT 50%,CRT 75%;",
	"-;",
	"P1,Pause Options;",
	"P1OP,Pause when OSD is open,On,Off;",
	"P1OQ,Dim video after 10s,On,Off;",
	"-;",
	"P2,High Score Options;",
	"P2OR,Autosave Hiscores,Off,On;",
	"-;",
	"DIP;",
	"-;",
	"R0,Reset;",
	"J1,Button1,Button2,Coin,Start 1P,Start 2P,Pause;",
	"jn,A,B,Select,Start,R,L;",
	"V,v",`BUILD_DATE
};

wire        forced_scandoubler;
wire  [1:0] buttons;
wire [31:0] status;
wire [10:0] ps2_key;

wire        ioctl_download;
wire        ioctl_upload;
wire        ioctl_upload_req;
wire  [7:0] ioctl_index;
wire        ioctl_wr;
wire [24:0] ioctl_addr;
wire  [7:0] ioctl_dout;
wire  [7:0] ioctl_din;

wire [15:0] joystick_0, joystick_1;
wire [15:0] joy = joystick_0 | joystick_1;

wire [21:0] gamma_bus;
wire        direct_video;

hps_io #(.CONF_STR(CONF_STR)) hps_io
(
	.clk_sys(CLK_10M),
	.HPS_BUS(HPS_BUS),
	.EXT_BUS(),
	.gamma_bus(gamma_bus),
	.direct_video(direct_video),
	.video_rotated(video_rotated),

	.forced_scandoubler(forced_scandoubler),

	.buttons(buttons),
	.status(status),
	.status_menumask({direct_video}),

	.ioctl_download(ioctl_download),
	.ioctl_upload(ioctl_upload),
	.ioctl_upload_req(ioctl_upload_req),
	.ioctl_wr(ioctl_wr),
	.ioctl_addr(ioctl_addr),
	.ioctl_dout(ioctl_dout),
	.ioctl_din(ioctl_din),
	.ioctl_index(ioctl_index),

	.joystick_0(joystick_0),
	.joystick_1(joystick_1),
	.ps2_key(ps2_key)
);

////////////////////   CLOCKS   ///////////////////
wire CLK_40M;
wire CLK_10M;
wire locked;

pll pll
(
    .refclk(CLK_50M),
    .rst(0),
    .outclk_0(CLK_40M),
    .outclk_1(CLK_10M),
    .locked(locked)
);

assign CLK_VIDEO = CLK_40M;   // HDMI needs the 40 MHz reference

wire reset = RESET | status[0] | buttons[1] | ioctl_download;

///////////////////         Keyboard           //////////////////

reg btn_up       = 0;
reg btn_down     = 0;
reg btn_left     = 0;
reg btn_right    = 0;
reg btn_fire     = 0;
reg btn_fire2    = 0;
reg btn_coin1    = 0;
reg btn_coin2    = 0;
reg btn_1p_start = 0;
reg btn_2p_start = 0;
reg btn_pause    = 0;
reg btn_service  = 0;

wire pressed = ~ps2_key[9];
wire [7:0] code = ps2_key[7:0];
always @(posedge CLK_10M) begin
	reg old_state;
	old_state <= ps2_key[10];
	if(old_state != ps2_key[10]) begin
		case(code)
			'h16: btn_1p_start <= pressed; // 1 = Player 1 Start
			'h1E: btn_2p_start <= pressed; // 2 = Player 2 Start
			'h2E: btn_coin1    <= pressed; // 5 = Coin Input 1
			'h36: btn_coin2    <= pressed; // 6 = Coin Input 2
			'h4D: btn_pause    <= pressed; // P = Pause
			'h46: btn_service  <= pressed; // 9 = Test Advance

			'h75: btn_up       <= pressed; // up         = Up
			'h72: btn_down     <= pressed; // down       = Down
			'h6B: btn_left     <= pressed; // left       = Left
			'h74: btn_right    <= pressed; // right      = Right
			'h14: btn_fire     <= pressed; // ctrl       = Draw Slow
			'h12: btn_fire2    <= pressed; // left shift = Draw Fast
		endcase 
	end
end

//////////////////  Game select (mod byte, MRA <rom index="5">)  ///////////////////////////
// GAMESEL-2026-06-21: MRA `<rom index="5"><part>01</part></rom>` => Funky Fish; absent => Kangaroo (mod=0).
// Cleared at each download start so Kangaroo MRAs (no index-5 byte) read mod=0 with NO MRA edits.
// (index 1 = sound ROM, index 4 = NVRAM — both taken; 5 is free.)
reg  [7:0] core_mod = 8'd0;
// GAMESEL-FIX-2026-06-21: dropped the download-start reset — it cleared core_mod when the index-4 NVRAM load
// (a separate ioctl_download transaction) re-raised ioctl_download AFTER the mod byte was captured. Now mirrors
// the proven Kyugo pattern (Arcade-Kyugo.sv:494 — simple capture, no reset). Original below:
// reg ioctl_download_d = 1'b0;
// always @(posedge CLK_10M) begin
//     ioctl_download_d <= ioctl_download;
//     if (ioctl_download & ~ioctl_download_d)    core_mod <= 8'd0;       // download start
//     else if (ioctl_wr & (ioctl_index == 8'd5)) core_mod <= ioctl_dout;
// end
always @(posedge CLK_10M)
	if (ioctl_wr & (ioctl_index == 8'd5))
		core_mod <= ioctl_dout;
wire is_funkyfish = (core_mod == 8'd1);
// MCU-2026-06-22: index-5 bit1 = MB8841 fitted (original kangaroo/kangarooa MRAs set 0x02). Bootleg & Funky
// Fish leave it clear -> mcu_present=0 -> boot-pulse NMI path (unchanged). is_funkyfish stays an == 0x01 test.
wire mcu_present = core_mod[1];

//////////////////  Arcade Buttons/Interfaces   ///////////////////////////

//Player 1
// GAMESEL-2026-06-21: joystick_0[4] (Button1 / "Bubbles") is the KANGAROO jump-assist hack — for Funky Fish
// it becomes the 2nd game button (IN1 bit 0x20) instead, so drop it from UP there.
// Original: wire m_up1 = btn_up | joystick_0[3] | joystick_0[4];
wire m_up1      = btn_up        | joystick_0[3]  | (is_funkyfish ? 1'b0 : joystick_0[4]);
wire m_down1    = btn_down      | joystick_0[2];
wire m_left1    = btn_left      | joystick_0[1];
wire m_right1   = btn_right     | joystick_0[0];
wire m_punch_p1 = btn_fire      | joystick_0[5];

//Player 2
wire m_up2      = btn_up		| joystick_1[3]  | (is_funkyfish ? 1'b0 : joystick_1[4]);
wire m_down2    = btn_down      | joystick_1[2];
wire m_left2    = btn_left      | joystick_1[1];
wire m_right2   = btn_right     | joystick_1[0];
wire m_punch_p2 = btn_fire      | joystick_1[5];

//Start/Coin
wire m_start1   = btn_1p_start  | joystick_0[7];
wire m_start2   = btn_2p_start  | joystick_0[8];
wire m_coin1    = btn_coin1     | joystick_0[6];
wire m_coin2    = btn_coin2     | joystick_1[6];
wire m_pause    = btn_pause     | joystick_0[9];

//Service Mode
wire m_service  = btn_service                  ;

// PAUSE SYSTEM
wire pause_cpu;
wire [23:0] rgb_out;
pause #(8,8,8,10) pause
(
	.*,
	.clk_sys(CLK_10M),
	.user_button(m_pause),
	.pause_request(hs_pause),
	.options(~status[26:25])
);

///////////////                 Video                  ////////////////

wire hblank, vblank;
wire hs, vs;
wire [7:0] r, g, b;
wire ce_pix;

// DIAG-2026-06-18: 2x pixel clock for "double the size then reduce". arcade_video now renders 512 px/line
// (each of the 256 source columns doubled -> MAME-style dimmed-copy interleave); screen_rotate + the
// scaler then shrink the 512-wide framebuffer back to the display ("reduce the resolution/size").
// ce_pix MUST be a CLK_40M-domain pulse: the core's 5 MHz ce_pix lives in the 10 MHz domain and can't be
// cleanly doubled there. Phase (==2) samples mid-period after the core's RGB settles; if pixels shimmer
// or smear horizontally, try ==1 or ==3. To revert: arcade_video back to #(256,24) and drop .ce_pix below.
reg [1:0] ce_pix_div = 2'd0;
always @(posedge CLK_40M) ce_pix_div <= ce_pix_div + 1'd1;
wire ce_pix_2x = (ce_pix_div == 2'd2);   // 10 MHz, 1-in-4 of CLK_40M

wire rotate_ccw = 0;  // Kangaroo is ROT90 (CW)
wire no_rotate = status[12] | direct_video;
wire flip = status[11] | ~no_rotate;
screen_rotate screen_rotate(.*);

arcade_video #(512,24) arcade_video   // DIAG-2026-06-18: was #(256,24) — 512 px/line (256 cols doubled), scaler reduces
(
	.*,

	.clk_video(CLK_40M),
	.ce_pix(ce_pix_2x),   // DIAG-2026-06-18: 10 MHz (overrides the core's 5 MHz ce_pix that .* would pick)

	.RGB_in(rgb_out),
	.HBlank(hblank),
	.VBlank(vblank),
	.HSync(hs),
	.VSync(vs),

	.fx(status[17:15])
);

// DIP switch
// DIP-FIX-2026-06-21: DIPs arrive from the OSD via ioctl index 254 (standard MiSTer DIP download), NOT status.
// Was `sw0 = status[7:0]` — a placeholder that never received the OSD DIP edits → "always 3 lives". Mirrors
// Kyugo (Arcade-Kyugo.sv:487). The MRA <switches default=..> is downloaded here; sw0 = DSW0 (read at 0xe400).
reg [7:0] dip_sw[8] = '{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00};
always @(posedge CLK_10M) begin
	if (ioctl_wr && (ioctl_index == 8'd254) && !ioctl_addr[24:3])
		dip_sw[ioctl_addr[2:0]] <= ioctl_dout;
end
wire [7:0] sw0 = dip_sw[0];

//Instantiate Kangaroo top-level game module
Kangaroo kangaroo_inst
(
	.reset(~reset),       // MiSTer reset is active-high; invert for active-low game modules

	.clk_10m(CLK_10M),

	// IN0: {coin_r, coin_l, start2, start1, service} active-high
	.in0({m_coin2, m_coin1, m_start2, m_start1, m_service}),
	// IN1: {punch, down, up, left, right} P1 active-high
	// GAMESEL-2026-06-21: in1 widened 5->8; bit5 (0x20) = Funky Fish 2nd button (ff_btn2_p1).
	// Original: .in1({m_punch_p1, m_down1, m_up1, m_left1, m_right1}),
	.in1({3'b00, m_punch_p1, m_down1, m_up1, m_left1, m_right1}),
	// IN2: {punch, down, up, left, right} P2 active-high
	.in2({3'b00, m_punch_p2, m_down2, m_up2, m_left2, m_right2}),
	.dsw0(sw0),

	.mcu_present(mcu_present),

	.video_hsync(hs),
	.video_vsync(vs),
	.video_vblank(vblank),
	.video_hblank(hblank),
	.ce_pix(ce_pix),

	.video_r(r),
	.video_g(g),
	.video_b(b),

	.sound_l(audio_l),
	.sound_r(audio_r),

	.ioctl_addr(ioctl_addr),
	.ioctl_data(ioctl_dout),
	.ioctl_wr(ioctl_wr),
	.ioctl_index(ioctl_index),

	.pause(pause_cpu),

	// HISCORE-2026-06-21: wired to the hiscore module (was stubbed to 0).
	.hs_address(hs_address),
	.hs_data_in(hs_data_in),
	.hs_data_out(hs_data_out),
	// DIAG-REVERT-2026-07-06e: hiscore SAVE path is repurposed below (3 bytes of E300-E305) for MCU
	// diagnostic taps -- don't let RESTORE write that garbage back into live workram on next boot.
	// .hs_write(hs_write_enable)
	.hs_write(1'b0)
);

// HISCORE SYSTEM (HISCORE-2026-06-21) — mirrors Tutankham (Kangaroo's structural base), same hiscore.v v0014.
// ioctl_din / ioctl_upload_req are now DRIVEN by the hiscore module (the old "disabled" assigns are removed).
// Score access uses the work-RAM port B in Kangaroo_CPU.sv:208 (clk_10m). Config = MRA index 3, dump = index 4.
wire [15:0] hs_address;
wire [7:0]  hs_data_in;
wire [7:0]  hs_data_out;
wire        hs_write_enable;
wire        hs_access_read;
wire        hs_access_write;
wire        hs_pause;
wire        hs_configured;

hiscore #(
	.HS_ADDRESSWIDTH(16),
	.CFG_ADDRESSWIDTH(3),
	.CFG_LENGTHWIDTH(2)
) hi (
	.*,
	.clk(CLK_10M),
	.paused(pause_cpu),
	.autosave(status[27]),
	.ram_address(hs_address),
	.data_from_ram(hs_data_out),
	.data_to_ram(hs_data_in),
	.data_from_hps(ioctl_dout),
	.data_to_hps(ioctl_din),
	.ram_write(hs_write_enable),
	.ram_intent_read(hs_access_read),
	.ram_intent_write(hs_access_write),
	.pause_cpu(hs_pause),
	.configured(hs_configured)
);

endmodule
