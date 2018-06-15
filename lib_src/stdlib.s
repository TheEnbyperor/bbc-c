.import _bbcc_pusha
.import _bbcc_pulla
.import strlen
.import strrev
.export itoa

\ Function: itoa
itoa: 
lda &8C
jsr _bbcc_pusha
lda &8D
jsr _bbcc_pusha
lda &8E
sta &8C
lda &8F
sta &8D
lda &72
jsr _bbcc_pusha
lda &73
jsr _bbcc_pusha
lda &74
jsr _bbcc_pusha
lda &75
jsr _bbcc_pusha
lda &76
jsr _bbcc_pusha
lda &77
jsr _bbcc_pusha

\ Set
lda #&00
sta &76
lda #&00
sta &77

\ Label
__bbcc_00000000: 

\ Mod
ldy #&00
lda (&8C),Y
sta &70
ldy #&01
lda (&8C),Y
sta &71
lda #&0A
sta &70
lda #&00
sta &71
lda #0
sta &70
sta &71
ldx #&10
__bbcc_00000002: 
asl &70
rol &71
rol &70
rol &71
sec
lda &70
sbc &70
pha
lda &71
sbc &71
bcc __bbcc_00000003
sta &71
pla
sta &70
inc &70
jmp __bbcc_00000004
__bbcc_00000003: 
pla
__bbcc_00000004: dex
bne __bbcc_00000002

\ Add
clc
lda &70
adc #&30
sta &74
lda &71
adc #&00
sta &75

\ Set
lda &76
sta &70
lda &77
sta &71

\ Inc
inc &76
bne __bbcc_00000005
inc &77
__bbcc_00000005: 

\ Add
clc
ldy #&02
lda (&8C),Y
adc &70
sta &72
ldy #&03
lda (&8C),Y
adc &71
sta &73

\ Set
lda &74
sta &70

\ SetAt
lda &70
ldy #&00
sta (&72),Y

\ Div
ldy #&00
lda (&8C),Y
sta &70
ldy #&01
lda (&8C),Y
sta &71
lda #&0A
sta &70
lda #&00
sta &71
lda #0
sta &70
sta &71
ldx #&10
__bbcc_00000006: 
asl &70
rol &71
rol &70
rol &71
sec
lda &70
sbc &70
pha
lda &71
sbc &71
bcc __bbcc_00000007
sta &71
pla
sta &70
inc &70
jmp __bbcc_00000008
__bbcc_00000007: 
pla
__bbcc_00000008: dex
bne __bbcc_00000006
lda &70
sta &70
lda &71
sta &71

\ Set
lda &70
ldy #&00
sta (&8C),Y
lda &71
ldy #&01
sta (&8C),Y

\ MoreThanCmp
lda #00
sta &70
clc
ldy #&00
lda (&8C),Y
sbc #&00
ldy #&01
lda (&8C),Y
sbc #&00
bvc __bbcc_0000000a
eor #&80
__bbcc_0000000a: bmi __bbcc_00000009
lda #01
sta &70
__bbcc_00000009: 

\ JmpZero
lda &70
bne __bbcc_0000000b
jmp __bbcc_00000001
__bbcc_0000000b: 

\ Jmp
jmp __bbcc_00000000

\ Label
__bbcc_00000001: 

\ Add
clc
ldy #&02
lda (&8C),Y
adc &76
sta &72
ldy #&03
lda (&8C),Y
adc &77
sta &73

\ Set
lda #&00
sta &70

\ SetAt
lda &70
ldy #&00
sta (&72),Y

\ Set
ldy #&02
lda (&8C),Y
sta &70
ldy #&03
lda (&8C),Y
sta &71

\ CallFunction
lda &71
jsr _bbcc_pusha
lda &70
jsr _bbcc_pusha
jsr strrev
clc
lda &8E
adc #&02
sta &8E
lda &8F
adc #&00
sta &8F

\ Return
jsr _bbcc_pulla
sta &77
jsr _bbcc_pulla
sta &76
jsr _bbcc_pulla
sta &75
jsr _bbcc_pulla
sta &74
jsr _bbcc_pulla
sta &73
jsr _bbcc_pulla
sta &72
lda &8C
sta &8E
lda &8D
sta &8F
jsr _bbcc_pulla
sta &8D
jsr _bbcc_pulla
sta &8C
rts
