.export strlen
.export strrev
.export itoa
.export main
// Function: strlen
strlen:
	push %r12
	mov %r14, %r12
	push %r1
// Set
	mov #0, %r1
// Label
__bbcc_00000000:
// ReadAt
	mov DWORD 8[%r12], %r0
	mov DWORD 8[%r12], %r0
	add %r1, %r0
	mov BYTE [%r0], %r0
// JmpZero
	cmp #0, %r0
	jze [__bbcc_00000001]
// Inc
	inc %r1
// Jmp
	jmp [__bbcc_00000000]
// Label
__bbcc_00000001:
// Return
	mov %r1, %r0
__bbcc_00000007:
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: strrev
strrev:
	push %r12
	mov %r14, %r12
	push %r1
	push %r2
	push %r3
	push %r4
	push %r5
// Set
	mov #0, %r3
// Set
	mov DWORD 8[%r12], %r0
// CallFunction
	push %r0
	call [strlen]
	add #4, %r14
// Sub
	sub #1, %r0
// Set
	mov %r0, %r2
// Label
__bbcc_00000002:
// MoreEqualJmp
	cmp %r3, %r2
	jge [__bbcc_00000004]
// ReadAt
	mov DWORD 8[%r12], %r0
	mov DWORD 8[%r12], %r0
	add %r3, %r0
	mov BYTE [%r0], %r0
// Set
	mov %r0, %r1
// ReadAt
	mov DWORD 8[%r12], %r0
	mov DWORD 8[%r12], %r0
	add %r2, %r0
	mov BYTE [%r0], %r0
// SetAt
	mov 8[%r12], %r4
	mov %r4, %r5
	add %r3, %r5
	mov %r0, BYTE [%r5]
// SetAt
	mov 8[%r12], %r0
	mov %r0, %r4
	add %r2, %r4
	mov %r1, BYTE [%r4]
// Label
__bbcc_00000003:
// Inc
	inc %r3
// Dec
	dec %r2
// Jmp
	jmp [__bbcc_00000002]
// Label
__bbcc_00000004:
// Return
	mov #0, %r0
__bbcc_00000008:
	pop %r5
	pop %r4
	pop %r3
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
// Set
	mov #0, %r0
// Set
// Set
	mov #0, %r2
// Label
__bbcc_00000005:
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
	mov 12[%r12], %r3
	mov %r3, %r4
	add %r1, %r4
	mov %r0, BYTE [%r4]
// Div
	mov DWORD 8[%r12], %r0
	div #10, %r0
// Set
	mov %r0, DWORD 8[%r12]
// LessEqualJmp
	mov #0, %r0
	cmp 8[%r12], %r0
	jle [__bbcc_00000006]
// Jmp
	jmp [__bbcc_00000005]
// Label
__bbcc_00000006:
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
__bbcc_00000009:
	pop %r4
	pop %r3
	pop %r2
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: main
main:
	push %r12
	mov %r14, %r12
	sub #20, %r14
	push %r1
	push %r2
	push %r3
// AddrOf
	lea DWORD -20[%r12], %r0
// Set
	mov %r0, %r2
// Set
	mov #1, %r1
// Set
	mov #0, %r0
// CallFunction
	push %r0
	push %r1
	push %r2
	mov #1, %r3
	push %r3
	call [itoa]
	add #16, %r14
// Return
	mov #0, %r0
__bbcc_0000000a:
	pop %r3
	pop %r2
	pop %r1
	mov %r12, %r14
	pop %r12
	ret