//============================================================================
//
//  Kangaroo Main CPU Board (TVG-1-CPU-B)
//  Based on MAME kangaroo.cpp by Ville Laitinen, Aaron Giles
//
//============================================================================

module Kangaroo_CPU
(
    input         reset,
    input         clk_10m,           // 10 MHz master clock (matches real XTAL)

    // Video outputs
    output  [2:0] video_r, video_g,  // BGR 3-bit palette
    output  [1:0] video_b,
    output        video_hsync, video_vsync,
    output        video_hblank, video_vblank,
    output        ce_pix,

    // Inputs
    input   [7:0] dsw0,             // 8-bit DIP switch
    input   [4:0] in0,              // IN0: service, start1, start2, coin_l, coin_r
    // GAMESEL-2026-06-21: in1 widened 5->8 (bit5/0x20 = Funky Fish 2nd button). Original: input [4:0] in1,
    input   [7:0] in1,              // IN1: P1 right,left,up,down,punch + bit5 = FF 2nd btn (0x20)
    input   [7:0] in2,              // IN2: P2 right, left, up, down, punch

    // Sound interface
    output  [7:0] sound_latch,      // Data to sound CPU
    output        sound_latch_wr,   // Strobe: sound latch written

    // Blitter ROMs — directly memory-mapped, loaded via index 2
    input         blit0_cs_i, blit1_cs_i, blit2_cs_i, blit3_cs_i,
    // Main program ROMs — loaded via index 0
    input         rom0_cs_i, rom1_cs_i, rom2_cs_i,
    input         rom3_cs_i, rom4_cs_i, rom5_cs_i,
    input  [24:0] ioctl_addr,
    input   [7:0] ioctl_data,
    input         ioctl_wr,

    // MCU (MB8841) — index 6 ROM download + presence flag (original Kangaroo HW only)
    input         mcu_present,    // 1 = MB8841 fitted (kangaroo/kangarooa); 0 = bootleg / Funky Fish
    input         mcurom_wr,      // ioctl_wr for index 6 (prog 0x000-0x7FF + protrom 0x800-0xFFF)

    input         pause,

    // Hiscore interface (active high, stubbed for now)
    input  [15:0] hs_address,
    input   [7:0] hs_data_in,
    output  [7:0] hs_data_out,
    input         hs_write
);

//------------------------------------------------------- Clock Enables -------------------------------------------------------//

// Generate clock enables from 10 MHz master
// cen_5m  = 10/2 = 5 MHz (pixel clock)
// cen_2m5 = 10/4 = 2.5 MHz (Z80 clock)
reg [1:0] div = 2'd0;
always_ff @(posedge clk_10m) begin
    div <= div + 2'd1;
end
wire cen_5m  = (div[0] == 1'b0);     // Every 2nd clock
wire cen_2m5 = (div == 2'd0);         // Every 4th clock

assign ce_pix = cen_5m;

//------------------------------------------------------------ CPU -------------------------------------------------------------//

// Main CPU — Zilog Z80 (T80s soft core)
wire [15:0] cpu_A;
wire  [7:0] cpu_Dout;
wire n_m1, n_mreq, n_iorq, n_rd, n_wr, n_rfsh;

T80s #(.Mode(0), .T2Write(1), .IOWait(1)) main_cpu
(
    .RESET_n(reset),
    .CLK(clk_10m),
    .CEN(cen_2m5 & ~pause),
    .INT_n(n_irq),
    .NMI_n(n_nmi),
    .BUSRQ_n(1'b1),
    .M1_n(n_m1),
    .MREQ_n(n_mreq),
    .IORQ_n(n_iorq),
    .RD_n(n_rd),
    .WR_n(n_wr),
    .RFSH_n(n_rfsh),
    .A(cpu_A),
    .DI(cpu_Din),
    .DO(cpu_Dout)
);

//------------------------------------------------------ Address Decoding ------------------------------------------------------//

// Active-low signals for memory regions
wire mem_access = ~n_mreq & n_rfsh;

// ROM: 0x0000-0x5FFF (read only)
wire cs_rom = mem_access & (cpu_A[15:14] == 2'b00) & ~cpu_A[13]; // 0x0000-0x1FFF
wire cs_rom_hi = mem_access & (cpu_A[15:13] == 3'b001);           // 0x2000-0x3FFF
wire cs_rom_top = mem_access & (cpu_A[15:13] == 3'b010);          // 0x4000-0x5FFF
wire cs_any_rom = cs_rom | cs_rom_hi | cs_rom_top;

// Video RAM: 0x8000-0xBFFF (write only from CPU perspective)
wire cs_videoram = mem_access & (cpu_A[15:14] == 2'b10);          // 0x8000-0xBFFF

// Banked blitter ROM: 0xC000-0xDFFF (read only)
wire cs_blitbank = mem_access & (cpu_A[15:13] == 3'b110);         // 0xC000-0xDFFF

// Work RAM: 0xE000-0xE3FF
wire cs_workram = mem_access & (cpu_A[15:10] == 6'b111000);       // 0xE000-0xE3FF

// DSW: 0xE400 (read, mirrored across 0xE400-0xE7FF)
wire cs_dsw = mem_access & (cpu_A[15:10] == 6'b111001);           // 0xE400-0xE7FF

// Video control: 0xE800-0xE80A (write, mirrored with 0x03F0)
wire cs_vidctrl = mem_access & (cpu_A[15:10] == 6'b111010);       // 0xE800-0xEBFF

// IN0 read / soundlatch write: 0xEC00
wire cs_in0 = mem_access & (cpu_A[15:8] == 8'hEC);

// IN1 read / coin counter write: 0xED00
wire cs_in1 = mem_access & (cpu_A[15:8] == 8'hED);

// IN2 read: 0xEE00
wire cs_in2 = mem_access & (cpu_A[15:8] == 8'hEE);

// MCU: 0xEF00 (security chip; MB8841 on original HW, returns 0 on bootleg)
wire cs_mcu = mem_access & (cpu_A[15:8] == 8'hEF);

//--------------------------------------------------------- CPU Data Mux -------------------------------------------------------//

wire [7:0] rom_D;
wire [7:0] blitbank_D;
wire [7:0] workram_D;
wire [7:0] mcu_dout;            // 0xEF00 read data (MCU R0 latch, or 0 on bootleg)

wire [7:0] cpu_Din =
    cs_any_rom     ? rom_D :
    cs_blitbank    ? blitbank_D :
    (cs_workram & ~n_rd) ? workram_D :
    cs_dsw         ? dsw0 :
    cs_in0         ? {3'b000, in0} :
    // GAMESEL-2026-06-21: pass all 8 IN1 bits (was {3'b000, in1}, which forced bits 5-7 to 0 → 2nd button dead).
    cs_in1         ? in1 :
    cs_in2         ? in2 :
    cs_mcu         ? mcu_dout :    // MB8841 R0 (original HW) or 0x00 (bootleg)
    8'hFF;

//-------------------------------------------------------- Program ROMs --------------------------------------------------------//

wire [7:0] rom0_D, rom1_D, rom2_D, rom3_D, rom4_D, rom5_D;

assign rom_D = (cpu_A[15:12] == 4'h0) ? rom0_D :
               (cpu_A[15:12] == 4'h1) ? rom1_D :
               (cpu_A[15:12] == 4'h2) ? rom2_D :
               (cpu_A[15:12] == 4'h3) ? rom3_D :
               (cpu_A[15:12] == 4'h4) ? rom4_D :
               (cpu_A[15:12] == 4'h5) ? rom5_D :
               8'hFF;

eprom_4k rom0 (.ADDR(cpu_A[11:0]), .CLK(clk_10m), .DATA(rom0_D),
               .ADDR_DL(ioctl_addr), .CLK_DL(clk_10m), .DATA_IN(ioctl_data),
               .CS_DL(rom0_cs_i), .WR(ioctl_wr));
eprom_4k rom1 (.ADDR(cpu_A[11:0]), .CLK(clk_10m), .DATA(rom1_D),
               .ADDR_DL(ioctl_addr), .CLK_DL(clk_10m), .DATA_IN(ioctl_data),
               .CS_DL(rom1_cs_i), .WR(ioctl_wr));
eprom_4k rom2 (.ADDR(cpu_A[11:0]), .CLK(clk_10m), .DATA(rom2_D),
               .ADDR_DL(ioctl_addr), .CLK_DL(clk_10m), .DATA_IN(ioctl_data),
               .CS_DL(rom2_cs_i), .WR(ioctl_wr));
eprom_4k rom3 (.ADDR(cpu_A[11:0]), .CLK(clk_10m), .DATA(rom3_D),
               .ADDR_DL(ioctl_addr), .CLK_DL(clk_10m), .DATA_IN(ioctl_data),
               .CS_DL(rom3_cs_i), .WR(ioctl_wr));
eprom_4k rom4 (.ADDR(cpu_A[11:0]), .CLK(clk_10m), .DATA(rom4_D),
               .ADDR_DL(ioctl_addr), .CLK_DL(clk_10m), .DATA_IN(ioctl_data),
               .CS_DL(rom4_cs_i), .WR(ioctl_wr));
eprom_4k rom5 (.ADDR(cpu_A[11:0]), .CLK(clk_10m), .DATA(rom5_D),
               .ADDR_DL(ioctl_addr), .CLK_DL(clk_10m), .DATA_IN(ioctl_data),
               .CS_DL(rom5_cs_i), .WR(ioctl_wr));

//------------------------------------------------------- Blitter ROMs --------------------------------------------------------//

// Blitter has 4 x 4KB ROMs, banked into 0xC000-0xDFFF via bank select (video_control[8])
// Bank 0: blit0 + blit2 (when bit 0 or 2 of bank select is 0)
// Bank 1: blit1 + blit3 (when bit 0 or 2 of bank select is set)
// MAME: m_blitbank->set_entry((data & 0x05) ? 1 : 0)
// Bank 0 maps: C000-CFFF=blit0(v0), D000-DFFF=blit2(v1)
// Bank 1 maps: C000-CFFF=blit1(v2), D000-DFFF=blit3(v3)

wire [7:0] blit0_D, blit1_D, blit2_D, blit3_D;
wire blit_bank_sel = (video_control[8] & 8'h05) != 0;  // MAME: (data & 0x05) ? 1 : 0

assign blitbank_D = cpu_A[12] ?
    (blit_bank_sel ? blit3_D : blit2_D) :
    (blit_bank_sel ? blit1_D : blit0_D);

eprom_4k blit0 (.ADDR(cpu_A[11:0]), .CLK(clk_10m), .DATA(blit0_D),
                .ADDR_DL(ioctl_addr), .CLK_DL(clk_10m), .DATA_IN(ioctl_data),
                .CS_DL(blit0_cs_i), .WR(ioctl_wr));
eprom_4k blit1 (.ADDR(cpu_A[11:0]), .CLK(clk_10m), .DATA(blit1_D),
                .ADDR_DL(ioctl_addr), .CLK_DL(clk_10m), .DATA_IN(ioctl_data),
                .CS_DL(blit1_cs_i), .WR(ioctl_wr));
eprom_4k blit2 (.ADDR(cpu_A[11:0]), .CLK(clk_10m), .DATA(blit2_D),
                .ADDR_DL(ioctl_addr), .CLK_DL(clk_10m), .DATA_IN(ioctl_data),
                .CS_DL(blit2_cs_i), .WR(ioctl_wr));
eprom_4k blit3 (.ADDR(cpu_A[11:0]), .CLK(clk_10m), .DATA(blit3_D),
                .ADDR_DL(ioctl_addr), .CLK_DL(clk_10m), .DATA_IN(ioctl_data),
                .CS_DL(blit3_cs_i), .WR(ioctl_wr));

//------------------------------------------------------------ RAM ------------------------------------------------------------//

// Work RAM (0xE000-0xE3FF, 1KB)
dpram_dc #(.widthad_a(10)) workram
(
    .clock_a(clk_10m),
    .wren_a(cs_workram & ~n_wr),
    .address_a(cpu_A[9:0]),
    .data_a(cpu_Dout),
    .q_a(workram_D),

    .clock_b(clk_10m),
    .wren_b(hs_write),
    .address_b(hs_address[9:0]),
    .data_b(hs_data_in),
    .q_b(workram_hs_q)
);

// DIAG-REVERT-2026-07-06e: repurpose 3 bytes of the existing real hiscore SAVE range (E303/E304/E305, the
// tail of the small 6-byte E300 entry -- doesn't touch E1A0-E1DB, the main 60-byte score table) for MCU
// diagnostic taps, so no MRA change is needed at all. Restore is disabled at the top level (see
// Arcade-Kangaroo.sv) so this garbage never gets written back into live workram on next boot.
//   E303 -> {7'b0, dbg_r0b1_sticky}  (has R0 bit1 EVER gone low this session)
//   E304 -> dbg_r0b1_edge_cnt        (saturating count of every R0 bit1 transition)
//   E305 -> dbg_595_cnt              (saturating count of visits to mcu_rom_addr==0x595, task 8's RSTR)
wire [7:0] workram_hs_q;
reg        dbg_r0b1_sticky   = 1'b0;
reg        dbg_r0b1_last     = 1'b1;
reg  [7:0] dbg_r0b1_edge_cnt = 8'd0;
reg  [7:0] dbg_595_cnt       = 8'd0;
// DIAG-REVERT-2026-07-06f: one step further upstream than dbg_595_cnt -- counts visits to 0x760, the
// dispatcher's OWN task-8 jump-table slot (entered via JPA, unconditional, from 70E). Distinguishes "the
// dispatcher's K-read never produces exactly 8" (this stays 0) from "task 8 IS selected but its own CALL
// $0592 or something inside it fails before ever reaching 595" (this counts but dbg_595_cnt stays 0).
reg  [7:0] dbg_760_cnt       = 8'd0;
// DIAG-REVERT-2026-07-06g: further upstream still, inside the shared 0x176 subsystem (ANY of its 10 callers,
// not task-8-specific) -- dbg_186_cnt confirms the M43-fix-driven "M[4,3]==other, open the gate" branch is
// actually being taken; dbg_1d9_cnt counts how often the sweep pointer gets reset back to its start; dbg_176
// (16-bit, NOT saturating -- this fires from 10 call sites, likely thousands of times) gives a true total
// call count so dbg_1d9_cnt/dbg_176 together show the average sweep excursion length between re-arms.
// dbg_ram41/42_do are live snapshots of the CURRENT sweep pointer (M[4,1]/M[4,2]) at save-time.
wire [3:0] dbg_ram41_do, dbg_ram42_do;
wire [3:0] dbg_mem_do, dbg_ramdo_do;   // DIAG-REVERT-2026-07-08: MCU internal readback (mem) vs live ram_do
wire [6:0] dbg_ramaddr_do;             // DIAG-REVERT-2026-07-08b: live MCU RAM address
wire [3:0] dbg_ramdi_do;               // DIAG-REVERT-2026-07-08b: live MCU RAM write data
wire       dbg_ramwe_do;               // DIAG-REVERT-2026-07-08b: live MCU RAM write-enable
reg  [7:0] dbg_186_cnt       = 8'd0;
reg  [7:0] dbg_1d9_cnt       = 8'd0;
reg [15:0] dbg_176_cnt       = 16'd0;
// DIAG-REVERT-2026-07-07-SWEEP: the decisive probe for the "is the protrom sweep pointer frozen?" question.
// MAME (kangaroo_ape.trace) lives in the dispatch loop (0x706 x130434) and NEVER exits it (0x1D9 K=0 exit
// x0), so its sweep pointer M[4,2]:M[4,1] increments every pass (0x199 ICM) and walks the whole protrom,
// hitting task-8 (K=8) 371x in 85s. Our FPGA showed the pointer parked at its 0x20 reset value in all 3
// Diagnostic 5/6/7 saves despite dbg_176_cnt=455 dispatcher passes. If ICM actually advances the pointer,
// 455 passes (>256) wrap it past 0xFF, so dbg_sweep_max would read 0xFF. If the sweep is truly frozen,
// dbg_sweep_max stays ~0x20. That single byte settles frozen-vs-walking with no further theory.
//   E1B2 dbg_sweep_min : min of {M[4,2],M[4,1]} seen (gated !=0x00 to exclude the boot-RAM-zero window)
//   E1B3 dbg_sweep_max : max of {M[4,2],M[4,1]} seen  <-- THE decisive byte (0xFF=walking, ~0x20=frozen)
//   E1B4 dbg_sweep_cur : live {M[4,2],M[4,1]} at save (combined form of the existing E1A2/E1A3 nibbles)
//   E1B5 dbg_77c_cnt   : visits to 0x77C, the K=0xF no-op dispatch slot. MAME hits this 0x. Directly tests
//                        the long-standing "stuck in the no-op spin" theory -- if 455 dispatcher passes were
//                        the no-op spin this saturates; if it's ~0 the MCU isn't spinning the no-op at all.
wire [7:0] dbg_sweep_ptr     = {dbg_ram42_do, dbg_ram41_do};
reg  [7:0] dbg_sweep_min     = 8'hFF;
reg  [7:0] dbg_sweep_max     = 8'h00;
reg  [7:0] dbg_77c_cnt       = 8'd0;
// DIAG-REVERT-2026-07-07-SWEEP: THROUGHPUT taps. Reframe: 4 task-8 hits in 455 dispatcher passes (0.88%) is
// a HIGHER rate than MAME's 371/244104 (0.15%) -- so per-pass coverage looks fine and the real divergence is
// that our MCU executes only ~455 dispatcher passes where MAME runs ~90k+/min. These two 16-bit counters say
// where the cycles actually go, in the SAME build (avoids a second compile if sweep_max confirms coverage):
//   E1B6/B7 dbg_039_cnt : timer-ISR entries (0x039). If huge vs dbg_176_cnt, the MCU is stuck servicing IRQs.
//   E1B8/B9 dbg_191_cnt : INK/debounce-loop visits (0x191). If >> dbg_176_cnt, the K-read debounce is spinning.
reg [15:0] dbg_039_cnt       = 16'd0;
reg [15:0] dbg_191_cnt       = 16'd0;
// DIAG-REVERT-2026-07-07-TRAP: Diagnostic 8 proved the foreground DIES after exactly 455 dispatcher passes
// (dbg_176_cnt frozen at 455 across Diag 5/6/7/8, identical, regardless of session length) while the timer
// ISR keeps firing at the correct rate (dbg_039_cnt=49987 = ~53s of normal 2624-instr-period IRQs). So the
// MCU foreground is TRAPPED in a tight loop that never reaches 0x176. This locates it: min/max of the
// foreground PC (mcu_rom_addr while NOT in the ISR body 0x039-0x138 nor the vector page 0x000-0x008), RESET
// on every 0x176 visit -- so after the final 0x176 (pass 455, never hit again) these accumulate ONLY the
// trapped loop's address span. dbg_last_fg is one live PC inside it as a cross-check.
//   E1BA/BB dbg_last_fg (11-bit) : last foreground PC (= a PC inside the trap loop at save)
//   E1BC/BD dbg_fg_min  (11-bit) : low bound of the trapped loop (since last 0x176)
//   E1BE/BF dbg_fg_max  (11-bit) : high bound of the trapped loop (since last 0x176)
wire        dbg_in_isr       = (mcu_rom_addr >= 11'h039 && mcu_rom_addr <= 11'h138)
                             || (mcu_rom_addr <= 11'h008);
reg  [10:0] dbg_last_fg      = 11'h000;
reg  [10:0] dbg_fg_min       = 11'h7FF;
reg  [10:0] dbg_fg_max       = 11'h000;
// DIAG-REVERT-2026-07-07-TRAP: unambiguous K=0-dispatch counter. K=0 and K=F are the ONLY dispatch values
// MAME never produces (0/244104); K=0 jumps to 0x740->0x1D9->RTS which has no valid caller in the JPL-entered
// dispatch loop = the fatal exit. 0x740 is reached ONLY by the K=0 JPA (verified: no literal ref in the ROM),
// so this counts real K=0 dispatches -- unlike dbg_1d9_cnt which the main loop (0x356/0x35D) also hits.
reg  [7:0]  dbg_740_cnt      = 8'd0;
// DIAG-REVERT-2026-07-07-KSTABLE-CHK: confirm the KSTABLE-FIX mechanism regardless of whether it works.
//   E1C1 dbg_debounce_state : bit0 = R2.0 was EVER set (=1) on a cycle executing 0x157 (the hung debounce's
//        first INK) -> proves main_data was in the K path there; bit1 = gate was open (r3_out[0]==0) at 0x157.
//   E1C2 dbg_maindata_157   : last main_data value seen while executing 0x157 (the Z80 value corrupting K).
reg  [7:0]  dbg_debounce_state = 8'd0;
reg  [7:0]  dbg_maindata_157   = 8'd0;
// DIAG-REVERT-2026-07-08: split "protrom_q oscillates" from "RAM readback corrupt" at the hung 0x157 debounce.
//   E1C3 = {K@0x159, K@0x157} -- the two consecutive K reads. Equal => K stable (readback is the bug);
//          different => protrom_q oscillates.
//   E1C4 = {ram_do, mem} sampled at 0x15A (the EOR compare). If K is stable but these two differ, the EOR is
//          comparing against a stale `mem` (registered readback) instead of the just-stored value = the hazard.
reg  [3:0]  dbg_k157   = 4'd0;
reg  [3:0]  dbg_k159   = 4'd0;
reg  [3:0]  dbg_mem_15A   = 4'd0;
reg  [3:0]  dbg_ramdo_15A = 4'd0;
// DIAG-REVERT-2026-07-08b: store vs read address/value at the hung debounce.
//   E1C5 = ST address (0x158)   E1C6 = EOR read address (0x15A)   E1C7 = {gate@157, ST value}   E1C8 = protrom_q@157
reg  [6:0]  dbg_st_addr   = 7'd0;
reg  [6:0]  dbg_eor_addr  = 7'd0;
reg  [3:0]  dbg_st_val    = 4'd0;
reg         dbg_r3_157    = 1'b0;
reg  [7:0]  dbg_protrom_157 = 8'd0;
reg         dbg_st_we     = 1'b0;   // DIAG-REVERT-2026-07-08b: was the write enabled at the ST?
// DIAG-REVERT-2026-07-08c: catch WHY M[4,3] reads 2 (page 0 -> K=0 -> dispatcher exits). Capture the value
// actually written to M[4,3]=0x43, and the protrom page (R3.1) at the K=0 dispatch (0x740).
//   E1C9 = {sticky:M[4,3] ever written !=1 (bit4), last M[4,3] write value (bits3:0)}
//   E1CA = count of M[4,3] writes that stored 2 (saturating) -- how often the "bad" value lands
//   E1CB = {page R3.1 at the K=0 dispatch 0x740 (bit0)} -- 0 confirms page-0 read caused K=0
reg  [3:0] dbg_m43_wval  = 4'hF;
reg        dbg_m43_wrong = 1'b0;
reg  [7:0] dbg_m43_2cnt  = 8'd0;
// DIAG-REVERT-2026-07-08c: measure the K=0 SOURCE at the dispatch K-read (0x191) the moment mcu_k==0 --
// the 184 K=0 exits (which MAME never takes) are the real throttle. Latch the full K formula inputs there.
//   E1CB = {page R3.1(bit2), gate R3.0(bit1), R2.0(bit0)}  -- gate/page/main_data-gate at the K=0 read
//   E1CC = main_data at the K=0 read      E1CD = protrom_q at the K=0 read
reg  [2:0] dbg_k0_gates = 3'd0;
reg  [7:0] dbg_k0_main  = 8'd0;
reg  [7:0] dbg_k0_prot  = 8'd0;
// DIAG-REVERT-2026-07-08d: is R3.1 (protrom page A8) stuck HIGH (page 1 = padding/0x00) when the real task
// table is on page 0? R3.1 is only cleared by the M[4,3]∈{2,3} branch, which ~never fires (M[4,3]≈1).
//   E1CE bit0 = R3.1 EVER 0 (page 0 reached at all); bit1 = a dispatch INK (0x191) EVER read on page 0.
//   E1CF = count of dispatch INKs read on page 0 (saturating) -- MAME would be nonzero; if ours is 0 we're pinned to page 1.
reg        dbg_r31_ever0 = 1'b0;
reg        dbg_p0_ink    = 1'b0;
reg  [7:0] dbg_p0_cnt    = 8'd0;
//------------------------------------------------------------------------------------------------------
// DIAG-REVERT-2026-07-09-RING: foreground-PC ring buffer + freeze detector.
//
// WHY: 17 single-value probes have each answered "not X" without locating WHERE the foreground dies.
// dbg_176_cnt plateaus at exactly 7856 across Diag 13/14/16/17 -- deterministic, therefore findable, the
// same way the 455-hang was cracked by finding its exact stop PC (the 0x157 debounce). Instead of another
// yes/no bit, capture the last 12 foreground instruction PCs at the moment the dispatcher stops, then walk
// that branch path and diff it against kangaroo_ape.trace at the same PC.
//
// ARMING -- the fix for the void Diagnostic 18. mcu_ena keeps ticking while the MCU is held in reset during
// ROM download, and in reset rom_addr=0 / single_byte_op='1' / r_in_irq='0', so the v1 probe (a) filled the
// ring with 12x PC 0x000 and (b) blew past its stall threshold before the MCU ever ran. Everything after was
// ignored. Nothing captures or counts now until dbg_armed, which is set by the FIRST 0x176 dispatcher pass --
// by definition the MCU is out of reset and running by then.
//
// FREEZE DETECT: dbg_stall_cnt counts mcu_ena ticks since the last 0x176 (dispatcher pass) and is cleared on
// every pass. Once armed, reaching 2^23 ticks (~3.35s at 2.5MHz) declares the foreground dead: dbg_frozen
// latches and the ring stops, preserving the last 11 PCs BEFORE the death. Everything else keeps running.
// A LONG threshold is the safe direction: the dead MCU never revives, so a late freeze costs nothing (if the
// foreground is trapped in a loop the ring just keeps refilling with that loop; if it stopped executing
// entirely the ring is preserved either way). A SHORT one risks freezing on a benign pause. 0.42s was short.
//
// ISR-BLINDNESS IS THE POINT: the timer ISR keeps firing after the foreground dies (Diag 8/17), so a naive
// ring would fill with ISR PCs. mcu_dbg_inirq (the CPU's real r_in_irq, not a PC-range heuristic) excludes
// them, and mcu_dbg_sbo keeps operand bytes of 2-byte opcodes out so the ring holds instruction PCs only.
//
// IS THE CAPTURE VALID? Read dbg_176_frz (E1DA/DB) = dbg_176_cnt latched AT the freeze. This is the check the
// v1 probe lacked: dbg_176_cnt (E1A0/A1) is never frozen, so it reads 7856 whether the freeze happened before
// or after the plateau -- it cannot tell them apart, and in Diag 18 it read a perfectly healthy 7856 while the
// ring held boot garbage. dbg_176_frz cannot lie:
//   dbg_176_frz == 7856 (== E1A0/A1)  => froze exactly at the plateau; the ring is the real death. THE GOAL.
//   dbg_176_frz <  7856              => froze early on a benign pause; ring is a wait loop. Raise threshold,
//                                       floor = dbg_max_gap*16 ticks (E1C1/C2, saturating at 0xFFFF).
//   dbg_frozen  == 0                 => never froze; the dispatcher never stalled 3.35s. Lower threshold.
//
// READING IT: E1C3 = {frozen, wrapped, in_irq@freeze, armed, write_ptr[3:0]}. Entries are E1C4..E1D9, two
// bytes each (low byte, then top 3 bits) -- same encoding as dbg_last_fg. NEWEST = index (write_ptr-1)%11.
// If wrapped=0 only indices 0..write_ptr-1 are valid. Expected outcomes:
//   - ring holds a short repeating cycle  => the foreground is trapped in a tight loop (like the 0x157 one)
//   - in_irq@freeze=1 and ring is stale   => an ISR never returned; the foreground was never rescheduled
//   - ring holds a non-repeating run      => it fell off a branch into somewhere it should never be
//------------------------------------------------------------------------------------------------------
wire        mcu_dbg_sbo;             // single_byte_op  -- rom_addr is an instruction's FIRST byte
wire        mcu_dbg_inirq;           // r_in_irq        -- inside an ISR
reg  [10:0] dbg_ring [0:10];         // last 11 foreground instruction PCs
reg  [3:0]  dbg_ring_wp   = 4'd0;    // next write index
reg         dbg_ring_wrap = 1'b0;    // ring has wrapped at least once (all 11 entries valid)
reg         dbg_frozen    = 1'b0;    // foreground declared dead; ring is preserved
reg         dbg_inirq_frz = 1'b0;    // was the MCU inside an ISR at the freeze?
reg         dbg_armed     = 1'b0;    // first 0x176 pass seen: MCU is out of reset and running
reg  [15:0] dbg_176_frz   = 16'd0;   // dbg_176_cnt latched at the freeze -- the validity check
reg  [23:0] dbg_stall_cnt = 24'd0;   // mcu_ena ticks since the last dispatcher pass (0x176)
reg  [15:0] dbg_max_gap   = 16'd0;   // largest completed 0x176->0x176 gap, in units of 16 mcu_ena ticks
always_ff @(posedge clk_10m) begin
    dbg_r0b1_last <= r0_out[1];
    if (~r0_out[1]) dbg_r0b1_sticky <= 1'b1;
    if (r0_out[1] != dbg_r0b1_last && dbg_r0b1_edge_cnt != 8'hFF)
        dbg_r0b1_edge_cnt <= dbg_r0b1_edge_cnt + 8'd1;
    if (mcu_ena && mcu_rom_addr == 11'h595 && dbg_595_cnt != 8'hFF)
        dbg_595_cnt <= dbg_595_cnt + 8'd1;
    if (mcu_ena && mcu_rom_addr == 11'h760 && dbg_760_cnt != 8'hFF)
        dbg_760_cnt <= dbg_760_cnt + 8'd1;
    if (mcu_ena && mcu_rom_addr == 11'h186 && dbg_186_cnt != 8'hFF)
        dbg_186_cnt <= dbg_186_cnt + 8'd1;
    if (mcu_ena && mcu_rom_addr == 11'h1D9 && dbg_1d9_cnt != 8'hFF)
        dbg_1d9_cnt <= dbg_1d9_cnt + 8'd1;
    if (mcu_ena && mcu_rom_addr == 11'h176 && dbg_176_cnt != 16'hFFFF)
        dbg_176_cnt <= dbg_176_cnt + 16'd1;
    // DIAG-REVERT-2026-07-07-SWEEP: sweep-pointer min/max + no-op-spin counter (see block comment above)
    if (mcu_ena) begin
        if (dbg_sweep_ptr != 8'h00 && dbg_sweep_ptr < dbg_sweep_min) dbg_sweep_min <= dbg_sweep_ptr;
        if (dbg_sweep_ptr > dbg_sweep_max) dbg_sweep_max <= dbg_sweep_ptr;
    end
    if (mcu_ena && mcu_rom_addr == 11'h77C && dbg_77c_cnt != 8'hFF)
        dbg_77c_cnt <= dbg_77c_cnt + 8'd1;
    if (mcu_ena && mcu_rom_addr == 11'h039 && dbg_039_cnt != 16'hFFFF)
        dbg_039_cnt <= dbg_039_cnt + 16'd1;
    if (mcu_ena && mcu_rom_addr == 11'h191 && dbg_191_cnt != 16'hFFFF)
        dbg_191_cnt <= dbg_191_cnt + 16'd1;
    if (mcu_ena && mcu_rom_addr == 11'h740 && dbg_740_cnt != 8'hFF)
        dbg_740_cnt <= dbg_740_cnt + 8'd1;
    // DIAG-REVERT-2026-07-08c: capture M[4,3] writes + page at K=0 dispatch
    if (dbg_ramwe_do && dbg_ramaddr_do == 7'h43) begin
        dbg_m43_wval <= dbg_ramdi_do;
        if (dbg_ramdi_do != 4'h1) dbg_m43_wrong <= 1'b1;
        if (dbg_ramdi_do == 4'h2 && dbg_m43_2cnt != 8'hFF) dbg_m43_2cnt <= dbg_m43_2cnt + 8'd1;
    end
    // DIAG-REVERT-2026-07-08c: latch K-formula inputs at the dispatch K-read when it comes out 0
    if (mcu_ena && mcu_rom_addr == 11'h191 && mcu_k == 4'h0) begin
        dbg_k0_gates <= {r3_out[1], r3_out[0], r2_out[0]};
        dbg_k0_main  <= main_data;
        dbg_k0_prot  <= protrom_q;
    end
    // DIAG-REVERT-2026-07-08d: R3.1 page-select coverage
    if (~r3_out[1]) dbg_r31_ever0 <= 1'b1;                       // R3.1 ever 0 (page 0 reachable)
    if (mcu_ena && mcu_rom_addr == 11'h191 && ~r3_out[1]) begin  // a dispatch INK on page 0
        dbg_p0_ink <= 1'b1;
        if (dbg_p0_cnt != 8'hFF) dbg_p0_cnt <= dbg_p0_cnt + 8'd1;
    end
    // DIAG-REVERT-2026-07-07-KSTABLE-CHK: sample gate/R2.0/main_data at the hung debounce (0x157)
    if (mcu_ena && mcu_rom_addr == 11'h157) begin
        if (r2_out[0])  dbg_debounce_state[0] <= 1'b1;   // R2.0 ever set here (main_data in K path)
        if (~r3_out[0]) dbg_debounce_state[1] <= 1'b1;   // protrom gate open here
        dbg_maindata_157 <= main_data;
        dbg_k157 <= mcu_k;                               // K on the 1st debounce read
        dbg_r3_157      <= r3_out[0];                    // gate state at the K read (0 = open)
        dbg_protrom_157 <= protrom_q;                    // raw protrom byte at the read address
    end
    // DIAG-REVERT-2026-07-08: 2nd read + the EOR readback
    if (mcu_ena && mcu_rom_addr == 11'h159) dbg_k159 <= mcu_k;
    if (mcu_ena && mcu_rom_addr == 11'h158) begin        // the ST cycle
        dbg_st_addr <= dbg_ramaddr_do;                   // where the store goes
        dbg_st_val  <= dbg_ramdi_do;                     // what value is stored
        dbg_st_we   <= dbg_ramwe_do;                     // is the write even enabled?
    end
    if (mcu_ena && mcu_rom_addr == 11'h15A) begin
        dbg_mem_15A   <= dbg_mem_do;     // what the EOR compares against (registered readback)
        dbg_ramdo_15A <= dbg_ramdo_do;   // the live RAM value at the same address
        dbg_eor_addr  <= dbg_ramaddr_do; // where the EOR reads
    end
    // DIAG-REVERT-2026-07-07-TRAP: foreground-PC trap locator (see block comment above)
    if (mcu_ena) begin
        if (mcu_rom_addr == 11'h176) begin
            dbg_fg_min <= 11'h7FF;
            dbg_fg_max <= 11'h000;
        end else if (!dbg_in_isr) begin
            dbg_last_fg <= mcu_rom_addr;
            if (mcu_rom_addr < dbg_fg_min) dbg_fg_min <= mcu_rom_addr;
            if (mcu_rom_addr > dbg_fg_max) dbg_fg_max <= mcu_rom_addr;
        end
    end
    // DIAG-REVERT-2026-07-09-RING: freeze detector + foreground-PC ring (see block comment above)
    if (mcu_ena && !dbg_frozen) begin
        if (mcu_rom_addr == 11'h176) begin
            dbg_armed <= 1'b1;                 // MCU is out of reset and dispatching: arm everything
            if (dbg_armed) begin               // skip the first pass: its "gap" is the whole boot
                if (|dbg_stall_cnt[23:20])                     dbg_max_gap <= 16'hFFFF;
                else if (dbg_stall_cnt[19:4] > dbg_max_gap)    dbg_max_gap <= dbg_stall_cnt[19:4];
            end
            dbg_stall_cnt <= 24'd0;
        end else if (dbg_armed) begin
            dbg_stall_cnt <= dbg_stall_cnt + 24'd1;
            // 2^23 mcu_ena ticks with no dispatcher pass => foreground is dead. Latch and stop the ring.
            if (dbg_stall_cnt == 24'h800000) begin
                dbg_frozen    <= 1'b1;
                dbg_inirq_frz <= mcu_dbg_inirq;
                dbg_176_frz   <= dbg_176_cnt;  // == 7856 proves we froze AT the plateau, not before it
            end
        end
        // capture foreground instruction PCs only: first byte of an instruction, outside any ISR
        if (dbg_armed && mcu_dbg_sbo && !mcu_dbg_inirq) begin
            dbg_ring[dbg_ring_wp] <= mcu_rom_addr;
            if (dbg_ring_wp == 4'd10) begin
                dbg_ring_wp   <= 4'd0;
                dbg_ring_wrap <= 1'b1;
            end else begin
                dbg_ring_wp   <= dbg_ring_wp + 4'd1;
            end
        end
    end
end
// DIAG-REVERT-2026-07-06h: E162/E118/E0CD are real Z80 workram cells OUTSIDE both configured hiscore
// ranges, so they can't be read via hs_address directly -- snoop the CPU's own writes to those specific
// addresses instead and latch the last value written (equivalent to "current contents", since writes are
// the only thing that ever changes workram). Checks the Z80-side gates directly on THIS build/session,
// rather than assuming the 2026-07-02 proof (a different build) still holds:
//   E162 = survival-clock gate (0x3534: CP $10; RET C -- needs >=0x10 to even reach the R0 check)
//   E118 = ape-active flag (0x352F: AND A; RET NZ -- must be 0, i.e. no ape already active, to proceed)
//   E0CD = an EARLIER gate (0x3526: AND 3; CP 3; RET Z -- bails before E118/E162/R0 are ever looked at)
//   dbg_r0_raw/mcu_present_snap = raw r0_out nibble + mcu_present, cross-checking the sticky/edge-count
//   taps against a direct snapshot, and ruling out mcu_present being wrong (which would force mcu_dout to
//   a hardcoded 0x00 regardless of r0_out -- bit1 would still read low either way, but worth eliminating).
reg [7:0] dbg_e162_snap = 8'd0;
reg [7:0] dbg_e118_snap = 8'd0;
reg [7:0] dbg_e0cd_snap = 8'd0;
// DIAG-REVERT-2026-07-06i: E017 is the very FIRST thing 0x351C checks (0x3520: RET NZ if E017!=0) --
// confirmed via kangaroo_cpu.dasm that entry itself is unconditional, called every frame from a straight-
// line dispatch table at 0x0482-0x04E2, no gating above it either. If E017 is stuck nonzero, NOTHING past
// this point (E0CD/E118/E162/R0, all already confirmed passing) ever gets checked at all.
// dbg_e118_ever_nz / dbg_e119_last_nz: a DIFFERENT hypothesis than anything checked so far -- what if the
// trigger logic actually DOES fire (writes real spawn data to E118/E119 at 0x3574-357B) but the ape sprite
// just never gets rendered, a completely separate bug from the trigger chain we've been chasing all day?
// Sticky-latches the first time E118 is EVER written nonzero, and the last nonzero value written to E119
// (the tier byte -- real spawns use 0x14/0x48/0x7C per the tier-selection logic, so a nonzero here that
// isn't one of those would itself be informative).
reg [7:0] dbg_e017_snap    = 8'd0;
reg       dbg_e118_ever_nz = 1'b0;
reg [7:0] dbg_e119_last_nz = 8'd0;
// DIAG-REVERT-2026-07-06j: every check so far (E017/E0CD/E118/E162/R0) only reads VALUES -- none of them
// actually confirm the Z80's PC ever executes 0x351C at all on this build. Counts real opcode-fetch (M1)
// cycles at that address directly, mirroring the same address-visit-counter approach already used on the
// MCU side. Edge-detects the M1 strobe (n_m1 falling) rather than gating on a clock enable, since n_m1 can
// stay low across multiple clk_10m cycles for one fetch and a level-gated count would over-count the same
// instruction repeatedly.
reg       dbg_n_m1_prev  = 1'b1;
reg [7:0] dbg_351c_cnt   = 8'd0;
// DIAG-REVERT-2026-07-06k: the user's direct challenge -- every gate value in the -06h/-06i snapshots
// checks out (E017==0, E0CD&3!=3, E118==0, E162>=0x10, R0 bit1==0), 351c_cnt proves the Z80 hits the
// entry point thousands of times, yet dbg_e118_ever_nz stays 0 (spawn-write code never runs). That means
// the gates are individually TRUE AT SOME POINT but maybe never all true on the SAME poll. Snapshotting
// values can't distinguish "gate always passes" from "gate passes sometimes, just never every gate at
// once" -- only counting how many times execution actually REACHES each successive checkpoint can. Six
// counters, one per gate boundary in kangaroo_cpu.dasm, each landing on the first opcode byte immediately
// after the preceding RET/branch was NOT taken:
//   3526 = survived 351C's "RET NZ if E017!=0" (E017 gate passed)
//   352E = survived 3526-352D's "RET Z if (E0CD&3)==3" (E0CD gate passed)
//   3534 = survived 352F-3533's "RET NZ if E118!=0" (E118/ape-active gate passed)
//   353A = survived 3534-3539's "RET C if E162<0x10" (survival-clock gate passed)
//   3541 = survived 353A-353F's "JR NZ,$358C if R0 bit1==1" (R0 bit1==0 confirmed, on the live poll)
//   3546 = survived 3541-3545's "RET NZ if E039!=0" (E039 latch gate passed -- actual spawn sequence starts here)
// If dbg_3546_cnt is ever nonzero, the spawn sequence DOES run and the bug is further downstream (past
// 3546, before the E118 write) -- a different bug than "gates never align." If dbg_3546_cnt stays 0 while
// an earlier counter (e.g. 3541) is nonzero, that pinpoints the exact gate that never passes concurrently
// with all the others.
reg [7:0] dbg_3526_cnt = 8'd0;
reg [7:0] dbg_352e_cnt = 8'd0;
reg [7:0] dbg_3534_cnt = 8'd0;
reg [7:0] dbg_353a_cnt = 8'd0;
reg [7:0] dbg_3541_cnt = 8'd0;
reg [7:0] dbg_3546_cnt = 8'd0;
always_ff @(posedge clk_10m) begin
    if (cs_workram & ~n_wr) begin
        if (cpu_A[9:0] == 10'h162) dbg_e162_snap <= cpu_Dout;
        if (cpu_A[9:0] == 10'h118) dbg_e118_snap <= cpu_Dout;
        if (cpu_A[9:0] == 10'h0CD) dbg_e0cd_snap <= cpu_Dout;
        if (cpu_A[9:0] == 10'h017) dbg_e017_snap <= cpu_Dout;
        if (cpu_A[9:0] == 10'h118 && cpu_Dout != 8'h00) dbg_e118_ever_nz <= 1'b1;
        if (cpu_A[9:0] == 10'h119 && cpu_Dout != 8'h00) dbg_e119_last_nz <= cpu_Dout;
    end
    dbg_n_m1_prev <= n_m1;
    if (dbg_n_m1_prev & ~n_m1 & (cpu_A == 16'h351C) && dbg_351c_cnt != 8'hFF)
        dbg_351c_cnt <= dbg_351c_cnt + 8'd1;
    if (dbg_n_m1_prev & ~n_m1 & (cpu_A == 16'h3526) && dbg_3526_cnt != 8'hFF)
        dbg_3526_cnt <= dbg_3526_cnt + 8'd1;
    if (dbg_n_m1_prev & ~n_m1 & (cpu_A == 16'h352E) && dbg_352e_cnt != 8'hFF)
        dbg_352e_cnt <= dbg_352e_cnt + 8'd1;
    if (dbg_n_m1_prev & ~n_m1 & (cpu_A == 16'h3534) && dbg_3534_cnt != 8'hFF)
        dbg_3534_cnt <= dbg_3534_cnt + 8'd1;
    if (dbg_n_m1_prev & ~n_m1 & (cpu_A == 16'h353A) && dbg_353a_cnt != 8'hFF)
        dbg_353a_cnt <= dbg_353a_cnt + 8'd1;
    if (dbg_n_m1_prev & ~n_m1 & (cpu_A == 16'h3541) && dbg_3541_cnt != 8'hFF)
        dbg_3541_cnt <= dbg_3541_cnt + 8'd1;
    if (dbg_n_m1_prev & ~n_m1 & (cpu_A == 16'h3546) && dbg_3546_cnt != 8'hFF)
        dbg_3546_cnt <= dbg_3546_cnt + 8'd1;
end
// DIAG-REVERT-2026-07-09-RING: decode the 22-byte ring window E1C4..E1D9 into {entry, lo/hi byte}.
// hs_address[4:0] runs 0x04..0x19 across that window, so offset = hs_address[4:0]-4 = 0..21,
// entry = offset[4:1] = 0..10, and offset[0] picks low byte (0) vs top-3-bits byte (1).
// DIAG-REVERT-2026-07-09-RING: ring decode retired (the ring did its job -- it caught the return-storm).
// The capture logic above still runs but nothing reads dbg_ring, so Quartus strips it. Uncomment these
// four lines and restore the mux entry below to bring the ring back.
// wire        hs_ring_sel  = (hs_address >= 16'hE1C4) && (hs_address <= 16'hE1D9);
// wire [4:0]  hs_ring_off  = hs_address[4:0] - 5'd4;
// wire [10:0] hs_ring_pc   = dbg_ring[hs_ring_off[4:1]];
// wire [7:0]  hs_ring_byte = hs_ring_off[0] ? {5'b0, hs_ring_pc[10:8]} : hs_ring_pc[7:0];

//------------------------------------------------------------------------------------------------------
// DIAG-REVERT-2026-07-09-RELOAD: capture the protrom address-chain RELOAD triples.
//
// WHAT THE PROTOCOL ACTUALLY IS (there is no "sweep pointer"): `0x139` reads a 16-byte protrom block into
// M[7,*]; then `0x45B-0x468` copies M[7,src..src+2] -> M[4,1] (addr lo), M[4,2] (addr hi), M[4,3] (MODE),
// one nibble per visit to `0x463 ST`. src=5, so next base = {nib[base+6], nib[base+5]}, mode = nib[base+7].
// Verified against the ROM: base 0x30 -> O=0xA5 mode=1, base 0xA5 -> O=0x30 mode=1. A clean 2-cycle.
// Shift src by one either way and the orbit collapses to 0x00 within ~6 links -- the protection is designed
// to be fragile, so "our chain diverges" is nearly content-free. The MODE is the informative byte.
//
// WHY THIS PROBE: MAME's mode is 1 on all 11,535 reloads (`0x41.trace`), and the `M[4,3]==2` branch arm at
// `0x185` is taken 0 / 244,104 times. Ours: `dbg_77c_cnt` (K=0xF dispatch) SATURATES while `dbg_740_cnt`
// (K=0) is 0. That combination cannot come from reading protrom data -- there are 35 zero-nibbles vs only
// 11 F-nibbles, so a roaming pointer would produce ~3x more K=0 than K=0xF. K=0xF must therefore come from
// the GATE BEING CLOSED, and the only arm that leaves R3.0 set is `M[4,3]==2`. Conclusion to test:
// **our reload writes 2 into M[4,3].**
//
// REFERENCE (first 8 reloads, O then mode): (A5,1) (E0,1) (BC,1) (C2,1) (30,1) (A5,1) (30,1) (A5,1)
//   reload #1 wrong  => divergence is already in the boot 0x139 block (O starts at 0x00)
//   #1 right, #N wrong => divergence at link N; the base is the previous reload's output, so the delta
//                         between our O and the reference O says exactly how far off the chain we are
//   all 8 right, mode always 1 => the chain is fine and the ape bug is downstream (task dispatch / R0)
//
// dbg_463_seen = 0 would mean the reload never executes at all -- a different failure entirely.
//------------------------------------------------------------------------------------------------------
reg  [3:0]  dbg_rl_lo      = 4'd0;    // M[4,1] of the reload in progress
reg  [3:0]  dbg_rl_hi      = 4'd0;    // M[4,2] of the reload in progress
reg  [7:0]  dbg_rl_o    [0:7];        // O = {M[4,2],M[4,1]} of the first 8 reloads
reg  [3:0]  dbg_rl_mode [0:7];        // M[4,3] (mode) of the first 8 reloads
reg  [15:0] dbg_rl_cnt     = 16'd0;   // total reloads (saturating)
reg  [7:0]  dbg_rl_badcnt  = 8'd0;    // reloads whose mode != 1 (saturating)
reg  [7:0]  dbg_rl_m2cnt   = 8'd0;    // reloads whose mode == 2 (saturating) -- the gate-closed arm
reg  [3:0]  dbg_rl_lastbad = 4'd0;    // last mode value seen that was not 1
reg         dbg_rl_sticky  = 1'b0;    // a mode != 1 was ever written
reg         dbg_463_seen   = 1'b0;    // 0x463 executed at all

always_ff @(posedge clk_10m) begin
    // ram_we/ram_addr/ram_di are combinational on the executing opcode, so they are valid in the same
    // mcu_ena cycle that mcu_rom_addr == 0x463 (the ST). Y runs 1,2,3 across three loop iterations.
    if (mcu_ena && dbg_ramwe_do && mcu_rom_addr == 11'h463) begin
        dbg_463_seen <= 1'b1;
        case (dbg_ramaddr_do)
            7'h41: dbg_rl_lo <= dbg_ramdi_do;
            7'h42: dbg_rl_hi <= dbg_ramdi_do;
            7'h43: begin                                       // mode written last => triple complete
                if (dbg_rl_cnt < 16'd8) begin
                    dbg_rl_o   [dbg_rl_cnt[2:0]] <= {dbg_rl_hi, dbg_rl_lo};
                    dbg_rl_mode[dbg_rl_cnt[2:0]] <= dbg_ramdi_do;
                end
                if (dbg_rl_cnt != 16'hFFFF) dbg_rl_cnt <= dbg_rl_cnt + 16'd1;
                if (dbg_ramdi_do != 4'd1) begin
                    dbg_rl_sticky  <= 1'b1;
                    dbg_rl_lastbad <= dbg_ramdi_do;
                    if (dbg_rl_badcnt != 8'hFF) dbg_rl_badcnt <= dbg_rl_badcnt + 8'd1;
                end
                if (dbg_ramdi_do == 4'd2 && dbg_rl_m2cnt != 8'hFF) dbg_rl_m2cnt <= dbg_rl_m2cnt + 8'd1;
            end
            default: ;
        endcase
    end
end

// DIAG-REVERT-2026-07-09-RELOAD: decode the E1C4..E1D9 window (hs_address[4:0] runs 0x04..0x19, so off=0..21)
//   +0..+7  O of reloads 1..8      +8..+15  mode of reloads 1..8      +16/+17  total reload count (16-bit)
//   +18     count of mode != 1     +19      count of mode == 2        +20  {sticky_bad,3'b0,last_bad_mode}
//   +21     {7'b0, 0x463 ever executed}
wire        hs_rl_sel  = (hs_address >= 16'hE1C4) && (hs_address <= 16'hE1D9);
wire [4:0]  hs_rl_off  = hs_address[4:0] - 5'd4;
//------------------------------------------------------------------------------------------------------
// DIAG-REVERT-2026-07-09-KHIST: K histogram at the dispatcher's INK + gate-vs-data split on K=0xF.
//
// RELOAD probe (above) is retired -- it ANSWERED its question: our reload chain is correct (first 8 triples
// exactly match MAME's A5/E0/BC/C2/30/A5/30/A5, mode 1 on 627 of 630 reloads). Its regs stay driven but
// unread, so Quartus strips them. Result recorded in the vault; do not re-run it.
//
// WHY THIS: every timer interrupt CLOSES the protrom gate -- `0x03D: LYI #$C; 0x03E: SETR` sets R3.0 on ISR
// entry so the ISR can do its own 8 K-reads (it strobes R1.0-3 and R2.0-3; Y=8 is R2.0, the bit that gates
// the Z80's main_data into K -- the timer ISR *is* the Z80->MCU data channel). It reopens the gate on the
// way out at `0x054-0x065`, but ONLY if `TBIT 0` of `M[4,7]` says a protrom transaction was in flight (that
// flag is SBIT-set at 0x178/0x13C and RBIT-cleared at 0x19E/0x16C). MAME runs that restore on 5,746 of
// 9,077 interrupts.
//
// If the gate is ever left CLOSED when the foreground's INK at 0x191 fires, then
//     K = 0xF & (R2.0 ? main_data : 0xF) & (~R3.0 ? protrom_q : 0xF)  ==  0xF
// -- it can NEVER read 0. That is exactly our signature: dbg_77c_cnt (K=0xF) saturated, dbg_740_cnt (K=0)
// exactly 0, even though the protrom has 35 zero-nibbles vs only 11 F-nibbles.
//
// MAME's K distribution (counted from task-slot addresses 0x740+4K in kangaroo_ape.trace, 130,434 total):
//   K=0:0  1:45899  2:9896  3:5266  4:793  5:1468  6:9239  7:1099
//   K=8:371 (THE APE)  9:6  A:6  B:734  C:5311  D:1522  E:48824  F:0
// 8-bit saturating bins are the right instrument: the big bins (1,E,2,6,C,3) will peg at 255 and we don't
// care, while the rare ones -- especially K=8 -- stay in range and are exactly what we need to compare.
//
// DECISIVE BYTE: `dbg_kf_gateclosed` (E1D9) = how many of the K=0xF reads had R3.0 == 1.
//   ~= the K=0xF count  => the GATE is being left closed by the ISR. Fix is in the ISR gate handshake.
//   == 0                => we really are reading F-nibble protrom bytes; `dbg_kf_o_first` says where.
//------------------------------------------------------------------------------------------------------
reg  [7:0]  dbg_khist [0:15];         // K value seen at 0x191, saturating
reg  [2:0]  dbg_kf_gates_first = 3'd0;  // {R3.1, R3.0, R2.0} at the FIRST K=0xF
reg  [7:0]  dbg_kf_main_first  = 8'd0;  // main_data at the first K=0xF
reg  [7:0]  dbg_kf_prot_first  = 8'd0;  // protrom_q at the first K=0xF
reg  [7:0]  dbg_kf_o_first     = 8'd0;  // O = {mcu_oh,mcu_ol} at the first K=0xF -- WHERE we were
reg  [2:0]  dbg_kf_gates_last  = 3'd0;  // same gates at the LAST K=0xF (does it vary?)
reg  [7:0]  dbg_kf_gateclosed  = 8'd0;  // count of K=0xF reads with R3.0==1 (saturating) -- THE ANSWER
reg         dbg_kf_seen        = 1'b0;

integer khi;
initial for (khi = 0; khi < 16; khi = khi + 1) dbg_khist[khi] = 8'd0;

//------------------------------------------------------------------------------------------------------
// DIAG-REVERT-2026-07-10-M43W: who writes ram[0x43] (= M[4,3], the MODE byte), and is the bad reload's
// BASE valid?  This decides whether "just force mode=1" is a legitimate fix or a repeat of MCU-M43-FIX.
//
// GROUND TRUTH (user's `0x41.trace`, MAME, boot -> start of game): ram[0x43] is written by exactly THREE
// PCs -- 0x016 (boot RAM clear), 0x01F (boot M[4,3]=1), 0x463 (the reload) -- and the reload writes 1 on
// all 11,535 of its executions. MAME's mode-2 arm (0x185) is taken 0 / 244,104 times.
//
// Our Diag 21: 3 of 630 reloads wrote mode != 1 (one of them 2). Diag 22: gate found CLOSED on >=255 K=0xF
// reads, last-sample gates {R3.1=0, R3.0=1} = the exact signature of the 0x185 mode-2 arm (0x185 -> 0x180
// clears R3.1 only; R3.0 is never cleared). Once mode==2 sticks, 0x186 (the only unconditional gate-open)
// never runs, INK returns 0xF forever, JPA lands on 0x77C = JPL $0706, no handler dispatches, and the
// reload -- the ONLY runtime writer of M[4,3] -- is unreachable. A one-way trap. MAME never enters it.
//
// THE DECIDING QUESTION: on the bad reload, was O = {M[4,2],M[4,1]} a VALID base (5C/6A/7A/84/30/A5)?
//   valid base + wrong mode only  => the mode nibble alone is corrupt; forcing M[4,3]=1 is a REAL fix.
//   garbage base                  => the whole 3-nibble read is corrupt; forcing the mode just reopens the
//                                    gate onto a garbage base -> K=0 -> 0x740 -> 0x1D9's unbalanced RTS,
//                                    i.e. straight back into the trap we escaped. Chase the block read.
//   a 4th writer PC appears       => that instruction is the bug; there is nothing to force.
//
// Captures the first 6 writes to ram[0x43] (PC + value) and the first bad reload's full triple.
//------------------------------------------------------------------------------------------------------
reg  [10:0] dbg_m43_pc   [0:5];       // mcu_rom_addr of the first 6 writes to ram[0x43]
reg  [3:0]  dbg_m43_val  [0:5];       // value written
reg  [2:0]  dbg_m43_wcnt = 3'd0;      // how many captured (0..6)
reg  [7:0]  dbg_m43_tot  = 8'd0;      // total writes to ram[0x43] (saturating)
reg  [7:0]  dbg_bad_o    = 8'd0;      // O of the FIRST reload whose mode != 1   <-- THE ANSWER
reg  [3:0]  dbg_bad_mode = 4'd0;      // that reload's mode value
reg  [7:0]  dbg_bad_idx  = 8'd0;      // which reload number it was (saturating)
reg         dbg_bad_seen = 1'b0;

integer m43i;
initial for (m43i = 0; m43i < 6; m43i = m43i + 1) begin
    dbg_m43_pc[m43i]  = 11'd0;
    dbg_m43_val[m43i] = 4'd0;
end

always_ff @(posedge clk_10m) begin
    if (mcu_ena && dbg_ramwe_do && dbg_ramaddr_do == 7'h43) begin
        if (dbg_m43_wcnt < 3'd6) begin
            dbg_m43_pc [dbg_m43_wcnt] <= mcu_rom_addr;
            dbg_m43_val[dbg_m43_wcnt] <= dbg_ramdi_do;
            dbg_m43_wcnt <= dbg_m43_wcnt + 3'd1;
        end
        if (dbg_m43_tot != 8'hFF) dbg_m43_tot <= dbg_m43_tot + 8'd1;
        // first reload (0x463) that stores a mode != 1: latch the base it came with.
        // dbg_rl_lo/hi were loaded by this same reload's earlier two ST's (Y=1 then Y=2).
        if (!dbg_bad_seen && mcu_rom_addr == 11'h463 && dbg_ramdi_do != 4'd1) begin
            dbg_bad_seen <= 1'b1;
            dbg_bad_o    <= {dbg_rl_hi, dbg_rl_lo};
            dbg_bad_mode <= dbg_ramdi_do;
            dbg_bad_idx  <= dbg_rl_cnt[7:0];
            // DIAG-REVERT-2026-07-10-M7BUF: snapshot the whole source buffer at the moment it goes wrong.
            dbg_m7_bad   <= dbg_m7_do;
        end
    end
    // DIAG-REVERT-2026-07-10-M7BUF: also snapshot M[7,*] on the LAST GOOD reload, so we can diff a known-good
    // block against the corrupt one. Overwritten every good reload; frozen once dbg_bad_seen latches.
    if (mcu_ena && dbg_ramwe_do && dbg_ramaddr_do == 7'h43 && mcu_rom_addr == 11'h463
        && dbg_ramdi_do == 4'd1 && !dbg_bad_seen)
        dbg_m7_good <= dbg_m7_do;
end

//------------------------------------------------------------------------------------------------------
// DIAG-REVERT-2026-07-10-M7BUF: what is IN the source buffer when the reload goes bad?
//
// Diag 23: reloads 1..161 correct; #162 reads base O=0x45 (not on the orbit 5C/6A/7A/84/30/A5) and mode 0.
// ram[0x43]'s writer list is now exactly MAME's (015 / 01E / 463) -- so nothing corrupts M[4,3] directly.
// The reload at 0x45B-0x468 only ever copies M[7,src..src+2] into M[4,1..3]. Therefore the corruption is
// in M[7,*], the buffer that 0x139's INK/ST loop fills with protrom nibbles.
//
// The user's framing, which is the right one: "even if alignment is correct overall, the devil is in the
// details -- if one or two instructions are misaligned in execution but 'correct in the end', incorrect
// data still enters the stream along the way." Every K input has now been shown stable at the ena edge
// (protrom_q registered, mcu_o registered, R2.0/R3.0 registered; only main_data is async and it is masked
// whenever R2.0=0, which Diag 10 measured at this very instruction). So construction says it cannot glitch.
// Measure the buffer instead of trusting construction.
//
// THREE OUTCOMES, each pointing somewhere different:
//   (a) SHIFTED  -- good block, rotated by 1-2 nibbles => the 0x139 loop ran one iteration too many/few.
//                   Look at 0x15D ICY / 0x165 XD 2 / AI #$F loop counter and the debounce exit.
//   (b) STALE    -- the previous block's bytes still present => the loop exited early; some ST never fired.
//   (c) GARBAGE  -- unrelated values => the ST's landed at wrong addresses (X or Y wrong), or K was wrong.
// Diff dbg_m7_bad against dbg_m7_good (the last correct reload's buffer) and against the protrom itself.
//------------------------------------------------------------------------------------------------------
wire [63:0] dbg_m7_do;
reg  [63:0] dbg_m7_bad  = 64'd0;   // M[7,0..F] at the first bad reload
reg  [63:0] dbg_m7_good = 64'd0;   // M[7,0..F] at the last good reload before it

//------------------------------------------------------------------------------------------------------
// DIAG-REVERT-2026-07-10-SRCY: catch the corruption of Y.
//
// Diag 24 + ROM read established this, and it is NOT a loop over-run:
//   `0x45B: XYD 7` parks the CALLER's Y into M[0,7]; `0x45D` reads it back as `src`. So src = caller's Y.
//   All 8 CALL $045B sites do an LYI immediately before: 0x2FD #$0, 0x478 #$8, 0x4BE #$1, 0x5BA #$0,
//   0x5CE #$0, 0x6B4 #$4, 0x6E6 #$1, 0x734 #$1.  ==> legal src is exactly {0, 1, 4, 8}.
//   Diag 24's bad reload read src = 3.  ***No caller can produce 3.  Y was corrupted.***
//
// Y is saved/restored by the timer ISR through bank-0 cell 4:
//   save    0x039: XD 0 ; 0x03A: XYD 4 ; 0x03B: XX ; 0x03C: XD 1
//   restore 0x134: XD 1 ; 0x135: XX   ; 0x136: XYD 4 ; 0x137: XD 0   (exact mirror; each op an involution)
// The 0x139 read loop parks its byte-counter in bank-0 cell 2 and its buffer index in cell 7 -- no overlap
// with the ISR's cells 0/1/4 -- so the ROM's design is sound and the corruption must be ours.
//
// HOW WE READ Y WITHOUT A NEW PORT: at `0x45F: L`, ram_addr = {X=7, Y} = 0x70+src, so dbg_ramaddr_do[3:0]
// IS src. Latch it on the first 0x45F after each 0x45B (group start).
//
// DECODE:
//   dbg_src_bad != {0,1,4,8}                     => confirms Y corruption (expect 3)
//   dbg_isr_in_reload = 1                        => an interrupt was accepted inside 0x455-0x468
//   dbg_isr_in_139    = 1                        => ... inside the 0x139-0x169 read loop
//   dbg_illegal_cnt vs dbg_isr_in_* correlation  => the ISR save/restore is the culprit
//   all srcs legal + illegal_cnt = 0             => Y is fine and the bad triple came from the BUFFER,
//                                                   i.e. 0x139 wrote the wrong bytes. Different bug.
//------------------------------------------------------------------------------------------------------
reg  [3:0] dbg_src   [0:7];        // src of the first 8 reload groups
reg  [3:0] dbg_srcn      = 4'd0;   // how many captured (needs 4 bits to reach 8 without wrapping)
reg        dbg_src_arm   = 1'b0;   // saw 0x45B, waiting for 0x45F
reg  [3:0] dbg_src_bad   = 4'hF;   // src of the first reload whose mode != 1
reg  [7:0] dbg_illegal_cnt = 8'd0; // reload groups whose src is not in {0,1,4,8}
reg        dbg_isr_in_reload = 1'b0;
reg        dbg_isr_in_139    = 1'b0;
reg  [7:0] dbg_isr_139_cnt   = 8'd0;
reg        dbg_inirq_last    = 1'b0;

integer si;
initial for (si = 0; si < 8; si = si + 1) dbg_src[si] = 4'd0;

always_ff @(posedge clk_10m) begin
    if (mcu_ena) begin
        dbg_inirq_last <= mcu_dbg_inirq;
        // interrupt ACCEPTED = rising edge of the CPU's own r_in_irq
        if (mcu_dbg_inirq && !dbg_inirq_last) begin
            if (mcu_rom_addr >= 11'h455 && mcu_rom_addr <= 11'h468) dbg_isr_in_reload <= 1'b1;
            if (mcu_rom_addr >= 11'h139 && mcu_rom_addr <= 11'h169) begin
                dbg_isr_in_139 <= 1'b1;
                if (dbg_isr_139_cnt != 8'hFF) dbg_isr_139_cnt <= dbg_isr_139_cnt + 8'd1;
            end
        end
        if (mcu_rom_addr == 11'h45B) dbg_src_arm <= 1'b1;           // group start
        if (mcu_rom_addr == 11'h45F && dbg_src_arm) begin           // first L of the group: addr = 0x70+src
            dbg_src_arm <= 1'b0;
            if (dbg_srcn < 4'd8) begin
                dbg_src[dbg_srcn[2:0]] <= dbg_ramaddr_do[3:0];
                dbg_srcn <= dbg_srcn + 4'd1;
            end
            if (!(dbg_ramaddr_do[3:0] == 4'd0 || dbg_ramaddr_do[3:0] == 4'd1 ||
                  dbg_ramaddr_do[3:0] == 4'd4 || dbg_ramaddr_do[3:0] == 4'd8))
                if (dbg_illegal_cnt != 8'hFF) dbg_illegal_cnt <= dbg_illegal_cnt + 8'd1;
            if (!dbg_bad_seen) dbg_src_bad <= dbg_ramaddr_do[3:0];  // holds the last src before the bad one
        end
    end
end

always_ff @(posedge clk_10m) begin
    if (mcu_ena && mcu_rom_addr == 11'h191) begin      // the dispatcher's K read (0x176's INK)
        if (dbg_khist[mcu_k] != 8'hFF) dbg_khist[mcu_k] <= dbg_khist[mcu_k] + 8'd1;
        if (mcu_k == 4'hF) begin
            if (!dbg_kf_seen) begin
                dbg_kf_seen        <= 1'b1;
                dbg_kf_gates_first <= {r3_out[1], r3_out[0], r2_out[0]};
                dbg_kf_main_first  <= main_data;
                dbg_kf_prot_first  <= protrom_q;
                dbg_kf_o_first     <= mcu_o;
            end
            dbg_kf_gates_last <= {r3_out[1], r3_out[0], r2_out[0]};
            if (r3_out[0] && dbg_kf_gateclosed != 8'hFF) dbg_kf_gateclosed <= dbg_kf_gateclosed + 8'd1;
        end
    end
end

// DIAG-REVERT-2026-07-10-M43W window. The KHIST bins are kept for K=0/K=8/K=F only -- the 3 that matter
// (MAME: 0, 371, 0) -- freeing 13 bytes for the writer log. Full 16-bin histogram retired (Diag 22 captured
// it; the big bins just saturate). Layout of E1C4..E1DB (hs_rl_off 0..23):
//    0  K=0 bin        1  K=8 bin        2  K=F bin        3  gate-closed count (>=255 in Diag 22)
//    4  total writes to ram[0x43]        5  {5'b0, bad_seen, bad_mode[3:0]} -- packed below
//    6  bad reload's O   <-- THE ANSWER (valid base 5C/6A/7A/84/30/A5, or garbage?)
//    7  bad reload's index
// DIAG-REVERT-2026-07-10-M7BUF layout of E1C4..E1D9 (hs_rl_off 0..21). The M43W writer log is retired --
// it answered its question (writers = 015/01E/463, exactly MAME's; no 4th writer). Both buffers fit:
//    0..7    dbg_m7_bad  : M[7,0..F] at the first BAD reload, 2 nibbles per byte {M[7,2k+1], M[7,2k]}
//    8..15   dbg_m7_good : M[7,0..F] at the last GOOD reload before it, same packing
//   16  bad reload's O (Diag 23 = 0x45)   17  {3'b0, bad_seen, bad_mode}   18  bad reload index
//   19  K=8 bin   20  K=0xF bin   21  gate-closed count
// (E1DA/DB stay dbg_176_frz; E1A0/A1 stay dbg_176_cnt)
// Byte k of a buffer = {M[7,2k+1], M[7,2k]} = bits [8k+7 : 8k] -- i.e. just a byte-lane select.
// Expressed as a right-shift + truncate, which Quartus 17 handles cleanly (no variable part-select).
wire [63:0] hs_m7_src  = dbg_m7_bad;
wire [7:0]  hs_m7_byte = hs_m7_src >> {hs_rl_off[2:0], 3'b000};
// DIAG-REVERT-2026-07-10-SRCY layout of E1C4..E1D9 (off 0..21). The GOOD buffer is retired -- Diag 24
// captured it (1 5 A 1 ...) and it is not going to change.
//    0..7   dbg_m7_bad : M[7,0..F] at the first bad reload, 2 nibbles/byte
//    8..11  src of reload groups 1..8, 2 per byte    (legal src = 0,1,4,8)
//   12  dbg_src_bad (src of the bad reload; Diag 24 implies 3)   13  count of ILLEGAL srcs
//   14  {6'b0, isr_in_reload, isr_in_139}            15  count of ISRs accepted inside 0x139-0x169
//   16  bad reload's O   17  {3'b0, bad_seen, bad_mode}   18  bad reload index
//   19  K=8 bin   20  K=0xF bin   21  gate-closed count
wire [7:0]  hs_rl_byte = (hs_rl_off <  5'd8 ) ? hs_m7_byte                           :
                         (hs_rl_off <  5'd12) ? {dbg_src[{hs_rl_off[1:0], 1'b1}],
                                                 dbg_src[{hs_rl_off[1:0], 1'b0}]}    :
                         (hs_rl_off == 5'd12) ? {4'b0, dbg_src_bad}                  :
                         (hs_rl_off == 5'd13) ? dbg_illegal_cnt                      :
                         (hs_rl_off == 5'd14) ? {6'b0, dbg_isr_in_reload, dbg_isr_in_139} :
                         (hs_rl_off == 5'd15) ? dbg_isr_139_cnt                      :
                         (hs_rl_off == 5'd16) ? dbg_bad_o                            :
                         (hs_rl_off == 5'd17) ? {3'b0, dbg_bad_seen, dbg_bad_mode}   :
                         (hs_rl_off == 5'd18) ? dbg_bad_idx                          :
                         (hs_rl_off == 5'd19) ? dbg_khist[8]                         :
                         (hs_rl_off == 5'd20) ? dbg_khist[15]                        :
                                                dbg_kf_gateclosed;
assign hs_data_out = (hs_address == 16'hE300) ? dbg_186_cnt :
                     (hs_address == 16'hE301) ? dbg_1d9_cnt :
                     (hs_address == 16'hE302) ? dbg_760_cnt :
                     (hs_address == 16'hE303) ? {7'b0, dbg_r0b1_sticky} :
                     (hs_address == 16'hE304) ? dbg_r0b1_edge_cnt :
                     (hs_address == 16'hE305) ? dbg_595_cnt :
                     (hs_address == 16'hE1A0) ? dbg_176_cnt[7:0] :
                     (hs_address == 16'hE1A1) ? dbg_176_cnt[15:8] :
                     (hs_address == 16'hE1A2) ? {4'b0, dbg_ram41_do} :
                     (hs_address == 16'hE1A3) ? {4'b0, dbg_ram42_do} :
                     (hs_address == 16'hE1A4) ? dbg_e162_snap :
                     (hs_address == 16'hE1A5) ? dbg_e118_snap :
                     (hs_address == 16'hE1A6) ? dbg_e0cd_snap :
                     (hs_address == 16'hE1A7) ? {3'b0, mcu_present, r0_out} :
                     (hs_address == 16'hE1A8) ? dbg_e017_snap :
                     (hs_address == 16'hE1A9) ? {7'b0, dbg_e118_ever_nz} :
                     (hs_address == 16'hE1AA) ? dbg_e119_last_nz :
                     (hs_address == 16'hE1AB) ? dbg_351c_cnt :
                     (hs_address == 16'hE1AC) ? dbg_3526_cnt :
                     (hs_address == 16'hE1AD) ? dbg_352e_cnt :
                     (hs_address == 16'hE1AE) ? dbg_3534_cnt :
                     (hs_address == 16'hE1AF) ? dbg_353a_cnt :
                     (hs_address == 16'hE1B0) ? dbg_3541_cnt :
                     (hs_address == 16'hE1B1) ? dbg_3546_cnt :
                     // DIAG-REVERT-2026-07-07-SWEEP: sweep-pointer min/max/current + no-op-spin counter
                     (hs_address == 16'hE1B2) ? dbg_sweep_min :
                     (hs_address == 16'hE1B3) ? dbg_sweep_max :
                     (hs_address == 16'hE1B4) ? dbg_sweep_ptr :
                     (hs_address == 16'hE1B5) ? dbg_77c_cnt :
                     (hs_address == 16'hE1B6) ? dbg_039_cnt[7:0] :
                     (hs_address == 16'hE1B7) ? dbg_039_cnt[15:8] :
                     (hs_address == 16'hE1B8) ? dbg_191_cnt[7:0] :
                     (hs_address == 16'hE1B9) ? dbg_191_cnt[15:8] :
                     // DIAG-REVERT-2026-07-07-TRAP: foreground-PC trap locator (11-bit each, low byte + top 3 bits)
                     (hs_address == 16'hE1BA) ? dbg_last_fg[7:0] :
                     (hs_address == 16'hE1BB) ? {5'b0, dbg_last_fg[10:8]} :
                     (hs_address == 16'hE1BC) ? dbg_fg_min[7:0] :
                     (hs_address == 16'hE1BD) ? {5'b0, dbg_fg_min[10:8]} :
                     (hs_address == 16'hE1BE) ? dbg_fg_max[7:0] :
                     (hs_address == 16'hE1BF) ? {5'b0, dbg_fg_max[10:8]} :
                     (hs_address == 16'hE1C0) ? dbg_740_cnt :
                     // DIAG-REVERT-2026-07-09-RING: E1C1..E1DB reclaimed for the ring buffer. Every tap below
                     // has already answered its question (Diag 10-17) -- K stable, mem clean, store/read
                     // addresses match, M[4,3] stray write rare, K=0 = protrom 0x00 on page 1, both pages
                     // read. Uncomment these 15 lines (and delete the 3 RING lines) to restore.
                     // (hs_address == 16'hE1C1) ? dbg_debounce_state :
                     // (hs_address == 16'hE1C2) ? dbg_maindata_157 :
                     // (hs_address == 16'hE1C3) ? {dbg_k159, dbg_k157} :
                     // (hs_address == 16'hE1C4) ? {dbg_ramdo_15A, dbg_mem_15A} :
                     // (hs_address == 16'hE1C5) ? {1'b0, dbg_st_addr} :
                     // (hs_address == 16'hE1C6) ? {1'b0, dbg_eor_addr} :
                     // (hs_address == 16'hE1C7) ? {2'b0, dbg_st_we, dbg_r3_157, dbg_st_val} :
                     // (hs_address == 16'hE1C8) ? dbg_protrom_157 :
                     // (hs_address == 16'hE1C9) ? {3'b0, dbg_m43_wrong, dbg_m43_wval} :
                     // (hs_address == 16'hE1CA) ? dbg_m43_2cnt :
                     // (hs_address == 16'hE1CB) ? {5'b0, dbg_k0_gates} :
                     // (hs_address == 16'hE1CC) ? dbg_k0_main :
                     // (hs_address == 16'hE1CD) ? dbg_k0_prot :
                     // (hs_address == 16'hE1CE) ? {6'b0, dbg_p0_ink, dbg_r31_ever0} :
                     // (hs_address == 16'hE1CF) ? dbg_p0_cnt :
                     // DIAG-REVERT-2026-07-09-RING: E1C1/C2 = max healthy dispatcher gap (x16 mcu_ena ticks,
                     // 0xFFFF = saturated), E1C3 = status, E1C4..E1D9 = the 11-entry foreground-PC ring,
                     // E1DA/DB = dbg_176_cnt latched at the freeze (== E1A0/A1 => the capture is valid).
                     (hs_address == 16'hE1C1) ? dbg_max_gap[7:0] :
                     (hs_address == 16'hE1C2) ? dbg_max_gap[15:8] :
                     (hs_address == 16'hE1C3) ? {dbg_frozen, dbg_ring_wrap, dbg_inirq_frz, dbg_armed, dbg_ring_wp} :
                  // DIAG-REVERT-2026-07-09-RING: retired -- was: hs_ring_sel ? hs_ring_byte :
                     hs_rl_sel                 ? hs_rl_byte   :
                     (hs_address == 16'hE1DA) ? dbg_176_frz[7:0] :
                     (hs_address == 16'hE1DB) ? dbg_176_frz[15:8] :
                     workram_hs_q;

//--------------------------------------------------- Video Control Registers --------------------------------------------------//

// MAME: m_video_control[0..10], written at 0xE800-0xE80A
// Only bits [3:0] of the address select the register (mirrored with 0x03F0)
reg [7:0] video_control [0:10];
integer vc_i;
initial begin
    for (vc_i = 0; vc_i < 11; vc_i = vc_i + 1)
        video_control[vc_i] = 8'd0;
end

// Trigger for blitter execution (directly from Step 4)
reg blitter_start = 0;

always_ff @(posedge clk_10m) begin
    blitter_start <= 0;
    if(cs_vidctrl & ~n_wr) begin
        if(cpu_A[3:0] <= 4'd10)
            video_control[cpu_A[3:0]] <= cpu_Dout;
        if(cpu_A[3:0] == 4'd5)
            blitter_start <= 1;  // Writing to reg 5 triggers DMA blit
    end
end

//------------------------------------------------------- Sound Latch ---------------------------------------------------------//

reg [7:0] slatch = 8'd0;
reg       slatch_wr_pulse = 0;
always_ff @(posedge clk_10m) begin
    slatch_wr_pulse <= 0;
    if(cs_in0 & ~n_wr) begin
        slatch <= cpu_Dout;
        slatch_wr_pulse <= 1;
    end
end
assign sound_latch = slatch;
assign sound_latch_wr = slatch_wr_pulse;

//------------------------------------------------------- Bootleg NMI ---------------------------------------------------------//

// The bootleg has no MCU. It pulses NMI at reset to make the game boot.
// MAME: m_maincpu->pulse_input_line(INPUT_LINE_NMI, attotime::zero);
// On original HW (mcu_present) the MB8841 drives NMI instead (see MCU block below) — this pulse is unused.
reg [7:0] nmi_boot_cnt = 8'd0;
reg n_nmi_boot = 1'b1;
always_ff @(posedge clk_10m) begin
    if(!reset) begin
        nmi_boot_cnt <= 8'd255;
        n_nmi_boot <= 1'b1;
    end
    else if(nmi_boot_cnt > 0 && cen_2m5) begin
        nmi_boot_cnt <= nmi_boot_cnt - 8'd1;
        if(nmi_boot_cnt == 8'd32)
            n_nmi_boot <= 1'b0;
        else if(nmi_boot_cnt == 8'd16)
            n_nmi_boot <= 1'b1;
    end
end

// NMI source select: MB8841 (R3.3) on original HW, bootleg boot pulse otherwise. (mcu_nmi_n: MCU block below.)
wire n_nmi = mcu_present ? mcu_nmi_n : n_nmi_boot;

//-------------------------------------------------------- MB8841 MCU ---------------------------------------------------------//
// Original Kangaroo (TVG-1-CPU-B, IC29) fits an MB8841 microcomputer used for protection. Per MAME
// kangaroo.cpp:153 — besides the boot NMI it "acts like a timer to determine the intervals of the big ape
// enemy appearing." Wiring mirrors kangaroo_mcu_state (kangaroo.cpp:455-504):
//   CPU wr 0xEF00 -> main_data                                            (mcu_w)
//   CPU rd 0xEF00 <- R0 port latch                                        (mcu_r)
//   K port = 0xF & (R2.0 ? main_data : F) & (~R3.0 ? protrom[addr] : F)   (mcu_port_k_r)
//   O port (oh:ol) -> protrom addr A0-A7 ; R3.1 -> A8 (A9,A10=GND)        (mcu_port_o_w / mcu_port_r_w)
//   R3.3 -> main-CPU NMI                                                  (mcu_port_r_w)
// MCU clock = 10MHz/4 = 2.5MHz (MAME MB8841(.., 10_MHz_XTAL/4)). Held in reset when not fitted.
// darfpga mb88 has separate R in/out ports and no external drive on kangaroo's R pins, so tie in<-out
// (MAME's read_r returns the output latch). Nothing drives the MCU /IRQ or /TC externally on kangaroo.

reg  [4:0] mcu_tp = 5'd0;          // timer prescaler approximation (MAME TIMER_PRESCALE=32)
always_ff @(posedge clk_10m) if (cen_2m5 & ~pause) mcu_tp <= mcu_tp + 5'd1;
wire mcu_ena       = cen_2m5 & ~pause;
wire mcu_ena_timer = mcu_ena & (mcu_tp == 5'd0);
wire mcu_reset_n   = reset & mcu_present;     // hold in reset unless MB8841 is fitted

wire [10:0] mcu_rom_addr;
wire  [7:0] mcu_rom_q;
wire  [3:0] mcu_ol, mcu_oh;
wire  [7:0] mcu_o = {mcu_oh, mcu_ol};         // combined O port = protrom A0-A7
wire  [3:0] r0_out, r1_out, r2_out, r3_out;

reg  [7:0] main_data = 8'd0;                  // CPU write to 0xEF00 (mcu_w)
always_ff @(posedge clk_10m)
    if (cs_mcu & ~n_wr) main_data <= cpu_Dout;

wire [10:0] protrom_addr = {2'b00, r3_out[1], mcu_o};   // A8 = R3.1, A0-A7 = O
wire  [7:0] protrom_q;

// MCU-KSTABLE-FIX-2026-07-07 REVERTED 2026-07-08: Diagnostic 10 probe proved R2.0==0 at the hung 0x157 read,
// so main_data is masked out of K there (R2.0?main_data:F -> F) -> the fix was a no-op. Restored original mcu_k.
// The real oscillation is in the protrom_q/readback path (R2.0 clear => K = protrom_q alone), yet two
// consecutive reads still never match -> next probe (below) captures K@0x157 vs K@0x159 to split
// "protrom_q unstable" from "RAM store/readback corrupt".
wire  [3:0] mcu_k = 4'hF
                  & ( r2_out[0] ? main_data[3:0] : 4'hF)   // gated by R2.0
                  & (~r3_out[0] ? protrom_q[3:0] : 4'hF);  // gated by ~R3.0

wire mcu_nmi_n = ~r3_out[3];                  // R3.3 asserts NMI (active high) -> n_nmi low
// MCU-R0PULSE-STRETCH-FIX REVERTED 2026-07-08: Diag 14 identical to Diag 13 (dbg_3541_cnt still 0, all MCU
// counters unchanged) -- the stretch had no pulse to catch because the MCU foreground stops dispatching at
// ~7856 passes (a 2nd deterministic hang past the M43 one). Not a timing/width problem (clocks verified to
// match MAME). Restored the original passthrough. Real target is now the K=0 exits / M[4,3]=2 page bug.
assign mcu_dout = mcu_present ? {4'h0, r0_out} : 8'h00;

mb88 mcu
(
    .clock      (clk_10m),
    .ena        (mcu_ena),
    .ena_timer  (mcu_ena_timer),
    .reset_n    (mcu_reset_n),

    .r0_port_in (r0_out), .r1_port_in (r1_out), .r2_port_in (r2_out), .r3_port_in (r3_out),
    .r0_port_out(r0_out), .r1_port_out(r1_out), .r2_port_out(r2_out), .r3_port_out(r3_out),
    .k_port_in  (mcu_k),
    .ol_port_out(mcu_ol), .oh_port_out(mcu_oh),
    .p_port_out (),

    .stby_n     (1'b1),
    .tc_n       (1'b1),
    .irq_n      (1'b1),
    .sc_in_n    (1'b1),
    .si_n       (1'b1),
    .sc_out_n   (),
    .so_n       (),
    .to_n       (),

    .rom_addr   (mcu_rom_addr),
    .rom_data   (mcu_rom_q),

    // DIAG-REVERT-2026-07-06g
    .dbg_ram41_do(dbg_ram41_do), .dbg_ram42_do(dbg_ram42_do),
    .dbg_mem_do(dbg_mem_do), .dbg_ramdo_do(dbg_ramdo_do),
    .dbg_ramaddr_do(dbg_ramaddr_do), .dbg_ramdi_do(dbg_ramdi_do),
    .dbg_ramwe_do(dbg_ramwe_do),
    // DIAG-REVERT-2026-07-09-RING
    .dbg_sbo_do(mcu_dbg_sbo), .dbg_inirq_do(mcu_dbg_inirq),
    // DIAG-REVERT-2026-07-10-M7BUF
    .dbg_m7_do(dbg_m7_do)
);

// MCU internal program ROM (2KB) — index 6, ioctl_addr[11]==0
dpram_dc #(.widthad_a(11), .width_a(8)) mcu_prog
(
    .clock_a(clk_10m), .address_a(mcu_rom_addr), .data_a(8'd0), .wren_a(1'b0), .q_a(mcu_rom_q),
    .clock_b(clk_10m), .address_b(ioctl_addr[10:0]), .data_b(ioctl_data),
    .wren_b(mcurom_wr & ~ioctl_addr[11]), .q_b()
);

// MCU protection PROM (2KB) — index 6, ioctl_addr[11]==1
dpram_dc #(.widthad_a(11), .width_a(8)) mcu_prot
(
    .clock_a(clk_10m), .address_a(protrom_addr), .data_a(8'd0), .wren_a(1'b0), .q_a(protrom_q),
    .clock_b(clk_10m), .address_b(ioctl_addr[10:0]), .data_b(ioctl_data),
    .wren_b(mcurom_wr & ioctl_addr[11]), .q_b()
);

//-------------------------------------------------------- VBlank IRQ ----------------------------------------------------------//

// MAME: standard IM1 interrupt, RST 38h every vblank
// IRQ fires on vblank rising edge
reg n_irq = 1'b1;
reg vblank_last = 0;
always_ff @(posedge clk_10m) begin
    if(!reset) begin
        n_irq <= 1'b1;
        vblank_last <= 0;
    end
    else begin
        vblank_last <= video_vblank;
        // Assert IRQ on rising edge of vblank
        if(video_vblank & ~vblank_last)
            n_irq <= 1'b0;
        // Auto-clear: Z80 IM1 acknowledges via M1+IORQ
        if(~n_m1 & ~n_iorq)
            n_irq <= 1'b1;
    end
end

//-------------------------------------------------------- Video Timing --------------------------------------------------------//

// Kangaroo video timing from MAME:
// screen.set_raw(10_MHz_XTAL, 320*2, 0*2, 256*2, 260, 8, 248);
// Total: 640 pixel clocks horizontal (at 5 MHz that's 320 positions at 10 MHz)
// But the screen uses 10 MHz as raw pixel clock with 640 total, 512 visible
// Vertical: 260 lines total, visible 8-248 (240 lines)
//
// We run the pixel counter at 10 MHz (ce_pix = cen_5m for output,
// but the counters tick every clk_10m)

reg [9:0] h_cnt = 10'd0;  // 0-639
reg [8:0] v_cnt = 9'd0;   // 0-259

always_ff @(posedge clk_10m) begin
    if(!reset) begin
        h_cnt <= 0;
        v_cnt <= 0;
    end
    else begin
        if(h_cnt == 10'd639) begin
            h_cnt <= 0;
            if(v_cnt == 9'd259)
                v_cnt <= 0;
            else
                v_cnt <= v_cnt + 9'd1;
        end
        else
            h_cnt <= h_cnt + 10'd1;
    end
end

// Sync and blank generation
// MAME visible: x = 0*2 to 256*2-1 = 0 to 511, y = 8 to 247
// TOP-BOTTOM-FIX-2026-06-21: the scanout pixel pipeline is 2 clk_10m cycles deep (combinational addr ->
// DPRAM addr-reg -> scan_word latch), so the pixel for h_cnt=H is output at H+2. hblank/hsync were
// combinational off h_cnt, so the active window LED the data by 2 px -> 2 rows of pre-visible garbage at the
// display TOP and the last 2 real rows pushed off the BOTTOM (h_cnt = display-vertical, ROT90). Delay
// hblank/hsync by 2 cycles to align the window with the data. This is a latency match, NOT a directional
// window shift (which wraps junk). v-axis has no such latency -> vblank/vsync stay combinational, and the
// vblank IRQ keeps using the undelayed video_vblank (game timing untouched).
// Original combinational lines below:
// assign video_hblank = (h_cnt >= 10'd512);
// assign video_hsync  = (h_cnt >= 10'd560) & (h_cnt < 10'd624);  // ~64 clocks
wire video_hblank_raw = (h_cnt >= 10'd512);
wire video_hsync_raw  = (h_cnt >= 10'd560) & (h_cnt < 10'd624);  // ~64 clocks
reg [1:0] hblank_sr = 2'b11;
reg [1:0] hsync_sr  = 2'b00;
always_ff @(posedge clk_10m) begin
    hblank_sr <= {hblank_sr[0], video_hblank_raw};
    hsync_sr  <= {hsync_sr[0],  video_hsync_raw};
end
assign video_hblank = hblank_sr[1];
assign video_hsync  = hsync_sr[1];
assign video_vblank = (v_cnt < 9'd8) | (v_cnt >= 9'd248);
assign video_vsync  = (v_cnt >= 9'd252) & (v_cnt < 9'd256);     // ~4 lines

//--------------------------------------------------------- Video RAM ----------------------------------------------------------//

// Kangaroo VRAM: 16384 addresses × 32 bits (4 bytes per word, 2 planes × 4 pixels)
// Split into two 16-bit-wide dpram_dc instances (lo=bytes 0,1  hi=bytes 2,3)
// Port A = CPU/blitter read-modify-write
// Port B = video scanout (read-only)

wire [15:0] vram_lo_qa, vram_hi_qa;   // Port A read data (CPU/blitter side)
wire [15:0] vram_lo_qb, vram_hi_qb;   // Port B read data (scanout side)
reg  [13:0] vram_addr_a;
reg  [15:0] vram_lo_da, vram_hi_da;
reg         vram_we_a;
wire [13:0] vram_addr_b;               // Scanout address (active accent accent driven by compositing logic)

dpram_dc #(.widthad_a(14), .width_a(16)) vram_lo
(
    .clock_a(clk_10m),
    .address_a(vram_addr_a),
    .data_a(vram_lo_da),
    .wren_a(vram_we_a),
    .q_a(vram_lo_qa),

    .clock_b(clk_10m),
    .address_b(vram_addr_b),
    .data_b(16'd0),
    .wren_b(1'b0),
    .q_b(vram_lo_qb)
);

dpram_dc #(.widthad_a(14), .width_a(16)) vram_hi
(
    .clock_a(clk_10m),
    .address_a(vram_addr_a),
    .data_a(vram_hi_da),
    .wren_a(vram_we_a),
    .q_a(vram_hi_qa),

    .clock_b(clk_10m),
    .address_b(vram_addr_b),
    .data_b(16'd0),
    .wren_b(1'b0),
    .q_b(vram_hi_qb)
);

// DIAG-2026-06-18 PLANE-OFFSET FIX (the 2-month sprite-edge fringe). The scanout previously read plane A
// and plane B through ONE shared port B (muxed on h_cnt[0]); with the 1-cycle DPRAM latency that left
// plane A one COLUMN ahead of plane B at compositing → garbage at sprite EDGES (interiors fine). These two
// MIRROR instances (written identically on port A) give plane B its own same-latency read port, so plane A
// reads vram_lo/hi:B and plane B reads vram_lo2/hi2:B — aligned (recreates step4's combinational dual-read).
wire [15:0] vram2_lo_qb, vram2_hi_qb;   // plane-B mirror scanout read data
wire [13:0] vram_addr_b2;               // plane B scanout address (mirror port B)

dpram_dc #(.widthad_a(14), .width_a(16)) vram_lo2
(
    .clock_a(clk_10m), .address_a(vram_addr_a), .data_a(vram_lo_da), .wren_a(vram_we_a), .q_a(),
    .clock_b(clk_10m), .address_b(vram_addr_b2), .data_b(16'd0), .wren_b(1'b0), .q_b(vram2_lo_qb)
);
dpram_dc #(.widthad_a(14), .width_a(16)) vram_hi2
(
    .clock_a(clk_10m), .address_a(vram_addr_a), .data_a(vram_hi_da), .wren_a(vram_we_a), .q_a(),
    .clock_b(clk_10m), .address_b(vram_addr_b2), .data_b(16'd0), .wren_b(1'b0), .q_b(vram2_hi_qb)
);

//------------------------------------------------ VRAM Expand/Mask Functions --------------------------------------------------//

// MAME videoram_write expand logic — pure combinational functions
// Expand 8-bit CPU data to 32-bit (DCBADCBA → 4 bytes)
function [31:0] expand_data;
    input [7:0] data;
    reg [31:0] e;
    begin
        e = 32'd0;
        if (data[0]) e = e | 32'h00000055;
        if (data[4]) e = e | 32'h000000aa;
        if (data[1]) e = e | 32'h00005500;
        if (data[5]) e = e | 32'h0000aa00;
        if (data[2]) e = e | 32'h00550000;
        if (data[6]) e = e | 32'h00aa0000;
        if (data[3]) e = e | 32'h55000000;
        if (data[7]) e = e | 32'haa000000;
        expand_data = e;
    end
endfunction

// Build layer mask from 4-bit mask value
function [31:0] build_layermask;
    input [3:0] mask;
    reg [31:0] m;
    begin
        m = 32'd0;
        if (mask[3]) m = m | 32'h30303030;
        if (mask[2]) m = m | 32'hc0c0c0c0;
        if (mask[1]) m = m | 32'h03030303;
        if (mask[0]) m = m | 32'h0c0c0c0c;
        build_layermask = m;
    end
endfunction

//------------------------------------------------------ Blitter ROM -----------------------------------------------------------//

// 16KB blitter ROM — single dpram_dc, port A = blitter read, port B = ioctl download
wire [7:0] blitrom_qa;
reg  [13:0] blitrom_addr_a;

// Compute ioctl write address for blitter ROM download
// blit0 → 0x0000-0x0FFF, blit1 → 0x1000-0x1FFF, blit2 → 0x2000-0x2FFF, blit3 → 0x3000-0x3FFF
wire [13:0] blitrom_dl_addr = blit0_cs_i ? {2'b00, ioctl_addr[11:0]} :
                               blit1_cs_i ? {2'b01, ioctl_addr[11:0]} :
                               blit2_cs_i ? {2'b10, ioctl_addr[11:0]} :
                               blit3_cs_i ? {2'b11, ioctl_addr[11:0]} :
                               14'd0;
wire blitrom_dl_wr = ioctl_wr & (blit0_cs_i | blit1_cs_i | blit2_cs_i | blit3_cs_i);

dpram_dc #(.widthad_a(14), .width_a(8)) blitrom_mem
(
    .clock_a(clk_10m),
    .address_a(blitrom_addr_a),
    .data_a(8'd0),
    .wren_a(1'b0),
    .q_a(blitrom_qa),

    .clock_b(clk_10m),
    .address_b(blitrom_dl_addr),
    .data_b(ioctl_data),
    .wren_b(blitrom_dl_wr),
    .q_b()
);

//------------------------------------------------------ DMA Blitter -----------------------------------------------------------//

// Pipelined read-modify-write state machine:
//   IDLE     — wait for blitter_start or CPU VRAM write
//   RMW_READ — present address to VRAM port A, wait 1 cycle for read data
//   RMW_WRITE— compute new value, write back to VRAM port A
//   BLIT_SETUP — load blitter parameters
//   BLIT_READ  — present blitrom address, wait for ROM data
//   BLIT_RMW_RD — present VRAM dest address, wait for old data
//   BLIT_RMW_WR_LO — write low-half blit result to VRAM
//   BLIT_RMW_RD2 — re-read VRAM for high-half blit
//   BLIT_RMW_WR_HI — write high-half blit result, advance to next pixel

localparam ST_IDLE        = 4'd0;
localparam ST_CPU_RMW_RD  = 4'd1;
localparam ST_CPU_RMW_WR  = 4'd2;
localparam ST_BLIT_SETUP  = 4'd3;
localparam ST_BLIT_ROMRD  = 4'd4;
localparam ST_BLIT_RMW_RD = 4'd5;
localparam ST_BLIT_RMW_WR_LO = 4'd6;
localparam ST_BLIT_RMW_RD2   = 4'd7;
localparam ST_BLIT_RMW_WR_HI = 4'd8;
localparam ST_BLIT_NEXT   = 4'd9;
localparam ST_CPU_RMW_RD2 = 4'd10;
localparam ST_BLIT_ROWSTART = 4'd11;
// DPRAM-LATENCY-FIX-2026-06-21: blitrom_mem is dpram_dc (altsyncram) = 2 clks addr-reg+read (the CPU RMW in
// this file correctly waits 2). The blit ROM reads waited only 1 → LOW/HIGH captured a cycle early off the
// shared port → 1-source-pixel skew between planes = the green/blue 1px fringe. These settle states fix it.
localparam ST_BLIT_WAIT_LO  = 4'd12;
localparam ST_BLIT_WAIT_HI  = 4'd13;

reg [3:0]  vram_state = ST_IDLE;
reg [7:0]  blit_width;
reg [7:0]  blit_height;
reg [7:0]  blit_x_cnt;
reg [7:0]  blit_y_cnt;
reg [15:0] blit_cur_src;
reg [15:0] blit_cur_dst;
reg [7:0]  blit_adj_mask;
reg [7:0]  blit_rom_data_lo;
reg [7:0]  blit_rom_data_hi;

// Registered copies of CPU write params (captured in IDLE)
reg [13:0] cpu_wr_addr;
reg [7:0]  cpu_wr_data;
reg [3:0]  cpu_wr_mask;

// Read-modify-write intermediates
reg [31:0] rmw_old_word;
reg [31:0] rmw_new_word;
reg [31:0] rmw_expdata;
reg [31:0] rmw_layermask;

always_ff @(posedge clk_10m) begin
    if (!reset) begin
        vram_state <= ST_IDLE;
        vram_we_a <= 0;
    end
    else begin
        vram_we_a <= 0;  // Default: no write

        case (vram_state)
            ST_IDLE: begin
                if (blitter_start) begin
                    // Latch blitter params
                    blit_width   <= video_control[4];
                    blit_height  <= video_control[5];
                    blit_cur_src <= {video_control[1], video_control[0]};
                    blit_cur_dst <= {video_control[3], video_control[2]};
                    blit_x_cnt  <= 0;
                    blit_y_cnt  <= 0;
                    // Compute adjusted mask
                    blit_adj_mask <= video_control[8];
                    vram_state <= ST_BLIT_SETUP;
                end
                else if (cs_videoram & ~n_wr) begin
                    // CPU VRAM write — start RMW cycle
                    cpu_wr_addr <= cpu_A[13:0];
                    cpu_wr_data <= cpu_Dout;
                    cpu_wr_mask <= video_control[8][3:0];
                    vram_addr_a <= cpu_A[13:0];  // Present read address
                    vram_state <= ST_CPU_RMW_RD;
                end
            end

            //--- CPU VRAM write (3-cycle RMW: addr → wait → read+compute → write) ---
            ST_CPU_RMW_RD: begin
                // Address was presented last cycle. dpram output will be valid NEXT cycle.
                // Pre-compute expand/mask while waiting for RAM.
                rmw_expdata  <= expand_data(cpu_wr_data);
                rmw_layermask <= build_layermask(cpu_wr_mask);
                vram_state <= ST_CPU_RMW_RD2;
            end

            ST_CPU_RMW_RD2: begin
                // NOW the dpram output is valid — latch it
                rmw_old_word <= {vram_hi_qa, vram_lo_qa};
                vram_state <= ST_CPU_RMW_WR;
            end

            ST_CPU_RMW_WR: begin
                rmw_new_word = (rmw_old_word & ~rmw_layermask) | (rmw_expdata & rmw_layermask);
                vram_addr_a <= cpu_wr_addr;
                vram_lo_da <= rmw_new_word[15:0];
                vram_hi_da <= rmw_new_word[31:16];
                vram_we_a  <= 1;
                vram_state <= ST_IDLE;
            end

            //--- Blitter DMA ---
            ST_BLIT_SETUP: begin
                // Adjust mask per MAME: OR top/bottom 2-bit pairs during DMA
                if (blit_adj_mask[3:2] != 0) blit_adj_mask[3:2] <= 2'b11;
                if (blit_adj_mask[1:0] != 0) blit_adj_mask[1:0] <= 2'b11;
                // Start first pixel: present low-half ROM addr
                blitrom_addr_a <= {1'b0, blit_cur_src[12:0]};
                // DPRAM-LATENCY-FIX-2026-06-21: was "vram_state <= ST_BLIT_ROMRD;" (1-cycle settle — TOO EARLY).
                vram_state <= ST_BLIT_WAIT_LO;
            end

            // DPRAM-LATENCY-FIX-2026-06-21: NEW settle state — LOW-half ROM needs 2 clks (addr-reg + read), like
            // the CPU RMW. Without it blit_rom_data_lo was captured a cycle early off the shared blitrom port,
            // landing the LOW plane 1 source-pixel off from HIGH = the green/blue 1px fringe.
            ST_BLIT_WAIT_LO: begin
                vram_state <= ST_BLIT_ROMRD;
            end

            ST_BLIT_ROMRD: begin
                // DPRAM-LATENCY-FIX-2026-06-21: LOW-half ROM data now valid (2 clks after present). Capture it,
                // then present HIGH-half addr + the VRAM read addr (both captured 2 clks later in ST_BLIT_RMW_RD).
                blit_rom_data_lo <= blitrom_qa;
                blitrom_addr_a <= {1'b1, blit_cur_src[12:0]};
                vram_addr_a <= (blit_cur_dst[13:0] + {6'd0, blit_x_cnt}) & 14'h3FFF;
                // DPRAM-LATENCY-FIX-2026-06-21: was "vram_state <= ST_BLIT_RMW_RD;" (1-cycle — TOO EARLY).
                vram_state <= ST_BLIT_WAIT_HI;
            end

            // DPRAM-LATENCY-FIX-2026-06-21: NEW settle state — HIGH-half ROM + VRAM reads need 2 clks.
            ST_BLIT_WAIT_HI: begin
                vram_state <= ST_BLIT_RMW_RD;
            end

            ST_BLIT_RMW_RD: begin
                // DPRAM-LATENCY-FIX-2026-06-21: HIGH-half ROM AND VRAM read-back both valid now (2 clks after
                // presented in ST_BLIT_ROMRD). Both match the SAME source pixel as LOW → planes aligned.
                blit_rom_data_hi <= blitrom_qa;
                rmw_old_word     <= {vram_hi_qa, vram_lo_qa};
                vram_state <= ST_BLIT_RMW_WR_LO;
            end

            // DPRAM-LATENCY-FIX-2026-06-21: ST_BLIT_RMW_RD2 no longer reached (VRAM capture merged above). Kept.
            ST_BLIT_RMW_RD2: begin
                rmw_old_word <= {vram_hi_qa, vram_lo_qa};
                vram_state <= ST_BLIT_RMW_WR_LO;
            end

            ST_BLIT_RMW_WR_LO: begin
                // clear pixel first
                rmw_expdata   = 32'h00000000;
                rmw_layermask = build_layermask(blit_adj_mask[3:0]);
                // Apply low-half blit (mask & 0x0A)
                //
                // NOTE 2026-05-16: this pairing is INVERTED from MAME's
                // kangaroo.cpp:344-345 (MAME pairs LOW↔0x05, HIGH↔0x0a).
                // We swapped to match MAME and the test showed: colors went
                // way off across all graphics + sprite trails turned BLACK
                // instead of green (clear started working but background
                // restoration broke). Diagnosis: the mismatch here is being
                // consumed by a COMPENSATING WRONGNESS elsewhere in the
                // pipeline (compositing? palette LUT? plane extraction at
                // scanout?), and the two wrongs make a right visually.
                // Reverting until we can ground-truth against MAME and find
                // the second mismatch. See
                // Claude/sprite_artifacting_audit_2026-05-16.md.
                rmw_expdata   = expand_data(blit_rom_data_lo);
                // PAIRING-MAME-MATCH-2026-06-21: with the DPRAM timing skew fixed, match MAME kangaroo.cpp:344
                // (LOW-half ROM <-> mask & 0x05). The inverted pairing only looked right because the skew was
                // compensating; now it's exposed. Original (inverted) line below:
                // rmw_layermask = build_layermask(blit_adj_mask[3:0] & 4'b1010);
                rmw_layermask = build_layermask(blit_adj_mask[3:0] & 4'b0101);
                rmw_new_word  = (rmw_old_word & ~rmw_layermask) | (rmw_expdata & rmw_layermask);
                // Now apply high-half blit (mask & 0x05) on top of that
                rmw_expdata   = expand_data(blit_rom_data_hi);
                // PAIRING-MAME-MATCH-2026-06-21: HIGH-half ROM <-> mask & 0x0a per MAME kangaroo.cpp:345.
                // Original (inverted) line below:
                // rmw_layermask = build_layermask(blit_adj_mask[3:0] & 4'b0101);
                rmw_layermask = build_layermask(blit_adj_mask[3:0] & 4'b1010);
                rmw_new_word  = (rmw_new_word & ~rmw_layermask) | (rmw_expdata & rmw_layermask);
                // Write back
                vram_addr_a <= (blit_cur_dst[13:0] + {6'd0, blit_x_cnt}) & 14'h3FFF;
                vram_lo_da  <= rmw_new_word[15:0];
                vram_hi_da  <= rmw_new_word[31:16];
                vram_we_a   <= 1;
                vram_state  <= ST_BLIT_NEXT;
            end

            ST_BLIT_NEXT: begin
                // Advance to next pixel
                blit_cur_src <= blit_cur_src + 16'd1;
                if (blit_x_cnt == blit_width) begin
                    blit_x_cnt <= 0;
                    if (blit_y_cnt == blit_height) begin
                        vram_state <= ST_IDLE;  // Done
                    end
                    else begin
                        blit_y_cnt  <= blit_y_cnt + 8'd1;
                        blit_cur_dst <= blit_cur_dst + 16'd256;
                        // Start next row: read ROM for first pixel
                        blitrom_addr_a <= {1'b0, (blit_cur_src + 16'd1) & 16'h1FFF};
                        vram_state <= ST_BLIT_ROWSTART;
                    end
                end
                else begin
                    blit_x_cnt <= blit_x_cnt + 8'd1;
                    // Start next pixel: present LOW-half ROM addr
                    blitrom_addr_a <= {1'b0, (blit_cur_src + 16'd1) & 16'h1FFF};
                    // DPRAM-LATENCY-FIX-2026-06-21: was "vram_state <= ST_BLIT_ROMRD;" (1-cycle — TOO EARLY).
                    vram_state <= ST_BLIT_WAIT_LO;
                end
            end

            ST_BLIT_ROWSTART: begin
                // blit_cur_dst is now settled — proceed to ROM read
                vram_state <= ST_BLIT_ROMRD;
            end

            default: vram_state <= ST_IDLE;
        endcase
    end
end

//----------------------------------------------- Pixel Compositing (screen_update) --------------------------------------------//

// MAME screen_update variables derived from video_control registers
wire [7:0] scrolly = video_control[6];
wire [7:0] scrollx = video_control[7];
wire [2:0] maska = (video_control[10] & 8'h28) >> 3;   // MAME exact
wire [2:0] maskb =  video_control[10][2:0];
wire [7:0] xora = video_control[9][5] ? 8'hFF : 8'h00;
wire [7:0] xorb = video_control[9][4] ? 8'hFF : 8'h00;
wire       enaa = video_control[9][3];
wire       enab = video_control[9][2];
wire       pria = ~video_control[9][1];
wire       prib = ~video_control[9][0];

// Current scanout position (used for address)
wire [8:0] scan_x = h_cnt[9:1];
wire [7:0] scan_y = v_cnt[7:0];

// 2026-06-18: scanout left at NATIVE (full content + correct size). HW results that rule out the simple
// knobs: doubling (src_col=h_cnt[9:2]) => top-half magnified; doubling + halved extent (hblank 256) =>
// only 1/4 of screen. So the doubling<->display-extent relationship here is NOT understood — needs a full
// pixel-path trace (h_cnt/v_cnt -> ce_pix -> arcade_video -> screen_rotate -> FB) before any more scanout
// edits. is_odd=h_cnt[1] interleave + pixb_raw priority kept (interleave present, just not MAME-clean).
wire [7:0] effxa = scrollx + (scan_x[7:0] ^ xora);
wire [7:0] effya = scrolly + (scan_y ^ xora);
wire [7:0] effxb = scan_x[7:0] ^ xorb;
wire [7:0] effyb = scan_y ^ xorb;

// Scanout pipeline — DIAG-2026-06-18 PLANE-OFFSET FIX. Read BOTH planes EVERY cycle on their own
// same-latency ports (plane A = vram_lo/hi:B, plane B = vram_lo2/hi2:B) instead of alternating ONE
// shared port on h_cnt[0]. The old alternating read left plane A one COLUMN ahead of plane B at the
// compositing point → garbage-colored sprite EDGES (the 2-month fringe / "green poop"). Now both planes
// are ALIGNED to the same column. Slices are delayed one cycle to match the 1-cycle DPRAM read latency,
// identically for both planes. (Image may shift ~1px horizontally vs before — cosmetic; adjust hblank if so.)

reg [31:0] scan_word_a, scan_word_b;
reg [1:0]  scan_effxa_slice, scan_effxb_slice;

wire [13:0] scan_addr_a_w = {effxa[7:2], effya};
wire [13:0] scan_addr_b_w = {effxb[7:2], effyb};

assign vram_addr_b  = scan_addr_a_w;   // plane A read port (vram_lo/hi:B)
assign vram_addr_b2 = scan_addr_b_w;   // plane B read port (vram_lo2/hi2:B)

reg [1:0] effxa_slice_hold, effxb_slice_hold;

always_ff @(posedge clk_10m) begin
    // capture this cycle's slice indices (for the addresses presented this cycle)
    effxa_slice_hold <= effxa[1:0];
    effxb_slice_hold <= effxb[1:0];
    // latch both planes together: q_b holds data for the address presented LAST cycle (1-cycle DPRAM
    // latency), and the matching last-cycle slice → plane A and plane B aligned to the SAME column.
    scan_word_a      <= {vram_hi_qb,  vram_lo_qb};
    scan_word_b      <= {vram2_hi_qb, vram2_lo_qb};
    scan_effxa_slice <= effxa_slice_hold;
    scan_effxb_slice <= effxb_slice_hold;
end

// Extract pixel bytes from latched 32-bit words
wire [7:0] vram_slice_a = (scan_effxa_slice == 2'd0) ? scan_word_a[7:0] :
                          (scan_effxa_slice == 2'd1) ? scan_word_a[15:8] :
                          (scan_effxa_slice == 2'd2) ? scan_word_a[23:16] :
                                                       scan_word_a[31:24];

wire [7:0] vram_slice_b = (scan_effxb_slice == 2'd0) ? scan_word_b[7:0] :
                          (scan_effxb_slice == 2'd1) ? scan_word_b[15:8] :
                          (scan_effxb_slice == 2'd2) ? scan_word_b[23:16] :
                                                       scan_word_b[31:24];

wire [3:0] pixa_raw = vram_slice_a[3:0];   // Plane A = low nibble
wire [3:0] pixb_raw = vram_slice_b[7:4];   // Plane B = high nibble

// Priority compositing (MAME logic)
// Even pixels (first of pair): full brightness, no KOS1 masking
// Odd pixels (second of pair): apply KOS1 color mask for Z=0 pixels
// DIAG-2026-06-18: at the NEW 10MHz pixel sampling (arcade_video ce_pix_2x), arcade_video samples the
// core's RGB once per h_cnt, so consecutive display pixels share scan_x (= the doubling) and h_cnt[0]
// is the doubled-pixel parity → full / dimmed-copy alternation = MAME interleave. (Was h_cnt[1], the
// parity for the old 5MHz/256px path.) Source stays native scan_x = full 256-column content.
wire is_odd_pixel = h_cnt[0];

// (2026-06-18: plane-hold "bleed fix" REVERTED — had zero effect on HW, so the bleed is NOT plane-A/B
//  misalignment. Back to the straight KOS1 masking. Bleed cause now suspected = the scaler interpolating
//  the fine interleave pattern in the horizontally-stretched THIN framebuffer → fix is the WIDTH/aspect.)
wire [3:0] pixa_masked = (is_odd_pixel && !(pixa_raw[3])) ? (pixa_raw & {1'b0, maska}) : pixa_raw;
wire [3:0] pixb_masked = (is_odd_pixel && !(pixb_raw[3])) ? (pixb_raw & {1'b0, maskb}) : pixb_raw;

wire [3:0] pixa_final = is_odd_pixel ? pixa_masked : pixa_raw;
wire [3:0] pixb_final = is_odd_pixel ? pixb_masked : pixb_raw;

reg [2:0] final_color;
always_comb begin
    final_color = 3'd0;
    if (enaa && (pria || pixb_raw == 0))
        final_color = final_color | pixa_final[2:0];
    if (enab && (prib || pixa_final == 0))
        final_color = final_color | pixb_final[2:0];
end

// Output — BGR 3-bit palette (MAME: PALETTE(config, m_palette, palette_device::BGR_3BIT))
wire active_video = ~video_hblank & ~video_vblank;
assign video_r = active_video ? {final_color[2], final_color[2], final_color[2]} : 3'd0;
assign video_g = active_video ? {final_color[1], final_color[1], final_color[1]} : 3'd0;
assign video_b = active_video ? {final_color[0], final_color[0]} : 2'd0;

endmodule
