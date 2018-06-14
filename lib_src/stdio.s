.import _bbcc_pusha
.import _bbcc_pulla
.import putchar
.import getchar
.export printf
.import itoa
__bbcc_0000000d: .byte &00,&00,&00,&00,&00,&00
.export puts
.export gets

\ Function: _puts
_puts: 
lda &8C
jsr _bbcc_pusha
lda &8D
jsr _bbcc_pusha
lda &8E
sta &8C
lda &8F
sta &8D

\ Label
__bbcc_00000000: 

\ ReadAt
ldy #&01
lda (&8C),Y
sta &71
ldy #&00
lda (&8C),Y
sta &70
ldy #&00
lda (&70),Y
sta &70

\ Set

\ JmpZero
lda &70
bne __bbcc_0000000e
jmp __bbcc_00000001
__bbcc_0000000e: 

\ Set

\ CallFunction
lda &70
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
clc
ldy #&00
lda (&8C),Y
adc #1
ldy #&00
sta (&8C),Y
ldy #&01
lda (&8C),Y
adc #0
ldy #&01
sta (&8C),Y

\ Jmp
jmp __bbcc_00000000

\ Label
__bbcc_00000001: 

\ Return
lda #&00
sta &70
lda #&00
sta &71
lda &8C
sta &8E
lda &8D
sta &8F
jsr _bbcc_pulla
sta &8D
jsr _bbcc_pulla
sta &8C
rts

\ Function: puts
puts: 
lda &8C
jsr _bbcc_pusha
lda &8D
jsr _bbcc_pusha
lda &8E
sta &8C
lda &8F
sta &8D

\ Set
ldy #&00
lda (&8C),Y
sta &70
ldy #&01
lda (&8C),Y
sta &71

\ CallFunction
lda &71
jsr _bbcc_pusha
lda &70
jsr _bbcc_pusha
jsr _puts
clc
lda &8E
adc #&02
sta &8E
lda &8F
adc #&00
sta &8F

\ Set
lda #&0A
sta &70

\ CallFunction
lda &70
jsr _bbcc_pusha
jsr putchar
clc
lda &8E
adc #&01
sta &8E
lda &8F
adc #&00
sta &8F

\ Return
lda #&00
sta &70
lda #&00
sta &71
lda &8C
sta &8E
lda &8D
sta &8F
jsr _bbcc_pulla
sta &8D
jsr _bbcc_pulla
sta &8C
rts

\ Function: gets
gets: 
lda &8C
jsr _bbcc_pusha
lda &8D
jsr _bbcc_pusha
lda &8E
sta &8C
lda &8F
sta &8D
lda &72
jsr _bbcc_pusha
lda &73
jsr _bbcc_pusha
lda &74
jsr _bbcc_pusha
lda &75
jsr _bbcc_pusha

\ Label
__bbcc_00000002: 

\ Dec
sec
ldy #&02
lda (&8C),Y
sbc #1
ldy #&02
sta (&8C),Y
ldy #&03
lda (&8C),Y
sbc #0
ldy #&03
sta (&8C),Y

\ LessThanCmp
lda #00
sta &70
ldy #&02
lda (&8C),Y
cmp #&00
ldy #&03
lda (&8C),Y
sbc #&00
bvc __bbcc_00000011
eor #&80
__bbcc_00000011: bpl __bbcc_00000010
lda #01
sta &70
__bbcc_00000010: 

\ JmpZero
lda &70
bne __bbcc_00000012
jmp __bbcc_00000003
__bbcc_00000012: 

\ CallFunction
jsr getchar

\ Set
lda &74
sta &72
lda &75
sta &73

\ Inc
inc &74
bne __bbcc_00000013
inc &75
__bbcc_00000013: 

\ Set

\ SetAt
lda &70
ldy #&00
sta (&72),Y

\ ReadAt
ldy #&00
lda (&72),Y
sta &70

\ EqualCmp
lda #00
sta &70
lda &70
cmp #&0A
bne __bbcc_00000014
lda #01
sta &70
__bbcc_00000014: 

\ JmpZero
lda &70
bne __bbcc_00000015
jmp __bbcc_00000004
__bbcc_00000015: 

\ Jmp
jmp __bbcc_00000003

\ Label
__bbcc_00000004: 

\ Jmp
jmp __bbcc_00000002

\ Label
__bbcc_00000003: 

\ Set
lda #&00
sta &70

\ SetAt
lda &70
ldy #&00
sta (&74),Y

\ Return
ldy #&00
lda (&8C),Y
sta &70
ldy #&01
lda (&8C),Y
sta &71
jsr _bbcc_pulla
sta &75
jsr _bbcc_pulla
sta &74
jsr _bbcc_pulla
sta &73
jsr _bbcc_pulla
sta &72
lda &8C
sta &8E
lda &8D
sta &8F
jsr _bbcc_pulla
sta &8D
jsr _bbcc_pulla
sta &8C
rts

\ Function: printf
printf: 
lda &8C
jsr _bbcc_pusha
lda &8D
jsr _bbcc_pusha
lda &8E
sta &8C
lda &8F
sta &8D
lda &72
jsr _bbcc_pusha
lda &73
jsr _bbcc_pusha
lda &74
jsr _bbcc_pusha
lda &75
jsr _bbcc_pusha
lda &76
jsr _bbcc_pusha
lda &77
jsr _bbcc_pusha

\ AddrOf
clc
lda &8C
adc #&00
sta &70
lda &8D
adc #&00
sta &71

\ Add
clc
lda &70
adc #&02
sta &70
lda &71
adc #&00
sta &71

\ Set

\ Set
lda &70
sta &74
lda &71
sta &75

\ Label
__bbcc_00000005: 

\ ReadAt
ldy #&01
lda (&8C),Y
sta &71
ldy #&00
lda (&8C),Y
sta &70
ldy #&00
lda (&70),Y
sta &70

\ Set
lda &70
sta &76

\ JmpZero
lda &76
bne __bbcc_00000016
jmp __bbcc_00000006
__bbcc_00000016: 

\ EqualCmp
lda #00
sta &70
lda &76
cmp #&25
bne __bbcc_00000017
lda #01
sta &70
__bbcc_00000017: 

\ JmpZero
lda &70
bne __bbcc_00000018
jmp __bbcc_00000007
__bbcc_00000018: 

\ Inc
clc
ldy #&00
lda (&8C),Y
adc #1
ldy #&00
sta (&8C),Y
ldy #&01
lda (&8C),Y
adc #0
ldy #&01
sta (&8C),Y

\ ReadAt
ldy #&01
lda (&8C),Y
sta &71
ldy #&00
lda (&8C),Y
sta &70
ldy #&00
lda (&70),Y
sta &70

\ Set
lda &70
sta &76

\ EqualCmp
lda #00
sta &70
lda &76
cmp #&63
bne __bbcc_0000001a
lda #01
sta &70
__bbcc_0000001a: 

\ JmpZero
lda &70
bne __bbcc_0000001b
jmp __bbcc_00000008
__bbcc_0000001b: 

\ Set
lda &74
sta &70
lda &75
sta &71

\ ReadAt
ldy #&00
lda (&70),Y
sta &70

\ Set
lda &70
sta &72

\ Add
clc
lda &74
adc #&01
sta &70
lda &75
adc #&00
sta &71

\ Set
lda &70
sta &74
lda &71
sta &75

\ Set
lda &72
sta &70

\ CallFunction
lda &70
jsr _bbcc_pusha
jsr putchar
clc
lda &8E
adc #&01
sta &8E
lda &8F
adc #&00
sta &8F

\ Jmp
jmp __bbcc_00000005

\ Label
__bbcc_00000008: 

\ EqualCmp
lda #00
sta &70
lda &76
cmp #&73
bne __bbcc_0000001c
lda #01
sta &70
__bbcc_0000001c: 

\ JmpZero
lda &70
bne __bbcc_0000001d
jmp __bbcc_00000009
__bbcc_0000001d: 

\ Set
lda &74
sta &70
lda &75
sta &71

\ ReadAt
ldy #&00
lda (&70),Y
sta &70
ldy #&01
lda (&70),Y
sta &71

\ Set

\ Set
lda &70
sta &72
lda &71
sta &73

\ Add
clc
lda &74
adc #&02
sta &70
lda &75
adc #&00
sta &71

\ Set
lda &70
sta &74
lda &71
sta &75

\ Set
lda &72
sta &70
lda &73
sta &71

\ CallFunction
lda &71
jsr _bbcc_pusha
lda &70
jsr _bbcc_pusha
jsr _puts
clc
lda &8E
adc #&02
sta &8E
lda &8F
adc #&00
sta &8F

\ Jmp
jmp __bbcc_00000005

\ Label
__bbcc_00000009: 

\ Set
lda #&00
sta &72

\ EqualCmp
lda #00
sta &70
lda &76
cmp #&69
bne __bbcc_0000001e
lda #01
sta &70
__bbcc_0000001e: 

\ JmpNotZero
lda &70
beq __bbcc_0000001f
__bbcc_0000001f: jmp __bbcc_0000000a
__bbcc_00000020: 

\ EqualCmp
lda #00
sta &70
lda &76
cmp #&64
bne __bbcc_00000021
lda #01
sta &70
__bbcc_00000021: 

\ JmpNotZero
lda &70
beq __bbcc_00000022
__bbcc_00000022: jmp __bbcc_0000000a
__bbcc_00000023: 

\ Jmp
jmp __bbcc_0000000b

\ Label
__bbcc_0000000a: 

\ Set
lda #&01
sta &72

\ Label
__bbcc_0000000b: 

\ JmpZero
lda &72
bne __bbcc_00000024
jmp __bbcc_0000000c
__bbcc_00000024: 

\ Set
lda &74
sta &70
lda &75
sta &71

\ ReadAt
ldy #&00
lda (&70),Y
sta &70
ldy #&01
lda (&70),Y
sta &71

\ Set
lda &70
sta &72
lda &71
sta &73

\ Add
clc
lda &74
adc #&02
sta &70
lda &75
adc #&00
sta &71

\ Set
lda &70
sta &74
lda &71
sta &75

\ AddrOf
lda #0(__bbcc_0000000d)
sta &70
lda #1(__bbcc_0000000d)
sta &71

\ Set

\ CallFunction
lda &71
jsr _bbcc_pusha
lda &70
jsr _bbcc_pusha
lda &73
jsr _bbcc_pusha
lda &72
jsr _bbcc_pusha
jsr itoa
clc
lda &8E
adc #&04
sta &8E
lda &8F
adc #&00
sta &8F

\ AddrOf
lda #0(__bbcc_0000000d)
sta &70
lda #1(__bbcc_0000000d)
sta &71

\ Set

\ CallFunction
lda &71
jsr _bbcc_pusha
lda &70
jsr _bbcc_pusha
jsr _puts
clc
lda &8E
adc #&02
sta &8E
lda &8F
adc #&00
sta &8F

\ Jmp
jmp __bbcc_00000005

\ Label
__bbcc_0000000c: 

\ Label
__bbcc_00000007: 

\ Set
lda &76
sta &70

\ CallFunction
lda &70
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
clc
ldy #&00
lda (&8C),Y
adc #1
ldy #&00
sta (&8C),Y
ldy #&01
lda (&8C),Y
adc #0
ldy #&01
sta (&8C),Y

\ Jmp
jmp __bbcc_00000005

\ Label
__bbcc_00000006: 

\ Return
jsr _bbcc_pulla
sta &77
jsr _bbcc_pulla
sta &76
jsr _bbcc_pulla
sta &75
jsr _bbcc_pulla
sta &74
jsr _bbcc_pulla
sta &73
jsr _bbcc_pulla
sta &72
lda &8C
sta &8E
lda &8D
sta &8F
jsr _bbcc_pulla
sta &8D
jsr _bbcc_pulla
sta &8C
rts
