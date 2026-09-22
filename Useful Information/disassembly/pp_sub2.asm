0000: 0000           .word   #%0000 ;RST
0002: 4000           .word   #%4000 ;RST FCW
0004: 2800           .word   #%2800 ;RST PC
0006: 210F 8F00      ld      r15,#%8f00
000A: 2100 0100      ld      r0,#%0100
000E: 7D0D           ldctl   psapoff,r0
0010: 8D08           clr     r0
0012: 7D0B           ldctl   refresh,r0
0014: 4D05 6002 0000 ld      %6002,#%0000
001A: 4D05 6002 0001 ld      %6002,#%0001
0020: 7C06           ei      nvi
0022: 4D05 8840 0005 ld      %8840,#%0005
0028: 4D05 80E2 0005 ld      %80e2,#%0005
002E: 4D05 889E 0096 ld      %889e,#%0096
0034: DF28           calr    %01e6
0036: DF60           calr    %0178
0038: DF21           calr    %01f8
003A: DEEE           calr    %0260
003C: DE67           calr    %0370
003E: DE90           calr    %0320
0040: E8FB           jr      %0038
0042: 6100 8898      ld      r0,%8898
0046: 8100           add     r0,r0
0048: 8100           add     r0,r0
004A: 4100 8898      add     r0,%8898
004E: A900           inc     r0,1
0050: 4100 8820      add     r0,%8820
0054: 6F00 8898      ld      %8898,r0
0058: 9E08           ret     
005A: FFFF           djnz    r15,%ffffff5e
005C: FFFF           djnz    r15,%ffffff60
005E: FFFF           djnz    r15,%ffffff62
0060: FFFF           djnz    r15,%ffffff64
0062: FFFF           djnz    r15,%ffffff66
0064: FFFF           djnz    r15,%ffffff68
0066: FFFF           djnz    r15,%ffffff6a
0068: FFFF           djnz    r15,%ffffff6c
006A: FFFF           djnz    r15,%ffffff6e
006C: FFFF           djnz    r15,%ffffff70
006E: FFFF           djnz    r15,%ffffff72
0070: FFFF           djnz    r15,%ffffff74
0072: FFFF           djnz    r15,%ffffff76
0074: FFFF           djnz    r15,%ffffff78
0076: FFFF           djnz    r15,%ffffff7a
0078: FFFF           djnz    r15,%ffffff7c
007A: FFFF           djnz    r15,%ffffff7e
007C: FFFF           djnz    r15,%ffffff80
007E: FFFF           djnz    r15,%ffffff82
0080: FFFF           djnz    r15,%ffffff84
0082: FFFF           djnz    r15,%ffffff86
0084: FFFF           djnz    r15,%ffffff88
0086: FFFF           djnz    r15,%ffffff8a
0088: FFFF           djnz    r15,%ffffff8c
008A: FFFF           djnz    r15,%ffffff8e
008C: FFFF           djnz    r15,%ffffff90
008E: FFFF           djnz    r15,%ffffff92
0090: FFFF           djnz    r15,%ffffff94
0092: FFFF           djnz    r15,%ffffff96
0094: FFFF           djnz    r15,%ffffff98
0096: FFFF           djnz    r15,%ffffff9a
0098: FFFF           djnz    r15,%ffffff9c
009A: FFFF           djnz    r15,%ffffff9e
009C: FFFF           djnz    r15,%ffffffa0
009E: FFFF           djnz    r15,%ffffffa2
00A0: FFFF           djnz    r15,%ffffffa4
00A2: FFFF           djnz    r15,%ffffffa6
00A4: FFFF           djnz    r15,%ffffffa8
00A6: FFFF           djnz    r15,%ffffffaa
00A8: FFFF           djnz    r15,%ffffffac
00AA: FFFF           djnz    r15,%ffffffae
00AC: FFFF           djnz    r15,%ffffffb0
00AE: FFFF           djnz    r15,%ffffffb2
00B0: FFFF           djnz    r15,%ffffffb4
00B2: FFFF           djnz    r15,%ffffffb6
00B4: FFFF           djnz    r15,%ffffffb8
00B6: FFFF           djnz    r15,%ffffffba
00B8: FFFF           djnz    r15,%ffffffbc
00BA: FFFF           djnz    r15,%ffffffbe
00BC: FFFF           djnz    r15,%ffffffc0
00BE: FFFF           djnz    r15,%ffffffc2
00C0: FFFF           djnz    r15,%ffffffc4
00C2: FFFF           djnz    r15,%ffffffc6
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
0104: 4000 0006      addb    rh0,%0006
0108: 4000 0006      addb    rh0,%0006
010C: 4000 0006      addb    rh0,%0006
0110: 0000 0000      addb    rh0,#%00
0114: 4000 0006      addb    rh0,%0006
0118: 4000 011C      addb    rh0,%011c
011C: 4D08 6002      clr     %6002
0120: 4D08 82BE      clr     %82be
0124: 030F 001E      sub     r15,#%001e
0128: 1CF9 000E      ldm     @r15,r0,#15
012C: DCA9           calr    %07dc
012E: 5F00 1750      call    %1750
0132: 5F00 1780      call    %1780
0136: DCE3           calr    %0772
0138: DCF1           calr    %0758
013A: DD06           calr    %0730
013C: 5F00 195A      call    %195a
0140: 5F00 1A42      call    %1a42
0144: 5F00 1B7C      call    %1b7c
0148: 5F00 16B8      call    %16b8
014C: 5F00 1CEC      call    %1cec
0150: 5F00 1D42      call    %1d42
0154: 5F00 1DA2      call    %1da2
0158: 5F00 1E2C      call    %1e2c
015C: 5F00 1EC0      call    %1ec0
0160: 5F00 167E      call    %167e
0164: 6900 8820      inc     %8820,1
0168: 1CF1 000E      ldm     r0,@r15,#15
016C: 010F 001E      add     r15,#%001e
0170: 4D05 6002 0001 ld      %6002,#%0001
0176: 7B00           iret
0178: 7601 8700      lda     pr1,%8700
017C: 7602 8F00      lda     pr2,%8f00
0180: 2100 0080      ld      r0,#%0080
0184: 0D15 0000      ld      @r1,#%0000
0188: 0D25 0000      ld      @r2,#%0000
018C: A911           inc     r1,2
018E: A921           inc     r2,2
0190: F087           djnz    r0,%0184
0192: 4D05 89F8 0000 ld      %89f8,#%0000
0198: 210A 0007      ld      r10,#%0007
019C: 210B 8B00      ld      r11,#%8b00
01A0: 4DB5 0000 8002 ld      %0000(r11),#%8002
01A6: 61B0 0006      ld      r0,%0006(r11)
01AA: B301 0005      sll     r0,#5
01AE: B309 FFFB      sra     r0,#5
01B2: 6FB0 0006      ld      %0006(r11),r0
01B6: 010B 0020      add     r11,#%0020
01BA: FA8E           djnz    r10,%01a0
01BC: 210A 0006      ld      r10,#%0006
01C0: 4DB5 0000 0000 ld      %0000(r11),#%0000
01C6: 010B 0020      add     r11,#%0020
01CA: FA86           djnz    r10,%01c0
01CC: 2101 AA00      ld      r1,#%aa00
01D0: 2100 0042      ld      r0,#%0042
01D4: 0D15 FFFF      ld      @r1,#%ffff
01D8: A911           inc     r1,2
01DA: F084           djnz    r0,%01d4
01DC: 4D08 81B0      clr     %81b0
01E0: 4D08 883C      clr     %883c
01E4: 9E08           ret     
01E6: 210A 0400      ld      r10,#%0400
01EA: 210B 9800      ld      r11,#%9800
01EE: 0DB5 0124      ld      @r11,#%0124
01F2: A9B1           inc     r11,2
01F4: FA84           djnz    r10,%01ee
01F6: 9E08           ret     
01F8: 6101 8180      ld      r1,%8180
01FC: 0301 0040      sub     r1,#%0040
0200: B311 FFFD      srl     r1,#3
0204: 2100 0006      ld      r0,#%0006
0208: DFF3           calr    %0224
020A: 0101 002C      add     r1,#%002c
020E: 2100 0006      ld      r0,#%0006
0212: E808           jr      %0224
0214: 6101 8180      ld      r1,%8180
0218: 0301 0040      sub     r1,#%0040
021C: B311 FFFD      srl     r1,#3
0220: 2100 003C      ld      r0,#%003c
0224: 8C18           clrb    rh1
0226: 601A 3850      ldb     rl2,%3850(r1)
022A: 0702 00FF      and     r2,#%00ff
022E: B321 0002      sll     r2,#2
0232: 5422 3950      ldl     rr2,%3950(r2)
0236: A114           ld      r4,r1
0238: 0704 003F      and     r4,#%003f
023C: B341 0005      sll     r4,#5
0240: 0504 A01C      or      r4,#%a01c
0244: 1D42           ldl     @r4,rr2
0246: AB41           dec     r4,2
0248: 7605 3B50      lda     pr5,%3b50
024C: 2102 000C      ld      r2,#%000c
0250: 2153           ld      r3,@r5
0252: 2F43           ld      @r4,r3
0254: AB41           dec     r4,2
0256: A951           inc     r5,2
0258: F285           djnz    r2,%0250
025A: A910           inc     r1,1
025C: F09D           djnz    r0,%0224
025E: 9E08           ret     
0260: 210B 3B68      ld      r11,#%3b68
0264: 6101 8180      ld      r1,%8180
0268: 0301 0040      sub     r1,#%0040
026C: B311 FFFD      srl     r1,#3
0270: 20BB           ldb     rl3,@r11
0272: A0BD           ldb     rl5,rl3
0274: A9B0           inc     r11,1
0276: 829B           subb    rl3,rl1
0278: 020B 0606      subb    rl3,#%06
027C: 0A0B 0606      cpb     rl3,#%06
0280: E705           jr      c/ult,%028c
0282: 020B 2020      subb    rl3,#%20
0286: 0A0B 0606      cpb     rl3,#%06
028A: EF0A           jr      nc/uge,%02a0
028C: 0705 003F      and     r5,#%003f
0290: B351 0005      sll     r5,#5
0294: 0505 A000      or      r5,#%a000
0298: DFD4           calr    %02f2
029A: 0CB4           testb   @r11
029C: EEE9           jr      ne/nz,%0270
029E: 9E08           ret     
02A0: A9B0           inc     r11,1
02A2: 20B8           ldb     rl0,@r11
02A4: A9B0           inc     r11,1
02A6: 8C84           testb   rl0
02A8: EEFC           jr      ne/nz,%02a2
02AA: 0CB4           testb   @r11
02AC: EEE1           jr      ne/nz,%0270
02AE: 9E08           ret     
02B0: 210B 3B68      ld      r11,#%3b68
02B4: 6101 8180      ld      r1,%8180
02B8: 0301 0040      sub     r1,#%0040
02BC: B311 FFFD      srl     r1,#3
02C0: 20BB           ldb     rl3,@r11
02C2: A0BD           ldb     rl5,rl3
02C4: A9B0           inc     r11,1
02C6: 829B           subb    rl3,rl1
02C8: 0A0B 3030      cpb     rl3,#%30
02CC: EF0A           jr      nc/uge,%02e2
02CE: 0705 003F      and     r5,#%003f
02D2: B351 0005      sll     r5,#5
02D6: 0505 A000      or      r5,#%a000
02DA: DFF5           calr    %02f2
02DC: 0CB4           testb   @r11
02DE: EEF0           jr      ne/nz,%02c0
02E0: 9E08           ret     
02E2: A9B0           inc     r11,1
02E4: 20B8           ldb     rl0,@r11
02E6: A9B0           inc     r11,1
02E8: 8C84           testb   rl0
02EA: EEFC           jr      ne/nz,%02e4
02EC: 0CB4           testb   @r11
02EE: EEE8           jr      ne/nz,%02c0
02F0: 9E08           ret     
02F2: 20B0           ldb     rh0,@r11
02F4: A9B0           inc     r11,1
02F6: 20B8           ldb     rl0,@r11
02F8: A9B0           inc     r11,1
02FA: A687           bitb    rl0,7
02FC: E603           jr      eq/z,%0304
02FE: 2F50           ld      @r5,r0
0300: A951           inc     r5,2
0302: E8F9           jr      %02f6
0304: 8C84           testb   rl0
0306: 9E06           ret     eq/z
0308: A08E           ldb     rl6,rl0
030A: 8C68           clrb    rh6
030C: 060E 1F1F      andb    rl6,#%1f
0310: 8166           add     r6,r6
0312: 8165           add     r5,r6
0314: E8F0           jr      %02f6
0316: 2105 0200      ld      r5,#%0200
031A: 2104 FE00      ld      r4,#%fe00
031E: E806           jr      %032c
0320: 2105 0020      ld      r5,#%0020
0324: 6104 8184      ld      r4,%8184
0328: 0104 0F00      add     r4,#%0f00
032C: A143           ld      r3,r4
032E: B331 FFFE      srl     r3,#2
0332: 0703 03FE      and     r3,#%03fe
0336: A142           ld      r2,r4
0338: 0302 0020      sub     r2,#%0020
033C: 0B02 0020      cp      r2,#%0020
0340: E711           jr      c/ult,%0364
0342: A131           ld      r1,r3
0344: B311 FFFD      srl     r1,#3
0348: 0701 0007      and     r1,#%0007
034C: 0101 0002      add     r1,#%0002
0350: 0B01 0006      cp      r1,#%0006
0354: E102           jr      lt,%035a
0356: 0101 0002      add     r1,#%0002
035A: 6F31 9000      ld      %9000(r3),r1
035E: A947           inc     r4,8
0360: F59B           djnz    r5,%032c
0362: 9E08           ret     
0364: A131           ld      r1,r3
0366: B311 FFFF      srl     r1,#1
036A: 0701 0001      and     r1,#%0001
036E: E8F5           jr      %035a
0370: 610E 883C      ld      r14,%883c
0374: 070E 007E      and     r14,#%007e
0378: 61E1 AA00      ld      r1,%aa00(r14)
037C: 0B01 FFFF      cp      r1,#%ffff
0380: 9E06           ret     eq/z
0382: 4DE5 AA00 FFFF ld      %aa00(r14),#%ffff
0388: A9E1           inc     r14,2
038A: 070E 007E      and     r14,#%007e
038E: 6F0E 883C      ld      %883c,r14
0392: 0B01 001D      cp      r1,#%001d
0396: 9E0F           ret     nc/uge
0398: A110           ld      r0,r1
039A: 8111           add     r1,r1
039C: 6111 03A2      ld      r1,%03a2(r1)
03A0: 1E18           jp      @rr1
03A2: 01E6           add     r6,@r14
03A4: 0476           orb     rh6,@r7
03A6: 0554           or      r4,@r5
03A8: 059E           or      r14,@r9
03AA: 05EC           or      r12,@r14
03AC: 2C3E           exb     rl6,@r3
03AE: 2DA2           ex      r2,@r10
03B0: 2DA2           ex      r2,@r10
03B2: 2CEA           exb     rl2,@r14
03B4: 2CEA           exb     rl2,@r14
03B6: 2CEA           exb     rl2,@r14
03B8: 2CEA           exb     rl2,@r14
03BA: 2CEA           exb     rl2,@r14
03BC: 2CEA           exb     rl2,@r14
03BE: 2CEA           exb     rl2,@r14
03C0: 2CEA           exb     rl2,@r14
03C2: 06FE           andb    rl6,@r15
03C4: 0712           and     r2,@r1
03C6: 2E78           ldb     @r7,rl0
03C8: 2E9C           ldb     @r9,rl4
03CA: 2EC8           ldb     @r12,rl0
03CC: 3034 071A      ldb     rh4,r3(#%071a)
03D0: 305A 040C      ldb     rl2,r5(#%040c)
03D4: 046C           orb     rl4,@r6
03D6: 03F0           sub     r0,@r15
03D8: 03E4           sub     r4,@r14
03DA: 03DC           sub     r12,@r13
03DC: 4D05 8C00 000A ld      %8c00,#%000a
03E2: 9E08           ret     
03E4: 210B 8C00      ld      r11,#%8c00
03E8: 4DB5 000C 0001 ld      %000c(r11),#%0001
03EE: 9E08           ret     
03F0: 210B 8C00      ld      r11,#%8c00
03F4: 0DB5 800A      ld      @r11,#%800a
03F8: 4DB5 0002 000C ld      %0002(r11),#%000c
03FE: 4DB5 0006 05C0 ld      %0006(r11),#%05c0
0404: 4DB5 000C 0000 ld      %000c(r11),#%0000
040A: 9E08           ret     
040C: DF05           calr    %0604
040E: 210B 8B00      ld      r11,#%8b00
0412: 210A 0007      ld      r10,#%0007
0416: 0DB5 0002      ld      @r11,#%0002
041A: 010B 0020      add     r11,#%0020
041E: FA85           djnz    r10,%0416
0420: 4D05 8188 FE00 ld      %8188,#%fe00
0426: 8D08           clr     r0
0428: A101           ld      r1,r0
042A: 5D00 8180      ldl     %8180,rr0
042E: 6F00 C000      ld      %c000,r0
0432: 4D05 8184 FF00 ld      %8184,#%ff00
0438: 4D05 C100 FF00 ld      %c100,#%ff00
043E: 4D05 818C 0000 ld      %818c,#%0000
0444: 4D05 81A0 0000 ld      %81a0,#%0000
044A: 6100 800C      ld      r0,%800c
044E: 6F00 819C      ld      %819c,r0
0452: 4D05 8C60 0001 ld      %8c60,#%0001
0458: 4D05 8C68 0010 ld      %8c68,#%0010
045E: D126           calr    %0214
0460: D0D9           calr    %02b0
0462: D0A7           calr    %0316
0464: D140           calr    %01e6
0466: 5F00 2DA2      call    %2da2
046A: 9E08           ret     
046C: D12D           calr    %0214
046E: D0E0           calr    %02b0
0470: D0AE           calr    %0316
0472: DF40           calr    %05f4
0474: 9E08           ret     
0476: D132           calr    %0214
0478: D0E5           calr    %02b0
047A: D0B3           calr    %0316
047C: 5F00 2DA2      call    %2da2
0480: DF0C           calr    %066a
0482: 210B 8B00      ld      r11,#%8b00
0486: 210A 0007      ld      r10,#%0007
048A: 0DB5 0002      ld      @r11,#%0002
048E: 010B 0020      add     r11,#%0020
0492: FA85           djnz    r10,%048a
0494: D000           calr    %0496
0496: 210B 8B00      ld      r11,#%8b00
049A: 2101 0000      ld      r1,#%0000
049E: 6100 81FA      ld      r0,%81fa
04A2: 0700 0007      and     r0,#%0007
04A6: E608           jr      eq/z,%04b8
04A8: DFC8           calr    %051a
04AA: AB00           dec     r0,1
04AC: E63A           jr      eq/z,%0522
04AE: DFE4           calr    %04e8
04B0: 0301 0080      sub     r1,#%0080
04B4: AB00           dec     r0,1
04B6: E8F7           jr      %04a6
04B8: 4D05 8188 2600 ld      %8188,#%2600
04BE: A110           ld      r0,r1
04C0: 0300 0012      sub     r0,#%0012
04C4: 6F00 8184      ld      %8184,r0
04C8: 4D05 818C 0000 ld      %818c,#%0000
04CE: 4D05 81A0 0000 ld      %81a0,#%0000
04D4: 6100 800C      ld      r0,%800c
04D8: 6F00 819C      ld      %819c,r0
04DC: 4D05 8C60 8001 ld      %8c60,#%8001
04E2: 4D05 8C68 0010 ld      %8c68,#%0010
04E8: 4DB5 0006 0240 ld      %0006(r11),#%0240
04EE: 4DB5 000E 0000 ld      %000e(r11),#%0000
04F4: 4DB5 0010 0000 ld      %0010(r11),#%0000
04FA: 6FB1 0002      ld      %0002(r11),r1
04FE: 4DB5 0012 0000 ld      %0012(r11),#%0000
0504: 4DB5 001C 0000 ld      %001c(r11),#%0000
050A: 4DB5 001A 0000 ld      %001a(r11),#%0000
0510: 0DB5 8002      ld      @r11,#%8002
0514: 010B 0020      add     r11,#%0020
0518: 9E08           ret     
051A: 4DB5 0006 FD00 ld      %0006(r11),#%fd00
0520: E8E6           jr      %04ee
0522: 4D05 8188 E200 ld      %8188,#%e200
0528: A110           ld      r0,r1
052A: 0300 0012      sub     r0,#%0012
052E: 6F00 8184      ld      %8184,r0
0532: 4D05 818C 0000 ld      %818c,#%0000
0538: 4D05 81A0 0000 ld      %81a0,#%0000
053E: 6100 800C      ld      r0,%800c
0542: 6F00 819C      ld      %819c,r0
0546: 4D05 8C60 8001 ld      %8c60,#%8001
054C: 4D05 8C68 0010 ld      %8c68,#%0010
0552: 9E08           ret     
0554: 210B 8B00      ld      r11,#%8b00
0558: 210A 0007      ld      r10,#%0007
055C: 6101 81FA      ld      r1,%81fa
0560: 0701 0007      and     r1,#%0007
0564: 1900 0300      mult    rr0,#%0300
0568: 0101 5400      add     r1,#%5400
056C: 6102 8148      ld      r2,%8148
0570: 0702 0007      and     r2,#%0007
0574: 0B02 0006      cp      r2,#%0006
0578: E907           jr      ge,%0588
057A: 0101 0800      add     r1,#%0800
057E: 0B02 0004      cp      r2,#%0004
0582: E902           jr      ge,%0588
0584: 0101 0400      add     r1,#%0400
0588: 6FB1 0012      ld      %0012(r11),r1
058C: 0301 0800      sub     r1,#%0800
0590: 010B 0020      add     r11,#%0020
0594: FA87           djnz    r10,%0588
0596: 4D05 889C 000A ld      %889c,#%000a
059C: 9E08           ret     
059E: D1C6           calr    %0214
05A0: D179           calr    %02b0
05A2: D147           calr    %0316
05A4: DFC3           calr    %0620
05A6: 210B 8B00      ld      r11,#%8b00
05AA: 210A 0007      ld      r10,#%0007
05AE: 0DB5 0002      ld      @r11,#%0002
05B2: 010B 0020      add     r11,#%0020
05B6: FA85           djnz    r10,%05ae
05B8: 4D05 8188 FE00 ld      %8188,#%fe00
05BE: 4D05 8184 FF00 ld      %8184,#%ff00
05C4: 4D05 818C 0000 ld      %818c,#%0000
05CA: 4D05 81A0 0000 ld      %81a0,#%0000
05D0: 6100 800C      ld      r0,%800c
05D4: 6F00 819C      ld      %819c,r0
05D8: 4D05 8C60 8001 ld      %8c60,#%8001
05DE: 4D05 8C68 0010 ld      %8c68,#%0010
05E4: D200           calr    %01e6
05E6: 5F00 2DA2      call    %2da2
05EA: 9E08           ret     
05EC: E8B3           jr      %0554
05EE: 8D32           neg     r3
05F0: A5CE           set     r12,14
05F2: E032           jr      n,%0658
05F4: 210B 8BE0      ld      r11,#%8be0
05F8: 0DB5 8009      ld      @r11,#%8009
05FC: 4DB5 000C 0001 ld      %000c(r11),#%0001
0602: E807           jr      %0612
0604: 210B 8BE0      ld      r11,#%8be0
0608: 0DB5 8009      ld      @r11,#%8009
060C: 4DB5 000C 0000 ld      %000c(r11),#%0000
0612: 4DB5 0002 0020 ld      %0002(r11),#%0020
0618: 4DB5 0006 0100 ld      %0006(r11),#%0100
061E: E80D           jr      %063a
0620: 210B 8BE0      ld      r11,#%8be0
0624: 0DB5 8006      ld      @r11,#%8006
0628: 4DB5 0002 0020 ld      %0002(r11),#%0020
062E: 4DB5 0006 0000 ld      %0006(r11),#%0000
0634: 4DB5 000C 0000 ld      %000c(r11),#%0000
063A: 010B 0020      add     r11,#%0020
063E: 210A 0003      ld      r10,#%0003
0642: 2101 8800      ld      r1,#%8800
0646: 2102 0000      ld      r2,#%0000
064A: 0DB5 0007      ld      @r11,#%0007
064E: 6FB1 0002      ld      %0002(r11),r1
0652: 4DB5 0006 0000 ld      %0006(r11),#%0000
0658: 6FB2 000C      ld      %000c(r11),r2
065C: A920           inc     r2,1
065E: 0101 0E00      add     r1,#%0e00
0662: 010B 0020      add     r11,#%0020
0666: FA8F           djnz    r10,%064a
0668: E828           jr      %06ba
066A: 210B 8BE0      ld      r11,#%8be0
066E: 0DB5 8006      ld      @r11,#%8006
0672: 4DB5 0002 0020 ld      %0002(r11),#%0020
0678: 4DB5 0006 0000 ld      %0006(r11),#%0000
067E: 4DB5 000C 0000 ld      %000c(r11),#%0000
0684: 010B 0020      add     r11,#%0020
0688: 210A 0003      ld      r10,#%0003
068C: 210C 05F2      ld      r12,#%05f2
0690: 2103 0004      ld      r3,#%0004
0694: 0DB5 8007      ld      @r11,#%8007
0698: 21C1           ld      r1,@r12
069A: ABC1           dec     r12,2
069C: A092           ldb     rh2,rl1
069E: 8C98           clrb    rl1
06A0: 8CA8           clrb    rl2
06A2: B329 FFFC      sra     r2,#4
06A6: 6FB1 0002      ld      %0002(r11),r1
06AA: 6FB2 0006      ld      %0006(r11),r2
06AE: 6FB3 000C      ld      %000c(r11),r3
06B2: A930           inc     r3,1
06B4: 010B 0020      add     r11,#%0020
06B8: FA93           djnz    r10,%0694
06BA: 2104 8D00      ld      r4,#%8d00
06BE: 2105 3D92      ld      r5,#%3d92
06C2: 2106 0018      ld      r6,#%0018
06C6: 2150           ld      r0,@r5
06C8: A102           ld      r2,r0
06CA: 0700 000F      and     r0,#%000f
06CE: 2101 0B00      ld      r1,#%0b00
06D2: 0B00 0002      cp      r0,#%0002
06D6: E10C           jr      lt,%06f0
06D8: 2101 F500      ld      r1,#%f500
06DC: 0B00 0006      cp      r0,#%0006
06E0: E107           jr      lt,%06f0
06E2: 2101 0B00      ld      r1,#%0b00
06E6: 0B00 0008      cp      r0,#%0008
06EA: E102           jr      lt,%06f0
06EC: 2101 0C00      ld      r1,#%0c00
06F0: 2F42           ld      @r4,r2
06F2: 6F41 0002      ld      %0002(r4),r1
06F6: A947           inc     r4,8
06F8: AB51           dec     r5,2
06FA: F69B           djnz    r6,%06c6
06FC: 9E08           ret     
06FE: 4D05 8C80 8008 ld      %8c80,#%8008
0704: 4D05 8C9C 0500 ld      %8c9c,#%0500
070A: 4D05 8C9E 0F00 ld      %8c9e,#%0f00
0710: 9E08           ret     
0712: 4D05 8C80 0008 ld      %8c80,#%0008
0718: 9E08           ret     
071A: C030           ldb     rh0,#%30
071C: 210C 9D0E      ld      r12,#%9d0e
0720: 5F00 2ACA      call    %2aca
0724: 4741 4D45      and     r1,%4d45(r4)
0728: 204F           ldb     rl7,@r4
072A: 5645 5240      addl    rr5,%5240(r4)
072E: 9E08           ret     
0730: 6100 8820      ld      r0,%8820
0734: 0700 0007      and     r0,#%0007
0738: 9E0E           ret     ne/nz
073A: 210B 8C00      ld      r11,#%8c00
073E: 0DB1 800A      cp      @r11,#%800a
0742: 9E0E           ret     ne/nz
0744: 61B1 000C      ld      r1,%000c(r11)
0748: 8D14           test    r1
074A: 9E06           ret     eq/z
074C: 0B01 0029      cp      r1,#%0029
0750: 9E09           ret     ge
0752: 69B0 000C      inc     %000c(r11),1
0756: 9E08           ret     
0758: 210B 8BE0      ld      r11,#%8be0
075C: 0DB1 8009      cp      @r11,#%8009
0760: 9E0E           ret     ne/nz
0762: 6BB1 0006      dec     %0006(r11),2
0766: 6101 8184      ld      r1,%8184
076A: A913           inc     r1,4
076C: 6FB1 0002      ld      %0002(r11),r1
0770: 9E08           ret     
0772: 4D01 8C80 8008 cp      %8c80,#%8008
0778: 9E0E           ret     ne/nz
077A: 6101 8C9C      ld      r1,%8c9c
077E: 0301 0008      sub     r1,#%0008
0782: 0B01 0000      cp      r1,#%0000
0786: E106           jr      lt,%0794
0788: 0B01 1000      cp      r1,#%1000
078C: E205           jr      le,%0798
078E: 2101 1000      ld      r1,#%1000
0792: E802           jr      %0798
0794: 2101 0000      ld      r1,#%0000
0798: 6F01 8C9C      ld      %8c9c,r1
079C: 4101 8184      add     r1,%8184
07A0: A913           inc     r1,4
07A2: 6F01 8C82      ld      %8c82,r1
07A6: 6101 8C9E      ld      r1,%8c9e
07AA: 8D14           test    r1
07AC: E612           jr      eq/z,%07d2
07AE: A110           ld      r0,r1
07B0: B301 FFFA      srl     r0,#6
07B4: A900           inc     r0,1
07B6: 8301           sub     r1,r0
07B8: 0B01 0000      cp      r1,#%0000
07BC: E106           jr      lt,%07ca
07BE: 0B01 1000      cp      r1,#%1000
07C2: E205           jr      le,%07ce
07C4: 2101 1000      ld      r1,#%1000
07C8: E802           jr      %07ce
07CA: 2101 0000      ld      r1,#%0000
07CE: 6F01 8C9E      ld      %8c9e,r1
07D2: B311 FFFD      srl     r1,#3
07D6: 6F01 8C8C      ld      %8c8c,r1
07DA: 9E08           ret     
07DC: 760B 8900      lda     pr11,%8900
07E0: 760C 8700      lda     pr12,%8700
07E4: 760D 8F00      lda     pr13,%8f00
07E8: 210A 0020      ld      r10,#%0020
07EC: 14B0           ldl     rr0,@r11
07EE: 54B2 0004      ldl     rr2,%0004(r11)
07F2: 5D00 8880      ldl     %8880,rr0
07F6: 5D02 8884      ldl     %8884,rr2
07FA: A9B7           inc     r11,8
07FC: A101           ld      r1,r0
07FE: 0701 000F      and     r1,#%000f
0802: E606           jr      eq/z,%0810
0804: 8111           add     r1,r1
0806: 6111 0816      ld      r1,%0816(r1)
080A: 1F10           call    r1
080C: FA91           djnz    r10,%07ec
080E: 9E08           ret     
0810: DFEE           calr    %0836
0812: FA82           djnz    r10,%0810
0814: 9E08           ret     
0816: 0836           xorb    rh6,@r3
0818: 084C           xorb    rl4,@r4
081A: 0864           xorb    rh4,@r6
081C: 087C           xorb    rl4,@r7
081E: 0894           xorb    rh4,@r9
0820: 08AC           xorb    rl4,@r10
0822: 08CA           xorb    rl2,@r12
0824: 08E8           xorb    rl0,@r14
0826: 0912           xor     r2,@r1
0828: 0930           xor     r0,@r3
082A: 0952           xor     r2,@r5
082C: 0836           xorb    rh6,@r3
082E: 0836           xorb    rh6,@r3
0830: 0836           xorb    rh6,@r3
0832: 0836           xorb    rh6,@r3
0834: 0836           xorb    rh6,@r3
0836: 8D08           clr     r0
0838: 8D18           clr     r1
083A: 1DC0           ldl     @r12,rr0
083C: 1DD0           ldl     @r13,rr0
083E: 5DC0 0004      ldl     %0004(r12),rr0
0842: 5DD0 0004      ldl     %0004(r13),rr0
0846: A9C7           inc     r12,8
0848: A9D7           inc     r13,8
084A: 9E08           ret     
084C: D9DF           calr    %1490
084E: D965           calr    %1586
0850: 6101 8824      ld      r1,%8824
0854: 0B01 00A0      cp      r1,#%00a0
0858: 9E0F           ret     nc/uge
085A: DF76           calr    %0970
085C: DF28           calr    %0a0e
085E: A9C7           inc     r12,8
0860: A9D7           inc     r13,8
0862: 9E08           ret     
0864: D9EB           calr    %1490
0866: D971           calr    %1586
0868: 6101 8824      ld      r1,%8824
086C: 0B01 00A0      cp      r1,#%00a0
0870: 9E0F           ret     nc/uge
0872: DF82           calr    %0970
0874: DF4E           calr    %09da
0876: A9C7           inc     r12,8
0878: A9D7           inc     r13,8
087A: 9E08           ret     
087C: D9F7           calr    %1490
087E: D97D           calr    %1586
0880: 6101 8824      ld      r1,%8824
0884: 0B01 00A0      cp      r1,#%00a0
0888: 9E0F           ret     nc/uge
088A: DEF2           calr    %0aa8
088C: DEC4           calr    %0b06
088E: A9C7           inc     r12,8
0890: A9D7           inc     r13,8
0892: 9E08           ret     
0894: DA03           calr    %1490
0896: D989           calr    %1586
0898: 6101 8824      ld      r1,%8824
089C: 0B01 00A0      cp      r1,#%00a0
08A0: 9E0F           ret     nc/uge
08A2: DEFE           calr    %0aa8
08A4: DEAC           calr    %0b4e
08A6: A9C7           inc     r12,8
08A8: A9D7           inc     r13,8
08AA: 9E08           ret     
08AC: DA0F           calr    %1490
08AE: D995           calr    %1586
08B0: 6101 8824      ld      r1,%8824
08B4: 0B01 0070      cp      r1,#%0070
08B8: 9E0F           ret     nc/uge
08BA: DE9C           calr    %0b84
08BC: DE1B           calr    %0c88
08BE: 010C 0020      add     r12,#%0020
08C2: 010D 0020      add     r13,#%0020
08C6: ABA2           dec     r10,3
08C8: 9E08           ret     
08CA: DA1E           calr    %1490
08CC: D9A4           calr    %1586
08CE: 6101 8824      ld      r1,%8824
08D2: 0B01 0070      cp      r1,#%0070
08D6: 9E0F           ret     nc/uge
08D8: DD98           calr    %0daa
08DA: DD13           calr    %0eb6
08DC: 010C 0058      add     r12,#%0058
08E0: 010D 0058      add     r13,#%0058
08E4: ABA9           dec     r10,10
08E6: 9E08           ret     
08E8: 6100 8882      ld      r0,%8882
08EC: 0300 0064      sub     r0,#%0064
08F0: 6F00 8882      ld      %8882,r0
08F4: DA33           calr    %1490
08F6: D9B9           calr    %1586
08F8: 6101 8824      ld      r1,%8824
08FC: 0B01 00A0      cp      r1,#%00a0
0900: 9E0F           ret     nc/uge
0902: DCDF           calr    %0f46
0904: DCA4           calr    %0fbe
0906: 010C 0010      add     r12,#%0010
090A: 010D 0010      add     r13,#%0010
090E: ABA0           dec     r10,1
0910: 9E08           ret     
0912: DA42           calr    %1490
0914: D9C8           calr    %1586
0916: 6101 8824      ld      r1,%8824
091A: 0B01 0070      cp      r1,#%0070
091E: 9E0F           ret     nc/uge
0920: DC92           calr    %0ffe
0922: DC49           calr    %1092
0924: 010C 0020      add     r12,#%0020
0928: 010D 0020      add     r13,#%0020
092C: ABA2           dec     r10,3
092E: 9E08           ret     
0930: DC01           calr    %1130
0932: DB8E           calr    %1218
0934: 4D04 8886      test    %8886
0938: EE06           jr      ne/nz,%0946
093A: 010C 0048      add     r12,#%0048
093E: 010D 0048      add     r13,#%0048
0942: ABA7           dec     r10,8
0944: 9E08           ret     
0946: 010C 0040      add     r12,#%0040
094A: 010D 0040      add     r13,#%0040
094E: ABA6           dec     r10,7
0950: 9E08           ret     
0952: DA62           calr    %1490
0954: D9E8           calr    %1586
0956: 6101 8824      ld      r1,%8824
095A: 0B01 0070      cp      r1,#%0070
095E: 9E0F           ret     nc/uge
0960: DB20           calr    %1322
0962: DAE4           calr    %139c
0964: 010C 0010      add     r12,#%0010
0968: 010D 0010      add     r13,#%0010
096C: ABA0           dec     r10,1
096E: 9E08           ret     
0970: 6101 8824      ld      r1,%8824
0974: 6105 8834      ld      r5,%8834
0978: 0B05 000F      cp      r5,#%000f
097C: EA04           jr      gt,%0986
097E: 1904 0007      mult    rr4,#%0007
0982: 1B04 0005      div     rr4,#%0005
0986: 8D12           neg     r1
0988: 0101 0182      add     r1,#%0182
098C: 8151           add     r1,r5
098E: 2FC1           ld      @r12,r1
0990: 6FC1 0004      ld      %0004(r12),r1
0994: 6101 8824      ld      r1,%8824
0998: 0B01 0070      cp      r1,#%0070
099C: E709           jr      c/ult,%09b0
099E: 8111           add     r1,r1
09A0: 6102 882C      ld      r2,%882c
09A4: 4112 8300      add     r2,%8300(r1)
09A8: 4D05 8894 006F ld      %8894,#%006f
09AE: E807           jr      %09be
09B0: 6F01 8894      ld      %8894,r1
09B4: 8111           add     r1,r1
09B6: 6102 882C      ld      r2,%882c
09BA: 4112 9700      add     r2,%9700(r1)
09BE: 8152           add     r2,r5
09C0: 8D22           neg     r2
09C2: 0102 053E      add     r2,#%053e
09C6: 6FC2 0002      ld      %0002(r12),r2
09CA: 8152           add     r2,r5
09CC: 6FC2 0006      ld      %0006(r12),r2
09D0: 0302 04BE      sub     r2,#%04be
09D4: 6F02 8890      ld      %8890,r2
09D8: 9E08           ret     
09DA: 6102 8894      ld      r2,%8894
09DE: 8122           add     r2,r2
09E0: 6101 8890      ld      r1,%8890
09E4: 6120 8500      ld      r0,%8500(r2)
09E8: B309 FFFE      sra     r0,#2
09EC: 8101           add     r1,r0
09EE: 0B01 FF81      cp      r1,#%ff81
09F2: E106           jr      lt,%0a00
09F4: 0B01 007F      cp      r1,#%007f
09F8: E205           jr      le,%0a04
09FA: 2101 007F      ld      r1,#%007f
09FE: E802           jr      %0a04
0A00: 2101 FF81      ld      r1,#%ff81
0A04: 6106 8886      ld      r6,%8886
0A08: 0706 000F      and     r6,#%000f
0A0C: E806           jr      %0a1a
0A0E: 6101 8886      ld      r1,%8886
0A12: A01E           ldb     rl6,rh1
0A14: 0706 0003      and     r6,#%0003
0A18: B110           extsb   r1
0A1A: 8D14           test    r1
0A1C: E523           jr      mi,%0a64
0A1E: 0101 0004      add     r1,#%0004
0A22: 8D08           clr     r0
0A24: 1B00 000B      div     rr0,#%000b
0A28: 8111           add     r1,r1
0A2A: A910           inc     r1,1
0A2C: A517           set     r1,7
0A2E: 6100 8834      ld      r0,%8834
0A32: 0B00 000F      cp      r0,#%000f
0A36: E203           jr      le,%0a3e
0A38: A507           set     r0,7
0A3A: A081           ldb     rh1,rl0
0A3C: E808           jr      %0a4e
0A3E: A105           ld      r5,r0
0A40: 1904 0007      mult    rr4,#%0007
0A44: 1B04 0005      div     rr4,#%0005
0A48: A150           ld      r0,r5
0A4A: A081           ldb     rh1,rl0
0A4C: 8100           add     r0,r0
0A4E: A080           ldb     rh0,rl0
0A50: 2FD1           ld      @r13,r1
0A52: AB10           dec     r1,1
0A54: 6FD1 0004      ld      %0004(r13),r1
0A58: A0E8           ldb     rl0,rl6
0A5A: 6FD0 0002      ld      %0002(r13),r0
0A5E: 6FD0 0006      ld      %0006(r13),r0
0A62: 9E08           ret     
0A64: 8D12           neg     r1
0A66: 0101 0003      add     r1,#%0003
0A6A: 8D08           clr     r0
0A6C: 1B00 000B      div     rr0,#%000b
0A70: 8111           add     r1,r1
0A72: 6100 8834      ld      r0,%8834
0A76: 0B00 000F      cp      r0,#%000f
0A7A: E203           jr      le,%0a82
0A7C: A507           set     r0,7
0A7E: A081           ldb     rh1,rl0
0A80: E808           jr      %0a92
0A82: A105           ld      r5,r0
0A84: 1904 0007      mult    rr4,#%0007
0A88: 1B04 0005      div     rr4,#%0005
0A8C: A150           ld      r0,r5
0A8E: A081           ldb     rh1,rl0
0A90: 8100           add     r0,r0
0A92: A080           ldb     rh0,rl0
0A94: 2FD1           ld      @r13,r1
0A96: A910           inc     r1,1
0A98: 6FD1 0004      ld      %0004(r13),r1
0A9C: A0E8           ldb     rl0,rl6
0A9E: 6FD0 0002      ld      %0002(r13),r0
0AA2: 6FD0 0006      ld      %0006(r13),r0
0AA6: 9E08           ret     
0AA8: 6101 8824      ld      r1,%8824
0AAC: 8D12           neg     r1
0AAE: 0101 0182      add     r1,#%0182
0AB2: 4101 8834      add     r1,%8834
0AB6: 2FC1           ld      @r12,r1
0AB8: 6FC1 0004      ld      %0004(r12),r1
0ABC: 6101 8824      ld      r1,%8824
0AC0: 0B01 0070      cp      r1,#%0070
0AC4: E709           jr      c/ult,%0ad8
0AC6: 8111           add     r1,r1
0AC8: 6102 882C      ld      r2,%882c
0ACC: 4112 8300      add     r2,%8300(r1)
0AD0: 4D05 8894 006F ld      %8894,#%006f
0AD6: E807           jr      %0ae6
0AD8: 6F01 8894      ld      %8894,r1
0ADC: 8111           add     r1,r1
0ADE: 6102 882C      ld      r2,%882c
0AE2: 4112 9700      add     r2,%9700(r1)
0AE6: 4102 8834      add     r2,%8834
0AEA: 8D22           neg     r2
0AEC: 0102 053E      add     r2,#%053e
0AF0: 6FC2 0002      ld      %0002(r12),r2
0AF4: 4102 8834      add     r2,%8834
0AF8: 6FC2 0006      ld      %0006(r12),r2
0AFC: 0302 04BE      sub     r2,#%04be
0B00: 6F02 8890      ld      %8890,r2
0B04: 9E08           ret     
0B06: 6101 8886      ld      r1,%8886
0B0A: A019           ldb     rl1,rh1
0B0C: 8D10           com     r1
0B0E: 0701 0007      and     r1,#%0007
0B12: 0B01 0005      cp      r1,#%0005
0B16: EF12           jr      nc/uge,%0b3c
0B18: 8111           add     r1,r1
0B1A: 0101 001E      add     r1,#%001e
0B1E: 6100 8834      ld      r0,%8834
0B22: A507           set     r0,7
0B24: A080           ldb     rh0,rl0
0B26: A081           ldb     rh1,rl0
0B28: C828           ldb     rl0,#%28
0B2A: 2FD1           ld      @r13,r1
0B2C: A910           inc     r1,1
0B2E: 6FD1 0004      ld      %0004(r13),r1
0B32: 6FD0 0002      ld      %0002(r13),r0
0B36: 6FD0 0006      ld      %0006(r13),r0
0B3A: 9E08           ret     
0B3C: 8D08           clr     r0
0B3E: 8D18           clr     r1
0B40: 1DC0           ldl     @r12,rr0
0B42: 1DD0           ldl     @r13,rr0
0B44: 5DC0 0004      ldl     %0004(r12),rr0
0B48: 5DD0 0004      ldl     %0004(r13),rr0
0B4C: 9E08           ret     
0B4E: 6101 8886      ld      r1,%8886
0B52: 0701 0007      and     r1,#%0007
0B56: A112           ld      r2,r1
0B58: 8111           add     r1,r1
0B5A: 0101 0018      add     r1,#%0018
0B5E: 6100 8834      ld      r0,%8834
0B62: A507           set     r0,7
0B64: A080           ldb     rh0,rl0
0B66: A081           ldb     rh1,rl0
0B68: C800           ldb     rl0,#%00
0B6A: 0B02 0003      cp      r2,#%0003
0B6E: E101           jr      lt,%0b72
0B70: C828           ldb     rl0,#%28
0B72: 2FD1           ld      @r13,r1
0B74: A910           inc     r1,1
0B76: 6FD1 0004      ld      %0004(r13),r1
0B7A: 6FD0 0002      ld      %0002(r13),r0
0B7E: 6FD0 0006      ld      %0006(r13),r0
0B82: 9E08           ret     
0B84: 6101 8824      ld      r1,%8824
0B88: A110           ld      r0,r1
0B8A: 6103 8834      ld      r3,%8834
0B8E: A134           ld      r4,r3
0B90: B349 FFFF      sra     r4,#1
0B94: 6102 8886      ld      r2,%8886
0B98: 0702 000F      and     r2,#%000f
0B9C: 0B02 0008      cp      r2,#%0008
0BA0: E937           jr      ge,%0c10
0BA2: 8D02           neg     r0
0BA4: 0100 0182      add     r0,#%0182
0BA8: 8140           add     r0,r4
0BAA: 6FC0 0018      ld      %0018(r12),r0
0BAE: 6FC0 001C      ld      %001c(r12),r0
0BB2: 8130           add     r0,r3
0BB4: 6FC0 000C      ld      %000c(r12),r0
0BB8: 6FC0 0010      ld      %0010(r12),r0
0BBC: 6FC0 0014      ld      %0014(r12),r0
0BC0: 8130           add     r0,r3
0BC2: 2FC0           ld      @r12,r0
0BC4: 6FC0 0004      ld      %0004(r12),r0
0BC8: 6FC0 0008      ld      %0008(r12),r0
0BCC: 8111           add     r1,r1
0BCE: 6102 882C      ld      r2,%882c
0BD2: 4112 9700      add     r2,%9700(r1)
0BD6: 8132           add     r2,r3
0BD8: 8142           add     r2,r4
0BDA: 8D22           neg     r2
0BDC: 0102 053E      add     r2,#%053e
0BE0: 6FC2 0002      ld      %0002(r12),r2
0BE4: 6FC2 000E      ld      %000e(r12),r2
0BE8: A121           ld      r1,r2
0BEA: B349 FFFF      sra     r4,#1
0BEE: 8141           add     r1,r4
0BF0: 6FC1 001A      ld      %001a(r12),r1
0BF4: 8132           add     r2,r3
0BF6: 6FC2 0006      ld      %0006(r12),r2
0BFA: 6FC2 0012      ld      %0012(r12),r2
0BFE: 8132           add     r2,r3
0C00: 6FC2 000A      ld      %000a(r12),r2
0C04: 6FC2 0016      ld      %0016(r12),r2
0C08: 8142           add     r2,r4
0C0A: 6FC2 001E      ld      %001e(r12),r2
0C0E: 9E08           ret     
0C10: A145           ld      r5,r4
0C12: B359 FFFF      sra     r5,#1
0C16: 8D02           neg     r0
0C18: 0100 0182      add     r0,#%0182
0C1C: 8140           add     r0,r4
0C1E: 6FC0 0010      ld      %0010(r12),r0
0C22: 6FC0 0014      ld      %0014(r12),r0
0C26: 6FC0 0018      ld      %0018(r12),r0
0C2A: 6FC0 001C      ld      %001c(r12),r0
0C2E: 8130           add     r0,r3
0C30: 2FC0           ld      @r12,r0
0C32: 6FC0 0004      ld      %0004(r12),r0
0C36: 6FC0 0008      ld      %0008(r12),r0
0C3A: 6FC0 000C      ld      %000c(r12),r0
0C3E: 8111           add     r1,r1
0C40: 6102 882C      ld      r2,%882c
0C44: 4112 9700      add     r2,%9700(r1)
0C48: 8132           add     r2,r3
0C4A: 8132           add     r2,r3
0C4C: 8D22           neg     r2
0C4E: 0102 053E      add     r2,#%053e
0C52: 6FC2 0002      ld      %0002(r12),r2
0C56: A121           ld      r1,r2
0C58: 8151           add     r1,r5
0C5A: 6FC1 0012      ld      %0012(r12),r1
0C5E: 8132           add     r2,r3
0C60: 6FC2 0006      ld      %0006(r12),r2
0C64: A121           ld      r1,r2
0C66: 8151           add     r1,r5
0C68: 6FC1 0016      ld      %0016(r12),r1
0C6C: 8132           add     r2,r3
0C6E: 6FC2 000A      ld      %000a(r12),r2
0C72: A121           ld      r1,r2
0C74: 8151           add     r1,r5
0C76: 6FC1 001A      ld      %001a(r12),r1
0C7A: 8132           add     r2,r3
0C7C: 6FC2 000E      ld      %000e(r12),r2
0C80: 8152           add     r2,r5
0C82: 6FC2 001E      ld      %001e(r12),r2
0C86: 9E08           ret     
0C88: 6101 8886      ld      r1,%8886
0C8C: 0701 000F      and     r1,#%000f
0C90: 0B01 0008      cp      r1,#%0008
0C94: E950           jr      ge,%0d36
0C96: A113           ld      r3,r1
0C98: 0701 0006      and     r1,#%0006
0C9C: 0703 0007      and     r3,#%0007
0CA0: 0103 0018      add     r3,#%0018
0CA4: A112           ld      r2,r1
0CA6: 8111           add     r1,r1
0CA8: 8121           add     r1,r2
0CAA: 0101 0034      add     r1,#%0034
0CAE: 6100 8834      ld      r0,%8834
0CB2: A084           ldb     rh4,rl0
0CB4: 0B00 000F      cp      r0,#%000f
0CB8: E203           jr      le,%0cc0
0CBA: A507           set     r0,7
0CBC: A081           ldb     rh1,rl0
0CBE: E802           jr      %0cc4
0CC0: A081           ldb     rh1,rl0
0CC2: 8100           add     r0,r0
0CC4: A080           ldb     rh0,rl0
0CC6: A0B8           ldb     rl0,rl3
0CC8: A0BC           ldb     rl4,rl3
0CCA: 6FD0 0002      ld      %0002(r13),r0
0CCE: 6FD0 0006      ld      %0006(r13),r0
0CD2: 6FD0 000A      ld      %000a(r13),r0
0CD6: 6FD0 000E      ld      %000e(r13),r0
0CDA: 6FD0 0012      ld      %0012(r13),r0
0CDE: 6FD0 0016      ld      %0016(r13),r0
0CE2: 6FD4 001A      ld      %001a(r13),r4
0CE6: 6FD4 001E      ld      %001e(r13),r4
0CEA: 2FD1           ld      @r13,r1
0CEC: A910           inc     r1,1
0CEE: 6FD1 0004      ld      %0004(r13),r1
0CF2: A910           inc     r1,1
0CF4: 6FD1 0008      ld      %0008(r13),r1
0CF8: A910           inc     r1,1
0CFA: 6FD1 000C      ld      %000c(r13),r1
0CFE: A910           inc     r1,1
0D00: 6FD1 0010      ld      %0010(r13),r1
0D04: A910           inc     r1,1
0D06: 6FD1 0014      ld      %0014(r13),r1
0D0A: B211 FFFF      srlb    rh1,#1
0D0E: 0A09 3A3A      cpb     rl1,#%3a
0D12: E10A           jr      lt,%0d28
0D14: 0A09 4646      cpb     rl1,#%46
0D18: E907           jr      ge,%0d28
0D1A: C956           ldb     rl1,#%56
0D1C: 6FD1 0018      ld      %0018(r13),r1
0D20: C957           ldb     rl1,#%57
0D22: 6FD1 001C      ld      %001c(r13),r1
0D26: 9E08           ret     
0D28: C9D7           ldb     rl1,#%d7
0D2A: 6FD1 0018      ld      %0018(r13),r1
0D2E: C9D6           ldb     rl1,#%d6
0D30: 6FD1 001C      ld      %001c(r13),r1
0D34: 9E08           ret     
0D36: A113           ld      r3,r1
0D38: 0103 0018      add     r3,#%0018
0D3C: 2101 004C      ld      r1,#%004c
0D40: 6100 8834      ld      r0,%8834
0D44: A084           ldb     rh4,rl0
0D46: 0B00 000F      cp      r0,#%000f
0D4A: E203           jr      le,%0d52
0D4C: A507           set     r0,7
0D4E: A081           ldb     rh1,rl0
0D50: E802           jr      %0d56
0D52: A081           ldb     rh1,rl0
0D54: 8100           add     r0,r0
0D56: A080           ldb     rh0,rl0
0D58: A0B8           ldb     rl0,rl3
0D5A: A0BC           ldb     rl4,rl3
0D5C: 6FD0 0002      ld      %0002(r13),r0
0D60: 6FD0 0006      ld      %0006(r13),r0
0D64: 6FD0 000A      ld      %000a(r13),r0
0D68: 6FD0 000E      ld      %000e(r13),r0
0D6C: 6FD4 0012      ld      %0012(r13),r4
0D70: 6FD4 0016      ld      %0016(r13),r4
0D74: 6FD4 001A      ld      %001a(r13),r4
0D78: 6FD4 001E      ld      %001e(r13),r4
0D7C: 2FD1           ld      @r13,r1
0D7E: A910           inc     r1,1
0D80: 6FD1 0004      ld      %0004(r13),r1
0D84: A910           inc     r1,1
0D86: 6FD1 0008      ld      %0008(r13),r1
0D8A: A910           inc     r1,1
0D8C: 6FD1 000C      ld      %000c(r13),r1
0D90: B211 FFFF      srlb    rh1,#1
0D94: C9D7           ldb     rl1,#%d7
0D96: 6FD1 0010      ld      %0010(r13),r1
0D9A: 6FD1 0014      ld      %0014(r13),r1
0D9E: C9D6           ldb     rl1,#%d6
0DA0: 6FD1 0018      ld      %0018(r13),r1
0DA4: 6FD1 001C      ld      %001c(r13),r1
0DA8: 9E08           ret     
0DAA: 6101 8824      ld      r1,%8824
0DAE: A110           ld      r0,r1
0DB0: 6103 8834      ld      r3,%8834
0DB4: A134           ld      r4,r3
0DB6: B349 FFFF      sra     r4,#1
0DBA: A145           ld      r5,r4
0DBC: B359 FFFF      sra     r5,#1
0DC0: 8D02           neg     r0
0DC2: 0100 0182      add     r0,#%0182
0DC6: A102           ld      r2,r0
0DC8: 8142           add     r2,r4
0DCA: 6FC2 003C      ld      %003c(r12),r2
0DCE: 6FC2 0054      ld      %0054(r12),r2
0DD2: 8130           add     r0,r3
0DD4: 6FC0 0038      ld      %0038(r12),r0
0DD8: 6FC0 0050      ld      %0050(r12),r0
0DDC: A102           ld      r2,r0
0DDE: 8142           add     r2,r4
0DE0: 6FC2 0034      ld      %0034(r12),r2
0DE4: 6FC2 004C      ld      %004c(r12),r2
0DE8: 8130           add     r0,r3
0DEA: 6FC0 0030      ld      %0030(r12),r0
0DEE: 6FC0 0048      ld      %0048(r12),r0
0DF2: A102           ld      r2,r0
0DF4: 8142           add     r2,r4
0DF6: 6FC2 002C      ld      %002c(r12),r2
0DFA: 6FC2 0044      ld      %0044(r12),r2
0DFE: 8130           add     r0,r3
0E00: 6FC0 0028      ld      %0028(r12),r0
0E04: 6FC0 0040      ld      %0040(r12),r0
0E08: A102           ld      r2,r0
0E0A: 8140           add     r0,r4
0E0C: 2FC0           ld      @r12,r0
0E0E: 6FC0 0004      ld      %0004(r12),r0
0E12: 8132           add     r2,r3
0E14: 6FC2 0008      ld      %0008(r12),r2
0E18: 6FC2 000C      ld      %000c(r12),r2
0E1C: 6FC2 0010      ld      %0010(r12),r2
0E20: 6FC2 0014      ld      %0014(r12),r2
0E24: 6FC2 0018      ld      %0018(r12),r2
0E28: 6FC2 001C      ld      %001c(r12),r2
0E2C: 6FC2 0020      ld      %0020(r12),r2
0E30: 6FC2 0024      ld      %0024(r12),r2
0E34: 8111           add     r1,r1
0E36: 6100 882C      ld      r0,%882c
0E3A: 4110 9700      add     r0,%9700(r1)
0E3E: 8D02           neg     r0
0E40: 0100 053E      add     r0,#%053e
0E44: A101           ld      r1,r0
0E46: 6FC0 001A      ld      %001a(r12),r0
0E4A: 8130           add     r0,r3
0E4C: 6FC0 001E      ld      %001e(r12),r0
0E50: 8130           add     r0,r3
0E52: 6FC0 0022      ld      %0022(r12),r0
0E56: 8130           add     r0,r3
0E58: 6FC0 0026      ld      %0026(r12),r0
0E5C: 8140           add     r0,r4
0E5E: 6FC0 0042      ld      %0042(r12),r0
0E62: 6FC0 0046      ld      %0046(r12),r0
0E66: 6FC0 004A      ld      %004a(r12),r0
0E6A: 6FC0 004E      ld      %004e(r12),r0
0E6E: 6FC0 0052      ld      %0052(r12),r0
0E72: 6FC0 0056      ld      %0056(r12),r0
0E76: 8331           sub     r1,r3
0E78: 6FC1 0016      ld      %0016(r12),r1
0E7C: 8331           sub     r1,r3
0E7E: 6FC1 0012      ld      %0012(r12),r1
0E82: A110           ld      r0,r1
0E84: 8331           sub     r1,r3
0E86: 8350           sub     r0,r5
0E88: 6FC1 000E      ld      %000e(r12),r1
0E8C: 6FC0 0006      ld      %0006(r12),r0
0E90: 8331           sub     r1,r3
0E92: 8330           sub     r0,r3
0E94: 6FC1 000A      ld      %000a(r12),r1
0E98: 6FC0 0002      ld      %0002(r12),r0
0E9C: 6FC1 002A      ld      %002a(r12),r1
0EA0: 6FC1 002E      ld      %002e(r12),r1
0EA4: 6FC1 0032      ld      %0032(r12),r1
0EA8: 6FC1 0036      ld      %0036(r12),r1
0EAC: 6FC1 003A      ld      %003a(r12),r1
0EB0: 6FC1 003E      ld      %003e(r12),r1
0EB4: 9E08           ret     
0EB6: A1D5           ld      r5,r13
0EB8: 2106 0F20      ld      r6,#%0f20
0EBC: 2107 000A      ld      r7,#%000a
0EC0: 6100 8834      ld      r0,%8834
0EC4: A507           set     r0,7
0EC6: A080           ldb     rh0,rl0
0EC8: 2068           ldb     rl0,@r6
0ECA: 2F50           ld      @r5,r0
0ECC: A960           inc     r6,1
0ECE: A953           inc     r5,4
0ED0: F785           djnz    r7,%0ec8
0ED2: 2107 000C      ld      r7,#%000c
0ED6: B201 FFFF      srlb    rh0,#1
0EDA: 2068           ldb     rl0,@r6
0EDC: 2F50           ld      @r5,r0
0EDE: A960           inc     r6,1
0EE0: A953           inc     r5,4
0EE2: F785           djnz    r7,%0eda
0EE4: A1D5           ld      r5,r13
0EE6: A951           inc     r5,2
0EE8: 6101 8886      ld      r1,%8886
0EEC: 0701 0007      and     r1,#%0007
0EF0: 8111           add     r1,r1
0EF2: 6111 0F36      ld      r1,%0f36(r1)
0EF6: 6100 8834      ld      r0,%8834
0EFA: A507           set     r0,7
0EFC: A080           ldb     rh0,rl0
0EFE: A018           ldb     rl0,rh1
0F00: A001           ldb     rh1,rh0
0F02: 2F50           ld      @r5,r0
0F04: A953           inc     r5,4
0F06: 2F50           ld      @r5,r0
0F08: A953           inc     r5,4
0F0A: 2107 0008      ld      r7,#%0008
0F0E: 2F51           ld      @r5,r1
0F10: A953           inc     r5,4
0F12: F783           djnz    r7,%0f0e
0F14: 2107 000C      ld      r7,#%000c
0F18: 2F51           ld      @r5,r1
0F1A: A953           inc     r5,4
0F1C: F783           djnz    r7,%0f18
0F1E: 9E08           ret     
0F20: 2E2F           ldb     @r2,rl7
0F22: 2829           incb    @r2,10
0F24: 2A2B           decb    @r2,12
0F26: 2C2D           exb     rl5,@r2
0F28: A9A8           inc     r10,9
0F2A: 5051 5253      cpl     rr1,%5253(r5)
0F2E: 5455 D0D1      ldl     rr5,%d0d1(r5)
0F32: D2D3           calr    %098e
0F34: D4D5           calr    %058c
0F36: 1310           .word   #%1310
0F38: 1410           ldl     rr0,@r1
0F3A: 1510           .word   #%1510
0F3C: 1610           addl    rr0,@r1
0F3E: 1710           .word   #%1710
0F40: 1711           pop     @r1,@r1
0F42: 1712           pop     @r2,@r1
0F44: 1312           push    @r1,@r2
0F46: 6101 8824      ld      r1,%8824
0F4A: 8D12           neg     r1
0F4C: 0101 0182      add     r1,#%0182
0F50: 6100 8834      ld      r0,%8834
0F54: B301 FFFF      srl     r0,#1
0F58: 8101           add     r1,r0
0F5A: 2FC1           ld      @r12,r1
0F5C: 6FC1 0004      ld      %0004(r12),r1
0F60: 6FC1 0008      ld      %0008(r12),r1
0F64: 6FC1 000C      ld      %000c(r12),r1
0F68: 6101 8824      ld      r1,%8824
0F6C: 0B01 0070      cp      r1,#%0070
0F70: E709           jr      c/ult,%0f84
0F72: 8111           add     r1,r1
0F74: 6102 882C      ld      r2,%882c
0F78: 4112 8300      add     r2,%8300(r1)
0F7C: 4D05 8894 006F ld      %8894,#%006f
0F82: E807           jr      %0f92
0F84: 6F01 8894      ld      %8894,r1
0F88: 8111           add     r1,r1
0F8A: 6102 882C      ld      r2,%882c
0F8E: 4112 9700      add     r2,%9700(r1)
0F92: 4102 8834      add     r2,%8834
0F96: 4102 8834      add     r2,%8834
0F9A: 8D22           neg     r2
0F9C: 0102 053E      add     r2,#%053e
0FA0: 6FC2 0002      ld      %0002(r12),r2
0FA4: 4102 8834      add     r2,%8834
0FA8: 6FC2 0006      ld      %0006(r12),r2
0FAC: 4102 8834      add     r2,%8834
0FB0: 6FC2 000A      ld      %000a(r12),r2
0FB4: 4102 8834      add     r2,%8834
0FB8: 6FC2 000E      ld      %000e(r12),r2
0FBC: 9E08           ret     
0FBE: 6100 8834      ld      r0,%8834
0FC2: 0B00 000F      cp      r0,#%000f
0FC6: E203           jr      le,%0fce
0FC8: A507           set     r0,7
0FCA: A081           ldb     rh1,rl0
0FCC: E802           jr      %0fd2
0FCE: A081           ldb     rh1,rl0
0FD0: 8100           add     r0,r0
0FD2: A080           ldb     rh0,rl0
0FD4: C827           ldb     rl0,#%27
0FD6: 6FD0 0002      ld      %0002(r13),r0
0FDA: 6FD0 0006      ld      %0006(r13),r0
0FDE: 6FD0 000A      ld      %000a(r13),r0
0FE2: 6FD0 000E      ld      %000e(r13),r0
0FE6: C930           ldb     rl1,#%30
0FE8: 2FD1           ld      @r13,r1
0FEA: A890           incb    rl1,1
0FEC: 6FD1 0004      ld      %0004(r13),r1
0FF0: A890           incb    rl1,1
0FF2: 6FD1 0008      ld      %0008(r13),r1
0FF6: A890           incb    rl1,1
0FF8: 6FD1 000C      ld      %000c(r13),r1
0FFC: 9E08           ret     
0FFE: 6101 8824      ld      r1,%8824
1002: B311 FFFF      srl     r1,#1
1006: 8D12           neg     r1
1008: 0101 0184      add     r1,#%0184
100C: 4101 8834      add     r1,%8834
1010: 2FC1           ld      @r12,r1
1012: 6FC1 0004      ld      %0004(r12),r1
1016: 6FC1 0008      ld      %0008(r12),r1
101A: 6FC1 000C      ld      %000c(r12),r1
101E: 6FC1 0010      ld      %0010(r12),r1
1022: 6FC1 0014      ld      %0014(r12),r1
1026: 6FC1 0018      ld      %0018(r12),r1
102A: 6FC1 001C      ld      %001c(r12),r1
102E: 6101 8834      ld      r1,%8834
1032: A110           ld      r0,r1
1034: B311 0001      sll     r1,#1
1038: 8D12           neg     r1
103A: 0101 04C0      add     r1,#%04c0
103E: B301 FFFF      srl     r0,#1
1042: 6103 8886      ld      r3,%8886
1046: 0703 0007      and     r3,#%0007
104A: 0303 0004      sub     r3,#%0004
104E: 8D34           test    r3
1050: ED01           jr      pl,%1054
1052: 8D32           neg     r3
1054: 603B 1128      ldb     rl3,%1128(r3)
1058: 9902           mult    rr2,r0
105A: 1B02 0014      div     rr2,#%0014
105E: 8331           sub     r1,r3
1060: 6FC1 0002      ld      %0002(r12),r1
1064: 8101           add     r1,r0
1066: 6FC1 0006      ld      %0006(r12),r1
106A: 8101           add     r1,r0
106C: 6FC1 000A      ld      %000a(r12),r1
1070: 8101           add     r1,r0
1072: 6FC1 000E      ld      %000e(r12),r1
1076: 8101           add     r1,r0
1078: 8101           add     r1,r0
107A: 6FC1 0012      ld      %0012(r12),r1
107E: 8101           add     r1,r0
1080: 6FC1 0016      ld      %0016(r12),r1
1084: 8101           add     r1,r0
1086: 6FC1 001A      ld      %001a(r12),r1
108A: 8101           add     r1,r0
108C: 6FC1 001E      ld      %001e(r12),r1
1090: 9E08           ret     
1092: 6100 8834      ld      r0,%8834
1096: B301 FFFF      srl     r0,#1
109A: A081           ldb     rh1,rl0
109C: 6100 8834      ld      r0,%8834
10A0: 6103 8886      ld      r3,%8886
10A4: 0703 0007      and     r3,#%0007
10A8: 0303 0004      sub     r3,#%0004
10AC: 8D34           test    r3
10AE: ED01           jr      pl,%10b2
10B0: 8D32           neg     r3
10B2: 603B 1128      ldb     rl3,%1128(r3)
10B6: 9902           mult    rr2,r0
10B8: 1B02 000A      div     rr2,#%000a
10BC: A0B0           ldb     rh0,rl3
10BE: 6103 8886      ld      r3,%8886
10C2: 0103 0004      add     r3,#%0004
10C6: 0703 000F      and     r3,#%000f
10CA: 0B03 0008      cp      r3,#%0008
10CE: E903           jr      ge,%10d6
10D0: C822           ldb     rl0,#%22
10D2: C958           ldb     rl1,#%58
10D4: E802           jr      %10da
10D6: C823           ldb     rl0,#%23
10D8: C9D8           ldb     rl1,#%d8
10DA: 2FD1           ld      @r13,r1
10DC: A910           inc     r1,1
10DE: 6FD1 0004      ld      %0004(r13),r1
10E2: A910           inc     r1,1
10E4: 6FD1 0008      ld      %0008(r13),r1
10E8: A910           inc     r1,1
10EA: 6FD1 000C      ld      %000c(r13),r1
10EE: A910           inc     r1,1
10F0: 6FD1 0010      ld      %0010(r13),r1
10F4: A910           inc     r1,1
10F6: 6FD1 0014      ld      %0014(r13),r1
10FA: A910           inc     r1,1
10FC: 6FD1 0018      ld      %0018(r13),r1
1100: A910           inc     r1,1
1102: 6FD1 001C      ld      %001c(r13),r1
1106: 6FD0 0002      ld      %0002(r13),r0
110A: 6FD0 0006      ld      %0006(r13),r0
110E: 6FD0 000A      ld      %000a(r13),r0
1112: 6FD0 000E      ld      %000e(r13),r0
1116: 6FD0 0012      ld      %0012(r13),r0
111A: 6FD0 0016      ld      %0016(r13),r0
111E: 6FD0 001A      ld      %001a(r13),r0
1122: 6FD0 001E      ld      %001e(r13),r0
1126: 9E08           ret     
1128: 0004 0709      addb    rh4,#%09
112C: 0A00 0000      cpb     rh0,#%00
1130: 2101 01A8      ld      r1,#%01a8
1134: 2FC1           ld      @r12,r1
1136: 6FC1 0004      ld      %0004(r12),r1
113A: 6FC1 0008      ld      %0008(r12),r1
113E: 6FC1 000C      ld      %000c(r12),r1
1142: 6FC1 0010      ld      %0010(r12),r1
1146: 6FC1 0014      ld      %0014(r12),r1
114A: 6FC1 0018      ld      %0018(r12),r1
114E: 6FC1 001C      ld      %001c(r12),r1
1152: 6FC1 0020      ld      %0020(r12),r1
1156: 6FC1 0024      ld      %0024(r12),r1
115A: 6FC1 0028      ld      %0028(r12),r1
115E: 6FC1 002C      ld      %002c(r12),r1
1162: 6FC1 0030      ld      %0030(r12),r1
1166: 6FC1 0034      ld      %0034(r12),r1
116A: 6FC1 0038      ld      %0038(r12),r1
116E: 6FC1 003C      ld      %003c(r12),r1
1172: 4D04 8886      test    %8886
1176: EE04           jr      ne/nz,%1180
1178: 6FC1 0040      ld      %0040(r12),r1
117C: 6FC1 0044      ld      %0044(r12),r1
1180: 6101 8884      ld      r1,%8884
1184: 6FC1 0002      ld      %0002(r12),r1
1188: 0101 0010      add     r1,#%0010
118C: 6FC1 0006      ld      %0006(r12),r1
1190: 0101 0010      add     r1,#%0010
1194: 6FC1 000A      ld      %000a(r12),r1
1198: 0101 0010      add     r1,#%0010
119C: 6FC1 000E      ld      %000e(r12),r1
11A0: 0101 0010      add     r1,#%0010
11A4: 6FC1 0012      ld      %0012(r12),r1
11A8: 0101 0010      add     r1,#%0010
11AC: 6FC1 0016      ld      %0016(r12),r1
11B0: 0101 0010      add     r1,#%0010
11B4: 6FC1 001A      ld      %001a(r12),r1
11B8: 0101 0010      add     r1,#%0010
11BC: 6FC1 001E      ld      %001e(r12),r1
11C0: 0101 0010      add     r1,#%0010
11C4: 6FC1 0022      ld      %0022(r12),r1
11C8: 0101 0010      add     r1,#%0010
11CC: 6FC1 0026      ld      %0026(r12),r1
11D0: 0101 0010      add     r1,#%0010
11D4: 6FC1 002A      ld      %002a(r12),r1
11D8: 0101 0010      add     r1,#%0010
11DC: 6FC1 002E      ld      %002e(r12),r1
11E0: 0101 0010      add     r1,#%0010
11E4: 6FC1 0032      ld      %0032(r12),r1
11E8: 0101 0010      add     r1,#%0010
11EC: 6FC1 0036      ld      %0036(r12),r1
11F0: 0101 0010      add     r1,#%0010
11F4: 6FC1 003A      ld      %003a(r12),r1
11F8: 0101 0010      add     r1,#%0010
11FC: 6FC1 003E      ld      %003e(r12),r1
1200: 4D04 8886      test    %8886
1204: 9E0E           ret     ne/nz
1206: 0101 0010      add     r1,#%0010
120A: 6FC1 0042      ld      %0042(r12),r1
120E: 0101 0010      add     r1,#%0010
1212: 6FC1 0046      ld      %0046(r12),r1
1216: 9E08           ret     
1218: 2101 1068      ld      r1,#%1068
121C: 2102 2026      ld      r2,#%2026
1220: 2FD1           ld      @r13,r1
1222: 6FD2 0002      ld      %0002(r13),r2
1226: A910           inc     r1,1
1228: 6FD1 0004      ld      %0004(r13),r1
122C: 6FD2 0006      ld      %0006(r13),r2
1230: A910           inc     r1,1
1232: 6FD1 0008      ld      %0008(r13),r1
1236: 6FD2 000A      ld      %000a(r13),r2
123A: 2101 1060      ld      r1,#%1060
123E: 2102 2024      ld      r2,#%2024
1242: 6FD1 000C      ld      %000c(r13),r1
1246: 6FD2 000E      ld      %000e(r13),r2
124A: A910           inc     r1,1
124C: 6FD1 0010      ld      %0010(r13),r1
1250: 6FD2 0012      ld      %0012(r13),r2
1254: A910           inc     r1,1
1256: 6FD1 0014      ld      %0014(r13),r1
125A: 6FD2 0016      ld      %0016(r13),r2
125E: A910           inc     r1,1
1260: 6FD1 0018      ld      %0018(r13),r1
1264: 6FD2 001A      ld      %001a(r13),r2
1268: A910           inc     r1,1
126A: 6FD1 001C      ld      %001c(r13),r1
126E: 6FD2 001E      ld      %001e(r13),r2
1272: A910           inc     r1,1
1274: 6FD1 0020      ld      %0020(r13),r1
1278: 6FD2 0022      ld      %0022(r13),r2
127C: A910           inc     r1,1
127E: 6FD1 0024      ld      %0024(r13),r1
1282: 6FD2 0026      ld      %0026(r13),r2
1286: A910           inc     r1,1
1288: 6FD1 0028      ld      %0028(r13),r1
128C: 6FD2 002A      ld      %002a(r13),r2
1290: 4D04 8886      test    %8886
1294: E61E           jr      eq/z,%12d2
1296: 2101 106C      ld      r1,#%106c
129A: 6FD1 002C      ld      %002c(r13),r1
129E: 6FD2 002E      ld      %002e(r13),r2
12A2: A910           inc     r1,1
12A4: 6FD1 0030      ld      %0030(r13),r1
12A8: 6FD2 0032      ld      %0032(r13),r2
12AC: A910           inc     r1,1
12AE: 6FD1 0034      ld      %0034(r13),r1
12B2: 6FD2 0036      ld      %0036(r13),r2
12B6: A910           inc     r1,1
12B8: 6FD1 0038      ld      %0038(r13),r1
12BC: 6FD2 003A      ld      %003a(r13),r2
12C0: 2101 1070      ld      r1,#%1070
12C4: 2102 202C      ld      r2,#%202c
12C8: 6FD1 003C      ld      %003c(r13),r1
12CC: 6FD2 003E      ld      %003e(r13),r2
12D0: 9E08           ret     
12D2: 2101 1060      ld      r1,#%1060
12D6: 2102 2025      ld      r2,#%2025
12DA: 6FD1 002C      ld      %002c(r13),r1
12DE: 6FD2 002E      ld      %002e(r13),r2
12E2: A910           inc     r1,1
12E4: 6FD1 0030      ld      %0030(r13),r1
12E8: 6FD2 0032      ld      %0032(r13),r2
12EC: A910           inc     r1,1
12EE: 6FD1 0034      ld      %0034(r13),r1
12F2: 6FD2 0036      ld      %0036(r13),r2
12F6: A910           inc     r1,1
12F8: 6FD1 0038      ld      %0038(r13),r1
12FC: 6FD2 003A      ld      %003a(r13),r2
1300: A910           inc     r1,1
1302: 6FD1 003C      ld      %003c(r13),r1
1306: 6FD2 003E      ld      %003e(r13),r2
130A: A910           inc     r1,1
130C: 6FD1 0040      ld      %0040(r13),r1
1310: 6FD2 0042      ld      %0042(r13),r2
1314: C970           ldb     rl1,#%70
1316: CB2C           ldb     rl3,#%2c
1318: 6FD1 0044      ld      %0044(r13),r1
131C: 6FD3 0046      ld      %0046(r13),r3
1320: 9E08           ret     
1322: 6101 8824      ld      r1,%8824
1326: A110           ld      r0,r1
1328: 8D02           neg     r0
132A: 0100 0182      add     r0,#%0182
132E: 6103 8834      ld      r3,%8834
1332: A134           ld      r4,r3
1334: B349 FFFF      sra     r4,#1
1338: A145           ld      r5,r4
133A: B359 FFFF      sra     r5,#1
133E: 8130           add     r0,r3
1340: 2FC0           ld      @r12,r0
1342: 8140           add     r0,r4
1344: 6FC0 0004      ld      %0004(r12),r0
1348: 6FC0 0008      ld      %0008(r12),r0
134C: 6FC0 000C      ld      %000c(r12),r0
1350: 8111           add     r1,r1
1352: 6102 882C      ld      r2,%882c
1356: 4112 9700      add     r2,%9700(r1)
135A: 6103 8886      ld      r3,%8886
135E: B339 0002      sla     r3,#2
1362: 0703 00FC      and     r3,#%00fc
1366: 6039 13EB      ldb     rl1,%13eb(r3)
136A: 0701 0003      and     r1,#%0003
136E: E608           jr      eq/z,%1380
1370: AB10           dec     r1,1
1372: E605           jr      eq/z,%137e
1374: AB10           dec     r1,1
1376: E601           jr      eq/z,%137a
1378: 8152           add     r2,r5
137A: 8142           add     r2,r4
137C: E801           jr      %1380
137E: 8152           add     r2,r5
1380: 8D22           neg     r2
1382: 0102 053E      add     r2,#%053e
1386: 6FC2 0002      ld      %0002(r12),r2
138A: 6FC2 0006      ld      %0006(r12),r2
138E: 8142           add     r2,r4
1390: 6FC2 000A      ld      %000a(r12),r2
1394: 8142           add     r2,r4
1396: 6FC2 000E      ld      %000e(r12),r2
139A: 9E08           ret     
139C: 6101 8834      ld      r1,%8834
13A0: A091           ldb     rh1,rl1
13A2: A090           ldb     rh0,rl1
13A4: C82C           ldb     rl0,#%2c
13A6: 6102 8886      ld      r2,%8886
13AA: B329 0002      sla     r2,#2
13AE: 0702 00FC      and     r2,#%00fc
13B2: A51F           set     r1,15
13B4: 6029 13E8      ldb     rl1,%13e8(r2)
13B8: 2FD1           ld      @r13,r1
13BA: 6FD0 0002      ld      %0002(r13),r0
13BE: A31F           res     r1,15
13C0: B319 FFFF      sra     r1,#1
13C4: 6029 13E9      ldb     rl1,%13e9(r2)
13C8: 6FD1 0004      ld      %0004(r13),r1
13CC: 6FD0 0006      ld      %0006(r13),r0
13D0: 6029 13EA      ldb     rl1,%13ea(r2)
13D4: 6FD1 0008      ld      %0008(r13),r1
13D8: 6FD0 000A      ld      %000a(r13),r0
13DC: C970           ldb     rl1,#%70
13DE: 6FD1 000C      ld      %000c(r13),r1
13E2: 6FD0 000E      ld      %000e(r13),r0
13E6: 9E08           ret     
13E8: 5071 7202      cpl     rr1,%7202(r7)
13EC: 5173 7401      pushl   @r7,%7401(r3)
13F0: 5270 7001      subl    rr0,%7001(r7)
13F4: 5370 7003      push    @r7,%7003
13F8: 5475 7003      ldl     rr5,%7003(r7)
13FC: 5576 7002      popl    %7002(r6),@r7
1400: 5677 7002      addl    rr7,%7002(r7)
1404: 5770 7001      pop     %7001,@r7
1408: 5870 7001      multl   rq0,%7001(r7)
140C: 5970 7001      mult    rr0,%7001(r7)
1410: 5A78 7901      divl    rq8,%7901(r7)
1414: 5071 7202      cpl     rr1,%7202(r7)
1418: 5173 7401      pushl   @r7,%7401(r3)
141C: 5270 7001      subl    rr0,%7001(r7)
1420: 5370 7003      push    @r7,%7003
1424: 5475 7003      ldl     rr5,%7003(r7)
1428: 5576 7002      popl    %7002(r6),@r7
142C: 5677 7002      addl    rr7,%7002(r7)
1430: 5770 7001      pop     %7001,@r7
1434: 5870 7001      multl   rq0,%7001(r7)
1438: 5970 7001      mult    rr0,%7001(r7)
143C: 5A78 7901      divl    rq8,%7901(r7)
1440: 5071 7202      cpl     rr1,%7202(r7)
1444: 5173 7401      pushl   @r7,%7401(r3)
1448: 5270 7001      subl    rr0,%7001(r7)
144C: 5370 7003      push    @r7,%7003
1450: 5475 7003      ldl     rr5,%7003(r7)
1454: 5576 7002      popl    %7002(r6),@r7
1458: 5677 7002      addl    rr7,%7002(r7)
145C: 5770 7001      pop     %7001,@r7
1460: 5870 7001      multl   rq0,%7001(r7)
1464: 5970 7001      mult    rr0,%7001(r7)
1468: 5A78 7901      divl    rq8,%7901(r7)
146C: 5071 7202      cpl     rr1,%7202(r7)
1470: 5173 7401      pushl   @r7,%7401(r3)
1474: 5270 7001      subl    rr0,%7001(r7)
1478: 5370 7003      push    @r7,%7003
147C: 5475 7003      ldl     rr5,%7003(r7)
1480: 5576 7002      popl    %7002(r6),@r7
1484: 5677 7002      addl    rr7,%7002(r7)
1488: 5770 7001      pop     %7001,@r7
148C: 5B70 7001      div     rr0,%7001(r7)
1490: 6102 8882      ld      r2,%8882
1494: 0B02 FFC1      cp      r2,#%ffc1
1498: E116           jr      lt,%14c6
149A: 0B02 1000      cp      r2,#%1000
149E: E913           jr      ge,%14c6
14A0: 8D24           test    r2
14A2: E518           jr      mi,%14d4
14A4: 0B02 0100      cp      r2,#%0100
14A8: E526           jr      mi,%14f6
14AA: 0B02 0800      cp      r2,#%0800
14AE: E52F           jr      mi,%150e
14B0: 7603 3600      lda     pr3,%3600
14B4: 2101 0000      ld      r1,#%0000
14B8: 2100 0004      ld      r0,#%0004
14BC: 0B32           cp      r2,@r3
14BE: ED15           jr      pl,%14ea
14C0: A910           inc     r1,1
14C2: A931           inc     r3,2
14C4: F085           djnz    r0,%14bc
14C6: 4D05 8824 FFFF ld      %8824,#%ffff
14CC: 4D05 8838 0000 ld      %8838,#%0000
14D2: 9E08           ret     
14D4: 8D20           com     r2
14D6: 0702 0FFF      and     r2,#%0fff
14DA: 0102 0070      add     r2,#%0070
14DE: 6F02 8824      ld      %8824,r2
14E2: 4D05 8838 0000 ld      %8838,#%0000
14E8: 9E08           ret     
14EA: 6F01 8824      ld      %8824,r1
14EE: 0332           sub     r2,@r3
14F0: 6F02 8838      ld      %8838,r2
14F4: 9E08           ret     
14F6: A121           ld      r1,r2
14F8: 0701 00F0      and     r1,#%00f0
14FC: B311 FFFE      srl     r1,#2
1500: 6113 1526      ld      r3,%1526(r1)
1504: 6110 1528      ld      r0,%1528(r1)
1508: A009           ldb     rl1,rh0
150A: 8C08           clrb    rh0
150C: E8D7           jr      %14bc
150E: A121           ld      r1,r2
1510: 0701 0700      and     r1,#%0700
1514: B311 FFFA      srl     r1,#6
1518: 6113 1566      ld      r3,%1566(r1)
151C: 6110 1568      ld      r0,%1568(r1)
1520: A009           ldb     rl1,rh0
1522: 8C08           clrb    rh0
1524: E8CB           jr      %14bc
1526: 36C8           rsvd36
1528: 640C 36B6      setb    %36b6,12
152C: 5B0A 36A6      div     rr10,%36a6
1530: 5309           .word   #%5309
1532: 3698           rsvd36
1534: 4C08 368E      clrb    %368e
1538: 4706 3684      and     r6,%3684
153C: 4206 367A      subb    rh6,%367a
1540: 3D06           in      r6,@r0
1542: 3672           rsvd36
1544: 3905           .word   #%3905
1546: 366C           rsvd36
1548: 3604           rsvd36
154A: 3666           rsvd36
154C: 3304 3660      ldr     %4bb0,r4
1550: 3004 365C      ldrb    rh4,%4bb0
1554: 2E03           .word   #%2e03
1556: 3656           rsvd36
1558: 2B04           .word   #%2b04
155A: 3652           rsvd36
155C: 2903           .word   #%2903
155E: 364E           rsvd36
1560: 2703 364C      bit     r6,r3
1564: 2602 364C      bitb    rh6,r2
1568: 264A           bitb    @r4,10
156A: 362A           rsvd36
156C: 1512           popl    @r2,@r1
156E: 361C           rsvd36
1570: 0E08           ext0e   #%08
1572: 3614           rsvd36
1574: 0A05 360E      cpb     rh5,#%0e
1578: 0704 360C      and     r4,#%360c
157C: 0602 3608      andb    rh2,#%08
1580: 0403 3606      orb     rh3,#%06
1584: 0302 6101      sub     r2,#%6101
1588: 8824           xorb    rh4,rh2
158A: 6103 8884      ld      r3,%8884
158E: A110           ld      r0,r1
1590: 0100 0004      add     r0,#%0004
1594: 9902           mult    rr2,r0
1596: B325 0006      slll    rr2,#6
159A: 6F02 882C      ld      %882c,r2
159E: 6100 8880      ld      r0,%8880
15A2: 8C08           clrb    rh0
15A4: 0B00 0004      cp      r0,#%0004
15A8: E641           jr      eq/z,%162c
15AA: 0B00 0002      cp      r0,#%0002
15AE: E209           jr      le,%15c2
15B0: 0B00 0006      cp      r0,#%0006
15B4: E222           jr      le,%15fa
15B6: 0B00 0008      cp      r0,#%0008
15BA: E646           jr      eq/z,%1648
15BC: 0B00 000A      cp      r0,#%000a
15C0: E64F           jr      eq/z,%1660
15C2: 0B01 0070      cp      r1,#%0070
15C6: EF0B           jr      nc/uge,%15de
15C8: 0101 0006      add     r1,#%0006
15CC: A110           ld      r0,r1
15CE: 8101           add     r1,r0
15D0: 8101           add     r1,r0
15D2: B311 FFFD      srl     r1,#3
15D6: AB10           dec     r1,1
15D8: 6F01 8834      ld      %8834,r1
15DC: 9E08           ret     
15DE: 0101 0040      add     r1,#%0040
15E2: B311 FFFE      srl     r1,#2
15E6: AB10           dec     r1,1
15E8: 6F01 8834      ld      %8834,r1
15EC: 0B01 0040      cp      r1,#%0040
15F0: 9E07           ret     c/ult
15F2: 4D05 8834 003F ld      %8834,#%003f
15F8: 9E08           ret     
15FA: 0B01 0070      cp      r1,#%0070
15FE: EF08           jr      nc/uge,%1610
1600: 0101 0004      add     r1,#%0004
1604: B311 FFFF      srl     r1,#1
1608: AB10           dec     r1,1
160A: 6F01 8834      ld      %8834,r1
160E: 9E08           ret     
1610: 0101 0077      add     r1,#%0077
1614: B311 FFFE      srl     r1,#2
1618: AB10           dec     r1,1
161A: 6F01 8834      ld      %8834,r1
161E: 0B01 0040      cp      r1,#%0040
1622: 9E07           ret     c/ult
1624: 4D05 8834 003F ld      %8834,#%003f
162A: 9E08           ret     
162C: 6102 8886      ld      r2,%8886
1630: 0702 0007      and     r2,#%0007
1634: 0B02 0003      cp      r2,#%0003
1638: E1C4           jr      lt,%15c2
163A: 6102 8886      ld      r2,%8886
163E: A02A           ldb     rl2,rh2
1640: 8C28           clrb    rh2
1642: 6F02 8834      ld      %8834,r2
1646: 9E08           ret     
1648: 0101 0004      add     r1,#%0004
164C: A112           ld      r2,r1
164E: B311 FFFF      srl     r1,#1
1652: 8121           add     r1,r2
1654: B311 FFFE      srl     r1,#2
1658: AB10           dec     r1,1
165A: 6F01 8834      ld      %8834,r1
165E: 9E08           ret     
1660: 0B01 0070      cp      r1,#%0070
1664: E702           jr      c/ult,%166a
1666: 2101 0070      ld      r1,#%0070
166A: 0101 0004      add     r1,#%0004
166E: 8D08           clr     r0
1670: B305 0003      slll    rr0,#3
1674: 1B00 000D      div     rr0,#%000d
1678: 6F01 8834      ld      %8834,r1
167C: 9E08           ret     
167E: 610D 8888      ld      r13,%8888
1682: ABD0           dec     r13,1
1684: 9E06           ret     eq/z
1686: 9E05           ret     mi
1688: 210A 8900      ld      r10,#%8900
168C: 210B 8908      ld      r11,#%8908
1690: A1DC           ld      r12,r13
1692: 61A0 0002      ld      r0,%0002(r10)
1696: 43B0 0002      sub     r0,%0002(r11)
169A: E906           jr      ge,%16a8
169C: 1CA1 0007      ldm     r0,@r10,#8
16A0: 1CA9 0403      ldm     @r10,r4,#4
16A4: 1CB9 0003      ldm     @r11,r0,#4
16A8: A9A7           inc     r10,8
16AA: A9B7           inc     r11,8
16AC: FC8E           djnz    r12,%1692
16AE: FD94           djnz    r13,%1688
16B0: 9E08           ret     
16B2: 61B0 001E      ld      r0,%001e(r11)
16B6: E821           jr      %16fa
16B8: 210A 000D      ld      r10,#%000d
16BC: 210B 8B00      ld      r11,#%8b00
16C0: 210C 8900      ld      r12,#%8900
16C4: 8D88           clr     r8
16C6: 21B0           ld      r0,@r11
16C8: A70F           bit     r0,15
16CA: E61B           jr      eq/z,%1702
16CC: 61B1 0008      ld      r1,%0008(r11)
16D0: 0101 003C      add     r1,#%003c
16D4: 0B01 0F3C      cp      r1,#%0f3c
16D8: EF14           jr      nc/uge,%1702
16DA: 8C08           clrb    rh0
16DC: 2FC0           ld      @r12,r0
16DE: 61B1 0008      ld      r1,%0008(r11)
16E2: 6FC1 0002      ld      %0002(r12),r1
16E6: 61B1 0006      ld      r1,%0006(r11)
16EA: 6FC1 0004      ld      %0004(r12),r1
16EE: AB02           dec     r0,3
16F0: 0B00 0002      cp      r0,#%0002
16F4: E7DE           jr      c/ult,%16b2
16F6: 61B0 000C      ld      r0,%000c(r11)
16FA: 6FC0 0006      ld      %0006(r12),r0
16FE: A9C7           inc     r12,8
1700: A980           inc     r8,1
1702: 010B 0020      add     r11,#%0020
1706: FAA1           djnz    r10,%16c6
1708: 2105 8D00      ld      r5,#%8d00
170C: 2106 0018      ld      r6,#%0018
1710: 2107 0003      ld      r7,#%0003
1714: 4D51 0004 0F00 cp      %0004(r5),#%0f00
171A: EF13           jr      nc/uge,%1742
171C: 0DC5 0005      ld      @r12,#%0005
1720: 6151 0004      ld      r1,%0004(r5)
1724: 6FC1 0002      ld      %0002(r12),r1
1728: 6151 0002      ld      r1,%0002(r5)
172C: 6FC1 0004      ld      %0004(r12),r1
1730: 2151           ld      r1,@r5
1732: 0701 000F      and     r1,#%000f
1736: 6FC1 0006      ld      %0006(r12),r1
173A: A9C7           inc     r12,8
173C: A980           inc     r8,1
173E: AB70           dec     r7,1
1740: E602           jr      eq/z,%1746
1742: A957           inc     r5,8
1744: F699           djnz    r6,%1714
1746: 0DC5 0000      ld      @r12,#%0000
174A: 6F08 8888      ld      %8888,r8
174E: 9E08           ret     
1750: 6101 8188      ld      r1,%8188
1754: 8D12           neg     r1
1756: B319 FFFC      sra     r1,#4
175A: A110           ld      r0,r1
175C: B309 FFFE      sra     r0,#2
1760: 8101           add     r1,r0
1762: 6F01 8C66      ld      %8c66,r1
1766: 6100 8184      ld      r0,%8184
176A: B301 FFFD      srl     r0,#3
176E: 0700 0001      and     r0,#%0001
1772: 6101 81A0      ld      r1,%81a0
1776: C100           ldb     rh1,#%00
1778: 8481           orb     rh1,rl0
177A: 6F01 8C6C      ld      %8c6c,r1
177E: 9E08           ret     
1780: 210A 0007      ld      r10,#%0007
1784: 210B 8B00      ld      r11,#%8b00
1788: 21B7           ld      r7,@r11
178A: A77F           bit     r7,15
178C: E625           jr      eq/z,%17d8
178E: A1B0           ld      r0,r11
1790: B301 FFFC      srl     r0,#4
1794: 0700 000C      and     r0,#%000c
1798: 61B1 0002      ld      r1,%0002(r11)
179C: 0701 0001      and     r1,#%0001
17A0: 8498           orb     rl0,rl1
17A2: 6FB0 000C      ld      %000c(r11),r0
17A6: 61B0 0002      ld      r0,%0002(r11)
17AA: 61B1 0004      ld      r1,%0004(r11)
17AE: 61B2 000E      ld      r2,%000e(r11)
17B2: 61B3 0010      ld      r3,%0010(r11)
17B6: 61B5 0012      ld      r5,%0012(r11)
17BA: B14A           exts    rr4
17BC: DFEF           calr    %17e0
17BE: DFBE           calr    %1844
17C0: DF9C           calr    %188a
17C2: 6FB2 000E      ld      %000e(r11),r2
17C6: 6FB3 0010      ld      %0010(r11),r3
17CA: B325 FFFD      srll    rr2,#3
17CE: 9620           addl    rr0,rr2
17D0: 6FB0 0002      ld      %0002(r11),r0
17D4: 6FB1 0004      ld      %0004(r11),r1
17D8: 010B 0020      add     r11,#%0020
17DC: FAAB           djnz    r10,%1788
17DE: 9E08           ret     
17E0: 0B07 8003      cp      r7,#%8003
17E4: E619           jr      eq/z,%1818
17E6: 4DB4 001C      test    %001c(r11)
17EA: EE1E           jr      ne/nz,%1828
17EC: 61B6 0014      ld      r6,%0014(r11)
17F0: 8B62           cp      r2,r6
17F2: E90B           jr      ge,%180a
17F4: 0B02 006E      cp      r2,#%006e
17F8: E906           jr      ge,%1806
17FA: 4D01 81F0 000A cp      %81f0,#%000a
1800: E901           jr      ge,%1804
1802: 9642           addl    rr2,rr4
1804: 9644           addl    rr4,rr4
1806: 9642           addl    rr2,rr4
1808: 9E08           ret     
180A: 0106 000A      add     r6,#%000a
180E: 8B62           cp      r2,r6
1810: 9E02           ret     le
1812: 9644           addl    rr4,rr4
1814: 9242           subl    rr2,rr4
1816: 9E08           ret     
1818: 1602 FFFC F2C0 addl    rr2,#%fffcf2c0
181E: 9E0D           ret     pl
1820: 1402 0000 0000 ldl     rr2,#%00000000
1826: 9E08           ret     
1828: 61B5 001C      ld      r5,%001c(r11)
182C: 4DB5 001C 0000 ld      %001c(r11),#%0000
1832: B14A           exts    rr4
1834: B345 0005      slll    rr4,#5
1838: 9642           addl    rr2,rr4
183A: 9E0D           ret     pl
183C: 1402 0000 0000 ldl     rr2,#%00000000
1842: 9E08           ret     
1844: 4DB4 001A      test    %001a(r11)
1848: 9E06           ret     eq/z
184A: E510           jr      mi,%186c
184C: 61B6 001A      ld      r6,%001a(r11)
1850: B369 FFFA      sra     r6,#6
1854: A960           inc     r6,1
1856: 41B6 0006      add     r6,%0006(r11)
185A: 6FB6 0006      ld      %0006(r11),r6
185E: 0B06 0300      cp      r6,#%0300
1862: 9E01           ret     lt
1864: 4DB5 001A 0000 ld      %001a(r11),#%0000
186A: 9E08           ret     
186C: 61B6 001A      ld      r6,%001a(r11)
1870: B369 FFFA      sra     r6,#6
1874: 41B6 0006      add     r6,%0006(r11)
1878: 6FB6 0006      ld      %0006(r11),r6
187C: 0B06 FD00      cp      r6,#%fd00
1880: 9E09           ret     ge
1882: 4DB5 001A 0000 ld      %001a(r11),#%0000
1888: 9E08           ret     
188A: 91F0           pushl   @r15,rr0
188C: 91F2           pushl   @r15,rr2
188E: A009           ldb     rl1,rh0
1890: 8C18           clrb    rh1
1892: 8D08           clr     r0
1894: A894           incb    rl1,5
1896: 2103 0004      ld      r3,#%0004
189A: 601A 36E0      ldb     rl2,%36e0(r1)
189E: B120           extsb   r2
18A0: 8D24           test    r2
18A2: ED01           jr      pl,%18a6
18A4: 8D22           neg     r2
18A6: 8120           add     r0,r2
18A8: A890           incb    rl1,1
18AA: F389           djnz    r3,%189a
18AC: B301 FFFF      srl     r0,#1
18B0: 8D00           com     r0
18B2: 0700 00FF      and     r0,#%00ff
18B6: A1B2           ld      r2,r11
18B8: 8D20           com     r2
18BA: 0702 00E0      and     r2,#%00e0
18BE: B321 FFFD      srl     r2,#3
18C2: 8120           add     r0,r2
18C4: B321 FFFF      srl     r2,#1
18C8: 8120           add     r0,r2
18CA: 6102 818C      ld      r2,%818c
18CE: B321 FFFE      srl     r2,#2
18D2: 8120           add     r0,r2
18D4: B321 FFFF      srl     r2,#1
18D8: 8120           add     r0,r2
18DA: 6102 81F0      ld      r2,%81f0
18DE: B321 FFFE      srl     r2,#2
18E2: 8120           add     r0,r2
18E4: B321 FFFF      srl     r2,#1
18E8: 8120           add     r0,r2
18EA: 6102 8148      ld      r2,%8148
18EE: 0702 0007      and     r2,#%0007
18F2: 0B02 0004      cp      r2,#%0004
18F6: E111           jr      lt,%191a
18F8: 0B02 0006      cp      r2,#%0006
18FC: E11C           jr      lt,%1936
18FE: 0300 00B4      sub     r0,#%00b4
1902: 0B00 001E      cp      r0,#%001e
1906: E106           jr      lt,%1914
1908: 0B00 0096      cp      r0,#%0096
190C: E205           jr      le,%1918
190E: 2100 0096      ld      r0,#%0096
1912: E802           jr      %1918
1914: 2100 001E      ld      r0,#%001e
1918: E81B           jr      %1950
191A: 0300 008C      sub     r0,#%008c
191E: 0B00 0032      cp      r0,#%0032
1922: E106           jr      lt,%1930
1924: 0B00 00D2      cp      r0,#%00d2
1928: E205           jr      le,%1934
192A: 2100 00D2      ld      r0,#%00d2
192E: E802           jr      %1934
1930: 2100 0032      ld      r0,#%0032
1934: E80D           jr      %1950
1936: 0300 00AA      sub     r0,#%00aa
193A: 0B00 0028      cp      r0,#%0028
193E: E106           jr      lt,%194c
1940: 0B00 00A0      cp      r0,#%00a0
1944: E205           jr      le,%1950
1946: 2100 00A0      ld      r0,#%00a0
194A: E802           jr      %1950
194C: 2100 0028      ld      r0,#%0028
1950: 6FB0 0014      ld      %0014(r11),r0
1954: 95F2           popl    rr2,@r15
1956: 95F0           popl    rr0,@r15
1958: 9E08           ret     
195A: 6101 8294      ld      r1,%8294
195E: 0B01 0001      cp      r1,#%0001
1962: E623           jr      eq/z,%19aa
1964: 0B01 FFFF      cp      r1,#%ffff
1968: 9E0E           ret     ne/nz
196A: 610C 8840      ld      r12,%8840
196E: 070C 0007      and     r12,#%0007
1972: EE01           jr      ne/nz,%1976
1974: A9C0           inc     r12,1
1976: 210B 8BC0      ld      r11,#%8bc0
197A: 67BF 0000      bit     %0000(r11),15
197E: EE11           jr      ne/nz,%19a2
1980: 6101 8184      ld      r1,%8184
1984: 0301 003A      sub     r1,#%003a
1988: 6FB1 0002      ld      %0002(r11),r1
198C: 5F00 0042      call    %0042
1990: 0700 003F      and     r0,#%003f
1994: 0100 0064      add     r0,#%0064
1998: 6FB0 000E      ld      %000e(r11),r0
199C: 4DB5 0000 8002 ld      %0000(r11),#%8002
19A2: 030B 0020      sub     r11,#%0020
19A6: FC97           djnz    r12,%197a
19A8: 9E08           ret     
19AA: 6101 81F0      ld      r1,%81f0
19AE: 0B01 000F      cp      r1,#%000f
19B2: 9E02           ret     le
19B4: 610C 8840      ld      r12,%8840
19B8: 070C 0007      and     r12,#%0007
19BC: EE01           jr      ne/nz,%19c0
19BE: A9C0           inc     r12,1
19C0: 210B 8BC0      ld      r11,#%8bc0
19C4: 67BF 0000      bit     %0000(r11),15
19C8: EE38           jr      ne/nz,%1a3a
19CA: 4D04 889C      test    %889c
19CE: EE25           jr      ne/nz,%1a1a
19D0: 6101 818C      ld      r1,%818c
19D4: 0B01 008C      cp      r1,#%008c
19D8: E924           jr      ge,%1a22
19DA: 6102 8C66      ld      r2,%8c66
19DE: 8D24           test    r2
19E0: ED01           jr      pl,%19e4
19E2: 8D22           neg     r2
19E4: 0B02 0032      cp      r2,#%0032
19E8: E11C           jr      lt,%1a22
19EA: 4D04 8C66      test    %8c66
19EE: 2103 0330      ld      r3,#%0330
19F2: E501           jr      mi,%19f6
19F4: 8D32           neg     r3
19F6: 6FB3 0006      ld      %0006(r11),r3
19FA: 0101 0046      add     r1,#%0046
19FE: 6FB1 000E      ld      %000e(r11),r1
1A02: 6102 8184      ld      r2,%8184
1A06: 0302 003A      sub     r2,#%003a
1A0A: 6FB2 0002      ld      %0002(r11),r2
1A0E: 0DB5 8002      ld      @r11,#%8002
1A12: 4D05 889C 0005 ld      %889c,#%0005
1A18: E810           jr      %1a3a
1A1A: 6B00 889C      dec     %889c,1
1A1E: 6101 818C      ld      r1,%818c
1A22: 6102 8184      ld      r2,%8184
1A26: 0102 1000      add     r2,#%1000
1A2A: 6FB2 0002      ld      %0002(r11),r2
1A2E: B311 FFFF      srl     r1,#1
1A32: 6FB1 000E      ld      %000e(r11),r1
1A36: 0DB5 8002      ld      @r11,#%8002
1A3A: 030B 0020      sub     r11,#%0020
1A3E: FCBE           djnz    r12,%19c4
1A40: 9E08           ret     
1A42: 6101 81F0      ld      r1,%81f0
1A46: AB19           dec     r1,10
1A48: 9E05           ret     mi
1A4A: A910           inc     r1,1
1A4C: 0B01 0028      cp      r1,#%0028
1A50: E202           jr      le,%1a56
1A52: 2101 0028      ld      r1,#%0028
1A56: 1900 0014      mult    rr0,#%0014
1A5A: A117           ld      r7,r1
1A5C: B311 FFFF      srl     r1,#1
1A60: A118           ld      r8,r1
1A62: B311 FFFF      srl     r1,#1
1A66: A119           ld      r9,r1
1A68: B311 FFFF      srl     r1,#1
1A6C: A11A           ld      r10,r1
1A6E: B311 FFFD      srl     r1,#3
1A72: A11B           ld      r11,r1
1A74: A9B0           inc     r11,1
1A76: 210C 0006      ld      r12,#%0006
1A7A: 210D 8B00      ld      r13,#%8b00
1A7E: 93FC           push    @r15,r12
1A80: 0DD1 8002      cp      @r13,#%8002
1A84: EE44           jr      ne/nz,%1b0e
1A86: 4DD4 0012      test    %0012(r13)
1A8A: E641           jr      eq/z,%1b0e
1A8C: A1DE           ld      r14,r13
1A8E: 010E 0020      add     r14,#%0020
1A92: 61D4 0002      ld      r4,%0002(r13)
1A96: 61D5 0006      ld      r5,%0006(r13)
1A9A: 61D6 000E      ld      r6,%000e(r13)
1A9E: 0DE1 8002      cp      @r14,#%8002
1AA2: EE32           jr      ne/nz,%1b08
1AA4: A141           ld      r1,r4
1AA6: 43E1 0002      sub     r1,%0002(r14)
1AAA: 8181           add     r1,r8
1AAC: 8B71           cp      r1,r7
1AAE: EF2C           jr      nc/uge,%1b08
1AB0: A152           ld      r2,r5
1AB2: 43E2 0006      sub     r2,%0006(r14)
1AB6: 0102 0320      add     r2,#%0320
1ABA: 0B02 0640      cp      r2,#%0640
1ABE: EF24           jr      nc/uge,%1b08
1AC0: A163           ld      r3,r6
1AC2: 43E3 000E      sub     r3,%000e(r14)
1AC6: 83A1           sub     r1,r10
1AC8: E514           jr      mi,%1af2
1ACA: 8391           sub     r1,r9
1ACC: E525           jr      mi,%1b18
1ACE: 83A1           sub     r1,r10
1AD0: E52D           jr      mi,%1b2c
1AD2: 83A1           sub     r1,r10
1AD4: E53A           jr      mi,%1b4a
1AD6: 8391           sub     r1,r9
1AD8: E547           jr      mi,%1b68
1ADA: 0B03 FFF1      cp      r3,#%fff1
1ADE: EA14           jr      gt,%1b08
1AE0: 4DE4 001A      test    %001a(r14)
1AE4: EE11           jr      ne/nz,%1b08
1AE6: 61E0 0006      ld      r0,%0006(r14)
1AEA: 8D02           neg     r0
1AEC: 6FE0 001A      ld      %001a(r14),r0
1AF0: E80B           jr      %1b08
1AF2: 0B03 000F      cp      r3,#%000f
1AF6: E108           jr      lt,%1b08
1AF8: 4DD4 001A      test    %001a(r13)
1AFC: EE05           jr      ne/nz,%1b08
1AFE: 61D0 0006      ld      r0,%0006(r13)
1B02: 8D02           neg     r0
1B04: 6FD0 001A      ld      %001a(r13),r0
1B08: 010E 0020      add     r14,#%0020
1B0C: FCB8           djnz    r12,%1a9e
1B0E: 010D 0020      add     r13,#%0020
1B12: 97FC           pop     r12,@r15
1B14: FCCC           djnz    r12,%1a7e
1B16: 9E08           ret     
1B18: 0B03 FFEC      cp      r3,#%ffec
1B1C: E2F5           jr      le,%1b08
1B1E: 4DD5 001C 8AD0 ld      %001c(r13),#%8ad0
1B24: 4DE5 001C 4E20 ld      %001c(r14),#%4e20
1B2A: E8EE           jr      %1b08
1B2C: 0B03 FFF1      cp      r3,#%fff1
1B30: E2EB           jr      le,%1b08
1B32: 61E0 000E      ld      r0,%000e(r14)
1B36: 81B0           add     r0,r11
1B38: 6FE0 000E      ld      %000e(r14),r0
1B3C: 83B0           sub     r0,r11
1B3E: 83B0           sub     r0,r11
1B40: ED01           jr      pl,%1b44
1B42: 8D08           clr     r0
1B44: 6FD0 000E      ld      %000e(r13),r0
1B48: E8DF           jr      %1b08
1B4A: 0B03 000F      cp      r3,#%000f
1B4E: E9DC           jr      ge,%1b08
1B50: 61D0 000E      ld      r0,%000e(r13)
1B54: 81B0           add     r0,r11
1B56: 6FD0 000E      ld      %000e(r13),r0
1B5A: 83B0           sub     r0,r11
1B5C: 83B0           sub     r0,r11
1B5E: ED01           jr      pl,%1b62
1B60: 8D08           clr     r0
1B62: 6FE0 000E      ld      %000e(r14),r0
1B66: E8D0           jr      %1b08
1B68: 0B03 0014      cp      r3,#%0014
1B6C: E9CD           jr      ge,%1b08
1B6E: 4DD5 001C 4E20 ld      %001c(r13),#%4e20
1B74: 4DE5 001C 8AD0 ld      %001c(r14),#%8ad0
1B7A: E8C6           jr      %1b08
1B7C: 210A 000B      ld      r10,#%000b
1B80: 210B 8B00      ld      r11,#%8b00
1B84: 61B0 0002      ld      r0,%0002(r11)
1B88: 4300 8184      sub     r0,%8184
1B8C: 6FB0 0008      ld      %0008(r11),r0
1B90: 61B0 0006      ld      r0,%0006(r11)
1B94: 4300 8C66      sub     r0,%8c66
1B98: 6FB0 000A      ld      %000a(r11),r0
1B9C: 010B 0020      add     r11,#%0020
1BA0: FA8F           djnz    r10,%1b84
1BA2: 010B 0020      add     r11,#%0020
1BA6: 61B0 0002      ld      r0,%0002(r11)
1BAA: 4300 8184      sub     r0,%8184
1BAE: 6FB0 0008      ld      %0008(r11),r0
1BB2: 61B0 0006      ld      r0,%0006(r11)
1BB6: 4300 8C66      sub     r0,%8c66
1BBA: 6FB0 000A      ld      %000a(r11),r0
1BBE: 2105 8D00      ld      r5,#%8d00
1BC2: 2106 0018      ld      r6,#%0018
1BC6: 6102 8184      ld      r2,%8184
1BCA: 6103 8C66      ld      r3,%8c66
1BCE: 2151           ld      r1,@r5
1BD0: 8321           sub     r1,r2
1BD2: 6F51 0004      ld      %0004(r5),r1
1BD6: 6151 0002      ld      r1,%0002(r5)
1BDA: 8331           sub     r1,r3
1BDC: 6F51 0006      ld      %0006(r5),r1
1BE0: A957           inc     r5,8
1BE2: F68B           djnz    r6,%1bce
1BE4: 210A 0007      ld      r10,#%0007
1BE8: 210B 8B00      ld      r11,#%8b00
1BEC: 27BF           bit     @r11,15
1BEE: E619           jr      eq/z,%1c22
1BF0: 61B1 0008      ld      r1,%0008(r11)
1BF4: 0B01 FED4      cp      r1,#%fed4
1BF8: E11F           jr      lt,%1c38
1BFA: 0B01 FFC4      cp      r1,#%ffc4
1BFE: E115           jr      lt,%1c2a
1C00: 0B01 1200      cp      r1,#%1200
1C04: E10E           jr      lt,%1c22
1C06: 5F00 0042      call    %0042
1C0A: 0700 0001      and     r0,#%0001
1C0E: E61B           jr      eq/z,%1c46
1C10: 4DB5 001C 8AD0 ld      %001c(r11),#%8ad0
1C16: 2101 FF00      ld      r1,#%ff00
1C1A: 41B1 0002      add     r1,%0002(r11)
1C1E: 6FB1 0002      ld      %0002(r11),r1
1C22: 010B 0020      add     r11,#%0020
1C26: FA9E           djnz    r10,%1bec
1C28: 9E08           ret     
1C2A: 61B0 000A      ld      r0,%000a(r11)
1C2E: 0100 0BB8      add     r0,#%0bb8
1C32: 0B00 1770      cp      r0,#%1770
1C36: EFF5           jr      nc/uge,%1c22
1C38: 23BF           res     @r11,15
1C3A: 4D04 8296      test    %8296
1C3E: E6F1           jr      eq/z,%1c22
1C40: 6900 828A      inc     %828a,1
1C44: E8EE           jr      %1c22
1C46: 23BF           res     @r11,15
1C48: E8EC           jr      %1c22
1C4A: 4DB1 0000 8002 cp      %0000(r11),#%8002
1C50: 9E0E           ret     ne/nz
1C52: 61B0 0008      ld      r0,%0008(r11)
1C56: 0300 001A      sub     r0,#%001a
1C5A: 0B00 FFDA      cp      r0,#%ffda
1C5E: E131           jr      lt,%1cc2
1C60: 0B00 0038      cp      r0,#%0038
1C64: 9E0A           ret     gt
1C66: 61B1 000A      ld      r1,%000a(r11)
1C6A: 8D14           test    r1
1C6C: ED01           jr      pl,%1c70
1C6E: 8D12           neg     r1
1C70: 0B01 02BC      cp      r1,#%02bc
1C74: 9E0A           ret     gt
1C76: 0B00 0026      cp      r0,#%0026
1C7A: EA2A           jr      gt,%1cd0
1C7C: 4D05 81A6 0001 ld      %81a6,#%0001
1C82: 4DB4 000A      test    %000a(r11)
1C86: E503           jr      mi,%1c8e
1C88: 4D05 81A6 FFFF ld      %81a6,#%ffff
1C8E: 0B01 01F4      cp      r1,#%01f4
1C92: EA25           jr      gt,%1cde
1C94: 4DB5 0000 8003 ld      %0000(r11),#%8003
1C9A: 4DB5 001E 07FF ld      %001e(r11),#%07ff
1CA0: 4D01 8C60 8004 cp      %8c60,#%8004
1CA6: 9E06           ret     eq/z
1CA8: 4D05 8C60 8004 ld      %8c60,#%8004
1CAE: 4D05 8C7C 0000 ld      %8c7c,#%0000
1CB4: 4D04 8104      test    %8104
1CB8: 9E0E           ret     ne/nz
1CBA: 4D05 80E2 0005 ld      %80e2,#%0005
1CC0: 9E08           ret     
1CC2: 0B01 0384      cp      r1,#%0384
1CC6: 9E0A           ret     gt
1CC8: 4DB5 001C E4A8 ld      %001c(r11),#%e4a8
1CCE: 9E08           ret     
1CD0: 4D01 81F0 000F cp      %81f0,#%000f
1CD6: E103           jr      lt,%1cde
1CD8: 4DB5 001C 1B58 ld      %001c(r11),#%1b58
1CDE: 4D04 81BC      test    %81bc
1CE2: 9E0E           ret     ne/nz
1CE4: 4D05 81BC 0037 ld      %81bc,#%0037
1CEA: 9E08           ret     
1CEC: 4D04 8296      test    %8296
1CF0: 9E06           ret     eq/z
1CF2: 210A 0007      ld      r10,#%0007
1CF6: 210B 8B00      ld      r11,#%8b00
1CFA: D059           calr    %1c4a
1CFC: 010B 0020      add     r11,#%0020
1D00: FA84           djnz    r10,%1cfa
1D02: 6101 8C60      ld      r1,%8c60
1D06: 0B01 8001      cp      r1,#%8001
1D0A: 9E0E           ret     ne/nz
1D0C: 4D04 889E      test    %889e
1D10: EE15           jr      ne/nz,%1d3c
1D12: 61B0 0000      ld      r0,%0000(r11)
1D16: 0B00 8006      cp      r0,#%8006
1D1A: 9E0E           ret     ne/nz
1D1C: 61B1 0008      ld      r1,%0008(r11)
1D20: 0101 0014      add     r1,#%0014
1D24: 0301 0028      sub     r1,#%0028
1D28: 9E0F           ret     nc/uge
1D2A: 61B1 000A      ld      r1,%000a(r11)
1D2E: 8D14           test    r1
1D30: ED01           jr      pl,%1d34
1D32: 8D12           neg     r1
1D34: 0B01 0600      cp      r1,#%0600
1D38: E921           jr      ge,%1d7c
1D3A: 9E08           ret     
1D3C: 6B00 889E      dec     %889e,1
1D40: 9E08           ret     
1D42: 4D04 8296      test    %8296
1D46: 9E06           ret     eq/z
1D48: 6101 8C60      ld      r1,%8c60
1D4C: 0B01 8001      cp      r1,#%8001
1D50: 9E0E           ret     ne/nz
1D52: 4D04 889E      test    %889e
1D56: 9E0E           ret     ne/nz
1D58: 2105 8D00      ld      r5,#%8d00
1D5C: 2106 0018      ld      r6,#%0018
1D60: 6151 0004      ld      r1,%0004(r5)
1D64: 0101 0014      add     r1,#%0014
1D68: 0301 0028      sub     r1,#%0028
1D6C: EF17           jr      nc/uge,%1d9c
1D6E: 6151 0006      ld      r1,%0006(r5)
1D72: 0101 0384      add     r1,#%0384
1D76: 0301 0708      sub     r1,#%0708
1D7A: EF10           jr      nc/uge,%1d9c
1D7C: 4D05 8C60 8004 ld      %8c60,#%8004
1D82: 4D05 8C7C 0000 ld      %8c7c,#%0000
1D88: 4D05 889E 0096 ld      %889e,#%0096
1D8E: 4D04 8104      test    %8104
1D92: 9E0E           ret     ne/nz
1D94: 4D05 80E2 0005 ld      %80e2,#%0005
1D9A: 9E08           ret     
1D9C: A957           inc     r5,8
1D9E: F6A0           djnz    r6,%1d60
1DA0: 9E08           ret     
1DA2: 210B 8C00      ld      r11,#%8c00
1DA6: 210A 0003      ld      r10,#%0003
1DAA: 61B0 0000      ld      r0,%0000(r11)
1DAE: 0B00 8007      cp      r0,#%8007
1DB2: EE34           jr      ne/nz,%1e1c
1DB4: 61B1 0008      ld      r1,%0008(r11)
1DB8: 0301 0064      sub     r1,#%0064
1DBC: 0101 0050      add     r1,#%0050
1DC0: 0301 00A0      sub     r1,#%00a0
1DC4: EF2F           jr      nc/uge,%1e24
1DC6: 61B1 000A      ld      r1,%000a(r11)
1DCA: 0101 03E8      add     r1,#%03e8
1DCE: 0301 07D0      sub     r1,#%07d0
1DD2: EF28           jr      nc/uge,%1e24
1DD4: 4D04 81BC      test    %81bc
1DD8: E510           jr      mi,%1dfa
1DDA: 6102 818C      ld      r2,%818c
1DDE: 0302 001E      sub     r2,#%001e
1DE2: 6103 8190      ld      r3,%8190
1DE6: B331 0003      sll     r3,#3
1DEA: 8332           sub     r2,r3
1DEC: ED02           jr      pl,%1df2
1DEE: 2102 0000      ld      r2,#%0000
1DF2: 4102 81BC      add     r2,%81bc
1DF6: 6F02 81BC      ld      %81bc,r2
1DFA: 6702 80EE      bit     %80ee,2
1DFE: EE0E           jr      ne/nz,%1e1c
1E00: 4DB4 001E      test    %001e(r11)
1E04: EE0B           jr      ne/nz,%1e1c
1E06: 6502 80EE      set     %80ee,2
1E0A: 4DB5 001E 0001 ld      %001e(r11),#%0001
1E10: 61B1 000A      ld      r1,%000a(r11)
1E14: B319 FFFA      sra     r1,#6
1E18: 6F01 80FA      ld      %80fa,r1
1E1C: 010B 0020      add     r11,#%0020
1E20: FABC           djnz    r10,%1daa
1E22: 9E08           ret     
1E24: 4DB5 001E 0000 ld      %001e(r11),#%0000
1E2A: E8F8           jr      %1e1c
1E2C: 210A 0007      ld      r10,#%0007
1E30: 210B 8B00      ld      r11,#%8b00
1E34: 61B0 0000      ld      r0,%0000(r11)
1E38: 8C08           clrb    rh0
1E3A: 0B00 0003      cp      r0,#%0003
1E3E: EE07           jr      ne/nz,%1e4e
1E40: 61B0 001E      ld      r0,%001e(r11)
1E44: 0300 0014      sub     r0,#%0014
1E48: E537           jr      mi,%1eb8
1E4A: 6FB0 001E      ld      %001e(r11),r0
1E4E: 010B 0020      add     r11,#%0020
1E52: FA90           djnz    r10,%1e34
1E54: 6100 8C60      ld      r0,%8c60
1E58: 0A08 0404      cpb     rl0,#%04
1E5C: 9E0E           ret     ne/nz
1E5E: 6101 8C7C      ld      r1,%8c7c
1E62: 0101 0010      add     r1,#%0010
1E66: 6F01 8C7C      ld      %8c7c,r1
1E6A: 0B01 0820      cp      r1,#%0820
1E6E: EA16           jr      gt,%1e9c
1E70: B311 FFFC      srl     r1,#4
1E74: 0B01 0064      cp      r1,#%0064
1E78: E91B           jr      ge,%1eb0
1E7A: 6018 3ECC      ldb     rl0,%3ecc(r1)
1E7E: 8C84           testb   rl0
1E80: E617           jr      eq/z,%1eb0
1E82: A080           ldb     rh0,rl0
1E84: 0608 0707      andb    rl0,#%07
1E88: B201 FFFE      srlb    rh0,#2
1E8C: 0400 0101      orb     rh0,#%01
1E90: 6F00 8C7E      ld      %8c7e,r0
1E94: 4D05 8C60 8004 ld      %8c60,#%8004
1E9A: 9E08           ret     
1E9C: 4D05 8C60 8001 ld      %8c60,#%8001
1EA2: 4D05 825C 0000 ld      %825c,#%0000
1EA8: 4D05 8218 0000 ld      %8218,#%0000
1EAE: 9E08           ret     
1EB0: 4D05 8C60 0004 ld      %8c60,#%0004
1EB6: 9E08           ret     
1EB8: 4DB5 0000 0002 ld      %0000(r11),#%0002
1EBE: E8C7           jr      %1e4e
1EC0: 6700 80F0      bit     %80f0,0
1EC4: E65D           jr      eq/z,%1f80
1EC6: 210A 0007      ld      r10,#%0007
1ECA: 8D88           clr     r8
1ECC: 210B 8B00      ld      r11,#%8b00
1ED0: 1404 0000 FDE8 ldl     rr4,#%0000fde8
1ED6: 61B0 0000      ld      r0,%0000(r11)
1EDA: 0B00 8002      cp      r0,#%8002
1EDE: EE14           jr      ne/nz,%1f08
1EE0: 61B1 0008      ld      r1,%0008(r11)
1EE4: 9910           mult    rr0,r1
1EE6: 61B3 000A      ld      r3,%000a(r11)
1EEA: B339 FFFD      sra     r3,#3
1EEE: 9932           mult    rr2,r3
1EF0: 9620           addl    rr0,rr2
1EF2: 9040           cpl     rr0,rr4
1EF4: E909           jr      ge,%1f08
1EF6: 9404           ldl     rr4,rr0
1EF8: 61B6 0008      ld      r6,%0008(r11)
1EFC: 61B7 000A      ld      r7,%000a(r11)
1F00: 61B9 000E      ld      r9,%000e(r11)
1F04: 2108 0001      ld      r8,#%0001
1F08: 010B 0020      add     r11,#%0020
1F0C: FA9C           djnz    r10,%1ed6
1F0E: 8D84           test    r8
1F10: E637           jr      eq/z,%1f80
1F12: B369 FFFC      sra     r6,#4
1F16: B379 FFF9      sra     r7,#7
1F1A: 0B06 FFF0      cp      r6,#%fff0
1F1E: E106           jr      lt,%1f2c
1F20: 0B06 000F      cp      r6,#%000f
1F24: E205           jr      le,%1f30
1F26: 2106 000F      ld      r6,#%000f
1F2A: E802           jr      %1f30
1F2C: 2106 FFF0      ld      r6,#%fff0
1F30: 0B07 FFF0      cp      r7,#%fff0
1F34: E106           jr      lt,%1f42
1F36: 0B07 000F      cp      r7,#%000f
1F3A: E205           jr      le,%1f46
1F3C: 2107 000F      ld      r7,#%000f
1F40: E802           jr      %1f46
1F42: 2107 FFF0      ld      r7,#%fff0
1F46: 8D62           neg     r6
1F48: 8D72           neg     r7
1F4A: 6F06 80F8      ld      %80f8,r6
1F4E: 6F07 80F6      ld      %80f6,r7
1F52: A191           ld      r1,r9
1F54: 0B01 006E      cp      r1,#%006e
1F58: E202           jr      le,%1f5e
1F5A: B319 FFFF      sra     r1,#1
1F5E: 4309 818C      sub     r9,%818c
1F62: B399 FFFC      sra     r9,#4
1F66: 8D64           test    r6
1F68: ED01           jr      pl,%1f6c
1F6A: 8D92           neg     r9
1F6C: 0109 0190      add     r9,#%0190
1F70: 9990           mult    rr0,r9
1F72: 1B00 00C8      div     rr0,#%00c8
1F76: 6F01 80FC      ld      %80fc,r1
1F7A: 6501 80F0      set     %80f0,1
1F7E: 9E08           ret     
1F80: 6301 80F0      res     %80f0,1
1F84: 9E08           ret     
1F86: FFFF           djnz    r15,%1e8a
1F88: FFFF           djnz    r15,%1e8c
1F8A: FFFF           djnz    r15,%1e8e
1F8C: FFFF           djnz    r15,%1e90
1F8E: FFFF           djnz    r15,%1e92
1F90: FFFF           djnz    r15,%1e94
1F92: FFFF           djnz    r15,%1e96
1F94: FFFF           djnz    r15,%1e98
1F96: FFFF           djnz    r15,%1e9a
1F98: FFFF           djnz    r15,%1e9c
1F9A: FFFF           djnz    r15,%1e9e
1F9C: FFFF           djnz    r15,%1ea0
1F9E: FFFF           djnz    r15,%1ea2
1FA0: FFFF           djnz    r15,%1ea4
1FA2: FFFF           djnz    r15,%1ea6
1FA4: FFFF           djnz    r15,%1ea8
1FA6: FFFF           djnz    r15,%1eaa
1FA8: FFFF           djnz    r15,%1eac
1FAA: FFFF           djnz    r15,%1eae
1FAC: FFFF           djnz    r15,%1eb0
1FAE: FFFF           djnz    r15,%1eb2
1FB0: FFFF           djnz    r15,%1eb4
1FB2: FFFF           djnz    r15,%1eb6
1FB4: FFFF           djnz    r15,%1eb8
1FB6: FFFF           djnz    r15,%1eba
1FB8: FFFF           djnz    r15,%1ebc
1FBA: FFFF           djnz    r15,%1ebe
1FBC: FFFF           djnz    r15,%1ec0
1FBE: FFFF           djnz    r15,%1ec2
1FC0: FFFF           djnz    r15,%1ec4
1FC2: FFFF           djnz    r15,%1ec6
1FC4: FFFF           djnz    r15,%1ec8
1FC6: FFFF           djnz    r15,%1eca
1FC8: FFFF           djnz    r15,%1ecc
1FCA: FFFF           djnz    r15,%1ece
1FCC: FFFF           djnz    r15,%1ed0
1FCE: FFFF           djnz    r15,%1ed2
1FD0: FFFF           djnz    r15,%1ed4
1FD2: FFFF           djnz    r15,%1ed6
1FD4: FFFF           djnz    r15,%1ed8
1FD6: FFFF           djnz    r15,%1eda
1FD8: FFFF           djnz    r15,%1edc
1FDA: FFFF           djnz    r15,%1ede
1FDC: FFFF           djnz    r15,%1ee0
1FDE: FFFF           djnz    r15,%1ee2
1FE0: FFFF           djnz    r15,%1ee4
1FE2: FFFF           djnz    r15,%1ee6
1FE4: FFFF           djnz    r15,%1ee8
1FE6: FFFF           djnz    r15,%1eea
1FE8: FFFF           djnz    r15,%1eec
1FEA: FFFF           djnz    r15,%1eee
1FEC: FFFF           djnz    r15,%1ef0
1FEE: FFFF           djnz    r15,%1ef2
1FF0: FFFF           djnz    r15,%1ef4
1FF2: FFFF           djnz    r15,%1ef6
1FF4: FFFF           djnz    r15,%1ef8
1FF6: FFFF           djnz    r15,%1efa
1FF8: FFFF           djnz    r15,%1efc
1FFA: FFFF           djnz    r15,%1efe
1FFC: FFFF           djnz    r15,%1f00
1FFE: FFFF           djnz    r15,%1f02
2000: FFFF           djnz    r15,%1f04
2002: FFFF           djnz    r15,%1f06
2004: FFFF           djnz    r15,%1f08
2006: FFFF           djnz    r15,%1f0a
2008: FFFF           djnz    r15,%1f0c
200A: FFFF           djnz    r15,%1f0e
200C: FFFF           djnz    r15,%1f10
200E: FFFF           djnz    r15,%1f12
2010: FFFF           djnz    r15,%1f14
2012: FFFF           djnz    r15,%1f16
2014: FFFF           djnz    r15,%1f18
2016: FFFF           djnz    r15,%1f1a
2018: FFFF           djnz    r15,%1f1c
201A: FFFF           djnz    r15,%1f1e
201C: FFFF           djnz    r15,%1f20
201E: FFFF           djnz    r15,%1f22
2020: FFFF           djnz    r15,%1f24
2022: FFFF           djnz    r15,%1f26
2024: FFFF           djnz    r15,%1f28
2026: FFFF           djnz    r15,%1f2a
2028: FFFF           djnz    r15,%1f2c
202A: FFFF           djnz    r15,%1f2e
202C: FFFF           djnz    r15,%1f30
202E: FFFF           djnz    r15,%1f32
2030: FFFF           djnz    r15,%1f34
2032: FFFF           djnz    r15,%1f36
2034: FFFF           djnz    r15,%1f38
2036: FFFF           djnz    r15,%1f3a
2038: FFFF           djnz    r15,%1f3c
203A: FFFF           djnz    r15,%1f3e
203C: FFFF           djnz    r15,%1f40
203E: FFFF           djnz    r15,%1f42
2040: FFFF           djnz    r15,%1f44
2042: FFFF           djnz    r15,%1f46
2044: FFFF           djnz    r15,%1f48
2046: FFFF           djnz    r15,%1f4a
2048: FFFF           djnz    r15,%1f4c
204A: FFFF           djnz    r15,%1f4e
204C: FFFF           djnz    r15,%1f50
204E: FFFF           djnz    r15,%1f52
2050: FFFF           djnz    r15,%1f54
2052: FFFF           djnz    r15,%1f56
2054: FFFF           djnz    r15,%1f58
2056: FFFF           djnz    r15,%1f5a
2058: FFFF           djnz    r15,%1f5c
205A: FFFF           djnz    r15,%1f5e
205C: FFFF           djnz    r15,%1f60
205E: FFFF           djnz    r15,%1f62
2060: FFFF           djnz    r15,%1f64
2062: FFFF           djnz    r15,%1f66
2064: FFFF           djnz    r15,%1f68
2066: FFFF           djnz    r15,%1f6a
2068: FFFF           djnz    r15,%1f6c
206A: FFFF           djnz    r15,%1f6e
206C: FFFF           djnz    r15,%1f70
206E: FFFF           djnz    r15,%1f72
2070: FFFF           djnz    r15,%1f74
2072: FFFF           djnz    r15,%1f76
2074: FFFF           djnz    r15,%1f78
2076: FFFF           djnz    r15,%1f7a
2078: FFFF           djnz    r15,%1f7c
207A: FFFF           djnz    r15,%1f7e
207C: FFFF           djnz    r15,%1f80
207E: FFFF           djnz    r15,%1f82
2080: FFFF           djnz    r15,%1f84
2082: FFFF           djnz    r15,%1f86
2084: FFFF           djnz    r15,%1f88
2086: FFFF           djnz    r15,%1f8a
2088: FFFF           djnz    r15,%1f8c
208A: FFFF           djnz    r15,%1f8e
208C: FFFF           djnz    r15,%1f90
208E: FFFF           djnz    r15,%1f92
2090: FFFF           djnz    r15,%1f94
2092: FFFF           djnz    r15,%1f96
2094: FFFF           djnz    r15,%1f98
2096: FFFF           djnz    r15,%1f9a
2098: FFFF           djnz    r15,%1f9c
209A: FFFF           djnz    r15,%1f9e
209C: FFFF           djnz    r15,%1fa0
209E: FFFF           djnz    r15,%1fa2
20A0: FFFF           djnz    r15,%1fa4
20A2: FFFF           djnz    r15,%1fa6
20A4: FFFF           djnz    r15,%1fa8
20A6: FFFF           djnz    r15,%1faa
20A8: FFFF           djnz    r15,%1fac
20AA: FFFF           djnz    r15,%1fae
20AC: FFFF           djnz    r15,%1fb0
20AE: FFFF           djnz    r15,%1fb2
20B0: FFFF           djnz    r15,%1fb4
20B2: FFFF           djnz    r15,%1fb6
20B4: FFFF           djnz    r15,%1fb8
20B6: FFFF           djnz    r15,%1fba
20B8: FFFF           djnz    r15,%1fbc
20BA: FFFF           djnz    r15,%1fbe
20BC: FFFF           djnz    r15,%1fc0
20BE: FFFF           djnz    r15,%1fc2
20C0: FFFF           djnz    r15,%1fc4
20C2: FFFF           djnz    r15,%1fc6
20C4: FFFF           djnz    r15,%1fc8
20C6: FFFF           djnz    r15,%1fca
20C8: FFFF           djnz    r15,%1fcc
20CA: FFFF           djnz    r15,%1fce
20CC: FFFF           djnz    r15,%1fd0
20CE: FFFF           djnz    r15,%1fd2
20D0: FFFF           djnz    r15,%1fd4
20D2: FFFF           djnz    r15,%1fd6
20D4: FFFF           djnz    r15,%1fd8
20D6: FFFF           djnz    r15,%1fda
20D8: FFFF           djnz    r15,%1fdc
20DA: FFFF           djnz    r15,%1fde
20DC: FFFF           djnz    r15,%1fe0
20DE: FFFF           djnz    r15,%1fe2
20E0: FFFF           djnz    r15,%1fe4
20E2: FFFF           djnz    r15,%1fe6
20E4: FFFF           djnz    r15,%1fe8
20E6: FFFF           djnz    r15,%1fea
20E8: FFFF           djnz    r15,%1fec
20EA: FFFF           djnz    r15,%1fee
20EC: FFFF           djnz    r15,%1ff0
20EE: FFFF           djnz    r15,%1ff2
20F0: FFFF           djnz    r15,%1ff4
20F2: FFFF           djnz    r15,%1ff6
20F4: FFFF           djnz    r15,%1ff8
20F6: FFFF           djnz    r15,%1ffa
20F8: FFFF           djnz    r15,%1ffc
20FA: FFFF           djnz    r15,%1ffe
20FC: FFFF           djnz    r15,%2000
20FE: FFFF           djnz    r15,%2002
2100: FFFF           djnz    r15,%2004
2102: FFFF           djnz    r15,%2006
2104: FFFF           djnz    r15,%2008
2106: FFFF           djnz    r15,%200a
2108: FFFF           djnz    r15,%200c
210A: FFFF           djnz    r15,%200e
210C: FFFF           djnz    r15,%2010
210E: FFFF           djnz    r15,%2012
2110: FFFF           djnz    r15,%2014
2112: FFFF           djnz    r15,%2016
2114: FFFF           djnz    r15,%2018
2116: FFFF           djnz    r15,%201a
2118: FFFF           djnz    r15,%201c
211A: FFFF           djnz    r15,%201e
211C: FFFF           djnz    r15,%2020
211E: FFFF           djnz    r15,%2022
2120: FFFF           djnz    r15,%2024
2122: FFFF           djnz    r15,%2026
2124: FFFF           djnz    r15,%2028
2126: FFFF           djnz    r15,%202a
2128: FFFF           djnz    r15,%202c
212A: FFFF           djnz    r15,%202e
212C: FFFF           djnz    r15,%2030
212E: FFFF           djnz    r15,%2032
2130: FFFF           djnz    r15,%2034
2132: FFFF           djnz    r15,%2036
2134: FFFF           djnz    r15,%2038
2136: FFFF           djnz    r15,%203a
2138: FFFF           djnz    r15,%203c
213A: FFFF           djnz    r15,%203e
213C: FFFF           djnz    r15,%2040
213E: FFFF           djnz    r15,%2042
2140: FFFF           djnz    r15,%2044
2142: FFFF           djnz    r15,%2046
2144: FFFF           djnz    r15,%2048
2146: FFFF           djnz    r15,%204a
2148: FFFF           djnz    r15,%204c
214A: FFFF           djnz    r15,%204e
214C: FFFF           djnz    r15,%2050
214E: FFFF           djnz    r15,%2052
2150: FFFF           djnz    r15,%2054
2152: FFFF           djnz    r15,%2056
2154: FFFF           djnz    r15,%2058
2156: FFFF           djnz    r15,%205a
2158: FFFF           djnz    r15,%205c
215A: FFFF           djnz    r15,%205e
215C: FFFF           djnz    r15,%2060
215E: FFFF           djnz    r15,%2062
2160: FFFF           djnz    r15,%2064
2162: FFFF           djnz    r15,%2066
2164: FFFF           djnz    r15,%2068
2166: FFFF           djnz    r15,%206a
2168: FFFF           djnz    r15,%206c
216A: FFFF           djnz    r15,%206e
216C: FFFF           djnz    r15,%2070
216E: FFFF           djnz    r15,%2072
2170: FFFF           djnz    r15,%2074
2172: FFFF           djnz    r15,%2076
2174: FFFF           djnz    r15,%2078
2176: FFFF           djnz    r15,%207a
2178: FFFF           djnz    r15,%207c
217A: FFFF           djnz    r15,%207e
217C: FFFF           djnz    r15,%2080
217E: FFFF           djnz    r15,%2082
2180: FFFF           djnz    r15,%2084
2182: FFFF           djnz    r15,%2086
2184: FFFF           djnz    r15,%2088
2186: FFFF           djnz    r15,%208a
2188: FFFF           djnz    r15,%208c
218A: FFFF           djnz    r15,%208e
218C: FFFF           djnz    r15,%2090
218E: FFFF           djnz    r15,%2092
2190: FFFF           djnz    r15,%2094
2192: FFFF           djnz    r15,%2096
2194: FFFF           djnz    r15,%2098
2196: FFFF           djnz    r15,%209a
2198: FFFF           djnz    r15,%209c
219A: FFFF           djnz    r15,%209e
219C: FFFF           djnz    r15,%20a0
219E: FFFF           djnz    r15,%20a2
21A0: FFFF           djnz    r15,%20a4
21A2: FFFF           djnz    r15,%20a6
21A4: FFFF           djnz    r15,%20a8
21A6: FFFF           djnz    r15,%20aa
21A8: FFFF           djnz    r15,%20ac
21AA: FFFF           djnz    r15,%20ae
21AC: FFFF           djnz    r15,%20b0
21AE: FFFF           djnz    r15,%20b2
21B0: FFFF           djnz    r15,%20b4
21B2: FFFF           djnz    r15,%20b6
21B4: FFFF           djnz    r15,%20b8
21B6: FFFF           djnz    r15,%20ba
21B8: FFFF           djnz    r15,%20bc
21BA: FFFF           djnz    r15,%20be
21BC: FFFF           djnz    r15,%20c0
21BE: FFFF           djnz    r15,%20c2
21C0: FFFF           djnz    r15,%20c4
21C2: FFFF           djnz    r15,%20c6
21C4: FFFF           djnz    r15,%20c8
21C6: FFFF           djnz    r15,%20ca
21C8: FFFF           djnz    r15,%20cc
21CA: FFFF           djnz    r15,%20ce
21CC: FFFF           djnz    r15,%20d0
21CE: FFFF           djnz    r15,%20d2
21D0: FFFF           djnz    r15,%20d4
21D2: FFFF           djnz    r15,%20d6
21D4: FFFF           djnz    r15,%20d8
21D6: FFFF           djnz    r15,%20da
21D8: FFFF           djnz    r15,%20dc
21DA: FFFF           djnz    r15,%20de
21DC: FFFF           djnz    r15,%20e0
21DE: FFFF           djnz    r15,%20e2
21E0: FFFF           djnz    r15,%20e4
21E2: FFFF           djnz    r15,%20e6
21E4: FFFF           djnz    r15,%20e8
21E6: FFFF           djnz    r15,%20ea
21E8: FFFF           djnz    r15,%20ec
21EA: FFFF           djnz    r15,%20ee
21EC: FFFF           djnz    r15,%20f0
21EE: FFFF           djnz    r15,%20f2
21F0: FFFF           djnz    r15,%20f4
21F2: FFFF           djnz    r15,%20f6
21F4: FFFF           djnz    r15,%20f8
21F6: FFFF           djnz    r15,%20fa
21F8: FFFF           djnz    r15,%20fc
21FA: FFFF           djnz    r15,%20fe
21FC: FFFF           djnz    r15,%2100
21FE: FFFF           djnz    r15,%2102
2200: FFFF           djnz    r15,%2104
2202: FFFF           djnz    r15,%2106
2204: FFFF           djnz    r15,%2108
2206: FFFF           djnz    r15,%210a
2208: FFFF           djnz    r15,%210c
220A: FFFF           djnz    r15,%210e
220C: FFFF           djnz    r15,%2110
220E: FFFF           djnz    r15,%2112
2210: FFFF           djnz    r15,%2114
2212: FFFF           djnz    r15,%2116
2214: FFFF           djnz    r15,%2118
2216: FFFF           djnz    r15,%211a
2218: FFFF           djnz    r15,%211c
221A: FFFF           djnz    r15,%211e
221C: FFFF           djnz    r15,%2120
221E: FFFF           djnz    r15,%2122
2220: FFFF           djnz    r15,%2124
2222: FFFF           djnz    r15,%2126
2224: FFFF           djnz    r15,%2128
2226: FFFF           djnz    r15,%212a
2228: FFFF           djnz    r15,%212c
222A: FFFF           djnz    r15,%212e
222C: FFFF           djnz    r15,%2130
222E: FFFF           djnz    r15,%2132
2230: FFFF           djnz    r15,%2134
2232: FFFF           djnz    r15,%2136
2234: FFFF           djnz    r15,%2138
2236: FFFF           djnz    r15,%213a
2238: FFFF           djnz    r15,%213c
223A: FFFF           djnz    r15,%213e
223C: FFFF           djnz    r15,%2140
223E: FFFF           djnz    r15,%2142
2240: FFFF           djnz    r15,%2144
2242: FFFF           djnz    r15,%2146
2244: FFFF           djnz    r15,%2148
2246: FFFF           djnz    r15,%214a
2248: FFFF           djnz    r15,%214c
224A: FFFF           djnz    r15,%214e
224C: FFFF           djnz    r15,%2150
224E: FFFF           djnz    r15,%2152
2250: FFFF           djnz    r15,%2154
2252: FFFF           djnz    r15,%2156
2254: FFFF           djnz    r15,%2158
2256: FFFF           djnz    r15,%215a
2258: FFFF           djnz    r15,%215c
225A: FFFF           djnz    r15,%215e
225C: FFFF           djnz    r15,%2160
225E: FFFF           djnz    r15,%2162
2260: FFFF           djnz    r15,%2164
2262: FFFF           djnz    r15,%2166
2264: FFFF           djnz    r15,%2168
2266: FFFF           djnz    r15,%216a
2268: FFFF           djnz    r15,%216c
226A: FFFF           djnz    r15,%216e
226C: FFFF           djnz    r15,%2170
226E: FFFF           djnz    r15,%2172
2270: FFFF           djnz    r15,%2174
2272: FFFF           djnz    r15,%2176
2274: FFFF           djnz    r15,%2178
2276: FFFF           djnz    r15,%217a
2278: FFFF           djnz    r15,%217c
227A: FFFF           djnz    r15,%217e
227C: FFFF           djnz    r15,%2180
227E: FFFF           djnz    r15,%2182
2280: FFFF           djnz    r15,%2184
2282: FFFF           djnz    r15,%2186
2284: FFFF           djnz    r15,%2188
2286: FFFF           djnz    r15,%218a
2288: FFFF           djnz    r15,%218c
228A: FFFF           djnz    r15,%218e
228C: FFFF           djnz    r15,%2190
228E: FFFF           djnz    r15,%2192
2290: FFFF           djnz    r15,%2194
2292: FFFF           djnz    r15,%2196
2294: FFFF           djnz    r15,%2198
2296: FFFF           djnz    r15,%219a
2298: FFFF           djnz    r15,%219c
229A: FFFF           djnz    r15,%219e
229C: FFFF           djnz    r15,%21a0
229E: FFFF           djnz    r15,%21a2
22A0: FFFF           djnz    r15,%21a4
22A2: FFFF           djnz    r15,%21a6
22A4: FFFF           djnz    r15,%21a8
22A6: FFFF           djnz    r15,%21aa
22A8: FFFF           djnz    r15,%21ac
22AA: FFFF           djnz    r15,%21ae
22AC: FFFF           djnz    r15,%21b0
22AE: FFFF           djnz    r15,%21b2
22B0: FFFF           djnz    r15,%21b4
22B2: FFFF           djnz    r15,%21b6
22B4: FFFF           djnz    r15,%21b8
22B6: FFFF           djnz    r15,%21ba
22B8: FFFF           djnz    r15,%21bc
22BA: FFFF           djnz    r15,%21be
22BC: FFFF           djnz    r15,%21c0
22BE: FFFF           djnz    r15,%21c2
22C0: FFFF           djnz    r15,%21c4
22C2: FFFF           djnz    r15,%21c6
22C4: FFFF           djnz    r15,%21c8
22C6: FFFF           djnz    r15,%21ca
22C8: FFFF           djnz    r15,%21cc
22CA: FFFF           djnz    r15,%21ce
22CC: FFFF           djnz    r15,%21d0
22CE: FFFF           djnz    r15,%21d2
22D0: FFFF           djnz    r15,%21d4
22D2: FFFF           djnz    r15,%21d6
22D4: FFFF           djnz    r15,%21d8
22D6: FFFF           djnz    r15,%21da
22D8: FFFF           djnz    r15,%21dc
22DA: FFFF           djnz    r15,%21de
22DC: FFFF           djnz    r15,%21e0
22DE: FFFF           djnz    r15,%21e2
22E0: FFFF           djnz    r15,%21e4
22E2: FFFF           djnz    r15,%21e6
22E4: FFFF           djnz    r15,%21e8
22E6: FFFF           djnz    r15,%21ea
22E8: FFFF           djnz    r15,%21ec
22EA: FFFF           djnz    r15,%21ee
22EC: FFFF           djnz    r15,%21f0
22EE: FFFF           djnz    r15,%21f2
22F0: FFFF           djnz    r15,%21f4
22F2: FFFF           djnz    r15,%21f6
22F4: FFFF           djnz    r15,%21f8
22F6: FFFF           djnz    r15,%21fa
22F8: FFFF           djnz    r15,%21fc
22FA: FFFF           djnz    r15,%21fe
22FC: FFFF           djnz    r15,%2200
22FE: FFFF           djnz    r15,%2202
2300: FFFF           djnz    r15,%2204
2302: FFFF           djnz    r15,%2206
2304: FFFF           djnz    r15,%2208
2306: FFFF           djnz    r15,%220a
2308: FFFF           djnz    r15,%220c
230A: FFFF           djnz    r15,%220e
230C: FFFF           djnz    r15,%2210
230E: FFFF           djnz    r15,%2212
2310: FFFF           djnz    r15,%2214
2312: FFFF           djnz    r15,%2216
2314: FFFF           djnz    r15,%2218
2316: FFFF           djnz    r15,%221a
2318: FFFF           djnz    r15,%221c
231A: FFFF           djnz    r15,%221e
231C: FFFF           djnz    r15,%2220
231E: FFFF           djnz    r15,%2222
2320: FFFF           djnz    r15,%2224
2322: FFFF           djnz    r15,%2226
2324: FFFF           djnz    r15,%2228
2326: FFFF           djnz    r15,%222a
2328: FFFF           djnz    r15,%222c
232A: FFFF           djnz    r15,%222e
232C: FFFF           djnz    r15,%2230
232E: FFFF           djnz    r15,%2232
2330: FFFF           djnz    r15,%2234
2332: FFFF           djnz    r15,%2236
2334: FFFF           djnz    r15,%2238
2336: FFFF           djnz    r15,%223a
2338: FFFF           djnz    r15,%223c
233A: FFFF           djnz    r15,%223e
233C: FFFF           djnz    r15,%2240
233E: FFFF           djnz    r15,%2242
2340: FFFF           djnz    r15,%2244
2342: FFFF           djnz    r15,%2246
2344: FFFF           djnz    r15,%2248
2346: FFFF           djnz    r15,%224a
2348: FFFF           djnz    r15,%224c
234A: FFFF           djnz    r15,%224e
234C: FFFF           djnz    r15,%2250
234E: FFFF           djnz    r15,%2252
2350: FFFF           djnz    r15,%2254
2352: FFFF           djnz    r15,%2256
2354: FFFF           djnz    r15,%2258
2356: FFFF           djnz    r15,%225a
2358: FFFF           djnz    r15,%225c
235A: FFFF           djnz    r15,%225e
235C: FFFF           djnz    r15,%2260
235E: FFFF           djnz    r15,%2262
2360: FFFF           djnz    r15,%2264
2362: FFFF           djnz    r15,%2266
2364: FFFF           djnz    r15,%2268
2366: FFFF           djnz    r15,%226a
2368: FFFF           djnz    r15,%226c
236A: FFFF           djnz    r15,%226e
236C: FFFF           djnz    r15,%2270
236E: FFFF           djnz    r15,%2272
2370: FFFF           djnz    r15,%2274
2372: FFFF           djnz    r15,%2276
2374: FFFF           djnz    r15,%2278
2376: FFFF           djnz    r15,%227a
2378: FFFF           djnz    r15,%227c
237A: FFFF           djnz    r15,%227e
237C: FFFF           djnz    r15,%2280
237E: FFFF           djnz    r15,%2282
2380: FFFF           djnz    r15,%2284
2382: FFFF           djnz    r15,%2286
2384: FFFF           djnz    r15,%2288
2386: FFFF           djnz    r15,%228a
2388: FFFF           djnz    r15,%228c
238A: FFFF           djnz    r15,%228e
238C: FFFF           djnz    r15,%2290
238E: FFFF           djnz    r15,%2292
2390: FFFF           djnz    r15,%2294
2392: FFFF           djnz    r15,%2296
2394: FFFF           djnz    r15,%2298
2396: FFFF           djnz    r15,%229a
2398: FFFF           djnz    r15,%229c
239A: FFFF           djnz    r15,%229e
239C: FFFF           djnz    r15,%22a0
239E: FFFF           djnz    r15,%22a2
23A0: FFFF           djnz    r15,%22a4
23A2: FFFF           djnz    r15,%22a6
23A4: FFFF           djnz    r15,%22a8
23A6: FFFF           djnz    r15,%22aa
23A8: FFFF           djnz    r15,%22ac
23AA: FFFF           djnz    r15,%22ae
23AC: FFFF           djnz    r15,%22b0
23AE: FFFF           djnz    r15,%22b2
23B0: FFFF           djnz    r15,%22b4
23B2: FFFF           djnz    r15,%22b6
23B4: FFFF           djnz    r15,%22b8
23B6: FFFF           djnz    r15,%22ba
23B8: FFFF           djnz    r15,%22bc
23BA: FFFF           djnz    r15,%22be
23BC: FFFF           djnz    r15,%22c0
23BE: FFFF           djnz    r15,%22c2
23C0: FFFF           djnz    r15,%22c4
23C2: FFFF           djnz    r15,%22c6
23C4: FFFF           djnz    r15,%22c8
23C6: FFFF           djnz    r15,%22ca
23C8: FFFF           djnz    r15,%22cc
23CA: FFFF           djnz    r15,%22ce
23CC: FFFF           djnz    r15,%22d0
23CE: FFFF           djnz    r15,%22d2
23D0: FFFF           djnz    r15,%22d4
23D2: FFFF           djnz    r15,%22d6
23D4: FFFF           djnz    r15,%22d8
23D6: FFFF           djnz    r15,%22da
23D8: FFFF           djnz    r15,%22dc
23DA: FFFF           djnz    r15,%22de
23DC: FFFF           djnz    r15,%22e0
23DE: FFFF           djnz    r15,%22e2
23E0: FFFF           djnz    r15,%22e4
23E2: FFFF           djnz    r15,%22e6
23E4: FFFF           djnz    r15,%22e8
23E6: FFFF           djnz    r15,%22ea
23E8: FFFF           djnz    r15,%22ec
23EA: FFFF           djnz    r15,%22ee
23EC: FFFF           djnz    r15,%22f0
23EE: FFFF           djnz    r15,%22f2
23F0: FFFF           djnz    r15,%22f4
23F2: FFFF           djnz    r15,%22f6
23F4: FFFF           djnz    r15,%22f8
23F6: FFFF           djnz    r15,%22fa
23F8: FFFF           djnz    r15,%22fc
23FA: FFFF           djnz    r15,%22fe
23FC: FFFF           djnz    r15,%2300
23FE: FFFF           djnz    r15,%2302
2400: FFFF           djnz    r15,%2304
2402: FFFF           djnz    r15,%2306
2404: FFFF           djnz    r15,%2308
2406: FFFF           djnz    r15,%230a
2408: FFFF           djnz    r15,%230c
240A: FFFF           djnz    r15,%230e
240C: FFFF           djnz    r15,%2310
240E: FFFF           djnz    r15,%2312
2410: FFFF           djnz    r15,%2314
2412: FFFF           djnz    r15,%2316
2414: FFFF           djnz    r15,%2318
2416: FFFF           djnz    r15,%231a
2418: FFFF           djnz    r15,%231c
241A: FFFF           djnz    r15,%231e
241C: FFFF           djnz    r15,%2320
241E: FFFF           djnz    r15,%2322
2420: FFFF           djnz    r15,%2324
2422: FFFF           djnz    r15,%2326
2424: FFFF           djnz    r15,%2328
2426: FFFF           djnz    r15,%232a
2428: FFFF           djnz    r15,%232c
242A: FFFF           djnz    r15,%232e
242C: FFFF           djnz    r15,%2330
242E: FFFF           djnz    r15,%2332
2430: FFFF           djnz    r15,%2334
2432: FFFF           djnz    r15,%2336
2434: FFFF           djnz    r15,%2338
2436: FFFF           djnz    r15,%233a
2438: FFFF           djnz    r15,%233c
243A: FFFF           djnz    r15,%233e
243C: FFFF           djnz    r15,%2340
243E: FFFF           djnz    r15,%2342
2440: FFFF           djnz    r15,%2344
2442: FFFF           djnz    r15,%2346
2444: FFFF           djnz    r15,%2348
2446: FFFF           djnz    r15,%234a
2448: FFFF           djnz    r15,%234c
244A: FFFF           djnz    r15,%234e
244C: FFFF           djnz    r15,%2350
244E: FFFF           djnz    r15,%2352
2450: FFFF           djnz    r15,%2354
2452: FFFF           djnz    r15,%2356
2454: FFFF           djnz    r15,%2358
2456: FFFF           djnz    r15,%235a
2458: FFFF           djnz    r15,%235c
245A: FFFF           djnz    r15,%235e
245C: FFFF           djnz    r15,%2360
245E: FFFF           djnz    r15,%2362
2460: FFFF           djnz    r15,%2364
2462: FFFF           djnz    r15,%2366
2464: FFFF           djnz    r15,%2368
2466: FFFF           djnz    r15,%236a
2468: FFFF           djnz    r15,%236c
246A: FFFF           djnz    r15,%236e
246C: FFFF           djnz    r15,%2370
246E: FFFF           djnz    r15,%2372
2470: FFFF           djnz    r15,%2374
2472: FFFF           djnz    r15,%2376
2474: FFFF           djnz    r15,%2378
2476: FFFF           djnz    r15,%237a
2478: FFFF           djnz    r15,%237c
247A: FFFF           djnz    r15,%237e
247C: FFFF           djnz    r15,%2380
247E: FFFF           djnz    r15,%2382
2480: FFFF           djnz    r15,%2384
2482: FFFF           djnz    r15,%2386
2484: FFFF           djnz    r15,%2388
2486: FFFF           djnz    r15,%238a
2488: FFFF           djnz    r15,%238c
248A: FFFF           djnz    r15,%238e
248C: FFFF           djnz    r15,%2390
248E: FFFF           djnz    r15,%2392
2490: FFFF           djnz    r15,%2394
2492: FFFF           djnz    r15,%2396
2494: FFFF           djnz    r15,%2398
2496: FFFF           djnz    r15,%239a
2498: FFFF           djnz    r15,%239c
249A: FFFF           djnz    r15,%239e
249C: FFFF           djnz    r15,%23a0
249E: FFFF           djnz    r15,%23a2
24A0: FFFF           djnz    r15,%23a4
24A2: FFFF           djnz    r15,%23a6
24A4: FFFF           djnz    r15,%23a8
24A6: FFFF           djnz    r15,%23aa
24A8: FFFF           djnz    r15,%23ac
24AA: FFFF           djnz    r15,%23ae
24AC: FFFF           djnz    r15,%23b0
24AE: FFFF           djnz    r15,%23b2
24B0: FFFF           djnz    r15,%23b4
24B2: FFFF           djnz    r15,%23b6
24B4: FFFF           djnz    r15,%23b8
24B6: FFFF           djnz    r15,%23ba
24B8: FFFF           djnz    r15,%23bc
24BA: FFFF           djnz    r15,%23be
24BC: FFFF           djnz    r15,%23c0
24BE: FFFF           djnz    r15,%23c2
24C0: FFFF           djnz    r15,%23c4
24C2: FFFF           djnz    r15,%23c6
24C4: FFFF           djnz    r15,%23c8
24C6: FFFF           djnz    r15,%23ca
24C8: FFFF           djnz    r15,%23cc
24CA: FFFF           djnz    r15,%23ce
24CC: FFFF           djnz    r15,%23d0
24CE: FFFF           djnz    r15,%23d2
24D0: FFFF           djnz    r15,%23d4
24D2: FFFF           djnz    r15,%23d6
24D4: FFFF           djnz    r15,%23d8
24D6: FFFF           djnz    r15,%23da
24D8: FFFF           djnz    r15,%23dc
24DA: FFFF           djnz    r15,%23de
24DC: FFFF           djnz    r15,%23e0
24DE: FFFF           djnz    r15,%23e2
24E0: FFFF           djnz    r15,%23e4
24E2: FFFF           djnz    r15,%23e6
24E4: FFFF           djnz    r15,%23e8
24E6: FFFF           djnz    r15,%23ea
24E8: FFFF           djnz    r15,%23ec
24EA: FFFF           djnz    r15,%23ee
24EC: FFFF           djnz    r15,%23f0
24EE: FFFF           djnz    r15,%23f2
24F0: FFFF           djnz    r15,%23f4
24F2: FFFF           djnz    r15,%23f6
24F4: FFFF           djnz    r15,%23f8
24F6: FFFF           djnz    r15,%23fa
24F8: FFFF           djnz    r15,%23fc
24FA: FFFF           djnz    r15,%23fe
24FC: FFFF           djnz    r15,%2400
24FE: FFFF           djnz    r15,%2402
2500: FFFF           djnz    r15,%2404
2502: FFFF           djnz    r15,%2406
2504: FFFF           djnz    r15,%2408
2506: FFFF           djnz    r15,%240a
2508: FFFF           djnz    r15,%240c
250A: FFFF           djnz    r15,%240e
250C: FFFF           djnz    r15,%2410
250E: FFFF           djnz    r15,%2412
2510: FFFF           djnz    r15,%2414
2512: FFFF           djnz    r15,%2416
2514: FFFF           djnz    r15,%2418
2516: FFFF           djnz    r15,%241a
2518: FFFF           djnz    r15,%241c
251A: FFFF           djnz    r15,%241e
251C: FFFF           djnz    r15,%2420
251E: FFFF           djnz    r15,%2422
2520: FFFF           djnz    r15,%2424
2522: FFFF           djnz    r15,%2426
2524: FFFF           djnz    r15,%2428
2526: FFFF           djnz    r15,%242a
2528: FFFF           djnz    r15,%242c
252A: FFFF           djnz    r15,%242e
252C: FFFF           djnz    r15,%2430
252E: FFFF           djnz    r15,%2432
2530: FFFF           djnz    r15,%2434
2532: FFFF           djnz    r15,%2436
2534: FFFF           djnz    r15,%2438
2536: FFFF           djnz    r15,%243a
2538: FFFF           djnz    r15,%243c
253A: FFFF           djnz    r15,%243e
253C: FFFF           djnz    r15,%2440
253E: FFFF           djnz    r15,%2442
2540: FFFF           djnz    r15,%2444
2542: FFFF           djnz    r15,%2446
2544: FFFF           djnz    r15,%2448
2546: FFFF           djnz    r15,%244a
2548: FFFF           djnz    r15,%244c
254A: FFFF           djnz    r15,%244e
254C: FFFF           djnz    r15,%2450
254E: FFFF           djnz    r15,%2452
2550: FFFF           djnz    r15,%2454
2552: FFFF           djnz    r15,%2456
2554: FFFF           djnz    r15,%2458
2556: FFFF           djnz    r15,%245a
2558: FFFF           djnz    r15,%245c
255A: FFFF           djnz    r15,%245e
255C: FFFF           djnz    r15,%2460
255E: FFFF           djnz    r15,%2462
2560: FFFF           djnz    r15,%2464
2562: FFFF           djnz    r15,%2466
2564: FFFF           djnz    r15,%2468
2566: FFFF           djnz    r15,%246a
2568: FFFF           djnz    r15,%246c
256A: FFFF           djnz    r15,%246e
256C: FFFF           djnz    r15,%2470
256E: FFFF           djnz    r15,%2472
2570: FFFF           djnz    r15,%2474
2572: FFFF           djnz    r15,%2476
2574: FFFF           djnz    r15,%2478
2576: FFFF           djnz    r15,%247a
2578: FFFF           djnz    r15,%247c
257A: FFFF           djnz    r15,%247e
257C: FFFF           djnz    r15,%2480
257E: FFFF           djnz    r15,%2482
2580: FFFF           djnz    r15,%2484
2582: FFFF           djnz    r15,%2486
2584: FFFF           djnz    r15,%2488
2586: FFFF           djnz    r15,%248a
2588: FFFF           djnz    r15,%248c
258A: FFFF           djnz    r15,%248e
258C: FFFF           djnz    r15,%2490
258E: FFFF           djnz    r15,%2492
2590: FFFF           djnz    r15,%2494
2592: FFFF           djnz    r15,%2496
2594: FFFF           djnz    r15,%2498
2596: FFFF           djnz    r15,%249a
2598: FFFF           djnz    r15,%249c
259A: FFFF           djnz    r15,%249e
259C: FFFF           djnz    r15,%24a0
259E: FFFF           djnz    r15,%24a2
25A0: FFFF           djnz    r15,%24a4
25A2: FFFF           djnz    r15,%24a6
25A4: FFFF           djnz    r15,%24a8
25A6: FFFF           djnz    r15,%24aa
25A8: FFFF           djnz    r15,%24ac
25AA: FFFF           djnz    r15,%24ae
25AC: FFFF           djnz    r15,%24b0
25AE: FFFF           djnz    r15,%24b2
25B0: FFFF           djnz    r15,%24b4
25B2: FFFF           djnz    r15,%24b6
25B4: FFFF           djnz    r15,%24b8
25B6: FFFF           djnz    r15,%24ba
25B8: FFFF           djnz    r15,%24bc
25BA: FFFF           djnz    r15,%24be
25BC: FFFF           djnz    r15,%24c0
25BE: FFFF           djnz    r15,%24c2
25C0: FFFF           djnz    r15,%24c4
25C2: FFFF           djnz    r15,%24c6
25C4: FFFF           djnz    r15,%24c8
25C6: FFFF           djnz    r15,%24ca
25C8: FFFF           djnz    r15,%24cc
25CA: FFFF           djnz    r15,%24ce
25CC: FFFF           djnz    r15,%24d0
25CE: FFFF           djnz    r15,%24d2
25D0: FFFF           djnz    r15,%24d4
25D2: FFFF           djnz    r15,%24d6
25D4: FFFF           djnz    r15,%24d8
25D6: FFFF           djnz    r15,%24da
25D8: FFFF           djnz    r15,%24dc
25DA: FFFF           djnz    r15,%24de
25DC: FFFF           djnz    r15,%24e0
25DE: FFFF           djnz    r15,%24e2
25E0: FFFF           djnz    r15,%24e4
25E2: FFFF           djnz    r15,%24e6
25E4: FFFF           djnz    r15,%24e8
25E6: FFFF           djnz    r15,%24ea
25E8: FFFF           djnz    r15,%24ec
25EA: FFFF           djnz    r15,%24ee
25EC: FFFF           djnz    r15,%24f0
25EE: FFFF           djnz    r15,%24f2
25F0: FFFF           djnz    r15,%24f4
25F2: FFFF           djnz    r15,%24f6
25F4: FFFF           djnz    r15,%24f8
25F6: FFFF           djnz    r15,%24fa
25F8: FFFF           djnz    r15,%24fc
25FA: FFFF           djnz    r15,%24fe
25FC: FFFF           djnz    r15,%2500
25FE: FFFF           djnz    r15,%2502
2600: FFFF           djnz    r15,%2504
2602: FFFF           djnz    r15,%2506
2604: FFFF           djnz    r15,%2508
2606: FFFF           djnz    r15,%250a
2608: FFFF           djnz    r15,%250c
260A: FFFF           djnz    r15,%250e
260C: FFFF           djnz    r15,%2510
260E: FFFF           djnz    r15,%2512
2610: FFFF           djnz    r15,%2514
2612: FFFF           djnz    r15,%2516
2614: FFFF           djnz    r15,%2518
2616: FFFF           djnz    r15,%251a
2618: FFFF           djnz    r15,%251c
261A: FFFF           djnz    r15,%251e
261C: FFFF           djnz    r15,%2520
261E: FFFF           djnz    r15,%2522
2620: FFFF           djnz    r15,%2524
2622: FFFF           djnz    r15,%2526
2624: FFFF           djnz    r15,%2528
2626: FFFF           djnz    r15,%252a
2628: FFFF           djnz    r15,%252c
262A: FFFF           djnz    r15,%252e
262C: FFFF           djnz    r15,%2530
262E: FFFF           djnz    r15,%2532
2630: FFFF           djnz    r15,%2534
2632: FFFF           djnz    r15,%2536
2634: FFFF           djnz    r15,%2538
2636: FFFF           djnz    r15,%253a
2638: FFFF           djnz    r15,%253c
263A: FFFF           djnz    r15,%253e
263C: FFFF           djnz    r15,%2540
263E: FFFF           djnz    r15,%2542
2640: FFFF           djnz    r15,%2544
2642: FFFF           djnz    r15,%2546
2644: FFFF           djnz    r15,%2548
2646: FFFF           djnz    r15,%254a
2648: FFFF           djnz    r15,%254c
264A: FFFF           djnz    r15,%254e
264C: FFFF           djnz    r15,%2550
264E: FFFF           djnz    r15,%2552
2650: FFFF           djnz    r15,%2554
2652: FFFF           djnz    r15,%2556
2654: FFFF           djnz    r15,%2558
2656: FFFF           djnz    r15,%255a
2658: FFFF           djnz    r15,%255c
265A: FFFF           djnz    r15,%255e
265C: FFFF           djnz    r15,%2560
265E: FFFF           djnz    r15,%2562
2660: FFFF           djnz    r15,%2564
2662: FFFF           djnz    r15,%2566
2664: FFFF           djnz    r15,%2568
2666: FFFF           djnz    r15,%256a
2668: FFFF           djnz    r15,%256c
266A: FFFF           djnz    r15,%256e
266C: FFFF           djnz    r15,%2570
266E: FFFF           djnz    r15,%2572
2670: FFFF           djnz    r15,%2574
2672: FFFF           djnz    r15,%2576
2674: FFFF           djnz    r15,%2578
2676: FFFF           djnz    r15,%257a
2678: FFFF           djnz    r15,%257c
267A: FFFF           djnz    r15,%257e
267C: FFFF           djnz    r15,%2580
267E: FFFF           djnz    r15,%2582
2680: FFFF           djnz    r15,%2584
2682: FFFF           djnz    r15,%2586
2684: FFFF           djnz    r15,%2588
2686: FFFF           djnz    r15,%258a
2688: FFFF           djnz    r15,%258c
268A: FFFF           djnz    r15,%258e
268C: FFFF           djnz    r15,%2590
268E: FFFF           djnz    r15,%2592
2690: FFFF           djnz    r15,%2594
2692: FFFF           djnz    r15,%2596
2694: FFFF           djnz    r15,%2598
2696: FFFF           djnz    r15,%259a
2698: FFFF           djnz    r15,%259c
269A: FFFF           djnz    r15,%259e
269C: FFFF           djnz    r15,%25a0
269E: FFFF           djnz    r15,%25a2
26A0: FFFF           djnz    r15,%25a4
26A2: FFFF           djnz    r15,%25a6
26A4: FFFF           djnz    r15,%25a8
26A6: FFFF           djnz    r15,%25aa
26A8: FFFF           djnz    r15,%25ac
26AA: FFFF           djnz    r15,%25ae
26AC: FFFF           djnz    r15,%25b0
26AE: FFFF           djnz    r15,%25b2
26B0: FFFF           djnz    r15,%25b4
26B2: FFFF           djnz    r15,%25b6
26B4: FFFF           djnz    r15,%25b8
26B6: FFFF           djnz    r15,%25ba
26B8: FFFF           djnz    r15,%25bc
26BA: FFFF           djnz    r15,%25be
26BC: FFFF           djnz    r15,%25c0
26BE: FFFF           djnz    r15,%25c2
26C0: FFFF           djnz    r15,%25c4
26C2: FFFF           djnz    r15,%25c6
26C4: FFFF           djnz    r15,%25c8
26C6: FFFF           djnz    r15,%25ca
26C8: FFFF           djnz    r15,%25cc
26CA: FFFF           djnz    r15,%25ce
26CC: FFFF           djnz    r15,%25d0
26CE: FFFF           djnz    r15,%25d2
26D0: FFFF           djnz    r15,%25d4
26D2: FFFF           djnz    r15,%25d6
26D4: FFFF           djnz    r15,%25d8
26D6: FFFF           djnz    r15,%25da
26D8: FFFF           djnz    r15,%25dc
26DA: FFFF           djnz    r15,%25de
26DC: FFFF           djnz    r15,%25e0
26DE: FFFF           djnz    r15,%25e2
26E0: FFFF           djnz    r15,%25e4
26E2: FFFF           djnz    r15,%25e6
26E4: FFFF           djnz    r15,%25e8
26E6: FFFF           djnz    r15,%25ea
26E8: FFFF           djnz    r15,%25ec
26EA: FFFF           djnz    r15,%25ee
26EC: FFFF           djnz    r15,%25f0
26EE: FFFF           djnz    r15,%25f2
26F0: FFFF           djnz    r15,%25f4
26F2: FFFF           djnz    r15,%25f6
26F4: FFFF           djnz    r15,%25f8
26F6: FFFF           djnz    r15,%25fa
26F8: FFFF           djnz    r15,%25fc
26FA: FFFF           djnz    r15,%25fe
26FC: FFFF           djnz    r15,%2600
26FE: FFFF           djnz    r15,%2602
2700: FFFF           djnz    r15,%2604
2702: FFFF           djnz    r15,%2606
2704: FFFF           djnz    r15,%2608
2706: FFFF           djnz    r15,%260a
2708: FFFF           djnz    r15,%260c
270A: FFFF           djnz    r15,%260e
270C: FFFF           djnz    r15,%2610
270E: FFFF           djnz    r15,%2612
2710: FFFF           djnz    r15,%2614
2712: FFFF           djnz    r15,%2616
2714: FFFF           djnz    r15,%2618
2716: FFFF           djnz    r15,%261a
2718: FFFF           djnz    r15,%261c
271A: FFFF           djnz    r15,%261e
271C: FFFF           djnz    r15,%2620
271E: FFFF           djnz    r15,%2622
2720: FFFF           djnz    r15,%2624
2722: FFFF           djnz    r15,%2626
2724: FFFF           djnz    r15,%2628
2726: FFFF           djnz    r15,%262a
2728: FFFF           djnz    r15,%262c
272A: FFFF           djnz    r15,%262e
272C: FFFF           djnz    r15,%2630
272E: FFFF           djnz    r15,%2632
2730: FFFF           djnz    r15,%2634
2732: FFFF           djnz    r15,%2636
2734: FFFF           djnz    r15,%2638
2736: FFFF           djnz    r15,%263a
2738: FFFF           djnz    r15,%263c
273A: FFFF           djnz    r15,%263e
273C: FFFF           djnz    r15,%2640
273E: FFFF           djnz    r15,%2642
2740: FFFF           djnz    r15,%2644
2742: FFFF           djnz    r15,%2646
2744: FFFF           djnz    r15,%2648
2746: FFFF           djnz    r15,%264a
2748: FFFF           djnz    r15,%264c
274A: FFFF           djnz    r15,%264e
274C: FFFF           djnz    r15,%2650
274E: FFFF           djnz    r15,%2652
2750: FFFF           djnz    r15,%2654
2752: FFFF           djnz    r15,%2656
2754: FFFF           djnz    r15,%2658
2756: FFFF           djnz    r15,%265a
2758: FFFF           djnz    r15,%265c
275A: FFFF           djnz    r15,%265e
275C: FFFF           djnz    r15,%2660
275E: FFFF           djnz    r15,%2662
2760: FFFF           djnz    r15,%2664
2762: FFFF           djnz    r15,%2666
2764: FFFF           djnz    r15,%2668
2766: FFFF           djnz    r15,%266a
2768: FFFF           djnz    r15,%266c
276A: FFFF           djnz    r15,%266e
276C: FFFF           djnz    r15,%2670
276E: FFFF           djnz    r15,%2672
2770: FFFF           djnz    r15,%2674
2772: FFFF           djnz    r15,%2676
2774: FFFF           djnz    r15,%2678
2776: FFFF           djnz    r15,%267a
2778: FFFF           djnz    r15,%267c
277A: FFFF           djnz    r15,%267e
277C: FFFF           djnz    r15,%2680
277E: FFFF           djnz    r15,%2682
2780: FFFF           djnz    r15,%2684
2782: FFFF           djnz    r15,%2686
2784: FFFF           djnz    r15,%2688
2786: FFFF           djnz    r15,%268a
2788: FFFF           djnz    r15,%268c
278A: FFFF           djnz    r15,%268e
278C: FFFF           djnz    r15,%2690
278E: FFFF           djnz    r15,%2692
2790: FFFF           djnz    r15,%2694
2792: FFFF           djnz    r15,%2696
2794: FFFF           djnz    r15,%2698
2796: FFFF           djnz    r15,%269a
2798: FFFF           djnz    r15,%269c
279A: FFFF           djnz    r15,%269e
279C: FFFF           djnz    r15,%26a0
279E: FFFF           djnz    r15,%26a2
27A0: FFFF           djnz    r15,%26a4
27A2: FFFF           djnz    r15,%26a6
27A4: FFFF           djnz    r15,%26a8
27A6: FFFF           djnz    r15,%26aa
27A8: FFFF           djnz    r15,%26ac
27AA: FFFF           djnz    r15,%26ae
27AC: FFFF           djnz    r15,%26b0
27AE: FFFF           djnz    r15,%26b2
27B0: FFFF           djnz    r15,%26b4
27B2: FFFF           djnz    r15,%26b6
27B4: FFFF           djnz    r15,%26b8
27B6: FFFF           djnz    r15,%26ba
27B8: FFFF           djnz    r15,%26bc
27BA: FFFF           djnz    r15,%26be
27BC: FFFF           djnz    r15,%26c0
27BE: FFFF           djnz    r15,%26c2
27C0: FFFF           djnz    r15,%26c4
27C2: FFFF           djnz    r15,%26c6
27C4: FFFF           djnz    r15,%26c8
27C6: FFFF           djnz    r15,%26ca
27C8: FFFF           djnz    r15,%26cc
27CA: FFFF           djnz    r15,%26ce
27CC: FFFF           djnz    r15,%26d0
27CE: FFFF           djnz    r15,%26d2
27D0: FFFF           djnz    r15,%26d4
27D2: FFFF           djnz    r15,%26d6
27D4: FFFF           djnz    r15,%26d8
27D6: FFFF           djnz    r15,%26da
27D8: FFFF           djnz    r15,%26dc
27DA: FFFF           djnz    r15,%26de
27DC: FFFF           djnz    r15,%26e0
27DE: FFFF           djnz    r15,%26e2
27E0: FFFF           djnz    r15,%26e4
27E2: FFFF           djnz    r15,%26e6
27E4: FFFF           djnz    r15,%26e8
27E6: FFFF           djnz    r15,%26ea
27E8: FFFF           djnz    r15,%26ec
27EA: FFFF           djnz    r15,%26ee
27EC: FFFF           djnz    r15,%26f0
27EE: FFFF           djnz    r15,%26f2
27F0: FFFF           djnz    r15,%26f4
27F2: FFFF           djnz    r15,%26f6
27F4: FFFF           djnz    r15,%26f8
27F6: FFFF           djnz    r15,%26fa
27F8: FFFF           djnz    r15,%26fc
27FA: FFFF           djnz    r15,%26fe
27FC: FFFF           djnz    r15,%2700
27FE: FFFF           djnz    r15,%2702
2800: 2109 0006      ld      r9,#%0006
2804: 210A 0000      ld      r10,#%0000
2808: 8D08           clr     r0
280A: 210C 2000      ld      r12,#%2000
280E: 00A8           addb    rl0,@r10
2810: A9A0           inc     r10,1
2812: 00A0           addb    rh0,@r10
2814: A9A0           inc     r10,1
2816: FC85           djnz    r12,%280e
2818: A880           incb    rl0,1
281A: EE04           jr      ne/nz,%2824
281C: A990           inc     r9,1
281E: A800           incb    rh0,1
2820: EE01           jr      ne/nz,%2824
2822: E81A           jr      %2858
2824: 210A 0400      ld      r10,#%0400
2828: 210B 9800      ld      r11,#%9800
282C: 0DB5 0A24      ld      @r11,#%0a24
2830: A9B1           inc     r11,2
2832: FA84           djnz    r10,%282c
2834: 6F09 8092      ld      %8092,r9
2838: 4D08 8090      clr     %8090
283C: E8FF           jr      %283c
283E: A101           ld      r1,r0
2840: 0701 000F      and     r1,#%000f
2844: EEEF           jr      ne/nz,%2824
2846: B301 FFFC      srl     r0,#4
284A: A990           inc     r9,1
284C: E8F8           jr      %283e
284E: 0700 00FF      and     r0,#%00ff
2852: EEE8           jr      ne/nz,%2824
2854: A990           inc     r9,1
2856: E8E6           jr      %2824
2858: 210E 0004      ld      r14,#%0004
285C: 2109 00A8      ld      r9,#%00a8
2860: 210B 8100      ld      r11,#%8100
2864: A1BA           ld      r10,r11
2866: 8D18           clr     r1
2868: A1E2           ld      r2,r14
286A: 210C 0300      ld      r12,#%0300
286E: A110           ld      r0,r1
2870: B311 0002      sll     r1,#2
2874: 8101           add     r1,r0
2876: A910           inc     r1,1
2878: 0121           add     r1,@r2
287A: A921           inc     r2,2
287C: A110           ld      r0,r1
287E: 2FA0           ld      @r10,r0
2880: 09A0           xor     r0,@r10
2882: EEDD           jr      ne/nz,%283e
2884: A9A1           inc     r10,2
2886: FC8D           djnz    r12,%286e
2888: 8D18           clr     r1
288A: A1E2           ld      r2,r14
288C: 210C 0300      ld      r12,#%0300
2890: A110           ld      r0,r1
2892: B311 0002      sll     r1,#2
2896: 8101           add     r1,r0
2898: A910           inc     r1,1
289A: 0121           add     r1,@r2
289C: A921           inc     r2,2
289E: A110           ld      r0,r1
28A0: 09B0           xor     r0,@r11
28A2: EECD           jr      ne/nz,%283e
28A4: A9B1           inc     r11,2
28A6: FC8C           djnz    r12,%2890
28A8: A993           inc     r9,4
28AA: A1BA           ld      r10,r11
28AC: 8D18           clr     r1
28AE: A1E2           ld      r2,r14
28B0: 210C 0400      ld      r12,#%0400
28B4: A110           ld      r0,r1
28B6: B311 0002      sll     r1,#2
28BA: 8101           add     r1,r0
28BC: A910           inc     r1,1
28BE: 0121           add     r1,@r2
28C0: A921           inc     r2,2
28C2: A110           ld      r0,r1
28C4: 2FA0           ld      @r10,r0
28C6: 09A0           xor     r0,@r10
28C8: EEBA           jr      ne/nz,%283e
28CA: A9A1           inc     r10,2
28CC: FC8D           djnz    r12,%28b4
28CE: 8D18           clr     r1
28D0: A1E2           ld      r2,r14
28D2: 210C 0400      ld      r12,#%0400
28D6: A110           ld      r0,r1
28D8: B311 0002      sll     r1,#2
28DC: 8101           add     r1,r0
28DE: A910           inc     r1,1
28E0: 0121           add     r1,@r2
28E2: A921           inc     r2,2
28E4: A110           ld      r0,r1
28E6: 09B0           xor     r0,@r11
28E8: EEAA           jr      ne/nz,%283e
28EA: A9B1           inc     r11,2
28EC: FC8C           djnz    r12,%28d6
28EE: A993           inc     r9,4
28F0: A1BA           ld      r10,r11
28F2: 8D18           clr     r1
28F4: A1E2           ld      r2,r14
28F6: 210C 0800      ld      r12,#%0800
28FA: A110           ld      r0,r1
28FC: B311 0002      sll     r1,#2
2900: 8101           add     r1,r0
2902: A910           inc     r1,1
2904: 0121           add     r1,@r2
2906: A921           inc     r2,2
2908: A110           ld      r0,r1
290A: 2FA0           ld      @r10,r0
290C: 09A0           xor     r0,@r10
290E: EE9F           jr      ne/nz,%284e
2910: A9A1           inc     r10,2
2912: FC8D           djnz    r12,%28fa
2914: 8D18           clr     r1
2916: A1E2           ld      r2,r14
2918: 210C 0800      ld      r12,#%0800
291C: A110           ld      r0,r1
291E: B311 0002      sll     r1,#2
2922: 8101           add     r1,r0
2924: A910           inc     r1,1
2926: 0121           add     r1,@r2
2928: A921           inc     r2,2
292A: A110           ld      r0,r1
292C: 09B0           xor     r0,@r11
292E: EE8F           jr      ne/nz,%284e
2930: A9B1           inc     r11,2
2932: FC8C           djnz    r12,%291c
2934: A991           inc     r9,2
2936: A1BA           ld      r10,r11
2938: 8D18           clr     r1
293A: A1E2           ld      r2,r14
293C: 210C 07F0      ld      r12,#%07f0
2940: A110           ld      r0,r1
2942: B311 0002      sll     r1,#2
2946: 8101           add     r1,r0
2948: A910           inc     r1,1
294A: 0121           add     r1,@r2
294C: A921           inc     r2,2
294E: A110           ld      r0,r1
2950: 2FA0           ld      @r10,r0
2952: 09A0           xor     r0,@r10
2954: 5E0E 284E      jp      ne/nz,%284e
2958: A9A1           inc     r10,2
295A: FC8E           djnz    r12,%2940
295C: 8D18           clr     r1
295E: A1E2           ld      r2,r14
2960: 210C 07F0      ld      r12,#%07f0
2964: A110           ld      r0,r1
2966: B311 0002      sll     r1,#2
296A: 8101           add     r1,r0
296C: A910           inc     r1,1
296E: 0121           add     r1,@r2
2970: A921           inc     r2,2
2972: A110           ld      r0,r1
2974: 09B0           xor     r0,@r11
2976: 5E0E 284E      jp      ne/nz,%284e
297A: A9B1           inc     r11,2
297C: FC8D           djnz    r12,%2964
297E: ABE0           dec     r14,1
2980: 5E0E 285C      jp      ne/nz,%285c
2984: 4D05 8144 0001 ld      %8144,#%0001
298A: 4D05 8146 0001 ld      %8146,#%0001
2990: 4D05 8148 0000 ld      %8148,#%0000
2996: 4D05 814A 0000 ld      %814a,#%0000
299C: 4D05 814C 0000 ld      %814c,#%0000
29A2: 4D05 8000 0000 ld      %8000,#%0000
29A8: 210A 0400      ld      r10,#%0400
29AC: 210B 9800      ld      r11,#%9800
29B0: 0DB5 0A24      ld      @r11,#%0a24
29B4: A9B1           inc     r11,2
29B6: FA84           djnz    r10,%29b0
29B8: 4D08 8094      clr     %8094
29BC: 4D08 8092      clr     %8092
29C0: 4D08 8090      clr     %8090
29C4: 6100 8094      ld      r0,%8094
29C8: 0700 00FF      and     r0,#%00ff
29CC: 0B00 0001      cp      r0,#%0001
29D0: EEF9           jr      ne/nz,%29c4
29D2: 5E08 0006      jp      %0006
29D6: 91F2           pushl   @r15,rr2
29D8: 91F4           pushl   @r15,rr4
29DA: 1404 0000 0000 ldl     rr4,#%00000000
29E0: A113           ld      r3,r1
29E2: 0703 000F      and     r3,#%000f
29E6: 8D28           clr     r2
29E8: 9624           addl    rr4,rr2
29EA: B305 FFFC      srll    rr0,#4
29EE: A113           ld      r3,r1
29F0: 0703 000F      and     r3,#%000f
29F4: 1902 000A      mult    rr2,#%000a
29F8: 9624           addl    rr4,rr2
29FA: B305 FFFC      srll    rr0,#4
29FE: A113           ld      r3,r1
2A00: 0703 000F      and     r3,#%000f
2A04: 1902 0064      mult    rr2,#%0064
2A08: 9624           addl    rr4,rr2
2A0A: B305 FFFC      srll    rr0,#4
2A0E: A113           ld      r3,r1
2A10: 0703 000F      and     r3,#%000f
2A14: 1902 03E8      mult    rr2,#%03e8
2A18: 9624           addl    rr4,rr2
2A1A: B305 FFFC      srll    rr0,#4
2A1E: A113           ld      r3,r1
2A20: 0703 000F      and     r3,#%000f
2A24: 1902 2710      mult    rr2,#%2710
2A28: 9624           addl    rr4,rr2
2A2A: 9440           ldl     rr0,rr4
2A2C: 95F4           popl    rr4,@r15
2A2E: 95F2           popl    rr2,@r15
2A30: 9E08           ret     
2A32: 91F2           pushl   @r15,rr2
2A34: 1402 0000 0000 ldl     rr2,#%00000000
2A3A: 8D08           clr     r0
2A3C: 1B00 2710      div     rr0,#%2710
2A40: 8513           or      r3,r1
2A42: B325 0004      slll    rr2,#4
2A46: A101           ld      r1,r0
2A48: 8D08           clr     r0
2A4A: 1B00 03E8      div     rr0,#%03e8
2A4E: 8513           or      r3,r1
2A50: B325 0004      slll    rr2,#4
2A54: A101           ld      r1,r0
2A56: 8D08           clr     r0
2A58: 1B00 0064      div     rr0,#%0064
2A5C: 8513           or      r3,r1
2A5E: B325 0004      slll    rr2,#4
2A62: A101           ld      r1,r0
2A64: 8D08           clr     r0
2A66: 1B00 000A      div     rr0,#%000a
2A6A: 8513           or      r3,r1
2A6C: B325 0004      slll    rr2,#4
2A70: 8503           or      r3,r0
2A72: 9420           ldl     rr0,rr2
2A74: 95F2           popl    rr2,@r15
2A76: 9E08           ret     
2A78: 2DFD           ex      r13,@r15
2A7A: 91F0           pushl   @r15,rr0
2A7C: A001           ldb     rh1,rh0
2A7E: E804           jr      %2a88
2A80: 2DFD           ex      r13,@r15
2A82: 91F0           pushl   @r15,rr0
2A84: 20D1           ldb     rh1,@r13
2A86: A9D0           inc     r13,1
2A88: A617           bitb    rh1,7
2A8A: EE13           jr      ne/nz,%2ab2
2A8C: 20D9           ldb     rl1,@r13
2A8E: A9D0           inc     r13,1
2A90: 0A09 4040      cpb     rl1,#%40
2A94: E614           jr      eq/z,%2abe
2A96: A018           ldb     rl0,rh1
2A98: 8C18           clrb    rh1
2A9A: 0A09 2020      cpb     rl1,#%20
2A9E: E901           jr      ge,%2aa2
2AA0: C920           ldb     rl1,#%20
2AA2: 0209 2020      subb    rl1,#%20
2AA6: 6019 3C28      ldb     rl1,%3c28(r1)
2AAA: A081           ldb     rh1,rl0
2AAC: 2FC1           ld      @r12,r1
2AAE: A9C1           inc     r12,2
2AB0: E8ED           jr      %2a8c
2AB2: 20D8           ldb     rl0,@r13
2AB4: 8C08           clrb    rh0
2AB6: C924           ldb     rl1,#%24
2AB8: 2FC1           ld      @r12,r1
2ABA: A9C1           inc     r12,2
2ABC: F083           djnz    r0,%2ab8
2ABE: A9D0           inc     r13,1
2AC0: 070D FFFE      and     r13,#%fffe
2AC4: 95F0           popl    rr0,@r15
2AC6: 2DFD           ex      r13,@r15
2AC8: 9E08           ret     
2ACA: 2DFB           ex      r11,@r15
2ACC: 91F0           pushl   @r15,rr0
2ACE: 20B9           ldb     rl1,@r11
2AD0: 8C18           clrb    rh1
2AD2: A9B0           inc     r11,1
2AD4: 0B01 0040      cp      r1,#%0040
2AD8: E616           jr      eq/z,%2b06
2ADA: E113           jr      lt,%2b02
2ADC: 0B01 005A      cp      r1,#%005a
2AE0: EA10           jr      gt,%2b02
2AE2: 6018 2AD1      ldb     rl0,%2ad1(r1)
2AE6: 2FC0           ld      @r12,r0
2AE8: A900           inc     r0,1
2AEA: A9C1           inc     r12,2
2AEC: 2FC0           ld      @r12,r0
2AEE: A900           inc     r0,1
2AF0: 010C 003E      add     r12,#%003e
2AF4: 2FC0           ld      @r12,r0
2AF6: A900           inc     r0,1
2AF8: A9C1           inc     r12,2
2AFA: 2FC0           ld      @r12,r0
2AFC: 030C 003E      sub     r12,#%003e
2B00: E8E6           jr      %2ace
2B02: A9C3           inc     r12,4
2B04: E8E4           jr      %2ace
2B06: 95F0           popl    rr0,@r15
2B08: A9B0           inc     r11,1
2B0A: 070B FFFE      and     r11,#%fffe
2B0E: 2DFB           ex      r11,@r15
2B10: 9E08           ret     
2B12: 940B           ldl     rr11,rr0
2B14: 0C0D           .word   #%0c0d
2B16: 9C0F           .word   #%9c0f
2B18: 9011           cpl     rr1,rr1
2B1A: 1213           subl    rr3,@r1
2B1C: 1415           ldl     rr5,@r1
2B1E: 9817           multl   rq7,rr1
2B20: A019           ldb     rl1,rh1
2B22: 1AA8           divl    rq8,@r10
2B24: 1C1D           .word   #%1c1d
2B26: 1EA4           jp      pe/ov,@rr10
2B28: 2088           ldb     rl0,@r8
2B2A: 8CAC           .word   #%8cac
2B2C: 91F0           pushl   @r15,rr0
2B2E: 91F2           pushl   @r15,rr2
2B30: 91FA           pushl   @r15,rr10
2B32: 9402           ldl     rr2,rr0
2B34: 210A 0005      ld      r10,#%0005
2B38: 210B 0001      ld      r11,#%0001
2B3C: B325 0004      slll    rr2,#4
2B40: A028           ldb     rl0,rh2
2B42: 0608 0F0F      andb    rl0,#%0f
2B46: 8DB4           test    r11
2B48: E605           jr      eq/z,%2b54
2B4A: 8C84           testb   rl0
2B4C: EE02           jr      ne/nz,%2b52
2B4E: C824           ldb     rl0,#%24
2B50: E801           jr      %2b54
2B52: 8DB8           clr     r11
2B54: 2FC0           ld      @r12,r0
2B56: A9C1           inc     r12,2
2B58: FA8F           djnz    r10,%2b3c
2B5A: B321 0004      sll     r2,#4
2B5E: A028           ldb     rl0,rh2
2B60: 0608 0F0F      andb    rl0,#%0f
2B64: 2FC0           ld      @r12,r0
2B66: A9C1           inc     r12,2
2B68: 95FA           popl    rr10,@r15
2B6A: 95F2           popl    rr2,@r15
2B6C: 95F0           popl    rr0,@r15
2B6E: 9E08           ret     
2B70: 91F0           pushl   @r15,rr0
2B72: 91FA           pushl   @r15,rr10
2B74: 210A 0002      ld      r10,#%0002
2B78: 210B 0001      ld      r11,#%0001
2B7C: A018           ldb     rl0,rh1
2B7E: 0608 0F0F      andb    rl0,#%0f
2B82: 8DB4           test    r11
2B84: E605           jr      eq/z,%2b90
2B86: 8C84           testb   rl0
2B88: EE02           jr      ne/nz,%2b8e
2B8A: C824           ldb     rl0,#%24
2B8C: E801           jr      %2b90
2B8E: 8DB8           clr     r11
2B90: 2FC0           ld      @r12,r0
2B92: A9C1           inc     r12,2
2B94: B311 0004      sll     r1,#4
2B98: FA8F           djnz    r10,%2b7c
2B9A: A018           ldb     rl0,rh1
2B9C: 0608 0F0F      andb    rl0,#%0f
2BA0: 2FC0           ld      @r12,r0
2BA2: A9C1           inc     r12,2
2BA4: 95FA           popl    rr10,@r15
2BA6: 95F0           popl    rr0,@r15
2BA8: 9E08           ret     
2BAA: A9C1           inc     r12,2
2BAC: 91F0           pushl   @r15,rr0
2BAE: B311 0004      sll     r1,#4
2BB2: A018           ldb     rl0,rh1
2BB4: 0608 0F0F      andb    rl0,#%0f
2BB8: 2FC0           ld      @r12,r0
2BBA: A9C1           inc     r12,2
2BBC: B311 0004      sll     r1,#4
2BC0: A018           ldb     rl0,rh1
2BC2: 0608 0F0F      andb    rl0,#%0f
2BC6: 2FC0           ld      @r12,r0
2BC8: A9C1           inc     r12,2
2BCA: 95F0           popl    rr0,@r15
2BCC: 9E08           ret     
2BCE: 2104 0007      ld      r4,#%0007
2BD2: 2103 9C50      ld      r3,#%9c50
2BD6: 2102 2BF6      ld      r2,#%2bf6
2BDA: C106           ldb     rh1,#%06
2BDC: 6100 814E      ld      r0,%814e
2BE0: 0700 0001      and     r0,#%0001
2BE4: E602           jr      eq/z,%2bea
2BE6: 8142           add     r2,r4
2BE8: C107           ldb     rh1,#%07
2BEA: 2029           ldb     rl1,@r2
2BEC: 2F31           ld      @r3,r1
2BEE: A920           inc     r2,1
2BF0: A931           inc     r3,2
2BF2: F485           djnz    r4,%2bea
2BF4: 9E08           ret     
2BF6: 0425           orb     rh5,@r2
2BF8: 0305 0930      sub     r5,#%0930
2BFC: 3102 2507      ldr     r2,%5107
2C00: 0009 8788      addb    rl1,#%88
2C04: 2103 9E0C      ld      r3,#%9e0c
2C08: 2102 1B28      ld      r2,#%1b28
2C0C: 2101 0002      ld      r1,#%0002
2C10: 2F32           ld      @r3,r2
2C12: A931           inc     r3,2
2C14: A920           inc     r2,1
2C16: 2F32           ld      @r3,r2
2C18: 0103 003E      add     r3,#%003e
2C1C: A920           inc     r2,1
2C1E: F188           djnz    r1,%2c10
2C20: 0303 0002      sub     r3,#%0002
2C24: DFFD           calr    %2c2c
2C26: 2102 1C28      ld      r2,#%1c28
2C2A: D000           calr    %2c2c
2C2C: 2101 0004      ld      r1,#%0004
2C30: 2F32           ld      @r3,r2
2C32: A931           inc     r3,2
2C34: A920           inc     r2,1
2C36: F184           djnz    r1,%2c30
2C38: 0103 0038      add     r3,#%0038
2C3C: 9E08           ret     
2C3E: DFB4           calr    %2cd8
2C40: 2100 0008      ld      r0,#%0008
2C44: DFAE           calr    %2cea
2C46: DF6C           calr    %2d70
2C48: D03E           calr    %2bce
2C4A: 210D 2C78      ld      r13,#%2c78
2C4E: 21DC           ld      r12,@r13
2C50: A9D1           inc     r13,2
2C52: 20D1           ldb     rh1,@r13
2C54: A9D0           inc     r13,1
2C56: 20D9           ldb     rl1,@r13
2C58: A9D0           inc     r13,1
2C5A: 0A09 FFFF      cpb     rl1,#%ff
2C5E: E603           jr      eq/z,%2c66
2C60: 2FC1           ld      @r12,r1
2C62: A9C1           inc     r12,2
2C64: E8F8           jr      %2c56
2C66: 60D8 0001      ldb     rl0,%0001(r13)
2C6A: A9D0           inc     r13,1
2C6C: 0A08 FFFF      cpb     rl0,#%ff
2C70: 9E06           ret     eq/z
2C72: 070D FFFE      and     r13,#%fffe
2C76: E8EB           jr      %2c4e
2C78: 9ADE           divl    rq14,rr13
2C7A: 1934           mult    rr4,@r3
2C7C: 3536 FFFF      ldl     rr6,r3(#%ffff)
2C80: 9B1E           div     rr14,r1
2C82: 1937           mult    rr7,@r3
2C84: 3839           rsvd38
2C86: FFFF           djnz    r15,%2b8a
2C88: 9B24           div     rr4,r2
2C8A: 1A3A           divl    rq10,@r3
2C8C: 3B3C           .word   #%3b3c
2C8E: 8C8D           .word   #%8c8d
2C90: 8E8F           ext8e   #%8f
2C92: FFFF           djnz    r15,%2b96
2C94: 9BC6           div     rr6,r12
2C96: 080F 1E13      xorb    rl7,#%13
2C9A: 1224           subl    rr4,@r2
2C9C: 1C19 0E0E      ldm     @r1,r14,#15
2CA0: 0D20           com     @r2
2CA2: 0A22           cpb     rh2,@r2
2CA4: FFFF           djnz    r15,%2ba8
2CA6: 9C46           .word   #%9c46
2CA8: 0801 150A      xorb    rh1,#%0a
2CAC: 1924           mult    rr4,@r2
2CAE: FFFF           djnz    r15,%2bb2
2CB0: 9E8E           .word   #%9e8e
2CB2: 0889           xorb    rl1,@r8
2CB4: 8A8B           cpb     rl3,rl0
2CB6: 2401 0908      setb    rl1,r1
2CBA: 0224           subb    rh4,@r2
2CBC: 170A           .word   #%170a
2CBE: 160C 1824 151D addl    rr12,#%1824151d
2CC4: 0D25 FFFF      ld      @r2,#%ffff
2CC8: 9F18           rsvd9f
2CCA: 0929           xor     r9,@r2
2CCC: 2A2B           decb    @r2,12
2CCE: 2C2D           exb     rl5,@r2
2CD0: 2E2F           ldb     @r2,rl7
2CD2: FFFF           djnz    r15,%2bd6
2CD4: FFFF           djnz    r15,%2bd8
2CD6: FFFF           djnz    r15,%2bda
2CD8: 210A 0400      ld      r10,#%0400
2CDC: 210B 9800      ld      r11,#%9800
2CE0: 0DB5 0824      ld      @r11,#%0824
2CE4: A9B1           inc     r11,2
2CE6: FA84           djnz    r10,%2ce0
2CE8: 9E08           ret     
2CEA: 0700 000F      and     r0,#%000f
2CEE: 0100 0008      add     r0,#%0008
2CF2: A080           ldb     rh0,rl0
2CF4: 2104 3C88      ld      r4,#%3c88
2CF8: 2105 99C4      ld      r5,#%99c4
2CFC: 2107 0003      ld      r7,#%0003
2D00: 2106 001C      ld      r6,#%001c
2D04: 2048           ldb     rl0,@r4
2D06: 2F50           ld      @r5,r0
2D08: A940           inc     r4,1
2D0A: A951           inc     r5,2
2D0C: F685           djnz    r6,%2d04
2D0E: A957           inc     r5,8
2D10: F789           djnz    r7,%2d00
2D12: 2103 9F2C      ld      r3,#%9f2c
2D16: 6100 800E      ld      r0,%800e
2D1A: 8C08           clrb    rh0
2D1C: A101           ld      r1,r0
2D1E: B301 FFFC      srl     r0,#4
2D22: 0B00 0009      cp      r0,#%0009
2D26: EA19           jr      gt,%2d5a
2D28: 2102 2D4A      ld      r2,#%2d4a
2D2C: 2105 0007      ld      r5,#%0007
2D30: DFE8           calr    %2d62
2D32: 0700 000F      and     r0,#%000f
2D36: EE01           jr      ne/nz,%2d3a
2D38: C824           ldb     rl0,#%24
2D3A: C008           ldb     rh0,#%08
2D3C: 2F30           ld      @r3,r0
2D3E: A931           inc     r3,2
2D40: 0701 000F      and     r1,#%000f
2D44: C108           ldb     rh1,#%08
2D46: 2F31           ld      @r3,r1
2D48: 9E08           ret     
2D4A: 0C1B           .word   #%0c1b
2D4C: 0E0D           ext0e   #%0d
2D4E: 121D           subl    rr13,@r1
2D50: 240F 1B0E      setb    rl3,r15
2D54: 0E24           ext0e   #%24
2D56: 1915           mult    rr5,@r1
2D58: 0A22           cpb     rh2,@r2
2D5A: 2102 2D51      ld      r2,#%2d51
2D5E: 2105 0009      ld      r5,#%0009
2D62: C408           ldb     rh4,#%08
2D64: 202C           ldb     rl4,@r2
2D66: 2F34           ld      @r3,r4
2D68: A920           inc     r2,1
2D6A: A931           inc     r3,2
2D6C: F585           djnz    r5,%2d64
2D6E: 9E08           ret     
2D70: 2104 3CDC      ld      r4,#%3cdc
2D74: 2105 9B40      ld      r5,#%9b40
2D78: 2106 0160      ld      r6,#%0160
2D7C: 2048           ldb     rl0,@r4
2D7E: A940           inc     r4,1
2D80: 8C84           testb   rl0
2D82: 9E06           ret     eq/z
2D84: 0A08 2020      cpb     rl0,#%20
2D88: E705           jr      c/ult,%2d94
2D8A: C018           ldb     rh0,#%18
2D8C: 2F50           ld      @r5,r0
2D8E: A951           inc     r5,2
2D90: F68B           djnz    r6,%2d7c
2D92: 9E08           ret     
2D94: 0D55 0824      ld      @r5,#%0824
2D98: A951           inc     r5,2
2D9A: AA80           decb    rl0,1
2D9C: E6EF           jr      eq/z,%2d7c
2D9E: F686           djnz    r6,%2d94
2DA0: 9E08           ret     
2DA2: 210C 98C6      ld      r12,#%98c6
2DA6: 5F00 2A80      call    %2a80
2DAA: 0554           or      r4,@r5
2DAC: 4F50           .word   #%4f50
2DAE: 40FF 210C      addb    rl7,%210c(r15)
2DB2: 98DC           multl   rq12,rr13
2DB4: 5F00 2A80      call    %2a80
2DB8: 0354           sub     r4,@r5
2DBA: 494D 4540      xor     r13,%4540(r4)
2DBE: 210C 9942      ld      r12,#%9942
2DC2: 5F00 2A80      call    %2a80
2DC6: 0253           subb    rh3,@r5
2DC8: 434F 5245      sub     r15,%5245(r4)
2DCC: 40FF 210C      addb    rl7,%210c(r15)
2DD0: 98EC           multl   rq12,rr14
2DD2: 5F00 2A80      call    %2a80
2DD6: 044C           orb     rl4,@r4
2DD8: 4150 2020      add     r0,%2020(r5)
2DDC: 2022           ldb     rh2,@r2
2DDE: 40FF 6100      addb    rl7,%6100(r15)
2DE2: 814E           add     r14,r4
2DE4: 0700 0001      and     r0,#%0001
2DE8: EE0C           jr      ne/nz,%2e02
2DEA: 210C 9968      ld      r12,#%9968
2DEE: 5F00 2A80      call    %2a80
2DF2: 2653           bitb    @r5,3
2DF4: 5045 4544      cpl     rr5,%4544(r4)
2DF8: 2020           ldb     rh0,@r2
2DFA: 2020           ldb     rh0,@r2
2DFC: 6B6D 40FF      dec     %40ff(r6),14
2E00: 9E08           ret     
2E02: 210C 9968      ld      r12,#%9968
2E06: 5F00 2A80      call    %2a80
2E0A: 2753           bit     @r5,3
2E0C: 5045 4544      cpl     rr5,%4544(r4)
2E10: 2020           ldb     rh0,@r2
2E12: 2020           ldb     rh0,@r2
2E14: 6B6D 40FF      dec     %40ff(r6),14
2E18: 9E08           ret     
2E1A: 210C 9BC6      ld      r12,#%9bc6
2E1E: 5F00 2A80      call    %2a80
2E22: 0846           xorb    rh6,@r4
2E24: 554A 4920      popl    %4920(r10),@r4
2E28: 5350 4545      push    @r5,%4545
2E2C: 4457 4159      orb     rh7,%4159(r5)
2E30: 40FF 210C      addb    rl7,%210c(r15)
2E34: 9C46           .word   #%9c46
2E36: 5F00 2A80      call    %2a80
2E3A: 0831           xorb    rh1,@r3
2E3C: 4C41 5020 3433 cpb     %5020(r4),#%20
2E42: 3539 4D40      ldl     rr9,r3(#%4d40)
2E46: 210C 9E8E      ld      r12,#%9e8e
2E4A: 5F00 2A80      call    %2a80
2E4E: 0878           xorb    rl0,@r7
2E50: 797A           .word   #%797a
2E52: 2031           ldb     rh1,@r3
2E54: 3938           .word   #%3938
2E56: 3220 4E41      ldb     r2(#%4e41),rh0
2E5A: 4D43           .word   #%4d43
2E5C: 4F20           .word   #%4f20
2E5E: 4C54 442E      testb   %442e(r5)
2E62: 40FF 210C      addb    rl7,%210c(r15)
2E66: 9F18           rsvd9f
2E68: 5F00 2A80      call    %2a80
2E6C: 0962           xor     r2,@r6
2E6E: 6364 6566      res     %6566(r6),4
2E72: 6768 40FF      bit     %40ff(r6),8
2E76: 9E08           ret     
2E78: DF51           calr    %2fd8
2E7A: 210C 9A0C      ld      r12,#%9a0c
2E7E: 5F00 2A80      call    %2a80
2E82: 0A45           cpb     rh5,@r4
2E84: 4E54           .word   #%4e54
2E86: 4552 2059      or      r2,%2059(r5)
2E8A: 4F55           .word   #%4f55
2E8C: 5220 494E      subl    rr0,%494e(r2)
2E90: 4954 4941      xor     r4,%4941(r5)
2E94: 4C53           .word   #%4c53
2E96: 40FF 5E08      addb    rl7,%5e08(r15)
2E9A: 2F9A           ld      @r9,r10
2E9C: DF63           calr    %2fd8
2E9E: 210C 9A06      ld      r12,#%9a06
2EA2: 5F00 2A80      call    %2a80
2EA6: 0A54           cpb     rh4,@r5
2EA8: 4845 2050      xorb    rh5,%2050(r4)
2EAC: 4153 5420      add     r3,%5420(r5)
2EB0: 3330 3020      ld      r3(#%3020),r0
2EB4: 4741 4D45      and     r1,%4d45(r4)
2EB8: 5320 5245      push    @r2,%5245
2EBC: 434F 5244      sub     r15,%5244(r4)
2EC0: 40FF 210C      addb    rl7,%210c(r15)
2EC4: 9A88           divl    rq8,rr8
2EC6: E878           jr      %2fb8
2EC8: DF79           calr    %2fd8
2ECA: 210C 9A0E      ld      r12,#%9a0e
2ECE: 5F00 2A80      call    %2a80
2ED2: 0A46           cpb     rh6,@r4
2ED4: 4153 5445      add     r3,%5445(r5)
2ED8: 5354 204C      push    @r5,%204c(r4)
2EDC: 4150 40FF      add     r0,%40ff(r5)
2EE0: 5400 A834      ldl     rr0,%a834
2EE4: B305 FFF8      srll    rr0,#8
2EE8: C00A           ldb     rh0,#%0a
2EEA: 5F00 2B70      call    %2b70
2EEE: 0DC5 0A26      ld      @r12,#%0a26
2EF2: A9C1           inc     r12,2
2EF4: 5400 A834      ldl     rr0,%a834
2EF8: 8D08           clr     r0
2EFA: 8C18           clrb    rh1
2EFC: C00A           ldb     rh0,#%0a
2EFE: 5F00 2BAC      call    %2bac
2F02: 210C 9A8A      ld      r12,#%9a8a
2F06: 5F00 2A80      call    %2a80
2F0A: 0A41           cpb     rh1,@r4
2F0C: 5645 5241      addl    rr5,%5241(r4)
2F10: 4745 2053      and     r5,%2053(r4)
2F14: 5045 4544      cpl     rr5,%4544(r4)
2F18: 2040           ldb     rh0,@r4
2F1A: 6100 814E      ld      r0,%814e
2F1E: 0700 0001      and     r0,#%0001
2F22: EE1E           jr      ne/nz,%2f60
2F24: 5400 A834      ldl     rr0,%a834
2F28: 5F00 29D6      call    %29d6
2F2C: 1402 095A 7860 ldl     rr2,#%095a7860
2F32: 9B12           div     rr2,r1
2F34: A131           ld      r1,r3
2F36: 8D08           clr     r0
2F38: 5F00 2A32      call    %2a32
2F3C: A113           ld      r3,r1
2F3E: B305 FFF8      srll    rr0,#8
2F42: C00A           ldb     rh0,#%0a
2F44: 5F00 2B70      call    %2b70
2F48: 0DC5 0A25      ld      @r12,#%0a25
2F4C: A9C1           inc     r12,2
2F4E: A131           ld      r1,r3
2F50: 8C18           clrb    rh1
2F52: 5F00 2BAC      call    %2bac
2F56: 5F00 2A80      call    %2a80
2F5A: 2E6B           ldb     @r6,rl3
2F5C: 6D40 E81D      ex      r0,%e81d(r4)
2F60: 5400 A834      ldl     rr0,%a834
2F64: 5F00 29D6      call    %29d6
2F68: 1402 05D0 2C44 ldl     rr2,#%05d02c44
2F6E: 9B12           div     rr2,r1
2F70: A131           ld      r1,r3
2F72: 8D08           clr     r0
2F74: 5F00 2A32      call    %2a32
2F78: A113           ld      r3,r1
2F7A: B305 FFF8      srll    rr0,#8
2F7E: C00A           ldb     rh0,#%0a
2F80: 5F00 2B70      call    %2b70
2F84: 0DC5 0A25      ld      @r12,#%0a25
2F88: A9C1           inc     r12,2
2F8A: A131           ld      r1,r3
2F8C: 8C18           clrb    rh1
2F8E: 5F00 2BAC      call    %2bac
2F92: 5F00 2A80      call    %2a80
2F96: 2F6B           ld      @r6,r11
2F98: 6D40 210C      ex      r0,%210c(r4)
2F9C: 9B10           div     rr0,r1
2F9E: 5F00 2A80      call    %2a80
2FA2: 0A3C           cpb     rl4,@r3
2FA4: 5052 495A      cpl     rr2,%495a(r5)
2FA8: 4520 5749      or      r0,%5749(r2)
2FAC: 4E4E           .word   #%4e4e
2FAE: 4552 533E      or      r2,%533e(r5)
2FB2: 40FF 210C      addb    rl7,%210c(r15)
2FB6: 9B88           div     rr8,r8
2FB8: 5F00 2A80      call    %2a80
2FBC: 0A4E           cpb     rl6,@r4
2FBE: 4F2E           .word   #%4f2e
2FC0: 2020           ldb     rh0,@r2
2FC2: 5343 4F52      push    @r4,%4f52(r3)
2FC6: 4520 2020      or      r0,%2020(r2)
2FCA: 5449 4D45      ldl     rr9,%4d45(r4)
2FCE: 2020           ldb     rh0,@r2
2FD0: 204E           ldb     rl6,@r4
2FD2: 414D 4540      add     r13,%4540(r4)
2FD6: 9E08           ret     
2FD8: 210B 9880      ld      r11,#%9880
2FDC: 210A 0020      ld      r10,#%0020
2FE0: 2100 0A24      ld      r0,#%0a24
2FE4: 2FB0           ld      @r11,r0
2FE6: 6FB0 0080      ld      %0080(r11),r0
2FEA: A9B1           inc     r11,2
2FEC: FA85           djnz    r10,%2fe4
2FEE: 210A 000C      ld      r10,#%000c
2FF2: 2100 2B2D      ld      r0,#%2b2d
2FF6: 2101 2A2C      ld      r1,#%2a2c
2FFA: 6102 814E      ld      r2,%814e
2FFE: 0702 0001      and     r2,#%0001
3002: 0102 002E      add     r2,#%002e
3006: 2EB8           ldb     @r11,rl0
3008: 6EB0 0010      ldb     %0010(r11),rh0
300C: 6EB9 0028      ldb     %0028(r11),rl1
3010: 6EB1 0080      ldb     %0080(r11),rh1
3014: 6EB0 0090      ldb     %0090(r11),rh0
3018: 6EBA 00A8      ldb     %00a8(r11),rl2
301C: A9B1           inc     r11,2
301E: FA8D           djnz    r10,%3006
3020: 210B 9980      ld      r11,#%9980
3024: 2100 0A24      ld      r0,#%0a24
3028: 210A 0300      ld      r10,#%0300
302C: 2FB0           ld      @r11,r0
302E: A9B1           inc     r11,2
3030: FA83           djnz    r10,%302c
3032: 9E08           ret     
3034: D02F           calr    %2fd8
3036: 210C 9A0C      ld      r12,#%9a0c
303A: 5F00 2A80      call    %2a80
303E: 0A45           cpb     rh5,@r4
3040: 4E54           .word   #%4e54
3042: 4552 2059      or      r2,%2059(r5)
3046: 4F55           .word   #%4f55
3048: 5220 494E      subl    rr0,%494e(r2)
304C: 4954 4941      xor     r4,%4941(r5)
3050: 4C53           .word   #%4c53
3052: 40FF 210C      addb    rl7,%210c(r15)
3056: 9A88           divl    rq8,rr8
3058: E8AF           jr      %2fb8
305A: 210A 0400      ld      r10,#%0400
305E: 210B 9800      ld      r11,#%9800
3062: 0DB5 0A24      ld      @r11,#%0a24
3066: A9B1           inc     r11,2
3068: FA84           djnz    r10,%3062
306A: 210C 9C10      ld      r12,#%9c10
306E: 5F00 2A80      call    %2a80
3072: 0A50           cpb     rh0,@r5
3074: 5553 4820      popl    %4820(r3),@r5
3078: 5354 4152      push    @r5,%4152(r4)
307C: 5420 4255      ldl     rr0,%4255(r2)
3080: 5454 4F4E      ldl     rr4,%4f4e(r5)
3084: 40FF 9E08      addb    rl7,%9e08(r15)
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
3300: FFFF           djnz    r15,%3204
3302: FFFF           djnz    r15,%3206
3304: FFFF           djnz    r15,%3208
3306: FFFF           djnz    r15,%320a
3308: FFFF           djnz    r15,%320c
330A: FFFF           djnz    r15,%320e
330C: FFFF           djnz    r15,%3210
330E: FFFF           djnz    r15,%3212
3310: FFFF           djnz    r15,%3214
3312: FFFF           djnz    r15,%3216
3314: FFFF           djnz    r15,%3218
3316: FFFF           djnz    r15,%321a
3318: FFFF           djnz    r15,%321c
331A: FFFF           djnz    r15,%321e
331C: FFFF           djnz    r15,%3220
331E: FFFF           djnz    r15,%3222
3320: FFFF           djnz    r15,%3224
3322: FFFF           djnz    r15,%3226
3324: FFFF           djnz    r15,%3228
3326: FFFF           djnz    r15,%322a
3328: FFFF           djnz    r15,%322c
332A: FFFF           djnz    r15,%322e
332C: FFFF           djnz    r15,%3230
332E: FFFF           djnz    r15,%3232
3330: FFFF           djnz    r15,%3234
3332: FFFF           djnz    r15,%3236
3334: FFFF           djnz    r15,%3238
3336: FFFF           djnz    r15,%323a
3338: FFFF           djnz    r15,%323c
333A: FFFF           djnz    r15,%323e
333C: FFFF           djnz    r15,%3240
333E: FFFF           djnz    r15,%3242
3340: FFFF           djnz    r15,%3244
3342: FFFF           djnz    r15,%3246
3344: FFFF           djnz    r15,%3248
3346: FFFF           djnz    r15,%324a
3348: FFFF           djnz    r15,%324c
334A: FFFF           djnz    r15,%324e
334C: FFFF           djnz    r15,%3250
334E: FFFF           djnz    r15,%3252
3350: FFFF           djnz    r15,%3254
3352: FFFF           djnz    r15,%3256
3354: FFFF           djnz    r15,%3258
3356: FFFF           djnz    r15,%325a
3358: FFFF           djnz    r15,%325c
335A: FFFF           djnz    r15,%325e
335C: FFFF           djnz    r15,%3260
335E: FFFF           djnz    r15,%3262
3360: FFFF           djnz    r15,%3264
3362: FFFF           djnz    r15,%3266
3364: FFFF           djnz    r15,%3268
3366: FFFF           djnz    r15,%326a
3368: FFFF           djnz    r15,%326c
336A: FFFF           djnz    r15,%326e
336C: FFFF           djnz    r15,%3270
336E: FFFF           djnz    r15,%3272
3370: FFFF           djnz    r15,%3274
3372: FFFF           djnz    r15,%3276
3374: FFFF           djnz    r15,%3278
3376: FFFF           djnz    r15,%327a
3378: FFFF           djnz    r15,%327c
337A: FFFF           djnz    r15,%327e
337C: FFFF           djnz    r15,%3280
337E: FFFF           djnz    r15,%3282
3380: FFFF           djnz    r15,%3284
3382: FFFF           djnz    r15,%3286
3384: FFFF           djnz    r15,%3288
3386: FFFF           djnz    r15,%328a
3388: FFFF           djnz    r15,%328c
338A: FFFF           djnz    r15,%328e
338C: FFFF           djnz    r15,%3290
338E: FFFF           djnz    r15,%3292
3390: FFFF           djnz    r15,%3294
3392: FFFF           djnz    r15,%3296
3394: FFFF           djnz    r15,%3298
3396: FFFF           djnz    r15,%329a
3398: FFFF           djnz    r15,%329c
339A: FFFF           djnz    r15,%329e
339C: FFFF           djnz    r15,%32a0
339E: FFFF           djnz    r15,%32a2
33A0: FFFF           djnz    r15,%32a4
33A2: FFFF           djnz    r15,%32a6
33A4: FFFF           djnz    r15,%32a8
33A6: FFFF           djnz    r15,%32aa
33A8: FFFF           djnz    r15,%32ac
33AA: FFFF           djnz    r15,%32ae
33AC: FFFF           djnz    r15,%32b0
33AE: FFFF           djnz    r15,%32b2
33B0: FFFF           djnz    r15,%32b4
33B2: FFFF           djnz    r15,%32b6
33B4: FFFF           djnz    r15,%32b8
33B6: FFFF           djnz    r15,%32ba
33B8: FFFF           djnz    r15,%32bc
33BA: FFFF           djnz    r15,%32be
33BC: FFFF           djnz    r15,%32c0
33BE: FFFF           djnz    r15,%32c2
33C0: FFFF           djnz    r15,%32c4
33C2: FFFF           djnz    r15,%32c6
33C4: FFFF           djnz    r15,%32c8
33C6: FFFF           djnz    r15,%32ca
33C8: FFFF           djnz    r15,%32cc
33CA: FFFF           djnz    r15,%32ce
33CC: FFFF           djnz    r15,%32d0
33CE: FFFF           djnz    r15,%32d2
33D0: FFFF           djnz    r15,%32d4
33D2: FFFF           djnz    r15,%32d6
33D4: FFFF           djnz    r15,%32d8
33D6: FFFF           djnz    r15,%32da
33D8: FFFF           djnz    r15,%32dc
33DA: FFFF           djnz    r15,%32de
33DC: FFFF           djnz    r15,%32e0
33DE: FFFF           djnz    r15,%32e2
33E0: FFFF           djnz    r15,%32e4
33E2: FFFF           djnz    r15,%32e6
33E4: FFFF           djnz    r15,%32e8
33E6: FFFF           djnz    r15,%32ea
33E8: FFFF           djnz    r15,%32ec
33EA: FFFF           djnz    r15,%32ee
33EC: FFFF           djnz    r15,%32f0
33EE: FFFF           djnz    r15,%32f2
33F0: FFFF           djnz    r15,%32f4
33F2: FFFF           djnz    r15,%32f6
33F4: FFFF           djnz    r15,%32f8
33F6: FFFF           djnz    r15,%32fa
33F8: FFFF           djnz    r15,%32fc
33FA: FFFF           djnz    r15,%32fe
33FC: FFFF           djnz    r15,%3300
33FE: FFFF           djnz    r15,%3302
3400: FFFF           djnz    r15,%3304
3402: FFFF           djnz    r15,%3306
3404: FFFF           djnz    r15,%3308
3406: FFFF           djnz    r15,%330a
3408: FFFF           djnz    r15,%330c
340A: FFFF           djnz    r15,%330e
340C: FFFF           djnz    r15,%3310
340E: FFFF           djnz    r15,%3312
3410: FFFF           djnz    r15,%3314
3412: FFFF           djnz    r15,%3316
3414: FFFF           djnz    r15,%3318
3416: FFFF           djnz    r15,%331a
3418: FFFF           djnz    r15,%331c
341A: FFFF           djnz    r15,%331e
341C: FFFF           djnz    r15,%3320
341E: FFFF           djnz    r15,%3322
3420: FFFF           djnz    r15,%3324
3422: FFFF           djnz    r15,%3326
3424: FFFF           djnz    r15,%3328
3426: FFFF           djnz    r15,%332a
3428: FFFF           djnz    r15,%332c
342A: FFFF           djnz    r15,%332e
342C: FFFF           djnz    r15,%3330
342E: FFFF           djnz    r15,%3332
3430: FFFF           djnz    r15,%3334
3432: FFFF           djnz    r15,%3336
3434: FFFF           djnz    r15,%3338
3436: FFFF           djnz    r15,%333a
3438: FFFF           djnz    r15,%333c
343A: FFFF           djnz    r15,%333e
343C: FFFF           djnz    r15,%3340
343E: FFFF           djnz    r15,%3342
3440: FFFF           djnz    r15,%3344
3442: FFFF           djnz    r15,%3346
3444: FFFF           djnz    r15,%3348
3446: FFFF           djnz    r15,%334a
3448: FFFF           djnz    r15,%334c
344A: FFFF           djnz    r15,%334e
344C: FFFF           djnz    r15,%3350
344E: FFFF           djnz    r15,%3352
3450: FFFF           djnz    r15,%3354
3452: FFFF           djnz    r15,%3356
3454: FFFF           djnz    r15,%3358
3456: FFFF           djnz    r15,%335a
3458: FFFF           djnz    r15,%335c
345A: FFFF           djnz    r15,%335e
345C: FFFF           djnz    r15,%3360
345E: FFFF           djnz    r15,%3362
3460: FFFF           djnz    r15,%3364
3462: FFFF           djnz    r15,%3366
3464: FFFF           djnz    r15,%3368
3466: FFFF           djnz    r15,%336a
3468: FFFF           djnz    r15,%336c
346A: FFFF           djnz    r15,%336e
346C: FFFF           djnz    r15,%3370
346E: FFFF           djnz    r15,%3372
3470: FFFF           djnz    r15,%3374
3472: FFFF           djnz    r15,%3376
3474: FFFF           djnz    r15,%3378
3476: FFFF           djnz    r15,%337a
3478: FFFF           djnz    r15,%337c
347A: FFFF           djnz    r15,%337e
347C: FFFF           djnz    r15,%3380
347E: FFFF           djnz    r15,%3382
3480: FFFF           djnz    r15,%3384
3482: FFFF           djnz    r15,%3386
3484: FFFF           djnz    r15,%3388
3486: FFFF           djnz    r15,%338a
3488: FFFF           djnz    r15,%338c
348A: FFFF           djnz    r15,%338e
348C: FFFF           djnz    r15,%3390
348E: FFFF           djnz    r15,%3392
3490: FFFF           djnz    r15,%3394
3492: FFFF           djnz    r15,%3396
3494: FFFF           djnz    r15,%3398
3496: FFFF           djnz    r15,%339a
3498: FFFF           djnz    r15,%339c
349A: FFFF           djnz    r15,%339e
349C: FFFF           djnz    r15,%33a0
349E: FFFF           djnz    r15,%33a2
34A0: FFFF           djnz    r15,%33a4
34A2: FFFF           djnz    r15,%33a6
34A4: FFFF           djnz    r15,%33a8
34A6: FFFF           djnz    r15,%33aa
34A8: FFFF           djnz    r15,%33ac
34AA: FFFF           djnz    r15,%33ae
34AC: FFFF           djnz    r15,%33b0
34AE: FFFF           djnz    r15,%33b2
34B0: FFFF           djnz    r15,%33b4
34B2: FFFF           djnz    r15,%33b6
34B4: FFFF           djnz    r15,%33b8
34B6: FFFF           djnz    r15,%33ba
34B8: FFFF           djnz    r15,%33bc
34BA: FFFF           djnz    r15,%33be
34BC: FFFF           djnz    r15,%33c0
34BE: FFFF           djnz    r15,%33c2
34C0: FFFF           djnz    r15,%33c4
34C2: FFFF           djnz    r15,%33c6
34C4: FFFF           djnz    r15,%33c8
34C6: FFFF           djnz    r15,%33ca
34C8: FFFF           djnz    r15,%33cc
34CA: FFFF           djnz    r15,%33ce
34CC: FFFF           djnz    r15,%33d0
34CE: FFFF           djnz    r15,%33d2
34D0: FFFF           djnz    r15,%33d4
34D2: FFFF           djnz    r15,%33d6
34D4: FFFF           djnz    r15,%33d8
34D6: FFFF           djnz    r15,%33da
34D8: FFFF           djnz    r15,%33dc
34DA: FFFF           djnz    r15,%33de
34DC: FFFF           djnz    r15,%33e0
34DE: FFFF           djnz    r15,%33e2
34E0: FFFF           djnz    r15,%33e4
34E2: FFFF           djnz    r15,%33e6
34E4: FFFF           djnz    r15,%33e8
34E6: FFFF           djnz    r15,%33ea
34E8: FFFF           djnz    r15,%33ec
34EA: FFFF           djnz    r15,%33ee
34EC: FFFF           djnz    r15,%33f0
34EE: FFFF           djnz    r15,%33f2
34F0: FFFF           djnz    r15,%33f4
34F2: FFFF           djnz    r15,%33f6
34F4: FFFF           djnz    r15,%33f8
34F6: FFFF           djnz    r15,%33fa
34F8: FFFF           djnz    r15,%33fc
34FA: FFFF           djnz    r15,%33fe
34FC: FFFF           djnz    r15,%3400
34FE: FFFF           djnz    r15,%3402
3500: FFFF           djnz    r15,%3404
3502: FFFF           djnz    r15,%3406
3504: FFFF           djnz    r15,%3408
3506: FFFF           djnz    r15,%340a
3508: FFFF           djnz    r15,%340c
350A: FFFF           djnz    r15,%340e
350C: FFFF           djnz    r15,%3410
350E: FFFF           djnz    r15,%3412
3510: FFFF           djnz    r15,%3414
3512: FFFF           djnz    r15,%3416
3514: FFFF           djnz    r15,%3418
3516: FFFF           djnz    r15,%341a
3518: FFFF           djnz    r15,%341c
351A: FFFF           djnz    r15,%341e
351C: FFFF           djnz    r15,%3420
351E: FFFF           djnz    r15,%3422
3520: FFFF           djnz    r15,%3424
3522: FFFF           djnz    r15,%3426
3524: FFFF           djnz    r15,%3428
3526: FFFF           djnz    r15,%342a
3528: FFFF           djnz    r15,%342c
352A: FFFF           djnz    r15,%342e
352C: FFFF           djnz    r15,%3430
352E: FFFF           djnz    r15,%3432
3530: FFFF           djnz    r15,%3434
3532: FFFF           djnz    r15,%3436
3534: FFFF           djnz    r15,%3438
3536: FFFF           djnz    r15,%343a
3538: FFFF           djnz    r15,%343c
353A: FFFF           djnz    r15,%343e
353C: FFFF           djnz    r15,%3440
353E: FFFF           djnz    r15,%3442
3540: FFFF           djnz    r15,%3444
3542: FFFF           djnz    r15,%3446
3544: FFFF           djnz    r15,%3448
3546: FFFF           djnz    r15,%344a
3548: FFFF           djnz    r15,%344c
354A: FFFF           djnz    r15,%344e
354C: FFFF           djnz    r15,%3450
354E: FFFF           djnz    r15,%3452
3550: FFFF           djnz    r15,%3454
3552: FFFF           djnz    r15,%3456
3554: FFFF           djnz    r15,%3458
3556: FFFF           djnz    r15,%345a
3558: FFFF           djnz    r15,%345c
355A: FFFF           djnz    r15,%345e
355C: FFFF           djnz    r15,%3460
355E: FFFF           djnz    r15,%3462
3560: FFFF           djnz    r15,%3464
3562: FFFF           djnz    r15,%3466
3564: FFFF           djnz    r15,%3468
3566: FFFF           djnz    r15,%346a
3568: FFFF           djnz    r15,%346c
356A: FFFF           djnz    r15,%346e
356C: FFFF           djnz    r15,%3470
356E: FFFF           djnz    r15,%3472
3570: FFFF           djnz    r15,%3474
3572: FFFF           djnz    r15,%3476
3574: FFFF           djnz    r15,%3478
3576: FFFF           djnz    r15,%347a
3578: FFFF           djnz    r15,%347c
357A: FFFF           djnz    r15,%347e
357C: FFFF           djnz    r15,%3480
357E: FFFF           djnz    r15,%3482
3580: FFFF           djnz    r15,%3484
3582: FFFF           djnz    r15,%3486
3584: FFFF           djnz    r15,%3488
3586: FFFF           djnz    r15,%348a
3588: FFFF           djnz    r15,%348c
358A: FFFF           djnz    r15,%348e
358C: FFFF           djnz    r15,%3490
358E: FFFF           djnz    r15,%3492
3590: FFFF           djnz    r15,%3494
3592: FFFF           djnz    r15,%3496
3594: FFFF           djnz    r15,%3498
3596: FFFF           djnz    r15,%349a
3598: FFFF           djnz    r15,%349c
359A: FFFF           djnz    r15,%349e
359C: FFFF           djnz    r15,%34a0
359E: FFFF           djnz    r15,%34a2
35A0: FFFF           djnz    r15,%34a4
35A2: FFFF           djnz    r15,%34a6
35A4: FFFF           djnz    r15,%34a8
35A6: FFFF           djnz    r15,%34aa
35A8: FFFF           djnz    r15,%34ac
35AA: FFFF           djnz    r15,%34ae
35AC: FFFF           djnz    r15,%34b0
35AE: FFFF           djnz    r15,%34b2
35B0: FFFF           djnz    r15,%34b4
35B2: FFFF           djnz    r15,%34b6
35B4: FFFF           djnz    r15,%34b8
35B6: FFFF           djnz    r15,%34ba
35B8: FFFF           djnz    r15,%34bc
35BA: FFFF           djnz    r15,%34be
35BC: FFFF           djnz    r15,%34c0
35BE: FFFF           djnz    r15,%34c2
35C0: FFFF           djnz    r15,%34c4
35C2: FFFF           djnz    r15,%34c6
35C4: FFFF           djnz    r15,%34c8
35C6: FFFF           djnz    r15,%34ca
35C8: FFFF           djnz    r15,%34cc
35CA: FFFF           djnz    r15,%34ce
35CC: FFFF           djnz    r15,%34d0
35CE: FFFF           djnz    r15,%34d2
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
3FFE: 0599           or      r9,@r9
