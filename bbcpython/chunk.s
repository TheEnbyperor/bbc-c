.import growCapacity
.import reallocate
.export initChunk
.export freeChunk
.export writeChunk
\ Function: initChunk
initChunk:
	push %r11
	mov %r13, %r11
	push %r1
\ SetAt
	mov 4[%r11], %r0
	mov #0, %r1
	mov %r1, WORD [%r0]
\ SetAt
	mov 4[%r11], %r0
	mov #0, %r1
	mov %r1, WORD 2[%r0]
\ Set
	mov #0, %r0
\ SetAt
	mov 4[%r11], %r1
	mov %r0, WORD 4[%r1]
\ Return
	mov #0, %r0
__bbcc_00000001:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
\ Function: writeChunk
writeChunk:
	push %r11
	mov %r13, %r11
	push %r1
	push %r2
\ ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 2[%r0], %r2
\ ReadAt
	mov WORD 4[%r11], %r0
	mov WORD [%r0], %r0
\ Add
	mov #1, %r1
	add %r0, %r1
\ LessThanCmp
	mov #1, %r0
	cmp %r2, %r1
	jl [__bbcc_00000002]
	mov #0, %r0
__bbcc_00000002:
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_00000000]
\ ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 2[%r0], %r0
\ CallFunction
	push %r0
	call [growCapacity]
	add #2, %r13
\ SetAt
	mov 4[%r11], %r1
	mov %r0, WORD 2[%r1]
\ ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 4[%r0], %r0
\ Set
	mov %r0, %r1
\ ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 2[%r0], %r0
\ Set
\ CallFunction
	push %r0
	push %r1
	call [reallocate]
	add #4, %r13
\ Set
\ Set
\ SetAt
	mov 4[%r11], %r1
	mov %r0, WORD 4[%r1]
\ Label
__bbcc_00000000:
\ ReadAt
	mov WORD 4[%r11], %r0
	mov WORD [%r0], %r1
\ ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 4[%r0], %r0
\ SetAt
	mov %r0, %r0
	add %r1, %r0
	mov 6[%r11], %r1
	mov %r1, BYTE [%r0]
\ ReadAt
	mov WORD 4[%r11], %r0
	mov WORD [%r0], %r0
\ Add
	add #1, %r0
\ SetAt
	mov 4[%r11], %r1
	mov %r0, WORD [%r1]
\ Return
	mov #0, %r0
__bbcc_00000003:
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
\ Function: freeChunk
freeChunk:
	push %r11
	mov %r13, %r11
	push %r1
\ ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 4[%r0], %r0
\ Set
	mov %r0, %r1
\ Set
	mov #0, %r0
\ CallFunction
	push %r0
	push %r1
	call [reallocate]
	add #4, %r13
\ Set
	mov WORD 4[%r11], %r0
\ CallFunction
	push %r0
	call [initChunk]
	add #2, %r13
\ Return
	mov #0, %r0
__bbcc_00000004:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret