//  Based on MAME polepos.cpp (Ernesto Corvi, Juergen Buchmueller, Alex Pasadyn, Aaron Giles, Nicola Salmoria, BSD-3-Clause)

`default_nettype none

module pp_ic25
(
    input  wire        clk,
    input  wire        rst_n,
    input  wire        sel,
    input  wire  [9:1] addr,       // sub1 byte address; [9]=branch, [8:1]=operand
    output wire [15:0] dout
);
    reg  [7:0]  last_signed;
    reg  [7:0]  last_unsigned;
    reg  [15:0] last_result;
    reg         sel_d;
    reg         acc_unsigned;

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
            if (done && acc_unsigned) last_result <= prod[15:0];
        end
    end

endmodule

`default_nettype wire
