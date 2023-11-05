;include 'bibliotecaE.inc' // USEI MAIS COMO REFERENCIA DO QUE COLOCAR NOS REGISTRADORES

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
;output_filename db "censura.bmp", 0

section .bss
fileHandleIn resd 1 ; Handle do arquivo de entrada
fileHandleOut resd 1 ; Handle do arquivo de saída
fileBuffer resb 54 ; Buffer para os primeiros 54 bytes do arquivo
buffer resb 6480
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

    ; Passo 2: Abertura do Arquivo de Entrada
    abrir_entrada:
    mov eax, 5 ; Abrir arquivo de entrada
    mov ebx, filename_in
    mov ecx, 0 ; Modo de leitura
    mov ecx, 0o777
    int 80h
    mov dword [fileHandleIn], eax

    ; Passo 3: Abertura do Arquivo de Saída
    abrir_saida:
    mov eax, 8 ; Abrir arquivo de saída
    mov ebx, filename_out
    mov ecx, 0o777 ; Modo de escrita
    int 80h
    mov dword [fileHandleOut], eax

    ; Passo 4: Ler os primeiros 54 bytes do arquivo de entrada
    ler_cabecalho:
    mov eax, 3 ; Ler arquivo de entrada
    mov ebx, dword [fileHandleIn]
    mov ecx, fileBuffer
    mov edx, 10
    int 80h

    ; Passo 5: Escrever os primeiros 54 bytes no arquivo de saída
    escrever_cabecalho:
    mov eax, 4 ; Escrever no arquivo de saída
    mov ebx, dword [fileHandleOut]
    mov ecx, fileBuffer
    mov edx, 10
    int 80h

    ; Lógica de censura - suponha que as coordenadas e dimensões sejam válidas
    censurar_retangulo:
    mov edi, [integer_x]      ; Coordenada X inicial
    mov esi, [integer_y]      ; Coordenada Y inicial
    mov edx, [integer_width]  ; Largura da censura
    mov ebp, [integer_height] ; Altura da censura

    ; Loop para censurar linha por linha
    linha_loop:
    cmp esi, [integer_y]         ; Verifique se estamos dentro do retângulo na coordenada Y
    jl pular_censura
    cmp esi, [integer_y]         ; Verifique se estamos dentro do retângulo na coordenada Y
    jg pular_censura
    cmp edi, [integer_x]         ; Verifique se estamos dentro do retângulo na coordenada X
    jl pular_censura
    cmp edi, [integer_x]         ; Verifique se estamos dentro do retângulo na coordenada X
    jg pular_censura

    ; Se estamos dentro do retângulo, censure o pixel
    mov eax, 3 ; Ler um pixel da imagem de entrada
    mov ebx, [fileHandleIn]
    mov ecx, fileBuffer
    mov edx, 3  ; Tamanho de um pixel em bytes (neste caso, supomos que cada pixel tem 3 bytes)
    int 80h

    ; Agora, você deve censurar este pixel (definindo os valores dos componentes de cor para 0)
    mov byte [ecx], 0  ; Censura o componente azul
    mov byte [ecx + 1], 0  ; Censura o componente verde
    mov byte [ecx + 2], 0  ; Censura o componente vermelho

    ; Escrever o pixel censurado na imagem de saída
    mov eax, 4 ; Escrever um pixel na imagem de saída
    mov ebx, [fileHandleOut]
    mov ecx, fileBuffer
    mov edx, 3  ; Tamanho de um pixel em bytes
    int 80h

    pular_censura:
    ; Atualize as coordenadas e dimensões conforme necessário
    add edi, 1  ; Avança para o próximo pixel na linha
    cmp edi, [integer_x]         ; Verifique se estamos dentro do retângulo na coordenada X
    jl linha_loop ; Se ainda não saímos do retângulo, continue
    add esi, 1  ; Avança para a próxima linha
    sub ebp, 1  ; Decrementa a altura da censura
    cmp ebp, 0
    je fechar_arquivos ; Se a altura da censura atingiu zero, saia do loop
    jmp censurar_retangulo

    fechar_arquivos:
    mov eax, 6 ; Fechar o arquivo de entrada
    mov ebx, dword [fileHandleIn]
    int 80h

    mov eax, 6 ; Fechar o arquivo de saída
    mov ebx, dword [fileHandleOut]
    int 80h

    fim: 
    mov eax, 1
    xor ebx, ebx
    int 80h
