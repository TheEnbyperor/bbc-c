.export printf
.export isupper
.export gets
.import _bbcc_pusha
.import _bbcc_pulla
.import getchar
.import putchar

\ Function
isupper: 
lda &74
pha
lda &75
pha
lda &72
pha
lda &73
pha

\ Set
lda #&01
sta &72

\ MoreEqualCmp
lda #00
sta &74
ldy #&00
lda (&8E),Y
cmp #&41
bcc __bbcc_0000000a
__bbcc_00000009: lda #01
sta &74
__bbcc_0000000a: 

\ JmpZero
lda &74
bne __bbcc_0000000b
jmp __bbcc_00000000
__bbcc_0000000b: 

\ LessEqualCmp
lda #00
sta &74
ldy #&00
lda (&8E),Y
cmp #&5A
bcc __bbcc_0000000c
bne __bbcc_0000000d
__bbcc_0000000c: lda #01
sta &74
__bbcc_0000000d: 

\ JmpZero
lda &74
bne __bbcc_0000000e
jmp __bbcc_00000000
__bbcc_0000000e: 

\ Jmp
jmp __bbcc_00000001

\ Label
__bbcc_00000000: 

\ Set
lda #&00
sta &72

\ Label
__bbcc_00000001: 

\ Return
lda &72
sta &70
pla
sta &75
pla
sta &74
pla
sta &73
pla
sta &72
rts

\ Function
gets: 
lda &78
pha
lda &79
pha
lda &76
pha
lda &77
pha
lda &74
pha
lda &75
pha
lda &72
pha
lda &73
pha

\ Set
ldy #&00
lda (&8E),Y
sta &72
ldy #&01
lda (&8E),Y
sta &73

\ Label
__bbcc_00000002: 

\ Dec
sec
ldy #&02
lda (&8E),Y
sbc #1
ldy #&02
sta (&8E),Y
ldy #&03
lda (&8E),Y
sbc #0
ldy #&03
sta (&8E),Y

\ LessThanCmp
lda #00
sta &74
ldy #&03
lda (&8E),Y
cmp #&00
bcc __bbcc_0000000f
bne __bbcc_00000010
ldy #&02
lda (&8E),Y
cmp #&00
bcs __bbcc_00000010
__bbcc_0000000f: lda #01
sta &74
__bbcc_00000010: 

\ JmpZero
lda &74
bne __bbcc_00000011
jmp __bbcc_00000003
__bbcc_00000011: 

\ CallFunction
jsr getchar
lda &70
sta &74

\ Set
lda &72
sta &74
lda &73
sta &75

\ Add
clc
lda &72
adc #&01
sta &72
lda &73
adc #0
sta &73

\ SetAt
lda &74
sta &76
lda &75
sta &77
lda &74
ldy #&00
sta (&76),Y

\ ReadAt
lda &75
sta &77
lda &74
sta &76
ldy #&00
lda (&76),Y
sta &78

\ EqualCmp
lda #00
sta &74
lda &78
cmp #&0A
bne __bbcc_00000012
lda #01
sta &74
__bbcc_00000012: 

\ JmpZero
lda &74
bne __bbcc_00000013
jmp __bbcc_00000004
__bbcc_00000013: 

\ Jmp
jmp __bbcc_00000003

\ Label
__bbcc_00000004: 

\ Jmp
jmp __bbcc_00000002

\ Label
__bbcc_00000003: 

\ SetAt
lda &72
sta &74
lda &73
sta &75
lda #&00
ldy #&00
sta (&74),Y
lda #&00
ldy #&01
sta (&74),Y

\ Return
ldy #&00
lda (&8E),Y
sta &70
ldy #&01
lda (&8E),Y
sta &71
pla
sta &73
pla
sta &72
pla
sta &77
pla
sta &76
pla
sta &79
pla
sta &78
pla
sta &75
pla
sta &74
rts

\ Function
printf: 
lda &7A
pha
lda &7B
pha
lda &78
pha
lda &79
pha
lda &76
pha
lda &77
pha
lda &74
pha
lda &75
pha
lda &72
pha
lda &73
pha

\ AddrOf
clc
lda &8E
adc #&00
sta &72
lda &8F
adc #&00
sta &73

\ Add
clc
lda &72
adc #&02
sta &72
lda &73
adc #&00
sta &73

\ Set

\ Set
ldy #&00
lda (&8E),Y
sta &74
ldy #&01
lda (&8E),Y
sta &75

\ Label
__bbcc_00000005: 

\ ReadAt
lda &75
sta &77
lda &74
sta &76
ldy #&00
lda (&76),Y
sta &76

\ Set

\ JmpZero
lda &76
bne __bbcc_00000014
jmp __bbcc_00000006
__bbcc_00000014: 

\ EqualCmp
lda #00
sta &78
lda &76
cmp #&25
bne __bbcc_00000015
lda #01
sta &78
__bbcc_00000015: 

\ JmpZero
lda &78
bne __bbcc_00000016
jmp __bbcc_00000007
__bbcc_00000016: 

\ Add
clc
lda &74
adc #&01
sta &74
lda &75
adc #0
sta &75

\ ReadAt
lda &75
sta &79
lda &74
sta &78
ldy #&00
lda (&78),Y
sta &76

\ Set

\ EqualCmp
lda #00
sta &78
lda &76
cmp #&73
bne __bbcc_00000017
lda #01
sta &78
__bbcc_00000017: 

\ JmpZero
lda &78
bne __bbcc_00000018
jmp __bbcc_00000008
__bbcc_00000018: 

\ Set
lda &72
sta &7A
lda &73
sta &7B

\ Set

\ Add
clc
lda &72
adc #&02
sta &72
lda &73
adc #&00
sta &73

\ Set

\ Set
lda &7A
sta &72
lda &7B
sta &73

\ CallFunction
lda &73
jsr _bbcc_pusha
lda &72
jsr _bbcc_pusha
jsr printf
clc
lda &8E
adc #&02
sta &8E
lda &8F
adc #&00
sta &8F
lda &70
sta &78
lda &71
sta &79

\ Jmp
jmp __bbcc_00000005

\ Label
__bbcc_00000008: 

\ Label
__bbcc_00000007: 

\ CallFunction
lda &76
jsr _bbcc_pusha
jsr putchar
clc
lda &8E
adc #&01
sta &8E
lda &8F
adc #&00
sta &8F

\ Add
clc
lda &74
adc #&01
sta &74
lda &75
adc #0
sta &75

\ Jmp
jmp __bbcc_00000005

\ Label
__bbcc_00000006: 

\ Return
pla
sta &77
pla
sta &76
pla
sta &7B
pla
sta &7A
pla
sta &73
pla
sta &72
pla
sta &79
pla
sta &78
pla
sta &75
pla
sta &74
rts
