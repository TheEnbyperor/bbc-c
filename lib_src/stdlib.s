.import _HIMEM
.export malloc
.export free
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
__bbcc_0000001d:
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
	mov %r0, %r1
\ Label
__bbcc_00000000:
\ Set
	mov #1, %r4
\ JmpZero
	cmp #0, %r1
	jze [__bbcc_00000002]
\ JmpZero
	cmp #0, %r1
	jze [__bbcc_00000002]
\ Set
	mov #1, %r3
\ Add
	mov %r1, %r0
	add #6, %r0
\ ReadAt
	mov BYTE [%r0], %r0
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_00000004]
\ Add
	mov %r1, %r0
	add #6, %r0
\ ReadAt
	mov BYTE [%r0], %r0
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_00000004]
\ Add
	mov %r1, %r0
	add #0, %r0
\ ReadAt
	mov WORD [%r0], %r2
\ MoreEqualCmp
	mov 6[%r11], %r5
	mov #1, %r0
	cmp %r2, %r5
	jae [__bbcc_0000001e]
	mov #0, %r0
__bbcc_0000001e:
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_00000004]
\ Jmp
	jmp [__bbcc_00000005]
\ Label
__bbcc_00000004:
\ Set
	mov #0, %r3
\ Label
__bbcc_00000005:
\ JmpNotZero
	cmp #0, %r3
	jnz [__bbcc_00000002]
\ Jmp
	jmp [__bbcc_00000003]
\ Label
__bbcc_00000002:
\ Set
	mov #0, %r4
\ Label
__bbcc_00000003:
\ JmpZero
	cmp #0, %r4
	jze [__bbcc_00000001]
\ Set
	mov %r1, %r0
\ SetAt
	mov 4[%r11], %r2
	mov %r0, WORD [%r2]
\ Add
	add #2, %r1
\ ReadAt
	mov WORD [%r1], %r0
\ Set
\ Set
	mov %r0, %r1
\ Jmp
	jmp [__bbcc_00000000]
\ Label
__bbcc_00000001:
\ Return
	mov %r1, %r0
__bbcc_0000001f:
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
	add %r0, %r2
\ Set
	mov #7, %r0
\ Add
	add %r2, %r0
\ MoreEqualCmp
	mov #31744, %r3
	mov #1, %r2
	cmp %r0, %r3
	jge [__bbcc_00000020]
	mov #0, %r2
__bbcc_00000020:
\ JmpZero
	cmp #0, %r2
	jze [__bbcc_00000007]
\ Return
	mov #0, %r0
	jmp [__bbcc_00000021]
\ Label
__bbcc_00000007:
\ Set
	mov WORD [mem_top], %r0
\ Set
	mov WORD 6[%r11], %r2
\ Add
	add %r0, %r2
\ Set
	mov #7, %r0
\ Add
	add %r2, %r0
\ Set
\ Set
	mov %r0, WORD [mem_top]
\ JmpZero
	mov WORD 4[%r11], %r0
	cmp #0, %r0
	jze [__bbcc_00000008]
\ Add
	mov WORD 4[%r11], %r2
	add #2, %r2
\ Set
	mov %r1, %r0
\ SetAt
	mov %r0, WORD [%r2]
\ Label
__bbcc_00000008:
\ Add
	mov %r1, %r0
	add #0, %r0
\ SetAt
	mov 6[%r11], %r2
	mov %r2, WORD [%r0]
\ Add
	mov %r1, %r0
	add #2, %r0
\ Set
	mov #0, %r2
\ SetAt
	mov %r2, WORD [%r0]
\ Add
	mov %r1, %r0
	add #6, %r0
\ Set
	mov #0, %r2
\ SetAt
	mov %r2, BYTE [%r0]
\ Return
	mov %r1, %r0
__bbcc_00000021:
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
	add %r0, %r1
\ Set
	mov WORD 6[%r11], %r0
\ Add
	add %r1, %r0
\ Set
\ Set
	mov %r0, %r1
\ Add
	mov WORD 4[%r11], %r0
	add #0, %r0
\ ReadAt
	mov WORD [%r0], %r2
\ Sub
	sub WORD 6[%r11], %r2
\ Sub
	sub #7, %r2
\ Add
	mov %r1, %r0
	add #0, %r0
\ SetAt
	mov %r2, WORD [%r0]
\ Add
	mov WORD 4[%r11], %r0
	add #2, %r0
\ ReadAt
	mov WORD [%r0], %r2
\ Add
	mov %r1, %r0
	add #2, %r0
\ SetAt
	mov %r2, WORD [%r0]
\ Add
	mov %r1, %r0
	add #6, %r0
\ Set
	mov #1, %r2
\ SetAt
	mov %r2, BYTE [%r0]
\ Add
	mov WORD 4[%r11], %r0
	add #0, %r0
\ SetAt
	mov 6[%r11], %r2
	mov %r2, WORD [%r0]
\ Add
	mov WORD 4[%r11], %r2
	add #2, %r2
\ Set
	mov %r1, %r0
\ SetAt
	mov %r0, WORD [%r2]
\ Return
	mov #0, %r0
__bbcc_00000022:
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
	push %r2
\ Set
	mov #1, %r1
\ Add
	mov WORD 4[%r11], %r0
	add #2, %r0
\ ReadAt
	mov WORD [%r0], %r0
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_00000009]
\ Add
	mov WORD 4[%r11], %r0
	add #2, %r0
\ ReadAt
	mov WORD [%r0], %r0
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_00000009]
\ Add
	mov WORD 4[%r11], %r0
	add #2, %r0
\ ReadAt
	mov WORD [%r0], %r0
\ Add
	add #6, %r0
\ ReadAt
	mov BYTE [%r0], %r0
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_00000009]
\ Jmp
	jmp [__bbcc_0000000a]
\ Label
__bbcc_00000009:
\ Set
	mov #0, %r1
\ Label
__bbcc_0000000a:
\ JmpZero
	cmp #0, %r1
	jze [__bbcc_0000000b]
\ Add
	mov WORD 4[%r11], %r2
	add #0, %r2
\ Add
	mov WORD 4[%r11], %r0
	add #2, %r0
\ ReadAt
	mov WORD [%r0], %r0
\ Add
	add #0, %r0
\ ReadAt
	mov WORD [%r0], %r0
\ Add
	add #7, %r0
\ ReadAt
	mov WORD [%r2], %r1
\ Add
	add %r1, %r0
\ SetAt
	mov %r0, WORD [%r2]
\ Add
	mov WORD 4[%r11], %r0
	add #2, %r0
\ ReadAt
	mov WORD [%r0], %r0
\ Add
	add #2, %r0
\ ReadAt
	mov WORD [%r0], %r1
\ Add
	mov WORD 4[%r11], %r0
	add #2, %r0
\ SetAt
	mov %r1, WORD [%r0]
\ Add
	mov WORD 4[%r11], %r0
	add #2, %r0
\ ReadAt
	mov WORD [%r0], %r0
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_0000000c]
\ Add
	mov WORD 4[%r11], %r0
	add #2, %r0
\ ReadAt
	mov WORD [%r0], %r0
\ Add
	add #4, %r0
\ Set
	mov WORD 4[%r11], %r1
\ SetAt
	mov %r1, WORD [%r0]
\ Label
__bbcc_0000000c:
\ Label
__bbcc_0000000b:
\ Return
	mov WORD 4[%r11], %r0
__bbcc_00000023:
	pop %r2
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
	jle [__bbcc_00000024]
	mov #0, %r0
__bbcc_00000024:
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_0000000d]
\ Return
	mov #0, %r0
	jmp [__bbcc_00000026]
\ Label
__bbcc_0000000d:
\ JmpNotZero
	mov WORD [global_base], %r0
	cmp #0, %r0
	jnz [__bbcc_0000000e]
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
	mov %r0, %r1
\ JmpNotZero
	cmp #0, %r1
	jnz [__bbcc_0000000f]
\ Return
	mov #0, %r0
	jmp [__bbcc_00000026]
\ Label
__bbcc_0000000f:
\ Set
	mov %r1, %r0
\ Set
	mov %r0, WORD [global_base]
\ Jmp
	jmp [__bbcc_00000010]
\ Label
__bbcc_0000000e:
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
	mov %r0, %r1
\ JmpNotZero
	cmp #0, %r1
	jnz [__bbcc_00000011]
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
	mov %r0, %r1
\ JmpNotZero
	cmp #0, %r1
	jnz [__bbcc_00000012]
\ Return
	mov #0, %r0
	jmp [__bbcc_00000026]
\ Label
__bbcc_00000012:
\ Jmp
	jmp [__bbcc_00000013]
\ Label
__bbcc_00000011:
\ Add
	mov %r1, %r0
	add #0, %r0
\ ReadAt
	mov WORD [%r0], %r2
\ Sub
	sub WORD 4[%r11], %r2
\ Set
	mov #4, %r0
\ Add
	add #7, %r0
\ MoreEqualCmp
	mov #1, %r3
	cmp %r2, %r0
	jae [__bbcc_00000025]
	mov #0, %r3
__bbcc_00000025:
\ JmpZero
	cmp #0, %r3
	jze [__bbcc_00000014]
\ Set
	mov %r1, %r0
\ CallFunction
	mov 4[%r11], %r2
	push %r2
	push %r0
	call [split_block]
	add #4, %r13
\ Label
__bbcc_00000014:
\ Add
	mov %r1, %r0
	add #6, %r0
\ Set
	mov #0, %r2
\ SetAt
	mov %r2, BYTE [%r0]
\ Label
__bbcc_00000013:
\ Label
__bbcc_00000010:
\ Set
\ Set
	mov #7, %r0
\ Add
	add %r1, %r0
\ Return
__bbcc_00000026:
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
	jnz [__bbcc_00000015]
\ Return
	mov #0, %r0
	jmp [__bbcc_00000027]
\ Label
__bbcc_00000015:
\ Set
	mov WORD 4[%r11], %r0
\ CallFunction
	push %r0
	call [get_block_ptr]
	add #2, %r13
\ Set
\ Set
	mov %r0, %r1
\ Add
	mov %r1, %r0
	add #6, %r0
\ Set
	mov #1, %r2
\ SetAt
	mov %r2, BYTE [%r0]
\ Set
	mov #1, %r2
\ Add
	mov %r1, %r0
	add #4, %r0
\ ReadAt
	mov WORD [%r0], %r0
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_00000016]
\ Add
	mov %r1, %r0
	add #4, %r0
\ ReadAt
	mov WORD [%r0], %r0
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_00000016]
\ Add
	mov %r1, %r0
	add #4, %r0
\ ReadAt
	mov WORD [%r0], %r0
\ Add
	add #6, %r0
\ ReadAt
	mov BYTE [%r0], %r0
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_00000016]
\ Jmp
	jmp [__bbcc_00000017]
\ Label
__bbcc_00000016:
\ Set
	mov #0, %r2
\ Label
__bbcc_00000017:
\ JmpZero
	cmp #0, %r2
	jze [__bbcc_00000018]
\ Add
	add #4, %r1
\ ReadAt
	mov WORD [%r1], %r0
\ Set
\ CallFunction
	push %r0
	call [fusion]
	add #2, %r13
\ Set
\ Set
	mov %r0, %r1
\ Label
__bbcc_00000018:
\ Add
	mov %r1, %r0
	add #2, %r0
\ ReadAt
	mov WORD [%r0], %r0
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_00000019]
\ Set
	mov %r1, %r0
\ CallFunction
	push %r0
	call [fusion]
	add #2, %r13
\ Jmp
	jmp [__bbcc_0000001a]
\ Label
__bbcc_00000019:
\ Add
	mov %r1, %r0
	add #4, %r0
\ ReadAt
	mov WORD [%r0], %r0
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_0000001b]
\ Add
	mov %r1, %r0
	add #4, %r0
\ ReadAt
	mov WORD [%r0], %r0
\ Add
	add #2, %r0
\ Set
	mov #0, %r2
\ SetAt
	mov %r2, WORD [%r0]
\ Jmp
	jmp [__bbcc_0000001c]
\ Label
__bbcc_0000001b:
\ Set
	mov #0, %r0
\ Set
	mov %r0, WORD [global_base]
\ Label
__bbcc_0000001c:
\ Set
	mov %r1, %r0
\ Set
	mov %r0, WORD [mem_top]
\ Label
__bbcc_0000001a:
\ Return
	mov #0, %r0
__bbcc_00000027:
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret