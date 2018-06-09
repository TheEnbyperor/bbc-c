__bbcc_00000000: .byte &00,&00,&00,&00,&00
.export out
.export main
.import _bbcc_pusha
.import _bbcc_pulla
.import itoa
.import printf
__bbcc_00000001: .byte &25,&73,&0A,&00

\ Function
main: 
lda &72
pha
lda &73
pha
lda &76
pha
lda &77
pha
lda &74
pha
lda &75
pha

\ AddrOf
lda #0(__bbcc_00000000)
sta &74
lda #1(__bbcc_00000000)
sta &75

\ Set
lda &74
sta &76
lda &75
sta &77

\ CallFunction
lda #&00
jsr _bbcc_pusha
lda #&2A
jsr _bbcc_pusha
lda &77
jsr _bbcc_pusha
lda &76
jsr _bbcc_pusha
jsr itoa
clc
lda &8E
adc #&04
sta &8E
lda &8F
adc #&00
sta &8F

\ AddrOf
lda #0(__bbcc_00000001)
sta &72
lda #1(__bbcc_00000001)
sta &73

\ Set
lda &72
sta &74
lda &73
sta &75

\ AddrOf
lda #0(__bbcc_00000000)
sta &72
lda #1(__bbcc_00000000)
sta &73

\ CallFunction
lda &75
jsr _bbcc_pusha
lda &74
jsr _bbcc_pusha
lda &73
jsr _bbcc_pusha
lda &72
jsr _bbcc_pusha
jsr printf
clc
lda &8E
adc #&04
sta &8E
lda &8F
adc #&00
sta &8F

\ Return
lda #&00
sta &70
lda #&00
sta &71
pla
sta &77
pla
sta &76
pla
sta &75
pla
sta &74
pla
sta &73
pla
sta &72
rts
