.export isupper
.export islower
.export isalpha
.export isdigit
.export isalnum
.export isascii
.export isblank
.export iscntrl
.export isspace
.export isxdigit
.export toupper
.export tolower
\ Function: isupper
isupper:
	push %r11
	mov %r13, %r11
	push %r1
	push %r2
\ Set
	mov #0, %r1
\ MoreEqualCmp
	mov #65, %r2
	mov #1, %r0
	cmp 4[%r11], %r2
	jge [__bbcc_0000001d]
	mov #0, %r0
__bbcc_0000001d:
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_00000001]
\ LessEqualCmp
	mov #90, %r2
	mov #1, %r0
	cmp 4[%r11], %r2
	jle [__bbcc_0000001e]
	mov #0, %r0
__bbcc_0000001e:
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_00000001]
\ Set
	mov #1, %r1
\ Label
__bbcc_00000001:
\ Return
	mov %r1, %r0
__bbcc_0000001f:
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
\ Function: islower
islower:
	push %r11
	mov %r13, %r11
	push %r1
	push %r2
\ Set
	mov #0, %r1
\ MoreEqualCmp
	mov #97, %r2
	mov #1, %r0
	cmp 4[%r11], %r2
	jge [__bbcc_00000020]
	mov #0, %r0
__bbcc_00000020:
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_00000003]
\ LessEqualCmp
	mov #122, %r2
	mov #1, %r0
	cmp 4[%r11], %r2
	jle [__bbcc_00000021]
	mov #0, %r0
__bbcc_00000021:
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_00000003]
\ Set
	mov #1, %r1
\ Label
__bbcc_00000003:
\ Return
	mov %r1, %r0
__bbcc_00000022:
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
\ Function: isalpha
isalpha:
	push %r11
	mov %r13, %r11
	push %r1
\ Set
	mov #0, %r1
\ CallFunction
	mov 4[%r11], %r0
	push %r0
	call [islower]
	add #2, %r13
\ JmpNotZero
	cmp #0, %r0
	jnz [__bbcc_00000004]
\ CallFunction
	mov 4[%r11], %r0
	push %r0
	call [isupper]
	add #2, %r13
\ JmpNotZero
	cmp #0, %r0
	jnz [__bbcc_00000004]
\ Jmp
	jmp [__bbcc_00000005]
\ Label
__bbcc_00000004:
\ Set
	mov #1, %r1
\ Label
__bbcc_00000005:
\ Return
	mov %r1, %r0
__bbcc_00000023:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
\ Function: isdigit
isdigit:
	push %r11
	mov %r13, %r11
	push %r1
	push %r2
\ Set
	mov BYTE 4[%r11], %r0
\ Set
\ Sub
	sub #48, %r0
\ LessEqualCmp
	mov #9, %r2
	mov #1, %r1
	cmp %r0, %r2
	jle [__bbcc_00000024]
	mov #0, %r1
__bbcc_00000024:
\ Return
	mov %r1, %r0
__bbcc_00000025:
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
\ Function: isalnum
isalnum:
	push %r11
	mov %r13, %r11
	push %r1
\ Set
	mov #0, %r1
\ CallFunction
	mov 4[%r11], %r0
	push %r0
	call [isalpha]
	add #2, %r13
\ JmpNotZero
	cmp #0, %r0
	jnz [__bbcc_00000006]
\ CallFunction
	mov 4[%r11], %r0
	push %r0
	call [isdigit]
	add #2, %r13
\ JmpNotZero
	cmp #0, %r0
	jnz [__bbcc_00000006]
\ Jmp
	jmp [__bbcc_00000007]
\ Label
__bbcc_00000006:
\ Set
	mov #1, %r1
\ Label
__bbcc_00000007:
\ Return
	mov %r1, %r0
__bbcc_00000026:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
\ Function: isascii
isascii:
	push %r11
	mov %r13, %r11
	push %r1
	push %r2
	push %r3
\ Set
	mov #1, %r3
\ Neg
	mov #-127, %r2
\ Set
	mov WORD 4[%r11], %r1
\ And
	mov %r2, %r0
	and %r1, %r0
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_00000008]
\ Set
	mov #0, %r3
\ Label
__bbcc_00000008:
\ Return
	mov %r3, %r0
__bbcc_00000027:
	pop %r3
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
\ Function: isblank
isblank:
	push %r11
	mov %r13, %r11
	push %r1
	push %r2
\ Set
	mov #0, %r1
\ EqualCmp
	mov #9, %r2
	mov #1, %r0
	cmp 4[%r11], %r2
	jze [__bbcc_00000028]
	mov #0, %r0
__bbcc_00000028:
\ JmpNotZero
	cmp #0, %r0
	jnz [__bbcc_00000009]
\ EqualCmp
	mov #32, %r2
	mov #1, %r0
	cmp 4[%r11], %r2
	jze [__bbcc_00000029]
	mov #0, %r0
__bbcc_00000029:
\ JmpNotZero
	cmp #0, %r0
	jnz [__bbcc_00000009]
\ Jmp
	jmp [__bbcc_0000000a]
\ Label
__bbcc_00000009:
\ Set
	mov #1, %r1
\ Label
__bbcc_0000000a:
\ Return
	mov %r1, %r0
__bbcc_0000002a:
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
\ Function: iscntrl
iscntrl:
	push %r11
	mov %r13, %r11
	push %r1
\ LessThanCmp
	mov #32, %r1
	mov #1, %r0
	cmp 4[%r11], %r1
	jl [__bbcc_0000002b]
	mov #0, %r0
__bbcc_0000002b:
\ Return
__bbcc_0000002c:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
\ Function: isspace
isspace:
	push %r11
	mov %r13, %r11
	push %r1
	push %r2
	push %r3
	push %r4
\ Set
	mov #0, %r3
\ Set
	mov #0, %r2
\ Set
	mov #0, %r1
\ EqualCmp
	mov #32, %r4
	mov #1, %r0
	cmp 4[%r11], %r4
	jze [__bbcc_0000002d]
	mov #0, %r0
__bbcc_0000002d:
\ JmpNotZero
	cmp #0, %r0
	jnz [__bbcc_0000000f]
\ EqualCmp
	mov #10, %r4
	mov #1, %r0
	cmp 4[%r11], %r4
	jze [__bbcc_0000002e]
	mov #0, %r0
__bbcc_0000002e:
\ JmpNotZero
	cmp #0, %r0
	jnz [__bbcc_0000000f]
\ Jmp
	jmp [__bbcc_00000010]
\ Label
__bbcc_0000000f:
\ Set
	mov #1, %r1
\ Label
__bbcc_00000010:
\ JmpNotZero
	cmp #0, %r1
	jnz [__bbcc_0000000d]
\ EqualCmp
	mov #9, %r1
	mov #1, %r0
	cmp 4[%r11], %r1
	jze [__bbcc_0000002f]
	mov #0, %r0
__bbcc_0000002f:
\ JmpNotZero
	cmp #0, %r0
	jnz [__bbcc_0000000d]
\ Jmp
	jmp [__bbcc_0000000e]
\ Label
__bbcc_0000000d:
\ Set
	mov #1, %r2
\ Label
__bbcc_0000000e:
\ JmpNotZero
	cmp #0, %r2
	jnz [__bbcc_0000000b]
\ EqualCmp
	mov #13, %r1
	mov #1, %r0
	cmp 4[%r11], %r1
	jze [__bbcc_00000030]
	mov #0, %r0
__bbcc_00000030:
\ JmpNotZero
	cmp #0, %r0
	jnz [__bbcc_0000000b]
\ Jmp
	jmp [__bbcc_0000000c]
\ Label
__bbcc_0000000b:
\ Set
	mov #1, %r3
\ Label
__bbcc_0000000c:
\ Return
	mov %r3, %r0
__bbcc_00000031:
	pop %r4
	pop %r3
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
\ Function: isxdigit
isxdigit:
	push %r11
	mov %r13, %r11
	push %r1
	push %r2
	push %r3
	push %r4
\ Set
	mov #0, %r3
\ Set
	mov #0, %r2
\ CallFunction
	mov 4[%r11], %r0
	push %r0
	call [isdigit]
	add #2, %r13
\ JmpNotZero
	cmp #0, %r0
	jnz [__bbcc_00000013]
\ Set
	mov #0, %r1
\ MoreEqualCmp
	mov #97, %r4
	mov #1, %r0
	cmp 4[%r11], %r4
	jge [__bbcc_00000032]
	mov #0, %r0
__bbcc_00000032:
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_00000016]
\ LessEqualCmp
	mov #102, %r4
	mov #1, %r0
	cmp 4[%r11], %r4
	jle [__bbcc_00000033]
	mov #0, %r0
__bbcc_00000033:
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_00000016]
\ Set
	mov #1, %r1
\ Label
__bbcc_00000016:
\ JmpNotZero
	cmp #0, %r1
	jnz [__bbcc_00000013]
\ Jmp
	jmp [__bbcc_00000014]
\ Label
__bbcc_00000013:
\ Set
	mov #1, %r2
\ Label
__bbcc_00000014:
\ JmpNotZero
	cmp #0, %r2
	jnz [__bbcc_00000011]
\ Set
	mov #0, %r1
\ MoreEqualCmp
	mov #65, %r2
	mov #1, %r0
	cmp 4[%r11], %r2
	jge [__bbcc_00000034]
	mov #0, %r0
__bbcc_00000034:
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_00000018]
\ LessEqualCmp
	mov #70, %r2
	mov #1, %r0
	cmp 4[%r11], %r2
	jle [__bbcc_00000035]
	mov #0, %r0
__bbcc_00000035:
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_00000018]
\ Set
	mov #1, %r1
\ Label
__bbcc_00000018:
\ JmpNotZero
	cmp #0, %r1
	jnz [__bbcc_00000011]
\ Jmp
	jmp [__bbcc_00000012]
\ Label
__bbcc_00000011:
\ Set
	mov #1, %r3
\ Label
__bbcc_00000012:
\ Return
	mov %r3, %r0
__bbcc_00000036:
	pop %r4
	pop %r3
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
\ Function: toupper
toupper:
	push %r11
	mov %r13, %r11
	push %r1
	push %r2
	push %r3
\ CallFunction
	mov 4[%r11], %r0
	push %r0
	call [islower]
	add #2, %r13
	mov %r0, %r3
\ Neg
	mov #-32, %r2
\ Set
	mov WORD 4[%r11], %r1
\ And
	mov %r2, %r0
	and %r1, %r0
\ JmpZero
	cmp #0, %r3
	jze [__bbcc_00000019]
\ Set
\ Jmp
	jmp [__bbcc_0000001a]
\ Label
__bbcc_00000019:
\ Set
	mov WORD 4[%r11], %r0
\ Label
__bbcc_0000001a:
\ Return
__bbcc_00000037:
	pop %r3
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
\ Function: tolower
tolower:
	push %r11
	mov %r13, %r11
	push %r1
\ CallFunction
	mov 4[%r11], %r0
	push %r0
	call [isupper]
	add #2, %r13
	mov %r0, %r1
\ Set
	mov WORD 4[%r11], %r0
\ IncOr
	mov #32, %r0
	or %r0, %r0
\ JmpZero
	cmp #0, %r1
	jze [__bbcc_0000001b]
\ Set
\ Jmp
	jmp [__bbcc_0000001c]
\ Label
__bbcc_0000001b:
\ Set
	mov WORD 4[%r11], %r0
\ Label
__bbcc_0000001c:
\ Return
__bbcc_00000038:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret