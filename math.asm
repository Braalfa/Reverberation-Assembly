SECTION .data
sign_mask     dw   1000_0000_0000_0000b, 0h  
int_mask     dw   0111_1111_0000_0000b, 0h
float_mask   dw  0000_0000_1111_1111b, 0h
max     dw   0111_1111_1111_1111b, 0h
min     dw   1000_0000_0000_0000b, 0h
mask     dd   0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_1111_1111_1111_1111b, 0h

SECTION .text

addition:
    push r10
    push r11

    and r8, [mask]
    and r9, [mask]

    mov r10, r8
    mov r11, r9

    shl r10, 48
    shl r11, 48

    mov r15, r10
    add r15, r11
    

    jo additionoverflow

    shr r15, 48

endaddition:

    and r15, [mask]
    pop r11
    pop r10

    ret 


additionoverflow:

    mov r10, r8
    and r10, [sign_mask]

    cmp r10, 0
    
    je positiveoverflow
    jmp negativeoverflow

positiveoverflow:
    mov r15, [max]
    jmp endaddition 

negativeoverflow:
    mov r15, [min]
    jmp endaddition 

substraction:
    and r8, [mask]
    and r9, [mask]
    
    mov r15d, r8d
    sub r15d, r9d

    and r15, [mask]
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
    
    and r8, [mask]
    and r9, [mask]

    mov r10, r8
    mov r11, r9

    push r8
    push r9

    mov r8, r10
    mov r9, r11

    and r10, [sign_mask]
    and r11, [sign_mask]

    cmp r10, 0
    je invert9
    neg r8

invert9:

    cmp r11, 0
    je notinvertr9
    neg r9
    
notinvertr9:

    and r8, [mask]
    and r9, [mask]

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
    and r15, [mask]

    pop r9
    pop r8

    mov r10, r8
    mov r11, r9

    and r10, [sign_mask]
    and r11, [sign_mask]

    xor r10, r11

    cmp r10, 0
    je notinvert
    neg r15
    
notinvert:

    and r15, [mask]

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

    and r8, [mask]
    and r9, [mask]

    mov eax, r8d
    mul r9d
    mov r15d, eax

    and r15, [mask]

    pop rax
    ret

division: 
    push rax
    push rcx

    and r8, [mask]
    and r9, [mask]

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

    and r15, [mask]

    pop rcx
    pop rax
    
    ret
