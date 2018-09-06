.import main
.export _start

_start:
    mov #$40000, %r14
    call main
    exit