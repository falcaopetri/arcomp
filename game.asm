INCLUDE Irvine32.inc
INCLUDE win32.inc

INCLUDE defines.asm
INCLUDE buffer.asm

.code
game_setup PROC
    INVOKE GetStdHandle, STD_OUTPUT_HANDLE
    mov console, eax    ; save console handle
    ret
game_setup ENDP

;;
; Invoca o fill'er correto do buffer baseado no game_curr_state,
; e imprime o buffer na tela
; @param game_curr_state - variável global
;;
game_print PROC USES eax
    ;.if game_curr_state == GAME_STATE_MENU_MAIN
    ;    call buffer_fill_menu_main
    ;.if game_curr_state == GAME_STATE_PLAYING
    ;    call buffer_fill_playing
    ;.endif

    call buffer_print
    ret
game_print ENDP

leTecla PROC
  ;lê a tecla
    call readkey
    jz nokey
    push eax
    push ecx
    call ReadKeyflush
    pop ecx
    pop eax
    ;TODO mudar para up e down
        cmp ah, 75             
            je SetaEsquerda
        cmp ah, 77
            je SetaDireita
        jmp nokey

;TODO mudar para up e down
 SetaEsquerda: 
    ;nave vai uma posição para a esquerda se não estiver do lado da parede
    cmp naveY, 0
        je nokey
    mov ax, nave_curr_pos.Y
    dec ax
    mov nave_curr_pos.Y, ax
    jmp nokey

  SetaDireita:
    ;nave vai uma posição para a direita se não estiver do lado da parede
    cmp naveY, 50
        je nokey
    mov ax, nave_curr_pos.Y
    inc ax
    mov nave_curr_pos.Y, ax
    
    jmp nokey
   
  nokey:      
    ret
leTecla ENDP

;;
; Invoca a sequência de funções do loop principal
; enquanto game_curr_state não for definido como
; GAME_STATE_QUIT por alguma delas
; @param game_curr_state - variável global
;;
game_loop PROC
MAIN_LOOP:
    
    call atualizaTela
    call leTecla
    call game_print

    .if game_curr_state != GAME_STATE_QUIT
        jmp MAIN_LOOP
    .endif

    ret
game_loop ENDP