%include 'bibliotecaE.inc'

extern printf, scanf
global main

section .data
filename_in db "fotoanonima.bmp", 0H ;declarando nome arquivo
filesize equ $ - filename_in               ;6480, 0H tamanho arquivo

request_filename_end db "digite nome do arquivo final :  ", 0H
request_filename db "digite nome do arquivo pra ser alterado :  ", 0H
request_x db "digite valor para coordenada x :  ", 0H
request_y db "digite valor para coordenada y :  ", 0H

format_string db "%s",
format_num db "%d",
;x dd 0 ;coordenada x
;y dd 0 ;coordenada y
;lenght dd 0 ;largura
;height dd 0 ;altura 

section .bss
fileHandle resd 1 ;4 bytes pra o handle  ;noGPTtinha fileHandleIN resd 4 e fileHandleOUT resd 1
buffer resb 6480 ;Descarregar Memoria 
integer_x resd 1 
integer_y resd 1
string_int resb 1

section .text 
main:
;mov eax, 8 ;OPEN_FILE // ignore

pergunta1:
push request_filename
call printf
add esp, 4

push string_int
push format_string
call scanf
add esp, 8 ;'4 + 4 bytes de integer1 e formatin'

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

;AQUI TA A MSG QUE VAI APARECER
;perguntaFileFim:
;push request_filename
;call printf
;add esp, 4
;
;push string_int
;push format_string
;call scanf
;add esp, 8 ;'4 + 4 bytes de integer1 e formatin'


abrir:
mov eax, 5                ;OPEN FILE
mov ebx, filename_in
mov ecx, 0                ;read only
mov edx, 0o777
int 80h

mov [fileHandle], eax

escrever:
mov eax, 3            ;WRITE FILE
mov ebx, [fileHandle]
mov ecx, buffer
mov edx, 10 ;bytes a serem escritos no arquivo (barra preta) (numero pode mudar)
;mov edx, filesize
int 80h
;jmp salvar? 


;manipular aquivo ---------------------------------------------------------
;loop? para ler linhas de byte

;salvar arquivo -----------------------------------------------------------
;mov eax, 4 ;sys_write
;mov ebx, 1 ;std_out
;mov ecx, buffer
;mov edx, filesize
;int 80h

;verificar:


fechar:
mov eax, CLOSE_FILE
mov ebx, [fileHandle]
int 80h

exit:
mov eax, 1
xor ebx, ebx
int 80h