.import _bbcc_pusha
.import _bbcc_pulla
.export strlen
.export strrev

\ Function: strlen
strlen: 
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

\ Set
lda #&00
sta &72
lda #&00
sta &73

\ Label
__bbcc_00000000: 

\ Set
ldy #&00
lda (&8C),Y
sta &70
ldy #&01
lda (&8C),Y
sta &71

\ Inc
clc
ldy #&00
lda (&8C),Y
adc #1
ldy #&00
sta (&8C),Y
ldy #&01
lda (&8C),Y
adc #0
ldy #&01
sta (&8C),Y

\ ReadAt
ldy #&00
lda (&70),Y
sta &70

\ NotEqualCmp
lda #00
sta &70
lda &70
cmp #&00
beq __bbcc_00000005
lda #01
sta &70
__bbcc_00000005: 

\ JmpZero
lda &70
bne __bbcc_00000006
jmp __bbcc_00000001
__bbcc_00000006: 

\ Inc
inc &72
bne __bbcc_00000007
inc &73
__bbcc_00000007: 

\ Jmp
jmp __bbcc_00000000

\ Label
__bbcc_00000001: 

\ Return
lda &72
sta &70
lda &73
sta &71
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

\ Function: strrev
strrev: 
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
lda &78
jsr _bbcc_pusha
lda &79
jsr _bbcc_pusha

\ Set
lda #&00
sta &78
lda #&00
sta &79

\ Set
ldy #&00
lda (&8C),Y
sta &70
ldy #&01
lda (&8C),Y
sta &71

\ CallFunction
lda &71
jsr _bbcc_pusha
lda &70
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
sta &70
lda &71
sbc #&00
sta &71

\ Set
lda &70
sta &76
lda &71
sta &77

\ Label
__bbcc_00000002: 

\ LessThanCmp
lda #00
sta &70
lda &78
cmp &76
lda &79
sbc &77
bvc __bbcc_00000009
eor #&80
__bbcc_00000009: bpl __bbcc_00000008
lda #01
sta &70
__bbcc_00000008: 

\ JmpZero
lda &70
bne __bbcc_0000000a
jmp __bbcc_00000003
__bbcc_0000000a: 

\ Add
clc
ldy #&00
lda (&8C),Y
adc &78
sta &70
ldy #&01
lda (&8C),Y
adc &79
sta &71

\ ReadAt
ldy #&00
lda (&70),Y
sta &70

\ Set
lda &70
sta &74

\ Add
clc
ldy #&00
lda (&8C),Y
adc &76
sta &70
ldy #&01
lda (&8C),Y
adc &77
sta &71

\ ReadAt
ldy #&00
lda (&70),Y
sta &72

\ Add
clc
ldy #&00
lda (&8C),Y
adc &78
sta &70
ldy #&01
lda (&8C),Y
adc &79
sta &71

\ SetAt
lda &72
ldy #&00
sta (&70),Y

\ Add
clc
ldy #&00
lda (&8C),Y
adc &76
sta &70
ldy #&01
lda (&8C),Y
adc &77
sta &71

\ SetAt
lda &74
ldy #&00
sta (&70),Y

\ Inc
inc &78
bne __bbcc_0000000b
inc &79
__bbcc_0000000b: 

\ Dec
lda &76
bne __bbcc_0000000c
dec &77
__bbcc_0000000c: 
dec &76

\ Jmp
jmp __bbcc_00000002

\ Label
__bbcc_00000003: 

\ Return
jsr _bbcc_pulla
sta &79
jsr _bbcc_pulla
sta &78
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
