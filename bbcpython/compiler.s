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
.export number
.export rules
.export initRule
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
__bbcc_0000003f:
.byte #69,#78,#68,#32,#80,#65,#82,#83,#69,#10,#0
rules:
.byte #0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
// Function: currentChunk
currentChunk:
	push %r12
	mov %r14, %r12
// ReadAt
	mov DWORD 8[%r12], %r0
	mov DWORD 34[%r0], %r0
// Return
__bbcc_00000040:
	mov %r12, %r14
	pop %r12
	ret
// Function: errorAt
errorAt:
	push %r12
	mov %r14, %r12
	push %r1
// ReadAt
	mov DWORD 8[%r12], %r0
	mov BYTE 33[%r0], %r0
// JmpZero
	cmp #0, %r0
	jze [__bbcc_00000000]
// Return
	mov #0, %r0
	jmp [__bbcc_00000041]
// Label
__bbcc_00000000:
// Set
	mov #1, %r0
// SetAt
	mov 8[%r12], %r1
	mov %r0, BYTE 33[%r1]
// AddrOf
	lea DWORD [__bbcc_00000031], %r0
// Set
	mov %r0, %r1
// ReadAt
	mov DWORD 12[%r12], %r0
	mov DWORD 12[%r0], %r0
// CallFunction
	push %r0
	push %r1
	call [printf]
	add #8, %r14
// ReadAt
	mov DWORD 12[%r12], %r0
	mov DWORD [%r0], %r0
// NotEqualJmp
	cmp #56, %r0
	jnz [__bbcc_00000001]
// AddrOf
	lea DWORD [__bbcc_00000032], %r0
// Set
// CallFunction
	push %r0
	call [printf]
	add #4, %r14
// Jmp
	jmp [__bbcc_00000002]
// Label
__bbcc_00000001:
// ReadAt
	mov DWORD 12[%r12], %r0
	mov DWORD [%r0], %r0
// NotEqualJmp
	cmp #57, %r0
	jnz [__bbcc_00000003]
// Jmp
	jmp [__bbcc_00000004]
// Label
__bbcc_00000003:
// AddrOf
	lea DWORD [__bbcc_00000033], %r0
// Set
// CallFunction
	push %r0
	call [printf]
	add #4, %r14
// Set
	mov #0, %r0
// Set
	mov %r0, %r1
// Label
__bbcc_00000005:
// ReadAt
	mov DWORD 12[%r12], %r0
	mov DWORD 8[%r0], %r0
// MoreEqualJmp
	cmp %r1, %r0
	jge [__bbcc_00000007]
// ReadAt
	mov DWORD 12[%r12], %r0
	mov DWORD 4[%r0], %r0
// ReadAt
	add %r1, %r0
	mov BYTE [%r0], %r0
// Set
// CallFunction
	push %r0
	call [putchar]
	add #4, %r14
// Label
__bbcc_00000006:
// Inc
	inc %r1
// Jmp
	jmp [__bbcc_00000005]
// Label
__bbcc_00000007:
// AddrOf
	lea DWORD [__bbcc_00000034], %r0
// Set
// CallFunction
	push %r0
	call [printf]
	add #4, %r14
// Label
__bbcc_00000004:
// Label
__bbcc_00000002:
// AddrOf
	lea DWORD [__bbcc_00000035], %r0
// Set
// CallFunction
	mov DWORD 16[%r12], %r1
	push %r1
	push %r0
	call [printf]
	add #8, %r14
// Set
	mov #1, %r0
// SetAt
	mov 8[%r12], %r1
	mov %r0, BYTE 32[%r1]
// Return
	mov #0, %r0
__bbcc_00000041:
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: errorAtCurrent
errorAtCurrent:
	push %r12
	mov %r14, %r12
	push %r1
	push %r2
// Set
	mov DWORD 8[%r12], %r2
// Add
	mov DWORD 8[%r12], %r0
// Set
	mov %r0, %r1
// Set
	mov DWORD 12[%r12], %r0
// CallFunction
	push %r0
	push %r1
	push %r2
	call [errorAt]
	add #12, %r14
// Return
	mov #0, %r0
__bbcc_00000042:
	pop %r2
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: error
error:
	push %r12
	mov %r14, %r12
	push %r1
	push %r2
// Set
	mov DWORD 8[%r12], %r2
// Add
	mov DWORD 8[%r12], %r0
	add #16, %r0
// Set
	mov %r0, %r1
// Set
	mov DWORD 12[%r12], %r0
// CallFunction
	push %r0
	push %r1
	push %r2
	call [errorAt]
	add #12, %r14
// Return
	mov #0, %r0
__bbcc_00000043:
	pop %r2
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: advance
advance:
	push %r12
	mov %r14, %r12
	sub #32, %r14
	push %r1
	push %r2
// ReadAt
	mov DWORD 8[%r12], %r0
	mov DWORD [%r0], %r1
	mov %r1, DWORD -32[%r12]
	mov DWORD 4[%r0], %r1
	mov %r1, DWORD -28[%r12]
	mov DWORD 8[%r0], %r1
	mov %r1, DWORD -24[%r12]
	mov DWORD 12[%r0], %r1
	mov %r1, DWORD -20[%r12]
// SetAt
	mov 8[%r12], %r0
	mov -32[%r12], %r1
	mov %r1, DWORD 16[%r0]
	mov -28[%r12], %r1
	mov %r1, DWORD 20[%r0]
	mov -24[%r12], %r1
	mov %r1, DWORD 24[%r0]
	mov -20[%r12], %r1
	mov %r1, DWORD 28[%r0]
// Label
__bbcc_00000008:
// ReadAt
	mov DWORD 8[%r12], %r0
	mov DWORD 38[%r0], %r0
// Set
	mov %r0, %r1
// AddrOf
	lea DWORD -16[%r12], %r0
// Set
// CallFunction
	push %r0
	push %r1
	call [scanToken]
	add #8, %r14
// AddrOf
	lea DWORD [__bbcc_00000036], %r0
// Set
	mov %r0, %r2
// AddrOf
	lea DWORD -16[%r12], %r0
// ReadAt
	mov DWORD 12[%r0], %r1
// AddrOf
	lea DWORD -16[%r12], %r0
// ReadAt
	mov DWORD [%r0], %r0
// CallFunction
	push %r0
	push %r1
	push %r2
	call [printf]
	add #12, %r14
// Set
	mov #0, %r0
// Set
	mov %r0, %r2
// Label
__bbcc_0000000b:
// AddrOf
	lea DWORD -16[%r12], %r0
// ReadAt
	mov DWORD 8[%r0], %r0
// MoreEqualJmp
	cmp %r2, %r0
	jge [__bbcc_0000000d]
// AddrOf
	lea DWORD [__bbcc_00000037], %r0
// Set
	mov %r0, %r1
// AddrOf
	lea DWORD -16[%r12], %r0
// ReadAt
	mov DWORD 4[%r0], %r0
// ReadAt
	add %r2, %r0
	mov BYTE [%r0], %r0
// CallFunction
	push %r0
	push %r1
	call [printf]
	add #8, %r14
// Label
__bbcc_0000000c:
// Inc
	inc %r2
// Jmp
	jmp [__bbcc_0000000b]
// Label
__bbcc_0000000d:
// AddrOf
	lea DWORD [__bbcc_00000038], %r0
// Set
// CallFunction
	push %r0
	call [printf]
	add #4, %r14
// SetAt
	mov 8[%r12], %r0
	mov -16[%r12], %r1
	mov %r1, DWORD [%r0]
	mov -12[%r12], %r1
	mov %r1, DWORD 4[%r0]
	mov -8[%r12], %r1
	mov %r1, DWORD 8[%r0]
	mov -4[%r12], %r1
	mov %r1, DWORD 12[%r0]
// Add
	mov DWORD 8[%r12], %r0
// ReadAt
	mov DWORD [%r0], %r0
// EqualJmp
	cmp #57, %r0
	jze [__bbcc_0000000e]
// Jmp
	jmp [__bbcc_0000000a]
// Label
__bbcc_0000000e:
// Set
	mov DWORD 8[%r12], %r1
// Add
	mov DWORD 8[%r12], %r0
// ReadAt
	mov DWORD 4[%r0], %r0
// Set
// CallFunction
	push %r0
	push %r1
	call [errorAtCurrent]
	add #8, %r14
// Label
__bbcc_00000009:
// Jmp
	jmp [__bbcc_00000008]
// Label
__bbcc_0000000a:
// Return
	mov #0, %r0
__bbcc_00000044:
	pop %r2
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: consume
consume:
	push %r12
	mov %r14, %r12
	push %r1
// Add
	mov DWORD 8[%r12], %r0
// ReadAt
	mov DWORD [%r0], %r0
// NotEqualJmp
	cmp 12[%r12], %r0
	jnz [__bbcc_0000000f]
// Set
	mov DWORD 8[%r12], %r0
// CallFunction
	push %r0
	call [advance]
	add #4, %r14
// Return
	mov #0, %r0
	jmp [__bbcc_00000045]
// Label
__bbcc_0000000f:
// Set
	mov DWORD 8[%r12], %r1
// Set
	mov DWORD 16[%r12], %r0
// CallFunction
	push %r0
	push %r1
	call [errorAtCurrent]
	add #8, %r14
// Return
	mov #0, %r0
__bbcc_00000045:
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: emitByte
emitByte:
	push %r12
	mov %r14, %r12
	push %r1
	push %r2
// Set
	mov DWORD 8[%r12], %r0
// CallFunction
	push %r0
	call [currentChunk]
	add #4, %r14
// Set
	mov %r0, %r1
// Add
	mov DWORD 8[%r12], %r0
	add #16, %r0
// ReadAt
	mov DWORD 12[%r0], %r0
// Set
// CallFunction
	push %r0
	mov DWORD 12[%r12], %r2
	push %r2
	push %r1
	call [writeChunk]
	add #12, %r14
// Return
	mov #0, %r0
__bbcc_00000046:
	pop %r2
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: emitBytes
emitBytes:
	push %r12
	mov %r14, %r12
	push %r1
// Set
	mov DWORD 8[%r12], %r0
// CallFunction
	mov DWORD 12[%r12], %r1
	push %r1
	push %r0
	call [emitByte]
	add #8, %r14
// Set
	mov DWORD 8[%r12], %r0
// CallFunction
	mov DWORD 16[%r12], %r1
	push %r1
	push %r0
	call [emitByte]
	add #8, %r14
// Return
	mov #0, %r0
__bbcc_00000047:
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: emitReturn
emitReturn:
	push %r12
	mov %r14, %r12
	push %r1
// Set
	mov DWORD 8[%r12], %r1
// Set
	mov #8, %r0
// CallFunction
	push %r0
	push %r1
	call [emitByte]
	add #8, %r14
// Return
	mov #0, %r0
__bbcc_00000048:
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: makeConstant
makeConstant:
	push %r12
	mov %r14, %r12
	push %r1
	push %r2
// Set
	mov DWORD 8[%r12], %r0
// CallFunction
	push %r0
	call [currentChunk]
	add #4, %r14
// Set
	mov %r0, %r1
// Set
	mov DWORD 12[%r12], %r0
// CallFunction
	push %r0
	push %r1
	call [addConstant]
	add #8, %r14
// Set
// Set
	mov %r0, %r2
// LessEqualJmp
	mov #256, %r0
	cmp %r2, %r0
	jle [__bbcc_00000010]
// Set
	mov DWORD 8[%r12], %r1
// AddrOf
	lea DWORD [__bbcc_00000039], %r0
// Set
// CallFunction
	push %r0
	push %r1
	call [error]
	add #8, %r14
// Return
	mov #0, %r0
	jmp [__bbcc_00000049]
// Label
__bbcc_00000010:
// Set
	mov %r2, %r0
// Return
__bbcc_00000049:
	pop %r2
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: emitConstant
emitConstant:
	push %r12
	mov %r14, %r12
	push %r1
	push %r2
	push %r3
// Set
	mov DWORD 8[%r12], %r3
// Set
	mov #0, %r2
// Set
	mov DWORD 8[%r12], %r1
// Set
	mov DWORD 12[%r12], %r0
// CallFunction
	push %r0
	push %r1
	call [makeConstant]
	add #8, %r14
// CallFunction
	push %r0
	push %r2
	push %r3
	call [emitBytes]
	add #12, %r14
// Return
	mov #0, %r0
__bbcc_0000004a:
	pop %r3
	pop %r2
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: endCompiler
endCompiler:
	push %r12
	mov %r14, %r12
	push %r1
// Set
	mov DWORD 8[%r12], %r0
// CallFunction
	push %r0
	call [emitReturn]
	add #4, %r14
// ReadAt
	mov DWORD 8[%r12], %r0
	mov BYTE 32[%r0], %r0
// JmpNotZero
	cmp #0, %r0
	jnz [__bbcc_00000011]
// AddrOf
	lea DWORD [__bbcc_00000038], %r0
// Set
// CallFunction
	push %r0
	call [printf]
	add #4, %r14
// Set
	mov DWORD 8[%r12], %r0
// CallFunction
	push %r0
	call [currentChunk]
	add #4, %r14
// Set
	mov %r0, %r1
// AddrOf
	lea DWORD [__bbcc_0000003a], %r0
// Set
// CallFunction
	push %r0
	push %r1
	call [disassembleChunk]
	add #8, %r14
// Label
__bbcc_00000011:
// Return
	mov #0, %r0
__bbcc_0000004b:
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: number
number:
	push %r12
	mov %r14, %r12
	sub #5, %r14
	push %r1
// Add
	mov DWORD 8[%r12], %r0
	add #16, %r0
// ReadAt
	mov DWORD 4[%r0], %r0
// Set
// CallFunction
	push %r0
	call [atoi]
	add #4, %r14
// Set
	mov %r0, %r1
// AddrOf
	lea DWORD -5[%r12], %r0
// Set
// CallFunction
	push %r0
	push %r1
	call [intVal]
	add #8, %r14
// Set
	mov DWORD 8[%r12], %r1
// AddrOf
	lea DWORD -5[%r12], %r0
// Set
// CallFunction
	push %r0
	push %r1
	call [emitConstant]
	add #8, %r14
// Return
	mov #0, %r0
__bbcc_0000004c:
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: string
string:
	push %r12
	mov %r14, %r12
	sub #5, %r14
	push %r1
	push %r2
// Add
	mov DWORD 8[%r12], %r0
	add #16, %r0
// ReadAt
	mov DWORD 4[%r0], %r0
// Set
	mov #1, %r1
// Add
	add %r1, %r0
// Set
	mov %r0, %r2
// Add
	mov DWORD 8[%r12], %r0
	add #16, %r0
// ReadAt
	mov DWORD 8[%r0], %r0
// Sub
	sub #2, %r0
// ReadAt
	mov DWORD 8[%r12], %r1
	mov DWORD 42[%r1], %r1
// Set
// CallFunction
	push %r1
	push %r0
	push %r2
	call [copyString]
	add #12, %r14
// Set
	mov %r0, %r1
// AddrOf
	lea DWORD -5[%r12], %r0
// Set
// CallFunction
	push %r0
	push %r1
	call [objVal]
	add #8, %r14
// Set
	mov DWORD 8[%r12], %r1
// AddrOf
	lea DWORD -5[%r12], %r0
// Set
// CallFunction
	push %r0
	push %r1
	call [emitConstant]
	add #8, %r14
// Return
	mov #0, %r0
__bbcc_0000004d:
	pop %r2
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: newline
newline:
	push %r12
	mov %r14, %r12
// Return
	mov #0, %r0
__bbcc_0000004e:
	mov %r12, %r14
	pop %r12
	ret
// Function: grouping
grouping:
	push %r12
	mov %r14, %r12
	push %r1
	push %r2
// Set
	mov DWORD 8[%r12], %r0
// CallFunction
	push %r0
	call [expression]
	add #4, %r14
// Set
	mov DWORD 8[%r12], %r2
// Set
	mov #11, %r1
// AddrOf
	lea DWORD [__bbcc_0000003b], %r0
// Set
// CallFunction
	push %r0
	push %r1
	push %r2
	call [consume]
	add #12, %r14
// Return
	mov #0, %r0
__bbcc_0000004f:
	pop %r2
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: binary
binary:
	push %r12
	mov %r14, %r12
	push %r1
	push %r2
	push %r3
// Add
	mov DWORD 8[%r12], %r0
	add #16, %r0
// ReadAt
	mov DWORD [%r0], %r0
// Set
	mov %r0, %r3
// CallFunction
	push %r3
	call [getRule]
	add #4, %r14
// Set
// Set
// Set
	mov DWORD 8[%r12], %r1
// ReadAt
	mov BYTE 8[%r0], %r0
// Set
// Add
	add #1, %r0
// Set
// CallFunction
	push %r0
	push %r1
	call [parsePrecedence]
	add #8, %r14
// NotEqualJmp
	cmp #3, %r3
	jnz [__bbcc_00000012]
// Set
	mov DWORD 8[%r12], %r1
// Set
	mov #3, %r0
// CallFunction
	push %r0
	push %r1
	call [emitByte]
	add #8, %r14
// Jmp
	jmp [__bbcc_00000013]
// Label
__bbcc_00000012:
// NotEqualJmp
	cmp #4, %r3
	jnz [__bbcc_00000014]
// Set
	mov DWORD 8[%r12], %r1
// Set
	mov #4, %r0
// CallFunction
	push %r0
	push %r1
	call [emitByte]
	add #8, %r14
// Jmp
	jmp [__bbcc_00000015]
// Label
__bbcc_00000014:
// NotEqualJmp
	cmp #6, %r3
	jnz [__bbcc_00000016]
// Set
	mov DWORD 8[%r12], %r1
// Set
	mov #5, %r0
// CallFunction
	push %r0
	push %r1
	call [emitByte]
	add #8, %r14
// Jmp
	jmp [__bbcc_00000017]
// Label
__bbcc_00000016:
// NotEqualJmp
	cmp #5, %r3
	jnz [__bbcc_00000018]
// Set
	mov DWORD 8[%r12], %r1
// Set
	mov #6, %r0
// CallFunction
	push %r0
	push %r1
	call [emitByte]
	add #8, %r14
// Jmp
	jmp [__bbcc_00000019]
// Label
__bbcc_00000018:
// NotEqualJmp
	cmp #50, %r3
	jnz [__bbcc_0000001a]
// Set
	mov DWORD 8[%r12], %r1
// Set
	mov #10, %r0
// CallFunction
	push %r0
	push %r1
	call [emitByte]
	add #8, %r14
// Jmp
	jmp [__bbcc_0000001b]
// Label
__bbcc_0000001a:
// NotEqualJmp
	cmp #51, %r3
	jnz [__bbcc_0000001c]
// Set
	mov DWORD 8[%r12], %r2
// Set
	mov #10, %r1
// Set
	mov #9, %r0
// CallFunction
	push %r0
	push %r1
	push %r2
	call [emitBytes]
	add #12, %r14
// Jmp
	jmp [__bbcc_0000001d]
// Label
__bbcc_0000001c:
// NotEqualJmp
	cmp #52, %r3
	jnz [__bbcc_0000001e]
// Set
	mov DWORD 8[%r12], %r1
// Set
	mov #11, %r0
// CallFunction
	push %r0
	push %r1
	call [emitByte]
	add #8, %r14
// Jmp
	jmp [__bbcc_0000001f]
// Label
__bbcc_0000001e:
// NotEqualJmp
	cmp #53, %r3
	jnz [__bbcc_00000020]
// Set
	mov DWORD 8[%r12], %r2
// Set
	mov #12, %r1
// Set
	mov #9, %r0
// CallFunction
	push %r0
	push %r1
	push %r2
	call [emitBytes]
	add #12, %r14
// Jmp
	jmp [__bbcc_00000021]
// Label
__bbcc_00000020:
// NotEqualJmp
	cmp #54, %r3
	jnz [__bbcc_00000022]
// Set
	mov DWORD 8[%r12], %r1
// Set
	mov #12, %r0
// CallFunction
	push %r0
	push %r1
	call [emitByte]
	add #8, %r14
// Jmp
	jmp [__bbcc_00000023]
// Label
__bbcc_00000022:
// NotEqualJmp
	cmp #55, %r3
	jnz [__bbcc_00000024]
// Set
	mov DWORD 8[%r12], %r2
// Set
	mov #11, %r1
// Set
	mov #9, %r0
// CallFunction
	push %r0
	push %r1
	push %r2
	call [emitBytes]
	add #12, %r14
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
__bbcc_00000050:
	pop %r3
	pop %r2
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: unary
unary:
	push %r12
	mov %r14, %r12
	push %r1
	push %r2
// Add
	mov DWORD 8[%r12], %r0
	add #16, %r0
// ReadAt
	mov DWORD [%r0], %r0
// Set
	mov %r0, %r2
// Set
	mov DWORD 8[%r12], %r1
// Set
	mov #15, %r0
// CallFunction
	push %r0
	push %r1
	call [parsePrecedence]
	add #8, %r14
// NotEqualJmp
	cmp #4, %r2
	jnz [__bbcc_00000025]
// Set
	mov DWORD 8[%r12], %r1
// Set
	mov #2, %r0
// CallFunction
	push %r0
	push %r1
	call [emitByte]
	add #8, %r14
// Jmp
	jmp [__bbcc_00000026]
// Label
__bbcc_00000025:
// NotEqualJmp
	cmp #42, %r2
	jnz [__bbcc_00000027]
// Set
	mov DWORD 8[%r12], %r1
// Set
	mov #9, %r0
// CallFunction
	push %r0
	push %r1
	call [emitByte]
	add #8, %r14
// Label
__bbcc_00000027:
// Label
__bbcc_00000026:
// Return
	mov #0, %r0
__bbcc_00000051:
	pop %r2
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: literal
literal:
	push %r12
	mov %r14, %r12
	sub #5, %r14
	push %r1
	push %r2
// Add
	mov DWORD 8[%r12], %r0
	add #16, %r0
// ReadAt
	mov DWORD [%r0], %r0
// Set
	mov %r0, %r2
// NotEqualJmp
	cmp #19, %r2
	jnz [__bbcc_00000028]
// AddrOf
	lea DWORD -5[%r12], %r0
// Set
// CallFunction
	push %r0
	call [noneVal]
	add #4, %r14
// Set
	mov DWORD 8[%r12], %r1
// AddrOf
	lea DWORD -5[%r12], %r0
// Set
// CallFunction
	push %r0
	push %r1
	call [emitConstant]
	add #8, %r14
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
	lea DWORD -5[%r12], %r0
// Set
// CallFunction
	push %r0
	push %r1
	call [boolVal]
	add #8, %r14
// Set
	mov DWORD 8[%r12], %r1
// AddrOf
	lea DWORD -5[%r12], %r0
// Set
// CallFunction
	push %r0
	push %r1
	call [emitConstant]
	add #8, %r14
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
	lea DWORD -5[%r12], %r0
// Set
// CallFunction
	push %r0
	push %r1
	call [boolVal]
	add #8, %r14
// Set
	mov DWORD 8[%r12], %r1
// AddrOf
	lea DWORD -5[%r12], %r0
// Set
// CallFunction
	push %r0
	push %r1
	call [emitConstant]
	add #8, %r14
// Label
__bbcc_0000002c:
// Label
__bbcc_0000002b:
// Label
__bbcc_00000029:
// Return
	mov #0, %r0
__bbcc_00000052:
	pop %r2
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: getRule
getRule:
	push %r12
	mov %r14, %r12
	push %r1
// AddrOf
	lea DWORD [rules], %r0
// Mult
	mov #9, %r1
	mul DWORD 8[%r12], %r1
// Add
	add %r1, %r0
// Return
__bbcc_00000053:
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: initRule
initRule:
	push %r12
	mov %r14, %r12
	push %r1
// SetAt
	mov 8[%r12], %r0
	mov 12[%r12], %r1
	mov %r1, DWORD [%r0]
// SetAt
	mov 8[%r12], %r0
	mov 16[%r12], %r1
	mov %r1, DWORD 4[%r0]
// SetAt
	mov 8[%r12], %r0
	mov 20[%r12], %r1
	mov %r1, BYTE 8[%r0]
// Return
	mov #0, %r0
__bbcc_00000054:
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: expression
expression:
	push %r12
	mov %r14, %r12
	push %r1
// Set
	mov DWORD 8[%r12], %r1
// Set
	mov #1, %r0
// CallFunction
	push %r0
	push %r1
	call [parsePrecedence]
	add #8, %r14
// Return
	mov #0, %r0
__bbcc_00000055:
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: parsePrecedence
parsePrecedence:
	push %r12
	mov %r14, %r12
	push %r1
	push %r2
// Set
	mov DWORD 8[%r12], %r0
// CallFunction
	push %r0
	call [advance]
	add #4, %r14
// Add
	mov DWORD 8[%r12], %r0
	add #16, %r0
// ReadAt
	mov DWORD [%r0], %r0
// CallFunction
	push %r0
	call [getRule]
	add #4, %r14
// ReadAt
	mov DWORD [%r0], %r0
// Set
	mov %r0, %r2
// NotEqualJmp
	cmp #0, %r2
	jnz [__bbcc_0000002d]
// Set
	mov DWORD 8[%r12], %r1
// AddrOf
	lea DWORD [__bbcc_0000003c], %r0
// Set
// CallFunction
	push %r0
	push %r1
	call [error]
	add #8, %r14
// Return
	mov #0, %r0
	jmp [__bbcc_00000056]
// Label
__bbcc_0000002d:
// Set
	mov DWORD 8[%r12], %r0
// CallFunction
	push %r0
	call [%r2]
	add #4, %r14
// Label
__bbcc_0000002e:
// Add
	mov DWORD 8[%r12], %r0
// ReadAt
	mov DWORD [%r0], %r0
// CallFunction
	push %r0
	call [getRule]
	add #4, %r14
// ReadAt
	mov BYTE 8[%r0], %r0
// MoreThanJmp
	cmp 12[%r12], %r0
	ja [__bbcc_0000002f]
// Set
	mov DWORD 8[%r12], %r0
// CallFunction
	push %r0
	call [advance]
	add #4, %r14
// Add
	mov DWORD 8[%r12], %r0
	add #16, %r0
// ReadAt
	mov DWORD [%r0], %r0
// CallFunction
	push %r0
	call [getRule]
	add #4, %r14
// ReadAt
	mov DWORD 4[%r0], %r0
// Set
	mov %r0, %r1
// Set
	mov DWORD 8[%r12], %r0
// CallFunction
	push %r0
	call [%r1]
	add #4, %r14
// Jmp
	jmp [__bbcc_0000002e]
// Label
__bbcc_0000002f:
// Return
	mov #0, %r0
__bbcc_00000056:
	pop %r2
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: compile
compile:
	push %r12
	mov %r14, %r12
	sub #143, %r14
	push %r1
	push %r2
	push %r3
// AddrOf
	lea DWORD [rules], %r0
// Add
// Set
	mov %r0, %r3
// AddrOf
	lea DWORD [number], %r0
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
	add #16, %r14
// AddrOf
	lea DWORD [rules], %r0
// Add
	add #9, %r0
// Set
	mov %r0, %r3
// AddrOf
	lea DWORD [string], %r0
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
	add #16, %r14
// AddrOf
	lea DWORD [rules], %r0
// Add
	add #171, %r0
// Set
	mov %r0, %r3
// AddrOf
	lea DWORD [literal], %r0
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
	add #16, %r14
// AddrOf
	lea DWORD [rules], %r0
// Add
	add #216, %r0
// Set
	mov %r0, %r3
// AddrOf
	lea DWORD [literal], %r0
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
	add #16, %r14
// AddrOf
	lea DWORD [rules], %r0
// Add
	add #126, %r0
// Set
	mov %r0, %r3
// AddrOf
	lea DWORD [literal], %r0
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
	add #16, %r14
// AddrOf
	lea DWORD [rules], %r0
// Add
	add #27, %r0
// Set
	mov %r0, %r3
// AddrOf
	lea DWORD [unary], %r0
// Set
	mov %r0, %r2
// AddrOf
	lea DWORD [binary], %r0
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
	add #16, %r14
// AddrOf
	lea DWORD [rules], %r0
// Add
	add #36, %r0
// Set
	mov %r0, %r3
// AddrOf
	lea DWORD [unary], %r0
// Set
	mov %r0, %r2
// AddrOf
	lea DWORD [binary], %r0
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
	add #16, %r14
// AddrOf
	lea DWORD [rules], %r0
// Add
	add #54, %r0
// Set
	mov %r0, %r3
// Set
	mov #0, %r2
// AddrOf
	lea DWORD [binary], %r0
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
	add #16, %r14
// AddrOf
	lea DWORD [rules], %r0
// Add
	add #45, %r0
// Set
	mov %r0, %r3
// Set
	mov #0, %r2
// AddrOf
	lea DWORD [binary], %r0
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
	add #16, %r14
// AddrOf
	lea DWORD [rules], %r0
// Add
	add #378, %r0
// Set
	mov %r0, %r3
// AddrOf
	lea DWORD [unary], %r0
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
	add #16, %r14
// AddrOf
	lea DWORD [rules], %r0
// Add
	add #450, %r0
// Set
	mov %r0, %r3
// Set
	mov #0, %r2
// AddrOf
	lea DWORD [binary], %r0
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
	add #16, %r14
// AddrOf
	lea DWORD [rules], %r0
// Add
	add #459, %r0
// Set
	mov %r0, %r3
// Set
	mov #0, %r2
// AddrOf
	lea DWORD [binary], %r0
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
	add #16, %r14
// AddrOf
	lea DWORD [rules], %r0
// Add
	add #468, %r0
// Set
	mov %r0, %r3
// Set
	mov #0, %r2
// AddrOf
	lea DWORD [binary], %r0
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
	add #16, %r14
// AddrOf
	lea DWORD [rules], %r0
// Add
	add #477, %r0
// Set
	mov %r0, %r3
// Set
	mov #0, %r2
// AddrOf
	lea DWORD [binary], %r0
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
	add #16, %r14
// AddrOf
	lea DWORD [rules], %r0
// Add
	add #486, %r0
// Set
	mov %r0, %r3
// Set
	mov #0, %r2
// AddrOf
	lea DWORD [binary], %r0
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
	add #16, %r14
// AddrOf
	lea DWORD [rules], %r0
// Add
	add #495, %r0
// Set
	mov %r0, %r3
// Set
	mov #0, %r2
// AddrOf
	lea DWORD [binary], %r0
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
	add #16, %r14
// AddrOf
	lea DWORD [rules], %r0
// Add
	add #90, %r0
// Set
	mov %r0, %r3
// AddrOf
	lea DWORD [grouping], %r0
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
	add #16, %r14
// AddrOf
	lea DWORD [rules], %r0
// Add
	add #522, %r0
// Set
	mov %r0, %r3
// Set
	mov #0, %r2
// AddrOf
	lea DWORD [newline], %r0
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
	add #16, %r14
// AddrOf
	lea DWORD -97[%r12], %r0
// Set
	mov %r0, %r1
// Set
	mov DWORD 8[%r12], %r0
// CallFunction
	push %r0
	push %r1
	call [initScanner]
	add #8, %r14
// AddrOf
	lea DWORD -143[%r12], %r1
// Set
	mov DWORD 12[%r12], %r0
// SetAt
	mov %r0, DWORD 34[%r1]
// AddrOf
	lea DWORD -97[%r12], %r0
// AddrOf
	lea DWORD -143[%r12], %r1
// Set
// SetAt
	mov %r0, DWORD 38[%r1]
// AddrOf
	lea DWORD -143[%r12], %r1
// Set
	mov DWORD 16[%r12], %r0
// SetAt
	mov %r0, DWORD 42[%r1]
// AddrOf
	lea DWORD -143[%r12], %r1
// Set
	mov #0, %r0
// SetAt
	mov %r0, BYTE 32[%r1]
// AddrOf
	lea DWORD -143[%r12], %r1
// Set
	mov #0, %r0
// SetAt
	mov %r0, BYTE 33[%r1]
// AddrOf
	lea DWORD [__bbcc_0000003d], %r0
// Set
// CallFunction
	push %r0
	call [printf]
	add #4, %r14
// AddrOf
	lea DWORD -143[%r12], %r0
// Set
// CallFunction
	push %r0
	call [advance]
	add #4, %r14
// AddrOf
	lea DWORD -143[%r12], %r0
// Set
// CallFunction
	push %r0
	call [expression]
	add #4, %r14
// AddrOf
	lea DWORD -143[%r12], %r0
// Set
	mov %r0, %r2
// Set
	mov #56, %r1
// AddrOf
	lea DWORD [__bbcc_0000003e], %r0
// Set
// CallFunction
	push %r0
	push %r1
	push %r2
	call [consume]
	add #12, %r14
// AddrOf
	lea DWORD -143[%r12], %r0
// Set
// CallFunction
	push %r0
	call [endCompiler]
	add #4, %r14
// AddrOf
	lea DWORD [__bbcc_0000003f], %r0
// Set
// CallFunction
	push %r0
	call [printf]
	add #4, %r14
// Set
	mov #1, %r1
// AddrOf
	lea DWORD -143[%r12], %r0
// ReadAt
	mov BYTE 32[%r0], %r0
// JmpZero
	cmp #0, %r0
	jze [__bbcc_00000030]
// Set
	mov #0, %r1
// Label
__bbcc_00000030:
// Return
	mov %r1, %r0
__bbcc_00000057:
	pop %r3
	pop %r2
	pop %r1
	mov %r12, %r14
	pop %r12
	ret