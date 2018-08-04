.import putchar
.import getchar
.import fputs
.import puts
.import malloc
.import free
.import realloc
.import strlen
.import strrev
.import strcmp
.import memset
.import backspace
.import append
.export main
__bbcc_0000000d:
.byte #36,#32,#0
__bbcc_0000000e:
.byte #101,#120,#105,#116,#0
__bbcc_0000000f:
.byte #99,#108,#101,#97,#114,#0
__bbcc_00000010:
.byte #66,#121,#101,#33,#0
key_buffer:
.byte #0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
\ Function: main
main:
	push %r11
	mov %r13, %r11
	push %r1
	push %r2
	push %r3
\ AddrOf
	lea WORD [__bbcc_0000000d], %r0
\ Set
\ CallFunction
	push %r0
	call [fputs]
	add #2, %r13
\ Label
__bbcc_00000000:
\ JmpZero
	mov #1, %r0
	cmp #0, %r0
	jze [__bbcc_00000001]
\ CallFunction
	call [getchar]
\ Set
\ Set
	mov %r0, %r2
\ EqualCmp
	mov #1, %r0
	cmp #27, %r2
	jze [__bbcc_00000011]
	mov #0, %r0
__bbcc_00000011:
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_00000002]
\ Set
	mov #10, %r0
\ CallFunction
	push %r0
	call [putchar]
	add #2, %r13
\ Jmp
	jmp [__bbcc_00000001]
\ Jmp
	jmp [__bbcc_00000003]
\ Label
__bbcc_00000002:
\ EqualCmp
	mov #1, %r0
	cmp #127, %r2
	jze [__bbcc_00000012]
	mov #0, %r0
__bbcc_00000012:
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_00000004]
\ AddrOf
	lea WORD [key_buffer], %r0
\ Set
\ CallFunction
	push %r0
	call [strlen]
	add #2, %r13
	mov %r0, %r1
\ MoreThanCmp
	mov #0, %r3
	mov #1, %r0
	cmp %r1, %r3
	jg [__bbcc_00000013]
	mov #0, %r0
__bbcc_00000013:
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_00000005]
\ AddrOf
	lea WORD [key_buffer], %r0
\ Set
\ CallFunction
	push %r0
	call [backspace]
	add #2, %r13
\ Set
	mov %r2, %r0
\ CallFunction
	push %r0
	call [putchar]
	add #2, %r13
\ Label
__bbcc_00000005:
\ Jmp
	jmp [__bbcc_00000006]
\ Label
__bbcc_00000004:
\ EqualCmp
	mov #1, %r0
	cmp #10, %r2
	jze [__bbcc_00000014]
	mov #0, %r0
__bbcc_00000014:
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_00000007]
\ Set
	mov #10, %r0
\ CallFunction
	push %r0
	call [putchar]
	add #2, %r13
\ AddrOf
	lea WORD [key_buffer], %r0
\ Set
	mov %r0, %r1
\ AddrOf
	lea WORD [__bbcc_0000000e], %r0
\ Set
\ CallFunction
	push %r0
	push %r1
	call [strcmp]
	add #4, %r13
	mov %r0, %r1
\ EqualCmp
	mov #1, %r0
	cmp #0, %r1
	jze [__bbcc_00000015]
	mov #0, %r0
__bbcc_00000015:
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_00000008]
\ Jmp
	jmp [__bbcc_00000001]
\ Jmp
	jmp [__bbcc_00000009]
\ Label
__bbcc_00000008:
\ AddrOf
	lea WORD [key_buffer], %r0
\ Set
	mov %r0, %r1
\ AddrOf
	lea WORD [__bbcc_0000000f], %r0
\ Set
\ CallFunction
	push %r0
	push %r1
	call [strcmp]
	add #4, %r13
	mov %r0, %r1
\ EqualCmp
	mov #1, %r0
	cmp #0, %r1
	jze [__bbcc_00000016]
	mov #0, %r0
__bbcc_00000016:
\ JmpZero
	cmp #0, %r0
	jze [__bbcc_0000000a]
\ Set
	mov #12, %r0
\ CallFunction
	push %r0
	call [putchar]
	add #2, %r13
\ Jmp
	jmp [__bbcc_0000000b]
\ Label
__bbcc_0000000a:
\ AddrOf
	lea WORD [key_buffer], %r0
\ Set
\ CallFunction
	push %r0
	call [puts]
	add #2, %r13
\ Label
__bbcc_0000000b:
\ Label
__bbcc_00000009:
\ AddrOf
	lea WORD [key_buffer], %r1
\ Set
	mov #0, %r0
\ SetAt
	mov %r0, BYTE [%r1]
\ AddrOf
	lea WORD [__bbcc_0000000d], %r0
\ Set
\ CallFunction
	push %r0
	call [fputs]
	add #2, %r13
\ Jmp
	jmp [__bbcc_0000000c]
\ Label
__bbcc_00000007:
\ AddrOf
	lea WORD [key_buffer], %r0
\ Set
\ CallFunction
	push %r2
	mov #20, %r1
	push %r1
	push %r0
	call [append]
	add #6, %r13
\ Set
	mov %r2, %r0
\ CallFunction
	push %r0
	call [putchar]
	add #2, %r13
\ Label
__bbcc_0000000c:
\ Label
__bbcc_00000006:
\ Label
__bbcc_00000003:
\ Jmp
	jmp [__bbcc_00000000]
\ Label
__bbcc_00000001:
\ AddrOf
	lea WORD [__bbcc_00000010], %r0
\ Set
\ CallFunction
	push %r0
	call [puts]
	add #2, %r13
\ Return
	mov #0, %r0
__bbcc_00000017:
	pop %r3
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret