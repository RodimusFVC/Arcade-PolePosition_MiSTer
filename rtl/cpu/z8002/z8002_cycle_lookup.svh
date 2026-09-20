// BATCH 9 2026-07-28: cycle-accuracy lookup table, mechanically generated from a
// script cross-referencing every dispatch condition in this file (as of the 0x2F/
// 0x0D guard fixes) against MAME's z8000tbl.hxx cycle-count column, replaying
// MAME's own init_tables() last-entry-wins overlap resolution to build a 65536-word
// oracle first. 175/181 conditions had a single uniform MAME cycle count (used
// directly); 6 needed sub-splitting on bits the RTL already decodes (documented
// inline below). Condition text is a verbatim, mechanically-copied match of each
// real dispatch arm above -- never hand-retyped, to guarantee correspondence.
function automatic [15:0] lookup_cycles(input [15:0] din);
    if (din[15:8]==8'h8D && din[3:0]==4'h8) lookup_cycles = 16'd7;
    else if (din[15:8]==8'h21) lookup_cycles = 16'd7;
    else if (din[15:8]==8'hA1 || din[15:8]==8'h81 || din[15:8]==8'h83 || din[15:8]==8'h85 || din[15:8]==8'h87 || din[15:8]==8'h89 || din[15:8]==8'h8B) lookup_cycles = (din[15:8]==8'hA1) ? 16'd3 : 16'd4;
    else if (din[15:8]==8'h01 || din[15:8]==8'h03 || din[15:8]==8'h05 || din[15:8]==8'h07 || din[15:8]==8'h09 || din[15:8]==8'h0B) lookup_cycles = 16'd7;
    else if (din[15:8]==8'h00 && din[7:4]!=4'h0) lookup_cycles = 16'd7;
    else if (din[15:8]==8'h2F && din[7:4]!=4'h0) lookup_cycles = 16'd8;
    else if (din[15:8]==8'hB3 && din[3:0]==4'h1) lookup_cycles = 16'd13;
    else if (din[15:8]==8'hB3 && din[3:0]==4'h9) lookup_cycles = 16'd13;
    else if (din[15:8]==8'hB3 && din[3:0]==4'hD) lookup_cycles = 16'd13;
    else if (din[15:8]==8'hB3 && din[3:0]==4'h5) lookup_cycles = 16'd13;
    else if (din[15:8]==8'h76 && din[7:4]==4'h0) lookup_cycles = 16'd12;
    else if (din[15:8]==8'h76 && din[7:4]!=4'h0) lookup_cycles = 16'd13;
    else if (din[15:8]==8'h71 && din[7:4]!=4'h0) lookup_cycles = 16'd14;
    else if (din[15:8]==8'h5E) lookup_cycles = (din[7:4]==4'h0) ? 16'd7 : 16'd8; // BATCH 16: direct(Z5E_0000_cccc_addr)=7 vs indexed(Z5E_ddN0_cccc_addr)=8, per z8000tbl.hxx -- was previously undifferentiated (7 for both), harmless before the JP indexed FIX since the wrong-target bug never got real test coverage to notice the cycle mismatch either.
    else if (din[15:8]==8'h61 && din[7:4]==4'h0) lookup_cycles = 16'd9;
    else if (din[15:8]==8'h6F && din[7:4]==4'h0) lookup_cycles = 16'd11;
    else if (din[15:8]==8'h0D && din[3:0]==4'h5 && din[7:4]!=4'h0) lookup_cycles = 16'd11;
    // ===================== CYCLE4D-2026-09-05 ==============================
    // Was two 2-way splits that only captured din[3:0]==5 (direct) and ==4
    // (indexed). Those were CORRECT for the opcodes dispatching when BATCH 9
    // generated this table on 2026-07-28 -- 4D04/4D05/4D08 are still right.
    // 4D00/01/02/06 were decoded LATER (4D01 on 2026-08-09, the silent-hang
    // fix) and silently inherited the arm default, so the split went stale.
    // MAME z8000tbl.hxx is uniform per low nibble, and the indexed form
    // (din[7:4]!=0) is exactly the direct form +1. Measured against MAME via
    // --dumpcycles: 49 wrong entries -> 0. These 49 were the ONLY wrong entries
    // in the whole 65536 space; every other mismatch is an opcode with no table
    // entry at all (deliberately unimplemented, falls through to the final =4).
    // 4D01 is used 41x across pp_sub1/sub2.
    //
    // TO RIP OUT: delete this block and restore the two lines:
    //   else if (din[15:8]==8'h4D && din[7:4]==4'h0) lookup_cycles = (din[3:0]==4'h5) ? 16'd14 : 16'd11;
    //   else if (din[15:8]==8'h4D && din[7:4]!=4'h0) lookup_cycles = (din[3:0]==4'h4) ? 16'd12 : 16'd15;
    // =======================================================================
    else if (din[15:8]==8'h4D) begin
        case (din[3:0])
            4'h0:    lookup_cycles = (din[7:4]==4'h0) ? 16'd15 : 16'd16;
            4'h1:    lookup_cycles = (din[7:4]==4'h0) ? 16'd14 : 16'd15;
            4'h2:    lookup_cycles = (din[7:4]==4'h0) ? 16'd15 : 16'd16;
            4'h4:    lookup_cycles = (din[7:4]==4'h0) ? 16'd11 : 16'd12;
            4'h5:    lookup_cycles = (din[7:4]==4'h0) ? 16'd14 : 16'd15;
            4'h6:    lookup_cycles = (din[7:4]==4'h0) ? 16'd14 : 16'd15;
            4'h8:    lookup_cycles = (din[7:4]==4'h0) ? 16'd11 : 16'd12;
            // never dispatched -- keep the prior arm defaults, unmeasured
            default: lookup_cycles = (din[7:4]==4'h0) ? 16'd11 : 16'd15;
        endcase
    end
    else if (din[15:8]==8'hAB) lookup_cycles = 16'd4;
    else if (din[15:8]==8'hAA) lookup_cycles = 16'd4;
    else if (din[15:8]==8'hA9) lookup_cycles = 16'd4;
    else if (din[15:8]==8'hA8) lookup_cycles = 16'd4;
    else if (din[15:12]==4'hF) lookup_cycles = 16'd11;
    else if (din[15:12]==4'hE) lookup_cycles = 16'd6;
    else if (din==16'h7B00) lookup_cycles = 16'd13;
    else if (din[15:8]==8'h7C && din[7:3]==5'h00) lookup_cycles = 16'd7;
    else if (din[15:8]==8'h7D && din[3]==1'b0) lookup_cycles = 16'd7;
    else if (din[15:8]==8'h7D && din[3]==1'b1) lookup_cycles = 16'd7;
    else if (din[15:8]==8'h1F && din[7:4]!=4'h0 && din[3:0]==4'h0) lookup_cycles = 16'd10;
    else if (din==16'h5F00) lookup_cycles = 16'd12;
    else if (din[15:12]==4'hD) lookup_cycles = 16'd10;
    else if (din[15:8]==8'h9E && din[7:4]==4'h0) lookup_cycles = 16'd10;
    else if (din[15:8]==8'h93 && din[7:4]!=4'h0) lookup_cycles = 16'd9;
    else if (din[15:8]==8'h0D && din[7:4]!=4'h0 && din[3:0]==4'h9) lookup_cycles = 16'd12;
    else if (din[15:8]==8'h53 && din[7:4]!=4'h0 && din[3:0]==4'h0) lookup_cycles = 16'd14;
    else if (din[15:8]==8'h97 && din[7:4]!=4'h0) lookup_cycles = 16'd8;
    else if (din[15:8]==8'h57 && din[7:4]!=4'h0 && din[3:0]==4'h0) lookup_cycles = 16'd16;
    else if (din[15:8]==8'h91 && din[7:4]!=4'h0) lookup_cycles = 16'd12;
    else if (din[15:8]==8'h95 && din[7:4]!=4'h0) lookup_cycles = 16'd12;
    else if (din[15:8]==8'h94) lookup_cycles = 16'd5;
    else if (din[15:8]==8'h14 && din[7:4]==4'h0) lookup_cycles = 16'd11;
    else if (din[15:8]==8'h14 && din[7:4]!=4'h0) lookup_cycles = 16'd11;
    else if (din[15:8]==8'h1D && din[7:4]!=4'h0) lookup_cycles = 16'd11;
    else if (din[15:8]==8'h54 && din[7:4]==4'h0) lookup_cycles = 16'd12;
    else if (din[15:8]==8'h54 && din[7:4]!=4'h0) lookup_cycles = 16'd13;
    else if (din[15:8]==8'h5D && din[7:4]==4'h0) lookup_cycles = 16'd15;
    else if (din[15:8]==8'h5D && din[7:4]!=4'h0) lookup_cycles = 16'd14;
    else if (din[15:8]==8'h1C && din[7:4]!=4'h0 && din[3:0]==4'h1) lookup_cycles = 16'd11;
    else if (din[15:8]==8'h1C && din[7:4]!=4'h0 && din[3:0]==4'h9) lookup_cycles = 16'd11;
    else if (din==16'h5C09) lookup_cycles = 16'd14;
    else if (din==16'h5C01) lookup_cycles = 16'd14;
    else if (din[15:8]==8'h11 && din[7:4]!=4'h0 && din[3:0]!=4'h0) lookup_cycles = 16'd20;
    else if (din[15:8]==8'h13 && din[7:4]!=4'h0 && din[3:0]!=4'h0) lookup_cycles = 16'd13;
    else if (din[15:8]==8'h15 && din[7:4]!=4'h0 && din[3:0]!=4'h0) lookup_cycles = 16'd19;
    else if (din[15:8]==8'h17 && din[7:4]!=4'h0 && din[3:0]!=4'h0) lookup_cycles = 16'd12;
    else if (din[15:8]==8'h00 && din[7:4]==4'h0) lookup_cycles = 16'd7;
    else if (din[15:8]==8'h02) lookup_cycles = 16'd7;
    else if (din[15:8]==8'h04) lookup_cycles = 16'd7;
    else if (din[15:8]==8'h06) lookup_cycles = 16'd7;
    else if (din[15:8]==8'h08) lookup_cycles = 16'd7;
    else if (din[15:8]==8'h0A) lookup_cycles = 16'd7;
    else if (din[15:8]==8'h20) lookup_cycles = 16'd7;
    else if (din[15:8]==8'h80 || din[15:8]==8'h82 || din[15:8]==8'h84 || din[15:8]==8'h86 || din[15:8]==8'h88 || din[15:8]==8'h8A || din[15:8]==8'hA0) lookup_cycles = (din[15:8]==8'hA0) ? 16'd3 : 16'd4;
    else if (din[15:8]==8'h2E && din[7:4]!=4'h0) lookup_cycles = 16'd8;
    else if (din[15:8]==8'h1E && din[7:4]!=4'h0) lookup_cycles = 16'd10;
    else if (din[15:8]==8'h10 && din[7:4]!=4'h0) lookup_cycles = 16'd14;
    else if (din[15:8]==8'h90) lookup_cycles = 16'd8;
    else if (din[15:8]==8'h26 && din[7:4]!=4'h0) lookup_cycles = 16'd8;
    else if (din[15:8]==8'h27 && din[7:4]!=4'h0) lookup_cycles = 16'd8;
    else if (din[15:8]==8'h23 && din[7:4]!=4'h0) lookup_cycles = 16'd11;
    else if (din[15:8]==8'h25 && din[7:4]!=4'h0) lookup_cycles = 16'd11;
    else if (din[15:8]==8'h2D && din[7:4]!=4'h0) lookup_cycles = 16'd12;
    else if (din[15:8]==8'h69 && din[7:4]==4'h0) lookup_cycles = 16'd13;
    else if (din[15:8]==8'h6B && din[7:4]==4'h0) lookup_cycles = 16'd13;
    else if (din[15:8]==8'h19 && din[7:4]==4'h0) lookup_cycles = 16'd70;
    else if (din[15:8]==8'h19 && din[7:4]!=4'h0) lookup_cycles = 16'd70;
    else if (din[15:8]==8'h99) lookup_cycles = 16'd70;
    else if (din[15:8]==8'h1B && din[7:4]==4'h0) lookup_cycles = 16'd107;
    else if (din[15:8]==8'h1B && din[7:4]!=4'h0) lookup_cycles = 16'd107;
    else if (din[15:8]==8'h9B) lookup_cycles = 16'd107;
    else if (din[15:8]==8'h18 && din[7:4]!=4'h0) lookup_cycles = 16'd282;
    else if (din[15:8]==8'h98) lookup_cycles = 16'd282;
    else if (din[15:8]==8'h1A && din[7:4]!=4'h0) lookup_cycles = 16'd744;
    else if (din[15:8]==8'h9A) lookup_cycles = 16'd744;
    else if (din[15:8]==8'h16 && din[7:4]==4'h0) lookup_cycles = 16'd14;
    else if (din[15:8]==8'h16 && din[7:4]!=4'h0) lookup_cycles = 16'd14;
    else if (din[15:8]==8'h96) lookup_cycles = 16'd8;
    else if (din[15:8]==8'h12 && din[7:4]==4'h0) lookup_cycles = 16'd14;
    else if (din[15:8]==8'h12 && din[7:4]!=4'h0) lookup_cycles = 16'd14;
    else if (din[15:8]==8'h92) lookup_cycles = 16'd8;
    else if (din[15:8]==8'h60 && din[7:4]==4'h0) lookup_cycles = 16'd9;
    else if (din[15:8]==8'h6E && din[7:4]==4'h0) lookup_cycles = 16'd11;
    else if (din[15:8]==8'h8C && din[3:0]==4'h8) lookup_cycles = 16'd7;
    else if (din[15:8]==8'h8C && din[3:0]==4'h4) lookup_cycles = 16'd7;
    else if (din[15:8]==8'hB2 && (din[3:0]==4'h0 || din[3:0]==4'h2)) lookup_cycles = 16'd6;
    else if (din[15:8]==8'hB2 && (din[3:0]==4'h4 || din[3:0]==4'h6)) lookup_cycles = 16'd6;
    else if (din[15:8]==8'hB2 && (din[3:0]==4'hC || din[3:0]==4'hE)) lookup_cycles = 16'd9;
    else if (din[15:8]==8'hB2 && din[3:0]==4'h1) lookup_cycles = 16'd13;
    else if (din[15:8]==8'h50 && din[7:4]==4'h0) lookup_cycles = 16'd15;
    else if (din[15:8]==8'h60 && din[7:4]!=4'h0) lookup_cycles = 16'd10;
    else if (din[15:8]==8'h6E && din[7:4]!=4'h0) lookup_cycles = 16'd11;
    else if (din[15:8]==8'h50 && din[7:4]!=4'h0) lookup_cycles = 16'd16;
    else if (din[15:8]==8'h69 && din[7:4]!=4'h0) lookup_cycles = 16'd14;
    else if (din[15:8]==8'h6B && din[7:4]!=4'h0) lookup_cycles = 16'd14;
    else if (din[15:8]==8'h8D && din[3:0]==4'h2) lookup_cycles = 16'd7;
    else if (din[15:8]==8'h8D && din[3:0]==4'h0) lookup_cycles = 16'd7;
    else if (din[15:8]==8'hB1 && din[3:0]==4'h0) lookup_cycles = 16'd11;
    else if (din[15:8]==8'hB0 && din[3:0]==4'h0) lookup_cycles = 16'd5;
    else if (din[15:8]==8'hB1 && din[3:0]==4'hA) lookup_cycles = 16'd11;
    else if (din[15:8]==8'h22 && din[7:4]!=4'h0) lookup_cycles = 16'd11;
    else if (din[15:8]==8'h24 && din[7:4]!=4'h0) lookup_cycles = 16'd11;
    else if (din[15:8]==8'h2C && din[7:4]!=4'h0) lookup_cycles = 16'd12;
    else if (din[15:8]==8'hAC) lookup_cycles = 16'd6;
    else if (din[15:8]==8'hB4) lookup_cycles = 16'd5;
    else if (din[15:8]==8'hB5) lookup_cycles = 16'd5;
    else if (din[15:8]==8'hB6) lookup_cycles = 16'd5;
    else if (din[15:8]==8'hB7) lookup_cycles = 16'd5;
    else if (din[15:8]==8'h62 && din[7:4]==4'h0) lookup_cycles = 16'd13;
    else if (din[15:8]==8'h62 && din[7:4]!=4'h0) lookup_cycles = 16'd14;
    else if (din[15:8]==8'h63 && din[7:4]==4'h0) lookup_cycles = 16'd13;
    else if (din[15:8]==8'h63 && din[7:4]!=4'h0) lookup_cycles = 16'd14;
    else if (din[15:8]==8'h64 && din[7:4]==4'h0) lookup_cycles = 16'd13;
    else if (din[15:8]==8'h64 && din[7:4]!=4'h0) lookup_cycles = 16'd14;
    else if (din[15:8]==8'h65 && din[7:4]==4'h0) lookup_cycles = 16'd13;
    else if (din[15:8]==8'h65 && din[7:4]!=4'h0) lookup_cycles = 16'd14;
    else if (din[15:8]==8'h66 && din[7:4]==4'h0) lookup_cycles = 16'd10;
    else if (din[15:8]==8'h66 && din[7:4]!=4'h0) lookup_cycles = 16'd11;
    else if (din[15:8]==8'h67 && din[7:4]==4'h0) lookup_cycles = 16'd10;
    else if (din[15:8]==8'h67 && din[7:4]!=4'h0) lookup_cycles = 16'd11;
    else if (din[15:8]==8'h6C && din[7:4]==4'h0) lookup_cycles = 16'd15;
    else if (din[15:8]==8'h6C && din[7:4]!=4'h0) lookup_cycles = 16'd16;
    else if (din[15:8]==8'h6D && din[7:4]==4'h0) lookup_cycles = 16'd15;
    else if (din[15:8]==8'h6D && din[7:4]!=4'h0) lookup_cycles = 16'd16;
    else if (din[15:8]==8'hAD) lookup_cycles = 16'd6;
    else if (din[15:8]==8'h0C && din[7:4]!=4'h0 && din[3:0]==4'h4) lookup_cycles = 16'd8;
    else if (din[15:8]==8'h0C && din[7:4]!=4'h0 && din[3:0]==4'h6) lookup_cycles = 16'd11;
    else if (din[15:8]==8'h0C && din[7:4]!=4'h0 && din[3:0]==4'h8) lookup_cycles = 16'd8;
    else if (din[15:8]==8'h0D && din[7:4]!=4'h0 && din[3:0]==4'h0) lookup_cycles = 16'd12;
    else if (din[15:8]==8'h0D && din[7:4]!=4'h0 && din[3:0]==4'h1) lookup_cycles = 16'd11;
    else if (din[15:8]==8'h0D && din[7:4]!=4'h0 && din[3:0]==4'h2) lookup_cycles = 16'd12;
    else if (din[15:8]==8'h0D && din[7:4]!=4'h0 && din[3:0]==4'h4) lookup_cycles = 16'd8;
    else if (din[15:8]==8'h0D && din[7:4]!=4'h0 && din[3:0]==4'h6) lookup_cycles = 16'd11;
    else if (din[15:8]==8'h0D && din[7:4]!=4'h0 && din[3:0]==4'h8) lookup_cycles = 16'd8;
    else if (din[15:8]>=8'h40 && din[15:8]<=8'h4B) lookup_cycles = (din[7:4]==4'h0) ? 16'd9 : 16'd10;
    else if (din[15:8]==8'h10 && din[7:4]==4'h0) lookup_cycles = 16'd14;
    else if (din[15:8]==8'h28 && din[7:4]!=4'h0) lookup_cycles = 16'd11;
    else if (din[15:8]==8'h29 && din[7:4]!=4'h0) lookup_cycles = 16'd11;
    else if (din[15:8]==8'h2A && din[7:4]!=4'h0) lookup_cycles = 16'd11;
    else if (din[15:8]==8'h2B && din[7:4]!=4'h0) lookup_cycles = 16'd11;
    else if (din[15:8]==8'h68 && din[7:4]==4'h0) lookup_cycles = 16'd13;
    else if (din[15:8]==8'h68 && din[7:4]!=4'h0) lookup_cycles = 16'd14;
    else if (din[15:8]==8'h6A && din[7:4]==4'h0) lookup_cycles = 16'd13;
    else if (din[15:8]==8'h6A && din[7:4]!=4'h0) lookup_cycles = 16'd14;
    else if (din[15:8]==8'h61 && din[7:4]!=4'h0) lookup_cycles = 16'd10;
    else if (din[15:8]==8'h6F && din[7:4]!=4'h0) lookup_cycles = 16'd12;
    else if (din[15:8]==8'h8C && din[3:0]==4'h0) lookup_cycles = 16'd7;
    else if (din[15:8]==8'h8C && din[3:0]==4'h2) lookup_cycles = 16'd7;
    else if (din[15:8]==8'h8C && din[3:0]==4'h6) lookup_cycles = 16'd7;
    else if (din[15:8]==8'h8C && din[3:0]==4'h1) lookup_cycles = 16'd7;
    else if (din[15:8]==8'h8C && din[3:0]==4'h9) lookup_cycles = 16'd7;
    else if (din==16'h8D07) lookup_cycles = 16'd7;
    else if (din[15:8]==8'h8D && din[3:0]==4'h4) lookup_cycles = 16'd7;
    else if (din[15:8]==8'h8D && din[3:0]==4'h6) lookup_cycles = 16'd7;
    else if (din[15:8]==8'h8D && din[3:0]==4'h1) lookup_cycles = 16'd7;
    else if (din[15:8]==8'h8D && din[3:0]==4'h3) lookup_cycles = 16'd7;
    else if (din[15:8]==8'h8D && din[3:0]==4'h5) lookup_cycles = 16'd7;
    else if (din[15:8]==8'h9C && (din[3:0]==4'h0 || din[3:0]==4'h8)) lookup_cycles = 16'd13;
    else if (din[15:8]==8'hA2) lookup_cycles = 16'd4;
    else if (din[15:8]==8'hA3) lookup_cycles = 16'd4;
    else if (din[15:8]==8'hA4) lookup_cycles = 16'd4;
    else if (din[15:8]==8'hA5) lookup_cycles = 16'd4;
    else if (din[15:8]==8'hA6) lookup_cycles = 16'd4;
    else if (din[15:8]==8'hA7) lookup_cycles = 16'd4;
    else if (din[15:8]==8'hAE) lookup_cycles = 16'd5;
    else if (din[15:8]==8'hAF) lookup_cycles = 16'd5;
    else if (din[15:8]==8'hBD) lookup_cycles = 16'd5;
    else if (din[15:8]==8'hBC) lookup_cycles = 16'd9;
    else if (din[15:8]==8'hBE) lookup_cycles = 16'd9;
    else if (din[15:8]==8'hB1 && din[3:0]==4'h7) lookup_cycles = 16'd11;
    else if (din[15:12]==4'hC) lookup_cycles = 16'd5;
    else lookup_cycles = 16'd4; // unimplemented/illegal -- MAME's own zinvalid default
endfunction
