.export __putchar
.export __getchar
.export __osbyte
.export __fgets

__putchar:
ldy #00
lda (&8E),Y
jsr &FFEE
sta &70
rts

__getchar:
jsr &FFE0
sta &70
rts

__osbyte:
lda &71
pha
ldy #02
lda (&8E),Y
sta &71
ldy #01
lda (&8E),Y
tax
ldy #00
lda (&8E),Y
ldy &71
jsr &FFF4
pla
sta &70
rts

__fgets:
lda #0
sta &72
sta &73
__fgets_1:
lda &73
ldy #3
cmp (&8E),Y
bcc __fgets_2
bne __fgets_3
lda &72
ldy #2
cmp (&8E),Y
bcs __fgets_3
__fgets_2:
jsr __getchar
lda &70
ldy #0
sta (&8E),Y
clc
lda (&8E),Y
adc #1
sta (&8E),Y
ldy #1
lda (&8E),Y
adc #0
sta (&8E),Y
inc &72
bne __fgets_4
inc &73
__fgets_4:
jmp __fgets_1
__fgets_3:
rts

