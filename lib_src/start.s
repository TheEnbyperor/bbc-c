.import main
.export _start

_start:
    mov #$7C00, %r13
    call main
    exit