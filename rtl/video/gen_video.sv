//============================================================================
//  gen_video.sv -- 1:1 transliteration of rtl/gen_video.vhd (Pole Position
//  video horizontal/vertical and sync generator, originally by Dar
//  (darfpga@aol.fr), http://darfpga.blogspot.fr).
//
//  Mechanical VHDL -> SystemVerilog port, 2026-08-05. NO intended behavior
//  change: every signal, initial value, comparison and commented-out block
//  below is preserved exactly as in the .vhd (source of truth; do not edit
//  it). Original French comments translated to English in place, same lines.
//
//  csync is declared but NEVER DRIVEN in this architecture -- the only
//  assignment to it is the commented-out block below (also commented out in
//  the .vhd). Preserved as-is; not a translation error.
//============================================================================
`default_nettype none

module gen_video (
    input  wire        clk,
    input  wire        enable,
    output wire [8:0]  hcnt,
    output wire [8:0]  vcnt,
    output wire         hsync,
    output logic        vsync,
    output wire         csync,    // composite sync for TV -- never driven, see header
    output wire         blank_h,
    output wire         blank_v,
    output logic        blankn,
    input  wire signed [3:0] h_offset,
    input  wire signed [3:0] v_offset
);

    logic [1:0] hclkReg;          // declared, unused in the source .vhd too -- preserved (Xevious leftover)
    logic       hblank;
    logic       vblank;
    logic [8:0] hcntReg = 9'd0;   // VHDL: hcntReg := to_unsigned(0,9)
    logic [8:0] vcntReg = 9'd15;  // VHDL: vcntReg := to_unsigned(15,9)

    logic hsync0;
    logic hsync1;
    logic hsync2;

    // VHDL: signal hsync_base, vsync_base : integer;  (no initializer -> power-up
    // state undefined until first assignment, same here)
    integer hsync_base;
    integer vsync_base;

    // 32-bit zero-extended views of the unsigned counters, used only where they
    // are compared against the (signed, 32-bit) hsync_base/vsync_base -- makes
    // explicit the same UNSIGNED-vs-INTEGER comparison numeric_std performs
    // implicitly in the VHDL (Verilator otherwise flags an implicit width
    // extension; the resulting comparison is numerically identical either way).
    wire [31:0] hcnt32 = 32'(hcntReg);
    wire [31:0] vcnt32 = 32'(vcntReg);

    assign blank_h = hblank;
    assign blank_v = vblank;

    assign hcnt  = hcntReg;
    assign vcnt  = vcntReg;
    assign hsync = ~hsync0;

    // Horizontal counter: 511-128+1=384 pixels (48 tiles)
    // 128 to 191: 64 pixels, start of line (8 tiles, of which the last 2 tiles are displayed)
    // 192 to 447: 256 pixels, center of line (32 tiles displayed)
    // 448 to 511: 64 pixels, end of line (8 tiles, of which the first 2 tiles are displayed)

    // Vertical counter: 263-000+1=264 lines (33 tiles)
    // 000 to 015: 16 lines, start of frame (2 tiles)
    // 016 to 239: 224 lines, center lines (28 tiles displayed)
    // 240 to 263: 24 lines, end of frame (3 tiles)

    // Horizontal sync: hcnt=[495-511/128-140] (29 pixels)
    // Vertical sync:   vcnt=[260-263/000-003] (8 lines)

    always_ff @(posedge clk) begin
        if (enable) begin    // clk & ena at 6MHz

            if (hcntReg == 511) begin
                hcntReg <= 128;
                if (vcntReg == 263) begin
                    vcntReg <= 0;
                end else begin
                    vcntReg <= vcntReg + 1;
                end
            end else begin
                hcntReg <= hcntReg + 1;
            end

            // VHDL: hsync_base <= 495 + to_integer(resize(h_offset, 9));
            // h_offset is signed; the explicit int'() cast sign-extends it to 32
            // bits before the add, matching the VHDL resize()+to_integer() step.
            hsync_base <= 495 + int'(h_offset);
            if (hcnt32 == hsync_base) begin
                hsync0 <= 1'b0;    // 1
            end else if (hcnt32 == (hsync_base+29-384)) begin
                hsync0 <= 1'b1;
            end

            if (hcnt32 == hsync_base) begin
                hsync1 <= 1'b0;
            end else if (hcnt32 == (hsync_base+13)) begin
                hsync1 <= 1'b1;    // 11
            end else if (hcnt32 == (hsync_base+192-384)) begin
                hsync1 <= 1'b0;
            end else if (hcnt32 == (hsync_base+13+192-384)) begin
                hsync1 <= 1'b1;    // 11
            end

            if (hcnt32 == hsync_base) begin
                hsync2 <= 1'b0;
            end else if (hcnt32 == (hsync_base-28)) begin
                hsync2 <= 1'b1;
            end


            //if     vcntReg = (vsync_base+ 2-1+2) mod 264 then csync <= hsync1;
            //elsif  vcntReg = (vsync_base+ 3-1+2) mod 264 then csync <= hsync1;
            //elsif  vcntReg = (vsync_base+ 4-1+2) mod 264 then csync <= hsync1; -- and hsync2;
            //elsif  vcntReg = (vsync_base+ 5-1+2) mod 264 then csync <= hsync2; -- not(hsync1);
            //elsif  vcntReg = (vsync_base+ 6-1+2) mod 264 then csync <= hsync2; -- not(hsync1);
            //elsif  vcntReg = (vsync_base+ 7-1+2) mod 264 then csync <= hsync2; -- not(hsync1) or not(hsync2);
            //elsif  vcntReg = (vsync_base+ 8-1+2) mod 264 then csync <= hsync1;
            //elsif  vcntReg = (vsync_base+ 9-1+2) mod 264 then csync <= hsync1;
            //elsif  vcntReg = (vsync_base+10-1+2) mod 264 then csync <= hsync1;
            //else                          csync <= hsync0;
            //end if;
            vsync_base <= 250 + int'(v_offset);
            if ((vcnt32 == (vsync_base+10)) && (int'(v_offset) < (263-250-10))) begin
                vsync <= 1'b1;
            end else if ((vcnt32 == (vsync_base+10-263)) && (int'(v_offset) >= (263-250-10))) begin
                vsync <= 1'b1;
            end else if ((vcnt32 == (vsync_base+17)) && (int'(v_offset) < (263-250-17))) begin
                vsync <= 1'b0;
            end else if ((vcnt32 == (vsync_base+17-263)) && (int'(v_offset) >= (263-250-17))) begin
                vsync <= 1'b0;
            end

            // Screen-position trim vs MAME (2026-07-14, HW-tuned): shift picture LEFT 2,
            // DOWN 2 via the visible-window (blank) compares. H start +N = left N (base
            // was +1; now +3 = 2 px further left, HW-confirmed V already correct at +0
            // = down 2). screen-x grows with hcnt, screen-y with vcnt.
            //
            // WIDTH fix (HW-observed "left side is fat"): this whole
            // 448/192 window was inherited unmodified from Xevious (288px: 32 tiles
            // centre + 2 extra tile-columns shown on EACH side) -- flagged but never
            // resolved in Claude/polepos_video_mapping_2026-07-13.md:302-306, since PP's
            // real MAME set_raw() visible width is 256px, not 288. The 2026-07-14 pass
            // only retuned the +1->+3 PHASE (both ends together), never the WIDTH. User
            // confirmed on real HW the excess 32px is entirely on the LEFT, so trim only
            // the deassert (left-edge/start-of-active) side by the full 32px; the assert
            // (right edge) point is untouched.
            //
            // PHASE re-tune #unverified (2026-07-28): user suspects the 2026-07-14 +3
            // (base was +1, then bumped to +3 = 2px further left) was itself mistuned --
            // dropped entirely (N=0) here, both edges together so the 256px width above
            // is preserved, net effect vs the immediately-prior state = shift RIGHT 3px.
            // HW-untested pending next compile; revert to +3 on both terms if wrong.
            // PHASE-SHIFT-2026-08-05 (HW-measured, user counted tiles): the picture
            // sat 5 tile-columns too far RIGHT -- the leftmost 5 columns belonged on
            // the right edge. Shift LEFT 5 tiles = 40 px, per this file's own
            // HW-tuned convention "H start +N = left N".
            //   +40 on BOTH compares, so the 256 px active width is PRESERVED
            //   (change one term to resize, both together to shift).
            //   assert:   448+16+8 = 472, +40 = 512 -> hcnt counts 128..511 (384
            //             wide), so it WRAPS: 512-384 = 128.
            //   deassert: 192-16+8+32 = 216, +40 = 256.
            //   Result: active 256..511 = 256 px, blanking 128..255 = 128 px, total
            //   384. The +32 already present on the deassert is the 2026-07-28 WIDTH
            //   trim (288->256 Xevious excess) and must stay -- it is not a phase term.
            // This also supersedes the untested "N=0" phase drop noted above, which
            // had shifted the picture RIGHT 3 px and was never HW-verified.
            // VERTICAL DELIBERATELY UNTOUCHED: user confirms top/bottom already align.
            // PIXCLK-PHASE-2026-08-09: REVERTED (HW-tested, user: "you broke the video
            // output with that realignment by one pixel column"). After
            // PIXCLK-FIX-2026-08-09 the picture sits 1 px too far LEFT, but moving the
            // phase term 40 -> 39 on both hblank compares did NOT fix it -- it broke
            // output entirely. Restored to 40. The 1 px offset is a KNOWN-OPEN cosmetic
            // issue; do not retry the naive both-terms-by-one shift, it has been tested
            // and failed. Likely needs the ena_vidgen/hcnt phase addressed instead,
            // since the corrected 1-in-8 enable is free-running where the old Xevious
            // slot machine self-synced to hcnt(0).
            if (hcntReg == (448+16+8+40-384)) begin        // = 128
                hblank <= 1'b1;
            end else if (hcntReg == (192-16+8+32+40)) begin // = 256
                hblank <= 1'b0;
            end

            if (vcntReg == (240+0)) begin
                vblank <= 1'b1;
            end else if (vcntReg == (016+0)) begin
                vblank <= 1'b0;
            end

            blankn <= ~(hblank | vblank);
        end
    end

endmodule

`default_nettype wire
