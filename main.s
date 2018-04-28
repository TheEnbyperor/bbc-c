.export _start
.export __strlen
.export __reverse
.export __itoa
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
__strlen: 
lda &7A
pha
lda &7B
pha
lda &74
pha
lda &75
pha
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

\ Set
lda #&00
sta &72
lda #&00
sta &73

\ Label
__bbcc_00000000: 

\ JmpZero
lda #&01
bne __bbcc_00000007
lda #&00
bne __bbcc_00000007
jmp __bbcc_00000001
__bbcc_00000007: 

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
__bbcc_00000008: 
lsr &75
ror &74
bcc __bbcc_00000009
clc
lda &76
adc &78
sta &78
lda #0
adc &79
sta &79
__bbcc_00000009: clc
asl &76
dex
bne __bbcc_00000008

\ Add
clc
ldy #&00
lda (&8E),Y
adc &78
sta &74
ldy #&01
lda (&8E),Y
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

\ EqualCmp
lda #00
sta &74
lda &78
cmp #&00
bne __bbcc_0000000a
lda #01
sta &74
__bbcc_0000000a: 

\ JmpZero
lda &74
bne __bbcc_0000000b
jmp __bbcc_00000002
__bbcc_0000000b: 

\ Add
clc
lda &72
adc #&01
sta &74
lda &73
adc #&00
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

\ Label
__bbcc_00000002: 

\ Set
lda &72
sta &74
lda &73
sta &75

\ Inc
inc &72
bne __bbcc_0000000c
inc &73
__bbcc_0000000c: 

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
__reverse: 
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

\ Set
lda #&00
sta &72
lda #&00
sta &73

\ Set
lda #&00
sta &74
lda #&00
sta &75

\ Set
lda #&00
sta &76

\ Set
lda #&00
sta &72
lda #&00
sta &73

\ CallFunction
ldy #&00
lda (&8E),Y
jsr _bbcc_pusha
ldy #&01
lda (&8E),Y
jsr _bbcc_pusha
ldy #&02
lda (&8E),Y
jsr _bbcc_pusha
ldy #&03
lda (&8E),Y
jsr _bbcc_pusha
ldy #&04
lda (&8E),Y
jsr _bbcc_pusha
ldy #&05
lda (&8E),Y
jsr _bbcc_pusha
ldy #&06
lda (&8E),Y
jsr _bbcc_pusha
ldy #&07
lda (&8E),Y
jsr _bbcc_pusha
jsr __strlen
clc
lda &8E
adc #&08
sta &8E
lda &8F
adc #&00
sta &8F
lda &70
sta &76
lda &71
sta &77

\ Sub
sec
lda #0
sta &78
lda #0
sta &79

\ Set
lda &78
sta &74
lda &79
sta &75

\ Label
__bbcc_00000003: 

\ LessThanCmp
lda #00
sta &76
lda &73
cmp &75
bcc __bbcc_0000000d
bne __bbcc_0000000e
lda &72
cmp &74
bcs __bbcc_0000000e
__bbcc_0000000d: lda #01
sta &77
__bbcc_0000000e: 

\ JmpZero
lda &76
bne __bbcc_0000000f
jmp __bbcc_00000004
__bbcc_0000000f: 

\ Mult
lda #&01
sta &78
lda &72
sta &76
lda &73
sta &77
lda #0
sta &7A
sta &7B
ldx #&10
__bbcc_00000010: 
lsr &77
ror &76
bcc __bbcc_00000011
clc
lda &78
adc &7A
sta &7A
lda #0
adc &7B
sta &7B
__bbcc_00000011: clc
asl &78
dex
bne __bbcc_00000010

\ Add
clc
ldy #&00
lda (&8E),Y
adc &7A
sta &76
ldy #&01
lda (&8E),Y
adc &7B
sta &77

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
sta &76

\ Mult
lda #&01
sta &78
lda &74
sta &76
lda &75
sta &77
lda #0
sta &7A
sta &7B
ldx #&10
__bbcc_00000012: 
lsr &77
ror &76
bcc __bbcc_00000013
clc
lda &78
adc &7A
sta &7A
lda #0
adc &7B
sta &7B
__bbcc_00000013: clc
asl &78
dex
bne __bbcc_00000012

\ Add
clc
ldy #&00
lda (&8E),Y
adc &7A
sta &76
ldy #&01
lda (&8E),Y
adc &7B
sta &77

\ ReadAt
lda &77
sta &79
lda &76
sta &78
ldy #&00
lda (&78),Y
sta &7A

\ Mult
lda #&01
sta &78
lda &72
sta &76
lda &73
sta &77
lda #0
sta &7A
sta &7B
ldx #&10
__bbcc_00000014: 
lsr &77
ror &76
bcc __bbcc_00000015
clc
lda &78
adc &7A
sta &7A
lda #0
adc &7B
sta &7B
__bbcc_00000015: clc
asl &78
dex
bne __bbcc_00000014

\ Add
clc
ldy #&00
lda (&8E),Y
adc &7A
sta &76
ldy #&01
lda (&8E),Y
adc &7B
sta &77

\ SetAt
lda &76
sta &78
lda &77
sta &79
lda &7A
ldy #&00
sta (&78),Y

\ Mult
lda #&01
sta &78
lda &74
sta &76
lda &75
sta &77
lda #0
sta &7A
sta &7B
ldx #&10
__bbcc_00000016: 
lsr &77
ror &76
bcc __bbcc_00000017
clc
lda &78
adc &7A
sta &7A
lda #0
adc &7B
sta &7B
__bbcc_00000017: clc
asl &78
dex
bne __bbcc_00000016

\ Add
clc
ldy #&00
lda (&8E),Y
adc &7A
sta &76
ldy #&01
lda (&8E),Y
adc &7B
sta &77

\ SetAt
lda &76
sta &78
lda &77
sta &79
lda &76
ldy #&00
sta (&78),Y

\ Set
lda &72
sta &76
lda &73
sta &77

\ Inc
inc &72
bne __bbcc_00000018
inc &73
__bbcc_00000018: 

\ Set
lda &74
sta &72
lda &75
sta &73

\ Dec
lda &74
bne __bbcc_00000019
dec &75
__bbcc_00000019: 
dec &74

\ Jmp
jmp __bbcc_00000003

\ Label
__bbcc_00000004: 

\ Return
lda #&00
sta &70
pla
sta &75
pla
sta &74
pla
sta &7B
pla
sta &7A
pla
sta &79
pla
sta &78
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
__itoa: 
lda &7A
pha
lda &7B
pha
lda &74
pha
lda &75
pha
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

\ Set
lda #&00
sta &72
lda #&00
sta &73

\ Set
lda #&00
sta &72
lda #&00
sta &73

\ Label
__bbcc_00000005: 

\ Mod
ldy #&00
lda (&8E),Y
sta &76
ldy #&01
lda (&8E),Y
sta &77
lda #&0A
sta &74
lda #&00
sta &75
lda #0
sta &78
sta &79
ldx #&10
__bbcc_0000001a: 
asl &76
rol &77
rol &78
rol &79
sec
lda &78
sbc &74
pha
lda &79
sbc &75
bcc __bbcc_0000001b
sta &79
pla
sta &78
inc &76
jmp __bbcc_0000001c
__bbcc_0000001b: 
pla
__bbcc_0000001c: dex
bne __bbcc_0000001a

\ Add
clc
lda &78
adc #&30
sta &74
lda &79
adc #&00
sta &75

\ Set
lda &72
sta &74
lda &73
sta &75

\ Inc
inc &72
bne __bbcc_0000001d
inc &73
__bbcc_0000001d: 

\ Mult
lda #&01
sta &78
lda &74
sta &76
lda &75
sta &77
lda #0
sta &7A
sta &7B
ldx #&10
__bbcc_0000001e: 
lsr &77
ror &76
bcc __bbcc_0000001f
clc
lda &78
adc &7A
sta &7A
lda #0
adc &7B
sta &7B
__bbcc_0000001f: clc
asl &78
dex
bne __bbcc_0000001e

\ Add
clc
ldy #&02
lda (&8E),Y
adc &7A
sta &74
ldy #&03
lda (&8E),Y
adc &7B
sta &75

\ SetAt
lda &74
sta &76
lda &75
sta &77
lda &74
ldy #&00
sta (&76),Y
lda &75
ldy #&01
sta (&76),Y

\ Div
ldy #&00
lda (&8E),Y
sta &78
ldy #&01
lda (&8E),Y
sta &79
lda #&0A
sta &76
lda #&00
sta &77
lda #0
sta &74
sta &75
ldx #&10
__bbcc_00000020: 
asl &78
rol &79
rol &74
rol &75
sec
lda &74
sbc &76
pha
lda &75
sbc &77
bcc __bbcc_00000021
sta &75
pla
sta &74
inc &78
jmp __bbcc_00000022
__bbcc_00000021: 
pla
__bbcc_00000022: dex
bne __bbcc_00000020
lda &78
sta &7A
lda &79
sta &7B

\ Set
lda &7A
ldy #&00
sta (&8E),Y
lda &7B
ldy #&01
sta (&8E),Y

\ MoreThanCmp
lda #00
sta &74
ldy #&01
lda (&8E),Y
cmp #&00
bcc __bbcc_00000024
bne __bbcc_00000023
ldy #&00
lda (&8E),Y
cmp #&00
beq __bbcc_00000024
bcc __bbcc_00000024
__bbcc_00000023: lda #01
sta &75
__bbcc_00000024: 

\ JmpZero
lda &74
bne __bbcc_00000025
jmp __bbcc_00000006
__bbcc_00000025: 

\ Jmp
jmp __bbcc_00000005

\ Label
__bbcc_00000006: 

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
__bbcc_00000026: 
lsr &75
ror &74
bcc __bbcc_00000027
clc
lda &76
adc &78
sta &78
lda #0
adc &79
sta &79
__bbcc_00000027: clc
asl &76
dex
bne __bbcc_00000026

\ Add
clc
ldy #&02
lda (&8E),Y
adc &78
sta &72
ldy #&03
lda (&8E),Y
adc &79
sta &73

\ SetAt
lda &72
sta &74
lda &73
sta &75
lda #&00
ldy #&00
sta (&74),Y
lda #&00
ldy #&01
sta (&74),Y

\ CallFunction
ldy #&02
lda (&8E),Y
jsr _bbcc_pusha
ldy #&03
lda (&8E),Y
jsr _bbcc_pusha
ldy #&04
lda (&8E),Y
jsr _bbcc_pusha
ldy #&05
lda (&8E),Y
jsr _bbcc_pusha
ldy #&06
lda (&8E),Y
jsr _bbcc_pusha
ldy #&07
lda (&8E),Y
jsr _bbcc_pusha
ldy #&08
lda (&8E),Y
jsr _bbcc_pusha
ldy #&09
lda (&8E),Y
jsr _bbcc_pusha
jsr __reverse
clc
lda &8E
adc #&08
sta &8E
lda &8F
adc #&00
sta &8F

\ Return
lda #&00
sta &70
pla
sta &7B
pla
sta &7A
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
pla
sta &73
pla
sta &72
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
__bbcc_00000028: 
lsr &71
ror &70
bcc __bbcc_00000029
clc
lda &72
adc &74
sta &74
lda &73
adc &75
sta &75
__bbcc_00000029: clc
asl &72
rol &73
dex
bne __bbcc_00000028

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
