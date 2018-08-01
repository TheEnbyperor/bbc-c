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
__bbcc_00000008:
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
	mov #0, %r2
\ Set
	mov WORD 4[%r11], %r0
\ CallFunction
	push %r0
	call [strlen]
	add #2, %r13
\ Sub
	sub #1, %r0
\ Set
	mov %r0, %r1
\ Label
__bbcc_00000002:
\ LessThanCmp
	mov #1, %r0
	cmp %r2, %r1
	jl [__bbcc_00000009]
	mov #0, %r0
__bbcc_00000009:
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_00000003]
\ Add
	mov %r2, %r0
	add WORD 4[%r11], %r0
\ ReadAt
	mov BYTE [%r0], %r0
\ Set
	mov %r0, %r4
\ Add
	mov %r1, %r0
	add WORD 4[%r11], %r0
\ ReadAt
	mov BYTE [%r0], %r3
\ Add
	mov %r2, %r0
	add WORD 4[%r11], %r0
\ SetAt
	mov %r3, BYTE [%r0]
\ Add
	mov %r1, %r0
	add WORD 4[%r11], %r0
\ SetAt
	mov %r4, BYTE [%r0]
\ Inc
	inc %r2
\ Dec
	dec %r1
\ Jmp
	jmp [__bbcc_00000002]
\ Label
__bbcc_00000003:
\ Return
	mov #0, %r0
__bbcc_0000000a:
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
	mov #0, %r1
\ Label
__bbcc_00000004:
\ Add
	mov %r1, %r0
	add WORD 4[%r11], %r0
\ ReadAt
	mov BYTE [%r0], %r3
\ Add
	mov %r1, %r0
	add WORD 6[%r11], %r0
\ ReadAt
	mov BYTE [%r0], %r2
\ EqualCmp
	mov #1, %r0
	cmp %r3, %r2
	jze [__bbcc_0000000b]
	mov #0, %r0
__bbcc_0000000b:
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_00000005]
\ Add
	mov %r1, %r0
	add WORD 4[%r11], %r0
\ ReadAt
	mov BYTE [%r0], %r2
\ EqualCmp
	mov #1, %r0
	cmp #0, %r2
	jze [__bbcc_0000000c]
	mov #0, %r0
__bbcc_0000000c:
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_00000006]
\ Return
	mov #0, %r0
	jmp [__bbcc_0000000d]
\ Label
__bbcc_00000006:
\ Set
	mov %r1, %r0
\ Inc
	inc %r1
\ Jmp
	jmp [__bbcc_00000004]
\ Label
__bbcc_00000005:
\ Add
	mov %r1, %r0
	add WORD 4[%r11], %r0
\ Add
	add WORD 6[%r11], %r1
\ ReadAt
	mov BYTE [%r0], %r0
\ ReadAt
	mov BYTE [%r1], %r1
\ Sub
	sub %r1, %r0
\ Return
__bbcc_0000000d:
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
	add WORD 4[%r11], %r0
\ Set
	mov #0, %r1
\ SetAt
	mov %r1, BYTE [%r0]
\ Return
	mov #0, %r0
__bbcc_0000000e:
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
	mov %r0, %r1
\ Add
	mov #1, %r2
	add %r1, %r2
\ MoreEqualCmp
	mov 6[%r11], %r3
	mov #1, %r0
	cmp %r2, %r3
	jge [__bbcc_0000000f]
	mov #0, %r0
__bbcc_0000000f:
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_00000007]
\ Return
	mov #0, %r0
	jmp [__bbcc_00000010]
\ Label
__bbcc_00000007:
\ Add
	mov %r1, %r0
	add WORD 4[%r11], %r0
\ SetAt
	mov 8[%r11], %r2
	mov %r2, BYTE [%r0]
\ Add
	mov #1, %r0
	add %r1, %r0
\ Add
	add WORD 4[%r11], %r0
\ Set
	mov #0, %r1
\ SetAt
	mov %r1, BYTE [%r0]
\ Return
	mov #0, %r0
__bbcc_00000010:
	pop %r3
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret