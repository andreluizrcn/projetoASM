

segment .data

LF          equ 0xA ;Line Feed
NULL        equ 0xD ;Final de String

SYS_EXIT    equ 1 ;codigo da chamada para finalizar
RET_EXIT    equ 0 ;operacao com sucesso

STD_IN      equ 0 ;entrada padrao
STD_OUT     equ 1 ; saida padrao
SYS_READ    equ 3 ;operacao de leitura
SYS_WRITE   equ 4 ; operacao de escrita
 
READ_FILE   equ 3 ;ler o arquivo
WRITE_FILE  equ 3 ;ler o arquivo
OPEN_FILE   equ 5 ; abrir o arquivo
CLOSE_FILE  equ 6 ;fechar o arquivo ou sys_close
CREATE_FILE equ 8 ;criar arquivo
 
OPEN_READ   equ 0 ;arquivo para leitura
OPEN_WRITE  equ 1 ;arquivo para escrita
OPEN_RW     equ 2 ;arquivo para leitura/escrita
OPEN_CREATE equ 40 ;se o arquivo nao existe, cria
OPEN_APPEND equ 400 ;arquivo para adicao de informacao 

SYS_CALL    equ 80 ;envia informacao para o SO