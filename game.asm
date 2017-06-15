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
    .if game_curr_state == GAME_STATE_MENU_MAIN
        call buffer_fill_menu_main
    .endif

    call buffer_print
    ret
game_print ENDP


;;
; Invoca a sequência de funções do loop principal
; enquanto game_curr_state não for definido como
; GAME_STATE_QUIT por alguma delas
; @param game_curr_state - variável global
;;
game_loop PROC
MAIN_LOOP:
    call game_print

    .if game_curr_state != GAME_STATE_QUIT
        jmp MAIN_LOOP
    .endif

    ret
game_loop ENDP