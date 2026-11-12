//  Based on MAME polepos.cpp (Ernesto Corvi, Juergen Buchmueller, Alex Pasadyn, Aaron Giles, Nicola Salmoria, BSD-3-Clause)
`default_nettype none

module PolePosition_CPU
(
    input  wire        clk,
    input  wire        cen,           // Z80 clock-enable = CLK_49M /16 = 3.072 MHz
    input  wire        reset,
    input  wire        pause,

    input  wire [8:0]  vpos,

    output wire        sub1_reset_n,
    output wire        sub2_reset_n,
    output wire        namco_reset,
    output wire        sound_en,
    output wire        gasel,         // q3  ADC channel select: 0=BRAKE, 1=ACCEL
    output wire        sb0,
    output wire        chacl,
    output wire        sub_nvi_trig,

    output wire [12:0] vram_addr,
    output wire  [7:0] vram_dout,
    output wire        vram_wr,
    output wire        vram_rd,
    input  wire  [7:0] vram_din,

    output wire  [7:0] n06_dout,
    output wire        n06_data_wr, n06_data_rd,
    output wire        n06_ctrl_wr, n06_ctrl_rd,
    input  wire  [7:0] n06_din,
    input  wire        n06_nmi_n,

    output wire  [5:0] wsg_addr,
    output wire  [7:0] wsg_dout,
    output wire        wsg_wr, wsg_rd,
    input  wire  [7:0] wsg_din,

    output wire  [7:0] engine_dout,
    output wire        engine_lsb_wr,
    output wire        engine_msb_wr,

    output wire        adc_wr, adc_rd,
    input  wire  [7:0] adc_din,
    input  wire        adc_intr_n,

    output wire        watchdog_wr,

    output wire        sub_illegal,

    output wire [13:0] prog_rom_a,
    input  wire  [7:0] prog_rom_d,
    output wire [13:0] sub1_rom_a,
    input  wire [15:0] sub1_rom_d,
    output wire [13:0] sub2_rom_a,
    input  wire [15:0] sub2_rom_d,

    output chip_pool_pkg::z80r_i_t z80r_0_i,
    input  chip_pool_pkg::z80r_o_t z80r_0_o,
    output chip_pool_pkg::z8002_i_t z8002_0_i,
    input  chip_pool_pkg::z8002_o_t z8002_0_o,
    output chip_pool_pkg::z8002_i_t z8002_1_i,
    input  chip_pool_pkg::z8002_o_t z8002_1_o,

    output ram_pool_pkg::pram_i_t nv_pr_i,
    input  ram_pool_pkg::pram_o_t nv_pr_o,
    output ram_pool_pkg::pram_i_t snd_pr_i,
    input  ram_pool_pkg::pram_o_t snd_pr_o,
    output ram_pool_pkg::pram_i_t [7:0] vr_i,
    input  ram_pool_pkg::pram_o_t [7:0] vr_o,

    input  wire        ic25_en,
    input  wire        bootleg_io,
    input  wire  [7:0] bl_steer,
    input  wire  [7:0] bl_in0,
    input  wire  [7:0] bl_dswa,
    input  wire  [7:0] bl_dswb,
    output reg   [3:0] bl_dac,
    output reg   [7:0] bl_latch,
    output wire        bl_latch_wr,
    input  wire [10:0] scan_sprite_addr,
    output wire [15:0] scan_sprite_dout,
    input  wire  [9:0] scan_road_addr,
    output wire [15:0] scan_road_dout,
    input  wire  [9:0] scan_alpha_addr,
    output wire [15:0] scan_alpha_dout,
    input  wire [10:0] scan_view_addr,
    output wire [15:0] scan_view_dout,
    output wire [15:0] hscroll,
    output wire [15:0] vscroll,

    input  wire [10:0] hs_address,
    output wire  [7:0] hs_data_out,
    input  wire  [7:0] hs_data_in,
    input  wire        hs_write
);

    wire [15:0] cpu_A;
    wire  [7:0] cpu_Dout;
    wire  [7:0] cpu_Din;
    wire        n_m1, n_mreq, n_iorq, n_rd, n_wr, n_rfsh;
    wire        n_int;

    assign z80r_0_i.reset_n = ~reset;
    assign z80r_0_i.ce      = cen & ~pause;
    assign z80r_0_i.wait_n  = 1'b1;
    assign z80r_0_i.int_n   = n_int;
    assign z80r_0_i.nmi_n   = n06_nmi_n;
    assign z80r_0_i.di      = cpu_Din;
    assign cpu_A    = z80r_0_o.a;
    assign cpu_Dout = z80r_0_o.dout;
    assign n_m1     = z80r_0_o.m1_n;
    assign n_mreq   = z80r_0_o.mreq_n;
    assign n_iorq   = z80r_0_o.iorq_n;
    assign n_rd     = z80r_0_o.rd_n;
    assign n_wr     = z80r_0_o.wr_n;
    assign n_rfsh   = z80r_0_o.rfsh_n;

    wire mem  = ~n_mreq & n_rfsh;
    wire wr_s = ~n_wr & cen;
    wire rd_s = ~n_rd;

    wire cs_rom    = mem & (cpu_A[15:14] == 2'b00) & ~(cpu_A[15:12] == 4'h3);
    wire cs_nvram  = mem & (cpu_A[15:12] == 4'h3);
    wire cs_vram   = mem & (cpu_A[15:13] == 3'b010);

    wire pg8       = mem & (cpu_A[15:12] == 4'h8);
    wire cs_wsg    = pg8 & (cpu_A[9:6] == 4'b1111);
    wire cs_sndram = pg8 & ~cs_wsg;

    wire pg9       = mem & (cpu_A[15:12] == 4'h9);
    wire cs_06d    = pg9 & ~cpu_A[8];
    wire cs_06c    = pg9 &  cpu_A[8];

    wire pgA       = mem & (cpu_A[15:12] == 4'hA);
    wire cs_aready = pgA & (cpu_A[9:8] == 2'b00);
    wire cs_awdog  = pgA & (cpu_A[9:8] == 2'b01);
    wire cs_aengl  = pgA & (cpu_A[9:8] == 2'b10);
    wire cs_aengh  = pgA & (cpu_A[9:8] == 2'b11);

    wire cs_io_adc = ~n_iorq & (cpu_A[7:0] == 8'h00);
    // M1 excluded so an interrupt acknowledge never decodes as a bootleg I/O port
    wire cs_io_bl  = ~n_iorq & n_m1 & bootleg_io & (cpu_A[7:0] >= 8'h02) & (cpu_A[7:0] <= 8'h05);
    wire cs_io_bl3 = cs_io_bl & (cpu_A[7:0] == 8'h03);
    wire cs_io_bl5 = ~n_iorq & n_m1 & bootleg_io & (cpu_A[7:0] == 8'h05);
    wire [7:0] bl_din = (cpu_A[7:0] == 8'h02) ? bl_steer :
                        (cpu_A[7:0] == 8'h03) ? bl_in0   : bl_dswa;
    always @(posedge clk) begin
        if (reset) begin
            bl_dac   <= 4'd0;
            bl_latch <= 8'hFC;
        end else begin
            if (cs_io_bl3 & wr_s) bl_dac   <= cpu_Dout[3:0];
            if (cs_io_bl5 & wr_s) bl_latch <= cpu_Dout | 8'hFC;
        end
    end
    assign bl_latch_wr = cs_io_bl5 & wr_s;

    reg [7:0] latch;
    wire      latch_wr = cs_aready & wr_s;
    always @(posedge clk) begin
        if (reset) latch <= 8'h00;
        else if (latch_wr) latch[cpu_A[2:0]] <= cpu_Dout[0];
    end
    assign namco_reset  = latch[1];
    assign sound_en     = latch[2];
    assign gasel        = latch[3];
    assign sub1_reset_n = latch[4];
    assign sub2_reset_n = latch[5];
    assign sb0          = latch[6];
    assign chacl        = latch[7];
    wire   irq_en       = latch[0];

    reg [8:0] vpos_d;
    always @(posedge clk) vpos_d <= vpos;
    wire vpos_new  = (vpos != vpos_d);
    wire irq_trig  = vpos_new & ((vpos == 9'd64) | (vpos == 9'd192));
    assign sub_nvi_trig = vpos_new & (vpos == 9'd240);

    reg irq_pending;
    always @(posedge clk) begin
        if (reset)                       irq_pending <= 1'b0;
        else if (!irq_en)                irq_pending <= 1'b0;
        else if (irq_trig)               irq_pending <= 1'b1;
    end
    assign n_int = ~(irq_pending & irq_en);

    wire [7:0] ready_val = 8'hFF
                         ^ ((vpos >= 9'd128) ? 8'h02 : 8'h00)
                         ^ ((~adc_intr_n)    ? 8'h08 : 8'h00);

    wire [7:0] rom_D = prog_rom_d;
    assign prog_rom_a = cpu_A[13:0];

    wire sub1_illegal_w, sub2_illegal_w;
    wire [7:0] subcpu_vram_din;

    wire [7:0] nvram_D = nv_pr_o.a_q;
    assign nv_pr_i = '{a_addr: {5'd0, cpu_A[10:0]}, a_d: cpu_Dout, a_we: cs_nvram & wr_s,
                       b_addr: {5'd0, hs_address}, b_d: hs_data_in, b_we: hs_write};
    assign hs_data_out = nv_pr_o.b_q;

    wire [7:0] sndram_D = snd_pr_o.a_q;
    assign snd_pr_i = '{a_addr: {6'd0, cpu_A[9:0]}, a_d: cpu_Dout, a_we: cs_sndram & wr_s, b_addr: 16'd0, b_d: 8'd0, b_we: 1'b0};

    assign vram_addr    = cpu_A[12:0];
    assign vram_dout    = cpu_Dout;
    assign vram_wr      = cs_vram & ~n_wr;
    assign vram_rd      = cs_vram & rd_s;

    assign n06_dout     = cpu_Dout;
    assign n06_data_wr  = cs_06d & wr_s;
    assign n06_data_rd  = cs_06d & rd_s;
    assign n06_ctrl_wr  = cs_06c & wr_s;
    assign n06_ctrl_rd  = cs_06c & rd_s;

    assign wsg_addr     = cpu_A[5:0];
    assign wsg_dout     = cpu_Dout;
    assign wsg_wr       = cs_wsg & wr_s;
    assign wsg_rd       = cs_wsg & rd_s;

    assign engine_dout  = cpu_Dout;
    assign engine_lsb_wr= cs_aengl & wr_s;
    assign engine_msb_wr= cs_aengh & wr_s;

    assign adc_wr       = cs_io_adc & wr_s;
    assign adc_rd       = cs_io_adc & rd_s;

    assign watchdog_wr  = cs_awdog & wr_s;

    assign cpu_Din =
        cs_rom     ? rom_D          :
        cs_nvram   ? nvram_D        :
        cs_vram    ? subcpu_vram_din:
        cs_sndram  ? sndram_D       :
        cs_wsg     ? wsg_din        :
        (cs_06d | cs_06c) ? n06_din :
        cs_aready  ? ready_val      :
        cs_io_adc  ? adc_din        :
        cs_io_bl5  ? bl_dswb        :
        cs_io_bl   ? bl_din         :
        8'hFF;

    PolePosition_subcpu subcpu
    (
        .ic25_en      (ic25_en),
        .clk          (clk),
        .reset        (reset),
        .pause        (pause),

        .sub1_reset_n (sub1_reset_n),
        .sub2_reset_n (sub2_reset_n),
        .sub_nvi_trig (sub_nvi_trig),

        .vram_addr    (vram_addr),
        .vram_dout    (vram_dout),
        .vram_wr      (vram_wr),
        .vram_rd      (vram_rd),
        .vram_din     (subcpu_vram_din),

        .scan_sprite_addr (scan_sprite_addr),
        .scan_sprite_dout (scan_sprite_dout),
        .scan_road_addr   (scan_road_addr),
        .scan_road_dout   (scan_road_dout),
        .scan_alpha_addr  (scan_alpha_addr),
        .scan_alpha_dout  (scan_alpha_dout),
        .scan_view_addr   (scan_view_addr),
        .scan_view_dout   (scan_view_dout),

        .hscroll      (hscroll),
        .vscroll      (vscroll),

        .sub1_rom_a   (sub1_rom_a),
        .sub1_rom_d   (sub1_rom_d),
        .sub2_rom_a   (sub2_rom_a),
        .sub2_rom_d   (sub2_rom_d),

        .z8002_0_i    (z8002_0_i),
        .z8002_0_o    (z8002_0_o),
        .z8002_1_i    (z8002_1_i),
        .z8002_1_o    (z8002_1_o),

        .vr_i         (vr_i),
        .vr_o         (vr_o),

        .dbg1_illegal (sub1_illegal_w), .dbg2_illegal (sub2_illegal_w)
    );

    assign sub_illegal = sub1_illegal_w | sub2_illegal_w;

endmodule

`default_nettype wire
