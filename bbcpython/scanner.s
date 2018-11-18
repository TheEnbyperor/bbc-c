.import strlen
.import memcmp
.import isalpha
.import isdigit
.export initScanner
.export scanToken
__bbcc_000000b6:
.byte #73,#110,#118,#97,#108,#105,#100,#32,#105,#110,#100,#101,#110,#116,#46,#0
__bbcc_000000b7:
.byte #85,#110,#116,#101,#114,#109,#105,#110,#97,#116,#101,#100,#32,#115,#116,#114,#105,#110,#103,#46,#0
__bbcc_000000b8:
.byte #114,#101,#97,#107,#0
__bbcc_000000b9:
.byte #108,#111,#98,#97,#108,#0
__bbcc_000000ba:
.byte #97,#109,#98,#100,#97,#0
__bbcc_000000bb:
.byte #114,#0
__bbcc_000000bc:
.byte #97,#115,#115,#0
__bbcc_000000bd:
.byte #105,#101,#108,#100,#0
__bbcc_000000be:
.byte #97,#108,#115,#101,#0
__bbcc_000000bf:
.byte #114,#117,#101,#0
__bbcc_000000c0:
.byte #114,#121,#0
__bbcc_000000c1:
.byte #111,#110,#101,#0
__bbcc_000000c2:
.byte #110,#116,#105,#110,#117,#101,#0
__bbcc_000000c3:
.byte #110,#97,#108,#108,#121,#0
__bbcc_000000c4:
.byte #111,#109,#0
__bbcc_000000c5:
.byte #105,#115,#101,#0
__bbcc_000000c6:
.byte #116,#117,#114,#110,#0
__bbcc_000000c7:
.byte #105,#108,#101,#0
__bbcc_000000c8:
.byte #116,#104,#0
__bbcc_000000c9:
.byte #112,#111,#114,#116,#0
__bbcc_000000ca:
.byte #97,#105,#116,#0
__bbcc_000000cb:
.byte #100,#0
__bbcc_000000cc:
.byte #110,#99,#0
__bbcc_000000cd:
.byte #101,#114,#116,#0
__bbcc_000000ce:
.byte #99,#101,#112,#116,#0
__bbcc_000000cf:
.byte #102,#0
__bbcc_000000d0:
.byte #101,#0
__bbcc_000000d1:
.byte #108,#111,#99,#97,#108,#0
__bbcc_000000d2:
.byte #85,#110,#101,#120,#112,#101,#99,#116,#101,#100,#32,#99,#104,#97,#114,#97,#99,#116,#101,#114,#0
// Function: initScanner
initScanner:
	push %r12
	mov %r14, %r12
	push %r1
// Set
	mov DWORD 12[%r12], %r0
// SetAt
	mov 8[%r12], %r1
	mov %r0, DWORD [%r1]
// Set
	mov DWORD 12[%r12], %r0
// SetAt
	mov 8[%r12], %r1
	mov %r0, DWORD 4[%r1]
// SetAt
	mov 8[%r12], %r0
	mov #1, %r1
	mov %r1, DWORD 8[%r0]
// Set
	mov #1, %r0
// SetAt
	mov 8[%r12], %r1
	mov %r0, BYTE 12[%r1]
// Add
	mov DWORD 8[%r12], %r0
	add #13, %r0
// Set
// SetAt
	mov 8[%r12], %r1
	mov %r0, DWORD 93[%r1]
// Set
	mov DWORD 8[%r12], %r0
// CallFunction
	mov #0, %r1
	push %r1
	push %r0
	call [pushIndent]
	add #8, %r14
// Return
	mov #0, %r0
__bbcc_000000d3:
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: isAtEnd
isAtEnd:
	push %r12
	mov %r14, %r12
	push %r1
// ReadAt
	mov DWORD 8[%r12], %r0
	mov DWORD 4[%r0], %r0
// ReadAt
	mov BYTE [%r0], %r1
// EqualCmp
	cmp #0, %r1
	sze %r0
// Return
__bbcc_000000d4:
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: pushIndent
pushIndent:
	push %r12
	mov %r14, %r12
	push %r1
// ReadAt
	mov DWORD 8[%r12], %r0
	mov DWORD 93[%r0], %r0
// SetAt
	mov 12[%r12], %r1
	mov %r1, DWORD [%r0]
// ReadAt
	mov DWORD 8[%r12], %r0
	mov DWORD 93[%r0], %r0
// Add
	add #4, %r0
// SetAt
	mov 8[%r12], %r1
	mov %r0, DWORD 93[%r1]
// Return
	mov #0, %r0
__bbcc_000000d5:
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: popIndent
popIndent:
	push %r12
	mov %r14, %r12
	push %r1
// ReadAt
	mov DWORD 8[%r12], %r0
	mov DWORD 93[%r0], %r0
// Sub
	sub #4, %r0
// SetAt
	mov 8[%r12], %r1
	mov %r0, DWORD 93[%r1]
// ReadAt
	mov DWORD 8[%r12], %r0
	mov DWORD 93[%r0], %r0
// ReadAt
	mov DWORD [%r0], %r0
// Return
__bbcc_000000d6:
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: peekIndent
peekIndent:
	push %r12
	mov %r14, %r12
	push %r1
	push %r2
// ReadAt
	mov DWORD 8[%r12], %r0
	mov DWORD 93[%r0], %r2
// Neg
	mov #-1, %r1
// Mult
	mov #4, %r0
	mul %r1, %r0
// ReadAt
	mov %r2, %r1
	add %r0, %r1
	mov DWORD [%r1], %r0
// Return
__bbcc_000000d7:
	pop %r2
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: makeToken
makeToken:
	push %r12
	mov %r14, %r12
	push %r1
// SetAt
	mov 12[%r12], %r0
	mov 16[%r12], %r1
	mov %r1, DWORD [%r0]
// ReadAt
	mov DWORD 8[%r12], %r0
	mov DWORD [%r0], %r0
// Set
// SetAt
	mov 12[%r12], %r1
	mov %r0, DWORD 4[%r1]
// ReadAt
	mov DWORD 8[%r12], %r0
	mov DWORD 4[%r0], %r0
// ReadAt
	mov DWORD 8[%r12], %r1
	mov DWORD [%r1], %r1
// Set
// Sub
	sub %r1, %r0
// Set
// SetAt
	mov 12[%r12], %r1
	mov %r0, DWORD 8[%r1]
// ReadAt
	mov DWORD 8[%r12], %r0
	mov DWORD 8[%r0], %r0
// SetAt
	mov 12[%r12], %r1
	mov %r0, DWORD 12[%r1]
// Return
	mov #0, %r0
__bbcc_000000d8:
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: errorToken
errorToken:
	push %r12
	mov %r14, %r12
	push %r1
// Set
	mov #57, %r0
// SetAt
	mov 12[%r12], %r1
	mov %r0, DWORD [%r1]
// Set
	mov DWORD 16[%r12], %r0
// SetAt
	mov 12[%r12], %r1
	mov %r0, DWORD 4[%r1]
// Set
	mov DWORD 16[%r12], %r0
// CallFunction
	push %r0
	call [strlen]
	add #4, %r14
// Set
// SetAt
	mov 12[%r12], %r1
	mov %r0, DWORD 8[%r1]
// ReadAt
	mov DWORD 8[%r12], %r0
	mov DWORD 8[%r0], %r0
// SetAt
	mov 12[%r12], %r1
	mov %r0, DWORD 12[%r1]
// Return
	mov #0, %r0
__bbcc_000000d9:
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: advance
advance:
	push %r12
	mov %r14, %r12
	push %r1
	push %r2
// ReadAt
	mov DWORD 8[%r12], %r0
	mov DWORD 4[%r0], %r0
// ReadAt
	mov BYTE [%r0], %r0
// Set
	mov %r0, %r2
// ReadAt
	mov DWORD 8[%r12], %r0
	mov DWORD 4[%r0], %r0
// Set
	mov %r0, %r1
// Add
	add #1, %r0
// SetAt
	mov 8[%r12], %r1
	mov %r0, DWORD 4[%r1]
// Return
	mov %r2, %r0
__bbcc_000000da:
	pop %r2
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: peek
peek:
	push %r12
	mov %r14, %r12
// ReadAt
	mov DWORD 8[%r12], %r0
	mov DWORD 4[%r0], %r0
// ReadAt
	mov BYTE [%r0], %r0
// Return
__bbcc_000000db:
	mov %r12, %r14
	pop %r12
	ret
// Function: match
match:
	push %r12
	mov %r14, %r12
	push %r1
// Set
	mov DWORD 8[%r12], %r0
// CallFunction
	push %r0
	call [isAtEnd]
	add #4, %r14
// JmpZero
	cmp #0, %r0
	jze [__bbcc_00000000]
// Return
	mov #0, %r0
	jmp [__bbcc_000000dc]
// Label
__bbcc_00000000:
// ReadAt
	mov DWORD 8[%r12], %r0
	mov DWORD 4[%r0], %r0
// ReadAt
	mov BYTE [%r0], %r0
// EqualJmp
	cmp 12[%r12], %r0
	jze [__bbcc_00000001]
// Return
	mov #0, %r0
	jmp [__bbcc_000000dc]
// Label
__bbcc_00000001:
// ReadAt
	mov DWORD 8[%r12], %r0
	mov DWORD 4[%r0], %r0
// Set
	mov %r0, %r1
// Add
	add #1, %r0
// SetAt
	mov 8[%r12], %r1
	mov %r0, DWORD 4[%r1]
// Return
	mov #1, %r0
__bbcc_000000dc:
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: skipWhitespace
skipWhitespace:
	push %r12
	mov %r14, %r12
	push %r1
// Label
__bbcc_00000002:
// Set
	mov DWORD 8[%r12], %r0
// CallFunction
	push %r0
	call [peek]
	add #4, %r14
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
	mov DWORD 8[%r12], %r0
// CallFunction
	push %r0
	call [advance]
	add #4, %r14
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
	mov DWORD 8[%r12], %r0
// CallFunction
	push %r0
	call [peek]
	add #4, %r14
// EqualJmp
	cmp #10, %r0
	jze [__bbcc_0000000b]
// Set
	mov DWORD 8[%r12], %r0
// CallFunction
	push %r0
	call [isAtEnd]
	add #4, %r14
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
	mov DWORD 8[%r12], %r0
// CallFunction
	push %r0
	call [advance]
	add #4, %r14
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
	jmp [__bbcc_000000dd]
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
__bbcc_000000dd:
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: indent
indent:
	push %r12
	mov %r14, %r12
	push %r1
	push %r2
	push %r3
	push %r4
// Set
	mov #0, %r1
// Label
__bbcc_0000000d:
// Set
	mov DWORD 8[%r12], %r0
// CallFunction
	push %r0
	call [peek]
	add #4, %r14
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
	mov DWORD 8[%r12], %r0
// CallFunction
	push %r0
	call [advance]
	add #4, %r14
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
// NotEqualJmp
	cmp #10, %r2
	jnz [__bbcc_00000015]
// Return
	mov #0, %r0
	jmp [__bbcc_000000de]
// Jmp
	jmp [__bbcc_00000016]
// Label
__bbcc_00000015:
// Jmp
	jmp [__bbcc_0000000f]
// Label
__bbcc_00000016:
// Label
__bbcc_00000014:
// Label
__bbcc_0000000e:
// Jmp
	jmp [__bbcc_0000000d]
// Label
__bbcc_0000000f:
// Set
	mov DWORD 8[%r12], %r0
// CallFunction
	push %r0
	call [peekIndent]
	add #4, %r14
// Set
	mov %r0, %r4
// NotEqualJmp
	cmp %r1, %r4
	jnz [__bbcc_00000017]
// Return
	mov #0, %r0
	jmp [__bbcc_000000de]
// Jmp
	jmp [__bbcc_00000018]
// Label
__bbcc_00000017:
// LessEqualJmp
	cmp %r1, %r4
	jle [__bbcc_00000019]
// Set
	mov DWORD 8[%r12], %r0
// CallFunction
	push %r1
	push %r0
	call [pushIndent]
	add #8, %r14
// Set
	mov DWORD 8[%r12], %r3
// Set
	mov DWORD 12[%r12], %r2
// Set
	mov #59, %r0
// CallFunction
	push %r0
	push %r2
	push %r3
	call [makeToken]
	add #12, %r14
// Return
	mov #1, %r0
	jmp [__bbcc_000000de]
// Jmp
	jmp [__bbcc_0000001a]
// Label
__bbcc_00000019:
// MoreEqualJmp
	cmp %r1, %r4
	jge [__bbcc_0000001b]
// Label
__bbcc_0000001c:
// Set
	mov DWORD 8[%r12], %r0
// CallFunction
	push %r0
	call [popIndent]
	add #4, %r14
// Set
	mov DWORD 8[%r12], %r0
// CallFunction
	push %r0
	call [peekIndent]
	add #4, %r14
// Set
	mov %r0, %r4
// NotEqualJmp
	cmp %r0, %r1
	jnz [__bbcc_0000001e]
// Set
	mov DWORD 8[%r12], %r3
// Set
	mov DWORD 12[%r12], %r2
// Set
	mov #60, %r0
// CallFunction
	push %r0
	push %r2
	push %r3
	call [makeToken]
	add #12, %r14
// Return
	mov #1, %r0
	jmp [__bbcc_000000de]
// Label
__bbcc_0000001e:
// MoreEqualJmp
	cmp %r1, %r4
	jge [__bbcc_0000001d]
// Jmp
	jmp [__bbcc_0000001c]
// Label
__bbcc_0000001d:
// Set
	mov DWORD 8[%r12], %r2
// Set
	mov DWORD 12[%r12], %r1
// AddrOf
	lea DWORD [__bbcc_000000b6], %r0
// Set
// CallFunction
	push %r0
	push %r1
	push %r2
	call [errorToken]
	add #12, %r14
// Return
	mov #1, %r0
	jmp [__bbcc_000000de]
// Label
__bbcc_0000001b:
// Label
__bbcc_0000001a:
// Label
__bbcc_00000018:
// Return
	mov #0, %r0
__bbcc_000000de:
	pop %r4
	pop %r3
	pop %r2
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: isAlpha
isAlpha:
	push %r12
	mov %r14, %r12
	push %r1
// Set
	mov #1, %r1
// Set
	mov DWORD 8[%r12], %r0
// CallFunction
	push %r0
	call [isalpha]
	add #4, %r14
// JmpNotZero
	cmp #0, %r0
	jnz [__bbcc_0000001f]
// EqualJmp
	mov #95, %r0
	cmp 8[%r12], %r0
	jze [__bbcc_0000001f]
// Set
	mov #0, %r1
// Label
__bbcc_0000001f:
// Return
	mov %r1, %r0
__bbcc_000000df:
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: string
string:
	push %r12
	mov %r14, %r12
	push %r1
	push %r2
// Label
__bbcc_00000020:
// Set
	mov #0, %r1
// Set
	mov DWORD 8[%r12], %r0
// CallFunction
	push %r0
	call [peek]
	add #4, %r14
// EqualJmp
	cmp 16[%r12], %r0
	jze [__bbcc_00000022]
// Set
	mov DWORD 8[%r12], %r0
// CallFunction
	push %r0
	call [peek]
	add #4, %r14
// EqualJmp
	cmp #10, %r0
	jze [__bbcc_00000022]
// Set
	mov DWORD 8[%r12], %r0
// CallFunction
	push %r0
	call [isAtEnd]
	add #4, %r14
// JmpNotZero
	cmp #0, %r0
	jnz [__bbcc_00000022]
// Set
	mov #1, %r1
// Label
__bbcc_00000022:
// JmpZero
	cmp #0, %r1
	jze [__bbcc_00000021]
// Set
	mov DWORD 8[%r12], %r0
// CallFunction
	push %r0
	call [advance]
	add #4, %r14
// Jmp
	jmp [__bbcc_00000020]
// Label
__bbcc_00000021:
// Set
	mov #1, %r1
// Set
	mov DWORD 8[%r12], %r0
// CallFunction
	push %r0
	call [isAtEnd]
	add #4, %r14
// JmpNotZero
	cmp #0, %r0
	jnz [__bbcc_00000024]
// Set
	mov DWORD 8[%r12], %r0
// CallFunction
	push %r0
	call [peek]
	add #4, %r14
// EqualJmp
	cmp #10, %r0
	jze [__bbcc_00000024]
// Set
	mov #0, %r1
// Label
__bbcc_00000024:
// JmpZero
	cmp #0, %r1
	jze [__bbcc_00000023]
// Set
	mov DWORD 8[%r12], %r2
// Set
	mov DWORD 12[%r12], %r1
// AddrOf
	lea DWORD [__bbcc_000000b7], %r0
// Set
// CallFunction
	push %r0
	push %r1
	push %r2
	call [errorToken]
	add #12, %r14
// Return
	mov #0, %r0
	jmp [__bbcc_000000e0]
// Label
__bbcc_00000023:
// Set
	mov DWORD 8[%r12], %r0
// CallFunction
	push %r0
	call [advance]
	add #4, %r14
// Set
	mov DWORD 8[%r12], %r2
// Set
	mov DWORD 12[%r12], %r1
// Set
	mov #1, %r0
// CallFunction
	push %r0
	push %r1
	push %r2
	call [makeToken]
	add #12, %r14
// Return
	mov #0, %r0
__bbcc_000000e0:
	pop %r2
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: number
number:
	push %r12
	mov %r14, %r12
	push %r1
	push %r2
// Label
__bbcc_00000025:
// Set
	mov DWORD 8[%r12], %r0
// CallFunction
	push %r0
	call [peek]
	add #4, %r14
// Set
// CallFunction
	push %r0
	call [isdigit]
	add #4, %r14
// JmpZero
	cmp #0, %r0
	jze [__bbcc_00000026]
// Set
	mov DWORD 8[%r12], %r0
// CallFunction
	push %r0
	call [advance]
	add #4, %r14
// Jmp
	jmp [__bbcc_00000025]
// Label
__bbcc_00000026:
// Set
	mov DWORD 8[%r12], %r2
// Set
	mov DWORD 12[%r12], %r1
// Set
	mov #0, %r0
// CallFunction
	push %r0
	push %r1
	push %r2
	call [makeToken]
	add #12, %r14
// Return
	mov #0, %r0
__bbcc_000000e1:
	pop %r2
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: checkKeyword
checkKeyword:
	push %r12
	mov %r14, %r12
	push %r1
	push %r2
	push %r3
// Set
	mov #0, %r3
// ReadAt
	mov DWORD 8[%r12], %r0
	mov DWORD 4[%r0], %r0
// ReadAt
	mov DWORD 8[%r12], %r1
	mov DWORD [%r1], %r1
// Set
// Sub
	sub %r1, %r0
// Add
	mov DWORD 12[%r12], %r1
	add DWORD 16[%r12], %r1
// NotEqualJmp
	cmp %r0, %r1
	jnz [__bbcc_00000028]
// ReadAt
	mov DWORD 8[%r12], %r0
	mov DWORD [%r0], %r0
// Set
	mov DWORD 12[%r12], %r1
// Add
	add %r1, %r0
// Set
	mov %r0, %r2
// Set
	mov DWORD 20[%r12], %r1
// Set
	mov DWORD 16[%r12], %r0
// CallFunction
	push %r0
	push %r1
	push %r2
	call [memcmp]
	add #12, %r14
// NotEqualJmp
	cmp #0, %r0
	jnz [__bbcc_00000028]
// Set
	mov #1, %r3
// Label
__bbcc_00000028:
// JmpZero
	cmp #0, %r3
	jze [__bbcc_00000027]
// Return
	mov DWORD 24[%r12], %r0
	jmp [__bbcc_000000e2]
// Label
__bbcc_00000027:
// Return
	mov #2, %r0
__bbcc_000000e2:
	pop %r3
	pop %r2
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: identifierType
identifierType:
	push %r12
	mov %r14, %r12
	push %r1
	push %r2
	push %r3
	push %r4
	push %r5
	push %r6
// ReadAt
	mov DWORD 8[%r12], %r0
	mov DWORD [%r0], %r0
// ReadAt
	mov BYTE [%r0], %r0
// Set
	mov %r0, %r3
// ReadAt
	mov DWORD 8[%r12], %r0
	mov DWORD 4[%r0], %r0
// ReadAt
	mov DWORD 8[%r12], %r1
	mov DWORD [%r1], %r1
// Set
// Sub
	sub %r1, %r0
// Set
// Set
	mov %r0, %r2
// NotEqualJmp
	cmp #98, %r3
	jnz [__bbcc_00000029]
// Set
	mov DWORD 8[%r12], %r4
// AddrOf
	lea DWORD [__bbcc_000000b8], %r0
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
	add #20, %r14
// Return
	jmp [__bbcc_000000e3]
// Jmp
	jmp [__bbcc_0000002a]
// Label
__bbcc_00000029:
// NotEqualJmp
	cmp #103, %r3
	jnz [__bbcc_0000002b]
// Set
	mov DWORD 8[%r12], %r4
// AddrOf
	lea DWORD [__bbcc_000000b9], %r0
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
	add #20, %r14
// Return
	jmp [__bbcc_000000e3]
// Jmp
	jmp [__bbcc_0000002c]
// Label
__bbcc_0000002b:
// NotEqualJmp
	cmp #108, %r3
	jnz [__bbcc_0000002d]
// Set
	mov DWORD 8[%r12], %r4
// AddrOf
	lea DWORD [__bbcc_000000ba], %r0
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
	add #20, %r14
// Return
	jmp [__bbcc_000000e3]
// Jmp
	jmp [__bbcc_0000002e]
// Label
__bbcc_0000002d:
// NotEqualJmp
	cmp #111, %r3
	jnz [__bbcc_0000002f]
// Set
	mov DWORD 8[%r12], %r4
// AddrOf
	lea DWORD [__bbcc_000000bb], %r0
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
	add #20, %r14
// Return
	jmp [__bbcc_000000e3]
// Jmp
	jmp [__bbcc_00000030]
// Label
__bbcc_0000002f:
// NotEqualJmp
	cmp #112, %r3
	jnz [__bbcc_00000031]
// Set
	mov DWORD 8[%r12], %r4
// AddrOf
	lea DWORD [__bbcc_000000bc], %r0
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
	add #20, %r14
// Return
	jmp [__bbcc_000000e3]
// Jmp
	jmp [__bbcc_00000032]
// Label
__bbcc_00000031:
// NotEqualJmp
	cmp #121, %r3
	jnz [__bbcc_00000033]
// Set
	mov DWORD 8[%r12], %r4
// AddrOf
	lea DWORD [__bbcc_000000bd], %r0
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
	add #20, %r14
// Return
	jmp [__bbcc_000000e3]
// Jmp
	jmp [__bbcc_00000034]
// Label
__bbcc_00000033:
// NotEqualJmp
	cmp #70, %r3
	jnz [__bbcc_00000035]
// Set
	mov DWORD 8[%r12], %r4
// AddrOf
	lea DWORD [__bbcc_000000be], %r0
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
	add #20, %r14
// Return
	jmp [__bbcc_000000e3]
// Jmp
	jmp [__bbcc_00000036]
// Label
__bbcc_00000035:
// NotEqualJmp
	cmp #84, %r3
	jnz [__bbcc_00000037]
// Set
	mov DWORD 8[%r12], %r4
// AddrOf
	lea DWORD [__bbcc_000000bf], %r0
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
	add #20, %r14
// Return
	jmp [__bbcc_000000e3]
// Jmp
	jmp [__bbcc_00000038]
// Label
__bbcc_00000037:
// NotEqualJmp
	cmp #116, %r3
	jnz [__bbcc_00000039]
// Set
	mov DWORD 8[%r12], %r4
// AddrOf
	lea DWORD [__bbcc_000000c0], %r0
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
	add #20, %r14
// Return
	jmp [__bbcc_000000e3]
// Jmp
	jmp [__bbcc_0000003a]
// Label
__bbcc_00000039:
// NotEqualJmp
	cmp #78, %r3
	jnz [__bbcc_0000003b]
// Set
	mov DWORD 8[%r12], %r4
// AddrOf
	lea DWORD [__bbcc_000000c1], %r0
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
	add #20, %r14
// Return
	jmp [__bbcc_000000e3]
// Jmp
	jmp [__bbcc_0000003c]
// Label
__bbcc_0000003b:
// Set
	mov #0, %r0
// NotEqualJmp
	cmp #99, %r3
	jnz [__bbcc_0000003e]
// LessEqualJmp
	mov #1, %r1
	cmp %r2, %r1
	jle [__bbcc_0000003e]
// Set
	mov #1, %r0
// Label
__bbcc_0000003e:
// JmpZero
	cmp #0, %r0
	jze [__bbcc_0000003d]
// ReadAt
	mov DWORD 8[%r12], %r0
	mov DWORD [%r0], %r0
// ReadAt
	mov BYTE 1[%r0], %r0
// Set
	mov %r0, %r3
// NotEqualJmp
	cmp #108, %r3
	jnz [__bbcc_0000003f]
// Set
	mov DWORD 8[%r12], %r4
// AddrOf
	lea DWORD [__bbcc_000000bc], %r0
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
	add #20, %r14
// Return
	jmp [__bbcc_000000e3]
// Jmp
	jmp [__bbcc_00000040]
// Label
__bbcc_0000003f:
// NotEqualJmp
	cmp #111, %r3
	jnz [__bbcc_00000041]
// Set
	mov DWORD 8[%r12], %r4
// AddrOf
	lea DWORD [__bbcc_000000c2], %r0
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
	add #20, %r14
// Return
	jmp [__bbcc_000000e3]
// Label
__bbcc_00000041:
// Label
__bbcc_00000040:
// Jmp
	jmp [__bbcc_00000042]
// Label
__bbcc_0000003d:
// Set
	mov #0, %r0
// NotEqualJmp
	cmp #102, %r3
	jnz [__bbcc_00000044]
// LessEqualJmp
	mov #1, %r1
	cmp %r2, %r1
	jle [__bbcc_00000044]
// Set
	mov #1, %r0
// Label
__bbcc_00000044:
// JmpZero
	cmp #0, %r0
	jze [__bbcc_00000043]
// ReadAt
	mov DWORD 8[%r12], %r0
	mov DWORD [%r0], %r0
// ReadAt
	mov BYTE 1[%r0], %r0
// Set
	mov %r0, %r3
// NotEqualJmp
	cmp #105, %r3
	jnz [__bbcc_00000045]
// Set
	mov DWORD 8[%r12], %r4
// AddrOf
	lea DWORD [__bbcc_000000c3], %r0
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
	add #20, %r14
// Return
	jmp [__bbcc_000000e3]
// Jmp
	jmp [__bbcc_00000046]
// Label
__bbcc_00000045:
// NotEqualJmp
	cmp #111, %r3
	jnz [__bbcc_00000047]
// Set
	mov DWORD 8[%r12], %r4
// AddrOf
	lea DWORD [__bbcc_000000bb], %r0
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
	add #20, %r14
// Return
	jmp [__bbcc_000000e3]
// Jmp
	jmp [__bbcc_00000048]
// Label
__bbcc_00000047:
// NotEqualJmp
	cmp #114, %r3
	jnz [__bbcc_00000049]
// Set
	mov DWORD 8[%r12], %r4
// AddrOf
	lea DWORD [__bbcc_000000c4], %r0
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
	add #20, %r14
// Return
	jmp [__bbcc_000000e3]
// Label
__bbcc_00000049:
// Label
__bbcc_00000048:
// Label
__bbcc_00000046:
// Jmp
	jmp [__bbcc_0000004a]
// Label
__bbcc_00000043:
// Set
	mov #0, %r0
// NotEqualJmp
	cmp #114, %r3
	jnz [__bbcc_0000004c]
// LessEqualJmp
	mov #1, %r1
	cmp %r2, %r1
	jle [__bbcc_0000004c]
// Set
	mov #1, %r0
// Label
__bbcc_0000004c:
// JmpZero
	cmp #0, %r0
	jze [__bbcc_0000004b]
// ReadAt
	mov DWORD 8[%r12], %r0
	mov DWORD [%r0], %r0
// ReadAt
	mov BYTE 1[%r0], %r0
// Set
	mov %r0, %r3
// NotEqualJmp
	cmp #97, %r3
	jnz [__bbcc_0000004d]
// Set
	mov DWORD 8[%r12], %r4
// AddrOf
	lea DWORD [__bbcc_000000c5], %r0
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
	add #20, %r14
// Return
	jmp [__bbcc_000000e3]
// Jmp
	jmp [__bbcc_0000004e]
// Label
__bbcc_0000004d:
// NotEqualJmp
	cmp #101, %r3
	jnz [__bbcc_0000004f]
// Set
	mov DWORD 8[%r12], %r4
// AddrOf
	lea DWORD [__bbcc_000000c6], %r0
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
	add #20, %r14
// Return
	jmp [__bbcc_000000e3]
// Label
__bbcc_0000004f:
// Label
__bbcc_0000004e:
// Jmp
	jmp [__bbcc_00000050]
// Label
__bbcc_0000004b:
// Set
	mov #0, %r0
// NotEqualJmp
	cmp #119, %r3
	jnz [__bbcc_00000052]
// LessEqualJmp
	mov #1, %r1
	cmp %r2, %r1
	jle [__bbcc_00000052]
// Set
	mov #1, %r0
// Label
__bbcc_00000052:
// JmpZero
	cmp #0, %r0
	jze [__bbcc_00000051]
// ReadAt
	mov DWORD 8[%r12], %r0
	mov DWORD [%r0], %r0
// ReadAt
	mov BYTE 1[%r0], %r0
// Set
	mov %r0, %r3
// NotEqualJmp
	cmp #104, %r3
	jnz [__bbcc_00000053]
// Set
	mov DWORD 8[%r12], %r4
// AddrOf
	lea DWORD [__bbcc_000000c7], %r0
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
	add #20, %r14
// Return
	jmp [__bbcc_000000e3]
// Jmp
	jmp [__bbcc_00000054]
// Label
__bbcc_00000053:
// NotEqualJmp
	cmp #105, %r3
	jnz [__bbcc_00000055]
// Set
	mov DWORD 8[%r12], %r4
// AddrOf
	lea DWORD [__bbcc_000000c8], %r0
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
	add #20, %r14
// Return
	jmp [__bbcc_000000e3]
// Label
__bbcc_00000055:
// Label
__bbcc_00000054:
// Jmp
	jmp [__bbcc_00000056]
// Label
__bbcc_00000051:
// Set
	mov #0, %r0
// NotEqualJmp
	cmp #105, %r3
	jnz [__bbcc_00000058]
// LessEqualJmp
	mov #1, %r1
	cmp %r2, %r1
	jle [__bbcc_00000058]
// Set
	mov #1, %r0
// Label
__bbcc_00000058:
// JmpZero
	cmp #0, %r0
	jze [__bbcc_00000057]
// ReadAt
	mov DWORD 8[%r12], %r0
	mov DWORD [%r0], %r0
// ReadAt
	mov BYTE 1[%r0], %r0
// Set
	mov %r0, %r3
// NotEqualJmp
	cmp #109, %r3
	jnz [__bbcc_00000059]
// Set
	mov DWORD 8[%r12], %r4
// AddrOf
	lea DWORD [__bbcc_000000c9], %r0
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
	add #20, %r14
// Return
	jmp [__bbcc_000000e3]
// Jmp
	jmp [__bbcc_0000005a]
// Label
__bbcc_00000059:
// NotEqualJmp
	cmp #110, %r3
	jnz [__bbcc_0000005b]
// Return
	mov #22, %r0
	jmp [__bbcc_000000e3]
// Jmp
	jmp [__bbcc_0000005c]
// Label
__bbcc_0000005b:
// NotEqualJmp
	cmp #115, %r3
	jnz [__bbcc_0000005d]
// Return
	mov #27, %r0
	jmp [__bbcc_000000e3]
// Jmp
	jmp [__bbcc_0000005e]
// Label
__bbcc_0000005d:
// NotEqualJmp
	cmp #102, %r3
	jnz [__bbcc_0000005f]
// Return
	mov #46, %r0
	jmp [__bbcc_000000e3]
// Label
__bbcc_0000005f:
// Label
__bbcc_0000005e:
// Label
__bbcc_0000005c:
// Label
__bbcc_0000005a:
// Jmp
	jmp [__bbcc_00000060]
// Label
__bbcc_00000057:
// Set
	mov #0, %r0
// NotEqualJmp
	cmp #97, %r3
	jnz [__bbcc_00000062]
// LessEqualJmp
	mov #1, %r1
	cmp %r2, %r1
	jle [__bbcc_00000062]
// Set
	mov #1, %r0
// Label
__bbcc_00000062:
// JmpZero
	cmp #0, %r0
	jze [__bbcc_00000061]
// ReadAt
	mov DWORD 8[%r12], %r0
	mov DWORD [%r0], %r0
// ReadAt
	mov BYTE 1[%r0], %r0
// Set
	mov %r0, %r3
// NotEqualJmp
	cmp #119, %r3
	jnz [__bbcc_00000063]
// Set
	mov DWORD 8[%r12], %r4
// AddrOf
	lea DWORD [__bbcc_000000ca], %r0
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
	add #20, %r14
// Return
	jmp [__bbcc_000000e3]
// Jmp
	jmp [__bbcc_00000064]
// Label
__bbcc_00000063:
// NotEqualJmp
	cmp #110, %r3
	jnz [__bbcc_00000065]
// Set
	mov DWORD 8[%r12], %r4
// AddrOf
	lea DWORD [__bbcc_000000cb], %r0
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
	add #20, %r14
// Return
	jmp [__bbcc_000000e3]
// Jmp
	jmp [__bbcc_00000066]
// Label
__bbcc_00000065:
// Set
	mov #0, %r0
// NotEqualJmp
	cmp #115, %r3
	jnz [__bbcc_00000068]
// NotEqualJmp
	cmp #2, %r2
	jnz [__bbcc_00000068]
// Set
	mov #1, %r0
// Label
__bbcc_00000068:
// JmpZero
	cmp #0, %r0
	jze [__bbcc_00000067]
// Return
	mov #34, %r0
	jmp [__bbcc_000000e3]
// Jmp
	jmp [__bbcc_00000069]
// Label
__bbcc_00000067:
// Set
	mov #0, %r0
// LessEqualJmp
	mov #2, %r1
	cmp %r2, %r1
	jle [__bbcc_0000006b]
// NotEqualJmp
	cmp #115, %r3
	jnz [__bbcc_0000006b]
// Set
	mov #1, %r0
// Label
__bbcc_0000006b:
// JmpZero
	cmp #0, %r0
	jze [__bbcc_0000006a]
// ReadAt
	mov DWORD 8[%r12], %r0
	mov DWORD [%r0], %r0
// ReadAt
	mov BYTE 2[%r0], %r0
// Set
	mov %r0, %r3
// NotEqualJmp
	cmp #121, %r3
	jnz [__bbcc_0000006c]
// Set
	mov DWORD 8[%r12], %r4
// AddrOf
	lea DWORD [__bbcc_000000cc], %r0
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
	add #20, %r14
// Return
	jmp [__bbcc_000000e3]
// Label
__bbcc_0000006c:
// NotEqualJmp
	cmp #115, %r3
	jnz [__bbcc_0000006d]
// Set
	mov DWORD 8[%r12], %r4
// AddrOf
	lea DWORD [__bbcc_000000cd], %r0
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
	add #20, %r14
// Return
	jmp [__bbcc_000000e3]
// Label
__bbcc_0000006d:
// Label
__bbcc_0000006a:
// Label
__bbcc_00000069:
// Label
__bbcc_00000066:
// Label
__bbcc_00000064:
// Jmp
	jmp [__bbcc_0000006e]
// Label
__bbcc_00000061:
// Set
	mov #0, %r0
// NotEqualJmp
	cmp #101, %r3
	jnz [__bbcc_00000070]
// LessEqualJmp
	mov #1, %r1
	cmp %r2, %r1
	jle [__bbcc_00000070]
// Set
	mov #1, %r0
// Label
__bbcc_00000070:
// JmpZero
	cmp #0, %r0
	jze [__bbcc_0000006f]
// ReadAt
	mov DWORD 8[%r12], %r0
	mov DWORD [%r0], %r0
// ReadAt
	mov BYTE 1[%r0], %r0
// Set
	mov %r0, %r3
// NotEqualJmp
	cmp #120, %r3
	jnz [__bbcc_00000071]
// Set
	mov DWORD 8[%r12], %r4
// AddrOf
	lea DWORD [__bbcc_000000ce], %r0
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
	add #20, %r14
// Return
	jmp [__bbcc_000000e3]
// Jmp
	jmp [__bbcc_00000072]
// Label
__bbcc_00000071:
// Set
	mov #0, %r0
// LessEqualJmp
	mov #2, %r1
	cmp %r2, %r1
	jle [__bbcc_00000074]
// NotEqualJmp
	cmp #108, %r3
	jnz [__bbcc_00000074]
// Set
	mov #1, %r0
// Label
__bbcc_00000074:
// JmpZero
	cmp #0, %r0
	jze [__bbcc_00000073]
// ReadAt
	mov DWORD 8[%r12], %r0
	mov DWORD [%r0], %r0
// ReadAt
	mov BYTE 2[%r0], %r0
// Set
	mov %r0, %r3
// NotEqualJmp
	cmp #105, %r3
	jnz [__bbcc_00000075]
// Set
	mov DWORD 8[%r12], %r4
// AddrOf
	lea DWORD [__bbcc_000000cf], %r0
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
	add #20, %r14
// Return
	jmp [__bbcc_000000e3]
// Label
__bbcc_00000075:
// NotEqualJmp
	cmp #115, %r3
	jnz [__bbcc_00000076]
// Set
	mov DWORD 8[%r12], %r4
// AddrOf
	lea DWORD [__bbcc_000000d0], %r0
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
	add #20, %r14
// Return
	jmp [__bbcc_000000e3]
// Label
__bbcc_00000076:
// Label
__bbcc_00000073:
// Label
__bbcc_00000072:
// Jmp
	jmp [__bbcc_00000077]
// Label
__bbcc_0000006f:
// Set
	mov #0, %r1
// NotEqualJmp
	cmp #100, %r3
	jnz [__bbcc_00000079]
// LessEqualJmp
	mov #2, %r0
	cmp %r2, %r0
	jle [__bbcc_00000079]
// ReadAt
	mov DWORD 8[%r12], %r0
	mov DWORD [%r0], %r0
// ReadAt
	mov BYTE 1[%r0], %r0
// NotEqualJmp
	cmp #101, %r0
	jnz [__bbcc_00000079]
// Set
	mov #1, %r1
// Label
__bbcc_00000079:
// JmpZero
	cmp #0, %r1
	jze [__bbcc_00000078]
// ReadAt
	mov DWORD 8[%r12], %r0
	mov DWORD [%r0], %r0
// ReadAt
	mov BYTE 2[%r0], %r0
// Set
	mov %r0, %r3
// NotEqualJmp
	cmp #102, %r3
	jnz [__bbcc_0000007a]
// Return
	mov #35, %r0
	jmp [__bbcc_000000e3]
// Jmp
	jmp [__bbcc_0000007b]
// Label
__bbcc_0000007a:
// NotEqualJmp
	cmp #108, %r3
	jnz [__bbcc_0000007c]
// Return
	mov #40, %r0
	jmp [__bbcc_000000e3]
// Label
__bbcc_0000007c:
// Label
__bbcc_0000007b:
// Jmp
	jmp [__bbcc_0000007d]
// Label
__bbcc_00000078:
// Set
	mov #0, %r1
// NotEqualJmp
	cmp #110, %r3
	jnz [__bbcc_0000007f]
// LessEqualJmp
	mov #2, %r0
	cmp %r2, %r0
	jle [__bbcc_0000007f]
// ReadAt
	mov DWORD 8[%r12], %r0
	mov DWORD [%r0], %r0
// ReadAt
	mov BYTE 1[%r0], %r0
// NotEqualJmp
	cmp #111, %r0
	jnz [__bbcc_0000007f]
// Set
	mov #1, %r1
// Label
__bbcc_0000007f:
// JmpZero
	cmp #0, %r1
	jze [__bbcc_0000007e]
// ReadAt
	mov DWORD 8[%r12], %r0
	mov DWORD [%r0], %r0
// ReadAt
	mov BYTE 2[%r0], %r0
// Set
	mov %r0, %r3
// NotEqualJmp
	cmp #116, %r3
	jnz [__bbcc_00000080]
// Return
	mov #42, %r0
	jmp [__bbcc_000000e3]
// Jmp
	jmp [__bbcc_00000081]
// Label
__bbcc_00000080:
// NotEqualJmp
	cmp #110, %r3
	jnz [__bbcc_00000082]
// Set
	mov DWORD 8[%r12], %r2
// AddrOf
	lea DWORD [__bbcc_000000d1], %r0
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
	add #20, %r14
// Return
	jmp [__bbcc_000000e3]
// Label
__bbcc_00000082:
// Label
__bbcc_00000081:
// Label
__bbcc_0000007e:
// Label
__bbcc_0000007d:
// Label
__bbcc_00000077:
// Label
__bbcc_0000006e:
// Label
__bbcc_00000060:
// Label
__bbcc_00000056:
// Label
__bbcc_00000050:
// Label
__bbcc_0000004a:
// Label
__bbcc_00000042:
// Label
__bbcc_0000003c:
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
// Return
	mov #2, %r0
__bbcc_000000e3:
	pop %r6
	pop %r5
	pop %r4
	pop %r3
	pop %r2
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: identifier
identifier:
	push %r12
	mov %r14, %r12
	push %r1
	push %r2
// Label
__bbcc_00000083:
// Set
	mov #1, %r1
// Set
	mov DWORD 8[%r12], %r0
// CallFunction
	push %r0
	call [peek]
	add #4, %r14
// CallFunction
	push %r0
	call [isAlpha]
	add #4, %r14
// JmpNotZero
	cmp #0, %r0
	jnz [__bbcc_00000085]
// Set
	mov DWORD 8[%r12], %r0
// CallFunction
	push %r0
	call [peek]
	add #4, %r14
// Set
// CallFunction
	push %r0
	call [isdigit]
	add #4, %r14
// JmpNotZero
	cmp #0, %r0
	jnz [__bbcc_00000085]
// Set
	mov #0, %r1
// Label
__bbcc_00000085:
// JmpZero
	cmp #0, %r1
	jze [__bbcc_00000084]
// Set
	mov DWORD 8[%r12], %r0
// CallFunction
	push %r0
	call [advance]
	add #4, %r14
// Jmp
	jmp [__bbcc_00000083]
// Label
__bbcc_00000084:
// Set
	mov DWORD 8[%r12], %r2
// Set
	mov DWORD 12[%r12], %r1
// Set
	mov DWORD 8[%r12], %r0
// CallFunction
	push %r0
	call [identifierType]
	add #4, %r14
// CallFunction
	push %r0
	push %r1
	push %r2
	call [makeToken]
	add #12, %r14
// Return
	mov #0, %r0
__bbcc_000000e4:
	pop %r2
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: scanToken
scanToken:
	push %r12
	mov %r14, %r12
	push %r1
	push %r2
	push %r3
	push %r4
// ReadAt
	mov DWORD 8[%r12], %r0
	mov BYTE 12[%r0], %r0
// JmpZero
	cmp #0, %r0
	jze [__bbcc_00000086]
// Set
	mov #0, %r0
// SetAt
	mov 8[%r12], %r1
	mov %r0, BYTE 12[%r1]
// ReadAt
	mov DWORD 8[%r12], %r0
	mov DWORD 4[%r0], %r0
// Set
// SetAt
	mov 8[%r12], %r1
	mov %r0, DWORD [%r1]
// Set
	mov DWORD 8[%r12], %r1
// Set
	mov DWORD 12[%r12], %r0
// CallFunction
	push %r0
	push %r1
	call [indent]
	add #8, %r14
// JmpZero
	cmp #0, %r0
	jze [__bbcc_00000087]
// Return
	mov #0, %r0
	jmp [__bbcc_000000e5]
// Label
__bbcc_00000087:
// Label
__bbcc_00000086:
// Set
	mov DWORD 8[%r12], %r0
// CallFunction
	push %r0
	call [skipWhitespace]
	add #4, %r14
// ReadAt
	mov DWORD 8[%r12], %r0
	mov DWORD 4[%r0], %r0
// Set
// SetAt
	mov 8[%r12], %r1
	mov %r0, DWORD [%r1]
// Set
	mov DWORD 8[%r12], %r0
// CallFunction
	push %r0
	call [isAtEnd]
	add #4, %r14
// JmpZero
	cmp #0, %r0
	jze [__bbcc_00000088]
// Set
	mov DWORD 8[%r12], %r2
// Set
	mov DWORD 12[%r12], %r1
// Set
	mov #56, %r0
// CallFunction
	push %r0
	push %r1
	push %r2
	call [makeToken]
	add #12, %r14
// Return
	mov #0, %r0
	jmp [__bbcc_000000e5]
// Label
__bbcc_00000088:
// Set
	mov DWORD 8[%r12], %r0
// CallFunction
	push %r0
	call [advance]
	add #4, %r14
// Set
	mov %r0, %r2
// NotEqualJmp
	cmp #10, %r2
	jnz [__bbcc_00000089]
// Set
	mov DWORD 8[%r12], %r3
// Set
	mov DWORD 12[%r12], %r1
// Set
	mov #58, %r0
// CallFunction
	push %r0
	push %r1
	push %r3
	call [makeToken]
	add #12, %r14
// SetAt
	mov 12[%r12], %r0
	mov #0, %r1
	mov %r1, DWORD 8[%r0]
// ReadAt
	mov DWORD 8[%r12], %r0
	mov DWORD 8[%r0], %r0
// Set
	mov %r0, %r1
// Add
	add #1, %r0
// SetAt
	mov 8[%r12], %r1
	mov %r0, DWORD 8[%r1]
// Set
	mov #1, %r0
// SetAt
	mov 8[%r12], %r1
	mov %r0, BYTE 12[%r1]
// Return
	mov #0, %r0
	jmp [__bbcc_000000e5]
// Jmp
	jmp [__bbcc_0000008a]
// Label
__bbcc_00000089:
// NotEqualJmp
	cmp #43, %r2
	jnz [__bbcc_0000008b]
// Set
	mov DWORD 8[%r12], %r3
// Set
	mov DWORD 12[%r12], %r1
// Set
	mov #3, %r0
// CallFunction
	push %r0
	push %r1
	push %r3
	call [makeToken]
	add #12, %r14
// Return
	mov #0, %r0
	jmp [__bbcc_000000e5]
// Jmp
	jmp [__bbcc_0000008c]
// Label
__bbcc_0000008b:
// NotEqualJmp
	cmp #45, %r2
	jnz [__bbcc_0000008d]
// Set
	mov DWORD 8[%r12], %r3
// Set
	mov DWORD 12[%r12], %r1
// Set
	mov #4, %r0
// CallFunction
	push %r0
	push %r1
	push %r3
	call [makeToken]
	add #12, %r14
// Return
	mov #0, %r0
	jmp [__bbcc_000000e5]
// Jmp
	jmp [__bbcc_0000008e]
// Label
__bbcc_0000008d:
// NotEqualJmp
	cmp #47, %r2
	jnz [__bbcc_0000008f]
// Set
	mov DWORD 8[%r12], %r3
// Set
	mov DWORD 12[%r12], %r1
// Set
	mov #5, %r0
// CallFunction
	push %r0
	push %r1
	push %r3
	call [makeToken]
	add #12, %r14
// Return
	mov #0, %r0
	jmp [__bbcc_000000e5]
// Jmp
	jmp [__bbcc_00000090]
// Label
__bbcc_0000008f:
// NotEqualJmp
	cmp #42, %r2
	jnz [__bbcc_00000091]
// Set
	mov DWORD 8[%r12], %r3
// Set
	mov DWORD 12[%r12], %r1
// Set
	mov #6, %r0
// CallFunction
	push %r0
	push %r1
	push %r3
	call [makeToken]
	add #12, %r14
// Return
	mov #0, %r0
	jmp [__bbcc_000000e5]
// Jmp
	jmp [__bbcc_00000092]
// Label
__bbcc_00000091:
// NotEqualJmp
	cmp #40, %r2
	jnz [__bbcc_00000093]
// Set
	mov DWORD 8[%r12], %r3
// Set
	mov DWORD 12[%r12], %r1
// Set
	mov #10, %r0
// CallFunction
	push %r0
	push %r1
	push %r3
	call [makeToken]
	add #12, %r14
// Return
	mov #0, %r0
	jmp [__bbcc_000000e5]
// Jmp
	jmp [__bbcc_00000094]
// Label
__bbcc_00000093:
// NotEqualJmp
	cmp #41, %r2
	jnz [__bbcc_00000095]
// Set
	mov DWORD 8[%r12], %r3
// Set
	mov DWORD 12[%r12], %r1
// Set
	mov #11, %r0
// CallFunction
	push %r0
	push %r1
	push %r3
	call [makeToken]
	add #12, %r14
// Return
	mov #0, %r0
	jmp [__bbcc_000000e5]
// Jmp
	jmp [__bbcc_00000096]
// Label
__bbcc_00000095:
// NotEqualJmp
	cmp #123, %r2
	jnz [__bbcc_00000097]
// Set
	mov DWORD 8[%r12], %r3
// Set
	mov DWORD 12[%r12], %r1
// Set
	mov #12, %r0
// CallFunction
	push %r0
	push %r1
	push %r3
	call [makeToken]
	add #12, %r14
// Return
	mov #0, %r0
	jmp [__bbcc_000000e5]
// Jmp
	jmp [__bbcc_00000098]
// Label
__bbcc_00000097:
// NotEqualJmp
	cmp #125, %r2
	jnz [__bbcc_00000099]
// Set
	mov DWORD 8[%r12], %r3
// Set
	mov DWORD 12[%r12], %r1
// Set
	mov #13, %r0
// CallFunction
	push %r0
	push %r1
	push %r3
	call [makeToken]
	add #12, %r14
// Return
	mov #0, %r0
	jmp [__bbcc_000000e5]
// Jmp
	jmp [__bbcc_0000009a]
// Label
__bbcc_00000099:
// NotEqualJmp
	cmp #44, %r2
	jnz [__bbcc_0000009b]
// Set
	mov DWORD 8[%r12], %r3
// Set
	mov DWORD 12[%r12], %r1
// Set
	mov #7, %r0
// CallFunction
	push %r0
	push %r1
	push %r3
	call [makeToken]
	add #12, %r14
// Return
	mov #0, %r0
	jmp [__bbcc_000000e5]
// Jmp
	jmp [__bbcc_0000009c]
// Label
__bbcc_0000009b:
// NotEqualJmp
	cmp #46, %r2
	jnz [__bbcc_0000009d]
// Set
	mov DWORD 8[%r12], %r3
// Set
	mov DWORD 12[%r12], %r1
// Set
	mov #8, %r0
// CallFunction
	push %r0
	push %r1
	push %r3
	call [makeToken]
	add #12, %r14
// Return
	mov #0, %r0
	jmp [__bbcc_000000e5]
// Jmp
	jmp [__bbcc_0000009e]
// Label
__bbcc_0000009d:
// NotEqualJmp
	cmp #58, %r2
	jnz [__bbcc_0000009f]
// Set
	mov DWORD 8[%r12], %r3
// Set
	mov DWORD 12[%r12], %r1
// Set
	mov #9, %r0
// CallFunction
	push %r0
	push %r1
	push %r3
	call [makeToken]
	add #12, %r14
// Return
	mov #0, %r0
	jmp [__bbcc_000000e5]
// Jmp
	jmp [__bbcc_000000a0]
// Label
__bbcc_0000009f:
// Set
	mov #0, %r3
// NotEqualJmp
	cmp #33, %r2
	jnz [__bbcc_000000a2]
// Set
	mov DWORD 8[%r12], %r1
// Set
	mov #61, %r0
// CallFunction
	push %r0
	push %r1
	call [match]
	add #8, %r14
// JmpZero
	cmp #0, %r0
	jze [__bbcc_000000a2]
// Set
	mov #1, %r3
// Label
__bbcc_000000a2:
// JmpZero
	cmp #0, %r3
	jze [__bbcc_000000a1]
// Set
	mov DWORD 8[%r12], %r3
// Set
	mov DWORD 12[%r12], %r1
// Set
	mov #51, %r0
// CallFunction
	push %r0
	push %r1
	push %r3
	call [makeToken]
	add #12, %r14
// Return
	mov #0, %r0
	jmp [__bbcc_000000e5]
// Jmp
	jmp [__bbcc_000000a3]
// Label
__bbcc_000000a1:
// NotEqualJmp
	cmp #61, %r2
	jnz [__bbcc_000000a4]
// Set
	mov DWORD 8[%r12], %r4
// Set
	mov DWORD 12[%r12], %r3
// Set
	mov DWORD 8[%r12], %r1
// Set
	mov #61, %r0
// CallFunction
	push %r0
	push %r1
	call [match]
	add #8, %r14
// JmpZero
	cmp #0, %r0
	jze [__bbcc_000000a5]
// Set
	mov #50, %r0
// Jmp
	jmp [__bbcc_000000a6]
// Label
__bbcc_000000a5:
// Set
	mov #49, %r0
// Label
__bbcc_000000a6:
// Set
// CallFunction
	push %r0
	push %r3
	push %r4
	call [makeToken]
	add #12, %r14
// Return
	mov #0, %r0
	jmp [__bbcc_000000e5]
// Jmp
	jmp [__bbcc_000000a7]
// Label
__bbcc_000000a4:
// NotEqualJmp
	cmp #60, %r2
	jnz [__bbcc_000000a8]
// Set
	mov DWORD 8[%r12], %r4
// Set
	mov DWORD 12[%r12], %r3
// Set
	mov DWORD 8[%r12], %r1
// Set
	mov #61, %r0
// CallFunction
	push %r0
	push %r1
	call [match]
	add #8, %r14
// JmpZero
	cmp #0, %r0
	jze [__bbcc_000000a9]
// Set
	mov #55, %r0
// Jmp
	jmp [__bbcc_000000aa]
// Label
__bbcc_000000a9:
// Set
	mov #54, %r0
// Label
__bbcc_000000aa:
// Set
// CallFunction
	push %r0
	push %r3
	push %r4
	call [makeToken]
	add #12, %r14
// Return
	mov #0, %r0
	jmp [__bbcc_000000e5]
// Jmp
	jmp [__bbcc_000000ab]
// Label
__bbcc_000000a8:
// NotEqualJmp
	cmp #62, %r2
	jnz [__bbcc_000000ac]
// Set
	mov DWORD 8[%r12], %r4
// Set
	mov DWORD 12[%r12], %r3
// Set
	mov DWORD 8[%r12], %r1
// Set
	mov #61, %r0
// CallFunction
	push %r0
	push %r1
	call [match]
	add #8, %r14
// JmpZero
	cmp #0, %r0
	jze [__bbcc_000000ad]
// Set
	mov #53, %r0
// Jmp
	jmp [__bbcc_000000ae]
// Label
__bbcc_000000ad:
// Set
	mov #52, %r0
// Label
__bbcc_000000ae:
// Set
// CallFunction
	push %r0
	push %r3
	push %r4
	call [makeToken]
	add #12, %r14
// Return
	mov #0, %r0
	jmp [__bbcc_000000e5]
// Jmp
	jmp [__bbcc_000000af]
// Label
__bbcc_000000ac:
// Set
	mov #1, %r0
// EqualJmp
	cmp #34, %r2
	jze [__bbcc_000000b1]
// EqualJmp
	cmp #39, %r2
	jze [__bbcc_000000b1]
// Set
	mov #0, %r0
// Label
__bbcc_000000b1:
// JmpZero
	cmp #0, %r0
	jze [__bbcc_000000b0]
// Set
	mov DWORD 8[%r12], %r1
// Set
	mov DWORD 12[%r12], %r0
// CallFunction
	push %r2
	push %r0
	push %r1
	call [string]
	add #12, %r14
// Return
	mov #0, %r0
	jmp [__bbcc_000000e5]
// Jmp
	jmp [__bbcc_000000b2]
// Label
__bbcc_000000b0:
// Set
	mov %r2, %r0
// CallFunction
	push %r0
	call [isdigit]
	add #4, %r14
// JmpZero
	cmp #0, %r0
	jze [__bbcc_000000b3]
// Set
	mov DWORD 8[%r12], %r1
// Set
	mov DWORD 12[%r12], %r0
// CallFunction
	push %r0
	push %r1
	call [number]
	add #8, %r14
// Return
	mov #0, %r0
	jmp [__bbcc_000000e5]
// Jmp
	jmp [__bbcc_000000b4]
// Label
__bbcc_000000b3:
// CallFunction
	push %r2
	call [isAlpha]
	add #4, %r14
// JmpZero
	cmp #0, %r0
	jze [__bbcc_000000b5]
// Set
	mov DWORD 8[%r12], %r1
// Set
	mov DWORD 12[%r12], %r0
// CallFunction
	push %r0
	push %r1
	call [identifier]
	add #8, %r14
// Return
	mov #0, %r0
	jmp [__bbcc_000000e5]
// Label
__bbcc_000000b5:
// Label
__bbcc_000000b4:
// Label
__bbcc_000000b2:
// Label
__bbcc_000000af:
// Label
__bbcc_000000ab:
// Label
__bbcc_000000a7:
// Label
__bbcc_000000a3:
// Label
__bbcc_000000a0:
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
// Set
	mov DWORD 8[%r12], %r2
// Set
	mov DWORD 12[%r12], %r1
// AddrOf
	lea DWORD [__bbcc_000000d2], %r0
// Set
// CallFunction
	push %r0
	push %r1
	push %r2
	call [errorToken]
	add #12, %r14
// Return
	mov #0, %r0
__bbcc_000000e5:
	pop %r4
	pop %r3
	pop %r2
	pop %r1
	mov %r12, %r14
	pop %r12
	ret