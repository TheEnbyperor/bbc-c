.export strlen
.export strrev
.export strcmp
.export memset
.export backspace
.export append
\ Function: strlen
strlen:
	push %r11
	mov %r13, %r11
	push %r1
\ Set
	mov #0, %r0
\ Label
__bbcc_00000000:
\ ReadAt
	mov WORD 4[%r11], %r1
	mov WORD 4[%r11], %r1
	add %r0, %r1
	mov BYTE [%r1], %r1
\ JmpZero
	cmp #0, %r1
	jze [__bbcc_00000001]
\ Add
	add #1, %r0
\ Set
\ Jmp
	jmp [__bbcc_00000000]
\ Label
__bbcc_00000001:
\ Return
__bbcc_0000000d:
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
	mov #0, %r1
\ Set
	mov WORD 4[%r11], %r0
\ CallFunction
	push %r0
	call [strlen]
	add #2, %r13
\ Sub
	sub #1, %r0
\ Set
	mov %r0, %r3
\ Label
__bbcc_00000002:
\ LessThanCmp
	mov #1, %r0
	cmp %r1, %r3
	jl [__bbcc_0000000e]
	mov #0, %r0
__bbcc_0000000e:
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_00000004]
\ ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 4[%r11], %r0
	add %r1, %r0
	mov BYTE [%r0], %r0
\ Set
	mov %r0, %r2
\ ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 4[%r11], %r0
	add %r3, %r0
	mov BYTE [%r0], %r0
\ SetAt
	mov 4[%r11], %r4
	add %r1, %r4
	mov %r0, BYTE [%r4]
\ SetAt
	mov 4[%r11], %r0
	add %r3, %r0
	mov %r2, BYTE [%r0]
\ Label
__bbcc_00000003:
\ Add
	add #1, %r1
\ Set
\ Sub
	mov #1, %r0
	sub %r3, %r0
\ Set
	mov %r0, %r3
\ Jmp
	jmp [__bbcc_00000002]
\ Label
__bbcc_00000004:
\ Return
	mov #0, %r0
__bbcc_0000000f:
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
__bbcc_00000005:
\ ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 4[%r11], %r0
	add %r1, %r0
	mov BYTE [%r0], %r3
\ ReadAt
	mov WORD 6[%r11], %r0
	mov WORD 6[%r11], %r0
	add %r1, %r0
	mov BYTE [%r0], %r2
\ EqualCmp
	mov #1, %r0
	cmp %r3, %r2
	jze [__bbcc_00000010]
	mov #0, %r0
__bbcc_00000010:
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_00000007]
\ ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 4[%r11], %r0
	add %r1, %r0
	mov BYTE [%r0], %r2
\ EqualCmp
	mov #1, %r0
	cmp #0, %r2
	jze [__bbcc_00000011]
	mov #0, %r0
__bbcc_00000011:
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_00000008]
\ Return
	mov #0, %r0
	jmp [__bbcc_00000012]
\ Label
__bbcc_00000008:
\ Label
__bbcc_00000006:
\ Set
	mov %r1, %r0
\ Add
	add #1, %r1
\ Set
\ Jmp
	jmp [__bbcc_00000005]
\ Label
__bbcc_00000007:
\ ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 4[%r11], %r0
	add %r1, %r0
	mov BYTE [%r0], %r0
\ ReadAt
	mov WORD 6[%r11], %r1
	mov WORD 6[%r11], %r1
	add %r1, %r1
	mov BYTE [%r1], %r1
\ Sub
	sub %r1, %r0
\ Return
__bbcc_00000012:
	pop %r3
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
\ Function: memset
memset:
	push %r11
	mov %r13, %r11
	push %r1
	push %r2
\ Set
	mov #0, %r0
\ Set
\ Label
__bbcc_00000009:
\ LessThanCmp
	mov 8[%r11], %r2
	mov #1, %r1
	cmp %r0, %r2
	jb [__bbcc_00000013]
	mov #0, %r1
__bbcc_00000013:
\ JmpZero
	cmp #0, %r1
	jze [__bbcc_0000000b]
\ SetAt
	mov 4[%r11], %r1
	add %r0, %r1
	mov 6[%r11], %r2
	mov %r2, BYTE [%r1]
\ Label
__bbcc_0000000a:
\ Add
	add #1, %r0
\ Set
\ Jmp
	jmp [__bbcc_00000009]
\ Label
__bbcc_0000000b:
\ Return
	mov #0, %r0
__bbcc_00000014:
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
	push %r2
\ Set
	mov WORD 4[%r11], %r0
\ CallFunction
	push %r0
	call [strlen]
	add #2, %r13
\ Set
\ Sub
	sub #1, %r0
\ Set
	mov #0, %r1
\ SetAt
	mov 4[%r11], %r2
	add %r0, %r2
	mov %r1, BYTE [%r2]
\ Return
	mov #0, %r0
__bbcc_00000015:
	pop %r2
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
	jge [__bbcc_00000016]
	mov #0, %r0
__bbcc_00000016:
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_0000000c]
\ Return
	mov #0, %r0
	jmp [__bbcc_00000017]
\ Label
__bbcc_0000000c:
\ SetAt
	mov 4[%r11], %r0
	add %r2, %r0
	mov 8[%r11], %r1
	mov %r1, BYTE [%r0]
\ Add
	mov #1, %r1
	add %r2, %r1
\ Set
	mov #0, %r0
\ SetAt
	mov 4[%r11], %r2
	add %r1, %r2
	mov %r0, BYTE [%r2]
\ Return
	mov #0, %r0
__bbcc_00000017:
	pop %r3
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret