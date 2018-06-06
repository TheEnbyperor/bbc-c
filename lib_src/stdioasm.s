.export putchar
.export getchar

putchar:
ldy #00
lda (&8E),Y
jsr &FFEE
sta &70
cmp #10
bne __putchar_1
lda #13
jsr &FFEE
__putchar_1:
rts

getchar:
jsr &FFE0
sta &70
rts

