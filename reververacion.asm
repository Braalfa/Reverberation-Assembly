
%include        'math.asm'                             ; include our external file
%include        'filehandler.asm'                             ; include our external file

SECTION .data
    alpha: dw 0000_0000_0110_0110b, 0h ; se define el alpha
    alpha_inv: dw 0, 0h ; espacio para almacenar alpha inverso
    alpha_minus: dw 0, 0h ; espacio para almacenar menos alfa
    k: dw 12000, 0h

SECTION .text
global  _start
 
_start:

updatek: ; funcion para duplicar k dado que una palabra ocupa dos bytes
    push rax
    push r8
    mov eax, [k]
    mov r8, 2
    mul r8
    mov [k], eax
    pop r8
    pop rax

calculateconstants: ; funcion para calcular las constantes de alpha

    mov r8d, 0000_0001_0000_0000b
    mov r9d, [alpha]
    call substraction
    mov [alpha_minus], r15d

    mov r8d, 0000_0001_0000_0000b
    mov r9d, r15d
    call division

    mov [alpha_inv], r15d

reverbexecution: ; funcion para ejecutar el procesamiento de reverberacion
    call createoutputfile
    call copyheaders
    call initializeregisters
    call fillbuffer
    call reverb


reberbinverseexecution: ; funcion para ejecutar la reduccion de reverberacion
    call switchfile
    call createoutputfile
    call copyheaders
    call initializeregisters
    call fillbuffer
    call reverbreduction
    jmp end

initializeregisters: ; se inicializan los registros de conteo
    mov r14, 44
    mov r12, 0
    mov r13, 0
    ret


fillbuffer: ; se llena el buffer y se copian los primeros datos
    call loadinputword 
    mov r8d, [input]
    mov [buffer+r12d], r8d
    mov [output], r8d
    call saveoutputword

    add r14d, 2
    add r12d, 2

    cmp r12d, [k]
    jl fillbuffer
    ret

reverb: ; se realiza el procesamiento de reververacion
    call loadinputword 
    cmp     r15, 0
    je     return 

    mov r8d, [alpha_minus]    
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

reverbreduction: ; se realiza la reduccion de reverberacion
    call loadinputword 
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


updatebufferpointers: ; funcion para actualizar los punteros del buffer
    add r13d, 2
    cmp r13d, [k]
    jbe skip1
    mov r13, 0 
skip1:
    add r12d, 2
    cmp r12d, [k]
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