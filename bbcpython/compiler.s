.import putchar
.import printf
.import disassembleChunk
.import boolVal
.import noneVal
.import intVal
.import objVal
.import writeChunk
.import addConstant
.import copyString
.import initScanner
.import scanToken
.import atoi
.export compile
.export parsePrecedence
.export rules
__bbcc_00000031:
.byte #91,#108,#105,#110,#101,#32,#37,#100,#93,#32,#69,#114,#114,#111,#114,#0
__bbcc_00000032:
.byte #32,#97,#116,#32,#101,#110,#100,#0
__bbcc_00000033:
.byte #32,#97,#116,#32,#39,#0
__bbcc_00000034:
.byte #39,#0
__bbcc_00000035:
.byte #58,#32,#37,#115,#10,#0
__bbcc_00000036:
.byte #37,#48,#52,#117,#32,#37,#48,#50,#117,#32,#0
__bbcc_00000037:
.byte #37,#99,#0
__bbcc_00000038:
.byte #10,#0
__bbcc_00000039:
.byte #84,#111,#111,#32,#109,#97,#110,#121,#32,#99,#111,#110,#115,#116,#97,#110,#116,#115,#32,#105,#110,#32,#111,#110,#101,#32,#99,#104,#117,#110,#107,#46,#0
__bbcc_0000003a:
.byte #99,#111,#100,#101,#0
__bbcc_0000003b:
.byte #69,#120,#112,#101,#99,#116,#32,#39,#41,#39,#32,#97,#102,#116,#101,#114,#32,#101,#120,#112,#114,#101,#115,#115,#105,#111,#110,#46,#0
__bbcc_0000003c:
.byte #69,#120,#112,#101,#99,#116,#32,#101,#120,#112,#114,#101,#115,#115,#105,#111,#110,#46,#0
__bbcc_0000003d:
.byte #83,#84,#65,#82,#84,#32,#80,#65,#82,#83,#69,#10,#0
__bbcc_0000003e:
.byte #69,#120,#112,#101,#99,#116,#101,#100,#32,#101,#110,#100,#32,#111,#102,#32,#101,#120,#112,#114,#101,#115,#115,#105,#111,#110,#46,#0
rules:
.byte #0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
// Function: currentChunk
currentChunk:
	push %r11
	mov %r13, %r11
// ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 18[%r0], %r0
// Return
__bbcc_0000003f:
	mov %r11, %r13
	pop %r11
	ret
// Function: errorAt
errorAt:
	push %r11
	mov %r13, %r11
	push %r1
// ReadAt
	mov WORD 4[%r11], %r0
	mov BYTE 17[%r0], %r0
// JmpZero
	cmp #0, %r0
	jze [__bbcc_00000000]
// Return
	mov #0, %r0
	jmp [__bbcc_00000040]
// Label
__bbcc_00000000:
// Set
	mov #1, %r0
// SetAt
	mov 4[%r11], %r1
	mov %r0, BYTE 17[%r1]
// AddrOf
	lea WORD [__bbcc_00000031], %r0
// Set
	mov %r0, %r1
// ReadAt
	mov WORD 6[%r11], %r0
	mov WORD 6[%r0], %r0
// CallFunction
	push %r0
	push %r1
	call [printf]
	add #4, %r13
// ReadAt
	mov WORD 6[%r11], %r0
	mov WORD [%r0], %r0
// NotEqualJmp
	cmp #56, %r0
	jnz [__bbcc_00000001]
// AddrOf
	lea WORD [__bbcc_00000032], %r0
// Set
// CallFunction
	push %r0
	call [printf]
	add #2, %r13
// Jmp
	jmp [__bbcc_00000002]
// Label
__bbcc_00000001:
// ReadAt
	mov WORD 6[%r11], %r0
	mov WORD [%r0], %r0
// NotEqualJmp
	cmp #57, %r0
	jnz [__bbcc_00000003]
// Jmp
	jmp [__bbcc_00000004]
// Label
__bbcc_00000003:
// AddrOf
	lea WORD [__bbcc_00000033], %r0
// Set
// CallFunction
	push %r0
	call [printf]
	add #2, %r13
// Set
	mov #0, %r0
// Set
	mov %r0, %r1
// Label
__bbcc_00000005:
// ReadAt
	mov WORD 6[%r11], %r0
	mov WORD 4[%r0], %r0
// MoreEqualJmp
	cmp %r1, %r0
	jge [__bbcc_00000007]
// ReadAt
	mov WORD 6[%r11], %r0
	mov WORD 2[%r0], %r0
// ReadAt
	add %r1, %r0
	mov BYTE [%r0], %r0
// Set
// CallFunction
	push %r0
	call [putchar]
	add #2, %r13
// Label
__bbcc_00000006:
// Add
	mov #1, %r0
	add %r1, %r0
// Set
	mov %r0, %r1
// Jmp
	jmp [__bbcc_00000005]
// Label
__bbcc_00000007:
// AddrOf
	lea WORD [__bbcc_00000034], %r0
// Set
// CallFunction
	push %r0
	call [printf]
	add #2, %r13
// Label
__bbcc_00000004:
// Label
__bbcc_00000002:
// AddrOf
	lea WORD [__bbcc_00000035], %r0
// Set
// CallFunction
	mov 8[%r11], %r1
	push %r1
	push %r0
	call [printf]
	add #4, %r13
// Set
	mov #1, %r0
// SetAt
	mov 4[%r11], %r1
	mov %r0, BYTE 16[%r1]
// Return
	mov #0, %r0
__bbcc_00000040:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: errorAtCurrent
errorAtCurrent:
	push %r11
	mov %r13, %r11
	push %r1
	push %r2
// Set
	mov WORD 4[%r11], %r2
// Add
	mov WORD 4[%r11], %r0
// Set
	mov %r0, %r1
// Set
	mov WORD 6[%r11], %r0
// CallFunction
	push %r0
	push %r1
	push %r2
	call [errorAt]
	add #6, %r13
// Return
	mov #0, %r0
__bbcc_00000041:
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: error
error:
	push %r11
	mov %r13, %r11
	push %r1
	push %r2
// Set
	mov WORD 4[%r11], %r2
// Add
	mov WORD 4[%r11], %r0
	add #8, %r0
// Set
	mov %r0, %r1
// Set
	mov WORD 6[%r11], %r0
// CallFunction
	push %r0
	push %r1
	push %r2
	call [errorAt]
	add #6, %r13
// Return
	mov #0, %r0
__bbcc_00000042:
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: advance
advance:
	push %r11
	mov %r13, %r11
	sub #16, %r13
	push %r1
	push %r2
// ReadAt
	mov WORD 4[%r11], %r0
	mov WORD [%r0], %r1
	mov %r1, WORD -16[%r11]
	mov WORD 2[%r0], %r1
	mov %r1, WORD -14[%r11]
	mov WORD 4[%r0], %r1
	mov %r1, WORD -12[%r11]
	mov WORD 6[%r0], %r1
	mov %r1, WORD -10[%r11]
// SetAt
	mov 4[%r11], %r0
	mov -16[%r11], %r1
	mov %r1, WORD 8[%r0]
	mov -14[%r11], %r1
	mov %r1, WORD 10[%r0]
	mov -12[%r11], %r1
	mov %r1, WORD 12[%r0]
	mov -10[%r11], %r1
	mov %r1, WORD 14[%r0]
// Label
__bbcc_00000008:
// ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 20[%r0], %r0
// Set
	mov %r0, %r1
// AddrOf
	lea WORD -8[%r11], %r0
// Set
// CallFunction
	push %r0
	push %r1
	call [scanToken]
	add #4, %r13
// AddrOf
	lea WORD [__bbcc_00000036], %r0
// Set
	mov %r0, %r2
// AddrOf
	lea WORD -8[%r11], %r0
// ReadAt
	mov WORD 6[%r0], %r1
// AddrOf
	lea WORD -8[%r11], %r0
// ReadAt
	mov WORD [%r0], %r0
// CallFunction
	push %r0
	push %r1
	push %r2
	call [printf]
	add #6, %r13
// Set
	mov #0, %r0
// Set
	mov %r0, %r2
// Label
__bbcc_0000000b:
// AddrOf
	lea WORD -8[%r11], %r0
// ReadAt
	mov WORD 4[%r0], %r0
// MoreEqualJmp
	cmp %r2, %r0
	jge [__bbcc_0000000d]
// AddrOf
	lea WORD [__bbcc_00000037], %r0
// Set
	mov %r0, %r1
// AddrOf
	lea WORD -8[%r11], %r0
// ReadAt
	mov WORD 2[%r0], %r0
// ReadAt
	add %r2, %r0
	mov BYTE [%r0], %r0
// CallFunction
	push %r0
	push %r1
	call [printf]
	add #4, %r13
// Label
__bbcc_0000000c:
// Add
	mov #1, %r0
	add %r2, %r0
// Set
	mov %r0, %r2
// Jmp
	jmp [__bbcc_0000000b]
// Label
__bbcc_0000000d:
// AddrOf
	lea WORD [__bbcc_00000038], %r0
// Set
// CallFunction
	push %r0
	call [printf]
	add #2, %r13
// SetAt
	mov 4[%r11], %r0
	mov -8[%r11], %r1
	mov %r1, WORD [%r0]
	mov -6[%r11], %r1
	mov %r1, WORD 2[%r0]
	mov -4[%r11], %r1
	mov %r1, WORD 4[%r0]
	mov -2[%r11], %r1
	mov %r1, WORD 6[%r0]
// Add
	mov WORD 4[%r11], %r0
// ReadAt
	mov WORD [%r0], %r0
// EqualJmp
	cmp #57, %r0
	jze [__bbcc_0000000e]
// Jmp
	jmp [__bbcc_0000000a]
// Label
__bbcc_0000000e:
// Set
	mov WORD 4[%r11], %r1
// Add
	mov WORD 4[%r11], %r0
// ReadAt
	mov WORD 2[%r0], %r0
// Set
// CallFunction
	push %r0
	push %r1
	call [errorAtCurrent]
	add #4, %r13
// Label
__bbcc_00000009:
// Jmp
	jmp [__bbcc_00000008]
// Label
__bbcc_0000000a:
// Return
	mov #0, %r0
__bbcc_00000043:
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: consume
consume:
	push %r11
	mov %r13, %r11
	push %r1
// Add
	mov WORD 4[%r11], %r0
// ReadAt
	mov WORD [%r0], %r0
// NotEqualJmp
	cmp 6[%r11], %r0
	jnz [__bbcc_0000000f]
// Set
	mov WORD 4[%r11], %r0
// CallFunction
	push %r0
	call [advance]
	add #2, %r13
// Return
	mov #0, %r0
	jmp [__bbcc_00000044]
// Label
__bbcc_0000000f:
// Set
	mov WORD 4[%r11], %r1
// Set
	mov WORD 8[%r11], %r0
// CallFunction
	push %r0
	push %r1
	call [errorAtCurrent]
	add #4, %r13
// Return
	mov #0, %r0
__bbcc_00000044:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: emitByte
emitByte:
	push %r11
	mov %r13, %r11
	push %r1
	push %r2
// Set
	mov WORD 4[%r11], %r0
// CallFunction
	push %r0
	call [currentChunk]
	add #2, %r13
// Set
	mov %r0, %r1
// Add
	mov WORD 4[%r11], %r0
	add #8, %r0
// ReadAt
	mov WORD 6[%r0], %r0
// Set
// CallFunction
	push %r0
	mov 6[%r11], %r2
	push %r2
	push %r1
	call [writeChunk]
	add #6, %r13
// Return
	mov #0, %r0
__bbcc_00000045:
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: emitBytes
emitBytes:
	push %r11
	mov %r13, %r11
	push %r1
// Set
	mov WORD 4[%r11], %r0
// CallFunction
	mov 6[%r11], %r1
	push %r1
	push %r0
	call [emitByte]
	add #4, %r13
// Set
	mov WORD 4[%r11], %r0
// CallFunction
	mov 8[%r11], %r1
	push %r1
	push %r0
	call [emitByte]
	add #4, %r13
// Return
	mov #0, %r0
__bbcc_00000046:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: emitReturn
emitReturn:
	push %r11
	mov %r13, %r11
	push %r1
// Set
	mov WORD 4[%r11], %r1
// Set
	mov #8, %r0
// CallFunction
	push %r0
	push %r1
	call [emitByte]
	add #4, %r13
// Return
	mov #0, %r0
__bbcc_00000047:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: makeConstant
makeConstant:
	push %r11
	mov %r13, %r11
	push %r1
	push %r2
// Set
	mov WORD 4[%r11], %r0
// CallFunction
	push %r0
	call [currentChunk]
	add #2, %r13
// Set
	mov %r0, %r1
// Set
	mov WORD 6[%r11], %r0
// CallFunction
	push %r0
	push %r1
	call [addConstant]
	add #4, %r13
// Set
// Set
	mov %r0, %r2
// LessEqualJmp
	mov #256, %r0
	cmp %r2, %r0
	jle [__bbcc_00000010]
// Set
	mov WORD 4[%r11], %r1
// AddrOf
	lea WORD [__bbcc_00000039], %r0
// Set
// CallFunction
	push %r0
	push %r1
	call [error]
	add #4, %r13
// Return
	mov #0, %r0
	jmp [__bbcc_00000048]
// Label
__bbcc_00000010:
// Set
	mov %r2, %r0
// Return
__bbcc_00000048:
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: emitConstant
emitConstant:
	push %r11
	mov %r13, %r11
	push %r1
	push %r2
	push %r3
// Set
	mov WORD 4[%r11], %r3
// Set
	mov #0, %r2
// Set
	mov WORD 4[%r11], %r1
// Set
	mov WORD 6[%r11], %r0
// CallFunction
	push %r0
	push %r1
	call [makeConstant]
	add #4, %r13
// CallFunction
	push %r0
	push %r2
	push %r3
	call [emitBytes]
	add #6, %r13
// Return
	mov #0, %r0
__bbcc_00000049:
	pop %r3
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: endCompiler
endCompiler:
	push %r11
	mov %r13, %r11
	push %r1
// Set
	mov WORD 4[%r11], %r0
// CallFunction
	push %r0
	call [emitReturn]
	add #2, %r13
// ReadAt
	mov WORD 4[%r11], %r0
	mov BYTE 16[%r0], %r0
// JmpNotZero
	cmp #0, %r0
	jnz [__bbcc_00000011]
// AddrOf
	lea WORD [__bbcc_00000038], %r0
// Set
// CallFunction
	push %r0
	call [printf]
	add #2, %r13
// Set
	mov WORD 4[%r11], %r0
// CallFunction
	push %r0
	call [currentChunk]
	add #2, %r13
// Set
	mov %r0, %r1
// AddrOf
	lea WORD [__bbcc_0000003a], %r0
// Set
// CallFunction
	push %r0
	push %r1
	call [disassembleChunk]
	add #4, %r13
// Label
__bbcc_00000011:
// Return
	mov #0, %r0
__bbcc_0000004a:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: number
number:
	push %r11
	mov %r13, %r11
	sub #3, %r13
	push %r1
// Add
	mov WORD 4[%r11], %r0
	add #8, %r0
// ReadAt
	mov WORD 2[%r0], %r0
// Set
// CallFunction
	push %r0
	call [atoi]
	add #2, %r13
// Set
	mov %r0, %r1
// AddrOf
	lea WORD -3[%r11], %r0
// Set
// CallFunction
	push %r0
	push %r1
	call [intVal]
	add #4, %r13
// Set
	mov WORD 4[%r11], %r1
// AddrOf
	lea WORD -3[%r11], %r0
// Set
// CallFunction
	push %r0
	push %r1
	call [emitConstant]
	add #4, %r13
// Return
	mov #0, %r0
__bbcc_0000004b:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: string
string:
	push %r11
	mov %r13, %r11
	sub #3, %r13
	push %r1
	push %r2
// Add
	mov WORD 4[%r11], %r0
	add #8, %r0
// ReadAt
	mov WORD 2[%r0], %r0
// Set
	mov #1, %r1
// Add
	add %r1, %r0
// Set
	mov %r0, %r2
// Add
	mov WORD 4[%r11], %r0
	add #8, %r0
// ReadAt
	mov WORD 4[%r0], %r0
// Sub
	sub #2, %r0
// ReadAt
	mov WORD 4[%r11], %r1
	mov WORD 22[%r1], %r1
// Set
// CallFunction
	push %r1
	push %r0
	push %r2
	call [copyString]
	add #6, %r13
// Set
	mov %r0, %r1
// AddrOf
	lea WORD -3[%r11], %r0
// Set
// CallFunction
	push %r0
	push %r1
	call [objVal]
	add #4, %r13
// Set
	mov WORD 4[%r11], %r1
// AddrOf
	lea WORD -3[%r11], %r0
// Set
// CallFunction
	push %r0
	push %r1
	call [emitConstant]
	add #4, %r13
// Return
	mov #0, %r0
__bbcc_0000004c:
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: newline
newline:
	push %r11
	mov %r13, %r11
// Return
	mov #0, %r0
__bbcc_0000004d:
	mov %r11, %r13
	pop %r11
	ret
// Function: grouping
grouping:
	push %r11
	mov %r13, %r11
	push %r1
	push %r2
// Set
	mov WORD 4[%r11], %r0
// CallFunction
	push %r0
	call [expression]
	add #2, %r13
// Set
	mov WORD 4[%r11], %r2
// Set
	mov #11, %r1
// AddrOf
	lea WORD [__bbcc_0000003b], %r0
// Set
// CallFunction
	push %r0
	push %r1
	push %r2
	call [consume]
	add #6, %r13
// Return
	mov #0, %r0
__bbcc_0000004e:
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: binary
binary:
	push %r11
	mov %r13, %r11
	push %r1
	push %r2
	push %r3
// Add
	mov WORD 4[%r11], %r0
	add #8, %r0
// ReadAt
	mov WORD [%r0], %r0
// Set
	mov %r0, %r3
// CallFunction
	push %r3
	call [getRule]
	add #2, %r13
// Set
// Set
// Set
	mov WORD 4[%r11], %r1
// ReadAt
	mov BYTE 4[%r0], %r0
// Set
// Add
	add #1, %r0
// Set
// CallFunction
	push %r0
	push %r1
	call [parsePrecedence]
	add #4, %r13
// NotEqualJmp
	cmp #3, %r3
	jnz [__bbcc_00000012]
// Set
	mov WORD 4[%r11], %r1
// Set
	mov #3, %r0
// CallFunction
	push %r0
	push %r1
	call [emitByte]
	add #4, %r13
// Jmp
	jmp [__bbcc_00000013]
// Label
__bbcc_00000012:
// NotEqualJmp
	cmp #4, %r3
	jnz [__bbcc_00000014]
// Set
	mov WORD 4[%r11], %r1
// Set
	mov #4, %r0
// CallFunction
	push %r0
	push %r1
	call [emitByte]
	add #4, %r13
// Jmp
	jmp [__bbcc_00000015]
// Label
__bbcc_00000014:
// NotEqualJmp
	cmp #6, %r3
	jnz [__bbcc_00000016]
// Set
	mov WORD 4[%r11], %r1
// Set
	mov #5, %r0
// CallFunction
	push %r0
	push %r1
	call [emitByte]
	add #4, %r13
// Jmp
	jmp [__bbcc_00000017]
// Label
__bbcc_00000016:
// NotEqualJmp
	cmp #5, %r3
	jnz [__bbcc_00000018]
// Set
	mov WORD 4[%r11], %r1
// Set
	mov #6, %r0
// CallFunction
	push %r0
	push %r1
	call [emitByte]
	add #4, %r13
// Jmp
	jmp [__bbcc_00000019]
// Label
__bbcc_00000018:
// NotEqualJmp
	cmp #50, %r3
	jnz [__bbcc_0000001a]
// Set
	mov WORD 4[%r11], %r1
// Set
	mov #10, %r0
// CallFunction
	push %r0
	push %r1
	call [emitByte]
	add #4, %r13
// Jmp
	jmp [__bbcc_0000001b]
// Label
__bbcc_0000001a:
// NotEqualJmp
	cmp #51, %r3
	jnz [__bbcc_0000001c]
// Set
	mov WORD 4[%r11], %r2
// Set
	mov #10, %r1
// Set
	mov #9, %r0
// CallFunction
	push %r0
	push %r1
	push %r2
	call [emitBytes]
	add #6, %r13
// Jmp
	jmp [__bbcc_0000001d]
// Label
__bbcc_0000001c:
// NotEqualJmp
	cmp #52, %r3
	jnz [__bbcc_0000001e]
// Set
	mov WORD 4[%r11], %r1
// Set
	mov #11, %r0
// CallFunction
	push %r0
	push %r1
	call [emitByte]
	add #4, %r13
// Jmp
	jmp [__bbcc_0000001f]
// Label
__bbcc_0000001e:
// NotEqualJmp
	cmp #53, %r3
	jnz [__bbcc_00000020]
// Set
	mov WORD 4[%r11], %r2
// Set
	mov #12, %r1
// Set
	mov #9, %r0
// CallFunction
	push %r0
	push %r1
	push %r2
	call [emitBytes]
	add #6, %r13
// Jmp
	jmp [__bbcc_00000021]
// Label
__bbcc_00000020:
// NotEqualJmp
	cmp #54, %r3
	jnz [__bbcc_00000022]
// Set
	mov WORD 4[%r11], %r1
// Set
	mov #12, %r0
// CallFunction
	push %r0
	push %r1
	call [emitByte]
	add #4, %r13
// Jmp
	jmp [__bbcc_00000023]
// Label
__bbcc_00000022:
// NotEqualJmp
	cmp #55, %r3
	jnz [__bbcc_00000024]
// Set
	mov WORD 4[%r11], %r2
// Set
	mov #11, %r1
// Set
	mov #9, %r0
// CallFunction
	push %r0
	push %r1
	push %r2
	call [emitBytes]
	add #6, %r13
// Label
__bbcc_00000024:
// Label
__bbcc_00000023:
// Label
__bbcc_00000021:
// Label
__bbcc_0000001f:
// Label
__bbcc_0000001d:
// Label
__bbcc_0000001b:
// Label
__bbcc_00000019:
// Label
__bbcc_00000017:
// Label
__bbcc_00000015:
// Label
__bbcc_00000013:
// Return
	mov #0, %r0
__bbcc_0000004f:
	pop %r3
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: unary
unary:
	push %r11
	mov %r13, %r11
	push %r1
	push %r2
// Add
	mov WORD 4[%r11], %r0
	add #8, %r0
// ReadAt
	mov WORD [%r0], %r0
// Set
	mov %r0, %r2
// Set
	mov WORD 4[%r11], %r1
// Set
	mov #15, %r0
// CallFunction
	push %r0
	push %r1
	call [parsePrecedence]
	add #4, %r13
// NotEqualJmp
	cmp #4, %r2
	jnz [__bbcc_00000025]
// Set
	mov WORD 4[%r11], %r1
// Set
	mov #2, %r0
// CallFunction
	push %r0
	push %r1
	call [emitByte]
	add #4, %r13
// Jmp
	jmp [__bbcc_00000026]
// Label
__bbcc_00000025:
// NotEqualJmp
	cmp #42, %r2
	jnz [__bbcc_00000027]
// Set
	mov WORD 4[%r11], %r1
// Set
	mov #9, %r0
// CallFunction
	push %r0
	push %r1
	call [emitByte]
	add #4, %r13
// Label
__bbcc_00000027:
// Label
__bbcc_00000026:
// Return
	mov #0, %r0
__bbcc_00000050:
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: literal
literal:
	push %r11
	mov %r13, %r11
	sub #3, %r13
	push %r1
	push %r2
// Add
	mov WORD 4[%r11], %r0
	add #8, %r0
// ReadAt
	mov WORD [%r0], %r0
// Set
	mov %r0, %r2
// NotEqualJmp
	cmp #19, %r2
	jnz [__bbcc_00000028]
// AddrOf
	lea WORD -3[%r11], %r0
// Set
// CallFunction
	push %r0
	call [noneVal]
	add #2, %r13
// Set
	mov WORD 4[%r11], %r1
// AddrOf
	lea WORD -3[%r11], %r0
// Set
// CallFunction
	push %r0
	push %r1
	call [emitConstant]
	add #4, %r13
// Jmp
	jmp [__bbcc_00000029]
// Label
__bbcc_00000028:
// NotEqualJmp
	cmp #24, %r2
	jnz [__bbcc_0000002a]
// Set
	mov #1, %r1
// AddrOf
	lea WORD -3[%r11], %r0
// Set
// CallFunction
	push %r0
	push %r1
	call [boolVal]
	add #4, %r13
// Set
	mov WORD 4[%r11], %r1
// AddrOf
	lea WORD -3[%r11], %r0
// Set
// CallFunction
	push %r0
	push %r1
	call [emitConstant]
	add #4, %r13
// Jmp
	jmp [__bbcc_0000002b]
// Label
__bbcc_0000002a:
// NotEqualJmp
	cmp #14, %r2
	jnz [__bbcc_0000002c]
// Set
	mov #0, %r1
// AddrOf
	lea WORD -3[%r11], %r0
// Set
// CallFunction
	push %r0
	push %r1
	call [boolVal]
	add #4, %r13
// Set
	mov WORD 4[%r11], %r1
// AddrOf
	lea WORD -3[%r11], %r0
// Set
// CallFunction
	push %r0
	push %r1
	call [emitConstant]
	add #4, %r13
// Label
__bbcc_0000002c:
// Label
__bbcc_0000002b:
// Label
__bbcc_00000029:
// Return
	mov #0, %r0
__bbcc_00000051:
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: getRule
getRule:
	push %r11
	mov %r13, %r11
	push %r1
// AddrOf
	lea WORD [rules], %r0
// Mult
	mov #5, %r1
	mul WORD 4[%r11], %r1
// Add
	add %r1, %r0
// Return
__bbcc_00000052:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: initRule
initRule:
	push %r11
	mov %r13, %r11
	push %r1
// Set
	mov WORD 6[%r11], %r0
// SetAt
	mov 4[%r11], %r1
	mov %r0, WORD [%r1]
// Set
	mov WORD 8[%r11], %r0
// SetAt
	mov 4[%r11], %r1
	mov %r0, WORD 2[%r1]
// SetAt
	mov 4[%r11], %r0
	mov 10[%r11], %r1
	mov %r1, BYTE 4[%r0]
// Return
	mov #0, %r0
__bbcc_00000053:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: expression
expression:
	push %r11
	mov %r13, %r11
	push %r1
// Set
	mov WORD 4[%r11], %r1
// Set
	mov #1, %r0
// CallFunction
	push %r0
	push %r1
	call [parsePrecedence]
	add #4, %r13
// Return
	mov #0, %r0
__bbcc_00000054:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: parsePrecedence
parsePrecedence:
	push %r11
	mov %r13, %r11
	push %r1
	push %r2
// Set
	mov WORD 4[%r11], %r0
// CallFunction
	push %r0
	call [advance]
	add #2, %r13
// Add
	mov WORD 4[%r11], %r0
	add #8, %r0
// ReadAt
	mov WORD [%r0], %r0
// CallFunction
	push %r0
	call [getRule]
	add #2, %r13
// ReadAt
	mov WORD [%r0], %r0
// Set
// Set
	mov %r0, %r2
// NotEqualJmp
	cmp #0, %r2
	jnz [__bbcc_0000002d]
// Set
	mov WORD 4[%r11], %r1
// AddrOf
	lea WORD [__bbcc_0000003c], %r0
// Set
// CallFunction
	push %r0
	push %r1
	call [error]
	add #4, %r13
// Return
	mov #0, %r0
	jmp [__bbcc_00000055]
// Label
__bbcc_0000002d:
// Set
	mov WORD 4[%r11], %r0
// CallFunction
	push %r0
	call [%r2]
	add #2, %r13
// Label
__bbcc_0000002e:
// Add
	mov WORD 4[%r11], %r0
// ReadAt
	mov WORD [%r0], %r0
// CallFunction
	push %r0
	call [getRule]
	add #2, %r13
// ReadAt
	mov BYTE 4[%r0], %r0
// MoreThanJmp
	cmp 6[%r11], %r0
	ja [__bbcc_0000002f]
// Set
	mov WORD 4[%r11], %r0
// CallFunction
	push %r0
	call [advance]
	add #2, %r13
// Add
	mov WORD 4[%r11], %r0
	add #8, %r0
// ReadAt
	mov WORD [%r0], %r0
// CallFunction
	push %r0
	call [getRule]
	add #2, %r13
// ReadAt
	mov WORD 2[%r0], %r0
// Set
// Set
	mov %r0, %r1
// Set
	mov WORD 4[%r11], %r0
// CallFunction
	push %r0
	call [%r1]
	add #2, %r13
// Jmp
	jmp [__bbcc_0000002e]
// Label
__bbcc_0000002f:
// Return
	mov #0, %r0
__bbcc_00000055:
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: compile
compile:
	push %r11
	mov %r13, %r11
	sub #73, %r13
	push %r1
	push %r2
	push %r3
// AddrOf
	lea WORD [rules], %r0
// Add
// Set
	mov %r0, %r3
// AddrOf
	lea WORD [number], %r0
// Set
	mov %r0, %r2
// Set
	mov #0, %r1
// Set
	mov #0, %r0
// CallFunction
	push %r0
	push %r1
	push %r2
	push %r3
	call [initRule]
	add #8, %r13
// AddrOf
	lea WORD [rules], %r0
// Add
	add #5, %r0
// Set
	mov %r0, %r3
// AddrOf
	lea WORD [string], %r0
// Set
	mov %r0, %r2
// Set
	mov #0, %r1
// Set
	mov #0, %r0
// CallFunction
	push %r0
	push %r1
	push %r2
	push %r3
	call [initRule]
	add #8, %r13
// AddrOf
	lea WORD [rules], %r0
// Add
	add #95, %r0
// Set
	mov %r0, %r3
// AddrOf
	lea WORD [literal], %r0
// Set
	mov %r0, %r2
// Set
	mov #0, %r1
// Set
	mov #0, %r0
// CallFunction
	push %r0
	push %r1
	push %r2
	push %r3
	call [initRule]
	add #8, %r13
// AddrOf
	lea WORD [rules], %r0
// Add
	add #120, %r0
// Set
	mov %r0, %r3
// AddrOf
	lea WORD [literal], %r0
// Set
	mov %r0, %r2
// Set
	mov #0, %r1
// Set
	mov #0, %r0
// CallFunction
	push %r0
	push %r1
	push %r2
	push %r3
	call [initRule]
	add #8, %r13
// AddrOf
	lea WORD [rules], %r0
// Add
	add #70, %r0
// Set
	mov %r0, %r3
// AddrOf
	lea WORD [literal], %r0
// Set
	mov %r0, %r2
// Set
	mov #0, %r1
// Set
	mov #0, %r0
// CallFunction
	push %r0
	push %r1
	push %r2
	push %r3
	call [initRule]
	add #8, %r13
// AddrOf
	lea WORD [rules], %r0
// Add
	add #15, %r0
// Set
	mov %r0, %r3
// AddrOf
	lea WORD [unary], %r0
// Set
	mov %r0, %r2
// AddrOf
	lea WORD [binary], %r0
// Set
	mov %r0, %r1
// Set
	mov #13, %r0
// CallFunction
	push %r0
	push %r1
	push %r2
	push %r3
	call [initRule]
	add #8, %r13
// AddrOf
	lea WORD [rules], %r0
// Add
	add #20, %r0
// Set
	mov %r0, %r3
// AddrOf
	lea WORD [unary], %r0
// Set
	mov %r0, %r2
// AddrOf
	lea WORD [binary], %r0
// Set
	mov %r0, %r1
// Set
	mov #13, %r0
// CallFunction
	push %r0
	push %r1
	push %r2
	push %r3
	call [initRule]
	add #8, %r13
// AddrOf
	lea WORD [rules], %r0
// Add
	add #30, %r0
// Set
	mov %r0, %r3
// Set
	mov #0, %r2
// AddrOf
	lea WORD [binary], %r0
// Set
	mov %r0, %r1
// Set
	mov #14, %r0
// CallFunction
	push %r0
	push %r1
	push %r2
	push %r3
	call [initRule]
	add #8, %r13
// AddrOf
	lea WORD [rules], %r0
// Add
	add #25, %r0
// Set
	mov %r0, %r3
// Set
	mov #0, %r2
// AddrOf
	lea WORD [binary], %r0
// Set
	mov %r0, %r1
// Set
	mov #14, %r0
// CallFunction
	push %r0
	push %r1
	push %r2
	push %r3
	call [initRule]
	add #8, %r13
// AddrOf
	lea WORD [rules], %r0
// Add
	add #210, %r0
// Set
	mov %r0, %r3
// AddrOf
	lea WORD [unary], %r0
// Set
	mov %r0, %r2
// Set
	mov #0, %r1
// Set
	mov #0, %r0
// CallFunction
	push %r0
	push %r1
	push %r2
	push %r3
	call [initRule]
	add #8, %r13
// AddrOf
	lea WORD [rules], %r0
// Add
	add #250, %r0
// Set
	mov %r0, %r3
// Set
	mov #0, %r2
// AddrOf
	lea WORD [binary], %r0
// Set
	mov %r0, %r1
// Set
	mov #8, %r0
// CallFunction
	push %r0
	push %r1
	push %r2
	push %r3
	call [initRule]
	add #8, %r13
// AddrOf
	lea WORD [rules], %r0
// Add
	add #255, %r0
// Set
	mov %r0, %r3
// Set
	mov #0, %r2
// AddrOf
	lea WORD [binary], %r0
// Set
	mov %r0, %r1
// Set
	mov #8, %r0
// CallFunction
	push %r0
	push %r1
	push %r2
	push %r3
	call [initRule]
	add #8, %r13
// AddrOf
	lea WORD [rules], %r0
// Add
	add #260, %r0
// Set
	mov %r0, %r3
// Set
	mov #0, %r2
// AddrOf
	lea WORD [binary], %r0
// Set
	mov %r0, %r1
// Set
	mov #8, %r0
// CallFunction
	push %r0
	push %r1
	push %r2
	push %r3
	call [initRule]
	add #8, %r13
// AddrOf
	lea WORD [rules], %r0
// Add
	add #265, %r0
// Set
	mov %r0, %r3
// Set
	mov #0, %r2
// AddrOf
	lea WORD [binary], %r0
// Set
	mov %r0, %r1
// Set
	mov #8, %r0
// CallFunction
	push %r0
	push %r1
	push %r2
	push %r3
	call [initRule]
	add #8, %r13
// AddrOf
	lea WORD [rules], %r0
// Add
	add #270, %r0
// Set
	mov %r0, %r3
// Set
	mov #0, %r2
// AddrOf
	lea WORD [binary], %r0
// Set
	mov %r0, %r1
// Set
	mov #8, %r0
// CallFunction
	push %r0
	push %r1
	push %r2
	push %r3
	call [initRule]
	add #8, %r13
// AddrOf
	lea WORD [rules], %r0
// Add
	add #275, %r0
// Set
	mov %r0, %r3
// Set
	mov #0, %r2
// AddrOf
	lea WORD [binary], %r0
// Set
	mov %r0, %r1
// Set
	mov #8, %r0
// CallFunction
	push %r0
	push %r1
	push %r2
	push %r3
	call [initRule]
	add #8, %r13
// AddrOf
	lea WORD [rules], %r0
// Add
	add #50, %r0
// Set
	mov %r0, %r3
// AddrOf
	lea WORD [grouping], %r0
// Set
	mov %r0, %r2
// Set
	mov #0, %r1
// Set
	mov #18, %r0
// CallFunction
	push %r0
	push %r1
	push %r2
	push %r3
	call [initRule]
	add #8, %r13
// AddrOf
	lea WORD [rules], %r0
// Add
	add #290, %r0
// Set
	mov %r0, %r3
// Set
	mov #0, %r2
// AddrOf
	lea WORD [newline], %r0
// Set
	mov %r0, %r1
// Set
	mov #1, %r0
// CallFunction
	push %r0
	push %r1
	push %r2
	push %r3
	call [initRule]
	add #8, %r13
// AddrOf
	lea WORD -49[%r11], %r0
// Set
	mov %r0, %r1
// Set
	mov WORD 4[%r11], %r0
// CallFunction
	push %r0
	push %r1
	call [initScanner]
	add #4, %r13
// AddrOf
	lea WORD -73[%r11], %r1
// Set
	mov WORD 6[%r11], %r0
// SetAt
	mov %r0, WORD 18[%r1]
// AddrOf
	lea WORD -49[%r11], %r0
// AddrOf
	lea WORD -73[%r11], %r1
// Set
// SetAt
	mov %r0, WORD 20[%r1]
// AddrOf
	lea WORD -73[%r11], %r1
// Set
	mov WORD 8[%r11], %r0
// SetAt
	mov %r0, WORD 22[%r1]
// AddrOf
	lea WORD -73[%r11], %r1
// Set
	mov #0, %r0
// SetAt
	mov %r0, BYTE 16[%r1]
// AddrOf
	lea WORD -73[%r11], %r1
// Set
	mov #0, %r0
// SetAt
	mov %r0, BYTE 17[%r1]
// AddrOf
	lea WORD [__bbcc_0000003d], %r0
// Set
// CallFunction
	push %r0
	call [printf]
	add #2, %r13
// AddrOf
	lea WORD -73[%r11], %r0
// Set
// CallFunction
	push %r0
	call [advance]
	add #2, %r13
// AddrOf
	lea WORD -73[%r11], %r0
// Set
// CallFunction
	push %r0
	call [expression]
	add #2, %r13
// AddrOf
	lea WORD -73[%r11], %r0
// Set
	mov %r0, %r2
// Set
	mov #56, %r1
// AddrOf
	lea WORD [__bbcc_0000003e], %r0
// Set
// CallFunction
	push %r0
	push %r1
	push %r2
	call [consume]
	add #6, %r13
// AddrOf
	lea WORD -73[%r11], %r0
// Set
// CallFunction
	push %r0
	call [endCompiler]
	add #2, %r13
// Set
	mov #1, %r1
// AddrOf
	lea WORD -73[%r11], %r0
// ReadAt
	mov BYTE 16[%r0], %r0
// JmpZero
	cmp #0, %r0
	jze [__bbcc_00000030]
// Set
	mov #0, %r1
// Label
__bbcc_00000030:
// Return
	mov %r1, %r0
__bbcc_00000056:
	pop %r3
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret