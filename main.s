.export rules
.export initRule
.export number
.export main
rules:
.byte #0,#0,#0,#0,#0,#0,#0,#0,#0
// Function: getRule
getRule:
	push %r12
	mov %r14, %r12
	push %r1
// AddrOf
	lea DWORD [rules], %r0
// Mult
	mov #9, %r1
	mul DWORD 8[%r12], %r1
// Add
	add %r1, %r0
// Return
__bbcc_00000000:
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: initRule
initRule:
	push %r12
	mov %r14, %r12
	push %r1
// SetAt
	mov 8[%r12], %r0
	mov 12[%r12], %r1
	mov %r1, DWORD [%r0]
// SetAt
	mov 8[%r12], %r0
	mov 16[%r12], %r1
	mov %r1, DWORD 4[%r0]
// SetAt
	mov 8[%r12], %r0
	mov 20[%r12], %r1
	mov %r1, BYTE 8[%r0]
// Return
	mov #0, %r0
__bbcc_00000001:
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: number
number:
	push %r12
	mov %r14, %r12
// Return
	mov #0, %r0
__bbcc_00000002:
	mov %r12, %r14
	pop %r12
	ret
// Function: main
main:
	push %r12
	mov %r14, %r12
	push %r1
	push %r2
	push %r3
// AddrOf
	lea DWORD [rules], %r0
// Add
// Set
	mov %r0, %r3
// AddrOf
	lea DWORD [number], %r0
// Set
	mov %r0, %r2
// Set
	mov #0, %r1
// Set
	mov #0, %r0
// CallFunction
	push %r0
	push %r1
	push %r2
	push %r3
	call [initRule]
	add #16, %r14
// Set
	mov #0, %r0
// CallFunction
	push %r0
	call [getRule]
	add #4, %r14
// ReadAt
	mov DWORD [%r0], %r0
// Set
// CallFunction
	call [%r0]
// Return
	mov #0, %r0
__bbcc_00000003:
	pop %r3
	pop %r2
	pop %r1
	mov %r12, %r14
	pop %r12
	ret