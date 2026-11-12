//  Based on MAME polepos_v.cpp (Ernesto Corvi, Juergen Buchmueller, Alex Pasadyn, Aaron Giles, Nicola Salmoria, BSD-3-Clause)

`default_nettype none

module pp_tile_layer #(
    parameter        SCAN_COLS   = 0,   // 0=TILEMAP_SCAN_ROWS, 1=TILEMAP_SCAN_COLS
    parameter integer COLS       = 32,
    parameter integer ROWS       = 32,
    parameter        USE_HSCROLL = 0,   // 1 = add hscroll to X (view)
    parameter        BANK_128V   = 0    // 1 = emit vpos[7] as 128V bank bit
)(
    input  wire        clk,
    input  wire        ce,

    input  wire [8:0]  hpos,
    input  wire [8:0]  vpos,
    input  wire [15:0] hscroll,
    input  wire        chacl,

    output wire [10:0] scan_addr,    // word index (10 bits used; [10]=0)
    input  wire [15:0] scan_dout,

    output reg  [12:0] gfx_addr,
    input  wire [7:0]  gfx_data,

    output wire [5:0]  color,
    output wire [1:0]  pixel,        // 2bpp value (0 = transparent)
    output wire        bank128v
);
    localparam integer CW = $clog2(COLS);
    localparam integer RW = $clog2(ROWS);

    wire [8:0] sx      = hpos - 9'd256;
    wire [8:0] x_disp  = USE_HSCROLL ? (sx + hscroll[8:0]) : sx;
    wire [8:0] x_fetch = x_disp + 9'd8;
    wire [2:0] p       = x_disp[2:0];

    wire [CW-1:0] fcol = x_fetch[3 +: CW];
    wire [RW-1:0] vrow = vpos [3 +: RW];
    wire [2:0]    frow = vpos[2:0];
    wire [10:0] fetch_index = SCAN_COLS ? { {(11-CW-RW){1'b0}}, fcol, vrow }
                                        : { {(11-CW-RW){1'b0}}, vrow, fcol };
    assign scan_addr = fetch_index;

    wire [12:0] fetch_gfx_l, fetch_gfx_r;
    wire  [5:0] fetch_color;
    pp_tile_decode u_fetch (
        .tile_word (scan_dout),
        .chacl     (chacl),
        .tile_code (),
        .tile_color(fetch_color),
        .row       (frow),
        .gfx_addr_l(fetch_gfx_l),
        .gfx_addr_r(fetch_gfx_r),
        .gfx_byte_l(8'd0),
        .gfx_byte_r(8'd0),
        .col       (3'd0),
        .pixel     ()
    );

    reg [7:0] nxt_byte_l, nxt_byte_r;
    reg [7:0] disp_byte_l, disp_byte_r;
    reg [5:0] disp_color;

    always @(posedge clk) begin
        if (ce) begin
            case (p)
                3'd2: gfx_addr <= fetch_gfx_l;
                3'd3: begin
                          nxt_byte_l <= gfx_data;
                          gfx_addr   <= fetch_gfx_r;
                      end
                3'd4: nxt_byte_r <= gfx_data;
                3'd7: begin
                          disp_byte_l <= nxt_byte_l;
                          disp_byte_r <= nxt_byte_r;
                          disp_color  <= chacl ? fetch_color : 6'd0;
                      end
                default: ;
            endcase
        end
    end

    pp_tile_decode u_disp (
        .tile_word (16'd0),
        .chacl     (1'b1),
        .tile_code (),
        .tile_color(),
        .row       (3'd0),
        .gfx_addr_l(),
        .gfx_addr_r(),
        .gfx_byte_l(disp_byte_l),
        .gfx_byte_r(disp_byte_r),
        .col       (p),
        .pixel     (pixel)
    );

    assign color    = disp_color;
    assign bank128v = BANK_128V ? vpos[7] : 1'b0;

endmodule

`default_nettype wire
