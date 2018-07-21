jsr &FFE0
bcc _getchar_2
cmp #27
bne _getchar_1
pha
lda #&7E
jsr &FFF4
pla
_getchar_2:
cmp #13
bne _getchar_1
lda #10
_getchar_1:
rts

