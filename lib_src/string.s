.export strlen
\ Function: strlen
strlen:
	push %r11
	mov %r13, %r11
	push %r1
\ Set
	mov #0, %r1
\ Label
__bbcc_00000000:
\ Set
	mov WORD 2[%r11], %r0
\ Inc
\ ReadAt
	mov BYTE [%r0], %r0
\ NotEqualCmp
	mov #0, %r0
	cmp #0, %r0
	jze [__bbcc_00000003]
	mov #1, %r0
__bbcc_00000003:
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_00000001]
\ Inc
	inc %r1
\ Jmp
	jmp [__bbcc_00000000]
\ Label
__bbcc_00000001:
\ Return
	mov %r1, %r0
	pop %r1
	mov %r11, %r13
	pop %r11
	ret