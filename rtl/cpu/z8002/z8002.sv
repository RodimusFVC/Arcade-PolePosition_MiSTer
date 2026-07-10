// ============================================================================
//  z8002.sv  —  Zilog Z8002 (non-segmented Z8000) CPU core
//  Greenfield core for Arcade-PolePosition_MiSTer.  SystemVerilog, Verilator-clean.
//
//  References (in "Useful Stuff/"):
//    - MAME z8000ops.hxx / z8000tbl.hxx / z8000cpu.h  (behavioral oracle)
//    - Z8000 Technical Manual.pdf, The Z8000 Handbook.pdf
//
//  Baked-in architecture (verified vs MAME z8000cpu.h):
//    - BIG-ENDIAN.  Word@A = {mem[A] high, mem[A+1] low}.  PC even.  SP=R15.
//    - 16x16 register file with byte overlays: byte reg n -> R[n&7], HIGH if n<8
//      else LOW.  (RH0..RH7 = n 0..7, RL0..RL7 = n 8..15.)
//    - FCW: C=b7 Z=b6 S=b5 P/V=b4 DA=b3 H=b2 ; ctrl S/N=b14 VIE=b12 NVIE=b11.
//    - Reset reads FCW from mem[2], PC from mem[4] (PSA reset area).
//
//  STATUS: bring-up.  Implemented (encodings/flags copied from MAME z8000ops.hxx):
//    LD rd,#imm16 (0x210d) | CLR rd (0x8Dd8) | ADDB rd,@rs (0x00, src!=0) |
//    INC rd,#n (0xA9) | INCB rbd,#n (0xA8) | DJNZ/DBJNZ (0xF, bit7=w) | JR cc (0xE)
//  Enough for the sub1 ROM-checksum self-test.  Undecoded opcode -> S_ILLEGAL.
// ============================================================================

module z8002
(
    input  wire        clk,
    input  wire        ce,
    input  wire        reset_n,

    output wire [15:0] addr,
    output wire [15:0] dout,
    input  wire [15:0] din,
    output wire        mreq,
    output wire        iorq,
    output wire        we,
    output wire        wordacc,
    input  wire        wait_n,

    input  wire        nmi_n,
    input  wire        nvi_n,
    input  wire        vi_n,

    output wire [15:0]  dbg_pc,
    output wire [15:0]  dbg_fcw,
    output wire [15:0]  dbg_ir,
    output wire         dbg_retire,
    output wire         dbg_illegal,
    output wire [255:0] dbg_regs
);

    // FCW flag bit indices
    localparam integer FC = 7, FZ = 6, FS = 5, FV = 4, FDA = 3, FH = 2;

    // Architectural state
    reg [15:0] R [0:15];
    reg [15:0] pc, fcw, ir;
    reg [3:0]  dst, src;        // latched operand fields
    reg        retire, illegal;

    // FSM
    localparam [2:0] S_RST_FCW = 3'd0, S_RST_PC = 3'd1, S_FETCH0 = 3'd2,
                     S_LDI_IMM = 3'd3, S_ADDB_RD = 3'd4, S_ILLEGAL = 3'd5;
    reg [2:0] state;

    // Address source (combinational). Data byte reads use word-aligned address.
    assign addr = (state == S_RST_FCW) ? 16'h0002 :
                  (state == S_RST_PC ) ? 16'h0004 :
                  (state == S_ADDB_RD) ? (R[src] & 16'hFFFE) :
                                         pc;
    assign mreq    = (state != S_ILLEGAL);
    assign iorq    = 1'b0;
    assign we      = 1'b0;
    assign wordacc = (state != S_ADDB_RD);   // ADDB @rs is a byte access
    assign dout    = 16'h0000;

    assign dbg_pc = pc; assign dbg_fcw = fcw; assign dbg_ir = ir;
    assign dbg_retire = retire; assign dbg_illegal = illegal;
    assign dbg_regs = { R[15],R[14],R[13],R[12],R[11],R[10],R[ 9],R[ 8],
                        R[ 7],R[ 6],R[ 5],R[ 4],R[ 3],R[ 2],R[ 1],R[ 0] };

    // ---- condition-code evaluation (z8000cpu.h CC0..CCF) ----
    function automatic cc_true(input [3:0] cc,
                               input c, input z, input s, input pv);
        case (cc)
            4'h0: cc_true = 1'b0;
            4'h1: cc_true = pv ^ s;
            4'h2: cc_true = z | (pv ^ s);
            4'h3: cc_true = z | c;
            4'h4: cc_true = pv;
            4'h5: cc_true = s;
            4'h6: cc_true = z;
            4'h7: cc_true = c;
            4'h8: cc_true = 1'b1;
            4'h9: cc_true = ~(pv ^ s);
            4'hA: cc_true = ~(z | (pv ^ s));
            4'hB: cc_true = ~(z | c);
            4'hC: cc_true = ~pv;
            4'hD: cc_true = ~s;
            4'hE: cc_true = ~z;
            4'hF: cc_true = ~c;
        endcase
    endfunction

    // combinational scratch
    reg  [7:0] dbyte;          // current dst byte-register value
    reg  [8:0] add8;           // 9-bit byte add (carry in [8])
    reg  [7:0] operand;        // memory byte operand for ADDB @rs
    reg  [16:0] incw_sum;
    reg  [8:0]  incb_sum;
    reg  [3:0]  incn;
    reg  [15:0] pc2, disp2;
    reg  vflag, hflag;

    integer i;
    always @(posedge clk) begin
        if (!reset_n) begin
            pc <= 0; fcw <= 0; ir <= 0; dst <= 0; src <= 0;
            retire <= 1'b0; illegal <= 1'b0; state <= S_RST_FCW;
            for (i = 0; i < 16; i = i + 1) R[i] <= 16'h0000;
        end
        else if (ce) begin
            retire <= 1'b0;
            pc2 = pc + 16'd2;
            case (state)
                S_RST_FCW: begin fcw <= din; state <= S_RST_PC; end
                S_RST_PC:  begin pc  <= din; state <= S_FETCH0; end

                S_FETCH0: begin
                    ir <= din;

                    // ---- LD rd,#imm16 : 0x210d ----
                    if (din[15:8] == 8'h21 && din[7:4] == 4'h0) begin
                        dst <= din[3:0]; pc <= pc2; state <= S_LDI_IMM;
                    end
                    // ---- CLR rd : 0x8Dd8 (no flags) ----
                    else if (din[15:8] == 8'h8D && din[3:0] == 4'h8) begin
                        R[din[7:4]] <= 16'h0000; pc <= pc2; retire <= 1'b1;
                    end
                    // ---- ADDB rd,@rs : 0x00, src(rs)=NIB2 != 0 ----
                    else if (din[15:8] == 8'h00 && din[7:4] != 4'h0) begin
                        src <= din[7:4]; dst <= din[3:0]; pc <= pc2;
                        state <= S_ADDB_RD;
                    end
                    // ---- INC rd,#n : 0xA9 (word, ZSV) ----
                    else if (din[15:8] == 8'hA9) begin
                        incn     = din[3:0] + 4'd1;              // i4p1 (1..16)
                        incw_sum = {1'b0, R[din[7:4]]} + {13'd0, incn};
                        vflag    = (~incw_sum[15] & ~R[din[7:4]][15] & 1'b0)   // n[15]=0
                                 | ( 1'b0        &  R[din[7:4]][15] & ~incw_sum[15]);
                        // MAME CHK_ADDW_V with value(n) high bit = 0:
                        vflag    = (~R[din[7:4]][15]) & incw_sum[15];
                        R[din[7:4]] <= incw_sum[15:0];
                        fcw <= (fcw & ~((1<<FZ)|(1<<FS)|(1<<FV)))
                             | ((incw_sum[15:0]==0) << FZ)
                             | (incw_sum[15]        << FS)
                             | (vflag               << FV);
                        pc <= pc2; retire <= 1'b1;
                    end
                    // ---- INCB rbd,#n : 0xA8 (byte, ZSV) ----
                    else if (din[15:8] == 8'hA8) begin
                        incn    = din[3:0] + 4'd1;
                        dbyte   = din[7] ? R[din[6:4]][7:0] : R[din[6:4]][15:8];
                        incb_sum = {1'b0, dbyte} + {5'd0, incn};
                        vflag   = (~dbyte[7]) & incb_sum[7];   // n high bit = 0
                        if (din[7]) R[din[6:4]][7:0]  <= incb_sum[7:0];
                        else        R[din[6:4]][15:8] <= incb_sum[7:0];
                        fcw <= (fcw & ~((1<<FZ)|(1<<FS)|(1<<FV)))
                             | ((incb_sum[7:0]==0) << FZ)
                             | (incb_sum[7]        << FS)
                             | (vflag              << FV);
                        pc <= pc2; retire <= 1'b1;
                    end
                    // ---- DJNZ/DBJNZ : 0xF, reg=NIB1, w=bit7, dsp7=[6:0] ----
                    else if (din[15:12] == 4'hF) begin
                        disp2 = {8'd0, din[6:0], 1'b0};          // 2*dsp7
                        if (din[7]) begin                        // DJNZ (word)
                            R[din[11:8]] <= R[din[11:8]] - 16'd1;
                            pc <= (R[din[11:8]] - 16'd1 != 0) ? (pc2 - disp2) : pc2;
                        end else begin                           // DBJNZ (byte)
                            if (din[11]) R[din[10:8]][7:0]  <= R[din[10:8]][7:0]  - 8'd1;
                            else         R[din[10:8]][15:8] <= R[din[10:8]][15:8] - 8'd1;
                            pc <= pc2;   // byte form unused by boot; branch added when needed
                        end
                        retire <= 1'b1;
                    end
                    // ---- JR cc,dsp8 : 0xE (signed, no flags) ----
                    else if (din[15:12] == 4'hE) begin
                        disp2 = {{7{din[7]}}, din[7:0], 1'b0};   // 2*signext(dsp8)
                        if (cc_true(din[11:8], fcw[FC], fcw[FZ], fcw[FS], fcw[FV]))
                             pc <= pc2 + disp2;
                        else pc <= pc2;
                        retire <= 1'b1;
                    end
                    else begin
                        illegal <= 1'b1; state <= S_ILLEGAL;
                    end
                end

                // ---- LD rd,#imm16 second word ----
                S_LDI_IMM: begin
                    R[dst] <= din; pc <= pc + 16'd2; retire <= 1'b1; state <= S_FETCH0;
                end

                // ---- ADDB rd,@rs data read + add (flags CZSVH, DA=0) ----
                S_ADDB_RD: begin
                    operand = R[src][0] ? din[7:0] : din[15:8];         // big-endian byte
                    dbyte   = dst[3] ? R[dst[2:0]][7:0] : R[dst[2:0]][15:8];
                    add8    = {1'b0, dbyte} + {1'b0, operand};
                    vflag   = ( operand[7] &  dbyte[7] & ~add8[7])
                            | (~operand[7] & ~dbyte[7] &  add8[7]);
                    hflag   = (add8[3:0] < dbyte[3:0]);
                    if (dst[3]) R[dst[2:0]][7:0]  <= add8[7:0];
                    else        R[dst[2:0]][15:8] <= add8[7:0];
                    fcw <= (fcw & ~((1<<FC)|(1<<FZ)|(1<<FS)|(1<<FV)|(1<<FDA)|(1<<FH)))
                         | (add8[8]            << FC)
                         | ((add8[7:0]==0)     << FZ)
                         | (add8[7]            << FS)
                         | (vflag              << FV)
                         | (hflag              << FH);   // DA stays 0
                    retire <= 1'b1; state <= S_FETCH0;
                end

                S_ILLEGAL: ;
                default: state <= S_FETCH0;
            endcase
        end
    end

    // verilator lint_off UNUSED
    wire _unused = &{1'b0, wait_n, nmi_n, nvi_n, vi_n};
    // verilator lint_on UNUSED

endmodule
