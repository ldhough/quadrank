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
	mov rdi, qword ptr [rdi + 32]
	lea r9, [rdx + rcx]
	mov r10d, r8d
	shl r10d, 5
	mov r11, qword ptr [rip + quadrank::binary::blocks::BINARY_MID_MASKS256@GOTPCREL]
	mov ebx, r8d
	shr ebx, 3
	and ebx, 32
	vmovdqu ymm0, ymmword ptr [rbx + r9]
	vpand ymm0, ymm0, ymmword ptr [r11 + r10]
	vpopcntq ymm0, ymm0
	vpmovqb xmm0, ymm0
	vpxor xmm1, xmm1, xmm1
	vpsadbw xmm0, xmm0, xmm1
	vmovq r9, xmm0
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
