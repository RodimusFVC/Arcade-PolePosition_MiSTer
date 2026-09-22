0000: 0000           .word   #%0000 ;RST
0002: 4000           .word   #%4000 ;RST FCW
0004: 3280           .word   #%3280 ;RST PC
0006: 210F 8700      ld      r15,#%8700
000A: 2100 0100      ld      r0,#%0100
000E: 7D0D           ldctl   psapoff,r0
0010: 8D08           clr     r0
0012: 7D0B           ldctl   refresh,r0
0014: 6101 800E      ld      r1,%800e
0018: DEA3           calr    %02d4
001A: 6F01 81AA      ld      %81aa,r1
001E: 4D08 810A      clr     %810a
0022: 4D08 810C      clr     %810c
0026: 4D08 8010      clr     %8010
002A: 4D05 6000 0001 ld      %6000,#%0001
0030: 7C06           ei      nvi
0032: E874           jr      %011c
0034: FFFF           djnz    r15,%ffffff38
0036: FFFF           djnz    r15,%ffffff3a
0038: FFFF           djnz    r15,%ffffff3c
003A: FFFF           djnz    r15,%ffffff3e
003C: FFFF           djnz    r15,%ffffff40
003E: FFFF           djnz    r15,%ffffff42
0040: FFFF           djnz    r15,%ffffff44
0042: FFFF           djnz    r15,%ffffff46
0044: FFFF           djnz    r15,%ffffff48
0046: FFFF           djnz    r15,%ffffff4a
0048: FFFF           djnz    r15,%ffffff4c
004A: FFFF           djnz    r15,%ffffff4e
004C: FFFF           djnz    r15,%ffffff50
004E: FFFF           djnz    r15,%ffffff52
0050: FFFF           djnz    r15,%ffffff54
0052: FFFF           djnz    r15,%ffffff56
0054: FFFF           djnz    r15,%ffffff58
0056: FFFF           djnz    r15,%ffffff5a
0058: FFFF           djnz    r15,%ffffff5c
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
0104: 4000 3280      addb    rh0,%3280
0108: 4000 3280      addb    rh0,%3280
010C: 4000 3280      addb    rh0,%3280
0110: 0000 0000      addb    rh0,#%00
0114: 4000 3280      addb    rh0,%3280
0118: 4000 02EA      addb    rh0,%02ea
011C: 6103 8188      ld      r3,%8188
0120: B12A           exts    rr2
0122: 9420           ldl     rr0,rr2
0124: 9622           addl    rr2,rr2
0126: 9622           addl    rr2,rr2
0128: 9602           addl    rr2,rr0
012A: 9420           ldl     rr0,rr2
012C: 9600           addl    rr0,rr0
012E: 9600           addl    rr0,rr0
0130: 0100 0080      add     r0,#%0080
0134: 2104 8300      ld      r4,#%8300
0138: 2105 0010      ld      r5,#%0010
013C: 9620           addl    rr0,rr2
013E: 2F40           ld      @r4,r0
0140: A941           inc     r4,2
0142: 9620           addl    rr0,rr2
0144: 2F40           ld      @r4,r0
0146: A941           inc     r4,2
0148: 9620           addl    rr0,rr2
014A: 2F40           ld      @r4,r0
014C: A941           inc     r4,2
014E: 9620           addl    rr0,rr2
0150: 2F40           ld      @r4,r0
0152: A941           inc     r4,2
0154: 9620           addl    rr0,rr2
0156: 2F40           ld      @r4,r0
0158: A941           inc     r4,2
015A: 9620           addl    rr0,rr2
015C: 2F40           ld      @r4,r0
015E: A941           inc     r4,2
0160: 9620           addl    rr0,rr2
0162: 2F40           ld      @r4,r0
0164: A941           inc     r4,2
0166: 9620           addl    rr0,rr2
0168: 2F40           ld      @r4,r0
016A: A941           inc     r4,2
016C: 9620           addl    rr0,rr2
016E: 2F40           ld      @r4,r0
0170: A941           inc     r4,2
0172: 9620           addl    rr0,rr2
0174: 2F40           ld      @r4,r0
0176: A941           inc     r4,2
0178: AB50           dec     r5,1
017A: EEE0           jr      ne/nz,%013c
017C: 210A 83DE      ld      r10,#%83de
0180: 210B 97E0      ld      r11,#%97e0
0184: 210C 85E0      ld      r12,#%85e0
0188: 210D 36DE      ld      r13,#%36de
018C: 6101 801C      ld      r1,%801c
0190: 0701 0003      and     r1,#%0003
0194: A091           ldb     rh1,rl1
0196: 8C98           clrb    rl1
0198: 0101 36E0      add     r1,#%36e0
019C: A11E           ld      r14,r1
019E: 6100 8184      ld      r0,%8184
01A2: 8D18           clr     r1
01A4: A116           ld      r6,r1
01A6: A167           ld      r7,r6
01A8: 9468           ldl     rr8,rr6
01AA: 21D3           ld      r3,@r13
01AC: ABD1           dec     r13,2
01AE: 8103           add     r3,r0
01B0: A039           ldb     rl1,rh3
01B2: 2103 2000      ld      r3,#%2000
01B6: 70EB 0100      ldb     rl3,r14(r1)
01BA: 8133           add     r3,r3
01BC: 2102 2100      ld      r2,#%2100
01C0: 600A 3BEF      ldb     rl2,%3bef
01C4: 8122           add     r2,r2
01C6: 203B           ldb     rl3,@r3
01C8: 2023           ldb     rh3,@r2
01CA: 2104 006F      ld      r4,#%006f
01CE: 21D3           ld      r3,@r13
01D0: ABD1           dec     r13,2
01D2: 8103           add     r3,r0
01D4: A039           ldb     rl1,rh3
01D6: 2103 2000      ld      r3,#%2000
01DA: 70EB 0100      ldb     rl3,r14(r1)
01DE: 8133           add     r3,r3
01E0: 2102 2100      ld      r2,#%2100
01E4: 604A 3B7F      ldb     rl2,%3b7f(r4)
01E8: 8122           add     r2,r2
01EA: 203B           ldb     rl3,@r3
01EC: 2023           ldb     rh3,@r2
01EE: B12A           exts    rr2
01F0: 9628           addl    rr8,rr2
01F2: 9686           addl    rr6,rr8
01F4: 9482           ldl     rr2,rr8
01F6: B32D FFFC      sral    rr2,#4
01FA: 93C3           push    @r12,r3
01FC: A0E3           ldb     rh3,rl6
01FE: A07B           ldb     rl3,rh7
0200: B339 FFFC      sra     r3,#4
0204: 01A3           add     r3,@r10
0206: 93B3           push    @r11,r3
0208: ABA1           dec     r10,2
020A: AB40           dec     r4,1
020C: EEE0           jr      ne/nz,%01ce
020E: 600B 4000      ldb     rl3,%4000
0212: 6003 4200      ldb     rh3,%4200
0216: B12A           exts    rr2
0218: 9628           addl    rr8,rr2
021A: 9628           addl    rr8,rr2
021C: 9686           addl    rr6,rr8
021E: 9482           ldl     rr2,rr8
0220: B32D FFFC      sral    rr2,#4
0224: 93C3           push    @r12,r3
0226: A0E3           ldb     rh3,rl6
0228: A07B           ldb     rl3,rh7
022A: B339 FFFC      sra     r3,#4
022E: 01A3           add     r3,@r10
0230: 93B3           push    @r11,r3
0232: 6106 8100      ld      r6,%8100
0236: 0106 ABCD      add     r6,#%abcd
023A: 2104 2000      ld      r4,#%2000
023E: 2105 2100      ld      r5,#%2100
0242: A0EC           ldb     rl4,rl6
0244: A06D           ldb     rl5,rh6
0246: 8144           add     r4,r4
0248: 8155           add     r5,r5
024A: 204B           ldb     rl3,@r4
024C: 2053           ldb     rh3,@r5
024E: A0E9           ldb     rl1,rl6
0250: A06B           ldb     rl3,rh6
0252: B110           extsb   r1
0254: 8C38           clrb    rh3
0256: 9930           mult    rr0,r3
0258: 2104 2000      ld      r4,#%2000
025C: 2105 2100      ld      r5,#%2100
0260: A0EC           ldb     rl4,rl6
0262: A06D           ldb     rl5,rh6
0264: 8144           add     r4,r4
0266: 8155           add     r5,r5
0268: 204B           ldb     rl3,@r4
026A: 2053           ldb     rh3,@r5
026C: 8B13           cp      r3,r1
026E: 5E06 011C      jp      eq/z,%011c
0272: 5F00 2704      call    %2704
0276: 210B 9904      ld      r11,#%9904
027A: 210A 028E      ld      r10,#%028e
027E: C108           ldb     rh1,#%08
0280: 20A9           ldb     rl1,@r10
0282: A717           bit     r1,7
0284: EE0F           jr      ne/nz,%02a4
0286: 2FB1           ld      @r11,r1
0288: A9A0           inc     r10,1
028A: A9B1           inc     r11,2
028C: E8F9           jr      %0280
028E: 0E1B           ext0e   #%1b
0290: 1B18           div     rr8,@r1
0292: 1B24           div     rr4,@r2
0294: 120C 0205 2424 subl    rr12,#%02052424
029A: 2B24           dec     @r2,5
029C: 170A           .word   #%170a
029E: 160C 1824 FFFF addl    rr12,#%1824ffff
02A4: 5F00 34D6      call    %34d6
02A8: 5F00 3532      call    %3532
02AC: 2100 0014      ld      r0,#%0014
02B0: 93F0           push    @r15,r0
02B2: 5F00 2704      call    %2704
02B6: 97F0           pop     r0,@r15
02B8: F085           djnz    r0,%02b0
02BA: 4D08 8014      clr     %8014
02BE: 5F00 2704      call    %2704
02C2: 4D08 8012      clr     %8012
02C6: 5F00 2704      call    %2704
02CA: 2100 1234      ld      r0,#%1234
02CE: 7D0D           ldctl   psapoff,r0
02D0: 5E08 011C      jp      %011c
02D4: A112           ld      r2,r1
02D6: 0702 000F      and     r2,#%000f
02DA: B311 FFFC      srl     r1,#4
02DE: 0701 000F      and     r1,#%000f
02E2: 1900 000A      mult    rr0,#%000a
02E6: 8121           add     r1,r2
02E8: 9E08           ret     
02EA: 5C09 000E 8110 ldm     %8110,r0,#15
02F0: 4D08 6000      clr     %6000
02F4: 4D08 82BC      clr     %82bc
02F8: 5F00 2F4E      call    %2f4e
02FC: 4D01 8010 8001 cp      %8010,#%8001
0302: E63A           jr      eq/z,%0378
0304: 6900 8100      inc     %8100,1
0308: 6100 8100      ld      r0,%8100
030C: 0700 0007      and     r0,#%0007
0310: 6F00 8102      ld      %8102,r0
0314: 6101 800E      ld      r1,%800e
0318: 6104 81AA      ld      r4,%81aa
031C: D025           calr    %02d4
031E: 6F01 81AA      ld      %81aa,r1
0322: 8314           sub     r4,r1
0324: ED08           jr      pl,%0336
0326: 8D42           neg     r4
0328: 0B04 0007      cp      r4,#%0007
032C: E904           jr      ge,%0336
032E: 4104 810C      add     r4,%810c
0332: 6F04 810C      ld      %810c,r4
0336: 4D04 810A      test    %810a
033A: EE0B           jr      ne/nz,%0352
033C: 4D04 810C      test    %810c
0340: E60A           jr      eq/z,%0356
0342: 4D05 810A 003C ld      %810a,#%003c
0348: 6B00 810C      dec     %810c,1
034C: 6500 80EC      set     %80ec,0
0350: E802           jr      %0356
0352: 6B00 810A      dec     %810a,1
0356: 6101 8012      ld      r1,%8012
035A: 0701 0007      and     r1,#%0007
035E: 8111           add     r1,r1
0360: 6111 0468      ld      r1,%0468(r1)
0364: 6102 8014      ld      r2,%8014
0368: 0702 001F      and     r2,#%001f
036C: 8122           add     r2,r2
036E: 7111 0200      ld      r1,r1(r2)
0372: 1F10           call    r1
0374: DFE8           calr    %03a6
0376: DFF9           calr    %0386
0378: 5C01 000E 8110 ldm     r0,%8110,#15
037E: 4D05 6000 0001 ld      %6000,#%0001
0384: 7B00           iret
0386: 6B00 A9C4      dec     %a9c4,1
038A: 9E0E           ret     ne/nz
038C: 4D05 A9C4 003C ld      %a9c4,#%003c
0392: 5400 A9C0      ldl     rr0,%a9c0
0396: 2103 0001      ld      r3,#%0001
039A: 8D28           clr     r2
039C: 5F00 2094      call    %2094
03A0: 5D00 A9C0      ldl     %a9c0,rr0
03A4: 9E08           ret     
03A6: 4D04 82C2      test    %82c2
03AA: EE13           jr      ne/nz,%03d2
03AC: 4D04 82C4      test    %82c4
03B0: EE29           jr      ne/nz,%0404
03B2: 4D04 82C6      test    %82c6
03B6: EE3F           jr      ne/nz,%0436
03B8: 4D05 82C2 0000 ld      %82c2,#%0000
03BE: 4D05 82C4 0000 ld      %82c4,#%0000
03C4: 4D05 82C6 0000 ld      %82c6,#%0000
03CA: 4D05 82C0 0000 ld      %82c0,#%0000
03D0: 9E08           ret     
03D2: 4D01 82C2 0001 cp      %82c2,#%0001
03D8: E60E           jr      eq/z,%03f6
03DA: 4D01 82C2 0002 cp      %82c2,#%0002
03E0: E6EB           jr      eq/z,%03b8
03E2: 6B00 82C2      dec     %82c2,1
03E6: 4D01 82C2 00D2 cp      %82c2,#%00d2
03EC: 9E0E           ret     ne/nz
03EE: 4D05 82C8 0001 ld      %82c8,#%0001
03F4: 9E08           ret     
03F6: 4D05 82C2 00F0 ld      %82c2,#%00f0
03FC: 4D05 82C0 0003 ld      %82c0,#%0003
0402: 9E08           ret     
0404: 4D01 82C4 0001 cp      %82c4,#%0001
040A: E60E           jr      eq/z,%0428
040C: 4D01 82C4 0002 cp      %82c4,#%0002
0412: E6D2           jr      eq/z,%03b8
0414: 6B00 82C4      dec     %82c4,1
0418: 4D01 82C4 00A0 cp      %82c4,#%00a0
041E: 9E0E           ret     ne/nz
0420: 4D05 82CA 0001 ld      %82ca,#%0001
0426: 9E08           ret     
0428: 4D05 82C4 00FA ld      %82c4,#%00fa
042E: 4D05 82C0 0003 ld      %82c0,#%0003
0434: 9E08           ret     
0436: 4D01 82C6 0001 cp      %82c6,#%0001
043C: E60E           jr      eq/z,%045a
043E: 4D01 82C6 0002 cp      %82c6,#%0002
0444: E6B9           jr      eq/z,%03b8
0446: 6B00 82C6      dec     %82c6,1
044A: 4D01 82C6 0122 cp      %82c6,#%0122
0450: 9E0E           ret     ne/nz
0452: 4D05 82CC 0001 ld      %82cc,#%0001
0458: 9E08           ret     
045A: 4D05 82C6 012C ld      %82c6,#%012c
0460: 4D05 82C0 0003 ld      %82c0,#%0003
0466: 9E08           ret     
0468: 0472           orb     rh2,@r7
046A: 0478           orb     rl0,@r7
046C: 048C           orb     rl4,@r8
046E: 0490           orb     rh0,@r9
0470: 04B0           orb     rh0,@r11
0472: 0542           or      r2,@r4
0474: 05F6           or      r6,@r15
0476: 0612           andb    rh2,@r1
0478: 0626           andb    rh6,@r2
047A: 0648           andb    rl0,@r4
047C: 067E           andb    rl6,@r7
047E: 0692           andb    rh2,@r9
0480: 06FE           andb    rl6,@r15
0482: 0716           and     r6,@r1
0484: 077A           and     r10,@r7
0486: 07B0           and     r0,@r11
0488: 082E           xorb    rl6,@r2
048A: 084A           xorb    rl2,@r4
048C: 0960           xor     r0,@r6
048E: 09AA           xor     r10,@r10
0490: 0A84           cpb     rh4,@r8
0492: 0B72           cp      r2,@r7
0494: 0CD4           testb   @r13
0496: 0D1E           .word   #%0d1e
0498: 0DB0           com     @r11
049A: 0EF4           ext0e   #%f4
049C: 0F42           ext0f   #%42
049E: 0FEA           ext0f   #%ea
04A0: 1060           cpl     rr0,@r6
04A2: 113C           pushl   @r3,@r12
04A4: 134C           push    @r4,@r12
04A6: 13AE           push    @r10,@r14
04A8: 13CC           push    @r12,@r12
04AA: 0542           or      r2,@r4
04AC: 0542           or      r2,@r4
04AE: 0542           or      r2,@r4
04B0: 13E6           push    @r14,@r6
04B2: 1494           ldl     rr4,@r9
04B4: 159A           popl    @r10,@r9
04B6: 1670           addl    rr0,@r7
04B8: 169A           addl    rr10,@r9
04BA: 1670           addl    rr0,@r7
04BC: 1718           pop     @r8,@r1
04BE: 1670           addl    rr0,@r7
04C0: 17C4           pop     @r4,@r12
04C2: 17E6           pop     @r6,@r14
04C4: 1858           multl   rq8,@r5
04C6: 18E8           multl   rq8,@r14
04C8: 18FA           multl   rq10,@r15
04CA: 6100 801A      ld      r0,%801a
04CE: 6101 848A      ld      r1,%848a
04D2: B305 FFFF      srll    rr0,#1
04D6: 6F01 848A      ld      %848a,r1
04DA: 0B01 00FF      cp      r1,#%00ff
04DE: E603           jr      eq/z,%04e6
04E0: 0B01 FF00      cp      r1,#%ff00
04E4: 9E0E           ret     ne/nz
04E6: 5400 81B8      ldl     rr0,%81b8
04EA: 6100 8488      ld      r0,%8488
04EE: B305 0004      slll    rr0,#4
04F2: 6F00 8488      ld      %8488,r0
04F6: 0B00 1234      cp      r0,#%1234
04FA: E613           jr      eq/z,%0522
04FC: 0B00 4321      cp      r0,#%4321
0500: 9E0E           ret     ne/nz
0502: 610E 81B0      ld      r14,%81b0
0506: 070E 007E      and     r14,#%007e
050A: 4DE5 AA00 000A ld      %aa00(r14),#%000a
0510: A9E1           inc     r14,2
0512: 070E 007E      and     r14,#%007e
0516: 4DE5 AA00 FFFF ld      %aa00(r14),#%ffff
051C: 6F0E 81B0      ld      %81b0,r14
0520: 9E08           ret     
0522: 610E 81B0      ld      r14,%81b0
0526: 070E 007E      and     r14,#%007e
052A: 4DE5 AA00 0009 ld      %aa00(r14),#%0009
0530: A9E1           inc     r14,2
0532: 070E 007E      and     r14,#%007e
0536: 4DE5 AA00 FFFF ld      %aa00(r14),#%ffff
053C: 6F0E 81B0      ld      %81b0,r14
0540: 9E08           ret     
0542: 8D08           clr     r0
0544: 8D18           clr     r1
0546: 6F00 82C0      ld      %82c0,r0
054A: 6F00 82C2      ld      %82c2,r0
054E: 6F00 82C4      ld      %82c4,r0
0552: 6F00 82C6      ld      %82c6,r0
0556: 6F00 82C8      ld      %82c8,r0
055A: 6F00 82CA      ld      %82ca,r0
055E: 6F00 82CC      ld      %82cc,r0
0562: 6F00 8020      ld      %8020,r0
0566: 6F00 889E      ld      %889e,r0
056A: 6F00 8150      ld      %8150,r0
056E: 6F00 81A6      ld      %81a6,r0
0572: 6F00 81AE      ld      %81ae,r0
0576: 5D00 8180      ldl     %8180,rr0
057A: 5D00 8184      ldl     %8184,rr0
057E: 5D00 8008      ldl     %8008,rr0
0582: 5D00 81E0      ldl     %81e0,rr0
0586: 5D00 800C      ldl     %800c,rr0
058A: 5D00 A870      ldl     %a870,rr0
058E: 6F00 A878      ld      %a878,r0
0592: 5D00 A874      ldl     %a874,rr0
0596: 6F00 81A0      ld      %81a0,r0
059A: 6F00 81AC      ld      %81ac,r0
059E: 6F00 80F0      ld      %80f0,r0
05A2: 6F00 A826      ld      %a826,r0
05A6: 5D00 A9C0      ldl     %a9c0,rr0
05AA: 4D05 A9C4 003C ld      %a9c4,#%003c
05B0: 5D00 A9C8      ldl     %a9c8,rr0
05B4: 1402 0120 0140 ldl     rr2,#%01200140
05BA: 5D02 826C      ldl     %826c,rr2
05BE: 5D02 8270      ldl     %8270,rr2
05C2: 1402 0000 7890 ldl     rr2,#%00007890
05C8: 5D02 A830      ldl     %a830,rr2
05CC: 5D02 A834      ldl     %a834,rr2
05D0: 5D02 A838      ldl     %a838,rr2
05D4: 5D02 A83C      ldl     %a83c,rr2
05D8: 2101 AA00      ld      r1,#%aa00
05DC: 2100 0042      ld      r0,#%0042
05E0: 0D15 FFFF      ld      @r1,#%ffff
05E4: A911           inc     r1,2
05E6: F084           djnz    r0,%05e0
05E8: 4D08 81B0      clr     %81b0
05EC: 4D08 883C      clr     %883c
05F0: 6900 8014      inc     %8014,1
05F4: 9E08           ret     
05F6: DE60           calr    %0938
05F8: 4D04 81AC      test    %81ac
05FC: EE04           jr      ne/nz,%0606
05FE: 4D05 81AC 001E ld      %81ac,#%001e
0604: 9E08           ret     
0606: 6B00 81AC      dec     %81ac,1
060A: 9E0E           ret     ne/nz
060C: 6900 8014      inc     %8014,1
0610: 9E08           ret     
0612: DE6E           calr    %0938
0614: 4D05 8012 0001 ld      %8012,#%0001
061A: 4D05 8014 0000 ld      %8014,#%0000
0620: 6900 8014      inc     %8014,1
0624: 9E08           ret     
0626: DE78           calr    %0938
0628: 4D05 8104 0001 ld      %8104,#%0001
062E: 4D04 81AC      test    %81ac
0632: EE04           jr      ne/nz,%063c
0634: 4D05 81AC 01F4 ld      %81ac,#%01f4
063A: 9E08           ret     
063C: 6B00 81AC      dec     %81ac,1
0640: 9E0E           ret     ne/nz
0642: 6900 8014      inc     %8014,1
0646: 9E08           ret     
0648: DE89           calr    %0938
064A: 4D05 8010 8000 ld      %8010,#%8000
0650: 4D05 8104 0001 ld      %8104,#%0001
0656: 4D05 883A 0001 ld      %883a,#%0001
065C: 610E 81B0      ld      r14,%81b0
0660: 070E 007E      and     r14,#%007e
0664: 4DE5 AA00 0005 ld      %aa00(r14),#%0005
066A: A9E1           inc     r14,2
066C: 070E 007E      and     r14,#%007e
0670: 4DE5 AA00 FFFF ld      %aa00(r14),#%ffff
0676: 6F0E 81B0      ld      %81b0,r14
067A: 5E08 0ACC      jp      %0acc
067E: DEA4           calr    %0938
0680: 4D08 81F4      clr     %81f4
0684: 4D08 A826      clr     %a826
0688: 4D05 81FC 0010 ld      %81fc,#%0010
068E: 5E08 0B72      jp      %0b72
0692: DEAE           calr    %0938
0694: 4D05 81FA 0007 ld      %81fa,#%0007
069A: 5F00 0F42      call    %0f42
069E: 4D08 883A      clr     %883a
06A2: 610E 81B0      ld      r14,%81b0
06A6: 070E 007E      and     r14,#%007e
06AA: 4DE5 AA00 0000 ld      %aa00(r14),#%0000
06B0: A9E1           inc     r14,2
06B2: 070E 007E      and     r14,#%007e
06B6: 4DE5 AA00 FFFF ld      %aa00(r14),#%ffff
06BC: 6F0E 81B0      ld      %81b0,r14
06C0: 610E 81B0      ld      r14,%81b0
06C4: 070E 007E      and     r14,#%007e
06C8: 4DE5 AA00 0016 ld      %aa00(r14),#%0016
06CE: A9E1           inc     r14,2
06D0: 070E 007E      and     r14,#%007e
06D4: 4DE5 AA00 FFFF ld      %aa00(r14),#%ffff
06DA: 6F0E 81B0      ld      %81b0,r14
06DE: 610E 81B0      ld      r14,%81b0
06E2: 070E 007E      and     r14,#%007e
06E6: 4DE5 AA00 0006 ld      %aa00(r14),#%0006
06EC: A9E1           inc     r14,2
06EE: 070E 007E      and     r14,#%007e
06F2: 4DE5 AA00 FFFF ld      %aa00(r14),#%ffff
06F8: 6F0E 81B0      ld      %81b0,r14
06FC: 9E08           ret     
06FE: DEE4           calr    %0938
0700: 4D08 81FE      clr     %81fe
0704: 5400 81E0      ldl     rr0,%81e0
0708: C001           ldb     rh0,#%01
070A: 210C 98CC      ld      r12,#%98cc
070E: 5F00 23E0      call    %23e0
0712: 5E08 0FEA      jp      %0fea
0716: DEF0           calr    %0938
0718: 5F00 1BB6      call    %1bb6
071C: 5F00 1BE4      call    %1be4
0720: 5F00 1CBC      call    %1cbc
0724: 5F00 2704      call    %2704
0728: 5F00 20A6      call    %20a6
072C: 5F00 1FE4      call    %1fe4
0730: 5F00 22DC      call    %22dc
0734: 5F00 1DB4      call    %1db4
0738: 5F00 1E22      call    %1e22
073C: 4D04 81FE      test    %81fe
0740: E60F           jr      eq/z,%0760
0742: 6900 8014      inc     %8014,1
0746: 4D08 81AC      clr     %81ac
074A: 4D08 80F0      clr     %80f0
074E: 4D05 883A 0001 ld      %883a,#%0001
0754: 4D08 8022      clr     %8022
0758: 4D05 8020 0073 ld      %8020,#%0073
075E: 9E08           ret     
0760: 4D04 81AC      test    %81ac
0764: EE04           jr      ne/nz,%076e
0766: 4D05 81AC 04B0 ld      %81ac,#%04b0
076C: 9E08           ret     
076E: 6B00 81AC      dec     %81ac,1
0772: 9E0E           ret     ne/nz
0774: 6900 8014      inc     %8014,1
0778: E8E8           jr      %074a
077A: DF22           calr    %0938
077C: 6700 8030      bit     %8030,0
0780: 9E06           ret     eq/z
0782: 4D08 8020      clr     %8020
0786: 610E 81B0      ld      r14,%81b0
078A: 070E 007E      and     r14,#%007e
078E: 4DE5 AA00 0014 ld      %aa00(r14),#%0014
0794: A9E1           inc     r14,2
0796: 070E 007E      and     r14,#%007e
079A: 4DE5 AA00 FFFF ld      %aa00(r14),#%ffff
07A0: 6F0E 81B0      ld      %81b0,r14
07A4: 6900 8014      inc     %8014,1
07A8: 4D05 81AC 0275 ld      %81ac,#%0275
07AE: 9E08           ret     
07B0: DF3D           calr    %0938
07B2: 5F00 24E2      call    %24e2
07B6: 4D04 81AC      test    %81ac
07BA: EE04           jr      ne/nz,%07c4
07BC: 4D05 81AC 0001 ld      %81ac,#%0001
07C2: 9E08           ret     
07C4: 6B00 81AC      dec     %81ac,1
07C8: 9E0E           ret     ne/nz
07CA: 6900 8014      inc     %8014,1
07CE: 4D08 883A      clr     %883a
07D2: 610E 81B0      ld      r14,%81b0
07D6: 070E 007E      and     r14,#%007e
07DA: 4DE5 AA00 0000 ld      %aa00(r14),#%0000
07E0: A9E1           inc     r14,2
07E2: 070E 007E      and     r14,#%007e
07E6: 4DE5 AA00 FFFF ld      %aa00(r14),#%ffff
07EC: 6F0E 81B0      ld      %81b0,r14
07F0: 610E 81B0      ld      r14,%81b0
07F4: 070E 007E      and     r14,#%007e
07F8: 4DE5 AA00 0016 ld      %aa00(r14),#%0016
07FE: A9E1           inc     r14,2
0800: 070E 007E      and     r14,#%007e
0804: 4DE5 AA00 FFFF ld      %aa00(r14),#%ffff
080A: 6F0E 81B0      ld      %81b0,r14
080E: 610E 81B0      ld      r14,%81b0
0812: 070E 007E      and     r14,#%007e
0816: 4DE5 AA00 0006 ld      %aa00(r14),#%0006
081C: A9E1           inc     r14,2
081E: 070E 007E      and     r14,#%007e
0822: 4DE5 AA00 FFFF ld      %aa00(r14),#%ffff
0828: 6F0E 81B0      ld      %81b0,r14
082C: 9E08           ret     
082E: DF7C           calr    %0938
0830: 6900 8014      inc     %8014,1
0834: 4D08 81FE      clr     %81fe
0838: 5400 81E0      ldl     rr0,%81e0
083C: C001           ldb     rh0,#%01
083E: 210C 98CC      ld      r12,#%98cc
0842: 5F00 23E0      call    %23e0
0846: 5E08 112E      jp      %112e
084A: DF8A           calr    %0938
084C: 5F00 112E      call    %112e
0850: 5F00 1BB6      call    %1bb6
0854: 5F00 1BE4      call    %1be4
0858: 5F00 1CBC      call    %1cbc
085C: 5F00 2704      call    %2704
0860: 5F00 20A6      call    %20a6
0864: 5F00 1FE4      call    %1fe4
0868: 5F00 22DC      call    %22dc
086C: 5F00 1DB4      call    %1db4
0870: 5F00 1E22      call    %1e22
0874: 4D04 81FE      test    %81fe
0878: EE15           jr      ne/nz,%08a4
087A: 6100 81AC      ld      r0,%81ac
087E: AB00           dec     r0,1
0880: 0B00 003C      cp      r0,#%003c
0884: EF03           jr      nc/uge,%088c
0886: 4D05 81BC FED4 ld      %81bc,#%fed4
088C: 4D04 81AC      test    %81ac
0890: EE04           jr      ne/nz,%089a
0892: 4D05 81AC 04B0 ld      %81ac,#%04b0
0898: 9E08           ret     
089A: 6B00 81AC      dec     %81ac,1
089E: 9E0E           ret     ne/nz
08A0: 6900 8014      inc     %8014,1
08A4: 4D08 80F0      clr     %80f0
08A8: DFDB           calr    %08f4
08AA: 4D08 81AC      clr     %81ac
08AE: 4D05 883A 0001 ld      %883a,#%0001
08B4: 4D05 8104 0001 ld      %8104,#%0001
08BA: 4D05 8018 0001 ld      %8018,#%0001
08C0: 4D05 8C60 0001 ld      %8c60,#%0001
08C6: 4D05 81F0 FFFF ld      %81f0,#%ffff
08CC: 4D08 8016      clr     %8016
08D0: 4D08 8014      clr     %8014
08D4: 610E 81B0      ld      r14,%81b0
08D8: 070E 007E      and     r14,#%007e
08DC: 4DE5 AA00 0010 ld      %aa00(r14),#%0010
08E2: A9E1           inc     r14,2
08E4: 070E 007E      and     r14,#%007e
08E8: 4DE5 AA00 FFFF ld      %aa00(r14),#%ffff
08EE: 6F0E 81B0      ld      %81b0,r14
08F2: 9E08           ret     
08F4: 210C 9D0E      ld      r12,#%9d0e
08F8: DFFF           calr    %08fc
08FA: A9C3           inc     r12,4
08FC: 2104 0004      ld      r4,#%0004
0900: 0DC5 0024      ld      @r12,#%0024
0904: A9C1           inc     r12,2
0906: 0DC5 0024      ld      @r12,#%0024
090A: 010C 003E      add     r12,#%003e
090E: 0DC5 0024      ld      @r12,#%0024
0912: A9C1           inc     r12,2
0914: 0DC5 0024      ld      @r12,#%0024
0918: 030C 003E      sub     r12,#%003e
091C: F48F           djnz    r4,%0900
091E: 9E08           ret     
0920: 4D04 8104      test    %8104
0924: 4D05 8106 0001 ld      %8106,#%0001
092A: 9E06           ret     eq/z
092C: 4D04 814C      test    %814c
0930: 9E0E           ret     ne/nz
0932: 4D08 8106      clr     %8106
0936: 9E08           ret     
0938: D00D           calr    %0920
093A: 6100 81AA      ld      r0,%81aa
093E: 0700 00FF      and     r0,#%00ff
0942: 9E06           ret     eq/z
0944: 6F00 81A8      ld      %81a8,r0
0948: 4D08 8104      clr     %8104
094C: 4D08 81AC      clr     %81ac
0950: 4D05 8012 0002 ld      %8012,#%0002
0956: 4D05 8014 0000 ld      %8014,#%0000
095C: 97F0           pop     r0,@r15
095E: 9E08           ret     
0960: DF84           calr    %0a5a
0962: 4D08 8200      clr     %8200
0966: 4D05 820A 04B0 ld      %820a,#%04b0
096C: 4D05 820C 0708 ld      %820c,#%0708
0972: 4D05 820E 01E0 ld      %820e,#%01e0
0978: 6101 800C      ld      r1,%800c
097C: 6F01 819C      ld      %819c,r1
0980: 4D05 8202 0004 ld      %8202,#%0004
0986: 610E 81B0      ld      r14,%81b0
098A: 070E 007E      and     r14,#%007e
098E: 4DE5 AA00 0017 ld      %aa00(r14),#%0017
0994: A9E1           inc     r14,2
0996: 070E 007E      and     r14,#%007e
099A: 4DE5 AA00 FFFF ld      %aa00(r14),#%ffff
09A0: 6F0E 81B0      ld      %81b0,r14
09A4: 6900 8014      inc     %8014,1
09A8: 9E08           ret     
09AA: DE9B           calr    %0c76
09AC: DFAA           calr    %0a5a
09AE: 5F00 1B60      call    %1b60
09B2: DFC4           calr    %0a2c
09B4: 4101 8202      add     r1,%8202
09B8: 6F01 8202      ld      %8202,r1
09BC: B319 FFFD      sra     r1,#3
09C0: 0701 0003      and     r1,#%0003
09C4: A110           ld      r0,r1
09C6: B301 FFFF      srl     r0,#1
09CA: 8901           xor     r1,r0
09CC: 6F01 801C      ld      %801c,r1
09D0: 5F00 30FC      call    %30fc
09D4: 6100 8190      ld      r0,%8190
09D8: 4100 8194      add     r0,%8194
09DC: 4D04 8200      test    %8200
09E0: EE07           jr      ne/nz,%09f0
09E2: 2101 0001      ld      r1,#%0001
09E6: 8D04           test    r0
09E8: E604           jr      eq/z,%09f2
09EA: 6B00 820E      dec     %820e,1
09EE: EE0B           jr      ne/nz,%0a06
09F0: A101           ld      r1,r0
09F2: 4101 8200      add     r1,%8200
09F6: 6F01 8200      ld      %8200,r1
09FA: 0B01 008C      cp      r1,#%008c
09FE: E203           jr      le,%0a06
0A00: 4D05 801E 0001 ld      %801e,#%0001
0A06: 4D04 81A4      test    %81a4
0A0A: E603           jr      eq/z,%0a12
0A0C: 4D05 820A 04B0 ld      %820a,#%04b0
0A12: 6B00 820A      dec     %820a,1
0A16: EE03           jr      ne/nz,%0a1e
0A18: 4D05 801E 0001 ld      %801e,#%0001
0A1E: 6B00 820C      dec     %820c,1
0A22: 9E0E           ret     ne/nz
0A24: 4D05 801E 0001 ld      %801e,#%0001
0A2A: 9E08           ret     
0A2C: 6100 800C      ld      r0,%800c
0A30: A102           ld      r2,r0
0A32: 6101 819C      ld      r1,%819c
0A36: A113           ld      r3,r1
0A38: 6F00 819C      ld      %819c,r0
0A3C: 8289           subb    rl1,rl0
0A3E: B110           extsb   r1
0A40: A110           ld      r0,r1
0A42: 8D04           test    r0
0A44: ED01           jr      pl,%0a48
0A46: 8D02           neg     r0
0A48: 0B00 000A      cp      r0,#%000a
0A4C: E202           jr      le,%0a52
0A4E: 2101 0000      ld      r1,#%0000
0A52: 8D12           neg     r1
0A54: 6F01 81A4      ld      %81a4,r1
0A58: 9E08           ret     
0A5A: 6100 81A8      ld      r0,%81a8
0A5E: 6101 81AA      ld      r1,%81aa
0A62: 0701 00FF      and     r1,#%00ff
0A66: 6F01 81A8      ld      %81a8,r1
0A6A: A910           inc     r1,1
0A6C: 8310           sub     r0,r1
0A6E: 9E0E           ret     ne/nz
0A70: 4D08 81AC      clr     %81ac
0A74: 4D05 8012 0003 ld      %8012,#%0003
0A7A: 4D05 8014 0000 ld      %8014,#%0000
0A80: 97F0           pop     r0,@r15
0A82: 9E08           ret     
0A84: 5F00 0920      call    %0920
0A88: 6502 80EC      set     %80ec,2
0A8C: 4D05 883A 0001 ld      %883a,#%0001
0A92: 610E 81B0      ld      r14,%81b0
0A96: 070E 007E      and     r14,#%007e
0A9A: 4DE5 AA00 0005 ld      %aa00(r14),#%0005
0AA0: A9E1           inc     r14,2
0AA2: 070E 007E      and     r14,#%007e
0AA6: 4DE5 AA00 FFFF ld      %aa00(r14),#%ffff
0AAC: 6F0E 81B0      ld      %81b0,r14
0AB0: 8D08           clr     r0
0AB2: 8D18           clr     r1
0AB4: 6F00 801E      ld      %801e,r0
0AB8: 5D00 A870      ldl     %a870,rr0
0ABC: 6F00 A878      ld      %a878,r0
0AC0: 5D00 A874      ldl     %a874,rr0
0AC4: 5D00 A9C8      ldl     %a9c8,rr0
0AC8: 6F00 8020      ld      %8020,r0
0ACC: 610E 81B0      ld      r14,%81b0
0AD0: 070E 007E      and     r14,#%007e
0AD4: 4DE5 AA00 0011 ld      %aa00(r14),#%0011
0ADA: A9E1           inc     r14,2
0ADC: 070E 007E      and     r14,#%007e
0AE0: 4DE5 AA00 FFFF ld      %aa00(r14),#%ffff
0AE6: 6F0E 81B0      ld      %81b0,r14
0AEA: 8D08           clr     r0
0AEC: 8D18           clr     r1
0AEE: 6F00 821E      ld      %821e,r0
0AF2: 6F00 821C      ld      %821c,r0
0AF6: 6F00 8220      ld      %8220,r0
0AFA: 6F00 822C      ld      %822c,r0
0AFE: 6F00 8482      ld      %8482,r0
0B02: 6F00 8480      ld      %8480,r0
0B06: 6F00 8222      ld      %8222,r0
0B0A: 6F00 8258      ld      %8258,r0
0B0E: 6F00 8190      ld      %8190,r0
0B12: 6F00 80F0      ld      %80f0,r0
0B16: 6F00 81F8      ld      %81f8,r0
0B1A: 6F00 828C      ld      %828c,r0
0B1E: 6F00 828E      ld      %828e,r0
0B22: 4D05 8290 0012 ld      %8290,#%0012
0B28: 6F00 8292      ld      %8292,r0
0B2C: 6F00 8296      ld      %8296,r0
0B30: 5D00 81B8      ldl     %81b8,rr0
0B34: 6F00 82A6      ld      %82a6,r0
0B38: 4D05 8294 0001 ld      %8294,#%0001
0B3E: 4D05 82A4 0001 ld      %82a4,#%0001
0B44: 4D05 82A2 000A ld      %82a2,#%000a
0B4A: 6F00 81B4      ld      %81b4,r0
0B4E: 6F00 81FC      ld      %81fc,r0
0B52: 4D05 8840 0003 ld      %8840,#%0003
0B58: 5F00 222C      call    %222c
0B5C: 6101 8146      ld      r1,%8146
0B60: 0701 0003      and     r1,#%0003
0B64: 0101 0013      add     r1,#%0013
0B68: 6F01 8280      ld      %8280,r1
0B6C: 6900 8014      inc     %8014,1
0B70: 9E08           ret     
0B72: DFD4           calr    %0bcc
0B74: 4D04 81AC      test    %81ac
0B78: EE04           jr      ne/nz,%0b82
0B7A: 4D05 81AC 00DC ld      %81ac,#%00dc
0B80: 9E08           ret     
0B82: 6B00 81AC      dec     %81ac,1
0B86: 9E0E           ret     ne/nz
0B88: 6900 8014      inc     %8014,1
0B8C: 4D08 8020      clr     %8020
0B90: 4D08 A826      clr     %a826
0B94: 4D08 8108      clr     %8108
0B98: 4D08 883A      clr     %883a
0B9C: 4D04 8104      test    %8104
0BA0: 5E0E 0F8A      jp      ne/nz,%0f8a
0BA4: 610E 81B0      ld      r14,%81b0
0BA8: 070E 007E      and     r14,#%007e
0BAC: 4DE5 AA00 0018 ld      %aa00(r14),#%0018
0BB2: A9E1           inc     r14,2
0BB4: 070E 007E      and     r14,#%007e
0BB8: 4DE5 AA00 FFFF ld      %aa00(r14),#%ffff
0BBE: 6F0E 81B0      ld      %81b0,r14
0BC2: 4D05 82C2 0001 ld      %82c2,#%0001
0BC8: 5E08 0F8A      jp      %0f8a
0BCC: 6100 81AC      ld      r0,%81ac
0BD0: 0B00 00C8      cp      r0,#%00c8
0BD4: E621           jr      eq/z,%0c18
0BD6: 0B00 00B4      cp      r0,#%00b4
0BDA: 9E0A           ret     gt
0BDC: E628           jr      eq/z,%0c2e
0BDE: 0B00 008C      cp      r0,#%008c
0BE2: EA2B           jr      gt,%0c3a
0BE4: 0B00 0078      cp      r0,#%0078
0BE8: 9E0A           ret     gt
0BEA: E638           jr      eq/z,%0c5c
0BEC: 0B00 0050      cp      r0,#%0050
0BF0: EA3C           jr      gt,%0c6a
0BF2: 9E0E           ret     ne/nz
0BF4: 4D08 8020      clr     %8020
0BF8: 2104 8055      ld      r4,#%8055
0BFC: 5400 A9C0      ldl     rr0,%a9c0
0C00: D978           calr    %1912
0C02: 8D08           clr     r0
0C04: 8D18           clr     r1
0C06: 5D00 A9C0      ldl     %a9c0,rr0
0C0A: 4D05 8022 0005 ld      %8022,#%0005
0C10: 4D05 8020 0073 ld      %8020,#%0073
0C16: 9E08           ret     
0C18: 4D04 8104      test    %8104
0C1C: 9E06           ret     eq/z
0C1E: 6100 801C      ld      r0,%801c
0C22: A900           inc     r0,1
0C24: 0700 0003      and     r0,#%0003
0C28: 6F00 801C      ld      %801c,r0
0C2C: 9E08           ret     
0C2E: 4D08 8022      clr     %8022
0C32: 4D05 8020 0073 ld      %8020,#%0073
0C38: 9E08           ret     
0C3A: 6700 8030      bit     %8030,0
0C3E: 9E06           ret     eq/z
0C40: 4D08 8020      clr     %8020
0C44: 5400 8038      ldl     rr0,%8038
0C48: A091           ldb     rh1,rl1
0C4A: A089           ldb     rl1,rl0
0C4C: 8D08           clr     r0
0C4E: 5F00 3532      call    %3532
0C52: B305 0004      slll    rr0,#4
0C56: 5D00 81E0      ldl     %81e0,rr0
0C5A: 9E08           ret     
0C5C: 4D05 8022 0004 ld      %8022,#%0004
0C62: 4D05 8020 0073 ld      %8020,#%0073
0C68: 9E08           ret     
0C6A: 6700 8030      bit     %8030,0
0C6E: 9E06           ret     eq/z
0C70: 4D08 8020      clr     %8020
0C74: 9E08           ret     
0C76: 2103 9F2C      ld      r3,#%9f2c
0C7A: 6100 800E      ld      r0,%800e
0C7E: 8C08           clrb    rh0
0C80: A101           ld      r1,r0
0C82: B301 FFFC      srl     r0,#4
0C86: 0B00 0009      cp      r0,#%0009
0C8A: EA19           jr      gt,%0cbe
0C8C: 2102 0CAE      ld      r2,#%0cae
0C90: 2105 0007      ld      r5,#%0007
0C94: DFE8           calr    %0cc6
0C96: 0700 000F      and     r0,#%000f
0C9A: EE01           jr      ne/nz,%0c9e
0C9C: C824           ldb     rl0,#%24
0C9E: C015           ldb     rh0,#%15
0CA0: 2F30           ld      @r3,r0
0CA2: A931           inc     r3,2
0CA4: 0701 000F      and     r1,#%000f
0CA8: C115           ldb     rh1,#%15
0CAA: 2F31           ld      @r3,r1
0CAC: 9E08           ret     
0CAE: 0C1B           .word   #%0c1b
0CB0: 0E0D           ext0e   #%0d
0CB2: 121D           subl    rr13,@r1
0CB4: 240F 1B0E      setb    rl3,r15
0CB8: 0E24           ext0e   #%24
0CBA: 1915           mult    rr5,@r1
0CBC: 0A22           cpb     rh2,@r2
0CBE: 2102 0CB5      ld      r2,#%0cb5
0CC2: 2105 0009      ld      r5,#%0009
0CC6: C415           ldb     rh4,#%15
0CC8: 202C           ldb     rl4,@r2
0CCA: 2F34           ld      @r3,r4
0CCC: A920           inc     r2,1
0CCE: A931           inc     r3,2
0CD0: F585           djnz    r5,%0cc8
0CD2: 9E08           ret     
0CD4: DDD4           calr    %112e
0CD6: 4D04 81AC      test    %81ac
0CDA: EE04           jr      ne/nz,%0ce4
0CDC: 4D05 81AC 00B4 ld      %81ac,#%00b4
0CE2: 9E08           ret     
0CE4: 6B00 81AC      dec     %81ac,1
0CE8: 9E0E           ret     ne/nz
0CEA: 6900 8014      inc     %8014,1
0CEE: 610E 81B0      ld      r14,%81b0
0CF2: 070E 007E      and     r14,#%007e
0CF6: 4DE5 AA00 0003 ld      %aa00(r14),#%0003
0CFC: A9E1           inc     r14,2
0CFE: 070E 007E      and     r14,#%007e
0D02: 4DE5 AA00 FFFF ld      %aa00(r14),#%ffff
0D08: 6F0E 81B0      ld      %81b0,r14
0D0C: 4D08 80F0      clr     %80f0
0D10: 4D04 8104      test    %8104
0D14: 9E0E           ret     ne/nz
0D16: 4D05 80F0 0001 ld      %80f0,#%0001
0D1C: 9E08           ret     
0D1E: D832           calr    %1cbc
0D20: DDFA           calr    %112e
0D22: 5F00 2704      call    %2704
0D26: D8E4           calr    %1b60
0D28: D904           calr    %1b22
0D2A: 4D04 81AC      test    %81ac
0D2E: EE04           jr      ne/nz,%0d38
0D30: 4D05 81AC 0050 ld      %81ac,#%0050
0D36: 9E08           ret     
0D38: 6B00 81AC      dec     %81ac,1
0D3C: 9E0E           ret     ne/nz
0D3E: 6900 8014      inc     %8014,1
0D42: 610E 81B0      ld      r14,%81b0
0D46: 070E 007E      and     r14,#%007e
0D4A: 4DE5 AA00 0004 ld      %aa00(r14),#%0004
0D50: A9E1           inc     r14,2
0D52: 070E 007E      and     r14,#%007e
0D56: 4DE5 AA00 FFFF ld      %aa00(r14),#%ffff
0D5C: 6F0E 81B0      ld      %81b0,r14
0D60: 8D08           clr     r0
0D62: 6F00 8488      ld      %8488,r0
0D66: 6F00 848A      ld      %848a,r0
0D6A: 6700 801A      bit     %801a,0
0D6E: E602           jr      eq/z,%0d74
0D70: 6B00 848A      dec     %848a,1
0D74: 6F00 821E      ld      %821e,r0
0D78: 6F00 889E      ld      %889e,r0
0D7C: 6F00 8482      ld      %8482,r0
0D80: 6F00 8480      ld      %8480,r0
0D84: 6F00 8258      ld      %8258,r0
0D88: 6F00 8016      ld      %8016,r0
0D8C: 6F00 81BC      ld      %81bc,r0
0D90: 6F00 81BE      ld      %81be,r0
0D94: 6F00 81F0      ld      %81f0,r0
0D98: 6F00 81F6      ld      %81f6,r0
0D9C: 4D05 81F4 0001 ld      %81f4,#%0001
0DA2: 4D05 8204 0001 ld      %8204,#%0001
0DA8: 4D05 8296 0001 ld      %8296,#%0001
0DAE: 9E08           ret     
0DB0: D929           calr    %1b60
0DB2: D8E8           calr    %1be4
0DB4: D87D           calr    %1cbc
0DB6: 5F00 2704      call    %2704
0DBA: 5F00 20A6      call    %20a6
0DBE: 5F00 20C8      call    %20c8
0DC2: DE4B           calr    %112e
0DC4: 5F00 22DC      call    %22dc
0DC8: D80B           calr    %1db4
0DCA: 5F00 1E22      call    %1e22
0DCE: 5F00 04CA      call    %04ca
0DD2: 4D04 8016      test    %8016
0DD6: 9E06           ret     eq/z
0DD8: 4D05 8C60 0001 ld      %8c60,#%0001
0DDE: 4D08 80F0      clr     %80f0
0DE2: 4D04 81F6      test    %81f6
0DE6: E652           jr      eq/z,%0e8c
0DE8: 6900 8014      inc     %8014,1
0DEC: 4D08 8296      clr     %8296
0DF0: 4D05 A826 012C ld      %a826,#%012c
0DF6: 4D05 8108 012C ld      %8108,#%012c
0DFC: 4D05 A840 00F0 ld      %a840,#%00f0
0E02: 4D05 82A2 0008 ld      %82a2,#%0008
0E08: 6101 81FA      ld      r1,%81fa
0E0C: 0701 0007      and     r1,#%0007
0E10: 8111           add     r1,r1
0E12: 6110 0E7C      ld      r0,%0e7c(r1)
0E16: 6F00 A842      ld      %a842,r0
0E1A: 4D04 81FA      test    %81fa
0E1E: E617           jr      eq/z,%0e4e
0E20: 6503 80EC      set     %80ec,3
0E24: 610E 81B0      ld      r14,%81b0
0E28: 070E 007E      and     r14,#%007e
0E2C: 4DE5 AA00 0019 ld      %aa00(r14),#%0019
0E32: A9E1           inc     r14,2
0E34: 070E 007E      and     r14,#%007e
0E38: 4DE5 AA00 FFFF ld      %aa00(r14),#%ffff
0E3E: 6F0E 81B0      ld      %81b0,r14
0E42: 4D05 82C4 0001 ld      %82c4,#%0001
0E48: 6900 A9C8      inc     %a9c8,1
0E4C: 9E08           ret     
0E4E: 6504 80EC      set     %80ec,4
0E52: 610E 81B0      ld      r14,%81b0
0E56: 070E 007E      and     r14,#%007e
0E5A: 4DE5 AA00 0019 ld      %aa00(r14),#%0019
0E60: A9E1           inc     r14,2
0E62: 070E 007E      and     r14,#%007e
0E66: 4DE5 AA00 FFFF ld      %aa00(r14),#%ffff
0E6C: 6F0E 81B0      ld      %81b0,r14
0E70: 4D05 82C4 0001 ld      %82c4,#%0001
0E76: 6900 A9C8      inc     %a9c8,1
0E7A: 9E08           ret     
0E7C: 0400 0200      orb     rh0,#%00
0E80: 0140           add     r0,@r4
0E82: 0100 0080      add     r0,#%0080
0E86: 0060           addb    rh0,@r6
0E88: 0040           addb    rh0,@r4
0E8A: 0020           addb    rh0,@r2
0E8C: 4D08 8296      clr     %8296
0E90: 6100 8274      ld      r0,%8274
0E94: 6F00 A878      ld      %a878,r0
0E98: 4D05 8108 0258 ld      %8108,#%0258
0E9E: 8D08           clr     r0
0EA0: 6F00 821E      ld      %821e,r0
0EA4: 6F00 80E8      ld      %80e8,r0
0EA8: 6F00 821C      ld      %821c,r0
0EAC: 6F00 8220      ld      %8220,r0
0EB0: 6F00 822C      ld      %822c,r0
0EB4: 6F00 8482      ld      %8482,r0
0EB8: 6F00 8480      ld      %8480,r0
0EBC: 6F00 8258      ld      %8258,r0
0EC0: 6F00 8190      ld      %8190,r0
0EC4: 6F00 80F0      ld      %80f0,r0
0EC8: 4D05 8012 0004 ld      %8012,#%0004
0ECE: 4D05 8014 0000 ld      %8014,#%0000
0ED4: 4D08 A824      clr     %a824
0ED8: 4D01 81FC 0002 cp      %81fc,#%0002
0EDE: 9E0E           ret     ne/nz
0EE0: 4D05 A826 0258 ld      %a826,#%0258
0EE6: 5400 A828      ldl     rr0,%a828
0EEA: 5D00 A820      ldl     %a820,rr0
0EEE: 5D00 A870      ldl     %a870,rr0
0EF2: 9E08           ret     
0EF4: DEE4           calr    %112e
0EF6: 5F00 25E8      call    %25e8
0EFA: 8D08           clr     r0
0EFC: 8D18           clr     r1
0EFE: 5D00 A820      ldl     %a820,rr0
0F02: 6F00 80E8      ld      %80e8,r0
0F06: 6F00 80E0      ld      %80e0,r0
0F0A: 4D01 A842 0000 cp      %a842,#%0000
0F10: 9E0A           ret     gt
0F12: 4D04 81AC      test    %81ac
0F16: EE04           jr      ne/nz,%0f20
0F18: 4D05 81AC 0028 ld      %81ac,#%0028
0F1E: 9E08           ret     
0F20: 6B00 81AC      dec     %81ac,1
0F24: 9E0E           ret     ne/nz
0F26: 6900 8014      inc     %8014,1
0F2A: 4D08 81F4      clr     %81f4
0F2E: 4D08 A826      clr     %a826
0F32: 4D08 8108      clr     %8108
0F36: 210C 9D90      ld      r12,#%9d90
0F3A: 5F00 3582      call    %3582
0F3E: 8196           add     r6,r9
0F40: 9E08           ret     
0F42: 610E 81B0      ld      r14,%81b0
0F46: 070E 007E      and     r14,#%007e
0F4A: 4DE5 AA00 0001 ld      %aa00(r14),#%0001
0F50: A9E1           inc     r14,2
0F52: 070E 007E      and     r14,#%007e
0F56: 4DE5 AA00 FFFF ld      %aa00(r14),#%ffff
0F5C: 6F0E 81B0      ld      %81b0,r14
0F60: 4D08 81B4      clr     %81b4
0F64: 4D05 8840 0004 ld      %8840,#%0004
0F6A: 6701 8146      bit     %8146,1
0F6E: EE02           jr      ne/nz,%0f74
0F70: 6900 8840      inc     %8840,1
0F74: 4D05 81FC 0010 ld      %81fc,#%0010
0F7A: 5F00 22AC      call    %22ac
0F7E: 5F00 2246      call    %2246
0F82: 6900 8014      inc     %8014,1
0F86: 5F00 0D0C      call    %0d0c
0F8A: 4D08 A824      clr     %a824
0F8E: 1400 0001 9999 ldl     rr0,#%00019999
0F94: 5D00 A828      ldl     %a828,rr0
0F98: 5D00 A82C      ldl     %a82c,rr0
0F9C: 8D08           clr     r0
0F9E: 8D18           clr     r1
0FA0: 5D00 818C      ldl     %818c,rr0
0FA4: 5D00 828C      ldl     %828c,rr0
0FA8: 6F00 8258      ld      %8258,r0
0FAC: 6F00 8204      ld      %8204,r0
0FB0: 6F00 821C      ld      %821c,r0
0FB4: 6F00 8220      ld      %8220,r0
0FB8: 6F00 822C      ld      %822c,r0
0FBC: 6F00 8480      ld      %8480,r0
0FC0: 6F00 8482      ld      %8482,r0
0FC4: 6F00 8190      ld      %8190,r0
0FC8: 6F00 8222      ld      %8222,r0
0FCC: 6F00 825C      ld      %825c,r0
0FD0: 6F00 8218      ld      %8218,r0
0FD4: 5D00 8180      ldl     %8180,rr0
0FD8: 6F00 81F0      ld      %81f0,r0
0FDC: 6F00 8274      ld      %8274,r0
0FE0: 6100 800C      ld      r0,%800c
0FE4: 6F00 819C      ld      %819c,r0
0FE8: 9E08           ret     
0FEA: D998           calr    %1cbc
0FEC: DF60           calr    %112e
0FEE: 5F00 2704      call    %2704
0FF2: DA4A           calr    %1b60
0FF4: DA9C           calr    %1abe
0FF6: DA60           calr    %1b38
0FF8: 4D04 81AC      test    %81ac
0FFC: EE04           jr      ne/nz,%1006
0FFE: 4D05 81AC 00F0 ld      %81ac,#%00f0
1004: 9E08           ret     
1006: 6B00 81AC      dec     %81ac,1
100A: 9E0E           ret     ne/nz
100C: 6900 8014      inc     %8014,1
1010: 610E 81B0      ld      r14,%81b0
1014: 070E 007E      and     r14,#%007e
1018: 4DE5 AA00 0002 ld      %aa00(r14),#%0002
101E: A9E1           inc     r14,2
1020: 070E 007E      and     r14,#%007e
1024: 4DE5 AA00 FFFF ld      %aa00(r14),#%ffff
102A: 6F0E 81B0      ld      %81b0,r14
102E: 8D08           clr     r0
1030: 6F00 821E      ld      %821e,r0
1034: 6F00 8258      ld      %8258,r0
1038: 6F00 8016      ld      %8016,r0
103C: 6F00 81BC      ld      %81bc,r0
1040: 6F00 81BE      ld      %81be,r0
1044: 6F00 81F0      ld      %81f0,r0
1048: 6F00 81F6      ld      %81f6,r0
104C: 6F00 828A      ld      %828a,r0
1050: A900           inc     r0,1
1052: 6F00 8204      ld      %8204,r0
1056: 6F00 A848      ld      %a848,r0
105A: 6F00 8296      ld      %8296,r0
105E: 9E08           ret     
1060: DA81           calr    %1b60
1062: DA40           calr    %1be4
1064: D9D5           calr    %1cbc
1066: 5F00 2704      call    %2704
106A: 5F00 20A6      call    %20a6
106E: 5F00 20C8      call    %20c8
1072: 5F00 213E      call    %213e
1076: DFA5           calr    %112e
1078: 5F00 22DC      call    %22dc
107C: D965           calr    %1db4
107E: D92F           calr    %1e22
1080: D905           calr    %1e78
1082: 5F00 23AC      call    %23ac
1086: 4D04 81F8      test    %81f8
108A: EE3B           jr      ne/nz,%1102
108C: 4D04 8016      test    %8016
1090: 9E06           ret     eq/z
1092: 6902 8014      inc     %8014,3
1096: 4D05 82A0 FFFF ld      %82a0,#%ffff
109C: 8D08           clr     r0
109E: 6F00 80F0      ld      %80f0,r0
10A2: 6F00 A824      ld      %a824,r0
10A6: 6F00 8296      ld      %8296,r0
10AA: 6F00 821E      ld      %821e,r0
10AE: 6F00 80E8      ld      %80e8,r0
10B2: 6F00 821C      ld      %821c,r0
10B6: 6F00 8220      ld      %8220,r0
10BA: 6F00 822C      ld      %822c,r0
10BE: 6F00 8482      ld      %8482,r0
10C2: 6F00 8480      ld      %8480,r0
10C6: 6F00 8258      ld      %8258,r0
10CA: 6F00 8190      ld      %8190,r0
10CE: 4D05 8C60 0001 ld      %8c60,#%0001
10D4: 6100 8274      ld      r0,%8274
10D8: 6F00 A878      ld      %a878,r0
10DC: 4D05 8108 0258 ld      %8108,#%0258
10E2: 4D01 81FC 0011 cp      %81fc,#%0011
10E8: 9E06           ret     eq/z
10EA: 5400 A82C      ldl     rr0,%a82c
10EE: 5D00 A828      ldl     %a828,rr0
10F2: 5D00 A820      ldl     %a820,rr0
10F6: 5D00 A870      ldl     %a870,rr0
10FA: 4D05 A826 0258 ld      %a826,#%0258
1100: 9E08           ret     
1102: 6900 8014      inc     %8014,1
1106: 5400 818C      ldl     rr0,%818c
110A: 5D00 8282      ldl     %8282,rr0
110E: 4D08 8296      clr     %8296
1112: 4D08 81AE      clr     %81ae
1116: 4D08 81AC      clr     %81ac
111A: 4D05 8294 FFFF ld      %8294,#%ffff
1120: 4D05 82A6 0001 ld      %82a6,#%0001
1126: 4D05 82C6 0001 ld      %82c6,#%0001
112C: 9E08           ret     
112E: D889           calr    %201e
1130: 5F00 21AA      call    %21aa
1134: 5F00 21C6      call    %21c6
1138: 5E08 1F40      jp      %1f40
113C: DACA           calr    %1baa
113E: DA70           calr    %1c60
1140: DA02           calr    %1d3e
1142: 5F00 2704      call    %2704
1146: D851           calr    %20a6
1148: D841           calr    %20c8
114A: D807           calr    %213e
114C: D010           calr    %112e
114E: 5F00 2374      call    %2374
1152: D9D0           calr    %1db4
1154: D99A           calr    %1e22
1156: DB72           calr    %1a74
1158: 4D04 8016      test    %8016
115C: 9E06           ret     eq/z
115E: 4D01 81AE 0001 cp      %81ae,#%0001
1164: E66C           jr      eq/z,%123e
1166: EA5D           jr      gt,%1222
1168: 6101 801C      ld      r1,%801c
116C: 0701 0003      and     r1,#%0003
1170: B311 0002      sll     r1,#2
1174: 6100 8146      ld      r0,%8146
1178: 0700 0003      and     r0,#%0003
117C: 8101           add     r1,r0
117E: B311 0002      sll     r1,#2
1182: 6100 8148      ld      r0,%8148
1186: 0700 0003      and     r0,#%0003
118A: 8101           add     r1,r0
118C: 8111           add     r1,r1
118E: 6100 A802      ld      r0,%a802
1192: 6111 3F34      ld      r1,%3f34(r1)
1196: A112           ld      r2,r1
1198: 0102 000A      add     r2,#%000a
119C: 8B20           cp      r0,r2
119E: E937           jr      ge,%120e
11A0: 8B10           cp      r0,r1
11A2: E92F           jr      ge,%1202
11A4: 6900 8014      inc     %8014,1
11A8: 6900 A9C8      inc     %a9c8,1
11AC: 4D08 A824      clr     %a824
11B0: 5400 A82C      ldl     rr0,%a82c
11B4: 5D00 A828      ldl     %a828,rr0
11B8: 5D00 A820      ldl     %a820,rr0
11BC: 5D00 A870      ldl     %a870,rr0
11C0: 4D05 A826 0258 ld      %a826,#%0258
11C6: 6100 8274      ld      r0,%8274
11CA: 6F00 A878      ld      %a878,r0
11CE: 4D05 8108 0258 ld      %8108,#%0258
11D4: 8D08           clr     r0
11D6: 8D18           clr     r1
11D8: 6F00 8480      ld      %8480,r0
11DC: 6F00 8482      ld      %8482,r0
11E0: 6F00 821C      ld      %821c,r0
11E4: 6F00 8258      ld      %8258,r0
11E8: 6F00 822C      ld      %822c,r0
11EC: 6F00 8220      ld      %8220,r0
11F0: 5D00 828C      ldl     %828c,rr0
11F4: 6F00 80E8      ld      %80e8,r0
11F8: 6F00 80E0      ld      %80e0,r0
11FC: 6F00 81AE      ld      %81ae,r0
1200: 9E08           ret     
1202: 4D05 81AE 0001 ld      %81ae,#%0001
1208: 4D08 81AC      clr     %81ac
120C: E844           jr      %1296
120E: DF6E           calr    %1334
1210: 0700 000C      and     r0,#%000c
1214: EEF6           jr      ne/nz,%1202
1216: 4D05 81AE 0002 ld      %81ae,#%0002
121C: 4D08 81AC      clr     %81ac
1220: E83A           jr      %1296
1222: DFE6           calr    %1258
1224: 4D04 81AC      test    %81ac
1228: EE04           jr      ne/nz,%1232
122A: 4D05 81AC 01E0 ld      %81ac,#%01e0
1230: 9E08           ret     
1232: 6B00 81AC      dec     %81ac,1
1236: 9E0E           ret     ne/nz
1238: 6900 8014      inc     %8014,1
123C: E8B5           jr      %11a8
123E: 4D04 81AC      test    %81ac
1242: EE04           jr      ne/nz,%124c
1244: 4D05 81AC 012C ld      %81ac,#%012c
124A: 9E08           ret     
124C: 6B00 81AC      dec     %81ac,1
1250: 9E0E           ret     ne/nz
1252: 6900 8014      inc     %8014,1
1256: E8A8           jr      %11a8
1258: 210B 8B00      ld      r11,#%8b00
125C: 210A 0007      ld      r10,#%0007
1260: 0DB1 8003      cp      @r11,#%8003
1264: 9E06           ret     eq/z
1266: 010B 0020      add     r11,#%0020
126A: FA86           djnz    r10,%1260
126C: 210B 8B00      ld      r11,#%8b00
1270: 210A 0007      ld      r10,#%0007
1274: 0DB1 8002      cp      @r11,#%8002
1278: EE04           jr      ne/nz,%1282
127A: 4DB1 0002 0600 cp      %0002(r11),#%0600
1280: EA04           jr      gt,%128a
1282: 010B 0020      add     r11,#%0020
1286: FA8A           djnz    r10,%1274
1288: 9E08           ret     
128A: 0DB5 8003      ld      @r11,#%8003
128E: 4DB5 001E 07FF ld      %001e(r11),#%07ff
1294: 9E08           ret     
1296: 4D05 8C60 8004 ld      %8c60,#%8004
129C: 4D08 8C7C      clr     %8c7c
12A0: 4D05 80E2 0005 ld      %80e2,#%0005
12A6: 9E08           ret     
12A8: 2102 9F80      ld      r2,#%9f80
12AC: 2104 0004      ld      r4,#%0004
12B0: DFBF           calr    %1334
12B2: B309 FFFE      sra     r0,#2
12B6: 6F20 0002      ld      %0002(r2),r0
12BA: B309 FFF7      sra     r0,#9
12BE: 2F20           ld      @r2,r0
12C0: A923           inc     r2,4
12C2: DFC8           calr    %1334
12C4: B301 FFFE      srl     r0,#2
12C8: 6F20 0002      ld      %0002(r2),r0
12CC: B301 FFF7      srl     r0,#9
12D0: 2F20           ld      @r2,r0
12D2: A923           inc     r2,4
12D4: DFD1           calr    %1334
12D6: B301 FFFE      srl     r0,#2
12DA: 0100 1000      add     r0,#%1000
12DE: 6F20 0002      ld      %0002(r2),r0
12E2: B301 FFF6      srl     r0,#10
12E6: 2F20           ld      @r2,r0
12E8: 0102 0008      add     r2,#%0008
12EC: F49F           djnz    r4,%12b0
12EE: 2104 0004      ld      r4,#%0004
12F2: DFE0           calr    %1334
12F4: B309 FFFE      sra     r0,#2
12F8: 6F20 0002      ld      %0002(r2),r0
12FC: B309 FFF7      sra     r0,#9
1300: 2F20           ld      @r2,r0
1302: A923           inc     r2,4
1304: DFE9           calr    %1334
1306: A50F           set     r0,15
1308: B309 FFFE      sra     r0,#2
130C: 6F20 0002      ld      %0002(r2),r0
1310: B309 FFF7      sra     r0,#9
1314: 2F20           ld      @r2,r0
1316: A923           inc     r2,4
1318: DFF3           calr    %1334
131A: B301 FFFE      srl     r0,#2
131E: 0100 1000      add     r0,#%1000
1322: 6F20 0002      ld      %0002(r2),r0
1326: B301 FFF6      srl     r0,#10
132A: 2F20           ld      @r2,r0
132C: 0102 0008      add     r2,#%0008
1330: F4A0           djnz    r4,%12f2
1332: 9E08           ret     
1334: 6100 8898      ld      r0,%8898
1338: 8100           add     r0,r0
133A: 8100           add     r0,r0
133C: 4100 8898      add     r0,%8898
1340: A900           inc     r0,1
1342: 4100 8100      add     r0,%8100
1346: 6F00 8898      ld      %8898,r0
134A: 9E08           ret     
134C: D10F           calr    %1130
134E: DC6E           calr    %1a74
1350: 4D08 80E8      clr     %80e8
1354: 4D04 81AC      test    %81ac
1358: EE04           jr      ne/nz,%1362
135A: 4D05 81AC 001E ld      %81ac,#%001e
1360: 9E08           ret     
1362: 6B00 81AC      dec     %81ac,1
1366: 9E0E           ret     ne/nz
1368: 6900 8014      inc     %8014,1
136C: 4D08 A848      clr     %a848
1370: 6101 A802      ld      r1,%a802
1374: 8D14           test    r1
1376: E613           jr      eq/z,%139e
1378: AB10           dec     r1,1
137A: 1900 00C8      mult    rr0,#%00c8
137E: 6103 A800      ld      r3,%a800
1382: AB30           dec     r3,1
1384: A132           ld      r2,r3
1386: B331 0002      sll     r3,#2
138A: 8123           add     r3,r2
138C: 8131           add     r1,r3
138E: 6103 8100      ld      r3,%8100
1392: 8D28           clr     r2
1394: 1B02 0005      div     rr2,#%0005
1398: 8121           add     r1,r2
139A: B311 FFFF      srl     r1,#1
139E: 6F01 82A0      ld      %82a0,r1
13A2: 210C 9E0A      ld      r12,#%9e0a
13A6: 5F00 3582      call    %3582
13AA: 8118           add     r8,r1
13AC: 9E08           ret     
13AE: D140           calr    %1130
13B0: DCDB           calr    %19fc
13B2: 4D04 81AC      test    %81ac
13B6: EE04           jr      ne/nz,%13c0
13B8: 4D05 81AC 001E ld      %81ac,#%001e
13BE: 9E08           ret     
13C0: 6B00 81AC      dec     %81ac,1
13C4: 9E0E           ret     ne/nz
13C6: 6900 8014      inc     %8014,1
13CA: 9E08           ret     
13CC: D14F           calr    %1130
13CE: D9AA           calr    %207c
13D0: DCEB           calr    %19fc
13D2: DD25           calr    %198a
13D4: 8DD4           test    r13
13D6: 9E06           ret     eq/z
13D8: 4D05 8012 0004 ld      %8012,#%0004
13DE: 4D05 8014 0000 ld      %8014,#%0000
13E4: 9E08           ret     
13E6: 4D08 A826      clr     %a826
13EA: 4D05 8108 0001 ld      %8108,#%0001
13F0: D161           calr    %1130
13F2: D9BC           calr    %207c
13F4: 4D05 A880 0004 ld      %a880,#%0004
13FA: 4D05 A882 0004 ld      %a882,#%0004
1400: DC46           calr    %1b76
1402: 5400 81B8      ldl     rr0,%81b8
1406: 5D00 A874      ldl     %a874,rr0
140A: 8D08           clr     r0
140C: 6F00 80E8      ld      %80e8,r0
1410: 6F00 80E0      ld      %80e0,r0
1414: 6E08 802D      ldb     %802d,rl0
1418: 6E08 802F      ldb     %802f,rl0
141C: 6E08 807D      ldb     %807d,rl0
1420: 6E08 807F      ldb     %807f,rl0
1424: 5400 81B8      ldl     rr0,%81b8
1428: B305 FFF4      srll    rr0,#12
142C: 5F00 34D6      call    %34d6
1430: 6E09 8025      ldb     %8025,rl1
1434: 6E01 8027      ldb     %8027,rh1
1438: 4D04 82A6      test    %82a6
143C: E60B           jr      eq/z,%1454
143E: 5400 A84A      ldl     rr0,%a84a
1442: 0700 000F      and     r0,#%000f
1446: 5F00 34D6      call    %34d6
144A: 6E09 8029      ldb     %8029,rl1
144E: 6E01 802B      ldb     %802b,rh1
1452: E806           jr      %1460
1454: 4C05 8029 0000 ldb     %8029,#%29
145A: 4C05 802B 0000 ldb     %802b,#%2b
1460: 4D05 8022 0002 ld      %8022,#%0002
1466: 4D05 8020 0073 ld      %8020,#%0073
146C: DFFB           calr    %1478
146E: 4D08 810E      clr     %810e
1472: 6900 8014      inc     %8014,1
1476: 9E08           ret     
1478: 6100 800E      ld      r0,%800e
147C: 0700 00FF      and     r0,#%00ff
1480: A101           ld      r1,r0
1482: 4300 81A8      sub     r0,%81a8
1486: 6F01 81A8      ld      %81a8,r1
148A: 9E06           ret     eq/z
148C: 4D05 810E 0001 ld      %810e,#%0001
1492: 9E08           ret     
1494: DC90           calr    %1b76
1496: D010           calr    %1478
1498: 6700 8030      bit     %8030,0
149C: 9E06           ret     eq/z
149E: 4D08 8020      clr     %8020
14A2: 6100 8034      ld      r0,%8034
14A6: C000           ldb     rh0,#%00
14A8: 0B00 0014      cp      r0,#%0014
14AC: EA56           jr      gt,%155a
14AE: 0B00 0006      cp      r0,#%0006
14B2: EA06           jr      gt,%14c0
14B4: 0B00 0001      cp      r0,#%0001
14B8: E606           jr      eq/z,%14c6
14BA: 6506 80EE      set     %80ee,6
14BE: E805           jr      %14ca
14C0: 6500 80EE      set     %80ee,0
14C4: E802           jr      %14ca
14C6: 6505 80EE      set     %80ee,5
14CA: 4D05 82B4 0A50 ld      %82b4,#%0a50
14D0: 4D05 82B6 0348 ld      %82b6,#%0348
14D6: 6100 800C      ld      r0,%800c
14DA: 6F00 819C      ld      %819c,r0
14DE: 4D08 82B0      clr     %82b0
14E2: 4D05 82A8 0004 ld      %82a8,#%0004
14E8: 4D05 82AA 0004 ld      %82aa,#%0004
14EE: 4D05 82AC 0004 ld      %82ac,#%0004
14F4: 6700 80EE      bit     %80ee,0
14F8: EE10           jr      ne/nz,%151a
14FA: 610E 81B0      ld      r14,%81b0
14FE: 070E 007E      and     r14,#%007e
1502: 4DE5 AA00 0012 ld      %aa00(r14),#%0012
1508: A9E1           inc     r14,2
150A: 070E 007E      and     r14,#%007e
150E: 4DE5 AA00 FFFF ld      %aa00(r14),#%ffff
1514: 6F0E 81B0      ld      %81b0,r14
1518: E80F           jr      %1538
151A: 610E 81B0      ld      r14,%81b0
151E: 070E 007E      and     r14,#%007e
1522: 4DE5 AA00 0015 ld      %aa00(r14),#%0015
1528: A9E1           inc     r14,2
152A: 070E 007E      and     r14,#%007e
152E: 4DE5 AA00 FFFF ld      %aa00(r14),#%ffff
1534: 6F0E 81B0      ld      %81b0,r14
1538: 6900 8014      inc     %8014,1
153C: DCE4           calr    %1b76
153E: 4D05 82B2 0001 ld      %82b2,#%0001
1544: 4D01 A880 0004 cp      %a880,#%0004
154A: 9E09           ret     ge
154C: 4D01 A882 0004 cp      %a882,#%0004
1552: 9E09           ret     ge
1554: 4D08 82B2      clr     %82b2
1558: 9E08           ret     
155A: 4C05 802D 0000 ldb     %802d,#%2d
1560: 4C05 802F 0000 ldb     %802f,#%2f
1566: 4C05 807D 0000 ldb     %807d,#%7d
156C: 4C05 807F 0000 ldb     %807f,#%7f
1572: 610E 81B0      ld      r14,%81b0
1576: 070E 007E      and     r14,#%007e
157A: 4DE5 AA00 0013 ld      %aa00(r14),#%0013
1580: A9E1           inc     r14,2
1582: 070E 007E      and     r14,#%007e
1586: 4DE5 AA00 FFFF ld      %aa00(r14),#%ffff
158C: 6F0E 81B0      ld      %81b0,r14
1590: 6507 80EC      set     %80ec,7
1594: 6905 8014      inc     %8014,6
1598: 9E08           ret     
159A: D092           calr    %1478
159C: 6100 800C      ld      r0,%800c
15A0: 6101 819C      ld      r1,%819c
15A4: 6F00 819C      ld      %819c,r0
15A8: 8289           subb    rl1,rl0
15AA: B110           extsb   r1
15AC: 8D12           neg     r1
15AE: E603           jr      eq/z,%15b6
15B0: 4D05 82B6 04B0 ld      %82b6,#%04b0
15B6: 6102 82B0      ld      r2,%82b0
15BA: 6120 82A8      ld      r0,%82a8(r2)
15BE: 8110           add     r0,r1
15C0: 6F20 82A8      ld      %82a8(r2),r0
15C4: 2102 82A8      ld      r2,#%82a8
15C8: 2103 0003      ld      r3,#%0003
15CC: 8D18           clr     r1
15CE: 2120           ld      r0,@r2
15D0: B301 FFFE      srl     r0,#2
15D4: 0700 001F      and     r0,#%001f
15D8: 0B00 0000      cp      r0,#%0000
15DC: E106           jr      lt,%15ea
15DE: 0B00 001B      cp      r0,#%001b
15E2: E205           jr      le,%15ee
15E4: 2100 001B      ld      r0,#%001b
15E8: E802           jr      %15ee
15EA: 2100 0000      ld      r0,#%0000
15EE: B311 0005      sll     r1,#5
15F2: 8101           add     r1,r0
15F4: A921           inc     r2,2
15F6: F395           djnz    r3,%15ce
15F8: 6E09 802D      ldb     %802d,rl1
15FC: 6E01 802F      ldb     %802f,rh1
1600: 6E09 807D      ldb     %807d,rl1
1604: 6E01 807F      ldb     %807f,rh1
1608: 5F00 2482      call    %2482
160C: DD4C           calr    %1b76
160E: 4D04 82B2      test    %82b2
1612: E60B           jr      eq/z,%162a
1614: 4D01 A880 0002 cp      %a880,#%0002
161A: E91E           jr      ge,%1658
161C: 4D01 A882 0002 cp      %a882,#%0002
1622: E91A           jr      ge,%1658
1624: 4D08 82B2      clr     %82b2
1628: E817           jr      %1658
162A: 4D01 A880 0006 cp      %a880,#%0006
1630: E904           jr      ge,%163a
1632: 4D01 A882 0006 cp      %a882,#%0006
1638: E10F           jr      lt,%1658
163A: 4D05 82B2 0001 ld      %82b2,#%0001
1640: 4D05 82B6 04B0 ld      %82b6,#%04b0
1646: 6901 82B0      inc     %82b0,2
164A: 4D01 82B0 0004 cp      %82b0,#%0004
1650: E203           jr      le,%1658
1652: 6902 8014      inc     %8014,3
1656: 9E08           ret     
1658: 4D04 810E      test    %810e
165C: EE06           jr      ne/nz,%166a
165E: 6B00 82B6      dec     %82b6,1
1662: E603           jr      eq/z,%166a
1664: 6B00 82B4      dec     %82b4,1
1668: 9E0E           ret     ne/nz
166A: 6900 8014      inc     %8014,1
166E: 9E08           ret     
1670: D0FD           calr    %1478
1672: 2101 8038      ld      r1,#%8038
1676: 2102 A900      ld      r2,#%a900
167A: 2103 0048      ld      r3,#%0048
167E: 2110           ld      r0,@r1
1680: 2F20           ld      @r2,r0
1682: A911           inc     r1,2
1684: A921           inc     r2,2
1686: F385           djnz    r3,%167e
1688: 4D05 8022 0001 ld      %8022,#%0001
168E: 4D05 8020 0073 ld      %8020,#%0073
1694: 6900 8014      inc     %8014,1
1698: 9E08           ret     
169A: 5F00 248A      call    %248a
169E: 6700 8030      bit     %8030,0
16A2: 9E06           ret     eq/z
16A4: 4D08 8020      clr     %8020
16A8: 6305 80EE      res     %80ee,5
16AC: 6306 80EE      res     %80ee,6
16B0: 6300 80EE      res     %80ee,0
16B4: 6307 80EC      res     %80ec,7
16B8: 610E 81B0      ld      r14,%81b0
16BC: 070E 007E      and     r14,#%007e
16C0: 4DE5 AA00 001C ld      %aa00(r14),#%001c
16C6: A9E1           inc     r14,2
16C8: 070E 007E      and     r14,#%007e
16CC: 4DE5 AA00 FFFF ld      %aa00(r14),#%ffff
16D2: 6F0E 81B0      ld      %81b0,r14
16D6: 610E 81B0      ld      r14,%81b0
16DA: 070E 007E      and     r14,#%007e
16DE: 4DE5 AA00 0000 ld      %aa00(r14),#%0000
16E4: A9E1           inc     r14,2
16E6: 070E 007E      and     r14,#%007e
16EA: 4DE5 AA00 FFFF ld      %aa00(r14),#%ffff
16F0: 6F0E 81B0      ld      %81b0,r14
16F4: 610E 81B0      ld      r14,%81b0
16F8: 070E 007E      and     r14,#%007e
16FC: 4DE5 AA00 0006 ld      %aa00(r14),#%0006
1702: A9E1           inc     r14,2
1704: 070E 007E      and     r14,#%007e
1708: 4DE5 AA00 FFFF ld      %aa00(r14),#%ffff
170E: 6F0E 81B0      ld      %81b0,r14
1712: 6904 8014      inc     %8014,5
1716: 9E08           ret     
1718: D151           calr    %1478
171A: 5F00 248A      call    %248a
171E: DFBA           calr    %17ac
1720: 4D04 81AC      test    %81ac
1724: EE04           jr      ne/nz,%172e
1726: 4D05 81AC 012C ld      %81ac,#%012c
172C: 9E08           ret     
172E: 6B00 81AC      dec     %81ac,1
1732: 9E0E           ret     ne/nz
1734: 6900 8014      inc     %8014,1
1738: 6901 8014      inc     %8014,2
173C: 4D08 8020      clr     %8020
1740: 6305 80EE      res     %80ee,5
1744: 6306 80EE      res     %80ee,6
1748: 6300 80EE      res     %80ee,0
174C: 6307 80EC      res     %80ec,7
1750: 610E 81B0      ld      r14,%81b0
1754: 070E 007E      and     r14,#%007e
1758: 4DE5 AA00 001C ld      %aa00(r14),#%001c
175E: A9E1           inc     r14,2
1760: 070E 007E      and     r14,#%007e
1764: 4DE5 AA00 FFFF ld      %aa00(r14),#%ffff
176A: 6F0E 81B0      ld      %81b0,r14
176E: 610E 81B0      ld      r14,%81b0
1772: 070E 007E      and     r14,#%007e
1776: 4DE5 AA00 0000 ld      %aa00(r14),#%0000
177C: A9E1           inc     r14,2
177E: 070E 007E      and     r14,#%007e
1782: 4DE5 AA00 FFFF ld      %aa00(r14),#%ffff
1788: 6F0E 81B0      ld      %81b0,r14
178C: 610E 81B0      ld      r14,%81b0
1790: 070E 007E      and     r14,#%007e
1794: 4DE5 AA00 0006 ld      %aa00(r14),#%0006
179A: A9E1           inc     r14,2
179C: 070E 007E      and     r14,#%007e
17A0: 4DE5 AA00 FFFF ld      %aa00(r14),#%ffff
17A6: 6F0E 81B0      ld      %81b0,r14
17AA: 9E08           ret     
17AC: 4D04 810E      test    %810e
17B0: 9E06           ret     eq/z
17B2: 6700 8030      bit     %8030,0
17B6: 9E06           ret     eq/z
17B8: 4D05 81AC 0001 ld      %81ac,#%0001
17BE: 4D08 810E      clr     %810e
17C2: 9E08           ret     
17C4: D1A7           calr    %1478
17C6: 5F00 24BC      call    %24bc
17CA: D010           calr    %17ac
17CC: 4D04 81AC      test    %81ac
17D0: EE04           jr      ne/nz,%17da
17D2: 4D05 81AC 0212 ld      %81ac,#%0212
17D8: 9E08           ret     
17DA: 6B00 81AC      dec     %81ac,1
17DE: 9E0E           ret     ne/nz
17E0: 6900 8014      inc     %8014,1
17E4: E8AB           jr      %173c
17E6: DB11           calr    %21c6
17E8: DB20           calr    %21aa
17EA: 4D05 8108 0001 ld      %8108,#%0001
17F0: DC59           calr    %1f40
17F2: DBBC           calr    %207c
17F4: 4D08 80E8      clr     %80e8
17F8: 4D08 80E0      clr     %80e0
17FC: 4D04 81AC      test    %81ac
1800: EE04           jr      ne/nz,%180a
1802: 4D05 81AC 000A ld      %81ac,#%000a
1808: 9E08           ret     
180A: 6B00 81AC      dec     %81ac,1
180E: 9E0E           ret     ne/nz
1810: 6900 8014      inc     %8014,1
1814: 4D05 8104 0001 ld      %8104,#%0001
181A: 4D05 8018 0001 ld      %8018,#%0001
1820: 4D05 8016 0000 ld      %8016,#%0000
1826: 4D05 81F0 FFFF ld      %81f0,#%ffff
182C: 4D05 8022 0004 ld      %8022,#%0004
1832: 4D05 8020 0073 ld      %8020,#%0073
1838: 610E 81B0      ld      r14,%81b0
183C: 070E 007E      and     r14,#%007e
1840: 4DE5 AA00 0010 ld      %aa00(r14),#%0010
1846: A9E1           inc     r14,2
1848: 070E 007E      and     r14,#%007e
184C: 4DE5 AA00 FFFF ld      %aa00(r14),#%ffff
1852: 6F0E 81B0      ld      %81b0,r14
1856: 9E08           ret     
1858: 6700 8030      bit     %8030,0
185C: 9E06           ret     eq/z
185E: 4D08 8020      clr     %8020
1862: 6900 8014      inc     %8014,1
1866: 2104 803D      ld      r4,#%803d
186A: 2101 0001      ld      r1,#%0001
186E: 8D08           clr     r0
1870: DF9B           calr    %193c
1872: 2104 8045      ld      r4,#%8045
1876: 5400 81B8      ldl     rr0,%81b8
187A: B305 FFF4      srll    rr0,#12
187E: DFB7           calr    %1912
1880: 2104 804D      ld      r4,#%804d
1884: 5400 A9C0      ldl     rr0,%a9c0
1888: DFBC           calr    %1912
188A: 2104 8055      ld      r4,#%8055
188E: 5400 A9C0      ldl     rr0,%a9c0
1892: DFC1           calr    %1912
1894: 8D08           clr     r0
1896: 8D18           clr     r1
1898: 5D00 A9C0      ldl     %a9c0,rr0
189C: 6105 A9C8      ld      r5,%a9c8
18A0: 8D54           test    r5
18A2: 9E06           ret     eq/z
18A4: 2104 8059      ld      r4,#%8059
18A8: 2101 0001      ld      r1,#%0001
18AC: DFA9           calr    %195c
18AE: AB50           dec     r5,1
18B0: 9E06           ret     eq/z
18B2: 2104 805D      ld      r4,#%805d
18B6: 2101 0001      ld      r1,#%0001
18BA: DFB0           calr    %195c
18BC: AB50           dec     r5,1
18BE: 9E06           ret     eq/z
18C0: 2104 8061      ld      r4,#%8061
18C4: 2101 0001      ld      r1,#%0001
18C8: DFB7           calr    %195c
18CA: AB50           dec     r5,1
18CC: 9E06           ret     eq/z
18CE: 2104 8065      ld      r4,#%8065
18D2: 2101 0001      ld      r1,#%0001
18D6: DFBE           calr    %195c
18D8: AB50           dec     r5,1
18DA: 9E06           ret     eq/z
18DC: 2104 8069      ld      r4,#%8069
18E0: 2101 0001      ld      r1,#%0001
18E4: DFC5           calr    %195c
18E6: 9E08           ret     
18E8: 4D05 8022 0005 ld      %8022,#%0005
18EE: 4D05 8020 0073 ld      %8020,#%0073
18F4: 6900 8014      inc     %8014,1
18F8: 9E08           ret     
18FA: 6700 8030      bit     %8030,0
18FE: 9E06           ret     eq/z
1900: 4D08 8020      clr     %8020
1904: 4D05 8012 0001 ld      %8012,#%0001
190A: 4D05 8014 0000 ld      %8014,#%0000
1910: 9E08           ret     
1912: 93F2           push    @r15,r2
1914: 0049           addb    rl1,@r4
1916: B090           dab     rl1
1918: 2E49           ldb     @r4,rl1
191A: AB41           dec     r4,2
191C: 204A           ldb     rl2,@r4
191E: B4A1           adcb    rh1,rl2
1920: B010           dab     rh1
1922: 2E41           ldb     @r4,rh1
1924: AB41           dec     r4,2
1926: 204A           ldb     rl2,@r4
1928: B4A8           adcb    rl0,rl2
192A: B080           dab     rl0
192C: 2E48           ldb     @r4,rl0
192E: AB41           dec     r4,2
1930: 204A           ldb     rl2,@r4
1932: B4A0           adcb    rh0,rl2
1934: B000           dab     rh0
1936: 2E40           ldb     @r4,rh0
1938: 97F2           pop     r2,@r15
193A: 9E08           ret     
193C: 93F2           push    @r15,r2
193E: 0049           addb    rl1,@r4
1940: B090           dab     rl1
1942: 2E49           ldb     @r4,rl1
1944: AB41           dec     r4,2
1946: 204A           ldb     rl2,@r4
1948: B4A1           adcb    rh1,rl2
194A: B010           dab     rh1
194C: 2E41           ldb     @r4,rh1
194E: AB41           dec     r4,2
1950: 204A           ldb     rl2,@r4
1952: B4A8           adcb    rl0,rl2
1954: B080           dab     rl0
1956: 2E48           ldb     @r4,rl0
1958: 97F2           pop     r2,@r15
195A: 9E08           ret     
195C: 93F2           push    @r15,r2
195E: 0049           addb    rl1,@r4
1960: B090           dab     rl1
1962: 2E49           ldb     @r4,rl1
1964: AB41           dec     r4,2
1966: 204A           ldb     rl2,@r4
1968: B4A1           adcb    rh1,rl2
196A: B010           dab     rh1
196C: 2E41           ldb     @r4,rh1
196E: 97F2           pop     r2,@r15
1970: 9E08           ret     
1972: 93F0           push    @r15,r0
1974: B281 FFFC      srlb    rl0,#4
1978: DFFF           calr    %197c
197A: 97F0           pop     r0,@r15
197C: 93F0           push    @r15,r0
197E: 0608 0F0F      andb    rl0,#%0f
1982: 2FC0           ld      @r12,r0
1984: A9C1           inc     r12,2
1986: 97F0           pop     r0,@r15
1988: 9E08           ret     
198A: 8DD8           clr     r13
198C: 4D04 828A      test    %828a
1990: E60E           jr      eq/z,%19ae
1992: 6B00 82A2      dec     %82a2,1
1996: 9E0E           ret     ne/nz
1998: 4D05 82A2 0005 ld      %82a2,#%0005
199E: 6B00 828A      dec     %828a,1
19A2: 6501 80EE      set     %80ee,1
19A6: 1402 0000 5000 ldl     rr2,#%00005000
19AC: E81B           jr      %19e4
19AE: 6B00 82A2      dec     %82a2,1
19B2: 9E0E           ret     ne/nz
19B4: 4D05 82A2 0003 ld      %82a2,#%0003
19BA: 4D04 82A0      test    %82a0
19BE: E618           jr      eq/z,%19f0
19C0: E517           jr      mi,%19f0
19C2: 6507 80EE      set     %80ee,7
19C6: 1402 0000 1000 ldl     rr2,#%00001000
19CC: 6100 82A0      ld      r0,%82a0
19D0: 0300 0005      sub     r0,#%0005
19D4: E602           jr      eq/z,%19da
19D6: ED04           jr      pl,%19e0
19D8: 8D08           clr     r0
19DA: 4D05 82A2 001E ld      %82a2,#%001e
19E0: 6F00 82A0      ld      %82a0,r0
19E4: 5400 81B8      ldl     rr0,%81b8
19E8: DCAB           calr    %2094
19EA: 5D00 81B8      ldl     %81b8,rr0
19EE: 9E08           ret     
19F0: 210D 0001      ld      r13,#%0001
19F4: 4D05 A802 0000 ld      %a802,#%0000
19FA: 9E08           ret     
19FC: 6106 8102      ld      r6,%8102
1A00: 2107 0000      ld      r7,#%0000
1A04: 4D04 828A      test    %828a
1A08: EE01           jr      ne/nz,%1a0c
1A0A: AD76           ex      r6,r7
1A0C: A0E0           ldb     rh0,rl6
1A0E: 210C 9E0A      ld      r12,#%9e0a
1A12: 5F00 3578      call    %3578
1A16: 5041 5353      cpl     rr1,%5353(r4)
1A1A: 494E 4720      xor     r14,%4720(r4)
1A1E: 424F 4E55      subb    rl7,%4e55(r4)
1A22: 5320 2035      push    @r2,%2035
1A26: 302A 40FF      ldb     rl2,r2(#%40ff)
1A2A: 6101 828A      ld      r1,%828a
1A2E: 5F00 3532      call    %3532
1A32: A0E0           ldb     rh0,rl6
1A34: 5F00 2460      call    %2460
1A38: 4D04 82A0      test    %82a0
1A3C: 9E05           ret     mi
1A3E: A0F0           ldb     rh0,rl7
1A40: 210C 9E8A      ld      r12,#%9e8a
1A44: 5F00 3578      call    %3578
1A48: 5449 4D45      ldl     rr9,%4d45(r4)
1A4C: 2042           ldb     rh2,@r4
1A4E: 4F4E           .word   #%4f4e
1A50: 5553 2032      popl    %2032(r3),@r5
1A54: 3030 2A40      ldb     rh0,r3(#%2a40)
1A58: 6101 82A0      ld      r1,%82a0
1A5C: 5F00 3532      call    %3532
1A60: AC91           exb     rh1,rl1
1A62: A0F0           ldb     rh0,rl7
1A64: 5F00 2460      call    %2460
1A68: C825           ldb     rl0,#%25
1A6A: 2FC0           ld      @r12,r0
1A6C: A9C1           inc     r12,2
1A6E: AC91           exb     rh1,rl1
1A70: 5F00 2460      call    %2460
1A74: 4D04 8288      test    %8288
1A78: EE04           jr      ne/nz,%1a82
1A7A: 4D01 A848 0002 cp      %a848,#%0002
1A80: 9E0E           ret     ne/nz
1A82: 4D05 A848 0002 ld      %a848,#%0002
1A88: 6100 8102      ld      r0,%8102
1A8C: A080           ldb     rh0,rl0
1A8E: 210C 9E0E      ld      r12,#%9e0e
1A92: 5F00 3578      call    %3578
1A96: 594F 5552      mult    rr15,%5552(r4)
1A9A: 2052           ldb     rh2,@r5
1A9C: 4543 4F52      or      r3,%4f52(r4)
1AA0: 4420 2020      orb     rh0,%2020(r2)
1AA4: 202E           ldb     rl6,@r2
1AA6: 40FF 030C      addb    rl7,%030c(r15)
1AAA: 0008 5402      addb    rl0,#%02
1AAE: A84A           incb    rh4,11
1AB0: B325 0008      slll    rr2,#8
1AB4: A121           ld      r1,r2
1AB6: DB4A           calr    %2424
1AB8: A039           ldb     rl1,rh3
1ABA: 5E08 245E      jp      %245e
1ABE: 6100 81AC      ld      r0,%81ac
1AC2: 0B00 00B4      cp      r0,#%00b4
1AC6: E612           jr      eq/z,%1aec
1AC8: 0B00 0078      cp      r0,#%0078
1ACC: E618           jr      eq/z,%1afe
1ACE: 0B00 003C      cp      r0,#%003c
1AD2: E61E           jr      eq/z,%1b10
1AD4: 0B00 0001      cp      r0,#%0001
1AD8: 9E0E           ret     ne/nz
1ADA: 4D05 8BEC 0004 ld      %8bec,#%0004
1AE0: 4D04 8106      test    %8106
1AE4: 9E06           ret     eq/z
1AE6: 6503 80EE      set     %80ee,3
1AEA: 9E08           ret     
1AEC: 4D05 8BEC 0001 ld      %8bec,#%0001
1AF2: 4D04 8106      test    %8106
1AF6: 9E06           ret     eq/z
1AF8: 6504 80EE      set     %80ee,4
1AFC: 9E08           ret     
1AFE: 4D05 8BEC 0002 ld      %8bec,#%0002
1B04: 4D04 8106      test    %8106
1B08: 9E06           ret     eq/z
1B0A: 6504 80EE      set     %80ee,4
1B0E: 9E08           ret     
1B10: 4D05 8BEC 0003 ld      %8bec,#%0003
1B16: 4D04 8106      test    %8106
1B1A: 9E06           ret     eq/z
1B1C: 6504 80EE      set     %80ee,4
1B20: 9E08           ret     
1B22: 6100 81AC      ld      r0,%81ac
1B26: 0B00 0001      cp      r0,#%0001
1B2A: 9E0E           ret     ne/nz
1B2C: 4D05 8BEC 0004 ld      %8bec,#%0004
1B32: 6503 80EE      set     %80ee,3
1B36: 9E08           ret     
1B38: 6100 81AC      ld      r0,%81ac
1B3C: 8D04           test    r0
1B3E: 9E06           ret     eq/z
1B40: 0B00 00C8      cp      r0,#%00c8
1B44: 9E09           ret     ge
1B46: 0B00 001E      cp      r0,#%001e
1B4A: E206           jr      le,%1b58
1B4C: A704           bit     r0,4
1B4E: EE04           jr      ne/nz,%1b58
1B50: 4D05 8C60 0001 ld      %8c60,#%0001
1B56: 9E08           ret     
1B58: 4D05 8C60 8001 ld      %8c60,#%8001
1B5E: 9E08           ret     
1B60: 6101 8008      ld      r1,%8008
1B64: DFD2           calr    %1bc2
1B66: 6F01 8190      ld      %8190,r1
1B6A: 6101 800A      ld      r1,%800a
1B6E: DFD7           calr    %1bc2
1B70: 6F01 8194      ld      %8194,r1
1B74: 9E08           ret     
1B76: D00C           calr    %1b60
1B78: 6100 8190      ld      r0,%8190
1B7C: 4100 A880      add     r0,%a880
1B80: 0B00 0007      cp      r0,#%0007
1B84: E201           jr      le,%1b88
1B86: A900           inc     r0,1
1B88: B301 FFFF      srl     r0,#1
1B8C: 6F00 A880      ld      %a880,r0
1B90: 6100 8194      ld      r0,%8194
1B94: 4100 A882      add     r0,%a882
1B98: 0B00 0007      cp      r0,#%0007
1B9C: E201           jr      le,%1ba0
1B9E: A900           inc     r0,1
1BA0: B301 FFFF      srl     r0,#1
1BA4: 6F00 A882      ld      %a882,r0
1BA8: 9E08           ret     
1BAA: 4D05 8190 0004 ld      %8190,#%0004
1BB0: 4D08 8194      clr     %8194
1BB4: 9E08           ret     
1BB6: 4D05 8190 0007 ld      %8190,#%0007
1BBC: 4D08 8194      clr     %8194
1BC0: 9E08           ret     
1BC2: 0009 2020      addb    rl1,#%20
1BC6: 8C18           clrb    rh1
1BC8: B311 FFFC      srl     r1,#4
1BCC: 0A09 0404      cpb     rl1,#%04
1BD0: E707           jr      c/ult,%1be0
1BD2: 0209 0404      subb    rl1,#%04
1BD6: 0A09 0808      cpb     rl1,#%08
1BDA: 9E07           ret     c/ult
1BDC: C907           ldb     rl1,#%07
1BDE: 9E08           ret     
1BE0: 8C98           clrb    rl1
1BE2: 9E08           ret     
1BE4: 4D04 81BC      test    %81bc
1BE8: EE0E           jr      ne/nz,%1c06
1BEA: 6101 8258      ld      r1,%8258
1BEE: 8D08           clr     r0
1BF0: A018           ldb     rl0,rh1
1BF2: A091           ldb     rh1,rl1
1BF4: A009           ldb     rl1,rh0
1BF6: 1B00 0271      div     rr0,#%0271
1BFA: 8D08           clr     r0
1BFC: B305 000C      slll    rr0,#12
1C00: 5D00 818C      ldl     %818c,rr0
1C04: 9E08           ret     
1C06: 6100 81BC      ld      r0,%81bc
1C0A: A101           ld      r1,r0
1C0C: 4D08 81BC      clr     %81bc
1C10: 8D12           neg     r1
1C12: 8D04           test    r0
1C14: ED07           jr      pl,%1c24
1C16: 8D02           neg     r0
1C18: 8D12           neg     r1
1C1A: 4100 818C      add     r0,%818c
1C1E: 0B00 0096      cp      r0,#%0096
1C22: E1E3           jr      lt,%1bea
1C24: B10A           exts    rr0
1C26: B305 000A      slll    rr0,#10
1C2A: 5600 818C      addl    rr0,%818c
1C2E: ED02           jr      pl,%1c34
1C30: 8D08           clr     r0
1C32: A101           ld      r1,r0
1C34: 5D00 818C      ldl     %818c,rr0
1C38: A103           ld      r3,r0
1C3A: 1902 0271      mult    rr2,#%0271
1C3E: B325 FFFC      srll    rr2,#4
1C42: 6F03 8258      ld      %8258,r3
1C46: E507           jr      mi,%1c56
1C48: 0B00 0100      cp      r0,#%0100
1C4C: 9E07           ret     c/ult
1C4E: 4D05 818C 00FF ld      %818c,#%00ff
1C54: 9E08           ret     
1C56: 4D08 818C      clr     %818c
1C5A: 4D08 818E      clr     %818e
1C5E: 9E08           ret     
1C60: 5402 818C      ldl     rr2,%818c
1C64: 6101 81BE      ld      r1,%81be
1C68: 4D08 81BE      clr     %81be
1C6C: 8D14           test    r1
1C6E: ED01           jr      pl,%1c72
1C70: 8D12           neg     r1
1C72: 8D08           clr     r0
1C74: B305 000A      slll    rr0,#10
1C78: 9202           subl    rr2,rr0
1C7A: EF02           jr      nc/uge,%1c80
1C7C: 8D28           clr     r2
1C7E: A123           ld      r3,r2
1C80: 5D02 818C      ldl     %818c,rr2
1C84: 6105 81BC      ld      r5,%81bc
1C88: 4D08 81BC      clr     %81bc
1C8C: 8D54           test    r5
1C8E: E50B           jr      mi,%1ca6
1C90: 5404 828C      ldl     rr4,%828c
1C94: 1604 0000 9C40 addl    rr4,#%00009c40
1C9A: 0B04 00FA      cp      r4,#%00fa
1C9E: 9E09           ret     ge
1CA0: 5D04 828C      ldl     %828c,rr4
1CA4: 9E08           ret     
1CA6: B14A           exts    rr4
1CA8: B345 000A      slll    rr4,#10
1CAC: 5604 828C      addl    rr4,%828c
1CB0: ED02           jr      pl,%1cb6
1CB2: 8D48           clr     r4
1CB4: A145           ld      r5,r4
1CB6: 5D04 828C      ldl     %828c,rr4
1CBA: 9E08           ret     
1CBC: 6102 8184      ld      r2,%8184
1CC0: 5400 8170      ldl     rr0,%8170
1CC4: B305 FFFD      srll    rr0,#3
1CC8: 5600 8184      addl    rr0,%8184
1CCC: 5D00 8184      ldl     %8184,rr0
1CD0: 6F00 C100      ld      %c100,r0
1CD4: 4D08 8288      clr     %8288
1CD8: EF03           jr      nc/uge,%1ce0
1CDA: 4D05 8288 0001 ld      %8288,#%0001
1CE0: 4D08 8286      clr     %8286
1CE4: 0B00 C000      cp      r0,#%c000
1CE8: E706           jr      c/ult,%1cf6
1CEA: 0B02 C000      cp      r2,#%c000
1CEE: EF03           jr      nc/uge,%1cf6
1CF0: 4D05 8286 0001 ld      %8286,#%0001
1CF6: 600B 8184      ldb     rl3,%8184
1CFA: 8C38           clrb    rh3
1CFC: 6104 801C      ld      r4,%801c
1D00: 0704 0003      and     r4,#%0003
1D04: A0C4           ldb     rh4,rl4
1D06: 8CC8           clrb    rl4
1D08: 0104 36E0      add     r4,#%36e0
1D0C: 704B 0300      ldb     rl3,r4(r3)
1D10: B130           extsb   r3
1D12: 6F03 8198      ld      %8198,r3
1D16: 8D32           neg     r3
1D18: 6101 818C      ld      r1,%818c
1D1C: 0B01 00FF      cp      r1,#%00ff
1D20: E202           jr      le,%1d26
1D22: 2101 00FF      ld      r1,#%00ff
1D26: A091           ldb     rh1,rl1
1D28: 8C98           clrb    rl1
1D2A: B311 FFFE      srl     r1,#2
1D2E: 9912           mult    rr2,r1
1D30: 5602 8180      addl    rr2,%8180
1D34: 5D02 8180      ldl     %8180,rr2
1D38: 6F02 C000      ld      %c000,r2
1D3C: 9E08           ret     
1D3E: 5400 8170      ldl     rr0,%8170
1D42: B305 FFFD      srll    rr0,#3
1D46: 5600 8184      addl    rr0,%8184
1D4A: 5D00 8184      ldl     %8184,rr0
1D4E: 6F00 C100      ld      %c100,r0
1D52: 5402 828C      ldl     rr2,%828c
1D56: B325 FFFD      srll    rr2,#3
1D5A: 5602 8290      addl    rr2,%8290
1D5E: 5D02 8290      ldl     %8290,rr2
1D62: 6F02 8C68      ld      %8c68,r2
1D66: 6100 8298      ld      r0,%8298
1D6A: 6101 8184      ld      r1,%8184
1D6E: 4101 8290      add     r1,%8290
1D72: 6F01 8298      ld      %8298,r1
1D76: 8D10           com     r1
1D78: 8710           and     r0,r1
1D7A: A70F           bit     r0,15
1D7C: 4D08 8288      clr     %8288
1D80: 9E06           ret     eq/z
1D82: 4D05 8288 0001 ld      %8288,#%0001
1D88: 4D08 82A4      clr     %82a4
1D8C: 6506 80EC      set     %80ec,6
1D90: 4D08 80F0      clr     %80f0
1D94: 610E 81B0      ld      r14,%81b0
1D98: 070E 007E      and     r14,#%007e
1D9C: 4DE5 AA00 001B ld      %aa00(r14),#%001b
1DA2: A9E1           inc     r14,2
1DA4: 070E 007E      and     r14,#%007e
1DA8: 4DE5 AA00 FFFF ld      %aa00(r14),#%ffff
1DAE: 6F0E 81B0      ld      %81b0,r14
1DB2: 9E08           ret     
1DB4: 4D04 8288      test    %8288
1DB8: 9E06           ret     eq/z
1DBA: 4D04 81F4      test    %81f4
1DBE: EE04           jr      ne/nz,%1dc8
1DC0: 4D05 81B4 0001 ld      %81b4,#%0001
1DC6: 9E08           ret     
1DC8: 4D04 81B4      test    %81b4
1DCC: EE04           jr      ne/nz,%1dd6
1DCE: 4D05 81B4 0001 ld      %81b4,#%0001
1DD4: 9E08           ret     
1DD6: 4D04 A820      test    %a820
1DDA: 9E0E           ret     ne/nz
1DDC: 6103 A822      ld      r3,%a822
1DE0: 8D78           clr     r7
1DE2: 6109 814A      ld      r9,%814a
1DE6: 0709 0003      and     r9,#%0003
1DEA: B391 0004      sll     r9,#4
1DEE: 6108 801C      ld      r8,%801c
1DF2: 0708 0003      and     r8,#%0003
1DF6: B381 0006      sll     r8,#6
1DFA: 8189           add     r9,r8
1DFC: 0109 3BF0      add     r9,#%3bf0
1E00: 2108 0008      ld      r8,#%0008
1E04: 0B93           cp      r3,@r9
1E06: E705           jr      c/ult,%1e12
1E08: E604           jr      eq/z,%1e12
1E0A: A970           inc     r7,1
1E0C: A991           inc     r9,2
1E0E: F886           djnz    r8,%1e04
1E10: 9E08           ret     
1E12: 6F07 81FA      ld      %81fa,r7
1E16: 4D08 81B4      clr     %81b4
1E1A: 4D05 81F6 0001 ld      %81f6,#%0001
1E20: 9E08           ret     
1E22: 4D04 8288      test    %8288
1E26: 9E06           ret     eq/z
1E28: 6900 81FC      inc     %81fc,1
1E2C: 6100 A824      ld      r0,%a824
1E30: 8D04           test    r0
1E32: E61E           jr      eq/z,%1e70
1E34: 0B00 0001      cp      r0,#%0001
1E38: 9E0E           ret     ne/nz
1E3A: 5400 A820      ldl     rr0,%a820
1E3E: 5D00 A828      ldl     %a828,rr0
1E42: DDDF           calr    %2286
1E44: 4D05 A826 0258 ld      %a826,#%0258
1E4A: 5400 A828      ldl     rr0,%a828
1E4E: 5000 A82C      cpl     rr0,%a82c
1E52: 9E0F           ret     nc/uge
1E54: 5D00 A82C      ldl     %a82c,rr0
1E58: 6103 801C      ld      r3,%801c
1E5C: 0703 0003      and     r3,#%0003
1E60: 8133           add     r3,r3
1E62: 8133           add     r3,r3
1E64: 5030 A830      cpl     rr0,%a830(r3)
1E68: 9E0F           ret     nc/uge
1E6A: 5D30 A830      ldl     %a830(r3),rr0
1E6E: 9E08           ret     
1E70: 4D05 A824 0001 ld      %a824,#%0001
1E76: 9E08           ret     
1E78: 4D04 8288      test    %8288
1E7C: 9E06           ret     eq/z
1E7E: 6101 81FC      ld      r1,%81fc
1E82: 0301 0012      sub     r1,#%0012
1E86: 9E05           ret     mi
1E88: A910           inc     r1,1
1E8A: 0701 0007      and     r1,#%0007
1E8E: 6100 8148      ld      r0,%8148
1E92: 0700 0003      and     r0,#%0003
1E96: B301 0003      sll     r0,#3
1E9A: 8501           or      r1,r0
1E9C: 6100 8146      ld      r0,%8146
1EA0: 0700 0003      and     r0,#%0003
1EA4: B301 0005      sll     r0,#5
1EA8: 8501           or      r1,r0
1EAA: 6100 801C      ld      r0,%801c
1EAE: 0700 0003      and     r0,#%0003
1EB2: B301 0007      sll     r0,#7
1EB6: 8501           or      r1,r0
1EB8: 6018 3CF0      ldb     rl0,%3cf0(r1)
1EBC: 0700 007F      and     r0,#%007f
1EC0: 9E06           ret     eq/z
1EC2: 4100 A802      add     r0,%a802
1EC6: 6F00 A802      ld      %a802,r0
1ECA: 6900 8840      inc     %8840,1
1ECE: 4D01 8840 0008 cp      %8840,#%0008
1ED4: E703           jr      c/ult,%1edc
1ED6: 4D05 8840 0007 ld      %8840,#%0007
1EDC: 6501 80EC      set     %80ec,1
1EE0: 4D05 8150 007F ld      %8150,#%007f
1EE6: 6900 A9C8      inc     %a9c8,1
1EEA: 9E08           ret     
1EEC: 4D04 8286      test    %8286
1EF0: 9E06           ret     eq/z
1EF2: 6100 81FC      ld      r0,%81fc
1EF6: 0B00 0001      cp      r0,#%0001
1EFA: E607           jr      eq/z,%1f0a
1EFC: 0B00 0011      cp      r0,#%0011
1F00: E604           jr      eq/z,%1f0a
1F02: 4B00 8280      cp      r0,%8280
1F06: E605           jr      eq/z,%1f12
1F08: 9E08           ret     
1F0A: 4D05 8BEC 0005 ld      %8bec,#%0005
1F10: 9E08           ret     
1F12: 4D05 8BEC 0006 ld      %8bec,#%0006
1F18: 610E 81B0      ld      r14,%81b0
1F1C: 070E 007E      and     r14,#%007e
1F20: 4DE5 AA00 001A ld      %aa00(r14),#%001a
1F26: A9E1           inc     r14,2
1F28: 070E 007E      and     r14,#%007e
1F2C: 4DE5 AA00 FFFF ld      %aa00(r14),#%ffff
1F32: 6F0E 81B0      ld      %81b0,r14
1F36: 9E08           ret     
1F38: 0140           add     r0,@r4
1F3A: 0190           add     r0,@r9
1F3C: 00C8           addb    rl0,@r12
1F3E: 00FA           addb    rl2,@r15
1F40: 5400 818C      ldl     rr0,%818c
1F44: B305 FFF4      srll    rr0,#12
1F48: 6102 8148      ld      r2,%8148
1F4C: B321 FFFA      srl     r2,#6
1F50: 0702 0002      and     r2,#%0002
1F54: 6103 814E      ld      r3,%814e
1F58: 8133           add     r3,r3
1F5A: 8133           add     r3,r3
1F5C: 0703 0004      and     r3,#%0004
1F60: 8532           or      r2,r3
1F62: 5920 1F38      mult    rr0,%1f38(r2)
1F66: B305 FFF4      srll    rr0,#12
1F6A: 5F00 3532      call    %3532
1F6E: 6104 801C      ld      r4,%801c
1F72: 0704 0003      and     r4,#%0003
1F76: 8144           add     r4,r4
1F78: 4B41 826C      cp      r1,%826c(r4)
1F7C: E202           jr      le,%1f82
1F7E: 6F41 826C      ld      %826c(r4),r1
1F82: 4B01 8274      cp      r1,%8274
1F86: E202           jr      le,%1f8c
1F88: 6F01 8274      ld      %8274,r1
1F8C: 210C 9968      ld      r12,#%9968
1F90: 4D04 8104      test    %8104
1F94: EE0F           jr      ne/nz,%1fb4
1F96: 4D04 8108      test    %8108
1F9A: E60E           jr      eq/z,%1fb8
1F9C: 6B00 8108      dec     %8108,1
1FA0: 6102 8108      ld      r2,%8108
1FA4: 0702 001F      and     r2,#%001f
1FA8: 0B02 0012      cp      r2,#%0012
1FAC: EA34           jr      gt,%2016
1FAE: 6101 8274      ld      r1,%8274
1FB2: E802           jr      %1fb8
1FB4: 6101 A878      ld      r1,%a878
1FB8: 5F00 3582      call    %3582
1FBC: 0053           addb    rh3,@r5
1FBE: 5045 4544      cpl     rr5,%4544(r4)
1FC2: 2040           ldb     rh0,@r4
1FC4: C000           ldb     rh0,#%00
1FC6: DDD2           calr    %2424
1FC8: 6100 814E      ld      r0,%814e
1FCC: 0700 0001      and     r0,#%0001
1FD0: EE05           jr      ne/nz,%1fdc
1FD2: 5F00 3582      call    %3582
1FD6: 1C6B           .word   #%1c6b
1FD8: 6D40 E804      ex      r0,%e804(r4)
1FDC: 5F00 3582      call    %3582
1FE0: 1D6B           ldl     @r6,rr11
1FE2: 6D40 6101      ex      r0,%6101(r4)
1FE6: 8188           add     r8,r8
1FE8: 8D12           neg     r1
1FEA: 5900 8198      mult    rr0,%8198
1FEE: B30D FFF9      sral    rr0,#7
1FF2: 5900 818C      mult    rr0,%818c
1FF6: 5600 818C      addl    rr0,%818c
1FFA: 0B00 0000      cp      r0,#%0000
1FFE: E106           jr      lt,%200c
2000: 0B00 0118      cp      r0,#%0118
2004: E205           jr      le,%2010
2006: 2100 0118      ld      r0,#%0118
200A: E802           jr      %2010
200C: 2100 0000      ld      r0,#%0000
2010: 5D00 8170      ldl     %8170,rr0
2014: 9E08           ret     
2016: 5F00 3582      call    %3582
201A: 810B           add     r11,r0
201C: 9E08           ret     
201E: 5400 8170      ldl     rr0,%8170
2022: B305 FFFF      srll    rr0,#1
2026: 1B00 4300      div     rr0,#%4300
202A: 8D08           clr     r0
202C: 5F00 3532      call    %3532
2030: 4D04 81B4      test    %81b4
2034: EE03           jr      ne/nz,%203c
2036: 1400 0000 0000 ldl     rr0,#%00000000
203C: 5402 81B8      ldl     rr2,%81b8
2040: DFD7           calr    %2094
2042: 5D00 81B8      ldl     %81b8,rr0
2046: 4D04 8104      test    %8104
204A: E602           jr      eq/z,%2050
204C: 5400 A874      ldl     rr0,%a874
2050: B305 FFF8      srll    rr0,#8
2054: C000           ldb     rh0,#%00
2056: 0609 F0F0      andb    rl1,#%f0
205A: 210C 994C      ld      r12,#%994c
205E: 5F00 23E0      call    %23e0
2062: 8C08           clrb    rh0
2064: 5000 81E0      cpl     rr0,%81e0
2068: E702           jr      c/ult,%206e
206A: 5D00 81E0      ldl     %81e0,rr0
206E: 5400 81E0      ldl     rr0,%81e0
2072: C001           ldb     rh0,#%01
2074: 210C 98CC      ld      r12,#%98cc
2078: DE4D           calr    %23e0
207A: 9E08           ret     
207C: 5400 81B8      ldl     rr0,%81b8
2080: B305 FFF8      srll    rr0,#8
2084: C000           ldb     rh0,#%00
2086: 0609 F0F0      andb    rl1,#%f0
208A: 210C 994C      ld      r12,#%994c
208E: DE58           calr    %23e0
2090: 8C08           clrb    rh0
2092: E8E8           jr      %2064
2094: 80B9           addb    rl1,rl3
2096: B090           dab     rl1
2098: B431           adcb    rh1,rh3
209A: B010           dab     rh1
209C: B4A8           adcb    rl0,rl2
209E: B080           dab     rl0
20A0: B420           adcb    rh0,rh2
20A2: B000           dab     rh0
20A4: 9E08           ret     
20A6: 4D04 82A4      test    %82a4
20AA: 9E06           ret     eq/z
20AC: 210B A800      ld      r11,#%a800
20B0: 2BB0           dec     @r11,1
20B2: 9E0E           ret     ne/nz
20B4: 0DB5 0028      ld      @r11,#%0028
20B8: 6900 81F0      inc     %81f0,1
20BC: 4DB4 0002      test    %0002(r11)
20C0: 9E06           ret     eq/z
20C2: 6BB0 0002      dec     %0002(r11),1
20C6: 9E08           ret     
20C8: 6100 A824      ld      r0,%a824
20CC: 0B00 FFFF      cp      r0,#%ffff
20D0: 5E06 2280      jp      eq/z,%2280
20D4: 0B00 0001      cp      r0,#%0001
20D8: 9E0E           ret     ne/nz
20DA: 6900 A810      inc     %a810,1
20DE: 4D01 A810 000A cp      %a810,#%000a
20E4: E103           jr      lt,%20ec
20E6: 4D05 A810 0000 ld      %a810,#%0000
20EC: 6B00 A812      dec     %a812,1
20F0: EE0E           jr      ne/nz,%210e
20F2: 4D05 A812 0004 ld      %a812,#%0004
20F8: 6900 A814      inc     %a814,1
20FC: 4D01 A814 000A cp      %a814,#%000a
2102: E105           jr      lt,%210e
2104: 4D05 A814 0000 ld      %a814,#%0000
210A: 6900 A816      inc     %a816,1
210E: 6102 A810      ld      r2,%a810
2112: 0702 000F      and     r2,#%000f
2116: 6103 A814      ld      r3,%a814
211A: 0703 000F      and     r3,#%000f
211E: B331 0004      sll     r3,#4
2122: 8532           or      r2,r3
2124: 6101 A816      ld      r1,%a816
2128: 8D08           clr     r0
212A: 5F00 3532      call    %3532
212E: B305 0008      slll    rr0,#8
2132: 0700 000F      and     r0,#%000f
2136: 8521           or      r1,r2
2138: 5D00 A820      ldl     %a820,rr0
213C: 9E08           ret     
213E: 4D01 A848 0001 cp      %a848,#%0001
2144: 9E0E           ret     ne/nz
2146: 6900 A850      inc     %a850,1
214A: 4D01 A850 000A cp      %a850,#%000a
2150: E103           jr      lt,%2158
2152: 4D05 A850 0000 ld      %a850,#%0000
2158: 6B00 A852      dec     %a852,1
215C: EE0E           jr      ne/nz,%217a
215E: 4D05 A852 0004 ld      %a852,#%0004
2164: 6900 A854      inc     %a854,1
2168: 4D01 A854 000A cp      %a854,#%000a
216E: E105           jr      lt,%217a
2170: 4D05 A854 0000 ld      %a854,#%0000
2176: 6900 A856      inc     %a856,1
217A: 6102 A850      ld      r2,%a850
217E: 0702 000F      and     r2,#%000f
2182: 6103 A854      ld      r3,%a854
2186: 0703 000F      and     r3,#%000f
218A: B331 0004      sll     r3,#4
218E: 8532           or      r2,r3
2190: 6101 A856      ld      r1,%a856
2194: 8D08           clr     r0
2196: 5F00 3532      call    %3532
219A: B305 0008      slll    rr0,#8
219E: 0700 000F      and     r0,#%000f
21A2: 8521           or      r1,r2
21A4: 5D00 A84A      ldl     %a84a,rr0
21A8: 9E08           ret     
21AA: 210C 995C      ld      r12,#%995c
21AE: 8D18           clr     r1
21B0: 4D04 8104      test    %8104
21B4: EE02           jr      ne/nz,%21ba
21B6: 6101 A802      ld      r1,%a802
21BA: 8D08           clr     r0
21BC: 5F00 3532      call    %3532
21C0: C005           ldb     rh0,#%05
21C2: DED0           calr    %2424
21C4: 9E08           ret     
21C6: 210C 98F2      ld      r12,#%98f2
21CA: 4D04 8104      test    %8104
21CE: EE06           jr      ne/nz,%21dc
21D0: 4D04 A826      test    %a826
21D4: EE06           jr      ne/nz,%21e2
21D6: 5400 A820      ldl     rr0,%a820
21DA: E80F           jr      %21fa
21DC: 5400 A870      ldl     rr0,%a870
21E0: E80C           jr      %21fa
21E2: 6B00 A826      dec     %a826,1
21E6: 6100 A826      ld      r0,%a826
21EA: 0700 001F      and     r0,#%001f
21EE: E618           jr      eq/z,%2220
21F0: 0B00 0014      cp      r0,#%0014
21F4: 9E0E           ret     ne/nz
21F6: 5400 A828      ldl     rr0,%a828
21FA: A112           ld      r2,r1
21FC: B305 FFF8      srll    rr0,#8
2200: C004           ldb     rh0,#%04
2202: DEF0           calr    %2424
2204: A121           ld      r1,r2
2206: DED5           calr    %245e
2208: 030C 0012      sub     r12,#%0012
220C: 5F00 3582      call    %3582
2210: 044C           orb     rl4,@r4
2212: 4150 40FF      add     r0,%40ff(r5)
2216: 010C 0006      add     r12,#%0006
221A: 0DC5 0425      ld      @r12,#%0425
221E: 9E08           ret     
2220: 030C 000A      sub     r12,#%000a
2224: 5F00 3582      call    %3582
2228: 840C           orb     rl4,rh0
222A: 9E08           ret     
222C: 4D05 A800 0028 ld      %a800,#%0028
2232: 6101 8144      ld      r1,%8144
2236: 0701 0003      and     r1,#%0003
223A: 6018 22D8      ldb     rl0,%22d8(r1)
223E: 8C08           clrb    rh0
2240: 6F00 A802      ld      %a802,r0
2244: E81D           jr      %2280
2246: 4D05 A800 0028 ld      %a800,#%0028
224C: 6101 8148      ld      r1,%8148
2250: 0701 0003      and     r1,#%0003
2254: B311 0003      sll     r1,#3
2258: 6100 8146      ld      r0,%8146
225C: 0700 0003      and     r0,#%0003
2260: B301 0005      sll     r0,#5
2264: 8501           or      r1,r0
2266: 6100 801C      ld      r0,%801c
226A: 0700 0003      and     r0,#%0003
226E: B301 0007      sll     r0,#7
2272: 8501           or      r1,r0
2274: 6018 3CF0      ldb     rl0,%3cf0(r1)
2278: 0700 007F      and     r0,#%007f
227C: 6F00 A802      ld      %a802,r0
2280: 4D05 A824 0000 ld      %a824,#%0000
2286: 4D05 A810 0000 ld      %a810,#%0000
228C: 4D05 A812 0004 ld      %a812,#%0004
2292: 4D05 A814 0000 ld      %a814,#%0000
2298: 4D05 A816 0000 ld      %a816,#%0000
229E: 4D05 A820 0000 ld      %a820,#%0000
22A4: 4D05 A822 0000 ld      %a822,#%0000
22AA: 9E08           ret     
22AC: 4D05 A848 0000 ld      %a848,#%0000
22B2: 4D05 A850 0000 ld      %a850,#%0000
22B8: 4D05 A852 0004 ld      %a852,#%0004
22BE: 4D05 A854 0000 ld      %a854,#%0000
22C4: 4D05 A856 0000 ld      %a856,#%0000
22CA: 4D05 A84A 0000 ld      %a84a,#%0000
22D0: 4D05 A84C 0000 ld      %a84c,#%0000
22D6: 9E08           ret     
22D8: 5A78 6E78      divl    rq8,%6e78(r7)
22DC: DFE0           calr    %231e
22DE: DFD1           calr    %233e
22E0: D1FB           calr    %1eec
22E2: DFCA           calr    %2350
22E4: 4D08 80FE      clr     %80fe
22E8: 4D04 81BC      test    %81bc
22EC: 9E0E           ret     ne/nz
22EE: 6100 8188      ld      r0,%8188
22F2: 8D04           test    r0
22F4: ED01           jr      pl,%22f8
22F6: 8D02           neg     r0
22F8: 0B00 4C00      cp      r0,#%4c00
22FC: 9E02           ret     le
22FE: 0300 2000      sub     r0,#%2000
2302: 8D02           neg     r0
2304: A008           ldb     rl0,rh0
2306: B100           extsb   r0
2308: 6F00 81BC      ld      %81bc,r0
230C: 8D02           neg     r0
230E: B301 FFFD      srl     r0,#3
2312: 4D04 8104      test    %8104
2316: 9E0E           ret     ne/nz
2318: 6F00 80FE      ld      %80fe,r0
231C: 9E08           ret     
231E: 4D04 81F6      test    %81f6
2322: EE03           jr      ne/nz,%232a
2324: 4D04 A802      test    %a802
2328: 9E0E           ret     ne/nz
232A: 4D05 81BC FEA2 ld      %81bc,#%fea2
2330: 4D04 818C      test    %818c
2334: 9E0E           ret     ne/nz
2336: 4D05 8016 0001 ld      %8016,#%0001
233C: 9E08           ret     
233E: 6100 8C60      ld      r0,%8c60
2342: 0A08 0404      cpb     rl0,#%04
2346: 9E0E           ret     ne/nz
2348: 4D05 81BC FEA2 ld      %81bc,#%fea2
234E: 9E08           ret     
2350: 6100 81FC      ld      r0,%81fc
2354: 4B00 8280      cp      r0,%8280
2358: EA09           jr      gt,%236c
235A: E604           jr      eq/z,%2364
235C: 4D05 81F8 0000 ld      %81f8,#%0000
2362: 9E08           ret     
2364: 4D01 8184 FB40 cp      %8184,#%fb40
236A: E7F8           jr      c/ult,%235c
236C: 4D05 81F8 0001 ld      %81f8,#%0001
2372: 9E08           ret     
2374: DFF3           calr    %2390
2376: D01D           calr    %233e
2378: D247           calr    %1eec
237A: D016           calr    %2350
237C: 6101 8282      ld      r1,%8282
2380: A113           ld      r3,r1
2382: 9930           mult    rr0,r3
2384: B305 FFF8      srll    rr0,#8
2388: A910           inc     r1,1
238A: 6F01 81BE      ld      %81be,r1
238E: 9E08           ret     
2390: 6100 8184      ld      r0,%8184
2394: 4100 8290      add     r0,%8290
2398: 0B00 0A00      cp      r0,#%0a00
239C: 9E02           ret     le
239E: 0B00 1000      cp      r0,#%1000
23A2: 9E09           ret     ge
23A4: 4D05 8016 0001 ld      %8016,#%0001
23AA: 9E08           ret     
23AC: 4D04 8150      test    %8150
23B0: 9E06           ret     eq/z
23B2: 6100 8150      ld      r0,%8150
23B6: 6B00 8150      dec     %8150,1
23BA: 210C 9AD2      ld      r12,#%9ad2
23BE: A704           bit     r0,4
23C0: E60B           jr      eq/z,%23d8
23C2: 5F00 3582      call    %3582
23C6: 0645           andb    rh5,@r4
23C8: 5854 454E      multl   rq4,%454e(r5)
23CC: 4445 4420      orb     rh5,%4420(r4)
23D0: 504C 4159      cpl     rr12,%4159(r4)
23D4: 2140           ld      r0,@r4
23D6: 9E08           ret     
23D8: 5F00 3582      call    %3582
23DC: 8114           add     r4,r1
23DE: 9E08           ret     
23E0: 91F0           pushl   @r15,rr0
23E2: 91F2           pushl   @r15,rr2
23E4: 91FA           pushl   @r15,rr10
23E6: 9402           ldl     rr2,rr0
23E8: 210A 0005      ld      r10,#%0005
23EC: 210B 0001      ld      r11,#%0001
23F0: B325 0004      slll    rr2,#4
23F4: A028           ldb     rl0,rh2
23F6: 0608 0F0F      andb    rl0,#%0f
23FA: 8DB4           test    r11
23FC: E605           jr      eq/z,%2408
23FE: 8C84           testb   rl0
2400: EE02           jr      ne/nz,%2406
2402: C824           ldb     rl0,#%24
2404: E801           jr      %2408
2406: 8DB8           clr     r11
2408: 2FC0           ld      @r12,r0
240A: A9C1           inc     r12,2
240C: FA8F           djnz    r10,%23f0
240E: B321 0004      sll     r2,#4
2412: A028           ldb     rl0,rh2
2414: 0608 0F0F      andb    rl0,#%0f
2418: 2FC0           ld      @r12,r0
241A: A9C1           inc     r12,2
241C: 95FA           popl    rr10,@r15
241E: 95F2           popl    rr2,@r15
2420: 95F0           popl    rr0,@r15
2422: 9E08           ret     
2424: 91F0           pushl   @r15,rr0
2426: 91FA           pushl   @r15,rr10
2428: 210A 0002      ld      r10,#%0002
242C: 210B 0001      ld      r11,#%0001
2430: A018           ldb     rl0,rh1
2432: 0608 0F0F      andb    rl0,#%0f
2436: 8DB4           test    r11
2438: E605           jr      eq/z,%2444
243A: 8C84           testb   rl0
243C: EE02           jr      ne/nz,%2442
243E: C824           ldb     rl0,#%24
2440: E801           jr      %2444
2442: 8DB8           clr     r11
2444: 2FC0           ld      @r12,r0
2446: A9C1           inc     r12,2
2448: B311 0004      sll     r1,#4
244C: FA8F           djnz    r10,%2430
244E: A018           ldb     rl0,rh1
2450: 0608 0F0F      andb    rl0,#%0f
2454: 2FC0           ld      @r12,r0
2456: A9C1           inc     r12,2
2458: 95FA           popl    rr10,@r15
245A: 95F0           popl    rr0,@r15
245C: 9E08           ret     
245E: A9C1           inc     r12,2
2460: 91F0           pushl   @r15,rr0
2462: B311 0004      sll     r1,#4
2466: A018           ldb     rl0,rh1
2468: 0608 0F0F      andb    rl0,#%0f
246C: 2FC0           ld      @r12,r0
246E: A9C1           inc     r12,2
2470: B311 0004      sll     r1,#4
2474: A018           ldb     rl0,rh1
2476: 0608 0F0F      andb    rl0,#%0f
247A: 2FC0           ld      @r12,r0
247C: A9C1           inc     r12,2
247E: 95F0           popl    rr0,@r15
2480: 9E08           ret     
2482: 8D98           clr     r9
2484: 2106 8039      ld      r6,#%8039
2488: E804           jr      %2492
248A: 2109 0001      ld      r9,#%0001
248E: 2106 A901      ld      r6,#%a901
2492: 6700 80EE      bit     %80ee,0
2496: E603           jr      eq/z,%249e
2498: 0106 0018      add     r6,#%0018
249C: E813           jr      %24c4
249E: 210C 9C88      ld      r12,#%9c88
24A2: 210D 0006      ld      r13,#%0006
24A6: 6104 8034      ld      r4,%8034
24AA: 6105 8036      ld      r5,%8036
24AE: 0705 0001      and     r5,#%0001
24B2: A0D4           ldb     rh4,rl5
24B4: A145           ld      r5,r4
24B6: 0304 0005      sub     r4,#%0005
24BA: E829           jr      %250e
24BC: 2106 A919      ld      r6,#%a919
24C0: 2109 0001      ld      r9,#%0001
24C4: 210C 9C08      ld      r12,#%9c08
24C8: 210D 0007      ld      r13,#%0007
24CC: 6104 8034      ld      r4,%8034
24D0: 6105 8036      ld      r5,%8036
24D4: 0705 0001      and     r5,#%0001
24D8: A0D4           ldb     rh4,rl5
24DA: A145           ld      r5,r4
24DC: 0304 0003      sub     r4,#%0003
24E0: E816           jr      %250e
24E2: 210C 9C88      ld      r12,#%9c88
24E6: 2109 0001      ld      r9,#%0001
24EA: 210D 0006      ld      r13,#%0006
24EE: 2106 8039      ld      r6,#%8039
24F2: 6105 81AC      ld      r5,%81ac
24F6: 8D48           clr     r4
24F8: 1B04 000F      div     rr4,#%000f
24FC: 8D48           clr     r4
24FE: 1B04 0006      div     rr4,#%0006
2502: 8D42           neg     r4
2504: 0104 0006      add     r4,#%0006
2508: A145           ld      r5,r4
250A: 2104 0001      ld      r4,#%0001
250E: 2107 0825      ld      r7,#%0825
2512: 8D44           test    r4
2514: E556           jr      mi,%25c2
2516: E655           jr      eq/z,%25c2
2518: 8B54           cp      r4,r5
251A: EE06           jr      ne/nz,%2528
251C: 6100 8102      ld      r0,%8102
2520: 0100 0008      add     r0,#%0008
2524: A087           ldb     rh7,rl0
2526: E801           jr      %252a
2528: C708           ldb     rh7,#%08
252A: A141           ld      r1,r4
252C: 5F00 3532      call    %3532
2530: A070           ldb     rh0,rh7
2532: 8C88           clrb    rl0
2534: D089           calr    %2424
2536: A9C1           inc     r12,2
2538: 2069           ldb     rl1,@r6
253A: 6061 0002      ldb     rh1,%0002(r6)
253E: A963           inc     r6,4
2540: 5F00 3532      call    %3532
2544: B305 0004      slll    rr0,#4
2548: A070           ldb     rh0,rh7
254A: D0B6           calr    %23e0
254C: A9C3           inc     r12,4
254E: 2069           ldb     rl1,@r6
2550: 6061 0002      ldb     rh1,%0002(r6)
2554: A963           inc     r6,4
2556: 8D14           test    r1
2558: E60D           jr      eq/z,%2574
255A: 5F00 3532      call    %3532
255E: A112           ld      r2,r1
2560: B305 FFF8      srll    rr0,#8
2564: A070           ldb     rh0,rh7
2566: D0A2           calr    %2424
2568: A121           ld      r1,r2
256A: 8C18           clrb    rh1
256C: D088           calr    %245e
256E: 6FC7 FFFA      ld      %fffa(r12),r7
2572: E802           jr      %2578
2574: 010C 000C      add     r12,#%000c
2578: 010C 0004      add     r12,#%0004
257C: 2103 0003      ld      r3,#%0003
2580: 2069           ldb     rl1,@r6
2582: 6061 0002      ldb     rh1,%0002(r6)
2586: A963           inc     r6,4
2588: B305 0001      slll    rr0,#1
258C: 8D88           clr     r8
258E: B305 0005      slll    rr0,#5
2592: 0700 001F      and     r0,#%001f
2596: A102           ld      r2,r0
2598: 6028 25C8      ldb     rl0,%25c8(r2)
259C: A070           ldb     rh0,rh7
259E: 8D94           test    r9
25A0: EE07           jr      ne/nz,%25b0
25A2: 0A00 0808      cpb     rh0,#%08
25A6: E604           jr      eq/z,%25b0
25A8: 4B08 82B0      cp      r8,%82b0
25AC: E601           jr      eq/z,%25b0
25AE: C008           ldb     rh0,#%08
25B0: 2FC0           ld      @r12,r0
25B2: A981           inc     r8,2
25B4: A9C1           inc     r12,2
25B6: F395           djnz    r3,%258e
25B8: 010C 0052      add     r12,#%0052
25BC: A940           inc     r4,1
25BE: FDD7           djnz    r13,%2512
25C0: 9E08           ret     
25C2: A96B           inc     r6,12
25C4: A940           inc     r4,1
25C6: E8A5           jr      %2512
25C8: 240A 0B0C      setb    rl3,r10
25CC: 0D0E           .word   #%0d0e
25CE: 0F10           ext0f   #%10
25D0: 1112           pushl   @r1,@r2
25D2: 1314           push    @r1,@r4
25D4: 1516           popl    @r6,@r1
25D6: 1718           pop     @r8,@r1
25D8: 191A           mult    rr10,@r1
25DA: 1B1C           div     rr12,@r1
25DC: 1D1E           ldl     @r1,rr14
25DE: 1F20           call    r2
25E0: 2122           ld      r2,@r2
25E2: 2325           res     @r2,5
25E4: 2424           setb    @r2,4
25E6: 2424           setb    @r2,4
25E8: 4D04 A840      test    %a840
25EC: E66C           jr      eq/z,%26c6
25EE: 6B00 A840      dec     %a840,1
25F2: 4D01 A840 0096 cp      %a840,#%0096
25F8: E90B           jr      ge,%2610
25FA: 4D01 A840 003C cp      %a840,#%003c
2600: E90E           jr      ge,%261e
2602: 2104 0000      ld      r4,#%0000
2606: 2105 0005      ld      r5,#%0005
260A: 6106 8102      ld      r6,%8102
260E: E80D           jr      %262a
2610: 6104 8102      ld      r4,%8102
2614: 2105 0000      ld      r5,#%0000
2618: 2106 0000      ld      r6,#%0000
261C: E806           jr      %262a
261E: 2104 0000      ld      r4,#%0000
2622: 6105 8102      ld      r5,%8102
2626: 2106 0000      ld      r6,#%0000
262A: A0C0           ldb     rh0,rl4
262C: 210C 9D92      ld      r12,#%9d92
2630: 5F00 3578      call    %3578
2634: 4C41 5020 5449 cpb     %5020(r4),#%20
263A: 4D45 2020 202E ld      %2020(r4),#%202e
2640: 40FF ABC5      addb    rl7,%abc5(r15)
2644: 6101 A82A      ld      r1,%a82a
2648: AC19           exb     rl1,rh1
264A: D0F6           calr    %2460
264C: AC19           exb     rl1,rh1
264E: D0F9           calr    %245e
2650: A0D0           ldb     rh0,rl5
2652: 4D04 81FA      test    %81fa
2656: E61C           jr      eq/z,%2690
2658: 210C 9E08      ld      r12,#%9e08
265C: 5F00 3578      call    %3578
2660: 504F 5349      cpl     rr15,%5349(r4)
2664: 5449 4F4E      ldl     rr9,%4f4e(r4)
2668: 2040           ldb     rh0,@r4
266A: 2100 0008      ld      r0,#%0008
266E: 2101 0001      ld      r1,#%0001
2672: 6102 81FA      ld      r2,%81fa
2676: 0702 0007      and     r2,#%0007
267A: A920           inc     r2,1
267C: 8AA9           cpb     rl1,rl2
267E: EE02           jr      ne/nz,%2684
2680: A0D1           ldb     rh1,rl5
2682: E801           jr      %2686
2684: C100           ldb     rh1,#%00
2686: 2FC1           ld      @r12,r1
2688: A9C3           inc     r12,4
268A: A890           incb    rl1,1
268C: F089           djnz    r0,%267c
268E: E80C           jr      %26a8
2690: 210C 9E12      ld      r12,#%9e12
2694: 5F00 3578      call    %3578
2698: 504F 4C45      cpl     rr15,%4c45(r4)
269C: 2050           ldb     rh0,@r5
269E: 4F53           .word   #%4f53
26A0: 4954 494F      xor     r4,%494f(r5)
26A4: 4E21 40FF      ldb     %40ff(r2),rh1
26A8: A0E0           ldb     rh0,rl6
26AA: 210C 9E98      ld      r12,#%9e98
26AE: 5F00 3578      call    %3578
26B2: 424F 4E55      subb    rl7,%4e55(r4)
26B6: 5320 40FF      push    @r2,%40ff
26BA: 6101 A842      ld      r1,%a842
26BE: D14E           calr    %2424
26C0: C800           ldb     rl0,#%00
26C2: 2FC0           ld      @r12,r0
26C4: 9E08           ret     
26C6: 6B00 82A2      dec     %82a2,1
26CA: EE9B           jr      ne/nz,%2602
26CC: 4D05 82A2 0008 ld      %82a2,#%0008
26D2: 6100 A842      ld      r0,%a842
26D6: 8D04           test    r0
26D8: E694           jr      eq/z,%2602
26DA: E593           jr      mi,%2602
26DC: 2101 0020      ld      r1,#%0020
26E0: 8298           subb    rl0,rl1
26E2: B080           dab     rl0
26E4: B610           sbcb    rh0,rh1
26E6: B000           dab     rh0
26E8: 6F00 A842      ld      %a842,r0
26EC: 1402 0002 0000 ldl     rr2,#%00020000
26F2: 5400 81B8      ldl     rr0,%81b8
26F6: D332           calr    %2094
26F8: 5D00 81B8      ldl     %81b8,rr0
26FC: 6507 80EE      set     %80ee,7
2700: 5E08 2602      jp      %2602
2704: DF94           calr    %27de
2706: DF41           calr    %2886
2708: DEC2           calr    %2986
270A: DE4C           calr    %2a74
270C: DE14           calr    %2ae6
270E: DE09           calr    %2afe
2710: DD28           calr    %2cc2
2712: DCC3           calr    %2d8e
2714: DC27           calr    %2ec8
2716: DC10           calr    %2ef8
2718: DBFB           calr    %2f24
271A: 2103 005A      ld      r3,#%005a
271E: 6707 8148      bit     %8148,7
2722: E602           jr      eq/z,%2728
2724: 2103 0050      ld      r3,#%0050
2728: 6101 821C      ld      r1,%821c
272C: 0101 01F4      add     r1,#%01f4
2730: 1900 001E      mult    rr0,#%001e
2734: 9B30           div     rr0,r3
2736: E607           jr      eq/z,%2746
2738: 0501 0001      or      r1,#%0001
273C: 0B01 1000      cp      r1,#%1000
2740: E102           jr      lt,%2746
2742: 2101 0FFF      ld      r1,#%0fff
2746: A113           ld      r3,r1
2748: A0B3           ldb     rh3,rl3
274A: 6F03 80F2      ld      %80f2,r3
274E: B311 FFFA      srl     r1,#6
2752: A091           ldb     rh1,rl1
2754: 6F01 80F4      ld      %80f4,r1
2758: 6101 818C      ld      r1,%818c
275C: 1900 0064      mult    rr0,#%0064
2760: 1B00 0078      div     rr0,#%0078
2764: 0B01 0000      cp      r1,#%0000
2768: E106           jr      lt,%2776
276A: 0B01 00FF      cp      r1,#%00ff
276E: E205           jr      le,%277a
2770: 2101 00FF      ld      r1,#%00ff
2774: E802           jr      %277a
2776: 2101 0000      ld      r1,#%0000
277A: 6F01 80E0      ld      %80e0,r1
277E: 4D01 8C60 8004 cp      %8c60,#%8004
2784: 9E0E           ret     ne/nz
2786: 4D01 8C7C 0064 cp      %8c7c,#%0064
278C: 9E0E           ret     ne/nz
278E: 610E 81B0      ld      r14,%81b0
2792: 070E 007E      and     r14,#%007e
2796: 4DE5 AA00 0008 ld      %aa00(r14),#%0008
279C: A9E1           inc     r14,2
279E: 070E 007E      and     r14,#%007e
27A2: 4DE5 AA00 FFFF ld      %aa00(r14),#%ffff
27A8: 6F0E 81B0      ld      %81b0,r14
27AC: 9E08           ret     
27AE: 0B01 0017      cp      r1,#%0017
27B2: E94F           jr      ge,%2852
27B4: 0B01 0013      cp      r1,#%0013
27B8: E906           jr      ge,%27c6
27BA: 4D08 821E      clr     %821e
27BE: E849           jr      %2852
27C0: 0B01 002C      cp      r1,#%002c
27C4: E246           jr      le,%2852
27C6: 6100 8100      ld      r0,%8100
27CA: A906           inc     r0,7
27CC: 0700 000F      and     r0,#%000f
27D0: EE40           jr      ne/nz,%2852
27D2: 4D04 821E      test    %821e
27D6: E63D           jr      eq/z,%2852
27D8: 6B00 821E      dec     %821e,1
27DC: E83A           jr      %2852
27DE: 6101 821C      ld      r1,%821c
27E2: A019           ldb     rl1,rh1
27E4: 8C18           clrb    rh1
27E6: 0B01 003F      cp      r1,#%003f
27EA: E202           jr      le,%27f0
27EC: 2101 003F      ld      r1,#%003f
27F0: 6700 801A      bit     %801a,0
27F4: E6E2           jr      eq/z,%27ba
27F6: 4D04 81BC      test    %81bc
27FA: EEE5           jr      ne/nz,%27c6
27FC: 0B01 001E      cp      r1,#%001e
2800: E2D6           jr      le,%27ae
2802: 0B01 002A      cp      r1,#%002a
2806: E9DC           jr      ge,%27c0
2808: 6102 821E      ld      r2,%821e
280C: 0B02 000C      cp      r2,#%000c
2810: E20F           jr      le,%2830
2812: 0B02 0018      cp      r2,#%0018
2816: E215           jr      le,%2842
2818: 0B02 0040      cp      r2,#%0040
281C: E91A           jr      ge,%2852
281E: 6100 8100      ld      r0,%8100
2822: A906           inc     r0,7
2824: 0700 00FF      and     r0,#%00ff
2828: EE14           jr      ne/nz,%2852
282A: 6900 821E      inc     %821e,1
282E: E811           jr      %2852
2830: 6100 8100      ld      r0,%8100
2834: A906           inc     r0,7
2836: 0700 003F      and     r0,#%003f
283A: EE0B           jr      ne/nz,%2852
283C: 6900 821E      inc     %821e,1
2840: E808           jr      %2852
2842: 6100 8100      ld      r0,%8100
2846: A906           inc     r0,7
2848: 0700 007F      and     r0,#%007f
284C: EE02           jr      ne/nz,%2852
284E: 6900 821E      inc     %821e,1
2852: 6019 3EF0      ldb     rl1,%3ef0(r1)
2856: 8C18           clrb    rh1
2858: 4101 821E      add     r1,%821e
285C: 0B01 006A      cp      r1,#%006a
2860: E102           jr      lt,%2866
2862: 2101 0069      ld      r1,#%0069
2866: 5900 8190      mult    rr0,%8190
286A: B305 FFFD      srll    rr0,#3
286E: 6F01 8220      ld      %8220,r1
2872: 6101 821C      ld      r1,%821c
2876: 8D08           clr     r0
2878: 1B00 0320      div     rr0,#%0320
287C: 0101 000A      add     r1,#%000a
2880: 6F01 823A      ld      %823a,r1
2884: 9E08           ret     
2886: 4D05 8226 000A ld      %8226,#%000a
288C: 4D04 8104      test    %8104
2890: EE04           jr      ne/nz,%289a
2892: 6700 801A      bit     %801a,0
2896: EE05           jr      ne/nz,%28a2
2898: E807           jr      %28a8
289A: 4D01 818C 0064 cp      %818c,#%0064
28A0: E103           jr      lt,%28a8
28A2: 4D05 8226 0005 ld      %8226,#%0005
28A8: 4D04 8204      test    %8204
28AC: E644           jr      eq/z,%2936
28AE: 6100 8228      ld      r0,%8228
28B2: 4300 821C      sub     r0,%821c
28B6: A101           ld      r1,r0
28B8: 8D04           test    r0
28BA: ED01           jr      pl,%28be
28BC: 8D02           neg     r0
28BE: 0B00 00C8      cp      r0,#%00c8
28C2: E248           jr      le,%2954
28C4: 8D14           test    r1
28C6: E51B           jr      mi,%28fe
28C8: 6101 8220      ld      r1,%8220
28CC: 0101 003C      add     r1,#%003c
28D0: 1900 0006      mult    rr0,#%0006
28D4: 4101 821C      add     r1,%821c
28D8: 6F01 821C      ld      %821c,r1
28DC: 6103 8228      ld      r3,%8228
28E0: A934           inc     r3,5
28E2: 1900 0005      mult    rr0,#%0005
28E6: 9B30           div     rr0,r3
28E8: 8D12           neg     r1
28EA: 0101 0009      add     r1,#%0009
28EE: 5900 823A      mult    rr0,%823a
28F2: 1B00 0004      div     rr0,#%0004
28F6: 8D12           neg     r1
28F8: 6F01 822C      ld      %822c,r1
28FC: 9E08           ret     
28FE: 6101 8220      ld      r1,%8220
2902: 0301 0040      sub     r1,#%0040
2906: 1900 0006      mult    rr0,#%0006
290A: 4101 821C      add     r1,%821c
290E: ED01           jr      pl,%2912
2910: 8D18           clr     r1
2912: 6F01 821C      ld      %821c,r1
2916: A914           inc     r1,5
2918: 6103 8228      ld      r3,%8228
291C: 1902 0005      mult    rr2,#%0005
2920: 9B12           div     rr2,r1
2922: 8D32           neg     r3
2924: 0103 0009      add     r3,#%0009
2928: 5902 8220      mult    rr2,%8220
292C: 1B02 0004      div     rr2,#%0004
2930: 6F03 822C      ld      %822c,r3
2934: 9E08           ret     
2936: 6101 8220      ld      r1,%8220
293A: 0301 000A      sub     r1,#%000a
293E: 1900 000A      mult    rr0,#%000a
2942: 4101 821C      add     r1,%821c
2946: ED01           jr      pl,%294a
2948: 8D18           clr     r1
294A: 6F01 821C      ld      %821c,r1
294E: 4D08 822C      clr     %822c
2952: 9E08           ret     
2954: 6101 8228      ld      r1,%8228
2958: 6F01 821C      ld      %821c,r1
295C: 6101 8220      ld      r1,%8220
2960: 5900 8226      mult    rr0,%8226
2964: 1900 0020      mult    rr0,#%0020
2968: 4B01 824C      cp      r1,%824c
296C: E105           jr      lt,%2978
296E: 6101 8220      ld      r1,%8220
2972: 6F01 822C      ld      %822c,r1
2976: 9E08           ret     
2978: 6101 8220      ld      r1,%8220
297C: 4301 823A      sub     r1,%823a
2980: 6F01 822C      ld      %822c,r1
2984: 9E08           ret     
2986: DFFD           calr    %298e
2988: DFE4           calr    %29c2
298A: DFBE           calr    %2a10
298C: 9E08           ret     
298E: 6101 822C      ld      r1,%822c
2992: 0B01 005D      cp      r1,#%005d
2996: E202           jr      le,%299c
2998: 2101 005D      ld      r1,#%005d
299C: 5900 8226      mult    rr0,%8226
29A0: 1900 0020      mult    rr0,#%0020
29A4: 6103 8194      ld      r3,%8194
29A8: 1902 05DC      mult    rr2,#%05dc
29AC: 8331           sub     r1,r3
29AE: 6F01 8484      ld      %8484,r1
29B2: 4D04 8258      test    %8258
29B6: 9E0E           ret     ne/nz
29B8: 8D14           test    r1
29BA: 9E0D           ret     pl
29BC: 4D08 8484      clr     %8484
29C0: 9E08           ret     
29C2: 6101 8484      ld      r1,%8484
29C6: 0B01 3A98      cp      r1,#%3a98
29CA: EA1A           jr      gt,%2a00
29CC: 0B01 C568      cp      r1,#%c568
29D0: E11B           jr      lt,%2a08
29D2: 6101 8258      ld      r1,%8258
29D6: 8D14           test    r1
29D8: ED01           jr      pl,%29dc
29DA: 8D18           clr     r1
29DC: 1900 0003      mult    rr0,#%0003
29E0: 1B00 0014      div     rr0,#%0014
29E4: A113           ld      r3,r1
29E6: 8D12           neg     r1
29E8: 4101 8482      add     r1,%8482
29EC: A112           ld      r2,r1
29EE: 8D14           test    r1
29F0: ED01           jr      pl,%29f4
29F2: 8D12           neg     r1
29F4: 0B01 0037      cp      r1,#%0037
29F8: 9E09           ret     ge
29FA: 4D08 8480      clr     %8480
29FE: 9E08           ret     
2A00: 4D05 8480 0001 ld      %8480,#%0001
2A06: 9E08           ret     
2A08: 4D05 8480 FFFF ld      %8480,#%ffff
2A0E: 9E08           ret     
2A10: 4D04 8480      test    %8480
2A14: E514           jr      mi,%2a3e
2A16: E627           jr      eq/z,%2a66
2A18: 8D24           test    r2
2A1A: E514           jr      mi,%2a44
2A1C: 6101 8484      ld      r1,%8484
2A20: 0301 2328      sub     r1,#%2328
2A24: B10A           exts    rr0
2A26: 1B00 01F4      div     rr0,#%01f4
2A2A: 4101 8482      add     r1,%8482
2A2E: ED01           jr      pl,%2a32
2A30: 8D18           clr     r1
2A32: 6F01 8482      ld      %8482,r1
2A36: 4D05 8240 2328 ld      %8240,#%2328
2A3C: 9E08           ret     
2A3E: 8D24           test    r2
2A40: E601           jr      eq/z,%2a44
2A42: EDEC           jr      pl,%2a1c
2A44: 6101 8484      ld      r1,%8484
2A48: 0101 2710      add     r1,#%2710
2A4C: B10A           exts    rr0
2A4E: 1B00 01F4      div     rr0,#%01f4
2A52: 4101 8482      add     r1,%8482
2A56: ED01           jr      pl,%2a5a
2A58: 8D18           clr     r1
2A5A: 6F01 8482      ld      %8482,r1
2A5E: 4D05 8240 D8F0 ld      %8240,#%d8f0
2A64: 9E08           ret     
2A66: 6F03 8482      ld      %8482,r3
2A6A: 6101 8484      ld      r1,%8484
2A6E: 6F01 8240      ld      %8240,r1
2A72: 9E08           ret     
2A74: 6101 8482      ld      r1,%8482
2A78: 5900 8226      mult    rr0,%8226
2A7C: 1000 0000 7D00 cpl     rr0,#%00007d00
2A82: E102           jr      lt,%2a88
2A84: 2101 7D00      ld      r1,#%7d00
2A88: 6F01 8228      ld      %8228,r1
2A8C: 6101 8258      ld      r1,%8258
2A90: 8D08           clr     r0
2A92: 1B00 0064      div     rr0,#%0064
2A96: A113           ld      r3,r1
2A98: 9930           mult    rr0,r3
2A9A: 5D00 8268      ldl     %8268,rr0
2A9E: 6103 8248      ld      r3,%8248
2AA2: 1902 04B0      mult    rr2,#%04b0
2AA6: 9602           addl    rr2,rr0
2AA8: B305 FFFE      srll    rr0,#2
2AAC: 9602           addl    rr2,rr0
2AAE: B305 FFFE      srll    rr0,#2
2AB2: 9602           addl    rr2,rr0
2AB4: B305 FFFF      srll    rr0,#1
2AB8: 9602           addl    rr2,rr0
2ABA: B325 FFFF      srll    rr2,#1
2ABE: 6F03 824C      ld      %824c,r3
2AC2: 6101 8240      ld      r1,%8240
2AC6: B10A           exts    rr0
2AC8: 9220           subl    rr0,rr2
2ACA: B30D FFFE      sral    rr0,#2
2ACE: 6F01 8254      ld      %8254,r1
2AD2: B319 FFFA      sra     r1,#6
2AD6: 4101 8258      add     r1,%8258
2ADA: 6F01 8258      ld      %8258,r1
2ADE: 9E0D           ret     pl
2AE0: 4D08 8258      clr     %8258
2AE4: 9E08           ret     
2AE6: 5400 8268      ldl     rr0,%8268
2AEA: A019           ldb     rl1,rh1
2AEC: A081           ldb     rh1,rl0
2AEE: A008           ldb     rl0,rh0
2AF0: 5900 825C      mult    rr0,%825c
2AF4: 1B00 000E      div     rr0,#%000e
2AF8: 6F01 8244      ld      %8244,r1
2AFC: 9E08           ret     
2AFE: DFFF           calr    %2b02
2B00: E832           jr      %2b66
2B02: 6100 800C      ld      r0,%800c
2B06: A102           ld      r2,r0
2B08: 6101 819C      ld      r1,%819c
2B0C: A113           ld      r3,r1
2B0E: 6F00 819C      ld      %819c,r0
2B12: 8289           subb    rl1,rl0
2B14: B110           extsb   r1
2B16: A110           ld      r0,r1
2B18: 8D04           test    r0
2B1A: ED01           jr      pl,%2b1e
2B1C: 8D02           neg     r0
2B1E: 0B00 000A      cp      r0,#%000a
2B22: E202           jr      le,%2b28
2B24: 2101 0000      ld      r1,#%0000
2B28: 6F01 81A4      ld      %81a4,r1
2B2C: 6101 8218      ld      r1,%8218
2B30: 6F01 81A0      ld      %81a0,r1
2B34: 5900 824A      mult    rr0,%824a
2B38: 1B00 000A      div     rr0,#%000a
2B3C: 4301 8198      sub     r1,%8198
2B40: 8D12           neg     r1
2B42: 5900 818C      mult    rr0,%818c
2B46: B30D FFFD      sral    rr0,#3
2B4A: A112           ld      r2,r1
2B4C: B329 FFFF      sra     r2,#1
2B50: 8121           add     r1,r2
2B52: 4101 8188      add     r1,%8188
2B56: 9E04           ret     pe/ov
2B58: 6F01 8188      ld      %8188,r1
2B5C: 9E0D           ret     pl
2B5E: A910           inc     r1,1
2B60: 6F01 8188      ld      %8188,r1
2B64: 9E08           ret     
2B66: 4D04 81F8      test    %81f8
2B6A: 5E0E 2C94      jp      ne/nz,%2c94
2B6E: 4D04 8104      test    %8104
2B72: 5E0E 2C94      jp      ne/nz,%2c94
2B76: 6101 825C      ld      r1,%825c
2B7A: A110           ld      r0,r1
2B7C: 6103 81A4      ld      r3,%81a4
2B80: 6104 8100      ld      r4,%8100
2B84: 0704 0003      and     r4,#%0003
2B88: EE02           jr      ne/nz,%2b8e
2B8A: 4103 81A6      add     r3,%81a6
2B8E: 4D05 81A6 0000 ld      %81a6,#%0000
2B94: A132           ld      r2,r3
2B96: 4D04 81F4      test    %81f4
2B9A: E65F           jr      eq/z,%2c5a
2B9C: A104           ld      r4,r0
2B9E: 4304 8198      sub     r4,%8198
2BA2: E63E           jr      eq/z,%2c20
2BA4: A145           ld      r5,r4
2BA6: 8D54           test    r5
2BA8: ED01           jr      pl,%2bac
2BAA: 8D52           neg     r5
2BAC: 0B05 0002      cp      r5,#%0002
2BB0: E11F           jr      lt,%2bf0
2BB2: 0B05 0004      cp      r5,#%0004
2BB6: E11F           jr      lt,%2bf6
2BB8: 0B05 0006      cp      r5,#%0006
2BBC: E11F           jr      lt,%2bfc
2BBE: 0B05 0008      cp      r5,#%0008
2BC2: E11F           jr      lt,%2c02
2BC4: 0B05 000A      cp      r5,#%000a
2BC8: E11F           jr      lt,%2c08
2BCA: 0B05 0010      cp      r5,#%0010
2BCE: E106           jr      lt,%2bdc
2BD0: 0B05 0020      cp      r5,#%0020
2BD4: E106           jr      lt,%2be2
2BD6: 2106 0003      ld      r6,#%0003
2BDA: E805           jr      %2be6
2BDC: 2106 0001      ld      r6,#%0001
2BE0: E802           jr      %2be6
2BE2: 2106 0002      ld      r6,#%0002
2BE6: 8D44           test    r4
2BE8: A164           ld      r4,r6
2BEA: ED1B           jr      pl,%2c22
2BEC: 8D42           neg     r4
2BEE: E819           jr      %2c22
2BF0: 2106 001F      ld      r6,#%001f
2BF4: E80B           jr      %2c0c
2BF6: 2106 000F      ld      r6,#%000f
2BFA: E808           jr      %2c0c
2BFC: 2106 0007      ld      r6,#%0007
2C00: E805           jr      %2c0c
2C02: 2106 0003      ld      r6,#%0003
2C06: E802           jr      %2c0c
2C08: 2106 0001      ld      r6,#%0001
2C0C: 8D44           test    r4
2C0E: 2104 0001      ld      r4,#%0001
2C12: ED02           jr      pl,%2c18
2C14: 2104 FFFF      ld      r4,#%ffff
2C18: 6105 8100      ld      r5,%8100
2C1C: 8765           and     r5,r6
2C1E: E601           jr      eq/z,%2c22
2C20: 8D48           clr     r4
2C22: 8D14           test    r1
2C24: ED01           jr      pl,%2c28
2C26: 8D12           neg     r1
2C28: 0B01 0009      cp      r1,#%0009
2C2C: E105           jr      lt,%2c38
2C2E: 0B01 002D      cp      r1,#%002d
2C32: E101           jr      lt,%2c36
2C34: 8132           add     r2,r3
2C36: 8132           add     r2,r3
2C38: 8132           add     r2,r3
2C3A: 8102           add     r2,r0
2C3C: 8342           sub     r2,r4
2C3E: 0B02 FF81      cp      r2,#%ff81
2C42: E106           jr      lt,%2c50
2C44: 0B02 007F      cp      r2,#%007f
2C48: E205           jr      le,%2c54
2C4A: 2102 007F      ld      r2,#%007f
2C4E: E802           jr      %2c54
2C50: 2102 FF81      ld      r2,#%ff81
2C54: 6F02 825C      ld      %825c,r2
2C58: 9E08           ret     
2C5A: 8D48           clr     r4
2C5C: 8D14           test    r1
2C5E: ED01           jr      pl,%2c62
2C60: 8D12           neg     r1
2C62: 0B01 0009      cp      r1,#%0009
2C66: E106           jr      lt,%2c74
2C68: 0B01 002D      cp      r1,#%002d
2C6C: E102           jr      lt,%2c72
2C6E: 8132           add     r2,r3
2C70: 8132           add     r2,r3
2C72: 8132           add     r2,r3
2C74: 8102           add     r2,r0
2C76: 8342           sub     r2,r4
2C78: 0B02 FF81      cp      r2,#%ff81
2C7C: E106           jr      lt,%2c8a
2C7E: 0B02 007F      cp      r2,#%007f
2C82: E205           jr      le,%2c8e
2C84: 2102 007F      ld      r2,#%007f
2C88: E802           jr      %2c8e
2C8A: 2102 FF81      ld      r2,#%ff81
2C8E: 6F02 825C      ld      %825c,r2
2C92: 9E08           ret     
2C94: 4D01 81F0 0003 cp      %81f0,#%0003
2C9A: 9E02           ret     le
2C9C: 6100 825C      ld      r0,%825c
2CA0: 8D02           neg     r0
2CA2: B309 FFFD      sra     r0,#3
2CA6: 4100 825C      add     r0,%825c
2CAA: 6F00 825C      ld      %825c,r0
2CAE: 6101 8188      ld      r1,%8188
2CB2: B10A           exts    rr0
2CB4: 1B00 07D0      div     rr0,#%07d0
2CB8: 4101 825C      add     r1,%825c
2CBC: 6F01 825C      ld      %825c,r1
2CC0: 9E08           ret     
2CC2: 6101 8240      ld      r1,%8240
2CC6: 8D14           test    r1
2CC8: ED01           jr      pl,%2ccc
2CCA: 8D12           neg     r1
2CCC: 8D08           clr     r0
2CCE: 4D04 8194      test    %8194
2CD2: E609           jr      eq/z,%2ce6
2CD4: 4D04 823A      test    %823a
2CD8: E606           jr      eq/z,%2ce6
2CDA: 1200 0000 2710 subl    rr0,#%00002710
2CE0: 1B00 0078      div     rr0,#%0078
2CE4: E805           jr      %2cf0
2CE6: 1200 0000 1F40 subl    rr0,#%00001f40
2CEC: 1B00 0050      div     rr0,#%0050
2CF0: 6102 81F4      ld      r2,%81f4
2CF4: 0702 0001      and     r2,#%0001
2CF8: 6103 8148      ld      r3,%8148
2CFC: B331 FFFA      srl     r3,#6
2D00: 0703 0004      and     r3,#%0004
2D04: 8532           or      r2,r3
2D06: 6028 3F30      ldb     rl0,%3f30(r2)
2D0A: 8C08           clrb    rh0
2D0C: A102           ld      r2,r0
2D0E: A103           ld      r3,r0
2D10: B331 FFFF      srl     r3,#1
2D14: 8310           sub     r0,r1
2D16: 8B20           cp      r0,r2
2D18: E201           jr      le,%2d1c
2D1A: A120           ld      r0,r2
2D1C: 8B30           cp      r0,r3
2D1E: E901           jr      ge,%2d22
2D20: A130           ld      r0,r3
2D22: 6F00 823E      ld      %823e,r0
2D26: 9E08           ret     
2D28: E50D           jr      mi,%2d44
2D2A: 6101 8484      ld      r1,%8484
2D2E: 0301 2710      sub     r1,#%2710
2D32: B10A           exts    rr0
2D34: 1B00 00A0      div     rr0,#%00a0
2D38: 8D12           neg     r1
2D3A: 0101 0064      add     r1,#%0064
2D3E: 6F01 823E      ld      %823e,r1
2D42: E80B           jr      %2d5a
2D44: 6101 8484      ld      r1,%8484
2D48: 0101 07D0      add     r1,#%07d0
2D4C: B10A           exts    rr0
2D4E: 1B00 0140      div     rr0,#%0140
2D52: 0101 0064      add     r1,#%0064
2D56: 6F01 823E      ld      %823e,r1
2D5A: 6101 823E      ld      r1,%823e
2D5E: 0B01 0032      cp      r1,#%0032
2D62: E903           jr      ge,%2d6a
2D64: 4D05 823E 0032 ld      %823e,#%0032
2D6A: 0B01 0064      cp      r1,#%0064
2D6E: E203           jr      le,%2d76
2D70: 4D05 823E 0064 ld      %823e,#%0064
2D76: 4D04 8480      test    %8480
2D7A: 9E06           ret     eq/z
2D7C: 6101 823E      ld      r1,%823e
2D80: 1900 0008      mult    rr0,#%0008
2D84: 1B00 000A      div     rr0,#%000a
2D88: 6F01 823E      ld      %823e,r1
2D8C: 9E08           ret     
2D8E: DFFF           calr    %2d92
2D90: E824           jr      %2dda
2D92: 4D04 8222      test    %8222
2D96: E60D           jr      eq/z,%2db2
2D98: 6701 8222      bit     %8222,1
2D9C: EE14           jr      ne/nz,%2dc6
2D9E: 4D05 8248 0003 ld      %8248,#%0003
2DA4: 4D05 824A 0008 ld      %824a,#%0008
2DAA: 4D05 8276 0004 ld      %8276,#%0004
2DB0: 9E08           ret     
2DB2: 4D05 8248 0001 ld      %8248,#%0001
2DB8: 4D05 824A 000A ld      %824a,#%000a
2DBE: 4D05 8276 0000 ld      %8276,#%0000
2DC4: 9E08           ret     
2DC6: 4D05 8248 000A ld      %8248,#%000a
2DCC: 4D05 824A 0005 ld      %824a,#%0005
2DD2: 4D05 8276 0008 ld      %8276,#%0008
2DD8: 9E08           ret     
2DDA: 6101 8244      ld      r1,%8244
2DDE: 8D14           test    r1
2DE0: ED01           jr      pl,%2de4
2DE2: 8D12           neg     r1
2DE4: A110           ld      r0,r1
2DE6: 8111           add     r1,r1
2DE8: 8111           add     r1,r1
2DEA: 8101           add     r1,r0
2DEC: 6102 823E      ld      r2,%823e
2DF0: A120           ld      r0,r2
2DF2: 8122           add     r2,r2
2DF4: 8102           add     r2,r0
2DF6: 8B12           cp      r2,r1
2DF8: EF33           jr      nc/uge,%2e60
2DFA: 6300 8222      res     %8222,0
2DFE: 8102           add     r2,r0
2E00: 8B12           cp      r2,r1
2E02: EF31           jr      nc/uge,%2e66
2E04: 6500 8222      set     %8222,0
2E08: 8102           add     r2,r0
2E0A: 8B12           cp      r2,r1
2E0C: EF2C           jr      nc/uge,%2e66
2E0E: 6701 8222      bit     %8222,1
2E12: E61C           jr      eq/z,%2e4c
2E14: 4D05 8222 0003 ld      %8222,#%0003
2E1A: 6100 825C      ld      r0,%825c
2E1E: 6F00 827A      ld      %827a,r0
2E22: 6101 8244      ld      r1,%8244
2E26: B10A           exts    rr0
2E28: 1B00 0020      div     rr0,#%0020
2E2C: 4101 8218      add     r1,%8218
2E30: 0B01 FF81      cp      r1,#%ff81
2E34: E106           jr      lt,%2e42
2E36: 0B01 007F      cp      r1,#%007f
2E3A: E205           jr      le,%2e46
2E3C: 2101 007F      ld      r1,#%007f
2E40: E802           jr      %2e46
2E42: 2101 FF81      ld      r1,#%ff81
2E46: 6F01 8218      ld      %8218,r1
2E4A: 9E08           ret     
2E4C: 4D05 8222 0003 ld      %8222,#%0003
2E52: 6100 825C      ld      r0,%825c
2E56: 6F00 827A      ld      %827a,r0
2E5A: 6F00 8218      ld      %8218,r0
2E5E: 9E08           ret     
2E60: 4D05 8222 0000 ld      %8222,#%0000
2E66: 6701 8222      bit     %8222,1
2E6A: EED7           jr      ne/nz,%2e1a
2E6C: 6100 8218      ld      r0,%8218
2E70: 4300 827A      sub     r0,%827a
2E74: 8D04           test    r0
2E76: ED01           jr      pl,%2e7a
2E78: 8D02           neg     r0
2E7A: 0B00 0005      cp      r0,#%0005
2E7E: EA07           jr      gt,%2e8e
2E80: 6100 825C      ld      r0,%825c
2E84: 6F00 827A      ld      %827a,r0
2E88: 6F00 8218      ld      %8218,r0
2E8C: 9E08           ret     
2E8E: 6100 825C      ld      r0,%825c
2E92: 6F00 827A      ld      %827a,r0
2E96: 6101 8258      ld      r1,%8258
2E9A: 4300 8218      sub     r0,%8218
2E9E: ED01           jr      pl,%2ea2
2EA0: 8D12           neg     r1
2EA2: B10A           exts    rr0
2EA4: 1B00 0258      div     rr0,#%0258
2EA8: 4101 8218      add     r1,%8218
2EAC: 0B01 FF81      cp      r1,#%ff81
2EB0: E106           jr      lt,%2ebe
2EB2: 0B01 007F      cp      r1,#%007f
2EB6: E205           jr      le,%2ec2
2EB8: 2101 007F      ld      r1,#%007f
2EBC: E802           jr      %2ec2
2EBE: 2101 FF81      ld      r1,#%ff81
2EC2: 6F01 8218      ld      %8218,r1
2EC6: 9E08           ret     
2EC8: 4D04 8104      test    %8104
2ECC: EE11           jr      ne/nz,%2ef0
2ECE: 6101 8C60      ld      r1,%8c60
2ED2: 0A09 0404      cpb     rl1,#%04
2ED6: E60C           jr      eq/z,%2ef0
2ED8: 6701 8222      bit     %8222,1
2EDC: EE05           jr      ne/nz,%2ee8
2EDE: 6101 8276      ld      r1,%8276
2EE2: 6F01 80E8      ld      %80e8,r1
2EE6: 9E08           ret     
2EE8: 4D05 80E8 000A ld      %80e8,#%000a
2EEE: 9E08           ret     
2EF0: 4D05 80E8 0000 ld      %80e8,#%0000
2EF6: 9E08           ret     
2EF8: 4D04 8104      test    %8104
2EFC: 9E0E           ret     ne/nz
2EFE: 6100 8194      ld      r0,%8194
2F02: 8100           add     r0,r0
2F04: 9E06           ret     eq/z
2F06: 4D01 818C 0002 cp      %818c,#%0002
2F0C: 9E07           ret     c/ult
2F0E: 4100 80E8      add     r0,%80e8
2F12: 6F00 80E8      ld      %80e8,r0
2F16: 0B00 0010      cp      r0,#%0010
2F1A: 9E07           ret     c/ult
2F1C: 4D05 80E8 000F ld      %80e8,#%000f
2F22: 9E08           ret     
2F24: 4D04 8104      test    %8104
2F28: 9E0E           ret     ne/nz
2F2A: 4D04 8480      test    %8480
2F2E: 9E06           ret     eq/z
2F30: 6100 8190      ld      r0,%8190
2F34: 4100 8194      add     r0,%8194
2F38: 4100 80E8      add     r0,%80e8
2F3C: 6F00 80E8      ld      %80e8,r0
2F40: 0B00 0010      cp      r0,#%0010
2F44: 9E07           ret     c/ult
2F46: 4D05 80E8 000F ld      %80e8,#%000f
2F4C: 9E08           ret     
2F4E: DF72           calr    %306c
2F50: 4D01 8000 0059 cp      %8000,#%0059
2F56: 9E0E           ret     ne/nz
2F58: 6100 8002      ld      r0,%8002
2F5C: 0700 00FF      and     r0,#%00ff
2F60: 0B00 0010      cp      r0,#%0010
2F64: E720           jr      c/ult,%2fa6
2F66: 0B00 0019      cp      r0,#%0019
2F6A: E724           jr      c/ult,%2fb4
2F6C: 4D04 813E      test    %813e
2F70: E603           jr      eq/z,%2f78
2F72: 6B00 813E      dec     %813e,1
2F76: 9E08           ret     
2F78: 6101 8100      ld      r1,%8100
2F7C: 0701 000F      and     r1,#%000f
2F80: 9E0E           ret     ne/nz
2F82: 6100 8004      ld      r0,%8004
2F86: 0700 00FF      and     r0,#%00ff
2F8A: 0B00 0012      cp      r0,#%0012
2F8E: E607           jr      eq/z,%2f9e
2F90: 0B00 0013      cp      r0,#%0013
2F94: 9E0E           ret     ne/nz
2F96: DFD5           calr    %2fee
2F98: 6B00 8130      dec     %8130,1
2F9C: 9E08           ret     
2F9E: DFD9           calr    %2fee
2FA0: 6900 8130      inc     %8130,1
2FA4: 9E08           ret     
2FA6: 6101 8130      ld      r1,%8130
2FAA: BE98           rldb    rl0,rl1
2FAC: BE18           rldb    rl0,rh1
2FAE: 6F01 8130      ld      %8130,r1
2FB2: 9E08           ret     
2FB4: 0300 0010      sub     r0,#%0010
2FB8: 8100           add     r0,r0
2FBA: 3401 0006      ldar    pr1,%2fc4
2FBE: 8101           add     r1,r0
2FC0: 2111           ld      r1,@r1
2FC2: 1E18           jp      @rr1
2FC4: 2FD6           ld      @r13,r6
2FC6: 2FEE           ld      @r14,r14
2FC8: 3004 3012      ldrb    rh4,%5fde
2FCC: 3020 3030      ldb     rh0,r2(#%3030)
2FD0: 3040 3050      ldb     rh0,r4(#%3050)
2FD4: 3058 6101      ldb     rl0,r5(#%6101)
2FD8: 8132           add     r2,r3
2FDA: 8111           add     r1,r1
2FDC: 0701 0006      and     r1,#%0006
2FE0: 6102 8130      ld      r2,%8130
2FE4: 0702 FFFE      and     r2,#%fffe
2FE8: 6F12 8134      ld      %8134(r1),r2
2FEC: 9E08           ret     
2FEE: 6101 8132      ld      r1,%8132
2FF2: 8111           add     r1,r1
2FF4: 0701 0006      and     r1,#%0006
2FF8: 6112 8134      ld      r2,%8134(r1)
2FFC: 6103 8130      ld      r3,%8130
3000: 2F23           ld      @r2,r3
3002: 9E08           ret     
3004: D00C           calr    %2fee
3006: 6900 8130      inc     %8130,1
300A: 4D05 813E 0028 ld      %813e,#%0028
3010: 9E08           ret     
3012: D013           calr    %2fee
3014: 6B00 8130      dec     %8130,1
3018: 4D05 813E 0028 ld      %813e,#%0028
301E: 9E08           ret     
3020: 6101 8132      ld      r1,%8132
3024: 8111           add     r1,r1
3026: 0701 0006      and     r1,#%0006
302A: 6911 8134      inc     %8134(r1),2
302E: 9E08           ret     
3030: 6101 8132      ld      r1,%8132
3034: 8111           add     r1,r1
3036: 0701 0006      and     r1,#%0006
303A: 6B11 8134      dec     %8134(r1),2
303E: 9E08           ret     
3040: 6100 8132      ld      r0,%8132
3044: A900           inc     r0,1
3046: 0700 0003      and     r0,#%0003
304A: 6F00 8132      ld      %8132,r0
304E: 9E08           ret     
3050: 4D05 8000 0073 ld      %8000,#%0073
3056: 9E08           ret     
3058: 6101 8132      ld      r1,%8132
305C: 8111           add     r1,r1
305E: 0701 0006      and     r1,#%0006
3062: 6112 8134      ld      r2,%8134(r1)
3066: 0702 FFFE      and     r2,#%fffe
306A: 1E28           jp      @rr2
306C: 4D01 8000 0059 cp      %8000,#%0059
3072: 9E0E           ret     ne/nz
3074: 210D 990C      ld      r13,#%990c
3078: 6100 8130      ld      r0,%8130
307C: DFD5           calr    %30d4
307E: 010D 006E      add     r13,#%006e
3082: 2101 8134      ld      r1,#%8134
3086: 2102 0004      ld      r2,#%0004
308A: 2110           ld      r0,@r1
308C: DFDD           calr    %30d4
308E: A9D1           inc     r13,2
3090: A103           ld      r3,r0
3092: 2130           ld      r0,@r3
3094: DFE1           calr    %30d4
3096: 010D 006E      add     r13,#%006e
309A: A911           inc     r1,2
309C: F28A           djnz    r2,%308a
309E: 4D01 8000 0059 cp      %8000,#%0059
30A4: 9E0E           ret     ne/nz
30A6: 6100 8100      ld      r0,%8100
30AA: 0700 001F      and     r0,#%001f
30AE: 0B00 0008      cp      r0,#%0008
30B2: 9E0F           ret     nc/uge
30B4: 6101 8132      ld      r1,%8132
30B8: 0701 0003      and     r1,#%0003
30BC: B311 0007      sll     r1,#7
30C0: 0101 9982      add     r1,#%9982
30C4: 2102 000A      ld      r2,#%000a
30C8: 2110           ld      r0,@r1
30CA: C824           ldb     rl0,#%24
30CC: 2F10           ld      @r1,r0
30CE: A911           inc     r1,2
30D0: F285           djnz    r2,%30c8
30D2: 9E08           ret     
30D4: 93F4           push    @r15,r4
30D6: 93F5           push    @r15,r5
30D8: A104           ld      r4,r0
30DA: 21D5           ld      r5,@r13
30DC: 8CD8           clrb    rl5
30DE: BE4D           rldb    rl5,rh4
30E0: 2FD5           ld      @r13,r5
30E2: A9D1           inc     r13,2
30E4: BE4D           rldb    rl5,rh4
30E6: 2FD5           ld      @r13,r5
30E8: A9D1           inc     r13,2
30EA: BECD           rldb    rl5,rl4
30EC: 2FD5           ld      @r13,r5
30EE: A9D1           inc     r13,2
30F0: BECD           rldb    rl5,rl4
30F2: 2FD5           ld      @r13,r5
30F4: A9D1           inc     r13,2
30F6: 97F5           pop     r5,@r15
30F8: 97F4           pop     r4,@r15
30FA: 9E08           ret     
30FC: 6104 801C      ld      r4,%801c
3100: 0704 0003      and     r4,#%0003
3104: A141           ld      r1,r4
3106: 8111           add     r1,r1
3108: 611A 3128      ld      r10,%3128(r1)
310C: DFEC           calr    %3136
310E: AB40           dec     r4,1
3110: 2105 0003      ld      r5,#%0003
3114: 0704 0003      and     r4,#%0003
3118: A141           ld      r1,r4
311A: 8111           add     r1,r1
311C: 611A 3128      ld      r10,%3128(r1)
3120: DFF9           calr    %3130
3122: AB40           dec     r4,1
3124: F589           djnz    r5,%3114
3126: 9E08           ret     
3128: 9A8A           divl    rq10,rr8
312A: 9AA4           divl    rq4,rr10
312C: 9C8A           .word   #%9c8a
312E: 9CA4           .word   #%9ca4
3130: 2100 0016      ld      r0,#%0016
3134: E806           jr      %3142
3136: 6100 8100      ld      r0,%8100
313A: 0700 0007      and     r0,#%0007
313E: 0100 0010      add     r0,#%0010
3142: 2102 0006      ld      r2,#%0006
3146: 2103 000A      ld      r3,#%000a
314A: 21A1           ld      r1,@r10
314C: A081           ldb     rh1,rl0
314E: 2FA1           ld      @r10,r1
3150: A9A1           inc     r10,2
3152: F385           djnz    r3,%314a
3154: 010A 002C      add     r10,#%002c
3158: F28A           djnz    r2,%3146
315A: 9E08           ret     
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
3280: 2109 0001      ld      r9,#%0001
3284: 210A 0000      ld      r10,#%0000
3288: 8D08           clr     r0
328A: 210C 2000      ld      r12,#%2000
328E: 00A0           addb    rh0,@r10
3290: A9A0           inc     r10,1
3292: 00A8           addb    rl0,@r10
3294: A9A0           inc     r10,1
3296: FC85           djnz    r12,%328e
3298: A880           incb    rl0,1
329A: EE04           jr      ne/nz,%32a4
329C: A990           inc     r9,1
329E: A800           incb    rh0,1
32A0: EE01           jr      ne/nz,%32a4
32A2: E81A           jr      %32d8
32A4: 210A 0400      ld      r10,#%0400
32A8: 210B 9800      ld      r11,#%9800
32AC: 0DB5 0824      ld      @r11,#%0824
32B0: A9B1           inc     r11,2
32B2: FA84           djnz    r10,%32ac
32B4: 6F09 8092      ld      %8092,r9
32B8: 4D08 8090      clr     %8090
32BC: E8FF           jr      %32bc
32BE: A101           ld      r1,r0
32C0: 0701 000F      and     r1,#%000f
32C4: EEEF           jr      ne/nz,%32a4
32C6: B301 FFFC      srl     r0,#4
32CA: A990           inc     r9,1
32CC: E8F8           jr      %32be
32CE: 0700 00FF      and     r0,#%00ff
32D2: EEE8           jr      ne/nz,%32a4
32D4: A990           inc     r9,1
32D6: E8E6           jr      %32a4
32D8: 210E 0004      ld      r14,#%0004
32DC: 2109 0094      ld      r9,#%0094
32E0: 210B 8100      ld      r11,#%8100
32E4: A1BA           ld      r10,r11
32E6: A1E1           ld      r1,r14
32E8: A1E2           ld      r2,r14
32EA: 210C 0300      ld      r12,#%0300
32EE: A110           ld      r0,r1
32F0: B311 0002      sll     r1,#2
32F4: 8101           add     r1,r0
32F6: A910           inc     r1,1
32F8: 0121           add     r1,@r2
32FA: A921           inc     r2,2
32FC: A110           ld      r0,r1
32FE: 2FA0           ld      @r10,r0
3300: 09A0           xor     r0,@r10
3302: EEDD           jr      ne/nz,%32be
3304: A9A1           inc     r10,2
3306: FC8D           djnz    r12,%32ee
3308: A1E1           ld      r1,r14
330A: A1E2           ld      r2,r14
330C: 210C 0300      ld      r12,#%0300
3310: A110           ld      r0,r1
3312: B311 0002      sll     r1,#2
3316: 8101           add     r1,r0
3318: A910           inc     r1,1
331A: 0121           add     r1,@r2
331C: A921           inc     r2,2
331E: A110           ld      r0,r1
3320: 09B0           xor     r0,@r11
3322: EECD           jr      ne/nz,%32be
3324: A9B1           inc     r11,2
3326: FC8C           djnz    r12,%3310
3328: A993           inc     r9,4
332A: A1BA           ld      r10,r11
332C: A1E1           ld      r1,r14
332E: A1E2           ld      r2,r14
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
3FFE: 2992           inc     @r9,3
