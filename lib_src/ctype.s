.export isupper
.export islower
.export isalpha
.export isdigit
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
bcc __bbcc_00000007
__bbcc_00000006: lda #01
sta &74
__bbcc_00000007: 

\ JmpZero
lda &74
bne __bbcc_00000008
jmp __bbcc_00000000
__bbcc_00000008: 

\ LessEqualCmp
lda #00
sta &74
ldy #&00
lda (&8E),Y
cmp #&5A
bcc __bbcc_00000009
bne __bbcc_0000000a
__bbcc_00000009: lda #01
sta &74
__bbcc_0000000a: 

\ JmpZero
lda &74
bne __bbcc_0000000b
jmp __bbcc_00000000
__bbcc_0000000b: 

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
bcc __bbcc_0000000d
__bbcc_0000000c: lda #01
sta &74
__bbcc_0000000d: 

\ JmpZero
lda &74
bne __bbcc_0000000e
jmp __bbcc_00000002
__bbcc_0000000e: 

\ LessEqualCmp
lda #00
sta &74
ldy #&00
lda (&8E),Y
cmp #&7A
bcc __bbcc_0000000f
bne __bbcc_00000010
__bbcc_0000000f: lda #01
sta &74
__bbcc_00000010: 

\ JmpZero
lda &74
bne __bbcc_00000011
jmp __bbcc_00000002
__bbcc_00000011: 

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
beq __bbcc_00000012
__bbcc_00000012: jmp __bbcc_00000004
__bbcc_00000013: 

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

\ JmpNotZero
lda &70
beq __bbcc_00000014
__bbcc_00000014: jmp __bbcc_00000004
__bbcc_00000015: 

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

\ Set
ldy #&00
lda (&8E),Y
sta &72
lda #0
sta &73

\ Set

\ Sub
sec
lda &72
sbc #&30
sta &70

\ LessEqualCmp
lda #00
sta &72
lda &70
cmp #&09
bcc __bbcc_00000016
bne __bbcc_00000017
__bbcc_00000016: lda #01
sta &72
__bbcc_00000017: 

\ Return
lda &72
sta &70
pla
sta &73
pla
sta &72
rts
