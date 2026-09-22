//============================================================================
//  pp_tile_layer.sv — Pole Position tilemap layer render pipeline
//
//  One instance renders ONE 8x8 2bpp tilemap layer (alpha OR view). It:
//    * generates the tilemap-scan buffer index from the display pixel position
//      (per MAME's TILEMAP_SCAN order + tilemap dimensions);
//    * drives this layer's dedicated scanout read port on PolePosition_subcpu
//      (my Part-2 step-1 4-port change) — a COMBINATIONAL word read;
//    * drives this layer's gfx ROM port (chars/tiles region, assumed a
//      SYNCHRONOUS 1-clk read) and fetches the two nibble-planar bytes;
//    * decodes to a per-pixel {color, pixel} via pp_tile_decode (x2).
//
//  Parameterized for the two PP layers (both 8x8, 2bpp, charlayout_2bpp):
//    alpha ("chars") : SCAN_COLS=0 (TILEMAP_SCAN_ROWS), 32x32, no scroll,
//                      BANK_128V=1  (polepos_v.cpp:186,169)
//    view  ("tiles") : SCAN_COLS=1 (TILEMAP_SCAN_COLS), 64x16, hscroll,
//                      BANK_128V=0  (polepos_v.cpp:185,263)
//  COLS/ROWS are powers of two for both (32/32, 64/16) → index math is shifts.
//
//  ── TIMING MODEL (the part to VERIFY in the co-sim; see sim_layer harness) ──
//  Single pixel-clock domain, advanced by `ce` (1 pulse per output pixel).
//  `hpos`/`vpos` = the DISPLAY pixel being output THIS `ce` (visible-region
//  pixel coords; caller maps gen_video hcnt/vcnt→these incl. any global flip).
//  Effective X: x_disp = hpos (+hscroll for view). Intra-tile phase p =
//  x_disp[2:0]. Each 8-pixel span we PREFETCH the next tile (x_fetch=x_disp+8,
//  constant across the span) and latch it at p==7, so the tile being displayed
//  is always the one prefetched during the previous span. Two gfx-ROM byte
//  reads (left x0-3, right x4-7) are issued at p==0/p==1 and captured at
//  p==1/p==2 (1-clk ROM latency). Pixel output is COMBINATIONAL (0 added
//  latency) from the latched display-tile bytes + col=p.
//
//  #verify-in-sim: (a) the p==0/1/2/7 gfx sequence vs the real 1-clk ROM
//  latency; (b) first tile of a scanline must be prefetched during the trailing
//  8 counts of hblank (caller must free-run the counters through blank);
//  (c) integration counter offset/flip (Xevious §3 "fudge constants") — NOT
//  handled here, that is a step-3 wiring concern.
//  Ground truth: Claude/polepos_video_mapping_2026-07-13.md §2-3, polepos_v.cpp
//  :145-186, polepos.cpp:820-829.
//============================================================================

`default_nettype none

module pp_tile_layer #(
    parameter        SCAN_COLS   = 0,   // 0=TILEMAP_SCAN_ROWS, 1=TILEMAP_SCAN_COLS
    parameter integer COLS       = 32,  // tilemap width  in tiles (pow2)
    parameter integer ROWS       = 32,  // tilemap height in tiles (pow2)
    parameter        USE_HSCROLL = 0,   // 1 = add hscroll to X (view)
    parameter        BANK_128V   = 0    // 1 = emit vpos[7] as 128V bank bit
)(
    input  wire        clk,
    input  wire        ce,            // pixel clock-enable (1 per output pixel)

    // ---- display pixel position (visible-region coords) ---------------------
    input  wire [8:0]  hpos,         // screen X of the pixel output this ce
    input  wire [8:0]  vpos,         // screen Y (view: 0..127; alpha: 0..255)
    input  wire [15:0] hscroll,      // view h-scroll (used iff USE_HSCROLL)
    input  wire        chacl,        // LS259 q7 (alpha only; tie 1 for view -- polepos_v.cpp:159-166)

    // ---- scanout read port (to this layer's buffer in PolePosition_subcpu) --
    output wire [10:0] scan_addr,    // word index (10 bits used; [10]=0)
    input  wire [15:0] scan_dout,    // COMBINATIONAL word read (same ce)

    // ---- gfx ROM read port (this layer's chars/tiles region) ----------------
    output reg  [12:0] gfx_addr,     // registered; data valid next clk
    input  wire [7:0]  gfx_data,     // synchronous 1-clk read

    // ---- pixel output (combinational, aligned to hpos/vpos) -----------------
    output wire [5:0]  color,        // 6-bit indirect-palette selector
    output wire [1:0]  pixel,        // 2bpp value (0 = transparent)
    output wire        bank128v      // 128V palette-bank bit (0 unless BANK_128V)
);
    localparam integer CW = $clog2(COLS);   // col index bits (alpha 5, view 6)
    localparam integer RW = $clog2(ROWS);   // row index bits (alpha 5, view 4)

    wire [8:0] sx      = hpos - 9'd256;
    wire [8:0] x_disp  = USE_HSCROLL ? (sx + hscroll[8:0]) : sx;
    wire [8:0] x_fetch = x_disp + 9'd8;             // tile prefetched this span
    wire [2:0] p       = x_disp[2:0];               // intra-tile phase 0..7

    // ---- tilemap-scan index of the PREFETCH tile ----------------------------
    wire [CW-1:0] fcol = x_fetch[3 +: CW];          // fetch tile column
    wire [RW-1:0] vrow = vpos [3 +: RW];            // tile row (same scanline)
    wire [2:0]    frow = vpos[2:0];                 // intra-tile row (fetch)
    //  SCAN_COLS : offset = col*ROWS + row ;  SCAN_ROWS : offset = row*COLS + col
    wire [10:0] fetch_index = SCAN_COLS ? { {(11-CW-RW){1'b0}}, fcol, vrow }
                                        : { {(11-CW-RW){1'b0}}, vrow, fcol };
    assign scan_addr = fetch_index;

    // ---- fetch-stage decode (word -> gfx addresses + color) -----------------
    wire [12:0] fetch_gfx_l, fetch_gfx_r;
    wire  [5:0] fetch_color;
    pp_tile_decode u_fetch (
        .tile_word (scan_dout),     // combinational fetch-tile word
        .chacl     (chacl),
        .tile_code (),
        .tile_color(fetch_color),
        .row       (frow),
        .gfx_addr_l(fetch_gfx_l),
        .gfx_addr_r(fetch_gfx_r),
        .gfx_byte_l(8'd0),          // unused on this instance
        .gfx_byte_r(8'd0),
        .col       (3'd0),
        .pixel     ()
    );

    // ---- gfx ROM fetch sequencer + tile-data latch --------------------------
    //  Prefetch tile is constant across the span (depends only on fcol/vrow),
    //  so left/right byte reads may be issued at any two phases and latched.
    reg [7:0] nxt_byte_l, nxt_byte_r;   // this-span prefetched bytes
    reg [7:0] disp_byte_l, disp_byte_r; // currently-displayed tile bytes
    reg [5:0] disp_color;

    always @(posedge clk) begin
        if (ce) begin
            //  Issue the two ROM reads at INTERIOR phases (p 2..4), never at
            //  p==0: p==0 is the x_fetch tile boundary (x_fetch = hpos+8 = D*8
            //  exactly), where the fetch-address path resolves to the PREVIOUS
            //  tile — measured: a p==0 LEFT read latched tile D-1 while a p==1
            //  RIGHT read latched tile D, so LEFT lagged RIGHT by one tile.
            //  Interior phases see the stable current fetch tile for both.
            case (p)
                3'd2: gfx_addr <= fetch_gfx_l;           // issue LEFT  addr
                3'd3: begin
                          nxt_byte_l <= gfx_data;        // capture LEFT  byte
                          gfx_addr   <= fetch_gfx_r;     // issue RIGHT addr
                      end
                3'd4: nxt_byte_r <= gfx_data;            // capture RIGHT byte
                3'd7: begin                              // latch for next span
                          disp_byte_l <= nxt_byte_l;
                          disp_byte_r <= nxt_byte_r;
                          // polepos_v.cpp:162-166 -- chacl==0 (reset default) forces
                          // color=0 regardless of VRAM contents; only the alpha
                          // instance gates on this (view ties chacl=1, always full color).
                          disp_color  <= chacl ? fetch_color : 6'd0;
                      end
                default: ; // idle phases
            endcase
        end
    end

    // ---- display-stage serialize (combinational, col = intra-tile phase) ----
    pp_tile_decode u_disp (
        .tile_word (16'd0),         // unused on this instance
        .chacl     (1'b1),
        .tile_code (),
        .tile_color(),
        .row       (3'd0),
        .gfx_addr_l(),
        .gfx_addr_r(),
        .gfx_byte_l(disp_byte_l),
        .gfx_byte_r(disp_byte_r),
        .col       (p),
        .pixel     (pixel)
    );

    assign color    = disp_color;
    assign bank128v = BANK_128V ? vpos[7] : 1'b0;

endmodule

`default_nettype wire
