.import printf
.import writeArray
.import printValue
.export writeLineInfoArray
.export getLastLine
.export getLine
.export writeLine
.export disassembleChunk
.export disassembleInstruction
__bbcc_00000026:
.byte #61,#61,#32,#37,#115,#32,#61,#61,#10,#0
__bbcc_00000027:
.byte #37,#48,#52,#117,#32,#0
__bbcc_00000028:
.byte #32,#32,#32,#124,#32,#0
__bbcc_00000029:
.byte #79,#80,#95,#67,#79,#78,#83,#84,#65,#78,#84,#0
__bbcc_0000002a:
.byte #79,#80,#95,#67,#79,#78,#83,#84,#65,#78,#84,#95,#76,#79,#78,#71,#0
__bbcc_0000002b:
.byte #79,#80,#95,#78,#69,#71,#65,#84,#69,#0
__bbcc_0000002c:
.byte #79,#80,#95,#65,#68,#68,#0
__bbcc_0000002d:
.byte #79,#80,#95,#83,#85,#66,#84,#82,#65,#67,#84,#0
__bbcc_0000002e:
.byte #79,#80,#95,#77,#85,#76,#84,#73,#80,#76,#89,#0
__bbcc_0000002f:
.byte #79,#80,#95,#68,#73,#86,#73,#68,#69,#0
__bbcc_00000030:
.byte #79,#80,#95,#77,#79,#68,#85,#76,#85,#83,#0
__bbcc_00000031:
.byte #79,#80,#95,#82,#69,#84,#85,#82,#78,#0
__bbcc_00000032:
.byte #79,#80,#95,#78,#79,#84,#0
__bbcc_00000033:
.byte #79,#80,#95,#69,#81,#85,#65,#76,#0
__bbcc_00000034:
.byte #79,#80,#95,#71,#82,#69,#65,#84,#69,#82,#0
__bbcc_00000035:
.byte #79,#80,#95,#76,#69,#83,#83,#0
__bbcc_00000036:
.byte #85,#110,#107,#110,#111,#119,#110,#32,#111,#112,#99,#111,#100,#101,#32,#37,#100,#10,#0
__bbcc_00000037:
.byte #37,#115,#10,#0
__bbcc_00000038:
.byte #37,#115,#32,#37,#48,#52,#117,#32,#39,#0
__bbcc_00000039:
.byte #39,#10,#0
// Function: writeLineInfoArray
writeLineInfoArray:
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
	mov #8, %r2
	push %r2
	push %r1
	call [writeArray]
	add #12, %r14
// Return
	mov #0, %r0
__bbcc_0000003a:
	pop %r2
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: getLastLine
getLastLine:
	push %r12
	mov %r14, %r12
	push %r1
	push %r2
// Add
	mov DWORD 8[%r12], %r0
// ReadAt
	mov DWORD [%r0], %r0
// NotEqualJmp
	cmp #0, %r0
	jnz [__bbcc_00000000]
// Return
	mov #0, %r0
	jmp [__bbcc_0000003b]
// Label
__bbcc_00000000:
// ReadAt
	mov DWORD 8[%r12], %r0
	mov DWORD 8[%r0], %r1
// Add
	mov DWORD 8[%r12], %r0
// ReadAt
	mov DWORD [%r0], %r0
// Set
	mov #1, %r2
// Sub
	sub %r2, %r0
// Mult
	mov #8, %r2
	mul %r0, %r2
// Add
	add %r2, %r1
// ReadAt
	mov DWORD 4[%r1], %r0
// Return
__bbcc_0000003b:
	pop %r2
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: getLine
getLine:
	push %r12
	mov %r14, %r12
	sub #16, %r14
	push %r1
	push %r2
	push %r3
	push %r4
// Set
	mov #0, %r0
// Set
// Set
	mov #0, %r2
// Set
// Label
__bbcc_00000001:
// Add
	mov DWORD 8[%r12], %r1
// ReadAt
	mov DWORD [%r1], %r1
// MoreEqualJmp
	cmp %r2, %r1
	jae [__bbcc_00000003]
// ReadAt
	mov DWORD 8[%r12], %r1
	mov DWORD 8[%r1], %r3
// Mult
	mov #8, %r1
	mul %r2, %r1
// ReadAt
	add %r1, %r3
	mov DWORD [%r3], %r4
	mov %r4, DWORD -16[%r12]
	mov DWORD 4[%r3], %r4
	mov %r4, DWORD -12[%r12]
// Set
	mov DWORD -16[%r12], %r1
	mov %r1, DWORD -8[%r12]
	mov DWORD -12[%r12], %r1
	mov %r1, DWORD -4[%r12]
// AddrOf
	lea DWORD -8[%r12], %r1
// ReadAt
	mov DWORD [%r1], %r1
// MoreThanJmp
	mov 12[%r12], %r3
	cmp %r1, %r3
	ja [__bbcc_00000004]
// AddrOf
	lea DWORD -8[%r12], %r0
// ReadAt
	mov DWORD 4[%r0], %r0
// Set
// Jmp
	jmp [__bbcc_00000005]
// Label
__bbcc_00000004:
// Jmp
	jmp [__bbcc_00000003]
// Label
__bbcc_00000005:
// Label
__bbcc_00000002:
// Set
	mov %r2, %r1
// Inc
	inc %r2
// Jmp
	jmp [__bbcc_00000001]
// Label
__bbcc_00000003:
// Return
__bbcc_0000003c:
	pop %r4
	pop %r3
	pop %r2
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: writeLine
writeLine:
	push %r12
	mov %r14, %r12
	sub #8, %r14
	push %r1
// AddrOf
	lea DWORD -8[%r12], %r0
// SetAt
	mov 12[%r12], %r1
	mov %r1, DWORD [%r0]
// AddrOf
	lea DWORD -8[%r12], %r0
// SetAt
	mov 16[%r12], %r1
	mov %r1, DWORD 4[%r0]
// Set
	mov DWORD 8[%r12], %r1
// AddrOf
	lea DWORD -8[%r12], %r0
// Set
// CallFunction
	push %r0
	push %r1
	call [writeLineInfoArray]
	add #8, %r14
// Return
	mov #0, %r0
__bbcc_0000003d:
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: disassembleChunk
disassembleChunk:
	push %r12
	mov %r14, %r12
	push %r1
// AddrOf
	lea DWORD [__bbcc_00000026], %r0
// Set
// CallFunction
	mov DWORD 12[%r12], %r1
	push %r1
	push %r0
	call [printf]
	add #8, %r14
// Set
	mov #0, %r0
// Set
// Label
__bbcc_00000006:
// Add
	mov DWORD 8[%r12], %r1
// ReadAt
	mov DWORD [%r1], %r1
// MoreEqualJmp
	cmp %r0, %r1
	jae [__bbcc_00000008]
// Set
	mov DWORD 8[%r12], %r1
// CallFunction
	push %r0
	push %r1
	call [disassembleInstruction]
	add #8, %r14
// Set
// Label
__bbcc_00000007:
// Jmp
	jmp [__bbcc_00000006]
// Label
__bbcc_00000008:
// Return
	mov #0, %r0
__bbcc_0000003e:
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: disassembleInstruction
disassembleInstruction:
	push %r12
	mov %r14, %r12
	push %r1
	push %r2
	push %r3
	push %r4
// AddrOf
	lea DWORD [__bbcc_00000027], %r0
// Set
// CallFunction
	mov DWORD 12[%r12], %r1
	push %r1
	push %r0
	call [printf]
	add #8, %r14
// Add
	mov DWORD 8[%r12], %r0
	add #24, %r0
// Set
// CallFunction
	mov DWORD 12[%r12], %r1
	push %r1
	push %r0
	call [getLine]
	add #8, %r14
// Set
	mov %r0, %r1
// Set
	mov #0, %r4
// LessEqualJmp
	mov #0, %r0
	cmp 12[%r12], %r0
	jle [__bbcc_0000000a]
// Add
	mov DWORD 8[%r12], %r0
	add #24, %r0
// Set
// Set
	mov #1, %r3
// Sub
	mov DWORD 12[%r12], %r2
	sub %r3, %r2
// CallFunction
	push %r2
	push %r0
	call [getLine]
	add #8, %r14
// NotEqualJmp
	cmp %r0, %r1
	jnz [__bbcc_0000000a]
// Set
	mov #1, %r4
// Label
__bbcc_0000000a:
// JmpZero
	cmp #0, %r4
	jze [__bbcc_00000009]
// AddrOf
	lea DWORD [__bbcc_00000028], %r0
// Set
// CallFunction
	push %r0
	call [printf]
	add #4, %r14
// Jmp
	jmp [__bbcc_0000000b]
// Label
__bbcc_00000009:
// AddrOf
	lea DWORD [__bbcc_00000027], %r0
// Set
// CallFunction
	push %r1
	push %r0
	call [printf]
	add #8, %r14
// Label
__bbcc_0000000b:
// ReadAt
	mov DWORD 8[%r12], %r0
	mov DWORD 8[%r0], %r0
// ReadAt
	add DWORD 12[%r12], %r0
	mov BYTE [%r0], %r1
// Set
// NotEqualJmp
	cmp #0, %r1
	jnz [__bbcc_0000000c]
// AddrOf
	lea DWORD [__bbcc_00000029], %r0
// Set
// Set
	mov DWORD 8[%r12], %r2
// CallFunction
	mov DWORD 12[%r12], %r3
	push %r3
	push %r2
	push %r0
	call [constantInstruction]
	add #12, %r14
// Return
	jmp [__bbcc_0000003f]
// Jmp
	jmp [__bbcc_0000000d]
// Label
__bbcc_0000000c:
// NotEqualJmp
	cmp #1, %r1
	jnz [__bbcc_0000000e]
// AddrOf
	lea DWORD [__bbcc_0000002a], %r0
// Set
// Set
	mov DWORD 8[%r12], %r2
// CallFunction
	mov DWORD 12[%r12], %r3
	push %r3
	push %r2
	push %r0
	call [longConstantInstruction]
	add #12, %r14
// Return
	jmp [__bbcc_0000003f]
// Jmp
	jmp [__bbcc_0000000f]
// Label
__bbcc_0000000e:
// NotEqualJmp
	cmp #2, %r1
	jnz [__bbcc_00000010]
// AddrOf
	lea DWORD [__bbcc_0000002b], %r0
// Set
// CallFunction
	mov DWORD 12[%r12], %r2
	push %r2
	push %r0
	call [simpleInstruction]
	add #8, %r14
// Return
	jmp [__bbcc_0000003f]
// Jmp
	jmp [__bbcc_00000011]
// Label
__bbcc_00000010:
// NotEqualJmp
	cmp #3, %r1
	jnz [__bbcc_00000012]
// AddrOf
	lea DWORD [__bbcc_0000002c], %r0
// Set
// CallFunction
	mov DWORD 12[%r12], %r2
	push %r2
	push %r0
	call [simpleInstruction]
	add #8, %r14
// Return
	jmp [__bbcc_0000003f]
// Jmp
	jmp [__bbcc_00000013]
// Label
__bbcc_00000012:
// NotEqualJmp
	cmp #4, %r1
	jnz [__bbcc_00000014]
// AddrOf
	lea DWORD [__bbcc_0000002d], %r0
// Set
// CallFunction
	mov DWORD 12[%r12], %r2
	push %r2
	push %r0
	call [simpleInstruction]
	add #8, %r14
// Return
	jmp [__bbcc_0000003f]
// Jmp
	jmp [__bbcc_00000015]
// Label
__bbcc_00000014:
// NotEqualJmp
	cmp #5, %r1
	jnz [__bbcc_00000016]
// AddrOf
	lea DWORD [__bbcc_0000002e], %r0
// Set
// CallFunction
	mov DWORD 12[%r12], %r2
	push %r2
	push %r0
	call [simpleInstruction]
	add #8, %r14
// Return
	jmp [__bbcc_0000003f]
// Jmp
	jmp [__bbcc_00000017]
// Label
__bbcc_00000016:
// NotEqualJmp
	cmp #6, %r1
	jnz [__bbcc_00000018]
// AddrOf
	lea DWORD [__bbcc_0000002f], %r0
// Set
// CallFunction
	mov DWORD 12[%r12], %r2
	push %r2
	push %r0
	call [simpleInstruction]
	add #8, %r14
// Return
	jmp [__bbcc_0000003f]
// Jmp
	jmp [__bbcc_00000019]
// Label
__bbcc_00000018:
// NotEqualJmp
	cmp #7, %r1
	jnz [__bbcc_0000001a]
// AddrOf
	lea DWORD [__bbcc_00000030], %r0
// Set
// CallFunction
	mov DWORD 12[%r12], %r2
	push %r2
	push %r0
	call [simpleInstruction]
	add #8, %r14
// Return
	jmp [__bbcc_0000003f]
// Jmp
	jmp [__bbcc_0000001b]
// Label
__bbcc_0000001a:
// NotEqualJmp
	cmp #8, %r1
	jnz [__bbcc_0000001c]
// AddrOf
	lea DWORD [__bbcc_00000031], %r0
// Set
// CallFunction
	mov DWORD 12[%r12], %r2
	push %r2
	push %r0
	call [simpleInstruction]
	add #8, %r14
// Return
	jmp [__bbcc_0000003f]
// Jmp
	jmp [__bbcc_0000001d]
// Label
__bbcc_0000001c:
// NotEqualJmp
	cmp #9, %r1
	jnz [__bbcc_0000001e]
// AddrOf
	lea DWORD [__bbcc_00000032], %r0
// Set
// CallFunction
	mov DWORD 12[%r12], %r2
	push %r2
	push %r0
	call [simpleInstruction]
	add #8, %r14
// Return
	jmp [__bbcc_0000003f]
// Jmp
	jmp [__bbcc_0000001f]
// Label
__bbcc_0000001e:
// NotEqualJmp
	cmp #10, %r1
	jnz [__bbcc_00000020]
// AddrOf
	lea DWORD [__bbcc_00000033], %r0
// Set
// CallFunction
	mov DWORD 12[%r12], %r2
	push %r2
	push %r0
	call [simpleInstruction]
	add #8, %r14
// Return
	jmp [__bbcc_0000003f]
// Jmp
	jmp [__bbcc_00000021]
// Label
__bbcc_00000020:
// NotEqualJmp
	cmp #11, %r1
	jnz [__bbcc_00000022]
// AddrOf
	lea DWORD [__bbcc_00000034], %r0
// Set
// CallFunction
	mov DWORD 12[%r12], %r2
	push %r2
	push %r0
	call [simpleInstruction]
	add #8, %r14
// Return
	jmp [__bbcc_0000003f]
// Jmp
	jmp [__bbcc_00000023]
// Label
__bbcc_00000022:
// NotEqualJmp
	cmp #12, %r1
	jnz [__bbcc_00000024]
// AddrOf
	lea DWORD [__bbcc_00000035], %r0
// Set
// CallFunction
	mov DWORD 12[%r12], %r2
	push %r2
	push %r0
	call [simpleInstruction]
	add #8, %r14
// Return
	jmp [__bbcc_0000003f]
// Jmp
	jmp [__bbcc_00000025]
// Label
__bbcc_00000024:
// AddrOf
	lea DWORD [__bbcc_00000036], %r0
// Set
// CallFunction
	push %r1
	push %r0
	call [printf]
	add #8, %r14
// Set
	mov #1, %r1
// Add
	mov DWORD 12[%r12], %r0
	add %r1, %r0
// Return
	jmp [__bbcc_0000003f]
// Label
__bbcc_00000025:
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
// Label
__bbcc_00000011:
// Label
__bbcc_0000000f:
// Label
__bbcc_0000000d:
// Return
	mov #0, %r0
__bbcc_0000003f:
	pop %r4
	pop %r3
	pop %r2
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: simpleInstruction
simpleInstruction:
	push %r12
	mov %r14, %r12
	push %r1
// AddrOf
	lea DWORD [__bbcc_00000037], %r0
// Set
// CallFunction
	mov DWORD 8[%r12], %r1
	push %r1
	push %r0
	call [printf]
	add #8, %r14
// Set
	mov #1, %r1
// Add
	mov DWORD 12[%r12], %r0
	add %r1, %r0
// Return
__bbcc_00000040:
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: constantInstruction
constantInstruction:
	push %r12
	mov %r14, %r12
	push %r1
	push %r2
// ReadAt
	mov DWORD 12[%r12], %r0
	mov DWORD 8[%r0], %r2
// Set
	mov #1, %r1
// Add
	mov DWORD 16[%r12], %r0
	add %r1, %r0
// ReadAt
	mov %r2, %r1
	add %r0, %r1
	mov BYTE [%r1], %r1
// Set
// AddrOf
	lea DWORD [__bbcc_00000038], %r0
// Set
// CallFunction
	push %r1
	mov DWORD 8[%r12], %r2
	push %r2
	push %r0
	call [printf]
	add #12, %r14
// Add
	mov DWORD 12[%r12], %r0
	add #12, %r0
// ReadAt
	mov DWORD 8[%r0], %r0
// Mult
	mov #5, %r2
	mul %r1, %r2
// Add
	add %r2, %r0
// Set
// CallFunction
	push %r0
	call [printValue]
	add #4, %r14
// AddrOf
	lea DWORD [__bbcc_00000039], %r0
// Set
// CallFunction
	push %r0
	call [printf]
	add #4, %r14
// Set
	mov #2, %r1
// Add
	mov DWORD 16[%r12], %r0
	add %r1, %r0
// Return
__bbcc_00000041:
	pop %r2
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: longConstantInstruction
longConstantInstruction:
	push %r12
	mov %r14, %r12
	push %r1
	push %r2
// ReadAt
	mov DWORD 12[%r12], %r0
	mov DWORD 8[%r0], %r0
// Set
	mov #1, %r2
// Add
	mov DWORD 16[%r12], %r1
	add %r2, %r1
// Add
	add %r1, %r0
// Set
// ReadAt
	mov DWORD [%r0], %r1
// Set
// AddrOf
	lea DWORD [__bbcc_00000038], %r0
// Set
// CallFunction
	push %r1
	mov DWORD 8[%r12], %r2
	push %r2
	push %r0
	call [printf]
	add #12, %r14
// Add
	mov DWORD 12[%r12], %r0
	add #12, %r0
// ReadAt
	mov DWORD 8[%r0], %r0
// Mult
	mov #5, %r2
	mul %r1, %r2
// Add
	add %r2, %r0
// Set
// CallFunction
	push %r0
	call [printValue]
	add #4, %r14
// AddrOf
	lea DWORD [__bbcc_00000039], %r0
// Set
// CallFunction
	push %r0
	call [printf]
	add #4, %r14
// Set
	mov #3, %r1
// Add
	mov DWORD 16[%r12], %r0
	add %r1, %r0
// Return
__bbcc_00000042:
	pop %r2
	pop %r1
	mov %r12, %r14
	pop %r12
	ret