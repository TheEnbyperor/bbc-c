.import printf
.import gets
.import initVM
.import interpret
.import freeVM
.export main
__bbcc_00000004:
.byte #62,#62,#62,#32,#0
__bbcc_00000005:
.byte #10,#0
\ Function: repl
repl:
	push %r11
	mov %r13, %r11
	sub #255, %r13
	push %r1
\ Label
__bbcc_00000000:
\ AddrOf
	lea WORD [__bbcc_00000004], %r0
\ Set
\ CallFunction
	push %r0
	call [printf]
	add #2, %r13
\ AddrOf
	lea WORD -255[%r11], %r0
\ Set
	mov %r0, %r1
\ Set
	mov #255, %r0
\ CallFunction
	push %r0
	push %r1
	call [gets]
	add #4, %r13
\ JmpNotZero
	cmp #0, %r0
	jnz [__bbcc_00000003]
\ AddrOf
	lea WORD [__bbcc_00000005], %r0
\ Set
\ CallFunction
	push %r0
	call [printf]
	add #2, %r13
\ Jmp
	jmp [__bbcc_00000002]
\ Label
__bbcc_00000003:
\ Set
	mov WORD 4[%r11], %r1
\ AddrOf
	lea WORD -255[%r11], %r0
\ Set
\ CallFunction
	push %r0
	push %r1
	call [interpret]
	add #4, %r13
\ Label
__bbcc_00000001:
\ Jmp
	jmp [__bbcc_00000000]
\ Label
__bbcc_00000002:
\ Return
	mov #0, %r0
__bbcc_00000006:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
\ Function: main
main:
	push %r11
	mov %r13, %r11
	sub #10, %r13
\ AddrOf
	lea WORD -10[%r11], %r0
\ Set
\ CallFunction
	push %r0
	call [initVM]
	add #2, %r13
\ Set
	mov WORD -10[%r11], %r0
\ CallFunction
	push %r0
	call [repl]
	add #2, %r13
\ AddrOf
	lea WORD -10[%r11], %r0
\ Set
\ CallFunction
	push %r0
	call [freeVM]
	add #2, %r13
\ Return
	mov #0, %r0
__bbcc_00000007:
	mov %r11, %r13
	pop %r11
	ret