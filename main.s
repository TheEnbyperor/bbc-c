.import putchar
.export fputs
.export main
__bbcc_00000003:
.byte #72,#101,#108,#108,#111,#44,#32,#119,#111,#114,#108,#100,#33,#10,#0
// Function: fputs
fputs:
	push %r12
	mov %r14, %r12
// Label
__bbcc_00000000:
// ReadAt
	mov DWORD 8[%r12], %r0
	mov BYTE [%r0], %r0
// Set
// JmpZero
	cmp #0, %r0
	jze [__bbcc_00000002]
// Set
// CallFunction
	push %r0
	call [putchar]
	add #4, %r14
// Label
__bbcc_00000001:
// Add
	mov #1, %r0
	add WORD 8[%r12], %r0
// Set
	mov %r0, WORD 8[%r12]
// Jmp
	jmp [__bbcc_00000000]
// Label
__bbcc_00000002:
// Return
	mov #0, %r0
__bbcc_00000004:
	mov %r12, %r14
	pop %r12
	ret
// Function: main
main:
	push %r12
	mov %r14, %r12
// AddrOf
	lea WORD [__bbcc_00000003], %r0
// Set
// CallFunction
	push %r0
	call [fputs]
	add #4, %r14
// Return
	mov #0, %r0
__bbcc_00000005:
	mov %r12, %r14
	pop %r12
	ret