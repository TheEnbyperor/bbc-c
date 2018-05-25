__bbcc_00000008: .byte &00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00,&00
__bbcc_00000009: .byte &00,&00,&00,&00,&00,&00,&00,&00,&00,&00
.export __buf
.export __Fibonacci
.export __num
.export __main
.import _bbcc_pusha
.import _bbcc_pulla
.import __getchar
.import __itoa
.import __putchar

\ Function
__main: 
lda &76
pha
lda &77
pha
lda &78
pha
lda &79
pha
lda &72
pha
lda &73
pha
lda &74
pha
lda &75
pha

\ Label
__bbcc_00000000: 

\ JmpZero
lda #&01
bne __bbcc_0000000a
lda #&00
bne __bbcc_0000000a
jmp __bbcc_00000001
__bbcc_0000000a: 

\ CallFunction
jsr __getchar
lda &70
sta &74

\ Set
lda &74
sta &72
lda #0
sta &73

\ Set

\ Sub
sec
lda &72
sbc #&41
sta &72
lda &73
sbc #&00
sta &73

\ Set

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
sta &74
lda &71
sta &75

\ Set

\ AddrOf
lda #<(__bbcc_00000009)
sta &75
lda #>(__bbcc_00000009)
sta &74

\ Set

\ CallFunction
lda &75
jsr _bbcc_pusha
lda &74
jsr _bbcc_pusha
lda &75
jsr _bbcc_pusha
lda &74
jsr _bbcc_pusha
jsr __itoa
clc
lda &8E
adc #&04
sta &8E
lda &8F
adc #&00
sta &8F

\ Set
lda #&00
sta &72
lda #&00
sta &73

\ Label
__bbcc_00000002: 

\ LessThanCmp
lda #00
sta &74
lda &73
cmp #&00
bcc __bbcc_0000000b
bne __bbcc_0000000c
lda &72
cmp #&0A
bcs __bbcc_0000000c
__bbcc_0000000b: lda #01
sta &75
__bbcc_0000000c: 

\ JmpZero
lda &74
bne __bbcc_0000000d
jmp __bbcc_00000003
__bbcc_0000000d: 

\ Mult
lda #&01
sta &76
lda &72
sta &74
lda &73
sta &75
lda #0
sta &78
sta &79
ldx #&10
__bbcc_0000000e: 
lsr &75
ror &74
bcc __bbcc_0000000f
clc
lda &76
adc &78
sta &78
lda #0
adc &79
sta &79
__bbcc_0000000f: clc
asl &76
dex
bne __bbcc_0000000e

\ Add
clc
lda <(__bbcc_00000009)
adc &78
sta &74
lda >(__bbcc_00000009)
adc &79
sta &75

\ ReadAt
lda &75
sta &77
lda &74
sta &76
ldy #&00
lda (&76),Y
sta &78

\ CallFunction
lda &78
jsr _bbcc_pusha
jsr __putchar
clc
lda &8E
adc #&01
sta &8E
lda &8F
adc #&00
sta &8F
lda &70
sta &74

\ Set
lda &72
sta &74
lda &73
sta &75

\ Inc
inc &72
bne __bbcc_00000010
inc &73
__bbcc_00000010: 

\ Jmp
jmp __bbcc_00000002

\ Label
__bbcc_00000003: 

\ Jmp
jmp __bbcc_00000000

\ Label
__bbcc_00000001: 

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
sta &77
pla
sta &76
pla
sta &79
pla
sta &78
pla
sta &75
pla
sta &74
rts

\ Function
__Fibonacci: 
lda &74
pha
lda &75
pha
lda &72
pha
lda &73
pha

\ EqualCmp
lda #00
sta &72
ldy #&00
lda (&8E),Y
cmp #&00
bne __bbcc_00000011
ldy #&01
lda (&8E),Y
cmp #&00
bne __bbcc_00000011
lda #01
sta &72
__bbcc_00000011: 

\ JmpZero
lda &72
bne __bbcc_00000012
jmp __bbcc_00000004
__bbcc_00000012: 

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

\ Jmp
jmp __bbcc_00000005

\ Label
__bbcc_00000004: 

\ EqualCmp
lda #00
sta &72
ldy #&00
lda (&8E),Y
cmp #&01
bne __bbcc_00000013
ldy #&01
lda (&8E),Y
cmp #&00
bne __bbcc_00000013
lda #01
sta &72
__bbcc_00000013: 

\ JmpZero
lda &72
bne __bbcc_00000014
jmp __bbcc_00000006
__bbcc_00000014: 

\ Return
lda #&01
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

\ Jmp
jmp __bbcc_00000007

\ Label
__bbcc_00000006: 

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
sta &73
pla
sta &72
pla
sta &75
pla
sta &74
rts

\ Label
__bbcc_00000007: 

\ Label
__bbcc_00000005: 

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
