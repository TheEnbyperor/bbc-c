.import putchar
.import getchar
.import fputs
.import puts
.import malloc
.import strlen
.import strrev
.import strcmp
.import backspace
.import append
.export main
key_buffer:
.byte #0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
\ Function: main
main:
	push %r11
	mov %r13, %r11
\ Set
	mov #4, %r0
\ CallFunction
	push %r0
	call [malloc]
	add #2, %r13
\ Return
	mov #0, %r0
	mov %r11, %r13
	pop %r11
	ret