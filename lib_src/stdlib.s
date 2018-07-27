.import _HIMEM
.export global_base
.export mem_top
.export get_block_ptr
.export find_free_block
.export request_space
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
	push %r2
\ Set
	mov WORD 4[%r11], %r2
\ Set
	mov #5, %r1
\ Add
	mov %r1, %r0
	add %r2, %r0
\ Return
__bbcc_0000001e:
	pop %r2
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
	push %r6
\ Set
	mov WORD [global_base], %r0
\ Set
	mov %r0, %r4
\ Label
__bbcc_00000000:
\ Set
	mov #1, %r5
\ JmpZero
	cmp #0, %r4
	jze [__bbcc_00000002]
\ Set
	mov #1, %r3
\ Set
	mov #1, %r2
\ Add
	mov %r4, %r0
	add #4, %r0
\ ReadAt
	mov BYTE [%r0], %r0
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_00000006]
\ Add
	mov %r4, %r0
	add #0, %r0
\ ReadAt
	mov WORD [%r0], %r1
\ MoreEqualCmp
	mov 6[%r11], %r6
	mov #1, %r0
	cmp %r1, %r6
	jae [__bbcc_0000001f]
	mov #0, %r0
__bbcc_0000001f:
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_00000006]
\ Jmp
	jmp [__bbcc_00000007]
\ Label
__bbcc_00000006:
\ Set
	mov #0, %r2
\ Label
__bbcc_00000007:
\ JmpNotZero
	cmp #0, %r2
	jnz [__bbcc_00000004]
\ Jmp
	jmp [__bbcc_00000005]
\ Label
__bbcc_00000004:
\ Set
	mov #0, %r3
\ Label
__bbcc_00000005:
\ JmpZero
	cmp #0, %r3
	jze [__bbcc_00000002]
\ Jmp
	jmp [__bbcc_00000003]
\ Label
__bbcc_00000002:
\ Set
	mov #0, %r5
\ Label
__bbcc_00000003:
\ JmpZero
	cmp #0, %r5
	jze [__bbcc_00000001]
\ Set
	mov %r4, %r0
\ SetAt
	mov 4[%r11], %r1
	mov %r0, WORD [%r1]
\ Add
	mov %r4, %r0
	add #2, %r0
\ ReadAt
	mov WORD [%r0], %r0
\ Set
\ Set
	mov %r0, %r4
\ Jmp
	jmp [__bbcc_00000000]
\ Label
__bbcc_00000001:
\ Return
	mov %r4, %r0
__bbcc_00000020:
	pop %r6
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
\ Set
	mov #1, %r0
\ JmpNotZero
	mov [mem_top], %r1
	cmp #0, %r1
	jnz [__bbcc_00000008]
\ Jmp
	jmp [__bbcc_00000009]
\ Label
__bbcc_00000008:
\ Set
	mov #0, %r0
\ Label
__bbcc_00000009:
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_0000000a]
\ AddrOf
	lea WORD [_HIMEM], %r0
\ Set
\ Set
	mov %r0, WORD [mem_top]
\ Label
__bbcc_0000000a:
\ Set
	mov WORD [mem_top], %r0
\ Set
	mov %r0, %r2
\ Add
	mov #5, %r1
	add WORD 6[%r11], %r1
\ Add
	mov %r1, %r0
	add WORD [mem_top], %r0
\ Set
	mov %r0, WORD [mem_top]
\ JmpZero
	mov 4[%r11], %r0
	cmp #0, %r0
	jze [__bbcc_0000000b]
\ Add
	mov WORD 4[%r11], %r1
	add #2, %r1
\ Set
	mov %r2, %r0
\ SetAt
	mov %r0, WORD [%r1]
\ Label
__bbcc_0000000b:
\ Add
	mov %r2, %r0
	add #0, %r0
\ SetAt
	mov 6[%r11], %r1
	mov %r1, WORD [%r0]
\ Add
	mov %r2, %r1
	add #2, %r1
\ Set
	mov #0, %r0
\ SetAt
	mov %r0, WORD [%r1]
\ Add
	mov %r2, %r1
	add #4, %r1
\ Set
	mov #0, %r0
\ SetAt
	mov %r0, BYTE [%r1]
\ Return
	mov %r2, %r0
__bbcc_00000021:
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
\ Function: malloc
malloc:
	push %r11
	mov %r13, %r11
	push %r1
	push %r2
\ LessEqualCmp
	mov #0, %r1
	mov #1, %r0
	cmp 4[%r11], %r1
	jle [__bbcc_00000022]
	mov #0, %r0
__bbcc_00000022:
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_0000000c]
\ Return
	mov #0, %r0
	jmp [__bbcc_00000023]
\ Label
__bbcc_0000000c:
\ Set
	mov #1, %r0
\ JmpNotZero
	mov [global_base], %r1
	cmp #0, %r1
	jnz [__bbcc_0000000d]
\ Jmp
	jmp [__bbcc_0000000e]
\ Label
__bbcc_0000000d:
\ Set
	mov #0, %r0
\ Label
__bbcc_0000000e:
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_0000000f]
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
	mov %r0, %r2
\ Set
	mov #1, %r0
\ JmpNotZero
	cmp #0, %r2
	jnz [__bbcc_00000010]
\ Jmp
	jmp [__bbcc_00000011]
\ Label
__bbcc_00000010:
\ Set
	mov #0, %r0
\ Label
__bbcc_00000011:
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_00000012]
\ Return
	mov #0, %r0
	jmp [__bbcc_00000023]
\ Label
__bbcc_00000012:
\ Set
	mov %r2, %r0
\ Set
	mov %r0, WORD [global_base]
\ Jmp
	jmp [__bbcc_00000013]
\ Label
__bbcc_0000000f:
\ Set
	mov WORD [global_base], %r0
\ Set
	mov %r0, WORD 2[%r11]
\ AddrOf
	lea WORD 2[%r11], %r0
\ Set
\ CallFunction
	mov 4[%r11], %r1
	push %r1
	push %r0
	call [find_free_block]
	add #4, %r13
\ Set
\ Set
	mov %r0, %r2
\ Set
	mov #1, %r0
\ JmpNotZero
	cmp #0, %r2
	jnz [__bbcc_00000014]
\ Jmp
	jmp [__bbcc_00000015]
\ Label
__bbcc_00000014:
\ Set
	mov #0, %r0
\ Label
__bbcc_00000015:
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_00000016]
\ Set
	mov WORD 2[%r11], %r0
\ CallFunction
	mov 4[%r11], %r1
	push %r1
	push %r0
	call [request_space]
	add #4, %r13
\ Set
\ Set
	mov %r0, %r2
\ Set
	mov #1, %r0
\ JmpNotZero
	cmp #0, %r2
	jnz [__bbcc_00000017]
\ Jmp
	jmp [__bbcc_00000018]
\ Label
__bbcc_00000017:
\ Set
	mov #0, %r0
\ Label
__bbcc_00000018:
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_00000019]
\ Return
	mov #0, %r0
	jmp [__bbcc_00000023]
\ Label
__bbcc_00000019:
\ Jmp
	jmp [__bbcc_0000001a]
\ Label
__bbcc_00000016:
\ Add
	mov %r2, %r1
	add #4, %r1
\ Set
	mov #0, %r0
\ SetAt
	mov %r0, BYTE [%r1]
\ Label
__bbcc_0000001a:
\ Label
__bbcc_00000013:
\ Set
\ Set
	mov #5, %r1
\ Add
	mov %r1, %r0
	add %r2, %r0
\ Return
__bbcc_00000023:
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
\ Set
	mov #1, %r0
\ JmpNotZero
	mov 4[%r11], %r1
	cmp #0, %r1
	jnz [__bbcc_0000001b]
\ Jmp
	jmp [__bbcc_0000001c]
\ Label
__bbcc_0000001b:
\ Set
	mov #0, %r0
\ Label
__bbcc_0000001c:
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_0000001d]
\ Return
	mov #0, %r0
	jmp [__bbcc_00000024]
\ Label
__bbcc_0000001d:
\ Set
	mov WORD 4[%r11], %r0
\ CallFunction
	push %r0
	call [get_block_ptr]
	add #2, %r13
\ Set
\ Set
\ Add
	mov %r0, %r1
	add #4, %r1
\ Set
	mov #1, %r0
\ SetAt
	mov %r0, BYTE [%r1]
\ Return
	mov #0, %r0
__bbcc_00000024:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret