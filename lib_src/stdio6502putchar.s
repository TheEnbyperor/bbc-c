jsr &FFEE
cmp #10
bne _putchar
lda #13
jsr &FFEE
_putchar:
rts

