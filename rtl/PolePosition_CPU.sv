//============================================================================
//  PolePosition_CPU.sv — Pole Position CPU subsystem
//    Z80 maincpu (this file today) + [NEXT] two Z8002 game CPUs + shared video RAM.
//    Replaces Xevious poleposition.vhd's 3-Z80 muxed-bus CPU section, presenting the
//    same downstream video-RAM read interface the Xevious video pipeline consumes.
//
//  Ground truth: MAME polepos.cpp  z80_map / z80_io / machine_config (LS259 @8E).
//  Fabric clock = 49.152 MHz (CLK_49M, from the Vastar PLL); EXACT CE divides:
//    Z80 + both Z8002 = /16 = 3.072 MHz · pixel = /8 = 6.144 · Namco 5xxx = /32 = 1.536.
//
//  ROLE — the Z80 is MASTER of the 3-CPU board: boots, self-tests, programs the LS259
//  latch, then RELEASES the two Z8002 game CPUs (q4/q5) and the Namco 5xxx (q1). All
//  three then talk through the shared video RAM (Z80 byte @0x4000-0x57FF; the Z8002s
//  word @0x8000-0xAFFF — the SAME physical buffers).
//
//  DONE (folded from pp_maincpu.sv): Z80 (T80s) + prog ROM (ioctl) + NVRAM + sound RAM
//  + LS259 latch + IRQ/READY; exposes the video-RAM byte port, 06xx bus, WSG, engine, ADC.
//  NEXT (this phase): add the two Z8002 instances + sub ROMs + the shared video RAM
//  (word/byte dual-width, arbitrated) + NVI@vblank + the 0x6000 nvi-enable latch.
//  #unverified — validates only IN-SYSTEM (T80 is VHDL, no standalone Verilator).
//============================================================================
`default_nettype none

module PolePosition_CPU
(
    input  wire        clk,           // CLK_49M fabric clock (49.152 MHz)
    input  wire        cen,           // Z80 clock-enable = CLK_49M /16 = 3.072 MHz
    input  wire        reset,         // active-high subsystem reset
    input  wire        pause,

    // ---- vertical line counter from video timing (drives IRQ / READY / sub-NVI) ----
    input  wire [8:0]  vpos,          // current scanline, 0..263 (set_raw vtotal=264)

    // ---- LS259 control-latch outputs (MAME polepos.cpp:931-943) ----------------
    output wire        sub1_reset_n,  // q4  0 = Z8002 #1 held in reset (MAME .invert())
    output wire        sub2_reset_n,  // q5  0 = Z8002 #2 held in reset (MAME .invert())
    output wire        namco_reset,   // q1  Namco 51/52/53/54xx reset  (polarity #unverified vs namco51.cpp)
    output wire        sound_en,      // q2  WSG sound_enable + engine clson
    output wire        gasel,         // q3  ADC channel select: 0=BRAKE, 1=ACCEL
                                       // (verified: MAME polepos.h m_analog_io{"BRAKE","ACCEL"}
                                       // indexed by gasel via analog_r()/gasel_w())
    output wire        sb0,           // q6  auto_start_mask = !q6 in MAME
    output wire        chacl,         // q7  (chacl_w — unmodelled)
    output wire        sub_nvi_trig,  // 1-clk pulse at line 240 -> NVI to BOTH Z8002s

    // ---- shared video-RAM byte port (Z80 view, 0x4000-0x57FF) ------------------
    //   sprite 0x4000-0x47FF | road 0x4800-0x4BFF | alpha 0x4C00-0x4FFF | view 0x5000-0x57FF
    //   Byte<->word lane mapping to the Z8002 side is resolved at pp_top (Z8002 phase).
    output wire [12:0] vram_addr,     // offset within the 0x4000-0x5FFF window
    output wire  [7:0] vram_dout,
    output wire        vram_wr,
    output wire        vram_rd,
    input  wire  [7:0] vram_din,      // #unused now that PolePosition_subcpu is
                                       // instantiated below (kept for interface
                                       // stability); real read data comes from
                                       // subcpu_vram_din internally.

    // ---- Namco 06xx bus (0x9000 data / 0x9100 ctrl, both mirror 0x0EFF) --------
    output wire  [7:0] n06_dout,
    output wire        n06_data_wr, n06_data_rd,
    output wire        n06_ctrl_wr, n06_ctrl_rd,
    input  wire  [7:0] n06_din,
    input  wire        n06_nmi_n,     // 06xx nmi_generate() -> Z80 NMI (active low). Was tied
                                       // 1'b1 (permanently inactive) before the 06xx block existed;
                                       // now driven by namco_06xx.sv via poleposition.vhd.

    // ---- Namco WSG sound registers (0x83C0-0x83FF, 64 bytes) -------------------
    output wire  [5:0] wsg_addr,
    output wire  [7:0] wsg_dout,
    output wire        wsg_wr, wsg_rd,
    input  wire  [7:0] wsg_din,

    // ---- engine sound (0xA200 lower nibble / 0xA300 upper nibble) --------------
    output wire  [7:0] engine_dout,
    output wire        engine_lsb_wr,
    output wire        engine_msb_wr,

    // ---- ADC0804 (Z80 I/O port 0x00) ------------------------------------------
    output wire        adc_wr, adc_rd,
    input  wire  [7:0] adc_din,       // conversion result (pedal position)
    input  wire        adc_intr_n,    // ADC INTR pin, active-low (end-of-conversion)

    // ---- watchdog (0xA100) -----------------------------------------------------
    output wire        watchdog_wr,

    // ---- ILLEGAL-SCREAM-2026-08-09 ---------------------------------------------
    // Sticky "one of the Z8002 subs hit an unimplemented opcode" flag. z8002.sv's
    // S_ILLEGAL is a TERMINAL state with mreq deasserted -- the sub just stops dead,
    // silently. Without this the only symptom is frozen road/sprite/view buffers,
    // which reads as a rendering bug. Routed to LED_USER at the top level.
    output wire        sub_illegal,

    // ---- ROM load (ioctl) — maincpu region of the index-0 stream (0x0000-0x2FFF)
    input  wire [24:0] ioctl_addr,
    input  wire  [7:0] ioctl_data,
    input  wire        rom_wr,        // = ioctl_wr & (index==0) & (ioctl_addr < 0x3000)

    // ---- sub CPU subsystem (PolePosition_subcpu) -------------------------
    input  wire        ioctl_wr_idx0, // = ioctl_wr & (index==0), FULL range (sub ROM regions
                                       //   0x3000-0xAFFF/0xB000-0x12FFF decoded inside the subsystem)
    input  wire        ic25_en,       // PP2 IC25 protection overlay (machine polepos2 only)
    // video-pipeline scanout: 4 INDEPENDENT read ports (see PolePosition_subcpu)
    input  wire [10:0] scan_sprite_addr,
    output wire [15:0] scan_sprite_dout,
    input  wire  [9:0] scan_road_addr,
    output wire [15:0] scan_road_dout,
    input  wire  [9:0] scan_alpha_addr,
    output wire [15:0] scan_alpha_dout,
    input  wire [10:0] scan_view_addr,
    output wire [15:0] scan_view_dout,
    output wire [15:0] hscroll,       // view16_hscroll (z8002_map 0xC000)
    output wire [15:0] vscroll,       // road16_vscroll (z8002_map 0xC100)

    // ---- HISCORE-NVRAM-2026-09-20: hiscore access to the NVRAM's free port B --
    // Scores live in the battery-backed NVRAM (Z80 0x3000-0x37FF). hiscore.dat:
    //   @:maincpu,program,3000,7f2,b0,95
    // 11-bit address == the 2 KB NVRAM == hiscore.v's HS_ADDRESSWIDTH(11), so
    // hs_address indexes the NVRAM directly with no offset.
    input  wire [10:0] hs_address,
    output wire  [7:0] hs_data_out,   // NVRAM -> hiscore  (data_from_ram)
    input  wire  [7:0] hs_data_in,    // hiscore -> NVRAM  (data_to_ram)
    input  wire        hs_write
);

    //------------------------------------------------------------------------
    //  Z80 core (T80s soft core, same as the Kangaroo scaffold)
    //------------------------------------------------------------------------
    wire [15:0] cpu_A;
    wire  [7:0] cpu_Dout;
    wire  [7:0] cpu_Din;
    wire        n_m1, n_mreq, n_iorq, n_rd, n_wr, n_rfsh;
    wire        n_int;

    T80s #(.Mode(0), .T2Write(1), .IOWait(1)) main_cpu
    (
        .RESET_n (~reset),
        .CLK     (clk),
        .CEN     (cen & ~pause),
        .INT_n   (n_int),
        .NMI_n   (n06_nmi_n),
        .BUSRQ_n (1'b1),
        .M1_n    (n_m1),
        .MREQ_n  (n_mreq),
        .IORQ_n  (n_iorq),
        .RD_n    (n_rd),
        .WR_n    (n_wr),
        .RFSH_n  (n_rfsh),
        .A       (cpu_A),
        .DI      (cpu_Din),
        .DO      (cpu_Dout)
    );

    wire mem  = ~n_mreq & n_rfsh;      // valid memory access (exclude refresh)
    wire wr_s = ~n_wr & cen;           // single-clk write strobe on the cen tick
    wire rd_s = ~n_rd;

    //------------------------------------------------------------------------
    //  Address decode (z80_map, MAME polepos.cpp:435-453) — mirrors folded in
    //------------------------------------------------------------------------
    wire cs_rom    = mem & (cpu_A[15:14] == 2'b00) & ~(cpu_A[15:12] == 4'h3);   // 0x0000-0x2FFF
    wire cs_nvram  = mem & (cpu_A[15:12] == 4'h3);                              // 0x3000-0x3FFF (mirror 0x0800)
    wire cs_vram   = mem & (cpu_A[15:13] == 3'b010);                            // 0x4000-0x5FFF (view ends 0x57FF)

    // 0x8000-0x8FFF page: sound work RAM 0x000-0x3BF, WSG regs 0x3C0-0x3FF (mirror 0x0C00)
    wire pg8       = mem & (cpu_A[15:12] == 4'h8);
    wire cs_wsg    = pg8 & (cpu_A[9:6] == 4'b1111);                             // 0x_3C0-0x_3FF
    wire cs_sndram = pg8 & ~cs_wsg;                                            // 0x_000-0x_3BF

    // 0x9000-0x9FFF page: 06xx (A8 selects data/ctrl; A[7:0] & A[11:9] mirror 0x0EFF)
    wire pg9       = mem & (cpu_A[15:12] == 4'h9);
    wire cs_06d    = pg9 & ~cpu_A[8];                                          // 0x9000 data
    wire cs_06c    = pg9 &  cpu_A[8];                                          // 0x9100 ctrl

    // 0xA000-0xAFFF page: A[9:8] selects {ready/latch, watchdog, engineL, engineH}
    wire pgA       = mem & (cpu_A[15:12] == 4'hA);
    wire cs_aready = pgA & (cpu_A[9:8] == 2'b00);                              // 0xA000  rd READY / wr latch
    wire cs_awdog  = pgA & (cpu_A[9:8] == 2'b01);                             // 0xA100  wr watchdog
    wire cs_aengl  = pgA & (cpu_A[9:8] == 2'b10);                             // 0xA200  wr engine lsb
    wire cs_aengh  = pgA & (cpu_A[9:8] == 2'b11);                             // 0xA300  wr engine msb

    // Z80 I/O space: ADC0804 at port 0x00 (z80_io, polepos.cpp:456-460)
    wire cs_io_adc = ~n_iorq & (cpu_A[7:0] == 8'h00);

    //------------------------------------------------------------------------
    //  LS259 control latch (8E) — write_d0: A[2:0] selects bit, D0 is data
    //------------------------------------------------------------------------
    reg [7:0] latch;                   // {chacl,sb0,sub2_rst_n,sub1_rst_n,gasel,sound_en,namco_rst,irq_en}
    wire      latch_wr = cs_aready & wr_s;
    always @(posedge clk) begin
        if (reset) latch <= 8'h00;     // power-on: q4/q5=0 -> both Z8002s held in reset (correct)
        else if (latch_wr) latch[cpu_A[2:0]] <= cpu_Dout[0];
    end
    assign namco_reset  = latch[1];
    assign sound_en     = latch[2];
    assign gasel        = latch[3];
    assign sub1_reset_n = latch[4];
    assign sub2_reset_n = latch[5];
    assign sb0          = latch[6];
    assign chacl        = latch[7];
    wire   irq_en       = latch[0];    // q0

    //------------------------------------------------------------------------
    //  IRQ generation (polepos.cpp scanline() :392-403)
    //   maincpu IRQ asserted at 64V and 192V when q0=1; q0=0 acks/clears.
    //   sub NVI trigger pulsed at 240V (line gating done per-Z8002 elsewhere).
    //------------------------------------------------------------------------
    reg [8:0] vpos_d;
    always @(posedge clk) vpos_d <= vpos;
    wire vpos_new  = (vpos != vpos_d);
    wire irq_trig  = vpos_new & ((vpos == 9'd64) | (vpos == 9'd192));
    assign sub_nvi_trig = vpos_new & (vpos == 9'd240);

    reg irq_pending;
    always @(posedge clk) begin
        if (reset)                       irq_pending <= 1'b0;
        else if (!irq_en)                irq_pending <= 1'b0;   // q0=0 forces clear (MAME .invert())
        else if (irq_trig)               irq_pending <= 1'b1;
    end
    assign n_int = ~(irq_pending & irq_en);

    //------------------------------------------------------------------------
    //  READY read (0xA000, polepos.cpp ready_r :291-302)
    //    bit1 ^= 1 when vpos>=128 ; bit3 ^= 1 when ADC INTR asserted (done)
    //------------------------------------------------------------------------
    wire [7:0] ready_val = 8'hFF
                         ^ ((vpos >= 9'd128) ? 8'h02 : 8'h00)
                         ^ ((~adc_intr_n)    ? 8'h08 : 8'h00);

    //------------------------------------------------------------------------
    //  Program ROM (0x0000-0x2FFF = 12 KB) — one 16 KB block, ioctl-loaded
    //------------------------------------------------------------------------
    wire [7:0] rom_D;
    dpram_dc #(.widthad_a(14)) prog_rom       // 16 KB (uses 0x0000-0x2FFF)
    (
        .clock_a  (clk),
        .address_a(cpu_A[13:0]),
        .q_a      (rom_D),

        .clock_b  (clk),
        .address_b(ioctl_addr[13:0]),
        .data_b   (ioctl_data),
        .wren_b   (rom_wr)
    );

    //------------------------------------------------------------------------
    //  NVRAM (0x3000-0x37FF, battery-backed in MAME) — 2 KB
    //  MAME ground truth: polepos.cpp:927 NVRAM(config, "nvram", nvram_device::DEFAULT_ALL_1)
    //  -> a fresh/unbacked NVRAM powers up filled with 0xFF. Our core doesn't
    //  battery-back/persist this RAM, so power-on state is all that matters.
    //  Was plain `spram` (powers up 0x00, diverging from MAME); swapped to
    //  dpram_dc (already used above for prog_rom, same 1-cycle read latency —
    //  outdata_reg_a defaults UNREGISTERED, matching spram's registered-q
    //  timing) so its init_file generic can point altsyncram at an all-FF .mif.
    //  Port B is unused (tied off; dpram_dc's wren_b/data_b/byteena_* default
    //  safely, same as the prog_rom instance above — only address_b/clock_b
    //  need an explicit connection since those VHDL ports have no default).
    //------------------------------------------------------------------------
    wire sub1_illegal_w, sub2_illegal_w;   // ILLEGAL-SCREAM-2026-08-09

    wire [7:0] nvram_D;
    dpram_dc #(.widthad_a(11), .init_file("rtl/ram_rom/pp_nvram_ff.mif")) nvram
    (
        .clock_a  (clk),
        .address_a(cpu_A[10:0]),
        .data_a   (cpu_Dout),
        .wren_a   (cs_nvram & wr_s),
        .q_a      (nvram_D),

        // HISCORE-NVRAM-2026-09-20: port B was unused (address_b tied to 0).
        // It is now the hiscore module's read/write window into the NVRAM.
        // Original: .address_b(11'd0)  with no data_b/wren_b/q_b.
        .clock_b  (clk),
        .address_b(hs_address),
        .data_b   (hs_data_in),
        .wren_b   (hs_write),
        .q_b      (hs_data_out)
    );

    //------------------------------------------------------------------------
    //  Sound work RAM (0x8000-0x83BF) — 1 KB block (0x3C0-0x3FF is the WSG port)
    //------------------------------------------------------------------------
    wire [7:0] sndram_D;
    spram #(.DATA_WIDTH(8), .ADDR_WIDTH(10)) sndram
    (
        .clk (clk),
        .addr(cpu_A[9:0]),
        .data(cpu_Dout),
        .q   (sndram_D),
        .we  (cs_sndram & wr_s)
    );

    //------------------------------------------------------------------------
    //  Peripheral port fan-out
    //------------------------------------------------------------------------
    assign vram_addr    = cpu_A[12:0];
    assign vram_dout    = cpu_Dout;
    // VRAM-WR-RACE-FIX-2026-07-27: was `cs_vram & wr_s` (wr_s = ~n_wr & cen, a
    // single fabric-clock pulse). PolePosition_subcpu.sv's Port-A arbiter only
    // grants the Z80 5 of 16 `div` slots (own_z80 = div<=4) and its own comment
    // assumes "writes are idempotent across the owner's whole slot (bus held
    // stable)" -- false for a 1-clk pulse racing an independently-phased
    // counter (div resets with `reset`; cen_cnt upstream never does). Co-sim
    // (verilator/pp_maincpu) measured EVERY Z80 VRAM write landing at div=5,
    // outside own_z80, 40/40 samples -- writes were silently dropped 100% of
    // the time. Hold vram_wr for the whole ~n_wr-active window (~2 T-states,
    // longer than one 16-cycle div period) so it's guaranteed to overlap an
    // own_z80 slot regardless of phase. wr_s itself is untouched (still used
    // for the single-pulse-safe local registers: latch, nvram, sndram, etc).
    assign vram_wr      = cs_vram & ~n_wr;
    assign vram_rd      = cs_vram & rd_s;

    assign n06_dout     = cpu_Dout;
    assign n06_data_wr  = cs_06d & wr_s;
    assign n06_data_rd  = cs_06d & rd_s;
    assign n06_ctrl_wr  = cs_06c & wr_s;
    assign n06_ctrl_rd  = cs_06c & rd_s;

    assign wsg_addr     = cpu_A[5:0];
    assign wsg_dout     = cpu_Dout;
    assign wsg_wr       = cs_wsg & wr_s;
    assign wsg_rd       = cs_wsg & rd_s;

    assign engine_dout  = cpu_Dout;
    assign engine_lsb_wr= cs_aengl & wr_s;
    assign engine_msb_wr= cs_aengh & wr_s;

    assign adc_wr       = cs_io_adc & wr_s;
    assign adc_rd       = cs_io_adc & rd_s;

    assign watchdog_wr  = cs_awdog & wr_s;

    //------------------------------------------------------------------------
    //  CPU read data mux
    //------------------------------------------------------------------------
    assign cpu_Din =
        cs_rom     ? rom_D          :
        cs_nvram   ? nvram_D        :
        cs_vram    ? subcpu_vram_din:
        cs_sndram  ? sndram_D       :
        cs_wsg     ? wsg_din        :
        (cs_06d | cs_06c) ? n06_din :
        cs_aready  ? ready_val      :
        cs_io_adc  ? adc_din        :
        8'hFF;

    //------------------------------------------------------------------------
    //  Sub CPU subsystem — two Z8002 game CPUs + shared video RAM
    //  (rtl/PolePosition_subcpu.sv). Z80 byte port <-> vram_* above;
    //  sub1/2_reset_n + sub_nvi_trig from the LS259/IRQ sections above.
    //------------------------------------------------------------------------
    wire [7:0] subcpu_vram_din;

    PolePosition_subcpu subcpu
    (
        .ic25_en      (ic25_en),
        .clk          (clk),
        .reset        (reset),
        .pause        (pause),          // PAUSE-GATE-2026-08-05: freeze both Z8002s

        .sub1_reset_n (sub1_reset_n),
        .sub2_reset_n (sub2_reset_n),
        .sub_nvi_trig (sub_nvi_trig),

        .vram_addr    (vram_addr),
        .vram_dout    (vram_dout),
        .vram_wr      (vram_wr),
        .vram_rd      (vram_rd),
        .vram_din     (subcpu_vram_din),

        .scan_sprite_addr (scan_sprite_addr),
        .scan_sprite_dout (scan_sprite_dout),
        .scan_road_addr   (scan_road_addr),
        .scan_road_dout   (scan_road_dout),
        .scan_alpha_addr  (scan_alpha_addr),
        .scan_alpha_dout  (scan_alpha_dout),
        .scan_view_addr   (scan_view_addr),
        .scan_view_dout   (scan_view_dout),

        .hscroll      (hscroll),
        .vscroll      (vscroll),

        .dn_addr      (ioctl_addr),
        .dn_data      (ioctl_data),
        .dn_wr        (ioctl_wr_idx0),

        .dbg1_pc      (), .dbg2_pc      (),
        .dbg1_ir      (), .dbg2_ir      (),
        .dbg1_fcw     (), .dbg2_fcw     (),
        .dbg1_retire  (), .dbg2_retire  (),
        // ILLEGAL-SCREAM-2026-08-09: these were BOTH left open, so a Z8002
        // S_ILLEGAL (a silent terminal hang) was completely invisible on
        // hardware -- it presented as a video bug and cost weeks. Surfaced now
        // and routed to LED_USER in Arcade-PolePosition.sv. Latched in z8002.sv,
        // so once lit it stays lit until reset.
        .dbg1_illegal (sub1_illegal_w), .dbg2_illegal (sub2_illegal_w),
        .dbg1_regs    (), .dbg2_regs    ()
    );

    assign sub_illegal = sub1_illegal_w | sub2_illegal_w;

endmodule

`default_nettype wire
