---------------------------------------------------------------------------------
-- mb88 by Dar (darfpga@aol.fr)
-- http://darfpga.blogspot.fr
---------------------------------------------------------------------------------
--
-- Version 0.3 -- 28/02/2017 --
--   fixed instruction JMP (0xC0..0xFF) let r_pa be incremented when r_pc = 0x3F
--
-- Version 0.2 -- 26/02/2017 --
--   corrected r_stf for tstR instruction (0x24)
--   corrected r_stf for tbit instruction (0x38-0x3B)
--
-- Version 0.1 -- 25/02/2017 --
--	 outO instruction write to ol,oh depending on r_cf
---------------------------------------------------------------------------------
-- Educational use only
-- Do not redistribute synthetized file with roms
-- Do not redistribute roms whatever the form
-- Use at your own risk
---------------------------------------------------------------------------------

--  Todo : Timer, Serial

--  Features :

---------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity mb88 is
port(
 clock     : in std_logic;
 ena       : in std_logic;
 ena_timer : in std_logic;
 reset_n   : in std_logic;

 r0_port_in  : in  std_logic_vector(3 downto 0);
 r1_port_in  : in  std_logic_vector(3 downto 0);
 r2_port_in  : in  std_logic_vector(3 downto 0);
 r3_port_in  : in  std_logic_vector(3 downto 0);
 r0_port_out : out std_logic_vector(3 downto 0);
 r1_port_out : out std_logic_vector(3 downto 0);
 r2_port_out : out std_logic_vector(3 downto 0);
 r3_port_out : out std_logic_vector(3 downto 0);
 k_port_in   : in  std_logic_vector(3 downto 0);
 ol_port_out : out std_logic_vector(3 downto 0);
 oh_port_out : out std_logic_vector(3 downto 0);
 p_port_out  : out std_logic_vector(3 downto 0);

 stby_n    : in std_logic;
 tc_n      : in std_logic;
 irq_n     : in std_logic;
 sc_in_n   : in std_logic;
 si_n      : in std_logic;
 sc_out_n  : out std_logic;
 so_n      : out std_logic;
 to_n      : out std_logic;

 rom_addr  : out std_logic_vector(10 downto 0);
 rom_data  : in  std_logic_vector( 7 downto 0);

 -- DIAG-REVERT-2026-07-06g: fixed-address read-only taps into internal RAM, no input port needed --
 -- always expose M[4,1]/M[4,2] (the shared protrom-sweep pointer's low/high nibble) for a live snapshot.
 dbg_ram41_do : out std_logic_vector(3 downto 0);
 dbg_ram42_do : out std_logic_vector(3 downto 0);
 -- DIAG-REVERT-2026-07-08: expose the readback path to catch a store/read-after-write hazard in the
 -- 0x157 debounce (ST writes K to M[X,Y], EOR compares K vs `mem`). dbg_mem_do = the registered `mem`
 -- (what EOR actually compares against); dbg_ramdo_do = the live combinational RAM output at the same addr.
 -- If they differ at the EOR (0x15A) while K is stable, the debounce compare is fed a stale value = the bug.
 dbg_mem_do   : out std_logic_vector(3 downto 0);
 dbg_ramdo_do : out std_logic_vector(3 downto 0);
 -- DIAG-REVERT-2026-07-08b: expose the live RAM address + write-data so we can see, at the hung debounce,
 -- exactly WHERE the ST (0x158) writes and WHAT value, vs WHERE the EOR (0x15A) reads.
 dbg_ramaddr_do : out std_logic_vector(6 downto 0);
 dbg_ramdi_do   : out std_logic_vector(3 downto 0);
 dbg_ramwe_do   : out std_logic;  -- DIAG-REVERT-2026-07-08b: is the write actually enabled at the ST?
                                  -- DIAG-REVERT-2026-07-09-RING: trailing ';' added here (was the last port)
 -- DIAG-REVERT-2026-07-09-RING: foreground instruction-boundary markers for the wrapper's PC ring buffer.
 -- dbg_sbo_do   = single_byte_op: on an `ena` cycle, '1' means the byte at rom_addr is the FIRST byte of an
 --                instruction -- this is exactly the condition the opcode case-dispatch is gated on (line ~520).
 --                '0' means rom_addr points at the 2nd byte (operand) of a 2-byte opcode.
 -- dbg_inirq_do = r_in_irq: '1' from interrupt-accept until the matching `rti`.
 -- Sampling rom_addr when (ena and dbg_sbo_do and not dbg_inirq_do) therefore yields precisely the
 -- FOREGROUND instruction stream: no operand bytes, no ISR PCs. That is what we diff vs kangaroo_ape.trace.
 dbg_sbo_do   : out std_logic;
 dbg_inirq_do : out std_logic;
 -- DIAG-REVERT-2026-07-10-M7BUF: expose all 16 nibbles of bank 7 (M[7,0..F] = ram 0x70-0x7F), the buffer
 -- that 0x139 fills with protrom bytes and that 0x463 reloads M[4,1..3] from. Read-only, no behaviour change.
 dbg_m7_do : out std_logic_vector(63 downto 0)

 );
end mb88;

architecture struct of mb88 is

 signal reset   : std_logic;
 signal clock_n : std_logic;

 signal ram_addr : std_logic_vector(6 downto 0);
 signal ram_we   : std_logic;
 signal ram_di   : std_logic_vector(3 downto 0);
 signal ram_do   : std_logic_vector(3 downto 0);

 signal r_pc  : std_logic_vector(5 downto 0) := (others=>'0');
 signal r_pa  : std_logic_vector(4 downto 0) := (others=>'0');
 signal r_si  : std_logic_vector(1 downto 0) := (others=>'0');
 signal r_a   : std_logic_vector(3 downto 0) := (others=>'0');
 signal r_x   : std_logic_vector(3 downto 0) := (others=>'0');
 signal r_y   : std_logic_vector(3 downto 0) := (others=>'0');
 signal r_stf : std_logic := '1';
 signal r_zf  : std_logic := '0';
 signal r_cf  : std_logic := '0';
 signal r_vf  : std_logic := '0';
 signal tmr_ovf : std_logic;  -- MCU-TIMERVF-FIX-2026-06-22: high the cycle the timer overflows (protects r_vf vs a coincident tstv clear)
 signal tmr_presc : std_logic_vector(5 downto 0) := (others=>'0');  -- MCU-PRESC-FIX-2026-06-22: instruction-based timer prescaler (MAME m_TP)
 signal tmr_itick : std_logic;  -- MCU-PRESC-FIX-2026-06-22: timer tick = every 32 INSTRUCTIONS (not clocks)
 -- MCU-PRESC-FIX2-2026-07-06: per-instruction CYCLE credit toward tmr_presc (0/1/2), see the tmr_credit
 -- assignment below for why this replaces a flat +1.
 signal tmr_credit : std_logic_vector(5 downto 0);
 signal r_sf  : std_logic := '0';
 signal r_nf  : std_logic := '0';

 signal r_pio : std_logic_vector(7 downto 0) := (others=>'0');
 signal r_th  : std_logic_vector(3 downto 0) := (others=>'0');
 signal r_tl  : std_logic_vector(3 downto 0) := (others=>'0');
 signal r_tp  : std_logic_vector(5 downto 0) := (others=>'0');
 signal r_ctr : std_logic_vector(5 downto 0) := (others=>'0');

 signal r_sb    : std_logic_vector(3 downto 0) := (others=>'0');
 signal r_sbcnt : std_logic_vector(3 downto 0) := (others=>'0');

 signal interrupt_pending : std_logic := '0';
 signal timer_interrupt_pending : std_logic := '0';
 signal r_in_irq : std_logic := '0';  -- MCU-INIRQ-FIX-2026-06-22: nested-IRQ guard (ported from mb88xx.v / MAME m_in_irq)
 signal irq_n_r           : std_logic := '0';

 signal tc_n_r : std_logic := '0';

 subtype stack_size is integer range 0 to 3;
 type    stack_def  is array(stack_size) of std_logic_vector(15 downto 0);
 signal  stack : stack_def := (others=>(others=>'0'));

 subtype ram_size is integer range 0 to 127;
 type    ram_def  is array(ram_size) of std_logic_vector(3 downto 0);
 signal  ram : ram_def := (others=>(others=>'0'));

 signal single_byte_op : std_logic := '1';
 -- MCU-IRQPC-FIX-2026-07-09: two-phase interrupt entry. MAME's irq check lives in burn_cycles(), called at
 -- mb88xx.cpp:999 AFTER the opcode switch, so the pushed frame (mb88xx.cpp:453-459) holds the FULLY RESOLVED
 -- next PC (post-INCPC, post-jump/call/rts) and the POST-instruction CF/ZF/ST. Vectoring in the same cycle the
 -- instruction executes -- as this core did -- pushes the PRE-instruction PC and PRE-instruction flags, so rti
 -- returns to the interrupted instruction and RE-EXECUTES it. Its A/X/Y/RAM side effects are not restored, so
 -- they apply twice: ICM and ICY double-increment, AI double-adds. With the timer ISR firing tens of thousands
 -- of times per session, that is what walks the protrom sweep pointer off its intended track.
 -- Phase 1 (below, at a complete-instruction boundary): latch the request, let the instruction finish.
 -- Phase 2 (next ena cycle): PC increment + opcode dispatch are suppressed, so r_pa/r_pc still hold the
 -- resolved next PC and the flags are post-instruction -- push exactly those, then vector.
 signal irq_latched : std_logic := '0';
 signal irq_is_ext  : std_logic := '0';
 signal op_code        : std_logic_vector(7 downto 0) := X"00";

 signal a_p1   : std_logic_vector(3 downto 0);
 signal a_p1_z : std_logic;
 signal a_p1_c : std_logic;
 signal a_m1   : std_logic_vector(3 downto 0);
 signal a_m1_z : std_logic;
 signal a_m1_c : std_logic;
 signal y_p1   : std_logic_vector(3 downto 0);
 signal y_p1_z : std_logic;
 signal y_p1_c : std_logic;
 signal y_m1   : std_logic_vector(3 downto 0);
 signal y_m1_z : std_logic;
 signal y_m1_c : std_logic;
 signal m_p1   : std_logic_vector(3 downto 0);
 signal m_p1_z : std_logic;
 signal m_p1_c : std_logic;
 signal m_m1   : std_logic_vector(3 downto 0);
 signal m_m1_z : std_logic;
 signal m_m1_c : std_logic;
 signal adc    : std_logic_vector(4 downto 0);
 signal adc_z  : std_logic;
 signal adc_c  : std_logic;
 signal sbc    : std_logic_vector(4 downto 0);
 signal sbc_z  : std_logic;
 signal sbc_c  : std_logic;
 signal cma    : std_logic_vector(4 downto 0);
 signal cma_z  : std_logic;
 signal cma_c  : std_logic;
 signal a_pim : std_logic_vector(4 downto 0);
 signal a_pim_z: std_logic;
 signal a_pim_c: std_logic;
 signal im_my  : std_logic_vector(4 downto 0);
 signal im_my_z: std_logic;
 signal im_my_c: std_logic;
 signal im_ma  : std_logic_vector(4 downto 0);
 signal im_ma_z: std_logic;
 signal im_ma_c: std_logic;
 signal a_and_m   : std_logic_vector(3 downto 0);
 signal a_and_m_z : std_logic;
 signal a_or_m    : std_logic_vector(3 downto 0);
 signal a_or_m_z  : std_logic;
 signal a_xor_m   : std_logic_vector(3 downto 0);
 signal a_xor_m_z : std_logic;
 signal nega   : std_logic_vector(3 downto 0);
 signal nega_z : std_logic;
 signal rola   : std_logic_vector(3 downto 0);
 signal rola_z : std_logic;
 signal rora   : std_logic_vector(3 downto 0);
 signal rora_z : std_logic;
 signal do_da  : std_logic;
 signal daa    : std_logic_vector(3 downto 0);
 signal daa_z  : std_logic;
 signal daa_c  : std_logic;
 signal das    : std_logic_vector(3 downto 0);
 signal das_z  : std_logic;
 signal das_c  : std_logic;
 signal dca    : std_logic_vector(3 downto 0);
 signal dca_z  : std_logic;
 signal dca_c  : std_logic;
 signal x_z    : std_logic;
 signal y_z    : std_logic;
 signal tl_z   : std_logic;
 signal th_z   : std_logic;
 signal sb_z   : std_logic;
 signal k_port_in_z : std_logic;
 signal r0_port_in_z : std_logic;
 signal r1_port_in_z : std_logic;
 signal r2_port_in_z : std_logic;
 signal r3_port_in_z : std_logic;
 signal sel_bit_y    : std_logic_vector(3 downto 0);

 signal m_set_bit : std_logic_vector(3 downto 0);
 signal m_clr_bit : std_logic_vector(3 downto 0);
 signal m_tst_bit : std_logic;

 signal mem   : std_logic_vector(3 downto 0);
 signal mem_z : std_logic;
 signal imm_x7_z : std_logic;
 signal imm_xF_z : std_logic;

begin

clock_n <= not clock;
reset   <= not reset_n;

rom_addr <= r_pa & r_pc;

-- MCU-TIMERVF-FIX-2026-06-22: the timer-overflow condition, combinational (mirrors the timer block's r_vf<='1').
-- darfpga ticks the timer BEFORE the instruction; MAME does it after (burn_cycles). So a tstv on the same cycle
-- as an overflow would clear r_vf and LOSE that overflow -> a poll-based countdown (the 45s ape timer) starves
-- while the interrupt-driven heartbeat survives. tstv now skips its clear when this is high (see X"26").
tmr_ovf <= '1' when ( ((tc_n = '0' and tc_n_r = '1' and r_pio(6) = '1') or
                       (tmr_itick = '1' and r_pio(7) = '1'))
                      and r_tl = X"F" and r_th = X"F" ) else '0';

-- MCU-PRESC-FIX-2026-06-22: timer prescaler tick = every 32 INSTRUCTIONS (ena & single_byte_op = 1 instr), like
-- MAME's m_TP += cycles in burn_cycles. The old clock-based ena_timer over-counted during the long timer ISR
-- (2-byte ops add clocks), overflowing the timer mid-ISR -> with m_in_irq the ISR re-fired back-to-back -> the
-- main loop starved -> the 45s count never reached 0x202 (clear R0 bit1) -> ape never spawned.
-- MCU-PRESC-FIX2-2026-07-06: the +1-per-instruction model above is STILL wrong vs real MAME. MAME's own
-- burn_cycles(oc) (mb88xx.cpp) adds the real per-instruction CYCLE count to m_TP, and oc=2 (not 1) for the six
-- 2-byte opcodes (jpa/en/dis/call/jpl -- rom_data=X"3D"/X"3E"/X"3F"/X"60".."X"6F"), credited ONCE per complete
-- instruction. Confirmed straight from MAME source (commit bfb725374d, "hap", 2024-12-03) which renamed
-- update_pio->burn_cycles specifically to fix timer/irq-cycle accounting. Our old flat +1 undercounts every
-- 2-byte op by 1 cycle -- and CALL/JPL/JPA/EN/DIS are 21.3% of all instructions in the real ROM (359/1689,
-- counted directly from kangaroo_mcu.dasm), so our internal timer runs meaningfully SLOWER than MAME's whenever
-- the K-port dispatcher (built on CALL/JPA/JPL) is active -- a real, ROM-data-backed rate-mismatch candidate for
-- the still-open "ape never spawns" bug. tmr_credit (below) supplies 0 on a 2-byte op's FIRST byte (deferred,
-- not yet a complete instruction), 2 on its SECOND byte (completes the instruction, matches burn_cycles(oc=2)
-- firing once), and 1 for an ordinary 1-byte op -- then tmr_itick/tmr_presc (both here and in the clocked
-- process below) use that credit instead of a flat +1, with correct wraparound for the +2 case.
-- Original (superseded) comparison, for reference:
-- tmr_itick <= '1' when (ena = '1' and single_byte_op = '1' and tmr_presc = "011111") else '0';
tmr_credit <= "000010" when (ena = '1' and single_byte_op = '0') else                    -- completing 2-byte op: +2
              "000000" when (ena = '1' and single_byte_op = '1' and
                             (rom_data = X"3D" or rom_data = X"3E" or rom_data = X"3F" or
                              (rom_data >= X"60" and rom_data <= X"6F"))) else            -- 1st byte of 2-byte op: +0 (deferred)
              "000001" when (ena = '1' and single_byte_op = '1') else "000000";           -- ordinary 1-byte op: +1

tmr_itick <= '1' when ((tmr_presc + tmr_credit) >= "100000") else '0';

ram_addr <= X"0" & rom_data(2 downto 0) when ((rom_data >= X"50") and (rom_data <= X"57")) else r_x(2 downto 0) & r_y;

ram_we <= '1' when(( (rom_data = X"1D")  or  (rom_data = X"1A") or
                     (rom_data = X"0A")  or  (rom_data = X"0B") or
										 (rom_data = X"2A")  or
                     (rom_data = X"19")  or  (rom_data = X"09") or
									  ((rom_data >= X"30") and (rom_data <= X"37") ) or
									  ((rom_data >= X"50") and (rom_data <= X"57") )
									 ) and (single_byte_op = '1')and ena = '1')
							else '0';

with rom_data select
ram_di <= r_a  when X"1D", r_a  when X"1A",
					r_a  when X"0A", r_a  when X"0B",
					r_sb when X"2A",
					m_m1 when X"19", m_p1 when X"09",
					m_set_bit when X"30", m_clr_bit when X"34",
					m_set_bit when X"31", m_clr_bit when X"35",
					m_set_bit when X"32", m_clr_bit when X"36",
					m_set_bit when X"33", m_clr_bit when X"37",
					r_a  when X"50", r_y when X"54",
					r_a  when X"51", r_y when X"55",
					r_a  when X"52", r_y when X"56",
					r_a  when X"53", r_y when X"57",
					X"A" when others;


a_p1   <= r_a + X"1";
a_p1_z <= '1' when a_p1 = X"0" else '0';
a_p1_c <= '1' when a_p1 = X"0" else '0';

a_m1   <= r_a - X"1";
a_m1_z <= '1' when a_m1 = X"0" else '0';
a_m1_c <= '1' when a_m1 = X"F" else '0';

y_p1   <= r_y + X"1";
y_p1_z <= '1' when y_p1 = X"0" else '0';
y_p1_c <= '1' when y_p1 = X"0" else '0';

y_m1   <= r_y - X"1";
y_m1_z <= '1' when y_m1 = X"0" else '0';
y_m1_c <= '1' when y_m1 = X"F" else '0';

m_p1   <= ram_do + X"1";
--m_p1_z <= '1' when m_p1 = X"0" else '0';
--m_p1_c <= '1' when m_p1 = X"0" else '0';

m_m1   <= ram_do - X"1";
--m_m1_z <= '1' when m_m1 = X"0" else '0';
--m_m1_c <= '1' when m_m1 = X"F" else '0';

-- MCU-SBITRBIT-FIX-2026-07-03: bit index for SBIT(0x30-33)/RBIT(0x34-37) is `opcode & 3` (MAME
-- mb88xx.cpp:816-826: "1 << (opcode & 3)") -- the low 2 bits ONLY. The select was keying on
-- rom_data(2 downto 0) (3 bits) against literal patterns "000"/"001"/"010"/others. SBIT's opcodes
-- (0x30-0x33) happen to always have bit2=0, so bits(2:0) coincidentally equal opcode&3 there and it
-- "worked" by accident -- but RBIT's opcodes (0x34-0x37) ALWAYS have bit2=1 (0x34="100"..0x37="111"),
-- so NONE of them ever matched "000"/"001"/"010" -- every RBIT variant fell through to `others` and
-- cleared bit3 unconditionally, regardless of which bit it was actually supposed to clear. RBIT 0/1/2
-- were silently broken (only RBIT 3 worked, by coincidence) despite being one of the most-used opcodes
-- in the ROM (~21k hits in one boot/attract trace). Original (buggy) selectors below, for reference:
-- with rom_data(2 downto 0) select
-- m_set_bit <= ram_do or X"1" when "000", ram_do or X"2" when "001",
--              ram_do or X"4" when "010", ram_do or X"8" when others;
-- with rom_data(2 downto 0) select
-- m_clr_bit <= ram_do and not X"1" when "000", ram_do and not X"2" when "001",
--              ram_do and not X"4" when "010", ram_do and not X"8" when others;
with rom_data(1 downto 0) select
m_set_bit <= ram_do or X"1" when "00",
             ram_do or X"2" when "01",
             ram_do or X"4" when "10",
             ram_do or X"8" when others;

with rom_data(1 downto 0) select
m_clr_bit <= ram_do and not X"1" when "00",
             ram_do and not X"2" when "01",
             ram_do and not X"4" when "10",
             ram_do and not X"8" when others;

m_tst_bit <= ram_do(to_integer(unsigned(rom_data(1 downto 0))));

rola   <= r_a(2 downto 0) & r_cf;
rola_z <= '1' when rola = X"0" else '0';

rora   <= r_cf & r_a(3 downto 1);
rora_z <= '1' when rora = X"0" else '0';

nega   <= not(r_a) + X"1";
nega_z <= '1' when nega = X"0" else '0';

adc <= ('0'&ram_do) + ('0'&r_a) + ("0000"&r_cf);
adc_z <= '1' when adc(3 downto 0) = X"0" else '0';
adc_c <= '1' when adc(4) = '1' else '0';

sbc <= ('0'&ram_do) - ('0'&r_a) - ("0000"&r_cf);
sbc_z <= '1' when sbc(3 downto 0) = X"0" else '0';
sbc_c <= '1' when sbc(4) = '1' else '0';

cma <= ('0'&ram_do) - ('0'&r_a);
cma_z <= '1' when cma(3 downto 0) = X"0" else '0';
cma_c <= '1' when cma(4) = '1' else '0';

a_pim   <= ('0'&rom_data(3 downto 0)) + ('0'&r_a);
a_pim_z <= '1' when a_pim(3 downto 0) = X"0" else '0';
a_pim_c <= '1' when a_pim(4) = '1' else '0';

im_my   <= ('0'&rom_data(3 downto 0)) - ('0'&r_y);
im_my_z <= '1' when im_my(3 downto 0) = X"0" else '0';
im_my_c <= '1' when im_my(4) = '1' else '0';

im_ma   <= ('0'&rom_data(3 downto 0)) - ('0'&r_a);
im_ma_z <= '1' when im_ma(3 downto 0) = X"0" else '0';
im_ma_c <= '1' when im_ma(4) = '1' else '0';

a_and_m <= r_a and ram_do;
a_and_m_z <= '1' when a_and_m = X"0" else '0';

a_or_m <= r_a or ram_do;
a_or_m_z <= '1' when a_or_m = X"0" else '0';

a_xor_m <= r_a xor ram_do;
a_xor_m_z <= '1' when a_xor_m = X"0" else '0';

do_da <= '1' when (r_a > X"9") or (r_cf = '1') else '0';

daa <= r_a + X"6";
daa_z <= '1' when daa = X"0" else '0';
daa_c <= '1' when r_a > X"9" else '0';

das <= r_a + X"A";
das_z <= '1' when das = X"0" else '0';
das_c <= '1' when r_a > X"5" else '0';

dca <= r_a + X"F";
dca_z <= '1' when dca = X"0" else '0';
dca_c <= '1' when dca = X"F" else '0';

x_z  <= '1' when r_x  = X"0" else '0';
y_z  <= '1' when r_y  = X"0" else '0';
tl_z <= '1' when r_tl = X"0" else '0';
th_z <= '1' when r_th = X"0" else '0';
sb_z <= '1' when r_sb = X"0" else '0';
k_port_in_z <= '1' when k_port_in = X"0" else '0';
r0_port_in_z <= '1' when r0_port_in = X"0" else '0';
r1_port_in_z <= '1' when r1_port_in = X"0" else '0';
r2_port_in_z <= '1' when r2_port_in = X"0" else '0';
r3_port_in_z <= '1' when r3_port_in = X"0" else '0';

with r_y(1 downto 0) select
sel_bit_y <= "0001" when "00",
						 "0010" when "01",
						 "0100" when "10",
						 "1000" when others;

imm_x7_z <= '1' when rom_data(2 downto 0) =  "000" else '0';
imm_xF_z <= '1' when rom_data(3 downto 0) = "0000" else '0';

process (clock_n)  -- register data before memory value update at middle cycle
begin
 if rising_edge(clock_n) then
  mem <= ram_do;
	if ram_do = X"0" then mem_z  <= '1'; else mem_z  <= '0'; end if;
	if m_p1 = X"0"   then m_p1_z <= '1';  else m_p1_z <= '0'; end if;
	if m_p1 = X"0"   then m_p1_c <= '1';  else m_p1_c <= '0'; end if;
	if m_m1 = X"0"   then m_m1_z <= '1';  else m_m1_z <= '0'; end if;
	if m_m1 = X"F"   then m_m1_c <= '1';  else m_m1_c <= '0'; end if;
end if;
end process;

process (clock)
begin
 if rising_edge(clock) then
--  mem <= ram_do;
--	if ram_do = X"0" then mem_z <= '1'; else mem_z <= '0'; end if;
	irq_n_r <= irq_n;
	r_nf <= not irq_n;
	if irq_n = '0' and irq_n_r = '1' and r_pio(2) = '1' then
		interrupt_pending <= '1';
	end if;

  if reset = '1' then
		r_pc    <= (others=>'0');
		r_pa    <= (others=>'0');
		r_si    <= (others=>'0');
		r_a     <= (others=>'0');
		r_x     <= (others=>'0');
		r_y     <= (others=>'0');
		r_stf   <= '1';
		r_zf    <= '0';
		r_cf    <= '0';
		r_vf    <= '0';
		r_sf    <= '0';
		r_nf    <= '0';
		r_pio   <= (others=>'0');
		r_th    <= (others=>'0');
		r_tl    <= (others=>'0');
		r_tp    <= (others=>'0');
		r_ctr   <= (others=>'0');
		r_sb    <= (others=>'0');
		r_sbcnt <= (others=>'0');
		interrupt_pending <= '0';
		timer_interrupt_pending <= '0';
		r_in_irq <= '0';  -- MCU-INIRQ-FIX-2026-06-22
		irq_latched <= '0';  -- MCU-IRQPC-FIX-2026-07-09
		irq_is_ext  <= '0';  -- MCU-IRQPC-FIX-2026-07-09
		stack <= (others=>(others=>'0'));
		single_byte_op <= '1';
		-- MCU-R0RESET-FIX-2026-07-07: real MB8841 R-ports reset HIGH (MB8841.pdf Table 2, "Output Port
		-- Level During Reset" -- R0-R3 fixed high). r0_port_out had no reset assignment and powered up
		-- to 0 on the FPGA, which poisons the Z80's E039 boot-arm latch (kangaroo_cpu.dasm 0x00A9: reads
		-- R0 bit1 at boot, sets E039=0xFF "already fired" if bit1 reads 0 -- real HW reads 1 there and
		-- boots E039=0 "armed"). R0 only, not R1-R3: the MCU's own init loop already clears R1/R2, and
		-- resetting R3 high would drive R3.3 high (mcu_nmi_n=0, spurious boot NMI).
		r0_port_out <= (others=>'1');
 else
		tc_n_r <= tc_n;
		-- MCU-PRESC-FIX-2026-06-22: count INSTRUCTIONS (single_byte_op=1 = a new instruction; the 2nd byte of a
		-- 2-byte op has single_byte_op=0 and is NOT counted), /32 -> tmr_itick. Matches MAME's per-instruction m_TP.
		-- MCU-PRESC-FIX2-2026-07-06: superseded by the credit-based version below (see tmr_credit comment above
		-- for why a flat +1 undercounts 2-byte ops). Original (superseded) block, for reference:
		-- if ena = '1' and single_byte_op = '1' then
		--     if tmr_presc = "011111" then tmr_presc <= (others=>'0');
		--     else tmr_presc <= tmr_presc + 1; end if;
		-- end if;
		if (tmr_presc + tmr_credit) >= "100000" then
			tmr_presc <= (tmr_presc + tmr_credit) - "100000";
		else
			tmr_presc <= tmr_presc + tmr_credit;
		end if;
		if (tc_n = '0' and tc_n_r = '1' and r_pio(6) = '1') or
		   (tmr_itick = '1' and r_pio(7) = '1')
		then
			r_tl <= r_tl + 1;
			if r_tl = X"F" then
				r_th <= r_th + 1;
				if r_th = X"F" then
					if r_pio(1) = '1' then
						timer_interrupt_pending <= '1';
					end if;
					r_vf <= '1';
				end if;
			end if;
		end if;

		if ena = '1' then

			op_code <= rom_data;
  		single_byte_op <= '1';

			-- MCU-IRQPC-FIX-2026-07-09 (phase 2a): on the vector cycle the PC must NOT advance -- r_pa/r_pc
			-- already hold the resolved next PC, which is the address we are about to push as the return point.
			if irq_latched = '1' then
				null;
			elsif r_pc = "111111" then
				r_pc <= "000000";
				r_pa <= r_pa + "0001";
			else
				r_pc <= r_pc + "000001";
			end if;

			-- FIX-2026-07-02: interrupt acceptance runs AFTER the instruction dispatch below (was
			-- previously gating it: whenever an interrupt was pending, the just-fetched instruction was
			-- silently discarded and never executed at all). MAME's model (mb88xx.cpp burn_cycles) always
			-- finishes dispatching the fetched opcode via its switch statement, then separately redirects
			-- PC for the NEXT fetch if an interrupt is pending -- it never discards an already-fetched
			-- instruction. See the MCU-IRQATOMIC-FIX-2026-07-02 block after this if/else for the actual
			-- acceptance logic (moved further, and gated, to also fix a 2-byte-opcode race -- see that note).
			-- MCU-IRQPC-FIX-2026-07-09 (phase 2b): on the vector cycle the fetched byte must NOT be dispatched.
			-- It is the instruction we are deferring; rti will return to it and execute it exactly once.
			-- (We only ever latch at a complete-instruction boundary, so single_byte_op='1' here and the
			--  2nd-byte `else` arm below can never be reached while irq_latched='1'.)
			if irq_latched = '1' then
				null;
			elsif single_byte_op = '1' then
			  case rom_data is
					when X"00"  => r_stf <='1';                                         -- nop
					when X"01"  => r_stf <='1';                                         -- outO    portO <- A //!PLA todo
						if r_cf = '0' then ol_port_out <= r_a; end if;
						if r_cf = '1' then oh_port_out <= r_a; end if;
					when X"02"  => r_stf <='1'; p_port_out  <= r_a;                     -- outP    portP <-  A
					when X"03"  => r_stf <='1';                                         -- outR(Y) portR(Y) <- A
						-- NOTE: changed from Dar's implementation
						if r_y(1 downto 0) = "00" then r0_port_out <= r_a; end if;
						if r_y(1 downto 0) = "01" then r1_port_out <= r_a; end if;
						if r_y(1 downto 0) = "10" then r2_port_out <= r_a; end if;
						if r_y(1 downto 0) = "11" then r3_port_out <= r_a; end if;
					when X"04"  => r_stf <='1'; r_y  <= r_a;                            -- tay  Y <- A
					when X"05"  => r_stf <='1'; r_th <= r_a;                            -- tath TH <- A
					when X"06"  => r_stf <='1'; r_tl <= r_a;                            -- tatl TL <- A
					when X"07"  => r_stf <='1'; r_sb <= r_a;                            -- tas  SB <- A
					when X"08"  => r_stf <= not y_p1_c; r_y <= y_p1; r_zf <= y_p1_z;    -- icy  Y <- Y+1
					when X"09"  => r_stf <= not m_p1_c;              r_zf <= m_p1_z;	  -- icm	M[X,Y] <- M[X,Y]+1
					when X"0A"  => r_stf <= not y_p1_c; r_y <= y_p1; r_zf <= y_p1_z;    -- stic M[X,Y] <- A; Y <- Y+1
					when X"0B"  => r_stf <='1';         r_a <= mem;  r_zf <= mem_z;     -- x    A <- M[X,Y]; M[X,Y] <- A
					when X"0C"  => r_stf <= not r_a(3); r_a <= rola; r_zf <= rola_z; r_cf <= r_a(3); -- rol
					when X"0D"  => r_stf <='1';         r_a <= mem;  r_zf <= mem_z;                  -- l    A <- M[X,Y];
					when X"0E"  => r_stf <= not adc_c;  r_a <= adc(3 downto 0); r_zf <= adc_z; r_cf <= adc_c; -- adc    A <- M[X,Y]+A+CF;
					when X"0F"  => r_stf <= not a_and_m_z; r_a <= a_and_m;      r_zf <= a_and_m_z;            -- and    A <- A & M[X,Y];
					when X"10"  =>
					  if do_da = '1' then r_stf <= not daa_c; r_a <= daa;  r_cf <= daa_c;            -- daa    A <- A + 6 ; si A>9 or CF
					  else                r_stf <= '1';                    r_cf <= '0'; end if;
					when X"11"  =>
					  if do_da = '1' then r_stf <= not das_c; r_a <= das;  r_cf <= das_c;            -- das    A <- A + 10; si A>9 or CF
						else                r_stf <= '1';                    r_cf <= '0'; end if;
					when X"12"  => r_stf <='1'; r_a <= k_port_in; r_zf <= k_port_in_z;    -- inK   A <- K
					when X"13"  => r_stf <='1';                                           -- inR   A <- R(Y)
						-- NOTE: changed from Dar's implementation
						if r_y(1 downto 0) = "00" then r_a <= r0_port_in; r_zf <= r0_port_in_z; end if;
						if r_y(1 downto 0) = "01" then r_a <= r1_port_in; r_zf <= r1_port_in_z; end if;
						if r_y(1 downto 0) = "10" then r_a <= r2_port_in; r_zf <= r2_port_in_z; end if;
						if r_y(1 downto 0) = "11" then r_a <= r3_port_in; r_zf <= r3_port_in_z; end if;
					when X"14"  => r_stf <='1'; r_a <= r_y;  r_zf <= y_z;                  -- tya   A <- Y
					when X"15"  => r_stf <='1'; r_a <= r_th; r_zf <= th_z;                 -- ttha  A <- TH
					when X"16"  => r_stf <='1'; r_a <= r_tl; r_zf <= tl_z;                 -- ttla  A <- TH
					when X"17"  => r_stf <='1'; r_a <= r_sb; r_zf <= sb_z;                 -- tsa   A <- SB
					when X"18"  => r_stf <= not y_m1_c; r_y <= y_m1;                       -- dcy   Y <- Y-1
					when X"19"  => r_stf <= not m_m1_c; r_zf <= m_m1_z;                    -- dcm   M[X,Y] <- M[X,Y]-1
					when X"1A"  => r_stf <= not y_m1_c; r_y <= y_m1; r_zf <= y_m1_z;       -- stdc  M[X,Y] <- A; Y <- Y-1
					when X"1B"  => r_stf <='1'; r_a <= r_x; r_x <= r_a; r_zf <= x_z;       -- xx    A <- X, X <- A
					when X"1C"  => r_stf <= not r_a(0); r_a <= rora; r_zf <= rora_z; r_cf <= r_a(0); -- ror
					when X"1D"  => r_stf <='1';                                                      -- st    M[X,Y] <- A
					when X"1E"  => r_stf <= not sbc_c;  r_a <= sbc(3 downto 0); r_zf <= sbc_z; r_cf <= sbc_c; -- sbc   A <- M[X,Y]-A-CF;
					when X"1F"  => r_stf <= not a_or_m_z; r_a <= a_or_m;        r_zf <= a_or_m_z;             -- or    A <- A | M[X,Y];
					when X"20"  => r_stf <='1';                                            -- setR
						-- DIAG-REVERT-2026-07-06d reverted 2026-07-07: superseded by the real MCU-R0RESET-FIX
						-- (R0 now boots high like real silicon, see the reset branch above) -- the natural SETR
						-- re-arm path is needed again for repeat ape spawns, so the bit1 mask is removed.
						if r_y(3 downto 2) = "00" then r0_port_out <= (r0_port_in or sel_bit_y ); end if;
						if r_y(3 downto 2) = "01" then r1_port_out <= (r1_port_in or sel_bit_y ); end if;
						if r_y(3 downto 2) = "10" then r2_port_out <= (r2_port_in or sel_bit_y ); end if;
						if r_y(3 downto 2) = "11" then r3_port_out <= (r3_port_in or sel_bit_y ); end if;
					when X"21"  => r_stf <='1'; r_cf <= '1';                               -- setCF
					when X"22"  => r_stf <='1';                                            -- clrR
						-- DIAG-REVERT-2026-07-06c reverted 2026-07-07: superseded by the real MCU-R0RESET-FIX
						-- (R0 now boots high like real silicon) -- letting the natural K-port sweep drive this
						-- opcode again, rather than forcing an unconditional clear at 0x595.
						if r_y(3 downto 2) = "00" then r0_port_out <= (r0_port_in and not sel_bit_y ); end if;
						if r_y(3 downto 2) = "01" then r1_port_out <= (r1_port_in and not sel_bit_y ); end if;
						if r_y(3 downto 2) = "10" then r2_port_out <= (r2_port_in and not sel_bit_y ); end if;
						if r_y(3 downto 2) = "11" then r3_port_out <= (r3_port_in and not sel_bit_y ); end if;
					when X"23"  => r_stf <='1'; r_cf <= '0';                               -- clrCF
					when X"24"  =>                                                         -- tstR
						if r_y(3 downto 2) = "00" then r_stf <= not r0_port_in(to_integer(unsigned(r_y(1 downto 0)))); end if;
						if r_y(3 downto 2) = "01" then r_stf <= not r1_port_in(to_integer(unsigned(r_y(1 downto 0)))); end if;
						if r_y(3 downto 2) = "10" then r_stf <= not r2_port_in(to_integer(unsigned(r_y(1 downto 0)))); end if;
						if r_y(3 downto 2) = "11" then r_stf <= not r3_port_in(to_integer(unsigned(r_y(1 downto 0)))); end if;
					when X"25"  => r_stf <= not r_nf;                                         -- tsti (interrupt)
					when X"26"  => r_stf <= not r_vf;                                        -- tstv (timer overflow)
						-- MCU-TIMERVF-FIX-2026-06-22: keep a coincident overflow (don't clear r_vf if the timer overflows THIS cycle)
						if tmr_ovf = '0' then r_vf <= '0'; end if;
					when X"27"  => r_stf <= not r_sf; r_sf <= '0';                            -- tsts (serial)
					when X"28"  => r_stf <= not r_cf;                                         -- tstc (CF)
					when X"29"  => r_stf <= not r_zf;                                         -- tstz (ZF)
					when X"2A"  => r_stf <= '1'; r_zf <= sb_z;                                -- sts  M[X,Y] <- SB
					when X"2B"  => r_stf <= '1'; r_sb <= mem;  r_zf <= mem_z;                 -- ls   SB <- M[X,Y]
					when X"2C"  => r_stf <= '1';                                              -- rts
						r_pa <= stack(to_integer(unsigned(r_si-"01")))(10 downto 6);
						r_pc <= stack(to_integer(unsigned(r_si-"01")))( 5 downto 0);
						r_si <= r_si - "01";
					when X"2D"  => r_stf <= not nega_z; r_a <= nega;                         -- negA A <- -A
					when X"2E"  => r_stf <= not cma_z; r_zf <= cma_z; r_cf <= cma_c;         -- c    M[X,Y]-A ?=
					when X"2F"  => r_stf <= not a_xor_m_z; r_a <= a_xor_m; r_zf <= a_xor_m_z;-- eor  A <- A xor M[X,Y];
					when X"30" | X"31" | X"32" | X"33" => r_stf <='1';                       -- sbit M[X,Y](op&3) <- 1
					when X"34" | X"35" | X"36" | X"37" => r_stf <='1';                       -- rbit M[X,Y](op&3) <- 0
					when X"38" | X"39" | X"3A" | X"3B" => r_stf <= not m_tst_bit;            -- tbit M[X,Y](op&3) == 1
					when X"3C"  =>                                                           -- rti
						r_pa  <= stack(to_integer(unsigned(r_si-"01")))(10 downto 6);
						r_pc  <= stack(to_integer(unsigned(r_si-"01")))( 5 downto 0);
						r_stf <= stack(to_integer(unsigned(r_si-"01")))(11);
						r_zf  <= stack(to_integer(unsigned(r_si-"01")))(12);
						r_cf  <= stack(to_integer(unsigned(r_si-"01")))(13);
						r_in_irq <= '0';  -- MCU-INIRQ-FIX-2026-06-22: clear nested-IRQ guard on rti (MAME m_in_irq)
						r_si  <= r_si - "01";
					when X"3D" => single_byte_op <= '0';                                   -- jpa
					when X"3E" => single_byte_op <= '0';                                   -- en
					when X"3F" => single_byte_op <= '0';                                   -- dis
					when X"40" => r_stf <= '1'; r0_port_out <= (r0_port_in or X"1");       -- setd  RO(op&3) <-  1
					when X"41" => r_stf <= '1'; r0_port_out <= (r0_port_in or X"2");       -- setd  RO(op&3) <-  1
					when X"42" => r_stf <= '1'; r0_port_out <= (r0_port_in or X"4");       -- setd  RO(op&3) <-  1
					when X"43" => r_stf <= '1'; r0_port_out <= (r0_port_in or X"8");       -- setd  RO(op&3) <-  1
					when X"44" => r_stf <= '1'; r0_port_out <= (r0_port_in and not X"1");  -- setd  RO(op&3) <-  0
					when X"45" => r_stf <= '1'; r0_port_out <= (r0_port_in and not X"2");  -- setd  RO(op&3) <-  0
					when X"46" => r_stf <= '1'; r0_port_out <= (r0_port_in and not X"4");  -- setd  RO(op&3) <-  0
					when X"47" => r_stf <= '1'; r0_port_out <= (r0_port_in and not X"8");  -- setd  RO(op&3) <-  0
					when X"48" | X"49" | X"4A" | X"4B" =>                                  -- tstd  R2(op&3) ?=
						r_stf <= not r2_port_in(to_integer(unsigned(rom_data(1 downto 0))));
					when X"4C" | X"4D" | X"4E" | X"4F" =>                                  -- tba   A(op&3) ?=
						r_stf <= not r_a(to_integer(unsigned(rom_data(1 downto 0))));
					when X"50" | X"51" | X"52" | X"53" =>                                  -- xd   A <-> M[0,op&3]
						r_stf <= '1'; r_a <= mem; r_zf <= mem_z;
					when X"54" | X"55" | X"56" | X"57" =>                                  -- xyd  Y <-> M[0,op&3]
						r_stf <= '1'; r_y <= mem; r_zf <= mem_z;
					when X"58" | X"59" | X"5A" | X"5B" | X"5C" | X"5D" | X"5E" | X"5F" =>  -- lxi  imm (op&7)
						r_stf <='1'; r_x <= '0' & rom_data(2 downto 0); r_zf <= imm_x7_z;
					when X"60" | X"61" | X"62" | X"63" | X"64" | X"65" | X"66" | X"67" =>  -- call addr
						single_byte_op <= '0';
					when X"68" | X"69" | X"6A" | X"6B" | X"6C" | X"6D" | X"6E" | X"6F" =>  -- jpl  addr
						single_byte_op <= '0';
					when X"70" | X"71" | X"72" | X"73" | X"74" | X"75" | X"76" | X"77" |
					     X"78" | X"79" | X"7A" | X"7B" | X"7C" | X"7D" | X"7E" | X"7F" =>  -- ai   A <- A+imm (op&F)
						r_stf <= not a_pim_c; r_a <= a_pim(3 downto 0); r_zf <= a_pim_z; r_cf <= a_pim_c;
					when X"80" | X"81" | X"82" | X"83" | X"84" | X"85" | X"86" | X"87" |
					     X"88" | X"89" | X"8A" | X"8B" | X"8C" | X"8D" | X"8E" | X"8F" =>  -- lyi  Y <- imm (op&F)
						r_stf <='1'; r_y <= rom_data(3 downto 0); r_zf <= imm_xF_z;
					when X"90" | X"91" | X"92" | X"93" | X"94" | X"95" | X"96" | X"97" |
					     X"98" | X"99" | X"9A" | X"9B" | X"9C" | X"9D" | X"9E" | X"9F" =>  -- li   A <- imm (op&F)
						r_stf <='1'; r_a <= rom_data(3 downto 0); r_zf <= imm_xF_z;
					when X"A0" | X"A1" | X"A2" | X"A3" | X"A4" | X"A5" | X"A6" | X"A7" |
					     X"A8" | X"A9" | X"AA" | X"AB" | X"AC" | X"AD" | X"AE" | X"AF" =>  -- cyi  imm - Y ?=
						r_stf <= not im_my_z; r_zf <= im_my_z; r_cf <= im_my_c;
					when X"B0" | X"B1" | X"B2" | X"B3" | X"B4" | X"B5" | X"B6" | X"B7" |
					     X"B8" | X"B9" | X"BA" | X"BB" | X"BC" | X"BD" | X"BE" | X"BF" =>  -- ci   imm - A ?=
						r_stf <= not im_ma_z; r_zf <= im_ma_z; r_cf <= im_ma_c;
					when others  => r_stf <='1';                                           -- jmp addr if ST  (op_code C0..FF)
						 if r_stf = '1' then r_pc <= rom_data(5 downto 0); end if; -- (let r_pa be incremented when r_pc = 0x3F)
				end case;
			else -- 2 bytes op_code, rom_data = 2nd byte
			  case op_code is
					when X"3D"  => r_stf <='1'; r_pa  <= rom_data(4 downto 0); r_pc <= r_a & "00";  -- jpa  PA <- data&0x1f; PC <- A*4
					when X"3E"  => r_stf <='1'; r_pio <= r_pio or  rom_data;                        -- en   PIO <- PIO or imm data
					when X"3F"  => r_stf <='1'; r_pio <= r_pio and not rom_data;                        -- dis  PIO <- PIO and not imm data
					when X"60" | X"61" | X"62" | X"63" | X"64" | X"65" | X"66" | X"67" =>           -- call addr if ST
						r_stf <= '1';
						if r_stf = '1' then
							stack(to_integer(unsigned(r_si)))(10 downto 0) <= (r_pa & r_pc) + '1';
							r_pc <= rom_data(5 downto 0);
							r_pa <= op_code(2 downto 0) & rom_data(7 downto 6);
							r_si <= r_si + "01";
						end if;
					when X"68" | X"69" | X"6A" | X"6B" | X"6C" | X"6D" | X"6E" | X"6F" =>           -- jpl if ST
						r_stf <= '1';
						if r_stf = '1' then
							r_pc <= rom_data(5 downto 0);
							r_pa <= op_code(2 downto 0) & rom_data(7 downto 6);
						end if;
					when others => r_stf <='1';
				end case;
			end if;

			-- MCU-IRQATOMIC-FIX-2026-07-02: interrupt acceptance moved to run ONCE, after the complete
			-- if/else above (i.e. after a full instruction -- both bytes, for CALL/JPL/JPA/EN/DIS --
			-- has been dispatched), and explicitly deferred when THIS cycle just decoded the FIRST byte
			-- of one of those 2-byte opcodes. Previously (FIX-2026-07-02, now superseded) the check ran
			-- unconditionally inside the single_byte_op='1' branch, which ALSO covers the cycle where a
			-- 2-byte opcode's first byte is recognized (single_byte_op is set '0' for next cycle, but the
			-- interrupt check ran on THIS cycle regardless). If an interrupt was pending at that exact
			-- moment, r_pc got redirected to the interrupt vector for the NEXT fetch -- but single_byte_op
			-- was ALREADY latched '0', so the NEXT cycle wrongly decoded whatever byte sits at the
			-- interrupt vector as if it were the 2nd byte of the CALL/JPL/JPA/EN/DIS, using the stale
			-- op_code register -- producing a garbage jump/call target unrelated to either the intended
			-- instruction or the interrupt. MAME's model (mb88xx.cpp execute_run/burn_cycles) fetches BOTH
			-- bytes of a 2-byte opcode inline within one atomic switch-case iteration and only checks
			-- interrupts once per COMPLETE instruction, never in between -- this fix matches that.
			-- MCU-IRQPC-FIX-2026-07-09 (phase 2 of 2): the push + vector. Deliberately OUTSIDE the 2-byte-opcode
			-- guard below: the deferred instruction may itself be a CALL/JPL/JPA, and skipping this block would
			-- deadlock (2a/2b hold the PC and suppress dispatch forever). Because 2a/2b suppressed the increment
			-- and the dispatch, r_pa/r_pc still hold the RESOLVED next PC (post-jump/call/rts) and r_cf/r_zf/r_stf
			-- still hold the POST-instruction flags -- exactly the frame MAME pushes at mb88xx.cpp:453-459.
			if irq_latched = '1' then
				irq_latched <= '0';
				r_in_irq    <= '1';  -- MCU-INIRQ-FIX-2026-06-22: nested-IRQ guard (MAME m_in_irq)
				stack(to_integer(unsigned(r_si)))(13 downto 0) <= (r_cf & r_zf & r_stf & r_pa & r_pc);
				-- MCU-IRQVEC-FIX-2026-06-22: MAME mb88xx.cpp:462-470 vectors EXTERNAL irq->0x02, TIMER irq->0x04.
				if irq_is_ext = '1' then r_pc <= "000010"; else r_pc <= "000100"; end if;
				r_pa <= "00000";
				r_si <= r_si + "01";
				-- MCU-IRQST-FIX-2026-07-09: MAME mb88xx.cpp:479 forces ST=1 on interrupt entry. ST is the BRANCH-
				-- ENABLE flag, not a generic skip: JMP/JPL/CALL execute only when ST=1. Both vectors are branches
				-- (0x004: JPL $0039 timer, 0x006: JPL $0710 serial), so entering an ISR with a stale ST='0' --
				-- which happens after every matching TSTZ/CI/CYI and every carrying ICM/ICY/AI, i.e. constantly
				-- in the protrom loop -- leaves the vector's JPL untaken and PC falls through 0x006 into 0x008,
				-- the boot/init code, executed inside an interrupt. The old ST is saved on the stack above
				-- (bit 11) and restored by rti.
				r_stf <= '1';
			end if;

			if not (single_byte_op = '1' and
			        (rom_data = X"3D" or rom_data = X"3E" or rom_data = X"3F" or
			         (rom_data >= X"60" and rom_data <= X"6F"))) then
				-- MCU-IRQPC-FIX-2026-07-09 (phase 1 of 2): LATCH ONLY. The instruction fetched this cycle is
				-- allowed to complete normally; the push + vector happen on the NEXT ena cycle (phase 2, just
				-- above this guard). The original immediate-vector body is kept commented out below -- to
				-- revert, uncomment it, delete the phase-2 block and phases 2a/2b, and drop irq_latched/irq_is_ext.
				if (interrupt_pending = '1' or timer_interrupt_pending = '1')
				   and r_in_irq = '0' and irq_latched = '0' then
					irq_latched <= '1';
					irq_is_ext  <= interrupt_pending;   -- MAME priority: external (0x02) before timer (0x04)
					if interrupt_pending = '1' then
						interrupt_pending <= '0';
					elsif timer_interrupt_pending = '1' then
						timer_interrupt_pending <= '0';
					end if;
				end if;
				-- ORIGINAL (immediate vector). This pushed r_pa/r_pc and r_cf/r_zf/r_stf as read PRE-edge, i.e.
				-- the address of the instruction that was executing and the flags from before it ran. rti then
				-- returned to that instruction and re-executed it, applying its A/X/Y/RAM side effects twice.
				-- if (interrupt_pending = '1' or timer_interrupt_pending = '1') and r_in_irq = '0' then
				--     r_in_irq <= '1';  -- MCU-INIRQ-FIX-2026-06-22: nested-IRQ guard (MAME m_in_irq)
				--     stack(to_integer(unsigned(r_si)))(13 downto 0) <= (r_cf & r_zf & r_stf & r_pa & r_pc);
				--     -- MCU-IRQVEC-FIX-2026-06-22: MAME mb88xx.cpp:462-470: EXTERNAL irq->0x02, TIMER irq->0x04.
				--     if interrupt_pending = '1' then r_pc <= "000010"; else r_pc <= "000100"; end if;
				--     r_pa <= "00000";
				--     r_si <= r_si + "01";
				--     if interrupt_pending = '1' then interrupt_pending <= '0';
				--     elsif timer_interrupt_pending = '1' then timer_interrupt_pending <= '0'; end if;
				-- end if;
			end if;

		end if;
	end if;
 end if;
end process;

-- RAM
-- MCU-M43-FIX-2026-07-02: writes to internal RAM 0x43 (M[4,3], the kangaroo ape-timer's protrom/K-port
-- gate selector) were measured landing as 0x2 on real HW, every time, across ~91 writes in a full
-- playthrough -- while the real MAME execution (both from full-ROM disassembly enumeration of every
-- static writer AND a live MAME watchpoint across 3+ real ape-spawn cycles, ~100 writes) confirms this
-- cell is written ONLY the literal value 0x1, never anything else. M[4,3]==0x2 diverts a recurring poll
-- (0x17A/0x13E in the MCU ROM) into the one branch that never clears port R3 bit0, permanently closing
-- the protrom->K-port gate -- which freezes the K-port-driven task dispatcher (RAM[0x40]) on a no-op task,
-- which is why the ape-timer task never runs. The exact VHDL-level mechanism producing 0x2 instead of 0x1
-- wasn't pinned down (suspected stale-accumulator capture in the tight LYI/LI/ST write burst at this ROM
-- address), but the correct value is unambiguous and exhaustively confirmed on the real hardware/software
-- reference (MAME) -- so force it directly at the one address in question, independent of the timing bug.
-- MCU-M43-FIX-2026-07-02 REMOVED 2026-07-08: ROOT CAUSE of the MCU foreground hang. HW proof (Diagnostic 12):
-- the protrom-protocol debounce STORES M[4,3] (ram_addr=0x43=E1C5) with its real value (E1C7[3:0]=0xF, write
-- enabled E1C7[5]=1) then reads it back to compare -- but this force-override stomped EVERY write to 0x43 to
-- "0001", so the readback (E1C4=0x1) never matched the stored value -> the debounce looped forever -> the
-- whole MCU foreground died -> no dispatcher -> no ape. The 2026-07-02 premise ("M[4,3] must always be 0x1,
-- 0x2 is a bug") was a MISDIAGNOSIS: 0x2 is a legitimate value the MCU writes there as part of the protrom
-- handshake; forcing it broke that handshake. Restored the normal, unconditional write. Original (buggy)
-- force block kept commented below per the diagnostic-revert convention.
--   if ram_we = '1' then
--     if ram_addr = "1000011" then ram(...) <= "0001";   -- <== the sabotage
--     else                         ram(...) <= ram_di;
--     end if;
--   end if;
process(clock_n)
begin
	if rising_edge(clock_n) then
		if ram_we = '1' then
			ram(to_integer(unsigned(ram_addr))) <= ram_di;
		end if;
	end if;
end process;

ram_do <= ram(to_integer(unsigned(ram_addr)));

-- DIAG-REVERT-2026-07-06g: read-only, fixed-address taps -- M[4,1]="1000001", M[4,2]="1000010".
-- Separate from the CPU's own ram_addr/ram_do path, doesn't touch it.
dbg_ram41_do <= ram(to_integer(unsigned'("1000001")));
dbg_ram42_do <= ram(to_integer(unsigned'("1000010")));
-- DIAG-REVERT-2026-07-08: readback-hazard taps (see port comment)
dbg_mem_do   <= mem;
dbg_ramdo_do <= ram_do;
-- DIAG-REVERT-2026-07-08b: live RAM address + write data
dbg_ramaddr_do <= ram_addr;
dbg_ramdi_do   <= ram_di;
dbg_ramwe_do   <= ram_we;
-- DIAG-REVERT-2026-07-09-RING: foreground instruction-boundary markers (read-only, see port comment)
dbg_sbo_do   <= single_byte_op;
dbg_inirq_do <= r_in_irq;

-- DIAG-REVERT-2026-07-10-M7BUF: read-only view of bank 7 (ram 0x70-0x7F), nibble n at bits [4n+3 : 4n].
m7buf: for i in 0 to 15 generate
  dbg_m7_do(4*i+3 downto 4*i) <= ram(112 + i);   -- 112 = 0x70
end generate;

end struct;
