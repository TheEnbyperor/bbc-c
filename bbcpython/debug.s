.import putchar
.import getchar
.import printf
.import fputs
.import puts
.import initChunk
.import freeChunk
.import writeChunk
.export disassembleChunk
.export disassembleInstruction
__bbcc_00000005:
.byte #61,#61,#32,#37,#115,#32,#61,#61,#10,#0
__bbcc_00000006:
.byte #37,#48,#52,#117,#32,#0
__bbcc_00000007:
.byte #79,#80,#95,#82,#69,#84,#85,#82,#78,#0
__bbcc_00000008:
.byte #85,#110,#107,#110,#111,#119,#110,#32,#111,#112,#99,#111,#100,#101,#32,#37,#100,#10,#0
__bbcc_00000009:
.byte #37,#115,#10,#0
\ Function: disassembleChunk
disassembleChunk:
	push %r11
	mov %r13, %r11
	push %r1
	push %r2
\ AddrOf
	lea WORD [__bbcc_00000005], %r0
\ Set
\ CallFunction
	mov 6[%r11], %r1
	push %r1
	push %r0
	call [printf]
	add #4, %r13
\ Set
	mov #0, %r2
\ Label
__bbcc_00000000:
\ ReadAt
	mov WORD 4[%r11], %r0
	mov WORD [%r0], %r1
\ LessThanCmp
	mov #1, %r0
	cmp %r2, %r1
	jl [__bbcc_0000000a]
	mov #0, %r0
__bbcc_0000000a:
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_00000002]
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
__bbcc_00000001:
\ Jmp
	jmp [__bbcc_00000000]
\ Label
__bbcc_00000002:
\ Return
	mov #0, %r0
__bbcc_0000000b:
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
\ AddrOf
	lea WORD [__bbcc_00000006], %r0
\ Set
\ CallFunction
	mov 6[%r11], %r1
	push %r1
	push %r0
	call [printf]
	add #4, %r13
\ ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 4[%r0], %r0
\ ReadAt
	mov %r0, %r0
	add WORD 6[%r11], %r0
	mov BYTE [%r0], %r0
\ Set
	mov %r0, %r1
\ EqualCmp
	mov #1, %r0
	cmp #0, %r1
	jze [__bbcc_0000000c]
	mov #0, %r0
__bbcc_0000000c:
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_00000003]
\ AddrOf
	lea WORD [__bbcc_00000007], %r0
\ Set
\ CallFunction
	mov 6[%r11], %r2
	push %r2
	push %r0
	call [simpleInstruction]
	add #4, %r13
\ Return
	jmp [__bbcc_0000000d]
\ Jmp
	jmp [__bbcc_00000004]
\ Label
__bbcc_00000003:
\ AddrOf
	lea WORD [__bbcc_00000008], %r0
\ Set
\ CallFunction
	push %r1
	push %r0
	call [printf]
	add #4, %r13
\ Add
	mov WORD 6[%r11], %r0
	add #1, %r0
\ Return
	jmp [__bbcc_0000000d]
\ Label
__bbcc_00000004:
\ Return
	mov #0, %r0
__bbcc_0000000d:
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
	lea WORD [__bbcc_00000009], %r0
\ Set
\ CallFunction
	mov 4[%r11], %r1
	push %r1
	push %r0
	call [printf]
	add #4, %r13
\ Add
	mov WORD 6[%r11], %r0
	add #1, %r0
\ Return
__bbcc_0000000e:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret