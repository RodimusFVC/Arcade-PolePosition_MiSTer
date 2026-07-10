0000: 0000           .word   #%0000 ;RST
0002: 4000           .word   #%4000 ;RST FCW
0004: 3300           .word   #%3300 ;RST PC
0006: 210F 8700      ld      r15,#%8700
000A: 2100 0100      ld      r0,#%0100
000E: 7D0D           ldctl   psapoff,r0
0010: 8D08           clr     r0
0012: 7D0B           ldctl   refresh,r0
0014: 6101 800E      ld      r1,%800e
0018: DF7F           calr    %011c
001A: 6F01 81AA      ld      %81aa,r1
001E: 4D08 810A      clr     %810a
0022: 4D08 810C      clr     %810c
0026: 4D05 6000 0001 ld      %6000,#%0001
002C: 7C06           ei      nvi
002E: 6103 8188      ld      r3,%8188
0032: B12A           exts    rr2
0034: 9420           ldl     rr0,rr2
0036: 9622           addl    rr2,rr2
0038: 9622           addl    rr2,rr2
003A: 9602           addl    rr2,rr0
003C: 9420           ldl     rr0,rr2
003E: 9600           addl    rr0,rr0
0040: 9600           addl    rr0,rr0
0042: 0100 0080      add     r0,#%0080
0046: 2104 8300      ld      r4,#%8300
004A: 2105 0010      ld      r5,#%0010
004E: 9620           addl    rr0,rr2
0050: 2F40           ld      @r4,r0
0052: A941           inc     r4,2
0054: 9620           addl    rr0,rr2
0056: 2F40           ld      @r4,r0
0058: A941           inc     r4,2
005A: 9620           addl    rr0,rr2
005C: 2F40           ld      @r4,r0
005E: A941           inc     r4,2
0060: 9620           addl    rr0,rr2
0062: 2F40           ld      @r4,r0
0064: A941           inc     r4,2
0066: 9620           addl    rr0,rr2
0068: 2F40           ld      @r4,r0
006A: A941           inc     r4,2
006C: 9620           addl    rr0,rr2
006E: 2F40           ld      @r4,r0
0070: A941           inc     r4,2
0072: 9620           addl    rr0,rr2
0074: 2F40           ld      @r4,r0
0076: A941           inc     r4,2
0078: 9620           addl    rr0,rr2
007A: 2F40           ld      @r4,r0
007C: A941           inc     r4,2
007E: 9620           addl    rr0,rr2
0080: 2F40           ld      @r4,r0
0082: A941           inc     r4,2
0084: 9620           addl    rr0,rr2
0086: 2F40           ld      @r4,r0
0088: A941           inc     r4,2
008A: AB50           dec     r5,1
008C: EEE0           jr      ne/nz,%004e
008E: 210A 83DE      ld      r10,#%83de
0092: 210B 97E0      ld      r11,#%97e0
0096: 210C 85E0      ld      r12,#%85e0
009A: 610D 8184      ld      r13,%8184
009E: 2101 006F      ld      r1,#%006f
00A2: 2100 0070      ld      r0,#%0070
00A6: 8D68           clr     r6
00A8: A167           ld      r7,r6
00AA: 9468           ldl     rr8,rr6
00AC: A113           ld      r3,r1
00AE: 8133           add     r3,r3
00B0: 6133 3600      ld      r3,%3600(r3)
00B4: 81D3           add     r3,r13
00B6: A03B           ldb     rl3,rh3
00B8: 8C38           clrb    rh3
00BA: 603B 36E0      ldb     rl3,%36e0(r3)
00BE: B130           extsb   r3
00C0: 601D 37E0      ldb     rl5,%37e0(r1)
00C4: 8C58           clrb    rh5
00C6: 9952           mult    rr2,r5
00C8: 9628           addl    rr8,rr2
00CA: 9686           addl    rr6,rr8
00CC: 9482           ldl     rr2,rr8
00CE: B32D FFFC      sral    rr2,#4
00D2: 93C3           push    @r12,r3
00D4: A0E3           ldb     rh3,rl6
00D6: A07B           ldb     rl3,rh7
00D8: B339 FFFC      sra     r3,#4
00DC: 01A3           add     r3,@r10
00DE: 93B3           push    @r11,r3
00E0: ABA1           dec     r10,2
00E2: AB10           dec     r1,1
00E4: F09D           djnz    r0,%00ac
00E6: 5E08 002E      jp      %002e
00EA: FFFF           djnz    r15,%ffffffee
00EC: FFFF           djnz    r15,%fffffff0
00EE: FFFF           djnz    r15,%fffffff2
00F0: FFFF           djnz    r15,%fffffff4
00F2: FFFF           djnz    r15,%fffffff6
00F4: FFFF           djnz    r15,%fffffff8
00F6: FFFF           djnz    r15,%fffffffa
00F8: FFFF           djnz    r15,%fffffffc
00FA: FFFF           djnz    r15,%fffffffe
00FC: FFFF           djnz    r15,%0000
00FE: FFFF           djnz    r15,%0002
0100: 0000 0000      addb    rh0,#%00
0104: 4000 3300      addb    rh0,%3300
0108: 4000 3300      addb    rh0,%3300
010C: 4000 3300      addb    rh0,%3300
0110: 0000 0000      addb    rh0,#%00
0114: 4000 3300      addb    rh0,%3300
0118: 4000 0132      addb    rh0,%0132
011C: A112           ld      r2,r1
011E: 0702 000F      and     r2,#%000f
0122: B311 FFFC      srl     r1,#4
0126: 0701 000F      and     r1,#%000f
012A: 1900 000A      mult    rr0,#%000a
012E: 8121           add     r1,r2
0130: 9E08           ret     
0132: 5C09 000E 8110 ldm     %8110,r0,#15
0138: 4D08 6000      clr     %6000
013C: 4D08 82BC      clr     %82bc
0140: 5F00 2692      call    %2692
0144: 6900 8100      inc     %8100,1
0148: 6100 8100      ld      r0,%8100
014C: 0700 0003      and     r0,#%0003
0150: EE08           jr      ne/nz,%0162
0152: 6900 8102      inc     %8102,1
0156: 4D01 8102 0006 cp      %8102,#%0006
015C: E702           jr      c/ult,%0162
015E: 4D08 8102      clr     %8102
0162: 6101 800E      ld      r1,%800e
0166: 6104 81AA      ld      r4,%81aa
016A: D028           calr    %011c
016C: 6F01 81AA      ld      %81aa,r1
0170: 8314           sub     r4,r1
0172: ED08           jr      pl,%0184
0174: 8D42           neg     r4
0176: 0B04 0007      cp      r4,#%0007
017A: E904           jr      ge,%0184
017C: 4104 810C      add     r4,%810c
0180: 6F04 810C      ld      %810c,r4
0184: 4D04 810A      test    %810a
0188: EE0B           jr      ne/nz,%01a0
018A: 4D04 810C      test    %810c
018E: E60A           jr      eq/z,%01a4
0190: 4D05 810A 003C ld      %810a,#%003c
0196: 6B00 810C      dec     %810c,1
019A: 6500 80EC      set     %80ec,0
019E: E802           jr      %01a4
01A0: 6B00 810A      dec     %810a,1
01A4: 6101 8012      ld      r1,%8012
01A8: 0701 0007      and     r1,#%0007
01AC: 8111           add     r1,r1
01AE: 6111 02B6      ld      r1,%02b6(r1)
01B2: 6102 8014      ld      r2,%8014
01B6: 0702 001F      and     r2,#%001f
01BA: 8122           add     r2,r2
01BC: 7111 0200      ld      r1,r1(r2)
01C0: 1F10           call    r1
01C2: DFE8           calr    %01f4
01C4: DFF9           calr    %01d4
01C6: 5C01 000E 8110 ldm     r0,%8110,#15
01CC: 4D05 6000 0001 ld      %6000,#%0001
01D2: 7B00           iret
01D4: 6B00 A9C4      dec     %a9c4,1
01D8: 9E0E           ret     ne/nz
01DA: 4D05 A9C4 003C ld      %a9c4,#%003c
01E0: 5400 A9C0      ldl     rr0,%a9c0
01E4: 2103 0001      ld      r3,#%0001
01E8: 8D28           clr     r2
01EA: 5F00 191E      call    %191e
01EE: 5D00 A9C0      ldl     %a9c0,rr0
01F2: 9E08           ret     
01F4: 4D04 82C2      test    %82c2
01F8: EE13           jr      ne/nz,%0220
01FA: 4D04 82C4      test    %82c4
01FE: EE29           jr      ne/nz,%0252
0200: 4D04 82C6      test    %82c6
0204: EE3F           jr      ne/nz,%0284
0206: 4D05 82C2 0000 ld      %82c2,#%0000
020C: 4D05 82C4 0000 ld      %82c4,#%0000
0212: 4D05 82C6 0000 ld      %82c6,#%0000
0218: 4D05 82C0 0000 ld      %82c0,#%0000
021E: 9E08           ret     
0220: 4D01 82C2 0001 cp      %82c2,#%0001
0226: E60E           jr      eq/z,%0244
0228: 4D01 82C2 0002 cp      %82c2,#%0002
022E: E6EB           jr      eq/z,%0206
0230: 6B00 82C2      dec     %82c2,1
0234: 4D01 82C2 00D2 cp      %82c2,#%00d2
023A: 9E0E           ret     ne/nz
023C: 4D05 82C8 0001 ld      %82c8,#%0001
0242: 9E08           ret     
0244: 4D05 82C2 00F0 ld      %82c2,#%00f0
024A: 4D05 82C0 0003 ld      %82c0,#%0003
0250: 9E08           ret     
0252: 4D01 82C4 0001 cp      %82c4,#%0001
0258: E60E           jr      eq/z,%0276
025A: 4D01 82C4 0002 cp      %82c4,#%0002
0260: E6D2           jr      eq/z,%0206
0262: 6B00 82C4      dec     %82c4,1
0266: 4D01 82C4 00A0 cp      %82c4,#%00a0
026C: 9E0E           ret     ne/nz
026E: 4D05 82CA 0001 ld      %82ca,#%0001
0274: 9E08           ret     
0276: 4D05 82C4 00FA ld      %82c4,#%00fa
027C: 4D05 82C0 0003 ld      %82c0,#%0003
0282: 9E08           ret     
0284: 4D01 82C6 0001 cp      %82c6,#%0001
028A: E60E           jr      eq/z,%02a8
028C: 4D01 82C6 0002 cp      %82c6,#%0002
0292: E6B9           jr      eq/z,%0206
0294: 6B00 82C6      dec     %82c6,1
0298: 4D01 82C6 0122 cp      %82c6,#%0122
029E: 9E0E           ret     ne/nz
02A0: 4D05 82CC 0001 ld      %82cc,#%0001
02A6: 9E08           ret     
02A8: 4D05 82C6 012C ld      %82c6,#%012c
02AE: 4D05 82C0 0003 ld      %82c0,#%0003
02B4: 9E08           ret     
02B6: 02C0           subb    rh0,@r12
02B8: 02C6           subb    rh6,@r12
02BA: 02D8           subb    rl0,@r13
02BC: 02DC           subb    rl4,@r13
02BE: 02FC           subb    rl4,@r15
02C0: 0316           sub     r6,@r1
02C2: 03A8           sub     r8,@r10
02C4: 03D0           sub     r0,@r13
02C6: 0406 042A      orb     rh6,#%2a
02CA: 0456           orb     rh6,@r5
02CC: 046C           orb     rl4,@r6
02CE: 04D6           orb     rh6,@r13
02D0: 04EC           orb     rl4,@r14
02D2: 052E           or      r14,@r2
02D4: 0542           or      r2,@r4
02D6: 059A           or      r10,@r9
02D8: 0602 063C      andb    rh2,#%3c
02DC: 066A           andb    rl2,@r6
02DE: 072A           and     r10,@r2
02E0: 0808 0852      xorb    rl0,#%52
02E4: 08CC           xorb    rl4,@r12
02E6: 09E0           xor     r0,@r14
02E8: 0A2E           cpb     rl6,@r2
02EA: 0ABA           cpb     rl2,@r11
02EC: 0B2C           cp      r12,@r2
02EE: 0BD0           cp      r0,@r13
02F0: 0C34           testb   @r3
02F2: 0C68           clrb    @r6
02F4: 0C86           tsetb   @r8
02F6: 0316           sub     r6,@r1
02F8: 0316           sub     r6,@r1
02FA: 0316           sub     r6,@r1
02FC: 0CA0           comb    @r10
02FE: 0D4E           .word   #%0d4e
0300: 0E5C           ext0e   #%5c
0302: 0F32           ext0f   #%32
0304: 0F5C           ext0f   #%5c
0306: 0F32           ext0f   #%32
0308: 0FDA           ext0f   #%da
030A: 0F32           ext0f   #%32
030C: 1086           cpl     rr6,@r8
030E: 10A8           cpl     rr8,@r10
0310: 111A           pushl   @r1,@r10
0312: 11AA           pushl   @r10,@r10
0314: 11BC           pushl   @r11,@r12
0316: 8D08           clr     r0
0318: 8D18           clr     r1
031A: 6F00 82C0      ld      %82c0,r0
031E: 6F00 82C2      ld      %82c2,r0
0322: 6F00 82C4      ld      %82c4,r0
0326: 6F00 82C6      ld      %82c6,r0
032A: 6F00 82C8      ld      %82c8,r0
032E: 6F00 82CA      ld      %82ca,r0
0332: 6F00 82CC      ld      %82cc,r0
0336: 6F00 8020      ld      %8020,r0
033A: 6F00 8150      ld      %8150,r0
033E: 6F00 81A6      ld      %81a6,r0
0342: 5D00 8180      ldl     %8180,rr0
0346: 5D00 8184      ldl     %8184,rr0
034A: 5D00 8008      ldl     %8008,rr0
034E: 5D00 81E0      ldl     %81e0,rr0
0352: 5D00 800C      ldl     %800c,rr0
0356: 5D00 A870      ldl     %a870,rr0
035A: 6F00 A878      ld      %a878,r0
035E: 5D00 A874      ldl     %a874,rr0
0362: 6F00 81A0      ld      %81a0,r0
0366: 6F00 81AC      ld      %81ac,r0
036A: 6F00 80F0      ld      %80f0,r0
036E: 6F00 A830      ld      %a830,r0
0372: 5D00 A9C0      ldl     %a9c0,rr0
0376: 4D05 A9C4 003C ld      %a9c4,#%003c
037C: 5D00 A9C8      ldl     %a9c8,rr0
0380: 1402 0000 9999 ldl     rr2,#%00009999
0386: 5D02 A834      ldl     %a834,rr2
038A: 2101 AA00      ld      r1,#%aa00
038E: 2100 0042      ld      r0,#%0042
0392: 0D15 FFFF      ld      @r1,#%ffff
0396: A911           inc     r1,2
0398: F084           djnz    r0,%0392
039A: 4D08 81B0      clr     %81b0
039E: 4D08 883C      clr     %883c
03A2: 6900 8014      inc     %8014,1
03A6: 9E08           ret     
03A8: 5F00 05DA      call    %05da
03AC: 4D04 81AC      test    %81ac
03B0: EE04           jr      ne/nz,%03ba
03B2: 4D05 81AC 001E ld      %81ac,#%001e
03B8: 9E08           ret     
03BA: 6B00 81AC      dec     %81ac,1
03BE: 9E0E           ret     ne/nz
03C0: 6900 8014      inc     %8014,1
03C4: 4D08 8022      clr     %8022
03C8: 4D05 8020 0073 ld      %8020,#%0073
03CE: 9E08           ret     
03D0: 5F00 05DA      call    %05da
03D4: 6700 8030      bit     %8030,0
03D8: 9E06           ret     eq/z
03DA: 4D08 8020      clr     %8020
03DE: 5400 8038      ldl     rr0,%8038
03E2: A091           ldb     rh1,rl1
03E4: A089           ldb     rl1,rl0
03E6: 8D08           clr     r0
03E8: 5F00 353A      call    %353a
03EC: B305 0004      slll    rr0,#4
03F0: 5D00 81E0      ldl     %81e0,rr0
03F4: 4D05 8012 0001 ld      %8012,#%0001
03FA: 4D05 8014 0000 ld      %8014,#%0000
0400: 6900 8014      inc     %8014,1
0404: 9E08           ret     
0406: 5F00 05DA      call    %05da
040A: 4D05 8104 0001 ld      %8104,#%0001
0410: 4D04 81AC      test    %81ac
0414: EE04           jr      ne/nz,%041e
0416: 4D05 81AC 01F4 ld      %81ac,#%01f4
041C: 9E08           ret     
041E: 6B00 81AC      dec     %81ac,1
0422: 9E0E           ret     ne/nz
0424: 6900 8014      inc     %8014,1
0428: 9E08           ret     
042A: 5F00 05DA      call    %05da
042E: 4D05 8104 0001 ld      %8104,#%0001
0434: 610E 81B0      ld      r14,%81b0
0438: 070E 007E      and     r14,#%007e
043C: 4DE5 AA00 0005 ld      %aa00(r14),#%0005
0442: A9E1           inc     r14,2
0444: 070E 007E      and     r14,#%007e
0448: 4DE5 AA00 FFFF ld      %aa00(r14),#%ffff
044E: 6F0E 81B0      ld      %81b0,r14
0452: 5E08 06A8      jp      %06a8
0456: 5F00 05DA      call    %05da
045A: 4D08 81F4      clr     %81f4
045E: 4D08 A830      clr     %a830
0462: 4D05 81FC 0002 ld      %81fc,#%0002
0468: 5E08 072A      jp      %072a
046C: 5F00 05DA      call    %05da
0470: 4D05 81FA 0007 ld      %81fa,#%0007
0476: 5F00 0A2E      call    %0a2e
047A: 610E 81B0      ld      r14,%81b0
047E: 070E 007E      and     r14,#%007e
0482: 4DE5 AA00 0000 ld      %aa00(r14),#%0000
0488: A9E1           inc     r14,2
048A: 070E 007E      and     r14,#%007e
048E: 4DE5 AA00 FFFF ld      %aa00(r14),#%ffff
0494: 6F0E 81B0      ld      %81b0,r14
0498: 610E 81B0      ld      r14,%81b0
049C: 070E 007E      and     r14,#%007e
04A0: 4DE5 AA00 0016 ld      %aa00(r14),#%0016
04A6: A9E1           inc     r14,2
04A8: 070E 007E      and     r14,#%007e
04AC: 4DE5 AA00 FFFF ld      %aa00(r14),#%ffff
04B2: 6F0E 81B0      ld      %81b0,r14
04B6: 610E 81B0      ld      r14,%81b0
04BA: 070E 007E      and     r14,#%007e
04BE: 4DE5 AA00 0006 ld      %aa00(r14),#%0006
04C4: A9E1           inc     r14,2
04C6: 070E 007E      and     r14,#%007e
04CA: 4DE5 AA00 FFFF ld      %aa00(r14),#%ffff
04D0: 6F0E 81B0      ld      %81b0,r14
04D4: 9E08           ret     
04D6: 5F00 05DA      call    %05da
04DA: 5400 81E0      ldl     rr0,%81e0
04DE: C02D           ldb     rh0,#%2d
04E0: 210C 98CC      ld      r12,#%98cc
04E4: 5F00 1C72      call    %1c72
04E8: 5E08 0ABA      jp      %0aba
04EC: 5F00 05DA      call    %05da
04F0: D84A           calr    %145e
04F2: D833           calr    %148e
04F4: 5F00 1572      call    %1572
04F8: 5F00 201A      call    %201a
04FC: 5F00 1930      call    %1930
0500: 5F00 186E      call    %186e
0504: 5F00 1B58      call    %1b58
0508: 5F00 165A      call    %165a
050C: 5F00 16BE      call    %16be
0510: 4D04 81AC      test    %81ac
0514: EE04           jr      ne/nz,%051e
0516: 4D05 81AC 0708 ld      %81ac,#%0708
051C: 9E08           ret     
051E: 6B00 81AC      dec     %81ac,1
0522: 9E0E           ret     ne/nz
0524: 6900 8014      inc     %8014,1
0528: 4D08 80F0      clr     %80f0
052C: 9E08           ret     
052E: 5F00 05DA      call    %05da
0532: 4D08 8022      clr     %8022
0536: 4D05 8020 0073 ld      %8020,#%0073
053C: 6900 8014      inc     %8014,1
0540: 9E08           ret     
0542: 5F00 05DA      call    %05da
0546: 6700 8030      bit     %8030,0
054A: 9E06           ret     eq/z
054C: 4D08 8020      clr     %8020
0550: 610E 81B0      ld      r14,%81b0
0554: 070E 007E      and     r14,#%007e
0558: 4DE5 AA00 0014 ld      %aa00(r14),#%0014
055E: A9E1           inc     r14,2
0560: 070E 007E      and     r14,#%007e
0564: 4DE5 AA00 FFFF ld      %aa00(r14),#%ffff
056A: 6F0E 81B0      ld      %81b0,r14
056E: 5400 8038      ldl     rr0,%8038
0572: A091           ldb     rh1,rl1
0574: A089           ldb     rl1,rl0
0576: 8D08           clr     r0
0578: 5F00 353A      call    %353a
057C: B305 0004      slll    rr0,#4
0580: 5D00 81E0      ldl     %81e0,rr0
0584: C02D           ldb     rh0,#%2d
0586: 210C 98CC      ld      r12,#%98cc
058A: 5F00 1C72      call    %1c72
058E: 6900 8014      inc     %8014,1
0592: 4D05 81AC 0275 ld      %81ac,#%0275
0598: 9E08           ret     
059A: 5F00 05DA      call    %05da
059E: 5F00 1DCE      call    %1dce
05A2: 4D04 81AC      test    %81ac
05A6: EE04           jr      ne/nz,%05b0
05A8: 4D05 81AC 0001 ld      %81ac,#%0001
05AE: 9E08           ret     
05B0: 6B00 81AC      dec     %81ac,1
05B4: 9E0E           ret     ne/nz
05B6: 6900 8014      inc     %8014,1
05BA: 4D05 8014 0001 ld      %8014,#%0001
05C0: 9E08           ret     
05C2: 4D04 8104      test    %8104
05C6: 4D05 8106 0001 ld      %8106,#%0001
05CC: 9E06           ret     eq/z
05CE: 4D04 814C      test    %814c
05D2: 9E0E           ret     ne/nz
05D4: 4D08 8106      clr     %8106
05D8: 9E08           ret     
05DA: D00D           calr    %05c2
05DC: 6100 81AA      ld      r0,%81aa
05E0: 0700 00FF      and     r0,#%00ff
05E4: 9E06           ret     eq/z
05E6: 6F00 81A8      ld      %81a8,r0
05EA: 4D08 8104      clr     %8104
05EE: 4D08 81AC      clr     %81ac
05F2: 4D05 8012 0002 ld      %8012,#%0002
05F8: 4D05 8014 0000 ld      %8014,#%0000
05FE: 97F0           pop     r0,@r15
0600: 9E08           ret     
0602: DFE2           calr    %0640
0604: 4D04 81AC      test    %81ac
0608: EE04           jr      ne/nz,%0612
060A: 4D05 81AC 003C ld      %81ac,#%003c
0610: 9E08           ret     
0612: 6B00 81AC      dec     %81ac,1
0616: 9E0E           ret     ne/nz
0618: 6900 8014      inc     %8014,1
061C: 610E 81B0      ld      r14,%81b0
0620: 070E 007E      and     r14,#%007e
0624: 4DE5 AA00 0017 ld      %aa00(r14),#%0017
062A: A9E1           inc     r14,2
062C: 070E 007E      and     r14,#%007e
0630: 4DE5 AA00 FFFF ld      %aa00(r14),#%ffff
0636: 6F0E 81B0      ld      %81b0,r14
063A: 9E08           ret     
063C: DFFF           calr    %0640
063E: 9E08           ret     
0640: 6100 81A8      ld      r0,%81a8
0644: 6101 81AA      ld      r1,%81aa
0648: 0701 00FF      and     r1,#%00ff
064C: 6F01 81A8      ld      %81a8,r1
0650: A910           inc     r1,1
0652: 8310           sub     r0,r1
0654: 9E0E           ret     ne/nz
0656: 4D08 81AC      clr     %81ac
065A: 4D05 8012 0003 ld      %8012,#%0003
0660: 4D05 8014 0000 ld      %8014,#%0000
0666: 97F0           pop     r0,@r15
0668: 9E08           ret     
066A: 5F00 05C2      call    %05c2
066E: 6502 80EC      set     %80ec,2
0672: 610E 81B0      ld      r14,%81b0
0676: 070E 007E      and     r14,#%007e
067A: 4DE5 AA00 0005 ld      %aa00(r14),#%0005
0680: A9E1           inc     r14,2
0682: 070E 007E      and     r14,#%007e
0686: 4DE5 AA00 FFFF ld      %aa00(r14),#%ffff
068C: 6F0E 81B0      ld      %81b0,r14
0690: 8D08           clr     r0
0692: 8D18           clr     r1
0694: 5D00 A870      ldl     %a870,rr0
0698: 6F00 A878      ld      %a878,r0
069C: 5D00 A874      ldl     %a874,rr0
06A0: 5D00 A9C8      ldl     %a9c8,rr0
06A4: 6F00 8020      ld      %8020,r0
06A8: 610E 81B0      ld      r14,%81b0
06AC: 070E 007E      and     r14,#%007e
06B0: 4DE5 AA00 0011 ld      %aa00(r14),#%0011
06B6: A9E1           inc     r14,2
06B8: 070E 007E      and     r14,#%007e
06BC: 4DE5 AA00 FFFF ld      %aa00(r14),#%ffff
06C2: 6F0E 81B0      ld      %81b0,r14
06C6: 8D08           clr     r0
06C8: 8D18           clr     r1
06CA: 6F00 80F0      ld      %80f0,r0
06CE: 6F00 81F8      ld      %81f8,r0
06D2: 6F00 828C      ld      %828c,r0
06D6: 6F00 828E      ld      %828e,r0
06DA: 4D05 8290 0012 ld      %8290,#%0012
06E0: 6F00 8292      ld      %8292,r0
06E4: 6F00 8296      ld      %8296,r0
06E8: 5D00 81B8      ldl     %81b8,rr0
06EC: 6F00 82A6      ld      %82a6,r0
06F0: 4D05 8294 0001 ld      %8294,#%0001
06F6: 4D05 82A4 0001 ld      %82a4,#%0001
06FC: 4D05 82A2 000A ld      %82a2,#%000a
0702: 6F00 81B4      ld      %81b4,r0
0706: 6F00 81FC      ld      %81fc,r0
070A: 4D05 8840 0003 ld      %8840,#%0003
0710: 5F00 1AB6      call    %1ab6
0714: 6101 8146      ld      r1,%8146
0718: 0701 0001      and     r1,#%0001
071C: 0101 0006      add     r1,#%0006
0720: 6F01 8280      ld      %8280,r1
0724: 6900 8014      inc     %8014,1
0728: 9E08           ret     
072A: 610D 81AC      ld      r13,%81ac
072E: A1D1           ld      r1,r13
0730: 0701 0003      and     r1,#%0003
0734: EE14           jr      ne/nz,%075e
0736: B3D1 FFFE      srl     r13,#2
073A: 070D 0007      and     r13,#%0007
073E: 010D 0008      add     r13,#%0008
0742: 610E 81B0      ld      r14,%81b0
0746: 070E 007E      and     r14,#%007e
074A: 6FED AA00      ld      %aa00(r14),r13
074E: A9E1           inc     r14,2
0750: 070E 007E      and     r14,#%007e
0754: 4DE5 AA00 FFFF ld      %aa00(r14),#%ffff
075A: 6F0E 81B0      ld      %81b0,r14
075E: 5F00 07B6      call    %07b6
0762: 4D04 81AC      test    %81ac
0766: EE04           jr      ne/nz,%0770
0768: 4D05 81AC 00DC ld      %81ac,#%00dc
076E: 9E08           ret     
0770: 6B00 81AC      dec     %81ac,1
0774: 9E0E           ret     ne/nz
0776: 6900 8014      inc     %8014,1
077A: 4D08 8020      clr     %8020
077E: 4D08 A830      clr     %a830
0782: 4D08 8108      clr     %8108
0786: 4D04 8104      test    %8104
078A: 5E0E 0A6A      jp      ne/nz,%0a6a
078E: 610E 81B0      ld      r14,%81b0
0792: 070E 007E      and     r14,#%007e
0796: 4DE5 AA00 0018 ld      %aa00(r14),#%0018
079C: A9E1           inc     r14,2
079E: 070E 007E      and     r14,#%007e
07A2: 4DE5 AA00 FFFF ld      %aa00(r14),#%ffff
07A8: 6F0E 81B0      ld      %81b0,r14
07AC: 4D05 82C2 0001 ld      %82c2,#%0001
07B2: 5E08 0A6A      jp      %0a6a
07B6: 6100 81AC      ld      r0,%81ac
07BA: 0B00 00C8      cp      r0,#%00c8
07BE: 9E0A           ret     gt
07C0: E616           jr      eq/z,%07ee
07C2: 0B00 00B4      cp      r0,#%00b4
07C6: EA1A           jr      gt,%07fc
07C8: 9E0E           ret     ne/nz
07CA: 4D08 8020      clr     %8020
07CE: 2104 8055      ld      r4,#%8055
07D2: 5400 A9C0      ldl     rr0,%a9c0
07D6: DB02           calr    %11d4
07D8: 8D08           clr     r0
07DA: 8D18           clr     r1
07DC: 5D00 A9C0      ldl     %a9c0,rr0
07E0: 4D05 8022 0005 ld      %8022,#%0005
07E6: 4D05 8020 0073 ld      %8020,#%0073
07EC: 9E08           ret     
07EE: 4D05 8022 0004 ld      %8022,#%0004
07F4: 4D05 8020 0073 ld      %8020,#%0073
07FA: 9E08           ret     
07FC: 6700 8030      bit     %8030,0
0800: 9E06           ret     eq/z
0802: 4D08 8020      clr     %8020
0806: 9E08           ret     
0808: DE22           calr    %0bc6
080A: 4D04 81AC      test    %81ac
080E: EE04           jr      ne/nz,%0818
0810: 4D05 81AC 00B4 ld      %81ac,#%00b4
0816: 9E08           ret     
0818: 6B00 81AC      dec     %81ac,1
081C: 9E0E           ret     ne/nz
081E: 6900 8014      inc     %8014,1
0822: 610E 81B0      ld      r14,%81b0
0826: 070E 007E      and     r14,#%007e
082A: 4DE5 AA00 0003 ld      %aa00(r14),#%0003
0830: A9E1           inc     r14,2
0832: 070E 007E      and     r14,#%007e
0836: 4DE5 AA00 FFFF ld      %aa00(r14),#%ffff
083C: 6F0E 81B0      ld      %81b0,r14
0840: 4D08 80F0      clr     %80f0
0844: 4D04 8104      test    %8104
0848: 9E0E           ret     ne/nz
084A: 4D05 80F0 0001 ld      %80f0,#%0001
0850: 9E08           ret     
0852: D971           calr    %1572
0854: DE48           calr    %0bc6
0856: 5F00 201A      call    %201a
085A: DA2B           calr    %1406
085C: DA4B           calr    %13c8
085E: 4D04 81AC      test    %81ac
0862: EE04           jr      ne/nz,%086c
0864: 4D05 81AC 0050 ld      %81ac,#%0050
086A: 9E08           ret     
086C: 6B00 81AC      dec     %81ac,1
0870: 9E0E           ret     ne/nz
0872: 6900 8014      inc     %8014,1
0876: 610E 81B0      ld      r14,%81b0
087A: 070E 007E      and     r14,#%007e
087E: 4DE5 AA00 0004 ld      %aa00(r14),#%0004
0884: A9E1           inc     r14,2
0886: 070E 007E      and     r14,#%007e
088A: 4DE5 AA00 FFFF ld      %aa00(r14),#%ffff
0890: 6F0E 81B0      ld      %81b0,r14
0894: 8D08           clr     r0
0896: 6F00 8258      ld      %8258,r0
089A: 6F00 8016      ld      %8016,r0
089E: 6F00 81BC      ld      %81bc,r0
08A2: 6F00 81BE      ld      %81be,r0
08A6: 6F00 81F0      ld      %81f0,r0
08AA: 6F00 81F6      ld      %81f6,r0
08AE: 4D05 81F4 0001 ld      %81f4,#%0001
08B4: 4D05 8204 0001 ld      %8204,#%0001
08BA: 4D05 8296 0001 ld      %8296,#%0001
08C0: 210C 9D98      ld      r12,#%9d98
08C4: 5F00 358A      call    %358a
08C8: 810A           add     r10,r0
08CA: 9E08           ret     
08CC: DA64           calr    %1406
08CE: DA21           calr    %148e
08D0: D9B0           calr    %1572
08D2: 5F00 201A      call    %201a
08D6: 5F00 1930      call    %1930
08DA: 5F00 1952      call    %1952
08DE: DE8D           calr    %0bc6
08E0: 5F00 1B58      call    %1b58
08E4: D946           calr    %165a
08E6: D915           calr    %16be
08E8: 4D04 8016      test    %8016
08EC: 9E06           ret     eq/z
08EE: 4D05 8C60 0001 ld      %8c60,#%0001
08F4: 4D08 80F0      clr     %80f0
08F8: 4D04 81F6      test    %81f6
08FC: E652           jr      eq/z,%09a2
08FE: 6900 8014      inc     %8014,1
0902: 4D08 8296      clr     %8296
0906: 4D05 A830 012C ld      %a830,#%012c
090C: 4D05 8108 012C ld      %8108,#%012c
0912: 4D05 A840 00F0 ld      %a840,#%00f0
0918: 4D05 82A2 0008 ld      %82a2,#%0008
091E: 6101 81FA      ld      r1,%81fa
0922: 0701 0007      and     r1,#%0007
0926: 8111           add     r1,r1
0928: 6110 0992      ld      r0,%0992(r1)
092C: 6F00 A842      ld      %a842,r0
0930: 4D04 81FA      test    %81fa
0934: E617           jr      eq/z,%0964
0936: 6503 80EC      set     %80ec,3
093A: 610E 81B0      ld      r14,%81b0
093E: 070E 007E      and     r14,#%007e
0942: 4DE5 AA00 0019 ld      %aa00(r14),#%0019
0948: A9E1           inc     r14,2
094A: 070E 007E      and     r14,#%007e
094E: 4DE5 AA00 FFFF ld      %aa00(r14),#%ffff
0954: 6F0E 81B0      ld      %81b0,r14
0958: 4D05 82C4 0001 ld      %82c4,#%0001
095E: 6900 A9C8      inc     %a9c8,1
0962: 9E08           ret     
0964: 6504 80EC      set     %80ec,4
0968: 610E 81B0      ld      r14,%81b0
096C: 070E 007E      and     r14,#%007e
0970: 4DE5 AA00 0019 ld      %aa00(r14),#%0019
0976: A9E1           inc     r14,2
0978: 070E 007E      and     r14,#%007e
097C: 4DE5 AA00 FFFF ld      %aa00(r14),#%ffff
0982: 6F0E 81B0      ld      %81b0,r14
0986: 4D05 82C4 0001 ld      %82c4,#%0001
098C: 6900 A9C8      inc     %a9c8,1
0990: 9E08           ret     
0992: 0400 0200      orb     rh0,#%00
0996: 0140           add     r0,@r4
0998: 0100 0080      add     r0,#%0080
099C: 0060           addb    rh0,@r6
099E: 0040           addb    rh0,@r4
09A0: 0020           addb    rh0,@r2
09A2: 4D08 8296      clr     %8296
09A6: 6100 829A      ld      r0,%829a
09AA: 6F00 A878      ld      %a878,r0
09AE: 4D05 8108 0258 ld      %8108,#%0258
09B4: 4D05 8012 0004 ld      %8012,#%0004
09BA: 4D05 8014 0000 ld      %8014,#%0000
09C0: 4D08 A824      clr     %a824
09C4: 4D01 81FC 0002 cp      %81fc,#%0002
09CA: 9E0E           ret     ne/nz
09CC: 4D05 A830 0258 ld      %a830,#%0258
09D2: 5400 A828      ldl     rr0,%a828
09D6: 5D00 A820      ldl     %a820,rr0
09DA: 5D00 A870      ldl     %a870,rr0
09DE: 9E08           ret     
09E0: DF0E           calr    %0bc6
09E2: 5F00 1ED8      call    %1ed8
09E6: 8D08           clr     r0
09E8: 8D18           clr     r1
09EA: 5D00 A820      ldl     %a820,rr0
09EE: 6F00 80E8      ld      %80e8,r0
09F2: 6F00 80E0      ld      %80e0,r0
09F6: 4D01 A842 0000 cp      %a842,#%0000
09FC: 9E0A           ret     gt
09FE: 4D04 81AC      test    %81ac
0A02: EE04           jr      ne/nz,%0a0c
0A04: 4D05 81AC 0028 ld      %81ac,#%0028
0A0A: 9E08           ret     
0A0C: 6B00 81AC      dec     %81ac,1
0A10: 9E0E           ret     ne/nz
0A12: 6900 8014      inc     %8014,1
0A16: 4D08 81F4      clr     %81f4
0A1A: 4D08 A830      clr     %a830
0A1E: 4D08 8108      clr     %8108
0A22: 210C 9D90      ld      r12,#%9d90
0A26: 5F00 358A      call    %358a
0A2A: 8196           add     r6,r9
0A2C: 9E08           ret     
0A2E: 610E 81B0      ld      r14,%81b0
0A32: 070E 007E      and     r14,#%007e
0A36: 4DE5 AA00 0001 ld      %aa00(r14),#%0001
0A3C: A9E1           inc     r14,2
0A3E: 070E 007E      and     r14,#%007e
0A42: 4DE5 AA00 FFFF ld      %aa00(r14),#%ffff
0A48: 6F0E 81B0      ld      %81b0,r14
0A4C: 4D08 81B4      clr     %81b4
0A50: 4D05 8840 0004 ld      %8840,#%0004
0A56: 6900 81FC      inc     %81fc,1
0A5A: 5F00 1B28      call    %1b28
0A5E: 5F00 1AD0      call    %1ad0
0A62: 6900 8014      inc     %8014,1
0A66: 5F00 0840      call    %0840
0A6A: 4D08 A824      clr     %a824
0A6E: 1400 0001 9999 ldl     rr0,#%00019999
0A74: 5D00 A828      ldl     %a828,rr0
0A78: 5D00 A82C      ldl     %a82c,rr0
0A7C: 8D08           clr     r0
0A7E: 8D18           clr     r1
0A80: 5D00 818C      ldl     %818c,rr0
0A84: 5D00 828C      ldl     %828c,rr0
0A88: 6F00 8258      ld      %8258,r0
0A8C: 6F00 8204      ld      %8204,r0
0A90: 6F00 821C      ld      %821c,r0
0A94: 6F00 8190      ld      %8190,r0
0A98: 6F00 8222      ld      %8222,r0
0A9C: 6F00 825C      ld      %825c,r0
0AA0: 6F00 8218      ld      %8218,r0
0AA4: 5D00 8180      ldl     %8180,rr0
0AA8: 6F00 81F0      ld      %81f0,r0
0AAC: 6F00 829A      ld      %829a,r0
0AB0: 6100 800C      ld      r0,%800c
0AB4: 6F00 819C      ld      %819c,r0
0AB8: 9E08           ret     
0ABA: DAA5           calr    %1572
0ABC: DF7C           calr    %0bc6
0ABE: 5F00 201A      call    %201a
0AC2: DB5F           calr    %1406
0AC4: DBB1           calr    %1364
0AC6: DB75           calr    %13de
0AC8: 4D04 81AC      test    %81ac
0ACC: EE04           jr      ne/nz,%0ad6
0ACE: 4D05 81AC 00F0 ld      %81ac,#%00f0
0AD4: 9E08           ret     
0AD6: 6B00 81AC      dec     %81ac,1
0ADA: 9E0E           ret     ne/nz
0ADC: 6900 8014      inc     %8014,1
0AE0: 610E 81B0      ld      r14,%81b0
0AE4: 070E 007E      and     r14,#%007e
0AE8: 4DE5 AA00 0002 ld      %aa00(r14),#%0002
0AEE: A9E1           inc     r14,2
0AF0: 070E 007E      and     r14,#%007e
0AF4: 4DE5 AA00 FFFF ld      %aa00(r14),#%ffff
0AFA: 6F0E 81B0      ld      %81b0,r14
0AFE: 8D08           clr     r0
0B00: 6F00 8258      ld      %8258,r0
0B04: 6F00 8016      ld      %8016,r0
0B08: 6F00 81BC      ld      %81bc,r0
0B0C: 6F00 81BE      ld      %81be,r0
0B10: 6F00 81F0      ld      %81f0,r0
0B14: 6F00 81F6      ld      %81f6,r0
0B18: 6F00 828A      ld      %828a,r0
0B1C: A900           inc     r0,1
0B1E: 6F00 8204      ld      %8204,r0
0B22: 6F00 A848      ld      %a848,r0
0B26: 6F00 8296      ld      %8296,r0
0B2A: 9E08           ret     
0B2C: DB94           calr    %1406
0B2E: DB51           calr    %148e
0B30: DAE0           calr    %1572
0B32: 5F00 201A      call    %201a
0B36: D904           calr    %1930
0B38: D8F4           calr    %1952
0B3A: D8BA           calr    %19c8
0B3C: DFBC           calr    %0bc6
0B3E: 5F00 1B58      call    %1b58
0B42: DA75           calr    %165a
0B44: DA44           calr    %16be
0B46: DA20           calr    %1708
0B48: 5F00 1C3E      call    %1c3e
0B4C: 4D04 81F8      test    %81f8
0B50: EE28           jr      ne/nz,%0ba2
0B52: 4D04 8016      test    %8016
0B56: 9E06           ret     eq/z
0B58: 6902 8014      inc     %8014,3
0B5C: 4D05 82A0 FFFF ld      %82a0,#%ffff
0B62: 4D08 80F0      clr     %80f0
0B66: 4D08 A824      clr     %a824
0B6A: 4D08 8296      clr     %8296
0B6E: 4D05 8C60 0001 ld      %8c60,#%0001
0B74: 6100 829A      ld      r0,%829a
0B78: 6F00 A878      ld      %a878,r0
0B7C: 4D05 8108 0258 ld      %8108,#%0258
0B82: 4D01 81FC 0004 cp      %81fc,#%0004
0B88: 9E06           ret     eq/z
0B8A: 5400 A82C      ldl     rr0,%a82c
0B8E: 5D00 A828      ldl     %a828,rr0
0B92: 5D00 A820      ldl     %a820,rr0
0B96: 5D00 A870      ldl     %a870,rr0
0B9A: 4D05 A830 0258 ld      %a830,#%0258
0BA0: 9E08           ret     
0BA2: 6900 8014      inc     %8014,1
0BA6: 5400 818C      ldl     rr0,%818c
0BAA: 5D00 8282      ldl     %8282,rr0
0BAE: 4D08 8296      clr     %8296
0BB2: 4D05 8294 FFFF ld      %8294,#%ffff
0BB8: 4D05 82A6 0001 ld      %82a6,#%0001
0BBE: 4D05 82C6 0001 ld      %82c6,#%0001
0BC4: 9E08           ret     
0BC6: D990           calr    %18a8
0BC8: D8CB           calr    %1a34
0BCA: D8BE           calr    %1a50
0BCC: 5E08 17E2      jp      %17e2
0BD0: DBC1           calr    %1450
0BD2: DB63           calr    %150e
0BD4: DAFC           calr    %15de
0BD6: 5F00 201A      call    %201a
0BDA: D956           calr    %1930
0BDC: D946           calr    %1952
0BDE: D90C           calr    %19c8
0BE0: D00E           calr    %0bc6
0BE2: 5F00 1BF2      call    %1bf2
0BE6: DAC7           calr    %165a
0BE8: DA96           calr    %16be
0BEA: DC6E           calr    %1310
0BEC: 4D04 8016      test    %8016
0BF0: 9E06           ret     eq/z
0BF2: 6900 8014      inc     %8014,1
0BF6: 6900 A9C8      inc     %a9c8,1
0BFA: 4D08 A824      clr     %a824
0BFE: 5400 A82C      ldl     rr0,%a82c
0C02: 5D00 A828      ldl     %a828,rr0
0C06: 5D00 A820      ldl     %a820,rr0
0C0A: 5D00 A870      ldl     %a870,rr0
0C0E: 4D05 A830 0258 ld      %a830,#%0258
0C14: 6100 829A      ld      r0,%829a
0C18: 6F00 A878      ld      %a878,r0
0C1C: 4D05 8108 0258 ld      %8108,#%0258
0C22: 8D08           clr     r0
0C24: 8D18           clr     r1
0C26: 5D00 828C      ldl     %828c,rr0
0C2A: 6F00 80E8      ld      %80e8,r0
0C2E: 6F00 80E0      ld      %80e0,r0
0C32: 9E08           ret     
0C34: D037           calr    %0bc8
0C36: DC94           calr    %1310
0C38: 4D04 81AC      test    %81ac
0C3C: EE04           jr      ne/nz,%0c46
0C3E: 4D05 81AC 001E ld      %81ac,#%001e
0C44: 9E08           ret     
0C46: 6B00 81AC      dec     %81ac,1
0C4A: 9E0E           ret     ne/nz
0C4C: 6900 8014      inc     %8014,1
0C50: 4D08 A848      clr     %a848
0C54: 6100 A802      ld      r0,%a802
0C58: 6F00 82A0      ld      %82a0,r0
0C5C: 210C 9E0A      ld      r12,#%9e0a
0C60: 5F00 358A      call    %358a
0C64: 8118           add     r8,r1
0C66: 9E08           ret     
0C68: D051           calr    %0bc8
0C6A: DCE5           calr    %12a2
0C6C: 4D04 81AC      test    %81ac
0C70: EE04           jr      ne/nz,%0c7a
0C72: 4D05 81AC 001E ld      %81ac,#%001e
0C78: 9E08           ret     
0C7A: 6B00 81AC      dec     %81ac,1
0C7E: 9E0E           ret     ne/nz
0C80: 6900 8014      inc     %8014,1
0C84: 9E08           ret     
0C86: D060           calr    %0bc8
0C88: D9C2           calr    %1906
0C8A: DCF5           calr    %12a2
0C8C: DD21           calr    %124c
0C8E: 8DD4           test    r13
0C90: 9E06           ret     eq/z
0C92: 4D05 8012 0004 ld      %8012,#%0004
0C98: 4D05 8014 0000 ld      %8014,#%0000
0C9E: 9E08           ret     
0CA0: 4D08 A830      clr     %a830
0CA4: 4D05 8108 0001 ld      %8108,#%0001
0CAA: D072           calr    %0bc8
0CAC: D9D4           calr    %1906
0CAE: 4D05 A880 0004 ld      %a880,#%0004
0CB4: 4D05 A882 0004 ld      %a882,#%0004
0CBA: DC50           calr    %141c
0CBC: 5400 81B8      ldl     rr0,%81b8
0CC0: 5D00 A874      ldl     %a874,rr0
0CC4: 8D08           clr     r0
0CC6: 6F00 80E8      ld      %80e8,r0
0CCA: 6F00 80E0      ld      %80e0,r0
0CCE: 6E08 802D      ldb     %802d,rl0
0CD2: 6E08 802F      ldb     %802f,rl0
0CD6: 6E08 807D      ldb     %807d,rl0
0CDA: 6E08 807F      ldb     %807f,rl0
0CDE: 5400 81B8      ldl     rr0,%81b8
0CE2: B305 FFF4      srll    rr0,#12
0CE6: 5F00 34DE      call    %34de
0CEA: 6E09 8025      ldb     %8025,rl1
0CEE: 6E01 8027      ldb     %8027,rh1
0CF2: 4D04 82A6      test    %82a6
0CF6: E60B           jr      eq/z,%0d0e
0CF8: 5400 A84A      ldl     rr0,%a84a
0CFC: 0700 000F      and     r0,#%000f
0D00: 5F00 34DE      call    %34de
0D04: 6E09 8029      ldb     %8029,rl1
0D08: 6E01 802B      ldb     %802b,rh1
0D0C: E806           jr      %0d1a
0D0E: 4C05 8029 0000 ldb     %8029,#%29
0D14: 4C05 802B 0000 ldb     %802b,#%2b
0D1A: 4D05 8022 0002 ld      %8022,#%0002
0D20: 4D05 8020 0073 ld      %8020,#%0073
0D26: DFFB           calr    %0d32
0D28: 4D08 810E      clr     %810e
0D2C: 6900 8014      inc     %8014,1
0D30: 9E08           ret     
0D32: 6100 800E      ld      r0,%800e
0D36: 0700 00FF      and     r0,#%00ff
0D3A: A101           ld      r1,r0
0D3C: 4300 81A8      sub     r0,%81a8
0D40: 6F01 81A8      ld      %81a8,r1
0D44: 9E06           ret     eq/z
0D46: 4D05 810E 0001 ld      %810e,#%0001
0D4C: 9E08           ret     
0D4E: DC9A           calr    %141c
0D50: D010           calr    %0d32
0D52: 6700 8030      bit     %8030,0
0D56: 9E06           ret     eq/z
0D58: 4D08 8020      clr     %8020
0D5C: 6100 8034      ld      r0,%8034
0D60: 6101 8036      ld      r1,%8036
0D64: 0701 0001      and     r1,#%0001
0D68: A090           ldb     rh0,rl1
0D6A: 0B00 0064      cp      r0,#%0064
0D6E: EA56           jr      gt,%0e1c
0D70: 0B00 0006      cp      r0,#%0006
0D74: EA06           jr      gt,%0d82
0D76: 0B00 0001      cp      r0,#%0001
0D7A: E606           jr      eq/z,%0d88
0D7C: 6506 80EE      set     %80ee,6
0D80: E805           jr      %0d8c
0D82: 6500 80EE      set     %80ee,0
0D86: E802           jr      %0d8c
0D88: 6505 80EE      set     %80ee,5
0D8C: 4D05 82B4 0A50 ld      %82b4,#%0a50
0D92: 4D05 82B6 0348 ld      %82b6,#%0348
0D98: 6100 800C      ld      r0,%800c
0D9C: 6F00 819C      ld      %819c,r0
0DA0: 4D08 82B0      clr     %82b0
0DA4: 4D05 82A8 0004 ld      %82a8,#%0004
0DAA: 4D05 82AA 0004 ld      %82aa,#%0004
0DB0: 4D05 82AC 0004 ld      %82ac,#%0004
0DB6: 6700 80EE      bit     %80ee,0
0DBA: EE10           jr      ne/nz,%0ddc
0DBC: 610E 81B0      ld      r14,%81b0
0DC0: 070E 007E      and     r14,#%007e
0DC4: 4DE5 AA00 0012 ld      %aa00(r14),#%0012
0DCA: A9E1           inc     r14,2
0DCC: 070E 007E      and     r14,#%007e
0DD0: 4DE5 AA00 FFFF ld      %aa00(r14),#%ffff
0DD6: 6F0E 81B0      ld      %81b0,r14
0DDA: E80F           jr      %0dfa
0DDC: 610E 81B0      ld      r14,%81b0
0DE0: 070E 007E      and     r14,#%007e
0DE4: 4DE5 AA00 0015 ld      %aa00(r14),#%0015
0DEA: A9E1           inc     r14,2
0DEC: 070E 007E      and     r14,#%007e
0DF0: 4DE5 AA00 FFFF ld      %aa00(r14),#%ffff
0DF6: 6F0E 81B0      ld      %81b0,r14
0DFA: 6900 8014      inc     %8014,1
0DFE: DCF2           calr    %141c
0E00: 4D05 82B2 0001 ld      %82b2,#%0001
0E06: 4D01 A880 0004 cp      %a880,#%0004
0E0C: 9E09           ret     ge
0E0E: 4D01 A882 0004 cp      %a882,#%0004
0E14: 9E09           ret     ge
0E16: 4D08 82B2      clr     %82b2
0E1A: 9E08           ret     
0E1C: 4C05 802D 0000 ldb     %802d,#%2d
0E22: 4C05 802F 0000 ldb     %802f,#%2f
0E28: 4C05 807D 0000 ldb     %807d,#%7d
0E2E: 4C05 807F 0000 ldb     %807f,#%7f
0E34: 610E 81B0      ld      r14,%81b0
0E38: 070E 007E      and     r14,#%007e
0E3C: 4DE5 AA00 0013 ld      %aa00(r14),#%0013
0E42: A9E1           inc     r14,2
0E44: 070E 007E      and     r14,#%007e
0E48: 4DE5 AA00 FFFF ld      %aa00(r14),#%ffff
0E4E: 6F0E 81B0      ld      %81b0,r14
0E52: 6507 80EC      set     %80ec,7
0E56: 6905 8014      inc     %8014,6
0E5A: 9E08           ret     
0E5C: D096           calr    %0d32
0E5E: 6100 800C      ld      r0,%800c
0E62: 6101 819C      ld      r1,%819c
0E66: 6F00 819C      ld      %819c,r0
0E6A: 8289           subb    rl1,rl0
0E6C: B110           extsb   r1
0E6E: 8D12           neg     r1
0E70: E603           jr      eq/z,%0e78
0E72: 4D05 82B6 04B0 ld      %82b6,#%04b0
0E78: 6102 82B0      ld      r2,%82b0
0E7C: 6120 82A8      ld      r0,%82a8(r2)
0E80: 8110           add     r0,r1
0E82: 6F20 82A8      ld      %82a8(r2),r0
0E86: 2102 82A8      ld      r2,#%82a8
0E8A: 2103 0003      ld      r3,#%0003
0E8E: 8D18           clr     r1
0E90: 2120           ld      r0,@r2
0E92: B301 FFFE      srl     r0,#2
0E96: 0700 001F      and     r0,#%001f
0E9A: 0B00 0000      cp      r0,#%0000
0E9E: E106           jr      lt,%0eac
0EA0: 0B00 001B      cp      r0,#%001b
0EA4: E205           jr      le,%0eb0
0EA6: 2100 001B      ld      r0,#%001b
0EAA: E802           jr      %0eb0
0EAC: 2100 0000      ld      r0,#%0000
0EB0: B311 0005      sll     r1,#5
0EB4: 8101           add     r1,r0
0EB6: A921           inc     r2,2
0EB8: F395           djnz    r3,%0e90
0EBA: 6E09 802D      ldb     %802d,rl1
0EBE: 6E01 802F      ldb     %802f,rh1
0EC2: 6E09 807D      ldb     %807d,rl1
0EC6: 6E01 807F      ldb     %807f,rh1
0ECA: 5F00 1D14      call    %1d14
0ECE: DD5A           calr    %141c
0ED0: 4D04 82B2      test    %82b2
0ED4: E60B           jr      eq/z,%0eec
0ED6: 4D01 A880 0002 cp      %a880,#%0002
0EDC: E91E           jr      ge,%0f1a
0EDE: 4D01 A882 0002 cp      %a882,#%0002
0EE4: E91A           jr      ge,%0f1a
0EE6: 4D08 82B2      clr     %82b2
0EEA: E817           jr      %0f1a
0EEC: 4D01 A880 0006 cp      %a880,#%0006
0EF2: E904           jr      ge,%0efc
0EF4: 4D01 A882 0006 cp      %a882,#%0006
0EFA: E10F           jr      lt,%0f1a
0EFC: 4D05 82B2 0001 ld      %82b2,#%0001
0F02: 4D05 82B6 04B0 ld      %82b6,#%04b0
0F08: 6901 82B0      inc     %82b0,2
0F0C: 4D01 82B0 0004 cp      %82b0,#%0004
0F12: E203           jr      le,%0f1a
0F14: 6902 8014      inc     %8014,3
0F18: 9E08           ret     
0F1A: 4D04 810E      test    %810e
0F1E: EE06           jr      ne/nz,%0f2c
0F20: 6B00 82B6      dec     %82b6,1
0F24: E603           jr      eq/z,%0f2c
0F26: 6B00 82B4      dec     %82b4,1
0F2A: 9E0E           ret     ne/nz
0F2C: 6900 8014      inc     %8014,1
0F30: 9E08           ret     
0F32: D101           calr    %0d32
0F34: 2101 8038      ld      r1,#%8038
0F38: 2102 A900      ld      r2,#%a900
0F3C: 2103 0048      ld      r3,#%0048
0F40: 2110           ld      r0,@r1
0F42: 2F20           ld      @r2,r0
0F44: A911           inc     r1,2
0F46: A921           inc     r2,2
0F48: F385           djnz    r3,%0f40
0F4A: 4D05 8022 0001 ld      %8022,#%0001
0F50: 4D05 8020 0073 ld      %8020,#%0073
0F56: 6900 8014      inc     %8014,1
0F5A: 9E08           ret     
0F5C: 5F00 1D1C      call    %1d1c
0F60: 6700 8030      bit     %8030,0
0F64: 9E06           ret     eq/z
0F66: 4D08 8020      clr     %8020
0F6A: 6305 80EE      res     %80ee,5
0F6E: 6306 80EE      res     %80ee,6
0F72: 6300 80EE      res     %80ee,0
0F76: 6307 80EC      res     %80ec,7
0F7A: 610E 81B0      ld      r14,%81b0
0F7E: 070E 007E      and     r14,#%007e
0F82: 4DE5 AA00 001C ld      %aa00(r14),#%001c
0F88: A9E1           inc     r14,2
0F8A: 070E 007E      and     r14,#%007e
0F8E: 4DE5 AA00 FFFF ld      %aa00(r14),#%ffff
0F94: 6F0E 81B0      ld      %81b0,r14
0F98: 610E 81B0      ld      r14,%81b0
0F9C: 070E 007E      and     r14,#%007e
0FA0: 4DE5 AA00 0000 ld      %aa00(r14),#%0000
0FA6: A9E1           inc     r14,2
0FA8: 070E 007E      and     r14,#%007e
0FAC: 4DE5 AA00 FFFF ld      %aa00(r14),#%ffff
0FB2: 6F0E 81B0      ld      %81b0,r14
0FB6: 610E 81B0      ld      r14,%81b0
0FBA: 070E 007E      and     r14,#%007e
0FBE: 4DE5 AA00 0006 ld      %aa00(r14),#%0006
0FC4: A9E1           inc     r14,2
0FC6: 070E 007E      and     r14,#%007e
0FCA: 4DE5 AA00 FFFF ld      %aa00(r14),#%ffff
0FD0: 6F0E 81B0      ld      %81b0,r14
0FD4: 6904 8014      inc     %8014,5
0FD8: 9E08           ret     
0FDA: D155           calr    %0d32
0FDC: 5F00 1D1C      call    %1d1c
0FE0: DFBA           calr    %106e
0FE2: 4D04 81AC      test    %81ac
0FE6: EE04           jr      ne/nz,%0ff0
0FE8: 4D05 81AC 012C ld      %81ac,#%012c
0FEE: 9E08           ret     
0FF0: 6B00 81AC      dec     %81ac,1
0FF4: 9E0E           ret     ne/nz
0FF6: 6900 8014      inc     %8014,1
0FFA: 6901 8014      inc     %8014,2
0FFE: 4D08 8020      clr     %8020
1002: 6305 80EE      res     %80ee,5
1006: 6306 80EE      res     %80ee,6
100A: 6300 80EE      res     %80ee,0
100E: 6307 80EC      res     %80ec,7
1012: 610E 81B0      ld      r14,%81b0
1016: 070E 007E      and     r14,#%007e
101A: 4DE5 AA00 001C ld      %aa00(r14),#%001c
1020: A9E1           inc     r14,2
1022: 070E 007E      and     r14,#%007e
1026: 4DE5 AA00 FFFF ld      %aa00(r14),#%ffff
102C: 6F0E 81B0      ld      %81b0,r14
1030: 610E 81B0      ld      r14,%81b0
1034: 070E 007E      and     r14,#%007e
1038: 4DE5 AA00 0000 ld      %aa00(r14),#%0000
103E: A9E1           inc     r14,2
1040: 070E 007E      and     r14,#%007e
1044: 4DE5 AA00 FFFF ld      %aa00(r14),#%ffff
104A: 6F0E 81B0      ld      %81b0,r14
104E: 610E 81B0      ld      r14,%81b0
1052: 070E 007E      and     r14,#%007e
1056: 4DE5 AA00 0006 ld      %aa00(r14),#%0006
105C: A9E1           inc     r14,2
105E: 070E 007E      and     r14,#%007e
1062: 4DE5 AA00 FFFF ld      %aa00(r14),#%ffff
1068: 6F0E 81B0      ld      %81b0,r14
106C: 9E08           ret     
106E: 4D04 810E      test    %810e
1072: 9E06           ret     eq/z
1074: 6700 8030      bit     %8030,0
1078: 9E06           ret     eq/z
107A: 4D05 81AC 0001 ld      %81ac,#%0001
1080: 4D08 810E      clr     %810e
1084: 9E08           ret     
1086: D1AB           calr    %0d32
1088: 5F00 1DA8      call    %1da8
108C: D010           calr    %106e
108E: 4D04 81AC      test    %81ac
1092: EE04           jr      ne/nz,%109c
1094: 4D05 81AC 0212 ld      %81ac,#%0212
109A: 9E08           ret     
109C: 6B00 81AC      dec     %81ac,1
10A0: 9E0E           ret     ne/nz
10A2: 6900 8014      inc     %8014,1
10A6: E8AB           jr      %0ffe
10A8: DB2D           calr    %1a50
10AA: DB3C           calr    %1a34
10AC: 4D05 8108 0001 ld      %8108,#%0001
10B2: DC69           calr    %17e2
10B4: DBD8           calr    %1906
10B6: 4D08 80E8      clr     %80e8
10BA: 4D08 80E0      clr     %80e0
10BE: 4D04 81AC      test    %81ac
10C2: EE04           jr      ne/nz,%10cc
10C4: 4D05 81AC 000A ld      %81ac,#%000a
10CA: 9E08           ret     
10CC: 6B00 81AC      dec     %81ac,1
10D0: 9E0E           ret     ne/nz
10D2: 6900 8014      inc     %8014,1
10D6: 4D05 8104 0001 ld      %8104,#%0001
10DC: 4D05 8018 0001 ld      %8018,#%0001
10E2: 4D05 8016 0000 ld      %8016,#%0000
10E8: 4D05 81F0 FFFF ld      %81f0,#%ffff
10EE: 4D05 8022 0004 ld      %8022,#%0004
10F4: 4D05 8020 0073 ld      %8020,#%0073
10FA: 610E 81B0      ld      r14,%81b0
10FE: 070E 007E      and     r14,#%007e
1102: 4DE5 AA00 0010 ld      %aa00(r14),#%0010
1108: A9E1           inc     r14,2
110A: 070E 007E      and     r14,#%007e
110E: 4DE5 AA00 FFFF ld      %aa00(r14),#%ffff
1114: 6F0E 81B0      ld      %81b0,r14
1118: 9E08           ret     
111A: 6700 8030      bit     %8030,0
111E: 9E06           ret     eq/z
1120: 4D08 8020      clr     %8020
1124: 6900 8014      inc     %8014,1
1128: 2104 803D      ld      r4,#%803d
112C: 2101 0001      ld      r1,#%0001
1130: 8D08           clr     r0
1132: DF9B           calr    %11fe
1134: 2104 8045      ld      r4,#%8045
1138: 5400 81B8      ldl     rr0,%81b8
113C: B305 FFF4      srll    rr0,#12
1140: DFB7           calr    %11d4
1142: 2104 804D      ld      r4,#%804d
1146: 5400 A9C0      ldl     rr0,%a9c0
114A: DFBC           calr    %11d4
114C: 2104 8055      ld      r4,#%8055
1150: 5400 A9C0      ldl     rr0,%a9c0
1154: DFC1           calr    %11d4
1156: 8D08           clr     r0
1158: 8D18           clr     r1
115A: 5D00 A9C0      ldl     %a9c0,rr0
115E: 6105 A9C8      ld      r5,%a9c8
1162: 8D54           test    r5
1164: 9E06           ret     eq/z
1166: 2104 8059      ld      r4,#%8059
116A: 2101 0001      ld      r1,#%0001
116E: DFA9           calr    %121e
1170: AB50           dec     r5,1
1172: 9E06           ret     eq/z
1174: 2104 805D      ld      r4,#%805d
1178: 2101 0001      ld      r1,#%0001
117C: DFB0           calr    %121e
117E: AB50           dec     r5,1
1180: 9E06           ret     eq/z
1182: 2104 8061      ld      r4,#%8061
1186: 2101 0001      ld      r1,#%0001
118A: DFB7           calr    %121e
118C: AB50           dec     r5,1
118E: 9E06           ret     eq/z
1190: 2104 8065      ld      r4,#%8065
1194: 2101 0001      ld      r1,#%0001
1198: DFBE           calr    %121e
119A: AB50           dec     r5,1
119C: 9E06           ret     eq/z
119E: 2104 8069      ld      r4,#%8069
11A2: 2101 0001      ld      r1,#%0001
11A6: DFC5           calr    %121e
11A8: 9E08           ret     
11AA: 4D05 8022 0005 ld      %8022,#%0005
11B0: 4D05 8020 0073 ld      %8020,#%0073
11B6: 6900 8014      inc     %8014,1
11BA: 9E08           ret     
11BC: 6700 8030      bit     %8030,0
11C0: 9E06           ret     eq/z
11C2: 4D08 8020      clr     %8020
11C6: 4D05 8012 0001 ld      %8012,#%0001
11CC: 4D05 8014 0000 ld      %8014,#%0000
11D2: 9E08           ret     
11D4: 93F2           push    @r15,r2
11D6: 0049           addb    rl1,@r4
11D8: B090           dab     rl1
11DA: 2E49           ldb     @r4,rl1
11DC: AB41           dec     r4,2
11DE: 204A           ldb     rl2,@r4
11E0: B4A1           adcb    rh1,rl2
11E2: B010           dab     rh1
11E4: 2E41           ldb     @r4,rh1
11E6: AB41           dec     r4,2
11E8: 204A           ldb     rl2,@r4
11EA: B4A8           adcb    rl0,rl2
11EC: B080           dab     rl0
11EE: 2E48           ldb     @r4,rl0
11F0: AB41           dec     r4,2
11F2: 204A           ldb     rl2,@r4
11F4: B4A0           adcb    rh0,rl2
11F6: B000           dab     rh0
11F8: 2E40           ldb     @r4,rh0
11FA: 97F2           pop     r2,@r15
11FC: 9E08           ret     
11FE: 93F2           push    @r15,r2
1200: 0049           addb    rl1,@r4
1202: B090           dab     rl1
1204: 2E49           ldb     @r4,rl1
1206: AB41           dec     r4,2
1208: 204A           ldb     rl2,@r4
120A: B4A1           adcb    rh1,rl2
120C: B010           dab     rh1
120E: 2E41           ldb     @r4,rh1
1210: AB41           dec     r4,2
1212: 204A           ldb     rl2,@r4
1214: B4A8           adcb    rl0,rl2
1216: B080           dab     rl0
1218: 2E48           ldb     @r4,rl0
121A: 97F2           pop     r2,@r15
121C: 9E08           ret     
121E: 93F2           push    @r15,r2
1220: 0049           addb    rl1,@r4
1222: B090           dab     rl1
1224: 2E49           ldb     @r4,rl1
1226: AB41           dec     r4,2
1228: 204A           ldb     rl2,@r4
122A: B4A1           adcb    rh1,rl2
122C: B010           dab     rh1
122E: 2E41           ldb     @r4,rh1
1230: 97F2           pop     r2,@r15
1232: 9E08           ret     
1234: 93F0           push    @r15,r0
1236: B281 FFFC      srlb    rl0,#4
123A: DFFF           calr    %123e
123C: 97F0           pop     r0,@r15
123E: 93F0           push    @r15,r0
1240: 0608 0F0F      andb    rl0,#%0f
1244: 2FC0           ld      @r12,r0
1246: A9C1           inc     r12,2
1248: 97F0           pop     r0,@r15
124A: 9E08           ret     
124C: 210D 0000      ld      r13,#%0000
1250: 6B00 82A2      dec     %82a2,1
1254: 9E0E           ret     ne/nz
1256: 4D05 82A2 0008 ld      %82a2,#%0008
125C: 4D04 828A      test    %828a
1260: E608           jr      eq/z,%1272
1262: 6B00 828A      dec     %828a,1
1266: 6501 80EE      set     %80ee,1
126A: 1402 0000 5000 ldl     rr2,#%00005000
1270: E80F           jr      %1290
1272: 4D04 82A0      test    %82a0
1276: E612           jr      eq/z,%129c
1278: E511           jr      mi,%129c
127A: 6B00 82A0      dec     %82a0,1
127E: 6100 82A0      ld      r0,%82a0
1282: 6F00 A802      ld      %a802,r0
1286: 6507 80EE      set     %80ee,7
128A: 1402 0002 0000 ldl     rr2,#%00020000
1290: 5400 81B8      ldl     rr0,%81b8
1294: DCBC           calr    %191e
1296: 5D00 81B8      ldl     %81b8,rr0
129A: 9E08           ret     
129C: 210D 0001      ld      r13,#%0001
12A0: 9E08           ret     
12A2: 6106 8102      ld      r6,%8102
12A6: 0106 0020      add     r6,#%0020
12AA: 2107 0001      ld      r7,#%0001
12AE: 4D04 828A      test    %828a
12B2: EE01           jr      ne/nz,%12b6
12B4: AD76           ex      r6,r7
12B6: A0E0           ldb     rh0,rl6
12B8: 210C 9E0A      ld      r12,#%9e0a
12BC: 5F00 3580      call    %3580
12C0: 5041 5353      cpl     rr1,%5353(r4)
12C4: 494E 4720      xor     r14,%4720(r4)
12C8: 424F 4E55      subb    rl7,%4e55(r4)
12CC: 5320 2035      push    @r2,%2035
12D0: 302A 40FF      ldb     rl2,r2(#%40ff)
12D4: 6101 828A      ld      r1,%828a
12D8: 5F00 353A      call    %353a
12DC: A0E0           ldb     rh0,rl6
12DE: 5F00 1CF2      call    %1cf2
12E2: 4D04 82A0      test    %82a0
12E6: 9E05           ret     mi
12E8: A0F0           ldb     rh0,rl7
12EA: 210C 9E90      ld      r12,#%9e90
12EE: 5F00 3580      call    %3580
12F2: 5449 4D45      ldl     rr9,%4d45(r4)
12F6: 2042           ldb     rh2,@r4
12F8: 4F4E           .word   #%4f4e
12FA: 5553 2032      popl    %2032(r3),@r5
12FE: 3030 2A40      ldb     rh0,r3(#%2a40)
1302: 6101 82A0      ld      r1,%82a0
1306: 5F00 353A      call    %353a
130A: A0F0           ldb     rh0,rl7
130C: 5E08 1CF2      jp      %1cf2
1310: 4D04 8288      test    %8288
1314: EE04           jr      ne/nz,%131e
1316: 4D01 A848 0002 cp      %a848,#%0002
131C: 9E0E           ret     ne/nz
131E: 4D05 A848 0002 ld      %a848,#%0002
1324: 6100 8102      ld      r0,%8102
1328: 0100 0020      add     r0,#%0020
132C: A080           ldb     rh0,rl0
132E: 210C 9E0A      ld      r12,#%9e0a
1332: 5F00 3580      call    %3580
1336: 594F 5552      mult    rr15,%5552(r4)
133A: 2052           ldb     rh2,@r5
133C: 4543 4F52      or      r3,%4f52(r4)
1340: 4420 2020      orb     rh0,%2020(r2)
1344: 2022           ldb     rh2,@r2
1346: 2020           ldb     rh0,@r2
1348: 2053           ldb     rh3,@r5
134A: 4543 40FF      or      r3,%40ff(r4)
134E: 030C 0014      sub     r12,#%0014
1352: 5402 A84A      ldl     rr2,%a84a
1356: B325 0008      slll    rr2,#8
135A: A121           ld      r1,r2
135C: DB54           calr    %1cb6
135E: A039           ldb     rl1,rh3
1360: 5E08 1CF0      jp      %1cf0
1364: 6100 81AC      ld      r0,%81ac
1368: 0B00 00B4      cp      r0,#%00b4
136C: E612           jr      eq/z,%1392
136E: 0B00 0078      cp      r0,#%0078
1372: E618           jr      eq/z,%13a4
1374: 0B00 003C      cp      r0,#%003c
1378: E61E           jr      eq/z,%13b6
137A: 0B00 0001      cp      r0,#%0001
137E: 9E0E           ret     ne/nz
1380: 4D05 8BEC 0004 ld      %8bec,#%0004
1386: 4D04 8106      test    %8106
138A: 9E06           ret     eq/z
138C: 6503 80EE      set     %80ee,3
1390: 9E08           ret     
1392: 4D05 8BEC 0001 ld      %8bec,#%0001
1398: 4D04 8106      test    %8106
139C: 9E06           ret     eq/z
139E: 6504 80EE      set     %80ee,4
13A2: 9E08           ret     
13A4: 4D05 8BEC 0002 ld      %8bec,#%0002
13AA: 4D04 8106      test    %8106
13AE: 9E06           ret     eq/z
13B0: 6504 80EE      set     %80ee,4
13B4: 9E08           ret     
13B6: 4D05 8BEC 0003 ld      %8bec,#%0003
13BC: 4D04 8106      test    %8106
13C0: 9E06           ret     eq/z
13C2: 6504 80EE      set     %80ee,4
13C6: 9E08           ret     
13C8: 6100 81AC      ld      r0,%81ac
13CC: 0B00 0001      cp      r0,#%0001
13D0: 9E0E           ret     ne/nz
13D2: 4D05 8BEC 0004 ld      %8bec,#%0004
13D8: 6503 80EE      set     %80ee,3
13DC: 9E08           ret     
13DE: 6100 81AC      ld      r0,%81ac
13E2: 8D04           test    r0
13E4: 9E06           ret     eq/z
13E6: 0B00 00C8      cp      r0,#%00c8
13EA: 9E09           ret     ge
13EC: 0B00 001E      cp      r0,#%001e
13F0: E206           jr      le,%13fe
13F2: A704           bit     r0,4
13F4: EE04           jr      ne/nz,%13fe
13F6: 4D05 8C60 0001 ld      %8c60,#%0001
13FC: 9E08           ret     
13FE: 4D05 8C60 8001 ld      %8c60,#%8001
1404: 9E08           ret     
1406: 6101 8008      ld      r1,%8008
140A: DFD0           calr    %146c
140C: 6F01 8190      ld      %8190,r1
1410: 6101 800A      ld      r1,%800a
1414: DFD5           calr    %146c
1416: 6F01 8194      ld      %8194,r1
141A: 9E08           ret     
141C: D00C           calr    %1406
141E: 6100 8190      ld      r0,%8190
1422: 4100 A880      add     r0,%a880
1426: 0B00 0007      cp      r0,#%0007
142A: E201           jr      le,%142e
142C: A900           inc     r0,1
142E: B301 FFFF      srl     r0,#1
1432: 6F00 A880      ld      %a880,r0
1436: 6100 8194      ld      r0,%8194
143A: 4100 A882      add     r0,%a882
143E: 0B00 0007      cp      r0,#%0007
1442: E201           jr      le,%1446
1444: A900           inc     r0,1
1446: B301 FFFF      srl     r0,#1
144A: 6F00 A882      ld      %a882,r0
144E: 9E08           ret     
1450: 4D05 8190 0004 ld      %8190,#%0004
1456: 4D05 8194 0000 ld      %8194,#%0000
145C: 9E08           ret     
145E: 4D05 8190 0007 ld      %8190,#%0007
1464: 4D05 8194 0000 ld      %8194,#%0000
146A: 9E08           ret     
146C: 0009 2020      addb    rl1,#%20
1470: 8C18           clrb    rh1
1472: B311 FFFC      srl     r1,#4
1476: 0A09 0404      cpb     rl1,#%04
147A: E707           jr      c/ult,%148a
147C: 0209 0404      subb    rl1,#%04
1480: 0A09 0808      cpb     rl1,#%08
1484: 9E07           ret     c/ult
1486: C907           ldb     rl1,#%07
1488: 9E08           ret     
148A: 8C98           clrb    rl1
148C: 9E08           ret     
148E: 4D04 81BC      test    %81bc
1492: EE0C           jr      ne/nz,%14ac
1494: 6101 8258      ld      r1,%8258
1498: 1900 0100      mult    rr0,#%0100
149C: 1B00 0271      div     rr0,#%0271
14A0: 8D08           clr     r0
14A2: B305 000C      slll    rr0,#12
14A6: 5D00 818C      ldl     %818c,rr0
14AA: 9E08           ret     
14AC: 6100 81BC      ld      r0,%81bc
14B0: A101           ld      r1,r0
14B2: 4D05 81BC 0000 ld      %81bc,#%0000
14B8: 8D12           neg     r1
14BA: 8D04           test    r0
14BC: ED07           jr      pl,%14cc
14BE: 8D02           neg     r0
14C0: 8D12           neg     r1
14C2: 4100 818C      add     r0,%818c
14C6: 0B00 0096      cp      r0,#%0096
14CA: E1E4           jr      lt,%1494
14CC: B10A           exts    rr0
14CE: B305 000A      slll    rr0,#10
14D2: 5600 818C      addl    rr0,%818c
14D6: ED03           jr      pl,%14de
14D8: 1400 0000 0000 ldl     rr0,#%00000000
14DE: 5D00 818C      ldl     %818c,rr0
14E2: A103           ld      r3,r0
14E4: 1902 2710      mult    rr2,#%2710
14E8: 1B02 0100      div     rr2,#%0100
14EC: 6F03 8258      ld      %8258,r3
14F0: E507           jr      mi,%1500
14F2: 0B00 0100      cp      r0,#%0100
14F6: 9E07           ret     c/ult
14F8: 4D05 818C 00FF ld      %818c,#%00ff
14FE: 9E08           ret     
1500: 4D05 818C 0000 ld      %818c,#%0000
1506: 4D05 818E 0000 ld      %818e,#%0000
150C: 9E08           ret     
150E: 5402 818C      ldl     rr2,%818c
1512: 6101 81BE      ld      r1,%81be
1516: 4D05 81BE 0000 ld      %81be,#%0000
151C: 8D14           test    r1
151E: ED01           jr      pl,%1522
1520: 8D12           neg     r1
1522: 8D08           clr     r0
1524: B305 000A      slll    rr0,#10
1528: 9202           subl    rr2,rr0
152A: EF03           jr      nc/uge,%1532
152C: 1402 0000 0000 ldl     rr2,#%00000000
1532: 5D02 818C      ldl     %818c,rr2
1536: 6105 81BC      ld      r5,%81bc
153A: 4D05 81BC 0000 ld      %81bc,#%0000
1540: 8D54           test    r5
1542: E50B           jr      mi,%155a
1544: 5404 828C      ldl     rr4,%828c
1548: 1604 0000 9C40 addl    rr4,#%00009c40
154E: 0B04 00FA      cp      r4,#%00fa
1552: 9E09           ret     ge
1554: 5D04 828C      ldl     %828c,rr4
1558: 9E08           ret     
155A: B14A           exts    rr4
155C: B345 000A      slll    rr4,#10
1560: 5604 828C      addl    rr4,%828c
1564: ED03           jr      pl,%156c
1566: 1404 0000 0000 ldl     rr4,#%00000000
156C: 5D04 828C      ldl     %828c,rr4
1570: 9E08           ret     
1572: 6102 8184      ld      r2,%8184
1576: 5400 8170      ldl     rr0,%8170
157A: B305 FFFD      srll    rr0,#3
157E: 5600 8184      addl    rr0,%8184
1582: 5D00 8184      ldl     %8184,rr0
1586: 6F00 C100      ld      %c100,r0
158A: 4D05 8288 0000 ld      %8288,#%0000
1590: EF03           jr      nc/uge,%1598
1592: 4D05 8288 0001 ld      %8288,#%0001
1598: 4D05 8286 0000 ld      %8286,#%0000
159E: 0B00 C000      cp      r0,#%c000
15A2: E706           jr      c/ult,%15b0
15A4: 0B02 C000      cp      r2,#%c000
15A8: EF03           jr      nc/uge,%15b0
15AA: 4D05 8286 0001 ld      %8286,#%0001
15B0: 600B 8184      ldb     rl3,%8184
15B4: 8C38           clrb    rh3
15B6: 603B 36E0      ldb     rl3,%36e0(r3)
15BA: B130           extsb   r3
15BC: 6F03 8198      ld      %8198,r3
15C0: 8D32           neg     r3
15C2: 6101 818C      ld      r1,%818c
15C6: A091           ldb     rh1,rl1
15C8: 8C98           clrb    rl1
15CA: B311 FFFE      srl     r1,#2
15CE: 9912           mult    rr2,r1
15D0: 5602 8180      addl    rr2,%8180
15D4: 5D02 8180      ldl     %8180,rr2
15D8: 6F02 C000      ld      %c000,r2
15DC: 9E08           ret     
15DE: 5400 8170      ldl     rr0,%8170
15E2: B305 FFFD      srll    rr0,#3
15E6: 5600 8184      addl    rr0,%8184
15EA: 5D00 8184      ldl     %8184,rr0
15EE: 6F00 C100      ld      %c100,r0
15F2: 5402 828C      ldl     rr2,%828c
15F6: B325 FFFD      srll    rr2,#3
15FA: 5602 8290      addl    rr2,%8290
15FE: 5D02 8290      ldl     %8290,rr2
1602: 6F02 8C68      ld      %8c68,r2
1606: 6100 8298      ld      r0,%8298
160A: 6101 8184      ld      r1,%8184
160E: 4101 8290      add     r1,%8290
1612: 6F01 8298      ld      %8298,r1
1616: 8D10           com     r1
1618: 8710           and     r0,r1
161A: A70F           bit     r0,15
161C: 4D05 8288 0000 ld      %8288,#%0000
1622: 9E06           ret     eq/z
1624: 4D05 8288 0001 ld      %8288,#%0001
162A: 4D05 82A4 0000 ld      %82a4,#%0000
1630: 6506 80EC      set     %80ec,6
1634: 4D05 80F0 0000 ld      %80f0,#%0000
163A: 610E 81B0      ld      r14,%81b0
163E: 070E 007E      and     r14,#%007e
1642: 4DE5 AA00 001B ld      %aa00(r14),#%001b
1648: A9E1           inc     r14,2
164A: 070E 007E      and     r14,#%007e
164E: 4DE5 AA00 FFFF ld      %aa00(r14),#%ffff
1654: 6F0E 81B0      ld      %81b0,r14
1658: 9E08           ret     
165A: 4D04 8288      test    %8288
165E: 9E06           ret     eq/z
1660: 4D04 81F4      test    %81f4
1664: EE04           jr      ne/nz,%166e
1666: 4D05 81B4 0001 ld      %81b4,#%0001
166C: 9E08           ret     
166E: 4D04 81B4      test    %81b4
1672: EE04           jr      ne/nz,%167c
1674: 4D05 81B4 0001 ld      %81b4,#%0001
167A: 9E08           ret     
167C: 4D04 A820      test    %a820
1680: 9E0E           ret     ne/nz
1682: 6103 A822      ld      r3,%a822
1686: 2107 0000      ld      r7,#%0000
168A: 2108 0008      ld      r8,#%0008
168E: 6109 814A      ld      r9,%814a
1692: 0709 0007      and     r9,#%0007
1696: B391 0004      sll     r9,#4
169A: 0109 3D94      add     r9,#%3d94
169E: 0B93           cp      r3,@r9
16A0: E705           jr      c/ult,%16ac
16A2: E604           jr      eq/z,%16ac
16A4: A970           inc     r7,1
16A6: A991           inc     r9,2
16A8: F886           djnz    r8,%169e
16AA: 9E08           ret     
16AC: 6F07 81FA      ld      %81fa,r7
16B0: 4D05 81B4 0000 ld      %81b4,#%0000
16B6: 4D05 81F6 0001 ld      %81f6,#%0001
16BC: 9E08           ret     
16BE: 4D04 8288      test    %8288
16C2: 9E06           ret     eq/z
16C4: 6900 81FC      inc     %81fc,1
16C8: 6100 A824      ld      r0,%a824
16CC: 8D04           test    r0
16CE: E618           jr      eq/z,%1700
16D0: 0B00 0001      cp      r0,#%0001
16D4: 9E0E           ret     ne/nz
16D6: 5400 A820      ldl     rr0,%a820
16DA: 5D00 A828      ldl     %a828,rr0
16DE: DDEF           calr    %1b02
16E0: 4D05 A830 0258 ld      %a830,#%0258
16E6: 5400 A828      ldl     rr0,%a828
16EA: 5000 A82C      cpl     rr0,%a82c
16EE: 9E0F           ret     nc/uge
16F0: 5D00 A82C      ldl     %a82c,rr0
16F4: 5000 A834      cpl     rr0,%a834
16F8: 9E0F           ret     nc/uge
16FA: 5D00 A834      ldl     %a834,rr0
16FE: 9E08           ret     
1700: 4D05 A824 0001 ld      %a824,#%0001
1706: 9E08           ret     
1708: 4D04 8288      test    %8288
170C: 9E06           ret     eq/z
170E: 6101 81FC      ld      r1,%81fc
1712: 0301 0005      sub     r1,#%0005
1716: 9E05           ret     mi
1718: A910           inc     r1,1
171A: 0701 0003      and     r1,#%0003
171E: 8111           add     r1,r1
1720: 6100 8148      ld      r0,%8148
1724: 0700 0007      and     r0,#%0007
1728: B301 0003      sll     r0,#3
172C: 8501           or      r1,r0
172E: 6100 8146      ld      r0,%8146
1732: 0700 0001      and     r0,#%0001
1736: B301 0006      sll     r0,#6
173A: 8501           or      r1,r0
173C: 6110 3E14      ld      r0,%3e14(r1)
1740: 8D04           test    r0
1742: 9E06           ret     eq/z
1744: 0B00 0064      cp      r0,#%0064
1748: 9E0F           ret     nc/uge
174A: 4100 A802      add     r0,%a802
174E: 6F00 A802      ld      %a802,r0
1752: 6900 8840      inc     %8840,1
1756: 4D01 8840 0008 cp      %8840,#%0008
175C: E703           jr      c/ult,%1764
175E: 4D05 8840 0007 ld      %8840,#%0007
1764: 6700 8146      bit     %8146,0
1768: EE06           jr      ne/nz,%1776
176A: 4D01 81FC 0005 cp      %81fc,#%0005
1770: EE02           jr      ne/nz,%1776
1772: 6900 8840      inc     %8840,1
1776: 6501 80EC      set     %80ec,1
177A: 4D05 8150 007F ld      %8150,#%007f
1780: 6900 A9C8      inc     %a9c8,1
1784: 9E08           ret     
1786: 4D04 8286      test    %8286
178A: 9E06           ret     eq/z
178C: 6100 81FC      ld      r0,%81fc
1790: 0B00 0001      cp      r0,#%0001
1794: E607           jr      eq/z,%17a4
1796: 0B00 0004      cp      r0,#%0004
179A: E604           jr      eq/z,%17a4
179C: 4B00 8280      cp      r0,%8280
17A0: E605           jr      eq/z,%17ac
17A2: 9E08           ret     
17A4: 4D05 8BEC 0005 ld      %8bec,#%0005
17AA: 9E08           ret     
17AC: 4D05 8BEC 0006 ld      %8bec,#%0006
17B2: 610E 81B0      ld      r14,%81b0
17B6: 070E 007E      and     r14,#%007e
17BA: 4DE5 AA00 001A ld      %aa00(r14),#%001a
17C0: A9E1           inc     r14,2
17C2: 070E 007E      and     r14,#%007e
17C6: 4DE5 AA00 FFFF ld      %aa00(r14),#%ffff
17CC: 6F0E 81B0      ld      %81b0,r14
17D0: 9E08           ret     
17D2: 0140           add     r0,@r4
17D4: 0140           add     r0,@r4
17D6: 0170           add     r0,@r7
17D8: 0190           add     r0,@r9
17DA: 00C8           addb    rl0,@r12
17DC: 00C8           addb    rl0,@r12
17DE: 00E6           addb    rh6,@r14
17E0: 00FA           addb    rl2,@r15
17E2: 5400 818C      ldl     rr0,%818c
17E6: B305 FFF4      srll    rr0,#12
17EA: 6102 8148      ld      r2,%8148
17EE: 0702 0006      and     r2,#%0006
17F2: 6103 814E      ld      r3,%814e
17F6: B331 0003      sll     r3,#3
17FA: 0703 0008      and     r3,#%0008
17FE: 8532           or      r2,r3
1800: 5920 17D2      mult    rr0,%17d2(r2)
1804: B305 FFF4      srll    rr0,#12
1808: 5F00 353A      call    %353a
180C: 4B01 829A      cp      r1,%829a
1810: E202           jr      le,%1816
1812: 6F01 829A      ld      %829a,r1
1816: 210C 9968      ld      r12,#%9968
181A: 4D04 8104      test    %8104
181E: EE0F           jr      ne/nz,%183e
1820: 4D04 8108      test    %8108
1824: E60E           jr      eq/z,%1842
1826: 6B00 8108      dec     %8108,1
182A: 6102 8108      ld      r2,%8108
182E: 0702 001F      and     r2,#%001f
1832: 0B02 0012      cp      r2,#%0012
1836: EA34           jr      gt,%18a0
1838: 6101 829A      ld      r1,%829a
183C: E802           jr      %1842
183E: 6101 A878      ld      r1,%a878
1842: 5F00 358A      call    %358a
1846: 0153           add     r3,@r5
1848: 5045 4544      cpl     rr5,%4544(r4)
184C: 2040           ldb     rh0,@r4
184E: C001           ldb     rh0,#%01
1850: DDCE           calr    %1cb6
1852: 6100 814E      ld      r0,%814e
1856: 0700 0001      and     r0,#%0001
185A: EE05           jr      ne/nz,%1866
185C: 5F00 358A      call    %358a
1860: 266B           bitb    @r6,11
1862: 6D40 E804      ex      r0,%e804(r4)
1866: 5F00 358A      call    %358a
186A: 276B           bit     @r6,11
186C: 6D40 6101      ex      r0,%6101(r4)
1870: 8188           add     r8,r8
1872: 8D12           neg     r1
1874: 5900 8198      mult    rr0,%8198
1878: B30D FFF9      sral    rr0,#7
187C: 5900 818C      mult    rr0,%818c
1880: 5600 818C      addl    rr0,%818c
1884: 0B00 0000      cp      r0,#%0000
1888: E106           jr      lt,%1896
188A: 0B00 0118      cp      r0,#%0118
188E: E205           jr      le,%189a
1890: 2100 0118      ld      r0,#%0118
1894: E802           jr      %189a
1896: 2100 0000      ld      r0,#%0000
189A: 5D00 8170      ldl     %8170,rr0
189E: 9E08           ret     
18A0: 5F00 358A      call    %358a
18A4: 810B           add     r11,r0
18A6: 9E08           ret     
18A8: 5400 8170      ldl     rr0,%8170
18AC: B305 FFFF      srll    rr0,#1
18B0: 1B00 4300      div     rr0,#%4300
18B4: 8D08           clr     r0
18B6: 5F00 353A      call    %353a
18BA: 4D04 81B4      test    %81b4
18BE: EE03           jr      ne/nz,%18c6
18C0: 1400 0000 0000 ldl     rr0,#%00000000
18C6: 5402 81B8      ldl     rr2,%81b8
18CA: DFD7           calr    %191e
18CC: 5D00 81B8      ldl     %81b8,rr0
18D0: 4D04 8104      test    %8104
18D4: E602           jr      eq/z,%18da
18D6: 5400 A874      ldl     rr0,%a874
18DA: B305 FFF8      srll    rr0,#8
18DE: C002           ldb     rh0,#%02
18E0: 0609 F0F0      andb    rl1,#%f0
18E4: 210C 994C      ld      r12,#%994c
18E8: 5F00 1C72      call    %1c72
18EC: 8C08           clrb    rh0
18EE: 5000 81E0      cpl     rr0,%81e0
18F2: E702           jr      c/ult,%18f8
18F4: 5D00 81E0      ldl     %81e0,rr0
18F8: 5400 81E0      ldl     rr0,%81e0
18FC: C005           ldb     rh0,#%05
18FE: 210C 98CC      ld      r12,#%98cc
1902: DE49           calr    %1c72
1904: 9E08           ret     
1906: 5400 81B8      ldl     rr0,%81b8
190A: B305 FFF8      srll    rr0,#8
190E: C002           ldb     rh0,#%02
1910: 0609 F0F0      andb    rl1,#%f0
1914: 210C 994C      ld      r12,#%994c
1918: DE54           calr    %1c72
191A: 8C08           clrb    rh0
191C: E8E8           jr      %18ee
191E: 80B9           addb    rl1,rl3
1920: B090           dab     rl1
1922: B431           adcb    rh1,rh3
1924: B010           dab     rh1
1926: B4A8           adcb    rl0,rl2
1928: B080           dab     rl0
192A: B420           adcb    rh0,rh2
192C: B000           dab     rh0
192E: 9E08           ret     
1930: 4D04 82A4      test    %82a4
1934: 9E06           ret     eq/z
1936: 210B A800      ld      r11,#%a800
193A: 2BB0           dec     @r11,1
193C: 9E0E           ret     ne/nz
193E: 0DB5 0028      ld      @r11,#%0028
1942: 6900 81F0      inc     %81f0,1
1946: 4DB4 0002      test    %0002(r11)
194A: 9E06           ret     eq/z
194C: 6BB0 0002      dec     %0002(r11),1
1950: 9E08           ret     
1952: 6100 A824      ld      r0,%a824
1956: 0B00 FFFF      cp      r0,#%ffff
195A: 5E06 1AFC      jp      eq/z,%1afc
195E: 0B00 0001      cp      r0,#%0001
1962: 9E0E           ret     ne/nz
1964: 6900 A810      inc     %a810,1
1968: 4D01 A810 000A cp      %a810,#%000a
196E: E103           jr      lt,%1976
1970: 4D05 A810 0000 ld      %a810,#%0000
1976: 6B00 A812      dec     %a812,1
197A: EE0E           jr      ne/nz,%1998
197C: 4D05 A812 0004 ld      %a812,#%0004
1982: 6900 A814      inc     %a814,1
1986: 4D01 A814 000A cp      %a814,#%000a
198C: E105           jr      lt,%1998
198E: 4D05 A814 0000 ld      %a814,#%0000
1994: 6900 A816      inc     %a816,1
1998: 6102 A810      ld      r2,%a810
199C: 0702 000F      and     r2,#%000f
19A0: 6103 A814      ld      r3,%a814
19A4: 0703 000F      and     r3,#%000f
19A8: B331 0004      sll     r3,#4
19AC: 8532           or      r2,r3
19AE: 6101 A816      ld      r1,%a816
19B2: 8D08           clr     r0
19B4: 5F00 353A      call    %353a
19B8: B305 0008      slll    rr0,#8
19BC: 0700 000F      and     r0,#%000f
19C0: 8521           or      r1,r2
19C2: 5D00 A820      ldl     %a820,rr0
19C6: 9E08           ret     
19C8: 4D01 A848 0001 cp      %a848,#%0001
19CE: 9E0E           ret     ne/nz
19D0: 6900 A850      inc     %a850,1
19D4: 4D01 A850 000A cp      %a850,#%000a
19DA: E103           jr      lt,%19e2
19DC: 4D05 A850 0000 ld      %a850,#%0000
19E2: 6B00 A852      dec     %a852,1
19E6: EE0E           jr      ne/nz,%1a04
19E8: 4D05 A852 0004 ld      %a852,#%0004
19EE: 6900 A854      inc     %a854,1
19F2: 4D01 A854 000A cp      %a854,#%000a
19F8: E105           jr      lt,%1a04
19FA: 4D05 A854 0000 ld      %a854,#%0000
1A00: 6900 A856      inc     %a856,1
1A04: 6102 A850      ld      r2,%a850
1A08: 0702 000F      and     r2,#%000f
1A0C: 6103 A854      ld      r3,%a854
1A10: 0703 000F      and     r3,#%000f
1A14: B331 0004      sll     r3,#4
1A18: 8532           or      r2,r3
1A1A: 6101 A856      ld      r1,%a856
1A1E: 8D08           clr     r0
1A20: 5F00 353A      call    %353a
1A24: B305 0008      slll    rr0,#8
1A28: 0700 000F      and     r0,#%000f
1A2C: 8521           or      r1,r2
1A2E: 5D00 A84A      ldl     %a84a,rr0
1A32: 9E08           ret     
1A34: 210C 995C      ld      r12,#%995c
1A38: 8D18           clr     r1
1A3A: 4D04 8104      test    %8104
1A3E: EE02           jr      ne/nz,%1a44
1A40: 6101 A802      ld      r1,%a802
1A44: 8D08           clr     r0
1A46: 5F00 353A      call    %353a
1A4A: C003           ldb     rh0,#%03
1A4C: DECC           calr    %1cb6
1A4E: 9E08           ret     
1A50: 210C 98F2      ld      r12,#%98f2
1A54: 4D04 8104      test    %8104
1A58: EE06           jr      ne/nz,%1a66
1A5A: 4D04 A830      test    %a830
1A5E: EE06           jr      ne/nz,%1a6c
1A60: 5400 A820      ldl     rr0,%a820
1A64: E80F           jr      %1a84
1A66: 5400 A870      ldl     rr0,%a870
1A6A: E80C           jr      %1a84
1A6C: 6B00 A830      dec     %a830,1
1A70: 6100 A830      ld      r0,%a830
1A74: 0700 001F      and     r0,#%001f
1A78: E618           jr      eq/z,%1aaa
1A7A: 0B00 0014      cp      r0,#%0014
1A7E: 9E0E           ret     ne/nz
1A80: 5400 A828      ldl     rr0,%a828
1A84: A112           ld      r2,r1
1A86: B305 FFF8      srll    rr0,#8
1A8A: C004           ldb     rh0,#%04
1A8C: DEEC           calr    %1cb6
1A8E: A121           ld      r1,r2
1A90: DED1           calr    %1cf0
1A92: 030C 0012      sub     r12,#%0012
1A96: 5F00 358A      call    %358a
1A9A: 044C           orb     rl4,@r4
1A9C: 4150 40FF      add     r0,%40ff(r5)
1AA0: 010C 0006      add     r12,#%0006
1AA4: 0DC5 0426      ld      @r12,#%0426
1AA8: 9E08           ret     
1AAA: 030C 000A      sub     r12,#%000a
1AAE: 5F00 358A      call    %358a
1AB2: 840C           orb     rl4,rh0
1AB4: 9E08           ret     
1AB6: 4D05 A800 0028 ld      %a800,#%0028
1ABC: 6101 8144      ld      r1,%8144
1AC0: 0701 0003      and     r1,#%0003
1AC4: 6018 1B54      ldb     rl0,%1b54(r1)
1AC8: 8C08           clrb    rh0
1ACA: 6F00 A802      ld      %a802,r0
1ACE: E816           jr      %1afc
1AD0: 4D05 A800 0028 ld      %a800,#%0028
1AD6: 6101 8148      ld      r1,%8148
1ADA: 0701 0007      and     r1,#%0007
1ADE: B311 0003      sll     r1,#3
1AE2: 6100 8146      ld      r0,%8146
1AE6: 0700 0001      and     r0,#%0001
1AEA: B301 0006      sll     r0,#6
1AEE: 8501           or      r1,r0
1AF0: 6110 3E14      ld      r0,%3e14(r1)
1AF4: 0700 007F      and     r0,#%007f
1AF8: 6F00 A802      ld      %a802,r0
1AFC: 4D05 A824 0000 ld      %a824,#%0000
1B02: 4D05 A810 0000 ld      %a810,#%0000
1B08: 4D05 A812 0004 ld      %a812,#%0004
1B0E: 4D05 A814 0000 ld      %a814,#%0000
1B14: 4D05 A816 0000 ld      %a816,#%0000
1B1A: 4D05 A820 0000 ld      %a820,#%0000
1B20: 4D05 A822 0000 ld      %a822,#%0000
1B26: 9E08           ret     
1B28: 4D05 A848 0000 ld      %a848,#%0000
1B2E: 4D05 A850 0000 ld      %a850,#%0000
1B34: 4D05 A852 0004 ld      %a852,#%0004
1B3A: 4D05 A854 0000 ld      %a854,#%0000
1B40: 4D05 A856 0000 ld      %a856,#%0000
1B46: 4D05 A84A 0000 ld      %a84a,#%0000
1B4C: 4D05 A84C 0000 ld      %a84c,#%0000
1B52: 9E08           ret     
1B54: 5A64 6E78      divl    rq4,%6e78(r6)
1B58: DFDF           calr    %1b9c
1B5A: DFD0           calr    %1bbc
1B5C: D1EC           calr    %1786
1B5E: DFC9           calr    %1bce
1B60: 4D05 80FE 0000 ld      %80fe,#%0000
1B66: 4D04 81BC      test    %81bc
1B6A: 9E0E           ret     ne/nz
1B6C: 6100 8188      ld      r0,%8188
1B70: 8D04           test    r0
1B72: ED01           jr      pl,%1b76
1B74: 8D02           neg     r0
1B76: 0B00 4C00      cp      r0,#%4c00
1B7A: 9E02           ret     le
1B7C: 0300 2000      sub     r0,#%2000
1B80: 8D02           neg     r0
1B82: A008           ldb     rl0,rh0
1B84: B100           extsb   r0
1B86: 6F00 81BC      ld      %81bc,r0
1B8A: 8D02           neg     r0
1B8C: B301 FFFD      srl     r0,#3
1B90: 4D04 8104      test    %8104
1B94: 9E0E           ret     ne/nz
1B96: 6F00 80FE      ld      %80fe,r0
1B9A: 9E08           ret     
1B9C: 4D04 81F6      test    %81f6
1BA0: EE03           jr      ne/nz,%1ba8
1BA2: 4D04 A802      test    %a802
1BA6: 9E0E           ret     ne/nz
1BA8: 4D05 81BC FED4 ld      %81bc,#%fed4
1BAE: 4D04 818C      test    %818c
1BB2: 9E0E           ret     ne/nz
1BB4: 4D05 8016 0001 ld      %8016,#%0001
1BBA: 9E08           ret     
1BBC: 6100 8C60      ld      r0,%8c60
1BC0: 0A08 0404      cpb     rl0,#%04
1BC4: 9E0E           ret     ne/nz
1BC6: 4D05 81BC FED4 ld      %81bc,#%fed4
1BCC: 9E08           ret     
1BCE: 6100 81FC      ld      r0,%81fc
1BD2: 4B00 8280      cp      r0,%8280
1BD6: EA09           jr      gt,%1bea
1BD8: E604           jr      eq/z,%1be2
1BDA: 4D05 81F8 0000 ld      %81f8,#%0000
1BE0: 9E08           ret     
1BE2: 4D01 8184 FB40 cp      %8184,#%fb40
1BE8: E7F8           jr      c/ult,%1bda
1BEA: 4D05 81F8 0001 ld      %81f8,#%0001
1BF0: 9E08           ret     
1BF2: DFE9           calr    %1c22
1BF4: D01D           calr    %1bbc
1BF6: D239           calr    %1786
1BF8: D016           calr    %1bce
1BFA: 6101 8282      ld      r1,%8282
1BFE: 0B01 0000      cp      r1,#%0000
1C02: E106           jr      lt,%1c10
1C04: 0B01 00FF      cp      r1,#%00ff
1C08: E205           jr      le,%1c14
1C0A: 2101 00FF      ld      r1,#%00ff
1C0E: E802           jr      %1c14
1C10: 2101 0000      ld      r1,#%0000
1C14: 9910           mult    rr0,r1
1C16: B311 FFF8      srl     r1,#8
1C1A: A910           inc     r1,1
1C1C: 6F01 81BE      ld      %81be,r1
1C20: 9E08           ret     
1C22: 6100 8184      ld      r0,%8184
1C26: 4100 8290      add     r0,%8290
1C2A: 0B00 0C00      cp      r0,#%0c00
1C2E: 9E02           ret     le
1C30: 0B00 1000      cp      r0,#%1000
1C34: 9E09           ret     ge
1C36: 4D05 8016 0001 ld      %8016,#%0001
1C3C: 9E08           ret     
1C3E: 4D04 8150      test    %8150
1C42: 9E06           ret     eq/z
1C44: 6100 8150      ld      r0,%8150
1C48: 6B00 8150      dec     %8150,1
1C4C: 210C 9AD2      ld      r12,#%9ad2
1C50: A704           bit     r0,4
1C52: E60B           jr      eq/z,%1c6a
1C54: 5F00 358A      call    %358a
1C58: 2245           resb    @r4,5
1C5A: 5854 454E      multl   rq4,%454e(r5)
1C5E: 4445 4420      orb     rh5,%4420(r4)
1C62: 504C 4159      cpl     rr12,%4159(r4)
1C66: 2140           ld      r0,@r4
1C68: 9E08           ret     
1C6A: 5F00 358A      call    %358a
1C6E: 8114           add     r4,r1
1C70: 9E08           ret     
1C72: 91F0           pushl   @r15,rr0
1C74: 91F2           pushl   @r15,rr2
1C76: 91FA           pushl   @r15,rr10
1C78: 9402           ldl     rr2,rr0
1C7A: 210A 0005      ld      r10,#%0005
1C7E: 210B 0001      ld      r11,#%0001
1C82: B325 0004      slll    rr2,#4
1C86: A028           ldb     rl0,rh2
1C88: 0608 0F0F      andb    rl0,#%0f
1C8C: 8DB4           test    r11
1C8E: E605           jr      eq/z,%1c9a
1C90: 8C84           testb   rl0
1C92: EE02           jr      ne/nz,%1c98
1C94: C824           ldb     rl0,#%24
1C96: E801           jr      %1c9a
1C98: 8DB8           clr     r11
1C9A: 2FC0           ld      @r12,r0
1C9C: A9C1           inc     r12,2
1C9E: FA8F           djnz    r10,%1c82
1CA0: B321 0004      sll     r2,#4
1CA4: A028           ldb     rl0,rh2
1CA6: 0608 0F0F      andb    rl0,#%0f
1CAA: 2FC0           ld      @r12,r0
1CAC: A9C1           inc     r12,2
1CAE: 95FA           popl    rr10,@r15
1CB0: 95F2           popl    rr2,@r15
1CB2: 95F0           popl    rr0,@r15
1CB4: 9E08           ret     
1CB6: 91F0           pushl   @r15,rr0
1CB8: 91FA           pushl   @r15,rr10
1CBA: 210A 0002      ld      r10,#%0002
1CBE: 210B 0001      ld      r11,#%0001
1CC2: A018           ldb     rl0,rh1
1CC4: 0608 0F0F      andb    rl0,#%0f
1CC8: 8DB4           test    r11
1CCA: E605           jr      eq/z,%1cd6
1CCC: 8C84           testb   rl0
1CCE: EE02           jr      ne/nz,%1cd4
1CD0: C824           ldb     rl0,#%24
1CD2: E801           jr      %1cd6
1CD4: 8DB8           clr     r11
1CD6: 2FC0           ld      @r12,r0
1CD8: A9C1           inc     r12,2
1CDA: B311 0004      sll     r1,#4
1CDE: FA8F           djnz    r10,%1cc2
1CE0: A018           ldb     rl0,rh1
1CE2: 0608 0F0F      andb    rl0,#%0f
1CE6: 2FC0           ld      @r12,r0
1CE8: A9C1           inc     r12,2
1CEA: 95FA           popl    rr10,@r15
1CEC: 95F0           popl    rr0,@r15
1CEE: 9E08           ret     
1CF0: A9C1           inc     r12,2
1CF2: 91F0           pushl   @r15,rr0
1CF4: B311 0004      sll     r1,#4
1CF8: A018           ldb     rl0,rh1
1CFA: 0608 0F0F      andb    rl0,#%0f
1CFE: 2FC0           ld      @r12,r0
1D00: A9C1           inc     r12,2
1D02: B311 0004      sll     r1,#4
1D06: A018           ldb     rl0,rh1
1D08: 0608 0F0F      andb    rl0,#%0f
1D0C: 2FC0           ld      @r12,r0
1D0E: A9C1           inc     r12,2
1D10: 95F0           popl    rr0,@r15
1D12: 9E08           ret     
1D14: 8D98           clr     r9
1D16: 2106 8039      ld      r6,#%8039
1D1A: E804           jr      %1d24
1D1C: 2109 0001      ld      r9,#%0001
1D20: 2106 A901      ld      r6,#%a901
1D24: 6700 80EE      bit     %80ee,0
1D28: E630           jr      eq/z,%1d8a
1D2A: 0106 0018      add     r6,#%0018
1D2E: 6100 82B4      ld      r0,%82b4
1D32: 0700 00FF      and     r0,#%00ff
1D36: E616           jr      eq/z,%1d64
1D38: 0B00 0080      cp      r0,#%0080
1D3C: EE39           jr      ne/nz,%1db0
1D3E: 210C 9A06      ld      r12,#%9a06
1D42: 5F00 358A      call    %358a
1D46: 0A20           cpb     rh0,@r2
1D48: 2020           ldb     rh0,@r2
1D4A: 454E 5445      or      r14,%5445(r4)
1D4E: 5220 594F      subl    rr0,%594f(r2)
1D52: 5552 2049      popl    %2049(r2),@r5
1D56: 4E49           .word   #%4e49
1D58: 5449 414C      ldl     rr9,%414c(r4)
1D5C: 5320 2020      push    @r2,%2020
1D60: 40FF E826      addb    rl7,%e826(r15)
1D64: 210C 9A06      ld      r12,#%9a06
1D68: 5F00 358A      call    %358a
1D6C: 0A54           cpb     rh4,@r5
1D6E: 4845 2050      xorb    rh5,%2050(r4)
1D72: 4153 5420      add     r3,%5420(r5)
1D76: 3330 3020      ld      r3(#%3020),r0
1D7A: 4741 4D45      and     r1,%4d45(r4)
1D7E: 5320 5245      push    @r2,%5245
1D82: 434F 5244      sub     r15,%5244(r4)
1D86: 40FF E813      addb    rl7,%e813(r15)
1D8A: 210C 9C08      ld      r12,#%9c08
1D8E: 210D 0006      ld      r13,#%0006
1D92: 6104 8034      ld      r4,%8034
1D96: 6105 8036      ld      r5,%8036
1D9A: 0705 0001      and     r5,#%0001
1D9E: A0D4           ldb     rh4,rl5
1DA0: A145           ld      r5,r4
1DA2: 0304 0005      sub     r4,#%0005
1DA6: E829           jr      %1dfa
1DA8: 2106 A919      ld      r6,#%a919
1DAC: 2109 0001      ld      r9,#%0001
1DB0: 210C 9B08      ld      r12,#%9b08
1DB4: 210D 0008      ld      r13,#%0008
1DB8: 6104 8034      ld      r4,%8034
1DBC: 6105 8036      ld      r5,%8036
1DC0: 0705 0001      and     r5,#%0001
1DC4: A0D4           ldb     rh4,rl5
1DC6: A145           ld      r5,r4
1DC8: 0304 0003      sub     r4,#%0003
1DCC: E816           jr      %1dfa
1DCE: 210C 9C08      ld      r12,#%9c08
1DD2: 2109 0001      ld      r9,#%0001
1DD6: 210D 0006      ld      r13,#%0006
1DDA: 2106 8039      ld      r6,#%8039
1DDE: 6105 81AC      ld      r5,%81ac
1DE2: 8D48           clr     r4
1DE4: 1B04 000F      div     rr4,#%000f
1DE8: 8D48           clr     r4
1DEA: 1B04 0006      div     rr4,#%0006
1DEE: 8D42           neg     r4
1DF0: 0104 0006      add     r4,#%0006
1DF4: A145           ld      r5,r4
1DF6: 2104 0001      ld      r4,#%0001
1DFA: 2107 0A26      ld      r7,#%0a26
1DFE: 8D44           test    r4
1E00: E558           jr      mi,%1eb2
1E02: E657           jr      eq/z,%1eb2
1E04: 8B54           cp      r4,r5
1E06: EE08           jr      ne/nz,%1e18
1E08: 6100 8102      ld      r0,%8102
1E0C: 0700 0007      and     r0,#%0007
1E10: 0100 000A      add     r0,#%000a
1E14: A087           ldb     rh7,rl0
1E16: E801           jr      %1e1a
1E18: C70A           ldb     rh7,#%0a
1E1A: A141           ld      r1,r4
1E1C: 5F00 353A      call    %353a
1E20: A070           ldb     rh0,rh7
1E22: 8C88           clrb    rl0
1E24: D0B8           calr    %1cb6
1E26: A9C1           inc     r12,2
1E28: 2069           ldb     rl1,@r6
1E2A: 6061 0002      ldb     rh1,%0002(r6)
1E2E: A963           inc     r6,4
1E30: 5F00 353A      call    %353a
1E34: B305 0004      slll    rr0,#4
1E38: A070           ldb     rh0,rh7
1E3A: D0E5           calr    %1c72
1E3C: A9C3           inc     r12,4
1E3E: 2069           ldb     rl1,@r6
1E40: 6061 0002      ldb     rh1,%0002(r6)
1E44: A963           inc     r6,4
1E46: 8D14           test    r1
1E48: E60D           jr      eq/z,%1e64
1E4A: 5F00 353A      call    %353a
1E4E: A112           ld      r2,r1
1E50: B305 FFF8      srll    rr0,#8
1E54: A070           ldb     rh0,rh7
1E56: D0D1           calr    %1cb6
1E58: A121           ld      r1,r2
1E5A: 8C18           clrb    rh1
1E5C: D0B7           calr    %1cf0
1E5E: 6FC7 FFFA      ld      %fffa(r12),r7
1E62: E802           jr      %1e68
1E64: 010C 000C      add     r12,#%000c
1E68: 010C 0004      add     r12,#%0004
1E6C: 2103 0003      ld      r3,#%0003
1E70: 2069           ldb     rl1,@r6
1E72: 6061 0002      ldb     rh1,%0002(r6)
1E76: A963           inc     r6,4
1E78: B305 0001      slll    rr0,#1
1E7C: 8D88           clr     r8
1E7E: B305 0005      slll    rr0,#5
1E82: 0700 001F      and     r0,#%001f
1E86: A102           ld      r2,r0
1E88: 6028 1EB8      ldb     rl0,%1eb8(r2)
1E8C: A070           ldb     rh0,rh7
1E8E: 8D94           test    r9
1E90: EE07           jr      ne/nz,%1ea0
1E92: 0A00 0A0A      cpb     rh0,#%0a
1E96: E604           jr      eq/z,%1ea0
1E98: 4B08 82B0      cp      r8,%82b0
1E9C: E601           jr      eq/z,%1ea0
1E9E: C00A           ldb     rh0,#%0a
1EA0: 2FC0           ld      @r12,r0
1EA2: A981           inc     r8,2
1EA4: A9C1           inc     r12,2
1EA6: F395           djnz    r3,%1e7e
1EA8: 010C 0052      add     r12,#%0052
1EAC: A940           inc     r4,1
1EAE: FDD9           djnz    r13,%1dfe
1EB0: 9E08           ret     
1EB2: A96B           inc     r6,12
1EB4: A940           inc     r4,1
1EB6: E8A3           jr      %1dfe
1EB8: 240A 0B0C      setb    rl3,r10
1EBC: 0D0E           .word   #%0d0e
1EBE: 0F10           ext0f   #%10
1EC0: 1112           pushl   @r1,@r2
1EC2: 1314           push    @r1,@r4
1EC4: 1516           popl    @r6,@r1
1EC6: 1718           pop     @r8,@r1
1EC8: 191A           mult    rr10,@r1
1ECA: 1B1C           div     rr12,@r1
1ECC: 1D1E           ldl     @r1,rr14
1ECE: 1F20           call    r2
1ED0: 2122           ld      r2,@r2
1ED2: 2325           res     @r2,5
1ED4: 2424           setb    @r2,4
1ED6: 2424           setb    @r2,4
1ED8: 4D04 A840      test    %a840
1EDC: E67F           jr      eq/z,%1fdc
1EDE: 6B00 A840      dec     %a840,1
1EE2: 4D01 A840 0096 cp      %a840,#%0096
1EE8: E90F           jr      ge,%1f08
1EEA: 4D01 A840 003C cp      %a840,#%003c
1EF0: E916           jr      ge,%1f1e
1EF2: 2104 0001      ld      r4,#%0001
1EF6: 2105 0023      ld      r5,#%0023
1EFA: 6106 8102      ld      r6,%8102
1EFE: 0706 000F      and     r6,#%000f
1F02: 0106 0020      add     r6,#%0020
1F06: E815           jr      %1f32
1F08: 6104 8102      ld      r4,%8102
1F0C: 0704 000F      and     r4,#%000f
1F10: 0104 0020      add     r4,#%0020
1F14: 2105 0001      ld      r5,#%0001
1F18: 2106 0001      ld      r6,#%0001
1F1C: E80A           jr      %1f32
1F1E: 2104 0001      ld      r4,#%0001
1F22: 6105 8102      ld      r5,%8102
1F26: 0705 000F      and     r5,#%000f
1F2A: 0105 0020      add     r5,#%0020
1F2E: 2106 0001      ld      r6,#%0001
1F32: A0C0           ldb     rh0,rl4
1F34: 210C 9D92      ld      r12,#%9d92
1F38: 5F00 3580      call    %3580
1F3C: 4C41 5020 5449 cpb     %5020(r4),#%20
1F42: 4D45 2020 2022 ld      %2020(r4),#%2022
1F48: 40FF ABC5      addb    rl7,%abc5(r15)
1F4C: 6101 A82A      ld      r1,%a82a
1F50: AC19           exb     rl1,rh1
1F52: D131           calr    %1cf2
1F54: AC19           exb     rl1,rh1
1F56: D134           calr    %1cf0
1F58: A0D0           ldb     rh0,rl5
1F5A: 4D04 81FA      test    %81fa
1F5E: E623           jr      eq/z,%1fa6
1F60: 210C 9E08      ld      r12,#%9e08
1F64: 5F00 3580      call    %3580
1F68: 504F 5349      cpl     rr15,%5349(r4)
1F6C: 5449 4F4E      ldl     rr9,%4f4e(r4)
1F70: 2040           ldb     rh0,@r4
1F72: 0B05 0010      cp      r5,#%0010
1F76: E902           jr      ge,%1f7c
1F78: 2105 0020      ld      r5,#%0020
1F7C: 0105 0018      add     r5,#%0018
1F80: 2100 0008      ld      r0,#%0008
1F84: 2101 0001      ld      r1,#%0001
1F88: 6102 81FA      ld      r2,%81fa
1F8C: 0702 0007      and     r2,#%0007
1F90: A920           inc     r2,1
1F92: 8AA9           cpb     rl1,rl2
1F94: EE02           jr      ne/nz,%1f9a
1F96: A0D1           ldb     rh1,rl5
1F98: E801           jr      %1f9c
1F9A: C101           ldb     rh1,#%01
1F9C: 2FC1           ld      @r12,r1
1F9E: A9C3           inc     r12,4
1FA0: A890           incb    rl1,1
1FA2: F089           djnz    r0,%1f92
1FA4: E80C           jr      %1fbe
1FA6: 210C 9E12      ld      r12,#%9e12
1FAA: 5F00 3580      call    %3580
1FAE: 504F 4C45      cpl     rr15,%4c45(r4)
1FB2: 2050           ldb     rh0,@r5
1FB4: 4F53           .word   #%4f53
1FB6: 4954 494F      xor     r4,%494f(r5)
1FBA: 4E21 40FF      ldb     %40ff(r2),rh1
1FBE: A0E0           ldb     rh0,rl6
1FC0: 210C 9E98      ld      r12,#%9e98
1FC4: 5F00 3580      call    %3580
1FC8: 424F 4E55      subb    rl7,%4e55(r4)
1FCC: 5320 40FF      push    @r2,%40ff
1FD0: 6101 A842      ld      r1,%a842
1FD4: D190           calr    %1cb6
1FD6: C800           ldb     rl0,#%00
1FD8: 2FC0           ld      @r12,r0
1FDA: 9E08           ret     
1FDC: 6B00 82A2      dec     %82a2,1
1FE0: EE88           jr      ne/nz,%1ef2
1FE2: 4D05 82A2 0008 ld      %82a2,#%0008
1FE8: 6100 A842      ld      r0,%a842
1FEC: 8D04           test    r0
1FEE: E681           jr      eq/z,%1ef2
1FF0: E580           jr      mi,%1ef2
1FF2: 2101 0020      ld      r1,#%0020
1FF6: 8298           subb    rl0,rl1
1FF8: B080           dab     rl0
1FFA: B610           sbcb    rh0,rh1
1FFC: B000           dab     rh0
1FFE: 6F00 A842      ld      %a842,r0
2002: 1402 0002 0000 ldl     rr2,#%00020000
2008: 5400 81B8      ldl     rr0,%81b8
200C: D378           calr    %191e
200E: 5D00 81B8      ldl     %81b8,rr0
2012: 6507 80EE      set     %80ee,7
2016: 5E08 1EF2      jp      %1ef2
201A: DFCD           calr    %2082
201C: DF64           calr    %2156
201E: DF41           calr    %219e
2020: DF22           calr    %21de
2022: DEF0           calr    %2244
2024: DEC0           calr    %22a6
2026: DE70           calr    %2348
2028: DE51           calr    %2388
202A: DDDB           calr    %2476
202C: DDAA           calr    %24da
202E: DCFD           calr    %2636
2030: DCE6           calr    %2666
2032: 2103 004E      ld      r3,#%004e
2036: 6102 8148      ld      r2,%8148
203A: 0B02 0003      cp      r2,#%0003
203E: E207           jr      le,%204e
2040: 2103 0048      ld      r3,#%0048
2044: 0B02 0005      cp      r2,#%0005
2048: E202           jr      le,%204e
204A: 2103 0042      ld      r3,#%0042
204E: 6101 821C      ld      r1,%821c
2052: 8D08           clr     r0
2054: 9B30           div     rr0,r3
2056: 6F01 80E0      ld      %80e0,r1
205A: 6100 818C      ld      r0,%818c
205E: 0B00 0000      cp      r0,#%0000
2062: E106           jr      lt,%2070
2064: 0B00 00FF      cp      r0,#%00ff
2068: E205           jr      le,%2074
206A: 2100 00FF      ld      r0,#%00ff
206E: E802           jr      %2074
2070: 2100 0000      ld      r0,#%0000
2074: 6F00 80F4      ld      %80f4,r0
2078: 6100 822C      ld      r0,%822c
207C: 6F00 80F2      ld      %80f2,r0
2080: 9E08           ret     
2082: 4D04 8204      test    %8204
2086: E643           jr      eq/z,%210e
2088: 4D04 8104      test    %8104
208C: EE07           jr      ne/nz,%209c
208E: 6700 801A      bit     %801a,0
2092: EE0B           jr      ne/nz,%20aa
2094: 4D05 8226 000A ld      %8226,#%000a
209A: E80A           jr      %20b0
209C: 4D01 818C 0064 cp      %818c,#%0064
20A2: 4D05 8226 000A ld      %8226,#%000a
20A8: E103           jr      lt,%20b0
20AA: 4D05 8226 0005 ld      %8226,#%0005
20B0: 6100 8228      ld      r0,%8228
20B4: 4300 821C      sub     r0,%821c
20B8: A101           ld      r1,r0
20BA: ED01           jr      pl,%20be
20BC: 8D02           neg     r0
20BE: 0B00 00C8      cp      r0,#%00c8
20C2: E139           jr      lt,%2136
20C4: 4D05 8224 0001 ld      %8224,#%0001
20CA: 8D14           test    r1
20CC: E510           jr      mi,%20ee
20CE: 6100 8220      ld      r0,%8220
20D2: 0100 000A      add     r0,#%000a
20D6: A101           ld      r1,r0
20D8: 8100           add     r0,r0
20DA: 8110           add     r0,r1
20DC: 8100           add     r0,r0
20DE: 4100 821C      add     r0,%821c
20E2: ED02           jr      pl,%20e8
20E4: 2100 0000      ld      r0,#%0000
20E8: 6F00 821C      ld      %821c,r0
20EC: E82B           jr      %2144
20EE: 6100 8220      ld      r0,%8220
20F2: 0300 003C      sub     r0,#%003c
20F6: A101           ld      r1,r0
20F8: 8100           add     r0,r0
20FA: 8110           add     r0,r1
20FC: 8100           add     r0,r0
20FE: 4100 821C      add     r0,%821c
2102: ED02           jr      pl,%2108
2104: 2100 0000      ld      r0,#%0000
2108: 6F00 821C      ld      %821c,r0
210C: E81B           jr      %2144
210E: 4D05 8224 0000 ld      %8224,#%0000
2114: 6100 8220      ld      r0,%8220
2118: 0300 0009      sub     r0,#%0009
211C: A101           ld      r1,r0
211E: 8100           add     r0,r0
2120: 8100           add     r0,r0
2122: 8110           add     r0,r1
2124: 8100           add     r0,r0
2126: 4100 821C      add     r0,%821c
212A: ED02           jr      pl,%2130
212C: 2100 0000      ld      r0,#%0000
2130: 6F00 821C      ld      %821c,r0
2134: E807           jr      %2144
2136: 4D05 8224 FFFF ld      %8224,#%ffff
213C: 6100 8228      ld      r0,%8228
2140: 6F00 821C      ld      %821c,r0
2144: 6101 8258      ld      r1,%8258
2148: 5900 8226      mult    rr0,%8226
214C: 1B00 0004      div     rr0,#%0004
2150: 6F01 8228      ld      %8228,r1
2154: 9E08           ret     
2156: 6101 821C      ld      r1,%821c
215A: B319 FFFE      sra     r1,#2
215E: 0A01 0E0E      cpb     rh1,#%0e
2162: E919           jr      ge,%2196
2164: A019           ldb     rl1,rh1
2166: 8C18           clrb    rh1
2168: 6102 8148      ld      r2,%8148
216C: 0B02 0003      cp      r2,#%0003
2170: E206           jr      le,%217e
2172: 0B02 0005      cp      r2,#%0005
2176: E206           jr      le,%2184
2178: 6019 3EB4      ldb     rl1,%3eb4(r1)
217C: E805           jr      %2188
217E: 6019 3E94      ldb     rl1,%3e94(r1)
2182: E802           jr      %2188
2184: 6019 3EA4      ldb     rl1,%3ea4(r1)
2188: 5900 8190      mult    rr0,%8190
218C: B30D FFFD      sral    rr0,#3
2190: 6F01 8220      ld      %8220,r1
2194: 9E08           ret     
2196: 4D05 8220 0000 ld      %8220,#%0000
219C: 9E08           ret     
219E: 6101 821C      ld      r1,%821c
21A2: 6103 8228      ld      r3,%8228
21A6: A910           inc     r1,1
21A8: A930           inc     r3,1
21AA: 8B31           cp      r1,r3
21AC: E90C           jr      ge,%21c6
21AE: 1900 0096      mult    rr0,#%0096
21B2: 9B30           div     rr0,r3
21B4: 8D12           neg     r1
21B6: 0101 00FA      add     r1,#%00fa
21BA: 6F01 8238      ld      %8238,r1
21BE: 4D05 8236 0000 ld      %8236,#%0000
21C4: 9E08           ret     
21C6: 1902 0096      mult    rr2,#%0096
21CA: 9B12           div     rr2,r1
21CC: 8D32           neg     r3
21CE: 0103 00FA      add     r3,#%00fa
21D2: 6F03 8236      ld      %8236,r3
21D6: 4D05 8238 0000 ld      %8238,#%0000
21DC: 9E08           ret     
21DE: 4D04 8224      test    %8224
21E2: E618           jr      eq/z,%2214
21E4: ED1E           jr      pl,%2222
21E6: 6101 8220      ld      r1,%8220
21EA: 6F01 822C      ld      %822c,r1
21EE: 5900 8226      mult    rr0,%8226
21F2: B305 0005      slll    rr0,#5
21F6: 6103 824C      ld      r3,%824c
21FA: 8D28           clr     r2
21FC: 9220           subl    rr0,rr2
21FE: ED0D           jr      pl,%221a
2200: B30D FFFE      sral    rr0,#2
2204: 8D12           neg     r1
2206: 0701 000F      and     r1,#%000f
220A: 0101 0005      add     r1,#%0005
220E: 6F01 823A      ld      %823a,r1
2212: 9E08           ret     
2214: 4D05 822C 0000 ld      %822c,#%0000
221A: 4D05 823A 0000 ld      %823a,#%0000
2220: 9E08           ret     
2222: 6101 8220      ld      r1,%8220
2226: 5900 8236      mult    rr0,%8236
222A: 1B00 0064      div     rr0,#%0064
222E: 6F01 822C      ld      %822c,r1
2232: 6101 8238      ld      r1,%8238
2236: 1900 0014      mult    rr0,#%0014
223A: 1B00 0064      div     rr0,#%0064
223E: 6F01 823A      ld      %823a,r1
2242: 9E08           ret     
2244: 6101 8240      ld      r1,%8240
2248: 8D14           test    r1
224A: ED01           jr      pl,%224e
224C: 8D12           neg     r1
224E: 8D08           clr     r0
2250: 4D04 8194      test    %8194
2254: E609           jr      eq/z,%2268
2256: 4D04 823A      test    %823a
225A: E606           jr      eq/z,%2268
225C: 1200 0000 2710 subl    rr0,#%00002710
2262: 1B00 0078      div     rr0,#%0078
2266: E805           jr      %2272
2268: 1200 0000 1F40 subl    rr0,#%00001f40
226E: 1B00 0050      div     rr0,#%0050
2272: 6102 81F4      ld      r2,%81f4
2276: 0702 0001      and     r2,#%0001
227A: 6103 8148      ld      r3,%8148
227E: 0703 0006      and     r3,#%0006
2282: 8532           or      r2,r3
2284: 6028 3EC4      ldb     rl0,%3ec4(r2)
2288: 8C08           clrb    rh0
228A: A102           ld      r2,r0
228C: A103           ld      r3,r0
228E: B331 FFFF      srl     r3,#1
2292: 8310           sub     r0,r1
2294: 8B20           cp      r0,r2
2296: E201           jr      le,%229a
2298: A120           ld      r0,r2
229A: 8B30           cp      r0,r3
229C: E901           jr      ge,%22a0
229E: A130           ld      r0,r3
22A0: 6F00 823E      ld      %823e,r0
22A4: 9E08           ret     
22A6: 6101 822C      ld      r1,%822c
22AA: 4301 823A      sub     r1,%823a
22AE: 5900 8226      mult    rr0,%8226
22B2: B305 0005      slll    rr0,#5
22B6: 6103 8194      ld      r3,%8194
22BA: 1902 0514      mult    rr2,#%0514
22BE: 9220           subl    rr0,rr2
22C0: 1000 0000 2EE0 cpl     rr0,#%00002ee0
22C6: E203           jr      le,%22ce
22C8: 1400 0000 2710 ldl     rr0,#%00002710
22CE: 1000 FFFF C568 cpl     rr0,#%ffffc568
22D4: E903           jr      ge,%22dc
22D6: 1400 FFFF D120 ldl     rr0,#%ffffd120
22DC: 6F01 8240      ld      %8240,r1
22E0: 6101 8258      ld      r1,%8258
22E4: 8D08           clr     r0
22E6: 1B00 0064      div     rr0,#%0064
22EA: 9910           mult    rr0,r1
22EC: 5D00 8268      ldl     %8268,rr0
22F0: A019           ldb     rl1,rh1
22F2: A081           ldb     rh1,rl0
22F4: 5900 825C      mult    rr0,%825c
22F8: 1B00 000E      div     rr0,#%000e
22FC: 6F01 8244      ld      %8244,r1
2300: 4D04 8222      test    %8222
2304: E60D           jr      eq/z,%2320
2306: 6701 8222      bit     %8222,1
230A: EE14           jr      ne/nz,%2334
230C: 4D05 8248 0003 ld      %8248,#%0003
2312: 4D05 824A 0008 ld      %824a,#%0008
2318: 4D05 8276 0004 ld      %8276,#%0004
231E: 9E08           ret     
2320: 4D05 8248 0001 ld      %8248,#%0001
2326: 4D05 824A 000A ld      %824a,#%000a
232C: 4D05 8276 0000 ld      %8276,#%0000
2332: 9E08           ret     
2334: 4D05 8248 000A ld      %8248,#%000a
233A: 4D05 824A 0005 ld      %824a,#%0005
2340: 4D05 8276 0008 ld      %8276,#%0008
2346: 9E08           ret     
2348: 6101 8248      ld      r1,%8248
234C: 1900 04B0      mult    rr0,#%04b0
2350: 5600 8268      addl    rr0,%8268
2354: B305 FFFF      srll    rr0,#1
2358: 6F01 824C      ld      %824c,r1
235C: 6101 8240      ld      r1,%8240
2360: B10A           exts    rr0
2362: 6103 824C      ld      r3,%824c
2366: 8D28           clr     r2
2368: 9220           subl    rr0,rr2
236A: B30D FFFE      sral    rr0,#2
236E: 6F01 8254      ld      %8254,r1
2372: B30D FFFA      sral    rr0,#6
2376: 4101 8258      add     r1,%8258
237A: 6F01 8258      ld      %8258,r1
237E: 9E0D           ret     pl
2380: 4D05 8258 0000 ld      %8258,#%0000
2386: 9E08           ret     
2388: 6101 8244      ld      r1,%8244
238C: 8D14           test    r1
238E: ED01           jr      pl,%2392
2390: 8D12           neg     r1
2392: A110           ld      r0,r1
2394: 8111           add     r1,r1
2396: 8111           add     r1,r1
2398: 8101           add     r1,r0
239A: 6102 823E      ld      r2,%823e
239E: A120           ld      r0,r2
23A0: 8122           add     r2,r2
23A2: 8102           add     r2,r0
23A4: 8B12           cp      r2,r1
23A6: EF33           jr      nc/uge,%240e
23A8: 6300 8222      res     %8222,0
23AC: 8102           add     r2,r0
23AE: 8B12           cp      r2,r1
23B0: EF31           jr      nc/uge,%2414
23B2: 6500 8222      set     %8222,0
23B6: 8102           add     r2,r0
23B8: 8B12           cp      r2,r1
23BA: EF2C           jr      nc/uge,%2414
23BC: 6701 8222      bit     %8222,1
23C0: E61C           jr      eq/z,%23fa
23C2: 4D05 8222 0003 ld      %8222,#%0003
23C8: 6100 825C      ld      r0,%825c
23CC: 6F00 827A      ld      %827a,r0
23D0: 6101 8244      ld      r1,%8244
23D4: B10A           exts    rr0
23D6: 1B00 0020      div     rr0,#%0020
23DA: 4101 8218      add     r1,%8218
23DE: 0B01 FF81      cp      r1,#%ff81
23E2: E106           jr      lt,%23f0
23E4: 0B01 007F      cp      r1,#%007f
23E8: E205           jr      le,%23f4
23EA: 2101 007F      ld      r1,#%007f
23EE: E802           jr      %23f4
23F0: 2101 FF81      ld      r1,#%ff81
23F4: 6F01 8218      ld      %8218,r1
23F8: 9E08           ret     
23FA: 4D05 8222 0003 ld      %8222,#%0003
2400: 6100 825C      ld      r0,%825c
2404: 6F00 827A      ld      %827a,r0
2408: 6F00 8218      ld      %8218,r0
240C: 9E08           ret     
240E: 4D05 8222 0000 ld      %8222,#%0000
2414: 6701 8222      bit     %8222,1
2418: EED7           jr      ne/nz,%23c8
241A: 6100 8218      ld      r0,%8218
241E: 4300 827A      sub     r0,%827a
2422: 8D04           test    r0
2424: ED01           jr      pl,%2428
2426: 8D02           neg     r0
2428: 0B00 0005      cp      r0,#%0005
242C: EA07           jr      gt,%243c
242E: 6100 825C      ld      r0,%825c
2432: 6F00 827A      ld      %827a,r0
2436: 6F00 8218      ld      %8218,r0
243A: 9E08           ret     
243C: 6100 825C      ld      r0,%825c
2440: 6F00 827A      ld      %827a,r0
2444: 6101 8258      ld      r1,%8258
2448: 4300 8218      sub     r0,%8218
244C: ED01           jr      pl,%2450
244E: 8D12           neg     r1
2450: B10A           exts    rr0
2452: 1B00 0258      div     rr0,#%0258
2456: 4101 8218      add     r1,%8218
245A: 0B01 FF81      cp      r1,#%ff81
245E: E106           jr      lt,%246c
2460: 0B01 007F      cp      r1,#%007f
2464: E205           jr      le,%2470
2466: 2101 007F      ld      r1,#%007f
246A: E802           jr      %2470
246C: 2101 FF81      ld      r1,#%ff81
2470: 6F01 8218      ld      %8218,r1
2474: 9E08           ret     
2476: 6100 800C      ld      r0,%800c
247A: A102           ld      r2,r0
247C: 6101 819C      ld      r1,%819c
2480: A113           ld      r3,r1
2482: 6F00 819C      ld      %819c,r0
2486: 8289           subb    rl1,rl0
2488: B110           extsb   r1
248A: A110           ld      r0,r1
248C: 8D04           test    r0
248E: ED01           jr      pl,%2492
2490: 8D02           neg     r0
2492: 0B00 000A      cp      r0,#%000a
2496: E202           jr      le,%249c
2498: 2101 0000      ld      r1,#%0000
249C: 6F01 81A4      ld      %81a4,r1
24A0: 6101 8218      ld      r1,%8218
24A4: 6F01 81A0      ld      %81a0,r1
24A8: 5900 824A      mult    rr0,%824a
24AC: 1B00 000A      div     rr0,#%000a
24B0: 4301 8198      sub     r1,%8198
24B4: 8D12           neg     r1
24B6: 5900 818C      mult    rr0,%818c
24BA: B30D FFFD      sral    rr0,#3
24BE: A112           ld      r2,r1
24C0: B329 FFFF      sra     r2,#1
24C4: 8121           add     r1,r2
24C6: 4101 8188      add     r1,%8188
24CA: 9E04           ret     pe/ov
24CC: 6F01 8188      ld      %8188,r1
24D0: 9E0D           ret     pl
24D2: A910           inc     r1,1
24D4: 6F01 8188      ld      %8188,r1
24D8: 9E08           ret     
24DA: 4D04 81F8      test    %81f8
24DE: 5E0E 2608      jp      ne/nz,%2608
24E2: 4D04 8104      test    %8104
24E6: 5E0E 2608      jp      ne/nz,%2608
24EA: 6101 825C      ld      r1,%825c
24EE: A110           ld      r0,r1
24F0: 6103 81A4      ld      r3,%81a4
24F4: 6104 8100      ld      r4,%8100
24F8: 0704 0003      and     r4,#%0003
24FC: EE02           jr      ne/nz,%2502
24FE: 4103 81A6      add     r3,%81a6
2502: 4D05 81A6 0000 ld      %81a6,#%0000
2508: A132           ld      r2,r3
250A: 4D04 81F4      test    %81f4
250E: E65F           jr      eq/z,%25ce
2510: A104           ld      r4,r0
2512: 4304 8198      sub     r4,%8198
2516: E63E           jr      eq/z,%2594
2518: A145           ld      r5,r4
251A: 8D54           test    r5
251C: ED01           jr      pl,%2520
251E: 8D52           neg     r5
2520: 0B05 0002      cp      r5,#%0002
2524: E11F           jr      lt,%2564
2526: 0B05 0004      cp      r5,#%0004
252A: E11F           jr      lt,%256a
252C: 0B05 0006      cp      r5,#%0006
2530: E11F           jr      lt,%2570
2532: 0B05 0008      cp      r5,#%0008
2536: E11F           jr      lt,%2576
2538: 0B05 000A      cp      r5,#%000a
253C: E11F           jr      lt,%257c
253E: 0B05 0010      cp      r5,#%0010
2542: E106           jr      lt,%2550
2544: 0B05 0020      cp      r5,#%0020
2548: E106           jr      lt,%2556
254A: 2106 0003      ld      r6,#%0003
254E: E805           jr      %255a
2550: 2106 0001      ld      r6,#%0001
2554: E802           jr      %255a
2556: 2106 0002      ld      r6,#%0002
255A: 8D44           test    r4
255C: A164           ld      r4,r6
255E: ED1B           jr      pl,%2596
2560: 8D42           neg     r4
2562: E819           jr      %2596
2564: 2106 001F      ld      r6,#%001f
2568: E80B           jr      %2580
256A: 2106 000F      ld      r6,#%000f
256E: E808           jr      %2580
2570: 2106 0007      ld      r6,#%0007
2574: E805           jr      %2580
2576: 2106 0003      ld      r6,#%0003
257A: E802           jr      %2580
257C: 2106 0001      ld      r6,#%0001
2580: 8D44           test    r4
2582: 2104 0001      ld      r4,#%0001
2586: ED02           jr      pl,%258c
2588: 2104 FFFF      ld      r4,#%ffff
258C: 6105 8100      ld      r5,%8100
2590: 8765           and     r5,r6
2592: E601           jr      eq/z,%2596
2594: 8D48           clr     r4
2596: 8D14           test    r1
2598: ED01           jr      pl,%259c
259A: 8D12           neg     r1
259C: 0B01 0009      cp      r1,#%0009
25A0: E105           jr      lt,%25ac
25A2: 0B01 002D      cp      r1,#%002d
25A6: E101           jr      lt,%25aa
25A8: 8132           add     r2,r3
25AA: 8132           add     r2,r3
25AC: 8132           add     r2,r3
25AE: 8102           add     r2,r0
25B0: 8342           sub     r2,r4
25B2: 0B02 FF81      cp      r2,#%ff81
25B6: E106           jr      lt,%25c4
25B8: 0B02 007F      cp      r2,#%007f
25BC: E205           jr      le,%25c8
25BE: 2102 007F      ld      r2,#%007f
25C2: E802           jr      %25c8
25C4: 2102 FF81      ld      r2,#%ff81
25C8: 6F02 825C      ld      %825c,r2
25CC: 9E08           ret     
25CE: 8D48           clr     r4
25D0: 8D14           test    r1
25D2: ED01           jr      pl,%25d6
25D4: 8D12           neg     r1
25D6: 0B01 0009      cp      r1,#%0009
25DA: E106           jr      lt,%25e8
25DC: 0B01 002D      cp      r1,#%002d
25E0: E102           jr      lt,%25e6
25E2: 8132           add     r2,r3
25E4: 8132           add     r2,r3
25E6: 8132           add     r2,r3
25E8: 8102           add     r2,r0
25EA: 8342           sub     r2,r4
25EC: 0B02 FF81      cp      r2,#%ff81
25F0: E106           jr      lt,%25fe
25F2: 0B02 007F      cp      r2,#%007f
25F6: E205           jr      le,%2602
25F8: 2102 007F      ld      r2,#%007f
25FC: E802           jr      %2602
25FE: 2102 FF81      ld      r2,#%ff81
2602: 6F02 825C      ld      %825c,r2
2606: 9E08           ret     
2608: 4D01 81F0 0003 cp      %81f0,#%0003
260E: 9E02           ret     le
2610: 6100 825C      ld      r0,%825c
2614: 8D02           neg     r0
2616: B309 FFFD      sra     r0,#3
261A: 4100 825C      add     r0,%825c
261E: 6F00 825C      ld      %825c,r0
2622: 6101 8188      ld      r1,%8188
2626: B10A           exts    rr0
2628: 1B00 07D0      div     rr0,#%07d0
262C: 4101 825C      add     r1,%825c
2630: 6F01 825C      ld      %825c,r1
2634: 9E08           ret     
2636: 4D04 8104      test    %8104
263A: EE11           jr      ne/nz,%265e
263C: 6101 8C60      ld      r1,%8c60
2640: 0A09 0404      cpb     rl1,#%04
2644: E60C           jr      eq/z,%265e
2646: 6701 8222      bit     %8222,1
264A: EE05           jr      ne/nz,%2656
264C: 6101 8276      ld      r1,%8276
2650: 6F01 80E8      ld      %80e8,r1
2654: 9E08           ret     
2656: 4D05 80E8 000A ld      %80e8,#%000a
265C: 9E08           ret     
265E: 4D05 80E8 0000 ld      %80e8,#%0000
2664: 9E08           ret     
2666: 4D04 8104      test    %8104
266A: 9E0E           ret     ne/nz
266C: 6100 8194      ld      r0,%8194
2670: 8100           add     r0,r0
2672: 9E06           ret     eq/z
2674: 4D01 818C 0002 cp      %818c,#%0002
267A: 9E07           ret     c/ult
267C: 4100 80E8      add     r0,%80e8
2680: 6F00 80E8      ld      %80e8,r0
2684: 0B00 0010      cp      r0,#%0010
2688: 9E07           ret     c/ult
268A: 4D05 80E8 000F ld      %80e8,#%000f
2690: 9E08           ret     
2692: DF72           calr    %27b0
2694: 4D01 8000 0059 cp      %8000,#%0059
269A: 9E0E           ret     ne/nz
269C: 6100 8002      ld      r0,%8002
26A0: 0700 00FF      and     r0,#%00ff
26A4: 0B00 0010      cp      r0,#%0010
26A8: E720           jr      c/ult,%26ea
26AA: 0B00 0019      cp      r0,#%0019
26AE: E724           jr      c/ult,%26f8
26B0: 4D04 813E      test    %813e
26B4: E603           jr      eq/z,%26bc
26B6: 6B00 813E      dec     %813e,1
26BA: 9E08           ret     
26BC: 6101 8100      ld      r1,%8100
26C0: 0701 000F      and     r1,#%000f
26C4: 9E0E           ret     ne/nz
26C6: 6100 8004      ld      r0,%8004
26CA: 0700 00FF      and     r0,#%00ff
26CE: 0B00 0012      cp      r0,#%0012
26D2: E607           jr      eq/z,%26e2
26D4: 0B00 0013      cp      r0,#%0013
26D8: 9E0E           ret     ne/nz
26DA: DFD5           calr    %2732
26DC: 6B00 8130      dec     %8130,1
26E0: 9E08           ret     
26E2: DFD9           calr    %2732
26E4: 6900 8130      inc     %8130,1
26E8: 9E08           ret     
26EA: 6101 8130      ld      r1,%8130
26EE: BE98           rldb    rl0,rl1
26F0: BE18           rldb    rl0,rh1
26F2: 6F01 8130      ld      %8130,r1
26F6: 9E08           ret     
26F8: 0300 0010      sub     r0,#%0010
26FC: 8100           add     r0,r0
26FE: 3401 0006      ldar    pr1,%2708
2702: 8101           add     r1,r0
2704: 2111           ld      r1,@r1
2706: 1E18           jp      @rr1
2708: 271A           bit     @r1,10
270A: 2732           bit     @r3,2
270C: 2748           bit     @r4,8
270E: 2756           bit     @r5,6
2710: 2764           bit     @r6,4
2712: 2774           bit     @r7,4
2714: 2784           bit     @r8,4
2716: 2794           bit     @r9,4
2718: 279C           bit     @r9,12
271A: 6101 8132      ld      r1,%8132
271E: 8111           add     r1,r1
2720: 0701 0006      and     r1,#%0006
2724: 6102 8130      ld      r2,%8130
2728: 0702 FFFE      and     r2,#%fffe
272C: 6F12 8134      ld      %8134(r1),r2
2730: 9E08           ret     
2732: 6101 8132      ld      r1,%8132
2736: 8111           add     r1,r1
2738: 0701 0006      and     r1,#%0006
273C: 6112 8134      ld      r2,%8134(r1)
2740: 6103 8130      ld      r3,%8130
2744: 2F23           ld      @r2,r3
2746: 9E08           ret     
2748: D00C           calr    %2732
274A: 6900 8130      inc     %8130,1
274E: 4D05 813E 0028 ld      %813e,#%0028
2754: 9E08           ret     
2756: D013           calr    %2732
2758: 6B00 8130      dec     %8130,1
275C: 4D05 813E 0028 ld      %813e,#%0028
2762: 9E08           ret     
2764: 6101 8132      ld      r1,%8132
2768: 8111           add     r1,r1
276A: 0701 0006      and     r1,#%0006
276E: 6911 8134      inc     %8134(r1),2
2772: 9E08           ret     
2774: 6101 8132      ld      r1,%8132
2778: 8111           add     r1,r1
277A: 0701 0006      and     r1,#%0006
277E: 6B11 8134      dec     %8134(r1),2
2782: 9E08           ret     
2784: 6100 8132      ld      r0,%8132
2788: A900           inc     r0,1
278A: 0700 0003      and     r0,#%0003
278E: 6F00 8132      ld      %8132,r0
2792: 9E08           ret     
2794: 4D05 8000 0073 ld      %8000,#%0073
279A: 9E08           ret     
279C: 6101 8132      ld      r1,%8132
27A0: 8111           add     r1,r1
27A2: 0701 0006      and     r1,#%0006
27A6: 6112 8134      ld      r2,%8134(r1)
27AA: 0702 FFFE      and     r2,#%fffe
27AE: 1E28           jp      @rr2
27B0: 4D01 8000 0059 cp      %8000,#%0059
27B6: 9E0E           ret     ne/nz
27B8: 210D 990C      ld      r13,#%990c
27BC: 6100 8130      ld      r0,%8130
27C0: DFD5           calr    %2818
27C2: 010D 006E      add     r13,#%006e
27C6: 2101 8134      ld      r1,#%8134
27CA: 2102 0004      ld      r2,#%0004
27CE: 2110           ld      r0,@r1
27D0: DFDD           calr    %2818
27D2: A9D1           inc     r13,2
27D4: A103           ld      r3,r0
27D6: 2130           ld      r0,@r3
27D8: DFE1           calr    %2818
27DA: 010D 006E      add     r13,#%006e
27DE: A911           inc     r1,2
27E0: F28A           djnz    r2,%27ce
27E2: 4D01 8000 0059 cp      %8000,#%0059
27E8: 9E0E           ret     ne/nz
27EA: 6100 8100      ld      r0,%8100
27EE: 0700 001F      and     r0,#%001f
27F2: 0B00 0008      cp      r0,#%0008
27F6: 9E0F           ret     nc/uge
27F8: 6101 8132      ld      r1,%8132
27FC: 0701 0003      and     r1,#%0003
2800: B311 0007      sll     r1,#7
2804: 0101 9982      add     r1,#%9982
2808: 2102 000A      ld      r2,#%000a
280C: 2110           ld      r0,@r1
280E: C824           ldb     rl0,#%24
2810: 2F10           ld      @r1,r0
2812: A911           inc     r1,2
2814: F285           djnz    r2,%280c
2816: 9E08           ret     
2818: 93F4           push    @r15,r4
281A: 93F5           push    @r15,r5
281C: A104           ld      r4,r0
281E: 21D5           ld      r5,@r13
2820: 8CD8           clrb    rl5
2822: BE4D           rldb    rl5,rh4
2824: 2FD5           ld      @r13,r5
2826: A9D1           inc     r13,2
2828: BE4D           rldb    rl5,rh4
282A: 2FD5           ld      @r13,r5
282C: A9D1           inc     r13,2
282E: BECD           rldb    rl5,rl4
2830: 2FD5           ld      @r13,r5
2832: A9D1           inc     r13,2
2834: BECD           rldb    rl5,rl4
2836: 2FD5           ld      @r13,r5
2838: A9D1           inc     r13,2
283A: 97F5           pop     r5,@r15
283C: 97F4           pop     r4,@r15
283E: 9E08           ret     
2840: FFFF           djnz    r15,%2744
2842: FFFF           djnz    r15,%2746
2844: FFFF           djnz    r15,%2748
2846: FFFF           djnz    r15,%274a
2848: FFFF           djnz    r15,%274c
284A: FFFF           djnz    r15,%274e
284C: FFFF           djnz    r15,%2750
284E: FFFF           djnz    r15,%2752
2850: FFFF           djnz    r15,%2754
2852: FFFF           djnz    r15,%2756
2854: FFFF           djnz    r15,%2758
2856: FFFF           djnz    r15,%275a
2858: FFFF           djnz    r15,%275c
285A: FFFF           djnz    r15,%275e
285C: FFFF           djnz    r15,%2760
285E: FFFF           djnz    r15,%2762
2860: FFFF           djnz    r15,%2764
2862: FFFF           djnz    r15,%2766
2864: FFFF           djnz    r15,%2768
2866: FFFF           djnz    r15,%276a
2868: FFFF           djnz    r15,%276c
286A: FFFF           djnz    r15,%276e
286C: FFFF           djnz    r15,%2770
286E: FFFF           djnz    r15,%2772
2870: FFFF           djnz    r15,%2774
2872: FFFF           djnz    r15,%2776
2874: FFFF           djnz    r15,%2778
2876: FFFF           djnz    r15,%277a
2878: FFFF           djnz    r15,%277c
287A: FFFF           djnz    r15,%277e
287C: FFFF           djnz    r15,%2780
287E: FFFF           djnz    r15,%2782
2880: FFFF           djnz    r15,%2784
2882: FFFF           djnz    r15,%2786
2884: FFFF           djnz    r15,%2788
2886: FFFF           djnz    r15,%278a
2888: FFFF           djnz    r15,%278c
288A: FFFF           djnz    r15,%278e
288C: FFFF           djnz    r15,%2790
288E: FFFF           djnz    r15,%2792
2890: FFFF           djnz    r15,%2794
2892: FFFF           djnz    r15,%2796
2894: FFFF           djnz    r15,%2798
2896: FFFF           djnz    r15,%279a
2898: FFFF           djnz    r15,%279c
289A: FFFF           djnz    r15,%279e
289C: FFFF           djnz    r15,%27a0
289E: FFFF           djnz    r15,%27a2
28A0: FFFF           djnz    r15,%27a4
28A2: FFFF           djnz    r15,%27a6
28A4: FFFF           djnz    r15,%27a8
28A6: FFFF           djnz    r15,%27aa
28A8: FFFF           djnz    r15,%27ac
28AA: FFFF           djnz    r15,%27ae
28AC: FFFF           djnz    r15,%27b0
28AE: FFFF           djnz    r15,%27b2
28B0: FFFF           djnz    r15,%27b4
28B2: FFFF           djnz    r15,%27b6
28B4: FFFF           djnz    r15,%27b8
28B6: FFFF           djnz    r15,%27ba
28B8: FFFF           djnz    r15,%27bc
28BA: FFFF           djnz    r15,%27be
28BC: FFFF           djnz    r15,%27c0
28BE: FFFF           djnz    r15,%27c2
28C0: FFFF           djnz    r15,%27c4
28C2: FFFF           djnz    r15,%27c6
28C4: FFFF           djnz    r15,%27c8
28C6: FFFF           djnz    r15,%27ca
28C8: FFFF           djnz    r15,%27cc
28CA: FFFF           djnz    r15,%27ce
28CC: FFFF           djnz    r15,%27d0
28CE: FFFF           djnz    r15,%27d2
28D0: FFFF           djnz    r15,%27d4
28D2: FFFF           djnz    r15,%27d6
28D4: FFFF           djnz    r15,%27d8
28D6: FFFF           djnz    r15,%27da
28D8: FFFF           djnz    r15,%27dc
28DA: FFFF           djnz    r15,%27de
28DC: FFFF           djnz    r15,%27e0
28DE: FFFF           djnz    r15,%27e2
28E0: FFFF           djnz    r15,%27e4
28E2: FFFF           djnz    r15,%27e6
28E4: FFFF           djnz    r15,%27e8
28E6: FFFF           djnz    r15,%27ea
28E8: FFFF           djnz    r15,%27ec
28EA: FFFF           djnz    r15,%27ee
28EC: FFFF           djnz    r15,%27f0
28EE: FFFF           djnz    r15,%27f2
28F0: FFFF           djnz    r15,%27f4
28F2: FFFF           djnz    r15,%27f6
28F4: FFFF           djnz    r15,%27f8
28F6: FFFF           djnz    r15,%27fa
28F8: FFFF           djnz    r15,%27fc
28FA: FFFF           djnz    r15,%27fe
28FC: FFFF           djnz    r15,%2800
28FE: FFFF           djnz    r15,%2802
2900: FFFF           djnz    r15,%2804
2902: FFFF           djnz    r15,%2806
2904: FFFF           djnz    r15,%2808
2906: FFFF           djnz    r15,%280a
2908: FFFF           djnz    r15,%280c
290A: FFFF           djnz    r15,%280e
290C: FFFF           djnz    r15,%2810
290E: FFFF           djnz    r15,%2812
2910: FFFF           djnz    r15,%2814
2912: FFFF           djnz    r15,%2816
2914: FFFF           djnz    r15,%2818
2916: FFFF           djnz    r15,%281a
2918: FFFF           djnz    r15,%281c
291A: FFFF           djnz    r15,%281e
291C: FFFF           djnz    r15,%2820
291E: FFFF           djnz    r15,%2822
2920: FFFF           djnz    r15,%2824
2922: FFFF           djnz    r15,%2826
2924: FFFF           djnz    r15,%2828
2926: FFFF           djnz    r15,%282a
2928: FFFF           djnz    r15,%282c
292A: FFFF           djnz    r15,%282e
292C: FFFF           djnz    r15,%2830
292E: FFFF           djnz    r15,%2832
2930: FFFF           djnz    r15,%2834
2932: FFFF           djnz    r15,%2836
2934: FFFF           djnz    r15,%2838
2936: FFFF           djnz    r15,%283a
2938: FFFF           djnz    r15,%283c
293A: FFFF           djnz    r15,%283e
293C: FFFF           djnz    r15,%2840
293E: FFFF           djnz    r15,%2842
2940: FFFF           djnz    r15,%2844
2942: FFFF           djnz    r15,%2846
2944: FFFF           djnz    r15,%2848
2946: FFFF           djnz    r15,%284a
2948: FFFF           djnz    r15,%284c
294A: FFFF           djnz    r15,%284e
294C: FFFF           djnz    r15,%2850
294E: FFFF           djnz    r15,%2852
2950: FFFF           djnz    r15,%2854
2952: FFFF           djnz    r15,%2856
2954: FFFF           djnz    r15,%2858
2956: FFFF           djnz    r15,%285a
2958: FFFF           djnz    r15,%285c
295A: FFFF           djnz    r15,%285e
295C: FFFF           djnz    r15,%2860
295E: FFFF           djnz    r15,%2862
2960: FFFF           djnz    r15,%2864
2962: FFFF           djnz    r15,%2866
2964: FFFF           djnz    r15,%2868
2966: FFFF           djnz    r15,%286a
2968: FFFF           djnz    r15,%286c
296A: FFFF           djnz    r15,%286e
296C: FFFF           djnz    r15,%2870
296E: FFFF           djnz    r15,%2872
2970: FFFF           djnz    r15,%2874
2972: FFFF           djnz    r15,%2876
2974: FFFF           djnz    r15,%2878
2976: FFFF           djnz    r15,%287a
2978: FFFF           djnz    r15,%287c
297A: FFFF           djnz    r15,%287e
297C: FFFF           djnz    r15,%2880
297E: FFFF           djnz    r15,%2882
2980: FFFF           djnz    r15,%2884
2982: FFFF           djnz    r15,%2886
2984: FFFF           djnz    r15,%2888
2986: FFFF           djnz    r15,%288a
2988: FFFF           djnz    r15,%288c
298A: FFFF           djnz    r15,%288e
298C: FFFF           djnz    r15,%2890
298E: FFFF           djnz    r15,%2892
2990: FFFF           djnz    r15,%2894
2992: FFFF           djnz    r15,%2896
2994: FFFF           djnz    r15,%2898
2996: FFFF           djnz    r15,%289a
2998: FFFF           djnz    r15,%289c
299A: FFFF           djnz    r15,%289e
299C: FFFF           djnz    r15,%28a0
299E: FFFF           djnz    r15,%28a2
29A0: FFFF           djnz    r15,%28a4
29A2: FFFF           djnz    r15,%28a6
29A4: FFFF           djnz    r15,%28a8
29A6: FFFF           djnz    r15,%28aa
29A8: FFFF           djnz    r15,%28ac
29AA: FFFF           djnz    r15,%28ae
29AC: FFFF           djnz    r15,%28b0
29AE: FFFF           djnz    r15,%28b2
29B0: FFFF           djnz    r15,%28b4
29B2: FFFF           djnz    r15,%28b6
29B4: FFFF           djnz    r15,%28b8
29B6: FFFF           djnz    r15,%28ba
29B8: FFFF           djnz    r15,%28bc
29BA: FFFF           djnz    r15,%28be
29BC: FFFF           djnz    r15,%28c0
29BE: FFFF           djnz    r15,%28c2
29C0: FFFF           djnz    r15,%28c4
29C2: FFFF           djnz    r15,%28c6
29C4: FFFF           djnz    r15,%28c8
29C6: FFFF           djnz    r15,%28ca
29C8: FFFF           djnz    r15,%28cc
29CA: FFFF           djnz    r15,%28ce
29CC: FFFF           djnz    r15,%28d0
29CE: FFFF           djnz    r15,%28d2
29D0: FFFF           djnz    r15,%28d4
29D2: FFFF           djnz    r15,%28d6
29D4: FFFF           djnz    r15,%28d8
29D6: FFFF           djnz    r15,%28da
29D8: FFFF           djnz    r15,%28dc
29DA: FFFF           djnz    r15,%28de
29DC: FFFF           djnz    r15,%28e0
29DE: FFFF           djnz    r15,%28e2
29E0: FFFF           djnz    r15,%28e4
29E2: FFFF           djnz    r15,%28e6
29E4: FFFF           djnz    r15,%28e8
29E6: FFFF           djnz    r15,%28ea
29E8: FFFF           djnz    r15,%28ec
29EA: FFFF           djnz    r15,%28ee
29EC: FFFF           djnz    r15,%28f0
29EE: FFFF           djnz    r15,%28f2
29F0: FFFF           djnz    r15,%28f4
29F2: FFFF           djnz    r15,%28f6
29F4: FFFF           djnz    r15,%28f8
29F6: FFFF           djnz    r15,%28fa
29F8: FFFF           djnz    r15,%28fc
29FA: FFFF           djnz    r15,%28fe
29FC: FFFF           djnz    r15,%2900
29FE: FFFF           djnz    r15,%2902
2A00: FFFF           djnz    r15,%2904
2A02: FFFF           djnz    r15,%2906
2A04: FFFF           djnz    r15,%2908
2A06: FFFF           djnz    r15,%290a
2A08: FFFF           djnz    r15,%290c
2A0A: FFFF           djnz    r15,%290e
2A0C: FFFF           djnz    r15,%2910
2A0E: FFFF           djnz    r15,%2912
2A10: FFFF           djnz    r15,%2914
2A12: FFFF           djnz    r15,%2916
2A14: FFFF           djnz    r15,%2918
2A16: FFFF           djnz    r15,%291a
2A18: FFFF           djnz    r15,%291c
2A1A: FFFF           djnz    r15,%291e
2A1C: FFFF           djnz    r15,%2920
2A1E: FFFF           djnz    r15,%2922
2A20: FFFF           djnz    r15,%2924
2A22: FFFF           djnz    r15,%2926
2A24: FFFF           djnz    r15,%2928
2A26: FFFF           djnz    r15,%292a
2A28: FFFF           djnz    r15,%292c
2A2A: FFFF           djnz    r15,%292e
2A2C: FFFF           djnz    r15,%2930
2A2E: FFFF           djnz    r15,%2932
2A30: FFFF           djnz    r15,%2934
2A32: FFFF           djnz    r15,%2936
2A34: FFFF           djnz    r15,%2938
2A36: FFFF           djnz    r15,%293a
2A38: FFFF           djnz    r15,%293c
2A3A: FFFF           djnz    r15,%293e
2A3C: FFFF           djnz    r15,%2940
2A3E: FFFF           djnz    r15,%2942
2A40: FFFF           djnz    r15,%2944
2A42: FFFF           djnz    r15,%2946
2A44: FFFF           djnz    r15,%2948
2A46: FFFF           djnz    r15,%294a
2A48: FFFF           djnz    r15,%294c
2A4A: FFFF           djnz    r15,%294e
2A4C: FFFF           djnz    r15,%2950
2A4E: FFFF           djnz    r15,%2952
2A50: FFFF           djnz    r15,%2954
2A52: FFFF           djnz    r15,%2956
2A54: FFFF           djnz    r15,%2958
2A56: FFFF           djnz    r15,%295a
2A58: FFFF           djnz    r15,%295c
2A5A: FFFF           djnz    r15,%295e
2A5C: FFFF           djnz    r15,%2960
2A5E: FFFF           djnz    r15,%2962
2A60: FFFF           djnz    r15,%2964
2A62: FFFF           djnz    r15,%2966
2A64: FFFF           djnz    r15,%2968
2A66: FFFF           djnz    r15,%296a
2A68: FFFF           djnz    r15,%296c
2A6A: FFFF           djnz    r15,%296e
2A6C: FFFF           djnz    r15,%2970
2A6E: FFFF           djnz    r15,%2972
2A70: FFFF           djnz    r15,%2974
2A72: FFFF           djnz    r15,%2976
2A74: FFFF           djnz    r15,%2978
2A76: FFFF           djnz    r15,%297a
2A78: FFFF           djnz    r15,%297c
2A7A: FFFF           djnz    r15,%297e
2A7C: FFFF           djnz    r15,%2980
2A7E: FFFF           djnz    r15,%2982
2A80: FFFF           djnz    r15,%2984
2A82: FFFF           djnz    r15,%2986
2A84: FFFF           djnz    r15,%2988
2A86: FFFF           djnz    r15,%298a
2A88: FFFF           djnz    r15,%298c
2A8A: FFFF           djnz    r15,%298e
2A8C: FFFF           djnz    r15,%2990
2A8E: FFFF           djnz    r15,%2992
2A90: FFFF           djnz    r15,%2994
2A92: FFFF           djnz    r15,%2996
2A94: FFFF           djnz    r15,%2998
2A96: FFFF           djnz    r15,%299a
2A98: FFFF           djnz    r15,%299c
2A9A: FFFF           djnz    r15,%299e
2A9C: FFFF           djnz    r15,%29a0
2A9E: FFFF           djnz    r15,%29a2
2AA0: FFFF           djnz    r15,%29a4
2AA2: FFFF           djnz    r15,%29a6
2AA4: FFFF           djnz    r15,%29a8
2AA6: FFFF           djnz    r15,%29aa
2AA8: FFFF           djnz    r15,%29ac
2AAA: FFFF           djnz    r15,%29ae
2AAC: FFFF           djnz    r15,%29b0
2AAE: FFFF           djnz    r15,%29b2
2AB0: FFFF           djnz    r15,%29b4
2AB2: FFFF           djnz    r15,%29b6
2AB4: FFFF           djnz    r15,%29b8
2AB6: FFFF           djnz    r15,%29ba
2AB8: FFFF           djnz    r15,%29bc
2ABA: FFFF           djnz    r15,%29be
2ABC: FFFF           djnz    r15,%29c0
2ABE: FFFF           djnz    r15,%29c2
2AC0: FFFF           djnz    r15,%29c4
2AC2: FFFF           djnz    r15,%29c6
2AC4: FFFF           djnz    r15,%29c8
2AC6: FFFF           djnz    r15,%29ca
2AC8: FFFF           djnz    r15,%29cc
2ACA: FFFF           djnz    r15,%29ce
2ACC: FFFF           djnz    r15,%29d0
2ACE: FFFF           djnz    r15,%29d2
2AD0: FFFF           djnz    r15,%29d4
2AD2: FFFF           djnz    r15,%29d6
2AD4: FFFF           djnz    r15,%29d8
2AD6: FFFF           djnz    r15,%29da
2AD8: FFFF           djnz    r15,%29dc
2ADA: FFFF           djnz    r15,%29de
2ADC: FFFF           djnz    r15,%29e0
2ADE: FFFF           djnz    r15,%29e2
2AE0: FFFF           djnz    r15,%29e4
2AE2: FFFF           djnz    r15,%29e6
2AE4: FFFF           djnz    r15,%29e8
2AE6: FFFF           djnz    r15,%29ea
2AE8: FFFF           djnz    r15,%29ec
2AEA: FFFF           djnz    r15,%29ee
2AEC: FFFF           djnz    r15,%29f0
2AEE: FFFF           djnz    r15,%29f2
2AF0: FFFF           djnz    r15,%29f4
2AF2: FFFF           djnz    r15,%29f6
2AF4: FFFF           djnz    r15,%29f8
2AF6: FFFF           djnz    r15,%29fa
2AF8: FFFF           djnz    r15,%29fc
2AFA: FFFF           djnz    r15,%29fe
2AFC: FFFF           djnz    r15,%2a00
2AFE: FFFF           djnz    r15,%2a02
2B00: FFFF           djnz    r15,%2a04
2B02: FFFF           djnz    r15,%2a06
2B04: FFFF           djnz    r15,%2a08
2B06: FFFF           djnz    r15,%2a0a
2B08: FFFF           djnz    r15,%2a0c
2B0A: FFFF           djnz    r15,%2a0e
2B0C: FFFF           djnz    r15,%2a10
2B0E: FFFF           djnz    r15,%2a12
2B10: FFFF           djnz    r15,%2a14
2B12: FFFF           djnz    r15,%2a16
2B14: FFFF           djnz    r15,%2a18
2B16: FFFF           djnz    r15,%2a1a
2B18: FFFF           djnz    r15,%2a1c
2B1A: FFFF           djnz    r15,%2a1e
2B1C: FFFF           djnz    r15,%2a20
2B1E: FFFF           djnz    r15,%2a22
2B20: FFFF           djnz    r15,%2a24
2B22: FFFF           djnz    r15,%2a26
2B24: FFFF           djnz    r15,%2a28
2B26: FFFF           djnz    r15,%2a2a
2B28: FFFF           djnz    r15,%2a2c
2B2A: FFFF           djnz    r15,%2a2e
2B2C: FFFF           djnz    r15,%2a30
2B2E: FFFF           djnz    r15,%2a32
2B30: FFFF           djnz    r15,%2a34
2B32: FFFF           djnz    r15,%2a36
2B34: FFFF           djnz    r15,%2a38
2B36: FFFF           djnz    r15,%2a3a
2B38: FFFF           djnz    r15,%2a3c
2B3A: FFFF           djnz    r15,%2a3e
2B3C: FFFF           djnz    r15,%2a40
2B3E: FFFF           djnz    r15,%2a42
2B40: FFFF           djnz    r15,%2a44
2B42: FFFF           djnz    r15,%2a46
2B44: FFFF           djnz    r15,%2a48
2B46: FFFF           djnz    r15,%2a4a
2B48: FFFF           djnz    r15,%2a4c
2B4A: FFFF           djnz    r15,%2a4e
2B4C: FFFF           djnz    r15,%2a50
2B4E: FFFF           djnz    r15,%2a52
2B50: FFFF           djnz    r15,%2a54
2B52: FFFF           djnz    r15,%2a56
2B54: FFFF           djnz    r15,%2a58
2B56: FFFF           djnz    r15,%2a5a
2B58: FFFF           djnz    r15,%2a5c
2B5A: FFFF           djnz    r15,%2a5e
2B5C: FFFF           djnz    r15,%2a60
2B5E: FFFF           djnz    r15,%2a62
2B60: FFFF           djnz    r15,%2a64
2B62: FFFF           djnz    r15,%2a66
2B64: FFFF           djnz    r15,%2a68
2B66: FFFF           djnz    r15,%2a6a
2B68: FFFF           djnz    r15,%2a6c
2B6A: FFFF           djnz    r15,%2a6e
2B6C: FFFF           djnz    r15,%2a70
2B6E: FFFF           djnz    r15,%2a72
2B70: FFFF           djnz    r15,%2a74
2B72: FFFF           djnz    r15,%2a76
2B74: FFFF           djnz    r15,%2a78
2B76: FFFF           djnz    r15,%2a7a
2B78: FFFF           djnz    r15,%2a7c
2B7A: FFFF           djnz    r15,%2a7e
2B7C: FFFF           djnz    r15,%2a80
2B7E: FFFF           djnz    r15,%2a82
2B80: FFFF           djnz    r15,%2a84
2B82: FFFF           djnz    r15,%2a86
2B84: FFFF           djnz    r15,%2a88
2B86: FFFF           djnz    r15,%2a8a
2B88: FFFF           djnz    r15,%2a8c
2B8A: FFFF           djnz    r15,%2a8e
2B8C: FFFF           djnz    r15,%2a90
2B8E: FFFF           djnz    r15,%2a92
2B90: FFFF           djnz    r15,%2a94
2B92: FFFF           djnz    r15,%2a96
2B94: FFFF           djnz    r15,%2a98
2B96: FFFF           djnz    r15,%2a9a
2B98: FFFF           djnz    r15,%2a9c
2B9A: FFFF           djnz    r15,%2a9e
2B9C: FFFF           djnz    r15,%2aa0
2B9E: FFFF           djnz    r15,%2aa2
2BA0: FFFF           djnz    r15,%2aa4
2BA2: FFFF           djnz    r15,%2aa6
2BA4: FFFF           djnz    r15,%2aa8
2BA6: FFFF           djnz    r15,%2aaa
2BA8: FFFF           djnz    r15,%2aac
2BAA: FFFF           djnz    r15,%2aae
2BAC: FFFF           djnz    r15,%2ab0
2BAE: FFFF           djnz    r15,%2ab2
2BB0: FFFF           djnz    r15,%2ab4
2BB2: FFFF           djnz    r15,%2ab6
2BB4: FFFF           djnz    r15,%2ab8
2BB6: FFFF           djnz    r15,%2aba
2BB8: FFFF           djnz    r15,%2abc
2BBA: FFFF           djnz    r15,%2abe
2BBC: FFFF           djnz    r15,%2ac0
2BBE: FFFF           djnz    r15,%2ac2
2BC0: FFFF           djnz    r15,%2ac4
2BC2: FFFF           djnz    r15,%2ac6
2BC4: FFFF           djnz    r15,%2ac8
2BC6: FFFF           djnz    r15,%2aca
2BC8: FFFF           djnz    r15,%2acc
2BCA: FFFF           djnz    r15,%2ace
2BCC: FFFF           djnz    r15,%2ad0
2BCE: FFFF           djnz    r15,%2ad2
2BD0: FFFF           djnz    r15,%2ad4
2BD2: FFFF           djnz    r15,%2ad6
2BD4: FFFF           djnz    r15,%2ad8
2BD6: FFFF           djnz    r15,%2ada
2BD8: FFFF           djnz    r15,%2adc
2BDA: FFFF           djnz    r15,%2ade
2BDC: FFFF           djnz    r15,%2ae0
2BDE: FFFF           djnz    r15,%2ae2
2BE0: FFFF           djnz    r15,%2ae4
2BE2: FFFF           djnz    r15,%2ae6
2BE4: FFFF           djnz    r15,%2ae8
2BE6: FFFF           djnz    r15,%2aea
2BE8: FFFF           djnz    r15,%2aec
2BEA: FFFF           djnz    r15,%2aee
2BEC: FFFF           djnz    r15,%2af0
2BEE: FFFF           djnz    r15,%2af2
2BF0: FFFF           djnz    r15,%2af4
2BF2: FFFF           djnz    r15,%2af6
2BF4: FFFF           djnz    r15,%2af8
2BF6: FFFF           djnz    r15,%2afa
2BF8: FFFF           djnz    r15,%2afc
2BFA: FFFF           djnz    r15,%2afe
2BFC: FFFF           djnz    r15,%2b00
2BFE: FFFF           djnz    r15,%2b02
2C00: FFFF           djnz    r15,%2b04
2C02: FFFF           djnz    r15,%2b06
2C04: FFFF           djnz    r15,%2b08
2C06: FFFF           djnz    r15,%2b0a
2C08: FFFF           djnz    r15,%2b0c
2C0A: FFFF           djnz    r15,%2b0e
2C0C: FFFF           djnz    r15,%2b10
2C0E: FFFF           djnz    r15,%2b12
2C10: FFFF           djnz    r15,%2b14
2C12: FFFF           djnz    r15,%2b16
2C14: FFFF           djnz    r15,%2b18
2C16: FFFF           djnz    r15,%2b1a
2C18: FFFF           djnz    r15,%2b1c
2C1A: FFFF           djnz    r15,%2b1e
2C1C: FFFF           djnz    r15,%2b20
2C1E: FFFF           djnz    r15,%2b22
2C20: FFFF           djnz    r15,%2b24
2C22: FFFF           djnz    r15,%2b26
2C24: FFFF           djnz    r15,%2b28
2C26: FFFF           djnz    r15,%2b2a
2C28: FFFF           djnz    r15,%2b2c
2C2A: FFFF           djnz    r15,%2b2e
2C2C: FFFF           djnz    r15,%2b30
2C2E: FFFF           djnz    r15,%2b32
2C30: FFFF           djnz    r15,%2b34
2C32: FFFF           djnz    r15,%2b36
2C34: FFFF           djnz    r15,%2b38
2C36: FFFF           djnz    r15,%2b3a
2C38: FFFF           djnz    r15,%2b3c
2C3A: FFFF           djnz    r15,%2b3e
2C3C: FFFF           djnz    r15,%2b40
2C3E: FFFF           djnz    r15,%2b42
2C40: FFFF           djnz    r15,%2b44
2C42: FFFF           djnz    r15,%2b46
2C44: FFFF           djnz    r15,%2b48
2C46: FFFF           djnz    r15,%2b4a
2C48: FFFF           djnz    r15,%2b4c
2C4A: FFFF           djnz    r15,%2b4e
2C4C: FFFF           djnz    r15,%2b50
2C4E: FFFF           djnz    r15,%2b52
2C50: FFFF           djnz    r15,%2b54
2C52: FFFF           djnz    r15,%2b56
2C54: FFFF           djnz    r15,%2b58
2C56: FFFF           djnz    r15,%2b5a
2C58: FFFF           djnz    r15,%2b5c
2C5A: FFFF           djnz    r15,%2b5e
2C5C: FFFF           djnz    r15,%2b60
2C5E: FFFF           djnz    r15,%2b62
2C60: FFFF           djnz    r15,%2b64
2C62: FFFF           djnz    r15,%2b66
2C64: FFFF           djnz    r15,%2b68
2C66: FFFF           djnz    r15,%2b6a
2C68: FFFF           djnz    r15,%2b6c
2C6A: FFFF           djnz    r15,%2b6e
2C6C: FFFF           djnz    r15,%2b70
2C6E: FFFF           djnz    r15,%2b72
2C70: FFFF           djnz    r15,%2b74
2C72: FFFF           djnz    r15,%2b76
2C74: FFFF           djnz    r15,%2b78
2C76: FFFF           djnz    r15,%2b7a
2C78: FFFF           djnz    r15,%2b7c
2C7A: FFFF           djnz    r15,%2b7e
2C7C: FFFF           djnz    r15,%2b80
2C7E: FFFF           djnz    r15,%2b82
2C80: FFFF           djnz    r15,%2b84
2C82: FFFF           djnz    r15,%2b86
2C84: FFFF           djnz    r15,%2b88
2C86: FFFF           djnz    r15,%2b8a
2C88: FFFF           djnz    r15,%2b8c
2C8A: FFFF           djnz    r15,%2b8e
2C8C: FFFF           djnz    r15,%2b90
2C8E: FFFF           djnz    r15,%2b92
2C90: FFFF           djnz    r15,%2b94
2C92: FFFF           djnz    r15,%2b96
2C94: FFFF           djnz    r15,%2b98
2C96: FFFF           djnz    r15,%2b9a
2C98: FFFF           djnz    r15,%2b9c
2C9A: FFFF           djnz    r15,%2b9e
2C9C: FFFF           djnz    r15,%2ba0
2C9E: FFFF           djnz    r15,%2ba2
2CA0: FFFF           djnz    r15,%2ba4
2CA2: FFFF           djnz    r15,%2ba6
2CA4: FFFF           djnz    r15,%2ba8
2CA6: FFFF           djnz    r15,%2baa
2CA8: FFFF           djnz    r15,%2bac
2CAA: FFFF           djnz    r15,%2bae
2CAC: FFFF           djnz    r15,%2bb0
2CAE: FFFF           djnz    r15,%2bb2
2CB0: FFFF           djnz    r15,%2bb4
2CB2: FFFF           djnz    r15,%2bb6
2CB4: FFFF           djnz    r15,%2bb8
2CB6: FFFF           djnz    r15,%2bba
2CB8: FFFF           djnz    r15,%2bbc
2CBA: FFFF           djnz    r15,%2bbe
2CBC: FFFF           djnz    r15,%2bc0
2CBE: FFFF           djnz    r15,%2bc2
2CC0: FFFF           djnz    r15,%2bc4
2CC2: FFFF           djnz    r15,%2bc6
2CC4: FFFF           djnz    r15,%2bc8
2CC6: FFFF           djnz    r15,%2bca
2CC8: FFFF           djnz    r15,%2bcc
2CCA: FFFF           djnz    r15,%2bce
2CCC: FFFF           djnz    r15,%2bd0
2CCE: FFFF           djnz    r15,%2bd2
2CD0: FFFF           djnz    r15,%2bd4
2CD2: FFFF           djnz    r15,%2bd6
2CD4: FFFF           djnz    r15,%2bd8
2CD6: FFFF           djnz    r15,%2bda
2CD8: FFFF           djnz    r15,%2bdc
2CDA: FFFF           djnz    r15,%2bde
2CDC: FFFF           djnz    r15,%2be0
2CDE: FFFF           djnz    r15,%2be2
2CE0: FFFF           djnz    r15,%2be4
2CE2: FFFF           djnz    r15,%2be6
2CE4: FFFF           djnz    r15,%2be8
2CE6: FFFF           djnz    r15,%2bea
2CE8: FFFF           djnz    r15,%2bec
2CEA: FFFF           djnz    r15,%2bee
2CEC: FFFF           djnz    r15,%2bf0
2CEE: FFFF           djnz    r15,%2bf2
2CF0: FFFF           djnz    r15,%2bf4
2CF2: FFFF           djnz    r15,%2bf6
2CF4: FFFF           djnz    r15,%2bf8
2CF6: FFFF           djnz    r15,%2bfa
2CF8: FFFF           djnz    r15,%2bfc
2CFA: FFFF           djnz    r15,%2bfe
2CFC: FFFF           djnz    r15,%2c00
2CFE: FFFF           djnz    r15,%2c02
2D00: FFFF           djnz    r15,%2c04
2D02: FFFF           djnz    r15,%2c06
2D04: FFFF           djnz    r15,%2c08
2D06: FFFF           djnz    r15,%2c0a
2D08: FFFF           djnz    r15,%2c0c
2D0A: FFFF           djnz    r15,%2c0e
2D0C: FFFF           djnz    r15,%2c10
2D0E: FFFF           djnz    r15,%2c12
2D10: FFFF           djnz    r15,%2c14
2D12: FFFF           djnz    r15,%2c16
2D14: FFFF           djnz    r15,%2c18
2D16: FFFF           djnz    r15,%2c1a
2D18: FFFF           djnz    r15,%2c1c
2D1A: FFFF           djnz    r15,%2c1e
2D1C: FFFF           djnz    r15,%2c20
2D1E: FFFF           djnz    r15,%2c22
2D20: FFFF           djnz    r15,%2c24
2D22: FFFF           djnz    r15,%2c26
2D24: FFFF           djnz    r15,%2c28
2D26: FFFF           djnz    r15,%2c2a
2D28: FFFF           djnz    r15,%2c2c
2D2A: FFFF           djnz    r15,%2c2e
2D2C: FFFF           djnz    r15,%2c30
2D2E: FFFF           djnz    r15,%2c32
2D30: FFFF           djnz    r15,%2c34
2D32: FFFF           djnz    r15,%2c36
2D34: FFFF           djnz    r15,%2c38
2D36: FFFF           djnz    r15,%2c3a
2D38: FFFF           djnz    r15,%2c3c
2D3A: FFFF           djnz    r15,%2c3e
2D3C: FFFF           djnz    r15,%2c40
2D3E: FFFF           djnz    r15,%2c42
2D40: FFFF           djnz    r15,%2c44
2D42: FFFF           djnz    r15,%2c46
2D44: FFFF           djnz    r15,%2c48
2D46: FFFF           djnz    r15,%2c4a
2D48: FFFF           djnz    r15,%2c4c
2D4A: FFFF           djnz    r15,%2c4e
2D4C: FFFF           djnz    r15,%2c50
2D4E: FFFF           djnz    r15,%2c52
2D50: FFFF           djnz    r15,%2c54
2D52: FFFF           djnz    r15,%2c56
2D54: FFFF           djnz    r15,%2c58
2D56: FFFF           djnz    r15,%2c5a
2D58: FFFF           djnz    r15,%2c5c
2D5A: FFFF           djnz    r15,%2c5e
2D5C: FFFF           djnz    r15,%2c60
2D5E: FFFF           djnz    r15,%2c62
2D60: FFFF           djnz    r15,%2c64
2D62: FFFF           djnz    r15,%2c66
2D64: FFFF           djnz    r15,%2c68
2D66: FFFF           djnz    r15,%2c6a
2D68: FFFF           djnz    r15,%2c6c
2D6A: FFFF           djnz    r15,%2c6e
2D6C: FFFF           djnz    r15,%2c70
2D6E: FFFF           djnz    r15,%2c72
2D70: FFFF           djnz    r15,%2c74
2D72: FFFF           djnz    r15,%2c76
2D74: FFFF           djnz    r15,%2c78
2D76: FFFF           djnz    r15,%2c7a
2D78: FFFF           djnz    r15,%2c7c
2D7A: FFFF           djnz    r15,%2c7e
2D7C: FFFF           djnz    r15,%2c80
2D7E: FFFF           djnz    r15,%2c82
2D80: FFFF           djnz    r15,%2c84
2D82: FFFF           djnz    r15,%2c86
2D84: FFFF           djnz    r15,%2c88
2D86: FFFF           djnz    r15,%2c8a
2D88: FFFF           djnz    r15,%2c8c
2D8A: FFFF           djnz    r15,%2c8e
2D8C: FFFF           djnz    r15,%2c90
2D8E: FFFF           djnz    r15,%2c92
2D90: FFFF           djnz    r15,%2c94
2D92: FFFF           djnz    r15,%2c96
2D94: FFFF           djnz    r15,%2c98
2D96: FFFF           djnz    r15,%2c9a
2D98: FFFF           djnz    r15,%2c9c
2D9A: FFFF           djnz    r15,%2c9e
2D9C: FFFF           djnz    r15,%2ca0
2D9E: FFFF           djnz    r15,%2ca2
2DA0: FFFF           djnz    r15,%2ca4
2DA2: FFFF           djnz    r15,%2ca6
2DA4: FFFF           djnz    r15,%2ca8
2DA6: FFFF           djnz    r15,%2caa
2DA8: FFFF           djnz    r15,%2cac
2DAA: FFFF           djnz    r15,%2cae
2DAC: FFFF           djnz    r15,%2cb0
2DAE: FFFF           djnz    r15,%2cb2
2DB0: FFFF           djnz    r15,%2cb4
2DB2: FFFF           djnz    r15,%2cb6
2DB4: FFFF           djnz    r15,%2cb8
2DB6: FFFF           djnz    r15,%2cba
2DB8: FFFF           djnz    r15,%2cbc
2DBA: FFFF           djnz    r15,%2cbe
2DBC: FFFF           djnz    r15,%2cc0
2DBE: FFFF           djnz    r15,%2cc2
2DC0: FFFF           djnz    r15,%2cc4
2DC2: FFFF           djnz    r15,%2cc6
2DC4: FFFF           djnz    r15,%2cc8
2DC6: FFFF           djnz    r15,%2cca
2DC8: FFFF           djnz    r15,%2ccc
2DCA: FFFF           djnz    r15,%2cce
2DCC: FFFF           djnz    r15,%2cd0
2DCE: FFFF           djnz    r15,%2cd2
2DD0: FFFF           djnz    r15,%2cd4
2DD2: FFFF           djnz    r15,%2cd6
2DD4: FFFF           djnz    r15,%2cd8
2DD6: FFFF           djnz    r15,%2cda
2DD8: FFFF           djnz    r15,%2cdc
2DDA: FFFF           djnz    r15,%2cde
2DDC: FFFF           djnz    r15,%2ce0
2DDE: FFFF           djnz    r15,%2ce2
2DE0: FFFF           djnz    r15,%2ce4
2DE2: FFFF           djnz    r15,%2ce6
2DE4: FFFF           djnz    r15,%2ce8
2DE6: FFFF           djnz    r15,%2cea
2DE8: FFFF           djnz    r15,%2cec
2DEA: FFFF           djnz    r15,%2cee
2DEC: FFFF           djnz    r15,%2cf0
2DEE: FFFF           djnz    r15,%2cf2
2DF0: FFFF           djnz    r15,%2cf4
2DF2: FFFF           djnz    r15,%2cf6
2DF4: FFFF           djnz    r15,%2cf8
2DF6: FFFF           djnz    r15,%2cfa
2DF8: FFFF           djnz    r15,%2cfc
2DFA: FFFF           djnz    r15,%2cfe
2DFC: FFFF           djnz    r15,%2d00
2DFE: FFFF           djnz    r15,%2d02
2E00: FFFF           djnz    r15,%2d04
2E02: FFFF           djnz    r15,%2d06
2E04: FFFF           djnz    r15,%2d08
2E06: FFFF           djnz    r15,%2d0a
2E08: FFFF           djnz    r15,%2d0c
2E0A: FFFF           djnz    r15,%2d0e
2E0C: FFFF           djnz    r15,%2d10
2E0E: FFFF           djnz    r15,%2d12
2E10: FFFF           djnz    r15,%2d14
2E12: FFFF           djnz    r15,%2d16
2E14: FFFF           djnz    r15,%2d18
2E16: FFFF           djnz    r15,%2d1a
2E18: FFFF           djnz    r15,%2d1c
2E1A: FFFF           djnz    r15,%2d1e
2E1C: FFFF           djnz    r15,%2d20
2E1E: FFFF           djnz    r15,%2d22
2E20: FFFF           djnz    r15,%2d24
2E22: FFFF           djnz    r15,%2d26
2E24: FFFF           djnz    r15,%2d28
2E26: FFFF           djnz    r15,%2d2a
2E28: FFFF           djnz    r15,%2d2c
2E2A: FFFF           djnz    r15,%2d2e
2E2C: FFFF           djnz    r15,%2d30
2E2E: FFFF           djnz    r15,%2d32
2E30: FFFF           djnz    r15,%2d34
2E32: FFFF           djnz    r15,%2d36
2E34: FFFF           djnz    r15,%2d38
2E36: FFFF           djnz    r15,%2d3a
2E38: FFFF           djnz    r15,%2d3c
2E3A: FFFF           djnz    r15,%2d3e
2E3C: FFFF           djnz    r15,%2d40
2E3E: FFFF           djnz    r15,%2d42
2E40: FFFF           djnz    r15,%2d44
2E42: FFFF           djnz    r15,%2d46
2E44: FFFF           djnz    r15,%2d48
2E46: FFFF           djnz    r15,%2d4a
2E48: FFFF           djnz    r15,%2d4c
2E4A: FFFF           djnz    r15,%2d4e
2E4C: FFFF           djnz    r15,%2d50
2E4E: FFFF           djnz    r15,%2d52
2E50: FFFF           djnz    r15,%2d54
2E52: FFFF           djnz    r15,%2d56
2E54: FFFF           djnz    r15,%2d58
2E56: FFFF           djnz    r15,%2d5a
2E58: FFFF           djnz    r15,%2d5c
2E5A: FFFF           djnz    r15,%2d5e
2E5C: FFFF           djnz    r15,%2d60
2E5E: FFFF           djnz    r15,%2d62
2E60: FFFF           djnz    r15,%2d64
2E62: FFFF           djnz    r15,%2d66
2E64: FFFF           djnz    r15,%2d68
2E66: FFFF           djnz    r15,%2d6a
2E68: FFFF           djnz    r15,%2d6c
2E6A: FFFF           djnz    r15,%2d6e
2E6C: FFFF           djnz    r15,%2d70
2E6E: FFFF           djnz    r15,%2d72
2E70: FFFF           djnz    r15,%2d74
2E72: FFFF           djnz    r15,%2d76
2E74: FFFF           djnz    r15,%2d78
2E76: FFFF           djnz    r15,%2d7a
2E78: FFFF           djnz    r15,%2d7c
2E7A: FFFF           djnz    r15,%2d7e
2E7C: FFFF           djnz    r15,%2d80
2E7E: FFFF           djnz    r15,%2d82
2E80: FFFF           djnz    r15,%2d84
2E82: FFFF           djnz    r15,%2d86
2E84: FFFF           djnz    r15,%2d88
2E86: FFFF           djnz    r15,%2d8a
2E88: FFFF           djnz    r15,%2d8c
2E8A: FFFF           djnz    r15,%2d8e
2E8C: FFFF           djnz    r15,%2d90
2E8E: FFFF           djnz    r15,%2d92
2E90: FFFF           djnz    r15,%2d94
2E92: FFFF           djnz    r15,%2d96
2E94: FFFF           djnz    r15,%2d98
2E96: FFFF           djnz    r15,%2d9a
2E98: FFFF           djnz    r15,%2d9c
2E9A: FFFF           djnz    r15,%2d9e
2E9C: FFFF           djnz    r15,%2da0
2E9E: FFFF           djnz    r15,%2da2
2EA0: FFFF           djnz    r15,%2da4
2EA2: FFFF           djnz    r15,%2da6
2EA4: FFFF           djnz    r15,%2da8
2EA6: FFFF           djnz    r15,%2daa
2EA8: FFFF           djnz    r15,%2dac
2EAA: FFFF           djnz    r15,%2dae
2EAC: FFFF           djnz    r15,%2db0
2EAE: FFFF           djnz    r15,%2db2
2EB0: FFFF           djnz    r15,%2db4
2EB2: FFFF           djnz    r15,%2db6
2EB4: FFFF           djnz    r15,%2db8
2EB6: FFFF           djnz    r15,%2dba
2EB8: FFFF           djnz    r15,%2dbc
2EBA: FFFF           djnz    r15,%2dbe
2EBC: FFFF           djnz    r15,%2dc0
2EBE: FFFF           djnz    r15,%2dc2
2EC0: FFFF           djnz    r15,%2dc4
2EC2: FFFF           djnz    r15,%2dc6
2EC4: FFFF           djnz    r15,%2dc8
2EC6: FFFF           djnz    r15,%2dca
2EC8: FFFF           djnz    r15,%2dcc
2ECA: FFFF           djnz    r15,%2dce
2ECC: FFFF           djnz    r15,%2dd0
2ECE: FFFF           djnz    r15,%2dd2
2ED0: FFFF           djnz    r15,%2dd4
2ED2: FFFF           djnz    r15,%2dd6
2ED4: FFFF           djnz    r15,%2dd8
2ED6: FFFF           djnz    r15,%2dda
2ED8: FFFF           djnz    r15,%2ddc
2EDA: FFFF           djnz    r15,%2dde
2EDC: FFFF           djnz    r15,%2de0
2EDE: FFFF           djnz    r15,%2de2
2EE0: FFFF           djnz    r15,%2de4
2EE2: FFFF           djnz    r15,%2de6
2EE4: FFFF           djnz    r15,%2de8
2EE6: FFFF           djnz    r15,%2dea
2EE8: FFFF           djnz    r15,%2dec
2EEA: FFFF           djnz    r15,%2dee
2EEC: FFFF           djnz    r15,%2df0
2EEE: FFFF           djnz    r15,%2df2
2EF0: FFFF           djnz    r15,%2df4
2EF2: FFFF           djnz    r15,%2df6
2EF4: FFFF           djnz    r15,%2df8
2EF6: FFFF           djnz    r15,%2dfa
2EF8: FFFF           djnz    r15,%2dfc
2EFA: FFFF           djnz    r15,%2dfe
2EFC: FFFF           djnz    r15,%2e00
2EFE: FFFF           djnz    r15,%2e02
2F00: FFFF           djnz    r15,%2e04
2F02: FFFF           djnz    r15,%2e06
2F04: FFFF           djnz    r15,%2e08
2F06: FFFF           djnz    r15,%2e0a
2F08: FFFF           djnz    r15,%2e0c
2F0A: FFFF           djnz    r15,%2e0e
2F0C: FFFF           djnz    r15,%2e10
2F0E: FFFF           djnz    r15,%2e12
2F10: FFFF           djnz    r15,%2e14
2F12: FFFF           djnz    r15,%2e16
2F14: FFFF           djnz    r15,%2e18
2F16: FFFF           djnz    r15,%2e1a
2F18: FFFF           djnz    r15,%2e1c
2F1A: FFFF           djnz    r15,%2e1e
2F1C: FFFF           djnz    r15,%2e20
2F1E: FFFF           djnz    r15,%2e22
2F20: FFFF           djnz    r15,%2e24
2F22: FFFF           djnz    r15,%2e26
2F24: FFFF           djnz    r15,%2e28
2F26: FFFF           djnz    r15,%2e2a
2F28: FFFF           djnz    r15,%2e2c
2F2A: FFFF           djnz    r15,%2e2e
2F2C: FFFF           djnz    r15,%2e30
2F2E: FFFF           djnz    r15,%2e32
2F30: FFFF           djnz    r15,%2e34
2F32: FFFF           djnz    r15,%2e36
2F34: FFFF           djnz    r15,%2e38
2F36: FFFF           djnz    r15,%2e3a
2F38: FFFF           djnz    r15,%2e3c
2F3A: FFFF           djnz    r15,%2e3e
2F3C: FFFF           djnz    r15,%2e40
2F3E: FFFF           djnz    r15,%2e42
2F40: FFFF           djnz    r15,%2e44
2F42: FFFF           djnz    r15,%2e46
2F44: FFFF           djnz    r15,%2e48
2F46: FFFF           djnz    r15,%2e4a
2F48: FFFF           djnz    r15,%2e4c
2F4A: FFFF           djnz    r15,%2e4e
2F4C: FFFF           djnz    r15,%2e50
2F4E: FFFF           djnz    r15,%2e52
2F50: FFFF           djnz    r15,%2e54
2F52: FFFF           djnz    r15,%2e56
2F54: FFFF           djnz    r15,%2e58
2F56: FFFF           djnz    r15,%2e5a
2F58: FFFF           djnz    r15,%2e5c
2F5A: FFFF           djnz    r15,%2e5e
2F5C: FFFF           djnz    r15,%2e60
2F5E: FFFF           djnz    r15,%2e62
2F60: FFFF           djnz    r15,%2e64
2F62: FFFF           djnz    r15,%2e66
2F64: FFFF           djnz    r15,%2e68
2F66: FFFF           djnz    r15,%2e6a
2F68: FFFF           djnz    r15,%2e6c
2F6A: FFFF           djnz    r15,%2e6e
2F6C: FFFF           djnz    r15,%2e70
2F6E: FFFF           djnz    r15,%2e72
2F70: FFFF           djnz    r15,%2e74
2F72: FFFF           djnz    r15,%2e76
2F74: FFFF           djnz    r15,%2e78
2F76: FFFF           djnz    r15,%2e7a
2F78: FFFF           djnz    r15,%2e7c
2F7A: FFFF           djnz    r15,%2e7e
2F7C: FFFF           djnz    r15,%2e80
2F7E: FFFF           djnz    r15,%2e82
2F80: FFFF           djnz    r15,%2e84
2F82: FFFF           djnz    r15,%2e86
2F84: FFFF           djnz    r15,%2e88
2F86: FFFF           djnz    r15,%2e8a
2F88: FFFF           djnz    r15,%2e8c
2F8A: FFFF           djnz    r15,%2e8e
2F8C: FFFF           djnz    r15,%2e90
2F8E: FFFF           djnz    r15,%2e92
2F90: FFFF           djnz    r15,%2e94
2F92: FFFF           djnz    r15,%2e96
2F94: FFFF           djnz    r15,%2e98
2F96: FFFF           djnz    r15,%2e9a
2F98: FFFF           djnz    r15,%2e9c
2F9A: FFFF           djnz    r15,%2e9e
2F9C: FFFF           djnz    r15,%2ea0
2F9E: FFFF           djnz    r15,%2ea2
2FA0: FFFF           djnz    r15,%2ea4
2FA2: FFFF           djnz    r15,%2ea6
2FA4: FFFF           djnz    r15,%2ea8
2FA6: FFFF           djnz    r15,%2eaa
2FA8: FFFF           djnz    r15,%2eac
2FAA: FFFF           djnz    r15,%2eae
2FAC: FFFF           djnz    r15,%2eb0
2FAE: FFFF           djnz    r15,%2eb2
2FB0: FFFF           djnz    r15,%2eb4
2FB2: FFFF           djnz    r15,%2eb6
2FB4: FFFF           djnz    r15,%2eb8
2FB6: FFFF           djnz    r15,%2eba
2FB8: FFFF           djnz    r15,%2ebc
2FBA: FFFF           djnz    r15,%2ebe
2FBC: FFFF           djnz    r15,%2ec0
2FBE: FFFF           djnz    r15,%2ec2
2FC0: FFFF           djnz    r15,%2ec4
2FC2: FFFF           djnz    r15,%2ec6
2FC4: FFFF           djnz    r15,%2ec8
2FC6: FFFF           djnz    r15,%2eca
2FC8: FFFF           djnz    r15,%2ecc
2FCA: FFFF           djnz    r15,%2ece
2FCC: FFFF           djnz    r15,%2ed0
2FCE: FFFF           djnz    r15,%2ed2
2FD0: FFFF           djnz    r15,%2ed4
2FD2: FFFF           djnz    r15,%2ed6
2FD4: FFFF           djnz    r15,%2ed8
2FD6: FFFF           djnz    r15,%2eda
2FD8: FFFF           djnz    r15,%2edc
2FDA: FFFF           djnz    r15,%2ede
2FDC: FFFF           djnz    r15,%2ee0
2FDE: FFFF           djnz    r15,%2ee2
2FE0: FFFF           djnz    r15,%2ee4
2FE2: FFFF           djnz    r15,%2ee6
2FE4: FFFF           djnz    r15,%2ee8
2FE6: FFFF           djnz    r15,%2eea
2FE8: FFFF           djnz    r15,%2eec
2FEA: FFFF           djnz    r15,%2eee
2FEC: FFFF           djnz    r15,%2ef0
2FEE: FFFF           djnz    r15,%2ef2
2FF0: FFFF           djnz    r15,%2ef4
2FF2: FFFF           djnz    r15,%2ef6
2FF4: FFFF           djnz    r15,%2ef8
2FF6: FFFF           djnz    r15,%2efa
2FF8: FFFF           djnz    r15,%2efc
2FFA: FFFF           djnz    r15,%2efe
2FFC: FFFF           djnz    r15,%2f00
2FFE: FFFF           djnz    r15,%2f02
3000: FFFF           djnz    r15,%2f04
3002: FFFF           djnz    r15,%2f06
3004: FFFF           djnz    r15,%2f08
3006: FFFF           djnz    r15,%2f0a
3008: FFFF           djnz    r15,%2f0c
300A: FFFF           djnz    r15,%2f0e
300C: FFFF           djnz    r15,%2f10
300E: FFFF           djnz    r15,%2f12
3010: FFFF           djnz    r15,%2f14
3012: FFFF           djnz    r15,%2f16
3014: FFFF           djnz    r15,%2f18
3016: FFFF           djnz    r15,%2f1a
3018: FFFF           djnz    r15,%2f1c
301A: FFFF           djnz    r15,%2f1e
301C: FFFF           djnz    r15,%2f20
301E: FFFF           djnz    r15,%2f22
3020: FFFF           djnz    r15,%2f24
3022: FFFF           djnz    r15,%2f26
3024: FFFF           djnz    r15,%2f28
3026: FFFF           djnz    r15,%2f2a
3028: FFFF           djnz    r15,%2f2c
302A: FFFF           djnz    r15,%2f2e
302C: FFFF           djnz    r15,%2f30
302E: FFFF           djnz    r15,%2f32
3030: FFFF           djnz    r15,%2f34
3032: FFFF           djnz    r15,%2f36
3034: FFFF           djnz    r15,%2f38
3036: FFFF           djnz    r15,%2f3a
3038: FFFF           djnz    r15,%2f3c
303A: FFFF           djnz    r15,%2f3e
303C: FFFF           djnz    r15,%2f40
303E: FFFF           djnz    r15,%2f42
3040: FFFF           djnz    r15,%2f44
3042: FFFF           djnz    r15,%2f46
3044: FFFF           djnz    r15,%2f48
3046: FFFF           djnz    r15,%2f4a
3048: FFFF           djnz    r15,%2f4c
304A: FFFF           djnz    r15,%2f4e
304C: FFFF           djnz    r15,%2f50
304E: FFFF           djnz    r15,%2f52
3050: FFFF           djnz    r15,%2f54
3052: FFFF           djnz    r15,%2f56
3054: FFFF           djnz    r15,%2f58
3056: FFFF           djnz    r15,%2f5a
3058: FFFF           djnz    r15,%2f5c
305A: FFFF           djnz    r15,%2f5e
305C: FFFF           djnz    r15,%2f60
305E: FFFF           djnz    r15,%2f62
3060: FFFF           djnz    r15,%2f64
3062: FFFF           djnz    r15,%2f66
3064: FFFF           djnz    r15,%2f68
3066: FFFF           djnz    r15,%2f6a
3068: FFFF           djnz    r15,%2f6c
306A: FFFF           djnz    r15,%2f6e
306C: FFFF           djnz    r15,%2f70
306E: FFFF           djnz    r15,%2f72
3070: FFFF           djnz    r15,%2f74
3072: FFFF           djnz    r15,%2f76
3074: FFFF           djnz    r15,%2f78
3076: FFFF           djnz    r15,%2f7a
3078: FFFF           djnz    r15,%2f7c
307A: FFFF           djnz    r15,%2f7e
307C: FFFF           djnz    r15,%2f80
307E: FFFF           djnz    r15,%2f82
3080: FFFF           djnz    r15,%2f84
3082: FFFF           djnz    r15,%2f86
3084: FFFF           djnz    r15,%2f88
3086: FFFF           djnz    r15,%2f8a
3088: FFFF           djnz    r15,%2f8c
308A: FFFF           djnz    r15,%2f8e
308C: FFFF           djnz    r15,%2f90
308E: FFFF           djnz    r15,%2f92
3090: FFFF           djnz    r15,%2f94
3092: FFFF           djnz    r15,%2f96
3094: FFFF           djnz    r15,%2f98
3096: FFFF           djnz    r15,%2f9a
3098: FFFF           djnz    r15,%2f9c
309A: FFFF           djnz    r15,%2f9e
309C: FFFF           djnz    r15,%2fa0
309E: FFFF           djnz    r15,%2fa2
30A0: FFFF           djnz    r15,%2fa4
30A2: FFFF           djnz    r15,%2fa6
30A4: FFFF           djnz    r15,%2fa8
30A6: FFFF           djnz    r15,%2faa
30A8: FFFF           djnz    r15,%2fac
30AA: FFFF           djnz    r15,%2fae
30AC: FFFF           djnz    r15,%2fb0
30AE: FFFF           djnz    r15,%2fb2
30B0: FFFF           djnz    r15,%2fb4
30B2: FFFF           djnz    r15,%2fb6
30B4: FFFF           djnz    r15,%2fb8
30B6: FFFF           djnz    r15,%2fba
30B8: FFFF           djnz    r15,%2fbc
30BA: FFFF           djnz    r15,%2fbe
30BC: FFFF           djnz    r15,%2fc0
30BE: FFFF           djnz    r15,%2fc2
30C0: FFFF           djnz    r15,%2fc4
30C2: FFFF           djnz    r15,%2fc6
30C4: FFFF           djnz    r15,%2fc8
30C6: FFFF           djnz    r15,%2fca
30C8: FFFF           djnz    r15,%2fcc
30CA: FFFF           djnz    r15,%2fce
30CC: FFFF           djnz    r15,%2fd0
30CE: FFFF           djnz    r15,%2fd2
30D0: FFFF           djnz    r15,%2fd4
30D2: FFFF           djnz    r15,%2fd6
30D4: FFFF           djnz    r15,%2fd8
30D6: FFFF           djnz    r15,%2fda
30D8: FFFF           djnz    r15,%2fdc
30DA: FFFF           djnz    r15,%2fde
30DC: FFFF           djnz    r15,%2fe0
30DE: FFFF           djnz    r15,%2fe2
30E0: FFFF           djnz    r15,%2fe4
30E2: FFFF           djnz    r15,%2fe6
30E4: FFFF           djnz    r15,%2fe8
30E6: FFFF           djnz    r15,%2fea
30E8: FFFF           djnz    r15,%2fec
30EA: FFFF           djnz    r15,%2fee
30EC: FFFF           djnz    r15,%2ff0
30EE: FFFF           djnz    r15,%2ff2
30F0: FFFF           djnz    r15,%2ff4
30F2: FFFF           djnz    r15,%2ff6
30F4: FFFF           djnz    r15,%2ff8
30F6: FFFF           djnz    r15,%2ffa
30F8: FFFF           djnz    r15,%2ffc
30FA: FFFF           djnz    r15,%2ffe
30FC: FFFF           djnz    r15,%3000
30FE: FFFF           djnz    r15,%3002
3100: FFFF           djnz    r15,%3004
3102: FFFF           djnz    r15,%3006
3104: FFFF           djnz    r15,%3008
3106: FFFF           djnz    r15,%300a
3108: FFFF           djnz    r15,%300c
310A: FFFF           djnz    r15,%300e
310C: FFFF           djnz    r15,%3010
310E: FFFF           djnz    r15,%3012
3110: FFFF           djnz    r15,%3014
3112: FFFF           djnz    r15,%3016
3114: FFFF           djnz    r15,%3018
3116: FFFF           djnz    r15,%301a
3118: FFFF           djnz    r15,%301c
311A: FFFF           djnz    r15,%301e
311C: FFFF           djnz    r15,%3020
311E: FFFF           djnz    r15,%3022
3120: FFFF           djnz    r15,%3024
3122: FFFF           djnz    r15,%3026
3124: FFFF           djnz    r15,%3028
3126: FFFF           djnz    r15,%302a
3128: FFFF           djnz    r15,%302c
312A: FFFF           djnz    r15,%302e
312C: FFFF           djnz    r15,%3030
312E: FFFF           djnz    r15,%3032
3130: FFFF           djnz    r15,%3034
3132: FFFF           djnz    r15,%3036
3134: FFFF           djnz    r15,%3038
3136: FFFF           djnz    r15,%303a
3138: FFFF           djnz    r15,%303c
313A: FFFF           djnz    r15,%303e
313C: FFFF           djnz    r15,%3040
313E: FFFF           djnz    r15,%3042
3140: FFFF           djnz    r15,%3044
3142: FFFF           djnz    r15,%3046
3144: FFFF           djnz    r15,%3048
3146: FFFF           djnz    r15,%304a
3148: FFFF           djnz    r15,%304c
314A: FFFF           djnz    r15,%304e
314C: FFFF           djnz    r15,%3050
314E: FFFF           djnz    r15,%3052
3150: FFFF           djnz    r15,%3054
3152: FFFF           djnz    r15,%3056
3154: FFFF           djnz    r15,%3058
3156: FFFF           djnz    r15,%305a
3158: FFFF           djnz    r15,%305c
315A: FFFF           djnz    r15,%305e
315C: FFFF           djnz    r15,%3060
315E: FFFF           djnz    r15,%3062
3160: FFFF           djnz    r15,%3064
3162: FFFF           djnz    r15,%3066
3164: FFFF           djnz    r15,%3068
3166: FFFF           djnz    r15,%306a
3168: FFFF           djnz    r15,%306c
316A: FFFF           djnz    r15,%306e
316C: FFFF           djnz    r15,%3070
316E: FFFF           djnz    r15,%3072
3170: FFFF           djnz    r15,%3074
3172: FFFF           djnz    r15,%3076
3174: FFFF           djnz    r15,%3078
3176: FFFF           djnz    r15,%307a
3178: FFFF           djnz    r15,%307c
317A: FFFF           djnz    r15,%307e
317C: FFFF           djnz    r15,%3080
317E: FFFF           djnz    r15,%3082
3180: FFFF           djnz    r15,%3084
3182: FFFF           djnz    r15,%3086
3184: FFFF           djnz    r15,%3088
3186: FFFF           djnz    r15,%308a
3188: FFFF           djnz    r15,%308c
318A: FFFF           djnz    r15,%308e
318C: FFFF           djnz    r15,%3090
318E: FFFF           djnz    r15,%3092
3190: FFFF           djnz    r15,%3094
3192: FFFF           djnz    r15,%3096
3194: FFFF           djnz    r15,%3098
3196: FFFF           djnz    r15,%309a
3198: FFFF           djnz    r15,%309c
319A: FFFF           djnz    r15,%309e
319C: FFFF           djnz    r15,%30a0
319E: FFFF           djnz    r15,%30a2
31A0: FFFF           djnz    r15,%30a4
31A2: FFFF           djnz    r15,%30a6
31A4: FFFF           djnz    r15,%30a8
31A6: FFFF           djnz    r15,%30aa
31A8: FFFF           djnz    r15,%30ac
31AA: FFFF           djnz    r15,%30ae
31AC: FFFF           djnz    r15,%30b0
31AE: FFFF           djnz    r15,%30b2
31B0: FFFF           djnz    r15,%30b4
31B2: FFFF           djnz    r15,%30b6
31B4: FFFF           djnz    r15,%30b8
31B6: FFFF           djnz    r15,%30ba
31B8: FFFF           djnz    r15,%30bc
31BA: FFFF           djnz    r15,%30be
31BC: FFFF           djnz    r15,%30c0
31BE: FFFF           djnz    r15,%30c2
31C0: FFFF           djnz    r15,%30c4
31C2: FFFF           djnz    r15,%30c6
31C4: FFFF           djnz    r15,%30c8
31C6: FFFF           djnz    r15,%30ca
31C8: FFFF           djnz    r15,%30cc
31CA: FFFF           djnz    r15,%30ce
31CC: FFFF           djnz    r15,%30d0
31CE: FFFF           djnz    r15,%30d2
31D0: FFFF           djnz    r15,%30d4
31D2: FFFF           djnz    r15,%30d6
31D4: FFFF           djnz    r15,%30d8
31D6: FFFF           djnz    r15,%30da
31D8: FFFF           djnz    r15,%30dc
31DA: FFFF           djnz    r15,%30de
31DC: FFFF           djnz    r15,%30e0
31DE: FFFF           djnz    r15,%30e2
31E0: FFFF           djnz    r15,%30e4
31E2: FFFF           djnz    r15,%30e6
31E4: FFFF           djnz    r15,%30e8
31E6: FFFF           djnz    r15,%30ea
31E8: FFFF           djnz    r15,%30ec
31EA: FFFF           djnz    r15,%30ee
31EC: FFFF           djnz    r15,%30f0
31EE: FFFF           djnz    r15,%30f2
31F0: FFFF           djnz    r15,%30f4
31F2: FFFF           djnz    r15,%30f6
31F4: FFFF           djnz    r15,%30f8
31F6: FFFF           djnz    r15,%30fa
31F8: FFFF           djnz    r15,%30fc
31FA: FFFF           djnz    r15,%30fe
31FC: FFFF           djnz    r15,%3100
31FE: FFFF           djnz    r15,%3102
3200: FFFF           djnz    r15,%3104
3202: FFFF           djnz    r15,%3106
3204: FFFF           djnz    r15,%3108
3206: FFFF           djnz    r15,%310a
3208: FFFF           djnz    r15,%310c
320A: FFFF           djnz    r15,%310e
320C: FFFF           djnz    r15,%3110
320E: FFFF           djnz    r15,%3112
3210: FFFF           djnz    r15,%3114
3212: FFFF           djnz    r15,%3116
3214: FFFF           djnz    r15,%3118
3216: FFFF           djnz    r15,%311a
3218: FFFF           djnz    r15,%311c
321A: FFFF           djnz    r15,%311e
321C: FFFF           djnz    r15,%3120
321E: FFFF           djnz    r15,%3122
3220: FFFF           djnz    r15,%3124
3222: FFFF           djnz    r15,%3126
3224: FFFF           djnz    r15,%3128
3226: FFFF           djnz    r15,%312a
3228: FFFF           djnz    r15,%312c
322A: FFFF           djnz    r15,%312e
322C: FFFF           djnz    r15,%3130
322E: FFFF           djnz    r15,%3132
3230: FFFF           djnz    r15,%3134
3232: FFFF           djnz    r15,%3136
3234: FFFF           djnz    r15,%3138
3236: FFFF           djnz    r15,%313a
3238: FFFF           djnz    r15,%313c
323A: FFFF           djnz    r15,%313e
323C: FFFF           djnz    r15,%3140
323E: FFFF           djnz    r15,%3142
3240: FFFF           djnz    r15,%3144
3242: FFFF           djnz    r15,%3146
3244: FFFF           djnz    r15,%3148
3246: FFFF           djnz    r15,%314a
3248: FFFF           djnz    r15,%314c
324A: FFFF           djnz    r15,%314e
324C: FFFF           djnz    r15,%3150
324E: FFFF           djnz    r15,%3152
3250: FFFF           djnz    r15,%3154
3252: FFFF           djnz    r15,%3156
3254: FFFF           djnz    r15,%3158
3256: FFFF           djnz    r15,%315a
3258: FFFF           djnz    r15,%315c
325A: FFFF           djnz    r15,%315e
325C: FFFF           djnz    r15,%3160
325E: FFFF           djnz    r15,%3162
3260: FFFF           djnz    r15,%3164
3262: FFFF           djnz    r15,%3166
3264: FFFF           djnz    r15,%3168
3266: FFFF           djnz    r15,%316a
3268: FFFF           djnz    r15,%316c
326A: FFFF           djnz    r15,%316e
326C: FFFF           djnz    r15,%3170
326E: FFFF           djnz    r15,%3172
3270: FFFF           djnz    r15,%3174
3272: FFFF           djnz    r15,%3176
3274: FFFF           djnz    r15,%3178
3276: FFFF           djnz    r15,%317a
3278: FFFF           djnz    r15,%317c
327A: FFFF           djnz    r15,%317e
327C: FFFF           djnz    r15,%3180
327E: FFFF           djnz    r15,%3182
3280: FFFF           djnz    r15,%3184
3282: FFFF           djnz    r15,%3186
3284: FFFF           djnz    r15,%3188
3286: FFFF           djnz    r15,%318a
3288: FFFF           djnz    r15,%318c
328A: FFFF           djnz    r15,%318e
328C: FFFF           djnz    r15,%3190
328E: FFFF           djnz    r15,%3192
3290: FFFF           djnz    r15,%3194
3292: FFFF           djnz    r15,%3196
3294: FFFF           djnz    r15,%3198
3296: FFFF           djnz    r15,%319a
3298: FFFF           djnz    r15,%319c
329A: FFFF           djnz    r15,%319e
329C: FFFF           djnz    r15,%31a0
329E: FFFF           djnz    r15,%31a2
32A0: FFFF           djnz    r15,%31a4
32A2: FFFF           djnz    r15,%31a6
32A4: FFFF           djnz    r15,%31a8
32A6: FFFF           djnz    r15,%31aa
32A8: FFFF           djnz    r15,%31ac
32AA: FFFF           djnz    r15,%31ae
32AC: FFFF           djnz    r15,%31b0
32AE: FFFF           djnz    r15,%31b2
32B0: FFFF           djnz    r15,%31b4
32B2: FFFF           djnz    r15,%31b6
32B4: FFFF           djnz    r15,%31b8
32B6: FFFF           djnz    r15,%31ba
32B8: FFFF           djnz    r15,%31bc
32BA: FFFF           djnz    r15,%31be
32BC: FFFF           djnz    r15,%31c0
32BE: FFFF           djnz    r15,%31c2
32C0: FFFF           djnz    r15,%31c4
32C2: FFFF           djnz    r15,%31c6
32C4: FFFF           djnz    r15,%31c8
32C6: FFFF           djnz    r15,%31ca
32C8: FFFF           djnz    r15,%31cc
32CA: FFFF           djnz    r15,%31ce
32CC: FFFF           djnz    r15,%31d0
32CE: FFFF           djnz    r15,%31d2
32D0: FFFF           djnz    r15,%31d4
32D2: FFFF           djnz    r15,%31d6
32D4: FFFF           djnz    r15,%31d8
32D6: FFFF           djnz    r15,%31da
32D8: FFFF           djnz    r15,%31dc
32DA: FFFF           djnz    r15,%31de
32DC: FFFF           djnz    r15,%31e0
32DE: FFFF           djnz    r15,%31e2
32E0: FFFF           djnz    r15,%31e4
32E2: FFFF           djnz    r15,%31e6
32E4: FFFF           djnz    r15,%31e8
32E6: FFFF           djnz    r15,%31ea
32E8: FFFF           djnz    r15,%31ec
32EA: FFFF           djnz    r15,%31ee
32EC: FFFF           djnz    r15,%31f0
32EE: FFFF           djnz    r15,%31f2
32F0: FFFF           djnz    r15,%31f4
32F2: FFFF           djnz    r15,%31f6
32F4: FFFF           djnz    r15,%31f8
32F6: FFFF           djnz    r15,%31fa
32F8: FFFF           djnz    r15,%31fc
32FA: FFFF           djnz    r15,%31fe
32FC: FFFF           djnz    r15,%3200
32FE: FFFF           djnz    r15,%3202
3300: 2109 0002      ld      r9,#%0002
3304: 210A 0000      ld      r10,#%0000
3308: 8D08           clr     r0
330A: 210C 2000      ld      r12,#%2000
330E: 00A0           addb    rh0,@r10
3310: A9A0           inc     r10,1
3312: 00A8           addb    rl0,@r10
3314: A9A0           inc     r10,1
3316: FC85           djnz    r12,%330e
3318: A880           incb    rl0,1
331A: EE04           jr      ne/nz,%3324
331C: A990           inc     r9,1
331E: A800           incb    rh0,1
3320: EE01           jr      ne/nz,%3324
3322: E81A           jr      %3358
3324: 210A 0400      ld      r10,#%0400
3328: 210B 9800      ld      r11,#%9800
332C: 0DB5 0A24      ld      @r11,#%0a24
3330: A9B1           inc     r11,2
3332: FA84           djnz    r10,%332c
3334: 6F09 8092      ld      %8092,r9
3338: 4D08 8090      clr     %8090
333C: E8FF           jr      %333c
333E: A101           ld      r1,r0
3340: 0701 000F      and     r1,#%000f
3344: EEEF           jr      ne/nz,%3324
3346: B301 FFFC      srl     r0,#4
334A: A990           inc     r9,1
334C: E8F8           jr      %333e
334E: 0700 00FF      and     r0,#%00ff
3352: EEE8           jr      ne/nz,%3324
3354: A990           inc     r9,1
3356: E8E6           jr      %3324
3358: 210E 0004      ld      r14,#%0004
335C: 2109 0094      ld      r9,#%0094
3360: 210B 8100      ld      r11,#%8100
3364: A1BA           ld      r10,r11
3366: A1E1           ld      r1,r14
3368: A1E2           ld      r2,r14
336A: 210C 0300      ld      r12,#%0300
336E: A110           ld      r0,r1
3370: B311 0002      sll     r1,#2
3374: 8101           add     r1,r0
3376: A910           inc     r1,1
3378: 0121           add     r1,@r2
337A: A921           inc     r2,2
337C: A110           ld      r0,r1
337E: 2FA0           ld      @r10,r0
3380: 09A0           xor     r0,@r10
3382: EEDD           jr      ne/nz,%333e
3384: A9A1           inc     r10,2
3386: FC8D           djnz    r12,%336e
3388: A1E1           ld      r1,r14
338A: A1E2           ld      r2,r14
338C: 210C 0300      ld      r12,#%0300
3390: A110           ld      r0,r1
3392: B311 0002      sll     r1,#2
3396: 8101           add     r1,r0
3398: A910           inc     r1,1
339A: 0121           add     r1,@r2
339C: A921           inc     r2,2
339E: A110           ld      r0,r1
33A0: 09B0           xor     r0,@r11
33A2: EECD           jr      ne/nz,%333e
33A4: A9B1           inc     r11,2
33A6: FC8C           djnz    r12,%3390
33A8: A993           inc     r9,4
33AA: A1BA           ld      r10,r11
33AC: A1E1           ld      r1,r14
33AE: A1E2           ld      r2,r14
33B0: 210C 0400      ld      r12,#%0400
33B4: A110           ld      r0,r1
33B6: B311 0002      sll     r1,#2
33BA: 8101           add     r1,r0
33BC: A910           inc     r1,1
33BE: 0121           add     r1,@r2
33C0: A921           inc     r2,2
33C2: A110           ld      r0,r1
33C4: 2FA0           ld      @r10,r0
33C6: 09A0           xor     r0,@r10
33C8: EEBA           jr      ne/nz,%333e
33CA: A9A1           inc     r10,2
33CC: FC8D           djnz    r12,%33b4
33CE: A1E1           ld      r1,r14
33D0: A1E2           ld      r2,r14
33D2: 210C 0400      ld      r12,#%0400
33D6: A110           ld      r0,r1
33D8: B311 0002      sll     r1,#2
33DC: 8101           add     r1,r0
33DE: A910           inc     r1,1
33E0: 0121           add     r1,@r2
33E2: A921           inc     r2,2
33E4: A110           ld      r0,r1
33E6: 09B0           xor     r0,@r11
33E8: EEAA           jr      ne/nz,%333e
33EA: A9B1           inc     r11,2
33EC: FC8C           djnz    r12,%33d6
33EE: A993           inc     r9,4
33F0: A1BA           ld      r10,r11
33F2: A1E1           ld      r1,r14
33F4: A1E2           ld      r2,r14
33F6: 210C 0800      ld      r12,#%0800
33FA: A110           ld      r0,r1
33FC: B311 0002      sll     r1,#2
3400: 8101           add     r1,r0
3402: A910           inc     r1,1
3404: 0121           add     r1,@r2
3406: A921           inc     r2,2
3408: A110           ld      r0,r1
340A: 2FA0           ld      @r10,r0
340C: 09A0           xor     r0,@r10
340E: EE9F           jr      ne/nz,%334e
3410: A9A1           inc     r10,2
3412: FC8D           djnz    r12,%33fa
3414: A1E1           ld      r1,r14
3416: A1E2           ld      r2,r14
3418: 210C 0800      ld      r12,#%0800
341C: A110           ld      r0,r1
341E: B311 0002      sll     r1,#2
3422: 8101           add     r1,r0
3424: A910           inc     r1,1
3426: 0121           add     r1,@r2
3428: A921           inc     r2,2
342A: A110           ld      r0,r1
342C: 09B0           xor     r0,@r11
342E: EE8F           jr      ne/nz,%334e
3430: A9B1           inc     r11,2
3432: FC8C           djnz    r12,%341c
3434: A991           inc     r9,2
3436: A1BA           ld      r10,r11
3438: A1E1           ld      r1,r14
343A: A1E2           ld      r2,r14
343C: 210C 07F0      ld      r12,#%07f0
3440: A110           ld      r0,r1
3442: B311 0002      sll     r1,#2
3446: 8101           add     r1,r0
3448: A910           inc     r1,1
344A: 0121           add     r1,@r2
344C: A921           inc     r2,2
344E: A110           ld      r0,r1
3450: 2FA0           ld      @r10,r0
3452: 09A0           xor     r0,@r10
3454: 5E0E 334E      jp      ne/nz,%334e
3458: A9A1           inc     r10,2
345A: FC8E           djnz    r12,%3440
345C: A1E1           ld      r1,r14
345E: A1E2           ld      r2,r14
3460: 210C 07F0      ld      r12,#%07f0
3464: A110           ld      r0,r1
3466: B311 0002      sll     r1,#2
346A: 8101           add     r1,r0
346C: A910           inc     r1,1
346E: 0121           add     r1,@r2
3470: A921           inc     r2,2
3472: A110           ld      r0,r1
3474: 09B0           xor     r0,@r11
3476: 5E0E 334E      jp      ne/nz,%334e
347A: A9B1           inc     r11,2
347C: FC8D           djnz    r12,%3464
347E: ABE0           dec     r14,1
3480: 5E0E 335C      jp      ne/nz,%335c
3484: 4D05 8144 0001 ld      %8144,#%0001
348A: 4D05 8146 0001 ld      %8146,#%0001
3490: 4D05 8148 0000 ld      %8148,#%0000
3496: 4D05 814A 0000 ld      %814a,#%0000
349C: 4D05 814C 0000 ld      %814c,#%0000
34A2: 4D05 8000 0000 ld      %8000,#%0000
34A8: 210A 0400      ld      r10,#%0400
34AC: 210B 9800      ld      r11,#%9800
34B0: 0DB5 0A24      ld      @r11,#%0a24
34B4: A9B1           inc     r11,2
34B6: FA84           djnz    r10,%34b0
34B8: 4D08 8092      clr     %8092
34BC: 4D08 8090      clr     %8090
34C0: 4D04 8090      test    %8090
34C4: E6FD           jr      eq/z,%34c0
34C6: 4D04 8090      test    %8090
34CA: EEFD           jr      ne/nz,%34c6
34CC: 6100 8094      ld      r0,%8094
34D0: 0700 00FF      and     r0,#%00ff
34D4: 0B00 0001      cp      r0,#%0001
34D8: EEF9           jr      ne/nz,%34cc
34DA: 5E08 0006      jp      %0006
34DE: 91F2           pushl   @r15,rr2
34E0: 91F4           pushl   @r15,rr4
34E2: 1404 0000 0000 ldl     rr4,#%00000000
34E8: A113           ld      r3,r1
34EA: 0703 000F      and     r3,#%000f
34EE: 8D28           clr     r2
34F0: 9624           addl    rr4,rr2
34F2: B305 FFFC      srll    rr0,#4
34F6: A113           ld      r3,r1
34F8: 0703 000F      and     r3,#%000f
34FC: 1902 000A      mult    rr2,#%000a
3500: 9624           addl    rr4,rr2
3502: B305 FFFC      srll    rr0,#4
3506: A113           ld      r3,r1
3508: 0703 000F      and     r3,#%000f
350C: 1902 0064      mult    rr2,#%0064
3510: 9624           addl    rr4,rr2
3512: B305 FFFC      srll    rr0,#4
3516: A113           ld      r3,r1
3518: 0703 000F      and     r3,#%000f
351C: 1902 03E8      mult    rr2,#%03e8
3520: 9624           addl    rr4,rr2
3522: B305 FFFC      srll    rr0,#4
3526: A113           ld      r3,r1
3528: 0703 000F      and     r3,#%000f
352C: 1902 2710      mult    rr2,#%2710
3530: 9624           addl    rr4,rr2
3532: 9440           ldl     rr0,rr4
3534: 95F4           popl    rr4,@r15
3536: 95F2           popl    rr2,@r15
3538: 9E08           ret     
353A: 91F2           pushl   @r15,rr2
353C: 1402 0000 0000 ldl     rr2,#%00000000
3542: 8D08           clr     r0
3544: 1B00 2710      div     rr0,#%2710
3548: 8513           or      r3,r1
354A: B325 0004      slll    rr2,#4
354E: A101           ld      r1,r0
3550: 8D08           clr     r0
3552: 1B00 03E8      div     rr0,#%03e8
3556: 8513           or      r3,r1
3558: B325 0004      slll    rr2,#4
355C: A101           ld      r1,r0
355E: 8D08           clr     r0
3560: 1B00 0064      div     rr0,#%0064
3564: 8513           or      r3,r1
3566: B325 0004      slll    rr2,#4
356A: A101           ld      r1,r0
356C: 8D08           clr     r0
356E: 1B00 000A      div     rr0,#%000a
3572: 8513           or      r3,r1
3574: B325 0004      slll    rr2,#4
3578: 8503           or      r3,r0
357A: 9420           ldl     rr0,rr2
357C: 95F2           popl    rr2,@r15
357E: 9E08           ret     
3580: 2DFD           ex      r13,@r15
3582: 93F0           push    @r15,r0
3584: 93F1           push    @r15,r1
3586: A001           ldb     rh1,rh0
3588: E805           jr      %3594
358A: 2DFD           ex      r13,@r15
358C: 93F0           push    @r15,r0
358E: 93F1           push    @r15,r1
3590: 20D1           ldb     rh1,@r13
3592: A9D0           inc     r13,1
3594: A617           bitb    rh1,7
3596: EE13           jr      ne/nz,%35be
3598: 20D9           ldb     rl1,@r13
359A: A9D0           inc     r13,1
359C: 0A09 4040      cpb     rl1,#%40
35A0: E614           jr      eq/z,%35ca
35A2: A018           ldb     rl0,rh1
35A4: 8C18           clrb    rh1
35A6: 0A09 2020      cpb     rl1,#%20
35AA: E901           jr      ge,%35ae
35AC: C920           ldb     rl1,#%20
35AE: 0209 2020      subb    rl1,#%20
35B2: 6019 3C28      ldb     rl1,%3c28(r1)
35B6: A081           ldb     rh1,rl0
35B8: 2FC1           ld      @r12,r1
35BA: A9C1           inc     r12,2
35BC: E8ED           jr      %3598
35BE: 20D8           ldb     rl0,@r13
35C0: 8C08           clrb    rh0
35C2: C924           ldb     rl1,#%24
35C4: 2FC1           ld      @r12,r1
35C6: A9C1           inc     r12,2
35C8: F083           djnz    r0,%35c4
35CA: A9D0           inc     r13,1
35CC: 070D FFFE      and     r13,#%fffe
35D0: 97F1           pop     r1,@r15
35D2: 97F0           pop     r0,@r15
35D4: 2DFD           ex      r13,@r15
35D6: 9E08           ret     
35D8: FFFF           djnz    r15,%34dc
35DA: FFFF           djnz    r15,%34de
35DC: FFFF           djnz    r15,%34e0
35DE: FFFF           djnz    r15,%34e2
35E0: FFFF           djnz    r15,%34e4
35E2: FFFF           djnz    r15,%34e6
35E4: FFFF           djnz    r15,%34e8
35E6: FFFF           djnz    r15,%34ea
35E8: FFFF           djnz    r15,%34ec
35EA: FFFF           djnz    r15,%34ee
35EC: FFFF           djnz    r15,%34f0
35EE: FFFF           djnz    r15,%34f2
35F0: FFFF           djnz    r15,%34f4
35F2: FFFF           djnz    r15,%34f6
35F4: FFFF           djnz    r15,%34f8
35F6: FFFF           djnz    r15,%34fa
35F8: FFFF           djnz    r15,%34fc
35FA: FFFF           djnz    r15,%34fe
35FC: FFFF           djnz    r15,%3500
35FE: FFFF           djnz    r15,%3502
3600: 0CAF           .word   #%0caf
3602: 0A7A           cpb     rl2,@r7
3604: 08E6           xorb    rh6,@r14
3606: 07B7           and     r7,@r11
3608: 06CB           andb    rl3,@r12
360A: 060F 0574      andb    rl7,#%74
360E: 04F4           orb     rh4,@r15
3610: 0487           orb     rh7,@r8
3612: 042A           orb     rl2,@r2
3614: 03D9           sub     r9,@r13
3616: 0392           sub     r2,@r9
3618: 0354           sub     r4,@r5
361A: 031C           sub     r12,@r1
361C: 02EB           subb    rl3,@r14
361E: 02BE           subb    rl6,@r11
3620: 0295           subb    rh5,@r9
3622: 0271           subb    rh1,@r7
3624: 024F           subb    rl7,@r4
3626: 0230           subb    rh0,@r3
3628: 0214           subb    rh4,@r1
362A: 01FA           add     r10,@r15
362C: 01E2           add     r2,@r14
362E: 01CB           add     r11,@r12
3630: 01B7           add     r7,@r11
3632: 01A3           add     r3,@r10
3634: 0191           add     r1,@r9
3636: 0180           add     r0,@r8
3638: 0170           add     r0,@r7
363A: 0160           add     r0,@r6
363C: 0152           add     r2,@r5
363E: 0145           add     r5,@r4
3640: 0138           add     r8,@r3
3642: 012C           add     r12,@r2
3644: 0120           add     r0,@r2
3646: 0116           add     r6,@r1
3648: 010B 0101      add     r11,#%0101
364C: 00F8           addb    rl0,@r15
364E: 00EF           addb    rl7,@r14
3650: 00E6           addb    rh6,@r14
3652: 00DE           addb    rl6,@r13
3654: 00D6           addb    rh6,@r13
3656: 00CF           addb    rl7,@r12
3658: 00C8           addb    rl0,@r12
365A: 00C1           addb    rh1,@r12
365C: 00BA           addb    rl2,@r11
365E: 00B4           addb    rh4,@r11
3660: 00AD           addb    rl5,@r10
3662: 00A8           addb    rl0,@r10
3664: 00A2           addb    rh2,@r10
3666: 009C           addb    rl4,@r9
3668: 0097           addb    rh7,@r9
366A: 0092           addb    rh2,@r9
366C: 008D           addb    rl5,@r8
366E: 0088           addb    rl0,@r8
3670: 0083           addb    rh3,@r8
3672: 007F           addb    rl7,@r7
3674: 007B           addb    rl3,@r7
3676: 0076           addb    rh6,@r7
3678: 0072           addb    rh2,@r7
367A: 006E           addb    rl6,@r6
367C: 006B           addb    rl3,@r6
367E: 0067           addb    rh7,@r6
3680: 0063           addb    rh3,@r6
3682: 0060           addb    rh0,@r6
3684: 005C           addb    rl4,@r5
3686: 0059           addb    rl1,@r5
3688: 0056           addb    rh6,@r5
368A: 0053           addb    rh3,@r5
368C: 0050           addb    rh0,@r5
368E: 004D           addb    rl5,@r4
3690: 004A           addb    rl2,@r4
3692: 0047           addb    rh7,@r4
3694: 0044           addb    rh4,@r4
3696: 0041           addb    rh1,@r4
3698: 003F           addb    rl7,@r3
369A: 003C           addb    rl4,@r3
369C: 003A           addb    rl2,@r3
369E: 0037           addb    rh7,@r3
36A0: 0035           addb    rh5,@r3
36A2: 0033           addb    rh3,@r3
36A4: 0030           addb    rh0,@r3
36A6: 002E           addb    rl6,@r2
36A8: 002C           addb    rl4,@r2
36AA: 002A           addb    rl2,@r2
36AC: 0028           addb    rl0,@r2
36AE: 0026           addb    rh6,@r2
36B0: 0024           addb    rh4,@r2
36B2: 0022           addb    rh2,@r2
36B4: 0020           addb    rh0,@r2
36B6: 001E           addb    rl6,@r1
36B8: 001C           addb    rl4,@r1
36BA: 001A           addb    rl2,@r1
36BC: 0019           addb    rl1,@r1
36BE: 0017           addb    rh7,@r1
36C0: 0015           addb    rh5,@r1
36C2: 0014           addb    rh4,@r1
36C4: 0012           addb    rh2,@r1
36C6: 0010           addb    rh0,@r1
36C8: 000F 000D      addb    rl7,#%0d
36CC: 000C 000A      addb    rl4,#%0a
36D0: 0009 0007      addb    rl1,#%07
36D4: 0006 0005      addb    rh6,#%05
36D8: 0003 0002      addb    rh3,#%02
36DC: 0001 0000      addb    rh1,#%00
36E0: 0000 0000      addb    rh0,#%00
36E4: 0000 0000      addb    rh0,#%00
36E8: 0000 0000      addb    rh0,#%00
36EC: 0000 0000      addb    rh0,#%00
36F0: 0000 0000      addb    rh0,#%00
36F4: 0000 0000      addb    rh0,#%00
36F8: 0000 0000      addb    rh0,#%00
36FC: 0000 0000      addb    rh0,#%00
3700: 0000 0000      addb    rh0,#%00
3704: 0000 0000      addb    rh0,#%00
3708: FCF8           djnz    r12,%361a
370A: F0E0           djnz    r0,%364c
370C: D0D0           calr    %356e
370E: D0D0           calr    %3570
3710: D0D0           calr    %3572
3712: D0D0           calr    %3574
3714: D0D8           calr    %3566
3716: E0E8           jr      n,%36e8
3718: F0F4           djnz    r0,%3632
371A: F8FC           djnz    r8,%3624
371C: 0000 0002      addb    rh0,#%02
3720: 0408 0C10      orb     rl0,#%10
3724: 1010           cpl     rr0,@r1
3726: 1010           cpl     rr0,@r1
3728: 1010           cpl     rr0,@r1
372A: 1010           cpl     rr0,@r1
372C: 1010           cpl     rr0,@r1
372E: 100E 0C0A 0806 cpl     rr14,#%0c0a0806
3734: 0402 0000      orb     rh2,#%00
3738: 00FC           addb    rl4,@r15
373A: F8F4           djnz    r8,%3654
373C: F0EC           djnz    r0,%3666
373E: E8E4           jr      %3708
3740: E0E0           jr      n,%3702
3742: E0E0           jr      n,%3704
3744: E0E0           jr      n,%3706
3746: E0E0           jr      n,%3708
3748: E0E0           jr      n,%370a
374A: E0E4           jr      n,%3714
374C: E8EC           jr      %3726
374E: F0F4           djnz    r0,%3668
3750: F8FA           djnz    r8,%365e
3752: FCFE           djnz    r12,%3658
3754: 0000 0000      addb    rh0,#%00
3758: 0810           xorb    rh0,@r1
375A: 2030           ldb     rh0,@r3
375C: 4050 5050      addb    rh0,%5050(r5)
3760: 4030 2018      addb    rh0,%2018(r3)
3764: 1008 0400 0000 cpl     rr8,#%04000000
376A: 0000 0000      addb    rh0,#%00
376E: 00FC           addb    rl4,@r15
3770: F8F4           djnz    r8,%368a
3772: F0EC           djnz    r0,%369c
3774: ECEC           jr      po/nov,%374e
3776: ECEC           jr      po/nov,%3750
3778: ECEC           jr      po/nov,%3752
377A: ECEC           jr      po/nov,%3754
377C: ECF0           jr      po/nov,%375e
377E: F4F8           djnz    r4,%3690
3780: FCFD           djnz    r12,%3688
3782: FEFD           djnz    r14,%368a
3784: FCF8           djnz    r12,%3696
3786: F4F0           djnz    r4,%36a8
3788: F0F0           djnz    r0,%36aa
378A: F0F0           djnz    r0,%36ac
378C: F0F0           djnz    r0,%36ae
378E: F0F0           djnz    r0,%36b0
3790: F0F0           djnz    r0,%36b2
3792: F0F0           djnz    r0,%36b4
3794: F0F0           djnz    r0,%36b6
3796: F0F0           djnz    r0,%36b8
3798: F0F0           djnz    r0,%36ba
379A: F0F0           djnz    r0,%36bc
379C: F0F0           djnz    r0,%36be
379E: F0F0           djnz    r0,%36c0
37A0: F0EE           djnz    r0,%36c6
37A2: ECEA           jr      po/nov,%3778
37A4: E8E8           jr      %3776
37A6: E8E8           jr      %3778
37A8: E8E6           jr      %3776
37AA: E4E2           jr      pe/ov,%3770
37AC: E0E0           jr      n,%376e
37AE: E0E0           jr      n,%3770
37B0: E0E0           jr      n,%3772
37B2: E0E0           jr      n,%3774
37B4: E0E0           jr      n,%3776
37B6: E0E4           jr      n,%3780
37B8: E8EC           jr      %3792
37BA: F0F4           djnz    r0,%36d4
37BC: F8FA           djnz    r8,%36ca
37BE: FCFE           djnz    r12,%36c4
37C0: 0000 0000      addb    rh0,#%00
37C4: 0000 0000      addb    rh0,#%00
37C8: 0000 0000      addb    rh0,#%00
37CC: 0000 0000      addb    rh0,#%00
37D0: 0000 0000      addb    rh0,#%00
37D4: 0000 0000      addb    rh0,#%00
37D8: 0000 0000      addb    rh0,#%00
37DC: 0000 0000      addb    rh0,#%00
37E0: FFFF           djnz    r15,%36e4
37E2: FFE3           djnz    r15,%371e
37E4: BA9B           .word   #%ba9b
37E6: 8370           sub     r0,r7
37E8: 6155 4B42      ld      r5,%4b42(r5)
37EC: 3B35 302C      sin    r3,#%302c
37F0: 2825           incb    @r2,6
37F2: 221F           resb    @r1,15
37F4: 1D1B           ldl     @r1,rr11
37F6: 1917           mult    rr7,@r1
37F8: 1614           addl    rr4,@r1
37FA: 1312           push    @r1,@r2
37FC: 1110           .word   #%1110
37FE: 0F0E           ext0f   #%0e
3800: 0D0D           .word   #%0d0d
3802: 0C0C           .word   #%0c0c
3804: 0B0B 0A0A      cp      r11,#%0a0a
3808: 0909 0808      xor     r9,#%0808
380C: 0807 0707      xorb    rh7,#%07
3810: 0706 0606      and     r6,#%0606
3814: 0606 0505      andb    rh6,#%05
3818: 0505 0505      or      r5,#%0505
381C: 0404 0404      orb     rh4,#%04
3820: 0404 0404      orb     rh4,#%04
3824: 0303 0303      sub     r3,#%0303
3828: 0303 0303      sub     r3,#%0303
382C: 0303 0303      sub     r3,#%0303
3830: 0302 0202      sub     r2,#%0202
3834: 0202 0202      subb    rh2,#%02
3838: 0202 0202      subb    rh2,#%02
383C: 0202 0202      subb    rh2,#%02
3840: 0202 0202      subb    rh2,#%02
3844: 0202 0201      subb    rh2,#%01
3848: 0101 0101      add     r1,#%0101
384C: 0101 0101      add     r1,#%0101
3850: 0607 0809      andb    rh7,#%09
3854: 0A0B 0C0D      cpb     rl3,#%0d
3858: 0E0A           ext0e   #%0a
385A: 0B0C 0607      cp      r12,#%0607
385E: 0809 5051      xorb    rl1,#%51
3862: 5253 5455      subl    rr3,%5455(r5)
3866: 5657 0A0B      addl    rr7,%0a0b(r5)
386A: 0C0D           .word   #%0c0d
386C: 0E0F           ext0e   #%0f
386E: 1011           cpl     rr1,@r1
3870: 1213           subl    rr3,@r1
3872: 1415           ldl     rr5,@r1
3874: 1617           addl    rr7,@r1
3876: 1819           multl   rq9,@r1
3878: 1A1B           divl    rq11,@r1
387A: 1C1D           .word   #%1c1d
387C: 1516           popl    @r6,@r1
387E: 1718           pop     @r8,@r1
3880: 1E1F           jp      nc/uge,@rr1
3882: 2030           ldb     rh0,@r3
3884: 3132 1213      ld      r2,r3(#%1213)
3888: 1415           ldl     rr5,@r1
388A: 1617           addl    rr7,@r1
388C: 1819           multl   rq9,@r1
388E: 1A1B           divl    rq11,@r1
3890: 1516           popl    @r6,@r1
3892: 1718           pop     @r8,@r1
3894: 1213           subl    rr3,@r1
3896: 141C           ldl     rr12,@r1
3898: 1D1E           ldl     @r1,rr14
389A: 1F20           call    r2
389C: 2728           bit     @r2,8
389E: 292A           inc     @r2,11
38A0: 0001 0203      addb    rh1,#%03
38A4: 0405 0A0B      orb     rh5,#%0b
38A8: 0C0F           .word   #%0c0f
38AA: 1011           cpl     rr1,@r1
38AC: 1213           subl    rr3,@r1
38AE: 1415           ldl     rr5,@r1
38B0: 1617           addl    rr7,@r1
38B2: 181C           multl   rq12,@r1
38B4: 1D4A           ldl     @r4,rr10
38B6: 4B4C 5051      cp      r12,%5051(r4)
38BA: 5253 5455      subl    rr3,%5455(r5)
38BE: 5657 0607      addl    rr7,%0607(r5)
38C2: 0809 0A0B      xorb    rl1,#%0b
38C6: 0C58           clrb    @r5
38C8: 595A 5B4B      mult    rr10,%5b4b(r5)
38CC: 4C50 5152      comb    %5152(r5)
38D0: 5354 5556      push    @r5,%5556(r4)
38D4: 5758 595A      pop     %595a(r8),@r5
38D8: 5B40 4342      div     rr0,%4342(r4)
38DC: 6869 6A6B      incb    %6a6b(r6),10
38E0: 6C6D 6E6F      exb     rl5,%6e6f(r6)
38E4: 0A0B 0C7D      cpb     rl3,#%7d
38E8: 7E7F           rsvd7e  #%7f
38EA: 2B2C           dec     @r2,13
38EC: 2D21           ex      r1,@r2
38EE: 2223           resb    @r2,3
38F0: 2425           setb    @r2,5
38F2: 262E           bitb    @r2,14
38F4: 2F00           .word   #%2f00
38F6: 0102 0304      add     r2,#%0304
38FA: 050A 0B0C      or      r10,#%0b0c
38FE: 5051 5253      cpl     rr1,%5253(r5)
3902: 5455 5657      ldl     rr5,%5657(r5)
3906: 7D7E           ldctl   nspseg,r7
3908: 7F00           sc      #%00
390A: 0102 0304      add     r2,#%0304
390E: 050A 0B0C      or      r10,#%0b0c
3912: 5859 5A5B      multl   rq9,%5a5b(r5)
3916: 4E4F           .word   #%4e4f
3918: 5051 5253      cpl     rr1,%5253(r5)
391C: 5455 5657      ldl     rr5,%5657(r5)
3920: 7D7E           ldctl   nspseg,r7
3922: 7F00           sc      #%00
3924: 0102 0304      add     r2,#%0304
3928: 050D 0E58      or      r13,#%0e58
392C: 595A 5B40      mult    rr10,%5b40(r5)
3930: 4142 5C5D      add     r2,%5c5d(r4)
3934: 5E5F 5F5F      jp      nc/uge,%5f5f(r5)
3938: 5F5F           .word   #%5f5f
393A: 6061 6263      ldb     rh1,%6263(r6)
393E: 6465 6667      setb    %6667(r6),5
3942: 4041 4243      addb    rh1,%4243(r4)
3946: 443C 3D3E      orb     rl4,%3d3e(r3)
394A: 3F4E           out     @r4,r14
394C: 4F0A           .word   #%4f0a
394E: 0B0C 0301      cp      r12,#%0301
3952: 0200 0303      subb    rh0,#%03
3956: 0202 0305      subb    rh2,#%05
395A: 0204 0307      subb    rh4,#%07
395E: 0206 0309      subb    rh6,#%09
3962: 0208 030B      subb    rl0,#%0b
3966: 020A 030D      subb    rl2,#%0d
396A: 020C 030F      subb    rl4,#%0f
396E: 020E 0311      subb    rl6,#%11
3972: 0210           subb    rh0,@r1
3974: 0313           sub     r3,@r1
3976: 0212           subb    rh2,@r1
3978: 0315           sub     r5,@r1
397A: 0214           subb    rh4,@r1
397C: 0317           sub     r7,@r1
397E: 0216           subb    rh6,@r1
3980: 0319           sub     r9,@r1
3982: 0218           subb    rl0,@r1
3984: 031B           sub     r11,@r1
3986: 021A           subb    rl2,@r1
3988: 031D           sub     r13,@r1
398A: 021C           subb    rl4,@r1
398C: 031F           sub     r15,@r1
398E: 001E           addb    rl6,@r1
3990: 0321           sub     r1,@r2
3992: 0020           addb    rh0,@r2
3994: 0323           sub     r3,@r2
3996: 0122           add     r2,@r2
3998: 0425           orb     rh5,@r2
399A: 0124           add     r4,@r2
399C: 0427           orb     rh7,@r2
399E: 0126           add     r6,@r2
39A0: 0429           orb     rl1,@r2
39A2: 0128           add     r8,@r2
39A4: 042B           orb     rl3,@r2
39A6: 012A           add     r10,@r2
39A8: 042D           orb     rl5,@r2
39AA: 012C           add     r12,@r2
39AC: 042F           orb     rl7,@r2
39AE: 012E           add     r14,@r2
39B0: 0431           orb     rh1,@r3
39B2: 0130           add     r0,@r3
39B4: 0433           orb     rh3,@r3
39B6: 0132           add     r2,@r3
39B8: 0435           orb     rh5,@r3
39BA: 0134           add     r4,@r3
39BC: 0437           orb     rh7,@r3
39BE: 0136           add     r6,@r3
39C0: 0439           orb     rl1,@r3
39C2: 0138           add     r8,@r3
39C4: 043B           orb     rl3,@r3
39C6: 013A           add     r10,@r3
39C8: 0343           sub     r3,@r4
39CA: 0142           add     r2,@r4
39CC: 0345           sub     r5,@r4
39CE: 0144           add     r4,@r4
39D0: 0347           sub     r7,@r4
39D2: 0146           add     r6,@r4
39D4: 0301 0200      sub     r1,#%0200
39D8: 0303 0202      sub     r3,#%0202
39DC: 0305 0204      sub     r5,#%0204
39E0: 0307 0200      sub     r7,#%0200
39E4: 0309 0202      sub     r9,#%0202
39E8: 030B 0204      sub     r11,#%0204
39EC: 030D 0200      sub     r13,#%0200
39F0: 030F 0202      sub     r15,#%0202
39F4: 0311           sub     r1,@r1
39F6: 0204 0313      subb    rh4,#%13
39FA: 0200 0315      subb    rh0,#%15
39FE: 0202 0317      subb    rh2,#%17
3A02: 0204 0319      subb    rh4,#%19
3A06: 0200 031B      subb    rh0,#%1b
3A0A: 0202 031D      subb    rh2,#%1d
3A0E: 0204 031F      subb    rh4,#%1f
3A12: 091E           xor     r14,@r1
3A14: 0321           sub     r1,@r2
3A16: 0920           xor     r0,@r2
3A18: 0323           sub     r3,@r2
3A1A: 0122           add     r2,@r2
3A1C: 033D           sub     r13,@r3
3A1E: 003C           addb    rl4,@r3
3A20: 033F           sub     r15,@r3
3A22: 003E           addb    rl6,@r3
3A24: 0341           sub     r1,@r4
3A26: 0140           add     r0,@r4
3A28: 037F           sub     r15,@r7
3A2A: 0A42           cpb     rh2,@r4
3A2C: 037F           sub     r15,@r7
3A2E: 0A44           cpb     rh4,@r4
3A30: 037F           sub     r15,@r7
3A32: 0A46           cpb     rh6,@r4
3A34: 037F           sub     r15,@r7
3A36: 0B06 037F      cp      r6,#%037f
3A3A: 0B08 037F      cp      r8,#%037f
3A3E: 0B0A 037F      cp      r10,#%037f
3A42: 0B0C 037F      cp      r12,#%037f
3A46: 0B0E 037F      cp      r14,#%037f
3A4A: 0B10           cp      r0,@r1
3A4C: 037F           sub     r15,@r7
3A4E: 0B12           cp      r2,@r1
3A50: 037F           sub     r15,@r7
3A52: 0B14           cp      r4,@r1
3A54: 037F           sub     r15,@r7
3A56: 0B16           cp      r6,@r1
3A58: 037F           sub     r15,@r7
3A5A: 0B18           cp      r8,@r1
3A5C: 037F           sub     r15,@r7
3A5E: 0B1A           cp      r10,@r1
3A60: 037F           sub     r15,@r7
3A62: 0B1C           cp      r12,@r1
3A64: 037F           sub     r15,@r7
3A66: 0C3C           .word   #%0c3c
3A68: 037F           sub     r15,@r7
3A6A: 0C3E           .word   #%0c3e
3A6C: 037F           sub     r15,@r7
3A6E: 053C           or      r12,@r3
3A70: 037F           sub     r15,@r7
3A72: 053E           or      r14,@r3
3A74: 037F           sub     r15,@r7
3A76: 0A40           cpb     rh0,@r4
3A78: 037F           sub     r15,@r7
3A7A: 056A           or      r10,@r6
3A7C: 037F           sub     r15,@r7
3A7E: 056B           or      r11,@r6
3A80: 037F           sub     r15,@r7
3A82: 066C           andb    rl4,@r6
3A84: 037F           sub     r15,@r7
3A86: 0C6A           .word   #%0c6a
3A88: 037F           sub     r15,@r7
3A8A: 0C6B           .word   #%0c6b
3A8C: 037F           sub     r15,@r7
3A8E: 066C           andb    rl4,@r6
3A90: 0349           sub     r9,@r4
3A92: 0248           subb    rl0,@r4
3A94: 034B           sub     r11,@r4
3A96: 024A           subb    rl2,@r4
3A98: 034D           sub     r13,@r4
3A9A: 024C           subb    rl4,@r4
3A9C: 034F           sub     r15,@r4
3A9E: 024E           subb    rl6,@r4
3AA0: 0351           sub     r1,@r5
3AA2: 0250           subb    rh0,@r5
3AA4: 0353           sub     r3,@r5
3AA6: 0252           subb    rh2,@r5
3AA8: 0355           sub     r5,@r5
3AAA: 0254           subb    rh4,@r5
3AAC: 0357           sub     r7,@r5
3AAE: 0256           subb    rh6,@r5
3AB0: 0359           sub     r9,@r5
3AB2: 0658           andb    rl0,@r5
3AB4: 035B           sub     r11,@r5
3AB6: 065A           andb    rl2,@r5
3AB8: 037F           sub     r15,@r7
3ABA: 075C           and     r12,@r5
3ABC: 037F           sub     r15,@r7
3ABE: 075D           and     r13,@r5
3AC0: 037F           sub     r15,@r7
3AC2: 075E           and     r14,@r5
3AC4: 037F           sub     r15,@r7
3AC6: 075F           and     r15,@r5
3AC8: 037F           sub     r15,@r7
3ACA: 0760           and     r0,@r6
3ACC: 037F           sub     r15,@r7
3ACE: 0761           and     r1,@r6
3AD0: 037F           sub     r15,@r7
3AD2: 0762           and     r2,@r6
3AD4: 037F           sub     r15,@r7
3AD6: 0763           and     r3,@r6
3AD8: 037F           sub     r15,@r7
3ADA: 0764           and     r4,@r6
3ADC: 037F           sub     r15,@r7
3ADE: 0765           and     r5,@r6
3AE0: 037F           sub     r15,@r7
3AE2: 0766           and     r6,@r6
3AE4: 037F           sub     r15,@r7
3AE6: 0767           and     r7,@r6
3AE8: 037F           sub     r15,@r7
3AEA: 0768           and     r8,@r6
3AEC: 037F           sub     r15,@r7
3AEE: 0769           and     r9,@r6
3AF0: 037F           sub     r15,@r7
3AF2: 206D           ldb     rl5,@r6
3AF4: 226F           resb    @r6,15
3AF6: 216E           ld      r14,@r6
3AF8: 2271           resb    @r7,1
3AFA: 2370           res     @r7,0
3AFC: 2273           resb    @r7,3
3AFE: 2372           res     @r7,2
3B00: 2475           setb    @r7,5
3B02: 2174           ld      r4,@r7
3B04: 2477           setb    @r7,7
3B06: 2576           set     @r7,6
3B08: 2679           bitb    @r7,9
3B0A: 2178           ld      r8,@r7
3B0C: 227B           resb    @r7,11
3B0E: 277A           bit     @r7,10
3B10: 037F           sub     r15,@r7
3B12: 0C6A           .word   #%0c6a
3B14: 037F           sub     r15,@r7
3B16: 0C6B           .word   #%0c6b
3B18: 037F           sub     r15,@r7
3B1A: 0D6C           .word   #%0d6c
3B1C: 037F           sub     r15,@r7
3B1E: 0D48           clr     @r4
3B20: 037F           sub     r15,@r7
3B22: 0D4A           .word   #%0d4a
3B24: 037F           sub     r15,@r7
3B26: 0D4C           .word   #%0d4c
3B28: 037F           sub     r15,@r7
3B2A: 0D4E           .word   #%0d4e
3B2C: 037F           sub     r15,@r7
3B2E: 0D50           com     @r5
3B30: 037F           sub     r15,@r7
3B32: 0D52           neg     @r5
3B34: 037F           sub     r15,@r7
3B36: 0D54           test    @r5
3B38: 037F           sub     r15,@r7
3B3A: 0D56           tset    @r5
3B3C: 037F           sub     r15,@r7
3B3E: 0D58           clr     @r5
3B40: 037F           sub     r15,@r7
3B42: 0D5A           .word   #%0d5a
3B44: 031F           sub     r15,@r1
3B46: 0E3C           ext0e   #%3c
3B48: 0321           sub     r1,@r2
3B4A: 0E3E           ext0e   #%3e
3B4C: 0323           sub     r3,@r2
3B4E: 0200 10FF      subb    rh0,#%ff
3B52: 10FF           cpl     rr15,@r15
3B54: 11FF           pushl   @r15,@r15
3B56: 11FF           pushl   @r15,@r15
3B58: 12FF           subl    rr15,@r15
3B5A: 12FF           subl    rr15,@r15
3B5C: 13FF           push    @r15,@r15
3B5E: 13FF           push    @r15,@r15
3B60: 13FF           push    @r15,@r15
3B62: 13FF           push    @r15,@r15
3B64: 13FF           push    @r15,@r15
3B66: 13FF           push    @r15,@r15
3B68: 0219           subb    rl1,@r1
3B6A: 08AC           xorb    rl4,@r10
3B6C: B00E           .word   #%b00e
3B6E: ADB1           ex      r1,r11
3B70: 0EAE           ext0e   #%ae
3B72: B20E           rrcb    rh0,2
3B74: AFB3           tcc     ule,r11
3B76: 0FB4           ext0f   #%b4
3B78: 0003 1C0A      addb    rh3,#%0a
3B7C: B50F           adc     r15,r0
3B7E: B60F           sbcb    rl7,rh0
3B80: B700           sbc     r0,r0
3B82: 1018           cpl     rr8,@r1
3B84: 0D88           clr     @r8
3B86: 0F89           ext0f   #%89
3B88: 0F8A           ext0f   #%8a
3B8A: 0F8B           ext0f   #%8b
3B8C: 0020           addb    rh0,@r2
3B8E: 180D           multl   rq13,@%l#1
3B90: 860F           andb    rl7,rh0
3B92: 8700           and     r0,r0
3B94: 9819           multl   rq9,rr1
3B96: 0992           xor     r2,@r9
3B98: 0E8C           ext0e   #%8c
3B9A: 930E           .word   #%930e
3B9C: 8E95           ext8e   #%95
3B9E: 0E8F           ext0e   #%8f
3BA0: 960E           addl    rr14,rr0
3BA2: 9097           cpl     rr7,rr9
3BA4: 0E91           ext0e   #%91
3BA6: 9800           multl   rq0,rr0
3BA8: 981C           multl   rq12,rr1
3BAA: 990F           mult    rr15,r0
3BAC: 9A0F           divl    rq15,rr0
3BAE: 9B0F           div     rr15,r0
3BB0: 9C0F           .word   #%9c0f
3BB2: 9D00           rsvd9d
3BB4: 3018 0D80      ldb     rl0,r1(#%0d80)
3BB8: 0F81           ext0f   #%81
3BBA: 0F82           ext0f   #%82
3BBC: 0F83           ext0f   #%83
3BBE: 0F84           ext0f   #%84
3BC0: 0F85           ext0f   #%85
3BC2: 0040           addb    rh0,@r4
3BC4: 180D           multl   rq13,@%l#1
3BC6: 880F           xorb    rl7,rh0
3BC8: 890F           xor     r15,r0
3BCA: 8A0F           cpb     rl7,rh0
3BCC: 8B00           cp      r0,r0
3BCE: 5018 0D86      cpl     rr8,%0d86(r1)
3BD2: 0F87           ext0f   #%87
3BD4: 0090           addb    rh0,@r9
3BD6: 280D           .word   #%280d
3BD8: F00F           dbjnz   rh0,%3bbc
3BDA: F100           dbjnz   rh1,%3bdc
3BDC: C018           ldb     rh0,#%18
3BDE: 0D80           com     @r8
3BE0: 0F81           ext0f   #%81
3BE2: 0F82           ext0f   #%82
3BE4: 0F83           ext0f   #%83
3BE6: 0F84           ext0f   #%84
3BE8: 0F85           ext0f   #%85
3BEA: 00CA           addb    rl2,@r12
3BEC: 180D           multl   rq13,@%l#1
3BEE: 880F           xorb    rl7,rh0
3BF0: 890F           xor     r15,r0
3BF2: 8A0F           cpb     rl7,rh0
3BF4: 8B00           cp      r0,r0
3BF6: D819           calr    %4bc6
3BF8: 089E           xorb    rl6,@r9
3BFA: A50E           set     r0,14
3BFC: 9FA6           rsvd9f
3BFE: 0EA0           ext0e   #%a0
3C00: A70E           bit     r0,14
3C02: A1A8           ld      r8,r10
3C04: 0EA2           ext0e   #%a2
3C06: A90E           inc     r0,15
3C08: A3AA           res     r10,10
3C0A: 0EA4           ext0e   #%a4
3C0C: AB00           dec     r0,1
3C0E: E418           jr      pe/ov,%3c40
3C10: 0D86           tset    @r8
3C12: 0F87           ext0f   #%87
3C14: 00F0           addb    rh0,@r15
3C16: 180D           multl   rq13,@%l#1
3C18: 800F           addb    rl7,rh0
3C1A: 810F           add     r15,r0
3C1C: 820F           subb    rl7,rh0
3C1E: 830F           sub     r15,r0
3C20: 840F           orb     rl7,rh0
3C22: 8500           or      r0,r0
3C24: 0000 0000      addb    rh0,#%00
3C28: 243E           setb    @r3,14
3C2A: 2624           bitb    @r2,4
3C2C: 2424           setb    @r2,4
3C2E: 2424           setb    @r2,4
3C30: 2424           setb    @r2,4
3C32: 2724           bit     @r2,4
3C34: 2424           setb    @r2,4
3C36: 2524           set     @r2,4
3C38: 0001 0203      addb    rh1,#%03
3C3C: 0405 0607      orb     rh5,#%07
3C40: 0809 2424      xorb    rl1,#%24
3C44: 3224 3324      ldb     r2(#%3324),rh4
3C48: 240A 0B0C      setb    rl3,r10
3C4C: 0D0E           .word   #%0d0e
3C4E: 0F10           ext0f   #%10
3C50: 1112           pushl   @r1,@r2
3C52: 1314           push    @r1,@r4
3C54: 1516           popl    @r6,@r1
3C56: 1718           pop     @r8,@r1
3C58: 191A           mult    rr10,@r1
3C5A: 1B1C           div     rr12,@r1
3C5C: 1D1E           ldl     @r1,rr14
3C5E: 1F20           call    r2
3C60: 2122           ld      r2,@r2
3C62: 2324           res     @r2,4
3C64: 2424           setb    @r2,4
3C66: 2424           setb    @r2,4
3C68: 2428           setb    @r2,8
3C6A: 292A           inc     @r2,11
3C6C: 2B2C           dec     @r2,13
3C6E: 2D2E           ex      r14,@r2
3C70: 2F34           ld      @r3,r4
3C72: 3530 3631      ldl     rr0,r3(#%3631)
3C76: 3738 393A      ldl     r3(#%393a),rr8
3C7A: 3B3C           .word   #%3b3c
3C7C: 8C8D           .word   #%8c8d
3C7E: 8E8F           ext8e   #%8f
3C80: 898A           xor     r10,r8
3C82: 8B24           cp      r4,r2
3C84: 2424           setb    @r2,4
3C86: 2424           setb    @r2,4
3C88: 4041 4243      addb    rh1,%4243(r4)
3C8C: 4445 4647      orb     rh5,%4647(r4)
3C90: 4824 4041      xorb    rh4,%4041(r2)
3C94: 4243 494A      subb    rh3,%494a(r4)
3C98: 4B4C 4D4E      cp      r12,%4d4e(r4)
3C9C: 4F50           .word   #%4f50
3C9E: 5152 5354      pushl   @r5,%5354(r2)
3CA2: 5556 5758      popl    %5758(r6),@r5
3CA6: 595A 5B5C      mult    rr10,%5b5c(r5)
3CAA: 5D5E 5F24      ldl     %5f24(r5),rr14
3CAE: 5758 595A      pop     %595a(r8),@r5
3CB2: 6061 6263      ldb     rh1,%6263(r6)
3CB6: 6465 6667      setb    %6667(r6),5
3CBA: 6869 6A6B      incb    %6a6b(r6),10
3CBE: 6C6D 6E6F      exb     rl5,%6e6f(r6)
3CC2: 7071 7273      ldb     rh1,r7(r2)
3CC6: 7475 7624      lda     pr5,r7(r6)
3CCA: 6E6F 7071      ldb     %7071(r6),rl7
3CCE: 7778 797A      ldl     r7(r9),rr8
3CD2: 7B7C           .word   #%7b7c
3CD4: 7D7E           ldctl   nspseg,r7
3CD6: 7F80           sc      #%80
3CD8: 8182           add     r2,r8
3CDA: 8384           sub     r4,r8
3CDC: 02B0           subb    rh0,@r11
3CDE: B1B2           .word   #%b1b2
3CE0: B2B2           rlb     rl3,2
3CE2: B2B2           rlb     rl3,2
3CE4: B2B2           rlb     rl3,2
3CE6: B2B2           rlb     rl3,2
3CE8: B2B2           rlb     rl3,2
3CEA: B3B2           rl      r11,2
3CEC: B2B2           rlb     rl3,2
3CEE: B2B2           rlb     rl3,2
3CF0: B2B2           rlb     rl3,2
3CF2: B2B2           rlb     rl3,2
3CF4: B2B2           rlb     rl3,2
3CF6: B2B4           rrb     rl3,1
3CF8: B503           adc     r3,r0
3CFA: B6B7           sbcb    rh7,rl3
3CFC: B818 B9BA      trdb    @r1,@r11,rl1
3D00: 03BB           sub     r11,@r11
3D02: 1ABC           divl    rq12,@r11
3D04: BD03           ldk     r0,3
3D06: BE0E           rldb    rl6,rh0
3D08: BFC0           rsvdbf
3D0A: C104           ldb     rh1,#%04
3D0C: C2C3           ldb     rh2,#%c3
3D0E: C4C5           ldb     rh4,#%c5
3D10: C6C7           ldb     rh6,#%c7
3D12: C803           ldb     rl0,#%03
3D14: C90E           ldb     rl1,#%0e
3D16: CACB           ldb     rl2,#%cb
3D18: CC03           ldb     rl4,#%03
3D1A: CDCE           ldb     rl5,#%ce
3D1C: CF08           ldb     rl7,#%08
3D1E: D00D           calr    %3d06
3D20: D1D2           calr    %397e
3D22: D3D4           calr    %357c
3D24: 02D5           subb    rh5,@r13
3D26: D60A           calr    %3114
3D28: D7D8           calr    %2d7a
3D2A: 0BD9           cp      r9,@r13
3D2C: DA01           calr    %492c
3D2E: DB03           calr    %472a
3D30: DCDD           calr    %4378
3D32: 0ADE           cpb     rl6,@r13
3D34: DF0B           calr    %3f20
3D36: E0E1           jr      n,%3cfa
3D38: 01E2           add     r2,@r14
3D3A: 03E3           sub     r3,@r14
3D3C: 0CE4           testb   @r14
3D3E: E509           jr      mi,%3d52
3D40: E6E7           jr      eq/z,%3d10
3D42: 02E8           subb    rl0,@r14
3D44: 02E9           subb    rl1,@r14
3D46: EA0D           jr      gt,%3d62
3D48: EBEC           jr      ugt,%3d22
3D4A: ED05           jr      pl,%3d56
3D4C: EEEF           jr      ne/nz,%3d2c
3D4E: F003           dbjnz   rh0,%3d4a
3D50: F102           dbjnz   rh1,%3d4e
3D52: F2F3           djnz    r2,%3c6e
3D54: 0FF4           ext0f   #%f4
3D56: F5F6           djnz    r5,%3c6c
3D58: FEFE           djnz    r14,%3c5e
3D5A: F7F8           djnz    r7,%3c6c
3D5C: F904           dbjnz   rl1,%3d56
3D5E: FAFB           djnz    r10,%3c6a
3D60: FCFD           djnz    r12,%3c68
3D62: 00FF           addb    rl7,@r15
3D64: 1401 1D03 2407 ldl     rr1,#%1d032407
3D6A: 2F00           .word   #%2f00
3D6C: 3404 4603      ldar    pr4,%8373
3D70: 4905 5609      xor     r5,%5609
3D74: 6001 6908      ldb     rh1,%6908
3D78: 7006           .word   #%7006
3D7A: 7F00           sc      #%00
3D7C: 8003           addb    rh3,rh0
3D7E: 8509           or      r9,r0
3D80: 9004           cpl     rr4,rr0
3D82: 9A01           divl    rq1,rr0
3D84: A505           set     r0,5
3D86: B002           .word   #%b002
3D88: BB00           .word   #%bb00
3D8A: C608           ldb     rh6,#%08
3D8C: D401           calr    %358c
3D8E: DC04           calr    %4588
3D90: E500           jr      mi,%3d92
3D92: EE05           jr      ne/nz,%3d9e
3D94: 5750 5900      pop     %5900,@r5
3D98: 6100 6300      ld      r0,%6300
3D9C: 6500 6700      set     %6700,0
3DA0: 6900 7100      inc     %7100,1
3DA4: 5800 6000      multl   rq0,%6000
3DA8: 6200 6400      resb    %6400,0
3DAC: 6600 6800      bitb    %6800,0
3DB0: 7000           .word   #%7000
3DB2: 7200           .word   #%7200
3DB4: 5850 6000      multl   rq0,%6000(r5)
3DB8: 6200 6400      resb    %6400,0
3DBC: 6600 6800      bitb    %6800,0
3DC0: 7000           .word   #%7000
3DC2: 7300           .word   #%7300
3DC4: 5900 6100      mult    rr0,%6100
3DC8: 6300 6500      res     %6500,0
3DCC: 6700 6900      bit     %6900,0
3DD0: 7100           .word   #%7100
3DD2: 7400           .word   #%7400
3DD4: 6550 6750      set     %6750(r5),0
3DD8: 7000           .word   #%7000
3DDA: 7250 7450      ldb     r5(r4),rh0
3DDE: 7650 7900      lda     pr0,%7900(r5)
3DE2: 8100           add     r0,r0
3DE4: 6600 6800      bitb    %6800,0
3DE8: 7000           .word   #%7000
3DEA: 7300           .word   #%7300
3DEC: 7500           .word   #%7500
3DEE: 7700           .word   #%7700
3DF0: 8000           addb    rh0,rh0
3DF2: 8200           subb    rh0,rh0
3DF4: 5700           .word   #%5700
3DF6: 5900 6100      mult    rr0,%6100
3DFA: 6300 6500      res     %6500,0
3DFE: 6700 6900      bit     %6900,0
3E02: 7100           .word   #%7100
3E04: 5950 6100      mult    rr0,%6100(r5)
3E08: 6300 6600      res     %6600,0
3E0C: 6800 7000      incb    %7000,1
3E10: 7200           .word   #%7200
3E12: 7500           .word   #%7500
3E14: 004B           addb    rl3,@r4
3E16: 0032           addb    rh2,@r3
3E18: 003D           addb    rl5,@r3
3E1A: 0000 004B      addb    rh0,#%4b
3E1E: 002E           addb    rl6,@r2
3E20: 003B           addb    rl3,@r3
3E22: 0000 004B      addb    rh0,#%4b
3E26: 0030           addb    rh0,@r3
3E28: 003C           addb    rl4,@r3
3E2A: 0000 004B      addb    rh0,#%4b
3E2E: 002C           addb    rl4,@r2
3E30: 003A           addb    rl2,@r3
3E32: 0000 004B      addb    rh0,#%4b
3E36: 0030           addb    rh0,@r3
3E38: 003C           addb    rl4,@r3
3E3A: 0000 004B      addb    rh0,#%4b
3E3E: 002E           addb    rl6,@r2
3E40: 003B           addb    rl3,@r3
3E42: 0000 004B      addb    rh0,#%4b
3E46: 0030           addb    rh0,@r3
3E48: 003C           addb    rl4,@r3
3E4A: 0000 004B      addb    rh0,#%4b
3E4E: 002E           addb    rl6,@r2
3E50: 003B           addb    rl3,@r3
3E52: 0000 004B      addb    rh0,#%4b
3E56: 0035           addb    rh5,@r3
3E58: 003A           addb    rl2,@r3
3E5A: 003E           addb    rl6,@r3
3E5C: 004B           addb    rl3,@r4
3E5E: 0031           addb    rh1,@r3
3E60: 0038           addb    rl0,@r3
3E62: 003C           addb    rl4,@r3
3E64: 004B           addb    rl3,@r4
3E66: 0033           addb    rh3,@r3
3E68: 0039           addb    rl1,@r3
3E6A: 003D           addb    rl5,@r3
3E6C: 004B           addb    rl3,@r4
3E6E: 002F           addb    rl7,@r2
3E70: 0037           addb    rh7,@r3
3E72: 003B           addb    rl3,@r3
3E74: 004B           addb    rl3,@r4
3E76: 0033           addb    rh3,@r3
3E78: 0039           addb    rl1,@r3
3E7A: 003D           addb    rl5,@r3
3E7C: 004B           addb    rl3,@r4
3E7E: 0031           addb    rh1,@r3
3E80: 0038           addb    rl0,@r3
3E82: 003C           addb    rl4,@r3
3E84: 004B           addb    rl3,@r4
3E86: 0033           addb    rh3,@r3
3E88: 0039           addb    rl1,@r3
3E8A: 003D           addb    rl5,@r3
3E8C: 004B           addb    rl3,@r4
3E8E: 0031           addb    rh1,@r3
3E90: 0038           addb    rl0,@r3
3E92: 003C           addb    rl4,@r3
3E94: 1E1E           jp      ne/nz,@rr1
3E96: 2323           res     @r2,3
3E98: 282D           incb    @r2,14
3E9A: 3237 3C37      ldb     r3(#%3c37),rh7
3E9E: 3228 140A      ldb     r2(#%140a),rl0
3EA2: 0000 1E1E      addb    rh0,#%1e
3EA6: 2323           res     @r2,3
3EA8: 282D           incb    @r2,14
3EAA: 3237 3C37      ldb     r3(#%3c37),rh7
3EAE: 3228 140A      ldb     r2(#%140a),rl0
3EB2: 0000 1E1E      addb    rh0,#%1e
3EB6: 2323           res     @r2,3
3EB8: 282D           incb    @r2,14
3EBA: 3237 3C37      ldb     r3(#%3c37),rh7
3EBE: 3228 140A      ldb     r2(#%140a),rl0
3EC2: 0000 6E64      addb    rh0,#%64
3EC6: 6E64 786E      ldb     %786e(r6),rh4
3ECA: 8278           subb    rl0,rh7
3ECC: 8080           addb    rh0,rl0
3ECE: 8080           addb    rh0,rl0
3ED0: 8080           addb    rh0,rl0
3ED2: 8181           add     r1,r8
3ED4: 8181           add     r1,r8
3ED6: 8181           add     r1,r8
3ED8: 8282           subb    rh2,rl0
3EDA: 8282           subb    rh2,rl0
3EDC: B382           rl      r8,2
3EDE: B382           rl      r8,2
3EE0: C382           ldb     rh3,#%82
3EE2: C382           ldb     rh3,#%82
3EE4: C3C3           ldb     rh3,#%c3
3EE6: D3D3           calr    %3742
3EE8: D3D3           calr    %3744
3EEA: E3E3           jr      ule,%3eb2
3EEC: E3E3           jr      ule,%3eb4
3EEE: D4D4           calr    %3548
3EF0: D4D4           calr    %354a
3EF2: E4E4           jr      pe/ov,%3ebc
3EF4: E4E4           jr      pe/ov,%3ebe
3EF6: F4F4           djnz    r4,%3e10
3EF8: F4F4           djnz    r4,%3e12
3EFA: E5E5           jr      mi,%3ec6
3EFC: E5E5           jr      mi,%3ec8
3EFE: E5E5           jr      mi,%3eca
3F00: F5F5           djnz    r5,%3e18
3F02: F5F5           djnz    r5,%3e1a
3F04: F5F5           djnz    r5,%3e1c
3F06: E6E6           jr      eq/z,%3ed4
3F08: E6E6           jr      eq/z,%3ed6
3F0A: E6E6           jr      eq/z,%3ed8
3F0C: F6F6           djnz    r6,%3e22
3F0E: F6F6           djnz    r6,%3e24
3F10: F6F6           djnz    r6,%3e26
3F12: E7E7           jr      c/ult,%3ee2
3F14: E7E7           jr      c/ult,%3ee4
3F16: E7E7           jr      c/ult,%3ee6
3F18: F7F7           djnz    r7,%3e2c
3F1A: F7F7           djnz    r7,%3e2e
3F1C: F7F7           djnz    r7,%3e30
3F1E: F7F7           djnz    r7,%3e32
3F20: F7F7           djnz    r7,%3e34
3F22: F7F7           djnz    r7,%3e36
3F24: 0000 0000      addb    rh0,#%00
3F28: 0000 0000      addb    rh0,#%00
3F2C: 0000 0000      addb    rh0,#%00
3F30: 0000 0000      addb    rh0,#%00
3F34: 0000 0000      addb    rh0,#%00
3F38: 0000 0000      addb    rh0,#%00
3F3C: 0000 0000      addb    rh0,#%00
3F40: 0000 0000      addb    rh0,#%00
3F44: 0000 0000      addb    rh0,#%00
3F48: 0000 0000      addb    rh0,#%00
3F4C: 0000 FFFF      addb    rh0,#%ff
3F50: FFFF           djnz    r15,%3e54
3F52: FFFF           djnz    r15,%3e56
3F54: FFFF           djnz    r15,%3e58
3F56: FFFF           djnz    r15,%3e5a
3F58: FFFF           djnz    r15,%3e5c
3F5A: FFFF           djnz    r15,%3e5e
3F5C: FFFF           djnz    r15,%3e60
3F5E: FFFF           djnz    r15,%3e62
3F60: FFFF           djnz    r15,%3e64
3F62: FFFF           djnz    r15,%3e66
3F64: FFFF           djnz    r15,%3e68
3F66: FFFF           djnz    r15,%3e6a
3F68: FFFF           djnz    r15,%3e6c
3F6A: FFFF           djnz    r15,%3e6e
3F6C: FFFF           djnz    r15,%3e70
3F6E: FFFF           djnz    r15,%3e72
3F70: FFFF           djnz    r15,%3e74
3F72: FFFF           djnz    r15,%3e76
3F74: FFFF           djnz    r15,%3e78
3F76: FFFF           djnz    r15,%3e7a
3F78: FFFF           djnz    r15,%3e7c
3F7A: FFFF           djnz    r15,%3e7e
3F7C: FFFF           djnz    r15,%3e80
3F7E: FFFF           djnz    r15,%3e82
3F80: FFFF           djnz    r15,%3e84
3F82: FFFF           djnz    r15,%3e86
3F84: FFFF           djnz    r15,%3e88
3F86: FFFF           djnz    r15,%3e8a
3F88: FFFF           djnz    r15,%3e8c
3F8A: FFFF           djnz    r15,%3e8e
3F8C: FFFF           djnz    r15,%3e90
3F8E: FFFF           djnz    r15,%3e92
3F90: FFFF           djnz    r15,%3e94
3F92: FFFF           djnz    r15,%3e96
3F94: FFFF           djnz    r15,%3e98
3F96: FFFF           djnz    r15,%3e9a
3F98: FFFF           djnz    r15,%3e9c
3F9A: FFFF           djnz    r15,%3e9e
3F9C: FFFF           djnz    r15,%3ea0
3F9E: FFFF           djnz    r15,%3ea2
3FA0: FFFF           djnz    r15,%3ea4
3FA2: FFFF           djnz    r15,%3ea6
3FA4: FFFF           djnz    r15,%3ea8
3FA6: FFFF           djnz    r15,%3eaa
3FA8: FFFF           djnz    r15,%3eac
3FAA: FFFF           djnz    r15,%3eae
3FAC: FFFF           djnz    r15,%3eb0
3FAE: FFFF           djnz    r15,%3eb2
3FB0: FFFF           djnz    r15,%3eb4
3FB2: FFFF           djnz    r15,%3eb6
3FB4: FFFF           djnz    r15,%3eb8
3FB6: FFFF           djnz    r15,%3eba
3FB8: FFFF           djnz    r15,%3ebc
3FBA: FFFF           djnz    r15,%3ebe
3FBC: FFFF           djnz    r15,%3ec0
3FBE: FFFF           djnz    r15,%3ec2
3FC0: FFFF           djnz    r15,%3ec4
3FC2: FFFF           djnz    r15,%3ec6
3FC4: FFFF           djnz    r15,%3ec8
3FC6: FFFF           djnz    r15,%3eca
3FC8: FFFF           djnz    r15,%3ecc
3FCA: FFFF           djnz    r15,%3ece
3FCC: FFFF           djnz    r15,%3ed0
3FCE: FFFF           djnz    r15,%3ed2
3FD0: FFFF           djnz    r15,%3ed4
3FD2: FFFF           djnz    r15,%3ed6
3FD4: FFFF           djnz    r15,%3ed8
3FD6: FFFF           djnz    r15,%3eda
3FD8: FFFF           djnz    r15,%3edc
3FDA: FFFF           djnz    r15,%3ede
3FDC: FFFF           djnz    r15,%3ee0
3FDE: FFFF           djnz    r15,%3ee2
3FE0: FFFF           djnz    r15,%3ee4
3FE2: FFFF           djnz    r15,%3ee6
3FE4: FFFF           djnz    r15,%3ee8
3FE6: FFFF           djnz    r15,%3eea
3FE8: FFFF           djnz    r15,%3eec
3FEA: FFFF           djnz    r15,%3eee
3FEC: FFFF           djnz    r15,%3ef0
3FEE: FFFF           djnz    r15,%3ef2
3FF0: FFFF           djnz    r15,%3ef4
3FF2: FFFF           djnz    r15,%3ef6
3FF4: FFFF           djnz    r15,%3ef8
3FF6: FFFF           djnz    r15,%3efa
3FF8: FFFF           djnz    r15,%3efc
3FFA: FFFF           djnz    r15,%3efe
3FFC: FFFF           djnz    r15,%3f00
3FFE: 310D 0000      ldr     r13,%4002
