.export fgets
.import _bbcc_pusha
.import _bbcc_pulla
.import getchar

\ Function
fgets: 
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

\ LessThanCmp
lda #00
sta &74
lda &73
ldy #&03
cmp (&8E),Y
bcc __bbcc_00000003
bne __bbcc_00000004
lda &72
ldy #&02
cmp (&8E),Y
bcs __bbcc_00000004
__bbcc_00000003: lda #01
sta &75
__bbcc_00000004: 

\ JmpZero
lda &74
bne __bbcc_00000005
jmp __bbcc_00000001
__bbcc_00000005: 

\ CallFunction
jsr getchar
lda &70
sta &72

\ Set

\ SetAt
ldy #&00
lda (&8E),Y
sta &70
ldy #&01
lda (&8E),Y
sta &71
lda &72
ldy #&00
sta (&70),Y

\ Add
clc
ldy #&00
lda (&8E),Y
adc #&02
ldy #&00
sta (&8E),Y
ldy #&01
lda (&8E),Y
adc #0
ldy #&01
sta (&8E),Y

\ EqualCmp
lda #00
sta &70
lda &72
cmp #&0A
bne __bbcc_00000006
lda #01
sta &70
__bbcc_00000006: 

\ JmpZero
lda &70
bne __bbcc_00000007
jmp __bbcc_00000002
__bbcc_00000007: 

\ Jmp
jmp __bbcc_00000001

\ Label
__bbcc_00000002: 

\ Jmp
jmp __bbcc_00000000

\ Label
__bbcc_00000001: 

\ SetAt
ldy #&00
lda (&8E),Y
sta &70
ldy #&01
lda (&8E),Y
sta &71
lda #&00
ldy #&00
sta (&70),Y
lda #&00
ldy #&01
sta (&70),Y

\ Return
ldy #&00
lda (&8E),Y
sta &70
ldy #&01
lda (&8E),Y
sta &71
pla
sta &75
pla
sta &74
pla
sta &73
pla
sta &72
rts
