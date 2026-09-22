//============================================================================
//  pp_ic25.sv — Pole Position II protection custom (IC25)
//
//  Based on MAME namco/polepos.cpp, polepos2_ic25_r() by the MAME team.
//  Signed x unsigned 8-bit multiplier, read overlay on sub1 0x4000-0x5FFF.
//
//    addr[9]==0 : latch signed operand,   return last_result[7:0]
//    addr[9]==1 : latch unsigned operand, return last_result[15:8],
//                 then last_result = (int8)signed * (uint8)unsigned
//    addr[8:1]  = operand;  dout = the same byte in both halves
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

    // One pulse per access: sub1 code lives below 0x4000, so addr always
    // leaves the window between reads.
    wire start = sel & ~sel_d;
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
            // recompute only after the read has delivered the old value
            if (done && acc_unsigned) last_result <= prod[15:0];
        end
    end

endmodule

`default_nettype wire
