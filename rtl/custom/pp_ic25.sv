//============================================================================
//  pp_ic25.sv — Pole Position II protection custom (IC25)
//
//  Ground truth: polepos.cpp:259-282 polepos2_ic25_r(), mapped by
//  polepos2_z8002_map_1() at sub1 0x4000-0x5FFF as a READ overlay on the ROM.
//  Only machine `polepos2` has it: polepos2/polepos2a. The bootleg polepos2b
//  is machine=`polepos` and "has a hacked ROM in its place" (MAME's comment),
//  so it must NOT be enabled there -- hence the runtime ic25_en gate.
//
//  MAME, with `offset` the WORD index into the window, masked to 9 bits:
//      offset < 0x100 : last_signed   = offset[7:0];  result = last_result[7:0]
//      offset >= 0x100: last_unsigned = offset[7:0];  result = last_result[15:8]
//                       then last_result = (int8)last_signed * (uint8)last_unsigned
//      returns result | (result << 8)   -- the same byte in both halves
//
//  Word index = (byte_addr & 0x1FFF) >> 1, so offset[8:0] = addr[9:1]:
//  addr[9] selects the signed/unsigned branch, addr[8:1] is the operand.
//
//  Ordering matters: the read returns the PREVIOUS product and only then
//  recomputes. `dout` is therefore combinational from last_result (stable for
//  the whole access), the operand is latched when the access starts, and the
//  multiply lands when it ends -- so a multi-cycle CPU read never sees the
//  value change under it.
//============================================================================

`default_nettype none

module pp_ic25
(
    input  wire        clk,
    input  wire        rst_n,
    input  wire        sel,        // read access in progress to the IC25 window
    input  wire  [9:1] addr,       // sub1 byte address; [9]=branch, [8:1]=operand
    output wire [15:0] dout
);
    reg  [7:0]  last_signed;
    reg  [7:0]  last_unsigned;
    reg  [15:0] last_result;
    reg         sel_d;
    reg         acc_unsigned;      // branch taken by the access in progress

    wire start = sel & ~sel_d;     // one pulse per access: addr leaves the
                                   // window between reads (PC lives below
                                   // 0x4000), so entries are separable
    wire done  = ~sel & sel_d;

    wire signed [15:0] prod = $signed({{8{last_signed[7]}}, last_signed})
                            * $signed({8'd0, last_unsigned});

    wire [7:0] result = addr[9] ? last_result[15:8] : last_result[7:0];
    assign dout = { result, result };

    always @(posedge clk) begin
        sel_d <= sel;
        if (!rst_n) begin
            last_signed   <= 8'd0;
            last_unsigned <= 8'd0;
            last_result   <= 16'd0;
            sel_d         <= 1'b0;
            acc_unsigned  <= 1'b0;
        end
        else begin
            if (start) begin
                acc_unsigned <= addr[9];
                if (addr[9]) last_unsigned <= addr[8:1];
                else         last_signed   <= addr[8:1];
            end
            // recompute only after the unsigned read has delivered the old value
            if (done && acc_unsigned) last_result <= prod[15:0];
        end
    end

endmodule

`default_nettype wire
