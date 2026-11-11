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

    input  wire [16:0] dn_addr,
    input  wire  [7:0] dn_data,
    input  wire        dn_wr,

    input  wire        ic25_en,         // PP2 IC25 protection custom (MRA mod byte bit 0)
    input  wire        bootleg_io,      // bootleg I/O board, machine topracern / polepos2bi (bit 1)
    input  wire        bootleg_snd,     // bootleg speech board, sound Z80 + TMS5220 (bit 2)

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

    output wire [14:0] sample52_addr,   // 52xx voice ROM (ioctl index 5 +0x4000, 0x8000 bytes)
    input  wire  [7:0] sample52_data,
    output wire [13:0] engine_addr,     // engine waveform ROM (ioctl index 5, 0x0000-0x3FFF)
    input  wire  [7:0] engine_data,

    input  wire        prom_wr,         // palette PROMs (ioctl index 2, 0x000-0xFFF)
    input  wire [11:0] prom_addr,
    input  wire  [7:0] prom_data,
    input  wire        wsg_prom_wr,     // WSG waveform PROM (ioctl index 2)
    input  wire  [7:0] wsg_prom_addr,
    input  wire  [7:0] wsg_prom_data,

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
    input  wire        fire1,           // Gear Change
    input  wire        coin2,
    input  wire        start2,

    input  wire        pause,

    input  wire  [7:0] steer_in,        // steering dial
    input  wire        mcu_rom_wr,      // MB88 ROMs (ioctl index 6: 51xx 0x000, 53xx 0x400, 54xx 0x800)
    input  wire [11:0] mcu_rom_addr,
    input  wire  [7:0] mcu_rom_data,

    input  wire  [7:0] accel_in,        // ADC accelerator / brake (MAME ACCEL / BRAKE, 0..0x90)
    input  wire  [7:0] brake_in,

    input  wire [10:0] hs_address,
    output wire  [7:0] hs_data_out,
    input  wire  [7:0] hs_data_in,
    input  wire        hs_write
);

    // ---- clock enables ----
    reg  [3:0] cen_cnt = 4'd0;           // Z80 / Z8002: clock_18 / 16
    always @(posedge clock_18)
        if (reset) cen_cnt <= 4'd0;
        else       cen_cnt <= cen_cnt + 4'd1;
    wire cen = (cen_cnt == 4'd0);

    reg  [2:0] slot = 3'd0;              // pixel: 1-in-8 of 49.152 MHz = 6.144 MHz (MAME MASTER_CLOCK/4)
    reg        ena_vidgen = 1'b0;
    always @(posedge clock_18) begin
        slot       <= slot + 3'd1;
        ena_vidgen <= (slot == 3'b111);
    end

    reg  [3:0] mcu_div_cnt = 4'd0;       // Namco MCUs: cen/12 = 256 kHz, the MB88 machine-cycle rate
    localparam [3:0] MCU_CEN_DIV = 4'd12;
    always @(posedge clock_18)
        if (reset)    mcu_div_cnt <= 4'd0;
        else if (cen) mcu_div_cnt <= (mcu_div_cnt == MCU_CEN_DIV - 4'd1) ? 4'd0 : mcu_div_cnt + 4'd1;
    wire mcu_ena = cen & (mcu_div_cnt == MCU_CEN_DIV - 4'd1) & ~pause;

    // ---- video ----
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

    // compositor: view / road, sprites, alpha (MAME screen_update)
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

    // ---- CPU board: Z80 + 2x Z8002 + shared video RAM ----
    wire       wdog_reset;
    wire       cpu_reset = reset | wdog_reset;   // the watchdog resets the CPU board only
    wire       cpu_rom_wr = dn_wr & (dn_addr[16:12] < 5'b00011);   // maincpu region < 0x3000

    wire [7:0] n06_dout, n06_din;
    wire       n06_data_wr, n06_data_rd, n06_ctrl_wr, n06_ctrl_rd, n06_nmi_n;
    wire       sb0, namco_reset, sound_en, gasel;
    wire [5:0] wsg_addr;
    wire [7:0] wsg_dout, wsg_din;
    wire       wsg_wr;
    wire [7:0] engine_dout;
    wire       engine_lsb_wr, engine_msb_wr;
    wire       adc_wr, adc_rd, adc_intr_n;
    wire [7:0] adc_din;
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
        .ioctl_addr({8'd0, dn_addr}), .ioctl_data(dn_data), .rom_wr(cpu_rom_wr), .ioctl_wr_idx0(dn_wr),
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

    adc0804 u_adc
    (
        .clk(clock_18), .reset(reset), .wr(adc_wr), .rd(adc_rd),
        .vin(gasel ? accel_in : brake_in), .dout(adc_din), .intr_n(adc_intr_n)
    );

    // ---- sound ----
    wire [15:0] wsg_audio, engine_audio, voice_audio, noise_audio, bs_audio;
    wire  [3:0] n52_p, n54_o0, n54_o1, n54_r1;
    wire [14:0] n52_sample_addr, bs_rom_addr;

    namco_wsg8 u_wsg
    (
        .clk(clock_18), .reset(reset), .sound_en(sound_en), .pause(pause),
        .reg_addr(wsg_addr), .reg_din(wsg_dout), .reg_wr(wsg_wr), .reg_dout(wsg_din),
        .wave_wr(wsg_prom_wr), .wave_addr(wsg_prom_addr), .wave_data(wsg_prom_data), .audio(wsg_audio)
    );

    pp_engine_snd u_engine
    (
        .clk(clock_18), .reset(reset), .pause(pause), .clson(sound_en),
        .lsb_wr(engine_lsb_wr), .msb_wr(engine_msb_wr), .din(engine_dout),
        .rom_addr(engine_addr), .rom_data(engine_data), .audio(engine_audio)
    );

    pp_voice52_snd u_voice52 (.clk(clock_18), .reset(reset), .pause(pause), .p_data(n52_p), .audio(voice_audio));

    pp_noise54_snd u_noise54
    (
        .clk(clock_18), .reset(reset), .pause(pause),
        .o0_data(n54_o0), .o1_data(n54_o1), .r1_data(n54_r1), .audio(noise_audio)
    );

    // bootleg speech board; its Z80 program sits in the (absent) 52xx's voice-ROM slot
    pp_bootleg_snd u_bootleg_snd
    (
        .clk(clock_18), .cen(cen), .reset(cpu_reset | ~bootleg_snd), .pause(pause),
        .latch_wr(bl_latch_wr & bootleg_snd), .latch_din(bl_latch),
        .rom_addr(bs_rom_addr), .rom_data(sample52_data), .audio(bs_audio),
        .tms_wr_data(), .tms_wr_strobe()
    );
    assign sample52_addr = bootleg_snd ? bs_rom_addr : n52_sample_addr;

    // mix gains (MAME routes): WSG 0.80 x2 (music level), 52xx 0.90, speech 0.80 front-only -> 0.40,
    // bootleg 4-bit DAC (v - 8) at 0.12 of full scale; engine and 54xx are scaled in their modules
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

    // ---- Namco 06xx + 51xx..54xx ----
    wire       mcu_reset_n = ~reset & namco_reset;   // Namco MCUs: system reset or LS259 q1

    // IN0 (active low): b7 test, b6 service, b5 coin2, b4 coin1, b2 auto start (follows sb0), b1 gear
    wire [7:0] in0_byte = {~self_test, ~service, ~coin2, ~coin1, 1'b1, sb0, ~fire1, 1'b1};
    // bootleg I/O board IN0 (active low): b7 test, b6 coin1, b5 gear; its 51xx sees only IN0>>4 (MAME)
    assign bl_in0 = {~self_test, ~coin1, ~fire1, 1'b1, 1'b0, 3'b111};
    wire [7:0] in0_51xx  = bootleg_io ? {bl_in0[7:4], 4'h0} : in0_byte;
    wire [7:0] dswb_51xx = bootleg_io ? 8'h00 : dip_switch_b;

    wire [3:0] n06_chipsel, n06_chip_wr;
    wire       n06_rw0;
    wire [7:0] n06_chip_dout, chip0_din, chip1_din;
    // the bootleg board has no 53xx/52xx/54xx: chips 1-3 deselected, chip 1 reads FF
    wire [3:0] n06_chipsel_g = {n06_chipsel[3:1] & {3{~bootleg_io}}, n06_chipsel[0]};
    wire [3:0] n06_chip_wr_g = {n06_chip_wr[3:1] & {3{~bootleg_io}}, n06_chip_wr[0]};

    namco_06xx u_n06xx
    (
        .clk(clock_18), .reset(reset), .pause(pause),
        .cpu_dout(n06_dout), .data_wr(n06_data_wr), .data_rd(n06_data_rd),
        .ctrl_wr(n06_ctrl_wr), .ctrl_rd(n06_ctrl_rd), .cpu_din(n06_din), .nmi_n(n06_nmi_n),
        .chipsel(n06_chipsel), .rw0(n06_rw0),
        .chip0_din(chip0_din), .chip1_din(bootleg_io ? 8'hFF : chip1_din),
        .chip2_din(8'hFF), .chip3_din(8'hFF),       // 52xx/54xx have no read callback (MAME)
        .chip_dout(n06_chip_dout), .chip_wr(n06_chip_wr)
    );

    // 51xx = chips-repo namco_51xx + its MB88 (no MB88 pool in this core yet); ROM slice 0x000-0x3FF of index 6
    chip_pool_pkg::mb88_i_t n51_mb88_i;
    chip_pool_pkg::mb88_o_t n51_mb88_o;
    namco_51xx u_n51xx
    (
        .clk(clock_18), .ena(mcu_ena), .reset_n(mcu_reset_n),
        .chip_sel(n06_chipsel[0]), .rw_in(n06_rw0), .data_out(chip0_din),
        .wr_en(n06_chip_wr[0]), .wr_data(n06_chip_dout),
        .in_a(dswb_51xx), .in_b(in0_51xx), .p_port_out(),
        .rom_wr(mcu_rom_wr && mcu_rom_addr[11:10] == 2'b00), .rom_addr_in(mcu_rom_addr[9:0]), .rom_data_in(mcu_rom_data),
        .vblank(vblank),
        .mb88_i(n51_mb88_i), .mb88_o(n51_mb88_o)
    );

    wire  [3:0] n51m_r0, n51m_r1, n51m_r2, n51m_r3, n51m_ol, n51m_oh, n51m_p;
    wire        n51m_owr;
    wire [10:0] n51m_rom_a;
    mb88 u_n51_mcu
    (
        .clock(clock_18), .ena(n51_mb88_i.ena), .reset_n(n51_mb88_i.reset_n), .ram_clr(1'b0),
        .r0_port_in(n51_mb88_i.r_in[3:0]), .r1_port_in(n51_mb88_i.r_in[7:4]), .r2_port_in(n51_mb88_i.r_in[11:8]),
        .r3_port_in(n51_mb88_i.r_in[15:12]),
        .r0_port_out(n51m_r0), .r1_port_out(n51m_r1), .r2_port_out(n51m_r2), .r3_port_out(n51m_r3),
        .k_port_in(n51_mb88_i.k), .ol_port_out(n51m_ol), .oh_port_out(n51m_oh), .o_wr(n51m_owr), .p_port_out(n51m_p),
        .stby_n(1'b1), .tc_n(n51_mb88_i.tc_n), .irq_n(n51_mb88_i.irq_n), .sc_in_n(1'b1), .si_n(n51_mb88_i.si_n),
        .sc_out_n(), .so_n(), .to_n(),
        .rom_addr(n51m_rom_a), .rom_data(n51_mb88_i.rom_d)
    );
    assign n51_mb88_o.r_out = {n51m_r3, n51m_r2, n51m_r1, n51m_r0};
    assign n51_mb88_o.o     = {n51m_oh, n51m_ol};
    assign n51_mb88_o.o_wr  = n51m_owr;
    assign n51_mb88_o.p     = n51m_p;
    assign n51_mb88_o.rom_a = n51m_rom_a;

    // 53xx steering inputs: R0 = changed bit, R1 = direction, from the dial; the accumulator steps every MCU clock
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

    // 53xx = chips-repo namco_53xx + its MB88 (no MB88 pool in this core yet); ROM slice 0x400-0x7FF of index 6
    chip_pool_pkg::mb88_i_t n53_mb88_i;
    chip_pool_pkg::mb88_o_t n53_mb88_o;
    namco_53xx u_n53xx
    (
        .clk(clock_18), .ena(mcu_ena), .reset_n(mcu_reset_n),
        .chip_sel(n06_chipsel_g[1]), .data_out(chip1_din),
        .k_in(4'h0), .in_a({3'b000, steer_delta, 3'b000, steer_accum[0]}), .in_b(dip_switch_a),
        .rom_wr(mcu_rom_wr && mcu_rom_addr[11:10] == 2'b01), .rom_addr_in(mcu_rom_addr[9:0]), .rom_data_in(mcu_rom_data),
        .mb88_i(n53_mb88_i), .mb88_o(n53_mb88_o)
    );

    wire  [3:0] n53m_r0, n53m_r1, n53m_r2, n53m_r3, n53m_ol, n53m_oh, n53m_p;
    wire        n53m_owr;
    wire [10:0] n53m_rom_a;
    mb88 u_n53_mcu
    (
        .clock(clock_18), .ena(n53_mb88_i.ena), .reset_n(n53_mb88_i.reset_n), .ram_clr(1'b0),
        .r0_port_in(n53_mb88_i.r_in[3:0]), .r1_port_in(n53_mb88_i.r_in[7:4]), .r2_port_in(n53_mb88_i.r_in[11:8]),
        .r3_port_in(n53_mb88_i.r_in[15:12]),
        .r0_port_out(n53m_r0), .r1_port_out(n53m_r1), .r2_port_out(n53m_r2), .r3_port_out(n53m_r3),
        .k_port_in(n53_mb88_i.k), .ol_port_out(n53m_ol), .oh_port_out(n53m_oh), .o_wr(n53m_owr), .p_port_out(n53m_p),
        .stby_n(1'b1), .tc_n(n53_mb88_i.tc_n), .irq_n(n53_mb88_i.irq_n), .sc_in_n(1'b1), .si_n(n53_mb88_i.si_n),
        .sc_out_n(), .so_n(), .to_n(),
        .rom_addr(n53m_rom_a), .rom_data(n53_mb88_i.rom_d)
    );
    assign n53_mb88_o.r_out = {n53m_r3, n53m_r2, n53m_r1, n53m_r0};
    assign n53_mb88_o.o     = {n53m_oh, n53m_ol};
    assign n53_mb88_o.o_wr  = n53m_owr;
    assign n53_mb88_o.p     = n53m_p;
    assign n53_mb88_o.rom_a = n53m_rom_a;

    // 54xx = chips-repo namco_54xx + its MB88 (no MB88 pool in this core yet); ROM slice 0x800-0xBFF of index 6
    chip_pool_pkg::mb88_i_t n54_mb88_i;
    chip_pool_pkg::mb88_o_t n54_mb88_o;
    namco_54xx u_n54xx
    (
        .clk(clock_18), .ena(mcu_ena), .reset_n(mcu_reset_n),
        .chip_sel(n06_chipsel_g[3]), .wr_en(n06_chip_wr_g[3]), .wr_data(n06_chip_dout),
        .discrete_o0(n54_o0), .discrete_o1(n54_o1), .discrete_r1(n54_r1),
        .rom_wr(mcu_rom_wr && mcu_rom_addr[11:10] == 2'b10), .rom_addr_in(mcu_rom_addr[9:0]), .rom_data_in(mcu_rom_data),
        .mb88_i(n54_mb88_i), .mb88_o(n54_mb88_o)
    );

    wire  [3:0] n54_r0, n54_r1o, n54_r2, n54_r3, n54_ol, n54_oh, n54_p;
    wire        n54_owr;
    wire [10:0] n54_rom_a;
    mb88 #(.IRQ_ENTRY_STALL(3)) u_n54_mcu
    (
        .clock(clock_18), .ena(n54_mb88_i.ena), .reset_n(n54_mb88_i.reset_n), .ram_clr(1'b0),
        .r0_port_in(n54_mb88_i.r_in[3:0]), .r1_port_in(n54_mb88_i.r_in[7:4]), .r2_port_in(n54_mb88_i.r_in[11:8]),
        .r3_port_in(n54_mb88_i.r_in[15:12]),
        .r0_port_out(n54_r0), .r1_port_out(n54_r1o), .r2_port_out(n54_r2), .r3_port_out(n54_r3),
        .k_port_in(n54_mb88_i.k), .ol_port_out(n54_ol), .oh_port_out(n54_oh), .o_wr(n54_owr), .p_port_out(n54_p),
        .stby_n(1'b1), .tc_n(n54_mb88_i.tc_n), .irq_n(n54_mb88_i.irq_n), .sc_in_n(1'b1), .si_n(n54_mb88_i.si_n),
        .sc_out_n(), .so_n(), .to_n(),
        .rom_addr(n54_rom_a), .rom_data(n54_mb88_i.rom_d)
    );
    assign n54_mb88_o.r_out = {n54_r3, n54_r2, n54_r1o, n54_r0};
    assign n54_mb88_o.o     = {n54_oh, n54_ol};
    assign n54_mb88_o.o_wr  = n54_owr;
    assign n54_mb88_o.p     = n54_p;
    assign n54_mb88_o.rom_a = n54_rom_a;

    // 52xx = chips-repo namco_52xx + its MB88 (no MB88 pool in this core yet); ROM slice 0xC00-0xFFF of index 6.
    // SI pulled high, no TC clock; the voice ROM reads FF from 0x8000 up
    wire [15:0] n52_addr16;
    chip_pool_pkg::mb88_i_t n52_mb88_i;
    chip_pool_pkg::mb88_o_t n52_mb88_o;
    namco_52xx u_n52xx
    (
        .clk(clock_18), .ena(mcu_ena), .reset_n(mcu_reset_n),
        .chip_sel(n06_chipsel_g[2]), .wr_en(n06_chip_wr_g[2]), .wr_data(n06_chip_dout),
        .si(1'b1), .tc_n(1'b1),
        .p_out(n52_p), .sample_addr(n52_addr16), .sample_data(n52_addr16[15] ? 8'hFF : sample52_data),
        .rom_wr(mcu_rom_wr && mcu_rom_addr[11:10] == 2'b11), .rom_addr_in(mcu_rom_addr[9:0]), .rom_data_in(mcu_rom_data),
        .mb88_i(n52_mb88_i), .mb88_o(n52_mb88_o)
    );
    assign n52_sample_addr = n52_addr16[14:0];

    wire  [3:0] n52m_r0, n52m_r1, n52m_r2, n52m_r3, n52m_ol, n52m_oh, n52m_p;
    wire        n52m_owr;
    wire [10:0] n52m_rom_a;
    mb88 u_n52_mcu
    (
        .clock(clock_18), .ena(n52_mb88_i.ena), .reset_n(n52_mb88_i.reset_n), .ram_clr(1'b0),
        .r0_port_in(n52_mb88_i.r_in[3:0]), .r1_port_in(n52_mb88_i.r_in[7:4]), .r2_port_in(n52_mb88_i.r_in[11:8]),
        .r3_port_in(n52_mb88_i.r_in[15:12]),
        .r0_port_out(n52m_r0), .r1_port_out(n52m_r1), .r2_port_out(n52m_r2), .r3_port_out(n52m_r3),
        .k_port_in(n52_mb88_i.k), .ol_port_out(n52m_ol), .oh_port_out(n52m_oh), .o_wr(n52m_owr), .p_port_out(n52m_p),
        .stby_n(1'b1), .tc_n(n52_mb88_i.tc_n), .irq_n(n52_mb88_i.irq_n), .sc_in_n(1'b1), .si_n(n52_mb88_i.si_n),
        .sc_out_n(), .so_n(), .to_n(),
        .rom_addr(n52m_rom_a), .rom_data(n52_mb88_i.rom_d)
    );
    assign n52_mb88_o.r_out = {n52m_r3, n52m_r2, n52m_r1, n52m_r0};
    assign n52_mb88_o.o     = {n52m_oh, n52m_ol};
    assign n52_mb88_o.o_wr  = n52m_owr;
    assign n52_mb88_o.p     = n52m_p;
    assign n52_mb88_o.rom_a = n52m_rom_a;

endmodule

`default_nettype wire
