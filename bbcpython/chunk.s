.import initArray
.import writeArray
.import freeArray
.import reallocate
.import getLastLine
.import writeLine
.import writeValueArray
.export initChunk
.export freeChunk
.export writeChunk
.export addConstant
// Function: initChunk
initChunk:
	push %r12
	mov %r14, %r12
// Set
	mov DWORD 8[%r12], %r0
// CallFunction
	push %r0
	call [initArray]
	add #4, %r14
// Add
	mov DWORD 8[%r12], %r0
	add #12, %r0
// Set
// CallFunction
	push %r0
	call [initArray]
	add #4, %r14
// Add
	mov DWORD 8[%r12], %r0
	add #24, %r0
// Set
// CallFunction
	push %r0
	call [initArray]
	add #4, %r14
// Return
	mov #0, %r0
__bbcc_00000001:
	mov %r12, %r14
	pop %r12
	ret
// Function: writeChunk
writeChunk:
	push %r12
	mov %r14, %r12
	push %r1
	push %r2
// Add
	mov DWORD 8[%r12], %r0
	add #24, %r0
// Set
// CallFunction
	push %r0
	call [getLastLine]
	add #4, %r14
// EqualJmp
	cmp 16[%r12], %r0
	jze [__bbcc_00000000]
// Add
	mov DWORD 8[%r12], %r0
	add #24, %r0
// Set
// Add
	mov DWORD 8[%r12], %r1
// ReadAt
	mov DWORD [%r1], %r1
// CallFunction
	mov DWORD 16[%r12], %r2
	push %r2
	push %r1
	push %r0
	call [writeLine]
	add #12, %r14
// Label
__bbcc_00000000:
// Set
	mov DWORD 8[%r12], %r1
// AddrOf
	lea DWORD 12[%r12], %r0
// Set
// CallFunction
	push %r0
	mov #1, %r2
	push %r2
	push %r1
	call [writeArray]
	add #12, %r14
// Return
	mov #0, %r0
__bbcc_00000002:
	pop %r2
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: addConstant
addConstant:
	push %r12
	mov %r14, %r12
	push %r1
// Add
	mov DWORD 8[%r12], %r0
	add #12, %r0
// Set
// Set
	mov DWORD 12[%r12], %r1
// CallFunction
	push %r1
	push %r0
	call [writeValueArray]
	add #8, %r14
// Add
	mov DWORD 8[%r12], %r0
	add #12, %r0
// Add
// ReadAt
	mov DWORD [%r0], %r0
// Set
	mov #1, %r1
// Sub
	sub %r1, %r0
// Return
__bbcc_00000003:
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: freeChunk
freeChunk:
	push %r12
	mov %r14, %r12
	push %r1
// ReadAt
	mov DWORD 8[%r12], %r0
	mov DWORD 8[%r0], %r0
// Set
// Set
	mov #0, %r1
// CallFunction
	push %r1
	push %r0
	call [reallocate]
	add #8, %r14
// Add
	mov DWORD 8[%r12], %r0
	add #12, %r0
// Set
// CallFunction
	push %r0
	call [freeArray]
	add #4, %r14
// Add
	mov DWORD 8[%r12], %r0
	add #24, %r0
// Set
// CallFunction
	push %r0
	call [freeArray]
	add #4, %r14
// Set
	mov DWORD 8[%r12], %r0
// CallFunction
	push %r0
	call [initChunk]
	add #4, %r14
// Return
	mov #0, %r0
__bbcc_00000004:
	pop %r1
	mov %r12, %r14
	pop %r12
	ret