;Autor: Castellanos Sulub Angel Alberto

%macro imprime 5
    mov eax, 4
    mov ebx, 1
    mov ecx, %1
    mov edx, %2
    int 0x80

    cmp byte [%3], 10
    jg %%saltar
    jmp %%final

%%saltar:
    mov byte [%3], 0
    imprime2 %4, %5 

%%final:
%endmacro

%macro imprime2 2
    mov eax, 4  ; Número de sistema para escribir en la salida estándar
    mov ebx, 1  ; Descriptor de archivo para stdout (1)
    mov ecx, %1 ; Dirección de la cadena de texto
    mov edx, %2 ; Longitud de la cadena de texto
    int 0x80    ; Llamar a la syscall write

%endmacro

section .data
    op1 db 10, 13, 7, '1. Distancia Euclidiana', 0
    op2 db 10, 13, 7, '2. Distancia Manhatan', 0
    op3 db 10, 13, 7, '3. Distancia Manhalanobis', 0
    op4 db 10, 13, 7, '4. Salir del programa', 0
    prompt: db 10, 13, 7, 'Seleccione una opcion: ', 0
    buffer: times 2 db 0   ; Buffer para almacenar la opción seleccionada
    MsgError db 10, 13, 7, 'Opcion invalida', 10, 13, 7, 0
    Msgop1 db 10, 13, 7, 'Escoja las coordenadas de izquierda a derecha y de abajo hacia arriba', 0
    Msgop12 db 10, 13, 7, 'Escoja el segundo grupo de coordenadas', 0
    Msgop2 db 10, 13, 7, 'No implementado', 0
    Msgop3 db 10, 13, 7, 'Adios', 0
    buffer2: times 2 db 0   ; Buffer para almacenar la opción seleccionada
    
    matrixc db '001 ', '002 ', '003 ', '004 ', '005 ', '006 ', '007 ', '008 ', '009 ', '010 ', '011 ', '012 ', '013 ', '014 ', '015 ', '016 ', '017 ', '018 ', '019 ', '020 ', '021 ', '022 ', '023 ', '024 ', '025 ', '026 ', '027 ', '028 ', '029 ', '030 ', '031 ', '032 ', '033 ', '034 ', '035 ', '036 ', '037 ', '038 ', '039 ', '040 ', '041 ', '042 ', '043 ', '044 ', '045 ', '046 ', '047 ', '048 ', '049 ', '050 ', '051 ', '052 ', '053 ', '054 ', '055 ', '056 ', '057 ', '058 ', '059 ', '060 ', '061 ', '062 ', '063 ', '064 ', '065 ', '066 ', '067 ', '068 ', '069 ', '070 ', '071 ', '072 ', '073 ', '074 ', '075 ', '076 ', '077 ', '078 ', '079 ', '080 ', '081 ', '082 ', '083 ', '084 ', '085 ', '086 ', '087 ', '088 ', '089 ', '090 ', '091 ', '092 ', '093 ', '094 ', '095 ', '096 ', '097 ', '098 ', '099 ', '100 ', '101 ', '102 ', '103 ', '104 ', '105 ', '106 ', '107 ', '108 ', '109 ', '110 ', '111 ', '112 ', '113 ', '114 ', '115 ', '116 ', '117 ', '118 ', '119 ', '120 ', '121 '

    coordenada1 db 0
    coordenada2 db 0
    coordenada3 db 0
    coordenada4 db 0
    lenm equ $-matrixc-7

    salto db 0

    ln db 0xA, 0xD
    lenln equ $-ln

    mstring times lenm db 0  ; String de destino, inicializado con ceros

    len equ $-mstring

    result db "El número ingresado es: "  ; Mensaje para mostrar el número ingresado
    result_len equ $-result

    resultado db 0, 0, 0, 0, 0

section .text
global _start

_start:

menu:
    mov eax, 0
    mov ebx, 0
    mov ecx, 0
    mov edx, 0
    mov dword[resultado], 0
    mov ebp, matrixc
    mov edi, 0
    mov byte [salto], 0

imprimir_matriz:
    inc byte [salto]
    imprime ebp, 4, salto, ln, lenln
    add ebp, 4
    add edi, 4

    cmp edi, len
    jb imprimir_matriz

    ; Mostrar opción 1
    imprime2 op1, 23
    
    ; Mostrar opción 2
    imprime2 op2, 24
    
    ; Mostrar opción 3
    imprime2 op3, 28          
    
    ; Mostrar opción 4
    imprime2 op4, 24   
    
    ; Solicita la opción al usuario
    imprime2 prompt, 26
    syscall  

; Lee la opción seleccionada
    mov rdx, 2       ; Longitud máxima de lectura (2 bytes)
    mov rsi, buffer  ; Dirección del buffer de lectura
    mov rdi, 0       ; Descriptor de archivo para stdin (0)
    mov eax, 0       ; Número de sistema para leer
    syscall          ; Llama a la syscall read para leer la opción
    
    ; Convierte la opción a un número
    xor eax, eax
    mov al, byte [buffer]        ; Carga el primer byte del buffer
    sub al, 48                  ; Resta 48 para convertir el código ASCII a número

    ; Evalúa la opción seleccionada
    cmp al, 1
    je op_1
    cmp al, 2
    je op_2
    cmp al, 3
    je op_3
    cmp al, 4
    je salir

    ; Opción inválida
    jmp invalida

op_1:
    imprime2 Msgop1, 73
    imprime2 ln, lenln

    ; Leer los dos bytes ingresados por el usuario
    mov eax, 3
    mov ebx, 0
    mov ecx, buffer2
    mov edx, 2  ; Leemos dos bytes
    int 0x80

    ; Convertir los dos bytes en un número de 16 bits
    movzx eax, word [buffer2]

    ; Mover el valor convertido a la variable "coordenada1"
    movzx eax, ax
    mov dword [coordenada1], eax

    imprime2 ln, lenln

    ; Leer los dos bytes ingresados por el usuario
    mov eax, 3
    mov ebx, 0
    mov ecx, buffer2
    mov edx, 2  ; Leemos dos bytes
    int 0x80

    ; Convertir los dos bytes en un número de 16 bits
    movzx eax, word [buffer2]

    ; Mover el valor convertido a la variable "coordenada2"
    movzx eax, ax
    mov dword [coordenada2], eax

    imprime2 ln, lenln

    imprime2 Msgop12, 42
    imprime2 ln, lenln

    ; Leer los dos bytes ingresados por el usuario
    mov eax, 3
    mov ebx, 0
    mov ecx, buffer2
    mov edx, 2  ; Leemos dos bytes
    int 0x80

    ; Convertir los dos bytes en un número de 16 bits
    movzx eax, word [buffer2]

    ; Mover el valor convertido a la variable "coordenada3"
    movzx eax, ax
    mov dword [coordenada3], eax

    imprime2 ln, lenln

    ; Leer los dos bytes ingresados por el usuario
    mov eax, 3
    mov ebx, 0
    mov ecx, buffer2
    mov edx, 2  ; Leemos dos bytes
    int 0x80

    ; Convertir los dos bytes en un número de 16 bits
    movzx eax, word [buffer2]

    ; Mover el valor convertido a la variable "coordenada4"
    movzx eax, ax
    mov dword [coordenada4], eax

    ; Calcular la distancia euclidiana
    mov eax, dword [coordenada3]
    sub eax, dword [coordenada1]; (x2 - x1)
    imul eax, eax               ; (x2 - x1)^2
    mov edx, dword [coordenada4]
    sub edx, dword [coordenada2]; (y2 - y1)
    imul edx, edx               ; (y2 - y1)^2
    add eax, edx                ; (x2 - x1)^2 + (y2 - y1)^2
    fsqrt                       ;sacar la raiz cuadrada

    ; Convertir el resultado de punto flotante a entero
    fistp dword [resultado]

    ; Mostrar el resultado
    mov eax, 4
    mov ebx, 1
    mov ecx, resultado
    mov edx, 4
    int 0x80

    ;volver al menu
    jmp menu

    
op_2:
    imprime2 Msgop1, 74
    imprime2 ln, lenln

    ; Leer los dos bytes ingresados por el usuario
    mov eax, 3
    mov ebx, 0
    mov ecx, buffer2
    mov edx, 2  ; Leemos dos bytes
    int 0x80

    ; Convertir los dos bytes en un número de 16 bits
    movzx eax, word [buffer2]

    ; Mover el valor convertido a la variable "coordenada1"
    movzx eax, ax
    mov dword [coordenada1], eax

    imprime2 ln, lenln

    ; Leer los dos bytes ingresados por el usuario
    mov eax, 3
    mov ebx, 0
    mov ecx, buffer2
    mov edx, 2  ; Leemos dos bytes
    int 0x80

    ; Convertir los dos bytes en un número de 16 bits
    movzx eax, word [buffer2]

    ; Mover el valor convertido a la variable "coordenada2"
    movzx eax, ax
    mov dword [coordenada2], eax

    imprime2 ln, lenln

    imprime2 Msgop12, 42
    imprime2 ln, lenln

    ; Leer los dos bytes ingresados por el usuario
    mov eax, 3
    mov ebx, 0
    mov ecx, buffer2
    mov edx, 2  ; Leemos dos bytes
    int 0x80

    ; Convertir los dos bytes en un número de 16 bits
    movzx eax, word [buffer2]

    ; Mover el valor convertido a la variable "coordenada3"
    movzx eax, ax
    mov dword [coordenada3], eax

    imprime2 ln, lenln

    ; Leer los dos bytes ingresados por el usuario
    mov eax, 3
    mov ebx, 0
    mov ecx, buffer2
    mov edx, 2  ; Leemos dos bytes
    int 0x80

    ; Convertir los dos bytes en un número de 16 bits
    movzx eax, word [buffer2]

    ; Mover el valor convertido a la variable "coordenada4"
    movzx eax, ax
    mov dword [coordenada4], eax

    ; Calcular la distancia Manhattan
    mov eax, dword [coordenada3]
    sub eax, dword [coordenada1];x2-x1
    mov edx, dword [coordenada4]
    sub edx, dword [coordenada2];y2-y1
    add eax, edx

    ; Mostrar el resultado
    mov eax, 4
    mov ebx, 1
    mov ecx, resultado
    mov edx, 4
    int 0x80

    ;volver al menu
    jmp menu

    
op_3:
;perdon no implementado
    imprime2 Msgop2, 20
    ;volver al menu
    jmp menu
    
salir:
;Despedida
    imprime2 Msgop3, 10
    imprime2 ln, lenln
    ;salir del programa
    jmp _exit

invalida:
;Opción invalida
    imprime2 MsgError,19
    ;volver al menu
    jmp menu
    
_exit:
    ; Salir del programa
    mov eax, 60                  ; Número de sistema para salir
    xor edi, edi                 ; Código de salida 0
    syscall                      ; Llama a la syscall exit
