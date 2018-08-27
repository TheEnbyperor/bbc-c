.export strlen
.export strrev
.export strcmp
.export memcmp
.export memset
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
\ ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 4[%r11], %r0
	add %r1, %r0
	mov BYTE [%r0], %r0
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_00000001]
\ Add
	mov #1, %r0
	add %r1, %r0
\ Set
	mov %r0, %r1
\ Jmp
	jmp [__bbcc_00000000]
\ Label
__bbcc_00000001:
\ Return
	mov %r1, %r0
__bbcc_00000011:
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
	push %r5
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
\ Label
__bbcc_00000002:
\ MoreEqualJmp
	cmp %r3, %r0
	jge [__bbcc_00000004]
\ ReadAt
	mov WORD 4[%r11], %r1
	mov WORD 4[%r11], %r1
	add %r3, %r1
	mov BYTE [%r1], %r1
\ Set
	mov %r1, %r2
\ ReadAt
	mov WORD 4[%r11], %r1
	mov WORD 4[%r11], %r1
	add %r0, %r1
	mov BYTE [%r1], %r1
\ SetAt
	mov 4[%r11], %r4
	mov %r4, %r5
	add %r3, %r5
	mov %r1, BYTE [%r5]
\ SetAt
	mov 4[%r11], %r1
	mov %r1, %r4
	add %r0, %r4
	mov %r2, BYTE [%r4]
\ Label
__bbcc_00000003:
\ Add
	mov #1, %r1
	add %r3, %r1
\ Set
	mov %r1, %r3
\ Sub
	sub #1, %r0
\ Set
\ Jmp
	jmp [__bbcc_00000002]
\ Label
__bbcc_00000004:
\ Return
	mov #0, %r0
__bbcc_00000013:
	pop %r5
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
\ Set
	mov #0, %r2
\ Label
__bbcc_00000005:
\ ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 4[%r11], %r0
	add %r2, %r0
	mov BYTE [%r0], %r1
\ ReadAt
	mov WORD 6[%r11], %r0
	mov WORD 6[%r11], %r0
	add %r2, %r0
	mov BYTE [%r0], %r0
\ NotEqualJmp
	cmp %r1, %r0
	jnz [__bbcc_00000007]
\ ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 4[%r11], %r0
	add %r2, %r0
	mov BYTE [%r0], %r0
\ NotEqualJmp
	cmp #0, %r0
	jnz [__bbcc_00000008]
\ Return
	mov #0, %r0
	jmp [__bbcc_00000014]
\ Label
__bbcc_00000008:
\ Label
__bbcc_00000006:
\ Add
	mov #1, %r0
	add %r2, %r0
\ Set
	mov %r0, %r2
\ Jmp
	jmp [__bbcc_00000005]
\ Label
__bbcc_00000007:
\ ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 4[%r11], %r0
	add %r2, %r0
	mov BYTE [%r0], %r0
\ ReadAt
	mov WORD 6[%r11], %r1
	mov WORD 6[%r11], %r1
	add %r2, %r1
	mov BYTE [%r1], %r1
\ Sub
	sub %r1, %r0
\ Return
__bbcc_00000014:
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
\ Function: memcmp
memcmp:
	push %r11
	mov %r13, %r11
	push %r1
	push %r2
	push %r3
	push %r4
\ Set
	mov WORD 4[%r11], %r0
\ Set
	mov %r0, %r4
\ Set
	mov WORD 6[%r11], %r0
\ Set
	mov %r0, %r3
\ Set
	mov #0, %r0
\ Set
	mov %r0, %r1
\ Label
__bbcc_00000009:
\ ReadAt
	mov %r4, %r0
	add %r1, %r0
	mov BYTE [%r0], %r2
\ ReadAt
	mov %r3, %r0
	add %r1, %r0
	mov BYTE [%r0], %r0
\ NotEqualJmp
	cmp %r2, %r0
	jnz [__bbcc_0000000b]
\ Set
	mov #1, %r2
\ Add
	mov %r1, %r0
	add %r2, %r0
\ NotEqualJmp
	cmp 8[%r11], %r0
	jnz [__bbcc_0000000c]
\ Return
	mov #0, %r0
	jmp [__bbcc_00000015]
\ Label
__bbcc_0000000c:
\ Label
__bbcc_0000000a:
\ Add
	mov #1, %r0
	add %r1, %r0
\ Set
	mov %r0, %r1
\ Jmp
	jmp [__bbcc_00000009]
\ Label
__bbcc_0000000b:
\ ReadAt
	mov %r4, %r0
	add %r1, %r0
	mov BYTE [%r0], %r0
\ ReadAt
	mov %r3, %r2
	add %r1, %r2
	mov BYTE [%r2], %r1
\ Sub
	sub %r1, %r0
\ Return
__bbcc_00000015:
	pop %r4
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
	mov %r0, %r1
\ Label
__bbcc_0000000d:
\ MoreEqualJmp
	mov 8[%r11], %r0
	cmp %r1, %r0
	jae [__bbcc_0000000f]
\ SetAt
	mov 4[%r11], %r0
	mov %r0, %r2
	add %r1, %r2
	mov 6[%r11], %r0
	mov %r0, BYTE [%r2]
\ Label
__bbcc_0000000e:
\ Add
	mov #1, %r0
	add %r1, %r0
\ Set
	mov %r0, %r1
\ Jmp
	jmp [__bbcc_0000000d]
\ Label
__bbcc_0000000f:
\ Return
	mov #0, %r0
__bbcc_00000017:
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
	push %r3
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
	mov %r2, %r3
	add %r0, %r3
	mov %r1, BYTE [%r3]
\ Return
	mov #0, %r0
__bbcc_00000018:
	pop %r3
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
	mov %r0, %r1
\ Add
	mov %r1, %r0
	add #1, %r0
\ LessThanJmp
	mov 6[%r11], %r2
	cmp %r0, %r2
	jl [__bbcc_00000010]
\ Return
	mov #0, %r0
	jmp [__bbcc_00000019]
\ Label
__bbcc_00000010:
\ SetAt
	mov 4[%r11], %r0
	mov %r0, %r2
	add %r1, %r2
	mov 8[%r11], %r0
	mov %r0, BYTE [%r2]
\ Add
	add #1, %r1
\ Set
	mov #0, %r0
\ SetAt
	mov 4[%r11], %r2
	mov %r2, %r3
	add %r1, %r3
	mov %r0, BYTE [%r3]
\ Return
	mov #0, %r0
__bbcc_00000019:
	pop %r3
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret