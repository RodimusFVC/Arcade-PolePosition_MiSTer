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

assign VIDEO_ARX = (!ar) ? 12'd2880 : (ar - 1'd1);
assign VIDEO_ARY = (!ar) ? 12'd2191 : 12'd0;

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

wire clk_sys,clk_12,clk_24,clk_36,clk_48;
wire pll_locked;

pll pll
(
	.refclk(CLK_50M),
	.rst(0),
	.outclk_0(clk_sys),
	.locked(pll_locked)
);

assign clk_48 = clk_sys;

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
wire [15:0] joystick_l_analog_0;
wire [15:0] joystick_r_analog_0;
wire  [8:0] spinner_0;
wire  [7:0] paddle_0;
wire [24:0] ps2_mouse;
wire [15:0] joy = joystick_0 | joystick_1;

wire [21:0] gamma_bus;

wire [10:0]hs_address;
wire [7:0] hs_data_in;
wire [7:0] hs_data_out;
wire hs_write_enable;
wire hs_pause;
wire hs_configured;

reg [7:0] dsw[2];
initial begin
	dsw[0] = 8'hFF;
	dsw[1] = 8'h74;
end
always @(posedge clk_sys)
	if (ioctl_wr && (ioctl_index==254) && !ioctl_addr[24:1])
		dsw[ioctl_addr[0]] <= ioctl_dout;

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

wire pause_cpu;

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
wire m_gear_btn = joystick_0[6] | key_p1_fire | key_p1_bomb;
wire m_gear1;
ctl_toggle u_gear(.clk(clk_sys), .clear(1'b0), .btn(m_gear_btn), .pause(pause_cpu), .q(m_gear1));
wire m_service_mode = joystick_0[7];
wire m_coin1  = joystick_0[8]  | key_coin1;
wire m_start1 = joystick_0[9]  | key_start1;
wire m_start2 = joystick_0[10] | joystick_1[9] | key_start2;
wire m_pause  = joystick_0[11];

wire m_coin2  = joystick_1[8]  | key_coin2;

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

wire ce_pix = ce_vid;

wire flip_screen = status[8];
wire rotate_ccw = flip_screen;
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

reg  service, service_r, service_trigger;
always @(posedge clk_sys) begin
	service <= status[6];
	service_r <= service;
	service_trigger <= service & !service_r;
end

wire rom_download = ioctl_download & !ioctl_index;

wire sub_illegal;
assign LED_USER  = rom_download | sub_illegal;

wire reset = RESET | status[0] | buttons[1] | ioctl_download | ~pll_locked | service_trigger | key_reset;

wire wdog_en = ~status[2];

wire       steer_mouse_ev;
wire [9:0] steer_mouse_dx;
/* verilator lint_off UNUSED */
wire [9:0] steer_mouse_dy;
wire [2:0] steer_mouse_btn;
/* verilator lint_on UNUSED */
ctl_mouse u_mouse(.clk(clk_sys), .ps2_mouse(ps2_mouse), .ev(steer_mouse_ev), .dx(steer_mouse_dx), .dy(steer_mouse_dy),
                  .btn(steer_mouse_btn));
wire [7:0] steer_pos;
ctl_steer #(.RATE(1'b1)) u_steer
(
	.clk         (clk_sys),
	.reset       (reset),
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

wire       pedal_analog = status[9];
wire       m_accel1 = (pedal_analog ? 1'b0 : m_up1)   | joystick_0[4];
wire       m_brake1 = (pedal_analog ? 1'b0 : m_down1) | joystick_0[5];
wire [7:0] pedal_y_raw  = status[21] ? joystick_r_analog_0[15:8] : joystick_l_analog_0[15:8];
wire pedal_tick;
ctl_tick #(.MODE(0)) u_pedal_tick(.clk(clk_sys), .pause(pause_cpu), .vblank(vblank), .period(18'd0), .tick(pedal_tick));
wire [7:0] pp_accel, pp_brake;
ctl_pedal #(.FULL(8'h90), .RAMP(8'd16), .DZ(8'd8), .PAUSE_MODE(1)) u_pedal
(
	.clk(clk_sys), .pause(pause_cpu), .tick(pedal_tick), .accel_btn(m_accel1), .brake_btn(m_brake1),
	.analog_en(pedal_analog), .axis(pedal_y_raw), .accel(pp_accel), .brake(pp_brake)
);

polepos_dispatcher polepos_dispatcher
(
	.clk(clk_sys),
	.reset(reset),
	.pause(pause_cpu),

	.ioctl_index(ioctl_index),
	.ioctl_addr(ioctl_addr),
	.ioctl_dout(ioctl_dout),
	.ioctl_wr(ioctl_wr),
	.ioctl_wr0(ioctl_wr & rom_download),

	.wdog_en(wdog_en),
	.sub_illegal(sub_illegal),

	.video_r(r),
	.video_g(g),
	.video_b(b),
	.video_hs(hs),
	.video_vs(vs),
	.video_en(ce_vid),
	.blank_h(hblank),
	.blank_v(vblank),

	.flip(flip_screen),
	.h_offset(status[27:22]),
	.v_offset(status[31:28]),
	.diag_swatch(status[7]),

	.audio(audio),

	.self_test(status[6] | m_service_mode),

	.service(key_service),
	.coin1(m_coin1),
	.coin2(m_coin2),
	.start1(m_start1),
	.start2(m_start2),
	.fire1(m_gear1),

	.dip_switch_a(dsw[0]),
	.dip_switch_b(dsw[1]),

	.steer_in(steer_pos),
	.accel_in(pp_accel),
	.brake_in(pp_brake),

	.hs_address(hs_address),
	.hs_data_out(hs_data_out),
	.hs_data_in(hs_data_in),
	.hs_write(hs_write_enable)
);

hiscore #(
	.HS_ADDRESSWIDTH(11),
	.HS_SCOREWIDTH(11),            // the capture buffer must cover the whole 2034-byte range
	.CFG_ADDRESSWIDTH(2),
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
