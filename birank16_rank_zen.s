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
	movabs rax, 595056260442243601
	mov r8, rsi
	mov rbx, qword ptr [rip + quadrank::binary::blocks::BINARY_MID_MASKS256@GOTPCREL]
	vmovdqa ymm1, ymmword ptr [rip + .LCPI25_0]
	vmovdqa ymm3, ymmword ptr [rip + .LCPI25_1]
	shr rdx, 4
	mulx rdx, rdx, rax
	mov r9, qword ptr [rdi + 8]
	imul rcx, rdx, 496
	shl rdx, 6
	sub r8, rcx
	mov rcx, qword ptr [rdi + 32]
	lea rdi, [r9 + rdx]
	mov r10d, r8d
	mov r11d, r8d
	shr r10d, 8
	shl r11d, 5
	shl r10d, 5
	vmovdqu ymm0, ymmword ptr [r10 + rdi]
	vpand ymm0, ymm0, ymmword ptr [rbx + r11]
	vpand ymm2, ymm0, ymm1
	vpsrlw ymm0, ymm0, 4
	vpand ymm0, ymm0, ymm1
	vpshufb ymm2, ymm3, ymm2
	vpxor xmm1, xmm1, xmm1
	vpshufb ymm0, ymm3, ymm0
	vpaddb ymm0, ymm0, ymm2
	vpsadbw ymm0, ymm0, ymm1
	vextracti128 xmm1, ymm0, 1
	vpaddq xmm0, xmm0, xmm1
	vpshufd xmm1, xmm0, 238
	vpaddq xmm0, xmm0, xmm1
	vmovq rdi, xmm0
	mov r10, rdi
	neg r10
	cmp r8, 256
	movzx r8d, word ptr [r9 + rdx + 62]
	cmovae r10, rdi
	shr rsi, 11
	mov rdx, rsi
	mulx rax, rax, rax
	mov eax, dword ptr [rcx + 4*rax]
	shl rax, 11
	add rax, r8
	add rax, r10
	pop rbx
	.cfi_def_cfa_offset 8
	vzeroupper
	ret
