//  Based on MAME polepos_a.cpp (Derrick Renaud, BSD-3-Clause)
`default_nettype none

module pp_voice52_snd
(
    input  wire        clk,
    input  wire        reset,
    input  wire        pause,

    input  wire  [3:0] p_data,

    output reg signed [15:0] audio
);

    localparam HP_SHIFT  = 6;
    localparam LP_SHIFT  = 3;
    localparam OUT_SHIFT = 11;

    reg [9:0] tick_div;
    reg       tick;
    always @(posedge clk) begin
        tick <= 1'b0;
        if (reset) begin
            tick_div <= 10'd0;
        end
        else if (!pause) begin
            tick_div <= tick_div + 10'd1;
            if (tick_div == 10'd1023) tick <= 1'b1;
        end
    end

    reg signed [15:0] dac_q12;
    always @(*) begin
        case (p_data)
            4'h0: dac_q12 = -16'sd8192;
            4'h1: dac_q12 = -16'sd7265;
            4'h2: dac_q12 = -16'sd6220;
            4'h3: dac_q12 = -16'sd5293;
            4'h4: dac_q12 = -16'sd3978;
            4'h5: dac_q12 = -16'sd3051;
            4'h6: dac_q12 = -16'sd2006;
            4'h7: dac_q12 = -16'sd1079;
            4'h8: dac_q12 =  16'sd1079;
            4'h9: dac_q12 =  16'sd2006;
            4'hA: dac_q12 =  16'sd3051;
            4'hB: dac_q12 =  16'sd3978;
            4'hC: dac_q12 =  16'sd5293;
            4'hD: dac_q12 =  16'sd6220;
            4'hE: dac_q12 =  16'sd7265;
            4'hF: dac_q12 =  16'sd8192;
        endcase
    end

    reg signed [27:0] hp_acc, lp1_acc, lp2_acc;

    wire signed [27:0] dac_ext = $signed({dac_q12, 12'd0});
    wire signed [27:0] hp_out  = dac_ext - hp_acc;

    wire signed [27:0] out_shifted = lp2_acc >>> OUT_SHIFT;

    always @(posedge clk) begin
        if (reset) begin
            hp_acc  <= 28'sd0;
            lp1_acc <= 28'sd0;
            lp2_acc <= 28'sd0;
            audio   <= 16'sd0;
        end
        else if (tick) begin
            hp_acc  <= hp_acc  + ((dac_ext - hp_acc)  >>> HP_SHIFT);
            lp1_acc <= lp1_acc + ((hp_out  - lp1_acc) >>> LP_SHIFT);
            lp2_acc <= lp2_acc + ((lp1_acc - lp2_acc) >>> LP_SHIFT);
            audio   <= out_shifted[15:0];
        end
    end

endmodule

`default_nettype wire
