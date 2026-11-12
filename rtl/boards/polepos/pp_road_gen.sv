//  Based on MAME polepos_v.cpp (Ernesto Corvi, Juergen Buchmueller, Alex Pasadyn, Aaron Giles, Nicola Salmoria, BSD-3-Clause)

`default_nettype none

module pp_road_gen
(
    input  wire        clk,
    input  wire        ce,
    input  wire [8:0]  hpos,
    input  wire [8:0]  vpos,

    input  wire [15:0] road_vscroll,

    output wire [9:0]  scan_road_addr,
    input  wire [15:0] scan_road_dout,

    output reg  [14:0] road_rom_addr,
    input  wire [7:0]  road_rom_data,

    input  wire        prom_wr,
    input  wire [11:0] prom_addr,
    input  wire [7:0]  prom_data,

    output wire [9:0]  road_index,
    output wire        road_active
);
    reg [11:0] vposmod [0:255];   // POOL-EXCEPTION: 12-bit per-line road table, written and read by the road pipeline
    always @(posedge clk) begin
        if (prom_wr) case (prom_addr[11:8])
            4'd5: vposmod[prom_addr[7:0]][3:0]  <= prom_data[3:0];
            4'd6: vposmod[prom_addr[7:0]][7:4]  <= prom_data[3:0];
            4'd7: vposmod[prom_addr[7:0]][11:8] <= prom_data[3:0];
            default: ;
        endcase
    end

    reg [9:0] linebuf [0:1023];   // POOL-EXCEPTION: 10-bit road line buffer (two banks), read during the write line
    reg [2:0] xscroll_bank [0:1];   // POOL-EXCEPTION: 3-bit x 2 register pair

    localparam [3:0] G_IDLE=0, G_SET0=1, G_SET1=2, G_CHUNK=3, G_RDC=4,
                     G_RDB1=5, G_RDB2=6, G_PIX=7, G_FILL=8, G_DONE=9,
                     G_SET0W=10, G_SET1W=11,
                     G_RDB3=12;
    reg [3:0]  gstate;
    reg [8:0]  ygen;
    reg        gbank;
    reg [8:0]  yoffs;
    reg [3:0]  roadpal;
    reg [9:0]  xoffs;
    reg [2:0]  xscroll;
    reg [5:0]  chunk;
    reg [8:0]  wptr;
    reg [7:0]  ctrl_b, b1_b, b2_b;
    reg [5:0]  roadval;
    reg        carin;
    reg [3:0]  pix;
    reg [8:0]  ygen_prev;

    assign scan_road_addr = (gstate == G_SET0 || gstate == G_SET0W)
                                ? (10'h380 + {3'd0, ygen[6:0]})
                                : {1'b0, yoffs};

    wire [12:0] romoffs = {ygen[6:0], 6'd0} + {7'd0, xoffs[8:3]};
    wire [11:0] b2off   = {romoffs[11:0] & 12'hFFF} | {romoffs[12], 11'd0};

    wire [8:0] b1_9 = {1'b0, b1_b};
    wire [8:0] b2_9 = {1'b0, b2_b};
    wire [1:0] pbits = {b2_9[pix], b1_9[pix]};
    wire [2:0] pbits_c = (!carin && (pbits != 0)) ? (pbits + 2'd1) : {1'b0, pbits};

    integer i;
    always @(posedge clk) begin
        case (gstate)
        G_IDLE: begin
            gstate <= G_SET0;
        end
        G_SET0: begin
            yoffs <= ((vposmod[ygen[7:0]] + road_vscroll) >> 3) & 12'h1ff;
            gstate <= G_SET0W;
        end
        G_SET0W: begin
            xoffs <= scan_road_dout[9:0];
            gstate <= G_SET1;
        end
        G_SET1: begin
            gstate <= G_SET1W;
        end
        G_SET1W: begin
            roadpal <= scan_road_dout[3:0];
            xscroll <= xoffs[2:0];
            xoffs   <= {xoffs[9:3], 3'd0};
            chunk   <= 6'd0;
            wptr    <= 9'd0;
            gstate  <= G_CHUNK;
        end
        G_CHUNK: begin
            if (chunk == 6'd33) begin
                xscroll_bank[gbank] <= xscroll;
                gstate <= G_DONE;
            end else if (xoffs[9]) begin
                pix    <= 4'd8;
                gstate <= G_FILL;
            end else begin
                road_rom_addr <= {2'd0, romoffs};
                gstate <= G_RDC;
            end
        end
        G_RDC: begin
            road_rom_addr <= 15'h2000 + {2'd0, romoffs};
            gstate <= G_RDB1;
        end
        G_RDB1: begin
            ctrl_b        <= road_rom_data;
            road_rom_addr <= 15'h4000 + {3'd0, b2off};
            gstate <= G_RDB2;
        end
        G_RDB2: begin
            b1_b   <= road_rom_data;
            gstate <= G_RDB3;
        end
        G_RDB3: begin
            b2_b    <= road_rom_data;
            roadval <= ctrl_b[5:0];
            carin   <= ctrl_b[7];
            pix     <= 4'd8;
            gstate  <= G_PIX;
        end
        G_PIX: begin
            linebuf[{gbank, wptr[8:0]}] <= {roadpal, roadval};
            roadval <= roadval + {3'd0, pbits_c};
            wptr    <= wptr + 9'd1;
            pix     <= pix - 4'd1;
            if (pix == 4'd1) begin
                xoffs  <= xoffs + 10'd8;
                chunk  <= chunk + 6'd1;
                gstate <= G_CHUNK;
            end
        end
        G_FILL: begin
            linebuf[{gbank, wptr[8:0]}] <= {roadpal, 6'd0};
            wptr <= wptr + 9'd1;
            pix  <= pix - 4'd1;
            if (pix == 4'd1) begin
                xoffs  <= xoffs + 10'd8;
                chunk  <= chunk + 6'd1;
                gstate <= G_CHUNK;
            end
        end
        G_DONE: gstate <= G_IDLE;
        default: gstate <= G_IDLE;
        endcase

        if (vpos != ygen_prev) begin
            ygen  <= vpos + 9'd1;
            gbank <= ~vpos[0];
            if (gstate == G_IDLE || gstate == G_DONE) gstate <= G_IDLE;
        end
        ygen_prev <= vpos;
    end

    wire        disp_bank = vpos[0];
    wire [8:0]  rd = {1'b0, hpos[7:0]} + {6'd0, xscroll_bank[disp_bank]};
    reg  [9:0]  road_index_r;
    always @(posedge clk) road_index_r <= linebuf[{disp_bank, rd}];

    assign road_index  = road_index_r;
    assign road_active = (vpos >= 9'd128);

endmodule

`default_nettype wire
