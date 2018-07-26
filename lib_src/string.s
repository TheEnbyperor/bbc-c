.export strlen
.export strrev
.export strcmp
.export backspace
.export append
\ Function: strlen
strlen:
	push %r11
	mov %r13, %r11
	push %r1
\ Set
	mov #0, %r1
\ Label
__bbcc_00000000:
\ Add
	mov %r1, %r0
	add WORD 4[%r11], %r0
\ ReadAt
	mov BYTE [%r0], %r0
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
\ Function: strrev
strrev:
	push %r11
	mov %r13, %r11
	push %r1
	push %r2
	push %r3
	push %r4
\ Set
	mov #0, %r3
\ Set
	mov WORD 4[%r11], %r0
\ CallFunction
	push %r0
	call [strlen]
	add #2, %r13
\ Sub
	sub #1, %r0
\ Set
	mov %r0, %r4
\ Label
__bbcc_00000002:
\ LessThanCmp
	mov #1, %r0
	cmp %r3, %r4
	jl [__bbcc_00000008]
	mov #0, %r0
__bbcc_00000008:
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_00000003]
\ Add
	mov %r3, %r0
	add WORD 4[%r11], %r0
\ ReadAt
	mov BYTE [%r0], %r0
\ Set
	mov %r0, %r2
\ Add
	mov %r4, %r0
	add WORD 4[%r11], %r0
\ ReadAt
	mov BYTE [%r0], %r1
\ Add
	mov %r3, %r0
	add WORD 4[%r11], %r0
\ SetAt
	mov %r1, BYTE [%r0]
\ Add
	mov %r4, %r0
	add WORD 4[%r11], %r0
\ SetAt
	mov %r2, BYTE [%r0]
\ Inc
	inc %r3
\ Dec
	dec %r4
\ Jmp
	jmp [__bbcc_00000002]
\ Label
__bbcc_00000003:
\ Return
	mov #0, %r0
	pop %r4
	pop %r3
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
\ Function: strcmp
strcmp:
	push %r11
	mov %r13, %r11
	push %r1
	push %r2
	push %r3
\ Set
	mov #0, %r2
\ Label
__bbcc_00000004:
\ Add
	mov %r2, %r0
	add WORD 4[%r11], %r0
\ ReadAt
	mov BYTE [%r0], %r3
\ Add
	mov %r2, %r0
	add WORD 6[%r11], %r0
\ ReadAt
	mov BYTE [%r0], %r1
\ EqualCmp
	mov #1, %r0
	cmp %r3, %r1
	jze [__bbcc_00000009]
	mov #0, %r0
__bbcc_00000009:
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_00000005]
\ Add
	mov %r2, %r0
	add WORD 4[%r11], %r0
\ ReadAt
	mov BYTE [%r0], %r1
\ EqualCmp
	mov #1, %r0
	cmp #0, %r1
	jze [__bbcc_0000000a]
	mov #0, %r0
__bbcc_0000000a:
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_00000006]
\ Return
	mov #0, %r0
	pop %r3
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
\ Label
__bbcc_00000006:
\ Set
	mov %r2, %r0
\ Inc
	inc %r2
\ Jmp
	jmp [__bbcc_00000004]
\ Label
__bbcc_00000005:
\ Add
	mov %r2, %r0
	add WORD 4[%r11], %r0
\ Add
	mov %r2, %r1
	add WORD 6[%r11], %r1
\ ReadAt
	mov BYTE [%r0], %r0
\ ReadAt
	mov BYTE [%r1], %r1
\ Sub
	sub %r1, %r0
\ Return
	pop %r3
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
\ Function: backspace
backspace:
	push %r11
	mov %r13, %r11
	push %r1
\ Set
	mov WORD 4[%r11], %r0
\ CallFunction
	push %r0
	call [strlen]
	add #2, %r13
\ Set
\ Sub
	sub #1, %r0
\ Add
	mov %r0, %r1
	add WORD 4[%r11], %r1
\ Set
	mov #0, %r0
\ SetAt
	mov %r0, BYTE [%r1]
\ Return
	mov #0, %r0
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
\ Function: append
append:
	push %r11
	mov %r13, %r11
	push %r1
	push %r2
	push %r3
\ Set
	mov WORD 4[%r11], %r0
\ CallFunction
	push %r0
	call [strlen]
	add #2, %r13
\ Set
	mov %r0, %r2
\ Add
	mov #1, %r1
	add %r2, %r1
\ MoreEqualCmp
	mov 6[%r11], %r3
	mov #1, %r0
	cmp %r1, %r3
	jge [__bbcc_0000000b]
	mov #0, %r0
__bbcc_0000000b:
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_00000007]
\ Return
	mov #0, %r0
	pop %r3
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
\ Label
__bbcc_00000007:
\ Add
	mov %r2, %r0
	add WORD 4[%r11], %r0
\ SetAt
	mov 8[%r11], %r1
	mov %r1, BYTE [%r0]
\ Add
	mov #1, %r0
	add %r2, %r0
\ Add
	mov %r0, %r1
	add WORD 4[%r11], %r1
\ Set
	mov #0, %r0
\ SetAt
	mov %r0, BYTE [%r1]
\ Return
	mov #0, %r0
	pop %r3
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret