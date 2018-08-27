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
\ Set
	mov #0, %r0
\ LessThanJmp
	mov #65, %r1
	cmp 4[%r11], %r1
	jl [__bbcc_00000000]
\ MoreThanJmp
	mov #90, %r1
	cmp 4[%r11], %r1
	jg [__bbcc_00000000]
\ Set
	mov #1, %r0
\ Label
__bbcc_00000000:
\ Return
__bbcc_0000000e:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
\ Function: islower
islower:
	push %r11
	mov %r13, %r11
	push %r1
\ Set
	mov #0, %r0
\ LessThanJmp
	mov #97, %r1
	cmp 4[%r11], %r1
	jl [__bbcc_00000001]
\ MoreThanJmp
	mov #122, %r1
	cmp 4[%r11], %r1
	jg [__bbcc_00000001]
\ Set
	mov #1, %r0
\ Label
__bbcc_00000001:
\ Return
__bbcc_0000000f:
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
	mov #1, %r1
\ CallFunction
	mov 4[%r11], %r0
	push %r0
	call [islower]
	add #2, %r13
\ JmpNotZero
	cmp #0, %r0
	jnz [__bbcc_00000002]
\ CallFunction
	mov 4[%r11], %r0
	push %r0
	call [isupper]
	add #2, %r13
\ JmpNotZero
	cmp #0, %r0
	jnz [__bbcc_00000002]
\ Set
	mov #0, %r1
\ Label
__bbcc_00000002:
\ Return
	mov %r1, %r0
__bbcc_00000010:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
\ Function: isdigit
isdigit:
	push %r11
	mov %r13, %r11
	push %r1
\ Set
	mov #0, %r0
\ LessThanJmp
	mov #48, %r1
	cmp 4[%r11], %r1
	jl [__bbcc_00000003]
\ MoreThanJmp
	mov #57, %r1
	cmp 4[%r11], %r1
	jg [__bbcc_00000003]
\ Set
	mov #1, %r0
\ Label
__bbcc_00000003:
\ Return
__bbcc_00000011:
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
	mov #1, %r1
\ CallFunction
	mov 4[%r11], %r0
	push %r0
	call [isalpha]
	add #2, %r13
\ JmpNotZero
	cmp #0, %r0
	jnz [__bbcc_00000004]
\ CallFunction
	mov 4[%r11], %r0
	push %r0
	call [isdigit]
	add #2, %r13
\ JmpNotZero
	cmp #0, %r0
	jnz [__bbcc_00000004]
\ Set
	mov #0, %r1
\ Label
__bbcc_00000004:
\ Return
	mov %r1, %r0
__bbcc_00000012:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
\ Function: isascii
isascii:
	push %r11
	mov %r13, %r11
	push %r1
\ LessEqualCmp
	mov #127, %r1
	cmp 4[%r11], %r1
	sle %r0
\ Return
__bbcc_00000013:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
\ Function: isblank
isblank:
	push %r11
	mov %r13, %r11
	push %r1
\ Set
	mov #1, %r0
\ EqualJmp
	mov #9, %r1
	cmp 4[%r11], %r1
	jze [__bbcc_00000005]
\ EqualJmp
	mov #32, %r1
	cmp 4[%r11], %r1
	jze [__bbcc_00000005]
\ Set
	mov #0, %r0
\ Label
__bbcc_00000005:
\ Return
__bbcc_00000014:
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
	cmp 4[%r11], %r1
	sl %r0
\ Return
__bbcc_00000015:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
\ Function: isspace
isspace:
	push %r11
	mov %r13, %r11
	push %r1
\ Set
	mov #1, %r0
\ EqualJmp
	mov #32, %r1
	cmp 4[%r11], %r1
	jze [__bbcc_00000006]
\ EqualJmp
	mov #10, %r1
	cmp 4[%r11], %r1
	jze [__bbcc_00000006]
\ EqualJmp
	mov #9, %r1
	cmp 4[%r11], %r1
	jze [__bbcc_00000006]
\ EqualJmp
	mov #13, %r1
	cmp 4[%r11], %r1
	jze [__bbcc_00000006]
\ Set
	mov #0, %r0
\ Label
__bbcc_00000006:
\ Return
__bbcc_00000016:
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
\ Set
	mov #1, %r1
\ CallFunction
	mov 4[%r11], %r0
	push %r0
	call [isdigit]
	add #2, %r13
\ JmpNotZero
	cmp #0, %r0
	jnz [__bbcc_00000007]
\ Set
	mov #0, %r0
\ LessThanJmp
	mov #97, %r2
	cmp 4[%r11], %r2
	jl [__bbcc_00000008]
\ MoreThanJmp
	mov #102, %r2
	cmp 4[%r11], %r2
	jg [__bbcc_00000008]
\ Set
	mov #1, %r0
\ Label
__bbcc_00000008:
\ JmpNotZero
	cmp #0, %r0
	jnz [__bbcc_00000007]
\ Set
	mov #0, %r0
\ LessThanJmp
	mov #65, %r2
	cmp 4[%r11], %r2
	jl [__bbcc_00000009]
\ MoreThanJmp
	mov #70, %r2
	cmp 4[%r11], %r2
	jg [__bbcc_00000009]
\ Set
	mov #1, %r0
\ Label
__bbcc_00000009:
\ JmpNotZero
	cmp #0, %r0
	jnz [__bbcc_00000007]
\ Set
	mov #0, %r1
\ Label
__bbcc_00000007:
\ Return
	mov %r1, %r0
__bbcc_00000017:
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
\ CallFunction
	mov 4[%r11], %r0
	push %r0
	call [islower]
	add #2, %r13
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_0000000a]
\ Neg
	mov #-32, %r1
\ And
	mov %r1, %r0
	and 4[%r11], %r0
\ Set
\ Jmp
	jmp [__bbcc_0000000b]
\ Label
__bbcc_0000000a:
\ Set
	mov WORD 4[%r11], %r0
\ Label
__bbcc_0000000b:
\ Return
__bbcc_00000018:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
\ Function: tolower
tolower:
	push %r11
	mov %r13, %r11
\ CallFunction
	mov 4[%r11], %r0
	push %r0
	call [isupper]
	add #2, %r13
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_0000000c]
\ IncOr
	mov #32, %r0
	or 4[%r11], %r0
\ Set
\ Jmp
	jmp [__bbcc_0000000d]
\ Label
__bbcc_0000000c:
\ Set
	mov WORD 4[%r11], %r0
\ Label
__bbcc_0000000d:
\ Return
__bbcc_00000019:
	mov %r11, %r13
	pop %r11
	ret