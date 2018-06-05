.export putchar
.export getchar

putchar:
ldy #00
lda (&8E),Y
jsr &FFE3
sta &70
rts

getchar:
jsr &FFE0
sta &70
rts

