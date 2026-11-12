// ============================================================================
//  z8002.sv -- Zilog Z8002 (non-segmented Z8000) CPU core.
//  Behavioural reference: MAME z8000ops.hxx / z8000tbl.hxx / z8000cpu.h (DAB table ported from MAME).
//  Big-endian words; PC even; SP = R15; byte reg n -> R[n&7] high if n < 8 else low;
//  FCW C=b7 Z=b6 S=b5 P/V=b4 DA=b3 H=b2; reset reads FCW @2, PC @4. NVI fully implemented.
//  Not implemented (unused by Pole Position): VI / NMI accept, segmentation, wait_n, NSP/SSP swap.
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
    // DAB result ROM, ported verbatim from MAME z8000 (Z8000_dab[])
    reg [8:0] dab_rom [0:2047];
    `include "z8002_dab_rom.svh"
    reg [15:0] target_cycles, cyc_count;
    `include "z8002_cycle_lookup.svh"
    reg [15:0] pc, fcw, ir, operand, ea;
    reg [15:0] psap;  // PSA pointer (control reg, LDCTL psapoff) - reset 0
    reg        nvi_pending;  // set on nvi_n ASSERT edge, cleared on NVI accept
    reg        nvi_n_d;  // previous nvi_n, for edge detect
    // real internal-trap infrastructure (EPU/privileged-instruction trap/system-call), modeled EXACTLY on the ...
    reg [15:0] trap_vec;
    localparam [15:0] VEC_EPU=16'h0004, VEC_TRAP=16'h0008, VEC_SYSCALL=16'h000C;

    // real 0x3A/0x3B port I/O
    reg [3:0]  io_sub;  // block forms: word1 NIB3 (0000-0011 increment grp, 1000-1011
                          // io_sub[3]=group(0=inc,1=dec), io_sub[1]= direction(0=IN,1=OUT), io_sub[0]=S-bit(special-I/O + the "bump both ...
    reg        io_wide;  // 0=byte(0x3A) 1=word(0x3B) -- shared by single AND block forms
    reg        io_dir;  // single-I/O forms only: 0=IN(port->dst) 1=OUT(src->port)
    reg [3:0]  cntreg;  // block forms: word2 NIB1, register HOLDING the loop count
    reg [3:0]  iocc;  // block forms: word2 NIB3, raw repeat-selector field (tested
                          // against exactly 0, NOT run through cc_true()
    reg [15:0] pc_orig;  // block forms: address of the opcode word, latched for the
                          // repeat-rewind (MAME's `m_pc -= 4`) combinational scratch for the block-form register bump (S_IOB_WR)
    reg signed [15:0] iob_step;
    reg               iob_both;
    reg [3:0]  dst, src;
    reg [2:0]  aluop, daop;
    reg        retire, illegal;
    // LDM loop counter (field value = count-1, 0..15)
    reg [3:0]  mcnt;
    reg        l32wb;
    // operand2 = low-word buffer for the 0x11 PUSHL @Rd,@Rs mem-to-mem pump (hi word already re-written via `operand` ...
    reg [15:0] operand2, bmask;
    reg        bitop_set;
    reg        lda76_has_src;
    reg        jpx;
    // RQ (quad, 4x16-bit) base register index for MULTL/DIVL = {dst[3:2],2'b00} (MAME `#define RQ(n) ...
    reg [3:0]  qbase;
    // index register nibble for register-indexed direct-address EA (addr(Rx))
    reg [3:0]  idxr;

    // sub-op selectors for the 0x4C (byte, dacop) / 0x4D (word, dadop) direct- address static-op family
    reg [2:0]  dacop;
    reg [1:0]  dadop;
    reg [7:0]  dacres;

    // `dwop` selects the sub-operation for the shared 0x52/56/58/5A (32-bit) and 0x59/5B (16-bit) direct-address ...
    reg [1:0]  dwop;
    reg        ldmx;

    // direct/indirect memory access op (for the EA states)
    localparam [2:0] DA_LDR=0, DA_STR=1, DA_STI=2, DA_CLR=3, DA_TST=4, DA_CPI=5;

    localparam [5:0] S_RST_FCW=0, S_RST_PC=1, S_FETCH0=2, S_IMM=3, S_MEMRD=4,
                     S_ALU=5, S_MEMWR=6, S_SHIFT=7, S_JP=8, S_ADDB_RD=9, S_ILLEGAL=10,
                     S_DA_FETCH=11, S_DA_IMM=12, S_DA_RD=13, S_DA_WR=14,
                     // NVI accept: push PC/FCW/vec (SP predecrement store x3), then read new FCW/PC from the PSA NVI vector ...
                     S_NVI_PC=15, S_NVI_FCW=16, S_NVI_VEC=17, S_NVI_RDFCW=18, S_NVI_RDPC=19,
                     // IRET: pop vec(discard)/FCW/PC (SP postincrement load x3)
                     S_IRET_VEC=20, S_IRET_FCW=21, S_IRET_PC=22;
    // stack + control flow
    localparam [5:0]
                     // CALL addr/@Rd, CALR: fetch target(direct only)->push PC->jump
                     S_CALL_FETCH=23, S_CALL_PUSH=24,
                     // RET cc (taken): pop PC
                     S_RET_POP=25,
                     // PUSH (word): shared push-commit + per-source-mode fetch chains
                     S_PUSH_W=26, S_PUSHI_FETCH=27, S_PUSHA_FETCH=28, S_PUSHA_RD=29,
                     // POP (word): register-dest direct; addr-dest fetch/pop/store chain
                     S_POP_R=30, S_POPA_FETCH=31, S_POPA_POP=32, S_POPA_WR=33,
                     // shared 32-bit (long) read/write pump, 2 words hi-then-lo at `ea`/ea+2: used by PUSHL/POPL (reg forms) and LDL ...
                     S_L32_RD_HI=34, S_L32_RD_LO=35, S_L32_WR_HI=36, S_L32_WR_LO=37,
                     // LDL RRd,imm32 (2-word immediate, own chain: reads via pc not ea)
                     S_LDL_IMM_HI=38, S_LDL_IMM_LO=39,
                     // LDL RRd,addr / LDL addr,RRs: fetch direct addr, then feed L32 pump
                     S_LDLA_FETCH=40, S_LDLSA_FETCH=41,
                     // LDM rd,@rs,n / LDM @rd,rs,n: fetch word2 (dst/src start + count), then self-looping word-at-a-time pump until ...
                     S_LDM_L_FETCH2=42, S_LDM_L_RD=43, S_LDM_S_FETCH2=44, S_LDM_S_WR=45;
    localparam [6:0]
                     // indirect-indirect PUSHL/PUSH/POP (0x11/0x13/0x17)
                     S_PLII_RD_HI=46, S_PLII_RD_LO=47, S_PLII_WR_HI=48, S_PLII_WR_LO=49,
                     S_PUSHII_RD=50, S_POPII_RD=51, S_POPII_WR=52,
                     // shared byte-ALU/LDB pipeline (mirrors S_IMM/S_MEMRD/S_ALU)
                     S_IMMB=53, S_MEMRDB=54, S_ALUB=55,
                     // LDB @Rd,rbs store (0x2E): word-aligned read-modify-write, because `wordacc` is left unconnected downstream ...
                     S_LDBST_RD=56, S_LDBST_WR=57,
                     // CPL rrd,@rs (0x10) / rrd,rrs (0x90): compare-only, no writeback
                     S_CPL_RD_HI=58, S_CPL_RD_LO=59, S_CPL_RR=60,
                     // BIT/BITB @Rd,#imm4 (0x27/0x26): read-only, no RMW hazard
                     S_BIT_RD=61, S_BITB_RD=62,
                     // RES/SET @Rd,#imm4 (0x23/0x25): word-only RMW (safe, word-aligned)
                     S_BITW_RD=63, S_BITW_WR=64,
                     // EX rd,@rs (0x2D): word-only exchange (safe); byte EXB (0x2C) deferred
                     S_EX_RD=65, S_EX_WR=66;
    localparam [6:0]
                     // INC/DEC addr,#n direct (0x69/0x6B, NIB2=0): fetch addr, RMW word (wordacc-safe, word-aligned by construction)
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
    localparam [6:0]
                     // register-indexed addr(Rx) EA datapath: after the addr word is fetched (via pc, identical timing to every direct ...
                     S_LDBDAX_FETCH=96, S_LDBSTAX_FETCH=97, S_CPLAX_FETCH=98,
                     S_INCDAX_FETCH=99,
                     // RESB/SETB @Rd,#imm4 (0x22/0x24, NIB2=dst!=0): byte RMW, shares bmask/bitop_set with the existing word RES/SET ...
                     S_RESETB_RD=100, S_RESETB_WR=101,
                     // EXB rbd,@rs (0x2C, NIB2=src!=0): byte RMW exchange, mirrors the existing word EX (S_EX_RD/WR) merged with the ...
                     S_EXB_RD=102, S_EXB_WR=103;
    localparam [6:0]
                     // direct-address(+index) RESB/SETB (0x62/0x64, byte RMW, share bmask/ bitop_set like the existing word RES/SET)
                     S_DAB_RESB_FETCH=104, S_DAB_RESBX_FETCH=105,
                     S_DAB_RESB_RD=106, S_DAB_RESB_WR=107,
                     // direct-address(+index) RES/SET (0x63/0x65, word RMW, share bmask/ bitop_set).
                     S_DAB_RESW_FETCH=108, S_DAB_RESWX_FETCH=109,
                     S_DAB_RESW_RD=110, S_DAB_RESW_WR=111,
                     // direct-address(+index) BITB (0x66, read-only byte, flags -Z----).
                     S_DAB_BITB_FETCH=112, S_DAB_BITBX_FETCH=113, S_DAB_BITB_RD=114,
                     // direct-address(+index) BIT (0x67, read-only word, flags -Z----).
                     S_DAB_BITW_FETCH=115, S_DAB_BITWX_FETCH=116, S_DAB_BITW_RD=117,
                     // direct-address(+index) EXB (0x6C, byte RMW exchange
                     S_DAB_EXB_FETCH=118, S_DAB_EXBX_FETCH=119,
                     S_DAB_EXB_RD=120, S_DAB_EXB_WR=121,
                     // direct-address(+index) EX (0x6D, word exchange).
                     S_DAB_EXW_FETCH=122, S_DAB_EXWX_FETCH=123,
                     S_DAB_EXW_RD=124, S_DAB_EXW_WR=125;
    // register-indirect @Rd simple family, 0x0C/0x0D) ---- State count exceeded the 7-bit budget (max 127)
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
                     // 0x40-0x4B ALU addr[,(rs)]: FETCH computes ea (direct/indexed, Batch-4 shape), RD reads @ea and stages ...
                     S_ALUA_FETCH=141,  S_ALUAX_FETCH=142,  S_ALUA_RD=143,
                     S_ALUAB_FETCH=144, S_ALUABX_FETCH=145, S_ALUAB_RD=146,
                     // 0x1000-0x100F CPL rrd,imm32: mirrors S_LDL_IMM_HI/LO's "two words via pc, no ea" shape feeding the existing CPL ...
                     S_CPLI_HI=147, S_CPLI_LO=148,
                     // 0x68/0x6A INCB/DECB addr[,(rs)],#n: byte sibling of S_INCDA_FETCH/ RD/WR, ea[0]-lane merge (same shape as ...
                     S_INCDAB_FETCH=149, S_INCDABX_FETCH=150, S_INCDAB_RD=151, S_INCDAB_WR=152,
                     // 0x61/0x6F missing indexed arms: compute ea<=din+R[idxr] then join the EXISTING, unmodified S_DA_RD/S_DA_WR tail ...
                     S_LDAX_FETCH=153, S_LDSAX_FETCH=154,
                     // 0x28-0x2B INCB/INC/DECB/DEC @rd: EA=R[dst] directly (no address word to fetch at all)
                     S_INCBI_RD=155, S_INCBI_WR=156, S_INCWI_RD=157, S_INCWI_WR=158;
    localparam [7:0]
                     S_DIV_BUSY=159, S_DIV_FIN=160, S_DIVL_FIN=161;
    // SLA/SRA word, SLAL/SRAL long, SLLL/SRLL long ---- (0xB3 NIB3={9,D,5})
    localparam [7:0]
                     S_SHIFTA=162, S_SHIFTAL=163, S_SHIFTL=164;
    localparam [7:0]
                     S_LDA76_FETCH=165, S_LDA76_GO=166;
    // remaining ISA gaps found via full-trace audit against the user's MAME boot-to-attract traces ...
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
                     // Z52/Z56/Z58/Z5A (SUBL/ADDL/MULTL/DIVL rrd|rqd,addr[,(rs)]): shared 32-bit-operand fetch+read chain, `dwop` ...
                     S_DWL_FETCH=187, S_DWL_FETCHX=188, S_DWL_RD_HI=189, S_DWL_RD_LO=190,
                     // Z59/Z5B (MULT/DIV rrd,addr[,(rs)]): shared 16-bit-operand chain, `dwop` (0=MULT,1=DIV) selects the existing GO ...
                     S_DWS_FETCH=191, S_DWS_FETCHX=192, S_DWS_RD=193,
                     // Z51 (PUSHL @rd,addr[,(rs)]): read a fresh long @ea, THEN push it (predecrement R[dst] by 4)
                     S_PLDA_FETCH=194, S_PLDA_FETCHX=195, S_PLDA_RD_HI=196, S_PLDA_RD_LO=197,
                     S_PLDA_WR_HI=198, S_PLDA_WR_LO=199,
                     // Z55 (POPL addr[,(rd)],@rs): pop a long @R[src] (postincrement +4), write it to the fetched ea
                     S_POLDA_FETCH=200, S_POLDA_FETCHX=201, S_POLDA_RD_HI=202, S_POLDA_RD_LO=203,
                     S_POLDA_WR_HI=204, S_POLDA_WR_LO=205,
                     // Z53/Z57 indexed (PUSH/POP word, addr(rs)): the DIRECT (NIB3=0) forms already exist (S_PUSHA_FETCH/RD, ...
                     S_PUSHAX_FETCH=206, S_POPAX_FETCH=207,
                     // Z5C08/Z5CN8 (TESTL addr[,(rd)]): new 32-bit read-only compare-to-zero.
                     S_TL_FETCH=208, S_TL_FETCHX=209, S_TL_RD_HI=210, S_TL_RD_LO=211,
                     // Z5C11/Z5C19 (LDM rd,addr(rs),n / LDM addr(rd),rs,n indexed): indexed word3-fetch siblings of ...
                     S_LDM_DA_FETCH3X=212, S_LDM_DA_LFETCH3X=213,
                     // Z5F10-Z5FF0 (CALL addr(rd) indexed): indexed sibling of the existing S_CALL_FETCH (0x5F00 exact-match direct), ...
                     S_CALLX_FETCH=214;
    localparam [7:0]
                     S_Z30_FETCH=215, S_Z31_FETCH=216, S_Z32_FETCH=217, S_Z33_FETCH=218,
                     S_Z34_FETCH=219, S_Z35_FETCH=220, S_Z37_FETCH=221;
    localparam [7:0]
                     S_Z70_FETCH=222, S_Z72_FETCH=223, S_Z73_FETCH=224,
                     S_Z74_FETCH=225, S_Z75_FETCH=226, S_Z77_FETCH=227;
    localparam [7:0]
                     S_MULTLI_HI=228, S_MULTLI_LO=229, S_DIVLI_HI=230, S_DIVLI_LO=231;
    // register-count dynamic shift GO states (SDLB/SDAB/SDLW/SDAW/SDLL/SDAL)
    localparam [7:0]
                     S_SDLB_GO=232, S_SDAB_GO=233, S_SDLW_GO=234,
                     S_SDAW_GO=235, S_SDLL_GO=236, S_SDAL_GO=237;
    // RESB/RES/SETB/SET/BITB/BIT rd,rs (0x22-0x27, NIB2=0)
    localparam [7:0]
                     S_RESB2_GO=238, S_RES2_GO=239, S_SETB2_GO=240,
                     S_SET2_GO=241, S_BITB2_GO=242, S_BIT2_GO=243;
    localparam [7:0]
                     S_SWALLOW1=244, S_HALT=245, S_SHIFTAB=246;
    localparam [7:0]
                     S_TRAP_PC=247, S_TRAP_FCW=248, S_TRAP_OP=249,
                     S_TRAP_RDFCW=250, S_TRAP_RDPC=251;
    // real single-cycle port I/O (INB/IN/OUTB/OUT, 0x3C-0x3F)
    localparam [7:0]
                     S_INB_GO=252, S_IN_GO=253, S_OUTB_GO=254, S_OUT_GO=255;
    reg [8:0] state;
    // LDPS real functional sequence (0x39 @rs / 0x79 addr[(rs)])
    localparam [8:0]
                     S_LDPS_FETCH=256, S_LDPS_FETCHX=257,
                     S_LDPS_RDFCW=258, S_LDPS_RDPC=259;
    // 0x3A/0x3B port I/O
    localparam [8:0]
                     S_IOS_FETCH=260, S_IOS_RD=261, S_IOS_WR=262,
                     S_IOB_FETCH2=263, S_IOB_RD=264, S_IOB_WR_RD=265, S_IOB_WR=266;

    // RB(src) value staged for the LDB @Rd,rbs store merge (S_LDBST_WR)
    wire [7:0] ldbst_val = src[3] ? R[src[2:0]][7:0] : R[src[2:0]][15:8];

    // RESB/SETB @Rd,#imm4 byte-merge (S_RESETB_WR)
    wire [7:0] resetb_new = bitop_set
        ? ((R[dst][0] ? operand[7:0] : operand[15:8]) | bmask[7:0])
        : ((R[dst][0] ? operand[7:0] : operand[15:8]) & ~bmask[7:0]);
    // EXB rbd,@rs old-value staging (S_EXB_WR dout)
    wire [7:0] exb_val = dst[3] ? R[dst[2:0]][7:0] : R[dst[2:0]][15:8];

    // transcribed LITERALLY per z8000ops.hxx, not "corrected" to match its siblings
    wire iob_rdword = io_wide || (io_sub==4'b0011);
    wire [7:0] iob_byte_rd = iob_rdword ? operand[7:0] : (R[src][0] ? operand[7:0] : operand[15:8]);
    // S_IOB_WR's dout: word forms pass the read value straight through (no lane logic at all, matches WRIR_W/WRPORT_W ...
    wire [15:0] iob_wr_dout = io_wide ? operand :
                              (io_sub[1]==1'b0) ? (R[dst][0] ? {operand2[15:8], iob_byte_rd}
                                                               : {iob_byte_rd, operand2[7:0]})
                                                 : {2{iob_byte_rd}};

    // RESB/SETB addr[,(rd)],#imm4 byte-merge (S_DAB_RESB_WR)
    wire [7:0] daresb_new = bitop_set
        ? ((ea[0] ? operand[7:0] : operand[15:8]) | bmask[7:0])
        : ((ea[0] ? operand[7:0] : operand[15:8]) & ~bmask[7:0]);

    // NVI push / IRET pop addresses: SP=R[15]
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
                  // stack + control flow explicit-address states
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
                  // indirect-indirect PUSHL/PUSH/POP
                  (state==S_PLII_RD_HI) ?  R[src] :
                  (state==S_PLII_RD_LO) ? (R[src] + 16'd2) :
                  (state==S_PLII_WR_HI) ?  ea :
                  (state==S_PLII_WR_LO) ? (ea + 16'd2) :
                  (state==S_PUSHII_RD ) ?  R[src] :
                  (state==S_POPII_RD  ) ?  R[src] :
                  (state==S_POPII_WR  ) ?  R[dst] :
                  // byte ALU/LDB, LDB store, CPL, BIT/RES/SET, EX
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
                  // INC/DEC direct, MULT/DIV/MULTL/DIVL, ADDL/SUBL, LDB direct load/store, CPL direct (fetch states omitted
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
                  // RESB/SETB, EXB (the four indexed *_FETCH states read the addr word via `pc`, same default convention as every ...
                  (state==S_RESETB_RD ) ? (R[dst] & 16'hFFFE) :
                  (state==S_RESETB_WR ) ? (R[dst] & 16'hFFFE) :
                  (state==S_EXB_RD    ) ? (R[src] & 16'hFFFE) :
                  (state==S_EXB_WR    ) ? (R[src] & 16'hFFFE) :
                  // direct-address(+index) RESB/RES/BITB/BIT/EXB/EX family (the *_FETCH/*X_FETCH states read the addr word via ...
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
                  // register-indirect @Rd simple family (0x0C/0x0D)
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
                  // (the new *_FETCH/*X_FETCH states all read the addr/ imm word via `pc`, same default convention as every prior ...
                  (state==S_ALUA_RD    ) ?  ea :
                  (state==S_ALUAB_RD   ) ? (ea & 16'hFFFE) :
                  (state==S_INCDAB_RD  ) ? (ea & 16'hFFFE) :
                  (state==S_INCDAB_WR  ) ? (ea & 16'hFFFE) :
                  (state==S_INCBI_RD   ) ? (R[dst] & 16'hFFFE) :
                  (state==S_INCBI_WR   ) ? (R[dst] & 16'hFFFE) :
                  (state==S_INCWI_RD   ) ? (R[dst] & 16'hFFFE) :
                  (state==S_INCWI_WR   ) ? (R[dst] & 16'hFFFE) :
                  // LD rd,rs(rx) (0x71)
                  (state==S_LD71_RD    ) ?  ea :
                  // 0x4C/4D direct-address(+index) static-op family (the *_FETCH/*_FETCHX states read the addr/imm8 word via `pc`, ...
                  (state==S_DAD_RD     ) ?  ea :
                  (state==S_DAD_WR     ) ?  ea :
                  (state==S_DAC_RD     ) ? (ea & 16'hFFFE) :
                  (state==S_DAC_RDRO   ) ? (ea & 16'hFFFE) :
                  (state==S_DAC_WR     ) ? (ea & 16'hFFFE) :
                  // 0x51-0x5C address-form family (*_FETCH/*_FETCHX states read the addr/word2/word3 word via `pc`, same default ...
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
                  // internal-trap accept sequence (mirrors S_NVI_* exactly, psap+trap_vec instead of the hardwired psap+0x18 NVI ...
                  (state==S_TRAP_PC    ) ?  (R[15] - 16'd2) :
                  (state==S_TRAP_FCW   ) ?  (R[15] - 16'd2) :
                  (state==S_TRAP_OP    ) ?  (R[15] - 16'd2) :
                  (state==S_TRAP_RDFCW ) ?  (psap + trap_vec) :
                  (state==S_TRAP_RDPC  ) ?  (psap + trap_vec + 16'd2) :
                  // addr is a plain register value (byte forms word-align, matching this file's established byte-access convention).
                  (state==S_INB_GO  ) ? (R[src] & 16'hFFFE) :
                  (state==S_IN_GO   ) ?  R[src] :
                  (state==S_OUTB_GO ) ? (R[dst] & 16'hFFFE) :
                  (state==S_OUT_GO  ) ?  R[dst] :
                  // LDPS RDFCW/RDPC (S_LDPS_FETCH/FETCHX default to `pc`, same convention as every other *_FETCH state
                  (state==S_LDPS_RDFCW) ?  ea :
                  (state==S_LDPS_RDPC ) ? (ea + 16'd2) :
                  // 0x3A/0x3B port I/O (S_IOS_FETCH/S_IOB_FETCH2 default to `pc`, same convention as every other *_FETCH state).
                  (state==S_IOS_RD    ) ? (io_wide ? ea : (ea & 16'hFFFE)) :
                  (state==S_IOS_WR    ) ? (io_wide ? ea : (ea & 16'hFFFE)) :
                  (state==S_IOB_RD    ) ? (iob_rdword ? R[src] : (R[src] & 16'hFFFE)) :
                  (state==S_IOB_WR_RD ) ? (R[dst] & 16'hFFFE) :
                  (state==S_IOB_WR    ) ? (io_wide ? R[dst] : (R[dst] & 16'hFFFE)) :
                                        pc;
    // /19: mreq/iorq are mutually exclusive space-selects (matches a real Z8000 bus)
    assign mreq    = (state!=S_ILLEGAL) && (state!=S_INB_GO) && (state!=S_IN_GO) &&
                      (state!=S_OUTB_GO) && (state!=S_OUT_GO) &&
                      (state!=S_IOS_RD) && (state!=S_IOS_WR) &&
                      !(state==S_IOB_RD && !io_sub[1]) &&
                      !(state==S_IOB_WR &&  io_sub[1]);
    // no I/O device is wired on this board, but the CPU core itself must still present a correct bus cycle: MREQ/IORQ ...
    assign iorq    = (state==S_INB_GO) || (state==S_IN_GO) || (state==S_OUTB_GO) || (state==S_OUT_GO) ||
                      (state==S_IOS_RD) || (state==S_IOS_WR) ||
                      (state==S_IOB_RD &&  !io_sub[1]) ||
                      (state==S_IOB_WR &&   io_sub[1]);
    assign we      = (state==S_MEMWR) || (state==S_DA_WR) ||
                      (state==S_NVI_PC) || (state==S_NVI_FCW) || (state==S_NVI_VEC) ||
                      (state==S_CALL_PUSH) || (state==S_PUSH_W) || (state==S_POPA_WR) ||
                      (state==S_L32_WR_HI) || (state==S_L32_WR_LO) || (state==S_LDM_S_WR) ||
                      (state==S_PLII_WR_HI) || (state==S_PLII_WR_LO) || (state==S_POPII_WR) ||
                      (state==S_LDBST_WR) || (state==S_BITW_WR) || (state==S_EX_WR) ||
                      (state==S_INCDA_WR) || (state==S_LDBSTA_WR) ||
                      (state==S_RESETB_WR) || (state==S_EXB_WR) ||
                      (state==S_DAB_RESB_WR) || (state==S_DAB_RESW_WR) ||
                      (state==S_DAB_EXB_WR)  || (state==S_DAB_EXW_WR)  ||
                      (state==S_TSETBI_WR) || (state==S_CLRBI_WR) || (state==S_COMI_WR) ||
                      (state==S_NEGI_WR)   || (state==S_TSETI_WR) || (state==S_CLRI_WR) ||
                      (state==S_INCDAB_WR) || (state==S_INCBI_WR) || (state==S_INCWI_WR) ||
                      (state==S_DAD_WR) || (state==S_DAC_WR) ||
                      (state==S_PLDA_WR_HI) || (state==S_PLDA_WR_LO) ||
                      (state==S_POLDA_WR_HI) || (state==S_POLDA_WR_LO) ||
                      (state==S_TRAP_PC) || (state==S_TRAP_FCW) || (state==S_TRAP_OP) ||
                      (state==S_OUTB_GO) || (state==S_OUT_GO) ||
                      (state==S_IOS_WR) || (state==S_IOB_WR);
    // S_MEMRDB/S_BITB_RD also word-align the read addr and keep only one byte of the result (same shape as the ...
    assign wordacc = (state!=S_ADDB_RD) && (state!=S_MEMRDB) && (state!=S_BITB_RD) &&
                      (state!=S_LDBDA_RD) && (state!=S_DAB_BITB_RD) && (state!=S_TESTBI_RD) &&
                      (state!=S_ALUAB_RD) && (state!=S_DAC_RDRO) &&
                      // INB (read-only byte-discard, like every other *_RD byte state above) and OUTB (byte write, no RMW needed for I/O
                      (state!=S_INB_GO) && (state!=S_OUTB_GO) &&
                      // S_IOS_RD/WR and S_IOB_RD are byte-discard-shaped whenever the access itself is byte-width (matches INB/OUTB's ...
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
                     (state==S_CALL_PUSH) ? pc :
                     (state==S_PUSH_W   ) ? operand :
                     (state==S_POPA_WR  ) ? operand :
                     (state==S_L32_WR_HI) ? R[{src[3:1],1'b0}] :
                     (state==S_L32_WR_LO) ? R[{src[3:1],1'b0}+4'd1] :
                     (state==S_LDM_S_WR ) ? R[src] :
                     (state==S_PLII_WR_HI) ? operand :
                     (state==S_PLII_WR_LO) ? operand2 :
                     (state==S_POPII_WR  ) ? operand :
                     (state==S_LDBST_WR  ) ? (R[dst][0] ? {operand[15:8], ldbst_val}
                                                          : {ldbst_val, operand[7:0]}) :
                     (state==S_BITW_WR   ) ? (bitop_set ? (operand | bmask) : (operand & ~bmask)) :
                     (state==S_EX_WR     ) ? R[dst] :
                     (state==S_INCDA_WR  ) ? operand :
                     (state==S_LDBSTA_WR ) ? (ea[0] ? {operand[15:8], ldbst_val}
                                                      : {ldbst_val, operand[7:0]}) :
                     // NOT the pointer register-NUMBER's bit0
                     (state==S_RESETB_WR ) ? (R[dst][0] ? {operand[15:8], resetb_new}
                                                          : {resetb_new, operand[7:0]}) :
                     (state==S_EXB_WR    ) ? (R[src][0] ? {operand[15:8], exb_val}
                                                          : {exb_val, operand[7:0]}) :
                     // (lane = ea[0], the FETCHED/indexed address' LSB, matching S_LDBDA_RD's convention
                     (state==S_DAB_RESB_WR) ? (ea[0] ? {operand[15:8], daresb_new}
                                                       : {daresb_new, operand[7:0]}) :
                     (state==S_DAB_RESW_WR) ? (bitop_set ? (operand | bmask) : (operand & ~bmask)) :
                     (state==S_DAB_EXB_WR ) ? (ea[0] ? {operand[15:8], exb_val}
                                                       : {exb_val, operand[7:0]}) :
                     (state==S_DAB_EXW_WR ) ? R[dst] :
                     // (lane = R[dst][0], matching S_LDBST_WR's established convention for a register-indirect byte RMW pointer)
                     (state==S_TSETBI_WR) ? (R[dst][0] ? {operand[15:8], 8'hFF}
                                                         : {8'hFF, operand[7:0]}) :
                     (state==S_CLRBI_WR ) ? (R[dst][0] ? {operand[15:8], 8'h00}
                                                         : {8'h00, operand[7:0]}) :
                     (state==S_COMI_WR  ) ? operand :
                     (state==S_NEGI_WR  ) ? operand :
                     (state==S_TSETI_WR ) ? 16'hFFFF :
                     (state==S_CLRI_WR  ) ? 16'h0000 :
                     // (all three WR states already hold the fully- merged new word in `operand` by the time WR runs, computed in ...
                     (state==S_INCDAB_WR || state==S_INCBI_WR || state==S_INCWI_WR) ? operand :
                     // (S_DAD_WR holds the fully-computed new WORD in `operand`, same shape as ...
                     (state==S_DAD_WR) ? operand :
                     (state==S_DAC_WR) ? (ea[0] ? {operand[15:8], dacres}
                                                  : {dacres, operand[7:0]}) :
                     // (S_PLDA/S_POLDA WR_HI/WR_LO write the hi/lo halves staged in operand/operand2 by their own RD_HI/RD_LO, same ...
                     (state==S_PLDA_WR_HI  || state==S_POLDA_WR_HI) ? operand  :
                     (state==S_PLDA_WR_LO  || state==S_POLDA_WR_LO) ? operand2 :
                     // trap accept push order (PC, then OLD fcw, then the trapping opcode word)
                     (state==S_TRAP_PC )  ? pc  :
                     (state==S_TRAP_FCW)  ? fcw :
                     (state==S_TRAP_OP )  ? ir  :
                     // matches MAME's WRPORT_B(value16=value| (value<<8)) / WRPORT_W(value) exactly: byte form replicates the byte ...
                     (state==S_OUTB_GO)   ? {2{src[3] ? R[src[2:0]][7:0] : R[src[2:0]][15:8]}} :
                     (state==S_OUT_GO )   ? R[src] :
                     // 0x3A/0x3B port I/O writes
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
    reg [7:0]  dab_byte;  // DAB source byte
    reg [10:0] dab_idx;  // DAB rom index {DA,H,C,byte}
    reg [8:0]  dab_res;  // DAB rom result {carry,byte}
    reg [4:0]  cnt;
    reg [4:0]  incn;
    reg        z,s,v,c,h,wb, cbit;
    // combinational scratch
    reg [7:0]  res8;  // byte-ALU result
    reg        p;  // parity flag (byte AND/OR/XOR P/V, MAME z8000_zsp[])
    reg [32:0] dif33;  // 33-bit long-compare scratch (CPL, reused by SUBL/S_LALU_GO)
    // combinational scratch
    reg [4:0]  i4p1;  // INC/DEC addr,#n imm4m1+1 (5-bit -- avoids the 4-bit
                                  // wraparound that `incn` has for field value 0xF/"+16", see report
    reg signed [31:0] mul_p32;  // MULT 16x16->32 product
    reg signed [63:0] mul_p64;  // MULTL 32x32->64 product
    reg signed [31:0] div_dvd, div_dvs, div_q, div_qtmp;  // DIV 32/16 scratch (dvs sign
                                  // extended to 32 so the divide is same-width both sides)
    reg signed [15:0] div_r;  // DIV remainder
    reg signed [63:0] div_dvd64, div_dvs64, div_q64, div_qtmp64;  // DIVL 64/32 scratch
    reg signed [31:0] div_r32;  // DIVL remainder
    // shared sequential restoring-divider datapath ---- Sized 64-bit so ONE datapath serves both DIV (32/16) and DIVL ...
    reg [63:0] dv_rem;  // running remainder (restoring division)
    reg [63:0] dv_quo;  // dividend in, quotient out (shifts through)
    reg [63:0] dv_dvsr;  // divisor magnitude
    reg [64:0] dv_shf, dv_sub;  // combinational: shifted remainder, trial subtract
    reg [6:0]  dv_cnt;  // iteration counter, 0..64
    reg        dv_qneg, dv_rneg;  // result signs: q = sign(dvd)^sign(dvs), r = sign(dvd)
    reg        dv_long;  // 0 = DIV (finish via S_DIV_FIN), 1 = DIVL (S_DIVL_FIN)
    reg signed [63:0] dv_q_signed, dv_r_signed;  // combinational sign-restored results
    reg [31:0] a32, val32, res32;  // ADDL/SUBL 32-bit operands/result
    reg [32:0] sum33;  // ADDL 33-bit carry scratch (dif33 doubles for SUBL/CPL)
    // combinational scratch
    reg [4:0]  nibc;  // ADC/SBC nibble carry/borrow-out scratch (H flag),
                                  // same 5-bit-add-with-carry-in-bit4 shape as the file's existing 9-bit (add8) / 17-bit (sum17/dif17) carry ...
    reg [7:0]  dcnt;  // SDLB/SDAB/SDLW/SDAW/SDLL/SDAL dynamic shift magnitude
                                  // (0-128, sign-negated from the count register's low byte same convention as the existing `scnt`/`cnt` used by ...

    // shared register-file writeback bus (see the writeback block at the very end of the main always block for the ...
    reg        rwb0_we,  rwb1_we,  rwb2_we,  rwb3_we;
    reg [3:0]  rwb0_idx, rwb1_idx, rwb2_idx, rwb3_idx;
    reg [15:0] rwb0_val, rwb1_val, rwb2_val, rwb3_val;
    reg [1:0]  rwb0_be,  rwb1_be,  rwb2_be,  rwb3_be;  // {high byte en, low byte en}

    integer i;
    always @(posedge clk) begin
        if (!reset_n) begin
            pc<=0; fcw<=0; ir<=0; dst<=0; src<=0; aluop<=0; operand<=0;
            ea<=0; daop<=0; retire<=0; illegal<=0; state<=S_RST_FCW;
            psap<=16'h0000; nvi_pending<=1'b0; nvi_n_d<=1'b1; mcnt<=4'h0; l32wb<=1'b0;
            operand2<=16'h0000; bmask<=16'h0000; bitop_set<=1'b0;
            idxr<=4'h0;
            target_cycles<=16'd0; cyc_count<=16'd1;  // cyc_count>=target_cycles so
                                                      // the first S_FETCH0 dispatches immediately
            for (i=0;i<16;i=i+1) R[i]<=16'h0000;
        end else if (ce) begin
            retire <= 1'b0;
            // default tick, EVERY ce cycle regardless of state (an instruction's own natural execution states are NOT ...
            cyc_count <= cyc_count + 16'd1;
            pc2 = pc + 16'd2;
            // level-triggered NVI latch (MAME execute_input_edge_triggered==false for NVI): Was `if (!nvi_n) nvi_pending <= ...
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
              // cycle-accuracy padding gate
              if (cyc_count < target_cycles) begin
                  // not yet time -- default `cyc_count<=cyc_count+1` above already applies
              end else begin
              target_cycles <= lookup_cycles(din);
              cyc_count <= 16'd1;
              // NVI accept (instruction-boundary check, ahead of decode) ---- MAME z8002_device::Interrupt(): ...
              if (nvi_pending && ((fcw & F_NVIE)!=16'h0000)) begin
                  state <= S_NVI_PC;
              end else begin
                ir <= din;
                // CLR rd (0x8Dd8, no flags)
                if (din[15:8]==8'h8D && din[3:0]==4'h8) begin
                    rwb0_we=1'b1; rwb0_idx=din[7:4]; rwb0_val=16'h0000; pc<=pc2; retire<=1'b1;
                end
                // LD rd,#imm16 (0x210d) / LD rd,@rs (0x21, src!=0)
                else if (din[15:8]==8'h21) begin
                    dst<=din[3:0]; aluop<=LD; pc<=pc2;
                    if (din[7:4]==0) state<=S_IMM;
                    else begin src<=din[7:4]; state<=S_MEMRD; end
                end
                // reg-reg ALU: A1=LD 81=ADD 83=SUB 85=OR 87=AND 89=XOR 8B=CP
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
                // mem/imm word ALU: 01=ADD 03=SUB 05=OR 07=AND 09=XOR 0B=CP
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
                // ADDB rd,@rs (0x00, src!=0, byte)
                else if (din[15:8]==8'h00 && din[7:4]!=4'h0) begin
                    src<=din[7:4]; dst<=din[3:0]; pc<=pc2; state<=S_ADDB_RD;
                end
                // LD @rd,rs store (0x2F, NIB2=dst(ptr)!=0) : ptr=NIB2, data=NIB3 ---- MAME Z2F_ddN0_ssss requires ptr!=0 ...
                else if (din[15:8]==8'h2F && din[7:4]!=4'h0) begin
                    dst<=din[7:4]; src<=din[3:0]; pc<=pc2; state<=S_MEMWR;
                end
                // SLL/SRL rd,#imm (0xB3, NIB3=1)
                else if (din[15:8]==8'hB3 && din[3:0]==4'h1) begin
                    dst<=din[7:4]; pc<=pc2; state<=S_SHIFT;
                end
                // SLA/SRA rd,#imm (0xB3, NIB3=9) : MAME ZB3_dddd_1001_imm8
                else if (din[15:8]==8'hB3 && din[3:0]==4'h9) begin
                    dst<=din[7:4]; pc<=pc2; state<=S_SHIFTA;
                end
                // SLAL/SRAL rrd,#imm (0xB3, NIB3=D) : MAME ZB3_dddd_1101_imm8
                else if (din[15:8]==8'hB3 && din[3:0]==4'hD) begin
                    dst<=din[7:4]; pc<=pc2; state<=S_SHIFTAL;
                end
                // SLLL/SRLL rrd,#imm (0xB3, NIB3=5) : MAME ZB3_dddd_0101_imm8
                else if (din[15:8]==8'hB3 && din[3:0]==4'h5) begin
                    dst<=din[7:4]; pc<=pc2; state<=S_SHIFTL;
                end
                // LDA prd,addr (0x7600-0x760f, NIB2==0) : MAME Z76_0000_dddd_addr
                else if (din[15:8]==8'h76 && din[7:4]==4'h0) begin
                    dst<=din[3:0]; lda76_has_src<=1'b0; pc<=pc2; state<=S_LDA76_FETCH;
                end
                // LDA prd,addr(rs) (0x7610-0x76ff, NIB2!=0) : MAME Z76_ssN0_dddd_addr
                else if (din[15:8]==8'h76 && din[7:4]!=4'h0) begin
                    dst<=din[3:0]; src<=din[7:4]; lda76_has_src<=1'b1; pc<=pc2; state<=S_LDA76_FETCH;
                end
                // LD rd,rs(rx) (0x71, NIB2!=0) : MAME Z71_ssN0_dddd_0000_xxxx_0000_0000
                else if (din[15:8]==8'h71 && din[7:4]!=4'h0) begin
                    src<=din[7:4]; dst<=din[3:0]; pc<=pc2; state<=S_LD71_FETCH;
                end
                // 0x70/72/73/74/75/77, the rest of the register+register- indexed family (0x71's siblings, same ...
                else if (din[15:8]==8'h70 && din[7:4]!=4'h0) begin
                    src<=din[7:4]; dst<=din[3:0]; pc<=pc2; state<=S_Z70_FETCH;
                end
                // Z72: LDB rd(rx),rbs
                else if (din[15:8]==8'h72 && din[7:4]!=4'h0) begin
                    dst<=din[7:4]; src<=din[3:0]; pc<=pc2; state<=S_Z72_FETCH;
                end
                // Z73: LD rd(rx),rs
                else if (din[15:8]==8'h73 && din[7:4]!=4'h0) begin
                    dst<=din[7:4]; src<=din[3:0]; daop<=DA_STR; pc<=pc2; state<=S_Z73_FETCH;
                end
                // Z74: LDA prd,rs(rx)
                else if (din[15:8]==8'h74 && din[7:4]!=4'h0) begin
                    src<=din[7:4]; dst<=din[3:0]; pc<=pc2; state<=S_Z74_FETCH;
                end
                // Z75: LDL rrd,rs(rx)
                else if (din[15:8]==8'h75 && din[7:4]!=4'h0) begin
                    src<=din[7:4]; dst<=din[3:0]; pc<=pc2; state<=S_Z75_FETCH;
                end
                // Z77: LDL rd(rx),rrs
                else if (din[15:8]==8'h77 && din[7:4]!=4'h0) begin
                    dst<=din[7:4]; src<=din[3:0]; pc<=pc2; state<=S_Z77_FETCH;
                end
                // JP cc,addr (0x5E00-0x5E0F, NIB2=0) : MAME Z5E_0000_cccc_addr "jp cc,addr". cc=NIB3
                else if (din[15:8]==8'h5E && din[7:4]==4'h0) begin
                    src<=din[3:0]; jpx<=1'b0; pc<=pc2; state<=S_JP;
                end
                // JP cc,addr(rd) (0x5E10-0x5EFF, NIB2=dst!=0) : MAME Z5E_ddN0_cccc_addr "jp cc,addr(rd)". cc=NIB3, ...
                else if (din[15:8]==8'h5E && din[7:4]!=4'h0) begin
                    src<=din[3:0]; idxr<=din[7:4]; jpx<=1'b1; pc<=pc2; state<=S_JP;
                end
                // LD rd,addr direct (0x61, NIB2=0)
                else if (din[15:8]==8'h61 && din[7:4]==4'h0) begin
                    dst<=din[3:0]; daop<=DA_LDR; pc<=pc2; state<=S_DA_FETCH;
                end
                // LD addr,rs direct (0x6F, NIB2=0)
                else if (din[15:8]==8'h6F && din[7:4]==4'h0) begin
                    src<=din[3:0]; daop<=DA_STR; pc<=pc2; state<=S_DA_FETCH;
                end
                // LD @rd,#imm16 (0x0D, NIB3=5, dst!=0): EA=R[dst] ---- MAME Z0D_ddN0_0101_imm16 requires dst!=0 (R0-as-pointer ...
                else if (din[15:8]==8'h0D && din[3:0]==4'h5 && din[7:4]!=4'h0) begin
                    ea<=R[din[7:4]]; daop<=DA_STI; pc<=pc2; state<=S_DA_IMM;
                end
                // added this same sub-op to the INDEXED sibling below (4'h1 -> DA_CPI) but never to this direct form
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
                // indexed group (0x4D, NIB2!=0): addr(rx) instead of plain addr
                else if (din[15:8]==8'h4D && din[7:4]!=4'h0) begin
                    idxr<=din[7:4]; pc<=pc2;
                    case (din[3:0])
                        4'h0: begin dadop<=2'd0; state<=S_DAD_FETCHX; end  // COM
                        4'h1: begin daop<=DA_CPI; state<=S_DAX_FETCH; end
                        4'h2: begin dadop<=2'd1; state<=S_DAD_FETCHX; end  // NEG
                        4'h5: begin daop<=DA_STI; state<=S_DAX_FETCH; end
                        4'h6: begin dadop<=2'd2; state<=S_DAD_FETCHX; end  // TSET
                        4'h4: begin daop<=DA_TST; state<=S_DAX_FETCH; end
                        4'h8: begin daop<=DA_CLR; state<=S_DAX_FETCH; end  // fix
                        default: begin illegal<=1'b1; state<=S_ILLEGAL; end
                    endcase
                end
                // direct-address(+index) BYTE static-op family, 0x4C
                else if (din[15:8]==8'h4C && din[7:4]==4'h0) begin
                    pc<=pc2;
                    case (din[3:0])
                        4'h0: begin dacop<=3'd0; state<=S_DAC_FETCH; end  // COMB
                        4'h1: begin dacop<=3'd5; state<=S_DAC_FETCH; end  // CPB #imm8
                        4'h2: begin dacop<=3'd1; state<=S_DAC_FETCH; end  // NEGB
                        4'h4: begin dacop<=3'd2; state<=S_DAC_FETCH; end  // TESTB
                        4'h5: begin dacop<=3'd6; state<=S_DAC_FETCH; end  // LDB #imm8
                        4'h6: begin dacop<=3'd3; state<=S_DAC_FETCH; end  // TSETB
                        4'h8: begin dacop<=3'd4; state<=S_DAC_FETCH; end  // CLRB
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
                // LDB addr(rd),rbs (0x4E)
                else if (din[15:8]==8'h4E && din[7:4]!=4'h0 && din[7:4]!=4'hF && din[3:0]==4'h1) begin
                    src<=din[3:0]; idxr<=din[7:4]; pc<=pc2; state<=S_LDBSTAX_FETCH;
                end
                // DEC rd,#n (0xAB, word, ZSV)
                else if (din[15:8]==8'hAB) begin
                    incn=din[3:0]+5'd1; a16=R[din[7:4]]; res16=a16-{11'd0,incn};
                    v=a16[15] & ~res16[15];
                    rwb0_we=1'b1; rwb0_idx=din[7:4]; rwb0_val=res16;
                    fcw<=(fcw & ~(MZ|MS|MV)) | ((res16==0)?MZ:0)|(res16[15]?MS:0)|(v?MV:0);
                    pc<=pc2; retire<=1'b1;
                end
                // DECB rbd,#n (0xAA, byte, ZSV)
                else if (din[15:8]==8'hAA) begin
                    incn=din[3:0]+5'd1;
                    dbyte = din[7] ? R[din[6:4]][7:0] : R[din[6:4]][15:8];
                    add8 = {1'b0,dbyte} - {4'd0,incn};
                    v = dbyte[7] & ~add8[7];
                    rwb0_we=1'b1; rwb0_idx={1'b0,din[6:4]}; rwb0_val={2{add8[7:0]}}; rwb0_be=din[7]?2'b01:2'b10;
                    fcw<=(fcw & ~(MZ|MS|MV)) | ((add8[7:0]==0)?MZ:0)|(add8[7]?MS:0)|(v?MV:0);
                    pc<=pc2; retire<=1'b1;
                end
                // INC rd,#n (0xA9, word, ZSV)
                else if (din[15:8]==8'hA9) begin
                    incn=din[3:0]+5'd1; incw_sum={1'b0,R[din[7:4]]}+{12'd0,incn};
                    v=(~R[din[7:4]][15]) & incw_sum[15];
                    rwb0_we=1'b1; rwb0_idx=din[7:4]; rwb0_val=incw_sum[15:0];
                    fcw<=(fcw & ~(MZ|MS|MV)) | ((incw_sum[15:0]==0)?MZ:0)
                        | (incw_sum[15]?MS:0) | (v?MV:0);
                    pc<=pc2; retire<=1'b1;
                end
                // INCB rbd,#n (0xA8, byte, ZSV)
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
                // DJNZ/DBJNZ (0xF, reg=NIB1, w=bit7, no flags)
                else if (din[15:12]==4'hF) begin
                    disp2={8'd0,din[6:0],1'b0};
                    if (din[7]) begin
                        rwb0_we=1'b1; rwb0_idx=din[11:8]; rwb0_val=R[din[11:8]]-16'd1;
                        pc<=(R[din[11:8]]-16'd1!=0) ? (pc2-disp2) : pc2;
                    end else begin
                        // Byte form fell through with pc<=pc2 and NEVER branched, so every byte dbjnz loop ran exactly one iteration
                        dbyte = (din[11] ? R[din[10:8]][7:0] : R[din[10:8]][15:8]) - 8'd1;
                        rwb0_we=1'b1; rwb0_idx={1'b0,din[10:8]}; rwb0_be=din[11]?2'b01:2'b10;
                        rwb0_val={2{dbyte}};
                        pc<=(dbyte!=8'd0) ? (pc2-disp2) : pc2;
                    end
                    retire<=1'b1;
                end
                // JR cc,dsp8 (0xE, signed, no flags)
                else if (din[15:12]==4'hE) begin
                    disp2={{7{din[7]}},din[7:0],1'b0};
                    pc<=cc_true(din[11:8],fcw[FC],fcw[FZ],fcw[FS],fcw[FV]) ? (pc2+disp2) : pc2;
                    retire<=1'b1;
                end
                // IRET (0x7B00, exact match): pop vec/fcw/pc in sequence
                else if (din==16'h7B00) begin
                    state<=S_IRET_VEC;
                end
                // MSET/MRES/MBIT (0x7B08/09/0A, exact match) : MAME Z7B_0000_1000/1001/1010
                else if (din==16'h7B08 || din==16'h7B09 || din==16'h7B0A) begin
                    if (!fcw[14]) begin trap_vec<=VEC_TRAP; pc<=pc2; state<=S_TRAP_PC; end
                    else begin pc<=pc2; retire<=1'b1; end
                end
                // MREQ rd (0x7B_dddd_1101) : MAME Z7B_dddd_1101, flags -ZS---. CHECK_PRIVILEGED_INSTR gated
                else if (din[15:8]==8'h7B && din[3:0]==4'hD) begin
                    if (!fcw[14]) begin trap_vec<=VEC_TRAP; pc<=pc2; state<=S_TRAP_PC; end
                    else begin
                        fcw<=(fcw & ~(MZ|MS)) | MZ;
                        pc<=pc2; retire<=1'b1;
                    end
                end
                // HALT (0x7A00, exact match) : MAME Z7A_0000_0000
                else if (din==16'h7A00) begin
                    if (!fcw[14]) begin trap_vec<=VEC_TRAP; pc<=pc2; state<=S_TRAP_PC; end
                    else state<=S_HALT;
                end
                // CHECK_PRIVILEGED_INSTR gated
                else if (din[15:8]==8'h39 && din[7:4]!=4'h0 && din[3:0]==4'h0) begin
                    if (!fcw[14]) begin trap_vec<=VEC_TRAP; pc<=pc2; state<=S_TRAP_PC; end
                    else begin ea<=R[din[7:4]]; pc<=pc2; state<=S_LDPS_RDFCW; end
                end
                // LDPS addr[,(rs)] (0x7900 exact / 0x7910-0x79F0, NIB3=0 FIXED in both) : MAME Z79_0000_0000_addr / ...
                else if (din[15:8]==8'h79 && din[3:0]==4'h0) begin
                    if (!fcw[14]) begin trap_vec<=VEC_TRAP; pc<=pc2; state<=S_TRAP_PC; end
                    else if (din[7:4]==4'h0) begin pc<=pc2; state<=S_LDPS_FETCH; end
                    else begin idxr<=din[7:4]; pc<=pc2; state<=S_LDPS_FETCHX; end
                end
                // the remaining I/O / EPU / reserved / block-string bucket
                else if (din[15:8]==8'h0E || din[15:8]==8'h0F ||
                         din[15:8]==8'h8E || din[15:8]==8'h8F) begin
                    if (!fcw[13]) begin trap_vec<=VEC_EPU; pc<=pc2; state<=S_TRAP_PC; end
                    else begin pc<=pc2; retire<=1'b1; end
                end
                // Z36_0000_0000 (BPT, 0x3600 exact) : MAME body is `m_irq_req |= Z8000_TRAP;` UNCONDITIONALLY (no CHECK_ macro at all
                else if (din==16'h3600) begin
                    trap_vec<=VEC_TRAP; pc<=pc2; state<=S_TRAP_PC;
                end
                // Z7F_imm8 (SC, system call, 0x7F00-0x7FFF) : MAME body is `GET_IMM8(0)
                else if (din[15:8]==8'h7F) begin
                    trap_vec<=VEC_SYSCALL; pc<=pc2; state<=S_TRAP_PC;
                end
                // they just test `if (m_fcw & F_EPU)` and do nothing meaningful either way (an empty comment placeholder)
                else if (din[15:8]==8'h38 ||
                         din[15:8]==8'h78 || din[15:8]==8'h7E ||
                         din[15:8]==8'h9D ||
                         din[15:8]==8'h9F || din[15:8]==8'hBF || din[15:8]==8'h36 ||
                         din[15:8]==8'hB9) begin
                    pc<=pc2; retire<=1'b1;
                end
                // INB/IN/OUTB/OUT (0x3C/3D/3E/3F)
                else if (din[15:8]==8'h3C) begin
                    if (!fcw[14]) begin trap_vec<=VEC_TRAP; pc<=pc2; state<=S_TRAP_PC; end
                    else begin src<=din[7:4]; dst<=din[3:0]; pc<=pc2; state<=S_INB_GO; end
                end
                // IN rd,@rs (0x3D) : MAME Z3D_ssss_dddd
                else if (din[15:8]==8'h3D) begin
                    if (!fcw[14]) begin trap_vec<=VEC_TRAP; pc<=pc2; state<=S_TRAP_PC; end
                    else begin src<=din[7:4]; dst<=din[3:0]; pc<=pc2; state<=S_IN_GO; end
                end
                // OUTB @rd,rbs (0x3E) : MAME Z3E_dddd_ssss
                else if (din[15:8]==8'h3E) begin
                    if (!fcw[14]) begin trap_vec<=VEC_TRAP; pc<=pc2; state<=S_TRAP_PC; end
                    else begin dst<=din[7:4]; src<=din[3:0]; pc<=pc2; state<=S_OUTB_GO; end
                end
                // OUT @rd,rs (0x3F) : MAME Z3F_dddd_ssss
                else if (din[15:8]==8'h3F) begin
                    if (!fcw[14]) begin trap_vec<=VEC_TRAP; pc<=pc2; state<=S_TRAP_PC; end
                    else begin dst<=din[7:4]; src<=din[3:0]; pc<=pc2; state<=S_OUT_GO; end
                end
                // size=2 members of the same bucket (one operand word to discard)
                else if ((din[15:8]==8'h3A || din[15:8]==8'h3B) && din[3:0]<=4'h3) begin
                    if (!fcw[14]) begin trap_vec<=VEC_TRAP; pc<=pc2; state<=S_TRAP_PC; end
                    else begin
                        src<=din[7:4]; io_sub<=din[3:0]; io_wide<=(din[15:8]==8'h3B);
                        pc_orig<=pc; pc<=pc2; state<=S_IOB_FETCH2;
                    end
                end
                // block, decrement group (NIB3=1000-1011)
                else if ((din[15:8]==8'h3A || din[15:8]==8'h3B) &&
                         din[3:0]>=4'h8 && din[3:0]<=4'hB) begin
                    if (!fcw[14]) begin trap_vec<=VEC_TRAP; pc<=pc2; state<=S_TRAP_PC; end
                    else begin
                        src<=din[7:4]; io_sub<=din[3:0]; io_wide<=(din[15:8]==8'h3B);
                        pc_orig<=pc; pc<=pc2; state<=S_IOB_FETCH2;
                    end
                end
                // single I/O, IN direction (NIB3=0100/0101): INB/SINB rbd,imm16 / IN/SIN rd,imm16
                else if ((din[15:8]==8'h3A || din[15:8]==8'h3B) &&
                         (din[3:0]==4'h4 || din[3:0]==4'h5)) begin
                    if (!fcw[14]) begin trap_vec<=VEC_TRAP; pc<=pc2; state<=S_TRAP_PC; end
                    else begin
                        dst<=din[7:4]; io_wide<=(din[15:8]==8'h3B); io_dir<=1'b0;
                        pc<=pc2; state<=S_IOS_FETCH;
                    end
                end
                // single I/O, OUT direction (NIB3=0110/0111): OUTB/SOUTB imm16,rbs / OUT/SOUT imm16,rs
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
                // DI/EI i2 (0x7C00-0x7C07): NIB2=0, bit2 0=DI/1=EI, imm2=din[1:0] ---- MAME: di fcw&=(imm2<<11)|0xe7ff
                else if (din[15:8]==8'h7C && din[7:3]==5'h00) begin
                    pc<=pc2; retire<=1'b1;
                    if (din[2]) begin  // EI
                        if (~din[0]) fcw[11]<=1'b1;  // NVIE
                        if (~din[1]) fcw[12]<=1'b1;  // VIE
                    end else begin  // DI
                        if (~din[0]) fcw[11]<=1'b0;
                        if (~din[1]) fcw[12]<=1'b0;
                    end
                end
                // LDCTL rd,ctrl (0x7D_0ccc, NIB3 bit3=0): read ctrl reg -> Rd ---- ctrl codes (Z8002 non-seg): 2=FCW 3=REFRESH ...
                else if (din[15:8]==8'h7D && din[3]==1'b0) begin
                    pc<=pc2; retire<=1'b1;
                    case (din[2:0])
                        3'd2: begin rwb0_we=1'b1; rwb0_idx=din[7:4]; rwb0_val=fcw;  end  // FCW
                        3'd5: begin rwb0_we=1'b1; rwb0_idx=din[7:4]; rwb0_val=psap; end  // PSAPOFF
                        // 3=REFRESH: DRAM-refresh counter - no DRAM in this FPGA/BRAM system, so there is nothing to read back
                        default: begin rwb0_we=1'b1; rwb0_idx=din[7:4]; rwb0_val=16'h0000; end
                    endcase
                end
                // LDCTL ctrl,rs (0x7D_1ccc, NIB3 bit3=1): write Rs -> ctrl reg
                else if (din[15:8]==8'h7D && din[3]==1'b1) begin
                    pc<=pc2; retire<=1'b1;
                    case (din[2:0])
                        3'd2: fcw <=R[din[7:4]];  // FCW (plain overwrite; no NSP swap - S_N never toggles in polepos)
                        3'd5: psap<=R[din[7:4]];  // PSAPOFF
                        // 3=REFRESH (pp_sub boot @0x0012 writes this): intentional no-op - no DRAM refresh timer exists in this system
                        default: ;
                    endcase
                end
                // stack + control flow ==================================== ---- CALL @Rd indirect (0x1F, NIB2=dst!=0,NIB3=0) : ...
                else if (din[15:8]==8'h1F && din[7:4]!=4'h0 && din[3:0]==4'h0) begin
                    ea<=R[din[7:4]]; pc<=pc2; state<=S_CALL_PUSH;
                end
                // CALL addr direct (0x5F00 exact) : MAME Z5F_0000_0000_addr ---- fetch target word, then push PC(=old_pc+4)/jump
                else if (din==16'h5F00) begin
                    pc<=pc2; state<=S_CALL_FETCH;
                end
                // CALL addr(rd) indexed (0x5F10-0x5FF0, NIB2=dst!=0) : MAME Z5F_ddN0_0000_addr
                else if (din[15:8]==8'h5F && din[7:4]!=4'h0 && din[3:0]==4'h0) begin
                    idxr<=din[7:4]; pc<=pc2; state<=S_CALLX_FETCH;
                end
                // 0x30-0x37 PC-relative(dsp16)/indexed(idx16) family
                else if (din[15:8]==8'h30 && din[7:4]==4'h0) begin
                    dst<=din[3:0]; pc<=pc2; state<=S_Z30_FETCH;
                end
                else if (din[15:8]==8'h30 && din[7:4]!=4'h0) begin
                    dst<=din[3:0]; idxr<=din[7:4]; pc<=pc2; state<=S_LDBDAX_FETCH;
                end
                // Z31: LDR rd,dsp16 / LD rd,rs(idx16) -- word load, dst=NIB3 always
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
                // Z34: LDAR prd,dsp16 / LDA prd,rs(idx16)
                else if (din[15:8]==8'h34 && din[7:4]==4'h0) begin
                    dst<=din[3:0]; pc<=pc2; state<=S_Z34_FETCH;
                end
                else if (din[15:8]==8'h34 && din[7:4]!=4'h0) begin
                    dst<=din[3:0]; src<=din[7:4]; lda76_has_src<=1'b1; pc<=pc2; state<=S_LDA76_FETCH;
                end
                // Z35: LDRL rrd,dsp16 / LDL rrd,rs(idx16)
                else if (din[15:8]==8'h35 && din[7:4]==4'h0) begin
                    dst<=din[3:0]; pc<=pc2; state<=S_Z35_FETCH;
                end
                else if (din[15:8]==8'h35 && din[7:4]!=4'h0) begin
                    dst<=din[3:0]; src<=din[7:4]; pc<=pc2; state<=S_LDLAX_FETCH;
                end
                // Z37: LDRL dsp16,rrs / LDL rd(idx16),rrs
                else if (din[15:8]==8'h37 && din[7:4]==4'h0) begin
                    src<=din[3:0]; pc<=pc2; state<=S_Z37_FETCH;
                end
                else if (din[15:8]==8'h37 && din[7:4]!=4'h0) begin
                    src<=din[3:0]; idxr<=din[7:4]; pc<=pc2; state<=S_LDLSAX_FETCH;
                end
                // CALR dsp12 (0xD000-0xDFFF) : MAME ZD_dsp12 ---- target = pc2 - 2*sext12(din[11:0])
                else if (din[15:12]==4'hD) begin
                    ea<=pc2 - {{3{din[11]}}, din[11:0], 1'b0};
                    pc<=pc2; state<=S_CALL_PUSH;
                end
                // RET cc (0x9E, NIB2=0) : MAME Z9E_0000_cccc ---- conditional pop-PC
                else if (din[15:8]==8'h9E && din[7:4]==4'h0) begin
                    if (cc_true(din[3:0],fcw[FC],fcw[FZ],fcw[FS],fcw[FV])) begin
                        state<=S_RET_POP;
                    end else begin
                        pc<=pc2; retire<=1'b1;
                    end
                end
                // PUSH @Rd,Rs (0x93, NIB2=dst!=0) : MAME Z93_ddN0_ssss
                else if (din[15:8]==8'h93 && din[7:4]!=4'h0) begin
                    dst<=din[7:4]; operand<=R[din[3:0]]; pc<=pc2; state<=S_PUSH_W;
                end
                // PUSH @Rd,#imm16 (0x0D, NIB2=dst!=0, NIB3=9) : MAME Z0D_ddN0_1001_imm16
                else if (din[15:8]==8'h0D && din[7:4]!=4'h0 && din[3:0]==4'h9) begin
                    dst<=din[7:4]; pc<=pc2; state<=S_PUSHI_FETCH;
                end
                // PUSH @Rd,addr direct (0x53, NIB2=dst!=0,NIB3=0) : MAME Z53_ddN0_0000_addr
                else if (din[15:8]==8'h53 && din[7:4]!=4'h0 && din[3:0]==4'h0) begin
                    dst<=din[7:4]; pc<=pc2; state<=S_PUSHA_FETCH;
                end
                // PUSH @Rd,addr(rs) indexed (0x53, NIB2=dst!=0,NIB3=src!=0) : MAME Z53_ddN0_ssN0_addr
                else if (din[15:8]==8'h53 && din[7:4]!=4'h0 && din[3:0]!=4'h0) begin
                    dst<=din[7:4]; idxr<=din[3:0]; pc<=pc2; state<=S_PUSHAX_FETCH;
                end
                // POP Rd,@Rs (0x97, NIB2=src!=0) : MAME Z97_ssN0_dddd
                else if (din[15:8]==8'h97 && din[7:4]!=4'h0) begin
                    src<=din[7:4]; dst<=din[3:0]; pc<=pc2; state<=S_POP_R;
                end
                // POP addr,@Rs direct (0x57, NIB2=src!=0,NIB3=0) : MAME Z57_ssN0_0000_addr
                else if (din[15:8]==8'h57 && din[7:4]!=4'h0 && din[3:0]==4'h0) begin
                    src<=din[7:4]; pc<=pc2; state<=S_POPA_FETCH;
                end
                // POP addr(rd),@Rs indexed (0x57, NIB2=src!=0,NIB3=dst!=0) : MAME Z57_ssN0_ddN0_addr
                else if (din[15:8]==8'h57 && din[7:4]!=4'h0 && din[3:0]!=4'h0) begin
                    src<=din[7:4]; idxr<=din[3:0]; pc<=pc2; state<=S_POPAX_FETCH;
                end
                // PUSHL @Rd,RRs (0x91, NIB2=dst!=0) : MAME Z91_ddN0_ssss ---- dst=pointer reg (plain)
                else if (din[15:8]==8'h91 && din[7:4]!=4'h0) begin
                    dst<=din[7:4]; src<=din[3:0]; ea<=R[din[7:4]]-16'd4;
                    l32wb<=1'b1; pc<=pc2; state<=S_L32_WR_HI;
                end
                // POPL RRd,@Rs (0x95, NIB2=src!=0) : MAME Z95_ssN0_dddd ---- src=pointer reg (plain)
                else if (din[15:8]==8'h95 && din[7:4]!=4'h0) begin
                    src<=din[7:4]; dst<=din[3:0]; ea<=R[din[7:4]];
                    l32wb<=1'b1; pc<=pc2; state<=S_L32_RD_HI;
                end
                // PUSHL @Rd,addr[,(rs)] (0x51, NIB2=dst!=0) : MAME Z51_ddN0_0000_addr / Z51_ddN0_ssN0_addr
                else if (din[15:8]==8'h51 && din[7:4]!=4'h0) begin
                    dst<=din[7:4]; pc<=pc2;
                    if (din[3:0]==4'h0) state<=S_PLDA_FETCH;
                    else begin idxr<=din[3:0]; state<=S_PLDA_FETCHX; end
                end
                // POPL addr[,(rd)],@Rs (0x55, NIB2=src!=0) : MAME Z55_ssN0_0000_addr / Z55_ssN0_ddN0_addr
                else if (din[15:8]==8'h55 && din[7:4]!=4'h0) begin
                    src<=din[7:4]; pc<=pc2;
                    if (din[3:0]==4'h0) state<=S_POLDA_FETCH;
                    else begin idxr<=din[3:0]; state<=S_POLDA_FETCHX; end
                end
                // SUBL rrd,addr[,(rs)] (0x52) : MAME Z52_0000_dddd_addr / Z52_ssN0_dddd_addr
                else if (din[15:8]==8'h52) begin
                    dst<=din[3:0]; aluop<=SUB; dwop<=2'd0; pc<=pc2;
                    if (din[7:4]==4'h0) state<=S_DWL_FETCH;
                    else begin idxr<=din[7:4]; state<=S_DWL_FETCHX; end
                end
                // ADDL rrd,addr[,(rs)] (0x56) : MAME Z56_0000_dddd_addr / Z56_ssN0_dddd_addr
                else if (din[15:8]==8'h56) begin
                    dst<=din[3:0]; aluop<=ADD; dwop<=2'd0; pc<=pc2;
                    if (din[7:4]==4'h0) state<=S_DWL_FETCH;
                    else begin idxr<=din[7:4]; state<=S_DWL_FETCHX; end
                end
                // MULTL rqd,addr[,(rs)] (0x58) : MAME Z58_0000_dddd_addr / Z58_ssN0_dddd_addr
                else if (din[15:8]==8'h58) begin
                    dst<=din[3:0]; dwop<=2'd1; pc<=pc2;
                    if (din[7:4]==4'h0) state<=S_DWL_FETCH;
                    else begin idxr<=din[7:4]; state<=S_DWL_FETCHX; end
                end
                // DIVL rqd,addr[,(rs)] (0x5A) : MAME Z5A_0000_dddd_addr / Z5A_ssN0_dddd_addr
                else if (din[15:8]==8'h5A) begin
                    dst<=din[3:0]; dwop<=2'd2; pc<=pc2;
                    if (din[7:4]==4'h0) state<=S_DWL_FETCH;
                    else begin idxr<=din[7:4]; state<=S_DWL_FETCHX; end
                end
                // MULT rrd,addr[,(rs)] (0x59) : MAME Z59_0000_dddd_addr / Z59_ssN0_dddd_addr
                else if (din[15:8]==8'h59) begin
                    dst<=din[3:0]; dwop<=2'd0; pc<=pc2;
                    if (din[7:4]==4'h0) state<=S_DWS_FETCH;
                    else begin idxr<=din[7:4]; state<=S_DWS_FETCHX; end
                end
                // DIV rrd,addr[,(rs)] (0x5B) : MAME Z5B_0000_dddd_addr / Z5B_ssN0_dddd_addr
                else if (din[15:8]==8'h5B) begin
                    dst<=din[3:0]; dwop<=2'd1; pc<=pc2;
                    if (din[7:4]==4'h0) state<=S_DWS_FETCH;
                    else begin idxr<=din[7:4]; state<=S_DWS_FETCHX; end
                end
                // LDL RRd,RRs (0x94, full range) : MAME Z94_ssss_dddd ---- single-cycle reg-pair move, no memory access
                else if (din[15:8]==8'h94) begin
                    rwb0_we=1'b1; rwb0_idx={din[3:1],1'b0};      rwb0_val=R[{din[7:5],1'b0}];
                    rwb1_we=1'b1; rwb1_idx={din[3:1],1'b0}+4'd1; rwb1_val=R[{din[7:5],1'b0}+4'd1];
                    pc<=pc2; retire<=1'b1;
                end
                // LDL RRd,#imm32 (0x14, NIB2=0) : MAME Z14_0000_dddd_imm32 ---- imm32 = {word1(hi),word2(lo)} (verified via ...
                else if (din[15:8]==8'h14 && din[7:4]==4'h0) begin
                    dst<=din[3:0]; pc<=pc2; state<=S_LDL_IMM_HI;
                end
                // LDL RRd,@Rs (0x14, NIB2=src!=0) : MAME Z14_ssN0_dddd
                else if (din[15:8]==8'h14 && din[7:4]!=4'h0) begin
                    dst<=din[3:0]; ea<=R[din[7:4]]; l32wb<=1'b0; pc<=pc2; state<=S_L32_RD_HI;
                end
                // LDL @Rd,RRs (0x1D, NIB2=dst!=0) : MAME Z1D_ddN0_ssss
                else if (din[15:8]==8'h1D && din[7:4]!=4'h0) begin
                    src<=din[3:0]; ea<=R[din[7:4]]; l32wb<=1'b0; pc<=pc2; state<=S_L32_WR_HI;
                end
                // LDL RRd,addr direct (0x54, NIB2=0) : MAME Z54_0000_dddd_addr
                else if (din[15:8]==8'h54 && din[7:4]==4'h0) begin
                    dst<=din[3:0]; pc<=pc2; state<=S_LDLA_FETCH;
                end
                // (post-verify): LDL RRd,addr(rs) indexed (0x54, NIB2!=0) : MAME Z54_ssN0_dddd_addr
                else if (din[15:8]==8'h54 && din[7:4]!=4'h0) begin
                    dst<=din[3:0]; src<=din[7:4]; pc<=pc2; state<=S_LDLAX_FETCH;
                end
                // LDL addr,RRs direct (0x5D, NIB2=0) : MAME Z5D_0000_ssss_addr
                else if (din[15:8]==8'h5D && din[7:4]==4'h0) begin
                    src<=din[3:0]; pc<=pc2; state<=S_LDLSA_FETCH;
                end
                // LDL addr(rx),RRs indexed (0x5D, NIB2!=0) : MAME Z5D_ddN0_ssss_addr (dst here is the INDEX reg per z8000ops.hxx ...
                else if (din[15:8]==8'h5D && din[7:4]!=4'h0) begin
                    src<=din[3:0]; idxr<=din[7:4]; pc<=pc2; state<=S_LDLSAX_FETCH;
                end
                // LDM rd,@rs,n (0x1C, NIB2=src!=0,NIB3=1) : MAME Z1C_ssN0_0001_0000_dddd_0000_nmin1 ---- word2 = ...
                else if (din[15:8]==8'h1C && din[7:4]!=4'h0 && din[3:0]==4'h1) begin
                    src<=din[7:4]; pc<=pc2; state<=S_LDM_L_FETCH2;
                end
                // LDM @rd,rs,n (0x1C, NIB2=dst!=0,NIB3=9) : MAME Z1C_ddN0_1001_0000_ssss_0000_nmin1
                else if (din[15:8]==8'h1C && din[7:4]!=4'h0 && din[3:0]==4'h9) begin
                    dst<=din[7:4]; pc<=pc2; state<=S_LDM_S_FETCH2;
                end
                // TESTL @rd (0x1C, NIB2=dst!=0,NIB3=8) : MAME Z1C_ddN0_1000 "testl @rd", flags -ZS---. Register-indirect sibling ...
                else if (din[15:8]==8'h1C && din[7:4]!=4'h0 && din[3:0]==4'h8) begin
                    ea<=R[din[7:4]]; pc<=pc2; state<=S_TL_RD_HI;
                end
                // (post-verify): LDM addr,rs,n (0x5C09) direct-address STORE : MAME Z5C_0000_1001_0000_ssss_0000_nmin1_addr
                else if (din==16'h5C09) begin
                    ldmx<=1'b0; pc<=pc2; state<=S_LDM_DA_FETCH2;
                end
                // LDM addr(rd),rs,n (0x5CN9, NIB2=idx!=0) indexed sibling of 0x5C09 above : MAME ...
                else if (din[15:8]==8'h5C && din[3:0]==4'h9 && din[7:4]!=4'h0) begin
                    idxr<=din[7:4]; ldmx<=1'b1; pc<=pc2; state<=S_LDM_DA_FETCH2;
                end
                // LDM rd,addr,n (0x5C01) direct-address LOAD, the load-direction sibling of 0x5C09 above : MAME ...
                else if (din==16'h5C01) begin
                    ldmx<=1'b0; pc<=pc2; state<=S_LDM_DA_LFETCH2;
                end
                // LDM rd,addr(rs),n (0x5CN1, NIB2=idx!=0) indexed sibling of 0x5C01 above : MAME ...
                else if (din[15:8]==8'h5C && din[3:0]==4'h1 && din[7:4]!=4'h0) begin
                    idxr<=din[7:4]; ldmx<=1'b1; pc<=pc2; state<=S_LDM_DA_LFETCH2;
                end
                // TESTL addr (0x5C08 exact) : MAME Z5C_0000_1000_addr
                else if (din==16'h5C08) begin
                    pc<=pc2; state<=S_TL_FETCH;
                end
                // TESTL addr(rd) indexed (0x5CN8, NIB2=idx!=0) : MAME Z5C_ddN0_1000_addr.
                else if (din[15:8]==8'h5C && din[3:0]==4'h8 && din[7:4]!=4'h0) begin
                    idxr<=din[7:4]; pc<=pc2; state<=S_TL_FETCHX;
                end
                // indirect-indirect PUSHL/PUSH/POPL/POP ================ ---- PUSHL @Rd,@Rs (0x11) : MAME Z11_ddN0_ssN0 "pushl ...
                else if (din[15:8]==8'h11 && din[7:4]!=4'h0 && !(din[7:4]==4'h1 && din[3:0]==4'h0)) begin
                    dst<=din[7:4]; src<=din[3:0]; ea<=R[din[7:4]]-16'd4; pc<=pc2; state<=S_PLII_RD_HI;
                end
                // PUSH @Rd,@Rs (0x13) : MAME Z13_ddN0_ssN0 "push @rd,@rs" ---- value = word read INDIRECTLY at R[src] (unmodified)
                else if (din[15:8]==8'h13 && din[7:4]!=4'h0 && !(din[7:4]==4'h1 && din[3:0]==4'h0)) begin
                    dst<=din[7:4]; src<=din[3:0]; pc<=pc2; state<=S_PUSHII_RD;
                end
                // POPL RRd,@Rs (0x15) : MAME Z15_ssN0_ddN0 "popl rd,@rs" ---- Body is BYTE-IDENTICAL to the already-implemented ...
                else if (din[15:8]==8'h15 && din[7:4]!=4'h0 && !(din[7:4]==4'h1 && din[3:0]==4'h0)) begin
                    src<=din[7:4]; dst<=din[3:0]; ea<=R[din[7:4]];
                    l32wb<=1'b1; pc<=pc2; state<=S_L32_RD_HI;
                end
                // POP @Rd,@Rs (0x17) : MAME Z17_ssN0_ddN0 "pop @rd,@rs" ---- src(NIB2)=source pointer (POPPED: read then +2)
                else if (din[15:8]==8'h17 && din[7:4]!=4'h0 && !(din[7:4]==4'h1 && din[3:0]==4'h0)) begin
                    dst<=din[3:0]; src<=din[7:4]; pc<=pc2; state<=S_POPII_RD;
                end
                // byte ALU/LDB, LDB store, CPL, JP/EX, BIT/RES/SET ===== Shared byte pipeline (S_IMMB/S_MEMRDB/S_ALUB) mirrors ...
                else if (din[15:8]==8'h00 && din[7:4]==4'h0) begin
                    dst<=din[3:0]; aluop<=ADD; pc<=pc2; state<=S_IMMB;
                end
                // SUBB rd,#imm8/@rs (0x02) : MAME Z02_0000_dddd_imm8 / Z02_ssN0_dddd
                else if (din[15:8]==8'h02) begin
                    dst<=din[3:0]; aluop<=SUB; pc<=pc2;
                    if (din[7:4]==4'h0) state<=S_IMMB; else begin src<=din[7:4]; state<=S_MEMRDB; end
                end
                // ORB rd,#imm8/@rs (0x04) : MAME Z04_0000_dddd_imm8 / Z04_ssN0_dddd
                else if (din[15:8]==8'h04) begin
                    dst<=din[3:0]; aluop<=OR; pc<=pc2;
                    if (din[7:4]==4'h0) state<=S_IMMB; else begin src<=din[7:4]; state<=S_MEMRDB; end
                end
                // ANDB rd,#imm8/@rs (0x06) : MAME Z06_0000_dddd_imm8 / Z06_ssN0_dddd
                else if (din[15:8]==8'h06) begin
                    dst<=din[3:0]; aluop<=AND; pc<=pc2;
                    if (din[7:4]==4'h0) state<=S_IMMB; else begin src<=din[7:4]; state<=S_MEMRDB; end
                end
                // XORB rd,#imm8/@rs (0x08) : MAME Z08_0000_dddd_imm8 / Z08_ssN0_dddd
                else if (din[15:8]==8'h08) begin
                    dst<=din[3:0]; aluop<=XOR; pc<=pc2;
                    if (din[7:4]==4'h0) state<=S_IMMB; else begin src<=din[7:4]; state<=S_MEMRDB; end
                end
                // CPB rd,#imm8/@rs (0x0A) : MAME Z0A_0000_dddd_imm8 / Z0A_ssN0_dddd
                else if (din[15:8]==8'h0A) begin
                    dst<=din[3:0]; aluop<=CP; pc<=pc2;
                    if (din[7:4]==4'h0) state<=S_IMMB; else begin src<=din[7:4]; state<=S_MEMRDB; end
                end
                // LDB rd,#imm8/@rs (0x20) : MAME Z20_0000_dddd_imm8 / Z20_ssN0_dddd
                else if (din[15:8]==8'h20) begin
                    dst<=din[3:0]; aluop<=LD; pc<=pc2;
                    if (din[7:4]==4'h0) state<=S_IMMB; else begin src<=din[7:4]; state<=S_MEMRDB; end
                end
                // byte reg-reg ALU: 80=ADDB 82=SUBB 84=ORB 86=ANDB 88=XORB 8A=CPB A0=LDB
                else if (din[15:8]==8'h80 || din[15:8]==8'h82 || din[15:8]==8'h84 ||
                         din[15:8]==8'h86 || din[15:8]==8'h88 || din[15:8]==8'h8A ||
                         din[15:8]==8'hA0) begin
                    dst<=din[3:0]; operand[7:0]<= din[7] ? R[din[6:4]][7:0] : R[din[6:4]][15:8];
                    pc<=pc2; state<=S_ALUB;
                    case (din[15:8])
                        8'h80: aluop<=ADD; 8'h82: aluop<=SUB; 8'h84: aluop<=OR;
                        8'h86: aluop<=AND; 8'h88: aluop<=XOR; 8'h8A: aluop<=CP;
                        default: aluop<=LD;  // 0xA0
                    endcase
                end
                // LDB @Rd,rbs store (0x2E, NIB2=dst!=0) : MAME Z2E_ddN0_ssss "ldb @rd,rbs" ---- RMW-safe byte store, see ...
                else if (din[15:8]==8'h2E && din[7:4]!=4'h0) begin
                    dst<=din[7:4]; src<=din[3:0]; pc<=pc2; state<=S_LDBST_RD;
                end
                // JP cc,@Rd (0x1E, NIB2=dst!=0) : MAME Z1E_ddN0_cccc "jp cc,@rd" ---- addr_from_reg(dst) reduces to plain RW(dst) ...
                else if (din[15:8]==8'h1E && din[7:4]!=4'h0) begin
                    pc <= cc_true(din[3:0],fcw[FC],fcw[FZ],fcw[FS],fcw[FV]) ? R[din[7:4]] : pc2;
                    retire<=1'b1;
                end
                // CPL rrd,@rs (0x10, NIB2=src!=0) : MAME Z10_ssN0_dddd "cpl rrd,@rs" ---- compare-only long, no writeback
                else if (din[15:8]==8'h10 && din[7:4]!=4'h0) begin
                    dst<=din[3:0]; src<=din[7:4]; pc<=pc2; state<=S_CPL_RD_HI;
                end
                // CPL rrd,rrs (0x90, full range) : MAME Z90_ssss_dddd "cpl rrd,rrs" ---- compare-only, no writeback, no memory access
                else if (din[15:8]==8'h90) begin
                    dst<=din[3:0]; src<=din[7:4]; pc<=pc2; state<=S_CPL_RR;
                end
                // BITB @Rd,#imm4 (0x26, NIB2=dst!=0) : MAME Z26_ddN0_imm4, flags -Z---- ---- read-only (no RMW hazard)
                else if (din[15:8]==8'h26 && din[7:4]!=4'h0) begin
                    dst<=din[7:4]; bmask<=(16'h0001<<din[3:0]); pc<=pc2; state<=S_BITB_RD;
                end
                // BIT @Rd,#imm4 (0x27, NIB2=dst!=0) : MAME Z27_ddN0_imm4, flags -Z
                else if (din[15:8]==8'h27 && din[7:4]!=4'h0) begin
                    dst<=din[7:4]; bmask<=(16'h0001<<din[3:0]); pc<=pc2; state<=S_BIT_RD;
                end
                // RESB/RES/SETB/SET @Rd,#imm4 static forms ---- RES/SET (word, 0x23/0x25) are safe word-aligned RMW (no wordacc ...
                else if (din[15:8]==8'h23 && din[7:4]!=4'h0) begin
                    dst<=din[7:4]; bmask<=(16'h0001<<din[3:0]); bitop_set<=1'b0;
                    pc<=pc2; state<=S_BITW_RD;
                end
                // SET @Rd,#imm4 (0x25, NIB2=dst!=0) : MAME Z25_ddN0_imm4, flags
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
                // EX rd,@rs (0x2D, NIB2=src!=0) : MAME Z2D_ssN0_dddd "ex rd,@rs", flags ------ ---- word-only exchange (safe, ...
                else if (din[15:8]==8'h2D && din[7:4]!=4'h0) begin
                    dst<=din[3:0]; src<=din[7:4]; pc<=pc2; state<=S_EX_RD;
                end
                // INC addr,#n direct (0x6900-0x690F, NIB2=0) : MAME Z69_0000_imm4m1_addr, flags -ZSV--. Indexed addr(Rd) form ...
                else if (din[15:8]==8'h69 && din[7:4]==4'h0) begin
                    mcnt<=din[3:0]; aluop<=ADD; pc<=pc2; state<=S_INCDA_FETCH;
                end
                // DEC addr,#n direct (0x6B00-0x6B0F, NIB2=0) : MAME Z6B_0000_imm4m1_addr, flags -ZSV--. Indexed form deferred ...
                else if (din[15:8]==8'h6B && din[7:4]==4'h0) begin
                    mcnt<=din[3:0]; aluop<=SUB; pc<=pc2; state<=S_INCDA_FETCH;
                end
                // MULT rrd,#imm16 (0x1900-0x190F, NIB2=0) : MAME Z19_0000_dddd_imm16 ---- flags CZS
                else if (din[15:8]==8'h19 && din[7:4]==4'h0) begin
                    dst<=din[3:0]; pc<=pc2; state<=S_MULT_IMM;
                end
                // MULT rrd,@rs (0x1910-0x19FF, NIB2!=0) : MAME Z19_ssN0_dddd
                else if (din[15:8]==8'h19 && din[7:4]!=4'h0) begin
                    dst<=din[3:0]; src<=din[7:4]; pc<=pc2; state<=S_MULT_RD;
                end
                // MULT rrd,rs (0x9900-0x99FF, full range) : MAME Z99_ssss_dddd
                else if (din[15:8]==8'h99) begin
                    dst<=din[3:0]; operand<=R[din[7:4]]; pc<=pc2; state<=S_MULT_GO;
                end
                // DIV rrd,#imm16 (0x1B00-0x1B0F, NIB2=0) : MAME Z1B_0000_dddd_imm16 ---- flags CZSV--. Divide-by-zero: Z,V set, ...
                else if (din[15:8]==8'h1B && din[7:4]==4'h0) begin
                    dst<=din[3:0]; pc<=pc2; state<=S_DIV_IMM;
                end
                // DIV rrd,@rs (0x1B10-0x1BFF, NIB2!=0) : MAME Z1B_ssN0_dddd
                else if (din[15:8]==8'h1B && din[7:4]!=4'h0) begin
                    dst<=din[3:0]; src<=din[7:4]; pc<=pc2; state<=S_DIV_RD;
                end
                // DIV rrd,rs (0x9B00-0x9BFF, full range) : MAME Z9B_ssss_dddd
                else if (din[15:8]==8'h9B) begin
                    dst<=din[3:0]; operand<=R[din[7:4]]; pc<=pc2; state<=S_DIV_GO;
                end
                // MULTL rqd,@rs (0x1810-0x18FF, NIB2!=0) : MAME Z18_ssN0_dddd ---- RQ(dst) truncates dst's low TWO bits (see ...
                else if (din[15:8]==8'h18 && din[7:4]!=4'h0) begin
                    dst<=din[3:0]; src<=din[7:4]; pc<=pc2; state<=S_MULTL_RD_HI;
                end
                // MULTL rqd,#imm32 (0x1800-0x180F, NIB2=0) : MAME Z18_00N0_dddd_imm32
                else if (din[15:8]==8'h18 && din[7:4]==4'h0) begin
                    dst<=din[3:0]; pc<=pc2; state<=S_MULTLI_HI;
                end
                // MULTL rqd,rrs (0x9800-0x98FF, full range) : MAME Z98_ssss_dddd ---- src is a 32-bit register PAIR here (unlike ...
                else if (din[15:8]==8'h98) begin
                    dst<=din[3:0];
                    operand <=R[{din[7:5],1'b0}]; operand2<=R[{din[7:5],1'b0}+4'd1];
                    pc<=pc2; state<=S_MULTL_GO;
                end
                // DIVL rqd,@rs (0x1A10-0x1AFF, NIB2!=0) : MAME Z1A_ssN0_dddd ---- Dividend is the FULL 64-bit quad (read live off ...
                else if (din[15:8]==8'h1A && din[7:4]!=4'h0) begin
                    dst<=din[3:0]; src<=din[7:4]; pc<=pc2; state<=S_DIVL_RD_HI;
                end
                // DIVL rqd,#imm32 (0x1A00-0x1A0F, NIB2=0) : MAME Z1A_0000_dddd_imm32
                else if (din[15:8]==8'h1A && din[7:4]==4'h0) begin
                    dst<=din[3:0]; pc<=pc2; state<=S_DIVLI_HI;
                end
                // DIVL rqd,rrs (0x9A00-0x9AFF, full range) : MAME Z9A_ssss_dddd
                else if (din[15:8]==8'h9A) begin
                    dst<=din[3:0];
                    operand <=R[{din[7:5],1'b0}]; operand2<=R[{din[7:5],1'b0}+4'd1];
                    pc<=pc2; state<=S_DIVL_GO;
                end
                // ADDL rrd,#imm32 (0x1600-0x160F, NIB2=0) : MAME Z16_0000_dddd_imm32
                else if (din[15:8]==8'h16 && din[7:4]==4'h0) begin
                    dst<=din[3:0]; aluop<=ADD; pc<=pc2; state<=S_LALU_IMM_HI;
                end
                // ADDL rrd,@rs (0x1610-0x16FF, NIB2!=0) : MAME Z16_ssN0_dddd
                else if (din[15:8]==8'h16 && din[7:4]!=4'h0) begin
                    dst<=din[3:0]; src<=din[7:4]; aluop<=ADD; pc<=pc2; state<=S_LALU_RD_HI;
                end
                // ADDL rrd,rrs (0x9600-0x96FF, full range) : MAME Z96_ssss_dddd
                else if (din[15:8]==8'h96) begin
                    dst<=din[3:0]; aluop<=ADD;
                    operand <=R[{din[7:5],1'b0}]; operand2<=R[{din[7:5],1'b0}+4'd1];
                    pc<=pc2; state<=S_LALU_GO;
                end
                // SUBL rrd,#imm32 (0x1200-0x120F, NIB2=0) : MAME Z12_0000_dddd_imm32
                else if (din[15:8]==8'h12 && din[7:4]==4'h0) begin
                    dst<=din[3:0]; aluop<=SUB; pc<=pc2; state<=S_LALU_IMM_HI;
                end
                // SUBL rrd,@rs (0x1210-0x12FF, NIB2!=0) : MAME Z12_ssN0_dddd
                else if (din[15:8]==8'h12 && din[7:4]!=4'h0) begin
                    dst<=din[3:0]; src<=din[7:4]; aluop<=SUB; pc<=pc2; state<=S_LALU_RD_HI;
                end
                // SUBL rrd,rrs (0x9200-0x92FF, full range) : MAME Z92_ssss_dddd
                else if (din[15:8]==8'h92) begin
                    dst<=din[3:0]; aluop<=SUB;
                    operand <=R[{din[7:5],1'b0}]; operand2<=R[{din[7:5],1'b0}+4'd1];
                    pc<=pc2; state<=S_LALU_GO;
                end
                // LDB rbd,addr direct-load (0x6000-0x600F, NIB2=0) : MAME Z60_0000_dddd_addr "ldb rbd,addr", flags ------. Read-only
                else if (din[15:8]==8'h60 && din[7:4]==4'h0) begin
                    dst<=din[3:0]; pc<=pc2; state<=S_LDBDA_FETCH;
                end
                // LDB addr,rbs direct-store (0x6E00-0x6E0F, NIB2=0) : MAME Z6E_0000_ssss_addr "ldb addr,rbs", flags ------. RMW ...
                else if (din[15:8]==8'h6E && din[7:4]==4'h0) begin
                    src<=din[3:0]; pc<=pc2; state<=S_LDBSTA_FETCH;
                end
                // CLRB rbd (0x8Cd8, NIB1=8) : MAME Z8C_dddd_1000, flags ------ ---- 0x8C is actually a 7-way static-op family ...
                else if (din[15:8]==8'h8C && din[3:0]==4'h8) begin
                    rwb0_we=1'b1; rwb0_idx={1'b0,din[6:4]}; rwb0_val=16'h0000; rwb0_be=din[7]?2'b01:2'b10;
                    pc<=pc2; retire<=1'b1;
                end
                // TESTB rbd (0x8Cd4, NIB1=4) : MAME Z8C_dddd_0100, flags -ZSP-- ---- Z/S/parity via the same ...
                else if (din[15:8]==8'h8C && din[3:0]==4'h4) begin
                    dbyte = din[7] ? R[din[6:4]][7:0] : R[din[6:4]][15:8];
                    p = (~^dbyte);
                    fcw<=(fcw & ~(MZ|MS|MV)) | ((dbyte==8'h00)?MZ:0)|(dbyte[7]?MS:0)|(p?MV:0);
                    pc<=pc2; retire<=1'b1;
                end
                // RLB rbd,#1|#2 (0xB2d0/0xB2d2, NIB1={0,2}) : MAME ZB2_dddd_00I0, flags CZSV--. twice=NIB1 bit1
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
                // RRB rbd,#1|#2 (0xB2d4/0xB2d6, NIB1={4,6}) : MAME ZB2_dddd_01I0, flags CZSV--. QUIRK (verified in RRB(), not the ...
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
                // Two-stage carry bookkeeping for `twice`: the first rotation's carry-OUT becomes the second rotation's carry-IN ...
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
                // RLCB rbd,#1|#2 (0xB2d8/0xB2dA, NIB1={8,A}) : MAME ZB2_dddd_10I0 "rotate left through carry", flags CZSV--. ...
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
                // SLLB/SRLB rbd,#imm8 (0xB2d1, NIB1=1) : MAME ZB2_dddd_0001_imm8, sign of imm8 selects direction (matches the ...
                else if (din[15:8]==8'hB2 && din[3:0]==4'h1) begin
                    dst<=din[7:4]; pc<=pc2; state<=S_SHIFTB;
                end
                // Dynamic (register- count) sibling of SLLB/SRLB: count = sign-extended R[word2 NIB1][7:0], ...
                else if (din[15:8]==8'hB2 && din[3:0]==4'h3) begin
                    dst<=din[7:4]; pc<=pc2; state<=S_SDLB_GO;
                end
                // SDAB rbd,rs (0xB2dB) : MAME ZB2_dddd_1011_0000_ssss_0000_0000, flags CZSV--. Same shape as SDLB above
                else if (din[15:8]==8'hB2 && din[3:0]==4'hB) begin
                    dst<=din[7:4]; pc<=pc2; state<=S_SDAB_GO;
                end
                // SLAB/SRAB rbd,#imm8 (0xB2d9) : MAME ZB2_dddd_1001_imm8, flags CZSV-- (byte arithmetic sibling of the ...
                else if (din[15:8]==8'hB2 && din[3:0]==4'h9) begin
                    dst<=din[7:4]; pc<=pc2; state<=S_SHIFTAB;
                end
                // RL/RR/RLC/RRC rd,#1|#2 (0xB3d0/d2/d4/d6/d8/dA/dC/dE) : MAME ZB3_dddd_00I0/01I0/10I0/11I0, flags CZSV--. Word ...
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
                // RR rd,#1|#2 (0xB3d4/0xB3d6) : same "if result==0 only Z
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
                // RLC rd,#1|#2 (0xB3d8/0xB3dA) : word sibling of RLCB above.
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
                // RRC rd,#1|#2 (0xB3dC/0xB3dE) : word sibling of the already-implemented RRCB.
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
                // SDL/SDA rd,rs (0xB3d3/dB) and SDLL/SDAL rrd,rs (0xB3d7/dF)
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
                // CPL rrd,addr direct (0x5000-0x500F, NIB2=0) : MAME Z50_0000_dddd_addr "cpl rrd,addr", compare-only, no writeback
                else if (din[15:8]==8'h50 && din[7:4]==4'h0) begin
                    dst<=din[3:0]; pc<=pc2; state<=S_CPLA_FETCH;
                end
                // register-indexed addr(Rx) EA datapath (CENTERPIECE) ========= For each family below, NIB2 (din[7:4]) is the ...
                else if (din[15:8]==8'h60 && din[7:4]!=4'h0) begin
                    dst<=din[3:0]; idxr<=din[7:4]; pc<=pc2; state<=S_LDBDAX_FETCH;
                end
                // Real usage 9/21 of LDB-store
                else if (din[15:8]==8'h6E && din[7:4]!=4'h0) begin
                    src<=din[3:0]; idxr<=din[7:4]; pc<=pc2; state<=S_LDBSTAX_FETCH;
                end
                // CPL rrd,addr(Rs) indexed (0x5010-0x50FF, NIB2=idx!=0) : MAME Z50_ssN0_dddd_addr
                else if (din[15:8]==8'h50 && din[7:4]!=4'h0) begin
                    dst<=din[3:0]; idxr<=din[7:4]; pc<=pc2; state<=S_CPLAX_FETCH;
                end
                // INC addr(Rd),#n indexed (0x6910-0x69FF, NIB2=idx!=0) : MAME Z69_ddN0_imm4m1_addr
                else if (din[15:8]==8'h69 && din[7:4]!=4'h0) begin
                    mcnt<=din[3:0]; aluop<=ADD; idxr<=din[7:4]; pc<=pc2; state<=S_INCDAX_FETCH;
                end
                // DEC addr(Rd),#n indexed (0x6B10-0x6BFF, NIB2=idx!=0) : MAME Z6B_ddN0_imm4m1_addr
                else if (din[15:8]==8'h6B && din[7:4]!=4'h0) begin
                    mcnt<=din[3:0]; aluop<=SUB; idxr<=din[7:4]; pc<=pc2; state<=S_INCDAX_FETCH;
                end
                // register-only bonus opcodes ================================== ---- NEG rd (0x8Dd2, NIB0=2) : MAME ...
                else if (din[15:8]==8'h8D && din[3:0]==4'h2) begin
                    res16 = 16'h0000 - R[din[7:4]];
                    v = (res16==16'h8000);
                    rwb0_we=1'b1; rwb0_idx=din[7:4]; rwb0_val=res16;
                    fcw<=(fcw & ~(MC|MZ|MS|MV))
                       | ((res16!=16'h0000)?MC:0)|((res16==16'h0000)?MZ:0)|(res16[15]?MS:0)|(v?MV:0);
                    pc<=pc2; retire<=1'b1;
                end
                // COM rd (0x8Dd0, NIB0=0) : MAME Z8D_dddd_0000, flags -ZS---. Real usage only ~6 but zero marginal cost (same ...
                else if (din[15:8]==8'h8D && din[3:0]==4'h0) begin
                    res16 = ~R[din[7:4]];
                    rwb0_we=1'b1; rwb0_idx=din[7:4]; rwb0_val=res16;
                    fcw<=(fcw & ~(MZ|MS)) | ((res16==16'h0000)?MZ:0)|(res16[15]?MS:0);
                    pc<=pc2; retire<=1'b1;
                end
                // Real usage 7.
                else if (din[15:8]==8'hB1 && din[3:0]==4'h0) begin
                    rwb0_we=1'b1; rwb0_idx=din[7:4]; rwb0_val={{8{R[din[7:4]][7]}}, R[din[7:4]][7:0]};
                    pc<=pc2; retire<=1'b1;
                end
                // DAB rbd (0xB0d0, NIB0=0) : MAME ZB0_dddd_0000 "dab rbd", flags CZS---. dst(NIB2=din[7:4]) is a byte-reg code ...
                else if (din[15:8]==8'hB0 && din[3:0]==4'h0) begin
                    dab_byte = din[7] ? R[din[6:4]][7:0] : R[din[6:4]][15:8];
                    dab_idx  = {fcw[FDA], fcw[FH], fcw[FC], dab_byte};
                    dab_res  = dab_rom[dab_idx];
                    rwb0_we=1'b1; rwb0_idx={1'b0,din[6:4]}; rwb0_val={2{dab_res[7:0]}}; rwb0_be=din[7]?2'b01:2'b10;
                    fcw<=(fcw & ~(MC|MZ|MS)) | (dab_res[8]?MC:0) | ((dab_res[7:0]==8'h00)?MZ:0) | (dab_res[7]?MS:0);
                    pc<=pc2; retire<=1'b1;
                end
                // Pair-base = {din[7:5],1'b0} (bit0-of-nibble truncation, same derivation already used for the ADDL/SUBL reg-reg ...
                else if (din[15:8]==8'hB1 && din[3:0]==4'hA) begin
                    rwb0_we=1'b1; rwb0_idx={din[7:5],1'b0}; rwb0_val={16{R[{din[7:5],1'b0}+4'd1][15]}};
                    pc<=pc2; retire<=1'b1;
                end
                // RESB @Rd,#imm4 (0x2210-0x22FF, NIB2=dst!=0) : MAME Z22_ddN0_imm4 "resb @rd,imm4", flags ------. Byte RMW via ...
                else if (din[15:8]==8'h22 && din[7:4]!=4'h0) begin
                    dst<=din[7:4]; bmask<=(16'h0001<<din[3:0]); bitop_set<=1'b0;
                    pc<=pc2; state<=S_RESETB_RD;
                end
                // SETB @Rd,#imm4 (0x2410-0x24FF, NIB2=dst!=0) : MAME Z24_ddN0_imm4 "setb @rd,imm4", flags ------. Same ...
                else if (din[15:8]==8'h24 && din[7:4]!=4'h0) begin
                    dst<=din[7:4]; bmask<=(16'h0001<<din[3:0]); bitop_set<=1'b1;
                    pc<=pc2; state<=S_RESETB_RD;
                end
                // EXB rbd,@rs (0x2C10-0x2CFF, NIB2=src!=0) : MAME Z2C_ssN0_dddd "exb rbd,@rs", flags ------. Byte RMW exchange ...
                else if (din[15:8]==8'h2C && din[7:4]!=4'h0) begin
                    dst<=din[3:0]; src<=din[7:4]; pc<=pc2; state<=S_EXB_RD;
                end
                // EXB rbd,rbs (0xAC, full range) : MAME ZAC_ssss_dddd "exb rbd,rbs", flags ------. Register-only byte swap, ...
                else if (din[15:8]==8'hAC) begin
                    rwb0_we=1'b1; rwb0_idx={1'b0,din[2:0]}; rwb0_be=din[3]?2'b01:2'b10; rwb0_val={2{din[7] ? R[din[6:4]][7:0] : R[din[6:4]][15:8]}};
                    rwb1_we=1'b1; rwb1_idx={1'b0,din[6:4]}; rwb1_be=din[7]?2'b01:2'b10; rwb1_val={2{din[3] ? R[din[2:0]][7:0] : R[din[2:0]][15:8]}};
                    pc<=pc2; retire<=1'b1;
                end
                // dst=NIB3,src=NIB2 (both byte-reg codes)
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
                // ADC rd,rs (0xB5, full range) : MAME ZB5_ssss_dddd, flags CZSV-- (no H/DA, matches ADDW)
                else if (din[15:8]==8'hB5) begin
                    a16 = R[din[3:0]];
                    sum17 = {1'b0,a16} + {1'b0,R[din[7:4]]} + {16'd0,fcw[FC]};
                    v = (~a16[15]&~R[din[7:4]][15]&sum17[15])|(a16[15]&R[din[7:4]][15]&~sum17[15]);
                    rwb0_we=1'b1; rwb0_idx=din[3:0]; rwb0_val=sum17[15:0];
                    fcw<=(fcw & ~(MC|MZ|MS|MV))
                       | (sum17[16]?MC:0)|((sum17[15:0]==0)?MZ:0)|(sum17[15]?MS:0)|(v?MV:0);
                    pc<=pc2; retire<=1'b1;
                end
                // C/H computed as borrow-out of a 9-bit/5-bit subtract-with-borrow-in (dual of ADCB's carry form, same ...
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
                // SBC rd,rs (0xB7, full range) : MAME ZB7_ssss_dddd, flags CZSV-- (no H/DA, matches SUBW)
                else if (din[15:8]==8'hB7) begin
                    a16 = R[din[3:0]];
                    dif17 = {1'b0,a16} - {1'b0,R[din[7:4]]} - {16'd0,fcw[FC]};
                    v = (~R[din[7:4]][15]&a16[15]&~dif17[15])|(R[din[7:4]][15]&~a16[15]&dif17[15]);
                    rwb0_we=1'b1; rwb0_idx=din[3:0]; rwb0_val=dif17[15:0];
                    fcw<=(fcw & ~(MC|MZ|MS|MV))
                       | (dif17[16]?MC:0)|((dif17[15:0]==0)?MZ:0)|(dif17[15]?MS:0)|(v?MV:0);
                    pc<=pc2; retire<=1'b1;
                end
                // direct-address(+index) RESB/RES/SETB/SET/BITB/BIT/EXB/EX ==== NIB2(din[7:4])=0 -> direct (ea<=din)
                else if (din[15:8]==8'h62 && din[7:4]==4'h0) begin
                    bmask<=(16'h0001<<din[3:0]); bitop_set<=1'b0; pc<=pc2; state<=S_DAB_RESB_FETCH;
                end
                else if (din[15:8]==8'h62 && din[7:4]!=4'h0) begin
                    bmask<=(16'h0001<<din[3:0]); bitop_set<=1'b0; idxr<=din[7:4];
                    pc<=pc2; state<=S_DAB_RESBX_FETCH;
                end
                // RES addr[,(rd)],#imm4 (0x6300-0x63FF) : MAME Z63_0000_imm4_addr / Z63_ddN0_imm4_addr, word RMW, flags ------. ...
                else if (din[15:8]==8'h63 && din[7:4]==4'h0) begin
                    bmask<=(16'h0001<<din[3:0]); bitop_set<=1'b0; pc<=pc2; state<=S_DAB_RESW_FETCH;
                end
                else if (din[15:8]==8'h63 && din[7:4]!=4'h0) begin
                    bmask<=(16'h0001<<din[3:0]); bitop_set<=1'b0; idxr<=din[7:4];
                    pc<=pc2; state<=S_DAB_RESWX_FETCH;
                end
                // SETB addr[,(rd)],#imm4 (0x6400-0x64FF) : MAME Z64_0000_imm4_addr / Z64_ddN0_imm4_addr, byte RMW, flags ------. ...
                else if (din[15:8]==8'h64 && din[7:4]==4'h0) begin
                    bmask<=(16'h0001<<din[3:0]); bitop_set<=1'b1; pc<=pc2; state<=S_DAB_RESB_FETCH;
                end
                else if (din[15:8]==8'h64 && din[7:4]!=4'h0) begin
                    bmask<=(16'h0001<<din[3:0]); bitop_set<=1'b1; idxr<=din[7:4];
                    pc<=pc2; state<=S_DAB_RESBX_FETCH;
                end
                // SET addr[,(rd)],#imm4 (0x6500-0x65FF) : MAME Z65_0000_imm4_addr / Z65_ddN0_imm4_addr, word RMW, flags ------. ...
                else if (din[15:8]==8'h65 && din[7:4]==4'h0) begin
                    bmask<=(16'h0001<<din[3:0]); bitop_set<=1'b1; pc<=pc2; state<=S_DAB_RESW_FETCH;
                end
                else if (din[15:8]==8'h65 && din[7:4]!=4'h0) begin
                    bmask<=(16'h0001<<din[3:0]); bitop_set<=1'b1; idxr<=din[7:4];
                    pc<=pc2; state<=S_DAB_RESWX_FETCH;
                end
                // BITB addr[,(rd)],#imm4 (0x6600-0x66FF) : MAME Z66_0000_imm4_addr / Z66_ddN0_imm4_addr, read-only byte, flags ...
                else if (din[15:8]==8'h66 && din[7:4]==4'h0) begin
                    bmask<=(16'h0001<<din[3:0]); pc<=pc2; state<=S_DAB_BITB_FETCH;
                end
                else if (din[15:8]==8'h66 && din[7:4]!=4'h0) begin
                    bmask<=(16'h0001<<din[3:0]); idxr<=din[7:4]; pc<=pc2; state<=S_DAB_BITBX_FETCH;
                end
                // BIT addr[,(rd)],#imm4 (0x6700-0x67FF) : MAME Z67_0000_imm4_addr / Z67_ddN0_imm4_addr, read-only word, flags ...
                else if (din[15:8]==8'h67 && din[7:4]==4'h0) begin
                    bmask<=(16'h0001<<din[3:0]); pc<=pc2; state<=S_DAB_BITW_FETCH;
                end
                else if (din[15:8]==8'h67 && din[7:4]!=4'h0) begin
                    bmask<=(16'h0001<<din[3:0]); idxr<=din[7:4]; pc<=pc2; state<=S_DAB_BITWX_FETCH;
                end
                // EXB rbd,addr[(rs)] (0x6C00-0x6CFF) : MAME Z6C_0000_dddd_addr / Z6C_ssN0_dddd_addr, byte RMW exchange, flags ...
                else if (din[15:8]==8'h6C && din[7:4]==4'h0) begin
                    dst<=din[3:0]; pc<=pc2; state<=S_DAB_EXB_FETCH;
                end
                else if (din[15:8]==8'h6C && din[7:4]!=4'h0) begin
                    dst<=din[3:0]; idxr<=din[7:4]; pc<=pc2; state<=S_DAB_EXBX_FETCH;
                end
                // EX rd,addr[(rs)] (0x6D00-0x6DFF) : MAME Z6D_0000_dddd_addr / Z6D_ssN0_dddd_addr, word exchange, flags ------. ...
                else if (din[15:8]==8'h6D && din[7:4]==4'h0) begin
                    dst<=din[3:0]; pc<=pc2; state<=S_DAB_EXW_FETCH;
                end
                else if (din[15:8]==8'h6D && din[7:4]!=4'h0) begin
                    dst<=din[3:0]; idxr<=din[7:4]; pc<=pc2; state<=S_DAB_EXWX_FETCH;
                end
                // EX rd,rs reg-reg (0xAD, full range) : MAME ZAD_ssss_dddd "ex rd,rs", flags ------. Real usage 3
                else if (din[15:8]==8'hAD) begin
                    rwb0_we=1'b1; rwb0_idx=din[3:0]; rwb0_val=R[din[7:4]];
                    rwb1_we=1'b1; rwb1_idx=din[7:4]; rwb1_val=R[din[3:0]];
                    pc<=pc2; retire<=1'b1;
                end
                // register-indirect @Rd simple family (0x0C/0x0D) ===== dst=NIB2(din[7:4]), sub-op selector=NIB3(din[3:0])
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
                // TESTB @rd (0x0C10-0x0CF0, NIB3=4) : MAME Z0C_ddN0_0100 "testb @rd", read-only, flags -ZSP-- (same formula as ...
                else if (din[15:8]==8'h0C && din[7:4]!=4'h0 && din[3:0]==4'h4) begin
                    dst<=din[7:4]; pc<=pc2; state<=S_TESTBI_RD;
                end
                // TSETB @rd (0x0C16-0x0CF6, NIB3=6) : MAME Z0C_ddN0_0110 "tsetb @rd", byte RMW (wordacc rule), flags --S---. S = ...
                else if (din[15:8]==8'h0C && din[7:4]!=4'h0 && din[3:0]==4'h6) begin
                    dst<=din[7:4]; pc<=pc2; state<=S_TSETBI_RD;
                end
                // CLRB @rd (0x0C18-0x0CF8, NIB3=8) : MAME Z0C_ddN0_1000 "clrb @rd", byte RMW (wordacc rule, unconditional 0), ...
                else if (din[15:8]==8'h0C && din[7:4]!=4'h0 && din[3:0]==4'h8) begin
                    dst<=din[7:4]; pc<=pc2; state<=S_CLRBI_RD;
                end
                // COM @rd (0x0D10-0x0DF0, NIB3=0) : MAME Z0D_ddN0_0000 "com @rd", word RMW, flags -ZS--- (same formula as the ...
                else if (din[15:8]==8'h0D && din[7:4]!=4'h0 && din[3:0]==4'h0) begin
                    dst<=din[7:4]; pc<=pc2; state<=S_COMI_RD;
                end
                // CP @rd,#imm16 (0x0D11-0x0DF1, NIB3=1) : MAME Z0D_ddN0_0001_imm16 "cp @rd,imm16", read-only compare, flags ...
                else if (din[15:8]==8'h0D && din[7:4]!=4'h0 && din[3:0]==4'h1) begin
                    dst<=din[7:4]; pc<=pc2; state<=S_CPRI_IMM;
                end
                // NEG @rd (0x0D12-0x0DF2, NIB3=2) : MAME Z0D_ddN0_0010 "neg @rd", word RMW, flags CZSV-- (same formula as the ...
                else if (din[15:8]==8'h0D && din[7:4]!=4'h0 && din[3:0]==4'h2) begin
                    dst<=din[7:4]; pc<=pc2; state<=S_NEGI_RD;
                end
                // TEST @rd (0x0D14-0x0DF4, NIB3=4) : MAME Z0D_ddN0_0100 "test @rd", read-only, flags -ZS--- (same formula as the ...
                else if (din[15:8]==8'h0D && din[7:4]!=4'h0 && din[3:0]==4'h4) begin
                    dst<=din[7:4]; pc<=pc2; state<=S_TESTI_RD;
                end
                // TSET @rd (0x0D16-0x0DF6, NIB3=6) : MAME Z0D_ddN0_0110 "tset @rd", word RMW, flags --S---. S = old bit15
                else if (din[15:8]==8'h0D && din[7:4]!=4'h0 && din[3:0]==4'h6) begin
                    dst<=din[7:4]; pc<=pc2; state<=S_TSETI_RD;
                end
                // CLR @rd (0x0D18-0x0DF8, NIB3=8) : MAME Z0D_ddN0_1000 "clr @rd", plain word write (no read needed), flags ...
                else if (din[15:8]==8'h0D && din[7:4]!=4'h0 && din[3:0]==4'h8) begin
                    dst<=din[7:4]; pc<=pc2; state<=S_CLRI_WR;
                end
                // ALU addr[,(rs)] direct/indexed (0x40-0x4B, task item 1) === ADDB/ADD/SUBB/SUB/ORB/OR/ANDB/AND/XORB/XOR/CPB/CP ...
                else if (din[15:8]>=8'h40 && din[15:8]<=8'h4B) begin
                    dst<=din[3:0]; pc<=pc2;
                    case (din[15:8])
                        8'h40,8'h41: aluop<=ADD; 8'h42,8'h43: aluop<=SUB;
                        8'h44,8'h45: aluop<=OR;  8'h46,8'h47: aluop<=AND;
                        8'h48,8'h49: aluop<=XOR; default:     aluop<=CP;  // 4A,4B
                    endcase
                    if (din[8]) begin  // odd byte1 -> word form
                        if (din[7:4]==4'h0) state<=S_ALUA_FETCH;
                        else begin idxr<=din[7:4]; state<=S_ALUAX_FETCH; end
                    end else begin  // even byte1 -> byte form
                        if (din[7:4]==4'h0) state<=S_ALUAB_FETCH;
                        else begin idxr<=din[7:4]; state<=S_ALUABX_FETCH; end
                    end
                end
                // CPL rrd,imm32 (0x1000-0x100F, task item 2) ================ MAME Z10_0000_dddd_imm32, compare-only long against ...
                else if (din[15:8]==8'h10 && din[7:4]==4'h0) begin
                    dst<=din[3:0]; pc<=pc2; state<=S_CPLI_HI;
                end
                // register-indirect INCB/INC/DECB/DEC @rd (0x28-0x2B) ======= EA=R[dst] directly, no address word to fetch
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
                // byte INC/DEC addr[,(rs)],#n (0x68/0x6A) =================== Byte siblings of the already-implemented word ...
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
                // missing indexed arms for LD rd,addr(rs) / LD addr(rs),rs == (0x61/0x6F, NIB2!=0)
                else if (din[15:8]==8'h61 && din[7:4]!=4'h0) begin
                    dst<=din[3:0]; daop<=DA_LDR; idxr<=din[7:4]; pc<=pc2; state<=S_LDAX_FETCH;
                end
                else if (din[15:8]==8'h6F && din[7:4]!=4'h0) begin
                    src<=din[3:0]; daop<=DA_STR; idxr<=din[7:4]; pc<=pc2; state<=S_LDSAX_FETCH;
                end
                // register-only closures (zero new states) =================== ---- COMB rbd (0x8Cd0) : MAME Z8C_dddd_0000, flags ...
                else if (din[15:8]==8'h8C && din[3:0]==4'h0) begin
                    dbyte = din[7] ? R[din[6:4]][7:0] : R[din[6:4]][15:8];
                    res8 = ~dbyte; p=(~^res8);
                    rwb0_we=1'b1; rwb0_idx={1'b0,din[6:4]}; rwb0_val={2{res8}}; rwb0_be=din[7]?2'b01:2'b10;
                    fcw<=(fcw & ~(MZ|MS|MV)) | ((res8==8'h00)?MZ:0)|(res8[7]?MS:0)|(p?MV:0);
                    pc<=pc2; retire<=1'b1;
                end
                // NEGB rbd (0x8Cd2) : MAME Z8C_dddd_0010, flags CZSV-- (same formula as the already-implemented word NEG rd, ...
                else if (din[15:8]==8'h8C && din[3:0]==4'h2) begin
                    dbyte = din[7] ? R[din[6:4]][7:0] : R[din[6:4]][15:8];
                    res8 = 8'h00 - dbyte; v=(res8==8'h80);
                    rwb0_we=1'b1; rwb0_idx={1'b0,din[6:4]}; rwb0_val={2{res8}}; rwb0_be=din[7]?2'b01:2'b10;
                    fcw<=(fcw & ~(MC|MZ|MS|MV)) | ((res8!=8'h00)?MC:0)|((res8==8'h00)?MZ:0)|(res8[7]?MS:0)|(v?MV:0);
                    pc<=pc2; retire<=1'b1;
                end
                // TSETB rbd (0x8Cd6) : MAME Z8C_dddd_0110, flags --S--- (S=old bit7, unconditional 0xFF
                else if (din[15:8]==8'h8C && din[3:0]==4'h6) begin
                    dbyte = din[7] ? R[din[6:4]][7:0] : R[din[6:4]][15:8];
                    fcw<=(fcw & ~MS) | (dbyte[7]?MS:0);
                    rwb0_we=1'b1; rwb0_idx={1'b0,din[6:4]}; rwb0_val=16'hFFFF; rwb0_be=din[7]?2'b01:2'b10;
                    pc<=pc2; retire<=1'b1;
                end
                // LDCTLB rbd,flags (0x8Cd1) : MAME Z8C_dddd_0001 "ldctlb rbd,flags"
                else if (din[15:8]==8'h8C && din[3:0]==4'h1) begin
                    rwb0_we=1'b1; rwb0_idx={1'b0,din[6:4]}; rwb0_val={2{(fcw[7:0] & 8'hFC)}}; rwb0_be=din[7]?2'b01:2'b10;
                    pc<=pc2; retire<=1'b1;
                end
                // LDCTLB flags,rbd (0x8Cd9) : MAME Z8C_dddd_1001 "ldctlb flags,rbd"
                else if (din[15:8]==8'h8C && din[3:0]==4'h9) begin
                    dbyte = din[7] ? R[din[6:4]][7:0] : R[din[6:4]][15:8];
                    fcw<=(fcw & ~16'h00FC) | {8'h00, (dbyte & 8'hFC)};
                    pc<=pc2; retire<=1'b1;
                end
                // NOP (0x8D07 EXACT) : MAME Z8D_0000_0111 "nop"
                else if (din==16'h8D07) begin
                    pc<=pc2; retire<=1'b1;
                end
                // TEST rd (0x8Dd4) : MAME Z8D_dddd_0100 "test rd", flags -ZS--- (same TESTW formula as the existing ...
                else if (din[15:8]==8'h8D && din[3:0]==4'h4) begin
                    fcw<=(fcw & ~(MZ|MS)) | ((R[din[7:4]]==16'h0000)?MZ:0)|(R[din[7:4]][15]?MS:0);
                    pc<=pc2; retire<=1'b1;
                end
                // NOTE: this register-DIRECT form was explicitly, deliberately skipped in Batch 4 citing "zero real ROM ...
                else if (din[15:8]==8'h8D && din[3:0]==4'h6) begin
                    fcw<=(fcw & ~MS) | (R[din[7:4]][15]?MS:0);
                    rwb0_we=1'b1; rwb0_idx=din[7:4]; rwb0_val=16'hFFFF;
                    pc<=pc2; retire<=1'b1;
                end
                // SETFLG/RESFLG/COMFLG imm4 (0x8D_imm4_0001/0011/0101, NIB0=1/3/5) : MAME Z8D_imm4_0001/0011/0101
                else if (din[15:8]==8'h8D && din[3:0]==4'h1) begin
                    fcw<=fcw | (din & 16'h00F0); pc<=pc2; retire<=1'b1;
                end
                else if (din[15:8]==8'h8D && din[3:0]==4'h3) begin
                    fcw<=fcw & ~(din & 16'h00F0); pc<=pc2; retire<=1'b1;
                end
                else if (din[15:8]==8'h8D && din[3:0]==4'h5) begin
                    fcw<=fcw ^ (din & 16'h00F0); pc<=pc2; retire<=1'b1;
                end
                // the handler body ignores NIB3 entirely, GET_DST uses NIB2) : MAME Z9C_dddd_1000 "testl rrd", flags -ZS--- ...
                else if (din[15:8]==8'h9C && (din[3:0]==4'h0 || din[3:0]==4'h8)) begin
                    fcw<=(fcw & ~(MZ|MS))
                       | (({R[{din[7:5],1'b0}],R[{din[7:5],1'b0}+4'd1]}==32'h00000000)?MZ:0)
                       | (R[{din[7:5],1'b0}][15]?MS:0);
                    pc<=pc2; retire<=1'b1;
                end
                // RESB/RES/SETB/SET/BITB/BIT rd,imm4 register-DIRECT forms (0xA2- 0xA7, full range each) : MAME ZA2-ZA7_dddd_imm4
                else if (din[15:8]==8'hA2) begin  // RESB rbd,imm4
                    dbyte = din[7] ? R[din[6:4]][7:0] : R[din[6:4]][15:8];
                    res8 = dbyte & ~(8'h01<<din[3:0]);
                    rwb0_we=1'b1; rwb0_idx={1'b0,din[6:4]}; rwb0_val={2{res8}}; rwb0_be=din[7]?2'b01:2'b10;
                    pc<=pc2; retire<=1'b1;
                end
                else if (din[15:8]==8'hA3) begin  // RES rd,imm4
                    rwb0_we=1'b1; rwb0_idx=din[7:4]; rwb0_val=R[din[7:4]] & ~(16'h0001<<din[3:0]);
                    pc<=pc2; retire<=1'b1;
                end
                else if (din[15:8]==8'hA4) begin  // SETB rbd,imm4
                    dbyte = din[7] ? R[din[6:4]][7:0] : R[din[6:4]][15:8];
                    res8 = dbyte | (8'h01<<din[3:0]);
                    rwb0_we=1'b1; rwb0_idx={1'b0,din[6:4]}; rwb0_val={2{res8}}; rwb0_be=din[7]?2'b01:2'b10;
                    pc<=pc2; retire<=1'b1;
                end
                else if (din[15:8]==8'hA5) begin  // SET rd,imm4
                    rwb0_we=1'b1; rwb0_idx=din[7:4]; rwb0_val=R[din[7:4]] | (16'h0001<<din[3:0]);
                    pc<=pc2; retire<=1'b1;
                end
                else if (din[15:8]==8'hA6) begin  // BITB rbd,imm4
                    dbyte = din[7] ? R[din[6:4]][7:0] : R[din[6:4]][15:8];
                    fcw<=(fcw & ~MZ) | (((dbyte & (8'h01<<din[3:0]))==8'h00) ? MZ : 16'h0000);
                    pc<=pc2; retire<=1'b1;
                end
                else if (din[15:8]==8'hA7) begin  // BIT rd,imm4
                    fcw<=(fcw & ~MZ) | (((R[din[7:4]] & (16'h0001<<din[3:0]))==16'h0000) ? MZ : 16'h0000);
                    pc<=pc2; retire<=1'b1;
                end
                // TCCB cc,rbd / TCC cc,rd (0xAE/0xAF, full range) : MAME ZAE/ZAF_ dddd_cccc "tccb/tcc cc,rbd/rd", flags
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
                // LDK rd,imm4 (0xBD, full range) : MAME ZBD_dddd_imm4 "ldk rd,imm4", flags
                else if (din[15:8]==8'hBD) begin
                    rwb0_we=1'b1; rwb0_idx=din[7:4]; rwb0_val={12'h000, din[3:0]};
                    pc<=pc2; retire<=1'b1;
                end
                // RLDB rba,rbb (0xBC, full range) : MAME ZBC_aaaa_bbbb "rldb rba,rbb"
                else if (din[15:8]==8'hBC) begin
                    dbyte     = din[7] ? R[din[6:4]][7:0] : R[din[6:4]][15:8];  // old a
                    operand_b = din[3] ? R[din[2:0]][7:0] : R[din[2:0]][15:8];  // old b (=tmp)
                    res8 = {operand_b[3:0], dbyte[7:4]};  // new a
                    rwb0_we=1'b1; rwb0_idx={1'b0,din[6:4]}; rwb0_val={2{res8}}; rwb0_be=din[7]?2'b01:2'b10;
                    rwb1_we=1'b1; rwb1_idx={1'b0,din[2:0]}; rwb1_val={2{operand_b}}; rwb1_be=din[3]?2'b01:2'b10;  // new b = old b
                    fcw<=(fcw & ~MZ) | ((operand_b==8'h00)?MZ:0);
                    pc<=pc2; retire<=1'b1;
                end
                // RRDB rba,rbb (0xBE, full range) : MAME ZBE_aaaa_bbbb "rrdb rba,rbb"
                else if (din[15:8]==8'hBE) begin
                    dbyte     = din[7] ? R[din[6:4]][7:0] : R[din[6:4]][15:8];  // old a (=tmp)
                    operand_b = din[3] ? R[din[2:0]][7:0] : R[din[2:0]][15:8];  // old b
                    res8 = {dbyte[3:0], operand_b[3:0]};  // new a
                    rwb0_we=1'b1; rwb0_idx={1'b0,din[6:4]}; rwb0_val={2{res8}}; rwb0_be=din[7]?2'b01:2'b10;
                    res8 = {operand_b[7:4], dbyte[7:4]};  // new b
                    rwb1_we=1'b1; rwb1_idx={1'b0,din[2:0]}; rwb1_val={2{res8}}; rwb1_be=din[3]?2'b01:2'b10;
                    fcw<=(fcw & ~MZ) | ((res8==8'h00)?MZ:0);
                    pc<=pc2; retire<=1'b1;
                end
                // EXTSL rqd (0xB1d7, NIB0=7) : MAME ZB1_dddd_0111 "extsl rqd", flags
                else if (din[15:8]==8'hB1 && din[3:0]==4'h7) begin
                    qbase = {din[7:6],2'b00};
                    rwb0_we=1'b1; rwb0_idx=qbase;      rwb0_val={16{R[qbase+4'd2][15]}};
                    rwb1_we=1'b1; rwb1_idx=qbase+4'd1; rwb1_val={16{R[qbase+4'd2][15]}};
                    pc<=pc2; retire<=1'b1;
                end
                // LDB rd,imm8 short form (0xC000-0xCFFF, full range) : MAME ZC_dddd_imm8 "ldb rbd,imm8"
                else if (din[15:12]==4'hC) begin
                    rwb0_we=1'b1; rwb0_idx={1'b0,din[10:8]}; rwb0_val={2{din[7:0]}}; rwb0_be=din[11]?2'b01:2'b10;
                    pc<=pc2; retire<=1'b1;
                end
                // catch-all trap
                else begin illegal<=1'b1; state<=S_ILLEGAL; end
              end
              end  // closes the cyc_count>=target_cycles dispatch-ready branch
            end

            // fetch 2nd word as immediate operand
            S_IMM:   begin operand<=din; pc<=pc+16'd2; state<=S_ALU; end
            // read word operand from @rs
            S_MEMRD: begin operand<=din; state<=S_ALU; end

            // shared word ALU
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

            // direct addressing
            S_DA_FETCH: begin
                ea<=din; pc<=pc+16'd2;
                case (daop)
                    DA_LDR, DA_TST: state<=S_DA_RD;
                    DA_STI, DA_CPI: state<=S_DA_IMM;
                    default:        state<=S_DA_WR;  // DA_STR, DA_CLR
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

            // indexed sibling of S_DA_FETCH/S_DA_IMM
            S_DAX_FETCH: begin
                ea<=din+R[idxr]; pc<=pc+16'd2;
                case (daop)
                    DA_TST:        state<=S_DA_RD;
                    // fix: DA_CLR was falling into `default`->S_DAX_IMM, which would have misread the FOLLOWING instruction word as a ...
                    DA_CLR:        state<=S_DA_WR;
                    default:       state<=S_DAX_IMM;  // DA_STI, DA_CPI (both need imm16 next)
                endcase
            end
            S_DAX_IMM: begin
                operand<=din; pc<=pc+16'd2;
                state<=(daop==DA_STI) ? S_DA_WR : S_DA_RD;  // STI writes; CPI reads mem next
            end

            // direct-address(+index) word static-op family, 0x4D COM/NEG/ TSET (dadop 0/1/2)
            S_DAD_FETCH:  begin ea<=din;         pc<=pc+16'd2; state<=S_DAD_RD; end
            S_DAD_FETCHX: begin ea<=din+R[idxr]; pc<=pc+16'd2; state<=S_DAD_RD; end
            S_DAD_RD: begin  // addr=ea (word read)
                case (dadop)
                    2'd0: begin  // COM: flags -ZS--- (no V, matches word COM/S_COMI_RD)
                        res16 = ~din;
                        fcw<=(fcw & ~(MZ|MS)) | ((res16==16'h0000)?MZ:0)|(res16[15]?MS:0);
                        operand<=res16;
                    end
                    2'd1: begin  // NEG: flags CZSV
                        res16 = 16'h0000 - din;
                        v=(res16==16'h8000);
                        fcw<=(fcw & ~(MC|MZ|MS|MV))
                           | ((res16!=16'h0000)?MC:0)|((res16==16'h0000)?MZ:0)|(res16[15]?MS:0)|(v?MV:0);
                        operand<=res16;
                    end
                    default: begin  // 2'd2 TSET: flags --S---, S=old bit15, new=0xFFFF unconditional
                        fcw<=(fcw & ~MS) | (din[15]?MS:0);
                        operand<=16'hFFFF;
                    end
                endcase
                state<=S_DAD_WR;
            end
            S_DAD_WR: begin retire<=1'b1; state<=S_FETCH0; end  // addr=ea,dout=operand,we=1

            // direct-address(+index) byte static-op family, 0x4C COMB/CPB/ NEGB/TESTB/LDB/TSETB/CLRB (dacop 0/5/1/2/6/3/4)
            S_DAC_FETCH: begin
                ea<=din; pc<=pc+16'd2;
                case (dacop)
                    3'd5, 3'd6: state<=S_DAC_IMM;  // CPB, LDB need imm8 next
                    3'd2:       state<=S_DAC_RDRO;  // TESTB: read-only
                    default:    state<=S_DAC_RD;  // COMB, NEGB, TSETB, CLRB: RMW
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
            S_DAC_IMM: begin  // imm8 = low byte of ext word (same convention as S_IMMB)
                operand[7:0]<=din[7:0]; pc<=pc+16'd2;
                state<=(dacop==3'd6) ? S_DAC_RD : S_DAC_RDRO;  // LDB writes; CPB read-only
            end
            S_DAC_RD: begin  // addr=ea&~1 (RMW path)
                dbyte = ea[0] ? din[7:0] : din[15:8];
                case (dacop)
                    3'd0: begin  // COMB: flags -ZSP
                        res8=~dbyte; p=(~^res8);
                        fcw<=(fcw & ~(MZ|MS|MV)) | ((res8==8'h00)?MZ:0)|(res8[7]?MS:0)|(p?MV:0);
                        dacres<=res8;
                    end
                    3'd1: begin  // NEGB: flags CZSV
                        res8=8'h00-dbyte; v=(res8==8'h80);
                        fcw<=(fcw & ~(MC|MZ|MS|MV)) | ((res8!=8'h00)?MC:0)|((res8==8'h00)?MZ:0)|(res8[7]?MS:0)|(v?MV:0);
                        dacres<=res8;
                    end
                    3'd3: begin  // TSETB: flags --S---, S=old bit7, new=0xFF unconditional
                        fcw<=(fcw & ~MS) | (dbyte[7]?MS:0);
                        dacres<=8'hFF;
                    end
                    3'd6: begin  // LDB addr,imm8: flags ------, write staged imm8
                        dacres<=operand[7:0];
                    end
                    default: begin  // 3'd4 CLRB: flags ------, unconditional 0
                        dacres<=8'h00;
                    end
                endcase
                operand<=din;
                state<=S_DAC_WR;
            end
            S_DAC_RDRO: begin  // addr=ea&~1 (read-only path: TESTB/CPB)
                dbyte = ea[0] ? din[7:0] : din[15:8];
                if (dacop==3'd5) begin  // CPB addr,imm8: flags CZSV
                    incb_sum = {1'b0,dbyte} - {1'b0,operand[7:0]};
                    v=(~operand[7]&dbyte[7]&~incb_sum[7])|(operand[7]&~dbyte[7]&incb_sum[7]);
                    fcw<=(fcw & ~(MC|MZ|MS|MV))
                       | (incb_sum[8]?MC:0)|((incb_sum[7:0]==0)?MZ:0)|(incb_sum[7]?MS:0)|(v?MV:0);
                end else begin  // TESTB: flags -ZSP
                    p=(~^dbyte);
                    fcw<=(fcw & ~(MZ|MS|MV)) | ((dbyte==8'h00)?MZ:0)|(dbyte[7]?MS:0)|(p?MV:0);
                end
                retire<=1'b1; state<=S_FETCH0;
            end
            S_DAC_WR: begin retire<=1'b1; state<=S_FETCH0; end  // addr=ea&~1,dout=merged(dacres@ea[0]),we=1

            // SLL(+)/SRL(-) rd,#imm16 (flags CZS)
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

            // right branch sign-extends instead of zero-filling
            S_SHIFTA: begin
                a16=R[dst]; scnt = din[15] ? (16'h0000 - din) : din; cnt=scnt[4:0];
                if (din[15]) begin  // right, arithmetic (sign-extend)
                    res16 = $signed(a16) >>> cnt;
                    cbit  = (cnt!=0) ? (($signed(a16) >>> (cnt-1)) & 16'h1) : 1'b0;
                    v     = 1'b0;
                end else begin  // left
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
                if (din[15]) begin  // right, arithmetic (sign-extend)
                    res32 = $signed(a32) >>> cnt;
                    cbit  = (cnt!=0) ? (($signed(a32) >>> (cnt-1)) & 32'h1) : 1'b0;
                    v     = 1'b0;
                end else begin  // left
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

            // LDA prd,addr[(rs)]
            S_LDA76_FETCH: begin operand<=din; pc<=pc+16'd2; state<=S_LDA76_GO; end
            S_LDA76_GO: begin
                rwb0_we=1'b1; rwb0_idx=dst; rwb0_val=operand + (lda76_has_src ? R[src] : 16'h0000);
                retire<=1'b1; state<=S_FETCH0;
            end

            // 0x30-0x37 PC-relative(dsp16) direct forms
            S_Z30_FETCH: begin ea<=pc+16'd2+din; pc<=pc+16'd2; state<=S_LDBDA_RD; end
            S_Z31_FETCH: begin ea<=pc+16'd2+din; pc<=pc+16'd2; state<=S_DA_RD; end
            // Z32 direct: LDRB dsp16,rbs
            S_Z32_FETCH: begin ea<=pc+16'd2+din; pc<=pc+16'd2; state<=S_LDBSTA_RD; end
            S_Z33_FETCH: begin ea<=pc+16'd2+din; pc<=pc+16'd2; state<=S_DA_WR; end
            // Z34 direct: LDAR prd,dsp16
            S_Z34_FETCH: begin
                rwb0_we=1'b1; rwb0_idx=dst; rwb0_val=pc+16'd2+din;
                pc<=pc+16'd2; retire<=1'b1; state<=S_FETCH0;
            end
            // Z35 direct: LDRL rrd,dsp16
            S_Z35_FETCH: begin ea<=pc+16'd2+din; l32wb<=1'b0; pc<=pc+16'd2; state<=S_L32_RD_HI; end
            // Z37 direct: LDRL dsp16,rrs
            S_Z37_FETCH: begin ea<=pc+16'd2+din; l32wb<=1'b0; pc<=pc+16'd2; state<=S_L32_WR_HI; end

            // LD rd,rs(rx) (0x71)
            S_LD71_FETCH: begin ea<=R[src]+R[din[11:8]]; pc<=pc+16'd2; state<=S_LD71_RD; end
            S_LD71_RD: begin rwb0_we=1'b1; rwb0_idx=dst; rwb0_val=din; retire<=1'b1; state<=S_FETCH0; end

            // 0x70/72/73/74/75/77
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

            // JP cc,addr[(rd)] (src holds cc)
            S_JP: begin
                pc<=cc_true(src,fcw[FC],fcw[FZ],fcw[FS],fcw[FV])
                    ? (din + (jpx ? R[idxr] : 16'h0000)) : (pc+16'd2);
                retire<=1'b1; state<=S_FETCH0;
            end

            // internal-trap accept sequence (EPU/TRAP/SYSCALL)
            S_TRAP_PC:  begin rwb0_we=1'b1; rwb0_idx=4'd15; rwb0_val=R[15]-16'd2; state<=S_TRAP_FCW;   end  // addr=SP-2,dout=pc,we=1
            S_TRAP_FCW: begin rwb0_we=1'b1; rwb0_idx=4'd15; rwb0_val=R[15]-16'd2; state<=S_TRAP_OP;    end  // addr=SP-4,dout=fcw(old),we=1
            S_TRAP_OP:  begin rwb0_we=1'b1; rwb0_idx=4'd15; rwb0_val=R[15]-16'd2; state<=S_TRAP_RDFCW; end  // addr=SP-6,dout=ir,we=1
            S_TRAP_RDFCW: begin fcw<=din; state<=S_TRAP_RDPC; end  // addr=psap+trap_vec, fcw<=mem[...]
            S_TRAP_RDPC:  begin pc<=din; retire<=1'b1; state<=S_FETCH0; end  // addr=psap+trap_vec+2, pc<=mem[...]

            // real port I/O (INB/IN/OUTB/OUT)
            S_INB_GO: begin  // addr=R[src]&~1, iorq=1, wordacc=0
                rwb0_we=1'b1; rwb0_idx={1'b0,dst[2:0]};
                rwb0_val={2{R[src][0] ? din[7:0] : din[15:8]}}; rwb0_be=dst[3]?2'b01:2'b10;
                retire<=1'b1; state<=S_FETCH0;
            end
            S_IN_GO: begin  // addr=R[src], iorq=1, wordacc=1
                rwb0_we=1'b1; rwb0_idx=dst; rwb0_val=din;
                retire<=1'b1; state<=S_FETCH0;
            end
            S_OUTB_GO: begin retire<=1'b1; state<=S_FETCH0; end  // addr=R[dst]&~1,iorq=1,we=1,wordacc=0,dout=merged
            S_OUT_GO:  begin retire<=1'b1; state<=S_FETCH0; end  // addr=R[dst],iorq=1,we=1,wordacc=1,dout=R[src]

            // LDPS real functional sequence.
            S_LDPS_FETCH:  begin ea<=din;         pc<=pc+16'd2; state<=S_LDPS_RDFCW; end  // addr word via pc
            S_LDPS_FETCHX: begin ea<=din+R[idxr]; pc<=pc+16'd2; state<=S_LDPS_RDFCW; end
            S_LDPS_RDFCW: begin fcw<=din; state<=S_LDPS_RDPC; end  // addr=ea, fcw<=mem[ea]
            S_LDPS_RDPC:  begin pc<=din; retire<=1'b1; state<=S_FETCH0; end  // addr=ea+2, pc<=mem[ea+2]

            // 0x3A/0x3B single I/O (SIN/SOUT family).
            S_IOS_FETCH: begin ea<=din; pc<=pc+16'd2; state<= io_dir ? S_IOS_WR : S_IOS_RD; end
            S_IOS_RD: begin  // addr=io_wide?ea:(ea&~1), iorq=1
                if (io_wide) begin rwb0_we=1'b1; rwb0_idx=dst; rwb0_val=din; end
                else begin
                    rwb0_we=1'b1; rwb0_idx={1'b0,dst[2:0]};
                    rwb0_val={2{ea[0] ? din[7:0] : din[15:8]}}; rwb0_be=dst[3]?2'b01:2'b10;
                end
                retire<=1'b1; state<=S_FETCH0;
            end
            S_IOS_WR: begin retire<=1'b1; state<=S_FETCH0; end  // addr=io_wide?ea:(ea&~1),iorq=1,we=1,dout=merged,wordacc=io_wide

            // 0x3A/0x3B self-repeating block I/O.
            S_IOB_FETCH2: begin  // addr word2 via pc
                cntreg<=din[11:8]; dst<=din[7:4]; iocc<=din[3:0];
                pc<=pc+16'd2; state<=S_IOB_RD;
            end
            S_IOB_RD: begin  // addr=iob_rdword?R[src]:(R[src]&~1); iorq=(IN dir); mreq=(OUT dir)
                operand<=din;
                // everything else (word forms, or byte+OUT writing to a PORT) doesn't.
                state<= (!io_wide && (io_sub[1]==1'b0)) ? S_IOB_WR_RD : S_IOB_WR;
            end
            S_IOB_WR_RD: begin operand2<=din; state<=S_IOB_WR; end  // addr=R[dst]&~1: old mem word for RMW
            S_IOB_WR: begin  // addr=io_wide?R[dst]:(R[dst]&~1); iorq=(OUT dir); mreq=(IN dir); we=1; dout=iob_wr_dout
                rwb0_we=1'b1; rwb0_idx=cntreg; rwb0_val=R[cntreg]-16'd1;
                iob_step = (io_wide ? 16'sd2 : 16'sd1) * (io_sub[3] ? -16'sd1 : 16'sd1);
                iob_both = io_wide || io_sub[3] || io_sub[0];
                if (iob_both) begin
                    rwb1_we=1'b1; rwb1_idx=dst; rwb1_val=R[dst]+iob_step;
                    rwb2_we=1'b1; rwb2_idx=src; rwb2_val=R[src]+iob_step;
                end else if (io_sub[1]) begin  // OUT, single-register case: bump src only
                    rwb1_we=1'b1; rwb1_idx=src; rwb1_val=R[src]+iob_step;
                end else begin  // IN, single-register case: bump dst only
                    rwb1_we=1'b1; rwb1_idx=dst; rwb1_val=R[dst]+iob_step;
                end
                // MAME: if(--RW(cnt)){CLR_V; if(cc==0)m_pc-=4;} else SET_V
                if ((R[cntreg]-16'd1) != 16'h0000) begin
                    fcw<=(fcw & ~MV);
                    if (iocc==4'h0) pc<=pc_orig;  // repeat: rewind to re-fetch/re-decode
                end else begin
                    fcw<=(fcw | MV);
                end
                retire<=1'b1; state<=S_FETCH0;
            end

            // ADDB rd,@rs (byte, flags CZSVH, DA=0)
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

            // NVI accept sequence: push PC, push old FCW, push vec tag, then load new FCW/PC from the PSA NVI vector ...
            S_NVI_PC:  begin rwb0_we=1'b1; rwb0_idx=4'd15; rwb0_val=R[15]-16'd2; state<=S_NVI_FCW;   end  // addr/dout comb: SP-2 <= pc
            S_NVI_FCW: begin rwb0_we=1'b1; rwb0_idx=4'd15; rwb0_val=R[15]-16'd2; state<=S_NVI_VEC;   end  // SP-4 <= old fcw
            S_NVI_VEC: begin rwb0_we=1'b1; rwb0_idx=4'd15; rwb0_val=R[15]-16'd2; state<=S_NVI_RDFCW; end  // SP-6 <= 16'h00FF
            S_NVI_RDFCW: begin fcw<=din; state<=S_NVI_RDPC; end  // fcw <= mem[psap+0x18]
            S_NVI_RDPC:  begin
                pc<=din; nvi_pending<=1'b0; state<=S_FETCH0;  // pc <= mem[psap+0x1A]
            end

            // IRET: pop vec(discard), pop FCW, pop PC
            S_IRET_VEC: begin rwb0_we=1'b1; rwb0_idx=4'd15; rwb0_val=R[15]+16'd2; state<=S_IRET_FCW; end  // discard din (tag)
            S_IRET_FCW: begin fcw<=din; rwb0_we=1'b1; rwb0_idx=4'd15; rwb0_val=R[15]+16'd2; state<=S_IRET_PC; end
            S_IRET_PC:  begin pc<=din; rwb0_we=1'b1; rwb0_idx=4'd15; rwb0_val=R[15]+16'd2; retire<=1'b1; state<=S_FETCH0; end

            // stack + control flow ======================================== ---- CALL: fetch target addr (direct form only), ...
            S_CALL_FETCH: begin ea<=din; pc<=pc+16'd2; state<=S_CALL_PUSH; end  // addr word via pc (default mux)
            // indexed sibling of S_CALL_FETCH (0x5F10-0x5FF0)
            S_CALLX_FETCH: begin ea<=din+R[idxr]; pc<=pc+16'd2; state<=S_CALL_PUSH; end
            S_CALL_PUSH:  begin rwb0_we=1'b1; rwb0_idx=4'd15; rwb0_val=R[15]-16'd2; pc<=ea; retire<=1'b1; state<=S_FETCH0; end  // addr=SP-2,dout=pc,we=1

            // RET cc (taken): pop PC, SP+=2
            S_RET_POP: begin pc<=din; rwb0_we=1'b1; rwb0_idx=4'd15; rwb0_val=R[15]+16'd2; retire<=1'b1; state<=S_FETCH0; end  // addr=R[15]

            // PUSH (word): value staged in `operand`, commit via generic push
            S_PUSHI_FETCH: begin operand<=din; pc<=pc+16'd2; state<=S_PUSH_W; end  // imm16 via pc
            S_PUSHA_FETCH: begin ea<=din; pc<=pc+16'd2; state<=S_PUSHA_RD; end  // addr word via pc
            // indexed sibling of S_PUSHA_FETCH (0x53, NIB3!=0)
            S_PUSHAX_FETCH: begin ea<=din+R[idxr]; pc<=pc+16'd2; state<=S_PUSHA_RD; end
            S_PUSHA_RD:    begin operand<=din; state<=S_PUSH_W; end  // addr=ea: read source value
            S_PUSH_W:      begin rwb0_we=1'b1; rwb0_idx=dst; rwb0_val=R[dst]-16'd2; retire<=1'b1; state<=S_FETCH0; end  // addr=R[dst]-2,dout=operand,we=1

            // POP (word): register-dest direct; addr-dest via fetch/pop/store chain
            S_POP_R:      begin rwb0_we=1'b1; rwb0_idx=dst; rwb0_val=din; rwb1_we=1'b1; rwb1_idx=src; rwb1_val=R[src]+16'd2; retire<=1'b1; state<=S_FETCH0; end  // addr=R[src]
            S_POPA_FETCH: begin ea<=din; pc<=pc+16'd2; state<=S_POPA_POP; end  // addr word via pc
            // indexed sibling of S_POPA_FETCH (0x57, NIB3!=0)
            S_POPAX_FETCH: begin ea<=din+R[idxr]; pc<=pc+16'd2; state<=S_POPA_POP; end
            S_POPA_POP:   begin operand<=din; rwb0_we=1'b1; rwb0_idx=src; rwb0_val=R[src]+16'd2; state<=S_POPA_WR; end  // addr=R[src]
            S_POPA_WR:    begin retire<=1'b1; state<=S_FETCH0; end  // addr=ea,dout=operand,we=1

            // shared 32-bit (long) pump: hi word @ea, lo word @ea+2
            S_L32_RD_HI: begin operand<=din; state<=S_L32_RD_LO; end  // addr=ea: hi word
            S_L32_RD_LO: begin  // addr=ea+2: lo word
                rwb0_we=1'b1; rwb0_idx={dst[3:1],1'b0};      rwb0_val=operand;
                rwb1_we=1'b1; rwb1_idx={dst[3:1],1'b0}+4'd1; rwb1_val=din;
                if (l32wb) begin rwb2_we=1'b1; rwb2_idx=src; rwb2_val=ea + 16'd4; end
                retire<=1'b1; state<=S_FETCH0;
            end
            S_L32_WR_HI: begin state<=S_L32_WR_LO; end  // addr=ea,dout=R[{src pair}]: hi word
            S_L32_WR_LO: begin  // addr=ea+2,dout=R[{src pair}+1]: lo word
                if (l32wb) begin rwb0_we=1'b1; rwb0_idx=dst; rwb0_val=ea; end
                retire<=1'b1; state<=S_FETCH0;
            end

            // PUSHL @Rd,addr[,(rs)] (0x51)
            S_PLDA_FETCH:  begin ea<=din;         pc<=pc+16'd2; state<=S_PLDA_RD_HI; end
            S_PLDA_FETCHX: begin ea<=din+R[idxr]; pc<=pc+16'd2; state<=S_PLDA_RD_HI; end
            S_PLDA_RD_HI: begin operand<=din;  state<=S_PLDA_RD_LO; end  // addr=ea: hi word
            S_PLDA_RD_LO: begin operand2<=din; state<=S_PLDA_WR_HI; end  // addr=ea+2: lo word
            S_PLDA_WR_HI: begin state<=S_PLDA_WR_LO; end  // addr=R[dst]-4,dout=operand,we=1
            S_PLDA_WR_LO: begin  // addr=R[dst]-4+2,dout=operand2,we=1
                rwb0_we=1'b1; rwb0_idx=dst; rwb0_val=R[dst]-16'd4;
                retire<=1'b1; state<=S_FETCH0;
            end

            // POPL addr[,(rd)],@Rs (0x55)
            S_POLDA_FETCH:  begin ea<=din;         pc<=pc+16'd2; state<=S_POLDA_RD_HI; end
            S_POLDA_FETCHX: begin ea<=din+R[idxr]; pc<=pc+16'd2; state<=S_POLDA_RD_HI; end
            S_POLDA_RD_HI: begin operand<=din; state<=S_POLDA_RD_LO; end  // addr=R[src]: hi word
            S_POLDA_RD_LO: begin  // addr=R[src]+2: lo word
                operand2<=din;
                rwb0_we=1'b1; rwb0_idx=src; rwb0_val=R[src]+16'd4;  // postincrement source ptr
                state<=S_POLDA_WR_HI;
            end
            S_POLDA_WR_HI: begin state<=S_POLDA_WR_LO; end  // addr=ea,dout=operand,we=1
            S_POLDA_WR_LO: begin retire<=1'b1; state<=S_FETCH0; end  // addr=ea+2,dout=operand2,we=1

            // LDL RRd,#imm32: hi word then lo word, both via pc (not ea)
            S_LDL_IMM_HI: begin operand<=din; pc<=pc+16'd2; state<=S_LDL_IMM_LO; end
            S_LDL_IMM_LO: begin
                rwb0_we=1'b1; rwb0_idx={dst[3:1],1'b0};      rwb0_val=operand;
                rwb1_we=1'b1; rwb1_idx={dst[3:1],1'b0}+4'd1; rwb1_val=din;
                pc<=pc+16'd2; retire<=1'b1; state<=S_FETCH0;
            end

            // LDL RRd,addr / LDL addr,RRs: fetch the direct address, then feed the generic L32 pump (l32wb=0, plain ...
            S_LDLA_FETCH:  begin ea<=din; l32wb<=1'b0; pc<=pc+16'd2; state<=S_L32_RD_HI; end
            // (post-verify): indexed sibling of the direct form above
            S_LDLAX_FETCH: begin ea<=din+R[src]; l32wb<=1'b0; pc<=pc+16'd2; state<=S_L32_RD_HI; end
            S_LDLSA_FETCH: begin ea<=din; l32wb<=1'b0; pc<=pc+16'd2; state<=S_L32_WR_HI; end
            // indexed sibling of S_LDLSA_FETCH above
            S_LDLSAX_FETCH: begin ea<=din+R[idxr]; l32wb<=1'b0; pc<=pc+16'd2; state<=S_L32_WR_HI; end

            // LDM rd,@rs,n: fetch word2 (dst start reg @ bits[11:8], cnt-1 @ bits[3:0]), base pointer ea<=R[src] (src holds ...
            S_LDM_L_FETCH2: begin
                dst<=din[11:8]; mcnt<=din[3:0]; ea<=R[src]; pc<=pc+16'd2; state<=S_LDM_L_RD;
            end
            S_LDM_L_RD: begin  // addr=ea
                rwb0_we=1'b1; rwb0_idx=dst; rwb0_val=din;
                if (mcnt==4'h0) begin retire<=1'b1; state<=S_FETCH0; end
                else begin mcnt<=mcnt-4'd1; dst<=dst+4'd1; ea<=ea+16'd2; end
            end

            // LDM @rd,rs,n: fetch word2 (src start reg @ bits[11:8], cnt-1 @ bits[3:0]), base pointer ea<=R[dst] (dst holds ...
            S_LDM_S_FETCH2: begin
                src<=din[11:8]; mcnt<=din[3:0]; ea<=R[dst]; pc<=pc+16'd2; state<=S_LDM_S_WR;
            end
            S_LDM_S_WR: begin  // addr=ea,dout=R[src],we=1
                if (mcnt==4'h0) begin retire<=1'b1; state<=S_FETCH0; end
                else begin mcnt<=mcnt-4'd1; src<=src+4'd1; ea<=ea+16'd2; end
            end

            // (post-verify): LDM addr,rs,n direct-address store
            S_LDM_DA_FETCH2: begin
                src<=din[11:8]; mcnt<=din[3:0]; pc<=pc+16'd2;
                state<= ldmx ? S_LDM_DA_FETCH3X : S_LDM_DA_FETCH3;
            end
            S_LDM_DA_FETCH3: begin ea<=din; pc<=pc+16'd2; state<=S_LDM_S_WR; end
            // indexed sibling of S_LDM_DA_FETCH3 -- ea=addr+R[idxr].
            S_LDM_DA_FETCH3X: begin ea<=din+R[idxr]; pc<=pc+16'd2; state<=S_LDM_S_WR; end

            // LDM rd,addr,n direct-address LOAD
            S_LDM_DA_LFETCH2: begin
                dst<=din[11:8]; mcnt<=din[3:0]; pc<=pc+16'd2;
                state<= ldmx ? S_LDM_DA_LFETCH3X : S_LDM_DA_LFETCH3;
            end
            S_LDM_DA_LFETCH3: begin ea<=din; pc<=pc+16'd2; state<=S_LDM_L_RD; end
            // indexed sibling of S_LDM_DA_LFETCH3 -- ea=addr+R[idxr].
            S_LDM_DA_LFETCH3X: begin ea<=din+R[idxr]; pc<=pc+16'd2; state<=S_LDM_L_RD; end

            // indirect-indirect PUSHL/PUSH/POP ===================== ---- PUSHL @Rd,@Rs (0x11): read long @R[src] ...
            S_PLII_RD_HI: begin operand<=din;  state<=S_PLII_WR_HI; end  // addr=R[src]: hi word
            S_PLII_WR_HI: begin                state<=S_PLII_RD_LO; end  // addr=ea,dout=operand,we=1
            S_PLII_RD_LO: begin operand2<=din; state<=S_PLII_WR_LO; end  // addr=R[src]+2: lo word
            S_PLII_WR_LO: begin rwb0_we=1'b1; rwb0_idx=dst; rwb0_val=ea; retire<=1'b1; state<=S_FETCH0; end  // addr=ea+2,dout=operand2,we=1

            // PUSH @Rd,@Rs (0x13): read word @R[src], hand off to existing S_PUSH_W
            S_PUSHII_RD: begin operand<=din; state<=S_PUSH_W; end  // addr=R[src]

            // POP @Rd,@Rs (0x17): pop word @R[src] (+2), write LIVE @R[dst]
            S_POPII_RD: begin rwb0_we=1'b1; rwb0_idx=src; rwb0_val=R[src]+16'd2; operand<=din; state<=S_POPII_WR; end  // addr=R[src]
            S_POPII_WR: begin retire<=1'b1; state<=S_FETCH0; end  // addr=R[dst] (live),dout=operand,we=1

            // shared byte ALU/LDB pipeline (mirrors S_IMM/S_MEMRD/S_ALU)
            S_IMMB:   begin operand[7:0]<=din[7:0]; pc<=pc+16'd2; state<=S_ALUB; end  // imm8 = LOW byte of ext word
            S_MEMRDB: begin operand[7:0]<= R[src][0] ? din[7:0] : din[15:8]; state<=S_ALUB; end  // addr=R[src]&~1
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
                    default: begin res8=dbyte^operand[7:0]; z=(res8==0); s=res8[7]; p=(~^res8);  // XOR
                         fmask=MZ|MS|MV; fval=(z?MZ:0)|(s?MS:0)|(p?MV:0); end
                endcase
                if (wb) begin rwb0_we=1'b1; rwb0_idx={1'b0,dst[2:0]}; rwb0_val={2{res8}}; rwb0_be=dst[3]?2'b01:2'b10; end
                fcw<=(fcw & ~fmask) | fval;
                retire<=1'b1; state<=S_FETCH0;
            end

            // LDB @Rd,rbs store (0x2E): word-aligned RMW so the untouched byte lane survives (wordacc unconnected downstream, ...
            S_LDBST_RD: begin operand<=din; state<=S_LDBST_WR; end  // addr=R[dst]&~1
            S_LDBST_WR: begin retire<=1'b1; state<=S_FETCH0; end  // addr=R[dst]&~1,dout=merged,we=1

            // CPL rrd,@rs (0x10): read long @R[src] (unmodified), compare vs RL(dst), no writeback
            S_CPL_RD_HI: begin operand<=din; state<=S_CPL_RD_LO; end  // addr=R[src]: hi word
            S_CPL_RD_LO: begin  // addr=R[src]+2: lo word
                dif33 = {1'b0, R[{dst[3:1],1'b0}], R[{dst[3:1],1'b0}+4'd1]} - {1'b0, operand, din};
                fcw<=(fcw & ~(MC|MZ|MS|MV)) | (dif33[32]?MC:0)|((dif33[31:0]==0)?MZ:0)|(dif33[31]?MS:0)
                   | (((~operand[15] & R[{dst[3:1],1'b0}][15] & ~dif33[31]) |
                       (operand[15] & ~R[{dst[3:1],1'b0}][15] &  dif33[31])) ? MV:0);
                retire<=1'b1; state<=S_FETCH0;
            end
            // CPL rrd,rrs (0x90): same compare, both operands direct register pairs
            S_CPL_RR: begin
                dif33 = {1'b0, R[{dst[3:1],1'b0}], R[{dst[3:1],1'b0}+4'd1]}
                      - {1'b0, R[{src[3:1],1'b0}], R[{src[3:1],1'b0}+4'd1]};
                fcw<=(fcw & ~(MC|MZ|MS|MV)) | (dif33[32]?MC:0)|((dif33[31:0]==0)?MZ:0)|(dif33[31]?MS:0)
                   | (((~R[{src[3:1],1'b0}][15] & R[{dst[3:1],1'b0}][15] & ~dif33[31]) |
                       (R[{src[3:1],1'b0}][15] & ~R[{dst[3:1],1'b0}][15] &  dif33[31])) ? MV:0);
                retire<=1'b1; state<=S_FETCH0;
            end

            // BITB/BIT @Rd,#imm4 (read-only, flags -Z----; Z=1 means tested bit is 0)
            S_BITB_RD: begin  // addr=R[dst]&~1
                dbyte = R[dst][0] ? din[7:0] : din[15:8];
                fcw<=(fcw & ~MZ) | (((dbyte & bmask[7:0])==0) ? MZ : 16'h0000);
                retire<=1'b1; state<=S_FETCH0;
            end
            S_BIT_RD: begin  // addr=R[dst]
                fcw<=(fcw & ~MZ) | (((din & bmask)==0) ? MZ : 16'h0000);
                retire<=1'b1; state<=S_FETCH0;
            end

            // RESB/RES/SETB/SET/BITB/BIT rd,rs (0x22-0x27, dynamic bit index)
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

            // bitop_set: 0=AND~bit 1=OR bit
            S_BITW_RD: begin operand<=din; state<=S_BITW_WR; end  // addr=R[dst]
            S_BITW_WR: begin retire<=1'b1; state<=S_FETCH0; end  // addr=R[dst],dout=merged,we=1

            // EX rd,@rs (word exchange; flags ------, untouched)
            S_EX_RD: begin operand<=din; state<=S_EX_WR; end  // addr=R[src]: old mem value
            S_EX_WR: begin rwb0_we=1'b1; rwb0_idx=dst; rwb0_val=operand; retire<=1'b1; state<=S_FETCH0; end  // addr=R[src],dout=R[dst](old),we=1

            // INC/DEC addr,#n direct: fetch addr, RMW word (wordacc-safe by construction)
            S_INCDA_FETCH: begin ea<=din; pc<=pc+16'd2; state<=S_INCDA_RD; end  // addr word via pc
            S_INCDA_RD: begin  // addr=ea: read old value
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
            S_INCDA_WR: begin retire<=1'b1; state<=S_FETCH0; end  // addr=ea,dout=operand,we=1

            // MULT rrd,{#imm16|@rs|rs}: dest16 = LOW word of RL(dst) (MAME truncates RL(dst) to uint16_t for MULTW's `dest` ...
            S_MULT_IMM: begin operand<=din; pc<=pc+16'd2; state<=S_MULT_GO; end
            S_MULT_RD:  begin operand<=din; state<=S_MULT_GO; end  // addr=R[src]&~1
            S_MULT_GO: begin
                mul_p32 = $signed(R[{dst[3:1],1'b0}+4'd1]) * $signed(operand);
                c = (mul_p32 < -32'sd32767) || (mul_p32 >= 32'sd32767);
                z = (mul_p32 == 32'sd0); s = mul_p32[31];
                rwb0_we=1'b1; rwb0_idx={dst[3:1],1'b0};      rwb0_val=mul_p32[31:16];
                rwb1_we=1'b1; rwb1_idx={dst[3:1],1'b0}+4'd1; rwb1_val=mul_p32[15:0];
                fcw<=(fcw & ~(MC|MZ|MS|MV)) | (c?MC:0)|(z?MZ:0)|(s?MS:0);
                retire<=1'b1; state<=S_FETCH0;
            end

            // DIV rrd,{#imm16|@rs|rs}: dest32 = FULL RL(dst) pair (dividend)
            S_DIV_IMM: begin operand<=din; pc<=pc+16'd2; state<=S_DIV_GO; end
            S_DIV_RD:  begin operand<=din; state<=S_DIV_GO; end  // addr=R[src]&~1
            S_DIV_GO: begin
                if (operand==16'h0000) begin
                    c=1'b0; z=1'b1; s=1'b0; v=1'b1;  // dest UNCHANGED -- no register write
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

            // shared restoring-division iteration (DIV and DIVL both land here) ---- Classic shift-subtract: {rem,quo} shifts ...
            S_DIV_BUSY: begin
                dv_shf = {dv_rem, dv_quo[63]};  // 65-bit (rem<<1 | next dividend bit)
                dv_sub = dv_shf - {1'b0, dv_dvsr};  // bit 64 = borrow => dvsr was bigger
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

            // MULTL rqd,{@rs|rrs}: dest32 = LOW half of the quad = RL(dst|2), i.e
            S_MULTL_RD_HI: begin operand<=din;  state<=S_MULTL_RD_LO; end  // addr=R[src]: hi word
            S_MULTL_RD_LO: begin operand2<=din; state<=S_MULTL_GO; end  // addr=R[src]+2: lo word
            // MULTL rqd,#imm32
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

            // DIVL rqd,{@rs|rrs}: dest64 = FULL quad R[qbase..+3] (read live, no staging needed since it's always already in ...
            S_DIVL_RD_HI: begin operand<=din;  state<=S_DIVL_RD_LO; end  // addr=R[src]: hi word
            S_DIVL_RD_LO: begin operand2<=din; state<=S_DIVL_GO; end  // addr=R[src]+2: lo word
            // DIVL rqd,#imm32 -- imm32 fetch, lands in the EXISTING S_DIVL_GO.
            S_DIVLI_HI: begin operand<=din;  pc<=pc+16'd2; state<=S_DIVLI_LO; end
            S_DIVLI_LO: begin operand2<=din; pc<=pc+16'd2; state<=S_DIVL_GO; end
            S_DIVL_GO: begin
                qbase = {dst[3:2],2'b00};
                if (operand==16'h0000 && operand2==16'h0000) begin
                    c=1'b0; z=1'b1; s=1'b0; v=1'b1;  // dest UNCHANGED
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

            // ADDL/SUBL rrd,{#imm32|@rs|rrs}: 32-bit version of the existing word S_ALU add/sub (identical carry/overflow ...
            S_LALU_IMM_HI: begin operand<=din;  pc<=pc+16'd2; state<=S_LALU_IMM_LO; end
            S_LALU_IMM_LO: begin operand2<=din; pc<=pc+16'd2; state<=S_LALU_GO; end
            S_LALU_RD_HI:  begin operand<=din;  state<=S_LALU_RD_LO; end  // addr=R[src]: hi word
            S_LALU_RD_LO:  begin operand2<=din; state<=S_LALU_GO; end  // addr=R[src]+2: lo word
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

            // SUBL/ADDL/MULTL/DIVL rrd|rqd,addr[,(rs)] (0x52/56/58/5A)
            S_DWL_FETCH:  begin ea<=din;         pc<=pc+16'd2; state<=S_DWL_RD_HI; end
            S_DWL_FETCHX: begin ea<=din+R[idxr]; pc<=pc+16'd2; state<=S_DWL_RD_HI; end
            S_DWL_RD_HI: begin operand<=din; state<=S_DWL_RD_LO; end  // addr=ea: hi word
            S_DWL_RD_LO: begin  // addr=ea+2: lo word
                operand2<=din;
                case (dwop)
                    2'd1: state<=S_MULTL_GO;
                    2'd2: state<=S_DIVL_GO;
                    default: state<=S_LALU_GO;  // 2'd0: ADDL/SUBL (aluop already set at decode)
                endcase
            end

            // MULT/DIV rrd,addr[,(rs)] (0x59/5B)
            S_DWS_FETCH:  begin ea<=din;         pc<=pc+16'd2; state<=S_DWS_RD; end
            S_DWS_FETCHX: begin ea<=din+R[idxr]; pc<=pc+16'd2; state<=S_DWS_RD; end
            S_DWS_RD: begin  // addr=ea
                operand<=din;
                state<=(dwop==2'd1) ? S_DIV_GO : S_MULT_GO;
            end

            // TESTL addr[,(rd)] (0x5C08/0x5CN8)
            S_TL_FETCH:  begin ea<=din;         pc<=pc+16'd2; state<=S_TL_RD_HI; end
            S_TL_FETCHX: begin ea<=din+R[idxr]; pc<=pc+16'd2; state<=S_TL_RD_HI; end
            S_TL_RD_HI: begin operand<=din; state<=S_TL_RD_LO; end  // addr=ea: hi word
            S_TL_RD_LO: begin  // addr=ea+2: lo word
                fcw<=(fcw & ~(MZ|MS)) | (({operand,din}==32'h00000000)?MZ:0) | (operand[15]?MS:0);
                retire<=1'b1; state<=S_FETCH0;
            end

            // LDB rbd,addr direct-load: read-only byte load, no RMW hazard
            S_LDBDA_FETCH: begin ea<=din; pc<=pc+16'd2; state<=S_LDBDA_RD; end  // addr word via pc
            S_LDBDA_RD: begin  // addr=ea&~1
                rwb0_we=1'b1; rwb0_idx={1'b0,dst[2:0]}; rwb0_val={2{ea[0] ? din[7:0] : din[15:8]}}; rwb0_be=dst[3]?2'b01:2'b10;
                retire<=1'b1; state<=S_FETCH0;
            end

            // LDB addr,rbs direct-store: word-aligned RMW (the wordacc rule, see header)
            S_LDBSTA_FETCH: begin ea<=din; pc<=pc+16'd2; state<=S_LDBSTA_RD; end  // addr word via pc
            S_LDBSTA_RD: begin operand<=din; state<=S_LDBSTA_WR; end  // addr=ea&~1
            S_LDBSTA_WR: begin retire<=1'b1; state<=S_FETCH0; end  // addr=ea&~1,dout=merged,we=1

            // SLLB/SRLB rbd,#imm8: byte version of the existing word S_SHIFT, imm8 = LOW byte of the fetched word (MAME ...
            S_SHIFTB: begin
                dbyte = dst[3] ? R[dst[2:0]][7:0] : R[dst[2:0]][15:8];
                scnt = din[7] ? (16'h0000 - {8'hFF,din[7:0]}) : {8'h00,din[7:0]};
                cnt = scnt[4:0];
                if (din[7]) begin  // negative imm8 -> SRLB
                    res8 = dbyte >> cnt;
                    cbit = (cnt!=5'd0) ? ((dbyte >> (cnt-5'd1)) & 8'h01) : 1'b0;
                end else begin  // positive/zero -> SLLB
                    res8 = dbyte << cnt;
                    cbit = (cnt!=5'd0) ? (((dbyte << (cnt-5'd1)) & 8'h80)!=8'h00) : 1'b0;
                end
                z=(res8==8'h00); s=res8[7];
                rwb0_we=1'b1; rwb0_idx={1'b0,dst[2:0]}; rwb0_val={2{res8}}; rwb0_be=dst[3]?2'b01:2'b10;
                fcw<=(fcw & ~(MC|MZ|MS)) | (cbit?MC:0)|(z?MZ:0)|(s?MS:0);
                pc<=pc+16'd2; retire<=1'b1; state<=S_FETCH0;
            end

            // SLAB/SRAB rbd,#imm8 (0xB2d9)
            S_SHIFTAB: begin
                dbyte = dst[3] ? R[dst[2:0]][7:0] : R[dst[2:0]][15:8];
                scnt = din[7] ? (16'h0000 - {8'hFF,din[7:0]}) : {8'h00,din[7:0]};
                cnt = scnt[4:0];
                if (din[7]) begin  // negative imm8 -> SRAB (arithmetic, sign-extend)
                    res8 = $signed(dbyte) >>> cnt;
                    cbit = (cnt!=5'd0) ? (($signed(dbyte) >>> (cnt-5'd1)) & 8'h01) : 1'b0;
                    v = 1'b0;
                end else begin  // positive/zero -> SLAB (left)
                    res8 = dbyte << cnt;
                    cbit = (cnt!=5'd0) ? (((dbyte << (cnt-5'd1)) & 8'h80)!=8'h00) : 1'b0;
                    v = (res8[7]!=dbyte[7]);
                end
                z=(res8==8'h00); s=res8[7];
                rwb0_we=1'b1; rwb0_idx={1'b0,dst[2:0]}; rwb0_val={2{res8}}; rwb0_be=dst[3]?2'b01:2'b10;
                fcw<=(fcw & ~(MC|MZ|MS|MV)) | (cbit?MC:0)|(z?MZ:0)|(s?MS:0)|(v?MV:0);
                pc<=pc+16'd2; retire<=1'b1; state<=S_FETCH0;
            end

            // shared no-op tail for every size=2 (opcode + exactly one operand word) instruction in the ...
            S_SWALLOW1: begin pc<=pc+16'd2; retire<=1'b1; state<=S_FETCH0; end

            // HALT (0x7A00)
            S_HALT: ;

            // SDLB/SDAB/SDLW/SDAW/SDLL/SDAL
            S_SDLB_GO: begin
                dbyte = dst[3] ? R[dst[2:0]][7:0] : R[dst[2:0]][15:8];
                dcnt = R[din[11:8]][7] ? (8'h00 - R[din[11:8]][7:0]) : R[din[11:8]][7:0];
                if (R[din[11:8]][7]) begin  // right, logical (zero-fill)
                    res8 = dbyte >> dcnt;
                    cbit = (dcnt!=8'h00) ? ((dbyte >> (dcnt-8'd1)) & 8'h01) : 1'b0;
                end else begin  // left
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
                if (R[din[11:8]][7]) begin  // right, arithmetic (sign-extend)
                    res8 = $signed(dbyte) >>> dcnt;
                    cbit = (dcnt!=8'h00) ? (($signed(dbyte) >>> (dcnt-8'd1)) & 8'h01) : 1'b0;
                end else begin  // left (identical to SDLB's left branch)
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
            // Long forms: dst here is a plain register NUMBER (0-15, per Z8002cpu.h's RL() bit0-truncation convention, same ...
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

            // CPL rrd,addr direct: same compare-only shape as S_CPL_RD_HI/LO (Batch 2) but addressed via `ea` (a fetched ...
            S_CPLA_FETCH: begin ea<=din; pc<=pc+16'd2; state<=S_CPLA_RD_HI; end  // addr word via pc
            S_CPLA_RD_HI: begin operand<=din; state<=S_CPLA_RD_LO; end  // addr=ea: hi word
            S_CPLA_RD_LO: begin  // addr=ea+2: lo word
                dif33 = {1'b0, R[{dst[3:1],1'b0}], R[{dst[3:1],1'b0}+4'd1]} - {1'b0, operand, din};
                fcw<=(fcw & ~(MC|MZ|MS|MV)) | (dif33[32]?MC:0)|((dif33[31:0]==32'h00000000)?MZ:0)|(dif33[31]?MS:0)
                   | (((~operand[15] & R[{dst[3:1],1'b0}][15] & ~dif33[31]) |
                       (operand[15] & ~R[{dst[3:1],1'b0}][15] &  dif33[31])) ? MV:0);
                retire<=1'b1; state<=S_FETCH0;
            end

            // Proof the NIB2==0 direct path is unchanged: these are new states reached ONLY from new (NIB2!=0) decode arms
            S_LDBDAX_FETCH:  begin ea<=din+R[idxr]; pc<=pc+16'd2; state<=S_LDBDA_RD;   end  // > existing S_LDBDA_RD
            S_LDBSTAX_FETCH: begin ea<=din+R[idxr]; pc<=pc+16'd2; state<=S_LDBSTA_RD;  end  // > existing S_LDBSTA_RD
            S_CPLAX_FETCH:   begin ea<=din+R[idxr]; pc<=pc+16'd2; state<=S_CPLA_RD_HI; end  // > existing S_CPLA_RD_HI
            S_INCDAX_FETCH:  begin ea<=din+R[idxr]; pc<=pc+16'd2; state<=S_INCDA_RD;   end  // > existing S_INCDA_RD

            // Lane = R[dst][0].
            S_RESETB_RD: begin operand<=din; state<=S_RESETB_WR; end  // addr=R[dst]&~1
            S_RESETB_WR: begin retire<=1'b1; state<=S_FETCH0; end  // addr=R[dst]&~1,dout=merged,we=1

            // EXB rbd,@rs (byte RMW exchange; addr=R[src]&~1, lane=R[src][0])
            S_EXB_RD: begin operand<=din; state<=S_EXB_WR; end  // addr=R[src]&~1
            S_EXB_WR: begin  // addr=R[src]&~1,dout=merged,we=1
                // lane = R[src][0] (address LSB), NOT src[0] (the pointer register NUMBER)
                rwb0_we=1'b1; rwb0_idx={1'b0,dst[2:0]}; rwb0_val={2{R[src][0] ? operand[7:0] : operand[15:8]}}; rwb0_be=dst[3]?2'b01:2'b10;
                retire<=1'b1; state<=S_FETCH0;
            end

            // direct-address(+index) RESB/RES/SETB/SET/BITB/BIT/EXB/EX ===== Each FETCH computes ea<=din (direct) or ...
            S_DAB_RESB_FETCH:  begin ea<=din;         pc<=pc+16'd2; state<=S_DAB_RESB_RD; end
            S_DAB_RESBX_FETCH: begin ea<=din+R[idxr]; pc<=pc+16'd2; state<=S_DAB_RESB_RD; end
            S_DAB_RESB_RD: begin operand<=din; state<=S_DAB_RESB_WR; end  // addr=ea&~1
            S_DAB_RESB_WR: begin retire<=1'b1; state<=S_FETCH0; end  // addr=ea&~1,dout=merged,we=1

            // RES/SET addr[,(rd)],#imm4 (word RMW; bitop_set: 0=AND~bit 1=OR bit).
            S_DAB_RESW_FETCH:  begin ea<=din;         pc<=pc+16'd2; state<=S_DAB_RESW_RD; end
            S_DAB_RESWX_FETCH: begin ea<=din+R[idxr]; pc<=pc+16'd2; state<=S_DAB_RESW_RD; end
            S_DAB_RESW_RD: begin operand<=din; state<=S_DAB_RESW_WR; end  // addr=ea
            S_DAB_RESW_WR: begin retire<=1'b1; state<=S_FETCH0; end  // addr=ea,dout=merged,we=1

            // Lane = ea[0].
            S_DAB_BITB_FETCH:  begin ea<=din;         pc<=pc+16'd2; state<=S_DAB_BITB_RD; end
            S_DAB_BITBX_FETCH: begin ea<=din+R[idxr]; pc<=pc+16'd2; state<=S_DAB_BITB_RD; end
            S_DAB_BITB_RD: begin  // addr=ea&~1
                dbyte = ea[0] ? din[7:0] : din[15:8];
                fcw<=(fcw & ~MZ) | (((dbyte & bmask[7:0])==0) ? MZ : 16'h0000);
                retire<=1'b1; state<=S_FETCH0;
            end

            // BIT addr[,(rd)],#imm4 (read-only word, flags -Z----).
            S_DAB_BITW_FETCH:  begin ea<=din;         pc<=pc+16'd2; state<=S_DAB_BITW_RD; end
            S_DAB_BITWX_FETCH: begin ea<=din+R[idxr]; pc<=pc+16'd2; state<=S_DAB_BITW_RD; end
            S_DAB_BITW_RD: begin  // addr=ea
                fcw<=(fcw & ~MZ) | (((din & bmask)==0) ? MZ : 16'h0000);
                retire<=1'b1; state<=S_FETCH0;
            end

            // `dst` holds the value register's byte-reg-code
            S_DAB_EXB_FETCH:  begin ea<=din;         pc<=pc+16'd2; state<=S_DAB_EXB_RD; end
            S_DAB_EXBX_FETCH: begin ea<=din+R[idxr]; pc<=pc+16'd2; state<=S_DAB_EXB_RD; end
            S_DAB_EXB_RD: begin operand<=din; state<=S_DAB_EXB_WR; end  // addr=ea&~1
            S_DAB_EXB_WR: begin  // addr=ea&~1,dout=merged,we=1
                rwb0_we=1'b1; rwb0_idx={1'b0,dst[2:0]}; rwb0_val={2{ea[0] ? operand[7:0] : operand[15:8]}}; rwb0_be=dst[3]?2'b01:2'b10;
                retire<=1'b1; state<=S_FETCH0;
            end

            // EX rd,addr[(rs)] (word exchange; flags ------, untouched).
            S_DAB_EXW_FETCH:  begin ea<=din;         pc<=pc+16'd2; state<=S_DAB_EXW_RD; end
            S_DAB_EXWX_FETCH: begin ea<=din+R[idxr]; pc<=pc+16'd2; state<=S_DAB_EXW_RD; end
            S_DAB_EXW_RD: begin operand<=din; state<=S_DAB_EXW_WR; end  // addr=ea
            S_DAB_EXW_WR: begin rwb0_we=1'b1; rwb0_idx=dst; rwb0_val=operand; retire<=1'b1; state<=S_FETCH0; end  // addr=ea,dout=R[dst](old),we=1

            // register-indirect @Rd simple family (0x0C/0x0D) ======= ---- TESTB @rd (read-only byte, flags -ZSP
            S_TESTBI_RD: begin  // addr=R[dst]&16'hFFFE
                dbyte = R[dst][0] ? din[7:0] : din[15:8];
                p = (~^dbyte);
                fcw<=(fcw & ~(MZ|MS|MV)) | ((dbyte==8'h00)?MZ:0)|(dbyte[7]?MS:0)|(p?MV:0);
                retire<=1'b1; state<=S_FETCH0;
            end

            // TSETB @rd (byte RMW; S = old bit7, new value unconditionally 0xFF).
            S_TSETBI_RD: begin  // addr=R[dst]&16'hFFFE
                dbyte = R[dst][0] ? din[7:0] : din[15:8];
                fcw<=(fcw & ~MS) | (dbyte[7]?MS:0);
                operand<=din; state<=S_TSETBI_WR;
            end
            S_TSETBI_WR: begin retire<=1'b1; state<=S_FETCH0; end  // addr=R[dst]&16'hFFFE,dout=merged(0xFF lane),we=1

            // CLRB @rd (byte RMW, unconditional 0x00, flags ------).
            S_CLRBI_RD: begin operand<=din; state<=S_CLRBI_WR; end  // addr=R[dst]&16'hFFFE
            S_CLRBI_WR: begin retire<=1'b1; state<=S_FETCH0; end  // addr=R[dst]&16'hFFFE,dout=merged(0x00 lane),we=1

            // COM @rd (word RMW; same formula as register-direct COM rd).
            S_COMI_RD: begin
                res16 = ~din;
                fcw<=(fcw & ~(MZ|MS)) | ((res16==16'h0000)?MZ:0)|(res16[15]?MS:0);
                operand<=res16; state<=S_COMI_WR;
            end
            S_COMI_WR: begin retire<=1'b1; state<=S_FETCH0; end  // addr=R[dst],dout=operand,we=1

            // CP @rd,#imm16 (read-only compare; same formula as the word CP aluop).
            S_CPRI_IMM: begin operand<=din; pc<=pc+16'd2; state<=S_CPRI_RD; end  // imm16 via pc
            S_CPRI_RD: begin  // addr=R[dst]
                dif17 = {1'b0,din} - {1'b0,operand};
                v = (~operand[15]&din[15]&~dif17[15])|(operand[15]&~din[15]&dif17[15]);
                fcw<=(fcw & ~(MC|MZ|MS|MV))
                   | (dif17[16]?MC:0)|((dif17[15:0]==16'h0000)?MZ:0)|(dif17[15]?MS:0)|(v?MV:0);
                retire<=1'b1; state<=S_FETCH0;
            end

            // NEG @rd (word RMW; same formula as register-direct NEG rd).
            S_NEGI_RD: begin
                res16 = 16'h0000 - din;
                v = (res16==16'h8000);
                fcw<=(fcw & ~(MC|MZ|MS|MV))
                   | ((res16!=16'h0000)?MC:0)|((res16==16'h0000)?MZ:0)|(res16[15]?MS:0)|(v?MV:0);
                operand<=res16; state<=S_NEGI_WR;
            end
            S_NEGI_WR: begin retire<=1'b1; state<=S_FETCH0; end  // addr=R[dst],dout=operand,we=1

            // TEST @rd (read-only word, flags -ZS----; same formula as DA_TST).
            S_TESTI_RD: begin  // addr=R[dst]
                fcw<=(fcw & ~(MZ|MS)) | ((din==16'h0000)?MZ:0)|(din[15]?MS:0);
                retire<=1'b1; state<=S_FETCH0;
            end

            // TSET @rd (word RMW; S = old bit15, new value unconditionally 0xFFFF).
            S_TSETI_RD: begin
                fcw<=(fcw & ~MS) | (din[15]?MS:0);
                state<=S_TSETI_WR;
            end
            S_TSETI_WR: begin retire<=1'b1; state<=S_FETCH0; end  // addr=R[dst],dout=16'hFFFF,we=1

            // CLR @rd (plain word write, no read needed, flags ------).
            S_CLRI_WR: begin retire<=1'b1; state<=S_FETCH0; end  // addr=R[dst],dout=16'h0000,we=1

            // ALU addr[,(rs)] direct/indexed (0x40-0x4B) =================== ---- word form: FETCH computes ea (direct or ...
            S_ALUA_FETCH:  begin ea<=din;         pc<=pc+16'd2; state<=S_ALUA_RD; end
            S_ALUAX_FETCH: begin ea<=din+R[idxr]; pc<=pc+16'd2; state<=S_ALUA_RD; end
            S_ALUA_RD: begin operand<=din; state<=S_ALU; end  // addr=ea

            // byte form: same shape, byte lane select via ea[0] (the fetched/ indexed address' LSB), joins the EXISTING ...
            S_ALUAB_FETCH:  begin ea<=din;         pc<=pc+16'd2; state<=S_ALUAB_RD; end
            S_ALUABX_FETCH: begin ea<=din+R[idxr]; pc<=pc+16'd2; state<=S_ALUAB_RD; end
            S_ALUAB_RD: begin operand[7:0]<= ea[0] ? din[7:0] : din[15:8]; state<=S_ALUB; end  // addr=ea&~1

            // CPL rrd,imm32 (0x1000-0x100F) ================================ Two words via `pc` (default mux, not `ea`), ...
            S_CPLI_HI: begin operand<=din; pc<=pc+16'd2; state<=S_CPLI_LO; end
            S_CPLI_LO: begin
                dif33 = {1'b0, R[{dst[3:1],1'b0}], R[{dst[3:1],1'b0}+4'd1]} - {1'b0, operand, din};
                fcw<=(fcw & ~(MC|MZ|MS|MV)) | (dif33[32]?MC:0)|((dif33[31:0]==32'h00000000)?MZ:0)|(dif33[31]?MS:0)
                   | (((~operand[15] & R[{dst[3:1],1'b0}][15] & ~dif33[31]) |
                       (operand[15] & ~R[{dst[3:1],1'b0}][15] &  dif33[31])) ? MV:0);
                pc<=pc+16'd2; retire<=1'b1; state<=S_FETCH0;
            end

            // byte INC/DEC addr[,(rs)],#n (0x68/0x6A)
            S_INCDAB_FETCH:  begin ea<=din;         pc<=pc+16'd2; state<=S_INCDAB_RD; end
            S_INCDABX_FETCH: begin ea<=din+R[idxr]; pc<=pc+16'd2; state<=S_INCDAB_RD; end
            S_INCDAB_RD: begin  // addr=ea&16'hFFFE: read old word, merge new byte @ea[0]
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

            // missing indexed arms for LD rd,addr(rs) / LD addr(rs),rs ===== Join the EXISTING, unmodified S_DA_RD/S_DA_WR ...
            S_LDAX_FETCH:  begin ea<=din+R[idxr]; pc<=pc+16'd2; state<=S_DA_RD; end
            S_LDSAX_FETCH: begin ea<=din+R[idxr]; pc<=pc+16'd2; state<=S_DA_WR; end

            S_INCBI_RD: begin  // addr=R[dst]&16'hFFFE: byte RMW, lane=R[dst][0]
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

            S_INCWI_RD: begin  // addr=R[dst]&16'hFFFE: word RMW, mirrors S_INCDA_RD one
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

            // SHARED REGISTER-FILE WRITEBACK BUS ========================== . Previously each of the ~111 R[] write sites ...
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
