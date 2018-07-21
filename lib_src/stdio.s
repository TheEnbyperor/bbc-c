.import putchar
.import getchar
.import itoa
.import strlen
.import strrev
.export puts
.export printf
\ Function: _puts
_puts:
	push %r11
	mov %r13, %r11
\ Label
__bbcc_00000000:
\ ReadAt
	mov WORD 2[%r11], %r0
	mov BYTE [%r0], %r0
\ Set
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_00000001]
\ Set
\ CallFunction
	push %r0
	call [putchar]
	add #2, %r13
\ Inc
\ Jmp
	jmp [__bbcc_00000000]
\ Label
__bbcc_00000001:
\ Return
	mov #0, %r0
	mov %r11, %r13
	pop %r11
	ret
\ Function: puts
puts:
	push %r11
	mov %r13, %r11
\ Set
	mov WORD 2[%r11], %r0
\ CallFunction
	push %r0
	call [_puts]
	add #2, %r13
\ Set
	mov #10, %r0
\ CallFunction
	push %r0
	call [putchar]
	add #2, %r13
\ Return
	mov #0, %r0
	mov %r11, %r13
	pop %r11
	ret
\ Function: printf
printf:
	push %r11
	mov %r13, %r11
	push %r1
	push %r2
	push %r3
	push %r4
	push %r5
\ AddrOf
	lea WORD 2[%r11], %r1
\ Add
	mov #2, %r0
	add %r1, %r0
\ Set
\ Set
	mov %r0, %r3
\ Label
__bbcc_00000002:
\ ReadAt
	mov WORD 2[%r11], %r0
	mov BYTE [%r0], %r0
\ Set
	mov %r0, %r4
\ JmpZero
	cmp #0, %r4
	jze [__bbcc_00000003]
\ EqualCmp
	mov #1, %r0
	cmp #37, %r4
	jze [__bbcc_0000000c]
	mov #0, %r0
__bbcc_0000000c:
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_00000004]
\ Inc
\ ReadAt
	mov WORD 2[%r11], %r0
	mov BYTE [%r0], %r0
\ Set
	mov %r0, %r4
\ EqualCmp
	mov #1, %r0
	cmp #0, %r4
	jze [__bbcc_0000000e]
	mov #0, %r0
__bbcc_0000000e:
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_00000005]
\ Jmp
	jmp [__bbcc_00000003]
\ Label
__bbcc_00000005:
\ EqualCmp
	mov #1, %r0
	cmp #99, %r4
	jze [__bbcc_0000000f]
	mov #0, %r0
__bbcc_0000000f:
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_00000006]
\ Set
	mov %r3, %r0
\ ReadAt
	mov BYTE [%r0], %r0
\ Set
	mov %r0, %r1
\ Add
	mov #1, %r0
	add %r3, %r0
\ Set
	mov %r0, %r3
\ Set
	mov %r1, %r0
\ CallFunction
	push %r0
	call [putchar]
	add #2, %r13
\ Inc
	inc %r2
\ Jmp
	jmp [__bbcc_00000002]
\ Label
__bbcc_00000006:
\ EqualCmp
	mov #1, %r0
	cmp #115, %r4
	jze [__bbcc_00000011]
	mov #0, %r0
__bbcc_00000011:
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_00000007]
\ Set
	mov %r3, %r0
\ ReadAt
	mov WORD [%r0], %r0
\ Set
\ Set
	mov %r0, %r1
\ Add
	mov #2, %r0
	add %r3, %r0
\ Set
	mov %r0, %r3
\ Set
	mov %r1, %r0
\ CallFunction
	push %r0
	call [_puts]
	add #2, %r13
\ Set
	mov %r1, %r0
\ CallFunction
	push %r0
	call [strlen]
	add #2, %r13
	mov %r0, %r1
\ Add
	mov %r1, %r0
	add %r2, %r0
\ Set
	mov %r0, %r2
\ Jmp
	jmp [__bbcc_00000002]
\ Label
__bbcc_00000007:
\ Set
	mov #0, %r1
\ EqualCmp
	mov #1, %r0
	cmp #105, %r4
	jze [__bbcc_00000012]
	mov #0, %r0
__bbcc_00000012:
\ JmpNotZero
	cmp #0, %r0
	jnz [__bbcc_00000008]
\ EqualCmp
	mov #1, %r0
	cmp #100, %r4
	jze [__bbcc_00000013]
	mov #0, %r0
__bbcc_00000013:
\ JmpNotZero
	cmp #0, %r0
	jnz [__bbcc_00000008]
\ Jmp
	jmp [__bbcc_00000009]
\ Label
__bbcc_00000008:
\ Set
	mov #1, %r1
\ Label
__bbcc_00000009:
\ JmpZero
	cmp #0, %r1
	jze [__bbcc_0000000a]
\ AddrOf
	lea WORD 6[%r11], %r1
\ Set
	mov #0, %r0
\ SetAt
	mov %r0, BYTE [%r1]
\ Inc
	inc %r1
\ SetAt
	mov #0, %r0
	mov %r0, BYTE [%r1]
\ Inc
	inc %r1
\ SetAt
	mov #0, %r0
	mov %r0, BYTE [%r1]
\ Inc
	inc %r1
\ SetAt
	mov #0, %r0
	mov %r0, BYTE [%r1]
\ Inc
	inc %r1
\ SetAt
	mov #0, %r0
	mov %r0, BYTE [%r1]
\ Inc
	inc %r1
\ SetAt
	mov #0, %r0
	mov %r0, BYTE [%r1]
\ Set
	mov %r3, %r0
\ ReadAt
	mov WORD [%r0], %r0
\ Set
	mov %r0, %r5
\ Add
	mov #2, %r0
	add %r3, %r0
\ Set
	mov %r0, %r3
\ AddrOf
	lea WORD 6[%r11], %r0
\ Set
\ CallFunction
	push %r0
	push %r5
	call [itoa]
	add #4, %r13
\ AddrOf
	lea WORD 6[%r11], %r0
\ Set
\ CallFunction
	push %r0
	call [_puts]
	add #2, %r13
\ AddrOf
	lea WORD 6[%r11], %r0
\ Set
\ CallFunction
	push %r0
	call [strlen]
	add #2, %r13
	mov %r0, %r1
\ Add
	mov %r1, %r0
	add %r5, %r0
\ Set
	mov %r0, %r5
\ Jmp
	jmp [__bbcc_00000002]
\ Label
__bbcc_0000000a:
\ Set
	mov %r4, %r0
\ CallFunction
	push %r0
	call [putchar]
	add #2, %r13
\ Label
__bbcc_00000004:
\ Set
	mov %r4, %r0
\ CallFunction
	push %r0
	call [putchar]
	add #2, %r13
\ Inc
	inc %r2
\ Inc
\ Jmp
	jmp [__bbcc_00000002]
\ Label
__bbcc_00000003:
\ Return
	mov #0, %r0
	pop %r5
	pop %r4
	pop %r3
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret