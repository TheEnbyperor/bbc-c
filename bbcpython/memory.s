.import free
.import realloc
.export growCapacity
.export shrinkCapacity
.export reallocate
// Function: growCapacity
growCapacity:
	push %r11
	mov %r13, %r11
// MoreEqualJmp
	mov #8, %r0
	cmp 4[%r11], %r0
	jge [__bbcc_00000000]
// Set
	mov #8, %r0
// Jmp
	jmp [__bbcc_00000001]
// Label
__bbcc_00000000:
// Add
	mov WORD 4[%r11], %r0
	add #8, %r0
// Set
// Label
__bbcc_00000001:
// Return
__bbcc_00000005:
	mov %r11, %r13
	pop %r11
	ret
// Function: shrinkCapacity
shrinkCapacity:
	push %r11
	mov %r13, %r11
	push %r1
// Sub
	mov WORD 4[%r11], %r0
	sub #8, %r0
// MoreEqualJmp
	mov 6[%r11], %r1
	cmp %r0, %r1
	jge [__bbcc_00000002]
// Set
	mov WORD 4[%r11], %r0
// Jmp
	jmp [__bbcc_00000003]
// Label
__bbcc_00000002:
// Sub
	mov WORD 4[%r11], %r0
	sub #8, %r0
// Set
// Label
__bbcc_00000003:
// Return
__bbcc_00000006:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: reallocate
reallocate:
	push %r11
	mov %r13, %r11
	push %r1
// NotEqualJmp
	mov #0, %r0
	cmp 6[%r11], %r0
	jnz [__bbcc_00000004]
// Set
	mov WORD 4[%r11], %r0
// CallFunction
	push %r0
	call [free]
	add #2, %r13
// Return
	mov #0, %r0
	jmp [__bbcc_00000007]
// Label
__bbcc_00000004:
// Set
	mov WORD 4[%r11], %r0
// CallFunction
	mov 6[%r11], %r1
	push %r1
	push %r0
	call [realloc]
	add #4, %r13
// Return
__bbcc_00000007:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret