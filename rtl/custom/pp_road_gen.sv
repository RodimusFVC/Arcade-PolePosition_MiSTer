//============================================================================
//  pp_road_gen.sv — Pole Position ROAD layer generator
//
//  Faithful RTL port of MAME draw_road() (polepos_v.cpp:304-373). PP's road is
//  a custom-chip per-scanline generator for the lower half of the screen
//  (y = 128..255): for each scanline it fetches a 3-plane road ROM and runs a
//  carry-propagate accumulator to produce a per-pixel road pen index.
//
//  STRUCTURE — line-buffer, exactly like MAME (which fills scanline[] then
//  draw_scanline16). A clk-paced generation FSM computes the NEXT scanline's 264
//  road pixels into a double-buffered line RAM while the CURRENT scanline is
//  displayed; the ce-paced output just reads the line RAM. This decouples the
//  fetch/accumulate timing from the pixel rate and makes the whole thing a
//  straight transcription of the C++ (verify: co-sim diff vs a draw_road port).
//
//  ROM/RAM interfaces (MAME polepos.cpp):
//    road ROM region 0x5000 : control@0x0000(0x2000) bits1@0x2000(0x2000)
//                             bits2@0x4000(0x1000). 1-clk sync read.
//    scan_road (road16_memory) : 0x400 words, COMBINATIONAL read. yoffs->roadpal
//                             and 0x380+y -> xoffs come from here.
//    vpos-modifier PROM : 256 x 12-bit, assembled from proms 0x500/0x600/0x700
//                             (polepos_v.cpp:130-134). Loaded via prom_* here.
//    road_vscroll : z8002 @0xC100.
//
//  Output: road_index[9:0] = (roadpal<<6) | roadval  -> pp_palette_road.
//          road_active = (vpos >= 128).
//============================================================================

`default_nettype none

module pp_road_gen
(
    input  wire        clk,
    input  wire        ce,              // pixel clock-enable (output side)
    input  wire [8:0]  hpos,            // display X of the pixel output this ce
    input  wire [8:0]  vpos,            // display Y

    input  wire [15:0] road_vscroll,    // z8002 @0xC100

    // ---- scan_road buffer (road16_memory), COMBINATIONAL read --------------
    output wire [9:0]  scan_road_addr,
    input  wire [15:0] scan_road_dout,

    // ---- road ROM (flat: control@0, bits1@0x2000, bits2@0x4000), 1-clk sync -
    output reg  [14:0] road_rom_addr,
    input  wire [7:0]  road_rom_data,

    // ---- vpos-modifier PROM load (proms 0x500=lo/0x600=mid/0x700=hi nibbles) -
    input  wire        prom_wr,
    input  wire [11:0] prom_addr,
    input  wire [7:0]  prom_data,

    // ---- output ------------------------------------------------------------
    output wire [9:0]  road_index,
    output wire        road_active
);
    // ======================= vpos-modifier PROM ===========================
    //  vposmod[i][11:0] = prom[0x700+i]<<8 | prom[0x600+i]<<4 | prom[0x500+i]
    reg [11:0] vposmod [0:255];
    always @(posedge clk) begin
        if (prom_wr) case (prom_addr[11:8])
            4'd5: vposmod[prom_addr[7:0]][3:0]  <= prom_data[3:0];  // 0x500 low
            4'd6: vposmod[prom_addr[7:0]][7:4]  <= prom_data[3:0];  // 0x600 mid
            4'd7: vposmod[prom_addr[7:0]][11:8] <= prom_data[3:0];  // 0x700 high
            default: ;
        endcase
    end

    // ======================= double line buffer ============================
    //  264 pixels/scanline (33 chunks x 8). Two banks selected by scanline parity:
    //  display bank = vpos[0], generate bank = ~vpos[0].
    reg [9:0] linebuf [0:1023];         // {gbank, wptr[8:0]} = bank*512 + pixel (pixel 0..263)
    reg [2:0] xscroll_bank [0:1];       // per-buffer xscroll (xoffs & 7)

    // ======================= generation FSM (clk-paced) ====================
    localparam [3:0] G_IDLE=0, G_SET0=1, G_SET1=2, G_CHUNK=3, G_RDC=4,
                     G_RDB1=5, G_RDB2=6, G_PIX=7, G_FILL=8, G_DONE=9,
    // SCAN-LATENCY-FIX-2026-08-06: G_SET0W/G_SET1W are wait states that absorb the
    // 1-clock latency of the scan_road read (see the assign below).
                     G_SET0W=10, G_SET1W=11;
    reg [3:0]  gstate;
    reg [8:0]  ygen;                    // scanline being generated
    reg        gbank;                   // bank being written (= ~display parity)
    reg [8:0]  yoffs;
    reg [3:0]  roadpal;
    reg [9:0]  xoffs;                   // running x offset (10-bit)
    reg [2:0]  xscroll;
    reg [5:0]  chunk;                   // 0..32
    reg [8:0]  wptr;                    // 0..263 write pointer into the bank
    reg [7:0]  ctrl_b, b1_b, b2_b;      // fetched control / bits1 / bits2
    reg [5:0]  roadval;
    reg        carin;
    reg [3:0]  pix;                     // 8..1 pixel counter within a chunk
    reg [8:0]  ygen_prev;               // vpos edge detect (scanline kick)

    // scan_road address is combinational off the FSM, but the DATA COMES BACK ONE
    // CLOCK LATER. SCAN-LATENCY-FIX-2026-08-06: the old comment here claimed "dout is
    // same-cycle" and the FSM consumed scan_road_dout in the very state that drove the
    // address. That was false: PolePosition_subcpu.sv:426-429 registers this read
    // (`road_lo_qb <= road_lo[scan_road_addr]`) so it can infer BRAM. Consequence on
    // real HW: xoffs was loaded from whatever address was presented during G_IDLE, not
    // from road16[0x380+y], so nearly every scanline's xoffs was garbage; once
    // xoffs >= 0x200 the G_CHUNK blank-fill path writes pen 0 (transparent) for the
    // rest of the line, which is why the road appeared as a ~32px block at top-left
    // with the rest of the road area transparent.
    // This went undetected because verilator/road/sim_main.cpp modelled the RAM
    // COMBINATIONALLY (`scan_road_dout = road16_memory[scan_road_addr]`), satisfying
    // the false assumption — the rig has been corrected to match the registered read.
    // The address is now held across {G_SET0,G_SET0W} and {G_SET1,G_SET1W}; each
    // value is consumed in the W state, one clock after its address went out.
    assign scan_road_addr = (gstate == G_SET0 || gstate == G_SET0W)
                                ? (10'h380 + {3'd0, ygen[6:0]})
                                : {1'b0, yoffs};   // G_SET1/G_SET1W use yoffs (9-bit)

    // road ROM address for the 3 planes of the CURRENT chunk's romoffs
    wire [12:0] romoffs = {ygen[6:0], 6'd0} + {7'd0, xoffs[8:3]};   // (y&7f)<<6 + (xoffs&1f8)>>3
    wire [11:0] b2off   = {romoffs[11:0] & 12'hFFF} | {romoffs[12], 11'd0}; // (romoffs&fff)|((romoffs&1000)>>1)

    // one 8-pixel road step (combinational), MAME's inner loop body for pixel `pix`
    //  MAME reads BIT(bitsN, i) for i=8..1; bit 8 of a byte is always 0. Pad to
    //  9 bits so pix==8 reads a real 0, not an out-of-range index.
    wire [8:0] b1_9 = {1'b0, b1_b};
    wire [8:0] b2_9 = {1'b0, b2_b};
    wire [1:0] pbits = {b2_9[pix], b1_9[pix]};                 // BIT(bits1,i)+ (BIT(bits2,i)<<1)
    wire [2:0] pbits_c = (!carin && (pbits != 0)) ? (pbits + 2'd1) : {1'b0, pbits};

    integer i;
    always @(posedge clk) begin
        case (gstate)
        G_IDLE: begin
            // kick generation of scanline ygen into bank gbank
            gstate <= G_SET0;
        end
        // SCAN-LATENCY-FIX-2026-08-06: address goes out in G_SET0, data is consumed one
        // clock later in G_SET0W. Same split for G_SET1/G_SET1W.
        G_SET0: begin
            // yoffs = (vposmod[y] + vscroll) >> 3 & 0x1ff  (ready for G_SET1's scan read)
            yoffs <= ((vposmod[ygen[7:0]] + road_vscroll) >> 3) & 12'h1ff;
            gstate <= G_SET0W;
        end
        G_SET0W: begin
            xoffs <= scan_road_dout[9:0];          // xoffs = road16_memory[0x380+y] & 0x3ff
            gstate <= G_SET1;
        end
        G_SET1: begin                              // drives scan_road_addr = yoffs
            gstate <= G_SET1W;
        end
        G_SET1W: begin
            roadpal <= scan_road_dout[3:0];        // roadpal = road16_memory[yoffs] & 15
            xscroll <= xoffs[2:0];
            xoffs   <= {xoffs[9:3], 3'd0};         // xoffs &= ~7
            chunk   <= 6'd0;
            wptr    <= 9'd0;
            gstate  <= G_CHUNK;
        end
        G_CHUNK: begin
            if (chunk == 6'd33) begin
                xscroll_bank[gbank] <= xscroll;
                gstate <= G_DONE;
            end else if (xoffs[9]) begin           // xoffs & 0x200 -> blank fill
                pix    <= 4'd8;
                gstate <= G_FILL;
            end else begin
                road_rom_addr <= {2'd0, romoffs};  // control @ romoffs
                gstate <= G_RDC;
            end
        end
        G_RDC: begin
            ctrl_b        <= road_rom_data;        // captured (1-clk after addr)
            road_rom_addr <= 15'h2000 + {2'd0, romoffs};   // bits1 @ 0x2000+romoffs
            gstate <= G_RDB1;
        end
        G_RDB1: begin
            b1_b          <= road_rom_data;
            road_rom_addr <= 15'h4000 + {3'd0, b2off};     // bits2 @ 0x4000+b2off
            gstate <= G_RDB2;
        end
        G_RDB2: begin
            b2_b    <= road_rom_data;
            roadval <= ctrl_b[5:0];                // roadval = control & 0x3f
            carin   <= ctrl_b[7];                  // carin = control >> 7
            pix     <= 4'd8;
            gstate  <= G_PIX;
        end
        G_PIX: begin
            linebuf[{gbank, wptr[8:0]}] <= {roadpal, roadval};  // (roadpal<<6)|roadval
            roadval <= roadval + {3'd0, pbits_c};
            wptr    <= wptr + 9'd1;
            pix     <= pix - 4'd1;
            if (pix == 4'd1) begin
                xoffs  <= xoffs + 10'd8;
                chunk  <= chunk + 6'd1;
                gstate <= G_CHUNK;
            end
        end
        G_FILL: begin                              // xoffs&0x200: 8 pixels of pen 0
            linebuf[{gbank, wptr[8:0]}] <= {roadpal, 6'd0};
            wptr <= wptr + 9'd1;
            pix  <= pix - 4'd1;
            if (pix == 4'd1) begin
                xoffs  <= xoffs + 10'd8;
                chunk  <= chunk + 6'd1;
                gstate <= G_CHUNK;
            end
        end
        G_DONE: gstate <= G_IDLE;                   // wait for the next scanline kick
        default: gstate <= G_IDLE;
        endcase

        // ---- scanline kick: when vpos advances, generate the NEXT line ----
        if (vpos != ygen_prev) begin
            ygen  <= vpos + 9'd1;                   // prepare the upcoming scanline
            gbank <= ~vpos[0];                       // into the non-display bank
            if (gstate == G_IDLE || gstate == G_DONE) gstate <= G_IDLE; // (re)kick via IDLE
        end
        ygen_prev <= vpos;
    end

    // ======================= output (ce-paced read) ========================
    // AREA FIX 2026-07-19: this read was combinational (`assign road_index = linebuf[..]`),
    // which BLOCKS BRAM inference -- Quartus reported "uninferred due to asynchronous read
    // logic" and built the whole 1024x10 buffer out of flip-flops + a 1024:1 mux
    // (pp_road_gen was 7,306 ALMs). BRAM reads are synchronous, so the read is now
    // REGISTERED, which is the inference template. See
    // [[Sim-model async-read RAM does not infer BRAM]].
    // TIMING NOTE -- the real pixel period is 3-4 clk, NOT the "~8 clk" the
    // pp_video_composite header claims: hcnt advances on ena_vidgen, whose slot machine
    // (poleposition.vhd:459-479) pulses every 3rd/4th clock_18. So the +1 clk here is a
    // meaningful fraction of a pixel, not free.
    // The registered value is correct from 1 clk into each pixel and stable for the rest,
    // including the first pixel of a line. (A `ce`-latched hpos+1 read-ahead would give
    // zero net latency but breaks pixel 0: the prefetch happens while hpos=383, which
    // selects entry 128, not 0. Rejected for that reason -- do not "optimise" back to it.)
    // Verified against the draw_road oracle with a CLOCK-ACCURATE rig (see the road co-sim
    // under the sim tree). NOTE: the STOCK rig samples combinationally with no clk edge and
    // therefore cannot evaluate a registered read at all -- it reports 100% mismatch on ANY
    // synchronous read. Use the clock-accurate sampling loop, not the stock one.
    wire        disp_bank = vpos[0];
    wire [8:0]  rd = {1'b0, hpos[7:0]} + {6'd0, xscroll_bank[disp_bank]};  // scanline[xscroll+x]
    reg  [9:0]  road_index_r;
    always @(posedge clk) road_index_r <= linebuf[{disp_bank, rd}];
    assign road_index  = road_index_r;
    assign road_active = (vpos >= 9'd128);

endmodule

`default_nettype wire
