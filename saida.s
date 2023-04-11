    .text 
    .globl _a 
    .data 
_a: 
    .int   4 
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
    .globl _div 
_div: 
    pushq   %rbp 
    movq    %rsp, %rbp 
    subq    $12, %rsp 
    movl    %edi, -8(%rbp) 
    movl    %esi, -4(%rbp) 
    movl    -8(%rbp), %eax 
    movl    %eax, _temp_r_1(%rip) 
    movl    -4(%rbp), %eax 
    movl    %eax, _temp_r_2(%rip) 
    movl    _temp_r_1(%rip), %eax 
    cltd 
    idivl	_temp_r_2(%rip) 
    movl    %eax, _temp_r_3(%rip) 
    movl    _temp_r_3(%rip), %eax 
    leave 
    ret 
    .text 
    .globl _multiply 
_multiply: 
    pushq   %rbp 
    movq    %rsp, %rbp 
    subq    $16, %rsp 
    movl    %edi, -12(%rbp) 
    movl    %esi, -8(%rbp) 
    movl    %edx, -4(%rbp) 
    movl    -12(%rbp), %eax 
    movl    %eax, _temp_r_4(%rip) 
    movl    -8(%rbp), %eax 
    movl    %eax, _temp_r_5(%rip) 
    movl    _temp_r_4(%rip), %eax 
    imull   _temp_r_5(%rip), %eax 
    movl    %eax, _temp_r_6(%rip) 
    movl    -4(%rbp), %eax 
    movl    %eax, _temp_r_7(%rip) 
    movl    _temp_r_6(%rip), %eax 
    imull   _temp_r_7(%rip), %eax 
    movl    %eax, _temp_r_8(%rip) 
    movl    _temp_r_8(%rip), %eax 
    leave 
    ret 
    .text 
    .globl _main 
_main: 
    pushq   %rbp 
    movq    %rsp, %rbp 
    subq    $4, %rsp 
    movl    $2, _temp_r_9(%rip) 
    movl    $2, _temp_r_10(%rip) 
    movl    $2, _temp_r_11(%rip) 
    movl    _temp_r_9(%rip), %edi 
    movl    _temp_r_10(%rip), %esi 
    movl    _temp_r_11(%rip), %edx 
    movl	$0, %eax 
    call	_multiply 
    movl    %eax, _temp_r_12(%rip) 
    movl    _temp_r_12(%rip), %eax 
    movl    %eax, -4(%rbp) 
    movl    -4(%rbp), %eax 
    movl    %eax, _temp_r_13(%rip) 
    movl    $2, _temp_r_14(%rip) 
    movl    _temp_r_13(%rip), %edi 
    movl    _temp_r_14(%rip), %esi 
    movl	$0, %eax 
    call	_div 
    movl    %eax, _temp_r_15(%rip) 
    movl    _temp_r_15(%rip), %eax 
    movl    %eax, _a(%rip) 
    movl    _a(%rip), %eax 
    movl    %eax, _temp_r_16(%rip) 
    movl    _temp_r_16(%rip), %eax 
    leave 
    ret 
