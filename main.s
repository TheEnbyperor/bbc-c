__bbcc_00000000: .byte &00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00
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
lda #&04
sta &72
lda #&01
sta &70
lda #&00
sta &71
lda #0
sta &74
sta &75
ldx #&10
__bbcc_00000001: 
lsr &71
ror &70
bcc __bbcc_00000002
clc
lda &72
adc &74
sta &74
lda #0
adc &75
sta &75
__bbcc_00000002: clc
asl &72
dex
bne __bbcc_00000001

\ Add
clc
lda <(__bbcc_00000000)
adc &74
sta &70
lda >(__bbcc_00000000)
adc &75
sta &71

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
sta &75
pla
sta &74
rts
