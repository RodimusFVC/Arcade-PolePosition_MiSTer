//============================================================================
//  adc0804.sv -- ADC0804 8-bit A/D converter (accelerator / brake pedals).
//  SPDX-License-Identifier: BSD-3-Clause
//  Copyright (C) 2026 Rodimus
//  Port of MAME src/devices/machine/adc0804.cpp (license:BSD-3-Clause, copyright-holders: AJR):
//  74 ticks per conversion at 384 kHz (clk/128), a start while busy is ignored, vin is sampled at completion,
//  read clears INTR (active low).
//  Channel select (gasel: 0 = brake, 1 = accel) is done outside, at vin.
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

            // conversion_start(): ignored while a conversion is in progress
            if (wr && !busy) begin
                busy     <= 1'b1;
                conv_cnt <= 7'd0;
            end

            // advance the in-progress conversion on each 384kHz tick
            if (busy && tick_384k) begin
                if (conv_cnt == CONV_CYCLES - 7'd1) begin
                    // conversion_done(): sample vin, latch result, assert INTR.
                    // textually last, so it wins over a same-clock wr/rd clear
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
