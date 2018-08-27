.import printf
.import growCapacity
.import reallocate
.export initValueArray
.export writeValueArray
.export freeValueArray
.export boolVal
.export noneVal
.export intVal
.export isBool
.export isNone
.export isInt
.export asBool
.export asInt
.export printValue
__bbcc_00000008:
.byte #37,#100,#0
__bbcc_00000009:
.byte #78,#111,#110,#101,#0
__bbcc_0000000a:
.byte #84,#114,#117,#101,#0
__bbcc_0000000b:
.byte #70,#97,#108,#115,#101,#0
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
__bbcc_0000000c:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
\ Function: writeValueArray
writeValueArray:
	push %r11
	mov %r13, %r11
	sub #4, %r13
	push %r1
	push %r2
\ ReadAt
	mov WORD 4[%r11], %r0
	mov WORD [%r0], %r0
\ Set
	mov #1, %r1
\ Add
	add %r1, %r0
\ ReadAt
	mov WORD 4[%r11], %r1
	mov WORD 2[%r1], %r1
\ MoreEqualJmp
	cmp %r1, %r0
	jae [__bbcc_00000000]
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
	mul #4, %r0
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
	mov WORD 6[%r11], %r0
	mov WORD [%r0], %r1
	mov %r1, WORD -4[%r11]
	mov WORD 2[%r0], %r1
	mov %r1, WORD -2[%r11]
\ ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 4[%r0], %r2
\ ReadAt
	mov WORD 4[%r11], %r0
	mov WORD [%r0], %r1
\ Mult
	mov #4, %r0
	mul %r1, %r0
\ SetAt
	mov %r2, %r1
	add %r0, %r1
	mov -4[%r11], %r0
	mov %r0, WORD [%r1]
	mov -2[%r11], %r0
	mov %r0, WORD 2[%r1]
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
__bbcc_0000000d:
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
__bbcc_0000000e:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
\ Function: printValue
printValue:
	push %r11
	mov %r13, %r11
	push %r1
	push %r2
\ ReadAt
	mov WORD 4[%r11], %r0
	mov WORD [%r0], %r0
\ Set
	mov %r0, %r2
\ NotEqualJmp
	cmp #1, %r2
	jnz [__bbcc_00000001]
\ AddrOf
	lea WORD [__bbcc_00000008], %r0
\ Set
	mov %r0, %r1
\ Set
	mov WORD 4[%r11], %r0
\ CallFunction
	push %r0
	call [asInt]
	add #2, %r13
\ CallFunction
	push %r0
	push %r1
	call [printf]
	add #4, %r13
\ Jmp
	jmp [__bbcc_00000002]
\ Label
__bbcc_00000001:
\ NotEqualJmp
	cmp #0, %r2
	jnz [__bbcc_00000003]
\ AddrOf
	lea WORD [__bbcc_00000009], %r0
\ Set
\ CallFunction
	push %r0
	call [printf]
	add #2, %r13
\ Jmp
	jmp [__bbcc_00000004]
\ Label
__bbcc_00000003:
\ NotEqualJmp
	cmp #2, %r2
	jnz [__bbcc_00000005]
\ Set
	mov WORD 4[%r11], %r0
\ CallFunction
	push %r0
	call [asBool]
	add #2, %r13
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_00000006]
\ AddrOf
	lea WORD [__bbcc_0000000a], %r0
\ Set
\ Jmp
	jmp [__bbcc_00000007]
\ Label
__bbcc_00000006:
\ AddrOf
	lea WORD [__bbcc_0000000b], %r0
\ Set
\ Label
__bbcc_00000007:
\ Set
\ CallFunction
	push %r0
	call [printf]
	add #2, %r13
\ Label
__bbcc_00000005:
\ Label
__bbcc_00000004:
\ Label
__bbcc_00000002:
\ Return
	mov #0, %r0
__bbcc_0000000f:
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
\ Function: boolVal
boolVal:
	push %r11
	mov %r13, %r11
	push %r1
\ Set
	mov #2, %r0
\ SetAt
	mov 6[%r11], %r1
	mov %r0, WORD [%r1]
\ Add
	mov WORD 6[%r11], %r0
	add #2, %r0
\ SetAt
	mov 4[%r11], %r1
	mov %r1, BYTE [%r0]
\ Return
	mov #0, %r0
__bbcc_00000010:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
\ Function: noneVal
noneVal:
	push %r11
	mov %r13, %r11
	push %r1
\ Set
	mov #0, %r0
\ SetAt
	mov 4[%r11], %r1
	mov %r0, WORD [%r1]
\ Add
	mov WORD 4[%r11], %r0
	add #2, %r0
\ SetAt
	mov #0, %r1
	mov %r1, WORD [%r0]
\ Return
	mov #0, %r0
__bbcc_00000011:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
\ Function: intVal
intVal:
	push %r11
	mov %r13, %r11
	push %r1
\ Set
	mov #1, %r0
\ SetAt
	mov 6[%r11], %r1
	mov %r0, WORD [%r1]
\ Add
	mov WORD 6[%r11], %r0
	add #2, %r0
\ SetAt
	mov 4[%r11], %r1
	mov %r1, WORD [%r0]
\ Return
	mov #0, %r0
__bbcc_00000012:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
\ Function: isBool
isBool:
	push %r11
	mov %r13, %r11
	push %r1
\ ReadAt
	mov WORD 4[%r11], %r0
	mov WORD [%r0], %r1
\ EqualCmp
	cmp #2, %r1
	sze %r0
\ Return
__bbcc_00000013:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
\ Function: isNone
isNone:
	push %r11
	mov %r13, %r11
	push %r1
\ ReadAt
	mov WORD 4[%r11], %r0
	mov WORD [%r0], %r1
\ EqualCmp
	cmp #0, %r1
	sze %r0
\ Return
__bbcc_00000014:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
\ Function: isInt
isInt:
	push %r11
	mov %r13, %r11
	push %r1
\ ReadAt
	mov WORD 4[%r11], %r0
	mov WORD [%r0], %r1
\ EqualCmp
	cmp #1, %r1
	sze %r0
\ Return
__bbcc_00000015:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
\ Function: asBool
asBool:
	push %r11
	mov %r13, %r11
\ Add
	mov WORD 4[%r11], %r0
	add #2, %r0
\ ReadAt
	mov BYTE [%r0], %r0
\ Return
__bbcc_00000016:
	mov %r11, %r13
	pop %r11
	ret
\ Function: asInt
asInt:
	push %r11
	mov %r13, %r11
\ Add
	mov WORD 4[%r11], %r0
	add #2, %r0
\ ReadAt
	mov WORD [%r0], %r0
\ Return
__bbcc_00000017:
	mov %r11, %r13
	pop %r11
	ret