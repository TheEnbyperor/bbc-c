.import putchar
.import getchar
.export main
\ Function: main
main:
	push %r11
	mov %r13, %r11
\ Set
	mov #97, %r0
\ CallFunction
	push %r0
	call [putchar]
	add #2, %r13
\ Return
	mov #0, %r0
	mov %r11, %r13
	pop %r11
	ret