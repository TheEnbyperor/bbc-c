.import memcpy
.export main
__bbcc_00000000:
.byte #104,#101,#108,#108,#111,#0
// Function: main
main:
	push %r12
	mov %r14, %r12
	sub #20, %r14
	push %r1
	push %r2
// AddrOf
	lea DWORD -20[%r12], %r1
// Set
// AddrOf
	lea DWORD [__bbcc_00000000], %r0
// Set
// Set
	mov #5, %r2
// CallFunction
	push %r2
	push %r0
	push %r1
	call [memcpy]
	add #12, %r14
// Return
	mov #0, %r0
__bbcc_00000001:
	pop %r2
	pop %r1
	mov %r12, %r14
	pop %r12
	ret