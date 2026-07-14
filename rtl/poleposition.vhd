---------------------------------------------------------------------------------
-- Pole Position (adapted from Xevious) by Dar (darfpga@aol.fr)
-- http://darfpga.blogspot.fr
---------------------------------------------------------------------------------
-- 2026-07-13 STEP-3 GUT: the Xevious 3-Z80 muxed-bus CPU section + the entire
-- Xevious video pipeline (fg/bg/sprite fetch, palettes, terrain, sound_machine,
-- mb88 5xxx) were REMOVED and replaced by PolePosition_CPU (Z80 + 2x Z8002 +
-- shared VRAM) driving the pp_alpha_bringup renderer. Only gen_video (H/V timing)
-- + the free-running pixel-slot machine (ena_vidgen) survive from the original.
-- Old code is recoverable from git. Sound / view / sprites / road / palette / the
-- Namco 5xxx I/O bus are NOT wired yet (this increment = real alpha content only).
---------------------------------------------------------------------------------
-- Educational use only. Do not redistribute synthetized file with roms.
---------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity poleposition is
port(
 clock_18       : in std_logic;
 reset          : in std_logic;

 dn_addr        : in  std_logic_vector(16 downto 0);
 dn_data        : in  std_logic_vector(7 downto 0);
 dn_wr          : in  std_logic;

 -- INCR-1a (DIAG-REVERT-2026-07-13): chars (alpha) gfx ROM interface. The ROM
 -- lives in the top (loaded at ioctl index 1); the alpha renderer here drives addr.
 gfx_addr       : out std_logic_vector(11 downto 0);
 gfx_data       : in  std_logic_vector(7 downto 0);

 -- alpha palette PROM load (ioctl index 2, 0x000-0x3FF = R/G/B/alpha tables)
 prom_wr        : in  std_logic;
 prom_addr      : in  std_logic_vector(9 downto 0);
 prom_data      : in  std_logic_vector(7 downto 0);

 video_r        : out std_logic_vector(3 downto 0);
 video_g        : out std_logic_vector(3 downto 0);
 video_b        : out std_logic_vector(3 downto 0);
 video_csync    : out std_logic;
 video_blankn   : out std_logic;
 video_hs       : out std_logic;
 video_vs       : out std_logic;
 video_en       : out std_logic;

 blank_h        : out std_logic;
 blank_v        : out std_logic;

 dip_switch_a   : in std_logic_vector (7 downto 0);
 dip_switch_b   : in std_logic_vector (7 downto 0);

 flip           : in std_logic;
 h_offset	: in signed(3 downto 0);
 v_offset	: in signed(3 downto 0);
 test_v         : in std_logic_vector (3 downto 0);

 audio          : out std_logic_vector(15 downto 0);

 self_test      : in std_logic;
 service        : in std_logic;
 coin1          : in std_logic;

 start1         : in std_logic;
 fire1          : in std_logic;
 up1            : in std_logic;
 down1          : in std_logic;
 left1          : in std_logic;
 right1         : in std_logic;

 coin2          : in std_logic;
 start2         : in std_logic;
 up2            : in std_logic;
 down2          : in std_logic;
 left2          : in std_logic;
 right2         : in std_logic;
 fire2          : in std_logic;

 pause          : in std_logic;

 -- STEP-3b-2: Namco 06xx bus + 51xx/53xx I/O MCU wiring. steer_in is a raw
 -- 8-bit dial reading (MAME m_steer_io->read()); Arcade-PolePosition.sv has
 -- no real spinner/analog input wired yet, so it currently feeds a digital
 -- left/right placeholder counter (see that file). mcu_rom_* loads the mb88
 -- internal ROMs (ioctl index 6: 51xx@0x000 53xx@0x400 54xx@0x800, each
 -- 0x400) -- mirrors the chars_rom/pp_prom load pattern in the top file.
 steer_in       : in  std_logic_vector(7 downto 0);
 mcu_rom_wr     : in  std_logic;
 mcu_rom_addr   : in  std_logic_vector(11 downto 0);
 mcu_rom_data   : in  std_logic_vector(7 downto 0);

 hs_address     : in  std_logic_vector(10 downto 0);
 hs_data_out    : out std_logic_vector(7 downto 0);
 hs_data_in     : in  std_logic_vector(7 downto 0);
 hs_write       : in std_logic
 );
end poleposition;

architecture struct of poleposition is

 signal reset_n     : std_logic;
 signal clock_18n   : std_logic;

 signal slot        : std_logic_vector(2 downto 0);
 signal slot24      : std_logic_vector(4 downto 0);
 signal ena_vidgen  : std_logic;

 signal hcnt        : std_logic_vector(8 downto 0);
 signal vcnt        : std_logic_vector(8 downto 0);
 signal vblank      : std_logic;

 signal bru_r, bru_g, bru_b : std_logic_vector(3 downto 0);

 -- Z80/Z8002 clock enable = clock_18 /16
 signal cen_cnt     : std_logic_vector(3 downto 0);
 signal cen         : std_logic;

 -- alpha scanout (renderer <-> PolePosition_CPU)
 signal bru_scan_addr   : std_logic_vector(10 downto 0);
 signal alpha_scan_dout : std_logic_vector(15 downto 0);

 -- CPU ROM-load derives from the index-0 dn_ stream
 signal cpu_rom_wr    : std_logic;
 signal cpu_ioctl_addr: std_logic_vector(24 downto 0);

 -- zero tie-offs for unwired CPU inputs
 signal zero8  : std_logic_vector(7 downto 0);
 signal zero10 : std_logic_vector(9 downto 0);
 signal zero11 : std_logic_vector(10 downto 0);

 -- STEP-3b-2: Namco 06xx bus + 51xx/53xx (rtl/namco_06xx.sv, namco_51xx.sv,
 -- namco_53xx.sv). u_pp_cpu's n06_* ports were open/zero8 tie-offs; now real.
 signal n06_dout_w     : std_logic_vector(7 downto 0);
 signal n06_data_wr_w  : std_logic;
 signal n06_data_rd_w  : std_logic;
 signal n06_ctrl_wr_w  : std_logic;
 signal n06_ctrl_rd_w  : std_logic;
 signal n06_din_w      : std_logic_vector(7 downto 0);
 signal n06_nmi_n_w    : std_logic;

 signal sb0_w          : std_logic;                     -- LS259 q6 (auto_start_mask = not sb0)
 signal namco_reset_w  : std_logic;                     -- LS259 q1 (51xx/53xx/54xx reset, MAME reset(state))
 signal mcu_reset_n    : std_logic;                     -- = not reset AND namco_reset_w

 signal n06_chipsel    : std_logic_vector(3 downto 0);
 signal n06_rw0        : std_logic;
 signal n06_chip_dout  : std_logic_vector(7 downto 0);
 signal n06_chip_wr    : std_logic_vector(3 downto 0);
 signal chip0_din      : std_logic_vector(7 downto 0);   -- 51xx read() -> 06xx data_r
 signal chip1_din      : std_logic_vector(7 downto 0);   -- 53xx read() -> 06xx data_r
 signal chip23_din     : std_logic_vector(7 downto 0);   -- 52xx/54xx unbuilt: reads as 0xFF (MAME devcb default)

 -- IN0 (MAME polepos.cpp PORT_START("IN0"), z80_map via 51xx input<2>/<3>):
 --   bit7=self_test bit6=service1 bit5=coin2 bit4=coin1 bit3=unused
 --   bit2=auto_start(=not sb0, program-controlled, NOT a physical input)
 --   bit1=Gear Change (BUTTON3; fire1 repurposed -- was dead in this Namco
 --        scaffold, no accel/brake/gear ports exist yet at the top level)
 --   bit0=unused
 signal in0_byte       : std_logic_vector(7 downto 0);

 -- Namco 5xxx MCU clock enable = clock_18/32 = 1.536 MHz (MAME MASTER_CLOCK/8/2),
 -- derived from the existing cen (clock_18/16, the Z80/Z8002 CE) by toggling once
 -- more per cen pulse.
 signal mcu_div : std_logic := '0';
 signal mcu_ena : std_logic;

 component namco_06xx
 port(
   clk        : in  std_logic;
   reset      : in  std_logic;
   pause      : in  std_logic;
   cpu_dout   : in  std_logic_vector(7 downto 0);
   data_wr    : in  std_logic;
   data_rd    : in  std_logic;
   ctrl_wr    : in  std_logic;
   ctrl_rd    : in  std_logic;
   cpu_din    : out std_logic_vector(7 downto 0);
   nmi_n      : out std_logic;
   chipsel    : out std_logic_vector(3 downto 0);
   rw0        : out std_logic;
   chip0_din  : in  std_logic_vector(7 downto 0);
   chip1_din  : in  std_logic_vector(7 downto 0);
   chip2_din  : in  std_logic_vector(7 downto 0);
   chip3_din  : in  std_logic_vector(7 downto 0);
   chip_dout  : out std_logic_vector(7 downto 0);
   chip_wr    : out std_logic_vector(3 downto 0)
 );
 end component;

 component namco_51xx
 port(
   clk          : in  std_logic;
   ena          : in  std_logic;
   reset_n      : in  std_logic;
   chip_sel     : in  std_logic;
   rw_in        : in  std_logic;
   data_out     : out std_logic_vector(7 downto 0);
   wr_en        : in  std_logic;
   wr_data      : in  std_logic_vector(7 downto 0);
   dswb         : in  std_logic_vector(7 downto 0);
   in0          : in  std_logic_vector(7 downto 0);
   p_port_out   : out std_logic_vector(3 downto 0);
   rom_wr       : in  std_logic;
   rom_addr_in  : in  std_logic_vector(11 downto 0);
   rom_data_in  : in  std_logic_vector(7 downto 0)
 );
 end component;

 component namco_53xx
 port(
   clk          : in  std_logic;
   ena          : in  std_logic;
   reset_n      : in  std_logic;
   chip_sel     : in  std_logic;
   data_out     : out std_logic_vector(7 downto 0);
   dswa         : in  std_logic_vector(7 downto 0);
   steer_in     : in  std_logic_vector(7 downto 0);
   rom_wr       : in  std_logic;
   rom_addr_in  : in  std_logic_vector(11 downto 0);
   rom_data_in  : in  std_logic_vector(7 downto 0)
 );
 end component;

 component pp_alpha_bringup
 port(
   clk      : in  std_logic;
   ce       : in  std_logic;
   hpos     : in  std_logic_vector(8 downto 0);
   vpos     : in  std_logic_vector(8 downto 0);
   gfx_addr : out std_logic_vector(11 downto 0);
   gfx_data : in  std_logic_vector(7 downto 0);
   scan_addr: out std_logic_vector(10 downto 0);
   scan_dout: in  std_logic_vector(15 downto 0);
   prom_wr  : in  std_logic;
   prom_addr: in  std_logic_vector(9 downto 0);
   prom_data: in  std_logic_vector(7 downto 0);
   r        : out std_logic_vector(3 downto 0);
   g        : out std_logic_vector(3 downto 0);
   b        : out std_logic_vector(3 downto 0)
 );
 end component;

 component PolePosition_CPU
 port(
   clk              : in  std_logic;
   cen              : in  std_logic;
   reset            : in  std_logic;
   pause            : in  std_logic;
   vpos             : in  std_logic_vector(8 downto 0);
   sub1_reset_n     : out std_logic;
   sub2_reset_n     : out std_logic;
   namco_reset      : out std_logic;
   sound_en         : out std_logic;
   gasel            : out std_logic;
   sb0              : out std_logic;
   chacl            : out std_logic;
   sub_nvi_trig     : out std_logic;
   vram_addr        : out std_logic_vector(12 downto 0);
   vram_dout        : out std_logic_vector(7 downto 0);
   vram_wr          : out std_logic;
   vram_rd          : out std_logic;
   vram_din         : in  std_logic_vector(7 downto 0);
   n06_dout         : out std_logic_vector(7 downto 0);
   n06_data_wr      : out std_logic;
   n06_data_rd      : out std_logic;
   n06_ctrl_wr      : out std_logic;
   n06_ctrl_rd      : out std_logic;
   n06_din          : in  std_logic_vector(7 downto 0);
   n06_nmi_n        : in  std_logic;
   wsg_addr         : out std_logic_vector(5 downto 0);
   wsg_dout         : out std_logic_vector(7 downto 0);
   wsg_wr           : out std_logic;
   wsg_rd           : out std_logic;
   wsg_din          : in  std_logic_vector(7 downto 0);
   engine_dout      : out std_logic_vector(7 downto 0);
   engine_lsb_wr    : out std_logic;
   engine_msb_wr    : out std_logic;
   adc_wr           : out std_logic;
   adc_rd           : out std_logic;
   adc_din          : in  std_logic_vector(7 downto 0);
   adc_intr_n       : in  std_logic;
   watchdog_wr      : out std_logic;
   ioctl_addr       : in  std_logic_vector(24 downto 0);
   ioctl_data       : in  std_logic_vector(7 downto 0);
   rom_wr           : in  std_logic;
   ioctl_wr_idx0    : in  std_logic;
   scan_sprite_addr : in  std_logic_vector(10 downto 0);
   scan_sprite_dout : out std_logic_vector(15 downto 0);
   scan_road_addr   : in  std_logic_vector(9 downto 0);
   scan_road_dout   : out std_logic_vector(15 downto 0);
   scan_alpha_addr  : in  std_logic_vector(9 downto 0);
   scan_alpha_dout  : out std_logic_vector(15 downto 0);
   scan_view_addr   : in  std_logic_vector(10 downto 0);
   scan_view_dout   : out std_logic_vector(15 downto 0);
   hscroll          : out std_logic_vector(15 downto 0);
   vscroll          : out std_logic_vector(15 downto 0)
 );
 end component;

begin

reset_n    <= not reset;
clock_18n  <= not clock_18;

zero8  <= (others => '0');
zero10 <= (others => '0');
zero11 <= (others => '0');

blank_v      <= vblank;
video_en     <= ena_vidgen;
audio        <= (others => '0');
hs_data_out  <= (others => '0');

cpu_ioctl_addr <= "00000000" & dn_addr;
cpu_rom_wr     <= dn_wr when dn_addr(16 downto 12) < "00011" else '0';  -- maincpu region < 0x3000

-- Z80 / Z8002 clock enable = clock_18 /16
process (clock_18)
begin
	if rising_edge(clock_18) then
		cen_cnt <= cen_cnt + "0001";
	end if;
end process;
cen <= '1' when cen_cnt = "0000" else '0';

-- free-running pixel-slot machine (unchanged from Xevious): generates ena_vidgen
-- that gen_video + the renderer step on. slot self-syncs to hcnt.
process (clock_18, hcnt)
begin
	if rising_edge(clock_18) then
		slot24  <= slot24 + "00001";
		slot    <= slot + "001";
		if slot = "101" then
			if (hcnt(2 downto 0) = "111") then slot24 <= (others=>'0'); end if;
			if (hcnt(0) = '1') then slot <= "000"; else slot <= "011"; end if;
		end if;
	end if;
end process;

process (clock_18)
begin
	if rising_edge(clock_18) then
		ena_vidgen <= '0';
		if slot = "100" or slot = "001" then ena_vidgen <= '1'; end if;
	end if;
end process;

-- H/V sync + counters (reused as-is; 384x264 Namco-family timing)
gen_video : entity work.gen_video
port map(
	clk      => clock_18,
	enable   => ena_vidgen,
	hcnt     => hcnt,
	vcnt     => vcnt,
	hsync    => video_hs,
	vsync    => video_vs,
	csync    => video_csync,
	blank_h  => blank_h,
	blank_v  => vblank,
	blankn   => video_blankn,
	h_offset => h_offset,
	v_offset => v_offset
);

-- alpha (text) renderer: reads the REAL scan_alpha buffer from PolePosition_CPU;
-- gfx from the top-side chars ROM; raw {color,pixel,bank}->RGB (palette = incr 1b).
u_alpha_bringup : pp_alpha_bringup
port map(
	clk      => clock_18,
	ce       => ena_vidgen,
	hpos     => hcnt,
	vpos     => vcnt,
	gfx_addr => gfx_addr,
	gfx_data => gfx_data,
	scan_addr=> bru_scan_addr,
	scan_dout=> alpha_scan_dout,
	prom_wr  => prom_wr,
	prom_addr=> prom_addr,
	prom_data=> prom_data,
	r        => bru_r,
	g        => bru_g,
	b        => bru_b
);

-- CPU subsystem: Z80 maincpu + 2x Z8002 game CPUs + shared VRAM. Its Z8002s
-- write the alpha buffer during attract -> real text. Sound/IO/06xx tied off.
u_pp_cpu : PolePosition_CPU
port map(
	clk              => clock_18,
	cen              => cen,
	reset            => reset,
	pause            => pause,
	vpos             => vcnt,
	sub1_reset_n     => open,
	sub2_reset_n     => open,
	namco_reset      => namco_reset_w,
	sound_en         => open,
	gasel            => open,
	sb0              => sb0_w,
	chacl            => open,
	sub_nvi_trig     => open,
	vram_addr        => open,
	vram_dout        => open,
	vram_wr          => open,
	vram_rd          => open,
	vram_din         => zero8,
	n06_dout         => n06_dout_w,
	n06_data_wr      => n06_data_wr_w,
	n06_data_rd      => n06_data_rd_w,
	n06_ctrl_wr      => n06_ctrl_wr_w,
	n06_ctrl_rd      => n06_ctrl_rd_w,
	n06_din          => n06_din_w,
	n06_nmi_n        => n06_nmi_n_w,
	wsg_addr         => open,
	wsg_dout         => open,
	wsg_wr           => open,
	wsg_rd           => open,
	wsg_din          => zero8,
	engine_dout      => open,
	engine_lsb_wr    => open,
	engine_msb_wr    => open,
	adc_wr           => open,
	adc_rd           => open,
	adc_din          => zero8,
	adc_intr_n       => '1',
	watchdog_wr      => open,
	ioctl_addr       => cpu_ioctl_addr,
	ioctl_data       => dn_data,
	rom_wr           => cpu_rom_wr,
	ioctl_wr_idx0    => dn_wr,
	scan_sprite_addr => zero11,
	scan_sprite_dout => open,
	scan_road_addr   => zero10,
	scan_road_dout   => open,
	scan_alpha_addr  => bru_scan_addr(9 downto 0),
	scan_alpha_dout  => alpha_scan_dout,
	scan_view_addr   => zero11,
	scan_view_dout   => open,
	hscroll          => open,
	vscroll          => open
);

-- ---- Namco 5xxx MCU clock enable (see signal declaration comment) ----------
process (clock_18)
begin
	if rising_edge(clock_18) then
		if cen = '1' then
			mcu_div <= not mcu_div;
		end if;
	end if;
end process;
mcu_ena <= cen and mcu_div and (not pause);

-- MCUs held in reset by EITHER the system reset OR the LS259 namco_reset latch
-- (q1, MAME reset(state) -- active-high "running", power-on default = held reset).
mcu_reset_n <= (not reset) and namco_reset_w;

-- IN0 (MAME PORT_START("IN0"), z80_map via the 51xx's input<2>/<3> nibbles).
-- All physical bits are IP_ACTIVE_LOW; bit2 (auto_start) is program-controlled
-- (sb0_w from the LS259, NOT a physical input); bit1 (Gear Change) repurposes
-- fire1 (dead in this Namco scaffold otherwise); bits 3/0 are MAME IPT_UNUSED.
in0_byte <= (not self_test) & (not service) & (not coin2) & (not coin1)
            & '1' & (not sb0_w) & (not fire1) & '1';

-- 52xx/54xx are not built this phase; their 06xx read lines return 0xFF,
-- matching MAME's devcb_read8 unbound-callback default.
chip23_din <= (others => '1');

u_n06xx : namco_06xx
port map(
	clk       => clock_18,
	reset     => reset,
	pause     => pause,
	cpu_dout  => n06_dout_w,
	data_wr   => n06_data_wr_w,
	data_rd   => n06_data_rd_w,
	ctrl_wr   => n06_ctrl_wr_w,
	ctrl_rd   => n06_ctrl_rd_w,
	cpu_din   => n06_din_w,
	nmi_n     => n06_nmi_n_w,
	chipsel   => n06_chipsel,
	rw0       => n06_rw0,
	chip0_din => chip0_din,
	chip1_din => chip1_din,
	chip2_din => chip23_din,
	chip3_din => chip23_din,
	chip_dout => n06_chip_dout,
	chip_wr   => n06_chip_wr
);

u_n51xx : namco_51xx
port map(
	clk         => clock_18,
	ena         => mcu_ena,
	reset_n     => mcu_reset_n,
	chip_sel    => n06_chipsel(0),
	rw_in       => n06_rw0,
	data_out    => chip0_din,
	wr_en       => n06_chip_wr(0),
	wr_data     => n06_chip_dout,
	dswb        => dip_switch_b,
	in0         => in0_byte,
	p_port_out  => open,
	rom_wr      => mcu_rom_wr,
	rom_addr_in => mcu_rom_addr,
	rom_data_in => mcu_rom_data
);

u_n53xx : namco_53xx
port map(
	clk         => clock_18,
	ena         => mcu_ena,
	reset_n     => mcu_reset_n,
	chip_sel    => n06_chipsel(1),
	data_out    => chip1_din,
	dswa        => dip_switch_a,
	steer_in    => steer_in,
	rom_wr      => mcu_rom_wr,
	rom_addr_in => mcu_rom_addr,
	rom_data_in => mcu_rom_data
);

-- video output register (bring-up RGB -> DAC; original palette path removed)
process (clock_18)
begin
	if rising_edge(clock_18) then
		video_r <= bru_r;
		video_g <= bru_g;
		video_b <= bru_b;
	end if;
end process;

end struct;
