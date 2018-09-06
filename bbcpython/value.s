.import printf
.import writeArray
.import objType
.import asCString
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
.export writeValueArray
.export boolVal
.export noneVal
.export intVal
.export objVal
.export isBool
.export isNone
.export isInt
.export isObj
.export asBool
.export asInt
.export asObj
.export printValue
.export LineInfo
.export LineInfoArray
.export OpCode
.export Chunk
.export InterpretResult
.export Stack
.export VM
.export ObjType
.export ObjString
__bbcc_0000000a:
.byte #37,#115,#0
__bbcc_0000000b:
.byte #37,#100,#0
__bbcc_0000000c:
.byte #78,#111,#110,#101,#0
__bbcc_0000000d:
.byte #84,#114,#117,#101,#0
__bbcc_0000000e:
.byte #70,#97,#108,#115,#101,#0
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
// Function: writeValueArray
writeValueArray:
	push %r11
	mov %r13, %r11
	push %r1
	push %r2
// Set
	mov WORD 4[%r11], %r1
// Set
	mov WORD 6[%r11], %r0
// CallFunction
	push %r0
	mov #3, %r2
	push %r2
	push %r1
	call [writeArray]
	add #6, %r13
// Return
	mov #0, %r0
__bbcc_0000000f:
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: printObject
printObject:
	push %r11
	mov %r13, %r11
	push %r1
// Set
	mov WORD 4[%r11], %r0
// CallFunction
	push %r0
	call [objType]
	add #2, %r13
// Set
// NotEqualJmp
	cmp #0, %r0
	jnz [__bbcc_00000000]
// AddrOf
	lea WORD [__bbcc_0000000a], %r0
// Set
	mov %r0, %r1
// Set
	mov WORD 4[%r11], %r0
// CallFunction
	push %r0
	call [asCString]
	add #2, %r13
// CallFunction
	push %r0
	push %r1
	call [printf]
	add #4, %r13
// Label
__bbcc_00000000:
// Return
	mov #0, %r0
__bbcc_00000010:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: printValue
printValue:
	push %r11
	mov %r13, %r11
	push %r1
	push %r2
// ReadAt
	mov WORD 4[%r11], %r0
	mov BYTE [%r0], %r0
// Set
	mov %r0, %r1
// NotEqualJmp
	cmp #1, %r1
	jnz [__bbcc_00000001]
// AddrOf
	lea WORD [__bbcc_0000000b], %r0
// Set
	mov %r0, %r2
// Set
	mov WORD 4[%r11], %r0
// CallFunction
	push %r0
	call [asInt]
	add #2, %r13
// CallFunction
	push %r0
	push %r2
	call [printf]
	add #4, %r13
// Jmp
	jmp [__bbcc_00000002]
// Label
__bbcc_00000001:
// NotEqualJmp
	cmp #0, %r1
	jnz [__bbcc_00000003]
// AddrOf
	lea WORD [__bbcc_0000000c], %r0
// Set
// CallFunction
	push %r0
	call [printf]
	add #2, %r13
// Jmp
	jmp [__bbcc_00000004]
// Label
__bbcc_00000003:
// NotEqualJmp
	cmp #2, %r1
	jnz [__bbcc_00000005]
// Set
	mov WORD 4[%r11], %r0
// CallFunction
	push %r0
	call [asBool]
	add #2, %r13
// JmpZero
	cmp #0, %r0
	jze [__bbcc_00000006]
// AddrOf
	lea WORD [__bbcc_0000000d], %r0
// Set
// Jmp
	jmp [__bbcc_00000007]
// Label
__bbcc_00000006:
// AddrOf
	lea WORD [__bbcc_0000000e], %r0
// Set
// Label
__bbcc_00000007:
// Set
// CallFunction
	push %r0
	call [printf]
	add #2, %r13
// Jmp
	jmp [__bbcc_00000008]
// Label
__bbcc_00000005:
// NotEqualJmp
	cmp #3, %r1
	jnz [__bbcc_00000009]
// Set
	mov WORD 4[%r11], %r0
// CallFunction
	push %r0
	call [printObject]
	add #2, %r13
// Label
__bbcc_00000009:
// Label
__bbcc_00000008:
// Label
__bbcc_00000004:
// Label
__bbcc_00000002:
// Return
	mov #0, %r0
__bbcc_00000011:
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: boolVal
boolVal:
	push %r11
	mov %r13, %r11
	push %r1
// Set
	mov #2, %r0
// SetAt
	mov 6[%r11], %r1
	mov %r0, BYTE [%r1]
// Add
	mov WORD 6[%r11], %r0
	add #1, %r0
// SetAt
	mov 4[%r11], %r1
	mov %r1, BYTE [%r0]
// Return
	mov #0, %r0
__bbcc_00000012:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: noneVal
noneVal:
	push %r11
	mov %r13, %r11
	push %r1
// Set
	mov #0, %r0
// SetAt
	mov 4[%r11], %r1
	mov %r0, BYTE [%r1]
// Add
	mov WORD 4[%r11], %r0
	add #1, %r0
// SetAt
	mov #0, %r1
	mov %r1, WORD [%r0]
// Return
	mov #0, %r0
__bbcc_00000013:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: intVal
intVal:
	push %r11
	mov %r13, %r11
	push %r1
// Set
	mov #1, %r0
// SetAt
	mov 6[%r11], %r1
	mov %r0, BYTE [%r1]
// Add
	mov WORD 6[%r11], %r0
	add #1, %r0
// SetAt
	mov 4[%r11], %r1
	mov %r1, WORD [%r0]
// Return
	mov #0, %r0
__bbcc_00000014:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: objVal
objVal:
	push %r11
	mov %r13, %r11
	push %r1
// Set
	mov #3, %r0
// SetAt
	mov 6[%r11], %r1
	mov %r0, BYTE [%r1]
// Add
	mov WORD 6[%r11], %r1
	add #1, %r1
// Set
	mov WORD 4[%r11], %r0
// SetAt
	mov %r0, WORD [%r1]
// Return
	mov #0, %r0
__bbcc_00000015:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: isBool
isBool:
	push %r11
	mov %r13, %r11
	push %r1
// ReadAt
	mov WORD 4[%r11], %r0
	mov BYTE [%r0], %r1
// EqualCmp
	cmp #2, %r1
	sze %r0
// Return
__bbcc_00000016:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: isNone
isNone:
	push %r11
	mov %r13, %r11
	push %r1
// ReadAt
	mov WORD 4[%r11], %r0
	mov BYTE [%r0], %r1
// EqualCmp
	cmp #0, %r1
	sze %r0
// Return
__bbcc_00000017:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: isInt
isInt:
	push %r11
	mov %r13, %r11
	push %r1
// ReadAt
	mov WORD 4[%r11], %r0
	mov BYTE [%r0], %r1
// EqualCmp
	cmp #1, %r1
	sze %r0
// Return
__bbcc_00000018:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: isObj
isObj:
	push %r11
	mov %r13, %r11
	push %r1
// ReadAt
	mov WORD 4[%r11], %r0
	mov BYTE [%r0], %r1
// EqualCmp
	cmp #3, %r1
	sze %r0
// Return
__bbcc_00000019:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: asBool
asBool:
	push %r11
	mov %r13, %r11
// Add
	mov WORD 4[%r11], %r0
	add #1, %r0
// ReadAt
	mov BYTE [%r0], %r0
// Return
__bbcc_0000001a:
	mov %r11, %r13
	pop %r11
	ret
// Function: asInt
asInt:
	push %r11
	mov %r13, %r11
// Add
	mov WORD 4[%r11], %r0
	add #1, %r0
// ReadAt
	mov WORD [%r0], %r0
// Return
__bbcc_0000001b:
	mov %r11, %r13
	pop %r11
	ret
// Function: asObj
asObj:
	push %r11
	mov %r13, %r11
// Add
	mov WORD 4[%r11], %r0
	add #1, %r0
// ReadAt
	mov WORD [%r0], %r0
// Return
__bbcc_0000001c:
	mov %r11, %r13
	pop %r11
	ret