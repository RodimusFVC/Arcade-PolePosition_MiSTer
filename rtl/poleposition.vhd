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
	namco_reset      => open,
	sound_en         => open,
	gasel            => open,
	sb0              => open,
	chacl            => open,
	sub_nvi_trig     => open,
	vram_addr        => open,
	vram_dout        => open,
	vram_wr          => open,
	vram_rd          => open,
	vram_din         => zero8,
	n06_dout         => open,
	n06_data_wr      => open,
	n06_data_rd      => open,
	n06_ctrl_wr      => open,
	n06_ctrl_rd      => open,
	n06_din          => zero8,
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
