---------------------------------------------------------------------------------
-- Pole Position (adapted from Xevious) by Dar (darfpga@aol.fr)
-- http://darfpga.blogspot.fr
---------------------------------------------------------------------------------
-- 2026-07-13 STEP-3 GUT: the Xevious 3-Z80 muxed-bus CPU section + the entire
-- Xevious video pipeline (fg/bg/sprite fetch, palettes, terrain, sound_machine,
-- mb88 5xxx) were REMOVED and replaced by PolePosition_CPU (Z80 + 2x Z8002 +
-- shared VRAM). Only gen_video (H/V timing) + the free-running pixel-slot machine
-- (ena_vidgen) survive from the original. Old code is recoverable from git.
--
-- STATUS 2026-08-06 (the 07-13 note above said sound/view/sprites/road/palette/
-- the Namco 5xxx bus were "NOT wired yet" and the renderer was pp_alpha_bringup;
-- all of that is long obsolete, so it is corrected here rather than left to
-- mislead): the renderer is pp_video_composite (alpha + view + road + sprites),
-- the 06xx bus with 51xx/52xx/53xx/54xx is live, and audio is namco_wsg8 mixed
-- with pp_engine_snd. VOICE52-2026-08-11: the 52xx's analog "discrete" output is
-- now modelled too (pp_voice52_snd.sv), so voice samples are audible. Still
-- absent: the 54xx analog "discrete" outputs (crash/explosion noise).
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

 -- watchdog defeat switch (rtl/pp_watchdog.sv wdog_en). 1 = watchdog live
 -- (MAME polepos.cpp:925 set_vblank_count(...,16)), 0 = permanently disabled.
 -- Driven from Arcade-PolePosition.sv's OSD "Watchdog" toggle, default ON.
 wdog_en        : in std_logic;

 -- ILLEGAL-SCREAM-2026-08-09: sticky 'a Z8002 sub hit an unimplemented opcode'
 -- flag. z8002.sv's S_ILLEGAL is a TERMINAL state -- the sub stops dead, silently,
 -- and the only symptom is frozen road/sprite/view buffers (reads as a video bug).
 -- Routed to LED_USER in Arcade-PolePosition.sv.
 sub_illegal    : out std_logic;

 dn_addr        : in  std_logic_vector(16 downto 0);
 dn_data        : in  std_logic_vector(7 downto 0);
 dn_wr          : in  std_logic;

 -- INCR-1a (DIAG-REVERT-2026-07-13): chars (alpha) gfx ROM interface. The ROM
 -- lives in the top (loaded at ioctl index 1); the alpha renderer here drives addr.
 gfx_addr       : out std_logic_vector(11 downto 0);
 gfx_data       : in  std_logic_vector(7 downto 0);

 -- INCR-view (2026-07-18): tiles (view/bg) gfx ROM interface. Sibling of the
 -- chars ROM; lives in the top (ioctl index 1 @0x1000); view renderer drives addr.
 view_gfx_addr  : out std_logic_vector(11 downto 0);
 view_gfx_data  : in  std_logic_vector(7 downto 0);

 -- INCR-video (2026-07-18): road / scalelut / sprite gfx ROMs (all in the top,
 -- ioctl idx1: road @0x14000, scalelut @0x19000, sprite small@0x2000 + big@0x6000
 -- -> combined sprite ROM @(ioctl_addr-0x2000)). The road/sprite generators drive addr.
 road_rom_addr  : out std_logic_vector(14 downto 0);
 road_rom_data  : in  std_logic_vector(7 downto 0);
 scalelut_addr  : out std_logic_vector(11 downto 0);
 scalelut_data  : in  std_logic_vector(7 downto 0);
 sprgfx_addr    : out std_logic_vector(16 downto 0);
 sprgfx_data    : in  std_logic_vector(7 downto 0);

 -- namco_52xx sample ("voice") ROM (ioctl index 5, region-relative 0x4000-0xBFFF,
 -- 0x8000 bytes -- the "engine" slice 0x0000-0x3FFF is a separate, still-unbuilt
 -- device and not wired here). rtl/namco/namco_52xx.sv drives addr from its
 -- internal O/R2/R3-port-built address register.
 sample52_addr  : out std_logic_vector(14 downto 0);
 sample52_data  : in  std_logic_vector(7 downto 0);

 -- ENGINE-SOUND-2026-08-06: engine ("car") sound waveform ROM, ioctl index 5
 -- region-relative 0x0000-0x3FFF (MAME "engine" region, 8 slots x 0x800).
 engine_addr    : out std_logic_vector(13 downto 0);
 engine_data    : in  std_logic_vector(7 downto 0);

 -- palette PROM load (ioctl index 2, 0x000-0xFFF = R/G/B/alpha/view/vpos-mod/road/sprite)
 prom_wr        : in  std_logic;
 prom_addr      : in  std_logic_vector(11 downto 0);
 prom_data      : in  std_logic_vector(7 downto 0);

 -- Namco WSG waveform PROM load (ioctl index 2, region-relative 0x1040-0x113F;
 -- top level pre-adjusts to a plain 0-255 address -- see namco_wsg8.sv header)
 wsg_prom_wr    : in  std_logic;
 wsg_prom_addr  : in  std_logic_vector(7 downto 0);
 wsg_prom_data  : in  std_logic_vector(7 downto 0);

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
 -- DIAG-REVERT-2026-08-16: palette-swatch overlay enable (OSD O7). 0 = normal.
 diag_swatch    : in std_logic;
 -- XEVIOUS-STRIP-2026-08-06: `test_v : in std_logic_vector(3 downto 0)` removed.
 -- It was declared here, referenced nowhere in the architecture, and left
 -- unconnected at the instantiation -- an undriven input on every build.

 audio          : out std_logic_vector(15 downto 0);

 self_test      : in std_logic;
 service        : in std_logic;
 coin1          : in std_logic;

 start1         : in std_logic;
 -- fire1 is the real Gear Change input (MAME IN0 bit 0x02) -- see in0_byte below.
 fire1          : in std_logic;

 coin2          : in std_logic;
 start2         : in std_logic;

 -- XEVIOUS-STRIP-2026-08-06: up1/down1/left1/right1 and up2/down2/left2/right2/
 -- fire2 were removed from this entity. They were Xevious two-player scaffold
 -- ports: declared here and referenced NOWHERE in the architecture below. Pole
 -- Position's directional controls are ANALOG (steering via the 53xx, pedals via
 -- the ADC0804), and it has exactly ONE gear input, so there is no P2 equivalent.
 -- The P1 direction signals still exist in Arcade-PolePosition.sv, where they
 -- drive the digital steering/pedal placeholders.

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

 -- ADC0804 (rtl/adc0804.sv) accelerator/brake pedal inputs (MAME "ACCEL"/"BRAKE"
 -- analog ports, PORT_MINMAX(0,0x90)). Selected onto adc_vin by gasel_w below
 -- (MAME polepos.h m_analog_io{"BRAKE","ACCEL"}: gasel=0->BRAKE, gasel=1->ACCEL).
 -- Arcade-PolePosition.sv currently drives these from a digital up/down
 -- placeholder (no real pedal/analog input wired at the top level yet).
 accel_in       : in  std_logic_vector(7 downto 0);
 brake_in       : in  std_logic_vector(7 downto 0);

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
 -- view/bg scanout + hscroll (renderer <-> PolePosition_CPU), 2026-07-18
 signal view_scan_addr_w : std_logic_vector(10 downto 0);
 signal view_scan_dout_w : std_logic_vector(15 downto 0);
 signal hscroll_w        : std_logic_vector(15 downto 0);
 -- road/sprite scanout + road vscroll (renderer <-> PolePosition_CPU), 2026-07-18
 signal road_scan_addr_w   : std_logic_vector(9 downto 0);
 signal road_scan_dout_w   : std_logic_vector(15 downto 0);
 signal sprite_scan_addr_w : std_logic_vector(10 downto 0);
 signal sprite_scan_dout_w : std_logic_vector(15 downto 0);
 signal road_vscroll_w     : std_logic_vector(15 downto 0);

 -- CPU ROM-load derives from the index-0 dn_ stream
 signal cpu_rom_wr    : std_logic;
 signal cpu_ioctl_addr: std_logic_vector(24 downto 0);

 -- watchdog (rtl/pp_watchdog.sv): watchdog_wr_w = Z80 $A100 kick (u_pp_cpu
 -- watchdog_wr, was `open`); wdog_reset_w = pulse OR'd into the CPU-subsystem
 -- reset ONLY (cpu_reset_w), never the video/ioctl reset. See pp_watchdog.sv
 -- header for the MAME citation + vblank-line source.
 signal watchdog_wr_w : std_logic;
 signal wdog_reset_w  : std_logic;
 signal cpu_reset_w   : std_logic;

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
 signal chacl_w        : std_logic;                     -- LS259 q7 (alpha layer enable color+msb, polepos_v.cpp:159-166)
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
 -- MCU-DIV6-2026-08-11: A/B SWITCH #2. `cen` is 3.072 MHz. The old divider gave
 -- mcu_ena = cen/2 = 1.536 MHz, which is the MB88's *PIN* clock. But mb88_core
 -- retires a 1-byte instruction per `ena` pulse, while mb88xx.h:125-126 charges
 -- it one MACHINE cycle = 6 pin clocks -- so all four Namco MCUs have been
 -- running ~6x too fast. Correct machine-cycle rate = 1.536/6 = 256 kHz = cen/12.
 --   MCU_CEN_DIV = 12  -> MAME-correct 256 kHz
 --   MCU_CEN_DIV =  2  -> the pre-2026-08-11 behaviour (restore with this one edit)
 -- NOTE: Kangaroo drives the same core at its raw 2.5 MHz Z80 enable and works,
 -- so a missing /6 is not automatically fatal -- it should only bite where the
 -- MCU is in a tight handshake with the CPU, i.e. the 51xx reply burst.
 -- 2026-08-11 build #2: set to 12 (MAME-correct 256 kHz machine-cycle rate) now
 -- that HOLD_MODE = 1 is HW-CONFIRMED as the controls fix and is the established
 -- baseline. This build therefore still isolates ONE variable.
 constant MCU_CEN_DIV : integer := 12;
 signal mcu_div_cnt : integer range 0 to 15 := 0;
 signal mcu_ena : std_logic;

 -- Namco WSG (8-voice, rtl/namco_wsg8.sv). u_pp_cpu's sound_en/wsg_* ports
 -- were open/zero8 tie-offs; now real (see u_wsg instance + wiring below).
 signal sound_en_w  : std_logic;

 -- ENGINE-SOUND-2026-08-06: engine ("car") sound, rtl/pp_engine_snd.sv.
 -- wsg_audio_w/engine_audio_w are the two voices; `audio` is their mix (below).
 signal engine_dout_w   : std_logic_vector(7 downto 0);
 signal engine_lsb_wr_w : std_logic;
 signal engine_msb_wr_w : std_logic;
 signal wsg_audio_w     : std_logic_vector(15 downto 0);
 signal engine_audio_w  : std_logic_vector(15 downto 0);
 -- VOICE52-2026-08-11: third voice. n52_p_w is the 52xx's OUT0-OUT3 audio pins,
 -- which were connected to `open` until now (hence: no voice samples at all).
 signal n52_p_w         : std_logic_vector(3 downto 0);
 signal voice_audio_w   : std_logic_vector(15 downto 0);
 -- NOISE54-2026-08-11: fourth voice. The 54xx's three discrete level outputs,
 -- likewise connected to `open` until now (hence: no screech/crash/rumble).
 signal n54_o0_w        : std_logic_vector(3 downto 0);
 signal n54_o1_w        : std_logic_vector(3 downto 0);
 signal n54_r1_w        : std_logic_vector(3 downto 0);
 signal noise_audio_w   : std_logic_vector(15 downto 0);
 signal audio_mix_s     : signed(17 downto 0);
 signal wsg_addr_w  : std_logic_vector(5 downto 0);
 signal wsg_dout_w  : std_logic_vector(7 downto 0);
 signal wsg_wr_w    : std_logic;
 signal wsg_din_w   : std_logic_vector(7 downto 0);

 -- ADC0804 (rtl/adc0804.sv). u_pp_cpu's gasel/adc_* ports were open/tied-off
 -- (gasel => open, adc_wr/adc_rd => open, adc_din => zero8, adc_intr_n => '1');
 -- now real (see u_adc instance + wiring below).
 signal gasel_w      : std_logic;                     -- LS259 q3, 0=BRAKE 1=ACCEL
 signal adc_wr_w     : std_logic;
 signal adc_rd_w     : std_logic;
 signal adc_din_w    : std_logic_vector(7 downto 0);
 signal adc_intr_n_w : std_logic;
 signal adc_vin_w    : std_logic_vector(7 downto 0);

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
   rom_data_in  : in  std_logic_vector(7 downto 0);
   vblank       : in  std_logic
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

 component namco_54xx
 port(
   clk          : in  std_logic;
   ena          : in  std_logic;
   reset_n      : in  std_logic;
   chip_sel     : in  std_logic;
   wr_en        : in  std_logic;
   wr_data      : in  std_logic_vector(7 downto 0);
   discrete_o0  : out std_logic_vector(3 downto 0);
   discrete_o1  : out std_logic_vector(3 downto 0);
   discrete_r1  : out std_logic_vector(3 downto 0);
   rom_wr       : in  std_logic;
   rom_addr_in  : in  std_logic_vector(11 downto 0);
   rom_data_in  : in  std_logic_vector(7 downto 0)
 );
 end component;

 component namco_52xx
 port(
   clk          : in  std_logic;
   ena          : in  std_logic;
   reset_n      : in  std_logic;
   chip_sel     : in  std_logic;
   wr_en        : in  std_logic;
   wr_data      : in  std_logic_vector(7 downto 0);
   discrete_p   : out std_logic_vector(3 downto 0);
   sample_addr  : out std_logic_vector(14 downto 0);
   sample_data  : in  std_logic_vector(7 downto 0);
   rom_wr       : in  std_logic;
   rom_addr_in  : in  std_logic_vector(11 downto 0);
   rom_data_in  : in  std_logic_vector(7 downto 0)
 );
 end component;

 -- ENGINE-SOUND-2026-08-06: rtl/pp_engine_snd.sv (MAME polepos_a.cpp
 -- polepos_sound_device). Instantiated via a VHDL component declaration, the
 -- proven Q17 VHDL<-SystemVerilog path used by every other SV peripheral here.
 component pp_engine_snd
 port(
   clk       : in  std_logic;
   reset     : in  std_logic;
   pause     : in  std_logic;
   clson     : in  std_logic;
   lsb_wr    : in  std_logic;
   msb_wr    : in  std_logic;
   din       : in  std_logic_vector(7 downto 0);
   rom_addr  : out std_logic_vector(13 downto 0);
   rom_data  : in  std_logic_vector(7 downto 0);
   audio     : out std_logic_vector(15 downto 0)
 );
 end component;

 -- VOICE52-2026-08-11: rtl/sound/pp_voice52_snd.sv (MAME polepos_a.cpp CHANL4).
 -- Takes the 52xx's 4-bit PCM output pins and does DAC + filter + level.
 component pp_voice52_snd
 port(
   clk       : in  std_logic;
   reset     : in  std_logic;
   pause     : in  std_logic;
   p_data    : in  std_logic_vector(3 downto 0);
   audio     : out std_logic_vector(15 downto 0)
 );
 end component;

 -- NOISE54-2026-08-11: rtl/sound/pp_noise54_snd.sv (MAME polepos_a.cpp
 -- CHANL1/2/3). Three 4-bit levels from the 54xx -> DAC + bandpass -> one mix.
 component pp_noise54_snd
 port(
   clk       : in  std_logic;
   reset     : in  std_logic;
   pause     : in  std_logic;
   o0_data   : in  std_logic_vector(3 downto 0);
   o1_data   : in  std_logic_vector(3 downto 0);
   r1_data   : in  std_logic_vector(3 downto 0);
   audio     : out std_logic_vector(15 downto 0)
 );
 end component;

 component namco_wsg8
 port(
   clk       : in  std_logic;
   reset     : in  std_logic;
   sound_en  : in  std_logic;
   pause     : in  std_logic;   -- PAUSE-GATE-2026-08-05
   reg_addr  : in  std_logic_vector(5 downto 0);
   reg_din   : in  std_logic_vector(7 downto 0);
   reg_wr    : in  std_logic;
   reg_dout  : out std_logic_vector(7 downto 0);
   wave_wr   : in  std_logic;
   wave_addr : in  std_logic_vector(7 downto 0);
   wave_data : in  std_logic_vector(7 downto 0);
   audio     : out std_logic_vector(15 downto 0)
 );
 end component;

 component adc0804
 port(
   clk      : in  std_logic;
   reset    : in  std_logic;
   wr       : in  std_logic;
   rd       : in  std_logic;
   vin      : in  std_logic_vector(7 downto 0);
   dout     : out std_logic_vector(7 downto 0);
   intr_n   : out std_logic
 );
 end component;

 component pp_video_composite
 port(
   clk             : in  std_logic;
   ce              : in  std_logic;
   hpos            : in  std_logic_vector(8 downto 0);
   vpos            : in  std_logic_vector(8 downto 0);
   chacl           : in  std_logic;
   diag_swatch     : in  std_logic;   -- DIAG-REVERT-2026-08-16: palette swatch overlay
   alpha_scan_addr : out std_logic_vector(10 downto 0);
   alpha_scan_dout : in  std_logic_vector(15 downto 0);
   alpha_gfx_addr  : out std_logic_vector(11 downto 0);
   alpha_gfx_data  : in  std_logic_vector(7 downto 0);
   view_scan_addr  : out std_logic_vector(10 downto 0);
   view_scan_dout  : in  std_logic_vector(15 downto 0);
   view_gfx_addr   : out std_logic_vector(11 downto 0);
   view_gfx_data   : in  std_logic_vector(7 downto 0);
   view_hscroll    : in  std_logic_vector(15 downto 0);
   road_scan_addr  : out std_logic_vector(9 downto 0);
   road_scan_dout  : in  std_logic_vector(15 downto 0);
   road_rom_addr   : out std_logic_vector(14 downto 0);
   road_rom_data   : in  std_logic_vector(7 downto 0);
   road_vscroll    : in  std_logic_vector(15 downto 0);
   sprite_scan_addr: out std_logic_vector(10 downto 0);
   sprite_scan_dout: in  std_logic_vector(15 downto 0);
   scalelut_addr   : out std_logic_vector(11 downto 0);
   scalelut_data   : in  std_logic_vector(7 downto 0);
   sprgfx_addr     : out std_logic_vector(16 downto 0);
   sprgfx_data     : in  std_logic_vector(7 downto 0);
   prom_wr         : in  std_logic;
   prom_addr       : in  std_logic_vector(11 downto 0);
   prom_data       : in  std_logic_vector(7 downto 0);
   r               : out std_logic_vector(3 downto 0);
   g               : out std_logic_vector(3 downto 0);
   b               : out std_logic_vector(3 downto 0)
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
   sub_illegal      : out std_logic;   -- ILLEGAL-SCREAM-2026-08-09
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

 component pp_watchdog
 port(
   clk        : in  std_logic;
   reset      : in  std_logic;
   wdog_en    : in  std_logic;
   vpos       : in  std_logic_vector(8 downto 0);
   kick       : in  std_logic;
   pause      : in  std_logic;   -- PAUSE-GATE-2026-08-05
   wdog_reset : out std_logic
 );
 end component;

 -- 2026-08-05: gen_video is now SystemVerilog (rtl/gen_video.sv). A SV module is
 -- NOT a VHDL primary unit in library `work`, so the previous direct-entity bind
 -- (`entity work.gen_video`) fails with Error 10481. Declared as a plain VHDL
 -- `component` instead -- the same proven Q17 pattern already used above for
 -- namco_06xx/51xx/52xx/53xx/54xx, namco_wsg8, adc0804, pp_video_composite,
 -- PolePosition_CPU and pp_watchdog, all of which are SystemVerilog modules.
 -- Port names/types/order copied verbatim from gen_video.vhd's entity.
 component gen_video
 port(
   clk      : in  std_logic;
   enable   : in  std_logic;
   hcnt     : out std_logic_vector(8 downto 0);
   vcnt     : out std_logic_vector(8 downto 0);
   hsync    : out std_logic;
   vsync    : out std_logic;
   csync    : out std_logic;
   blank_h  : out std_logic;
   blank_v  : out std_logic;
   blankn   : out std_logic;
   h_offset : in  signed(3 downto 0);
   v_offset : in  signed(3 downto 0)
 );
 end component;

begin

reset_n    <= not reset;
clock_18n  <= not clock_18;

-- CPU-subsystem reset = system reset OR'd with the watchdog pulse (pp_watchdog
-- instance below). Feeds ONLY u_pp_cpu (Z80 + both Z8002s), matching MAME's
-- watchdog_fired()->schedule_soft_reset(). Video pipeline / ioctl-download /
-- ROM-load reset are untouched (still driven straight from the `reset` input).
cpu_reset_w <= reset or wdog_reset_w;

zero8  <= (others => '0');
zero10 <= (others => '0');
zero11 <= (others => '0');

blank_v      <= vblank;
video_en     <= ena_vidgen;
hs_data_out  <= (others => '0');

cpu_ioctl_addr <= "00000000" & dn_addr;
cpu_rom_wr     <= dn_wr when dn_addr(16 downto 12) < "00011" else '0';  -- maincpu region < 0x3000

-- Z80 / Z8002 clock enable = clock_18 /16
--
-- CEN-PHASE-FIX-2026-08-05: cen_cnt is now RESET-SYNCHRONISED. It previously had
-- no reset and free-ran from FPGA configuration, while PolePosition_subcpu.sv's
-- `div` counter (which owns the shared-VRAM port-A time-division mux) DOES reset:
--     always @(posedge clk) if (reset) div <= 4'd0; else div <= div + 4'd1;
-- Both are 4-bit and tick every clock, so the PHASE between this `cen` pulse and
-- the Z80's port-A ownership window (own_z80 = div <= 4, i.e. 5 slots of 16) was
-- arbitrary -- determined by whenever reset happened to be released, and shifted
-- by every subsequent reset.
--
-- Consequence when the phase lands wrong: `cen` fires outside div 0..4, so
-- own_z80 is low for the entire Z80 access and EVERY Z80 read/write to shared
-- VRAM is silently dropped -- no stall, no retry, no error. Reads additionally
-- capture whichever address another master had on the shared port.
--
-- This is a prime suspect for the HW-only self-test "RAM 73" failure (a Z8002
-- sub's RAM pattern test over shared VRAM) that Verilator never reproduces: the
-- sim releases reset at a fixed cycle after ROM load and so always lands on the
-- same -- evidently good -- phase, while real HW's reset release is gated by the
-- reset chain / ioctl_download and lands elsewhere.
--
-- Resetting cen_cnt to 0 alongside div makes `cen` fire at div=0, inside the
-- Z80's ownership window, deterministically and identically on every reset.
process (clock_18)
begin
	if rising_edge(clock_18) then
		if reset = '1' then
			cen_cnt <= (others => '0');
		else
			cen_cnt <= cen_cnt + "0001";
		end if;
	end if;
end process;
cen <= '1' when cen_cnt = "0000" else '0';

-- PIXCLK-FIX-2026-08-09 -----------------------------------------------------
-- ena_vidgen is the pixel clock enable: it steps gen_video's H/V counters, the
-- renderer (pp_video_composite.ce) AND the core's output CE_PIXEL
-- (Arcade-PolePosition.sv:426 `wire ce_pix = ce_vid;`).
--
-- Pole Position needs a 6.144 MHz pixel clock (MAME polepos.cpp:950
-- set_raw(MASTER_CLOCK/4, 384, 0, 256, 264, ...) with MASTER_CLOCK=24.576 MHz),
-- i.e. 384*264 @ 60.606 Hz. clock_18 is now 49.152 MHz (the PLL is single-output;
-- the signal name is a fossil of the old 18.432 MHz domain), so the enable must
-- be exactly 1-in-8: 49.152/8 = 6.144 MHz.
--
-- The original below was inherited unchanged from Xevious, whose 18.432 MHz
-- domain needs 1-in-3 (18.432/3 = 6.144 MHz). Run at 49.152 MHz it measures
-- ~1-in-6 => 8.192 MHz pixel clock => 384*264 @ 80.8 Hz, i.e. video ~33% fast.
-- The CPU divider WAS re-derived for the new clock (cen = clk/16 = 3.072 MHz,
-- matching MAME's Z80 MASTER_CLOCK/8), which is why boot speed matches MAME
-- while everything downstream of the first EI breaks.
--
-- Measured in verilator/pp_maincpu before this change: 609,888 clk/frame
-- (6.016 clk per pixel step). Correct is 384*8*264 = 811,008 clk/frame.
--
-- To revert: delete the process below, uncomment the original.
--   process (clock_18, hcnt)
--   begin
--   	if rising_edge(clock_18) then
--   		slot24  <= slot24 + "00001";
--   		slot    <= slot + "001";
--   		if slot = "101" then
--   			if (hcnt(2 downto 0) = "111") then slot24 <= (others=>'0'); end if;
--   			if (hcnt(0) = '1') then slot <= "000"; else slot <= "011"; end if;
--   		end if;
--   	end if;
--   end process;
--
--   process (clock_18)
--   begin
--   	if rising_edge(clock_18) then
--   		ena_vidgen <= '0';
--   		if slot = "100" or slot = "001" then ena_vidgen <= '1'; end if;
--   	end if;
--   end process;
------------------------------------------------------------------------------
-- `slot` is reused as the 1-in-8 divider (it had no reader outside this block).
-- `slot24` never had a reader at all; it is kept ticking only so the signal is
-- not left undriven.
process (clock_18)
begin
	if rising_edge(clock_18) then
		slot24     <= slot24 + "00001";
		slot       <= slot + "001";
		ena_vidgen <= '0';
		if slot = "111" then ena_vidgen <= '1'; end if;
	end if;
end process;

-- H/V sync + counters (reused as-is; 384x264 Namco-family timing)
u_gen_video : gen_video
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

-- FULL video compositor: view/bg (vpos<128) OR road (vpos>=128) -> sprites ->
-- alpha, per MAME screen_update. Reads the REAL scan_alpha/view/road/sprite
-- buffers from PolePosition_CPU; gfx from the top-side chars/tiles/road/scalelut/
-- sprite ROMs; palettes pp_palette_alpha/view/road/sprite. Both generators are
-- co-sim-verified (verilator/road, verilator/sprite).
u_video_composite : pp_video_composite
port map(
	clk              => clock_18,
	ce               => ena_vidgen,
	hpos             => hcnt,
	vpos             => vcnt,
	chacl            => chacl_w,
	diag_swatch      => diag_swatch,   -- DIAG-REVERT-2026-08-16
	alpha_scan_addr  => bru_scan_addr,
	alpha_scan_dout  => alpha_scan_dout,
	alpha_gfx_addr   => gfx_addr,
	alpha_gfx_data   => gfx_data,
	view_scan_addr   => view_scan_addr_w,
	view_scan_dout   => view_scan_dout_w,
	view_gfx_addr    => view_gfx_addr,
	view_gfx_data    => view_gfx_data,
	view_hscroll     => hscroll_w,
	road_scan_addr   => road_scan_addr_w,
	road_scan_dout   => road_scan_dout_w,
	road_rom_addr    => road_rom_addr,
	road_rom_data    => road_rom_data,
	road_vscroll     => road_vscroll_w,
	sprite_scan_addr => sprite_scan_addr_w,
	sprite_scan_dout => sprite_scan_dout_w,
	scalelut_addr    => scalelut_addr,
	scalelut_data    => scalelut_data,
	sprgfx_addr      => sprgfx_addr,
	sprgfx_data      => sprgfx_data,
	prom_wr          => prom_wr,
	prom_addr        => prom_addr,
	prom_data        => prom_data,
	r                => bru_r,
	g                => bru_g,
	b                => bru_b
);

-- CPU subsystem: Z80 maincpu + 2x Z8002 game CPUs + shared VRAM. Its Z8002s
-- write the alpha buffer during attract -> real text. Sound/IO/06xx tied off.
u_pp_cpu : PolePosition_CPU
port map(
	clk              => clock_18,
	cen              => cen,
	reset            => cpu_reset_w,
	pause            => pause,
	vpos             => vcnt,
	sub1_reset_n     => open,
	sub2_reset_n     => open,
	namco_reset      => namco_reset_w,
	sound_en         => sound_en_w,
	gasel            => gasel_w,
	sb0              => sb0_w,
	chacl            => chacl_w,
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
	wsg_addr         => wsg_addr_w,
	wsg_dout         => wsg_dout_w,
	wsg_wr           => wsg_wr_w,
	wsg_rd           => open,        -- unused: reg_dout is a live combinational readback,
	                                  -- no read-strobe needed (see namco_wsg8.sv)
	wsg_din          => wsg_din_w,
	engine_dout      => engine_dout_w,   -- ENGINE-SOUND-2026-08-06: now real (u_engine below)
	engine_lsb_wr    => engine_lsb_wr_w,
	engine_msb_wr    => engine_msb_wr_w,
	adc_wr           => adc_wr_w,
	adc_rd           => adc_rd_w,
	adc_din          => adc_din_w,
	adc_intr_n       => adc_intr_n_w,
	watchdog_wr      => watchdog_wr_w,
	sub_illegal      => sub_illegal,   -- ILLEGAL-SCREAM-2026-08-09
	ioctl_addr       => cpu_ioctl_addr,
	ioctl_data       => dn_data,
	rom_wr           => cpu_rom_wr,
	ioctl_wr_idx0    => dn_wr,
	scan_sprite_addr => sprite_scan_addr_w,
	scan_sprite_dout => sprite_scan_dout_w,
	scan_road_addr   => road_scan_addr_w,
	scan_road_dout   => road_scan_dout_w,
	scan_alpha_addr  => bru_scan_addr(9 downto 0),
	scan_alpha_dout  => alpha_scan_dout,
	scan_view_addr   => view_scan_addr_w,
	scan_view_dout   => view_scan_dout_w,
	hscroll          => hscroll_w,
	vscroll          => road_vscroll_w
);

-- watchdog (rtl/pp_watchdog.sv). vpos = vcnt, the SAME source fed to u_pp_cpu's
-- vpos port above (vcnt is gen_video's counter, NOT gated by CPU reset). See
-- pp_watchdog.sv header for the MAME citation and the vblank-line source.
u_watchdog : pp_watchdog
port map(
	clk        => clock_18,
	reset      => reset,
	wdog_en    => wdog_en,
	vpos       => vcnt,
	kick       => watchdog_wr_w,
	pause      => pause,
	wdog_reset => wdog_reset_w
);

-- ADC0804 (rtl/adc0804.sv) accelerator/brake pedal converter. Channel select is
-- gasel_w (LS259 q3, MAME polepos.h m_analog_io{"BRAKE","ACCEL"}): gasel=0
-- selects BRAKE, gasel=1 selects ACCEL. accel_in/brake_in are entity inputs
-- (Arcade-PolePosition.sv currently drives a digital placeholder, see there).
adc_vin_w <= accel_in when gasel_w = '1' else brake_in;

u_adc : adc0804
port map(
	clk      => clock_18,
	reset    => reset,
	wr       => adc_wr_w,
	rd       => adc_rd_w,
	vin      => adc_vin_w,
	dout     => adc_din_w,
	intr_n   => adc_intr_n_w
);

-- RESTORED-2026-07-28: STARTUP-STRIP-2026-07-27 had this commented out (WSG
-- was ~2,634 ALMs, cut to save Quartus compile time while chasing the boot
-- hang). The z8002.sv register-writeback-bus refactor freed ~5,400 ALMs
-- (28,789->23,364, 56% device util post-fit), so there's ample headroom to
-- bring real sound back. This also fixes the sim/HW self-test divergence on
-- the WSG readback stub (production tied wsg_din_w to 0x00, the Verilator
-- testbench independently tied it to 0xFF -- restoring the real chip here
-- removes the stub entirely, so there's nothing left to disagree).
u_wsg : namco_wsg8
port map(
	clk       => clock_18,
	reset     => reset,
	sound_en  => sound_en_w,
	pause     => pause,
	reg_addr  => wsg_addr_w,
	reg_din   => wsg_dout_w,
	reg_wr    => wsg_wr_w,
	reg_dout  => wsg_din_w,
	wave_wr   => wsg_prom_wr,
	wave_addr => wsg_prom_addr,
	wave_data => wsg_prom_data,
	audio     => wsg_audio_w        -- ENGINE-SOUND-2026-08-06: was `audio` directly;
);                                  -- now one of two voices into the mix below.

-- ---- engine ("car") sound -------------------------------------------------
-- MAME polepos_a.cpp polepos_sound_device: an 8-slot x 0x800 waveform ROM read
-- by a phase accumulator whose rate comes from the 0xA200/0xA300 register pair,
-- with a per-slot volume. clson is LS259 q2 = the same sound_en that gates the
-- WSG (polepos.cpp:938). See pp_engine_snd.sv's header for the rate derivation
-- and for what is deliberately NOT modelled (the 3-pole analog filter chain).
u_engine : pp_engine_snd
port map(
	clk      => clock_18,
	reset    => reset,
	pause    => pause,
	clson    => sound_en_w,
	lsb_wr   => engine_lsb_wr_w,
	msb_wr   => engine_msb_wr_w,
	din      => engine_dout_w,
	rom_addr => engine_addr,
	rom_data => engine_data,
	audio    => engine_audio_w
);

-- ---- 52xx voice ("sample player") -----------------------------------------
-- VOICE52-2026-08-11: MAME polepos_a.cpp CHANL4. The 52xx MCU decodes the
-- voice ROM itself and puts 4-bit PCM on its P pins (namco52.cpp:14 "OUT0-OUT3
-- = sound output"), so this stage is only the analog tail: R1 ladder DAC,
-- VREF offset, highpass, lowpass, level. See pp_voice52_snd.sv for the two
-- filter deviations and for the single level knob.
u_voice52 : pp_voice52_snd
port map(
	clk    => clock_18,
	reset  => reset,
	pause  => pause,
	p_data => n52_p_w,
	audio  => voice_audio_w
);

-- ---- 54xx noise (tyre screech / crash / rumble) ----------------------------
-- NOISE54-2026-08-11: MAME polepos_a.cpp CHANL1/2/3. The 54xx MCU generates the
-- waveform and presents three 4-bit levels; this stage is DAC + bandpass only.
-- Channel->band mapping is load-bearing, see pp_noise54_snd.sv's header.
u_noise54 : pp_noise54_snd
port map(
	clk     => clock_18,
	reset   => reset,
	pause   => pause,
	o0_data => n54_o0_w,
	o1_data => n54_o1_w,
	r1_data => n54_r1_w,
	audio   => noise_audio_w
);

-- ---- audio mix ------------------------------------------------------------
-- Sum then saturate, so the WSG keeps its previous level (a plain >>1 mix would
-- have quietly halved it) and only genuine peaks clip.
-- VOICE52-2026-08-11: widened 17 -> 18 bits for the third voice.
-- NOISE54-2026-08-11: fourth voice added. 18 bits still covers four 16-bit
-- signed inputs (4 x 32768 = 2^17, one bit of sign headroom left).
audio_mix_s <= resize(signed(wsg_audio_w), 18) + resize(signed(engine_audio_w), 18)
                                               + resize(signed(voice_audio_w), 18)
                                               + resize(signed(noise_audio_w), 18);
audio <= x"7FFF" when audio_mix_s >  to_signed(32767, 18) else
         x"8000" when audio_mix_s < to_signed(-32768, 18) else
         std_logic_vector(audio_mix_s(15 downto 0));

-- ---- Namco 5xxx MCU clock enable (see signal declaration comment) ----------
-- MCU-PHASE-FIX-2026-08-05: same defect class as CEN-PHASE-FIX above. mcu_div is
-- a toggle with no reset, so its polarity after any reset was arbitrary (whatever
-- it happened to hold), making mcu_ena land on either the even or the odd `cen`
-- -- non-deterministic across resets. The 51xx/53xx sit on the 06xx handshake in
-- the boot path, so give them a deterministic enable phase too.
process (clock_18)
begin
	if rising_edge(clock_18) then
		if reset = '1' then
			mcu_div <= '0';
			mcu_div_cnt <= 0;                       -- MCU-DIV6-2026-08-11
		elsif cen = '1' then
			mcu_div <= not mcu_div;
			-- MCU-DIV6-2026-08-11: modulo-MCU_CEN_DIV replaces the /2 toggle.
			-- Reset to 0 keeps the MCU-PHASE-FIX-2026-08-05 determinism.
			if mcu_div_cnt = MCU_CEN_DIV - 1 then
				mcu_div_cnt <= 0;
			else
				mcu_div_cnt <= mcu_div_cnt + 1;
			end if;
		end if;
	end if;
end process;
-- MCU-DIV6-2026-08-11: original below, restore by setting MCU_CEN_DIV = 2 (the
-- line itself is equivalent to the old one at that setting -- mcu_div is kept
-- driven so the old expression can be dropped back in verbatim if needed).
-- mcu_ena <= cen and mcu_div and (not pause);
-- Fires on the LAST count, not the first: at MCU_CEN_DIV = 2 that is the 2nd
-- `cen`, exactly where the old `mcu_div` toggle fired. So setting the constant
-- back to 2 restores the previous behaviour bit-for-bit, phase included.
mcu_ena <= '1' when (cen = '1' and mcu_div_cnt = MCU_CEN_DIV - 1 and pause = '0') else '0';

-- MCUs held in reset by EITHER the system reset OR the LS259 namco_reset latch
-- (q1, MAME reset(state) -- active-high "running", power-on default = held reset).
mcu_reset_n <= (not reset) and namco_reset_w;

-- IN0 (MAME PORT_START("IN0"), z80_map via the 51xx's input<2>/<3> nibbles).
-- All physical bits are IP_ACTIVE_LOW; bit2 (auto_start) is program-controlled
-- (sb0_w from the LS259, NOT a physical input); bit1 (Gear Change) repurposes
-- fire1 (dead in this Namco scaffold otherwise); bits 3/0 are MAME IPT_UNUSED.
-- AUTOSTART-POLARITY-FIX-2026-08-11: bit2 follows sb0 DIRECTLY, not inverted.
-- Symptom it fixes: self-test printed "MANUAL START" (operators manual: "suspect
-- the game harness"), attract/gameplay never started -- live issue #1.
--
-- Bit 2 is NOT a physical button. polepos.cpp:504 marks it IPT_CUSTOM "start 1,
-- program controlled": the Z80 writes LS259 q6 ($A006 -> sb0) and reads the line
-- back here, through the 51xx. pp_maincpu.asm $0A6F-$0A99 is a two-phase
-- loopback test, and the messages are "AUTO START" @$11FE / "MANUAL START" @$120B:
--     $0A72  and $04 / jr nz  -> bit2 must be 0 here, else MANUAL
--     $0A7C  writes sb0 := 1
--     $0A8B  and $04 / ret nz -> bit2 must be 1 there
-- So the line must FOLLOW sb0. Inverting it fails phase 1 on the very first pass,
-- and the only code that ever sets sb0 sits BEHIND that branch -- unescapable.
--
-- Why the old code looked right: MAME's auto_start_r() returns
-- `m_auto_start_mask = !sb0`, so `not sb0_w` matches the callback literally. But
-- the field is IP_ACTIVE_LOW, and MAME applies that inversion to custom fields
-- too, so the byte the game sees is !(!sb0) = sb0. The two inversions cancel.
-- Confirmed by observation, not derivation: MAME's self-test prints AUTO START
-- (user, 2026-08-11) where ours printed MANUAL.
-- Original below, restore by swapping the two bit-2 terms:
-- in0_byte <= (not self_test) & (not service) & (not coin2) & (not coin1)
--             & '1' & (not sb0_w) & (not fire1) & '1';
in0_byte <= (not self_test) & (not service) & (not coin2) & (not coin1)
            & '1' & sb0_w & (not fire1) & '1';

-- 52xx and 54xx (both built 2026-07-28) legitimately have NO read_callback<2>/<3>
-- bound in polepos.cpp -- namco52.cpp/namco54.cpp have no read() method at all --
-- so chip2_din/chip3_din staying tied to this 0xFF stub is CORRECT and permanent,
-- not a placeholder: it matches MAME's devcb_read8 unbound-callback default
-- exactly for both chips (verified by reading both device sources directly).
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
	rom_data_in => mcu_rom_data,
	-- TC-TIMER-FIX-2026-07-17: vblank -> 51xx mb88 external-counter timer (was stubbed).
	-- `vblank` is gen_video's blank_v (1 during vertical blank); the 51xx inverts it to
	-- the TC pin level internally. This is what advances the 51xx per-frame self-test logic.
	vblank      => vblank
);

-- 2026-08-05: the 53xx was temporarily removed here to test whether it explained the
-- HW-only "RAM 73" self-test failure (the Verilator rig omits namco_53xx and ties
-- chip1_din to 0xFF, making it the only 06xx-bus delta between the two environments).
-- RESULT: HW-tested, ZERO difference — same RAM 73. The 53xx is NOT the cause. Restored.
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

-- 54xx: 06xx chip3 slot (write-only, no read_callback in MAME -- see chip23_din
-- comment above). discrete_o0/o1/r1 feed MAME's analog "discrete" sound circuit,
-- not modeled yet -- left open, same TODO status as u_pp_cpu's engine_* ports.
u_n54xx : namco_54xx
port map(
	clk         => clock_18,
	ena         => mcu_ena,
	reset_n     => mcu_reset_n,
	chip_sel    => n06_chipsel(3),
	wr_en       => n06_chip_wr(3),
	wr_data     => n06_chip_dout,
	-- NOISE54-2026-08-11: all three were `open` (screech/crash/rumble silent)
	discrete_o0 => n54_o0_w,
	discrete_o1 => n54_o1_w,
	discrete_r1 => n54_r1_w,
	rom_wr      => mcu_rom_wr,
	rom_addr_in => mcu_rom_addr,
	rom_data_in => mcu_rom_data
);

-- 52xx: 06xx chip2 slot (write-only, no read_callback in MAME -- see chip23_din
-- comment above). discrete_p feeds MAME's analog "discrete" sound circuit, not
-- modeled yet. sample_addr/sample_data are the external 0x8000 "voice" ROM
-- (ioctl index 5, wired at the poleposition entity level via sample52_addr/data).
u_n52xx : namco_52xx
port map(
	clk         => clock_18,
	ena         => mcu_ena,
	reset_n     => mcu_reset_n,
	chip_sel    => n06_chipsel(2),
	wr_en       => n06_chip_wr(2),
	wr_data     => n06_chip_dout,
	discrete_p  => n52_p_w,      -- VOICE52-2026-08-11: was `open` (voice was silent)
	sample_addr => sample52_addr,
	sample_data => sample52_data,
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
