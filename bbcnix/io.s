.export writeio
.export readio

writeio:
    mov 4[%r14], %r0
    mov 4[%r14], %r1
    mov6502 %r0, [%r1]
    ret

readio:
    mov 4[%r14], %r0
    mov6502 [%r0], %r0
    ret