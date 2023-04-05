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
    .globl _temp_r_11 
    .zerofill __DATA,__common,_temp_r_11,4,2 
_main: 
    pushq   %rbp 
    movq    %rsp, %rbp 
    subq    $4, %rsp 
    movl    $1, _temp_r_1(%rip) 
    movl    _temp_r_1(%rip), %eax 
    movl    %eax, -4(%rbp) 
    movl    $6, _temp_r_2(%rip) 
    movl    _temp_r_2(%rip), %eax 
    movl    %eax, -8(%rbp) 
    movl    $0, _temp_r_9(%rip) 
L4: 
    movl    -4(%rbp), %eax 
    movl    %eax, _temp_r_3(%rip) 
    movl    -8(%rbp), %eax 
    movl    %eax, _temp_r_4(%rip) 
    movl    _temp_r_3(%rip), %eax 
    cmpl    _temp_r_4(%rip), %eax 
    jge     L2 
    movl    $1, _temp_r_5(%rip) 
    jmp     L3 
L2: 
    movl    $0, _temp_r_5(%rip) 
L3: 
    movl    _temp_r_5(%rip), %eax 
    cmpl    _temp_r_9(%rip), %eax 
    je      L6 
L5: 
    movl    -4(%rbp), %eax 
    movl    %eax, _temp_r_6(%rip) 
    movl    $1, _temp_r_7(%rip) 
    movl    _temp_r_6(%rip), %edx 
    movl    _temp_r_7(%rip), %eax 
    addl    %edx, %eax 
    movl    %eax, _temp_r_8(%rip) 
    movl    _temp_r_8(%rip), %eax 
    movl    %eax, -4(%rbp) 
    jmp     L4 
L6: 
    movl    -4(%rbp), %eax 
    movl    %eax, _temp_r_11(%rip) 
    movl    _temp_r_11(%rip), %eax 
    leave 
    ret 
