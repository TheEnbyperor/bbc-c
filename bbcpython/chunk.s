.import initArray
.import writeArray
.import freeArray
.import reallocate
.import getLastLine
.import writeLine
.import writeValueArray
.export size_t
.export ptrdiff_t
.export int8_t
.export uint8_t
.export int16_t
.export uint16_t
.export ArrayMeta
.export DynamicArray
.export LineInfo
.export LineInfoArray
.export ValueType
.export Obj
.export Value
.export ValueArray
.export OpCode
.export Chunk
.export initChunk
.export freeChunk
.export writeChunk
.export addConstant
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
LineInfo:
.byte #0,#0,#0,#0
LineInfoArray:
.byte #0,#0,#0,#0,#0,#0
ValueType:
.byte #0
Obj:
.byte #0
Value:
.byte #0,#0,#0
ValueArray:
.byte #0,#0,#0,#0,#0,#0
OpCode:
.byte #0
Chunk:
.byte #0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
// Function: initChunk
initChunk:
	push %r11
	mov %r13, %r11
// Set
	mov WORD 4[%r11], %r0
// CallFunction
	push %r0
	call [initArray]
	add #2, %r13
// Add
	mov WORD 4[%r11], %r0
	add #6, %r0
// Set
// CallFunction
	push %r0
	call [initArray]
	add #2, %r13
// Add
	mov WORD 4[%r11], %r0
	add #12, %r0
// Set
// CallFunction
	push %r0
	call [initArray]
	add #2, %r13
// Return
	mov #0, %r0
__bbcc_00000001:
	mov %r11, %r13
	pop %r11
	ret
// Function: writeChunk
writeChunk:
	push %r11
	mov %r13, %r11
	push %r1
	push %r2
// Add
	mov WORD 4[%r11], %r0
	add #12, %r0
// Set
// CallFunction
	push %r0
	call [getLastLine]
	add #2, %r13
// EqualJmp
	cmp 8[%r11], %r0
	jze [__bbcc_00000000]
// Add
	mov WORD 4[%r11], %r0
	add #12, %r0
// Set
	mov %r0, %r1
// Add
	mov WORD 4[%r11], %r0
// ReadAt
	mov WORD [%r0], %r0
// CallFunction
	mov 8[%r11], %r2
	push %r2
	push %r0
	push %r1
	call [writeLine]
	add #6, %r13
// Label
__bbcc_00000000:
// Set
	mov WORD 4[%r11], %r1
// AddrOf
	lea WORD 6[%r11], %r0
// Set
// CallFunction
	push %r0
	mov #1, %r2
	push %r2
	push %r1
	call [writeArray]
	add #6, %r13
// Return
	mov #0, %r0
__bbcc_00000002:
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: addConstant
addConstant:
	push %r11
	mov %r13, %r11
	push %r1
// Add
	mov WORD 4[%r11], %r0
	add #6, %r0
// Set
	mov %r0, %r1
// Set
	mov WORD 6[%r11], %r0
// CallFunction
	push %r0
	push %r1
	call [writeValueArray]
	add #4, %r13
// Add
	mov WORD 4[%r11], %r0
	add #6, %r0
// Add
// ReadAt
	mov WORD [%r0], %r0
// Set
	mov #1, %r1
// Sub
	sub %r1, %r0
// Return
__bbcc_00000003:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: freeChunk
freeChunk:
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
// Add
	mov WORD 4[%r11], %r0
	add #6, %r0
// Set
// CallFunction
	push %r0
	call [freeArray]
	add #2, %r13
// Add
	mov WORD 4[%r11], %r0
	add #12, %r0
// Set
// CallFunction
	push %r0
	call [freeArray]
	add #2, %r13
// Set
	mov WORD 4[%r11], %r0
// CallFunction
	push %r0
	call [initChunk]
	add #2, %r13
// Return
	mov #0, %r0
__bbcc_00000004:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret