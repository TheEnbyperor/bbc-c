__bbcc_0000000a: .byte &00,&00,&00,&00,&00,&00
.export printf
.export out
.export gets
.export puts
.import _bbcc_pusha
.import _bbcc_pulla
.import getchar
.import putchar
.import putchar
.import putchar

\ Function
gets: 
lda &78
pha
lda &79
pha
lda &76
pha
lda &77
pha
lda &72
pha
lda &73
pha
lda &74
pha
lda &75
pha

\ Set
ldy #&00
lda (&8E),Y
sta &74
ldy #&01
lda (&8E),Y
sta &75

\ Label
__bbcc_00000000: 

\ Dec
sec
ldy #&02
lda (&8E),Y
sbc #1
ldy #&02
sta (&8E),Y
ldy #&03
lda (&8E),Y
sbc #0
ldy #&03
sta (&8E),Y

\ LessThanCmp
lda #00
sta &72
ldy #&02
lda (&8E),Y
cmp #&00
ldy #&03
lda (&8E),Y
sbc #&00
bvc __bbcc_0000000c
eor #&80
__bbcc_0000000c: bpl __bbcc_0000000b
lda #01
sta &72
__bbcc_0000000b: 

\ JmpZero
lda &72
bne __bbcc_0000000d
jmp __bbcc_00000001
__bbcc_0000000d: 

\ CallFunction
jsr getchar
lda &70
sta &72

\ Set
lda &74
sta &76
lda &75
sta &77

\ Inc
inc &74
bne __bbcc_0000000e
inc &75
__bbcc_0000000e: 

\ SetAt
lda &76
sta &78
lda &77
sta &79
lda &72
ldy #&00
sta (&78),Y

\ ReadAt
lda &77
sta &73
lda &76
sta &72
ldy #&00
lda (&72),Y
sta &78

\ EqualCmp
lda #00
sta &72
lda &78
cmp #&0A
bne __bbcc_0000000f
lda #01
sta &72
__bbcc_0000000f: 

\ JmpZero
lda &72
bne __bbcc_00000010
jmp __bbcc_00000002
__bbcc_00000010: 

\ Jmp
jmp __bbcc_00000001

\ Label
__bbcc_00000002: 

\ Jmp
jmp __bbcc_00000000

\ Label
__bbcc_00000001: 

\ Set
lda #&00
sta &72

\ SetAt
lda &74
sta &76
lda &75
sta &77
lda &72
ldy #&00
sta (&76),Y

\ Return
ldy #&00
lda (&8E),Y
sta &70
ldy #&01
lda (&8E),Y
sta &71
pla
sta &75
pla
sta &74
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
rts

\ Function
puts: 
lda &72
pha
lda &73
pha
lda &76
pha
lda &77
pha
lda &74
pha
lda &75
pha

\ Set
ldy #&00
lda (&8E),Y
sta &74
ldy #&01
lda (&8E),Y
sta &75

\ Label
__bbcc_00000003: 

\ ReadAt
lda &75
sta &73
lda &74
sta &72

\ Set

\ JmpZero
lda &76
bne __bbcc_00000011
jmp __bbcc_00000004
__bbcc_00000011: 

\ CallFunction
lda &76
jsr _bbcc_pusha
jsr putchar
clc
lda &8E
adc #&01
sta &8E
lda &8F
adc #&00
sta &8F
lda &70
sta &72

\ Add
clc
lda &74
adc #&00
sta &74
lda &75
adc #0
sta &75

\ Jmp
jmp __bbcc_00000003

\ Label
__bbcc_00000004: 

\ Return
lda #&00
sta &70
lda #&00
sta &71
pla
sta &75
pla
sta &74
pla
sta &77
pla
sta &76
pla
sta &73
pla
sta &72
rts

\ Function
printf: 
lda &7C
pha
lda &7D
pha
lda &7A
pha
lda &7B
pha
lda &78
pha
lda &79
pha
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
clc
lda &8E
adc #&00
sta &72
lda &8F
adc #&00
sta &73

\ Add
clc
lda &72
adc #&02
sta &74
lda &73
adc #&00
sta &75

\ Set

\ Set
ldy #&00
lda (&8E),Y
sta &76
ldy #&01
lda (&8E),Y
sta &77

\ Label
__bbcc_00000005: 

\ ReadAt
lda &77
sta &73
lda &76
sta &72
ldy #&00
lda (&72),Y
sta &78

\ Set
lda &78
sta &72

\ JmpZero
lda &72
bne __bbcc_00000012
jmp __bbcc_00000006
__bbcc_00000012: 

\ EqualCmp
lda #00
sta &78
lda &72
cmp #&25
bne __bbcc_00000013
lda #01
sta &78
__bbcc_00000013: 

\ JmpZero
lda &78
bne __bbcc_00000014
jmp __bbcc_00000007
__bbcc_00000014: 

\ Inc
inc &76
bne __bbcc_00000015
inc &77
__bbcc_00000015: 

\ ReadAt
lda &77
sta &79
lda &76
sta &78
ldy #&00
lda (&78),Y
sta &7A

\ Set
lda &7A
sta &72

\ EqualCmp
lda #00
sta &78
lda &72
cmp #&63
bne __bbcc_00000016
lda #01
sta &78
__bbcc_00000016: 

\ JmpZero
lda &78
bne __bbcc_00000017
jmp __bbcc_00000008
__bbcc_00000017: 

\ Set
lda &74
sta &78
lda &75
sta &79

\ ReadAt
lda &79
sta &7B
lda &78
sta &7A
ldy #&00
lda (&7A),Y
sta &7C

\ Set
lda &7C
sta &78

\ Add
clc
lda &74
adc #&01
sta &7A
lda &75
adc #&00
sta &7B

\ Set
lda &7A
sta &74
lda &7B
sta &75

\ CallFunction
lda &78
jsr _bbcc_pusha
jsr putchar
clc
lda &8E
adc #&01
sta &8E
lda &8F
adc #&00
sta &8F
lda &70
sta &7A

\ Jmp
jmp __bbcc_00000005

\ Label
__bbcc_00000008: 

\ EqualCmp
lda #00
sta &78
lda &72
cmp #&73
bne __bbcc_00000018
lda #01
sta &78
__bbcc_00000018: 

\ JmpZero
lda &78
bne __bbcc_00000019
jmp __bbcc_00000009
__bbcc_00000019: 

\ Set
lda &74
sta &78
lda &75
sta &79

\ ReadAt
lda &79
sta &7B
lda &78
sta &7A
ldy #&00
lda (&7A),Y
sta &7C
ldy #&01
lda (&7A),Y
sta &7D

\ Set
lda &7C
sta &7A
lda &7D
sta &7B

\ Add
clc
lda &74
adc #&02
sta &78
lda &75
adc #&00
sta &79

\ Set
lda &78
sta &74
lda &79
sta &75

\ Set
lda &7A
sta &74
lda &7B
sta &75

\ CallFunction
lda &75
jsr _bbcc_pusha
lda &74
jsr _bbcc_pusha
jsr puts
clc
lda &8E
adc #&02
sta &8E
lda &8F
adc #&00
sta &8F
lda &70
sta &78
lda &71
sta &79

\ Jmp
jmp __bbcc_00000005

\ Label
__bbcc_00000009: 

\ Label
__bbcc_00000007: 

\ CallFunction
lda &72
jsr _bbcc_pusha
jsr putchar
clc
lda &8E
adc #&01
sta &8E
lda &8F
adc #&00
sta &8F

\ Inc
inc &76
bne __bbcc_0000001a
inc &77
__bbcc_0000001a: 

\ Jmp
jmp __bbcc_00000005

\ Label
__bbcc_00000006: 

\ Return
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
pla
sta &79
pla
sta &78
pla
sta &7B
pla
sta &7A
pla
sta &7D
pla
sta &7C
rts
