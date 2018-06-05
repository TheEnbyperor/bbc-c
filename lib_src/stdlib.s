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
sta &74
lda &73
sta &75

\ Inc
inc &72
bne __bbcc_00000005
inc &73
__bbcc_00000005: 

\ Mult
lda #&01
sta &78
lda &74
sta &76
lda &75
sta &77
lda #0
sta &7A
sta &7B
ldx #&10
__bbcc_00000006: 
lsr &77
ror &76
bcc __bbcc_00000007
clc
lda &78
adc &7A
sta &7A
lda #0
adc &7B
sta &7B
__bbcc_00000007: clc
asl &78
dex
bne __bbcc_00000006

\ Add
clc
ldy #&02
lda (&8E),Y
adc &7A
sta &74
ldy #&03
lda (&8E),Y
adc &7B
sta &75

\ SetAt
lda &74
sta &76
lda &75
sta &77
lda &74
ldy #&00
sta (&76),Y
lda &75
ldy #&01
sta (&76),Y

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
__bbcc_00000008: 
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
bcc __bbcc_00000009
sta &75
pla
sta &74
inc &78
jmp __bbcc_0000000a
__bbcc_00000009: 
pla
__bbcc_0000000a: dex
bne __bbcc_00000008
lda &78
ldy #&00
sta (&8E),Y
lda &79
ldy #&01
sta (&8E),Y

\ Set

\ MoreThanCmp
lda #00
sta &74
ldy #&01
lda (&8E),Y
cmp #&00
bcc __bbcc_0000000c
bne __bbcc_0000000b
ldy #&00
lda (&8E),Y
cmp #&00
beq __bbcc_0000000c
bcc __bbcc_0000000c
__bbcc_0000000b: lda #01
sta &75
__bbcc_0000000c: 

\ JmpZero
lda &74
bne __bbcc_0000000d
jmp __bbcc_00000001
__bbcc_0000000d: 

\ Jmp
jmp __bbcc_00000000

\ Label
__bbcc_00000001: 

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
ldy #&02
lda (&8E),Y
adc &78
sta &72
ldy #&03
lda (&8E),Y
adc &79
sta &73

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

\ AddrOf
clc
lda &8E
adc #&02
sta &74
lda &8F
adc #&00
sta &75

\ Set

\ CallFunction
lda &75
jsr _bbcc_pusha
lda &74
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
lda #&00
sta &70
pla
sta &7B
pla
sta &7A
pla
sta &77
pla
sta &76
pla
sta &79
pla
sta &78
pla
sta &73
pla
sta &72
pla
sta &75
pla
sta &74
rts
