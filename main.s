.export __main
.import _bbcc_pusha
.import _bbcc_pulla
.import __getchar
.import __putchar

\ Function
__main: 
lda &74
pha
lda &75
pha
lda &72
pha
lda &73
pha

\ CallFunction
jsr __getchar
lda &70
sta &72

\ CallFunction
lda #&61
jsr _bbcc_pusha
lda #&00
jsr _bbcc_pusha
jsr __putchar
clc
lda &8E
adc #&02
sta &8E
lda &8F
adc #&00
sta &8F

\ Mult
lda #&03
sta &72
lda #&00
sta &73
lda #&0A
sta &70
lda #&00
sta &71
lda #0
sta &74
sta &75
ldx #&10
__bbcc_00000000: 
lsr &71
ror &70
bcc __bbcc_00000001
clc
lda &72
adc &74
sta &74
lda &73
adc &75
sta &75
__bbcc_00000001: clc
asl &72
rol &73
dex
bne __bbcc_00000000

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
sta &75
pla
sta &74
rts
