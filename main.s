.export out
.export main
out:
.byte #0,#0,#0,#0,#0
\ Function: main
main:
	push %r11
	mov %r13, %r11
\ Set
	mov #42, %r1
\ Set
\ Return
	mov %r11, %r13
	pop %r11
	ret