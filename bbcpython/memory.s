.import free
.import realloc
.export initArray
.export writeArray
.export popArray
.export freeArray
.export growCapacity
.export shrinkCapacity
.export reallocate
// Function: initArray
initArray:
	push %r12
	mov %r14, %r12
	push %r1
// Set
	mov #0, %r0
// SetAt
	mov 8[%r12], %r1
	mov %r0, DWORD 8[%r1]
// Add
	mov DWORD 8[%r12], %r1
// Set
	mov #0, %r0
// SetAt
	mov %r0, DWORD 4[%r1]
// Add
	mov DWORD 8[%r12], %r1
// Set
	mov #0, %r0
// SetAt
	mov %r0, DWORD [%r1]
// Return
	mov #0, %r0
__bbcc_0000000d:
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: writeArray
writeArray:
	push %r12
	mov %r14, %r12
	push %r1
	push %r2
	push %r3
	push %r4
	push %r5
// Add
	mov DWORD 8[%r12], %r2
// Add
	mov DWORD 8[%r12], %r0
// ReadAt
	mov DWORD [%r0], %r0
// Set
	mov #1, %r1
// Add
	add %r1, %r0
// ReadAt
	mov DWORD 4[%r2], %r1
// MoreEqualJmp
	cmp %r1, %r0
	jae [__bbcc_00000000]
// Add
	mov DWORD 8[%r12], %r0
// ReadAt
	mov DWORD 4[%r0], %r0
// Set
// Set
// CallFunction
	push %r0
	call [growCapacity]
	add #4, %r14
// Add
	mov DWORD 8[%r12], %r1
// Set
// SetAt
	mov %r0, DWORD 4[%r1]
// ReadAt
	mov DWORD 8[%r12], %r0
	mov DWORD 8[%r0], %r0
// Set
	mov %r0, %r1
// Add
	mov DWORD 8[%r12], %r0
// ReadAt
	mov DWORD 4[%r0], %r0
// Mult
	mul DWORD 12[%r12], %r0
// CallFunction
	push %r0
	push %r1
	call [reallocate]
	add #8, %r14
// Set
// SetAt
	mov 8[%r12], %r1
	mov %r0, DWORD 8[%r1]
// Label
__bbcc_00000000:
// Add
	mov DWORD 8[%r12], %r0
// ReadAt
	mov DWORD [%r0], %r0
// Mult
	mul DWORD 12[%r12], %r0
// Set
	mov %r0, %r1
// Set
	mov #0, %r0
// Set
	mov %r0, %r4
// Label
__bbcc_00000001:
// MoreEqualJmp
	mov 12[%r12], %r0
	cmp %r4, %r0
	jae [__bbcc_00000003]
// Set
	mov DWORD 16[%r12], %r0
// Set
	mov %r4, %r2
// Add
	add %r2, %r0
// ReadAt
	mov BYTE [%r0], %r3
// ReadAt
	mov DWORD 8[%r12], %r0
	mov DWORD 8[%r0], %r2
// Add
	mov %r1, %r0
	add %r4, %r0
// SetAt
	mov %r2, %r5
	add %r0, %r5
	mov %r3, BYTE [%r5]
// Label
__bbcc_00000002:
// Inc
	inc %r4
// Jmp
	jmp [__bbcc_00000001]
// Label
__bbcc_00000003:
// Add
	mov DWORD 8[%r12], %r2
// ReadAt
	mov DWORD [%r2], %r0
// Set
	mov %r0, %r1
// Add
	add #1, %r0
// SetAt
	mov %r0, DWORD [%r2]
// Return
	mov #0, %r0
__bbcc_0000000e:
	pop %r5
	pop %r4
	pop %r3
	pop %r2
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: popArray
popArray:
	push %r12
	mov %r14, %r12
	push %r1
	push %r2
	push %r3
	push %r4
// Add
	mov DWORD 8[%r12], %r2
// ReadAt
	mov DWORD [%r2], %r0
// Set
	mov %r0, %r1
// Sub
	sub #1, %r0
// SetAt
	mov %r0, DWORD [%r2]
// Add
	mov DWORD 8[%r12], %r0
// ReadAt
	mov DWORD [%r0], %r0
// Mult
	mul DWORD 12[%r12], %r0
// Set
	mov %r0, %r1
// Set
	mov #0, %r0
// Set
	mov %r0, %r4
// Label
__bbcc_00000004:
// MoreEqualJmp
	mov 12[%r12], %r0
	cmp %r4, %r0
	jae [__bbcc_00000006]
// ReadAt
	mov DWORD 8[%r12], %r0
	mov DWORD 8[%r0], %r2
// Add
	mov %r1, %r0
	add %r4, %r0
// ReadAt
	add %r0, %r2
	mov BYTE [%r2], %r3
// Set
	mov DWORD 16[%r12], %r0
// Set
	mov %r4, %r2
// Add
	add %r2, %r0
// SetAt
	mov %r3, BYTE [%r0]
// Label
__bbcc_00000005:
// Inc
	inc %r4
// Jmp
	jmp [__bbcc_00000004]
// Label
__bbcc_00000006:
// Add
	mov DWORD 8[%r12], %r0
// ReadAt
	mov DWORD 4[%r0], %r0
// Set
// Set
	mov %r0, %r2
// Add
	mov DWORD 8[%r12], %r0
// ReadAt
	mov DWORD [%r0], %r0
// Set
// CallFunction
	push %r0
	push %r2
	call [shrinkCapacity]
	add #8, %r14
// Add
	mov DWORD 8[%r12], %r1
// Set
// SetAt
	mov %r0, DWORD 4[%r1]
// Add
	mov DWORD 8[%r12], %r0
// ReadAt
	mov DWORD 4[%r0], %r0
// EqualJmp
	cmp %r0, %r2
	jze [__bbcc_00000007]
// ReadAt
	mov DWORD 8[%r12], %r0
	mov DWORD 8[%r0], %r0
// Set
	mov %r0, %r1
// Add
	mov DWORD 8[%r12], %r0
// ReadAt
	mov DWORD 4[%r0], %r0
// Mult
	mul DWORD 12[%r12], %r0
// CallFunction
	push %r0
	push %r1
	call [reallocate]
	add #8, %r14
// Set
// SetAt
	mov 8[%r12], %r1
	mov %r0, DWORD 8[%r1]
// Label
__bbcc_00000007:
// Return
	mov #0, %r0
__bbcc_0000000f:
	pop %r4
	pop %r3
	pop %r2
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: freeArray
freeArray:
	push %r12
	mov %r14, %r12
	push %r1
// ReadAt
	mov DWORD 8[%r12], %r0
	mov DWORD 8[%r0], %r0
// Set
	mov %r0, %r1
// Set
	mov #0, %r0
// CallFunction
	push %r0
	push %r1
	call [reallocate]
	add #8, %r14
// Set
	mov DWORD 8[%r12], %r0
// CallFunction
	push %r0
	call [initArray]
	add #4, %r14
// Return
	mov #0, %r0
__bbcc_00000010:
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: growCapacity
growCapacity:
	push %r12
	mov %r14, %r12
// MoreEqualJmp
	mov #8, %r0
	cmp 8[%r12], %r0
	jge [__bbcc_00000008]
// Set
	mov #8, %r0
// Jmp
	jmp [__bbcc_00000009]
// Label
__bbcc_00000008:
// Add
	mov DWORD 8[%r12], %r0
	add #8, %r0
// Set
// Label
__bbcc_00000009:
// Return
__bbcc_00000011:
	mov %r12, %r14
	pop %r12
	ret
// Function: shrinkCapacity
shrinkCapacity:
	push %r12
	mov %r14, %r12
	push %r1
// Sub
	mov DWORD 8[%r12], %r0
	sub #8, %r0
// MoreEqualJmp
	mov 12[%r12], %r1
	cmp %r0, %r1
	jge [__bbcc_0000000a]
// Set
	mov DWORD 8[%r12], %r0
// Jmp
	jmp [__bbcc_0000000b]
// Label
__bbcc_0000000a:
// Sub
	mov DWORD 8[%r12], %r0
	sub #8, %r0
// Set
// Label
__bbcc_0000000b:
// Return
__bbcc_00000012:
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: reallocate
reallocate:
	push %r12
	mov %r14, %r12
	push %r1
// NotEqualJmp
	mov #0, %r0
	cmp 12[%r12], %r0
	jnz [__bbcc_0000000c]
// Set
	mov DWORD 8[%r12], %r0
// CallFunction
	push %r0
	call [free]
	add #4, %r14
// Return
	mov #0, %r0
	jmp [__bbcc_00000013]
// Label
__bbcc_0000000c:
// Set
	mov DWORD 8[%r12], %r0
// CallFunction
	mov DWORD 12[%r12], %r1
	push %r1
	push %r0
	call [realloc]
	add #8, %r14
// Return
__bbcc_00000013:
	pop %r1
	mov %r12, %r14
	pop %r12
	ret