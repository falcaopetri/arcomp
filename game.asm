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
    cmp  nave_curr_pos.Y, 0
        je nokey
    mov ax, nave_curr_pos.Y
    dec ax
    mov nave_curr_pos.Y, ax
     call criaInimigo
    jmp nokey

  SetaDireita:
    ;nave vai uma posição para a direita se não estiver do lado da parede
    cmp nave_curr_pos.Y, 20
        je nokey
    mov ax, nave_curr_pos.Y
    inc ax
    mov nave_curr_pos.Y, ax
    
    jmp nokey
   
  nokey:      
    ret
leTecla ENDP

criaInimigo PROC

    movzx ecx, numInimigos
    movzx edx, numMaxInimigos
    cmp ecx, edx
    je fim
    ;TODO setar 3 Ys fixos
    call Randomize
    mov  eax, 19     ;get random 0 to 50
    call RandomRange ;
    inc  eax         ;make range 1 to 20

    ;mov inimigo_curr_pos[ecx].X, 60
    mov (COORD PTR inimigo_curr_pos[ecx]).X,60 
    ;coloca em uma posicao aleatória da tela
    ;mov inimigo_curr_pos[ecx].Y, ax
    mov (COORD PTR inimigo_curr_pos[ecx]).Y,ax 

    inc numInimigos

    fim:

    ret

criaInimigo ENDP

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