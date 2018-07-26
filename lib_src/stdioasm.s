.export putchar
.export getchar

putchar:
    mov 2[%r13], %r0
    calln $FFEE, %r0
    cmp #10, %r0
    jne _putchar
    mov #13, %r0
    calln $FFEE, %r0
_putchar:
    ret

getchar:
    calln $FFE0, %r0
    cmp #27, %r0
    jne _getchar_1
    mov #$7E, %r1
    calln $FFF4, %r1
    jmp _getchar_2
_getchar_1:
    cmp #13, %r0
    jne _getchar_2
    mov #10, %r0
_getchar_2:
    ret
