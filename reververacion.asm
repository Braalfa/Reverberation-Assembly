
%include        'math.asm'                             ; include our external file
%include        'filehandler.asm'                             ; include our external file

SECTION .data
    alpha: dw 0000_0000_1000_0000b
    kk: dw 4

SECTION .text
global  _start
 
_start:

    call createoutputfile


    mov r14, 0
    mov r12, 0
    mov r13, 0

fillbuffer:
    call loadinputword ; se carga el input
    mov r8d, [input]
    mov [output+r12d], r8d
    call saveoutputword

    add r14d, 2
    add r12d, 2

    cmp r12d, [kk]
    jl fillbuffer

reverb:
    call loadinputword ; se carga el input
    mov r8, 0 
    mov r9, 0 
    mov r9d, [input]
f:
    cmp r8, [input]
    je end  ; si el input es 0 entonces se termina

    mov r8d, 0000_0001_0000_0000b
    mov r9d, [alpha]
    call substraction
a:
    mov r8d, r15d    
    mov r9d, [input]
    call multiplication
    mov r10d, r15d
b:
    mov r8d, [alpha]
    mov r9d, [output+r13d]
    call multiplication
c:
    add r15d, r10d
d:
    mov [output+r12d], r15d
    call saveoutputword

    call updatebufferpointers

    add r14d, 2
    jmp reverb

updatebufferpointers:
    add r13d, 2
    cmp r13d, [kk]
    jbe skip1
    mov r13, 0 
skip1:
    add r12d, 2
    cmp r12d, [kk]
    jbe skip2
    mov r12, 0 
skip2:
    ret

end: 

    mov     ebx, 0
    mov     eax, 1
    int     80h