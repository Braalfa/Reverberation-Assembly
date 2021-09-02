
%include        'math.asm'                             ; include our external file
%include        'filehandler.asm'                             ; include our external file

SECTION .data 
    alpha: dw 0000_0000_1000_0000b, 0h
    alpha_inv: dw 0000_0010_0000_0000b, 0h
    doublek: dw 5000, 0h

SECTION .text
global  _start
 
_start:


reverbexecution:
    call createoutputfile
    call copyheaders
    call initializeregisters
    call fillbuffer
    call reverb


reberbinverseexecution:
    call switchfile
    call createoutputfile
    call copyheaders
    call initializeregisters
    call fillbuffer
    call reverbreduction
    jmp end

initializeregisters:
    mov r14, 44
    mov r12, 0
    mov r13, 0
    ret


fillbuffer:
    call loadinputword ; se carga el input
    mov r8d, [input]
    mov [buffer+r12d], r8d
    mov [output], r8d
    call saveoutputword

    add r14d, 2
    add r12d, 2

    cmp r12d, [doublek]
    jl fillbuffer
    ret

reverb:
    call loadinputword ; se carga el input
    cmp     r15, 0
    je     return 

    mov r8d, 0000_0001_0000_0000b
    mov r9d, [alpha]
    call substraction

    mov r8d, r15d    
    mov r9d, [input]
    call multiplication
    mov r10d, r15d

    mov r8d, [alpha]
    mov r9d, [buffer+r13d]
    call multiplication

    mov r8, r10
    mov r9, r15
    call addition

    mov [output], r15d
    mov [buffer+r12d], r15d
    call saveoutputword

    call updatebufferpointers

    add r14d, 2
    jmp reverb

reverbreduction:
    call loadinputword ; se carga el input
    cmp     r15, 0
    je     return 

    mov r8d, [alpha]
    neg r8d
    mov r9d, [buffer+r13d]
    call multiplication

    mov r8d, [input]
    and r8d, [mask]
    mov [buffer+r12d], r8d
    mov r9d, r15d
    call addition

    mov r8d, [alpha_inv]
    mov r9d, r15d
    call multiplication

    mov [output], r15d
    call saveoutputword
    call updatebufferpointers

    add r14d, 2
    jmp reverbreduction


updatebufferpointers:
    add r13d, 2
    cmp r13d, [doublek]
    jbe skip1
    mov r13, 0 
skip1:
    add r12d, 2
    cmp r12d, [doublek]
    jbe skip2
    mov r12, 0 
skip2:
    ret

return:
    ret

end: 

    mov     ebx, 0
    mov     eax, 1
    int     80h