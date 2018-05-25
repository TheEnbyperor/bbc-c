__bbcc_00000004: .byte &00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00
.export __buf
.export __Fibonacci
.export __main
.import _bbcc_pusha
.import _bbcc_pulla

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
lda &72
pha
lda &73
pha

\ CallFunction
lda #&00
jsr _bbcc_pusha
lda #&02
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
sta &72
lda &71
sta &73

\ Return
lda &72
sta &70
lda &73
sta &71
pla
sta &73
pla
sta &72
rts

\ Function
__Fibonacci: 
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

\ Sub
sec
ldy #&00
lda (&8E),Y
sbc #&01
sta &72
ldy #&01
lda (&8E),Y
sbc #&00
sta &73

\ Sub
sec
ldy #&00
lda (&8E),Y
sbc #&02
sta &74
ldy #&01
lda (&8E),Y
sbc #&00
sta &75

\ Add
clc
lda &72
adc &74
sta &76
lda &73
adc &75
sta &77

\ Return
lda &76
sta &70
lda &77
sta &71
pla
sta &77
pla
sta &76
pla
sta &73
pla
sta &72
pla
sta &75
pla
sta &74
rts

\ EqualCmp
lda #00
sta &72
ldy #&00
lda (&8E),Y
cmp #&00
bne __bbcc_00000005
ldy #&01
lda (&8E),Y
cmp #&00
bne __bbcc_00000005
lda #01
sta &72
__bbcc_00000005: 

\ JmpZero
lda &72
bne __bbcc_00000006
jmp __bbcc_00000000
__bbcc_00000006: 

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
sta &73
pla
sta &72
pla
sta &75
pla
sta &74
rts

\ Jmp
jmp __bbcc_00000001

\ Label
__bbcc_00000000: 

\ EqualCmp
lda #00
sta &72
ldy #&00
lda (&8E),Y
cmp #&01
bne __bbcc_00000007
ldy #&01
lda (&8E),Y
cmp #&00
bne __bbcc_00000007
lda #01
sta &72
__bbcc_00000007: 

\ JmpZero
lda &72
bne __bbcc_00000008
jmp __bbcc_00000002
__bbcc_00000008: 

\ Return
lda #&01
sta &70
lda #&00
sta &71
pla
sta &77
pla
sta &76
pla
sta &73
pla
sta &72
pla
sta &75
pla
sta &74
rts

\ Jmp
jmp __bbcc_00000003

\ Label
__bbcc_00000002: 

\ Sub
sec
ldy #&00
lda (&8E),Y
sbc #&01
sta &72
ldy #&01
lda (&8E),Y
sbc #&00
sta &73

\ CallFunction
lda &73
jsr _bbcc_pusha
lda &72
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
sta &72
lda &71
sta &73

\ Sub
sec
ldy #&00
lda (&8E),Y
sbc #&02
sta &74
ldy #&01
lda (&8E),Y
sbc #&00
sta &75

\ CallFunction
lda &75
jsr _bbcc_pusha
lda &74
jsr _bbcc_pusha
jsr __Fibonacci
clc
lda &8E
adc #&02
sta &8E
lda &8F
adc #&00
sta &8F

\ Add
clc
lda &72
adc &70
sta &74
lda &73
adc &71
sta &75

\ Return
lda &74
sta &70
lda &75
sta &71
pla
sta &77
pla
sta &76
pla
sta &73
pla
sta &72
pla
sta &75
pla
sta &74
rts

\ Label
__bbcc_00000003: 

\ Label
__bbcc_00000001: 

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
sta &73
pla
sta &72
pla
sta &75
pla
sta &74
rts
