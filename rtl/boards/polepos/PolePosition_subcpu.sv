//  Based on MAME polepos.cpp, polepos_v.cpp (Ernesto Corvi, Juergen Buchmueller, Alex Pasadyn, Aaron Giles, Nicola Salmoria, BSD-3-Clause)
`default_nettype none

module PolePosition_subcpu
(
    input  wire        clk,
    input  wire        pause,
    input  wire        reset,

    input  wire        sub1_reset_n,
    input  wire        sub2_reset_n,
    input  wire        sub_nvi_trig,

    input  wire [12:0] vram_addr,
    input  wire  [7:0] vram_dout,
    input  wire        vram_wr,
    input  wire        vram_rd,
    output wire  [7:0] vram_din,

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

    output wire [13:0] sub1_rom_a,
    input  wire [15:0] sub1_rom_d,
    output wire [13:0] sub2_rom_a,
    input  wire [15:0] sub2_rom_d,

    input  wire        ic25_en,

    output chip_pool_pkg::z8002_i_t z8002_0_i,
    input  chip_pool_pkg::z8002_o_t z8002_0_o,
    output chip_pool_pkg::z8002_i_t z8002_1_i,
    input  chip_pool_pkg::z8002_o_t z8002_1_o,

    output ram_pool_pkg::pram_i_t [7:0] vr_i,
    input  ram_pool_pkg::pram_o_t [7:0] vr_o,

    output wire        dbg1_illegal, dbg2_illegal
);

    reg [3:0] div;
    always @(posedge clk) begin
        if (reset) div <= 4'd0;
        else       div <= div + 4'd1;
    end
    wire cen_sub1 = (div == 4'd5)  & ~pause;
    wire cen_sub2 = (div == 4'd10) & ~pause;

    wire [15:0] sub1_addr, sub1_dout, sub1_din;
    wire        sub1_mreq, sub1_iorq, sub1_we, sub1_wordacc;

    wire [15:0] sub2_addr, sub2_dout, sub2_din;
    wire        sub2_mreq, sub2_iorq, sub2_we, sub2_wordacc;

    wire sub1_nvi_n, sub2_nvi_n;

    assign z8002_0_i.reset_n = sub1_reset_n;
    assign z8002_0_i.ce      = cen_sub1;
    assign z8002_0_i.din     = sub1_din;
    assign z8002_0_i.wait_n  = 1'b1;
    assign z8002_0_i.nmi_n   = 1'b1;
    assign z8002_0_i.nvi_n   = sub1_nvi_n;
    assign z8002_0_i.vi_n    = 1'b1;
    assign sub1_addr    = z8002_0_o.addr;
    assign sub1_dout    = z8002_0_o.dout;
    assign sub1_mreq    = z8002_0_o.mreq;
    assign sub1_iorq    = z8002_0_o.iorq;
    assign sub1_we      = z8002_0_o.we;
    assign sub1_wordacc = z8002_0_o.wordacc;
    assign dbg1_illegal = z8002_0_o.illegal;

    assign z8002_1_i.reset_n = sub2_reset_n;
    assign z8002_1_i.ce      = cen_sub2;
    assign z8002_1_i.din     = sub2_din;
    assign z8002_1_i.wait_n  = 1'b1;
    assign z8002_1_i.nmi_n   = 1'b1;
    assign z8002_1_i.nvi_n   = sub2_nvi_n;
    assign z8002_1_i.vi_n    = 1'b1;
    assign sub2_addr    = z8002_1_o.addr;
    assign sub2_dout    = z8002_1_o.dout;
    assign sub2_mreq    = z8002_1_o.mreq;
    assign sub2_iorq    = z8002_1_o.iorq;
    assign sub2_we      = z8002_1_o.we;
    assign sub2_wordacc = z8002_1_o.wordacc;
    assign dbg2_illegal = z8002_1_o.illegal;

    wire sub1_mem_we = sub1_mreq & sub1_we;
    wire sub2_mem_we = sub2_mreq & sub2_we;

    localparam [15:0] NVI_ADDR = 16'h6000, NVI_MASK = 16'hE001;
    localparam [15:0] HS_ADDR  = 16'hC000, HS_MASK  = 16'hC701;
    localparam [15:0] VS_ADDR  = 16'hC100, VS_MASK  = 16'hC701;

    wire sub1_rom_sel  = ~sub1_addr[15];
    wire [13:0] sub1_rom_idx = sub1_addr[14:1];
    wire sub1_v_sprite = (sub1_addr[15:12] == 4'h8);
    wire sub1_v_road   = (sub1_addr[15:12] == 4'h9) & ~sub1_addr[11];
    wire sub1_v_alpha  = (sub1_addr[15:12] == 4'h9) &  sub1_addr[11];
    wire sub1_v_view   = (sub1_addr[15:12] == 4'hA);
    wire [10:0] sub1_idx11 = sub1_addr[11:1];
    wire [9:0]  sub1_idx10 = sub1_addr[10:1];
    wire sub1_nvi_hit  = ((sub1_addr & NVI_MASK) == NVI_ADDR);
    wire sub1_hs_hit   = ((sub1_addr & HS_MASK)  == HS_ADDR);
    wire sub1_vs_hit   = ((sub1_addr & VS_MASK)  == VS_ADDR);

    wire sub2_rom_sel  = ~sub2_addr[15];
    wire [13:0] sub2_rom_idx = sub2_addr[14:1];
    wire sub2_v_sprite = (sub2_addr[15:12] == 4'h8);
    wire sub2_v_road   = (sub2_addr[15:12] == 4'h9) & ~sub2_addr[11];
    wire sub2_v_alpha  = (sub2_addr[15:12] == 4'h9) &  sub2_addr[11];
    wire sub2_v_view   = (sub2_addr[15:12] == 4'hA);
    wire [10:0] sub2_idx11 = sub2_addr[11:1];
    wire [9:0]  sub2_idx10 = sub2_addr[10:1];
    wire sub2_nvi_hit  = ((sub2_addr & NVI_MASK) == NVI_ADDR);
    wire sub2_hs_hit   = ((sub2_addr & HS_MASK)  == HS_ADDR);
    wire sub2_vs_hit   = ((sub2_addr & VS_MASK)  == VS_ADDR);

    wire z80_v_sprite = (vram_addr[12:11] == 2'b00);
    wire z80_v_road   = (vram_addr[12:10] == 3'b010);
    wire z80_v_alpha  = (vram_addr[12:10] == 3'b011);
    wire z80_v_view   = (vram_addr[12:11] == 2'b10);
    wire [10:0] z80_idx11 = vram_addr[10:0];
    wire [9:0]  z80_idx10 = vram_addr[9:0];

    wire own_z80  = (div <= 4'd4);
    wire own_sub1 = (div >= 4'd5)  & (div <= 4'd9);
    wire own_sub2 = (div >= 4'd10);

    assign sub1_rom_a = sub1_rom_idx;
    assign sub2_rom_a = sub2_rom_idx;
    wire [15:0] sub1_rom_rd = sub1_rom_d;
    wire [15:0] sub2_rom_rd = sub2_rom_d;

    wire [10:0] pa_addr11 = own_z80 ? z80_idx11 : own_sub1 ? sub1_idx11 : sub2_idx11;
    wire  [9:0] pa_addr10 = own_z80 ? z80_idx10 : own_sub1 ? sub1_idx10 : sub2_idx10;
    wire  [7:0] pa_wdlo   = own_z80 ? vram_dout : own_sub1 ? sub1_dout[7:0]  : sub2_dout[7:0];
    wire  [7:0] pa_wdhi   =              own_sub1 ? sub1_dout[15:8] : sub2_dout[15:8];

    wire we_sprite_lo = (own_z80 & vram_wr & z80_v_sprite) | (own_sub1 & sub1_mem_we & sub1_v_sprite) | (own_sub2 & sub2_mem_we & sub2_v_sprite);
    wire we_sprite_hi =                                       (own_sub1 & sub1_mem_we & sub1_v_sprite) | (own_sub2 & sub2_mem_we & sub2_v_sprite);
    wire we_road_lo   = (own_z80 & vram_wr & z80_v_road)   | (own_sub1 & sub1_mem_we & sub1_v_road)   | (own_sub2 & sub2_mem_we & sub2_v_road);
    wire we_road_hi   =                                       (own_sub1 & sub1_mem_we & sub1_v_road)   | (own_sub2 & sub2_mem_we & sub2_v_road);
    wire we_alpha_lo  = (own_z80 & vram_wr & z80_v_alpha)  | (own_sub1 & sub1_mem_we & sub1_v_alpha)  | (own_sub2 & sub2_mem_we & sub2_v_alpha);
    wire we_alpha_hi  =                                       (own_sub1 & sub1_mem_we & sub1_v_alpha)  | (own_sub2 & sub2_mem_we & sub2_v_alpha);
    wire we_view_lo   = (own_z80 & vram_wr & z80_v_view)   | (own_sub1 & sub1_mem_we & sub1_v_view)   | (own_sub2 & sub2_mem_we & sub2_v_view);
    wire we_view_hi   =                                       (own_sub1 & sub1_mem_we & sub1_v_view)   | (own_sub2 & sub2_mem_we & sub2_v_view);

    wire [7:0] sprite_hi_qa, sprite_lo_qa, sprite_hi_qb, sprite_lo_qb;
    wire [7:0] road_hi_qa,   road_lo_qa,   road_hi_qb,   road_lo_qb;
    wire [7:0] alpha_hi_qa,  alpha_lo_qa,  alpha_hi_qb,  alpha_lo_qb;
    wire [7:0] view_hi_qa,   view_lo_qa,   view_hi_qb,   view_lo_qb;

    assign vr_i[0] = '{a_addr: {5'd0, pa_addr11}, a_d: pa_wdlo, a_we: we_sprite_lo, b_addr: {5'd0, scan_sprite_addr}, b_d: 8'd0, b_we: 1'b0};
    assign vr_i[1] = '{a_addr: {5'd0, pa_addr11}, a_d: pa_wdhi, a_we: we_sprite_hi, b_addr: {5'd0, scan_sprite_addr}, b_d: 8'd0, b_we: 1'b0};
    assign vr_i[2] = '{a_addr: {6'd0, pa_addr10}, a_d: pa_wdlo, a_we: we_road_lo,   b_addr: {6'd0, scan_road_addr},   b_d: 8'd0, b_we: 1'b0};
    assign vr_i[3] = '{a_addr: {6'd0, pa_addr10}, a_d: pa_wdhi, a_we: we_road_hi,   b_addr: {6'd0, scan_road_addr},   b_d: 8'd0, b_we: 1'b0};
    assign vr_i[4] = '{a_addr: {6'd0, pa_addr10}, a_d: pa_wdlo, a_we: we_alpha_lo,  b_addr: {6'd0, scan_alpha_addr},  b_d: 8'd0, b_we: 1'b0};
    assign vr_i[5] = '{a_addr: {6'd0, pa_addr10}, a_d: pa_wdhi, a_we: we_alpha_hi,  b_addr: {6'd0, scan_alpha_addr},  b_d: 8'd0, b_we: 1'b0};
    assign vr_i[6] = '{a_addr: {5'd0, pa_addr11}, a_d: pa_wdlo, a_we: we_view_lo,   b_addr: {5'd0, scan_view_addr},   b_d: 8'd0, b_we: 1'b0};
    assign vr_i[7] = '{a_addr: {5'd0, pa_addr11}, a_d: pa_wdhi, a_we: we_view_hi,   b_addr: {5'd0, scan_view_addr},   b_d: 8'd0, b_we: 1'b0};
    assign sprite_lo_qa = vr_o[0].a_q;  assign sprite_lo_qb = vr_o[0].b_q;
    assign sprite_hi_qa = vr_o[1].a_q;  assign sprite_hi_qb = vr_o[1].b_q;
    assign road_lo_qa   = vr_o[2].a_q;  assign road_lo_qb   = vr_o[2].b_q;
    assign road_hi_qa   = vr_o[3].a_q;  assign road_hi_qb   = vr_o[3].b_q;
    assign alpha_lo_qa  = vr_o[4].a_q;  assign alpha_lo_qb  = vr_o[4].b_q;
    assign alpha_hi_qa  = vr_o[5].a_q;  assign alpha_hi_qb  = vr_o[5].b_q;
    assign view_lo_qa   = vr_o[6].a_q;  assign view_lo_qb   = vr_o[6].b_q;
    assign view_hi_qa   = vr_o[7].a_q;  assign view_hi_qb   = vr_o[7].b_q;
    assign scan_sprite_dout = {sprite_hi_qb, sprite_lo_qb};
    assign scan_road_dout   = {road_hi_qb,   road_lo_qb};
    assign scan_alpha_dout  = {alpha_hi_qb,  alpha_lo_qb};
    assign scan_view_dout   = {view_hi_qb,   view_lo_qb};

    wire [15:0] sub1_vram_qa = sub1_v_sprite ? {sprite_hi_qa, sprite_lo_qa}
                             : sub1_v_road   ? {road_hi_qa,   road_lo_qa}
                             : sub1_v_alpha  ? {alpha_hi_qa,  alpha_lo_qa}
                             : sub1_v_view   ? {view_hi_qa,   view_lo_qa}
                             :                 16'hFFFF;
    wire [15:0] sub2_vram_qa = sub2_v_sprite ? {sprite_hi_qa, sprite_lo_qa}
                             : sub2_v_road   ? {road_hi_qa,   road_lo_qa}
                             : sub2_v_alpha  ? {alpha_hi_qa,  alpha_lo_qa}
                             : sub2_v_view   ? {view_hi_qa,   view_lo_qa}
                             :                 16'hFFFF;
    wire  [7:0] z80_vram_qa  = z80_v_sprite  ? sprite_lo_qa
                             : z80_v_road    ? road_lo_qa
                             : z80_v_alpha   ? alpha_lo_qa
                             : z80_v_view    ? view_lo_qa
                             :                 8'hFF;
    reg [15:0] sub1_vram_hold, sub2_vram_hold;
    reg  [7:0] z80_vram_hold;
    always @(posedge clk) begin
        if (div == 4'd10) sub1_vram_hold <= sub1_vram_qa;
        if (div == 4'd0 ) sub2_vram_hold <= sub2_vram_qa;
        if (div == 4'd5 ) z80_vram_hold  <= z80_vram_qa;
    end

    reg nvi_en_sub1, nvi_en_sub2;
    always @(posedge clk) begin
        if (reset | ~sub1_reset_n) nvi_en_sub1 <= 1'b0;
        else if (sub1_mem_we & sub1_nvi_hit) nvi_en_sub1 <= sub1_dout[0];
    end
    always @(posedge clk) begin
        if (reset | ~sub2_reset_n) nvi_en_sub2 <= 1'b0;
        else if (sub2_mem_we & sub2_nvi_hit) nvi_en_sub2 <= sub2_dout[0];
    end

    reg [15:0] hscroll_r, vscroll_r;
    always @(posedge clk) begin
        if (reset) hscroll_r <= 16'h0000;
        else if (sub1_mem_we & sub1_hs_hit) hscroll_r <= sub1_dout;
        else if (sub2_mem_we & sub2_hs_hit) hscroll_r <= sub2_dout;
    end
    always @(posedge clk) begin
        if (reset) vscroll_r <= 16'h0000;
        else if (sub1_mem_we & sub1_vs_hit) vscroll_r <= sub1_dout;
        else if (sub2_mem_we & sub2_vs_hit) vscroll_r <= sub2_dout;
    end
    assign hscroll = hscroll_r;
    assign vscroll = vscroll_r;

    reg nvi_latch_sub1, nvi_latch_sub2;
    always @(posedge clk) begin
        if (reset | ~sub1_reset_n)                           nvi_latch_sub1 <= 1'b0;
        else if (sub_nvi_trig)                               nvi_latch_sub1 <= nvi_en_sub1;
        else if (sub1_mem_we & sub1_nvi_hit & ~sub1_dout[0]) nvi_latch_sub1 <= 1'b0;
    end
    always @(posedge clk) begin
        if (reset | ~sub2_reset_n)                           nvi_latch_sub2 <= 1'b0;
        else if (sub_nvi_trig)                               nvi_latch_sub2 <= nvi_en_sub2;
        else if (sub2_mem_we & sub2_nvi_hit & ~sub2_dout[0]) nvi_latch_sub2 <= 1'b0;
    end
    assign sub1_nvi_n = ~nvi_latch_sub1;
    assign sub2_nvi_n = ~nvi_latch_sub2;

    wire        sub1_ic25_sel = ic25_en & (sub1_addr[15:13] == 3'b010) & ~sub1_we;
    wire [15:0] sub1_ic25_rd;

    pp_ic25 u_ic25 (
        .clk   (clk),
        .rst_n (~reset),
        .sel   (sub1_ic25_sel),
        .addr  (sub1_addr[9:1]),
        .dout  (sub1_ic25_rd)
    );

    assign sub1_din = sub1_ic25_sel ? sub1_ic25_rd
                    : sub1_rom_sel  ? sub1_rom_rd : sub1_vram_hold;
    assign sub2_din = sub2_rom_sel ? sub2_rom_rd : sub2_vram_hold;
    assign vram_din = z80_vram_hold;

endmodule

`default_nettype wire
