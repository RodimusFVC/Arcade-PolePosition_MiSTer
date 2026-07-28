//============================================================================
//  pp_palette_road.sv — Pole Position ROAD layer palette lookup
//
//  Ports MAME's polepos_palette() index arithmetic verbatim for the road layer
//  (polepos_v.cpp:123-126), the sibling of pp_palette_view but with a 10-bit
//  index (the road pen is (roadpal<<6)|roadval, not {color,pixel}):
//
//    stage 1: promval = road_prom[ road_index[9:0] ]         (proms 0x800, 1024)
//             road_index = (roadpal[3:0] << 6) | roadval[5:0]  (from the generator)
//    stage 2: indirect = 0x40 + promval                      (MAME: 0x040+color)
//    stage 3: r/g/b nib = {red,green,blue}_prom[indirect]    (proms 0x000/1/2)
//    stage 4: R/G/B = weighted-resistor DAC (0x0e/1f/43/8f)  (same as alpha/view)
//
//  Like the bg/view palette: NO transparency, NO 128V banking (single bank). The
//  road is drawn opaquely for the lower half (vpos>=128); the compositor selects
//  road-vs-black there, alpha still composites on top.
//
//  PROM load: ioctl "proms" region. road_prom is 0x800-0xBFF (prom_addr[11:10]==
//  2'b10, index=prom_addr[9:0]); R/G/B are 0x000/0x100/0x200 (prom_addr[11:8]=
//  0/1/2, index=prom_addr[7:0]). prom_addr is 12-bit to reach 0xBFF.
//  Latency = 2 clk (matches the other palettes for compositor alignment).
//============================================================================

`default_nettype none

module pp_palette_road
(
    input  wire        clk,

    // ---- PROM load (ioctl "proms" region) ----------------------------------
    input  wire        prom_wr,
    input  wire [11:0] prom_addr,   // R/G/B: [11:8]=0/1/2,[7:0]=idx ; road: [11:10]=10,[9:0]=idx
    input  wire [7:0]  prom_data,

    // ---- lookup request (from the road generator) --------------------------
    input  wire [9:0]  road_index,  // (roadpal<<6) | roadval  (0..1023)

    // ---- result (2-clk latency) --------------------------------------------
    output wire [7:0]  r,
    output wire [7:0]  g,
    output wire [7:0]  b
);
    // ---- PROM tables -------------------------------------------------------
    reg [3:0] red_prom   [0:255];    // 0x000 : red   nibble (shared DAC table)
    reg [3:0] green_prom [0:255];    // 0x100 : green nibble
    reg [3:0] blue_prom  [0:255];    // 0x200 : blue  nibble
    reg [3:0] road_prom  [0:1023];   // 0x800 : road indirect selector (4-bit, 1024)

    always @(posedge clk) begin
        if (prom_wr) begin
            if (prom_addr[11:10] == 2'b10)          // 0x800-0xBFF : road (1024)
                road_prom[prom_addr[9:0]] <= prom_data[3:0];
            else case (prom_addr[11:8])             // 0x000/0x100/0x200 : R/G/B
                4'd0: red_prom  [prom_addr[7:0]] <= prom_data[3:0];
                4'd1: green_prom[prom_addr[7:0]] <= prom_data[3:0];
                4'd2: blue_prom [prom_addr[7:0]] <= prom_data[3:0];
                default: ;
            endcase
        end
    end

    // ---- stage 1: road PROM lookup (10-bit index) --------------------------
    reg [3:0] promval;
    always @(posedge clk) promval <= road_prom[road_index];

    // ---- stage 2: indirect index -> R/G/B nibble lookup --------------------
    //   indirect = 0x40 + promval  (MAME line 126: 0x040 + color) -> 0x40..0x4F
    wire [7:0] indirect = 8'h40 + {4'h0, promval};
    reg  [3:0] r_nib, g_nib, b_nib;
    always @(posedge clk) begin
        r_nib <= red_prom  [indirect];
        g_nib <= green_prom[indirect];
        b_nib <= blue_prom [indirect];
    end

    // ---- stage 3: weighted-resistor DAC (combinational) --------------------
    function [7:0] dac(input [3:0] n);
        dac = (n[0] ? 8'h0e : 8'h00) + (n[1] ? 8'h1f : 8'h00)
            + (n[2] ? 8'h43 : 8'h00) + (n[3] ? 8'h8f : 8'h00);
    endfunction

    assign r = dac(r_nib);
    assign g = dac(g_nib);
    assign b = dac(b_nib);

endmodule

`default_nettype wire
