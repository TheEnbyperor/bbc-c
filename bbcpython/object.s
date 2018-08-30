.import isObj
.import asObj
.import reallocate
.import memcpy
.export objType
.export isString
.export asString
.export asCString
.export takeString
.export copyString
// Function: allocateObject
allocateObject:
	push %r11
	mov %r13, %r11
	push %r1
	push %r2
// Set
	mov #0, %r0
// CallFunction
	mov 4[%r11], %r1
	push %r1
	push %r0
	call [reallocate]
	add #4, %r13
// Set
// Set
// Set
	mov %r0, %r1
// SetAt
	mov 6[%r11], %r0
	mov %r0, BYTE [%r1]
// ReadAt
	mov WORD 8[%r11], %r0
	mov WORD 10[%r0], %r0
// Set
// SetAt
	mov %r0, WORD 1[%r1]
// Set
	mov %r1, %r0
// SetAt
	mov 8[%r11], %r2
	mov %r0, WORD 10[%r2]
// Return
	mov %r1, %r0
__bbcc_00000001:
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: isObjType
isObjType:
	push %r11
	mov %r13, %r11
	push %r1
// Set
	mov #0, %r1
// Set
	mov WORD 4[%r11], %r0
// CallFunction
	push %r0
	call [isObj]
	add #2, %r13
// JmpZero
	cmp #0, %r0
	jze [__bbcc_00000000]
// Set
	mov WORD 4[%r11], %r0
// CallFunction
	push %r0
	call [asObj]
	add #2, %r13
// ReadAt
	mov BYTE [%r0], %r0
// NotEqualJmp
	cmp 6[%r11], %r0
	jnz [__bbcc_00000000]
// Set
	mov #1, %r1
// Label
__bbcc_00000000:
// Return
	mov %r1, %r0
__bbcc_00000002:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: objType
objType:
	push %r11
	mov %r13, %r11
// Set
	mov WORD 4[%r11], %r0
// CallFunction
	push %r0
	call [asObj]
	add #2, %r13
// ReadAt
	mov BYTE [%r0], %r0
// Return
__bbcc_00000003:
	mov %r11, %r13
	pop %r11
	ret
// Function: isString
isString:
	push %r11
	mov %r13, %r11
	push %r1
// Set
	mov WORD 4[%r11], %r1
// Set
	mov #0, %r0
// CallFunction
	push %r0
	push %r1
	call [isObjType]
	add #4, %r13
// Return
__bbcc_00000004:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: asString
asString:
	push %r11
	mov %r13, %r11
// Set
	mov WORD 4[%r11], %r0
// CallFunction
	push %r0
	call [asObj]
	add #2, %r13
// Set
// Return
__bbcc_00000005:
	mov %r11, %r13
	pop %r11
	ret
// Function: asCString
asCString:
	push %r11
	mov %r13, %r11
// Set
	mov WORD 4[%r11], %r0
// CallFunction
	push %r0
	call [asObj]
	add #2, %r13
// Set
// ReadAt
	mov WORD 5[%r0], %r0
// Return
__bbcc_00000006:
	mov %r11, %r13
	pop %r11
	ret
// Function: allocateString
allocateString:
	push %r11
	mov %r13, %r11
	push %r1
	push %r2
// Set
	mov #0, %r1
// Set
	mov WORD 8[%r11], %r0
// CallFunction
	push %r0
	push %r1
	mov #7, %r2
	push %r2
	call [allocateObject]
	add #6, %r13
// Set
// Set
// Set
	mov %r0, %r1
// SetAt
	mov 6[%r11], %r0
	mov %r0, WORD 3[%r1]
// Set
	mov WORD 4[%r11], %r0
// SetAt
	mov %r0, WORD 5[%r1]
// Return
	mov %r1, %r0
__bbcc_00000007:
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: takeString
takeString:
	push %r11
	mov %r13, %r11
	push %r1
	push %r2
// Set
	mov WORD 4[%r11], %r1
// Set
	mov WORD 8[%r11], %r0
// CallFunction
	push %r0
	mov 6[%r11], %r2
	push %r2
	push %r1
	call [allocateString]
	add #6, %r13
// Return
__bbcc_00000008:
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: copyString
copyString:
	push %r11
	mov %r13, %r11
	push %r1
	push %r2
	push %r3
// Set
	mov #0, %r1
// Add
	mov WORD 6[%r11], %r0
	add #1, %r0
// Set
// CallFunction
	push %r0
	push %r1
	call [reallocate]
	add #4, %r13
// Set
// Set
	mov %r0, %r3
// Set
	mov %r3, %r2
// Set
	mov WORD 4[%r11], %r1
// Set
	mov WORD 6[%r11], %r0
// CallFunction
	push %r0
	push %r1
	push %r2
	call [memcpy]
	add #6, %r13
// Set
	mov #0, %r0
// SetAt
	mov %r3, %r1
	add WORD 6[%r11], %r1
	mov %r0, BYTE [%r1]
// Set
	mov %r3, %r1
// Set
	mov WORD 8[%r11], %r0
// CallFunction
	push %r0
	mov 6[%r11], %r2
	push %r2
	push %r1
	call [allocateString]
	add #6, %r13
// Return
__bbcc_00000009:
	pop %r3
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret