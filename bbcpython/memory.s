.import free
.import realloc
.export growCapacity
.export shrinkCapacity
.export reallocate
.export freeObjects
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
__bbcc_00000008:
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
__bbcc_00000009:
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
	jmp [__bbcc_0000000a]
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
__bbcc_0000000a:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: freeObject
freeObject:
	push %r11
	mov %r13, %r11
	push %r1
// ReadAt
	mov WORD 4[%r11], %r0
	mov BYTE [%r0], %r0
// Set
// NotEqualJmp
	cmp #0, %r0
	jnz [__bbcc_00000005]
// Set
	mov WORD 4[%r11], %r0
// Set
// Set
// ReadAt
	mov WORD 5[%r0], %r0
// Set
	mov %r0, %r1
// Set
	mov #0, %r0
// CallFunction
	push %r0
	push %r1
	call [reallocate]
	add #4, %r13
// Set
	mov WORD 4[%r11], %r1
// Set
	mov #0, %r0
// CallFunction
	push %r0
	push %r1
	call [reallocate]
	add #4, %r13
// Label
__bbcc_00000005:
// Return
	mov #0, %r0
__bbcc_0000000b:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: freeObjects
freeObjects:
	push %r11
	mov %r13, %r11
	push %r1
	push %r2
// ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 10[%r0], %r0
// Set
// Set
	mov %r0, %r2
// Label
__bbcc_00000006:
// EqualJmp
	cmp #0, %r2
	jze [__bbcc_00000007]
// ReadAt
	mov WORD 1[%r2], %r0
// Set
// Set
	mov %r0, %r1
// Set
	mov %r2, %r0
// CallFunction
	push %r0
	call [freeObject]
	add #2, %r13
// Set
	mov %r1, %r0
// Set
	mov %r0, %r2
// Jmp
	jmp [__bbcc_00000006]
// Label
__bbcc_00000007:
// Return
	mov #0, %r0
__bbcc_0000000c:
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret