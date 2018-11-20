.import reallocate
.import isObj
.import asObj
.import memcpy
.export objType
.export isString
.export asString
.export asCString
.export takeString
.export copyString
.export freeObjects
// Function: allocateObject
allocateObject:
	push %r12
	mov %r14, %r12
	push %r1
	push %r2
// Set
	mov #0, %r0
// CallFunction
	mov DWORD 8[%r12], %r1
	push %r1
	push %r0
	call [reallocate]
	add #8, %r14
// Set
// Set
// Set
// SetAt
	mov 12[%r12], %r1
	mov %r1, BYTE [%r0]
// ReadAt
	mov DWORD 16[%r12], %r1
	mov DWORD 20[%r1], %r1
// Set
// SetAt
	mov %r1, DWORD 1[%r0]
// Set
	mov %r0, %r1
// SetAt
	mov 16[%r12], %r2
	mov %r1, DWORD 20[%r2]
// Return
__bbcc_00000004:
	pop %r2
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: isObjType
isObjType:
	push %r12
	mov %r14, %r12
	push %r1
// Set
	mov #0, %r1
// Set
	mov DWORD 8[%r12], %r0
// CallFunction
	push %r0
	call [isObj]
	add #4, %r14
// JmpZero
	cmp #0, %r0
	jze [__bbcc_00000000]
// Set
	mov DWORD 8[%r12], %r0
// CallFunction
	push %r0
	call [asObj]
	add #4, %r14
// ReadAt
	mov BYTE [%r0], %r0
// NotEqualJmp
	cmp 12[%r12], %r0
	jnz [__bbcc_00000000]
// Set
	mov #1, %r1
// Label
__bbcc_00000000:
// Return
	mov %r1, %r0
__bbcc_00000005:
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: objType
objType:
	push %r12
	mov %r14, %r12
// Set
	mov DWORD 8[%r12], %r0
// CallFunction
	push %r0
	call [asObj]
	add #4, %r14
// ReadAt
	mov BYTE [%r0], %r0
// Return
__bbcc_00000006:
	mov %r12, %r14
	pop %r12
	ret
// Function: isString
isString:
	push %r12
	mov %r14, %r12
	push %r1
// Set
	mov DWORD 8[%r12], %r1
// Set
	mov #0, %r0
// CallFunction
	push %r0
	push %r1
	call [isObjType]
	add #8, %r14
// Return
__bbcc_00000007:
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: asString
asString:
	push %r12
	mov %r14, %r12
// Set
	mov DWORD 8[%r12], %r0
// CallFunction
	push %r0
	call [asObj]
	add #4, %r14
// Set
// Return
__bbcc_00000008:
	mov %r12, %r14
	pop %r12
	ret
// Function: asCString
asCString:
	push %r12
	mov %r14, %r12
// Set
	mov DWORD 8[%r12], %r0
// CallFunction
	push %r0
	call [asObj]
	add #4, %r14
// Set
// ReadAt
	mov DWORD 9[%r0], %r0
// Return
__bbcc_00000009:
	mov %r12, %r14
	pop %r12
	ret
// Function: allocateString
allocateString:
	push %r12
	mov %r14, %r12
	push %r1
	push %r2
// Set
	mov #0, %r1
// Set
	mov DWORD 16[%r12], %r0
// CallFunction
	push %r0
	push %r1
	mov #13, %r2
	push %r2
	call [allocateObject]
	add #12, %r14
// Set
// Set
// Set
// SetAt
	mov 12[%r12], %r1
	mov %r1, DWORD 5[%r0]
// Set
	mov DWORD 8[%r12], %r1
// SetAt
	mov %r1, DWORD 9[%r0]
// Return
__bbcc_0000000a:
	pop %r2
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: takeString
takeString:
	push %r12
	mov %r14, %r12
	push %r1
	push %r2
// Set
	mov DWORD 8[%r12], %r1
// Set
	mov DWORD 16[%r12], %r0
// CallFunction
	push %r0
	mov DWORD 12[%r12], %r2
	push %r2
	push %r1
	call [allocateString]
	add #12, %r14
// Return
__bbcc_0000000b:
	pop %r2
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: copyString
copyString:
	push %r12
	mov %r14, %r12
	push %r1
	push %r2
	push %r3
// Set
	mov #0, %r1
// Add
	mov DWORD 12[%r12], %r0
	add #1, %r0
// Set
// CallFunction
	push %r0
	push %r1
	call [reallocate]
	add #8, %r14
// Set
	mov %r0, %r1
// Set
// Set
	mov %r1, %r0
// Set
	mov DWORD 8[%r12], %r3
// Set
	mov DWORD 12[%r12], %r2
// CallFunction
	push %r2
	push %r3
	push %r0
	call [memcpy]
	add #12, %r14
// Set
	mov #0, %r0
// SetAt
	mov %r1, %r2
	add DWORD 12[%r12], %r2
	mov %r0, BYTE [%r2]
// Set
// Set
	mov DWORD 16[%r12], %r0
// CallFunction
	push %r0
	mov DWORD 12[%r12], %r2
	push %r2
	push %r1
	call [allocateString]
	add #12, %r14
// Return
__bbcc_0000000c:
	pop %r3
	pop %r2
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: freeObject
freeObject:
	push %r12
	mov %r14, %r12
	push %r1
// ReadAt
	mov DWORD 8[%r12], %r0
	mov BYTE [%r0], %r0
// Set
// NotEqualJmp
	cmp #0, %r0
	jnz [__bbcc_00000001]
// Set
	mov DWORD 8[%r12], %r0
// Set
// Set
// ReadAt
	mov DWORD 9[%r0], %r0
// Set
// Set
	mov #0, %r1
// CallFunction
	push %r1
	push %r0
	call [reallocate]
	add #8, %r14
// Set
	mov DWORD 8[%r12], %r1
// Set
	mov #0, %r0
// CallFunction
	push %r0
	push %r1
	call [reallocate]
	add #8, %r14
// Label
__bbcc_00000001:
// Return
	mov #0, %r0
__bbcc_0000000d:
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: freeObjects
freeObjects:
	push %r12
	mov %r14, %r12
	push %r1
// ReadAt
	mov DWORD 8[%r12], %r0
	mov DWORD 20[%r0], %r1
// Set
// Set
// Label
__bbcc_00000002:
// EqualJmp
	cmp #0, %r1
	jze [__bbcc_00000003]
// ReadAt
	mov DWORD 1[%r1], %r0
// Set
// Set
// Set
// CallFunction
	push %r1
	call [freeObject]
	add #4, %r14
// Set
	mov %r0, %r1
// Set
// Jmp
	jmp [__bbcc_00000002]
// Label
__bbcc_00000003:
// Return
	mov #0, %r0
__bbcc_0000000e:
	pop %r1
	mov %r12, %r14
	pop %r12
	ret