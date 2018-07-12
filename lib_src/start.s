.import main
.export _start

_start:
    mov #$1800, %r13
    call main
    ret