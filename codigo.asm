%include 'bibliotecaE.inc'

extern printf, scanf
global main

section .data

request_filename_end db "nome do arquivo de saída:  ", 0AH, 0H
request_filename db "nome do arquivo de entrada:  ", 0AH,0H
request_x db "coordenada x:  ", 0AH,0H
request_y db "coordenada y:  ", 0AH,0H
request_width db "largura do retângulo:  ", 0AH,0H
request_height db "altura do retângulo:  ", 0AH,0H

format_string db "%s",0H
format_num db "%d",0H

section .bss
fileHandle resd 1 ; Handle do arquivo
fileBuffer resb 54 ; Buffer para os primeiros 54 bytes do arquivo
integer_x resd 1 
integer_y resd 1
integer_width resd 1
integer_height resd 1
filename_in resb 300
filename_out resb 300 

section .text 
main:
; Passo 1: perguntar as coisas
pergunta1:
push request_filename
call printf
add esp, 4

push filename_in
push format_string
call scanf
add esp, 8

perguntaX:
push request_x
call printf
add esp, 4

push integer_x
push format_num
call scanf
add esp, 8

perguntaY:
push request_y
call printf
add esp, 4

push integer_y
push format_num
call scanf
add esp, 8

perguntaWidth:
push request_width
call printf
add esp, 4

push integer_width
push format_num
call scanf
add esp, 8
 
perguntaHeight:
push request_height
call printf
add esp, 4

push integer_height
push format_num
call scanf
add esp, 8

PerguntaNovoArquivo:
push request_filename_end
call printf
add esp, 4

push filename_out
push format_string
call scanf
add esp, 8


; Passo 2: Abertura do Arquivo 1 e 2
abrir_1:
mov eax, 5 ; Abrir arquivo
mov ebx, filename_in
mov ecx, 0 ; Modo de leitura
mov edx, 0o777
int 80h
mov [fileHandle], eax

; Ler os primeiros 54 bytes do arquivo
mov eax, 3 ; Ler arquivo
mov ebx, [fileHandle]
mov ecx, fileBuffer
mov edx, 54
int 80h

abrir_2: ;arquivo 2
; Escrever os primeiros 54 bytes no arquivo de saída
mov eax, 5 ; Abrir arquivo de saída
mov ebx, filename_out
mov ecx, 1 ; Modo de escrita
mov edx, 0o777
int 80h
mov [fileHandle], eax

mov eax, 4 ; Escrever no arquivo de saída
mov ebx, [fileHandle]
mov ecx, fileBuffer
mov edx, 54
int 80h

; Passo 3: Leitura e Escrita dos Pixels
censurar:
mov eax, 3 ; Ler arquivo de entrada
mov ebx, [fileHandle]
mov ecx, fileBuffer
mov edx, 54 ; Lê os próximos 54 bytes da imagem (cabeçalho)
int 80h

; Loop para ler e censurar cada linha da imagem
linha_loop:
    mov eax, 3 ; Ler arquivo de entrada
    mov ebx, [fileHandle]
    mov ecx, fileBuffer
    mov edx, 6480 ;
    int 80h

fim:
mov eax, 1
xor ebx, ebx
int 80h