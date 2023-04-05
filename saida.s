    .text 
    .globl _main 
    .text 
    .globl _temp_r_1 
    .zerofill __DATA,__common,_temp_r_1,4,2 
    .text 
    .globl _temp_r_2 
    .zerofill __DATA,__common,_temp_r_2,4,2 
    .text 
    .globl _temp_r_3 
    .zerofill __DATA,__common,_temp_r_3,4,2 
    .text 
    .globl _temp_r_4 
    .zerofill __DATA,__common,_temp_r_4,4,2 
_main: 
    pushq   %rbp 
    movq    %rsp, %rbp 
    movl    $10, _temp_r_1(%rip) 
    movl    _temp_r_1(%rip), %eax 
    movl    %eax, -8(%rbp) 
    movl    -8(%rbp), %eax 
    movl    %eax, _temp_r_2(%rip) 
    movl    _temp_r_2(%rip), %eax 
    negl	%eax 
    movl    %eax, _temp_r_3(%rip) 
    movl    _temp_r_3(%rip), %eax 
    movl    %eax, -12(%rbp) 
    movl    -12(%rbp), %eax 
    movl    %eax, _temp_r_4(%rip) 
    movl    _temp_r_4(%rip), %eax 
    popq	%rbp 
    ret 
