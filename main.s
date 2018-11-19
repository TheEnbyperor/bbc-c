.import isdigit
.export main
// Function: main
main:
	push %r12
	mov %r14, %r12
// CallFunction
	mov #48, %r0
	push %r0
	call [isdigit]
	add #4, %r14
// Return
	mov #0, %r0
__bbcc_00000000:
	mov %r12, %r14
	pop %r12
	ret