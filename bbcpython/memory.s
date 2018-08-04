.import malloc
.import free
.import realloc
.export growCapacity
.export reallocate
\ Function: growCapacity
growCapacity:
	push %r11
	mov %r13, %r11
	push %r1
\ LessThanCmp
	mov #8, %r1
	mov #1, %r0
	cmp 4[%r11], %r1
	jl [__bbcc_00000003]
	mov #0, %r0
__bbcc_00000003:
\ Add
	mov #8, %r1
	add WORD 4[%r11], %r1
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_00000000]
\ Set
	mov #8, %r0
\ Jmp
	jmp [__bbcc_00000001]
\ Label
__bbcc_00000000:
\ Set
	mov %r1, %r0
\ Label
__bbcc_00000001:
\ Return
__bbcc_00000004:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
\ Function: reallocate
reallocate:
	push %r11
	mov %r13, %r11
	push %r1
\ EqualCmp
	mov #0, %r1
	mov #1, %r0
	cmp 6[%r11], %r1
	jze [__bbcc_00000005]
	mov #0, %r0
__bbcc_00000005:
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_00000002]
\ Set
	mov WORD 4[%r11], %r0
\ CallFunction
	push %r0
	call [free]
	add #2, %r13
\ Return
	mov #0, %r0
	jmp [__bbcc_00000006]
\ Label
__bbcc_00000002:
\ Set
	mov WORD 4[%r11], %r0
\ CallFunction
	mov 6[%r11], %r1
	push %r1
	push %r0
	call [realloc]
	add #4, %r13
\ Return
__bbcc_00000006:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret