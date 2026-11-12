//  Based on MAME polepos_v.cpp (Ernesto Corvi, Juergen Buchmueller, Alex Pasadyn, Aaron Giles, Nicola Salmoria, BSD-3-Clause)

`default_nettype none

module pp_sprite_gen
(
    input  wire        clk,
    input  wire        ce,
    input  wire [8:0]  hpos,
    input  wire [8:0]  vpos,
    input  wire [8:0]  ynext,

    output wire [10:0] scan_sprite_addr,
    input  wire [15:0] scan_sprite_dout,

    output reg  [11:0] scalelut_addr,
    input  wire [7:0]  scalelut_data,

    output reg  [16:0] sprgfx_addr,
    input  wire [7:0]  sprgfx_data,

    input  wire        prom_wr,
    input  wire [11:0] prom_addr,
    input  wire [7:0]  prom_data,

    output wire [3:0]  sprite_pen,
    output wire [5:0]  sprite_color,
    output wire        sprite_bank,
    output wire        sprite_active
);
    reg [3:0] sprite_prom [0:1023];   // POOL-EXCEPTION: 4-bit sprite colour PROM copy read in the sprite pipeline
    always @(posedge clk)
        if (prom_wr && prom_addr[11:10]==2'b11)
            sprite_prom[prom_addr[9:0]] <= prom_data[3:0];

    reg [11:0] linebuf [0:511];   // POOL-EXCEPTION: 12-bit sprite line buffer

    localparam [3:0] S_IDLE=0, S_CLR=1, S_A0=2, S_A1=3, S_A2=4, S_A3=5,
                     S_CALC=6, S_CALC2=13, S_SCALE=7, S_DSET=8, S_FLO=9,
                     S_FHI=10, S_PIX=11, S_DONE=12,
                     S_A4=14,
                     S_FLOW=15;
    reg [3:0]  st;
    reg [8:0]  ygen, ygen_prev;
    reg        gbank;
    reg [8:0]  clr_i;
    reg [1:0]  attr_sel;

    reg [5:0]  spr;
    reg [15:0] p0w, p1w, s0w, s1w;
    reg [9:0]  sx;
    reg [9:0]  sy;
    reg [5:0]  sizex, sizey;
    reg [6:0]  code;
    reg        flipx, big, bank;
    reg [5:0]  color;
    reg [4:0]  dy;
    reg [9:0]  xx;
    reg [6:0]  siz, offs, xcnt;
    reg [7:0]  byte_lo;

    assign scan_sprite_addr =
        (attr_sel==2'd0) ? (11'h380 + {3'd0, spr, 1'b0})           :
        (attr_sel==2'd1) ? (11'h380 + {3'd0, spr, 1'b0} + 11'd1)   :
        (attr_sel==2'd2) ? (11'h780 + {3'd0, spr, 1'b0})           :
                           (11'h780 + {3'd0, spr, 1'b0} + 11'd1);

    wire [9:0] yin = ({1'b0, ygen} - sy) & 10'h1ff;
    wire       on_v = (ygen >= 9'h10) && (ygen < 9'hf0);
    wire       covered = on_v && (yin <= {4'd0, sizey});

    wire [4:0] offsxor = flipx ? (big ? 5'h1f : 5'h0f) : 5'h00;
    wire [4:0] col     = offs[5:1] ^ offsxor;
    wire [1:0] cq      = col[1:0];
    wire [16:0] blo_small = {code, 6'd0} + {8'd0, dy, 2'd0} + {14'd0, col[4:2]};
    wire [16:0] blo_big   = 17'h04000 + {code, 8'd0} + {6'd0, dy, 3'd0} + {14'd0, col[4:2]};
    wire [16:0] byte_lo_a = big ? blo_big : blo_small;
    wire [16:0] hi_off    = big ? 17'h08000 : 17'h02000;
    wire p0b = byte_lo    [3'd7 - {1'b0, cq}];
    wire p1b = byte_lo    [3'd3 - {1'b0, cq}];
    wire p2b = sprgfx_data[3'd7 - {1'b0, cq}];
    wire p3b = sprgfx_data[3'd3 - {1'b0, cq}];
    wire [3:0] pen = {p0b, p1b, p2b, p3b};
    wire pen_transp = (sprite_prom[{color, pen}] == 4'hF);

    wire [7:0] siz_sum = {1'b0, siz} + 8'd1 + {2'd0, sizex};
    wire       siz_carry = siz_sum[6];

    always @(posedge clk) begin
        case (st)
        S_IDLE: ;
        S_CLR: begin
            linebuf[{gbank, clr_i[7:0]}] <= 12'd0;
            clr_i <= clr_i + 9'd1;
            if (clr_i[7:0] == 8'hff) begin spr <= 6'd0; attr_sel <= 2'd0; st <= S_A0; end
        end
        S_A0: begin                          attr_sel <= 2'd1; st <= S_A1; end
        S_A1: begin p0w <= scan_sprite_dout; attr_sel <= 2'd2; st <= S_A2; end
        S_A2: begin p1w <= scan_sprite_dout; attr_sel <= 2'd3; st <= S_A3; end
        S_A3: begin s0w <= scan_sprite_dout;                   st <= S_A4; end
        S_A4: begin s1w <= scan_sprite_dout;                   st <= S_CALC; end
        S_CALC: begin
            sx    <= p1w[9:0] - 10'h40 + 10'd4;
            sy    <= 10'd513 - {1'b0, p0w[8:0]};
            sizex <= s1w[13:8];
            sizey <= s0w[13:8];
            code  <= s0w[6:0];
            flipx <= s0w[7];
            big   <= s0w[15];
            color <= s1w[5:0];
            st    <= S_CALC2;
        end
        S_CALC2: begin
            bank <= (sy >= 10'd128);
            scalelut_addr <= {yin[5:0], sizey};
            st <= covered ? S_SCALE : S_DONE;
        end
        S_SCALE: st <= S_DSET;
        S_DSET: begin
            dy   <= big ? scalelut_data[4:0] : {1'b0, scalelut_data[4:1]};
            xx   <= sx;
            siz  <= 7'd0;
            offs <= 7'd0;
            xcnt <= big ? 7'h40 : 7'h20;
            st   <= S_FLO;
        end
        S_FLO:  begin sprgfx_addr <= byte_lo_a;             st <= S_FLOW; end
        S_FLOW: begin sprgfx_addr <= byte_lo_a + hi_off;    st <= S_FHI;  end
        S_FHI:  begin byte_lo    <= sprgfx_data;            st <= S_PIX;  end
        S_PIX: begin
            if (xx < 10'h100 && !pen_transp)
                linebuf[{gbank, xx[7:0]}] <= {1'b1, bank, color, pen};
            offs <= offs + 7'd1;
            siz  <= siz_sum[5:0];
            if (siz_carry) xx <= (xx + 10'd1) & 10'h3ff;
            xcnt <= xcnt - 7'd1;
            st   <= (xcnt == 7'd1) ? S_DONE : S_FLO;
        end
        S_DONE: begin
            if (spr == 6'd63) st <= S_IDLE;
            else begin spr <= spr + 6'd1; attr_sel <= 2'd0; st <= S_A0; end
        end
        default: st <= S_IDLE;
        endcase

        if (vpos != ygen_prev) begin
            ygen  <= ynext;
            gbank <= ~vpos[0];
            clr_i <= 9'd0;
            st    <= S_CLR;
        end
        ygen_prev <= vpos;
    end

    wire        disp_bank = vpos[0];
    wire [11:0] oent = linebuf[{disp_bank, hpos[7:0]}];
    assign sprite_active = oent[11];
    assign sprite_bank   = oent[10];
    assign sprite_color  = oent[9:4];
    assign sprite_pen    = oent[3:0];

endmodule

`default_nettype wire
