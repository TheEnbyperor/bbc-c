.import printf
.import boolVal
.import intVal
.import objVal
.import isBool
.import isNone
.import isInt
.import asBool
.import asInt
.import printValue
.import initChunk
.import freeChunk
.import getLine
.import disassembleInstruction
.import growCapacity
.import shrinkCapacity
.import reallocate
.import freeObjects
.import isString
.import asString
.import takeString
.import compile
.import memcpy
.export initStack
.export freeStack
.export pushStack
.export popStack
.export initVM
.export interpret
.export freeVM
.export concatenate
__bbcc_0000003a:
.byte #91,#108,#105,#110,#101,#32,#37,#100,#93,#32,#105,#110,#32,#115,#99,#114,#105,#112,#116,#58,#32,#37,#115,#10,#0
__bbcc_0000003b:
.byte #79,#112,#101,#114,#97,#110,#100,#115,#32,#109,#117,#115,#116,#32,#98,#101,#32,#97,#32,#110,#117,#109,#98,#101,#114,#46,#0
__bbcc_0000003c:
.byte #91,#0
__bbcc_0000003d:
.byte #44,#32,#0
__bbcc_0000003e:
.byte #93,#10,#0
__bbcc_0000003f:
.byte #79,#112,#101,#114,#97,#110,#100,#32,#109,#117,#115,#116,#32,#98,#101,#32,#97,#32,#110,#117,#109,#98,#101,#114,#46,#0
__bbcc_00000040:
.byte #79,#112,#101,#114,#97,#110,#100,#115,#32,#109,#117,#115,#116,#32,#98,#101,#32,#116,#119,#111,#32,#110,#117,#109,#98,#101,#114,#115,#32,#111,#114,#32,#116,#119,#111,#32,#115,#116,#114,#105,#110,#103,#115,#46,#0
__bbcc_00000041:
.byte #10,#0
__bbcc_00000042:
.byte #10,#83,#84,#65,#82,#84,#32,#86,#77,#10,#0
__bbcc_00000043:
.byte #69,#78,#68,#32,#86,#77,#10,#10,#0
// Function: initStack
initStack:
	push %r11
	mov %r13, %r11
	push %r1
// Set
	mov #0, %r0
// SetAt
	mov 4[%r11], %r1
	mov %r0, WORD [%r1]
// Set
	mov #0, %r0
// SetAt
	mov 4[%r11], %r1
	mov %r0, WORD 4[%r1]
// Set
	mov #0, %r0
// SetAt
	mov 4[%r11], %r1
	mov %r0, WORD 2[%r1]
// Return
	mov #0, %r0
__bbcc_00000044:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: pushStack
pushStack:
	push %r11
	mov %r13, %r11
	sub #3, %r13
	push %r1
	push %r2
// ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 2[%r0], %r0
// Set
	mov #1, %r1
// Add
	add %r1, %r0
// ReadAt
	mov WORD 4[%r11], %r1
	mov WORD 4[%r1], %r1
// MoreEqualJmp
	cmp %r1, %r0
	jae [__bbcc_00000000]
// ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 4[%r0], %r0
// Set
// Set
// CallFunction
	push %r0
	call [growCapacity]
	add #2, %r13
// Set
// SetAt
	mov 4[%r11], %r1
	mov %r0, WORD 4[%r1]
// ReadAt
	mov WORD 4[%r11], %r0
	mov WORD [%r0], %r0
// Set
	mov %r0, %r1
// ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 4[%r0], %r0
// Mult
	mul #3, %r0
// CallFunction
	push %r0
	push %r1
	call [reallocate]
	add #4, %r13
// Set
// Set
// SetAt
	mov 4[%r11], %r1
	mov %r0, WORD [%r1]
// Label
__bbcc_00000000:
// ReadAt
	mov WORD 6[%r11], %r0
	mov WORD [%r0], %r1
	mov %r1, WORD -3[%r11]
	mov BYTE 2[%r0], %r1
	mov %r1, BYTE -1[%r11]
// ReadAt
	mov WORD 4[%r11], %r0
	mov WORD [%r0], %r2
// ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 2[%r0], %r1
// Mult
	mov #3, %r0
	mul %r1, %r0
// SetAt
	mov %r2, %r1
	add %r0, %r1
	mov -3[%r11], %r0
	mov %r0, WORD [%r1]
	mov -1[%r11], %r0
	mov %r0, BYTE 2[%r1]
// ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 2[%r0], %r1
// Set
	mov %r1, %r0
// Add
	mov #1, %r0
	add %r1, %r0
// SetAt
	mov 4[%r11], %r1
	mov %r0, WORD 2[%r1]
// Return
	mov #0, %r0
__bbcc_00000045:
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: popStack
popStack:
	push %r11
	mov %r13, %r11
	sub #3, %r13
	push %r1
	push %r2
// ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 2[%r0], %r0
// Set
	mov %r0, %r1
// Sub
	sub #1, %r0
// SetAt
	mov 4[%r11], %r1
	mov %r0, WORD 2[%r1]
// ReadAt
	mov WORD 4[%r11], %r0
	mov WORD [%r0], %r2
// ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 2[%r0], %r1
// Mult
	mov #3, %r0
	mul %r1, %r0
// ReadAt
	mov %r2, %r1
	add %r0, %r1
	mov WORD [%r1], %r2
	mov %r2, WORD -3[%r11]
	mov BYTE 2[%r1], %r2
	mov %r2, BYTE -1[%r11]
// SetAt
	mov 6[%r11], %r0
	mov -3[%r11], %r1
	mov %r1, WORD [%r0]
	mov -1[%r11], %r1
	mov %r1, BYTE 2[%r0]
// ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 4[%r0], %r0
// Set
// Set
	mov %r0, %r1
// ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 2[%r0], %r0
// Set
// CallFunction
	push %r0
	push %r1
	call [shrinkCapacity]
	add #4, %r13
// Set
// SetAt
	mov 4[%r11], %r2
	mov %r0, WORD 4[%r2]
// ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 4[%r0], %r0
// EqualJmp
	cmp %r0, %r1
	jze [__bbcc_00000001]
// ReadAt
	mov WORD 4[%r11], %r0
	mov WORD [%r0], %r0
// Set
	mov %r0, %r1
// ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 4[%r0], %r0
// Mult
	mul #3, %r0
// CallFunction
	push %r0
	push %r1
	call [reallocate]
	add #4, %r13
// Set
// Set
// SetAt
	mov 4[%r11], %r1
	mov %r0, WORD [%r1]
// Label
__bbcc_00000001:
// Return
	mov #0, %r0
__bbcc_00000046:
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: freeStack
freeStack:
	push %r11
	mov %r13, %r11
	push %r1
// ReadAt
	mov WORD 4[%r11], %r0
	mov WORD [%r0], %r0
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
	call [initStack]
	add #2, %r13
// Return
	mov #0, %r0
__bbcc_00000047:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: initVM
initVM:
	push %r11
	mov %r13, %r11
	push %r1
// Add
	mov WORD 4[%r11], %r0
	add #4, %r0
// Set
// CallFunction
	push %r0
	call [initStack]
	add #2, %r13
// Set
	mov #0, %r0
// SetAt
	mov 4[%r11], %r1
	mov %r0, WORD 10[%r1]
// Return
	mov #0, %r0
__bbcc_00000048:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: freeVM
freeVM:
	push %r11
	mov %r13, %r11
// Add
	mov WORD 4[%r11], %r0
	add #4, %r0
// Set
// CallFunction
	push %r0
	call [freeStack]
	add #2, %r13
// Set
	mov WORD 4[%r11], %r0
// CallFunction
	push %r0
	call [freeObjects]
	add #2, %r13
// Return
	mov #0, %r0
__bbcc_00000049:
	mov %r11, %r13
	pop %r11
	ret
// Function: readByte
readByte:
	push %r11
	mov %r13, %r11
	push %r1
	push %r2
// ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 2[%r0], %r2
// Set
	mov %r2, %r1
// Add
	mov #1, %r0
	add %r2, %r0
// SetAt
	mov 4[%r11], %r2
	mov %r0, WORD 2[%r2]
// ReadAt
	mov BYTE [%r1], %r0
// Return
__bbcc_0000004a:
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: readConstant
readConstant:
	push %r11
	mov %r13, %r11
	push %r1
	push %r2
// ReadAt
	mov WORD 4[%r11], %r0
	mov WORD [%r0], %r0
// Add
	add #6, %r0
// ReadAt
	mov WORD 4[%r0], %r1
// Set
	mov WORD 4[%r11], %r0
// CallFunction
	push %r0
	call [readByte]
	add #2, %r13
	mov %r0, %r2
// Mult
	mov #3, %r0
	mul %r2, %r0
// Add
	add %r0, %r1
// Return
	mov %r1, %r0
__bbcc_0000004b:
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: peek
peek:
	push %r11
	mov %r13, %r11
	push %r1
	push %r2
// Add
	mov WORD 4[%r11], %r0
	add #4, %r0
// ReadAt
	mov WORD [%r0], %r1
// Add
	mov WORD 4[%r11], %r0
	add #4, %r0
// ReadAt
	mov WORD 2[%r0], %r0
// Set
	mov #1, %r2
// Sub
	sub %r2, %r0
// Set
	mov WORD 6[%r11], %r2
// Sub
	sub %r2, %r0
// Mult
	mov #3, %r2
	mul %r0, %r2
// Add
	add %r2, %r1
// Return
	mov %r1, %r0
__bbcc_0000004c:
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: runtimeError
runtimeError:
	push %r11
	mov %r13, %r11
	push %r1
	push %r2
// ReadAt
	mov WORD 4[%r11], %r0
	mov WORD [%r0], %r1
// ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 2[%r0], %r0
// ReadAt
	mov WORD 4[%r1], %r1
// Set
// Sub
	sub %r1, %r0
// Set
	mov #1, %r1
// Sub
	sub %r1, %r0
// Set
// Set
	mov %r0, %r2
// AddrOf
	lea WORD [__bbcc_0000003a], %r0
// Set
	mov %r0, %r1
// ReadAt
	mov WORD 4[%r11], %r0
	mov WORD [%r0], %r0
// Add
	add #12, %r0
// Set
// CallFunction
	push %r2
	push %r0
	call [getLine]
	add #4, %r13
// CallFunction
	mov 6[%r11], %r2
	push %r2
	push %r0
	push %r1
	call [printf]
	add #6, %r13
// Add
	mov WORD 4[%r11], %r0
	add #4, %r0
// Set
// CallFunction
	push %r0
	call [freeStack]
	add #2, %r13
// Return
	mov #0, %r0
__bbcc_0000004d:
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: checkArithType
checkArithType:
	push %r11
	mov %r13, %r11
	sub #3, %r13
	push %r1
	push %r2
// Set
	mov WORD 4[%r11], %r0
// CallFunction
	mov #1, %r1
	push %r1
	push %r0
	call [peek]
	add #4, %r13
// Set
// SetAt
	mov 10[%r11], %r1
	mov %r0, WORD [%r1]
// Set
	mov #1, %r1
// Set
	mov WORD 4[%r11], %r0
// CallFunction
	mov #0, %r2
	push %r2
	push %r0
	call [peek]
	add #4, %r13
// Set
// CallFunction
	push %r0
	call [isInt]
	add #2, %r13
// JmpZero
	cmp #0, %r0
	jze [__bbcc_00000003]
// ReadAt
	mov WORD 10[%r11], %r0
	mov WORD [%r0], %r0
// Set
// CallFunction
	push %r0
	call [isInt]
	add #2, %r13
// JmpZero
	cmp #0, %r0
	jze [__bbcc_00000003]
// Set
	mov #0, %r1
// Label
__bbcc_00000003:
// JmpZero
	cmp #0, %r1
	jze [__bbcc_00000002]
// Set
	mov WORD 4[%r11], %r1
// AddrOf
	lea WORD [__bbcc_0000003b], %r0
// Set
// CallFunction
	push %r0
	push %r1
	call [runtimeError]
	add #4, %r13
// Return
	mov #0, %r0
	jmp [__bbcc_0000004e]
// Label
__bbcc_00000002:
// Add
	mov WORD 4[%r11], %r0
	add #4, %r0
// Set
	mov %r0, %r1
// AddrOf
	lea WORD -3[%r11], %r0
// Set
// CallFunction
	push %r0
	push %r1
	call [popStack]
	add #4, %r13
// ReadAt
	mov WORD 10[%r11], %r0
	mov WORD [%r0], %r0
// Set
// CallFunction
	push %r0
	call [asInt]
	add #2, %r13
// SetAt
	mov 6[%r11], %r1
	mov %r0, WORD [%r1]
// AddrOf
	lea WORD -3[%r11], %r0
// Set
// CallFunction
	push %r0
	call [asInt]
	add #2, %r13
// SetAt
	mov 8[%r11], %r1
	mov %r0, WORD [%r1]
// Return
	mov #1, %r0
__bbcc_0000004e:
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: isFalsey
isFalsey:
	push %r11
	mov %r13, %r11
	push %r1
// Set
	mov WORD 4[%r11], %r0
// CallFunction
	mov #0, %r1
	push %r1
	push %r0
	call [peek]
	add #4, %r13
// Set
// SetAt
	mov 6[%r11], %r1
	mov %r0, WORD [%r1]
// ReadAt
	mov WORD 6[%r11], %r0
	mov WORD [%r0], %r0
// Set
// CallFunction
	push %r0
	call [isNone]
	add #2, %r13
// JmpZero
	cmp #0, %r0
	jze [__bbcc_00000004]
// Return
	mov #1, %r0
	jmp [__bbcc_0000004f]
// Jmp
	jmp [__bbcc_00000005]
// Label
__bbcc_00000004:
// ReadAt
	mov WORD 6[%r11], %r0
	mov WORD [%r0], %r0
// Set
// CallFunction
	push %r0
	call [isBool]
	add #2, %r13
// JmpZero
	cmp #0, %r0
	jze [__bbcc_00000006]
// Set
	mov #1, %r1
// ReadAt
	mov WORD 6[%r11], %r0
	mov WORD [%r0], %r0
// Set
// CallFunction
	push %r0
	call [asBool]
	add #2, %r13
// JmpZero
	cmp #0, %r0
	jze [__bbcc_00000007]
// Set
	mov #0, %r1
// Label
__bbcc_00000007:
// Return
	mov %r1, %r0
	jmp [__bbcc_0000004f]
// Jmp
	jmp [__bbcc_00000008]
// Label
__bbcc_00000006:
// ReadAt
	mov WORD 6[%r11], %r0
	mov WORD [%r0], %r0
// Set
// CallFunction
	push %r0
	call [isInt]
	add #2, %r13
// JmpZero
	cmp #0, %r0
	jze [__bbcc_00000009]
// ReadAt
	mov WORD 6[%r11], %r0
	mov WORD [%r0], %r0
// Set
// CallFunction
	push %r0
	call [asInt]
	add #2, %r13
	mov %r0, %r1
// EqualCmp
	cmp #0, %r1
	sze %r0
// Return
	jmp [__bbcc_0000004f]
// Label
__bbcc_00000009:
// Label
__bbcc_00000008:
// Label
__bbcc_00000005:
// Return
	mov #0, %r0
__bbcc_0000004f:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: valuesEqual
valuesEqual:
	push %r11
	mov %r13, %r11
	sub #3, %r13
	push %r1
	push %r2
	push %r3
// Add
	mov WORD 4[%r11], %r0
	add #4, %r0
// Set
	mov %r0, %r1
// AddrOf
	lea WORD -3[%r11], %r0
// Set
// CallFunction
	push %r0
	push %r1
	call [popStack]
	add #4, %r13
// Set
	mov WORD 4[%r11], %r0
// CallFunction
	mov #0, %r1
	push %r1
	push %r0
	call [peek]
	add #4, %r13
// Set
// SetAt
	mov 6[%r11], %r1
	mov %r0, WORD [%r1]
// AddrOf
	lea WORD -3[%r11], %r1
// ReadAt
	mov WORD 6[%r11], %r0
	mov WORD [%r0], %r0
// ReadAt
	mov BYTE [%r1], %r1
// ReadAt
	mov BYTE [%r0], %r0
// EqualJmp
	cmp %r1, %r0
	jze [__bbcc_0000000a]
// Return
	mov #0, %r0
	jmp [__bbcc_00000050]
// Label
__bbcc_0000000a:
// ReadAt
	mov WORD 6[%r11], %r0
	mov WORD [%r0], %r0
// ReadAt
	mov BYTE [%r0], %r0
// Set
	mov %r0, %r3
// NotEqualJmp
	cmp #2, %r3
	jnz [__bbcc_0000000b]
// ReadAt
	mov WORD 6[%r11], %r0
	mov WORD [%r0], %r0
// Set
// CallFunction
	push %r0
	call [asBool]
	add #2, %r13
	mov %r0, %r2
// AddrOf
	lea WORD -3[%r11], %r0
// Set
// CallFunction
	push %r0
	call [asBool]
	add #2, %r13
	mov %r0, %r1
// EqualCmp
	cmp %r2, %r1
	sze %r0
// Return
	jmp [__bbcc_00000050]
// Label
__bbcc_0000000b:
// NotEqualJmp
	cmp #0, %r3
	jnz [__bbcc_0000000c]
// Return
	mov #1, %r0
	jmp [__bbcc_00000050]
// Label
__bbcc_0000000c:
// NotEqualJmp
	cmp #1, %r3
	jnz [__bbcc_0000000d]
// ReadAt
	mov WORD 6[%r11], %r0
	mov WORD [%r0], %r0
// Set
// CallFunction
	push %r0
	call [asInt]
	add #2, %r13
	mov %r0, %r2
// AddrOf
	lea WORD -3[%r11], %r0
// Set
// CallFunction
	push %r0
	call [asInt]
	add #2, %r13
	mov %r0, %r1
// EqualCmp
	cmp %r2, %r1
	sze %r0
// Return
	jmp [__bbcc_00000050]
// Label
__bbcc_0000000d:
// Return
	mov #0, %r0
__bbcc_00000050:
	pop %r3
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: concatenate
concatenate:
	push %r11
	mov %r13, %r11
	sub #3, %r13
	push %r1
	push %r2
	push %r3
	push %r4
	push %r5
	push %r6
	push %r7
// Add
	mov WORD 4[%r11], %r0
	add #4, %r0
// Set
	mov %r0, %r1
// AddrOf
	lea WORD -3[%r11], %r0
// Set
// CallFunction
	push %r0
	push %r1
	call [popStack]
	add #4, %r13
// Set
	mov WORD 4[%r11], %r0
// CallFunction
	mov #0, %r1
	push %r1
	push %r0
	call [peek]
	add #4, %r13
// Set
// Set
	mov %r0, %r3
// AddrOf
	lea WORD -3[%r11], %r0
// Set
// CallFunction
	push %r0
	call [asString]
	add #2, %r13
// Set
// Set
	mov %r0, %r5
// Set
	mov %r3, %r0
// CallFunction
	push %r0
	call [asString]
	add #2, %r13
// Set
// Set
	mov %r0, %r4
// ReadAt
	mov WORD 3[%r4], %r0
// ReadAt
	mov WORD 3[%r5], %r1
// Add
	add %r1, %r0
// Set
	mov %r0, %r2
// Set
	mov #0, %r1
// Add
	mov %r2, %r0
	add #1, %r0
// Set
// CallFunction
	push %r0
	push %r1
	call [reallocate]
	add #4, %r13
// Set
// Set
	mov %r0, %r1
// Set
	mov %r1, %r7
// ReadAt
	mov WORD 5[%r4], %r0
// Set
	mov %r0, %r6
// ReadAt
	mov WORD 3[%r4], %r0
// Set
// CallFunction
	push %r0
	push %r6
	push %r7
	call [memcpy]
	add #6, %r13
// ReadAt
	mov WORD 3[%r4], %r0
// Set
	mov %r0, %r4
// Add
	mov %r1, %r0
	add %r4, %r0
// Set
	mov %r0, %r6
// ReadAt
	mov WORD 5[%r5], %r0
// Set
	mov %r0, %r4
// ReadAt
	mov WORD 3[%r5], %r0
// Set
// CallFunction
	push %r0
	push %r4
	push %r6
	call [memcpy]
	add #6, %r13
// Set
	mov #0, %r0
// SetAt
	mov %r1, %r4
	add %r2, %r4
	mov %r0, BYTE [%r4]
// Set
// Set
	mov WORD 4[%r11], %r0
// CallFunction
	push %r0
	push %r2
	push %r1
	call [takeString]
	add #6, %r13
// Set
// Set
	mov %r0, %r4
// Set
	mov %r4, %r1
// Set
	mov %r3, %r0
// CallFunction
	push %r0
	push %r1
	call [objVal]
	add #4, %r13
// Return
	mov #0, %r0
__bbcc_00000051:
	pop %r7
	pop %r6
	pop %r5
	pop %r4
	pop %r3
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: run
run:
	push %r11
	mov %r13, %r11
	sub #9, %r13
	push %r1
	push %r2
	push %r3
	push %r4
// Label
__bbcc_0000000e:
// AddrOf
	lea WORD [__bbcc_0000003c], %r0
// Set
// CallFunction
	push %r0
	call [printf]
	add #2, %r13
// Set
	mov #0, %r2
// Label
__bbcc_00000011:
// Add
	mov WORD 4[%r11], %r0
	add #4, %r0
// ReadAt
	mov WORD 2[%r0], %r0
// MoreEqualJmp
	cmp %r2, %r0
	jge [__bbcc_00000013]
// EqualJmp
	cmp #0, %r2
	jze [__bbcc_00000014]
// AddrOf
	lea WORD [__bbcc_0000003d], %r0
// Set
// CallFunction
	push %r0
	call [printf]
	add #2, %r13
// Label
__bbcc_00000014:
// Add
	mov WORD 4[%r11], %r0
	add #4, %r0
// ReadAt
	mov WORD [%r0], %r0
// Mult
	mov #3, %r1
	mul %r2, %r1
// Add
	add %r1, %r0
// Set
// CallFunction
	push %r0
	call [printValue]
	add #2, %r13
// Label
__bbcc_00000012:
// Set
	mov %r2, %r0
// Add
	mov #1, %r0
	add %r2, %r0
// Set
	mov %r0, %r2
// Jmp
	jmp [__bbcc_00000011]
// Label
__bbcc_00000013:
// AddrOf
	lea WORD [__bbcc_0000003e], %r0
// Set
// CallFunction
	push %r0
	call [printf]
	add #2, %r13
// ReadAt
	mov WORD 4[%r11], %r0
	mov WORD [%r0], %r0
// Set
	mov %r0, %r2
// ReadAt
	mov WORD 4[%r11], %r0
	mov WORD [%r0], %r1
// ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 2[%r0], %r0
// ReadAt
	mov WORD 4[%r1], %r1
// Set
// Sub
	sub %r1, %r0
// Set
// Set
// CallFunction
	push %r0
	push %r2
	call [disassembleInstruction]
	add #4, %r13
// Set
	mov WORD 4[%r11], %r0
// CallFunction
	push %r0
	call [readByte]
	add #2, %r13
// Set
	mov %r0, %r2
// NotEqualJmp
	cmp #0, %r2
	jnz [__bbcc_00000015]
// Set
	mov WORD 4[%r11], %r0
// CallFunction
	push %r0
	call [readConstant]
	add #2, %r13
// Set
// Set
	mov %r0, %r3
// Add
	mov WORD 4[%r11], %r0
	add #4, %r0
// Set
	mov %r0, %r1
// Set
	mov %r3, %r0
// CallFunction
	push %r0
	push %r1
	call [pushStack]
	add #4, %r13
// Jmp
	jmp [__bbcc_00000016]
// Label
__bbcc_00000015:
// NotEqualJmp
	cmp #2, %r2
	jnz [__bbcc_00000017]
// Set
	mov WORD 4[%r11], %r0
// CallFunction
	mov #0, %r1
	push %r1
	push %r0
	call [peek]
	add #4, %r13
// Set
// Set
	mov %r0, WORD -9[%r11]
// Set
	mov WORD -9[%r11], %r0
// CallFunction
	push %r0
	call [isInt]
	add #2, %r13
// JmpNotZero
	cmp #0, %r0
	jnz [__bbcc_00000018]
// Set
	mov WORD 4[%r11], %r1
// AddrOf
	lea WORD [__bbcc_0000003f], %r0
// Set
// CallFunction
	push %r0
	push %r1
	call [runtimeError]
	add #4, %r13
// Return
	mov #2, %r0
	jmp [__bbcc_00000052]
// Label
__bbcc_00000018:
// Set
	mov WORD -9[%r11], %r0
// CallFunction
	push %r0
	call [asInt]
	add #2, %r13
// Neg
	neg %r0
// Set
	mov WORD -9[%r11], %r1
// CallFunction
	push %r1
	push %r0
	call [intVal]
	add #4, %r13
// Jmp
	jmp [__bbcc_00000019]
// Label
__bbcc_00000017:
// NotEqualJmp
	cmp #3, %r2
	jnz [__bbcc_0000001a]
// Set
	mov #0, %r1
// Set
	mov WORD 4[%r11], %r0
// CallFunction
	mov #0, %r3
	push %r3
	push %r0
	call [peek]
	add #4, %r13
// Set
// CallFunction
	push %r0
	call [isString]
	add #2, %r13
// JmpZero
	cmp #0, %r0
	jze [__bbcc_0000001c]
// Set
	mov WORD 4[%r11], %r0
// CallFunction
	mov #1, %r3
	push %r3
	push %r0
	call [peek]
	add #4, %r13
// Set
// CallFunction
	push %r0
	call [isString]
	add #2, %r13
// JmpZero
	cmp #0, %r0
	jze [__bbcc_0000001c]
// Set
	mov #1, %r1
// Label
__bbcc_0000001c:
// JmpZero
	cmp #0, %r1
	jze [__bbcc_0000001b]
// Set
	mov WORD 4[%r11], %r0
// CallFunction
	push %r0
	call [concatenate]
	add #2, %r13
// Jmp
	jmp [__bbcc_0000001d]
// Label
__bbcc_0000001b:
// Set
	mov #0, %r1
// Set
	mov WORD 4[%r11], %r0
// CallFunction
	mov #0, %r3
	push %r3
	push %r0
	call [peek]
	add #4, %r13
// Set
// CallFunction
	push %r0
	call [isInt]
	add #2, %r13
// JmpZero
	cmp #0, %r0
	jze [__bbcc_0000001f]
// Set
	mov WORD 4[%r11], %r0
// CallFunction
	mov #1, %r3
	push %r3
	push %r0
	call [peek]
	add #4, %r13
// Set
// CallFunction
	push %r0
	call [isInt]
	add #2, %r13
// JmpZero
	cmp #0, %r0
	jze [__bbcc_0000001f]
// Set
	mov #1, %r1
// Label
__bbcc_0000001f:
// JmpZero
	cmp #0, %r1
	jze [__bbcc_0000001e]
// Set
	mov WORD 4[%r11], %r0
// CallFunction
	mov #1, %r1
	push %r1
	push %r0
	call [peek]
	add #4, %r13
// Set
// Set
	mov %r0, WORD -9[%r11]
// Add
	mov WORD 4[%r11], %r0
	add #4, %r0
// Set
	mov %r0, %r1
// AddrOf
	lea WORD -3[%r11], %r0
// Set
// CallFunction
	push %r0
	push %r1
	call [popStack]
	add #4, %r13
// Set
	mov WORD -9[%r11], %r0
// CallFunction
	push %r0
	call [asInt]
	add #2, %r13
// Set
	mov %r0, WORD -5[%r11]
// AddrOf
	lea WORD -3[%r11], %r0
// Set
// CallFunction
	push %r0
	call [asInt]
	add #2, %r13
// Set
	mov %r0, WORD -7[%r11]
// Add
	mov WORD -5[%r11], %r1
	add WORD -7[%r11], %r1
// Set
	mov WORD -9[%r11], %r0
// CallFunction
	push %r0
	push %r1
	call [intVal]
	add #4, %r13
// Jmp
	jmp [__bbcc_00000020]
// Label
__bbcc_0000001e:
// Set
	mov WORD 4[%r11], %r1
// AddrOf
	lea WORD [__bbcc_00000040], %r0
// Set
// CallFunction
	push %r0
	push %r1
	call [runtimeError]
	add #4, %r13
// Return
	mov #2, %r0
	jmp [__bbcc_00000052]
// Label
__bbcc_00000020:
// Label
__bbcc_0000001d:
// Jmp
	jmp [__bbcc_00000021]
// Label
__bbcc_0000001a:
// NotEqualJmp
	cmp #4, %r2
	jnz [__bbcc_00000022]
// Set
	mov WORD 4[%r11], %r4
// AddrOf
	lea WORD -5[%r11], %r0
// Set
	mov %r0, %r3
// AddrOf
	lea WORD -7[%r11], %r0
// Set
	mov %r0, %r1
// AddrOf
	lea WORD -9[%r11], %r0
// Set
// CallFunction
	push %r0
	push %r1
	push %r3
	push %r4
	call [checkArithType]
	add #8, %r13
// JmpNotZero
	cmp #0, %r0
	jnz [__bbcc_00000023]
// Return
	mov #2, %r0
	jmp [__bbcc_00000052]
// Label
__bbcc_00000023:
// Sub
	mov WORD -5[%r11], %r1
	sub WORD -7[%r11], %r1
// Set
	mov WORD -9[%r11], %r0
// CallFunction
	push %r0
	push %r1
	call [intVal]
	add #4, %r13
// Jmp
	jmp [__bbcc_00000024]
// Label
__bbcc_00000022:
// NotEqualJmp
	cmp #5, %r2
	jnz [__bbcc_00000025]
// Set
	mov WORD 4[%r11], %r4
// AddrOf
	lea WORD -5[%r11], %r0
// Set
	mov %r0, %r3
// AddrOf
	lea WORD -7[%r11], %r0
// Set
	mov %r0, %r1
// AddrOf
	lea WORD -9[%r11], %r0
// Set
// CallFunction
	push %r0
	push %r1
	push %r3
	push %r4
	call [checkArithType]
	add #8, %r13
// JmpNotZero
	cmp #0, %r0
	jnz [__bbcc_00000026]
// Return
	mov #2, %r0
	jmp [__bbcc_00000052]
// Label
__bbcc_00000026:
// Mult
	mov WORD -5[%r11], %r1
	mul WORD -7[%r11], %r1
// Set
	mov WORD -9[%r11], %r0
// CallFunction
	push %r0
	push %r1
	call [intVal]
	add #4, %r13
// Jmp
	jmp [__bbcc_00000027]
// Label
__bbcc_00000025:
// NotEqualJmp
	cmp #6, %r2
	jnz [__bbcc_00000028]
// Set
	mov WORD 4[%r11], %r4
// AddrOf
	lea WORD -5[%r11], %r0
// Set
	mov %r0, %r3
// AddrOf
	lea WORD -7[%r11], %r0
// Set
	mov %r0, %r1
// AddrOf
	lea WORD -9[%r11], %r0
// Set
// CallFunction
	push %r0
	push %r1
	push %r3
	push %r4
	call [checkArithType]
	add #8, %r13
// JmpNotZero
	cmp #0, %r0
	jnz [__bbcc_00000029]
// Return
	mov #2, %r0
	jmp [__bbcc_00000052]
// Label
__bbcc_00000029:
// Div
	mov WORD -5[%r11], %r1
	div WORD -7[%r11], %r1
// Set
	mov WORD -9[%r11], %r0
// CallFunction
	push %r0
	push %r1
	call [intVal]
	add #4, %r13
// Jmp
	jmp [__bbcc_0000002a]
// Label
__bbcc_00000028:
// NotEqualJmp
	cmp #7, %r2
	jnz [__bbcc_0000002b]
// Set
	mov WORD 4[%r11], %r4
// AddrOf
	lea WORD -5[%r11], %r0
// Set
	mov %r0, %r3
// AddrOf
	lea WORD -7[%r11], %r0
// Set
	mov %r0, %r1
// AddrOf
	lea WORD -9[%r11], %r0
// Set
// CallFunction
	push %r0
	push %r1
	push %r3
	push %r4
	call [checkArithType]
	add #8, %r13
// JmpNotZero
	cmp #0, %r0
	jnz [__bbcc_0000002c]
// Return
	mov #2, %r0
	jmp [__bbcc_00000052]
// Label
__bbcc_0000002c:
// Mod
	mov WORD -5[%r11], %r1
	mod WORD -7[%r11], %r1
// Set
	mov WORD -9[%r11], %r0
// CallFunction
	push %r0
	push %r1
	call [intVal]
	add #4, %r13
// Jmp
	jmp [__bbcc_0000002d]
// Label
__bbcc_0000002b:
// NotEqualJmp
	cmp #9, %r2
	jnz [__bbcc_0000002e]
// Set
	mov WORD 4[%r11], %r1
// AddrOf
	lea WORD -9[%r11], %r0
// Set
// CallFunction
	push %r0
	push %r1
	call [isFalsey]
	add #4, %r13
	mov %r0, %r1
// Set
	mov WORD -9[%r11], %r0
// CallFunction
	push %r0
	push %r1
	call [boolVal]
	add #4, %r13
// Jmp
	jmp [__bbcc_0000002f]
// Label
__bbcc_0000002e:
// NotEqualJmp
	cmp #10, %r2
	jnz [__bbcc_00000030]
// Set
	mov WORD 4[%r11], %r1
// AddrOf
	lea WORD -9[%r11], %r0
// Set
// CallFunction
	push %r0
	push %r1
	call [valuesEqual]
	add #4, %r13
	mov %r0, %r1
// Set
	mov WORD -9[%r11], %r0
// CallFunction
	push %r0
	push %r1
	call [boolVal]
	add #4, %r13
// Jmp
	jmp [__bbcc_00000031]
// Label
__bbcc_00000030:
// NotEqualJmp
	cmp #11, %r2
	jnz [__bbcc_00000032]
// Set
	mov WORD 4[%r11], %r4
// AddrOf
	lea WORD -5[%r11], %r0
// Set
	mov %r0, %r3
// AddrOf
	lea WORD -7[%r11], %r0
// Set
	mov %r0, %r1
// AddrOf
	lea WORD -9[%r11], %r0
// Set
// CallFunction
	push %r0
	push %r1
	push %r3
	push %r4
	call [checkArithType]
	add #8, %r13
// JmpNotZero
	cmp #0, %r0
	jnz [__bbcc_00000033]
// Return
	mov #2, %r0
	jmp [__bbcc_00000052]
// Label
__bbcc_00000033:
// MoreThanCmp
	mov -7[%r11], %r0
	cmp -5[%r11], %r0
	sg %r1
// Set
	mov WORD -9[%r11], %r0
// CallFunction
	push %r0
	push %r1
	call [boolVal]
	add #4, %r13
// Jmp
	jmp [__bbcc_00000034]
// Label
__bbcc_00000032:
// NotEqualJmp
	cmp #12, %r2
	jnz [__bbcc_00000035]
// Set
	mov WORD 4[%r11], %r4
// AddrOf
	lea WORD -5[%r11], %r0
// Set
	mov %r0, %r3
// AddrOf
	lea WORD -7[%r11], %r0
// Set
	mov %r0, %r1
// AddrOf
	lea WORD -9[%r11], %r0
// Set
// CallFunction
	push %r0
	push %r1
	push %r3
	push %r4
	call [checkArithType]
	add #8, %r13
// JmpNotZero
	cmp #0, %r0
	jnz [__bbcc_00000036]
// Return
	mov #2, %r0
	jmp [__bbcc_00000052]
// Label
__bbcc_00000036:
// LessThanCmp
	mov -7[%r11], %r0
	cmp -5[%r11], %r0
	sl %r1
// Set
	mov WORD -9[%r11], %r0
// CallFunction
	push %r0
	push %r1
	call [boolVal]
	add #4, %r13
// Jmp
	jmp [__bbcc_00000037]
// Label
__bbcc_00000035:
// NotEqualJmp
	cmp #8, %r2
	jnz [__bbcc_00000038]
// Add
	mov WORD 4[%r11], %r0
	add #4, %r0
// Set
	mov %r0, %r1
// AddrOf
	lea WORD -3[%r11], %r0
// Set
// CallFunction
	push %r0
	push %r1
	call [popStack]
	add #4, %r13
// AddrOf
	lea WORD -3[%r11], %r0
// Set
// CallFunction
	push %r0
	call [printValue]
	add #2, %r13
// AddrOf
	lea WORD [__bbcc_00000041], %r0
// Set
// CallFunction
	push %r0
	call [printf]
	add #2, %r13
// Return
	mov #0, %r0
	jmp [__bbcc_00000052]
// Label
__bbcc_00000038:
// Label
__bbcc_00000037:
// Label
__bbcc_00000034:
// Label
__bbcc_00000031:
// Label
__bbcc_0000002f:
// Label
__bbcc_0000002d:
// Label
__bbcc_0000002a:
// Label
__bbcc_00000027:
// Label
__bbcc_00000024:
// Label
__bbcc_00000021:
// Label
__bbcc_00000019:
// Label
__bbcc_00000016:
// Label
__bbcc_0000000f:
// Jmp
	jmp [__bbcc_0000000e]
// Label
__bbcc_00000010:
// Return
	mov #0, %r0
__bbcc_00000052:
	pop %r4
	pop %r3
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: interpret
interpret:
	push %r11
	mov %r13, %r11
	sub #18, %r13
	push %r1
	push %r2
// AddrOf
	lea WORD -18[%r11], %r0
// Set
// CallFunction
	push %r0
	call [initChunk]
	add #2, %r13
// Set
	mov WORD 6[%r11], %r2
// AddrOf
	lea WORD -18[%r11], %r0
// Set
	mov %r0, %r1
// Set
	mov WORD 4[%r11], %r0
// CallFunction
	push %r0
	push %r1
	push %r2
	call [compile]
	add #6, %r13
// JmpNotZero
	cmp #0, %r0
	jnz [__bbcc_00000039]
// AddrOf
	lea WORD -18[%r11], %r0
// Set
// CallFunction
	push %r0
	call [freeChunk]
	add #2, %r13
// Return
	mov #1, %r0
	jmp [__bbcc_00000053]
// Label
__bbcc_00000039:
// AddrOf
	lea WORD -18[%r11], %r0
// Set
// SetAt
	mov 4[%r11], %r1
	mov %r0, WORD [%r1]
// ReadAt
	mov WORD 4[%r11], %r0
	mov WORD [%r0], %r0
// ReadAt
	mov WORD 4[%r0], %r0
// Set
// SetAt
	mov 4[%r11], %r1
	mov %r0, WORD 2[%r1]
// AddrOf
	lea WORD [__bbcc_00000042], %r0
// Set
// CallFunction
	push %r0
	call [printf]
	add #2, %r13
// Set
	mov WORD 4[%r11], %r0
// CallFunction
	push %r0
	call [run]
	add #2, %r13
// Set
	mov %r0, %r1
// AddrOf
	lea WORD [__bbcc_00000043], %r0
// Set
// CallFunction
	push %r0
	call [printf]
	add #2, %r13
// AddrOf
	lea WORD -18[%r11], %r0
// Set
// CallFunction
	push %r0
	call [freeChunk]
	add #2, %r13
// Return
	mov %r1, %r0
__bbcc_00000053:
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret