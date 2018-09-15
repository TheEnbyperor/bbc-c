.import isdigit
.import _HIMEM
.export malloc
.export free
.export realloc
.export atoi
global_base:
.byte #0,#0,#0,#0
mem_top:
.byte #0,#0,#0,#0
// Function: get_block_ptr
get_block_ptr:
	push %r12
	mov %r14, %r12
	push %r1
// Set
	mov DWORD 8[%r12], %r0
// Set
	mov #13, %r1
// Sub
	sub %r1, %r0
// Return
__bbcc_0000002b:
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: get_data_ptr
get_data_ptr:
	push %r12
	mov %r14, %r12
	push %r1
// Set
	mov DWORD 8[%r12], %r0
// Set
	mov #13, %r1
// Add
	add %r1, %r0
// Return
__bbcc_0000002c:
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: find_free_block
find_free_block:
	push %r12
	mov %r14, %r12
	push %r1
	push %r2
	push %r3
	push %r4
// Set
	mov DWORD [global_base], %r0
// Set
	mov %r0, %r3
// Label
__bbcc_00000000:
// Set
	mov #0, %r2
// JmpZero
	cmp #0, %r3
	jze [__bbcc_00000002]
// Set
	mov #0, %r1
// ReadAt
	mov BYTE 12[%r3], %r0
// JmpZero
	cmp #0, %r0
	jze [__bbcc_00000003]
// ReadAt
	mov DWORD [%r3], %r0
// LessThanJmp
	mov 12[%r12], %r4
	cmp %r0, %r4
	jb [__bbcc_00000003]
// Set
	mov #1, %r1
// Label
__bbcc_00000003:
// JmpNotZero
	cmp #0, %r1
	jnz [__bbcc_00000002]
// Set
	mov #1, %r2
// Label
__bbcc_00000002:
// JmpZero
	cmp #0, %r2
	jze [__bbcc_00000001]
// Set
	mov %r3, %r0
// SetAt
	mov 8[%r12], %r1
	mov %r0, DWORD [%r1]
// ReadAt
	mov DWORD 4[%r3], %r0
// Set
// Set
	mov %r0, %r3
// Jmp
	jmp [__bbcc_00000000]
// Label
__bbcc_00000001:
// Return
	mov %r3, %r0
__bbcc_0000002d:
	pop %r4
	pop %r3
	pop %r2
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: request_space
request_space:
	push %r12
	mov %r14, %r12
	push %r1
	push %r2
// JmpNotZero
	mov DWORD [mem_top], %r0
	cmp #0, %r0
	jnz [__bbcc_00000004]
// AddrOf
	lea DWORD [_HIMEM], %r0
// Set
// Set
	mov %r0, DWORD [mem_top]
// Label
__bbcc_00000004:
// Set
	mov DWORD [mem_top], %r0
// Set
	mov %r0, %r1
// Set
	mov DWORD [mem_top], %r0
// Set
	mov DWORD 12[%r12], %r2
// Add
	add %r2, %r0
// Set
	mov #13, %r2
// Add
	add %r2, %r0
// LessThanJmp
	mov #262143, %r2
	cmp %r0, %r2
	jl [__bbcc_00000005]
// Return
	mov #0, %r0
	jmp [__bbcc_0000002e]
// Label
__bbcc_00000005:
// Set
	mov DWORD [mem_top], %r0
// Set
	mov DWORD 12[%r12], %r2
// Add
	add %r2, %r0
// Set
	mov #13, %r2
// Add
	add %r2, %r0
// Set
// Set
	mov %r0, DWORD [mem_top]
// JmpZero
	mov DWORD 8[%r12], %r0
	cmp #0, %r0
	jze [__bbcc_00000006]
// Set
	mov %r1, %r0
// SetAt
	mov 8[%r12], %r2
	mov %r0, DWORD 4[%r2]
// Label
__bbcc_00000006:
// Set
	mov DWORD 8[%r12], %r0
// SetAt
	mov %r0, DWORD 8[%r1]
// SetAt
	mov 12[%r12], %r0
	mov %r0, DWORD [%r1]
// Set
	mov #0, %r0
// SetAt
	mov %r0, DWORD 4[%r1]
// Set
	mov #0, %r0
// SetAt
	mov %r0, BYTE 12[%r1]
// Return
	mov %r1, %r0
__bbcc_0000002e:
	pop %r2
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: split_block
split_block:
	push %r12
	mov %r14, %r12
	push %r1
	push %r2
// Set
	mov DWORD 8[%r12], %r0
// Set
	mov #13, %r1
// Add
	add %r1, %r0
// Set
	mov DWORD 12[%r12], %r1
// Add
	add %r1, %r0
// Set
// Set
	mov %r0, %r2
// ReadAt
	mov DWORD 8[%r12], %r0
	mov DWORD [%r0], %r0
// Sub
	sub DWORD 12[%r12], %r0
// Sub
	sub #13, %r0
// SetAt
	mov %r0, DWORD [%r2]
// ReadAt
	mov DWORD 8[%r12], %r0
	mov DWORD 4[%r0], %r0
// SetAt
	mov %r0, DWORD 4[%r2]
// Set
	mov DWORD 8[%r12], %r0
// SetAt
	mov %r0, DWORD 8[%r2]
// Set
	mov #1, %r0
// SetAt
	mov %r0, BYTE 12[%r2]
// SetAt
	mov 8[%r12], %r0
	mov 12[%r12], %r1
	mov %r1, DWORD [%r0]
// Set
	mov %r2, %r0
// SetAt
	mov 8[%r12], %r1
	mov %r0, DWORD 4[%r1]
// ReadAt
	mov DWORD 4[%r2], %r0
// JmpZero
	cmp #0, %r0
	jze [__bbcc_00000007]
// ReadAt
	mov DWORD 4[%r2], %r1
// Set
	mov %r2, %r0
// SetAt
	mov %r0, DWORD 8[%r1]
// Label
__bbcc_00000007:
// Return
	mov #0, %r0
__bbcc_0000002f:
	pop %r2
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: fusion
fusion:
	push %r12
	mov %r14, %r12
	push %r1
// Set
	mov #0, %r1
// ReadAt
	mov DWORD 8[%r12], %r0
	mov DWORD 4[%r0], %r0
// JmpZero
	cmp #0, %r0
	jze [__bbcc_00000009]
// ReadAt
	mov DWORD 8[%r12], %r0
	mov DWORD 4[%r0], %r0
// ReadAt
	mov BYTE 12[%r0], %r0
// JmpZero
	cmp #0, %r0
	jze [__bbcc_00000009]
// Set
	mov #1, %r1
// Label
__bbcc_00000009:
// JmpZero
	cmp #0, %r1
	jze [__bbcc_00000008]
// ReadAt
	mov DWORD 8[%r12], %r0
	mov DWORD 4[%r0], %r0
// ReadAt
	mov DWORD [%r0], %r0
// Add
	mov #13, %r1
	add %r0, %r1
// ReadAt
	mov DWORD 8[%r12], %r0
	mov DWORD [%r0], %r0
// Add
	add %r1, %r0
// SetAt
	mov 8[%r12], %r1
	mov %r0, DWORD [%r1]
// ReadAt
	mov DWORD 8[%r12], %r0
	mov DWORD 4[%r0], %r0
// ReadAt
	mov DWORD 4[%r0], %r0
// SetAt
	mov 8[%r12], %r1
	mov %r0, DWORD 4[%r1]
// ReadAt
	mov DWORD 8[%r12], %r0
	mov DWORD 4[%r0], %r0
// JmpZero
	cmp #0, %r0
	jze [__bbcc_0000000a]
// ReadAt
	mov DWORD 8[%r12], %r0
	mov DWORD 4[%r0], %r1
// Set
	mov DWORD 8[%r12], %r0
// SetAt
	mov %r0, DWORD 8[%r1]
// Label
__bbcc_0000000a:
// Label
__bbcc_00000008:
// Return
	mov DWORD 8[%r12], %r0
__bbcc_00000030:
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: malloc
malloc:
	push %r12
	mov %r14, %r12
	sub #4, %r14
	push %r1
	push %r2
	push %r3
// MoreThanJmp
	mov #0, %r0
	cmp 8[%r12], %r0
	jg [__bbcc_0000000b]
// Return
	mov #0, %r0
	jmp [__bbcc_00000031]
// Label
__bbcc_0000000b:
// JmpNotZero
	mov DWORD [global_base], %r0
	cmp #0, %r0
	jnz [__bbcc_0000000c]
// Set
	mov #0, %r0
// CallFunction
	mov DWORD 8[%r12], %r1
	push %r1
	push %r0
	call [request_space]
	add #8, %r14
// Set
// Set
	mov %r0, %r3
// JmpNotZero
	cmp #0, %r3
	jnz [__bbcc_0000000d]
// Return
	mov #0, %r0
	jmp [__bbcc_00000031]
// Label
__bbcc_0000000d:
// Set
	mov %r3, %r0
// Set
	mov %r0, DWORD [global_base]
// Jmp
	jmp [__bbcc_0000000e]
// Label
__bbcc_0000000c:
// Set
	mov DWORD [global_base], %r0
// Set
	mov %r0, DWORD -4[%r12]
// AddrOf
	lea DWORD -4[%r12], %r0
// Set
// CallFunction
	mov DWORD 8[%r12], %r1
	push %r1
	push %r0
	call [find_free_block]
	add #8, %r14
// Set
// Set
	mov %r0, %r3
// JmpNotZero
	cmp #0, %r3
	jnz [__bbcc_0000000f]
// Set
	mov DWORD -4[%r12], %r0
// CallFunction
	mov DWORD 8[%r12], %r1
	push %r1
	push %r0
	call [request_space]
	add #8, %r14
// Set
// Set
	mov %r0, %r3
// JmpNotZero
	cmp #0, %r3
	jnz [__bbcc_00000010]
// Return
	mov #0, %r0
	jmp [__bbcc_00000031]
// Label
__bbcc_00000010:
// Jmp
	jmp [__bbcc_00000011]
// Label
__bbcc_0000000f:
// ReadAt
	mov DWORD [%r3], %r0
// Sub
	sub DWORD 8[%r12], %r0
// Set
	mov #4, %r2
// Add
	mov #13, %r1
	add %r2, %r1
// LessThanJmp
	cmp %r0, %r1
	jb [__bbcc_00000012]
// Set
	mov %r3, %r0
// CallFunction
	mov DWORD 8[%r12], %r1
	push %r1
	push %r0
	call [split_block]
	add #8, %r14
// Label
__bbcc_00000012:
// Set
	mov #0, %r0
// SetAt
	mov %r0, BYTE 12[%r3]
// Label
__bbcc_00000011:
// Label
__bbcc_0000000e:
// Set
	mov %r3, %r0
// Set
	mov #13, %r1
// Add
	add %r1, %r0
// Return
__bbcc_00000031:
	pop %r3
	pop %r2
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: free
free:
	push %r12
	mov %r14, %r12
	push %r1
	push %r2
// JmpNotZero
	mov DWORD 8[%r12], %r0
	cmp #0, %r0
	jnz [__bbcc_00000013]
// Return
	mov #0, %r0
	jmp [__bbcc_00000032]
// Label
__bbcc_00000013:
// Set
	mov DWORD 8[%r12], %r0
// CallFunction
	push %r0
	call [get_block_ptr]
	add #4, %r14
// Set
// Set
	mov %r0, %r2
// Set
	mov #1, %r0
// SetAt
	mov %r0, BYTE 12[%r2]
// Set
	mov #0, %r1
// ReadAt
	mov DWORD 8[%r2], %r0
// JmpZero
	cmp #0, %r0
	jze [__bbcc_00000015]
// ReadAt
	mov DWORD 8[%r2], %r0
// ReadAt
	mov BYTE 12[%r0], %r0
// JmpZero
	cmp #0, %r0
	jze [__bbcc_00000015]
// Set
	mov #1, %r1
// Label
__bbcc_00000015:
// JmpZero
	cmp #0, %r1
	jze [__bbcc_00000014]
// ReadAt
	mov DWORD 8[%r2], %r0
// Set
// CallFunction
	push %r0
	call [fusion]
	add #4, %r14
// Set
// Set
	mov %r0, %r2
// Label
__bbcc_00000014:
// ReadAt
	mov DWORD 4[%r2], %r0
// JmpZero
	cmp #0, %r0
	jze [__bbcc_00000016]
// Set
	mov %r2, %r0
// CallFunction
	push %r0
	call [fusion]
	add #4, %r14
// Jmp
	jmp [__bbcc_00000017]
// Label
__bbcc_00000016:
// ReadAt
	mov DWORD 8[%r2], %r0
// JmpZero
	cmp #0, %r0
	jze [__bbcc_00000018]
// ReadAt
	mov DWORD 8[%r2], %r1
// Set
	mov #0, %r0
// SetAt
	mov %r0, DWORD 4[%r1]
// Jmp
	jmp [__bbcc_00000019]
// Label
__bbcc_00000018:
// Set
	mov #0, %r0
// Set
	mov %r0, DWORD [global_base]
// Label
__bbcc_00000019:
// Set
	mov %r2, %r0
// Set
	mov %r0, DWORD [mem_top]
// Label
__bbcc_00000017:
// Return
	mov #0, %r0
__bbcc_00000032:
	pop %r2
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: copy_block
copy_block:
	push %r12
	mov %r14, %r12
	push %r1
	push %r2
	push %r3
	push %r4
// Set
	mov DWORD 8[%r12], %r0
// CallFunction
	push %r0
	call [get_data_ptr]
	add #4, %r14
// Set
// Set
	mov %r0, %r4
// Set
	mov DWORD 12[%r12], %r0
// CallFunction
	push %r0
	call [get_data_ptr]
	add #4, %r14
// Set
// Set
	mov %r0, %r3
// Set
	mov #0, %r0
// Set
	mov %r0, %r2
// Label
__bbcc_0000001a:
// Set
	mov #0, %r1
// ReadAt
	mov DWORD 8[%r12], %r0
	mov DWORD [%r0], %r0
// MoreEqualJmp
	cmp %r2, %r0
	jae [__bbcc_0000001d]
// ReadAt
	mov DWORD 12[%r12], %r0
	mov DWORD [%r0], %r0
// MoreEqualJmp
	cmp %r2, %r0
	jae [__bbcc_0000001d]
// Set
	mov #1, %r1
// Label
__bbcc_0000001d:
// JmpZero
	cmp #0, %r1
	jze [__bbcc_0000001c]
// ReadAt
	mov %r4, %r0
	add %r2, %r0
	mov BYTE [%r0], %r0
// SetAt
	mov %r3, %r1
	add %r2, %r1
	mov %r0, BYTE [%r1]
// Label
__bbcc_0000001b:
// Inc
	inc %r2
// Jmp
	jmp [__bbcc_0000001a]
// Label
__bbcc_0000001c:
// Return
	mov #0, %r0
__bbcc_00000033:
	pop %r4
	pop %r3
	pop %r2
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: realloc
realloc:
	push %r12
	mov %r14, %r12
	push %r1
	push %r2
	push %r3
// JmpNotZero
	mov DWORD 8[%r12], %r0
	cmp #0, %r0
	jnz [__bbcc_0000001e]
// CallFunction
	mov DWORD 12[%r12], %r0
	push %r0
	call [malloc]
	add #4, %r14
// Return
	jmp [__bbcc_00000034]
// Label
__bbcc_0000001e:
// Set
	mov DWORD 8[%r12], %r0
// CallFunction
	push %r0
	call [get_block_ptr]
	add #4, %r14
// Set
// Set
	mov %r0, %r1
// ReadAt
	mov DWORD [%r1], %r0
// LessThanJmp
	mov 12[%r12], %r2
	cmp %r0, %r2
	jb [__bbcc_0000001f]
// ReadAt
	mov DWORD [%r1], %r0
// Sub
	sub DWORD 12[%r12], %r0
// Set
	mov #4, %r3
// Add
	mov #13, %r2
	add %r3, %r2
// LessThanJmp
	cmp %r0, %r2
	jb [__bbcc_00000020]
// Set
	mov %r1, %r0
// CallFunction
	mov DWORD 12[%r12], %r2
	push %r2
	push %r0
	call [split_block]
	add #8, %r14
// Label
__bbcc_00000020:
// Jmp
	jmp [__bbcc_00000021]
// Label
__bbcc_0000001f:
// Set
	mov #0, %r3
// ReadAt
	mov DWORD 4[%r1], %r0
// JmpZero
	cmp #0, %r0
	jze [__bbcc_00000023]
// ReadAt
	mov DWORD 4[%r1], %r0
// ReadAt
	mov BYTE 12[%r0], %r0
// JmpZero
	cmp #0, %r0
	jze [__bbcc_00000023]
// ReadAt
	mov DWORD [%r1], %r0
// Add
	add #13, %r0
// ReadAt
	mov DWORD 4[%r1], %r2
// ReadAt
	mov DWORD [%r2], %r2
// Add
	add %r2, %r0
// LessThanJmp
	mov 12[%r12], %r2
	cmp %r0, %r2
	jb [__bbcc_00000023]
// Set
	mov #1, %r3
// Label
__bbcc_00000023:
// JmpZero
	cmp #0, %r3
	jze [__bbcc_00000022]
// Set
	mov %r1, %r0
// CallFunction
	push %r0
	call [fusion]
	add #4, %r14
// ReadAt
	mov DWORD [%r1], %r0
// Sub
	sub DWORD 12[%r12], %r0
// Set
	mov #4, %r3
// Add
	mov #13, %r2
	add %r3, %r2
// LessThanJmp
	cmp %r0, %r2
	jb [__bbcc_00000024]
// Set
	mov %r1, %r0
// CallFunction
	mov DWORD 12[%r12], %r2
	push %r2
	push %r0
	call [split_block]
	add #8, %r14
// Label
__bbcc_00000024:
// Jmp
	jmp [__bbcc_00000025]
// Label
__bbcc_00000022:
// CallFunction
	mov DWORD 12[%r12], %r0
	push %r0
	call [malloc]
	add #4, %r14
// Set
// Set
	mov %r0, %r2
// JmpNotZero
	cmp #0, %r2
	jnz [__bbcc_00000026]
// Return
	mov #0, %r0
	jmp [__bbcc_00000034]
// Label
__bbcc_00000026:
// Set
	mov %r2, %r0
// CallFunction
	push %r0
	call [get_block_ptr]
	add #4, %r14
// Set
// Set
// Set
// Set
// CallFunction
	push %r0
	push %r1
	call [copy_block]
	add #8, %r14
// Set
	mov DWORD 8[%r12], %r0
// CallFunction
	push %r0
	call [free]
	add #4, %r14
// Return
	mov %r2, %r0
	jmp [__bbcc_00000034]
// Label
__bbcc_00000025:
// Label
__bbcc_00000021:
// Return
	mov DWORD 8[%r12], %r0
__bbcc_00000034:
	pop %r3
	pop %r2
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: atoi
atoi:
	push %r12
	mov %r14, %r12
	push %r1
	push %r2
	push %r3
// Set
	mov DWORD 8[%r12], %r0
// Set
	mov %r0, %r3
// Set
	mov #0, %r1
// Set
	mov #0, %r0
// Set
	mov %r0, %r2
// ReadAt
	mov BYTE [%r3], %r0
// NotEqualJmp
	cmp #45, %r0
	jnz [__bbcc_00000027]
// Set
	mov #1, %r0
// Set
	mov %r0, %r2
// Inc
	inc %r3
// Label
__bbcc_00000027:
// Label
__bbcc_00000028:
// ReadAt
	mov BYTE [%r3], %r0
// Set
// CallFunction
	push %r0
	call [isdigit]
	add #4, %r14
// JmpZero
	cmp #0, %r0
	jze [__bbcc_00000029]
// Mult
	mul #10, %r1
// Set
// ReadAt
	mov BYTE [%r3], %r0
// Set
// Sub
	sub #48, %r0
// Set
// Add
	add %r0, %r1
// Set
// Inc
	inc %r3
// Jmp
	jmp [__bbcc_00000028]
// Label
__bbcc_00000029:
// JmpZero
	cmp #0, %r2
	jze [__bbcc_0000002a]
// Neg
	neg %r1
// Set
// Label
__bbcc_0000002a:
// Return
	mov %r1, %r0
__bbcc_00000035:
	pop %r3
	pop %r2
	pop %r1
	mov %r12, %r14
	pop %r12
	ret