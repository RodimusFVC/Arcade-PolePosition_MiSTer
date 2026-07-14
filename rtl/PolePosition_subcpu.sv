//============================================================================
//  PolePosition_subcpu.sv — two Z8002 game CPUs + shared video RAM
//
//  Ground truth: MAME polepos.cpp (z8002_map / z8002_map_1/2) + polepos_v.cpp
//  (sprite_r/w, road_r/w, alpha_r/w, view_r/w — Z80 byte-lane handlers).
//
//  Z80 BYTE LANE (verified in polepos_v.cpp): sprite_r/w, road_r/w, alpha_r/w,
//  view_r/w ALL read/write ONLY THE LOW BYTE of the 16-bit word:
//      sprite_r: return mem[offset] & 0xff;
//      sprite_w: mem[offset] = (mem[offset] & 0xff00) | data;
//  identical pattern for road/alpha/view. So every Z80 access is a low-byte
//  R/W of the same word the Z8002s see; high byte is untouched by the Z80.
//
//  Buffer map (Z8002 word addr | Z80 byte offset from 0x4000 | depth):
//    sprite  0x8000-0x8FFF | 0x000-0x7FF | 0x800 words (11-bit index)
//    road    0x9000-0x97FF | 0x800-0xBFF | 0x400 words (10-bit index)
//    alpha   0x9800-0x9FFF | 0xC00-0xFFF | 0x400 words (10-bit index)
//    view    0xA000-0xAFFF | 0x1000-0x17FF | 0x800 words (11-bit index)
//  Z80 relative offset == word index numerically for all four buffers (1:1),
//  so both CPU sides decode to the SAME index space per buffer.
//
//  Sub program ROM: 0x0000-0x7FFF Z8002 space, but only 8K words (13-bit
//  addr[13:1], addr[14] mirrored/unused) are physically loaded — confirmed by
//  pp_sub1.bin/pp_sub2.bin = 16384 bytes = 8192 words each, and sub1's parked
//  wait-loop PC (0x34C0, per spec) sits inside that 8K-word range.
//
//  ARBITRATION: shared VRAM buffers have one word-wide read-only "port B"
//  (scanout, for the future video pipeline) plus three independent write
//  ports (Z80 byte / sub1 word / sub2 word), one per writer, each its own
//  always block (see DIAG-REVERT-2026-07-12 below). Implemented behaviorally:
//  each buffer is a hi/lo BYTE-array pair (avoids any array-element
//  bit-select), with continuous combinational reads per consumer. An earlier
//  revision chained the three writers behind ONE priority-arbitrated
//  (Z80 > sub1 > sub2) always block, which silently DROPPED a lower-priority
//  writer's data whenever a higher-priority writer also wrote to that same
//  buffer (any index) in the same clock -- this broke sub2's VRAM
//  write/read-back self-test (0x287E/0x2880 in pp_sub2.asm) whenever sub1 ran
//  concurrently, even though sub2's own ROM checksum was unaffected. Splitting
//  into independent per-writer blocks matches real dual-port VRAM behavior for
//  non-conflicting addresses; only a genuine same-cycle+same-index write from
//  two masters remains a race, same as it would be in real hardware. Z8002 bus
//  signals are held stable by the core across its whole inter-ce window (~16
//  clk slack per the "present addr, din valid by next ce" contract in
//  z8002.sv), so repeated same-cycle re-service is idempotent and there is no
//  dependence on exact clock-edge alignment between the externally-supplied
//  Z80 `cen` and this module's internally generated sub1/sub2 CEs.
//
//  #deviation: Z8002-side buffer/register accesses are treated as WORD-ONLY
//  (wordacc/addr[0] byte lane not modeled on the Z8002 side — only the Z80
//  side is genuinely byte-oriented per polepos_v.cpp). The core's `wordacc`
//  output is left unconnected. Flagged for follow-up if a sub ROM is found
//  to do a byte-wide (ADDB/INCB) access into VRAM.
//
//  #deviation: NVI level-hold — nvi_latch_subN is (re)armed only at each
//  sub_nvi_trig pulse (from that CPU's nvi_enable at that instant) and held
//  for the whole inter-trigger period; relies on z8002.sv's documented
//  internal "nvi_pending level-latched from nvi_n, cleared on NVI accept"
//  behavior to accept it exactly once. No external accept/ack signal exists
//  to clear it early (z8002.sv exposes no such port).
//
//  0x6000/0xC000/0xC100 mirror-mask decodes derived from the given MAME
//  AM_MIRROR masks (0x1FFE, 0x38FE): significant-bit mask = ~mirror_mask.
//============================================================================
`default_nettype none

module PolePosition_subcpu
(
    input  wire        clk,
    input  wire        reset,          // active-high subsystem reset

    // ---- per-CPU reset (LS259 latch, PolePosition_CPU) + vblank NVI pulse ----
    input  wire        sub1_reset_n,
    input  wire        sub2_reset_n,
    input  wire        sub_nvi_trig,   // 1-clk pulse at vblank line 240

    // ---- Z80 byte-wide video-RAM port (from PolePosition_CPU vram_*) --------
    input  wire [12:0] vram_addr,      // offset from 0x4000 (0x0000-0x17FF valid)
    input  wire  [7:0] vram_dout,
    input  wire        vram_wr,
    input  wire        vram_rd,
    output wire  [7:0] vram_din,

    // ---- scanout (port B): 4 INDEPENDENT word-wide read-only ports, one per
    //      buffer, so the video pipeline can read all four concurrently every
    //      cycle. Replaces the old single muxed scan_buf_sel/scan_addr/scan_dout
    //      (Part-2 4-port scanout fix, 2026-07-13). Addr widths = buffer depths.
    input  wire [10:0] scan_sprite_addr,  // 0x800 words (11-bit)
    output wire [15:0] scan_sprite_dout,
    input  wire  [9:0] scan_road_addr,    // 0x400 words (10-bit)
    output wire [15:0] scan_road_dout,
    input  wire  [9:0] scan_alpha_addr,   // 0x400 words (10-bit)
    output wire [15:0] scan_alpha_dout,
    input  wire [10:0] scan_view_addr,    // 0x800 words (11-bit)
    output wire [15:0] scan_view_dout,

    // ---- scroll registers (z8002_map: 0xC000 view hscroll, 0xC100 road vscroll)
    output wire [15:0] hscroll,
    output wire [15:0] vscroll,

    // ---- ROM ioctl load: index-0 stream, sub1@0x3000(0x4000) sub2@0x7000(0x4000)
    //      pre-gated to index==0 by the caller (matches PolePosition_CPU.sv's
    //      rom_wr convention). Interleaved 16-bit big-endian: even dn_addr=HIGH.
    input  wire [24:0] dn_addr,
    input  wire  [7:0] dn_data,
    input  wire        dn_wr,

    // ---- debug ----------------------------------------------------------
    output wire [15:0] dbg1_pc,   dbg2_pc,
    output wire [15:0] dbg1_ir,   dbg2_ir,
    output wire [15:0] dbg1_fcw,  dbg2_fcw,
    output wire        dbg1_retire, dbg2_retire,
    output wire        dbg1_illegal, dbg2_illegal,
    output wire [255:0] dbg1_regs, dbg2_regs,
    output wire        dbg1_nvi_n, dbg2_nvi_n,  // NVI-delivery probe (co-sim only)
    output wire        dbg1_nvi_en, dbg2_nvi_en // nvi_enable gate state (co-sim only)
);

    //------------------------------------------------------------------------
    //  Shared CE divider — cen_z80(implicit, external)=phase0, sub1=phase5,
    //  sub2=phase10, all /16 of CLK_49M = 3.072 MHz, non-overlapping.
    //------------------------------------------------------------------------
    reg [3:0] div;
    always @(posedge clk) begin
        if (reset) div <= 4'd0;
        else       div <= div + 4'd1;
    end
    wire cen_sub1 = (div == 4'd5);
    wire cen_sub2 = (div == 4'd10);

    //------------------------------------------------------------------------
    //  Z8002 instances
    //------------------------------------------------------------------------
    wire [15:0] sub1_addr, sub1_dout, sub1_din;
    wire        sub1_mreq, sub1_iorq, sub1_we, sub1_wordacc;

    wire [15:0] sub2_addr, sub2_dout, sub2_din;
    wire        sub2_mreq, sub2_iorq, sub2_we, sub2_wordacc;

    wire sub1_nvi_n, sub2_nvi_n;

    z8002 sub1
    (
        .clk        (clk),
        .ce         (cen_sub1),
        .reset_n    (sub1_reset_n),
        .addr       (sub1_addr),
        .dout       (sub1_dout),
        .din        (sub1_din),
        .mreq       (sub1_mreq),
        .iorq       (sub1_iorq),
        .we         (sub1_we),
        .wordacc    (sub1_wordacc),
        .wait_n     (1'b1),
        .nmi_n      (1'b1),
        .nvi_n      (sub1_nvi_n),
        .vi_n       (1'b1),
        .dbg_pc     (dbg1_pc),
        .dbg_fcw    (dbg1_fcw),
        .dbg_ir     (dbg1_ir),
        .dbg_retire (dbg1_retire),
        .dbg_illegal(dbg1_illegal),
        .dbg_regs   (dbg1_regs)
    );

    z8002 sub2
    (
        .clk        (clk),
        .ce         (cen_sub2),
        .reset_n    (sub2_reset_n),
        .addr       (sub2_addr),
        .dout       (sub2_dout),
        .din        (sub2_din),
        .mreq       (sub2_mreq),
        .iorq       (sub2_iorq),
        .we         (sub2_we),
        .wordacc    (sub2_wordacc),
        .wait_n     (1'b1),
        .nmi_n      (1'b1),
        .nvi_n      (sub2_nvi_n),
        .vi_n       (1'b1),
        .dbg_pc     (dbg2_pc),
        .dbg_fcw    (dbg2_fcw),
        .dbg_ir     (dbg2_ir),
        .dbg_retire (dbg2_retire),
        .dbg_illegal(dbg2_illegal),
        .dbg_regs   (dbg2_regs)
    );

    wire sub1_mem_we = sub1_mreq & sub1_we;
    wire sub2_mem_we = sub2_mreq & sub2_we;

    //------------------------------------------------------------------------
    //  Per-sub address decode (z8002_map): ROM 0x0000-0x7FFF (8K-word phys),
    //  VRAM 0x8000-0xAFFF word, nvi_enable @0x6000 (mirror ~0x1FFE),
    //  hscroll @0xC000 / vscroll @0xC100 (mirror ~0x38FE each).
    //------------------------------------------------------------------------
    localparam [15:0] NVI_ADDR = 16'h6000, NVI_MASK = 16'hE001; // sig bits = ~0x1FFE
    localparam [15:0] HS_ADDR  = 16'hC000, HS_MASK  = 16'hC701; // sig bits = ~0x38FE
    localparam [15:0] VS_ADDR  = 16'hC100, VS_MASK  = 16'hC701;

    wire sub1_rom_sel  = ~sub1_addr[15];
    wire [12:0] sub1_rom_idx = sub1_addr[13:1];
    wire sub1_v_sprite = (sub1_addr[15:12] == 4'h8);
    wire sub1_v_road   = (sub1_addr[15:12] == 4'h9) & ~sub1_addr[11];
    wire sub1_v_alpha  = (sub1_addr[15:12] == 4'h9) &  sub1_addr[11];
    wire sub1_v_view   = (sub1_addr[15:12] == 4'hA);
    wire [10:0] sub1_idx11 = sub1_addr[11:1];
    wire [9:0]  sub1_idx10 = sub1_addr[10:1];
    wire sub1_nvi_hit  = ((sub1_addr & NVI_MASK) == NVI_ADDR);
    wire sub1_hs_hit   = ((sub1_addr & HS_MASK)  == HS_ADDR);
    wire sub1_vs_hit   = ((sub1_addr & VS_MASK)  == VS_ADDR);

    wire sub2_rom_sel  = ~sub2_addr[15];
    wire [12:0] sub2_rom_idx = sub2_addr[13:1];
    wire sub2_v_sprite = (sub2_addr[15:12] == 4'h8);
    wire sub2_v_road   = (sub2_addr[15:12] == 4'h9) & ~sub2_addr[11];
    wire sub2_v_alpha  = (sub2_addr[15:12] == 4'h9) &  sub2_addr[11];
    wire sub2_v_view   = (sub2_addr[15:12] == 4'hA);
    wire [10:0] sub2_idx11 = sub2_addr[11:1];
    wire [9:0]  sub2_idx10 = sub2_addr[10:1];
    wire sub2_nvi_hit  = ((sub2_addr & NVI_MASK) == NVI_ADDR);
    wire sub2_hs_hit   = ((sub2_addr & HS_MASK)  == HS_ADDR);
    wire sub2_vs_hit   = ((sub2_addr & VS_MASK)  == VS_ADDR);

    //------------------------------------------------------------------------
    //  Z80-side decode (vram_addr, offset from 0x4000)
    //------------------------------------------------------------------------
    wire z80_v_sprite = (vram_addr[12:11] == 2'b00);
    wire z80_v_road   = (vram_addr[12:10] == 3'b010);
    wire z80_v_alpha  = (vram_addr[12:10] == 3'b011);
    wire z80_v_view   = (vram_addr[12:11] == 2'b10);
    wire [10:0] z80_idx11 = vram_addr[10:0];
    wire [9:0]  z80_idx10 = vram_addr[9:0];

    //========================================================================
    //  MEMORY (BRAM) — 2026-07-14 synthesis rewrite (Quartus Error 276003 fix)
    //
    //  The sub ROMs and shared VRAM were behavioral byte-array pairs with
    //  ASYNC, multi-port (up to 4) combinational reads — a Verilator-friendly
    //  model that Quartus CANNOT infer as M10K, so ~350 Kbit tried to map to
    //  flip-flops and overflowed the 5CSEBA6 (Error 276003). See
    //  [[Sim-model async-read RAM does not infer BRAM]].
    //
    //  Rewritten to inferred, REGISTERED-read, <=2-port BRAM using an SV
    //  template that BOTH Verilator and Quartus M10K accept (no VHDL
    //  altsyncram, so verilator_subcpu still builds). Arrays stay hi/lo
    //  byte-split — one full-width write per array => reliable inference,
    //  no byte-enable, and the Z80's low-byte-only write is just a lo-array
    //  write with the hi array untouched.
    //
    //  PORT BUDGET — how 4 read consumers fit in 2 BRAM ports:
    //    * Port A = the CPU side (z80 + sub1 + sub2). The three masters are
    //      time-staggered by the /16 CE divider (sub1 CE=div5, sub2 CE=div10,
    //      z80 CE~div0) and each HOLDS its bus stable across its whole ~16-clk
    //      window, so they are TIME-DIVISION muxed onto ONE port by `div` slot
    //      (z80: div 0..4, sub1: div 5..9, sub2: div 10..15). Each master's
    //      registered read is latched into a per-master HOLD at the trailing
    //      slot edge; the hold is stable at that master's NEXT CE. That
    //      one-CE-period latency is EXACTLY the z8002 contract (addr presented
    //      at CE N-1, din consumed at CE N — wait_n tied high => no waits),
    //      and the Z80's multi-T-state read has even more slack.
    //    * Port B = scanout (registered read). pp_tile_layer consumes the word
    //      at intra-tile phase p>=2 and scan_addr is constant across the whole
    //      8-pixel span, so the +1-clk BRAM latency is invisible (verified vs
    //      pp_tile_layer.sv fetch timing).
    //
    //  NOTE: a naive priority mux (z80>sub1>sub2) does NOT work for READS —
    //  sub1_mreq/sub2_mreq are asserted almost every cycle (mreq=state!=ILLEGAL)
    //  so priority would permanently starve sub2 (it would read sub1's data).
    //  Time-division slotting is required.
    //========================================================================

    //------------------------------------------------------------------------
    //  Port-A time-division owner (matches cen_sub1=div5 / cen_sub2=div10).
    //------------------------------------------------------------------------
    wire own_z80  = (div <= 4'd4);
    wire own_sub1 = (div >= 4'd5)  & (div <= 4'd9);
    wire own_sub2 = (div >= 4'd10);

    //------------------------------------------------------------------------
    //  Sub program ROMs — 8K words each, hi/lo byte-split SIMPLE-dual-port
    //  BRAM: write port = index-0 ioctl byte stream (sub1@0x3000/sub2@0x7000,
    //  even dn_addr=HIGH byte, big-endian); read port = the owning z8002
    //  (REGISTERED). Dedicated per sub (rom1<->sub1, rom2<->sub2), so no slot
    //  mux is needed — the read is valid at the sub's CE (addr stable the whole
    //  window). SDP template: `if(we) mem[waddr]<=wd; q<=mem[raddr];`.
    //------------------------------------------------------------------------
    reg [7:0] rom1_hi [0:8191];
    reg [7:0] rom1_lo [0:8191];
    reg [7:0] rom2_hi [0:8191];
    reg [7:0] rom2_lo [0:8191];

    localparam [24:0] SUB1_BASE = 25'h3000, SUB1_LAST = 25'h6FFF;
    localparam [24:0] SUB2_BASE = 25'h7000, SUB2_LAST = 25'hAFFF;

    wire sub1_ld_hit = dn_wr & (dn_addr >= SUB1_BASE) & (dn_addr <= SUB1_LAST);
    wire sub2_ld_hit = dn_wr & (dn_addr >= SUB2_BASE) & (dn_addr <= SUB2_LAST);
    wire [24:0] sub1_ld_rel = dn_addr - SUB1_BASE;
    wire [24:0] sub2_ld_rel = dn_addr - SUB2_BASE;
    wire [12:0] sub1_ld_idx = sub1_ld_rel[13:1];
    wire [12:0] sub2_ld_idx = sub2_ld_rel[13:1];
    wire        sub1_ld_hi  = ~sub1_ld_rel[0];
    wire        sub2_ld_hi  = ~sub2_ld_rel[0];

    reg [7:0] rom1_hi_q, rom1_lo_q, rom2_hi_q, rom2_lo_q;
    always @(posedge clk) begin
        // write port A: ioctl byte lane (even dn_addr=HI, odd=LO)
        if (sub1_ld_hit &  sub1_ld_hi) rom1_hi[sub1_ld_idx] <= dn_data;
        if (sub1_ld_hit & ~sub1_ld_hi) rom1_lo[sub1_ld_idx] <= dn_data;
        // read port B: sub1 registered fetch
        rom1_hi_q <= rom1_hi[sub1_rom_idx];
        rom1_lo_q <= rom1_lo[sub1_rom_idx];
    end
    always @(posedge clk) begin
        if (sub2_ld_hit &  sub2_ld_hi) rom2_hi[sub2_ld_idx] <= dn_data;
        if (sub2_ld_hit & ~sub2_ld_hi) rom2_lo[sub2_ld_idx] <= dn_data;
        rom2_hi_q <= rom2_hi[sub2_rom_idx];
        rom2_lo_q <= rom2_lo[sub2_rom_idx];
    end
    wire [15:0] sub1_rom_rd = {rom1_hi_q, rom1_lo_q};
    wire [15:0] sub2_rom_rd = {rom2_hi_q, rom2_lo_q};

    //------------------------------------------------------------------------
    //  Shared VRAM buffers — hi/lo byte-split TRUE-dual-port BRAM (see the
    //  MEMORY header above). Port A = CPU side (time-division muxed
    //  z80/sub1/sub2, read+write); Port B = scanout (registered read).
    //------------------------------------------------------------------------
    reg [7:0] sprite_hi [0:2047];
    reg [7:0] sprite_lo [0:2047];
    reg [7:0] road_hi   [0:1023];
    reg [7:0] road_lo   [0:1023];
    reg [7:0] alpha_hi  [0:1023];
    reg [7:0] alpha_lo  [0:1023];
    reg [7:0] view_hi   [0:2047];
    reg [7:0] view_lo   [0:2047];

    // Memory zero-init is SIM-ONLY: Verilator has no loop cap, but Quartus
    // rejects the 8192-iteration loop (Error 10106, 5000-iter synth limit). On
    // Cyclone V the inferred BRAM config-inits to 0 anyway, and the sub ROMs are
    // ioctl-loaded (reset held during download) before the Z8002s run — so no
    // explicit init is needed for HW. Guard with VERILATOR (auto-defined by it).
    integer i;
`ifdef VERILATOR
    initial begin
        for (i = 0; i < 8192; i = i + 1) begin
            rom1_hi[i] = 8'h00; rom1_lo[i] = 8'h00;
            rom2_hi[i] = 8'h00; rom2_lo[i] = 8'h00;
        end
        for (i = 0; i < 2048; i = i + 1) begin
            sprite_hi[i] = 8'h00; sprite_lo[i] = 8'h00;
            view_hi[i]   = 8'h00; view_lo[i]   = 8'h00;
        end
        for (i = 0; i < 1024; i = i + 1) begin
            road_hi[i]  = 8'h00; road_lo[i]  = 8'h00;
            alpha_hi[i] = 8'h00; alpha_lo[i] = 8'h00;
        end
    end
`endif

    //------------------------------------------------------------------------
    //  Shared Port-A (CPU-side) controls — selected by the current `div` slot
    //  owner. Address widths: sprite/view = 11-bit, road/alpha = 10-bit. The
    //  Z80 writes the LOW byte only (polepos_v.cpp byte lane) => it drives the
    //  lo-array write-enable but never the hi array; the z8002s write the full
    //  word. Writes are idempotent across the owner's whole slot (bus held
    //  stable), so no edge alignment is assumed.
    //------------------------------------------------------------------------
    wire [10:0] pa_addr11 = own_z80 ? z80_idx11 : own_sub1 ? sub1_idx11 : sub2_idx11;
    wire  [9:0] pa_addr10 = own_z80 ? z80_idx10 : own_sub1 ? sub1_idx10 : sub2_idx10;
    wire  [7:0] pa_wdlo   = own_z80 ? vram_dout : own_sub1 ? sub1_dout[7:0]  : sub2_dout[7:0];
    wire  [7:0] pa_wdhi   =              own_sub1 ? sub1_dout[15:8] : sub2_dout[15:8]; // z80 n/a

    // per-buffer Port-A write enables (owner writing AND targeting that buffer)
    wire we_sprite_lo = (own_z80 & vram_wr & z80_v_sprite) | (own_sub1 & sub1_mem_we & sub1_v_sprite) | (own_sub2 & sub2_mem_we & sub2_v_sprite);
    wire we_sprite_hi =                                       (own_sub1 & sub1_mem_we & sub1_v_sprite) | (own_sub2 & sub2_mem_we & sub2_v_sprite);
    wire we_road_lo   = (own_z80 & vram_wr & z80_v_road)   | (own_sub1 & sub1_mem_we & sub1_v_road)   | (own_sub2 & sub2_mem_we & sub2_v_road);
    wire we_road_hi   =                                       (own_sub1 & sub1_mem_we & sub1_v_road)   | (own_sub2 & sub2_mem_we & sub2_v_road);
    wire we_alpha_lo  = (own_z80 & vram_wr & z80_v_alpha)  | (own_sub1 & sub1_mem_we & sub1_v_alpha)  | (own_sub2 & sub2_mem_we & sub2_v_alpha);
    wire we_alpha_hi  =                                       (own_sub1 & sub1_mem_we & sub1_v_alpha)  | (own_sub2 & sub2_mem_we & sub2_v_alpha);
    wire we_view_lo   = (own_z80 & vram_wr & z80_v_view)   | (own_sub1 & sub1_mem_we & sub1_v_view)   | (own_sub2 & sub2_mem_we & sub2_v_view);
    wire we_view_hi   =                                       (own_sub1 & sub1_mem_we & sub1_v_view)   | (own_sub2 & sub2_mem_we & sub2_v_view);

    // Port-A registered reads (_qa, muxed CPU side) + Port-B scanout reads (_qb)
    reg [7:0] sprite_hi_qa, sprite_lo_qa, sprite_hi_qb, sprite_lo_qb;
    reg [7:0] road_hi_qa,   road_lo_qa,   road_hi_qb,   road_lo_qb;
    reg [7:0] alpha_hi_qa,  alpha_lo_qa,  alpha_hi_qb,  alpha_lo_qb;
    reg [7:0] view_hi_qa,   view_lo_qa,   view_hi_qb,   view_lo_qb;

    // ---- sprite (0x800 words, 11-bit) ----
    always @(posedge clk) begin
        if (we_sprite_lo) sprite_lo[pa_addr11] <= pa_wdlo;
        sprite_lo_qa <= sprite_lo[pa_addr11];
    end
    always @(posedge clk) begin
        if (we_sprite_hi) sprite_hi[pa_addr11] <= pa_wdhi;
        sprite_hi_qa <= sprite_hi[pa_addr11];
    end
    always @(posedge clk) begin
        sprite_lo_qb <= sprite_lo[scan_sprite_addr];
        sprite_hi_qb <= sprite_hi[scan_sprite_addr];
    end
    assign scan_sprite_dout = {sprite_hi_qb, sprite_lo_qb};

    // ---- road (0x400 words, 10-bit) ----
    always @(posedge clk) begin
        if (we_road_lo) road_lo[pa_addr10] <= pa_wdlo;
        road_lo_qa <= road_lo[pa_addr10];
    end
    always @(posedge clk) begin
        if (we_road_hi) road_hi[pa_addr10] <= pa_wdhi;
        road_hi_qa <= road_hi[pa_addr10];
    end
    always @(posedge clk) begin
        road_lo_qb <= road_lo[scan_road_addr];
        road_hi_qb <= road_hi[scan_road_addr];
    end
    assign scan_road_dout = {road_hi_qb, road_lo_qb};

    // ---- alpha (0x400 words, 10-bit) ----
    always @(posedge clk) begin
        if (we_alpha_lo) alpha_lo[pa_addr10] <= pa_wdlo;
        alpha_lo_qa <= alpha_lo[pa_addr10];
    end
    always @(posedge clk) begin
        if (we_alpha_hi) alpha_hi[pa_addr10] <= pa_wdhi;
        alpha_hi_qa <= alpha_hi[pa_addr10];
    end
    always @(posedge clk) begin
        alpha_lo_qb <= alpha_lo[scan_alpha_addr];
        alpha_hi_qb <= alpha_hi[scan_alpha_addr];
    end
    assign scan_alpha_dout = {alpha_hi_qb, alpha_lo_qb};

    // ---- view (0x800 words, 11-bit) ----
    always @(posedge clk) begin
        if (we_view_lo) view_lo[pa_addr11] <= pa_wdlo;
        view_lo_qa <= view_lo[pa_addr11];
    end
    always @(posedge clk) begin
        if (we_view_hi) view_hi[pa_addr11] <= pa_wdhi;
        view_hi_qa <= view_hi[pa_addr11];
    end
    always @(posedge clk) begin
        view_lo_qb <= view_lo[scan_view_addr];
        view_hi_qb <= view_hi[scan_view_addr];
    end
    assign scan_view_dout = {view_hi_qb, view_lo_qb};

    //------------------------------------------------------------------------
    //  Per-master Port-A read HOLDs. `_qa` at capture time reflects the addr
    //  driven onto Port-A on the PREVIOUS clk (registered read), i.e. the slot
    //  owner just before the boundary. Capture each master's read as its slot
    //  ends; the hold is then stable through that master's next CE:
    //    z80  slot 0..4  -> capture div==5  (qa = z80 read from div4)
    //    sub1 slot 5..9  -> capture div==10 (qa = sub1 read from div9); CE div5
    //    sub2 slot 10..15-> capture div==0  (qa = sub2 read from div15); CE div10
    //  Buffer select uses the master's decode (stable across its window), so it
    //  agrees with the rom/vram select used when din is consumed at the CE.
    //------------------------------------------------------------------------
    wire [15:0] sub1_vram_qa = sub1_v_sprite ? {sprite_hi_qa, sprite_lo_qa}
                             : sub1_v_road   ? {road_hi_qa,   road_lo_qa}
                             : sub1_v_alpha  ? {alpha_hi_qa,  alpha_lo_qa}
                             : sub1_v_view   ? {view_hi_qa,   view_lo_qa}
                             :                 16'hFFFF;
    wire [15:0] sub2_vram_qa = sub2_v_sprite ? {sprite_hi_qa, sprite_lo_qa}
                             : sub2_v_road   ? {road_hi_qa,   road_lo_qa}
                             : sub2_v_alpha  ? {alpha_hi_qa,  alpha_lo_qa}
                             : sub2_v_view   ? {view_hi_qa,   view_lo_qa}
                             :                 16'hFFFF;
    wire  [7:0] z80_vram_qa  = z80_v_sprite  ? sprite_lo_qa
                             : z80_v_road    ? road_lo_qa
                             : z80_v_alpha   ? alpha_lo_qa
                             : z80_v_view    ? view_lo_qa
                             :                 8'hFF;
    reg [15:0] sub1_vram_hold, sub2_vram_hold;
    reg  [7:0] z80_vram_hold;
    always @(posedge clk) begin
        if (div == 4'd10) sub1_vram_hold <= sub1_vram_qa;
        if (div == 4'd0 ) sub2_vram_hold <= sub2_vram_qa;
        if (div == 4'd5 ) z80_vram_hold  <= z80_vram_qa;
    end

    //------------------------------------------------------------------------
    //  Aux registers: per-CPU nvi_enable latch, shared hscroll/vscroll
    //------------------------------------------------------------------------
    reg nvi_en_sub1, nvi_en_sub2;
    always @(posedge clk) begin
        if (reset | ~sub1_reset_n) nvi_en_sub1 <= 1'b0;
        else if (sub1_mem_we & sub1_nvi_hit) nvi_en_sub1 <= sub1_dout[0];
    end
    always @(posedge clk) begin
        if (reset | ~sub2_reset_n) nvi_en_sub2 <= 1'b0;
        else if (sub2_mem_we & sub2_nvi_hit) nvi_en_sub2 <= sub2_dout[0];
    end

    reg [15:0] hscroll_r, vscroll_r;
    always @(posedge clk) begin
        if (reset) hscroll_r <= 16'h0000;
        else if (sub1_mem_we & sub1_hs_hit) hscroll_r <= sub1_dout;
        else if (sub2_mem_we & sub2_hs_hit) hscroll_r <= sub2_dout;
    end
    always @(posedge clk) begin
        if (reset) vscroll_r <= 16'h0000;
        else if (sub1_mem_we & sub1_vs_hit) vscroll_r <= sub1_dout;
        else if (sub2_mem_we & sub2_vs_hit) vscroll_r <= sub2_dout;
    end
    assign hscroll = hscroll_r;
    assign vscroll = vscroll_r;

    //------------------------------------------------------------------------
    //  NVI level-hold: (re)armed at each sub_nvi_trig pulse, gated by that
    //  CPU's nvi_enable at that instant; held until the next trigger.
    //------------------------------------------------------------------------
    reg nvi_latch_sub1, nvi_latch_sub2;
    always @(posedge clk) begin
        if (reset | ~sub1_reset_n) nvi_latch_sub1 <= 1'b0;
        else if (sub_nvi_trig)     nvi_latch_sub1 <= nvi_en_sub1;
    end
    always @(posedge clk) begin
        if (reset | ~sub2_reset_n) nvi_latch_sub2 <= 1'b0;
        else if (sub_nvi_trig)     nvi_latch_sub2 <= nvi_en_sub2;
    end
    assign sub1_nvi_n = ~nvi_latch_sub1;
    assign sub2_nvi_n = ~nvi_latch_sub2;
    assign dbg1_nvi_n  = sub1_nvi_n;
    assign dbg2_nvi_n  = sub2_nvi_n;
    assign dbg1_nvi_en = nvi_en_sub1;
    assign dbg2_nvi_en = nvi_en_sub2;

    //------------------------------------------------------------------------
    //  Sub CPU / Z80 read-data muxes. VRAM data comes from the per-master
    //  Port-A read HOLD (registered one CE-period earlier == the z8002 memory
    //  contract). The rom/vram select uses the CURRENT addr, which still points
    //  at the same window's access being consumed this CE. ROM read is a direct
    //  registered fetch (dedicated Port-B, no slot). Unmapped => hold defaults
    //  (16'hFFFF / 8'hFF) preserved inside the *_vram_qa muxes above.
    //------------------------------------------------------------------------
    assign sub1_din = sub1_rom_sel ? sub1_rom_rd : sub1_vram_hold;
    assign sub2_din = sub2_rom_sel ? sub2_rom_rd : sub2_vram_hold;
    assign vram_din = z80_vram_hold;

    // scan_*_dout (port B) are driven registered inside each buffer block above.

endmodule

`default_nettype wire
