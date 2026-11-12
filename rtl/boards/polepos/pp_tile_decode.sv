//  Based on MAME polepos_v.cpp (Ernesto Corvi, Juergen Buchmueller, Alex Pasadyn, Aaron Giles, Nicola Salmoria, BSD-3-Clause)

`default_nettype none

module pp_tile_decode
(
    input  wire [15:0] tile_word,
    input  wire        chacl,          // alpha: LS259 q7. 0 => code masked to 8b
    output wire  [8:0] tile_code,      // 9-bit; bit8 = word[14]
    output wire  [5:0] tile_color,

    input  wire  [2:0] row,
    output wire [12:0] gfx_addr_l,
    output wire [12:0] gfx_addr_r,

    input  wire  [7:0] gfx_byte_l,
    input  wire  [7:0] gfx_byte_r,
    input  wire  [2:0] col,
    output wire  [1:0] pixel
);

    assign tile_code  = { tile_word[14], tile_word[7:0] };
    assign tile_color = tile_word[13:8];

    wire [8:0] code9 = chacl ? tile_code : { 1'b0, tile_code[7:0] };

    assign gfx_addr_l = { code9, 1'b0, row };
    assign gfx_addr_r = { code9, 1'b1, row };

    wire [7:0] sel_byte = col[2] ? gfx_byte_r : gfx_byte_l;
    wire [1:0] x_in_half = col[1:0];
    wire [2:0] bit_p0 = {1'b1, ~x_in_half};
    wire [2:0] bit_p1 = {1'b0, ~x_in_half};
    assign pixel = { sel_byte[bit_p0], sel_byte[bit_p1] };

endmodule

`default_nettype wire
