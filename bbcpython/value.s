.import putchar
.import getchar
.import printf
.import fputs
.import puts
.import growCapacity
.import reallocate
.export initValueArray
.export writeValueArray
.export freeValueArray
.export printValue
__bbcc_00000001:
.byte #37,#117,#0
\ Function: initValueArray
initValueArray:
	push %r11
	mov %r13, %r11
	push %r1
\ Set
	mov #0, %r0
\ SetAt
	mov 4[%r11], %r1
	mov %r0, WORD 4[%r1]
\ Set
	mov #0, %r0
\ SetAt
	mov 4[%r11], %r1
	mov %r0, WORD 2[%r1]
\ Set
	mov #0, %r0
\ SetAt
	mov 4[%r11], %r1
	mov %r0, WORD [%r1]
\ Return
	mov #0, %r0
__bbcc_00000002:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
\ Function: writeValueArray
writeValueArray:
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
\ Set
	mov #1, %r1
\ Add
	add %r1, %r0
\ LessThanCmp
	mov #1, %r1
	cmp %r2, %r0
	jb [__bbcc_00000003]
	mov #0, %r1
__bbcc_00000003:
\ JmpZero
	cmp #0, %r1
	jze [__bbcc_00000000]
\ ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 2[%r0], %r0
\ Set
\ Set
\ CallFunction
	push %r0
	call [growCapacity]
	add #2, %r13
\ Set
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
\ Mult
	mul #2, %r0
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
	mov WORD [%r0], %r2
\ ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 4[%r0], %r1
\ Mult
	mov #2, %r0
	mul %r2, %r0
\ SetAt
	add %r0, %r1
	mov 6[%r11], %r0
	mov %r0, WORD [%r1]
\ ReadAt
	mov WORD 4[%r11], %r0
	mov WORD [%r0], %r1
\ Set
	mov %r1, %r0
\ Add
	mov #1, %r0
	add %r1, %r0
\ SetAt
	mov 4[%r11], %r1
	mov %r0, WORD [%r1]
\ Return
	mov #0, %r0
__bbcc_00000004:
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
\ Function: freeValueArray
freeValueArray:
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
	call [initValueArray]
	add #2, %r13
\ Return
	mov #0, %r0
__bbcc_00000005:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
\ Function: printValue
printValue:
	push %r11
	mov %r13, %r11
	push %r1
\ AddrOf
	lea WORD [__bbcc_00000001], %r0
\ Set
\ CallFunction
	mov 4[%r11], %r1
	push %r1
	push %r0
	call [printf]
	add #4, %r13
\ Return
	mov #0, %r0
__bbcc_00000006:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret