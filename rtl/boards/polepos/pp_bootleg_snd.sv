//  Based on MAME polepos.cpp (Ernesto Corvi, Juergen Buchmueller, Alex Pasadyn, Aaron Giles, Nicola Salmoria, BSD-3-Clause)
`default_nettype none

module pp_bootleg_snd
(
    input  wire        clk,
    input  wire        cen,
    input  wire        reset,
    input  wire        pause,

    input  wire        latch_wr,
    input  wire  [7:0] latch_din,

    output wire [14:0] rom_addr,
    input  wire  [7:0] rom_data,

    output wire signed [15:0] audio,

    output chip_pool_pkg::z80r_i_t z80r_1_i,
    input  chip_pool_pkg::z80r_o_t z80r_1_o,
    output ram_pool_pkg::pram_i_t  bs_pr_i,
    input  ram_pool_pkg::pram_o_t  bs_pr_o,

    output chip_pool_pkg::tms5220rsws_i_t tms5220rsws_0_i,
    input  chip_pool_pkg::tms5220rsws_o_t tms5220rsws_0_o
);

    wire [15:0] A;
    wire  [7:0] DO;
    reg   [7:0] DI;
    wire        n_m1, n_mreq, n_iorq, n_rd, n_wr, n_rfsh;
    reg         nmi_pend = 1'b0;

    assign z80r_1_i.reset_n = ~reset;
    assign z80r_1_i.ce      = cen & ~pause;
    assign z80r_1_i.wait_n  = ~tms5220rsws_0_o.ready_n;   // TMS5220 READY holds the Z80 until the chip takes the byte
    assign z80r_1_i.int_n   = 1'b1;
    assign z80r_1_i.nmi_n   = ~nmi_pend;
    assign z80r_1_i.di      = DI;
    assign A      = z80r_1_o.a;
    assign DO     = z80r_1_o.dout;
    assign n_m1   = z80r_1_o.m1_n;
    assign n_mreq = z80r_1_o.mreq_n;
    assign n_iorq = z80r_1_o.iorq_n;
    assign n_rd   = z80r_1_o.rd_n;
    assign n_wr   = z80r_1_o.wr_n;
    assign n_rfsh = z80r_1_o.rfsh_n;

    wire mem    = ~n_mreq & n_rfsh;
    wire wr_s   = ~n_wr & cen & ~pause;
    wire cs_rom = mem & (A[15:13] == 3'b000);
    wire cs_ram = mem & (A[15:8]  == 8'h27);
    wire cs_lat = mem & (A == 16'h4000);
    wire cs_ack = mem & (A == 16'h6000);
    wire cs_tms = ~n_iorq & n_m1 & (A[7:0] == 8'h00);

    assign rom_addr = {2'b00, A[12:0]};

    wire [7:0] ram_q = bs_pr_o.a_q;
    assign bs_pr_i = '{a_addr: {8'd0, A[7:0]}, a_d: DO, a_we: cs_ram & wr_s, b_addr: 16'd0, b_d: 8'd0, b_we: 1'b0};

    reg [7:0] latch = 8'hFF;
    reg       rd_d;
    wire      rd_edge = ~n_rd & ~rd_d;
    always @(posedge clk) begin
        rd_d <= ~n_rd;
        if (reset) begin
            nmi_pend <= 1'b0;
        end else begin
            if (latch_wr) begin latch <= latch_din; nmi_pend <= 1'b1; end
            else if (cs_ack & rd_edge & ~pause) nmi_pend <= 1'b0;
        end
    end

    assign tms5220rsws_0_i.reset = reset;
    assign tms5220rsws_0_i.pause = pause;
    assign tms5220rsws_0_i.rs_n  = ~(cs_tms & ~n_rd);
    assign tms5220rsws_0_i.ws_n  = ~(cs_tms & ~n_wr);
    assign tms5220rsws_0_i.d_in  = DO;
    assign audio                 = tms5220rsws_0_o.audio;

    always @(*) begin
        if      (cs_rom) DI = rom_data;
        else if (cs_ram) DI = ram_q;
        else if (cs_lat) DI = latch;
        else if (cs_tms) DI = tms5220rsws_0_o.d_out;
        else             DI = 8'h00;
    end

endmodule

`default_nettype wire
