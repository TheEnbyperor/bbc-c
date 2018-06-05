.export main
.import _bbcc_pusha
.import _bbcc_pulla
.import printf

\ Function
main: 
lda &72
pha
lda &73
pha
sec
lda &8E
sbc #&0F
sta &8E
lda &8F
sbc #&00
sta &8F

\ Set
ldy #&00
lda (&8E),Y
sta &72
ldy #&01
lda (&8E),Y
sta &73

\ CallFunction
lda &73
jsr _bbcc_pusha
lda &72
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
clc
lda &8E
adc #&0F
sta &8E
lda &8F
adc #&00
sta &8F
pla
sta &73
pla
sta &72
rts
