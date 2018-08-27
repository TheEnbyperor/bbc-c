.import strlen
.import memcmp
.import isalpha
.import isdigit
.export initScanner
.export scanToken
__bbcc_000000b4:
.byte #73,#110,#118,#97,#108,#105,#100,#32,#105,#110,#100,#101,#110,#116,#46,#0
__bbcc_000000b5:
.byte #85,#110,#116,#101,#114,#109,#105,#110,#97,#116,#101,#100,#32,#115,#116,#114,#105,#110,#103,#46,#0
__bbcc_000000b6:
.byte #114,#101,#97,#107,#0
__bbcc_000000b7:
.byte #108,#111,#98,#97,#108,#0
__bbcc_000000b8:
.byte #97,#109,#98,#100,#97,#0
__bbcc_000000b9:
.byte #114,#0
__bbcc_000000ba:
.byte #97,#115,#115,#0
__bbcc_000000bb:
.byte #105,#101,#108,#100,#0
__bbcc_000000bc:
.byte #97,#108,#115,#101,#0
__bbcc_000000bd:
.byte #114,#117,#101,#0
__bbcc_000000be:
.byte #114,#121,#0
__bbcc_000000bf:
.byte #111,#110,#101,#0
__bbcc_000000c0:
.byte #110,#116,#105,#110,#117,#101,#0
__bbcc_000000c1:
.byte #110,#97,#108,#108,#121,#0
__bbcc_000000c2:
.byte #111,#109,#0
__bbcc_000000c3:
.byte #105,#115,#101,#0
__bbcc_000000c4:
.byte #116,#117,#114,#110,#0
__bbcc_000000c5:
.byte #105,#108,#101,#0
__bbcc_000000c6:
.byte #116,#104,#0
__bbcc_000000c7:
.byte #112,#111,#114,#116,#0
__bbcc_000000c8:
.byte #97,#105,#116,#0
__bbcc_000000c9:
.byte #100,#0
__bbcc_000000ca:
.byte #110,#99,#0
__bbcc_000000cb:
.byte #101,#114,#116,#0
__bbcc_000000cc:
.byte #99,#101,#112,#116,#0
__bbcc_000000cd:
.byte #102,#0
__bbcc_000000ce:
.byte #101,#0
__bbcc_000000cf:
.byte #108,#111,#99,#97,#108,#0
__bbcc_000000d0:
.byte #85,#110,#101,#120,#112,#101,#99,#116,#101,#100,#32,#99,#104,#97,#114,#97,#99,#116,#101,#114,#0
// Function: initScanner
initScanner:
	push %r11
	mov %r13, %r11
	push %r1
// Set
	mov WORD 6[%r11], %r0
// SetAt
	mov 4[%r11], %r1
	mov %r0, WORD [%r1]
// Set
	mov WORD 6[%r11], %r0
// SetAt
	mov 4[%r11], %r1
	mov %r0, WORD 2[%r1]
// SetAt
	mov 4[%r11], %r0
	mov #1, %r1
	mov %r1, WORD 4[%r0]
// Set
	mov #1, %r0
// SetAt
	mov 4[%r11], %r1
	mov %r0, BYTE 6[%r1]
// Add
	mov WORD 4[%r11], %r0
	add #7, %r0
// Set
// SetAt
	mov 4[%r11], %r1
	mov %r0, WORD 47[%r1]
// Set
	mov WORD 4[%r11], %r0
// CallFunction
	mov #0, %r1
	push %r1
	push %r0
	call [pushIndent]
	add #4, %r13
// Return
	mov #0, %r0
__bbcc_000000d1:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: isAtEnd
isAtEnd:
	push %r11
	mov %r13, %r11
	push %r1
// ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 2[%r0], %r0
// ReadAt
	mov BYTE [%r0], %r1
// EqualCmp
	cmp #0, %r1
	sze %r0
// Return
__bbcc_000000d2:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: pushIndent
pushIndent:
	push %r11
	mov %r13, %r11
	push %r1
// ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 47[%r0], %r0
// SetAt
	mov 6[%r11], %r1
	mov %r1, WORD [%r0]
// ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 47[%r0], %r0
// Add
	add #2, %r0
// SetAt
	mov 4[%r11], %r1
	mov %r0, WORD 47[%r1]
// Return
	mov #0, %r0
__bbcc_000000d3:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: popIndent
popIndent:
	push %r11
	mov %r13, %r11
	push %r1
// ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 47[%r0], %r0
// Sub
	sub #2, %r0
// SetAt
	mov 4[%r11], %r1
	mov %r0, WORD 47[%r1]
// ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 47[%r0], %r0
// ReadAt
	mov WORD [%r0], %r0
// Return
__bbcc_000000d4:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: peekIndent
peekIndent:
	push %r11
	mov %r13, %r11
	push %r1
	push %r2
// ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 47[%r0], %r2
// Neg
	mov #-1, %r1
// Mult
	mov #2, %r0
	mul %r1, %r0
// ReadAt
	mov %r2, %r1
	add %r0, %r1
	mov WORD [%r1], %r0
// Return
__bbcc_000000d5:
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: makeToken
makeToken:
	push %r11
	mov %r13, %r11
	push %r1
// SetAt
	mov 6[%r11], %r0
	mov 8[%r11], %r1
	mov %r1, WORD [%r0]
// ReadAt
	mov WORD 4[%r11], %r0
	mov WORD [%r0], %r0
// Set
// SetAt
	mov 6[%r11], %r1
	mov %r0, WORD 2[%r1]
// ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 2[%r0], %r0
// ReadAt
	mov WORD 4[%r11], %r1
	mov WORD [%r1], %r1
// Set
// Sub
	sub %r1, %r0
// Set
// SetAt
	mov 6[%r11], %r1
	mov %r0, WORD 4[%r1]
// ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 4[%r0], %r0
// SetAt
	mov 6[%r11], %r1
	mov %r0, WORD 6[%r1]
// Return
	mov #0, %r0
__bbcc_000000d6:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: errorToken
errorToken:
	push %r11
	mov %r13, %r11
	push %r1
// Set
	mov #57, %r0
// SetAt
	mov 6[%r11], %r1
	mov %r0, WORD [%r1]
// Set
	mov WORD 8[%r11], %r0
// SetAt
	mov 6[%r11], %r1
	mov %r0, WORD 2[%r1]
// Set
	mov WORD 8[%r11], %r0
// CallFunction
	push %r0
	call [strlen]
	add #2, %r13
// Set
// SetAt
	mov 6[%r11], %r1
	mov %r0, WORD 4[%r1]
// ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 4[%r0], %r0
// SetAt
	mov 6[%r11], %r1
	mov %r0, WORD 6[%r1]
// Return
	mov #0, %r0
__bbcc_000000d7:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: advance
advance:
	push %r11
	mov %r13, %r11
	push %r1
	push %r2
// ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 2[%r0], %r0
// ReadAt
	mov BYTE [%r0], %r0
// Set
	mov %r0, %r2
// ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 2[%r0], %r1
// Set
	mov %r1, %r0
// Add
	mov #1, %r0
	add %r1, %r0
// SetAt
	mov 4[%r11], %r1
	mov %r0, WORD 2[%r1]
// Return
	mov %r2, %r0
__bbcc_000000d8:
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: peek
peek:
	push %r11
	mov %r13, %r11
// ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 2[%r0], %r0
// ReadAt
	mov BYTE [%r0], %r0
// Return
__bbcc_000000d9:
	mov %r11, %r13
	pop %r11
	ret
// Function: match
match:
	push %r11
	mov %r13, %r11
	push %r1
// Set
	mov WORD 4[%r11], %r0
// CallFunction
	push %r0
	call [isAtEnd]
	add #2, %r13
// JmpZero
	cmp #0, %r0
	jze [__bbcc_00000000]
// Return
	mov #0, %r0
	jmp [__bbcc_000000da]
// Label
__bbcc_00000000:
// ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 2[%r0], %r0
// ReadAt
	mov BYTE [%r0], %r0
// EqualJmp
	cmp 6[%r11], %r0
	jze [__bbcc_00000001]
// Return
	mov #0, %r0
	jmp [__bbcc_000000da]
// Label
__bbcc_00000001:
// ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 2[%r0], %r1
// Set
	mov %r1, %r0
// Add
	mov #1, %r0
	add %r1, %r0
// SetAt
	mov 4[%r11], %r1
	mov %r0, WORD 2[%r1]
// Return
	mov #1, %r0
__bbcc_000000da:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: skipWhitespace
skipWhitespace:
	push %r11
	mov %r13, %r11
	push %r1
// Label
__bbcc_00000002:
// Set
	mov WORD 4[%r11], %r0
// CallFunction
	push %r0
	call [peek]
	add #2, %r13
// Set
	mov %r0, %r1
// Set
	mov #1, %r0
// EqualJmp
	cmp #32, %r1
	jze [__bbcc_00000006]
// EqualJmp
	cmp #13, %r1
	jze [__bbcc_00000006]
// EqualJmp
	cmp #9, %r1
	jze [__bbcc_00000006]
// Set
	mov #0, %r0
// Label
__bbcc_00000006:
// JmpZero
	cmp #0, %r0
	jze [__bbcc_00000005]
// Set
	mov WORD 4[%r11], %r0
// CallFunction
	push %r0
	call [advance]
	add #2, %r13
// Jmp
	jmp [__bbcc_00000007]
// Label
__bbcc_00000005:
// NotEqualJmp
	cmp #35, %r1
	jnz [__bbcc_00000008]
// Label
__bbcc_00000009:
// Set
	mov #0, %r1
// Set
	mov WORD 4[%r11], %r0
// CallFunction
	push %r0
	call [peek]
	add #2, %r13
// EqualJmp
	cmp #10, %r0
	jze [__bbcc_0000000b]
// Set
	mov WORD 4[%r11], %r0
// CallFunction
	push %r0
	call [isAtEnd]
	add #2, %r13
// JmpNotZero
	cmp #0, %r0
	jnz [__bbcc_0000000b]
// Set
	mov #1, %r1
// Label
__bbcc_0000000b:
// JmpZero
	cmp #0, %r1
	jze [__bbcc_0000000a]
// Set
	mov WORD 4[%r11], %r0
// CallFunction
	push %r0
	call [advance]
	add #2, %r13
// Jmp
	jmp [__bbcc_00000009]
// Label
__bbcc_0000000a:
// Jmp
	jmp [__bbcc_0000000c]
// Label
__bbcc_00000008:
// Return
	mov #0, %r0
	jmp [__bbcc_000000db]
// Label
__bbcc_0000000c:
// Label
__bbcc_00000007:
// Label
__bbcc_00000003:
// Jmp
	jmp [__bbcc_00000002]
// Label
__bbcc_00000004:
// Return
	mov #0, %r0
__bbcc_000000db:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: indent
indent:
	push %r11
	mov %r13, %r11
	push %r1
	push %r2
	push %r3
	push %r4
// Set
	mov #0, %r1
// Label
__bbcc_0000000d:
// Set
	mov WORD 4[%r11], %r0
// CallFunction
	push %r0
	call [peek]
	add #2, %r13
// Set
	mov %r0, %r2
// Set
	mov #1, %r0
// EqualJmp
	cmp #32, %r2
	jze [__bbcc_00000011]
// EqualJmp
	cmp #9, %r2
	jze [__bbcc_00000011]
// Set
	mov #0, %r0
// Label
__bbcc_00000011:
// JmpZero
	cmp #0, %r0
	jze [__bbcc_00000010]
// Set
	mov WORD 4[%r11], %r0
// CallFunction
	push %r0
	call [advance]
	add #2, %r13
// NotEqualJmp
	cmp #9, %r2
	jnz [__bbcc_00000012]
// Add
	add #4, %r1
// Set
// Jmp
	jmp [__bbcc_00000013]
// Label
__bbcc_00000012:
// Add
	add #1, %r1
// Set
// Label
__bbcc_00000013:
// Jmp
	jmp [__bbcc_00000014]
// Label
__bbcc_00000010:
// Jmp
	jmp [__bbcc_0000000f]
// Label
__bbcc_00000014:
// Label
__bbcc_0000000e:
// Jmp
	jmp [__bbcc_0000000d]
// Label
__bbcc_0000000f:
// Set
	mov WORD 4[%r11], %r0
// CallFunction
	push %r0
	call [peekIndent]
	add #2, %r13
// Set
	mov %r0, %r4
// NotEqualJmp
	cmp %r1, %r4
	jnz [__bbcc_00000015]
// Return
	mov #0, %r0
	jmp [__bbcc_000000dc]
// Jmp
	jmp [__bbcc_00000016]
// Label
__bbcc_00000015:
// LessEqualJmp
	cmp %r1, %r4
	jle [__bbcc_00000017]
// Set
	mov WORD 4[%r11], %r0
// CallFunction
	push %r1
	push %r0
	call [pushIndent]
	add #4, %r13
// Set
	mov WORD 4[%r11], %r3
// Set
	mov WORD 6[%r11], %r2
// Set
	mov #59, %r0
// CallFunction
	push %r0
	push %r2
	push %r3
	call [makeToken]
	add #6, %r13
// Return
	mov #1, %r0
	jmp [__bbcc_000000dc]
// Jmp
	jmp [__bbcc_00000018]
// Label
__bbcc_00000017:
// MoreEqualJmp
	cmp %r1, %r4
	jge [__bbcc_00000019]
// Label
__bbcc_0000001a:
// Set
	mov WORD 4[%r11], %r0
// CallFunction
	push %r0
	call [popIndent]
	add #2, %r13
// Set
	mov WORD 4[%r11], %r0
// CallFunction
	push %r0
	call [peekIndent]
	add #2, %r13
// Set
	mov %r0, %r4
// NotEqualJmp
	cmp %r4, %r1
	jnz [__bbcc_0000001c]
// Set
	mov WORD 4[%r11], %r3
// Set
	mov WORD 6[%r11], %r2
// Set
	mov #60, %r0
// CallFunction
	push %r0
	push %r2
	push %r3
	call [makeToken]
	add #6, %r13
// Return
	mov #1, %r0
	jmp [__bbcc_000000dc]
// Label
__bbcc_0000001c:
// MoreEqualJmp
	cmp %r1, %r4
	jge [__bbcc_0000001b]
// Jmp
	jmp [__bbcc_0000001a]
// Label
__bbcc_0000001b:
// Set
	mov WORD 4[%r11], %r2
// Set
	mov WORD 6[%r11], %r1
// AddrOf
	lea WORD [__bbcc_000000b4], %r0
// Set
// CallFunction
	push %r0
	push %r1
	push %r2
	call [errorToken]
	add #6, %r13
// Return
	mov #1, %r0
	jmp [__bbcc_000000dc]
// Label
__bbcc_00000019:
// Label
__bbcc_00000018:
// Label
__bbcc_00000016:
// Return
	mov #0, %r0
__bbcc_000000dc:
	pop %r4
	pop %r3
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: isAlpha
isAlpha:
	push %r11
	mov %r13, %r11
	push %r1
// Set
	mov #1, %r1
// Set
	mov WORD 4[%r11], %r0
// CallFunction
	push %r0
	call [isalpha]
	add #2, %r13
// JmpNotZero
	cmp #0, %r0
	jnz [__bbcc_0000001d]
// EqualJmp
	mov #95, %r0
	cmp 4[%r11], %r0
	jze [__bbcc_0000001d]
// Set
	mov #0, %r1
// Label
__bbcc_0000001d:
// Return
	mov %r1, %r0
__bbcc_000000dd:
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: string
string:
	push %r11
	mov %r13, %r11
	push %r1
	push %r2
// Label
__bbcc_0000001e:
// Set
	mov #0, %r1
// Set
	mov WORD 4[%r11], %r0
// CallFunction
	push %r0
	call [peek]
	add #2, %r13
// EqualJmp
	cmp 8[%r11], %r0
	jze [__bbcc_00000020]
// Set
	mov WORD 4[%r11], %r0
// CallFunction
	push %r0
	call [peek]
	add #2, %r13
// EqualJmp
	cmp #10, %r0
	jze [__bbcc_00000020]
// Set
	mov WORD 4[%r11], %r0
// CallFunction
	push %r0
	call [isAtEnd]
	add #2, %r13
// JmpNotZero
	cmp #0, %r0
	jnz [__bbcc_00000020]
// Set
	mov #1, %r1
// Label
__bbcc_00000020:
// JmpZero
	cmp #0, %r1
	jze [__bbcc_0000001f]
// Set
	mov WORD 4[%r11], %r0
// CallFunction
	push %r0
	call [advance]
	add #2, %r13
// Jmp
	jmp [__bbcc_0000001e]
// Label
__bbcc_0000001f:
// Set
	mov #1, %r1
// Set
	mov WORD 4[%r11], %r0
// CallFunction
	push %r0
	call [isAtEnd]
	add #2, %r13
// JmpNotZero
	cmp #0, %r0
	jnz [__bbcc_00000022]
// Set
	mov WORD 4[%r11], %r0
// CallFunction
	push %r0
	call [peek]
	add #2, %r13
// EqualJmp
	cmp #10, %r0
	jze [__bbcc_00000022]
// Set
	mov #0, %r1
// Label
__bbcc_00000022:
// JmpZero
	cmp #0, %r1
	jze [__bbcc_00000021]
// Set
	mov WORD 4[%r11], %r2
// Set
	mov WORD 6[%r11], %r1
// AddrOf
	lea WORD [__bbcc_000000b5], %r0
// Set
// CallFunction
	push %r0
	push %r1
	push %r2
	call [errorToken]
	add #6, %r13
// Return
	mov #0, %r0
	jmp [__bbcc_000000de]
// Label
__bbcc_00000021:
// Set
	mov WORD 4[%r11], %r0
// CallFunction
	push %r0
	call [advance]
	add #2, %r13
// Set
	mov WORD 4[%r11], %r2
// Set
	mov WORD 6[%r11], %r1
// Set
	mov #1, %r0
// CallFunction
	push %r0
	push %r1
	push %r2
	call [makeToken]
	add #6, %r13
// Return
	mov #0, %r0
__bbcc_000000de:
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: number
number:
	push %r11
	mov %r13, %r11
	push %r1
	push %r2
// Label
__bbcc_00000023:
// Set
	mov WORD 4[%r11], %r0
// CallFunction
	push %r0
	call [peek]
	add #2, %r13
// Set
// CallFunction
	push %r0
	call [isdigit]
	add #2, %r13
// JmpZero
	cmp #0, %r0
	jze [__bbcc_00000024]
// Set
	mov WORD 4[%r11], %r0
// CallFunction
	push %r0
	call [advance]
	add #2, %r13
// Jmp
	jmp [__bbcc_00000023]
// Label
__bbcc_00000024:
// Set
	mov WORD 4[%r11], %r2
// Set
	mov WORD 6[%r11], %r1
// Set
	mov #0, %r0
// CallFunction
	push %r0
	push %r1
	push %r2
	call [makeToken]
	add #6, %r13
// Return
	mov #0, %r0
__bbcc_000000df:
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: checkKeyword
checkKeyword:
	push %r11
	mov %r13, %r11
	push %r1
	push %r2
	push %r3
// Set
	mov #0, %r3
// ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 2[%r0], %r0
// ReadAt
	mov WORD 4[%r11], %r1
	mov WORD [%r1], %r1
// Set
// Sub
	sub %r1, %r0
// Add
	mov WORD 6[%r11], %r1
	add WORD 8[%r11], %r1
// NotEqualJmp
	cmp %r0, %r1
	jnz [__bbcc_00000026]
// ReadAt
	mov WORD 4[%r11], %r0
	mov WORD [%r0], %r0
// Set
	mov WORD 6[%r11], %r1
// Add
	add %r1, %r0
// Set
	mov %r0, %r2
// Set
	mov WORD 10[%r11], %r1
// Set
	mov WORD 8[%r11], %r0
// CallFunction
	push %r0
	push %r1
	push %r2
	call [memcmp]
	add #6, %r13
// NotEqualJmp
	cmp #0, %r0
	jnz [__bbcc_00000026]
// Set
	mov #1, %r3
// Label
__bbcc_00000026:
// JmpZero
	cmp #0, %r3
	jze [__bbcc_00000025]
// Return
	mov WORD 12[%r11], %r0
	jmp [__bbcc_000000e0]
// Label
__bbcc_00000025:
// Return
	mov #2, %r0
__bbcc_000000e0:
	pop %r3
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: identifierType
identifierType:
	push %r11
	mov %r13, %r11
	push %r1
	push %r2
	push %r3
	push %r4
	push %r5
	push %r6
// ReadAt
	mov WORD 4[%r11], %r0
	mov WORD [%r0], %r0
// ReadAt
	mov BYTE [%r0], %r0
// Set
	mov %r0, %r3
// ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 2[%r0], %r0
// ReadAt
	mov WORD 4[%r11], %r1
	mov WORD [%r1], %r1
// Set
// Sub
	sub %r1, %r0
// Set
// Set
	mov %r0, %r2
// NotEqualJmp
	cmp #98, %r3
	jnz [__bbcc_00000027]
// Set
	mov WORD 4[%r11], %r4
// AddrOf
	lea WORD [__bbcc_000000b6], %r0
// Set
	mov %r0, %r1
// Set
	mov #20, %r0
// CallFunction
	push %r0
	push %r1
	mov #4, %r5
	push %r5
	mov #1, %r6
	push %r6
	push %r4
	call [checkKeyword]
	add #10, %r13
// Return
	jmp [__bbcc_000000e1]
// Jmp
	jmp [__bbcc_00000028]
// Label
__bbcc_00000027:
// NotEqualJmp
	cmp #103, %r3
	jnz [__bbcc_00000029]
// Set
	mov WORD 4[%r11], %r4
// AddrOf
	lea WORD [__bbcc_000000b7], %r0
// Set
	mov %r0, %r1
// Set
	mov #41, %r0
// CallFunction
	push %r0
	push %r1
	mov #5, %r5
	push %r5
	mov #1, %r6
	push %r6
	push %r4
	call [checkKeyword]
	add #10, %r13
// Return
	jmp [__bbcc_000000e1]
// Jmp
	jmp [__bbcc_0000002a]
// Label
__bbcc_00000029:
// NotEqualJmp
	cmp #108, %r3
	jnz [__bbcc_0000002b]
// Set
	mov WORD 4[%r11], %r4
// AddrOf
	lea WORD [__bbcc_000000b8], %r0
// Set
	mov %r0, %r1
// Set
	mov #32, %r0
// CallFunction
	push %r0
	push %r1
	mov #5, %r5
	push %r5
	mov #1, %r6
	push %r6
	push %r4
	call [checkKeyword]
	add #10, %r13
// Return
	jmp [__bbcc_000000e1]
// Jmp
	jmp [__bbcc_0000002c]
// Label
__bbcc_0000002b:
// NotEqualJmp
	cmp #111, %r3
	jnz [__bbcc_0000002d]
// Set
	mov WORD 4[%r11], %r4
// AddrOf
	lea WORD [__bbcc_000000b9], %r0
// Set
	mov %r0, %r1
// Set
	mov #47, %r0
// CallFunction
	push %r0
	push %r1
	mov #1, %r5
	push %r5
	mov #1, %r6
	push %r6
	push %r4
	call [checkKeyword]
	add #10, %r13
// Return
	jmp [__bbcc_000000e1]
// Jmp
	jmp [__bbcc_0000002e]
// Label
__bbcc_0000002d:
// NotEqualJmp
	cmp #112, %r3
	jnz [__bbcc_0000002f]
// Set
	mov WORD 4[%r11], %r4
// AddrOf
	lea WORD [__bbcc_000000ba], %r0
// Set
	mov %r0, %r1
// Set
	mov #18, %r0
// CallFunction
	push %r0
	push %r1
	mov #3, %r5
	push %r5
	mov #1, %r6
	push %r6
	push %r4
	call [checkKeyword]
	add #10, %r13
// Return
	jmp [__bbcc_000000e1]
// Jmp
	jmp [__bbcc_00000030]
// Label
__bbcc_0000002f:
// NotEqualJmp
	cmp #121, %r3
	jnz [__bbcc_00000031]
// Set
	mov WORD 4[%r11], %r4
// AddrOf
	lea WORD [__bbcc_000000bb], %r0
// Set
	mov %r0, %r1
// Set
	mov #48, %r0
// CallFunction
	push %r0
	push %r1
	mov #4, %r5
	push %r5
	mov #1, %r6
	push %r6
	push %r4
	call [checkKeyword]
	add #10, %r13
// Return
	jmp [__bbcc_000000e1]
// Jmp
	jmp [__bbcc_00000032]
// Label
__bbcc_00000031:
// NotEqualJmp
	cmp #70, %r3
	jnz [__bbcc_00000033]
// Set
	mov WORD 4[%r11], %r4
// AddrOf
	lea WORD [__bbcc_000000bc], %r0
// Set
	mov %r0, %r1
// Set
	mov #14, %r0
// CallFunction
	push %r0
	push %r1
	mov #4, %r5
	push %r5
	mov #1, %r6
	push %r6
	push %r4
	call [checkKeyword]
	add #10, %r13
// Return
	jmp [__bbcc_000000e1]
// Jmp
	jmp [__bbcc_00000034]
// Label
__bbcc_00000033:
// NotEqualJmp
	cmp #84, %r3
	jnz [__bbcc_00000035]
// Set
	mov WORD 4[%r11], %r4
// AddrOf
	lea WORD [__bbcc_000000bd], %r0
// Set
	mov %r0, %r1
// Set
	mov #24, %r0
// CallFunction
	push %r0
	push %r1
	mov #3, %r5
	push %r5
	mov #1, %r6
	push %r6
	push %r4
	call [checkKeyword]
	add #10, %r13
// Return
	jmp [__bbcc_000000e1]
// Jmp
	jmp [__bbcc_00000036]
// Label
__bbcc_00000035:
// NotEqualJmp
	cmp #116, %r3
	jnz [__bbcc_00000037]
// Set
	mov WORD 4[%r11], %r4
// AddrOf
	lea WORD [__bbcc_000000be], %r0
// Set
	mov %r0, %r1
// Set
	mov #33, %r0
// CallFunction
	push %r0
	push %r1
	mov #2, %r5
	push %r5
	mov #1, %r6
	push %r6
	push %r4
	call [checkKeyword]
	add #10, %r13
// Return
	jmp [__bbcc_000000e1]
// Jmp
	jmp [__bbcc_00000038]
// Label
__bbcc_00000037:
// NotEqualJmp
	cmp #78, %r3
	jnz [__bbcc_00000039]
// Set
	mov WORD 4[%r11], %r4
// AddrOf
	lea WORD [__bbcc_000000bf], %r0
// Set
	mov %r0, %r1
// Set
	mov #19, %r0
// CallFunction
	push %r0
	push %r1
	mov #3, %r5
	push %r5
	mov #1, %r6
	push %r6
	push %r4
	call [checkKeyword]
	add #10, %r13
// Return
	jmp [__bbcc_000000e1]
// Jmp
	jmp [__bbcc_0000003a]
// Label
__bbcc_00000039:
// Set
	mov #0, %r0
// NotEqualJmp
	cmp #99, %r3
	jnz [__bbcc_0000003c]
// LessEqualJmp
	mov #1, %r1
	cmp %r2, %r1
	jle [__bbcc_0000003c]
// Set
	mov #1, %r0
// Label
__bbcc_0000003c:
// JmpZero
	cmp #0, %r0
	jze [__bbcc_0000003b]
// ReadAt
	mov WORD 4[%r11], %r0
	mov WORD [%r0], %r0
// ReadAt
	mov BYTE 1[%r0], %r0
// Set
	mov %r0, %r3
// NotEqualJmp
	cmp #108, %r3
	jnz [__bbcc_0000003d]
// Set
	mov WORD 4[%r11], %r4
// AddrOf
	lea WORD [__bbcc_000000ba], %r0
// Set
	mov %r0, %r1
// Set
	mov #15, %r0
// CallFunction
	push %r0
	push %r1
	mov #3, %r5
	push %r5
	mov #2, %r6
	push %r6
	push %r4
	call [checkKeyword]
	add #10, %r13
// Return
	jmp [__bbcc_000000e1]
// Jmp
	jmp [__bbcc_0000003e]
// Label
__bbcc_0000003d:
// NotEqualJmp
	cmp #111, %r3
	jnz [__bbcc_0000003f]
// Set
	mov WORD 4[%r11], %r4
// AddrOf
	lea WORD [__bbcc_000000c0], %r0
// Set
	mov %r0, %r1
// Set
	mov #30, %r0
// CallFunction
	push %r0
	push %r1
	mov #6, %r5
	push %r5
	mov #2, %r6
	push %r6
	push %r4
	call [checkKeyword]
	add #10, %r13
// Return
	jmp [__bbcc_000000e1]
// Label
__bbcc_0000003f:
// Label
__bbcc_0000003e:
// Jmp
	jmp [__bbcc_00000040]
// Label
__bbcc_0000003b:
// Set
	mov #0, %r0
// NotEqualJmp
	cmp #102, %r3
	jnz [__bbcc_00000042]
// LessEqualJmp
	mov #1, %r1
	cmp %r2, %r1
	jle [__bbcc_00000042]
// Set
	mov #1, %r0
// Label
__bbcc_00000042:
// JmpZero
	cmp #0, %r0
	jze [__bbcc_00000041]
// ReadAt
	mov WORD 4[%r11], %r0
	mov WORD [%r0], %r0
// ReadAt
	mov BYTE 1[%r0], %r0
// Set
	mov %r0, %r3
// NotEqualJmp
	cmp #105, %r3
	jnz [__bbcc_00000043]
// Set
	mov WORD 4[%r11], %r4
// AddrOf
	lea WORD [__bbcc_000000c1], %r0
// Set
	mov %r0, %r1
// Set
	mov #26, %r0
// CallFunction
	push %r0
	push %r1
	mov #5, %r5
	push %r5
	mov #2, %r6
	push %r6
	push %r4
	call [checkKeyword]
	add #10, %r13
// Return
	jmp [__bbcc_000000e1]
// Jmp
	jmp [__bbcc_00000044]
// Label
__bbcc_00000043:
// NotEqualJmp
	cmp #111, %r3
	jnz [__bbcc_00000045]
// Set
	mov WORD 4[%r11], %r4
// AddrOf
	lea WORD [__bbcc_000000b9], %r0
// Set
	mov %r0, %r1
// Set
	mov #31, %r0
// CallFunction
	push %r0
	push %r1
	mov #1, %r5
	push %r5
	mov #2, %r6
	push %r6
	push %r4
	call [checkKeyword]
	add #10, %r13
// Return
	jmp [__bbcc_000000e1]
// Jmp
	jmp [__bbcc_00000046]
// Label
__bbcc_00000045:
// NotEqualJmp
	cmp #114, %r3
	jnz [__bbcc_00000047]
// Set
	mov WORD 4[%r11], %r4
// AddrOf
	lea WORD [__bbcc_000000c2], %r0
// Set
	mov %r0, %r1
// Set
	mov #36, %r0
// CallFunction
	push %r0
	push %r1
	mov #2, %r5
	push %r5
	mov #2, %r6
	push %r6
	push %r4
	call [checkKeyword]
	add #10, %r13
// Return
	jmp [__bbcc_000000e1]
// Label
__bbcc_00000047:
// Label
__bbcc_00000046:
// Label
__bbcc_00000044:
// Jmp
	jmp [__bbcc_00000048]
// Label
__bbcc_00000041:
// Set
	mov #0, %r0
// NotEqualJmp
	cmp #114, %r3
	jnz [__bbcc_0000004a]
// LessEqualJmp
	mov #1, %r1
	cmp %r2, %r1
	jle [__bbcc_0000004a]
// Set
	mov #1, %r0
// Label
__bbcc_0000004a:
// JmpZero
	cmp #0, %r0
	jze [__bbcc_00000049]
// ReadAt
	mov WORD 4[%r11], %r0
	mov WORD [%r0], %r0
// ReadAt
	mov BYTE 1[%r0], %r0
// Set
	mov %r0, %r3
// NotEqualJmp
	cmp #97, %r3
	jnz [__bbcc_0000004b]
// Set
	mov WORD 4[%r11], %r4
// AddrOf
	lea WORD [__bbcc_000000c3], %r0
// Set
	mov %r0, %r1
// Set
	mov #23, %r0
// CallFunction
	push %r0
	push %r1
	mov #3, %r5
	push %r5
	mov #2, %r6
	push %r6
	push %r4
	call [checkKeyword]
	add #10, %r13
// Return
	jmp [__bbcc_000000e1]
// Jmp
	jmp [__bbcc_0000004c]
// Label
__bbcc_0000004b:
// NotEqualJmp
	cmp #101, %r3
	jnz [__bbcc_0000004d]
// Set
	mov WORD 4[%r11], %r4
// AddrOf
	lea WORD [__bbcc_000000c4], %r0
// Set
	mov %r0, %r1
// Set
	mov #28, %r0
// CallFunction
	push %r0
	push %r1
	mov #4, %r5
	push %r5
	mov #2, %r6
	push %r6
	push %r4
	call [checkKeyword]
	add #10, %r13
// Return
	jmp [__bbcc_000000e1]
// Label
__bbcc_0000004d:
// Label
__bbcc_0000004c:
// Jmp
	jmp [__bbcc_0000004e]
// Label
__bbcc_00000049:
// Set
	mov #0, %r0
// NotEqualJmp
	cmp #119, %r3
	jnz [__bbcc_00000050]
// LessEqualJmp
	mov #1, %r1
	cmp %r2, %r1
	jle [__bbcc_00000050]
// Set
	mov #1, %r0
// Label
__bbcc_00000050:
// JmpZero
	cmp #0, %r0
	jze [__bbcc_0000004f]
// ReadAt
	mov WORD 4[%r11], %r0
	mov WORD [%r0], %r0
// ReadAt
	mov BYTE 1[%r0], %r0
// Set
	mov %r0, %r3
// NotEqualJmp
	cmp #104, %r3
	jnz [__bbcc_00000051]
// Set
	mov WORD 4[%r11], %r4
// AddrOf
	lea WORD [__bbcc_000000c5], %r0
// Set
	mov %r0, %r1
// Set
	mov #38, %r0
// CallFunction
	push %r0
	push %r1
	mov #3, %r5
	push %r5
	mov #2, %r6
	push %r6
	push %r4
	call [checkKeyword]
	add #10, %r13
// Return
	jmp [__bbcc_000000e1]
// Jmp
	jmp [__bbcc_00000052]
// Label
__bbcc_00000051:
// NotEqualJmp
	cmp #105, %r3
	jnz [__bbcc_00000053]
// Set
	mov WORD 4[%r11], %r4
// AddrOf
	lea WORD [__bbcc_000000c6], %r0
// Set
	mov %r0, %r1
// Set
	mov #43, %r0
// CallFunction
	push %r0
	push %r1
	mov #2, %r5
	push %r5
	mov #2, %r6
	push %r6
	push %r4
	call [checkKeyword]
	add #10, %r13
// Return
	jmp [__bbcc_000000e1]
// Label
__bbcc_00000053:
// Label
__bbcc_00000052:
// Jmp
	jmp [__bbcc_00000054]
// Label
__bbcc_0000004f:
// Set
	mov #0, %r0
// NotEqualJmp
	cmp #105, %r3
	jnz [__bbcc_00000056]
// LessEqualJmp
	mov #1, %r1
	cmp %r2, %r1
	jle [__bbcc_00000056]
// Set
	mov #1, %r0
// Label
__bbcc_00000056:
// JmpZero
	cmp #0, %r0
	jze [__bbcc_00000055]
// ReadAt
	mov WORD 4[%r11], %r0
	mov WORD [%r0], %r0
// ReadAt
	mov BYTE 1[%r0], %r0
// Set
	mov %r0, %r3
// NotEqualJmp
	cmp #109, %r3
	jnz [__bbcc_00000057]
// Set
	mov WORD 4[%r11], %r4
// AddrOf
	lea WORD [__bbcc_000000c7], %r0
// Set
	mov %r0, %r1
// Set
	mov #17, %r0
// CallFunction
	push %r0
	push %r1
	mov #4, %r5
	push %r5
	mov #2, %r6
	push %r6
	push %r4
	call [checkKeyword]
	add #10, %r13
// Return
	jmp [__bbcc_000000e1]
// Jmp
	jmp [__bbcc_00000058]
// Label
__bbcc_00000057:
// NotEqualJmp
	cmp #110, %r3
	jnz [__bbcc_00000059]
// Return
	mov #22, %r0
	jmp [__bbcc_000000e1]
// Jmp
	jmp [__bbcc_0000005a]
// Label
__bbcc_00000059:
// NotEqualJmp
	cmp #115, %r3
	jnz [__bbcc_0000005b]
// Return
	mov #27, %r0
	jmp [__bbcc_000000e1]
// Jmp
	jmp [__bbcc_0000005c]
// Label
__bbcc_0000005b:
// NotEqualJmp
	cmp #102, %r3
	jnz [__bbcc_0000005d]
// Return
	mov #46, %r0
	jmp [__bbcc_000000e1]
// Label
__bbcc_0000005d:
// Label
__bbcc_0000005c:
// Label
__bbcc_0000005a:
// Label
__bbcc_00000058:
// Jmp
	jmp [__bbcc_0000005e]
// Label
__bbcc_00000055:
// Set
	mov #0, %r0
// NotEqualJmp
	cmp #97, %r3
	jnz [__bbcc_00000060]
// LessEqualJmp
	mov #1, %r1
	cmp %r2, %r1
	jle [__bbcc_00000060]
// Set
	mov #1, %r0
// Label
__bbcc_00000060:
// JmpZero
	cmp #0, %r0
	jze [__bbcc_0000005f]
// ReadAt
	mov WORD 4[%r11], %r0
	mov WORD [%r0], %r0
// ReadAt
	mov BYTE 1[%r0], %r0
// Set
	mov %r0, %r3
// NotEqualJmp
	cmp #119, %r3
	jnz [__bbcc_00000061]
// Set
	mov WORD 4[%r11], %r4
// AddrOf
	lea WORD [__bbcc_000000c8], %r0
// Set
	mov %r0, %r1
// Set
	mov #15, %r0
// CallFunction
	push %r0
	push %r1
	mov #3, %r5
	push %r5
	mov #2, %r6
	push %r6
	push %r4
	call [checkKeyword]
	add #10, %r13
// Return
	jmp [__bbcc_000000e1]
// Jmp
	jmp [__bbcc_00000062]
// Label
__bbcc_00000061:
// NotEqualJmp
	cmp #110, %r3
	jnz [__bbcc_00000063]
// Set
	mov WORD 4[%r11], %r4
// AddrOf
	lea WORD [__bbcc_000000c9], %r0
// Set
	mov %r0, %r1
// Set
	mov #29, %r0
// CallFunction
	push %r0
	push %r1
	mov #1, %r5
	push %r5
	mov #2, %r6
	push %r6
	push %r4
	call [checkKeyword]
	add #10, %r13
// Return
	jmp [__bbcc_000000e1]
// Jmp
	jmp [__bbcc_00000064]
// Label
__bbcc_00000063:
// Set
	mov #0, %r0
// NotEqualJmp
	cmp #115, %r3
	jnz [__bbcc_00000066]
// NotEqualJmp
	cmp #2, %r2
	jnz [__bbcc_00000066]
// Set
	mov #1, %r0
// Label
__bbcc_00000066:
// JmpZero
	cmp #0, %r0
	jze [__bbcc_00000065]
// Return
	mov #34, %r0
	jmp [__bbcc_000000e1]
// Jmp
	jmp [__bbcc_00000067]
// Label
__bbcc_00000065:
// Set
	mov #0, %r0
// LessEqualJmp
	mov #2, %r1
	cmp %r2, %r1
	jle [__bbcc_00000069]
// NotEqualJmp
	cmp #115, %r3
	jnz [__bbcc_00000069]
// Set
	mov #1, %r0
// Label
__bbcc_00000069:
// JmpZero
	cmp #0, %r0
	jze [__bbcc_00000068]
// ReadAt
	mov WORD 4[%r11], %r0
	mov WORD [%r0], %r0
// ReadAt
	mov BYTE 2[%r0], %r0
// Set
	mov %r0, %r3
// NotEqualJmp
	cmp #121, %r3
	jnz [__bbcc_0000006a]
// Set
	mov WORD 4[%r11], %r4
// AddrOf
	lea WORD [__bbcc_000000ca], %r0
// Set
	mov %r0, %r1
// Set
	mov #44, %r0
// CallFunction
	push %r0
	push %r1
	mov #2, %r5
	push %r5
	mov #3, %r6
	push %r6
	push %r4
	call [checkKeyword]
	add #10, %r13
// Return
	jmp [__bbcc_000000e1]
// Label
__bbcc_0000006a:
// NotEqualJmp
	cmp #115, %r3
	jnz [__bbcc_0000006b]
// Set
	mov WORD 4[%r11], %r4
// AddrOf
	lea WORD [__bbcc_000000cb], %r0
// Set
	mov %r0, %r1
// Set
	mov #39, %r0
// CallFunction
	push %r0
	push %r1
	mov #3, %r5
	push %r5
	mov #3, %r6
	push %r6
	push %r4
	call [checkKeyword]
	add #10, %r13
// Return
	jmp [__bbcc_000000e1]
// Label
__bbcc_0000006b:
// Label
__bbcc_00000068:
// Label
__bbcc_00000067:
// Label
__bbcc_00000064:
// Label
__bbcc_00000062:
// Jmp
	jmp [__bbcc_0000006c]
// Label
__bbcc_0000005f:
// Set
	mov #0, %r0
// NotEqualJmp
	cmp #101, %r3
	jnz [__bbcc_0000006e]
// LessEqualJmp
	mov #1, %r1
	cmp %r2, %r1
	jle [__bbcc_0000006e]
// Set
	mov #1, %r0
// Label
__bbcc_0000006e:
// JmpZero
	cmp #0, %r0
	jze [__bbcc_0000006d]
// ReadAt
	mov WORD 4[%r11], %r0
	mov WORD [%r0], %r0
// ReadAt
	mov BYTE 1[%r0], %r0
// Set
	mov %r0, %r3
// NotEqualJmp
	cmp #120, %r3
	jnz [__bbcc_0000006f]
// Set
	mov WORD 4[%r11], %r4
// AddrOf
	lea WORD [__bbcc_000000cc], %r0
// Set
	mov %r0, %r1
// Set
	mov #21, %r0
// CallFunction
	push %r0
	push %r1
	mov #4, %r5
	push %r5
	mov #2, %r6
	push %r6
	push %r4
	call [checkKeyword]
	add #10, %r13
// Return
	jmp [__bbcc_000000e1]
// Jmp
	jmp [__bbcc_00000070]
// Label
__bbcc_0000006f:
// Set
	mov #0, %r0
// LessEqualJmp
	mov #2, %r1
	cmp %r2, %r1
	jle [__bbcc_00000072]
// NotEqualJmp
	cmp #108, %r3
	jnz [__bbcc_00000072]
// Set
	mov #1, %r0
// Label
__bbcc_00000072:
// JmpZero
	cmp #0, %r0
	jze [__bbcc_00000071]
// ReadAt
	mov WORD 4[%r11], %r0
	mov WORD [%r0], %r0
// ReadAt
	mov BYTE 2[%r0], %r0
// Set
	mov %r0, %r3
// NotEqualJmp
	cmp #105, %r3
	jnz [__bbcc_00000073]
// Set
	mov WORD 4[%r11], %r4
// AddrOf
	lea WORD [__bbcc_000000cd], %r0
// Set
	mov %r0, %r1
// Set
	mov #45, %r0
// CallFunction
	push %r0
	push %r1
	mov #1, %r5
	push %r5
	mov #3, %r6
	push %r6
	push %r4
	call [checkKeyword]
	add #10, %r13
// Return
	jmp [__bbcc_000000e1]
// Label
__bbcc_00000073:
// NotEqualJmp
	cmp #115, %r3
	jnz [__bbcc_00000074]
// Set
	mov WORD 4[%r11], %r4
// AddrOf
	lea WORD [__bbcc_000000ce], %r0
// Set
	mov %r0, %r1
// Set
	mov #16, %r0
// CallFunction
	push %r0
	push %r1
	mov #1, %r5
	push %r5
	mov #3, %r6
	push %r6
	push %r4
	call [checkKeyword]
	add #10, %r13
// Return
	jmp [__bbcc_000000e1]
// Label
__bbcc_00000074:
// Label
__bbcc_00000071:
// Label
__bbcc_00000070:
// Jmp
	jmp [__bbcc_00000075]
// Label
__bbcc_0000006d:
// Set
	mov #0, %r1
// NotEqualJmp
	cmp #100, %r3
	jnz [__bbcc_00000077]
// LessEqualJmp
	mov #2, %r0
	cmp %r2, %r0
	jle [__bbcc_00000077]
// ReadAt
	mov WORD 4[%r11], %r0
	mov WORD [%r0], %r0
// ReadAt
	mov BYTE 1[%r0], %r0
// NotEqualJmp
	cmp #101, %r0
	jnz [__bbcc_00000077]
// Set
	mov #1, %r1
// Label
__bbcc_00000077:
// JmpZero
	cmp #0, %r1
	jze [__bbcc_00000076]
// ReadAt
	mov WORD 4[%r11], %r0
	mov WORD [%r0], %r0
// ReadAt
	mov BYTE 2[%r0], %r0
// Set
	mov %r0, %r3
// NotEqualJmp
	cmp #102, %r3
	jnz [__bbcc_00000078]
// Return
	mov #35, %r0
	jmp [__bbcc_000000e1]
// Jmp
	jmp [__bbcc_00000079]
// Label
__bbcc_00000078:
// NotEqualJmp
	cmp #108, %r3
	jnz [__bbcc_0000007a]
// Return
	mov #40, %r0
	jmp [__bbcc_000000e1]
// Label
__bbcc_0000007a:
// Label
__bbcc_00000079:
// Jmp
	jmp [__bbcc_0000007b]
// Label
__bbcc_00000076:
// Set
	mov #0, %r1
// NotEqualJmp
	cmp #110, %r3
	jnz [__bbcc_0000007d]
// LessEqualJmp
	mov #2, %r0
	cmp %r2, %r0
	jle [__bbcc_0000007d]
// ReadAt
	mov WORD 4[%r11], %r0
	mov WORD [%r0], %r0
// ReadAt
	mov BYTE 1[%r0], %r0
// NotEqualJmp
	cmp #111, %r0
	jnz [__bbcc_0000007d]
// Set
	mov #1, %r1
// Label
__bbcc_0000007d:
// JmpZero
	cmp #0, %r1
	jze [__bbcc_0000007c]
// ReadAt
	mov WORD 4[%r11], %r0
	mov WORD [%r0], %r0
// ReadAt
	mov BYTE 2[%r0], %r0
// Set
	mov %r0, %r3
// NotEqualJmp
	cmp #116, %r3
	jnz [__bbcc_0000007e]
// Return
	mov #42, %r0
	jmp [__bbcc_000000e1]
// Jmp
	jmp [__bbcc_0000007f]
// Label
__bbcc_0000007e:
// NotEqualJmp
	cmp #110, %r3
	jnz [__bbcc_00000080]
// Set
	mov WORD 4[%r11], %r2
// AddrOf
	lea WORD [__bbcc_000000cf], %r0
// Set
	mov %r0, %r1
// Set
	mov #37, %r0
// CallFunction
	push %r0
	push %r1
	mov #5, %r3
	push %r3
	mov #3, %r4
	push %r4
	push %r2
	call [checkKeyword]
	add #10, %r13
// Return
	jmp [__bbcc_000000e1]
// Label
__bbcc_00000080:
// Label
__bbcc_0000007f:
// Label
__bbcc_0000007c:
// Label
__bbcc_0000007b:
// Label
__bbcc_00000075:
// Label
__bbcc_0000006c:
// Label
__bbcc_0000005e:
// Label
__bbcc_00000054:
// Label
__bbcc_0000004e:
// Label
__bbcc_00000048:
// Label
__bbcc_00000040:
// Label
__bbcc_0000003a:
// Label
__bbcc_00000038:
// Label
__bbcc_00000036:
// Label
__bbcc_00000034:
// Label
__bbcc_00000032:
// Label
__bbcc_00000030:
// Label
__bbcc_0000002e:
// Label
__bbcc_0000002c:
// Label
__bbcc_0000002a:
// Label
__bbcc_00000028:
// Return
	mov #2, %r0
__bbcc_000000e1:
	pop %r6
	pop %r5
	pop %r4
	pop %r3
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: identifier
identifier:
	push %r11
	mov %r13, %r11
	push %r1
	push %r2
// Label
__bbcc_00000081:
// Set
	mov #1, %r1
// Set
	mov WORD 4[%r11], %r0
// CallFunction
	push %r0
	call [peek]
	add #2, %r13
// CallFunction
	push %r0
	call [isAlpha]
	add #2, %r13
// JmpNotZero
	cmp #0, %r0
	jnz [__bbcc_00000083]
// Set
	mov WORD 4[%r11], %r0
// CallFunction
	push %r0
	call [peek]
	add #2, %r13
// Set
// CallFunction
	push %r0
	call [isdigit]
	add #2, %r13
// JmpNotZero
	cmp #0, %r0
	jnz [__bbcc_00000083]
// Set
	mov #0, %r1
// Label
__bbcc_00000083:
// JmpZero
	cmp #0, %r1
	jze [__bbcc_00000082]
// Set
	mov WORD 4[%r11], %r0
// CallFunction
	push %r0
	call [advance]
	add #2, %r13
// Jmp
	jmp [__bbcc_00000081]
// Label
__bbcc_00000082:
// Set
	mov WORD 4[%r11], %r2
// Set
	mov WORD 6[%r11], %r1
// Set
	mov WORD 4[%r11], %r0
// CallFunction
	push %r0
	call [identifierType]
	add #2, %r13
// CallFunction
	push %r0
	push %r1
	push %r2
	call [makeToken]
	add #6, %r13
// Return
	mov #0, %r0
__bbcc_000000e2:
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret
// Function: scanToken
scanToken:
	push %r11
	mov %r13, %r11
	push %r1
	push %r2
	push %r3
	push %r4
// ReadAt
	mov WORD 4[%r11], %r0
	mov BYTE 6[%r0], %r0
// JmpZero
	cmp #0, %r0
	jze [__bbcc_00000084]
// Set
	mov #0, %r0
// SetAt
	mov 4[%r11], %r1
	mov %r0, BYTE 6[%r1]
// ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 2[%r0], %r0
// Set
// SetAt
	mov 4[%r11], %r1
	mov %r0, WORD [%r1]
// Set
	mov WORD 4[%r11], %r1
// Set
	mov WORD 6[%r11], %r0
// CallFunction
	push %r0
	push %r1
	call [indent]
	add #4, %r13
// JmpZero
	cmp #0, %r0
	jze [__bbcc_00000085]
// Return
	mov #0, %r0
	jmp [__bbcc_000000e3]
// Label
__bbcc_00000085:
// Label
__bbcc_00000084:
// Set
	mov WORD 4[%r11], %r0
// CallFunction
	push %r0
	call [skipWhitespace]
	add #2, %r13
// ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 2[%r0], %r0
// Set
// SetAt
	mov 4[%r11], %r1
	mov %r0, WORD [%r1]
// Set
	mov WORD 4[%r11], %r0
// CallFunction
	push %r0
	call [isAtEnd]
	add #2, %r13
// JmpZero
	cmp #0, %r0
	jze [__bbcc_00000086]
// Set
	mov WORD 4[%r11], %r2
// Set
	mov WORD 6[%r11], %r1
// Set
	mov #56, %r0
// CallFunction
	push %r0
	push %r1
	push %r2
	call [makeToken]
	add #6, %r13
// Return
	mov #0, %r0
	jmp [__bbcc_000000e3]
// Label
__bbcc_00000086:
// Set
	mov WORD 4[%r11], %r0
// CallFunction
	push %r0
	call [advance]
	add #2, %r13
// Set
	mov %r0, %r2
// NotEqualJmp
	cmp #10, %r2
	jnz [__bbcc_00000087]
// Set
	mov WORD 4[%r11], %r3
// Set
	mov WORD 6[%r11], %r1
// Set
	mov #58, %r0
// CallFunction
	push %r0
	push %r1
	push %r3
	call [makeToken]
	add #6, %r13
// SetAt
	mov 6[%r11], %r0
	mov #0, %r1
	mov %r1, WORD 4[%r0]
// ReadAt
	mov WORD 4[%r11], %r0
	mov WORD 4[%r0], %r1
// Set
	mov %r1, %r0
// Add
	mov #1, %r0
	add %r1, %r0
// SetAt
	mov 4[%r11], %r1
	mov %r0, WORD 4[%r1]
// Set
	mov #1, %r0
// SetAt
	mov 4[%r11], %r1
	mov %r0, BYTE 6[%r1]
// Return
	mov #0, %r0
	jmp [__bbcc_000000e3]
// Jmp
	jmp [__bbcc_00000088]
// Label
__bbcc_00000087:
// NotEqualJmp
	cmp #43, %r2
	jnz [__bbcc_00000089]
// Set
	mov WORD 4[%r11], %r3
// Set
	mov WORD 6[%r11], %r1
// Set
	mov #3, %r0
// CallFunction
	push %r0
	push %r1
	push %r3
	call [makeToken]
	add #6, %r13
// Return
	mov #0, %r0
	jmp [__bbcc_000000e3]
// Jmp
	jmp [__bbcc_0000008a]
// Label
__bbcc_00000089:
// NotEqualJmp
	cmp #45, %r2
	jnz [__bbcc_0000008b]
// Set
	mov WORD 4[%r11], %r3
// Set
	mov WORD 6[%r11], %r1
// Set
	mov #4, %r0
// CallFunction
	push %r0
	push %r1
	push %r3
	call [makeToken]
	add #6, %r13
// Return
	mov #0, %r0
	jmp [__bbcc_000000e3]
// Jmp
	jmp [__bbcc_0000008c]
// Label
__bbcc_0000008b:
// NotEqualJmp
	cmp #47, %r2
	jnz [__bbcc_0000008d]
// Set
	mov WORD 4[%r11], %r3
// Set
	mov WORD 6[%r11], %r1
// Set
	mov #5, %r0
// CallFunction
	push %r0
	push %r1
	push %r3
	call [makeToken]
	add #6, %r13
// Return
	mov #0, %r0
	jmp [__bbcc_000000e3]
// Jmp
	jmp [__bbcc_0000008e]
// Label
__bbcc_0000008d:
// NotEqualJmp
	cmp #42, %r2
	jnz [__bbcc_0000008f]
// Set
	mov WORD 4[%r11], %r3
// Set
	mov WORD 6[%r11], %r1
// Set
	mov #6, %r0
// CallFunction
	push %r0
	push %r1
	push %r3
	call [makeToken]
	add #6, %r13
// Return
	mov #0, %r0
	jmp [__bbcc_000000e3]
// Jmp
	jmp [__bbcc_00000090]
// Label
__bbcc_0000008f:
// NotEqualJmp
	cmp #40, %r2
	jnz [__bbcc_00000091]
// Set
	mov WORD 4[%r11], %r3
// Set
	mov WORD 6[%r11], %r1
// Set
	mov #10, %r0
// CallFunction
	push %r0
	push %r1
	push %r3
	call [makeToken]
	add #6, %r13
// Return
	mov #0, %r0
	jmp [__bbcc_000000e3]
// Jmp
	jmp [__bbcc_00000092]
// Label
__bbcc_00000091:
// NotEqualJmp
	cmp #41, %r2
	jnz [__bbcc_00000093]
// Set
	mov WORD 4[%r11], %r3
// Set
	mov WORD 6[%r11], %r1
// Set
	mov #11, %r0
// CallFunction
	push %r0
	push %r1
	push %r3
	call [makeToken]
	add #6, %r13
// Return
	mov #0, %r0
	jmp [__bbcc_000000e3]
// Jmp
	jmp [__bbcc_00000094]
// Label
__bbcc_00000093:
// NotEqualJmp
	cmp #123, %r2
	jnz [__bbcc_00000095]
// Set
	mov WORD 4[%r11], %r3
// Set
	mov WORD 6[%r11], %r1
// Set
	mov #12, %r0
// CallFunction
	push %r0
	push %r1
	push %r3
	call [makeToken]
	add #6, %r13
// Return
	mov #0, %r0
	jmp [__bbcc_000000e3]
// Jmp
	jmp [__bbcc_00000096]
// Label
__bbcc_00000095:
// NotEqualJmp
	cmp #125, %r2
	jnz [__bbcc_00000097]
// Set
	mov WORD 4[%r11], %r3
// Set
	mov WORD 6[%r11], %r1
// Set
	mov #13, %r0
// CallFunction
	push %r0
	push %r1
	push %r3
	call [makeToken]
	add #6, %r13
// Return
	mov #0, %r0
	jmp [__bbcc_000000e3]
// Jmp
	jmp [__bbcc_00000098]
// Label
__bbcc_00000097:
// NotEqualJmp
	cmp #44, %r2
	jnz [__bbcc_00000099]
// Set
	mov WORD 4[%r11], %r3
// Set
	mov WORD 6[%r11], %r1
// Set
	mov #7, %r0
// CallFunction
	push %r0
	push %r1
	push %r3
	call [makeToken]
	add #6, %r13
// Return
	mov #0, %r0
	jmp [__bbcc_000000e3]
// Jmp
	jmp [__bbcc_0000009a]
// Label
__bbcc_00000099:
// NotEqualJmp
	cmp #46, %r2
	jnz [__bbcc_0000009b]
// Set
	mov WORD 4[%r11], %r3
// Set
	mov WORD 6[%r11], %r1
// Set
	mov #8, %r0
// CallFunction
	push %r0
	push %r1
	push %r3
	call [makeToken]
	add #6, %r13
// Return
	mov #0, %r0
	jmp [__bbcc_000000e3]
// Jmp
	jmp [__bbcc_0000009c]
// Label
__bbcc_0000009b:
// NotEqualJmp
	cmp #58, %r2
	jnz [__bbcc_0000009d]
// Set
	mov WORD 4[%r11], %r3
// Set
	mov WORD 6[%r11], %r1
// Set
	mov #9, %r0
// CallFunction
	push %r0
	push %r1
	push %r3
	call [makeToken]
	add #6, %r13
// Return
	mov #0, %r0
	jmp [__bbcc_000000e3]
// Jmp
	jmp [__bbcc_0000009e]
// Label
__bbcc_0000009d:
// Set
	mov #0, %r3
// NotEqualJmp
	cmp #33, %r2
	jnz [__bbcc_000000a0]
// Set
	mov WORD 4[%r11], %r1
// Set
	mov #61, %r0
// CallFunction
	push %r0
	push %r1
	call [match]
	add #4, %r13
// JmpZero
	cmp #0, %r0
	jze [__bbcc_000000a0]
// Set
	mov #1, %r3
// Label
__bbcc_000000a0:
// JmpZero
	cmp #0, %r3
	jze [__bbcc_0000009f]
// Set
	mov WORD 4[%r11], %r3
// Set
	mov WORD 6[%r11], %r1
// Set
	mov #51, %r0
// CallFunction
	push %r0
	push %r1
	push %r3
	call [makeToken]
	add #6, %r13
// Return
	mov #0, %r0
	jmp [__bbcc_000000e3]
// Jmp
	jmp [__bbcc_000000a1]
// Label
__bbcc_0000009f:
// NotEqualJmp
	cmp #61, %r2
	jnz [__bbcc_000000a2]
// Set
	mov WORD 4[%r11], %r4
// Set
	mov WORD 6[%r11], %r3
// Set
	mov WORD 4[%r11], %r1
// Set
	mov #61, %r0
// CallFunction
	push %r0
	push %r1
	call [match]
	add #4, %r13
// JmpZero
	cmp #0, %r0
	jze [__bbcc_000000a3]
// Set
	mov #50, %r0
// Jmp
	jmp [__bbcc_000000a4]
// Label
__bbcc_000000a3:
// Set
	mov #49, %r0
// Label
__bbcc_000000a4:
// Set
// CallFunction
	push %r0
	push %r3
	push %r4
	call [makeToken]
	add #6, %r13
// Return
	mov #0, %r0
	jmp [__bbcc_000000e3]
// Jmp
	jmp [__bbcc_000000a5]
// Label
__bbcc_000000a2:
// NotEqualJmp
	cmp #60, %r2
	jnz [__bbcc_000000a6]
// Set
	mov WORD 4[%r11], %r4
// Set
	mov WORD 6[%r11], %r3
// Set
	mov WORD 4[%r11], %r1
// Set
	mov #61, %r0
// CallFunction
	push %r0
	push %r1
	call [match]
	add #4, %r13
// JmpZero
	cmp #0, %r0
	jze [__bbcc_000000a7]
// Set
	mov #55, %r0
// Jmp
	jmp [__bbcc_000000a8]
// Label
__bbcc_000000a7:
// Set
	mov #54, %r0
// Label
__bbcc_000000a8:
// Set
// CallFunction
	push %r0
	push %r3
	push %r4
	call [makeToken]
	add #6, %r13
// Return
	mov #0, %r0
	jmp [__bbcc_000000e3]
// Jmp
	jmp [__bbcc_000000a9]
// Label
__bbcc_000000a6:
// NotEqualJmp
	cmp #62, %r2
	jnz [__bbcc_000000aa]
// Set
	mov WORD 4[%r11], %r4
// Set
	mov WORD 6[%r11], %r3
// Set
	mov WORD 4[%r11], %r1
// Set
	mov #61, %r0
// CallFunction
	push %r0
	push %r1
	call [match]
	add #4, %r13
// JmpZero
	cmp #0, %r0
	jze [__bbcc_000000ab]
// Set
	mov #53, %r0
// Jmp
	jmp [__bbcc_000000ac]
// Label
__bbcc_000000ab:
// Set
	mov #52, %r0
// Label
__bbcc_000000ac:
// Set
// CallFunction
	push %r0
	push %r3
	push %r4
	call [makeToken]
	add #6, %r13
// Return
	mov #0, %r0
	jmp [__bbcc_000000e3]
// Jmp
	jmp [__bbcc_000000ad]
// Label
__bbcc_000000aa:
// Set
	mov #1, %r0
// EqualJmp
	cmp #34, %r2
	jze [__bbcc_000000af]
// EqualJmp
	cmp #39, %r2
	jze [__bbcc_000000af]
// Set
	mov #0, %r0
// Label
__bbcc_000000af:
// JmpZero
	cmp #0, %r0
	jze [__bbcc_000000ae]
// Set
	mov WORD 4[%r11], %r1
// Set
	mov WORD 6[%r11], %r0
// CallFunction
	push %r2
	push %r0
	push %r1
	call [string]
	add #6, %r13
// Return
	mov #0, %r0
	jmp [__bbcc_000000e3]
// Jmp
	jmp [__bbcc_000000b0]
// Label
__bbcc_000000ae:
// Set
	mov %r2, %r0
// CallFunction
	push %r0
	call [isdigit]
	add #2, %r13
// JmpZero
	cmp #0, %r0
	jze [__bbcc_000000b1]
// Set
	mov WORD 4[%r11], %r1
// Set
	mov WORD 6[%r11], %r0
// CallFunction
	push %r0
	push %r1
	call [number]
	add #4, %r13
// Return
	mov #0, %r0
	jmp [__bbcc_000000e3]
// Jmp
	jmp [__bbcc_000000b2]
// Label
__bbcc_000000b1:
// CallFunction
	push %r2
	call [isAlpha]
	add #2, %r13
// JmpZero
	cmp #0, %r0
	jze [__bbcc_000000b3]
// Set
	mov WORD 4[%r11], %r1
// Set
	mov WORD 6[%r11], %r0
// CallFunction
	push %r0
	push %r1
	call [identifier]
	add #4, %r13
// Return
	mov #0, %r0
	jmp [__bbcc_000000e3]
// Label
__bbcc_000000b3:
// Label
__bbcc_000000b2:
// Label
__bbcc_000000b0:
// Label
__bbcc_000000ad:
// Label
__bbcc_000000a9:
// Label
__bbcc_000000a5:
// Label
__bbcc_000000a1:
// Label
__bbcc_0000009e:
// Label
__bbcc_0000009c:
// Label
__bbcc_0000009a:
// Label
__bbcc_00000098:
// Label
__bbcc_00000096:
// Label
__bbcc_00000094:
// Label
__bbcc_00000092:
// Label
__bbcc_00000090:
// Label
__bbcc_0000008e:
// Label
__bbcc_0000008c:
// Label
__bbcc_0000008a:
// Label
__bbcc_00000088:
// Set
	mov WORD 4[%r11], %r2
// Set
	mov WORD 6[%r11], %r1
// AddrOf
	lea WORD [__bbcc_000000d0], %r0
// Set
// CallFunction
	push %r0
	push %r1
	push %r2
	call [errorToken]
	add #6, %r13
// Return
	mov #0, %r0
__bbcc_000000e3:
	pop %r4
	pop %r3
	pop %r2
	pop %r1
	mov %r11, %r13
	pop %r11
	ret