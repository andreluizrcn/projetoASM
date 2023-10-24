extern printf, scanf
global main

;declarando variaveis n inicializadas --------------------------------------
section .bss
fileHandle resd 1 ;4 bytes pra o handle  ;noGPTtinha fileHandleIN resd 4 e fileHandleOUT resd 1
buffer resb 6480 ;Descarregar Memoria


section .data
filename db "fotoanonima.bmp", 0H ;declarando nome arquivo
filesize equ $ - filename               ;6480, 0H tamanho arquivo


section .text 
main:

;criacao/abrir aquivo -----------------------------------------------------
mov eax, 8 ;OPEN_FILE
mov ebx, filename
mov ecx, 0
mov ecx, 0o777
int 80h
;mov fileHandle, eax

;ler arquivo --------------------------------------------------------------
mov [fileHandle], eax
mov eax, 3
mov ebx, [fileHandle]
mov ecx, buffer
mov edx, filesize
int 80h


;manipular aquivo ---------------------------------------------------------


;salvar arquivo -----------------------------------------------------------
mov eax, 4 ;sys_write
mov ebx, 1 ;std_out
mov ecx, buffer
mov edx, filesize
int 80h

;fechar arquivo ----------------------------------------------------------
mov eax, 6
mov ebx, [fileHandle]
int 80h

;fim padrao --------------------------------------------------------------
mov eax, 1
xor ebx, ebx
int 80h