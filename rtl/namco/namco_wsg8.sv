//============================================================================
//  namco_wsg8.sv — Namco WSG (Waveform Sound Generator), Pole Position's
//    8-voice / quad-gain variant of the classic Namco custom sound chip.
//
//  Ground truth: MAME src/devices/sound/namco.cpp (namco_device::polepos_sound_r/w
//  + namco_audio_device::{device_clock_changed,build_decoded_waveform,
//  namco_update_one,sound_stream_update}). This project's Useful Stuff/mame/
//  does NOT include namco.cpp/.h (checked — genuinely absent, not misnamed), so
//  this was fetched fresh from https://github.com/mamedev/mame at tag mame0270
//  (matches this MRA's <mameversion>0270</mameversion>) and cross-checked line
//  by line against the API this project's local polepos.cpp actually calls
//  (NAMCO(...), set_voices(8), set_stereo(true), polepos_sound_r/w) — the two
//  files matched exactly (namco.h at that tag declares namco_device with those
//  exact members; a newer/master-branch namco.cpp has since been templated and
//  would NOT match polepos.cpp's call sites, so mame0270 is confirmed correct).
//
//  Config (src/mame/namco/polepos.cpp :963-967, :937):
//    NAMCO(config, m_namco_sound, MASTER_CLOCK/512)   MASTER_CLOCK=24.576MHz
//                                                      -> namco clock = 48000 Hz
//    set_voices(8); set_stereo(true);
//    m_latch->q_out_cb<2>().set(m_namco_sound, FUNC(namco_device::sound_enable_w));
//      -- NO .invert() on q2 (unlike q0/q4/q5) -> latch bit = sound_enable directly.
//      PolePosition_CPU.sv already exposes this un-inverted as `sound_en`.
//
//  ---- Register map (polepos_sound_r/w, MAME namco.cpp :389-476) — Z80 side
//  0x83C0-0x83FF (64 bytes, mirror 0x0C00); PolePosition_CPU.sv's wsg_addr[5:0]
//  is already the region-relative 0x00-0x3F offset. Per voice ch (0..7),
//  base = ch*4:
//    base+0x00        frequency low byte  \_ voice->frequency = lo + (hi<<8)
//    base+0x01        frequency high byte /  (16-bit accumulator step — NOT the
//                     20-bit pacman-style layout; this is polepos_sound_w's own
//                     decode, confirmed against namco.cpp:451-452)
//    base+0x02        GAIN2, upper nibble -> contributes to volume[1] ("right")
//    base+0x03        GAIN3 (upper nibble, volume[0]) / GAIN4 (lower nibble, volume[1])
//    ch*4+0x23        GAIN1 (upper nibble -> volume[0]) | bit3 = ext-source
//                     select (54xx/52xx routed to this voice instead of the WSG
//                     waveform -> namco.cpp mutes volume[0]=volume[1]=0 when set;
//                     channels 0/1 normally have this bit set in the real game,
//                     per namco.cpp's own comment: "the game doesn't use the
//                     first 2 [voices] because it selects the 54XX/52XX outputs
//                     on those channels") | bits[2:0] = waveform_select (0-7).
//  volume[0] = (soundregs[base+3]>>4 + soundregs[base+0x23]>>4) / 2
//  volume[1] = (soundregs[base+3]&0xf + soundregs[base+2]>>4) / 2
//  (all other byte offsets in 0x00-0x3F are dead register-file bytes on real
//  hardware: stored, but polepos_sound_w's `switch(offset & 0x23)` never reads
//  them back into a voice parameter — reproduced here by simply never wiring
//  them to anything, matching MAME's decode exactly.)
//
//  ---- Waveform ROM: MAME ROM_REGION "namco" 0x100 (256 bytes), "pp1-5.3b"
//  crc 8568decc — 8 waveforms x 32 samples, 4-bit PCM (namco.cpp
//  build_decoded_waveform/update_namco_waveform, "wave_size==0" i.e. the
//  external-ROM path since Pole Position's namco_device has a real ROM
//  region: "use only low 4 bits", sample value = nibble-8, signed -8..+7).
//  Per the MRA, this ROM lives in ioctl index 2 at region-relative offset
//  0x1040-0x113F (right after the 0x1040-byte "proms" block: red/green/blue/
//  alpha/bg/vpos*3/road/sprite/vram-addr-dec, THEN namco WSG, THEN user1
//  sync). This module's wave_addr/wave_wr are already 0-255 region-relative
//  (the ioctl_index/offset gate lives at the top level, Arcade-PolePosition.sv,
//  mirroring the existing pp_prom_wr pattern one level up).
//
//  ---- Accumulator / pitch math (namco_audio_device::device_clock_changed +
//  WAVEFORM_POSITION(n)=(n>>fracbits)&0x1f): MAME oversamples its own audio
//  stream to >=192kHz by doubling the namco clock (48000->96000->192000, 2
//  doublings) then reads the waveform position from a 5-bit window starting at
//  bit fracbits=15+2=17 of a free-running counter incremented by the 16-bit
//  frequency register EVERY STREAM SAMPLE (192kHz). That 4x oversampling is a
//  MAME audio-quality choice, not extra hardware precision. Running our own
//  accumulator once per REAL 48kHz tick instead (matching the actual namco
//  clock) and shifting the read window down by the same factor (17-2=15)
//  yields IDENTICAL pitch:
//      MAME:  Hz = freq * 192000 / 2^22   (fracbits=17, +5-bit field = 2^22)
//      ours:  Hz = freq * 48000  / 2^20   (fracbits=15, +5-bit field = 2^20)
//      192000/2^22 = 48000/2^20  (both reduce to freq/87.3813...) -- equal.
//  counter is 20 bits (15-bit fraction + 5-bit waveform index), counter +=
//  freq (16-bit) once per 48kHz tick; waveform position = counter[19:15].
//
//  ---- Mixing (namco_update_one + OUTPUT_LEVEL, namco.cpp :40-43): MIXLEVEL =
//  1<<(16-4-4) = 256, OUTPUT_LEVEL(n) = n*MIXLEVEL/voices = n*32 (voices=8).
//  Per voice, per side: contribution = (wave_nibble-8) * volume(0-15) * 32.
//  This project's top level drives a single mono `audio` (AUDIO_R=AUDIO_L
//  already in Arcade-PolePosition.sv), so MAME's stereo (volume[0]/volume[1])
//  pair is summed and averaged into one mono value:
//      mono = ((sum_l + sum_r) * 32) / 2 = (sum_l + sum_r) << 4
//  Range check: |wave-8|<=8, vol<=15 -> |term|<=120; 8 voices -> |sum_l|,
//  |sum_r|<=960 -> |sum_l+sum_r|<=1920 -> <<4 => <=30720, fits signed 16-bit
//  with headroom (no further scaling/clamping needed).
//
//  ---- Register file / waveform table are PLAIN distributed-logic arrays, not
//  altsyncram/dpram_dc: every 48kHz tick, 8 voices each need FIVE register
//  bytes (40 simultaneous reads) and their OWN data-dependent waveform-ROM
//  address (8 simultaneous dynamic reads) — far more read ports than a 2-port
//  BRAM primitive offers. 64B + 256B replicated 8x is negligible against the
//  5CSEBA6 LE budget (this is smaller than a single Z8002 core already in the
//  design).
//
//  KNOWN ITERATION POINTS (need real HW ears — #unverified):
//   - the L/R -> mono averaging above is THIS PROJECT's own choice (forced by
//     the top level being mono-duplicated already); overall gain/headroom vs
//     MAME's true stereo mix + analog 54xx/52xx summing is unverified.
//   - channels 0/1 are expected to read as silent/near-silent in normal play
//     (their ch*4+0x23 ext-select bit routes them to 54xx/52xx instead, which
//     are NOT built this pass) — that matches MAME's own comment, not a bug.
//============================================================================
`default_nettype none

module namco_wsg8
(
    input  wire        clk,          // CLK_49M fabric clock (49.152 MHz)
    input  wire        reset,
    input  wire        sound_en,     // LS259 q2, MAME sound_enable_w (active-high, NOT inverted)
    // PAUSE-GATE-2026-08-05: gate the 48 kHz sample tick, not the audio output.
    // Gating the CHIP (not just the CPU that writes it) is what makes voices
    // freeze mid-note instead of ringing on / drifting while paused, and it
    // resumes at exactly the same phase. Do NOT "fix" this by muting `audio`
    // instead -- that stops the sound but lets the voice counters advance.
    // Canonical: vault note "Pause must gate every clock domain".
    input  wire        pause,

    // ---- Z80-side register bus (PolePosition_CPU.sv wsg_* ports) -----------
    input  wire  [5:0] reg_addr,     // = cpu_A[5:0], offset within 0x83C0-0x83FF
    input  wire  [7:0] reg_din,      // write data from CPU (wsg_dout)
    input  wire        reg_wr,       // single clk_sys pulse per Z80 write (cs_wsg & wr_s)
    output wire  [7:0] reg_dout,     // read data back to CPU (-> wsg_din)

    // ---- waveform PROM load (ioctl index 2; see header for the exact
    //      region-relative offset — gated/adjusted at the top level) ---------
    input  wire        wave_wr,
    input  wire  [7:0] wave_addr,
    input  wire  [7:0] wave_data,

    output reg  [15:0] audio         // mono sample, signed two's-complement bits
);

    // ---- 64-byte register file (distributed logic; see header) ------------
    reg [7:0] regs [0:63];
    always @(posedge clk) if (reg_wr) regs[reg_addr] <= reg_din;
    assign reg_dout = regs[reg_addr];

    // ---- 256-byte waveform ROM (distributed logic; see header) -------------
    reg [3:0] wave_rom [0:255];
    always @(posedge clk) if (wave_wr) wave_rom[wave_addr] <= wave_data[3:0];

    // ---- 48 kHz sample tick: CLK_49M/1024 = 49,152,000/1024 = 48,000 Hz,
    // exactly MAME's NAMCO(...,MASTER_CLOCK/512) namco clock (24,576,000/512).
    // Free-running (no reset), matching this file's other clock dividers.
    reg [9:0] ce_div;
    wire ce_wsg = (ce_div == 10'd0) & ~pause;   // PAUSE-GATE-2026-08-05
    always @(posedge clk) ce_div <= ce_div + 10'd1;

    // ---- per-voice state (flat arrays; see header re: distributed logic) --
    reg  [19:0] counter    [0:7];
    wire [15:0] freq       [0:7];
    wire  [7:0] g23        [0:7];   // regs[ch*4+0x23]: GAIN1 | ext-select | waveform_select
    wire  [7:0] g03        [0:7];   // regs[ch*4+0x03]: GAIN3 (hi) / GAIN4 (lo)
    wire  [7:0] g02        [0:7];   // regs[ch*4+0x02]: GAIN2 (hi)
    wire  [2:0] wsel       [0:7];
    wire        extsel     [0:7];
    wire  [4:0] wpos       [0:7];
    wire  [7:0] waddr      [0:7];
    wire  [3:0] wnib       [0:7];
    wire signed [4:0] wsig [0:7];   // wnib - 8, range -8..+7
    wire  [3:0] vol_l      [0:7];
    wire  [3:0] vol_r      [0:7];
    wire signed [9:0] contrib_l [0:7];
    wire signed [9:0] contrib_r [0:7];

    genvar v;
    generate
        for (v = 0; v < 8; v = v + 1) begin : g_voice
            assign freq[v]   = {regs[v*4+1], regs[v*4+0]};
            assign g23[v]    = regs[v*4+8'h23];
            assign g03[v]    = regs[v*4+3];
            assign g02[v]    = regs[v*4+2];
            assign wsel[v]   = g23[v][2:0];
            assign extsel[v] = g23[v][3];

            always @(posedge clk) begin
                if (reset)       counter[v] <= 20'd0;
                else if (ce_wsg) counter[v] <= counter[v] + freq[v];
            end

            assign wpos[v]  = counter[v][19:15];
            assign waddr[v] = {wsel[v], wpos[v]};
            assign wnib[v]  = wave_rom[waddr[v]];
            assign wsig[v]  = $signed({1'b0, wnib[v]}) - 5'sd8;

            assign vol_l[v] = extsel[v] ? 4'd0 : (({1'b0,g03[v][7:4]} + {1'b0,g23[v][7:4]}) >> 1);
            assign vol_r[v] = extsel[v] ? 4'd0 : (({1'b0,g03[v][3:0]} + {1'b0,g02[v][7:4]}) >> 1);

            assign contrib_l[v] = wsig[v] * $signed({1'b0, vol_l[v]});
            assign contrib_r[v] = wsig[v] * $signed({1'b0, vol_r[v]});
        end
    endgenerate

    // ---- sum across voices, then MIXLEVEL scale + L/R->mono average --------
    integer i;
    reg signed [12:0] sum_l, sum_r;
    always @(*) begin
        sum_l = 13'sd0;
        sum_r = 13'sd0;
        for (i = 0; i < 8; i = i + 1) begin
            sum_l = sum_l + contrib_l[i];
            sum_r = sum_r + contrib_r[i];
        end
    end

    wire signed [13:0] mix_sum     = sum_l + sum_r;
    wire signed [17:0] mix_shifted = mix_sum <<< 4;   // *32 (OUTPUT_LEVEL) / 2 (mono avg) = <<4
    wire signed [15:0] mono        = mix_shifted[15:0]; // true range fits 16b (see header)

    always @(posedge clk) audio <= sound_en ? mono : 16'd0;

endmodule

`default_nettype wire
