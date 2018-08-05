.import initChunk
.import freeChunk
.import writeChunk
.import disassembleChunk
.import disassembleInstruction
.export main
__bbcc_00000000:
.byte #116,#101,#115,#116,#32,#99,#104,#117,#110,#107,#0
\ Function: main
main:
	push %r11
	mov %r13, %r11
	sub #6, %r13
	push %r1
\ AddrOf
	lea WORD -6[%r11], %r0
\ Set
\ CallFunction
	push %r0
	call [initChunk]
	add #2, %r13
\ AddrOf
	lea WORD -6[%r11], %r0
\ Set
	mov %r0, %r1
\ Set
	mov #0, %r0
\ CallFunction
	push %r0
	push %r1
	call [writeChunk]
	add #4, %r13
\ AddrOf
	lea WORD -6[%r11], %r0
\ Set
	mov %r0, %r1
\ Set
	mov #0, %r0
\ CallFunction
	push %r0
	push %r1
	call [writeChunk]
	add #4, %r13
\ AddrOf
	lea WORD -6[%r11], %r0
\ Set
	mov %r0, %r1
\ AddrOf
	lea WORD [__bbcc_00000000], %r0
\ Set
\ CallFunction
	push %r0
	push %r1
	call [disassembleChunk]
	add #4, %r13
\ AddrOf
	lea WORD -6[%r11], %r0
\ Set
\ CallFunction
	push %r0
	call [freeChunk]
	add #2, %r13
\ Return
	mov #0, %r0
__bbcc_00000001:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret