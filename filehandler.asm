SECTION .data
    input dw 0000_0000_0000_0000b, 0h
    output dw 0000_0000_0000_0000b, 0h

    buffer times 12001 dw 0, 0h  ; se define el buffer

    outputfilename db 'output1.wav', 0h    ; se definen los nombres de archivos
    inputfilename db 'input1.wav', 0h   
    outputfilename2 db 'output2.wav', 0h   
    inputfilename2 db 'input2.wav', 0h   


SECTION .text

switchfile: ; funcion para cambiar entrada de input 1 a input 2
    push r8
    mov r8, [inputfilename2]
    mov [inputfilename], r8
    mov r8, [outputfilename2]
    mov [outputfilename], r8
    pop r8
    ret

copyheaders: ; funcion para copiar los headers del archivo WAV
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

loadinputword: ; funcion para cargar una palabra de entrada
    push rdx
    push rcx
    push rbx
    push rax
    
    call openinput
    call updatefileposition
    call readinput
    
    mov r15, 1
    
    cmp     eax, 0 ; se compara cuando terminar
    jne     continue 
    mov r15, 0

continue:


    call closefile
    
    pop rax
    pop rbx
    pop rcx
    pop rdx
    ret

saveoutputword: ; funcion para guardar una palabra de salida
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

createoutputfile: ; funcion para crear el archivo de salida
    push rdx
    push rcx
    push rbx
    push rax

    mov     ecx, 0777o      
    mov     ebx, outputfilename 
    mov     eax, 8        
    int     80h           
    
    call closefile
        
    pop rax
    pop rbx
    pop rcx
    pop rdx

    ret 

openinput: ; funcion para abir el archivo de entrada
    mov     ecx, 0             
    mov     ebx, inputfilename  
    mov     eax, 5              
    int     80h        
    ret

updatefileposition: ; funcion para actualizar la posicion a leer/escribir
    mov     edx, 0   
    mov     ecx, r14d       
    mov     ebx, eax       
    mov     eax, 19           
    int     80h                
    ret

readinput: ; funcion para leer la entrada
    mov     edx, 2      
    mov     ecx, input    
    mov     ebx, ebx    
    mov     eax, 3   
    int     80h         

    ret

openoutput: ; funcion para abrir el archivo de salida
    mov     ecx, 1              
    mov     ebx, outputfilename  
    mov     eax, 5         
    int     80h              
    ret

write: ; funcion para escribir en la salida
    mov     edx, 2
    mov     ecx, output
    mov     ebx, ebx            
    mov     eax, 4  
    int     80h         
    ret 

closefile: ; funcion para cerrar el archivo
    mov     ebx, ebx          
    mov     eax, 6          
    int     80h           
    ret