INCLUDE Irvine32.inc
INCLUDE win32.inc

INCLUDE defines.asm
INCLUDE buffer.asm

.code
game_setup PROC
    INVOKE GetStdHandle, STD_OUTPUT_HANDLE
    mov console, eax    ; save console handle

    INVOKE SetConsoleTitle, OFFSET game_title
    INVOKE SetConsoleScreenBufferSize, console, bufferSize

    call ClearBuffer
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


game_level_calculate_remaining_enemies PROC
    mov game_level_remaining_enemies, 5
    ret
game_level_calculate_remaining_enemies ENDP

leTecla PROC
  ;lê a tecla
    call readkey
    jz nokey
    push eax
    push ecx
    call ReadKeyflush
    pop ecx
    pop eax
    cmp ah, KEY_UP_CODE
        je MOVE_UP
    cmp ah, KEY_DOWN_CODE
        je MOVE_DOWN
    cmp ah, KEY_SPACE_CODE
        .if game_curr_state == GAME_STATE_PLAYING
            je espaco
        .endif
    cmp al, KEY_ESC_CODE
        je QUIT_CODE
    jmp nokey

 MOVE_UP: 
    ;nave vai uma posição para a esquerda se não estiver do lado da parede
    or num_max_tiros,0001
    cmp  nave_curr_pos.Y, 0
        je nokey
    mov ax, nave_curr_pos.Y
    dec ax
    mov nave_curr_pos.Y, ax
     
    jmp nokey

  MOVE_DOWN:
    ;nave vai uma posição para a direita se não estiver do lado da parede
    or num_max_tiros,0001
    cmp nave_curr_pos.Y, 20
        je nokey
    mov ax, nave_curr_pos.Y
    inc ax
    mov nave_curr_pos.Y, ax
    
    jmp nokey

  espaco:   
    call criaTiro
    jmp nokey
 QUIT_CODE:
    mov game_curr_state, GAME_STATE_QUIT
    mov edx, OFFSET game_title
    INVOKE WriteString
    
  nokey:      
    ret
leTecla ENDP

criaInimigo PROC USES ecx eax edx
    movzx ecx, numInimigos
    call GetMseconds
    mov edx, eax
    sub eax, last_spawn
    .if ecx < NUM_MAX_INIMIGOS 
        .if game_level_remaining_enemies >= NUM_MAX_INIMIGOS
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
    .endif
    ret
criaInimigo ENDP

criaTiro PROC USES ecx eax edx
    movzx ecx, numTiros   
    movzx eax, num_max_tiros 
    .if ecx < eax
            mov ax, nave_curr_pos.X
            add ax, 9
            mov (COORD PTR tiro_curr_pos[ecx * TYPE COORD]).X, ax
            mov ax, nave_curr_pos.Y
            add ax, 2
            mov (COORD PTR tiro_curr_pos[ecx * TYPE COORD]).Y, ax
            inc numTiros
            dec num_max_tiros
    .endif
    ret
criaTiro ENDP

;COLISAO
removeInimigo PROC USES edx esi eax ebx, idx:DWORD
    movzx edx, numInimigos
    mov esi, idx

    mov bx,  inimigo_curr_pos[esi  * TYPE COORD].X
    mov explosao_curr_pos.X, bx
    mov bx,  inimigo_curr_pos[esi  * TYPE COORD].Y
    mov explosao_curr_pos.Y, bx
    INVOKE insertRegionIntoBuffer, OFFSET explosao, explosao_dimension, explosao_curr_pos

    dec edx
    mov ax, inimigo_curr_pos[edx  * TYPE COORD].X
    mov inimigo_curr_pos[esi  * TYPE COORD].X , ax
    mov ax, inimigo_curr_pos[edx  * TYPE COORD].Y
    mov inimigo_curr_pos[esi  * TYPE COORD].Y , ax
    dec numInimigos
    dec game_level_remaining_enemies

    ret
removeInimigo ENDP

;COLISAO
; ebx = 0 se não teve colisão
; ebx = 1 retorna em eax o índice da colisão
verificaColisaoParede PROC USES ecx esi, array:DWORD, len:DWORD
    mov ecx, len
    mov ebx, 0
    mov eax, array
    .if ecx > 0
        mov esi, 0
    L1:
        cmp (COORD PTR [eax + esi * TYPE COORD]).X, 0
        jne inimigoSemColisao
        mov eax, esi
        mov ebx, 1
        jmp QUIT
    inimigoSemColisao:
        inc esi
        loop L1
    .endif
    QUIT:
    ret
verificaColisaoParede ENDP

verificaColisaoParedeTiro PROC
         movzx ecx, numTiros
        .if ecx > 0
            mov esi, 0
            L1:
            cmp tiro_curr_pos[esi * TYPE COORD].X, 79
                jb tiroSemColisao
            
            ;tiro colidiu com a parede    
            ;movzx edx, numTiros
            ;dec edx
            ;mov ax, tiro_curr_pos[edx  * TYPE COORD].X
            ;mov tiro_curr_pos[esi  * TYPE COORD].X , ax
            ;mov ax, tiro_curr_pos[edx  * TYPE COORD].Y
            ;mov tiro_curr_pos[esi  * TYPE COORD].Y , ax
            dec numTiros

            tiroSemColisao:
            inc esi
            loop L1

         .endif
         ret
verificaColisaoParedeTiro ENDP

level_reset PROC USES ecx esi eax
    call game_level_calculate_remaining_enemies
    mov ecx, NUM_STARS
    mov esi, 0
    L1:
        mov ax, star_initial_pos[esi * TYPE COORD].X
        mov star_curr_pos[esi * TYPE COORD].X, ax
        mov ax, star_initial_pos[esi * TYPE COORD].Y
        mov star_curr_pos[esi * TYPE COORD].Y, ax
        inc esi
        loop L1
    mov game_curr_state, GAME_STATE_PLAYING
    ret
level_reset ENDP

;COLISAO
; ebx = 0 se não teve colisão
; ebx = 1 retorna em eax o índice da colisão
verificaColisaoJogador PROC USES ecx esi edx, array:DWORD, len:DWORD
    mov ecx, len
    mov ebx, 0
    mov edx, array
    .if ecx > 0
;COLISAO INIMIGO_JOGADOR {  
        mov esi, 0
        L2:
		mov ax, nave_curr_pos.X
		mov bx, nave_curr_pos.Y
		;cmp ax, (COORD PTR [edx + esi * TYPE COORD]).X 
        ;    jb inimigoSemColisao2
		add ax, nave_dimension.X
		cmp ax, (COORD PTR [edx + esi * TYPE COORD]).X
            jb inimigoSemColisao2
			
		mov ax, (COORD PTR [edx + esi * TYPE COORD]).Y
		add ax, inimigo_dimension.Y
		dec ax
		cmp bx, ax
            ja inimigoSemColisao2
			
		add bx, nave_dimension.Y		
        cmp bx, (COORD PTR [edx + esi * TYPE COORD]).Y
            jb inimigoSemColisao2
		
        mov eax, esi
        mov ebx, 1
        jmp QUIT

        inimigoSemColisao2:
        inc esi
        mov ebx, 0
        loop L2

;}
		.endif
    QUIT:
    
    ret
verificaColisaoJogador ENDP

verificaColisaoTiroInimigo PROC
        movzx ecx, numInimigos
        movzx eax, numTiros
        mov ebx, 0
        .if ecx > 0
        .if eax > 0
            mov esi, 0
            L3:
            mov ax, tiro_curr_pos.X
            mov bx, tiro_curr_pos.Y
            
            mov dx, inimigo_curr_pos[esi  * TYPE COORD].X
            add dx, inimigo_dimension.X
            cmp ax, dx 
                ja inimigoSemColisao3

            cmp ax, inimigo_curr_pos[esi  * TYPE COORD].X
                jb inimigoSemColisao3
                
            mov dx, inimigo_curr_pos[esi  * TYPE COORD].Y
            add dx, inimigo_dimension.Y
            cmp bx, dx
                ja inimigoSemColisao3
                
            cmp bx, inimigo_curr_pos[esi  * TYPE COORD].Y
                jb inimigoSemColisao3

            ;inimigo colidiu com a parede    
            mov eax, esi
            mov ebx, 1
            dec numTiros
            jmp QUIT

            inimigoSemColisao3:
                inc esi
                mov ebx, 0
                loop L3

        .endif
        .endif
    QUIT:

    ret
verificaColisaoTiroInimigo ENDP

checkStarAnswer PROC idx:DWORD
    .if idx == 0
        mov game_curr_state, GAME_STATE_QUIT
    .else
        call level_reset
    .endif
    ret
checkStarAnswer ENDP

verificaColisoes PROC USES ebx eax
    .if game_curr_state == GAME_STATE_PLAYING
        INVOKE verificaColisaoParede, OFFSET inimigo_curr_pos, numInimigos
        .if ebx == 1
            INVOKE removeInimigo, eax
        .endif
        INVOKE verificaColisaoJogador, OFFSET inimigo_curr_pos, numInimigos
        .if ebx == 1
            INVOKE removeInimigo, eax
        .endif
    .elseif game_curr_state == GAME_STATE_STAR
        INVOKE verificaColisaoJogador, OFFSET star_curr_pos, NUM_STARS
        .if ebx == 1
            INVOKE checkStarAnswer, eax
        .endif
        INVOKE verificaColisaoParede, OFFSET star_curr_pos, NUM_STARS
        .if ebx == 1
            mov game_curr_state, GAME_STATE_QUIT
        .endif
    .endif
    ret
verificaColisoes ENDP

atualizarEstados PROC
    call leTecla

    ;TODO colocar pausa para criar inimigo, n da para criar qd bate na parede pq vai ter sempre 1
    call criaInimigo
    call verificaColisoes

    .if game_level_remaining_enemies == 0
        .if game_curr_state == GAME_STATE_PLAYING
            mov game_curr_state, GAME_STATE_STAR
        .endif
    .endif
    ret
atualizarEstados ENDP

;;
; Invoca a sequência de funções do loop principal
; enquanto game_curr_state não for definido como
; GAME_STATE_QUIT por alguma delas
; @param game_curr_state - variável global
;;
game_loop PROC
    call game_level_calculate_remaining_enemies

MAIN_LOOP:
    call atualizarEstados
    call verificaColisaoParedeTiro
    call verificaColisaoTiroInimigo
    .if ebx == 1
        INVOKE removeInimigo, eax
    .endif
    call atualizaTela
    call game_print

    .if game_curr_state != GAME_STATE_QUIT
        jmp MAIN_LOOP
    .endif

    call ClrScr

    ret
game_loop ENDP