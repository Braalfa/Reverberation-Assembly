
%include        'math.asm'                             ; include our external file
%include        'filehandler.asm'                             ; include our external file

SECTION .data 
    alpha: dw 0000_0000_1001_0000b, 0h
    kk: dw 5000, 0h

SECTION .text
global  _start
 
_start:
    

    call createoutputfile
    call copyheaders

    mov r14, 44
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
    mov r8, 2112 
    mov r9, 0 
f:
    mov r8, 0
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
    mov r8, r10
    mov r9, r15
    call addition
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
