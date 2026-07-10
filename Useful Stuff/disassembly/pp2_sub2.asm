0000: 0000           .word   #%0000 ;RST
0002: 4000           .word   #%4000 ;RST FCW
0004: 3060           .word   #%3060 ;RST PC
0006: 2100 210F      ld      r0,#%210f
000A: 8F00           ext8f   #%00
000C: 2100 0100      ld      r0,#%0100
0010: 7D0D           ldctl   psapoff,r0
0012: 8D08           clr     r0
0014: 7D0B           ldctl   refresh,r0
0016: 4D08 6002      clr     %6002
001A: 4D05 6002 0001 ld      %6002,#%0001
0020: 7C06           ei      nvi
0022: 4D08 8010      clr     %8010
0026: 4D05 8840 0005 ld      %8840,#%0005
002C: 4D05 80E2 0005 ld      %80e2,#%0005
0032: 4D05 889E 0096 ld      %889e,#%0096
0038: DF5D           calr    %0180
003A: DF53           calr    %0196
003C: 4D04 883A      test    %883a
0040: EE02           jr      ne/nz,%0046
0042: DF1E           calr    %0208
0044: DED4           calr    %029e
0046: DE46           calr    %03bc
0048: DE76           calr    %035e
004A: E8F8           jr      %003c
004C: 2100 6100      ld      r0,#%6100
0050: 8898           xorb    rl0,rl1
0052: 8100           add     r0,r0
0054: 8100           add     r0,r0
0056: 4100 8898      add     r0,%8898
005A: A900           inc     r0,1
005C: 4100 8820      add     r0,%8820
0060: 6F00 8898      ld      %8898,r0
0064: 9E08           ret     
0066: 4D08 4D08      clr     %4d08
006A: 6002 4D08      ldb     rh2,%4d08
006E: 82BE           subb    rl6,rl3
0070: 030F 001E      sub     r15,#%001e
0074: 1CF9 000E      ldm     @r15,r0,#15
0078: 4D01 8010 8001 cp      %8010,#%8001
007E: E61A           jr      eq/z,%00b4
0080: DB32           calr    %0a1e
0082: 5F00 1DCC      call    %1dcc
0086: 5F00 1DFC      call    %1dfc
008A: DBA0           calr    %094c
008C: DBAE           calr    %0932
008E: DBC3           calr    %090a
0090: 5F00 1FAC      call    %1fac
0094: 5F00 2094      call    %2094
0098: 5F00 21D8      call    %21d8
009C: 5F00 1D34      call    %1d34
00A0: 5F00 2342      call    %2342
00A4: 5F00 24A6      call    %24a6
00A8: 5F00 262C      call    %262c
00AC: 5F00 1CFA      call    %1cfa
00B0: 6900 8820      inc     %8820,1
00B4: 1CF1 000E      ldm     r0,@r15,#15
00B8: 010F 001E      add     r15,#%001e
00BC: 4D05 6002 0001 ld      %6002,#%0001
00C2: 7B00           iret
00C4: FFFF           djnz    r15,%ffffffc8
00C6: FFFF           djnz    r15,%ffffffca
00C8: FFFF           djnz    r15,%ffffffcc
00CA: FFFF           djnz    r15,%ffffffce
00CC: FFFF           djnz    r15,%ffffffd0
00CE: FFFF           djnz    r15,%ffffffd2
00D0: FFFF           djnz    r15,%ffffffd4
00D2: FFFF           djnz    r15,%ffffffd6
00D4: FFFF           djnz    r15,%ffffffd8
00D6: FFFF           djnz    r15,%ffffffda
00D8: FFFF           djnz    r15,%ffffffdc
00DA: FFFF           djnz    r15,%ffffffde
00DC: FFFF           djnz    r15,%ffffffe0
00DE: FFFF           djnz    r15,%ffffffe2
00E0: FFFF           djnz    r15,%ffffffe4
00E2: FFFF           djnz    r15,%ffffffe6
00E4: FFFF           djnz    r15,%ffffffe8
00E6: FFFF           djnz    r15,%ffffffea
00E8: FFFF           djnz    r15,%ffffffec
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
0104: 4000 0008      addb    rh0,%0008
0108: 4000 0008      addb    rh0,%0008
010C: 4000 0008      addb    rh0,%0008
0110: 0000 0000      addb    rh0,#%00
0114: 4000 0008      addb    rh0,%0008
0118: 4000 0068      addb    rh0,%0068
011C: 93F0           push    @r15,r0
011E: 93F1           push    @r15,r1
0120: 6101 8100      ld      r1,%8100
0124: 0701 0003      and     r1,#%0003
0128: 8111           add     r1,r1
012A: 8111           add     r1,r1
012C: 6110 0142      ld      r0,%0142(r1)
0130: 6111 0140      ld      r1,%0140(r1)
0134: 0B10           cp      r0,@r1
0136: E601           jr      eq/z,%013a
0138: 7D1D           ldctl   psapoff,r1
013A: 97F1           pop     r1,@r15
013C: 97F0           pop     r0,@r15
013E: 9E08           ret     
0140: 42B0 182B      subb    rh0,%182b(r11)
0144: 42BC 2417      subb    rl4,%2417(r11)
0148: 42BE 0A16      subb    rl6,%0a16(r11)
014C: 42C0 0C18      subb    rh0,%0c18(r12)
0150: 0150           add     r0,@r5
0152: 1234           subl    rr4,@r3
0154: 0154           add     r4,@r5
0156: 1234           subl    rr4,@r3
0158: 0158           add     r8,@r5
015A: 1234           subl    rr4,@r3
015C: 015C           add     r12,@r5
015E: 1234           subl    rr4,@r3
0160: 0160           add     r0,@r6
0162: 1234           subl    rr4,@r3
0164: 0164           add     r4,@r6
0166: 1234           subl    rr4,@r3
0168: 0168           add     r8,@r6
016A: 1234           subl    rr4,@r3
016C: 016C           add     r12,@r6
016E: 1234           subl    rr4,@r3
0170: 0170           add     r0,@r7
0172: 1234           subl    rr4,@r3
0174: 0174           add     r4,@r7
0176: 1234           subl    rr4,@r3
0178: 0178           add     r8,@r7
017A: 1234           subl    rr4,@r3
017C: 017C           add     r12,@r7
017E: 1234           subl    rr4,@r3
0180: D033           calr    %011c
0182: 2100 0124      ld      r0,#%0124
0186: 210A 0400      ld      r10,#%0400
018A: 210B 9800      ld      r11,#%9800
018E: 2FB0           ld      @r11,r0
0190: A9B1           inc     r11,2
0192: FA83           djnz    r10,%018e
0194: 9E08           ret     
0196: 2101 8700      ld      r1,#%8700
019A: 2102 8F00      ld      r2,#%8f00
019E: 2100 0080      ld      r0,#%0080
01A2: 0D18           clr     @r1
01A4: 0D28           clr     @r2
01A6: A911           inc     r1,2
01A8: A921           inc     r2,2
01AA: F085           djnz    r0,%01a2
01AC: 4D08 89F8      clr     %89f8
01B0: 210A 0007      ld      r10,#%0007
01B4: 210B 8B00      ld      r11,#%8b00
01B8: 0DB5 8002      ld      @r11,#%8002
01BC: 61B0 0006      ld      r0,%0006(r11)
01C0: B301 0005      sll     r0,#5
01C4: B309 FFFB      sra     r0,#5
01C8: 6FB0 0006      ld      %0006(r11),r0
01CC: 010B 0020      add     r11,#%0020
01D0: FA8D           djnz    r10,%01b8
01D2: 210A 0006      ld      r10,#%0006
01D6: 0DB8           clr     @r11
01D8: 010B 0020      add     r11,#%0020
01DC: FA84           djnz    r10,%01d6
01DE: 2101 AA00      ld      r1,#%aa00
01E2: 2100 0042      ld      r0,#%0042
01E6: 0D15 FFFF      ld      @r1,#%ffff
01EA: A911           inc     r1,2
01EC: F084           djnz    r0,%01e6
01EE: 4D08 81B0      clr     %81b0
01F2: 4D08 883C      clr     %883c
01F6: 2102 9F8E      ld      r2,#%9f8e
01FA: 2101 0008      ld      r1,#%0008
01FE: 0D28           clr     @r2
0200: 0102 0010      add     r2,#%0010
0204: F184           djnz    r1,%01fe
0206: 9E08           ret     
0208: 6101 8180      ld      r1,%8180
020C: 0301 0040      sub     r1,#%0040
0210: B311 FFFD      srl     r1,#3
0214: 6100 801C      ld      r0,%801c
0218: 0700 0003      and     r0,#%0003
021C: A081           ldb     rh1,rl0
021E: 2100 0008      ld      r0,#%0008
0222: DFEE           calr    %0248
0224: 0009 2A2A      addb    rl1,#%2a
0228: 2100 0008      ld      r0,#%0008
022C: E80D           jr      %0248
022E: 6101 8180      ld      r1,%8180
0232: 0301 0040      sub     r1,#%0040
0236: B311 FFFD      srl     r1,#3
023A: 6100 801C      ld      r0,%801c
023E: 0700 0003      and     r0,#%0003
0242: A081           ldb     rh1,rl0
0244: 2100 003C      ld      r0,#%003c
0248: 601A 5000      ldb     rl2,%5000(r1)
024C: 8C28           clrb    rh2
024E: 602B 5400      ldb     rl3,%5400(r2)
0252: 8C38           clrb    rh3
0254: 602C 5401      ldb     rl4,%5401(r2)
0258: 8C48           clrb    rh4
025A: 8132           add     r2,r3
025C: 8122           add     r2,r2
025E: 0102 5502      add     r2,#%5502
0262: 8334           sub     r4,r3
0264: A940           inc     r4,1
0266: A115           ld      r5,r1
0268: 0705 003F      and     r5,#%003f
026C: B351 0005      sll     r5,#5
0270: 0105 A01E      add     r5,#%a01e
0274: 2123           ld      r3,@r2
0276: 2F53           ld      @r5,r3
0278: A921           inc     r2,2
027A: AB51           dec     r5,2
027C: F485           djnz    r4,%0274
027E: A154           ld      r4,r5
0280: 0704 001F      and     r4,#%001f
0284: A142           ld      r2,r4
0286: 0102 587C      add     r2,#%587c
028A: B341 FFFF      srl     r4,#1
028E: 2123           ld      r3,@r2
0290: 2F53           ld      @r5,r3
0292: AB51           dec     r5,2
0294: AB21           dec     r2,2
0296: F485           djnz    r4,%028e
0298: A890           incb    rl1,1
029A: F0AA           djnz    r0,%0248
029C: 9E08           ret     
029E: 210B 589C      ld      r11,#%589c
02A2: 6101 8180      ld      r1,%8180
02A6: 0301 0040      sub     r1,#%0040
02AA: B311 FFFD      srl     r1,#3
02AE: 20BB           ldb     rl3,@r11
02B0: A0BD           ldb     rl5,rl3
02B2: A9B0           inc     r11,1
02B4: 829B           subb    rl3,rl1
02B6: 020B 0606      subb    rl3,#%06
02BA: 0A0B 0606      cpb     rl3,#%06
02BE: E705           jr      c/ult,%02ca
02C0: 020B 2020      subb    rl3,#%20
02C4: 0A0B 0606      cpb     rl3,#%06
02C8: EF0A           jr      nc/uge,%02de
02CA: 0705 003F      and     r5,#%003f
02CE: B351 0005      sll     r5,#5
02D2: 0505 A000      or      r5,#%a000
02D6: DFD4           calr    %0330
02D8: 0CB4           testb   @r11
02DA: EEE9           jr      ne/nz,%02ae
02DC: 9E08           ret     
02DE: A9B0           inc     r11,1
02E0: 20B8           ldb     rl0,@r11
02E2: A9B0           inc     r11,1
02E4: 8C84           testb   rl0
02E6: EEFC           jr      ne/nz,%02e0
02E8: 0CB4           testb   @r11
02EA: EEE1           jr      ne/nz,%02ae
02EC: 9E08           ret     
02EE: 210B 589C      ld      r11,#%589c
02F2: 6101 8180      ld      r1,%8180
02F6: 0301 0040      sub     r1,#%0040
02FA: B311 FFFD      srl     r1,#3
02FE: 20BB           ldb     rl3,@r11
0300: A0BD           ldb     rl5,rl3
0302: A9B0           inc     r11,1
0304: 829B           subb    rl3,rl1
0306: 0A0B 3030      cpb     rl3,#%30
030A: EF0A           jr      nc/uge,%0320
030C: 0705 003F      and     r5,#%003f
0310: B351 0005      sll     r5,#5
0314: 0505 A000      or      r5,#%a000
0318: DFF5           calr    %0330
031A: 0CB4           testb   @r11
031C: EEF0           jr      ne/nz,%02fe
031E: 9E08           ret     
0320: A9B0           inc     r11,1
0322: 20B8           ldb     rl0,@r11
0324: A9B0           inc     r11,1
0326: 8C84           testb   rl0
0328: EEFC           jr      ne/nz,%0322
032A: 0CB4           testb   @r11
032C: EEE8           jr      ne/nz,%02fe
032E: 9E08           ret     
0330: 20B0           ldb     rh0,@r11
0332: A9B0           inc     r11,1
0334: 20B8           ldb     rl0,@r11
0336: A9B0           inc     r11,1
0338: A687           bitb    rl0,7
033A: E603           jr      eq/z,%0342
033C: 2F50           ld      @r5,r0
033E: A951           inc     r5,2
0340: E8F9           jr      %0334
0342: 8C84           testb   rl0
0344: 9E06           ret     eq/z
0346: A08E           ldb     rl6,rl0
0348: 8C68           clrb    rh6
034A: 060E 1F1F      andb    rl6,#%1f
034E: 8166           add     r6,r6
0350: 8165           add     r5,r6
0352: E8F0           jr      %0334
0354: 2105 0200      ld      r5,#%0200
0358: 2104 FE00      ld      r4,#%fe00
035C: E806           jr      %036a
035E: 2105 0020      ld      r5,#%0020
0362: 6104 8184      ld      r4,%8184
0366: 0104 0F00      add     r4,#%0f00
036A: 6100 801C      ld      r0,%801c
036E: 0700 0003      and     r0,#%0003
0372: B301 0003      sll     r0,#3
0376: A143           ld      r3,r4
0378: B331 FFFE      srl     r3,#2
037C: 0703 03FE      and     r3,#%03fe
0380: A142           ld      r2,r4
0382: 0302 0020      sub     r2,#%0020
0386: 0B02 0020      cp      r2,#%0020
038A: E70D           jr      c/ult,%03a6
038C: A131           ld      r1,r3
038E: B311 FFFD      srl     r1,#3
0392: 0701 0007      and     r1,#%0007
0396: 8101           add     r1,r0
0398: 6019 5BE0      ldb     rl1,%5be0(r1)
039C: 6F31 9000      ld      %9000(r3),r1
03A0: A947           inc     r4,8
03A2: F597           djnz    r5,%0376
03A4: 9E08           ret     
03A6: A131           ld      r1,r3
03A8: B311 0001      sll     r1,#1
03AC: 0701 0007      and     r1,#%0007
03B0: 8101           add     r1,r0
03B2: B311 FFFE      srl     r1,#2
03B6: 6019 5C00      ldb     rl1,%5c00(r1)
03BA: E8F0           jr      %039c
03BC: 610E 883C      ld      r14,%883c
03C0: 070E 007E      and     r14,#%007e
03C4: 61E1 AA00      ld      r1,%aa00(r14)
03C8: 0B01 FFFF      cp      r1,#%ffff
03CC: 9E06           ret     eq/z
03CE: 4DE5 AA00 FFFF ld      %aa00(r14),#%ffff
03D4: A9E1           inc     r14,2
03D6: 070E 007E      and     r14,#%007e
03DA: 6F0E 883C      ld      %883c,r14
03DE: 0B01 001D      cp      r1,#%001d
03E2: 9E0F           ret     nc/uge
03E4: A110           ld      r0,r1
03E6: 8111           add     r1,r1
03E8: 6111 03EE      ld      r1,%03ee(r1)
03EC: 1E18           jp      @rr1
03EE: 0180           add     r0,@r8
03F0: 05FA           or      r10,@r15
03F2: 06E8           andb    rl0,@r14
03F4: 0720           and     r0,@r2
03F6: 06E8           andb    rl0,@r14
03F8: 0772           and     r2,@r7
03FA: 4352 4352      sub     r2,%4352(r5)
03FE: 0442           orb     rh2,@r4
0400: 0448           orb     rl0,@r4
0402: 046A           orb     rl2,@r6
0404: 056C           or      r12,@r6
0406: 056C           or      r12,@r6
0408: 056C           or      r12,@r6
040A: 056C           or      r12,@r6
040C: 056C           or      r12,@r6
040E: 088E           xorb    rl6,@r8
0410: 08D2           xorb    rh2,@r13
0412: 43BE 43DE      sub     r14,%43de(r11)
0416: 4432 43F8      orb     rh2,%43f8(r3)
041A: 08DA           xorb    rl2,@r13
041C: 4594 0594      or      r4,%0594(r9)
0420: 05F0           or      r0,@r15
0422: 057A           or      r10,@r7
0424: 056E           or      r14,@r6
0426: 0566           or      r6,@r6
0428: 056C           or      r12,@r6
042A: 056C           or      r12,@r6
042C: 056C           or      r12,@r6
042E: D18A           calr    %011c
0430: 2100 0124      ld      r0,#%0124
0434: 210A 0200      ld      r10,#%0200
0438: 210B 9B04      ld      r11,#%9b04
043C: 2FB0           ld      @r11,r0
043E: A9B1           inc     r11,2
0440: FA83           djnz    r10,%043c
0442: D10B           calr    %022e
0444: D0AC           calr    %02ee
0446: 9E08           ret     
0448: 210B 9988      ld      r11,#%9988
044C: 210A 0460      ld      r10,#%0460
0450: C108           ldb     rh1,#%08
0452: 20A9           ldb     rl1,@r10
0454: A717           bit     r1,7
0456: 9E0E           ret     ne/nz
0458: 2FB1           ld      @r11,r1
045A: A9A0           inc     r10,1
045C: A9B1           inc     r11,2
045E: E8F9           jr      %0452
0460: 2B24           dec     @r2,5
0462: 170A           .word   #%170a
0464: 160C 1824 FFFF addl    rr12,#%1824ffff
046A: 210C 99C2      ld      r12,#%99c2
046E: 5F00 4128      call    %4128
0472: 0054           addb    rh4,@r5
0474: 4849 5320      xorb    rl1,%5320(r4)
0478: 4741 4D45      and     r1,%4d45(r4)
047C: 2049           ldb     rl1,@r4
047E: 5320 4D41      push    @r2,%4d41
0482: 4445 2042      orb     rh5,%2042(r4)
0486: 5940 210C      mult    rr0,%210c(r4)
048A: 9A48           divl    rq8,rr4
048C: 5F00 4128      call    %4128
0490: 0046           addb    rh6,@r4
0492: 4F4C           .word   #%4f4c
0494: 4C4F           .word   #%4c4f
0496: 5749 4E47      pop     %4e47(r9),@r4
049A: 204D           ldb     rl5,@r4
049C: 454D 4245      or      r13,%4245(r4)
04A0: 5253 402C      subl    rr3,%402c(r5)
04A4: 210C 9B04      ld      r12,#%9b04
04A8: 5F00 4128      call    %4128
04AC: 0050           addb    rh0,@r5
04AE: 4342 2041      sub     r2,%2041(r4)
04B2: 4E44           .word   #%4e44
04B4: 2050           ldb     rh0,@r5
04B6: 524F 4752      subl    rr15,%4752(r4)
04BA: 414D 2020      add     r13,%2020(r4)
04BE: 2020           ldb     rh0,@r2
04C0: 204B           ldb     rl3,@r4
04C2: 2E54           ldb     @r5,rh4
04C4: 4153 4849      add     r3,%4849(r5)
04C8: 524F 4000      subl    rr15,%4000(r4)
04CC: 210C 9B84      ld      r12,#%9b84
04D0: 5F00 4128      call    %4128
04D4: 0047           addb    rh7,@r4
04D6: 414D 4520      add     r13,%4520(r4)
04DA: 5741 5920      pop     %5920(r1),@r4
04DE: 2020           ldb     rh0,@r2
04E0: 2020           ldb     rh0,@r2
04E2: 2020           ldb     rh0,@r2
04E4: 2020           ldb     rh0,@r2
04E6: 2020           ldb     rh0,@r2
04E8: 2053           ldb     rh3,@r5
04EA: 2E4F           ldb     @r4,rl7
04EC: 4B41 4D4F      cp      r1,%4d4f(r4)
04F0: 544F 4000      ldl     rr15,%4000(r4)
04F4: 210C 9C04      ld      r12,#%9c04
04F8: 5F00 4128      call    %4128
04FC: 0053           addb    rh3,@r5
04FE: 4F55           .word   #%4f55
0500: 4E44           .word   #%4e44
0502: 2041           ldb     rh1,@r4
0504: 4E44           .word   #%4e44
0506: 204D           ldb     rl5,@r4
0508: 5553 4943      popl    %4943(r3),@r5
050C: 2020           ldb     rh0,@r2
050E: 2020           ldb     rh0,@r2
0510: 204E           ldb     rl6,@r4
0512: 2E4F           ldb     @r4,rl7
0514: 484E 4F47      xorb    rl6,%4f47(r4)
0518: 4940 210C      xor     r0,%210c(r4)
051C: 9C84           .word   #%9c84
051E: 5F00 4128      call    %4128
0522: 0054           addb    rh4,@r5
0524: 4553 5420      or      r3,%5420(r5)
0528: 5052 4F47      cpl     rr2,%4f47(r5)
052C: 5241 4D20      subl    rr1,%4d20(r4)
0530: 2020           ldb     rh0,@r2
0532: 2020           ldb     rh0,@r2
0534: 2020           ldb     rh0,@r2
0536: 204B           ldb     rl3,@r4
0538: 2E43           ldb     @r4,rh3
053A: 524F 5353      subl    rr15,%5353(r4)
053E: 40B0 210C      addb    rh0,%210c(r11)
0542: 9D04           rsvd9d
0544: 5F00 4128      call    %4128
0548: 0043           addb    rh3,@r4
054A: 5553 544F      popl    %544f(r3),@r5
054E: 4D20 4943      com     %4943(r2)
0552: 2020           ldb     rh0,@r2
0554: 2020           ldb     rh0,@r2
0556: 2020           ldb     rh0,@r2
0558: 2020           ldb     rh0,@r2
055A: 2020           ldb     rh0,@r2
055C: 2053           ldb     rh3,@r5
055E: 2E53           ldb     @r5,rh3
0560: 4154 4F40      add     r4,%4f40(r5)
0564: 9E08           ret     
0566: 4D05 8C00 000A ld      %8c00,#%000a
056C: 9E08           ret     
056E: 210B 8C00      ld      r11,#%8c00
0572: 4DB5 000C 0001 ld      %000c(r11),#%0001
0578: 9E08           ret     
057A: 210B 8C00      ld      r11,#%8c00
057E: 0DB5 800A      ld      @r11,#%800a
0582: 4DB5 0002 000C ld      %0002(r11),#%000c
0588: 4DB5 0006 05C0 ld      %0006(r11),#%05c0
058E: 4DB8 000C      clr     %000c(r11)
0592: 9E08           ret     
0594: DEF9           calr    %07a4
0596: 210B 8B00      ld      r11,#%8b00
059A: 210A 0007      ld      r10,#%0007
059E: 0DB5 0002      ld      @r11,#%0002
05A2: 010B 0020      add     r11,#%0020
05A6: FA85           djnz    r10,%059e
05A8: 4D05 8188 FE00 ld      %8188,#%fe00
05AE: 8D08           clr     r0
05B0: A101           ld      r1,r0
05B2: 5D00 8180      ldl     %8180,rr0
05B6: 6F00 C000      ld      %c000,r0
05BA: 4D05 8184 FF00 ld      %8184,#%ff00
05C0: 4D05 C100 FF00 ld      %c100,#%ff00
05C6: 4D08 818C      clr     %818c
05CA: 4D08 81A0      clr     %81a0
05CE: 6100 800C      ld      r0,%800c
05D2: 6F00 819C      ld      %819c,r0
05D6: 4D05 8C60 0001 ld      %8c60,#%0001
05DC: 4D05 8C68 0010 ld      %8c68,#%0010
05E2: D1DB           calr    %022e
05E4: D17C           calr    %02ee
05E6: D14A           calr    %0354
05E8: D235           calr    %0180
05EA: 5F00 4352      call    %4352
05EE: 9E08           ret     
05F0: D1E2           calr    %022e
05F2: D183           calr    %02ee
05F4: D151           calr    %0354
05F6: DF32           calr    %0794
05F8: 9E08           ret     
05FA: D1E7           calr    %022e
05FC: D188           calr    %02ee
05FE: D156           calr    %0354
0600: 5F00 4352      call    %4352
0604: DF12           calr    %07e2
0606: D209           calr    %01f6
0608: 210B 8B00      ld      r11,#%8b00
060C: 210A 0007      ld      r10,#%0007
0610: 0DB5 0002      ld      @r11,#%0002
0614: 010B 0020      add     r11,#%0020
0618: FA85           djnz    r10,%0610
061A: D000           calr    %061c
061C: 210B 8B00      ld      r11,#%8b00
0620: 2101 0000      ld      r1,#%0000
0624: 6100 81FA      ld      r0,%81fa
0628: 6102 801C      ld      r2,%801c
062C: 0702 0003      and     r2,#%0003
0630: 0B02 0001      cp      r2,#%0001
0634: EE02           jr      ne/nz,%063a
0636: 0900 0001      xor     r0,#%0001
063A: 0700 0007      and     r0,#%0007
063E: E608           jr      eq/z,%0650
0640: DFCA           calr    %06ae
0642: AB00           dec     r0,1
0644: E638           jr      eq/z,%06b6
0646: DFE6           calr    %067c
0648: 0301 0080      sub     r1,#%0080
064C: AB00           dec     r0,1
064E: E8F7           jr      %063e
0650: 4D05 8188 2600 ld      %8188,#%2600
0656: A110           ld      r0,r1
0658: 0300 0012      sub     r0,#%0012
065C: 6F00 8184      ld      %8184,r0
0660: 4D08 818C      clr     %818c
0664: 4D08 81A0      clr     %81a0
0668: 6100 800C      ld      r0,%800c
066C: 6F00 819C      ld      %819c,r0
0670: 4D05 8C60 8001 ld      %8c60,#%8001
0676: 4D05 8C68 0010 ld      %8c68,#%0010
067C: 4DB5 0006 0240 ld      %0006(r11),#%0240
0682: 4DB5 000E 0000 ld      %000e(r11),#%0000
0688: 4DB5 0010 0000 ld      %0010(r11),#%0000
068E: 6FB1 0002      ld      %0002(r11),r1
0692: 4DB5 0012 0000 ld      %0012(r11),#%0000
0698: 4DB5 001C 0000 ld      %001c(r11),#%0000
069E: 4DB5 001A 0000 ld      %001a(r11),#%0000
06A4: 0DB5 8002      ld      @r11,#%8002
06A8: 010B 0020      add     r11,#%0020
06AC: 9E08           ret     
06AE: 4DB5 0006 FD00 ld      %0006(r11),#%fd00
06B4: E8E6           jr      %0682
06B6: 4D05 8188 E200 ld      %8188,#%e200
06BC: A110           ld      r0,r1
06BE: 0300 0012      sub     r0,#%0012
06C2: 6F00 8184      ld      %8184,r0
06C6: 4D05 818C 0000 ld      %818c,#%0000
06CC: 4D05 81A0 0000 ld      %81a0,#%0000
06D2: 6100 800C      ld      r0,%800c
06D6: 6F00 819C      ld      %819c,r0
06DA: 4D05 8C60 8001 ld      %8c60,#%8001
06E0: 4D05 8C68 0010 ld      %8c68,#%0010
06E6: 9E08           ret     
06E8: 210B 8B00      ld      r11,#%8b00
06EC: 210A 0007      ld      r10,#%0007
06F0: 6101 81FA      ld      r1,%81fa
06F4: 0701 0007      and     r1,#%0007
06F8: 1900 0300      mult    rr0,#%0300
06FC: 0101 5400      add     r1,#%5400
0700: 6707 8148      bit     %8148,7
0704: EE02           jr      ne/nz,%070a
0706: 0101 0C00      add     r1,#%0c00
070A: 6FB1 0012      ld      %0012(r11),r1
070E: 0301 0800      sub     r1,#%0800
0712: 010B 0020      add     r11,#%0020
0716: FA87           djnz    r10,%070a
0718: 4D05 889C 000A ld      %889c,#%000a
071E: 9E08           ret     
0720: D27A           calr    %022e
0722: D21B           calr    %02ee
0724: D1E9           calr    %0354
0726: DFB3           calr    %07c2
0728: 210B 8B00      ld      r11,#%8b00
072C: 210A 0007      ld      r10,#%0007
0730: 0DB5 0002      ld      @r11,#%0002
0734: 010B 0020      add     r11,#%0020
0738: FA85           djnz    r10,%0730
073A: DFFC           calr    %0744
073C: D2DF           calr    %0180
073E: 5F00 4352      call    %4352
0742: 9E08           ret     
0744: 4D05 8188 FE00 ld      %8188,#%fe00
074A: 4D05 8184 FF00 ld      %8184,#%ff00
0750: 4D05 818C 0000 ld      %818c,#%0000
0756: 4D05 81A0 0000 ld      %81a0,#%0000
075C: 6100 800C      ld      r0,%800c
0760: 6F00 819C      ld      %819c,r0
0764: 4D05 8C60 8001 ld      %8c60,#%8001
076A: 4D05 8C68 0010 ld      %8c68,#%0010
0770: 9E08           ret     
0772: DFFD           calr    %077a
0774: D2C0           calr    %01f6
0776: 5E08 4278      jp      %4278
077A: D01C           calr    %0744
077C: 210B 8BE0      ld      r11,#%8be0
0780: 0DB5 800B      ld      @r11,#%800b
0784: 4DB5 000C 0000 ld      %000c(r11),#%0000
078A: 4DB5 0002 FEFF ld      %0002(r11),#%feff
0790: 8D38           clr     r3
0792: E836           jr      %0800
0794: 210B 8BE0      ld      r11,#%8be0
0798: 0DB5 8009      ld      @r11,#%8009
079C: 4DB5 000C 0001 ld      %000c(r11),#%0001
07A2: E807           jr      %07b2
07A4: 210B 8BE0      ld      r11,#%8be0
07A8: 0DB5 8009      ld      @r11,#%8009
07AC: 4DB5 000C 0000 ld      %000c(r11),#%0000
07B2: 4DB5 0002 0020 ld      %0002(r11),#%0020
07B8: 4DB5 0006 0100 ld      %0006(r11),#%0100
07BE: 8D38           clr     r3
07C0: E81F           jr      %0800
07C2: 210B 8BE0      ld      r11,#%8be0
07C6: 0DB5 8006      ld      @r11,#%8006
07CA: 4DB5 0002 0020 ld      %0002(r11),#%0020
07D0: 4DB5 0006 0000 ld      %0006(r11),#%0000
07D6: 4DB5 000C 0000 ld      %000c(r11),#%0000
07DC: 8D38           clr     r3
07DE: 8D98           clr     r9
07E0: E80F           jr      %0800
07E2: 210B 8BE0      ld      r11,#%8be0
07E6: 0DB5 8006      ld      @r11,#%8006
07EA: 4DB5 0002 0020 ld      %0002(r11),#%0020
07F0: 4DB8 0006      clr     %0006(r11)
07F4: 4DB8 000C      clr     %000c(r11)
07F8: 2103 0004      ld      r3,#%0004
07FC: 2109 0001      ld      r9,#%0001
0800: 010B 0020      add     r11,#%0020
0804: 210A 0003      ld      r10,#%0003
0808: 6100 801C      ld      r0,%801c
080C: 0700 0003      and     r0,#%0003
0810: A10C           ld      r12,r0
0812: B3C1 0003      sll     r12,#3
0816: 810C           add     r12,r0
0818: 010C 5C08      add     r12,#%5c08
081C: C080           ldb     rh0,#%80
081E: 20C8           ldb     rl0,@r12
0820: A9C0           inc     r12,1
0822: 0A08 0C0C      cpb     rl0,#%0c
0826: E603           jr      eq/z,%082e
0828: 8D94           test    r9
082A: EE01           jr      ne/nz,%082e
082C: 8C08           clrb    rh0
082E: 2FB0           ld      @r11,r0
0830: 20C1           ldb     rh1,@r12
0832: A9C0           inc     r12,1
0834: 20C2           ldb     rh2,@r12
0836: A9C0           inc     r12,1
0838: 8C98           clrb    rl1
083A: 8CA8           clrb    rl2
083C: B329 FFFC      sra     r2,#4
0840: 6FB1 0002      ld      %0002(r11),r1
0844: 6FB2 0006      ld      %0006(r11),r2
0848: 6FB3 000C      ld      %000c(r11),r3
084C: A930           inc     r3,1
084E: 010B 0020      add     r11,#%0020
0852: FA9C           djnz    r10,%081c
0854: 6105 801C      ld      r5,%801c
0858: 0705 0003      and     r5,#%0003
085C: 1904 0030      mult    rr4,#%0030
0860: 0105 5A7E      add     r5,#%5a7e
0864: 2104 8D00      ld      r4,#%8d00
0868: 2106 0018      ld      r6,#%0018
086C: 2151           ld      r1,@r5
086E: 2F41           ld      @r4,r1
0870: B311 FFFE      srl     r1,#2
0874: 0701 0003      and     r1,#%0003
0878: 6011 088A      ldb     rh1,%088a(r1)
087C: 8C98           clrb    rl1
087E: 6F41 0002      ld      %0002(r4),r1
0882: A947           inc     r4,8
0884: AB51           dec     r5,2
0886: F68E           djnz    r6,%086c
0888: 9E08           ret     
088A: F5F5           djnz    r5,%07a2
088C: 0B0C 4D05      cp      r12,#%4d05
0890: 8C80           comb    rl0
0892: 8008           addb    rl0,rh0
0894: 4D05 8C9C 0500 ld      %8c9c,#%0500
089A: 4D05 8C9E 0F00 ld      %8c9e,#%0f00
08A0: 210B 8BE0      ld      r11,#%8be0
08A4: 0DB5 0006      ld      @r11,#%0006
08A8: 010B 0020      add     r11,#%0020
08AC: 210A 0003      ld      r10,#%0003
08B0: 21B1           ld      r1,@r11
08B2: 0701 000F      and     r1,#%000f
08B6: 2FB1           ld      @r11,r1
08B8: 010B 0020      add     r11,#%0020
08BC: FA87           djnz    r10,%08b0
08BE: 4D05 8BE0 800D ld      %8be0,#%800d
08C4: 4D05 8BFC 0700 ld      %8bfc,#%0700
08CA: 4D05 8BFE 1500 ld      %8bfe,#%1500
08D0: 9E08           ret     
08D2: 4D05 8C80 0008 ld      %8c80,#%0008
08D8: 9E08           ret     
08DA: 2101 DA60      ld      r1,#%da60
08DE: 210C 9D0E      ld      r12,#%9d0e
08E2: DFFF           calr    %08e6
08E4: A9C3           inc     r12,4
08E6: 2104 0004      ld      r4,#%0004
08EA: 2FC1           ld      @r12,r1
08EC: A910           inc     r1,1
08EE: A9C1           inc     r12,2
08F0: 2FC1           ld      @r12,r1
08F2: A910           inc     r1,1
08F4: 010C 003E      add     r12,#%003e
08F8: 2FC1           ld      @r12,r1
08FA: A910           inc     r1,1
08FC: A9C1           inc     r12,2
08FE: 2FC1           ld      @r12,r1
0900: A910           inc     r1,1
0902: 030C 003E      sub     r12,#%003e
0906: F48F           djnz    r4,%08ea
0908: 9E08           ret     
090A: 6100 8820      ld      r0,%8820
090E: 0700 0007      and     r0,#%0007
0912: 9E0E           ret     ne/nz
0914: 210B 8C00      ld      r11,#%8c00
0918: 0DB1 800A      cp      @r11,#%800a
091C: 9E0E           ret     ne/nz
091E: 61B1 000C      ld      r1,%000c(r11)
0922: 8D14           test    r1
0924: 9E06           ret     eq/z
0926: 0B01 0029      cp      r1,#%0029
092A: 9E09           ret     ge
092C: 69B0 000C      inc     %000c(r11),1
0930: 9E08           ret     
0932: 210B 8BE0      ld      r11,#%8be0
0936: 0DB1 8009      cp      @r11,#%8009
093A: 9E0E           ret     ne/nz
093C: 6BB1 0006      dec     %0006(r11),2
0940: 6101 8184      ld      r1,%8184
0944: A913           inc     r1,4
0946: 6FB1 0002      ld      %0002(r11),r1
094A: 9E08           ret     
094C: 4D01 8C80 8008 cp      %8c80,#%8008
0952: 9E0E           ret     ne/nz
0954: 6101 8C9C      ld      r1,%8c9c
0958: 0301 0008      sub     r1,#%0008
095C: 0B01 0000      cp      r1,#%0000
0960: E106           jr      lt,%096e
0962: 0B01 1000      cp      r1,#%1000
0966: E205           jr      le,%0972
0968: 2101 1000      ld      r1,#%1000
096C: E802           jr      %0972
096E: 2101 0000      ld      r1,#%0000
0972: 6F01 8C9C      ld      %8c9c,r1
0976: 4101 8184      add     r1,%8184
097A: A913           inc     r1,4
097C: 6F01 8C82      ld      %8c82,r1
0980: 6101 8C9E      ld      r1,%8c9e
0984: 8D14           test    r1
0986: E612           jr      eq/z,%09ac
0988: A110           ld      r0,r1
098A: B301 FFFA      srl     r0,#6
098E: A900           inc     r0,1
0990: 8301           sub     r1,r0
0992: 0B01 0000      cp      r1,#%0000
0996: E106           jr      lt,%09a4
0998: 0B01 1000      cp      r1,#%1000
099C: E205           jr      le,%09a8
099E: 2101 1000      ld      r1,#%1000
09A2: E802           jr      %09a8
09A4: 2101 0000      ld      r1,#%0000
09A8: 6F01 8C9E      ld      %8c9e,r1
09AC: B311 FFFD      srl     r1,#3
09B0: 6F01 8C8C      ld      %8c8c,r1
09B4: 4D01 8BE0 800D cp      %8be0,#%800d
09BA: 9E0E           ret     ne/nz
09BC: 6101 8BFC      ld      r1,%8bfc
09C0: 0301 0008      sub     r1,#%0008
09C4: 0B01 0000      cp      r1,#%0000
09C8: E106           jr      lt,%09d6
09CA: 0B01 1000      cp      r1,#%1000
09CE: E205           jr      le,%09da
09D0: 2101 1000      ld      r1,#%1000
09D4: E802           jr      %09da
09D6: 2101 0000      ld      r1,#%0000
09DA: 6F01 8BFC      ld      %8bfc,r1
09DE: 4101 8184      add     r1,%8184
09E2: A913           inc     r1,4
09E4: 6F01 8BE2      ld      %8be2,r1
09E8: 6101 8BFE      ld      r1,%8bfe
09EC: 8D14           test    r1
09EE: E612           jr      eq/z,%0a14
09F0: A110           ld      r0,r1
09F2: B301 FFFA      srl     r0,#6
09F6: A900           inc     r0,1
09F8: 8301           sub     r1,r0
09FA: 0B01 0000      cp      r1,#%0000
09FE: E106           jr      lt,%0a0c
0A00: 0B01 1000      cp      r1,#%1000
0A04: E205           jr      le,%0a10
0A06: 2101 1000      ld      r1,#%1000
0A0A: E802           jr      %0a10
0A0C: 2101 0000      ld      r1,#%0000
0A10: 6F01 8BFE      ld      %8bfe,r1
0A14: B311 FFFD      srl     r1,#3
0A18: 6F01 8BEC      ld      %8bec,r1
0A1C: 9E08           ret     
0A1E: 210B 8900      ld      r11,#%8900
0A22: 210C 8700      ld      r12,#%8700
0A26: 210D 8F00      ld      r13,#%8f00
0A2A: 210A 0020      ld      r10,#%0020
0A2E: 1CB1 0003      ldm     r0,@r11,#4
0A32: 5C09 0003 8880 ldm     %8880,r0,#4
0A38: A104           ld      r4,r0
0A3A: 0704 000F      and     r4,#%000f
0A3E: E607           jr      eq/z,%0a4e
0A40: 8144           add     r4,r4
0A42: 6144 0A66      ld      r4,%0a66(r4)
0A46: 1F40           call    r4
0A48: A9B7           inc     r11,8
0A4A: FA8F           djnz    r10,%0a2e
0A4C: 9E08           ret     
0A4E: 8D08           clr     r0
0A50: A101           ld      r1,r0
0A52: 1DC0           ldl     @r12,rr0
0A54: 1DD0           ldl     @r13,rr0
0A56: 5DC0 0004      ldl     %0004(r12),rr0
0A5A: 5DD0 0004      ldl     %0004(r13),rr0
0A5E: A9C7           inc     r12,8
0A60: A9D7           inc     r13,8
0A62: FA8B           djnz    r10,%0a4e
0A64: 9E08           ret     
0A66: 0C46           tsetb   @r4
0A68: 0C5C           .word   #%0c5c
0A6A: 0C78           clrb    @r7
0A6C: 0C9A           .word   #%0c9a
0A6E: 0CB6           tsetb   @r11
0A70: 0CDE           .word   #%0cde
0A72: 0D06           .word   #%0d06
0A74: 0D2E           .word   #%0d2e
0A76: 0D62           neg     @r6
0A78: 0D84           test    @r8
0A7A: 0D94           test    @r9
0A7C: 0DB6           tset    @r11
0A7E: 0DC6           tset    @r12
0A80: 0DEE           .word   #%0dee
0A82: 0C46           tsetb   @r4
0A84: 0C46           tsetb   @r4
0A86: 6102 8882      ld      r2,%8882
0A8A: 8D24           test    r2
0A8C: E517           jr      mi,%0abc
0A8E: 0B02 1000      cp      r2,#%1000
0A92: E90E           jr      ge,%0ab0
0A94: A121           ld      r1,r2
0A96: 1900 0074      mult    rr0,#%0074
0A9A: 0102 0093      add     r2,#%0093
0A9E: 9B20           div     rr0,r2
0AA0: 8D12           neg     r1
0AA2: 0101 006F      add     r1,#%006f
0AA6: 6F01 8824      ld      %8824,r1
0AAA: 6F00 8838      ld      %8838,r0
0AAE: 9E08           ret     
0AB0: 4D05 8824 FFFF ld      %8824,#%ffff
0AB6: 4D08 8838      clr     %8838
0ABA: 9E08           ret     
0ABC: 0B02 FFC1      cp      r2,#%ffc1
0AC0: E1F7           jr      lt,%0ab0
0AC2: 8D20           com     r2
0AC4: 8C28           clrb    rh2
0AC6: 0102 0070      add     r2,#%0070
0ACA: 6F02 8824      ld      %8824,r2
0ACE: 4D08 8838      clr     %8838
0AD2: 9E08           ret     
0AD4: 6101 8824      ld      r1,%8824
0AD8: 6103 8884      ld      r3,%8884
0ADC: A110           ld      r0,r1
0ADE: 0100 0004      add     r0,#%0004
0AE2: 9902           mult    rr2,r0
0AE4: B325 0006      slll    rr2,#6
0AE8: 6F02 882C      ld      %882c,r2
0AEC: 6103 8880      ld      r3,%8880
0AF0: 0703 000F      and     r3,#%000f
0AF4: 8133           add     r3,r3
0AF6: 6133 0AFC      ld      r3,%0afc(r3)
0AFA: 1E38           jp      @rr3
0AFC: 0B1C           cp      r12,@r1
0AFE: 0B1C           cp      r12,@r1
0B00: 0B1C           cp      r12,@r1
0B02: 0B54           cp      r4,@r5
0B04: 0B9E           cp      r14,@r9
0B06: 0B6C           cp      r12,@r6
0B08: 0B6C           cp      r12,@r6
0B0A: 0B1C           cp      r12,@r1
0B0C: 0BBA           cp      r10,@r11
0B0E: 0B1C           cp      r12,@r1
0B10: 0BEE           cp      r14,@r14
0B12: 0B6C           cp      r12,@r6
0B14: 0C0C           .word   #%0c0c
0B16: 0BBA           cp      r10,@r11
0B18: 0B1C           cp      r12,@r1
0B1A: 0B1C           cp      r12,@r1
0B1C: 0B01 0070      cp      r1,#%0070
0B20: EF0B           jr      nc/uge,%0b38
0B22: 0101 0006      add     r1,#%0006
0B26: A110           ld      r0,r1
0B28: 8101           add     r1,r0
0B2A: 8101           add     r1,r0
0B2C: B311 FFFD      srl     r1,#3
0B30: AB10           dec     r1,1
0B32: 6F01 8834      ld      %8834,r1
0B36: 9E08           ret     
0B38: 0101 0040      add     r1,#%0040
0B3C: B311 FFFE      srl     r1,#2
0B40: AB10           dec     r1,1
0B42: 6F01 8834      ld      %8834,r1
0B46: 0B01 0040      cp      r1,#%0040
0B4A: 9E07           ret     c/ult
0B4C: 4D05 8834 003F ld      %8834,#%003f
0B52: 9E08           ret     
0B54: 4D04 81AE      test    %81ae
0B58: E609           jr      eq/z,%0b6c
0B5A: 6102 8882      ld      r2,%8882
0B5E: 0102 037E      add     r2,#%037e
0B62: 1400 0002 757A ldl     rr0,#%0002757a
0B68: 9B20           div     rr0,r2
0B6A: E810           jr      %0b8c
0B6C: 0B01 0070      cp      r1,#%0070
0B70: EF08           jr      nc/uge,%0b82
0B72: 0101 0004      add     r1,#%0004
0B76: B311 FFFF      srl     r1,#1
0B7A: AB10           dec     r1,1
0B7C: 6F01 8834      ld      %8834,r1
0B80: 9E08           ret     
0B82: 0101 0077      add     r1,#%0077
0B86: B311 FFFE      srl     r1,#2
0B8A: AB10           dec     r1,1
0B8C: 6F01 8834      ld      %8834,r1
0B90: 0B01 0040      cp      r1,#%0040
0B94: 9E07           ret     c/ult
0B96: 4D05 8834 003F ld      %8834,#%003f
0B9C: 9E08           ret     
0B9E: 6102 8886      ld      r2,%8886
0BA2: 0702 000F      and     r2,#%000f
0BA6: 0B02 0003      cp      r2,#%0003
0BAA: E1B8           jr      lt,%0b1c
0BAC: 6102 8886      ld      r2,%8886
0BB0: A02A           ldb     rl2,rh2
0BB2: 8C28           clrb    rh2
0BB4: 6F02 8834      ld      %8834,r2
0BB8: 9E08           ret     
0BBA: 0101 0004      add     r1,#%0004
0BBE: A112           ld      r2,r1
0BC0: B321 FFFF      srl     r2,#1
0BC4: 8112           add     r2,r1
0BC6: B321 FFFD      srl     r2,#3
0BCA: 8121           add     r1,r2
0BCC: B311 FFFE      srl     r1,#2
0BD0: 4D05 8834 0001 ld      %8834,#%0001
0BD6: 8D14           test    r1
0BD8: 9E05           ret     mi
0BDA: 9E06           ret     eq/z
0BDC: 6F01 8834      ld      %8834,r1
0BE0: 0B01 0021      cp      r1,#%0021
0BE4: 9E07           ret     c/ult
0BE6: 4D05 8834 0020 ld      %8834,#%0020
0BEC: 9E08           ret     
0BEE: 0B01 0070      cp      r1,#%0070
0BF2: E702           jr      c/ult,%0bf8
0BF4: 2101 0070      ld      r1,#%0070
0BF8: 0101 0004      add     r1,#%0004
0BFC: 8D08           clr     r0
0BFE: B305 0003      slll    rr0,#3
0C02: 1B00 000D      div     rr0,#%000d
0C06: 6F01 8834      ld      %8834,r1
0C0A: 9E08           ret     
0C0C: 0B01 0070      cp      r1,#%0070
0C10: EF0C           jr      nc/uge,%0c2a
0C12: 0101 0004      add     r1,#%0004
0C16: A110           ld      r0,r1
0C18: B301 FFFD      srl     r0,#3
0C1C: 8101           add     r1,r0
0C1E: B311 FFFF      srl     r1,#1
0C22: AB10           dec     r1,1
0C24: 6F01 8834      ld      %8834,r1
0C28: 9E08           ret     
0C2A: 0101 0077      add     r1,#%0077
0C2E: B311 FFFE      srl     r1,#2
0C32: AB10           dec     r1,1
0C34: 6F01 8834      ld      %8834,r1
0C38: 0B01 0040      cp      r1,#%0040
0C3C: 9E07           ret     c/ult
0C3E: 4D05 8834 003F ld      %8834,#%003f
0C44: 9E08           ret     
0C46: 8D08           clr     r0
0C48: 8D18           clr     r1
0C4A: 1DC0           ldl     @r12,rr0
0C4C: 1DD0           ldl     @r13,rr0
0C4E: 5DC0 0004      ldl     %0004(r12),rr0
0C52: 5DD0 0004      ldl     %0004(r13),rr0
0C56: A9C7           inc     r12,8
0C58: A9D7           inc     r13,8
0C5A: 9E08           ret     
0C5C: 5F00 0A86      call    %0a86
0C60: 6101 8824      ld      r1,%8824
0C64: 0B01 00A0      cp      r1,#%00a0
0C68: 9E0F           ret     nc/uge
0C6A: 5F00 0AD4      call    %0ad4
0C6E: DF33           calr    %0e0a
0C70: DEE1           calr    %0eb0
0C72: A9C7           inc     r12,8
0C74: A9D7           inc     r13,8
0C76: 9E08           ret     
0C78: 0B0A 0001      cp      r10,#%0001
0C7C: 9E01           ret     lt
0C7E: 5F00 0A86      call    %0a86
0C82: 6101 8824      ld      r1,%8824
0C86: 0B01 00A0      cp      r1,#%00a0
0C8A: 9E0F           ret     nc/uge
0C8C: 5F00 0AD4      call    %0ad4
0C90: DF44           calr    %0e0a
0C92: DF0C           calr    %0e7c
0C94: A9C7           inc     r12,8
0C96: A9D7           inc     r13,8
0C98: 9E08           ret     
0C9A: 5F00 0A86      call    %0a86
0C9E: 6101 8824      ld      r1,%8824
0CA2: 0B01 00A0      cp      r1,#%00a0
0CA6: 9E0F           ret     nc/uge
0CA8: 5F00 0AD4      call    %0ad4
0CAC: DEAA           calr    %0f5a
0CAE: DE85           calr    %0fa6
0CB0: A9C7           inc     r12,8
0CB2: A9D7           inc     r13,8
0CB4: 9E08           ret     
0CB6: 0B0A 0005      cp      r10,#%0005
0CBA: 9E01           ret     lt
0CBC: 5F00 0A86      call    %0a86
0CC0: 6101 8824      ld      r1,%8824
0CC4: 0B01 00A0      cp      r1,#%00a0
0CC8: 9E0F           ret     nc/uge
0CCA: 5F00 0AD4      call    %0ad4
0CCE: DE71           calr    %0fee
0CD0: DDE7           calr    %1104
0CD2: 010C 0028      add     r12,#%0028
0CD6: 010D 0028      add     r13,#%0028
0CDA: ABA3           dec     r10,4
0CDC: 9E08           ret     
0CDE: 0B0A 0004      cp      r10,#%0004
0CE2: 9E01           ret     lt
0CE4: 5F00 0A86      call    %0a86
0CE8: 6101 8824      ld      r1,%8824
0CEC: 0B01 0070      cp      r1,#%0070
0CF0: 9E0F           ret     nc/uge
0CF2: 5F00 0AD4      call    %0ad4
0CF6: DDBD           calr    %117e
0CF8: DD3C           calr    %1282
0CFA: 010C 0020      add     r12,#%0020
0CFE: 010D 0020      add     r13,#%0020
0D02: ABA2           dec     r10,3
0D04: 9E08           ret     
0D06: 0B0A 000B      cp      r10,#%000b
0D0A: 9E01           ret     lt
0D0C: 5F00 0A86      call    %0a86
0D10: 6101 8824      ld      r1,%8824
0D14: 0B01 0070      cp      r1,#%0070
0D18: 9E0F           ret     nc/uge
0D1A: 5F00 0AD4      call    %0ad4
0D1E: DCD9           calr    %136e
0D20: DC54           calr    %147a
0D22: 010C 0058      add     r12,#%0058
0D26: 010D 0058      add     r13,#%0058
0D2A: ABA9           dec     r10,10
0D2C: 9E08           ret     
0D2E: 0B0A 0002      cp      r10,#%0002
0D32: 9E01           ret     lt
0D34: 6100 8882      ld      r0,%8882
0D38: 0300 0064      sub     r0,#%0064
0D3C: 6F00 8882      ld      %8882,r0
0D40: 5F00 0A86      call    %0a86
0D44: 6101 8824      ld      r1,%8824
0D48: 0B01 00A0      cp      r1,#%00a0
0D4C: 9E0F           ret     nc/uge
0D4E: 5F00 0AD4      call    %0ad4
0D52: DC25           calr    %150a
0D54: DBEA           calr    %1582
0D56: 010C 0010      add     r12,#%0010
0D5A: 010D 0010      add     r13,#%0010
0D5E: ABA0           dec     r10,1
0D60: 9E08           ret     
0D62: 5F00 0A86      call    %0a86
0D66: 6101 8824      ld      r1,%8824
0D6A: 0B01 0070      cp      r1,#%0070
0D6E: 9E0F           ret     nc/uge
0D70: 5F00 0AD4      call    %0ad4
0D74: DBDA           calr    %15c2
0D76: DB85           calr    %166e
0D78: 010C 0028      add     r12,#%0028
0D7C: 010D 0028      add     r13,#%0028
0D80: ABA3           dec     r10,4
0D82: 9E08           ret     
0D84: DB45           calr    %16fc
0D86: DB0D           calr    %176e
0D88: 010C 0020      add     r12,#%0020
0D8C: 010D 0020      add     r13,#%0020
0D90: ABA2           dec     r10,3
0D92: 9E08           ret     
0D94: 5F00 0A86      call    %0a86
0D98: 6101 8824      ld      r1,%8824
0D9C: 0B01 0070      cp      r1,#%0070
0DA0: 9E0F           ret     nc/uge
0DA2: 5F00 0AD4      call    %0ad4
0DA6: DACD           calr    %180e
0DA8: DA91           calr    %1888
0DAA: 010C 0010      add     r12,#%0010
0DAE: 010D 0010      add     r13,#%0010
0DB2: ABA0           dec     r10,1
0DB4: 9E08           ret     
0DB6: DA1E           calr    %197c
0DB8: D9D5           calr    %1a10
0DBA: 010C 0030      add     r12,#%0030
0DBE: 010D 0030      add     r13,#%0030
0DC2: ABA4           dec     r10,5
0DC4: 9E08           ret     
0DC6: 0B0A 000B      cp      r10,#%000b
0DCA: 9E01           ret     lt
0DCC: 5F00 0A86      call    %0a86
0DD0: 6101 8824      ld      r1,%8824
0DD4: 0B01 0070      cp      r1,#%0070
0DD8: 9E0F           ret     nc/uge
0DDA: 5F00 0AD4      call    %0ad4
0DDE: D9A1           calr    %1a9e
0DE0: D917           calr    %1bb4
0DE2: 010C 0058      add     r12,#%0058
0DE6: 010D 0058      add     r13,#%0058
0DEA: ABA9           dec     r10,10
0DEC: 9E08           ret     
0DEE: 5F00 0A86      call    %0a86
0DF2: 6101 8824      ld      r1,%8824
0DF6: 0B01 0070      cp      r1,#%0070
0DFA: 9E0F           ret     nc/uge
0DFC: 5F00 0AD4      call    %0ad4
0E00: D8EA           calr    %1c2e
0E02: D8A2           calr    %1cc0
0E04: A9C7           inc     r12,8
0E06: A9D7           inc     r13,8
0E08: 9E08           ret     
0E0A: 6101 8824      ld      r1,%8824
0E0E: 6105 8834      ld      r5,%8834
0E12: 0B05 000F      cp      r5,#%000f
0E16: EA08           jr      gt,%0e28
0E18: A154           ld      r4,r5
0E1A: 8155           add     r5,r5
0E1C: 8145           add     r5,r4
0E1E: 8155           add     r5,r5
0E20: 8145           add     r5,r4
0E22: 8344           sub     r4,r4
0E24: 1B04 0005      div     rr4,#%0005
0E28: 8D12           neg     r1
0E2A: 0101 0182      add     r1,#%0182
0E2E: 8151           add     r1,r5
0E30: 2FC1           ld      @r12,r1
0E32: 6FC1 0004      ld      %0004(r12),r1
0E36: 6101 8824      ld      r1,%8824
0E3A: 0B01 0070      cp      r1,#%0070
0E3E: E709           jr      c/ult,%0e52
0E40: 8111           add     r1,r1
0E42: 6102 882C      ld      r2,%882c
0E46: 4112 8300      add     r2,%8300(r1)
0E4A: 4D05 8894 006F ld      %8894,#%006f
0E50: E807           jr      %0e60
0E52: 6F01 8894      ld      %8894,r1
0E56: 8111           add     r1,r1
0E58: 6102 882C      ld      r2,%882c
0E5C: 4112 9700      add     r2,%9700(r1)
0E60: 8152           add     r2,r5
0E62: 8D22           neg     r2
0E64: 0102 053E      add     r2,#%053e
0E68: 6FC2 0002      ld      %0002(r12),r2
0E6C: 8152           add     r2,r5
0E6E: 6FC2 0006      ld      %0006(r12),r2
0E72: 0302 04BE      sub     r2,#%04be
0E76: 6F02 8890      ld      %8890,r2
0E7A: 9E08           ret     
0E7C: 6102 8894      ld      r2,%8894
0E80: 8122           add     r2,r2
0E82: 6101 8890      ld      r1,%8890
0E86: 6120 8500      ld      r0,%8500(r2)
0E8A: B309 FFFE      sra     r0,#2
0E8E: 8101           add     r1,r0
0E90: 0B01 FF81      cp      r1,#%ff81
0E94: E106           jr      lt,%0ea2
0E96: 0B01 007F      cp      r1,#%007f
0E9A: E205           jr      le,%0ea6
0E9C: 2101 007F      ld      r1,#%007f
0EA0: E802           jr      %0ea6
0EA2: 2101 FF81      ld      r1,#%ff81
0EA6: 6106 8886      ld      r6,%8886
0EAA: 0706 000F      and     r6,#%000f
0EAE: E806           jr      %0ebc
0EB0: 6101 8886      ld      r1,%8886
0EB4: A01E           ldb     rl6,rh1
0EB6: 0706 0003      and     r6,#%0003
0EBA: B110           extsb   r1
0EBC: 8D14           test    r1
0EBE: E527           jr      mi,%0f0e
0EC0: 0101 0004      add     r1,#%0004
0EC4: 8D08           clr     r0
0EC6: 1B00 000B      div     rr0,#%000b
0ECA: 8111           add     r1,r1
0ECC: A910           inc     r1,1
0ECE: A517           set     r1,7
0ED0: 6100 8834      ld      r0,%8834
0ED4: 0B00 000F      cp      r0,#%000f
0ED8: E203           jr      le,%0ee0
0EDA: A507           set     r0,7
0EDC: A081           ldb     rh1,rl0
0EDE: E80C           jr      %0ef8
0EE0: A105           ld      r5,r0
0EE2: A154           ld      r4,r5
0EE4: 8155           add     r5,r5
0EE6: 8145           add     r5,r4
0EE8: 8155           add     r5,r5
0EEA: 8145           add     r5,r4
0EEC: 8344           sub     r4,r4
0EEE: 1B04 0005      div     rr4,#%0005
0EF2: A150           ld      r0,r5
0EF4: A081           ldb     rh1,rl0
0EF6: 8100           add     r0,r0
0EF8: A080           ldb     rh0,rl0
0EFA: 2FD1           ld      @r13,r1
0EFC: AB10           dec     r1,1
0EFE: 6FD1 0004      ld      %0004(r13),r1
0F02: A0E8           ldb     rl0,rl6
0F04: 6FD0 0002      ld      %0002(r13),r0
0F08: 6FD0 0006      ld      %0006(r13),r0
0F0C: 9E08           ret     
0F0E: 8D12           neg     r1
0F10: 0101 0003      add     r1,#%0003
0F14: 8D08           clr     r0
0F16: 1B00 000B      div     rr0,#%000b
0F1A: 8111           add     r1,r1
0F1C: 6100 8834      ld      r0,%8834
0F20: 0B00 000F      cp      r0,#%000f
0F24: E203           jr      le,%0f2c
0F26: A507           set     r0,7
0F28: A081           ldb     rh1,rl0
0F2A: E80C           jr      %0f44
0F2C: A105           ld      r5,r0
0F2E: A154           ld      r4,r5
0F30: 8155           add     r5,r5
0F32: 8145           add     r5,r4
0F34: 8155           add     r5,r5
0F36: 8145           add     r5,r4
0F38: 8344           sub     r4,r4
0F3A: 1B04 0005      div     rr4,#%0005
0F3E: A150           ld      r0,r5
0F40: A081           ldb     rh1,rl0
0F42: 8100           add     r0,r0
0F44: A080           ldb     rh0,rl0
0F46: 2FD1           ld      @r13,r1
0F48: A910           inc     r1,1
0F4A: 6FD1 0004      ld      %0004(r13),r1
0F4E: A0E8           ldb     rl0,rl6
0F50: 6FD0 0002      ld      %0002(r13),r0
0F54: 6FD0 0006      ld      %0006(r13),r0
0F58: 9E08           ret     
0F5A: 6101 8824      ld      r1,%8824
0F5E: 8D12           neg     r1
0F60: 0101 0182      add     r1,#%0182
0F64: 4101 8834      add     r1,%8834
0F68: 2FC1           ld      @r12,r1
0F6A: 6FC1 0004      ld      %0004(r12),r1
0F6E: 6101 8824      ld      r1,%8824
0F72: 0B01 0070      cp      r1,#%0070
0F76: E706           jr      c/ult,%0f84
0F78: 8111           add     r1,r1
0F7A: 6102 882C      ld      r2,%882c
0F7E: 4112 8300      add     r2,%8300(r1)
0F82: E805           jr      %0f8e
0F84: 8111           add     r1,r1
0F86: 6102 882C      ld      r2,%882c
0F8A: 4112 9700      add     r2,%9700(r1)
0F8E: 4102 8834      add     r2,%8834
0F92: 8D22           neg     r2
0F94: 0102 053E      add     r2,#%053e
0F98: 6FC2 0002      ld      %0002(r12),r2
0F9C: 4102 8834      add     r2,%8834
0FA0: 6FC2 0006      ld      %0006(r12),r2
0FA4: 9E08           ret     
0FA6: 6101 8886      ld      r1,%8886
0FAA: A019           ldb     rl1,rh1
0FAC: 8D10           com     r1
0FAE: 0701 0007      and     r1,#%0007
0FB2: 0B01 0005      cp      r1,#%0005
0FB6: EF12           jr      nc/uge,%0fdc
0FB8: 8111           add     r1,r1
0FBA: 0101 001E      add     r1,#%001e
0FBE: 6100 8834      ld      r0,%8834
0FC2: A507           set     r0,7
0FC4: A080           ldb     rh0,rl0
0FC6: A081           ldb     rh1,rl0
0FC8: C828           ldb     rl0,#%28
0FCA: 2FD1           ld      @r13,r1
0FCC: A910           inc     r1,1
0FCE: 6FD1 0004      ld      %0004(r13),r1
0FD2: 6FD0 0002      ld      %0002(r13),r0
0FD6: 6FD0 0006      ld      %0006(r13),r0
0FDA: 9E08           ret     
0FDC: 8D08           clr     r0
0FDE: 8D18           clr     r1
0FE0: 1DC0           ldl     @r12,rr0
0FE2: 1DD0           ldl     @r13,rr0
0FE4: 5DC0 0004      ldl     %0004(r12),rr0
0FE8: 5DD0 0004      ldl     %0004(r13),rr0
0FEC: 9E08           ret     
0FEE: 6101 8824      ld      r1,%8824
0FF2: 8D12           neg     r1
0FF4: 0101 0182      add     r1,#%0182
0FF8: A116           ld      r6,r1
0FFA: 4101 8834      add     r1,%8834
0FFE: 6FC1 0010      ld      %0010(r12),r1
1002: 6FC1 0014      ld      %0014(r12),r1
1006: 6101 8824      ld      r1,%8824
100A: 8111           add     r1,r1
100C: 6107 882C      ld      r7,%882c
1010: 4117 9700      add     r7,%9700(r1)
1014: 4107 8834      add     r7,%8834
1018: 8D72           neg     r7
101A: 0107 053E      add     r7,#%053e
101E: 6FC7 0012      ld      %0012(r12),r7
1022: 4107 8834      add     r7,%8834
1026: 6FC7 0016      ld      %0016(r12),r7
102A: 2109 9F80      ld      r9,#%9f80
102E: A1C8           ld      r8,r12
1030: 93FA           push    @r15,r10
1032: 93FB           push    @r15,r11
1034: 210B 0002      ld      r11,#%0002
1038: 210A 0004      ld      r10,#%0004
103C: 4D94 000E      test    %000e(r9)
1040: E65B           jr      eq/z,%10f8
1042: 1490           ldl     rr0,@r9
1044: A113           ld      r3,r1
1046: B319 FFFC      sra     r1,#4
104A: 8110           add     r0,r1
104C: B319 FFFF      sra     r1,#1
1050: 8313           sub     r3,r1
1052: A131           ld      r1,r3
1054: 1D90           ldl     @r9,rr0
1056: A103           ld      r3,r0
1058: 5490 0004      ldl     rr0,%0004(r9)
105C: A114           ld      r4,r1
105E: B319 FFFC      sra     r1,#4
1062: 8110           add     r0,r1
1064: B319 FFFF      sra     r1,#1
1068: 8314           sub     r4,r1
106A: A141           ld      r1,r4
106C: 5D90 0004      ldl     %0004(r9),rr0
1070: A104           ld      r4,r0
1072: 5490 0008      ldl     rr0,%0008(r9)
1076: A115           ld      r5,r1
1078: B319 FFFC      sra     r1,#4
107C: 8110           add     r0,r1
107E: B319 FFFF      sra     r1,#1
1082: 8315           sub     r5,r1
1084: A151           ld      r1,r5
1086: 0301 00D0      sub     r1,#%00d0
108A: 8D04           test    r0
108C: ED08           jr      pl,%109e
108E: 8D02           neg     r0
1090: A7A1           bit     r10,1
1092: EE02           jr      ne/nz,%1098
1094: B319 FFFE      sra     r1,#2
1098: 8D14           test    r1
109A: ED01           jr      pl,%109e
109C: 8D12           neg     r1
109E: 5D90 0008      ldl     %0008(r9),rr0
10A2: A105           ld      r5,r0
10A4: B339 FFFA      sra     r3,#6
10A8: B349 FFFA      sra     r4,#6
10AC: B359 FFFA      sra     r5,#6
10B0: 0104 01BC      add     r4,#%01bc
10B4: 2101 2804      ld      r1,#%2804
10B8: 8D08           clr     r0
10BA: 9B40           div     rr0,r4
10BC: 6F91 000C      ld      %000c(r9),r1
10C0: A112           ld      r2,r1
10C2: 2101 0074      ld      r1,#%0074
10C6: 8351           sub     r1,r5
10C8: 1900 018A      mult    rr0,#%018a
10CC: 9B40           div     rr0,r4
10CE: 8D12           neg     r1
10D0: 0101 0067      add     r1,#%0067
10D4: 8161           add     r1,r6
10D6: 8121           add     r1,r2
10D8: 2F81           ld      @r8,r1
10DA: 1902 018A      mult    rr2,#%018a
10DE: 9B42           div     rr2,r4
10E0: 8173           add     r3,r7
10E2: 6F83 0002      ld      %0002(r8),r3
10E6: 0109 0010      add     r9,#%0010
10EA: A983           inc     r8,4
10EC: FAD9           djnz    r10,%103c
10EE: A987           inc     r8,8
10F0: FBDD           djnz    r11,%1038
10F2: 97FB           pop     r11,@r15
10F4: 97FA           pop     r10,@r15
10F6: 9E08           ret     
10F8: 4D98 000C      clr     %000c(r9)
10FC: 4D88 0002      clr     %0002(r8)
1100: 0D88           clr     @r8
1102: E8F1           jr      %10e6
1104: 6100 8834      ld      r0,%8834
1108: A507           set     r0,7
110A: 6101 8886      ld      r1,%8886
110E: 0701 000F      and     r1,#%000f
1112: 0B01 0007      cp      r1,#%0007
1116: E201           jr      le,%111a
1118: 8D08           clr     r0
111A: 0701 0007      and     r1,#%0007
111E: A112           ld      r2,r1
1120: 8111           add     r1,r1
1122: 0101 0018      add     r1,#%0018
1126: A080           ldb     rh0,rl0
1128: A081           ldb     rh1,rl0
112A: C800           ldb     rl0,#%00
112C: 0B02 0003      cp      r2,#%0003
1130: E101           jr      lt,%1134
1132: C828           ldb     rl0,#%28
1134: 6FD1 0010      ld      %0010(r13),r1
1138: A910           inc     r1,1
113A: 6FD1 0014      ld      %0014(r13),r1
113E: 6FD0 0012      ld      %0012(r13),r0
1142: 6FD0 0016      ld      %0016(r13),r0
1146: 2109 9F8C      ld      r9,#%9f8c
114A: A1D8           ld      r8,r13
114C: 2107 1176      ld      r7,#%1176
1150: 2105 0002      ld      r5,#%0002
1154: 2106 0004      ld      r6,#%0004
1158: 2191           ld      r1,@r9
115A: A091           ldb     rh1,rl1
115C: 2079           ldb     rl1,@r7
115E: 2F81           ld      @r8,r1
1160: C929           ldb     rl1,#%29
1162: 6F81 0002      ld      %0002(r8),r1
1166: A970           inc     r7,1
1168: A983           inc     r8,4
116A: 0109 0010      add     r9,#%0010
116E: F68C           djnz    r6,%1158
1170: A987           inc     r8,8
1172: F590           djnz    r5,%1154
1174: 9E08           ret     
1176: 2218           resb    @r1,8
1178: 1923           mult    rr3,@r2
117A: 231A           res     @r1,10
117C: 1C24           .word   #%1c24
117E: 6101 8824      ld      r1,%8824
1182: A110           ld      r0,r1
1184: 6103 8834      ld      r3,%8834
1188: A134           ld      r4,r3
118A: B349 FFFF      sra     r4,#1
118E: 6102 8886      ld      r2,%8886
1192: 0702 000F      and     r2,#%000f
1196: 0B02 000C      cp      r2,#%000c
119A: E937           jr      ge,%120a
119C: 8D02           neg     r0
119E: 0100 0182      add     r0,#%0182
11A2: 8140           add     r0,r4
11A4: 6FC0 0018      ld      %0018(r12),r0
11A8: 6FC0 001C      ld      %001c(r12),r0
11AC: 8130           add     r0,r3
11AE: 6FC0 000C      ld      %000c(r12),r0
11B2: 6FC0 0010      ld      %0010(r12),r0
11B6: 6FC0 0014      ld      %0014(r12),r0
11BA: 8130           add     r0,r3
11BC: 2FC0           ld      @r12,r0
11BE: 6FC0 0004      ld      %0004(r12),r0
11C2: 6FC0 0008      ld      %0008(r12),r0
11C6: 8111           add     r1,r1
11C8: 6102 882C      ld      r2,%882c
11CC: 4112 9700      add     r2,%9700(r1)
11D0: 8132           add     r2,r3
11D2: 8142           add     r2,r4
11D4: 8D22           neg     r2
11D6: 0102 053E      add     r2,#%053e
11DA: 6FC2 0002      ld      %0002(r12),r2
11DE: 6FC2 000E      ld      %000e(r12),r2
11E2: A121           ld      r1,r2
11E4: B349 FFFF      sra     r4,#1
11E8: 8141           add     r1,r4
11EA: 6FC1 001A      ld      %001a(r12),r1
11EE: 8132           add     r2,r3
11F0: 6FC2 0006      ld      %0006(r12),r2
11F4: 6FC2 0012      ld      %0012(r12),r2
11F8: 8132           add     r2,r3
11FA: 6FC2 000A      ld      %000a(r12),r2
11FE: 6FC2 0016      ld      %0016(r12),r2
1202: 8142           add     r2,r4
1204: 6FC2 001E      ld      %001e(r12),r2
1208: 9E08           ret     
120A: A145           ld      r5,r4
120C: B359 FFFF      sra     r5,#1
1210: 8D02           neg     r0
1212: 0100 0182      add     r0,#%0182
1216: 8140           add     r0,r4
1218: 6FC0 0010      ld      %0010(r12),r0
121C: 6FC0 0014      ld      %0014(r12),r0
1220: 6FC0 0018      ld      %0018(r12),r0
1224: 6FC0 001C      ld      %001c(r12),r0
1228: 8130           add     r0,r3
122A: 2FC0           ld      @r12,r0
122C: 6FC0 0004      ld      %0004(r12),r0
1230: 6FC0 0008      ld      %0008(r12),r0
1234: 6FC0 000C      ld      %000c(r12),r0
1238: 8111           add     r1,r1
123A: 6102 882C      ld      r2,%882c
123E: 4112 9700      add     r2,%9700(r1)
1242: 8132           add     r2,r3
1244: 8132           add     r2,r3
1246: 8D22           neg     r2
1248: 0102 053E      add     r2,#%053e
124C: 6FC2 0002      ld      %0002(r12),r2
1250: A121           ld      r1,r2
1252: 8151           add     r1,r5
1254: 6FC1 0012      ld      %0012(r12),r1
1258: 8132           add     r2,r3
125A: 6FC2 0006      ld      %0006(r12),r2
125E: A121           ld      r1,r2
1260: 8151           add     r1,r5
1262: 6FC1 0016      ld      %0016(r12),r1
1266: 8132           add     r2,r3
1268: 6FC2 000A      ld      %000a(r12),r2
126C: A121           ld      r1,r2
126E: 8151           add     r1,r5
1270: 6FC1 001A      ld      %001a(r12),r1
1274: 8132           add     r2,r3
1276: 6FC2 000E      ld      %000e(r12),r2
127A: 8152           add     r2,r5
127C: 6FC2 001E      ld      %001e(r12),r2
1280: 9E08           ret     
1282: 6100 8834      ld      r0,%8834
1286: A082           ldb     rh2,rl0
1288: A083           ldb     rh3,rl0
128A: B331 FFFF      srl     r3,#1
128E: A084           ldb     rh4,rl0
1290: 8044           addb    rh4,rh4
1292: A085           ldb     rh5,rl0
1294: 8D68           clr     r6
1296: 0B00 000F      cp      r0,#%000f
129A: E203           jr      le,%12a2
129C: A52F           set     r2,15
129E: A084           ldb     rh4,rl0
12A0: A960           inc     r6,1
12A2: 6107 8886      ld      r7,%8886
12A6: 0707 000F      and     r7,#%000f
12AA: A171           ld      r1,r7
12AC: 0701 000E      and     r1,#%000e
12B0: 8161           add     r1,r6
12B2: 601A 5BC0      ldb     rl2,%5bc0(r1)
12B6: 607C 5BD0      ldb     rl4,%5bd0(r7)
12BA: A0CD           ldb     rl5,rl4
12BC: 0B07 000C      cp      r7,#%000c
12C0: E931           jr      ge,%1324
12C2: 2FD2           ld      @r13,r2
12C4: A920           inc     r2,1
12C6: 6FD2 0004      ld      %0004(r13),r2
12CA: A920           inc     r2,1
12CC: 6FD2 0008      ld      %0008(r13),r2
12D0: A920           inc     r2,1
12D2: 6FD2 000C      ld      %000c(r13),r2
12D6: A920           inc     r2,1
12D8: 6FD2 0010      ld      %0010(r13),r2
12DC: A920           inc     r2,1
12DE: 6FD2 0014      ld      %0014(r13),r2
12E2: 0B07 0008      cp      r7,#%0008
12E6: E907           jr      ge,%12f6
12E8: CB56           ldb     rl3,#%56
12EA: 6FD3 0018      ld      %0018(r13),r3
12EE: A930           inc     r3,1
12F0: 6FD3 001C      ld      %001c(r13),r3
12F4: E806           jr      %1302
12F6: CBD7           ldb     rl3,#%d7
12F8: 6FD3 0018      ld      %0018(r13),r3
12FC: AB30           dec     r3,1
12FE: 6FD3 001C      ld      %001c(r13),r3
1302: 6FD4 0002      ld      %0002(r13),r4
1306: 6FD4 0006      ld      %0006(r13),r4
130A: 6FD4 000A      ld      %000a(r13),r4
130E: 6FD4 000E      ld      %000e(r13),r4
1312: 6FD4 0012      ld      %0012(r13),r4
1316: 6FD4 0016      ld      %0016(r13),r4
131A: 6FD5 001A      ld      %001a(r13),r5
131E: 6FD5 001E      ld      %001e(r13),r5
1322: 9E08           ret     
1324: 2FD2           ld      @r13,r2
1326: A920           inc     r2,1
1328: 6FD2 0004      ld      %0004(r13),r2
132C: A920           inc     r2,1
132E: 6FD2 0008      ld      %0008(r13),r2
1332: A920           inc     r2,1
1334: 6FD2 000C      ld      %000c(r13),r2
1338: CBD7           ldb     rl3,#%d7
133A: 6FD3 0010      ld      %0010(r13),r3
133E: 6FD3 0014      ld      %0014(r13),r3
1342: CBD6           ldb     rl3,#%d6
1344: 6FD3 0018      ld      %0018(r13),r3
1348: 6FD3 001C      ld      %001c(r13),r3
134C: 6FD4 0002      ld      %0002(r13),r4
1350: 6FD4 0006      ld      %0006(r13),r4
1354: 6FD4 000A      ld      %000a(r13),r4
1358: 6FD4 000E      ld      %000e(r13),r4
135C: 6FD5 0012      ld      %0012(r13),r5
1360: 6FD5 0016      ld      %0016(r13),r5
1364: 6FD5 001A      ld      %001a(r13),r5
1368: 6FD5 001E      ld      %001e(r13),r5
136C: 9E08           ret     
136E: 6101 8824      ld      r1,%8824
1372: A110           ld      r0,r1
1374: 6103 8834      ld      r3,%8834
1378: A134           ld      r4,r3
137A: B349 FFFF      sra     r4,#1
137E: A145           ld      r5,r4
1380: B359 FFFF      sra     r5,#1
1384: 8D02           neg     r0
1386: 0100 0182      add     r0,#%0182
138A: A102           ld      r2,r0
138C: 8142           add     r2,r4
138E: 6FC2 003C      ld      %003c(r12),r2
1392: 6FC2 0054      ld      %0054(r12),r2
1396: 8130           add     r0,r3
1398: 6FC0 0038      ld      %0038(r12),r0
139C: 6FC0 0050      ld      %0050(r12),r0
13A0: A102           ld      r2,r0
13A2: 8142           add     r2,r4
13A4: 6FC2 0034      ld      %0034(r12),r2
13A8: 6FC2 004C      ld      %004c(r12),r2
13AC: 8130           add     r0,r3
13AE: 6FC0 0030      ld      %0030(r12),r0
13B2: 6FC0 0048      ld      %0048(r12),r0
13B6: A102           ld      r2,r0
13B8: 8142           add     r2,r4
13BA: 6FC2 002C      ld      %002c(r12),r2
13BE: 6FC2 0044      ld      %0044(r12),r2
13C2: 8130           add     r0,r3
13C4: 6FC0 0028      ld      %0028(r12),r0
13C8: 6FC0 0040      ld      %0040(r12),r0
13CC: A102           ld      r2,r0
13CE: 8140           add     r0,r4
13D0: 2FC0           ld      @r12,r0
13D2: 6FC0 0004      ld      %0004(r12),r0
13D6: 8132           add     r2,r3
13D8: 6FC2 0008      ld      %0008(r12),r2
13DC: 6FC2 000C      ld      %000c(r12),r2
13E0: 6FC2 0010      ld      %0010(r12),r2
13E4: 6FC2 0014      ld      %0014(r12),r2
13E8: 6FC2 0018      ld      %0018(r12),r2
13EC: 6FC2 001C      ld      %001c(r12),r2
13F0: 6FC2 0020      ld      %0020(r12),r2
13F4: 6FC2 0024      ld      %0024(r12),r2
13F8: 8111           add     r1,r1
13FA: 6100 882C      ld      r0,%882c
13FE: 4110 9700      add     r0,%9700(r1)
1402: 8D02           neg     r0
1404: 0100 053E      add     r0,#%053e
1408: A101           ld      r1,r0
140A: 6FC0 001A      ld      %001a(r12),r0
140E: 8130           add     r0,r3
1410: 6FC0 001E      ld      %001e(r12),r0
1414: 8130           add     r0,r3
1416: 6FC0 0022      ld      %0022(r12),r0
141A: 8130           add     r0,r3
141C: 6FC0 0026      ld      %0026(r12),r0
1420: 8140           add     r0,r4
1422: 6FC0 0042      ld      %0042(r12),r0
1426: 6FC0 0046      ld      %0046(r12),r0
142A: 6FC0 004A      ld      %004a(r12),r0
142E: 6FC0 004E      ld      %004e(r12),r0
1432: 6FC0 0052      ld      %0052(r12),r0
1436: 6FC0 0056      ld      %0056(r12),r0
143A: 8331           sub     r1,r3
143C: 6FC1 0016      ld      %0016(r12),r1
1440: 8331           sub     r1,r3
1442: 6FC1 0012      ld      %0012(r12),r1
1446: A110           ld      r0,r1
1448: 8331           sub     r1,r3
144A: 8350           sub     r0,r5
144C: 6FC1 000E      ld      %000e(r12),r1
1450: 6FC0 0006      ld      %0006(r12),r0
1454: 8331           sub     r1,r3
1456: 8330           sub     r0,r3
1458: 6FC1 000A      ld      %000a(r12),r1
145C: 6FC0 0002      ld      %0002(r12),r0
1460: 6FC1 002A      ld      %002a(r12),r1
1464: 6FC1 002E      ld      %002e(r12),r1
1468: 6FC1 0032      ld      %0032(r12),r1
146C: 6FC1 0036      ld      %0036(r12),r1
1470: 6FC1 003A      ld      %003a(r12),r1
1474: 6FC1 003E      ld      %003e(r12),r1
1478: 9E08           ret     
147A: A1D5           ld      r5,r13
147C: 2106 14E4      ld      r6,#%14e4
1480: 2107 000A      ld      r7,#%000a
1484: 6100 8834      ld      r0,%8834
1488: A507           set     r0,7
148A: A080           ldb     rh0,rl0
148C: 2068           ldb     rl0,@r6
148E: 2F50           ld      @r5,r0
1490: A960           inc     r6,1
1492: A953           inc     r5,4
1494: F785           djnz    r7,%148c
1496: 2107 000C      ld      r7,#%000c
149A: B201 FFFF      srlb    rh0,#1
149E: 2068           ldb     rl0,@r6
14A0: 2F50           ld      @r5,r0
14A2: A960           inc     r6,1
14A4: A953           inc     r5,4
14A6: F785           djnz    r7,%149e
14A8: A1D5           ld      r5,r13
14AA: A951           inc     r5,2
14AC: 6101 8886      ld      r1,%8886
14B0: 0701 0007      and     r1,#%0007
14B4: 8111           add     r1,r1
14B6: 6111 14FA      ld      r1,%14fa(r1)
14BA: 6100 8834      ld      r0,%8834
14BE: A507           set     r0,7
14C0: A080           ldb     rh0,rl0
14C2: A018           ldb     rl0,rh1
14C4: A001           ldb     rh1,rh0
14C6: 2F50           ld      @r5,r0
14C8: A953           inc     r5,4
14CA: 2F50           ld      @r5,r0
14CC: A953           inc     r5,4
14CE: 2107 0008      ld      r7,#%0008
14D2: 2F51           ld      @r5,r1
14D4: A953           inc     r5,4
14D6: F783           djnz    r7,%14d2
14D8: 2107 000C      ld      r7,#%000c
14DC: 2F51           ld      @r5,r1
14DE: A953           inc     r5,4
14E0: F783           djnz    r7,%14dc
14E2: 9E08           ret     
14E4: 2E2F           ldb     @r2,rl7
14E6: 2829           incb    @r2,10
14E8: 2A2B           decb    @r2,12
14EA: 2C2D           exb     rl5,@r2
14EC: A9A8           inc     r10,9
14EE: 5051 5253      cpl     rr1,%5253(r5)
14F2: 5455 D0D1      ldl     rr5,%d0d1(r5)
14F6: D2D3           calr    %0f52
14F8: D4D5           calr    %0b50
14FA: 1310           .word   #%1310
14FC: 1410           ldl     rr0,@r1
14FE: 1510           .word   #%1510
1500: 1610           addl    rr0,@r1
1502: 1710           .word   #%1710
1504: 1711           pop     @r1,@r1
1506: 1712           pop     @r2,@r1
1508: 1312           push    @r1,@r2
150A: 6101 8824      ld      r1,%8824
150E: 8D12           neg     r1
1510: 0101 0182      add     r1,#%0182
1514: 6100 8834      ld      r0,%8834
1518: B301 FFFF      srl     r0,#1
151C: 8101           add     r1,r0
151E: 2FC1           ld      @r12,r1
1520: 6FC1 0004      ld      %0004(r12),r1
1524: 6FC1 0008      ld      %0008(r12),r1
1528: 6FC1 000C      ld      %000c(r12),r1
152C: 6101 8824      ld      r1,%8824
1530: 0B01 0070      cp      r1,#%0070
1534: E709           jr      c/ult,%1548
1536: 8111           add     r1,r1
1538: 6102 882C      ld      r2,%882c
153C: 4112 8300      add     r2,%8300(r1)
1540: 4D05 8894 006F ld      %8894,#%006f
1546: E807           jr      %1556
1548: 6F01 8894      ld      %8894,r1
154C: 8111           add     r1,r1
154E: 6102 882C      ld      r2,%882c
1552: 4112 9700      add     r2,%9700(r1)
1556: 4102 8834      add     r2,%8834
155A: 4102 8834      add     r2,%8834
155E: 8D22           neg     r2
1560: 0102 053E      add     r2,#%053e
1564: 6FC2 0002      ld      %0002(r12),r2
1568: 4102 8834      add     r2,%8834
156C: 6FC2 0006      ld      %0006(r12),r2
1570: 4102 8834      add     r2,%8834
1574: 6FC2 000A      ld      %000a(r12),r2
1578: 4102 8834      add     r2,%8834
157C: 6FC2 000E      ld      %000e(r12),r2
1580: 9E08           ret     
1582: 6100 8834      ld      r0,%8834
1586: 0B00 000F      cp      r0,#%000f
158A: E203           jr      le,%1592
158C: A507           set     r0,7
158E: A081           ldb     rh1,rl0
1590: E802           jr      %1596
1592: A081           ldb     rh1,rl0
1594: 8100           add     r0,r0
1596: A080           ldb     rh0,rl0
1598: C827           ldb     rl0,#%27
159A: 6FD0 0002      ld      %0002(r13),r0
159E: 6FD0 0006      ld      %0006(r13),r0
15A2: 6FD0 000A      ld      %000a(r13),r0
15A6: 6FD0 000E      ld      %000e(r13),r0
15AA: C930           ldb     rl1,#%30
15AC: 2FD1           ld      @r13,r1
15AE: A890           incb    rl1,1
15B0: 6FD1 0004      ld      %0004(r13),r1
15B4: A890           incb    rl1,1
15B6: 6FD1 0008      ld      %0008(r13),r1
15BA: A890           incb    rl1,1
15BC: 6FD1 000C      ld      %000c(r13),r1
15C0: 9E08           ret     
15C2: 6101 8834      ld      r1,%8834
15C6: A114           ld      r4,r1
15C8: B311 FFFE      srl     r1,#2
15CC: 8141           add     r1,r4
15CE: 0101 0182      add     r1,#%0182
15D2: A110           ld      r0,r1
15D4: 6103 8886      ld      r3,%8886
15D8: A135           ld      r5,r3
15DA: 0105 0007      add     r5,#%0007
15DE: 0703 000F      and     r3,#%000f
15E2: 0303 0008      sub     r3,#%0008
15E6: 8D34           test    r3
15E8: ED01           jr      pl,%15ec
15EA: 8D32           neg     r3
15EC: 603B 16F2      ldb     rl3,%16f2(r3)
15F0: 9942           mult    rr2,r4
15F2: B331 FFF9      srl     r3,#7
15F6: 8131           add     r1,r3
15F8: A931           inc     r3,2
15FA: A754           bit     r5,4
15FC: E601           jr      eq/z,%1600
15FE: AD10           ex      r0,r1
1600: 2FC1           ld      @r12,r1
1602: 6FC1 0004      ld      %0004(r12),r1
1606: 6FC1 0008      ld      %0008(r12),r1
160A: 6FC1 000C      ld      %000c(r12),r1
160E: 6FC0 0010      ld      %0010(r12),r0
1612: 6FC0 0014      ld      %0014(r12),r0
1616: 6FC0 0018      ld      %0018(r12),r0
161A: 6FC0 001C      ld      %001c(r12),r0
161E: 6FC0 0020      ld      %0020(r12),r0
1622: 6FC0 0024      ld      %0024(r12),r0
1626: A141           ld      r1,r4
1628: 8111           add     r1,r1
162A: 8141           add     r1,r4
162C: A142           ld      r2,r4
162E: B321 FFFD      srl     r2,#3
1632: 8121           add     r1,r2
1634: 8D12           neg     r1
1636: 0101 04C0      add     r1,#%04c0
163A: 6FC1 0012      ld      %0012(r12),r1
163E: 8141           add     r1,r4
1640: 6FC1 0002      ld      %0002(r12),r1
1644: 6FC1 0016      ld      %0016(r12),r1
1648: 8141           add     r1,r4
164A: 6FC1 0006      ld      %0006(r12),r1
164E: 6FC1 001A      ld      %001a(r12),r1
1652: 8141           add     r1,r4
1654: 6FC1 000A      ld      %000a(r12),r1
1658: 6FC1 001E      ld      %001e(r12),r1
165C: 8141           add     r1,r4
165E: 6FC1 000E      ld      %000e(r12),r1
1662: 6FC1 0022      ld      %0022(r12),r1
1666: 8141           add     r1,r4
1668: 6FC1 0026      ld      %0026(r12),r1
166C: 9E08           ret     
166E: 2101 0068      ld      r1,#%0068
1672: A0B1           ldb     rh1,rl3
1674: A51F           set     r1,15
1676: 2FD1           ld      @r13,r1
1678: A910           inc     r1,1
167A: 6FD1 0004      ld      %0004(r13),r1
167E: A910           inc     r1,1
1680: 6FD1 0008      ld      %0008(r13),r1
1684: A910           inc     r1,1
1686: 6FD1 000C      ld      %000c(r13),r1
168A: 6FD1 0010      ld      %0010(r13),r1
168E: A910           inc     r1,1
1690: 6FD1 0014      ld      %0014(r13),r1
1694: A910           inc     r1,1
1696: 6FD1 0018      ld      %0018(r13),r1
169A: A910           inc     r1,1
169C: 6FD1 001C      ld      %001c(r13),r1
16A0: A910           inc     r1,1
16A2: 6FD1 0020      ld      %0020(r13),r1
16A6: C968           ldb     rl1,#%68
16A8: 6FD1 0024      ld      %0024(r13),r1
16AC: A754           bit     r5,4
16AE: EE05           jr      ne/nz,%16ba
16B0: 2100 0034      ld      r0,#%0034
16B4: 2101 003A      ld      r1,#%003a
16B8: E804           jr      %16c2
16BA: 2100 0032      ld      r0,#%0032
16BE: 2101 0033      ld      r1,#%0033
16C2: A0C0           ldb     rh0,rl4
16C4: A50F           set     r0,15
16C6: A001           ldb     rh1,rh0
16C8: 6FD0 0002      ld      %0002(r13),r0
16CC: 6FD0 0006      ld      %0006(r13),r0
16D0: 6FD0 000A      ld      %000a(r13),r0
16D4: 6FD1 000E      ld      %000e(r13),r1
16D8: 6FD0 0012      ld      %0012(r13),r0
16DC: 6FD0 0016      ld      %0016(r13),r0
16E0: 6FD0 001A      ld      %001a(r13),r0
16E4: 6FD0 001E      ld      %001e(r13),r0
16E8: 6FD0 0022      ld      %0022(r13),r0
16EC: 6FD1 0026      ld      %0026(r13),r1
16F0: 9E08           ret     
16F2: 0118           add     r8,@r1
16F4: 3047 5A6A      ldb     rh7,r4(#%5a6a)
16F8: 767D 8000      lda     pr13,%8000(r7)
16FC: 2101 01A8      ld      r1,#%01a8
1700: 2FC1           ld      @r12,r1
1702: 6FC1 0004      ld      %0004(r12),r1
1706: 6FC1 0008      ld      %0008(r12),r1
170A: 6FC1 000C      ld      %000c(r12),r1
170E: 6FC1 0010      ld      %0010(r12),r1
1712: 0101 0012      add     r1,#%0012
1716: 6FC1 0014      ld      %0014(r12),r1
171A: 6FC1 0018      ld      %0018(r12),r1
171E: 6FC1 001C      ld      %001c(r12),r1
1722: 6101 8884      ld      r1,%8884
1726: 6FC1 0002      ld      %0002(r12),r1
172A: 0101 0020      add     r1,#%0020
172E: 6FC1 0006      ld      %0006(r12),r1
1732: 0101 0020      add     r1,#%0020
1736: 6FC1 000A      ld      %000a(r12),r1
173A: 0101 0020      add     r1,#%0020
173E: 6FC1 000E      ld      %000e(r12),r1
1742: 0101 0020      add     r1,#%0020
1746: 6FC1 0012      ld      %0012(r12),r1
174A: 4D04 8886      test    %8886
174E: EE02           jr      ne/nz,%1754
1750: 0101 0010      add     r1,#%0010
1754: 0101 0010      add     r1,#%0010
1758: 6FC1 0016      ld      %0016(r12),r1
175C: 0101 0020      add     r1,#%0020
1760: 6FC1 001A      ld      %001a(r12),r1
1764: 0101 0020      add     r1,#%0020
1768: 6FC1 001E      ld      %001e(r12),r1
176C: 9E08           ret     
176E: 6100 801C      ld      r0,%801c
1772: 0700 0001      and     r0,#%0001
1776: EE0F           jr      ne/nz,%1796
1778: 0DD5 A060      ld      @r13,#%a060
177C: 6100 8884      ld      r0,%8884
1780: 0700 0004      and     r0,#%0004
1784: EE04           jr      ne/nz,%178e
1786: 4DD5 0002 A031 ld      %0002(r13),#%a031
178C: E812           jr      %17b2
178E: 4DD5 0002 A026 ld      %0002(r13),#%a026
1794: E80E           jr      %17b2
1796: 0DD5 A061      ld      @r13,#%a061
179A: 6100 8884      ld      r0,%8884
179E: 0700 0004      and     r0,#%0004
17A2: EE04           jr      ne/nz,%17ac
17A4: 4DD5 0002 A030 ld      %0002(r13),#%a030
17AA: E803           jr      %17b2
17AC: 4DD5 0002 A02F ld      %0002(r13),#%a02f
17B2: 2101 A062      ld      r1,#%a062
17B6: 2102 A024      ld      r2,#%a024
17BA: 4D04 8886      test    %8886
17BE: E601           jr      eq/z,%17c2
17C0: A920           inc     r2,1
17C2: 6FD1 0004      ld      %0004(r13),r1
17C6: 6FD2 0006      ld      %0006(r13),r2
17CA: A910           inc     r1,1
17CC: 6FD1 0008      ld      %0008(r13),r1
17D0: 6FD2 000A      ld      %000a(r13),r2
17D4: A910           inc     r1,1
17D6: 6FD1 000C      ld      %000c(r13),r1
17DA: 6FD2 000E      ld      %000e(r13),r2
17DE: A910           inc     r1,1
17E0: 6FD1 0010      ld      %0010(r13),r1
17E4: 6FD2 0012      ld      %0012(r13),r2
17E8: 2101 A262      ld      r1,#%a262
17EC: 2102 A02D      ld      r2,#%a02d
17F0: 6FD1 0014      ld      %0014(r13),r1
17F4: 6FD2 0016      ld      %0016(r13),r2
17F8: A910           inc     r1,1
17FA: 6FD1 0018      ld      %0018(r13),r1
17FE: 6FD2 001A      ld      %001a(r13),r2
1802: A910           inc     r1,1
1804: 6FD1 001C      ld      %001c(r13),r1
1808: 6FD2 001E      ld      %001e(r13),r2
180C: 9E08           ret     
180E: 6101 8824      ld      r1,%8824
1812: A110           ld      r0,r1
1814: 8D02           neg     r0
1816: 0100 0182      add     r0,#%0182
181A: 6103 8834      ld      r3,%8834
181E: A134           ld      r4,r3
1820: B349 FFFF      sra     r4,#1
1824: A145           ld      r5,r4
1826: B359 FFFF      sra     r5,#1
182A: 8130           add     r0,r3
182C: 2FC0           ld      @r12,r0
182E: 8140           add     r0,r4
1830: 6FC0 0004      ld      %0004(r12),r0
1834: 6FC0 0008      ld      %0008(r12),r0
1838: 6FC0 000C      ld      %000c(r12),r0
183C: 8111           add     r1,r1
183E: 6102 882C      ld      r2,%882c
1842: 4112 9700      add     r2,%9700(r1)
1846: 6103 8886      ld      r3,%8886
184A: B339 0002      sla     r3,#2
184E: 0703 00FC      and     r3,#%00fc
1852: 6039 18D7      ldb     rl1,%18d7(r3)
1856: 0701 0003      and     r1,#%0003
185A: E608           jr      eq/z,%186c
185C: AB10           dec     r1,1
185E: E605           jr      eq/z,%186a
1860: AB10           dec     r1,1
1862: E601           jr      eq/z,%1866
1864: 8152           add     r2,r5
1866: 8142           add     r2,r4
1868: E801           jr      %186c
186A: 8152           add     r2,r5
186C: 8D22           neg     r2
186E: 0102 053E      add     r2,#%053e
1872: 6FC2 0002      ld      %0002(r12),r2
1876: 6FC2 0006      ld      %0006(r12),r2
187A: 8142           add     r2,r4
187C: 6FC2 000A      ld      %000a(r12),r2
1880: 8142           add     r2,r4
1882: 6FC2 000E      ld      %000e(r12),r2
1886: 9E08           ret     
1888: 6101 8834      ld      r1,%8834
188C: A091           ldb     rh1,rl1
188E: A090           ldb     rh0,rl1
1890: C82C           ldb     rl0,#%2c
1892: 6102 8886      ld      r2,%8886
1896: B329 0002      sla     r2,#2
189A: 0702 00FC      and     r2,#%00fc
189E: A51F           set     r1,15
18A0: 6029 18D4      ldb     rl1,%18d4(r2)
18A4: 2FD1           ld      @r13,r1
18A6: 6FD0 0002      ld      %0002(r13),r0
18AA: A31F           res     r1,15
18AC: B319 FFFF      sra     r1,#1
18B0: 6029 18D5      ldb     rl1,%18d5(r2)
18B4: 6FD1 0004      ld      %0004(r13),r1
18B8: 6FD0 0006      ld      %0006(r13),r0
18BC: 6029 18D6      ldb     rl1,%18d6(r2)
18C0: 6FD1 0008      ld      %0008(r13),r1
18C4: 6FD0 000A      ld      %000a(r13),r0
18C8: C970           ldb     rl1,#%70
18CA: 6FD1 000C      ld      %000c(r13),r1
18CE: 6FD0 000E      ld      %000e(r13),r0
18D2: 9E08           ret     
18D4: 5071 7202      cpl     rr1,%7202(r7)
18D8: 5173 7401      pushl   @r7,%7401(r3)
18DC: 5270 7001      subl    rr0,%7001(r7)
18E0: 5370 7003      push    @r7,%7003
18E4: 5475 7003      ldl     rr5,%7003(r7)
18E8: 5576 7002      popl    %7002(r6),@r7
18EC: 5677 7002      addl    rr7,%7002(r7)
18F0: 5770 7001      pop     %7001,@r7
18F4: 5870 7001      multl   rq0,%7001(r7)
18F8: 5970 7001      mult    rr0,%7001(r7)
18FC: 5A78 7901      divl    rq8,%7901(r7)
1900: 5071 7202      cpl     rr1,%7202(r7)
1904: 5173 7401      pushl   @r7,%7401(r3)
1908: 5270 7001      subl    rr0,%7001(r7)
190C: 5370 7003      push    @r7,%7003
1910: 5475 7003      ldl     rr5,%7003(r7)
1914: 5576 7002      popl    %7002(r6),@r7
1918: 5677 7002      addl    rr7,%7002(r7)
191C: 5770 7001      pop     %7001,@r7
1920: 5870 7001      multl   rq0,%7001(r7)
1924: 5970 7001      mult    rr0,%7001(r7)
1928: 5A78 7901      divl    rq8,%7901(r7)
192C: 5071 7202      cpl     rr1,%7202(r7)
1930: 5173 7401      pushl   @r7,%7401(r3)
1934: 5270 7001      subl    rr0,%7001(r7)
1938: 5370 7003      push    @r7,%7003
193C: 5475 7003      ldl     rr5,%7003(r7)
1940: 5576 7002      popl    %7002(r6),@r7
1944: 5677 7002      addl    rr7,%7002(r7)
1948: 5770 7001      pop     %7001,@r7
194C: 5870 7001      multl   rq0,%7001(r7)
1950: 5970 7001      mult    rr0,%7001(r7)
1954: 5A78 7901      divl    rq8,%7901(r7)
1958: 5071 7202      cpl     rr1,%7202(r7)
195C: 5173 7401      pushl   @r7,%7401(r3)
1960: 5270 7001      subl    rr0,%7001(r7)
1964: 5370 7003      push    @r7,%7003
1968: 5475 7003      ldl     rr5,%7003(r7)
196C: 5576 7002      popl    %7002(r6),@r7
1970: 5677 7002      addl    rr7,%7002(r7)
1974: 5770 7001      pop     %7001,@r7
1978: 5B70 7001      div     rr0,%7001(r7)
197C: 2101 01CA      ld      r1,#%01ca
1980: 2FC1           ld      @r12,r1
1982: 6FC1 0004      ld      %0004(r12),r1
1986: 6FC1 0008      ld      %0008(r12),r1
198A: 6FC1 000C      ld      %000c(r12),r1
198E: 0301 0020      sub     r1,#%0020
1992: 6FC1 0010      ld      %0010(r12),r1
1996: 6FC1 0014      ld      %0014(r12),r1
199A: 6FC1 0018      ld      %0018(r12),r1
199E: 6FC1 001C      ld      %001c(r12),r1
19A2: 6FC1 0020      ld      %0020(r12),r1
19A6: 6FC1 0024      ld      %0024(r12),r1
19AA: 0301 0018      sub     r1,#%0018
19AE: 6FC1 0028      ld      %0028(r12),r1
19B2: 0301 0020      sub     r1,#%0020
19B6: 6FC1 002C      ld      %002c(r12),r1
19BA: 2101 047C      ld      r1,#%047c
19BE: 2100 0020      ld      r0,#%0020
19C2: 6FC1 0002      ld      %0002(r12),r1
19C6: 8101           add     r1,r0
19C8: 6FC1 0006      ld      %0006(r12),r1
19CC: 8101           add     r1,r0
19CE: 6FC1 000A      ld      %000a(r12),r1
19D2: 8101           add     r1,r0
19D4: 6FC1 000E      ld      %000e(r12),r1
19D8: 0301 0080      sub     r1,#%0080
19DC: 6FC1 0012      ld      %0012(r12),r1
19E0: 8101           add     r1,r0
19E2: 6FC1 0016      ld      %0016(r12),r1
19E6: 8101           add     r1,r0
19E8: 6FC1 001A      ld      %001a(r12),r1
19EC: 8101           add     r1,r0
19EE: 6FC1 001E      ld      %001e(r12),r1
19F2: 8101           add     r1,r0
19F4: 6FC1 0022      ld      %0022(r12),r1
19F8: 8101           add     r1,r0
19FA: 6FC1 0026      ld      %0026(r12),r1
19FE: 0301 004E      sub     r1,#%004e
1A02: 6FC1 002A      ld      %002a(r12),r1
1A06: 0301 0008      sub     r1,#%0008
1A0A: 6FC1 002E      ld      %002e(r12),r1
1A0E: 9E08           ret     
1A10: 2101 A068      ld      r1,#%a068
1A14: 2FD1           ld      @r13,r1
1A16: A910           inc     r1,1
1A18: 6FD1 0004      ld      %0004(r13),r1
1A1C: A910           inc     r1,1
1A1E: 6FD1 0008      ld      %0008(r13),r1
1A22: A910           inc     r1,1
1A24: 6FD1 000C      ld      %000c(r13),r1
1A28: 6FD1 0010      ld      %0010(r13),r1
1A2C: A910           inc     r1,1
1A2E: 6FD1 0014      ld      %0014(r13),r1
1A32: A910           inc     r1,1
1A34: 6FD1 0018      ld      %0018(r13),r1
1A38: A910           inc     r1,1
1A3A: 6FD1 001C      ld      %001c(r13),r1
1A3E: A910           inc     r1,1
1A40: 6FD1 0020      ld      %0020(r13),r1
1A44: 2101 A068      ld      r1,#%a068
1A48: 6FD1 0024      ld      %0024(r13),r1
1A4C: AB11           dec     r1,2
1A4E: 6FD1 0028      ld      %0028(r13),r1
1A52: A910           inc     r1,1
1A54: 6FD1 002C      ld      %002c(r13),r1
1A58: 6101 8820      ld      r1,%8820
1A5C: 8D08           clr     r0
1A5E: 1B00 0006      div     rr0,#%0006
1A62: A101           ld      r1,r0
1A64: 0100 9F34      add     r0,#%9f34
1A68: 0101 9F3A      add     r1,#%9f3a
1A6C: 6FD0 0002      ld      %0002(r13),r0
1A70: 6FD0 0006      ld      %0006(r13),r0
1A74: 6FD0 000A      ld      %000a(r13),r0
1A78: 6FD1 000E      ld      %000e(r13),r1
1A7C: 6FD0 0012      ld      %0012(r13),r0
1A80: 6FD0 0016      ld      %0016(r13),r0
1A84: 6FD0 001A      ld      %001a(r13),r0
1A88: 6FD0 001E      ld      %001e(r13),r0
1A8C: 6FD0 0022      ld      %0022(r13),r0
1A90: 6FD1 0026      ld      %0026(r13),r1
1A94: 6FD0 002A      ld      %002a(r13),r0
1A98: 6FD0 002E      ld      %002e(r13),r0
1A9C: 9E08           ret     
1A9E: 6101 8824      ld      r1,%8824
1AA2: A110           ld      r0,r1
1AA4: 6103 8834      ld      r3,%8834
1AA8: A134           ld      r4,r3
1AAA: B349 FFFF      sra     r4,#1
1AAE: A145           ld      r5,r4
1AB0: B359 FFFF      sra     r5,#1
1AB4: 8D02           neg     r0
1AB6: 0100 0182      add     r0,#%0182
1ABA: 8130           add     r0,r3
1ABC: 2FC0           ld      @r12,r0
1ABE: 6FC0 0028      ld      %0028(r12),r0
1AC2: 6FC0 0024      ld      %0024(r12),r0
1AC6: 6FC0 0054      ld      %0054(r12),r0
1ACA: A102           ld      r2,r0
1ACC: 8142           add     r2,r4
1ACE: 6FC2 002C      ld      %002c(r12),r2
1AD2: 6FC2 0050      ld      %0050(r12),r2
1AD6: 8130           add     r0,r3
1AD8: 6FC0 0004      ld      %0004(r12),r0
1ADC: 6FC0 0030      ld      %0030(r12),r0
1AE0: 6FC0 0020      ld      %0020(r12),r0
1AE4: 6FC0 004C      ld      %004c(r12),r0
1AE8: A102           ld      r2,r0
1AEA: 8152           add     r2,r5
1AEC: 6FC2 0034      ld      %0034(r12),r2
1AF0: 6FC2 0048      ld      %0048(r12),r2
1AF4: A102           ld      r2,r0
1AF6: 8142           add     r2,r4
1AF8: 6FC2 0038      ld      %0038(r12),r2
1AFC: 6FC2 0044      ld      %0044(r12),r2
1B00: 8130           add     r0,r3
1B02: 6FC0 0008      ld      %0008(r12),r0
1B06: 6FC0 001C      ld      %001c(r12),r0
1B0A: A102           ld      r2,r0
1B0C: 8152           add     r2,r5
1B0E: 6FC2 000C      ld      %000c(r12),r2
1B12: 6FC2 0018      ld      %0018(r12),r2
1B16: 8140           add     r0,r4
1B18: 6FC0 0010      ld      %0010(r12),r0
1B1C: 6FC0 0014      ld      %0014(r12),r0
1B20: 8142           add     r2,r4
1B22: 6FC2 003C      ld      %003c(r12),r2
1B26: 6FC2 0040      ld      %0040(r12),r2
1B2A: 8111           add     r1,r1
1B2C: 6100 882C      ld      r0,%882c
1B30: 4110 9700      add     r0,%9700(r1)
1B34: 8D02           neg     r0
1B36: 0100 053E      add     r0,#%053e
1B3A: A101           ld      r1,r0
1B3C: 6FC0 0016      ld      %0016(r12),r0
1B40: 8130           add     r0,r3
1B42: 6FC0 001A      ld      %001a(r12),r0
1B46: 6FC0 0042      ld      %0042(r12),r0
1B4A: A102           ld      r2,r0
1B4C: 8142           add     r2,r4
1B4E: 6FC2 004A      ld      %004a(r12),r2
1B52: 8130           add     r0,r3
1B54: 6FC0 001E      ld      %001e(r12),r0
1B58: 6FC0 004E      ld      %004e(r12),r0
1B5C: 8132           add     r2,r3
1B5E: 6FC2 0022      ld      %0022(r12),r2
1B62: 6FC2 0056      ld      %0056(r12),r2
1B66: 8130           add     r0,r3
1B68: 6FC0 0046      ld      %0046(r12),r0
1B6C: 6FC0 0026      ld      %0026(r12),r0
1B70: 8132           add     r2,r3
1B72: 6FC2 0052      ld      %0052(r12),r2
1B76: 8331           sub     r1,r3
1B78: 6FC1 0012      ld      %0012(r12),r1
1B7C: A112           ld      r2,r1
1B7E: 8342           sub     r2,r4
1B80: 6FC2 003E      ld      %003e(r12),r2
1B84: 8331           sub     r1,r3
1B86: 6FC1 000E      ld      %000e(r12),r1
1B8A: 6FC1 0036      ld      %0036(r12),r1
1B8E: 8332           sub     r2,r3
1B90: 6FC2 0032      ld      %0032(r12),r2
1B94: 8331           sub     r1,r3
1B96: 6FC1 000A      ld      %000a(r12),r1
1B9A: 6FC1 002A      ld      %002a(r12),r1
1B9E: 8332           sub     r2,r3
1BA0: 6FC2 003A      ld      %003a(r12),r2
1BA4: 6FC2 0006      ld      %0006(r12),r2
1BA8: 8331           sub     r1,r3
1BAA: 6FC1 002E      ld      %002e(r12),r1
1BAE: 6FC1 0002      ld      %0002(r12),r1
1BB2: 9E08           ret     
1BB4: A1D5           ld      r5,r13
1BB6: 2106 1C08      ld      r6,#%1c08
1BBA: 2107 000A      ld      r7,#%000a
1BBE: 6100 8834      ld      r0,%8834
1BC2: A507           set     r0,7
1BC4: A080           ldb     rh0,rl0
1BC6: 2068           ldb     rl0,@r6
1BC8: 2F50           ld      @r5,r0
1BCA: A960           inc     r6,1
1BCC: A953           inc     r5,4
1BCE: F785           djnz    r7,%1bc6
1BD0: 2107 000C      ld      r7,#%000c
1BD4: B201 FFFF      srlb    rh0,#1
1BD8: 2068           ldb     rl0,@r6
1BDA: 2F50           ld      @r5,r0
1BDC: A960           inc     r6,1
1BDE: A953           inc     r5,4
1BE0: F785           djnz    r7,%1bd8
1BE2: A1D5           ld      r5,r13
1BE4: A951           inc     r5,2
1BE6: 2101 002A      ld      r1,#%002a
1BEA: 6100 8834      ld      r0,%8834
1BEE: A507           set     r0,7
1BF0: A081           ldb     rh1,rl0
1BF2: 2107 000A      ld      r7,#%000a
1BF6: 2F51           ld      @r5,r1
1BF8: A953           inc     r5,4
1BFA: F783           djnz    r7,%1bf6
1BFC: 2107 000C      ld      r7,#%000c
1C00: 2F51           ld      @r5,r1
1C02: A953           inc     r5,4
1C04: F783           djnz    r7,%1c00
1C06: 9E08           ret     
1C08: 7071 7273      ldb     rh1,r7(r2)
1C0C: 7475 7677      lda     pr5,r7(r6)
1C10: F1F0           djnz    r1,%1b32
1C12: 5859 5C5D      multl   rq9,%5c5d(r5)
1C16: 5A5B DBDA      divl    rq11,%dbda(r5)
1C1A: 5E5F D9D8      jp      nc/uge,%d9d8(r5)
1C1E: 1310           .word   #%1310
1C20: 1410           ldl     rr0,@r1
1C22: 1510           .word   #%1510
1C24: 1610           addl    rr0,@r1
1C26: 1710           .word   #%1710
1C28: 1711           pop     @r1,@r1
1C2A: 1712           pop     @r2,@r1
1C2C: 1312           push    @r1,@r2
1C2E: 6101 8834      ld      r1,%8834
1C32: A114           ld      r4,r1
1C34: B311 FFFF      srl     r1,#1
1C38: 0101 0182      add     r1,#%0182
1C3C: 2FC1           ld      @r12,r1
1C3E: 8341           sub     r1,r4
1C40: 6FC1 0004      ld      %0004(r12),r1
1C44: A141           ld      r1,r4
1C46: B311 FFFD      srl     r1,#3
1C4A: 8D12           neg     r1
1C4C: 0101 04C0      add     r1,#%04c0
1C50: A110           ld      r0,r1
1C52: 6103 8886      ld      r3,%8886
1C56: A135           ld      r5,r3
1C58: 0105 0003      add     r5,#%0003
1C5C: 0703 0007      and     r3,#%0007
1C60: 0303 0004      sub     r3,#%0004
1C64: 8D34           test    r3
1C66: ED01           jr      pl,%1c6a
1C68: 8D32           neg     r3
1C6A: 603B 1CF4      ldb     rl3,%1cf4(r3)
1C6E: 9942           mult    rr2,r4
1C70: B331 FFF9      srl     r3,#7
1C74: A753           bit     r5,3
1C76: EE11           jr      ne/nz,%1c9a
1C78: A132           ld      r2,r3
1C7A: B321 0003      sll     r2,#3
1C7E: 8332           sub     r2,r3
1C80: B321 FFFC      srl     r2,#4
1C84: 8320           sub     r0,r2
1C86: A132           ld      r2,r3
1C88: B321 0002      sll     r2,#2
1C8C: 8132           add     r2,r3
1C8E: 8122           add     r2,r2
1C90: 8132           add     r2,r3
1C92: B321 FFFC      srl     r2,#4
1C96: 8321           sub     r1,r2
1C98: E80E           jr      %1cb6
1C9A: A132           ld      r2,r3
1C9C: B321 0003      sll     r2,#3
1CA0: 8132           add     r2,r3
1CA2: B321 FFFC      srl     r2,#4
1CA6: 8320           sub     r0,r2
1CA8: A132           ld      r2,r3
1CAA: B321 0002      sll     r2,#2
1CAE: 8132           add     r2,r3
1CB0: B321 FFFC      srl     r2,#4
1CB4: 8321           sub     r1,r2
1CB6: 6FC0 0002      ld      %0002(r12),r0
1CBA: 6FC1 0006      ld      %0006(r12),r1
1CBE: 9E08           ret     
1CC0: A753           bit     r5,3
1CC2: EE05           jr      ne/nz,%1cce
1CC4: 2100 0066      ld      r0,#%0066
1CC8: 2101 0067      ld      r1,#%0067
1CCC: E804           jr      %1cd6
1CCE: 2100 00E6      ld      r0,#%00e6
1CD2: 2101 00E7      ld      r1,#%00e7
1CD6: A0C0           ldb     rh0,rl4
1CD8: A50F           set     r0,15
1CDA: A001           ldb     rh1,rh0
1CDC: 2FD0           ld      @r13,r0
1CDE: 6FD1 0004      ld      %0004(r13),r1
1CE2: 2100 0034      ld      r0,#%0034
1CE6: A0B0           ldb     rh0,rl3
1CE8: A50F           set     r0,15
1CEA: 6FD0 0002      ld      %0002(r13),r0
1CEE: 6FD0 0006      ld      %0006(r13),r0
1CF2: 9E08           ret     
1CF4: 0130           add     r0,@r3
1CF6: 5A76 8000      divl    rq6,%8000(r7)
1CFA: 610D 8888      ld      r13,%8888
1CFE: ABD0           dec     r13,1
1D00: 9E06           ret     eq/z
1D02: 9E05           ret     mi
1D04: 210A 8900      ld      r10,#%8900
1D08: 210B 8908      ld      r11,#%8908
1D0C: A1DC           ld      r12,r13
1D0E: 61A0 0002      ld      r0,%0002(r10)
1D12: 43B0 0002      sub     r0,%0002(r11)
1D16: E906           jr      ge,%1d24
1D18: 1CA1 0007      ldm     r0,@r10,#8
1D1C: 1CA9 0403      ldm     @r10,r4,#4
1D20: 1CB9 0003      ldm     @r11,r0,#4
1D24: A9A7           inc     r10,8
1D26: A9B7           inc     r11,8
1D28: FC8E           djnz    r12,%1d0e
1D2A: FD94           djnz    r13,%1d04
1D2C: 9E08           ret     
1D2E: 61B0 001E      ld      r0,%001e(r11)
1D32: E821           jr      %1d76
1D34: 210A 000D      ld      r10,#%000d
1D38: 210B 8B00      ld      r11,#%8b00
1D3C: 210C 8900      ld      r12,#%8900
1D40: 8D88           clr     r8
1D42: 21B0           ld      r0,@r11
1D44: A70F           bit     r0,15
1D46: E61B           jr      eq/z,%1d7e
1D48: 61B1 0008      ld      r1,%0008(r11)
1D4C: 0101 003C      add     r1,#%003c
1D50: 0B01 0F3C      cp      r1,#%0f3c
1D54: EF14           jr      nc/uge,%1d7e
1D56: 8C08           clrb    rh0
1D58: 2FC0           ld      @r12,r0
1D5A: 61B1 0008      ld      r1,%0008(r11)
1D5E: 6FC1 0002      ld      %0002(r12),r1
1D62: 61B1 0006      ld      r1,%0006(r11)
1D66: 6FC1 0004      ld      %0004(r12),r1
1D6A: AB02           dec     r0,3
1D6C: 0B00 0002      cp      r0,#%0002
1D70: E7DE           jr      c/ult,%1d2e
1D72: 61B0 000C      ld      r0,%000c(r11)
1D76: 6FC0 0006      ld      %0006(r12),r0
1D7A: A9C7           inc     r12,8
1D7C: A980           inc     r8,1
1D7E: 010B 0020      add     r11,#%0020
1D82: FAA1           djnz    r10,%1d42
1D84: 2105 8D00      ld      r5,#%8d00
1D88: 2106 0018      ld      r6,#%0018
1D8C: 2107 0003      ld      r7,#%0003
1D90: 4D51 0004 0F00 cp      %0004(r5),#%0f00
1D96: EF13           jr      nc/uge,%1dbe
1D98: 0DC5 0005      ld      @r12,#%0005
1D9C: 6151 0004      ld      r1,%0004(r5)
1DA0: 6FC1 0002      ld      %0002(r12),r1
1DA4: 6151 0002      ld      r1,%0002(r5)
1DA8: 6FC1 0004      ld      %0004(r12),r1
1DAC: 2151           ld      r1,@r5
1DAE: 0701 000F      and     r1,#%000f
1DB2: 6FC1 0006      ld      %0006(r12),r1
1DB6: A9C7           inc     r12,8
1DB8: A980           inc     r8,1
1DBA: AB70           dec     r7,1
1DBC: E602           jr      eq/z,%1dc2
1DBE: A957           inc     r5,8
1DC0: F699           djnz    r6,%1d90
1DC2: 0DC5 0000      ld      @r12,#%0000
1DC6: 6F08 8888      ld      %8888,r8
1DCA: 9E08           ret     
1DCC: 6101 8188      ld      r1,%8188
1DD0: 8D12           neg     r1
1DD2: B319 FFFC      sra     r1,#4
1DD6: A110           ld      r0,r1
1DD8: B309 FFFE      sra     r0,#2
1DDC: 8101           add     r1,r0
1DDE: 6F01 8C66      ld      %8c66,r1
1DE2: 6100 8184      ld      r0,%8184
1DE6: B301 FFFD      srl     r0,#3
1DEA: 0700 0001      and     r0,#%0001
1DEE: 6101 81A0      ld      r1,%81a0
1DF2: C100           ldb     rh1,#%00
1DF4: 8481           orb     rh1,rl0
1DF6: 6F01 8C6C      ld      %8c6c,r1
1DFA: 9E08           ret     
1DFC: 210A 0007      ld      r10,#%0007
1E00: 210B 8B00      ld      r11,#%8b00
1E04: 21B7           ld      r7,@r11
1E06: A77F           bit     r7,15
1E08: E625           jr      eq/z,%1e54
1E0A: A1B0           ld      r0,r11
1E0C: B301 FFFC      srl     r0,#4
1E10: 0700 000C      and     r0,#%000c
1E14: 61B1 0002      ld      r1,%0002(r11)
1E18: 0701 0001      and     r1,#%0001
1E1C: 8498           orb     rl0,rl1
1E1E: 6FB0 000C      ld      %000c(r11),r0
1E22: 61B0 0002      ld      r0,%0002(r11)
1E26: 61B1 0004      ld      r1,%0004(r11)
1E2A: 61B2 000E      ld      r2,%000e(r11)
1E2E: 61B3 0010      ld      r3,%0010(r11)
1E32: 61B5 0012      ld      r5,%0012(r11)
1E36: B14A           exts    rr4
1E38: DFEF           calr    %1e5c
1E3A: DFBE           calr    %1ec0
1E3C: DF9C           calr    %1f06
1E3E: 6FB2 000E      ld      %000e(r11),r2
1E42: 6FB3 0010      ld      %0010(r11),r3
1E46: B325 FFFD      srll    rr2,#3
1E4A: 9620           addl    rr0,rr2
1E4C: 6FB0 0002      ld      %0002(r11),r0
1E50: 6FB1 0004      ld      %0004(r11),r1
1E54: 010B 0020      add     r11,#%0020
1E58: FAAB           djnz    r10,%1e04
1E5A: 9E08           ret     
1E5C: 0B07 8003      cp      r7,#%8003
1E60: E619           jr      eq/z,%1e94
1E62: 4DB4 001C      test    %001c(r11)
1E66: EE1E           jr      ne/nz,%1ea4
1E68: 61B6 0014      ld      r6,%0014(r11)
1E6C: 8B62           cp      r2,r6
1E6E: E90B           jr      ge,%1e86
1E70: 0B02 006E      cp      r2,#%006e
1E74: E906           jr      ge,%1e82
1E76: 4D01 81F0 000A cp      %81f0,#%000a
1E7C: E901           jr      ge,%1e80
1E7E: 9642           addl    rr2,rr4
1E80: 9644           addl    rr4,rr4
1E82: 9642           addl    rr2,rr4
1E84: 9E08           ret     
1E86: 0106 000A      add     r6,#%000a
1E8A: 8B62           cp      r2,r6
1E8C: 9E02           ret     le
1E8E: 9644           addl    rr4,rr4
1E90: 9242           subl    rr2,rr4
1E92: 9E08           ret     
1E94: 1602 FFFC F2C0 addl    rr2,#%fffcf2c0
1E9A: 9E0D           ret     pl
1E9C: 1402 0000 0000 ldl     rr2,#%00000000
1EA2: 9E08           ret     
1EA4: 61B5 001C      ld      r5,%001c(r11)
1EA8: 4DB5 001C 0000 ld      %001c(r11),#%0000
1EAE: B14A           exts    rr4
1EB0: B345 0005      slll    rr4,#5
1EB4: 9642           addl    rr2,rr4
1EB6: 9E0D           ret     pl
1EB8: 1402 0000 0000 ldl     rr2,#%00000000
1EBE: 9E08           ret     
1EC0: 4DB4 001A      test    %001a(r11)
1EC4: 9E06           ret     eq/z
1EC6: E510           jr      mi,%1ee8
1EC8: 61B6 001A      ld      r6,%001a(r11)
1ECC: B369 FFFA      sra     r6,#6
1ED0: A960           inc     r6,1
1ED2: 41B6 0006      add     r6,%0006(r11)
1ED6: 6FB6 0006      ld      %0006(r11),r6
1EDA: 0B06 0300      cp      r6,#%0300
1EDE: 9E01           ret     lt
1EE0: 4DB5 001A 0000 ld      %001a(r11),#%0000
1EE6: 9E08           ret     
1EE8: 61B6 001A      ld      r6,%001a(r11)
1EEC: B369 FFFA      sra     r6,#6
1EF0: 41B6 0006      add     r6,%0006(r11)
1EF4: 6FB6 0006      ld      %0006(r11),r6
1EF8: 0B06 FD00      cp      r6,#%fd00
1EFC: 9E09           ret     ge
1EFE: 4DB5 001A 0000 ld      %001a(r11),#%0000
1F04: 9E08           ret     
1F06: 91F0           pushl   @r15,rr0
1F08: 91F2           pushl   @r15,rr2
1F0A: A009           ldb     rl1,rh0
1F0C: 8C18           clrb    rh1
1F0E: 8D08           clr     r0
1F10: A894           incb    rl1,5
1F12: 2103 0004      ld      r3,#%0004
1F16: 601A 48E0      ldb     rl2,%48e0(r1)
1F1A: B120           extsb   r2
1F1C: 8D24           test    r2
1F1E: ED01           jr      pl,%1f22
1F20: 8D22           neg     r2
1F22: 8120           add     r0,r2
1F24: A890           incb    rl1,1
1F26: F389           djnz    r3,%1f16
1F28: B301 FFFF      srl     r0,#1
1F2C: 8D00           com     r0
1F2E: 0700 00FF      and     r0,#%00ff
1F32: A1B2           ld      r2,r11
1F34: 8D20           com     r2
1F36: 0702 00E0      and     r2,#%00e0
1F3A: B321 FFFD      srl     r2,#3
1F3E: 8120           add     r0,r2
1F40: B321 FFFF      srl     r2,#1
1F44: 8120           add     r0,r2
1F46: 6102 818C      ld      r2,%818c
1F4A: B321 FFFE      srl     r2,#2
1F4E: 8120           add     r0,r2
1F50: B321 FFFF      srl     r2,#1
1F54: 8120           add     r0,r2
1F56: 6102 81F0      ld      r2,%81f0
1F5A: B321 FFFE      srl     r2,#2
1F5E: 8120           add     r0,r2
1F60: B321 FFFF      srl     r2,#1
1F64: 8120           add     r0,r2
1F66: 6707 8148      bit     %8148,7
1F6A: E60E           jr      eq/z,%1f88
1F6C: 0300 00B4      sub     r0,#%00b4
1F70: 0B00 001E      cp      r0,#%001e
1F74: E106           jr      lt,%1f82
1F76: 0B00 0096      cp      r0,#%0096
1F7A: E205           jr      le,%1f86
1F7C: 2100 0096      ld      r0,#%0096
1F80: E802           jr      %1f86
1F82: 2100 001E      ld      r0,#%001e
1F86: E80D           jr      %1fa2
1F88: 0300 008C      sub     r0,#%008c
1F8C: 0B00 0032      cp      r0,#%0032
1F90: E106           jr      lt,%1f9e
1F92: 0B00 00D2      cp      r0,#%00d2
1F96: E205           jr      le,%1fa2
1F98: 2100 00D2      ld      r0,#%00d2
1F9C: E802           jr      %1fa2
1F9E: 2100 0032      ld      r0,#%0032
1FA2: 6FB0 0014      ld      %0014(r11),r0
1FA6: 95F2           popl    rr2,@r15
1FA8: 95F0           popl    rr0,@r15
1FAA: 9E08           ret     
1FAC: 6101 8294      ld      r1,%8294
1FB0: 0B01 0001      cp      r1,#%0001
1FB4: E623           jr      eq/z,%1ffc
1FB6: 0B01 FFFF      cp      r1,#%ffff
1FBA: 9E0E           ret     ne/nz
1FBC: 610C 8840      ld      r12,%8840
1FC0: 070C 0007      and     r12,#%0007
1FC4: EE01           jr      ne/nz,%1fc8
1FC6: A9C0           inc     r12,1
1FC8: 210B 8BC0      ld      r11,#%8bc0
1FCC: 67BF 0000      bit     %0000(r11),15
1FD0: EE11           jr      ne/nz,%1ff4
1FD2: 6101 8184      ld      r1,%8184
1FD6: 0301 003A      sub     r1,#%003a
1FDA: 6FB1 0002      ld      %0002(r11),r1
1FDE: 5F00 004E      call    %004e
1FE2: 0700 003F      and     r0,#%003f
1FE6: 0100 0064      add     r0,#%0064
1FEA: 6FB0 000E      ld      %000e(r11),r0
1FEE: 4DB5 0000 8002 ld      %0000(r11),#%8002
1FF4: 030B 0020      sub     r11,#%0020
1FF8: FC97           djnz    r12,%1fcc
1FFA: 9E08           ret     
1FFC: 6101 81F0      ld      r1,%81f0
2000: 0B01 000F      cp      r1,#%000f
2004: 9E02           ret     le
2006: 610C 8840      ld      r12,%8840
200A: 070C 0007      and     r12,#%0007
200E: EE01           jr      ne/nz,%2012
2010: A9C0           inc     r12,1
2012: 210B 8BC0      ld      r11,#%8bc0
2016: 67BF 0000      bit     %0000(r11),15
201A: EE38           jr      ne/nz,%208c
201C: 4D04 889C      test    %889c
2020: EE25           jr      ne/nz,%206c
2022: 6101 818C      ld      r1,%818c
2026: 0B01 008C      cp      r1,#%008c
202A: E924           jr      ge,%2074
202C: 6102 8C66      ld      r2,%8c66
2030: 8D24           test    r2
2032: ED01           jr      pl,%2036
2034: 8D22           neg     r2
2036: 0B02 0032      cp      r2,#%0032
203A: E11C           jr      lt,%2074
203C: 4D04 8C66      test    %8c66
2040: 2103 0330      ld      r3,#%0330
2044: E501           jr      mi,%2048
2046: 8D32           neg     r3
2048: 6FB3 0006      ld      %0006(r11),r3
204C: 0101 0046      add     r1,#%0046
2050: 6FB1 000E      ld      %000e(r11),r1
2054: 6102 8184      ld      r2,%8184
2058: 0302 003A      sub     r2,#%003a
205C: 6FB2 0002      ld      %0002(r11),r2
2060: 0DB5 8002      ld      @r11,#%8002
2064: 4D05 889C 0005 ld      %889c,#%0005
206A: E810           jr      %208c
206C: 6B00 889C      dec     %889c,1
2070: 6101 818C      ld      r1,%818c
2074: 6102 8184      ld      r2,%8184
2078: 0102 1000      add     r2,#%1000
207C: 6FB2 0002      ld      %0002(r11),r2
2080: B311 FFFF      srl     r1,#1
2084: 6FB1 000E      ld      %000e(r11),r1
2088: 0DB5 8002      ld      @r11,#%8002
208C: 030B 0020      sub     r11,#%0020
2090: FCBE           djnz    r12,%2016
2092: 9E08           ret     
2094: 6101 81F0      ld      r1,%81f0
2098: AB19           dec     r1,10
209A: 9E05           ret     mi
209C: A910           inc     r1,1
209E: 0B01 0028      cp      r1,#%0028
20A2: E202           jr      le,%20a8
20A4: 2101 0028      ld      r1,#%0028
20A8: A110           ld      r0,r1
20AA: 8111           add     r1,r1
20AC: 8111           add     r1,r1
20AE: 8101           add     r1,r0
20B0: 8111           add     r1,r1
20B2: 8111           add     r1,r1
20B4: 8300           sub     r0,r0
20B6: A117           ld      r7,r1
20B8: B311 FFFF      srl     r1,#1
20BC: A118           ld      r8,r1
20BE: B311 FFFF      srl     r1,#1
20C2: A119           ld      r9,r1
20C4: B311 FFFF      srl     r1,#1
20C8: A11A           ld      r10,r1
20CA: B311 FFFD      srl     r1,#3
20CE: A11B           ld      r11,r1
20D0: A9B0           inc     r11,1
20D2: 210C 0006      ld      r12,#%0006
20D6: 210D 8B00      ld      r13,#%8b00
20DA: 93FC           push    @r15,r12
20DC: 0DD1 8002      cp      @r13,#%8002
20E0: EE44           jr      ne/nz,%216a
20E2: 4DD4 0012      test    %0012(r13)
20E6: E641           jr      eq/z,%216a
20E8: A1DE           ld      r14,r13
20EA: 010E 0020      add     r14,#%0020
20EE: 61D4 0002      ld      r4,%0002(r13)
20F2: 61D5 0006      ld      r5,%0006(r13)
20F6: 61D6 000E      ld      r6,%000e(r13)
20FA: 0DE1 8002      cp      @r14,#%8002
20FE: EE32           jr      ne/nz,%2164
2100: A141           ld      r1,r4
2102: 43E1 0002      sub     r1,%0002(r14)
2106: 8181           add     r1,r8
2108: 8B71           cp      r1,r7
210A: EF2C           jr      nc/uge,%2164
210C: A152           ld      r2,r5
210E: 43E2 0006      sub     r2,%0006(r14)
2112: 0102 0320      add     r2,#%0320
2116: 0B02 0640      cp      r2,#%0640
211A: EF24           jr      nc/uge,%2164
211C: A163           ld      r3,r6
211E: 43E3 000E      sub     r3,%000e(r14)
2122: 83A1           sub     r1,r10
2124: E514           jr      mi,%214e
2126: 8391           sub     r1,r9
2128: E525           jr      mi,%2174
212A: 83A1           sub     r1,r10
212C: E52D           jr      mi,%2188
212E: 83A1           sub     r1,r10
2130: E53A           jr      mi,%21a6
2132: 8391           sub     r1,r9
2134: E547           jr      mi,%21c4
2136: 0B03 FFF1      cp      r3,#%fff1
213A: EA14           jr      gt,%2164
213C: 4DE4 001A      test    %001a(r14)
2140: EE11           jr      ne/nz,%2164
2142: 61E0 0006      ld      r0,%0006(r14)
2146: 8D02           neg     r0
2148: 6FE0 001A      ld      %001a(r14),r0
214C: E80B           jr      %2164
214E: 0B03 000F      cp      r3,#%000f
2152: E108           jr      lt,%2164
2154: 4DD4 001A      test    %001a(r13)
2158: EE05           jr      ne/nz,%2164
215A: 61D0 0006      ld      r0,%0006(r13)
215E: 8D02           neg     r0
2160: 6FD0 001A      ld      %001a(r13),r0
2164: 010E 0020      add     r14,#%0020
2168: FCB8           djnz    r12,%20fa
216A: 010D 0020      add     r13,#%0020
216E: 97FC           pop     r12,@r15
2170: FCCC           djnz    r12,%20da
2172: 9E08           ret     
2174: 0B03 FFEC      cp      r3,#%ffec
2178: E2F5           jr      le,%2164
217A: 4DD5 001C 8AD0 ld      %001c(r13),#%8ad0
2180: 4DE5 001C 4E20 ld      %001c(r14),#%4e20
2186: E8EE           jr      %2164
2188: 0B03 FFF1      cp      r3,#%fff1
218C: E2EB           jr      le,%2164
218E: 61E0 000E      ld      r0,%000e(r14)
2192: 81B0           add     r0,r11
2194: 6FE0 000E      ld      %000e(r14),r0
2198: 83B0           sub     r0,r11
219A: 83B0           sub     r0,r11
219C: ED01           jr      pl,%21a0
219E: 8D08           clr     r0
21A0: 6FD0 000E      ld      %000e(r13),r0
21A4: E8DF           jr      %2164
21A6: 0B03 000F      cp      r3,#%000f
21AA: E9DC           jr      ge,%2164
21AC: 61D0 000E      ld      r0,%000e(r13)
21B0: 81B0           add     r0,r11
21B2: 6FD0 000E      ld      %000e(r13),r0
21B6: 83B0           sub     r0,r11
21B8: 83B0           sub     r0,r11
21BA: ED01           jr      pl,%21be
21BC: 8D08           clr     r0
21BE: 6FE0 000E      ld      %000e(r14),r0
21C2: E8D0           jr      %2164
21C4: 0B03 0014      cp      r3,#%0014
21C8: E9CD           jr      ge,%2164
21CA: 4DD5 001C 4E20 ld      %001c(r13),#%4e20
21D0: 4DE5 001C 8AD0 ld      %001c(r14),#%8ad0
21D6: E8C6           jr      %2164
21D8: 210A 000B      ld      r10,#%000b
21DC: 210B 8B00      ld      r11,#%8b00
21E0: 61B0 0002      ld      r0,%0002(r11)
21E4: 4300 8184      sub     r0,%8184
21E8: 6FB0 0008      ld      %0008(r11),r0
21EC: 61B0 0006      ld      r0,%0006(r11)
21F0: 4300 8C66      sub     r0,%8c66
21F4: 6FB0 000A      ld      %000a(r11),r0
21F8: 010B 0020      add     r11,#%0020
21FC: FA8F           djnz    r10,%21e0
21FE: 010B 0020      add     r11,#%0020
2202: 61B0 0002      ld      r0,%0002(r11)
2206: 4300 8184      sub     r0,%8184
220A: 6FB0 0008      ld      %0008(r11),r0
220E: 61B0 0006      ld      r0,%0006(r11)
2212: 4300 8C66      sub     r0,%8c66
2216: 6FB0 000A      ld      %000a(r11),r0
221A: 2105 8D00      ld      r5,#%8d00
221E: 2106 0018      ld      r6,#%0018
2222: 6102 8184      ld      r2,%8184
2226: 6103 8C66      ld      r3,%8c66
222A: 2151           ld      r1,@r5
222C: 8321           sub     r1,r2
222E: 6F51 0004      ld      %0004(r5),r1
2232: 6151 0002      ld      r1,%0002(r5)
2236: 8331           sub     r1,r3
2238: 6F51 0006      ld      %0006(r5),r1
223C: A957           inc     r5,8
223E: F68B           djnz    r6,%222a
2240: 210A 0007      ld      r10,#%0007
2244: 210B 8B00      ld      r11,#%8b00
2248: 27BF           bit     @r11,15
224A: E619           jr      eq/z,%227e
224C: 61B1 0008      ld      r1,%0008(r11)
2250: 0B01 FED4      cp      r1,#%fed4
2254: E11F           jr      lt,%2294
2256: 0B01 FFC4      cp      r1,#%ffc4
225A: E115           jr      lt,%2286
225C: 0B01 1200      cp      r1,#%1200
2260: E10E           jr      lt,%227e
2262: 5F00 004E      call    %004e
2266: 0700 0001      and     r0,#%0001
226A: E61B           jr      eq/z,%22a2
226C: 4DB5 001C 8AD0 ld      %001c(r11),#%8ad0
2272: 2101 FF00      ld      r1,#%ff00
2276: 41B1 0002      add     r1,%0002(r11)
227A: 6FB1 0002      ld      %0002(r11),r1
227E: 010B 0020      add     r11,#%0020
2282: FA9E           djnz    r10,%2248
2284: 9E08           ret     
2286: 61B0 000A      ld      r0,%000a(r11)
228A: 0100 0BB8      add     r0,#%0bb8
228E: 0B00 1770      cp      r0,#%1770
2292: EFF5           jr      nc/uge,%227e
2294: 23BF           res     @r11,15
2296: 4D04 8296      test    %8296
229A: E6F1           jr      eq/z,%227e
229C: 6900 828A      inc     %828a,1
22A0: E8EE           jr      %227e
22A2: 23BF           res     @r11,15
22A4: E8EC           jr      %227e
22A6: 0DB1 8002      cp      @r11,#%8002
22AA: 9E0E           ret     ne/nz
22AC: 61B0 0008      ld      r0,%0008(r11)
22B0: 0300 001A      sub     r0,#%001a
22B4: 0B00 FFDA      cp      r0,#%ffda
22B8: E12F           jr      lt,%2318
22BA: 0B00 0038      cp      r0,#%0038
22BE: 9E0A           ret     gt
22C0: 61B1 000A      ld      r1,%000a(r11)
22C4: 8D14           test    r1
22C6: ED01           jr      pl,%22ca
22C8: 8D12           neg     r1
22CA: 0B01 02BC      cp      r1,#%02bc
22CE: 9E0A           ret     gt
22D0: 0B00 0026      cp      r0,#%0026
22D4: EA28           jr      gt,%2326
22D6: 4D05 81A6 0001 ld      %81a6,#%0001
22DC: 4DB4 000A      test    %000a(r11)
22E0: E503           jr      mi,%22e8
22E2: 4D05 81A6 FFFF ld      %81a6,#%ffff
22E8: 0B01 01F4      cp      r1,#%01f4
22EC: EA23           jr      gt,%2334
22EE: 0DB5 8003      ld      @r11,#%8003
22F2: 4DB5 001E 07FF ld      %001e(r11),#%07ff
22F8: 4D01 8C60 8004 cp      %8c60,#%8004
22FE: 9E06           ret     eq/z
2300: 4D05 8C60 8004 ld      %8c60,#%8004
2306: 4D08 8C7C      clr     %8c7c
230A: 4D04 8104      test    %8104
230E: 9E0E           ret     ne/nz
2310: 4D05 80E2 0005 ld      %80e2,#%0005
2316: 9E08           ret     
2318: 0B01 0384      cp      r1,#%0384
231C: 9E0A           ret     gt
231E: 4DB5 001C E4A8 ld      %001c(r11),#%e4a8
2324: 9E08           ret     
2326: 4D01 81F0 000F cp      %81f0,#%000f
232C: E103           jr      lt,%2334
232E: 4DB5 001C 1B58 ld      %001c(r11),#%1b58
2334: 4D04 81BC      test    %81bc
2338: 9E0E           ret     ne/nz
233A: 4D05 81BC 0037 ld      %81bc,#%0037
2340: 9E08           ret     
2342: 4D04 8296      test    %8296
2346: 9E06           ret     eq/z
2348: 210A 0007      ld      r10,#%0007
234C: 210B 8B00      ld      r11,#%8b00
2350: D056           calr    %22a6
2352: 010B 0020      add     r11,#%0020
2356: FA84           djnz    r10,%2350
2358: 6101 8C60      ld      r1,%8c60
235C: 0B01 8001      cp      r1,#%8001
2360: 9E0E           ret     ne/nz
2362: 4D04 889E      test    %889e
2366: EE18           jr      ne/nz,%2398
2368: DFE6           calr    %239e
236A: DFC2           calr    %23e8
236C: 210B 8BE0      ld      r11,#%8be0
2370: 21B0           ld      r0,@r11
2372: 0B00 8006      cp      r0,#%8006
2376: 9E0E           ret     ne/nz
2378: 61B1 0008      ld      r1,%0008(r11)
237C: 0101 0014      add     r1,#%0014
2380: 0301 0028      sub     r1,#%0028
2384: 9E0F           ret     nc/uge
2386: 61B1 000A      ld      r1,%000a(r11)
238A: 8D14           test    r1
238C: ED01           jr      pl,%2390
238E: 8D12           neg     r1
2390: 0B01 0600      cp      r1,#%0600
2394: E916           jr      ge,%23c2
2396: 9E08           ret     
2398: 6B00 889E      dec     %889e,1
239C: 9E08           ret     
239E: 2105 8D00      ld      r5,#%8d00
23A2: 2106 0018      ld      r6,#%0018
23A6: 6151 0004      ld      r1,%0004(r5)
23AA: 0101 0014      add     r1,#%0014
23AE: 0301 0028      sub     r1,#%0028
23B2: EF17           jr      nc/uge,%23e2
23B4: 6151 0006      ld      r1,%0006(r5)
23B8: 0101 0384      add     r1,#%0384
23BC: 0301 0708      sub     r1,#%0708
23C0: EF10           jr      nc/uge,%23e2
23C2: 4D05 8C60 8004 ld      %8c60,#%8004
23C8: 4D05 8C7C 0000 ld      %8c7c,#%0000
23CE: 4D05 889E 0096 ld      %889e,#%0096
23D4: 4D04 8104      test    %8104
23D8: 9E0E           ret     ne/nz
23DA: 4D05 80E2 0005 ld      %80e2,#%0005
23E0: 9E08           ret     
23E2: A957           inc     r5,8
23E4: F6A0           djnz    r6,%23a6
23E6: 9E08           ret     
23E8: 210B 8C00      ld      r11,#%8c00
23EC: 210A 0003      ld      r10,#%0003
23F0: 21B0           ld      r0,@r11
23F2: 0B00 8007      cp      r0,#%8007
23F6: EE41           jr      ne/nz,%247a
23F8: 61B1 0008      ld      r1,%0008(r11)
23FC: 0301 0014      sub     r1,#%0014
2400: 0301 00A0      sub     r1,#%00a0
2404: EF37           jr      nc/uge,%2474
2406: 61B1 000A      ld      r1,%000a(r11)
240A: 0101 03E8      add     r1,#%03e8
240E: 0301 07D0      sub     r1,#%07d0
2412: EF30           jr      nc/uge,%2474
2414: 4D04 81BC      test    %81bc
2418: E515           jr      mi,%2444
241A: 6103 818C      ld      r3,%818c
241E: 0B03 00FF      cp      r3,#%00ff
2422: E702           jr      c/ult,%2428
2424: 2103 00FF      ld      r3,#%00ff
2428: A131           ld      r1,r3
242A: 9912           mult    rr2,r1
242C: B325 FFFA      srll    rr2,#6
2430: A131           ld      r1,r3
2432: B311 FFFF      srl     r1,#1
2436: 8113           add     r3,r1
2438: 0703 1FC0      and     r3,#%1fc0
243C: 4103 81BC      add     r3,%81bc
2440: 6F03 81BC      ld      %81bc,r3
2444: 4D04 8104      test    %8104
2448: EE11           jr      ne/nz,%246c
244A: 6702 80EE      bit     %80ee,2
244E: EE0E           jr      ne/nz,%246c
2450: 4DB4 001E      test    %001e(r11)
2454: EE0B           jr      ne/nz,%246c
2456: 6502 80EE      set     %80ee,2
245A: 4DB5 001E 0001 ld      %001e(r11),#%0001
2460: 61B1 000A      ld      r1,%000a(r11)
2464: B319 FFFA      sra     r1,#6
2468: 6F01 80FA      ld      %80fa,r1
246C: 010B 0020      add     r11,#%0020
2470: FAC1           djnz    r10,%23f0
2472: 9E08           ret     
2474: 4DB8 001E      clr     %001e(r11)
2478: E8F9           jr      %246c
247A: 0B00 800C      cp      r0,#%800c
247E: EEF6           jr      ne/nz,%246c
2480: 61B1 0008      ld      r1,%0008(r11)
2484: 0101 0014      add     r1,#%0014
2488: 0301 0028      sub     r1,#%0028
248C: EFEF           jr      nc/uge,%246c
248E: 61B1 000A      ld      r1,%000a(r11)
2492: 8D14           test    r1
2494: ED01           jr      pl,%2498
2496: 8D12           neg     r1
2498: 0B01 0600      cp      r1,#%0600
249C: E1E7           jr      lt,%246c
249E: E891           jr      %23c2
24A0: 0DB5 0002      ld      @r11,#%0002
24A4: E810           jr      %24c6
24A6: 210A 0007      ld      r10,#%0007
24AA: 210B 8B00      ld      r11,#%8b00
24AE: 21B0           ld      r0,@r11
24B0: 8C08           clrb    rh0
24B2: 0B00 0003      cp      r0,#%0003
24B6: EE07           jr      ne/nz,%24c6
24B8: 61B0 001E      ld      r0,%001e(r11)
24BC: 0300 0014      sub     r0,#%0014
24C0: E5EF           jr      mi,%24a0
24C2: 6FB0 001E      ld      %001e(r11),r0
24C6: 010B 0020      add     r11,#%0020
24CA: FA8F           djnz    r10,%24ae
24CC: 6100 8C60      ld      r0,%8c60
24D0: 0A08 0404      cpb     rl0,#%04
24D4: 9E0E           ret     ne/nz
24D6: 6100 821C      ld      r0,%821c
24DA: 0300 0050      sub     r0,#%0050
24DE: ED01           jr      pl,%24e2
24E0: 8D08           clr     r0
24E2: 6F00 821C      ld      %821c,r0
24E6: 4D08 8220      clr     %8220
24EA: 4D08 8190      clr     %8190
24EE: 4D08 821E      clr     %821e
24F2: 4D08 8480      clr     %8480
24F6: 6900 8C7C      inc     %8c7c,1
24FA: 6101 8C7C      ld      r1,%8c7c
24FE: 6018 5B10      ldb     rl0,%5b10(r1)
2502: 8C08           clrb    rh0
2504: 0B00 0007      cp      r0,#%0007
2508: E20D           jr      le,%2524
250A: A080           ldb     rh0,rl0
250C: 0608 0F0F      andb    rl0,#%0f
2510: B201 FFFE      srlb    rh0,#2
2514: 0400 0101      orb     rh0,#%01
2518: 6F00 8C7E      ld      %8c7e,r0
251C: 4D05 8C60 8004 ld      %8c60,#%8004
2522: 9E08           ret     
2524: A102           ld      r2,r0
2526: 8122           add     r2,r2
2528: 6122 252E      ld      r2,%252e(r2)
252C: 1E28           jp      @rr2
252E: 253E           set     @r3,14
2530: 254C           set     @r4,12
2532: 2552           set     @r5,2
2534: 2558           set     @r5,8
2536: 255E           set     @r5,14
2538: 2580           set     @r8,0
253A: 2564           set     @r6,4
253C: 256C           set     @r6,12
253E: 4D05 8C7E 000F ld      %8c7e,#%000f
2544: 4D05 8C60 8004 ld      %8c60,#%8004
254A: 9E08           ret     
254C: 2102 9F80      ld      r2,#%9f80
2550: E823           jr      %2598
2552: 2102 9F90      ld      r2,#%9f90
2556: E820           jr      %2598
2558: 2102 9FA0      ld      r2,#%9fa0
255C: E81D           jr      %2598
255E: 2102 9FB0      ld      r2,#%9fb0
2562: E81A           jr      %2598
2564: 4D05 81FE 0001 ld      %81fe,#%0001
256A: 9E08           ret     
256C: 4D05 8C60 8001 ld      %8c60,#%8001
2572: 4D08 825C      clr     %825c
2576: 4D08 8218      clr     %8218
257A: 4D08 821C      clr     %821c
257E: 9E08           ret     
2580: 4D05 8C60 0004 ld      %8c60,#%0004
2586: 2102 9F8E      ld      r2,#%9f8e
258A: 2101 0008      ld      r1,#%0008
258E: 0D28           clr     @r2
2590: 0102 0010      add     r2,#%0010
2594: F184           djnz    r1,%258e
2596: 9E08           ret     
2598: 4D25 000E 0001 ld      %000e(r2),#%0001
259E: 5F00 004E      call    %004e
25A2: B309 FFFE      sra     r0,#2
25A6: 6F20 0002      ld      %0002(r2),r0
25AA: B309 FFF7      sra     r0,#9
25AE: 2F20           ld      @r2,r0
25B0: A923           inc     r2,4
25B2: 5F00 004E      call    %004e
25B6: B301 FFFE      srl     r0,#2
25BA: 6F20 0002      ld      %0002(r2),r0
25BE: B301 FFF7      srl     r0,#9
25C2: 2F20           ld      @r2,r0
25C4: A923           inc     r2,4
25C6: 5F00 004E      call    %004e
25CA: B301 FFFE      srl     r0,#2
25CE: 0100 1000      add     r0,#%1000
25D2: 6F20 0002      ld      %0002(r2),r0
25D6: B301 FFF6      srl     r0,#10
25DA: 2F20           ld      @r2,r0
25DC: 0102 0038      add     r2,#%0038
25E0: 2104 0004      ld      r4,#%0004
25E4: 4D25 000E 0001 ld      %000e(r2),#%0001
25EA: 5F00 004E      call    %004e
25EE: B309 FFFE      sra     r0,#2
25F2: 6F20 0002      ld      %0002(r2),r0
25F6: B309 FFF7      sra     r0,#9
25FA: 2F20           ld      @r2,r0
25FC: A923           inc     r2,4
25FE: 5F00 004E      call    %004e
2602: A50F           set     r0,15
2604: B309 FFFE      sra     r0,#2
2608: 6F20 0002      ld      %0002(r2),r0
260C: B309 FFF7      sra     r0,#9
2610: 2F20           ld      @r2,r0
2612: A923           inc     r2,4
2614: 5F00 004E      call    %004e
2618: B301 FFFE      srl     r0,#2
261C: 0100 1000      add     r0,#%1000
2620: 6F20 0002      ld      %0002(r2),r0
2624: B301 FFF6      srl     r0,#10
2628: 2F20           ld      @r2,r0
262A: 9E08           ret     
262C: 6700 80F0      bit     %80f0,0
2630: E65D           jr      eq/z,%26ec
2632: 210A 0007      ld      r10,#%0007
2636: 8D88           clr     r8
2638: 210B 8B00      ld      r11,#%8b00
263C: 1404 0000 FDE8 ldl     rr4,#%0000fde8
2642: 61B0 0000      ld      r0,%0000(r11)
2646: 0B00 8002      cp      r0,#%8002
264A: EE14           jr      ne/nz,%2674
264C: 61B1 0008      ld      r1,%0008(r11)
2650: 9910           mult    rr0,r1
2652: 61B3 000A      ld      r3,%000a(r11)
2656: B339 FFFD      sra     r3,#3
265A: 9932           mult    rr2,r3
265C: 9620           addl    rr0,rr2
265E: 9040           cpl     rr0,rr4
2660: E909           jr      ge,%2674
2662: 9404           ldl     rr4,rr0
2664: 61B6 0008      ld      r6,%0008(r11)
2668: 61B7 000A      ld      r7,%000a(r11)
266C: 61B9 000E      ld      r9,%000e(r11)
2670: 2108 0001      ld      r8,#%0001
2674: 010B 0020      add     r11,#%0020
2678: FA9C           djnz    r10,%2642
267A: 8D84           test    r8
267C: E637           jr      eq/z,%26ec
267E: B369 FFFC      sra     r6,#4
2682: B379 FFF9      sra     r7,#7
2686: 0B06 FFF0      cp      r6,#%fff0
268A: E106           jr      lt,%2698
268C: 0B06 000F      cp      r6,#%000f
2690: E205           jr      le,%269c
2692: 2106 000F      ld      r6,#%000f
2696: E802           jr      %269c
2698: 2106 FFF0      ld      r6,#%fff0
269C: 0B07 FFF0      cp      r7,#%fff0
26A0: E106           jr      lt,%26ae
26A2: 0B07 000F      cp      r7,#%000f
26A6: E205           jr      le,%26b2
26A8: 2107 000F      ld      r7,#%000f
26AC: E802           jr      %26b2
26AE: 2107 FFF0      ld      r7,#%fff0
26B2: 8D62           neg     r6
26B4: 8D72           neg     r7
26B6: 6F06 80F8      ld      %80f8,r6
26BA: 6F07 80F6      ld      %80f6,r7
26BE: A191           ld      r1,r9
26C0: 0B01 006E      cp      r1,#%006e
26C4: E202           jr      le,%26ca
26C6: B319 FFFF      sra     r1,#1
26CA: 4309 818C      sub     r9,%818c
26CE: B399 FFFC      sra     r9,#4
26D2: 8D64           test    r6
26D4: ED01           jr      pl,%26d8
26D6: 8D92           neg     r9
26D8: 0109 0190      add     r9,#%0190
26DC: 9990           mult    rr0,r9
26DE: 1B00 00C8      div     rr0,#%00c8
26E2: 6F01 80FC      ld      %80fc,r1
26E6: 6501 80F0      set     %80f0,1
26EA: 9E08           ret     
26EC: 6301 80F0      res     %80f0,1
26F0: 9E08           ret     
26F2: 2102 1024      ld      r2,#%1024
26F6: E802           jr      %26fc
26F8: 2102 0124      ld      r2,#%0124
26FC: 2101 98BE      ld      r1,#%98be
2700: 2103 0040      ld      r3,#%0040
2704: 2100 001C      ld      r0,#%001c
2708: 2F12           ld      @r1,r2
270A: 8131           add     r1,r3
270C: F083           djnz    r0,%2708
270E: 9E08           ret     
2710: DC1E           calr    %2ed6
2712: 2103 005A      ld      r3,#%005a
2716: 6707 8148      bit     %8148,7
271A: E602           jr      eq/z,%2720
271C: 2103 0050      ld      r3,#%0050
2720: 6101 821C      ld      r1,%821c
2724: 0101 01F4      add     r1,#%01f4
2728: 1900 001E      mult    rr0,#%001e
272C: 9B30           div     rr0,r3
272E: E607           jr      eq/z,%273e
2730: 0501 0001      or      r1,#%0001
2734: 0B01 1000      cp      r1,#%1000
2738: E102           jr      lt,%273e
273A: 2101 0FFF      ld      r1,#%0fff
273E: A113           ld      r3,r1
2740: A0B3           ldb     rh3,rl3
2742: 6F03 80F2      ld      %80f2,r3
2746: B311 FFFA      srl     r1,#6
274A: A091           ldb     rh1,rl1
274C: 6F01 80F4      ld      %80f4,r1
2750: 6101 818C      ld      r1,%818c
2754: 1900 0064      mult    rr0,#%0064
2758: 1B00 0078      div     rr0,#%0078
275C: 0B01 0000      cp      r1,#%0000
2760: E106           jr      lt,%276e
2762: 0B01 00FF      cp      r1,#%00ff
2766: E205           jr      le,%2772
2768: 2101 00FF      ld      r1,#%00ff
276C: E802           jr      %2772
276E: 2101 0000      ld      r1,#%0000
2772: 6F01 80E0      ld      %80e0,r1
2776: 4D01 8C60 8004 cp      %8c60,#%8004
277C: 9E0E           ret     ne/nz
277E: 4D01 8C7C 0064 cp      %8c7c,#%0064
2784: 9E0E           ret     ne/nz
2786: 610E 81B0      ld      r14,%81b0
278A: 070E 007E      and     r14,#%007e
278E: 4DE5 AA00 0008 ld      %aa00(r14),#%0008
2794: A9E1           inc     r14,2
2796: 070E 007E      and     r14,#%007e
279A: 4DE5 AA00 FFFF ld      %aa00(r14),#%ffff
27A0: 6F0E 81B0      ld      %81b0,r14
27A4: 9E08           ret     
27A6: 0B01 0017      cp      r1,#%0017
27AA: E949           jr      ge,%283e
27AC: 0B01 0013      cp      r1,#%0013
27B0: E90B           jr      ge,%27c8
27B2: 4D08 821E      clr     %821e
27B6: E843           jr      %283e
27B8: 0B01 002C      cp      r1,#%002c
27BC: E240           jr      le,%283e
27BE: 0B01 003F      cp      r1,#%003f
27C2: E202           jr      le,%27c8
27C4: 2101 003F      ld      r1,#%003f
27C8: 6100 8100      ld      r0,%8100
27CC: A906           inc     r0,7
27CE: 0700 000F      and     r0,#%000f
27D2: EE35           jr      ne/nz,%283e
27D4: 4D04 821E      test    %821e
27D8: E632           jr      eq/z,%283e
27DA: 6B00 821E      dec     %821e,1
27DE: E82F           jr      %283e
27E0: 6101 821C      ld      r1,%821c
27E4: A019           ldb     rl1,rh1
27E6: 8C18           clrb    rh1
27E8: 0B01 001F      cp      r1,#%001f
27EC: E2DC           jr      le,%27a6
27EE: 0B01 002A      cp      r1,#%002a
27F2: E9E2           jr      ge,%27b8
27F4: 6102 821E      ld      r2,%821e
27F8: 0B02 0010      cp      r2,#%0010
27FC: E20F           jr      le,%281c
27FE: 0B02 0020      cp      r2,#%0020
2802: E215           jr      le,%282e
2804: 0B02 0040      cp      r2,#%0040
2808: EA1A           jr      gt,%283e
280A: 6100 8100      ld      r0,%8100
280E: A906           inc     r0,7
2810: 0700 00FF      and     r0,#%00ff
2814: EE14           jr      ne/nz,%283e
2816: 6900 821E      inc     %821e,1
281A: E811           jr      %283e
281C: 6100 8100      ld      r0,%8100
2820: A906           inc     r0,7
2822: 0700 003F      and     r0,#%003f
2826: EE0B           jr      ne/nz,%283e
2828: 6900 821E      inc     %821e,1
282C: E808           jr      %283e
282E: 6100 8100      ld      r0,%8100
2832: A906           inc     r0,7
2834: 0700 007F      and     r0,#%007f
2838: EE02           jr      ne/nz,%283e
283A: 6900 821E      inc     %821e,1
283E: 6019 3EF0      ldb     rl1,%3ef0(r1)
2842: 8C18           clrb    rh1
2844: 4101 821E      add     r1,%821e
2848: 0B01 006A      cp      r1,#%006a
284C: E102           jr      lt,%2852
284E: 2101 0069      ld      r1,#%0069
2852: 5900 8190      mult    rr0,%8190
2856: B30D FFFD      sral    rr0,#3
285A: 6F01 8220      ld      %8220,r1
285E: 6101 821C      ld      r1,%821c
2862: 8D08           clr     r0
2864: 1B00 0320      div     rr0,#%0320
2868: 0101 000A      add     r1,#%000a
286C: 6F01 823A      ld      %823a,r1
2870: 9E08           ret     
2872: 4D05 8226 000A ld      %8226,#%000a
2878: 4D04 8104      test    %8104
287C: EE04           jr      ne/nz,%2886
287E: 6700 801A      bit     %801a,0
2882: EE05           jr      ne/nz,%288e
2884: E807           jr      %2894
2886: 4D01 818C 0064 cp      %818c,#%0064
288C: E103           jr      lt,%2894
288E: 4D05 8226 0005 ld      %8226,#%0005
2894: 4D04 8204      test    %8204
2898: E644           jr      eq/z,%2922
289A: 6100 8228      ld      r0,%8228
289E: 4300 821C      sub     r0,%821c
28A2: A101           ld      r1,r0
28A4: 8D04           test    r0
28A6: ED01           jr      pl,%28aa
28A8: 8D02           neg     r0
28AA: 0B00 00C8      cp      r0,#%00c8
28AE: E248           jr      le,%2940
28B0: 8D14           test    r1
28B2: E51B           jr      mi,%28ea
28B4: 6101 8220      ld      r1,%8220
28B8: 0101 003C      add     r1,#%003c
28BC: 1900 0006      mult    rr0,#%0006
28C0: 4101 821C      add     r1,%821c
28C4: 6F01 821C      ld      %821c,r1
28C8: 6103 8228      ld      r3,%8228
28CC: A934           inc     r3,5
28CE: 1900 0005      mult    rr0,#%0005
28D2: 9B30           div     rr0,r3
28D4: 8D12           neg     r1
28D6: 0101 0009      add     r1,#%0009
28DA: 5900 823A      mult    rr0,%823a
28DE: 1B00 0004      div     rr0,#%0004
28E2: 8D12           neg     r1
28E4: 6F01 822C      ld      %822c,r1
28E8: 9E08           ret     
28EA: 6101 8220      ld      r1,%8220
28EE: 0301 003C      sub     r1,#%003c
28F2: 1900 0006      mult    rr0,#%0006
28F6: 4101 821C      add     r1,%821c
28FA: ED01           jr      pl,%28fe
28FC: 8D18           clr     r1
28FE: 6F01 821C      ld      %821c,r1
2902: A914           inc     r1,5
2904: 6103 8228      ld      r3,%8228
2908: 1902 0005      mult    rr2,#%0005
290C: 9B12           div     rr2,r1
290E: 8D32           neg     r3
2910: 0103 0009      add     r3,#%0009
2914: 5902 8220      mult    rr2,%8220
2918: 1B02 0004      div     rr2,#%0004
291C: 6F03 822C      ld      %822c,r3
2920: 9E08           ret     
2922: 6101 8220      ld      r1,%8220
2926: 0301 000A      sub     r1,#%000a
292A: 1900 000A      mult    rr0,#%000a
292E: 4101 821C      add     r1,%821c
2932: ED01           jr      pl,%2936
2934: 8D18           clr     r1
2936: 6F01 821C      ld      %821c,r1
293A: 4D08 822C      clr     %822c
293E: 9E08           ret     
2940: 6101 8228      ld      r1,%8228
2944: 6F01 821C      ld      %821c,r1
2948: 6101 8220      ld      r1,%8220
294C: 5900 8226      mult    rr0,%8226
2950: 1900 0020      mult    rr0,#%0020
2954: 4B01 824C      cp      r1,%824c
2958: E105           jr      lt,%2964
295A: 6101 8220      ld      r1,%8220
295E: 6F01 822C      ld      %822c,r1
2962: 9E08           ret     
2964: 6101 8220      ld      r1,%8220
2968: 4301 823A      sub     r1,%823a
296C: 6F01 822C      ld      %822c,r1
2970: 9E08           ret     
2972: 6101 822C      ld      r1,%822c
2976: 5900 8226      mult    rr0,%8226
297A: 1900 0020      mult    rr0,#%0020
297E: 6103 8194      ld      r3,%8194
2982: 1902 05DC      mult    rr2,#%05dc
2986: 8331           sub     r1,r3
2988: 6F01 8484      ld      %8484,r1
298C: 4D04 8258      test    %8258
2990: EE04           jr      ne/nz,%299a
2992: 8D14           test    r1
2994: ED02           jr      pl,%299a
2996: 4D08 8484      clr     %8484
299A: 6101 8484      ld      r1,%8484
299E: 0B01 3A98      cp      r1,#%3a98
29A2: E212           jr      le,%29c8
29A4: 4D05 8480 0001 ld      %8480,#%0001
29AA: 0301 2328      sub     r1,#%2328
29AE: B10A           exts    rr0
29B0: 1B00 01F4      div     rr0,#%01f4
29B4: 4101 8482      add     r1,%8482
29B8: ED01           jr      pl,%29bc
29BA: 8D18           clr     r1
29BC: 6F01 8482      ld      %8482,r1
29C0: 4D05 8240 2328 ld      %8240,#%2328
29C6: 9E08           ret     
29C8: 0B01 C568      cp      r1,#%c568
29CC: E912           jr      ge,%29f2
29CE: 4D05 8480 FFFF ld      %8480,#%ffff
29D4: 0101 2710      add     r1,#%2710
29D8: B10A           exts    rr0
29DA: 1B00 01F4      div     rr0,#%01f4
29DE: 4101 8482      add     r1,%8482
29E2: ED01           jr      pl,%29e6
29E4: 8D18           clr     r1
29E6: 6F01 8482      ld      %8482,r1
29EA: 4D05 8240 D8F0 ld      %8240,#%d8f0
29F0: 9E08           ret     
29F2: 6101 8258      ld      r1,%8258
29F6: 1900 0003      mult    rr0,#%0003
29FA: 1B00 0014      div     rr0,#%0014
29FE: A113           ld      r3,r1
2A00: 8D12           neg     r1
2A02: 4101 8482      add     r1,%8482
2A06: 8D14           test    r1
2A08: ED01           jr      pl,%2a0c
2A0A: 8D12           neg     r1
2A0C: 0B01 0028      cp      r1,#%0028
2A10: E909           jr      ge,%2a24
2A12: 4D08 8480      clr     %8480
2A16: 6F03 8482      ld      %8482,r3
2A1A: 6101 8484      ld      r1,%8484
2A1E: 6F01 8240      ld      %8240,r1
2A22: 9E08           ret     
2A24: 4D04 8480      test    %8480
2A28: E5D2           jr      mi,%29ce
2A2A: E6F3           jr      eq/z,%2a12
2A2C: E8BB           jr      %29a4
2A2E: 6101 8482      ld      r1,%8482
2A32: 5900 8226      mult    rr0,%8226
2A36: ED01           jr      pl,%2a3a
2A38: 8D18           clr     r1
2A3A: 6F01 8228      ld      %8228,r1
2A3E: 6101 8258      ld      r1,%8258
2A42: 8D08           clr     r0
2A44: 1B00 0064      div     rr0,#%0064
2A48: A113           ld      r3,r1
2A4A: 9930           mult    rr0,r3
2A4C: 5D00 8268      ldl     %8268,rr0
2A50: 6103 8248      ld      r3,%8248
2A54: 1902 04B0      mult    rr2,#%04b0
2A58: 9602           addl    rr2,rr0
2A5A: B305 FFFE      srll    rr0,#2
2A5E: 9602           addl    rr2,rr0
2A60: B305 FFFE      srll    rr0,#2
2A64: 9602           addl    rr2,rr0
2A66: B305 FFFF      srll    rr0,#1
2A6A: 9602           addl    rr2,rr0
2A6C: B325 FFFF      srll    rr2,#1
2A70: 6F03 824C      ld      %824c,r3
2A74: 6101 8240      ld      r1,%8240
2A78: B10A           exts    rr0
2A7A: 9220           subl    rr0,rr2
2A7C: B30D FFFE      sral    rr0,#2
2A80: 6F01 8254      ld      %8254,r1
2A84: B319 FFFA      sra     r1,#6
2A88: 4101 8258      add     r1,%8258
2A8C: 6F01 8258      ld      %8258,r1
2A90: 9E0D           ret     pl
2A92: 4D08 8258      clr     %8258
2A96: 9E08           ret     
2A98: 5400 8268      ldl     rr0,%8268
2A9C: A019           ldb     rl1,rh1
2A9E: A081           ldb     rh1,rl0
2AA0: A008           ldb     rl0,rh0
2AA2: 5900 825C      mult    rr0,%825c
2AA6: 1B00 000E      div     rr0,#%000e
2AAA: 6F01 8244      ld      %8244,r1
2AAE: 9E08           ret     
2AB0: DFFF           calr    %2ab4
2AB2: E832           jr      %2b18
2AB4: 6100 800C      ld      r0,%800c
2AB8: A102           ld      r2,r0
2ABA: 6101 819C      ld      r1,%819c
2ABE: A113           ld      r3,r1
2AC0: 6F00 819C      ld      %819c,r0
2AC4: 8289           subb    rl1,rl0
2AC6: B110           extsb   r1
2AC8: A110           ld      r0,r1
2ACA: 8D04           test    r0
2ACC: ED01           jr      pl,%2ad0
2ACE: 8D02           neg     r0
2AD0: 0B00 000A      cp      r0,#%000a
2AD4: E202           jr      le,%2ada
2AD6: 2101 0000      ld      r1,#%0000
2ADA: 6F01 81A4      ld      %81a4,r1
2ADE: 6101 8218      ld      r1,%8218
2AE2: 6F01 81A0      ld      %81a0,r1
2AE6: 5900 824A      mult    rr0,%824a
2AEA: 1B00 000A      div     rr0,#%000a
2AEE: 4301 8198      sub     r1,%8198
2AF2: 8D12           neg     r1
2AF4: 5900 818C      mult    rr0,%818c
2AF8: B30D FFFD      sral    rr0,#3
2AFC: A112           ld      r2,r1
2AFE: B329 FFFF      sra     r2,#1
2B02: 8121           add     r1,r2
2B04: 4101 8188      add     r1,%8188
2B08: 9E04           ret     pe/ov
2B0A: 6F01 8188      ld      %8188,r1
2B0E: 9E0D           ret     pl
2B10: A910           inc     r1,1
2B12: 6F01 8188      ld      %8188,r1
2B16: 9E08           ret     
2B18: 4D04 81F8      test    %81f8
2B1C: 5E0E 2C46      jp      ne/nz,%2c46
2B20: 4D04 8104      test    %8104
2B24: 5E0E 2C46      jp      ne/nz,%2c46
2B28: 6101 825C      ld      r1,%825c
2B2C: A110           ld      r0,r1
2B2E: 6103 81A4      ld      r3,%81a4
2B32: 6104 8100      ld      r4,%8100
2B36: 0704 0003      and     r4,#%0003
2B3A: EE02           jr      ne/nz,%2b40
2B3C: 4103 81A6      add     r3,%81a6
2B40: 4D05 81A6 0000 ld      %81a6,#%0000
2B46: A132           ld      r2,r3
2B48: 4D04 81F4      test    %81f4
2B4C: E65F           jr      eq/z,%2c0c
2B4E: A104           ld      r4,r0
2B50: 4304 8198      sub     r4,%8198
2B54: E63E           jr      eq/z,%2bd2
2B56: A145           ld      r5,r4
2B58: 8D54           test    r5
2B5A: ED01           jr      pl,%2b5e
2B5C: 8D52           neg     r5
2B5E: 0B05 0002      cp      r5,#%0002
2B62: E11F           jr      lt,%2ba2
2B64: 0B05 0004      cp      r5,#%0004
2B68: E11F           jr      lt,%2ba8
2B6A: 0B05 0006      cp      r5,#%0006
2B6E: E11F           jr      lt,%2bae
2B70: 0B05 0008      cp      r5,#%0008
2B74: E11F           jr      lt,%2bb4
2B76: 0B05 000A      cp      r5,#%000a
2B7A: E11F           jr      lt,%2bba
2B7C: 0B05 0010      cp      r5,#%0010
2B80: E106           jr      lt,%2b8e
2B82: 0B05 0020      cp      r5,#%0020
2B86: E106           jr      lt,%2b94
2B88: 2106 0003      ld      r6,#%0003
2B8C: E805           jr      %2b98
2B8E: 2106 0001      ld      r6,#%0001
2B92: E802           jr      %2b98
2B94: 2106 0002      ld      r6,#%0002
2B98: 8D44           test    r4
2B9A: A164           ld      r4,r6
2B9C: ED1B           jr      pl,%2bd4
2B9E: 8D42           neg     r4
2BA0: E819           jr      %2bd4
2BA2: 2106 001F      ld      r6,#%001f
2BA6: E80B           jr      %2bbe
2BA8: 2106 000F      ld      r6,#%000f
2BAC: E808           jr      %2bbe
2BAE: 2106 0007      ld      r6,#%0007
2BB2: E805           jr      %2bbe
2BB4: 2106 0003      ld      r6,#%0003
2BB8: E802           jr      %2bbe
2BBA: 2106 0001      ld      r6,#%0001
2BBE: 8D44           test    r4
2BC0: 2104 0001      ld      r4,#%0001
2BC4: ED02           jr      pl,%2bca
2BC6: 2104 FFFF      ld      r4,#%ffff
2BCA: 6105 8100      ld      r5,%8100
2BCE: 8765           and     r5,r6
2BD0: E601           jr      eq/z,%2bd4
2BD2: 8D48           clr     r4
2BD4: 8D14           test    r1
2BD6: ED01           jr      pl,%2bda
2BD8: 8D12           neg     r1
2BDA: 0B01 0009      cp      r1,#%0009
2BDE: E105           jr      lt,%2bea
2BE0: 0B01 002D      cp      r1,#%002d
2BE4: E101           jr      lt,%2be8
2BE6: 8132           add     r2,r3
2BE8: 8132           add     r2,r3
2BEA: 8132           add     r2,r3
2BEC: 8102           add     r2,r0
2BEE: 8342           sub     r2,r4
2BF0: 0B02 FF81      cp      r2,#%ff81
2BF4: E106           jr      lt,%2c02
2BF6: 0B02 007F      cp      r2,#%007f
2BFA: E205           jr      le,%2c06
2BFC: 2102 007F      ld      r2,#%007f
2C00: E802           jr      %2c06
2C02: 2102 FF81      ld      r2,#%ff81
2C06: 6F02 825C      ld      %825c,r2
2C0A: 9E08           ret     
2C0C: 8D48           clr     r4
2C0E: 8D14           test    r1
2C10: ED01           jr      pl,%2c14
2C12: 8D12           neg     r1
2C14: 0B01 0009      cp      r1,#%0009
2C18: E106           jr      lt,%2c26
2C1A: 0B01 002D      cp      r1,#%002d
2C1E: E102           jr      lt,%2c24
2C20: 8132           add     r2,r3
2C22: 8132           add     r2,r3
2C24: 8132           add     r2,r3
2C26: 8102           add     r2,r0
2C28: 8342           sub     r2,r4
2C2A: 0B02 FF81      cp      r2,#%ff81
2C2E: E106           jr      lt,%2c3c
2C30: 0B02 007F      cp      r2,#%007f
2C34: E205           jr      le,%2c40
2C36: 2102 007F      ld      r2,#%007f
2C3A: E802           jr      %2c40
2C3C: 2102 FF81      ld      r2,#%ff81
2C40: 6F02 825C      ld      %825c,r2
2C44: 9E08           ret     
2C46: 4D01 81F0 0003 cp      %81f0,#%0003
2C4C: 9E02           ret     le
2C4E: 6100 825C      ld      r0,%825c
2C52: 8D02           neg     r0
2C54: B309 FFFD      sra     r0,#3
2C58: 4100 825C      add     r0,%825c
2C5C: 6F00 825C      ld      %825c,r0
2C60: 6101 8188      ld      r1,%8188
2C64: B10A           exts    rr0
2C66: 1B00 07D0      div     rr0,#%07d0
2C6A: 4101 825C      add     r1,%825c
2C6E: 6F01 825C      ld      %825c,r1
2C72: 9E08           ret     
2C74: 6101 8240      ld      r1,%8240
2C78: 8D14           test    r1
2C7A: ED01           jr      pl,%2c7e
2C7C: 8D12           neg     r1
2C7E: 8D08           clr     r0
2C80: 4D04 8194      test    %8194
2C84: E609           jr      eq/z,%2c98
2C86: 4D04 823A      test    %823a
2C8A: E606           jr      eq/z,%2c98
2C8C: 1200 0000 2710 subl    rr0,#%00002710
2C92: 1B00 0078      div     rr0,#%0078
2C96: E805           jr      %2ca2
2C98: 1200 0000 1F40 subl    rr0,#%00001f40
2C9E: 1B00 0050      div     rr0,#%0050
2CA2: 6102 81F4      ld      r2,%81f4
2CA6: 0702 0001      and     r2,#%0001
2CAA: 6103 8148      ld      r3,%8148
2CAE: B331 FFFA      srl     r3,#6
2CB2: 0703 0004      and     r3,#%0004
2CB6: 8532           or      r2,r3
2CB8: 6028 3F30      ldb     rl0,%3f30(r2)
2CBC: 8C08           clrb    rh0
2CBE: A102           ld      r2,r0
2CC0: A103           ld      r3,r0
2CC2: B331 FFFF      srl     r3,#1
2CC6: 8310           sub     r0,r1
2CC8: 8B20           cp      r0,r2
2CCA: E201           jr      le,%2cce
2CCC: A120           ld      r0,r2
2CCE: 8B30           cp      r0,r3
2CD0: E901           jr      ge,%2cd4
2CD2: A130           ld      r0,r3
2CD4: 6F00 823E      ld      %823e,r0
2CD8: 9E08           ret     
2CDA: E50D           jr      mi,%2cf6
2CDC: 6101 8484      ld      r1,%8484
2CE0: 0301 2710      sub     r1,#%2710
2CE4: B10A           exts    rr0
2CE6: 1B00 00A0      div     rr0,#%00a0
2CEA: 8D12           neg     r1
2CEC: 0101 0064      add     r1,#%0064
2CF0: 6F01 823E      ld      %823e,r1
2CF4: E80B           jr      %2d0c
2CF6: 6101 8484      ld      r1,%8484
2CFA: 0101 07D0      add     r1,#%07d0
2CFE: B10A           exts    rr0
2D00: 1B00 0140      div     rr0,#%0140
2D04: 0101 0064      add     r1,#%0064
2D08: 6F01 823E      ld      %823e,r1
2D0C: 6101 823E      ld      r1,%823e
2D10: 0B01 0032      cp      r1,#%0032
2D14: E903           jr      ge,%2d1c
2D16: 4D05 823E 0032 ld      %823e,#%0032
2D1C: 0B01 0064      cp      r1,#%0064
2D20: E203           jr      le,%2d28
2D22: 4D05 823E 0064 ld      %823e,#%0064
2D28: 4D04 8480      test    %8480
2D2C: 9E06           ret     eq/z
2D2E: 6101 823E      ld      r1,%823e
2D32: 1900 0008      mult    rr0,#%0008
2D36: 1B00 000A      div     rr0,#%000a
2D3A: 6F01 823E      ld      %823e,r1
2D3E: 9E08           ret     
2D40: DFFF           calr    %2d44
2D42: E824           jr      %2d8c
2D44: 4D04 8222      test    %8222
2D48: E60D           jr      eq/z,%2d64
2D4A: 6701 8222      bit     %8222,1
2D4E: EE14           jr      ne/nz,%2d78
2D50: 4D05 8248 0003 ld      %8248,#%0003
2D56: 4D05 824A 0008 ld      %824a,#%0008
2D5C: 4D05 8276 0004 ld      %8276,#%0004
2D62: 9E08           ret     
2D64: 4D05 8248 0001 ld      %8248,#%0001
2D6A: 4D05 824A 000A ld      %824a,#%000a
2D70: 4D05 8276 0000 ld      %8276,#%0000
2D76: 9E08           ret     
2D78: 4D05 8248 000A ld      %8248,#%000a
2D7E: 4D05 824A 0005 ld      %824a,#%0005
2D84: 4D05 8276 0008 ld      %8276,#%0008
2D8A: 9E08           ret     
2D8C: 6101 8244      ld      r1,%8244
2D90: 8D14           test    r1
2D92: ED01           jr      pl,%2d96
2D94: 8D12           neg     r1
2D96: A110           ld      r0,r1
2D98: 8111           add     r1,r1
2D9A: 8111           add     r1,r1
2D9C: 8101           add     r1,r0
2D9E: 6102 823E      ld      r2,%823e
2DA2: A120           ld      r0,r2
2DA4: 8122           add     r2,r2
2DA6: 8102           add     r2,r0
2DA8: 8B12           cp      r2,r1
2DAA: EF33           jr      nc/uge,%2e12
2DAC: 6300 8222      res     %8222,0
2DB0: 8102           add     r2,r0
2DB2: 8B12           cp      r2,r1
2DB4: EF31           jr      nc/uge,%2e18
2DB6: 6500 8222      set     %8222,0
2DBA: 8102           add     r2,r0
2DBC: 8B12           cp      r2,r1
2DBE: EF2C           jr      nc/uge,%2e18
2DC0: 6701 8222      bit     %8222,1
2DC4: E61C           jr      eq/z,%2dfe
2DC6: 4D05 8222 0003 ld      %8222,#%0003
2DCC: 6100 825C      ld      r0,%825c
2DD0: 6F00 827A      ld      %827a,r0
2DD4: 6101 8244      ld      r1,%8244
2DD8: B10A           exts    rr0
2DDA: 1B00 0020      div     rr0,#%0020
2DDE: 4101 8218      add     r1,%8218
2DE2: 0B01 FF81      cp      r1,#%ff81
2DE6: E106           jr      lt,%2df4
2DE8: 0B01 007F      cp      r1,#%007f
2DEC: E205           jr      le,%2df8
2DEE: 2101 007F      ld      r1,#%007f
2DF2: E802           jr      %2df8
2DF4: 2101 FF81      ld      r1,#%ff81
2DF8: 6F01 8218      ld      %8218,r1
2DFC: 9E08           ret     
2DFE: 4D05 8222 0003 ld      %8222,#%0003
2E04: 6100 825C      ld      r0,%825c
2E08: 6F00 827A      ld      %827a,r0
2E0C: 6F00 8218      ld      %8218,r0
2E10: 9E08           ret     
2E12: 4D05 8222 0000 ld      %8222,#%0000
2E18: 6701 8222      bit     %8222,1
2E1C: EED7           jr      ne/nz,%2dcc
2E1E: 6100 8218      ld      r0,%8218
2E22: 4300 827A      sub     r0,%827a
2E26: 8D04           test    r0
2E28: ED01           jr      pl,%2e2c
2E2A: 8D02           neg     r0
2E2C: 0B00 0005      cp      r0,#%0005
2E30: EA07           jr      gt,%2e40
2E32: 6100 825C      ld      r0,%825c
2E36: 6F00 827A      ld      %827a,r0
2E3A: 6F00 8218      ld      %8218,r0
2E3E: 9E08           ret     
2E40: 6100 825C      ld      r0,%825c
2E44: 6F00 827A      ld      %827a,r0
2E48: 6101 8258      ld      r1,%8258
2E4C: 4300 8218      sub     r0,%8218
2E50: ED01           jr      pl,%2e54
2E52: 8D12           neg     r1
2E54: B10A           exts    rr0
2E56: 1B00 0258      div     rr0,#%0258
2E5A: 4101 8218      add     r1,%8218
2E5E: 0B01 FF81      cp      r1,#%ff81
2E62: E106           jr      lt,%2e70
2E64: 0B01 007F      cp      r1,#%007f
2E68: E205           jr      le,%2e74
2E6A: 2101 007F      ld      r1,#%007f
2E6E: E802           jr      %2e74
2E70: 2101 FF81      ld      r1,#%ff81
2E74: 6F01 8218      ld      %8218,r1
2E78: 9E08           ret     
2E7A: 4D04 8104      test    %8104
2E7E: EE11           jr      ne/nz,%2ea2
2E80: 6101 8C60      ld      r1,%8c60
2E84: 0A09 0404      cpb     rl1,#%04
2E88: E60C           jr      eq/z,%2ea2
2E8A: 6701 8222      bit     %8222,1
2E8E: EE05           jr      ne/nz,%2e9a
2E90: 6101 8276      ld      r1,%8276
2E94: 6F01 80E8      ld      %80e8,r1
2E98: 9E08           ret     
2E9A: 4D05 80E8 000A ld      %80e8,#%000a
2EA0: 9E08           ret     
2EA2: 4D05 80E8 0000 ld      %80e8,#%0000
2EA8: 9E08           ret     
2EAA: 4D04 8104      test    %8104
2EAE: 9E0E           ret     ne/nz
2EB0: 6100 8194      ld      r0,%8194
2EB4: 8100           add     r0,r0
2EB6: 9E06           ret     eq/z
2EB8: 4D01 818C 0002 cp      %818c,#%0002
2EBE: 9E07           ret     c/ult
2EC0: 4100 80E8      add     r0,%80e8
2EC4: 6F00 80E8      ld      %80e8,r0
2EC8: 0B00 0010      cp      r0,#%0010
2ECC: 9E07           ret     c/ult
2ECE: 4D05 80E8 000F ld      %80e8,#%000f
2ED4: 9E08           ret     
2ED6: 4D04 8104      test    %8104
2EDA: 9E0E           ret     ne/nz
2EDC: 4D04 8480      test    %8480
2EE0: 9E06           ret     eq/z
2EE2: 6100 8190      ld      r0,%8190
2EE6: 4100 8194      add     r0,%8194
2EEA: 4100 80E8      add     r0,%80e8
2EEE: 6F00 80E8      ld      %80e8,r0
2EF2: 0B00 0010      cp      r0,#%0010
2EF6: 9E07           ret     c/ult
2EF8: 4D05 80E8 000F ld      %80e8,#%000f
2EFE: 9E08           ret     
2F00: DF72           calr    %301e
2F02: 4D01 8000 0059 cp      %8000,#%0059
2F08: 9E0E           ret     ne/nz
2F0A: 6100 8002      ld      r0,%8002
2F0E: 0700 00FF      and     r0,#%00ff
2F12: 0B00 0010      cp      r0,#%0010
2F16: E720           jr      c/ult,%2f58
2F18: 0B00 0019      cp      r0,#%0019
2F1C: E724           jr      c/ult,%2f66
2F1E: 4D04 813E      test    %813e
2F22: E603           jr      eq/z,%2f2a
2F24: 6B00 813E      dec     %813e,1
2F28: 9E08           ret     
2F2A: 6101 8100      ld      r1,%8100
2F2E: 0701 000F      and     r1,#%000f
2F32: 9E0E           ret     ne/nz
2F34: 6100 8004      ld      r0,%8004
2F38: 0700 00FF      and     r0,#%00ff
2F3C: 0B00 0012      cp      r0,#%0012
2F40: E607           jr      eq/z,%2f50
2F42: 0B00 0013      cp      r0,#%0013
2F46: 9E0E           ret     ne/nz
2F48: DFD5           calr    %2fa0
2F4A: 6B00 8130      dec     %8130,1
2F4E: 9E08           ret     
2F50: DFD9           calr    %2fa0
2F52: 6900 8130      inc     %8130,1
2F56: 9E08           ret     
2F58: 6101 8130      ld      r1,%8130
2F5C: BE98           rldb    rl0,rl1
2F5E: BE18           rldb    rl0,rh1
2F60: 6F01 8130      ld      %8130,r1
2F64: 9E08           ret     
2F66: 0300 0010      sub     r0,#%0010
2F6A: 8100           add     r0,r0
2F6C: 3401 0006      ldar    pr1,%2f76
2F70: 8101           add     r1,r0
2F72: 2111           ld      r1,@r1
2F74: 1E18           jp      @rr1
2F76: 2F88           ld      @r8,r8
2F78: 2FA0           ld      @r10,r0
2F7A: 2FB6           ld      @r11,r6
2F7C: 2FC4           ld      @r12,r4
2F7E: 2FD2           ld      @r13,r2
2F80: 2FE2           ld      @r14,r2
2F82: 2FF2           ld      @r15,r2
2F84: 3002 300A      ldrb    rh2,%5f92
2F88: 6101 8132      ld      r1,%8132
2F8C: 8111           add     r1,r1
2F8E: 0701 0006      and     r1,#%0006
2F92: 6102 8130      ld      r2,%8130
2F96: 0702 FFFE      and     r2,#%fffe
2F9A: 6F12 8134      ld      %8134(r1),r2
2F9E: 9E08           ret     
2FA0: 6101 8132      ld      r1,%8132
2FA4: 8111           add     r1,r1
2FA6: 0701 0006      and     r1,#%0006
2FAA: 6112 8134      ld      r2,%8134(r1)
2FAE: 6103 8130      ld      r3,%8130
2FB2: 2F23           ld      @r2,r3
2FB4: 9E08           ret     
2FB6: D00C           calr    %2fa0
2FB8: 6900 8130      inc     %8130,1
2FBC: 4D05 813E 0028 ld      %813e,#%0028
2FC2: 9E08           ret     
2FC4: D013           calr    %2fa0
2FC6: 6B00 8130      dec     %8130,1
2FCA: 4D05 813E 0028 ld      %813e,#%0028
2FD0: 9E08           ret     
2FD2: 6101 8132      ld      r1,%8132
2FD6: 8111           add     r1,r1
2FD8: 0701 0006      and     r1,#%0006
2FDC: 6911 8134      inc     %8134(r1),2
2FE0: 9E08           ret     
2FE2: 6101 8132      ld      r1,%8132
2FE6: 8111           add     r1,r1
2FE8: 0701 0006      and     r1,#%0006
2FEC: 6B11 8134      dec     %8134(r1),2
2FF0: 9E08           ret     
2FF2: 6100 8132      ld      r0,%8132
2FF6: A900           inc     r0,1
2FF8: 0700 0003      and     r0,#%0003
2FFC: 6F00 8132      ld      %8132,r0
3000: 242A           setb    @r2,10
3002: 2624           bitb    @r2,4
3004: 2424           setb    @r2,4
3006: 2424           setb    @r2,4
3008: 2424           setb    @r2,4
300A: 2724           bit     @r2,4
300C: 2424           setb    @r2,4
300E: 2524           set     @r2,4
3010: 0001 0203      addb    rh1,#%03
3014: 0405 0607      orb     rh5,#%07
3018: 0809 2424      xorb    rl1,#%24
301C: 2824           incb    @r2,5
301E: 2924           inc     @r2,5
3020: 240A 0B0C      setb    rl3,r10
3024: 0D0E           .word   #%0d0e
3026: 0F10           ext0f   #%10
3028: 1112           pushl   @r1,@r2
302A: 1314           push    @r1,@r4
302C: 1516           popl    @r6,@r1
302E: 1718           pop     @r8,@r1
3030: 191A           mult    rr10,@r1
3032: 1B1C           div     rr12,@r1
3034: 1D1E           ldl     @r1,rr14
3036: 1F20           call    r2
3038: 2122           ld      r2,@r2
303A: 233A           res     @r3,10
303C: 243B           setb    @r3,11
303E: 2424           setb    @r2,4
3040: 2428           setb    @r2,8
3042: 292A           inc     @r2,11
3044: 2B2C           dec     @r2,13
3046: 2D2E           ex      r14,@r2
3048: 2F34           ld      @r3,r4
304A: 352C 362D      ldl     rr12,r2(#%362d)
304E: 3738 393A      ldl     r3(#%393a),rr8
3052: 3B3C           .word   #%3b3c
3054: 8C8D           .word   #%8c8d
3056: 8E8F           ext8e   #%8f
3058: 898A           xor     r10,r8
305A: 8B24           cp      r4,r2
305C: 2424           setb    @r2,4
305E: 2424           setb    @r2,4
3060: 2109 0005      ld      r9,#%0005
3064: 8DA8           clr     r10
3066: 8D08           clr     r0
3068: 210C 2000      ld      r12,#%2000
306C: 00A8           addb    rl0,@r10
306E: A9A0           inc     r10,1
3070: 00A0           addb    rh0,@r10
3072: A9A0           inc     r10,1
3074: FC85           djnz    r12,%306c
3076: A880           incb    rl0,1
3078: EE1D           jr      ne/nz,%30b4
307A: A990           inc     r9,1
307C: A800           incb    rh0,1
307E: EE1A           jr      ne/nz,%30b4
3080: 2109 0007      ld      r9,#%0007
3084: 210A 4000      ld      r10,#%4000
3088: 8D08           clr     r0
308A: 210C 1000      ld      r12,#%1000
308E: 00A8           addb    rl0,@r10
3090: A9A0           inc     r10,1
3092: 00A0           addb    rh0,@r10
3094: A9A0           inc     r10,1
3096: FC85           djnz    r12,%308e
3098: A880           incb    rl0,1
309A: EE0C           jr      ne/nz,%30b4
309C: A990           inc     r9,1
309E: A800           incb    rh0,1
30A0: EE09           jr      ne/nz,%30b4
30A2: E834           jr      %310c
30A4: 242A           setb    @r2,10
30A6: 2624           bitb    @r2,4
30A8: 2424           setb    @r2,4
30AA: 2424           setb    @r2,4
30AC: 2424           setb    @r2,4
30AE: 2724           bit     @r2,4
30B0: 2424           setb    @r2,4
30B2: 2524           set     @r2,4
30B4: 2100 0824      ld      r0,#%0824
30B8: 210A 0400      ld      r10,#%0400
30BC: 210B 9800      ld      r11,#%9800
30C0: 2FB0           ld      @r11,r0
30C2: A9B1           inc     r11,2
30C4: ABA0           dec     r10,1
30C6: EEFC           jr      ne/nz,%30c0
30C8: 6F09 8092      ld      %8092,r9
30CC: 4D08 8090      clr     %8090
30D0: E8FF           jr      %30d0
30D2: 2428           setb    @r2,8
30D4: 292A           inc     @r2,11
30D6: 2B2C           dec     @r2,13
30D8: 2D2E           ex      r14,@r2
30DA: 393A           .word   #%393a
30DC: 3B3C           .word   #%3b3c
30DE: 8C8D           .word   #%8c8d
30E0: 8E8F           ext8e   #%8f
30E2: A101           ld      r1,r0
30E4: 0701 000F      and     r1,#%000f
30E8: EEE5           jr      ne/nz,%30b4
30EA: B301 FFFC      srl     r0,#4
30EE: A990           inc     r9,1
30F0: E8F8           jr      %30e2
30F2: 0700 00FF      and     r0,#%00ff
30F6: EEDE           jr      ne/nz,%30b4
30F8: A990           inc     r9,1
30FA: E8DC           jr      %30b4
30FC: 1112           pushl   @r1,@r2
30FE: 1314           push    @r1,@r4
3100: 1516           popl    @r6,@r1
3102: 1718           pop     @r8,@r1
3104: 2428           setb    @r2,8
3106: 292A           inc     @r2,11
3108: 2B2C           dec     @r2,13
310A: 2D2E           ex      r14,@r2
310C: 210E 0004      ld      r14,#%0004
3110: 2109 00A8      ld      r9,#%00a8
3114: 210B 8100      ld      r11,#%8100
3118: A1BA           ld      r10,r11
311A: 8D18           clr     r1
311C: A1E2           ld      r2,r14
311E: 210C 0300      ld      r12,#%0300
3122: A110           ld      r0,r1
3124: 8111           add     r1,r1
3126: 8111           add     r1,r1
3128: 8111           add     r1,r1
312A: 8111           add     r1,r1
312C: 8101           add     r1,r0
312E: A910           inc     r1,1
3130: 0121           add     r1,@r2
3132: A921           inc     r2,2
3134: A110           ld      r0,r1
3136: 2FA0           ld      @r10,r0
3138: 09A0           xor     r0,@r10
313A: EED3           jr      ne/nz,%30e2
313C: A9A1           inc     r10,2
313E: FC8F           djnz    r12,%3122
3140: 8D18           clr     r1
3142: A1E2           ld      r2,r14
3144: 210C 0300      ld      r12,#%0300
3148: A110           ld      r0,r1
314A: 8111           add     r1,r1
314C: 8111           add     r1,r1
314E: 8111           add     r1,r1
3150: 8111           add     r1,r1
3152: 8101           add     r1,r0
3154: A910           inc     r1,1
3156: 0121           add     r1,@r2
3158: A921           inc     r2,2
315A: A110           ld      r0,r1
315C: 09B0           xor     r0,@r11
315E: EEC1           jr      ne/nz,%30e2
3160: A9B1           inc     r11,2
3162: FC8E           djnz    r12,%3148
3164: A993           inc     r9,4
3166: A1BA           ld      r10,r11
3168: 8D18           clr     r1
316A: A1E2           ld      r2,r14
316C: 210C 0400      ld      r12,#%0400
3170: A110           ld      r0,r1
3172: 8111           add     r1,r1
3174: 8111           add     r1,r1
3176: 8111           add     r1,r1
3178: 8111           add     r1,r1
317A: 8101           add     r1,r0
317C: A910           inc     r1,1
317E: 0121           add     r1,@r2
3180: A921           inc     r2,2
3182: A110           ld      r0,r1
3184: 2FA0           ld      @r10,r0
3186: 09A0           xor     r0,@r10
3188: EEAC           jr      ne/nz,%30e2
318A: A9A1           inc     r10,2
318C: FC8F           djnz    r12,%3170
318E: 8D18           clr     r1
3190: A1E2           ld      r2,r14
3192: 210C 0400      ld      r12,#%0400
3196: A110           ld      r0,r1
3198: 8111           add     r1,r1
319A: 8111           add     r1,r1
319C: 8111           add     r1,r1
319E: 8111           add     r1,r1
31A0: 8101           add     r1,r0
31A2: A910           inc     r1,1
31A4: 0121           add     r1,@r2
31A6: A921           inc     r2,2
31A8: A110           ld      r0,r1
31AA: 09B0           xor     r0,@r11
31AC: EE9A           jr      ne/nz,%30e2
31AE: A9B1           inc     r11,2
31B0: FC8E           djnz    r12,%3196
31B2: A993           inc     r9,4
31B4: A1BA           ld      r10,r11
31B6: 8D18           clr     r1
31B8: A1E2           ld      r2,r14
31BA: 210C 0800      ld      r12,#%0800
31BE: A110           ld      r0,r1
31C0: 8111           add     r1,r1
31C2: 8111           add     r1,r1
31C4: 8111           add     r1,r1
31C6: 8111           add     r1,r1
31C8: 8101           add     r1,r0
31CA: A910           inc     r1,1
31CC: 0121           add     r1,@r2
31CE: A921           inc     r2,2
31D0: A110           ld      r0,r1
31D2: 2FA0           ld      @r10,r0
31D4: 09A0           xor     r0,@r10
31D6: EE8D           jr      ne/nz,%30f2
31D8: A9A1           inc     r10,2
31DA: FC8F           djnz    r12,%31be
31DC: 8D18           clr     r1
31DE: A1E2           ld      r2,r14
31E0: 210C 0800      ld      r12,#%0800
31E4: A110           ld      r0,r1
31E6: 8111           add     r1,r1
31E8: 8111           add     r1,r1
31EA: 8111           add     r1,r1
31EC: 8111           add     r1,r1
31EE: 8101           add     r1,r0
31F0: A910           inc     r1,1
31F2: 0121           add     r1,@r2
31F4: A921           inc     r2,2
31F6: A110           ld      r0,r1
31F8: 09B0           xor     r0,@r11
31FA: 5E0E 30F2      jp      ne/nz,%30f2
31FE: A9B1           inc     r11,2
3200: FC8F           djnz    r12,%31e4
3202: A991           inc     r9,2
3204: A1BA           ld      r10,r11
3206: 8D18           clr     r1
3208: A1E2           ld      r2,r14
320A: 210C 07F0      ld      r12,#%07f0
320E: A110           ld      r0,r1
3210: 8111           add     r1,r1
3212: 8111           add     r1,r1
3214: 8111           add     r1,r1
3216: 8111           add     r1,r1
3218: 8101           add     r1,r0
321A: A910           inc     r1,1
321C: 0121           add     r1,@r2
321E: A921           inc     r2,2
3220: A110           ld      r0,r1
3222: 2FA0           ld      @r10,r0
3224: 09A0           xor     r0,@r10
3226: 5E0E 30F2      jp      ne/nz,%30f2
322A: A9A1           inc     r10,2
322C: FC90           djnz    r12,%320e
322E: 8D18           clr     r1
3230: A1E2           ld      r2,r14
3232: 210C 07F0      ld      r12,#%07f0
3236: A110           ld      r0,r1
3238: 8111           add     r1,r1
323A: 8111           add     r1,r1
323C: 8111           add     r1,r1
323E: 8111           add     r1,r1
3240: 8101           add     r1,r0
3242: A910           inc     r1,1
3244: 0121           add     r1,@r2
3246: A921           inc     r2,2
3248: A110           ld      r0,r1
324A: 09B0           xor     r0,@r11
324C: 5E0E 30F2      jp      ne/nz,%30f2
3250: A9B1           inc     r11,2
3252: FC8F           djnz    r12,%3236
3254: ABE0           dec     r14,1
3256: 5E0E 3110      jp      ne/nz,%3110
325A: 4D05 8144 0001 ld      %8144,#%0001
3260: 4D05 8146 0001 ld      %8146,#%0001
3266: 4D08 8148      clr     %8148
326A: 4D08 814A      clr     %814a
326E: 4D08 814C      clr     %814c
3272: 4D08 8000      clr     %8000
3276: 2100 0824      ld      r0,#%0824
327A: 210A 0400      ld      r10,#%0400
327E: 210B 9800      ld      r11,#%9800
3282: 2FB0           ld      @r11,r0
3284: A9B1           inc     r11,2
3286: ABA0           dec     r10,1
3288: EEFC           jr      ne/nz,%3282
328A: 4D08 8094      clr     %8094
328E: 4D08 8092      clr     %8092
3292: 4D08 8090      clr     %8090
3296: 6100 8094      ld      r0,%8094
329A: 0700 00FF      and     r0,#%00ff
329E: 0B00 0001      cp      r0,#%0001
32A2: EEF9           jr      ne/nz,%3296
32A4: 5E08 0008      jp      %0008
32A8: 1112           pushl   @r1,@r2
32AA: 1314           push    @r1,@r4
32AC: 1516           popl    @r6,@r1
32AE: 1718           pop     @r8,@r1
32B0: 191A           mult    rr10,@r1
32B2: 1B1C           div     rr12,@r1
32B4: 1D1E           ldl     @r1,rr14
32B6: 1F20           call    r2
32B8: 2122           ld      r2,@r2
32BA: 233A           res     @r3,10
32BC: 243B           setb    @r3,11
32BE: 2424           setb    @r2,4
32C0: 2424           setb    @r2,4
32C2: 2724           bit     @r2,4
32C4: 2424           setb    @r2,4
32C6: 2524           set     @r2,4
32C8: 0001 0203      addb    rh1,#%03
32CC: 0405 0607      orb     rh5,#%07
32D0: 242A           setb    @r2,10
32D2: 2624           bitb    @r2,4
32D4: 2424           setb    @r2,4
32D6: 2424           setb    @r2,4
32D8: 0809 2424      xorb    rl1,#%24
32DC: 2824           incb    @r2,5
32DE: 2924           inc     @r2,5
32E0: 240A 0B0C      setb    rl3,r10
32E4: 0D0E           .word   #%0d0e
32E6: 0F10           ext0f   #%10
32E8: 2428           setb    @r2,8
32EA: 292A           inc     @r2,11
32EC: 2B2C           dec     @r2,13
32EE: 2D2E           ex      r14,@r2
32F0: 2F34           ld      @r3,r4
32F2: 352C 362D      ldl     rr12,r2(#%362d)
32F6: 3738 393A      ldl     r3(#%393a),rr8
32FA: 3B3C           .word   #%3b3c
32FC: 8C8D           .word   #%8c8d
32FE: 8E8F           ext8e   #%8f
3300: 2424           setb    @r2,4
3302: 2724           bit     @r2,4
3304: 2424           setb    @r2,4
3306: 2524           set     @r2,4
3308: 0001 0203      addb    rh1,#%03
330C: 0405 0607      orb     rh5,#%07
3310: 242A           setb    @r2,10
3312: 2624           bitb    @r2,4
3314: 2424           setb    @r2,4
3316: 2424           setb    @r2,4
3318: 0809 2424      xorb    rl1,#%24
331C: 2824           incb    @r2,5
331E: 2924           inc     @r2,5
3320: 240A 0B0C      setb    rl3,r10
3324: 0D0E           .word   #%0d0e
3326: 0F10           ext0f   #%10
3328: 898A           xor     r10,r8
332A: 8B24           cp      r4,r2
332C: 2424           setb    @r2,4
332E: 2424           setb    @r2,4
3330: 210C 0400      ld      r12,#%0400
3334: A110           ld      r0,r1
3336: B311 0002      sll     r1,#2
333A: 8101           add     r1,r0
333C: A910           inc     r1,1
333E: 0121           add     r1,@r2
3340: A921           inc     r2,2
3342: A110           ld      r0,r1
3344: 2FA0           ld      @r10,r0
3346: 09A0           xor     r0,@r10
3348: EEBA           jr      ne/nz,%32be
334A: A9A1           inc     r10,2
334C: FC8D           djnz    r12,%3334
334E: A1E1           ld      r1,r14
3350: A1E2           ld      r2,r14
3352: 210C 0400      ld      r12,#%0400
3356: A110           ld      r0,r1
3358: B311 0002      sll     r1,#2
335C: 8101           add     r1,r0
335E: A910           inc     r1,1
3360: 0121           add     r1,@r2
3362: A921           inc     r2,2
3364: A110           ld      r0,r1
3366: 09B0           xor     r0,@r11
3368: EEAA           jr      ne/nz,%32be
336A: A9B1           inc     r11,2
336C: FC8C           djnz    r12,%3356
336E: A993           inc     r9,4
3370: A1BA           ld      r10,r11
3372: A1E1           ld      r1,r14
3374: A1E2           ld      r2,r14
3376: 210C 0800      ld      r12,#%0800
337A: A110           ld      r0,r1
337C: B311 0002      sll     r1,#2
3380: 8101           add     r1,r0
3382: A910           inc     r1,1
3384: 0121           add     r1,@r2
3386: A921           inc     r2,2
3388: A110           ld      r0,r1
338A: 2FA0           ld      @r10,r0
338C: 09A0           xor     r0,@r10
338E: EE9F           jr      ne/nz,%32ce
3390: A9A1           inc     r10,2
3392: FC8D           djnz    r12,%337a
3394: A1E1           ld      r1,r14
3396: A1E2           ld      r2,r14
3398: 210C 0800      ld      r12,#%0800
339C: A110           ld      r0,r1
339E: B311 0002      sll     r1,#2
33A2: 8101           add     r1,r0
33A4: A910           inc     r1,1
33A6: 0121           add     r1,@r2
33A8: A921           inc     r2,2
33AA: A110           ld      r0,r1
33AC: 09B0           xor     r0,@r11
33AE: EE8F           jr      ne/nz,%32ce
33B0: A9B1           inc     r11,2
33B2: FC8C           djnz    r12,%339c
33B4: A991           inc     r9,2
33B6: A1BA           ld      r10,r11
33B8: A1E1           ld      r1,r14
33BA: A1E2           ld      r2,r14
33BC: 210C 07F0      ld      r12,#%07f0
33C0: A110           ld      r0,r1
33C2: B311 0002      sll     r1,#2
33C6: 8101           add     r1,r0
33C8: A910           inc     r1,1
33CA: 0121           add     r1,@r2
33CC: A921           inc     r2,2
33CE: A110           ld      r0,r1
33D0: 2FA0           ld      @r10,r0
33D2: 09A0           xor     r0,@r10
33D4: 5E0E 32CE      jp      ne/nz,%32ce
33D8: A9A1           inc     r10,2
33DA: FC8E           djnz    r12,%33c0
33DC: A1E1           ld      r1,r14
33DE: A1E2           ld      r2,r14
33E0: 210C 07F0      ld      r12,#%07f0
33E4: A110           ld      r0,r1
33E6: B311 0002      sll     r1,#2
33EA: 8101           add     r1,r0
33EC: A910           inc     r1,1
33EE: 0121           add     r1,@r2
33F0: A921           inc     r2,2
33F2: A110           ld      r0,r1
33F4: 09B0           xor     r0,@r11
33F6: 5E0E 32CE      jp      ne/nz,%32ce
33FA: A9B1           inc     r11,2
33FC: FC8D           djnz    r12,%33e4
33FE: ABE0           dec     r14,1
3400: 5E0E 32DC      jp      ne/nz,%32dc
3404: 2106 7890      ld      r6,#%7890
3408: 2108 000A      ld      r8,#%000a
340C: 2104 2000      ld      r4,#%2000
3410: 2105 2100      ld      r5,#%2100
3414: A0EC           ldb     rl4,rl6
3416: A06D           ldb     rl5,rh6
3418: 8144           add     r4,r4
341A: 8155           add     r5,r5
341C: 204B           ldb     rl3,@r4
341E: 2053           ldb     rh3,@r5
3420: A0E9           ldb     rl1,rl6
3422: A06B           ldb     rl3,rh6
3424: B110           extsb   r1
3426: 8C38           clrb    rh3
3428: 9930           mult    rr0,r3
342A: A167           ld      r7,r6
342C: B361 0004      sll     r6,#4
3430: 8176           add     r6,r7
3432: A960           inc     r6,1
3434: 2104 2000      ld      r4,#%2000
3438: 2105 2100      ld      r5,#%2100
343C: A0EC           ldb     rl4,rl6
343E: A06D           ldb     rl5,rh6
3440: 8144           add     r4,r4
3442: 8155           add     r5,r5
3444: 204B           ldb     rl3,@r4
3446: 2053           ldb     rh3,@r5
3448: 8B13           cp      r3,r1
344A: EE2A           jr      ne/nz,%34a0
344C: F897           djnz    r8,%3420
344E: 4D05 8144 0001 ld      %8144,#%0001
3454: 4D05 8146 0001 ld      %8146,#%0001
345A: 4D08 8148      clr     %8148
345E: 4D08 814A      clr     %814a
3462: 4D08 814C      clr     %814c
3466: 4D08 8000      clr     %8000
346A: 210A 0400      ld      r10,#%0400
346E: 210B 9800      ld      r11,#%9800
3472: 0DB5 0824      ld      @r11,#%0824
3476: A9B1           inc     r11,2
3478: FA84           djnz    r10,%3472
347A: 4D08 8092      clr     %8092
347E: 4D08 8090      clr     %8090
3482: 4D04 8090      test    %8090
3486: E6FD           jr      eq/z,%3482
3488: 4D04 8090      test    %8090
348C: EEFD           jr      ne/nz,%3488
348E: 6100 8094      ld      r0,%8094
3492: 0700 00FF      and     r0,#%00ff
3496: 0B00 0001      cp      r0,#%0001
349A: EEF9           jr      ne/nz,%348e
349C: 5E08 0006      jp      %0006
34A0: 210A 0400      ld      r10,#%0400
34A4: 210B 9800      ld      r11,#%9800
34A8: 0DB5 0824      ld      @r11,#%0824
34AC: A9B1           inc     r11,2
34AE: FA84           djnz    r10,%34a8
34B0: 210B 9908      ld      r11,#%9908
34B4: 210A 34CA      ld      r10,#%34ca
34B8: C108           ldb     rh1,#%08
34BA: 20A9           ldb     rl1,@r10
34BC: A717           bit     r1,7
34BE: EE04           jr      ne/nz,%34c8
34C0: 2FB1           ld      @r11,r1
34C2: A9A0           inc     r10,1
34C4: A9B1           inc     r11,2
34C6: E8F9           jr      %34ba
34C8: E8FF           jr      %34c8
34CA: 0E1B           ext0e   #%1b
34CC: 1B18           div     rr8,@r1
34CE: 1B24           div     rr4,@r2
34D0: 120C 0205 FFFF subl    rr12,#%0205ffff
34D6: 91F2           pushl   @r15,rr2
34D8: 91F4           pushl   @r15,rr4
34DA: 1404 0000 0000 ldl     rr4,#%00000000
34E0: A113           ld      r3,r1
34E2: 0703 000F      and     r3,#%000f
34E6: 8D28           clr     r2
34E8: 9624           addl    rr4,rr2
34EA: B305 FFFC      srll    rr0,#4
34EE: A113           ld      r3,r1
34F0: 0703 000F      and     r3,#%000f
34F4: 1902 000A      mult    rr2,#%000a
34F8: 9624           addl    rr4,rr2
34FA: B305 FFFC      srll    rr0,#4
34FE: A113           ld      r3,r1
3500: 0703 000F      and     r3,#%000f
3504: 1902 0064      mult    rr2,#%0064
3508: 9624           addl    rr4,rr2
350A: B305 FFFC      srll    rr0,#4
350E: A113           ld      r3,r1
3510: 0703 000F      and     r3,#%000f
3514: 1902 03E8      mult    rr2,#%03e8
3518: 9624           addl    rr4,rr2
351A: B305 FFFC      srll    rr0,#4
351E: A113           ld      r3,r1
3520: 0703 000F      and     r3,#%000f
3524: 1902 2710      mult    rr2,#%2710
3528: 9624           addl    rr4,rr2
352A: 9440           ldl     rr0,rr4
352C: 95F4           popl    rr4,@r15
352E: 95F2           popl    rr2,@r15
3530: 9E08           ret     
3532: 91F2           pushl   @r15,rr2
3534: 1402 0000 0000 ldl     rr2,#%00000000
353A: 8D08           clr     r0
353C: 1B00 2710      div     rr0,#%2710
3540: 8513           or      r3,r1
3542: B325 0004      slll    rr2,#4
3546: A101           ld      r1,r0
3548: 8D08           clr     r0
354A: 1B00 03E8      div     rr0,#%03e8
354E: 8513           or      r3,r1
3550: B325 0004      slll    rr2,#4
3554: A101           ld      r1,r0
3556: 8D08           clr     r0
3558: 1B00 0064      div     rr0,#%0064
355C: 8513           or      r3,r1
355E: B325 0004      slll    rr2,#4
3562: A101           ld      r1,r0
3564: 8D08           clr     r0
3566: 1B00 000A      div     rr0,#%000a
356A: 8513           or      r3,r1
356C: B325 0004      slll    rr2,#4
3570: 8503           or      r3,r0
3572: 9420           ldl     rr0,rr2
3574: 95F2           popl    rr2,@r15
3576: 9E08           ret     
3578: 2DFD           ex      r13,@r15
357A: 93F0           push    @r15,r0
357C: 93F1           push    @r15,r1
357E: A001           ldb     rh1,rh0
3580: E805           jr      %358c
3582: 2DFD           ex      r13,@r15
3584: 93F0           push    @r15,r0
3586: 93F1           push    @r15,r1
3588: 20D1           ldb     rh1,@r13
358A: A9D0           inc     r13,1
358C: A617           bitb    rh1,7
358E: EE13           jr      ne/nz,%35b6
3590: 20D9           ldb     rl1,@r13
3592: A9D0           inc     r13,1
3594: 0A09 4040      cpb     rl1,#%40
3598: E614           jr      eq/z,%35c2
359A: A018           ldb     rl0,rh1
359C: 8C18           clrb    rh1
359E: 0A09 2020      cpb     rl1,#%20
35A2: E901           jr      ge,%35a6
35A4: C920           ldb     rl1,#%20
35A6: 0209 2020      subb    rl1,#%20
35AA: 6019 3AE0      ldb     rl1,%3ae0(r1)
35AE: A081           ldb     rh1,rl0
35B0: 2FC1           ld      @r12,r1
35B2: A9C1           inc     r12,2
35B4: E8ED           jr      %3590
35B6: 20D8           ldb     rl0,@r13
35B8: 8C08           clrb    rh0
35BA: C924           ldb     rl1,#%24
35BC: 2FC1           ld      @r12,r1
35BE: A9C1           inc     r12,2
35C0: F083           djnz    r0,%35bc
35C2: A9D0           inc     r13,1
35C4: 070D FFFE      and     r13,#%fffe
35C8: 97F1           pop     r1,@r15
35CA: 97F0           pop     r0,@r15
35CC: 2DFD           ex      r13,@r15
35CE: 9E08           ret     
35D0: FFFF           djnz    r15,%34d4
35D2: FFFF           djnz    r15,%34d6
35D4: FFFF           djnz    r15,%34d8
35D6: FFFF           djnz    r15,%34da
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
37E0: 0000 0000      addb    rh0,#%00
37E4: 0000 0000      addb    rh0,#%00
37E8: 0000 0000      addb    rh0,#%00
37EC: 0000 0000      addb    rh0,#%00
37F0: 0004 080C      addb    rh4,#%0c
37F4: 1014           cpl     rr4,@r1
37F6: 181C           multl   rq12,@r1
37F8: 2024           ldb     rh4,@r2
37FA: 2424           setb    @r2,4
37FC: 2424           setb    @r2,4
37FE: 2420           setb    @r2,0
3800: 1C18           testl   @r1
3802: 1410           ldl     rr0,@r1
3804: 0C08           .word   #%0c08
3806: 0400 0000      orb     rh0,#%00
380A: 0000 0000      addb    rh0,#%00
380E: 0000 0000      addb    rh0,#%00
3812: 0000 0000      addb    rh0,#%00
3816: 0000 0004      addb    rh0,#%04
381A: 080C 1014      xorb    rl4,#%14
381E: 181C           multl   rq12,@r1
3820: 2024           ldb     rh4,@r2
3822: 2424           setb    @r2,4
3824: 2424           setb    @r2,4
3826: 2420           setb    @r2,0
3828: 1C18           testl   @r1
382A: 1410           ldl     rr0,@r1
382C: 0C08           .word   #%0c08
382E: 0400 0000      orb     rh0,#%00
3832: 0000 0000      addb    rh0,#%00
3836: 0000 0000      addb    rh0,#%00
383A: 0000 0000      addb    rh0,#%00
383E: 0000 0000      addb    rh0,#%00
3842: 0000 0000      addb    rh0,#%00
3846: 0000 0000      addb    rh0,#%00
384A: 0000 0000      addb    rh0,#%00
384E: 0000 0000      addb    rh0,#%00
3852: 0000 0000      addb    rh0,#%00
3856: 0000 0000      addb    rh0,#%00
385A: 0000 0000      addb    rh0,#%00
385E: 0000 0000      addb    rh0,#%00
3862: 0000 0000      addb    rh0,#%00
3866: 0000 0000      addb    rh0,#%00
386A: 0000 0004      addb    rh0,#%04
386E: 080C 1014      xorb    rl4,#%14
3872: 181C           multl   rq12,@r1
3874: 2024           ldb     rh4,@r2
3876: 2424           setb    @r2,4
3878: 2424           setb    @r2,4
387A: 2420           setb    @r2,0
387C: 1C18           testl   @r1
387E: 1410           ldl     rr0,@r1
3880: 0C08           .word   #%0c08
3882: 0400 0000      orb     rh0,#%00
3886: 0000 0000      addb    rh0,#%00
388A: 0000 0000      addb    rh0,#%00
388E: 0000 0000      addb    rh0,#%00
3892: 0000 0004      addb    rh0,#%04
3896: 080C 1014      xorb    rl4,#%14
389A: 181C           multl   rq12,@r1
389C: 2024           ldb     rh4,@r2
389E: 2424           setb    @r2,4
38A0: 2424           setb    @r2,4
38A2: 2420           setb    @r2,0
38A4: 1C18           testl   @r1
38A6: 1410           ldl     rr0,@r1
38A8: 0C08           .word   #%0c08
38AA: 0400 0000      orb     rh0,#%00
38AE: 0000 0000      addb    rh0,#%00
38B2: 0000 0000      addb    rh0,#%00
38B6: 0000 0000      addb    rh0,#%00
38BA: 0000 0000      addb    rh0,#%00
38BE: 0000 0000      addb    rh0,#%00
38C2: 0000 0000      addb    rh0,#%00
38C6: 0000 0000      addb    rh0,#%00
38CA: 0000 0000      addb    rh0,#%00
38CE: 0000 0000      addb    rh0,#%00
38D2: 0000 0000      addb    rh0,#%00
38D6: 0000 0000      addb    rh0,#%00
38DA: 0000 0000      addb    rh0,#%00
38DE: 0000 0000      addb    rh0,#%00
38E2: 0000 0000      addb    rh0,#%00
38E6: 0000 0000      addb    rh0,#%00
38EA: 0000 0000      addb    rh0,#%00
38EE: 0000 0000      addb    rh0,#%00
38F2: 0000 FCF8      addb    rh0,#%f8
38F6: F0E8           djnz    r0,%3828
38F8: E0E0           jr      n,%38ba
38FA: DCD8           calr    %3f4c
38FC: D4D0           calr    %2f5e
38FE: D0C8           calr    %3770
3900: C8D0           ldb     rl0,#%d0
3902: D8E0           calr    %4744
3904: E8F0           jr      %38e6
3906: F8FC           djnz    r8,%3810
3908: 0004 0810      addb    rh4,#%10
390C: 2028           ldb     rl0,@r2
390E: 2010           ldb     rh0,@r1
3910: 0800 F8F0      xorb    rh0,#%f0
3914: E0D8           jr      n,%38c6
3916: E0F0           jr      n,%38f8
3918: F800           dbjnz   rl0,%391a
391A: 0810           xorb    rh0,@r1
391C: 2028           ldb     rl0,@r2
391E: 2010           ldb     rh0,@r1
3920: 0800 FCF8      xorb    rh0,#%f8
3924: F0E0           djnz    r0,%3866
3926: E0F0           jr      n,%3908
3928: F800           dbjnz   rl0,%392a
392A: 0408 1018      orb     rl0,#%18
392E: 2018           ldb     rl0,@r1
3930: 1008 0000 0000 cpl     rr8,#%00000000
3936: 0000 0000      addb    rh0,#%00
393A: 0000 00F8      addb    rh0,#%f8
393E: F0E8           djnz    r0,%3870
3940: E0DC           jr      n,%38fa
3942: D8DC           calr    %478c
3944: E0E8           jr      n,%3916
3946: F0F8           djnz    r0,%3858
3948: 0000 0000      addb    rh0,#%00
394C: 0000 0000      addb    rh0,#%00
3950: F8F0           djnz    r8,%3872
3952: E0F0           jr      n,%3934
3954: F800           dbjnz   rl0,%3956
3956: 1020           cpl     rr0,@r2
3958: 4060 7060      addb    rh0,%7060(r6)
395C: 4020 1000      addb    rh0,%1000(r2)
3960: 0000 00FC      addb    rh0,#%fc
3964: F8F4           djnz    r8,%387e
3966: F0F0           djnz    r0,%3888
3968: F4F8           djnz    r4,%387a
396A: FC00           dbjnz   rl4,%396c
396C: 00FC           addb    rl4,@r15
396E: F8F0           djnz    r8,%3890
3970: ECEC           jr      po/nov,%394a
3972: F0F4           djnz    r0,%388c
3974: F8FC           djnz    r8,%387e
3976: 0000 0000      addb    rh0,#%00
397A: 0004 0810      addb    rh4,#%10
397E: 2020           ldb     rh0,@r2
3980: 1810           multl   rq0,@r1
3982: 0808 0810      xorb    rl0,#%10
3986: 2028           ldb     rl0,@r2
3988: 2820           incb    @r2,1
398A: 1810           multl   rq0,@r1
398C: 0C08           .word   #%0c08
398E: 0400 0000      orb     rh0,#%00
3992: 0000 0000      addb    rh0,#%00
3996: 0000 0000      addb    rh0,#%00
399A: 0000 0000      addb    rh0,#%00
399E: 0000 0000      addb    rh0,#%00
39A2: 0000 0000      addb    rh0,#%00
39A6: 0000 0000      addb    rh0,#%00
39AA: 0000 0000      addb    rh0,#%00
39AE: 0000 0810      addb    rh0,#%10
39B2: 1410           ldl     rr0,@r1
39B4: 0800 0000      xorb    rh0,#%00
39B8: 0000 0000      addb    rh0,#%00
39BC: 0000 0000      addb    rh0,#%00
39C0: ECD8           jr      po/nov,%3972
39C2: C4D8           ldb     rh4,#%d8
39C4: EC00           jr      po/nov,%39c6
39C6: 1428           ldl     rr8,@r2
39C8: 3C28           inb     rl0,@r2
39CA: 1400 F8F4 F4F4 ldl     rr0,#%f8f4f4f4
39D0: F8FC           djnz    r8,%38da
39D2: 0000 0000      addb    rh0,#%00
39D6: 0000 0000      addb    rh0,#%00
39DA: 0000 0000      addb    rh0,#%00
39DE: 0000 0000      addb    rh0,#%00
39E2: 0000 0000      addb    rh0,#%00
39E6: 0000 0000      addb    rh0,#%00
39EA: 00FF           addb    rl7,@r15
39EC: FEFC           djnz    r14,%38f6
39EE: FAF8           djnz    r10,%3900
39F0: F8F8           djnz    r8,%3902
39F2: F8F8           djnz    r8,%3904
39F4: F8FA           djnz    r8,%3902
39F6: FCFF           djnz    r12,%38fa
39F8: 0000 0000      addb    rh0,#%00
39FC: 0000 0000      addb    rh0,#%00
3A00: 0000 0000      addb    rh0,#%00
3A04: 0000 0000      addb    rh0,#%00
3A08: 0000 0000      addb    rh0,#%00
3A0C: 0000 F0E0      addb    rh0,#%e0
3A10: D0D0           calr    %3872
3A12: E0F0           jr      n,%39f4
3A14: 0000 1020      addb    rh0,#%20
3A18: 3040 3020      ldb     rh0,r4(#%3020)
3A1C: 1000 00F0 E0D0 cpl     rr0,#%00f0e0d0
3A22: C8D0           ldb     rl0,#%d0
3A24: E0F0           jr      n,%3a06
3A26: 0000 F8F0      addb    rh0,#%f0
3A2A: E8E0           jr      %39ec
3A2C: E0E8           jr      n,%39fe
3A2E: F0F8           djnz    r0,%3940
3A30: FC00           dbjnz   rl4,%3a32
3A32: 0408 0C10      orb     rl0,#%10
3A36: 0C08           .word   #%0c08
3A38: 0400 FCF8      orb     rh0,#%f8
3A3C: F4F0           djnz    r4,%395e
3A3E: F4F8           djnz    r4,%3950
3A40: FC00           dbjnz   rl4,%3a42
3A42: 0810           xorb    rh0,@r1
3A44: 1820           multl   rq0,@r2
3A46: 1810           multl   rq0,@r1
3A48: 0800 0000      xorb    rh0,#%00
3A4C: F0E0           djnz    r0,%398e
3A4E: D0C4           calr    %38c8
3A50: D0E0           calr    %3892
3A52: F0F8           djnz    r0,%3964
3A54: 0000 0000      addb    rh0,#%00
3A58: 0000 0000      addb    rh0,#%00
3A5C: 0000 0000      addb    rh0,#%00
3A60: 0000 0000      addb    rh0,#%00
3A64: 0000 0000      addb    rh0,#%00
3A68: 00F0           addb    rh0,@r15
3A6A: E0D0           jr      n,%3a0c
3A6C: D0E0           calr    %38ae
3A6E: F0F8           djnz    r0,%3980
3A70: 0000 1020      addb    rh0,#%20
3A74: 3038 3020      ldb     rl0,r3(#%3020)
3A78: 1008 0000 0000 cpl     rr8,#%00000000
3A7E: F8F0           djnz    r8,%39a0
3A80: E0D0           jr      n,%3a22
3A82: C8D0           ldb     rl0,#%d0
3A84: E0F0           jr      n,%3a66
3A86: F8FC           djnz    r8,%3990
3A88: 0008 1018      addb    rl0,#%18
3A8C: 2030           ldb     rh0,@r3
3A8E: 3030 2018      ldb     rh0,r3(#%2018)
3A92: 1008 0402 0000 cpl     rr8,#%04020000
3A98: 0000 0000      addb    rh0,#%00
3A9C: 0000 0000      addb    rh0,#%00
3AA0: 0000 F0E0      addb    rh0,#%e0
3AA4: C0A0           ldb     rh0,#%a0
3AA6: 9090           cpl     rr0,rr9
3AA8: A0C0           ldb     rh0,rl4
3AAA: E0F0           jr      n,%3a8c
3AAC: F800           dbjnz   rl0,%3aae
3AAE: 0000 0000      addb    rh0,#%00
3AB2: 0000 0000      addb    rh0,#%00
3AB6: 0000 00FE      addb    rh0,#%fe
3ABA: FEFC           djnz    r14,%39c4
3ABC: F8F0           djnz    r8,%39de
3ABE: E0F0           jr      n,%3aa0
3AC0: F800           dbjnz   rl0,%3ac2
3AC2: 1020           cpl     rr0,@r2
3AC4: 3020 1008      ldb     rh0,r2(#%1008)
3AC8: 0010           addb    rh0,@r1
3ACA: 2030           ldb     rh0,@r3
3ACC: 2010           ldb     rh0,@r1
3ACE: 0800 00F0      xorb    rh0,#%f0
3AD2: E8E0           jr      %3a94
3AD4: E8F0           jr      %3ab6
3AD6: F8FC           djnz    r8,%39e0
3AD8: 0000 0000      addb    rh0,#%00
3ADC: 0000 0000      addb    rh0,#%00
3AE0: 242A           setb    @r2,10
3AE2: 2624           bitb    @r2,4
3AE4: 2424           setb    @r2,4
3AE6: 2424           setb    @r2,4
3AE8: 2424           setb    @r2,4
3AEA: 2724           bit     @r2,4
3AEC: 2424           setb    @r2,4
3AEE: 2524           set     @r2,4
3AF0: 0001 0203      addb    rh1,#%03
3AF4: 0405 0607      orb     rh5,#%07
3AF8: 0809 2424      xorb    rl1,#%24
3AFC: 2824           incb    @r2,5
3AFE: 2924           inc     @r2,5
3B00: 240A 0B0C      setb    rl3,r10
3B04: 0D0E           .word   #%0d0e
3B06: 0F10           ext0f   #%10
3B08: 1112           pushl   @r1,@r2
3B0A: 1314           push    @r1,@r4
3B0C: 1516           popl    @r6,@r1
3B0E: 1718           pop     @r8,@r1
3B10: 191A           mult    rr10,@r1
3B12: 1B1C           div     rr12,@r1
3B14: 1D1E           ldl     @r1,rr14
3B16: 1F20           call    r2
3B18: 2122           ld      r2,@r2
3B1A: 233A           res     @r3,10
3B1C: 243B           setb    @r3,11
3B1E: 2424           setb    @r2,4
3B20: 2428           setb    @r2,8
3B22: 292A           inc     @r2,11
3B24: 2B2C           dec     @r2,13
3B26: 2D2E           ex      r14,@r2
3B28: 2F34           ld      @r3,r4
3B2A: 352C 362D      ldl     rr12,r2(#%362d)
3B2E: 3738 393A      ldl     r3(#%393a),rr8
3B32: 3B3C           .word   #%3b3c
3B34: 8C8D           .word   #%8c8d
3B36: 8E8F           ext8e   #%8f
3B38: 898A           xor     r10,r8
3B3A: 8B24           cp      r4,r2
3B3C: 2424           setb    @r2,4
3B3E: 2424           setb    @r2,4
3B40: FFFF           djnz    r15,%3a44
3B42: FFFF           djnz    r15,%3a46
3B44: FFFF           djnz    r15,%3a48
3B46: FFFF           djnz    r15,%3a4a
3B48: FFFF           djnz    r15,%3a4c
3B4A: FFFF           djnz    r15,%3a4e
3B4C: FFFF           djnz    r15,%3a50
3B4E: FFFF           djnz    r15,%3a52
3B50: FFFF           djnz    r15,%3a54
3B52: FFFF           djnz    r15,%3a56
3B54: FFFF           djnz    r15,%3a58
3B56: FFFF           djnz    r15,%3a5a
3B58: FFFF           djnz    r15,%3a5c
3B5A: FFFF           djnz    r15,%3a5e
3B5C: FFFF           djnz    r15,%3a60
3B5E: FFFF           djnz    r15,%3a62
3B60: FFFF           djnz    r15,%3a64
3B62: FFFF           djnz    r15,%3a66
3B64: FFFF           djnz    r15,%3a68
3B66: FFFF           djnz    r15,%3a6a
3B68: FFFF           djnz    r15,%3a6c
3B6A: FFFF           djnz    r15,%3a6e
3B6C: FFFF           djnz    r15,%3a70
3B6E: FFFF           djnz    r15,%3a72
3B70: FFFF           djnz    r15,%3a74
3B72: FFFF           djnz    r15,%3a76
3B74: FFFF           djnz    r15,%3a78
3B76: FFFF           djnz    r15,%3a7a
3B78: FFFF           djnz    r15,%3a7c
3B7A: FFFF           djnz    r15,%3a7e
3B7C: FFFF           djnz    r15,%3a80
3B7E: FFFF           djnz    r15,%3a82
3B80: FFFF           djnz    r15,%3a84
3B82: FFE3           djnz    r15,%3abe
3B84: BA9B           .word   #%ba9b
3B86: 8370           sub     r0,r7
3B88: 6155 4B42      ld      r5,%4b42(r5)
3B8C: 3B35 302C      sin    r3,#%302c
3B90: 2825           incb    @r2,6
3B92: 221F           resb    @r1,15
3B94: 1D1B           ldl     @r1,rr11
3B96: 1917           mult    rr7,@r1
3B98: 1614           addl    rr4,@r1
3B9A: 1312           push    @r1,@r2
3B9C: 1110           .word   #%1110
3B9E: 0F0E           ext0f   #%0e
3BA0: 0D0D           .word   #%0d0d
3BA2: 0C0C           .word   #%0c0c
3BA4: 0B0B 0A0A      cp      r11,#%0a0a
3BA8: 0909 0808      xor     r9,#%0808
3BAC: 0807 0707      xorb    rh7,#%07
3BB0: 0706 0606      and     r6,#%0606
3BB4: 0606 0505      andb    rh6,#%05
3BB8: 0505 0505      or      r5,#%0505
3BBC: 0404 0404      orb     rh4,#%04
3BC0: 0404 0404      orb     rh4,#%04
3BC4: 0303 0303      sub     r3,#%0303
3BC8: 0303 0303      sub     r3,#%0303
3BCC: 0303 0303      sub     r3,#%0303
3BD0: 0302 0202      sub     r2,#%0202
3BD4: 0202 0202      subb    rh2,#%02
3BD8: 0202 0202      subb    rh2,#%02
3BDC: 0202 0202      subb    rh2,#%02
3BE0: 0202 0202      subb    rh2,#%02
3BE4: 0202 0201      subb    rh2,#%01
3BE8: 0101 0101      add     r1,#%0101
3BEC: 0101 0101      add     r1,#%0101
3BF0: 5600 5800      addl    rr0,%5800
3BF4: 6000 6200      ldb     rh0,%6200
3BF8: 6400 6600      setb    %6600,0
3BFC: 6800 7000      incb    %7000,1
3C00: 5500           .word   #%5500
3C02: 5700           .word   #%5700
3C04: 5900 6100      mult    rr0,%6100
3C08: 6300 6500      res     %6500,0
3C0C: 6700 6900      bit     %6900,0
3C10: 5450 5650      ldl     rr0,%5650(r5)
3C14: 5850 6050      multl   rq0,%6050(r5)
3C18: 6250 6450      resb    %6450(r5),0
3C1C: 6650 6850      bitb    %6850(r5),0
3C20: 5400 5600      ldl     rr0,%5600
3C24: 5800 6000      multl   rq0,%6000
3C28: 6200 6400      resb    %6400,0
3C2C: 6600 6800      bitb    %6800,0
3C30: 5400 5600      ldl     rr0,%5600
3C34: 5800 6000      multl   rq0,%6000
3C38: 6200 6400      resb    %6400,0
3C3C: 6600 6800      bitb    %6800,0
3C40: 5300           .word   #%5300
3C42: 5500           .word   #%5500
3C44: 5700           .word   #%5700
3C46: 5900 6100      mult    rr0,%6100
3C4A: 6300 6500      res     %6500,0
3C4E: 6700 5250      bit     %5250,0
3C52: 5450 5650      ldl     rr0,%5650(r5)
3C56: 5850 6050      multl   rq0,%6050(r5)
3C5A: 6250 6450      resb    %6450(r5),0
3C5E: 6650 5200      bitb    %5200(r5),0
3C62: 5400 5600      ldl     rr0,%5600
3C66: 5800 6000      multl   rq0,%6000
3C6A: 6200 6400      resb    %6400,0
3C6E: 6600 5500      bitb    %5500,0
3C72: 5700           .word   #%5700
3C74: 5900 6100      mult    rr0,%6100
3C78: 6300 6500      res     %6500,0
3C7C: 6700 6900      bit     %6900,0
3C80: 5400 5600      ldl     rr0,%5600
3C84: 5800 6000      multl   rq0,%6000
3C88: 6200 6400      resb    %6400,0
3C8C: 6600 6800      bitb    %6800,0
3C90: 5350 5550      push    @r5,%5550
3C94: 5750 5950      pop     %5950,@r5
3C98: 6150 6350      ld      r0,%6350(r5)
3C9C: 6550 6750      set     %6750(r5),0
3CA0: 5300           .word   #%5300
3CA2: 5500           .word   #%5500
3CA4: 5700           .word   #%5700
3CA6: 5900 6100      mult    rr0,%6100
3CAA: 6300 6500      res     %6500,0
3CAE: 6700 5800      bit     %5800,0
3CB2: 6000 6200      ldb     rh0,%6200
3CB6: 6400 6600      setb    %6600,0
3CBA: 6800 7000      incb    %7000,1
3CBE: 7200           .word   #%7200
3CC0: 5700           .word   #%5700
3CC2: 5900 6100      mult    rr0,%6100
3CC6: 6300 6500      res     %6500,0
3CCA: 6700 6900      bit     %6900,0
3CCE: 7100           .word   #%7100
3CD0: 5650 5850      addl    rr0,%5850(r5)
3CD4: 6050 6250      ldb     rh0,%6250(r5)
3CD8: 6450 6650      setb    %6650(r5),0
3CDC: 6850 7050      incb    %7050(r5),1
3CE0: 5600 5800      addl    rr0,%5800
3CE4: 6000 6200      ldb     rh0,%6200
3CE8: 6400 6600      setb    %6600,0
3CEC: 6800 7000      incb    %7000,1
3CF0: 502B 3900      cpl     rr11,%3900(r2)
3CF4: 0000 0000      addb    rh0,#%00
3CF8: 4B2E 3800      cp      r14,%3800(r2)
3CFC: 0000 0000      addb    rh0,#%00
3D00: 4B2C 3700      cp      r12,%3700(r2)
3D04: 0000 0000      addb    rh0,#%00
3D08: 4B2A 3600      cp      r10,%3600(r2)
3D0C: 0000 0000      addb    rh0,#%00
3D10: 502E 3939      cpl     rr14,%3939(r2)
3D14: 0000 0000      addb    rh0,#%00
3D18: 4B31 3838      cp      r1,%3838(r3)
3D1C: 0000 0000      addb    rh0,#%00
3D20: 4B2F 3737      cp      r15,%3737(r2)
3D24: 0000 0000      addb    rh0,#%00
3D28: 4B2D 3636      cp      r13,%3636(r2)
3D2C: 0000 0000      addb    rh0,#%00
3D30: 502E 3A3A      cpl     rr14,%3a3a(r2)
3D34: 3A00 0000      inirb  @r0,@r0,r0
3D38: 4B31 3939      cp      r1,%3939(r3)
3D3C: 3900           .word   #%3900
3D3E: 0000 4B2F      addb    rh0,#%2f
3D42: 3838           rsvd38
3D44: 3800           rsvd38
3D46: 0000 4B2D      addb    rh0,#%2d
3D4A: 3737 3700      ldl     r3(#%3700),rr7
3D4E: 0000 502E      addb    rh0,#%2e
3D52: 3A3A 3A3C      outdb  @r3,@r3,r10
3D56: 0000 4B31      addb    rh0,#%31
3D5A: 3939           .word   #%3939
3D5C: 393B           .word   #%393b
3D5E: 0000 4B2F      addb    rh0,#%2f
3D62: 3838           rsvd38
3D64: 383A           rsvd38
3D66: 0000 4B2D      addb    rh0,#%2d
3D6A: 3737 3739      ldl     r3(#%3739),rr7
3D6E: 0000 5027      addb    rh0,#%27
3D72: 3700 0000      ldrl    %3d76,rr0
3D76: 0000 4B2A      addb    rh0,#%2a
3D7A: 3600           bpt
3D7C: 0000 0000      addb    rh0,#%00
3D80: 4B28 3500      cp      r8,%3500(r2)
3D84: 0000 0000      addb    rh0,#%00
3D88: 4B26 3400      cp      r6,%3400(r2)
3D8C: 0000 0000      addb    rh0,#%00
3D90: 502A 3737      cpl     rr10,%3737(r2)
3D94: 0000 0000      addb    rh0,#%00
3D98: 4B2D 3636      cp      r13,%3636(r2)
3D9C: 0000 0000      addb    rh0,#%00
3DA0: 4B2B 3535      cp      r11,%3535(r2)
3DA4: 0000 0000      addb    rh0,#%00
3DA8: 4B29 3434      cp      r9,%3434(r2)
3DAC: 0000 0000      addb    rh0,#%00
3DB0: 502A 3838      cpl     rr10,%3838(r2)
3DB4: 3800           rsvd38
3DB6: 0000 4B2D      addb    rh0,#%2d
3DBA: 3737 3700      ldl     r3(#%3700),rr7
3DBE: 0000 4B2B      addb    rh0,#%2b
3DC2: 3636           rsvd36
3DC4: 3600           bpt
3DC6: 0000 4B29      addb    rh0,#%29
3DCA: 3535 3500      ldl     rr5,r3(#%3500)
3DCE: 0000 502A      addb    rh0,#%2a
3DD2: 3838           rsvd38
3DD4: 383A           rsvd38
3DD6: 0000 4B2D      addb    rh0,#%2d
3DDA: 3737 3739      ldl     r3(#%3739),rr7
3DDE: 0000 4B2B      addb    rh0,#%2b
3DE2: 3636           rsvd36
3DE4: 3638           rsvd36
3DE6: 0000 4B29      addb    rh0,#%29
3DEA: 3535 3537      ldl     rr5,r3(#%3537)
3DEE: 0000 502B      addb    rh0,#%2b
3DF2: 3900           .word   #%3900
3DF4: 0000 0000      addb    rh0,#%00
3DF8: 4B2E 3800      cp      r14,%3800(r2)
3DFC: 0000 0000      addb    rh0,#%00
3E00: 4B2C 3700      cp      r12,%3700(r2)
3E04: 0000 0000      addb    rh0,#%00
3E08: 4B2A 3600      cp      r10,%3600(r2)
3E0C: 0000 0000      addb    rh0,#%00
3E10: 502E 3939      cpl     rr14,%3939(r2)
3E14: 0000 0000      addb    rh0,#%00
3E18: 4B31 3838      cp      r1,%3838(r3)
3E1C: 0000 0000      addb    rh0,#%00
3E20: 4B2F 3737      cp      r15,%3737(r2)
3E24: 0000 0000      addb    rh0,#%00
3E28: 4B2D 3636      cp      r13,%3636(r2)
3E2C: 0000 0000      addb    rh0,#%00
3E30: 502E 3A3A      cpl     rr14,%3a3a(r2)
3E34: 3A00 0000      inirb  @r0,@r0,r0
3E38: 4B31 3939      cp      r1,%3939(r3)
3E3C: 3900           .word   #%3900
3E3E: 0000 4B2F      addb    rh0,#%2f
3E42: 3838           rsvd38
3E44: 3800           rsvd38
3E46: 0000 4B2D      addb    rh0,#%2d
3E4A: 3737 3700      ldl     r3(#%3700),rr7
3E4E: 0000 502E      addb    rh0,#%2e
3E52: 3A3A 3A3C      outdb  @r3,@r3,r10
3E56: 0000 4B31      addb    rh0,#%31
3E5A: 3939           .word   #%3939
3E5C: 393B           .word   #%393b
3E5E: 0000 4B2F      addb    rh0,#%2f
3E62: 3838           rsvd38
3E64: 383A           rsvd38
3E66: 0000 4B2D      addb    rh0,#%2d
3E6A: 3737 3739      ldl     r3(#%3739),rr7
3E6E: 0000 502D      addb    rh0,#%2d
3E72: 3A00 0000      inirb  @r0,@r0,r0
3E76: 0000 4B30      addb    rh0,#%30
3E7A: 3900           .word   #%3900
3E7C: 0000 0000      addb    rh0,#%00
3E80: 4B2E 3800      cp      r14,%3800(r2)
3E84: 0000 0000      addb    rh0,#%00
3E88: 4B2C 3700      cp      r12,%3700(r2)
3E8C: 0000 0000      addb    rh0,#%00
3E90: 5030 3A3A      cpl     rr0,%3a3a(r3)
3E94: 0000 0000      addb    rh0,#%00
3E98: 4B33 3939      cp      r3,%3939(r3)
3E9C: 0000 0000      addb    rh0,#%00
3EA0: 4B31 3838      cp      r1,%3838(r3)
3EA4: 0000 0000      addb    rh0,#%00
3EA8: 4B2F 3737      cp      r15,%3737(r2)
3EAC: 0000 0000      addb    rh0,#%00
3EB0: 5030 3B3B      cpl     rr0,%3b3b(r3)
3EB4: 3B00 0000      inir   @r0,@r0,r0
3EB8: 4B33 3A3A      cp      r3,%3a3a(r3)
3EBC: 3A00 0000      inirb  @r0,@r0,r0
3EC0: 4B31 3939      cp      r1,%3939(r3)
3EC4: 3900           .word   #%3900
3EC6: 0000 4B2F      addb    rh0,#%2f
3ECA: 3838           rsvd38
3ECC: 3800           rsvd38
3ECE: 0000 5030      addb    rh0,#%30
3ED2: 3B3B 3B3D      sotdr  @r3,@r3,rl3
3ED6: 0000 4B33      addb    rh0,#%33
3EDA: 3A3A 3A3C      outdb  @r3,@r3,r10
3EDE: 0000 4B31      addb    rh0,#%31
3EE2: 3939           .word   #%3939
3EE4: 393B           .word   #%393b
3EE6: 0000 4B2F      addb    rh0,#%2f
3EEA: 3838           rsvd38
3EEC: 383A           rsvd38
3EEE: 0000 1C1D      addb    rh0,#%1d
3EF2: 1E1F           jp      nc/uge,@rr1
3EF4: 2022           ldb     rh2,@r2
3EF6: 2425           setb    @r2,5
3EF8: 2627           bitb    @r2,7
3EFA: 2727           bit     @r2,7
3EFC: 2828           incb    @r2,9
3EFE: 292A           inc     @r2,11
3F00: 2A2B           decb    @r2,12
3F02: 2C2E           exb     rl6,@r2
3F04: 3032 3435      ldb     rh2,r3(#%3435)
3F08: 3637           rsvd36
3F0A: 393A           .word   #%393a
3F0C: 3C3D           inb     rl5,@r3
3F0E: 3E3F           outb    @r3,rl7
3F10: 403F 3E3D      addb    rl7,%3e3d(r3)
3F14: 3C3B           inb     rl3,@r3
3F16: 3835           rsvd38
3F18: 312E 2A25      ld      r14,r2(#%2a25)
3F1C: 201B           ldb     rl3,@r1
3F1E: 1510           .word   #%1510
3F20: 0A06 0000      cpb     rh6,#%00
3F24: 0000 0000      addb    rh0,#%00
3F28: 0000 0000      addb    rh0,#%00
3F2C: 0000 0000      addb    rh0,#%00
3F30: 786E           rsvd78
3F32: 877D           and     r13,r7
3F34: 0010           addb    rh0,@r1
3F36: 0010           addb    rh0,@r1
3F38: 0010           addb    rh0,@r1
3F3A: 0010           addb    rh0,@r1
3F3C: 0010           addb    rh0,@r1
3F3E: 0010           addb    rh0,@r1
3F40: 0010           addb    rh0,@r1
3F42: 0010           addb    rh0,@r1
3F44: 0010           addb    rh0,@r1
3F46: 0010           addb    rh0,@r1
3F48: 0010           addb    rh0,@r1
3F4A: 0010           addb    rh0,@r1
3F4C: 0010           addb    rh0,@r1
3F4E: 0010           addb    rh0,@r1
3F50: 0010           addb    rh0,@r1
3F52: 0010           addb    rh0,@r1
3F54: 0010           addb    rh0,@r1
3F56: 0010           addb    rh0,@r1
3F58: 0010           addb    rh0,@r1
3F5A: 0010           addb    rh0,@r1
3F5C: 0010           addb    rh0,@r1
3F5E: 0010           addb    rh0,@r1
3F60: 0010           addb    rh0,@r1
3F62: 0010           addb    rh0,@r1
3F64: 0010           addb    rh0,@r1
3F66: 0010           addb    rh0,@r1
3F68: 0010           addb    rh0,@r1
3F6A: 0010           addb    rh0,@r1
3F6C: 0010           addb    rh0,@r1
3F6E: 0010           addb    rh0,@r1
3F70: 0010           addb    rh0,@r1
3F72: 0010           addb    rh0,@r1
3F74: 0010           addb    rh0,@r1
3F76: 0010           addb    rh0,@r1
3F78: 0010           addb    rh0,@r1
3F7A: 0010           addb    rh0,@r1
3F7C: 0010           addb    rh0,@r1
3F7E: 0010           addb    rh0,@r1
3F80: 0010           addb    rh0,@r1
3F82: 0010           addb    rh0,@r1
3F84: 0010           addb    rh0,@r1
3F86: 0010           addb    rh0,@r1
3F88: 0010           addb    rh0,@r1
3F8A: 0010           addb    rh0,@r1
3F8C: 0010           addb    rh0,@r1
3F8E: 0010           addb    rh0,@r1
3F90: 0010           addb    rh0,@r1
3F92: 0010           addb    rh0,@r1
3F94: 0010           addb    rh0,@r1
3F96: 0010           addb    rh0,@r1
3F98: 0010           addb    rh0,@r1
3F9A: 0010           addb    rh0,@r1
3F9C: 0010           addb    rh0,@r1
3F9E: 0010           addb    rh0,@r1
3FA0: 0010           addb    rh0,@r1
3FA2: 0010           addb    rh0,@r1
3FA4: 0010           addb    rh0,@r1
3FA6: 0010           addb    rh0,@r1
3FA8: 0010           addb    rh0,@r1
3FAA: 0010           addb    rh0,@r1
3FAC: 0010           addb    rh0,@r1
3FAE: 0010           addb    rh0,@r1
3FB0: 0010           addb    rh0,@r1
3FB2: 0010           addb    rh0,@r1
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
3FFE: 9C22           .word   #%9c22
