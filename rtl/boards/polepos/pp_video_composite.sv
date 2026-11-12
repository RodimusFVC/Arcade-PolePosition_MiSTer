//  Based on MAME polepos_v.cpp (Ernesto Corvi, Juergen Buchmueller, Alex Pasadyn, Aaron Giles, Nicola Salmoria, BSD-3-Clause)

`default_nettype none

module pp_video_composite
(
    input  wire        clk,
    input  wire        ce,
    input  wire [8:0]  hpos,
    input  wire [8:0]  vpos,
    input  wire        flip,
    input  wire        chacl,
    input  wire        diag_swatch,

    output wire [10:0] alpha_scan_addr,  input wire [15:0] alpha_scan_dout,
    output wire [12:0] alpha_gfx_addr,   input wire [7:0]  alpha_gfx_data,
    output wire [10:0] view_scan_addr,   input wire [15:0] view_scan_dout,
    output wire [12:0] view_gfx_addr,    input wire [7:0]  view_gfx_data,
    input  wire [15:0] view_hscroll,
    output wire [9:0]  road_scan_addr,   input wire [15:0] road_scan_dout,
    output wire [14:0] road_rom_addr,    input wire [7:0]  road_rom_data,
    input  wire [15:0] road_vscroll,
    output wire [10:0] sprite_scan_addr, input wire [15:0] sprite_scan_dout,
    output wire [11:0] scalelut_addr,    input wire [7:0]  scalelut_data,
    output wire [16:0] sprgfx_addr,      input wire [7:0]  sprgfx_data,

    input  wire        prom_wr,
    input  wire [11:0] prom_addr,
    input  wire [7:0]  prom_data,

    output wire [3:0]  r,
    output wire [3:0]  g,
    output wire [3:0]  b
);

    wire [5:0] a_color; wire [1:0] a_pixel; wire a_bank;

    // CRT Flip: visible lines 16-239 mirror to 255 - v; one line early for video_crtflip's line of latency
    wire [8:0] vpos_f = flip ? {1'b0, 8'd254 - vpos[7:0]} : vpos;
    wire [8:0] ynext  = flip ? {1'b0, 8'd253 - vpos[7:0]} : vpos + 9'd1;
    pp_tile_layer #(.SCAN_COLS(0), .COLS(32), .ROWS(32), .USE_HSCROLL(0), .BANK_128V(1))
    u_alpha (.clk(clk), .ce(ce), .hpos(hpos), .vpos(vpos_f), .hscroll(16'd0), .chacl(chacl),
             .scan_addr(alpha_scan_addr), .scan_dout(alpha_scan_dout),
             .gfx_addr(alpha_gfx_addr), .gfx_data(alpha_gfx_data),
             .color(a_color), .pixel(a_pixel), .bank128v(a_bank));
    wire [7:0] ar, ag, ab; wire a_transp;
    wire a_prom_wr = prom_wr && !prom_addr[10] && (prom_addr[11:8] <= 4'd3);
    pp_palette_alpha u_pal_a (.clk(clk), .prom_wr(a_prom_wr), .prom_addr(prom_addr[9:0]),
             .prom_data(prom_data), .color(a_color), .pixel(a_pixel), .bank128v(a_bank),
             .r(ar), .g(ag), .b(ab), .transparent(a_transp));

    wire [5:0] v_color; wire [1:0] v_pixel; wire v_bunused;
    pp_tile_layer #(.SCAN_COLS(1), .COLS(64), .ROWS(16), .USE_HSCROLL(1), .BANK_128V(0))
    u_view (.clk(clk), .ce(ce), .hpos(hpos), .vpos(vpos_f), .hscroll(view_hscroll), .chacl(1'b1),
            .scan_addr(view_scan_addr), .scan_dout(view_scan_dout),
            .gfx_addr(view_gfx_addr), .gfx_data(view_gfx_data),
            .color(v_color), .pixel(v_pixel), .bank128v(v_bunused));
    wire [7:0] vr, vg, vb;
    pp_palette_view u_pal_v (.clk(clk), .prom_wr(prom_wr), .prom_addr(prom_addr),
            .prom_data(prom_data), .color(v_color), .pixel(v_pixel), .r(vr), .g(vg), .b(vb));

    wire [9:0] road_idx; wire road_act;
    pp_road_gen u_road (.clk(clk), .ce(ce), .hpos(hpos), .vpos(vpos), .ynext(ynext),
            .road_vscroll(road_vscroll),
            .scan_road_addr(road_scan_addr), .scan_road_dout(road_scan_dout),
            .road_rom_addr(road_rom_addr), .road_rom_data(road_rom_data),
            .prom_wr(prom_wr), .prom_addr(prom_addr), .prom_data(prom_data),
            .road_index(road_idx), .road_active(road_act));
    wire [7:0] rr, rg, rb;
    pp_palette_road u_pal_r (.clk(clk), .prom_wr(prom_wr), .prom_addr(prom_addr),
            .prom_data(prom_data), .road_index(road_idx), .r(rr), .g(rg), .b(rb));

    wire [3:0] s_pen; wire [5:0] s_color; wire s_bank, s_active;
    pp_sprite_gen u_spr (.clk(clk), .ce(ce), .hpos(hpos), .vpos(vpos), .ynext(ynext),
            .scan_sprite_addr(sprite_scan_addr), .scan_sprite_dout(sprite_scan_dout),
            .scalelut_addr(scalelut_addr), .scalelut_data(scalelut_data),
            .sprgfx_addr(sprgfx_addr), .sprgfx_data(sprgfx_data),
            .prom_wr(prom_wr), .prom_addr(prom_addr), .prom_data(prom_data),
            .sprite_pen(s_pen), .sprite_color(s_color), .sprite_bank(s_bank),
            .sprite_active(s_active));
    localparam [8:0] SW_X0 = 9'd280;
    localparam [8:0] SW_Y0 = 9'd56;
    wire [8:0] sw_dx = hpos - SW_X0;
    wire [8:0] sw_dy = vpos - SW_Y0;
    wire       sw_on = diag_swatch && (hpos >= SW_X0) && (sw_dx < 9'd128)
                                   && (vpos >= SW_Y0) && (sw_dy < 9'd128);
    wire [7:0] sw_indirect = {1'b0, sw_dy[6:4], sw_dx[6:3]};

    wire [7:0] sr, sg, sb; wire s_transp_unused;
    pp_palette_sprite u_pal_s (.clk(clk), .prom_wr(prom_wr), .prom_addr(prom_addr),
            .prom_data(prom_data), .color(s_color), .pen(s_pen), .bank128v(s_bank),
            .diag_en(sw_on), .diag_indirect(sw_indirect),
            .r(sr), .g(sg), .b(sb), .transparent(s_transp_unused));

    wire        view_region = (vpos_f < 9'd128);
    wire [7:0]  base_r = view_region ? vr : rr;
    wire [7:0]  base_g = view_region ? vg : rg;
    wire [7:0]  base_b = view_region ? vb : rb;
    wire [7:0]  mid_r  = (s_active | sw_on) ? sr : base_r;
    wire [7:0]  mid_g  = (s_active | sw_on) ? sg : base_g;
    wire [7:0]  mid_b  = (s_active | sw_on) ? sb : base_b;
    wire [7:0]  fin_r  = (a_transp | sw_on) ? mid_r : ar;
    wire [7:0]  fin_g  = (a_transp | sw_on) ? mid_g : ag;
    wire [7:0]  fin_b  = (a_transp | sw_on) ? mid_b : ab;

    assign r = fin_r[7:4];
    assign g = fin_g[7:4];
    assign b = fin_b[7:4];

endmodule

`default_nettype wire
