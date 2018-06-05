.export putchar
.export getchar
.export osbyte
.export fgets

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

