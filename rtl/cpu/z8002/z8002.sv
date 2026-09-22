// ============================================================================
//  z8002.sv  —  Zilog Z8002 (non-segmented Z8000) CPU core
//  Greenfield core for Arcade-PolePosition_MiSTer.  SystemVerilog, Verilator-clean.
//
//  References: MAME z8000ops.hxx / z8000tbl.hxx / z8000cpu.h (behavioral oracle).
//
//  ============================================================================
//  ★ NOT YET IMPLEMENTED — what's left to make this a FULL Z8000 core ★
//  ----------------------------------------------------------------------------
//  This core is COMPLETE for everything Pole Position exercises: both sub ROMs
//  co-sim-run to completion (pp_sub1 ~15M / pp_sub2 ~12M retires @30M cyc, ZERO
//  dbg_illegal), and the NVI/ISR/IRET selftest passes. Every item below is
//  DELIBERATELY unbuilt and is UNREACHABLE by PP — its ROMs never execute these
//  and its wiring ties the relevant pins inactive. Scope decision 2026-07-18:
//  "close reachable gaps only". Reusing this core for a DIFFERENT Z8000 game (or
//  wanting a truly complete Z8002) means building the pieces below.
//
//  --- OPCODES (all route to S_ILLEGAL; see the catch-all near the 0xC handler) ---
//    0x30-0x37  load-relative / base+displacement (LDR/LDRB/LDRL, LDB base+disp)
//    0x38-0x3F  I/O + block I/O (IN/OUT/INB/OUTB/SIN/SOUT/SINB/SOUTB,
//               INIR/OTIR/INDR/OTDR/...) - no I/O device on the PP sub-CPUs
//    0x70-0x77  base+index loads, LDA/LDAR (load-address)
//    0x79       LDPS (load program status)                     [privileged]
//    0x7A       HALT                                           [privileged]
//    0x7B       MSET/MRES/MBIT/MREQ (multi-micro)  -- NOTE 0x7B00 IRET IS done
//    0x7D       LDCTL: FCW(2)+PSAPOFF(5) done; REFRESH(3)/NSPOFF(7)/seg = no-op
//    0x7E/0x7F  extended / SC (system-call trap)
//    0xB8/BA/BB block transfer / compare / translate strings (LDIR/CPIR/TRIB/...)
//    0x0E/0F/4E/8E/8F  EPU extended instructions  -- no EPU present
//    (Also: one 0x4D0x direct-address sub-op default traps -- implemented 0x4D
//     sub-ops are STI/CLR/TST; the rest are unused by PP.)
//
//  --- NON-OPCODE (chip machinery -- a CPU is more than its decode) ---
//    VI  (vectored interrupt)  vi_n pin exists but sits in the _unused sink: NO
//        accept path, NO vector-byte acknowledge cycle. PP ties vi_n inactive
//        (matches MAME: subs take NVI ONLY, asserted at vblank scanline 240).
//    NMI                       nmi_n pin in _unused sink; no accept path. PP ties
//        nmi_n inactive. (NVI itself is FULLY implemented + selftest-proven.)
//    Traps                     SC / privileged / extended-instruction / segment:
//        NO trap-vectoring infrastructure (tied to the trapped opcodes above).
//    Normal/System SP (FCW.S_N) single hardware SP; S_N never toggles here, so no
//        NSP<->SSP swap on mode change or interrupt entry.
//    wait_n                    NOT honored (in _unused sink); memory assumed
//        zero-wait (BRAM). A slow/shared bus would need real wait handling.
//    iorq                      output pin exists but is never driven (no I/O ops).
//    REFRESH                   LDCTL REFRESH accepted as a no-op (no DRAM here).
//    Segmentation (Z8001)      absent by design -- this is the Z8002 (non-seg) part.
//  ============================================================================
//
//  Baked-in (verified vs MAME): BIG-ENDIAN (word@A={mem[A]hi,mem[A+1]lo}); PC even;
//  SP=R15; 16x16 regfile, byte reg n -> R[n&7] HIGH if n<8 else LOW; FCW C=b7 Z=b6
//  S=b5 P/V=b4 DA=b3 H=b2 ; reset reads FCW@mem[2], PC@mem[4].
//
//  MICROSEQUENCER: S_FETCH0 decodes -> operand from reg (latched) / imm (S_IMM) /
//  mem (S_MEMRD) -> S_ALU applies aluop.  Stores via S_MEMWR.  Shifts S_SHIFT,
//  jumps S_JP.  Byte ADDB@rs keeps its own S_ADDB_RD.  Undecoded op -> S_ILLEGAL.
//
//  STATUS: runs sub1 ROM checksum self-test + init.  Opcodes (encodings/flags from
//  z8000ops.hxx): LD #imm/@rs/rs, CLR, ADDB@rs, INC, INCB, DJNZ/DBJNZ, JR cc,
//  ADD/SUB/AND/OR/XOR/CP (rs / #imm / @rs, word), SLL/SRL #imm, LD @rd,rs, JP cc.
//
//  BATCH 1 (stack + control flow) added: CALL addr/@Rd, CALR, RET cc, PUSH @Rd,{Rs|
//  imm16|addr}, POP {Rd|addr},@Rs, PUSHL @Rd,RRs, POPL RRd,@Rs, LDL RRd,{RRs|imm32|
//  @Rs|addr} / LDL {@Rd|addr},RRs, LDM {rd,@rs,n | @rd,rs,n}. Direct-addressed forms
//  only (no register-indexed addr(Rx) EA). RRn register-pair select truncates bit0
//  (RRn = R[n&0xE]:R[n&0xE+1]) -- authority is MAME z8000cpu.h:41
//  `#define RL(n) m_regs.L[BYTE_XOR_BE((n) >> 1)]`, i.e. bit0 of the nibble is
//  discarded. NOTE: do NOT "confirm" this from pp_sub1.asm odd-pair sightings --
//  the ones near $12F2 are the disassembler decoding an ASCII STRING TABLE as code
//  ("TIME"/"ON"/"US 2" after the call at $12EE). Trust z8000cpu.h, not the dasm there.
//
//  BATCH 2 added: PART A -- the indirect-indirect stack family PUSHL/PUSH/POPL/POP
//  @Rd,@Rs (0x11/0x13/0x15/0x17); PART B -- SUBB/ORB/ANDB/XORB/CPB/LDB (#imm8/@rs/
//  rbd,rbs, incl. ADDB's own missing #imm8/reg-reg sub-forms), LDB @Rd,rbs store,
//  JP cc,@Rd, CPL rrd,{@rs|rrs}, BITB/BIT @Rd,#imm4 (read-only), RES/SET @Rd,#imm4
//  (word), EX rd,@rs (word). Byte flag formulas verified vs z8000ops.hxx per-op
//  (ORB/ANDB/XORB set P/V as PARITY, not overflow). Byte MEMORY WRITES (LDB store,
//  RES/SET/EXB word forms would be fine but their BYTE forms RESB/SETB/EXB are NOT
//  implemented) use word-aligned read-modify-write because `wordacc` is left
//  unconnected downstream (PolePosition_subcpu.sv #deviation comment) -- a bare
//  byte-lane write would silently clobber the neighboring byte on the current bus
//  wiring. MULT/DIV/MULTL/DIVL, ADDL/SUBL, and all register-indexed addr(Rx)/direct-
//  address ALU forms (0x40-0x4B family) are NOT implemented this batch (see report).
//
//  BATCH 3 added: INC/DEC addr,#n direct (0x69/0x6B, NIB2=0 only -- indexed addr(Rx)
//  form still has no EA datapath, deferred per policy); MULT/DIV rrd,{#imm16|@rs|rs}
//  (0x19/0x1B + reg-reg 0x99/0x9B) and MULTL/DIVL rqd,{@rs|rrs} (0x18/0x1A indirect +
//  reg-reg 0x98/0x9A -- imm32 sub-forms skipped, zero real ROM occurrences); ADDL/SUBL
//  rrd,{#imm32|@rs|rrs} (0x16/0x12 + reg-reg 0x96/0x92, full coverage); LDB rbd,addr
//  direct-load (0x60, NIB2=0) and LDB addr,rbs direct-store (0x6E, NIB2=0, RMW per the
//  wordacc rule); CLRB/TESTB rbd (0x8Cd8/0x8Cd4 -- the ONLY two of 0x8C's 7 static
//  sub-ops actually used); RLB/RRB/RRCB rbd,#1|#2 + SLLB/SRLB rbd,#imm8 (0xB2 family,
//  register-only, no memory access); CPL rrd,addr direct (0x50, NIB2=0 only). RQ(n)
//  (quad/64-bit register group for MULTL/DIVL) truncates n's LOW TWO bits (MAME
//  `#define RQ(n) m_regs.Q[(n)>>2]`) -- base = {n[3:2],2'b00}, big-endian word order
//  R[base]:R[base+1]:R[base+2]:R[base+3] MSW-first (verified structurally consistent
//  with RL(n)'s already-established bit0-truncation, just one level wider). DIV/DIVL
//  use Verilog's native signed `/`/`%` (truncate-toward-zero, remainder takes the
//  dividend's sign) which is algebraically IDENTICAL to MAME's manual abs/sign-restore
//  dance in DIVW/DIVL -- verified term-by-term, not assumed. MULTW/MULTL's doc-comment
//  says flags "CZSV--" but neither function body ever calls SET_V (only CLR_CZSV) --
//  V is always cleared for MULT/MULTL, never set; trusted the code over the comment
//  (see report). Register-indexed addr(Rx) EA remains undatapathed and is still
//  skipped everywhere (costs real coverage on LDB-load 0x60 [3/32 uses direct] and
//  CPL 0x50 [3/23 uses direct] -- see report, flagged as a good Batch 4 candidate).
//
//  BATCH 4 added the register-indexed addr(Rx) EA DATAPATH (the deferred item above):
//  `idxr` (new 4-bit reg) latches NIB2 at decode; four new *X_FETCH states (one per
//  family) compute ea<=din+R[idxr] the same cycle the addr word is fetched, then join
//  the EXISTING, byte-for-byte-unmodified direct-form RD/WR states -- LDB rbd,addr(Rs)
//  load (0x60,NIB2!=0), LDB addr(Rs),rbs store (0x6E,NIB2!=0, RMW), CPL rrd,addr(Rs)
//  (0x50,NIB2!=0), INC/DEC addr(Rs),#n (0x69/0x6B,NIB2!=0). Index nibble confirmed at
//  NIB2 for all five vs z8000ops.hxx (matches the task brief). Also added (register-
//  only, zero/near-zero marginal states): NEG rd (0x8Dd2) + COM rd (0x8Dd0, same 0x8D
//  dispatch as the existing CLR); EXTSB rd (0xB1d0) + EXTS rrd (0xB1dA); EXB rbd,rbs
//  reg-reg (0xAC). New byte-RMW pairs (S_RESETB_RD/WR, S_EXB_RD/WR): RESB/SETB
//  @Rd,#imm4 (0x22/0x24,NIB2!=0, share bmask/bitop_set with the existing word RES/SET)
//  and EXB rbd,@rs (0x2C,NIB2!=0, mirrors EX + the LDB-store byte-merge pattern). ADC/
//  ADCB/SBC/SBCB rd,rs (0xB5/0xB4/0xB7/0xB6, reg-reg only -- no memory-form exists in
//  the real ISA, confirmed against the table) added inline in S_FETCH0; C/H computed as
//  carry/borrow-out of an explicit 9-bit/5-bit add-or-sub-with-carry-in (`nibc`, new
//  scratch), proven equivalent to CHK_ADCX_C/CHK_ADCB_H's roundabout C form rather than
//  transliterated. CORRECTIONS TO PREVIOUS-BATCH / TASK-BRIEF ASSUMPTIONS (see report):
//  the task brief's "TSET/TSETB ~suggested" register-direct form (0x8Dd6) has ZERO real
//  ROM occurrences -- every real TSET/TSETB use is the register-INDIRECT @Rd form (a
//  DIFFERENT encoding, 0x0D/0x0C family) needing its own new RMW datapath; skipped
//  entirely, not just the register form. "EXTS/EXTSB ~82 combined" was wrong -- real
//  combined usage is 16 (9+7). Discovered mid-batch: 0x62-0x67/0x6C-0x6D are a SECOND,
//  separate direct-address(+index) family for BIT/BITB/RES/SET/RESB/SETB/EXB/EX (addr
//  and addr(Rx) forms, same EA shape as this batch's datapath) with ~82 combined real
//  uses (RES 17,SET 25,BIT 25,BITB 6,RESB 4,SETB 5,EXB 4,EX ~unmeasured) -- NOT wired
//  this batch (out of the task brief's explicit scope, which named only the 0x22/0x24/
//  0x2C register-indirect forms), flagged as the strongest Batch 5 candidate since it
//  would reuse this batch's exact *_FETCH+index-add pattern at near-zero marginal cost.
//
//  BATCH 5 built exactly that: the direct-address(+index) RESB/RES/SETB/SET/BITB/BIT/EXB/EX
//  family (0x62-0x67, 0x6C-0x6D), all eight mnemonics, both the direct (NIB2=din[7:4]=0) and
//  register-indexed (NIB2!=0, addr(Rx), reusing Batch 4's ea<=din+R[idxr] shape) forms.
//  GET_BIT/GET_DST(OP0,NIB3) (z8000cpu.h) put the bit-index/exchange-value field at NIB3
//  (din[3:0]) for ALL EIGHT opcodes regardless of NIB2, confirmed per-handler in
//  z8000ops.hxx. RES/SET (0x63/0x65, word) share one state pair via bitop_set, mirroring the
//  existing register-indirect S_BITW_RD/WR; RESB/SETB (0x62/0x64, byte) share one word-
//  aligned RMW pair (wordacc rule) mirroring S_RESETB_RD/WR, lane=ea[0] (the fetched
//  address' LSB, NOT a register bit -- same convention as S_LDBDA_RD/S_RESETB_WR). BIT/BITB
//  (0x67/0x66) are read-only (flags -Z----, own FETCH/RD only, no WR). EX/EXB (0x6D/0x6C)
//  are exchanges (own FETCH/RD/WR, `dst`=NIB3=value register(-code), reusing the EXISTING
//  `exb_val` wire unchanged since it's already generic on `dst`). Also added EX rd,rs
//  reg-reg (0xAD, full range, register-only) alongside, mirroring the already-implemented
//  EXB reg-reg (0xAC).
//  ROM-USAGE CORRECTION (measured properly this batch, see report): the 0x38A0-0x3E08 span
//  in ALL FOUR pp*_sub*.asm files is a DATA TABLE (raw incrementing byte values -- e.g.
//  0x6C,0x6D,0x6E,0x6F = ASCII "l","m","n","o" -- confirmed by manual inspection: the
//  "instructions" there don't form coherent flow, unlike the real code immediately before
//  it) misdecoded as plausible opcodes; EVERY apparent RESB/BITB/EXB hit and several
//  RES/SET/BIT hits previously counted were inside this table and are FALSE POSITIVES (this
//  is the file header's own TRAP-1 warning, caught in the act). Excluding that span, REAL
//  confirmed usage is BIT 52 (47 direct+5 indexed), SET 43 (all direct), RES 22 (21
//  direct+1 indexed), EX 6 (all indexed -- direct form unused), SETB 1 (direct), EX(0xAD
//  reg-reg) 3; RESB/BITB/EXB have ZERO confirmed real hits. Implemented all eight anyway
//  (RESB/BITB/EXB ride for free on their required siblings' state machinery) to close the
//  whole range rather than leave a partial family with stray S_ILLEGAL traps.
//
//  BATCH 5 PART 2 (task item 2, budget permitting) added the register-indirect @Rd "simple"
//  family (0x0C byte / 0x0D word, dst=NIB2, sub-op selector=NIB3): TESTB/TSETB/CLRB @rd
//  (0x0C, NIB3=4/6/8) and COM/CP-imm16/NEG/TEST/TSET/CLR @rd (0x0D, NIB3=0/1/2/4/6/8) --
//  explicitly named item-2 candidates ("register-indirect NEG/COM", "TSET/TSETB register-
//  indirect"). All gated NIB2(dst)!=0 (z8000tbl.hxx's table range starts at NIB2=1 --
//  dst=R0 is undefined for this whole family); flags/RMW formulas copied unchanged from
//  their already-verified register-direct siblings (TESTB/COM/NEG) or the existing word CP
//  aluop. `state` widened from 7 to 8 bits (max value crossed 127) -- the one non-purely-
//  additive line touched this batch, flagged per the task brief. SKIPPED: COMB @rd (0x0C,
//  NIB3=0) -- z8000ops.hxx's handler reads GET_DST(OP0,NIB3) instead of NIB2 like every
//  sibling sub-op, which (since NIB3 is the fixed sub-op-selector, always 0 here) means MAME
//  itself always resolves dst=R0 for this one opcode -- looks like a genuine MAME source
//  bug, not real hardware behavior; only 1 real ROM occurrence anyway, not worth the
//  ambiguity (see report). NEGB/CPB-imm8/LDB-imm8 @rd: zero confirmed real occurrences,
//  skipped. Also flagged (not fixed, out of scope): the pre-existing baseline LD @rd,#imm16
//  arm (0x0D/NIB3=5) lacks the NIB2!=0 guard that every sibling in this family needs.
//
//  BATCH 6 (this session; the incoming task brief called it "Batch 5" but that name was
//  already used above by real prior history in this file, so the new work is numbered
//  6 to keep the log unambiguous -- see report). Full mechanical set-diff against
//  z8000tbl.hxx's 519 real rows found the decode MUCH further along than the task brief
//  assumed (its named "still-deferred" items -- RESB/SETB/EXB register-indirect, LDB/
//  CPL/INC/DEC indexed EA -- were already done in Batches 4-5 above) but also turned up a
//  large amount of genuinely new territory the brief never named. Implemented this batch,
//  all ADDITIVE, all reusing existing datapaths: (1) 0x40-0x4B ALU addr[,(rs)] direct/
//  indexed (ADDB/ADD/SUBB/SUB/ORB/OR/ANDB/AND/XORB/XOR/CPB/CP, dest always a register --
//  the task brief's explicit item 1); (2) 0x1000-0x100F CPL rrd,imm32 (explicit item 2);
//  (3) 0x28-0x2B register-indirect INCB/INC/DECB/DEC @rd; (4) 0x68/0x6A byte INC/DEC
//  addr[,(rs)],#n (byte siblings of the already-done word 0x69/0x6B); (5) missing indexed
//  arms for LD rd,addr(rs) / LD addr(rs),rs (0x61/0x6F, direct forms were already done);
//  (6) a large sweep of register-only, zero-memory-access closures: 0x8C remaining sub-ops
//  (COMB/NEGB/TSETB/LDCTLB-read/LDCTLB-write), 0x8D remaining sub-ops (NOP/TEST/TSET/
//  SETFLG/RESFLG/COMFLG), 0x9C TESTL, 0xA2-0xA7 register-direct RESB/RES/SETB/SET/BITB/
//  BIT rd,imm4, 0xAE/0xAF TCCB/TCC, 0xBC/0xBD/0xBE RLDB/LDK/RRDB, 0xB1d7 EXTSL, and
//  0xC0-0xCF LD rd,imm8 short form (single-word, dst=NIB1, imm8=the SAME word's low byte).
//  RLDB/RRDB were traced term-by-term through the actual MAME C body (not the mnemonic's
//  naive "rotate" implication) -- RLDB's second register (b) algebraically comes out
//  UNCHANGED (tmp captured before any write, then re-OR'd back into itself); RRDB's does
//  not. `state` unchanged at 8 bits (new max 158, still under 255).
//
//  EXPLICITLY DEFERRED, NOT IMPLEMENTED, WITH JUSTIFICATION (see report for the full
//  per-family breakdown): 0x30-0x35/0x37 LDRB/LDR/LDRL/LDA/LDAR relative(dsp16 PC-
//  relative)+indexed(idx16) -- CONFIRMED real usage in both sub ROMs (ldr/lda/ldar/ldrb
//  disassemble at matching addresses in both subs, i.e. genuine shared code, not the
//  file's known data-table false-positive span) but needs a NEW PC-relative EA style;
//  strongest next-batch candidate. 0x4C/0x4D/0x4E static-op/LDB-store direct+indexed
//  address family (COM/CP-imm/NEG/TEST/LD-imm/TSET/CLR byte+word @addr, mirrors the
//  already-built 0x0C/0x0D register-indirect siblings almost exactly) -- large (~30+
//  states), modest confirmed usage, deferred for batch-size discipline. 0x51-0x5C(+5D/5F
//  indexed) PUSHL/POPL/SUBL/ADDL/MULTL/DIVL/MULT/DIV-vs-address forms, direct-address LDM,
//  TESTL-addr -- large brand-new family, usage not yet measured. 0x70-0x77 Rx register+
//  register-indexed family (EA=Rbase+Ridx, a third new addressing-mode category) -- only
//  1 confirmed hit (LDA/0x74, identical in both subs); the other 6 siblings show zero,
//  and a partial family would leave the exact "stray S_ILLEGAL trap" the project's own
//  precedent warns against, so deferred whole. 0xB0 DAB rbd -- CONFIRMED real usage (15
//  hits in sub1, clustered as BCD-adjacent register pairs, zero false-positive risk) but
//  needs the literal 2048-entry Z8000_dab[] ROM table (z8000dab.h) transcribed faithfully
//  (the generator's own makedab.cpp has a confirmed operator-precedence bug baked into the
//  checked-in table -- must transcribe the ACTUAL table, not re-derive the "intended"
//  algorithm); flagged HIGH PRIORITY next batch given confirmed usage. 0xB8 TRxB/TRTxB
//  translate-block and 0xBA/0xBB CPxx/CPxxR/LDxx/LDxxR compare/move-block -- complex
//  multi-condition self-repeating block primitives, zero confirmed usage, out of scope.
//  Genuinely PRIVILEGED/EPU/reserved, skipped like the existing refresh/nspseg/nspoff
//  precedent (not silently trapped -- just never reachable by PP's normal-mode program):
//  0x0E/0x0F ext0e/ext0f (EPU, also the file's own documented false-positive trigger),
//  0x36 BPT+rsvd, 0x38/0x78/0x7E/0x8E/0x8F/0x9D/0x9F/0xB9/0xBF rsvd/EPU, 0x39/0x79 LDPS,
//  0x3A/0x3B I/O block, 0x3C-0x3F IN/OUT, 0x7A HALT, 0x7B08/09/0A/dddd_1101 MSET/MRES/
//  MBIT/MREQ (multiprocessor cascade lines), 0x7F SC (system-call trap -- needs new
//  vectoring infra this core doesn't have, zero expected arcade-sub-CPU usage).
// ============================================================================

module z8002
(
    input  wire        clk, ce, reset_n,
    output wire [15:0] addr,
    output wire [15:0] dout,
    input  wire [15:0] din,
    output wire        mreq, iorq, we, wordacc,
    input  wire        wait_n, nmi_n, nvi_n, vi_n,
    output wire [15:0]  dbg_pc, dbg_fcw, dbg_ir,
    output wire         dbg_retire, dbg_illegal,
    output wire [255:0] dbg_regs
);
    // FCW flag masks
    localparam [15:0] MC=16'h0080, MZ=16'h0040, MS=16'h0020, MV=16'h0010,
                      MDA=16'h0008, MH=16'h0004;
    localparam integer FC=7, FZ=6, FS=5, FV=4, FH=2, FDA=3;
    // FCW interrupt-enable masks (MAME z8000cpu.h): F_NVIE=bit11 F_VIE=bit12 F_S_N=bit14
    localparam [15:0] F_NVIE=16'h0800, F_VIE=16'h1000, F_S_N=16'h4000;
    // ALU ops
    localparam [2:0] LD=0, ADD=1, SUB=2, AND=3, OR=4, XOR=5, CP=6;

    reg [15:0] R [0:15];
    // ==== BATCH 8: DAB (0xB0) result ROM, ported verbatim from MAME's
    // Useful Stuff/mame/z8000/z8000dab.h (2048 x 9-bit, mechanically extracted -- NOT
    // hand-transcribed -- and spot-checked against the source header: idx[8..0]=0
    // ->9'h008, idx=9->9'h009, idx=10->9'h010 (BCD carry after 9); idx=1023(add-section
    // end)->9'h165; idx=1024(sub-section start)->9'h000; idx=2047(sub-section
    // end)->9'h199, all matching the header exactly). Index = {DA,H,C,byte-value}
    // (bit10=DA/subtract flag, bit9=H, bit8=C, bits7:0=RB(dst)); result bits7:0=
    // decimal-adjusted byte, bit8=carry-out. ====
    reg [8:0] dab_rom [0:2047];
    `include "z8002_dab_rom.svh"
    reg [15:0] target_cycles, cyc_count;
    `include "z8002_cycle_lookup.svh"
    reg [15:0] pc, fcw, ir, operand, ea;
    reg [15:0] psap;           // PSA pointer (control reg, LDCTL psapoff) - reset 0
    reg        nvi_pending;    // set on nvi_n ASSERT edge, cleared on NVI accept
    reg        nvi_n_d;        // NVIEDGE-2026-09-05: previous nvi_n, for edge detect
    // real internal-trap infrastructure (EPU/privileged-instruction
    // trap/system-call), modeled EXACTLY on the already-verified NVI accept sequence
    // (S_NVI_PC/FCW/VEC/RDFCW/RDPC) -- push PC, push OLD fcw, push the trapping opcode
    // word (MAME: "for internal traps, the 1st word of the instruction is pushed",
    // z8000.cpp:363/375/387 -- this core's `ir` IS m_op[0], already latched at decode),
    // then load new FCW/PC from the PSA vector table at PSAP+trap_vec/+trap_vec+2 (MAME
    // z8000cpu.h: EPU=PSAP+4, TRAP=PSAP+8, SYSCALL=PSAP+0xC, vecmult=1 for Z8002 non-
    // segmented -- confirmed against z8000.cpp's z8002_device constructor). `trap_vec`
    // selects which of the three (latched at decode).
    //
    // DELIBERATE, DOCUMENTED SIMPLIFICATION: real CHANGE_FCW() also swaps R15 with a
    // separate Normal-Stack-Pointer shadow register on any F_S_N (system/normal mode)
    // change (z8000ops.hxx:19-40). This core has ONE hardware SP by design -- the file's
    // own original header already documents this for the EXISTING, HW-verified NVI/IRET
    // path ("S_N never toggles here, so no NSP<->SSP swap"). Implementing the swap ONLY
    // for these NEW trap paths (and not retrofitting the proven NVI/IRET path to match)
    // would leave the core in a WORSE, inconsistent state -- some mode transitions swap
    // SP, others don't, depending on which code path triggered them, which is a strictly
    // worse hazard than the single uniform simplification already in place. This trap
    // sequence inherits the SAME single-SP simplification for consistency with the rest
    // of this core, not because it's what MAME's literal source does. Flagged in report.
    reg [15:0] trap_vec;
    localparam [15:0] VEC_EPU=16'h0004, VEC_TRAP=16'h0008, VEC_SYSCALL=16'h000C;

    // real 0x3A/0x3B port I/O -- single (INB/SINB/OUTB/SOUTB and
    // word siblings, NIB3=0100-0111) and self-repeating block (INIB/SINIB/OUTIB/SOUTIB/
    // INDB/SINDB/OUTDB/SOUTDB and word siblings, NIB3=0000-0011/1000-1011). Shared
    // between 0x3A(byte)/0x3B(word) via `io_wide` (set from the decoded top byte).
    // `mode` (MAME's RDPORT/WRPORT first param, 0=standard I/O space / 1=special I/O
    // space) is NOT modeled as a separate signal -- this core's bus has exactly one
    // `iorq` pin (no second "special I/O" strobe), so both spaces collapse onto the
    // same wire, matching the same kind of necessary single-space simplification
    // already used for LDPS's stack-vs-data collapse elsewhere in this batch. Flagged
    // in report.
    reg [3:0]  io_sub;   // block forms: word1 NIB3 (0000-0011 increment grp, 1000-1011
                          // decrement grp) -- io_sub[3]=group(0=inc,1=dec), io_sub[1]=
                          // direction(0=IN,1=OUT), io_sub[0]=S-bit(special-I/O + the
                          // "bump both pointers" quirk for the byte increment group)
    reg        io_wide;  // 0=byte(0x3A) 1=word(0x3B) -- shared by single AND block forms
    reg        io_dir;   // single-I/O forms only: 0=IN(port->dst) 1=OUT(src->port)
    reg [3:0]  cntreg;   // block forms: word2 NIB1, register HOLDING the loop count
    reg [3:0]  iocc;     // block forms: word2 NIB3, raw repeat-selector field (tested
                          // against exactly 0, NOT run through cc_true() -- matches
                          // MAME's literal `if (cc == 0) m_pc -= 4;`)
    reg [15:0] pc_orig;  // block forms: address of the opcode word, latched for the
                          // repeat-rewind (MAME's `m_pc -= 4`)
    // combinational scratch for the block-form register bump (S_IOB_WR)
    reg signed [15:0] iob_step;
    reg               iob_both;
    reg [3:0]  dst, src;
    reg [2:0]  aluop, daop;
    reg        retire, illegal;
    // BATCH 1: LDM loop counter (field value = count-1, 0..15); L32 pump pointer-writeback
    // enable (set for PUSHL/POPL which advance a register pointer; clear for plain LDL)
    reg [3:0]  mcnt;
    reg        l32wb;
    // BATCH 2: operand2 = low-word buffer for the 0x11 PUSHL @Rd,@Rs mem-to-mem pump
    // (hi word already re-written via `operand` before lo is read, see states below);
    // bmask/bitop_set = latched bit-test mask + RES(0)/SET(1) selector for the static
    // BIT/BITB/RES/SET @Rd,#imm4 family.
    reg [15:0] operand2, bmask;
    reg        bitop_set;
    reg        lda76_has_src;
    reg        jpx;
    // BATCH 3: RQ (quad, 4x16-bit) base register index for MULTL/DIVL = {dst[3:2],2'b00}
    // (MAME `#define RQ(n) m_regs.Q[(n)>>2]` truncates the low TWO bits of n, one level
    // wider than RL's bit0 truncation). operand/operand2 double as the hi/lo staging
    // buffer for MULTL/DIVL's 32-bit value operand (mirrors their L32-pump reuse
    // elsewhere in the file); `aluop` (ADD/SUB, already declared) selects INC-vs-DEC for
    // the S_INCDA_* RMW pump and ADDL-vs-SUBL for the S_LALU_* pump -- no new selector
    // register needed for either.
    reg [3:0]  qbase;
    // BATCH 4: index register nibble for register-indexed direct-address EA (addr(Rx)).
    // Latched at decode from NIB2 (din[7:4]) -- verified against z8000ops.hxx for EACH
    // of the four opcode families this batch indexes (LDB load 0x60, LDB store 0x6E,
    // CPL 0x50, INC/DEC 0x69/0x6B): every one of them puts the index nibble at NIB2,
    // confirming the task brief's hint. EA = addr + R[idxr], computed as a plain 16-bit
    // Verilog add (natural reg-width truncation reproduces z8000cpu.h's non-segmented
    // addr_add(): `(addr+addend)&0xffff` exactly). Consumed exactly once, in the four
    // *_FETCH states below, then dead until the next decode -- no lifetime hazard with
    // dst/src/mcnt/aluop, which the same indexed states also depend on (all latched
    // together at decode, all read together one cycle later).
    reg [3:0]  idxr;

    // BATCH 10: sub-op selectors for the 0x4C (byte, dacop) / 0x4D (word, dadop) direct-
    // address static-op family -- see the localparam block above for the states. dacop:
    // 0=COMB 1=NEGB 2=TESTB 3=TSETB 4=CLRB 5=CPB(imm8) 6=LDB(imm8 store).
    // dadop: 0=COM 1=NEG 2=TSET. `dacres` stages the computed new byte for S_DAC_WR's
    // ea[0]-lane merge (mirrors `daresb_new`'s shape but the value is already fully
    // computed by S_DAC_RD, not a bitmask merge, so no extra wire is needed).
    reg [2:0]  dacop;
    reg [1:0]  dadop;
    reg [7:0]  dacres;

    // BATCH 11: `dwop` selects the sub-operation for the shared 0x52/56/58/5A (32-bit)
    // and 0x59/5B (16-bit) direct-address arithmetic chains -- meaning is CONTEXT-
    // dependent on which chain is running (documented at each decode site): 32-bit chain
    // 0=ADDL/SUBL(aluop already selects which) 1=MULTL 2=DIVL; 16-bit chain 0=MULT 1=DIV.
    // `ldmx` flags indexed-vs-direct for the shared LDM word2-fetch states (S_LDM_DA_
    // FETCH2/LFETCH2), which route to either the existing direct word3-fetch or this
    // batch's new indexed word3-fetch based on it.
    reg [1:0]  dwop;
    reg        ldmx;

    // direct/indirect memory access op (for the EA states)
    localparam [2:0] DA_LDR=0, DA_STR=1, DA_STI=2, DA_CLR=3, DA_TST=4, DA_CPI=5;

    localparam [5:0] S_RST_FCW=0, S_RST_PC=1, S_FETCH0=2, S_IMM=3, S_MEMRD=4,
                     S_ALU=5, S_MEMWR=6, S_SHIFT=7, S_JP=8, S_ADDB_RD=9, S_ILLEGAL=10,
                     S_DA_FETCH=11, S_DA_IMM=12, S_DA_RD=13, S_DA_WR=14,
                     // NVI accept: push PC/FCW/vec (SP predecrement store x3),
                     // then read new FCW/PC from the PSA NVI vector (PSAP+0x18/0x1A)
                     S_NVI_PC=15, S_NVI_FCW=16, S_NVI_VEC=17, S_NVI_RDFCW=18, S_NVI_RDPC=19,
                     // IRET: pop vec(discard)/FCW/PC (SP postincrement load x3)
                     S_IRET_VEC=20, S_IRET_FCW=21, S_IRET_PC=22;
    // ---- BATCH 1 additions: stack + control flow ----
    localparam [5:0]
                     // CALL addr/@Rd, CALR: fetch target(direct only)->push PC->jump
                     S_CALL_FETCH=23, S_CALL_PUSH=24,
                     // RET cc (taken): pop PC
                     S_RET_POP=25,
                     // PUSH (word): shared push-commit + per-source-mode fetch chains
                     S_PUSH_W=26, S_PUSHI_FETCH=27, S_PUSHA_FETCH=28, S_PUSHA_RD=29,
                     // POP (word): register-dest direct; addr-dest fetch/pop/store chain
                     S_POP_R=30, S_POPA_FETCH=31, S_POPA_POP=32, S_POPA_WR=33,
                     // shared 32-bit (long) read/write pump, 2 words hi-then-lo at `ea`/ea+2:
                     // used by PUSHL/POPL (reg forms) and LDL reg-indirect/direct-addr forms
                     S_L32_RD_HI=34, S_L32_RD_LO=35, S_L32_WR_HI=36, S_L32_WR_LO=37,
                     // LDL RRd,imm32 (2-word immediate, own chain: reads via pc not ea)
                     S_LDL_IMM_HI=38, S_LDL_IMM_LO=39,
                     // LDL RRd,addr / LDL addr,RRs: fetch direct addr, then feed L32 pump
                     S_LDLA_FETCH=40, S_LDLSA_FETCH=41,
                     // LDM rd,@rs,n / LDM @rd,rs,n: fetch word2 (dst/src start + count),
                     // then self-looping word-at-a-time pump until mcnt==0
                     S_LDM_L_FETCH2=42, S_LDM_L_RD=43, S_LDM_S_FETCH2=44, S_LDM_S_WR=45;
    // ---- BATCH 2 additions ----
    localparam [6:0]
                     // PART A: indirect-indirect PUSHL/PUSH/POP (0x11/0x13/0x17) --
                     // memory-to-memory pumps. (0x15/POPL is an alias of the existing
                     // 0x95 arm/states, see decode chain -- no new states needed for it.)
                     S_PLII_RD_HI=46, S_PLII_RD_LO=47, S_PLII_WR_HI=48, S_PLII_WR_LO=49,
                     S_PUSHII_RD=50, S_POPII_RD=51, S_POPII_WR=52,
                     // PART B: shared byte-ALU/LDB pipeline (mirrors S_IMM/S_MEMRD/S_ALU)
                     S_IMMB=53, S_MEMRDB=54, S_ALUB=55,
                     // LDB @Rd,rbs store (0x2E): word-aligned read-modify-write, because
                     // `wordacc` is left unconnected downstream (PolePosition_subcpu.sv) --
                     // a bare byte write would clobber the neighboring byte on real HW wiring.
                     S_LDBST_RD=56, S_LDBST_WR=57,
                     // CPL rrd,@rs (0x10) / rrd,rrs (0x90): compare-only, no writeback
                     S_CPL_RD_HI=58, S_CPL_RD_LO=59, S_CPL_RR=60,
                     // BIT/BITB @Rd,#imm4 (0x27/0x26): read-only, no RMW hazard
                     S_BIT_RD=61, S_BITB_RD=62,
                     // RES/SET @Rd,#imm4 (0x23/0x25): word-only RMW (safe, word-aligned);
                     // byte RESB/SETB (0x22/0x24) deferred -- same wordacc hazard as LDB store
                     S_BITW_RD=63, S_BITW_WR=64,
                     // EX rd,@rs (0x2D): word-only exchange (safe); byte EXB (0x2C) deferred
                     S_EX_RD=65, S_EX_WR=66;
    // ---- BATCH 3 additions ----
    localparam [6:0]
                     // INC/DEC addr,#n direct (0x69/0x6B, NIB2=0): fetch addr, RMW word
                     // (wordacc-safe, word-aligned by construction). aluop selects ADD/SUB.
                     S_INCDA_FETCH=67, S_INCDA_RD=68, S_INCDA_WR=69,
                     // MULT rrd,{#imm16|@rs|rs} (0x19 / reg-reg 0x99)
                     S_MULT_IMM=70, S_MULT_RD=71, S_MULT_GO=72,
                     // DIV rrd,{#imm16|@rs|rs} (0x1B / reg-reg 0x9B)
                     S_DIV_IMM=73, S_DIV_RD=74, S_DIV_GO=75,
                     // MULTL rqd,{@rs|rrs} (0x18 indirect / reg-reg 0x98; imm32 unused, skipped)
                     S_MULTL_RD_HI=76, S_MULTL_RD_LO=77, S_MULTL_GO=78,
                     // DIVL rqd,{@rs|rrs} (0x1A indirect / reg-reg 0x9A; imm32 unused, skipped)
                     S_DIVL_RD_HI=79, S_DIVL_RD_LO=80, S_DIVL_GO=81,
                     // ADDL/SUBL rrd,{#imm32|@rs|rrs} (0x16/0x12 + reg-reg 0x96/0x92)
                     S_LALU_IMM_HI=82, S_LALU_IMM_LO=83, S_LALU_RD_HI=84, S_LALU_RD_LO=85,
                     S_LALU_GO=86,
                     // LDB rbd,addr direct-load (0x60, NIB2=0): read-only, no RMW hazard
                     S_LDBDA_FETCH=87, S_LDBDA_RD=88,
                     // LDB addr,rbs direct-store (0x6E, NIB2=0): RMW (wordacc rule)
                     S_LDBSTA_FETCH=89, S_LDBSTA_RD=90, S_LDBSTA_WR=91,
                     // SLLB/SRLB rbd,#imm8 (0xB2d1): fetch imm8, register-only otherwise
                     S_SHIFTB=92,
                     // CPL rrd,addr direct (0x50, NIB2=0 only): compare-only, no writeback
                     S_CPLA_FETCH=93, S_CPLA_RD_HI=94, S_CPLA_RD_LO=95;
    // ---- BATCH 4 additions ----
    localparam [6:0]
                     // register-indexed addr(Rx) EA datapath: after the addr word is
                     // fetched (via pc, identical timing to every direct *_FETCH state
                     // above), add R[idxr] to it IN THE SAME CYCLE, then join the
                     // existing UNMODIFIED direct-form RD/WR pipeline for that opcode.
                     S_LDBDAX_FETCH=96, S_LDBSTAX_FETCH=97, S_CPLAX_FETCH=98,
                     S_INCDAX_FETCH=99,
                     // RESB/SETB @Rd,#imm4 (0x22/0x24, NIB2=dst!=0): byte RMW, shares
                     // bmask/bitop_set with the existing word RES/SET (S_BITW_RD/WR).
                     S_RESETB_RD=100, S_RESETB_WR=101,
                     // EXB rbd,@rs (0x2C, NIB2=src!=0): byte RMW exchange, mirrors the
                     // existing word EX (S_EX_RD/WR) merged with the LDB-store byte-
                     // merge pattern (S_LDBST_RD/WR).
                     S_EXB_RD=102, S_EXB_WR=103;
    // ---- BATCH 5 additions ----
    localparam [6:0]
                     // direct-address(+index) RESB/SETB (0x62/0x64, byte RMW, share bmask/
                     // bitop_set like the existing word RES/SET); lane=ea[0].
                     S_DAB_RESB_FETCH=104, S_DAB_RESBX_FETCH=105,
                     S_DAB_RESB_RD=106, S_DAB_RESB_WR=107,
                     // direct-address(+index) RES/SET (0x63/0x65, word RMW, share bmask/
                     // bitop_set).
                     S_DAB_RESW_FETCH=108, S_DAB_RESWX_FETCH=109,
                     S_DAB_RESW_RD=110, S_DAB_RESW_WR=111,
                     // direct-address(+index) BITB (0x66, read-only byte, flags -Z----).
                     S_DAB_BITB_FETCH=112, S_DAB_BITBX_FETCH=113, S_DAB_BITB_RD=114,
                     // direct-address(+index) BIT (0x67, read-only word, flags -Z----).
                     S_DAB_BITW_FETCH=115, S_DAB_BITWX_FETCH=116, S_DAB_BITW_RD=117,
                     // direct-address(+index) EXB (0x6C, byte RMW exchange; `dst`=NIB3=
                     // value byte-reg-code, reuses the existing `exb_val` wire).
                     S_DAB_EXB_FETCH=118, S_DAB_EXBX_FETCH=119,
                     S_DAB_EXB_RD=120, S_DAB_EXB_WR=121,
                     // direct-address(+index) EX (0x6D, word exchange).
                     S_DAB_EXW_FETCH=122, S_DAB_EXWX_FETCH=123,
                     S_DAB_EXW_RD=124, S_DAB_EXW_WR=125;
    // ---- BATCH 5 PART 2 additions (register-indirect @Rd simple family, 0x0C/0x0D) ----
    // State count exceeded the 7-bit budget (max 127) -- `state` widened to 8 bits below.
    // This is the one non-purely-additive line touched this batch (documented, see report).
    localparam [7:0]
                     S_TESTBI_RD=126,
                     S_TSETBI_RD=127, S_TSETBI_WR=128,
                     S_CLRBI_RD=129,  S_CLRBI_WR=130,
                     S_COMI_RD=131,   S_COMI_WR=132,
                     S_CPRI_IMM=133,  S_CPRI_RD=134,
                     S_NEGI_RD=135,   S_NEGI_WR=136,
                     S_TESTI_RD=137,
                     S_TSETI_RD=138,  S_TSETI_WR=139,
                     S_CLRI_WR=140;
    localparam [7:0]
                     // 0x40-0x4B ALU addr[,(rs)]: FETCH computes ea (direct/indexed,
                     // Batch-4 shape), RD reads @ea and stages `operand`, then joins the
                     // EXISTING S_ALU/S_ALUB tail unchanged (dst/aluop latched at decode).
                     S_ALUA_FETCH=141,  S_ALUAX_FETCH=142,  S_ALUA_RD=143,
                     S_ALUAB_FETCH=144, S_ALUABX_FETCH=145, S_ALUAB_RD=146,
                     // 0x1000-0x100F CPL rrd,imm32: mirrors S_LDL_IMM_HI/LO's "two words
                     // via pc, no ea" shape feeding the existing CPL dif33 compare formula.
                     S_CPLI_HI=147, S_CPLI_LO=148,
                     // 0x68/0x6A INCB/DECB addr[,(rs)],#n: byte sibling of S_INCDA_FETCH/
                     // RD/WR, ea[0]-lane merge (same shape as S_LDBSTA's byte-store merge).
                     S_INCDAB_FETCH=149, S_INCDABX_FETCH=150, S_INCDAB_RD=151, S_INCDAB_WR=152,
                     // 0x61/0x6F missing indexed arms: compute ea<=din+R[idxr] then join
                     // the EXISTING, unmodified S_DA_RD/S_DA_WR tail (Batch-4 X_FETCH shape).
                     S_LDAX_FETCH=153, S_LDSAX_FETCH=154,
                     // 0x28-0x2B INCB/INC/DECB/DEC @rd: EA=R[dst] directly (no address
                     // word to fetch at all) -- mirrors S_INCDA_RD/WR one level more direct.
                     S_INCBI_RD=155, S_INCBI_WR=156, S_INCWI_RD=157, S_INCWI_WR=158;
    localparam [7:0]
                     S_DIV_BUSY=159, S_DIV_FIN=160, S_DIVL_FIN=161;
    // ---- BATCH 7 2026-07-27: SLA/SRA word, SLAL/SRAL long, SLLL/SRLL long ----
    // (0xB3 NIB3={9,D,5}). Word SLL/SRL (NIB3=1) already existed as S_SHIFT;
    // these are its arithmetic and 32-bit siblings, needed once real code past
    // the self-test/06xx-51xx handshake became reachable for the first time
    // (VRAM-WR-RACE-FIX-2026-07-27) -- SRAL specifically hit as S_ILLEGAL at
    // pp_sub1.asm:83 (0x00CE `sral rr2,#4`). MAME z8000ops.hxx SRAW/SRAL/SRLW/
    // SRLL bodies verified: right-arithmetic-shift NEVER sets V despite the
    // "flags CZSV--" doc-comment (CLR_CZSV then no `if(...)SET_V` at all) --
    // matched exactly below, not assumed from the mnemonic.
    localparam [7:0]
                     S_SHIFTA=162, S_SHIFTAL=163, S_SHIFTL=164;
    localparam [7:0]
                     S_LDA76_FETCH=165, S_LDA76_GO=166;
    // ---- BATCH 8 2026-07-27: remaining ISA gaps found via full-trace audit against the
    // user's MAME boot-to-attract traces (pp_sub1_fullboot.trace/pp_sub2_fullboot.trace) --
    // every opcode word ACTUALLY EXECUTED by either sub, cross-referenced against z8002.sv's
    // real dispatch conditions (including range and exact-match forms the naive per-line
    // audit missed on the first pass) to get the true remaining gap list mechanically, not
    // by eye. Families: 0x4D indexed (CP/TEST/LD-imm with a base+index addr), 0x5C direct
    // LOAD direction (0x5C09's STORE sibling), 0x5D indexed (LDL store), 0x71 (LD word,
    // register+register indexed -- the last confirmed-needed sibling of the 0x70-0x77
    // family), 0xB0 (DAB, decimal-adjust-byte, needs MAME's Z8000_dab lookup table for
    // correctness rather than re-deriving BCD edge cases by hand). ----
    localparam [7:0]
                     S_DAX_FETCH=170, S_DAX_IMM=171,
                     S_LDM_DA_LFETCH2=172, S_LDM_DA_LFETCH3=173,
                     S_LDLSAX_FETCH=174,
                     S_LD71_FETCH=175, S_LD71_RD=176;
    localparam [7:0]
                     S_LDLAX_FETCH=167, S_LDM_DA_FETCH2=168, S_LDM_DA_FETCH3=169;
    localparam [7:0]
                     S_DAC_FETCH=177, S_DAC_FETCHX=178, S_DAC_IMM=179,
                     S_DAC_RD=180, S_DAC_RDRO=181, S_DAC_WR=182,
                     S_DAD_FETCH=183, S_DAD_FETCHX=184, S_DAD_RD=185, S_DAD_WR=186;
    localparam [7:0]
                     // Z52/Z56/Z58/Z5A (SUBL/ADDL/MULTL/DIVL rrd|rqd,addr[,(rs)]): shared
                     // 32-bit-operand fetch+read chain, `dwop` selects which existing GO
                     // state to land in (0=LALU[aluop already ADD/SUB]/1=MULTL/2=DIVL).
                     S_DWL_FETCH=187, S_DWL_FETCHX=188, S_DWL_RD_HI=189, S_DWL_RD_LO=190,
                     // Z59/Z5B (MULT/DIV rrd,addr[,(rs)]): shared 16-bit-operand chain,
                     // `dwop` (0=MULT,1=DIV) selects the existing GO state.
                     S_DWS_FETCH=191, S_DWS_FETCHX=192, S_DWS_RD=193,
                     // Z51 (PUSHL @rd,addr[,(rs)]): read a fresh long @ea, THEN push it
                     // (predecrement R[dst] by 4) -- new dedicated pump (S_L32_WR_* can't
                     // be reused: its dout is hardwired to a register PAIR, not `operand`).
                     S_PLDA_FETCH=194, S_PLDA_FETCHX=195, S_PLDA_RD_HI=196, S_PLDA_RD_LO=197,
                     S_PLDA_WR_HI=198, S_PLDA_WR_LO=199,
                     // Z55 (POPL addr[,(rd)],@rs): pop a long @R[src] (postincrement +4),
                     // write it to the fetched ea -- new dedicated pump, same reasoning.
                     S_POLDA_FETCH=200, S_POLDA_FETCHX=201, S_POLDA_RD_HI=202, S_POLDA_RD_LO=203,
                     S_POLDA_WR_HI=204, S_POLDA_WR_LO=205,
                     // Z53/Z57 indexed (PUSH/POP word, addr(rs)): the DIRECT (NIB3=0) forms
                     // already exist (S_PUSHA_FETCH/RD, S_POPA_FETCH/POP/WR) -- these are
                     // just indexed *_FETCH siblings joining those tails unchanged.
                     S_PUSHAX_FETCH=206, S_POPAX_FETCH=207,
                     // Z5C08/Z5CN8 (TESTL addr[,(rd)]): new 32-bit read-only compare-to-zero.
                     S_TL_FETCH=208, S_TL_FETCHX=209, S_TL_RD_HI=210, S_TL_RD_LO=211,
                     // Z5C11/Z5C19 (LDM rd,addr(rs),n / LDM addr(rd),rs,n indexed): indexed
                     // word3-fetch siblings of S_LDM_DA_FETCH3/S_LDM_DA_LFETCH3, selected via
                     // the `ldmx` flag set at decode (word2-fetch states S_LDM_DA_FETCH2/
                     // LFETCH2 are reused UNCHANGED for both direct and indexed).
                     S_LDM_DA_FETCH3X=212, S_LDM_DA_LFETCH3X=213,
                     // Z5F10-Z5FF0 (CALL addr(rd) indexed): indexed sibling of the existing
                     // S_CALL_FETCH (0x5F00 exact-match direct), joins S_CALL_PUSH unchanged.
                     S_CALLX_FETCH=214;
    localparam [7:0]
                     S_Z30_FETCH=215, S_Z31_FETCH=216, S_Z32_FETCH=217, S_Z33_FETCH=218,
                     S_Z34_FETCH=219, S_Z35_FETCH=220, S_Z37_FETCH=221;
    localparam [7:0]
                     S_Z70_FETCH=222, S_Z72_FETCH=223, S_Z73_FETCH=224,
                     S_Z74_FETCH=225, S_Z75_FETCH=226, S_Z77_FETCH=227;
    localparam [7:0]
                     S_MULTLI_HI=228, S_MULTLI_LO=229, S_DIVLI_HI=230, S_DIVLI_LO=231;
    // BATCH 14: register-count dynamic shift GO states (SDLB/SDAB/SDLW/SDAW/SDLL/SDAL) --
    // each single-cycle: word2 (read via `pc`, default addr mux) supplies the count
    // register NUMBER at NIB1 (din[11:8]); that register's live VALUE is read the SAME
    // cycle (no further memory access), same shape as S_Z74_FETCH.
    localparam [7:0]
                     S_SDLB_GO=232, S_SDAB_GO=233, S_SDLW_GO=234,
                     S_SDAW_GO=235, S_SDLL_GO=236, S_SDAL_GO=237;
    // BATCH 14: RESB/RES/SETB/SET/BITB/BIT rd,rs (0x22-0x27, NIB2=0) -- the register-to-
    // register DYNAMIC-bit-index sibling of the already-implemented @Rd,#imm4 (memory,
    // NIB2!=0) and rd,imm4 (register, 0xA2-0xA7) forms: here the bit POSITION is read live
    // off a register (masked to 0-7/0-15) instead of a literal nibble. Single-cycle: word2
    // (read via `pc`) supplies the TARGET register number at NIB1.
    localparam [7:0]
                     S_RESB2_GO=238, S_RES2_GO=239, S_SETB2_GO=240,
                     S_SET2_GO=241, S_BITB2_GO=242, S_BIT2_GO=243;
    localparam [7:0]
                     S_SWALLOW1=244, S_HALT=245, S_SHIFTAB=246;
    localparam [7:0]
                     S_TRAP_PC=247, S_TRAP_FCW=248, S_TRAP_OP=249,
                     S_TRAP_RDFCW=250, S_TRAP_RDPC=251;
    // ---- BATCH 18 2026-08-09: real single-cycle port I/O (INB/IN/OUTB/OUT, 0x3C-0x3F).
    // `iorq` (previously hardwired 0) now asserts during these four states; addr/dout/
    // wordacc follow the SAME byte-lane-vs-plain-word convention this file already uses
    // uniformly for every other byte/word pair (RDPORT_B/WRPORT_B are structurally
    // identical C-level shape to RDMEM_B/WRMEM_B, which this core already implements via
    // word-align+lane-select everywhere -- applying the same pattern to I/O is not a new
    // invention, it's this file's established translation of MAME's byte-space-access
    // idiom, just pointed at a different address space). See the S_xxB_GO/S_xx_GO state
    // bodies + iorq/addr/dout/wordacc mux comments for the exact per-signal mapping. ----
    localparam [7:0]
                     S_INB_GO=252, S_IN_GO=253, S_OUTB_GO=254, S_OUT_GO=255;
    reg [8:0] state;
    // ---- BATCH 18: LDPS real functional sequence (0x39 @rs / 0x79 addr[(rs)]) -- shared
    // RDFCW/RDPC tail (fcw=mem[ea], pc=mem[ea+2], matches both MAME bodies exactly once
    // `ea` is set correctly per sub-form: 0x39 sets it directly from a register, 0x79
    // fetches an addr word first, optionally +R[idxr]). ----
    localparam [8:0]
                     S_LDPS_FETCH=256, S_LDPS_FETCHX=257,
                     S_LDPS_RDFCW=258, S_LDPS_RDPC=259;
    // ---- BATCH 19: 0x3A/0x3B port I/O -- single (S_IOS_*) and self-repeating block
    // (S_IOB_*) forms. See the io_sub/io_wide/io_dir/cntreg/iocc/pc_orig declaration
    // comments and the iob_rdword/iob_byte_rd/iob_wr_dout wire comments above. ----
    localparam [8:0]
                     S_IOS_FETCH=260, S_IOS_RD=261, S_IOS_WR=262,
                     S_IOB_FETCH2=263, S_IOB_RD=264, S_IOB_WR_RD=265, S_IOB_WR=266;

    // BATCH 2: RB(src) value staged for the LDB @Rd,rbs store merge (S_LDBST_WR) --
    // src here holds the byte-reg-code of the VALUE register (see 0x2E decode arm).
    wire [7:0] ldbst_val = src[3] ? R[src[2:0]][7:0] : R[src[2:0]][15:8];

    // BATCH 4: RESB/SETB @Rd,#imm4 byte-merge (S_RESETB_WR) -- `dst` holds the plain
    // pointer register (NIB2), `operand` the word read back in S_RESETB_RD, `bmask`/
    // `bitop_set` shared with the existing word RES/SET (0x23/0x25). Lane = R[dst][0]
    // (the LSB of the ADDRESS held in R[dst], NOT dst[0] -- mirrors ldbst_val's sibling
    // lane test `R[dst][0]` in the dout mux below, same S_LDBST_RD/WR-derived pattern).
    wire [7:0] resetb_new = bitop_set
        ? ((R[dst][0] ? operand[7:0] : operand[15:8]) | bmask[7:0])
        : ((R[dst][0] ? operand[7:0] : operand[15:8]) & ~bmask[7:0]);
    // BATCH 4: EXB rbd,@rs old-value staging (S_EXB_WR dout) -- `dst` here holds the
    // byte-reg-code of the VALUE register (see 0x2C decode arm), mirroring ldbst_val.
    wire [7:0] exb_val = dst[3] ? R[dst[2:0]][7:0] : R[dst[2:0]][15:8];

    // BATCH 19: 0x3A/0x3B block-I/O read-side byte extraction (S_IOB_RD stages the full
    // word read into `operand`; S_IOB_WR extracts the byte MAME actually transfers).
    // `iob_rdword`: was this READ itself word-wide? True for the word family (io_wide)
    // OR the ONE confirmed MAME quirk (Z3A_ssss_0011/SOUTIB reads via RDIR_W(src) where
    // every sibling byte block-op uses RDIR_B/RDPORT_B -- transcribed LITERALLY per
    // z8000ops.hxx, not "corrected" to match its siblings; flagged in report). When
    // iob_rdword, the transferred byte is the LOW byte of the word AS READ (matches C's
    // implicit uint16_t->uint8_t truncation exactly -- operand[7:0], no lane selection,
    // since a genuine word read has no lane concept). Otherwise it's the normal
    // established byte-lane extraction off the READ side's own address (R[src][0]).
    wire iob_rdword = io_wide || (io_sub==4'b0011);
    wire [7:0] iob_byte_rd = iob_rdword ? operand[7:0] : (R[src][0] ? operand[7:0] : operand[15:8]);
    // S_IOB_WR's dout: word forms pass the read value straight through (no lane logic
    // at all, matches WRIR_W/WRPORT_W taking a plain uint16_t). Byte forms differ by
    // WRITE target: IN direction (io_sub[1]==0) writes to MEMORY, which per this file's
    // established byte-memory-write convention needs a genuine RMW merge against the
    // OLD word staged in `operand2` by S_IOB_WR_RD, lane=R[dst][0] (the WRITE side's own
    // address, same convention as every other byte-memory-write merge in this file).
    // OUT direction (io_sub[1]==1) writes to a PORT, which (matching MAME's WRPORT_B
    // replicate+byte-enable-mask, no RMW) just replicates the byte into both halves,
    // same as the standalone S_OUTB_GO built in Batch 18.
    wire [15:0] iob_wr_dout = io_wide ? operand :
                              (io_sub[1]==1'b0) ? (R[dst][0] ? {operand2[15:8], iob_byte_rd}
                                                               : {iob_byte_rd, operand2[7:0]})
                                                 : {2{iob_byte_rd}};

    // BATCH 5: RESB/SETB addr[,(rd)],#imm4 byte-merge (S_DAB_RESB_WR) -- same shape as
    // Batch 4's `resetb_new` but the RMW pointer is the fetched/indexed `ea`, not R[dst]
    // (dst holds the EXCHANGE value register for this batch's EX/EXB, not a bit-op pointer).
    // Lane = ea[0] (the address LSB), matching S_LDBDA_RD/resetb_new's established convention.
    wire [7:0] daresb_new = bitop_set
        ? ((ea[0] ? operand[7:0] : operand[15:8]) | bmask[7:0])
        : ((ea[0] ? operand[7:0] : operand[15:8]) & ~bmask[7:0]);

    // NVI push / IRET pop addresses: SP=R[15]; pushes pre-decrement (addr=R15-2,
    // and R15 itself is updated -=2 on the same edge), pops read at current R15
    // then post-increment (matches MAME PUSHW/POPW exactly).
    assign addr = (state==S_RST_FCW ) ? 16'h0002 :
                  (state==S_RST_PC  ) ? 16'h0004 :
                  (state==S_ADDB_RD ) ? (R[src] & 16'hFFFE) :
                  (state==S_MEMRD   ) ? (R[src] & 16'hFFFE) :
                  (state==S_MEMWR   ) ?  R[dst] :
                  (state==S_DA_RD   ) ?  ea :
                  (state==S_DA_WR   ) ?  ea :
                  (state==S_NVI_PC  ) ?  (R[15] - 16'd2) :
                  (state==S_NVI_FCW ) ?  (R[15] - 16'd2) :
                  (state==S_NVI_VEC ) ?  (R[15] - 16'd2) :
                  (state==S_NVI_RDFCW) ? (psap + 16'h0018) :
                  (state==S_NVI_RDPC) ?  (psap + 16'h001A) :
                  (state==S_IRET_VEC) ?  R[15] :
                  (state==S_IRET_FCW) ?  R[15] :
                  (state==S_IRET_PC ) ?  R[15] :
                  // ---- BATCH 1: stack + control flow explicit-address states ----
                  (state==S_CALL_PUSH) ? (R[15] - 16'd2) :
                  (state==S_RET_POP  ) ?  R[15] :
                  (state==S_PUSH_W   ) ? (R[dst] - 16'd2) :
                  (state==S_PUSHA_RD ) ?  ea :
                  (state==S_POP_R    ) ?  R[src] :
                  (state==S_POPA_POP ) ?  R[src] :
                  (state==S_POPA_WR  ) ?  ea :
                  (state==S_L32_RD_HI) ?  ea :
                  (state==S_L32_RD_LO) ? (ea + 16'd2) :
                  (state==S_L32_WR_HI) ?  ea :
                  (state==S_L32_WR_LO) ? (ea + 16'd2) :
                  (state==S_LDM_L_RD ) ?  ea :
                  (state==S_LDM_S_WR ) ?  ea :
                  // ---- BATCH 2 PART A: indirect-indirect PUSHL/PUSH/POP ----
                  (state==S_PLII_RD_HI) ?  R[src] :
                  (state==S_PLII_RD_LO) ? (R[src] + 16'd2) :
                  (state==S_PLII_WR_HI) ?  ea :
                  (state==S_PLII_WR_LO) ? (ea + 16'd2) :
                  (state==S_PUSHII_RD ) ?  R[src] :
                  (state==S_POPII_RD  ) ?  R[src] :
                  (state==S_POPII_WR  ) ?  R[dst] :
                  // ---- BATCH 2 PART B: byte ALU/LDB, LDB store, CPL, BIT/RES/SET, EX ----
                  (state==S_MEMRDB    ) ? (R[src] & 16'hFFFE) :
                  (state==S_LDBST_RD  ) ? (R[dst] & 16'hFFFE) :
                  (state==S_LDBST_WR  ) ? (R[dst] & 16'hFFFE) :
                  (state==S_CPL_RD_HI ) ?  R[src] :
                  (state==S_CPL_RD_LO ) ? (R[src] + 16'd2) :
                  (state==S_BIT_RD    ) ?  R[dst] :
                  (state==S_BITB_RD   ) ? (R[dst] & 16'hFFFE) :
                  (state==S_BITW_RD   ) ?  R[dst] :
                  (state==S_BITW_WR   ) ?  R[dst] :
                  (state==S_EX_RD     ) ?  R[src] :
                  (state==S_EX_WR     ) ?  R[src] :
                  // ---- BATCH 3: INC/DEC direct, MULT/DIV/MULTL/DIVL, ADDL/SUBL, LDB
                  //      direct load/store, CPL direct (fetch states omitted -- they
                  //      default to `pc`, same convention as S_DA_FETCH/S_IMM/etc) ----
                  (state==S_INCDA_RD  ) ?  ea :
                  (state==S_INCDA_WR  ) ?  ea :
                  (state==S_MULT_RD   ) ? (R[src] & 16'hFFFE) :
                  (state==S_DIV_RD    ) ? (R[src] & 16'hFFFE) :
                  (state==S_MULTL_RD_HI) ?  R[src] :
                  (state==S_MULTL_RD_LO) ? (R[src] + 16'd2) :
                  (state==S_DIVL_RD_HI) ?  R[src] :
                  (state==S_DIVL_RD_LO) ? (R[src] + 16'd2) :
                  (state==S_LALU_RD_HI) ?  R[src] :
                  (state==S_LALU_RD_LO) ? (R[src] + 16'd2) :
                  (state==S_LDBDA_RD  ) ? (ea & 16'hFFFE) :
                  (state==S_LDBSTA_RD ) ? (ea & 16'hFFFE) :
                  (state==S_LDBSTA_WR ) ? (ea & 16'hFFFE) :
                  (state==S_CPLA_RD_HI) ?  ea :
                  (state==S_CPLA_RD_LO) ? (ea + 16'd2) :
                  // ---- BATCH 4: RESB/SETB, EXB (the four indexed *_FETCH states read
                  //      the addr word via `pc`, same default convention as every direct
                  //      *_FETCH state -- no entry needed here) ----
                  (state==S_RESETB_RD ) ? (R[dst] & 16'hFFFE) :
                  (state==S_RESETB_WR ) ? (R[dst] & 16'hFFFE) :
                  (state==S_EXB_RD    ) ? (R[src] & 16'hFFFE) :
                  (state==S_EXB_WR    ) ? (R[src] & 16'hFFFE) :
                  // ---- BATCH 5: direct-address(+index) RESB/RES/BITB/BIT/EXB/EX family
                  //      (the *_FETCH/*X_FETCH states read the addr word via `pc`, same
                  //      default convention as every other *_FETCH state -- no entry needed) --
                  (state==S_DAB_RESB_RD) ? (ea & 16'hFFFE) :
                  (state==S_DAB_RESB_WR) ? (ea & 16'hFFFE) :
                  (state==S_DAB_RESW_RD) ?  ea :
                  (state==S_DAB_RESW_WR) ?  ea :
                  (state==S_DAB_BITB_RD) ? (ea & 16'hFFFE) :
                  (state==S_DAB_BITW_RD) ?  ea :
                  (state==S_DAB_EXB_RD ) ? (ea & 16'hFFFE) :
                  (state==S_DAB_EXB_WR ) ? (ea & 16'hFFFE) :
                  (state==S_DAB_EXW_RD ) ?  ea :
                  (state==S_DAB_EXW_WR ) ?  ea :
                  // ---- BATCH 5 PART 2: register-indirect @Rd simple family (0x0C/0x0D) ----
                  (state==S_TESTBI_RD) ? (R[dst] & 16'hFFFE) :
                  (state==S_TSETBI_RD) ? (R[dst] & 16'hFFFE) :
                  (state==S_TSETBI_WR) ? (R[dst] & 16'hFFFE) :
                  (state==S_CLRBI_RD ) ? (R[dst] & 16'hFFFE) :
                  (state==S_CLRBI_WR ) ? (R[dst] & 16'hFFFE) :
                  (state==S_COMI_RD  ) ?  R[dst] :
                  (state==S_COMI_WR  ) ?  R[dst] :
                  (state==S_CPRI_RD  ) ?  R[dst] :
                  (state==S_NEGI_RD  ) ?  R[dst] :
                  (state==S_NEGI_WR  ) ?  R[dst] :
                  (state==S_TESTI_RD ) ?  R[dst] :
                  (state==S_TSETI_RD ) ?  R[dst] :
                  (state==S_TSETI_WR ) ?  R[dst] :
                  (state==S_CLRI_WR  ) ?  R[dst] :
                  // ---- BATCH 6 ---- (the new *_FETCH/*X_FETCH states all read the addr/
                  // imm word via `pc`, same default convention as every prior *_FETCH
                  // state -- no entry needed for those here)
                  (state==S_ALUA_RD    ) ?  ea :
                  (state==S_ALUAB_RD   ) ? (ea & 16'hFFFE) :
                  (state==S_INCDAB_RD  ) ? (ea & 16'hFFFE) :
                  (state==S_INCDAB_WR  ) ? (ea & 16'hFFFE) :
                  (state==S_INCBI_RD   ) ? (R[dst] & 16'hFFFE) :
                  (state==S_INCBI_WR   ) ? (R[dst] & 16'hFFFE) :
                  (state==S_INCWI_RD   ) ? (R[dst] & 16'hFFFE) :
                  (state==S_INCWI_WR   ) ? (R[dst] & 16'hFFFE) :
                  // BATCH 8: LD rd,rs(rx) (0x71) -- ea = R[src]+R[idx] computed in
                  // S_LD71_FETCH (idx read straight off word2's din[11:8], no idxr
                  // staging needed since both operands are live that same cycle).
                  (state==S_LD71_RD    ) ?  ea :
                  // BATCH 10: 0x4C/4D direct-address(+index) static-op family (the
                  // *_FETCH/*_FETCHX states read the addr/imm8 word via `pc`, same default
                  // convention as every other *_FETCH state -- no entry needed for those).
                  (state==S_DAD_RD     ) ?  ea :
                  (state==S_DAD_WR     ) ?  ea :
                  (state==S_DAC_RD     ) ? (ea & 16'hFFFE) :
                  (state==S_DAC_RDRO   ) ? (ea & 16'hFFFE) :
                  (state==S_DAC_WR     ) ? (ea & 16'hFFFE) :
                  // BATCH 11: 0x51-0x5C address-form family (*_FETCH/*_FETCHX states read
                  // the addr/word2/word3 word via `pc`, same default convention -- no entry
                  // needed for those here).
                  (state==S_DWL_RD_HI  ) ?  ea :
                  (state==S_DWL_RD_LO  ) ? (ea + 16'd2) :
                  (state==S_DWS_RD     ) ?  ea :
                  (state==S_PLDA_RD_HI ) ?  ea :
                  (state==S_PLDA_RD_LO ) ? (ea + 16'd2) :
                  (state==S_PLDA_WR_HI ) ? (R[dst] - 16'd4) :
                  (state==S_PLDA_WR_LO ) ? (R[dst] - 16'd4 + 16'd2) :
                  (state==S_POLDA_RD_HI) ?  R[src] :
                  (state==S_POLDA_RD_LO) ? (R[src] + 16'd2) :
                  (state==S_POLDA_WR_HI) ?  ea :
                  (state==S_POLDA_WR_LO) ? (ea + 16'd2) :
                  (state==S_TL_RD_HI   ) ?  ea :
                  (state==S_TL_RD_LO   ) ? (ea + 16'd2) :
                  // BATCH 17: internal-trap accept sequence (mirrors S_NVI_* exactly,
                  // psap+trap_vec instead of the hardwired psap+0x18 NVI offset).
                  (state==S_TRAP_PC    ) ?  (R[15] - 16'd2) :
                  (state==S_TRAP_FCW   ) ?  (R[15] - 16'd2) :
                  (state==S_TRAP_OP    ) ?  (R[15] - 16'd2) :
                  (state==S_TRAP_RDFCW ) ?  (psap + trap_vec) :
                  (state==S_TRAP_RDPC  ) ?  (psap + trap_vec + 16'd2) :
                  // BATCH 18: port I/O -- addr is a plain register value (byte forms
                  // word-align, matching this file's established byte-access convention).
                  (state==S_INB_GO  ) ? (R[src] & 16'hFFFE) :
                  (state==S_IN_GO   ) ?  R[src] :
                  (state==S_OUTB_GO ) ? (R[dst] & 16'hFFFE) :
                  (state==S_OUT_GO  ) ?  R[dst] :
                  // BATCH 18: LDPS RDFCW/RDPC (S_LDPS_FETCH/FETCHX default to `pc`, same
                  // convention as every other *_FETCH state -- no entry needed for those).
                  (state==S_LDPS_RDFCW) ?  ea :
                  (state==S_LDPS_RDPC ) ? (ea + 16'd2) :
                  // BATCH 19: 0x3A/0x3B port I/O (S_IOS_FETCH/S_IOB_FETCH2 default to
                  // `pc`, same convention as every other *_FETCH state).
                  (state==S_IOS_RD    ) ? (io_wide ? ea : (ea & 16'hFFFE)) :
                  (state==S_IOS_WR    ) ? (io_wide ? ea : (ea & 16'hFFFE)) :
                  (state==S_IOB_RD    ) ? (iob_rdword ? R[src] : (R[src] & 16'hFFFE)) :
                  (state==S_IOB_WR_RD ) ? (R[dst] & 16'hFFFE) :
                  (state==S_IOB_WR    ) ? (io_wide ? R[dst] : (R[dst] & 16'hFFFE)) :
                                        pc;
    // BATCH 18/19: mreq/iorq are mutually exclusive space-selects (matches a real Z8000
    // bus). S_IOS_RD/WR are always I/O (register<->port, no memory involved). S_IOB_RD/
    // WR flip between mem and port depending on io_sub[1] (IN direction reads FROM
    // port/writes TO memory; OUT direction is the mirror) -- S_IOB_FETCH2/WR_RD are
    // always memory (word2 fetch; RMW old-value read).
    assign mreq    = (state!=S_ILLEGAL) && (state!=S_INB_GO) && (state!=S_IN_GO) &&
                      (state!=S_OUTB_GO) && (state!=S_OUT_GO) &&
                      (state!=S_IOS_RD) && (state!=S_IOS_WR) &&
                      !(state==S_IOB_RD && !io_sub[1]) &&
                      !(state==S_IOB_WR &&  io_sub[1]);
    // BATCH 18: real iorq, asserted during the four port-I/O states (was hardwired 0 --
    // no I/O device is wired on this board, but the CPU core itself must still present a
    // correct bus cycle: MREQ/IORQ space-select, addr, dout, wordacc, matching every
    // other memory-space access in this file. Downstream simply sees IORQ asserted with
    // nothing answering, exactly like a real unconnected I/O bus.
    assign iorq    = (state==S_INB_GO) || (state==S_IN_GO) || (state==S_OUTB_GO) || (state==S_OUT_GO) ||
                      // BATCH 19
                      (state==S_IOS_RD) || (state==S_IOS_WR) ||
                      (state==S_IOB_RD &&  !io_sub[1]) ||
                      (state==S_IOB_WR &&   io_sub[1]);
    assign we      = (state==S_MEMWR) || (state==S_DA_WR) ||
                      (state==S_NVI_PC) || (state==S_NVI_FCW) || (state==S_NVI_VEC) ||
                      (state==S_CALL_PUSH) || (state==S_PUSH_W) || (state==S_POPA_WR) ||
                      (state==S_L32_WR_HI) || (state==S_L32_WR_LO) || (state==S_LDM_S_WR) ||
                      // ---- BATCH 2 ----
                      (state==S_PLII_WR_HI) || (state==S_PLII_WR_LO) || (state==S_POPII_WR) ||
                      (state==S_LDBST_WR) || (state==S_BITW_WR) || (state==S_EX_WR) ||
                      // ---- BATCH 3 ----
                      (state==S_INCDA_WR) || (state==S_LDBSTA_WR) ||
                      // ---- BATCH 4 ----
                      (state==S_RESETB_WR) || (state==S_EXB_WR) ||
                      // ---- BATCH 5 ----
                      (state==S_DAB_RESB_WR) || (state==S_DAB_RESW_WR) ||
                      (state==S_DAB_EXB_WR)  || (state==S_DAB_EXW_WR)  ||
                      // ---- BATCH 5 PART 2 ----
                      (state==S_TSETBI_WR) || (state==S_CLRBI_WR) || (state==S_COMI_WR) ||
                      (state==S_NEGI_WR)   || (state==S_TSETI_WR) || (state==S_CLRI_WR) ||
                      // ---- BATCH 6 ----
                      (state==S_INCDAB_WR) || (state==S_INCBI_WR) || (state==S_INCWI_WR) ||
                      // ---- BATCH 10 ----
                      (state==S_DAD_WR) || (state==S_DAC_WR) ||
                      // ---- BATCH 11 ----
                      (state==S_PLDA_WR_HI) || (state==S_PLDA_WR_LO) ||
                      (state==S_POLDA_WR_HI) || (state==S_POLDA_WR_LO) ||
                      // ---- BATCH 17 ----
                      (state==S_TRAP_PC) || (state==S_TRAP_FCW) || (state==S_TRAP_OP) ||
                      // ---- BATCH 18 ----
                      (state==S_OUTB_GO) || (state==S_OUT_GO) ||
                      // ---- BATCH 19 ----
                      (state==S_IOS_WR) || (state==S_IOB_WR);
    // BATCH 2: S_MEMRDB/S_BITB_RD also word-align the read addr and keep only one byte of
    // the result (same shape as the pre-existing S_ADDB_RD) -- flagged for consistency even
    // though `wordacc` is currently left unconnected downstream (PolePosition_subcpu.sv).
    // BATCH 3: S_LDBDA_RD is the same shape (LDB rbd,addr direct-load, one byte of a
    // word-aligned read) -- added to the exclusion list. S_LDBSTA_RD/WR are NOT added:
    // like S_LDBST_RD/WR they are a genuine word-wide RMW (read+merge+write the whole
    // word), matching the existing convention that only byte-discarding READS are
    // excluded.
    // BATCH 5: S_DAB_BITB_RD is the same shape (BITB addr[,(rd)],#imm4 -- a read-only byte
    // test discarding the other lane of the word read) -- added to the exclusion list.
    // S_DAB_RESB_RD/S_DAB_EXB_RD are NOT added: like S_RESETB_RD/S_EXB_RD they are genuine
    // word-wide RMW (read+merge+write the whole word). BATCH 5 PART 2: S_TESTBI_RD is the
    // same read-only-byte-discard shape -- excluded. S_TSETBI_RD/S_CLRBI_RD are genuine RMW
    // (need the full word for the merge-write) -- NOT excluded, same as their siblings.
    // BATCH 6: S_ALUAB_RD is the same read-only-byte-discard shape (ALU rbd,addr[,(rs)]
    // -- reads one byte lane of a word-aligned read, no writeback) -- excluded. S_INCDAB_
    // RD/S_INCBI_RD/S_INCWI_RD are NOT added: genuine byte/word RMW (need the full word
    // for the merge-write), same convention as their siblings.
    // BATCH 10: S_DAC_RDRO is the same read-only-byte-discard shape (TESTB/CPB
    // addr[,(rs)] -- discards the other lane of the word read, no writeback) -- excluded.
    // S_DAC_RD is NOT added: it's the shared COMB/NEGB/TSETB/CLRB/LDB RMW path, genuine
    // word-wide read needed for the merge-write, same convention as its siblings.
    assign wordacc = (state!=S_ADDB_RD) && (state!=S_MEMRDB) && (state!=S_BITB_RD) &&
                      (state!=S_LDBDA_RD) && (state!=S_DAB_BITB_RD) && (state!=S_TESTBI_RD) &&
                      (state!=S_ALUAB_RD) && (state!=S_DAC_RDRO) &&
                      // ---- BATCH 18: INB (read-only byte-discard, like every other
                      // *_RD byte state above) and OUTB (byte write, no RMW needed for
                      // I/O -- MAME's WRPORT_B replicates+byte-enable-masks, it never
                      // reads the old port value first) are both genuine byte accesses. ----
                      (state!=S_INB_GO) && (state!=S_OUTB_GO) &&
                      // ---- BATCH 19: S_IOS_RD/WR and S_IOB_RD are byte-discard-shaped
                      // whenever the access itself is byte-width (matches INB/OUTB's
                      // precedent above). S_IOB_WR is byte ONLY when it's a byte PORT
                      // write (OUT direction, replicate-not-merge, same reasoning as
                      // OUTB) -- when it's a byte MEMORY write (IN direction) it's a
                      // genuine RMW merge and stays word-wide, matching S_LDBSTA_WR's
                      // established precedent. S_IOB_WR_RD (the RMW old-value read) is
                      // NEVER excluded -- it always needs the full word, same as every
                      // other RMW read in this file. ----
                      !(state==S_IOS_RD && !io_wide) &&
                      !(state==S_IOS_WR && !io_wide) &&
                      !(state==S_IOB_RD && !iob_rdword) &&
                      !(state==S_IOB_WR && !io_wide && io_sub[1]);
    assign dout    = (state==S_MEMWR) ? R[src] :
                     (state==S_DA_WR) ? (daop==DA_STR ? R[src] :
                                         daop==DA_STI ? operand : 16'h0000) :
                     (state==S_NVI_PC ) ? pc :
                     (state==S_NVI_FCW) ? fcw :
                     (state==S_NVI_VEC) ? 16'h00FF :
                     // ---- BATCH 1 ----
                     (state==S_CALL_PUSH) ? pc :
                     (state==S_PUSH_W   ) ? operand :
                     (state==S_POPA_WR  ) ? operand :
                     (state==S_L32_WR_HI) ? R[{src[3:1],1'b0}] :
                     (state==S_L32_WR_LO) ? R[{src[3:1],1'b0}+4'd1] :
                     (state==S_LDM_S_WR ) ? R[src] :
                     // ---- BATCH 2 PART A ----
                     (state==S_PLII_WR_HI) ? operand :
                     (state==S_PLII_WR_LO) ? operand2 :
                     (state==S_POPII_WR  ) ? operand :
                     // ---- BATCH 2 PART B ----
                     (state==S_LDBST_WR  ) ? (R[dst][0] ? {operand[15:8], ldbst_val}
                                                          : {ldbst_val, operand[7:0]}) :
                     (state==S_BITW_WR   ) ? (bitop_set ? (operand | bmask) : (operand & ~bmask)) :
                     (state==S_EX_WR     ) ? R[dst] :
                     // ---- BATCH 3 ----
                     (state==S_INCDA_WR  ) ? operand :
                     (state==S_LDBSTA_WR ) ? (ea[0] ? {operand[15:8], ldbst_val}
                                                      : {ldbst_val, operand[7:0]}) :
                     // ---- BATCH 4 ---- (lane = R[ptr][0], the address LSB -- NOT the
                     // pointer register-NUMBER's bit0; same mistake-to-avoid the existing
                     // S_LDBST_WR line above already gets right via `R[dst][0]`)
                     (state==S_RESETB_WR ) ? (R[dst][0] ? {operand[15:8], resetb_new}
                                                          : {resetb_new, operand[7:0]}) :
                     (state==S_EXB_WR    ) ? (R[src][0] ? {operand[15:8], exb_val}
                                                          : {exb_val, operand[7:0]}) :
                     // ---- BATCH 5 ---- (lane = ea[0], the FETCHED/indexed address' LSB,
                     // matching S_LDBDA_RD's convention -- not a register bit)
                     (state==S_DAB_RESB_WR) ? (ea[0] ? {operand[15:8], daresb_new}
                                                       : {daresb_new, operand[7:0]}) :
                     (state==S_DAB_RESW_WR) ? (bitop_set ? (operand | bmask) : (operand & ~bmask)) :
                     (state==S_DAB_EXB_WR ) ? (ea[0] ? {operand[15:8], exb_val}
                                                       : {exb_val, operand[7:0]}) :
                     (state==S_DAB_EXW_WR ) ? R[dst] :
                     // ---- BATCH 5 PART 2 ---- (lane = R[dst][0], matching S_LDBST_WR's
                     // established convention for a register-indirect byte RMW pointer)
                     (state==S_TSETBI_WR) ? (R[dst][0] ? {operand[15:8], 8'hFF}
                                                         : {8'hFF, operand[7:0]}) :
                     (state==S_CLRBI_WR ) ? (R[dst][0] ? {operand[15:8], 8'h00}
                                                         : {8'h00, operand[7:0]}) :
                     (state==S_COMI_WR  ) ? operand :
                     (state==S_NEGI_WR  ) ? operand :
                     (state==S_TSETI_WR ) ? 16'hFFFF :
                     (state==S_CLRI_WR  ) ? 16'h0000 :
                     // ---- BATCH 6 ---- (all three WR states already hold the fully-
                     // merged new word in `operand` by the time WR runs, computed in
                     // their RD sibling -- same shape as the pre-existing S_INCDA_WR line)
                     (state==S_INCDAB_WR || state==S_INCBI_WR || state==S_INCWI_WR) ? operand :
                     // ---- BATCH 10 ---- (S_DAD_WR holds the fully-computed new WORD in
                     // `operand`, same shape as S_INCDA_WR/S_COMI_WR/S_NEGI_WR/S_TSETI_WR.
                     // S_DAC_WR merges the fully-computed new BYTE `dacres` into the ea[0]
                     // lane of the word read back in S_DAC_RD, same shape as S_LDBSTA_WR/
                     // S_RESETB_WR/S_DAB_RESB_WR.)
                     (state==S_DAD_WR) ? operand :
                     (state==S_DAC_WR) ? (ea[0] ? {operand[15:8], dacres}
                                                  : {dacres, operand[7:0]}) :
                     // ---- BATCH 11 ---- (S_PLDA/S_POLDA WR_HI/WR_LO write the hi/lo halves
                     // staged in operand/operand2 by their own RD_HI/RD_LO, same shape as
                     // every other hi-then-lo 32-bit WR pair in this file, e.g. S_L32_WR_*.)
                     (state==S_PLDA_WR_HI  || state==S_POLDA_WR_HI) ? operand  :
                     (state==S_PLDA_WR_LO  || state==S_POLDA_WR_LO) ? operand2 :
                     // ---- BATCH 17: trap accept push order (PC, then OLD fcw, then the
                     // trapping opcode word) -- matches MAME's PUSH_PC()/PUSHW(SP,fcw)/
                     // PUSHW(SP,m_op[0]) sequence exactly (see S_TRAP_* state comments).
                     (state==S_TRAP_PC )  ? pc  :
                     (state==S_TRAP_FCW)  ? fcw :
                     (state==S_TRAP_OP )  ? ir  :
                     // ---- BATCH 18: OUTB/OUT -- matches MAME's WRPORT_B(value16=value|
                     // (value<<8)) / WRPORT_W(value) exactly: byte form replicates the
                     // byte into both halves (the address-derived lane/lane-mask on the
                     // other end of the bus picks the real one, same as every other byte
                     // write in this file); word form is the plain register value. ----
                     (state==S_OUTB_GO)   ? {2{src[3] ? R[src[2:0]][7:0] : R[src[2:0]][15:8]}} :
                     (state==S_OUT_GO )   ? R[src] :
                     // ---- BATCH 19: 0x3A/0x3B port I/O writes. Single OUT form: same
                     // replicate-byte/plain-word shape as OUTB/OUT above (src here holds
                     // the value register, byte-reg-code for the byte family). Block
                     // form: `iob_wr_dout` (declared above) already encodes the full
                     // per-direction/per-width logic (RMW merge for byte-to-memory,
                     // replicate for byte-to-port, passthrough for word). ----
                     (state==S_IOS_WR) ? (io_wide ? R[src] : {2{src[3] ? R[src[2:0]][7:0] : R[src[2:0]][15:8]}}) :
                     (state==S_IOB_WR) ? iob_wr_dout :
                                        16'h0000;

    assign dbg_pc=pc; assign dbg_fcw=fcw; assign dbg_ir=ir;
    assign dbg_retire=retire; assign dbg_illegal=illegal;
    assign dbg_regs = { R[15],R[14],R[13],R[12],R[11],R[10],R[9],R[8],
                        R[7],R[6],R[5],R[4],R[3],R[2],R[1],R[0] };

    function automatic cc_true(input [3:0] cc, input c, input z, input s, input pv);
        case (cc)
            4'h0: cc_true=1'b0;          4'h8: cc_true=1'b1;
            4'h1: cc_true=pv^s;          4'h9: cc_true=~(pv^s);
            4'h2: cc_true=z|(pv^s);      4'hA: cc_true=~(z|(pv^s));
            4'h3: cc_true=z|c;           4'hB: cc_true=~(z|c);
            4'h4: cc_true=pv;            4'hC: cc_true=~pv;
            4'h5: cc_true=s;             4'hD: cc_true=~s;
            4'h6: cc_true=z;             4'hE: cc_true=~z;
            4'h7: cc_true=c;             4'hF: cc_true=~c;
        endcase
    endfunction

    // combinational scratch
    reg [15:0] pc2, disp2;
    reg [8:0]  add8, incb_sum;
    reg [16:0] incw_sum, sum17, dif17;
    reg [15:0] a16, res16, fmask, fval, scnt;
    reg [7:0]  dbyte, operand_b;
    reg [7:0]  dab_byte;          // BATCH 8: DAB source byte
    reg [10:0] dab_idx;           // BATCH 8: DAB rom index {DA,H,C,byte}
    reg [8:0]  dab_res;           // BATCH 8: DAB rom result {carry,byte}
    reg [4:0]  cnt;
    reg [4:0]  incn;
    reg        z,s,v,c,h,wb, cbit;
    // BATCH 2 combinational scratch
    reg [7:0]  res8;             // byte-ALU result
    reg        p;                // parity flag (byte AND/OR/XOR P/V, MAME z8000_zsp[])
    reg [32:0] dif33;            // 33-bit long-compare scratch (CPL, reused by SUBL/S_LALU_GO)
    // BATCH 3 combinational scratch
    reg [4:0]  i4p1;             // INC/DEC addr,#n imm4m1+1 (5-bit -- avoids the 4-bit
                                  // wraparound that `incn` has for field value 0xF/"+16",
                                  // see report; do NOT narrow this to match `incn`)
    reg signed [31:0] mul_p32;   // MULT 16x16->32 product
    reg signed [63:0] mul_p64;   // MULTL 32x32->64 product
    reg signed [31:0] div_dvd, div_dvs, div_q, div_qtmp; // DIV 32/16 scratch (dvs sign-
                                  // extended to 32 so the divide is same-width both sides)
    reg signed [15:0] div_r;     // DIV remainder
    reg signed [63:0] div_dvd64, div_dvs64, div_q64, div_qtmp64; // DIVL 64/32 scratch
    reg signed [31:0] div_r32;   // DIVL remainder
    // ---- AREA FIX 2026-07-19: shared sequential restoring-divider datapath ----
    // Sized 64-bit so ONE datapath serves both DIV (32/16) and DIVL (64/32); DIV
    // simply zero/sign-pads into the same registers. Magnitude division + sign
    // restore reproduces Verilog's signed `/`,`%` semantics exactly (truncate
    // toward zero; remainder takes the DIVIDEND's sign) -- which the old code's
    // header already established is algebraically identical to MAME's DIVW/DIVL
    // abs/sign-restore dance in z8000ops.hxx. Most-negative operands are safe:
    // negating -2^63 yields 0x8000_0000_0000_0000, which read as UNSIGNED is
    // exactly the magnitude 2^63.
    reg [63:0] dv_rem;           // running remainder (restoring division)
    reg [63:0] dv_quo;           // dividend in, quotient out (shifts through)
    reg [63:0] dv_dvsr;          // divisor magnitude
    reg [64:0] dv_shf, dv_sub;   // combinational: shifted remainder, trial subtract
    reg [6:0]  dv_cnt;           // iteration counter, 0..64
    reg        dv_qneg, dv_rneg; // result signs: q = sign(dvd)^sign(dvs), r = sign(dvd)
    reg        dv_long;          // 0 = DIV (finish via S_DIV_FIN), 1 = DIVL (S_DIVL_FIN)
    reg signed [63:0] dv_q_signed, dv_r_signed; // combinational sign-restored results
    reg [31:0] a32, val32, res32; // ADDL/SUBL 32-bit operands/result
    reg [32:0] sum33;            // ADDL 33-bit carry scratch (dif33 doubles for SUBL/CPL)
    // BATCH 4 combinational scratch
    reg [4:0]  nibc;             // ADC/SBC nibble carry/borrow-out scratch (H flag),
                                  // same 5-bit-add-with-carry-in-bit4 shape as the file's
                                  // existing 9-bit (add8) / 17-bit (sum17/dif17) carry
                                  // scratch, one level narrower.
    // BATCH 14 combinational scratch
    reg [7:0]  dcnt;             // SDLB/SDAB/SDLW/SDAW/SDLL/SDAL dynamic shift magnitude
                                  // (0-128, sign-negated from the count register's low byte
                                  // same convention as the existing `scnt`/`cnt` used by the
                                  // immediate-count S_SHIFT/S_SHIFTA/S_SHIFTL, just 8 bits
                                  // wide instead of 5 -- a register-sourced int8_t count can
                                  // reach magnitude 128 (from -128), wider than any fetched
                                  // immediate field this file has shifted by before).

    // ---- shared register-file writeback bus (see the writeback block at the
    //      very end of the main always block for the rationale) ----
    reg        rwb0_we,  rwb1_we,  rwb2_we,  rwb3_we;
    reg [3:0]  rwb0_idx, rwb1_idx, rwb2_idx, rwb3_idx;
    reg [15:0] rwb0_val, rwb1_val, rwb2_val, rwb3_val;
    reg [1:0]  rwb0_be,  rwb1_be,  rwb2_be,  rwb3_be;   // {high byte en, low byte en}

    integer i;
    always @(posedge clk) begin
        if (!reset_n) begin
            pc<=0; fcw<=0; ir<=0; dst<=0; src<=0; aluop<=0; operand<=0;
            ea<=0; daop<=0; retire<=0; illegal<=0; state<=S_RST_FCW;
            psap<=16'h0000; nvi_pending<=1'b0; nvi_n_d<=1'b1; mcnt<=4'h0; l32wb<=1'b0;
            operand2<=16'h0000; bmask<=16'h0000; bitop_set<=1'b0;
            idxr<=4'h0;
            target_cycles<=16'd0; cyc_count<=16'd1; // BATCH 9: cyc_count>=target_cycles so
                                                      // the first S_FETCH0 dispatches immediately
            for (i=0;i<16;i=i+1) R[i]<=16'h0000;
        end else if (ce) begin
            retire <= 1'b0;
            // BATCH 9: default tick, EVERY ce cycle regardless of state (an instruction's
            // own natural execution states are NOT S_FETCH0, and must still count toward
            // its target) -- overridden to 16'd1 only in S_FETCH0's dispatch branch below,
            // same "default-then-override-in-a-later-branch" idiom as `retire` above.
            cyc_count <= cyc_count + 16'd1;
            pc2 = pc + 16'd2;
            // level-triggered NVI latch (MAME execute_input_edge_triggered==false for NVI):
            // ================= NVIEDGE-2026-09-05 ==============================
            // Was `if (!nvi_n) nvi_pending <= 1'b1;` -- level-sampled every ce, so
            // the accept's clear was undone on the very next ce while the line was
            // still low, and each IRET re-entered the handler. MEASURED: exactly
            // 2.000 handler entries/frame on both subs (correct = 1.000).
            //
            // MAME sets the request ONLY in execute_set_input(), which the scheduler
            // calls on line TRANSITIONS -- z8000.cpp: ASSERT does `m_irq_req |=
            // Z8000_NVI`, accept does `m_irq_req &= ~Z8000_NVI`, and nothing re-sets
            // it while the line stays asserted. So it is one-shot per assertion.
            //
            // PAIRED WITH PolePosition_subcpu.sv NVI-ACK-ON-DISABLE-2026-09-05: that
            // fix de-asserts nvi_n on the sub's 0x6000 write, which is what produces
            // the rising edge that arms the next frame. Reverting that one WITHOUT
            // reverting this leaves nvi_n low forever -> no further assert edge ->
            // the subs take one NVI and never run again. Move the two together.
            //
            // TO RIP OUT: restore `if (!nvi_n) nvi_pending <= 1'b1;` and drop nvi_n_d.
            // ==================================================================
            nvi_n_d <= nvi_n;
            if (!nvi_n && nvi_n_d) nvi_pending <= 1'b1;
            // writeback-bus defaults: no channel writes unless a state arm claims one
            rwb0_we=1'b0; rwb0_idx=4'd0; rwb0_val=16'h0000; rwb0_be=2'b11;
            rwb1_we=1'b0; rwb1_idx=4'd0; rwb1_val=16'h0000; rwb1_be=2'b11;
            rwb2_we=1'b0; rwb2_idx=4'd0; rwb2_val=16'h0000; rwb2_be=2'b11;
            rwb3_we=1'b0; rwb3_idx=4'd0; rwb3_val=16'h0000; rwb3_be=2'b11;
            case (state)
            S_RST_FCW: begin fcw<=din; state<=S_RST_PC; end
            S_RST_PC:  begin pc <=din; state<=S_FETCH0; end

            S_FETCH0: begin
              // ==== BATCH 9 2026-07-28: cycle-accuracy padding gate. `cyc_count` ticks
              // every ce cycle unconditionally (the default assignment at the top of this
              // block, same idiom as `retire`) starting from the instant an instruction is
              // dispatched (reset to 1 below); `target_cycles` is that instruction's real
              // MAME cycle count, latched at the same moment. If real hardware would still
              // be mid-instruction, idle here (mem[pc] keeps combinationally reading the
              // next opcode harmlessly -- addr defaults to `pc` in this state -- but we
              // don't ACT on it yet). Once caught up, dispatch exactly as before and latch
              // the NEW instruction's target cycle count for next time. This is the ONLY
              // change needed for full-ISA cycle accuracy -- zero edits to any of the ~180
              // existing dispatch arms or their state sequences below. ====
              if (cyc_count < target_cycles) begin
                  // not yet time -- default `cyc_count<=cyc_count+1` above already applies
              end else begin
              target_cycles <= lookup_cycles(din);
              cyc_count <= 16'd1;
              // ---- NVI accept (instruction-boundary check, ahead of decode) ----
              // MAME z8002_device::Interrupt(): (m_irq_req&Z8000_NVI)&&(m_fcw&F_NVIE)
              if (nvi_pending && ((fcw & F_NVIE)!=16'h0000)) begin
                  state <= S_NVI_PC;
              end else begin
                ir <= din;
                // ---- CLR rd (0x8Dd8, no flags) ----
                if (din[15:8]==8'h8D && din[3:0]==4'h8) begin
                    rwb0_we=1'b1; rwb0_idx=din[7:4]; rwb0_val=16'h0000; pc<=pc2; retire<=1'b1;
                end
                // ---- LD rd,#imm16 (0x210d) / LD rd,@rs (0x21, src!=0) ----
                else if (din[15:8]==8'h21) begin
                    dst<=din[3:0]; aluop<=LD; pc<=pc2;
                    if (din[7:4]==0) state<=S_IMM;
                    else begin src<=din[7:4]; state<=S_MEMRD; end
                end
                // ---- reg-reg ALU: A1=LD 81=ADD 83=SUB 85=OR 87=AND 89=XOR 8B=CP ----
                else if (din[15:8]==8'hA1 || din[15:8]==8'h81 || din[15:8]==8'h83 ||
                         din[15:8]==8'h85 || din[15:8]==8'h87 || din[15:8]==8'h89 ||
                         din[15:8]==8'h8B) begin
                    dst<=din[3:0]; operand<=R[din[7:4]]; pc<=pc2; state<=S_ALU;
                    case (din[15:8])
                        8'hA1: aluop<=LD;  8'h81: aluop<=ADD; 8'h83: aluop<=SUB;
                        8'h85: aluop<=OR;  8'h87: aluop<=AND; 8'h89: aluop<=XOR;
                        default: aluop<=CP;
                    endcase
                end
                // ---- mem/imm word ALU: 01=ADD 03=SUB 05=OR 07=AND 09=XOR 0B=CP ----
                else if (din[15:8]==8'h01 || din[15:8]==8'h03 || din[15:8]==8'h05 ||
                         din[15:8]==8'h07 || din[15:8]==8'h09 || din[15:8]==8'h0B) begin
                    dst<=din[3:0]; pc<=pc2;
                    case (din[15:8])
                        8'h01: aluop<=ADD; 8'h03: aluop<=SUB; 8'h05: aluop<=OR;
                        8'h07: aluop<=AND; 8'h09: aluop<=XOR; default: aluop<=CP;
                    endcase
                    if (din[7:4]==0) state<=S_IMM;
                    else begin src<=din[7:4]; state<=S_MEMRD; end
                end
                // ---- ADDB rd,@rs (0x00, src!=0, byte) ----
                else if (din[15:8]==8'h00 && din[7:4]!=4'h0) begin
                    src<=din[7:4]; dst<=din[3:0]; pc<=pc2; state<=S_ADDB_RD;
                end
                // ---- LD @rd,rs store (0x2F, NIB2=dst(ptr)!=0) : ptr=NIB2, data=NIB3 ----
                // MAME Z2F_ddN0_ssss requires ptr!=0 (R0-as-pointer is undefined here, same
                // "N0" convention as every other @rd-pointer family in this file); the guard
                // was missing -- found via the cycle-accuracy audit (dst==0 maps to MAME's
                // own zinvalid table entry, not a real instruction).
                else if (din[15:8]==8'h2F && din[7:4]!=4'h0) begin
                    dst<=din[7:4]; src<=din[3:0]; pc<=pc2; state<=S_MEMWR;
                end
                // ---- SLL/SRL rd,#imm (0xB3, NIB3=1) ----
                else if (din[15:8]==8'hB3 && din[3:0]==4'h1) begin
                    dst<=din[7:4]; pc<=pc2; state<=S_SHIFT;
                end
                // ==== BATCH 7: SLA/SRA rd,#imm (0xB3, NIB3=9) : MAME ZB3_dddd_1001_imm8 ====
                else if (din[15:8]==8'hB3 && din[3:0]==4'h9) begin
                    dst<=din[7:4]; pc<=pc2; state<=S_SHIFTA;
                end
                // ==== BATCH 7: SLAL/SRAL rrd,#imm (0xB3, NIB3=D) : MAME ZB3_dddd_1101_imm8 ==
                else if (din[15:8]==8'hB3 && din[3:0]==4'hD) begin
                    dst<=din[7:4]; pc<=pc2; state<=S_SHIFTAL;
                end
                // ==== BATCH 7: SLLL/SRLL rrd,#imm (0xB3, NIB3=5) : MAME ZB3_dddd_0101_imm8 ==
                else if (din[15:8]==8'hB3 && din[3:0]==4'h5) begin
                    dst<=din[7:4]; pc<=pc2; state<=S_SHIFTL;
                end
                // ==== BATCH 7: LDA prd,addr (0x7600-0x760f, NIB2==0) : MAME Z76_0000_dddd_addr
                else if (din[15:8]==8'h76 && din[7:4]==4'h0) begin
                    dst<=din[3:0]; lda76_has_src<=1'b0; pc<=pc2; state<=S_LDA76_FETCH;
                end
                // ==== BATCH 7: LDA prd,addr(rs) (0x7610-0x76ff, NIB2!=0) : MAME
                //      Z76_ssN0_dddd_addr ====
                else if (din[15:8]==8'h76 && din[7:4]!=4'h0) begin
                    dst<=din[3:0]; src<=din[7:4]; lda76_has_src<=1'b1; pc<=pc2; state<=S_LDA76_FETCH;
                end
                // ==== BATCH 8: LD rd,rs(rx) (0x71, NIB2!=0) : MAME
                // Z71_ssN0_dddd_0000_xxxx_0000_0000. word1: src=NIB2(bits7:4,nonzero),
                // dst=NIB3(bits3:0). word2: idx=NIB1(bits11:8), rest reserved/zero -- NOT
                // an address literal like every other *_FETCH family in this file, so
                // S_LD71_FETCH reads it straight off `din[11:8]` (no idxr staging) to form
                // ea=R[src]+R[idx], then joins a dedicated one-cycle S_LD71_RD (can't reuse
                // S_DA_RD: that path always writes back via daop, this is a fixed plain LD). ====
                else if (din[15:8]==8'h71 && din[7:4]!=4'h0) begin
                    src<=din[7:4]; dst<=din[3:0]; pc<=pc2; state<=S_LD71_FETCH;
                end
                // ==== BATCH 13: 0x70/72/73/74/75/77, the rest of the register+register-
                // indexed family (0x71's siblings, same word2-NIB1-is-an-index-REGISTER-
                // NUMBER shape). ====
                // ---- Z70: LDB rbd,rs(rx) -- byte load. dst=NIB3(dest breg), src=NIB2(base
                // ptr reg,nonzero). Joins EXISTING S_LDBDA_RD tail. ----
                else if (din[15:8]==8'h70 && din[7:4]!=4'h0) begin
                    src<=din[7:4]; dst<=din[3:0]; pc<=pc2; state<=S_Z70_FETCH;
                end
                // ---- Z72: LDB rd(rx),rbs -- byte store. src=NIB3(value breg), dst=NIB2
                // (base ptr reg,nonzero -- scratch-held, not read by the S_LDBSTA_RD/WR
                // tail it joins). ----
                else if (din[15:8]==8'h72 && din[7:4]!=4'h0) begin
                    dst<=din[7:4]; src<=din[3:0]; pc<=pc2; state<=S_Z72_FETCH;
                end
                // ---- Z73: LD rd(rx),rs -- word store. src=NIB3(value), dst=NIB2(base ptr,
                // nonzero, scratch). Joins EXISTING S_DA_WR tail, daop=DA_STR. ----
                else if (din[15:8]==8'h73 && din[7:4]!=4'h0) begin
                    dst<=din[7:4]; src<=din[3:0]; daop<=DA_STR; pc<=pc2; state<=S_Z73_FETCH;
                end
                // ---- Z74: LDA prd,rs(rx) -- register-ONLY address computation (dst<=R[src]
                // +R[idx], no memory access), dst=NIB3, src=NIB2(base,nonzero). ----
                else if (din[15:8]==8'h74 && din[7:4]!=4'h0) begin
                    src<=din[7:4]; dst<=din[3:0]; pc<=pc2; state<=S_Z74_FETCH;
                end
                // ---- Z75: LDL rrd,rs(rx) -- long load. dst=NIB3(dest pair), src=NIB2(base
                // ptr,nonzero). Joins EXISTING S_L32_RD_HI tail. ----
                else if (din[15:8]==8'h75 && din[7:4]!=4'h0) begin
                    src<=din[7:4]; dst<=din[3:0]; pc<=pc2; state<=S_Z75_FETCH;
                end
                // ---- Z77: LDL rd(rx),rrs -- long store. src=NIB3(value pair), dst=NIB2
                // (base ptr,nonzero,scratch). Joins EXISTING S_L32_WR_HI tail. ----
                else if (din[15:8]==8'h77 && din[7:4]!=4'h0) begin
                    dst<=din[7:4]; src<=din[3:0]; pc<=pc2; state<=S_Z77_FETCH;
                end
                // ==== BATCH 16: JP cc,addr (0x5E00-0x5E0F, NIB2=0) : MAME
                // Z5E_0000_cccc_addr "jp cc,addr". cc=NIB3. Direct form: jump target is
                // exactly the fetched addr word, no index. ====
                else if (din[15:8]==8'h5E && din[7:4]==4'h0) begin
                    src<=din[3:0]; jpx<=1'b0; pc<=pc2; state<=S_JP;
                end
                // ==== BATCH 16 BUG FIX: JP cc,addr(rd) (0x5E10-0x5EFF, NIB2=dst!=0) : MAME
                // Z5E_ddN0_cccc_addr "jp cc,addr(rd)". cc=NIB3, dst(NIB2)=index register.
                // addr_add(addr,RW(dst)) BEFORE the cc test -- jump target when taken is
                // addr+R[dst]. The OLD code here matched this whole range with NO NIB2
                // check and no index addend at all (silent wrong-target bug, see the jpx
                // declaration comment). ====
                else if (din[15:8]==8'h5E && din[7:4]!=4'h0) begin
                    src<=din[3:0]; idxr<=din[7:4]; jpx<=1'b1; pc<=pc2; state<=S_JP;
                end
                // ---- LD rd,addr direct (0x61, NIB2=0) ----
                else if (din[15:8]==8'h61 && din[7:4]==4'h0) begin
                    dst<=din[3:0]; daop<=DA_LDR; pc<=pc2; state<=S_DA_FETCH;
                end
                // ---- LD addr,rs direct (0x6F, NIB2=0) ----
                else if (din[15:8]==8'h6F && din[7:4]==4'h0) begin
                    src<=din[3:0]; daop<=DA_STR; pc<=pc2; state<=S_DA_FETCH;
                end
                // ---- LD @rd,#imm16 (0x0D, NIB3=5, dst!=0): EA=R[dst] ----
                // MAME Z0D_ddN0_0101_imm16 requires dst!=0 (R0-as-pointer undefined, same
                // "N0" convention used elsewhere); guard was missing, found via the
                // cycle-accuracy audit (dst==0 maps to MAME's zinvalid entry).
                else if (din[15:8]==8'h0D && din[3:0]==4'h5 && din[7:4]!=4'h0) begin
                    ea<=R[din[7:4]]; daop<=DA_STI; pc<=pc2; state<=S_DA_IMM;
                end
                // ---- direct group (0x4D, NIB2=0): 1=CP#imm 5=LD#imm 8=CLR 4=TEST ----
                // CP-DIRECT-FIX-2026-08-09: 4'h1 (CP addr,#imm16 -- MAME
                // Z4D_0000_0001_addr_imm16) was MISSING here and fell to the
                // default -> S_ILLEGAL, which is a silent terminal hang
                // (`S_ILLEGAL: ;`). BATCH 8 added this same sub-op to the INDEXED
                // sibling below (4'h1 -> DA_CPI) but never to this direct form.
                // HW effect: both Pole Position subs execute it in attract mode --
                // pp_sub1.asm 27B0 `cp %8000,#%0059`, pp_sub2.asm 0772
                // `cp %8c80,#%8008` -- so both Z8002s hung and the road/sprite/view
                // buffers froze while the Z80 carried on running attract.
                // BATCH 10: added 4'h0/2/6 (COM/NEG/TSET, word RMW via dadop+S_DAD_FETCH --
                // same shape as the already-verified register-indirect S_COMI/S_NEGI/S_TSETI).
                else if (din[15:8]==8'h4D && din[7:4]==4'h0) begin
                    pc<=pc2;
                    case (din[3:0])
                        4'h0: begin dadop<=2'd0; state<=S_DAD_FETCH; end  // COM
                        4'h1: begin daop<=DA_CPI; state<=S_DA_FETCH; end
                        4'h2: begin dadop<=2'd1; state<=S_DAD_FETCH; end  // NEG
                        4'h5: begin daop<=DA_STI; state<=S_DA_FETCH; end
                        4'h6: begin dadop<=2'd2; state<=S_DAD_FETCH; end  // TSET
                        4'h8: begin daop<=DA_CLR; state<=S_DA_FETCH; end
                        4'h4: begin daop<=DA_TST; state<=S_DA_FETCH; end
                        default: begin illegal<=1'b1; state<=S_ILLEGAL; end
                    endcase
                end
                // ==== BATCH 8: indexed group (0x4D, NIB2!=0): addr(rx) instead of plain addr
                // -- 1=CP#imm(NEW: MAME Z4D_ddN0_0001_addr_imm16, compare mem@addr(rx) against
                // a fetched imm16, discard result, CZSV flags per the existing S_ALU CP shape)
                // 5=LD#imm(MAME Z4D_ddN0_0101_addr_imm16) 4=TEST(MAME Z4D_ddN0_0100_addr).
                // "dst" here is really the INDEX register (MAME's own naming, kept only for
                // its GET_DST macro use) -- reused as `idxr` per this file's convention. ====
                // BATCH 10: added 4'h0/2/6 (COM/NEG/TSET via dadop+S_DAD_FETCHX) AND 4'h8
                // (CLR -- MAME Z4D_ddN0_1000_addr, was MISSING from this indexed case
                // entirely, a second CP-DIRECT-FIX-shaped gap: it silently fell to
                // S_ILLEGAL just like 4D01 did before today's fix). Routes to the EXISTING
                // DA_CLR/S_DAX_FETCH path -- but S_DAX_FETCH's own case had no DA_CLR arm
                // either (see the fix at S_DAX_FETCH below), so both halves needed fixing.
                else if (din[15:8]==8'h4D && din[7:4]!=4'h0) begin
                    idxr<=din[7:4]; pc<=pc2;
                    case (din[3:0])
                        4'h0: begin dadop<=2'd0; state<=S_DAD_FETCHX; end // COM
                        4'h1: begin daop<=DA_CPI; state<=S_DAX_FETCH; end
                        4'h2: begin dadop<=2'd1; state<=S_DAD_FETCHX; end // NEG
                        4'h5: begin daop<=DA_STI; state<=S_DAX_FETCH; end
                        4'h6: begin dadop<=2'd2; state<=S_DAD_FETCHX; end // TSET
                        4'h4: begin daop<=DA_TST; state<=S_DAX_FETCH; end
                        4'h8: begin daop<=DA_CLR; state<=S_DAX_FETCH; end // BATCH 10 fix
                        default: begin illegal<=1'b1; state<=S_ILLEGAL; end
                    endcase
                end
                // ==== BATCH 10: direct-address(+index) BYTE static-op family, 0x4C --
                // mirrors the word 0x4D family immediately above (same NIB3 sub-op codes:
                // 0=COMB 1=CPB#imm8 2=NEGB 4=TESTB 5=LDB#imm8 6=TSETB 8=CLRB), shares one
                // FETCH/FETCHX/[IMM]/RD-or-RDRO/[WR] pipe selected by `dacop`, see the
                // S_DAC_* state bodies for the per-op flag formulas (transcribed from
                // z8000ops.hxx Z4C_*, each verified against its register-indirect Z0C_*
                // sibling's already-working formula). MAME QUIRK: Z4C_0000_0000_addr
                // (COMB addr, direct, no index) reads via RDMEM_W not RDMEM_B in
                // z8000ops.hxx -- an apparent source typo (every OTHER member of this
                // family, incl. this op's own indexed sibling Z4C_ddN0_0000_addr, uses
                // RDMEM_B) -- implemented here consistently with RDMEM_B like every
                // sibling, NOT MAME's literal truncating-RDMEM_W behavior (flagged in
                // report, not guessed past silently). ====
                else if (din[15:8]==8'h4C && din[7:4]==4'h0) begin
                    pc<=pc2;
                    case (din[3:0])
                        4'h0: begin dacop<=3'd0; state<=S_DAC_FETCH; end // COMB
                        4'h1: begin dacop<=3'd5; state<=S_DAC_FETCH; end // CPB #imm8
                        4'h2: begin dacop<=3'd1; state<=S_DAC_FETCH; end // NEGB
                        4'h4: begin dacop<=3'd2; state<=S_DAC_FETCH; end // TESTB
                        4'h5: begin dacop<=3'd6; state<=S_DAC_FETCH; end // LDB #imm8
                        4'h6: begin dacop<=3'd3; state<=S_DAC_FETCH; end // TSETB
                        4'h8: begin dacop<=3'd4; state<=S_DAC_FETCH; end // CLRB
                        default: begin illegal<=1'b1; state<=S_ILLEGAL; end
                    endcase
                end
                else if (din[15:8]==8'h4C && din[7:4]!=4'h0) begin
                    idxr<=din[7:4]; pc<=pc2;
                    case (din[3:0])
                        4'h0: begin dacop<=3'd0; state<=S_DAC_FETCHX; end
                        4'h1: begin dacop<=3'd5; state<=S_DAC_FETCHX; end
                        4'h2: begin dacop<=3'd1; state<=S_DAC_FETCHX; end
                        4'h4: begin dacop<=3'd2; state<=S_DAC_FETCHX; end
                        4'h5: begin dacop<=3'd6; state<=S_DAC_FETCHX; end
                        4'h6: begin dacop<=3'd3; state<=S_DAC_FETCHX; end
                        4'h8: begin dacop<=3'd4; state<=S_DAC_FETCHX; end
                        default: begin illegal<=1'b1; state<=S_ILLEGAL; end
                    endcase
                end
                // ==== BATCH 10: LDB addr(rd),rbs (0x4E) -- MAME QUIRK: z8000tbl.hxx's ONLY
                // table entry for this handler is `{0x4e11,0x4ef0,16,...}`, which (per the
                // verified beg/end/step init loop in z8000.cpp: `for(val=beg;val<=end;
                // val+=step) z8000_exec[val]=...`) dispatches ONLY src(NIB3)=1, dst/idxr
                // (NIB2)=1..E to the real handler -- NOT the full "ddN0_ssN0" nonzero-both
                // space its own name implies. Its semantic sibling Z6E_ddN0_ssss_addr
                // (0x6E, already implemented) uses a DENSE step=1 table for the identical
                // shape (index reg + byte value reg + fetched addr) -- confirming
                // 2-free-nibble instructions normally get dense tables in this source, so
                // this step=16 entry looks like a genuine MAME table-authoring bug, not
                // real hardware behavior. Implemented CONSERVATIVELY matching MAME's
                // LITERAL dispatch only (src fixed at reg-code 1, dst/idxr=1..E) rather
                // than guessing the broader "any src, any dst" interpretation -- flagged
                // in report for the user's call. Reuses the EXISTING S_LDBSTAX_FETCH/
                // S_LDBSTA_RD/WR states verbatim (same shape as 0x6E indexed), zero new
                // states. ====
                else if (din[15:8]==8'h4E && din[7:4]!=4'h0 && din[7:4]!=4'hF && din[3:0]==4'h1) begin
                    src<=din[3:0]; idxr<=din[7:4]; pc<=pc2; state<=S_LDBSTAX_FETCH;
                end
                // ---- DEC rd,#n (0xAB, word, ZSV) ----
                else if (din[15:8]==8'hAB) begin
                    incn=din[3:0]+5'd1; a16=R[din[7:4]]; res16=a16-{11'd0,incn};
                    v=a16[15] & ~res16[15];
                    rwb0_we=1'b1; rwb0_idx=din[7:4]; rwb0_val=res16;
                    fcw<=(fcw & ~(MZ|MS|MV)) | ((res16==0)?MZ:0)|(res16[15]?MS:0)|(v?MV:0);
                    pc<=pc2; retire<=1'b1;
                end
                // ---- DECB rbd,#n (0xAA, byte, ZSV) ----
                else if (din[15:8]==8'hAA) begin
                    incn=din[3:0]+5'd1;
                    dbyte = din[7] ? R[din[6:4]][7:0] : R[din[6:4]][15:8];
                    add8 = {1'b0,dbyte} - {4'd0,incn};
                    v = dbyte[7] & ~add8[7];
                    rwb0_we=1'b1; rwb0_idx={1'b0,din[6:4]}; rwb0_val={2{add8[7:0]}}; rwb0_be=din[7]?2'b01:2'b10;
                    fcw<=(fcw & ~(MZ|MS|MV)) | ((add8[7:0]==0)?MZ:0)|(add8[7]?MS:0)|(v?MV:0);
                    pc<=pc2; retire<=1'b1;
                end
                // ---- INC rd,#n (0xA9, word, ZSV) ----
                else if (din[15:8]==8'hA9) begin
                    incn=din[3:0]+5'd1; incw_sum={1'b0,R[din[7:4]]}+{12'd0,incn};
                    v=(~R[din[7:4]][15]) & incw_sum[15];
                    rwb0_we=1'b1; rwb0_idx=din[7:4]; rwb0_val=incw_sum[15:0];
                    fcw<=(fcw & ~(MZ|MS|MV)) | ((incw_sum[15:0]==0)?MZ:0)
                        | (incw_sum[15]?MS:0) | (v?MV:0);
                    pc<=pc2; retire<=1'b1;
                end
                // ---- INCB rbd,#n (0xA8, byte, ZSV) ----
                else if (din[15:8]==8'hA8) begin
                    incn=din[3:0]+5'd1;
                    dbyte = din[7] ? R[din[6:4]][7:0] : R[din[6:4]][15:8];
                    incb_sum={1'b0,dbyte}+{4'd0,incn};
                    v=(~dbyte[7]) & incb_sum[7];
                    rwb0_we=1'b1; rwb0_idx={1'b0,din[6:4]}; rwb0_val={2{incb_sum[7:0]}}; rwb0_be=din[7]?2'b01:2'b10;
                    fcw<=(fcw & ~(MZ|MS|MV)) | ((incb_sum[7:0]==0)?MZ:0)
                        | (incb_sum[7]?MS:0) | (v?MV:0);
                    pc<=pc2; retire<=1'b1;
                end
                // ---- DJNZ/DBJNZ (0xF, reg=NIB1, w=bit7, no flags) ----
                else if (din[15:12]==4'hF) begin
                    disp2={8'd0,din[6:0],1'b0};
                    if (din[7]) begin
                        rwb0_we=1'b1; rwb0_idx=din[11:8]; rwb0_val=R[din[11:8]]-16'd1;
                        pc<=(R[din[11:8]]-16'd1!=0) ? (pc2-disp2) : pc2;
                    end else begin
                        // ============ DBJNZ-BRANCH-2026-09-05 ==========================
                        // Byte form fell through with pc<=pc2 and NEVER branched, so every
                        // byte dbjnz loop ran exactly one iteration. MAME z8000ops.hxx
                        // ZF_dddd_0dsp7: RB(dst)-=1; if (RB(dst)) set_pc(m_pc - 2*dsp7);
                        // Same shape as the word form directly above. Suite: 16189 -> 0.
                        // NOT visually confirmed on hardware; suite evidence only. The
                        // horizon "pillar" this was expected to fix did not reproduce in
                        // either build, so do NOT record this as the pillar fix.
                        //
                        // TO RIP OUT: delete the four lines below and restore:
                        //   rwb0_we=1'b1; rwb0_idx={1'b0,din[10:8]}; rwb0_be=din[11]?2'b01:2'b10;
                        //   rwb0_val={2{(din[11] ? R[din[10:8]][7:0] : R[din[10:8]][15:8]) - 8'd1}};
                        //   pc<=pc2;
                        // ===============================================================
                        dbyte = (din[11] ? R[din[10:8]][7:0] : R[din[10:8]][15:8]) - 8'd1;
                        rwb0_we=1'b1; rwb0_idx={1'b0,din[10:8]}; rwb0_be=din[11]?2'b01:2'b10;
                        rwb0_val={2{dbyte}};
                        pc<=(dbyte!=8'd0) ? (pc2-disp2) : pc2;
                    end
                    retire<=1'b1;
                end
                // ---- JR cc,dsp8 (0xE, signed, no flags) ----
                else if (din[15:12]==4'hE) begin
                    disp2={{7{din[7]}},din[7:0],1'b0};
                    pc<=cc_true(din[11:8],fcw[FC],fcw[FZ],fcw[FS],fcw[FV]) ? (pc2+disp2) : pc2;
                    retire<=1'b1;
                end
                // ---- IRET (0x7B00, exact match): pop vec/fcw/pc in sequence ----
                else if (din==16'h7B00) begin
                    state<=S_IRET_VEC;
                end
                // ==== BATCH 18: MSET/MRES/MBIT (0x7B08/09/0A, exact match) : MAME
                // Z7B_0000_1000/1001/1010 -- CHECK_PRIVILEGED_INSTR gated (traps to
                // VEC_TRAP unless fcw[14]/F_S_N set). When privileged: multiprocessor
                // mu-0/mu-I cascade line control. No multiprocessor cascade exists on this
                // board (single Z8002, mu pins unconnected) -- MAME's own bodies are
                // LITERALLY EMPTY beyond the privilege check (just a comment: "/* set mu-0
                // line */" etc, no state/flag change at all, confirmed by reading the C
                // bodies directly -- NOT assumed from the MBIT doc-comment's "flags
                // CZS---" claim, which the body never acts on). True no-ops when
                // privileged -- this is not a corner cut, it's what MAME's real C body
                // does verbatim once past the privilege gate. ====
                else if (din==16'h7B08 || din==16'h7B09 || din==16'h7B0A) begin
                    if (!fcw[14]) begin trap_vec<=VEC_TRAP; pc<=pc2; state<=S_TRAP_PC; end
                    else begin pc<=pc2; retire<=1'b1; end
                end
                // ==== BATCH 18: MREQ rd (0x7B_dddd_1101) : MAME Z7B_dddd_1101, flags
                // -ZS---. CHECK_PRIVILEGED_INSTR gated. When privileged: tests the
                // (always-unconnected on this board) mu-I line and inverts the cascade
                // onto mu-0. With mu-I tied low (no multiprocessor peer -- same
                // "unconnected pin" precedent as vi_n/nmi_n elsewhere in this core), MAME's
                // own body resolves UNCONDITIONALLY to Z=1,S=0 (verified term-by-term
                // against the C body's two `if(m_mi)` branches with m_mi=0 substituted);
                // dst(NIB2) is captured by the real body's field decode but never read or
                // written. ====
                else if (din[15:8]==8'h7B && din[3:0]==4'hD) begin
                    if (!fcw[14]) begin trap_vec<=VEC_TRAP; pc<=pc2; state<=S_TRAP_PC; end
                    else begin
                        fcw<=(fcw & ~(MZ|MS)) | MZ;
                        pc<=pc2; retire<=1'b1;
                    end
                end
                // ==== BATCH 18: HALT (0x7A00, exact match) : MAME Z7A_0000_0000.
                // CHECK_PRIVILEGED_INSTR gated. When privileged: genuine, INTENTIONAL
                // non-retiring stop (see S_HALT's own comment -- not a decode bug, matches
                // real hardware, `illegal` never asserted). ====
                else if (din==16'h7A00) begin
                    if (!fcw[14]) begin trap_vec<=VEC_TRAP; pc<=pc2; state<=S_TRAP_PC; end
                    else state<=S_HALT;
                end
                // ==== BATCH 18: LDPS @rs (0x3910-0x39F0, NIB2=src!=0, NIB3=0 FIXED --
                // z8000tbl.hxx's ONLY entry is `{0x3910,0x39f0,16,...}`) : MAME
                // Z39_ssN0_0000. CHECK_PRIVILEGED_INSTR gated. When privileged (non-
                // segmented Z8002 body): fcw=RDMEM_W(RW(src)); set_pc(RDMEM_W(RW(src)+2));
                // CHANGE_FCW(fcw) -- loads new FCW/PC straight from R[src]/R[src]+2 (no
                // operand-word fetch needed at all, EA is already a register value).
                // Joins the shared S_LDPS_RDFCW/RDPC tail (also used by 0x79 below).
                // Single unified memory space (this core has never modeled a separate
                // stack-vs-data space anywhere -- MAME's `src==SP?m_stack:m_data`
                // distinction collapses to the same bus here, consistent with every other
                // instruction in this file). CHANGE_FCW's mode-switch NSP/SSP-swap side
                // effect is skipped (same deliberate single-SP simplification as the
                // S_TRAP_* sequence and this core's existing LDCTL FCW,Rn, which already
                // does a plain `fcw<=R[...]` overwrite with no swap). ====
                else if (din[15:8]==8'h39 && din[7:4]!=4'h0 && din[3:0]==4'h0) begin
                    if (!fcw[14]) begin trap_vec<=VEC_TRAP; pc<=pc2; state<=S_TRAP_PC; end
                    else begin ea<=R[din[7:4]]; pc<=pc2; state<=S_LDPS_RDFCW; end
                end
                // ==== BATCH 18: LDPS addr[,(rs)] (0x7900 exact / 0x7910-0x79F0, NIB3=0
                // FIXED in both) : MAME Z79_0000_0000_addr / Z79_ssN0_0000_addr.
                // CHECK_PRIVILEGED_INSTR gated. When privileged: fetch the addr word
                // (direct) or addr word + R[idxr] (indexed), then join the SAME
                // S_LDPS_RDFCW/RDPC tail as 0x39 above (fcw=RDMEM_W(m_data,addr);
                // set_pc(RDMEM_W(m_data,addr+2))). ====
                else if (din[15:8]==8'h79 && din[3:0]==4'h0) begin
                    if (!fcw[14]) begin trap_vec<=VEC_TRAP; pc<=pc2; state<=S_TRAP_PC; end
                    else if (din[7:4]==4'h0) begin pc<=pc2; state<=S_LDPS_FETCH; end
                    else begin idxr<=din[7:4]; pc<=pc2; state<=S_LDPS_FETCHX; end
                end
                // ==== BATCH 15: the remaining I/O / EPU / reserved / block-string bucket --
                // grouped together because they share the SAME root cause: either genuinely
                // PRIVILEGED + I/O-port hardware this board doesn't have (0x38-0x3F, all of
                // which call CHECK_PRIVILEGED_INSTR then touch real I/O ports this core has
                // no device behind -- `iorq` is documented as "never driven"), or genuinely
                // EPU/reserved opcodes gated on F_EPU (which this core, correctly, never
                // sets -- no Z8001 Extension Processing Unit exists on this board), or BPT
                // (raises an internal TRAP this core has no vectoring for), or complex self-
                // repeating block-string primitives (0xB8/BA/BB TRIB/TRIRB/TRDB/TRDRB and
                // siblings -- NOT privileged, genuinely implementable in principle, but out
                // of scope for this batch's time budget; flagged in report as the strongest
                // follow-up candidate). ALL decoded as ACCEPTED (never S_ILLEGAL -- the
                // task's hard "do not leave as a silent hang" requirement) but functionally
                // a no-op: consume the correct number of operand words for correct PC
                // advancement (matching each handler's real `size` field in z8000tbl.hxx),
                // touch NO register/memory/flag state. This is a deliberate, flagged
                // trade-off (see report), not a claim of full hardware fidelity. ----
                // ==== BATCH 17: real internal traps, per MAME z8000ops.hxx/z8000.cpp
                // exactly, using the S_TRAP_* sequence added this batch. ====
                // ---- Z0E/Z0F/Z8E/Z8F (ext0e/ext0f/ext8e/ext8f) : MAME body calls
                // CHECK_EXT_INSTR() = "if (!(m_fcw & F_EPU)) { trap; return; }" FIRST.
                // F_EPU (fcw bit13) is never set anywhere in this core (no Z8001 EPU
                // exists on this board) UNLESS a real ROM explicitly writes it via LDCTL
                // FCW,Rn (a plain whole-fcw overwrite, already implemented) -- so this
                // reads the LIVE fcw bit, matching MAME exactly: traps unless F_EPU
                // happens to be set. When F_EPU IS set, MAME's body does nothing beyond
                // consuming imm8 (the "Z8001 EPU code goes here" branch is a literal
                // empty comment in z8000ops.hxx, verified -- not guessed). ----
                else if (din[15:8]==8'h0E || din[15:8]==8'h0F ||
                         din[15:8]==8'h8E || din[15:8]==8'h8F) begin
                    if (!fcw[13]) begin trap_vec<=VEC_EPU; pc<=pc2; state<=S_TRAP_PC; end
                    else begin pc<=pc2; retire<=1'b1; end
                end
                // ---- Z36_0000_0000 (BPT, 0x3600 exact) : MAME body is
                // `m_irq_req |= Z8000_TRAP;` UNCONDITIONALLY (no CHECK_ macro at all --
                // this one always traps, in any mode). ----
                else if (din==16'h3600) begin
                    trap_vec<=VEC_TRAP; pc<=pc2; state<=S_TRAP_PC;
                end
                // ---- Z7F_imm8 (SC, system call, 0x7F00-0x7FFF) : MAME body is
                // `GET_IMM8(0); m_irq_req |= Z8000_SYSCALL;` UNCONDITIONALLY (no CHECK_
                // macro -- SC always traps, that's its entire purpose; imm8 is word0's
                // own low byte, already consumed, no PC effect). ----
                else if (din[15:8]==8'h7F) begin
                    trap_vec<=VEC_SYSCALL; pc<=pc2; state<=S_TRAP_PC;
                end
                // ==== BATCH 15 (still no-op, confirmed genuinely correct per MAME -- see
                // report): Z38/Z78/Z7E/Z9D/Z9F/ZBF/Z36_imm8 have NO CHECK_EXT_INSTR call
                // at all in their real C bodies (verified line-by-line) -- they just test
                // `if (m_fcw & F_EPU)` and do nothing meaningful either way (an empty
                // comment placeholder). Since F_EPU is realistically never set on this
                // board, MAME's own source treats these as UNCONDITIONAL no-ops, never
                // traps -- this is not a corner cut, it is the literal, correct behavior
                // per the authoritative source. Z3C/Z3D/Z3E/Z3F (IN/OUT) and 0x38-0x3B's
                // block-I/O group DO need real I/O-bus + privilege-check work -- deferred
                // to the next batch (not folded into this no-op bucket). size=1 (no
                // operand word, single-cycle, inline -- no state needed). ZB9 (rsvdb9,
                // also NO CHECK_EXT_INSTR call) is INCLUDED here too even though
                // z8000tbl.hxx's literal entry is `{0xb900,0xb9ff,16,...}` (NIB3=0 fixed,
                // sparse) -- every ONE of its 11 "_imm8" siblings above uses a DENSE
                // step=1 range (matches the imm8 field living in word0's own low byte,
                // valid for ANY value); ZB9 is the sole outlier, almost certainly the
                // same class of table-authoring typo already caught for Z4E/Z5F (see
                // report) rather than real hardware singling out just this one reserved
                // opcode's low nibble. Treated as dense to match its siblings'
                // overwhelming consensus -- flagged in report, not silently guessed past. ====
                else if (din[15:8]==8'h38 ||
                         din[15:8]==8'h78 || din[15:8]==8'h7E ||
                         din[15:8]==8'h9D ||
                         din[15:8]==8'h9F || din[15:8]==8'hBF || din[15:8]==8'h36 ||
                         din[15:8]==8'hB9) begin
                    pc<=pc2; retire<=1'b1;
                end
                // ==== BATCH 18: INB/IN/OUTB/OUT (0x3C/3D/3E/3F) -- real single-cycle port
                // I/O, CHECK_PRIVILEGED_INSTR gated (traps to VEC_TRAP unless fcw[14]/F_S_N
                // is set, same gate as every other privileged instruction here). When
                // privileged: asserts `iorq` (was hardwired 0, now driven for real -- see
                // the iorq/addr/dout/wordacc mux updates), addr=the port-address register's
                // value, byte forms word-align+lane-select (this file's established byte-
                // access convention, structurally identical to RDPORT_B/WRPORT_B's own
                // addr&~1 + byte-enable-mask shape), word forms use the address directly. ====
                // ---- INB rbd,@rs (0x3C) : MAME Z3C_ssss_dddd. src(NIB2)=port addr reg,
                // dst(NIB3)=dest byte reg. ----
                else if (din[15:8]==8'h3C) begin
                    if (!fcw[14]) begin trap_vec<=VEC_TRAP; pc<=pc2; state<=S_TRAP_PC; end
                    else begin src<=din[7:4]; dst<=din[3:0]; pc<=pc2; state<=S_INB_GO; end
                end
                // ---- IN rd,@rs (0x3D) : MAME Z3D_ssss_dddd. src(NIB2)=port addr reg,
                // dst(NIB3)=dest word reg. ----
                else if (din[15:8]==8'h3D) begin
                    if (!fcw[14]) begin trap_vec<=VEC_TRAP; pc<=pc2; state<=S_TRAP_PC; end
                    else begin src<=din[7:4]; dst<=din[3:0]; pc<=pc2; state<=S_IN_GO; end
                end
                // ---- OUTB @rd,rbs (0x3E) : MAME Z3E_dddd_ssss. dst(NIB2)=port addr reg,
                // src(NIB3)=value byte reg. ----
                else if (din[15:8]==8'h3E) begin
                    if (!fcw[14]) begin trap_vec<=VEC_TRAP; pc<=pc2; state<=S_TRAP_PC; end
                    else begin dst<=din[7:4]; src<=din[3:0]; pc<=pc2; state<=S_OUTB_GO; end
                end
                // ---- OUT @rd,rs (0x3F) : MAME Z3F_dddd_ssss. dst(NIB2)=port addr reg,
                // src(NIB3)=value word reg. ----
                else if (din[15:8]==8'h3F) begin
                    if (!fcw[14]) begin trap_vec<=VEC_TRAP; pc<=pc2; state<=S_TRAP_PC; end
                    else begin dst<=din[7:4]; src<=din[3:0]; pc<=pc2; state<=S_OUT_GO; end
                end
                // ==== BATCH 15: size=2 members of the same bucket (one operand word to
                // discard) -- routed through the shared S_SWALLOW1. UNLIKE the size=1 bucket
                // above, these are genuinely SPARSE (multiple distinct sub-ops packed into
                // one top byte, each pinned to specific NIB2/NIB3 values by its own table
                // line) -- guards below reproduce each family's exact true valid set (NOT a
                // blanket top-byte match, which would over-accept -- caught by the audit's
                // "MAME-invalid words our core ACCEPTS" going nonzero on the first pass):
                //  0xB8 (TRIB/TRIRB/TRDB/TRDRB + IR/DR variants): NIB2(din[7:4]) nonzero,
                //   NIB3 EVEN (din[0]==0, 8 sub-ops: 0,2,4,6,8,A,C,E).
                //  0xBA/0xBB (CPSD/CPSDR/CPSI/CPSIR/LDD/LDDR/LDI/LDIR block move/compare):
                //   NIB2 nonzero, NIB3 in {0,1,2,4,6,8,9,A,C,E} (10 sub-ops; 3,5,7,B,D,F are
                //   genuinely absent from the table, not merely a stride artifact). ====
                // ==== BATCH 19: 0x3A/0x3B real port I/O -- SIN/SOUT/SINB/SOUTB (single,
                // NIB3=0100-0111) and INIB/SINIB/OUTIB/SOUTIB/INDB/SINDB/OUTDB/SOUTDB +
                // word siblings (self-repeating block, NIB3=0000-0011/1000-1011).
                // CHECK_PRIVILEGED_INSTR gated (traps to VEC_TRAP unless fcw[14]/F_S_N).
                // 0x3A=byte,0x3B=word share every state via `io_wide`. ====
                // ---- block, increment group (NIB3=0000-0011): src=word1 NIB2 (nonzero,
                // the register whose value doesn't get bumped by THIS field -- see
                // io_sub-keyed direction logic in S_IOB_WR). pc_orig latched for repeat. ----
                else if ((din[15:8]==8'h3A || din[15:8]==8'h3B) && din[3:0]<=4'h3) begin
                    if (!fcw[14]) begin trap_vec<=VEC_TRAP; pc<=pc2; state<=S_TRAP_PC; end
                    else begin
                        src<=din[7:4]; io_sub<=din[3:0]; io_wide<=(din[15:8]==8'h3B);
                        pc_orig<=pc; pc<=pc2; state<=S_IOB_FETCH2;
                    end
                end
                // ---- block, decrement group (NIB3=1000-1011) ----
                else if ((din[15:8]==8'h3A || din[15:8]==8'h3B) &&
                         din[3:0]>=4'h8 && din[3:0]<=4'hB) begin
                    if (!fcw[14]) begin trap_vec<=VEC_TRAP; pc<=pc2; state<=S_TRAP_PC; end
                    else begin
                        src<=din[7:4]; io_sub<=din[3:0]; io_wide<=(din[15:8]==8'h3B);
                        pc_orig<=pc; pc<=pc2; state<=S_IOB_FETCH2;
                    end
                end
                // ---- single I/O, IN direction (NIB3=0100/0101): INB/SINB rbd,imm16 /
                // IN/SIN rd,imm16. dst=word1 NIB2. ----
                else if ((din[15:8]==8'h3A || din[15:8]==8'h3B) &&
                         (din[3:0]==4'h4 || din[3:0]==4'h5)) begin
                    if (!fcw[14]) begin trap_vec<=VEC_TRAP; pc<=pc2; state<=S_TRAP_PC; end
                    else begin
                        dst<=din[7:4]; io_wide<=(din[15:8]==8'h3B); io_dir<=1'b0;
                        pc<=pc2; state<=S_IOS_FETCH;
                    end
                end
                // ---- single I/O, OUT direction (NIB3=0110/0111): OUTB/SOUTB imm16,rbs /
                // OUT/SOUT imm16,rs. src=word1 NIB2. ----
                else if ((din[15:8]==8'h3A || din[15:8]==8'h3B) &&
                         (din[3:0]==4'h6 || din[3:0]==4'h7)) begin
                    if (!fcw[14]) begin trap_vec<=VEC_TRAP; pc<=pc2; state<=S_TRAP_PC; end
                    else begin
                        src<=din[7:4]; io_wide<=(din[15:8]==8'h3B); io_dir<=1'b1;
                        pc<=pc2; state<=S_IOS_FETCH;
                    end
                end
                else if (din[15:8]==8'hB8 && din[7:4]!=4'h0 && din[0]==1'b0) begin
                    pc<=pc2; state<=S_SWALLOW1;
                end
                else if ((din[15:8]==8'hBA || din[15:8]==8'hBB) && din[7:4]!=4'h0 &&
                         din[3:0]!=4'h3 && din[3:0]!=4'h5 && din[3:0]!=4'h7 &&
                         din[3:0]!=4'hB && din[3:0]!=4'hD && din[3:0]!=4'hF) begin
                    pc<=pc2; state<=S_SWALLOW1;
                end
                // ---- DI/EI i2 (0x7C00-0x7C07): NIB2=0, bit2 0=DI/1=EI, imm2=din[1:0] ----
                // MAME: di fcw&=(imm2<<11)|0xe7ff ; ei fcw|=(~imm2<<11)&0x1800
                // i.e. per interrupt bit: imm2 bit=1 -> leave alone, bit=0 -> act (set/clear)
                else if (din[15:8]==8'h7C && din[7:3]==5'h00) begin
                    pc<=pc2; retire<=1'b1;
                    if (din[2]) begin // EI
                        if (~din[0]) fcw[11]<=1'b1;   // NVIE
                        if (~din[1]) fcw[12]<=1'b1;   // VIE
                    end else begin   // DI
                        if (~din[0]) fcw[11]<=1'b0;
                        if (~din[1]) fcw[12]<=1'b0;
                    end
                end
                // ---- LDCTL rd,ctrl (0x7D_0ccc, NIB3 bit3=0): read ctrl reg -> Rd ----
                //   ctrl codes (Z8002 non-seg): 2=FCW 3=REFRESH 5=PSAPOFF 7=NSPOFF.
                else if (din[15:8]==8'h7D && din[3]==1'b0) begin
                    pc<=pc2; retire<=1'b1;
                    case (din[2:0])
                        3'd2: begin rwb0_we=1'b1; rwb0_idx=din[7:4]; rwb0_val=fcw;  end // FCW
                        3'd5: begin rwb0_we=1'b1; rwb0_idx=din[7:4]; rwb0_val=psap; end // PSAPOFF
                        // 3=REFRESH: DRAM-refresh counter - no DRAM in this FPGA/BRAM system,
                        // so there is nothing to read back; return 0. 7=NSPOFF / 4,6=seg
                        // (Z8001-only): no effect in a non-segmented single hardware-SP model.
                        // Explicit documented default (NOT a silent drop) - the only reachable
                        // real use is the boot-time WRITE below (pp_sub @0x0012 ldctl refresh).
                        default: begin rwb0_we=1'b1; rwb0_idx=din[7:4]; rwb0_val=16'h0000; end
                    endcase
                end
                // ---- LDCTL ctrl,rs (0x7D_1ccc, NIB3 bit3=1): write Rs -> ctrl reg ----
                else if (din[15:8]==8'h7D && din[3]==1'b1) begin
                    pc<=pc2; retire<=1'b1;
                    case (din[2:0])
                        3'd2: fcw <=R[din[7:4]];   // FCW (plain overwrite; no NSP swap - S_N never toggles in polepos)
                        3'd5: psap<=R[din[7:4]];   // PSAPOFF
                        // 3=REFRESH (pp_sub boot @0x0012 writes this): intentional no-op -
                        // no DRAM refresh timer exists in this system. 7=NSPOFF / 4,6=seg:
                        // no effect (non-segmented, single hardware SP). Documented, accepted,
                        // NOT silently swallowed - a real reachable write that correctly does nothing.
                        default: ;
                    endcase
                end
                // ==== BATCH 1: stack + control flow ====================================
                // ---- CALL @Rd indirect (0x1F, NIB2=dst!=0,NIB3=0) : MAME Z1F_ddN0_0000 ----
                // push PC (=pc2, already the post-fetch return addr), jump to R[dst]. No flags.
                else if (din[15:8]==8'h1F && din[7:4]!=4'h0 && din[3:0]==4'h0) begin
                    ea<=R[din[7:4]]; pc<=pc2; state<=S_CALL_PUSH;
                end
                // ---- CALL addr direct (0x5F00 exact) : MAME Z5F_0000_0000_addr ----
                // fetch target word, then push PC(=old_pc+4)/jump. No flags.
                else if (din==16'h5F00) begin
                    pc<=pc2; state<=S_CALL_FETCH;
                end
                // ==== BATCH 11: CALL addr(rd) indexed (0x5F10-0x5FF0, NIB2=dst!=0) : MAME
                // Z5F_ddN0_0000_addr. NIB3 is a FIXED "0000" field here (unlike the 0x51/53/
                // 55/57 families where the low nibble is a genuine free index-register
                // operand) -- z8000tbl.hxx's single table line `{0x5f10,0x5ff0,16,...}`
                // confirms NIB3=0 always (BUG FOUND AND FIXED here: an earlier version of
                // this arm omitted the din[3:0]==0 guard and over-accepted 225 words with
                // NIB3!=0 as legal CALL encodings -- caught by the audit's "MAME-invalid
                // words our core ACCEPTS" check going nonzero). Indexed sibling of the
                // direct form above, joins the EXISTING S_CALL_PUSH tail unchanged. ====
                else if (din[15:8]==8'h5F && din[7:4]!=4'h0 && din[3:0]==4'h0) begin
                    idxr<=din[7:4]; pc<=pc2; state<=S_CALLX_FETCH;
                end
                // ==== BATCH 12: 0x30-0x37 PC-relative(dsp16)/indexed(idx16) family. See the
                // localparam block's header comment for the overall shape; each pair below
                // is direct(NIB2=0,PC-relative dsp16) / indexed(NIB2=idx-reg!=0, reuses an
                // EXISTING X_FETCH state verbatim). ====
                // ---- Z30: LDB rbd,dsp16 / rbd,rs(idx16) -- byte load, dst=NIB3 always ----
                else if (din[15:8]==8'h30 && din[7:4]==4'h0) begin
                    dst<=din[3:0]; pc<=pc2; state<=S_Z30_FETCH;
                end
                else if (din[15:8]==8'h30 && din[7:4]!=4'h0) begin
                    dst<=din[3:0]; idxr<=din[7:4]; pc<=pc2; state<=S_LDBDAX_FETCH;
                end
                // ---- Z31: LDR rd,dsp16 / LD rd,rs(idx16) -- word load, dst=NIB3 always ----
                else if (din[15:8]==8'h31 && din[7:4]==4'h0) begin
                    dst<=din[3:0]; daop<=DA_LDR; pc<=pc2; state<=S_Z31_FETCH;
                end
                else if (din[15:8]==8'h31 && din[7:4]!=4'h0) begin
                    dst<=din[3:0]; daop<=DA_LDR; idxr<=din[7:4]; pc<=pc2; state<=S_LDAX_FETCH;
                end
                else if (din[15:8]==8'h32 && din[7:4]==4'h0) begin
                    src<=din[3:0]; pc<=pc2; state<=S_Z32_FETCH;
                end
                else if (din[15:8]==8'h32 && din[7:4]!=4'h0) begin
                    src<=din[3:0]; idxr<=din[7:4]; pc<=pc2; state<=S_LDBSTAX_FETCH;
                end
                else if (din[15:8]==8'h33 && din[7:4]==4'h0) begin
                    src<=din[3:0]; daop<=DA_STR; pc<=pc2; state<=S_Z33_FETCH;
                end
                else if (din[15:8]==8'h33 && din[7:4]!=4'h0) begin
                    src<=din[3:0]; daop<=DA_STR; idxr<=din[7:4]; pc<=pc2; state<=S_LDSAX_FETCH;
                end
                // ---- Z34: LDAR prd,dsp16 / LDA prd,rs(idx16) -- register-ONLY address
                // load, no memory operand read at all; dst=NIB3 always. Indexed reuses
                // S_LDA76_FETCH/GO verbatim -- its `operand + (lda76_has_src?R[src]:0)`
                // formula IS R[src]+idx16 (addition commutes; MAME's own RDBX_*/add_to_
                // addr_reg helpers add register+fetched-word in either order, see report). ----
                else if (din[15:8]==8'h34 && din[7:4]==4'h0) begin
                    dst<=din[3:0]; pc<=pc2; state<=S_Z34_FETCH;
                end
                else if (din[15:8]==8'h34 && din[7:4]!=4'h0) begin
                    dst<=din[3:0]; src<=din[7:4]; lda76_has_src<=1'b1; pc<=pc2; state<=S_LDA76_FETCH;
                end
                // ---- Z35: LDRL rrd,dsp16 / LDL rrd,rs(idx16) -- long load, dst=NIB3 always.
                // Indexed reuses S_LDLAX_FETCH verbatim (already sets l32wb=0 internally). ----
                else if (din[15:8]==8'h35 && din[7:4]==4'h0) begin
                    dst<=din[3:0]; pc<=pc2; state<=S_Z35_FETCH;
                end
                else if (din[15:8]==8'h35 && din[7:4]!=4'h0) begin
                    dst<=din[3:0]; src<=din[7:4]; pc<=pc2; state<=S_LDLAX_FETCH;
                end
                // ---- Z37: LDRL dsp16,rrs / LDL rd(idx16),rrs -- long store, src(value
                // pair)=NIB3 always (unrestricted). Indexed reuses S_LDLSAX_FETCH verbatim
                // (already sets l32wb=0 internally). ----
                else if (din[15:8]==8'h37 && din[7:4]==4'h0) begin
                    src<=din[3:0]; pc<=pc2; state<=S_Z37_FETCH;
                end
                else if (din[15:8]==8'h37 && din[7:4]!=4'h0) begin
                    src<=din[3:0]; idxr<=din[7:4]; pc<=pc2; state<=S_LDLSAX_FETCH;
                end
                // ---- CALR dsp12 (0xD000-0xDFFF) : MAME ZD_dsp12 ----
                // target = pc2 - 2*sext12(din[11:0]). No flags.
                // MAME (z8000ops.hxx:6834) writes this piecewise:
                //   dsp12 = (dsp12 & 2048) ? 4096 - 2*(dsp12 & 2047) : -2*(dsp12 & 2047);
                //   set_pc(addr_add(m_pc, dsp12));
                // which is ALGEBRAICALLY IDENTICAL to the sext form used here -- checked at
                // the branch boundaries: d=0x001 -> pc-2 (both); d=0x800 -> pc+4096 (both);
                // d=0xFFF -> pc+2 (both). Note the default direction is BACKWARD (bit11 clear
                // => negative), which is why MAME's expression looks inverted. Don't "fix" it.
                else if (din[15:12]==4'hD) begin
                    ea<=pc2 - {{3{din[11]}}, din[11:0], 1'b0};
                    pc<=pc2; state<=S_CALL_PUSH;
                end
                // ---- RET cc (0x9E, NIB2=0) : MAME Z9E_0000_cccc ----
                // conditional pop-PC; if cc false, stack is UNTOUCHED (MAME only pops inside
                // the taken case) -- just retire in place. No flags.
                else if (din[15:8]==8'h9E && din[7:4]==4'h0) begin
                    if (cc_true(din[3:0],fcw[FC],fcw[FZ],fcw[FS],fcw[FV])) begin
                        state<=S_RET_POP;
                    end else begin
                        pc<=pc2; retire<=1'b1;
                    end
                end
                // ---- PUSH @Rd,Rs (0x93, NIB2=dst!=0) : MAME Z93_ddN0_ssss ----
                else if (din[15:8]==8'h93 && din[7:4]!=4'h0) begin
                    dst<=din[7:4]; operand<=R[din[3:0]]; pc<=pc2; state<=S_PUSH_W;
                end
                // ---- PUSH @Rd,#imm16 (0x0D, NIB2=dst!=0, NIB3=9) : MAME Z0D_ddN0_1001_imm16 ----
                else if (din[15:8]==8'h0D && din[7:4]!=4'h0 && din[3:0]==4'h9) begin
                    dst<=din[7:4]; pc<=pc2; state<=S_PUSHI_FETCH;
                end
                // ---- PUSH @Rd,addr direct (0x53, NIB2=dst!=0,NIB3=0) : MAME Z53_ddN0_0000_addr ----
                else if (din[15:8]==8'h53 && din[7:4]!=4'h0 && din[3:0]==4'h0) begin
                    dst<=din[7:4]; pc<=pc2; state<=S_PUSHA_FETCH;
                end
                // ==== BATCH 11: PUSH @Rd,addr(rs) indexed (0x53, NIB2=dst!=0,NIB3=src!=0) :
                // MAME Z53_ddN0_ssN0_addr. dst(NIB2)=PUSH pointer register; src(NIB3)=index
                // register. Joins the EXISTING S_PUSHA_RD->S_PUSH_W tail unchanged. ====
                else if (din[15:8]==8'h53 && din[7:4]!=4'h0 && din[3:0]!=4'h0) begin
                    dst<=din[7:4]; idxr<=din[3:0]; pc<=pc2; state<=S_PUSHAX_FETCH;
                end
                // ---- POP Rd,@Rs (0x97, NIB2=src!=0) : MAME Z97_ssN0_dddd ----
                else if (din[15:8]==8'h97 && din[7:4]!=4'h0) begin
                    src<=din[7:4]; dst<=din[3:0]; pc<=pc2; state<=S_POP_R;
                end
                // ---- POP addr,@Rs direct (0x57, NIB2=src!=0,NIB3=0) : MAME Z57_ssN0_0000_addr ----
                else if (din[15:8]==8'h57 && din[7:4]!=4'h0 && din[3:0]==4'h0) begin
                    src<=din[7:4]; pc<=pc2; state<=S_POPA_FETCH;
                end
                // ==== BATCH 11: POP addr(rd),@Rs indexed (0x57, NIB2=src!=0,NIB3=dst!=0) :
                // MAME Z57_ssN0_ddN0_addr. src(NIB2)=POP source pointer register (postincrement,
                // unchanged from the direct form); dst(NIB3)=index register added to the
                // fetched addr (MAME names it "dst" only because GET_DST's macro shape fits --
                // it's a plain index register here, no register write happens through it).
                // Joins the EXISTING S_POPA_POP->S_POPA_WR tail unchanged. ====
                else if (din[15:8]==8'h57 && din[7:4]!=4'h0 && din[3:0]!=4'h0) begin
                    src<=din[7:4]; idxr<=din[3:0]; pc<=pc2; state<=S_POPAX_FETCH;
                end
                // ---- PUSHL @Rd,RRs (0x91, NIB2=dst!=0) : MAME Z91_ddN0_ssss ----
                // dst=pointer reg (plain); src=value register PAIR select (bit0 truncated,
                // see file header). New pointer = R[dst]-4, precomputed into `ea`.
                else if (din[15:8]==8'h91 && din[7:4]!=4'h0) begin
                    dst<=din[7:4]; src<=din[3:0]; ea<=R[din[7:4]]-16'd4;
                    l32wb<=1'b1; pc<=pc2; state<=S_L32_WR_HI;
                end
                // ---- POPL RRd,@Rs (0x95, NIB2=src!=0) : MAME Z95_ssN0_dddd ----
                // src=pointer reg (plain); dst=dest register PAIR select (bit0 truncated).
                else if (din[15:8]==8'h95 && din[7:4]!=4'h0) begin
                    src<=din[7:4]; dst<=din[3:0]; ea<=R[din[7:4]];
                    l32wb<=1'b1; pc<=pc2; state<=S_L32_RD_HI;
                end
                // ==== BATCH 11: PUSHL @Rd,addr[,(rs)] (0x51, NIB2=dst!=0) : MAME
                // Z51_ddN0_0000_addr / Z51_ddN0_ssN0_addr. dst(NIB2)=PUSHL pointer register;
                // src(NIB3)=index register (0=none/plain addr, nonzero=addr(rs)). Reads a
                // fresh 32-bit value from the fetched address, THEN pushes it -- new
                // dedicated pump (S_PLDA_*), see its state-body comment for why S_L32_WR_*
                // can't be reused here. ====
                else if (din[15:8]==8'h51 && din[7:4]!=4'h0) begin
                    dst<=din[7:4]; pc<=pc2;
                    if (din[3:0]==4'h0) state<=S_PLDA_FETCH;
                    else begin idxr<=din[3:0]; state<=S_PLDA_FETCHX; end
                end
                // ==== BATCH 11: POPL addr[,(rd)],@Rs (0x55, NIB2=src!=0) : MAME
                // Z55_ssN0_0000_addr / Z55_ssN0_ddN0_addr. src(NIB2)=POPL source pointer
                // register (postincrement +4); dst(NIB3)=index register added to the fetched
                // addr (0=none/plain addr). New dedicated pump (S_POLDA_*). ====
                else if (din[15:8]==8'h55 && din[7:4]!=4'h0) begin
                    src<=din[7:4]; pc<=pc2;
                    if (din[3:0]==4'h0) state<=S_POLDA_FETCH;
                    else begin idxr<=din[3:0]; state<=S_POLDA_FETCHX; end
                end
                // ==== BATCH 11: SUBL rrd,addr[,(rs)] (0x52) : MAME Z52_0000_dddd_addr /
                // Z52_ssN0_dddd_addr. dst=NIB3 (dest reg pair, unrestricted); idxr=NIB2
                // (index register, nonzero when indexed). Shared 32-bit chain, dwop=0 routes
                // to the EXISTING S_LALU_GO (aluop=SUB already selects subtract there). ====
                else if (din[15:8]==8'h52) begin
                    dst<=din[3:0]; aluop<=SUB; dwop<=2'd0; pc<=pc2;
                    if (din[7:4]==4'h0) state<=S_DWL_FETCH;
                    else begin idxr<=din[7:4]; state<=S_DWL_FETCHX; end
                end
                // ==== BATCH 11: ADDL rrd,addr[,(rs)] (0x56) : MAME Z56_0000_dddd_addr /
                // Z56_ssN0_dddd_addr. Same shape as SUBL above, aluop=ADD. ====
                else if (din[15:8]==8'h56) begin
                    dst<=din[3:0]; aluop<=ADD; dwop<=2'd0; pc<=pc2;
                    if (din[7:4]==4'h0) state<=S_DWL_FETCH;
                    else begin idxr<=din[7:4]; state<=S_DWL_FETCHX; end
                end
                // ==== BATCH 11: MULTL rqd,addr[,(rs)] (0x58) : MAME Z58_0000_dddd_addr /
                // Z58_ssN0_dddd_addr. dwop=1 routes to the EXISTING S_MULTL_GO. ====
                else if (din[15:8]==8'h58) begin
                    dst<=din[3:0]; dwop<=2'd1; pc<=pc2;
                    if (din[7:4]==4'h0) state<=S_DWL_FETCH;
                    else begin idxr<=din[7:4]; state<=S_DWL_FETCHX; end
                end
                // ==== BATCH 11: DIVL rqd,addr[,(rs)] (0x5A) : MAME Z5A_0000_dddd_addr /
                // Z5A_ssN0_dddd_addr. dwop=2 routes to the EXISTING S_DIVL_GO. ====
                else if (din[15:8]==8'h5A) begin
                    dst<=din[3:0]; dwop<=2'd2; pc<=pc2;
                    if (din[7:4]==4'h0) state<=S_DWL_FETCH;
                    else begin idxr<=din[7:4]; state<=S_DWL_FETCHX; end
                end
                // ==== BATCH 11: MULT rrd,addr[,(rs)] (0x59) : MAME Z59_0000_dddd_addr /
                // Z59_ssN0_dddd_addr. Shared 16-bit chain, dwop=0 routes to S_MULT_GO. ====
                else if (din[15:8]==8'h59) begin
                    dst<=din[3:0]; dwop<=2'd0; pc<=pc2;
                    if (din[7:4]==4'h0) state<=S_DWS_FETCH;
                    else begin idxr<=din[7:4]; state<=S_DWS_FETCHX; end
                end
                // ==== BATCH 11: DIV rrd,addr[,(rs)] (0x5B) : MAME Z5B_0000_dddd_addr /
                // Z5B_ssN0_dddd_addr. dwop=1 routes to S_DIV_GO. ====
                else if (din[15:8]==8'h5B) begin
                    dst<=din[3:0]; dwop<=2'd1; pc<=pc2;
                    if (din[7:4]==4'h0) state<=S_DWS_FETCH;
                    else begin idxr<=din[7:4]; state<=S_DWS_FETCHX; end
                end
                // ---- LDL RRd,RRs (0x94, full range) : MAME Z94_ssss_dddd ----
                // single-cycle reg-pair move, no memory access. No flags.
                // LDL-SRC-PAIR-FIX-2026-08-10 --------------------------------------
                // The SOURCE register field is nibble din[7:4]. Forcing it to an even
                // pair base is {din[7:5],1'b0} -- the derivation used everywhere else
                // in this file, and used correctly for the DESTINATION ({din[3:1],1'b0})
                // on the very next line. This read {din[6:4],1'b0}: one bit too low.
                //   ldl rr0,rr2 (0x9420): src should be {001,0}=RR2, got {010,0}=RR4
                //   ldl rr2,rr8 (0x9482): src should be {100,0}=RR8, got {000,0}=RR0
                // Silent-wrong, never hangs -- same class as the 4D01 and indexed-JP
                // gaps. Found via pp_sub1.asm 0x0034 `ldl rr0,rr2` leaving rr0 at zero,
                // which zeroed the road-curve step (rr2 stuck at 4*orig instead of
                // 5*orig, rr0 at 0x0080 instead of 20*orig) and made every per-scanline
                // road xoffs garbage. MAME Z94_ssss_dddd: RL(dst) = RL(src).
                // Original: rwb0_val=R[{din[6:4],1'b0}]; rwb1_val=R[{din[6:4],1'b0}+4'd1];
                else if (din[15:8]==8'h94) begin
                    rwb0_we=1'b1; rwb0_idx={din[3:1],1'b0};      rwb0_val=R[{din[7:5],1'b0}];
                    rwb1_we=1'b1; rwb1_idx={din[3:1],1'b0}+4'd1; rwb1_val=R[{din[7:5],1'b0}+4'd1];
                    pc<=pc2; retire<=1'b1;
                end
                // ---- LDL RRd,#imm32 (0x14, NIB2=0) : MAME Z14_0000_dddd_imm32 ----
                // imm32 = {word1(hi),word2(lo)} (verified via GET_IMM32 macro). No flags.
                else if (din[15:8]==8'h14 && din[7:4]==4'h0) begin
                    dst<=din[3:0]; pc<=pc2; state<=S_LDL_IMM_HI;
                end
                // ---- LDL RRd,@Rs (0x14, NIB2=src!=0) : MAME Z14_ssN0_dddd ----
                else if (din[15:8]==8'h14 && din[7:4]!=4'h0) begin
                    dst<=din[3:0]; ea<=R[din[7:4]]; l32wb<=1'b0; pc<=pc2; state<=S_L32_RD_HI;
                end
                // ---- LDL @Rd,RRs (0x1D, NIB2=dst!=0) : MAME Z1D_ddN0_ssss ----
                else if (din[15:8]==8'h1D && din[7:4]!=4'h0) begin
                    src<=din[3:0]; ea<=R[din[7:4]]; l32wb<=1'b0; pc<=pc2; state<=S_L32_WR_HI;
                end
                // ---- LDL RRd,addr direct (0x54, NIB2=0) : MAME Z54_0000_dddd_addr ----
                else if (din[15:8]==8'h54 && din[7:4]==4'h0) begin
                    dst<=din[3:0]; pc<=pc2; state<=S_LDLA_FETCH;
                end
                // ==== BATCH 7 (post-verify): LDL RRd,addr(rs) indexed (0x54, NIB2!=0) :
                //      MAME Z54_ssN0_dddd_addr. Same S_L32_RD_HI/LO read tail as the direct
                //      form above, just ea=addr+R[src] instead of ea=addr. ====
                else if (din[15:8]==8'h54 && din[7:4]!=4'h0) begin
                    dst<=din[3:0]; src<=din[7:4]; pc<=pc2; state<=S_LDLAX_FETCH;
                end
                // ---- LDL addr,RRs direct (0x5D, NIB2=0) : MAME Z5D_0000_ssss_addr ----
                else if (din[15:8]==8'h5D && din[7:4]==4'h0) begin
                    src<=din[3:0]; pc<=pc2; state<=S_LDLSA_FETCH;
                end
                // ==== BATCH 8: LDL addr(rx),RRs indexed (0x5D, NIB2!=0) : MAME
                // Z5D_ddN0_ssss_addr (dst here is the INDEX reg per z8000ops.hxx GET_DST,
                // src is the reg-pair stored). Same S_L32_WR_HI/LO store tail as the direct
                // form above, just ea=addr+R[idx] instead of ea=addr -- mirrors the 0x54
                // indexed-load sibling (S_LDLAX_FETCH) added in Batch 7. ====
                else if (din[15:8]==8'h5D && din[7:4]!=4'h0) begin
                    src<=din[3:0]; idxr<=din[7:4]; pc<=pc2; state<=S_LDLSAX_FETCH;
                end
                // ---- LDM rd,@rs,n (0x1C, NIB2=src!=0,NIB3=1) : MAME Z1C_ssN0_0001_0000_dddd_0000_nmin1 ----
                // word2 = {4'b0,dst[11:8],4'b0,cnt[3:0]}; transfers cnt+1 words mem->regs,
                // dst wraps mod 16 each step (natural 4-bit reg wrap == MAME's (dst+1)&15).
                else if (din[15:8]==8'h1C && din[7:4]!=4'h0 && din[3:0]==4'h1) begin
                    src<=din[7:4]; pc<=pc2; state<=S_LDM_L_FETCH2;
                end
                // ---- LDM @rd,rs,n (0x1C, NIB2=dst!=0,NIB3=9) : MAME Z1C_ddN0_1001_0000_ssss_0000_nmin1 ----
                else if (din[15:8]==8'h1C && din[7:4]!=4'h0 && din[3:0]==4'h9) begin
                    dst<=din[7:4]; pc<=pc2; state<=S_LDM_S_FETCH2;
                end
                // ==== BATCH 15: TESTL @rd (0x1C, NIB2=dst!=0,NIB3=8) : MAME Z1C_ddN0_1000
                // "testl @rd", flags -ZS---. Register-indirect sibling of the already-
                // implemented TESTL addr[,(rd)] (Batch 11, S_TL_FETCH/RD_HI/RD_LO) -- EA=
                // R[dst] is already known, so this bypasses S_TL_FETCH entirely and jumps
                // straight to S_TL_RD_HI (same "point ea at R[dst], skip the FETCH" trick
                // used for COMB/NEGB/CPB/LDB above). ====
                else if (din[15:8]==8'h1C && din[7:4]!=4'h0 && din[3:0]==4'h8) begin
                    ea<=R[din[7:4]]; pc<=pc2; state<=S_TL_RD_HI;
                end
                // ==== BATCH 7 (post-verify): LDM addr,rs,n (0x5C09) direct-address STORE :
                //      MAME Z5C_0000_1001_0000_ssss_0000_nmin1_addr.
                //      Reuses S_LDM_S_WR's loop tail UNCHANGED -- only ea's source differs
                //      (a fetched addr word here vs R[dst] for the @rd form above). ====
                else if (din==16'h5C09) begin
                    ldmx<=1'b0; pc<=pc2; state<=S_LDM_DA_FETCH2;
                end
                // ==== BATCH 11: LDM addr(rd),rs,n (0x5CN9, NIB2=idx!=0) indexed sibling of
                // 0x5C09 above : MAME Z5C_ddN0_1001_0000_ssN0_0000_nmin1_addr. Reuses the
                // SAME S_LDM_DA_FETCH2 word2-fetch (dst/cnt fields are in word2, unaffected
                // by indexing) -- `ldmx` tells it to route to the new indexed word3-fetch. ====
                else if (din[15:8]==8'h5C && din[3:0]==4'h9 && din[7:4]!=4'h0) begin
                    idxr<=din[7:4]; ldmx<=1'b1; pc<=pc2; state<=S_LDM_DA_FETCH2;
                end
                // ==== BATCH 8: LDM rd,addr,n (0x5C01) direct-address LOAD, the load-direction
                // sibling of 0x5C09 above : MAME Z5C_0000_0001_0000_dddd_0000_nmin1_addr.
                // Reuses S_LDM_L_RD's loop tail UNCHANGED (same register-fill loop the @rs
                // register-indirect LOAD form already uses). ====
                else if (din==16'h5C01) begin
                    ldmx<=1'b0; pc<=pc2; state<=S_LDM_DA_LFETCH2;
                end
                // ==== BATCH 11: LDM rd,addr(rs),n (0x5CN1, NIB2=idx!=0) indexed sibling of
                // 0x5C01 above : MAME Z5C_ssN0_0001_0000_dddd_0000_nmin1_addr. Same `ldmx`
                // routing trick as the STORE indexed arm above. ====
                else if (din[15:8]==8'h5C && din[3:0]==4'h1 && din[7:4]!=4'h0) begin
                    idxr<=din[7:4]; ldmx<=1'b1; pc<=pc2; state<=S_LDM_DA_LFETCH2;
                end
                // ==== BATCH 11: TESTL addr (0x5C08 exact) : MAME Z5C_0000_1000_addr. New
                // 32-bit read-only compare-to-zero, flags -ZS--- (matches the already-
                // implemented register-direct TESTL rrd, 0x9C, one level indirected). ====
                else if (din==16'h5C08) begin
                    pc<=pc2; state<=S_TL_FETCH;
                end
                // ==== BATCH 11: TESTL addr(rd) indexed (0x5CN8, NIB2=idx!=0) : MAME
                // Z5C_ddN0_1000_addr. ====
                else if (din[15:8]==8'h5C && din[3:0]==4'h8 && din[7:4]!=4'h0) begin
                    idxr<=din[7:4]; pc<=pc2; state<=S_TL_FETCHX;
                end
                // ==== BATCH 2 PART A: indirect-indirect PUSHL/PUSH/POPL/POP ================
                // ---- PUSHL @Rd,@Rs (0x11) : MAME Z11_ddN0_ssN0 "pushl @rd,@rs" ----
                // value = long read INDIRECTLY at R[src] (src ptr unmodified); pushed
                // (pre-decrement by 4) to R[dst]-4.
                // the earlier guard here (`din[3:0]!=0` too, "both
                // nibbles nonzero") was a DELIBERATE prior-session narrowing to the "real
                // ROM code never emits that edge" cases (the old "close reachable gaps
                // only" policy), explicitly flagged as such in this comment before -- but
                // z8000tbl.hxx's actual entry is `{0x1111,0x11ff,1,...}` (DENSE, step=1),
                // which permits src(NIB3)=0 for every dst(NIB2)>=2; only the single corner
                // word 0x1110 (NIB2=1,NIB3=0) sits below `beg` and is genuinely excluded.
                // Confirmed the state machinery has zero special-casing hazard for src=0
                // (R0 is a perfectly ordinary 16-bit pointer value here, same as any other
                // register -- z8000ops.hxx's RDIR_L/addr_from_reg never special-case reg 0
                // in this indirect-pointer role, unlike the "N0" DESTINATION-pointer
                // convention used elsewhere in this ISA). Relaxed to match the true table;
                // this task's "close the whole decode" mandate supersedes the old
                // narrower-scope call, not a re-litigation of it. ----
                else if (din[15:8]==8'h11 && din[7:4]!=4'h0 && !(din[7:4]==4'h1 && din[3:0]==4'h0)) begin
                    dst<=din[7:4]; src<=din[3:0]; ea<=R[din[7:4]]-16'd4; pc<=pc2; state<=S_PLII_RD_HI;
                end
                // ---- PUSH @Rd,@Rs (0x13) : MAME Z13_ddN0_ssN0 "push @rd,@rs" ----
                // value = word read INDIRECTLY at R[src] (unmodified); hands off to the
                // existing S_PUSH_W commit (addr=R[dst]-2,dout=operand,we=1) unchanged.
                // dst==src (e.g. "push @r15,@r15") correctly stack-dups: read completes
                // before R[dst] is ever touched. BATCH 14: same table-shape relaxation as
                // 0x11 above (`{0x1311,0x13ff,1,...}`, only 0x1310 excluded). ----
                else if (din[15:8]==8'h13 && din[7:4]!=4'h0 && !(din[7:4]==4'h1 && din[3:0]==4'h0)) begin
                    dst<=din[7:4]; src<=din[3:0]; pc<=pc2; state<=S_PUSHII_RD;
                end
                // ---- POPL RRd,@Rs (0x15) : MAME Z15_ssN0_ddN0 "popl rd,@rs" ----
                // Body is BYTE-IDENTICAL to the already-implemented 0x95 (POPL RRd,@Rs): dst
                // is a DIRECT register-pair write (RL(dst)=POPL(src)), never indirect --
                // despite MAME's disassembler (8000dasm.cpp) printing "popl @%rw3,@%rw2" with
                // an "@" on the dest, which contradicts z8000ops.hxx's own RL(dst)= (no
                // WRIR_L call at all). Treated as a disassembler-string copy/paste artifact
                // off the pushl/push template lines above it (see report); z8000ops.hxx
                // trusted per the authoritative-reference rule. 0x15 is functionally an
                // alias of 0x95. BATCH 14: same table-shape relaxation (`{0x1511,0x15ff,1,
                // ...}`, only 0x1510 excluded) -- dst(NIB3)=0 (RL(0)=R0:R1) is an entirely
                // ordinary register-pair write, no hazard. ----
                else if (din[15:8]==8'h15 && din[7:4]!=4'h0 && !(din[7:4]==4'h1 && din[3:0]==4'h0)) begin
                    src<=din[7:4]; dst<=din[3:0]; ea<=R[din[7:4]];
                    l32wb<=1'b1; pc<=pc2; state<=S_L32_RD_HI;
                end
                // ---- POP @Rd,@Rs (0x17) : MAME Z17_ssN0_ddN0 "pop @rd,@rs" ----
                // dst(NIB3)=target pointer (WRITTEN indirectly, itself never modified);
                // src(NIB2)=source pointer (POPPED: read then +2). Real eval order matters
                // when dst==src: WRIR_W(dst,POPW(src)) evaluates POPW(src) FIRST (including
                // its R[src]+=2 side effect) and only THEN resolves addr_from_reg(dst) --
                // so no `ea` precompute here; S_POPII_WR reads R[dst] LIVE off the register
                // file (post-increment already applied if dst==src), matching that order.
                // BATCH 14: same table-shape relaxation (`{0x1711,0x17ff,1,...}`, only
                // 0x1710 excluded). ----
                else if (din[15:8]==8'h17 && din[7:4]!=4'h0 && !(din[7:4]==4'h1 && din[3:0]==4'h0)) begin
                    dst<=din[3:0]; src<=din[7:4]; pc<=pc2; state<=S_POPII_RD;
                end
                // ==== BATCH 2 PART B: byte ALU/LDB, LDB store, CPL, JP/EX, BIT/RES/SET =====
                // Shared byte pipeline (S_IMMB/S_MEMRDB/S_ALUB) mirrors the existing word ALU
                // pipeline (S_IMM/S_MEMRD/S_ALU) exactly, but for the byte register file
                // (RB(n): dst[3]?LOW:HIGH of R[dst[2:0]], matching ADDB/DECB/INCB's already-
                // established convention) and MAME's byte flag formulas -- ORB/ANDB/XORB set
                // P/V as PARITY (z8000ops.hxx CHK_XXXB_ZSP / z8000_zsp[] table), NOT overflow,
                // unlike the word forms which never touch P/V at all. `aluop`/`dst`/`src` are
                // reused from the word pipeline (word/byte never run concurrently).
                // ---- ADDB rd,#imm8 (0x00, NIB2=0) : MAME Z00_0000_dddd_imm8 ----
                else if (din[15:8]==8'h00 && din[7:4]==4'h0) begin
                    dst<=din[3:0]; aluop<=ADD; pc<=pc2; state<=S_IMMB;
                end
                // ---- SUBB rd,#imm8/@rs (0x02) : MAME Z02_0000_dddd_imm8 / Z02_ssN0_dddd ----
                else if (din[15:8]==8'h02) begin
                    dst<=din[3:0]; aluop<=SUB; pc<=pc2;
                    if (din[7:4]==4'h0) state<=S_IMMB; else begin src<=din[7:4]; state<=S_MEMRDB; end
                end
                // ---- ORB rd,#imm8/@rs (0x04) : MAME Z04_0000_dddd_imm8 / Z04_ssN0_dddd ----
                else if (din[15:8]==8'h04) begin
                    dst<=din[3:0]; aluop<=OR; pc<=pc2;
                    if (din[7:4]==4'h0) state<=S_IMMB; else begin src<=din[7:4]; state<=S_MEMRDB; end
                end
                // ---- ANDB rd,#imm8/@rs (0x06) : MAME Z06_0000_dddd_imm8 / Z06_ssN0_dddd ----
                else if (din[15:8]==8'h06) begin
                    dst<=din[3:0]; aluop<=AND; pc<=pc2;
                    if (din[7:4]==4'h0) state<=S_IMMB; else begin src<=din[7:4]; state<=S_MEMRDB; end
                end
                // ---- XORB rd,#imm8/@rs (0x08) : MAME Z08_0000_dddd_imm8 / Z08_ssN0_dddd ----
                else if (din[15:8]==8'h08) begin
                    dst<=din[3:0]; aluop<=XOR; pc<=pc2;
                    if (din[7:4]==4'h0) state<=S_IMMB; else begin src<=din[7:4]; state<=S_MEMRDB; end
                end
                // ---- CPB rd,#imm8/@rs (0x0A) : MAME Z0A_0000_dddd_imm8 / Z0A_ssN0_dddd ----
                else if (din[15:8]==8'h0A) begin
                    dst<=din[3:0]; aluop<=CP; pc<=pc2;
                    if (din[7:4]==4'h0) state<=S_IMMB; else begin src<=din[7:4]; state<=S_MEMRDB; end
                end
                // ---- LDB rd,#imm8/@rs (0x20) : MAME Z20_0000_dddd_imm8 / Z20_ssN0_dddd ----
                else if (din[15:8]==8'h20) begin
                    dst<=din[3:0]; aluop<=LD; pc<=pc2;
                    if (din[7:4]==4'h0) state<=S_IMMB; else begin src<=din[7:4]; state<=S_MEMRDB; end
                end
                // ---- byte reg-reg ALU: 80=ADDB 82=SUBB 84=ORB 86=ANDB 88=XORB 8A=CPB A0=LDB ----
                else if (din[15:8]==8'h80 || din[15:8]==8'h82 || din[15:8]==8'h84 ||
                         din[15:8]==8'h86 || din[15:8]==8'h88 || din[15:8]==8'h8A ||
                         din[15:8]==8'hA0) begin
                    dst<=din[3:0]; operand[7:0]<= din[7] ? R[din[6:4]][7:0] : R[din[6:4]][15:8];
                    pc<=pc2; state<=S_ALUB;
                    case (din[15:8])
                        8'h80: aluop<=ADD; 8'h82: aluop<=SUB; 8'h84: aluop<=OR;
                        8'h86: aluop<=AND; 8'h88: aluop<=XOR; 8'h8A: aluop<=CP;
                        default: aluop<=LD; // 0xA0
                    endcase
                end
                // ---- LDB @Rd,rbs store (0x2E, NIB2=dst!=0) : MAME Z2E_ddN0_ssss "ldb @rd,rbs" ----
                // RMW-safe byte store, see S_LDBST_RD/WR header comment (wordacc unconnected).
                else if (din[15:8]==8'h2E && din[7:4]!=4'h0) begin
                    dst<=din[7:4]; src<=din[3:0]; pc<=pc2; state<=S_LDBST_RD;
                end
                // ---- JP cc,@Rd (0x1E, NIB2=dst!=0) : MAME Z1E_ddN0_cccc "jp cc,@rd" ----
                // addr_from_reg(dst) reduces to plain RW(dst) in non-segmented (Z8002) mode --
                // despite the MAME disassembler cosmetically showing "@rr1" (a segmented-mode
                // register-pair convention it always uses for this mnemonic); z8000cpu.h's
                // addr_from_reg() returns RW(regno) here, a single plain register, confirmed
                // against pp_sub*.asm "jp @rr1" instances (target is R[dst], not RRd).
                else if (din[15:8]==8'h1E && din[7:4]!=4'h0) begin
                    pc <= cc_true(din[3:0],fcw[FC],fcw[FZ],fcw[FS],fcw[FV]) ? R[din[7:4]] : pc2;
                    retire<=1'b1;
                end
                // ---- CPL rrd,@rs (0x10, NIB2=src!=0) : MAME Z10_ssN0_dddd "cpl rrd,@rs" ----
                // compare-only long, no writeback. imm32 form (0x1000-0x100F) not implemented
                // (rare/unused compare-against-32-bit-constant addressing; see report).
                else if (din[15:8]==8'h10 && din[7:4]!=4'h0) begin
                    dst<=din[3:0]; src<=din[7:4]; pc<=pc2; state<=S_CPL_RD_HI;
                end
                // ---- CPL rrd,rrs (0x90, full range) : MAME Z90_ssss_dddd "cpl rrd,rrs" ----
                // compare-only, no writeback, no memory access -- routed through S_CPL_RR
                // (shares the same flag-compute code shape as the indirect form above).
                else if (din[15:8]==8'h90) begin
                    dst<=din[3:0]; src<=din[7:4]; pc<=pc2; state<=S_CPL_RR;
                end
                // ---- BITB @Rd,#imm4 (0x26, NIB2=dst!=0) : MAME Z26_ddN0_imm4, flags -Z---- ----
                // read-only (no RMW hazard). bit = 1<<NIB3 (NIB3 8-15 => bmask[7:0]==0, byte
                // test naturally always-false, matching MAME's own uint8_t&uint16_t promotion).
                else if (din[15:8]==8'h26 && din[7:4]!=4'h0) begin
                    dst<=din[7:4]; bmask<=(16'h0001<<din[3:0]); pc<=pc2; state<=S_BITB_RD;
                end
                // ---- BIT @Rd,#imm4 (0x27, NIB2=dst!=0) : MAME Z27_ddN0_imm4, flags -Z---- ----
                else if (din[15:8]==8'h27 && din[7:4]!=4'h0) begin
                    dst<=din[7:4]; bmask<=(16'h0001<<din[3:0]); pc<=pc2; state<=S_BIT_RD;
                end
                // ---- RESB/RES/SETB/SET @Rd,#imm4 static forms ----
                // RES/SET (word, 0x23/0x25) are safe word-aligned RMW (no wordacc hazard) and
                // are implemented here via the shared S_BITW_RD/WR pair (bitop_set selects
                // AND~bit vs OR bit). RESB/SETB (byte, 0x22/0x24) are DEFERRED: same wordacc-
                // unconnected hazard as the LDB store, would need the same RMW-merge pattern
                // (see report) -- not implemented this batch.
                // ---- RES @Rd,#imm4 (0x23, NIB2=dst!=0) : MAME Z23_ddN0_imm4, flags ------ ----
                else if (din[15:8]==8'h23 && din[7:4]!=4'h0) begin
                    dst<=din[7:4]; bmask<=(16'h0001<<din[3:0]); bitop_set<=1'b0;
                    pc<=pc2; state<=S_BITW_RD;
                end
                // ---- SET @Rd,#imm4 (0x25, NIB2=dst!=0) : MAME Z25_ddN0_imm4, flags ------ ----
                else if (din[15:8]==8'h25 && din[7:4]!=4'h0) begin
                    dst<=din[7:4]; bmask<=(16'h0001<<din[3:0]); bitop_set<=1'b1;
                    pc<=pc2; state<=S_BITW_RD;
                end
                else if (din[15:8]==8'h22 && din[7:4]==4'h0) begin
                    src<=din[3:0]; pc<=pc2; state<=S_RESB2_GO;
                end
                else if (din[15:8]==8'h23 && din[7:4]==4'h0) begin
                    src<=din[3:0]; pc<=pc2; state<=S_RES2_GO;
                end
                else if (din[15:8]==8'h24 && din[7:4]==4'h0) begin
                    src<=din[3:0]; pc<=pc2; state<=S_SETB2_GO;
                end
                else if (din[15:8]==8'h25 && din[7:4]==4'h0) begin
                    src<=din[3:0]; pc<=pc2; state<=S_SET2_GO;
                end
                else if (din[15:8]==8'h26 && din[7:4]==4'h0) begin
                    src<=din[3:0]; pc<=pc2; state<=S_BITB2_GO;
                end
                else if (din[15:8]==8'h27 && din[7:4]==4'h0) begin
                    src<=din[3:0]; pc<=pc2; state<=S_BIT2_GO;
                end
                // ---- EX rd,@rs (0x2D, NIB2=src!=0) : MAME Z2D_ssN0_dddd "ex rd,@rs", flags ------ ----
                // word-only exchange (safe, full-word RMW). Byte EXB (0x2C) deferred (same
                // wordacc hazard as LDB store / RESB / SETB).
                else if (din[15:8]==8'h2D && din[7:4]!=4'h0) begin
                    dst<=din[3:0]; src<=din[7:4]; pc<=pc2; state<=S_EX_RD;
                end
                // ==== BATCH 3 =============================================================
                // ---- INC addr,#n direct (0x6900-0x690F, NIB2=0) : MAME Z69_0000_imm4m1_addr,
                // flags -ZSV--. Indexed addr(Rd) form (NIB2!=0, the rest of the 0x69 byte
                // range) has no register-indexed EA datapath -- deferred per policy, same as
                // every prior batch. Real ROM usage: 60/61 direct, 1/61 indexed -- direct-only
                // covers effectively all of it. i4p1 = NIB3+1, latched into `mcnt` across the
                // addr fetch; `aluop` (reused, ADD here) tells S_INCDA_RD which op to run. ----
                else if (din[15:8]==8'h69 && din[7:4]==4'h0) begin
                    mcnt<=din[3:0]; aluop<=ADD; pc<=pc2; state<=S_INCDA_FETCH;
                end
                // ---- DEC addr,#n direct (0x6B00-0x6B0F, NIB2=0) : MAME Z6B_0000_imm4m1_addr,
                // flags -ZSV--. Indexed form deferred (38/43 real uses are direct). ----
                else if (din[15:8]==8'h6B && din[7:4]==4'h0) begin
                    mcnt<=din[3:0]; aluop<=SUB; pc<=pc2; state<=S_INCDA_FETCH;
                end
                // ---- MULT rrd,#imm16 (0x1900-0x190F, NIB2=0) : MAME Z19_0000_dddd_imm16 ----
                // flags CZS--- ; V is NEVER set by MULTW despite the MAME doc-comment saying
                // "CZSV--" -- the function body only calls CLR_CZSV, no SET_V anywhere. Trusted
                // the code over the comment (see report).
                else if (din[15:8]==8'h19 && din[7:4]==4'h0) begin
                    dst<=din[3:0]; pc<=pc2; state<=S_MULT_IMM;
                end
                // ---- MULT rrd,@rs (0x1910-0x19FF, NIB2!=0) : MAME Z19_ssN0_dddd ----
                else if (din[15:8]==8'h19 && din[7:4]!=4'h0) begin
                    dst<=din[3:0]; src<=din[7:4]; pc<=pc2; state<=S_MULT_RD;
                end
                // ---- MULT rrd,rs (0x9900-0x99FF, full range) : MAME Z99_ssss_dddd ----
                else if (din[15:8]==8'h99) begin
                    dst<=din[3:0]; operand<=R[din[7:4]]; pc<=pc2; state<=S_MULT_GO;
                end
                // ---- DIV rrd,#imm16 (0x1B00-0x1B0F, NIB2=0) : MAME Z1B_0000_dddd_imm16 ----
                // flags CZSV--. Divide-by-zero: Z,V set, C,S cleared, dest UNCHANGED.
                else if (din[15:8]==8'h1B && din[7:4]==4'h0) begin
                    dst<=din[3:0]; pc<=pc2; state<=S_DIV_IMM;
                end
                // ---- DIV rrd,@rs (0x1B10-0x1BFF, NIB2!=0) : MAME Z1B_ssN0_dddd ----
                else if (din[15:8]==8'h1B && din[7:4]!=4'h0) begin
                    dst<=din[3:0]; src<=din[7:4]; pc<=pc2; state<=S_DIV_RD;
                end
                // ---- DIV rrd,rs (0x9B00-0x9BFF, full range) : MAME Z9B_ssss_dddd ----
                else if (din[15:8]==8'h9B) begin
                    dst<=din[3:0]; operand<=R[din[7:4]]; pc<=pc2; state<=S_DIV_GO;
                end
                // ---- MULTL rqd,@rs (0x1810-0x18FF, NIB2!=0) : MAME Z18_ssN0_dddd ----
                // RQ(dst) truncates dst's low TWO bits (see header comment); the 32-bit dest
                // value MULTL actually reads is the LOW half of the quad, i.e. RL(dst|2).
                else if (din[15:8]==8'h18 && din[7:4]!=4'h0) begin
                    dst<=din[3:0]; src<=din[7:4]; pc<=pc2; state<=S_MULTL_RD_HI;
                end
                // ==== BATCH 14: MULTL rqd,#imm32 (0x1800-0x180F, NIB2=0) : MAME
                // Z18_00N0_dddd_imm32. dst=NIB3 (free 0-15, the "N0" in the handler's own
                // name is a naming artifact -- z8000tbl.hxx's dense `{0x1800,0x180f,1,...}`
                // includes dst=0). Fetches imm32 (hi-then-lo via pc, same shape as the
                // already-implemented S_LALU_IMM_HI/LO), lands in the EXISTING S_MULTL_GO. ====
                else if (din[15:8]==8'h18 && din[7:4]==4'h0) begin
                    dst<=din[3:0]; pc<=pc2; state<=S_MULTLI_HI;
                end
                // ---- MULTL rqd,rrs (0x9800-0x98FF, full range) : MAME Z98_ssss_dddd ----
                // src is a 32-bit register PAIR here (unlike MULT's plain-register src) --
                // staged combinationally straight off `din`, same convention already used by
                // ADDL/SUBL reg-reg below (RL pair base = {din[7:5],1'b0}, bit0 of the nibble
                // truncated per z8000cpu.h RL()).
                else if (din[15:8]==8'h98) begin
                    dst<=din[3:0];
                    operand <=R[{din[7:5],1'b0}]; operand2<=R[{din[7:5],1'b0}+4'd1];
                    pc<=pc2; state<=S_MULTL_GO;
                end
                // ---- DIVL rqd,@rs (0x1A10-0x1AFF, NIB2!=0) : MAME Z1A_ssN0_dddd ----
                // Dividend is the FULL 64-bit quad (read live off the regfile in S_DIVL_GO);
                // only the 32-bit divisor needs fetching here.
                else if (din[15:8]==8'h1A && din[7:4]!=4'h0) begin
                    dst<=din[3:0]; src<=din[7:4]; pc<=pc2; state<=S_DIVL_RD_HI;
                end
                // ==== BATCH 14: DIVL rqd,#imm32 (0x1A00-0x1A0F, NIB2=0) : MAME
                // Z1A_0000_dddd_imm32. dst=NIB3 (free 0-15). Fetches imm32 (hi-then-lo via
                // pc), lands in the EXISTING S_DIVL_GO. ====
                else if (din[15:8]==8'h1A && din[7:4]==4'h0) begin
                    dst<=din[3:0]; pc<=pc2; state<=S_DIVLI_HI;
                end
                // ---- DIVL rqd,rrs (0x9A00-0x9AFF, full range) : MAME Z9A_ssss_dddd ----
                else if (din[15:8]==8'h9A) begin
                    dst<=din[3:0];
                    operand <=R[{din[7:5],1'b0}]; operand2<=R[{din[7:5],1'b0}+4'd1];
                    pc<=pc2; state<=S_DIVL_GO;
                end
                // ---- ADDL rrd,#imm32 (0x1600-0x160F, NIB2=0) : MAME Z16_0000_dddd_imm32 ----
                else if (din[15:8]==8'h16 && din[7:4]==4'h0) begin
                    dst<=din[3:0]; aluop<=ADD; pc<=pc2; state<=S_LALU_IMM_HI;
                end
                // ---- ADDL rrd,@rs (0x1610-0x16FF, NIB2!=0) : MAME Z16_ssN0_dddd ----
                else if (din[15:8]==8'h16 && din[7:4]!=4'h0) begin
                    dst<=din[3:0]; src<=din[7:4]; aluop<=ADD; pc<=pc2; state<=S_LALU_RD_HI;
                end
                // ---- ADDL rrd,rrs (0x9600-0x96FF, full range) : MAME Z96_ssss_dddd ----
                else if (din[15:8]==8'h96) begin
                    dst<=din[3:0]; aluop<=ADD;
                    operand <=R[{din[7:5],1'b0}]; operand2<=R[{din[7:5],1'b0}+4'd1];
                    pc<=pc2; state<=S_LALU_GO;
                end
                // ---- SUBL rrd,#imm32 (0x1200-0x120F, NIB2=0) : MAME Z12_0000_dddd_imm32 ----
                else if (din[15:8]==8'h12 && din[7:4]==4'h0) begin
                    dst<=din[3:0]; aluop<=SUB; pc<=pc2; state<=S_LALU_IMM_HI;
                end
                // ---- SUBL rrd,@rs (0x1210-0x12FF, NIB2!=0) : MAME Z12_ssN0_dddd ----
                else if (din[15:8]==8'h12 && din[7:4]!=4'h0) begin
                    dst<=din[3:0]; src<=din[7:4]; aluop<=SUB; pc<=pc2; state<=S_LALU_RD_HI;
                end
                // ---- SUBL rrd,rrs (0x9200-0x92FF, full range) : MAME Z92_ssss_dddd ----
                else if (din[15:8]==8'h92) begin
                    dst<=din[3:0]; aluop<=SUB;
                    operand <=R[{din[7:5],1'b0}]; operand2<=R[{din[7:5],1'b0}+4'd1];
                    pc<=pc2; state<=S_LALU_GO;
                end
                // ---- LDB rbd,addr direct-load (0x6000-0x600F, NIB2=0) : MAME Z60_0000_dddd_addr
                // "ldb rbd,addr", flags ------. Read-only -- no wordacc/RMW hazard. Indexed
                // addr(rs) form (NIB2!=0) dominates REAL usage (29/32) but is deferred (no
                // indexed-EA datapath) -- flagged in the report as the strongest case yet for
                // building that datapath in a future batch.
                else if (din[15:8]==8'h60 && din[7:4]==4'h0) begin
                    dst<=din[3:0]; pc<=pc2; state<=S_LDBDA_FETCH;
                end
                // ---- LDB addr,rbs direct-store (0x6E00-0x6E0F, NIB2=0) : MAME
                // Z6E_0000_ssss_addr "ldb addr,rbs", flags ------. RMW word-aligned store (the
                // wordacc rule, see header) -- mirrors S_LDBST_RD/WR but keyed off `ea` (a
                // fetched direct address) instead of R[dst]. Indexed form (NIB2!=0) is the
                // minority here (9/21) -- deferred.
                else if (din[15:8]==8'h6E && din[7:4]==4'h0) begin
                    src<=din[3:0]; pc<=pc2; state<=S_LDBSTA_FETCH;
                end
                // ---- CLRB rbd (0x8Cd8, NIB1=8) : MAME Z8C_dddd_1000, flags ------ ----
                // 0x8C is actually a 7-way static-op family (comb/negb/testb/tsetb/ldctlb-r/
                // clrb/ldctlb-w, selected by NIB1) -- the task brief's "CLRB/TESTB static"
                // framing undersold the table but happened to nail real usage exactly: ONLY
                // these two sub-ops appear anywhere in either ROM (34 clrb + 9 testb = 43,
                // matching the queue count exactly); comb/negb/tsetb/ldctlb are unused, skipped.
                // Single-cycle, register-only -- no memory access.
                else if (din[15:8]==8'h8C && din[3:0]==4'h8) begin
                    rwb0_we=1'b1; rwb0_idx={1'b0,din[6:4]}; rwb0_val=16'h0000; rwb0_be=din[7]?2'b01:2'b10;
                    pc<=pc2; retire<=1'b1;
                end
                // ---- TESTB rbd (0x8Cd4, NIB1=4) : MAME Z8C_dddd_0100, flags -ZSP-- ----
                // Z/S/parity via the same z8000_zsp[]-equivalent formula already used for
                // Batch 2's byte AND/OR/XOR P/V (parity, not overflow).
                else if (din[15:8]==8'h8C && din[3:0]==4'h4) begin
                    dbyte = din[7] ? R[din[6:4]][7:0] : R[din[6:4]][15:8];
                    p = (~^dbyte);
                    fcw<=(fcw & ~(MZ|MS|MV)) | ((dbyte==8'h00)?MZ:0)|(dbyte[7]?MS:0)|(p?MV:0);
                    pc<=pc2; retire<=1'b1;
                end
                // ---- RLB rbd,#1|#2 (0xB2d0/0xB2d2, NIB1={0,2}) : MAME ZB2_dddd_00I0, flags
                // CZSV--. twice=NIB1 bit1. Register-only, single-cycle. ----
                else if (din[15:8]==8'hB2 && (din[3:0]==4'h0 || din[3:0]==4'h2)) begin
                    dbyte = din[7] ? R[din[6:4]][7:0] : R[din[6:4]][15:8];
                    res8 = {dbyte[6:0], dbyte[7]};
                    if (din[1]) res8 = {res8[6:0], res8[7]};
                    v = res8[7] ^ dbyte[7];
                    rwb0_we=1'b1; rwb0_idx={1'b0,din[6:4]}; rwb0_val={2{res8}}; rwb0_be=din[7]?2'b01:2'b10;
                    fcw<=(fcw & ~(MC|MZ|MS|MV)) | (res8[0]?MC:0)|((res8==8'h00)?MZ:0)
                       | (res8[7]?MS:0)|(v?MV:0);
                    pc<=pc2; retire<=1'b1;
                end
                // ---- RRB rbd,#1|#2 (0xB2d4/0xB2d6, NIB1={4,6}) : MAME ZB2_dddd_01I0, flags
                // CZSV--. QUIRK (verified in RRB(), not the doc-comment): if result==0 only Z
                // is set; else if result[7] BOTH S and C are set together (MAME SET_SC macro);
                // else (positive nonzero) neither Z/S/C is touched. Not the usual independent
                // C/Z/S computation the rest of the ISA uses -- replicated exactly. ----
                else if (din[15:8]==8'hB2 && (din[3:0]==4'h4 || din[3:0]==4'h6)) begin
                    dbyte = din[7] ? R[din[6:4]][7:0] : R[din[6:4]][15:8];
                    res8 = {dbyte[0], dbyte[7:1]};
                    if (din[1]) res8 = {res8[0], res8[7:1]};
                    v = res8[7] ^ dbyte[7];
                    rwb0_we=1'b1; rwb0_idx={1'b0,din[6:4]}; rwb0_val={2{res8}}; rwb0_be=din[7]?2'b01:2'b10;
                    fcw<=(fcw & ~(MC|MZ|MS|MV)) | ((res8==8'h00)?MZ:0)
                       | ((res8!=8'h00 && res8[7])?(MC|MS):0) | (v?MV:0);
                    pc<=pc2; retire<=1'b1;
                end
                // ---- RRCB rbd,#1|#2 (0xB2dC/0xB2dE, NIB1={C,E}) : MAME ZB2_dddd_11I0 "rotate
                // right through carry", flags CZSV-- (doc-comment says "-Z----", WRONG -- the
                // RRCB() body clearly does CLR_CZSV + SET_C + SET_V, trusted the code).
                // Two-stage carry bookkeeping for `twice`: the first rotation's
                // carry-OUT becomes the second rotation's carry-IN at the opposite end. ----
                else if (din[15:8]==8'hB2 && (din[3:0]==4'hC || din[3:0]==4'hE)) begin
                    dbyte = din[7] ? R[din[6:4]][7:0] : R[din[6:4]][15:8];
                    res8 = {fcw[FC], dbyte[7:1]};
                    cbit = dbyte[0];
                    if (din[1]) begin
                        cbit = res8[0];
                        res8 = {dbyte[0], res8[7:1]};
                    end
                    v = res8[7] ^ dbyte[7];
                    rwb0_we=1'b1; rwb0_idx={1'b0,din[6:4]}; rwb0_val={2{res8}}; rwb0_be=din[7]?2'b01:2'b10;
                    fcw<=(fcw & ~(MC|MZ|MS|MV)) | (cbit?MC:0)|((res8==8'h00)?MZ:0)
                       | (res8[7]?MS:0)|(v?MV:0);
                    pc<=pc2; retire<=1'b1;
                end
                // ==== BATCH 14: RLCB rbd,#1|#2 (0xB2d8/0xB2dA, NIB1={8,A}) : MAME
                // ZB2_dddd_10I0 "rotate left through carry", flags CZSV--. Previously
                // skipped ("zero real ROM occurrences" under Batch 3's narrower-scope
                // policy) -- implemented now for the "close the whole decode" mandate.
                // Mirrors the already-implemented RRCB exactly, direction reversed. ====
                else if (din[15:8]==8'hB2 && (din[3:0]==4'h8 || din[3:0]==4'hA)) begin
                    dbyte = din[7] ? R[din[6:4]][7:0] : R[din[6:4]][15:8];
                    cbit = dbyte[7];
                    res8 = {dbyte[6:0], fcw[FC]};
                    if (din[1]) begin
                        cbit = res8[7];
                        res8 = {res8[6:0], dbyte[7]};
                    end
                    v = res8[7] ^ dbyte[7];
                    rwb0_we=1'b1; rwb0_idx={1'b0,din[6:4]}; rwb0_val={2{res8}}; rwb0_be=din[7]?2'b01:2'b10;
                    fcw<=(fcw & ~(MC|MZ|MS|MV)) | (cbit?MC:0)|((res8==8'h00)?MZ:0)
                       | (res8[7]?MS:0)|(v?MV:0);
                    pc<=pc2; retire<=1'b1;
                end
                // ---- SLLB/SRLB rbd,#imm8 (0xB2d1, NIB1=1) : MAME ZB2_dddd_0001_imm8, sign of
                // imm8 selects direction (matches the existing word S_SHIFT convention exactly,
                // negative=right/SRLB, positive=left/SLLB). flags CZS--- ; V is NOT touched
                // (SLLB/SRLB both call CLR_CZS, never CLR_CZSV and never SET_V -- doc-comment
                // says "srlb: CZSV--" but the function body proves otherwise, trusted the code).
                // SLAB/SRAB (0xB2d9, arithmetic) form still has zero real ROM occurrences --
                // skipped like its siblings; register-count SDLB/SDAB are implemented below. ----
                else if (din[15:8]==8'hB2 && din[3:0]==4'h1) begin
                    dst<=din[7:4]; pc<=pc2; state<=S_SHIFTB;
                end
                // ==== BATCH 14: SDLB rbd,rs (0xB2d3) : MAME
                // ZB2_dddd_0011_0000_ssss_0000_0000, flags CZSV-- (its doc-comment AND body
                // both confirm V IS set here, unlike SLLB's imm8 sibling above -- verified,
                // not assumed from the "SD" prefix's resemblance to SLL). Dynamic (register-
                // count) sibling of SLLB/SRLB: count = sign-extended R[word2 NIB1][7:0],
                // positive=left/negative=right (same convention as every imm-shift in this
                // file), computed as a single barrel shift + explicit carry-capture -- proven
                // equivalent to MAME's bit-serial loop (same technique already used by
                // S_SHIFT/S_SHIFTA/S_SHIFTL for the immediate forms). Single-cycle: word2's
                // NIB1 (the count register NUMBER) and that register's live VALUE are both
                // available combinationally the same cycle word2 is read via `pc`, no further
                // memory access needed (same shape as S_Z74_FETCH). ====
                else if (din[15:8]==8'hB2 && din[3:0]==4'h3) begin
                    dst<=din[7:4]; pc<=pc2; state<=S_SDLB_GO;
                end
                // ---- SDAB rbd,rs (0xB2dB) : MAME ZB2_dddd_1011_0000_ssss_0000_0000, flags
                // CZSV--. Same shape as SDLB above; differs only in the RIGHT-shift fill
                // (arithmetic sign-extend vs logical zero-fill -- LEFT shift is bit-identical
                // either way, matching SDAB()/SDLB()'s own C bodies). ----
                else if (din[15:8]==8'hB2 && din[3:0]==4'hB) begin
                    dst<=din[7:4]; pc<=pc2; state<=S_SDAB_GO;
                end
                // ==== BATCH 15: SLAB/SRAB rbd,#imm8 (0xB2d9) : MAME ZB2_dddd_1001_imm8,
                // flags CZSV-- (byte arithmetic sibling of the already-implemented SLLB/
                // SRLB imm8, S_SHIFTB). Previously skipped ("zero real ROM occurrences") --
                // implemented now via the new S_SHIFTAB state. ====
                else if (din[15:8]==8'hB2 && din[3:0]==4'h9) begin
                    dst<=din[7:4]; pc<=pc2; state<=S_SHIFTAB;
                end
                // ==== BATCH 14: RL/RR/RLC/RRC rd,#1|#2 (0xB3d0/d2/d4/d6/d8/dA/dC/dE) : MAME
                // ZB3_dddd_00I0/01I0/10I0/11I0, flags CZSV--. Word siblings of the already-
                // implemented RLB/RRB/RLCB/RRCB, one level wider (full register 0-15, no
                // byte-half select). ENTIRE word RL/RR/RLC/RRC family was previously missing
                // (only the byte forms existed). ====
                else if (din[15:8]==8'hB3 && (din[3:0]==4'h0 || din[3:0]==4'h2)) begin
                    a16 = R[din[7:4]];
                    res16 = {a16[14:0], a16[15]};
                    if (din[1]) res16 = {res16[14:0], res16[15]};
                    v = res16[15] ^ a16[15];
                    rwb0_we=1'b1; rwb0_idx=din[7:4]; rwb0_val=res16;
                    fcw<=(fcw & ~(MC|MZ|MS|MV)) | (res16[0]?MC:0)|((res16==16'h0000)?MZ:0)
                       | (res16[15]?MS:0)|(v?MV:0);
                    pc<=pc2; retire<=1'b1;
                end
                // ---- RR rd,#1|#2 (0xB3d4/0xB3d6) : same "if result==0 only Z; else if
                // result[15] both S+C together" quirk as byte RRB, one level wider. ----
                else if (din[15:8]==8'hB3 && (din[3:0]==4'h4 || din[3:0]==4'h6)) begin
                    a16 = R[din[7:4]];
                    res16 = {a16[0], a16[15:1]};
                    if (din[1]) res16 = {res16[0], res16[15:1]};
                    v = res16[15] ^ a16[15];
                    rwb0_we=1'b1; rwb0_idx=din[7:4]; rwb0_val=res16;
                    fcw<=(fcw & ~(MC|MZ|MS|MV)) | ((res16==16'h0000)?MZ:0)
                       | ((res16!=16'h0000 && res16[15])?(MC|MS):0) | (v?MV:0);
                    pc<=pc2; retire<=1'b1;
                end
                // ---- RLC rd,#1|#2 (0xB3d8/0xB3dA) : word sibling of RLCB above. ----
                else if (din[15:8]==8'hB3 && (din[3:0]==4'h8 || din[3:0]==4'hA)) begin
                    a16 = R[din[7:4]];
                    cbit = a16[15];
                    res16 = {a16[14:0], fcw[FC]};
                    if (din[1]) begin
                        cbit = res16[15];
                        res16 = {res16[14:0], a16[15]};
                    end
                    v = res16[15] ^ a16[15];
                    rwb0_we=1'b1; rwb0_idx=din[7:4]; rwb0_val=res16;
                    fcw<=(fcw & ~(MC|MZ|MS|MV)) | (cbit?MC:0)|((res16==16'h0000)?MZ:0)
                       | (res16[15]?MS:0)|(v?MV:0);
                    pc<=pc2; retire<=1'b1;
                end
                // ---- RRC rd,#1|#2 (0xB3dC/0xB3dE) : word sibling of the already-implemented
                // RRCB. ----
                else if (din[15:8]==8'hB3 && (din[3:0]==4'hC || din[3:0]==4'hE)) begin
                    a16 = R[din[7:4]];
                    res16 = {fcw[FC], a16[15:1]};
                    cbit = a16[0];
                    if (din[1]) begin
                        cbit = res16[0];
                        res16 = {a16[0], res16[15:1]};
                    end
                    v = res16[15] ^ a16[15];
                    rwb0_we=1'b1; rwb0_idx=din[7:4]; rwb0_val=res16;
                    fcw<=(fcw & ~(MC|MZ|MS|MV)) | (cbit?MC:0)|((res16==16'h0000)?MZ:0)
                       | (res16[15]?MS:0)|(v?MV:0);
                    pc<=pc2; retire<=1'b1;
                end
                // ==== BATCH 14: SDL/SDA rd,rs (0xB3d3/dB) and SDLL/SDAL rrd,rs (0xB3d7/dF) --
                // register-count dynamic shifts, word/long siblings of SDLB/SDAB above.
                // Long forms pass RW(src)&0xff (truncated, then reinterpreted as int8_t by
                // the C parameter type -- same value as (int8_t)RW(src) for the low byte,
                // confirmed against z8000ops.hxx's SDLL/SDAL call sites). ====
                else if (din[15:8]==8'hB3 && din[3:0]==4'h3) begin
                    dst<=din[7:4]; pc<=pc2; state<=S_SDLW_GO;
                end
                else if (din[15:8]==8'hB3 && din[3:0]==4'hB) begin
                    dst<=din[7:4]; pc<=pc2; state<=S_SDAW_GO;
                end
                else if (din[15:8]==8'hB3 && din[3:0]==4'h7) begin
                    dst<=din[7:4]; pc<=pc2; state<=S_SDLL_GO;
                end
                else if (din[15:8]==8'hB3 && din[3:0]==4'hF) begin
                    dst<=din[7:4]; pc<=pc2; state<=S_SDAL_GO;
                end
                // ---- CPL rrd,addr direct (0x5000-0x500F, NIB2=0) : MAME Z50_0000_dddd_addr
                // "cpl rrd,addr", compare-only, no writeback. Indexed addr(rs) form dominates
                // real usage (20/23) but is deferred (no indexed-EA datapath) -- like LDB-load
                // 0x60, this is a strong future-batch candidate for that datapath; direct-only
                // covers just 3/23 here. ----
                else if (din[15:8]==8'h50 && din[7:4]==4'h0) begin
                    dst<=din[3:0]; pc<=pc2; state<=S_CPLA_FETCH;
                end
                // ==== BATCH 4: register-indexed addr(Rx) EA datapath (CENTERPIECE) =========
                // For each family below, NIB2 (din[7:4]) is the index register -- verified
                // against z8000ops.hxx per-opcode (Z60_ssN0_dddd_addr / Z6E_ddN0_ssss_addr /
                // Z50_ssN0_dddd_addr / Z69_ddN0_imm4m1_addr / Z6B_ddN0_imm4m1_addr all use
                // GET_SRC-or-GET_DST(OP0,NIB2) for the index and addr_add(addr,RW(index)) --
                // confirming the task brief's hint exactly for all five. `idxr` latches that
                // nibble; the *X_FETCH states add R[idxr] to the fetched addr word in the
                // SAME cycle it's latched, then hand off into the EXISTING, UNTOUCHED direct-
                // form RD/WR states (S_LDBDA_RD / S_LDBSTA_RD.. / S_CPLA_RD_HI.. / S_INCDA_RD..)
                // -- so the NIB2==0 direct path (decoded a few lines above, unmodified) and the
                // indexed path share only those tail states, never their FETCH/decode logic.
                // ---- LDB rbd,addr(Rs) indexed load (0x6010-0x60FF, NIB2=idx!=0) : MAME
                // Z60_ssN0_dddd_addr. Real usage 29/32 of LDB-load -- the dominant form. ----
                else if (din[15:8]==8'h60 && din[7:4]!=4'h0) begin
                    dst<=din[3:0]; idxr<=din[7:4]; pc<=pc2; state<=S_LDBDAX_FETCH;
                end
                // ---- LDB addr(Rs),rbs indexed store (0x6E10-0x6EFF, NIB2=idx!=0) : MAME
                // Z6E_ddN0_ssss_addr (field named "dd" but is the INDEX reg, not a dest --
                // same misleading-macro-name pattern already flagged for Z69/Z6B). Real usage
                // 9/21 of LDB-store. RMW word-aligned store per the wordacc rule (unchanged
                // merge logic, only `ea` now includes the index term). ----
                else if (din[15:8]==8'h6E && din[7:4]!=4'h0) begin
                    src<=din[3:0]; idxr<=din[7:4]; pc<=pc2; state<=S_LDBSTAX_FETCH;
                end
                // ---- CPL rrd,addr(Rs) indexed (0x5010-0x50FF, NIB2=idx!=0) : MAME
                // Z50_ssN0_dddd_addr. Real usage 20/23 of CPL-direct -- the dominant form. ----
                else if (din[15:8]==8'h50 && din[7:4]!=4'h0) begin
                    dst<=din[3:0]; idxr<=din[7:4]; pc<=pc2; state<=S_CPLAX_FETCH;
                end
                // ---- INC addr(Rd),#n indexed (0x6910-0x69FF, NIB2=idx!=0) : MAME
                // Z69_ddN0_imm4m1_addr. Real usage only 1/61 (direct dominates for INC,
                // unlike its siblings) -- implemented anyway since the datapath is shared. ----
                else if (din[15:8]==8'h69 && din[7:4]!=4'h0) begin
                    mcnt<=din[3:0]; aluop<=ADD; idxr<=din[7:4]; pc<=pc2; state<=S_INCDAX_FETCH;
                end
                // ---- DEC addr(Rd),#n indexed (0x6B10-0x6BFF, NIB2=idx!=0) : MAME
                // Z6B_ddN0_imm4m1_addr. Real usage 5/43 of DEC. ----
                else if (din[15:8]==8'h6B && din[7:4]!=4'h0) begin
                    mcnt<=din[3:0]; aluop<=SUB; idxr<=din[7:4]; pc<=pc2; state<=S_INCDAX_FETCH;
                end
                // ==== BATCH 4: register-only bonus opcodes ==================================
                // ---- NEG rd (0x8Dd2, NIB0=2) : MAME Z8D_dddd_0010, flags CZSV--. Real usage
                // 58 (dominant single-register op family this batch). C=1 iff result!=0 (a
                // negation only "doesn't carry" when the input was already 0); V=1 only for
                // the -32768 edge case (its negation doesn't fit in 16 bits). ----
                else if (din[15:8]==8'h8D && din[3:0]==4'h2) begin
                    res16 = 16'h0000 - R[din[7:4]];
                    v = (res16==16'h8000);
                    rwb0_we=1'b1; rwb0_idx=din[7:4]; rwb0_val=res16;
                    fcw<=(fcw & ~(MC|MZ|MS|MV))
                       | ((res16!=16'h0000)?MC:0)|((res16==16'h0000)?MZ:0)|(res16[15]?MS:0)|(v?MV:0);
                    pc<=pc2; retire<=1'b1;
                end
                // ---- COM rd (0x8Dd0, NIB0=0) : MAME Z8D_dddd_0000, flags -ZS---. Real usage
                // only ~6 but zero marginal cost (same 0x8D dispatch as NEG/CLR above). ----
                else if (din[15:8]==8'h8D && din[3:0]==4'h0) begin
                    res16 = ~R[din[7:4]];
                    rwb0_we=1'b1; rwb0_idx=din[7:4]; rwb0_val=res16;
                    fcw<=(fcw & ~(MZ|MS)) | ((res16==16'h0000)?MZ:0)|(res16[15]?MS:0);
                    pc<=pc2; retire<=1'b1;
                end
                // ---- EXTSB rd (0xB1d0, NIB0=0) : MAME ZB1_dddd_0000 "extsb rd", flags ------.
                // Sign-extends the LOW BYTE of the WHOLE word register back over itself (dst
                // is a plain register index here, NOT a byte-reg code -- verified against
                // RW(dst)=(int16_t)(int8_t)RW(dst) operating on the full register). Real usage
                // 7. ----
                else if (din[15:8]==8'hB1 && din[3:0]==4'h0) begin
                    rwb0_we=1'b1; rwb0_idx=din[7:4]; rwb0_val={{8{R[din[7:4]][7]}}, R[din[7:4]][7:0]};
                    pc<=pc2; retire<=1'b1;
                end
                // ==== BATCH 8: DAB rbd (0xB0d0, NIB0=0) : MAME ZB0_dddd_0000 "dab rbd",
                // flags CZS---. dst(NIB2=din[7:4]) is a byte-reg code (dst[3] selects hi/lo
                // half of R[dst[2:0]], same convention as ldbst_val/exb_val above). Single-
                // cycle register-only op, no memory access -- retires directly like the
                // EXTSB/EXTS forms just above. idx into dab_rom = {DA,H,C,byte-value} per
                // z8000dab.h's own header comment; CZS recomputed from the RESULT byte
                // (CLR_CZS+CHK_XXXB_ZS: Z=(result==0), S=result[7]; H is left UNCHANGED --
                // MAME's DAB never touches F_H, matching CLR_CZS's mask exactly). ====
                else if (din[15:8]==8'hB0 && din[3:0]==4'h0) begin
                    dab_byte = din[7] ? R[din[6:4]][7:0] : R[din[6:4]][15:8];
                    dab_idx  = {fcw[FDA], fcw[FH], fcw[FC], dab_byte};
                    dab_res  = dab_rom[dab_idx];
                    rwb0_we=1'b1; rwb0_idx={1'b0,din[6:4]}; rwb0_val={2{dab_res[7:0]}}; rwb0_be=din[7]?2'b01:2'b10;
                    fcw<=(fcw & ~(MC|MZ|MS)) | (dab_res[8]?MC:0) | ((dab_res[7:0]==8'h00)?MZ:0) | (dab_res[7]?MS:0);
                    pc<=pc2; retire<=1'b1;
                end
                // ---- EXTS rrd (0xB1dA, NIB0=A) : MAME ZB1_dddd_1010 "exts rrd", flags ------.
                // Sign-extends the LOW WORD of the register pair into the HIGH word (RL(dst)=
                // (int32_t)(int16_t)RL(dst) -- low word unchanged, only the hi word needs a
                // write). Pair-base = {din[7:5],1'b0} (bit0-of-nibble truncation, same
                // derivation already used for the ADDL/SUBL reg-reg forms). Real usage 9. ----
                else if (din[15:8]==8'hB1 && din[3:0]==4'hA) begin
                    rwb0_we=1'b1; rwb0_idx={din[7:5],1'b0}; rwb0_val={16{R[{din[7:5],1'b0}+4'd1][15]}};
                    pc<=pc2; retire<=1'b1;
                end
                // ---- RESB @Rd,#imm4 (0x2210-0x22FF, NIB2=dst!=0) : MAME Z22_ddN0_imm4 "resb
                // @rd,imm4", flags ------. Byte RMW via S_RESETB_RD/WR (shares bmask/bitop_set
                // with the existing word RES/SET). The 2-word reg-reg form (0x2200-0x220F,
                // "resb rbd,rs") has only ~1 real occurrence -- skipped. Real usage 13. ----
                else if (din[15:8]==8'h22 && din[7:4]!=4'h0) begin
                    dst<=din[7:4]; bmask<=(16'h0001<<din[3:0]); bitop_set<=1'b0;
                    pc<=pc2; state<=S_RESETB_RD;
                end
                // ---- SETB @Rd,#imm4 (0x2410-0x24FF, NIB2=dst!=0) : MAME Z24_ddN0_imm4 "setb
                // @rd,imm4", flags ------. Same S_RESETB_RD/WR pump, bitop_set=1. Real usage
                // 28 -- the single highest-value byte-RMW addition this batch. ----
                else if (din[15:8]==8'h24 && din[7:4]!=4'h0) begin
                    dst<=din[7:4]; bmask<=(16'h0001<<din[3:0]); bitop_set<=1'b1;
                    pc<=pc2; state<=S_RESETB_RD;
                end
                // ---- EXB rbd,@rs (0x2C10-0x2CFF, NIB2=src!=0) : MAME Z2C_ssN0_dddd "exb
                // rbd,@rs", flags ------. Byte RMW exchange (S_EXB_RD/WR): addr=R[src]&~1,
                // lane=R[src][0], dst=value byte-reg-code (mirrors EX's dst/src convention).
                // Real usage 11. ----
                else if (din[15:8]==8'h2C && din[7:4]!=4'h0) begin
                    dst<=din[3:0]; src<=din[7:4]; pc<=pc2; state<=S_EXB_RD;
                end
                // ---- EXB rbd,rbs (0xAC, full range) : MAME ZAC_ssss_dddd "exb rbd,rbs",
                // flags ------. Register-only byte swap, single-cycle -- both halves read the
                // OLD value combinationally (non-blocking assignment), so dst==src is a
                // correct (harmless) no-op swap. Real usage only 2 but zero marginal states. ----
                else if (din[15:8]==8'hAC) begin
                    rwb0_we=1'b1; rwb0_idx={1'b0,din[2:0]}; rwb0_be=din[3]?2'b01:2'b10; rwb0_val={2{din[7] ? R[din[6:4]][7:0] : R[din[6:4]][15:8]}};
                    rwb1_we=1'b1; rwb1_idx={1'b0,din[6:4]}; rwb1_be=din[7]?2'b01:2'b10; rwb1_val={2{din[3] ? R[din[2:0]][7:0] : R[din[2:0]][15:8]}};
                    pc<=pc2; retire<=1'b1;
                end
                // ---- ADCB rd,rs (0xB4, full range) : MAME ZB4_ssss_dddd, flags CZSVDH (DA
                // cleared -- CLR_DA in the macro body, like ADDB). dst=NIB3,src=NIB2 (both
                // byte-reg codes). C/H computed as carry-out of a 9-bit/5-bit add-with-carry-
                // in, proven equivalent to CHK_ADCX_C/CHK_ADCB_H's more roundabout C form
                // (verified by hand for the dest==result edge cases). Real usage 9. ----
                else if (din[15:8]==8'hB4) begin
                    dbyte     = din[3] ? R[din[2:0]][7:0] : R[din[2:0]][15:8];
                    operand_b = din[7] ? R[din[6:4]][7:0] : R[din[6:4]][15:8];
                    add8 = {1'b0,dbyte} + {1'b0,operand_b} + {8'd0,fcw[FC]};
                    nibc = {1'b0,dbyte[3:0]} + {1'b0,operand_b[3:0]} + {4'd0,fcw[FC]};
                    v = (operand_b[7]&dbyte[7]&~add8[7])|(~operand_b[7]&~dbyte[7]&add8[7]);
                    rwb0_we=1'b1; rwb0_idx={1'b0,din[2:0]}; rwb0_val={2{add8[7:0]}}; rwb0_be=din[3]?2'b01:2'b10;
                    fcw<=(fcw & ~(MC|MZ|MS|MV|MDA|MH))
                       | (add8[8]?MC:0)|((add8[7:0]==0)?MZ:0)|(add8[7]?MS:0)|(v?MV:0)|(nibc[4]?MH:0);
                    pc<=pc2; retire<=1'b1;
                end
                // ---- ADC rd,rs (0xB5, full range) : MAME ZB5_ssss_dddd, flags CZSV-- (no
                // H/DA, matches ADDW). dst=NIB3=din[3:0],src=NIB2=din[7:4] (plain word regs).
                // Real usage 4. ----
                else if (din[15:8]==8'hB5) begin
                    a16 = R[din[3:0]];
                    sum17 = {1'b0,a16} + {1'b0,R[din[7:4]]} + {16'd0,fcw[FC]};
                    v = (~a16[15]&~R[din[7:4]][15]&sum17[15])|(a16[15]&R[din[7:4]][15]&~sum17[15]);
                    rwb0_we=1'b1; rwb0_idx=din[3:0]; rwb0_val=sum17[15:0];
                    fcw<=(fcw & ~(MC|MZ|MS|MV))
                       | (sum17[16]?MC:0)|((sum17[15:0]==0)?MZ:0)|(sum17[15]?MS:0)|(v?MV:0);
                    pc<=pc2; retire<=1'b1;
                end
                // ---- SBCB rd,rs (0xB6, full range) : MAME ZB6_ssss_dddd, flags CZSVDH (DA
                // SET unconditionally -- SET_DA in the macro body, like SUBB). C/H computed as
                // borrow-out of a 9-bit/5-bit subtract-with-borrow-in (dual of ADCB's carry
                // form, same equivalence argument). Real usage 5. ----
                else if (din[15:8]==8'hB6) begin
                    dbyte     = din[3] ? R[din[2:0]][7:0] : R[din[2:0]][15:8];
                    operand_b = din[7] ? R[din[6:4]][7:0] : R[din[6:4]][15:8];
                    add8 = {1'b0,dbyte} - {1'b0,operand_b} - {8'd0,fcw[FC]};
                    nibc = {1'b0,dbyte[3:0]} - {1'b0,operand_b[3:0]} - {4'd0,fcw[FC]};
                    v = (~operand_b[7]&dbyte[7]&~add8[7])|(operand_b[7]&~dbyte[7]&add8[7]);
                    rwb0_we=1'b1; rwb0_idx={1'b0,din[2:0]}; rwb0_val={2{add8[7:0]}}; rwb0_be=din[3]?2'b01:2'b10;
                    fcw<=(fcw & ~(MC|MZ|MS|MV|MDA|MH))
                       | (add8[8]?MC:0)|((add8[7:0]==0)?MZ:0)|(add8[7]?MS:0)|(v?MV:0)|MDA|(nibc[4]?MH:0);
                    pc<=pc2; retire<=1'b1;
                end
                // ---- SBC rd,rs (0xB7, full range) : MAME ZB7_ssss_dddd, flags CZSV-- (no
                // H/DA, matches SUBW). Real usage 2. ----
                else if (din[15:8]==8'hB7) begin
                    a16 = R[din[3:0]];
                    dif17 = {1'b0,a16} - {1'b0,R[din[7:4]]} - {16'd0,fcw[FC]};
                    v = (~R[din[7:4]][15]&a16[15]&~dif17[15])|(R[din[7:4]][15]&~a16[15]&dif17[15]);
                    rwb0_we=1'b1; rwb0_idx=din[3:0]; rwb0_val=dif17[15:0];
                    fcw<=(fcw & ~(MC|MZ|MS|MV))
                       | (dif17[16]?MC:0)|((dif17[15:0]==0)?MZ:0)|(dif17[15]?MS:0)|(v?MV:0);
                    pc<=pc2; retire<=1'b1;
                end
                // ==== BATCH 5: direct-address(+index) RESB/RES/SETB/SET/BITB/BIT/EXB/EX ====
                // NIB2(din[7:4])=0 -> direct (ea<=din); NIB2!=0 -> indexed (idxr<=NIB2, EA
                // computed in the *X_FETCH state as ea<=din+R[idxr], the Batch-4 pattern).
                // Bit-index/exchange-reg field is NIB3(din[3:0]) for ALL eight regardless of
                // NIB2 -- GET_BIT/GET_DST(OP0,NIB3), confirmed per z8000ops.hxx handler.
                // ---- RESB addr[,(rd)],#imm4 (0x6200-0x62FF) : MAME Z62_0000_imm4_addr /
                // Z62_ddN0_imm4_addr, byte RMW, flags ------. Real usage: 0 confirmed (see
                // header) -- kept for family completeness, rides free on SETB's states. ----
                else if (din[15:8]==8'h62 && din[7:4]==4'h0) begin
                    bmask<=(16'h0001<<din[3:0]); bitop_set<=1'b0; pc<=pc2; state<=S_DAB_RESB_FETCH;
                end
                else if (din[15:8]==8'h62 && din[7:4]!=4'h0) begin
                    bmask<=(16'h0001<<din[3:0]); bitop_set<=1'b0; idxr<=din[7:4];
                    pc<=pc2; state<=S_DAB_RESBX_FETCH;
                end
                // ---- RES addr[,(rd)],#imm4 (0x6300-0x63FF) : MAME Z63_0000_imm4_addr /
                // Z63_ddN0_imm4_addr, word RMW, flags ------. Real usage 22 (21 direct+1 idx). ----
                else if (din[15:8]==8'h63 && din[7:4]==4'h0) begin
                    bmask<=(16'h0001<<din[3:0]); bitop_set<=1'b0; pc<=pc2; state<=S_DAB_RESW_FETCH;
                end
                else if (din[15:8]==8'h63 && din[7:4]!=4'h0) begin
                    bmask<=(16'h0001<<din[3:0]); bitop_set<=1'b0; idxr<=din[7:4];
                    pc<=pc2; state<=S_DAB_RESWX_FETCH;
                end
                // ---- SETB addr[,(rd)],#imm4 (0x6400-0x64FF) : MAME Z64_0000_imm4_addr /
                // Z64_ddN0_imm4_addr, byte RMW, flags ------. Real usage 1 (direct only). ----
                else if (din[15:8]==8'h64 && din[7:4]==4'h0) begin
                    bmask<=(16'h0001<<din[3:0]); bitop_set<=1'b1; pc<=pc2; state<=S_DAB_RESB_FETCH;
                end
                else if (din[15:8]==8'h64 && din[7:4]!=4'h0) begin
                    bmask<=(16'h0001<<din[3:0]); bitop_set<=1'b1; idxr<=din[7:4];
                    pc<=pc2; state<=S_DAB_RESBX_FETCH;
                end
                // ---- SET addr[,(rd)],#imm4 (0x6500-0x65FF) : MAME Z65_0000_imm4_addr /
                // Z65_ddN0_imm4_addr, word RMW, flags ------. Real usage 43 (all direct). ----
                else if (din[15:8]==8'h65 && din[7:4]==4'h0) begin
                    bmask<=(16'h0001<<din[3:0]); bitop_set<=1'b1; pc<=pc2; state<=S_DAB_RESW_FETCH;
                end
                else if (din[15:8]==8'h65 && din[7:4]!=4'h0) begin
                    bmask<=(16'h0001<<din[3:0]); bitop_set<=1'b1; idxr<=din[7:4];
                    pc<=pc2; state<=S_DAB_RESWX_FETCH;
                end
                // ---- BITB addr[,(rd)],#imm4 (0x6600-0x66FF) : MAME Z66_0000_imm4_addr /
                // Z66_ddN0_imm4_addr, read-only byte, flags -Z----. Real usage: 0 confirmed
                // (see header) -- kept for family completeness, rides free on BIT's states. ----
                else if (din[15:8]==8'h66 && din[7:4]==4'h0) begin
                    bmask<=(16'h0001<<din[3:0]); pc<=pc2; state<=S_DAB_BITB_FETCH;
                end
                else if (din[15:8]==8'h66 && din[7:4]!=4'h0) begin
                    bmask<=(16'h0001<<din[3:0]); idxr<=din[7:4]; pc<=pc2; state<=S_DAB_BITBX_FETCH;
                end
                // ---- BIT addr[,(rd)],#imm4 (0x6700-0x67FF) : MAME Z67_0000_imm4_addr /
                // Z67_ddN0_imm4_addr, read-only word, flags -Z----. Real usage 52 (47 direct+
                // 5 idx) -- the single highest-value opcode in this whole batch. ----
                else if (din[15:8]==8'h67 && din[7:4]==4'h0) begin
                    bmask<=(16'h0001<<din[3:0]); pc<=pc2; state<=S_DAB_BITW_FETCH;
                end
                else if (din[15:8]==8'h67 && din[7:4]!=4'h0) begin
                    bmask<=(16'h0001<<din[3:0]); idxr<=din[7:4]; pc<=pc2; state<=S_DAB_BITWX_FETCH;
                end
                // ---- EXB rbd,addr[(rs)] (0x6C00-0x6CFF) : MAME Z6C_0000_dddd_addr /
                // Z6C_ssN0_dddd_addr, byte RMW exchange, flags ------. `dst`=NIB3=value
                // register's byte-reg-code (mirrors the existing register-indirect EXB
                // convention, 0x2C). Real usage: 0 confirmed (see header) -- kept for family
                // completeness, rides free on EX's states. ----
                else if (din[15:8]==8'h6C && din[7:4]==4'h0) begin
                    dst<=din[3:0]; pc<=pc2; state<=S_DAB_EXB_FETCH;
                end
                else if (din[15:8]==8'h6C && din[7:4]!=4'h0) begin
                    dst<=din[3:0]; idxr<=din[7:4]; pc<=pc2; state<=S_DAB_EXBX_FETCH;
                end
                // ---- EX rd,addr[(rs)] (0x6D00-0x6DFF) : MAME Z6D_0000_dddd_addr /
                // Z6D_ssN0_dddd_addr, word exchange, flags ------. Real usage 6 (all
                // indexed -- direct form unused in the sample). ----
                else if (din[15:8]==8'h6D && din[7:4]==4'h0) begin
                    dst<=din[3:0]; pc<=pc2; state<=S_DAB_EXW_FETCH;
                end
                else if (din[15:8]==8'h6D && din[7:4]!=4'h0) begin
                    dst<=din[3:0]; idxr<=din[7:4]; pc<=pc2; state<=S_DAB_EXWX_FETCH;
                end
                // ---- EX rd,rs reg-reg (0xAD, full range) : MAME ZAD_ssss_dddd "ex rd,rs",
                // flags ------. Real usage 3. Register-only, single-cycle -- both sides read
                // the OLD value combinationally (non-blocking assignment), so dst==src is a
                // correct (harmless) no-op swap, mirroring the existing EXB reg-reg (0xAC). ----
                else if (din[15:8]==8'hAD) begin
                    rwb0_we=1'b1; rwb0_idx=din[3:0]; rwb0_val=R[din[7:4]];
                    rwb1_we=1'b1; rwb1_idx=din[7:4]; rwb1_val=R[din[3:0]];
                    pc<=pc2; retire<=1'b1;
                end
                // ==== BATCH 5 PART 2: register-indirect @Rd simple family (0x0C/0x0D) =====
                // dst=NIB2(din[7:4]), sub-op selector=NIB3(din[3:0]). z8000tbl.hxx's table
                // range for this whole family starts at NIB2=1 (0x0c10/0x0d10, NOT 0x0c00/
                // 0x0d00) -- dst=R0 is UNDEFINED here (falls to illegal on real MAME), so
                // every arm below is gated din[7:4]!=0, matching the file's existing
                // convention for other indirect forms (e.g. the 0x0D/NIB3=9 PUSH arm above).
                // NOTE: the pre-existing baseline LD @rd,#imm16 arm (0x0D/NIB3=5, a few
                // hundred lines up) does NOT have this guard -- flagged in the report as a
                // likely pre-existing gap, not touched (out of scope: don't modify existing
                // bodies).
                // ==== BATCH 15: COMB/NEGB/CPB/LDB @rd -- the remaining 0x0C sub-ops,
                // previously skipped ("zero confirmed real ROM occurrences" / COMB's
                // ambiguity, see below) -- implemented now for the "close the whole decode"
                // mandate. Reuse the EXISTING S_DAC_RD/S_DAC_IMM pipe (Batch 10, direct-
                // address family) by pointing `ea` straight at R[dst] instead of a fetched
                // address -- no FETCH stage needed (EA is already known), no new states.
                // COMB @rd (0x0C_x_0, NIB3=0000) : MAME Z0C_ddN0_0000 body reads
                // GET_DST(OP0,NIB3) instead of NIB2 like EVERY sibling (NEGB/TESTB/TSETB/
                // CLRB/LDB/CPB all correctly use NIB2) -- since NIB3 is the FIXED sub-op
                // selector here (always 0000 for this one), taking it literally would mean
                // EVERY COMB @rd encoding resolves dst=R0 regardless of what's actually
                // encoded, which cannot be real Z8000 hardware behavior. Implemented with
                // NIB2 instead, matching every sibling and the already-fixed
                // Z4C_0000_0000_addr COMB precedent (same MAME-source-typo category) --
                // flagged in report, not silently guessed past. ====
                else if (din[15:8]==8'h0C && din[7:4]!=4'h0 && din[3:0]==4'h0) begin
                    ea<=R[din[7:4]]; dacop<=3'd0; pc<=pc2; state<=S_DAC_RD;
                end
                // NEGB @rd (0x0C_x_2, NIB3=0010) : MAME Z0C_ddN0_0010, flags CZSV--.
                else if (din[15:8]==8'h0C && din[7:4]!=4'h0 && din[3:0]==4'h2) begin
                    ea<=R[din[7:4]]; dacop<=3'd1; pc<=pc2; state<=S_DAC_RD;
                end
                // CPB @rd,imm8 (0x0C_x_1, NIB3=0001) : MAME Z0C_ddN0_0001_imm8, flags CZSV--.
                else if (din[15:8]==8'h0C && din[7:4]!=4'h0 && din[3:0]==4'h1) begin
                    ea<=R[din[7:4]]; dacop<=3'd5; pc<=pc2; state<=S_DAC_IMM;
                end
                // LDB @rd,imm8 (0x0C_x_5, NIB3=0101) : MAME Z0C_ddN0_0101_imm8, flags ------.
                else if (din[15:8]==8'h0C && din[7:4]!=4'h0 && din[3:0]==4'h5) begin
                    ea<=R[din[7:4]]; dacop<=3'd6; pc<=pc2; state<=S_DAC_IMM;
                end
                // ---- TESTB @rd (0x0C10-0x0CF0, NIB3=4) : MAME Z0C_ddN0_0100 "testb @rd",
                // read-only, flags -ZSP-- (same formula as the register-direct TESTB rbd,
                // 0x8Cd4). Real usage 10. ----
                else if (din[15:8]==8'h0C && din[7:4]!=4'h0 && din[3:0]==4'h4) begin
                    dst<=din[7:4]; pc<=pc2; state<=S_TESTBI_RD;
                end
                // ---- TSETB @rd (0x0C16-0x0CF6, NIB3=6) : MAME Z0C_ddN0_0110 "tsetb @rd",
                // byte RMW (wordacc rule), flags --S---. S = old bit7 (tested off the READ,
                // before the write); new value unconditionally 0xFF. Real usage 5. ----
                else if (din[15:8]==8'h0C && din[7:4]!=4'h0 && din[3:0]==4'h6) begin
                    dst<=din[7:4]; pc<=pc2; state<=S_TSETBI_RD;
                end
                // ---- CLRB @rd (0x0C18-0x0CF8, NIB3=8) : MAME Z0C_ddN0_1000 "clrb @rd",
                // byte RMW (wordacc rule, unconditional 0), flags ------. Real usage 2. ----
                else if (din[15:8]==8'h0C && din[7:4]!=4'h0 && din[3:0]==4'h8) begin
                    dst<=din[7:4]; pc<=pc2; state<=S_CLRBI_RD;
                end
                // ---- COM @rd (0x0D10-0x0DF0, NIB3=0) : MAME Z0D_ddN0_0000 "com @rd", word
                // RMW, flags -ZS--- (same formula as the register-direct COM rd, 0x8Dd0).
                // Real usage 2. ----
                else if (din[15:8]==8'h0D && din[7:4]!=4'h0 && din[3:0]==4'h0) begin
                    dst<=din[7:4]; pc<=pc2; state<=S_COMI_RD;
                end
                // ---- CP @rd,#imm16 (0x0D11-0x0DF1, NIB3=1) : MAME Z0D_ddN0_0001_imm16
                // "cp @rd,imm16", read-only compare, flags CZSV-- (same formula as the
                // existing word CP aluop in S_ALU). Real usage 11. ----
                else if (din[15:8]==8'h0D && din[7:4]!=4'h0 && din[3:0]==4'h1) begin
                    dst<=din[7:4]; pc<=pc2; state<=S_CPRI_IMM;
                end
                // ---- NEG @rd (0x0D12-0x0DF2, NIB3=2) : MAME Z0D_ddN0_0010 "neg @rd", word
                // RMW, flags CZSV-- (same formula as the register-direct NEG rd, 0x8Dd2).
                // Real usage 1. ----
                else if (din[15:8]==8'h0D && din[7:4]!=4'h0 && din[3:0]==4'h2) begin
                    dst<=din[7:4]; pc<=pc2; state<=S_NEGI_RD;
                end
                // ---- TEST @rd (0x0D14-0x0DF4, NIB3=4) : MAME Z0D_ddN0_0100 "test @rd",
                // read-only, flags -ZS--- (same formula as the existing DA_TST direct-address
                // test). Real usage 2. ----
                else if (din[15:8]==8'h0D && din[7:4]!=4'h0 && din[3:0]==4'h4) begin
                    dst<=din[7:4]; pc<=pc2; state<=S_TESTI_RD;
                end
                // ---- TSET @rd (0x0D16-0x0DF6, NIB3=6) : MAME Z0D_ddN0_0110 "tset @rd",
                // word RMW, flags --S---. S = old bit15; new value unconditionally 0xFFFF.
                // Real usage 2. ----
                else if (din[15:8]==8'h0D && din[7:4]!=4'h0 && din[3:0]==4'h6) begin
                    dst<=din[7:4]; pc<=pc2; state<=S_TSETI_RD;
                end
                // ---- CLR @rd (0x0D18-0x0DF8, NIB3=8) : MAME Z0D_ddN0_1000 "clr @rd", plain
                // word write (no read needed), flags ------. Real usage 6. ----
                else if (din[15:8]==8'h0D && din[7:4]!=4'h0 && din[3:0]==4'h8) begin
                    dst<=din[7:4]; pc<=pc2; state<=S_CLRI_WR;
                end
                // ==== BATCH 6: ALU addr[,(rs)] direct/indexed (0x40-0x4B, task item 1) ===
                // ADDB/ADD/SUBB/SUB/ORB/OR/ANDB/AND/XORB/XOR/CPB/CP rbd/rd,addr[,(rs)].
                // dst=NIB3 always (GET_DST(OP0,NIB3), confirmed per z8000ops.hxx for all
                // 12); NIB2=0 -> direct (ea<=addr word), NIB2!=0 -> indexed (idxr<=NIB2,
                // ea<=addr+R[idxr] in the *X_FETCH state, Batch-4 shape). Odd opcode byte
                // (41,43,45,47,49,4B) = word form; even (40,42,44,46,48,4A) = byte form --
                // verified against the table's Z40/Z41-style pairing for every one of the
                // 6 pairs. Dest is ALWAYS a register (RB(dst)/RW(dst)) -- addr is only ever
                // the SOURCE operand, no memory write for any of these 12. ----
                else if (din[15:8]>=8'h40 && din[15:8]<=8'h4B) begin
                    dst<=din[3:0]; pc<=pc2;
                    case (din[15:8])
                        8'h40,8'h41: aluop<=ADD; 8'h42,8'h43: aluop<=SUB;
                        8'h44,8'h45: aluop<=OR;  8'h46,8'h47: aluop<=AND;
                        8'h48,8'h49: aluop<=XOR; default:     aluop<=CP;   // 4A,4B
                    endcase
                    if (din[8]) begin // odd byte1 -> word form
                        if (din[7:4]==4'h0) state<=S_ALUA_FETCH;
                        else begin idxr<=din[7:4]; state<=S_ALUAX_FETCH; end
                    end else begin      // even byte1 -> byte form
                        if (din[7:4]==4'h0) state<=S_ALUAB_FETCH;
                        else begin idxr<=din[7:4]; state<=S_ALUABX_FETCH; end
                    end
                end
                // ==== BATCH 6: CPL rrd,imm32 (0x1000-0x100F, task item 2) ================
                // MAME Z10_0000_dddd_imm32, compare-only long against a 32-bit immediate
                // (imm32={word1(hi),word2(lo)}, same GET_IMM32 convention as the existing
                // LDL RRd,#imm32). Complements the already-implemented CPL @rs (NIB2!=0,
                // a few hundred lines up) -- this is exactly its NIB2==0 counterpart. ----
                else if (din[15:8]==8'h10 && din[7:4]==4'h0) begin
                    dst<=din[3:0]; pc<=pc2; state<=S_CPLI_HI;
                end
                // ==== BATCH 6: register-indirect INCB/INC/DECB/DEC @rd (0x28-0x2B) =======
                // EA=R[dst] directly, no address word to fetch. Byte forms (0x28/0x2A) are
                // word-aligned RMW (wordacc rule, lane=R[dst][0], mirrors S_TSETBI/S_CLRBI);
                // word forms (0x29/0x2B) mirror the already-implemented direct-address word
                // INC/DEC (S_INCDA_RD) one level more direct. aluop(ADD/SUB) + mcnt(imm4m1
                // nibble) reused exactly as the direct-address family already does. ----
                else if (din[15:8]==8'h28 && din[7:4]!=4'h0) begin
                    dst<=din[7:4]; mcnt<=din[3:0]; aluop<=ADD; pc<=pc2; state<=S_INCBI_RD;
                end
                else if (din[15:8]==8'h29 && din[7:4]!=4'h0) begin
                    dst<=din[7:4]; mcnt<=din[3:0]; aluop<=ADD; pc<=pc2; state<=S_INCWI_RD;
                end
                else if (din[15:8]==8'h2A && din[7:4]!=4'h0) begin
                    dst<=din[7:4]; mcnt<=din[3:0]; aluop<=SUB; pc<=pc2; state<=S_INCBI_RD;
                end
                else if (din[15:8]==8'h2B && din[7:4]!=4'h0) begin
                    dst<=din[7:4]; mcnt<=din[3:0]; aluop<=SUB; pc<=pc2; state<=S_INCWI_RD;
                end
                // ==== BATCH 6: byte INC/DEC addr[,(rs)],#n (0x68/0x6A) ===================
                // Byte siblings of the already-implemented word INC/DEC direct/indexed
                // (0x69/0x6B) -- identical FETCH shape (direct: ea<=addr; indexed: idxr<=
                // NIB2, ea<=addr+R[idxr] in the *X_FETCH state), byte-lane RMW merge in RD
                // (ea[0] lane, same convention as S_LDBSTA/S_RESETB). ----
                else if (din[15:8]==8'h68 && din[7:4]==4'h0) begin
                    mcnt<=din[3:0]; aluop<=ADD; pc<=pc2; state<=S_INCDAB_FETCH;
                end
                else if (din[15:8]==8'h68 && din[7:4]!=4'h0) begin
                    mcnt<=din[3:0]; aluop<=ADD; idxr<=din[7:4]; pc<=pc2; state<=S_INCDABX_FETCH;
                end
                else if (din[15:8]==8'h6A && din[7:4]==4'h0) begin
                    mcnt<=din[3:0]; aluop<=SUB; pc<=pc2; state<=S_INCDAB_FETCH;
                end
                else if (din[15:8]==8'h6A && din[7:4]!=4'h0) begin
                    mcnt<=din[3:0]; aluop<=SUB; idxr<=din[7:4]; pc<=pc2; state<=S_INCDABX_FETCH;
                end
                // ==== BATCH 6: missing indexed arms for LD rd,addr(rs) / LD addr(rs),rs ==
                // (0x61/0x6F, NIB2!=0) -- the direct forms (NIB2==0) were already done;
                // this closes the indexed side using the EXISTING, unmodified S_DA_RD/
                // S_DA_WR tail (daop already selects LDR/STR), Batch-4 X_FETCH shape. ----
                else if (din[15:8]==8'h61 && din[7:4]!=4'h0) begin
                    dst<=din[3:0]; daop<=DA_LDR; idxr<=din[7:4]; pc<=pc2; state<=S_LDAX_FETCH;
                end
                else if (din[15:8]==8'h6F && din[7:4]!=4'h0) begin
                    src<=din[3:0]; daop<=DA_STR; idxr<=din[7:4]; pc<=pc2; state<=S_LDSAX_FETCH;
                end
                // ==== BATCH 6: register-only closures (zero new states) ===================
                // ---- COMB rbd (0x8Cd0) : MAME Z8C_dddd_0000, flags -ZSP-- (CHK_XXXB_ZSP,
                // same parity convention as the already-implemented byte AND/OR/XOR/TESTB
                // -- verified against the macro body, NOT assumed -ZS--- from the mnemonic
                // name alone). ----
                else if (din[15:8]==8'h8C && din[3:0]==4'h0) begin
                    dbyte = din[7] ? R[din[6:4]][7:0] : R[din[6:4]][15:8];
                    res8 = ~dbyte; p=(~^res8);
                    rwb0_we=1'b1; rwb0_idx={1'b0,din[6:4]}; rwb0_val={2{res8}}; rwb0_be=din[7]?2'b01:2'b10;
                    fcw<=(fcw & ~(MZ|MS|MV)) | ((res8==8'h00)?MZ:0)|(res8[7]?MS:0)|(p?MV:0);
                    pc<=pc2; retire<=1'b1;
                end
                // ---- NEGB rbd (0x8Cd2) : MAME Z8C_dddd_0010, flags CZSV-- (same formula
                // as the already-implemented word NEG rd, 0x8Dd2, one level narrower). ----
                else if (din[15:8]==8'h8C && din[3:0]==4'h2) begin
                    dbyte = din[7] ? R[din[6:4]][7:0] : R[din[6:4]][15:8];
                    res8 = 8'h00 - dbyte; v=(res8==8'h80);
                    rwb0_we=1'b1; rwb0_idx={1'b0,din[6:4]}; rwb0_val={2{res8}}; rwb0_be=din[7]?2'b01:2'b10;
                    fcw<=(fcw & ~(MC|MZ|MS|MV)) | ((res8!=8'h00)?MC:0)|((res8==8'h00)?MZ:0)|(res8[7]?MS:0)|(v?MV:0);
                    pc<=pc2; retire<=1'b1;
                end
                // ---- TSETB rbd (0x8Cd6) : MAME Z8C_dddd_0110, flags --S--- (S=old bit7,
                // unconditional 0xFF -- same formula as the already-implemented register-
                // INDIRECT TSETB @rd, S_TSETBI_RD, one level more direct: no memory access
                // at all). ----
                else if (din[15:8]==8'h8C && din[3:0]==4'h6) begin
                    dbyte = din[7] ? R[din[6:4]][7:0] : R[din[6:4]][15:8];
                    fcw<=(fcw & ~MS) | (dbyte[7]?MS:0);
                    rwb0_we=1'b1; rwb0_idx={1'b0,din[6:4]}; rwb0_val=16'hFFFF; rwb0_be=din[7]?2'b01:2'b10;
                    pc<=pc2; retire<=1'b1;
                end
                // ---- LDCTLB rbd,flags (0x8Cd1) : MAME Z8C_dddd_0001 "ldctlb rbd,flags" --
                // reads the CURRENT flag byte (FCW bits[7:2] = C/Z/S/V/D/H, exactly this
                // file's MC/MZ/MS/MV/MDA/MH bit positions) into rbd. The doc-comment's
                // "flags CZSVDH" describes which bits get READ, not new flags computed --
                // fcw itself is untouched by this arm. ----
                else if (din[15:8]==8'h8C && din[3:0]==4'h1) begin
                    rwb0_we=1'b1; rwb0_idx={1'b0,din[6:4]}; rwb0_val={2{(fcw[7:0] & 8'hFC)}}; rwb0_be=din[7]?2'b01:2'b10;
                    pc<=pc2; retire<=1'b1;
                end
                // ---- LDCTLB flags,rbd (0x8Cd9) : MAME Z8C_dddd_1001 "ldctlb flags,rbd" --
                // writes rbd's value into FCW bits[7:2], mirror of the read form above. ----
                else if (din[15:8]==8'h8C && din[3:0]==4'h9) begin
                    dbyte = din[7] ? R[din[6:4]][7:0] : R[din[6:4]][15:8];
                    fcw<=(fcw & ~16'h00FC) | {8'h00, (dbyte & 8'hFC)};
                    pc<=pc2; retire<=1'b1;
                end
                // ---- NOP (0x8D07 EXACT) : MAME Z8D_0000_0111 "nop" -- single exact
                // opcode (not a NIB-varying family like its 0x8D siblings), no effect. ----
                else if (din==16'h8D07) begin
                    pc<=pc2; retire<=1'b1;
                end
                // ---- TEST rd (0x8Dd4) : MAME Z8D_dddd_0100 "test rd", flags -ZS--- (same
                // TESTW formula as the existing direct-address TEST, DA_TST). ----
                else if (din[15:8]==8'h8D && din[3:0]==4'h4) begin
                    fcw<=(fcw & ~(MZ|MS)) | ((R[din[7:4]]==16'h0000)?MZ:0)|(R[din[7:4]][15]?MS:0);
                    pc<=pc2; retire<=1'b1;
                end
                // ---- TSET rd (0x8Dd6) : MAME Z8D_dddd_0110 "tset rd", flags --S--- (S=old
                // bit15, unconditional 0xFFFF -- same formula as the already-implemented
                // register-INDIRECT TSET @rd, S_TSETI_RD). NOTE: this register-DIRECT form
                // was explicitly, deliberately skipped in Batch 4 citing "zero real ROM
                // occurrences" for THAT batch's narrower scope -- this task's mandate is
                // the stronger "close the whole decode, no valid encoding may trap," which
                // supersedes that prioritization call, not a re-litigation of it (see
                // report). ----
                else if (din[15:8]==8'h8D && din[3:0]==4'h6) begin
                    fcw<=(fcw & ~MS) | (R[din[7:4]][15]?MS:0);
                    rwb0_we=1'b1; rwb0_idx=din[7:4]; rwb0_val=16'hFFFF;
                    pc<=pc2; retire<=1'b1;
                end
                // ---- SETFLG/RESFLG/COMFLG imm4 (0x8D_imm4_0001/0011/0101, NIB0=1/3/5) :
                // MAME Z8D_imm4_0001/0011/0101 -- set/clear/toggle FCW bits[7:4] (C/Z/S/V)
                // directly from the OPCODE WORD's own bits[7:4] (m_fcw|=/&=~/^= m_op[0]&
                // 0x00f0), no register/memory operand at all. fcw's own bit layout already
                // IS C=b7 Z=b6 S=b5 V=b4, so `din&16'h00F0` lines up with zero shifting. ----
                else if (din[15:8]==8'h8D && din[3:0]==4'h1) begin
                    fcw<=fcw | (din & 16'h00F0); pc<=pc2; retire<=1'b1;
                end
                else if (din[15:8]==8'h8D && din[3:0]==4'h3) begin
                    fcw<=fcw & ~(din & 16'h00F0); pc<=pc2; retire<=1'b1;
                end
                else if (din[15:8]==8'h8D && din[3:0]==4'h5) begin
                    fcw<=fcw ^ (din & 16'h00F0); pc<=pc2; retire<=1'b1;
                end
                // ---- TESTL rrd (0x9C00-0x9CF8, NIB3={0,8} only per z8000tbl.hxx's step=8
                // table row -- the handler body ignores NIB3 entirely, GET_DST uses NIB2)
                // : MAME Z9C_dddd_1000 "testl rrd", flags -ZS--- (32-bit long test,
                // register-only; pair-select = {dst[3:1],1'b0}, the file's established
                // bit0-truncation convention). ----
                else if (din[15:8]==8'h9C && (din[3:0]==4'h0 || din[3:0]==4'h8)) begin
                    fcw<=(fcw & ~(MZ|MS))
                       | (({R[{din[7:5],1'b0}],R[{din[7:5],1'b0}+4'd1]}==32'h00000000)?MZ:0)
                       | (R[{din[7:5],1'b0}][15]?MS:0);
                    pc<=pc2; retire<=1'b1;
                end
                // ---- RESB/RES/SETB/SET/BITB/BIT rd,imm4 register-DIRECT forms (0xA2-
                // 0xA7, full range each) : MAME ZA2-ZA7_dddd_imm4 -- register-only bit-ops
                // (no memory access at all), distinct from the already-implemented
                // memory-form @Rd,#imm4 family (0x22-0x27) and direct-address(+index) form
                // (0x62-0x67). Reuses the same bmask-shift shape; BIT/BITB flags -Z----
                // (Z=1 means tested bit is 0, matching the existing memory-form convention);
                // RES/SET/RESB/SETB flags ------. ----
                else if (din[15:8]==8'hA2) begin // RESB rbd,imm4
                    dbyte = din[7] ? R[din[6:4]][7:0] : R[din[6:4]][15:8];
                    res8 = dbyte & ~(8'h01<<din[3:0]);
                    rwb0_we=1'b1; rwb0_idx={1'b0,din[6:4]}; rwb0_val={2{res8}}; rwb0_be=din[7]?2'b01:2'b10;
                    pc<=pc2; retire<=1'b1;
                end
                else if (din[15:8]==8'hA3) begin // RES rd,imm4
                    rwb0_we=1'b1; rwb0_idx=din[7:4]; rwb0_val=R[din[7:4]] & ~(16'h0001<<din[3:0]);
                    pc<=pc2; retire<=1'b1;
                end
                else if (din[15:8]==8'hA4) begin // SETB rbd,imm4
                    dbyte = din[7] ? R[din[6:4]][7:0] : R[din[6:4]][15:8];
                    res8 = dbyte | (8'h01<<din[3:0]);
                    rwb0_we=1'b1; rwb0_idx={1'b0,din[6:4]}; rwb0_val={2{res8}}; rwb0_be=din[7]?2'b01:2'b10;
                    pc<=pc2; retire<=1'b1;
                end
                else if (din[15:8]==8'hA5) begin // SET rd,imm4
                    rwb0_we=1'b1; rwb0_idx=din[7:4]; rwb0_val=R[din[7:4]] | (16'h0001<<din[3:0]);
                    pc<=pc2; retire<=1'b1;
                end
                else if (din[15:8]==8'hA6) begin // BITB rbd,imm4
                    dbyte = din[7] ? R[din[6:4]][7:0] : R[din[6:4]][15:8];
                    fcw<=(fcw & ~MZ) | (((dbyte & (8'h01<<din[3:0]))==8'h00) ? MZ : 16'h0000);
                    pc<=pc2; retire<=1'b1;
                end
                else if (din[15:8]==8'hA7) begin // BIT rd,imm4
                    fcw<=(fcw & ~MZ) | (((R[din[7:4]] & (16'h0001<<din[3:0]))==16'h0000) ? MZ : 16'h0000);
                    pc<=pc2; retire<=1'b1;
                end
                // ---- TCCB cc,rbd / TCC cc,rd (0xAE/0xAF, full range) : MAME ZAE/ZAF_
                // dddd_cccc "tccb/tcc cc,rbd/rd", flags ------ -- bit0 UNCONDITIONALLY
                // replaced by cc_true(cc) (not OR'd -- MAME clears bit0 first, then
                // conditionally sets it, net effect = direct assignment). Reuses the
                // existing cc_true() function unchanged (same cc encoding as JR/RET/JP cc). ----
                else if (din[15:8]==8'hAE) begin
                    dbyte = din[7] ? R[din[6:4]][7:0] : R[din[6:4]][15:8];
                    res8 = {dbyte[7:1], cc_true(din[3:0],fcw[FC],fcw[FZ],fcw[FS],fcw[FV])};
                    rwb0_we=1'b1; rwb0_idx={1'b0,din[6:4]}; rwb0_val={2{res8}}; rwb0_be=din[7]?2'b01:2'b10;
                    pc<=pc2; retire<=1'b1;
                end
                else if (din[15:8]==8'hAF) begin
                    rwb0_we=1'b1; rwb0_idx=din[7:4]; rwb0_val={R[din[7:4]][15:1], cc_true(din[3:0],fcw[FC],fcw[FZ],fcw[FS],fcw[FV])};
                    pc<=pc2; retire<=1'b1;
                end
                // ---- LDK rd,imm4 (0xBD, full range) : MAME ZBD_dddd_imm4 "ldk rd,imm4",
                // flags ------ -- zero-extended 4-bit immediate load, cheapest possible
                // instruction (no memory access, no flags, single word). ----
                else if (din[15:8]==8'hBD) begin
                    rwb0_we=1'b1; rwb0_idx=din[7:4]; rwb0_val={12'h000, din[3:0]};
                    pc<=pc2; retire<=1'b1;
                end
                // ---- RLDB rba,rbb (0xBC, full range) : MAME ZBC_aaaa_bbbb "rldb rba,rbb"
                // -- a=NIB2,b=NIB3 (both plain byte-reg-codes, NOT gated non-zero). Traced
                // term-by-term through the ACTUAL C body (not the "rotate" mnemonic's
                // naive 3-nibble-cycle implication): new_a={old_b_lo,old_a_hi}; new_b=
                // old_b UNCHANGED (tmp=old_b captured before any write, then RB(b)=
                // (RB(b)&0xf0)|(tmp&0x0f) algebraically reduces to old_b itself) -- verified
                // by hand, not assumed from the name. Flags -Z---- (Z from the new/
                // unchanged b value). ----
                else if (din[15:8]==8'hBC) begin
                    dbyte     = din[7] ? R[din[6:4]][7:0] : R[din[6:4]][15:8];  // old a
                    operand_b = din[3] ? R[din[2:0]][7:0] : R[din[2:0]][15:8];  // old b (=tmp)
                    res8 = {operand_b[3:0], dbyte[7:4]};                        // new a
                    rwb0_we=1'b1; rwb0_idx={1'b0,din[6:4]}; rwb0_val={2{res8}}; rwb0_be=din[7]?2'b01:2'b10;
                    rwb1_we=1'b1; rwb1_idx={1'b0,din[2:0]}; rwb1_val={2{operand_b}}; rwb1_be=din[3]?2'b01:2'b10; // new b = old b
                    fcw<=(fcw & ~MZ) | ((operand_b==8'h00)?MZ:0);
                    pc<=pc2; retire<=1'b1;
                end
                // ---- RRDB rba,rbb (0xBE, full range) : MAME ZBE_aaaa_bbbb "rrdb rba,rbb"
                // -- same term-by-term trace discipline as RLDB above. tmp=old_a (captured
                // FIRST here, the opposite operand from RLDB's tmp -- not a copy-paste
                // error, verified against the actual body): new_a={old_a_lo,old_b_lo};
                // new_b={old_b_hi,old_a_hi}. Both registers genuinely change here (unlike
                // RLDB). Flags -Z---- (Z from the new b value). ----
                else if (din[15:8]==8'hBE) begin
                    dbyte     = din[7] ? R[din[6:4]][7:0] : R[din[6:4]][15:8];  // old a (=tmp)
                    operand_b = din[3] ? R[din[2:0]][7:0] : R[din[2:0]][15:8];  // old b
                    res8 = {dbyte[3:0], operand_b[3:0]};                        // new a
                    rwb0_we=1'b1; rwb0_idx={1'b0,din[6:4]}; rwb0_val={2{res8}}; rwb0_be=din[7]?2'b01:2'b10;
                    res8 = {operand_b[7:4], dbyte[7:4]};                        // new b
                    rwb1_we=1'b1; rwb1_idx={1'b0,din[2:0]}; rwb1_val={2{res8}}; rwb1_be=din[3]?2'b01:2'b10;
                    fcw<=(fcw & ~MZ) | ((res8==8'h00)?MZ:0);
                    pc<=pc2; retire<=1'b1;
                end
                // ---- EXTSL rqd (0xB1d7, NIB0=7) : MAME ZB1_dddd_0111 "extsl rqd", flags
                // ------ -- sign-extends the LOW 32 bits of the quad (R[qbase+2]:
                // R[qbase+3]) into the HIGH 32 bits (R[qbase]:R[qbase+1]), one level wider
                // than the already-implemented EXTS (16->32) at 0xB1dA, same RQ(n)
                // low-two-bits-truncation derivation (header comment). ----
                else if (din[15:8]==8'hB1 && din[3:0]==4'h7) begin
                    qbase = {din[7:6],2'b00};
                    rwb0_we=1'b1; rwb0_idx=qbase;      rwb0_val={16{R[qbase+4'd2][15]}};
                    rwb1_we=1'b1; rwb1_idx=qbase+4'd1; rwb1_val={16{R[qbase+4'd2][15]}};
                    pc<=pc2; retire<=1'b1;
                end
                // ---- LDB rd,imm8 short form (0xC000-0xCFFF, full range) : MAME
                // ZC_dddd_imm8 "ldb rbd,imm8" -- dst=NIB1(din[11:8], byte-reg-code),
                // imm8=din[7:0] (the SAME opcode word's low byte -- single-word
                // instruction, no second-word fetch at all). flags ------. ----
                else if (din[15:12]==4'hC) begin
                    rwb0_we=1'b1; rwb0_idx={1'b0,din[10:8]}; rwb0_val={2{din[7:0]}}; rwb0_be=din[11]?2'b01:2'b10;
                    pc<=pc2; retire<=1'b1;
                end
                // ---- catch-all trap. INTENTIONALLY-UNIMPLEMENTED families land here (see
                //   scope decision 2026-07-18: "close reachable gaps only"). All are UNREACHABLE
                //   by the Pole Position sub ROMs (co-sim runs both to completion, 0 illegal):
                //     0x30-0x37  load-relative / base+displacement (LDR/LDRB/LDRL, LDB base+disp)
                //     0x38-0x3F  I/O + block I/O (IN/OUT/SIN/SOUT/INIR/OTIR...) - no I/O device
                //                on the sub-CPUs (the sc/in/out disasm hits are inside the
                //                0x38A0-0x3E08 ASCII data-table, misdecoded - confirmed false)
                //   (full detail + the NON-OPCODE gaps are in the file-header manifest)
                //     0x70-0x77  base+index loads, LDA/LDAR
                //     0x79/7A/7B(partial)/7E/7F  LDPS/HALT/MSET.../SC - system, unused
                //     0xB8/BA/BB block-transfer/compare/translate strings (LDIR/CPIR/TRIB...)
                //     0x0E/0F/4E/8E/8F  EPU extended instructions - no EPU present
                //   Trapping (not silently ignoring) matches MAME's zinvalid for anything the
                //   real hardware wouldn't decode. Implement a family here only if a ROM path
                //   is ever shown to reach it.
                else begin illegal<=1'b1; state<=S_ILLEGAL; end
              end
              end // BATCH 9: closes the cyc_count>=target_cycles dispatch-ready branch
            end

            // fetch 2nd word as immediate operand
            S_IMM:   begin operand<=din; pc<=pc+16'd2; state<=S_ALU; end
            // read word operand from @rs
            S_MEMRD: begin operand<=din; state<=S_ALU; end

            // ---- shared word ALU ----
            S_ALU: begin
                a16=R[dst]; sum17={1'b0,a16}+{1'b0,operand}; dif17={1'b0,a16}-{1'b0,operand};
                wb=1'b1; res16=operand; fmask=16'h0000; fval=16'h0000;
                case (aluop)
                    LD:  begin res16=operand; end
                    ADD: begin res16=sum17[15:0];
                         c=sum17[16]; z=(res16==0); s=res16[15];
                         v=(~a16[15]&~operand[15]&res16[15])|(a16[15]&operand[15]&~res16[15]);
                         fmask=MC|MZ|MS|MV; fval=(c?MC:0)|(z?MZ:0)|(s?MS:0)|(v?MV:0); end
                    SUB, CP: begin res16=dif17[15:0];
                         c=dif17[16]; z=(res16==0); s=res16[15];
                         v=(~operand[15]&a16[15]&~res16[15])|(operand[15]&~a16[15]&res16[15]);
                         fmask=MC|MZ|MS|MV; fval=(c?MC:0)|(z?MZ:0)|(s?MS:0)|(v?MV:0);
                         if (aluop==CP) wb=1'b0; end
                    AND: begin res16=a16&operand; z=(res16==0); s=res16[15];
                         fmask=MZ|MS; fval=(z?MZ:0)|(s?MS:0); end
                    OR:  begin res16=a16|operand; z=(res16==0); s=res16[15];
                         fmask=MZ|MS; fval=(z?MZ:0)|(s?MS:0); end
                    default: begin res16=a16^operand; z=(res16==0); s=res16[15];  // XOR
                         fmask=MZ|MS; fval=(z?MZ:0)|(s?MS:0); end
                endcase
                if (wb) begin rwb0_we=1'b1; rwb0_idx=dst; rwb0_val=res16; end
                fcw<=(fcw & ~fmask) | fval;
                retire<=1'b1; state<=S_FETCH0;
            end

            // store handled combinationally via addr/dout/we
            S_MEMWR: begin retire<=1'b1; state<=S_FETCH0; end

            // ---- direct addressing ----
            S_DA_FETCH: begin
                ea<=din; pc<=pc+16'd2;
                case (daop)
                    DA_LDR, DA_TST: state<=S_DA_RD;
                    DA_STI, DA_CPI: state<=S_DA_IMM;
                    default:        state<=S_DA_WR;   // DA_STR, DA_CLR
                endcase
            end
            S_DA_IMM: begin
                operand<=din; pc<=pc+16'd2;
                state<=(daop==DA_CPI) ? S_DA_RD : S_DA_WR;
            end
            S_DA_RD:  begin
                if (daop==DA_LDR) begin rwb0_we=1'b1; rwb0_idx=dst; rwb0_val=din; end
                else if (daop==DA_CPI) begin
                    dif17={1'b0,din}-{1'b0,operand};
                    c=dif17[16]; z=(dif17[15:0]==0); s=dif17[15];
                    v=(~operand[15]&din[15]&~dif17[15])|(operand[15]&~din[15]&dif17[15]);
                    fcw<=(fcw & ~(MC|MZ|MS|MV)) | (c?MC:0)|(z?MZ:0)|(s?MS:0)|(v?MV:0);
                end
                else fcw<=(fcw & ~(MZ|MS)) | ((din==0)?MZ:0) | (din[15]?MS:0);  // TEST
                retire<=1'b1; state<=S_FETCH0;
            end
            S_DA_WR:  begin retire<=1'b1; state<=S_FETCH0; end

            // ==== BATCH 8: indexed sibling of S_DA_FETCH/S_DA_IMM -- ea=addr+R[idxr] instead
            // of ea=addr, then joins the EXISTING S_DA_RD/S_DA_WR tail unchanged (same pattern
            // as S_LDAX_FETCH/S_LDSAX_FETCH already do for the 0x61/0x6F family). ====
            S_DAX_FETCH: begin
                ea<=din+R[idxr]; pc<=pc+16'd2;
                case (daop)
                    DA_TST:        state<=S_DA_RD;
                    // BATCH 10 fix: DA_CLR was falling into `default`->S_DAX_IMM, which
                    // would have misread the FOLLOWING instruction word as a bogus imm16
                    // operand and corrupted PC -- a latent bug that was unreachable until
                    // this batch's decode fix above made indexed CLR (0x4D_ddN0_1000)
                    // reachable at all. CLR needs no read/immediate: write 0 straight away,
                    // same as the direct form's S_DA_FETCH `default` (DA_STR, DA_CLR).
                    DA_CLR:        state<=S_DA_WR;
                    default:       state<=S_DAX_IMM;  // DA_STI, DA_CPI (both need imm16 next)
                endcase
            end
            S_DAX_IMM: begin
                operand<=din; pc<=pc+16'd2;
                state<=(daop==DA_STI) ? S_DA_WR : S_DA_RD;  // STI writes; CPI reads mem next
            end

            // ==== BATCH 10: direct-address(+index) word static-op family, 0x4D COM/NEG/
            // TSET (dadop 0/1/2) -- flag formulas transcribed verbatim from the already-
            // verified register-indirect S_COMI_RD/S_NEGI_RD/S_TSETI_RD (Batch 5 Part 2),
            // just reading @ea instead of @R[dst]. ====
            S_DAD_FETCH:  begin ea<=din;         pc<=pc+16'd2; state<=S_DAD_RD; end
            S_DAD_FETCHX: begin ea<=din+R[idxr]; pc<=pc+16'd2; state<=S_DAD_RD; end
            S_DAD_RD: begin // addr=ea (word read)
                case (dadop)
                    2'd0: begin // COM: flags -ZS--- (no V, matches word COM/S_COMI_RD)
                        res16 = ~din;
                        fcw<=(fcw & ~(MZ|MS)) | ((res16==16'h0000)?MZ:0)|(res16[15]?MS:0);
                        operand<=res16;
                    end
                    2'd1: begin // NEG: flags CZSV--
                        res16 = 16'h0000 - din;
                        v=(res16==16'h8000);
                        fcw<=(fcw & ~(MC|MZ|MS|MV))
                           | ((res16!=16'h0000)?MC:0)|((res16==16'h0000)?MZ:0)|(res16[15]?MS:0)|(v?MV:0);
                        operand<=res16;
                    end
                    default: begin // 2'd2 TSET: flags --S---, S=old bit15, new=0xFFFF unconditional
                        fcw<=(fcw & ~MS) | (din[15]?MS:0);
                        operand<=16'hFFFF;
                    end
                endcase
                state<=S_DAD_WR;
            end
            S_DAD_WR: begin retire<=1'b1; state<=S_FETCH0; end // addr=ea,dout=operand,we=1

            // ==== BATCH 10: direct-address(+index) byte static-op family, 0x4C COMB/CPB/
            // NEGB/TESTB/LDB/TSETB/CLRB (dacop 0/5/1/2/6/3/4) -- word-aligned RMW (wordacc
            // rule, lane=ea[0]), mirrors the already-verified register-indirect S_TESTBI/
            // S_TSETBI/S_CLRBI/byte-S_ALUB-CP formulas. RD is the RMW path (COMB/NEGB/
            // TSETB/CLRB/LDB, all need the full word for the merge-write); RDRO is the
            // read-only path (TESTB/CPB, discard the other byte lane -- excluded from
            // `wordacc` below like every other read-only byte state in this file). ====
            S_DAC_FETCH: begin
                ea<=din; pc<=pc+16'd2;
                case (dacop)
                    3'd5, 3'd6: state<=S_DAC_IMM;   // CPB, LDB need imm8 next
                    3'd2:       state<=S_DAC_RDRO;  // TESTB: read-only
                    default:    state<=S_DAC_RD;    // COMB, NEGB, TSETB, CLRB: RMW
                endcase
            end
            S_DAC_FETCHX: begin
                ea<=din+R[idxr]; pc<=pc+16'd2;
                case (dacop)
                    3'd5, 3'd6: state<=S_DAC_IMM;
                    3'd2:       state<=S_DAC_RDRO;
                    default:    state<=S_DAC_RD;
                endcase
            end
            S_DAC_IMM: begin // imm8 = low byte of ext word (same convention as S_IMMB)
                operand[7:0]<=din[7:0]; pc<=pc+16'd2;
                state<=(dacop==3'd6) ? S_DAC_RD : S_DAC_RDRO; // LDB writes; CPB read-only
            end
            S_DAC_RD: begin // addr=ea&~1 (RMW path)
                dbyte = ea[0] ? din[7:0] : din[15:8];
                case (dacop)
                    3'd0: begin // COMB: flags -ZSP--
                        res8=~dbyte; p=(~^res8);
                        fcw<=(fcw & ~(MZ|MS|MV)) | ((res8==8'h00)?MZ:0)|(res8[7]?MS:0)|(p?MV:0);
                        dacres<=res8;
                    end
                    3'd1: begin // NEGB: flags CZSV--
                        res8=8'h00-dbyte; v=(res8==8'h80);
                        fcw<=(fcw & ~(MC|MZ|MS|MV)) | ((res8!=8'h00)?MC:0)|((res8==8'h00)?MZ:0)|(res8[7]?MS:0)|(v?MV:0);
                        dacres<=res8;
                    end
                    3'd3: begin // TSETB: flags --S---, S=old bit7, new=0xFF unconditional
                        fcw<=(fcw & ~MS) | (dbyte[7]?MS:0);
                        dacres<=8'hFF;
                    end
                    3'd6: begin // LDB addr,imm8: flags ------, write staged imm8
                        dacres<=operand[7:0];
                    end
                    default: begin // 3'd4 CLRB: flags ------, unconditional 0
                        dacres<=8'h00;
                    end
                endcase
                operand<=din;
                state<=S_DAC_WR;
            end
            S_DAC_RDRO: begin // addr=ea&~1 (read-only path: TESTB/CPB)
                dbyte = ea[0] ? din[7:0] : din[15:8];
                if (dacop==3'd5) begin // CPB addr,imm8: flags CZSV--
                    incb_sum = {1'b0,dbyte} - {1'b0,operand[7:0]};
                    v=(~operand[7]&dbyte[7]&~incb_sum[7])|(operand[7]&~dbyte[7]&incb_sum[7]);
                    fcw<=(fcw & ~(MC|MZ|MS|MV))
                       | (incb_sum[8]?MC:0)|((incb_sum[7:0]==0)?MZ:0)|(incb_sum[7]?MS:0)|(v?MV:0);
                end else begin // TESTB: flags -ZSP--
                    p=(~^dbyte);
                    fcw<=(fcw & ~(MZ|MS|MV)) | ((dbyte==8'h00)?MZ:0)|(dbyte[7]?MS:0)|(p?MV:0);
                end
                retire<=1'b1; state<=S_FETCH0;
            end
            S_DAC_WR: begin retire<=1'b1; state<=S_FETCH0; end // addr=ea&~1,dout=merged(dacres@ea[0]),we=1

            // ---- SLL(+)/SRL(-) rd,#imm16 (flags CZS) ----
            S_SHIFT: begin
                a16=R[dst]; scnt = din[15] ? (16'h0000 - din) : din; cnt=scnt[4:0];
                if (din[15]) begin
                    res16 = a16 >> cnt;
                    cbit  = (cnt!=0) ? ((a16 >> (cnt-1)) & 16'h1) : 1'b0;
                end else begin
                    res16 = a16 << cnt;
                    cbit  = (cnt!=0) ? (((a16 << (cnt-1)) & 16'h8000)!=0) : 1'b0;
                end
                z=(res16==0); s=res16[15];
                rwb0_we=1'b1; rwb0_idx=dst; rwb0_val=res16;
                fcw<=(fcw & ~(MC|MZ|MS)) | (cbit?MC:0)|(z?MZ:0)|(s?MS:0);
                pc<=pc+16'd2; retire<=1'b1; state<=S_FETCH0;
            end

            // ==== BATCH 7 2026-07-27: SLA/SRA rd,#imm (word, flags CZSV) ==================
            // Left branch is bit-identical to S_SHIFT's left branch (arithmetic and logical
            // left shift produce the same result bits -- only the flags differ); right
            // branch sign-extends instead of zero-filling. V: left sets it on a sign change
            // (MAME `if((result^dest)&S16)SET_V`); right NEVER sets it -- SRAW's actual body
            // has no SET_V call at all despite the "flags CZSV--" doc-comment, verified
            // against the macro body, not assumed from the mnemonic. ----
            S_SHIFTA: begin
                a16=R[dst]; scnt = din[15] ? (16'h0000 - din) : din; cnt=scnt[4:0];
                if (din[15]) begin // right, arithmetic (sign-extend)
                    res16 = $signed(a16) >>> cnt;
                    cbit  = (cnt!=0) ? (($signed(a16) >>> (cnt-1)) & 16'h1) : 1'b0;
                    v     = 1'b0;
                end else begin // left
                    res16 = a16 << cnt;
                    cbit  = (cnt!=0) ? (((a16 << (cnt-1)) & 16'h8000)!=0) : 1'b0;
                    v     = (res16[15]!=a16[15]);
                end
                z=(res16==0); s=res16[15];
                rwb0_we=1'b1; rwb0_idx=dst; rwb0_val=res16;
                fcw<=(fcw & ~(MC|MZ|MS|MV)) | (cbit?MC:0)|(z?MZ:0)|(s?MS:0)|(v?MV:0);
                pc<=pc+16'd2; retire<=1'b1; state<=S_FETCH0;
            end

            S_SHIFTAL: begin
                a32 = {R[{dst[3:1],1'b0}], R[{dst[3:1],1'b0}+4'd1]};
                scnt = din[15] ? (16'h0000 - din) : din; cnt=scnt[4:0];
                if (din[15]) begin // right, arithmetic (sign-extend)
                    res32 = $signed(a32) >>> cnt;
                    cbit  = (cnt!=0) ? (($signed(a32) >>> (cnt-1)) & 32'h1) : 1'b0;
                    v     = 1'b0;
                end else begin // left
                    res32 = a32 << cnt;
                    cbit  = (cnt!=0) ? (((a32 << (cnt-1)) & 32'h80000000)!=0) : 1'b0;
                    v     = (res32[31]!=a32[31]);
                end
                z=(res32==0); s=res32[31];
                rwb0_we=1'b1; rwb0_idx={dst[3:1],1'b0};      rwb0_val=res32[31:16];
                rwb1_we=1'b1; rwb1_idx={dst[3:1],1'b0}+4'd1; rwb1_val=res32[15:0];
                fcw<=(fcw & ~(MC|MZ|MS|MV)) | (cbit?MC:0)|(z?MZ:0)|(s?MS:0)|(v?MV:0);
                pc<=pc+16'd2; retire<=1'b1; state<=S_FETCH0;
            end

            S_SHIFTL: begin
                a32 = {R[{dst[3:1],1'b0}], R[{dst[3:1],1'b0}+4'd1]};
                scnt = din[15] ? (16'h0000 - din) : din; cnt=scnt[4:0];
                if (din[15]) begin
                    res32 = a32 >> cnt;
                    cbit  = (cnt!=0) ? ((a32 >> (cnt-1)) & 32'h1) : 1'b0;
                end else begin
                    res32 = a32 << cnt;
                    cbit  = (cnt!=0) ? (((a32 << (cnt-1)) & 32'h80000000)!=0) : 1'b0;
                end
                z=(res32==0); s=res32[31];
                rwb0_we=1'b1; rwb0_idx={dst[3:1],1'b0};      rwb0_val=res32[31:16];
                rwb1_we=1'b1; rwb1_idx={dst[3:1],1'b0}+4'd1; rwb1_val=res32[15:0];
                fcw<=(fcw & ~(MC|MZ|MS)) | (cbit?MC:0)|(z?MZ:0)|(s?MS:0);
                pc<=pc+16'd2; retire<=1'b1; state<=S_FETCH0;
            end

            // ==== BATCH 7 2026-07-27: LDA prd,addr[(rs)] -- flags: ------ (untouched) ====
            // Non-segmented (Z8002) mode only: RW(dst) = addr [+ R[src]]. No memory access
            // at all -- `addr` is a raw absolute 16-bit operand word (MAME GET_ADDR_RAW, no
            // PC-relative resolution needed off-segment), NOT a pointer to dereference. ----
            S_LDA76_FETCH: begin operand<=din; pc<=pc+16'd2; state<=S_LDA76_GO; end
            S_LDA76_GO: begin
                rwb0_we=1'b1; rwb0_idx=dst; rwb0_val=operand + (lda76_has_src ? R[src] : 16'h0000);
                retire<=1'b1; state<=S_FETCH0;
            end

            // ==== BATCH 12: 0x30-0x37 PC-relative(dsp16) direct forms. `pc` here already
            // equals the address of the dsp16 word being read as `din` this cycle (decode
            // set pc<=pc2 one cycle earlier) -- MAME's GET_DSP16 evaluates addr_add(m_pc,
            // (int16_t)tmp16) AFTER get_operand(1) has advanced m_pc PAST that word, i.e.
            // at (this pc)+2, so `pc+16'd2+din` reproduces it exactly. No explicit sign-
            // extension of `din` is needed: 16-bit modular addition gives the identical low
            // 16 bits whether the addend is interpreted signed or unsigned (same free-sign-
            // extension trick already used by JR/CALR's own PC-relative displacement math
            // elsewhere in this file). ====
            // ---- Z30 direct: LDB rbd,dsp16 -- joins the EXISTING S_LDBDA_RD tail (byte
            // load, word-aligned read, ea[0] lane -- dst already latched at decode). ----
            S_Z30_FETCH: begin ea<=pc+16'd2+din; pc<=pc+16'd2; state<=S_LDBDA_RD; end
            S_Z31_FETCH: begin ea<=pc+16'd2+din; pc<=pc+16'd2; state<=S_DA_RD; end
            // ---- Z32 direct: LDRB dsp16,rbs -- joins the EXISTING S_LDBSTA_RD tail (byte
            // store, word-aligned RMW, src already latched at decode). ----
            S_Z32_FETCH: begin ea<=pc+16'd2+din; pc<=pc+16'd2; state<=S_LDBSTA_RD; end
            S_Z33_FETCH: begin ea<=pc+16'd2+din; pc<=pc+16'd2; state<=S_DA_WR; end
            // ---- Z34 direct: LDAR prd,dsp16 -- register-ONLY (no memory read of the
            // target at all, matches MAME's addr_to_reg): single-cycle, computes the PC-
            // relative address and writes it straight to R[dst]. ----
            S_Z34_FETCH: begin
                rwb0_we=1'b1; rwb0_idx=dst; rwb0_val=pc+16'd2+din;
                pc<=pc+16'd2; retire<=1'b1; state<=S_FETCH0;
            end
            // ---- Z35 direct: LDRL rrd,dsp16 -- joins the EXISTING S_L32_RD_HI tail (long
            // load, l32wb=0 -- plain load, no pointer writeback -- dst already latched). ----
            S_Z35_FETCH: begin ea<=pc+16'd2+din; l32wb<=1'b0; pc<=pc+16'd2; state<=S_L32_RD_HI; end
            // ---- Z37 direct: LDRL dsp16,rrs -- joins the EXISTING S_L32_WR_HI tail (long
            // store, l32wb=0, dout sourced from R[{src pair}] -- src already latched). ----
            S_Z37_FETCH: begin ea<=pc+16'd2+din; l32wb<=1'b0; pc<=pc+16'd2; state<=S_L32_WR_HI; end

            // ---- BATCH 8: LD rd,rs(rx) (0x71) -- word2's `din` holds only the idx nibble
            // (bits[11:8]), not an address literal, so it's read straight into the ea sum
            // instead of being staged through `operand`/`idxr` like every other indexed
            // family. ea is registered here; S_LD71_RD (added to the addr mux above as
            // `ea`) sees `din`=mem[ea] one cycle later, same one-state-latency shape as
            // every other *_FETCH->*_RD pair in this file. ----
            S_LD71_FETCH: begin ea<=R[src]+R[din[11:8]]; pc<=pc+16'd2; state<=S_LD71_RD; end
            S_LD71_RD: begin rwb0_we=1'b1; rwb0_idx=dst; rwb0_val=din; retire<=1'b1; state<=S_FETCH0; end

            // ==== BATCH 13: 0x70/72/73/74/75/77 -- same "ea=R[base]+R[word2's NIB1]" shape
            // as S_LD71_FETCH above, each joining an EXISTING RD/WR tail. ====
            S_Z70_FETCH: begin ea<=R[src]+R[din[11:8]]; pc<=pc+16'd2; state<=S_LDBDA_RD; end
            S_Z72_FETCH: begin ea<=R[dst]+R[din[11:8]]; pc<=pc+16'd2; state<=S_LDBSTA_RD; end
            S_Z73_FETCH: begin ea<=R[dst]+R[din[11:8]]; pc<=pc+16'd2; state<=S_DA_WR; end
            // Z74: register-only (no memory access) -- single-cycle add+writeback.
            S_Z74_FETCH: begin
                rwb0_we=1'b1; rwb0_idx=dst; rwb0_val=R[src]+R[din[11:8]];
                pc<=pc+16'd2; retire<=1'b1; state<=S_FETCH0;
            end
            S_Z75_FETCH: begin ea<=R[src]+R[din[11:8]]; l32wb<=1'b0; pc<=pc+16'd2; state<=S_L32_RD_HI; end
            S_Z77_FETCH: begin ea<=R[dst]+R[din[11:8]]; l32wb<=1'b0; pc<=pc+16'd2; state<=S_L32_WR_HI; end

            // ---- JP cc,addr[(rd)] (src holds cc). BATCH 16 fix: when taken and jpx,
            // add R[idxr] to the fetched addr (matches MAME's addr_add(addr,RW(dst))
            // BEFORE the cc test -- the addend is added whether or not cc is ultimately
            // true, but since it's only ever CONSUMED on the taken path, computing it
            // only there is equivalent and cheaper). Not-taken path is unaffected by
            // indexing either way (matches MAME: the switch does nothing on !cc,
            // leaving m_pc at its already-advanced-past-both-words value = our pc+2). ----
            S_JP: begin
                pc<=cc_true(src,fcw[FC],fcw[FZ],fcw[FS],fcw[FV])
                    ? (din + (jpx ? R[idxr] : 16'h0000)) : (pc+16'd2);
                retire<=1'b1; state<=S_FETCH0;
            end

            // ---- BATCH 17: internal-trap accept sequence (EPU/TRAP/SYSCALL) -- push PC,
            // push OLD fcw, push the trapping opcode word (`ir`, matches MAME's m_op[0]),
            // then load new FCW/PC from PSAP+trap_vec/+trap_vec+2. See the `trap_vec`
            // declaration comment for the full derivation and the deliberate single-SP
            // simplification (no NSP<->SSP swap, matching the existing NVI/IRET path). ----
            S_TRAP_PC:  begin rwb0_we=1'b1; rwb0_idx=4'd15; rwb0_val=R[15]-16'd2; state<=S_TRAP_FCW;   end // addr=SP-2,dout=pc,we=1
            S_TRAP_FCW: begin rwb0_we=1'b1; rwb0_idx=4'd15; rwb0_val=R[15]-16'd2; state<=S_TRAP_OP;    end // addr=SP-4,dout=fcw(old),we=1
            S_TRAP_OP:  begin rwb0_we=1'b1; rwb0_idx=4'd15; rwb0_val=R[15]-16'd2; state<=S_TRAP_RDFCW; end // addr=SP-6,dout=ir,we=1
            S_TRAP_RDFCW: begin fcw<=din; state<=S_TRAP_RDPC; end          // addr=psap+trap_vec,   fcw<=mem[...]
            S_TRAP_RDPC:  begin pc<=din; retire<=1'b1; state<=S_FETCH0; end // addr=psap+trap_vec+2, pc<=mem[...]

            // ==== BATCH 18: real port I/O (INB/IN/OUTB/OUT). All single-cycle -- addr is
            // a plain register value (no fetch needed), dout/din handled combinationally
            // via the mux updates below. ====
            S_INB_GO: begin // addr=R[src]&~1, iorq=1, wordacc=0
                rwb0_we=1'b1; rwb0_idx={1'b0,dst[2:0]};
                rwb0_val={2{R[src][0] ? din[7:0] : din[15:8]}}; rwb0_be=dst[3]?2'b01:2'b10;
                retire<=1'b1; state<=S_FETCH0;
            end
            S_IN_GO: begin // addr=R[src], iorq=1, wordacc=1
                rwb0_we=1'b1; rwb0_idx=dst; rwb0_val=din;
                retire<=1'b1; state<=S_FETCH0;
            end
            S_OUTB_GO: begin retire<=1'b1; state<=S_FETCH0; end // addr=R[dst]&~1,iorq=1,we=1,wordacc=0,dout=merged
            S_OUT_GO:  begin retire<=1'b1; state<=S_FETCH0; end // addr=R[dst],iorq=1,we=1,wordacc=1,dout=R[src]

            // ==== BATCH 18: LDPS real functional sequence. ====
            S_LDPS_FETCH:  begin ea<=din;         pc<=pc+16'd2; state<=S_LDPS_RDFCW; end // addr word via pc
            S_LDPS_FETCHX: begin ea<=din+R[idxr]; pc<=pc+16'd2; state<=S_LDPS_RDFCW; end
            S_LDPS_RDFCW: begin fcw<=din; state<=S_LDPS_RDPC; end          // addr=ea,   fcw<=mem[ea]
            S_LDPS_RDPC:  begin pc<=din; retire<=1'b1; state<=S_FETCH0; end // addr=ea+2, pc<=mem[ea+2]

            // ==== BATCH 19: 0x3A/0x3B single I/O (SIN/SOUT family). ====
            S_IOS_FETCH: begin ea<=din; pc<=pc+16'd2; state<= io_dir ? S_IOS_WR : S_IOS_RD; end
            S_IOS_RD: begin // addr=io_wide?ea:(ea&~1), iorq=1
                if (io_wide) begin rwb0_we=1'b1; rwb0_idx=dst; rwb0_val=din; end
                else begin
                    rwb0_we=1'b1; rwb0_idx={1'b0,dst[2:0]};
                    rwb0_val={2{ea[0] ? din[7:0] : din[15:8]}}; rwb0_be=dst[3]?2'b01:2'b10;
                end
                retire<=1'b1; state<=S_FETCH0;
            end
            S_IOS_WR: begin retire<=1'b1; state<=S_FETCH0; end // addr=io_wide?ea:(ea&~1),iorq=1,we=1,dout=merged,wordacc=io_wide

            // ==== BATCH 19: 0x3A/0x3B self-repeating block I/O. ====
            S_IOB_FETCH2: begin // addr word2 via pc
                cntreg<=din[11:8]; dst<=din[7:4]; iocc<=din[3:0];
                pc<=pc+16'd2; state<=S_IOB_RD;
            end
            S_IOB_RD: begin // addr=iob_rdword?R[src]:(R[src]&~1); iorq=(IN dir); mreq=(OUT dir)
                operand<=din;
                // byte+IN(writing to MEMORY) needs the OLD mem word for the RMW merge;
                // everything else (word forms, or byte+OUT writing to a PORT) doesn't.
                state<= (!io_wide && (io_sub[1]==1'b0)) ? S_IOB_WR_RD : S_IOB_WR;
            end
            S_IOB_WR_RD: begin operand2<=din; state<=S_IOB_WR; end // addr=R[dst]&~1: old mem word for RMW
            S_IOB_WR: begin // addr=io_wide?R[dst]:(R[dst]&~1); iorq=(OUT dir); mreq=(IN dir); we=1; dout=iob_wr_dout
                rwb0_we=1'b1; rwb0_idx=cntreg; rwb0_val=R[cntreg]-16'd1;
                iob_step = (io_wide ? 16'sd2 : 16'sd1) * (io_sub[3] ? -16'sd1 : 16'sd1);
                iob_both = io_wide || io_sub[3] || io_sub[0];
                if (iob_both) begin
                    rwb1_we=1'b1; rwb1_idx=dst; rwb1_val=R[dst]+iob_step;
                    rwb2_we=1'b1; rwb2_idx=src; rwb2_val=R[src]+iob_step;
                end else if (io_sub[1]) begin // OUT, single-register case: bump src only
                    rwb1_we=1'b1; rwb1_idx=src; rwb1_val=R[src]+iob_step;
                end else begin // IN, single-register case: bump dst only
                    rwb1_we=1'b1; rwb1_idx=dst; rwb1_val=R[dst]+iob_step;
                end
                // MAME: if(--RW(cnt)){CLR_V; if(cc==0)m_pc-=4;} else SET_V;
                if ((R[cntreg]-16'd1) != 16'h0000) begin
                    fcw<=(fcw & ~MV);
                    if (iocc==4'h0) pc<=pc_orig; // repeat: rewind to re-fetch/re-decode
                end else begin
                    fcw<=(fcw | MV);
                end
                retire<=1'b1; state<=S_FETCH0;
            end

            // ---- ADDB rd,@rs (byte, flags CZSVH, DA=0) ----
            S_ADDB_RD: begin
                operand_b = R[src][0] ? din[7:0] : din[15:8];
                dbyte     = dst[3] ? R[dst[2:0]][7:0] : R[dst[2:0]][15:8];
                add8      = {1'b0,dbyte}+{1'b0,operand_b};
                v = (operand_b[7]&dbyte[7]&~add8[7])|(~operand_b[7]&~dbyte[7]&add8[7]);
                h = (add8[3:0] < dbyte[3:0]);
                rwb0_we=1'b1; rwb0_idx={1'b0,dst[2:0]}; rwb0_val={2{add8[7:0]}}; rwb0_be=dst[3]?2'b01:2'b10;
                fcw<=(fcw & ~(MC|MZ|MS|MV|MDA|MH))
                   | (add8[8]?MC:0)|((add8[7:0]==0)?MZ:0)|(add8[7]?MS:0)|(v?MV:0)|(h?MH:0);
                retire<=1'b1; state<=S_FETCH0;
            end

            // ---- NVI accept sequence: push PC, push old FCW, push vec tag,
            //      then load new FCW/PC from the PSA NVI vector (PSAP+0x18/0x1A) ----
            S_NVI_PC:  begin rwb0_we=1'b1; rwb0_idx=4'd15; rwb0_val=R[15]-16'd2; state<=S_NVI_FCW;   end  // addr/dout comb: SP-2 <= pc
            S_NVI_FCW: begin rwb0_we=1'b1; rwb0_idx=4'd15; rwb0_val=R[15]-16'd2; state<=S_NVI_VEC;   end  // SP-4 <= old fcw
            S_NVI_VEC: begin rwb0_we=1'b1; rwb0_idx=4'd15; rwb0_val=R[15]-16'd2; state<=S_NVI_RDFCW; end  // SP-6 <= 16'h00FF
            S_NVI_RDFCW: begin fcw<=din; state<=S_NVI_RDPC; end          // fcw <= mem[psap+0x18]
            S_NVI_RDPC:  begin
                pc<=din; nvi_pending<=1'b0; state<=S_FETCH0;             // pc <= mem[psap+0x1A]
            end

            // ---- IRET: pop vec(discard), pop FCW, pop PC ----
            S_IRET_VEC: begin rwb0_we=1'b1; rwb0_idx=4'd15; rwb0_val=R[15]+16'd2; state<=S_IRET_FCW; end // discard din (tag)
            S_IRET_FCW: begin fcw<=din; rwb0_we=1'b1; rwb0_idx=4'd15; rwb0_val=R[15]+16'd2; state<=S_IRET_PC; end
            S_IRET_PC:  begin pc<=din; rwb0_we=1'b1; rwb0_idx=4'd15; rwb0_val=R[15]+16'd2; retire<=1'b1; state<=S_FETCH0; end

            // ==== BATCH 1: stack + control flow ========================================
            // ---- CALL: fetch target addr (direct form only), then push PC & jump ----
            S_CALL_FETCH: begin ea<=din; pc<=pc+16'd2; state<=S_CALL_PUSH; end // addr word via pc (default mux)
            // BATCH 11: indexed sibling of S_CALL_FETCH (0x5F10-0x5FF0) -- ea=addr+R[idxr],
            // joins the EXISTING S_CALL_PUSH unchanged.
            S_CALLX_FETCH: begin ea<=din+R[idxr]; pc<=pc+16'd2; state<=S_CALL_PUSH; end
            S_CALL_PUSH:  begin rwb0_we=1'b1; rwb0_idx=4'd15; rwb0_val=R[15]-16'd2; pc<=ea; retire<=1'b1; state<=S_FETCH0; end // addr=SP-2,dout=pc,we=1

            // ---- RET cc (taken): pop PC, SP+=2 ----
            S_RET_POP: begin pc<=din; rwb0_we=1'b1; rwb0_idx=4'd15; rwb0_val=R[15]+16'd2; retire<=1'b1; state<=S_FETCH0; end // addr=R[15]

            // ---- PUSH (word): value staged in `operand`, commit via generic push ----
            S_PUSHI_FETCH: begin operand<=din; pc<=pc+16'd2; state<=S_PUSH_W; end          // imm16 via pc
            S_PUSHA_FETCH: begin ea<=din; pc<=pc+16'd2; state<=S_PUSHA_RD; end             // addr word via pc
            // BATCH 11: indexed sibling of S_PUSHA_FETCH (0x53, NIB3!=0) -- ea=addr+R[idxr],
            // joins the EXISTING S_PUSHA_RD unchanged.
            S_PUSHAX_FETCH: begin ea<=din+R[idxr]; pc<=pc+16'd2; state<=S_PUSHA_RD; end
            S_PUSHA_RD:    begin operand<=din; state<=S_PUSH_W; end                        // addr=ea: read source value
            S_PUSH_W:      begin rwb0_we=1'b1; rwb0_idx=dst; rwb0_val=R[dst]-16'd2; retire<=1'b1; state<=S_FETCH0; end  // addr=R[dst]-2,dout=operand,we=1

            // ---- POP (word): register-dest direct; addr-dest via fetch/pop/store chain ----
            S_POP_R:      begin rwb0_we=1'b1; rwb0_idx=dst; rwb0_val=din; rwb1_we=1'b1; rwb1_idx=src; rwb1_val=R[src]+16'd2; retire<=1'b1; state<=S_FETCH0; end // addr=R[src]
            S_POPA_FETCH: begin ea<=din; pc<=pc+16'd2; state<=S_POPA_POP; end                          // addr word via pc
            // BATCH 11: indexed sibling of S_POPA_FETCH (0x57, NIB3!=0) -- ea=addr+R[idxr],
            // joins the EXISTING S_POPA_POP unchanged.
            S_POPAX_FETCH: begin ea<=din+R[idxr]; pc<=pc+16'd2; state<=S_POPA_POP; end
            S_POPA_POP:   begin operand<=din; rwb0_we=1'b1; rwb0_idx=src; rwb0_val=R[src]+16'd2; state<=S_POPA_WR; end   // addr=R[src]
            S_POPA_WR:    begin retire<=1'b1; state<=S_FETCH0; end                                     // addr=ea,dout=operand,we=1

            // ---- shared 32-bit (long) pump: hi word @ea, lo word @ea+2. `dst`=dest
            //      reg-PAIR select (RD) / `src`=value reg-PAIR select (WR); when l32wb,
            //      the plain pointer register (`src` for RD/POPL, `dst` for WR/PUSHL)
            //      is written back (POPL: ea+4 ; PUSHL: ea, already = R[dst_orig]-4) ----
            S_L32_RD_HI: begin operand<=din; state<=S_L32_RD_LO; end // addr=ea: hi word
            S_L32_RD_LO: begin                                       // addr=ea+2: lo word
                rwb0_we=1'b1; rwb0_idx={dst[3:1],1'b0};      rwb0_val=operand;
                rwb1_we=1'b1; rwb1_idx={dst[3:1],1'b0}+4'd1; rwb1_val=din;
                if (l32wb) begin rwb2_we=1'b1; rwb2_idx=src; rwb2_val=ea + 16'd4; end
                retire<=1'b1; state<=S_FETCH0;
            end
            S_L32_WR_HI: begin state<=S_L32_WR_LO; end            // addr=ea,dout=R[{src pair}]: hi word
            S_L32_WR_LO: begin                                    // addr=ea+2,dout=R[{src pair}+1]: lo word
                if (l32wb) begin rwb0_we=1'b1; rwb0_idx=dst; rwb0_val=ea; end
                retire<=1'b1; state<=S_FETCH0;
            end

            // ==== BATCH 11: PUSHL @Rd,addr[,(rs)] (0x51) -- read a FRESH 32-bit value from
            // the fetched address (hi@ea, lo@ea+2, staged operand/operand2), THEN push it
            // (predecrement R[dst] by 4, same commit shape as S_L32_WR_LO's l32wb branch,
            // but dout must come from `operand`/`operand2` here, not a register pair, so a
            // dedicated pump is needed -- can't reuse S_L32_WR_* directly). ====
            S_PLDA_FETCH:  begin ea<=din;         pc<=pc+16'd2; state<=S_PLDA_RD_HI; end
            S_PLDA_FETCHX: begin ea<=din+R[idxr]; pc<=pc+16'd2; state<=S_PLDA_RD_HI; end
            S_PLDA_RD_HI: begin operand<=din;  state<=S_PLDA_RD_LO; end  // addr=ea: hi word
            S_PLDA_RD_LO: begin operand2<=din; state<=S_PLDA_WR_HI; end  // addr=ea+2: lo word
            S_PLDA_WR_HI: begin state<=S_PLDA_WR_LO; end                 // addr=R[dst]-4,dout=operand,we=1
            S_PLDA_WR_LO: begin // addr=R[dst]-4+2,dout=operand2,we=1
                rwb0_we=1'b1; rwb0_idx=dst; rwb0_val=R[dst]-16'd4;
                retire<=1'b1; state<=S_FETCH0;
            end

            // ==== BATCH 11: POPL addr[,(rd)],@Rs (0x55) -- pop a long @R[src] (postincrement
            // +4, same as the register-form POPL), write it to the fetched ea (no pointer
            // adjustment on the destination side -- it's a plain address, not a pointer
            // register). Dedicated pump, same reasoning as PUSHL above (dout source differs
            // from S_L32_WR_*'s hardwired register-pair). ====
            S_POLDA_FETCH:  begin ea<=din;         pc<=pc+16'd2; state<=S_POLDA_RD_HI; end
            S_POLDA_FETCHX: begin ea<=din+R[idxr]; pc<=pc+16'd2; state<=S_POLDA_RD_HI; end
            S_POLDA_RD_HI: begin operand<=din; state<=S_POLDA_RD_LO; end // addr=R[src]: hi word
            S_POLDA_RD_LO: begin // addr=R[src]+2: lo word
                operand2<=din;
                rwb0_we=1'b1; rwb0_idx=src; rwb0_val=R[src]+16'd4;  // postincrement source ptr
                state<=S_POLDA_WR_HI;
            end
            S_POLDA_WR_HI: begin state<=S_POLDA_WR_LO; end            // addr=ea,dout=operand,we=1
            S_POLDA_WR_LO: begin retire<=1'b1; state<=S_FETCH0; end   // addr=ea+2,dout=operand2,we=1

            // ---- LDL RRd,#imm32: hi word then lo word, both via pc (not ea) ----
            S_LDL_IMM_HI: begin operand<=din; pc<=pc+16'd2; state<=S_LDL_IMM_LO; end
            S_LDL_IMM_LO: begin
                rwb0_we=1'b1; rwb0_idx={dst[3:1],1'b0};      rwb0_val=operand;
                rwb1_we=1'b1; rwb1_idx={dst[3:1],1'b0}+4'd1; rwb1_val=din;
                pc<=pc+16'd2; retire<=1'b1; state<=S_FETCH0;
            end

            // ---- LDL RRd,addr / LDL addr,RRs: fetch the direct address, then feed
            //      the generic L32 pump (l32wb=0, plain load/store, no ptr writeback) ----
            S_LDLA_FETCH:  begin ea<=din; l32wb<=1'b0; pc<=pc+16'd2; state<=S_L32_RD_HI; end
            // BATCH 7 (post-verify): indexed sibling of the direct form above -- same
            // S_L32_RD_HI/LO tail, ea = addr+R[src] instead of ea = addr.
            S_LDLAX_FETCH: begin ea<=din+R[src]; l32wb<=1'b0; pc<=pc+16'd2; state<=S_L32_RD_HI; end
            S_LDLSA_FETCH: begin ea<=din; l32wb<=1'b0; pc<=pc+16'd2; state<=S_L32_WR_HI; end
            // BATCH 8: indexed sibling of S_LDLSA_FETCH above -- same S_L32_WR_HI/LO
            // store tail, ea = addr+R[idxr] instead of ea = addr.
            S_LDLSAX_FETCH: begin ea<=din+R[idxr]; l32wb<=1'b0; pc<=pc+16'd2; state<=S_L32_WR_HI; end

            // ---- LDM rd,@rs,n: fetch word2 (dst start reg @ bits[11:8], cnt-1 @ bits[3:0]),
            //      base pointer ea<=R[src] (src holds the ptr reg latched in S_FETCH0),
            //      then self-loop one word/cycle until mcnt==0 ----
            S_LDM_L_FETCH2: begin
                dst<=din[11:8]; mcnt<=din[3:0]; ea<=R[src]; pc<=pc+16'd2; state<=S_LDM_L_RD;
            end
            S_LDM_L_RD: begin // addr=ea
                rwb0_we=1'b1; rwb0_idx=dst; rwb0_val=din;
                if (mcnt==4'h0) begin retire<=1'b1; state<=S_FETCH0; end
                else begin mcnt<=mcnt-4'd1; dst<=dst+4'd1; ea<=ea+16'd2; end
            end

            // ---- LDM @rd,rs,n: fetch word2 (src start reg @ bits[11:8], cnt-1 @ bits[3:0]),
            //      base pointer ea<=R[dst] (dst holds the ptr reg latched in S_FETCH0) ----
            S_LDM_S_FETCH2: begin
                src<=din[11:8]; mcnt<=din[3:0]; ea<=R[dst]; pc<=pc+16'd2; state<=S_LDM_S_WR;
            end
            S_LDM_S_WR: begin // addr=ea,dout=R[src],we=1
                if (mcnt==4'h0) begin retire<=1'b1; state<=S_FETCH0; end
                else begin mcnt<=mcnt-4'd1; src<=src+4'd1; ea<=ea+16'd2; end
            end

            // BATCH 7 (post-verify): LDM addr,rs,n direct-address store -- two fetches
            // (word2: src-start+count, word3: the addr) then join S_LDM_S_WR UNCHANGED.
            // BATCH 11: `ldmx` (set at decode) routes to the NEW indexed word3-fetch
            // instead when this word2-fetch is shared by the 0x5CN9 indexed form.
            S_LDM_DA_FETCH2: begin
                src<=din[11:8]; mcnt<=din[3:0]; pc<=pc+16'd2;
                state<= ldmx ? S_LDM_DA_FETCH3X : S_LDM_DA_FETCH3;
            end
            S_LDM_DA_FETCH3: begin ea<=din; pc<=pc+16'd2; state<=S_LDM_S_WR; end
            // BATCH 11: indexed sibling of S_LDM_DA_FETCH3 -- ea=addr+R[idxr].
            S_LDM_DA_FETCH3X: begin ea<=din+R[idxr]; pc<=pc+16'd2; state<=S_LDM_S_WR; end

            // BATCH 8: LDM rd,addr,n direct-address LOAD -- same two-fetch shape as the STORE
            // pair above (word2: dst-start+count, word3: the addr), joins S_LDM_L_RD UNCHANGED.
            // BATCH 11: same `ldmx` routing trick as the STORE word2-fetch above.
            S_LDM_DA_LFETCH2: begin
                dst<=din[11:8]; mcnt<=din[3:0]; pc<=pc+16'd2;
                state<= ldmx ? S_LDM_DA_LFETCH3X : S_LDM_DA_LFETCH3;
            end
            S_LDM_DA_LFETCH3: begin ea<=din; pc<=pc+16'd2; state<=S_LDM_L_RD; end
            // BATCH 11: indexed sibling of S_LDM_DA_LFETCH3 -- ea=addr+R[idxr].
            S_LDM_DA_LFETCH3X: begin ea<=din+R[idxr]; pc<=pc+16'd2; state<=S_LDM_L_RD; end

            // ==== BATCH 2 PART A: indirect-indirect PUSHL/PUSH/POP =====================
            // ---- PUSHL @Rd,@Rs (0x11): read long @R[src] (unmodified), write long @ea
            //      (=R[dst]-4, precomputed at fetch), commit R[dst]<=ea. Read-then-write
            //      ordering (not read-both-then-write-both) matches MAME's own evaluation
            //      order for PUSHL(dst,RDIR_L(src)) since RDIR_L has no side effect on
            //      `src`, so any read/write region overlap resolves identically either way ----
            S_PLII_RD_HI: begin operand<=din;  state<=S_PLII_WR_HI; end  // addr=R[src]: hi word
            S_PLII_WR_HI: begin                state<=S_PLII_RD_LO; end  // addr=ea,dout=operand,we=1
            S_PLII_RD_LO: begin operand2<=din; state<=S_PLII_WR_LO; end  // addr=R[src]+2: lo word
            S_PLII_WR_LO: begin rwb0_we=1'b1; rwb0_idx=dst; rwb0_val=ea; retire<=1'b1; state<=S_FETCH0; end // addr=ea+2,dout=operand2,we=1

            // ---- PUSH @Rd,@Rs (0x13): read word @R[src], hand off to existing S_PUSH_W ----
            S_PUSHII_RD: begin operand<=din; state<=S_PUSH_W; end        // addr=R[src]

            // ---- POP @Rd,@Rs (0x17): pop word @R[src] (+2), write LIVE @R[dst] ----
            S_POPII_RD: begin rwb0_we=1'b1; rwb0_idx=src; rwb0_val=R[src]+16'd2; operand<=din; state<=S_POPII_WR; end // addr=R[src]
            S_POPII_WR: begin retire<=1'b1; state<=S_FETCH0; end          // addr=R[dst] (live),dout=operand,we=1

            // ==== BATCH 2 PART B ========================================================
            // ---- shared byte ALU/LDB pipeline (mirrors S_IMM/S_MEMRD/S_ALU) ----
            S_IMMB:   begin operand[7:0]<=din[7:0]; pc<=pc+16'd2; state<=S_ALUB; end // imm8 = LOW byte of ext word
            S_MEMRDB: begin operand[7:0]<= R[src][0] ? din[7:0] : din[15:8]; state<=S_ALUB; end // addr=R[src]&~1
            S_ALUB: begin
                dbyte    = dst[3] ? R[dst[2:0]][7:0] : R[dst[2:0]][15:8];  // current dest byte
                add8     = {1'b0,dbyte} + {1'b0,operand[7:0]};
                incb_sum = {1'b0,dbyte} - {1'b0,operand[7:0]};
                wb=1'b1; res8=operand[7:0]; fmask=16'h0000; fval=16'h0000;
                case (aluop)
                    LD:  begin res8=operand[7:0]; end
                    ADD: begin res8=add8[7:0];
                         c=add8[8]; z=(res8==0); s=res8[7];
                         v=(operand[7]&dbyte[7]&~res8[7])|(~operand[7]&~dbyte[7]&res8[7]);
                         h=(res8[3:0]<dbyte[3:0]);
                         fmask=MC|MZ|MS|MV|MDA|MH; fval=(c?MC:0)|(z?MZ:0)|(s?MS:0)|(v?MV:0)|(h?MH:0); end
                    SUB: begin res8=incb_sum[7:0];
                         c=incb_sum[8]; z=(res8==0); s=res8[7];
                         v=(~operand[7]&dbyte[7]&~res8[7])|(operand[7]&~dbyte[7]&res8[7]);
                         h=(res8[3:0]>dbyte[3:0]);
                         fmask=MC|MZ|MS|MV|MDA|MH; fval=(c?MC:0)|(z?MZ:0)|(s?MS:0)|(v?MV:0)|MDA|(h?MH:0); end
                    AND: begin res8=dbyte&operand[7:0]; z=(res8==0); s=res8[7]; p=(~^res8);
                         fmask=MZ|MS|MV; fval=(z?MZ:0)|(s?MS:0)|(p?MV:0); end
                    OR:  begin res8=dbyte|operand[7:0]; z=(res8==0); s=res8[7]; p=(~^res8);
                         fmask=MZ|MS|MV; fval=(z?MZ:0)|(s?MS:0)|(p?MV:0); end
                    CP:  begin res8=incb_sum[7:0]; wb=1'b0;
                         c=incb_sum[8]; z=(res8==0); s=res8[7];
                         v=(~operand[7]&dbyte[7]&~res8[7])|(operand[7]&~dbyte[7]&res8[7]);
                         fmask=MC|MZ|MS|MV; fval=(c?MC:0)|(z?MZ:0)|(s?MS:0)|(v?MV:0); end
                    default: begin res8=dbyte^operand[7:0]; z=(res8==0); s=res8[7]; p=(~^res8); // XOR
                         fmask=MZ|MS|MV; fval=(z?MZ:0)|(s?MS:0)|(p?MV:0); end
                endcase
                if (wb) begin rwb0_we=1'b1; rwb0_idx={1'b0,dst[2:0]}; rwb0_val={2{res8}}; rwb0_be=dst[3]?2'b01:2'b10; end
                fcw<=(fcw & ~fmask) | fval;
                retire<=1'b1; state<=S_FETCH0;
            end

            // ---- LDB @Rd,rbs store (0x2E): word-aligned RMW so the untouched byte lane
            //      survives (wordacc unconnected downstream, see header comment) ----
            S_LDBST_RD: begin operand<=din; state<=S_LDBST_WR; end       // addr=R[dst]&~1
            S_LDBST_WR: begin retire<=1'b1; state<=S_FETCH0; end        // addr=R[dst]&~1,dout=merged,we=1

            // ---- CPL rrd,@rs (0x10): read long @R[src] (unmodified), compare vs RL(dst),
            //      no writeback. Flags CZSV per MAME CPL()/CHK_SUBL_V. ----
            S_CPL_RD_HI: begin operand<=din; state<=S_CPL_RD_LO; end     // addr=R[src]: hi word
            S_CPL_RD_LO: begin                                          // addr=R[src]+2: lo word
                dif33 = {1'b0, R[{dst[3:1],1'b0}], R[{dst[3:1],1'b0}+4'd1]} - {1'b0, operand, din};
                fcw<=(fcw & ~(MC|MZ|MS|MV)) | (dif33[32]?MC:0)|((dif33[31:0]==0)?MZ:0)|(dif33[31]?MS:0)
                   | (((~operand[15] & R[{dst[3:1],1'b0}][15] & ~dif33[31]) |
                       (operand[15] & ~R[{dst[3:1],1'b0}][15] &  dif33[31])) ? MV:0);
                retire<=1'b1; state<=S_FETCH0;
            end
            // ---- CPL rrd,rrs (0x90): same compare, both operands direct register pairs ----
            S_CPL_RR: begin
                dif33 = {1'b0, R[{dst[3:1],1'b0}], R[{dst[3:1],1'b0}+4'd1]}
                      - {1'b0, R[{src[3:1],1'b0}], R[{src[3:1],1'b0}+4'd1]};
                fcw<=(fcw & ~(MC|MZ|MS|MV)) | (dif33[32]?MC:0)|((dif33[31:0]==0)?MZ:0)|(dif33[31]?MS:0)
                   | (((~R[{src[3:1],1'b0}][15] & R[{dst[3:1],1'b0}][15] & ~dif33[31]) |
                       (R[{src[3:1],1'b0}][15] & ~R[{dst[3:1],1'b0}][15] &  dif33[31])) ? MV:0);
                retire<=1'b1; state<=S_FETCH0;
            end

            // ---- BITB/BIT @Rd,#imm4 (read-only, flags -Z----; Z=1 means tested bit is 0) ----
            S_BITB_RD: begin // addr=R[dst]&~1
                dbyte = R[dst][0] ? din[7:0] : din[15:8];
                fcw<=(fcw & ~MZ) | (((dbyte & bmask[7:0])==0) ? MZ : 16'h0000);
                retire<=1'b1; state<=S_FETCH0;
            end
            S_BIT_RD: begin // addr=R[dst]
                fcw<=(fcw & ~MZ) | (((din & bmask)==0) ? MZ : 16'h0000);
                retire<=1'b1; state<=S_FETCH0;
            end

            // ==== BATCH 14: RESB/RES/SETB/SET/BITB/BIT rd,rs (0x22-0x27, dynamic bit index)
            // -- `din` here is word2 (read via `pc`, default addr mux); din[11:8]/din[10:8]
            // is the TARGET register (byte-reg-code for the B forms, plain register for the
            // word forms); `src` (word1 NIB3, latched at decode) is the register whose LOW
            // bits (masked 0-7 byte / 0-15 word) give the bit POSITION -- register-only,
            // single cycle, no memory access, flags exactly mirror the already-implemented
            // @Rd,#imm4 siblings (RESB/RES/SETB/SET ------, BITB/BIT -Z----). ====
            S_RESB2_GO: begin
                dbyte = din[11] ? R[din[10:8]][7:0] : R[din[10:8]][15:8];
                res8 = dbyte & ~(8'h01 << R[src][2:0]);
                rwb0_we=1'b1; rwb0_idx={1'b0,din[10:8]}; rwb0_val={2{res8}}; rwb0_be=din[11]?2'b01:2'b10;
                pc<=pc+16'd2; retire<=1'b1; state<=S_FETCH0;
            end
            S_RES2_GO: begin
                rwb0_we=1'b1; rwb0_idx=din[11:8]; rwb0_val=R[din[11:8]] & ~(16'h0001 << R[src][3:0]);
                pc<=pc+16'd2; retire<=1'b1; state<=S_FETCH0;
            end
            S_SETB2_GO: begin
                dbyte = din[11] ? R[din[10:8]][7:0] : R[din[10:8]][15:8];
                res8 = dbyte | (8'h01 << R[src][2:0]);
                rwb0_we=1'b1; rwb0_idx={1'b0,din[10:8]}; rwb0_val={2{res8}}; rwb0_be=din[11]?2'b01:2'b10;
                pc<=pc+16'd2; retire<=1'b1; state<=S_FETCH0;
            end
            S_SET2_GO: begin
                rwb0_we=1'b1; rwb0_idx=din[11:8]; rwb0_val=R[din[11:8]] | (16'h0001 << R[src][3:0]);
                pc<=pc+16'd2; retire<=1'b1; state<=S_FETCH0;
            end
            S_BITB2_GO: begin
                dbyte = din[11] ? R[din[10:8]][7:0] : R[din[10:8]][15:8];
                fcw<=(fcw & ~MZ) | (((dbyte & (8'h01 << R[src][2:0]))==8'h00) ? MZ : 16'h0000);
                pc<=pc+16'd2; retire<=1'b1; state<=S_FETCH0;
            end
            S_BIT2_GO: begin
                fcw<=(fcw & ~MZ) | (((R[din[11:8]] & (16'h0001 << R[src][3:0]))==16'h0000) ? MZ : 16'h0000);
                pc<=pc+16'd2; retire<=1'b1; state<=S_FETCH0;
            end

            // ---- RES/SET @Rd,#imm4 (word, shared pump; bitop_set: 0=AND~bit 1=OR bit;
            //      flags ------, untouched) ----
            S_BITW_RD: begin operand<=din; state<=S_BITW_WR; end        // addr=R[dst]
            S_BITW_WR: begin retire<=1'b1; state<=S_FETCH0; end         // addr=R[dst],dout=merged,we=1

            // ---- EX rd,@rs (word exchange; flags ------, untouched) ----
            S_EX_RD: begin operand<=din; state<=S_EX_WR; end            // addr=R[src]: old mem value
            S_EX_WR: begin rwb0_we=1'b1; rwb0_idx=dst; rwb0_val=operand; retire<=1'b1; state<=S_FETCH0; end // addr=R[src],dout=R[dst](old),we=1

            // ==== BATCH 3 ================================================================
            // ---- INC/DEC addr,#n direct: fetch addr, RMW word (wordacc-safe by
            //      construction). `aluop` (ADD=INC/SUB=DEC) and `mcnt` (imm4m1 nibble)
            //      latched at decode. i4p1 uses a 5-bit scratch (not the pre-existing
            //      4-bit `incn`) so imm4m1 field 0xF ("+16") doesn't wrap to 0 -- see the
            //      report re: `incn`'s truncation bug in the pre-Batch-1 register form. ----
            S_INCDA_FETCH: begin ea<=din; pc<=pc+16'd2; state<=S_INCDA_RD; end // addr word via pc
            S_INCDA_RD: begin // addr=ea: read old value
                i4p1 = {1'b0,mcnt} + 5'd1;
                if (aluop==ADD) begin
                    incw_sum = {1'b0,din} + {12'd0,i4p1};
                    v = (~din[15]) & incw_sum[15];
                    operand <= incw_sum[15:0];
                    fcw<=(fcw & ~(MZ|MS|MV)) | ((incw_sum[15:0]==16'h0000)?MZ:0)|(incw_sum[15]?MS:0)|(v?MV:0);
                end else begin
                    dif17 = {1'b0,din} - {12'd0,i4p1};
                    v = din[15] & ~dif17[15];
                    operand <= dif17[15:0];
                    fcw<=(fcw & ~(MZ|MS|MV)) | ((dif17[15:0]==16'h0000)?MZ:0)|(dif17[15]?MS:0)|(v?MV:0);
                end
                state<=S_INCDA_WR;
            end
            S_INCDA_WR: begin retire<=1'b1; state<=S_FETCH0; end   // addr=ea,dout=operand,we=1

            // ---- MULT rrd,{#imm16|@rs|rs}: dest16 = LOW word of RL(dst) (MAME truncates
            //      RL(dst) to uint16_t for MULTW's `dest` param); product overwrites the
            //      FULL RL(dst) pair. V is NEVER set (verified in MULTW's body -- only
            //      CLR_CZSV runs, no SET_V despite the doc-comment saying CZSV--); C uses
            //      MAME's exact asymmetric bounds (< -32767 or >= 32767), not +-32768. ----
            S_MULT_IMM: begin operand<=din; pc<=pc+16'd2; state<=S_MULT_GO; end
            S_MULT_RD:  begin operand<=din; state<=S_MULT_GO; end            // addr=R[src]&~1
            S_MULT_GO: begin
                mul_p32 = $signed(R[{dst[3:1],1'b0}+4'd1]) * $signed(operand);
                c = (mul_p32 < -32'sd32767) || (mul_p32 >= 32'sd32767);
                z = (mul_p32 == 32'sd0); s = mul_p32[31];
                rwb0_we=1'b1; rwb0_idx={dst[3:1],1'b0};      rwb0_val=mul_p32[31:16];
                rwb1_we=1'b1; rwb1_idx={dst[3:1],1'b0}+4'd1; rwb1_val=mul_p32[15:0];
                fcw<=(fcw & ~(MC|MZ|MS|MV)) | (c?MC:0)|(z?MZ:0)|(s?MS:0);
                retire<=1'b1; state<=S_FETCH0;
            end

            // ---- DIV rrd,{#imm16|@rs|rs}: dest32 = FULL RL(dst) pair (dividend); quotient
            //      -> lo word, remainder -> hi word of RL(dst). Verilog signed `/`/`%`
            //      truncate toward zero with the remainder taking the dividend's sign --
            //      algebraically IDENTICAL to MAME's manual abs/sign-restore dance in
            //      DIVW (verified term-by-term against z8000ops.hxx, see header). Overflow
            //      retry (>>1, clamp to -1/0, set C) and divide-by-zero (Z,V set, C,S
            //      cleared, dest UNCHANGED) replicated exactly. ----
            S_DIV_IMM: begin operand<=din; pc<=pc+16'd2; state<=S_DIV_GO; end
            S_DIV_RD:  begin operand<=din; state<=S_DIV_GO; end              // addr=R[src]&~1
            S_DIV_GO: begin
                if (operand==16'h0000) begin
                    c=1'b0; z=1'b1; s=1'b0; v=1'b1;   // dest UNCHANGED -- no register write
                    fcw<=(fcw & ~(MC|MZ|MS|MV)) | (c?MC:0)|(z?MZ:0)|(s?MS:0)|(v?MV:0);
                    retire<=1'b1; state<=S_FETCH0;
                end else begin
                    div_dvd = $signed({R[{dst[3:1],1'b0}], R[{dst[3:1],1'b0}+4'd1]});
                    div_dvs = {{16{operand[15]}}, operand};
                    dv_qneg <= div_dvd[31] ^ div_dvs[31];
                    dv_rneg <= div_dvd[31];
                    dv_quo  <= {32'd0, (div_dvd[31] ? -div_dvd : div_dvd)};
                    dv_dvsr <= {32'd0, (div_dvs[31] ? -div_dvs : div_dvs)};
                    dv_rem  <= 64'd0;
                    dv_cnt  <= 7'd0;
                    dv_long <= 1'b0;
                    state   <= S_DIV_BUSY;
                end
            end

            // ---- shared restoring-division iteration (DIV and DIVL both land here) ----
            // Classic shift-subtract: {rem,quo} shifts left one bit per cycle, the bit
            // shifted out of quo's MSB enters rem's LSB, then a trial subtract decides
            // the quotient bit. 64 iterations covers both widths (DIV's 32-bit dividend
            // is zero-padded into the low half, so its first 32 shifts are harmless).
            S_DIV_BUSY: begin
                dv_shf = {dv_rem, dv_quo[63]};        // 65-bit (rem<<1 | next dividend bit)
                dv_sub = dv_shf - {1'b0, dv_dvsr};    // bit 64 = borrow => dvsr was bigger
                if (!dv_sub[64]) begin
                    dv_rem <= dv_sub[63:0];
                    dv_quo <= {dv_quo[62:0], 1'b1};
                end else begin
                    dv_rem <= dv_shf[63:0];
                    dv_quo <= {dv_quo[62:0], 1'b0};
                end
                dv_cnt <= dv_cnt + 7'd1;
                if (dv_cnt == 7'd63) state <= dv_long ? S_DIVL_FIN : S_DIV_FIN;
            end

            S_DIV_FIN: begin
                dv_q_signed = dv_qneg ? -$signed(dv_quo) : $signed(dv_quo);
                dv_r_signed = dv_rneg ? -$signed(dv_rem) : $signed(dv_rem);
                div_q = dv_q_signed[31:0];
                div_r = dv_r_signed[15:0];
                if (div_q < -32'sd32768 || div_q > 32'sd32767) begin
                    v = 1'b1;
                    div_qtmp = div_q >>> 1;
                    if (div_qtmp >= -32'sd32768 && div_qtmp <= 32'sd32767) begin
                        div_q = (div_qtmp < 0) ? -32'sd1 : 32'sd0;
                        c = 1'b1; z=(div_q[15:0]==16'h0000); s=div_q[15];
                    end else begin
                        c = 1'b0; z = 1'b0; s = 1'b0;
                    end
                end else begin
                    v = 1'b0; c = 1'b0; z=(div_q[15:0]==16'h0000); s=div_q[15];
                end
                rwb0_we=1'b1; rwb0_idx={dst[3:1],1'b0};      rwb0_val=div_r[15:0];
                rwb1_we=1'b1; rwb1_idx={dst[3:1],1'b0}+4'd1; rwb1_val=div_q[15:0];
                fcw<=(fcw & ~(MC|MZ|MS|MV)) | (c?MC:0)|(z?MZ:0)|(s?MS:0)|(v?MV:0);
                retire<=1'b1; state<=S_FETCH0;
            end

            // ---- MULTL rqd,{@rs|rrs}: dest32 = LOW half of the quad = RL(dst|2), i.e.
            //      R[qbase+2]:R[qbase+3]; product overwrites the FULL quad R[qbase..+3]
            //      MSW-first. V never set (same MULTW quirk, verified in MULTL's body). ----
            S_MULTL_RD_HI: begin operand<=din;  state<=S_MULTL_RD_LO; end  // addr=R[src]: hi word
            S_MULTL_RD_LO: begin operand2<=din; state<=S_MULTL_GO; end     // addr=R[src]+2: lo word
            // BATCH 14: MULTL rqd,#imm32 -- imm32 fetch (hi-then-lo via pc, same shape as
            // S_LALU_IMM_HI/LO), lands in the EXISTING S_MULTL_GO unchanged.
            S_MULTLI_HI: begin operand<=din;  pc<=pc+16'd2; state<=S_MULTLI_LO; end
            S_MULTLI_LO: begin operand2<=din; pc<=pc+16'd2; state<=S_MULTL_GO; end
            S_MULTL_GO: begin
                qbase = {dst[3:2],2'b00};
                mul_p64 = $signed({R[qbase+4'd2],R[qbase+4'd3]}) * $signed({operand,operand2});
                c = (mul_p64 < -64'sd2147483647) || (mul_p64 >= 64'sd2147483647);
                z = (mul_p64 == 64'sd0); s = mul_p64[63];
                rwb0_we=1'b1; rwb0_idx=qbase;      rwb0_val=mul_p64[63:48];
                rwb1_we=1'b1; rwb1_idx=qbase+4'd1; rwb1_val=mul_p64[47:32];
                rwb2_we=1'b1; rwb2_idx=qbase+4'd2; rwb2_val=mul_p64[31:16];
                rwb3_we=1'b1; rwb3_idx=qbase+4'd3; rwb3_val=mul_p64[15:0];
                fcw<=(fcw & ~(MC|MZ|MS|MV)) | (c?MC:0)|(z?MZ:0)|(s?MS:0);
                retire<=1'b1; state<=S_FETCH0;
            end

            // ---- DIVL rqd,{@rs|rrs}: dest64 = FULL quad R[qbase..+3] (read live, no
            //      staging needed since it's always already in the regfile); quotient ->
            //      low half (qbase+2/+3), remainder -> high half (qbase/qbase+1), MSW-
            //      first -- mirrors DIV's hi=remainder/lo=quotient packing one level up. ----
            S_DIVL_RD_HI: begin operand<=din;  state<=S_DIVL_RD_LO; end    // addr=R[src]: hi word
            S_DIVL_RD_LO: begin operand2<=din; state<=S_DIVL_GO; end       // addr=R[src]+2: lo word
            // BATCH 14: DIVL rqd,#imm32 -- imm32 fetch, lands in the EXISTING S_DIVL_GO.
            S_DIVLI_HI: begin operand<=din;  pc<=pc+16'd2; state<=S_DIVLI_LO; end
            S_DIVLI_LO: begin operand2<=din; pc<=pc+16'd2; state<=S_DIVL_GO; end
            S_DIVL_GO: begin
                qbase = {dst[3:2],2'b00};
                if (operand==16'h0000 && operand2==16'h0000) begin
                    c=1'b0; z=1'b1; s=1'b0; v=1'b1;   // dest UNCHANGED
                    fcw<=(fcw & ~(MC|MZ|MS|MV)) | (c?MC:0)|(z?MZ:0)|(s?MS:0)|(v?MV:0);
                    retire<=1'b1; state<=S_FETCH0;
                end else begin
                    div_dvd64 = $signed({R[qbase],R[qbase+4'd1],R[qbase+4'd2],R[qbase+4'd3]});
                    div_dvs64 = {{32{operand[15]}}, operand, operand2};
                    dv_qneg <= div_dvd64[63] ^ div_dvs64[63];
                    dv_rneg <= div_dvd64[63];
                    dv_quo  <= div_dvd64[63] ? -div_dvd64 : div_dvd64;
                    dv_dvsr <= div_dvs64[63] ? -div_dvs64 : div_dvs64;
                    dv_rem  <= 64'd0;
                    dv_cnt  <= 7'd0;
                    dv_long <= 1'b1;
                    state   <= S_DIV_BUSY;
                end
            end

            S_DIVL_FIN: begin
                qbase = {dst[3:2],2'b00};
                dv_q_signed = dv_qneg ? -$signed(dv_quo) : $signed(dv_quo);
                dv_r_signed = dv_rneg ? -$signed(dv_rem) : $signed(dv_rem);
                div_q64 = dv_q_signed;
                div_r32 = dv_r_signed[31:0];
                if (div_q64 < -64'sd2147483648 || div_q64 > 64'sd2147483647) begin
                    v = 1'b1;
                    div_qtmp64 = div_q64 >>> 1;
                    if (div_qtmp64 >= -64'sd2147483648 && div_qtmp64 <= 64'sd2147483647) begin
                        div_q64 = (div_qtmp64 < 0) ? -64'sd1 : 64'sd0;
                        c = 1'b1; z=(div_q64[31:0]==32'h00000000); s=div_q64[31];
                    end else begin
                        c = 1'b0; z = 1'b0; s = 1'b0;
                    end
                end else begin
                    v = 1'b0; c = 1'b0; z=(div_q64[31:0]==32'h00000000); s=div_q64[31];
                end
                rwb0_we=1'b1; rwb0_idx=qbase;      rwb0_val=div_r32[31:16];
                rwb1_we=1'b1; rwb1_idx=qbase+4'd1; rwb1_val=div_r32[15:0];
                rwb2_we=1'b1; rwb2_idx=qbase+4'd2; rwb2_val=div_q64[31:16];
                rwb3_we=1'b1; rwb3_idx=qbase+4'd3; rwb3_val=div_q64[15:0];
                fcw<=(fcw & ~(MC|MZ|MS|MV)) | (c?MC:0)|(z?MZ:0)|(s?MS:0)|(v?MV:0);
                retire<=1'b1; state<=S_FETCH0;
            end

            // ---- ADDL/SUBL rrd,{#imm32|@rs|rrs}: 32-bit version of the existing word
            //      S_ALU add/sub (identical carry/overflow shape, one level wider).
            //      `aluop` (ADD/SUB) selects; imm32/@rs stage hi:lo into operand:operand2;
            //      the reg-reg form stages the same pair combinationally at decode. ----
            S_LALU_IMM_HI: begin operand<=din;  pc<=pc+16'd2; state<=S_LALU_IMM_LO; end
            S_LALU_IMM_LO: begin operand2<=din; pc<=pc+16'd2; state<=S_LALU_GO; end
            S_LALU_RD_HI:  begin operand<=din;  state<=S_LALU_RD_LO; end     // addr=R[src]: hi word
            S_LALU_RD_LO:  begin operand2<=din; state<=S_LALU_GO; end        // addr=R[src]+2: lo word
            S_LALU_GO: begin
                a32   = {R[{dst[3:1],1'b0}], R[{dst[3:1],1'b0}+4'd1]};
                val32 = {operand, operand2};
                sum33 = {1'b0,a32} + {1'b0,val32};
                dif33 = {1'b0,a32} - {1'b0,val32};
                if (aluop==ADD) begin
                    res32=sum33[31:0]; c=sum33[32]; z=(res32==32'h00000000); s=res32[31];
                    v=(~a32[31]&~val32[31]&res32[31])|(a32[31]&val32[31]&~res32[31]);
                end else begin
                    res32=dif33[31:0]; c=dif33[32]; z=(res32==32'h00000000); s=res32[31];
                    v=(~val32[31]&a32[31]&~res32[31])|(val32[31]&~a32[31]&res32[31]);
                end
                rwb0_we=1'b1; rwb0_idx={dst[3:1],1'b0};      rwb0_val=res32[31:16];
                rwb1_we=1'b1; rwb1_idx={dst[3:1],1'b0}+4'd1; rwb1_val=res32[15:0];
                fcw<=(fcw & ~(MC|MZ|MS|MV)) | (c?MC:0)|(z?MZ:0)|(s?MS:0)|(v?MV:0);
                retire<=1'b1; state<=S_FETCH0;
            end

            // ==== BATCH 11: SUBL/ADDL/MULTL/DIVL rrd|rqd,addr[,(rs)] (0x52/56/58/5A) --
            // shared 32-bit-operand fetch+read chain (hi@ea, lo@ea+2, staged operand/
            // operand2, exact same staging shape S_LALU_RD_HI/LO and S_MULTL/DIVL_RD_HI/LO
            // already use for their register-indirect siblings), `dwop` picks which
            // EXISTING, already-verified GO state to land in -- zero duplicated math. ====
            S_DWL_FETCH:  begin ea<=din;         pc<=pc+16'd2; state<=S_DWL_RD_HI; end
            S_DWL_FETCHX: begin ea<=din+R[idxr]; pc<=pc+16'd2; state<=S_DWL_RD_HI; end
            S_DWL_RD_HI: begin operand<=din; state<=S_DWL_RD_LO; end // addr=ea: hi word
            S_DWL_RD_LO: begin // addr=ea+2: lo word
                operand2<=din;
                case (dwop)
                    2'd1: state<=S_MULTL_GO;
                    2'd2: state<=S_DIVL_GO;
                    default: state<=S_LALU_GO;  // 2'd0: ADDL/SUBL (aluop already set at decode)
                endcase
            end

            // ==== BATCH 11: MULT/DIV rrd,addr[,(rs)] (0x59/5B) -- shared 16-bit-operand
            // fetch+read chain (same staging shape as S_MULT_RD/S_DIV_RD), `dwop` picks the
            // EXISTING GO state. ====
            S_DWS_FETCH:  begin ea<=din;         pc<=pc+16'd2; state<=S_DWS_RD; end
            S_DWS_FETCHX: begin ea<=din+R[idxr]; pc<=pc+16'd2; state<=S_DWS_RD; end
            S_DWS_RD: begin // addr=ea
                operand<=din;
                state<=(dwop==2'd1) ? S_DIV_GO : S_MULT_GO;
            end

            // ==== BATCH 11: TESTL addr[,(rd)] (0x5C08/0x5CN8) -- new 32-bit read-only
            // compare-to-zero, flags -ZS--- (same formula as the already-implemented
            // register-direct TESTL rrd, 0x9C: Z=({hi,lo}==0), S=hi[15]). ====
            S_TL_FETCH:  begin ea<=din;         pc<=pc+16'd2; state<=S_TL_RD_HI; end
            S_TL_FETCHX: begin ea<=din+R[idxr]; pc<=pc+16'd2; state<=S_TL_RD_HI; end
            S_TL_RD_HI: begin operand<=din; state<=S_TL_RD_LO; end // addr=ea: hi word
            S_TL_RD_LO: begin // addr=ea+2: lo word
                fcw<=(fcw & ~(MZ|MS)) | (({operand,din}==32'h00000000)?MZ:0) | (operand[15]?MS:0);
                retire<=1'b1; state<=S_FETCH0;
            end

            // ---- LDB rbd,addr direct-load: read-only byte load, no RMW hazard. Byte-lane
            //      select uses ea[0] (the FETCHED address' LSB), not a register's LSB --
            //      unlike S_MEMRDB/S_ADDB_RD which read via a register-indirect pointer. ----
            S_LDBDA_FETCH: begin ea<=din; pc<=pc+16'd2; state<=S_LDBDA_RD; end // addr word via pc
            S_LDBDA_RD: begin // addr=ea&~1
                rwb0_we=1'b1; rwb0_idx={1'b0,dst[2:0]}; rwb0_val={2{ea[0] ? din[7:0] : din[15:8]}}; rwb0_be=dst[3]?2'b01:2'b10;
                retire<=1'b1; state<=S_FETCH0;
            end

            // ---- LDB addr,rbs direct-store: word-aligned RMW (the wordacc rule, see
            //      header). `ldbst_val` (Batch 2's combinational RB(src) wire) is reused
            //      unchanged -- `src` here holds the value register's byte-reg-code, same
            //      convention as the existing 0x2E store. ----
            S_LDBSTA_FETCH: begin ea<=din; pc<=pc+16'd2; state<=S_LDBSTA_RD; end // addr word via pc
            S_LDBSTA_RD: begin operand<=din; state<=S_LDBSTA_WR; end            // addr=ea&~1
            S_LDBSTA_WR: begin retire<=1'b1; state<=S_FETCH0; end               // addr=ea&~1,dout=merged,we=1

            // ---- SLLB/SRLB rbd,#imm8: byte version of the existing word S_SHIFT, imm8 =
            //      LOW byte of the fetched word (MAME GET_IMM8 truncates get_operand() to
            //      uint8_t). Sign of imm8 selects direction (negative=SRLB,positive=SLLB),
            //      same convention as the word form. flags CZS--- ; V is NOT touched
            //      (SLLB/SRLB both call CLR_CZS, never SET_V -- doc-comment says "srlb:
            //      CZSV--" but the function body proves otherwise, trusted the code). ----
            S_SHIFTB: begin
                dbyte = dst[3] ? R[dst[2:0]][7:0] : R[dst[2:0]][15:8];
                scnt = din[7] ? (16'h0000 - {8'hFF,din[7:0]}) : {8'h00,din[7:0]};
                cnt = scnt[4:0];
                if (din[7]) begin // negative imm8 -> SRLB
                    res8 = dbyte >> cnt;
                    cbit = (cnt!=5'd0) ? ((dbyte >> (cnt-5'd1)) & 8'h01) : 1'b0;
                end else begin      // positive/zero -> SLLB
                    res8 = dbyte << cnt;
                    cbit = (cnt!=5'd0) ? (((dbyte << (cnt-5'd1)) & 8'h80)!=8'h00) : 1'b0;
                end
                z=(res8==8'h00); s=res8[7];
                rwb0_we=1'b1; rwb0_idx={1'b0,dst[2:0]}; rwb0_val={2{res8}}; rwb0_be=dst[3]?2'b01:2'b10;
                fcw<=(fcw & ~(MC|MZ|MS)) | (cbit?MC:0)|(z?MZ:0)|(s?MS:0);
                pc<=pc+16'd2; retire<=1'b1; state<=S_FETCH0;
            end

            // ==== BATCH 15: SLAB/SRAB rbd,#imm8 (0xB2d9) -- byte arithmetic sibling of
            // S_SHIFTB above, one level narrower than word S_SHIFTA. Right (SRAB) never
            // sets V (verified in SRAB()'s body -- CLR_CZSV then no SET_V call at all,
            // matching the already-established S_SHIFTA/S_SHIFTAL rule); left (SLAB) is
            // bit-identical to SLLB's left branch but DOES set V (SLAB's own body has the
            // `if((result^dest)&S08)SET_V` call that SLLB's lacks). ====
            S_SHIFTAB: begin
                dbyte = dst[3] ? R[dst[2:0]][7:0] : R[dst[2:0]][15:8];
                scnt = din[7] ? (16'h0000 - {8'hFF,din[7:0]}) : {8'h00,din[7:0]};
                cnt = scnt[4:0];
                if (din[7]) begin // negative imm8 -> SRAB (arithmetic, sign-extend)
                    res8 = $signed(dbyte) >>> cnt;
                    cbit = (cnt!=5'd0) ? (($signed(dbyte) >>> (cnt-5'd1)) & 8'h01) : 1'b0;
                    v = 1'b0;
                end else begin // positive/zero -> SLAB (left)
                    res8 = dbyte << cnt;
                    cbit = (cnt!=5'd0) ? (((dbyte << (cnt-5'd1)) & 8'h80)!=8'h00) : 1'b0;
                    v = (res8[7]!=dbyte[7]);
                end
                z=(res8==8'h00); s=res8[7];
                rwb0_we=1'b1; rwb0_idx={1'b0,dst[2:0]}; rwb0_val={2{res8}}; rwb0_be=dst[3]?2'b01:2'b10;
                fcw<=(fcw & ~(MC|MZ|MS|MV)) | (cbit?MC:0)|(z?MZ:0)|(s?MS:0)|(v?MV:0);
                pc<=pc+16'd2; retire<=1'b1; state<=S_FETCH0;
            end

            // ==== BATCH 15: S_SWALLOW1 -- shared no-op tail for every size=2 (opcode +
            // exactly one operand word) instruction in the I/O/EPU/privileged/block-string
            // bucket (see decode-site comments + report). Reads and discards the operand
            // word via `pc` (default addr mux), advances past it, retires with NO register/
            // memory/flag side effects. ====
            S_SWALLOW1: begin pc<=pc+16'd2; retire<=1'b1; state<=S_FETCH0; end

            // ==== BATCH 15: HALT (0x7A00) -- a genuine, INTENTIONAL non-retiring stop
            // (matches real Z8000 hardware: HALT parks instruction fetch until an unmasked
            // interrupt or reset). Deliberately NOT S_ILLEGAL: `illegal` is never asserted
            // here, so the audit correctly reports this word as an accepted, real ISA
            // behavior rather than a decode gap. This core has no NMI/VI accept path
            // (documented in the file header), so there is currently nothing that can ever
            // resume from this state -- a real halt-then-resume would need that
            // infrastructure built first (flagged in report, not implemented here). ====
            S_HALT: ;

            // ==== BATCH 14: SDLB/SDAB/SDLW/SDAW/SDLL/SDAL -- register-count dynamic shifts.
            // `din` here is word2 (read via `pc`, default addr mux); din[11:8] is the count
            // register NUMBER, R[din[11:8]][7:0] its live VALUE (read the SAME cycle -- a
            // plain regfile read, not a memory access). Sign selects direction (negative=
            // right,positive=left, same convention as every immediate shift in this file);
            // magnitude -> `dcnt` via the same negate-if-negative idiom as `scnt`. LEFT-shift
            // result/carry are bit-identical between the L(ogic) and A(rithmetic) forms
            // (matches SDLB()/SDAB()'s C bodies, which only diverge in the RIGHT-shift fill:
            // zero vs sign-extend) -- flags CZSV-- for ALL SIX (verified in each C body: every
            // one calls SET_V on a sign change, unlike the imm8 SLLB/SRLB siblings which
            // never do). ====
            S_SDLB_GO: begin
                dbyte = dst[3] ? R[dst[2:0]][7:0] : R[dst[2:0]][15:8];
                dcnt = R[din[11:8]][7] ? (8'h00 - R[din[11:8]][7:0]) : R[din[11:8]][7:0];
                if (R[din[11:8]][7]) begin // right, logical (zero-fill)
                    res8 = dbyte >> dcnt;
                    cbit = (dcnt!=8'h00) ? ((dbyte >> (dcnt-8'd1)) & 8'h01) : 1'b0;
                end else begin // left
                    res8 = dbyte << dcnt;
                    cbit = (dcnt!=8'h00) ? (((dbyte << (dcnt-8'd1)) & 8'h80)!=8'h00) : 1'b0;
                end
                v=(res8[7]^dbyte[7]); z=(res8==8'h00); s=res8[7];
                rwb0_we=1'b1; rwb0_idx={1'b0,dst[2:0]}; rwb0_val={2{res8}}; rwb0_be=dst[3]?2'b01:2'b10;
                fcw<=(fcw & ~(MC|MZ|MS|MV)) | (cbit?MC:0)|(z?MZ:0)|(s?MS:0)|(v?MV:0);
                pc<=pc+16'd2; retire<=1'b1; state<=S_FETCH0;
            end
            S_SDAB_GO: begin
                dbyte = dst[3] ? R[dst[2:0]][7:0] : R[dst[2:0]][15:8];
                dcnt = R[din[11:8]][7] ? (8'h00 - R[din[11:8]][7:0]) : R[din[11:8]][7:0];
                if (R[din[11:8]][7]) begin // right, arithmetic (sign-extend)
                    res8 = $signed(dbyte) >>> dcnt;
                    cbit = (dcnt!=8'h00) ? (($signed(dbyte) >>> (dcnt-8'd1)) & 8'h01) : 1'b0;
                end else begin // left (identical to SDLB's left branch)
                    res8 = dbyte << dcnt;
                    cbit = (dcnt!=8'h00) ? (((dbyte << (dcnt-8'd1)) & 8'h80)!=8'h00) : 1'b0;
                end
                v=(res8[7]^dbyte[7]); z=(res8==8'h00); s=res8[7];
                rwb0_we=1'b1; rwb0_idx={1'b0,dst[2:0]}; rwb0_val={2{res8}}; rwb0_be=dst[3]?2'b01:2'b10;
                fcw<=(fcw & ~(MC|MZ|MS|MV)) | (cbit?MC:0)|(z?MZ:0)|(s?MS:0)|(v?MV:0);
                pc<=pc+16'd2; retire<=1'b1; state<=S_FETCH0;
            end
            S_SDLW_GO: begin
                a16 = R[dst];
                dcnt = R[din[11:8]][7] ? (8'h00 - R[din[11:8]][7:0]) : R[din[11:8]][7:0];
                if (R[din[11:8]][7]) begin
                    res16 = a16 >> dcnt;
                    cbit = (dcnt!=8'h00) ? ((a16 >> (dcnt-8'd1)) & 16'h1) : 1'b0;
                end else begin
                    res16 = a16 << dcnt;
                    cbit = (dcnt!=8'h00) ? (((a16 << (dcnt-8'd1)) & 16'h8000)!=0) : 1'b0;
                end
                v=(res16[15]^a16[15]); z=(res16==16'h0000); s=res16[15];
                rwb0_we=1'b1; rwb0_idx=dst; rwb0_val=res16;
                fcw<=(fcw & ~(MC|MZ|MS|MV)) | (cbit?MC:0)|(z?MZ:0)|(s?MS:0)|(v?MV:0);
                pc<=pc+16'd2; retire<=1'b1; state<=S_FETCH0;
            end
            S_SDAW_GO: begin
                a16 = R[dst];
                dcnt = R[din[11:8]][7] ? (8'h00 - R[din[11:8]][7:0]) : R[din[11:8]][7:0];
                if (R[din[11:8]][7]) begin
                    res16 = $signed(a16) >>> dcnt;
                    cbit = (dcnt!=8'h00) ? (($signed(a16) >>> (dcnt-8'd1)) & 16'h1) : 1'b0;
                end else begin
                    res16 = a16 << dcnt;
                    cbit = (dcnt!=8'h00) ? (((a16 << (dcnt-8'd1)) & 16'h8000)!=0) : 1'b0;
                end
                v=(res16[15]^a16[15]); z=(res16==16'h0000); s=res16[15];
                rwb0_we=1'b1; rwb0_idx=dst; rwb0_val=res16;
                fcw<=(fcw & ~(MC|MZ|MS|MV)) | (cbit?MC:0)|(z?MZ:0)|(s?MS:0)|(v?MV:0);
                pc<=pc+16'd2; retire<=1'b1; state<=S_FETCH0;
            end
            // Long forms: dst here is a plain register NUMBER (0-15, per Z8002cpu.h's RL()
            // bit0-truncation convention, same {dst[3:1],1'b0} pair-base already used
            // throughout this file for every other RRd operand).
            S_SDLL_GO: begin
                a32 = {R[{dst[3:1],1'b0}], R[{dst[3:1],1'b0}+4'd1]};
                dcnt = R[din[11:8]][7] ? (8'h00 - R[din[11:8]][7:0]) : R[din[11:8]][7:0];
                if (R[din[11:8]][7]) begin
                    res32 = a32 >> dcnt;
                    cbit = (dcnt!=8'h00) ? ((a32 >> (dcnt-8'd1)) & 32'h1) : 1'b0;
                end else begin
                    res32 = a32 << dcnt;
                    cbit = (dcnt!=8'h00) ? (((a32 << (dcnt-8'd1)) & 32'h80000000)!=0) : 1'b0;
                end
                v=(res32[31]^a32[31]); z=(res32==32'h00000000); s=res32[31];
                rwb0_we=1'b1; rwb0_idx={dst[3:1],1'b0};      rwb0_val=res32[31:16];
                rwb1_we=1'b1; rwb1_idx={dst[3:1],1'b0}+4'd1; rwb1_val=res32[15:0];
                fcw<=(fcw & ~(MC|MZ|MS|MV)) | (cbit?MC:0)|(z?MZ:0)|(s?MS:0)|(v?MV:0);
                pc<=pc+16'd2; retire<=1'b1; state<=S_FETCH0;
            end
            S_SDAL_GO: begin
                a32 = {R[{dst[3:1],1'b0}], R[{dst[3:1],1'b0}+4'd1]};
                dcnt = R[din[11:8]][7] ? (8'h00 - R[din[11:8]][7:0]) : R[din[11:8]][7:0];
                if (R[din[11:8]][7]) begin
                    res32 = $signed(a32) >>> dcnt;
                    cbit = (dcnt!=8'h00) ? (($signed(a32) >>> (dcnt-8'd1)) & 32'h1) : 1'b0;
                end else begin
                    res32 = a32 << dcnt;
                    cbit = (dcnt!=8'h00) ? (((a32 << (dcnt-8'd1)) & 32'h80000000)!=0) : 1'b0;
                end
                v=(res32[31]^a32[31]); z=(res32==32'h00000000); s=res32[31];
                rwb0_we=1'b1; rwb0_idx={dst[3:1],1'b0};      rwb0_val=res32[31:16];
                rwb1_we=1'b1; rwb1_idx={dst[3:1],1'b0}+4'd1; rwb1_val=res32[15:0];
                fcw<=(fcw & ~(MC|MZ|MS|MV)) | (cbit?MC:0)|(z?MZ:0)|(s?MS:0)|(v?MV:0);
                pc<=pc+16'd2; retire<=1'b1; state<=S_FETCH0;
            end

            // ---- CPL rrd,addr direct: same compare-only shape as S_CPL_RD_HI/LO (Batch 2)
            //      but addressed via `ea` (a fetched direct address) instead of R[src] --
            //      duplicated rather than rerouted through the existing states, per the
            //      no-touch-existing-bodies rule. ----
            S_CPLA_FETCH: begin ea<=din; pc<=pc+16'd2; state<=S_CPLA_RD_HI; end // addr word via pc
            S_CPLA_RD_HI: begin operand<=din; state<=S_CPLA_RD_LO; end         // addr=ea: hi word
            S_CPLA_RD_LO: begin                                                // addr=ea+2: lo word
                dif33 = {1'b0, R[{dst[3:1],1'b0}], R[{dst[3:1],1'b0}+4'd1]} - {1'b0, operand, din};
                fcw<=(fcw & ~(MC|MZ|MS|MV)) | (dif33[32]?MC:0)|((dif33[31:0]==32'h00000000)?MZ:0)|(dif33[31]?MS:0)
                   | (((~operand[15] & R[{dst[3:1],1'b0}][15] & ~dif33[31]) |
                       (operand[15] & ~R[{dst[3:1],1'b0}][15] &  dif33[31])) ? MV:0);
                retire<=1'b1; state<=S_FETCH0;
            end

            // ==== BATCH 4: register-indexed addr(Rx) EA datapath (CENTERPIECE) =========
            // Each state below fetches the addr word (via `pc`, identical timing to the
            // sibling direct-form *_FETCH state) and, IN THE SAME CYCLE, adds R[idxr] to
            // it (plain 16-bit Verilog add -- reg-width truncation reproduces z8000cpu.h
            // addr_add()'s `&0xffff` exactly), then joins the EXISTING, UNMODIFIED direct-
            // form RD/WR pipeline. Proof the NIB2==0 direct path is unchanged: these are
            // new states reached ONLY from new (NIB2!=0) decode arms -- the original
            // S_LDBDA_FETCH/S_LDBSTA_FETCH/S_CPLA_FETCH/S_INCDA_FETCH bodies above (Batch 3)
            // are not touched by one character, and the direct-form decode arms (NIB2==0,
            // a few lines up in S_FETCH0) still transition to them exactly as before. ----
            S_LDBDAX_FETCH:  begin ea<=din+R[idxr]; pc<=pc+16'd2; state<=S_LDBDA_RD;   end // -> existing S_LDBDA_RD
            S_LDBSTAX_FETCH: begin ea<=din+R[idxr]; pc<=pc+16'd2; state<=S_LDBSTA_RD;  end // -> existing S_LDBSTA_RD
            S_CPLAX_FETCH:   begin ea<=din+R[idxr]; pc<=pc+16'd2; state<=S_CPLA_RD_HI; end // -> existing S_CPLA_RD_HI
            S_INCDAX_FETCH:  begin ea<=din+R[idxr]; pc<=pc+16'd2; state<=S_INCDA_RD;   end // -> existing S_INCDA_RD

            // ---- RESB/SETB @Rd,#imm4 (byte RMW; bmask/bitop_set shared with the existing
            //      word RES/SET, S_BITW_RD/WR). Lane = R[dst][0]. ----
            S_RESETB_RD: begin operand<=din; state<=S_RESETB_WR; end  // addr=R[dst]&~1
            S_RESETB_WR: begin retire<=1'b1; state<=S_FETCH0; end     // addr=R[dst]&~1,dout=merged,we=1

            // ---- EXB rbd,@rs (byte RMW exchange; addr=R[src]&~1, lane=R[src][0]) ----
            S_EXB_RD: begin operand<=din; state<=S_EXB_WR; end        // addr=R[src]&~1
            S_EXB_WR: begin                                           // addr=R[src]&~1,dout=merged,we=1
                // lane = R[src][0] (address LSB), NOT src[0] (the pointer register NUMBER)
                rwb0_we=1'b1; rwb0_idx={1'b0,dst[2:0]}; rwb0_val={2{R[src][0] ? operand[7:0] : operand[15:8]}}; rwb0_be=dst[3]?2'b01:2'b10;
                retire<=1'b1; state<=S_FETCH0;
            end

            // ==== BATCH 5: direct-address(+index) RESB/RES/SETB/SET/BITB/BIT/EXB/EX =====
            // Each FETCH computes ea<=din (direct) or ea<=din+R[idxr] (indexed, the Batch-4
            // *X_FETCH shape), then joins a shared RD (and WR, for ops that write) tail.
            // ---- RESB/SETB addr[,(rd)],#imm4 (byte RMW; bmask/bitop_set shared with the
            //      RES/SET word pair below). Lane = ea[0]. ----
            S_DAB_RESB_FETCH:  begin ea<=din;         pc<=pc+16'd2; state<=S_DAB_RESB_RD; end
            S_DAB_RESBX_FETCH: begin ea<=din+R[idxr]; pc<=pc+16'd2; state<=S_DAB_RESB_RD; end
            S_DAB_RESB_RD: begin operand<=din; state<=S_DAB_RESB_WR; end  // addr=ea&~1
            S_DAB_RESB_WR: begin retire<=1'b1; state<=S_FETCH0; end       // addr=ea&~1,dout=merged,we=1

            // ---- RES/SET addr[,(rd)],#imm4 (word RMW; bitop_set: 0=AND~bit 1=OR bit). ----
            S_DAB_RESW_FETCH:  begin ea<=din;         pc<=pc+16'd2; state<=S_DAB_RESW_RD; end
            S_DAB_RESWX_FETCH: begin ea<=din+R[idxr]; pc<=pc+16'd2; state<=S_DAB_RESW_RD; end
            S_DAB_RESW_RD: begin operand<=din; state<=S_DAB_RESW_WR; end  // addr=ea
            S_DAB_RESW_WR: begin retire<=1'b1; state<=S_FETCH0; end       // addr=ea,dout=merged,we=1

            // ---- BITB addr[,(rd)],#imm4 (read-only byte, flags -Z----; Z=1 means the
            //      tested bit is 0). Lane = ea[0]. ----
            S_DAB_BITB_FETCH:  begin ea<=din;         pc<=pc+16'd2; state<=S_DAB_BITB_RD; end
            S_DAB_BITBX_FETCH: begin ea<=din+R[idxr]; pc<=pc+16'd2; state<=S_DAB_BITB_RD; end
            S_DAB_BITB_RD: begin // addr=ea&~1
                dbyte = ea[0] ? din[7:0] : din[15:8];
                fcw<=(fcw & ~MZ) | (((dbyte & bmask[7:0])==0) ? MZ : 16'h0000);
                retire<=1'b1; state<=S_FETCH0;
            end

            // ---- BIT addr[,(rd)],#imm4 (read-only word, flags -Z----). ----
            S_DAB_BITW_FETCH:  begin ea<=din;         pc<=pc+16'd2; state<=S_DAB_BITW_RD; end
            S_DAB_BITWX_FETCH: begin ea<=din+R[idxr]; pc<=pc+16'd2; state<=S_DAB_BITW_RD; end
            S_DAB_BITW_RD: begin // addr=ea
                fcw<=(fcw & ~MZ) | (((din & bmask)==0) ? MZ : 16'h0000);
                retire<=1'b1; state<=S_FETCH0;
            end

            // ---- EXB rbd,addr[(rs)] (byte RMW exchange; flags ------, untouched). `dst`
            //      holds the value register's byte-reg-code; reuses the existing generic
            //      `exb_val` wire unchanged. Lane = ea[0]. ----
            S_DAB_EXB_FETCH:  begin ea<=din;         pc<=pc+16'd2; state<=S_DAB_EXB_RD; end
            S_DAB_EXBX_FETCH: begin ea<=din+R[idxr]; pc<=pc+16'd2; state<=S_DAB_EXB_RD; end
            S_DAB_EXB_RD: begin operand<=din; state<=S_DAB_EXB_WR; end    // addr=ea&~1
            S_DAB_EXB_WR: begin                                           // addr=ea&~1,dout=merged,we=1
                rwb0_we=1'b1; rwb0_idx={1'b0,dst[2:0]}; rwb0_val={2{ea[0] ? operand[7:0] : operand[15:8]}}; rwb0_be=dst[3]?2'b01:2'b10;
                retire<=1'b1; state<=S_FETCH0;
            end

            // ---- EX rd,addr[(rs)] (word exchange; flags ------, untouched). ----
            S_DAB_EXW_FETCH:  begin ea<=din;         pc<=pc+16'd2; state<=S_DAB_EXW_RD; end
            S_DAB_EXWX_FETCH: begin ea<=din+R[idxr]; pc<=pc+16'd2; state<=S_DAB_EXW_RD; end
            S_DAB_EXW_RD: begin operand<=din; state<=S_DAB_EXW_WR; end    // addr=ea
            S_DAB_EXW_WR: begin rwb0_we=1'b1; rwb0_idx=dst; rwb0_val=operand; retire<=1'b1; state<=S_FETCH0; end // addr=ea,dout=R[dst](old),we=1

            // ==== BATCH 5 PART 2: register-indirect @Rd simple family (0x0C/0x0D) =======
            // ---- TESTB @rd (read-only byte, flags -ZSP--; same formula as register-direct
            //      TESTB rbd). ----
            S_TESTBI_RD: begin // addr=R[dst]&16'hFFFE
                dbyte = R[dst][0] ? din[7:0] : din[15:8];
                p = (~^dbyte);
                fcw<=(fcw & ~(MZ|MS|MV)) | ((dbyte==8'h00)?MZ:0)|(dbyte[7]?MS:0)|(p?MV:0);
                retire<=1'b1; state<=S_FETCH0;
            end

            // ---- TSETB @rd (byte RMW; S = old bit7, new value unconditionally 0xFF). ----
            S_TSETBI_RD: begin // addr=R[dst]&16'hFFFE
                dbyte = R[dst][0] ? din[7:0] : din[15:8];
                fcw<=(fcw & ~MS) | (dbyte[7]?MS:0);
                operand<=din; state<=S_TSETBI_WR;
            end
            S_TSETBI_WR: begin retire<=1'b1; state<=S_FETCH0; end  // addr=R[dst]&16'hFFFE,dout=merged(0xFF lane),we=1

            // ---- CLRB @rd (byte RMW, unconditional 0x00, flags ------). ----
            S_CLRBI_RD: begin operand<=din; state<=S_CLRBI_WR; end // addr=R[dst]&16'hFFFE
            S_CLRBI_WR: begin retire<=1'b1; state<=S_FETCH0; end  // addr=R[dst]&16'hFFFE,dout=merged(0x00 lane),we=1

            // ---- COM @rd (word RMW; same formula as register-direct COM rd). ----
            S_COMI_RD: begin
                res16 = ~din;
                fcw<=(fcw & ~(MZ|MS)) | ((res16==16'h0000)?MZ:0)|(res16[15]?MS:0);
                operand<=res16; state<=S_COMI_WR;
            end
            S_COMI_WR: begin retire<=1'b1; state<=S_FETCH0; end   // addr=R[dst],dout=operand,we=1

            // ---- CP @rd,#imm16 (read-only compare; same formula as the word CP aluop). ----
            S_CPRI_IMM: begin operand<=din; pc<=pc+16'd2; state<=S_CPRI_RD; end // imm16 via pc
            S_CPRI_RD: begin // addr=R[dst]
                dif17 = {1'b0,din} - {1'b0,operand};
                v = (~operand[15]&din[15]&~dif17[15])|(operand[15]&~din[15]&dif17[15]);
                fcw<=(fcw & ~(MC|MZ|MS|MV))
                   | (dif17[16]?MC:0)|((dif17[15:0]==16'h0000)?MZ:0)|(dif17[15]?MS:0)|(v?MV:0);
                retire<=1'b1; state<=S_FETCH0;
            end

            // ---- NEG @rd (word RMW; same formula as register-direct NEG rd). ----
            S_NEGI_RD: begin
                res16 = 16'h0000 - din;
                v = (res16==16'h8000);
                fcw<=(fcw & ~(MC|MZ|MS|MV))
                   | ((res16!=16'h0000)?MC:0)|((res16==16'h0000)?MZ:0)|(res16[15]?MS:0)|(v?MV:0);
                operand<=res16; state<=S_NEGI_WR;
            end
            S_NEGI_WR: begin retire<=1'b1; state<=S_FETCH0; end   // addr=R[dst],dout=operand,we=1

            // ---- TEST @rd (read-only word, flags -ZS----; same formula as DA_TST). ----
            S_TESTI_RD: begin // addr=R[dst]
                fcw<=(fcw & ~(MZ|MS)) | ((din==16'h0000)?MZ:0)|(din[15]?MS:0);
                retire<=1'b1; state<=S_FETCH0;
            end

            // ---- TSET @rd (word RMW; S = old bit15, new value unconditionally 0xFFFF). ----
            S_TSETI_RD: begin
                fcw<=(fcw & ~MS) | (din[15]?MS:0);
                state<=S_TSETI_WR;
            end
            S_TSETI_WR: begin retire<=1'b1; state<=S_FETCH0; end  // addr=R[dst],dout=16'hFFFF,we=1

            // ---- CLR @rd (plain word write, no read needed, flags ------). ----
            S_CLRI_WR: begin retire<=1'b1; state<=S_FETCH0; end   // addr=R[dst],dout=16'h0000,we=1

            // ==== BATCH 6: ALU addr[,(rs)] direct/indexed (0x40-0x4B) ===================
            // ---- word form: FETCH computes ea (direct or indexed), RD reads @ea and
            // stages `operand`, then joins the EXISTING S_ALU tail unchanged. ----
            S_ALUA_FETCH:  begin ea<=din;         pc<=pc+16'd2; state<=S_ALUA_RD; end
            S_ALUAX_FETCH: begin ea<=din+R[idxr]; pc<=pc+16'd2; state<=S_ALUA_RD; end
            S_ALUA_RD: begin operand<=din; state<=S_ALU; end             // addr=ea

            // ---- byte form: same shape, byte lane select via ea[0] (the fetched/
            // indexed address' LSB), joins the EXISTING S_ALUB tail. ----
            S_ALUAB_FETCH:  begin ea<=din;         pc<=pc+16'd2; state<=S_ALUAB_RD; end
            S_ALUABX_FETCH: begin ea<=din+R[idxr]; pc<=pc+16'd2; state<=S_ALUAB_RD; end
            S_ALUAB_RD: begin operand[7:0]<= ea[0] ? din[7:0] : din[15:8]; state<=S_ALUB; end // addr=ea&~1

            // ==== BATCH 6: CPL rrd,imm32 (0x1000-0x100F) ================================
            // Two words via `pc` (default mux, not `ea`), mirrors S_LDL_IMM_HI/LO's shape.
            S_CPLI_HI: begin operand<=din; pc<=pc+16'd2; state<=S_CPLI_LO; end
            S_CPLI_LO: begin
                dif33 = {1'b0, R[{dst[3:1],1'b0}], R[{dst[3:1],1'b0}+4'd1]} - {1'b0, operand, din};
                fcw<=(fcw & ~(MC|MZ|MS|MV)) | (dif33[32]?MC:0)|((dif33[31:0]==32'h00000000)?MZ:0)|(dif33[31]?MS:0)
                   | (((~operand[15] & R[{dst[3:1],1'b0}][15] & ~dif33[31]) |
                       (operand[15] & ~R[{dst[3:1],1'b0}][15] &  dif33[31])) ? MV:0);
                pc<=pc+16'd2; retire<=1'b1; state<=S_FETCH0;
            end

            // ==== BATCH 6: byte INC/DEC addr[,(rs)],#n (0x68/0x6A) =======================
            S_INCDAB_FETCH:  begin ea<=din;         pc<=pc+16'd2; state<=S_INCDAB_RD; end
            S_INCDABX_FETCH: begin ea<=din+R[idxr]; pc<=pc+16'd2; state<=S_INCDAB_RD; end
            S_INCDAB_RD: begin // addr=ea&16'hFFFE: read old word, merge new byte @ea[0]
                i4p1 = {1'b0,mcnt} + 5'd1;
                dbyte = ea[0] ? din[7:0] : din[15:8];
                if (aluop==ADD) begin
                    incb_sum = {1'b0,dbyte} + {4'd0,i4p1};
                    v = (~dbyte[7]) & incb_sum[7]; res8 = incb_sum[7:0];
                end else begin
                    add8 = {1'b0,dbyte} - {4'd0,i4p1};
                    v = dbyte[7] & ~add8[7]; res8 = add8[7:0];
                end
                operand <= ea[0] ? {din[15:8], res8} : {res8, din[7:0]};
                fcw <= (fcw & ~(MZ|MS|MV)) | ((res8==8'h00)?MZ:0)|(res8[7]?MS:0)|(v?MV:0);
                state<=S_INCDAB_WR;
            end
            S_INCDAB_WR: begin retire<=1'b1; state<=S_FETCH0; end  // addr=ea&16'hFFFE,dout=operand,we=1

            // ==== BATCH 6: missing indexed arms for LD rd,addr(rs) / LD addr(rs),rs =====
            // Join the EXISTING, unmodified S_DA_RD/S_DA_WR tail (Batch-4 X_FETCH shape).
            S_LDAX_FETCH:  begin ea<=din+R[idxr]; pc<=pc+16'd2; state<=S_DA_RD; end
            S_LDSAX_FETCH: begin ea<=din+R[idxr]; pc<=pc+16'd2; state<=S_DA_WR; end

            S_INCBI_RD: begin // addr=R[dst]&16'hFFFE: byte RMW, lane=R[dst][0]
                i4p1 = {1'b0,mcnt} + 5'd1;
                dbyte = R[dst][0] ? din[7:0] : din[15:8];
                if (aluop==ADD) begin
                    incb_sum = {1'b0,dbyte} + {4'd0,i4p1};
                    v = (~dbyte[7]) & incb_sum[7]; res8 = incb_sum[7:0];
                end else begin
                    add8 = {1'b0,dbyte} - {4'd0,i4p1};
                    v = dbyte[7] & ~add8[7]; res8 = add8[7:0];
                end
                operand <= R[dst][0] ? {din[15:8], res8} : {res8, din[7:0]};
                fcw <= (fcw & ~(MZ|MS|MV)) | ((res8==8'h00)?MZ:0)|(res8[7]?MS:0)|(v?MV:0);
                state<=S_INCBI_WR;
            end
            S_INCBI_WR: begin retire<=1'b1; state<=S_FETCH0; end  // addr=R[dst]&16'hFFFE,dout=operand,we=1

            S_INCWI_RD: begin // addr=R[dst]&16'hFFFE: word RMW, mirrors S_INCDA_RD one
                               // level more direct (EA=R[dst] instead of a fetched addr)
                i4p1 = {1'b0,mcnt} + 5'd1;
                if (aluop==ADD) begin
                    incw_sum = {1'b0,din} + {12'd0,i4p1};
                    v = (~din[15]) & incw_sum[15];
                    operand <= incw_sum[15:0];
                    fcw<=(fcw & ~(MZ|MS|MV)) | ((incw_sum[15:0]==16'h0000)?MZ:0)|(incw_sum[15]?MS:0)|(v?MV:0);
                end else begin
                    dif17 = {1'b0,din} - {12'd0,i4p1};
                    v = din[15] & ~dif17[15];
                    operand <= dif17[15:0];
                    fcw<=(fcw & ~(MZ|MS|MV)) | ((dif17[15:0]==16'h0000)?MZ:0)|(dif17[15]?MS:0)|(v?MV:0);
                end
                state<=S_INCWI_WR;
            end
            S_INCWI_WR: begin retire<=1'b1; state<=S_FETCH0; end  // addr=R[dst]&16'hFFFE,dout=operand,we=1

            S_ILLEGAL: ;
            default: state<=S_FETCH0;
            endcase

            // ============ SHARED REGISTER-FILE WRITEBACK BUS ==========================
            // AREA FIX 2026-07-28. Previously each of the ~111 R[] write sites scattered
            // across the ~180-state case above assigned R[<index expr>] <= <value expr>
            // directly. Synthesis has to build, for EVERY bit of EVERY one of the 16
            // registers, a mux selecting among all ~111 possible next-values -- Quartus's
            // own map.rpt fan-in table showed individual R[] bits needing 110..151-input
            // muxes at ~146-200 LEs per bit, doubled because z8002 is instantiated twice
            // (sub1+sub2). That is what made synthesis alone take ~15 minutes, and it got
            // strictly worse with every state added.
            //
            // Now every write site instead drives one of four shared channels, and the
            // register file is written from exactly one place: here. The wide value mux
            // now exists ONCE per channel on a 16-bit bus instead of being replicated
            // across all 16 registers, and each register bit sees only a 4-channel mux.
            //
            // Channel count = the maximum number of DISTINCT registers any single state
            // writes: 4, set by the MULTL/DIVL quad-register (R[qbase..qbase+3]) writes.
            // Two channels cover the 32-bit register-pair (RRd) and swap/pop forms; the
            // third is used only by S_L32_RD_LO (pair + pointer writeback).
            //
            // Semantics deliberately preserved from the original code:
            //  * Channels are applied in ascending order, so a later channel overrides an
            //    earlier one on the same target -- matching "last non-blocking assignment
            //    in the block wins", which is what the old aliasing cases (EX rd,rd and
            //    POP rd,@rd) relied on.
            //  * Priority is resolved PER BYTE LANE, not per register. EXB RHn,RLn writes
            //    both halves of the SAME register from two channels in one cycle; a
            //    per-register priority would incorrectly drop one of them.
            //  * rwb*_be is {high-byte enable, low-byte enable}. Byte writes replicate the
            //    byte into both halves of rwb*_val and let the mask pick the lane, so the
            //    Z8000 RH/RL convention (register-field bit 3 set => RL => bits [7:0])
            //    stays exactly where the original code had it.
            //  * All reads of R[] elsewhere still see the OLD value: R[] is written only by
            //    non-blocking assignments, and the channel signals are blocking temporaries
            //    computed at the same point in the block the original write sat at.
            if (rwb0_we) begin
                if (rwb0_be[0]) R[rwb0_idx][7:0]  <= rwb0_val[7:0];
                if (rwb0_be[1]) R[rwb0_idx][15:8] <= rwb0_val[15:8];
            end
            if (rwb1_we) begin
                if (rwb1_be[0]) R[rwb1_idx][7:0]  <= rwb1_val[7:0];
                if (rwb1_be[1]) R[rwb1_idx][15:8] <= rwb1_val[15:8];
            end
            if (rwb2_we) begin
                if (rwb2_be[0]) R[rwb2_idx][7:0]  <= rwb2_val[7:0];
                if (rwb2_be[1]) R[rwb2_idx][15:8] <= rwb2_val[15:8];
            end
            if (rwb3_we) begin
                if (rwb3_be[0]) R[rwb3_idx][7:0]  <= rwb3_val[7:0];
                if (rwb3_be[1]) R[rwb3_idx][15:8] <= rwb3_val[15:8];
            end
        end
    end

    // verilator lint_off UNUSED
    wire _unused = &{1'b0, wait_n, nmi_n, vi_n};
    // verilator lint_on UNUSED
endmodule
