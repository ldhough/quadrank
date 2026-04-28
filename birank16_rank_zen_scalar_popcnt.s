.intel_syntax noprefix
.section .text.birank16_rank,"ax",@progbits
	.globl	birank16_rank
	.p2align	4
.type	birank16_rank,@function
birank16_rank:
	.cfi_startproc
	push r15
	.cfi_def_cfa_offset 16
	push r14
	.cfi_def_cfa_offset 24
	push r12
	.cfi_def_cfa_offset 32
	push rbx
	.cfi_def_cfa_offset 40
	push rax
	.cfi_def_cfa_offset 48
	.cfi_offset rbx, -40
	.cfi_offset r12, -32
	.cfi_offset r14, -24
	.cfi_offset r15, -16
	mov rdx, rsi
	movabs rax, 595056260442243601
	mov rbx, qword ptr [rip + quadrank::binary::blocks::BINARY_MID_MASKS256@GOTPCREL]
	shr rdx, 4
	mulx rcx, rcx, rax
	mov rdx, rsi
	imul r8, rcx, 496
	shl rcx, 6
	sub rdx, r8
	mov r8, qword ptr [rdi + 8]
	mov r10d, edx
	mov r11d, edx
	shr r10d, 8
	shl r11d, 5
	shl r10d, 5
	lea r9, [r8 + rcx]
	mov r14, qword ptr [r10 + r9]
	mov r15, qword ptr [r10 + r9 + 8]
	mov r12, qword ptr [r10 + r9 + 16]
	mov r9, qword ptr [r10 + r9 + 24]
	and r14, qword ptr [rbx + r11]
	and r15, qword ptr [rbx + r11 + 8]
	and r12, qword ptr [rbx + r11 + 16]
	and r9, qword ptr [rbx + r11 + 24]
	#APP

	popcnt r14, r14
	popcnt r15, r15
	popcnt r12, r12
	popcnt r9, r9
	add r14, r15
	add r12, r9
	add r14, r12

	#NO_APP
	mov r9d, r14d
	mov r10, r9
	movzx ecx, word ptr [r8 + rcx + 62]
	neg r10
	cmp rdx, 256
	cmovae r10, r9
	shr rsi, 11
	mov rdx, rsi
	mulx rax, rax, rax
	mov rdx, qword ptr [rdi + 32]
	mov eax, dword ptr [rdx + 4*rax]
	shl rax, 11
	add rax, rcx
	add rax, r10
	add rsp, 8
	.cfi_def_cfa_offset 40
	pop rbx
	.cfi_def_cfa_offset 32
	pop r12
	.cfi_def_cfa_offset 24
	pop r14
	.cfi_def_cfa_offset 16
	pop r15
	.cfi_def_cfa_offset 8
	ret
