//============================================================================
//  gen_ram.sv -- 1:1 transliteration of rtl/gen_ram.vhd (Syntiac's generic
//  VHDL RAM support file, modified by Dar/darfpga; original header history
//  preserved verbatim below the port list). Mechanical VHDL -> SystemVerilog
//  port, 2026-08-05.
//
//  Single address port shared by the write and read processes: a genuine
//  single-port synchronous RAM. we/addr/d drive a write; q is a REGISTERED
//  read of the SAME addr, independent of we -- i.e. q updates every clock to
//  reflect ram[addr] as it stood BEFORE this edge's write (if any). This is
//  OLD-DATA read-during-write behavior (distinct from dpram_dc.vhd's
//  NEW_DATA_NO_NBE_READ same-port bypass -- see the dpram_dc.sv sim model's
//  header, under pp_maincpu/ in the verilator tree, for that contrasting case).
//  Preserved via two separate always_ff blocks mirroring the two original
//  VHDL processes exactly; Verilog/SV nonblocking-assignment semantics give
//  the same OLD-DATA result either way (an NBA's RHS is evaluated using
//  pre-edge values regardless of block/statement order), but the 1:1
//  process-for-process structure is kept for line-by-line auditability
//  against the .vhd (source of truth; do not edit that file).
//
//  rAddrReg / qReg below are declared but UNUSED -- dead since the VHDL's own
//  April-2016 "remove address register when writing" edit (see original
//  header). Preserved per the no-cruft-removal rule, not a translation gap.
//============================================================================
// -----------------------------------------------------------------------
//
// Syntiac's generic VHDL support files.
//
// -----------------------------------------------------------------------
// Copyright 2005-2008 by Peter Wendrich (pwsoft@syntiac.com)
// http://www.syntiac.com/fpga64.html
//
// Modified April 2016 by Dar (darfpga@aol.fr)
// http://darfpga.blogspot.fr
//   Remove address register when writing
//
// -----------------------------------------------------------------------
//
// gen_rwram.vhd
//
// -----------------------------------------------------------------------
//
// generic ram.
//
// -----------------------------------------------------------------------
`default_nettype none

module gen_ram #(
    parameter integer dWidth = 8,
    parameter integer aWidth = 10
)(
    input  wire                clk,
    input  wire                we,
    input  wire [aWidth-1:0]   addr,
    input  wire [dWidth-1:0]   d,
    output logic [dWidth-1:0]  q
);

    logic [dWidth-1:0] ram [0:(2**aWidth)-1];

    logic [aWidth-1:0] rAddrReg;   // dead since the 2016 edit -- preserved, see header
    logic [dWidth-1:0] qReg;       // dead since the 2016 edit -- preserved, see header

    // -----------------------------------------------------------------------
    // Signals to entity interface
    // -----------------------------------------------------------------------
    //  q <= qReg;

    // -----------------------------------------------------------------------
    // Memory write
    // -----------------------------------------------------------------------
    always_ff @(posedge clk) begin
        if (we) begin
            ram[addr] <= d;
        end
    end

    // -----------------------------------------------------------------------
    // Memory read
    // -----------------------------------------------------------------------
    always_ff @(posedge clk) begin
        //  qReg <= ram[rAddrReg];
        //  rAddrReg <= addr;
        //  qReg <= ram[addr];
        q <= ram[addr];
    end
    //q <= ram[addr];

endmodule

`default_nettype wire
