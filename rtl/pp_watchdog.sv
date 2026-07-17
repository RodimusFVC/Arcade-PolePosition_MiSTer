//============================================================================
//  pp_watchdog.sv — Pole Position Z80 watchdog reset (0xA100)
//
//  Ground truth: Useful Stuff/mame/polepos.cpp:925
//    WATCHDOG_TIMER(config, "watchdog").set_vblank_count(m_screen, 16);
//  and :1042
//    map(0xa100, 0xa100).mirror(0x0cff).w("watchdog", FUNC(watchdog_timer_device::reset_w));
//  -> the Z80 must write $A100 (PolePosition_CPU.sv's watchdog_wr = cs_awdog & wr_s)
//  at least once every 16 VBLANKs, or the real board resets. watchdog.cpp:104-121
//  (watchdog_reset()) shows ANY write reloads the counter to m_vblank_count (=16);
//  watchdog.cpp:158-168 (watchdog_vblank()) decrements once per VBLANK-start and
//  fires (schedule_soft_reset(), :145-150) when it reaches 0 -- i.e. exactly 16
//  un-kicked VBLANK-starts elapse between a kick and the reset. Implemented below
//  as an equivalent up-counter (kick clears it; fires on the 16th un-kicked
//  VBLANK-start).
//
//  VBLANK-start edge: vpos here is fed vcnt straight from rtl/gen_video.vhd
//  (poleposition.vhd u_pp_cpu port map: vpos => vcnt, so this module sees the
//  exact same vcnt). gen_video.vhd:124 `if vcntReg = (240+0) then vblank <= '1';`
//  marks the start of vertical blanking (vtotal = 264 lines, vcnt 0..263, see
//  gen_video.vhd:56-59/71). PolePosition_CPU.sv:193 already keys sub_nvi_trig off
//  this identical vpos==240 transition for its own vblank-edge event
//  (`assign sub_nvi_trig = vpos_new & (vpos == 9'd240);`) -- the same edge-detect
//  idiom (vpos_d register + inequality compare) is reused here for consistency.
//
//  wdog_reset is a PULSE (not a level): held high for PULSE_CYCLES clk cycles
//  (default 32, i.e. >1 full Z80/Z8002 cen period = clk/16, so the CEN-gated CPU
//  cores reliably sample it) then it deasserts and the counter re-arms from 0,
//  mirroring MAME's device_reset()->watchdog_reset() reload on machine reset. If
//  wdog_en stays asserted and nothing ever kicks $A100 again (e.g. the CPU is
//  hung), this free-runs into a repeating reset every 16 VBLANKs (~16 frames @
//  ~60 Hz = ~4 Hz). PULSE_CYCLES is a judgement call, not HW-validated -- long
//  enough to clear >1 cen period without hand-deriving exact T80/Z8002 reset
//  timing (see vault: don't hand-simulate RTL timing). Caller ORs wdog_reset
//  into the CPU-subsystem reset (u_pp_cpu), NOT the video pipeline or the
//  ioctl/ROM-download reset -- see poleposition.vhd.
//
//  wdog_en: defeat switch, driven from Arcade-PolePosition.sv (OSD "Watchdog"
//  toggle, status[2], default ON). The core currently hangs during self-test
//  with no $A100 kick at the hang site; with the watchdog live that hang becomes
//  the ~4 Hz reboot loop described above -- useful signal that something is
//  wrong, but it turns a static, inspectable hang into a moving target. wdog_en=0
//  holds the counter clear and wdog_reset low unconditionally so the hang can be
//  observed without the reboot loop.
//============================================================================
`default_nettype none

module pp_watchdog #(
    parameter PULSE_CYCLES = 32   // wdog_reset pulse width in clk cycles (>1 cen period = 16 clks)
)
(
    input  wire       clk,         // CLK_49M, 49.152 MHz fabric clock
    input  wire        reset,       // active-high system reset (top-level `reset`, NOT the OR'd CPU reset)
    input  wire        wdog_en,     // 1 = watchdog live, 0 = permanently defeated
    input  wire  [8:0] vpos,        // = vcnt from gen_video.vhd (0..263)
    input  wire        kick,        // 1-clk strobe: Z80 wrote $A100 (PolePosition_CPU.sv watchdog_wr)
    output reg         wdog_reset   // active-high PULSE, see header
);

    // VBLANK-start edge detect -- same idiom as PolePosition_CPU.sv's sub_nvi_trig
    reg [8:0] vpos_d;
    always @(posedge clk) vpos_d <= vpos;
    wire vblank_start = (vpos == 9'd240) & (vpos_d != 9'd240);

    reg [3:0] vbl_count;   // 0..15: un-kicked VBLANK-starts since the last kick/reset
    reg [4:0] pulse_cnt;   // 0..PULSE_CYCLES-1
    reg       pulsing;

    always @(posedge clk) begin
        if (reset || !wdog_en) begin
            vbl_count  <= 4'd0;
            pulsing    <= 1'b0;
            pulse_cnt  <= 5'd0;
            wdog_reset <= 1'b0;
        end else if (pulsing) begin
            if (pulse_cnt == PULSE_CYCLES-1) begin
                pulsing    <= 1'b0;
                wdog_reset <= 1'b0;
                vbl_count  <= 4'd0;        // re-arm for the next 16 VBLANKs
            end else begin
                pulse_cnt <= pulse_cnt + 5'd1;
            end
        end else if (kick) begin
            vbl_count <= 4'd0;
        end else if (vblank_start) begin
            if (vbl_count == 4'd15) begin  // 16th un-kicked VBLANK-start -> fire
                wdog_reset <= 1'b1;
                pulsing    <= 1'b1;
                pulse_cnt  <= 5'd0;
            end else begin
                vbl_count <= vbl_count + 4'd1;
            end
        end
    end

endmodule

`default_nettype wire
