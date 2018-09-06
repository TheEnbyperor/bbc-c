.import reallocate
.import isObj
.import asObj
.import memcpy
.export size_t
.export ptrdiff_t
.export int8_t
.export uint8_t
.export int16_t
.export uint16_t
.export ArrayMeta
.export DynamicArray
.export ValueType
.export Obj
.export Value
.export ValueArray
.export LineInfo
.export LineInfoArray
.export OpCode
.export Chunk
.export InterpretResult
.export Stack
.export VM
.export ObjType
.export ObjString
.export objType
.export isString
.export asString
.export asCString
.export takeString
.export copyString
.export freeObjects
size_t:
.byte #0,#0
ptrdiff_t:
.byte #0,#0
int8_t:
.byte #0
uint8_t:
.byte #0
int16_t:
.byte #0,#0
uint16_t:
.byte #0,#0
ArrayMeta:
.byte #0,#0,#0,#0
DynamicArray:
.byte #0,#0,#0,#0,#0,#0
ValueType:
.byte #0
Obj:
.byte #0,#0,#0
Value:
.byte #0,#0,#0
ValueArray:
.byte #0,#0,#0,#0,#0,#0
LineInfo:
.byte #0,#0,#0,#0
LineInfoArray:
.byte #0,#0,#0,#0,#0,#0
OpCode:
.byte #0
Chunk:
.byte #0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
InterpretResult:
.byte #0
Stack:
.byte #0,#0,#0,#0,#0,#0
VM:
.byte #0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
ObjType:
.byte #0
ObjString:
.byte #0,#0,#0,#0,#0,#0,#0
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
__bbcc_00000004:
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
__bbcc_00000005:
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
__bbcc_00000006:
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
__bbcc_00000007:
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
__bbcc_00000008:
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
__bbcc_00000009:
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
__bbcc_0000000a:
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
__bbcc_0000000b:
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
__bbcc_0000000c:
	pop %r3
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: freeObject
freeObject:
	push %r11
	mov %r13, %r11
	push %r1
// ReadAt
	mov WORD 4[%r11], %r0
	mov BYTE [%r0], %r0
// Set
// NotEqualJmp
	cmp #0, %r0
	jnz [__bbcc_00000001]
// Set
	mov WORD 4[%r11], %r0
// Set
// Set
// ReadAt
	mov WORD 5[%r0], %r0
// Set
	mov %r0, %r1
// Set
	mov #0, %r0
// CallFunction
	push %r0
	push %r1
	call [reallocate]
	add #4, %r13
// Set
	mov WORD 4[%r11], %r1
// Set
	mov #0, %r0
// CallFunction
	push %r0
	push %r1
	call [reallocate]
	add #4, %r13
// Label
__bbcc_00000001:
// Return
	mov #0, %r0
__bbcc_0000000d:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: freeObjects
freeObjects:
	push %r11
	mov %r13, %r11
	push %r1
	push %r2
// ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 10[%r0], %r0
// Set
// Set
	mov %r0, %r2
// Label
__bbcc_00000002:
// EqualJmp
	cmp #0, %r2
	jze [__bbcc_00000003]
// ReadAt
	mov WORD 1[%r2], %r0
// Set
// Set
	mov %r0, %r1
// Set
	mov %r2, %r0
// CallFunction
	push %r0
	call [freeObject]
	add #2, %r13
// Set
	mov %r1, %r0
// Set
	mov %r0, %r2
// Jmp
	jmp [__bbcc_00000002]
// Label
__bbcc_00000003:
// Return
	mov #0, %r0
__bbcc_0000000e:
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret