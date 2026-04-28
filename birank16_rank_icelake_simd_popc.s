.intel_syntax noprefix
.section .text.birank16_rank,"ax",@progbits
	.globl	birank16_rank
	.p2align	4
.type	birank16_rank,@function
birank16_rank:
	.cfi_startproc
	push rbx
	.cfi_def_cfa_offset 16
	.cfi_offset rbx, -16
	mov rdx, rsi
	shr rdx, 4
	movabs rax, 595056260442243601
	mulx rcx, rcx, rax
	imul rdx, rcx, 496
	mov r8, rsi
	sub r8, rdx
	shl rcx, 6
	mov rdx, qword ptr [rdi + 8]
	lea r9, [rdx + rcx]
	mov r10d, r8d
	shr r10d, 3
	and r10d, 32
	mov r11d, r8d
	shl r11d, 5
	mov rbx, qword ptr [rip + quadrank::binary::blocks::BINARY_MID_MASKS256@GOTPCREL]
	vmovdqu ymm0, ymmword ptr [rbx + r11]
	vpand ymm0, ymm0, ymmword ptr [r10 + r9]
	mov rdi, qword ptr [rdi + 32]
	vpopcntq ymm0, ymm0
	vextracti128 xmm1, ymm0, 1
	vpaddq xmm0, xmm1, xmm0
	vpshufd xmm1, xmm0, 238
	vpaddq xmm0, xmm0, xmm1
	vmovd r9d, xmm0
	mov r10, r9
	neg r10
	cmp r8, 256
	movzx ecx, word ptr [rdx + rcx + 62]
	cmovae r10, r9
	shr rsi, 11
	mov rdx, rsi
	mulx rax, rax, rax
	mov eax, dword ptr [rdi + 4*rax]
	shl rax, 11
	add rax, rcx
	add rax, r10
	pop rbx
	.cfi_def_cfa_offset 8
	vzeroupper
	ret
