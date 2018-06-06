.export printf
.import _bbcc_pusha
.import _bbcc_pulla
.import putchar

\ Function
printf: 
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
sta &72
lda &73
adc #&00
sta &73

\ Set

\ Set
ldy #&00
lda (&8E),Y
sta &74
ldy #&01
lda (&8E),Y
sta &75

\ Label
__bbcc_00000000: 

\ ReadAt
lda &75
sta &77
lda &74
sta &76
ldy #&00
lda (&76),Y
sta &76

\ Set

\ JmpZero
lda &76
bne __bbcc_00000004
jmp __bbcc_00000001
__bbcc_00000004: 

\ EqualCmp
lda #00
sta &78
lda &76
cmp #&25
bne __bbcc_00000005
lda #01
sta &78
__bbcc_00000005: 

\ JmpZero
lda &78
bne __bbcc_00000006
jmp __bbcc_00000002
__bbcc_00000006: 

\ Add
clc
lda &74
adc #&01
sta &74
lda &75
adc #0
sta &75

\ ReadAt
lda &75
sta &79
lda &74
sta &78
ldy #&00
lda (&78),Y
sta &76

\ Set

\ EqualCmp
lda #00
sta &78
lda &76
cmp #&73
bne __bbcc_00000007
lda #01
sta &78
__bbcc_00000007: 

\ JmpZero
lda &78
bne __bbcc_00000008
jmp __bbcc_00000003
__bbcc_00000008: 

\ Set
lda &72
sta &7A
lda &73
sta &7B

\ Set

\ Add
clc
lda &72
adc #&02
sta &72
lda &73
adc #&00
sta &73

\ Set

\ Set
lda &7A
sta &72
lda &7B
sta &73

\ CallFunction
lda &73
jsr _bbcc_pusha
lda &72
jsr _bbcc_pusha
jsr printf
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
jmp __bbcc_00000000

\ Label
__bbcc_00000003: 

\ Label
__bbcc_00000002: 

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

\ Add
clc
lda &74
adc #&01
sta &74
lda &75
adc #0
sta &75

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
sta &77
pla
sta &76
pla
sta &7B
pla
sta &7A
pla
sta &73
pla
sta &72
pla
sta &79
pla
sta &78
pla
sta &75
pla
sta &74
rts
