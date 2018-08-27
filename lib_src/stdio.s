.import putchar
.import getchar
.import strlen
.import strrev
.import isdigit
.export printf
.export fputs
.export puts
.export gets
.export itoa
\ Function: fputs
fputs:
	push %r11
	mov %r13, %r11
\ Label
__bbcc_00000000:
\ ReadAt
	mov WORD 4[%r11], %r0
	mov BYTE [%r0], %r0
\ Set
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_00000002]
\ Set
\ CallFunction
	push %r0
	call [putchar]
	add #2, %r13
\ Label
__bbcc_00000001:
\ Add
	mov #1, %r0
	add WORD 4[%r11], %r0
\ Set
	mov %r0, WORD 4[%r11]
\ Jmp
	jmp [__bbcc_00000000]
\ Label
__bbcc_00000002:
\ Return
	mov #0, %r0
__bbcc_00000020:
	mov %r11, %r13
	pop %r11
	ret
\ Function: puts
puts:
	push %r11
	mov %r13, %r11
\ Set
	mov WORD 4[%r11], %r0
\ CallFunction
	push %r0
	call [fputs]
	add #2, %r13
\ Set
	mov #10, %r0
\ CallFunction
	push %r0
	call [putchar]
	add #2, %r13
\ Return
	mov #0, %r0
__bbcc_00000021:
	mov %r11, %r13
	pop %r11
	ret
\ Function: gets
gets:
	push %r11
	mov %r13, %r11
	push %r1
	push %r2
	push %r3
\ Set
	mov WORD 4[%r11], %r0
\ Set
	mov %r0, %r2
\ Label
__bbcc_00000003:
\ Sub
	mov WORD 6[%r11], %r0
	sub #1, %r0
\ Set
	mov %r0, WORD 6[%r11]
\ LessEqualJmp
	mov #0, %r0
	cmp 6[%r11], %r0
	jle [__bbcc_00000004]
\ CallFunction
	call [getchar]
\ Set
\ Set
	mov %r0, %r1
\ NotEqualJmp
	cmp #3, %r1
	jnz [__bbcc_00000005]
\ Return
	mov #0, %r0
	jmp [__bbcc_00000022]
\ Label
__bbcc_00000005:
\ Set
	mov %r1, %r0
\ CallFunction
	push %r0
	call [putchar]
	add #2, %r13
\ NotEqualJmp
	cmp #8, %r1
	jnz [__bbcc_00000006]
\ Sub
	sub #1, %r2
\ Set
\ Set
	mov #0, %r0
\ SetAt
	mov %r0, BYTE [%r2]
\ Jmp
	jmp [__bbcc_00000003]
\ Label
__bbcc_00000006:
\ Set
	mov %r2, %r3
\ Add
	mov #1, %r0
	add %r2, %r0
\ Set
	mov %r0, %r2
\ SetAt
	mov %r1, BYTE [%r3]
\ ReadAt
	mov BYTE [%r3], %r0
\ NotEqualJmp
	cmp #10, %r0
	jnz [__bbcc_00000007]
\ Sub
	sub #1, %r1
\ Set
\ Jmp
	jmp [__bbcc_00000004]
\ Label
__bbcc_00000007:
\ Jmp
	jmp [__bbcc_00000003]
\ Label
__bbcc_00000004:
\ Set
	mov #0, %r0
\ SetAt
	mov %r0, BYTE [%r2]
\ Return
	mov WORD 4[%r11], %r0
__bbcc_00000022:
	pop %r3
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
\ Function: itoa
itoa:
	push %r11
	mov %r13, %r11
	push %r1
	push %r2
	push %r3
	push %r4
	push %r5
\ Set
	mov #0, %r0
\ Set
	mov %r0, %r3
\ Set
	mov #0, %r0
\ JmpNotZero
	mov BYTE 8[%r11], %r1
	cmp #0, %r1
	jnz [__bbcc_00000009]
\ MoreEqualJmp
	mov #0, %r1
	cmp 4[%r11], %r1
	jge [__bbcc_00000009]
\ Set
	mov #1, %r0
\ Label
__bbcc_00000009:
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_00000008]
\ Set
	mov #1, %r0
\ Set
	mov %r0, %r3
\ Neg
	mov 4[%r11], %r0
	neg %r0
\ Set
	mov %r0, WORD 4[%r11]
\ Label
__bbcc_00000008:
\ Set
	mov #0, %r2
\ Label
__bbcc_0000000a:
\ Mod
	mov WORD 4[%r11], %r0
	mod #10, %r0
\ Add
	add #48, %r0
\ Set
	mov %r2, %r4
\ Add
	mov #1, %r1
	add %r2, %r1
\ Set
	mov %r1, %r2
\ Set
\ SetAt
	mov 6[%r11], %r1
	mov %r1, %r5
	add %r4, %r5
	mov %r0, BYTE [%r5]
\ Div
	mov WORD 4[%r11], %r0
	div #10, %r0
\ Set
	mov %r0, WORD 4[%r11]
\ LessEqualJmp
	mov #0, %r0
	cmp 4[%r11], %r0
	jle [__bbcc_0000000b]
\ Jmp
	jmp [__bbcc_0000000a]
\ Label
__bbcc_0000000b:
\ Label
__bbcc_0000000c:
\ MoreEqualJmp
	mov 10[%r11], %r0
	cmp %r2, %r0
	jge [__bbcc_0000000e]
\ Set
	mov %r2, %r1
\ Add
	mov #1, %r0
	add %r2, %r0
\ Set
	mov %r0, %r2
\ Set
	mov #48, %r0
\ SetAt
	mov 6[%r11], %r4
	mov %r4, %r5
	add %r1, %r5
	mov %r0, BYTE [%r5]
\ Label
__bbcc_0000000d:
\ Jmp
	jmp [__bbcc_0000000c]
\ Label
__bbcc_0000000e:
\ JmpZero
	cmp #0, %r3
	jze [__bbcc_0000000f]
\ Set
	mov %r2, %r1
\ Add
	mov #1, %r0
	add %r2, %r0
\ Set
	mov %r0, %r2
\ Set
	mov #45, %r0
\ SetAt
	mov 6[%r11], %r3
	mov %r3, %r4
	add %r1, %r4
	mov %r0, BYTE [%r4]
\ Label
__bbcc_0000000f:
\ Set
	mov #0, %r0
\ SetAt
	mov 6[%r11], %r1
	mov %r1, %r3
	add %r2, %r3
	mov %r0, BYTE [%r3]
\ Set
	mov WORD 6[%r11], %r0
\ CallFunction
	push %r0
	call [strrev]
	add #2, %r13
\ Return
	mov #0, %r0
__bbcc_00000025:
	pop %r5
	pop %r4
	pop %r3
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
\ Function: printf
printf:
	push %r11
	mov %r13, %r11
	sub #24, %r13
	push %r1
	push %r2
	push %r3
	push %r4
	push %r5
	push %r6
	push %r7
\ AddrOf
	lea WORD 4[%r11], %r2
\ Set
	mov #1, %r0
\ Mult
	mul #2, %r0
\ Add
	add %r0, %r2
\ Set
	mov %r2, %r0
\ Set
	mov %r0, %r5
\ Label
__bbcc_00000010:
\ ReadAt
	mov WORD 4[%r11], %r0
	mov BYTE [%r0], %r0
\ Set
	mov %r0, %r4
\ JmpZero
	cmp #0, %r4
	jze [__bbcc_00000012]
\ NotEqualJmp
	cmp #37, %r4
	jnz [__bbcc_00000013]
\ Set
	mov #0, %r0
\ Set
	mov %r0, %r3
\ Add
	mov #1, %r0
	add WORD 4[%r11], %r0
\ Set
	mov %r0, WORD 4[%r11]
\ ReadAt
	mov WORD 4[%r11], %r0
	mov BYTE [%r0], %r0
\ Set
	mov %r0, %r4
\ NotEqualJmp
	cmp #48, %r4
	jnz [__bbcc_00000014]
\ Add
	mov #1, %r0
	add WORD 4[%r11], %r0
\ Set
	mov %r0, WORD 4[%r11]
\ ReadAt
	mov WORD 4[%r11], %r0
	mov BYTE [%r0], %r0
\ Set
	mov %r0, %r4
\ NotEqualJmp
	cmp #0, %r4
	jnz [__bbcc_00000015]
\ Jmp
	jmp [__bbcc_00000012]
\ Label
__bbcc_00000015:
\ Set
	mov %r4, %r0
\ CallFunction
	push %r0
	call [isdigit]
	add #2, %r13
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_00000016]
\ Set
	mov %r4, %r0
\ Sub
	sub #48, %r0
\ Set
	mov %r0, %r3
\ Label
__bbcc_00000016:
\ Add
	mov #1, %r0
	add WORD 4[%r11], %r0
\ Set
	mov %r0, WORD 4[%r11]
\ ReadAt
	mov WORD 4[%r11], %r0
	mov BYTE [%r0], %r0
\ Set
	mov %r0, %r4
\ Label
__bbcc_00000014:
\ NotEqualJmp
	cmp #0, %r4
	jnz [__bbcc_00000017]
\ Jmp
	jmp [__bbcc_00000012]
\ Jmp
	jmp [__bbcc_00000018]
\ Label
__bbcc_00000017:
\ NotEqualJmp
	cmp #99, %r4
	jnz [__bbcc_00000019]
\ Set
	mov %r5, %r0
\ ReadAt
	mov BYTE [%r0], %r0
\ Set
	mov %r0, %r6
\ Set
	mov %r5, %r0
\ Set
	mov #2, %r2
\ Add
	add %r2, %r0
\ Set
\ Set
	mov %r0, %r5
\ Set
	mov %r6, %r0
\ CallFunction
	push %r0
	call [putchar]
	add #2, %r13
\ Add
	mov #1, %r0
	add %r1, %r0
\ Set
	mov %r0, %r1
\ Jmp
	jmp [__bbcc_00000011]
\ Jmp
	jmp [__bbcc_0000001a]
\ Label
__bbcc_00000019:
\ NotEqualJmp
	cmp #115, %r4
	jnz [__bbcc_0000001b]
\ Set
	mov %r5, %r0
\ ReadAt
	mov WORD [%r0], %r0
\ Set
\ Set
	mov %r0, %r2
\ Set
	mov %r5, %r0
\ Set
	mov #2, %r5
\ Add
	add %r5, %r0
\ Set
\ Set
	mov %r0, %r5
\ Set
	mov %r2, %r0
\ CallFunction
	push %r0
	call [fputs]
	add #2, %r13
\ Set
	mov %r2, %r0
\ CallFunction
	push %r0
	call [strlen]
	add #2, %r13
\ Add
	add %r0, %r1
\ Set
\ Jmp
	jmp [__bbcc_00000011]
\ Jmp
	jmp [__bbcc_0000001c]
\ Label
__bbcc_0000001b:
\ NotEqualJmp
	cmp #117, %r4
	jnz [__bbcc_0000001d]
\ Set
	mov %r5, %r0
\ ReadAt
	mov WORD [%r0], %r0
\ Set
	mov %r0, %r2
\ Set
	mov %r5, %r0
\ Set
	mov #2, %r5
\ Add
	add %r5, %r0
\ Set
\ Set
	mov %r0, %r5
\ AddrOf
	lea WORD -24[%r11], %r0
\ Set
	mov %r0, %r7
\ Set
	mov #1, %r6
\ Set
	mov %r3, %r0
\ CallFunction
	push %r0
	push %r6
	push %r7
	push %r2
	call [itoa]
	add #8, %r13
\ AddrOf
	lea WORD -24[%r11], %r0
\ Set
\ CallFunction
	push %r0
	call [fputs]
	add #2, %r13
\ AddrOf
	lea WORD -24[%r11], %r0
\ Set
\ CallFunction
	push %r0
	call [strlen]
	add #2, %r13
\ Add
	add %r0, %r2
\ Set
\ Jmp
	jmp [__bbcc_00000011]
\ Jmp
	jmp [__bbcc_0000001e]
\ Label
__bbcc_0000001d:
\ NotEqualJmp
	cmp #100, %r4
	jnz [__bbcc_0000001f]
\ Set
	mov %r5, %r0
\ ReadAt
	mov WORD [%r0], %r0
\ Set
	mov %r0, %r2
\ Set
	mov %r5, %r0
\ Set
	mov #2, %r5
\ Add
	add %r5, %r0
\ Set
\ Set
	mov %r0, %r5
\ AddrOf
	lea WORD -24[%r11], %r0
\ Set
	mov %r0, %r7
\ Set
	mov #0, %r6
\ Set
	mov %r3, %r0
\ CallFunction
	push %r0
	push %r6
	push %r7
	push %r2
	call [itoa]
	add #8, %r13
\ AddrOf
	lea WORD -24[%r11], %r0
\ Set
\ CallFunction
	push %r0
	call [fputs]
	add #2, %r13
\ AddrOf
	lea WORD -24[%r11], %r0
\ Set
\ CallFunction
	push %r0
	call [strlen]
	add #2, %r13
\ Add
	add %r0, %r2
\ Set
\ Jmp
	jmp [__bbcc_00000011]
\ Label
__bbcc_0000001f:
\ Label
__bbcc_0000001e:
\ Label
__bbcc_0000001c:
\ Label
__bbcc_0000001a:
\ Label
__bbcc_00000018:
\ Set
	mov %r4, %r0
\ CallFunction
	push %r0
	call [putchar]
	add #2, %r13
\ Label
__bbcc_00000013:
\ Set
	mov %r4, %r0
\ CallFunction
	push %r0
	call [putchar]
	add #2, %r13
\ Add
	mov #1, %r0
	add %r1, %r0
\ Set
	mov %r0, %r1
\ Label
__bbcc_00000011:
\ Add
	mov #1, %r0
	add WORD 4[%r11], %r0
\ Set
	mov %r0, WORD 4[%r11]
\ Jmp
	jmp [__bbcc_00000010]
\ Label
__bbcc_00000012:
\ Return
	mov #0, %r0
__bbcc_00000026:
	pop %r7
	pop %r6
	pop %r5
	pop %r4
	pop %r3
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret