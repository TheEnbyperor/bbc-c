.import strlen
.import strrev
.import strcmp
.import memset
.import backspace
.import append
.import _HIMEM
.export malloc
.export free
.export realloc
global_base:
.byte #0,#0
mem_top:
.byte #0,#0
\ Function: get_block_ptr
get_block_ptr:
	push %r11
	mov %r13, %r11
	push %r1
\ Set
	mov WORD 4[%r11], %r0
\ Set
	mov #7, %r1
\ Sub
	sub %r1, %r0
\ Return
__bbcc_0000002f:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
\ Function: get_data_ptr
get_data_ptr:
	push %r11
	mov %r13, %r11
	push %r1
\ Set
	mov WORD 4[%r11], %r0
\ Set
	mov #7, %r1
\ Add
	add %r1, %r0
\ Return
__bbcc_00000030:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
\ Function: find_free_block
find_free_block:
	push %r11
	mov %r13, %r11
	push %r1
	push %r2
	push %r3
	push %r4
	push %r5
\ Set
	mov WORD [global_base], %r0
\ Set
	mov %r0, %r4
\ Label
__bbcc_00000000:
\ Set
	mov #0, %r3
\ JmpZero
	cmp #0, %r4
	jze [__bbcc_00000003]
\ Set
	mov #0, %r2
\ ReadAt
	mov BYTE 6[%r4], %r0
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_00000005]
\ ReadAt
	mov WORD [%r4], %r1
\ MoreEqualCmp
	mov 6[%r11], %r5
	mov #1, %r0
	cmp %r1, %r5
	jae [__bbcc_00000031]
	mov #0, %r0
__bbcc_00000031:
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_00000005]
\ Set
	mov #1, %r2
\ Label
__bbcc_00000005:
\ JmpNotZero
	cmp #0, %r2
	jnz [__bbcc_00000003]
\ Set
	mov #1, %r3
\ Label
__bbcc_00000003:
\ JmpZero
	cmp #0, %r3
	jze [__bbcc_00000001]
\ Set
	mov %r4, %r0
\ SetAt
	mov 4[%r11], %r1
	mov %r0, WORD [%r1]
\ ReadAt
	mov WORD 2[%r4], %r0
\ Set
\ Set
	mov %r0, %r4
\ Jmp
	jmp [__bbcc_00000000]
\ Label
__bbcc_00000001:
\ Return
	mov %r4, %r0
__bbcc_00000032:
	pop %r5
	pop %r4
	pop %r3
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
\ Function: request_space
request_space:
	push %r11
	mov %r13, %r11
	push %r1
	push %r2
	push %r3
\ JmpNotZero
	mov WORD [mem_top], %r0
	cmp #0, %r0
	jnz [__bbcc_00000006]
\ AddrOf
	lea WORD [_HIMEM], %r0
\ Set
\ Set
	mov %r0, WORD [mem_top]
\ Label
__bbcc_00000006:
\ Set
	mov WORD [mem_top], %r0
\ Set
	mov %r0, %r1
\ Set
	mov WORD [mem_top], %r0
\ Set
	mov WORD 6[%r11], %r2
\ Add
	add %r2, %r0
\ Set
	mov #7, %r2
\ Add
	add %r2, %r0
\ MoreEqualCmp
	mov #31744, %r3
	mov #1, %r2
	cmp %r0, %r3
	jge [__bbcc_00000033]
	mov #0, %r2
__bbcc_00000033:
\ JmpZero
	cmp #0, %r2
	jze [__bbcc_00000007]
\ Return
	mov #0, %r0
	jmp [__bbcc_00000034]
\ Label
__bbcc_00000007:
\ Set
	mov WORD [mem_top], %r0
\ Set
	mov WORD 6[%r11], %r2
\ Add
	add %r2, %r0
\ Set
	mov #7, %r2
\ Add
	add %r2, %r0
\ Set
\ Set
	mov %r0, WORD [mem_top]
\ JmpZero
	mov WORD 4[%r11], %r0
	cmp #0, %r0
	jze [__bbcc_00000008]
\ Set
	mov %r1, %r0
\ SetAt
	mov 4[%r11], %r2
	mov %r0, WORD 2[%r2]
\ Label
__bbcc_00000008:
\ Set
	mov WORD 4[%r11], %r0
\ SetAt
	mov %r0, WORD 4[%r1]
\ SetAt
	mov 6[%r11], %r0
	mov %r0, WORD [%r1]
\ Set
	mov #0, %r0
\ SetAt
	mov %r0, WORD 2[%r1]
\ Set
	mov #0, %r0
\ SetAt
	mov %r0, BYTE 6[%r1]
\ Return
	mov %r1, %r0
__bbcc_00000034:
	pop %r3
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
\ Function: split_block
split_block:
	push %r11
	mov %r13, %r11
	push %r1
	push %r2
\ Set
	mov WORD 4[%r11], %r0
\ Set
	mov #7, %r1
\ Add
	add %r1, %r0
\ Set
	mov WORD 6[%r11], %r1
\ Add
	add %r1, %r0
\ Set
\ Set
	mov %r0, %r2
\ ReadAt
	mov WORD 4[%r11], %r0
	mov WORD [%r0], %r0
\ Sub
	sub WORD 6[%r11], %r0
\ Sub
	sub #7, %r0
\ SetAt
	mov %r0, WORD [%r2]
\ ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 2[%r0], %r0
\ SetAt
	mov %r0, WORD 2[%r2]
\ Set
	mov WORD 4[%r11], %r0
\ SetAt
	mov %r0, WORD 4[%r2]
\ Set
	mov #1, %r0
\ SetAt
	mov %r0, BYTE 6[%r2]
\ SetAt
	mov 4[%r11], %r0
	mov 6[%r11], %r1
	mov %r1, WORD [%r0]
\ Set
	mov %r2, %r0
\ SetAt
	mov 4[%r11], %r1
	mov %r0, WORD 2[%r1]
\ ReadAt
	mov WORD 2[%r2], %r0
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_00000009]
\ ReadAt
	mov WORD 2[%r2], %r1
\ Set
	mov %r2, %r0
\ SetAt
	mov %r0, WORD 4[%r1]
\ Label
__bbcc_00000009:
\ Return
	mov #0, %r0
__bbcc_00000035:
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
\ Function: fusion
fusion:
	push %r11
	mov %r13, %r11
	push %r1
\ Set
	mov #0, %r1
\ ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 2[%r0], %r0
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_0000000b]
\ ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 2[%r0], %r0
\ ReadAt
	mov BYTE 6[%r0], %r0
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_0000000b]
\ Set
	mov #1, %r1
\ Label
__bbcc_0000000b:
\ JmpZero
	cmp #0, %r1
	jze [__bbcc_0000000c]
\ ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 2[%r0], %r0
\ ReadAt
	mov WORD [%r0], %r0
\ Add
	mov #7, %r1
	add %r0, %r1
\ ReadAt
	mov WORD 4[%r11], %r0
	mov WORD [%r0], %r0
\ Add
	add %r1, %r0
\ SetAt
	mov 4[%r11], %r1
	mov %r0, WORD [%r1]
\ ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 2[%r0], %r0
\ ReadAt
	mov WORD 2[%r0], %r0
\ SetAt
	mov 4[%r11], %r1
	mov %r0, WORD 2[%r1]
\ ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 2[%r0], %r0
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_0000000d]
\ ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 2[%r0], %r1
\ Set
	mov WORD 4[%r11], %r0
\ SetAt
	mov %r0, WORD 4[%r1]
\ Label
__bbcc_0000000d:
\ Label
__bbcc_0000000c:
\ Return
	mov WORD 4[%r11], %r0
__bbcc_00000036:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
\ Function: malloc
malloc:
	push %r11
	mov %r13, %r11
	sub #2, %r13
	push %r1
	push %r2
	push %r3
\ LessEqualCmp
	mov #0, %r1
	mov #1, %r0
	cmp 4[%r11], %r1
	jle [__bbcc_00000037]
	mov #0, %r0
__bbcc_00000037:
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_0000000e]
\ Return
	mov #0, %r0
	jmp [__bbcc_00000039]
\ Label
__bbcc_0000000e:
\ JmpNotZero
	mov WORD [global_base], %r0
	cmp #0, %r0
	jnz [__bbcc_0000000f]
\ Set
	mov #0, %r0
\ CallFunction
	mov 4[%r11], %r1
	push %r1
	push %r0
	call [request_space]
	add #4, %r13
\ Set
\ Set
	mov %r0, %r3
\ JmpNotZero
	cmp #0, %r3
	jnz [__bbcc_00000010]
\ Return
	mov #0, %r0
	jmp [__bbcc_00000039]
\ Label
__bbcc_00000010:
\ Set
	mov %r3, %r0
\ Set
	mov %r0, WORD [global_base]
\ Jmp
	jmp [__bbcc_00000011]
\ Label
__bbcc_0000000f:
\ Set
	mov WORD [global_base], %r0
\ Set
	mov %r0, WORD -2[%r11]
\ AddrOf
	lea WORD -2[%r11], %r0
\ Set
\ CallFunction
	mov 4[%r11], %r1
	push %r1
	push %r0
	call [find_free_block]
	add #4, %r13
\ Set
\ Set
	mov %r0, %r3
\ JmpNotZero
	cmp #0, %r3
	jnz [__bbcc_00000012]
\ Set
	mov WORD -2[%r11], %r0
\ CallFunction
	mov 4[%r11], %r1
	push %r1
	push %r0
	call [request_space]
	add #4, %r13
\ Set
\ Set
	mov %r0, %r3
\ JmpNotZero
	cmp #0, %r3
	jnz [__bbcc_00000013]
\ Return
	mov #0, %r0
	jmp [__bbcc_00000039]
\ Label
__bbcc_00000013:
\ Jmp
	jmp [__bbcc_00000014]
\ Label
__bbcc_00000012:
\ ReadAt
	mov WORD [%r3], %r0
\ Sub
	sub WORD 4[%r11], %r0
\ Set
	mov #4, %r1
\ Add
	mov #7, %r2
	add %r1, %r2
\ MoreEqualCmp
	mov #1, %r1
	cmp %r0, %r2
	jae [__bbcc_00000038]
	mov #0, %r1
__bbcc_00000038:
\ JmpZero
	cmp #0, %r1
	jze [__bbcc_00000015]
\ Set
	mov %r3, %r0
\ CallFunction
	mov 4[%r11], %r1
	push %r1
	push %r0
	call [split_block]
	add #4, %r13
\ Label
__bbcc_00000015:
\ Set
	mov #0, %r0
\ SetAt
	mov %r0, BYTE 6[%r3]
\ Label
__bbcc_00000014:
\ Label
__bbcc_00000011:
\ Set
	mov %r3, %r0
\ Set
	mov #7, %r1
\ Add
	add %r1, %r0
\ Return
__bbcc_00000039:
	pop %r3
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
\ Function: free
free:
	push %r11
	mov %r13, %r11
	push %r1
	push %r2
\ JmpNotZero
	mov WORD 4[%r11], %r0
	cmp #0, %r0
	jnz [__bbcc_00000016]
\ Return
	mov #0, %r0
	jmp [__bbcc_0000003a]
\ Label
__bbcc_00000016:
\ Set
	mov WORD 4[%r11], %r0
\ CallFunction
	push %r0
	call [get_block_ptr]
	add #2, %r13
\ Set
\ Set
	mov %r0, %r2
\ Set
	mov #1, %r0
\ SetAt
	mov %r0, BYTE 6[%r2]
\ Set
	mov #0, %r1
\ ReadAt
	mov WORD 4[%r2], %r0
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_00000018]
\ ReadAt
	mov WORD 4[%r2], %r0
\ ReadAt
	mov BYTE 6[%r0], %r0
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_00000018]
\ Set
	mov #1, %r1
\ Label
__bbcc_00000018:
\ JmpZero
	cmp #0, %r1
	jze [__bbcc_00000019]
\ ReadAt
	mov WORD 4[%r2], %r0
\ Set
\ CallFunction
	push %r0
	call [fusion]
	add #2, %r13
\ Set
\ Set
	mov %r0, %r2
\ Label
__bbcc_00000019:
\ ReadAt
	mov WORD 2[%r2], %r0
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_0000001a]
\ Set
	mov %r2, %r0
\ CallFunction
	push %r0
	call [fusion]
	add #2, %r13
\ Jmp
	jmp [__bbcc_0000001b]
\ Label
__bbcc_0000001a:
\ ReadAt
	mov WORD 4[%r2], %r0
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_0000001c]
\ ReadAt
	mov WORD 4[%r2], %r1
\ Set
	mov #0, %r0
\ SetAt
	mov %r0, WORD 2[%r1]
\ Jmp
	jmp [__bbcc_0000001d]
\ Label
__bbcc_0000001c:
\ Set
	mov #0, %r0
\ Set
	mov %r0, WORD [global_base]
\ Label
__bbcc_0000001d:
\ Set
	mov %r2, %r0
\ Set
	mov %r0, WORD [mem_top]
\ Label
__bbcc_0000001b:
\ Return
	mov #0, %r0
__bbcc_0000003a:
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
\ Function: copy_block
copy_block:
	push %r11
	mov %r13, %r11
	push %r1
	push %r2
	push %r3
	push %r4
	push %r5
\ Set
	mov WORD 4[%r11], %r0
\ CallFunction
	push %r0
	call [get_data_ptr]
	add #2, %r13
\ Set
\ Set
	mov %r0, %r4
\ Set
	mov WORD 6[%r11], %r0
\ CallFunction
	push %r0
	call [get_data_ptr]
	add #2, %r13
\ Set
\ Set
	mov %r0, %r5
\ Set
	mov #0, %r0
\ Set
	mov %r0, %r3
\ Label
__bbcc_0000001e:
\ Set
	mov #0, %r2
\ ReadAt
	mov WORD 4[%r11], %r0
	mov WORD [%r0], %r1
\ LessThanCmp
	mov #1, %r0
	cmp %r3, %r1
	jb [__bbcc_0000003b]
	mov #0, %r0
__bbcc_0000003b:
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_00000022]
\ ReadAt
	mov WORD 6[%r11], %r0
	mov WORD [%r0], %r1
\ LessThanCmp
	mov #1, %r0
	cmp %r3, %r1
	jb [__bbcc_0000003c]
	mov #0, %r0
__bbcc_0000003c:
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_00000022]
\ Set
	mov #1, %r2
\ Label
__bbcc_00000022:
\ JmpZero
	cmp #0, %r2
	jze [__bbcc_00000020]
\ ReadAt
	mov %r4, %r0
	add %r3, %r0
	mov BYTE [%r0], %r0
\ SetAt
	mov %r5, %r1
	add %r3, %r1
	mov %r0, BYTE [%r1]
\ Label
__bbcc_0000001f:
\ Add
	mov #1, %r0
	add %r3, %r0
\ Set
	mov %r0, %r3
\ Jmp
	jmp [__bbcc_0000001e]
\ Label
__bbcc_00000020:
\ Return
	mov #0, %r0
__bbcc_0000003d:
	pop %r5
	pop %r4
	pop %r3
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
\ Function: realloc
realloc:
	push %r11
	mov %r13, %r11
	push %r1
	push %r2
	push %r3
	push %r4
\ JmpNotZero
	mov WORD 4[%r11], %r0
	cmp #0, %r0
	jnz [__bbcc_00000023]
\ CallFunction
	mov 6[%r11], %r0
	push %r0
	call [malloc]
	add #2, %r13
\ Return
	jmp [__bbcc_00000042]
\ Label
__bbcc_00000023:
\ Set
	mov WORD 4[%r11], %r0
\ CallFunction
	push %r0
	call [get_block_ptr]
	add #2, %r13
\ Set
\ Set
	mov %r0, %r1
\ ReadAt
	mov WORD [%r1], %r2
\ MoreEqualCmp
	mov 6[%r11], %r3
	mov #1, %r0
	cmp %r2, %r3
	jae [__bbcc_0000003e]
	mov #0, %r0
__bbcc_0000003e:
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_00000024]
\ ReadAt
	mov WORD [%r1], %r0
\ Sub
	sub WORD 6[%r11], %r0
\ Set
	mov #4, %r2
\ Add
	mov #7, %r3
	add %r2, %r3
\ MoreEqualCmp
	mov #1, %r2
	cmp %r0, %r3
	jae [__bbcc_0000003f]
	mov #0, %r2
__bbcc_0000003f:
\ JmpZero
	cmp #0, %r2
	jze [__bbcc_00000025]
\ Set
	mov %r1, %r0
\ CallFunction
	mov 6[%r11], %r2
	push %r2
	push %r0
	call [split_block]
	add #4, %r13
\ Label
__bbcc_00000025:
\ Jmp
	jmp [__bbcc_00000026]
\ Label
__bbcc_00000024:
\ Set
	mov #0, %r3
\ Set
	mov #0, %r2
\ ReadAt
	mov WORD 2[%r1], %r0
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_0000002a]
\ ReadAt
	mov WORD 2[%r1], %r0
\ ReadAt
	mov BYTE 6[%r0], %r0
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_0000002a]
\ Set
	mov #1, %r2
\ Label
__bbcc_0000002a:
\ JmpZero
	cmp #0, %r2
	jze [__bbcc_00000028]
\ ReadAt
	mov WORD [%r1], %r0
\ Add
	add #7, %r0
\ ReadAt
	mov WORD 2[%r1], %r2
\ ReadAt
	mov WORD [%r2], %r2
\ Add
	add %r2, %r0
\ MoreEqualCmp
	mov 6[%r11], %r4
	mov #1, %r2
	cmp %r0, %r4
	jae [__bbcc_00000040]
	mov #0, %r2
__bbcc_00000040:
\ JmpZero
	cmp #0, %r2
	jze [__bbcc_00000028]
\ Set
	mov #1, %r3
\ Label
__bbcc_00000028:
\ JmpZero
	cmp #0, %r3
	jze [__bbcc_0000002b]
\ Set
	mov %r1, %r0
\ CallFunction
	push %r0
	call [fusion]
	add #2, %r13
\ ReadAt
	mov WORD [%r1], %r0
\ Sub
	sub WORD 6[%r11], %r0
\ Set
	mov #4, %r2
\ Add
	mov #7, %r3
	add %r2, %r3
\ MoreEqualCmp
	mov #1, %r2
	cmp %r0, %r3
	jae [__bbcc_00000041]
	mov #0, %r2
__bbcc_00000041:
\ JmpZero
	cmp #0, %r2
	jze [__bbcc_0000002c]
\ Set
	mov %r1, %r0
\ CallFunction
	mov 6[%r11], %r2
	push %r2
	push %r0
	call [split_block]
	add #4, %r13
\ Label
__bbcc_0000002c:
\ Jmp
	jmp [__bbcc_0000002d]
\ Label
__bbcc_0000002b:
\ CallFunction
	mov 6[%r11], %r0
	push %r0
	call [malloc]
	add #2, %r13
\ Set
\ Set
	mov %r0, %r2
\ JmpNotZero
	cmp #0, %r2
	jnz [__bbcc_0000002e]
\ Return
	mov #0, %r0
	jmp [__bbcc_00000042]
\ Label
__bbcc_0000002e:
\ Set
	mov %r2, %r0
\ CallFunction
	push %r0
	call [get_block_ptr]
	add #2, %r13
\ Set
\ Set
\ Set
\ Set
\ CallFunction
	push %r0
	push %r1
	call [copy_block]
	add #4, %r13
\ Set
	mov WORD 4[%r11], %r0
\ CallFunction
	push %r0
	call [free]
	add #2, %r13
\ Return
	mov %r2, %r0
	jmp [__bbcc_00000042]
\ Label
__bbcc_0000002d:
\ Label
__bbcc_00000026:
\ Return
	mov WORD 4[%r11], %r0
__bbcc_00000042:
	pop %r4
	pop %r3
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret