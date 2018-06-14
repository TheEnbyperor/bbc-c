.import _bbcc_pusha
.import _bbcc_pulla
.import putchar
.import getchar
.import printf
.import itoa
.import strlen
.import strrev
.export out
__bbcc_00000000: .byte &00,&00,&00,&00,&00
.export main
main: 

\ Set
lda #&2A
sta &70
lda #&00
sta &71

\ Set

\ Set
lda &70
sta &72
lda &71
sta &73

\ AddrOf
lda #0(__bbcc_00000000)
sta &70
lda #1(__bbcc_00000000)
sta &71

\ Set

\ CallFunction
lda &71
jsr _bbcc_pusha
lda &70
jsr _bbcc_pusha
lda &73
jsr _bbcc_pusha
lda &72
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
lda #0(__bbcc_00000000)
sta &70
lda #1(__bbcc_00000000)
sta &71

\ Set

\ CallFunction
lda &71
jsr _bbcc_pusha
lda &70
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
rts
