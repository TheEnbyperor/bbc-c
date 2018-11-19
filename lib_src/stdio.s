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
__bbcc_0000001f:
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
__bbcc_00000020:
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
	jmp [__bbcc_00000021]
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
__bbcc_00000021:
	pop %r2
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: itoa
itoa:
	push %r12
	mov %r14, %r12
	push %r1
	push %r2
	push %r3
	push %r4
	push %r5
// Set
	mov #0, %r0
// Set
	mov %r0, %r3
// Set
	mov #0, %r0
// JmpNotZero
	mov BYTE 16[%r12], %r1
	cmp #0, %r1
	jnz [__bbcc_00000009]
// MoreEqualJmp
	mov #0, %r1
	cmp 8[%r12], %r1
	jge [__bbcc_00000009]
// Set
	mov #1, %r0
// Label
__bbcc_00000009:
// JmpZero
	cmp #0, %r0
	jze [__bbcc_00000008]
// Set
	mov #1, %r0
// Set
	mov %r0, %r3
// Neg
	mov 8[%r12], %r0
	neg %r0
// Set
	mov %r0, DWORD 8[%r12]
// Label
__bbcc_00000008:
// Set
	mov #0, %r2
// Label
__bbcc_0000000a:
// Mod
	mov DWORD 8[%r12], %r0
	mod #10, %r0
// Add
	add #48, %r0
// Set
	mov %r2, %r1
// Inc
	inc %r2
// Set
// SetAt
	mov 12[%r12], %r4
	mov %r4, %r5
	add %r1, %r5
	mov %r0, BYTE [%r5]
// Div
	mov DWORD 8[%r12], %r0
	div #10, %r0
// Set
	mov %r0, DWORD 8[%r12]
// LessEqualJmp
	mov #0, %r0
	cmp 8[%r12], %r0
	jle [__bbcc_0000000b]
// Jmp
	jmp [__bbcc_0000000a]
// Label
__bbcc_0000000b:
// Label
__bbcc_0000000c:
// MoreEqualJmp
	mov 20[%r12], %r0
	cmp %r2, %r0
	jge [__bbcc_0000000d]
// Set
	mov %r2, %r1
// Inc
	inc %r2
// Set
	mov #48, %r0
// SetAt
	mov 12[%r12], %r4
	mov %r4, %r5
	add %r1, %r5
	mov %r0, BYTE [%r5]
// Jmp
	jmp [__bbcc_0000000c]
// Label
__bbcc_0000000d:
// JmpZero
	cmp #0, %r3
	jze [__bbcc_0000000e]
// Set
	mov %r2, %r1
// Inc
	inc %r2
// Set
	mov #45, %r0
// SetAt
	mov 12[%r12], %r3
	mov %r3, %r4
	add %r1, %r4
	mov %r0, BYTE [%r4]
// Label
__bbcc_0000000e:
// Set
	mov #0, %r0
// SetAt
	mov 12[%r12], %r1
	mov %r1, %r3
	add %r2, %r3
	mov %r0, BYTE [%r3]
// Set
	mov DWORD 12[%r12], %r0
// CallFunction
	push %r0
	call [strrev]
	add #4, %r14
// Return
	mov #0, %r0
__bbcc_00000022:
	pop %r5
	pop %r4
	pop %r3
	pop %r2
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: printf
printf:
	push %r12
	mov %r14, %r12
	sub #24, %r14
	push %r1
	push %r2
	push %r3
	push %r4
	push %r5
	push %r6
	push %r7
// AddrOf
	lea DWORD 8[%r12], %r2
// Set
	mov #1, %r0
// Mult
	mul #4, %r0
// Add
	add %r0, %r2
// Set
	mov %r2, %r0
// Set
	mov %r0, %r5
// Label
__bbcc_0000000f:
// ReadAt
	mov DWORD 8[%r12], %r0
	mov BYTE [%r0], %r0
// Set
	mov %r0, %r4
// JmpZero
	cmp #0, %r0
	jze [__bbcc_00000011]
// NotEqualJmp
	cmp #37, %r4
	jnz [__bbcc_00000012]
// Set
	mov #0, %r0
// Set
	mov %r0, %r3
// Inc
	inc 8[%r12]
// ReadAt
	mov DWORD 8[%r12], %r0
	mov BYTE [%r0], %r0
// Set
	mov %r0, %r4
// NotEqualJmp
	cmp #48, %r4
	jnz [__bbcc_00000013]
// Inc
	inc 8[%r12]
// ReadAt
	mov DWORD 8[%r12], %r0
	mov BYTE [%r0], %r0
// Set
	mov %r0, %r4
// NotEqualJmp
	cmp #0, %r4
	jnz [__bbcc_00000014]
// Jmp
	jmp [__bbcc_00000011]
// Label
__bbcc_00000014:
// Set
	mov %r4, %r0
// CallFunction
	push %r0
	call [isdigit]
	add #4, %r14
// JmpZero
	cmp #0, %r0
	jze [__bbcc_00000015]
// Set
	mov %r4, %r0
// Sub
	sub #48, %r0
// Set
	mov %r0, %r3
// Label
__bbcc_00000015:
// Set
	mov %r3, %r0
// Add
	add #48, %r0
// Set
// CallFunction
	push %r0
	call [putchar]
	add #4, %r14
// Inc
	inc 8[%r12]
// ReadAt
	mov DWORD 8[%r12], %r0
	mov BYTE [%r0], %r0
// Set
	mov %r0, %r4
// Label
__bbcc_00000013:
// NotEqualJmp
	cmp #0, %r4
	jnz [__bbcc_00000016]
// Jmp
	jmp [__bbcc_00000011]
// Jmp
	jmp [__bbcc_00000017]
// Label
__bbcc_00000016:
// NotEqualJmp
	cmp #99, %r4
	jnz [__bbcc_00000018]
// Set
	mov %r5, %r0
// ReadAt
	mov BYTE [%r0], %r0
// Set
	mov %r0, %r6
// Set
	mov %r5, %r0
// Set
	mov #4, %r2
// Add
	add %r2, %r0
// Set
// Set
	mov %r0, %r5
// Set
	mov %r6, %r0
// CallFunction
	push %r0
	call [putchar]
	add #4, %r14
// Inc
	inc %r1
// Jmp
	jmp [__bbcc_00000010]
// Jmp
	jmp [__bbcc_00000019]
// Label
__bbcc_00000018:
// NotEqualJmp
	cmp #115, %r4
	jnz [__bbcc_0000001a]
// Set
	mov %r5, %r0
// ReadAt
	mov DWORD [%r0], %r0
// Set
// Set
	mov %r0, %r6
// Set
	mov %r5, %r0
// Set
	mov #4, %r2
// Add
	add %r2, %r0
// Set
// Set
	mov %r0, %r5
// Set
	mov %r6, %r0
// CallFunction
	push %r0
	call [fputs]
	add #4, %r14
// Set
	mov %r6, %r0
// CallFunction
	push %r0
	call [strlen]
	add #4, %r14
// Add
	add %r0, %r1
// Set
// Jmp
	jmp [__bbcc_00000010]
// Jmp
	jmp [__bbcc_0000001b]
// Label
__bbcc_0000001a:
// NotEqualJmp
	cmp #117, %r4
	jnz [__bbcc_0000001c]
// Set
	mov %r5, %r0
// ReadAt
	mov DWORD [%r0], %r0
// Set
	mov %r0, %r2
// Set
	mov %r5, %r0
// Set
	mov #4, %r5
// Add
	add %r5, %r0
// Set
// Set
	mov %r0, %r5
// AddrOf
	lea DWORD -24[%r12], %r0
// Set
	mov %r0, %r7
// Set
	mov #1, %r6
// Set
	mov %r3, %r0
// CallFunction
	push %r0
	push %r6
	push %r7
	push %r2
	call [itoa]
	add #16, %r14
// AddrOf
	lea DWORD -24[%r12], %r0
// Set
// CallFunction
	push %r0
	call [fputs]
	add #4, %r14
// AddrOf
	lea DWORD -24[%r12], %r0
// Set
// CallFunction
	push %r0
	call [strlen]
	add #4, %r14
// Add
	add %r0, %r2
// Set
// Jmp
	jmp [__bbcc_00000010]
// Jmp
	jmp [__bbcc_0000001d]
// Label
__bbcc_0000001c:
// NotEqualJmp
	cmp #100, %r4
	jnz [__bbcc_0000001e]
// Set
	mov %r5, %r0
// ReadAt
	mov DWORD [%r0], %r0
// Set
	mov %r0, %r2
// Set
	mov %r5, %r0
// Set
	mov #4, %r5
// Add
	add %r5, %r0
// Set
// Set
	mov %r0, %r5
// AddrOf
	lea DWORD -24[%r12], %r0
// Set
	mov %r0, %r7
// Set
	mov #0, %r6
// Set
	mov %r3, %r0
// CallFunction
	push %r0
	push %r6
	push %r7
	push %r2
	call [itoa]
	add #16, %r14
// AddrOf
	lea DWORD -24[%r12], %r0
// Set
// CallFunction
	push %r0
	call [fputs]
	add #4, %r14
// AddrOf
	lea DWORD -24[%r12], %r0
// Set
// CallFunction
	push %r0
	call [strlen]
	add #4, %r14
// Add
	add %r0, %r2
// Set
// Jmp
	jmp [__bbcc_00000010]
// Label
__bbcc_0000001e:
// Label
__bbcc_0000001d:
// Label
__bbcc_0000001b:
// Label
__bbcc_00000019:
// Label
__bbcc_00000017:
// Set
	mov %r4, %r0
// CallFunction
	push %r0
	call [putchar]
	add #4, %r14
// Label
__bbcc_00000012:
// Set
	mov %r4, %r0
// CallFunction
	push %r0
	call [putchar]
	add #4, %r14
// Inc
	inc %r1
// Label
__bbcc_00000010:
// Inc
	inc 8[%r12]
// Jmp
	jmp [__bbcc_0000000f]
// Label
__bbcc_00000011:
// Return
	mov #0, %r0
__bbcc_00000023:
	pop %r7
	pop %r6
	pop %r5
	pop %r4
	pop %r3
	pop %r2
	pop %r1
	mov %r12, %r14
	pop %r12
	ret