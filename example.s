	.text
	.globl _b
	.zerofill __DATA,__common,_b,4,2
	.text
	.globl _goodbye
	.globl _hello
	.globl _main

_goodbye:
	pushq	%rbp
	movq	%rsp, %rbp
	movl	$2, -4(%rbp)
	movl	-4(%rbp), %eax
	popq	%rbp
	ret
	
_hello:
	pushq	%rbp
	movq	%rsp, %rbp
	movl	$0, %eax
	call	_goodbye
	movl	%eax, -4(%rbp)
	movl	-4(%rbp), %eax
	leave
	ret

_main:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx

	movl	$0, %eax
	call	_hello
	movl	%eax, %ebx
	movl	$0, %eax
	call	_goodbye
	imull	%eax, %ebx
	movl	%ebx, %edx
	movl	%edx, %eax
	sall	$2, %eax
	addl	%edx, %eax
	addl	%eax, %eax
	movl	%eax, -20(%rbp)
	movl	-20(%rbp), %eax
	movq	-8(%rbp), %rbx
	leave
	ret