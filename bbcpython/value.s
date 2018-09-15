.import printf
.import writeArray
.import objType
.import asCString
.export writeValueArray
.export boolVal
.export noneVal
.export intVal
.export objVal
.export isBool
.export isNone
.export isInt
.export isObj
.export asBool
.export asInt
.export asObj
.export printValue
__bbcc_0000000a:
.byte #37,#115,#0
__bbcc_0000000b:
.byte #37,#100,#0
__bbcc_0000000c:
.byte #78,#111,#110,#101,#0
__bbcc_0000000d:
.byte #84,#114,#117,#101,#0
__bbcc_0000000e:
.byte #70,#97,#108,#115,#101,#0
// Function: writeValueArray
writeValueArray:
	push %r12
	mov %r14, %r12
	push %r1
	push %r2
// Set
	mov DWORD 8[%r12], %r1
// Set
	mov DWORD 12[%r12], %r0
// CallFunction
	push %r0
	mov #5, %r2
	push %r2
	push %r1
	call [writeArray]
	add #12, %r14
// Return
	mov #0, %r0
__bbcc_0000000f:
	pop %r2
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: printObject
printObject:
	push %r12
	mov %r14, %r12
	push %r1
// Set
	mov DWORD 8[%r12], %r0
// CallFunction
	push %r0
	call [objType]
	add #4, %r14
// Set
// NotEqualJmp
	cmp #0, %r0
	jnz [__bbcc_00000000]
// AddrOf
	lea DWORD [__bbcc_0000000a], %r0
// Set
	mov %r0, %r1
// Set
	mov DWORD 8[%r12], %r0
// CallFunction
	push %r0
	call [asCString]
	add #4, %r14
// CallFunction
	push %r0
	push %r1
	call [printf]
	add #8, %r14
// Label
__bbcc_00000000:
// Return
	mov #0, %r0
__bbcc_00000010:
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: printValue
printValue:
	push %r12
	mov %r14, %r12
	push %r1
	push %r2
// ReadAt
	mov DWORD 8[%r12], %r0
	mov BYTE [%r0], %r0
// Set
	mov %r0, %r1
// NotEqualJmp
	cmp #1, %r1
	jnz [__bbcc_00000001]
// AddrOf
	lea DWORD [__bbcc_0000000b], %r0
// Set
	mov %r0, %r2
// Set
	mov DWORD 8[%r12], %r0
// CallFunction
	push %r0
	call [asInt]
	add #4, %r14
// CallFunction
	push %r0
	push %r2
	call [printf]
	add #8, %r14
// Jmp
	jmp [__bbcc_00000002]
// Label
__bbcc_00000001:
// NotEqualJmp
	cmp #0, %r1
	jnz [__bbcc_00000003]
// AddrOf
	lea DWORD [__bbcc_0000000c], %r0
// Set
// CallFunction
	push %r0
	call [printf]
	add #4, %r14
// Jmp
	jmp [__bbcc_00000004]
// Label
__bbcc_00000003:
// NotEqualJmp
	cmp #2, %r1
	jnz [__bbcc_00000005]
// Set
	mov DWORD 8[%r12], %r0
// CallFunction
	push %r0
	call [asBool]
	add #4, %r14
// JmpZero
	cmp #0, %r0
	jze [__bbcc_00000006]
// AddrOf
	lea DWORD [__bbcc_0000000d], %r0
// Set
// Jmp
	jmp [__bbcc_00000007]
// Label
__bbcc_00000006:
// AddrOf
	lea DWORD [__bbcc_0000000e], %r0
// Set
// Label
__bbcc_00000007:
// Set
// CallFunction
	push %r0
	call [printf]
	add #4, %r14
// Jmp
	jmp [__bbcc_00000008]
// Label
__bbcc_00000005:
// NotEqualJmp
	cmp #3, %r1
	jnz [__bbcc_00000009]
// Set
	mov DWORD 8[%r12], %r0
// CallFunction
	push %r0
	call [printObject]
	add #4, %r14
// Label
__bbcc_00000009:
// Label
__bbcc_00000008:
// Label
__bbcc_00000004:
// Label
__bbcc_00000002:
// Return
	mov #0, %r0
__bbcc_00000011:
	pop %r2
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: boolVal
boolVal:
	push %r12
	mov %r14, %r12
	push %r1
// Set
	mov #2, %r0
// SetAt
	mov 12[%r12], %r1
	mov %r0, BYTE [%r1]
// Add
	mov DWORD 12[%r12], %r0
	add #1, %r0
// SetAt
	mov 8[%r12], %r1
	mov %r1, BYTE [%r0]
// Return
	mov #0, %r0
__bbcc_00000012:
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: noneVal
noneVal:
	push %r12
	mov %r14, %r12
	push %r1
// Set
	mov #0, %r0
// SetAt
	mov 8[%r12], %r1
	mov %r0, BYTE [%r1]
// Add
	mov DWORD 8[%r12], %r0
	add #1, %r0
// SetAt
	mov #0, %r1
	mov %r1, DWORD [%r0]
// Return
	mov #0, %r0
__bbcc_00000013:
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: intVal
intVal:
	push %r12
	mov %r14, %r12
	push %r1
// Set
	mov #1, %r0
// SetAt
	mov 12[%r12], %r1
	mov %r0, BYTE [%r1]
// Add
	mov DWORD 12[%r12], %r0
	add #1, %r0
// SetAt
	mov 8[%r12], %r1
	mov %r1, DWORD [%r0]
// Return
	mov #0, %r0
__bbcc_00000014:
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: objVal
objVal:
	push %r12
	mov %r14, %r12
	push %r1
// Set
	mov #3, %r0
// SetAt
	mov 12[%r12], %r1
	mov %r0, BYTE [%r1]
// Add
	mov DWORD 12[%r12], %r1
	add #1, %r1
// Set
	mov DWORD 8[%r12], %r0
// SetAt
	mov %r0, DWORD [%r1]
// Return
	mov #0, %r0
__bbcc_00000015:
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: isBool
isBool:
	push %r12
	mov %r14, %r12
	push %r1
// ReadAt
	mov DWORD 8[%r12], %r0
	mov BYTE [%r0], %r1
// EqualCmp
	cmp #2, %r1
	sze %r0
// Return
__bbcc_00000016:
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: isNone
isNone:
	push %r12
	mov %r14, %r12
	push %r1
// ReadAt
	mov DWORD 8[%r12], %r0
	mov BYTE [%r0], %r1
// EqualCmp
	cmp #0, %r1
	sze %r0
// Return
__bbcc_00000017:
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: isInt
isInt:
	push %r12
	mov %r14, %r12
	push %r1
// ReadAt
	mov DWORD 8[%r12], %r0
	mov BYTE [%r0], %r1
// EqualCmp
	cmp #1, %r1
	sze %r0
// Return
__bbcc_00000018:
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: isObj
isObj:
	push %r12
	mov %r14, %r12
	push %r1
// ReadAt
	mov DWORD 8[%r12], %r0
	mov BYTE [%r0], %r1
// EqualCmp
	cmp #3, %r1
	sze %r0
// Return
__bbcc_00000019:
	pop %r1
	mov %r12, %r14
	pop %r12
	ret
// Function: asBool
asBool:
	push %r12
	mov %r14, %r12
// Add
	mov DWORD 8[%r12], %r0
	add #1, %r0
// ReadAt
	mov BYTE [%r0], %r0
// Return
__bbcc_0000001a:
	mov %r12, %r14
	pop %r12
	ret
// Function: asInt
asInt:
	push %r12
	mov %r14, %r12
// Add
	mov DWORD 8[%r12], %r0
	add #1, %r0
// ReadAt
	mov DWORD [%r0], %r0
// Return
__bbcc_0000001b:
	mov %r12, %r14
	pop %r12
	ret
// Function: asObj
asObj:
	push %r12
	mov %r14, %r12
// Add
	mov DWORD 8[%r12], %r0
	add #1, %r0
// ReadAt
	mov DWORD [%r0], %r0
// Return
__bbcc_0000001c:
	mov %r12, %r14
	pop %r12
	ret