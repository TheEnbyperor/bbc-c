.export __Fibonacci
.export __main
.import _bbcc_pusha
.import _bbcc_pulla
.import __itoa

\ Function
__main: 
lda &76
pha
lda &77
pha
lda &74
pha
lda &75
pha
sec
lda &8E
sbc #&0A
sta &8E
lda &8F
sbc #&00
sta &8F

\ Set
lda #&00
ldy #&00
sta (&8E),Y
lda #&00
ldy #&01
sta (&8E),Y
lda #&00
ldy #&02
sta (&8E),Y
lda #&00
ldy #&03
sta (&8E),Y
lda #&00
ldy #&04
sta (&8E),Y
lda #&00
ldy #&05
sta (&8E),Y
lda #&00
ldy #&06
sta (&8E),Y
lda #&00
ldy #&07
sta (&8E),Y
lda #&00
ldy #&08
sta (&8E),Y
lda #&00
ldy #&09
sta (&8E),Y

\ CallFunction
lda #&00
jsr _bbcc_pusha
lda #&03
jsr _bbcc_pusha
jsr __Fibonacci
clc
lda &8E
adc #&02
sta &8E
lda &8F
adc #&00
sta &8F
lda &70
sta &74
lda &71
sta &75

\ Set

\ AddrOf
clc
lda &8E
adc #&00
sta &76
lda &8F
adc #&00
sta &77

\ Set

\ CallFunction
lda &75
jsr _bbcc_pusha
lda &74
jsr _bbcc_pusha
lda &77
jsr _bbcc_pusha
lda &76
jsr _bbcc_pusha
jsr __itoa
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
clc
lda &8E
adc #&0A
sta &8E
lda &8F
adc #&00
sta &8F
pla
sta &75
pla
sta &74
pla
sta &77
pla
sta &76
rts

\ Function
__Fibonacci: 

\ Return
ldy #&00
lda (&8E),Y
sta &70
ldy #&01
lda (&8E),Y
sta &71
rts
