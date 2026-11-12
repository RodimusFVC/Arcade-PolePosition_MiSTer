//  polepos_dispatcher - Pole Position shared pools and board
//  Copyright (C) 2026 Rodimus
`default_nettype none

module polepos_dispatcher
(
    input  wire        clk,
    input  wire        reset,
    input  wire        pause,

    input  wire  [7:0] ioctl_index,
    input  wire [24:0] ioctl_addr,
    input  wire  [7:0] ioctl_dout,
    input  wire        ioctl_wr,
    input  wire        ioctl_wr0,

    input  wire        wdog_en,
    output wire        sub_illegal,

    output wire  [3:0] video_r,
    output wire  [3:0] video_g,
    output wire  [3:0] video_b,
    output wire        video_hs,
    output wire        video_vs,
    output wire        video_en,
    output wire        blank_h,
    output wire        blank_v,

    input  wire        flip,
    input  wire signed [5:0] h_offset,
    input  wire signed [3:0] v_offset,
    input  wire        diag_swatch,

    output wire [15:0] audio,

    input  wire        self_test,
    input  wire        service,
    input  wire        coin1,
    input  wire        start1,
    input  wire        fire1,
    input  wire        coin2,
    input  wire        start2,

    input  wire  [7:0] dip_switch_a,
    input  wire  [7:0] dip_switch_b,
    input  wire  [7:0] steer_in,
    input  wire  [7:0] accel_in,
    input  wire  [7:0] brake_in,

    input  wire [10:0] hs_address,
    output wire  [7:0] hs_data_out,
    input  wire  [7:0] hs_data_in,
    input  wire        hs_write
);

// MRA mod byte (ioctl index 7): [0] PP2 IC25 custom, [1] bootleg I/O board, [2] bootleg speech board
reg [7:0] pp_mod = 8'd0;
always @(posedge clk)
    if (ioctl_wr && (ioctl_index == 8'd7) && (ioctl_addr == 25'd0)) pp_mod <= ioctl_dout;

wire [16:0] dn_addr = ioctl_addr[16:0];

/////////////////////////////  Shared CPU / sound chip pool  /////////////////////////////

// z80r_0: main Z80 (polepos) | z80r_1: bootleg speech board Z80 (polepos)
chip_pool_pkg::z80r_i_t z80r_0_i, z80r_1_i;
chip_pool_pkg::z80r_o_t z80r_0_o, z80r_1_o;

t80sv_T80s #(.Mode(0), .T2Write(1), .IOWait(1)) z80r_0
(
    .RESET_n(z80r_0_i.reset_n), .CLK(clk), .CEN(z80r_0_i.ce), .WAIT_n(z80r_0_i.wait_n), .INT_n(z80r_0_i.int_n),
    .NMI_n(z80r_0_i.nmi_n),
    .BUSRQ_n(1'b1), .M1_n(z80r_0_o.m1_n), .MREQ_n(z80r_0_o.mreq_n), .IORQ_n(z80r_0_o.iorq_n), .RD_n(z80r_0_o.rd_n),
    .WR_n(z80r_0_o.wr_n), .RFSH_n(z80r_0_o.rfsh_n), .A(z80r_0_o.a), .DI(z80r_0_i.di), .DO(z80r_0_o.dout)
);

t80sv_T80s #(.Mode(0), .T2Write(1), .IOWait(1)) z80r_1
(
    .RESET_n(z80r_1_i.reset_n), .CLK(clk), .CEN(z80r_1_i.ce), .WAIT_n(z80r_1_i.wait_n), .INT_n(z80r_1_i.int_n),
    .NMI_n(z80r_1_i.nmi_n),
    .BUSRQ_n(1'b1), .M1_n(z80r_1_o.m1_n), .MREQ_n(z80r_1_o.mreq_n), .IORQ_n(z80r_1_o.iorq_n), .RD_n(z80r_1_o.rd_n),
    .WR_n(z80r_1_o.wr_n), .RFSH_n(z80r_1_o.rfsh_n), .A(z80r_1_o.a), .DI(z80r_1_i.di), .DO(z80r_1_o.dout)
);

// z8002_0 / z8002_1: game CPUs 1 and 2 (polepos)
chip_pool_pkg::z8002_i_t z8002_0_i, z8002_1_i;
chip_pool_pkg::z8002_o_t z8002_0_o, z8002_1_o;

z8002 z8002_0
(
    .clk(clk), .ce(z8002_0_i.ce), .reset_n(z8002_0_i.reset_n), .addr(z8002_0_o.addr), .dout(z8002_0_o.dout),
    .din(z8002_0_i.din), .mreq(z8002_0_o.mreq), .iorq(z8002_0_o.iorq), .we(z8002_0_o.we), .wordacc(z8002_0_o.wordacc),
    .wait_n(z8002_0_i.wait_n), .nmi_n(z8002_0_i.nmi_n), .nvi_n(z8002_0_i.nvi_n), .vi_n(z8002_0_i.vi_n),
    .dbg_pc(), .dbg_fcw(), .dbg_ir(), .dbg_retire(), .dbg_illegal(z8002_0_o.illegal), .dbg_regs()
);

z8002 z8002_1
(
    .clk(clk), .ce(z8002_1_i.ce), .reset_n(z8002_1_i.reset_n), .addr(z8002_1_o.addr), .dout(z8002_1_o.dout),
    .din(z8002_1_i.din), .mreq(z8002_1_o.mreq), .iorq(z8002_1_o.iorq), .we(z8002_1_o.we), .wordacc(z8002_1_o.wordacc),
    .wait_n(z8002_1_i.wait_n), .nmi_n(z8002_1_i.nmi_n), .nvi_n(z8002_1_i.nvi_n), .vi_n(z8002_1_i.vi_n),
    .dbg_pc(), .dbg_fcw(), .dbg_ir(), .dbg_retire(), .dbg_illegal(z8002_1_o.illegal), .dbg_regs()
);

// namco_06xx_0: Namco 06XX (polepos)
chip_pool_pkg::namco_06xx_i_t namco_06xx_0_i;
chip_pool_pkg::namco_06xx_o_t namco_06xx_0_o;

namco_06xx namco_06xx_0
(
    .clk(clk), .reset(namco_06xx_0_i.reset), .pause(pause), .irq_on_access(namco_06xx_0_i.irq_on_access),
    .cpu_dout(namco_06xx_0_i.cpu_dout), .data_wr(namco_06xx_0_i.data_wr), .data_rd(namco_06xx_0_i.data_rd),
    .ctrl_wr(namco_06xx_0_i.ctrl_wr), .ctrl_rd(namco_06xx_0_i.ctrl_rd), .cpu_din(namco_06xx_0_o.cpu_din),
    .nmi_n(namco_06xx_0_o.nmi_n), .chipsel(namco_06xx_0_o.chipsel), .rw0(namco_06xx_0_o.rw0),
    .chip0_din(namco_06xx_0_i.chip0_din), .chip1_din(namco_06xx_0_i.chip1_din), .chip2_din(namco_06xx_0_i.chip2_din),
    .chip3_din(namco_06xx_0_i.chip3_din), .chip_dout(namco_06xx_0_o.chip_dout), .chip_wr(namco_06xx_0_o.chip_wr)
);

// MCU mask ROMs: ioctl index 6, 51xx 0x000, 53xx 0x400, 54xx 0x800, 52xx 0xC00
wire        mcu_rom_wr   = ioctl_wr & (ioctl_index == 8'd6) & (ioctl_addr < 25'h1000);
wire [11:0] mcu_rom_addr = ioctl_addr[11:0];

// mb88_0: 51XX MCU | mb88_1: 53XX MCU | mb88_2: 54XX MCU | mb88_3: 52XX MCU (polepos)
chip_pool_pkg::mb88_i_t mb88_0_i, mb88_1_i, mb88_2_i, mb88_3_i;
chip_pool_pkg::mb88_o_t mb88_0_o, mb88_1_o, mb88_2_o, mb88_3_o;

// namco_51xx_0 (polepos)
chip_pool_pkg::namco_51xx_i_t namco_51xx_0_i;
chip_pool_pkg::namco_51xx_o_t namco_51xx_0_o;

namco_51xx namco_51xx_0
(
    .clk(clk), .ena(namco_51xx_0_i.ena), .reset_n(namco_51xx_0_i.reset_n),
    .chip_sel(namco_51xx_0_i.chip_sel), .rw_in(namco_51xx_0_i.rw_in), .data_out(namco_51xx_0_o.data_out),
    .wr_en(namco_51xx_0_i.wr_en), .wr_data(namco_51xx_0_i.wr_data),
    .in_a(namco_51xx_0_i.in_a), .in_b(namco_51xx_0_i.in_b), .p_port_out(namco_51xx_0_o.p_port_out),
    .rom_wr(mcu_rom_wr && mcu_rom_addr[11:10] == 2'b00), .rom_addr_in(mcu_rom_addr[9:0]), .rom_data_in(ioctl_dout),
    .vblank(namco_51xx_0_i.vblank),
    .mb88_i(mb88_0_i), .mb88_o(mb88_0_o)
);

// namco_53xx_0 (polepos)
chip_pool_pkg::namco_53xx_i_t namco_53xx_0_i;
chip_pool_pkg::namco_53xx_o_t namco_53xx_0_o;

namco_53xx namco_53xx_0
(
    .clk(clk), .ena(namco_53xx_0_i.ena), .reset_n(namco_53xx_0_i.reset_n),
    .chip_sel(namco_53xx_0_i.chip_sel), .data_out(namco_53xx_0_o.data_out),
    .k_in(namco_53xx_0_i.k_in), .in_a(namco_53xx_0_i.in_a), .in_b(namco_53xx_0_i.in_b),
    .rom_wr(mcu_rom_wr && mcu_rom_addr[11:10] == 2'b01), .rom_addr_in(mcu_rom_addr[9:0]), .rom_data_in(ioctl_dout),
    .mb88_i(mb88_1_i), .mb88_o(mb88_1_o)
);

// namco_54xx_0 (polepos)
chip_pool_pkg::namco_54xx_i_t namco_54xx_0_i;
chip_pool_pkg::namco_54xx_o_t namco_54xx_0_o;

namco_54xx namco_54xx_0
(
    .clk(clk), .ena(namco_54xx_0_i.ena), .reset_n(namco_54xx_0_i.reset_n),
    .chip_sel(namco_54xx_0_i.chip_sel), .wr_en(namco_54xx_0_i.wr_en), .wr_data(namco_54xx_0_i.wr_data),
    .discrete_o0(namco_54xx_0_o.discrete_o0), .discrete_o1(namco_54xx_0_o.discrete_o1),
    .discrete_r1(namco_54xx_0_o.discrete_r1),
    .rom_wr(mcu_rom_wr && mcu_rom_addr[11:10] == 2'b10), .rom_addr_in(mcu_rom_addr[9:0]), .rom_data_in(ioctl_dout),
    .mb88_i(mb88_2_i), .mb88_o(mb88_2_o)
);

// namco_52xx_0 (polepos)
chip_pool_pkg::namco_52xx_i_t namco_52xx_0_i;
chip_pool_pkg::namco_52xx_o_t namco_52xx_0_o;

namco_52xx namco_52xx_0
(
    .clk(clk), .ena(namco_52xx_0_i.ena), .reset_n(namco_52xx_0_i.reset_n),
    .chip_sel(namco_52xx_0_i.chip_sel), .wr_en(namco_52xx_0_i.wr_en), .wr_data(namco_52xx_0_i.wr_data),
    .si(namco_52xx_0_i.si), .tc_n(namco_52xx_0_i.tc_n),
    .p_out(namco_52xx_0_o.p_out), .sample_addr(namco_52xx_0_o.sample_addr), .sample_data(namco_52xx_0_i.sample_data),
    .rom_wr(mcu_rom_wr && mcu_rom_addr[11:10] == 2'b11), .rom_addr_in(mcu_rom_addr[9:0]), .rom_data_in(ioctl_dout),
    .mb88_i(mb88_3_i), .mb88_o(mb88_3_o)
);

mb88 mb88_0
(
    .clock(clk), .ena(mb88_0_i.ena), .reset_n(mb88_0_i.reset_n), .ram_clr(1'b0),
    .r0_port_in(mb88_0_i.r_in[3:0]), .r1_port_in(mb88_0_i.r_in[7:4]), .r2_port_in(mb88_0_i.r_in[11:8]),
    .r3_port_in(mb88_0_i.r_in[15:12]),
    .r0_port_out(mb88_0_o.r_out[3:0]), .r1_port_out(mb88_0_o.r_out[7:4]), .r2_port_out(mb88_0_o.r_out[11:8]),
    .r3_port_out(mb88_0_o.r_out[15:12]),
    .k_port_in(mb88_0_i.k), .ol_port_out(mb88_0_o.o[3:0]), .oh_port_out(mb88_0_o.o[7:4]), .o_wr(mb88_0_o.o_wr),
    .p_port_out(mb88_0_o.p), .stby_n(1'b1), .tc_n(mb88_0_i.tc_n), .irq_n(mb88_0_i.irq_n), .sc_in_n(1'b1),
    .si_n(mb88_0_i.si_n), .sc_out_n(), .so_n(), .to_n(),
    .rom_addr(mb88_0_o.rom_a), .rom_data(mb88_0_i.rom_d)
);

mb88 mb88_1
(
    .clock(clk), .ena(mb88_1_i.ena), .reset_n(mb88_1_i.reset_n), .ram_clr(1'b0),
    .r0_port_in(mb88_1_i.r_in[3:0]), .r1_port_in(mb88_1_i.r_in[7:4]), .r2_port_in(mb88_1_i.r_in[11:8]),
    .r3_port_in(mb88_1_i.r_in[15:12]),
    .r0_port_out(mb88_1_o.r_out[3:0]), .r1_port_out(mb88_1_o.r_out[7:4]), .r2_port_out(mb88_1_o.r_out[11:8]),
    .r3_port_out(mb88_1_o.r_out[15:12]),
    .k_port_in(mb88_1_i.k), .ol_port_out(mb88_1_o.o[3:0]), .oh_port_out(mb88_1_o.o[7:4]), .o_wr(mb88_1_o.o_wr),
    .p_port_out(mb88_1_o.p), .stby_n(1'b1), .tc_n(mb88_1_i.tc_n), .irq_n(mb88_1_i.irq_n), .sc_in_n(1'b1),
    .si_n(mb88_1_i.si_n), .sc_out_n(), .so_n(), .to_n(),
    .rom_addr(mb88_1_o.rom_a), .rom_data(mb88_1_i.rom_d)
);

mb88 #(.IRQ_ENTRY_STALL(3)) mb88_2
(
    .clock(clk), .ena(mb88_2_i.ena), .reset_n(mb88_2_i.reset_n), .ram_clr(1'b0),
    .r0_port_in(mb88_2_i.r_in[3:0]), .r1_port_in(mb88_2_i.r_in[7:4]), .r2_port_in(mb88_2_i.r_in[11:8]),
    .r3_port_in(mb88_2_i.r_in[15:12]),
    .r0_port_out(mb88_2_o.r_out[3:0]), .r1_port_out(mb88_2_o.r_out[7:4]), .r2_port_out(mb88_2_o.r_out[11:8]),
    .r3_port_out(mb88_2_o.r_out[15:12]),
    .k_port_in(mb88_2_i.k), .ol_port_out(mb88_2_o.o[3:0]), .oh_port_out(mb88_2_o.o[7:4]), .o_wr(mb88_2_o.o_wr),
    .p_port_out(mb88_2_o.p), .stby_n(1'b1), .tc_n(mb88_2_i.tc_n), .irq_n(mb88_2_i.irq_n), .sc_in_n(1'b1),
    .si_n(mb88_2_i.si_n), .sc_out_n(), .so_n(), .to_n(),
    .rom_addr(mb88_2_o.rom_a), .rom_data(mb88_2_i.rom_d)
);

mb88 mb88_3
(
    .clock(clk), .ena(mb88_3_i.ena), .reset_n(mb88_3_i.reset_n), .ram_clr(1'b0),
    .r0_port_in(mb88_3_i.r_in[3:0]), .r1_port_in(mb88_3_i.r_in[7:4]), .r2_port_in(mb88_3_i.r_in[11:8]),
    .r3_port_in(mb88_3_i.r_in[15:12]),
    .r0_port_out(mb88_3_o.r_out[3:0]), .r1_port_out(mb88_3_o.r_out[7:4]), .r2_port_out(mb88_3_o.r_out[11:8]),
    .r3_port_out(mb88_3_o.r_out[15:12]),
    .k_port_in(mb88_3_i.k), .ol_port_out(mb88_3_o.o[3:0]), .oh_port_out(mb88_3_o.o[7:4]), .o_wr(mb88_3_o.o_wr),
    .p_port_out(mb88_3_o.p), .stby_n(1'b1), .tc_n(mb88_3_i.tc_n), .irq_n(mb88_3_i.irq_n), .sc_in_n(1'b1),
    .si_n(mb88_3_i.si_n), .sc_out_n(), .so_n(), .to_n(),
    .rom_addr(mb88_3_o.rom_a), .rom_data(mb88_3_i.rom_d)
);

// namco_54xx_snd_0: 54XX noise analog stage, Pole Position mode (polepos)
chip_pool_pkg::namco_54xx_snd_i_t namco_54xx_snd_0_i;
chip_pool_pkg::namco_54xx_snd_o_t namco_54xx_snd_0_o;

namco_54xx_snd #(.BOARD(1)) namco_54xx_snd_0
(
    .clk(clk), .reset(namco_54xx_snd_0_i.reset), .pause(pause),
    .o0_data(namco_54xx_snd_0_i.o0_data), .o1_data(namco_54xx_snd_0_i.o1_data), .r1_data(namco_54xx_snd_0_i.r1_data),
    .bosco(namco_54xx_snd_0_i.bosco), .ext_volts(namco_54xx_snd_0_i.ext_volts), .audio(namco_54xx_snd_0_o.audio)
);

// namco_wsg8_0: 8-voice WSG (polepos). Waveform PROM: ioctl index 2, 0x1040-0x113F (unaligned: subtract, 8-bit wrap is correct)
chip_pool_pkg::namco_wsg8_i_t namco_wsg8_0_i;
chip_pool_pkg::namco_wsg8_o_t namco_wsg8_0_o;
wire [15:0] namco_wsg8_0_audio;
wire        wsg_prom_wr   = ioctl_wr & (ioctl_index == 8'd2) & (ioctl_addr >= 25'h1040) & (ioctl_addr < 25'h1140);
wire  [7:0] wsg_prom_addr = ioctl_addr[7:0] - 8'h40;

namco_wsg8 namco_wsg8_0
(
    .clk(clk), .reset(namco_wsg8_0_i.reset), .sound_en(namco_wsg8_0_i.sound_en), .pause(pause),
    .reg_addr(namco_wsg8_0_i.reg_addr), .reg_din(namco_wsg8_0_i.reg_din), .reg_wr(namco_wsg8_0_i.reg_wr),
    .reg_dout(namco_wsg8_0_o.reg_dout),
    .wave_wr(wsg_prom_wr), .wave_addr(wsg_prom_addr), .wave_data(ioctl_dout), .audio(namco_wsg8_0_audio)
);
assign namco_wsg8_0_o.audio = namco_wsg8_0_audio;

// adc0804_0: pedal ADC (polepos)
chip_pool_pkg::adc0804_i_t adc0804_0_i;
chip_pool_pkg::adc0804_o_t adc0804_0_o;

adc0804 adc0804_0
(
    .clk(clk), .reset(adc0804_0_i.reset), .wr(adc0804_0_i.wr), .rd(adc0804_0_i.rd), .vin(adc0804_0_i.vin),
    .dout(adc0804_0_o.dout), .intr_n(adc0804_0_o.intr_n)
);

// tms5220rsws_0: bootleg speech board TMS5220 (polepos), 600 kHz (7.5 kHz samples)
chip_pool_pkg::tms5220rsws_i_t tms5220rsws_0_i;
chip_pool_pkg::tms5220rsws_o_t tms5220rsws_0_o;
logic signed [15:0] tms5220rsws_0_audio;

tms5220_rsws #(.CLK_HZ(49152000), .TMS_HZ(600000)) tms5220rsws_0
(
    .clk(clk), .reset(tms5220rsws_0_i.reset), .pause(tms5220rsws_0_i.pause),
    .rs_n(tms5220rsws_0_i.rs_n), .ws_n(tms5220rsws_0_i.ws_n), .d_in(tms5220rsws_0_i.d_in), .d_out(tms5220rsws_0_o.d_out),
    .ready_n(tms5220rsws_0_o.ready_n), .int_n(tms5220rsws_0_o.int_n), .audio(tms5220rsws_0_audio)
);
assign tms5220rsws_0_o.audio = tms5220rsws_0_audio;

/////////////////////////////  Shared ROM blocks  /////////////////////////////
// One block per region: every region is read in the same clock by its own consumer.

// rom0: main Z80 program, index 0 0x0000-0x2FFF
wire [13:0] prog_rom_a;
wire  [7:0] prog_rom_d;

dpram_dc #(.widthad_a(14)) rom0
(
    .clock_a(clk), .address_a(prog_rom_a), .q_a(prog_rom_d),
    .clock_b(clk), .address_b(dn_addr[13:0]), .data_b(ioctl_dout), .wren_b(ioctl_wr0 & (dn_addr[16:12] < 5'b00011))
);

// rom1 / rom2: game CPU 1 / 2 programs, index 0 0x3000 / 0xB000 (0x8000 each), big-endian words, hi / lo byte-split
wire [13:0] sub1_rom_a, sub2_rom_a;
wire [15:0] sub1_rom_d, sub2_rom_d;
reg  [7:0] rom1_hi [0:16383];
reg  [7:0] rom1_lo [0:16383];
reg  [7:0] rom2_hi [0:16383];
reg  [7:0] rom2_lo [0:16383];

localparam [24:0] SUB1_BASE = 25'h3000,  SUB1_LAST = 25'h0AFFF;
localparam [24:0] SUB2_BASE = 25'h0B000, SUB2_LAST = 25'h12FFF;

wire        sub1_ld_hit = ioctl_wr0 & ({8'd0, dn_addr} >= SUB1_BASE) & ({8'd0, dn_addr} <= SUB1_LAST);
wire        sub2_ld_hit = ioctl_wr0 & ({8'd0, dn_addr} >= SUB2_BASE) & ({8'd0, dn_addr} <= SUB2_LAST);
wire [24:0] sub1_ld_rel = {8'd0, dn_addr} - SUB1_BASE;
wire [24:0] sub2_ld_rel = {8'd0, dn_addr} - SUB2_BASE;
wire [13:0] sub1_ld_idx = sub1_ld_rel[14:1];
wire [13:0] sub2_ld_idx = sub2_ld_rel[14:1];
wire        sub1_ld_hi  = ~sub1_ld_rel[0];
wire        sub2_ld_hi  = ~sub2_ld_rel[0];

reg [7:0] rom1_hi_q, rom1_lo_q, rom2_hi_q, rom2_lo_q;
always @(posedge clk) begin
    if (sub1_ld_hit &  sub1_ld_hi) rom1_hi[sub1_ld_idx] <= ioctl_dout;
    if (sub1_ld_hit & ~sub1_ld_hi) rom1_lo[sub1_ld_idx] <= ioctl_dout;
    rom1_hi_q <= rom1_hi[sub1_rom_a];
    rom1_lo_q <= rom1_lo[sub1_rom_a];
end
always @(posedge clk) begin
    if (sub2_ld_hit &  sub2_ld_hi) rom2_hi[sub2_ld_idx] <= ioctl_dout;
    if (sub2_ld_hit & ~sub2_ld_hi) rom2_lo[sub2_ld_idx] <= ioctl_dout;
    rom2_hi_q <= rom2_hi[sub2_rom_a];
    rom2_lo_q <= rom2_lo[sub2_rom_a];
end
assign sub1_rom_d = {rom1_hi_q, rom1_lo_q};
assign sub2_rom_d = {rom2_hi_q, rom2_lo_q};

`ifdef VERILATOR
integer i;
initial begin
    for (i = 0; i < 8192; i = i + 1) begin
        rom1_hi[i] = 8'h00; rom1_lo[i] = 8'h00;
        rom2_hi[i] = 8'h00; rom2_lo[i] = 8'h00;
    end
end
`endif

// index 1 (padded to the region sizes): chars 0x00000 | tiles 0x02000 | sprites 0x04000 | road 0x18000 |
// scalelut 0x1D000
// rom3: alpha chars
wire [12:0] chars_gfx_addr;
reg  [7:0]  chars_gfx_data;
reg  [7:0]  chars_rom [0:8191];
wire        chars_wr = ioctl_wr & (ioctl_index == 8'd1) & (ioctl_addr < 25'h2000);
always @(posedge clk) begin
    if (chars_wr) chars_rom[ioctl_addr[12:0]] <= ioctl_dout;
    chars_gfx_data <= chars_rom[chars_gfx_addr];
end

// rom4: view tiles
wire [12:0] tiles_gfx_addr;
reg  [7:0]  tiles_gfx_data;
reg  [7:0]  tiles_rom [0:8191];
wire        tiles_wr = ioctl_wr & (ioctl_index == 8'd1) & (ioctl_addr >= 25'h2000) & (ioctl_addr < 25'h4000);
always @(posedge clk) begin
    if (tiles_wr) tiles_rom[ioctl_addr[12:0]] <= ioctl_dout;
    tiles_gfx_data <= tiles_rom[tiles_gfx_addr];
end

// rom5: road
wire [14:0] road_rom_addr;
reg  [7:0]  road_rom_data;
reg  [7:0]  road_rom [0:20479];
wire        road_wr = ioctl_wr & (ioctl_index == 8'd1) & (ioctl_addr >= 25'h18000) & (ioctl_addr < 25'h1D000);
always @(posedge clk) begin
    if (road_wr) road_rom[ioctl_addr - 25'h18000] <= ioctl_dout;
    road_rom_data <= road_rom[road_rom_addr];
end

// rom6: sprite scale table
wire [11:0] scalelut_addr;
reg  [7:0]  scalelut_data;
reg  [7:0]  scalelut_rom [0:4095];
wire        scalelut_wr = ioctl_wr & (ioctl_index == 8'd1) & (ioctl_addr >= 25'h1D000) & (ioctl_addr < 25'h1E000);
always @(posedge clk) begin
    if (scalelut_wr) scalelut_rom[ioctl_addr[11:0]] <= ioctl_dout;
    scalelut_data <= scalelut_rom[scalelut_addr];
end

// rom7: sprites + big sprites
wire [16:0] sprgfx_addr;
reg  [7:0]  sprgfx_data;
reg  [7:0]  sprite_rom [0:81919];
wire        sprite_wr = ioctl_wr & (ioctl_index == 8'd1) & (ioctl_addr >= 25'h4000) & (ioctl_addr < 25'h18000);
always @(posedge clk) begin
    if (sprite_wr) sprite_rom[ioctl_addr - 25'h4000] <= ioctl_dout;
    sprgfx_data <= sprite_rom[sprgfx_addr];
end

// rom8: 52XX voice samples (bootleg speech board: its Z80 program), index 5 0x4000-0xBFFF
wire [14:0] sample52_addr;
reg  [7:0]  sample52_data;
reg  [7:0]  sample52_rom [0:32767];
wire        sample52_wr = ioctl_wr & (ioctl_index == 8'd5) & (ioctl_addr >= 25'h4000) & (ioctl_addr < 25'hC000);
always @(posedge clk) begin
    if (sample52_wr) sample52_rom[ioctl_addr - 25'h4000] <= ioctl_dout;
    sample52_data <= sample52_rom[sample52_addr];
end

// rom9: engine waveforms, index 5 0x0000-0x3FFF (8 slots x 0x800)
wire [13:0] engine_addr;
reg  [7:0]  engine_data;
reg  [7:0]  engine_rom [0:16383];
wire        engine_wr = ioctl_wr & (ioctl_index == 8'd5) & (ioctl_addr < 25'h4000);
always @(posedge clk) begin
    if (engine_wr) engine_rom[ioctl_addr[13:0]] <= ioctl_dout;
    engine_data <= engine_rom[engine_addr];
end

// palette PROMs (index 2, 0x000-0xFFF) load into the board's palette pipelines
wire        prom_wr = ioctl_wr & (ioctl_index == 8'd2) & (ioctl_addr < 25'h1000);

/////////////////////////////  Shared RAM pool  /////////////////////////////

//   block 0  (2K)  polepos: NVRAM 0x3000-0x37FF (port B = hiscore; powers up all FF)
//   block 1  (1K)  polepos: sound work RAM 0x8000-0x83BF
//   block 2  (2K)  polepos: sprite RAM low byte    | block 3 (2K) high byte
//   block 4  (1K)  polepos: road RAM low byte      | block 5 (1K) high byte
//   block 6  (1K)  polepos: alpha RAM low byte     | block 7 (1K) high byte
//   block 8  (2K)  polepos: view RAM low byte      | block 9 (2K) high byte
//     (port A = Z80 / game CPU 1 / game CPU 2 time slots, port B = video scan-out)
//   block 10 (256) polepos: bootleg speech board RAM 0x2700-0x27FF
localparam int RAM_BLOCKS = 11;

ram_pool_pkg::pram_i_t [RAM_BLOCKS-1:0] pp_pr_i, pool_i;
ram_pool_pkg::pram_o_t [RAM_BLOCKS-1:0] pool_o;

assign pool_i = pp_pr_i;

function automatic int ram_aw(input int n);
    case (n)
        0, 2, 3, 8, 9: ram_aw = 11;
        10:            ram_aw = 8;
        default:       ram_aw = 10;
    endcase
endfunction

genvar pn;
generate
    for (pn = 0; pn < RAM_BLOCKS; pn = pn + 1) begin : rpool
        localparam int AW = ram_aw(pn);
        if (pn == 0) begin : g_nv
            dpram_dc #(.widthad_a(AW), .init_file("rtl/dispatcher/pp_nvram_ff.mif")) ram
            (
                .clock_a(clk), .address_a(pool_i[pn].a_addr[AW-1:0]), .data_a(pool_i[pn].a_d), .wren_a(pool_i[pn].a_we),
                .q_a(pool_o[pn].a_q),
                .clock_b(clk), .address_b(pool_i[pn].b_addr[AW-1:0]), .data_b(pool_i[pn].b_d), .wren_b(pool_i[pn].b_we),
                .q_b(pool_o[pn].b_q)
            );
        end else begin : g_ram
            dpram_dc #(.widthad_a(AW)) ram
            (
                .clock_a(clk), .address_a(pool_i[pn].a_addr[AW-1:0]), .data_a(pool_i[pn].a_d), .wren_a(pool_i[pn].a_we),
                .q_a(pool_o[pn].a_q),
                .clock_b(clk), .address_b(pool_i[pn].b_addr[AW-1:0]), .data_b(pool_i[pn].b_d), .wren_b(pool_i[pn].b_we),
                .q_b(pool_o[pn].b_q)
            );
        end
    end
endgenerate

/////////////////////////////  Boards  /////////////////////////////

chip_pool_pkg::z80r_i_t       pp_z80r_0_i, pp_z80r_1_i;
chip_pool_pkg::z8002_i_t      pp_z8002_0_i, pp_z8002_1_i;
chip_pool_pkg::namco_06xx_i_t pp_namco_06xx_0_i;
chip_pool_pkg::namco_51xx_i_t pp_namco_51xx_0_i;
chip_pool_pkg::namco_52xx_i_t pp_namco_52xx_0_i;
chip_pool_pkg::namco_53xx_i_t pp_namco_53xx_0_i;
chip_pool_pkg::namco_54xx_i_t pp_namco_54xx_0_i;
chip_pool_pkg::namco_54xx_snd_i_t pp_namco_54xx_snd_0_i;

poleposition polepos
(
    .clock_18(clk),
    .reset(reset),
    .wdog_en(wdog_en),
    .sub_illegal(sub_illegal),

    .ic25_en(pp_mod[0]),
    .bootleg_io(pp_mod[1]),
    .bootleg_snd(pp_mod[2]),

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

    .prom_wr(prom_wr),
    .prom_addr(ioctl_addr[11:0]),
    .prom_data(ioctl_dout),

    .prog_rom_a(prog_rom_a),
    .prog_rom_d(prog_rom_d),
    .sub1_rom_a(sub1_rom_a),
    .sub1_rom_d(sub1_rom_d),
    .sub2_rom_a(sub2_rom_a),
    .sub2_rom_d(sub2_rom_d),

    .video_r(video_r),
    .video_g(video_g),
    .video_b(video_b),
    .video_csync(),
    .video_blankn(),
    .video_hs(video_hs),
    .video_vs(video_vs),
    .video_en(video_en),
    .blank_h(blank_h),
    .blank_v(blank_v),

    .dip_switch_a(dip_switch_a),
    .dip_switch_b(dip_switch_b),

    .flip(flip),
    .h_offset(h_offset),
    .v_offset(v_offset),
    .diag_swatch(diag_swatch),

    .audio(audio),

    .self_test(self_test),
    .service(service),
    .coin1(coin1),
    .start1(start1),
    .fire1(fire1),
    .coin2(coin2),
    .start2(start2),

    .pause(pause),

    .steer_in(steer_in),
    .accel_in(accel_in),
    .brake_in(brake_in),

    .hs_address(hs_address),
    .hs_data_out(hs_data_out),
    .hs_data_in(hs_data_in),
    .hs_write(hs_write),

    .z80r_0_i(pp_z80r_0_i), .z80r_0_o(z80r_0_o),
    .z80r_1_i(pp_z80r_1_i), .z80r_1_o(z80r_1_o),
    .z8002_0_i(pp_z8002_0_i), .z8002_0_o(z8002_0_o),
    .z8002_1_i(pp_z8002_1_i), .z8002_1_o(z8002_1_o),
    .namco_06xx_0_i(pp_namco_06xx_0_i), .namco_06xx_0_o(namco_06xx_0_o),
    .namco_51xx_0_i(pp_namco_51xx_0_i), .namco_51xx_0_o(namco_51xx_0_o),
    .namco_52xx_0_i(pp_namco_52xx_0_i), .namco_52xx_0_o(namco_52xx_0_o),
    .namco_53xx_0_i(pp_namco_53xx_0_i), .namco_53xx_0_o(namco_53xx_0_o),
    .namco_54xx_0_i(pp_namco_54xx_0_i), .namco_54xx_0_o(namco_54xx_0_o),
    .namco_54xx_snd_0_i(pp_namco_54xx_snd_0_i), .namco_54xx_snd_0_o(namco_54xx_snd_0_o),

    .namco_wsg8_0_i(namco_wsg8_0_i), .namco_wsg8_0_o(namco_wsg8_0_o),
    .adc0804_0_i(adc0804_0_i), .adc0804_0_o(adc0804_0_o),

    .tms5220rsws_0_i(tms5220rsws_0_i), .tms5220rsws_0_o(tms5220rsws_0_o),

    .pr_i(pp_pr_i),
    .pr_o(pool_o)
);

assign z80r_0_i       = pp_z80r_0_i;
assign z80r_1_i       = pp_z80r_1_i;
assign z8002_0_i      = pp_z8002_0_i;
assign z8002_1_i      = pp_z8002_1_i;
assign namco_06xx_0_i = pp_namco_06xx_0_i;
assign namco_51xx_0_i = pp_namco_51xx_0_i;
assign namco_52xx_0_i = pp_namco_52xx_0_i;
assign namco_53xx_0_i = pp_namco_53xx_0_i;
assign namco_54xx_0_i = pp_namco_54xx_0_i;
assign namco_54xx_snd_0_i = pp_namco_54xx_snd_0_i;

endmodule

`default_nettype wire
