//============================================================================
//  pp_video_composite.sv — Pole Position full video compositor
//
//  Supersedes pp_tile_composite: instantiates ALL four layers + their palettes
//  and composites per MAME screen_update() (polepos_v.cpp:451-460):
//      view/bg (opaque, vpos<128)  OR  road (opaque, vpos>=128)   <- bottom
//      sprites (transpen 0x1f)                                     <- middle
//      alpha/text (transparency)                                  <- top
//
//  base  = (vpos<128) ? view_rgb : road_rgb
//  mid   = sprite_active ? sprite_rgb : base      (engine already dropped transp)
//  final = alpha_transparent ? mid : alpha_rgb
//
//  Latency: every layer's RGB is 2 clk after its combinational hpos/vpos-driven
//  generator output, and 2 clk << one ~8-clk pixel period, so the STABLE current
//  hpos/vpos + engine flags align with the palette RGB — no extra delay (same as
//  pp_tile_composite). ** road/sprite generators are UNVERIFIED drafts — co-sim. **
//============================================================================

`default_nettype none

module pp_video_composite
(
    input  wire        clk,
    input  wire        ce,
    input  wire [8:0]  hpos,
    input  wire [8:0]  vpos,
    input  wire        chacl,        // LS259 q7: alpha color+msb enable (0 at reset)

    // ---- ALPHA ----
    output wire [10:0] alpha_scan_addr,  input wire [15:0] alpha_scan_dout,
    output wire [11:0] alpha_gfx_addr,   input wire [7:0]  alpha_gfx_data,
    // ---- VIEW ----
    output wire [10:0] view_scan_addr,   input wire [15:0] view_scan_dout,
    output wire [11:0] view_gfx_addr,    input wire [7:0]  view_gfx_data,
    input  wire [15:0] view_hscroll,
    // ---- ROAD ----
    output wire [9:0]  road_scan_addr,   input wire [15:0] road_scan_dout,
    output wire [14:0] road_rom_addr,    input wire [7:0]  road_rom_data,
    input  wire [15:0] road_vscroll,
    // ---- SPRITE ----
    output wire [10:0] sprite_scan_addr, input wire [15:0] sprite_scan_dout,
    output wire [11:0] scalelut_addr,    input wire [7:0]  scalelut_data,
    output wire [16:0] sprgfx_addr,      input wire [7:0]  sprgfx_data,

    // ---- shared palette PROM load (each palette/gen filters its region) ----
    input  wire        prom_wr,
    input  wire [11:0] prom_addr,
    input  wire [7:0]  prom_data,

    // ---- composited output ----
    output wire [3:0]  r,
    output wire [3:0]  g,
    output wire [3:0]  b
);
    // REVERTED-2026-07-28: a same-session fix attempted here (subtracting a
    // constant 128 from hpos) was based on a wrong premise -- it assumed the
    // active display width was the full raw hcnt range (128-511, 384px), but
    // gen_video.vhd's own hblank compares (hcnt=475 assert / hcnt=187
    // deassert) show the TRUE active region is only hcnt 187-474 (288px).
    // Real hardware never shows the difference: poleposition.vhd exports
    // blankn/video_blankn as OUTPUT ports, blanked downstream by MiSTer's own
    // scandoubler/arcade_video -- this file's raw RGB was never the problem.
    // The actual bug was in the Verilator CAPTURE (sim_main.cpp/play_main.cpp
    // never applied that blanking, capturing the full unblanked hblank
    // region), fixed there instead -- see those files' FIX-2026-07-28 notes.

    // ======================= ALPHA =========================================
    wire [5:0] a_color; wire [1:0] a_pixel; wire a_bank;
    pp_tile_layer #(.SCAN_COLS(0), .COLS(32), .ROWS(32), .USE_HSCROLL(0), .BANK_128V(1))
    u_alpha (.clk(clk), .ce(ce), .hpos(hpos), .vpos(vpos), .hscroll(16'd0), .chacl(chacl),
             .scan_addr(alpha_scan_addr), .scan_dout(alpha_scan_dout),
             .gfx_addr(alpha_gfx_addr), .gfx_data(alpha_gfx_data),
             .color(a_color), .pixel(a_pixel), .bank128v(a_bank));
    wire [7:0] ar, ag, ab; wire a_transp;
    wire a_prom_wr = prom_wr && !prom_addr[10] && (prom_addr[11:8] <= 4'd3);
    pp_palette_alpha u_pal_a (.clk(clk), .prom_wr(a_prom_wr), .prom_addr(prom_addr[9:0]),
             .prom_data(prom_data), .color(a_color), .pixel(a_pixel), .bank128v(a_bank),
             .r(ar), .g(ag), .b(ab), .transparent(a_transp));

    // ======================= VIEW ==========================================
    wire [5:0] v_color; wire [1:0] v_pixel; wire v_bunused;
    pp_tile_layer #(.SCAN_COLS(1), .COLS(64), .ROWS(16), .USE_HSCROLL(1), .BANK_128V(0))
    u_view (.clk(clk), .ce(ce), .hpos(hpos), .vpos(vpos), .hscroll(view_hscroll), .chacl(1'b1),
            .scan_addr(view_scan_addr), .scan_dout(view_scan_dout),
            .gfx_addr(view_gfx_addr), .gfx_data(view_gfx_data),
            .color(v_color), .pixel(v_pixel), .bank128v(v_bunused));
    wire [7:0] vr, vg, vb;
    pp_palette_view u_pal_v (.clk(clk), .prom_wr(prom_wr), .prom_addr(prom_addr[10:0]),
            .prom_data(prom_data), .color(v_color), .pixel(v_pixel), .r(vr), .g(vg), .b(vb));

    // ======================= ROAD ==========================================
    // RESTORED-2026-07-28: STARTUP-STRIP-2026-07-27 had this commented out
    // (cut Quartus/Verilator build time while chasing the boot hang). The
    // z8002.sv register-writeback-bus refactor freed ~5,400 ALMs, so there's
    // ample headroom. NOTE: these generators are UNVERIFIED DRAFTS (see file
    // header) -- never co-sim-proven against MAME, restoring them is turning
    // on untested code, not known-good code.
    wire [9:0] road_idx; wire road_act;
    pp_road_gen u_road (.clk(clk), .ce(ce), .hpos(hpos), .vpos(vpos),
            .road_vscroll(road_vscroll),
            .scan_road_addr(road_scan_addr), .scan_road_dout(road_scan_dout),
            .road_rom_addr(road_rom_addr), .road_rom_data(road_rom_data),
            .prom_wr(prom_wr), .prom_addr(prom_addr), .prom_data(prom_data),
            .road_index(road_idx), .road_active(road_act));
    wire [7:0] rr, rg, rb;
    pp_palette_road u_pal_r (.clk(clk), .prom_wr(prom_wr), .prom_addr(prom_addr),
            .prom_data(prom_data), .road_index(road_idx), .r(rr), .g(rg), .b(rb));

    // ======================= SPRITE ========================================
    // RESTORED-2026-07-28: same reason as road above -- also an unverified draft.
    wire [3:0] s_pen; wire [5:0] s_color; wire s_bank, s_active;
    pp_sprite_gen u_spr (.clk(clk), .ce(ce), .hpos(hpos), .vpos(vpos),
            .scan_sprite_addr(sprite_scan_addr), .scan_sprite_dout(sprite_scan_dout),
            .scalelut_addr(scalelut_addr), .scalelut_data(scalelut_data),
            .sprgfx_addr(sprgfx_addr), .sprgfx_data(sprgfx_data),
            .prom_wr(prom_wr), .prom_addr(prom_addr), .prom_data(prom_data),
            .sprite_pen(s_pen), .sprite_color(s_color), .sprite_bank(s_bank),
            .sprite_active(s_active));
    wire [7:0] sr, sg, sb; wire s_transp_unused;
    pp_palette_sprite u_pal_s (.clk(clk), .prom_wr(prom_wr), .prom_addr(prom_addr),
            .prom_data(prom_data), .color(s_color), .pen(s_pen), .bank128v(s_bank),
            .r(sr), .g(sg), .b(sb), .transparent(s_transp_unused));

    // ======================= COMPOSITE =====================================
    wire        view_region = (vpos < 9'd128);
    wire [7:0]  base_r = view_region ? vr : rr;
    wire [7:0]  base_g = view_region ? vg : rg;
    wire [7:0]  base_b = view_region ? vb : rb;
    wire [7:0]  mid_r  = s_active ? sr : base_r;   // sprite over view/road
    wire [7:0]  mid_g  = s_active ? sg : base_g;
    wire [7:0]  mid_b  = s_active ? sb : base_b;
    wire [7:0]  fin_r  = a_transp ? mid_r : ar;    // alpha on top
    wire [7:0]  fin_g  = a_transp ? mid_g : ag;
    wire [7:0]  fin_b  = a_transp ? mid_b : ab;

    assign r = fin_r[7:4];
    assign g = fin_g[7:4];
    assign b = fin_b[7:4];

endmodule

`default_nettype wire
