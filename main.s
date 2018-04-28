.export _start
.export __main
.export __a
.import __getchar

\ Routines
_bbcc_pusha: pha
lda &8E
bne _bbcc_pusha_1
dec &8F
_bbcc_pusha_1: 
dec &8E
pla
ldy #00
sta (&8E),Y
rts
_bbcc_pulla: ldy #0
lda (&8E),Y
inc &8E
beq _bbcc_pulla_1
rts
_bbcc_pulla_1: 
inc &8F
rts

\ Function
_start: 

\ Set
lda #&00
sta &8E
lda #&18
sta &8F

\ CallFunction
jsr __main
lda &70
sta &72

\ Return
lda &72
sta &70
rts

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

\ CallFunction
jsr __getchar

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

\ Add
clc
lda &74
adc &72
sta &70
lda &75
adc &73
sta &71

\ Return
pla
sta &73
pla
sta &72
pla
sta &75
pla
sta &74
rts
