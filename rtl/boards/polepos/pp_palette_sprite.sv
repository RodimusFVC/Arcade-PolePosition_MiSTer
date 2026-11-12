//  Based on MAME polepos_v.cpp (Ernesto Corvi, Juergen Buchmueller, Alex Pasadyn, Aaron Giles, Nicola Salmoria, BSD-3-Clause)

`default_nettype none

module pp_palette_sprite
(
    input  wire        clk,

    input  wire        prom_wr,
    input  wire [11:0] prom_addr,
    input  wire [7:0]  prom_data,

    input  wire [5:0]  color,       // sprite colour group (sizmem[1] & 0x3f)
    input  wire [3:0]  pen,
    input  wire        bank128v,

    input  wire        diag_en,
    input  wire [7:0]  diag_indirect,

    output wire [7:0]  r,
    output wire [7:0]  g,
    output wire [7:0]  b,
    output wire        transparent
);
    reg [3:0] red_prom    [0:255];   // POOL-EXCEPTION: 4-bit palette PROM copy; each of the four palette pipelines reads its own in the same clock
    reg [3:0] green_prom  [0:255];   // POOL-EXCEPTION: 4-bit palette PROM copy; each of the four palette pipelines reads its own in the same clock
    reg [3:0] blue_prom   [0:255];   // POOL-EXCEPTION: 4-bit palette PROM copy; each of the four palette pipelines reads its own in the same clock
    reg [3:0] sprite_prom [0:1023];   // POOL-EXCEPTION: 4-bit palette PROM copy; each of the four palette pipelines reads its own in the same clock

    always @(posedge clk) begin
        if (prom_wr) begin
            if (prom_addr[11:10] == 2'b11)
                sprite_prom[prom_addr[9:0]] <= prom_data[3:0];
            else case (prom_addr[11:8])
                4'd0: red_prom  [prom_addr[7:0]] <= prom_data[3:0];
                4'd1: green_prom[prom_addr[7:0]] <= prom_data[3:0];
                4'd2: blue_prom [prom_addr[7:0]] <= prom_data[3:0];
                default: ;
            endcase
        end
    end

    wire [9:0] spr_idx = {color, pen};
    reg  [3:0] promval;
    reg        s1_bank;
    always @(posedge clk) begin
        promval <= sprite_prom[spr_idx];
        s1_bank <= bank128v;
    end
    wire s1_transp = (promval == 4'hF);

    wire [7:0] indirect_norm = s1_bank ? (8'h50 + {4'h0, promval}) : (8'h10 + {4'h0, promval});
    wire [7:0] indirect      = diag_en ? diag_indirect : indirect_norm;
    reg  [3:0] r_nib, g_nib, b_nib;
    reg        s2_transp;
    always @(posedge clk) begin
        r_nib     <= red_prom  [indirect];
        g_nib     <= green_prom[indirect];
        b_nib     <= blue_prom [indirect];
        s2_transp <= s1_transp;
    end

    function [7:0] dac(input [3:0] n);
        dac = (n[0] ? 8'h0e : 8'h00) + (n[1] ? 8'h1f : 8'h00)
            + (n[2] ? 8'h43 : 8'h00) + (n[3] ? 8'h8f : 8'h00);
    endfunction

    assign r           = dac(r_nib);
    assign g           = dac(g_nib);
    assign b           = dac(b_nib);
    assign transparent = s2_transp;

endmodule

`default_nettype wire
