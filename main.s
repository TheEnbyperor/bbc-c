.import malloc
.export main
// Function: main
main:
	push %r12
	mov %r14, %r12
// Set
	mov #4, %r0
// CallFunction
	push %r0
	call [malloc]
	add #4, %r14
// Return
__bbcc_00000000:
	mov %r12, %r14
	pop %r12
	ret