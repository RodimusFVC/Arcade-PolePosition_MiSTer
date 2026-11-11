//============================================================================
//  pp_bootleg_snd.sv -- Pole Position II bootlegs' speech board (MAME polepos2bi / polepos2bs / grally).
//  Based on MAME polepos.cpp sound_z80_bootleg_map / _iomap:
//    Z80 3.072 MHz: 0000-1FFF ROM, 2700-27FF RAM, 4000 latch, 6000 latch acknowledge; I/O 00 = TMS5220.
//    Latch pending -> Z80 NMI. TMS5220 at 600 kHz = 7500 samples/s.
//  The 8 KB program ROM is read from the (absent) 52xx's voice-ROM BRAM (1-clk registered read).
//============================================================================
`default_nettype none

module pp_bootleg_snd
(
    input  wire        clk,           // 49.152 MHz fabric clock
    input  wire        cen,           // 3.072 MHz Z80 clock enable (same as the main Z80)
    input  wire        reset,
    input  wire        pause,

    input  wire        latch_wr,      // main Z80 OUT $05 strobe
    input  wire  [7:0] latch_din,     // already | 0xfc

    output wire [14:0] rom_addr,      // into the shared 52xx-slot BRAM
    input  wire  [7:0] rom_data,

    output wire signed [15:0] audio,  // TMS5220 sample (MAME stream units * 32768)

    // sim taps
    output wire  [7:0] tms_wr_data,
    output wire        tms_wr_strobe
);

    // ---------------- sound Z80 ----------------
    wire [15:0] A;
    wire  [7:0] DO;
    reg   [7:0] DI;
    wire        n_m1, n_mreq, n_iorq, n_rd, n_wr, n_rfsh;
    reg         nmi_pend = 1'b0;      // generic_latch_8 data pending -> NMI

    t80sv_T80s #(.Mode(0), .T2Write(1), .IOWait(1)) snd_cpu
    (
        .RESET_n (~reset),
        .CLK     (clk),
        .CEN     (cen & ~pause),
        .INT_n   (1'b1),
        .NMI_n   (~nmi_pend),
        .BUSRQ_n (1'b1),
        .M1_n    (n_m1),
        .MREQ_n  (n_mreq),
        .IORQ_n  (n_iorq),
        .RD_n    (n_rd),
        .WR_n    (n_wr),
        .RFSH_n  (n_rfsh),
        .A       (A),
        .DI      (DI),
        .DO      (DO)
    );

    wire mem    = ~n_mreq & n_rfsh;
    wire wr_s   = ~n_wr & cen & ~pause;
    wire cs_rom = mem & (A[15:13] == 3'b000);                 // 0000-1FFF
    wire cs_ram = mem & (A[15:8]  == 8'h27);                  // 2700-27FF
    wire cs_lat = mem & (A == 16'h4000);
    wire cs_ack = mem & (A == 16'h6000);
    wire cs_tms = ~n_iorq & n_m1 & (A[7:0] == 8'h00);

    assign rom_addr = {2'b00, A[12:0]};

    reg [7:0] ram [0:255];
    reg [7:0] ram_q;
    always @(posedge clk) begin
        if (cs_ram & wr_s) ram[A[7:0]] <= DO;
        ram_q <= ram[A[7:0]];
    end

    // ---------------- sound latch (GENERIC_LATCH_8, separate acknowledge) ----------------
    reg [7:0] latch = 8'hFF;
    reg       rd_d;
    wire      rd_edge = ~n_rd & ~rd_d;
    always @(posedge clk) begin
        rd_d <= ~n_rd;
        if (reset) begin
            nmi_pend <= 1'b0;
        end else begin
            if (latch_wr) begin latch <= latch_din; nmi_pend <= 1'b1; end
            else if (cs_ack & rd_edge & ~pause) nmi_pend <= 1'b0;    // acknowledge_r
        end
    end

    // ---------------- TMS5220 ----------------
    // 600 kHz / 80 = 7500 samples/s from 49.152 MHz: +75 per clk, wrap at 491520 (= 49152000/100)
    reg  [18:0] smp_acc = 19'd0;
    reg         ce_smp;
    always @(posedge clk) begin
        ce_smp <= 1'b0;
        if (!pause) begin
            if (smp_acc >= 19'd491445) begin smp_acc <= smp_acc + 19'd75 - 19'd491520; ce_smp <= 1'b1; end
            else smp_acc <= smp_acc + 19'd75;
        end
    end

    wire [7:0] tms_dout;
    // an I/O write holds WR low for two cen ticks: strobe once, on WR's falling edge
    reg        wr_d;
    always @(posedge clk) wr_d <= ~n_wr;
    wire       tms_wr = cs_tms & ~n_wr & ~wr_d & ~pause;
    wire       tms_rd = cs_tms & rd_edge & ~pause;
    wire signed [15:0] tms_audio;
    wire       tms_valid;

    tms5220 tms
    (
        .clk        (clk),
        .reset      (reset),
        .ce_sample  (ce_smp),
        .wr         (tms_wr),
        .din        (DO),
        .rd         (tms_rd),
        .dout       (tms_dout),
        .int_n      (),
        .ready_n    (),
        .audio      (tms_audio),
        .audio_valid(tms_valid)
    );
    assign audio         = tms_audio;
    assign tms_wr_data   = DO;
    assign tms_wr_strobe = tms_wr;

    // ---------------- read mux ----------------
    always @(*) begin
        if      (cs_rom) DI = rom_data;
        else if (cs_ram) DI = ram_q;
        else if (cs_lat) DI = latch;
        else if (cs_tms) DI = tms_dout;
        else             DI = 8'h00;     // MAME unmapped read = 0
    end

endmodule

`default_nettype wire
