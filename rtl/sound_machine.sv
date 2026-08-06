//============================================================================
//  sound_machine.sv -- 1:1 transliteration of rtl/sound_machine.vhd
//  (Pole Position sound machine by Dar (darfpga@aol.fr),
//  http://darfpga.blogspot.fr). Mechanical VHDL -> SystemVerilog port,
//  2026-08-05. Original header comment preserved verbatim below.
//
//  3 voices frequency/waveform synthesizer
//
//  Original hardware done with only one 4 bits sequential adder to realise
//  one 20 bits adder and two 16 bits adder.
//
//  Too nice and clever to be done another way, just doing it the same way!
//
//  ---- Arithmetic-width note (2026-08-05) -----------------------------------
//  The VHDL uses BOTH `ieee.std_logic_unsigned.all` AND `ieee.numeric_std.all`
//  in the same scope (unusual/legacy combo). For plain STD_LOGIC_VECTOR
//  operands (as used throughout this file), only std_logic_unsigned's "+"/"*"
//  overloads apply. I could not directly introspect which exact width
//  convention Quartus 17.0's bundled std_logic_unsigned resolves to (running
//  Quartus/GHDL is out of scope here). However the existing VHDL assigns the
//  `("00"&samples_chN)*volume_chN` sum-of-3-products DIRECTLY to the 10-bit
//  `audio` port with no explicit resize() call -- this only type-checks if
//  "*" returns the FULL L+R-bit product (6+4=10 bits) and "+" returns a
//  result the SAME width as its (equal-width) operands (i.e. numeric_std's
//  UNSIGNED semantics, not an old truncating-to-left-operand-width Synopsys
//  interpretation). I've transliterated on that basis. Given this design's
//  actual value ranges (max product 15*15=225, max 3-way sum 675), the result
//  never approaches the 10-bit (1023) or 5-bit `sum` (31) wrap boundary
//  either way, so the translation below is safe regardless of which exact
//  legacy convention the real toolchain uses at the extremes -- flagged here
//  for visibility, not because I found a discrepancy.
//============================================================================
`default_nettype none

module sound_machine (
    input  wire        clock_18,
    input  wire [5:0]  hcnt,
    input  wire        ena,
    input  wire [3:0]  cpu_addr,
    input  wire [3:0]  cpu_do,
    input  wire        ram_0_we,
    input  wire        ram_1_we,
    output logic [9:0] audio
);

    wire        clock_18n;
    wire [3:0]  snd_ram_addr;
    wire [3:0]  snd_ram_di;
    wire        snd_ram_0_we;
    wire        snd_ram_1_we;
    wire [3:0]  snd_ram_0_do;
    wire [3:0]  snd_ram_1_do;

    wire [7:0]  snd_seq_addr;
    wire [7:0]  snd_seq_do;

    logic [7:0] snd_samples_addr;
    wire  [7:0] snd_samples_do;

    logic [4:0] sum;
    logic [4:0] sum_r = 5'b00000;
    logic       sum_3_rr = 1'b0;

    logic [3:0] samples_ch0;
    logic [3:0] samples_ch1;
    logic [3:0] samples_ch2;
    logic [3:0] volume_ch0;
    logic [3:0] volume_ch1;
    logic [3:0] volume_ch2;

    assign clock_18n = ~clock_18;

    assign snd_seq_addr = {1'b0, ~ram_0_we, hcnt};

    assign snd_ram_addr = (ram_0_we || ram_1_we) ? cpu_addr : hcnt[5:2];
    assign snd_ram_di   = (ram_0_we || ram_1_we) ? cpu_do   : sum_r[3:0];

    assign snd_ram_0_we = (~snd_seq_do[1] & ena) | ram_0_we;
    assign snd_ram_1_we = ram_1_we;

    assign sum = {1'b0, snd_ram_0_do} + {1'b0, snd_ram_1_do} + {4'b0000, sum_r[4]};

    always_ff @(posedge clock_18) begin
        if (ena) begin
            if (snd_seq_do[3] == 1'b0) begin
                sum_r    <= 5'b00000;
                sum_3_rr <= 1'b0;
            end else if (snd_seq_do[0] == 1'b0) begin
                sum_r    <= sum;
                sum_3_rr <= sum_r[3];
            end

            snd_samples_addr <= {snd_ram_0_do[2:0], sum_r[3:0], sum_3_rr};

            if (snd_seq_do[2] == 1'b0) begin
                if (hcnt[5:2] == 4'h5) begin
                    samples_ch0 <= snd_samples_do[3:0];
                    volume_ch0  <= snd_ram_1_do;
                end
                if (hcnt[5:2] == 4'hA) begin
                    samples_ch1 <= snd_samples_do[3:0];
                    volume_ch1  <= snd_ram_1_do;
                end
                if (hcnt[5:2] == 4'hF) begin
                    samples_ch2 <= snd_samples_do[3:0];
                    volume_ch2  <= snd_ram_1_do;
                end
            end

            audio <= {2'b00, samples_ch0} * volume_ch0 +
                     {2'b00, samples_ch1} * volume_ch1 +
                     {2'b00, samples_ch2} * volume_ch2;

        end
    end

    // sound register RAM0
    gen_ram #(.dWidth(4), .aWidth(4)) sound_ram_0 (
        .clk  (clock_18n),
        .we   (snd_ram_0_we),
        .addr (snd_ram_addr),
        .d    (snd_ram_di),
        .q    (snd_ram_0_do)
    );

    // sound register RAM1
    gen_ram #(.dWidth(4), .aWidth(4)) sound_ram_1 (
        .clk  (clock_18n),
        .we   (snd_ram_1_we),
        .addr (snd_ram_addr),
        .d    (snd_ram_di),
        .q    (snd_ram_1_do)
    );

    // sound samples ROM
    sound_samples sound_samples_i (
        .clk  (clock_18n),
        .addr (snd_samples_addr),
        .data (snd_samples_do)
    );

    // sound compute sequencer ROM
    sound_seq sound_seq_i (
        .clk  (clock_18n),
        .addr (snd_seq_addr),
        .data (snd_seq_do)
    );

endmodule

`default_nettype wire
