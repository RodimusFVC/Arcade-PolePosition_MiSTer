//============================================================================
//  pp_alpha_first_light.sv — integrated ALPHA (text) render block
//
//  Composes the two unit-verified modules into the reusable "alpha layer"
//  block that the step-3 poleposition.vhd surgery instantiates:
//
//     hpos/vpos ─► pp_tile_layer(ALPHA) ─►{color,pixel,bank128v}─► pp_palette_alpha ─► R/G/B
//                        │  ▲                                             ▲
//              scan_alpha│  │gfx(chars)                          proms(0x000-0x3FF)
//
//  Drives the subcpu's scan_alpha port and the chars gfx ROM; consumes the
//  ioctl proms slice. Output R/G/B + `transparent` (transparent = the alpha
//  pixel shows the layer below; for an alpha-only first-light bring-up the
//  caller can substitute black/backdrop when transparent=1).
//
//  ── LATENCY ──  pp_tile_layer output is combinational vs hpos/vpos (0 clk);
//  pp_palette_alpha adds 2 clk. So R/G/B for the pixel at (hpos,vpos) appears
//  2 `ce` ticks LATER. The step-3 wiring aligns this against gen_video's
//  visible window (a 2-pixel display shift, folded into the §3 h-offset fudge).
//  This module exposes that as a fixed, documented pipeline delay.
//============================================================================

`default_nettype none

module pp_alpha_first_light
(
    input  wire        clk,
    input  wire        ce,            // pixel clock-enable

    // ---- video position (from gen_video) -----------------------------------
    input  wire [8:0]  hpos,
    input  wire [8:0]  vpos,

    // ---- scan_alpha read port (to PolePosition_subcpu, alpha buffer) --------
    output wire [9:0]  scan_alpha_addr,
    input  wire [15:0] scan_alpha_dout,

    // ---- chars gfx ROM (alpha tiles, 0x1000 region) ------------------------
    output wire [11:0] gfx_addr,
    input  wire [7:0]  gfx_data,

    // ---- palette PROM load (ioctl proms slice 0x000-0x3FF) -----------------
    input  wire        prom_wr,
    input  wire [9:0]  prom_addr,
    input  wire [7:0]  prom_data,

    // ---- RGB output (2-clk pipeline latency vs hpos/vpos) ------------------
    output wire [7:0]  r,
    output wire [7:0]  g,
    output wire [7:0]  b,
    output wire        transparent
);
    // tile layer -> palette handoff
    wire [10:0] tl_scan_addr;
    wire [5:0]  tl_color;
    wire [1:0]  tl_pixel;
    wire        tl_bank128v;

    // alpha buffer index is 10-bit (32x32 = 0x400); tile layer emits 11 (bit10=0)
    assign scan_alpha_addr = tl_scan_addr[9:0];

    pp_tile_layer #(
        .SCAN_COLS   (0),   // TILEMAP_SCAN_ROWS
        .COLS        (32),
        .ROWS        (32),
        .USE_HSCROLL (0),   // alpha has no scroll
        .BANK_128V   (1)    // alpha emits vpos[7] as the 128V bank bit
    ) u_tile (
        .clk       (clk),
        .ce        (ce),
        .hpos      (hpos),
        .vpos      (vpos),
        .hscroll   (16'd0),
        .scan_addr (tl_scan_addr),
        .scan_dout (scan_alpha_dout),
        .gfx_addr  (gfx_addr),
        .gfx_data  (gfx_data),
        .color     (tl_color),
        .pixel     (tl_pixel),
        .bank128v  (tl_bank128v)
    );

    pp_palette_alpha u_pal (
        .clk         (clk),
        .prom_wr     (prom_wr),
        .prom_addr   (prom_addr),
        .prom_data   (prom_data),
        .color       (tl_color),
        .pixel       (tl_pixel),
        .bank128v    (tl_bank128v),
        .r           (r),
        .g           (g),
        .b           (b),
        .transparent (transparent)
    );

endmodule

`default_nettype wire
