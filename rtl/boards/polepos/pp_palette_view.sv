//  Based on MAME polepos_v.cpp (Ernesto Corvi, Juergen Buchmueller, Alex Pasadyn, Aaron Giles, Nicola Salmoria, BSD-3-Clause)

`default_nettype none

module pp_palette_view
(
    input  wire        clk,

    input  wire        prom_wr,
    input  wire [11:0] prom_addr,   // [11:8]=table (0=R,1=G,2=B,4=view), [7:0]=idx
    input  wire [7:0]  prom_data,

    input  wire [5:0]  color,
    input  wire [1:0]  pixel,

    output wire [7:0]  r,
    output wire [7:0]  g,
    output wire [7:0]  b
);
    reg [3:0] red_prom   [0:255];   // POOL-EXCEPTION: 4-bit palette PROM copy; each of the four palette pipelines reads its own in the same clock
    reg [3:0] green_prom [0:255];   // POOL-EXCEPTION: 4-bit palette PROM copy; each of the four palette pipelines reads its own in the same clock
    reg [3:0] blue_prom  [0:255];   // POOL-EXCEPTION: 4-bit palette PROM copy; each of the four palette pipelines reads its own in the same clock
    reg [3:0] view_prom  [0:255];   // POOL-EXCEPTION: 4-bit palette PROM copy; each of the four palette pipelines reads its own in the same clock

    always @(posedge clk) begin
        if (prom_wr) begin
            case (prom_addr[11:8])
                4'd0: red_prom  [prom_addr[7:0]] <= prom_data[3:0];
                4'd1: green_prom[prom_addr[7:0]] <= prom_data[3:0];
                4'd2: blue_prom [prom_addr[7:0]] <= prom_data[3:0];
                4'd4: view_prom [prom_addr[7:0]] <= prom_data[3:0];
                default: ;
            endcase
        end
    end

    wire [7:0] view_idx = {color, pixel};
    reg  [3:0] promval;
    always @(posedge clk) promval <= view_prom[view_idx];

    wire [7:0] indirect = {4'h0, promval};
    reg  [3:0] r_nib, g_nib, b_nib;
    always @(posedge clk) begin
        r_nib <= red_prom  [indirect];
        g_nib <= green_prom[indirect];
        b_nib <= blue_prom [indirect];
    end

    function [7:0] dac(input [3:0] n);
        dac = (n[0] ? 8'h0e : 8'h00) + (n[1] ? 8'h1f : 8'h00)
            + (n[2] ? 8'h43 : 8'h00) + (n[3] ? 8'h8f : 8'h00);
    endfunction

    assign r = dac(r_nib);
    assign g = dac(g_nib);
    assign b = dac(b_nib);

endmodule

`default_nettype wire
