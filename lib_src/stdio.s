.import putchar
.import getchar
.export fputs
.export puts
.export gets
// Function: fputs
fputs:
	push %r12
	mov %r14, %r12
	push %r1
// Label
__bbcc_00000000:
// ReadAt
	mov DWORD 8[%r12], %r0
	mov BYTE [%r0], %r1
// Set
	mov %r1, %r0
// JmpZero
	cmp #0, %r1
	jze [__bbcc_00000002]
// Set
// CallFunction
	push %r0
	call [putchar]
	add #4, %r14
// Label
__bbcc_00000001:
// Inc
	inc 8[%r12]
// Jmp
	jmp [__bbcc_00000000]
// Label
__bbcc_00000002:
// Return
	mov #0, %r0
__bbcc_00000008:
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: puts
puts:
	push %r12
	mov %r14, %r12
// Set
	mov DWORD 8[%r12], %r0
// CallFunction
	push %r0
	call [fputs]
	add #4, %r14
// Set
	mov #10, %r0
// CallFunction
	push %r0
	call [putchar]
	add #4, %r14
// Return
	mov #0, %r0
__bbcc_00000009:
	mov %r12, %r14
	pop %r12
	ret
// Function: gets
gets:
	push %r12
	mov %r14, %r12
	push %r1
	push %r2
// Set
	mov DWORD 8[%r12], %r0
// Set
	mov %r0, %r2
// Label
__bbcc_00000003:
// Dec
	dec 12[%r12]
// LessEqualJmp
	mov #0, %r0
	cmp 12[%r12], %r0
	jle [__bbcc_00000004]
// CallFunction
	call [getchar]
// Set
// Set
	mov %r0, %r1
// NotEqualJmp
	cmp #3, %r1
	jnz [__bbcc_00000005]
// Return
	mov #0, %r0
	jmp [__bbcc_0000000a]
// Label
__bbcc_00000005:
// Set
	mov %r1, %r0
// CallFunction
	push %r0
	call [putchar]
	add #4, %r14
// NotEqualJmp
	cmp #127, %r1
	jnz [__bbcc_00000006]
// Dec
	dec %r2
// Jmp
	jmp [__bbcc_00000003]
// Label
__bbcc_00000006:
// Set
	mov %r2, %r0
// Inc
	inc %r2
// SetAt
	mov %r1, BYTE [%r0]
// NotEqualJmp
	cmp #10, %r1
	jnz [__bbcc_00000007]
// Dec
	dec %r2
// Jmp
	jmp [__bbcc_00000004]
// Label
__bbcc_00000007:
// Jmp
	jmp [__bbcc_00000003]
// Label
__bbcc_00000004:
// Set
	mov #0, %r0
// SetAt
	mov %r0, BYTE [%r2]
// Return
	mov DWORD 8[%r12], %r0
__bbcc_0000000a:
	pop %r2
	pop %r1
	mov %r12, %r14
	pop %r12
	ret