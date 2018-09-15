.export strlen
.export strrev
.export strcmp
.export memcmp
.export memset
.export memcpy
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
__bbcc_00000012:
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
__bbcc_00000013:
	pop %r5
	pop %r4
	pop %r3
	pop %r2
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: strcmp
strcmp:
	push %r12
	mov %r14, %r12
	push %r1
	push %r2
// Set
	mov #0, %r2
// Label
__bbcc_00000005:
// ReadAt
	mov DWORD 8[%r12], %r0
	mov DWORD 8[%r12], %r0
	add %r2, %r0
	mov BYTE [%r0], %r1
// ReadAt
	mov DWORD 12[%r12], %r0
	mov DWORD 12[%r12], %r0
	add %r2, %r0
	mov BYTE [%r0], %r0
// NotEqualJmp
	cmp %r1, %r0
	jnz [__bbcc_00000007]
// ReadAt
	mov DWORD 8[%r12], %r0
	mov DWORD 8[%r12], %r0
	add %r2, %r0
	mov BYTE [%r0], %r0
// NotEqualJmp
	cmp #0, %r0
	jnz [__bbcc_00000008]
// Return
	mov #0, %r0
	jmp [__bbcc_00000014]
// Label
__bbcc_00000008:
// Label
__bbcc_00000006:
// Inc
	inc %r2
// Jmp
	jmp [__bbcc_00000005]
// Label
__bbcc_00000007:
// ReadAt
	mov DWORD 8[%r12], %r0
	mov DWORD 8[%r12], %r0
	add %r2, %r0
	mov BYTE [%r0], %r0
// ReadAt
	mov DWORD 12[%r12], %r1
	mov DWORD 12[%r12], %r1
	add %r2, %r1
	mov BYTE [%r1], %r1
// Sub
	sub %r1, %r0
// Return
__bbcc_00000014:
	pop %r2
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: memcmp
memcmp:
	push %r12
	mov %r14, %r12
	push %r1
	push %r2
	push %r3
	push %r4
// Set
	mov DWORD 8[%r12], %r0
// Set
	mov %r0, %r4
// Set
	mov DWORD 12[%r12], %r0
// Set
	mov %r0, %r3
// Set
	mov #0, %r0
// Set
	mov %r0, %r1
// Label
__bbcc_00000009:
// ReadAt
	mov %r4, %r0
	add %r1, %r0
	mov BYTE [%r0], %r2
// ReadAt
	mov %r3, %r0
	add %r1, %r0
	mov BYTE [%r0], %r0
// NotEqualJmp
	cmp %r2, %r0
	jnz [__bbcc_0000000b]
// Set
	mov #1, %r2
// Add
	mov %r1, %r0
	add %r2, %r0
// NotEqualJmp
	cmp 16[%r12], %r0
	jnz [__bbcc_0000000c]
// Return
	mov #0, %r0
	jmp [__bbcc_00000015]
// Label
__bbcc_0000000c:
// Label
__bbcc_0000000a:
// Inc
	inc %r1
// Jmp
	jmp [__bbcc_00000009]
// Label
__bbcc_0000000b:
// ReadAt
	mov %r4, %r0
	add %r1, %r0
	mov BYTE [%r0], %r0
// ReadAt
	mov %r3, %r2
	add %r1, %r2
	mov BYTE [%r2], %r1
// Sub
	sub %r1, %r0
// Return
__bbcc_00000015:
	pop %r4
	pop %r3
	pop %r2
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: memset
memset:
	push %r12
	mov %r14, %r12
	push %r1
	push %r2
// Set
	mov #0, %r0
// Set
// Label
__bbcc_0000000d:
// MoreEqualJmp
	mov 16[%r12], %r1
	cmp %r0, %r1
	jae [__bbcc_0000000f]
// SetAt
	mov 8[%r12], %r1
	mov %r1, %r2
	add %r0, %r2
	mov 12[%r12], %r1
	mov %r1, BYTE [%r2]
// Label
__bbcc_0000000e:
// Inc
	inc %r0
// Jmp
	jmp [__bbcc_0000000d]
// Label
__bbcc_0000000f:
// Return
	mov #0, %r0
__bbcc_00000016:
	pop %r2
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: memcpy
memcpy:
	push %r12
	mov %r14, %r12
	push %r1
	push %r2
// Label
__bbcc_00000010:
// Dec
	dec 16[%r12]
// Set
	mov DWORD 12[%r12], %r0
// ReadAt
	add DWORD 16[%r12], %r0
	mov BYTE [%r0], %r1
// Set
	mov DWORD 8[%r12], %r0
// SetAt
	mov %r0, %r2
	add DWORD 16[%r12], %r2
	mov %r1, BYTE [%r2]
// LessEqualJmp
	mov #0, %r0
	cmp 16[%r12], %r0
	jle [__bbcc_00000011]
// Jmp
	jmp [__bbcc_00000010]
// Label
__bbcc_00000011:
// Return
	mov DWORD 8[%r12], %r0
__bbcc_00000017:
	pop %r2
	pop %r1
	mov %r12, %r14
	pop %r12
	ret