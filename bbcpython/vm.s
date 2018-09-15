.import printf
.import initArray
.import writeArray
.import popArray
.import freeArray
.import reallocate
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
.import isString
.import asString
.import takeString
.import freeObjects
.import compile
.import memcpy
.export pushStack
.export popStack
.export initVM
.export interpret
.export freeVM
.export concatenate
__bbcc_00000038:
.byte #91,#108,#105,#110,#101,#32,#37,#100,#93,#32,#105,#110,#32,#115,#99,#114,#105,#112,#116,#58,#32,#37,#115,#10,#0
__bbcc_00000039:
.byte #79,#112,#101,#114,#97,#110,#100,#115,#32,#109,#117,#115,#116,#32,#98,#101,#32,#97,#32,#110,#117,#109,#98,#101,#114,#46,#0
__bbcc_0000003a:
.byte #91,#0
__bbcc_0000003b:
.byte #44,#32,#0
__bbcc_0000003c:
.byte #93,#10,#0
__bbcc_0000003d:
.byte #79,#112,#101,#114,#97,#110,#100,#32,#109,#117,#115,#116,#32,#98,#101,#32,#97,#32,#110,#117,#109,#98,#101,#114,#46,#0
__bbcc_0000003e:
.byte #79,#112,#101,#114,#97,#110,#100,#115,#32,#109,#117,#115,#116,#32,#98,#101,#32,#116,#119,#111,#32,#110,#117,#109,#98,#101,#114,#115,#32,#111,#114,#32,#116,#119,#111,#32,#115,#116,#114,#105,#110,#103,#115,#46,#0
__bbcc_0000003f:
.byte #10,#0
__bbcc_00000040:
.byte #10,#83,#84,#65,#82,#84,#32,#86,#77,#10,#0
__bbcc_00000041:
.byte #69,#78,#68,#32,#86,#77,#10,#10,#0
// Function: pushStack
pushStack:
	push %r12
	mov %r14, %r12
	push %r1
	push %r2
// Set
	mov DWORD 8[%r12], %r1
// Set
	mov DWORD 12[%r12], %r0
// CallFunction
	push %r0
	mov #5, %r2
	push %r2
	push %r1
	call [writeArray]
	add #12, %r14
// Return
	mov #0, %r0
__bbcc_00000042:
	pop %r2
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: popStack
popStack:
	push %r12
	mov %r14, %r12
	push %r1
	push %r2
// Set
	mov DWORD 8[%r12], %r1
// Set
	mov DWORD 12[%r12], %r0
// CallFunction
	push %r0
	mov #5, %r2
	push %r2
	push %r1
	call [popArray]
	add #12, %r14
// Return
	mov #0, %r0
__bbcc_00000043:
	pop %r2
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: initVM
initVM:
	push %r12
	mov %r14, %r12
	push %r1
// Add
	mov DWORD 8[%r12], %r0
	add #8, %r0
// Set
// CallFunction
	push %r0
	call [initArray]
	add #4, %r14
// Set
	mov #0, %r0
// SetAt
	mov 8[%r12], %r1
	mov %r0, DWORD 20[%r1]
// Return
	mov #0, %r0
__bbcc_00000044:
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: freeVM
freeVM:
	push %r12
	mov %r14, %r12
// Add
	mov DWORD 8[%r12], %r0
	add #8, %r0
// Set
// CallFunction
	push %r0
	call [freeArray]
	add #4, %r14
// Set
	mov DWORD 8[%r12], %r0
// CallFunction
	push %r0
	call [freeObjects]
	add #4, %r14
// Return
	mov #0, %r0
__bbcc_00000045:
	mov %r12, %r14
	pop %r12
	ret
// Function: readByte
readByte:
	push %r12
	mov %r14, %r12
	push %r1
	push %r2
// ReadAt
	mov DWORD 8[%r12], %r0
	mov DWORD 4[%r0], %r0
// Set
	mov %r0, %r1
// Add
	add #1, %r0
// SetAt
	mov 8[%r12], %r2
	mov %r0, DWORD 4[%r2]
// ReadAt
	mov BYTE [%r1], %r0
// Return
__bbcc_00000046:
	pop %r2
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: readConstant
readConstant:
	push %r12
	mov %r14, %r12
	push %r1
	push %r2
// ReadAt
	mov DWORD 8[%r12], %r0
	mov DWORD [%r0], %r0
// Add
	add #12, %r0
// ReadAt
	mov DWORD 8[%r0], %r1
// Set
	mov DWORD 8[%r12], %r0
// CallFunction
	push %r0
	call [readByte]
	add #4, %r14
	mov %r0, %r2
// Mult
	mov #5, %r0
	mul %r2, %r0
// Add
	add %r0, %r1
// Return
	mov %r1, %r0
__bbcc_00000047:
	pop %r2
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: peek
peek:
	push %r12
	mov %r14, %r12
	push %r1
	push %r2
// Add
	mov DWORD 8[%r12], %r0
	add #8, %r0
// ReadAt
	mov DWORD 8[%r0], %r1
// Add
	mov DWORD 8[%r12], %r0
	add #8, %r0
// Add
// ReadAt
	mov DWORD [%r0], %r0
// Set
	mov #1, %r2
// Sub
	sub %r2, %r0
// Set
	mov DWORD 12[%r12], %r2
// Sub
	sub %r2, %r0
// Mult
	mov #5, %r2
	mul %r0, %r2
// Add
	add %r2, %r1
// Return
	mov %r1, %r0
__bbcc_00000048:
	pop %r2
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: runtimeError
runtimeError:
	push %r12
	mov %r14, %r12
	push %r1
	push %r2
// ReadAt
	mov DWORD 8[%r12], %r0
	mov DWORD [%r0], %r1
// ReadAt
	mov DWORD 8[%r12], %r0
	mov DWORD 4[%r0], %r0
// ReadAt
	mov DWORD 8[%r1], %r1
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
	lea DWORD [__bbcc_00000038], %r0
// Set
	mov %r0, %r1
// ReadAt
	mov DWORD 8[%r12], %r0
	mov DWORD [%r0], %r0
// Add
	add #24, %r0
// Set
// CallFunction
	push %r2
	push %r0
	call [getLine]
	add #8, %r14
// CallFunction
	mov DWORD 12[%r12], %r2
	push %r2
	push %r0
	push %r1
	call [printf]
	add #12, %r14
// Add
	mov DWORD 8[%r12], %r0
	add #8, %r0
// Set
// CallFunction
	push %r0
	call [freeArray]
	add #4, %r14
// Return
	mov #0, %r0
__bbcc_00000049:
	pop %r2
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: checkArithType
checkArithType:
	push %r12
	mov %r14, %r12
	sub #5, %r14
	push %r1
	push %r2
// Set
	mov DWORD 8[%r12], %r0
// CallFunction
	mov #1, %r1
	push %r1
	push %r0
	call [peek]
	add #8, %r14
// Set
// SetAt
	mov 20[%r12], %r1
	mov %r0, DWORD [%r1]
// Set
	mov #1, %r1
// Set
	mov DWORD 8[%r12], %r0
// CallFunction
	mov #0, %r2
	push %r2
	push %r0
	call [peek]
	add #8, %r14
// Set
// CallFunction
	push %r0
	call [isInt]
	add #4, %r14
// JmpZero
	cmp #0, %r0
	jze [__bbcc_00000001]
// ReadAt
	mov DWORD 20[%r12], %r0
	mov DWORD [%r0], %r0
// Set
// CallFunction
	push %r0
	call [isInt]
	add #4, %r14
// JmpZero
	cmp #0, %r0
	jze [__bbcc_00000001]
// Set
	mov #0, %r1
// Label
__bbcc_00000001:
// JmpZero
	cmp #0, %r1
	jze [__bbcc_00000000]
// Set
	mov DWORD 8[%r12], %r1
// AddrOf
	lea DWORD [__bbcc_00000039], %r0
// Set
// CallFunction
	push %r0
	push %r1
	call [runtimeError]
	add #8, %r14
// Return
	mov #0, %r0
	jmp [__bbcc_0000004a]
// Label
__bbcc_00000000:
// Add
	mov DWORD 8[%r12], %r0
	add #8, %r0
// Set
	mov %r0, %r1
// AddrOf
	lea DWORD -5[%r12], %r0
// Set
// CallFunction
	push %r0
	push %r1
	call [popStack]
	add #8, %r14
// ReadAt
	mov DWORD 20[%r12], %r0
	mov DWORD [%r0], %r0
// Set
// CallFunction
	push %r0
	call [asInt]
	add #4, %r14
// SetAt
	mov 12[%r12], %r1
	mov %r0, DWORD [%r1]
// AddrOf
	lea DWORD -5[%r12], %r0
// Set
// CallFunction
	push %r0
	call [asInt]
	add #4, %r14
// SetAt
	mov 16[%r12], %r1
	mov %r0, DWORD [%r1]
// Return
	mov #1, %r0
__bbcc_0000004a:
	pop %r2
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: isFalsey
isFalsey:
	push %r12
	mov %r14, %r12
	push %r1
// Set
	mov DWORD 8[%r12], %r0
// CallFunction
	mov #0, %r1
	push %r1
	push %r0
	call [peek]
	add #8, %r14
// Set
// SetAt
	mov 12[%r12], %r1
	mov %r0, DWORD [%r1]
// ReadAt
	mov DWORD 12[%r12], %r0
	mov DWORD [%r0], %r0
// Set
// CallFunction
	push %r0
	call [isNone]
	add #4, %r14
// JmpZero
	cmp #0, %r0
	jze [__bbcc_00000002]
// Return
	mov #1, %r0
	jmp [__bbcc_0000004b]
// Jmp
	jmp [__bbcc_00000003]
// Label
__bbcc_00000002:
// ReadAt
	mov DWORD 12[%r12], %r0
	mov DWORD [%r0], %r0
// Set
// CallFunction
	push %r0
	call [isBool]
	add #4, %r14
// JmpZero
	cmp #0, %r0
	jze [__bbcc_00000004]
// Set
	mov #1, %r1
// ReadAt
	mov DWORD 12[%r12], %r0
	mov DWORD [%r0], %r0
// Set
// CallFunction
	push %r0
	call [asBool]
	add #4, %r14
// JmpZero
	cmp #0, %r0
	jze [__bbcc_00000005]
// Set
	mov #0, %r1
// Label
__bbcc_00000005:
// Return
	mov %r1, %r0
	jmp [__bbcc_0000004b]
// Jmp
	jmp [__bbcc_00000006]
// Label
__bbcc_00000004:
// ReadAt
	mov DWORD 12[%r12], %r0
	mov DWORD [%r0], %r0
// Set
// CallFunction
	push %r0
	call [isInt]
	add #4, %r14
// JmpZero
	cmp #0, %r0
	jze [__bbcc_00000007]
// ReadAt
	mov DWORD 12[%r12], %r0
	mov DWORD [%r0], %r0
// Set
// CallFunction
	push %r0
	call [asInt]
	add #4, %r14
	mov %r0, %r1
// EqualCmp
	cmp #0, %r1
	sze %r0
// Return
	jmp [__bbcc_0000004b]
// Label
__bbcc_00000007:
// Label
__bbcc_00000006:
// Label
__bbcc_00000003:
// Return
	mov #0, %r0
__bbcc_0000004b:
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: valuesEqual
valuesEqual:
	push %r12
	mov %r14, %r12
	sub #5, %r14
	push %r1
	push %r2
	push %r3
// Add
	mov DWORD 8[%r12], %r0
	add #8, %r0
// Set
	mov %r0, %r1
// AddrOf
	lea DWORD -5[%r12], %r0
// Set
// CallFunction
	push %r0
	push %r1
	call [popStack]
	add #8, %r14
// Set
	mov DWORD 8[%r12], %r0
// CallFunction
	mov #0, %r1
	push %r1
	push %r0
	call [peek]
	add #8, %r14
// Set
// SetAt
	mov 12[%r12], %r1
	mov %r0, DWORD [%r1]
// AddrOf
	lea DWORD -5[%r12], %r1
// ReadAt
	mov DWORD 12[%r12], %r0
	mov DWORD [%r0], %r0
// ReadAt
	mov BYTE [%r1], %r1
// ReadAt
	mov BYTE [%r0], %r0
// EqualJmp
	cmp %r1, %r0
	jze [__bbcc_00000008]
// Return
	mov #0, %r0
	jmp [__bbcc_0000004c]
// Label
__bbcc_00000008:
// ReadAt
	mov DWORD 12[%r12], %r0
	mov DWORD [%r0], %r0
// ReadAt
	mov BYTE [%r0], %r0
// Set
	mov %r0, %r3
// NotEqualJmp
	cmp #2, %r3
	jnz [__bbcc_00000009]
// ReadAt
	mov DWORD 12[%r12], %r0
	mov DWORD [%r0], %r0
// Set
// CallFunction
	push %r0
	call [asBool]
	add #4, %r14
	mov %r0, %r2
// AddrOf
	lea DWORD -5[%r12], %r0
// Set
// CallFunction
	push %r0
	call [asBool]
	add #4, %r14
	mov %r0, %r1
// EqualCmp
	cmp %r2, %r1
	sze %r0
// Return
	jmp [__bbcc_0000004c]
// Label
__bbcc_00000009:
// NotEqualJmp
	cmp #0, %r3
	jnz [__bbcc_0000000a]
// Return
	mov #1, %r0
	jmp [__bbcc_0000004c]
// Label
__bbcc_0000000a:
// NotEqualJmp
	cmp #1, %r3
	jnz [__bbcc_0000000b]
// ReadAt
	mov DWORD 12[%r12], %r0
	mov DWORD [%r0], %r0
// Set
// CallFunction
	push %r0
	call [asInt]
	add #4, %r14
	mov %r0, %r2
// AddrOf
	lea DWORD -5[%r12], %r0
// Set
// CallFunction
	push %r0
	call [asInt]
	add #4, %r14
	mov %r0, %r1
// EqualCmp
	cmp %r2, %r1
	sze %r0
// Return
	jmp [__bbcc_0000004c]
// Label
__bbcc_0000000b:
// Return
	mov #0, %r0
__bbcc_0000004c:
	pop %r3
	pop %r2
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: concatenate
concatenate:
	push %r12
	mov %r14, %r12
	sub #5, %r14
	push %r1
	push %r2
	push %r3
	push %r4
	push %r5
	push %r6
	push %r7
// Add
	mov DWORD 8[%r12], %r0
	add #8, %r0
// Set
	mov %r0, %r1
// AddrOf
	lea DWORD -5[%r12], %r0
// Set
// CallFunction
	push %r0
	push %r1
	call [popStack]
	add #8, %r14
// Set
	mov DWORD 8[%r12], %r0
// CallFunction
	mov #0, %r1
	push %r1
	push %r0
	call [peek]
	add #8, %r14
// Set
// Set
	mov %r0, %r3
// AddrOf
	lea DWORD -5[%r12], %r0
// Set
// CallFunction
	push %r0
	call [asString]
	add #4, %r14
// Set
// Set
	mov %r0, %r6
// Set
	mov %r3, %r0
// CallFunction
	push %r0
	call [asString]
	add #4, %r14
// Set
// Set
	mov %r0, %r4
// ReadAt
	mov DWORD 5[%r4], %r0
// ReadAt
	mov DWORD 5[%r6], %r1
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
	add #8, %r14
// Set
// Set
	mov %r0, %r1
// Set
	mov %r1, %r7
// ReadAt
	mov DWORD 9[%r4], %r0
// Set
	mov %r0, %r5
// ReadAt
	mov DWORD 5[%r4], %r0
// Set
// CallFunction
	push %r0
	push %r5
	push %r7
	call [memcpy]
	add #12, %r14
// ReadAt
	mov DWORD 5[%r4], %r0
// Set
	mov %r0, %r4
// Add
	mov %r1, %r0
	add %r4, %r0
// Set
	mov %r0, %r5
// ReadAt
	mov DWORD 9[%r6], %r0
// Set
	mov %r0, %r4
// ReadAt
	mov DWORD 5[%r6], %r0
// Set
// CallFunction
	push %r0
	push %r4
	push %r5
	call [memcpy]
	add #12, %r14
// Set
	mov #0, %r0
// SetAt
	mov %r1, %r4
	add %r2, %r4
	mov %r0, BYTE [%r4]
// Set
// Set
	mov DWORD 8[%r12], %r0
// CallFunction
	push %r0
	push %r2
	push %r1
	call [takeString]
	add #12, %r14
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
	add #8, %r14
// Return
	mov #0, %r0
__bbcc_0000004d:
	pop %r7
	pop %r6
	pop %r5
	pop %r4
	pop %r3
	pop %r2
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: run
run:
	push %r12
	mov %r14, %r12
	sub #17, %r14
	push %r1
	push %r2
	push %r3
	push %r4
// Label
__bbcc_0000000c:
// AddrOf
	lea DWORD [__bbcc_0000003a], %r0
// Set
// CallFunction
	push %r0
	call [printf]
	add #4, %r14
// Set
	mov #0, %r2
// Label
__bbcc_0000000f:
// Add
	mov DWORD 8[%r12], %r0
	add #8, %r0
// Add
// ReadAt
	mov DWORD [%r0], %r0
// MoreEqualJmp
	cmp %r2, %r0
	jge [__bbcc_00000011]
// EqualJmp
	cmp #0, %r2
	jze [__bbcc_00000012]
// AddrOf
	lea DWORD [__bbcc_0000003b], %r0
// Set
// CallFunction
	push %r0
	call [printf]
	add #4, %r14
// Label
__bbcc_00000012:
// Add
	mov DWORD 8[%r12], %r0
	add #8, %r0
// ReadAt
	mov DWORD 8[%r0], %r0
// Mult
	mov #5, %r1
	mul %r2, %r1
// Add
	add %r1, %r0
// Set
// CallFunction
	push %r0
	call [printValue]
	add #4, %r14
// Label
__bbcc_00000010:
// Set
	mov %r2, %r0
// Inc
	inc %r2
// Jmp
	jmp [__bbcc_0000000f]
// Label
__bbcc_00000011:
// AddrOf
	lea DWORD [__bbcc_0000003c], %r0
// Set
// CallFunction
	push %r0
	call [printf]
	add #4, %r14
// ReadAt
	mov DWORD 8[%r12], %r0
	mov DWORD [%r0], %r0
// Set
	mov %r0, %r2
// ReadAt
	mov DWORD 8[%r12], %r0
	mov DWORD [%r0], %r1
// ReadAt
	mov DWORD 8[%r12], %r0
	mov DWORD 4[%r0], %r0
// ReadAt
	mov DWORD 8[%r1], %r1
// Set
// Sub
	sub %r1, %r0
// Set
// Set
// CallFunction
	push %r0
	push %r2
	call [disassembleInstruction]
	add #8, %r14
// Set
	mov DWORD 8[%r12], %r0
// CallFunction
	push %r0
	call [readByte]
	add #4, %r14
// Set
	mov %r0, %r3
// NotEqualJmp
	cmp #0, %r3
	jnz [__bbcc_00000013]
// Set
	mov DWORD 8[%r12], %r0
// CallFunction
	push %r0
	call [readConstant]
	add #4, %r14
// Set
// Set
	mov %r0, %r2
// Add
	mov DWORD 8[%r12], %r0
	add #8, %r0
// Set
	mov %r0, %r1
// Set
	mov %r2, %r0
// CallFunction
	push %r0
	push %r1
	call [pushStack]
	add #8, %r14
// Jmp
	jmp [__bbcc_00000014]
// Label
__bbcc_00000013:
// NotEqualJmp
	cmp #2, %r3
	jnz [__bbcc_00000015]
// Set
	mov DWORD 8[%r12], %r0
// CallFunction
	mov #0, %r1
	push %r1
	push %r0
	call [peek]
	add #8, %r14
// Set
// Set
	mov %r0, DWORD -17[%r12]
// Set
	mov DWORD -17[%r12], %r0
// CallFunction
	push %r0
	call [isInt]
	add #4, %r14
// JmpNotZero
	cmp #0, %r0
	jnz [__bbcc_00000016]
// Set
	mov DWORD 8[%r12], %r1
// AddrOf
	lea DWORD [__bbcc_0000003d], %r0
// Set
// CallFunction
	push %r0
	push %r1
	call [runtimeError]
	add #8, %r14
// Return
	mov #2, %r0
	jmp [__bbcc_0000004e]
// Label
__bbcc_00000016:
// Set
	mov DWORD -17[%r12], %r0
// CallFunction
	push %r0
	call [asInt]
	add #4, %r14
// Neg
	neg %r0
// Set
	mov DWORD -17[%r12], %r1
// CallFunction
	push %r1
	push %r0
	call [intVal]
	add #8, %r14
// Jmp
	jmp [__bbcc_00000017]
// Label
__bbcc_00000015:
// NotEqualJmp
	cmp #3, %r3
	jnz [__bbcc_00000018]
// Set
	mov #0, %r1
// Set
	mov DWORD 8[%r12], %r0
// CallFunction
	mov #0, %r2
	push %r2
	push %r0
	call [peek]
	add #8, %r14
// Set
// CallFunction
	push %r0
	call [isString]
	add #4, %r14
// JmpZero
	cmp #0, %r0
	jze [__bbcc_0000001a]
// Set
	mov DWORD 8[%r12], %r0
// CallFunction
	mov #1, %r2
	push %r2
	push %r0
	call [peek]
	add #8, %r14
// Set
// CallFunction
	push %r0
	call [isString]
	add #4, %r14
// JmpZero
	cmp #0, %r0
	jze [__bbcc_0000001a]
// Set
	mov #1, %r1
// Label
__bbcc_0000001a:
// JmpZero
	cmp #0, %r1
	jze [__bbcc_00000019]
// Set
	mov DWORD 8[%r12], %r0
// CallFunction
	push %r0
	call [concatenate]
	add #4, %r14
// Jmp
	jmp [__bbcc_0000001b]
// Label
__bbcc_00000019:
// Set
	mov #0, %r1
// Set
	mov DWORD 8[%r12], %r0
// CallFunction
	mov #0, %r2
	push %r2
	push %r0
	call [peek]
	add #8, %r14
// Set
// CallFunction
	push %r0
	call [isInt]
	add #4, %r14
// JmpZero
	cmp #0, %r0
	jze [__bbcc_0000001d]
// Set
	mov DWORD 8[%r12], %r0
// CallFunction
	mov #1, %r2
	push %r2
	push %r0
	call [peek]
	add #8, %r14
// Set
// CallFunction
	push %r0
	call [isInt]
	add #4, %r14
// JmpZero
	cmp #0, %r0
	jze [__bbcc_0000001d]
// Set
	mov #1, %r1
// Label
__bbcc_0000001d:
// JmpZero
	cmp #0, %r1
	jze [__bbcc_0000001c]
// Set
	mov DWORD 8[%r12], %r0
// CallFunction
	mov #1, %r1
	push %r1
	push %r0
	call [peek]
	add #8, %r14
// Set
// Set
	mov %r0, DWORD -17[%r12]
// Add
	mov DWORD 8[%r12], %r0
	add #8, %r0
// Set
	mov %r0, %r1
// AddrOf
	lea DWORD -5[%r12], %r0
// Set
// CallFunction
	push %r0
	push %r1
	call [popStack]
	add #8, %r14
// Set
	mov DWORD -17[%r12], %r0
// CallFunction
	push %r0
	call [asInt]
	add #4, %r14
// Set
	mov %r0, DWORD -9[%r12]
// AddrOf
	lea DWORD -5[%r12], %r0
// Set
// CallFunction
	push %r0
	call [asInt]
	add #4, %r14
// Set
	mov %r0, DWORD -13[%r12]
// Add
	mov DWORD -9[%r12], %r1
	add DWORD -13[%r12], %r1
// Set
	mov DWORD -17[%r12], %r0
// CallFunction
	push %r0
	push %r1
	call [intVal]
	add #8, %r14
// Jmp
	jmp [__bbcc_0000001e]
// Label
__bbcc_0000001c:
// Set
	mov DWORD 8[%r12], %r1
// AddrOf
	lea DWORD [__bbcc_0000003e], %r0
// Set
// CallFunction
	push %r0
	push %r1
	call [runtimeError]
	add #8, %r14
// Return
	mov #2, %r0
	jmp [__bbcc_0000004e]
// Label
__bbcc_0000001e:
// Label
__bbcc_0000001b:
// Jmp
	jmp [__bbcc_0000001f]
// Label
__bbcc_00000018:
// NotEqualJmp
	cmp #4, %r3
	jnz [__bbcc_00000020]
// Set
	mov DWORD 8[%r12], %r4
// AddrOf
	lea DWORD -9[%r12], %r0
// Set
	mov %r0, %r2
// AddrOf
	lea DWORD -13[%r12], %r0
// Set
	mov %r0, %r1
// AddrOf
	lea DWORD -17[%r12], %r0
// Set
// CallFunction
	push %r0
	push %r1
	push %r2
	push %r4
	call [checkArithType]
	add #16, %r14
// JmpNotZero
	cmp #0, %r0
	jnz [__bbcc_00000021]
// Return
	mov #2, %r0
	jmp [__bbcc_0000004e]
// Label
__bbcc_00000021:
// Sub
	mov DWORD -9[%r12], %r1
	sub DWORD -13[%r12], %r1
// Set
	mov DWORD -17[%r12], %r0
// CallFunction
	push %r0
	push %r1
	call [intVal]
	add #8, %r14
// Jmp
	jmp [__bbcc_00000022]
// Label
__bbcc_00000020:
// NotEqualJmp
	cmp #5, %r3
	jnz [__bbcc_00000023]
// Set
	mov DWORD 8[%r12], %r4
// AddrOf
	lea DWORD -9[%r12], %r0
// Set
	mov %r0, %r2
// AddrOf
	lea DWORD -13[%r12], %r0
// Set
	mov %r0, %r1
// AddrOf
	lea DWORD -17[%r12], %r0
// Set
// CallFunction
	push %r0
	push %r1
	push %r2
	push %r4
	call [checkArithType]
	add #16, %r14
// JmpNotZero
	cmp #0, %r0
	jnz [__bbcc_00000024]
// Return
	mov #2, %r0
	jmp [__bbcc_0000004e]
// Label
__bbcc_00000024:
// Mult
	mov DWORD -9[%r12], %r1
	mul DWORD -13[%r12], %r1
// Set
	mov DWORD -17[%r12], %r0
// CallFunction
	push %r0
	push %r1
	call [intVal]
	add #8, %r14
// Jmp
	jmp [__bbcc_00000025]
// Label
__bbcc_00000023:
// NotEqualJmp
	cmp #6, %r3
	jnz [__bbcc_00000026]
// Set
	mov DWORD 8[%r12], %r4
// AddrOf
	lea DWORD -9[%r12], %r0
// Set
	mov %r0, %r2
// AddrOf
	lea DWORD -13[%r12], %r0
// Set
	mov %r0, %r1
// AddrOf
	lea DWORD -17[%r12], %r0
// Set
// CallFunction
	push %r0
	push %r1
	push %r2
	push %r4
	call [checkArithType]
	add #16, %r14
// JmpNotZero
	cmp #0, %r0
	jnz [__bbcc_00000027]
// Return
	mov #2, %r0
	jmp [__bbcc_0000004e]
// Label
__bbcc_00000027:
// Div
	mov DWORD -9[%r12], %r1
	div DWORD -13[%r12], %r1
// Set
	mov DWORD -17[%r12], %r0
// CallFunction
	push %r0
	push %r1
	call [intVal]
	add #8, %r14
// Jmp
	jmp [__bbcc_00000028]
// Label
__bbcc_00000026:
// NotEqualJmp
	cmp #7, %r3
	jnz [__bbcc_00000029]
// Set
	mov DWORD 8[%r12], %r4
// AddrOf
	lea DWORD -9[%r12], %r0
// Set
	mov %r0, %r2
// AddrOf
	lea DWORD -13[%r12], %r0
// Set
	mov %r0, %r1
// AddrOf
	lea DWORD -17[%r12], %r0
// Set
// CallFunction
	push %r0
	push %r1
	push %r2
	push %r4
	call [checkArithType]
	add #16, %r14
// JmpNotZero
	cmp #0, %r0
	jnz [__bbcc_0000002a]
// Return
	mov #2, %r0
	jmp [__bbcc_0000004e]
// Label
__bbcc_0000002a:
// Mod
	mov DWORD -9[%r12], %r1
	mod DWORD -13[%r12], %r1
// Set
	mov DWORD -17[%r12], %r0
// CallFunction
	push %r0
	push %r1
	call [intVal]
	add #8, %r14
// Jmp
	jmp [__bbcc_0000002b]
// Label
__bbcc_00000029:
// NotEqualJmp
	cmp #9, %r3
	jnz [__bbcc_0000002c]
// Set
	mov DWORD 8[%r12], %r1
// AddrOf
	lea DWORD -17[%r12], %r0
// Set
// CallFunction
	push %r0
	push %r1
	call [isFalsey]
	add #8, %r14
	mov %r0, %r1
// Set
	mov DWORD -17[%r12], %r0
// CallFunction
	push %r0
	push %r1
	call [boolVal]
	add #8, %r14
// Jmp
	jmp [__bbcc_0000002d]
// Label
__bbcc_0000002c:
// NotEqualJmp
	cmp #10, %r3
	jnz [__bbcc_0000002e]
// Set
	mov DWORD 8[%r12], %r1
// AddrOf
	lea DWORD -17[%r12], %r0
// Set
// CallFunction
	push %r0
	push %r1
	call [valuesEqual]
	add #8, %r14
	mov %r0, %r1
// Set
	mov DWORD -17[%r12], %r0
// CallFunction
	push %r0
	push %r1
	call [boolVal]
	add #8, %r14
// Jmp
	jmp [__bbcc_0000002f]
// Label
__bbcc_0000002e:
// NotEqualJmp
	cmp #11, %r3
	jnz [__bbcc_00000030]
// Set
	mov DWORD 8[%r12], %r4
// AddrOf
	lea DWORD -9[%r12], %r0
// Set
	mov %r0, %r2
// AddrOf
	lea DWORD -13[%r12], %r0
// Set
	mov %r0, %r1
// AddrOf
	lea DWORD -17[%r12], %r0
// Set
// CallFunction
	push %r0
	push %r1
	push %r2
	push %r4
	call [checkArithType]
	add #16, %r14
// JmpNotZero
	cmp #0, %r0
	jnz [__bbcc_00000031]
// Return
	mov #2, %r0
	jmp [__bbcc_0000004e]
// Label
__bbcc_00000031:
// MoreThanCmp
	mov -13[%r12], %r0
	cmp -9[%r12], %r0
	sg %r1
// Set
	mov DWORD -17[%r12], %r0
// CallFunction
	push %r0
	push %r1
	call [boolVal]
	add #8, %r14
// Jmp
	jmp [__bbcc_00000032]
// Label
__bbcc_00000030:
// NotEqualJmp
	cmp #12, %r3
	jnz [__bbcc_00000033]
// Set
	mov DWORD 8[%r12], %r4
// AddrOf
	lea DWORD -9[%r12], %r0
// Set
	mov %r0, %r2
// AddrOf
	lea DWORD -13[%r12], %r0
// Set
	mov %r0, %r1
// AddrOf
	lea DWORD -17[%r12], %r0
// Set
// CallFunction
	push %r0
	push %r1
	push %r2
	push %r4
	call [checkArithType]
	add #16, %r14
// JmpNotZero
	cmp #0, %r0
	jnz [__bbcc_00000034]
// Return
	mov #2, %r0
	jmp [__bbcc_0000004e]
// Label
__bbcc_00000034:
// LessThanCmp
	mov -13[%r12], %r0
	cmp -9[%r12], %r0
	sl %r1
// Set
	mov DWORD -17[%r12], %r0
// CallFunction
	push %r0
	push %r1
	call [boolVal]
	add #8, %r14
// Jmp
	jmp [__bbcc_00000035]
// Label
__bbcc_00000033:
// NotEqualJmp
	cmp #8, %r3
	jnz [__bbcc_00000036]
// Add
	mov DWORD 8[%r12], %r0
	add #8, %r0
// Set
	mov %r0, %r1
// AddrOf
	lea DWORD -5[%r12], %r0
// Set
// CallFunction
	push %r0
	push %r1
	call [popStack]
	add #8, %r14
// AddrOf
	lea DWORD -5[%r12], %r0
// Set
// CallFunction
	push %r0
	call [printValue]
	add #4, %r14
// AddrOf
	lea DWORD [__bbcc_0000003f], %r0
// Set
// CallFunction
	push %r0
	call [printf]
	add #4, %r14
// Return
	mov #0, %r0
	jmp [__bbcc_0000004e]
// Label
__bbcc_00000036:
// Label
__bbcc_00000035:
// Label
__bbcc_00000032:
// Label
__bbcc_0000002f:
// Label
__bbcc_0000002d:
// Label
__bbcc_0000002b:
// Label
__bbcc_00000028:
// Label
__bbcc_00000025:
// Label
__bbcc_00000022:
// Label
__bbcc_0000001f:
// Label
__bbcc_00000017:
// Label
__bbcc_00000014:
// Label
__bbcc_0000000d:
// Jmp
	jmp [__bbcc_0000000c]
// Label
__bbcc_0000000e:
// Return
	mov #0, %r0
__bbcc_0000004e:
	pop %r4
	pop %r3
	pop %r2
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: interpret
interpret:
	push %r12
	mov %r14, %r12
	sub #36, %r14
	push %r1
	push %r2
// AddrOf
	lea DWORD -36[%r12], %r0
// Set
// CallFunction
	push %r0
	call [initChunk]
	add #4, %r14
// Set
	mov DWORD 12[%r12], %r2
// AddrOf
	lea DWORD -36[%r12], %r0
// Set
	mov %r0, %r1
// Set
	mov DWORD 8[%r12], %r0
// CallFunction
	push %r0
	push %r1
	push %r2
	call [compile]
	add #12, %r14
// JmpNotZero
	cmp #0, %r0
	jnz [__bbcc_00000037]
// AddrOf
	lea DWORD -36[%r12], %r0
// Set
// CallFunction
	push %r0
	call [freeChunk]
	add #4, %r14
// Return
	mov #1, %r0
	jmp [__bbcc_0000004f]
// Label
__bbcc_00000037:
// AddrOf
	lea DWORD -36[%r12], %r0
// Set
// SetAt
	mov 8[%r12], %r1
	mov %r0, DWORD [%r1]
// ReadAt
	mov DWORD 8[%r12], %r0
	mov DWORD [%r0], %r0
// ReadAt
	mov DWORD 8[%r0], %r0
// Set
// SetAt
	mov 8[%r12], %r1
	mov %r0, DWORD 4[%r1]
// AddrOf
	lea DWORD [__bbcc_00000040], %r0
// Set
// CallFunction
	push %r0
	call [printf]
	add #4, %r14
// Set
	mov DWORD 8[%r12], %r0
// CallFunction
	push %r0
	call [run]
	add #4, %r14
// Set
	mov %r0, %r1
// AddrOf
	lea DWORD [__bbcc_00000041], %r0
// Set
// CallFunction
	push %r0
	call [printf]
	add #4, %r14
// AddrOf
	lea DWORD -36[%r12], %r0
// Set
// CallFunction
	push %r0
	call [freeChunk]
	add #4, %r14
// Return
	mov %r1, %r0
__bbcc_0000004f:
	pop %r2
	pop %r1
	mov %r12, %r14
	pop %r12
	ret