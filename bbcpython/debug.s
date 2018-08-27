.import printf
.import printValue
.import growCapacity
.import reallocate
.export initLineInfoArray
.export writeLineInfoArray
.export freeLineInfoArray
.export getLastLine
.export getLine
.export writeLine
.export disassembleChunk
.export disassembleInstruction
__bbcc_00000027:
.byte #61,#61,#32,#37,#115,#32,#61,#61,#10,#0
__bbcc_00000028:
.byte #37,#48,#52,#117,#32,#0
__bbcc_00000029:
.byte #32,#32,#32,#124,#32,#0
__bbcc_0000002a:
.byte #79,#80,#95,#67,#79,#78,#83,#84,#65,#78,#84,#0
__bbcc_0000002b:
.byte #79,#80,#95,#67,#79,#78,#83,#84,#65,#78,#84,#95,#76,#79,#78,#71,#0
__bbcc_0000002c:
.byte #79,#80,#95,#78,#69,#71,#65,#84,#69,#0
__bbcc_0000002d:
.byte #79,#80,#95,#65,#68,#68,#0
__bbcc_0000002e:
.byte #79,#80,#95,#83,#85,#66,#84,#82,#65,#67,#84,#0
__bbcc_0000002f:
.byte #79,#80,#95,#77,#85,#76,#84,#73,#80,#76,#89,#0
__bbcc_00000030:
.byte #79,#80,#95,#68,#73,#86,#73,#68,#69,#0
__bbcc_00000031:
.byte #79,#80,#95,#77,#79,#68,#85,#76,#85,#83,#0
__bbcc_00000032:
.byte #79,#80,#95,#82,#69,#84,#85,#82,#78,#0
__bbcc_00000033:
.byte #79,#80,#95,#78,#79,#84,#0
__bbcc_00000034:
.byte #79,#80,#95,#69,#81,#85,#65,#76,#0
__bbcc_00000035:
.byte #79,#80,#95,#71,#82,#69,#65,#84,#69,#82,#0
__bbcc_00000036:
.byte #79,#80,#95,#76,#69,#83,#83,#0
__bbcc_00000037:
.byte #85,#110,#107,#110,#111,#119,#110,#32,#111,#112,#99,#111,#100,#101,#32,#37,#100,#10,#0
__bbcc_00000038:
.byte #37,#115,#10,#0
__bbcc_00000039:
.byte #37,#115,#32,#37,#48,#52,#117,#32,#39,#0
__bbcc_0000003a:
.byte #39,#10,#0
// Function: initLineInfoArray
initLineInfoArray:
	push %r11
	mov %r13, %r11
	push %r1
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
// Set
	mov #0, %r0
// SetAt
	mov 4[%r11], %r1
	mov %r0, WORD [%r1]
// Return
	mov #0, %r0
__bbcc_0000003b:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: writeLineInfoArray
writeLineInfoArray:
	push %r11
	mov %r13, %r11
	sub #4, %r13
	push %r1
	push %r2
// ReadAt
	mov WORD 4[%r11], %r0
	mov WORD [%r0], %r0
// Set
	mov #1, %r1
// Add
	add %r1, %r0
// ReadAt
	mov WORD 4[%r11], %r1
	mov WORD 2[%r1], %r1
// MoreEqualJmp
	cmp %r1, %r0
	jae [__bbcc_00000000]
// ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 2[%r0], %r0
// Set
// Set
// CallFunction
	push %r0
	call [growCapacity]
	add #2, %r13
// Set
// SetAt
	mov 4[%r11], %r1
	mov %r0, WORD 2[%r1]
// ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 4[%r0], %r0
// Set
	mov %r0, %r1
// ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 2[%r0], %r0
// Mult
	mul #4, %r0
// CallFunction
	push %r0
	push %r1
	call [reallocate]
	add #4, %r13
// Set
// Set
// SetAt
	mov 4[%r11], %r1
	mov %r0, WORD 4[%r1]
// Label
__bbcc_00000000:
// ReadAt
	mov WORD 6[%r11], %r0
	mov WORD [%r0], %r1
	mov %r1, WORD -4[%r11]
	mov WORD 2[%r0], %r1
	mov %r1, WORD -2[%r11]
// ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 4[%r0], %r2
// ReadAt
	mov WORD 4[%r11], %r0
	mov WORD [%r0], %r1
// Mult
	mov #4, %r0
	mul %r1, %r0
// SetAt
	mov %r2, %r1
	add %r0, %r1
	mov -4[%r11], %r0
	mov %r0, WORD [%r1]
	mov -2[%r11], %r0
	mov %r0, WORD 2[%r1]
// ReadAt
	mov WORD 4[%r11], %r0
	mov WORD [%r0], %r1
// Set
	mov %r1, %r0
// Add
	mov #1, %r0
	add %r1, %r0
// SetAt
	mov 4[%r11], %r1
	mov %r0, WORD [%r1]
// Return
	mov #0, %r0
__bbcc_0000003c:
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: freeLineInfoArray
freeLineInfoArray:
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
	call [initLineInfoArray]
	add #2, %r13
// Return
	mov #0, %r0
__bbcc_0000003d:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: getLastLine
getLastLine:
	push %r11
	mov %r13, %r11
	push %r1
	push %r2
// ReadAt
	mov WORD 4[%r11], %r0
	mov WORD [%r0], %r0
// NotEqualJmp
	cmp #0, %r0
	jnz [__bbcc_00000001]
// Return
	mov #0, %r0
	jmp [__bbcc_0000003e]
// Label
__bbcc_00000001:
// ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 4[%r0], %r1
// ReadAt
	mov WORD 4[%r11], %r0
	mov WORD [%r0], %r0
// Set
	mov #1, %r2
// Sub
	sub %r2, %r0
// Mult
	mov #4, %r2
	mul %r0, %r2
// Add
	add %r2, %r1
// ReadAt
	mov WORD 2[%r1], %r0
// Return
__bbcc_0000003e:
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: getLine
getLine:
	push %r11
	mov %r13, %r11
	sub #8, %r13
	push %r1
	push %r2
	push %r3
	push %r4
// Set
	mov #0, %r0
// Set
	mov %r0, %r3
// Set
	mov #0, %r0
// Set
	mov %r0, %r2
// Label
__bbcc_00000002:
// ReadAt
	mov WORD 4[%r11], %r0
	mov WORD [%r0], %r0
// MoreEqualJmp
	cmp %r2, %r0
	jae [__bbcc_00000004]
// ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 4[%r0], %r1
// Mult
	mov #4, %r0
	mul %r2, %r0
// ReadAt
	add %r0, %r1
	mov WORD [%r1], %r4
	mov %r4, WORD -8[%r11]
	mov WORD 2[%r1], %r4
	mov %r4, WORD -6[%r11]
// Set
	mov WORD -8[%r11], %r0
	mov %r0, WORD -4[%r11]
	mov WORD -6[%r11], %r0
	mov %r0, WORD -2[%r11]
// AddrOf
	lea WORD -4[%r11], %r0
// ReadAt
	mov WORD [%r0], %r0
// MoreThanJmp
	mov 6[%r11], %r1
	cmp %r0, %r1
	ja [__bbcc_00000005]
// AddrOf
	lea WORD -4[%r11], %r0
// ReadAt
	mov WORD 2[%r0], %r0
// Set
	mov %r0, %r3
// Jmp
	jmp [__bbcc_00000006]
// Label
__bbcc_00000005:
// Jmp
	jmp [__bbcc_00000004]
// Label
__bbcc_00000006:
// Label
__bbcc_00000003:
// Set
	mov %r2, %r0
// Add
	mov #1, %r0
	add %r2, %r0
// Set
	mov %r0, %r2
// Jmp
	jmp [__bbcc_00000002]
// Label
__bbcc_00000004:
// Return
	mov %r3, %r0
__bbcc_0000003f:
	pop %r4
	pop %r3
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: writeLine
writeLine:
	push %r11
	mov %r13, %r11
	sub #4, %r13
	push %r1
// AddrOf
	lea WORD -4[%r11], %r0
// SetAt
	mov 6[%r11], %r1
	mov %r1, WORD [%r0]
// AddrOf
	lea WORD -4[%r11], %r0
// SetAt
	mov 8[%r11], %r1
	mov %r1, WORD 2[%r0]
// Set
	mov WORD 4[%r11], %r1
// AddrOf
	lea WORD -4[%r11], %r0
// Set
// CallFunction
	push %r0
	push %r1
	call [writeLineInfoArray]
	add #4, %r13
// Return
	mov #0, %r0
__bbcc_00000040:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: disassembleChunk
disassembleChunk:
	push %r11
	mov %r13, %r11
	push %r1
// AddrOf
	lea WORD [__bbcc_00000027], %r0
// Set
// CallFunction
	mov 6[%r11], %r1
	push %r1
	push %r0
	call [printf]
	add #4, %r13
// Set
	mov #0, %r0
// Set
	mov %r0, %r1
// Label
__bbcc_00000007:
// ReadAt
	mov WORD 4[%r11], %r0
	mov WORD [%r0], %r0
// MoreEqualJmp
	cmp %r1, %r0
	jae [__bbcc_00000009]
// Set
	mov WORD 4[%r11], %r0
// CallFunction
	push %r1
	push %r0
	call [disassembleInstruction]
	add #4, %r13
// Set
	mov %r0, %r1
// Label
__bbcc_00000008:
// Jmp
	jmp [__bbcc_00000007]
// Label
__bbcc_00000009:
// Return
	mov #0, %r0
__bbcc_00000041:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: disassembleInstruction
disassembleInstruction:
	push %r11
	mov %r13, %r11
	push %r1
	push %r2
	push %r3
	push %r4
// AddrOf
	lea WORD [__bbcc_00000028], %r0
// Set
// CallFunction
	mov 6[%r11], %r1
	push %r1
	push %r0
	call [printf]
	add #4, %r13
// Add
	mov WORD 4[%r11], %r0
	add #12, %r0
// Set
// CallFunction
	mov 6[%r11], %r1
	push %r1
	push %r0
	call [getLine]
	add #4, %r13
// Set
	mov %r0, %r2
// Set
	mov #0, %r4
// LessEqualJmp
	mov #0, %r0
	cmp 6[%r11], %r0
	jle [__bbcc_0000000b]
// Add
	mov WORD 4[%r11], %r0
	add #12, %r0
// Set
	mov %r0, %r3
// Set
	mov #1, %r1
// Sub
	mov WORD 6[%r11], %r0
	sub %r1, %r0
// CallFunction
	push %r0
	push %r3
	call [getLine]
	add #4, %r13
// NotEqualJmp
	cmp %r0, %r2
	jnz [__bbcc_0000000b]
// Set
	mov #1, %r4
// Label
__bbcc_0000000b:
// JmpZero
	cmp #0, %r4
	jze [__bbcc_0000000a]
// AddrOf
	lea WORD [__bbcc_00000029], %r0
// Set
// CallFunction
	push %r0
	call [printf]
	add #2, %r13
// Jmp
	jmp [__bbcc_0000000c]
// Label
__bbcc_0000000a:
// AddrOf
	lea WORD [__bbcc_00000028], %r0
// Set
// CallFunction
	push %r2
	push %r0
	call [printf]
	add #4, %r13
// Label
__bbcc_0000000c:
// ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 4[%r0], %r0
// ReadAt
	add WORD 6[%r11], %r0
	mov BYTE [%r0], %r0
// Set
	mov %r0, %r1
// NotEqualJmp
	cmp #0, %r1
	jnz [__bbcc_0000000d]
// AddrOf
	lea WORD [__bbcc_0000002a], %r0
// Set
	mov %r0, %r2
// Set
	mov WORD 4[%r11], %r0
// CallFunction
	mov 6[%r11], %r3
	push %r3
	push %r0
	push %r2
	call [constantInstruction]
	add #6, %r13
// Return
	jmp [__bbcc_00000042]
// Jmp
	jmp [__bbcc_0000000e]
// Label
__bbcc_0000000d:
// NotEqualJmp
	cmp #1, %r1
	jnz [__bbcc_0000000f]
// AddrOf
	lea WORD [__bbcc_0000002b], %r0
// Set
	mov %r0, %r2
// Set
	mov WORD 4[%r11], %r0
// CallFunction
	mov 6[%r11], %r3
	push %r3
	push %r0
	push %r2
	call [longConstantInstruction]
	add #6, %r13
// Return
	jmp [__bbcc_00000042]
// Jmp
	jmp [__bbcc_00000010]
// Label
__bbcc_0000000f:
// NotEqualJmp
	cmp #2, %r1
	jnz [__bbcc_00000011]
// AddrOf
	lea WORD [__bbcc_0000002c], %r0
// Set
// CallFunction
	mov 6[%r11], %r2
	push %r2
	push %r0
	call [simpleInstruction]
	add #4, %r13
// Return
	jmp [__bbcc_00000042]
// Jmp
	jmp [__bbcc_00000012]
// Label
__bbcc_00000011:
// NotEqualJmp
	cmp #3, %r1
	jnz [__bbcc_00000013]
// AddrOf
	lea WORD [__bbcc_0000002d], %r0
// Set
// CallFunction
	mov 6[%r11], %r2
	push %r2
	push %r0
	call [simpleInstruction]
	add #4, %r13
// Return
	jmp [__bbcc_00000042]
// Jmp
	jmp [__bbcc_00000014]
// Label
__bbcc_00000013:
// NotEqualJmp
	cmp #4, %r1
	jnz [__bbcc_00000015]
// AddrOf
	lea WORD [__bbcc_0000002e], %r0
// Set
// CallFunction
	mov 6[%r11], %r2
	push %r2
	push %r0
	call [simpleInstruction]
	add #4, %r13
// Return
	jmp [__bbcc_00000042]
// Jmp
	jmp [__bbcc_00000016]
// Label
__bbcc_00000015:
// NotEqualJmp
	cmp #5, %r1
	jnz [__bbcc_00000017]
// AddrOf
	lea WORD [__bbcc_0000002f], %r0
// Set
// CallFunction
	mov 6[%r11], %r2
	push %r2
	push %r0
	call [simpleInstruction]
	add #4, %r13
// Return
	jmp [__bbcc_00000042]
// Jmp
	jmp [__bbcc_00000018]
// Label
__bbcc_00000017:
// NotEqualJmp
	cmp #6, %r1
	jnz [__bbcc_00000019]
// AddrOf
	lea WORD [__bbcc_00000030], %r0
// Set
// CallFunction
	mov 6[%r11], %r2
	push %r2
	push %r0
	call [simpleInstruction]
	add #4, %r13
// Return
	jmp [__bbcc_00000042]
// Jmp
	jmp [__bbcc_0000001a]
// Label
__bbcc_00000019:
// NotEqualJmp
	cmp #7, %r1
	jnz [__bbcc_0000001b]
// AddrOf
	lea WORD [__bbcc_00000031], %r0
// Set
// CallFunction
	mov 6[%r11], %r2
	push %r2
	push %r0
	call [simpleInstruction]
	add #4, %r13
// Return
	jmp [__bbcc_00000042]
// Jmp
	jmp [__bbcc_0000001c]
// Label
__bbcc_0000001b:
// NotEqualJmp
	cmp #8, %r1
	jnz [__bbcc_0000001d]
// AddrOf
	lea WORD [__bbcc_00000032], %r0
// Set
// CallFunction
	mov 6[%r11], %r2
	push %r2
	push %r0
	call [simpleInstruction]
	add #4, %r13
// Return
	jmp [__bbcc_00000042]
// Jmp
	jmp [__bbcc_0000001e]
// Label
__bbcc_0000001d:
// NotEqualJmp
	cmp #9, %r1
	jnz [__bbcc_0000001f]
// AddrOf
	lea WORD [__bbcc_00000033], %r0
// Set
// CallFunction
	mov 6[%r11], %r2
	push %r2
	push %r0
	call [simpleInstruction]
	add #4, %r13
// Return
	jmp [__bbcc_00000042]
// Jmp
	jmp [__bbcc_00000020]
// Label
__bbcc_0000001f:
// NotEqualJmp
	cmp #10, %r1
	jnz [__bbcc_00000021]
// AddrOf
	lea WORD [__bbcc_00000034], %r0
// Set
// CallFunction
	mov 6[%r11], %r2
	push %r2
	push %r0
	call [simpleInstruction]
	add #4, %r13
// Return
	jmp [__bbcc_00000042]
// Jmp
	jmp [__bbcc_00000022]
// Label
__bbcc_00000021:
// NotEqualJmp
	cmp #11, %r1
	jnz [__bbcc_00000023]
// AddrOf
	lea WORD [__bbcc_00000035], %r0
// Set
// CallFunction
	mov 6[%r11], %r2
	push %r2
	push %r0
	call [simpleInstruction]
	add #4, %r13
// Return
	jmp [__bbcc_00000042]
// Jmp
	jmp [__bbcc_00000024]
// Label
__bbcc_00000023:
// NotEqualJmp
	cmp #12, %r1
	jnz [__bbcc_00000025]
// AddrOf
	lea WORD [__bbcc_00000036], %r0
// Set
// CallFunction
	mov 6[%r11], %r2
	push %r2
	push %r0
	call [simpleInstruction]
	add #4, %r13
// Return
	jmp [__bbcc_00000042]
// Jmp
	jmp [__bbcc_00000026]
// Label
__bbcc_00000025:
// AddrOf
	lea WORD [__bbcc_00000037], %r0
// Set
// CallFunction
	push %r1
	push %r0
	call [printf]
	add #4, %r13
// Set
	mov #1, %r1
// Add
	mov WORD 6[%r11], %r0
	add %r1, %r0
// Return
	jmp [__bbcc_00000042]
// Label
__bbcc_00000026:
// Label
__bbcc_00000024:
// Label
__bbcc_00000022:
// Label
__bbcc_00000020:
// Label
__bbcc_0000001e:
// Label
__bbcc_0000001c:
// Label
__bbcc_0000001a:
// Label
__bbcc_00000018:
// Label
__bbcc_00000016:
// Label
__bbcc_00000014:
// Label
__bbcc_00000012:
// Label
__bbcc_00000010:
// Label
__bbcc_0000000e:
// Return
	mov #0, %r0
__bbcc_00000042:
	pop %r4
	pop %r3
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: simpleInstruction
simpleInstruction:
	push %r11
	mov %r13, %r11
	push %r1
// AddrOf
	lea WORD [__bbcc_00000038], %r0
// Set
// CallFunction
	mov 4[%r11], %r1
	push %r1
	push %r0
	call [printf]
	add #4, %r13
// Set
	mov #1, %r1
// Add
	mov WORD 6[%r11], %r0
	add %r1, %r0
// Return
__bbcc_00000043:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: constantInstruction
constantInstruction:
	push %r11
	mov %r13, %r11
	push %r1
	push %r2
// ReadAt
	mov WORD 6[%r11], %r0
	mov WORD 4[%r0], %r2
// Set
	mov #1, %r1
// Add
	mov WORD 8[%r11], %r0
	add %r1, %r0
// ReadAt
	mov %r2, %r1
	add %r0, %r1
	mov BYTE [%r1], %r0
// Set
	mov %r0, %r2
// AddrOf
	lea WORD [__bbcc_00000039], %r0
// Set
// CallFunction
	push %r2
	mov 4[%r11], %r1
	push %r1
	push %r0
	call [printf]
	add #6, %r13
// Add
	mov WORD 6[%r11], %r0
	add #6, %r0
// ReadAt
	mov WORD 4[%r0], %r0
// Mult
	mov #4, %r1
	mul %r2, %r1
// Add
	add %r1, %r0
// Set
// CallFunction
	push %r0
	call [printValue]
	add #2, %r13
// AddrOf
	lea WORD [__bbcc_0000003a], %r0
// Set
// CallFunction
	push %r0
	call [printf]
	add #2, %r13
// Set
	mov #2, %r1
// Add
	mov WORD 8[%r11], %r0
	add %r1, %r0
// Return
__bbcc_00000044:
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: longConstantInstruction
longConstantInstruction:
	push %r11
	mov %r13, %r11
	push %r1
	push %r2
// ReadAt
	mov WORD 6[%r11], %r0
	mov WORD 4[%r0], %r0
// Set
	mov #1, %r2
// Add
	mov WORD 8[%r11], %r1
	add %r2, %r1
// Add
	add %r1, %r0
// Set
// ReadAt
	mov WORD [%r0], %r0
// Set
	mov %r0, %r2
// AddrOf
	lea WORD [__bbcc_00000039], %r0
// Set
// CallFunction
	push %r2
	mov 4[%r11], %r1
	push %r1
	push %r0
	call [printf]
	add #6, %r13
// Add
	mov WORD 6[%r11], %r0
	add #6, %r0
// ReadAt
	mov WORD 4[%r0], %r0
// Mult
	mov #4, %r1
	mul %r2, %r1
// Add
	add %r1, %r0
// Set
// CallFunction
	push %r0
	call [printValue]
	add #2, %r13
// AddrOf
	lea WORD [__bbcc_0000003a], %r0
// Set
// CallFunction
	push %r0
	call [printf]
	add #2, %r13
// Set
	mov #3, %r1
// Add
	mov WORD 8[%r11], %r0
	add %r1, %r0
// Return
__bbcc_00000045:
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret