//============================================================================
//  pp_palette_sprite.sv — Pole Position SPRITE layer palette lookup
//
//  Ports MAME's polepos_palette() sprite arithmetic verbatim (polepos_v.cpp
//  :106-114). Like pp_palette_alpha it HAS transparency + 128V banking:
//
//    stage 1: promval = sprite_prom[ {color[5:0], pen[3:0]} ]  (proms 0xc00,1024)
//             transparent = (promval == 4'hF)          (MAME transpen 0x1f)
//    stage 2: indirect = bank128v ? (0x50+promval) : (0x10+promval)
//    stage 3: r/g/b nib = {red,green,blue}_prom[indirect]     (proms 0x000/1/2)
//    stage 4: R/G/B = weighted-resistor DAC (0x0e/1f/43/8f)
//
//  bank128v = the sprite's 0x40 colour bit (draw_sprites: `if (sy>=128) color|=0x40`).
//  Index is {color[5:0], pen[3:0]} = colour group * 16 + the 4bpp pen (granularity 16).
//
//  PROM load: sprite_prom is 0xc00-0xFFF (prom_addr[11:10]==2'b11, idx=[9:0]);
//  R/G/B are 0x000/0x100/0x200 (prom_addr[11:8]=0/1/2, idx=[7:0]). 12-bit addr.
//  Latency = 2 clk (matches the other palettes for compositor alignment).
//============================================================================

`default_nettype none

module pp_palette_sprite
(
    input  wire        clk,

    // ---- PROM load (ioctl "proms" region) ----------------------------------
    input  wire        prom_wr,
    input  wire [11:0] prom_addr,
    input  wire [7:0]  prom_data,

    // ---- lookup request (from the sprite engine) ---------------------------
    input  wire [5:0]  color,       // sprite colour group (sizmem[1] & 0x3f)
    input  wire [3:0]  pen,         // 4bpp pixel value
    input  wire        bank128v,    // sprite 0x40 bit (sy>=128)

    // ---- result (2-clk latency) --------------------------------------------
    output wire [7:0]  r,
    output wire [7:0]  g,
    output wire [7:0]  b,
    output wire        transparent  // sprite pixel is transparent (show below)
);
    reg [3:0] red_prom    [0:255];    // 0x000 : red   nibble (shared DAC table)
    reg [3:0] green_prom  [0:255];    // 0x100 : green nibble
    reg [3:0] blue_prom   [0:255];    // 0x200 : blue  nibble
    reg [3:0] sprite_prom [0:1023];   // 0xc00 : sprite indirect selector (1024)

    always @(posedge clk) begin
        if (prom_wr) begin
            if (prom_addr[11:10] == 2'b11)          // 0xc00-0xFFF : sprite (1024)
                sprite_prom[prom_addr[9:0]] <= prom_data[3:0];
            else case (prom_addr[11:8])             // 0x000/0x100/0x200 : R/G/B
                4'd0: red_prom  [prom_addr[7:0]] <= prom_data[3:0];
                4'd1: green_prom[prom_addr[7:0]] <= prom_data[3:0];
                4'd2: blue_prom [prom_addr[7:0]] <= prom_data[3:0];
                default: ;
            endcase
        end
    end

    // ---- stage 1: sprite PROM lookup ({color,pen}) -------------------------
    wire [9:0] spr_idx = {color, pen};
    reg  [3:0] promval;
    reg        s1_bank;
    always @(posedge clk) begin
        promval <= sprite_prom[spr_idx];
        s1_bank <= bank128v;
    end
    wire s1_transp = (promval == 4'hF);

    // ---- stage 2: indirect index -> R/G/B nibble lookup --------------------
    wire [7:0] indirect = s1_bank ? (8'h50 + {4'h0, promval}) : (8'h10 + {4'h0, promval});
    reg  [3:0] r_nib, g_nib, b_nib;
    reg        s2_transp;
    always @(posedge clk) begin
        r_nib     <= red_prom  [indirect];
        g_nib     <= green_prom[indirect];
        b_nib     <= blue_prom [indirect];
        s2_transp <= s1_transp;
    end

    // ---- stage 3: weighted-resistor DAC (combinational) --------------------
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
