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
.import initChunk
.import freeChunk
.import writeChunk
.import addConstant
.import initVM
.import interpret
.import freeVM
.export main
\ Function: main
main:
	push %r11
	mov %r13, %r11
	sub #22, %r13
	push %r1
	push %r2
	push %r3
\ AddrOf
	lea WORD -4[%r11], %r0
\ Set
\ CallFunction
	push %r0
	call [initVM]
	add #2, %r13
\ AddrOf
	lea WORD -22[%r11], %r0
\ Set
\ CallFunction
	push %r0
	call [initChunk]
	add #2, %r13
\ AddrOf
	lea WORD -22[%r11], %r0
\ Set
\ CallFunction
	mov #2, %r1
	push %r1
	push %r0
	call [addConstant]
	add #4, %r13
\ Set
	mov %r0, %r3
\ AddrOf
	lea WORD -22[%r11], %r0
\ Set
	mov %r0, %r2
\ Set
	mov #0, %r1
\ Set
	mov #123, %r0
\ CallFunction
	push %r0
	push %r1
	push %r2
	call [writeChunk]
	add #6, %r13
\ AddrOf
	lea WORD -22[%r11], %r0
\ Set
	mov %r0, %r2
\ Set
	mov %r3, %r1
\ Set
	mov #123, %r0
\ CallFunction
	push %r0
	push %r1
	push %r2
	call [writeChunk]
	add #6, %r13
\ AddrOf
	lea WORD -22[%r11], %r0
\ Set
	mov %r0, %r2
\ Set
	mov #2, %r1
\ Set
	mov #123, %r0
\ CallFunction
	push %r0
	push %r1
	push %r2
	call [writeChunk]
	add #6, %r13
\ AddrOf
	lea WORD -4[%r11], %r0
\ Set
	mov %r0, %r1
\ AddrOf
	lea WORD -22[%r11], %r0
\ Set
\ CallFunction
	push %r0
	push %r1
	call [interpret]
	add #4, %r13
\ AddrOf
	lea WORD -4[%r11], %r0
\ Set
\ CallFunction
	push %r0
	call [freeVM]
	add #2, %r13
\ AddrOf
	lea WORD -22[%r11], %r0
\ Set
\ CallFunction
	push %r0
	call [freeChunk]
	add #2, %r13
\ Return
	mov #0, %r0
__bbcc_00000000:
	pop %r3
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret