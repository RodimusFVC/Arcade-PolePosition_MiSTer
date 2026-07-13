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

    //------------------------------------------------------------------------
    //  Sub program ROMs — 8K words each (0x0000-0x3FFF word-addr range),
    //  hi/lo byte-split so ioctl byte writes never need an array-element
    //  bit-select. Loaded from the index-0 stream: sub1@0x3000(0x4000 B),
    //  sub2@0x7000(0x4000 B); even dn_addr=HIGH byte, odd=LOW (big-endian).
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

    always @(posedge clk) begin
        if (sub1_ld_hit) begin
            if (sub1_ld_hi) rom1_hi[sub1_ld_idx] <= dn_data;
            else            rom1_lo[sub1_ld_idx] <= dn_data;
        end
        if (sub2_ld_hit) begin
            if (sub2_ld_hi) rom2_hi[sub2_ld_idx] <= dn_data;
            else            rom2_lo[sub2_ld_idx] <= dn_data;
        end
    end

    wire [15:0] sub1_rom_rd = {rom1_hi[sub1_rom_idx], rom1_lo[sub1_rom_idx]};
    wire [15:0] sub2_rom_rd = {rom2_hi[sub2_rom_idx], rom2_lo[sub2_rom_idx]};

    //------------------------------------------------------------------------
    //  Shared VRAM buffers — hi/lo byte-split, one buffer = one always block
    //  doing priority-arbitrated writes (Z80 > sub1 > sub2); reads are
    //  continuous combinational taps per consumer.
    //------------------------------------------------------------------------
    reg [7:0] sprite_hi [0:2047];
    reg [7:0] sprite_lo [0:2047];
    reg [7:0] road_hi   [0:1023];
    reg [7:0] road_lo   [0:1023];
    reg [7:0] alpha_hi  [0:1023];
    reg [7:0] alpha_lo  [0:1023];
    reg [7:0] view_hi   [0:2047];
    reg [7:0] view_lo   [0:2047];

    integer i;
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

    // ---- sprite (0x800 words) ----
    wire z80_we_sprite  = vram_wr & z80_v_sprite;
    wire sub1_we_sprite = sub1_mem_we & sub1_v_sprite;
    wire sub2_we_sprite = sub2_mem_we & sub2_v_sprite;
    // DIAG-REVERT-2026-07-12: original priority-arbitrated single write port
    // (Z80 > sub1 > sub2) silently DROPPED a sub2 write whenever sub1 wrote
    // to this same buffer (any index) in the same clock -- confirmed by bisect
    // (verilator_subcpu vs verilator/z8002.sv): sub2's ROM checksum passes
    // identically in both co-sims, but sub2's VRAM write/read-back pattern
    // test at 0x287E/0x2880 (see pp_sub2.asm) only fails when sub1 runs
    // concurrently; holding sub1 in reset let sub2 run past it cleanly. Real
    // dual-port VRAM has independent write ports per master for non-conflicting
    // addresses, so give each writer (Z80/sub1/sub2) its own always block
    // instead of chaining them behind one if/else-if (only same-cycle+
    // same-index writes from two masters remain a genuine, rare race, same
    // as real hardware would have).
    // always @(posedge clk) begin
    //     if (z80_we_sprite)
    //         sprite_lo[z80_idx11] <= vram_dout;
    //     else if (sub1_we_sprite) begin
    //         sprite_hi[sub1_idx11] <= sub1_dout[15:8];
    //         sprite_lo[sub1_idx11] <= sub1_dout[7:0];
    //     end else if (sub2_we_sprite) begin
    //         sprite_hi[sub2_idx11] <= sub2_dout[15:8];
    //         sprite_lo[sub2_idx11] <= sub2_dout[7:0];
    //     end
    // end
    always @(posedge clk) if (z80_we_sprite) sprite_lo[z80_idx11] <= vram_dout;
    always @(posedge clk) if (sub1_we_sprite) begin
        sprite_hi[sub1_idx11] <= sub1_dout[15:8];
        sprite_lo[sub1_idx11] <= sub1_dout[7:0];
    end
    always @(posedge clk) if (sub2_we_sprite) begin
        sprite_hi[sub2_idx11] <= sub2_dout[15:8];
        sprite_lo[sub2_idx11] <= sub2_dout[7:0];
    end
    wire [15:0] sprite_rd_sub1 = {sprite_hi[sub1_idx11], sprite_lo[sub1_idx11]};
    wire [15:0] sprite_rd_sub2 = {sprite_hi[sub2_idx11], sprite_lo[sub2_idx11]};
    wire  [7:0] sprite_rd_z80  = sprite_lo[z80_idx11];
    wire [15:0] sprite_rd_scan = {sprite_hi[scan_sprite_addr], sprite_lo[scan_sprite_addr]};

    // ---- road (0x400 words) ----
    wire z80_we_road  = vram_wr & z80_v_road;
    wire sub1_we_road = sub1_mem_we & sub1_v_road;
    wire sub2_we_road = sub2_mem_we & sub2_v_road;
    // DIAG-REVERT-2026-07-12: same fix as sprite buffer above -- independent
    // per-writer always blocks instead of one priority-arbitrated block.
    // always @(posedge clk) begin
    //     if (z80_we_road)
    //         road_lo[z80_idx10] <= vram_dout;
    //     else if (sub1_we_road) begin
    //         road_hi[sub1_idx10] <= sub1_dout[15:8];
    //         road_lo[sub1_idx10] <= sub1_dout[7:0];
    //     end else if (sub2_we_road) begin
    //         road_hi[sub2_idx10] <= sub2_dout[15:8];
    //         road_lo[sub2_idx10] <= sub2_dout[7:0];
    //     end
    // end
    always @(posedge clk) if (z80_we_road) road_lo[z80_idx10] <= vram_dout;
    always @(posedge clk) if (sub1_we_road) begin
        road_hi[sub1_idx10] <= sub1_dout[15:8];
        road_lo[sub1_idx10] <= sub1_dout[7:0];
    end
    always @(posedge clk) if (sub2_we_road) begin
        road_hi[sub2_idx10] <= sub2_dout[15:8];
        road_lo[sub2_idx10] <= sub2_dout[7:0];
    end
    wire [15:0] road_rd_sub1 = {road_hi[sub1_idx10], road_lo[sub1_idx10]};
    wire [15:0] road_rd_sub2 = {road_hi[sub2_idx10], road_lo[sub2_idx10]};
    wire  [7:0] road_rd_z80  = road_lo[z80_idx10];
    wire [15:0] road_rd_scan = {road_hi[scan_road_addr], road_lo[scan_road_addr]};

    // ---- alpha (0x400 words) ----
    wire z80_we_alpha  = vram_wr & z80_v_alpha;
    wire sub1_we_alpha = sub1_mem_we & sub1_v_alpha;
    wire sub2_we_alpha = sub2_mem_we & sub2_v_alpha;
    // DIAG-REVERT-2026-07-12: same fix as sprite buffer above -- independent
    // per-writer always blocks instead of one priority-arbitrated block.
    // always @(posedge clk) begin
    //     if (z80_we_alpha)
    //         alpha_lo[z80_idx10] <= vram_dout;
    //     else if (sub1_we_alpha) begin
    //         alpha_hi[sub1_idx10] <= sub1_dout[15:8];
    //         alpha_lo[sub1_idx10] <= sub1_dout[7:0];
    //     end else if (sub2_we_alpha) begin
    //         alpha_hi[sub2_idx10] <= sub2_dout[15:8];
    //         alpha_lo[sub2_idx10] <= sub2_dout[7:0];
    //     end
    // end
    always @(posedge clk) if (z80_we_alpha) alpha_lo[z80_idx10] <= vram_dout;
    always @(posedge clk) if (sub1_we_alpha) begin
        alpha_hi[sub1_idx10] <= sub1_dout[15:8];
        alpha_lo[sub1_idx10] <= sub1_dout[7:0];
    end
    always @(posedge clk) if (sub2_we_alpha) begin
        alpha_hi[sub2_idx10] <= sub2_dout[15:8];
        alpha_lo[sub2_idx10] <= sub2_dout[7:0];
    end
    wire [15:0] alpha_rd_sub1 = {alpha_hi[sub1_idx10], alpha_lo[sub1_idx10]};
    wire [15:0] alpha_rd_sub2 = {alpha_hi[sub2_idx10], alpha_lo[sub2_idx10]};
    wire  [7:0] alpha_rd_z80  = alpha_lo[z80_idx10];
    wire [15:0] alpha_rd_scan = {alpha_hi[scan_alpha_addr], alpha_lo[scan_alpha_addr]};

    // ---- view (0x800 words) ----
    wire z80_we_view  = vram_wr & z80_v_view;
    wire sub1_we_view = sub1_mem_we & sub1_v_view;
    wire sub2_we_view = sub2_mem_we & sub2_v_view;
    // DIAG-REVERT-2026-07-12: same fix as sprite buffer above -- independent
    // per-writer always blocks instead of one priority-arbitrated block.
    // always @(posedge clk) begin
    //     if (z80_we_view)
    //         view_lo[z80_idx11] <= vram_dout;
    //     else if (sub1_we_view) begin
    //         view_hi[sub1_idx11] <= sub1_dout[15:8];
    //         view_lo[sub1_idx11] <= sub1_dout[7:0];
    //     end else if (sub2_we_view) begin
    //         view_hi[sub2_idx11] <= sub2_dout[15:8];
    //         view_lo[sub2_idx11] <= sub2_dout[7:0];
    //     end
    // end
    always @(posedge clk) if (z80_we_view) view_lo[z80_idx11] <= vram_dout;
    always @(posedge clk) if (sub1_we_view) begin
        view_hi[sub1_idx11] <= sub1_dout[15:8];
        view_lo[sub1_idx11] <= sub1_dout[7:0];
    end
    always @(posedge clk) if (sub2_we_view) begin
        view_hi[sub2_idx11] <= sub2_dout[15:8];
        view_lo[sub2_idx11] <= sub2_dout[7:0];
    end
    wire [15:0] view_rd_sub1 = {view_hi[sub1_idx11], view_lo[sub1_idx11]};
    wire [15:0] view_rd_sub2 = {view_hi[sub2_idx11], view_lo[sub2_idx11]};
    wire  [7:0] view_rd_z80  = view_lo[z80_idx11];
    wire [15:0] view_rd_scan = {view_hi[scan_view_addr], view_lo[scan_view_addr]};

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
    //  Sub CPU read-data muxes
    //------------------------------------------------------------------------
    assign sub1_din =
        sub1_rom_sel  ? sub1_rom_rd    :
        sub1_v_sprite ? sprite_rd_sub1 :
        sub1_v_road   ? road_rd_sub1   :
        sub1_v_alpha  ? alpha_rd_sub1  :
        sub1_v_view   ? view_rd_sub1   :
        16'hFFFF;

    assign sub2_din =
        sub2_rom_sel  ? sub2_rom_rd    :
        sub2_v_sprite ? sprite_rd_sub2 :
        sub2_v_road   ? road_rd_sub2   :
        sub2_v_alpha  ? alpha_rd_sub2  :
        sub2_v_view   ? view_rd_sub2   :
        16'hFFFF;

    //------------------------------------------------------------------------
    //  Z80 byte-port read mux
    //------------------------------------------------------------------------
    assign vram_din =
        z80_v_sprite ? sprite_rd_z80 :
        z80_v_road   ? road_rd_z80   :
        z80_v_alpha  ? alpha_rd_z80  :
        z80_v_view   ? view_rd_z80   :
        8'hFF;

    //------------------------------------------------------------------------
    //  Scanout (port B): 4 independent word-wide read ports (all combinational,
    //  read concurrently — buffers are behavioral byte-array pairs so parallel
    //  reads are free). Each renderer drives its own address, gets its own data.
    //------------------------------------------------------------------------
    assign scan_sprite_dout = sprite_rd_scan;
    assign scan_road_dout   = road_rd_scan;
    assign scan_alpha_dout  = alpha_rd_scan;
    assign scan_view_dout   = view_rd_scan;

endmodule

`default_nettype wire
