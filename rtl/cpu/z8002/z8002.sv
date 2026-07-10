// ============================================================================
//  z8002.sv  —  Zilog Z8002 (non-segmented Z8000) CPU core
//  Greenfield core for Arcade-PolePosition_MiSTer.  SystemVerilog, Verilator-clean.
//
//  References (in "Useful Stuff/"):
//    - MAME z8000ops.hxx / z8000tbl.hxx / z8000cpu.h  (behavioral oracle)
//    - Z8000 Technical Manual.pdf, The Z8000 Handbook.pdf
//
//  Architecture notes baked in from day one (do not "fix" these later):
//    - BIG-ENDIAN.  Memory word at address A = { mem[A] (high), mem[A+1] (low) }.
//      The C++/RTL memory model assembles words that way; the core sees words.
//    - Non-segmented (Z8002): 16-bit addresses, PC is even, SP = R15.
//    - 16x16-bit register file with byte/word/long/quad overlays (added when
//      decode needs them).  FCW carries flags + control bits (S/N, VIE, NVIE).
//
//  STATUS: SKELETON — fetch pipeline + PC/FCW/reset only.  NO instruction
//  decode yet.  Halts on sentinel word 0x7A00 so the harness can bound a run.
//  This exists to prove the Verilator co-sim flow end-to-end before opcodes go in.
// ============================================================================

module z8002
(
    input  wire        clk,
    input  wire        ce,        // clock enable (1 CPU tick per asserted ce)
    input  wire        reset_n,   // active-low reset

    // ---- Memory / I/O bus (word-wide; memory model handles big-endian) ----
    output wire [15:0] addr,      // effective address (combinational)
    output wire [15:0] dout,      // write data
    input  wire [15:0] din,       // read data
    output wire        mreq,      // transaction request this cycle
    output wire        iorq,      // 1 = I/O space, 0 = memory space
    output wire        we,        // 1 = write, 0 = read
    output wire        wordacc,   // 1 = word access, 0 = byte access
    input  wire        wait_n,    // wait-state input (unused in skeleton)

    // ---- Interrupts (active low; unused in skeleton) ----
    input  wire        nmi_n,
    input  wire        nvi_n,
    input  wire        vi_n,

    // ---- Debug / trace taps ----
    output wire [15:0] dbg_pc,
    output wire [15:0] dbg_fcw,
    output wire [15:0] dbg_ir,
    output wire        dbg_retire // pulses 1 clk when an instruction completes
);

    // ------------------------------------------------------------------
    //  Architectural state
    // ------------------------------------------------------------------
    reg [15:0] pc;
    reg [15:0] fcw;
    reg [15:0] ir;              // latched first instruction word

    // Reset defaults — PLACEHOLDER until PSA-based reset is implemented.
    // Real Z8002 reset loads FCW then PC from the Program Status Area.
    // TODO(z8002): fetch RESET_FCW/RESET_PC from PSA vector (z8000cpu.h RST).
    localparam [15:0] RESET_FCW = 16'h5000; // S/N=1 (system), seg=0, ints off
    localparam [15:0] RESET_PC  = 16'h0000;

    // ------------------------------------------------------------------
    //  Fetch FSM (skeleton)
    // ------------------------------------------------------------------
    localparam [1:0] S_FETCH = 2'd0,
                     S_HALT  = 2'd1;
    reg [1:0] state;
    reg       retire;

    // Combinational bus outputs (skeleton: address is always PC = fetch only)
    assign addr    = pc;
    assign mreq    = (state == S_FETCH);
    assign iorq    = 1'b0;
    assign we      = 1'b0;
    assign wordacc = 1'b1;
    assign dout    = 16'h0000;

    assign dbg_pc     = pc;
    assign dbg_fcw    = fcw;
    assign dbg_ir     = ir;
    assign dbg_retire = retire;

    always @(posedge clk) begin
        if (!reset_n) begin
            pc     <= RESET_PC;
            fcw    <= RESET_FCW;
            ir     <= 16'h0000;
            retire <= 1'b0;
            state  <= S_FETCH;
        end
        else if (ce) begin
            retire <= 1'b0;
            case (state)
                S_FETCH: begin
                    ir <= din;                 // din reflects mem[addr==pc]
                    if (din == 16'h7A00) begin // sentinel HALT (placeholder)
                        state <= S_HALT;
                    end
                    else begin
                        pc     <= pc + 16'd2;
                        retire <= 1'b1;
                    end
                end
                S_HALT: begin
                    // stay halted
                end
                default: state <= S_FETCH;
            endcase
        end
    end

    // Silence Verilator UNUSED on not-yet-wired inputs (removed as they get used)
    // verilator lint_off UNUSED
    wire _unused = &{1'b0, wait_n, nmi_n, nvi_n, vi_n, din[14:0]};
    // verilator lint_on UNUSED

endmodule
