.export putchar
.export getchar

putchar:
    mov 2[%r13], %r0
    calln $FFEE, %r0
    ret

getchar:
    calln $FFE0, %r0
    ret
