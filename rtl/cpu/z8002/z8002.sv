// ============================================================================
//  z8002.sv  —  Zilog Z8002 (non-segmented Z8000) CPU core
//  Greenfield core for Arcade-PolePosition_MiSTer.  SystemVerilog, Verilator-clean.
//
//  References: MAME z8000ops.hxx / z8000tbl.hxx / z8000cpu.h (behavioral oracle).
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
    localparam integer FC=7, FZ=6, FS=5, FV=4, FH=2;
    // FCW interrupt-enable masks (MAME z8000cpu.h): F_NVIE=bit11 F_VIE=bit12 F_S_N=bit14
    localparam [15:0] F_NVIE=16'h0800, F_VIE=16'h1000, F_S_N=16'h4000;
    // ALU ops
    localparam [2:0] LD=0, ADD=1, SUB=2, AND=3, OR=4, XOR=5, CP=6;

    reg [15:0] R [0:15];
    reg [15:0] pc, fcw, ir, operand, ea;
    reg [15:0] psap;           // PSA pointer (control reg, LDCTL psapoff) - reset 0
    reg        nvi_pending;    // level-latched from nvi_n, cleared on NVI accept
    reg [3:0]  dst, src;
    reg [2:0]  aluop, daop;
    reg        retire, illegal;

    // direct/indirect memory access op (for the EA states)
    localparam [2:0] DA_LDR=0, DA_STR=1, DA_STI=2, DA_CLR=3, DA_TST=4;

    localparam [4:0] S_RST_FCW=0, S_RST_PC=1, S_FETCH0=2, S_IMM=3, S_MEMRD=4,
                     S_ALU=5, S_MEMWR=6, S_SHIFT=7, S_JP=8, S_ADDB_RD=9, S_ILLEGAL=10,
                     S_DA_FETCH=11, S_DA_IMM=12, S_DA_RD=13, S_DA_WR=14,
                     // NVI accept: push PC/FCW/vec (SP predecrement store x3),
                     // then read new FCW/PC from the PSA NVI vector (PSAP+0x18/0x1A)
                     S_NVI_PC=15, S_NVI_FCW=16, S_NVI_VEC=17, S_NVI_RDFCW=18, S_NVI_RDPC=19,
                     // IRET: pop vec(discard)/FCW/PC (SP postincrement load x3)
                     S_IRET_VEC=20, S_IRET_FCW=21, S_IRET_PC=22;
    reg [4:0] state;

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
                                        pc;
    assign mreq    = (state!=S_ILLEGAL);
    assign iorq    = 1'b0;
    assign we      = (state==S_MEMWR) || (state==S_DA_WR) ||
                      (state==S_NVI_PC) || (state==S_NVI_FCW) || (state==S_NVI_VEC);
    assign wordacc = (state!=S_ADDB_RD);
    assign dout    = (state==S_MEMWR) ? R[src] :
                     (state==S_DA_WR) ? (daop==DA_STR ? R[src] :
                                         daop==DA_STI ? operand : 16'h0000) :
                     (state==S_NVI_PC ) ? pc :
                     (state==S_NVI_FCW) ? fcw :
                     (state==S_NVI_VEC) ? 16'h00FF :
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
    reg [4:0]  cnt;
    reg [3:0]  incn;
    reg        z,s,v,c,h,wb, cbit;

    integer i;
    always @(posedge clk) begin
        if (!reset_n) begin
            pc<=0; fcw<=0; ir<=0; dst<=0; src<=0; aluop<=0; operand<=0;
            ea<=0; daop<=0; retire<=0; illegal<=0; state<=S_RST_FCW;
            psap<=16'h0000; nvi_pending<=1'b0;
            for (i=0;i<16;i=i+1) R[i]<=16'h0000;
        end else if (ce) begin
            retire <= 1'b0;
            pc2 = pc + 16'd2;
            // level-triggered NVI latch (MAME execute_input_edge_triggered==false for NVI):
            // set while the line is held low; cleared exactly on accept (S_NVI_RDPC) unless
            // still held low that same cycle, in which case it correctly re-latches.
            if (!nvi_n) nvi_pending <= 1'b1;
            case (state)
            S_RST_FCW: begin fcw<=din; state<=S_RST_PC; end
            S_RST_PC:  begin pc <=din; state<=S_FETCH0; end

            S_FETCH0: begin
              // ---- NVI accept (instruction-boundary check, ahead of decode) ----
              // MAME z8002_device::Interrupt(): (m_irq_req&Z8000_NVI)&&(m_fcw&F_NVIE)
              if (nvi_pending && ((fcw & F_NVIE)!=16'h0000)) begin
                  state <= S_NVI_PC;
              end else begin
                ir <= din;
                // ---- CLR rd (0x8Dd8, no flags) ----
                if (din[15:8]==8'h8D && din[3:0]==4'h8) begin
                    R[din[7:4]]<=16'h0000; pc<=pc2; retire<=1'b1;
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
                // ---- LD @rd,rs store (0x2F) : ptr=NIB2, data=NIB3 ----
                else if (din[15:8]==8'h2F) begin
                    dst<=din[7:4]; src<=din[3:0]; pc<=pc2; state<=S_MEMWR;
                end
                // ---- SLL/SRL rd,#imm (0xB3, NIB3=1) ----
                else if (din[15:8]==8'hB3 && din[3:0]==4'h1) begin
                    dst<=din[7:4]; pc<=pc2; state<=S_SHIFT;
                end
                // ---- JP cc,addr (0x5E) : cc=NIB3 ----
                else if (din[15:8]==8'h5E) begin
                    src<=din[3:0]; pc<=pc2; state<=S_JP;
                end
                // ---- LD rd,addr direct (0x61, NIB2=0) ----
                else if (din[15:8]==8'h61 && din[7:4]==4'h0) begin
                    dst<=din[3:0]; daop<=DA_LDR; pc<=pc2; state<=S_DA_FETCH;
                end
                // ---- LD addr,rs direct (0x6F, NIB2=0) ----
                else if (din[15:8]==8'h6F && din[7:4]==4'h0) begin
                    src<=din[3:0]; daop<=DA_STR; pc<=pc2; state<=S_DA_FETCH;
                end
                // ---- LD @rd,#imm16 (0x0D, NIB3=5): EA=R[dst] ----
                else if (din[15:8]==8'h0D && din[3:0]==4'h5) begin
                    ea<=R[din[7:4]]; daop<=DA_STI; pc<=pc2; state<=S_DA_IMM;
                end
                // ---- direct group (0x4D, NIB2=0): 5=LD#imm 8=CLR 4=TEST ----
                else if (din[15:8]==8'h4D && din[7:4]==4'h0) begin
                    pc<=pc2;
                    case (din[3:0])
                        4'h5: begin daop<=DA_STI; state<=S_DA_FETCH; end
                        4'h8: begin daop<=DA_CLR; state<=S_DA_FETCH; end
                        4'h4: begin daop<=DA_TST; state<=S_DA_FETCH; end
                        default: begin illegal<=1'b1; state<=S_ILLEGAL; end
                    endcase
                end
                // ---- DEC rd,#n (0xAB, word, ZSV) ----
                else if (din[15:8]==8'hAB) begin
                    incn=din[3:0]+4'd1; a16=R[din[7:4]]; res16=a16-{12'd0,incn};
                    v=a16[15] & ~res16[15];
                    R[din[7:4]]<=res16;
                    fcw<=(fcw & ~(MZ|MS|MV)) | ((res16==0)?MZ:0)|(res16[15]?MS:0)|(v?MV:0);
                    pc<=pc2; retire<=1'b1;
                end
                // ---- DECB rbd,#n (0xAA, byte, ZSV) ----
                else if (din[15:8]==8'hAA) begin
                    incn=din[3:0]+4'd1;
                    dbyte = din[7] ? R[din[6:4]][7:0] : R[din[6:4]][15:8];
                    add8 = {1'b0,dbyte} - {5'd0,incn};
                    v = dbyte[7] & ~add8[7];
                    if (din[7]) R[din[6:4]][7:0]<=add8[7:0];
                    else        R[din[6:4]][15:8]<=add8[7:0];
                    fcw<=(fcw & ~(MZ|MS|MV)) | ((add8[7:0]==0)?MZ:0)|(add8[7]?MS:0)|(v?MV:0);
                    pc<=pc2; retire<=1'b1;
                end
                // ---- INC rd,#n (0xA9, word, ZSV) ----
                else if (din[15:8]==8'hA9) begin
                    incn=din[3:0]+4'd1; incw_sum={1'b0,R[din[7:4]]}+{13'd0,incn};
                    v=(~R[din[7:4]][15]) & incw_sum[15];
                    R[din[7:4]]<=incw_sum[15:0];
                    fcw<=(fcw & ~(MZ|MS|MV)) | ((incw_sum[15:0]==0)?MZ:0)
                        | (incw_sum[15]?MS:0) | (v?MV:0);
                    pc<=pc2; retire<=1'b1;
                end
                // ---- INCB rbd,#n (0xA8, byte, ZSV) ----
                else if (din[15:8]==8'hA8) begin
                    incn=din[3:0]+4'd1;
                    dbyte = din[7] ? R[din[6:4]][7:0] : R[din[6:4]][15:8];
                    incb_sum={1'b0,dbyte}+{5'd0,incn};
                    v=(~dbyte[7]) & incb_sum[7];
                    if (din[7]) R[din[6:4]][7:0]<=incb_sum[7:0];
                    else        R[din[6:4]][15:8]<=incb_sum[7:0];
                    fcw<=(fcw & ~(MZ|MS|MV)) | ((incb_sum[7:0]==0)?MZ:0)
                        | (incb_sum[7]?MS:0) | (v?MV:0);
                    pc<=pc2; retire<=1'b1;
                end
                // ---- DJNZ/DBJNZ (0xF, reg=NIB1, w=bit7, no flags) ----
                else if (din[15:12]==4'hF) begin
                    disp2={8'd0,din[6:0],1'b0};
                    if (din[7]) begin
                        R[din[11:8]]<=R[din[11:8]]-16'd1;
                        pc<=(R[din[11:8]]-16'd1!=0) ? (pc2-disp2) : pc2;
                    end else begin
                        if (din[11]) R[din[10:8]][7:0] <=R[din[10:8]][7:0] -8'd1;
                        else         R[din[10:8]][15:8]<=R[din[10:8]][15:8]-8'd1;
                        pc<=pc2;
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
                else if (din[15:8]==8'h7D && din[3]==1'b0) begin
                    pc<=pc2; retire<=1'b1;
                    case (din[2:0])
                        3'd2: R[din[7:4]]<=fcw;    // FCW
                        3'd5: R[din[7:4]]<=psap;   // PSAPOFF
                        default: ; // refresh/nspseg/nspoff not modeled (unused by polepos)
                    endcase
                end
                // ---- LDCTL ctrl,rs (0x7D_1ccc, NIB3 bit3=1): write Rs -> ctrl reg ----
                else if (din[15:8]==8'h7D && din[3]==1'b1) begin
                    pc<=pc2; retire<=1'b1;
                    case (din[2:0])
                        3'd2: fcw <=R[din[7:4]];   // FCW (plain overwrite; no NSP swap - S_N never toggles in polepos)
                        3'd5: psap<=R[din[7:4]];   // PSAPOFF
                        default: ;
                    endcase
                end
                else begin illegal<=1'b1; state<=S_ILLEGAL; end
              end
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
                if (wb) R[dst]<=res16;
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
                    DA_STI:         state<=S_DA_IMM;
                    default:        state<=S_DA_WR;   // DA_STR, DA_CLR
                endcase
            end
            S_DA_IMM: begin operand<=din; pc<=pc+16'd2; state<=S_DA_WR; end
            S_DA_RD:  begin
                if (daop==DA_LDR) R[dst]<=din;
                else fcw<=(fcw & ~(MZ|MS)) | ((din==0)?MZ:0) | (din[15]?MS:0);  // TEST
                retire<=1'b1; state<=S_FETCH0;
            end
            S_DA_WR:  begin retire<=1'b1; state<=S_FETCH0; end

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
                R[dst]<=res16;
                fcw<=(fcw & ~(MC|MZ|MS)) | (cbit?MC:0)|(z?MZ:0)|(s?MS:0);
                pc<=pc+16'd2; retire<=1'b1; state<=S_FETCH0;
            end

            // ---- JP cc,addr (src holds cc) ----
            S_JP: begin
                pc<=cc_true(src,fcw[FC],fcw[FZ],fcw[FS],fcw[FV]) ? din : (pc+16'd2);
                retire<=1'b1; state<=S_FETCH0;
            end

            // ---- ADDB rd,@rs (byte, flags CZSVH, DA=0) ----
            S_ADDB_RD: begin
                operand_b = R[src][0] ? din[7:0] : din[15:8];
                dbyte     = dst[3] ? R[dst[2:0]][7:0] : R[dst[2:0]][15:8];
                add8      = {1'b0,dbyte}+{1'b0,operand_b};
                v = (operand_b[7]&dbyte[7]&~add8[7])|(~operand_b[7]&~dbyte[7]&add8[7]);
                h = (add8[3:0] < dbyte[3:0]);
                if (dst[3]) R[dst[2:0]][7:0] <=add8[7:0];
                else        R[dst[2:0]][15:8]<=add8[7:0];
                fcw<=(fcw & ~(MC|MZ|MS|MV|MDA|MH))
                   | (add8[8]?MC:0)|((add8[7:0]==0)?MZ:0)|(add8[7]?MS:0)|(v?MV:0)|(h?MH:0);
                retire<=1'b1; state<=S_FETCH0;
            end

            // ---- NVI accept sequence: push PC, push old FCW, push vec tag,
            //      then load new FCW/PC from the PSA NVI vector (PSAP+0x18/0x1A) ----
            S_NVI_PC:  begin R[15]<=R[15]-16'd2; state<=S_NVI_FCW;   end  // addr/dout comb: SP-2 <= pc
            S_NVI_FCW: begin R[15]<=R[15]-16'd2; state<=S_NVI_VEC;   end  // SP-4 <= old fcw
            S_NVI_VEC: begin R[15]<=R[15]-16'd2; state<=S_NVI_RDFCW; end  // SP-6 <= 16'h00FF
            S_NVI_RDFCW: begin fcw<=din; state<=S_NVI_RDPC; end          // fcw <= mem[psap+0x18]
            S_NVI_RDPC:  begin
                pc<=din; nvi_pending<=1'b0; state<=S_FETCH0;             // pc <= mem[psap+0x1A]
            end

            // ---- IRET: pop vec(discard), pop FCW, pop PC ----
            S_IRET_VEC: begin R[15]<=R[15]+16'd2; state<=S_IRET_FCW; end // discard din (tag)
            S_IRET_FCW: begin fcw<=din; R[15]<=R[15]+16'd2; state<=S_IRET_PC; end
            S_IRET_PC:  begin pc<=din; R[15]<=R[15]+16'd2; retire<=1'b1; state<=S_FETCH0; end

            S_ILLEGAL: ;
            default: state<=S_FETCH0;
            endcase
        end
    end

    // verilator lint_off UNUSED
    wire _unused = &{1'b0, wait_n, nmi_n, vi_n};
    // verilator lint_on UNUSED
endmodule
