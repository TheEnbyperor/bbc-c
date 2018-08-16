.import putchar
.import getchar
.import printf
.import fputs
.import puts
.import initValueArray
.import writeValueArray
.import freeValueArray
.import printValue
.import initLineInfoArray
.import writeLineInfoArray
.import freeLineInfoArray
.import getLastLine
.import getLine
.import writeLine
.import disassembleChunk
.import disassembleInstruction
.import growCapacity
.import reallocate
.export initChunk
.export freeChunk
.export writeChunk
.export addConstant
\ Function: initChunk
initChunk:
	push %r11
	mov %r13, %r11
	push %r1
\ Set
	mov #0, %r0
\ SetAt
	mov 4[%r11], %r1
	mov %r0, WORD [%r1]
\ Set
	mov #0, %r0
\ SetAt
	mov 4[%r11], %r1
	mov %r0, WORD 2[%r1]
\ Set
	mov #0, %r0
\ SetAt
	mov 4[%r11], %r1
	mov %r0, WORD 4[%r1]
\ Add
	mov WORD 4[%r11], %r0
	add #6, %r0
\ Set
\ CallFunction
	push %r0
	call [initValueArray]
	add #2, %r13
\ Add
	mov WORD 4[%r11], %r0
	add #12, %r0
\ Set
\ CallFunction
	push %r0
	call [initLineInfoArray]
	add #2, %r13
\ Return
	mov #0, %r0
__bbcc_00000002:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
\ Function: writeChunk
writeChunk:
	push %r11
	mov %r13, %r11
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
	jb [__bbcc_00000003]
	mov #0, %r1
__bbcc_00000003:
\ JmpZero
	cmp #0, %r1
	jze [__bbcc_00000000]
\ ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 2[%r0], %r0
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
\ Add
	mov WORD 4[%r11], %r0
	add #12, %r0
\ Set
\ CallFunction
	push %r0
	call [getLastLine]
	add #2, %r13
	mov %r0, %r1
\ NotEqualCmp
	mov #0, %r0
	cmp 8[%r11], %r1
	jze [__bbcc_00000004]
	mov #1, %r0
__bbcc_00000004:
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_00000001]
\ Add
	mov WORD 4[%r11], %r0
	add #12, %r0
\ Set
	mov %r0, %r1
\ ReadAt
	mov WORD 4[%r11], %r0
	mov WORD [%r0], %r0
\ CallFunction
	mov 8[%r11], %r2
	push %r2
	push %r0
	push %r1
	call [writeLine]
	add #6, %r13
\ Label
__bbcc_00000001:
\ ReadAt
	mov WORD 4[%r11], %r0
	mov WORD [%r0], %r1
\ ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 4[%r0], %r0
\ SetAt
	add %r1, %r0
	mov 6[%r11], %r1
	mov %r1, BYTE [%r0]
\ ReadAt
	mov WORD 4[%r11], %r0
	mov WORD [%r0], %r1
\ Add
	mov #1, %r0
	add %r1, %r0
\ SetAt
	mov 4[%r11], %r1
	mov %r0, WORD [%r1]
\ Return
	mov #0, %r0
__bbcc_00000005:
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
\ Function: addConstant
addConstant:
	push %r11
	mov %r13, %r11
	push %r1
\ Add
	mov WORD 4[%r11], %r0
	add #6, %r0
\ Set
\ CallFunction
	mov 6[%r11], %r1
	push %r1
	push %r0
	call [writeValueArray]
	add #4, %r13
\ Add
	mov WORD 4[%r11], %r0
	add #6, %r0
\ ReadAt
	mov WORD [%r0], %r0
\ Set
	mov #1, %r1
\ Sub
	sub %r1, %r0
\ Return
__bbcc_00000006:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
\ Function: freeChunk
freeChunk:
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
\ Add
	mov WORD 4[%r11], %r0
	add #6, %r0
\ Set
\ CallFunction
	push %r0
	call [freeValueArray]
	add #2, %r13
\ Add
	mov WORD 4[%r11], %r0
	add #12, %r0
\ Set
\ CallFunction
	push %r0
	call [freeLineInfoArray]
	add #2, %r13
\ Set
	mov WORD 4[%r11], %r0
\ CallFunction
	push %r0
	call [initChunk]
	add #2, %r13
\ Return
	mov #0, %r0
__bbcc_00000007:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret