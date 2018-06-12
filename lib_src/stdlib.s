.export itoa
.import _bbcc_pusha
.import _bbcc_pulla
.import strrev

\ Function
itoa: 
lda &7A
pha
lda &7B
pha
lda &74
pha
lda &75
pha
lda &76
pha
lda &77
pha
lda &78
pha
lda &79
pha
lda &72
pha
lda &73
pha

\ Set
lda #&00
sta &72
lda #&00
sta &73

\ Label
__bbcc_00000000: 

\ Mod
ldy #&00
lda (&8E),Y
sta &76
ldy #&01
lda (&8E),Y
sta &77
lda #&0A
sta &74
lda #&00
sta &75
lda #0
sta &78
sta &79
ldx #&10
__bbcc_00000002: 
asl &76
rol &77
rol &78
rol &79
sec
lda &78
sbc &74
pha
lda &79
sbc &75
bcc __bbcc_00000003
sta &79
pla
sta &78
inc &76
jmp __bbcc_00000004
__bbcc_00000003: 
pla
__bbcc_00000004: dex
bne __bbcc_00000002

\ Add
clc
lda &78
adc #&30
sta &74
lda &79
adc #&00
sta &75

\ Set
lda &72
sta &76
lda &73
sta &77

\ Inc
inc &72
bne __bbcc_00000005
inc &73
__bbcc_00000005: 

\ Add
clc
ldy #&02
lda (&8E),Y
adc &76
sta &78
ldy #&03
lda (&8E),Y
adc &77
sta &79

\ Set
lda &74
sta &76

\ SetAt
lda &78
sta &74
lda &79
sta &75
lda &76
ldy #&00
sta (&74),Y

\ Div
ldy #&00
lda (&8E),Y
sta &78
ldy #&01
lda (&8E),Y
sta &79
lda #&0A
sta &76
lda #&00
sta &77
lda #0
sta &74
sta &75
ldx #&10
__bbcc_00000006: 
asl &78
rol &79
rol &74
rol &75
sec
lda &74
sbc &76
pha
lda &75
sbc &77
bcc __bbcc_00000007
sta &75
pla
sta &74
inc &78
jmp __bbcc_00000008
__bbcc_00000007: 
pla
__bbcc_00000008: dex
bne __bbcc_00000006
lda &78
sta &7A
lda &79
sta &7B

\ Set
lda &7A
ldy #&00
sta (&8E),Y
lda &7B
ldy #&01
sta (&8E),Y

\ MoreThanCmp
lda #00
sta &74
clc
ldy #&00
lda (&8E),Y
sbc #&00
ldy #&01
lda (&8E),Y
sbc #&00
bvc __bbcc_0000000a
eor #&80
__bbcc_0000000a: bmi __bbcc_00000009
lda #01
sta &74
__bbcc_00000009: 

\ JmpZero
lda &74
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
lda (&8E),Y
adc &72
sta &74
ldy #&03
lda (&8E),Y
adc &73
sta &75

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

\ Set
ldy #&02
lda (&8E),Y
sta &72
ldy #&03
lda (&8E),Y
sta &73

\ CallFunction
lda &73
jsr _bbcc_pusha
lda &72
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
pla
sta &73
pla
sta &72
pla
sta &79
pla
sta &78
pla
sta &77
pla
sta &76
pla
sta &75
pla
sta &74
pla
sta &7B
pla
sta &7A
rts
