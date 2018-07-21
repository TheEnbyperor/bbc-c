.import putchar
.import getchar
.import puts
.export main
__bbcc_00000003:
.byte #126,#32,#62,#0
\ Function: main
main:
	push %r11
	mov %r13, %r11
	push %r1
\ AddrOf
	lea WORD [__bbcc_00000003], %r0
\ Set
\ CallFunction
	push %r0
	call [puts]
	add #2, %r13
\ Label
__bbcc_00000000:
\ JmpZero
\ CallFunction
	call [getchar]
\ Set
\ Set
	mov %r0, %r1
\ EqualCmp
	mov #1, %r0
	cmp #27, %r1
	jze [__bbcc_00000004]
	mov #0, %r0
__bbcc_00000004:
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_00000002]
\ Jmp
	jmp [__bbcc_00000001]
\ Label
__bbcc_00000002:
\ Set
	mov %r1, %r0
\ CallFunction
	push %r0
	call [putchar]
	add #2, %r13
\ Jmp
	jmp [__bbcc_00000000]
\ Label
__bbcc_00000001:
\ Return
	mov #0, %r0
	pop %r1
	mov %r11, %r13
	pop %r11
	ret