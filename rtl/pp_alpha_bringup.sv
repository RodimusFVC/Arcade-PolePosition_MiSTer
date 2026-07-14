//============================================================================
//  pp_alpha_bringup.sv — STEP-3a HW bring-up scaffold  (TEMPORARY / DIAG)
//
//  Proves the alpha tile renderer (pp_tile_layer) lights up pixels on REAL
//  hardware, isolated from the CPU + ROM-load integration. Self-contained:
//  drives pp_tile_layer's scan buffer + gfx ROM with deterministic TEST
//  PATTERNS (no subcpu, no external RAM/ROM, no palette/proms) and maps the
//  raw {color,pixel,bank} straight to 4-bit RGB. If a STABLE, position-varying
//  tile grid appears on screen, the fetch+serialize pipeline works on silicon.
//
//  REMOVE after bring-up (see DIAG-REVERT tags in poleposition.vhd + files.qip).
//  The real path swaps the test patterns for the subcpu scan_alpha buffer + the
//  chars gfx ROM, and routes {color,pixel} through pp_palette_alpha.
//============================================================================
`default_nettype none

module pp_alpha_bringup
(
    input  wire        clk,
    input  wire        ce,
    input  wire [8:0]  hpos,
    input  wire [8:0]  vpos,
    // INCR-1a: real chars gfx ROM now drives gfx (was an internal test pattern);
    // gfx ROM lives in the top (loaded at ioctl index 1), read via these ports.
    output wire [11:0] gfx_addr,
    input  wire [7:0]  gfx_data,
    // INCR-2: alpha tilemap buffer now comes from PolePosition_CPU's scan_alpha
    // port (real attract content), not the internal test pattern.
    output wire [10:0] scan_addr,
    input  wire [15:0] scan_dout,
    // alpha palette PROM load (ioctl index 2, slice 0x000-0x3FF = R/G/B/alpha tables)
    input  wire        prom_wr,
    input  wire [9:0]  prom_addr,
    input  wire [7:0]  prom_data,
    output wire [3:0]  r,
    output wire [3:0]  g,
    output wire [3:0]  b
);
    wire [5:0]  color;
    wire [1:0]  pixel;
    wire        bank128v;

    pp_tile_layer #(
        .SCAN_COLS(0), .COLS(32), .ROWS(32), .USE_HSCROLL(0), .BANK_128V(1)
    ) u_tile (
        .clk(clk), .ce(ce),
        .hpos(hpos), .vpos(vpos), .hscroll(16'd0),
        .scan_addr(scan_addr), .scan_dout(scan_dout),
        .gfx_addr(gfx_addr),   .gfx_data(gfx_data),
        .color(color), .pixel(pixel), .bank128v(bank128v)
    );

    // REAL alpha palette (2026-07-14): {color,pixel,bank128v} -> RGB via
    // pp_palette_alpha (PROM LUTs + weighted-resistor DAC). 2-clk latency is
    // negligible vs the 8-clk pixel period; 8-bit DAC output truncated to the
    // core's 4-bit video path. Transparency (ptransp) is ignored until a bg layer
    // exists to composite below — alpha-only first-light shows palette colour.
    wire [7:0] pr, pg, pb;
    wire       ptransp;
    pp_palette_alpha u_pal (
        .clk        (clk),
        .prom_wr    (prom_wr),
        .prom_addr  (prom_addr),
        .prom_data  (prom_data),
        .color      (color),
        .pixel      (pixel),
        .bank128v   (bank128v),
        .r          (pr),
        .g          (pg),
        .b          (pb),
        .transparent(ptransp)
    );
    assign r = pr[7:4];
    assign g = pg[7:4];
    assign b = pb[7:4];

endmodule

`default_nettype wire
