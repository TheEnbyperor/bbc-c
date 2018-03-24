	.intel_syntax noprefix
	.section .text
	.global main

main:
	push rbp
	mov rbp, rsp
	sub rsp, 0
	// SET
	mov eax, 2
	// ADD
	add eax, 1
	// SET
	// RETURN
	mov rsp, rbp
	pop rbp
	ret
	// RETURN
	mov eax, 0
	mov rsp, rbp
	pop rbp
	ret
	.att_syntax noprefix
