
SECTION .data
int_mask     dw   1111_1111_0000_0000b  
float_mask   dw  0000_0000_1111_1111b

SECTION .text
global  _start
 
_start:

    mov r9, 0000_0001_1000_0000b
    mov r8, 0000_0011_0100_0000b
    call division_float
    jmp end        

addition:
    mov r15, r8
    add r15, r9
    ret 


multiplication_float:

    push r10
    push r11
    push r12
    push r13
    push r14
    push rax
    push rbx
    push rcx
    push rdx


    mov r10, r8
    mov r11, r8
    and r10, [int_mask]
    and r11, [float_mask]
    shr r10, 8

    mov r12, r9
    mov r13, r9
    and r12, [int_mask]
    and r13, [float_mask]
    shr r12, 8
    
    push r8
    push r9

    mov r8, r10
    mov r9, r12    

    call multiplication
    mov rax, r15

    mov r8, r10
    mov r9, r13    

    call multiplication
    mov rbx, r15

    mov r8, r11
    mov r9, r12    

    call multiplication
    mov rcx, r15

    mov r8, r11
    mov r9, r13

    call multiplication
    mov rdx, r15


    shl rax, 8
    shr rdx, 8

    add rax, rbx
    add rax, rcx
    add rax, rdx
    
    mov r15, rax

    pop r8
    pop r9
    pop r10
    pop r11
    pop r12
    pop r13
    pop r14
    pop rax
    pop rbx
    pop rcx
    pop rdx

    ret 

multiplication:
    push rax

    mov eax, r8d
    mul r9
    mov r15d, eax
    
    pop rax
    ret

division_float: 

    push rax
    
    mov eax, r8d  
    div r9      
    mov r15, rax
    
    pop rax
    
    ret

end: 

    mov     ebx, 0
    mov     eax, 1
    int     80h