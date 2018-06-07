.export isupper
.export islower
.export isalpha
.export isdigit
.export isalnum
.export isascii
.export isblank
.export iscntrl
.export isspace
.export isxdigit
.export toupper
.export tolower
.import _bbcc_pusha
.import _bbcc_pulla

\ Function
isupper: 
lda &74
pha
lda &75
pha
lda &72
pha
lda &73
pha

\ Set
lda #&01
sta &72

\ MoreEqualCmp
lda #00
sta &74
ldy #&00
lda (&8E),Y
cmp #&41
bcc __bbcc_0000001f
__bbcc_0000001e: lda #01
sta &74
__bbcc_0000001f: 

\ JmpZero
lda &74
bne __bbcc_00000020
jmp __bbcc_00000000
__bbcc_00000020: 

\ LessEqualCmp
lda #00
sta &74
ldy #&00
lda (&8E),Y
cmp #&5A
bcc __bbcc_00000021
bne __bbcc_00000022
__bbcc_00000021: lda #01
sta &74
__bbcc_00000022: 

\ JmpZero
lda &74
bne __bbcc_00000023
jmp __bbcc_00000000
__bbcc_00000023: 

\ Jmp
jmp __bbcc_00000001

\ Label
__bbcc_00000000: 

\ Set
lda #&00
sta &72

\ Label
__bbcc_00000001: 

\ Return
lda &72
sta &70
pla
sta &75
pla
sta &74
pla
sta &73
pla
sta &72
rts

\ Function
islower: 
lda &74
pha
lda &75
pha
lda &72
pha
lda &73
pha

\ Set
lda #&01
sta &72

\ MoreEqualCmp
lda #00
sta &74
ldy #&00
lda (&8E),Y
cmp #&61
bcc __bbcc_00000025
__bbcc_00000024: lda #01
sta &74
__bbcc_00000025: 

\ JmpZero
lda &74
bne __bbcc_00000026
jmp __bbcc_00000002
__bbcc_00000026: 

\ LessEqualCmp
lda #00
sta &74
ldy #&00
lda (&8E),Y
cmp #&7A
bcc __bbcc_00000027
bne __bbcc_00000028
__bbcc_00000027: lda #01
sta &74
__bbcc_00000028: 

\ JmpZero
lda &74
bne __bbcc_00000029
jmp __bbcc_00000002
__bbcc_00000029: 

\ Jmp
jmp __bbcc_00000003

\ Label
__bbcc_00000002: 

\ Set
lda #&00
sta &72

\ Label
__bbcc_00000003: 

\ Return
lda &72
sta &70
pla
sta &75
pla
sta &74
pla
sta &73
pla
sta &72
rts

\ Function
isalpha: 
lda &74
pha
lda &75
pha
lda &72
pha
lda &73
pha

\ Set
lda #&00
sta &72

\ CallFunction
ldy #&00
lda (&8E),Y
jsr _bbcc_pusha
jsr islower
clc
lda &8E
adc #&01
sta &8E
lda &8F
adc #&00
sta &8F
lda &70
sta &74

\ JmpNotZero
lda &74
beq __bbcc_0000002a
__bbcc_0000002a: jmp __bbcc_00000004
__bbcc_0000002b: 

\ CallFunction
ldy #&00
lda (&8E),Y
jsr _bbcc_pusha
jsr isupper
clc
lda &8E
adc #&01
sta &8E
lda &8F
adc #&00
sta &8F
lda &70
sta &74

\ JmpNotZero
lda &74
beq __bbcc_0000002c
__bbcc_0000002c: jmp __bbcc_00000004
__bbcc_0000002d: 

\ Jmp
jmp __bbcc_00000005

\ Label
__bbcc_00000004: 

\ Set
lda #&01
sta &72

\ Label
__bbcc_00000005: 

\ Return
lda &72
sta &70
pla
sta &75
pla
sta &74
pla
sta &73
pla
sta &72
rts

\ Function
isdigit: 
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
lda #0
sta &75

\ Set

\ Sub
sec
lda &74
sbc #&30
sta &72

\ LessEqualCmp
lda #00
sta &74
lda &72
cmp #&09
bcc __bbcc_0000002e
bne __bbcc_0000002f
__bbcc_0000002e: lda #01
sta &74
__bbcc_0000002f: 

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

\ Function
isalnum: 
lda &74
pha
lda &75
pha
lda &72
pha
lda &73
pha

\ Set
lda #&00
sta &72

\ CallFunction
ldy #&00
lda (&8E),Y
jsr _bbcc_pusha
jsr isalpha
clc
lda &8E
adc #&01
sta &8E
lda &8F
adc #&00
sta &8F
lda &70
sta &74

\ JmpNotZero
lda &74
beq __bbcc_00000030
__bbcc_00000030: jmp __bbcc_00000006
__bbcc_00000031: 

\ CallFunction
ldy #&00
lda (&8E),Y
jsr _bbcc_pusha
jsr isdigit
clc
lda &8E
adc #&01
sta &8E
lda &8F
adc #&00
sta &8F
lda &70
sta &74

\ JmpNotZero
lda &74
beq __bbcc_00000032
__bbcc_00000032: jmp __bbcc_00000006
__bbcc_00000033: 

\ Jmp
jmp __bbcc_00000007

\ Label
__bbcc_00000006: 

\ Set
lda #&01
sta &72

\ Label
__bbcc_00000007: 

\ Return
lda &72
sta &70
pla
sta &75
pla
sta &74
pla
sta &73
pla
sta &72
rts

\ Function
isascii: 
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

\ Set
lda #&01
sta &72

\ Not
lda #&7F
eor #&FF
sta &74
lda #&00
eor #&FF
sta &75

\ Set
ldy #&00
lda (&8E),Y
sta &76
lda #0
sta &77

\ And
lda &76
and &74
sta &78
lda &77
and &75
sta &79

\ JmpNotZero
lda &78
beq __bbcc_00000034
lda &79
beq __bbcc_00000034
__bbcc_00000034: jmp __bbcc_00000008
__bbcc_00000035: 

\ Jmp
jmp __bbcc_00000009

\ Label
__bbcc_00000008: 

\ Set
lda #&00
sta &72

\ Label
__bbcc_00000009: 

\ Return
lda &72
sta &70
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
sta &73
pla
sta &72
rts

\ Function
isblank: 
lda &74
pha
lda &75
pha
lda &72
pha
lda &73
pha

\ Set
lda #&00
sta &72

\ EqualCmp
lda #00
sta &74
ldy #&00
lda (&8E),Y
cmp #&09
bne __bbcc_00000036
lda #01
sta &74
__bbcc_00000036: 

\ JmpNotZero
lda &74
beq __bbcc_00000037
__bbcc_00000037: jmp __bbcc_0000000a
__bbcc_00000038: 

\ EqualCmp
lda #00
sta &74
ldy #&00
lda (&8E),Y
cmp #&20
bne __bbcc_00000039
lda #01
sta &74
__bbcc_00000039: 

\ JmpNotZero
lda &74
beq __bbcc_0000003a
__bbcc_0000003a: jmp __bbcc_0000000a
__bbcc_0000003b: 

\ Jmp
jmp __bbcc_0000000b

\ Label
__bbcc_0000000a: 

\ Set
lda #&01
sta &72

\ Label
__bbcc_0000000b: 

\ Return
lda &72
sta &70
pla
sta &75
pla
sta &74
pla
sta &73
pla
sta &72
rts

\ Function
iscntrl: 
lda &72
pha
lda &73
pha

\ LessThanCmp
lda #00
sta &72
ldy #&00
lda (&8E),Y
cmp #&20
bcs __bbcc_0000003d
__bbcc_0000003c: lda #01
sta &72
__bbcc_0000003d: 

\ Return
lda &72
sta &70
pla
sta &73
pla
sta &72
rts

\ Function
isspace: 
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

\ Set
lda #&00
sta &72

\ Set
lda #&00
sta &74

\ Set
lda #&00
sta &76

\ EqualCmp
lda #00
sta &78
ldy #&00
lda (&8E),Y
cmp #&20
bne __bbcc_0000003e
lda #01
sta &78
__bbcc_0000003e: 

\ JmpNotZero
lda &78
beq __bbcc_0000003f
__bbcc_0000003f: jmp __bbcc_00000010
__bbcc_00000040: 

\ EqualCmp
lda #00
sta &78
ldy #&00
lda (&8E),Y
cmp #&0A
bne __bbcc_00000041
lda #01
sta &78
__bbcc_00000041: 

\ JmpNotZero
lda &78
beq __bbcc_00000042
__bbcc_00000042: jmp __bbcc_00000010
__bbcc_00000043: 

\ Jmp
jmp __bbcc_00000011

\ Label
__bbcc_00000010: 

\ Set
lda #&01
sta &76

\ Label
__bbcc_00000011: 

\ JmpNotZero
lda &76
beq __bbcc_00000044
__bbcc_00000044: jmp __bbcc_0000000e
__bbcc_00000045: 

\ EqualCmp
lda #00
sta &76
ldy #&00
lda (&8E),Y
cmp #&09
bne __bbcc_00000046
lda #01
sta &76
__bbcc_00000046: 

\ JmpNotZero
lda &76
beq __bbcc_00000047
__bbcc_00000047: jmp __bbcc_0000000e
__bbcc_00000048: 

\ Jmp
jmp __bbcc_0000000f

\ Label
__bbcc_0000000e: 

\ Set
lda #&01
sta &74

\ Label
__bbcc_0000000f: 

\ JmpNotZero
lda &74
beq __bbcc_00000049
__bbcc_00000049: jmp __bbcc_0000000c
__bbcc_0000004a: 

\ EqualCmp
lda #00
sta &74
ldy #&00
lda (&8E),Y
cmp #&0D
bne __bbcc_0000004b
lda #01
sta &74
__bbcc_0000004b: 

\ JmpNotZero
lda &74
beq __bbcc_0000004c
__bbcc_0000004c: jmp __bbcc_0000000c
__bbcc_0000004d: 

\ Jmp
jmp __bbcc_0000000d

\ Label
__bbcc_0000000c: 

\ Set
lda #&01
sta &72

\ Label
__bbcc_0000000d: 

\ Return
lda &72
sta &70
pla
sta &79
pla
sta &78
pla
sta &77
pla
sta &76
pla
sta &75
pla
sta &74
pla
sta &73
pla
sta &72
rts

\ Function
isxdigit: 
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

\ Set
lda #&00
sta &72

\ Set
lda #&00
sta &74

\ CallFunction
ldy #&00
lda (&8E),Y
jsr _bbcc_pusha
jsr isdigit
clc
lda &8E
adc #&01
sta &8E
lda &8F
adc #&00
sta &8F
lda &70
sta &76

\ JmpNotZero
lda &76
beq __bbcc_0000004e
__bbcc_0000004e: jmp __bbcc_00000014
__bbcc_0000004f: 

\ Set
lda #&01
sta &76

\ MoreEqualCmp
lda #00
sta &78
ldy #&00
lda (&8E),Y
cmp #&61
bcc __bbcc_00000051
__bbcc_00000050: lda #01
sta &78
__bbcc_00000051: 

\ JmpZero
lda &78
bne __bbcc_00000052
jmp __bbcc_00000016
__bbcc_00000052: 

\ LessEqualCmp
lda #00
sta &78
ldy #&00
lda (&8E),Y
cmp #&66
bcc __bbcc_00000053
bne __bbcc_00000054
__bbcc_00000053: lda #01
sta &78
__bbcc_00000054: 

\ JmpZero
lda &78
bne __bbcc_00000055
jmp __bbcc_00000016
__bbcc_00000055: 

\ Jmp
jmp __bbcc_00000017

\ Label
__bbcc_00000016: 

\ Set
lda #&00
sta &76

\ Label
__bbcc_00000017: 

\ JmpNotZero
lda &76
beq __bbcc_00000056
__bbcc_00000056: jmp __bbcc_00000014
__bbcc_00000057: 

\ Jmp
jmp __bbcc_00000015

\ Label
__bbcc_00000014: 

\ Set
lda #&01
sta &74

\ Label
__bbcc_00000015: 

\ JmpNotZero
lda &74
beq __bbcc_00000058
__bbcc_00000058: jmp __bbcc_00000012
__bbcc_00000059: 

\ Set
lda #&01
sta &74

\ MoreEqualCmp
lda #00
sta &76
ldy #&00
lda (&8E),Y
cmp #&41
bcc __bbcc_0000005b
__bbcc_0000005a: lda #01
sta &76
__bbcc_0000005b: 

\ JmpZero
lda &76
bne __bbcc_0000005c
jmp __bbcc_00000018
__bbcc_0000005c: 

\ LessEqualCmp
lda #00
sta &76
ldy #&00
lda (&8E),Y
cmp #&46
bcc __bbcc_0000005d
bne __bbcc_0000005e
__bbcc_0000005d: lda #01
sta &76
__bbcc_0000005e: 

\ JmpZero
lda &76
bne __bbcc_0000005f
jmp __bbcc_00000018
__bbcc_0000005f: 

\ Jmp
jmp __bbcc_00000019

\ Label
__bbcc_00000018: 

\ Set
lda #&00
sta &74

\ Label
__bbcc_00000019: 

\ JmpNotZero
lda &74
beq __bbcc_00000060
__bbcc_00000060: jmp __bbcc_00000012
__bbcc_00000061: 

\ Jmp
jmp __bbcc_00000013

\ Label
__bbcc_00000012: 

\ Set
lda #&01
sta &72

\ Label
__bbcc_00000013: 

\ Return
lda &72
sta &70
pla
sta &79
pla
sta &78
pla
sta &77
pla
sta &76
pla
sta &75
pla
sta &74
pla
sta &73
pla
sta &72
rts

\ Function
toupper: 
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

\ CallFunction
ldy #&00
lda (&8E),Y
jsr _bbcc_pusha
jsr islower
clc
lda &8E
adc #&01
sta &8E
lda &8F
adc #&00
sta &8F
lda &70
sta &72

\ Not
lda #&20
eor #&FF
sta &74
lda #&00
eor #&FF
sta &75

\ Set
ldy #&00
lda (&8E),Y
sta &76
lda #0
sta &77

\ And
lda &76
and &74
sta &78
lda &77
and &75
sta &79

\ JmpZero
lda &72
bne __bbcc_00000062
jmp __bbcc_0000001a
__bbcc_00000062: 

\ Set
lda &78
sta &72
lda &79
sta &73

\ Jmp
jmp __bbcc_0000001b

\ Label
__bbcc_0000001a: 

\ Set
ldy #&00
lda (&8E),Y
sta &72
lda #0
sta &73

\ Label
__bbcc_0000001b: 

\ Return
lda &72
sta &70
lda &73
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
sta &79
pla
sta &78
pla
sta &73
pla
sta &72
rts

\ Function
tolower: 
lda &74
pha
lda &75
pha
lda &72
pha
lda &73
pha

\ CallFunction
ldy #&00
lda (&8E),Y
jsr _bbcc_pusha
jsr isupper
clc
lda &8E
adc #&01
sta &8E
lda &8F
adc #&00
sta &8F

\ Set
ldy #&00
lda (&8E),Y
sta &72
lda #0
sta &73

\ IncOr
lda &72
ora #&20
sta &74
lda &73
ora #&00
sta &75

\ JmpZero
lda &70
bne __bbcc_00000063
jmp __bbcc_0000001c
__bbcc_00000063: 

\ Set
lda &74
sta &70
lda &75
sta &71

\ Jmp
jmp __bbcc_0000001d

\ Label
__bbcc_0000001c: 

\ Set
ldy #&00
lda (&8E),Y
sta &70
lda #0
sta &71

\ Label
__bbcc_0000001d: 

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
