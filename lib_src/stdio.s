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

\ Label
__bbcc_00000000: 

\ Inc
clc
ldy #&02
lda (&8E),Y
adc #1
ldy #&02
sta (&8E),Y
ldy #&03
lda (&8E),Y
adc #0
ldy #&03
sta (&8E),Y

\ LessThanCmp
lda #00
sta &74
ldy #&03
lda (&8E),Y
cmp #&00
bcc __bbcc_00000006
bne __bbcc_00000007
ldy #&02
lda (&8E),Y
cmp #&00
bcs __bbcc_00000007
__bbcc_00000006: lda #01
sta &74
__bbcc_00000007: 

\ JmpZero
lda &74
bne __bbcc_00000008
jmp __bbcc_00000001
__bbcc_00000008: 

\ CallFunction
jsr getchar
lda &70
sta &76

\ Set

\ Set
lda &72
sta &74
lda &73
sta &75

\ Add
clc
lda &72
adc #&02
sta &72
lda &73
adc #0
sta &73

\ SetAt
lda &74
sta &78
lda &75
sta &79
lda &76
ldy #&00
sta (&78),Y

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
bne __bbcc_00000009
lda #01
sta &74
__bbcc_00000009: 

\ JmpZero
lda &74
bne __bbcc_0000000a
jmp __bbcc_00000002
__bbcc_0000000a: 

\ Jmp
jmp __bbcc_00000001

\ Label
__bbcc_00000002: 

\ Jmp
jmp __bbcc_00000000

\ Label
__bbcc_00000001: 

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
lda &74
pha
lda &75
pha
lda &76
pha
lda &77
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
__bbcc_00000003: 

\ ReadAt
lda &73
sta &75
lda &72
sta &74
ldy #&00
lda (&74),Y
sta &76

\ JmpZero
lda &76
bne __bbcc_0000000b
jmp __bbcc_00000004
__bbcc_0000000b: 

\ ReadAt
lda &73
sta &75
lda &72
sta &74
ldy #&00
lda (&74),Y
sta &76

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
lda &72
adc #&01
sta &72
lda &73
adc #0
sta &73

\ Jmp
jmp __bbcc_00000003

\ Label
__bbcc_00000004: 

\ Return
lda #&00
sta &70
lda #&00
sta &71
pla
sta &75
pla
sta &74
pla
sta &77
pla
sta &76
pla
sta &73
pla
sta &72
rts
