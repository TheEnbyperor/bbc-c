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
.import initLineInfoArray
.import writeLineInfoArray
.import freeLineInfoArray
.import getLastLine
.import getLine
.import writeLine
.import disassembleChunk
.import disassembleInstruction
.export initVM
.export interpret
.export freeVM
__bbcc_00000006:
.byte #10,#0
\ Function: initVM
initVM:
	push %r11
	mov %r13, %r11
\ Return
	mov #0, %r0
__bbcc_00000007:
	mov %r11, %r13
	pop %r11
	ret
\ Function: freeVM
freeVM:
	push %r11
	mov %r13, %r11
\ Return
	mov #0, %r0
__bbcc_00000008:
	mov %r11, %r13
	pop %r11
	ret
\ Function: readByte
readByte:
	push %r11
	mov %r13, %r11
	push %r1
	push %r2
\ ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 2[%r0], %r2
\ Set
	mov %r2, %r1
\ Add
	mov #1, %r0
	add %r2, %r0
\ SetAt
	mov 4[%r11], %r2
	mov %r0, WORD 2[%r2]
\ ReadAt
	mov BYTE [%r1], %r0
\ Return
__bbcc_00000009:
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
\ Function: readConstant
readConstant:
	push %r11
	mov %r13, %r11
	push %r1
	push %r2
\ ReadAt
	mov WORD 4[%r11], %r0
	mov WORD [%r0], %r1
\ Add
	add #6, %r1
\ Set
	mov WORD 4[%r11], %r0
\ CallFunction
	push %r0
	call [readByte]
	add #2, %r13
	mov %r0, %r2
\ ReadAt
	mov WORD 4[%r1], %r1
\ Mult
	mov #2, %r0
	mul %r2, %r0
\ ReadAt
	add %r0, %r1
	mov WORD [%r1], %r0
\ Return
__bbcc_0000000a:
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
\ Function: run
run:
	push %r11
	mov %r13, %r11
	push %r1
	push %r2
\ Label
__bbcc_00000000:
\ ReadAt
	mov WORD 4[%r11], %r0
	mov WORD [%r0], %r0
\ Set
	mov %r0, %r2
\ ReadAt
	mov WORD 4[%r11], %r0
	mov WORD [%r0], %r1
\ ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 2[%r0], %r0
\ ReadAt
	mov WORD 4[%r1], %r1
\ Set
\ Sub
	sub %r1, %r0
\ Set
\ Set
\ CallFunction
	push %r0
	push %r2
	call [disassembleInstruction]
	add #4, %r13
\ Set
	mov WORD 4[%r11], %r0
\ CallFunction
	push %r0
	call [readByte]
	add #2, %r13
\ Set
	mov %r0, %r1
\ EqualCmp
	mov #1, %r0
	cmp #0, %r1
	jze [__bbcc_0000000b]
	mov #0, %r0
__bbcc_0000000b:
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_00000003]
\ Set
	mov WORD 4[%r11], %r0
\ CallFunction
	push %r0
	call [readConstant]
	add #2, %r13
\ Set
\ CallFunction
	push %r0
	call [printValue]
	add #2, %r13
\ AddrOf
	lea WORD [__bbcc_00000006], %r0
\ Set
\ CallFunction
	push %r0
	call [printf]
	add #2, %r13
\ Jmp
	jmp [__bbcc_00000004]
\ Label
__bbcc_00000003:
\ EqualCmp
	mov #1, %r0
	cmp #2, %r1
	jze [__bbcc_0000000c]
	mov #0, %r0
__bbcc_0000000c:
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_00000005]
\ Return
	mov #0, %r0
	jmp [__bbcc_0000000d]
\ Label
__bbcc_00000005:
\ Label
__bbcc_00000004:
\ Label
__bbcc_00000001:
\ Jmp
	jmp [__bbcc_00000000]
\ Label
__bbcc_00000002:
\ Return
	mov #0, %r0
__bbcc_0000000d:
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
\ Function: interpret
interpret:
	push %r11
	mov %r13, %r11
	push %r1
\ Set
	mov WORD 6[%r11], %r0
\ SetAt
	mov 4[%r11], %r1
	mov %r0, WORD [%r1]
\ ReadAt
	mov WORD 6[%r11], %r0
	mov WORD 4[%r0], %r0
\ Set
\ SetAt
	mov 4[%r11], %r1
	mov %r0, WORD 2[%r1]
\ Set
	mov WORD 4[%r11], %r0
\ CallFunction
	push %r0
	call [run]
	add #2, %r13
\ Return
__bbcc_0000000e:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret