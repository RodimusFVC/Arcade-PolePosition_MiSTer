//============================================================================
//  pp_palette_view.sv — Pole Position VIEW/BG (scenery) layer palette lookup
//
//  Ports MAME's polepos_palette() index arithmetic verbatim for the bg/view
//  layer (polepos_v.cpp:94-103), the sibling of pp_palette_alpha:
//
//    stage 1: promval = view_prom[ {color6, pixel2} ]        (proms 0x400)
//    stage 2: indirect = 0x00 + promval                      (MAME: 0x000+color)
//    stage 3: r/g/b nib = {red,green,blue}_prom[indirect]    (proms 0x000/1/2)
//    stage 4: R/G/B = weighted-resistor DAC (0x0e/1f/43/8f)  (same as alpha)
//
//  DIFFERENCES from pp_palette_alpha (all per MAME):
//    * NO transparency — the bg/view has no transpen (line 102 is an unconditional
//      0x000+color). It is the OPAQUE bottom layer; alpha's transparency is what
//      reveals it. So there is no `transparent` output.
//    * NO 128V banking — single bank (line 99-103, no 0x060 sibling).
//    * indirect resolves to 0x00..0x0F (promval is 4-bit), i.e. the bg colours
//      live in the first 16 entries of the shared R/G/B DAC PROMs.
//
//  The R/G/B DAC PROMs (0x000/0x100/0x200) are SHARED with the alpha stage on
//  real HW; this module keeps its own copies (tiny 256x4 tables) so it is a
//  self-contained drop-in like pp_palette_alpha. Latency = 2 clk (matches
//  pp_palette_alpha so the compositor can align the two layers with one delay).
//
//  PROM load: ioctl "proms" region. prom_addr[10:8] selects the table
//  (0=R@0x000, 1=G@0x100, 2=B@0x200, 4=view@0x400); prom_addr[7:0]=entry.
//============================================================================

`default_nettype none

module pp_palette_view
(
    input  wire        clk,

    // ---- PROM load (ioctl "proms" region) ----------------------------------
    input  wire        prom_wr,
    input  wire [11:0] prom_addr,   // [11:8]=table (0=R,1=G,2=B,4=view), [7:0]=idx
    input  wire [7:0]  prom_data,

    // ---- lookup request (from the view tile layer) -------------------------
    input  wire [5:0]  color,       // 6-bit tile colour selector
    input  wire [1:0]  pixel,       // 2bpp pixel value

    // ---- result (2-clk latency, matches pp_palette_alpha) ------------------
    output wire [7:0]  r,
    output wire [7:0]  g,
    output wire [7:0]  b
);
    // ---- PROM tables (loaded from the proms region) ------------------------
    reg [3:0] red_prom   [0:255];   // 0x000 : red   nibble  (shared DAC table)
    reg [3:0] green_prom [0:255];   // 0x100 : green nibble
    reg [3:0] blue_prom  [0:255];   // 0x200 : blue  nibble
    reg [3:0] view_prom  [0:255];   // 0x400 : bg/view indirect selector (4-bit)

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

    // ---- stage 1: view PROM lookup ({color,pixel}) -------------------------
    wire [7:0] view_idx = {color, pixel};   // = color*4 + pixel (0..255)
    reg  [3:0] promval;
    always @(posedge clk) promval <= view_prom[view_idx];

    // ---- stage 2: indirect index -> R/G/B nibble lookup --------------------
    //   indirect = 0x00 + promval  (MAME line 102: 0x000 + color) -> 0x00..0x0F
    wire [7:0] indirect = {4'h0, promval};
    reg  [3:0] r_nib, g_nib, b_nib;
    always @(posedge clk) begin
        r_nib <= red_prom  [indirect];
        g_nib <= green_prom[indirect];
        b_nib <= blue_prom [indirect];
    end

    // ---- stage 3: weighted-resistor DAC (combinational) --------------------
    //   value = 0x0e*bit0 + 0x1f*bit1 + 0x43*bit2 + 0x8f*bit3   (max 0xFF)
    function [7:0] dac(input [3:0] n);
        dac = (n[0] ? 8'h0e : 8'h00) + (n[1] ? 8'h1f : 8'h00)
            + (n[2] ? 8'h43 : 8'h00) + (n[3] ? 8'h8f : 8'h00);
    endfunction

    assign r = dac(r_nib);
    assign g = dac(g_nib);
    assign b = dac(b_nib);

endmodule

`default_nettype wire
