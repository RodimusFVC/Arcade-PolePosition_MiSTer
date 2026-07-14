//============================================================================
//  pp_palette_alpha.sv — Pole Position ALPHA (text) layer palette lookup
//
//  Ports MAME's polepos_palette() index arithmetic verbatim (polepos_v.cpp
//  :30-135) for the alpha layer, per the audit's recommendation (avoid
//  reverse-engineering the real PROM address-pin order). Two chained table
//  lookups + the weighted-resistor RGB DAC:
//
//    stage 1: promval = alpha_prom[ {color6, pixel} ]           (proms 0x300)
//             transparent = (promval == 4'hF)          (MAME transpen = 0x2f)
//    stage 2: indirect  = bank128v ? (0x60+promval) : (0x20+promval)
//             r/g/b nib = {red,green,blue}_prom[indirect]  (proms 0x000/1/2)
//    stage 3: R/G/B = weighted DAC of the nibble: bit weights {0e,1f,43,8f}
//
//  NOTE PP uses the *weighted-resistor* DAC (0x0e/0x1f/0x43/0x8f), NOT the
//  raw-nibble passthrough Xevious's red/green/blue.vhd used — regenerate, do
//  not copy those tables (video_mapping §3).
//
//  128V banks 0x020+/0x060+ are physically IDENTICAL colours on real HW (MAME
//  comment polepos_v.cpp:42-51) — we still implement the bank select for
//  faithfulness; it is visually irrelevant, so first-light works with either.
//
//  PROM tables are loaded from the ioctl "proms" region (0x000-0x3FF slice)
//  via prom_wr/prom_addr/prom_data — addr[9:8] selects table, addr[7:0] entry.
//  Held as four independent 256x-wide read ports so the two chained lookups
//  (alpha, then r+g+b) each get a dedicated port. Latency = 2 clk (registered
//  BRAM reads); caller aligns via the video counter offset.
//============================================================================

`default_nettype none

module pp_palette_alpha
(
    input  wire        clk,

    // ---- PROM load (ioctl "proms" region, 0x000-0x3FF slice) ---------------
    input  wire        prom_wr,
    input  wire [9:0]  prom_addr,   // [9:8]=table (0=R,1=G,2=B,3=alpha), [7:0]=idx
    input  wire [7:0]  prom_data,

    // ---- lookup request (from the alpha tile layer) ------------------------
    input  wire [5:0]  color,       // 6-bit tile colour selector
    input  wire [1:0]  pixel,       // 2bpp pixel value
    input  wire        bank128v,    // vpos>=128 palette bank

    // ---- result (2-clk latency) --------------------------------------------
    output wire [7:0]  r,
    output wire [7:0]  g,
    output wire [7:0]  b,
    output wire        transparent  // alpha pixel is transparent (show below)
);
    // ---- PROM tables (loaded from the proms region) ------------------------
    reg [3:0] red_prom   [0:255];   // 0x000 : red   nibble
    reg [3:0] green_prom [0:255];   // 0x100 : green nibble
    reg [3:0] blue_prom  [0:255];   // 0x200 : blue  nibble
    reg [3:0] alpha_prom [0:255];   // 0x300 : alpha indirect selector (4-bit)

    always @(posedge clk) begin
        if (prom_wr) begin
            case (prom_addr[9:8])
                2'd0: red_prom  [prom_addr[7:0]] <= prom_data[3:0];
                2'd1: green_prom[prom_addr[7:0]] <= prom_data[3:0];
                2'd2: blue_prom [prom_addr[7:0]] <= prom_data[3:0];
                2'd3: alpha_prom[prom_addr[7:0]] <= prom_data[3:0];
            endcase
        end
    end

    // ---- stage 1: alpha PROM lookup ({color,pixel}) ------------------------
    wire [7:0] alpha_idx = {color, pixel};   // = color*4 + pixel (0..255)
    reg  [3:0] promval;
    reg        s1_bank;
    always @(posedge clk) begin
        promval <= alpha_prom[alpha_idx];
        s1_bank <= bank128v;
    end
    wire s1_transp = (promval == 4'hF);

    // ---- stage 2: indirect index -> R/G/B nibble lookup --------------------
    //   indirect = bank ? 0x60+promval : 0x20+promval   (both < 128)
    wire [7:0] indirect = s1_bank ? (8'h60 + promval) : (8'h20 + promval);
    reg  [3:0] r_nib, g_nib, b_nib;
    reg        s2_transp;
    always @(posedge clk) begin
        r_nib     <= red_prom  [indirect];
        g_nib     <= green_prom[indirect];
        b_nib     <= blue_prom [indirect];
        s2_transp <= s1_transp;
    end

    // ---- stage 3: weighted-resistor DAC (combinational) --------------------
    //   value = 0x0e*bit0 + 0x1f*bit1 + 0x43*bit2 + 0x8f*bit3   (max 0xFF)
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
