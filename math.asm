SECTION .data
int_mask     dw   1111_1111_0000_0000b  
float_mask   dw  0000_0000_1111_1111b

SECTION .text

addition:
    mov r15d, r8d
    add r15d, r9d
    ret 


substraction:
    mov r15d, r8d
    sub r15d, r9d
    ret 


multiplication:

    push r10
    push r11
    push r12
    push r13
    push r14
    push rax
    push rbx
    push rcx
    push rdx


    mov r10d, r8d
    mov r11d, r8d
    and r10d, [int_mask]
    and r11d, [float_mask]
    shr r10d, 8

    mov r12d, r9d
    mov r13d, r9d
    and r12d, [int_mask]
    and r13d, [float_mask]
    shr r12d, 8
    
    push r8
    push r9

    mov r8d, r10d
    mov r9d, r12d  

    call multiplication_aux
    mov eax, r15d

    mov r8d, r10d
    mov r9d, r13d    

    call multiplication_aux
    mov ebx, r15d

    mov r8d, r11d
    mov r9d, r12d    

    call multiplication_aux
    mov ecx, r15d

    mov r8d, r11d
    mov r9d, r13d

    call multiplication_aux
    mov edx, r15d


    shl eax, 8
    shr edx, 8

    add eax, ebx
    add eax, ecx
    add eax, edx
    
    mov r15d, eax

    pop r9
    pop r8
    pop rdx
    pop rcx
    pop rbx
    pop rax
    pop r14
    pop r13
    pop r12
    pop r11
    pop r10

    ret 

multiplication_aux:
    push rax

    mov eax, r8d
    mul r9d
    mov r15d, eax

    pop rax
    ret

division: 
    push rax
    push rcx

    mov eax, r8d      
    mov r15d, 0
div1: 
    div r9d    
    mov r14, 0  
    mov r14d, eax
    shl r14d, 8
    add r15d, r14d
    mov eax, edx
div2: 

    div r9d    
    mov r14, 0  
    mov r14d, eax
    shr r14d, 24
    add r15d, r14d

    pop rcx
    pop rax
    
    ret
