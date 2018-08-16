.import putchar
.import getchar
.import printf
.import fputs
.import puts
.import initValueArray
.import writeValueArray
.import freeValueArray
.import printValue
.import initChunk
.import freeChunk
.import writeChunk
.import addConstant
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
__bbcc_00000014:
.byte #61,#61,#32,#37,#115,#32,#61,#61,#10,#0
__bbcc_00000015:
.byte #37,#48,#52,#117,#32,#0
__bbcc_00000016:
.byte #32,#32,#32,#124,#32,#0
__bbcc_00000017:
.byte #79,#80,#95,#67,#79,#78,#83,#84,#65,#78,#84,#0
__bbcc_00000018:
.byte #79,#80,#95,#67,#79,#78,#83,#84,#65,#78,#84,#95,#76,#79,#78,#71,#0
__bbcc_00000019:
.byte #79,#80,#95,#82,#69,#84,#85,#82,#78,#0
__bbcc_0000001a:
.byte #85,#110,#107,#110,#111,#119,#110,#32,#111,#112,#99,#111,#100,#101,#32,#37,#100,#10,#0
__bbcc_0000001b:
.byte #37,#115,#10,#0
__bbcc_0000001c:
.byte #37,#115,#32,#37,#48,#52,#117,#32,#39,#0
__bbcc_0000001d:
.byte #39,#10,#0
\ Function: initLineInfoArray
initLineInfoArray:
	push %r11
	mov %r13, %r11
	push %r1
\ Set
	mov #0, %r0
\ SetAt
	mov 4[%r11], %r1
	mov %r0, WORD 4[%r1]
\ Set
	mov #0, %r0
\ SetAt
	mov 4[%r11], %r1
	mov %r0, WORD 2[%r1]
\ Set
	mov #0, %r0
\ SetAt
	mov 4[%r11], %r1
	mov %r0, WORD [%r1]
\ Return
	mov #0, %r0
__bbcc_0000001e:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
\ Function: writeLineInfoArray
writeLineInfoArray:
	push %r11
	mov %r13, %r11
	sub #4, %r13
	push %r1
	push %r2
\ ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 2[%r0], %r2
\ ReadAt
	mov WORD 4[%r11], %r0
	mov WORD [%r0], %r0
\ Set
	mov #1, %r1
\ Add
	add %r1, %r0
\ LessThanCmp
	mov #1, %r1
	cmp %r2, %r0
	jb [__bbcc_0000001f]
	mov #0, %r1
__bbcc_0000001f:
\ JmpZero
	cmp #0, %r1
	jze [__bbcc_00000000]
\ ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 2[%r0], %r0
\ Set
\ Set
\ CallFunction
	push %r0
	call [growCapacity]
	add #2, %r13
\ Set
\ SetAt
	mov 4[%r11], %r1
	mov %r0, WORD 2[%r1]
\ ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 4[%r0], %r0
\ Set
	mov %r0, %r1
\ ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 2[%r0], %r0
\ Mult
	mul #4, %r0
\ CallFunction
	push %r0
	push %r1
	call [reallocate]
	add #4, %r13
\ Set
\ Set
\ SetAt
	mov 4[%r11], %r1
	mov %r0, WORD 4[%r1]
\ Label
__bbcc_00000000:
\ ReadAt
	mov WORD 6[%r11], %r0
	mov WORD [%r0], %r1
	mov %r1, WORD -4[%r11]
	mov WORD 2[%r0], %r1
	mov %r1, WORD -2[%r11]
\ ReadAt
	mov WORD 4[%r11], %r0
	mov WORD [%r0], %r2
\ ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 4[%r0], %r1
\ Mult
	mov #4, %r0
	mul %r2, %r0
\ SetAt
	add %r0, %r1
	mov -4[%r11], %r0
	mov %r0, WORD [%r1]
	mov -2[%r11], %r0
	mov %r0, WORD 2[%r1]
\ ReadAt
	mov WORD 4[%r11], %r0
	mov WORD [%r0], %r1
\ Set
	mov %r1, %r0
\ Add
	mov #1, %r0
	add %r1, %r0
\ SetAt
	mov 4[%r11], %r1
	mov %r0, WORD [%r1]
\ Return
	mov #0, %r0
__bbcc_00000020:
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
\ Function: freeLineInfoArray
freeLineInfoArray:
	push %r11
	mov %r13, %r11
	push %r1
\ ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 4[%r0], %r0
\ Set
	mov %r0, %r1
\ Set
	mov #0, %r0
\ CallFunction
	push %r0
	push %r1
	call [reallocate]
	add #4, %r13
\ Set
	mov WORD 4[%r11], %r0
\ CallFunction
	push %r0
	call [initLineInfoArray]
	add #2, %r13
\ Return
	mov #0, %r0
__bbcc_00000021:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
\ Function: getLastLine
getLastLine:
	push %r11
	mov %r13, %r11
	push %r1
	push %r2
\ ReadAt
	mov WORD 4[%r11], %r0
	mov WORD [%r0], %r1
\ EqualCmp
	mov #1, %r0
	cmp #0, %r1
	jze [__bbcc_00000022]
	mov #0, %r0
__bbcc_00000022:
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_00000001]
\ Return
	mov #0, %r0
	jmp [__bbcc_00000023]
\ Label
__bbcc_00000001:
\ ReadAt
	mov WORD 4[%r11], %r0
	mov WORD [%r0], %r1
\ Set
	mov #1, %r0
\ Sub
	sub %r0, %r1
\ ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 4[%r0], %r0
\ Mult
	mov #4, %r2
	mul %r1, %r2
\ Add
	add %r2, %r0
\ ReadAt
	mov WORD 2[%r0], %r0
\ Return
__bbcc_00000023:
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
\ Function: getLine
getLine:
	push %r11
	mov %r13, %r11
	sub #8, %r13
	push %r1
	push %r2
	push %r3
	push %r4
\ Set
	mov #0, %r0
\ Set
	mov %r0, %r3
\ Set
	mov #0, %r0
\ Set
	mov %r0, %r2
\ Label
__bbcc_00000002:
\ ReadAt
	mov WORD 4[%r11], %r0
	mov WORD [%r0], %r1
\ LessThanCmp
	mov #1, %r0
	cmp %r2, %r1
	jb [__bbcc_00000024]
	mov #0, %r0
__bbcc_00000024:
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_00000004]
\ ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 4[%r0], %r1
\ Mult
	mov #4, %r0
	mul %r2, %r0
\ ReadAt
	add %r0, %r1
	mov WORD [%r1], %r4
	mov %r4, WORD -8[%r11]
	mov WORD 2[%r1], %r4
	mov %r4, WORD -6[%r11]
\ Set
	mov WORD -8[%r11], %r0
	mov %r0, WORD -4[%r11]
	mov WORD -6[%r11], %r0
	mov %r0, WORD -2[%r11]
\ AddrOf
	lea WORD -4[%r11], %r0
\ ReadAt
	mov WORD [%r0], %r1
\ LessEqualCmp
	mov 6[%r11], %r4
	mov #1, %r0
	cmp %r1, %r4
	jbe [__bbcc_00000025]
	mov #0, %r0
__bbcc_00000025:
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_00000005]
\ AddrOf
	lea WORD -4[%r11], %r0
\ ReadAt
	mov WORD 2[%r0], %r0
\ Set
	mov %r0, %r3
\ Jmp
	jmp [__bbcc_00000006]
\ Label
__bbcc_00000005:
\ Jmp
	jmp [__bbcc_00000004]
\ Label
__bbcc_00000006:
\ Label
__bbcc_00000003:
\ Set
	mov %r2, %r0
\ Add
	mov #1, %r0
	add %r2, %r0
\ Set
	mov %r0, %r2
\ Jmp
	jmp [__bbcc_00000002]
\ Label
__bbcc_00000004:
\ Return
	mov %r3, %r0
__bbcc_00000026:
	pop %r4
	pop %r3
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
\ Function: writeLine
writeLine:
	push %r11
	mov %r13, %r11
	sub #4, %r13
	push %r1
\ AddrOf
	lea WORD -4[%r11], %r0
\ SetAt
	mov 6[%r11], %r1
	mov %r1, WORD [%r0]
\ AddrOf
	lea WORD -4[%r11], %r0
\ SetAt
	mov 8[%r11], %r1
	mov %r1, WORD 2[%r0]
\ Set
	mov WORD 4[%r11], %r1
\ AddrOf
	lea WORD -4[%r11], %r0
\ Set
\ CallFunction
	push %r0
	push %r1
	call [writeLineInfoArray]
	add #4, %r13
\ Return
	mov #0, %r0
__bbcc_00000027:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
\ Function: disassembleChunk
disassembleChunk:
	push %r11
	mov %r13, %r11
	push %r1
	push %r2
\ AddrOf
	lea WORD [__bbcc_00000014], %r0
\ Set
\ CallFunction
	mov 6[%r11], %r1
	push %r1
	push %r0
	call [printf]
	add #4, %r13
\ Set
	mov #0, %r0
\ Set
	mov %r0, %r2
\ Label
__bbcc_00000007:
\ ReadAt
	mov WORD 4[%r11], %r0
	mov WORD [%r0], %r1
\ LessThanCmp
	mov #1, %r0
	cmp %r2, %r1
	jb [__bbcc_00000028]
	mov #0, %r0
__bbcc_00000028:
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_00000009]
\ Set
	mov WORD 4[%r11], %r0
\ CallFunction
	push %r2
	push %r0
	call [disassembleInstruction]
	add #4, %r13
\ Set
	mov %r0, %r2
\ Label
__bbcc_00000008:
\ Jmp
	jmp [__bbcc_00000007]
\ Label
__bbcc_00000009:
\ Return
	mov #0, %r0
__bbcc_00000029:
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
\ Function: disassembleInstruction
disassembleInstruction:
	push %r11
	mov %r13, %r11
	push %r1
	push %r2
	push %r3
	push %r4
\ AddrOf
	lea WORD [__bbcc_00000015], %r0
\ Set
\ CallFunction
	mov 6[%r11], %r1
	push %r1
	push %r0
	call [printf]
	add #4, %r13
\ Add
	mov WORD 4[%r11], %r0
	add #12, %r0
\ Set
\ CallFunction
	mov 6[%r11], %r1
	push %r1
	push %r0
	call [getLine]
	add #4, %r13
\ Set
	mov %r0, %r2
\ Set
	mov #0, %r4
\ MoreThanCmp
	mov #0, %r1
	mov #1, %r0
	cmp 6[%r11], %r1
	jg [__bbcc_0000002a]
	mov #0, %r0
__bbcc_0000002a:
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_0000000b]
\ Add
	mov WORD 4[%r11], %r0
	add #12, %r0
\ Set
	mov %r0, %r3
\ Set
	mov #1, %r1
\ Sub
	mov WORD 6[%r11], %r0
	sub %r1, %r0
\ CallFunction
	push %r0
	push %r3
	call [getLine]
	add #4, %r13
	mov %r0, %r1
\ EqualCmp
	mov #1, %r0
	cmp %r1, %r2
	jze [__bbcc_0000002b]
	mov #0, %r0
__bbcc_0000002b:
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_0000000b]
\ Set
	mov #1, %r4
\ Label
__bbcc_0000000b:
\ JmpZero
	cmp #0, %r4
	jze [__bbcc_0000000c]
\ AddrOf
	lea WORD [__bbcc_00000016], %r0
\ Set
\ CallFunction
	push %r0
	call [printf]
	add #2, %r13
\ Jmp
	jmp [__bbcc_0000000d]
\ Label
__bbcc_0000000c:
\ AddrOf
	lea WORD [__bbcc_00000015], %r0
\ Set
\ CallFunction
	push %r2
	push %r0
	call [printf]
	add #4, %r13
\ Label
__bbcc_0000000d:
\ ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 4[%r0], %r0
\ ReadAt
	add WORD 6[%r11], %r0
	mov BYTE [%r0], %r0
\ Set
	mov %r0, %r1
\ EqualCmp
	mov #1, %r0
	cmp #0, %r1
	jze [__bbcc_0000002c]
	mov #0, %r0
__bbcc_0000002c:
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_0000000e]
\ AddrOf
	lea WORD [__bbcc_00000017], %r0
\ Set
	mov %r0, %r2
\ Set
	mov WORD 4[%r11], %r0
\ CallFunction
	mov 6[%r11], %r3
	push %r3
	push %r0
	push %r2
	call [constantInstruction]
	add #6, %r13
\ Return
	jmp [__bbcc_0000002f]
\ Jmp
	jmp [__bbcc_0000000f]
\ Label
__bbcc_0000000e:
\ EqualCmp
	mov #1, %r0
	cmp #1, %r1
	jze [__bbcc_0000002d]
	mov #0, %r0
__bbcc_0000002d:
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_00000010]
\ AddrOf
	lea WORD [__bbcc_00000018], %r0
\ Set
	mov %r0, %r2
\ Set
	mov WORD 4[%r11], %r0
\ CallFunction
	mov 6[%r11], %r3
	push %r3
	push %r0
	push %r2
	call [longConstantInstruction]
	add #6, %r13
\ Return
	jmp [__bbcc_0000002f]
\ Jmp
	jmp [__bbcc_00000011]
\ Label
__bbcc_00000010:
\ EqualCmp
	mov #1, %r0
	cmp #2, %r1
	jze [__bbcc_0000002e]
	mov #0, %r0
__bbcc_0000002e:
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_00000012]
\ AddrOf
	lea WORD [__bbcc_00000019], %r0
\ Set
\ CallFunction
	mov 6[%r11], %r2
	push %r2
	push %r0
	call [simpleInstruction]
	add #4, %r13
\ Return
	jmp [__bbcc_0000002f]
\ Jmp
	jmp [__bbcc_00000013]
\ Label
__bbcc_00000012:
\ AddrOf
	lea WORD [__bbcc_0000001a], %r0
\ Set
\ CallFunction
	push %r1
	push %r0
	call [printf]
	add #4, %r13
\ Set
	mov #1, %r1
\ Add
	mov WORD 6[%r11], %r0
	add %r1, %r0
\ Return
	jmp [__bbcc_0000002f]
\ Label
__bbcc_00000013:
\ Label
__bbcc_00000011:
\ Label
__bbcc_0000000f:
\ Return
	mov #0, %r0
__bbcc_0000002f:
	pop %r4
	pop %r3
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
\ Function: simpleInstruction
simpleInstruction:
	push %r11
	mov %r13, %r11
	push %r1
\ AddrOf
	lea WORD [__bbcc_0000001b], %r0
\ Set
\ CallFunction
	mov 4[%r11], %r1
	push %r1
	push %r0
	call [printf]
	add #4, %r13
\ Set
	mov #1, %r1
\ Add
	mov WORD 6[%r11], %r0
	add %r1, %r0
\ Return
__bbcc_00000030:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
\ Function: constantInstruction
constantInstruction:
	push %r11
	mov %r13, %r11
	push %r1
	push %r2
\ Set
	mov #1, %r0
\ Add
	mov WORD 8[%r11], %r1
	add %r0, %r1
\ ReadAt
	mov WORD 6[%r11], %r0
	mov WORD 4[%r0], %r0
\ ReadAt
	add %r1, %r0
	mov BYTE [%r0], %r0
\ Set
	mov %r0, %r2
\ AddrOf
	lea WORD [__bbcc_0000001c], %r0
\ Set
\ CallFunction
	push %r2
	mov 4[%r11], %r1
	push %r1
	push %r0
	call [printf]
	add #6, %r13
\ Add
	mov WORD 6[%r11], %r0
	add #6, %r0
\ ReadAt
	mov WORD 4[%r0], %r1
\ Mult
	mov #2, %r0
	mul %r2, %r0
\ ReadAt
	add %r0, %r1
	mov WORD [%r1], %r0
\ CallFunction
	push %r0
	call [printValue]
	add #2, %r13
\ AddrOf
	lea WORD [__bbcc_0000001d], %r0
\ Set
\ CallFunction
	push %r0
	call [printf]
	add #2, %r13
\ Set
	mov #2, %r1
\ Add
	mov WORD 8[%r11], %r0
	add %r1, %r0
\ Return
__bbcc_00000031:
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
\ Function: longConstantInstruction
longConstantInstruction:
	push %r11
	mov %r13, %r11
	push %r1
	push %r2
\ Set
	mov #1, %r0
\ Add
	mov WORD 8[%r11], %r1
	add %r0, %r1
\ ReadAt
	mov WORD 6[%r11], %r0
	mov WORD 4[%r0], %r0
\ Add
	add %r1, %r0
\ Set
\ ReadAt
	mov WORD [%r0], %r0
\ Set
	mov %r0, %r2
\ AddrOf
	lea WORD [__bbcc_0000001c], %r0
\ Set
\ CallFunction
	push %r2
	mov 4[%r11], %r1
	push %r1
	push %r0
	call [printf]
	add #6, %r13
\ Add
	mov WORD 6[%r11], %r0
	add #6, %r0
\ ReadAt
	mov WORD 4[%r0], %r1
\ Mult
	mov #2, %r0
	mul %r2, %r0
\ ReadAt
	add %r0, %r1
	mov WORD [%r1], %r0
\ CallFunction
	push %r0
	call [printValue]
	add #2, %r13
\ AddrOf
	lea WORD [__bbcc_0000001d], %r0
\ Set
\ CallFunction
	push %r0
	call [printf]
	add #2, %r13
\ Set
	mov #3, %r1
\ Add
	mov WORD 8[%r11], %r0
	add %r1, %r0
\ Return
__bbcc_00000032:
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret