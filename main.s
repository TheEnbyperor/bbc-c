.import putchar
.import getchar
.import fputs
.import puts
.import malloc
.import free
.import realloc
.import strlen
.import strrev
.import strcmp
.import memset
.import backspace
.import append
.export main
__bbcc_00000000:
.byte #36,#32,#0
key_buffer:
.byte #0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
\ Function: main
main:
	push %r11
	mov %r13, %r11
\ AddrOf
	lea WORD [__bbcc_00000000], %r0
\ Set
\ CallFunction
	push %r0
	call [fputs]
	add #2, %r13
\ Return
	mov #0, %r0
__bbcc_00000001:
	mov %r11, %r13
	pop %r11
	ret