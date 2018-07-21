.export putchar
.export getchar

\ 6520 code to handle putchar newline correctly
_putchar:
    .byte #$20, #$EE, #$FF, #$C9, #$0A, #$D0, #$05, #$A9, #$0D, #$20, #$EE, #$FF, #$60

\ 6502 code to acknowledge escape condition on getchar
_getchar:
    .byte #$20, #$E0, #$FF, #$90, #$0B, #$C9, #$1B, #$D0, #$0D, #$48, #$A9, #$7E, #$20, #$F4, #$FF, #$68, #$C9, #$0D,
     #$D0, #$02, #$A9, #$0A, #$60

putchar:
    mov 2[%r13], %r0
    calln _putchar, %r0
    ret

getchar:
    calln _getchar, %r0
    ret
