.import printf
.import gets
.import initVM
.import interpret
.import freeVM
.export main
__bbcc_00000004:
.byte #62,#62,#62,#32,#0
__bbcc_00000005:
.byte #10,#66,#121,#101,#33,#10,#0
// Function: repl
repl:
	push %r12
	mov %r14, %r12
	sub #255, %r14
	push %r1
// Label
__bbcc_00000000:
// AddrOf
	lea DWORD [__bbcc_00000004], %r0
// Set
// CallFunction
	push %r0
	call [printf]
	add #4, %r14
// AddrOf
	lea DWORD -255[%r12], %r0
// Set
// Set
	mov #255, %r1
// CallFunction
	push %r1
	push %r0
	call [gets]
	add #8, %r14
// JmpNotZero
	cmp #0, %r0
	jnz [__bbcc_00000003]
// AddrOf
	lea DWORD [__bbcc_00000005], %r0
// Set
// CallFunction
	push %r0
	call [printf]
	add #4, %r14
// Jmp
	jmp [__bbcc_00000002]
// Label
__bbcc_00000003:
// Set
	mov DWORD 8[%r12], %r1
// AddrOf
	lea DWORD -255[%r12], %r0
// Set
// CallFunction
	push %r0
	push %r1
	call [interpret]
	add #8, %r14
// Label
__bbcc_00000001:
// Jmp
	jmp [__bbcc_00000000]
// Label
__bbcc_00000002:
// Return
	mov #0, %r0
__bbcc_00000006:
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: main
main:
	push %r12
	mov %r14, %r12
	sub #24, %r14
// AddrOf
	lea DWORD -24[%r12], %r0
// Set
// CallFunction
	push %r0
	call [initVM]
	add #4, %r14
// AddrOf
	lea DWORD -24[%r12], %r0
// Set
// CallFunction
	push %r0
	call [repl]
	add #4, %r14
// AddrOf
	lea DWORD -24[%r12], %r0
// Set
// CallFunction
	push %r0
	call [freeVM]
	add #4, %r14
// Return
	mov #0, %r0
__bbcc_00000007:
	mov %r12, %r14
	pop %r12
	ret