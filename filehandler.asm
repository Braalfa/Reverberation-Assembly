SECTION .data
    input dw 0000_0000_0000_0000b, 0h
    output dw 0000_0000_0000_0000b, 0h

    buffer times 2501 dw 0, 0h  ; the contents to write

    outputfilename db 'output1.wav', 0h    ; the filename to create
    inputfilename db 'input1.wav', 0h    ; the filename to create
    outputfilename2 db 'output2.wav', 0h    ; the filename to create
    inputfilename2 db 'input2.wav', 0h    ; the filename to create


SECTION .text

switchfile:
    push r8
    mov r8, [inputfilename2]
    mov [inputfilename], r8
    mov r8, [outputfilename2]
    mov [outputfilename], r8
    pop r8
    ret

copyheaders:
    push r14
    push r12
    push r8

    mov r14, 0
    mov r12, 0
headersloop:
    call loadinputword
    mov r8, [input]
    mov [output], r8
    call saveoutputword

    add r14, 2
    cmp r14, 44
    jl headersloop

    pop r8
    pop r12
    pop r14
    ret

loadinputword:
    push rdx
    push rcx
    push rbx
    push rax
    
    call openinput
    call updatefileposition
    call readinput
    
    mov r15, 1
    
    cmp     eax, 0
    jne     continue 
    mov r15, 0

continue:


    call closefile
    
    pop rax
    pop rbx
    pop rcx
    pop rdx
    ret

saveoutputword:
    push rdx
    push rcx
    push rbx
    push rax

    call openoutput
    call updatefileposition
    call write
    call closefile
    
    pop rax
    pop rbx
    pop rcx
    pop rdx
    ret

createoutputfile:
    push rdx
    push rcx
    push rbx
    push rax

    mov     ecx, 0777o          ; set all permissions to read, write, execute
    mov     ebx, outputfilename ; filename we will create
    mov     eax, 8              ; invoke SYS_CREAT (kernel opcode 8)
    int     80h                 ; call the kernel
    
    call closefile
        
    pop rax
    pop rbx
    pop rcx
    pop rdx

    ret 

openinput: 
    mov     ecx, 0              ; flag for readonly access mode (O_RDONLY)
    mov     ebx, inputfilename  ; filename we created above
    mov     eax, 5              ; invoke SYS_OPEN (kernel opcode 5)
    int     80h                 ; call the kernel
    ret

updatefileposition:
    mov     edx, 0          ; Put the reference position for the offset in the EDX register
    mov     ecx, r14d             ; Put the offset value in the ECX register
    mov     ebx, eax           ; move the opened file descriptor into EBX
    mov     eax, 19            ; Put the system call sys_lseek () number 19, in the EAX register
    int     80h                ; call the kernel
    ret

readinput:
    mov     edx, 2             ; number of bytes to read - one for each letter of the file contents
    mov     ecx, input          ; move the memory address of our file contents variable into ecx
    mov     ebx, ebx            ; move the opened file descriptor into EBX
    mov     eax, 3              ; invoke SYS_READ (kernel opcode 3)
    int     80h                 ; call the kernel

    ret

openoutput: 
    mov     ecx, 1              ; flag for writeonly access mode
    mov     ebx, outputfilename  ; filename we created above
    mov     eax, 5              ; invoke SYS_OPEN (kernel opcode 5)
    int     80h                 ; call the kernel
    ret

write:
    mov     edx, 2
    mov     ecx, output
    mov     ebx, ebx            ; move the file descriptor of the file we created into ebx
    mov     eax, 4              ; invoke SYS_WRITE (kernel opcode 4)
    int     80h                 ; call the kernel
    ret 

closefile:
    mov     ebx, ebx            ; not needed but used to demonstrate that SYS_CLOSE takes a file descriptor from EBX
    mov     eax, 6              ; invoke SYS_CLOSE (kernel opcode 6)
    int     80h                 ; call the kernel
    ret