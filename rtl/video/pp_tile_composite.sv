//============================================================================
//  pp_tile_composite.sv — Pole Position tilemap compositor (ALPHA over VIEW)
//
//  Supersedes pp_alpha_bringup for the two tilemap layers: renders BOTH the
//  alpha (text) and view/bg (scenery) layers and composites them per MAME's
//  layer order (polepos_v.cpp:451): view/bg is the OPAQUE bottom (top 128
//  scanlines, vpos<128), alpha is on top and honours its transparency.
//
//  Layer map (from pp_tile_layer / video_mapping §2-3):
//    alpha : SCAN_COLS=0, 32x32, no scroll, BANK_128V=1, chars gfx, pp_palette_alpha
//    view  : SCAN_COLS=1, 64x16, hscroll,  BANK_128V=0, tiles gfx, pp_palette_view
//
//  Compositing (combinational, both palettes are 2-clk and settle within one
//  ~8-clk pixel period, so the STABLE current vpos aligns with the palette out —
//  no extra delay needed; the caller applies the sub-pixel counter offset):
//    base = (vpos<128) ? view_rgb : BLACK      // road (vpos>=128) is TBD -> black
//    final = alpha_transparent ? base : alpha_rgb
//
//  NOTE: enabling this compositor HONOURS alpha transparency for the first time
//  (pp_alpha_bringup ignored it and showed palette[0x2f]). The self-test '0'
//  screen's background will now show the view layer (or black) instead of the
//  old flat blue — expected; verify on HW (video_mapping deferred-transparency).
//============================================================================

`default_nettype none

module pp_tile_composite
(
    input  wire        clk,
    input  wire        ce,
    input  wire [8:0]  hpos,
    input  wire [8:0]  vpos,

    // ---- ALPHA layer buffers/ROM ------------------------------------------
    output wire [10:0] alpha_scan_addr,
    input  wire [15:0] alpha_scan_dout,
    output wire [12:0] alpha_gfx_addr,
    input  wire [7:0]  alpha_gfx_data,

    // ---- VIEW layer buffers/ROM -------------------------------------------
    output wire [10:0] view_scan_addr,
    input  wire [15:0] view_scan_dout,
    output wire [12:0] view_gfx_addr,
    input  wire [7:0]  view_gfx_data,
    input  wire [15:0] view_hscroll,     // PP view h-scroll (z8002 @0xC000)

    // ---- palette PROM load (ioctl "proms" region) -------------------------
    //   [10:8] table: 0=R@0x000 1=G@0x100 2=B@0x200 3=alpha@0x300 4=view@0x400
    input  wire        prom_wr,
    input  wire [10:0] prom_addr,
    input  wire [7:0]  prom_data,

    // ---- composited pixel out (4-bit RGB, core video path) ----------------
    output wire [3:0]  r,
    output wire [3:0]  g,
    output wire [3:0]  b
);
    // ======================= ALPHA layer ==================================
    wire [5:0] a_color;  wire [1:0] a_pixel;  wire a_bank;
    pp_tile_layer #(
        .SCAN_COLS(0), .COLS(32), .ROWS(32), .USE_HSCROLL(0), .BANK_128V(1)
    ) u_alpha (
        .clk(clk), .ce(ce), .hpos(hpos), .vpos(vpos), .hscroll(16'd0),
        .scan_addr(alpha_scan_addr), .scan_dout(alpha_scan_dout),
        .gfx_addr(alpha_gfx_addr),   .gfx_data(alpha_gfx_data),
        .color(a_color), .pixel(a_pixel), .bank128v(a_bank)
    );

    wire [7:0] ar, ag, ab;  wire a_transp;
    // alpha palette only sees the 0x000-0x3FF slice (gate off view's 0x400 write)
    wire a_prom_wr = prom_wr && !prom_addr[10];
    pp_palette_alpha u_pal_a (
        .clk(clk),
        .prom_wr(a_prom_wr), .prom_addr(prom_addr[9:0]), .prom_data(prom_data),
        .color(a_color), .pixel(a_pixel), .bank128v(a_bank),
        .r(ar), .g(ag), .b(ab), .transparent(a_transp)
    );

    // ======================= VIEW layer ===================================
    wire [5:0] v_color;  wire [1:0] v_pixel;  wire v_bank_unused;
    pp_tile_layer #(
        .SCAN_COLS(1), .COLS(64), .ROWS(16), .USE_HSCROLL(1), .BANK_128V(0)
    ) u_view (
        .clk(clk), .ce(ce), .hpos(hpos), .vpos(vpos), .hscroll(view_hscroll),
        .scan_addr(view_scan_addr), .scan_dout(view_scan_dout),
        .gfx_addr(view_gfx_addr),   .gfx_data(view_gfx_data),
        .color(v_color), .pixel(v_pixel), .bank128v(v_bank_unused)
    );

    wire [7:0] vr, vg, vb;
    // view palette filters its own tables (R/G/B/view) via prom_addr[11:8]
    // VIEWPROM-ALIAS-FIX-2026-08-16: pp_palette_view's prom_addr widened 11->12
    // bits. THIS module (superseded by pp_video_composite, but still listed in
    // files.qip) only has an 11-bit bus, so pad bit 11 with 0 -- it never
    // carries the 0x800+ offsets that caused the aliasing. Keeps behaviour
    // identical and avoids a port-width warning in the Quartus build.
    pp_palette_view u_pal_v (
        .clk(clk),
        .prom_wr(prom_wr), .prom_addr({1'b0, prom_addr}), .prom_data(prom_data),
        .color(v_color), .pixel(v_pixel),
        .r(vr), .g(vg), .b(vb)
    );

    // ======================= COMPOSITE ====================================
    wire        view_region = (vpos < 9'd128);           // top 128 lines = view/bg
    wire [7:0]  base_r = view_region ? vr : 8'd0;        // road region -> black (TBD)
    wire [7:0]  base_g = view_region ? vg : 8'd0;
    wire [7:0]  base_b = view_region ? vb : 8'd0;

    wire [7:0]  fr = a_transp ? base_r : ar;             // alpha on top unless transparent
    wire [7:0]  fg = a_transp ? base_g : ag;
    wire [7:0]  fb = a_transp ? base_b : ab;

    assign r = fr[7:4];
    assign g = fg[7:4];
    assign b = fb[7:4];

endmodule

`default_nettype wire
