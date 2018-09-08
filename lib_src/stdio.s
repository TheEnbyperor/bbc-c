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
// Add
	mov #1, %r0
	add DWORD 8[%r12], %r0
// Set
	mov %r0, DWORD 8[%r12]
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
	push %r3
// Set
	mov DWORD 8[%r12], %r0
// Set
	mov %r0, %r1
// Label
__bbcc_00000003:
// Sub
	mov DWORD 12[%r12], %r0
	sub #1, %r0
// Set
	mov %r0, DWORD 12[%r12]
// LessEqualJmp
	mov #0, %r0
	cmp 12[%r12], %r0
	jle [__bbcc_00000004]
// CallFunction
	call [getchar]
// Set
// Set
	mov %r0, %r3
// NotEqualJmp
	cmp #3, %r3
	jnz [__bbcc_00000005]
// Return
	mov #0, %r0
	jmp [__bbcc_0000000a]
// Label
__bbcc_00000005:
// Set
	mov %r3, %r0
// CallFunction
	push %r0
	call [putchar]
	add #4, %r14
// NotEqualJmp
	cmp #127, %r3
	jnz [__bbcc_00000006]
// Sub
	sub #1, %r1
// Set
// Jmp
	jmp [__bbcc_00000003]
// Label
__bbcc_00000006:
// Set
	mov %r1, %r2
// Add
	mov #1, %r0
	add %r1, %r0
// Set
	mov %r0, %r1
// SetAt
	mov %r3, BYTE [%r2]
// NotEqualJmp
	cmp #10, %r3
	jnz [__bbcc_00000007]
// Sub
	sub #1, %r1
// Set
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
	mov %r0, BYTE [%r1]
// Return
	mov DWORD 8[%r12], %r0
__bbcc_0000000a:
	pop %r3
	pop %r2
	pop %r1
	mov %r12, %r14
	pop %r12
	ret