.import free
.import realloc
.export size_t
.export ptrdiff_t
.export int8_t
.export uint8_t
.export int16_t
.export uint16_t
.export ArrayMeta
.export DynamicArray
.export initArray
.export writeArray
.export popArray
.export freeArray
.export growCapacity
.export shrinkCapacity
.export reallocate
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
// Function: initArray
initArray:
	push %r11
	mov %r13, %r11
	push %r1
// Set
	mov #0, %r0
// SetAt
	mov 4[%r11], %r1
	mov %r0, WORD 4[%r1]
// Add
	mov WORD 4[%r11], %r1
// Set
	mov #0, %r0
// SetAt
	mov %r0, WORD 2[%r1]
// Add
	mov WORD 4[%r11], %r1
// Set
	mov #0, %r0
// SetAt
	mov %r0, WORD [%r1]
// Return
	mov #0, %r0
__bbcc_0000000d:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: writeArray
writeArray:
	push %r11
	mov %r13, %r11
	push %r1
	push %r2
	push %r3
	push %r4
	push %r5
// Add
	mov WORD 4[%r11], %r2
// Add
	mov WORD 4[%r11], %r0
// ReadAt
	mov WORD [%r0], %r0
// Set
	mov #1, %r1
// Add
	add %r1, %r0
// ReadAt
	mov WORD 2[%r2], %r1
// MoreEqualJmp
	cmp %r1, %r0
	jae [__bbcc_00000000]
// Add
	mov WORD 4[%r11], %r0
// ReadAt
	mov WORD 2[%r0], %r0
// Set
// Set
// CallFunction
	push %r0
	call [growCapacity]
	add #2, %r13
// Add
	mov WORD 4[%r11], %r1
// Set
// SetAt
	mov %r0, WORD 2[%r1]
// ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 4[%r0], %r0
// Set
	mov %r0, %r1
// Add
	mov WORD 4[%r11], %r0
// ReadAt
	mov WORD 2[%r0], %r0
// Mult
	mul WORD 6[%r11], %r0
// CallFunction
	push %r0
	push %r1
	call [reallocate]
	add #4, %r13
// Set
// SetAt
	mov 4[%r11], %r1
	mov %r0, WORD 4[%r1]
// Label
__bbcc_00000000:
// Add
	mov WORD 4[%r11], %r0
// ReadAt
	mov WORD [%r0], %r0
// Mult
	mul WORD 6[%r11], %r0
// Set
	mov %r0, %r1
// Set
	mov #0, %r0
// Set
	mov %r0, %r4
// Label
__bbcc_00000001:
// MoreEqualJmp
	mov 6[%r11], %r0
	cmp %r4, %r0
	jae [__bbcc_00000003]
// Set
	mov WORD 8[%r11], %r0
// Set
	mov %r4, %r2
// Add
	add %r2, %r0
// ReadAt
	mov BYTE [%r0], %r3
// ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 4[%r0], %r2
// Add
	mov %r1, %r0
	add %r4, %r0
// SetAt
	mov %r2, %r5
	add %r0, %r5
	mov %r3, BYTE [%r5]
// Label
__bbcc_00000002:
// Add
	mov #1, %r0
	add %r4, %r0
// Set
	mov %r0, %r4
// Jmp
	jmp [__bbcc_00000001]
// Label
__bbcc_00000003:
// Add
	mov WORD 4[%r11], %r2
// ReadAt
	mov WORD [%r2], %r1
// Set
	mov %r1, %r0
// Add
	mov #1, %r0
	add %r1, %r0
// SetAt
	mov %r0, WORD [%r2]
// Return
	mov #0, %r0
__bbcc_0000000e:
	pop %r5
	pop %r4
	pop %r3
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: popArray
popArray:
	push %r11
	mov %r13, %r11
	push %r1
	push %r2
	push %r3
	push %r4
// Add
	mov WORD 4[%r11], %r2
// ReadAt
	mov WORD [%r2], %r0
// Set
	mov %r0, %r1
// Sub
	sub #1, %r0
// SetAt
	mov %r0, WORD [%r2]
// Add
	mov WORD 4[%r11], %r0
// ReadAt
	mov WORD [%r0], %r0
// Mult
	mul WORD 6[%r11], %r0
// Set
	mov %r0, %r1
// Set
	mov #0, %r0
// Set
	mov %r0, %r4
// Label
__bbcc_00000004:
// MoreEqualJmp
	mov 6[%r11], %r0
	cmp %r4, %r0
	jae [__bbcc_00000006]
// ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 4[%r0], %r2
// Add
	mov %r1, %r0
	add %r4, %r0
// ReadAt
	add %r0, %r2
	mov BYTE [%r2], %r3
// Set
	mov WORD 8[%r11], %r0
// Set
	mov %r4, %r2
// Add
	add %r2, %r0
// SetAt
	mov %r3, BYTE [%r0]
// Label
__bbcc_00000005:
// Add
	mov #1, %r0
	add %r4, %r0
// Set
	mov %r0, %r4
// Jmp
	jmp [__bbcc_00000004]
// Label
__bbcc_00000006:
// Add
	mov WORD 4[%r11], %r0
// ReadAt
	mov WORD 2[%r0], %r0
// Set
// Set
	mov %r0, %r2
// Add
	mov WORD 4[%r11], %r0
// ReadAt
	mov WORD [%r0], %r0
// Set
// CallFunction
	push %r0
	push %r2
	call [shrinkCapacity]
	add #4, %r13
// Add
	mov WORD 4[%r11], %r1
// Set
// SetAt
	mov %r0, WORD 2[%r1]
// Add
	mov WORD 4[%r11], %r0
// ReadAt
	mov WORD 2[%r0], %r0
// EqualJmp
	cmp %r0, %r2
	jze [__bbcc_00000007]
// ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 4[%r0], %r0
// Set
	mov %r0, %r1
// Add
	mov WORD 4[%r11], %r0
// ReadAt
	mov WORD 2[%r0], %r0
// Mult
	mul WORD 6[%r11], %r0
// CallFunction
	push %r0
	push %r1
	call [reallocate]
	add #4, %r13
// Set
// SetAt
	mov 4[%r11], %r1
	mov %r0, WORD 4[%r1]
// Label
__bbcc_00000007:
// Return
	mov #0, %r0
__bbcc_0000000f:
	pop %r4
	pop %r3
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: freeArray
freeArray:
	push %r11
	mov %r13, %r11
	push %r1
// ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 4[%r0], %r0
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
	mov WORD 4[%r11], %r0
// CallFunction
	push %r0
	call [initArray]
	add #2, %r13
// Return
	mov #0, %r0
__bbcc_00000010:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: growCapacity
growCapacity:
	push %r11
	mov %r13, %r11
// MoreEqualJmp
	mov #8, %r0
	cmp 4[%r11], %r0
	jge [__bbcc_00000008]
// Set
	mov #8, %r0
// Jmp
	jmp [__bbcc_00000009]
// Label
__bbcc_00000008:
// Add
	mov WORD 4[%r11], %r0
	add #8, %r0
// Set
// Label
__bbcc_00000009:
// Return
__bbcc_00000011:
	mov %r11, %r13
	pop %r11
	ret
// Function: shrinkCapacity
shrinkCapacity:
	push %r11
	mov %r13, %r11
	push %r1
// Sub
	mov WORD 4[%r11], %r0
	sub #8, %r0
// MoreEqualJmp
	mov 6[%r11], %r1
	cmp %r0, %r1
	jge [__bbcc_0000000a]
// Set
	mov WORD 4[%r11], %r0
// Jmp
	jmp [__bbcc_0000000b]
// Label
__bbcc_0000000a:
// Sub
	mov WORD 4[%r11], %r0
	sub #8, %r0
// Set
// Label
__bbcc_0000000b:
// Return
__bbcc_00000012:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: reallocate
reallocate:
	push %r11
	mov %r13, %r11
	push %r1
// NotEqualJmp
	mov #0, %r0
	cmp 6[%r11], %r0
	jnz [__bbcc_0000000c]
// Set
	mov WORD 4[%r11], %r0
// CallFunction
	push %r0
	call [free]
	add #2, %r13
// Return
	mov #0, %r0
	jmp [__bbcc_00000013]
// Label
__bbcc_0000000c:
// Set
	mov WORD 4[%r11], %r0
// CallFunction
	mov 6[%r11], %r1
	push %r1
	push %r0
	call [realloc]
	add #4, %r13
// Return
__bbcc_00000013:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret