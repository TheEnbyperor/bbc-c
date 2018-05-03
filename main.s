.export __buf
.export __main
.import _bbcc_pusha
.import _bbcc_pulla

\ Function
__main: 
lda &72
pha
lda &73
pha
lda &74
pha
lda &75
pha

\ Mult
lda #&01
sta &72
lda #&00
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
lda #0
adc &75
sta &75
__bbcc_00000001: clc
asl &72
dex
bne __bbcc_00000000

\ Add
clc
lda &1000
adc &74
sta &70
lda &1001
adc &75
sta &71

\ ReadAt
lda &71
sta &73
lda &70
sta &72
ldy #&00
lda (&72),Y
sta &74

\ Return
lda &74
sta &70
pla
sta &73
pla
sta &72
pla
sta &75
pla
sta &74
rts
