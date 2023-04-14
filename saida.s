    .text 
    .globl _temp_r_1 
    .data 
_temp_r_1: 
    .int   4 
    .text 
    .globl _temp_r_2 
    .data 
_temp_r_2: 
    .int   4 
    .text 
    .globl _temp_r_3 
    .data 
_temp_r_3: 
    .int   4 
    .text 
    .globl _temp_r_4 
    .data 
_temp_r_4: 
    .int   4 
    .text 
    .globl _temp_r_5 
    .data 
_temp_r_5: 
    .int   4 
    .text 
    .globl _temp_r_6 
    .data 
_temp_r_6: 
    .int   4 
    .text 
    .globl _temp_r_7 
    .data 
_temp_r_7: 
    .int   4 
    .text 
    .globl _temp_r_8 
    .data 
_temp_r_8: 
    .int   4 
    .text 
    .globl _temp_r_9 
    .data 
_temp_r_9: 
    .int   4 
    .text 
    .globl _temp_r_10 
    .data 
_temp_r_10: 
    .int   4 
    .text 
    .globl _temp_r_11 
    .data 
_temp_r_11: 
    .int   4 
    .text 
    .globl _temp_r_12 
    .data 
_temp_r_12: 
    .int   4 
    .text 
    .globl _temp_r_13 
    .data 
_temp_r_13: 
    .int   4 
    .text 
    .globl _temp_r_14 
    .data 
_temp_r_14: 
    .int   4 
    .text 
    .globl _temp_r_15 
    .data 
_temp_r_15: 
    .int   4 
    .text 
    .globl _temp_r_16 
    .data 
_temp_r_16: 
    .int   4 
    .text 
    .globl _temp_r_17 
    .data 
_temp_r_17: 
    .int   4 
    .text 
    .globl _temp_r_18 
    .data 
_temp_r_18: 
    .int   4 
    .text 
    .globl _temp_r_19 
    .data 
_temp_r_19: 
    .int   4 
    .text 
    .globl _temp_r_20 
    .data 
_temp_r_20: 
    .int   4 
    .text 
    .globl _temp_r_21 
    .data 
_temp_r_21: 
    .int   4 
    .text 
    .globl _temp_r_22 
    .data 
_temp_r_22: 
    .int   4 
    .text 
    .globl _temp_r_23 
    .data 
_temp_r_23: 
    .int   4 
    .text 
    .globl _temp_r_24 
    .data 
_temp_r_24: 
    .int   4 
    .text 
    .globl _temp_r_25 
    .data 
_temp_r_25: 
    .int   4 
    .text 
    .globl _temp_r_26 
    .data 
_temp_r_26: 
    .int   4 
    .text 
    .globl _temp_r_27 
    .data 
_temp_r_27: 
    .int   4 
    .text 
    .globl _temp_r_28 
    .data 
_temp_r_28: 
    .int   4 
    .text 
    .globl _temp_r_29 
    .data 
_temp_r_29: 
    .int   4 
    .text 
    .globl _temp_r_30 
    .data 
_temp_r_30: 
    .int   4 
    .text 
    .globl _temp_r_31 
    .data 
_temp_r_31: 
    .int   4 
    .text 
    .globl _temp_r_32 
    .data 
_temp_r_32: 
    .int   4 
    .text 
    .globl _temp_r_33 
    .data 
_temp_r_33: 
    .int   4 
    .text 
    .globl _main 
_main: 
    pushq   %rbp 
    movq    %rsp, %rbp 
    subq    $4, %rsp 
    movl    $10000, _temp_r_31(%rip) 
    movl    $10000, _temp_r_32(%rip) 
    movl    _temp_r_31(%rip), %edi 
    movl    _temp_r_32(%rip), %esi 
    movl	$0, %eax 
    pushq   %rbp 
    movq    %rsp, %rbp 
    subq    $12, %rsp 
    movl    %edi, -8(%rbp) 
    movl    %esi, -4(%rbp) 
    movl	$0, %eax 
    pushq   %rbp 
    movq    %rsp, %rbp 
    subq    $4, %rsp 
    movl    $0, _temp_r_2(%rip) 
    movl    _temp_r_2(%rip), %eax 
    leave 
    movl    %eax, _temp_r_19(%rip) 
    movl    _temp_r_19(%rip), %eax 
    movl    %eax, -12(%rbp) 
    movl    $0, _temp_r_28(%rip) 
L14: 
    movl    -4(%rbp), %eax 
    movl    %eax, _temp_r_20(%rip) 
    movl	$0, %eax 
    pushq   %rbp 
    movq    %rsp, %rbp 
    subq    $4, %rsp 
    movl    $0, _temp_r_2(%rip) 
    movl    _temp_r_2(%rip), %eax 
    leave 
    movl    %eax, _temp_r_21(%rip) 
    movl    _temp_r_20(%rip), %eax 
    cmpl    _temp_r_21(%rip), %eax 
    jle     L12 
    movl    $1, _temp_r_22(%rip) 
    jmp     L13 
L12: 
    movl    $0, _temp_r_22(%rip) 
L13: 
    movl    _temp_r_22(%rip), %eax 
    cmpl    _temp_r_28(%rip), %eax 
    je      L16 
L15: 
    movl    -12(%rbp), %eax 
    movl    %eax, _temp_r_23(%rip) 
    movl    -8(%rbp), %eax 
    movl    %eax, _temp_r_24(%rip) 
    movl    _temp_r_23(%rip), %edi 
    movl    _temp_r_24(%rip), %esi 
    movl	$0, %eax 
    pushq   %rbp 
    movq    %rsp, %rbp 
    subq    $12, %rsp 
    movl    %edi, -8(%rbp) 
    movl    %esi, -4(%rbp) 
    movl    $0, _temp_r_16(%rip) 
L8: 
    movl    -4(%rbp), %eax 
    movl    %eax, _temp_r_9(%rip) 
    movl	$0, %eax 
    pushq   %rbp 
    movq    %rsp, %rbp 
    subq    $4, %rsp 
    movl    $0, _temp_r_2(%rip) 
    movl    _temp_r_2(%rip), %eax 
    leave 
    movl    %eax, _temp_r_10(%rip) 
    movl    _temp_r_9(%rip), %eax 
    cmpl    _temp_r_10(%rip), %eax 
    jle     L6 
    movl    $1, _temp_r_11(%rip) 
    jmp     L7 
L6: 
    movl    $0, _temp_r_11(%rip) 
L7: 
    movl    _temp_r_11(%rip), %eax 
    cmpl    _temp_r_16(%rip), %eax 
    je      L10 
L9: 
    movl    -8(%rbp), %eax 
    movl    %eax, _temp_r_12(%rip) 
    movl    _temp_r_12(%rip), %edi 
    movl	$0, %eax 
    pushq   %rbp 
    movq    %rsp, %rbp 
    subq    $8, %rsp 
    movl    %edi, -4(%rbp) 
    movl    -4(%rbp), %eax 
    movl    %eax, _temp_r_6(%rip) 
    movl	$0, %eax 
    pushq   %rbp 
    movq    %rsp, %rbp 
    subq    $4, %rsp 
    movl    $1, _temp_r_1(%rip) 
    movl    _temp_r_1(%rip), %eax 
    leave 
    movl    %eax, _temp_r_7(%rip) 
    movl    _temp_r_6(%rip), %edx 
    movl    _temp_r_7(%rip), %eax 
    addl    %edx, %eax 
    movl    %eax, _temp_r_8(%rip) 
    movl    _temp_r_8(%rip), %eax 
    leave 
    movl    %eax, _temp_r_13(%rip) 
    movl    _temp_r_13(%rip), %eax 
    movl    %eax, -8(%rbp) 
    movl    -4(%rbp), %eax 
    movl    %eax, _temp_r_14(%rip) 
    movl    _temp_r_14(%rip), %edi 
    movl	$0, %eax 
    pushq   %rbp 
    movq    %rsp, %rbp 
    subq    $8, %rsp 
    movl    %edi, -4(%rbp) 
    movl    -4(%rbp), %eax 
    movl    %eax, _temp_r_3(%rip) 
    movl	$0, %eax 
    pushq   %rbp 
    movq    %rsp, %rbp 
    subq    $4, %rsp 
    movl    $1, _temp_r_1(%rip) 
    movl    _temp_r_1(%rip), %eax 
    leave 
    movl    %eax, _temp_r_4(%rip) 
    movl    _temp_r_3(%rip), %eax 
    subl    _temp_r_4(%rip), %eax 
    movl    %eax, _temp_r_5(%rip) 
    movl    _temp_r_5(%rip), %eax 
    leave 
    movl    %eax, _temp_r_15(%rip) 
    movl    _temp_r_15(%rip), %eax 
    movl    %eax, -4(%rbp) 
    jmp     L8 
L10: 
    movl    -8(%rbp), %eax 
    movl    %eax, _temp_r_18(%rip) 
    movl    _temp_r_18(%rip), %eax 
    leave 
    movl    %eax, _temp_r_25(%rip) 
    movl    _temp_r_25(%rip), %eax 
    movl    %eax, -12(%rbp) 
    movl    -4(%rbp), %eax 
    movl    %eax, _temp_r_26(%rip) 
    movl    _temp_r_26(%rip), %edi 
    movl	$0, %eax 
    pushq   %rbp 
    movq    %rsp, %rbp 
    subq    $8, %rsp 
    movl    %edi, -4(%rbp) 
    movl    -4(%rbp), %eax 
    movl    %eax, _temp_r_3(%rip) 
    movl	$0, %eax 
    pushq   %rbp 
    movq    %rsp, %rbp 
    subq    $4, %rsp 
    movl    $1, _temp_r_1(%rip) 
    movl    _temp_r_1(%rip), %eax 
    leave 
    movl    %eax, _temp_r_4(%rip) 
    movl    _temp_r_3(%rip), %eax 
    subl    _temp_r_4(%rip), %eax 
    movl    %eax, _temp_r_5(%rip) 
    movl    _temp_r_5(%rip), %eax 
    leave 
    movl    %eax, _temp_r_27(%rip) 
    movl    _temp_r_27(%rip), %eax 
    movl    %eax, -4(%rbp) 
    jmp     L14 
L16: 
    movl    -12(%rbp), %eax 
    movl    %eax, _temp_r_30(%rip) 
    movl    _temp_r_30(%rip), %eax 
    leave 
    movl    %eax, _temp_r_33(%rip) 
    movl    _temp_r_33(%rip), %eax 
    leave 
    ret 
