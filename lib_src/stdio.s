.import putchar
.import getchar
.import malloc
.import free
.import realloc
.import strlen
.import strrev
.import strcmp
.import memset
.import backspace
.import append
.export printf
.export fputs
.export puts
.export gets
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
	mov WORD 4[%r11], %r0
	add #1, %r0
\ Set
	mov %r0, WORD 4[%r11]
\ Jmp
	jmp [__bbcc_00000000]
\ Label
__bbcc_00000002:
\ Return
	mov #0, %r0
__bbcc_0000000c:
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
__bbcc_0000000d:
	mov %r11, %r13
	pop %r11
	ret
\ Function: gets
gets:
	push %r11
	mov %r13, %r11
	push %r1
	push %r2
\ Label
__bbcc_00000003:
\ Sub
	mov #1, %r0
	sub WORD 6[%r11], %r0
\ Set
	mov %r0, WORD 6[%r11]
\ LessThanCmp
	mov #0, %r2
	mov #1, %r0
	cmp 6[%r11], %r2
	jl [__bbcc_0000000e]
	mov #0, %r0
__bbcc_0000000e:
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_00000004]
\ CallFunction
	call [getchar]
\ Set
	mov %r1, %r2
\ Add
	add #1, %r1
\ Set
\ Set
\ SetAt
	mov %r0, BYTE [%r2]
\ ReadAt
	mov BYTE [%r2], %r2
\ EqualCmp
	mov #1, %r0
	cmp #10, %r2
	jze [__bbcc_0000000f]
	mov #0, %r0
__bbcc_0000000f:
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_00000005]
\ Jmp
	jmp [__bbcc_00000004]
\ Label
__bbcc_00000005:
\ Jmp
	jmp [__bbcc_00000003]
\ Label
__bbcc_00000004:
\ Set
	mov #0, %r0
\ SetAt
	mov %r0, BYTE [%r1]
\ Return
	mov WORD 4[%r11], %r0
__bbcc_00000010:
	pop %r2
	pop %r1
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
\ AddrOf
	lea WORD 4[%r11], %r2
\ Add
	mov #2, %r0
	add %r2, %r0
\ Set
\ Set
	mov %r0, %r2
\ Label
__bbcc_00000006:
\ ReadAt
	mov WORD 4[%r11], %r0
	mov BYTE [%r0], %r0
\ Set
	mov %r0, %r3
\ JmpZero
	cmp #0, %r3
	jze [__bbcc_00000008]
\ EqualCmp
	mov #1, %r0
	cmp #37, %r3
	jze [__bbcc_00000011]
	mov #0, %r0
__bbcc_00000011:
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_00000009]
\ Add
	mov WORD 4[%r11], %r0
	add #1, %r0
\ Set
	mov %r0, WORD 4[%r11]
\ ReadAt
	mov WORD 4[%r11], %r0
	mov BYTE [%r0], %r0
\ Set
	mov %r0, %r3
\ EqualCmp
	mov #1, %r0
	cmp #0, %r3
	jze [__bbcc_00000012]
	mov #0, %r0
__bbcc_00000012:
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_0000000a]
\ Jmp
	jmp [__bbcc_00000008]
\ Label
__bbcc_0000000a:
\ EqualCmp
	mov #1, %r0
	cmp #115, %r3
	jze [__bbcc_00000013]
	mov #0, %r0
__bbcc_00000013:
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_0000000b]
\ Set
	mov %r2, %r0
\ ReadAt
	mov WORD [%r0], %r0
\ Set
\ Set
	mov %r0, %r4
\ Set
\ Set
	mov #2, %r0
\ Add
	add %r2, %r0
\ Set
\ Set
	mov %r0, %r2
\ Set
	mov %r4, %r0
\ CallFunction
	push %r0
	call [fputs]
	add #2, %r13
\ Set
	mov %r4, %r0
\ CallFunction
	push %r0
	call [strlen]
	add #2, %r13
\ Add
	add %r1, %r0
\ Set
	mov %r0, %r1
\ Jmp
	jmp [__bbcc_00000007]
\ Label
__bbcc_0000000b:
\ Set
	mov %r3, %r0
\ CallFunction
	push %r0
	call [putchar]
	add #2, %r13
\ Label
__bbcc_00000009:
\ Set
	mov %r3, %r0
\ CallFunction
	push %r0
	call [putchar]
	add #2, %r13
\ Add
	add #1, %r1
\ Set
\ Label
__bbcc_00000007:
\ Add
	mov WORD 4[%r11], %r0
	add #1, %r0
\ Set
	mov %r0, WORD 4[%r11]
\ Jmp
	jmp [__bbcc_00000006]
\ Label
__bbcc_00000008:
\ Return
	mov #0, %r0
__bbcc_00000014:
	pop %r4
	pop %r3
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret