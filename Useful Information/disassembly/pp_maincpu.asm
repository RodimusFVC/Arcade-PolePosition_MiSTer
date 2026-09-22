0000: 31 41 00    ld   sp,$0041
0003: C9          ret
0004: FF          rst  $38
0005: FF          rst  $38
0006: FF          rst  $38
0007: FF          rst  $38
0008: 87          add  a,a
0009: 30 05       jr   nc,$0010
000B: 24          inc  h
000C: C3 10 00    jp   $0010
000F: FF          rst  $38
0010: 85          add  a,l
0011: 6F          ld   l,a
0012: D0          ret  nc
0013: 24          inc  h
0014: C9          ret
0015: FF          rst  $38
0016: FF          rst  $38
0017: FF          rst  $38
0018: 77          ld   (hl),a
0019: 23          inc  hl
001A: 10 FC       djnz $0018
001C: C9          ret
001D: FF          rst  $38
001E: FF          rst  $38
001F: FF          rst  $38
0020: FF          rst  $38
0021: FF          rst  $38
0022: FF          rst  $38
0023: FF          rst  $38
0024: FF          rst  $38
0025: FF          rst  $38
0026: FF          rst  $38
0027: FF          rst  $38
0028: FF          rst  $38
0029: FF          rst  $38
002A: FF          rst  $38
002B: FF          rst  $38
002C: FF          rst  $38
002D: FF          rst  $38
002E: FF          rst  $38
002F: FF          rst  $38
0030: 11 00 90    ld   de,$9000
0033: 06 00       ld   b,$00
0035: C3 B6 00    jp   $00B6
0038: C3 0D 01    jp   $010D
003B: 00          nop
003C: 00          nop
003D: 00          nop
003E: 00          nop
003F: 00          nop
0040: 00          nop
0041: 00          nop
0042: 09          add  hl,bc
0043: 00          nop
0044: 00          nop
0045: FF          rst  $38
0046: FF          rst  $38
0047: FF          rst  $38
0048: FF          rst  $38
0049: FF          rst  $38
004A: FF          rst  $38
004B: FF          rst  $38
004C: FF          rst  $38
004D: FF          rst  $38
004E: FF          rst  $38
004F: FF          rst  $38
0050: FF          rst  $38
0051: FF          rst  $38
0052: FF          rst  $38
0053: FF          rst  $38
0054: FF          rst  $38
0055: FF          rst  $38
0056: FF          rst  $38
0057: FF          rst  $38
0058: FF          rst  $38
0059: FF          rst  $38
005A: FF          rst  $38
005B: FF          rst  $38
005C: FF          rst  $38
005D: FF          rst  $38
005E: FF          rst  $38
005F: FF          rst  $38
0060: FF          rst  $38
0061: FF          rst  $38
0062: FF          rst  $38
0063: FF          rst  $38
0064: FF          rst  $38
0065: FF          rst  $38
0066: D9          exx
0067: ED A0       ldi
0069: EA 98 00    jp   pe,$0098
006C: 21 00 91    ld   hl,$9100
006F: 36 10       ld   (hl),$10
0071: F5          push af
0072: 2A 00 81    ld   hl,($8100)
0075: 7E          ld   a,(hl)
0076: A7          and  a
0077: 28 1E       jr   z,$0097
0079: 36 00       ld   (hl),$00
007B: F5          push af
007C: 2C          inc  l
007D: 2C          inc  l
007E: 4E          ld   c,(hl)
007F: 2C          inc  l
0080: 46          ld   b,(hl)
0081: 2C          inc  l
0082: 5E          ld   e,(hl)
0083: 2C          inc  l
0084: 56          ld   d,(hl)
0085: 2C          inc  l
0086: 7E          ld   a,(hl)
0087: 2C          inc  l
0088: 2C          inc  l
0089: 22 00 81    ld   ($8100),hl
008C: 2D          dec  l
008D: 66          ld   h,(hl)
008E: 6F          ld   l,a
008F: F1          pop  af
0090: D9          exx
0091: 32 00 91    ld   ($9100),a
0094: F1          pop  af
0095: ED 45       retn
0097: F1          pop  af
0098: D9          exx
0099: ED 45       retn
009B: 31 00 83    ld   sp,$8300
009E: ED 56       im   1
00A0: 3E 01       ld   a,$01
00A2: 32 00 A0    ld   ($A000),a
00A5: FB          ei
00A6: 21 00 4C    ld   hl,$4C00
00A9: 36 24       ld   (hl),$24
00AB: 23          inc  hl
00AC: 7C          ld   a,h
00AD: FE 50       cp   $50
00AF: 20 F8       jr   nz,$00A9
00B1: CD 78 02    call $0278
00B4: 18 FB       jr   $00B1
00B6: 08          ex   af,af'
00B7: 3A 00 91    ld   a,($9100)
00BA: E6 E0       and  $E0
00BC: 20 06       jr   nz,$00C4
00BE: 08          ex   af,af'
00BF: D9          exx
00C0: 32 00 91    ld   ($9100),a
00C3: C9          ret
00C4: E5          push hl
00C5: D5          push de
00C6: EB          ex   de,hl
00C7: 2A 02 81    ld   hl,($8102)
00CA: 7D          ld   a,l
00CB: C6 08       add  a,$08
00CD: 6F          ld   l,a
00CE: 22 02 81    ld   ($8102),hl
00D1: 2D          dec  l
00D2: 72          ld   (hl),d
00D3: 2D          dec  l
00D4: 73          ld   (hl),e
00D5: 2D          dec  l
00D6: D1          pop  de
00D7: 72          ld   (hl),d
00D8: 2D          dec  l
00D9: 73          ld   (hl),e
00DA: 2D          dec  l
00DB: 70          ld   (hl),b
00DC: 2D          dec  l
00DD: 71          ld   (hl),c
00DE: 2D          dec  l
00DF: 2D          dec  l
00E0: 08          ex   af,af'
00E1: 77          ld   (hl),a
00E2: 3A 00 91    ld   a,($9100)
00E5: FE 10       cp   $10
00E7: 28 02       jr   z,$00EB
00E9: E1          pop  hl
00EA: C9          ret
00EB: 7E          ld   a,(hl)
00EC: 36 00       ld   (hl),$00
00EE: 22 02 81    ld   ($8102),hl
00F1: E1          pop  hl
00F2: C3 BE 00    jp   $00BE
00F5: 3A 0C 40    ld   a,($400C)
00F8: A7          and  a
00F9: C8          ret  z
00FA: AF          xor  a
00FB: 32 15 82    ld   ($8215),a
00FE: 32 0C 40    ld   ($400C),a
0101: 21 0B 01    ld   hl,$010B
0104: 0E 02       ld   c,$02
0106: 3E 81       ld   a,$81
0108: C3 30 00    jp   $0030
010B: 02          ld   (bc),a
010C: 02          ld   (bc),a
010D: E5          push hl
010E: D5          push de
010F: C5          push bc
0110: F5          push af
0111: AF          xor  a
0112: 32 00 A0    ld   ($A000),a
0115: 3C          inc  a
0116: 32 07 A0    ld   ($A007),a
0119: 21 00 90    ld   hl,$9000
011C: 11 04 81    ld   de,$8104
011F: 01 08 00    ld   bc,$0008
0122: 3E 72       ld   a,$72
0124: CD B6 00    call $00B6
0127: 21 00 90    ld   hl,$9000
012A: 11 0C 81    ld   de,$810C
012D: 01 03 00    ld   bc,$0003
0130: 3E 71       ld   a,$71
0132: CD B6 00    call $00B6
0135: CD 00 20    call $2000
0138: CD F5 00    call $00F5
013B: D3 00       out  ($00),a
013D: 3A 00 A0    ld   a,($A000)
0140: CB 4F       bit  1,a
0142: 28 42       jr   z,$0186
0144: CD BE 05    call $05BE
0147: CD E1 01    call $01E1
014A: CD 06 02    call $0206
014D: CD B5 01    call $01B5
0150: 3E 01       ld   a,$01
0152: 32 00 A0    ld   ($A000),a
0155: 3A 19 82    ld   a,($8219)
0158: A7          and  a
0159: 20 22       jr   nz,$017D
015B: 3A 0C 81    ld   a,($810C)
015E: FE BB       cp   $BB
0160: 28 4B       jr   z,$01AD
0162: A7          and  a
0163: 20 03       jr   nz,$0168
0165: 32 15 82    ld   ($8215),a
0168: 21 5F 41    ld   hl,$415F
016B: 7E          ld   a,(hl)
016C: 2B          dec  hl
016D: B6          or   (hl)
016E: 2B          dec  hl
016F: 28 04       jr   z,$0175
0171: 34          inc  (hl)
0172: 20 0C       jr   nz,$0180
0174: C7          rst  $00
0175: 36 88       ld   (hl),$88
0177: 23          inc  hl
0178: 36 01       ld   (hl),$01
017A: 23          inc  hl
017B: 36 01       ld   (hl),$01
017D: 32 00 A1    ld   ($A100),a
0180: F1          pop  af
0181: C1          pop  bc
0182: D1          pop  de
0183: E1          pop  hl
0184: FB          ei
0185: C9          ret
0186: CD 92 06    call $0692
0189: CD 39 02    call $0239
018C: 3A 15 82    ld   a,($8215)
018F: 3C          inc  a
0190: 32 15 82    ld   ($8215),a
0193: 3A 0C 81    ld   a,($810C)
0196: A7          and  a
0197: 28 B7       jr   z,$0150
0199: 3A 19 82    ld   a,($8219)
019C: A7          and  a
019D: 20 B1       jr   nz,$0150
019F: 3A 15 82    ld   a,($8215)
01A2: 1F          rra
01A3: 1F          rra
01A4: 1F          rra
01A5: 1F          rra
01A6: 1F          rra
01A7: 2F          cpl
01A8: 32 06 A0    ld   ($A006),a
01AB: 18 A3       jr   $0150
01AD: 3A 00 91    ld   a,($9100)
01B0: FE 10       cp   $10
01B2: 20 F9       jr   nz,$01AD
01B4: C7          rst  $00
01B5: 21 64 41    ld   hl,$4164
01B8: 06 03       ld   b,$03
01BA: 7E          ld   a,(hl)
01BB: A7          and  a
01BC: 20 04       jr   nz,$01C2
01BE: 23          inc  hl
01BF: 10 F9       djnz $01BA
01C1: C9          ret
01C2: 36 00       ld   (hl),$00
01C4: 3E 03       ld   a,$03
01C6: 90          sub  b
01C7: 4F          ld   c,a
01C8: 81          add  a,c
01C9: 81          add  a,c
01CA: 4F          ld   c,a
01CB: 06 00       ld   b,$00
01CD: 21 D8 01    ld   hl,$01D8
01D0: 09          add  hl,bc
01D1: 0E 03       ld   c,$03
01D3: 3E 84       ld   a,$84
01D5: C3 30 00    jp   $0030
01D8: 01 01 00    ld   bc,$0001
01DB: 02          ld   (bc),a
01DC: 02          ld   (bc),a
01DD: 00          nop
01DE: 04          inc  b
01DF: 04          inc  b
01E0: 00          nop
01E1: 3A 04 81    ld   a,($8104)
01E4: 32 06 40    ld   ($4006),a
01E7: 3A 0C 81    ld   a,($810C)
01EA: 32 07 40    ld   ($4007),a
01ED: 3A 0D 81    ld   a,($810D)
01F0: 2F          cpl
01F1: 07          rlca
01F2: 07          rlca
01F3: 07          rlca
01F4: E6 01       and  $01
01F6: 32 08 40    ld   ($4008),a
01F9: 3A 0E 81    ld   a,($810E)
01FC: 2F          cpl
01FD: 07          rlca
01FE: 07          rlca
01FF: 07          rlca
0200: E6 01       and  $01
0202: 32 0D 40    ld   ($400D),a
0205: C9          ret
0206: 06 14       ld   b,$14
0208: 3A 00 A0    ld   a,($A000)
020B: CB 5F       bit  3,a
020D: 28 08       jr   z,$0217
020F: 10 F7       djnz $0208
0211: 3E 00       ld   a,$00
0213: 32 04 40    ld   ($4004),a
0216: C9          ret
0217: DB 00       in   a,($00)
0219: 47          ld   b,a
021A: 3A AD 81    ld   a,($81AD)
021D: A7          and  a
021E: 20 0D       jr   nz,$022D
0220: 3A AB 81    ld   a,($81AB)
0223: 80          add  a,b
0224: 32 04 40    ld   ($4004),a
0227: 3E 00       ld   a,$00
0229: 32 03 A0    ld   ($A003),a
022C: C9          ret
022D: 3D          dec  a
022E: 32 AD 81    ld   ($81AD),a
0231: 78          ld   a,b
0232: ED 44       neg
0234: 32 AB 81    ld   ($81AB),a
0237: 18 EE       jr   $0227
0239: 06 14       ld   b,$14
023B: 3A 00 A0    ld   a,($A000)
023E: CB 5F       bit  3,a
0240: 28 08       jr   z,$024A
0242: 10 F7       djnz $023B
0244: 3E 00       ld   a,$00
0246: 32 05 40    ld   ($4005),a
0249: C9          ret
024A: DB 00       in   a,($00)
024C: 47          ld   b,a
024D: 3A AE 81    ld   a,($81AE)
0250: A7          and  a
0251: 20 0D       jr   nz,$0260
0253: 3A AC 81    ld   a,($81AC)
0256: 80          add  a,b
0257: 32 05 40    ld   ($4005),a
025A: 3E 01       ld   a,$01
025C: 32 03 A0    ld   ($A003),a
025F: C9          ret
0260: 3D          dec  a
0261: 32 AE 81    ld   ($81AE),a
0264: 78          ld   a,b
0265: FE 80       cp   $80
0267: 38 02       jr   c,$026B
0269: 3E 00       ld   a,$00
026B: FE 50       cp   $50
026D: 38 02       jr   c,$0271
026F: 3E 4F       ld   a,$4F
0271: ED 44       neg
0273: 32 AC 81    ld   ($81AC),a
0276: 18 E2       jr   $025A
0278: 3A 10 40    ld   a,($4010)
027B: FE 73       cp   $73
027D: 20 2F       jr   nz,$02AE
027F: 3A 18 40    ld   a,($4018)
0282: A7          and  a
0283: C0          ret  nz
0284: 3A 11 40    ld   a,($4011)
0287: F5          push af
0288: 3E FF       ld   a,$FF
028A: 32 11 40    ld   ($4011),a
028D: F1          pop  af
028E: A7          and  a
028F: CA B6 02    jp   z,$02B6
0292: 3D          dec  a
0293: CA 3E 03    jp   z,$033E
0296: 3D          dec  a
0297: CA 51 04    jp   z,$0451
029A: 3D          dec  a
029B: CA 67 05    jp   z,$0567
029E: 3D          dec  a
029F: CA 98 05    jp   z,$0598
02A2: 3D          dec  a
02A3: CA AB 05    jp   z,$05AB
02A6: F5          push af
02A7: 3E 01       ld   a,$01
02A9: 32 18 40    ld   ($4018),a
02AC: F1          pop  af
02AD: C9          ret
02AE: F5          push af
02AF: 3E 00       ld   a,$00
02B1: 32 18 40    ld   ($4018),a
02B4: F1          pop  af
02B5: C9          ret
02B6: CD 9D 03    call $039D
02B9: CD C4 02    call $02C4
02BC: F5          push af
02BD: 3E 01       ld   a,$01
02BF: 32 18 40    ld   ($4018),a
02C2: F1          pop  af
02C3: C9          ret
02C4: 21 1C 40    ld   hl,$401C
02C7: 06 24       ld   b,$24
02C9: 36 00       ld   (hl),$00
02CB: 23          inc  hl
02CC: 10 FB       djnz $02C9
02CE: E5          push hl
02CF: 21 00 30    ld   hl,$3000
02D2: 22 C2 81    ld   ($81C2),hl
02D5: E1          pop  hl
02D6: 01 2C 01    ld   bc,$012C
02D9: C5          push bc
02DA: E5          push hl
02DB: 21 1C 40    ld   hl,$401C
02DE: 22 C0 81    ld   ($81C0),hl
02E1: E1          pop  hl
02E2: 06 06       ld   b,$06
02E4: D5          push de
02E5: 2A C2 81    ld   hl,($81C2)
02E8: 5E          ld   e,(hl)
02E9: 23          inc  hl
02EA: 56          ld   d,(hl)
02EB: EB          ex   de,hl
02EC: D1          pop  de
02ED: E5          push hl
02EE: 2A C0 81    ld   hl,($81C0)
02F1: 5E          ld   e,(hl)
02F2: 23          inc  hl
02F3: 56          ld   d,(hl)
02F4: E1          pop  hl
02F5: E5          push hl
02F6: A7          and  a
02F7: ED 52       sbc  hl,de
02F9: E1          pop  hl
02FA: 38 1D       jr   c,$0319
02FC: 78          ld   a,b
02FD: 87          add  a,a
02FE: 80          add  a,b
02FF: 87          add  a,a
0300: 4F          ld   c,a
0301: 06 00       ld   b,$00
0303: 21 3F 40    ld   hl,$403F
0306: 11 45 40    ld   de,$4045
0309: ED B8       lddr
030B: 2A C2 81    ld   hl,($81C2)
030E: ED 5B C0 81 ld   de,($81C0)
0312: 01 06 00    ld   bc,$0006
0315: ED B0       ldir
0317: 18 10       jr   $0329
0319: D5          push de
031A: E5          push hl
031B: 2A C0 81    ld   hl,($81C0)
031E: 11 06 00    ld   de,$0006
0321: 19          add  hl,de
0322: 22 C0 81    ld   ($81C0),hl
0325: E1          pop  hl
0326: D1          pop  de
0327: 10 BB       djnz $02E4
0329: D5          push de
032A: E5          push hl
032B: 2A C2 81    ld   hl,($81C2)
032E: 11 06 00    ld   de,$0006
0331: 19          add  hl,de
0332: 22 C2 81    ld   ($81C2),hl
0335: E1          pop  hl
0336: D1          pop  de
0337: C1          pop  bc
0338: 0B          dec  bc
0339: 78          ld   a,b
033A: B1          or   c
033B: 20 9C       jr   nz,$02D9
033D: C9          ret
033E: 2A 12 40    ld   hl,($4012)
0341: 11 10 27    ld   de,$2710
0344: E5          push hl
0345: A7          and  a
0346: ED 52       sbc  hl,de
0348: E1          pop  hl
0349: 30 27       jr   nc,$0372
034B: 2A 14 40    ld   hl,($4014)
034E: 11 40 9C    ld   de,$9C40
0351: E5          push hl
0352: A7          and  a
0353: ED 52       sbc  hl,de
0355: E1          pop  hl
0356: 30 1A       jr   nc,$0372
0358: 3A 17 40    ld   a,($4017)
035B: CB 7F       bit  7,a
035D: 20 13       jr   nz,$0372
035F: CD 9D 03    call $039D
0362: CD D6 03    call $03D6
0365: CD C4 02    call $02C4
0368: CD F8 03    call $03F8
036B: CD 86 03    call $0386
036E: ED 53 F0 37 ld   ($37F0),de
0372: F5          push af
0373: 3E 01       ld   a,$01
0375: 32 18 40    ld   ($4018),a
0378: F1          pop  af
0379: C9          ret
037A: CD 86 03    call $0386
037D: 2A F0 37    ld   hl,($37F0)
0380: E5          push hl
0381: A7          and  a
0382: ED 52       sbc  hl,de
0384: E1          pop  hl
0385: C9          ret
0386: 21 00 30    ld   hl,$3000
0389: 11 00 00    ld   de,$0000
038C: 01 08 07    ld   bc,$0708
038F: 7B          ld   a,e
0390: 86          add  a,(hl)
0391: 5F          ld   e,a
0392: 3E 00       ld   a,$00
0394: 8A          adc  a,d
0395: 57          ld   d,a
0396: 23          inc  hl
0397: 0B          dec  bc
0398: 78          ld   a,b
0399: B1          or   c
039A: 20 F3       jr   nz,$038F
039C: C9          ret
039D: E5          push hl
039E: 21 00 30    ld   hl,$3000
03A1: 22 C0 81    ld   ($81C0),hl
03A4: E1          pop  hl
03A5: 01 2C 01    ld   bc,$012C
03A8: D5          push de
03A9: 2A C0 81    ld   hl,($81C0)
03AC: 5E          ld   e,(hl)
03AD: 23          inc  hl
03AE: 56          ld   d,(hl)
03AF: EB          ex   de,hl
03B0: D1          pop  de
03B1: 11 10 27    ld   de,$2710
03B4: E5          push hl
03B5: A7          and  a
03B6: ED 52       sbc  hl,de
03B8: E1          pop  hl
03B9: 38 07       jr   c,$03C2
03BB: 2A C0 81    ld   hl,($81C0)
03BE: 75          ld   (hl),l
03BF: 23          inc  hl
03C0: 36 04       ld   (hl),$04
03C2: D5          push de
03C3: E5          push hl
03C4: 2A C0 81    ld   hl,($81C0)
03C7: 11 06 00    ld   de,$0006
03CA: 19          add  hl,de
03CB: 22 C0 81    ld   ($81C0),hl
03CE: E1          pop  hl
03CF: D1          pop  de
03D0: 0B          dec  bc
03D1: 78          ld   a,b
03D2: B1          or   c
03D3: 20 D3       jr   nz,$03A8
03D5: C9          ret
03D6: 2A 08 37    ld   hl,($3708)
03D9: 11 00 30    ld   de,$3000
03DC: E5          push hl
03DD: A7          and  a
03DE: ED 52       sbc  hl,de
03E0: E1          pop  hl
03E1: 38 0C       jr   c,$03EF
03E3: 2A 08 37    ld   hl,($3708)
03E6: 11 02 37    ld   de,$3702
03E9: E5          push hl
03EA: A7          and  a
03EB: ED 52       sbc  hl,de
03ED: E1          pop  hl
03EE: D8          ret  c
03EF: E5          push hl
03F0: 21 00 30    ld   hl,$3000
03F3: 22 08 37    ld   ($3708),hl
03F6: E1          pop  hl
03F7: C9          ret
03F8: D5          push de
03F9: 2A 08 37    ld   hl,($3708)
03FC: 5E          ld   e,(hl)
03FD: 23          inc  hl
03FE: 56          ld   d,(hl)
03FF: EB          ex   de,hl
0400: D1          pop  de
0401: ED 5B 3A 40 ld   de,($403A)
0405: E5          push hl
0406: A7          and  a
0407: ED 52       sbc  hl,de
0409: E1          pop  hl
040A: 38 1D       jr   c,$0429
040C: D5          push de
040D: E5          push hl
040E: 2A 08 37    ld   hl,($3708)
0411: 11 06 00    ld   de,$0006
0414: 19          add  hl,de
0415: 11 02 37    ld   de,$3702
0418: E5          push hl
0419: A7          and  a
041A: ED 52       sbc  hl,de
041C: E1          pop  hl
041D: 38 03       jr   c,$0422
041F: 21 00 30    ld   hl,$3000
0422: 22 08 37    ld   ($3708),hl
0425: E1          pop  hl
0426: D1          pop  de
0427: 18 CF       jr   $03F8
0429: 21 12 40    ld   hl,$4012
042C: ED 5B 08 37 ld   de,($3708)
0430: 01 06 00    ld   bc,$0006
0433: ED B0       ldir
0435: D5          push de
0436: E5          push hl
0437: 2A 08 37    ld   hl,($3708)
043A: 11 06 00    ld   de,$0006
043D: 19          add  hl,de
043E: 11 02 37    ld   de,$3702
0441: E5          push hl
0442: A7          and  a
0443: ED 52       sbc  hl,de
0445: E1          pop  hl
0446: 38 03       jr   c,$044B
0448: 21 00 30    ld   hl,$3000
044B: 22 08 37    ld   ($3708),hl
044E: E1          pop  hl
044F: D1          pop  de
0450: C9          ret
0451: 21 1C 40    ld   hl,$401C
0454: 06 0F       ld   b,$0F
0456: 36 FF       ld   (hl),$FF
0458: 23          inc  hl
0459: 36 FF       ld   (hl),$FF
045B: 23          inc  hl
045C: 10 F8       djnz $0456
045E: 21 12 40    ld   hl,$4012
0461: 11 3A 40    ld   de,$403A
0464: 01 06 00    ld   bc,$0006
0467: ED B0       ldir
0469: 21 40 40    ld   hl,$4040
046C: 06 18       ld   b,$18
046E: 36 00       ld   (hl),$00
0470: 23          inc  hl
0471: 36 00       ld   (hl),$00
0473: 23          inc  hl
0474: 10 F8       djnz $046E
0476: E5          push hl
0477: 21 2C 01    ld   hl,$012C
047A: 22 CA 81    ld   ($81CA),hl
047D: E1          pop  hl
047E: E5          push hl
047F: 21 01 00    ld   hl,$0001
0482: 22 C8 81    ld   ($81C8),hl
0485: E1          pop  hl
0486: E5          push hl
0487: 21 00 30    ld   hl,$3000
048A: 22 C0 81    ld   ($81C0),hl
048D: E1          pop  hl
048E: E5          push hl
048F: 21 3A 40    ld   hl,$403A
0492: 22 C2 81    ld   ($81C2),hl
0495: E1          pop  hl
0496: D5          push de
0497: 2A C2 81    ld   hl,($81C2)
049A: 5E          ld   e,(hl)
049B: 23          inc  hl
049C: 56          ld   d,(hl)
049D: EB          ex   de,hl
049E: D1          pop  de
049F: E5          push hl
04A0: 2A C0 81    ld   hl,($81C0)
04A3: 5E          ld   e,(hl)
04A4: 23          inc  hl
04A5: 56          ld   d,(hl)
04A6: E1          pop  hl
04A7: E5          push hl
04A8: A7          and  a
04A9: ED 52       sbc  hl,de
04AB: E1          pop  hl
04AC: D2 25 05    jp   nc,$0525
04AF: D5          push de
04B0: E5          push hl
04B1: 2A C8 81    ld   hl,($81C8)
04B4: 11 01 00    ld   de,$0001
04B7: 19          add  hl,de
04B8: 22 C8 81    ld   ($81C8),hl
04BB: E1          pop  hl
04BC: D1          pop  de
04BD: 06 05       ld   b,$05
04BF: D5          push de
04C0: E5          push hl
04C1: 2A C2 81    ld   hl,($81C2)
04C4: 11 FA FF    ld   de,$FFFA
04C7: 19          add  hl,de
04C8: 22 C2 81    ld   ($81C2),hl
04CB: E1          pop  hl
04CC: D1          pop  de
04CD: D5          push de
04CE: 2A C2 81    ld   hl,($81C2)
04D1: 5E          ld   e,(hl)
04D2: 23          inc  hl
04D3: 56          ld   d,(hl)
04D4: EB          ex   de,hl
04D5: D1          pop  de
04D6: E5          push hl
04D7: A7          and  a
04D8: ED 52       sbc  hl,de
04DA: E1          pop  hl
04DB: 30 04       jr   nc,$04E1
04DD: 10 E0       djnz $04BF
04DF: 18 1A       jr   $04FB
04E1: 21 22 40    ld   hl,$4022
04E4: 11 1C 40    ld   de,$401C
04E7: 05          dec  b
04E8: 28 09       jr   z,$04F3
04EA: 78          ld   a,b
04EB: 87          add  a,a
04EC: 80          add  a,b
04ED: 87          add  a,a
04EE: 4F          ld   c,a
04EF: 06 00       ld   b,$00
04F1: ED B0       ldir
04F3: 2A C0 81    ld   hl,($81C0)
04F6: 01 06 00    ld   bc,$0006
04F9: ED B0       ldir
04FB: D5          push de
04FC: E5          push hl
04FD: 2A C0 81    ld   hl,($81C0)
0500: 11 06 00    ld   de,$0006
0503: 19          add  hl,de
0504: 22 C0 81    ld   ($81C0),hl
0507: E1          pop  hl
0508: D1          pop  de
0509: 2A CA 81    ld   hl,($81CA)
050C: 2B          dec  hl
050D: 22 CA 81    ld   ($81CA),hl
0510: 7C          ld   a,h
0511: B5          or   l
0512: C2 8E 04    jp   nz,$048E
0515: E5          push hl
0516: 2A C8 81    ld   hl,($81C8)
0519: 22 1A 40    ld   ($401A),hl
051C: E1          pop  hl
051D: F5          push af
051E: 3E 01       ld   a,$01
0520: 32 18 40    ld   ($4018),a
0523: F1          pop  af
0524: C9          ret
0525: 06 08       ld   b,$08
0527: D5          push de
0528: E5          push hl
0529: 2A C2 81    ld   hl,($81C2)
052C: 11 06 00    ld   de,$0006
052F: 19          add  hl,de
0530: 22 C2 81    ld   ($81C2),hl
0533: E1          pop  hl
0534: D1          pop  de
0535: D5          push de
0536: 2A C2 81    ld   hl,($81C2)
0539: 5E          ld   e,(hl)
053A: 23          inc  hl
053B: 56          ld   d,(hl)
053C: EB          ex   de,hl
053D: D1          pop  de
053E: E5          push hl
053F: A7          and  a
0540: ED 52       sbc  hl,de
0542: E1          pop  hl
0543: 38 04       jr   c,$0549
0545: 10 E0       djnz $0527
0547: 18 B2       jr   $04FB
0549: 21 69 40    ld   hl,$4069
054C: 11 6F 40    ld   de,$406F
054F: 05          dec  b
0550: 28 09       jr   z,$055B
0552: 78          ld   a,b
0553: 87          add  a,a
0554: 80          add  a,b
0555: 87          add  a,a
0556: 4F          ld   c,a
0557: 06 00       ld   b,$00
0559: ED B8       lddr
055B: 2A C0 81    ld   hl,($81C0)
055E: 01 05 00    ld   bc,$0005
0561: 09          add  hl,bc
0562: 03          inc  bc
0563: ED B8       lddr
0565: 18 94       jr   $04FB
0567: 21 00 30    ld   hl,$3000
056A: 11 B0 04    ld   de,$04B0
056D: 01 2C 01    ld   bc,$012C
0570: 73          ld   (hl),e
0571: 23          inc  hl
0572: 72          ld   (hl),d
0573: 23          inc  hl
0574: 36 00       ld   (hl),$00
0576: 23          inc  hl
0577: 36 00       ld   (hl),$00
0579: 23          inc  hl
057A: 36 00       ld   (hl),$00
057C: 23          inc  hl
057D: 36 00       ld   (hl),$00
057F: 23          inc  hl
0580: 1B          dec  de
0581: 1B          dec  de
0582: 1B          dec  de
0583: 0B          dec  bc
0584: 78          ld   a,b
0585: B1          or   c
0586: 20 E8       jr   nz,$0570
0588: CD 86 03    call $0386
058B: ED 53 F0 37 ld   ($37F0),de
058F: E5          push hl
0590: 21 00 30    ld   hl,$3000
0593: 22 08 37    ld   ($3708),hl
0596: E1          pop  hl
0597: C9          ret
0598: 21 0C 37    ld   hl,$370C
059B: 11 1C 40    ld   de,$401C
059E: 01 1E 00    ld   bc,$001E
05A1: ED B0       ldir
05A3: F5          push af
05A4: 3E 01       ld   a,$01
05A6: 32 18 40    ld   ($4018),a
05A9: F1          pop  af
05AA: C9          ret
05AB: 21 1C 40    ld   hl,$401C
05AE: 11 0C 37    ld   de,$370C
05B1: 01 1E 00    ld   bc,$001E
05B4: ED B0       ldir
05B6: F5          push af
05B7: 3E 01       ld   a,$01
05B9: 32 18 40    ld   ($4018),a
05BC: F1          pop  af
05BD: C9          ret
05BE: 3A 00 40    ld   a,($4000)
05C1: FE 73       cp   $73
05C3: C0          ret  nz
05C4: CD 37 06    call $0637
05C7: DD 21 94 81 ld   ix,$8194
05CB: 2A 90 81    ld   hl,($8190)
05CE: CD 58 06    call $0658
05D1: FD 21 76 4E ld   iy,$4E76
05D5: 06 04       ld   b,$04
05D7: DD 6E 00    ld   l,(ix+$00)
05DA: DD 66 01    ld   h,(ix+$01)
05DD: CD 58 06    call $0658
05E0: FD 23       inc  iy
05E2: DD CB 02 46 bit  0,(ix+$02)
05E6: 28 09       jr   z,$05F1
05E8: 5E          ld   e,(hl)
05E9: 23          inc  hl
05EA: 56          ld   d,(hl)
05EB: EB          ex   de,hl
05EC: CD 58 06    call $0658
05EF: 18 10       jr   $0601
05F1: FD 36 00 24 ld   (iy+$00),$24
05F5: FD 23       inc  iy
05F7: FD 36 00 24 ld   (iy+$00),$24
05FB: FD 23       inc  iy
05FD: 7E          ld   a,(hl)
05FE: CD 5D 06    call $065D
0601: 11 37 00    ld   de,$0037
0604: FD 19       add  iy,de
0606: 11 04 00    ld   de,$0004
0609: DD 19       add  ix,de
060B: 10 CA       djnz $05D7
060D: 3A 00 40    ld   a,($4000)
0610: FE 73       cp   $73
0612: C0          ret  nz
0613: 21 A8 81    ld   hl,$81A8
0616: 34          inc  (hl)
0617: 7E          ld   a,(hl)
0618: E6 1F       and  $1F
061A: FE 08       cp   $08
061C: D0          ret  nc
061D: 3A 92 81    ld   a,($8192)
0620: E6 03       and  $03
0622: 87          add  a,a
0623: 87          add  a,a
0624: 87          add  a,a
0625: 6F          ld   l,a
0626: 26 00       ld   h,$00
0628: 29          add  hl,hl
0629: 29          add  hl,hl
062A: 29          add  hl,hl
062B: 11 76 4E    ld   de,$4E76
062E: 19          add  hl,de
062F: 06 0A       ld   b,$0A
0631: 36 24       ld   (hl),$24
0633: 23          inc  hl
0634: 10 FB       djnz $0631
0636: C9          ret
0637: FD 21 35 4E ld   iy,$4E35
063B: 3A 03 40    ld   a,($4003)
063E: CB 47       bit  0,a
0640: 28 0B       jr   z,$064D
0642: CD 72 06    call $0672
0645: 53          ld   d,e
0646: 48          ld   c,b
0647: 49          ld   c,c
0648: 46          ld   b,(hl)
0649: 54          ld   d,h
064A: 20 40       jr   nz,$068C
064C: C9          ret
064D: CD 72 06    call $0672
0650: 20 20       jr   nz,$0672
0652: 20 20       jr   nz,$0674
0654: 20 20       jr   nz,$0676
0656: 40          ld   b,b
0657: C9          ret
0658: 7C          ld   a,h
0659: CD 5D 06    call $065D
065C: 7D          ld   a,l
065D: F5          push af
065E: 0F          rrca
065F: 0F          rrca
0660: 0F          rrca
0661: 0F          rrca
0662: E6 0F       and  $0F
0664: FD 77 00    ld   (iy+$00),a
0667: FD 23       inc  iy
0669: F1          pop  af
066A: E6 0F       and  $0F
066C: FD 77 00    ld   (iy+$00),a
066F: FD 23       inc  iy
0671: C9          ret
0672: E3          ex   (sp),hl
0673: F5          push af
0674: 7E          ld   a,(hl)
0675: 23          inc  hl
0676: FE 40       cp   $40
0678: 28 15       jr   z,$068F
067A: FE 20       cp   $20
067C: 20 04       jr   nz,$0682
067E: 3E 24       ld   a,$24
0680: 18 06       jr   $0688
0682: FE 10       cp   $10
0684: 38 02       jr   c,$0688
0686: D6 37       sub  $37
0688: FD 77 00    ld   (iy+$00),a
068B: FD 23       inc  iy
068D: 18 E5       jr   $0674
068F: F1          pop  af
0690: E3          ex   (sp),hl
0691: C9          ret
0692: CD B3 07    call $07B3
0695: CD CE 07    call $07CE
0698: CD EC 07    call $07EC
069B: 3A 00 40    ld   a,($4000)
069E: FE 73       cp   $73
06A0: C0          ret  nz
06A1: 3A 01 40    ld   a,($4001)
06A4: FE 10       cp   $10
06A6: 38 2F       jr   c,$06D7
06A8: FE 19       cp   $19
06AA: 38 3F       jr   c,$06EB
06AC: 21 AA 81    ld   hl,$81AA
06AF: 7E          ld   a,(hl)
06B0: A7          and  a
06B1: 28 02       jr   z,$06B5
06B3: 35          dec  (hl)
06B4: C9          ret
06B5: 3A A8 81    ld   a,($81A8)
06B8: E6 0F       and  $0F
06BA: C0          ret  nz
06BB: 3A 02 40    ld   a,($4002)
06BE: FE 12       cp   $12
06C0: 28 0C       jr   z,$06CE
06C2: FE 13       cp   $13
06C4: C0          ret  nz
06C5: CD 35 07    call $0735
06C8: 1B          dec  de
06C9: ED 53 90 81 ld   ($8190),de
06CD: C9          ret
06CE: CD 35 07    call $0735
06D1: 13          inc  de
06D2: ED 53 90 81 ld   ($8190),de
06D6: C9          ret
06D7: 06 04       ld   b,$04
06D9: 2A 90 81    ld   hl,($8190)
06DC: 17          rla
06DD: 17          rla
06DE: 17          rla
06DF: 17          rla
06E0: 17          rla
06E1: CB 15       rl   l
06E3: CB 14       rl   h
06E5: 10 F9       djnz $06E0
06E7: 22 90 81    ld   ($8190),hl
06EA: C9          ret
06EB: 3A 01 40    ld   a,($4001)
06EE: D6 10       sub  $10
06F0: 21 03 40    ld   hl,$4003
06F3: CB 46       bit  0,(hl)
06F5: 28 02       jr   z,$06F9
06F7: C6 09       add  a,$09
06F9: 87          add  a,a
06FA: 5F          ld   e,a
06FB: 16 00       ld   d,$00
06FD: 21 06 07    ld   hl,$0706
0700: 19          add  hl,de
0701: 5E          ld   e,(hl)
0702: 23          inc  hl
0703: 56          ld   d,(hl)
0704: EB          ex   de,hl
0705: E9          jp   (hl)
0706: 2A 07 35    ld   hl,($3507)
0709: 07          rlca
070A: 4A          ld   c,d
070B: 07          rlca
070C: 58          ld   e,b
070D: 07          rlca
070E: 5E          ld   e,(hl)
070F: 07          rlca
0710: 69          ld   l,c
0711: 07          rlca
0712: 74          ld   (hl),h
0713: 07          rlca
0714: 7D          ld   a,l
0715: 07          rlca
0716: 84          add  a,h
0717: 07          rlca
0718: 2A 07 35    ld   hl,($3507)
071B: 07          rlca
071C: 89          adc  a,c
071D: 07          rlca
071E: 91          sub  c
071F: 07          rlca
0720: 5E          ld   e,(hl)
0721: 07          rlca
0722: 69          ld   l,c
0723: 07          rlca
0724: 74          ld   (hl),h
0725: 07          rlca
0726: 92          sub  d
0727: 07          rlca
0728: 84          add  a,h
0729: 07          rlca
072A: CD A4 07    call $07A4
072D: ED 5B 90 81 ld   de,($8190)
0731: 73          ld   (hl),e
0732: 23          inc  hl
0733: 72          ld   (hl),d
0734: C9          ret
0735: CD A4 07    call $07A4
0738: 5E          ld   e,(hl)
0739: 23          inc  hl
073A: 56          ld   d,(hl)
073B: 23          inc  hl
073C: CB 46       bit  0,(hl)
073E: 2A 90 81    ld   hl,($8190)
0741: EB          ex   de,hl
0742: 28 04       jr   z,$0748
0744: 73          ld   (hl),e
0745: 23          inc  hl
0746: 72          ld   (hl),d
0747: C9          ret
0748: 73          ld   (hl),e
0749: C9          ret
074A: CD 35 07    call $0735
074D: 13          inc  de
074E: ED 53 90 81 ld   ($8190),de
0752: 3E 32       ld   a,$32
0754: 32 AA 81    ld   ($81AA),a
0757: C9          ret
0758: CD 35 07    call $0735
075B: 1B          dec  de
075C: 18 F0       jr   $074E
075E: CD A4 07    call $07A4
0761: 5E          ld   e,(hl)
0762: 23          inc  hl
0763: 56          ld   d,(hl)
0764: 13          inc  de
0765: 72          ld   (hl),d
0766: 2B          dec  hl
0767: 73          ld   (hl),e
0768: C9          ret
0769: CD A4 07    call $07A4
076C: 5E          ld   e,(hl)
076D: 23          inc  hl
076E: 56          ld   d,(hl)
076F: 1B          dec  de
0770: 72          ld   (hl),d
0771: 2B          dec  hl
0772: 73          ld   (hl),e
0773: C9          ret
0774: 21 92 81    ld   hl,$8192
0777: 7E          ld   a,(hl)
0778: 3C          inc  a
0779: E6 03       and  $03
077B: 77          ld   (hl),a
077C: C9          ret
077D: CD A4 07    call $07A4
0780: 23          inc  hl
0781: 23          inc  hl
0782: 34          inc  (hl)
0783: C9          ret
0784: 21 03 40    ld   hl,$4003
0787: 34          inc  (hl)
0788: C9          ret
0789: CD A4 07    call $07A4
078C: 5E          ld   e,(hl)
078D: 23          inc  hl
078E: 56          ld   d,(hl)
078F: EB          ex   de,hl
0790: E9          jp   (hl)
0791: C7          rst  $00
0792: 3E FF       ld   a,$FF
0794: 32 01 40    ld   ($4001),a
0797: 32 02 40    ld   ($4002),a
079A: AF          xor  a
079B: 32 03 40    ld   ($4003),a
079E: 3E 59       ld   a,$59
07A0: 32 00 40    ld   ($4000),a
07A3: C9          ret
07A4: 3A 92 81    ld   a,($8192)
07A7: E6 03       and  $03
07A9: 87          add  a,a
07AA: 87          add  a,a
07AB: 5F          ld   e,a
07AC: 16 00       ld   d,$00
07AE: 21 94 81    ld   hl,$8194
07B1: 19          add  hl,de
07B2: C9          ret
07B3: 21 83 81    ld   hl,$8183
07B6: 11 87 81    ld   de,$8187
07B9: 01 04 00    ld   bc,$0004
07BC: ED B8       lddr
07BE: 21 0B 81    ld   hl,$810B
07C1: 01 04 00    ld   bc,$0004
07C4: ED B8       lddr
07C6: 21 82 81    ld   hl,$8182
07C9: 3E FF       ld   a,$FF
07CB: ED 67       rrd  (hl)
07CD: C9          ret
07CE: 21 84 81    ld   hl,$8184
07D1: 11 80 81    ld   de,$8180
07D4: 06 04       ld   b,$04
07D6: 1A          ld   a,(de)
07D7: 2F          cpl
07D8: A6          and  (hl)
07D9: 20 0A       jr   nz,$07E5
07DB: 23          inc  hl
07DC: 13          inc  de
07DD: 10 F7       djnz $07D6
07DF: 3E FF       ld   a,$FF
07E1: 32 01 40    ld   ($4001),a
07E4: C9          ret
07E5: CD 06 08    call $0806
07E8: 32 01 40    ld   ($4001),a
07EB: C9          ret
07EC: 21 80 81    ld   hl,$8180
07EF: 06 04       ld   b,$04
07F1: 7E          ld   a,(hl)
07F2: 2F          cpl
07F3: A7          and  a
07F4: 20 09       jr   nz,$07FF
07F6: 23          inc  hl
07F7: 10 F8       djnz $07F1
07F9: 3E FF       ld   a,$FF
07FB: 32 02 40    ld   ($4002),a
07FE: C9          ret
07FF: CD 06 08    call $0806
0802: 32 02 40    ld   ($4002),a
0805: C9          ret
0806: 05          dec  b
0807: 68          ld   l,b
0808: 26 00       ld   h,$00
080A: 11 04 00    ld   de,$0004
080D: 18 01       jr   $0810
080F: 19          add  hl,de
0810: 0F          rrca
0811: 30 FC       jr   nc,$080F
0813: 11 19 08    ld   de,$0819
0816: 19          add  hl,de
0817: 7E          ld   a,(hl)
0818: C9          ret
0819: 11 18 08    ld   de,$0818
081C: 00          nop
081D: 10 FF       djnz $081E
081F: 09          add  hl,bc
0820: 01 14 FF    ld   bc,$FF14
0823: 0A          ld   a,(bc)
0824: 02          ld   (bc),a
0825: 16 FF       ld   d,$FF
0827: 0B          dec  bc
0828: 03          inc  bc
0829: 15          dec  d
082A: FF          rst  $38
082B: 0C          inc  c
082C: 04          inc  b
082D: 17          rla
082E: FF          rst  $38
082F: 0D          dec  c
0830: 05          dec  b
0831: 12          ld   (de),a
0832: FF          rst  $38
0833: 0E 06       ld   c,$06
0835: 13          inc  de
0836: FF          rst  $38
0837: 0F          rrca
0838: 07          rlca
0839: FF          rst  $38
083A: FF          rst  $38
083B: FF          rst  $38
083C: FF          rst  $38
083D: FF          rst  $38
083E: FF          rst  $38
083F: FF          rst  $38
0840: FF          rst  $38
0841: FF          rst  $38
0842: FF          rst  $38
0843: FF          rst  $38
0844: FF          rst  $38
0845: FF          rst  $38
0846: FF          rst  $38
0847: FF          rst  $38
0848: FF          rst  $38
0849: FF          rst  $38
084A: FF          rst  $38
084B: FF          rst  $38
084C: FF          rst  $38
084D: FF          rst  $38
084E: FF          rst  $38
084F: FF          rst  $38
0850: FF          rst  $38
0851: FF          rst  $38
0852: FF          rst  $38
0853: FF          rst  $38
0854: FF          rst  $38
0855: FF          rst  $38
0856: FF          rst  $38
0857: FF          rst  $38
0858: FF          rst  $38
0859: FF          rst  $38
085A: FF          rst  $38
085B: FF          rst  $38
085C: FF          rst  $38
085D: FF          rst  $38
085E: FF          rst  $38
085F: FF          rst  $38
0860: FF          rst  $38
0861: FF          rst  $38
0862: FF          rst  $38
0863: FF          rst  $38
0864: FF          rst  $38
0865: FF          rst  $38
0866: FF          rst  $38
0867: FF          rst  $38
0868: FF          rst  $38
0869: FF          rst  $38
086A: FF          rst  $38
086B: FF          rst  $38
086C: FF          rst  $38
086D: FF          rst  $38
086E: FF          rst  $38
086F: FF          rst  $38
0870: FF          rst  $38
0871: FF          rst  $38
0872: FF          rst  $38
0873: FF          rst  $38
0874: FF          rst  $38
0875: FF          rst  $38
0876: FF          rst  $38
0877: FF          rst  $38
0878: FF          rst  $38
0879: FF          rst  $38
087A: FF          rst  $38
087B: FF          rst  $38
087C: FF          rst  $38
087D: FF          rst  $38
087E: FF          rst  $38
087F: FF          rst  $38
0880: FF          rst  $38
0881: FF          rst  $38
0882: FF          rst  $38
0883: FF          rst  $38
0884: FF          rst  $38
0885: FF          rst  $38
0886: FF          rst  $38
0887: FF          rst  $38
0888: FF          rst  $38
0889: FF          rst  $38
088A: FF          rst  $38
088B: FF          rst  $38
088C: FF          rst  $38
088D: FF          rst  $38
088E: FF          rst  $38
088F: FF          rst  $38
0890: FF          rst  $38
0891: FF          rst  $38
0892: FF          rst  $38
0893: FF          rst  $38
0894: FF          rst  $38
0895: FF          rst  $38
0896: FF          rst  $38
0897: FF          rst  $38
0898: FF          rst  $38
0899: FF          rst  $38
089A: FF          rst  $38
089B: FF          rst  $38
089C: FF          rst  $38
089D: FF          rst  $38
089E: FF          rst  $38
089F: FF          rst  $38
08A0: FF          rst  $38
08A1: FF          rst  $38
08A2: FF          rst  $38
08A3: FF          rst  $38
08A4: FF          rst  $38
08A5: FF          rst  $38
08A6: FF          rst  $38
08A7: FF          rst  $38
08A8: FF          rst  $38
08A9: FF          rst  $38
08AA: FF          rst  $38
08AB: FF          rst  $38
08AC: FF          rst  $38
08AD: FF          rst  $38
08AE: FF          rst  $38
08AF: FF          rst  $38
08B0: FF          rst  $38
08B1: FF          rst  $38
08B2: FF          rst  $38
08B3: FF          rst  $38
08B4: FF          rst  $38
08B5: FF          rst  $38
08B6: FF          rst  $38
08B7: FF          rst  $38
08B8: FF          rst  $38
08B9: FF          rst  $38
08BA: FF          rst  $38
08BB: FF          rst  $38
08BC: FF          rst  $38
08BD: FF          rst  $38
08BE: FF          rst  $38
08BF: FF          rst  $38
08C0: FF          rst  $38
08C1: FF          rst  $38
08C2: FF          rst  $38
08C3: FF          rst  $38
08C4: FF          rst  $38
08C5: FF          rst  $38
08C6: FF          rst  $38
08C7: FF          rst  $38
08C8: FF          rst  $38
08C9: FF          rst  $38
08CA: FF          rst  $38
08CB: FF          rst  $38
08CC: FF          rst  $38
08CD: FF          rst  $38
08CE: FF          rst  $38
08CF: FF          rst  $38
08D0: FF          rst  $38
08D1: FF          rst  $38
08D2: FF          rst  $38
08D3: FF          rst  $38
08D4: FF          rst  $38
08D5: FF          rst  $38
08D6: FF          rst  $38
08D7: FF          rst  $38
08D8: FF          rst  $38
08D9: FF          rst  $38
08DA: FF          rst  $38
08DB: FF          rst  $38
08DC: FF          rst  $38
08DD: FF          rst  $38
08DE: FF          rst  $38
08DF: FF          rst  $38
08E0: FF          rst  $38
08E1: FF          rst  $38
08E2: FF          rst  $38
08E3: FF          rst  $38
08E4: FF          rst  $38
08E5: FF          rst  $38
08E6: FF          rst  $38
08E7: FF          rst  $38
08E8: FF          rst  $38
08E9: FF          rst  $38
08EA: FF          rst  $38
08EB: FF          rst  $38
08EC: FF          rst  $38
08ED: FF          rst  $38
08EE: FF          rst  $38
08EF: FF          rst  $38
08F0: FF          rst  $38
08F1: FF          rst  $38
08F2: FF          rst  $38
08F3: FF          rst  $38
08F4: FF          rst  $38
08F5: FF          rst  $38
08F6: FF          rst  $38
08F7: FF          rst  $38
08F8: FF          rst  $38
08F9: FF          rst  $38
08FA: FF          rst  $38
08FB: FF          rst  $38
08FC: FF          rst  $38
08FD: FF          rst  $38
08FE: FF          rst  $38
08FF: FF          rst  $38
0900: F3          di
0901: AF          xor  a
0902: 32 00 A0    ld   ($A000),a
0905: 32 04 A0    ld   ($A004),a
0908: 32 05 A0    ld   ($A005),a
090B: 32 01 A0    ld   ($A001),a
090E: 32 07 A0    ld   ($A007),a
0911: 32 06 A0    ld   ($A006),a
0914: 3D          dec  a
0915: 32 00 90    ld   ($9000),a
0918: 3E 10       ld   a,$10
091A: 32 00 91    ld   ($9100),a
091D: 11 00 00    ld   de,$0000
0920: D9          exx
0921: 21 00 83    ld   hl,$8300
0924: 3E 06       ld   a,$06
0926: 08          ex   af,af'
0927: 54          ld   d,h
0928: 5D          ld   e,l
0929: 0E 08       ld   c,$08
092B: 06 04       ld   b,$04
092D: D9          exx
092E: 62          ld   h,d
092F: 6B          ld   l,e
0930: D9          exx
0931: D9          exx
0932: 7C          ld   a,h
0933: AD          xor  l
0934: 2F          cpl
0935: 87          add  a,a
0936: 87          add  a,a
0937: ED 6A       adc  hl,hl
0939: 7D          ld   a,l
093A: D9          exx
093B: 77          ld   (hl),a
093C: 32 00 A1    ld   ($A100),a
093F: 2C          inc  l
0940: 7D          ld   a,l
0941: FE C0       cp   $C0
0943: 20 EC       jr   nz,$0931
0945: 25          dec  h
0946: 10 E9       djnz $0931
0948: 06 04       ld   b,$04
094A: 62          ld   h,d
094B: 6B          ld   l,e
094C: D9          exx
094D: EB          ex   de,hl
094E: D9          exx
094F: D9          exx
0950: 7C          ld   a,h
0951: AD          xor  l
0952: 2F          cpl
0953: 87          add  a,a
0954: 87          add  a,a
0955: ED 6A       adc  hl,hl
0957: 7D          ld   a,l
0958: D9          exx
0959: AE          xor  (hl)
095A: C2 9D 10    jp   nz,$109D
095D: 32 00 A1    ld   ($A100),a
0960: 2C          inc  l
0961: 7D          ld   a,l
0962: FE C0       cp   $C0
0964: 20 E9       jr   nz,$094F
0966: 25          dec  h
0967: 10 E6       djnz $094F
0969: 6B          ld   l,e
096A: 62          ld   h,d
096B: 0D          dec  c
096C: 20 BD       jr   nz,$092B
096E: 08          ex   af,af'
096F: 31 00 83    ld   sp,$8300
0972: AF          xor  a
0973: 21 00 40    ld   hl,$4000
0976: CD 15 10    call $1015
0979: 3E 02       ld   a,$02
097B: 21 00 44    ld   hl,$4400
097E: CD 15 10    call $1015
0981: CD 93 0D    call $0D93
0984: 11 93 09    ld   de,$0993
0987: EB          ex   de,hl
0988: 5E          ld   e,(hl)
0989: 23          inc  hl
098A: 56          ld   d,(hl)
098B: 23          inc  hl
098C: EB          ex   de,hl
098D: CD 92 09    call $0992
0990: 18 F5       jr   $0987
0992: E9          jp   (hl)
0993: 59          ld   e,c
0994: 10 8F       djnz $0925
0996: 0E 94       ld   c,$94
0998: 0E E1       ld   c,$E1
099A: 09          add  hl,bc
099B: C8          ret  z
099C: 0E 01       ld   c,$01
099E: 0F          rrca
099F: 0D          dec  c
09A0: 0F          rrca
09A1: E7          rst  $20
09A2: 10 54       djnz $09F8
09A4: 0A          ld   a,(bc)
09A5: 5B          ld   e,e
09A6: 0A          ld   a,(bc)
09A7: 66          ld   h,(hl)
09A8: 0A          ld   a,(bc)
09A9: 9C          sbc  a,h
09AA: 0A          ld   a,(bc)
09AB: 1B          dec  de
09AC: 0B          dec  bc
09AD: 27          daa
09AE: 0B          dec  bc
09AF: 33          inc  sp
09B0: 0B          dec  bc
09B1: 3F          ccf
09B2: 0B          dec  bc
09B3: 5B          ld   e,e
09B4: 0B          dec  bc
09B5: 7E          ld   a,(hl)
09B6: 0C          inc  c
09B7: 43          ld   b,e
09B8: 0C          inc  c
09B9: AE          xor  (hl)
09BA: 0C          inc  c
09BB: BF          cp   a
09BC: 0C          inc  c
09BD: D1          pop  de
09BE: 0C          inc  c
09BF: DE 0C       sbc  a,$0C
09C1: EB          ex   de,hl
09C2: 0C          inc  c
09C3: 56          ld   d,(hl)
09C4: 0D          dec  c
09C5: 8B          adc  a,e
09C6: 0D          dec  c
09C7: C7          rst  $00
09C8: 0D          dec  c
09C9: 1B          dec  de
09CA: 0F          rrca
09CB: 32 0F EB    ld   ($EB0F),a
09CE: 0B          dec  bc
09CF: 4C          ld   c,h
09D0: 0A          ld   a,(bc)
09D1: 5B          ld   e,e
09D2: 0A          ld   a,(bc)
09D3: 4C          ld   c,h
09D4: 0F          rrca
09D5: 55          ld   d,l
09D6: 0F          rrca
09D7: 63          ld   h,e
09D8: 0F          rrca
09D9: 7F          ld   a,a
09DA: 0F          rrca
09DB: 79          ld   a,c
09DC: 0E 5B       ld   c,$5B
09DE: 0A          ld   a,(bc)
09DF: 24          inc  h
09E0: 0F          rrca
09E1: D5          push de
09E2: 21 00 40    ld   hl,$4000
09E5: 11 01 40    ld   de,$4001
09E8: 01 FF 17    ld   bc,$17FF
09EB: 36 00       ld   (hl),$00
09ED: ED B0       ldir
09EF: 21 00 80    ld   hl,$8000
09F2: 11 01 80    ld   de,$8001
09F5: 01 7F 02    ld   bc,$027F
09F8: 36 00       ld   (hl),$00
09FA: ED B0       ldir
09FC: 21 00 83    ld   hl,$8300
09FF: 3E 00       ld   a,$00
0A01: 06 00       ld   b,$00
0A03: 77          ld   (hl),a
0A04: 23          inc  hl
0A05: 10 FC       djnz $0A03
0A07: 32 00 A1    ld   ($A100),a
0A0A: 21 00 80    ld   hl,$8000
0A0D: 22 00 81    ld   ($8100),hl
0A10: 22 02 81    ld   ($8102),hl
0A13: 21 44 0A    ld   hl,$0A44
0A16: 11 02 82    ld   de,$8202
0A19: 01 08 00    ld   bc,$0008
0A1C: ED B0       ldir
0A1E: 21 AD 81    ld   hl,$81AD
0A21: 3E 04       ld   a,$04
0A23: 06 02       ld   b,$02
0A25: 77          ld   (hl),a
0A26: 23          inc  hl
0A27: 10 FC       djnz $0A25
0A29: 32 00 A1    ld   ($A100),a
0A2C: 21 03 0E    ld   hl,$0E03
0A2F: 22 16 82    ld   ($8216),hl
0A32: 3E 01       ld   a,$01
0A34: 32 19 82    ld   ($8219),a
0A37: 32 02 A0    ld   ($A002),a
0A3A: 32 71 40    ld   ($4071),a
0A3D: 3E 10       ld   a,$10
0A3F: 32 18 82    ld   ($8218),a
0A42: D1          pop  de
0A43: C9          ret
0A44: 01 01 01    ld   bc,$0101
0A47: 01 01 02    ld   bc,$0201
0A4A: 03          inc  bc
0A4B: 03          inc  bc
0A4C: 06 3C       ld   b,$3C
0A4E: CD 5B 0A    call $0A5B
0A51: 10 FB       djnz $0A4E
0A53: C9          ret
0A54: 06 07       ld   b,$07
0A56: CD 5B 0A    call $0A5B
0A59: 10 FB       djnz $0A56
0A5B: 3A 15 82    ld   a,($8215)
0A5E: 4F          ld   c,a
0A5F: 3A 15 82    ld   a,($8215)
0A62: B9          cp   c
0A63: 28 FA       jr   z,$0A5F
0A65: C9          ret
0A66: 21 1A 82    ld   hl,$821A
0A69: 7E          ld   a,(hl)
0A6A: FE 1E       cp   $1E
0A6C: 30 17       jr   nc,$0A85
0A6E: 34          inc  (hl)
0A6F: 3A 0C 81    ld   a,($810C)
0A72: E6 04       and  $04
0A74: 20 1B       jr   nz,$0A91
0A76: 7E          ld   a,(hl)
0A77: FE 1E       cp   $1E
0A79: D8          ret  c
0A7A: 3E 01       ld   a,$01
0A7C: 32 06 A0    ld   ($A006),a
0A7F: 21 FE 11    ld   hl,$11FE
0A82: C3 AE 0F    jp   $0FAE
0A85: FE 24       cp   $24
0A87: 30 02       jr   nc,$0A8B
0A89: 34          inc  (hl)
0A8A: C9          ret
0A8B: 3A 0C 81    ld   a,($810C)
0A8E: E6 04       and  $04
0A90: C0          ret  nz
0A91: 3E 1F       ld   a,$1F
0A93: 32 1A 82    ld   ($821A),a
0A96: 21 0B 12    ld   hl,$120B
0A99: C3 AE 0F    jp   $0FAE
0A9C: D5          push de
0A9D: 3A 08 81    ld   a,($8108)
0AA0: 2F          cpl
0AA1: 57          ld   d,a
0AA2: 06 07       ld   b,$07
0AA4: 17          rla
0AA5: CB 19       rr   c
0AA7: 10 FB       djnz $0AA4
0AA9: 79          ld   a,c
0AAA: E6 0E       and  $0E
0AAC: 32 A0 40    ld   ($40A0),a
0AAF: CB 19       rr   c
0AB1: CB 19       rr   c
0AB3: 79          ld   a,c
0AB4: E6 0C       and  $0C
0AB6: 32 A1 40    ld   ($40A1),a
0AB9: 79          ld   a,c
0ABA: 1F          rra
0ABB: 1F          rra
0ABC: 1F          rra
0ABD: 1F          rra
0ABE: E6 03       and  $03
0AC0: 32 A2 40    ld   ($40A2),a
0AC3: 7A          ld   a,d
0AC4: E6 01       and  $01
0AC6: 32 A3 40    ld   ($40A3),a
0AC9: 3A 0D 81    ld   a,($810D)
0ACC: 2F          cpl
0ACD: 57          ld   d,a
0ACE: 06 08       ld   b,$08
0AD0: 17          rla
0AD1: CB 19       rr   c
0AD3: 10 FB       djnz $0AD0
0AD5: 79          ld   a,c
0AD6: E6 07       and  $07
0AD8: 32 A5 40    ld   ($40A5),a
0ADB: 79          ld   a,c
0ADC: 1F          rra
0ADD: 1F          rra
0ADE: 1F          rra
0ADF: E6 07       and  $07
0AE1: 32 A4 40    ld   ($40A4),a
0AE4: 7A          ld   a,d
0AE5: E6 01       and  $01
0AE7: 32 A6 40    ld   ($40A6),a
0AEA: 7A          ld   a,d
0AEB: 1F          rra
0AEC: E6 01       and  $01
0AEE: 32 A7 40    ld   ($40A7),a
0AF1: 3A 0C 81    ld   a,($810C)
0AF4: 0F          rrca
0AF5: E6 01       and  $01
0AF7: 32 FF 81    ld   ($81FF),a
0AFA: 21 10 82    ld   hl,$8210
0AFD: 11 11 82    ld   de,$8211
0B00: 01 07 00    ld   bc,$0007
0B03: ED B8       lddr
0B05: EB          ex   de,hl
0B06: 3A 0C 81    ld   a,($810C)
0B09: 77          ld   (hl),a
0B0A: 23          inc  hl
0B0B: B6          or   (hl)
0B0C: 2F          cpl
0B0D: 23          inc  hl
0B0E: A6          and  (hl)
0B0F: 23          inc  hl
0B10: A6          and  (hl)
0B11: 77          ld   (hl),a
0B12: D1          pop  de
0B13: A7          and  a
0B14: C8          ret  z
0B15: 3E 01       ld   a,$01
0B17: 32 14 82    ld   ($8214),a
0B1A: C9          ret
0B1B: 21 11 11    ld   hl,$1111
0B1E: CD AE 0F    call $0FAE
0B21: 3A 04 40    ld   a,($4004)
0B24: C3 D3 0F    jp   $0FD3
0B27: 21 1A 11    ld   hl,$111A
0B2A: CD AE 0F    call $0FAE
0B2D: 3A 05 40    ld   a,($4005)
0B30: C3 D3 0F    jp   $0FD3
0B33: 21 23 11    ld   hl,$1123
0B36: CD AE 0F    call $0FAE
0B39: 3A 06 40    ld   a,($4006)
0B3C: C3 D3 0F    jp   $0FD3
0B3F: 21 2F 11    ld   hl,$112F
0B42: CD AE 0F    call $0FAE
0B45: 3A FF 81    ld   a,($81FF)
0B48: A7          and  a
0B49: 28 08       jr   z,$0B53
0B4B: 3E 15       ld   a,$15
0B4D: 02          ld   (bc),a
0B4E: 03          inc  bc
0B4F: 3E 18       ld   a,$18
0B51: 02          ld   (bc),a
0B52: C9          ret
0B53: 3E 11       ld   a,$11
0B55: 02          ld   (bc),a
0B56: 03          inc  bc
0B57: 3E 12       ld   a,$12
0B59: 02          ld   (bc),a
0B5A: C9          ret
0B5B: 21 38 11    ld   hl,$1138
0B5E: CD AE 0F    call $0FAE
0B61: 3A 00 82    ld   a,($8200)
0B64: CD E2 0F    call $0FE2
0B67: 3A 14 82    ld   a,($8214)
0B6A: A7          and  a
0B6B: 28 32       jr   z,$0B9F
0B6D: AF          xor  a
0B6E: 32 14 82    ld   ($8214),a
0B71: CD EB 0B    call $0BEB
0B74: 3A 00 82    ld   a,($8200)
0B77: 21 04 0C    ld   hl,$0C04
0B7A: CF          rst  $08
0B7B: 3A 00 82    ld   a,($8200)
0B7E: D7          rst  $10
0B7F: 7E          ld   a,(hl)
0B80: 23          inc  hl
0B81: 4E          ld   c,(hl)
0B82: 23          inc  hl
0B83: 46          ld   b,(hl)
0B84: 02          ld   (bc),a
0B85: AF          xor  a
0B86: 32 60 41    ld   ($4160),a
0B89: 3A 00 82    ld   a,($8200)
0B8C: 3C          inc  a
0B8D: FE 15       cp   $15
0B8F: 38 01       jr   c,$0B92
0B91: AF          xor  a
0B92: 32 00 82    ld   ($8200),a
0B95: 3D          dec  a
0B96: FE 12       cp   $12
0B98: 38 05       jr   c,$0B9F
0B9A: 3E 03       ld   a,$03
0B9C: 32 60 41    ld   ($4160),a
0B9F: 2A 12 82    ld   hl,($8212)
0BA2: 3A 04 40    ld   a,($4004)
0BA5: 3C          inc  a
0BA6: 4F          ld   c,a
0BA7: 06 00       ld   b,$00
0BA9: 09          add  hl,bc
0BAA: DC E3 0B    call c,$0BE3
0BAD: 09          add  hl,bc
0BAE: DC E3 0B    call c,$0BE3
0BB1: 09          add  hl,bc
0BB2: DC E3 0B    call c,$0BE3
0BB5: 3A 05 40    ld   a,($4005)
0BB8: C6 10       add  a,$10
0BBA: 30 02       jr   nc,$0BBE
0BBC: 3E F0       ld   a,$F0
0BBE: 2F          cpl
0BBF: 4F          ld   c,a
0BC0: 06 FF       ld   b,$FF
0BC2: 03          inc  bc
0BC3: CB 21       sla  c
0BC5: CB 10       rl   b
0BC7: 09          add  hl,bc
0BC8: D4 E7 0B    call nc,$0BE7
0BCB: 09          add  hl,bc
0BCC: D4 E7 0B    call nc,$0BE7
0BCF: 09          add  hl,bc
0BD0: D4 E7 0B    call nc,$0BE7
0BD3: 22 12 82    ld   ($8212),hl
0BD6: 7C          ld   a,h
0BD7: 32 70 40    ld   ($4070),a
0BDA: A7          and  a
0BDB: 28 02       jr   z,$0BDF
0BDD: 3E 01       ld   a,$01
0BDF: 32 78 40    ld   ($4078),a
0BE2: C9          ret
0BE3: 21 FF FF    ld   hl,$FFFF
0BE6: C9          ret
0BE7: 21 00 00    ld   hl,$0000
0BEA: C9          ret
0BEB: 21 00 00    ld   hl,$0000
0BEE: 22 76 40    ld   ($4076),hl
0BF1: 21 20 83    ld   hl,$8320
0BF4: 3E 00       ld   a,$00
0BF6: 06 10       ld   b,$10
0BF8: 77          ld   (hl),a
0BF9: 23          inc  hl
0BFA: 10 FC       djnz $0BF8
0BFC: 32 00 A1    ld   ($A100),a
0BFF: AF          xor  a
0C00: 32 74 40    ld   ($4074),a
0C03: C9          ret
0C04: 80          add  a,b
0C05: 76          halt
0C06: 40          ld   b,b
0C07: 40          ld   b,b
0C08: 76          halt
0C09: 40          ld   b,b
0C0A: 20 76       jr   nz,$0C82
0C0C: 40          ld   b,b
0C0D: 10 76       djnz $0C85
0C0F: 40          ld   b,b
0C10: 08          ex   af,af'
0C11: 76          halt
0C12: 40          ld   b,b
0C13: 04          inc  b
0C14: 76          halt
0C15: 40          ld   b,b
0C16: 02          ld   (bc),a
0C17: 76          halt
0C18: 40          ld   b,b
0C19: 01 76 40    ld   bc,$4076
0C1C: 80          add  a,b
0C1D: 77          ld   (hl),a
0C1E: 40          ld   b,b
0C1F: 40          ld   b,b
0C20: 77          ld   (hl),a
0C21: 40          ld   b,b
0C22: 20 77       jr   nz,$0C9B
0C24: 40          ld   b,b
0C25: 10 77       djnz $0C9E
0C27: 40          ld   b,b
0C28: 08          ex   af,af'
0C29: 77          ld   (hl),a
0C2A: 40          ld   b,b
0C2B: 04          inc  b
0C2C: 77          ld   (hl),a
0C2D: 40          ld   b,b
0C2E: 02          ld   (bc),a
0C2F: 77          ld   (hl),a
0C30: 40          ld   b,b
0C31: 01 77 40    ld   bc,$4077
0C34: 05          dec  b
0C35: 71          ld   (hl),c
0C36: 40          ld   b,b
0C37: 08          ex   af,af'
0C38: 74          ld   (hl),h
0C39: 40          ld   b,b
0C3A: 01 64 41    ld   bc,$4164
0C3D: 01 65 41    ld   bc,$4165
0C40: 01 66 41    ld   bc,$4166
0C43: 21 41 11    ld   hl,$1141
0C46: CD AE 0F    call $0FAE
0C49: E5          push hl
0C4A: 3A A0 40    ld   a,($40A0)
0C4D: 21 1A 12    ld   hl,$121A
0C50: CF          rst  $08
0C51: 7E          ld   a,(hl)
0C52: 32 03 82    ld   ($8203),a
0C55: A7          and  a
0C56: 28 1C       jr   z,$0C74
0C58: 02          ld   (bc),a
0C59: 23          inc  hl
0C5A: 03          inc  bc
0C5B: E3          ex   (sp),hl
0C5C: CD B2 0F    call $0FB2
0C5F: E3          ex   (sp),hl
0C60: 7E          ld   a,(hl)
0C61: 02          ld   (bc),a
0C62: 23          inc  hl
0C63: 03          inc  bc
0C64: 03          inc  bc
0C65: 7E          ld   a,(hl)
0C66: 23          inc  hl
0C67: 32 04 82    ld   ($8204),a
0C6A: 02          ld   (bc),a
0C6B: E3          ex   (sp),hl
0C6C: 03          inc  bc
0C6D: CD B2 0F    call $0FB2
0C70: E1          pop  hl
0C71: 7E          ld   a,(hl)
0C72: 02          ld   (bc),a
0C73: C9          ret
0C74: E1          pop  hl
0C75: 21 5F 11    ld   hl,$115F
0C78: CD AE 0F    call $0FAE
0C7B: C3 AE 0F    jp   $0FAE
0C7E: 21 56 11    ld   hl,$1156
0C81: CD AE 0F    call $0FAE
0C84: 3A A1 40    ld   a,($40A1)
0C87: 21 3A 12    ld   hl,$123A
0C8A: D7          rst  $10
0C8B: 7E          ld   a,(hl)
0C8C: 32 05 82    ld   ($8205),a
0C8F: 02          ld   (bc),a
0C90: 23          inc  hl
0C91: 03          inc  bc
0C92: E5          push hl
0C93: 21 4A 11    ld   hl,$114A
0C96: CD B2 0F    call $0FB2
0C99: E3          ex   (sp),hl
0C9A: 7E          ld   a,(hl)
0C9B: 02          ld   (bc),a
0C9C: 23          inc  hl
0C9D: 03          inc  bc
0C9E: 03          inc  bc
0C9F: 7E          ld   a,(hl)
0CA0: 23          inc  hl
0CA1: 32 06 82    ld   ($8206),a
0CA4: 02          ld   (bc),a
0CA5: E3          ex   (sp),hl
0CA6: 03          inc  bc
0CA7: CD B2 0F    call $0FB2
0CAA: E1          pop  hl
0CAB: 7E          ld   a,(hl)
0CAC: 02          ld   (bc),a
0CAD: C9          ret
0CAE: 21 93 11    ld   hl,$1193
0CB1: CD AE 0F    call $0FAE
0CB4: 3A A2 40    ld   a,($40A2)
0CB7: 21 CD 0C    ld   hl,$0CCD
0CBA: D7          rst  $10
0CBB: 7E          ld   a,(hl)
0CBC: C3 E2 0F    jp   $0FE2
0CBF: 21 9B 11    ld   hl,$119B
0CC2: CD AE 0F    call $0FAE
0CC5: 3A A3 40    ld   a,($40A3)
0CC8: C6 03       add  a,$03
0CCA: C3 E2 0F    jp   $0FE2
0CCD: 5A          ld   e,d
0CCE: 64          ld   h,h
0CCF: 6E          ld   l,(hl)
0CD0: 78          ld   a,b
0CD1: 21 A3 11    ld   hl,$11A3
0CD4: CD AE 0F    call $0FAE
0CD7: 3A A4 40    ld   a,($40A4)
0CDA: C6 0A       add  a,$0A
0CDC: 02          ld   (bc),a
0CDD: C9          ret
0CDE: 21 B4 11    ld   hl,$11B4
0CE1: CD AE 0F    call $0FAE
0CE4: 3A A5 40    ld   a,($40A5)
0CE7: C6 0A       add  a,$0A
0CE9: 02          ld   (bc),a
0CEA: C9          ret
0CEB: 3A 0D 82    ld   a,($820D)
0CEE: E6 40       and  $40
0CF0: 28 4B       jr   z,$0D3D
0CF2: 3A 06 40    ld   a,($4006)
0CF5: 32 00 40    ld   ($4000),a
0CF8: AF          xor  a
0CF9: 32 01 82    ld   ($8201),a
0CFC: D5          push de
0CFD: 11 44 4F    ld   de,$4F44
0D00: 21 0D 37    ld   hl,$370D
0D03: 01 03 02    ld   bc,$0203
0D06: CD F0 10    call $10F0
0D09: 06 04       ld   b,$04
0D0B: CD FA 10    call $10FA
0D0E: 23          inc  hl
0D0F: 06 03       ld   b,$03
0D11: CD F0 10    call $10F0
0D14: 06 02       ld   b,$02
0D16: CD F0 10    call $10F0
0D19: 2B          dec  hl
0D1A: 11 84 4F    ld   de,$4F84
0D1D: 06 03       ld   b,$03
0D1F: CD F0 10    call $10F0
0D22: 06 02       ld   b,$02
0D24: CD FA 10    call $10FA
0D27: 06 02       ld   b,$02
0D29: CD FA 10    call $10FA
0D2C: 06 02       ld   b,$02
0D2E: CD FA 10    call $10FA
0D31: 06 02       ld   b,$02
0D33: CD FA 10    call $10FA
0D36: 06 02       ld   b,$02
0D38: CD FA 10    call $10FA
0D3B: D1          pop  de
0D3C: C9          ret
0D3D: 3A 15 82    ld   a,($8215)
0D40: E6 03       and  $03
0D42: C0          ret  nz
0D43: 3A 01 82    ld   a,($8201)
0D46: 3C          inc  a
0D47: 32 01 82    ld   ($8201),a
0D4A: C0          ret  nz
0D4B: 21 40 4F    ld   hl,$4F40
0D4E: 01 24 60    ld   bc,$6024
0D51: 71          ld   (hl),c
0D52: 23          inc  hl
0D53: 10 FC       djnz $0D51
0D55: C9          ret
0D56: 3A 04 40    ld   a,($4004)
0D59: C6 30       add  a,$30
0D5B: FE B0       cp   $B0
0D5D: 38 12       jr   c,$0D71
0D5F: 3A 0D 82    ld   a,($820D)
0D62: E6 40       and  $40
0D64: 28 0B       jr   z,$0D71
0D66: 21 0C 37    ld   hl,$370C
0D69: 06 19       ld   b,$19
0D6B: AF          xor  a
0D6C: 77          ld   (hl),a
0D6D: 23          inc  hl
0D6E: 10 FC       djnz $0D6C
0D70: C9          ret
0D71: 3A 04 40    ld   a,($4004)
0D74: C6 30       add  a,$30
0D76: FE B0       cp   $B0
0D78: D8          ret  c
0D79: 3A 0D 82    ld   a,($820D)
0D7C: 1F          rra
0D7D: 1F          rra
0D7E: D0          ret  nc
0D7F: D5          push de
0D80: CD 67 05    call $0567
0D83: 21 E5 11    ld   hl,$11E5
0D86: CD AE 0F    call $0FAE
0D89: D1          pop  de
0D8A: C9          ret
0D8B: D5          push de
0D8C: CD 7A 03    call $037A
0D8F: 20 EF       jr   nz,$0D80
0D91: D1          pop  de
0D92: C9          ret
0D93: 11 E0 37    ld   de,$37E0
0D96: 21 B7 0D    ld   hl,$0DB7
0D99: 06 10       ld   b,$10
0D9B: CD A2 0D    call $0DA2
0D9E: 23          inc  hl
0D9F: 10 FA       djnz $0D9B
0DA1: C9          ret
0DA2: C5          push bc
0DA3: 01 10 00    ld   bc,$0010
0DA6: ED B0       ldir
0DA8: 06 10       ld   b,$10
0DAA: 1B          dec  de
0DAB: 2B          dec  hl
0DAC: 1A          ld   a,(de)
0DAD: BE          cp   (hl)
0DAE: 3E 08       ld   a,$08
0DB0: C2 AE 10    jp   nz,$10AE
0DB3: 10 F5       djnz $0DAA
0DB5: C1          pop  bc
0DB6: C9          ret
0DB7: 14          inc  d
0DB8: 29          add  hl,hl
0DB9: 52          ld   d,d
0DBA: A5          and  l
0DBB: 4A          ld   c,d
0DBC: 96          sub  (hl)
0DBD: 3C          inc  a
0DBE: 78          ld   a,b
0DBF: F0          ret  p
0DC0: E1          pop  hl
0DC1: C3 87 0E    jp   $0E87
0DC4: 6B          ld   l,e
0DC5: BD          cp   l
0DC6: DF          rst  $18
0DC7: 3A 0D 82    ld   a,($820D)
0DCA: 1F          rra
0DCB: 1F          rra
0DCC: D0          ret  nc
0DCD: 2A 16 82    ld   hl,($8216)
0DD0: 3A 06 40    ld   a,($4006)
0DD3: BE          cp   (hl)
0DD4: 28 07       jr   z,$0DDD
0DD6: 21 03 0E    ld   hl,$0E03
0DD9: 22 16 82    ld   ($8216),hl
0DDC: C9          ret
0DDD: 23          inc  hl
0DDE: 7E          ld   a,(hl)
0DDF: 22 16 82    ld   ($8216),hl
0DE2: 3C          inc  a
0DE3: C0          ret  nz
0DE4: 11 09 0E    ld   de,$0E09
0DE7: 21 40 4C    ld   hl,$4C40
0DEA: 0E 70       ld   c,$70
0DEC: 06 08       ld   b,$08
0DEE: 1A          ld   a,(de)
0DEF: 87          add  a,a
0DF0: 36 24       ld   (hl),$24
0DF2: 30 02       jr   nc,$0DF6
0DF4: 36 06       ld   (hl),$06
0DF6: 23          inc  hl
0DF7: 10 F6       djnz $0DEF
0DF9: 13          inc  de
0DFA: 0D          dec  c
0DFB: 20 EF       jr   nz,$0DEC
0DFD: 11 DD 09    ld   de,$09DD
0E00: C3 EB 0B    jp   $0BEB
0E03: 04          inc  b
0E04: 45          ld   b,l
0E05: 55          ld   d,l
0E06: 56          ld   d,(hl)
0E07: 91          sub  c
0E08: FF          rst  $38
0E09: 00          nop
0E0A: 00          nop
0E0B: 00          nop
0E0C: 00          nop
0E0D: 00          nop
0E0E: 00          nop
0E0F: 00          nop
0E10: 00          nop
0E11: 1E 00       ld   e,$00
0E13: 00          nop
0E14: 00          nop
0E15: 21 11 C7    ld   hl,$C711
0E18: 1C          inc  e
0E19: 4C          ld   c,h
0E1A: B2          or   d
0E1B: 28 A2       jr   z,$0DBF
0E1D: 50          ld   d,b
0E1E: 92          sub  d
0E1F: 28 82       jr   z,$0DA3
0E21: 50          ld   d,b
0E22: 91          sub  c
0E23: E7          rst  $20
0E24: 04          inc  b
0E25: 4C          ld   c,h
0E26: 90          sub  b
0E27: 28 88       jr   z,$0DB1
0E29: 21 10 48    ld   hl,$4810
0E2C: 90          sub  b
0E2D: 1E 39       ld   e,$39
0E2F: 87          add  a,a
0E30: 3E 00       ld   a,$00
0E32: 00          nop
0E33: 00          nop
0E34: 00          nop
0E35: 44          ld   b,h
0E36: E4 4E 38    call po,$384E
0E39: 45          ld   b,l
0E3A: 16 D1       ld   d,$D1
0E3C: 44          ld   b,h
0E3D: 65          ld   h,l
0E3E: 15          dec  d
0E3F: 50          ld   d,b
0E40: 44          ld   b,h
0E41: 55          ld   d,l
0E42: 15          dec  d
0E43: 50          ld   d,b
0E44: 44          ld   b,h
0E45: 4D          ld   c,l
0E46: F4 50 44    call p,$4450
0E49: 45          ld   b,l
0E4A: 14          inc  d
0E4B: 51          ld   d,c
0E4C: 44          ld   b,h
0E4D: 45          ld   b,l
0E4E: 14          inc  d
0E4F: 4E          ld   c,(hl)
0E50: 38 00       jr   c,$0E52
0E52: 00          nop
0E53: 00          nop
0E54: 00          nop
0E55: 01 07 DC    ld   bc,$DC07
0E58: 00          nop
0E59: 01 01 12    ld   bc,$1201
0E5C: 00          nop
0E5D: 01 01 11    ld   bc,$1101
0E60: 00          nop
0E61: 01 01 11    ld   bc,$1101
0E64: 00          nop
0E65: 01 01 11    ld   bc,$1101
0E68: 00          nop
0E69: 01 01 12    ld   bc,$1201
0E6C: 00          nop
0E6D: 01 F1 1C    ld   bc,$1CF1
0E70: 20 00       jr   nz,$0E72
0E72: 00          nop
0E73: 00          nop
0E74: 00          nop
0E75: 00          nop
0E76: 00          nop
0E77: 00          nop
0E78: 00          nop
0E79: AF          xor  a
0E7A: 32 07 40    ld   ($4007),a
0E7D: 3E 01       ld   a,$01
0E7F: 32 4A 40    ld   ($404A),a
0E82: 32 04 A0    ld   ($A004),a
0E85: 32 05 A0    ld   ($A005),a
0E88: AF          xor  a
0E89: 32 19 82    ld   ($8219),a
0E8C: C3 9B 00    jp   $009B
0E8F: 21 04 A0    ld   hl,$A004
0E92: 18 03       jr   $0E97
0E94: 21 05 A0    ld   hl,$A005
0E97: 3E 01       ld   a,$01
0E99: 32 48 40    ld   ($4048),a
0E9C: 77          ld   (hl),a
0E9D: D5          push de
0E9E: 11 00 00    ld   de,$0000
0EA1: 01 30 01    ld   bc,$0130
0EA4: 3A 48 40    ld   a,($4048)
0EA7: 32 00 A1    ld   ($A100),a
0EAA: A7          and  a
0EAB: 28 0B       jr   z,$0EB8
0EAD: 15          dec  d
0EAE: 20 F4       jr   nz,$0EA4
0EB0: 1D          dec  e
0EB1: 20 F1       jr   nz,$0EA4
0EB3: 0D          dec  c
0EB4: 20 EE       jr   nz,$0EA4
0EB6: 10 EC       djnz $0EA4
0EB8: 3A 49 40    ld   a,($4049)
0EBB: D1          pop  de
0EBC: A7          and  a
0EBD: C8          ret  z
0EBE: CB 7F       bit  7,a
0EC0: CA 87 10    jp   z,$1087
0EC3: E6 7F       and  $7F
0EC5: C3 D1 10    jp   $10D1
0EC8: 3E 01       ld   a,$01
0ECA: 32 01 A0    ld   ($A001),a
0ECD: 01 00 10    ld   bc,$1000
0ED0: CD F4 0E    call $0EF4
0ED3: D5          push de
0ED4: 21 FD 0E    ld   hl,$0EFD
0ED7: 11 00 90    ld   de,$9000
0EDA: 01 03 00    ld   bc,$0003
0EDD: ED A0       ldi
0EDF: D9          exx
0EE0: 3E C1       ld   a,$C1
0EE2: 32 00 91    ld   ($9100),a
0EE5: 3A 00 91    ld   a,($9100)
0EE8: FE 10       cp   $10
0EEA: 20 F9       jr   nz,$0EE5
0EEC: 01 00 01    ld   bc,$0100
0EEF: CD F4 0E    call $0EF4
0EF2: D1          pop  de
0EF3: C9          ret
0EF4: 0D          dec  c
0EF5: 32 00 A1    ld   ($A100),a
0EF8: 20 FA       jr   nz,$0EF4
0EFA: 10 F8       djnz $0EF4
0EFC: C9          ret
0EFD: 05          dec  b
0EFE: 05          dec  b
0EFF: 05          dec  b
0F00: 05          dec  b
0F01: ED 56       im   1
0F03: AF          xor  a
0F04: 32 00 A0    ld   ($A000),a
0F07: 3C          inc  a
0F08: 32 00 A0    ld   ($A000),a
0F0B: FB          ei
0F0C: C9          ret
0F0D: 21 00 4C    ld   hl,$4C00
0F10: 01 24 08    ld   bc,$0824
0F13: 71          ld   (hl),c
0F14: 2C          inc  l
0F15: 20 FC       jr   nz,$0F13
0F17: 24          inc  h
0F18: 10 F9       djnz $0F13
0F1A: C9          ret
0F1B: 3A 0C 81    ld   a,($810C)
0F1E: 87          add  a,a
0F1F: D8          ret  c
0F20: 11 A5 09    ld   de,$09A5
0F23: C9          ret
0F24: 3A 0C 81    ld   a,($810C)
0F27: 87          add  a,a
0F28: 38 04       jr   c,$0F2E
0F2A: 11 DD 09    ld   de,$09DD
0F2D: C9          ret
0F2E: 11 CB 09    ld   de,$09CB
0F31: C9          ret
0F32: 21 00 4C    ld   hl,$4C00
0F35: 06 04       ld   b,$04
0F37: 3E AC       ld   a,$AC
0F39: CB 45       bit  0,l
0F3B: 28 01       jr   z,$0F3E
0F3D: 3C          inc  a
0F3E: CB 6D       bit  5,l
0F40: 28 02       jr   z,$0F44
0F42: C6 02       add  a,$02
0F44: 77          ld   (hl),a
0F45: 2C          inc  l
0F46: 20 EF       jr   nz,$0F37
0F48: 24          inc  h
0F49: 10 EC       djnz $0F37
0F4B: C9          ret
0F4C: 3A 0C 81    ld   a,($810C)
0F4F: 87          add  a,a
0F50: D8          ret  c
0F51: 11 CF 09    ld   de,$09CF
0F54: C9          ret
0F55: F3          di
0F56: 3A 00 91    ld   a,($9100)
0F59: FE 10       cp   $10
0F5B: 20 F9       jr   nz,$0F56
0F5D: 01 00 08    ld   bc,$0800
0F60: C3 F4 0E    jp   $0EF4
0F63: 21 02 82    ld   hl,$8202
0F66: D5          push de
0F67: 11 00 90    ld   de,$9000
0F6A: 01 08 00    ld   bc,$0008
0F6D: 3E 01       ld   a,$01
0F6F: 12          ld   (de),a
0F70: D9          exx
0F71: 3E A1       ld   a,$A1
0F73: 32 00 91    ld   ($9100),a
0F76: 3A 00 91    ld   a,($9100)
0F79: FE 10       cp   $10
0F7B: 20 F9       jr   nz,$0F76
0F7D: D1          pop  de
0F7E: C9          ret
0F7F: 01 00 04    ld   bc,$0400
0F82: D5          push de
0F83: CD F4 0E    call $0EF4
0F86: 21 00 90    ld   hl,$9000
0F89: 11 0C 81    ld   de,$810C
0F8C: 01 03 00    ld   bc,$0003
0F8F: D9          exx
0F90: 3E 91       ld   a,$91
0F92: 32 00 91    ld   ($9100),a
0F95: 3A 00 91    ld   a,($9100)
0F98: FE 10       cp   $10
0F9A: 20 F9       jr   nz,$0F95
0F9C: D1          pop  de
0F9D: 3A 0C 81    ld   a,($810C)
0FA0: A7          and  a
0FA1: C8          ret  z
0FA2: FE A0       cp   $A0
0FA4: C8          ret  z
0FA5: 11 D7 09    ld   de,$09D7
0FA8: 21 18 82    ld   hl,$8218
0FAB: 35          dec  (hl)
0FAC: C0          ret  nz
0FAD: C7          rst  $00
0FAE: 4E          ld   c,(hl)
0FAF: 23          inc  hl
0FB0: 46          ld   b,(hl)
0FB1: 23          inc  hl
0FB2: 7E          ld   a,(hl)
0FB3: 23          inc  hl
0FB4: FE 2F       cp   $2F
0FB6: C8          ret  z
0FB7: FE 2E       cp   $2E
0FB9: 28 0E       jr   z,$0FC9
0FBB: FE 20       cp   $20
0FBD: 28 0E       jr   z,$0FCD
0FBF: D6 30       sub  $30
0FC1: FE 0A       cp   $0A
0FC3: 38 0A       jr   c,$0FCF
0FC5: D6 07       sub  $07
0FC7: 18 06       jr   $0FCF
0FC9: 3E 25       ld   a,$25
0FCB: 18 02       jr   $0FCF
0FCD: 3E 24       ld   a,$24
0FCF: 02          ld   (bc),a
0FD0: 03          inc  bc
0FD1: 18 DF       jr   $0FB2
0FD3: F5          push af
0FD4: 1F          rra
0FD5: 1F          rra
0FD6: 1F          rra
0FD7: 1F          rra
0FD8: E6 0F       and  $0F
0FDA: 02          ld   (bc),a
0FDB: 03          inc  bc
0FDC: F1          pop  af
0FDD: E6 0F       and  $0F
0FDF: 02          ld   (bc),a
0FE0: 03          inc  bc
0FE1: C9          ret
0FE2: E5          push hl
0FE3: 60          ld   h,b
0FE4: 69          ld   l,c
0FE5: 0E 00       ld   c,$00
0FE7: D6 0A       sub  $0A
0FE9: 38 03       jr   c,$0FEE
0FEB: 0C          inc  c
0FEC: 18 F9       jr   $0FE7
0FEE: C6 0A       add  a,$0A
0FF0: 47          ld   b,a
0FF1: 79          ld   a,c
0FF2: 0E 01       ld   c,$01
0FF4: D6 0A       sub  $0A
0FF6: 38 03       jr   c,$0FFB
0FF8: 0C          inc  c
0FF9: 18 F9       jr   $0FF4
0FFB: 0D          dec  c
0FFC: 20 0B       jr   nz,$1009
0FFE: 36 24       ld   (hl),$24
1000: 23          inc  hl
1001: C6 0A       add  a,$0A
1003: 20 08       jr   nz,$100D
1005: 3E 24       ld   a,$24
1007: 18 04       jr   $100D
1009: 71          ld   (hl),c
100A: 23          inc  hl
100B: C6 0A       add  a,$0A
100D: 77          ld   (hl),a
100E: 23          inc  hl
100F: 70          ld   (hl),b
1010: 23          inc  hl
1011: 44          ld   b,h
1012: 4D          ld   c,l
1013: E1          pop  hl
1014: C9          ret
1015: 08          ex   af,af'
1016: 54          ld   d,h
1017: 5D          ld   e,l
1018: 0E 08       ld   c,$08
101A: 06 04       ld   b,$04
101C: D9          exx
101D: 62          ld   h,d
101E: 6B          ld   l,e
101F: D9          exx
1020: D9          exx
1021: 7C          ld   a,h
1022: AD          xor  l
1023: 2F          cpl
1024: 87          add  a,a
1025: 87          add  a,a
1026: ED 6A       adc  hl,hl
1028: 7D          ld   a,l
1029: D9          exx
102A: 77          ld   (hl),a
102B: 32 00 A1    ld   ($A100),a
102E: 2C          inc  l
102F: 20 EF       jr   nz,$1020
1031: 24          inc  h
1032: 10 EC       djnz $1020
1034: 06 04       ld   b,$04
1036: 62          ld   h,d
1037: 6B          ld   l,e
1038: D9          exx
1039: EB          ex   de,hl
103A: D9          exx
103B: D9          exx
103C: 7C          ld   a,h
103D: AD          xor  l
103E: 2F          cpl
103F: 87          add  a,a
1040: 87          add  a,a
1041: ED 6A       adc  hl,hl
1043: 7D          ld   a,l
1044: D9          exx
1045: AE          xor  (hl)
1046: C2 9D 10    jp   nz,$109D
1049: 32 00 A1    ld   ($A100),a
104C: 2C          inc  l
104D: 20 EC       jr   nz,$103B
104F: 24          inc  h
1050: 10 E9       djnz $103B
1052: 6B          ld   l,e
1053: 62          ld   h,d
1054: 0D          dec  c
1055: 20 C3       jr   nz,$101A
1057: 08          ex   af,af'
1058: C9          ret
1059: 21 00 00    ld   hl,$0000
105C: D5          push de
105D: 11 FE 1F    ld   de,$1FFE
1060: 01 00 20    ld   bc,$2000
1063: CD 6E 10    call $106E
1066: 01 00 10    ld   bc,$1000
1069: CD 6E 10    call $106E
106C: D1          pop  de
106D: C9          ret
106E: AF          xor  a
106F: 86          add  a,(hl)
1070: 32 00 A1    ld   ($A100),a
1073: 23          inc  hl
1074: 0D          dec  c
1075: 20 F8       jr   nz,$106F
1077: 10 F6       djnz $106F
1079: 4F          ld   c,a
107A: 1A          ld   a,(de)
107B: B9          cp   c
107C: 20 02       jr   nz,$1080
107E: 13          inc  de
107F: C9          ret
1080: 7C          ld   a,h
1081: 1F          rra
1082: 1F          rra
1083: 1F          rra
1084: 1F          rra
1085: E6 01       and  $01
1087: CD 0D 0F    call $0F0D
108A: F5          push af
108B: 21 DE 11    ld   hl,$11DE
108E: CD AE 0F    call $0FAE
1091: F1          pop  af
1092: CD E2 0F    call $0FE2
1095: F3          di
1096: AF          xor  a
1097: 32 07 A0    ld   ($A007),a
109A: C3 9A 10    jp   $109A
109D: 08          ex   af,af'
109E: FE 04       cp   $04
10A0: 28 0C       jr   z,$10AE
10A2: FE 05       cp   $05
10A4: 28 08       jr   z,$10AE
10A6: 4F          ld   c,a
10A7: 08          ex   af,af'
10A8: E6 0F       and  $0F
10AA: 79          ld   a,c
10AB: 20 01       jr   nz,$10AE
10AD: 3C          inc  a
10AE: 21 00 4C    ld   hl,$4C00
10B1: 11 01 4C    ld   de,$4C01
10B4: 36 24       ld   (hl),$24
10B6: 01 FF 07    ld   bc,$07FF
10B9: ED B0       ldir
10BB: 32 8D 4C    ld   ($4C8D),a
10BE: 21 89 4C    ld   hl,$4C89
10C1: 36 1B       ld   (hl),$1B
10C3: 23          inc  hl
10C4: 36 0A       ld   (hl),$0A
10C6: 23          inc  hl
10C7: 36 16       ld   (hl),$16
10C9: F3          di
10CA: AF          xor  a
10CB: 32 07 A0    ld   ($A007),a
10CE: C3 CE 10    jp   $10CE
10D1: F5          push af
10D2: CD 0D 0F    call $0F0D
10D5: 21 D7 11    ld   hl,$11D7
10D8: CD AE 0F    call $0FAE
10DB: F1          pop  af
10DC: CD E2 0F    call $0FE2
10DF: F3          di
10E0: AF          xor  a
10E1: 32 07 A0    ld   ($A007),a
10E4: C3 E4 10    jp   $10E4
10E7: 21 C5 11    ld   hl,$11C5
10EA: CD AE 0F    call $0FAE
10ED: C3 AE 0F    jp   $0FAE
10F0: 3E 99       ld   a,$99
10F2: 96          sub  (hl)
10F3: 1F          rra
10F4: 1F          rra
10F5: 1F          rra
10F6: 1F          rra
10F7: CD 04 11    call $1104
10FA: 3E 99       ld   a,$99
10FC: 96          sub  (hl)
10FD: CD 04 11    call $1104
1100: 23          inc  hl
1101: 10 ED       djnz $10F0
1103: C9          ret
1104: E6 0F       and  $0F
1106: 12          ld   (de),a
1107: 13          inc  de
1108: 0D          dec  c
1109: C0          ret  nz
110A: 0E 03       ld   c,$03
110C: 3E 25       ld   a,$25
110E: 12          ld   (de),a
110F: 13          inc  de
1110: C9          ret
1111: C7          rst  $00
1112: 4C          ld   c,h
1113: 41          ld   b,c
1114: 43          ld   b,e
1115: 43          ld   b,e
1116: 45          ld   b,l
1117: 4C          ld   c,h
1118: 20 2F       jr   nz,$1149
111A: D3 4C       out  ($4C),a
111C: 42          ld   b,d
111D: 52          ld   d,d
111E: 41          ld   b,c
111F: 4B          ld   c,e
1120: 45          ld   b,l
1121: 20 2F       jr   nz,$1152
1123: 04          inc  b
1124: 4D          ld   c,l
1125: 53          ld   d,e
1126: 54          ld   d,h
1127: 45          ld   b,l
1128: 45          ld   b,l
1129: 52          ld   d,d
112A: 49          ld   c,c
112B: 4E          ld   c,(hl)
112C: 47          ld   b,a
112D: 20 2F       jr   nz,$115E
112F: 13          inc  de
1130: 4D          ld   c,l
1131: 53          ld   d,e
1132: 48          ld   c,b
1133: 49          ld   c,c
1134: 46          ld   b,(hl)
1135: 54          ld   d,h
1136: 20 2F       jr   nz,$1167
1138: 47          ld   b,a
1139: 4D          ld   c,l
113A: 53          ld   d,e
113B: 4F          ld   c,a
113C: 55          ld   d,l
113D: 4E          ld   c,(hl)
113E: 44          ld   b,h
113F: 20 2F       jr   nz,$1170
1141: 87          add  a,a
1142: 4D          ld   c,l
1143: 43          ld   b,e
1144: 4F          ld   c,a
1145: 49          ld   c,c
1146: 4E          ld   c,(hl)
1147: 31 20 2F    ld   sp,$2F20
114A: 43          ld   b,e
114B: 4F          ld   c,a
114C: 49          ld   c,c
114D: 4E          ld   c,(hl)
114E: 2F          cpl
114F: 43          ld   b,e
1150: 52          ld   d,d
1151: 45          ld   b,l
1152: 44          ld   b,h
1153: 49          ld   c,c
1154: 54          ld   d,h
1155: 2F          cpl
1156: C7          rst  $00
1157: 4D          ld   c,l
1158: 43          ld   b,e
1159: 4F          ld   c,a
115A: 49          ld   c,c
115B: 4E          ld   c,(hl)
115C: 32 20 2F    ld   ($2F20),a
115F: 87          add  a,a
1160: 4D          ld   c,l
1161: 46          ld   b,(hl)
1162: 52          ld   d,d
1163: 45          ld   b,l
1164: 45          ld   b,l
1165: 20 50       jr   nz,$11B7
1167: 4C          ld   c,h
1168: 41          ld   b,c
1169: 59          ld   e,c
116A: 20 20       jr   nz,$118C
116C: 20 20       jr   nz,$118E
116E: 20 20       jr   nz,$1190
1170: 20 20       jr   nz,$1192
1172: 20 20       jr   nz,$1194
1174: 20 20       jr   nz,$1196
1176: 20 20       jr   nz,$1198
1178: 2F          cpl
1179: C7          rst  $00
117A: 4D          ld   c,l
117B: 20 20       jr   nz,$119D
117D: 20 20       jr   nz,$119F
117F: 20 20       jr   nz,$11A1
1181: 20 20       jr   nz,$11A3
1183: 20 20       jr   nz,$11A5
1185: 20 20       jr   nz,$11A7
1187: 20 20       jr   nz,$11A9
1189: 20 20       jr   nz,$11AB
118B: 20 20       jr   nz,$11AD
118D: 20 20       jr   nz,$11AF
118F: 20 20       jr   nz,$11B1
1191: 20 2F       jr   nz,$11C2
1193: 08          ex   af,af'
1194: 4E          ld   c,(hl)
1195: 54          ld   d,h
1196: 49          ld   c,c
1197: 4D          ld   c,l
1198: 45          ld   b,l
1199: 20 2F       jr   nz,$11CA
119B: 48          ld   c,b
119C: 4E          ld   c,(hl)
119D: 47          ld   b,a
119E: 4F          ld   c,a
119F: 41          ld   b,c
11A0: 4C          ld   c,h
11A1: 20 2F       jr   nz,$11D2
11A3: 84          add  a,h
11A4: 4E          ld   c,(hl)
11A5: 45          ld   b,l
11A6: 58          ld   e,b
11A7: 54          ld   d,h
11A8: 45          ld   b,l
11A9: 4E          ld   c,(hl)
11AA: 44          ld   b,h
11AB: 45          ld   b,l
11AC: 44          ld   b,h
11AD: 20 52       jr   nz,$1201
11AF: 41          ld   b,c
11B0: 4E          ld   c,(hl)
11B1: 4B          ld   c,e
11B2: 20 2F       jr   nz,$11E3
11B4: C4 4E 50    call nz,$504E
11B7: 52          ld   d,d
11B8: 41          ld   b,c
11B9: 43          ld   b,e
11BA: 54          ld   d,h
11BB: 49          ld   c,c
11BC: 43          ld   b,e
11BD: 45          ld   b,l
11BE: 20 52       jr   nz,$1212
11C0: 41          ld   b,c
11C1: 4E          ld   c,(hl)
11C2: 4B          ld   c,e
11C3: 20 2F       jr   nz,$11F4
11C5: 89          adc  a,c
11C6: 4C          ld   c,h
11C7: 52          ld   d,d
11C8: 41          ld   b,c
11C9: 4D          ld   c,l
11CA: 20 4F       jr   nz,$121B
11CC: 4B          ld   c,e
11CD: 2F          cpl
11CE: 95          sub  l
11CF: 4C          ld   c,h
11D0: 52          ld   d,d
11D1: 4F          ld   c,a
11D2: 4D          ld   c,l
11D3: 20 4F       jr   nz,$1224
11D5: 4B          ld   c,e
11D6: 2F          cpl
11D7: 89          adc  a,c
11D8: 4C          ld   c,h
11D9: 52          ld   d,d
11DA: 41          ld   b,c
11DB: 4D          ld   c,l
11DC: 20 2F       jr   nz,$120D
11DE: 95          sub  l
11DF: 4C          ld   c,h
11E0: 52          ld   d,d
11E1: 4F          ld   c,a
11E2: 4D          ld   c,l
11E3: 20 2F       jr   nz,$1214
11E5: 44          ld   b,h
11E6: 4F          ld   c,a
11E7: 48          ld   c,b
11E8: 49          ld   c,c
11E9: 47          ld   b,a
11EA: 48          ld   c,b
11EB: 20 53       jr   nz,$1240
11ED: 43          ld   b,e
11EE: 4F          ld   c,a
11EF: 52          ld   d,d
11F0: 45          ld   b,l
11F1: 20 49       jr   nz,$123C
11F3: 4E          ld   c,(hl)
11F4: 49          ld   c,c
11F5: 54          ld   d,h
11F6: 49          ld   c,c
11F7: 41          ld   b,c
11F8: 4C          ld   c,h
11F9: 49          ld   c,c
11FA: 5A          ld   e,d
11FB: 45          ld   b,l
11FC: 44          ld   b,h
11FD: 2F          cpl
11FE: 04          inc  b
11FF: 4F          ld   c,a
1200: 41          ld   b,c
1201: 55          ld   d,l
1202: 54          ld   d,h
1203: 4F          ld   c,a
1204: 20 53       jr   nz,$1259
1206: 54          ld   d,h
1207: 41          ld   b,c
1208: 52          ld   d,d
1209: 54          ld   d,h
120A: 2F          cpl
120B: 04          inc  b
120C: 4F          ld   c,a
120D: 4D          ld   c,l
120E: 41          ld   b,c
120F: 4E          ld   c,(hl)
1210: 55          ld   d,l
1211: 41          ld   b,c
1212: 4C          ld   c,h
1213: 20 53       jr   nz,$1268
1215: 54          ld   d,h
1216: 41          ld   b,c
1217: 52          ld   d,d
1218: 54          ld   d,h
1219: 2F          cpl
121A: 01 24 01    ld   bc,$0124
121D: 24          inc  h
121E: 01 24 02    ld   bc,$0224
1221: 1C          inc  e
1222: 01 24 03    ld   bc,$0324
1225: 1C          inc  e
1226: 02          ld   (bc),a
1227: 1C          inc  e
1228: 01 24 03    ld   bc,$0324
122B: 1C          inc  e
122C: 01 24 03    ld   bc,$0324
122F: 1C          inc  e
1230: 02          ld   (bc),a
1231: 1C          inc  e
1232: 04          inc  b
1233: 1C          inc  e
1234: 03          inc  bc
1235: 1C          inc  e
1236: 00          nop
1237: 24          inc  h
1238: 01 24 01    ld   bc,$0124
123B: 24          inc  h
123C: 01 24 02    ld   bc,$0224
123F: 1C          inc  e
1240: 01 24 03    ld   bc,$0324
1243: 1C          inc  e
1244: 02          ld   (bc),a
1245: 1C          inc  e
1246: 04          inc  b
1247: 1C          inc  e
1248: 03          inc  bc
1249: 1C          inc  e
124A: FF          rst  $38
124B: FF          rst  $38
124C: FF          rst  $38
124D: FF          rst  $38
124E: FF          rst  $38
124F: FF          rst  $38
1250: FF          rst  $38
1251: FF          rst  $38
1252: FF          rst  $38
1253: FF          rst  $38
1254: FF          rst  $38
1255: FF          rst  $38
1256: FF          rst  $38
1257: FF          rst  $38
1258: FF          rst  $38
1259: FF          rst  $38
125A: FF          rst  $38
125B: FF          rst  $38
125C: FF          rst  $38
125D: FF          rst  $38
125E: FF          rst  $38
125F: FF          rst  $38
1260: FF          rst  $38
1261: FF          rst  $38
1262: FF          rst  $38
1263: FF          rst  $38
1264: FF          rst  $38
1265: FF          rst  $38
1266: FF          rst  $38
1267: FF          rst  $38
1268: FF          rst  $38
1269: FF          rst  $38
126A: FF          rst  $38
126B: FF          rst  $38
126C: FF          rst  $38
126D: FF          rst  $38
126E: FF          rst  $38
126F: FF          rst  $38
1270: FF          rst  $38
1271: FF          rst  $38
1272: FF          rst  $38
1273: FF          rst  $38
1274: FF          rst  $38
1275: FF          rst  $38
1276: FF          rst  $38
1277: FF          rst  $38
1278: FF          rst  $38
1279: FF          rst  $38
127A: FF          rst  $38
127B: FF          rst  $38
127C: FF          rst  $38
127D: FF          rst  $38
127E: FF          rst  $38
127F: FF          rst  $38
1280: FF          rst  $38
1281: FF          rst  $38
1282: FF          rst  $38
1283: FF          rst  $38
1284: FF          rst  $38
1285: FF          rst  $38
1286: FF          rst  $38
1287: FF          rst  $38
1288: FF          rst  $38
1289: FF          rst  $38
128A: FF          rst  $38
128B: FF          rst  $38
128C: FF          rst  $38
128D: FF          rst  $38
128E: FF          rst  $38
128F: FF          rst  $38
1290: FF          rst  $38
1291: FF          rst  $38
1292: FF          rst  $38
1293: FF          rst  $38
1294: FF          rst  $38
1295: FF          rst  $38
1296: FF          rst  $38
1297: FF          rst  $38
1298: FF          rst  $38
1299: FF          rst  $38
129A: FF          rst  $38
129B: FF          rst  $38
129C: FF          rst  $38
129D: FF          rst  $38
129E: FF          rst  $38
129F: FF          rst  $38
12A0: FF          rst  $38
12A1: FF          rst  $38
12A2: FF          rst  $38
12A3: FF          rst  $38
12A4: FF          rst  $38
12A5: FF          rst  $38
12A6: FF          rst  $38
12A7: FF          rst  $38
12A8: FF          rst  $38
12A9: FF          rst  $38
12AA: FF          rst  $38
12AB: FF          rst  $38
12AC: FF          rst  $38
12AD: FF          rst  $38
12AE: FF          rst  $38
12AF: FF          rst  $38
12B0: FF          rst  $38
12B1: FF          rst  $38
12B2: FF          rst  $38
12B3: FF          rst  $38
12B4: FF          rst  $38
12B5: FF          rst  $38
12B6: FF          rst  $38
12B7: FF          rst  $38
12B8: FF          rst  $38
12B9: FF          rst  $38
12BA: FF          rst  $38
12BB: FF          rst  $38
12BC: FF          rst  $38
12BD: FF          rst  $38
12BE: FF          rst  $38
12BF: FF          rst  $38
12C0: FF          rst  $38
12C1: FF          rst  $38
12C2: FF          rst  $38
12C3: FF          rst  $38
12C4: FF          rst  $38
12C5: FF          rst  $38
12C6: FF          rst  $38
12C7: FF          rst  $38
12C8: FF          rst  $38
12C9: FF          rst  $38
12CA: FF          rst  $38
12CB: FF          rst  $38
12CC: FF          rst  $38
12CD: FF          rst  $38
12CE: FF          rst  $38
12CF: FF          rst  $38
12D0: FF          rst  $38
12D1: FF          rst  $38
12D2: FF          rst  $38
12D3: FF          rst  $38
12D4: FF          rst  $38
12D5: FF          rst  $38
12D6: FF          rst  $38
12D7: FF          rst  $38
12D8: FF          rst  $38
12D9: FF          rst  $38
12DA: FF          rst  $38
12DB: FF          rst  $38
12DC: FF          rst  $38
12DD: FF          rst  $38
12DE: FF          rst  $38
12DF: FF          rst  $38
12E0: FF          rst  $38
12E1: FF          rst  $38
12E2: FF          rst  $38
12E3: FF          rst  $38
12E4: FF          rst  $38
12E5: FF          rst  $38
12E6: FF          rst  $38
12E7: FF          rst  $38
12E8: FF          rst  $38
12E9: FF          rst  $38
12EA: FF          rst  $38
12EB: FF          rst  $38
12EC: FF          rst  $38
12ED: FF          rst  $38
12EE: FF          rst  $38
12EF: FF          rst  $38
12F0: FF          rst  $38
12F1: FF          rst  $38
12F2: FF          rst  $38
12F3: FF          rst  $38
12F4: FF          rst  $38
12F5: FF          rst  $38
12F6: FF          rst  $38
12F7: FF          rst  $38
12F8: FF          rst  $38
12F9: FF          rst  $38
12FA: FF          rst  $38
12FB: FF          rst  $38
12FC: FF          rst  $38
12FD: FF          rst  $38
12FE: FF          rst  $38
12FF: FF          rst  $38
1300: FF          rst  $38
1301: FF          rst  $38
1302: FF          rst  $38
1303: FF          rst  $38
1304: FF          rst  $38
1305: FF          rst  $38
1306: FF          rst  $38
1307: FF          rst  $38
1308: FF          rst  $38
1309: FF          rst  $38
130A: FF          rst  $38
130B: FF          rst  $38
130C: FF          rst  $38
130D: FF          rst  $38
130E: FF          rst  $38
130F: FF          rst  $38
1310: FF          rst  $38
1311: FF          rst  $38
1312: FF          rst  $38
1313: FF          rst  $38
1314: FF          rst  $38
1315: FF          rst  $38
1316: FF          rst  $38
1317: FF          rst  $38
1318: FF          rst  $38
1319: FF          rst  $38
131A: FF          rst  $38
131B: FF          rst  $38
131C: FF          rst  $38
131D: FF          rst  $38
131E: FF          rst  $38
131F: FF          rst  $38
1320: FF          rst  $38
1321: FF          rst  $38
1322: FF          rst  $38
1323: FF          rst  $38
1324: FF          rst  $38
1325: FF          rst  $38
1326: FF          rst  $38
1327: FF          rst  $38
1328: FF          rst  $38
1329: FF          rst  $38
132A: FF          rst  $38
132B: FF          rst  $38
132C: FF          rst  $38
132D: FF          rst  $38
132E: FF          rst  $38
132F: FF          rst  $38
1330: FF          rst  $38
1331: FF          rst  $38
1332: FF          rst  $38
1333: FF          rst  $38
1334: FF          rst  $38
1335: FF          rst  $38
1336: FF          rst  $38
1337: FF          rst  $38
1338: FF          rst  $38
1339: FF          rst  $38
133A: FF          rst  $38
133B: FF          rst  $38
133C: FF          rst  $38
133D: FF          rst  $38
133E: FF          rst  $38
133F: FF          rst  $38
1340: FF          rst  $38
1341: FF          rst  $38
1342: FF          rst  $38
1343: FF          rst  $38
1344: FF          rst  $38
1345: FF          rst  $38
1346: FF          rst  $38
1347: FF          rst  $38
1348: FF          rst  $38
1349: FF          rst  $38
134A: FF          rst  $38
134B: FF          rst  $38
134C: FF          rst  $38
134D: FF          rst  $38
134E: FF          rst  $38
134F: FF          rst  $38
1350: FF          rst  $38
1351: FF          rst  $38
1352: FF          rst  $38
1353: FF          rst  $38
1354: FF          rst  $38
1355: FF          rst  $38
1356: FF          rst  $38
1357: FF          rst  $38
1358: FF          rst  $38
1359: FF          rst  $38
135A: FF          rst  $38
135B: FF          rst  $38
135C: FF          rst  $38
135D: FF          rst  $38
135E: FF          rst  $38
135F: FF          rst  $38
1360: FF          rst  $38
1361: FF          rst  $38
1362: FF          rst  $38
1363: FF          rst  $38
1364: FF          rst  $38
1365: FF          rst  $38
1366: FF          rst  $38
1367: FF          rst  $38
1368: FF          rst  $38
1369: FF          rst  $38
136A: FF          rst  $38
136B: FF          rst  $38
136C: FF          rst  $38
136D: FF          rst  $38
136E: FF          rst  $38
136F: FF          rst  $38
1370: FF          rst  $38
1371: FF          rst  $38
1372: FF          rst  $38
1373: FF          rst  $38
1374: FF          rst  $38
1375: FF          rst  $38
1376: FF          rst  $38
1377: FF          rst  $38
1378: FF          rst  $38
1379: FF          rst  $38
137A: FF          rst  $38
137B: FF          rst  $38
137C: FF          rst  $38
137D: FF          rst  $38
137E: FF          rst  $38
137F: FF          rst  $38
1380: FF          rst  $38
1381: FF          rst  $38
1382: FF          rst  $38
1383: FF          rst  $38
1384: FF          rst  $38
1385: FF          rst  $38
1386: FF          rst  $38
1387: FF          rst  $38
1388: FF          rst  $38
1389: FF          rst  $38
138A: FF          rst  $38
138B: FF          rst  $38
138C: FF          rst  $38
138D: FF          rst  $38
138E: FF          rst  $38
138F: FF          rst  $38
1390: FF          rst  $38
1391: FF          rst  $38
1392: FF          rst  $38
1393: FF          rst  $38
1394: FF          rst  $38
1395: FF          rst  $38
1396: FF          rst  $38
1397: FF          rst  $38
1398: FF          rst  $38
1399: FF          rst  $38
139A: FF          rst  $38
139B: FF          rst  $38
139C: FF          rst  $38
139D: FF          rst  $38
139E: FF          rst  $38
139F: FF          rst  $38
13A0: FF          rst  $38
13A1: FF          rst  $38
13A2: FF          rst  $38
13A3: FF          rst  $38
13A4: FF          rst  $38
13A5: FF          rst  $38
13A6: FF          rst  $38
13A7: FF          rst  $38
13A8: FF          rst  $38
13A9: FF          rst  $38
13AA: FF          rst  $38
13AB: FF          rst  $38
13AC: FF          rst  $38
13AD: FF          rst  $38
13AE: FF          rst  $38
13AF: FF          rst  $38
13B0: FF          rst  $38
13B1: FF          rst  $38
13B2: FF          rst  $38
13B3: FF          rst  $38
13B4: FF          rst  $38
13B5: FF          rst  $38
13B6: FF          rst  $38
13B7: FF          rst  $38
13B8: FF          rst  $38
13B9: FF          rst  $38
13BA: FF          rst  $38
13BB: FF          rst  $38
13BC: FF          rst  $38
13BD: FF          rst  $38
13BE: FF          rst  $38
13BF: FF          rst  $38
13C0: FF          rst  $38
13C1: FF          rst  $38
13C2: FF          rst  $38
13C3: FF          rst  $38
13C4: FF          rst  $38
13C5: FF          rst  $38
13C6: FF          rst  $38
13C7: FF          rst  $38
13C8: FF          rst  $38
13C9: FF          rst  $38
13CA: FF          rst  $38
13CB: FF          rst  $38
13CC: FF          rst  $38
13CD: FF          rst  $38
13CE: FF          rst  $38
13CF: FF          rst  $38
13D0: FF          rst  $38
13D1: FF          rst  $38
13D2: FF          rst  $38
13D3: FF          rst  $38
13D4: FF          rst  $38
13D5: FF          rst  $38
13D6: FF          rst  $38
13D7: FF          rst  $38
13D8: FF          rst  $38
13D9: FF          rst  $38
13DA: FF          rst  $38
13DB: FF          rst  $38
13DC: FF          rst  $38
13DD: FF          rst  $38
13DE: FF          rst  $38
13DF: FF          rst  $38
13E0: FF          rst  $38
13E1: FF          rst  $38
13E2: FF          rst  $38
13E3: FF          rst  $38
13E4: FF          rst  $38
13E5: FF          rst  $38
13E6: FF          rst  $38
13E7: FF          rst  $38
13E8: FF          rst  $38
13E9: FF          rst  $38
13EA: FF          rst  $38
13EB: FF          rst  $38
13EC: FF          rst  $38
13ED: FF          rst  $38
13EE: FF          rst  $38
13EF: FF          rst  $38
13F0: FF          rst  $38
13F1: FF          rst  $38
13F2: FF          rst  $38
13F3: FF          rst  $38
13F4: FF          rst  $38
13F5: FF          rst  $38
13F6: FF          rst  $38
13F7: FF          rst  $38
13F8: FF          rst  $38
13F9: FF          rst  $38
13FA: FF          rst  $38
13FB: FF          rst  $38
13FC: FF          rst  $38
13FD: FF          rst  $38
13FE: FF          rst  $38
13FF: FF          rst  $38
1400: FF          rst  $38
1401: FF          rst  $38
1402: FF          rst  $38
1403: FF          rst  $38
1404: FF          rst  $38
1405: FF          rst  $38
1406: FF          rst  $38
1407: FF          rst  $38
1408: FF          rst  $38
1409: FF          rst  $38
140A: FF          rst  $38
140B: FF          rst  $38
140C: FF          rst  $38
140D: FF          rst  $38
140E: FF          rst  $38
140F: FF          rst  $38
1410: FF          rst  $38
1411: FF          rst  $38
1412: FF          rst  $38
1413: FF          rst  $38
1414: FF          rst  $38
1415: FF          rst  $38
1416: FF          rst  $38
1417: FF          rst  $38
1418: FF          rst  $38
1419: FF          rst  $38
141A: FF          rst  $38
141B: FF          rst  $38
141C: FF          rst  $38
141D: FF          rst  $38
141E: FF          rst  $38
141F: FF          rst  $38
1420: FF          rst  $38
1421: FF          rst  $38
1422: FF          rst  $38
1423: FF          rst  $38
1424: FF          rst  $38
1425: FF          rst  $38
1426: FF          rst  $38
1427: FF          rst  $38
1428: FF          rst  $38
1429: FF          rst  $38
142A: FF          rst  $38
142B: FF          rst  $38
142C: FF          rst  $38
142D: FF          rst  $38
142E: FF          rst  $38
142F: FF          rst  $38
1430: FF          rst  $38
1431: FF          rst  $38
1432: FF          rst  $38
1433: FF          rst  $38
1434: FF          rst  $38
1435: FF          rst  $38
1436: FF          rst  $38
1437: FF          rst  $38
1438: FF          rst  $38
1439: FF          rst  $38
143A: FF          rst  $38
143B: FF          rst  $38
143C: FF          rst  $38
143D: FF          rst  $38
143E: FF          rst  $38
143F: FF          rst  $38
1440: FF          rst  $38
1441: FF          rst  $38
1442: FF          rst  $38
1443: FF          rst  $38
1444: FF          rst  $38
1445: FF          rst  $38
1446: FF          rst  $38
1447: FF          rst  $38
1448: FF          rst  $38
1449: FF          rst  $38
144A: FF          rst  $38
144B: FF          rst  $38
144C: FF          rst  $38
144D: FF          rst  $38
144E: FF          rst  $38
144F: FF          rst  $38
1450: FF          rst  $38
1451: FF          rst  $38
1452: FF          rst  $38
1453: FF          rst  $38
1454: FF          rst  $38
1455: FF          rst  $38
1456: FF          rst  $38
1457: FF          rst  $38
1458: FF          rst  $38
1459: FF          rst  $38
145A: FF          rst  $38
145B: FF          rst  $38
145C: FF          rst  $38
145D: FF          rst  $38
145E: FF          rst  $38
145F: FF          rst  $38
1460: FF          rst  $38
1461: FF          rst  $38
1462: FF          rst  $38
1463: FF          rst  $38
1464: FF          rst  $38
1465: FF          rst  $38
1466: FF          rst  $38
1467: FF          rst  $38
1468: FF          rst  $38
1469: FF          rst  $38
146A: FF          rst  $38
146B: FF          rst  $38
146C: FF          rst  $38
146D: FF          rst  $38
146E: FF          rst  $38
146F: FF          rst  $38
1470: FF          rst  $38
1471: FF          rst  $38
1472: FF          rst  $38
1473: FF          rst  $38
1474: FF          rst  $38
1475: FF          rst  $38
1476: FF          rst  $38
1477: FF          rst  $38
1478: FF          rst  $38
1479: FF          rst  $38
147A: FF          rst  $38
147B: FF          rst  $38
147C: FF          rst  $38
147D: FF          rst  $38
147E: FF          rst  $38
147F: FF          rst  $38
1480: FF          rst  $38
1481: FF          rst  $38
1482: FF          rst  $38
1483: FF          rst  $38
1484: FF          rst  $38
1485: FF          rst  $38
1486: FF          rst  $38
1487: FF          rst  $38
1488: FF          rst  $38
1489: FF          rst  $38
148A: FF          rst  $38
148B: FF          rst  $38
148C: FF          rst  $38
148D: FF          rst  $38
148E: FF          rst  $38
148F: FF          rst  $38
1490: FF          rst  $38
1491: FF          rst  $38
1492: FF          rst  $38
1493: FF          rst  $38
1494: FF          rst  $38
1495: FF          rst  $38
1496: FF          rst  $38
1497: FF          rst  $38
1498: FF          rst  $38
1499: FF          rst  $38
149A: FF          rst  $38
149B: FF          rst  $38
149C: FF          rst  $38
149D: FF          rst  $38
149E: FF          rst  $38
149F: FF          rst  $38
14A0: FF          rst  $38
14A1: FF          rst  $38
14A2: FF          rst  $38
14A3: FF          rst  $38
14A4: FF          rst  $38
14A5: FF          rst  $38
14A6: FF          rst  $38
14A7: FF          rst  $38
14A8: FF          rst  $38
14A9: FF          rst  $38
14AA: FF          rst  $38
14AB: FF          rst  $38
14AC: FF          rst  $38
14AD: FF          rst  $38
14AE: FF          rst  $38
14AF: FF          rst  $38
14B0: FF          rst  $38
14B1: FF          rst  $38
14B2: FF          rst  $38
14B3: FF          rst  $38
14B4: FF          rst  $38
14B5: FF          rst  $38
14B6: FF          rst  $38
14B7: FF          rst  $38
14B8: FF          rst  $38
14B9: FF          rst  $38
14BA: FF          rst  $38
14BB: FF          rst  $38
14BC: FF          rst  $38
14BD: FF          rst  $38
14BE: FF          rst  $38
14BF: FF          rst  $38
14C0: FF          rst  $38
14C1: FF          rst  $38
14C2: FF          rst  $38
14C3: FF          rst  $38
14C4: FF          rst  $38
14C5: FF          rst  $38
14C6: FF          rst  $38
14C7: FF          rst  $38
14C8: FF          rst  $38
14C9: FF          rst  $38
14CA: FF          rst  $38
14CB: FF          rst  $38
14CC: FF          rst  $38
14CD: FF          rst  $38
14CE: FF          rst  $38
14CF: FF          rst  $38
14D0: FF          rst  $38
14D1: FF          rst  $38
14D2: FF          rst  $38
14D3: FF          rst  $38
14D4: FF          rst  $38
14D5: FF          rst  $38
14D6: FF          rst  $38
14D7: FF          rst  $38
14D8: FF          rst  $38
14D9: FF          rst  $38
14DA: FF          rst  $38
14DB: FF          rst  $38
14DC: FF          rst  $38
14DD: FF          rst  $38
14DE: FF          rst  $38
14DF: FF          rst  $38
14E0: FF          rst  $38
14E1: FF          rst  $38
14E2: FF          rst  $38
14E3: FF          rst  $38
14E4: FF          rst  $38
14E5: FF          rst  $38
14E6: FF          rst  $38
14E7: FF          rst  $38
14E8: FF          rst  $38
14E9: FF          rst  $38
14EA: FF          rst  $38
14EB: FF          rst  $38
14EC: FF          rst  $38
14ED: FF          rst  $38
14EE: FF          rst  $38
14EF: FF          rst  $38
14F0: FF          rst  $38
14F1: FF          rst  $38
14F2: FF          rst  $38
14F3: FF          rst  $38
14F4: FF          rst  $38
14F5: FF          rst  $38
14F6: FF          rst  $38
14F7: FF          rst  $38
14F8: FF          rst  $38
14F9: FF          rst  $38
14FA: FF          rst  $38
14FB: FF          rst  $38
14FC: FF          rst  $38
14FD: FF          rst  $38
14FE: FF          rst  $38
14FF: FF          rst  $38
1500: FF          rst  $38
1501: FF          rst  $38
1502: FF          rst  $38
1503: FF          rst  $38
1504: FF          rst  $38
1505: FF          rst  $38
1506: FF          rst  $38
1507: FF          rst  $38
1508: FF          rst  $38
1509: FF          rst  $38
150A: FF          rst  $38
150B: FF          rst  $38
150C: FF          rst  $38
150D: FF          rst  $38
150E: FF          rst  $38
150F: FF          rst  $38
1510: FF          rst  $38
1511: FF          rst  $38
1512: FF          rst  $38
1513: FF          rst  $38
1514: FF          rst  $38
1515: FF          rst  $38
1516: FF          rst  $38
1517: FF          rst  $38
1518: FF          rst  $38
1519: FF          rst  $38
151A: FF          rst  $38
151B: FF          rst  $38
151C: FF          rst  $38
151D: FF          rst  $38
151E: FF          rst  $38
151F: FF          rst  $38
1520: FF          rst  $38
1521: FF          rst  $38
1522: FF          rst  $38
1523: FF          rst  $38
1524: FF          rst  $38
1525: FF          rst  $38
1526: FF          rst  $38
1527: FF          rst  $38
1528: FF          rst  $38
1529: FF          rst  $38
152A: FF          rst  $38
152B: FF          rst  $38
152C: FF          rst  $38
152D: FF          rst  $38
152E: FF          rst  $38
152F: FF          rst  $38
1530: FF          rst  $38
1531: FF          rst  $38
1532: FF          rst  $38
1533: FF          rst  $38
1534: FF          rst  $38
1535: FF          rst  $38
1536: FF          rst  $38
1537: FF          rst  $38
1538: FF          rst  $38
1539: FF          rst  $38
153A: FF          rst  $38
153B: FF          rst  $38
153C: FF          rst  $38
153D: FF          rst  $38
153E: FF          rst  $38
153F: FF          rst  $38
1540: FF          rst  $38
1541: FF          rst  $38
1542: FF          rst  $38
1543: FF          rst  $38
1544: FF          rst  $38
1545: FF          rst  $38
1546: FF          rst  $38
1547: FF          rst  $38
1548: FF          rst  $38
1549: FF          rst  $38
154A: FF          rst  $38
154B: FF          rst  $38
154C: FF          rst  $38
154D: FF          rst  $38
154E: FF          rst  $38
154F: FF          rst  $38
1550: FF          rst  $38
1551: FF          rst  $38
1552: FF          rst  $38
1553: FF          rst  $38
1554: FF          rst  $38
1555: FF          rst  $38
1556: FF          rst  $38
1557: FF          rst  $38
1558: FF          rst  $38
1559: FF          rst  $38
155A: FF          rst  $38
155B: FF          rst  $38
155C: FF          rst  $38
155D: FF          rst  $38
155E: FF          rst  $38
155F: FF          rst  $38
1560: FF          rst  $38
1561: FF          rst  $38
1562: FF          rst  $38
1563: FF          rst  $38
1564: FF          rst  $38
1565: FF          rst  $38
1566: FF          rst  $38
1567: FF          rst  $38
1568: FF          rst  $38
1569: FF          rst  $38
156A: FF          rst  $38
156B: FF          rst  $38
156C: FF          rst  $38
156D: FF          rst  $38
156E: FF          rst  $38
156F: FF          rst  $38
1570: FF          rst  $38
1571: FF          rst  $38
1572: FF          rst  $38
1573: FF          rst  $38
1574: FF          rst  $38
1575: FF          rst  $38
1576: FF          rst  $38
1577: FF          rst  $38
1578: FF          rst  $38
1579: FF          rst  $38
157A: FF          rst  $38
157B: FF          rst  $38
157C: FF          rst  $38
157D: FF          rst  $38
157E: FF          rst  $38
157F: FF          rst  $38
1580: FF          rst  $38
1581: FF          rst  $38
1582: FF          rst  $38
1583: FF          rst  $38
1584: FF          rst  $38
1585: FF          rst  $38
1586: FF          rst  $38
1587: FF          rst  $38
1588: FF          rst  $38
1589: FF          rst  $38
158A: FF          rst  $38
158B: FF          rst  $38
158C: FF          rst  $38
158D: FF          rst  $38
158E: FF          rst  $38
158F: FF          rst  $38
1590: FF          rst  $38
1591: FF          rst  $38
1592: FF          rst  $38
1593: FF          rst  $38
1594: FF          rst  $38
1595: FF          rst  $38
1596: FF          rst  $38
1597: FF          rst  $38
1598: FF          rst  $38
1599: FF          rst  $38
159A: FF          rst  $38
159B: FF          rst  $38
159C: FF          rst  $38
159D: FF          rst  $38
159E: FF          rst  $38
159F: FF          rst  $38
15A0: FF          rst  $38
15A1: FF          rst  $38
15A2: FF          rst  $38
15A3: FF          rst  $38
15A4: FF          rst  $38
15A5: FF          rst  $38
15A6: FF          rst  $38
15A7: FF          rst  $38
15A8: FF          rst  $38
15A9: FF          rst  $38
15AA: FF          rst  $38
15AB: FF          rst  $38
15AC: FF          rst  $38
15AD: FF          rst  $38
15AE: FF          rst  $38
15AF: FF          rst  $38
15B0: FF          rst  $38
15B1: FF          rst  $38
15B2: FF          rst  $38
15B3: FF          rst  $38
15B4: FF          rst  $38
15B5: FF          rst  $38
15B6: FF          rst  $38
15B7: FF          rst  $38
15B8: FF          rst  $38
15B9: FF          rst  $38
15BA: FF          rst  $38
15BB: FF          rst  $38
15BC: FF          rst  $38
15BD: FF          rst  $38
15BE: FF          rst  $38
15BF: FF          rst  $38
15C0: FF          rst  $38
15C1: FF          rst  $38
15C2: FF          rst  $38
15C3: FF          rst  $38
15C4: FF          rst  $38
15C5: FF          rst  $38
15C6: FF          rst  $38
15C7: FF          rst  $38
15C8: FF          rst  $38
15C9: FF          rst  $38
15CA: FF          rst  $38
15CB: FF          rst  $38
15CC: FF          rst  $38
15CD: FF          rst  $38
15CE: FF          rst  $38
15CF: FF          rst  $38
15D0: FF          rst  $38
15D1: FF          rst  $38
15D2: FF          rst  $38
15D3: FF          rst  $38
15D4: FF          rst  $38
15D5: FF          rst  $38
15D6: FF          rst  $38
15D7: FF          rst  $38
15D8: FF          rst  $38
15D9: FF          rst  $38
15DA: FF          rst  $38
15DB: FF          rst  $38
15DC: FF          rst  $38
15DD: FF          rst  $38
15DE: FF          rst  $38
15DF: FF          rst  $38
15E0: FF          rst  $38
15E1: FF          rst  $38
15E2: FF          rst  $38
15E3: FF          rst  $38
15E4: FF          rst  $38
15E5: FF          rst  $38
15E6: FF          rst  $38
15E7: FF          rst  $38
15E8: FF          rst  $38
15E9: FF          rst  $38
15EA: FF          rst  $38
15EB: FF          rst  $38
15EC: FF          rst  $38
15ED: FF          rst  $38
15EE: FF          rst  $38
15EF: FF          rst  $38
15F0: FF          rst  $38
15F1: FF          rst  $38
15F2: FF          rst  $38
15F3: FF          rst  $38
15F4: FF          rst  $38
15F5: FF          rst  $38
15F6: FF          rst  $38
15F7: FF          rst  $38
15F8: FF          rst  $38
15F9: FF          rst  $38
15FA: FF          rst  $38
15FB: FF          rst  $38
15FC: FF          rst  $38
15FD: FF          rst  $38
15FE: FF          rst  $38
15FF: FF          rst  $38
1600: FF          rst  $38
1601: FF          rst  $38
1602: FF          rst  $38
1603: FF          rst  $38
1604: FF          rst  $38
1605: FF          rst  $38
1606: FF          rst  $38
1607: FF          rst  $38
1608: FF          rst  $38
1609: FF          rst  $38
160A: FF          rst  $38
160B: FF          rst  $38
160C: FF          rst  $38
160D: FF          rst  $38
160E: FF          rst  $38
160F: FF          rst  $38
1610: FF          rst  $38
1611: FF          rst  $38
1612: FF          rst  $38
1613: FF          rst  $38
1614: FF          rst  $38
1615: FF          rst  $38
1616: FF          rst  $38
1617: FF          rst  $38
1618: FF          rst  $38
1619: FF          rst  $38
161A: FF          rst  $38
161B: FF          rst  $38
161C: FF          rst  $38
161D: FF          rst  $38
161E: FF          rst  $38
161F: FF          rst  $38
1620: FF          rst  $38
1621: FF          rst  $38
1622: FF          rst  $38
1623: FF          rst  $38
1624: FF          rst  $38
1625: FF          rst  $38
1626: FF          rst  $38
1627: FF          rst  $38
1628: FF          rst  $38
1629: FF          rst  $38
162A: FF          rst  $38
162B: FF          rst  $38
162C: FF          rst  $38
162D: FF          rst  $38
162E: FF          rst  $38
162F: FF          rst  $38
1630: FF          rst  $38
1631: FF          rst  $38
1632: FF          rst  $38
1633: FF          rst  $38
1634: FF          rst  $38
1635: FF          rst  $38
1636: FF          rst  $38
1637: FF          rst  $38
1638: FF          rst  $38
1639: FF          rst  $38
163A: FF          rst  $38
163B: FF          rst  $38
163C: FF          rst  $38
163D: FF          rst  $38
163E: FF          rst  $38
163F: FF          rst  $38
1640: FF          rst  $38
1641: FF          rst  $38
1642: FF          rst  $38
1643: FF          rst  $38
1644: FF          rst  $38
1645: FF          rst  $38
1646: FF          rst  $38
1647: FF          rst  $38
1648: FF          rst  $38
1649: FF          rst  $38
164A: FF          rst  $38
164B: FF          rst  $38
164C: FF          rst  $38
164D: FF          rst  $38
164E: FF          rst  $38
164F: FF          rst  $38
1650: FF          rst  $38
1651: FF          rst  $38
1652: FF          rst  $38
1653: FF          rst  $38
1654: FF          rst  $38
1655: FF          rst  $38
1656: FF          rst  $38
1657: FF          rst  $38
1658: FF          rst  $38
1659: FF          rst  $38
165A: FF          rst  $38
165B: FF          rst  $38
165C: FF          rst  $38
165D: FF          rst  $38
165E: FF          rst  $38
165F: FF          rst  $38
1660: FF          rst  $38
1661: FF          rst  $38
1662: FF          rst  $38
1663: FF          rst  $38
1664: FF          rst  $38
1665: FF          rst  $38
1666: FF          rst  $38
1667: FF          rst  $38
1668: FF          rst  $38
1669: FF          rst  $38
166A: FF          rst  $38
166B: FF          rst  $38
166C: FF          rst  $38
166D: FF          rst  $38
166E: FF          rst  $38
166F: FF          rst  $38
1670: FF          rst  $38
1671: FF          rst  $38
1672: FF          rst  $38
1673: FF          rst  $38
1674: FF          rst  $38
1675: FF          rst  $38
1676: FF          rst  $38
1677: FF          rst  $38
1678: FF          rst  $38
1679: FF          rst  $38
167A: FF          rst  $38
167B: FF          rst  $38
167C: FF          rst  $38
167D: FF          rst  $38
167E: FF          rst  $38
167F: FF          rst  $38
1680: FF          rst  $38
1681: FF          rst  $38
1682: FF          rst  $38
1683: FF          rst  $38
1684: FF          rst  $38
1685: FF          rst  $38
1686: FF          rst  $38
1687: FF          rst  $38
1688: FF          rst  $38
1689: FF          rst  $38
168A: FF          rst  $38
168B: FF          rst  $38
168C: FF          rst  $38
168D: FF          rst  $38
168E: FF          rst  $38
168F: FF          rst  $38
1690: FF          rst  $38
1691: FF          rst  $38
1692: FF          rst  $38
1693: FF          rst  $38
1694: FF          rst  $38
1695: FF          rst  $38
1696: FF          rst  $38
1697: FF          rst  $38
1698: FF          rst  $38
1699: FF          rst  $38
169A: FF          rst  $38
169B: FF          rst  $38
169C: FF          rst  $38
169D: FF          rst  $38
169E: FF          rst  $38
169F: FF          rst  $38
16A0: FF          rst  $38
16A1: FF          rst  $38
16A2: FF          rst  $38
16A3: FF          rst  $38
16A4: FF          rst  $38
16A5: FF          rst  $38
16A6: FF          rst  $38
16A7: FF          rst  $38
16A8: FF          rst  $38
16A9: FF          rst  $38
16AA: FF          rst  $38
16AB: FF          rst  $38
16AC: FF          rst  $38
16AD: FF          rst  $38
16AE: FF          rst  $38
16AF: FF          rst  $38
16B0: FF          rst  $38
16B1: FF          rst  $38
16B2: FF          rst  $38
16B3: FF          rst  $38
16B4: FF          rst  $38
16B5: FF          rst  $38
16B6: FF          rst  $38
16B7: FF          rst  $38
16B8: FF          rst  $38
16B9: FF          rst  $38
16BA: FF          rst  $38
16BB: FF          rst  $38
16BC: FF          rst  $38
16BD: FF          rst  $38
16BE: FF          rst  $38
16BF: FF          rst  $38
16C0: FF          rst  $38
16C1: FF          rst  $38
16C2: FF          rst  $38
16C3: FF          rst  $38
16C4: FF          rst  $38
16C5: FF          rst  $38
16C6: FF          rst  $38
16C7: FF          rst  $38
16C8: FF          rst  $38
16C9: FF          rst  $38
16CA: FF          rst  $38
16CB: FF          rst  $38
16CC: FF          rst  $38
16CD: FF          rst  $38
16CE: FF          rst  $38
16CF: FF          rst  $38
16D0: FF          rst  $38
16D1: FF          rst  $38
16D2: FF          rst  $38
16D3: FF          rst  $38
16D4: FF          rst  $38
16D5: FF          rst  $38
16D6: FF          rst  $38
16D7: FF          rst  $38
16D8: FF          rst  $38
16D9: FF          rst  $38
16DA: FF          rst  $38
16DB: FF          rst  $38
16DC: FF          rst  $38
16DD: FF          rst  $38
16DE: FF          rst  $38
16DF: FF          rst  $38
16E0: FF          rst  $38
16E1: FF          rst  $38
16E2: FF          rst  $38
16E3: FF          rst  $38
16E4: FF          rst  $38
16E5: FF          rst  $38
16E6: FF          rst  $38
16E7: FF          rst  $38
16E8: FF          rst  $38
16E9: FF          rst  $38
16EA: FF          rst  $38
16EB: FF          rst  $38
16EC: FF          rst  $38
16ED: FF          rst  $38
16EE: FF          rst  $38
16EF: FF          rst  $38
16F0: FF          rst  $38
16F1: FF          rst  $38
16F2: FF          rst  $38
16F3: FF          rst  $38
16F4: FF          rst  $38
16F5: FF          rst  $38
16F6: FF          rst  $38
16F7: FF          rst  $38
16F8: FF          rst  $38
16F9: FF          rst  $38
16FA: FF          rst  $38
16FB: FF          rst  $38
16FC: FF          rst  $38
16FD: FF          rst  $38
16FE: FF          rst  $38
16FF: FF          rst  $38
1700: FF          rst  $38
1701: FF          rst  $38
1702: FF          rst  $38
1703: FF          rst  $38
1704: FF          rst  $38
1705: FF          rst  $38
1706: FF          rst  $38
1707: FF          rst  $38
1708: FF          rst  $38
1709: FF          rst  $38
170A: FF          rst  $38
170B: FF          rst  $38
170C: FF          rst  $38
170D: FF          rst  $38
170E: FF          rst  $38
170F: FF          rst  $38
1710: FF          rst  $38
1711: FF          rst  $38
1712: FF          rst  $38
1713: FF          rst  $38
1714: FF          rst  $38
1715: FF          rst  $38
1716: FF          rst  $38
1717: FF          rst  $38
1718: FF          rst  $38
1719: FF          rst  $38
171A: FF          rst  $38
171B: FF          rst  $38
171C: FF          rst  $38
171D: FF          rst  $38
171E: FF          rst  $38
171F: FF          rst  $38
1720: FF          rst  $38
1721: FF          rst  $38
1722: FF          rst  $38
1723: FF          rst  $38
1724: FF          rst  $38
1725: FF          rst  $38
1726: FF          rst  $38
1727: FF          rst  $38
1728: FF          rst  $38
1729: FF          rst  $38
172A: FF          rst  $38
172B: FF          rst  $38
172C: FF          rst  $38
172D: FF          rst  $38
172E: FF          rst  $38
172F: FF          rst  $38
1730: FF          rst  $38
1731: FF          rst  $38
1732: FF          rst  $38
1733: FF          rst  $38
1734: FF          rst  $38
1735: FF          rst  $38
1736: FF          rst  $38
1737: FF          rst  $38
1738: FF          rst  $38
1739: FF          rst  $38
173A: FF          rst  $38
173B: FF          rst  $38
173C: FF          rst  $38
173D: FF          rst  $38
173E: FF          rst  $38
173F: FF          rst  $38
1740: FF          rst  $38
1741: FF          rst  $38
1742: FF          rst  $38
1743: FF          rst  $38
1744: FF          rst  $38
1745: FF          rst  $38
1746: FF          rst  $38
1747: FF          rst  $38
1748: FF          rst  $38
1749: FF          rst  $38
174A: FF          rst  $38
174B: FF          rst  $38
174C: FF          rst  $38
174D: FF          rst  $38
174E: FF          rst  $38
174F: FF          rst  $38
1750: FF          rst  $38
1751: FF          rst  $38
1752: FF          rst  $38
1753: FF          rst  $38
1754: FF          rst  $38
1755: FF          rst  $38
1756: FF          rst  $38
1757: FF          rst  $38
1758: FF          rst  $38
1759: FF          rst  $38
175A: FF          rst  $38
175B: FF          rst  $38
175C: FF          rst  $38
175D: FF          rst  $38
175E: FF          rst  $38
175F: FF          rst  $38
1760: FF          rst  $38
1761: FF          rst  $38
1762: FF          rst  $38
1763: FF          rst  $38
1764: FF          rst  $38
1765: FF          rst  $38
1766: FF          rst  $38
1767: FF          rst  $38
1768: FF          rst  $38
1769: FF          rst  $38
176A: FF          rst  $38
176B: FF          rst  $38
176C: FF          rst  $38
176D: FF          rst  $38
176E: FF          rst  $38
176F: FF          rst  $38
1770: FF          rst  $38
1771: FF          rst  $38
1772: FF          rst  $38
1773: FF          rst  $38
1774: FF          rst  $38
1775: FF          rst  $38
1776: FF          rst  $38
1777: FF          rst  $38
1778: FF          rst  $38
1779: FF          rst  $38
177A: FF          rst  $38
177B: FF          rst  $38
177C: FF          rst  $38
177D: FF          rst  $38
177E: FF          rst  $38
177F: FF          rst  $38
1780: FF          rst  $38
1781: FF          rst  $38
1782: FF          rst  $38
1783: FF          rst  $38
1784: FF          rst  $38
1785: FF          rst  $38
1786: FF          rst  $38
1787: FF          rst  $38
1788: FF          rst  $38
1789: FF          rst  $38
178A: FF          rst  $38
178B: FF          rst  $38
178C: FF          rst  $38
178D: FF          rst  $38
178E: FF          rst  $38
178F: FF          rst  $38
1790: FF          rst  $38
1791: FF          rst  $38
1792: FF          rst  $38
1793: FF          rst  $38
1794: FF          rst  $38
1795: FF          rst  $38
1796: FF          rst  $38
1797: FF          rst  $38
1798: FF          rst  $38
1799: FF          rst  $38
179A: FF          rst  $38
179B: FF          rst  $38
179C: FF          rst  $38
179D: FF          rst  $38
179E: FF          rst  $38
179F: FF          rst  $38
17A0: FF          rst  $38
17A1: FF          rst  $38
17A2: FF          rst  $38
17A3: FF          rst  $38
17A4: FF          rst  $38
17A5: FF          rst  $38
17A6: FF          rst  $38
17A7: FF          rst  $38
17A8: FF          rst  $38
17A9: FF          rst  $38
17AA: FF          rst  $38
17AB: FF          rst  $38
17AC: FF          rst  $38
17AD: FF          rst  $38
17AE: FF          rst  $38
17AF: FF          rst  $38
17B0: FF          rst  $38
17B1: FF          rst  $38
17B2: FF          rst  $38
17B3: FF          rst  $38
17B4: FF          rst  $38
17B5: FF          rst  $38
17B6: FF          rst  $38
17B7: FF          rst  $38
17B8: FF          rst  $38
17B9: FF          rst  $38
17BA: FF          rst  $38
17BB: FF          rst  $38
17BC: FF          rst  $38
17BD: FF          rst  $38
17BE: FF          rst  $38
17BF: FF          rst  $38
17C0: FF          rst  $38
17C1: FF          rst  $38
17C2: FF          rst  $38
17C3: FF          rst  $38
17C4: FF          rst  $38
17C5: FF          rst  $38
17C6: FF          rst  $38
17C7: FF          rst  $38
17C8: FF          rst  $38
17C9: FF          rst  $38
17CA: FF          rst  $38
17CB: FF          rst  $38
17CC: FF          rst  $38
17CD: FF          rst  $38
17CE: FF          rst  $38
17CF: FF          rst  $38
17D0: FF          rst  $38
17D1: FF          rst  $38
17D2: FF          rst  $38
17D3: FF          rst  $38
17D4: FF          rst  $38
17D5: FF          rst  $38
17D6: FF          rst  $38
17D7: FF          rst  $38
17D8: FF          rst  $38
17D9: FF          rst  $38
17DA: FF          rst  $38
17DB: FF          rst  $38
17DC: FF          rst  $38
17DD: FF          rst  $38
17DE: FF          rst  $38
17DF: FF          rst  $38
17E0: FF          rst  $38
17E1: FF          rst  $38
17E2: FF          rst  $38
17E3: FF          rst  $38
17E4: FF          rst  $38
17E5: FF          rst  $38
17E6: FF          rst  $38
17E7: FF          rst  $38
17E8: FF          rst  $38
17E9: FF          rst  $38
17EA: FF          rst  $38
17EB: FF          rst  $38
17EC: FF          rst  $38
17ED: FF          rst  $38
17EE: FF          rst  $38
17EF: FF          rst  $38
17F0: FF          rst  $38
17F1: FF          rst  $38
17F2: FF          rst  $38
17F3: FF          rst  $38
17F4: FF          rst  $38
17F5: FF          rst  $38
17F6: FF          rst  $38
17F7: FF          rst  $38
17F8: FF          rst  $38
17F9: FF          rst  $38
17FA: FF          rst  $38
17FB: FF          rst  $38
17FC: FF          rst  $38
17FD: FF          rst  $38
17FE: FF          rst  $38
17FF: FF          rst  $38
1800: FF          rst  $38
1801: FF          rst  $38
1802: FF          rst  $38
1803: FF          rst  $38
1804: FF          rst  $38
1805: FF          rst  $38
1806: FF          rst  $38
1807: FF          rst  $38
1808: FF          rst  $38
1809: FF          rst  $38
180A: FF          rst  $38
180B: FF          rst  $38
180C: FF          rst  $38
180D: FF          rst  $38
180E: FF          rst  $38
180F: FF          rst  $38
1810: FF          rst  $38
1811: FF          rst  $38
1812: FF          rst  $38
1813: FF          rst  $38
1814: FF          rst  $38
1815: FF          rst  $38
1816: FF          rst  $38
1817: FF          rst  $38
1818: FF          rst  $38
1819: FF          rst  $38
181A: FF          rst  $38
181B: FF          rst  $38
181C: FF          rst  $38
181D: FF          rst  $38
181E: FF          rst  $38
181F: FF          rst  $38
1820: FF          rst  $38
1821: FF          rst  $38
1822: FF          rst  $38
1823: FF          rst  $38
1824: FF          rst  $38
1825: FF          rst  $38
1826: FF          rst  $38
1827: FF          rst  $38
1828: FF          rst  $38
1829: FF          rst  $38
182A: FF          rst  $38
182B: FF          rst  $38
182C: FF          rst  $38
182D: FF          rst  $38
182E: FF          rst  $38
182F: FF          rst  $38
1830: FF          rst  $38
1831: FF          rst  $38
1832: FF          rst  $38
1833: FF          rst  $38
1834: FF          rst  $38
1835: FF          rst  $38
1836: FF          rst  $38
1837: FF          rst  $38
1838: FF          rst  $38
1839: FF          rst  $38
183A: FF          rst  $38
183B: FF          rst  $38
183C: FF          rst  $38
183D: FF          rst  $38
183E: FF          rst  $38
183F: FF          rst  $38
1840: FF          rst  $38
1841: FF          rst  $38
1842: FF          rst  $38
1843: FF          rst  $38
1844: FF          rst  $38
1845: FF          rst  $38
1846: FF          rst  $38
1847: FF          rst  $38
1848: FF          rst  $38
1849: FF          rst  $38
184A: FF          rst  $38
184B: FF          rst  $38
184C: FF          rst  $38
184D: FF          rst  $38
184E: FF          rst  $38
184F: FF          rst  $38
1850: FF          rst  $38
1851: FF          rst  $38
1852: FF          rst  $38
1853: FF          rst  $38
1854: FF          rst  $38
1855: FF          rst  $38
1856: FF          rst  $38
1857: FF          rst  $38
1858: FF          rst  $38
1859: FF          rst  $38
185A: FF          rst  $38
185B: FF          rst  $38
185C: FF          rst  $38
185D: FF          rst  $38
185E: FF          rst  $38
185F: FF          rst  $38
1860: FF          rst  $38
1861: FF          rst  $38
1862: FF          rst  $38
1863: FF          rst  $38
1864: FF          rst  $38
1865: FF          rst  $38
1866: FF          rst  $38
1867: FF          rst  $38
1868: FF          rst  $38
1869: FF          rst  $38
186A: FF          rst  $38
186B: FF          rst  $38
186C: FF          rst  $38
186D: FF          rst  $38
186E: FF          rst  $38
186F: FF          rst  $38
1870: FF          rst  $38
1871: FF          rst  $38
1872: FF          rst  $38
1873: FF          rst  $38
1874: FF          rst  $38
1875: FF          rst  $38
1876: FF          rst  $38
1877: FF          rst  $38
1878: FF          rst  $38
1879: FF          rst  $38
187A: FF          rst  $38
187B: FF          rst  $38
187C: FF          rst  $38
187D: FF          rst  $38
187E: FF          rst  $38
187F: FF          rst  $38
1880: FF          rst  $38
1881: FF          rst  $38
1882: FF          rst  $38
1883: FF          rst  $38
1884: FF          rst  $38
1885: FF          rst  $38
1886: FF          rst  $38
1887: FF          rst  $38
1888: FF          rst  $38
1889: FF          rst  $38
188A: FF          rst  $38
188B: FF          rst  $38
188C: FF          rst  $38
188D: FF          rst  $38
188E: FF          rst  $38
188F: FF          rst  $38
1890: FF          rst  $38
1891: FF          rst  $38
1892: FF          rst  $38
1893: FF          rst  $38
1894: FF          rst  $38
1895: FF          rst  $38
1896: FF          rst  $38
1897: FF          rst  $38
1898: FF          rst  $38
1899: FF          rst  $38
189A: FF          rst  $38
189B: FF          rst  $38
189C: FF          rst  $38
189D: FF          rst  $38
189E: FF          rst  $38
189F: FF          rst  $38
18A0: FF          rst  $38
18A1: FF          rst  $38
18A2: FF          rst  $38
18A3: FF          rst  $38
18A4: FF          rst  $38
18A5: FF          rst  $38
18A6: FF          rst  $38
18A7: FF          rst  $38
18A8: FF          rst  $38
18A9: FF          rst  $38
18AA: FF          rst  $38
18AB: FF          rst  $38
18AC: FF          rst  $38
18AD: FF          rst  $38
18AE: FF          rst  $38
18AF: FF          rst  $38
18B0: FF          rst  $38
18B1: FF          rst  $38
18B2: FF          rst  $38
18B3: FF          rst  $38
18B4: FF          rst  $38
18B5: FF          rst  $38
18B6: FF          rst  $38
18B7: FF          rst  $38
18B8: FF          rst  $38
18B9: FF          rst  $38
18BA: FF          rst  $38
18BB: FF          rst  $38
18BC: FF          rst  $38
18BD: FF          rst  $38
18BE: FF          rst  $38
18BF: FF          rst  $38
18C0: FF          rst  $38
18C1: FF          rst  $38
18C2: FF          rst  $38
18C3: FF          rst  $38
18C4: FF          rst  $38
18C5: FF          rst  $38
18C6: FF          rst  $38
18C7: FF          rst  $38
18C8: FF          rst  $38
18C9: FF          rst  $38
18CA: FF          rst  $38
18CB: FF          rst  $38
18CC: FF          rst  $38
18CD: FF          rst  $38
18CE: FF          rst  $38
18CF: FF          rst  $38
18D0: FF          rst  $38
18D1: FF          rst  $38
18D2: FF          rst  $38
18D3: FF          rst  $38
18D4: FF          rst  $38
18D5: FF          rst  $38
18D6: FF          rst  $38
18D7: FF          rst  $38
18D8: FF          rst  $38
18D9: FF          rst  $38
18DA: FF          rst  $38
18DB: FF          rst  $38
18DC: FF          rst  $38
18DD: FF          rst  $38
18DE: FF          rst  $38
18DF: FF          rst  $38
18E0: FF          rst  $38
18E1: FF          rst  $38
18E2: FF          rst  $38
18E3: FF          rst  $38
18E4: FF          rst  $38
18E5: FF          rst  $38
18E6: FF          rst  $38
18E7: FF          rst  $38
18E8: FF          rst  $38
18E9: FF          rst  $38
18EA: FF          rst  $38
18EB: FF          rst  $38
18EC: FF          rst  $38
18ED: FF          rst  $38
18EE: FF          rst  $38
18EF: FF          rst  $38
18F0: FF          rst  $38
18F1: FF          rst  $38
18F2: FF          rst  $38
18F3: FF          rst  $38
18F4: FF          rst  $38
18F5: FF          rst  $38
18F6: FF          rst  $38
18F7: FF          rst  $38
18F8: FF          rst  $38
18F9: FF          rst  $38
18FA: FF          rst  $38
18FB: FF          rst  $38
18FC: FF          rst  $38
18FD: FF          rst  $38
18FE: FF          rst  $38
18FF: FF          rst  $38
1900: FF          rst  $38
1901: FF          rst  $38
1902: FF          rst  $38
1903: FF          rst  $38
1904: FF          rst  $38
1905: FF          rst  $38
1906: FF          rst  $38
1907: FF          rst  $38
1908: FF          rst  $38
1909: FF          rst  $38
190A: FF          rst  $38
190B: FF          rst  $38
190C: FF          rst  $38
190D: FF          rst  $38
190E: FF          rst  $38
190F: FF          rst  $38
1910: FF          rst  $38
1911: FF          rst  $38
1912: FF          rst  $38
1913: FF          rst  $38
1914: FF          rst  $38
1915: FF          rst  $38
1916: FF          rst  $38
1917: FF          rst  $38
1918: FF          rst  $38
1919: FF          rst  $38
191A: FF          rst  $38
191B: FF          rst  $38
191C: FF          rst  $38
191D: FF          rst  $38
191E: FF          rst  $38
191F: FF          rst  $38
1920: FF          rst  $38
1921: FF          rst  $38
1922: FF          rst  $38
1923: FF          rst  $38
1924: FF          rst  $38
1925: FF          rst  $38
1926: FF          rst  $38
1927: FF          rst  $38
1928: FF          rst  $38
1929: FF          rst  $38
192A: FF          rst  $38
192B: FF          rst  $38
192C: FF          rst  $38
192D: FF          rst  $38
192E: FF          rst  $38
192F: FF          rst  $38
1930: FF          rst  $38
1931: FF          rst  $38
1932: FF          rst  $38
1933: FF          rst  $38
1934: FF          rst  $38
1935: FF          rst  $38
1936: FF          rst  $38
1937: FF          rst  $38
1938: FF          rst  $38
1939: FF          rst  $38
193A: FF          rst  $38
193B: FF          rst  $38
193C: FF          rst  $38
193D: FF          rst  $38
193E: FF          rst  $38
193F: FF          rst  $38
1940: FF          rst  $38
1941: FF          rst  $38
1942: FF          rst  $38
1943: FF          rst  $38
1944: FF          rst  $38
1945: FF          rst  $38
1946: FF          rst  $38
1947: FF          rst  $38
1948: FF          rst  $38
1949: FF          rst  $38
194A: FF          rst  $38
194B: FF          rst  $38
194C: FF          rst  $38
194D: FF          rst  $38
194E: FF          rst  $38
194F: FF          rst  $38
1950: FF          rst  $38
1951: FF          rst  $38
1952: FF          rst  $38
1953: FF          rst  $38
1954: FF          rst  $38
1955: FF          rst  $38
1956: FF          rst  $38
1957: FF          rst  $38
1958: FF          rst  $38
1959: FF          rst  $38
195A: FF          rst  $38
195B: FF          rst  $38
195C: FF          rst  $38
195D: FF          rst  $38
195E: FF          rst  $38
195F: FF          rst  $38
1960: FF          rst  $38
1961: FF          rst  $38
1962: FF          rst  $38
1963: FF          rst  $38
1964: FF          rst  $38
1965: FF          rst  $38
1966: FF          rst  $38
1967: FF          rst  $38
1968: FF          rst  $38
1969: FF          rst  $38
196A: FF          rst  $38
196B: FF          rst  $38
196C: FF          rst  $38
196D: FF          rst  $38
196E: FF          rst  $38
196F: FF          rst  $38
1970: FF          rst  $38
1971: FF          rst  $38
1972: FF          rst  $38
1973: FF          rst  $38
1974: FF          rst  $38
1975: FF          rst  $38
1976: FF          rst  $38
1977: FF          rst  $38
1978: FF          rst  $38
1979: FF          rst  $38
197A: FF          rst  $38
197B: FF          rst  $38
197C: FF          rst  $38
197D: FF          rst  $38
197E: FF          rst  $38
197F: FF          rst  $38
1980: FF          rst  $38
1981: FF          rst  $38
1982: FF          rst  $38
1983: FF          rst  $38
1984: FF          rst  $38
1985: FF          rst  $38
1986: FF          rst  $38
1987: FF          rst  $38
1988: FF          rst  $38
1989: FF          rst  $38
198A: FF          rst  $38
198B: FF          rst  $38
198C: FF          rst  $38
198D: FF          rst  $38
198E: FF          rst  $38
198F: FF          rst  $38
1990: FF          rst  $38
1991: FF          rst  $38
1992: FF          rst  $38
1993: FF          rst  $38
1994: FF          rst  $38
1995: FF          rst  $38
1996: FF          rst  $38
1997: FF          rst  $38
1998: FF          rst  $38
1999: FF          rst  $38
199A: FF          rst  $38
199B: FF          rst  $38
199C: FF          rst  $38
199D: FF          rst  $38
199E: FF          rst  $38
199F: FF          rst  $38
19A0: FF          rst  $38
19A1: FF          rst  $38
19A2: FF          rst  $38
19A3: FF          rst  $38
19A4: FF          rst  $38
19A5: FF          rst  $38
19A6: FF          rst  $38
19A7: FF          rst  $38
19A8: FF          rst  $38
19A9: FF          rst  $38
19AA: FF          rst  $38
19AB: FF          rst  $38
19AC: FF          rst  $38
19AD: FF          rst  $38
19AE: FF          rst  $38
19AF: FF          rst  $38
19B0: FF          rst  $38
19B1: FF          rst  $38
19B2: FF          rst  $38
19B3: FF          rst  $38
19B4: FF          rst  $38
19B5: FF          rst  $38
19B6: FF          rst  $38
19B7: FF          rst  $38
19B8: FF          rst  $38
19B9: FF          rst  $38
19BA: FF          rst  $38
19BB: FF          rst  $38
19BC: FF          rst  $38
19BD: FF          rst  $38
19BE: FF          rst  $38
19BF: FF          rst  $38
19C0: FF          rst  $38
19C1: FF          rst  $38
19C2: FF          rst  $38
19C3: FF          rst  $38
19C4: FF          rst  $38
19C5: FF          rst  $38
19C6: FF          rst  $38
19C7: FF          rst  $38
19C8: FF          rst  $38
19C9: FF          rst  $38
19CA: FF          rst  $38
19CB: FF          rst  $38
19CC: FF          rst  $38
19CD: FF          rst  $38
19CE: FF          rst  $38
19CF: FF          rst  $38
19D0: FF          rst  $38
19D1: FF          rst  $38
19D2: FF          rst  $38
19D3: FF          rst  $38
19D4: FF          rst  $38
19D5: FF          rst  $38
19D6: FF          rst  $38
19D7: FF          rst  $38
19D8: FF          rst  $38
19D9: FF          rst  $38
19DA: FF          rst  $38
19DB: FF          rst  $38
19DC: FF          rst  $38
19DD: FF          rst  $38
19DE: FF          rst  $38
19DF: FF          rst  $38
19E0: FF          rst  $38
19E1: FF          rst  $38
19E2: FF          rst  $38
19E3: FF          rst  $38
19E4: FF          rst  $38
19E5: FF          rst  $38
19E6: FF          rst  $38
19E7: FF          rst  $38
19E8: FF          rst  $38
19E9: FF          rst  $38
19EA: FF          rst  $38
19EB: FF          rst  $38
19EC: FF          rst  $38
19ED: FF          rst  $38
19EE: FF          rst  $38
19EF: FF          rst  $38
19F0: FF          rst  $38
19F1: FF          rst  $38
19F2: FF          rst  $38
19F3: FF          rst  $38
19F4: FF          rst  $38
19F5: FF          rst  $38
19F6: FF          rst  $38
19F7: FF          rst  $38
19F8: FF          rst  $38
19F9: FF          rst  $38
19FA: FF          rst  $38
19FB: FF          rst  $38
19FC: FF          rst  $38
19FD: FF          rst  $38
19FE: FF          rst  $38
19FF: FF          rst  $38
1A00: FF          rst  $38
1A01: FF          rst  $38
1A02: FF          rst  $38
1A03: FF          rst  $38
1A04: FF          rst  $38
1A05: FF          rst  $38
1A06: FF          rst  $38
1A07: FF          rst  $38
1A08: FF          rst  $38
1A09: FF          rst  $38
1A0A: FF          rst  $38
1A0B: FF          rst  $38
1A0C: FF          rst  $38
1A0D: FF          rst  $38
1A0E: FF          rst  $38
1A0F: FF          rst  $38
1A10: FF          rst  $38
1A11: FF          rst  $38
1A12: FF          rst  $38
1A13: FF          rst  $38
1A14: FF          rst  $38
1A15: FF          rst  $38
1A16: FF          rst  $38
1A17: FF          rst  $38
1A18: FF          rst  $38
1A19: FF          rst  $38
1A1A: FF          rst  $38
1A1B: FF          rst  $38
1A1C: FF          rst  $38
1A1D: FF          rst  $38
1A1E: FF          rst  $38
1A1F: FF          rst  $38
1A20: FF          rst  $38
1A21: FF          rst  $38
1A22: FF          rst  $38
1A23: FF          rst  $38
1A24: FF          rst  $38
1A25: FF          rst  $38
1A26: FF          rst  $38
1A27: FF          rst  $38
1A28: FF          rst  $38
1A29: FF          rst  $38
1A2A: FF          rst  $38
1A2B: FF          rst  $38
1A2C: FF          rst  $38
1A2D: FF          rst  $38
1A2E: FF          rst  $38
1A2F: FF          rst  $38
1A30: FF          rst  $38
1A31: FF          rst  $38
1A32: FF          rst  $38
1A33: FF          rst  $38
1A34: FF          rst  $38
1A35: FF          rst  $38
1A36: FF          rst  $38
1A37: FF          rst  $38
1A38: FF          rst  $38
1A39: FF          rst  $38
1A3A: FF          rst  $38
1A3B: FF          rst  $38
1A3C: FF          rst  $38
1A3D: FF          rst  $38
1A3E: FF          rst  $38
1A3F: FF          rst  $38
1A40: FF          rst  $38
1A41: FF          rst  $38
1A42: FF          rst  $38
1A43: FF          rst  $38
1A44: FF          rst  $38
1A45: FF          rst  $38
1A46: FF          rst  $38
1A47: FF          rst  $38
1A48: FF          rst  $38
1A49: FF          rst  $38
1A4A: FF          rst  $38
1A4B: FF          rst  $38
1A4C: FF          rst  $38
1A4D: FF          rst  $38
1A4E: FF          rst  $38
1A4F: FF          rst  $38
1A50: FF          rst  $38
1A51: FF          rst  $38
1A52: FF          rst  $38
1A53: FF          rst  $38
1A54: FF          rst  $38
1A55: FF          rst  $38
1A56: FF          rst  $38
1A57: FF          rst  $38
1A58: FF          rst  $38
1A59: FF          rst  $38
1A5A: FF          rst  $38
1A5B: FF          rst  $38
1A5C: FF          rst  $38
1A5D: FF          rst  $38
1A5E: FF          rst  $38
1A5F: FF          rst  $38
1A60: FF          rst  $38
1A61: FF          rst  $38
1A62: FF          rst  $38
1A63: FF          rst  $38
1A64: FF          rst  $38
1A65: FF          rst  $38
1A66: FF          rst  $38
1A67: FF          rst  $38
1A68: FF          rst  $38
1A69: FF          rst  $38
1A6A: FF          rst  $38
1A6B: FF          rst  $38
1A6C: FF          rst  $38
1A6D: FF          rst  $38
1A6E: FF          rst  $38
1A6F: FF          rst  $38
1A70: FF          rst  $38
1A71: FF          rst  $38
1A72: FF          rst  $38
1A73: FF          rst  $38
1A74: FF          rst  $38
1A75: FF          rst  $38
1A76: FF          rst  $38
1A77: FF          rst  $38
1A78: FF          rst  $38
1A79: FF          rst  $38
1A7A: FF          rst  $38
1A7B: FF          rst  $38
1A7C: FF          rst  $38
1A7D: FF          rst  $38
1A7E: FF          rst  $38
1A7F: FF          rst  $38
1A80: FF          rst  $38
1A81: FF          rst  $38
1A82: FF          rst  $38
1A83: FF          rst  $38
1A84: FF          rst  $38
1A85: FF          rst  $38
1A86: FF          rst  $38
1A87: FF          rst  $38
1A88: FF          rst  $38
1A89: FF          rst  $38
1A8A: FF          rst  $38
1A8B: FF          rst  $38
1A8C: FF          rst  $38
1A8D: FF          rst  $38
1A8E: FF          rst  $38
1A8F: FF          rst  $38
1A90: FF          rst  $38
1A91: FF          rst  $38
1A92: FF          rst  $38
1A93: FF          rst  $38
1A94: FF          rst  $38
1A95: FF          rst  $38
1A96: FF          rst  $38
1A97: FF          rst  $38
1A98: FF          rst  $38
1A99: FF          rst  $38
1A9A: FF          rst  $38
1A9B: FF          rst  $38
1A9C: FF          rst  $38
1A9D: FF          rst  $38
1A9E: FF          rst  $38
1A9F: FF          rst  $38
1AA0: FF          rst  $38
1AA1: FF          rst  $38
1AA2: FF          rst  $38
1AA3: FF          rst  $38
1AA4: FF          rst  $38
1AA5: FF          rst  $38
1AA6: FF          rst  $38
1AA7: FF          rst  $38
1AA8: FF          rst  $38
1AA9: FF          rst  $38
1AAA: FF          rst  $38
1AAB: FF          rst  $38
1AAC: FF          rst  $38
1AAD: FF          rst  $38
1AAE: FF          rst  $38
1AAF: FF          rst  $38
1AB0: FF          rst  $38
1AB1: FF          rst  $38
1AB2: FF          rst  $38
1AB3: FF          rst  $38
1AB4: FF          rst  $38
1AB5: FF          rst  $38
1AB6: FF          rst  $38
1AB7: FF          rst  $38
1AB8: FF          rst  $38
1AB9: FF          rst  $38
1ABA: FF          rst  $38
1ABB: FF          rst  $38
1ABC: FF          rst  $38
1ABD: FF          rst  $38
1ABE: FF          rst  $38
1ABF: FF          rst  $38
1AC0: FF          rst  $38
1AC1: FF          rst  $38
1AC2: FF          rst  $38
1AC3: FF          rst  $38
1AC4: FF          rst  $38
1AC5: FF          rst  $38
1AC6: FF          rst  $38
1AC7: FF          rst  $38
1AC8: FF          rst  $38
1AC9: FF          rst  $38
1ACA: FF          rst  $38
1ACB: FF          rst  $38
1ACC: FF          rst  $38
1ACD: FF          rst  $38
1ACE: FF          rst  $38
1ACF: FF          rst  $38
1AD0: FF          rst  $38
1AD1: FF          rst  $38
1AD2: FF          rst  $38
1AD3: FF          rst  $38
1AD4: FF          rst  $38
1AD5: FF          rst  $38
1AD6: FF          rst  $38
1AD7: FF          rst  $38
1AD8: FF          rst  $38
1AD9: FF          rst  $38
1ADA: FF          rst  $38
1ADB: FF          rst  $38
1ADC: FF          rst  $38
1ADD: FF          rst  $38
1ADE: FF          rst  $38
1ADF: FF          rst  $38
1AE0: FF          rst  $38
1AE1: FF          rst  $38
1AE2: FF          rst  $38
1AE3: FF          rst  $38
1AE4: FF          rst  $38
1AE5: FF          rst  $38
1AE6: FF          rst  $38
1AE7: FF          rst  $38
1AE8: FF          rst  $38
1AE9: FF          rst  $38
1AEA: FF          rst  $38
1AEB: FF          rst  $38
1AEC: FF          rst  $38
1AED: FF          rst  $38
1AEE: FF          rst  $38
1AEF: FF          rst  $38
1AF0: FF          rst  $38
1AF1: FF          rst  $38
1AF2: FF          rst  $38
1AF3: FF          rst  $38
1AF4: FF          rst  $38
1AF5: FF          rst  $38
1AF6: FF          rst  $38
1AF7: FF          rst  $38
1AF8: FF          rst  $38
1AF9: FF          rst  $38
1AFA: FF          rst  $38
1AFB: FF          rst  $38
1AFC: FF          rst  $38
1AFD: FF          rst  $38
1AFE: FF          rst  $38
1AFF: FF          rst  $38
1B00: FF          rst  $38
1B01: FF          rst  $38
1B02: FF          rst  $38
1B03: FF          rst  $38
1B04: FF          rst  $38
1B05: FF          rst  $38
1B06: FF          rst  $38
1B07: FF          rst  $38
1B08: FF          rst  $38
1B09: FF          rst  $38
1B0A: FF          rst  $38
1B0B: FF          rst  $38
1B0C: FF          rst  $38
1B0D: FF          rst  $38
1B0E: FF          rst  $38
1B0F: FF          rst  $38
1B10: FF          rst  $38
1B11: FF          rst  $38
1B12: FF          rst  $38
1B13: FF          rst  $38
1B14: FF          rst  $38
1B15: FF          rst  $38
1B16: FF          rst  $38
1B17: FF          rst  $38
1B18: FF          rst  $38
1B19: FF          rst  $38
1B1A: FF          rst  $38
1B1B: FF          rst  $38
1B1C: FF          rst  $38
1B1D: FF          rst  $38
1B1E: FF          rst  $38
1B1F: FF          rst  $38
1B20: FF          rst  $38
1B21: FF          rst  $38
1B22: FF          rst  $38
1B23: FF          rst  $38
1B24: FF          rst  $38
1B25: FF          rst  $38
1B26: FF          rst  $38
1B27: FF          rst  $38
1B28: FF          rst  $38
1B29: FF          rst  $38
1B2A: FF          rst  $38
1B2B: FF          rst  $38
1B2C: FF          rst  $38
1B2D: FF          rst  $38
1B2E: FF          rst  $38
1B2F: FF          rst  $38
1B30: FF          rst  $38
1B31: FF          rst  $38
1B32: FF          rst  $38
1B33: FF          rst  $38
1B34: FF          rst  $38
1B35: FF          rst  $38
1B36: FF          rst  $38
1B37: FF          rst  $38
1B38: FF          rst  $38
1B39: FF          rst  $38
1B3A: FF          rst  $38
1B3B: FF          rst  $38
1B3C: FF          rst  $38
1B3D: FF          rst  $38
1B3E: FF          rst  $38
1B3F: FF          rst  $38
1B40: FF          rst  $38
1B41: FF          rst  $38
1B42: FF          rst  $38
1B43: FF          rst  $38
1B44: FF          rst  $38
1B45: FF          rst  $38
1B46: FF          rst  $38
1B47: FF          rst  $38
1B48: FF          rst  $38
1B49: FF          rst  $38
1B4A: FF          rst  $38
1B4B: FF          rst  $38
1B4C: FF          rst  $38
1B4D: FF          rst  $38
1B4E: FF          rst  $38
1B4F: FF          rst  $38
1B50: FF          rst  $38
1B51: FF          rst  $38
1B52: FF          rst  $38
1B53: FF          rst  $38
1B54: FF          rst  $38
1B55: FF          rst  $38
1B56: FF          rst  $38
1B57: FF          rst  $38
1B58: FF          rst  $38
1B59: FF          rst  $38
1B5A: FF          rst  $38
1B5B: FF          rst  $38
1B5C: FF          rst  $38
1B5D: FF          rst  $38
1B5E: FF          rst  $38
1B5F: FF          rst  $38
1B60: FF          rst  $38
1B61: FF          rst  $38
1B62: FF          rst  $38
1B63: FF          rst  $38
1B64: FF          rst  $38
1B65: FF          rst  $38
1B66: FF          rst  $38
1B67: FF          rst  $38
1B68: FF          rst  $38
1B69: FF          rst  $38
1B6A: FF          rst  $38
1B6B: FF          rst  $38
1B6C: FF          rst  $38
1B6D: FF          rst  $38
1B6E: FF          rst  $38
1B6F: FF          rst  $38
1B70: FF          rst  $38
1B71: FF          rst  $38
1B72: FF          rst  $38
1B73: FF          rst  $38
1B74: FF          rst  $38
1B75: FF          rst  $38
1B76: FF          rst  $38
1B77: FF          rst  $38
1B78: FF          rst  $38
1B79: FF          rst  $38
1B7A: FF          rst  $38
1B7B: FF          rst  $38
1B7C: FF          rst  $38
1B7D: FF          rst  $38
1B7E: FF          rst  $38
1B7F: FF          rst  $38
1B80: FF          rst  $38
1B81: FF          rst  $38
1B82: FF          rst  $38
1B83: FF          rst  $38
1B84: FF          rst  $38
1B85: FF          rst  $38
1B86: FF          rst  $38
1B87: FF          rst  $38
1B88: FF          rst  $38
1B89: FF          rst  $38
1B8A: FF          rst  $38
1B8B: FF          rst  $38
1B8C: FF          rst  $38
1B8D: FF          rst  $38
1B8E: FF          rst  $38
1B8F: FF          rst  $38
1B90: FF          rst  $38
1B91: FF          rst  $38
1B92: FF          rst  $38
1B93: FF          rst  $38
1B94: FF          rst  $38
1B95: FF          rst  $38
1B96: FF          rst  $38
1B97: FF          rst  $38
1B98: FF          rst  $38
1B99: FF          rst  $38
1B9A: FF          rst  $38
1B9B: FF          rst  $38
1B9C: FF          rst  $38
1B9D: FF          rst  $38
1B9E: FF          rst  $38
1B9F: FF          rst  $38
1BA0: FF          rst  $38
1BA1: FF          rst  $38
1BA2: FF          rst  $38
1BA3: FF          rst  $38
1BA4: FF          rst  $38
1BA5: FF          rst  $38
1BA6: FF          rst  $38
1BA7: FF          rst  $38
1BA8: FF          rst  $38
1BA9: FF          rst  $38
1BAA: FF          rst  $38
1BAB: FF          rst  $38
1BAC: FF          rst  $38
1BAD: FF          rst  $38
1BAE: FF          rst  $38
1BAF: FF          rst  $38
1BB0: FF          rst  $38
1BB1: FF          rst  $38
1BB2: FF          rst  $38
1BB3: FF          rst  $38
1BB4: FF          rst  $38
1BB5: FF          rst  $38
1BB6: FF          rst  $38
1BB7: FF          rst  $38
1BB8: FF          rst  $38
1BB9: FF          rst  $38
1BBA: FF          rst  $38
1BBB: FF          rst  $38
1BBC: FF          rst  $38
1BBD: FF          rst  $38
1BBE: FF          rst  $38
1BBF: FF          rst  $38
1BC0: FF          rst  $38
1BC1: FF          rst  $38
1BC2: FF          rst  $38
1BC3: FF          rst  $38
1BC4: FF          rst  $38
1BC5: FF          rst  $38
1BC6: FF          rst  $38
1BC7: FF          rst  $38
1BC8: FF          rst  $38
1BC9: FF          rst  $38
1BCA: FF          rst  $38
1BCB: FF          rst  $38
1BCC: FF          rst  $38
1BCD: FF          rst  $38
1BCE: FF          rst  $38
1BCF: FF          rst  $38
1BD0: FF          rst  $38
1BD1: FF          rst  $38
1BD2: FF          rst  $38
1BD3: FF          rst  $38
1BD4: FF          rst  $38
1BD5: FF          rst  $38
1BD6: FF          rst  $38
1BD7: FF          rst  $38
1BD8: FF          rst  $38
1BD9: FF          rst  $38
1BDA: FF          rst  $38
1BDB: FF          rst  $38
1BDC: FF          rst  $38
1BDD: FF          rst  $38
1BDE: FF          rst  $38
1BDF: FF          rst  $38
1BE0: FF          rst  $38
1BE1: FF          rst  $38
1BE2: FF          rst  $38
1BE3: FF          rst  $38
1BE4: FF          rst  $38
1BE5: FF          rst  $38
1BE6: FF          rst  $38
1BE7: FF          rst  $38
1BE8: FF          rst  $38
1BE9: FF          rst  $38
1BEA: FF          rst  $38
1BEB: FF          rst  $38
1BEC: FF          rst  $38
1BED: FF          rst  $38
1BEE: FF          rst  $38
1BEF: FF          rst  $38
1BF0: FF          rst  $38
1BF1: FF          rst  $38
1BF2: FF          rst  $38
1BF3: FF          rst  $38
1BF4: FF          rst  $38
1BF5: FF          rst  $38
1BF6: FF          rst  $38
1BF7: FF          rst  $38
1BF8: FF          rst  $38
1BF9: FF          rst  $38
1BFA: FF          rst  $38
1BFB: FF          rst  $38
1BFC: FF          rst  $38
1BFD: FF          rst  $38
1BFE: FF          rst  $38
1BFF: FF          rst  $38
1C00: FF          rst  $38
1C01: FF          rst  $38
1C02: FF          rst  $38
1C03: FF          rst  $38
1C04: FF          rst  $38
1C05: FF          rst  $38
1C06: FF          rst  $38
1C07: FF          rst  $38
1C08: FF          rst  $38
1C09: FF          rst  $38
1C0A: FF          rst  $38
1C0B: FF          rst  $38
1C0C: FF          rst  $38
1C0D: FF          rst  $38
1C0E: FF          rst  $38
1C0F: FF          rst  $38
1C10: FF          rst  $38
1C11: FF          rst  $38
1C12: FF          rst  $38
1C13: FF          rst  $38
1C14: FF          rst  $38
1C15: FF          rst  $38
1C16: FF          rst  $38
1C17: FF          rst  $38
1C18: FF          rst  $38
1C19: FF          rst  $38
1C1A: FF          rst  $38
1C1B: FF          rst  $38
1C1C: FF          rst  $38
1C1D: FF          rst  $38
1C1E: FF          rst  $38
1C1F: FF          rst  $38
1C20: FF          rst  $38
1C21: FF          rst  $38
1C22: FF          rst  $38
1C23: FF          rst  $38
1C24: FF          rst  $38
1C25: FF          rst  $38
1C26: FF          rst  $38
1C27: FF          rst  $38
1C28: FF          rst  $38
1C29: FF          rst  $38
1C2A: FF          rst  $38
1C2B: FF          rst  $38
1C2C: FF          rst  $38
1C2D: FF          rst  $38
1C2E: FF          rst  $38
1C2F: FF          rst  $38
1C30: FF          rst  $38
1C31: FF          rst  $38
1C32: FF          rst  $38
1C33: FF          rst  $38
1C34: FF          rst  $38
1C35: FF          rst  $38
1C36: FF          rst  $38
1C37: FF          rst  $38
1C38: FF          rst  $38
1C39: FF          rst  $38
1C3A: FF          rst  $38
1C3B: FF          rst  $38
1C3C: FF          rst  $38
1C3D: FF          rst  $38
1C3E: FF          rst  $38
1C3F: FF          rst  $38
1C40: FF          rst  $38
1C41: FF          rst  $38
1C42: FF          rst  $38
1C43: FF          rst  $38
1C44: FF          rst  $38
1C45: FF          rst  $38
1C46: FF          rst  $38
1C47: FF          rst  $38
1C48: FF          rst  $38
1C49: FF          rst  $38
1C4A: FF          rst  $38
1C4B: FF          rst  $38
1C4C: FF          rst  $38
1C4D: FF          rst  $38
1C4E: FF          rst  $38
1C4F: FF          rst  $38
1C50: FF          rst  $38
1C51: FF          rst  $38
1C52: FF          rst  $38
1C53: FF          rst  $38
1C54: FF          rst  $38
1C55: FF          rst  $38
1C56: FF          rst  $38
1C57: FF          rst  $38
1C58: FF          rst  $38
1C59: FF          rst  $38
1C5A: FF          rst  $38
1C5B: FF          rst  $38
1C5C: FF          rst  $38
1C5D: FF          rst  $38
1C5E: FF          rst  $38
1C5F: FF          rst  $38
1C60: FF          rst  $38
1C61: FF          rst  $38
1C62: FF          rst  $38
1C63: FF          rst  $38
1C64: FF          rst  $38
1C65: FF          rst  $38
1C66: FF          rst  $38
1C67: FF          rst  $38
1C68: FF          rst  $38
1C69: FF          rst  $38
1C6A: FF          rst  $38
1C6B: FF          rst  $38
1C6C: FF          rst  $38
1C6D: FF          rst  $38
1C6E: FF          rst  $38
1C6F: FF          rst  $38
1C70: FF          rst  $38
1C71: FF          rst  $38
1C72: FF          rst  $38
1C73: FF          rst  $38
1C74: FF          rst  $38
1C75: FF          rst  $38
1C76: FF          rst  $38
1C77: FF          rst  $38
1C78: FF          rst  $38
1C79: FF          rst  $38
1C7A: FF          rst  $38
1C7B: FF          rst  $38
1C7C: FF          rst  $38
1C7D: FF          rst  $38
1C7E: FF          rst  $38
1C7F: FF          rst  $38
1C80: FF          rst  $38
1C81: FF          rst  $38
1C82: FF          rst  $38
1C83: FF          rst  $38
1C84: FF          rst  $38
1C85: FF          rst  $38
1C86: FF          rst  $38
1C87: FF          rst  $38
1C88: FF          rst  $38
1C89: FF          rst  $38
1C8A: FF          rst  $38
1C8B: FF          rst  $38
1C8C: FF          rst  $38
1C8D: FF          rst  $38
1C8E: FF          rst  $38
1C8F: FF          rst  $38
1C90: FF          rst  $38
1C91: FF          rst  $38
1C92: FF          rst  $38
1C93: FF          rst  $38
1C94: FF          rst  $38
1C95: FF          rst  $38
1C96: FF          rst  $38
1C97: FF          rst  $38
1C98: FF          rst  $38
1C99: FF          rst  $38
1C9A: FF          rst  $38
1C9B: FF          rst  $38
1C9C: FF          rst  $38
1C9D: FF          rst  $38
1C9E: FF          rst  $38
1C9F: FF          rst  $38
1CA0: FF          rst  $38
1CA1: FF          rst  $38
1CA2: FF          rst  $38
1CA3: FF          rst  $38
1CA4: FF          rst  $38
1CA5: FF          rst  $38
1CA6: FF          rst  $38
1CA7: FF          rst  $38
1CA8: FF          rst  $38
1CA9: FF          rst  $38
1CAA: FF          rst  $38
1CAB: FF          rst  $38
1CAC: FF          rst  $38
1CAD: FF          rst  $38
1CAE: FF          rst  $38
1CAF: FF          rst  $38
1CB0: FF          rst  $38
1CB1: FF          rst  $38
1CB2: FF          rst  $38
1CB3: FF          rst  $38
1CB4: FF          rst  $38
1CB5: FF          rst  $38
1CB6: FF          rst  $38
1CB7: FF          rst  $38
1CB8: FF          rst  $38
1CB9: FF          rst  $38
1CBA: FF          rst  $38
1CBB: FF          rst  $38
1CBC: FF          rst  $38
1CBD: FF          rst  $38
1CBE: FF          rst  $38
1CBF: FF          rst  $38
1CC0: FF          rst  $38
1CC1: FF          rst  $38
1CC2: FF          rst  $38
1CC3: FF          rst  $38
1CC4: FF          rst  $38
1CC5: FF          rst  $38
1CC6: FF          rst  $38
1CC7: FF          rst  $38
1CC8: FF          rst  $38
1CC9: FF          rst  $38
1CCA: FF          rst  $38
1CCB: FF          rst  $38
1CCC: FF          rst  $38
1CCD: FF          rst  $38
1CCE: FF          rst  $38
1CCF: FF          rst  $38
1CD0: FF          rst  $38
1CD1: FF          rst  $38
1CD2: FF          rst  $38
1CD3: FF          rst  $38
1CD4: FF          rst  $38
1CD5: FF          rst  $38
1CD6: FF          rst  $38
1CD7: FF          rst  $38
1CD8: FF          rst  $38
1CD9: FF          rst  $38
1CDA: FF          rst  $38
1CDB: FF          rst  $38
1CDC: FF          rst  $38
1CDD: FF          rst  $38
1CDE: FF          rst  $38
1CDF: FF          rst  $38
1CE0: FF          rst  $38
1CE1: FF          rst  $38
1CE2: FF          rst  $38
1CE3: FF          rst  $38
1CE4: FF          rst  $38
1CE5: FF          rst  $38
1CE6: FF          rst  $38
1CE7: FF          rst  $38
1CE8: FF          rst  $38
1CE9: FF          rst  $38
1CEA: FF          rst  $38
1CEB: FF          rst  $38
1CEC: FF          rst  $38
1CED: FF          rst  $38
1CEE: FF          rst  $38
1CEF: FF          rst  $38
1CF0: FF          rst  $38
1CF1: FF          rst  $38
1CF2: FF          rst  $38
1CF3: FF          rst  $38
1CF4: FF          rst  $38
1CF5: FF          rst  $38
1CF6: FF          rst  $38
1CF7: FF          rst  $38
1CF8: FF          rst  $38
1CF9: FF          rst  $38
1CFA: FF          rst  $38
1CFB: FF          rst  $38
1CFC: FF          rst  $38
1CFD: FF          rst  $38
1CFE: FF          rst  $38
1CFF: FF          rst  $38
1D00: FF          rst  $38
1D01: FF          rst  $38
1D02: FF          rst  $38
1D03: FF          rst  $38
1D04: FF          rst  $38
1D05: FF          rst  $38
1D06: FF          rst  $38
1D07: FF          rst  $38
1D08: FF          rst  $38
1D09: FF          rst  $38
1D0A: FF          rst  $38
1D0B: FF          rst  $38
1D0C: FF          rst  $38
1D0D: FF          rst  $38
1D0E: FF          rst  $38
1D0F: FF          rst  $38
1D10: FF          rst  $38
1D11: FF          rst  $38
1D12: FF          rst  $38
1D13: FF          rst  $38
1D14: FF          rst  $38
1D15: FF          rst  $38
1D16: FF          rst  $38
1D17: FF          rst  $38
1D18: FF          rst  $38
1D19: FF          rst  $38
1D1A: FF          rst  $38
1D1B: FF          rst  $38
1D1C: FF          rst  $38
1D1D: FF          rst  $38
1D1E: FF          rst  $38
1D1F: FF          rst  $38
1D20: FF          rst  $38
1D21: FF          rst  $38
1D22: FF          rst  $38
1D23: FF          rst  $38
1D24: FF          rst  $38
1D25: FF          rst  $38
1D26: FF          rst  $38
1D27: FF          rst  $38
1D28: FF          rst  $38
1D29: FF          rst  $38
1D2A: FF          rst  $38
1D2B: FF          rst  $38
1D2C: FF          rst  $38
1D2D: FF          rst  $38
1D2E: FF          rst  $38
1D2F: FF          rst  $38
1D30: FF          rst  $38
1D31: FF          rst  $38
1D32: FF          rst  $38
1D33: FF          rst  $38
1D34: FF          rst  $38
1D35: FF          rst  $38
1D36: FF          rst  $38
1D37: FF          rst  $38
1D38: FF          rst  $38
1D39: FF          rst  $38
1D3A: FF          rst  $38
1D3B: FF          rst  $38
1D3C: FF          rst  $38
1D3D: FF          rst  $38
1D3E: FF          rst  $38
1D3F: FF          rst  $38
1D40: FF          rst  $38
1D41: FF          rst  $38
1D42: FF          rst  $38
1D43: FF          rst  $38
1D44: FF          rst  $38
1D45: FF          rst  $38
1D46: FF          rst  $38
1D47: FF          rst  $38
1D48: FF          rst  $38
1D49: FF          rst  $38
1D4A: FF          rst  $38
1D4B: FF          rst  $38
1D4C: FF          rst  $38
1D4D: FF          rst  $38
1D4E: FF          rst  $38
1D4F: FF          rst  $38
1D50: FF          rst  $38
1D51: FF          rst  $38
1D52: FF          rst  $38
1D53: FF          rst  $38
1D54: FF          rst  $38
1D55: FF          rst  $38
1D56: FF          rst  $38
1D57: FF          rst  $38
1D58: FF          rst  $38
1D59: FF          rst  $38
1D5A: FF          rst  $38
1D5B: FF          rst  $38
1D5C: FF          rst  $38
1D5D: FF          rst  $38
1D5E: FF          rst  $38
1D5F: FF          rst  $38
1D60: FF          rst  $38
1D61: FF          rst  $38
1D62: FF          rst  $38
1D63: FF          rst  $38
1D64: FF          rst  $38
1D65: FF          rst  $38
1D66: FF          rst  $38
1D67: FF          rst  $38
1D68: FF          rst  $38
1D69: FF          rst  $38
1D6A: FF          rst  $38
1D6B: FF          rst  $38
1D6C: FF          rst  $38
1D6D: FF          rst  $38
1D6E: FF          rst  $38
1D6F: FF          rst  $38
1D70: FF          rst  $38
1D71: FF          rst  $38
1D72: FF          rst  $38
1D73: FF          rst  $38
1D74: FF          rst  $38
1D75: FF          rst  $38
1D76: FF          rst  $38
1D77: FF          rst  $38
1D78: FF          rst  $38
1D79: FF          rst  $38
1D7A: FF          rst  $38
1D7B: FF          rst  $38
1D7C: FF          rst  $38
1D7D: FF          rst  $38
1D7E: FF          rst  $38
1D7F: FF          rst  $38
1D80: FF          rst  $38
1D81: FF          rst  $38
1D82: FF          rst  $38
1D83: FF          rst  $38
1D84: FF          rst  $38
1D85: FF          rst  $38
1D86: FF          rst  $38
1D87: FF          rst  $38
1D88: FF          rst  $38
1D89: FF          rst  $38
1D8A: FF          rst  $38
1D8B: FF          rst  $38
1D8C: FF          rst  $38
1D8D: FF          rst  $38
1D8E: FF          rst  $38
1D8F: FF          rst  $38
1D90: FF          rst  $38
1D91: FF          rst  $38
1D92: FF          rst  $38
1D93: FF          rst  $38
1D94: FF          rst  $38
1D95: FF          rst  $38
1D96: FF          rst  $38
1D97: FF          rst  $38
1D98: FF          rst  $38
1D99: FF          rst  $38
1D9A: FF          rst  $38
1D9B: FF          rst  $38
1D9C: FF          rst  $38
1D9D: FF          rst  $38
1D9E: FF          rst  $38
1D9F: FF          rst  $38
1DA0: FF          rst  $38
1DA1: FF          rst  $38
1DA2: FF          rst  $38
1DA3: FF          rst  $38
1DA4: FF          rst  $38
1DA5: FF          rst  $38
1DA6: FF          rst  $38
1DA7: FF          rst  $38
1DA8: FF          rst  $38
1DA9: FF          rst  $38
1DAA: FF          rst  $38
1DAB: FF          rst  $38
1DAC: FF          rst  $38
1DAD: FF          rst  $38
1DAE: FF          rst  $38
1DAF: FF          rst  $38
1DB0: FF          rst  $38
1DB1: FF          rst  $38
1DB2: FF          rst  $38
1DB3: FF          rst  $38
1DB4: FF          rst  $38
1DB5: FF          rst  $38
1DB6: FF          rst  $38
1DB7: FF          rst  $38
1DB8: FF          rst  $38
1DB9: FF          rst  $38
1DBA: FF          rst  $38
1DBB: FF          rst  $38
1DBC: FF          rst  $38
1DBD: FF          rst  $38
1DBE: FF          rst  $38
1DBF: FF          rst  $38
1DC0: FF          rst  $38
1DC1: FF          rst  $38
1DC2: FF          rst  $38
1DC3: FF          rst  $38
1DC4: FF          rst  $38
1DC5: FF          rst  $38
1DC6: FF          rst  $38
1DC7: FF          rst  $38
1DC8: FF          rst  $38
1DC9: FF          rst  $38
1DCA: FF          rst  $38
1DCB: FF          rst  $38
1DCC: FF          rst  $38
1DCD: FF          rst  $38
1DCE: FF          rst  $38
1DCF: FF          rst  $38
1DD0: FF          rst  $38
1DD1: FF          rst  $38
1DD2: FF          rst  $38
1DD3: FF          rst  $38
1DD4: FF          rst  $38
1DD5: FF          rst  $38
1DD6: FF          rst  $38
1DD7: FF          rst  $38
1DD8: FF          rst  $38
1DD9: FF          rst  $38
1DDA: FF          rst  $38
1DDB: FF          rst  $38
1DDC: FF          rst  $38
1DDD: FF          rst  $38
1DDE: FF          rst  $38
1DDF: FF          rst  $38
1DE0: FF          rst  $38
1DE1: FF          rst  $38
1DE2: FF          rst  $38
1DE3: FF          rst  $38
1DE4: FF          rst  $38
1DE5: FF          rst  $38
1DE6: FF          rst  $38
1DE7: FF          rst  $38
1DE8: FF          rst  $38
1DE9: FF          rst  $38
1DEA: FF          rst  $38
1DEB: FF          rst  $38
1DEC: FF          rst  $38
1DED: FF          rst  $38
1DEE: FF          rst  $38
1DEF: FF          rst  $38
1DF0: FF          rst  $38
1DF1: FF          rst  $38
1DF2: FF          rst  $38
1DF3: FF          rst  $38
1DF4: FF          rst  $38
1DF5: FF          rst  $38
1DF6: FF          rst  $38
1DF7: FF          rst  $38
1DF8: FF          rst  $38
1DF9: FF          rst  $38
1DFA: FF          rst  $38
1DFB: FF          rst  $38
1DFC: FF          rst  $38
1DFD: FF          rst  $38
1DFE: FF          rst  $38
1DFF: FF          rst  $38
1E00: FF          rst  $38
1E01: FF          rst  $38
1E02: FF          rst  $38
1E03: FF          rst  $38
1E04: FF          rst  $38
1E05: FF          rst  $38
1E06: FF          rst  $38
1E07: FF          rst  $38
1E08: FF          rst  $38
1E09: FF          rst  $38
1E0A: FF          rst  $38
1E0B: FF          rst  $38
1E0C: FF          rst  $38
1E0D: FF          rst  $38
1E0E: FF          rst  $38
1E0F: FF          rst  $38
1E10: FF          rst  $38
1E11: FF          rst  $38
1E12: FF          rst  $38
1E13: FF          rst  $38
1E14: FF          rst  $38
1E15: FF          rst  $38
1E16: FF          rst  $38
1E17: FF          rst  $38
1E18: FF          rst  $38
1E19: FF          rst  $38
1E1A: FF          rst  $38
1E1B: FF          rst  $38
1E1C: FF          rst  $38
1E1D: FF          rst  $38
1E1E: FF          rst  $38
1E1F: FF          rst  $38
1E20: FF          rst  $38
1E21: FF          rst  $38
1E22: FF          rst  $38
1E23: FF          rst  $38
1E24: FF          rst  $38
1E25: FF          rst  $38
1E26: FF          rst  $38
1E27: FF          rst  $38
1E28: FF          rst  $38
1E29: FF          rst  $38
1E2A: FF          rst  $38
1E2B: FF          rst  $38
1E2C: FF          rst  $38
1E2D: FF          rst  $38
1E2E: FF          rst  $38
1E2F: FF          rst  $38
1E30: FF          rst  $38
1E31: FF          rst  $38
1E32: FF          rst  $38
1E33: FF          rst  $38
1E34: FF          rst  $38
1E35: FF          rst  $38
1E36: FF          rst  $38
1E37: FF          rst  $38
1E38: FF          rst  $38
1E39: FF          rst  $38
1E3A: FF          rst  $38
1E3B: FF          rst  $38
1E3C: FF          rst  $38
1E3D: FF          rst  $38
1E3E: FF          rst  $38
1E3F: FF          rst  $38
1E40: FF          rst  $38
1E41: FF          rst  $38
1E42: FF          rst  $38
1E43: FF          rst  $38
1E44: FF          rst  $38
1E45: FF          rst  $38
1E46: FF          rst  $38
1E47: FF          rst  $38
1E48: FF          rst  $38
1E49: FF          rst  $38
1E4A: FF          rst  $38
1E4B: FF          rst  $38
1E4C: FF          rst  $38
1E4D: FF          rst  $38
1E4E: FF          rst  $38
1E4F: FF          rst  $38
1E50: FF          rst  $38
1E51: FF          rst  $38
1E52: FF          rst  $38
1E53: FF          rst  $38
1E54: FF          rst  $38
1E55: FF          rst  $38
1E56: FF          rst  $38
1E57: FF          rst  $38
1E58: FF          rst  $38
1E59: FF          rst  $38
1E5A: FF          rst  $38
1E5B: FF          rst  $38
1E5C: FF          rst  $38
1E5D: FF          rst  $38
1E5E: FF          rst  $38
1E5F: FF          rst  $38
1E60: FF          rst  $38
1E61: FF          rst  $38
1E62: FF          rst  $38
1E63: FF          rst  $38
1E64: FF          rst  $38
1E65: FF          rst  $38
1E66: FF          rst  $38
1E67: FF          rst  $38
1E68: FF          rst  $38
1E69: FF          rst  $38
1E6A: FF          rst  $38
1E6B: FF          rst  $38
1E6C: FF          rst  $38
1E6D: FF          rst  $38
1E6E: FF          rst  $38
1E6F: FF          rst  $38
1E70: FF          rst  $38
1E71: FF          rst  $38
1E72: FF          rst  $38
1E73: FF          rst  $38
1E74: FF          rst  $38
1E75: FF          rst  $38
1E76: FF          rst  $38
1E77: FF          rst  $38
1E78: FF          rst  $38
1E79: FF          rst  $38
1E7A: FF          rst  $38
1E7B: FF          rst  $38
1E7C: FF          rst  $38
1E7D: FF          rst  $38
1E7E: FF          rst  $38
1E7F: FF          rst  $38
1E80: FF          rst  $38
1E81: FF          rst  $38
1E82: FF          rst  $38
1E83: FF          rst  $38
1E84: FF          rst  $38
1E85: FF          rst  $38
1E86: FF          rst  $38
1E87: FF          rst  $38
1E88: FF          rst  $38
1E89: FF          rst  $38
1E8A: FF          rst  $38
1E8B: FF          rst  $38
1E8C: FF          rst  $38
1E8D: FF          rst  $38
1E8E: FF          rst  $38
1E8F: FF          rst  $38
1E90: FF          rst  $38
1E91: FF          rst  $38
1E92: FF          rst  $38
1E93: FF          rst  $38
1E94: FF          rst  $38
1E95: FF          rst  $38
1E96: FF          rst  $38
1E97: FF          rst  $38
1E98: FF          rst  $38
1E99: FF          rst  $38
1E9A: FF          rst  $38
1E9B: FF          rst  $38
1E9C: FF          rst  $38
1E9D: FF          rst  $38
1E9E: FF          rst  $38
1E9F: FF          rst  $38
1EA0: FF          rst  $38
1EA1: FF          rst  $38
1EA2: FF          rst  $38
1EA3: FF          rst  $38
1EA4: FF          rst  $38
1EA5: FF          rst  $38
1EA6: FF          rst  $38
1EA7: FF          rst  $38
1EA8: FF          rst  $38
1EA9: FF          rst  $38
1EAA: FF          rst  $38
1EAB: FF          rst  $38
1EAC: FF          rst  $38
1EAD: FF          rst  $38
1EAE: FF          rst  $38
1EAF: FF          rst  $38
1EB0: FF          rst  $38
1EB1: FF          rst  $38
1EB2: FF          rst  $38
1EB3: FF          rst  $38
1EB4: FF          rst  $38
1EB5: FF          rst  $38
1EB6: FF          rst  $38
1EB7: FF          rst  $38
1EB8: FF          rst  $38
1EB9: FF          rst  $38
1EBA: FF          rst  $38
1EBB: FF          rst  $38
1EBC: FF          rst  $38
1EBD: FF          rst  $38
1EBE: FF          rst  $38
1EBF: FF          rst  $38
1EC0: FF          rst  $38
1EC1: FF          rst  $38
1EC2: FF          rst  $38
1EC3: FF          rst  $38
1EC4: FF          rst  $38
1EC5: FF          rst  $38
1EC6: FF          rst  $38
1EC7: FF          rst  $38
1EC8: FF          rst  $38
1EC9: FF          rst  $38
1ECA: FF          rst  $38
1ECB: FF          rst  $38
1ECC: FF          rst  $38
1ECD: FF          rst  $38
1ECE: FF          rst  $38
1ECF: FF          rst  $38
1ED0: FF          rst  $38
1ED1: FF          rst  $38
1ED2: FF          rst  $38
1ED3: FF          rst  $38
1ED4: FF          rst  $38
1ED5: FF          rst  $38
1ED6: FF          rst  $38
1ED7: FF          rst  $38
1ED8: FF          rst  $38
1ED9: FF          rst  $38
1EDA: FF          rst  $38
1EDB: FF          rst  $38
1EDC: FF          rst  $38
1EDD: FF          rst  $38
1EDE: FF          rst  $38
1EDF: FF          rst  $38
1EE0: FF          rst  $38
1EE1: FF          rst  $38
1EE2: FF          rst  $38
1EE3: FF          rst  $38
1EE4: FF          rst  $38
1EE5: FF          rst  $38
1EE6: FF          rst  $38
1EE7: FF          rst  $38
1EE8: FF          rst  $38
1EE9: FF          rst  $38
1EEA: FF          rst  $38
1EEB: FF          rst  $38
1EEC: FF          rst  $38
1EED: FF          rst  $38
1EEE: FF          rst  $38
1EEF: FF          rst  $38
1EF0: FF          rst  $38
1EF1: FF          rst  $38
1EF2: FF          rst  $38
1EF3: FF          rst  $38
1EF4: FF          rst  $38
1EF5: FF          rst  $38
1EF6: FF          rst  $38
1EF7: FF          rst  $38
1EF8: FF          rst  $38
1EF9: FF          rst  $38
1EFA: FF          rst  $38
1EFB: FF          rst  $38
1EFC: FF          rst  $38
1EFD: FF          rst  $38
1EFE: FF          rst  $38
1EFF: FF          rst  $38
1F00: FF          rst  $38
1F01: FF          rst  $38
1F02: FF          rst  $38
1F03: FF          rst  $38
1F04: FF          rst  $38
1F05: FF          rst  $38
1F06: FF          rst  $38
1F07: FF          rst  $38
1F08: FF          rst  $38
1F09: FF          rst  $38
1F0A: FF          rst  $38
1F0B: FF          rst  $38
1F0C: FF          rst  $38
1F0D: FF          rst  $38
1F0E: FF          rst  $38
1F0F: FF          rst  $38
1F10: FF          rst  $38
1F11: FF          rst  $38
1F12: FF          rst  $38
1F13: FF          rst  $38
1F14: FF          rst  $38
1F15: FF          rst  $38
1F16: FF          rst  $38
1F17: FF          rst  $38
1F18: FF          rst  $38
1F19: FF          rst  $38
1F1A: FF          rst  $38
1F1B: FF          rst  $38
1F1C: FF          rst  $38
1F1D: FF          rst  $38
1F1E: FF          rst  $38
1F1F: FF          rst  $38
1F20: FF          rst  $38
1F21: FF          rst  $38
1F22: FF          rst  $38
1F23: FF          rst  $38
1F24: FF          rst  $38
1F25: FF          rst  $38
1F26: FF          rst  $38
1F27: FF          rst  $38
1F28: FF          rst  $38
1F29: FF          rst  $38
1F2A: FF          rst  $38
1F2B: FF          rst  $38
1F2C: FF          rst  $38
1F2D: FF          rst  $38
1F2E: FF          rst  $38
1F2F: FF          rst  $38
1F30: FF          rst  $38
1F31: FF          rst  $38
1F32: FF          rst  $38
1F33: FF          rst  $38
1F34: FF          rst  $38
1F35: FF          rst  $38
1F36: FF          rst  $38
1F37: FF          rst  $38
1F38: FF          rst  $38
1F39: FF          rst  $38
1F3A: FF          rst  $38
1F3B: FF          rst  $38
1F3C: FF          rst  $38
1F3D: FF          rst  $38
1F3E: FF          rst  $38
1F3F: FF          rst  $38
1F40: FF          rst  $38
1F41: FF          rst  $38
1F42: FF          rst  $38
1F43: FF          rst  $38
1F44: FF          rst  $38
1F45: FF          rst  $38
1F46: FF          rst  $38
1F47: FF          rst  $38
1F48: FF          rst  $38
1F49: FF          rst  $38
1F4A: FF          rst  $38
1F4B: FF          rst  $38
1F4C: FF          rst  $38
1F4D: FF          rst  $38
1F4E: FF          rst  $38
1F4F: FF          rst  $38
1F50: FF          rst  $38
1F51: FF          rst  $38
1F52: FF          rst  $38
1F53: FF          rst  $38
1F54: FF          rst  $38
1F55: FF          rst  $38
1F56: FF          rst  $38
1F57: FF          rst  $38
1F58: FF          rst  $38
1F59: FF          rst  $38
1F5A: FF          rst  $38
1F5B: FF          rst  $38
1F5C: FF          rst  $38
1F5D: FF          rst  $38
1F5E: FF          rst  $38
1F5F: FF          rst  $38
1F60: FF          rst  $38
1F61: FF          rst  $38
1F62: FF          rst  $38
1F63: FF          rst  $38
1F64: FF          rst  $38
1F65: FF          rst  $38
1F66: FF          rst  $38
1F67: FF          rst  $38
1F68: FF          rst  $38
1F69: FF          rst  $38
1F6A: FF          rst  $38
1F6B: FF          rst  $38
1F6C: FF          rst  $38
1F6D: FF          rst  $38
1F6E: FF          rst  $38
1F6F: FF          rst  $38
1F70: FF          rst  $38
1F71: FF          rst  $38
1F72: FF          rst  $38
1F73: FF          rst  $38
1F74: FF          rst  $38
1F75: FF          rst  $38
1F76: FF          rst  $38
1F77: FF          rst  $38
1F78: FF          rst  $38
1F79: FF          rst  $38
1F7A: FF          rst  $38
1F7B: FF          rst  $38
1F7C: FF          rst  $38
1F7D: FF          rst  $38
1F7E: FF          rst  $38
1F7F: FF          rst  $38
1F80: FF          rst  $38
1F81: FF          rst  $38
1F82: FF          rst  $38
1F83: FF          rst  $38
1F84: FF          rst  $38
1F85: FF          rst  $38
1F86: FF          rst  $38
1F87: FF          rst  $38
1F88: FF          rst  $38
1F89: FF          rst  $38
1F8A: FF          rst  $38
1F8B: FF          rst  $38
1F8C: FF          rst  $38
1F8D: FF          rst  $38
1F8E: FF          rst  $38
1F8F: FF          rst  $38
1F90: FF          rst  $38
1F91: FF          rst  $38
1F92: FF          rst  $38
1F93: FF          rst  $38
1F94: FF          rst  $38
1F95: FF          rst  $38
1F96: FF          rst  $38
1F97: FF          rst  $38
1F98: FF          rst  $38
1F99: FF          rst  $38
1F9A: FF          rst  $38
1F9B: FF          rst  $38
1F9C: FF          rst  $38
1F9D: FF          rst  $38
1F9E: FF          rst  $38
1F9F: FF          rst  $38
1FA0: FF          rst  $38
1FA1: FF          rst  $38
1FA2: FF          rst  $38
1FA3: FF          rst  $38
1FA4: FF          rst  $38
1FA5: FF          rst  $38
1FA6: FF          rst  $38
1FA7: FF          rst  $38
1FA8: FF          rst  $38
1FA9: FF          rst  $38
1FAA: FF          rst  $38
1FAB: FF          rst  $38
1FAC: FF          rst  $38
1FAD: FF          rst  $38
1FAE: FF          rst  $38
1FAF: FF          rst  $38
1FB0: FF          rst  $38
1FB1: FF          rst  $38
1FB2: FF          rst  $38
1FB3: FF          rst  $38
1FB4: FF          rst  $38
1FB5: FF          rst  $38
1FB6: FF          rst  $38
1FB7: FF          rst  $38
1FB8: FF          rst  $38
1FB9: FF          rst  $38
1FBA: FF          rst  $38
1FBB: FF          rst  $38
1FBC: FF          rst  $38
1FBD: FF          rst  $38
1FBE: FF          rst  $38
1FBF: FF          rst  $38
1FC0: FF          rst  $38
1FC1: FF          rst  $38
1FC2: FF          rst  $38
1FC3: FF          rst  $38
1FC4: FF          rst  $38
1FC5: FF          rst  $38
1FC6: FF          rst  $38
1FC7: FF          rst  $38
1FC8: FF          rst  $38
1FC9: FF          rst  $38
1FCA: FF          rst  $38
1FCB: FF          rst  $38
1FCC: FF          rst  $38
1FCD: FF          rst  $38
1FCE: FF          rst  $38
1FCF: FF          rst  $38
1FD0: FF          rst  $38
1FD1: FF          rst  $38
1FD2: FF          rst  $38
1FD3: FF          rst  $38
1FD4: FF          rst  $38
1FD5: FF          rst  $38
1FD6: FF          rst  $38
1FD7: FF          rst  $38
1FD8: FF          rst  $38
1FD9: FF          rst  $38
1FDA: FF          rst  $38
1FDB: FF          rst  $38
1FDC: FF          rst  $38
1FDD: FF          rst  $38
1FDE: FF          rst  $38
1FDF: FF          rst  $38
1FE0: FF          rst  $38
1FE1: FF          rst  $38
1FE2: FF          rst  $38
1FE3: FF          rst  $38
1FE4: FF          rst  $38
1FE5: FF          rst  $38
1FE6: FF          rst  $38
1FE7: FF          rst  $38
1FE8: FF          rst  $38
1FE9: FF          rst  $38
1FEA: FF          rst  $38
1FEB: FF          rst  $38
1FEC: FF          rst  $38
1FED: FF          rst  $38
1FEE: FF          rst  $38
1FEF: FF          rst  $38
1FF0: FF          rst  $38
1FF1: FF          rst  $38
1FF2: FF          rst  $38
1FF3: FF          rst  $38
1FF4: FF          rst  $38
1FF5: FF          rst  $38
1FF6: FF          rst  $38
1FF7: FF          rst  $38
1FF8: FF          rst  $38
1FF9: FF          rst  $38
1FFA: FF          rst  $38
1FFB: FF          rst  $38
1FFC: FF          rst  $38
1FFD: 93          sub  e
1FFE: FF          rst  $38
1FFF: F2 21 40    jp   p,$4021
2002: 83          add  a,e
2003: 36 00       ld   (hl),$00
2005: 11 41 83    ld   de,$8341
2008: 01 1D 00    ld   bc,$001D
200B: ED B0       ldir
200D: 3A 71 40    ld   a,($4071)
2010: A7          and  a
2011: CA D9 21    jp   z,$21D9
2014: 06 F9       ld   b,$F9
2016: 0E F8       ld   c,$F8
2018: 3A 60 41    ld   a,($4160)
201B: E6 03       and  $03
201D: 28 0E       jr   z,$202D
201F: 0E FA       ld   c,$FA
2021: 3D          dec  a
2022: 28 09       jr   z,$202D
2024: 0E F9       ld   c,$F9
2026: 3D          dec  a
2027: 28 04       jr   z,$202D
2029: 06 FB       ld   b,$FB
202B: 0E FB       ld   c,$FB
202D: 21 C2 83    ld   hl,$83C2
2030: 11 20 00    ld   de,$0020
2033: 36 F0       ld   (hl),$F0
2035: 23          inc  hl
2036: 36 FF       ld   (hl),$FF
2038: 19          add  hl,de
2039: 70          ld   (hl),b
203A: 21 C6 83    ld   hl,$83C6
203D: 36 F0       ld   (hl),$F0
203F: 23          inc  hl
2040: 36 FF       ld   (hl),$FF
2042: 19          add  hl,de
2043: 71          ld   (hl),c
2044: 3A 71 40    ld   a,($4071)
2047: CB 57       bit  2,a
2049: 28 12       jr   z,$205D
204B: 21 BE 24    ld   hl,$24BE
204E: 0E 05       ld   c,$05
2050: 3E 88       ld   a,$88
2052: F7          rst  $30
2053: 21 71 40    ld   hl,$4071
2056: CB 96       res  2,(hl)
2058: 2C          inc  l
2059: CB D6       set  2,(hl)
205B: 18 14       jr   $2071
205D: 3A 72 40    ld   a,($4072)
2060: CB 57       bit  2,a
2062: 28 0D       jr   z,$2071
2064: 21 C3 24    ld   hl,$24C3
2067: 0E 01       ld   c,$01
2069: 3E 88       ld   a,$88
206B: F7          rst  $30
206C: 21 72 40    ld   hl,$4072
206F: CB 96       res  2,(hl)
2071: 3A 74 40    ld   a,($4074)
2074: E6 0F       and  $0F
2076: F6 70       or   $70
2078: 32 00 83    ld   ($8300),a
207B: E6 0F       and  $0F
207D: 21 C4 24    ld   hl,$24C4
2080: D7          rst  $10
2081: 7E          ld   a,(hl)
2082: 32 02 83    ld   ($8302),a
2085: 3E 60       ld   a,$60
2087: 32 01 83    ld   ($8301),a
208A: 21 00 83    ld   hl,$8300
208D: 0E 07       ld   c,$07
208F: 3E 88       ld   a,$88
2091: F7          rst  $30
2092: 3A 78 40    ld   a,($4078)
2095: CB 47       bit  0,a
2097: 28 1F       jr   z,$20B8
2099: 3A 70 40    ld   a,($4070)
209C: C6 14       add  a,$14
209E: 30 02       jr   nc,$20A2
20A0: 3E FF       ld   a,$FF
20A2: 4F          ld   c,a
20A3: 1F          rra
20A4: 1F          rra
20A5: E6 3F       and  $3F
20A7: 32 00 A3    ld   ($A300),a
20AA: 79          ld   a,c
20AB: 17          rla
20AC: 17          rla
20AD: 17          rla
20AE: 17          rla
20AF: F6 01       or   $01
20B1: E6 3F       and  $3F
20B3: 32 00 A2    ld   ($A200),a
20B6: 18 07       jr   $20BF
20B8: AF          xor  a
20B9: 32 00 A2    ld   ($A200),a
20BC: 32 00 A3    ld   ($A300),a
20BF: 3A 7F 40    ld   a,($407F)
20C2: A7          and  a
20C3: 28 55       jr   z,$211A
20C5: 3A 7A 40    ld   a,($407A)
20C8: A7          and  a
20C9: 28 4F       jr   z,$211A
20CB: 21 5E 83    ld   hl,$835E
20CE: 34          inc  (hl)
20CF: 3E 04       ld   a,$04
20D1: BE          cp   (hl)
20D2: 38 2F       jr   c,$2103
20D4: 3A 7F 40    ld   a,($407F)
20D7: 47          ld   b,a
20D8: 21 00 04    ld   hl,$0400
20DB: 11 66 00    ld   de,$0066
20DE: 19          add  hl,de
20DF: 10 FD       djnz $20DE
20E1: 44          ld   b,h
20E2: 4D          ld   c,l
20E3: 21 50 83    ld   hl,$8350
20E6: 71          ld   (hl),c
20E7: 2C          inc  l
20E8: 70          ld   (hl),b
20E9: 2C          inc  l
20EA: 36 C0       ld   (hl),$C0
20EC: 2C          inc  l
20ED: 36 CC       ld   (hl),$CC
20EF: 3A 79 40    ld   a,($4079)
20F2: 21 70 40    ld   hl,$4070
20F5: AE          xor  (hl)
20F6: E6 03       and  $03
20F8: F6 C0       or   $C0
20FA: 32 5C 83    ld   ($835C),a
20FD: AF          xor  a
20FE: 32 5F 83    ld   ($835F),a
2101: 18 1B       jr   $211E
2103: 21 5F 83    ld   hl,$835F
2106: 34          inc  (hl)
2107: 3A 7A 40    ld   a,($407A)
210A: FE 30       cp   $30
210C: 38 02       jr   c,$2110
210E: 3E 30       ld   a,$30
2110: 2F          cpl
2111: 0F          rrca
2112: 0F          rrca
2113: 0F          rrca
2114: E6 07       and  $07
2116: 3C          inc  a
2117: BE          cp   (hl)
2118: 30 04       jr   nc,$211E
211A: AF          xor  a
211B: 32 5E 83    ld   ($835E),a
211E: 3A 76 40    ld   a,($4076)
2121: 32 3C 83    ld   ($833C),a
2124: 3A 77 40    ld   a,($4077)
2127: 32 3D 83    ld   ($833D),a
212A: 21 30 83    ld   hl,$8330
212D: 36 00       ld   (hl),$00
212F: 3A 3C 83    ld   a,($833C)
2132: A7          and  a
2133: 28 0F       jr   z,$2144
2135: 06 07       ld   b,$07
2137: 07          rlca
2138: 38 05       jr   c,$213F
213A: 34          inc  (hl)
213B: 10 FA       djnz $2137
213D: 18 05       jr   $2144
213F: CD 21 22    call $2221
2142: 18 18       jr   $215C
2144: 3A 3D 83    ld   a,($833D)
2147: A7          and  a
2148: 28 12       jr   z,$215C
214A: 21 30 83    ld   hl,$8330
214D: 36 08       ld   (hl),$08
214F: 06 08       ld   b,$08
2151: 07          rlca
2152: 38 05       jr   c,$2159
2154: 34          inc  (hl)
2155: 10 FA       djnz $2151
2157: 18 03       jr   $215C
2159: CD 21 22    call $2221
215C: 3A 3C 83    ld   a,($833C)
215F: CB 47       bit  0,a
2161: 28 08       jr   z,$216B
2163: 3E 07       ld   a,$07
2165: 32 30 83    ld   ($8330),a
2168: CD 21 22    call $2221
216B: 3A 78 40    ld   a,($4078)
216E: CB 4F       bit  1,a
2170: CA D9 21    jp   z,$21D9
2173: 3A 7E 40    ld   a,($407E)
2176: 0F          rrca
2177: 0F          rrca
2178: 0F          rrca
2179: 0F          rrca
217A: E6 0F       and  $0F
217C: 67          ld   h,a
217D: 3A 7E 40    ld   a,($407E)
2180: 0F          rrca
2181: 0F          rrca
2182: 0F          rrca
2183: 0F          rrca
2184: E6 F0       and  $F0
2186: 6F          ld   l,a
2187: 01 80 08    ld   bc,$0880
218A: 09          add  hl,bc
218B: 44          ld   b,h
218C: 4D          ld   c,l
218D: 21 40 83    ld   hl,$8340
2190: 71          ld   (hl),c
2191: 2C          inc  l
2192: 70          ld   (hl),b
2193: 21 55 00    ld   hl,$0055
2196: 09          add  hl,bc
2197: 44          ld   b,h
2198: 4D          ld   c,l
2199: 21 44 83    ld   hl,$8344
219C: 71          ld   (hl),c
219D: 2C          inc  l
219E: 70          ld   (hl),b
219F: 3A 7C 40    ld   a,($407C)
21A2: C6 10       add  a,$10
21A4: CB 3F       srl  a
21A6: CB 3F       srl  a
21A8: 21 D4 24    ld   hl,$24D4
21AB: CF          rst  $08
21AC: 5E          ld   e,(hl)
21AD: 23          inc  hl
21AE: 56          ld   d,(hl)
21AF: EB          ex   de,hl
21B0: 3A 7B 40    ld   a,($407B)
21B3: C6 10       add  a,$10
21B5: CB 3F       srl  a
21B7: CF          rst  $08
21B8: 11 42 83    ld   de,$8342
21BB: 7E          ld   a,(hl)
21BC: E6 F0       and  $F0
21BE: 12          ld   (de),a
21BF: 32 46 83    ld   ($8346),a
21C2: 7E          ld   a,(hl)
21C3: 0F          rrca
21C4: 0F          rrca
21C5: 0F          rrca
21C6: 0F          rrca
21C7: E6 F0       and  $F0
21C9: 32 59 83    ld   ($8359),a
21CC: F6 01       or   $01
21CE: 32 58 83    ld   ($8358),a
21D1: 23          inc  hl
21D2: 1C          inc  e
21D3: ED A0       ldi
21D5: 7E          ld   a,(hl)
21D6: 32 47 83    ld   ($8347),a
21D9: 21 40 83    ld   hl,$8340
21DC: 11 C8 83    ld   de,$83C8
21DF: 01 18 00    ld   bc,$0018
21E2: ED B0       ldir
21E4: 21 EB 83    ld   hl,$83EB
21E7: 11 58 83    ld   de,$8358
21EA: 06 06       ld   b,$06
21EC: 1A          ld   a,(de)
21ED: 77          ld   (hl),a
21EE: 1C          inc  e
21EF: 2C          inc  l
21F0: 2C          inc  l
21F1: 2C          inc  l
21F2: 2C          inc  l
21F3: 10 F7       djnz $21EC
21F5: 3A 3D 83    ld   a,($833D)
21F8: CB 77       bit  6,a
21FA: 20 07       jr   nz,$2203
21FC: AF          xor  a
21FD: 32 29 83    ld   ($8329),a
2200: 3A 3D 83    ld   a,($833D)
2203: CB 6F       bit  5,a
2205: 20 07       jr   nz,$220E
2207: AF          xor  a
2208: 32 2A 83    ld   ($832A),a
220B: 3A 3D 83    ld   a,($833D)
220E: CB 47       bit  0,a
2210: 20 04       jr   nz,$2216
2212: AF          xor  a
2213: 32 2F 83    ld   ($832F),a
2216: 3A 3C 83    ld   a,($833C)
2219: CB 7F       bit  7,a
221B: C0          ret  nz
221C: AF          xor  a
221D: 32 20 83    ld   ($8320),a
2220: C9          ret
2221: 21 30 83    ld   hl,$8330
2224: 7E          ld   a,(hl)
2225: 87          add  a,a
2226: 86          add  a,(hl)
2227: 21 CE 25    ld   hl,$25CE
222A: D7          rst  $10
222B: 11 31 83    ld   de,$8331
222E: 01 03 00    ld   bc,$0003
2231: ED B0       ldir
2233: 21 20 83    ld   hl,$8320
2236: 3A 30 83    ld   a,($8330)
2239: D7          rst  $10
223A: 7E          ld   a,(hl)
223B: A7          and  a
223C: 20 19       jr   nz,$2257
223E: 34          inc  (hl)
223F: 21 32 83    ld   hl,$8332
2242: 46          ld   b,(hl)
2243: 48          ld   c,b
2244: 21 60 83    ld   hl,$8360
2247: 3A 31 83    ld   a,($8331)
224A: D7          rst  $10
224B: AF          xor  a
224C: DF          rst  $18
224D: 41          ld   b,c
224E: 21 8E 83    ld   hl,$838E
2251: 3A 31 83    ld   a,($8331)
2254: D7          rst  $10
2255: AF          xor  a
2256: DF          rst  $18
2257: CD A2 22    call $22A2
225A: 21 32 83    ld   hl,$8332
225D: 35          dec  (hl)
225E: 28 0A       jr   z,$226A
2260: 21 31 83    ld   hl,$8331
2263: 34          inc  (hl)
2264: 21 33 83    ld   hl,$8333
2267: 34          inc  (hl)
2268: 18 ED       jr   $2257
226A: 3A 36 83    ld   a,($8336)
226D: A7          and  a
226E: C8          ret  z
226F: AF          xor  a
2270: 32 36 83    ld   ($8336),a
2273: 21 20 83    ld   hl,$8320
2276: 3A 30 83    ld   a,($8330)
2279: D7          rst  $10
227A: 36 00       ld   (hl),$00
227C: 3A 30 83    ld   a,($8330)
227F: FE 07       cp   $07
2281: 28 16       jr   z,$2299
2283: FE 09       cp   $09
2285: C8          ret  z
2286: FE 0A       cp   $0A
2288: C8          ret  z
2289: FE 0F       cp   $0F
228B: C8          ret  z
228C: 3A 3C 83    ld   a,($833C)
228F: E6 01       and  $01
2291: 32 76 40    ld   ($4076),a
2294: AF          xor  a
2295: 32 77 40    ld   ($4077),a
2298: C9          ret
2299: 3A 3C 83    ld   a,($833C)
229C: E6 FE       and  $FE
229E: 32 76 40    ld   ($4076),a
22A1: C9          ret
22A2: 21 8E 83    ld   hl,$838E
22A5: 3A 31 83    ld   a,($8331)
22A8: D7          rst  $10
22A9: 34          inc  (hl)
22AA: 3A 31 83    ld   a,($8331)
22AD: 21 6C 25    ld   hl,$256C
22B0: CF          rst  $08
22B1: 5E          ld   e,(hl)
22B2: 23          inc  hl
22B3: 56          ld   d,(hl)
22B4: 21 60 83    ld   hl,$8360
22B7: 3A 31 83    ld   a,($8331)
22BA: D7          rst  $10
22BB: 7E          ld   a,(hl)
22BC: EB          ex   de,hl
22BD: D7          rst  $10
22BE: 22 34 83    ld   ($8334),hl
22C1: 7E          ld   a,(hl)
22C2: 3C          inc  a
22C3: CA A2 24    jp   z,$24A2
22C6: 21 FE 25    ld   hl,$25FE
22C9: 3A 31 83    ld   a,($8331)
22CC: D7          rst  $10
22CD: 7E          ld   a,(hl)
22CE: A7          and  a
22CF: 28 0D       jr   z,$22DE
22D1: 3D          dec  a
22D2: 28 05       jr   z,$22D9
22D4: 11 F6 26    ld   de,$26F6
22D7: 18 08       jr   $22E1
22D9: 11 DC 26    ld   de,$26DC
22DC: 18 03       jr   $22E1
22DE: 11 C2 26    ld   de,$26C2
22E1: 2A 34 83    ld   hl,($8334)
22E4: 7E          ld   a,(hl)
22E5: 0F          rrca
22E6: 0F          rrca
22E7: 0F          rrca
22E8: 0F          rrca
22E9: E6 0F       and  $0F
22EB: EB          ex   de,hl
22EC: CF          rst  $08
22ED: 4E          ld   c,(hl)
22EE: 23          inc  hl
22EF: 46          ld   b,(hl)
22F0: EB          ex   de,hl
22F1: 7E          ld   a,(hl)
22F2: E6 0F       and  $0F
22F4: 28 07       jr   z,$22FD
22F6: CB 38       srl  b
22F8: CB 19       rr   c
22FA: 3D          dec  a
22FB: 20 F9       jr   nz,$22F6
22FD: 21 40 83    ld   hl,$8340
2300: 3A 33 83    ld   a,($8333)
2303: 87          add  a,a
2304: 87          add  a,a
2305: 85          add  a,l
2306: 6F          ld   l,a
2307: 71          ld   (hl),c
2308: 2C          inc  l
2309: 70          ld   (hl),b
230A: 21 60 26    ld   hl,$2660
230D: 3A 31 83    ld   a,($8331)
2310: 5F          ld   e,a
2311: 16 00       ld   d,$00
2313: 19          add  hl,de
2314: 7E          ld   a,(hl)
2315: A7          and  a
2316: 28 1A       jr   z,$2332
2318: 21 8E 83    ld   hl,$838E
231B: 3A 31 83    ld   a,($8331)
231E: 5F          ld   e,a
231F: 16 00       ld   d,$00
2321: 19          add  hl,de
2322: 7E          ld   a,(hl)
2323: FE 05       cp   $05
2325: 30 0B       jr   nc,$2332
2327: 87          add  a,a
2328: 3D          dec  a
2329: 0F          rrca
232A: 0F          rrca
232B: 0F          rrca
232C: 0F          rrca
232D: 32 37 83    ld   ($8337),a
2330: 18 32       jr   $2364
2332: 21 91 26    ld   hl,$2691
2335: 3A 31 83    ld   a,($8331)
2338: 5F          ld   e,a
2339: 16 00       ld   d,$00
233B: 19          add  hl,de
233C: 7E          ld   a,(hl)
233D: A7          and  a
233E: 28 1F       jr   z,$235F
2340: 21 8E 83    ld   hl,$838E
2343: 3A 31 83    ld   a,($8331)
2346: 5F          ld   e,a
2347: 16 00       ld   d,$00
2349: 19          add  hl,de
234A: 7E          ld   a,(hl)
234B: 2A 34 83    ld   hl,($8334)
234E: 23          inc  hl
234F: 96          sub  (hl)
2350: ED 44       neg
2352: FE 08       cp   $08
2354: 30 09       jr   nc,$235F
2356: 0F          rrca
2357: 0F          rrca
2358: 0F          rrca
2359: 0F          rrca
235A: 32 37 83    ld   ($8337),a
235D: 18 05       jr   $2364
235F: 3E 80       ld   a,$80
2361: 32 37 83    ld   ($8337),a
2364: 21 42 83    ld   hl,$8342
2367: 3A 33 83    ld   a,($8333)
236A: 87          add  a,a
236B: 87          add  a,a
236C: 85          add  a,l
236D: 6F          ld   l,a
236E: E5          push hl
236F: 3A 3C 83    ld   a,($833C)
2372: A7          and  a
2373: 28 04       jr   z,$2379
2375: 0E 00       ld   c,$00
2377: 18 05       jr   $237E
2379: 3A 3D 83    ld   a,($833D)
237C: 0E 08       ld   c,$08
237E: 07          rlca
237F: 38 03       jr   c,$2384
2381: 0C          inc  c
2382: 18 FA       jr   $237E
2384: 21 C3 23    ld   hl,$23C3
2387: 79          ld   a,c
2388: CF          rst  $08
2389: 5E          ld   e,(hl)
238A: 23          inc  hl
238B: 56          ld   d,(hl)
238C: EB          ex   de,hl
238D: E9          jp   (hl)
238E: 21 58 83    ld   hl,$8358
2391: 3A 33 83    ld   a,($8333)
2394: 85          add  a,l
2395: 6F          ld   l,a
2396: EB          ex   de,hl
2397: 21 2F 26    ld   hl,$262F
239A: 3A 31 83    ld   a,($8331)
239D: D7          rst  $10
239E: EB          ex   de,hl
239F: 1A          ld   a,(de)
23A0: B6          or   (hl)
23A1: 77          ld   (hl),a
23A2: 21 8E 83    ld   hl,$838E
23A5: 3A 31 83    ld   a,($8331)
23A8: D7          rst  $10
23A9: 7E          ld   a,(hl)
23AA: 2A 34 83    ld   hl,($8334)
23AD: 23          inc  hl
23AE: BE          cp   (hl)
23AF: C0          ret  nz
23B0: 21 60 83    ld   hl,$8360
23B3: 3A 31 83    ld   a,($8331)
23B6: D7          rst  $10
23B7: 34          inc  (hl)
23B8: 34          inc  (hl)
23B9: 21 8E 83    ld   hl,$838E
23BC: 3A 31 83    ld   a,($8331)
23BF: D7          rst  $10
23C0: 36 00       ld   (hl),$00
23C2: C9          ret
23C3: 1A          ld   a,(de)
23C4: 24          inc  h
23C5: E3          ex   (sp),hl
23C6: 23          inc  hl
23C7: 54          ld   d,h
23C8: 24          inc  h
23C9: E3          ex   (sp),hl
23CA: 23          inc  hl
23CB: FE 23       cp   $23
23CD: 1A          ld   a,(de)
23CE: 24          inc  h
23CF: 54          ld   d,h
23D0: 24          inc  h
23D1: 54          ld   d,h
23D2: 24          inc  h
23D3: F0          ret  p
23D4: 23          inc  hl
23D5: 1A          ld   a,(de)
23D6: 24          inc  h
23D7: 1A          ld   a,(de)
23D8: 24          inc  h
23D9: 54          ld   d,h
23DA: 24          inc  h
23DB: 54          ld   d,h
23DC: 24          inc  h
23DD: 6F          ld   l,a
23DE: 24          inc  h
23DF: 0C          inc  c
23E0: 24          inc  h
23E1: 1A          ld   a,(de)
23E2: 24          inc  h
23E3: 21 60 83    ld   hl,$8360
23E6: 3A 31 83    ld   a,($8331)
23E9: D7          rst  $10
23EA: 7E          ld   a,(hl)
23EB: CB 3F       srl  a
23ED: E1          pop  hl
23EE: 18 2E       jr   $241E
23F0: 21 3E 83    ld   hl,$833E
23F3: 34          inc  (hl)
23F4: 7E          ld   a,(hl)
23F5: CB 3F       srl  a
23F7: CB 3F       srl  a
23F9: CB 3F       srl  a
23FB: E1          pop  hl
23FC: 18 20       jr   $241E
23FE: 21 60 83    ld   hl,$8360
2401: 3A 31 83    ld   a,($8331)
2404: D7          rst  $10
2405: 7E          ld   a,(hl)
2406: CB 3F       srl  a
2408: 2F          cpl
2409: E1          pop  hl
240A: 18 12       jr   $241E
240C: 21 3F 83    ld   hl,$833F
240F: 34          inc  (hl)
2410: 7E          ld   a,(hl)
2411: CB 3F       srl  a
2413: CB 3F       srl  a
2415: CB 3F       srl  a
2417: E1          pop  hl
2418: 18 04       jr   $241E
241A: E1          pop  hl
241B: 3A 33 83    ld   a,($8333)
241E: E6 03       and  $03
2420: 28 24       jr   z,$2446
2422: 3D          dec  a
2423: 28 12       jr   z,$2437
2425: 3D          dec  a
2426: 28 17       jr   z,$243F
2428: 21 58 83    ld   hl,$8358
242B: 3A 33 83    ld   a,($8333)
242E: 85          add  a,l
242F: 6F          ld   l,a
2430: 3A 37 83    ld   a,($8337)
2433: 77          ld   (hl),a
2434: C3 8E 23    jp   $238E
2437: 2C          inc  l
2438: 3A 37 83    ld   a,($8337)
243B: 77          ld   (hl),a
243C: C3 8E 23    jp   $238E
243F: 3A 37 83    ld   a,($8337)
2442: 77          ld   (hl),a
2443: C3 8E 23    jp   $238E
2446: 3A 37 83    ld   a,($8337)
2449: 2C          inc  l
244A: 0F          rrca
244B: 0F          rrca
244C: 0F          rrca
244D: 0F          rrca
244E: E6 0F       and  $0F
2450: 77          ld   (hl),a
2451: C3 8E 23    jp   $238E
2454: E1          pop  hl
2455: 3A 37 83    ld   a,($8337)
2458: 77          ld   (hl),a
2459: 0F          rrca
245A: 0F          rrca
245B: 0F          rrca
245C: 0F          rrca
245D: B6          or   (hl)
245E: 2C          inc  l
245F: 77          ld   (hl),a
2460: 21 58 83    ld   hl,$8358
2463: 3A 33 83    ld   a,($8333)
2466: 85          add  a,l
2467: 6F          ld   l,a
2468: 3A 37 83    ld   a,($8337)
246B: 77          ld   (hl),a
246C: C3 96 23    jp   $2396
246F: E1          pop  hl
2470: 3A 7D 40    ld   a,($407D)
2473: C6 10       add  a,$10
2475: CB 3F       srl  a
2477: CB 3F       srl  a
2479: 21 64 25    ld   hl,$2564
247C: D7          rst  $10
247D: EB          ex   de,hl
247E: 21 42 83    ld   hl,$8342
2481: 3A 33 83    ld   a,($8333)
2484: 87          add  a,a
2485: 87          add  a,a
2486: 85          add  a,l
2487: 6F          ld   l,a
2488: 1A          ld   a,(de)
2489: 0F          rrca
248A: 0F          rrca
248B: 0F          rrca
248C: 0F          rrca
248D: E6 F0       and  $F0
248F: 77          ld   (hl),a
2490: 2C          inc  l
2491: 1A          ld   a,(de)
2492: 77          ld   (hl),a
2493: 21 58 83    ld   hl,$8358
2496: 3A 33 83    ld   a,($8333)
2499: 85          add  a,l
249A: 6F          ld   l,a
249B: 1A          ld   a,(de)
249C: E6 F0       and  $F0
249E: 77          ld   (hl),a
249F: C3 96 23    jp   $2396
24A2: 21 58 83    ld   hl,$8358
24A5: 3A 33 83    ld   a,($8333)
24A8: 85          add  a,l
24A9: 6F          ld   l,a
24AA: 36 00       ld   (hl),$00
24AC: 87          add  a,a
24AD: 87          add  a,a
24AE: 21 42 83    ld   hl,$8342
24B1: 85          add  a,l
24B2: 6F          ld   l,a
24B3: 36 00       ld   (hl),$00
24B5: 2C          inc  l
24B6: 36 00       ld   (hl),$00
24B8: 3E 01       ld   a,$01
24BA: 32 36 83    ld   ($8336),a
24BD: C9          ret
24BE: 40          ld   b,b
24BF: 60          ld   h,b
24C0: 30 03       jr   nc,$24C5
24C2: 66          ld   h,(hl)
24C3: 20 06       jr   nz,$24CB
24C5: 46          ld   b,(hl)
24C6: 86          add  a,(hl)
24C7: C6 07       add  a,$07
24C9: 47          ld   b,a
24CA: 67          ld   h,a
24CB: 87          add  a,a
24CC: 97          sub  a
24CD: A7          and  a
24CE: B7          or   a
24CF: C7          rst  $00
24D0: D7          rst  $10
24D1: E7          rst  $20
24D2: F7          rst  $30
24D3: F7          rst  $30
24D4: E4 24 F4    call po,$F424
24D7: 24          inc  h
24D8: 04          inc  b
24D9: 25          dec  h
24DA: 14          inc  d
24DB: 25          dec  h
24DC: 24          inc  h
24DD: 25          dec  h
24DE: 34          inc  (hl)
24DF: 25          dec  h
24E0: 44          ld   b,h
24E1: 25          dec  h
24E2: 54          ld   d,h
24E3: 25          dec  h
24E4: 20 00       jr   nz,$24E6
24E6: 21 00 21    ld   hl,$2100
24E9: 00          nop
24EA: 22 00 22    ld   ($2200),hl
24ED: 00          nop
24EE: 12          ld   (de),a
24EF: 00          nop
24F0: 12          ld   (de),a
24F1: 00          nop
24F2: 02          ld   (bc),a
24F3: 00          nop
24F4: 40          ld   b,b
24F5: 00          nop
24F6: 41          ld   b,c
24F7: 00          nop
24F8: 42          ld   b,d
24F9: 00          nop
24FA: 43          ld   b,e
24FB: 00          nop
24FC: 34          inc  (hl)
24FD: 00          nop
24FE: 24          inc  h
24FF: 00          nop
2500: 14          inc  d
2501: 00          nop
2502: 04          inc  b
2503: 00          nop
2504: 60          ld   h,b
2505: 21 62 21    ld   hl,$2162
2508: 64          ld   h,h
2509: 21 65 21    ld   hl,$2165
250C: 66          ld   h,(hl)
250D: 21 16 21    ld   hl,$2116
2510: 16 21       ld   d,$21
2512: 06 21       ld   b,$21
2514: 80          add  a,b
2515: 54          ld   d,h
2516: 82          add  a,d
2517: 54          ld   d,h
2518: 85          add  a,l
2519: 54          ld   d,h
251A: 87          add  a,a
251B: 54          ld   d,h
251C: 78          ld   a,b
251D: 45          ld   b,l
251E: 58          ld   e,b
251F: 45          ld   b,l
2520: 28 45       jr   z,$2567
2522: 08          ex   af,af'
2523: 45          ld   b,l
2524: 54          ld   d,h
2525: 80          add  a,b
2526: 54          ld   d,h
2527: 82          add  a,d
2528: 54          ld   d,h
2529: 85          add  a,l
252A: 54          ld   d,h
252B: 87          add  a,a
252C: 45          ld   b,l
252D: 78          ld   a,b
252E: 45          ld   b,l
252F: 58          ld   e,b
2530: 45          ld   b,l
2531: 28 45       jr   z,$2578
2533: 08          ex   af,af'
2534: 21 60 21    ld   hl,$2160
2537: 62          ld   h,d
2538: 21 64 21    ld   hl,$2164
253B: 65          ld   h,l
253C: 12          ld   (de),a
253D: 56          ld   d,(hl)
253E: 12          ld   (de),a
253F: 46          ld   b,(hl)
2540: 12          ld   (de),a
2541: 26 12       ld   h,$12
2543: 16 00       ld   d,$00
2545: 40          ld   b,b
2546: 00          nop
2547: 41          ld   b,c
2548: 00          nop
2549: 42          ld   b,d
254A: 00          nop
254B: 43          ld   b,e
254C: 00          nop
254D: 34          inc  (hl)
254E: 00          nop
254F: 32 00 31    ld   ($3100),a
2552: 00          nop
2553: 30 00       jr   nc,$2555
2555: 20 00       jr   nz,$2557
2557: 21 00 21    ld   hl,$2100
255A: 00          nop
255B: 22 00 22    ld   ($2200),hl
255E: 00          nop
255F: 12          ld   (de),a
2560: 00          nop
2561: 12          ld   (de),a
2562: 00          nop
2563: 02          ld   (bc),a
2564: 80          add  a,b
2565: 81          add  a,c
2566: 83          add  a,e
2567: 86          add  a,(hl)
2568: 68          ld   l,b
2569: 38 18       jr   c,$2583
256B: 08          ex   af,af'
256C: 10 27       djnz $2595
256E: 10 27       djnz $2597
2570: 13          inc  de
2571: 27          daa
2572: 13          inc  de
2573: 27          daa
2574: 2F          cpl
2575: 27          daa
2576: 2F          cpl
2577: 27          daa
2578: 5C          ld   e,h
2579: 27          daa
257A: 7F          ld   a,a
257B: 27          daa
257C: 75          ld   (hl),l
257D: 2B          dec  hl
257E: 9C          sbc  a,h
257F: 2B          dec  hl
2580: C3 2B D6    jp   $D62B
2583: 2B          dec  hl
2584: BC          cp   h
2585: 28 1F       jr   z,$25A6
2587: 29          add  hl,hl
2588: 82          add  a,d
2589: 29          add  hl,hl
258A: E5          push hl
258B: 29          add  hl,hl
258C: 92          sub  d
258D: 27          daa
258E: AB          xor  e
258F: 27          daa
2590: C4 27 DD    call nz,$DD27
2593: 27          daa
2594: F6 27       or   $27
2596: 1F          rra
2597: 28 48       jr   z,$25E1
2599: 28 71       jr   z,$260C
259B: 28 9A       jr   z,$2537
259D: 28 AB       jr   z,$254A
259F: 28 48       jr   z,$25E9
25A1: 2A 4B 2A    ld   hl,($2A4B)
25A4: 4E          ld   c,(hl)
25A5: 2A 51 2A    ld   hl,($2A51)
25A8: 54          ld   d,h
25A9: 2A C7 2A    ld   hl,($2AC7)
25AC: 3A 2B 3A    ld   a,($3A2B)
25AF: 2B          dec  hl
25B0: C7          rst  $00
25B1: 2A 54 2A    ld   hl,($2A54)
25B4: 16 27       ld   d,$27
25B6: E9          jp   (hl)
25B7: 2B          dec  hl
25B8: B5          or   l
25B9: 2C          inc  l
25BA: 66          ld   h,(hl)
25BB: 2C          inc  l
25BC: 66          ld   h,(hl)
25BD: 2C          inc  l
25BE: B5          or   l
25BF: 2C          inc  l
25C0: E9          jp   (hl)
25C1: 2B          dec  hl
25C2: 14          inc  d
25C3: 2D          dec  l
25C4: 23          inc  hl
25C5: 2D          dec  l
25C6: 32 2D E7    ld   ($E72D),a
25C9: 2D          dec  l
25CA: 6E          ld   l,(hl)
25CB: 2E F5       ld   l,$F5
25CD: 2E 1E       ld   l,$1E
25CF: 06 00       ld   b,$00
25D1: 08          ex   af,af'
25D2: 04          inc  b
25D3: 00          nop
25D4: 00          nop
25D5: 02          ld   (bc),a
25D6: 00          nop
25D7: 10 04       djnz $25DD
25D9: 00          nop
25DA: 14          inc  d
25DB: 04          inc  b
25DC: 00          nop
25DD: 04          inc  b
25DE: 04          inc  b
25DF: 00          nop
25E0: 24          inc  h
25E1: 01 03 2B    ld   bc,$2B03
25E4: 02          ld   (bc),a
25E5: 04          inc  b
25E6: 1A          ld   a,(de)
25E7: 02          ld   (bc),a
25E8: 00          nop
25E9: 25          dec  h
25EA: 06 00       ld   b,$00
25EC: 0C          inc  c
25ED: 04          inc  b
25EE: 00          nop
25EF: 00          nop
25F0: 02          ld   (bc),a
25F1: 02          ld   (bc),a
25F2: 02          ld   (bc),a
25F3: 02          ld   (bc),a
25F4: 02          ld   (bc),a
25F5: 18 02       jr   $25F9
25F7: 02          ld   (bc),a
25F8: 1C          inc  e
25F9: 02          ld   (bc),a
25FA: 00          nop
25FB: 2D          dec  l
25FC: 04          inc  b
25FD: 00          nop
25FE: 01 02 01    ld   bc,$0102
2601: 02          ld   (bc),a
2602: 01 02 00    ld   bc,$0002
2605: 00          nop
2606: 00          nop
2607: 00          nop
2608: 01 02 00    ld   bc,$0002
260B: 00          nop
260C: 00          nop
260D: 00          nop
260E: 00          nop
260F: 00          nop
2610: 00          nop
2611: 00          nop
2612: 00          nop
2613: 00          nop
2614: 00          nop
2615: 00          nop
2616: 00          nop
2617: 00          nop
2618: 00          nop
2619: 02          ld   (bc),a
261A: 00          nop
261B: 02          ld   (bc),a
261C: 00          nop
261D: 01 00 01    ld   bc,$0100
2620: 00          nop
2621: 01 00 00    ld   bc,$0000
2624: 00          nop
2625: 00          nop
2626: 01 01 01    ld   bc,$0101
2629: 00          nop
262A: 00          nop
262B: 00          nop
262C: 00          nop
262D: 00          nop
262E: 00          nop
262F: 04          inc  b
2630: 04          inc  b
2631: 04          inc  b
2632: 04          inc  b
2633: 06 06       ld   b,$06
2635: 06 06       ld   b,$06
2637: 06 06       ld   b,$06
2639: 06 06       ld   b,$06
263B: 07          rlca
263C: 07          rlca
263D: 07          rlca
263E: 07          rlca
263F: 06 06       ld   b,$06
2641: 06 06       ld   b,$06
2643: 06 06       ld   b,$06
2645: 06 06       ld   b,$06
2647: 06 06       ld   b,$06
2649: 05          dec  b
264A: 05          dec  b
264B: 05          dec  b
264C: 05          dec  b
264D: 06 06       ld   b,$06
264F: 06 06       ld   b,$06
2651: 06 06       ld   b,$06
2653: 04          inc  b
2654: 06 06       ld   b,$06
2656: 06 06       ld   b,$06
2658: 06 06       ld   b,$06
265A: 07          rlca
265B: 07          rlca
265C: 06 06       ld   b,$06
265E: 06 06       ld   b,$06
2660: 00          nop
2661: 00          nop
2662: 00          nop
2663: 00          nop
2664: 01 01 01    ld   bc,$0101
2667: 01 01 01    ld   bc,$0101
266A: 01 01 01    ld   bc,$0101
266D: 01 01 01    ld   bc,$0101
2670: 01 01 01    ld   bc,$0101
2673: 01 01 01    ld   bc,$0101
2676: 01 01 00    ld   bc,$0001
2679: 00          nop
267A: 00          nop
267B: 00          nop
267C: 00          nop
267D: 00          nop
267E: 01 01 01    ld   bc,$0101
2681: 01 01 01    ld   bc,$0101
2684: 00          nop
2685: 00          nop
2686: 00          nop
2687: 00          nop
2688: 00          nop
2689: 00          nop
268A: 00          nop
268B: 00          nop
268C: 00          nop
268D: 00          nop
268E: 00          nop
268F: 00          nop
2690: 00          nop
2691: 00          nop
2692: 00          nop
2693: 00          nop
2694: 00          nop
2695: 01 01 01    ld   bc,$0101
2698: 01 01 01    ld   bc,$0101
269B: 01 01 01    ld   bc,$0101
269E: 01 01 01    ld   bc,$0101
26A1: 01 01 01    ld   bc,$0101
26A4: 01 01 01    ld   bc,$0101
26A7: 01 01 00    ld   bc,$0001
26AA: 00          nop
26AB: 00          nop
26AC: 00          nop
26AD: 00          nop
26AE: 00          nop
26AF: 01 01 01    ld   bc,$0101
26B2: 01 01 01    ld   bc,$0101
26B5: 00          nop
26B6: 01 01 01    ld   bc,$0101
26B9: 01 01 01    ld   bc,$0101
26BC: 00          nop
26BD: 00          nop
26BE: 01 01 01    ld   bc,$0101
26C1: 01 50 81    ld   bc,$8150
26C4: 00          nop
26C5: 89          adc  a,c
26C6: 26 91       ld   h,$91
26C8: C8          ret  z
26C9: 99          sbc  a,c
26CA: EC A2 9D    call pe,$9DA2
26CD: AC          xor  h
26CE: E0          ret  po
26CF: B6          or   (hl)
26D0: C0          ret  nz
26D1: C1          pop  bc
26D2: 45          ld   b,l
26D3: CD 7A D9    call $D97A
26D6: 69          ld   l,c
26D7: E6 1C       and  $1C
26D9: F4 00 00    call p,$0000
26DC: 35          dec  (hl)
26DD: 82          add  a,d
26DE: F2 89 27    jp   p,$2789
26E1: 92          sub  d
26E2: D8          ret  c
26E3: 9A          sbc  a,d
26E4: 0C          inc  c
26E5: A4          and  h
26E6: CE AD       adc  a,$AD
26E8: 23          inc  hl
26E9: B8          cp   b
26EA: 17          rla
26EB: C3 B0 CE    jp   $CEB0
26EE: FB          ei
26EF: DA 01 E8    jp   c,$E801
26F2: CC F5 00    call z,$00F5
26F5: 00          nop
26F6: 6E          ld   l,(hl)
26F7: 80          add  a,b
26F8: 11 88 29    ld   de,$2988
26FB: 90          sub  b
26FC: BC          cp   h
26FD: 98          sbc  a,b
26FE: D0          ret  nc
26FF: A1          and  c
2700: 70          ld   (hl),b
2701: AB          xor  e
2702: A1          and  c
2703: B5          or   l
2704: 6E          ld   l,(hl)
2705: C0          ret  nz
2706: DF          rst  $18
2707: CB FE       set  7,(hl)
2709: D7          rst  $10
270A: D7          rst  $10
270B: E4 72 F2    call po,$F272
270E: 00          nop
270F: 00          nop
2710: 02          ld   (bc),a
2711: 18 FF       jr   $2712
2713: 01 78 FF    ld   bc,$FF78
2716: A2          and  d
2717: 0C          inc  c
2718: C0          ret  nz
2719: 0C          inc  c
271A: A2          and  d
271B: 0C          inc  c
271C: C0          ret  nz
271D: 0C          inc  c
271E: A2          and  d
271F: 0C          inc  c
2720: C0          ret  nz
2721: 0C          inc  c
2722: A2          and  d
2723: 0C          inc  c
2724: C0          ret  nz
2725: 0C          inc  c
2726: A2          and  d
2727: 0C          inc  c
2728: C0          ret  nz
2729: 0C          inc  c
272A: A2          and  d
272B: 0C          inc  c
272C: C0          ret  nz
272D: 0C          inc  c
272E: FF          rst  $38
272F: 73          ld   (hl),e
2730: 40          ld   b,b
2731: 73          ld   (hl),e
2732: 10 73       djnz $27A7
2734: 10 93       djnz $26C9
2736: 10 53       djnz $278B
2738: 10 23       djnz $275D
273A: 10 03       djnz $273F
273C: 10 23       djnz $2761
273E: 10 53       djnz $2793
2740: 10 73       djnz $27B5
2742: 18 73       jr   $27B7
2744: 0C          inc  c
2745: 73          ld   (hl),e
2746: 0C          inc  c
2747: 93          sub  e
2748: 10 53       djnz $279D
274A: 10 23       djnz $276F
274C: 10 03       djnz $2751
274E: 10 23       djnz $2773
2750: 10 53       djnz $27A5
2752: 10 73       djnz $27C7
2754: 10 A3       djnz $26F9
2756: 10 02       djnz $275A
2758: 10 22       djnz $277C
275A: 90          sub  b
275B: FF          rst  $38
275C: 23          inc  hl
275D: 50          ld   d,b
275E: 23          inc  hl
275F: 10 03       djnz $2764
2761: 30 94       jr   nc,$26F7
2763: 30 23       jr   nc,$2788
2765: 18 23       jr   $278A
2767: 0C          inc  c
2768: 23          inc  hl
2769: 0C          inc  c
276A: 03          inc  bc
276B: 10 94       djnz $2701
276D: 10 74       djnz $27E3
276F: 10 94       djnz $2705
2771: 10 03       djnz $2776
2773: 10 23       djnz $2798
2775: 10 53       djnz $27CA
2777: 10 73       djnz $27EC
2779: 10 A3       djnz $271E
277B: 10 93       djnz $2710
277D: 90          sub  b
277E: FF          rst  $38
277F: 73          ld   (hl),e
2780: 30 53       jr   nc,$27D5
2782: 30 23       jr   nc,$27A7
2784: 30 03       jr   nc,$2789
2786: 30 73       jr   nc,$27FB
2788: 30 53       jr   nc,$27DD
278A: 30 23       jr   nc,$27AF
278C: 30 03       jr   nc,$2791
278E: 30 23       jr   nc,$27B3
2790: 90          sub  b
2791: FF          rst  $38
2792: 33          inc  sp
2793: 40          ld   b,b
2794: 33          inc  sp
2795: 10 33       djnz $27CA
2797: 10 43       djnz $27DC
2799: 10 43       djnz $27DE
279B: 10 43       djnz $27E0
279D: 10 53       djnz $27F2
279F: 10 53       djnz $27F4
27A1: 10 53       djnz $27F6
27A3: 10 63       djnz $2808
27A5: 20 63       jr   nz,$280A
27A7: 10 73       djnz $281C
27A9: A0          and  b
27AA: FF          rst  $38
27AB: 73          ld   (hl),e
27AC: 40          ld   b,b
27AD: 73          ld   (hl),e
27AE: 10 73       djnz $2823
27B0: 10 83       djnz $2735
27B2: 10 83       djnz $2737
27B4: 10 83       djnz $2739
27B6: 10 93       djnz $274B
27B8: 10 93       djnz $274D
27BA: 10 93       djnz $274F
27BC: 10 A3       djnz $2761
27BE: 20 A3       jr   nz,$2763
27C0: 10 B3       djnz $2775
27C2: A0          and  b
27C3: FF          rst  $38
27C4: A3          and  e
27C5: 40          ld   b,b
27C6: A3          and  e
27C7: 10 A3       djnz $276C
27C9: 10 B3       djnz $277E
27CB: 10 B3       djnz $2780
27CD: 10 B3       djnz $2782
27CF: 10 02       djnz $27D3
27D1: 10 02       djnz $27D5
27D3: 10 02       djnz $27D7
27D5: 10 12       djnz $27E9
27D7: 20 12       jr   nz,$27EB
27D9: 10 22       djnz $27FD
27DB: A0          and  b
27DC: FF          rst  $38
27DD: 23          inc  hl
27DE: 40          ld   b,b
27DF: 23          inc  hl
27E0: 10 23       djnz $2805
27E2: 10 33       djnz $2817
27E4: 10 33       djnz $2819
27E6: 10 33       djnz $281B
27E8: 10 43       djnz $282D
27EA: 10 43       djnz $282F
27EC: 10 43       djnz $2831
27EE: 10 53       djnz $2843
27F0: 20 53       jr   nz,$2845
27F2: 10 63       djnz $2857
27F4: A0          and  b
27F5: FF          rst  $38
27F6: A3          and  e
27F7: 0C          inc  c
27F8: A3          and  e
27F9: 0C          inc  c
27FA: A3          and  e
27FB: 0C          inc  c
27FC: C0          ret  nz
27FD: 24          inc  h
27FE: 93          sub  e
27FF: 0C          inc  c
2800: 93          sub  e
2801: 0C          inc  c
2802: 93          sub  e
2803: 0C          inc  c
2804: C0          ret  nz
2805: 0C          inc  c
2806: 73          ld   (hl),e
2807: 0C          inc  c
2808: 73          ld   (hl),e
2809: 0C          inc  c
280A: 73          ld   (hl),e
280B: 18 33       jr   $2840
280D: 30 53       jr   nc,$2862
280F: 30 83       jr   nc,$2794
2811: 30 B3       jr   nc,$27C6
2813: 30 22       jr   nc,$2837
2815: 18 32       jr   $2849
2817: 0C          inc  c
2818: 32 0C 32    ld   ($320C),a
281B: 0C          inc  c
281C: C0          ret  nz
281D: 0C          inc  c
281E: FF          rst  $38
281F: 73          ld   (hl),e
2820: 0C          inc  c
2821: 73          ld   (hl),e
2822: 0C          inc  c
2823: 73          ld   (hl),e
2824: 0C          inc  c
2825: C0          ret  nz
2826: 24          inc  h
2827: 53          ld   d,e
2828: 0C          inc  c
2829: 53          ld   d,e
282A: 0C          inc  c
282B: 53          ld   d,e
282C: 0C          inc  c
282D: C0          ret  nz
282E: 0C          inc  c
282F: 33          inc  sp
2830: 0C          inc  c
2831: 33          inc  sp
2832: 0C          inc  c
2833: 33          inc  sp
2834: 18 13       jr   $2849
2836: 30 23       jr   nc,$285B
2838: 30 53       jr   nc,$288D
283A: 30 83       jr   nc,$27BF
283C: 30 02       jr   nc,$2840
283E: 18 12       jr   $2852
2840: 0C          inc  c
2841: 12          ld   (de),a
2842: 0C          inc  c
2843: 12          ld   (de),a
2844: 0C          inc  c
2845: C0          ret  nz
2846: 0C          inc  c
2847: FF          rst  $38
2848: 33          inc  sp
2849: 0C          inc  c
284A: 33          inc  sp
284B: 0C          inc  c
284C: 33          inc  sp
284D: 0C          inc  c
284E: C0          ret  nz
284F: 24          inc  h
2850: 23          inc  hl
2851: 0C          inc  c
2852: 23          inc  hl
2853: 0C          inc  c
2854: 23          inc  hl
2855: 0C          inc  c
2856: C0          ret  nz
2857: 0C          inc  c
2858: 03          inc  bc
2859: 0C          inc  c
285A: 03          inc  bc
285B: 0C          inc  c
285C: 03          inc  bc
285D: 18 A4       jr   $2803
285F: 30 B4       jr   nc,$2815
2861: 30 23       jr   nc,$2886
2863: 30 53       jr   nc,$28B8
2865: 30 83       jr   nc,$27EA
2867: 18 A3       jr   $280C
2869: 0C          inc  c
286A: A3          and  e
286B: 0C          inc  c
286C: A3          and  e
286D: 0C          inc  c
286E: C0          ret  nz
286F: 0C          inc  c
2870: FF          rst  $38
2871: 23          inc  hl
2872: 0C          inc  c
2873: 23          inc  hl
2874: 0C          inc  c
2875: 23          inc  hl
2876: 0C          inc  c
2877: C0          ret  nz
2878: 24          inc  h
2879: 03          inc  bc
287A: 0C          inc  c
287B: 03          inc  bc
287C: 0C          inc  c
287D: 03          inc  bc
287E: 0C          inc  c
287F: C0          ret  nz
2880: 0C          inc  c
2881: A3          and  e
2882: 0C          inc  c
2883: A3          and  e
2884: 0C          inc  c
2885: A3          and  e
2886: 18 64       jr   $28EC
2888: 30 84       jr   nc,$280E
288A: 30 B4       jr   nc,$2840
288C: 30 23       jr   nc,$28B1
288E: 30 53       jr   nc,$28E3
2890: 18 63       jr   $28F5
2892: 0C          inc  c
2893: 63          ld   h,e
2894: 0C          inc  c
2895: 63          ld   h,e
2896: 0C          inc  c
2897: C0          ret  nz
2898: 0C          inc  c
2899: FF          rst  $38
289A: 34          inc  (hl)
289B: 01 64 01    ld   bc,$0164
289E: 94          sub  h
289F: 01 03 01    ld   bc,$0103
28A2: 33          inc  sp
28A3: 01 63 01    ld   bc,$0163
28A6: 93          sub  e
28A7: 01 02 01    ld   bc,$0102
28AA: FF          rst  $38
28AB: 54          ld   d,h
28AC: 01 84 01    ld   bc,$0184
28AF: B4          or   h
28B0: 01 23 01    ld   bc,$0123
28B3: 53          ld   d,e
28B4: 01 83 01    ld   bc,$0183
28B7: B3          or   e
28B8: 01 22 01    ld   bc,$0122
28BB: FF          rst  $38
28BC: A3          and  e
28BD: 30 93       jr   nc,$2852
28BF: 10 C0       djnz $2881
28C1: 10 A3       djnz $2866
28C3: 10 32       djnz $28F7
28C5: 30 22       jr   nc,$28E9
28C7: 10 C0       djnz $2889
28C9: 10 32       djnz $28FD
28CB: 10 52       djnz $291F
28CD: 10 C0       djnz $288F
28CF: 10 52       djnz $2923
28D1: 10 52       djnz $2925
28D3: 10 C0       djnz $2895
28D5: 10 72       djnz $2949
28D7: 20 C0       jr   nz,$2899
28D9: 10 52       djnz $292D
28DB: 10 A2       djnz $287F
28DD: 30 A3       jr   nc,$2882
28DF: 30 93       jr   nc,$2874
28E1: 10 C0       djnz $28A3
28E3: 10 A3       djnz $2888
28E5: 10 32       djnz $2919
28E7: 30 22       jr   nc,$290B
28E9: 10 C0       djnz $28AB
28EB: 10 32       djnz $291F
28ED: 10 52       djnz $2941
28EF: 10 C0       djnz $28B1
28F1: 10 52       djnz $2945
28F3: 10 52       djnz $2947
28F5: 10 C0       djnz $28B7
28F7: 10 72       djnz $296B
28F9: 20 C0       jr   nz,$28BB
28FB: 10 52       djnz $294F
28FD: 10 32       djnz $2931
28FF: 10 C0       djnz $28C1
2901: 10 22       djnz $2925
2903: 10 52       djnz $2957
2905: 40          ld   b,b
2906: C0          ret  nz
2907: 10 32       djnz $293B
2909: 30 C0       jr   nc,$28CB
290B: 10 32       djnz $293F
290D: 20 C0       jr   nz,$28CF
290F: 10 32       djnz $2943
2911: 40          ld   b,b
2912: C0          ret  nz
2913: 10 22       djnz $2937
2915: 30 C0       jr   nc,$28D7
2917: 10 22       djnz $293B
2919: 10 C0       djnz $28DB
291B: 10 22       djnz $293F
291D: 10 FF       djnz $291E
291F: A3          and  e
2920: 30 93       jr   nc,$28B5
2922: 10 C0       djnz $28E4
2924: 10 A3       djnz $28C9
2926: 10 32       djnz $295A
2928: 30 22       jr   nc,$294C
292A: 10 C0       djnz $28EC
292C: 10 32       djnz $2960
292E: 10 32       djnz $2962
2930: 10 C0       djnz $28F2
2932: 10 32       djnz $2966
2934: 10 32       djnz $2968
2936: 10 C0       djnz $28F8
2938: 10 32       djnz $296C
293A: 20 C0       jr   nz,$28FC
293C: 10 32       djnz $2970
293E: 10 82       djnz $28C2
2940: 30 A3       jr   nc,$28E5
2942: 30 93       jr   nc,$28D7
2944: 10 C0       djnz $2906
2946: 10 A3       djnz $28EB
2948: 10 32       djnz $297C
294A: 30 22       jr   nc,$296E
294C: 10 C0       djnz $290E
294E: 10 32       djnz $2982
2950: 10 32       djnz $2984
2952: 10 C0       djnz $2914
2954: 10 32       djnz $2988
2956: 10 32       djnz $298A
2958: 10 C0       djnz $291A
295A: 10 32       djnz $298E
295C: 20 C0       jr   nz,$291E
295E: 10 32       djnz $2992
2960: 10 B3       djnz $2915
2962: 10 C0       djnz $2924
2964: 10 B3       djnz $2919
2966: 10 22       djnz $298A
2968: 40          ld   b,b
2969: C0          ret  nz
296A: 10 22       djnz $298E
296C: 30 C0       jr   nc,$292E
296E: 10 22       djnz $2992
2970: 20 C0       jr   nz,$2932
2972: 10 02       djnz $2976
2974: 40          ld   b,b
2975: C0          ret  nz
2976: 10 02       djnz $297A
2978: 30 C0       jr   nc,$293A
297A: 10 02       djnz $297E
297C: 10 C0       djnz $293E
297E: 10 02       djnz $2982
2980: 10 FF       djnz $2981
2982: 73          ld   (hl),e
2983: 30 63       jr   nc,$29E8
2985: 10 C0       djnz $2947
2987: 10 73       djnz $29FC
2989: 10 A3       djnz $292E
298B: 30 A3       jr   nc,$2930
298D: 10 C0       djnz $294F
298F: 10 A3       djnz $2934
2991: 10 B3       djnz $2946
2993: 10 C0       djnz $2955
2995: 10 B3       djnz $294A
2997: 10 B3       djnz $294C
2999: 10 C0       djnz $295B
299B: 10 B3       djnz $2950
299D: 20 C0       jr   nz,$295F
299F: 10 B3       djnz $2954
29A1: 10 52       djnz $29F5
29A3: 30 73       jr   nc,$2A18
29A5: 30 63       jr   nc,$2A0A
29A7: 10 C0       djnz $2969
29A9: 10 73       djnz $2A1E
29AB: 10 A3       djnz $2950
29AD: 30 93       jr   nc,$2942
29AF: 10 C0       djnz $2971
29B1: 10 A3       djnz $2956
29B3: 10 B3       djnz $2968
29B5: 10 C0       djnz $2977
29B7: 10 B3       djnz $296C
29B9: 10 B3       djnz $296E
29BB: 10 C0       djnz $297D
29BD: 10 B3       djnz $2972
29BF: 20 C0       jr   nz,$2981
29C1: 10 B3       djnz $2976
29C3: 10 83       djnz $2948
29C5: 10 C0       djnz $2987
29C7: 10 83       djnz $294C
29C9: 10 A3       djnz $296E
29CB: 40          ld   b,b
29CC: C0          ret  nz
29CD: 10 A3       djnz $2972
29CF: 30 C0       jr   nc,$2991
29D1: 10 A3       djnz $2976
29D3: 20 C0       jr   nz,$2995
29D5: 10 83       djnz $295A
29D7: 40          ld   b,b
29D8: C0          ret  nz
29D9: 10 83       djnz $295E
29DB: 30 C0       jr   nc,$299D
29DD: 10 83       djnz $2962
29DF: 10 C0       djnz $29A1
29E1: 10 83       djnz $2966
29E3: 10 FF       djnz $29E4
29E5: 33          inc  sp
29E6: 30 33       jr   nc,$2A1B
29E8: 10 C0       djnz $29AA
29EA: 10 33       djnz $2A1F
29EC: 10 73       djnz $2A61
29EE: 30 63       jr   nc,$2A53
29F0: 10 C0       djnz $29B2
29F2: 10 73       djnz $2A67
29F4: 10 83       djnz $2979
29F6: 10 C0       djnz $29B8
29F8: 10 83       djnz $297D
29FA: 10 83       djnz $297F
29FC: 10 C0       djnz $29BE
29FE: 10 83       djnz $2983
2A00: 20 C0       jr   nz,$29C2
2A02: 10 83       djnz $2987
2A04: 10 22       djnz $2A28
2A06: 30 33       jr   nc,$2A3B
2A08: 30 33       jr   nc,$2A3D
2A0A: 10 C0       djnz $29CC
2A0C: 10 33       djnz $2A41
2A0E: 10 73       djnz $2A83
2A10: 30 73       jr   nc,$2A85
2A12: 10 C0       djnz $29D4
2A14: 10 73       djnz $2A89
2A16: 10 83       djnz $299B
2A18: 10 C0       djnz $29DA
2A1A: 10 83       djnz $299F
2A1C: 10 83       djnz $29A1
2A1E: 10 C0       djnz $29E0
2A20: 10 83       djnz $29A5
2A22: 20 C0       jr   nz,$29E4
2A24: 10 83       djnz $29A9
2A26: 10 53       djnz $2A7B
2A28: 10 C0       djnz $29EA
2A2A: 10 53       djnz $2A7F
2A2C: 10 73       djnz $2AA1
2A2E: 40          ld   b,b
2A2F: C0          ret  nz
2A30: 10 73       djnz $2AA5
2A32: 30 C0       jr   nc,$29F4
2A34: 10 63       djnz $2A99
2A36: 20 C0       jr   nz,$29F8
2A38: 10 53       djnz $2A8D
2A3A: 40          ld   b,b
2A3B: C0          ret  nz
2A3C: 10 53       djnz $2A91
2A3E: 30 C0       jr   nc,$2A00
2A40: 10 43       djnz $2A85
2A42: 10 C0       djnz $2A04
2A44: 10 53       djnz $2A99
2A46: 10 FF       djnz $2A47
2A48: A3          and  e
2A49: 04          inc  b
2A4A: FF          rst  $38
2A4B: 02          ld   (bc),a
2A4C: 04          inc  b
2A4D: FF          rst  $38
2A4E: 73          ld   (hl),e
2A4F: 04          inc  b
2A50: FF          rst  $38
2A51: A3          and  e
2A52: 04          inc  b
2A53: FF          rst  $38
2A54: 83          add  a,e
2A55: 30 83       jr   nc,$29DA
2A57: 0C          inc  c
2A58: 83          add  a,e
2A59: 0C          inc  c
2A5A: 83          add  a,e
2A5B: 12          ld   (de),a
2A5C: 83          add  a,e
2A5D: 09          add  hl,bc
2A5E: 83          add  a,e
2A5F: 09          add  hl,bc
2A60: A3          and  e
2A61: 0C          inc  c
2A62: 33          inc  sp
2A63: 0C          inc  c
2A64: A3          and  e
2A65: 0C          inc  c
2A66: 83          add  a,e
2A67: 30 83       jr   nc,$29EC
2A69: 0C          inc  c
2A6A: 83          add  a,e
2A6B: 0C          inc  c
2A6C: 83          add  a,e
2A6D: 12          ld   (de),a
2A6E: 83          add  a,e
2A6F: 09          add  hl,bc
2A70: 83          add  a,e
2A71: 09          add  hl,bc
2A72: A3          and  e
2A73: 0C          inc  c
2A74: 33          inc  sp
2A75: 0C          inc  c
2A76: A3          and  e
2A77: 0C          inc  c
2A78: 02          ld   (bc),a
2A79: 18 02       jr   $2A7D
2A7B: 0C          inc  c
2A7C: 02          ld   (bc),a
2A7D: 0C          inc  c
2A7E: 83          add  a,e
2A7F: 0C          inc  c
2A80: 02          ld   (bc),a
2A81: 0C          inc  c
2A82: 12          ld   (de),a
2A83: 0C          inc  c
2A84: 83          add  a,e
2A85: 0C          inc  c
2A86: 12          ld   (de),a
2A87: 0C          inc  c
2A88: 32 0C 83    ld   ($830C),a
2A8B: 0C          inc  c
2A8C: 32 0C 62    ld   ($620C),a
2A8F: 18 62       jr   $2AF3
2A91: 0C          inc  c
2A92: 52          ld   d,d
2A93: 0C          inc  c
2A94: 32 0C 12    ld   ($120C),a
2A97: 0C          inc  c
2A98: 32 12 12    ld   ($1212),a
2A9B: 12          ld   (de),a
2A9C: 02          ld   (bc),a
2A9D: 12          ld   (de),a
2A9E: A3          and  e
2A9F: 12          ld   (de),a
2AA0: 83          add  a,e
2AA1: 30 83       jr   nc,$2A26
2AA3: 0C          inc  c
2AA4: 83          add  a,e
2AA5: 0C          inc  c
2AA6: 83          add  a,e
2AA7: 12          ld   (de),a
2AA8: 83          add  a,e
2AA9: 09          add  hl,bc
2AAA: 83          add  a,e
2AAB: 09          add  hl,bc
2AAC: A3          and  e
2AAD: 0C          inc  c
2AAE: 33          inc  sp
2AAF: 0C          inc  c
2AB0: A3          and  e
2AB1: 0C          inc  c
2AB2: 02          ld   (bc),a
2AB3: 30 02       jr   nc,$2AB7
2AB5: 0C          inc  c
2AB6: 02          ld   (bc),a
2AB7: 0C          inc  c
2AB8: 02          ld   (bc),a
2AB9: 12          ld   (de),a
2ABA: 02          ld   (bc),a
2ABB: 09          add  hl,bc
2ABC: 02          ld   (bc),a
2ABD: 09          add  hl,bc
2ABE: 32 0C A3    ld   ($A30C),a
2AC1: 0C          inc  c
2AC2: 32 0C 82    ld   ($820C),a
2AC5: B4          or   h
2AC6: FF          rst  $38
2AC7: 83          add  a,e
2AC8: 30 83       jr   nc,$2A4D
2ACA: 0C          inc  c
2ACB: 83          add  a,e
2ACC: 0C          inc  c
2ACD: 83          add  a,e
2ACE: 12          ld   (de),a
2ACF: 83          add  a,e
2AD0: 09          add  hl,bc
2AD1: 83          add  a,e
2AD2: 09          add  hl,bc
2AD3: A3          and  e
2AD4: 0C          inc  c
2AD5: 33          inc  sp
2AD6: 0C          inc  c
2AD7: A3          and  e
2AD8: 0C          inc  c
2AD9: 83          add  a,e
2ADA: 30 83       jr   nc,$2A5F
2ADC: 0C          inc  c
2ADD: 83          add  a,e
2ADE: 0C          inc  c
2ADF: 83          add  a,e
2AE0: 12          ld   (de),a
2AE1: 83          add  a,e
2AE2: 09          add  hl,bc
2AE3: 83          add  a,e
2AE4: 09          add  hl,bc
2AE5: A3          and  e
2AE6: 0C          inc  c
2AE7: 33          inc  sp
2AE8: 0C          inc  c
2AE9: A3          and  e
2AEA: 0C          inc  c
2AEB: 83          add  a,e
2AEC: 18 83       jr   $2A71
2AEE: 0C          inc  c
2AEF: 83          add  a,e
2AF0: 0C          inc  c
2AF1: 33          inc  sp
2AF2: 0C          inc  c
2AF3: 83          add  a,e
2AF4: 0C          inc  c
2AF5: 83          add  a,e
2AF6: 0C          inc  c
2AF7: 33          inc  sp
2AF8: 0C          inc  c
2AF9: 83          add  a,e
2AFA: 0C          inc  c
2AFB: 83          add  a,e
2AFC: 0C          inc  c
2AFD: 33          inc  sp
2AFE: 0C          inc  c
2AFF: 83          add  a,e
2B00: 0C          inc  c
2B01: 12          ld   (de),a
2B02: 18 12       jr   $2B16
2B04: 0C          inc  c
2B05: 02          ld   (bc),a
2B06: 0C          inc  c
2B07: A3          and  e
2B08: 0C          inc  c
2B09: 83          add  a,e
2B0A: 0C          inc  c
2B0B: A3          and  e
2B0C: 12          ld   (de),a
2B0D: 83          add  a,e
2B0E: 12          ld   (de),a
2B0F: 73          ld   (hl),e
2B10: 12          ld   (de),a
2B11: 53          ld   d,e
2B12: 12          ld   (de),a
2B13: 83          add  a,e
2B14: 30 83       jr   nc,$2A99
2B16: 0C          inc  c
2B17: 83          add  a,e
2B18: 0C          inc  c
2B19: 83          add  a,e
2B1A: 12          ld   (de),a
2B1B: 83          add  a,e
2B1C: 09          add  hl,bc
2B1D: 83          add  a,e
2B1E: 09          add  hl,bc
2B1F: A3          and  e
2B20: 0C          inc  c
2B21: 33          inc  sp
2B22: 0C          inc  c
2B23: A3          and  e
2B24: 0C          inc  c
2B25: 83          add  a,e
2B26: 30 83       jr   nc,$2AAB
2B28: 0C          inc  c
2B29: 83          add  a,e
2B2A: 0C          inc  c
2B2B: 83          add  a,e
2B2C: 12          ld   (de),a
2B2D: 83          add  a,e
2B2E: 09          add  hl,bc
2B2F: 83          add  a,e
2B30: 09          add  hl,bc
2B31: A3          and  e
2B32: 0C          inc  c
2B33: 33          inc  sp
2B34: 0C          inc  c
2B35: A3          and  e
2B36: 0C          inc  c
2B37: 02          ld   (bc),a
2B38: B4          or   h
2B39: FF          rst  $38
2B3A: 84          add  a,h
2B3B: 24          inc  h
2B3C: 74          ld   (hl),h
2B3D: 24          inc  h
2B3E: 54          ld   d,h
2B3F: 24          inc  h
2B40: 34          inc  (hl)
2B41: 24          inc  h
2B42: 84          add  a,h
2B43: 24          inc  h
2B44: 74          ld   (hl),h
2B45: 24          inc  h
2B46: 54          ld   d,h
2B47: 24          inc  h
2B48: 34          inc  (hl)
2B49: 24          inc  h
2B4A: 84          add  a,h
2B4B: 24          inc  h
2B4C: 74          ld   (hl),h
2B4D: 24          inc  h
2B4E: 54          ld   d,h
2B4F: 24          inc  h
2B50: 34          inc  (hl)
2B51: 24          inc  h
2B52: 13          inc  de
2B53: 24          inc  h
2B54: 03          inc  bc
2B55: 24          inc  h
2B56: A4          and  h
2B57: 24          inc  h
2B58: 34          inc  (hl)
2B59: 24          inc  h
2B5A: 84          add  a,h
2B5B: 24          inc  h
2B5C: 74          ld   (hl),h
2B5D: 24          inc  h
2B5E: 54          ld   d,h
2B5F: 24          inc  h
2B60: 34          inc  (hl)
2B61: 24          inc  h
2B62: 84          add  a,h
2B63: 24          inc  h
2B64: 74          ld   (hl),h
2B65: 24          inc  h
2B66: 54          ld   d,h
2B67: 24          inc  h
2B68: 34          inc  (hl)
2B69: 24          inc  h
2B6A: 84          add  a,h
2B6B: 24          inc  h
2B6C: 34          inc  (hl)
2B6D: 24          inc  h
2B6E: 84          add  a,h
2B6F: 24          inc  h
2B70: 34          inc  (hl)
2B71: 24          inc  h
2B72: 84          add  a,h
2B73: 24          inc  h
2B74: FF          rst  $38
2B75: A3          and  e
2B76: 18 93       jr   $2B0B
2B78: 0C          inc  c
2B79: A3          and  e
2B7A: 3C          inc  a
2B7B: B3          or   e
2B7C: 0C          inc  c
2B7D: A3          and  e
2B7E: 0C          inc  c
2B7F: 93          sub  e
2B80: 0C          inc  c
2B81: A3          and  e
2B82: 0C          inc  c
2B83: B3          or   e
2B84: 0C          inc  c
2B85: A3          and  e
2B86: 0C          inc  c
2B87: B3          or   e
2B88: 0C          inc  c
2B89: 02          ld   (bc),a
2B8A: 0C          inc  c
2B8B: B3          or   e
2B8C: 0C          inc  c
2B8D: 03          inc  bc
2B8E: 0C          inc  c
2B8F: 12          ld   (de),a
2B90: 0C          inc  c
2B91: 02          ld   (bc),a
2B92: 0C          inc  c
2B93: 12          ld   (de),a
2B94: 0C          inc  c
2B95: 22 18 22    ld   ($2218),hl
2B98: 0C          inc  c
2B99: 32 78 FF    ld   ($FF78),a
2B9C: 73          ld   (hl),e
2B9D: 18 63       jr   $2C02
2B9F: 0C          inc  c
2BA0: 73          ld   (hl),e
2BA1: 3C          inc  a
2BA2: 83          add  a,e
2BA3: 0C          inc  c
2BA4: 73          ld   (hl),e
2BA5: 0C          inc  c
2BA6: 63          ld   h,e
2BA7: 0C          inc  c
2BA8: 73          ld   (hl),e
2BA9: 0C          inc  c
2BAA: 83          add  a,e
2BAB: 0C          inc  c
2BAC: 73          ld   (hl),e
2BAD: 0C          inc  c
2BAE: 83          add  a,e
2BAF: 0C          inc  c
2BB0: 93          sub  e
2BB1: 0C          inc  c
2BB2: 83          add  a,e
2BB3: 0C          inc  c
2BB4: 93          sub  e
2BB5: 0C          inc  c
2BB6: A3          and  e
2BB7: 0C          inc  c
2BB8: 93          sub  e
2BB9: 0C          inc  c
2BBA: A3          and  e
2BBB: 0C          inc  c
2BBC: B3          or   e
2BBD: 18 B3       jr   $2B72
2BBF: 0C          inc  c
2BC0: 02          ld   (bc),a
2BC1: 78          ld   a,b
2BC2: FF          rst  $38
2BC3: 33          inc  sp
2BC4: 24          inc  h
2BC5: A4          and  h
2BC6: 24          inc  h
2BC7: 33          inc  sp
2BC8: 24          inc  h
2BC9: A4          and  h
2BCA: 24          inc  h
2BCB: 43          ld   b,e
2BCC: 24          inc  h
2BCD: B4          or   h
2BCE: 24          inc  h
2BCF: 53          ld   d,e
2BD0: 24          inc  h
2BD1: 63          ld   h,e
2BD2: 24          inc  h
2BD3: 73          ld   (hl),e
2BD4: 78          ld   a,b
2BD5: FF          rst  $38
2BD6: 33          inc  sp
2BD7: 24          inc  h
2BD8: A4          and  h
2BD9: 24          inc  h
2BDA: 33          inc  sp
2BDB: 24          inc  h
2BDC: A4          and  h
2BDD: 24          inc  h
2BDE: 43          ld   b,e
2BDF: 24          inc  h
2BE0: B4          or   h
2BE1: 24          inc  h
2BE2: 83          add  a,e
2BE3: 24          inc  h
2BE4: 93          sub  e
2BE5: 24          inc  h
2BE6: A3          and  e
2BE7: 78          ld   a,b
2BE8: FF          rst  $38
2BE9: 33          inc  sp
2BEA: 24          inc  h
2BEB: 83          add  a,e
2BEC: 1B          dec  de
2BED: A3          and  e
2BEE: 09          add  hl,bc
2BEF: 02          ld   (bc),a
2BF0: 1B          dec  de
2BF1: 83          add  a,e
2BF2: 09          add  hl,bc
2BF3: 12          ld   (de),a
2BF4: 1B          dec  de
2BF5: 03          inc  bc
2BF6: 09          add  hl,bc
2BF7: A3          and  e
2BF8: 1B          dec  de
2BF9: 02          ld   (bc),a
2BFA: 09          add  hl,bc
2BFB: A3          and  e
2BFC: 1B          dec  de
2BFD: 83          add  a,e
2BFE: 09          add  hl,bc
2BFF: 73          ld   (hl),e
2C00: 1B          dec  de
2C01: 53          ld   d,e
2C02: 09          add  hl,bc
2C03: 33          inc  sp
2C04: 24          inc  h
2C05: 33          inc  sp
2C06: 0C          inc  c
2C07: 83          add  a,e
2C08: 0C          inc  c
2C09: A3          and  e
2C0A: 0C          inc  c
2C0B: 33          inc  sp
2C0C: 0C          inc  c
2C0D: 83          add  a,e
2C0E: 0C          inc  c
2C0F: A3          and  e
2C10: 0C          inc  c
2C11: 32 1B 12    ld   ($121B),a
2C14: 09          add  hl,bc
2C15: 02          ld   (bc),a
2C16: 1B          dec  de
2C17: 12          ld   (de),a
2C18: 09          add  hl,bc
2C19: 02          ld   (bc),a
2C1A: 1B          dec  de
2C1B: 83          add  a,e
2C1C: 09          add  hl,bc
2C1D: A3          and  e
2C1E: 1B          dec  de
2C1F: 73          ld   (hl),e
2C20: 09          add  hl,bc
2C21: 83          add  a,e
2C22: 1B          dec  de
2C23: 83          add  a,e
2C24: 09          add  hl,bc
2C25: 02          ld   (bc),a
2C26: 1B          dec  de
2C27: 32 09 52    ld   ($5209),a
2C2A: 1B          dec  de
2C2B: 52          ld   d,d
2C2C: 09          add  hl,bc
2C2D: 32 1B 12    ld   ($121B),a
2C30: 09          add  hl,bc
2C31: 32 1B 02    ld   ($021B),a
2C34: 09          add  hl,bc
2C35: 83          add  a,e
2C36: 24          inc  h
2C37: 12          ld   (de),a
2C38: 1B          dec  de
2C39: 12          ld   (de),a
2C3A: 09          add  hl,bc
2C3B: 02          ld   (bc),a
2C3C: 1B          dec  de
2C3D: A3          and  e
2C3E: 09          add  hl,bc
2C3F: 02          ld   (bc),a
2C40: 1B          dec  de
2C41: 83          add  a,e
2C42: 09          add  hl,bc
2C43: 53          ld   d,e
2C44: 24          inc  h
2C45: 12          ld   (de),a
2C46: 1B          dec  de
2C47: 12          ld   (de),a
2C48: 09          add  hl,bc
2C49: 02          ld   (bc),a
2C4A: 1B          dec  de
2C4B: A3          and  e
2C4C: 09          add  hl,bc
2C4D: 02          ld   (bc),a
2C4E: 1B          dec  de
2C4F: 83          add  a,e
2C50: 09          add  hl,bc
2C51: 53          ld   d,e
2C52: 1B          dec  de
2C53: 12          ld   (de),a
2C54: 09          add  hl,bc
2C55: 02          ld   (bc),a
2C56: 1B          dec  de
2C57: 83          add  a,e
2C58: 09          add  hl,bc
2C59: A3          and  e
2C5A: 1B          dec  de
2C5B: 73          ld   (hl),e
2C5C: 09          add  hl,bc
2C5D: 83          add  a,e
2C5E: 0C          inc  c
2C5F: 02          ld   (bc),a
2C60: 0C          inc  c
2C61: 32 0C 82    ld   ($820C),a
2C64: 24          inc  h
2C65: FF          rst  $38
2C66: 84          add  a,h
2C67: 24          inc  h
2C68: 34          inc  (hl)
2C69: 24          inc  h
2C6A: 84          add  a,h
2C6B: 24          inc  h
2C6C: 34          inc  (hl)
2C6D: 24          inc  h
2C6E: 84          add  a,h
2C6F: 24          inc  h
2C70: 34          inc  (hl)
2C71: 24          inc  h
2C72: 74          ld   (hl),h
2C73: 24          inc  h
2C74: 34          inc  (hl)
2C75: 24          inc  h
2C76: 74          ld   (hl),h
2C77: 24          inc  h
2C78: 34          inc  (hl)
2C79: 24          inc  h
2C7A: 74          ld   (hl),h
2C7B: 24          inc  h
2C7C: 34          inc  (hl)
2C7D: 24          inc  h
2C7E: 74          ld   (hl),h
2C7F: 1B          dec  de
2C80: 34          inc  (hl)
2C81: 09          add  hl,bc
2C82: 54          ld   d,h
2C83: 1B          dec  de
2C84: 74          ld   (hl),h
2C85: 09          add  hl,bc
2C86: 84          add  a,h
2C87: 24          inc  h
2C88: 34          inc  (hl)
2C89: 24          inc  h
2C8A: 13          inc  de
2C8B: 24          inc  h
2C8C: 13          inc  de
2C8D: 24          inc  h
2C8E: 03          inc  bc
2C8F: 24          inc  h
2C90: 03          inc  bc
2C91: 24          inc  h
2C92: A4          and  h
2C93: 24          inc  h
2C94: A4          and  h
2C95: 24          inc  h
2C96: 84          add  a,h
2C97: 24          inc  h
2C98: 84          add  a,h
2C99: 24          inc  h
2C9A: A4          and  h
2C9B: 24          inc  h
2C9C: A4          and  h
2C9D: 24          inc  h
2C9E: 84          add  a,h
2C9F: 1B          dec  de
2CA0: 74          ld   (hl),h
2CA1: 09          add  hl,bc
2CA2: 54          ld   d,h
2CA3: 1B          dec  de
2CA4: 44          ld   b,h
2CA5: 09          add  hl,bc
2CA6: 34          inc  (hl)
2CA7: 1B          dec  de
2CA8: 44          ld   b,h
2CA9: 09          add  hl,bc
2CAA: 54          ld   d,h
2CAB: 1B          dec  de
2CAC: 74          ld   (hl),h
2CAD: 09          add  hl,bc
2CAE: 84          add  a,h
2CAF: 1B          dec  de
2CB0: 34          inc  (hl)
2CB1: 09          add  hl,bc
2CB2: 84          add  a,h
2CB3: 24          inc  h
2CB4: FF          rst  $38
2CB5: 33          inc  sp
2CB6: 3F          ccf
2CB7: 23          inc  hl
2CB8: 09          add  hl,bc
2CB9: 13          inc  de
2CBA: 24          inc  h
2CBB: 03          inc  bc
2CBC: 24          inc  h
2CBD: 33          inc  sp
2CBE: 24          inc  h
2CBF: 13          inc  de
2CC0: 24          inc  h
2CC1: A4          and  h
2CC2: 24          inc  h
2CC3: 74          ld   (hl),h
2CC4: 24          inc  h
2CC5: 34          inc  (hl)
2CC6: 24          inc  h
2CC7: 44          ld   b,h
2CC8: 24          inc  h
2CC9: 54          ld   d,h
2CCA: 24          inc  h
2CCB: 74          ld   (hl),h
2CCC: 24          inc  h
2CCD: A4          and  h
2CCE: 24          inc  h
2CCF: 84          add  a,h
2CD0: 1B          dec  de
2CD1: 74          ld   (hl),h
2CD2: 09          add  hl,bc
2CD3: 84          add  a,h
2CD4: 1B          dec  de
2CD5: 84          add  a,h
2CD6: 09          add  hl,bc
2CD7: A4          and  h
2CD8: 1B          dec  de
2CD9: 03          inc  bc
2CDA: 09          add  hl,bc
2CDB: 13          inc  de
2CDC: 1B          dec  de
2CDD: 13          inc  de
2CDE: 09          add  hl,bc
2CDF: 03          inc  bc
2CE0: 1B          dec  de
2CE1: A3          and  e
2CE2: 09          add  hl,bc
2CE3: 03          inc  bc
2CE4: 1B          dec  de
2CE5: 84          add  a,h
2CE6: 09          add  hl,bc
2CE7: 34          inc  (hl)
2CE8: 24          inc  h
2CE9: A4          and  h
2CEA: 1B          dec  de
2CEB: A4          and  h
2CEC: 09          add  hl,bc
2CED: 84          add  a,h
2CEE: 1B          dec  de
2CEF: 74          ld   (hl),h
2CF0: 09          add  hl,bc
2CF1: 84          add  a,h
2CF2: 1B          dec  de
2CF3: 54          ld   d,h
2CF4: 09          add  hl,bc
2CF5: 04          inc  b
2CF6: 24          inc  h
2CF7: A4          and  h
2CF8: 1B          dec  de
2CF9: A4          and  h
2CFA: 09          add  hl,bc
2CFB: 03          inc  bc
2CFC: 1B          dec  de
2CFD: A4          and  h
2CFE: 09          add  hl,bc
2CFF: 84          add  a,h
2D00: 1B          dec  de
2D01: 74          ld   (hl),h
2D02: 09          add  hl,bc
2D03: 54          ld   d,h
2D04: 1B          dec  de
2D05: 44          ld   b,h
2D06: 09          add  hl,bc
2D07: 34          inc  (hl)
2D08: 1B          dec  de
2D09: 13          inc  de
2D0A: 09          add  hl,bc
2D0B: 03          inc  bc
2D0C: 1B          dec  de
2D0D: A4          and  h
2D0E: 09          add  hl,bc
2D0F: 84          add  a,h
2D10: 24          inc  h
2D11: 83          add  a,e
2D12: 24          inc  h
2D13: FF          rst  $38
2D14: A4          and  h
2D15: 08          ex   af,af'
2D16: 33          inc  sp
2D17: 08          ex   af,af'
2D18: 53          ld   d,e
2D19: 08          ex   af,af'
2D1A: A4          and  h
2D1B: 08          ex   af,af'
2D1C: 33          inc  sp
2D1D: 08          ex   af,af'
2D1E: 53          ld   d,e
2D1F: 08          ex   af,af'
2D20: A3          and  e
2D21: 20 FF       jr   nz,$2D22
2D23: 54          ld   d,h
2D24: 08          ex   af,af'
2D25: A4          and  h
2D26: 08          ex   af,af'
2D27: 03          inc  bc
2D28: 08          ex   af,af'
2D29: 54          ld   d,h
2D2A: 08          ex   af,af'
2D2B: A4          and  h
2D2C: 08          ex   af,af'
2D2D: 03          inc  bc
2D2E: 08          ex   af,af'
2D2F: 53          ld   d,e
2D30: 20 FF       jr   nz,$2D31
2D32: A3          and  e
2D33: 1B          dec  de
2D34: A3          and  e
2D35: 09          add  hl,bc
2D36: A3          and  e
2D37: 0C          inc  c
2D38: 73          ld   (hl),e
2D39: 0C          inc  c
2D3A: A3          and  e
2D3B: 0C          inc  c
2D3C: 02          ld   (bc),a
2D3D: 24          inc  h
2D3E: 22 24 A3    ld   ($A324),hl
2D41: 1B          dec  de
2D42: A3          and  e
2D43: 09          add  hl,bc
2D44: A3          and  e
2D45: 0C          inc  c
2D46: 73          ld   (hl),e
2D47: 0C          inc  c
2D48: A3          and  e
2D49: 0C          inc  c
2D4A: 02          ld   (bc),a
2D4B: 24          inc  h
2D4C: 22 24 A3    ld   ($A324),hl
2D4F: 1B          dec  de
2D50: A3          and  e
2D51: 09          add  hl,bc
2D52: A3          and  e
2D53: 0C          inc  c
2D54: 73          ld   (hl),e
2D55: 0C          inc  c
2D56: A3          and  e
2D57: 0C          inc  c
2D58: 02          ld   (bc),a
2D59: 24          inc  h
2D5A: 22 24 32    ld   ($3224),hl
2D5D: 24          inc  h
2D5E: 52          ld   d,d
2D5F: 24          inc  h
2D60: 22 18 C0    ld   ($C018),hl
2D63: 0C          inc  c
2D64: 22 18 C0    ld   ($C018),hl
2D67: 0C          inc  c
2D68: 22 1B 22    ld   ($221B),hl
2D6B: 09          add  hl,bc
2D6C: 22 0C 12    ld   ($120C),hl
2D6F: 0C          inc  c
2D70: 22 0C 32    ld   ($320C),hl
2D73: 24          inc  h
2D74: 22 24 02    ld   ($0224),hl
2D77: 1B          dec  de
2D78: 02          ld   (bc),a
2D79: 09          add  hl,bc
2D7A: 02          ld   (bc),a
2D7B: 0C          inc  c
2D7C: A3          and  e
2D7D: 0C          inc  c
2D7E: 02          ld   (bc),a
2D7F: 0C          inc  c
2D80: 22 24 A3    ld   ($A324),hl
2D83: 24          inc  h
2D84: 93          sub  e
2D85: 1B          dec  de
2D86: 93          sub  e
2D87: 09          add  hl,bc
2D88: 93          sub  e
2D89: 0C          inc  c
2D8A: A3          and  e
2D8B: 0C          inc  c
2D8C: 93          sub  e
2D8D: 0C          inc  c
2D8E: 73          ld   (hl),e
2D8F: 1B          dec  de
2D90: 73          ld   (hl),e
2D91: 09          add  hl,bc
2D92: 73          ld   (hl),e
2D93: 0C          inc  c
2D94: 93          sub  e
2D95: 0C          inc  c
2D96: 73          ld   (hl),e
2D97: 0C          inc  c
2D98: 63          ld   h,e
2D99: 0C          inc  c
2D9A: 43          ld   b,e
2D9B: 0C          inc  c
2D9C: 63          ld   h,e
2D9D: 0C          inc  c
2D9E: 73          ld   (hl),e
2D9F: 0C          inc  c
2DA0: 63          ld   h,e
2DA1: 0C          inc  c
2DA2: 73          ld   (hl),e
2DA3: 0C          inc  c
2DA4: 93          sub  e
2DA5: 18 C0       jr   $2D67
2DA7: 0C          inc  c
2DA8: A3          and  e
2DA9: 18 C0       jr   $2D6B
2DAB: 0C          inc  c
2DAC: A3          and  e
2DAD: 1B          dec  de
2DAE: A3          and  e
2DAF: 09          add  hl,bc
2DB0: A3          and  e
2DB1: 0C          inc  c
2DB2: 73          ld   (hl),e
2DB3: 0C          inc  c
2DB4: A3          and  e
2DB5: 0C          inc  c
2DB6: 02          ld   (bc),a
2DB7: 24          inc  h
2DB8: 22 24 A3    ld   ($A324),hl
2DBB: 1B          dec  de
2DBC: A3          and  e
2DBD: 09          add  hl,bc
2DBE: A3          and  e
2DBF: 0C          inc  c
2DC0: 73          ld   (hl),e
2DC1: 0C          inc  c
2DC2: A3          and  e
2DC3: 0C          inc  c
2DC4: 02          ld   (bc),a
2DC5: 24          inc  h
2DC6: 22 24 A3    ld   ($A324),hl
2DC9: 1B          dec  de
2DCA: A3          and  e
2DCB: 09          add  hl,bc
2DCC: A3          and  e
2DCD: 0C          inc  c
2DCE: 73          ld   (hl),e
2DCF: 0C          inc  c
2DD0: A3          and  e
2DD1: 0C          inc  c
2DD2: 02          ld   (bc),a
2DD3: 1B          dec  de
2DD4: 32 09 22    ld   ($2209),a
2DD7: 3F          ccf
2DD8: 02          ld   (bc),a
2DD9: 09          add  hl,bc
2DDA: A3          and  e
2DDB: 1B          dec  de
2DDC: 73          ld   (hl),e
2DDD: 09          add  hl,bc
2DDE: 53          ld   d,e
2DDF: 1B          dec  de
2DE0: 53          ld   d,e
2DE1: 09          add  hl,bc
2DE2: 33          inc  sp
2DE3: 24          inc  h
2DE4: 32 24 FF    ld   ($FF24),a
2DE7: 73          ld   (hl),e
2DE8: 1B          dec  de
2DE9: 73          ld   (hl),e
2DEA: 09          add  hl,bc
2DEB: 73          ld   (hl),e
2DEC: 0C          inc  c
2DED: 33          inc  sp
2DEE: 0C          inc  c
2DEF: 73          ld   (hl),e
2DF0: 0C          inc  c
2DF1: 73          ld   (hl),e
2DF2: 24          inc  h
2DF3: A3          and  e
2DF4: 24          inc  h
2DF5: 73          ld   (hl),e
2DF6: 1B          dec  de
2DF7: 73          ld   (hl),e
2DF8: 09          add  hl,bc
2DF9: 73          ld   (hl),e
2DFA: 0C          inc  c
2DFB: 33          inc  sp
2DFC: 0C          inc  c
2DFD: 73          ld   (hl),e
2DFE: 0C          inc  c
2DFF: 73          ld   (hl),e
2E00: 24          inc  h
2E01: A3          and  e
2E02: 24          inc  h
2E03: 73          ld   (hl),e
2E04: 1B          dec  de
2E05: 73          ld   (hl),e
2E06: 09          add  hl,bc
2E07: 73          ld   (hl),e
2E08: 0C          inc  c
2E09: 33          inc  sp
2E0A: 0C          inc  c
2E0B: 73          ld   (hl),e
2E0C: 0C          inc  c
2E0D: 73          ld   (hl),e
2E0E: 24          inc  h
2E0F: A3          and  e
2E10: 24          inc  h
2E11: 02          ld   (bc),a
2E12: 24          inc  h
2E13: 22 24 B3    ld   ($B324),hl
2E16: 18 C0       jr   $2DD8
2E18: 0C          inc  c
2E19: B3          or   e
2E1A: 18 C0       jr   $2DDC
2E1C: 0C          inc  c
2E1D: 53          ld   d,e
2E1E: 48          ld   c,b
2E1F: 53          ld   d,e
2E20: 48          ld   c,b
2E21: 53          ld   d,e
2E22: 48          ld   c,b
2E23: 53          ld   d,e
2E24: 48          ld   c,b
2E25: 53          ld   d,e
2E26: 48          ld   c,b
2E27: 23          inc  hl
2E28: 48          ld   c,b
2E29: 13          inc  de
2E2A: 48          ld   c,b
2E2B: 23          inc  hl
2E2C: 18 C0       jr   $2DEE
2E2E: 0C          inc  c
2E2F: 53          ld   d,e
2E30: 18 C0       jr   $2DF2
2E32: 0C          inc  c
2E33: 73          ld   (hl),e
2E34: 1B          dec  de
2E35: 73          ld   (hl),e
2E36: 09          add  hl,bc
2E37: 73          ld   (hl),e
2E38: 0C          inc  c
2E39: 33          inc  sp
2E3A: 0C          inc  c
2E3B: 73          ld   (hl),e
2E3C: 0C          inc  c
2E3D: 73          ld   (hl),e
2E3E: 24          inc  h
2E3F: A3          and  e
2E40: 24          inc  h
2E41: 73          ld   (hl),e
2E42: 1B          dec  de
2E43: 73          ld   (hl),e
2E44: 09          add  hl,bc
2E45: 73          ld   (hl),e
2E46: 0C          inc  c
2E47: 33          inc  sp
2E48: 0C          inc  c
2E49: 73          ld   (hl),e
2E4A: 0C          inc  c
2E4B: 73          ld   (hl),e
2E4C: 24          inc  h
2E4D: A3          and  e
2E4E: 24          inc  h
2E4F: 73          ld   (hl),e
2E50: 1B          dec  de
2E51: 73          ld   (hl),e
2E52: 09          add  hl,bc
2E53: 73          ld   (hl),e
2E54: 0C          inc  c
2E55: 33          inc  sp
2E56: 0C          inc  c
2E57: 73          ld   (hl),e
2E58: 0C          inc  c
2E59: 83          add  a,e
2E5A: 1B          dec  de
2E5B: 02          ld   (bc),a
2E5C: 09          add  hl,bc
2E5D: A3          and  e
2E5E: 3F          ccf
2E5F: C0          ret  nz
2E60: 09          add  hl,bc
2E61: 73          ld   (hl),e
2E62: 1B          dec  de
2E63: 33          inc  sp
2E64: 09          add  hl,bc
2E65: 23          inc  hl
2E66: 1B          dec  de
2E67: 23          inc  hl
2E68: 09          add  hl,bc
2E69: A4          and  h
2E6A: 24          inc  h
2E6B: A3          and  e
2E6C: 24          inc  h
2E6D: FF          rst  $38
2E6E: 33          inc  sp
2E6F: 1B          dec  de
2E70: 33          inc  sp
2E71: 09          add  hl,bc
2E72: 33          inc  sp
2E73: 0C          inc  c
2E74: A4          and  h
2E75: 0C          inc  c
2E76: 33          inc  sp
2E77: 0C          inc  c
2E78: 53          ld   d,e
2E79: 24          inc  h
2E7A: 73          ld   (hl),e
2E7B: 24          inc  h
2E7C: 33          inc  sp
2E7D: 1B          dec  de
2E7E: 33          inc  sp
2E7F: 09          add  hl,bc
2E80: 33          inc  sp
2E81: 0C          inc  c
2E82: A4          and  h
2E83: 0C          inc  c
2E84: 33          inc  sp
2E85: 0C          inc  c
2E86: 53          ld   d,e
2E87: 24          inc  h
2E88: 73          ld   (hl),e
2E89: 24          inc  h
2E8A: 33          inc  sp
2E8B: 1B          dec  de
2E8C: 33          inc  sp
2E8D: 09          add  hl,bc
2E8E: 33          inc  sp
2E8F: 0C          inc  c
2E90: A4          and  h
2E91: 0C          inc  c
2E92: 33          inc  sp
2E93: 0C          inc  c
2E94: 53          ld   d,e
2E95: 24          inc  h
2E96: 73          ld   (hl),e
2E97: 24          inc  h
2E98: 83          add  a,e
2E99: 24          inc  h
2E9A: A3          and  e
2E9B: 24          inc  h
2E9C: 73          ld   (hl),e
2E9D: 18 C0       jr   $2E5F
2E9F: 0C          inc  c
2EA0: 73          ld   (hl),e
2EA1: 18 C0       jr   $2E63
2EA3: 0C          inc  c
2EA4: 23          inc  hl
2EA5: 48          ld   c,b
2EA6: 23          inc  hl
2EA7: 48          ld   c,b
2EA8: 23          inc  hl
2EA9: 48          ld   c,b
2EAA: 23          inc  hl
2EAB: 48          ld   c,b
2EAC: 03          inc  bc
2EAD: 48          ld   c,b
2EAE: A4          and  h
2EAF: 48          ld   c,b
2EB0: 94          sub  h
2EB1: 48          ld   c,b
2EB2: 94          sub  h
2EB3: 18 C0       jr   $2E75
2EB5: 0C          inc  c
2EB6: 23          inc  hl
2EB7: 18 C0       jr   $2E79
2EB9: 0C          inc  c
2EBA: 33          inc  sp
2EBB: 1B          dec  de
2EBC: 33          inc  sp
2EBD: 09          add  hl,bc
2EBE: 33          inc  sp
2EBF: 0C          inc  c
2EC0: A4          and  h
2EC1: 0C          inc  c
2EC2: 33          inc  sp
2EC3: 0C          inc  c
2EC4: 53          ld   d,e
2EC5: 24          inc  h
2EC6: 73          ld   (hl),e
2EC7: 24          inc  h
2EC8: 33          inc  sp
2EC9: 1B          dec  de
2ECA: 33          inc  sp
2ECB: 09          add  hl,bc
2ECC: 33          inc  sp
2ECD: 0C          inc  c
2ECE: A4          and  h
2ECF: 0C          inc  c
2ED0: 33          inc  sp
2ED1: 0C          inc  c
2ED2: 53          ld   d,e
2ED3: 24          inc  h
2ED4: 23          inc  hl
2ED5: 24          inc  h
2ED6: 33          inc  sp
2ED7: 1B          dec  de
2ED8: 33          inc  sp
2ED9: 09          add  hl,bc
2EDA: 33          inc  sp
2EDB: 0C          inc  c
2EDC: A4          and  h
2EDD: 0C          inc  c
2EDE: 33          inc  sp
2EDF: 0C          inc  c
2EE0: 53          ld   d,e
2EE1: 1B          dec  de
2EE2: 73          ld   (hl),e
2EE3: 09          add  hl,bc
2EE4: 83          add  a,e
2EE5: 3F          ccf
2EE6: C0          ret  nz
2EE7: 09          add  hl,bc
2EE8: 33          inc  sp
2EE9: 1B          dec  de
2EEA: 23          inc  hl
2EEB: 09          add  hl,bc
2EEC: 03          inc  bc
2EED: 1B          dec  de
2EEE: A4          and  h
2EEF: 09          add  hl,bc
2EF0: 74          ld   (hl),h
2EF1: 24          inc  h
2EF2: 73          ld   (hl),e
2EF3: 24          inc  h
2EF4: FF          rst  $38
2EF5: 34          inc  (hl)
2EF6: 1B          dec  de
2EF7: A5          and  l
2EF8: 09          add  hl,bc
2EF9: 34          inc  (hl)
2EFA: 1B          dec  de
2EFB: A5          and  l
2EFC: 09          add  hl,bc
2EFD: 34          inc  (hl)
2EFE: 1B          dec  de
2EFF: A5          and  l
2F00: 09          add  hl,bc
2F01: 54          ld   d,h
2F02: 24          inc  h
2F03: 34          inc  (hl)
2F04: 1B          dec  de
2F05: A5          and  l
2F06: 09          add  hl,bc
2F07: 34          inc  (hl)
2F08: 1B          dec  de
2F09: A5          and  l
2F0A: 09          add  hl,bc
2F0B: 34          inc  (hl)
2F0C: 1B          dec  de
2F0D: A5          and  l
2F0E: 09          add  hl,bc
2F0F: 54          ld   d,h
2F10: 24          inc  h
2F11: 34          inc  (hl)
2F12: 1B          dec  de
2F13: A5          and  l
2F14: 09          add  hl,bc
2F15: 34          inc  (hl)
2F16: 1B          dec  de
2F17: A5          and  l
2F18: 09          add  hl,bc
2F19: 34          inc  (hl)
2F1A: 1B          dec  de
2F1B: A5          and  l
2F1C: 09          add  hl,bc
2F1D: 54          ld   d,h
2F1E: 24          inc  h
2F1F: 34          inc  (hl)
2F20: 24          inc  h
2F21: 54          ld   d,h
2F22: 24          inc  h
2F23: 74          ld   (hl),h
2F24: 24          inc  h
2F25: C0          ret  nz
2F26: 24          inc  h
2F27: A4          and  h
2F28: 48          ld   c,b
2F29: A4          and  h
2F2A: 48          ld   c,b
2F2B: A4          and  h
2F2C: 48          ld   c,b
2F2D: A4          and  h
2F2E: 48          ld   c,b
2F2F: 94          sub  h
2F30: 48          ld   c,b
2F31: 74          ld   (hl),h
2F32: 48          ld   c,b
2F33: 44          ld   b,h
2F34: 48          ld   c,b
2F35: 44          ld   b,h
2F36: 18 C0       jr   $2EF8
2F38: 0C          inc  c
2F39: A4          and  h
2F3A: 18 C0       jr   $2EFC
2F3C: 0C          inc  c
2F3D: 34          inc  (hl)
2F3E: 1B          dec  de
2F3F: A5          and  l
2F40: 09          add  hl,bc
2F41: 34          inc  (hl)
2F42: 1B          dec  de
2F43: A5          and  l
2F44: 09          add  hl,bc
2F45: 34          inc  (hl)
2F46: 1B          dec  de
2F47: A5          and  l
2F48: 09          add  hl,bc
2F49: 54          ld   d,h
2F4A: 24          inc  h
2F4B: 34          inc  (hl)
2F4C: 1B          dec  de
2F4D: A5          and  l
2F4E: 09          add  hl,bc
2F4F: 34          inc  (hl)
2F50: 1B          dec  de
2F51: A5          and  l
2F52: 09          add  hl,bc
2F53: 34          inc  (hl)
2F54: 1B          dec  de
2F55: A5          and  l
2F56: 09          add  hl,bc
2F57: 54          ld   d,h
2F58: 24          inc  h
2F59: 34          inc  (hl)
2F5A: 1B          dec  de
2F5B: A5          and  l
2F5C: 09          add  hl,bc
2F5D: 34          inc  (hl)
2F5E: 1B          dec  de
2F5F: A5          and  l
2F60: 09          add  hl,bc
2F61: 34          inc  (hl)
2F62: 1B          dec  de
2F63: A4          and  h
2F64: 09          add  hl,bc
2F65: 54          ld   d,h
2F66: 3F          ccf
2F67: C0          ret  nz
2F68: 09          add  hl,bc
2F69: 54          ld   d,h
2F6A: 1B          dec  de
2F6B: A5          and  l
2F6C: 09          add  hl,bc
2F6D: 54          ld   d,h
2F6E: 1B          dec  de
2F6F: A5          and  l
2F70: 09          add  hl,bc
2F71: 34          inc  (hl)
2F72: 24          inc  h
2F73: 33          inc  sp
2F74: 24          inc  h
2F75: FF          rst  $38
2F76: FF          rst  $38
2F77: FF          rst  $38
2F78: FF          rst  $38
2F79: FF          rst  $38
2F7A: FF          rst  $38
2F7B: FF          rst  $38
2F7C: FF          rst  $38
2F7D: FF          rst  $38
2F7E: FF          rst  $38
2F7F: FF          rst  $38
2F80: FF          rst  $38
2F81: FF          rst  $38
2F82: FF          rst  $38
2F83: FF          rst  $38
2F84: FF          rst  $38
2F85: FF          rst  $38
2F86: FF          rst  $38
2F87: FF          rst  $38
2F88: FF          rst  $38
2F89: FF          rst  $38
2F8A: FF          rst  $38
2F8B: FF          rst  $38
2F8C: FF          rst  $38
2F8D: FF          rst  $38
2F8E: FF          rst  $38
2F8F: FF          rst  $38
2F90: FF          rst  $38
2F91: FF          rst  $38
2F92: FF          rst  $38
2F93: FF          rst  $38
2F94: FF          rst  $38
2F95: FF          rst  $38
2F96: FF          rst  $38
2F97: FF          rst  $38
2F98: FF          rst  $38
2F99: FF          rst  $38
2F9A: FF          rst  $38
2F9B: FF          rst  $38
2F9C: FF          rst  $38
2F9D: FF          rst  $38
2F9E: FF          rst  $38
2F9F: FF          rst  $38
2FA0: FF          rst  $38
2FA1: FF          rst  $38
2FA2: FF          rst  $38
2FA3: FF          rst  $38
2FA4: FF          rst  $38
2FA5: FF          rst  $38
2FA6: FF          rst  $38
2FA7: FF          rst  $38
2FA8: FF          rst  $38
2FA9: FF          rst  $38
2FAA: FF          rst  $38
2FAB: FF          rst  $38
2FAC: FF          rst  $38
2FAD: FF          rst  $38
2FAE: FF          rst  $38
2FAF: FF          rst  $38
2FB0: FF          rst  $38
2FB1: FF          rst  $38
2FB2: FF          rst  $38
2FB3: FF          rst  $38
2FB4: FF          rst  $38
2FB5: FF          rst  $38
2FB6: FF          rst  $38
2FB7: FF          rst  $38
2FB8: FF          rst  $38
2FB9: FF          rst  $38
2FBA: FF          rst  $38
2FBB: FF          rst  $38
2FBC: FF          rst  $38
2FBD: FF          rst  $38
2FBE: FF          rst  $38
2FBF: FF          rst  $38
2FC0: FF          rst  $38
2FC1: FF          rst  $38
2FC2: FF          rst  $38
2FC3: FF          rst  $38
2FC4: FF          rst  $38
2FC5: FF          rst  $38
2FC6: FF          rst  $38
2FC7: FF          rst  $38
2FC8: FF          rst  $38
2FC9: FF          rst  $38
2FCA: FF          rst  $38
2FCB: FF          rst  $38
2FCC: FF          rst  $38
2FCD: FF          rst  $38
2FCE: FF          rst  $38
2FCF: FF          rst  $38
2FD0: FF          rst  $38
2FD1: FF          rst  $38
2FD2: FF          rst  $38
2FD3: FF          rst  $38
2FD4: FF          rst  $38
2FD5: FF          rst  $38
2FD6: FF          rst  $38
2FD7: FF          rst  $38
2FD8: FF          rst  $38
2FD9: FF          rst  $38
2FDA: FF          rst  $38
2FDB: FF          rst  $38
2FDC: FF          rst  $38
2FDD: FF          rst  $38
2FDE: FF          rst  $38
2FDF: FF          rst  $38
2FE0: FF          rst  $38
2FE1: FF          rst  $38
2FE2: FF          rst  $38
2FE3: FF          rst  $38
2FE4: FF          rst  $38
2FE5: FF          rst  $38
2FE6: FF          rst  $38
2FE7: FF          rst  $38
2FE8: FF          rst  $38
2FE9: FF          rst  $38
2FEA: FF          rst  $38
2FEB: FF          rst  $38
2FEC: FF          rst  $38
2FED: FF          rst  $38
2FEE: FF          rst  $38
2FEF: FF          rst  $38
2FF0: FF          rst  $38
2FF1: FF          rst  $38
2FF2: FF          rst  $38
2FF3: FF          rst  $38
2FF4: FF          rst  $38
2FF5: FF          rst  $38
2FF6: FF          rst  $38
2FF7: FF          rst  $38
2FF8: FF          rst  $38
2FF9: FF          rst  $38
2FFA: FF          rst  $38
2FFB: FF          rst  $38
2FFC: FF          rst  $38
2FFD: FF          rst  $38
2FFE: FF          rst  $38
2FFF: FF          rst  $38
