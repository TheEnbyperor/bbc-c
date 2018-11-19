.export main
// Function: main
main:
	push %r12
	mov %r14, %r12
	push %r1
// Set
	mov #51, %r0
// Set
// Set
// Sub
	sub #48, %r0
// Set
// Set
	mov %r0, %r1
// Set
	mov #0, %r0
// Label
__bbcc_00000000:
// MoreEqualJmp
	cmp %r0, %r1
	jge [__bbcc_00000001]
// Inc
	inc %r0
// Jmp
	jmp [__bbcc_00000000]
// Label
__bbcc_00000001:
// Return
	mov #0, %r0
__bbcc_00000002:
	pop %r1
	mov %r12, %r14
	pop %r12
	ret