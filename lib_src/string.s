.export strlen
.export strrev
.import _bbcc_pusha
.import _bbcc_pulla

\ Function
strlen: 
lda &76
pha
lda &77
pha
lda &78
pha
lda &79
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
lda #&00
sta &72
lda #&00
sta &73

\ Label
__bbcc_00000000: 

\ Set
ldy #&00
lda (&8E),Y
sta &74
ldy #&01
lda (&8E),Y
sta &75

\ Add
clc
ldy #&00
lda (&8E),Y
adc #&01
ldy #&00
sta (&8E),Y
ldy #&01
lda (&8E),Y
adc #0
ldy #&01
sta (&8E),Y

\ ReadAt
lda &75
sta &77
lda &74
sta &76
ldy #&00
lda (&76),Y
sta &78

\ NotEqualCmp
lda #00
sta &74
lda &78
cmp #&00
beq __bbcc_00000004
lda #01
sta &74
__bbcc_00000004: 

\ JmpZero
lda &74
bne __bbcc_00000005
jmp __bbcc_00000001
__bbcc_00000005: 

\ Inc
inc &72
bne __bbcc_00000006
inc &73
__bbcc_00000006: 

\ Jmp
jmp __bbcc_00000000

\ Label
__bbcc_00000001: 

\ Return
lda &72
sta &70
lda &73
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
sta &79
pla
sta &78
pla
sta &77
pla
sta &76
rts

\ Function
strrev: 
lda &76
pha
lda &77
pha
lda &78
pha
lda &79
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
lda #&00
sta &72
lda #&00
sta &73

\ Set
ldy #&00
lda (&8E),Y
sta &74
ldy #&01
lda (&8E),Y
sta &75

\ CallFunction
lda &75
jsr _bbcc_pusha
lda &74
jsr _bbcc_pusha
jsr strlen
clc
lda &8E
adc #&02
sta &8E
lda &8F
adc #&00
sta &8F

\ Sub
sec
lda &70
sbc #&01
sta &74
lda &71
sbc #&00
sta &75

\ Set
lda &74
sta &70
lda &75
sta &71

\ Label
__bbcc_00000002: 

\ LessThanCmp
lda #00
sta &74
lda &73
sbc &71
lda &72
cmp &70
bvc __bbcc_00000008
eor #&80
__bbcc_00000008: bmi __bbcc_00000007
lda #01
sta &74
__bbcc_00000007: 

\ JmpZero
lda &74
bne __bbcc_00000009
jmp __bbcc_00000003
__bbcc_00000009: 

\ Mult
lda #&01
sta &76
lda &72
sta &74
lda &73
sta &75
lda #0
sta &78
sta &79
ldx #&10
__bbcc_0000000a: 
lsr &75
ror &74
bcc __bbcc_0000000b
clc
lda &76
adc &78
sta &78
lda #0
adc &79
sta &79
__bbcc_0000000b: clc
asl &76
dex
bne __bbcc_0000000a

\ Add
clc
ldy #&00
lda (&8E),Y
adc &78
sta &74
ldy #&01
lda (&8E),Y
adc &79
sta &75

\ ReadAt
lda &75
sta &77
lda &74
sta &76
ldy #&00
lda (&76),Y
sta &78

\ Set
lda &78
sta &74

\ Mult
lda #&01
sta &76
lda &70
sta &74
lda &71
sta &75
lda #0
sta &78
sta &79
ldx #&10
__bbcc_0000000c: 
lsr &75
ror &74
bcc __bbcc_0000000d
clc
lda &76
adc &78
sta &78
lda #0
adc &79
sta &79
__bbcc_0000000d: clc
asl &76
dex
bne __bbcc_0000000c

\ Add
clc
ldy #&00
lda (&8E),Y
adc &78
sta &74
ldy #&01
lda (&8E),Y
adc &79
sta &75

\ ReadAt
lda &75
sta &77
lda &74
sta &76
ldy #&00
lda (&76),Y
sta &78

\ Mult
lda #&01
sta &76
lda &72
sta &74
lda &73
sta &75
lda #0
sta &78
sta &79
ldx #&10
__bbcc_0000000e: 
lsr &75
ror &74
bcc __bbcc_0000000f
clc
lda &76
adc &78
sta &78
lda #0
adc &79
sta &79
__bbcc_0000000f: clc
asl &76
dex
bne __bbcc_0000000e

\ Add
clc
ldy #&00
lda (&8E),Y
adc &78
sta &74
ldy #&01
lda (&8E),Y
adc &79
sta &75

\ SetAt
lda &74
sta &76
lda &75
sta &77
lda &78
ldy #&00
sta (&76),Y

\ Mult
lda #&01
sta &76
lda &70
sta &74
lda &71
sta &75
lda #0
sta &78
sta &79
ldx #&10
__bbcc_00000010: 
lsr &75
ror &74
bcc __bbcc_00000011
clc
lda &76
adc &78
sta &78
lda #0
adc &79
sta &79
__bbcc_00000011: clc
asl &76
dex
bne __bbcc_00000010

\ Add
clc
ldy #&00
lda (&8E),Y
adc &78
sta &74
ldy #&01
lda (&8E),Y
adc &79
sta &75

\ SetAt
lda &74
sta &76
lda &75
sta &77
lda &74
ldy #&00
sta (&76),Y

\ Set
lda &72
sta &74
lda &73
sta &75

\ Inc
inc &72
bne __bbcc_00000012
inc &73
__bbcc_00000012: 

\ Set
lda &70
sta &72
lda &71
sta &73

\ Dec
lda &70
bne __bbcc_00000013
dec &71
__bbcc_00000013: 
dec &70

\ Jmp
jmp __bbcc_00000002

\ Label
__bbcc_00000003: 

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
sta &79
pla
sta &78
pla
sta &77
pla
sta &76
rts
