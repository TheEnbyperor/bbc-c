.import writeio
.export main
// Function: main
main:
	push %r12
	mov %r14, %r12
	push %r1
// Set
	mov #65024, %r1
// Set
	mov #12, %r0
// CallFunction
	push %r0
	push %r1
	call [writeio]
	add #8, %r14
// Set
	mov #65025, %r1
// ShiftLeft
	mov #31744, %r0
	shl #4, %r0
// Sub
	sub #116, %r0
// ExcOr
	xor #32, %r0
// Set
// CallFunction
	push %r0
	push %r1
	call [writeio]
	add #8, %r14
// Asm
	mov6502 %0 $FE00
// Return
	mov #0, %r0
__bbcc_00000000:
	pop %r1
	mov %r12, %r14
	pop %r12
	ret