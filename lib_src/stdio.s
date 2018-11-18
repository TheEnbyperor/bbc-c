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
__bbcc_00000020:
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
__bbcc_00000021:
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
	jmp [__bbcc_00000022]
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
__bbcc_00000022:
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
	mov #105, %r0
// CallFunction
	push %r0
	call [putchar]
	add #4, %r14
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
	mov #105, %r0
// CallFunction
	push %r0
	call [putchar]
	add #4, %r14
// Add
	mov DWORD 8[%r12], %r0
	add #48, %r0
// Set
// CallFunction
	push %r0
	call [putchar]
	add #4, %r14
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
// Set
	mov #97, %r0
// CallFunction
	push %r0
	call [putchar]
	add #4, %r14
// Label
__bbcc_0000000c:
// MoreEqualJmp
	mov 20[%r12], %r0
	cmp %r2, %r0
	jge [__bbcc_0000000e]
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
// Label
__bbcc_0000000d:
// Jmp
	jmp [__bbcc_0000000c]
// Label
__bbcc_0000000e:
// JmpZero
	cmp #0, %r3
	jze [__bbcc_0000000f]
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
__bbcc_0000000f:
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
__bbcc_00000023:
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
__bbcc_00000010:
// ReadAt
	mov DWORD 8[%r12], %r0
	mov BYTE [%r0], %r0
// Set
	mov %r0, %r4
// JmpZero
	cmp #0, %r0
	jze [__bbcc_00000012]
// NotEqualJmp
	cmp #37, %r4
	jnz [__bbcc_00000013]
// Set
	mov #0, %r0
// Set
	mov %r0, %r3
// Set
	mov #48, %r0
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
// NotEqualJmp
	cmp #48, %r4
	jnz [__bbcc_00000014]
// Set
	mov #49, %r0
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
// NotEqualJmp
	cmp #0, %r4
	jnz [__bbcc_00000015]
// Jmp
	jmp [__bbcc_00000012]
// Label
__bbcc_00000015:
// Set
	mov %r4, %r0
// CallFunction
	push %r0
	call [isdigit]
	add #4, %r14
// JmpZero
	cmp #0, %r0
	jze [__bbcc_00000016]
// Set
	mov %r4, %r0
// Sub
	sub #48, %r0
// Set
	mov %r0, %r3
// Label
__bbcc_00000016:
// Inc
	inc 8[%r12]
// ReadAt
	mov DWORD 8[%r12], %r0
	mov BYTE [%r0], %r0
// Set
	mov %r0, %r4
// Label
__bbcc_00000014:
// Set
	mov #50, %r0
// CallFunction
	push %r0
	call [putchar]
	add #4, %r14
// NotEqualJmp
	cmp #0, %r4
	jnz [__bbcc_00000017]
// Jmp
	jmp [__bbcc_00000012]
// Jmp
	jmp [__bbcc_00000018]
// Label
__bbcc_00000017:
// NotEqualJmp
	cmp #99, %r4
	jnz [__bbcc_00000019]
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
	jmp [__bbcc_00000011]
// Jmp
	jmp [__bbcc_0000001a]
// Label
__bbcc_00000019:
// NotEqualJmp
	cmp #115, %r4
	jnz [__bbcc_0000001b]
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
	jmp [__bbcc_00000011]
// Jmp
	jmp [__bbcc_0000001c]
// Label
__bbcc_0000001b:
// NotEqualJmp
	cmp #117, %r4
	jnz [__bbcc_0000001d]
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
// Set
	mov #51, %r0
// CallFunction
	push %r0
	call [putchar]
	add #4, %r14
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
	jmp [__bbcc_00000011]
// Jmp
	jmp [__bbcc_0000001e]
// Label
__bbcc_0000001d:
// NotEqualJmp
	cmp #100, %r4
	jnz [__bbcc_0000001f]
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
	jmp [__bbcc_00000011]
// Label
__bbcc_0000001f:
// Label
__bbcc_0000001e:
// Label
__bbcc_0000001c:
// Label
__bbcc_0000001a:
// Label
__bbcc_00000018:
// Set
	mov %r4, %r0
// CallFunction
	push %r0
	call [putchar]
	add #4, %r14
// Label
__bbcc_00000013:
// Set
	mov %r4, %r0
// CallFunction
	push %r0
	call [putchar]
	add #4, %r14
// Inc
	inc %r1
// Label
__bbcc_00000011:
// Inc
	inc 8[%r12]
// Jmp
	jmp [__bbcc_00000010]
// Label
__bbcc_00000012:
// Return
	mov #0, %r0
__bbcc_00000024:
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