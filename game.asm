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

criaInimigo PROC USES ecx eax edx
    movzx ecx, numInimigos
    call GetMseconds
    mov edx, eax
    sub eax, last_spawn
    .if ecx < NUM_MAX_INIMIGOS 
        .if eax > DELAY_BETWEEN_SPAWNS
            mov last_spawn, edx
            ;todo setar linhas fixas
            call Randomize
            mov  eax, 19
            call RandomRange ;
            inc  eax         

            mov (COORD PTR inimigo_curr_pos[ecx * TYPE COORD]).X, 60 
            ; coloca em uma posicao aleatória da tela
            mov (COORD PTR inimigo_curr_pos[ecx * TYPE COORD]).Y, ax 

            inc numInimigos
        .endif
    .endif
    ret
criaInimigo ENDP

;COLISAO
verificaColisao PROC
;COLISAO INIMIGO {

    ;colisao parede
    movzx ecx, numInimigos
    .if ecx > 0
        
        mov esi, 0
        L1:
        cmp inimigo_curr_pos[esi * TYPE COORD].X, 0
            jne inimigoSemColisao
        
        ;inimigo colidiu com a parede    
        movzx edx, numInimigos
        dec edx
        mov ax, inimigo_curr_pos[edx  * TYPE COORD].X
        mov inimigo_curr_pos[esi  * TYPE COORD].X , ax
        mov ax, inimigo_curr_pos[edx  * TYPE COORD].Y
        mov inimigo_curr_pos[esi  * TYPE COORD].Y , ax
        dec numInimigos

        inimigoSemColisao:
        inc esi
        loop L1

;}

    .endif
    ret
verificaColisao ENDP

;;
; Invoca a sequência de funções do loop principal
; enquanto game_curr_state não for definido como
; GAME_STATE_QUIT por alguma delas
; @param game_curr_state - variável global
;;
game_loop PROC

MAIN_LOOP:
    
    call atualizaTela
    ;TODO colocar pausa para criar inimigo, n da para criar qd bate na parede pq vai ter sempre 1
    call criaInimigo
    call verificaColisao
    call leTecla
    call game_print


    .if game_curr_state != GAME_STATE_QUIT
        jmp MAIN_LOOP
    .endif

    ret
game_loop ENDP