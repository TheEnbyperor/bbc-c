.export main
.import _bbcc_pusha
.import _bbcc_pulla
.import printf
__bbcc_00000000: .byte &48,&65,&6C,&6C,&6F,&2C,&20,&77,&6F,&72,&6C,&64,&21,&0A,&00

\ Function
main: 
lda &74
pha
lda &75
pha

\ AddrOf
lda #0(__bbcc_00000000)
sta &75
lda #1(__bbcc_00000000)
sta &74

\ Set

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

\ Return
lda #&00
sta &70
lda #&00
sta &71
pla
sta &75
pla
sta &74
rts
