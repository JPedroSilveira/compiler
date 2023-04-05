    .text 
    .globl _goodbye 
    .text 
    .globl _temp_r_1 
    .zerofill __DATA,__common,_temp_r_1,4,2 
    .text 
    .globl _temp_r_2 
    .zerofill __DATA,__common,_temp_r_2,4,2 
    .text 
    .globl _hello 
    .text 
    .globl _temp_r_3 
    .zerofill __DATA,__common,_temp_r_3,4,2 
    .text 
    .globl _temp_r_4 
    .zerofill __DATA,__common,_temp_r_4,4,2 
    .text 
    .globl _temp_r_5 
    .zerofill __DATA,__common,_temp_r_5,4,2 
    .text 
    .globl _temp_r_6 
    .zerofill __DATA,__common,_temp_r_6,4,2 
    .text 
    .globl _temp_r_7 
    .zerofill __DATA,__common,_temp_r_7,4,2 
    .text 
    .globl _temp_r_8 
    .zerofill __DATA,__common,_temp_r_8,4,2 
    .text 
    .globl _temp_r_9 
    .zerofill __DATA,__common,_temp_r_9,4,2 
    .text 
    .globl _temp_r_10 
    .zerofill __DATA,__common,_temp_r_10,4,2 
    .text 
    .globl _main 
    .text 
    .globl _temp_r_11 
    .zerofill __DATA,__common,_temp_r_11,4,2 
    .text 
    .globl _temp_r_12 
    .zerofill __DATA,__common,_temp_r_12,4,2 
    .text 
    .globl _temp_r_13 
    .zerofill __DATA,__common,_temp_r_13,4,2 
    .text 
    .globl _temp_r_14 
    .zerofill __DATA,__common,_temp_r_14,4,2 
    .text 
    .globl _temp_r_15 
    .zerofill __DATA,__common,_temp_r_15,4,2 
    .text 
    .globl _temp_r_16 
    .zerofill __DATA,__common,_temp_r_16,4,2 
    .text 
    .globl _temp_r_17 
    .zerofill __DATA,__common,_temp_r_17,4,2 
    .text 
    .globl _temp_r_18 
    .zerofill __DATA,__common,_temp_r_18,4,2 
    .text 
    .globl _temp_r_19 
    .zerofill __DATA,__common,_temp_r_19,4,2 
    .text 
    .globl _temp_r_20 
    .zerofill __DATA,__common,_temp_r_20,4,2 
    .text 
    .globl _temp_r_21 
    .zerofill __DATA,__common,_temp_r_21,4,2 
    .text 
    .globl _temp_r_22 
    .zerofill __DATA,__common,_temp_r_22,4,2 
    .text 
    .globl _temp_r_23 
    .zerofill __DATA,__common,_temp_r_23,4,2 
    .text 
    .globl _temp_r_24 
    .zerofill __DATA,__common,_temp_r_24,4,2 
    .text 
    .globl _temp_r_25 
    .zerofill __DATA,__common,_temp_r_25,4,2 
    .text 
    .globl _temp_r_26 
    .zerofill __DATA,__common,_temp_r_26,4,2 
    .text 
    .globl _temp_r_27 
    .zerofill __DATA,__common,_temp_r_27,4,2 
    .text 
    .globl _temp_r_28 
    .zerofill __DATA,__common,_temp_r_28,4,2 
_goodbye: 
    pushq   %rbp 
    movq    %rsp, %rbp 
    subq    $4, %rsp 
    movl    $2, _temp_r_1(%rip) 
    movl    _temp_r_1(%rip), %eax 
    movl    %eax, -4(%rbp) 
    movl    -4(%rbp), %eax 
    movl    %eax, _temp_r_2(%rip) 
    movl    _temp_r_2(%rip), %eax 
    leave 
    ret 
_hello: 
    pushq   %rbp 
    movq    %rsp, %rbp 
    subq    $4, %rsp 
    movl    $1, _temp_r_3(%rip) 
    movl    _temp_r_3(%rip), %eax 
    movl    %eax, -4(%rbp) 
    movl    $1, _temp_r_4(%rip) 
    movl    _temp_r_4(%rip), %eax 
    movl    %eax, -8(%rbp) 
    movl    $1, _temp_r_5(%rip) 
    movl    _temp_r_5(%rip), %eax 
    movl    %eax, -12(%rbp) 
    movl    -4(%rbp), %eax 
    movl    %eax, _temp_r_6(%rip) 
    movl    -8(%rbp), %eax 
    movl    %eax, _temp_r_7(%rip) 
    movl    _temp_r_6(%rip), %edx 
    movl    _temp_r_7(%rip), %eax 
    addl    %edx, %eax 
    movl    %eax, _temp_r_8(%rip) 
    movl    -12(%rbp), %eax 
    movl    %eax, _temp_r_9(%rip) 
    movl    _temp_r_8(%rip), %edx 
    movl    _temp_r_9(%rip), %eax 
    addl    %edx, %eax 
    movl    %eax, _temp_r_10(%rip) 
    movl    _temp_r_10(%rip), %eax 
    leave 
    ret 
_main: 
    pushq   %rbp 
    movq    %rsp, %rbp 
    subq    $16, %rsp 
    movl	$0, %eax 
    call	_hello 
    movl    %eax, _temp_r_11(%rip) 
    movl    _temp_r_11(%rip), %eax 
    movl    %eax, -12(%rbp) 
    movl	$0, %eax 
    call	_hello 
    movl    %eax, _temp_r_12(%rip) 
    movl    _temp_r_12(%rip), %eax 
    movl    %eax, -8(%rbp) 
    movl	$0, %eax 
    call	_goodbye 
    movl    %eax, _temp_r_13(%rip) 
    movl    _temp_r_13(%rip), %eax 
    movl    %eax, -4(%rbp) 
    movl    $10, _temp_r_14(%rip) 
    movl    _temp_r_14(%rip), %eax 
    movl    %eax, -20(%rbp) 
    movl    -12(%rbp), %eax 
    movl    %eax, _temp_r_15(%rip) 
    movl    -8(%rbp), %eax 
    movl    %eax, _temp_r_16(%rip) 
    movl    _temp_r_15(%rip), %eax 
    imull   _temp_r_16(%rip), %eax 
    movl    %eax, _temp_r_17(%rip) 
    movl    -4(%rbp), %eax 
    movl    %eax, _temp_r_18(%rip) 
    movl    _temp_r_17(%rip), %eax 
    imull   _temp_r_18(%rip), %eax 
    movl    %eax, _temp_r_19(%rip) 
    movl    -20(%rbp), %eax 
    movl    %eax, _temp_r_20(%rip) 
    movl    _temp_r_19(%rip), %eax 
    imull   _temp_r_20(%rip), %eax 
    movl    %eax, _temp_r_21(%rip) 
    movl    $1000, _temp_r_22(%rip) 
    movl    _temp_r_21(%rip), %eax 
    cmpl    _temp_r_22(%rip), %eax 
    jle     L4 
    movl    $1, _temp_r_23(%rip) 
    jmp     L5 
L4: 
    movl    $0, _temp_r_23(%rip) 
L5: 
    movl    $0, _temp_r_26(%rip) 
    movl    _temp_r_23(%rip), %eax 
    cmpl    _temp_r_26(%rip), %eax 
    je      L7 
L6: 
    movl    $1, _temp_r_24(%rip) 
    movl    _temp_r_24(%rip), %eax 
    movl    %eax, -16(%rbp) 
    jmp     L8 
L7: 
    movl    $2, _temp_r_25(%rip) 
    movl    _temp_r_25(%rip), %eax 
    movl    %eax, -16(%rbp) 
L8: 
    movl    -16(%rbp), %eax 
    movl    %eax, _temp_r_28(%rip) 
    movl    _temp_r_28(%rip), %eax 
    leave 
    ret 
