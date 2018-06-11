.export printf
.export gets
.import _bbcc_pusha
.import _bbcc_pulla
.import getchar
.import putchar

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

\ Set
lda &72
sta &74
lda &73
sta &75

\ Label
__bbcc_00000000: 

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
sta &72
ldy #&03
lda (&8E),Y
sbc #&00
ldy #&02
lda (&8E),Y
cmp #&00
bvc __bbcc_00000008
eor #&80
__bbcc_00000008: bmi __bbcc_00000007
lda #01
sta &72
__bbcc_00000007: 

\ JmpZero
lda &72
bne __bbcc_00000009
jmp __bbcc_00000001
__bbcc_00000009: 

\ CallFunction
jsr getchar
lda &70
sta &72

\ Set
lda &74
sta &72
lda &75
sta &73

\ Add
clc
lda &74
adc #&01
sta &74
lda &75
adc #0
sta &75

\ SetAt
lda &72
sta &76
lda &73
sta &77
lda &72
ldy #&00
sta (&76),Y

\ ReadAt
lda &73
sta &77
lda &72
sta &76
ldy #&00
lda (&76),Y
sta &78

\ EqualCmp
lda #00
sta &72
lda &78
cmp #&0A
bne __bbcc_0000000a
lda #01
sta &72
__bbcc_0000000a: 

\ JmpZero
lda &72
bne __bbcc_0000000b
jmp __bbcc_00000002
__bbcc_0000000b: 

\ Jmp
jmp __bbcc_00000001

\ Label
__bbcc_00000002: 

\ Jmp
jmp __bbcc_00000000

\ Label
__bbcc_00000001: 

\ Set
lda #&00
sta &72

\ SetAt
lda &74
sta &76
lda &75
sta &77
lda &72
ldy #&00
sta (&76),Y

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
sta &75
pla
sta &74
pla
sta &77
pla
sta &76
pla
sta &79
pla
sta &78
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
sta &74
lda &73
adc #&00
sta &75

\ Set
lda &74
sta &72
lda &75
sta &73

\ Set
lda &72
sta &74
lda &73
sta &75

\ Set
ldy #&00
lda (&8E),Y
sta &72
ldy #&01
lda (&8E),Y
sta &73

\ Set
lda &72
sta &76
lda &73
sta &77

\ Label
__bbcc_00000003: 

\ ReadAt
lda &77
sta &73
lda &76
sta &72
ldy #&00
lda (&72),Y
sta &78

\ Set
lda &78
sta &72

\ JmpZero
lda &72
bne __bbcc_0000000c
jmp __bbcc_00000004
__bbcc_0000000c: 

\ EqualCmp
lda #00
sta &78
lda &72
cmp #&25
bne __bbcc_0000000d
lda #01
sta &78
__bbcc_0000000d: 

\ JmpZero
lda &78
bne __bbcc_0000000e
jmp __bbcc_00000005
__bbcc_0000000e: 

\ Add
clc
lda &76
adc #&01
sta &76
lda &77
adc #0
sta &77

\ ReadAt
lda &77
sta &79
lda &76
sta &78
ldy #&00
lda (&78),Y
sta &7A

\ Set
lda &7A
sta &72

\ EqualCmp
lda #00
sta &78
lda &72
cmp #&73
bne __bbcc_0000000f
lda #01
sta &78
__bbcc_0000000f: 

\ JmpZero
lda &78
bne __bbcc_00000010
jmp __bbcc_00000006
__bbcc_00000010: 

\ Set
lda &74
sta &78
lda &75
sta &79

\ Set
lda &78
sta &7A
lda &79
sta &7B

\ Set
lda &7A
sta &78
lda &7B
sta &79

\ Add
clc
lda &74
adc #&02
sta &7A
lda &75
adc #&00
sta &7B

\ Set
lda &7A
sta &74
lda &7B
sta &75

\ Set
lda &78
sta &74
lda &79
sta &75

\ CallFunction
lda &75
jsr _bbcc_pusha
lda &74
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
jmp __bbcc_00000003

\ Label
__bbcc_00000006: 

\ Label
__bbcc_00000005: 

\ CallFunction
lda &72
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
lda &76
adc #&01
sta &76
lda &77
adc #0
sta &77

\ Jmp
jmp __bbcc_00000003

\ Label
__bbcc_00000004: 

\ Return
pla
sta &73
pla
sta &72
pla
sta &75
pla
sta &74
pla
sta &77
pla
sta &76
pla
sta &79
pla
sta &78
pla
sta &7B
pla
sta &7A
rts
