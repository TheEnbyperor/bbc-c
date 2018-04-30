.export __strlen
.export __strrev
.import _bbcc_pusha

\ Function
__strlen: 
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

\ JmpZero
lda #&01
bne __bbcc_00000005
lda #&00
bne __bbcc_00000005
jmp __bbcc_00000001
__bbcc_00000005: 

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
__bbcc_00000006: 
lsr &75
ror &74
bcc __bbcc_00000007
clc
lda &76
adc &78
sta &78
lda #0
adc &79
sta &79
__bbcc_00000007: clc
asl &76
dex
bne __bbcc_00000006

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

\ EqualCmp
lda #00
sta &74
lda &78
cmp #&00
bne __bbcc_00000008
lda #01
sta &74
__bbcc_00000008: 

\ JmpZero
lda &74
bne __bbcc_00000009
jmp __bbcc_00000002
__bbcc_00000009: 

\ Add
clc
lda &72
adc #&01
sta &74
lda &73
adc #&00
sta &75

\ Return
lda &74
sta &70
lda &75
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

\ Label
__bbcc_00000002: 

\ Set
lda &72
sta &74
lda &73
sta &75

\ Inc
inc &72
bne __bbcc_0000000a
inc &73
__bbcc_0000000a: 

\ Jmp
jmp __bbcc_00000000

\ Label
__bbcc_00000001: 

\ Return
lda #&00
sta &70
lda #&00
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
__strrev: 
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
lda #&00
sta &72
lda #&00
sta &73

\ Set
lda #&00
sta &74
lda #&00
sta &75

\ Set
lda #&00
sta &76

\ Set
lda #&00
sta &72
lda #&00
sta &73

\ AddrOf
ldy #&00
lda (&8E),Y
sta &77
ldy #&01
lda (&8E),Y
sta &76

\ CallFunction
lda &76
jsr _bbcc_pusha
lda &77
jsr _bbcc_pusha
jsr __strlen
clc
lda &8E
adc #&02
sta &8E
lda &8F
adc #&00
sta &8F

\ Sub
sec
lda #0
sta &76
lda #0
sta &77

\ Set
lda &76
sta &74
lda &77
sta &75

\ Label
__bbcc_00000003: 

\ LessThanCmp
lda #00
sta &70
lda &73
cmp &75
bcc __bbcc_0000000b
bne __bbcc_0000000c
lda &72
cmp &74
bcs __bbcc_0000000c
__bbcc_0000000b: lda #01
sta &71
__bbcc_0000000c: 

\ JmpZero
lda &70
bne __bbcc_0000000d
jmp __bbcc_00000004
__bbcc_0000000d: 

\ Mult
lda #&01
sta &76
lda &72
sta &70
lda &73
sta &71
lda #0
sta &78
sta &79
ldx #&10
__bbcc_0000000e: 
lsr &71
ror &70
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
sta &70
ldy #&01
lda (&8E),Y
adc &79
sta &71

\ ReadAt
lda &71
sta &77
lda &70
sta &76
ldy #&00
lda (&76),Y
sta &78

\ Set
lda &78
sta &76

\ Mult
lda #&01
sta &76
lda &74
sta &70
lda &75
sta &71
lda #0
sta &78
sta &79
ldx #&10
__bbcc_00000010: 
lsr &71
ror &70
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
sta &70
ldy #&01
lda (&8E),Y
adc &79
sta &71

\ ReadAt
lda &71
sta &77
lda &70
sta &76
ldy #&00
lda (&76),Y
sta &78

\ Mult
lda #&01
sta &76
lda &72
sta &70
lda &73
sta &71
lda #0
sta &78
sta &79
ldx #&10
__bbcc_00000012: 
lsr &71
ror &70
bcc __bbcc_00000013
clc
lda &76
adc &78
sta &78
lda #0
adc &79
sta &79
__bbcc_00000013: clc
asl &76
dex
bne __bbcc_00000012

\ Add
clc
ldy #&00
lda (&8E),Y
adc &78
sta &70
ldy #&01
lda (&8E),Y
adc &79
sta &71

\ SetAt
lda &70
sta &76
lda &71
sta &77
lda &78
ldy #&00
sta (&76),Y

\ Mult
lda #&01
sta &76
lda &74
sta &70
lda &75
sta &71
lda #0
sta &78
sta &79
ldx #&10
__bbcc_00000014: 
lsr &71
ror &70
bcc __bbcc_00000015
clc
lda &76
adc &78
sta &78
lda #0
adc &79
sta &79
__bbcc_00000015: clc
asl &76
dex
bne __bbcc_00000014

\ Add
clc
ldy #&00
lda (&8E),Y
adc &78
sta &70
ldy #&01
lda (&8E),Y
adc &79
sta &71

\ SetAt
lda &70
sta &78
lda &71
sta &79
lda &76
ldy #&00
sta (&78),Y

\ Set
lda &72
sta &70
lda &73
sta &71

\ Inc
inc &72
bne __bbcc_00000016
inc &73
__bbcc_00000016: 

\ Set
lda &74
sta &70
lda &75
sta &71

\ Dec
lda &74
bne __bbcc_00000017
dec &75
__bbcc_00000017: 
dec &74

\ Jmp
jmp __bbcc_00000003

\ Label
__bbcc_00000004: 

\ Return
lda #&00
sta &70
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
