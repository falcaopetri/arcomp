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
        cmp ah, KEY_UP_CODE
            je MOVE_UP
        cmp ah, KEY_DOWN_CODE
            je MOVE_DOWN
        cmp ah, KEY_SPACE_CODE
            je espaco
        jmp nokey

;TODO mudar para up e down
 MOVE_UP: 
    ;nave vai uma posição para a esquerda se não estiver do lado da parede
    cmp  nave_curr_pos.Y, 0
        je nokey
    mov ax, nave_curr_pos.Y
    dec ax
    mov nave_curr_pos.Y, ax
     
    jmp nokey

  MOVE_DOWN:
    ;nave vai uma posição para a direita se não estiver do lado da parede
    cmp nave_curr_pos.Y, 20
        je nokey
    mov ax, nave_curr_pos.Y
    inc ax
    mov nave_curr_pos.Y, ax
    
    jmp nokey


  espaco:
    call criaTiro
    
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

criaTiro PROC USES ecx eax edx
    movzx ecx, numTiros   
    .if ecx < NUM_MAX_TIROS 
            mov ax, nave_curr_pos.X
            add ax, 9
            mov (COORD PTR tiro_curr_pos[ecx * TYPE COORD]).X, ax
            mov ax, nave_curr_pos.Y
            add ax, 2
            mov (COORD PTR tiro_curr_pos[ecx * TYPE COORD]).Y, ax
            inc numTiros
    .endif
    ret
criaTiro ENDP

;COLISAO
verificaColisaoParede PROC

		 movzx ecx, numInimigos
		.if ecx > 0
;COLISAO INIMIGO_PAREDE {
     
        mov esi, 0
        L1:
        cmp inimigo_curr_pos[esi * TYPE COORD].X, 0
            jne inimigoSemColisao


         call removeInimigo

        inimigoSemColisao:
        inc esi
        loop L1

;}

    .endif
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

verificaColisaoJogador PROC
		movzx ecx, numInimigos
		.if ecx > 0
;COLISAO INIMIGO_JOGADOR {  
        mov esi, 0
        L2:
		mov ax, nave_curr_pos.X
		mov bx, nave_curr_pos.Y
		
		;cmp ax, inimigo_curr_pos[esi  * TYPE COORD].X 
        ;    jb inimigoSemColisao2
		add ax, nave_dimension.X
		cmp ax, inimigo_curr_pos[esi  * TYPE COORD].X
            jb inimigoSemColisao2
			
		mov dx, inimigo_curr_pos[esi  * TYPE COORD].Y
		add dx, inimigo_dimension.Y
		dec dx
		cmp bx,dx
            ja inimigoSemColisao2
			
		add bx, nave_dimension.Y		
        cmp bx, inimigo_curr_pos[esi  * TYPE COORD].Y
            jb inimigoSemColisao2
		
		
        
        call removeInimigo

        inimigoSemColisao2:
        inc esi
        loop L2

;}
		.endif
			ret
verificaColisaoJogador ENDP

verificaColisaoTiroInimigo PROC
        movzx ecx, numInimigos
        movzx eax, numTiros
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
            cmp bx,dx
                ja inimigoSemColisao3
                
            cmp bx, inimigo_curr_pos[esi  * TYPE COORD].Y
                jb inimigoSemColisao3

               
                
            ;inimigo colidiu com a parede    
            movzx edx, numInimigos
            dec edx
            mov ax, inimigo_curr_pos[edx  * TYPE COORD].X
            mov inimigo_curr_pos[esi  * TYPE COORD].X , ax
            mov ax, inimigo_curr_pos[edx  * TYPE COORD].Y
            mov inimigo_curr_pos[esi  * TYPE COORD].Y , ax
            dec numInimigos
            dec numTiros

            inimigoSemColisao3:
                inc esi
                loop L3

        .endif
        .endif
            ret
verificaColisaoTiroInimigo ENDP

removeInimigo PROC
        ;inimigo colidiu com a parede    
        movzx edx, numInimigos
        dec edx
        mov ax, inimigo_curr_pos[edx  * TYPE COORD].X
        mov inimigo_curr_pos[esi  * TYPE COORD].X , ax
        mov ax, inimigo_curr_pos[edx  * TYPE COORD].Y
        mov inimigo_curr_pos[esi  * TYPE COORD].Y , ax
        dec numInimigos

        ret
removeInimigo ENDP
;;
; Invoca a sequência de funções do loop principal
; enquanto game_curr_state não for definido como
; GAME_STATE_QUIT por alguma delas
; @param game_curr_state - variável global
;;
game_loop PROC

MAIN_LOOP:
    
    call atualizaTela
    call criaInimigo
    call verificaColisaoParede
	call verificaColisaoJogador
    call verificaColisaoParedeTiro
    call verificaColisaoTiroInimigo
    call leTecla
    call game_print


    .if game_curr_state != GAME_STATE_QUIT
        jmp MAIN_LOOP
    .endif

    ret
game_loop ENDP