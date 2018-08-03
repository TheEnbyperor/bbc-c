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
key_buffer:
.byte #0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
\ Function: main
main:
	push %r11
	mov %r13, %r11
	push %r1
	push %r2
\ Set
	mov #30, %r0
\ CallFunction
	push %r0
	call [malloc]
	add #2, %r13
\ Set
\ Set
	mov %r0, %r2
\ Set
	mov %r2, %r1
\ Set
	mov #4, %r0
\ CallFunction
	push %r0
	push %r1
	call [realloc]
	add #4, %r13
\ Set
	mov %r2, %r1
\ Set
	mov #10, %r0
\ CallFunction
	push %r0
	push %r1
	call [realloc]
	add #4, %r13
\ Set
	mov %r2, %r1
\ Set
	mov #40, %r0
\ CallFunction
	push %r0
	push %r1
	call [realloc]
	add #4, %r13
\ Return
	mov #0, %r0
__bbcc_00000000:
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret