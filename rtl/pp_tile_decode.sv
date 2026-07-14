//============================================================================
//  pp_tile_decode.sv — Pole Position 2bpp tile graphics decode datapath
//
//  Covers BOTH tilemap layers — alpha ("chars") and view ("tiles") — because
//  they use the IDENTICAL MAME charlayout_2bpp (polepos.cpp:862-864). This is
//  the PP-specific replacement for the Xevious code/attr-split + 2bpp serialize
//  (poleposition.vhd:768-837); per the Part-2 audit, "only the address-gen
//  formula and the code/attr source bits need re-deriving" — that is exactly
//  and only what lives here.
//
//  SCOPE — this module is PURE COMBINATIONAL DATAPATH. It does NOT own:
//    * the tilemap-scan address (screen H/V -> buffer word index) — caller
//      drives the scan_{alpha,view}_addr port and hands the fetched word in
//      (that mapping needs a polepos_v.cpp tilemap-scan read; still TODO);
//    * fetch scheduling / scan-port arbitration — the future slot scheduler
//      (conversion-plan step 5, the CE-domain-vs-clock_18 open question);
//    * global screen (cocktail) flip — caller applies it to `row`/`col` the
//      same way Xevious XORs hcnt(2:0) with `flip` (poleposition.vhd:833).
//  Those are Xevious-reusable structure + the new arbiter; they wrap THIS.
//
//  Ground truth:
//    charlayout_2bpp   : polepos.cpp:820-829  (8x8, 2bpp, planeoffset {0,4},
//                        16 bytes/tile; byte y = LEFT 4px, byte y+8 = RIGHT 4px,
//                        each byte nibble-planar: lo nibble=plane0, hi=plane1)
//    code/color unpack : polepos_v.cpp:145-171 (bg_/tx_get_tile_info), distilled
//                        in Claude/polepos_video_mapping_2026-07-13.md §2
//============================================================================

`default_nettype none

module pp_tile_decode
(
    // ---- tile attribute word (one scan_{alpha,view}_dout, 16-bit) -----------
    input  wire [15:0] tile_word,
    output wire  [8:0] tile_code,      // 9-bit; bit8 = word[14] (see #unverified)
    output wire  [5:0] tile_color,     // 6-bit indirect-palette selector

    // ---- gfx ROM byte-address generation (2bpp, planes {0,4}) ---------------
    input  wire  [2:0] row,            // intra-tile row 0..7 (caller pre-applies
                                       //   any global V-flip)
    output wire [11:0] gfx_addr_l,     // LEFT  half (x0..3) = {code8, 1'b0, row}
    output wire [11:0] gfx_addr_r,     // RIGHT half (x4..7) = {code8, 1'b1, row}

    // ---- 2bpp nibble-planar serialize ---------------------------------------
    input  wire  [7:0] gfx_byte_l,     // fetched byte @ gfx_addr_l
    input  wire  [7:0] gfx_byte_r,     // fetched byte @ gfx_addr_r
    input  wire  [2:0] col,            // intra-tile column 0..7 (caller pre-
                                       //   applies any global H-flip)
    output wire  [1:0] pixel           // 2bpp value; 0 = transparent (MAME conv.)
);

    // ---- code / color unpack -------------------------------------------------
    //   MAME: code  = (word & 0xff) | ((word & 0x4000) >> 6)  = {word[14],word[7:0]}
    //         color = (word & 0x3f00) >> 8                    = word[13:8]
    assign tile_code  = { tile_word[14], tile_word[7:0] };
    assign tile_color = tile_word[13:8];

    // #unverified (video_mapping §7 open question): code bit8 (word[14]) makes a
    // 9-bit code against a 256-tile / 0x1000-byte region. Real HW may wrap
    // mod-256, OR word[14] may be a dead / bank-select line. We DROP it here
    // (mask to code[7:0]) — the safe "fits the 0x1000 region exactly" default.
    // Revisit only if attract/boot art shows wrong-tile artifacts.
    wire [7:0] code8 = tile_code[7:0];

    // ---- gfx ROM byte address (charlayout_2bpp) ------------------------------
    //   16 bytes/tile; per row y two bytes: offset y = LEFT 4px, 8+y = RIGHT 4px.
    //   addr = {code8, half, row}  (half 0=left, 1=right)  -> 12 bits = 0x1000.
    assign gfx_addr_l = { code8, 1'b0, row };
    assign gfx_addr_r = { code8, 1'b1, row };

    // ---- 2bpp serialize ------------------------------------------------------
    //   Each byte holds 4 pixels, nibble-planar:
    //     pixel(x) = { byte[(x&3)+4], byte[x&3] }   (plane1 = MSB, plane0 = LSB)
    //   x<4 -> left byte, x>=4 -> right byte  (col[2] selects the half).
    wire [7:0] sel_byte = col[2] ? gfx_byte_r : gfx_byte_l;
    // Name the nibble bit indices as plain wires. A concatenation used *inside*
    // a bit-select (`sel_byte[{1'b1,col[1:0]}]`) mis-evaluated for indices 6/7
    // under Verilator — same hazard as expression bit-selects; name it first.
    wire [2:0] bit_p0 = {1'b0, col[1:0]};   // plane 0 -> byte bits 0..3
    wire [2:0] bit_p1 = {1'b1, col[1:0]};   // plane 1 -> byte bits 4..7
    assign pixel = { sel_byte[bit_p1], sel_byte[bit_p0] };

endmodule

`default_nettype wire
