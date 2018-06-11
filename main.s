__bbcc_00000000: .byte &00,&00,&00,&00,&00
.export out
.export main
.import _bbcc_pusha
.import _bbcc_pulla
.import strrev
.import printf
__bbcc_00000001: .byte &48,&65,&6C,&6C,&6F,&2C,&20,&77,&6F,&72,&6C,&64,&21,&00

\ Function
main: 
lda &76
pha
lda &77
pha
lda &74
pha
lda &75
pha
lda &72
pha
lda &73
pha

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

\ Set
lda &74
sta &72
lda &75
sta &73

\ Set
lda &72
sta &74
lda &73
sta &75

\ CallFunction
lda &75
jsr _bbcc_pusha
lda &74
jsr _bbcc_pusha
jsr strrev
clc
lda &8E
adc #&02
sta &8E
lda &8F
adc #&00
sta &8F

\ Set
lda &72
sta &74
lda &73
sta &75

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
sta &73
pla
sta &72
pla
sta &75
pla
sta &74
pla
sta &77
pla
sta &76
rts
