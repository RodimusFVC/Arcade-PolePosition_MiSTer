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
    `include "sys/emu_ports.vh"
);

assign {SD_SCK, SD_MOSI, SD_CS} = 'Z;
assign {UART_RTS, UART_TXD, UART_DTR} = 0;
assign {SDRAM_DQ, SDRAM_A, SDRAM_BA, SDRAM_CLK, SDRAM_CKE, SDRAM_DQML, SDRAM_DQMH, SDRAM_nWE, SDRAM_nCAS, SDRAM_nRAS, SDRAM_nCS} = 'Z;

assign VGA_F1    = 0;
assign VGA_SCALER= 0;
assign USER_OUT  = '1;
// LED_USER also latches a Z8002 illegal opcode
wire sub_illegal;
assign LED_USER  = rom_download | sub_illegal;
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

// horizontal (ROT0) game: landscape aspect only
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
	"P1OMR,CRT H-sync adjust,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,-32,-31,-30,-29,-28,-27,-26,-25,-24,-23,-22,-21,-20,-19,-18,-17,-16,-15,-14,-13,-12,-11,-10,-9,-8,-7,-6,-5,-4,-3,-2,-1;",
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
	"P3,Controls;",
	"P3OHI,Steering,D-pad,Analog stick/wheel,Paddle;",
	"P3OEG,Steering sensitivity,1.0x,0.75x,0.5x,0.25x,0.125x,1.25x,1.5x,2.0x;",
	"P3OD,Steering direction,Normal,Reversed;",
	"P3O9,Pedals,Digital buttons,Analog;",
	"P3OL,Pedal axis,Left stick Y,Right stick Y;",
	"P3-;",
	"P3-,Spinner and mouse always steer;",
	"P3-,Analog pedals: up = gas, down = brake;",
	"-;",
	"O2,Watchdog,On,Off;",
	"O6,Service Mode,Off,On;",
	"O7,Palette Swatch,Off,On;",
	"R0,Reset;",
	// button slots: keep identical to the MRA <buttons> list
	"J1,Accelerate,Brake,Gear,Service Mode,Coin,Start 1P,Start 2P,Pause;",
	"jn,A,B,X,Y,Select,Start,R,L;",

	"V,v",`BUILD_DATE
};

// DIP switches (ioctl index 254): byte 0 = DSWA, byte 1 = DSWB, MAME polarity; power-on = MAME defaults
reg [7:0] dsw[2];
initial begin
	dsw[0] = 8'hFF;
	dsw[1] = 8'h74;
end
always @(posedge clk_sys)
	if (ioctl_wr && (ioctl_index==254) && !ioctl_addr[24:1])
		dsw[ioctl_addr[0]] <= ioctl_dout;

////////////////////   CLOCKS   ///////////////////

wire clk_sys,clk_12,clk_24,clk_36,clk_48;
wire pll_locked;

pll pll
(
	.refclk(CLK_50M),
	.rst(0),
	.outclk_0(clk_sys),
	.locked(pll_locked)
);

// single 49.152 MHz domain; clk_48 is the legacy video-clock name
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
wire [15:0] joystick_l_analog_0;  // analog wheel / stick X
wire [15:0] joystick_r_analog_0;  // optional pedal axis Y
wire  [8:0] spinner_0;
wire  [7:0] paddle_0;
wire [24:0] ps2_mouse;
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
	.ps2_mouse(ps2_mouse),
	.spinner_0(spinner_0),
	.paddle_0(paddle_0),
	.joystick_l_analog_0(joystick_l_analog_0),
	.joystick_r_analog_0(joystick_r_analog_0),
	.joystick_0(joystick_0),
	.joystick_1(joystick_1)
);

wire pause_cpu;                     // CTL2-2026-10-25: declared here (was at the pause instance; the keyboard uses it)

// CTL2-2026-10-25: v1 local keyboard commented out below (now controllers.sv ctl_keyboard)
// wire key_start1, key_start2;
// wire key_coin1, key_coin2, key_coin3, key_coin4;
// wire key_reset, key_service;
//
// wire key_p1_up, key_p1_left, key_p1_down, key_p1_right, key_p1_fire, key_p1_bomb;
// wire key_p2_up, key_p2_left, key_p2_down, key_p2_right, key_p2_fire, key_p2_bomb;
//
// wire pressed = ps2_key[9];
// always @(posedge clk_sys) begin
// 	reg old_state;
//
// 	old_state <= ps2_key[10];
// 	if(old_state ^ ps2_key[10]) begin
// 		casex(ps2_key[8:0])
// 			'h016: key_start1   <= pressed; // 1
// 			'h01e: key_start2   <= pressed; // 2
// 			'h02E: key_coin1    <= pressed; // 5
// 			'h036: key_coin2    <= pressed; // 6
// 			'h004: key_reset    <= pressed; // F3
// 			'h046: key_service  <= pressed; // 9
//
// 			'hX75: key_p1_up    <= pressed; // up
// 			'hX6b: key_p1_left  <= pressed; // left
// 			'hX72: key_p1_down  <= pressed; // down
// 			'hX74: key_p1_right <= pressed; // right
// 			'h014: key_p1_fire  <= pressed; // lctrl
// 			'h011: key_p1_bomb  <= pressed; // lalt
//
// 			'h02d: key_p2_up    <= pressed; // r
// 			'h023: key_p2_left  <= pressed; // d
// 			'h02b: key_p2_down  <= pressed; // f
// 			'h034: key_p2_right <= pressed; // g
// 			'h01c: key_p2_fire  <= pressed; // a
// 			'h01b: key_p2_bomb  <= pressed; // s
// 		endcase
// 	end
// end
// controllers.sv ctl_keyboard, STD_EXT 1 (the old casex: non-arrow keys only on their non-extended code, so right Ctrl /
// Alt do nothing; arrows either). kb [0] up [1] down [2] left [3] right [4] lctrl [5] lalt [6] 1 [7] 2 [8] 5 [9] 6
// [10] 9 ([11] T / [12] P unused); kbx [0] F3 reset, player 2 [1] R up [2] D left [3] F down [4] G right [5] A fire
// [6] S bomb (player 2 keys unused by the board, as before)
/* verilator lint_off UNUSED */
wire [12:0] kb;
wire  [6:0] kbx;
/* verilator lint_on UNUSED */
ctl_keyboard #(.STD_EXT(1), .NX(7), .NXO(7), .XKEYS({24'h11_1B_06, 24'h11_1C_05, 24'h11_34_04, 24'h11_2B_03,
                                                     24'h11_23_02, 24'h11_2D_01, 24'h11_04_00})) u_kb
(
	.clk(clk_sys), .ps2_key(ps2_key), .pause(pause_cpu), .kb(kb), .kbx(kbx)
);
wire key_start1 = kb[6], key_start2 = kb[7];
wire key_coin1 = kb[8], key_coin2 = kb[9];
wire key_reset = kbx[0], key_service = kb[10];
wire key_p1_up = kb[0], key_p1_left = kb[2], key_p1_down = kb[1], key_p1_right = kb[3], key_p1_fire = kb[4], key_p1_bomb = kb[5];


wire m_right1 = joystick_0[0]  | key_p1_right;
wire m_left1  = joystick_0[1]  | key_p1_left;
wire m_down1  = joystick_0[2]  | key_p1_down;
wire m_up1    = joystick_0[3]  | key_p1_up;
// gear shifter is a latching toggle (MAME PORT_TOGGLE); powers up in Lo
wire m_gear_btn = joystick_0[6] | key_p1_fire | key_p1_bomb;
// CTL-2026-10-24: original block commented out below (replaced by rtl/mister_custom/controllers.sv modules after it)
// reg  m_gear_btn_d = 1'b0;
// reg  m_gear1      = 1'b0;
// always @(posedge clk_sys) begin
// 	m_gear_btn_d <= m_gear_btn;
// 	if (m_gear_btn & ~m_gear_btn_d) m_gear1 <= ~m_gear1;   // flip on press (rising edge)
// end
// CTL-2026-10-24: gear PORT_TOGGLE via ctl_toggle (flips on each press, powers up in Lo)
wire m_gear1;
// CTL2-2026-10-25: original below (presses while paused are ignored)
// ctl_toggle u_gear(.clk(clk_sys), .clear(1'b0), .btn(m_gear_btn), .q(m_gear1));
ctl_toggle u_gear(.clk(clk_sys), .clear(1'b0), .btn(m_gear_btn), .pause(pause_cpu), .q(m_gear1));
// Service Mode (self-test switch, IN0 bit 7): button or OSD toggle
wire m_service_mode = joystick_0[7];
wire m_coin1  = joystick_0[8]  | key_coin1;
wire m_start1 = joystick_0[9]  | key_start1;
// P2 Start doubles as Start 2P
wire m_start2 = joystick_0[10] | joystick_1[9] | key_start2;
wire m_pause  = joystick_0[11];

wire m_coin2  = joystick_1[8]  | key_coin2;

// PAUSE SYSTEM
// CTL2-2026-10-25: original below (pause_cpu is now declared above the keyboard block)
// wire				pause_cpu;
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

// arcade_video samples on the core's own pixel enable
wire ce_pix = ce_vid;

wire flip_screen = status[8];
wire rotate_ccw = flip_screen;
// never rotate (ROT0)
wire no_rotate = 1'b1;
wire video_rotated;
wire flip = 0;

screen_rotate screen_rotate (.*);

localparam [1:0] VID_H_DELAY = 2'd1;   // pixels to shift RIGHT; 0 = disabled
reg [11:0] rgb_d1 = 12'd0, rgb_d2 = 12'd0, rgb_d3 = 12'd0;
always @(posedge clk_sys) if (ce_pix) begin
	rgb_d1 <= rgb_out;
	rgb_d2 <= rgb_d1;
	rgb_d3 <= rgb_d2;
end
wire [11:0] rgb_shifted = (VID_H_DELAY == 2'd0) ? rgb_out :
                          (VID_H_DELAY == 2'd1) ? rgb_d1  :
                          (VID_H_DELAY == 2'd2) ? rgb_d2  : rgb_d3;

arcade_video #(256,12) arcade_video
(
	.*,

	.clk_video(clk_48),
	.RGB_in(rgb_shifted),
	.HBlank(hblank),
	.VBlank(vblank),
	.HSync(hs),
	.VSync(vs),

	.fx(status[5:3])
);

wire [15:0] audio;
assign AUDIO_L = audio;
assign AUDIO_R = AUDIO_L;
assign AUDIO_S = 1;

wire service, service_r, service_trigger;
always @(posedge clk_sys) begin
	service <= status[6];
	service_r <= service;
	service_trigger <= service & !service_r;
end

wire rom_download = ioctl_download & !ioctl_index;

// MRA mod byte (ioctl index 7): bit0 PP2 IC25 custom, bit1 bootleg I/O board, bit2 bootleg speech board
reg [7:0] pp_mod = 8'd0;
always @(posedge clk_sys) begin
	if (ioctl_wr && (ioctl_index == 8'd7) && (ioctl_addr == 25'd0))
		pp_mod <= ioctl_dout;
end
wire ic25_en = pp_mod[0];
wire bootleg_io = pp_mod[1];
wire bootleg_snd = pp_mod[2];
// hold reset for the whole multi-index download
wire reset = RESET | status[0] | buttons[1] | ioctl_download | ~pll_locked | service_trigger | key_reset;

// watchdog enable (OSD, default on, MAME polepos.cpp set_vblank_count 16)
wire wdog_en = ~status[2];

// alpha chars ROM: ioctl index 1, 0x0000-0x0FFF
wire [12:0] chars_gfx_addr;
reg  [7:0]  chars_gfx_data;
reg  [7:0]  chars_rom [0:8191];
wire        chars_wr = ioctl_wr & (ioctl_index == 8'd1) & (ioctl_addr < 25'h2000);
always @(posedge clk_sys) begin
	if (chars_wr) chars_rom[ioctl_addr[12:0]] <= ioctl_dout;
	chars_gfx_data <= chars_rom[chars_gfx_addr];
end

wire [12:0] tiles_gfx_addr;
reg  [7:0]  tiles_gfx_data;
reg  [7:0]  tiles_rom [0:8191];
wire        tiles_wr = ioctl_wr & (ioctl_index == 8'd1) & (ioctl_addr >= 25'h2000) & (ioctl_addr < 25'h4000);
always @(posedge clk_sys) begin
	if (tiles_wr) tiles_rom[ioctl_addr[12:0]] <= ioctl_dout;
	tiles_gfx_data <= tiles_rom[tiles_gfx_addr];
end

wire [14:0] road_rom_addr;
reg  [7:0]  road_rom_data;
reg  [7:0]  road_rom [0:20479];    // 0x5000
wire        road_wr = ioctl_wr & (ioctl_index == 8'd1) & (ioctl_addr >= 25'h18000) & (ioctl_addr < 25'h1D000);
always @(posedge clk_sys) begin
	if (road_wr) road_rom[ioctl_addr - 25'h18000] <= ioctl_dout;
	road_rom_data <= road_rom[road_rom_addr];
end

wire [11:0] scalelut_addr;
reg  [7:0]  scalelut_data;
reg  [7:0]  scalelut_rom [0:4095];
wire        scalelut_wr = ioctl_wr & (ioctl_index == 8'd1) & (ioctl_addr >= 25'h1D000) & (ioctl_addr < 25'h1E000);
always @(posedge clk_sys) begin
	if (scalelut_wr) scalelut_rom[ioctl_addr[11:0]] <= ioctl_dout;
	scalelut_data <= scalelut_rom[scalelut_addr];
end

wire [16:0] sprgfx_addr;
reg  [7:0]  sprgfx_data;
reg  [7:0]  sprite_rom [0:81919];  // 0x14000
// index-1 stream padded to MAME region sizes (one gate set for PP1 and PP2), see mra_emit.py IDX1_PAD:
//   chars 0x00000 | tiles 0x02000 | sprites 0x04000 | bigsprites 0x08000 | road 0x18000 | scalelut 0x1D000
wire        sprite_wr = ioctl_wr & (ioctl_index == 8'd1) & (ioctl_addr >= 25'h4000) & (ioctl_addr < 25'h18000);
always @(posedge clk_sys) begin
	if (sprite_wr) sprite_rom[ioctl_addr - 25'h4000] <= ioctl_dout;
	sprgfx_data <= sprite_rom[sprgfx_addr];
end

// palette PROMs: ioctl index 2, 0x000-0xFFF
wire        pp_prom_wr   = ioctl_wr & (ioctl_index == 8'd2) & (ioctl_addr < 25'h1000);
wire [11:0] pp_prom_addr = ioctl_addr[11:0];
wire [7:0]  pp_prom_data = ioctl_dout;

// WSG waveform PROM: ioctl index 2, 0x1040-0x113F (unaligned: subtract, 8-bit wrap is correct)
wire        wsg_prom_wr   = ioctl_wr & (ioctl_index == 8'd2) & (ioctl_addr >= 25'h1040) & (ioctl_addr < 25'h1140);
wire [7:0]  wsg_prom_addr = ioctl_addr[7:0] - 8'h40;
wire [7:0]  wsg_prom_data = ioctl_dout;

wire        mcu_rom_wr   = ioctl_wr & (ioctl_index == 8'd6) & (ioctl_addr < 25'h1000);
wire [11:0] mcu_rom_addr = ioctl_addr[11:0];
wire [7:0]  mcu_rom_data = ioctl_dout;

wire [14:0] sample52_addr;
reg  [7:0]  sample52_data;
reg  [7:0]  sample52_rom [0:32767]; // 0x8000
wire        sample52_wr = ioctl_wr & (ioctl_index == 8'd5) & (ioctl_addr >= 25'h4000) & (ioctl_addr < 25'hC000);
always @(posedge clk_sys) begin
	if (sample52_wr) sample52_rom[ioctl_addr - 25'h4000] <= ioctl_dout;
	sample52_data <= sample52_rom[sample52_addr];
end

// engine waveform ROM: ioctl index 5, 0x0000-0x3FFF (8 slots x 0x800)
wire [13:0] engine_addr;
reg  [7:0]  engine_data;
reg  [7:0]  engine_rom [0:16383]; // 0x4000
wire        engine_wr = ioctl_wr & (ioctl_index == 8'd5) & (ioctl_addr < 25'h4000);
always @(posedge clk_sys) begin
	if (engine_wr) engine_rom[ioctl_addr[13:0]] <= ioctl_dout;
	engine_data <= engine_rom[engine_addr];
end

// steering via ctl_mouse + ctl_steer: spinner / mouse X relative, stick / paddle absolute by status[18:17], D-pad
// ramp, one count per clk/16384 tick. steer_pos powers up 0x80; reset sets 0x80.
wire       steer_mouse_ev;
wire [9:0] steer_mouse_dx;
/* verilator lint_off UNUSED */
wire [9:0] steer_mouse_dy;
wire [2:0] steer_mouse_btn;
/* verilator lint_on UNUSED */
ctl_mouse u_mouse(.clk(clk_sys), .ps2_mouse(ps2_mouse), .ev(steer_mouse_ev), .dx(steer_mouse_dx), .dy(steer_mouse_dy),
                  .btn(steer_mouse_btn));
wire [7:0] steer_pos;
// CTL4-2026-10-27: original below. RATE: Steering = Analog stick/wheel turns at a speed set by the deflection (MAME feeds
// a stick to the IPT_DIAL that way); before, a held stick moved the dial <= 64 counts once and the car went straight.
// ctl_steer u_steer
ctl_steer #(.RATE(1'b1)) u_steer
(
	.clk         (clk_sys),
	.reset       (reset),
	// CTL2-2026-10-25: original below
// 	.pause       (1'b0),
// 	.mode        (status[18:17]),
	.pause       (pause_cpu),
	.mode        (status[18:17]),
	.sensitivity (status[16:14]),
	.reverse     (status[13]),
	.left        (m_left1),
	.right       (m_right1),
	.spinner     (spinner_0),
	.mouse_ev    (steer_mouse_ev),
	.mouse_dx    (steer_mouse_dx),
	.analog_x    (joystick_l_analog_0[7:0]),
	.paddle      (paddle_0),
	.steer_pos   (steer_pos)
);

// pedals (ADC, full scale 0x90): Accelerate/Brake buttons or D-pad; OSD analog mode reads one stick axis (up = gas)
wire       pedal_analog = status[9];
wire       m_accel1 = (pedal_analog ? 1'b0 : m_up1)   | joystick_0[4];
wire       m_brake1 = (pedal_analog ? 1'b0 : m_down1) | joystick_0[5];
wire [7:0] pedal_y_raw  = status[21] ? joystick_r_analog_0[15:8] : joystick_l_analog_0[15:8];
// CTL-2026-10-24: original block commented out below (replaced by rtl/mister_custom/controllers.sv modules after it)
// wire signed [8:0] pedal_y = $signed({pedal_y_raw[7], pedal_y_raw});
// wire [7:0] pedal_mag    = pedal_y[8] ? (8'd0 - pedal_y_raw) : pedal_y_raw;     // |Y|, -128 -> 128 wraps to 0x80
// wire [15:0] pedal_scl   = {8'd0, pedal_mag} * 16'd144;                       // x 0x90 / 128
// wire [7:0] pedal_lvl    = (pedal_mag < 8'd8) ? 8'h00 : pedal_scl[14:7];       // dead zone ~6%
// wire [7:0] ana_accel    = (pedal_analog && pedal_y[8])  ? pedal_lvl : 8'h00;  // up (negative Y)
// wire [7:0] ana_brake    = (pedal_analog && !pedal_y[8]) ? pedal_lvl : 8'h00;  // down
// // digital pedals ramp +16/frame like MAME's keyboard pedal: the PP2 bootlegs only start while gas reads $40-$7F
// reg  [7:0] dig_accel = 8'h00, dig_brake = 8'h00;
// reg        pedal_vb_d;
// always @(posedge clk_sys) begin
// 	pedal_vb_d <= vblank;
// 	if (vblank & ~pedal_vb_d) begin
// 		dig_accel <= !m_accel1 ? 8'h00 : (dig_accel >= 8'h80) ? 8'h90 : dig_accel + 8'd16;
// 		dig_brake <= !m_brake1 ? 8'h00 : (dig_brake >= 8'h80) ? 8'h90 : dig_brake + 8'd16;
// 	end
// end
// wire [7:0] pp_accel = m_accel1 ? dig_accel : ana_accel;
// wire [7:0] pp_brake = m_brake1 ? dig_brake : ana_brake;
// CTL-2026-10-24: pedal levels via ctl_tick (vblank) + ctl_pedal (+16 per frame to 0x90; analog |Y| x 0x90/128, dead zone 8)
wire pedal_tick;
// CTL2-2026-10-25: original below (pedal tick and ramps stop while paused; PAUSE_MODE 1: a release while paused clears)
// ctl_tick #(.MODE(0)) u_pedal_tick(.clk(clk_sys), .pause(1'b0), .vblank(vblank), .period(18'd0), .tick(pedal_tick));
// wire [7:0] pp_accel, pp_brake;
// ctl_pedal #(.FULL(8'h90), .RAMP(8'd16), .DZ(8'd8)) u_pedal
// (
// 	.clk(clk_sys), .pause(1'b0), .tick(pedal_tick), .accel_btn(m_accel1), .brake_btn(m_brake1),
ctl_tick #(.MODE(0)) u_pedal_tick(.clk(clk_sys), .pause(pause_cpu), .vblank(vblank), .period(18'd0), .tick(pedal_tick));
wire [7:0] pp_accel, pp_brake;
ctl_pedal #(.FULL(8'h90), .RAMP(8'd16), .DZ(8'd8), .PAUSE_MODE(1)) u_pedal
(
	.clk(clk_sys), .pause(pause_cpu), .tick(pedal_tick), .accel_btn(m_accel1), .brake_btn(m_brake1),
	.analog_en(pedal_analog), .axis(pedal_y_raw), .accel(pp_accel), .brake(pp_brake)
);

poleposition poleposition
(
	.clock_18(clk_sys),
	.reset(reset),
	.wdog_en(wdog_en),
	.sub_illegal(sub_illegal),

	.dn_addr(ioctl_addr[16:0]),
	.dn_data(ioctl_dout),
	.dn_wr(ioctl_wr & rom_download),
	.ic25_en(ic25_en),
	.bootleg_io(bootleg_io),
	.bootleg_snd(bootleg_snd),

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

	.engine_addr(engine_addr),
	.engine_data(engine_data),

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
	.h_offset(status[27:22]),
	.v_offset(status[31:28]),
	.diag_swatch(status[7]),

	.audio(audio),

	.self_test(status[6] | m_service_mode),

	// service = IN0 bit 6 service credit (keyboard 9), not the self-test switch
	.service(key_service),
	.coin1(m_coin1),
	.coin2(m_coin2),
	.start1(m_start1),
	.start2(m_start2),
	.fire1(m_gear1),  // Gear Change -> IN0 bit 1

	.dip_switch_a(dsw[0]),
	.dip_switch_b(dsw[1]),

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

wire [10:0]hs_address;
wire [7:0] hs_data_in;
wire [7:0] hs_data_out;
wire hs_write_enable;
wire hs_pause;
wire hs_configured;

hiscore #(
	.HS_ADDRESSWIDTH(11),          // 2 KB NVRAM, Z80 $3000-$37FF (2048 >= $7F2)
	.HS_SCOREWIDTH(11),  // capture buffer must cover the whole 2034-byte range
	.CFG_ADDRESSWIDTH(2),          // 4 entries max; we use 1
	.CFG_LENGTHWIDTH(2)            // 16-bit length ($7F2)
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
