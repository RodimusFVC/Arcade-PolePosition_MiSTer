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
    input  wire        chacl,          // alpha: LS259 q7. 0 => code masked to 8b
    output wire  [8:0] tile_code,      // 9-bit; bit8 = word[14]
    output wire  [5:0] tile_color,     // 6-bit indirect-palette selector

    // ---- gfx ROM byte-address generation (2bpp, planes {0,4}) ---------------
    input  wire  [2:0] row,            // intra-tile row 0..7 (caller pre-applies
                                       //   any global V-flip)
    output wire [12:0] gfx_addr_l,     // LEFT  half (x0..3) = {code9, 1'b0, row}
    output wire [12:0] gfx_addr_r,     // RIGHT half (x4..7) = {code9, 1'b1, row}

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

    // Code bit8 (word[14]) is LIVE: PP2 has 512 tiles. chacl==0 masks it to 8
    // bits on the alpha layer only (polepos_v.cpp:162-166); the view layer ties
    // chacl=1, matching bg_get_tile_info which has no such mask. PP1 needs no
    // per-game gate: its MRA mirrors the 0x1000 chars/tiles ROM across the
    // 0x2000 window, so code 256+N reads tile N -- what a 4 KB ROM with no A12
    // does on real hardware, and what MAME's `code %= total_elements` does
    // (charlayout_2bpp is RGN_FRAC(1,1), so elements track the region size).
    wire [8:0] code9 = chacl ? tile_code : { 1'b0, tile_code[7:0] };

    // ---- gfx ROM byte address (charlayout_2bpp) ------------------------------
    //   16 bytes/tile; per row y two bytes: offset y = LEFT 4px, 8+y = RIGHT 4px.
    //   addr = {code8, half, row}  (half 0=left, 1=right)  -> 12 bits = 0x1000.
    assign gfx_addr_l = { code9, 1'b0, row };
    assign gfx_addr_r = { code9, 1'b1, row };

    // ---- 2bpp serialize ------------------------------------------------------
    //   Derived directly from MAME's charlayout_2bpp (Useful Stuff/mame/polepos.cpp:820-829):
    //     planeoffset{0,4}, xoffset{0,1,2,3, 8*8+0..3}, MSB-first bit addressing
    //     (bit-address B -> byte B/8, bit (7-B%8)). Working it through for one
    //     4px half-byte: plane0 (offset 0) lands on bits 7,6,5,4 for x=0,1,2,3
    //     and plane1 (offset 4) lands on bits 3,2,1,0 for x=0,1,2,3 -- i.e. the
    //     HIGH nibble is plane0 (not the low nibble), and x INCREASES as the
    //     bit position DECREASES within each nibble (x=0 at the nibble's top
    //     bit). Getting either of these backwards was silently plausible (both
    //     compile and "do something") -- this is why it needed re-deriving from
    //     the source instead of re-guessing: FIX-2026-07-28 for a real, visually
    //     confirmed horizontal mirror (was also a latent plane/color swap).
    //   x<4 -> left byte, x>=4 -> right byte  (col[2] selects the half).
    wire [7:0] sel_byte = col[2] ? gfx_byte_r : gfx_byte_l;
    wire [1:0] x_in_half = col[1:0];
    wire [2:0] bit_p0 = {1'b1, ~x_in_half};   // plane0 -> bits 7,6,5,4 as x=0,1,2,3
    wire [2:0] bit_p1 = {1'b0, ~x_in_half};   // plane1 -> bits 3,2,1,0 as x=0,1,2,3
    // TILEPEN-ORDER-FIX-2026-08-16: plane0 is the MSB, not the LSB.
    // Same fault as PENORDER-FIX-2026-08-16 in pp_sprite_gen.sv, which was
    // HW-CONFIRMED today: MAME's decode gives plane 0 the HIGH pen bit
    // (planebit = 1 << (planes-1-plane)). This line had the 2bpp equivalent
    // backwards. For 2bpp, reversal swaps pen1<->pen2 and leaves pen0/pen3
    // fixed, so silhouettes and backgrounds look fine while DETAIL and FILL
    // trade colours -- the mountains' light angled dashes rendered as a brown
    // smear on teal instead of light dashes on brown (user, 2026-08-16).
    // ⚠️ This also feeds the ALPHA layer. Text that uses only pen0/pen3 is
    // unaffected (both are fixed points); if any HUD text changes colour,
    // that is this change and it needs re-checking, not the view layer.
    // assign pixel = { sel_byte[bit_p1], sel_byte[bit_p0] };   // ORIGINAL
    assign pixel = { sel_byte[bit_p0], sel_byte[bit_p1] };

endmodule

`default_nettype wire
