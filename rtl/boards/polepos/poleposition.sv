//---------------------------------------------------------------------------------
// Pole Position (adapted from Xevious) by Dar (darfpga@aol.fr)
// http://darfpga.blogspot.fr
//---------------------------------------------------------------------------------
// Pole Position / Pole Position II: CPU board, Namco 06xx + 51xx..54xx, sound, video.
//---------------------------------------------------------------------------------
// Educational use only. Do not redistribute synthetized file with roms.
//---------------------------------------------------------------------------------
`default_nettype none

module poleposition
(
    input  wire        clock_18,
    input  wire        reset,

    input  wire        wdog_en,         // watchdog enable (OSD); 0 = disabled
    output wire        sub_illegal,

    input  wire        ic25_en,
    input  wire        bootleg_io,
    input  wire        bootleg_snd,

    output wire [12:0] gfx_addr,
    input  wire  [7:0] gfx_data,
    output wire [12:0] view_gfx_addr,
    input  wire  [7:0] view_gfx_data,
    output wire [14:0] road_rom_addr,
    input  wire  [7:0] road_rom_data,
    output wire [11:0] scalelut_addr,
    input  wire  [7:0] scalelut_data,
    output wire [16:0] sprgfx_addr,
    input  wire  [7:0] sprgfx_data,

    output wire [14:0] sample52_addr,
    input  wire  [7:0] sample52_data,
    output wire [13:0] engine_addr,
    input  wire  [7:0] engine_data,

    input  wire        prom_wr,
    input  wire [11:0] prom_addr,
    input  wire  [7:0] prom_data,
    output wire [13:0] prog_rom_a,
    input  wire  [7:0] prog_rom_d,
    output wire [13:0] sub1_rom_a,
    input  wire [15:0] sub1_rom_d,
    output wire [13:0] sub2_rom_a,
    input  wire [15:0] sub2_rom_d,

    output reg   [3:0] video_r,
    output reg   [3:0] video_g,
    output reg   [3:0] video_b,
    output wire        video_csync,
    output wire        video_blankn,
    output wire        video_hs,
    output wire        video_vs,
    output wire        video_en,
    output wire        blank_h,
    output wire        blank_v,

    input  wire  [7:0] dip_switch_a,
    input  wire  [7:0] dip_switch_b,

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

    input  wire        pause,

    input  wire  [7:0] steer_in,

    input  wire  [7:0] accel_in,
    input  wire  [7:0] brake_in,

    input  wire [10:0] hs_address,
    output wire  [7:0] hs_data_out,
    input  wire  [7:0] hs_data_in,
    input  wire        hs_write,

    output chip_pool_pkg::z80r_i_t z80r_0_i,
    input  chip_pool_pkg::z80r_o_t z80r_0_o,
    output chip_pool_pkg::z80r_i_t z80r_1_i,
    input  chip_pool_pkg::z80r_o_t z80r_1_o,
    output chip_pool_pkg::z8002_i_t z8002_0_i,
    input  chip_pool_pkg::z8002_o_t z8002_0_o,
    output chip_pool_pkg::z8002_i_t z8002_1_i,
    input  chip_pool_pkg::z8002_o_t z8002_1_o,
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

    output chip_pool_pkg::namco_wsg8_i_t namco_wsg8_0_i,
    input  chip_pool_pkg::namco_wsg8_o_t namco_wsg8_0_o,
    output chip_pool_pkg::adc0804_i_t    adc0804_0_i,
    input  chip_pool_pkg::adc0804_o_t    adc0804_0_o,

    output chip_pool_pkg::tms5220rsws_i_t tms5220rsws_0_i,
    input  chip_pool_pkg::tms5220rsws_o_t tms5220rsws_0_o,

    output ram_pool_pkg::pram_i_t [10:0] pr_i,
    input  ram_pool_pkg::pram_o_t [10:0] pr_o
);

    reg  [3:0] cen_cnt = 4'd0;
    always @(posedge clock_18)
        if (reset) cen_cnt <= 4'd0;
        else       cen_cnt <= cen_cnt + 4'd1;
    wire cen = (cen_cnt == 4'd0);

    reg  [2:0] slot = 3'd0;
    reg        ena_vidgen = 1'b0;
    always @(posedge clock_18) begin
        slot       <= slot + 3'd1;
        ena_vidgen <= (slot == 3'b111);
    end

    reg  [3:0] mcu_div_cnt = 4'd0;
    localparam [3:0] MCU_CEN_DIV = 4'd12;
    always @(posedge clock_18)
        if (reset)    mcu_div_cnt <= 4'd0;
        else if (cen) mcu_div_cnt <= (mcu_div_cnt == MCU_CEN_DIV - 4'd1) ? 4'd0 : mcu_div_cnt + 4'd1;
    wire mcu_ena = cen & (mcu_div_cnt == MCU_CEN_DIV - 4'd1) & ~pause;

    wire [8:0] hcnt, vcnt;
    wire       vblank;
    wire [3:0] bru_r, bru_g, bru_b;
    assign blank_v  = vblank;
    assign video_en = ena_vidgen;

    gen_video u_gen_video
    (
        .clk(clock_18), .enable(ena_vidgen), .hcnt(hcnt), .vcnt(vcnt),
        .hsync(video_hs), .vsync(video_vs), .csync(video_csync),
        .blank_h(blank_h), .blank_v(vblank), .blankn(video_blankn),
        .h_offset(h_offset), .v_offset(v_offset)
    );

    wire [10:0] alpha_scan_addr, view_scan_addr, sprite_scan_addr;
    wire  [9:0] road_scan_addr;
    wire [15:0] alpha_scan_dout, view_scan_dout, road_scan_dout, sprite_scan_dout;
    wire [15:0] hscroll, road_vscroll;
    wire        chacl;

    pp_video_composite u_video_composite
    (
        .clk(clock_18), .ce(ena_vidgen), .hpos(hcnt), .vpos(vcnt),
        .chacl(chacl), .diag_swatch(diag_swatch),
        .alpha_scan_addr(alpha_scan_addr), .alpha_scan_dout(alpha_scan_dout),
        .alpha_gfx_addr(gfx_addr), .alpha_gfx_data(gfx_data),
        .view_scan_addr(view_scan_addr), .view_scan_dout(view_scan_dout),
        .view_gfx_addr(view_gfx_addr), .view_gfx_data(view_gfx_data), .view_hscroll(hscroll),
        .road_scan_addr(road_scan_addr), .road_scan_dout(road_scan_dout),
        .road_rom_addr(road_rom_addr), .road_rom_data(road_rom_data), .road_vscroll(road_vscroll),
        .sprite_scan_addr(sprite_scan_addr), .sprite_scan_dout(sprite_scan_dout),
        .scalelut_addr(scalelut_addr), .scalelut_data(scalelut_data),
        .sprgfx_addr(sprgfx_addr), .sprgfx_data(sprgfx_data),
        .prom_wr(prom_wr), .prom_addr(prom_addr), .prom_data(prom_data),
        .r(bru_r), .g(bru_g), .b(bru_b)
    );

    always @(posedge clock_18) begin
        video_r <= bru_r;
        video_g <= bru_g;
        video_b <= bru_b;
    end

    wire       wdog_reset;
    wire       cpu_reset = reset | wdog_reset;

    wire [7:0] n06_dout, n06_din;
    wire       n06_data_wr, n06_data_rd, n06_ctrl_wr, n06_ctrl_rd, n06_nmi_n;
    wire       sb0, namco_reset, sound_en, gasel;
    wire [5:0] wsg_addr;
    wire [7:0] wsg_dout, wsg_din;
    wire       wsg_wr;
    wire [7:0] engine_dout;
    wire       engine_lsb_wr, engine_msb_wr;
    wire       adc_wr, adc_rd;
    wire [7:0] adc_din    = adc0804_0_o.dout;
    wire       adc_intr_n = adc0804_0_o.intr_n;
    wire       watchdog_wr;
    wire [3:0] bl_dac;
    wire [7:0] bl_latch;
    wire       bl_latch_wr;
    wire [7:0] bl_in0;

    PolePosition_CPU u_pp_cpu
    (
        .clk(clock_18), .cen(cen), .reset(cpu_reset), .pause(pause), .vpos(vcnt),
        .sub1_reset_n(), .sub2_reset_n(), .namco_reset(namco_reset), .sound_en(sound_en),
        .gasel(gasel), .sb0(sb0), .chacl(chacl), .sub_nvi_trig(),
        .vram_addr(), .vram_dout(), .vram_wr(), .vram_rd(), .vram_din(8'd0),
        .n06_dout(n06_dout), .n06_data_wr(n06_data_wr), .n06_data_rd(n06_data_rd),
        .n06_ctrl_wr(n06_ctrl_wr), .n06_ctrl_rd(n06_ctrl_rd), .n06_din(n06_din), .n06_nmi_n(n06_nmi_n),
        .wsg_addr(wsg_addr), .wsg_dout(wsg_dout), .wsg_wr(wsg_wr), .wsg_rd(), .wsg_din(wsg_din),
        .engine_dout(engine_dout), .engine_lsb_wr(engine_lsb_wr), .engine_msb_wr(engine_msb_wr),
        .adc_wr(adc_wr), .adc_rd(adc_rd), .adc_din(adc_din), .adc_intr_n(adc_intr_n),
        .watchdog_wr(watchdog_wr), .sub_illegal(sub_illegal),
        .prog_rom_a(prog_rom_a), .prog_rom_d(prog_rom_d),
        .sub1_rom_a(sub1_rom_a), .sub1_rom_d(sub1_rom_d), .sub2_rom_a(sub2_rom_a), .sub2_rom_d(sub2_rom_d),
        .z80r_0_i(z80r_0_i), .z80r_0_o(z80r_0_o),
        .z8002_0_i(z8002_0_i), .z8002_0_o(z8002_0_o), .z8002_1_i(z8002_1_i), .z8002_1_o(z8002_1_o),
        .nv_pr_i(pr_i[0]), .nv_pr_o(pr_o[0]), .snd_pr_i(pr_i[1]), .snd_pr_o(pr_o[1]),
        .vr_i(pr_i[9:2]), .vr_o(pr_o[9:2]),
        .ic25_en(ic25_en),
        .bootleg_io(bootleg_io), .bl_steer(steer_in), .bl_in0(bl_in0), .bl_dswa(dip_switch_a), .bl_dswb(dip_switch_b),
        .bl_dac(bl_dac), .bl_latch(bl_latch), .bl_latch_wr(bl_latch_wr),
        .scan_sprite_addr(sprite_scan_addr), .scan_sprite_dout(sprite_scan_dout),
        .scan_road_addr(road_scan_addr), .scan_road_dout(road_scan_dout),
        .scan_alpha_addr(alpha_scan_addr[9:0]), .scan_alpha_dout(alpha_scan_dout),
        .scan_view_addr(view_scan_addr), .scan_view_dout(view_scan_dout),
        .hscroll(hscroll), .vscroll(road_vscroll),
        .hs_address(hs_address), .hs_data_out(hs_data_out), .hs_data_in(hs_data_in), .hs_write(hs_write)
    );

    pp_watchdog u_watchdog
    (
        .clk(clock_18), .reset(reset), .wdog_en(wdog_en), .vpos(vcnt),
        .kick(watchdog_wr), .pause(pause), .wdog_reset(wdog_reset)
    );

    assign adc0804_0_i.reset = reset;
    assign adc0804_0_i.wr    = adc_wr;
    assign adc0804_0_i.rd    = adc_rd;
    assign adc0804_0_i.vin   = gasel ? accel_in : brake_in;

    wire [15:0] wsg_audio = namco_wsg8_0_o.audio;
    wire [15:0] engine_audio, voice_audio, noise_audio, bs_audio;
    wire  [3:0] n52_p, n54_o0, n54_o1, n54_r1;
    wire [14:0] n52_sample_addr, bs_rom_addr;

    assign namco_wsg8_0_i.reset    = reset;
    assign namco_wsg8_0_i.sound_en = sound_en;
    assign namco_wsg8_0_i.reg_addr = wsg_addr;
    assign namco_wsg8_0_i.reg_din  = wsg_dout;
    assign namco_wsg8_0_i.reg_wr   = wsg_wr;
    assign wsg_din                 = namco_wsg8_0_o.reg_dout;

    pp_engine_snd u_engine
    (
        .clk(clock_18), .reset(reset), .pause(pause), .clson(sound_en),
        .lsb_wr(engine_lsb_wr), .msb_wr(engine_msb_wr), .din(engine_dout),
        .rom_addr(engine_addr), .rom_data(engine_data), .audio(engine_audio)
    );

    pp_voice52_snd u_voice52 (.clk(clock_18), .reset(reset), .pause(pause), .p_data(n52_p), .audio(voice_audio));

    assign namco_54xx_snd_0_i.reset     = reset;
    assign namco_54xx_snd_0_i.o0_data   = n54_o0;
    assign namco_54xx_snd_0_i.o1_data   = n54_o1;
    assign namco_54xx_snd_0_i.r1_data   = n54_r1;
    assign namco_54xx_snd_0_i.bosco     = 1'b0;
    assign namco_54xx_snd_0_i.ext_volts = 32'sd0;
    assign noise_audio = namco_54xx_snd_0_o.audio;

    pp_bootleg_snd u_bootleg_snd
    (
        .clk(clock_18), .cen(cen), .reset(cpu_reset | ~bootleg_snd), .pause(pause),
        .latch_wr(bl_latch_wr & bootleg_snd), .latch_din(bl_latch),
        .rom_addr(bs_rom_addr), .rom_data(sample52_data), .audio(bs_audio),
        .z80r_1_i(z80r_1_i), .z80r_1_o(z80r_1_o), .bs_pr_i(pr_i[10]), .bs_pr_o(pr_o[10]),
        .tms5220rsws_0_i(tms5220rsws_0_i), .tms5220rsws_0_o(tms5220rsws_0_o)
    );
    assign sample52_addr = bootleg_snd ? bs_rom_addr : n52_sample_addr;

    wire signed [24:0] wsg_gain   = $signed(wsg_audio)   * $signed(9'sd205);
    wire signed [24:0] voice_gain = $signed(voice_audio) * $signed(9'sd230);
    wire signed [24:0] bs_gain    = $signed(bs_audio)    * $signed(9'sd102);
    wire signed  [4:0] bl_dac_c   = $signed({1'b0, bl_dac}) - 5'sd8;
    wire signed [15:0] bl_dac_p   = bl_dac_c * $signed(11'sd492);
    wire signed [24:0] wsg_sh     = wsg_gain   >>> 7;
    wire signed [24:0] voice_sh   = voice_gain >>> 8;
    wire signed [24:0] bs_sh      = bs_gain    >>> 8;
    wire signed [17:0] bl_dac_s   = bootleg_io  ? {{2{bl_dac_p[15]}}, bl_dac_p} : 18'sd0;
    wire signed [17:0] bs_audio_s = bootleg_snd ? bs_sh[17:0] : 18'sd0;
    wire signed [17:0] audio_mix  = wsg_sh[17:0]
                                  + {{2{engine_audio[15]}}, engine_audio}
                                  + voice_sh[17:0]
                                  + {{2{noise_audio[15]}}, noise_audio}
                                  + bl_dac_s
                                  + bs_audio_s;
    assign audio = (audio_mix >  18'sd32767) ? 16'h7FFF :
                   (audio_mix < -18'sd32768) ? 16'h8000 : audio_mix[15:0];

    wire       mcu_reset_n = ~reset & namco_reset;

    wire [7:0] in0_byte = {~self_test, ~service, ~coin2, ~coin1, 1'b1, sb0, ~fire1, 1'b1};
    assign bl_in0 = {~self_test, ~coin1, ~fire1, 1'b1, 1'b0, 3'b111};
    wire [7:0] in0_51xx  = bootleg_io ? {bl_in0[7:4], 4'h0} : in0_byte;
    wire [7:0] dswb_51xx = bootleg_io ? 8'h00 : dip_switch_b;

    wire [3:0] n06_chipsel, n06_chip_wr;
    wire       n06_rw0;
    wire [7:0] n06_chip_dout, chip0_din, chip1_din;
    wire [3:0] n06_chipsel_g = {n06_chipsel[3:1] & {3{~bootleg_io}}, n06_chipsel[0]};
    wire [3:0] n06_chip_wr_g = {n06_chip_wr[3:1] & {3{~bootleg_io}}, n06_chip_wr[0]};

    assign namco_06xx_0_i.reset = reset;
    assign namco_06xx_0_i.irq_on_access = 1'b0;
    assign namco_06xx_0_i.cpu_dout = n06_dout;
    assign namco_06xx_0_i.data_wr = n06_data_wr;
    assign namco_06xx_0_i.data_rd = n06_data_rd;
    assign namco_06xx_0_i.ctrl_wr = n06_ctrl_wr;
    assign namco_06xx_0_i.ctrl_rd = n06_ctrl_rd;
    assign namco_06xx_0_i.chip0_din = chip0_din;
    assign namco_06xx_0_i.chip1_din = bootleg_io ? 8'hFF : chip1_din;
    assign namco_06xx_0_i.chip2_din = 8'hFF;
    assign namco_06xx_0_i.chip3_din = 8'hFF;
    assign n06_din       = namco_06xx_0_o.cpu_din;
    assign n06_nmi_n     = namco_06xx_0_o.nmi_n;
    assign n06_chipsel   = namco_06xx_0_o.chipsel;
    assign n06_rw0       = namco_06xx_0_o.rw0;
    assign n06_chip_dout = namco_06xx_0_o.chip_dout;
    assign n06_chip_wr   = namco_06xx_0_o.chip_wr;

    assign namco_51xx_0_i.ena = mcu_ena;
    assign namco_51xx_0_i.reset_n = mcu_reset_n;
    assign namco_51xx_0_i.chip_sel = n06_chipsel[0];
    assign namco_51xx_0_i.rw_in = n06_rw0;
    assign namco_51xx_0_i.wr_en = n06_chip_wr[0];
    assign namco_51xx_0_i.wr_data = n06_chip_dout;
    assign namco_51xx_0_i.in_a = dswb_51xx;
    assign namco_51xx_0_i.in_b = in0_51xx;
    assign namco_51xx_0_i.vblank = vblank;
    assign chip0_din = namco_51xx_0_o.data_out;

    reg  [7:0]        steer_last;
    reg  signed [8:0] steer_accum;
    reg               steer_delta;
    wire signed [8:0] steer_diff2 = ($signed({1'b0, steer_in}) - $signed({1'b0, steer_last})) <<< 1;
    wire signed [8:0] steer_pre   = steer_accum + steer_diff2;
    always @(posedge clock_18) begin
        if (!mcu_reset_n) begin
            steer_last  <= 8'h00;
            steer_accum <= 9'sd0;
            steer_delta <= 1'b0;
        end else if (mcu_ena) begin
            steer_last <= steer_in;
            if (steer_pre < 0) begin
                steer_delta <= 1'b0;
                steer_accum <= steer_pre + 9'sd1;
            end else if (steer_pre > 0) begin
                steer_delta <= 1'b1;
                steer_accum <= steer_pre - 9'sd1;
            end else begin
                steer_accum <= steer_pre;
            end
        end
    end

    assign namco_53xx_0_i = '{ena: mcu_ena, reset_n: mcu_reset_n, chip_sel: n06_chipsel_g[1], k_in: 4'h0,
                              in_a: {3'b000, steer_delta, 3'b000, steer_accum[0]}, in_b: dip_switch_a};
    assign chip1_din = namco_53xx_0_o.data_out;

    assign namco_54xx_0_i = '{ena: mcu_ena, reset_n: mcu_reset_n, chip_sel: n06_chipsel_g[3], wr_en: n06_chip_wr_g[3],
                              wr_data: n06_chip_dout};
    assign n54_o0 = namco_54xx_0_o.discrete_o0;
    assign n54_o1 = namco_54xx_0_o.discrete_o1;
    assign n54_r1 = namco_54xx_0_o.discrete_r1;

    wire [15:0] n52_addr16 = namco_52xx_0_o.sample_addr;
    assign namco_52xx_0_i = '{ena: mcu_ena, reset_n: mcu_reset_n, chip_sel: n06_chipsel_g[2], wr_en: n06_chip_wr_g[2],
                              wr_data: n06_chip_dout, si: 1'b1, tc_n: 1'b1,
                              sample_data: n52_addr16[15] ? 8'hFF : sample52_data};
    assign n52_p           = namco_52xx_0_o.p_out;
    assign n52_sample_addr = n52_addr16[14:0];

endmodule

`default_nettype wire
