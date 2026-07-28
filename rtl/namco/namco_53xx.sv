//============================================================================
//  namco_53xx.sv — Namco 53xx I/O MCU wrapper (steering/DSW reader)
//
//  Ground truth: MAME src/devices/machine/namco53.cpp (namco_53xx_device) +
//  src/mame/namco/polepos.cpp machine_config (:901-906, :918-919) + the
//  polepos_state steering helpers (polepos.cpp :362-389, steering_changed_r
//  / steering_delta_r — these are CPU-side in MAME, not part of namco53.cpp
//  itself, but are bundled into this wrapper per the spec: this chip "owns"
//  everything the 53xx chip-select session touches).
//  MB8843 4-bit MCU (rtl/cpu/mb88_sv/mb88.sv) + its 0x400 internal mask ROM
//  (ioctl index 6, offset 0x400-0x7FF, 53xx.bin crc b326fecb).
//
//  polepos machine_config port wiring:
//    k_port_callback = namco_53xx_k_r, HARDWIRED TO 0 in polepos.cpp (comment:
//                       "hardwired to 0") -> k_port_in tied to 4'h0 here.
//    input<0> = steering_changed_r   (R0, bit0 only meaningful)
//    input<1> = steering_delta_r     (R1, bit0 only meaningful)
//    input<2> = DSWA & 0x0f          (R2)
//    input<3> = DSWA >> 4            (R3)
//    p_port_callback: NOT bound for polepos -> P output unwired.
//  Unlike 51xx, NO write_callback<1> is bound in polepos.cpp (namco53.cpp has
//  no write() method at all) — this wrapper has no wr_en/wr_data input; the
//  Z80 can select+read chip1 but writes to it are architecturally a no-op.
//
//  ---- STEERING (polepos.cpp steering_changed_r/steering_delta_r, faithfully
//  reproduced arithmetic) -------------------------------------------------
//  MAME samples the analog "STEER" dial EVERY TIME the running 53xx firmware
//  polls R0 (an mb88 "inR" opcode fetch) — there is no fixed rate. Reproducing
//  that exactly would need a read-strobe tapped out of mb88_core's opcode
//  decode (not currently exposed). This wrapper instead updates the
//  accumulator once per `ena` tick (1.536 MHz, the MCU's own clock enable) —
//  faster than any real poll rate, so it never falls behind physical wheel
//  motion, at the cost of not being cycle-exact. #unverified / KNOWN ITERATION
//  POINT: steer_in itself has NO real analog source wired yet either (see
//  Arcade-PolePosition.sv's steer_in placeholder) — steering feel needs HW
//  iteration regardless of this module's timing choice.
//============================================================================
`default_nettype none

module namco_53xx
(
    input  wire        clk,        // fabric clock (CLK_49M)
    input  wire        ena,        // MCU clock enable = clk_sys/32 = 1.536 MHz (MASTER_CLOCK/8/2)
    input  wire        reset_n,    // = ~system_reset & namco_reset (LS259 q1)

    // ---- 06xx bus-side ------------------------------------------------------
    input  wire        chip_sel,   // chipsel[1]: active-high IRQ/select pulse
    output wire  [7:0] data_out,   // -> namco_06xx chip1_din (data_r AND-reduce input)

    // ---- polepos I/O mapping ------------------------------------------------
    input  wire  [7:0] dswa,       // DSWA: input<2>=dswa[3:0] input<3>=dswa[7:4]
    input  wire  [7:0] steer_in,   // raw 8-bit dial position (MAME m_steer_io->read())

    // ---- ROM (ioctl index 6; this wrapper claims addr[11:10]==2'b01, i.e.
    //      the 0x400-0x7FF slice) --------------------------------------------
    input  wire        rom_wr,
    input  wire [11:0] rom_addr_in,
    input  wire  [7:0] rom_data_in
);

    // ---- steering accumulator (polepos.cpp steering_changed_r, verbatim
    //      arithmetic; see header for the update-rate simplification) -------
    reg  [7:0]       steer_last;
    reg  signed [8:0] steer_accum;
    reg              steer_delta;

    wire signed [8:0] diff2 = ($signed({1'b0, steer_in}) - $signed({1'b0, steer_last})) <<< 1;
    wire signed [8:0] accum_pre = steer_accum + diff2;

    always @(posedge clk) begin
        if (!reset_n) begin
            steer_last  <= 8'h00;
            steer_accum <= 9'sd0;
            steer_delta <= 1'b0;
        end else if (ena) begin
            steer_last <= steer_in;
            if (accum_pre < 0) begin
                steer_delta <= 1'b0;
                steer_accum <= accum_pre + 9'sd1;
            end else if (accum_pre > 0) begin
                steer_delta <= 1'b1;
                steer_accum <= accum_pre - 9'sd1;
            end else begin
                steer_accum <= accum_pre;
            end
        end
    end

    wire steer_changed_bit = steer_accum[0];

    // ---- K-port: hardwired to 0 in polepos.cpp -----------------------------
    wire [3:0] k_in = 4'h0;

    // ---- R-ports: steering (R0/R1), DSWA (R2/R3) ---------------------------
    wire [3:0] r0_in = {3'b000, steer_changed_bit};
    wire [3:0] r1_in = {3'b000, steer_delta};
    wire [3:0] r2_in = dswa[3:0];
    wire [3:0] r3_in = dswa[7:4];
    wire [3:0] r0_out, r1_out, r2_out, r3_out;  // unused (53xx doesn't drive R as outputs)
    wire [3:0] p_out_unused;

    wire [3:0] oh_w, ol_w;

    wire [10:0] rom_addr;
    wire  [7:0] rom_data;

    mb88 u_mcu
    (
        .clock      (clk),
        .ena        (ena),
        .reset_n    (reset_n),

        .r0_port_in (r0_in), .r1_port_in (r1_in), .r2_port_in (r2_in), .r3_port_in (r3_in),
        .r0_port_out(r0_out), .r1_port_out(r1_out), .r2_port_out(r2_out), .r3_port_out(r3_out),
        .k_port_in  (k_in),
        .ol_port_out(ol_w), .oh_port_out(oh_w),
        .p_port_out (p_out_unused),

        .stby_n     (1'b1),
        .tc_n       (1'b1),
        .irq_n      (~chip_sel),
        .sc_in_n    (1'b1),
        .si_n       (1'b1),
        .sc_out_n   (),
        .so_n       (),
        .to_n       (),

        .rom_addr   (rom_addr),
        .rom_data   (rom_data)
    );

    // read() returns m_portO directly (O_w has no scheduler sync in namco53.cpp,
    // unlike 51xx) — no external write path exists either (see header), so the
    // MCU's own O-port register is the whole story; no separate mailbox needed.
    assign data_out = {oh_w, ol_w};

    // ---- 0x400 internal MCU ROM (ioctl index 6, offset 0x400-0x7FF) -------
    dpram_dc #(.widthad_a(10)) rom_53xx
    (
        .clock_a  (clk), .address_a(rom_addr[9:0]), .data_a(8'h00), .wren_a(1'b0), .q_a(rom_data),
        .clock_b  (clk), .address_b(rom_addr_in[9:0]), .data_b(rom_data_in),
        .wren_b   (rom_wr & (rom_addr_in[11:10] == 2'b01)), .q_b()
    );

endmodule

`default_nettype wire
