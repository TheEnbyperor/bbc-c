.import putchar
.import getchar
.import malloc
.import free
.import strlen
.import strrev
.import strcmp
.import backspace
.import append
.export fputs
.export puts
.export gets
.export printf
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
	jze [__bbcc_00000001]
\ Set
\ CallFunction
	push %r0
	call [putchar]
	add #2, %r13
\ Inc
	inc 4[%r11]
\ Jmp
	jmp [__bbcc_00000000]
\ Label
__bbcc_00000001:
\ Return
	mov #0, %r0
__bbcc_00000007:
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
__bbcc_00000008:
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
__bbcc_00000002:
\ Dec
	dec 6[%r11]
\ LessThanCmp
	mov #0, %r1
	mov #1, %r0
	cmp 6[%r11], %r1
	jl [__bbcc_00000009]
	mov #0, %r0
__bbcc_00000009:
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_00000003]
\ CallFunction
	call [getchar]
\ Set
	mov %r2, %r1
\ Inc
	inc %r2
\ Set
\ SetAt
	mov %r0, BYTE [%r1]
\ ReadAt
	mov BYTE [%r1], %r1
\ EqualCmp
	mov #1, %r0
	cmp #10, %r1
	jze [__bbcc_0000000a]
	mov #0, %r0
__bbcc_0000000a:
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_00000004]
\ Jmp
	jmp [__bbcc_00000003]
\ Label
__bbcc_00000004:
\ Jmp
	jmp [__bbcc_00000002]
\ Label
__bbcc_00000003:
\ Set
	mov #0, %r0
\ SetAt
	mov %r0, BYTE [%r2]
\ Return
	mov WORD 4[%r11], %r0
__bbcc_0000000b:
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
\ AddrOf
	lea WORD 4[%r11], %r2
\ Add
	mov #2, %r0
	add %r2, %r0
\ Set
\ Set
\ Label
__bbcc_00000005:
\ ReadAt
	mov WORD 4[%r11], %r0
	mov BYTE [%r0], %r0
\ Set
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_00000006]
\ Set
\ CallFunction
	push %r0
	call [putchar]
	add #2, %r13
\ Inc
	inc %r1
\ Inc
	inc 4[%r11]
\ Jmp
	jmp [__bbcc_00000005]
\ Label
__bbcc_00000006:
\ Return
	mov #0, %r0
__bbcc_0000000c:
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret