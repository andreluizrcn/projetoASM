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
    ; Largura fixa do bloco de leitura (6480 bytes)
    mov ecx, 6480

    linha_loop:
        ; Ler um bloco de pixels
        mov eax, 3 ; Ler arquivo de entrada
        mov ebx, [fileHandle]
        mov edx, ecx
        int 80h

        ; Aqui, você deve implementar a lógica para censurar a região retangular.
        ; Percorra os bytes lidos (representando pixels) e aplique a censura na área especificada.
        
        ; Registro ECX deve conter o número de bytes lidos no bloco
        
        censurar_pixels:
            ; Verifique se a posição atual (posição_x, posição_y) está dentro da área a ser censurada
            ; Lembre-se de que as coordenadas crescem da esquerda para a direita e de baixo para cima em arquivos BMP.
            ; Portanto, X=250 e Y=310 representam o canto superior esquerdo da área a ser censurada.
            ; Largura=230 e altura=30
            
            ; Calcule a posição atual em relação ao início do bloco
            ; Suponha que a imagem tenha uma profundidade de cor de 24 bits (3 bytes por pixel).
            ; A largura da imagem é importante para calcular o deslocamento.

            ; Deslocamento atual no bloco
            mov esi, ecx
            sub esi, edx

            ; Calcule a posição_x e posição_y dentro da imagem completa
            mov eax, [integer_x]
            add eax, esi
            mov ebx, [integer_y]
            add ebx, 1 ; Lembre-se de que as coordenadas crescem de baixo para cima
            sub ebx, ecx
            sub ebx, edx

            ; Verifique se a posição_x e posição_y estão dentro da área a ser censurada
            ; X=250, Y=310, largura=230, altura=30
            mov edx, [integer_width]
            add edx, 250
            cmp eax, 250
            jl pixel_fora_da_area_x
            cmp eax, edx
            jge pixel_fora_da_area_x

            mov edx, [integer_height]
            add edx, 310
            cmp ebx, 310
            jl pixel_fora_da_area_y
            cmp ebx, edx
            jge pixel_fora_da_area_y

            ; Pixel está dentro da área a ser censurada, substitua-o por preto (0, 0, 0)
            mov byte [ecx], 0 ; Blue
            mov byte [ecx + 1], 0 ; Green
            mov byte [ecx + 2], 0 ; Red

            pixel_fora_da_area_y:

            pixel_fora_da_area_x:
            
            ; Continue verificando os próximos pixels
            add ecx, 3
            loop censurar_pixels

        ; Escrever o bloco de pixels (possivelmente censurados) no arquivo de saída
        mov eax, 5 ; Abrir arquivo de saída
        mov ebx, filename_out
        mov ecx, 1 ; Modo de escrita
        mov edx, 0o777
        int 80h
        mov [fileHandle], eax

        mov eax, 4 ; Escrever no arquivo de saída
        mov ebx, [fileHandle]
        mov ecx, buffer ; Coloque aqui os bytes censurados
        int 80h

        ; Continue lendo e censurando o restante da imagem
        loop linha_loop
