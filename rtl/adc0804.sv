//============================================================================
//  adc0804.sv — ADC0804 8-bit A/D converter (Pole Position accelerator/brake
//    pedal input), faithful port of MAME's device model.
//
//  Ground truth: MAME src/devices/machine/adc0804.cpp/.h.
//    adc0804_device::s_conversion_cycles = 74   (device clock ticks per conversion)
//    write(offset,data): set_interrupt(false); conversion_start();
//    conversion_start(): only (re)starts the conversion timer if one is NOT
//      already running (MAME: `if (!m_timer->enabled())`) — a start request
//      while busy is silently IGNORED, the in-flight conversion runs to completion.
//    conversion_done(): m_result = m_vin_callback();  set_interrupt(true);
//      (the analog input is sampled AT completion, NOT at the start-conversion write)
//    read(offset): set_interrupt(false); return m_result;
//      (RD_STROBED mode — the default; polepos.cpp never calls set_rd_mode(), so
//      this is the mode that applies. A read always clears the interrupt too.)
//    intr_r(): return m_intr_active ? 0 : 1;
//      => the INTR pin is ACTIVE LOW: 0 while a completed result is waiting,
//      1 otherwise. This module's `intr_n` output is that same pin directly.
//
//  Instantiation (src/mame/namco/polepos.cpp):
//    ADC0804(config, m_adc, MASTER_CLOCK/8/8);   MASTER_CLOCK=24.576MHz -> 384 kHz
//    m_adc->vin_callback().set(FUNC(polepos_state::analog_r));
//    z80_io: map(0x00,0x00).rw(m_adc, read, write);  IN A,($00)=read, OUT ($00),A=start
//
//  Channel select (LS259 q3, MAME polepos.h/.cpp — VERIFIED, an earlier comment
//  elsewhere in this codebase had this backwards):
//    m_analog_io(*this, {"BRAKE", "ACCEL"})   // index 0 = BRAKE, index 1 = ACCEL
//    analog_r() { return m_analog_io[m_adc_input & 1]->read(); }
//    gasel_w(state) { m_adc_input = state; }
//    ==> gasel == 0 selects BRAKE.  gasel == 1 selects ACCEL.
//    (channel muxing itself is done OUTSIDE this module, at the vin input —
//    see poleposition.vhd's adc_vin <= accel_in when gasel_w='1' else brake_in;)
//
//  Pedal range: MAME PORT_MINMAX(0, 0x90) — full scale is 0x90, NOT 0xFF.
//
//  Fabric clock: clk_sys = CLK_49M = 49.152 MHz = 2x MASTER_CLOCK, so the
//  384 kHz ADC clock here = clk_sys / 128 (49.152MHz/128 = 384kHz, matching
//  MAME's MASTER_CLOCK/8/8 exactly since MASTER_CLOCK = clk_sys/2).
//============================================================================
`default_nettype none

module adc0804
(
    input  wire        clk,        // CLK_49M fabric clock (49.152 MHz)
    input  wire        reset,      // active-high
    input  wire        wr,         // 1-clk strobe: start conversion (Z80 OUT ($00),A)
    input  wire        rd,         // 1-clk strobe: read result      (Z80 IN A,($00))
    input  wire  [7:0] vin,        // analog input, sampled AT conversion_done (not at start)
    output wire  [7:0] dout,       // conversion result
    output wire        intr_n      // ADC0804 INTR pin, active-low (0 = conversion complete)
);

    // ---- 384 kHz tick generator: clk_sys/128 clock-enable ---------------------
    //   49.152 MHz / 128 = 384 kHz = MAME's ADC0804(config, m_adc, MASTER_CLOCK/8/8)
    //   with MASTER_CLOCK = 24.576 MHz (= clk_sys/2).
    reg [6:0] clk_div;
    wire      tick_384k = (clk_div == 7'd127);

    always @(posedge clk) begin
        if (reset) clk_div <= 7'd0;
        else       clk_div <= clk_div + 7'd1;
    end

    // ---- conversion state machine ---------------------------------------------
    localparam [6:0] CONV_CYCLES = 7'd74;   // MAME adc0804.cpp s_conversion_cycles

    reg        busy;
    reg  [6:0] conv_cnt;    // counts 384kHz ticks elapsed since conversion_start()
    reg  [7:0] result_r;
    reg        intr_active; // mirrors MAME's m_intr_active (1 = INTR asserted/active)

    always @(posedge clk) begin
        if (reset) begin
            busy        <= 1'b0;
            conv_cnt    <= 7'd0;
            result_r    <= 8'h00;
            intr_active <= 1'b0;
        end else begin
            // write() and read() both do set_interrupt(false) unconditionally.
            if (wr | rd) intr_active <= 1'b0;

            // conversion_start(): ignored while a conversion is already in progress
            // (MAME: `if (!m_timer->enabled())`).
            if (wr && !busy) begin
                busy     <= 1'b1;
                conv_cnt <= 7'd0;
            end

            // advance the in-progress conversion on each 384kHz tick
            if (busy && tick_384k) begin
                if (conv_cnt == CONV_CYCLES - 7'd1) begin
                    // conversion_done(): sample vin, latch result, assert INTR.
                    // This assignment is textually last, so it wins over the
                    // wr/rd clear above if they land on the same clock edge.
                    busy        <= 1'b0;
                    result_r    <= vin;
                    intr_active <= 1'b1;
                end else begin
                    conv_cnt <= conv_cnt + 7'd1;
                end
            end
        end
    end

    assign dout   = result_r;
    assign intr_n = ~intr_active;

endmodule

`default_nettype wire
