INCLUDE Irvine32.inc
INCLUDE win32.inc

INCLUDE defines.asm
INCLUDE buffer.asm

.code

;;
; Configura o terminal, incluindo título e tamanho da janela
;;
game_setup PROC
    INVOKE GetStdHandle, STD_OUTPUT_HANDLE
    mov console, eax    ; save console handle

    INVOKE SetConsoleTitle, OFFSET game_title
    INVOKE SetConsoleScreenBufferSize, console, bufferSize

    call ClearBuffer
    ret
game_setup ENDP

;;
; Função que define quantos inimigos no nível
; inimigos = level * 2 + 5, level in [0, MAX_LEVELS]
;;
game_level_calculate_remaining_enemies PROC uses eax
    movzx eax, game_level_curr
    mov game_level_remaining_enemies, eax
    shl game_level_remaining_enemies, 1
    add game_level_remaining_enemies, 5
    ret
game_level_calculate_remaining_enemies ENDP

;;
; Macro para gerar um número em eax no range [1, range]
;;
mRandomPositive MACRO range
    mov  eax, range
    call RandomRange
    inc  eax
ENDM

;;
; Popula as informações de game_level_question
;   - Testa por resultados negativos (A < B, op -)
;   - Testa por ambiquidades de resposta (2 + 2 = 2 * 2)
; FIXME como não temos uma boa função para imprimir um número com várias casas decimais
; estamos gerando apenas perguntas que usam apenas dígitos, e cuja operação não gere
; números > 10. Isto é, apenas os pares (1, 1), (2,1), (3, 1), (3, 2), (3, 3)
;;
game_level_calculate_star_question PROC USES eax ebx edx
    call Randomize
    mRandomPositive 3
    mov game_level_question.A, al
    mRandomPositive 3
    mov game_level_question.B, al

    ; nunca dá sub negativo
    .if game_level_question.A < al
        mov ah, game_level_question.A
        mov game_level_question.A, al
        mov game_level_question.B, ah
    .endif
    ; nunca dá 2*2 = 2+2
    .if game_level_question.A == 2
        .if game_level_question.B == 2
            inc game_level_question.A
        .endif
    .endif

    mRandomPositive 3
    dec eax

    mov bl, game_level_question.A
    .if OPS[eax] == '+'
        add bl, game_level_question.B
        mov game_level_question.R, bl
        mov game_level_question.OP, '+'
    .elseif OPS[eax] == '-'
        sub bl, game_level_question.B
        mov game_level_question.R, bl
        mov game_level_question.OP, '-'
    .elseif OPS[eax] == '*'
        movzx dx, game_level_question.B
        imul bx, dx
        mov game_level_question.R, bl
        mov game_level_question.OP, '*'
    .endif

    add game_level_question.A, '0'
    add game_level_question.B, '0'
    add game_level_question.R, '0'

    ret
game_level_calculate_star_question ENDP

;;
; lê tecla e realiza a ação necessária de acordo com
; o estado atual do jogo
;;
leTecla PROC
  ;lê a tecla
    call readkey
    jz nokey
    push eax
    push ecx
    call ReadKeyflush
    pop ecx
    pop eax
    .if al == KEY_ENTER_CODE
        .if game_curr_state == GAME_STATE_INTRO
            mov game_curr_state, GAME_STATE_INSTRU
            jmp nokey
        .elseif game_curr_state == GAME_STATE_INSTRU
            call game_reset
            mov game_curr_state, GAME_STATE_PLAYING
            jmp nokey
        .endif
    .elseif al == KEY_ESC_CODE
        .if game_curr_state == GAME_STATE_INTRO
            jmp QUIT_CODE
        .else
            jmp GOTO_INTRO
        .endif
    .elseif ah == KEY_UP_CODE
        .if game_curr_state == GAME_STATE_PLAYING
            jmp MOVE_UP
        .elseif game_curr_state == GAME_STATE_STAR
            jmp MOVE_UP
        .endif
    .elseif ah == KEY_DOWN_CODE
        .if game_curr_state == GAME_STATE_PLAYING
            jmp MOVE_DOWN
        .elseif game_curr_state == GAME_STATE_STAR
            jmp MOVE_DOWN
        .endif
    .elseif ah == KEY_SPACE_CODE
        .if game_curr_state == GAME_STATE_PLAYING
            jmp espaco
        .endif
    .else
        jmp nokey
    .endif

 MOVE_UP: 
    ;nave vai uma posição para a esquerda se não estiver do lado da parede
    or num_max_tiros, 0001
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
    jmp nokey
 GOTO_INTRO:
    mov game_curr_state, GAME_STATE_INTRO
  nokey:      
    ret
leTecla ENDP

;;
; Cria inimigo se as seguintes condições forem satisfeitas:
;   - Delay de DELAY_BETWEEN_SPAWNS
;   - Não mais que NUM_MAX_INIMIGOS ativos
;   - Ainda existe inimigos restantes no level
; Gera um inimigo em uma posição aleatória de Y
;;
criaInimigo PROC USES ecx eax edx
    movzx ecx, numInimigos
    call GetMseconds
    mov edx, eax
    sub eax, last_spawn
    .if ecx < NUM_MAX_INIMIGOS 
        .if game_level_remaining_enemies >= NUM_MAX_INIMIGOS
            .if eax > DELAY_BETWEEN_SPAWNS
                mov last_spawn, edx
                call Randomize
                mRandomPositive 19

                mov (COORD PTR inimigo_curr_pos[ecx * TYPE COORD]).X, 60 
                ; coloca em uma posicao aleatória da tela
                mov (COORD PTR inimigo_curr_pos[ecx * TYPE COORD]).Y, ax 

                inc numInimigos
            .endif
        .endif
    .endif
    ret
criaInimigo ENDP

;;
; Cria um tiro se houverem tiros disponíveis
;;
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
;;
; Remove o inimigo enemy[idx], e gera a animação de explosão por 1 frame
;;
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
;;
; Testa se algum elemento de array colidiu com a parede esquerda
; ebx = 0 se não teve colisão
; ebx = 1 retorna em eax o índice da colisão
;;
verificaColisaoParede PROC USES ecx esi, array:DWORD, len:DWORD
    mov ecx, len
    mov ebx, 0
    mov eax, array
    .if ecx > 0
        mov esi, 0
    L1:
        cmp (COORD PTR [eax + esi * TYPE COORD]).X, 0
        jne SemColisao
        mov eax, esi
        mov ebx, 1
        jmp QUIT
    SemColisao:
        inc esi
        loop L1
    .endif
    QUIT:
    ret
verificaColisaoParede ENDP

;;
; Testa se algum elemento de tiro_curr_pos colidiu com a parede direita
; Remove ele caso necessário
; FIXME funciona apenas para 1 bala ativa
;;
verificaColisaoParedeTiro PROC
    movzx ecx, numTiros
    .if ecx > 0
        mov esi, 0
        L1:
        cmp tiro_curr_pos[esi * TYPE COORD].X, 79
            jb tiroSemColisao
        
        dec numTiros

        tiroSemColisao:
        inc esi
        loop L1

    .endif
    ret
verificaColisaoParedeTiro ENDP

;;
; Ações necessárias para se começar um nível novo
;;
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

;;
; Ações necessárias para se começar um jogo novo
;;
game_reset PROC
    mov game_level_curr, 0
    call level_reset
    ret
game_reset ENDP

;COLISAO
;;
; Testa se algum elemento de array colidiu com a nave
; ebx = 0 se não teve colisão
; ebx = 1 retorna em eax o índice da colisão
;;
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

;;
;;
; Testa se algum elemento de tiro_curr_pos colidiu com algum inimigo
; ebx = 0 se não teve colisão
; ebx = 1 retorna em eax o índice da colisão
; FIXME funciona apenas para 1 bala ativa
;;
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

;;
; Avança para o próximo nível ou para o fim do jogo
; @param game_level_curr - variável global
;;
level_next PROC
    inc game_level_curr
    .if game_level_curr == MAX_LEVELS
        mov game_curr_state, GAME_STATE_ARCOMP
    .else
        call level_reset
        mov game_curr_state, GAME_STATE_PLAYING
    .endif
    ret
level_next ENDP

;;
; Testa se o jogador selecionou a resposta certa,
; avançando para o próximo nível ou perdendo
; @param game_curr_state - variável global
; @param idx - índice do objeto colidido
;;
checkStarAnswer PROC USES eax idx:DWORD
    mov eax, OFFSET OPS
    add eax, idx
    mov al, BYTE PTR [eax]
    .if game_level_question.OP == al
        call level_next
    .else
        mov game_curr_state, GAME_STATE_LOSE_STAR
    .endif
    ret
checkStarAnswer ENDP


mRemoveInimigo MACRO
    .if ebx == 1
        INVOKE removeInimigo, eax
    .endif
ENDM

;;
; Pode ocorrer colisões entre:
;   - Parede (direita) e tiro
;   - Parede (esquerda) e inimigo
;   - Inimigo e nave
;   - Tiro e inimigo
;   - Nave e estrela
; Essa última colisão só pode ocorrer se estamos no modo GAME_STATE_STAR,
; os demais ocorrem apenas se estamos no modo GAME_STATE_PLAYING.
; Sempre que ocorre uma colisão, alguém é removido (inimigo ou tiro).
;
; TODO atualmente, a nave precisa estar alinhada com a estrela para que não colida com uma estrela errada
; A colisão com uma estrela gera um teste de resposta correta (checkStarAnswer)
; @param game_curr_state - variável global
;;
verificaColisoes PROC USES ebx eax
    .if game_curr_state == GAME_STATE_PLAYING
        call verificaColisaoParedeTiro
        call verificaColisaoTiroInimigo
        mRemoveInimigo

        INVOKE verificaColisaoParede, OFFSET inimigo_curr_pos, numInimigos
        mRemoveInimigo
        INVOKE verificaColisaoJogador, OFFSET inimigo_curr_pos, numInimigos
        mRemoveInimigo
        .if ebx == 1
            mov game_curr_state, GAME_STATE_LOSE_COLLISION
        .endif
    .elseif game_curr_state == GAME_STATE_STAR
        INVOKE verificaColisaoJogador, OFFSET star_curr_pos, NUM_STARS
        .if ebx == 1
            INVOKE checkStarAnswer, eax
        .endif
        ;INVOKE verificaColisaoParede, OFFSET star_curr_pos, NUM_STARS
        ;.if ebx == 1
        ;    mov game_curr_state, GAME_STATE_QUIT
        ;.endif
    .endif
    ret
verificaColisoes ENDP

;;
; Leitura de tecla, criação de inimigo, teste de colisões
; teste de fim da fase, todos acompanhados de possíveis
; atualizações em game_curr_state
; @param game_curr_state - variável global
;;
atualizarEstados PROC
    call leTecla

    call criaInimigo
    call verificaColisoes

    .if game_level_remaining_enemies == 0
        .if game_curr_state == GAME_STATE_PLAYING
            call game_level_calculate_star_question
            mov game_curr_state, GAME_STATE_STAR
        .endif
    .endif
    ret
atualizarEstados ENDP

;;
; Invoca a sequência de funções do loop principal
; enquanto game_curr_state não for definido como
; GAME_STATE_QUIT por atualizarEstados
; Loop principal:
;   - Limpar buffer
;   - Atualziar Estado
;   - Atualizar Tela
;   - Desenhar Tela
; @param game_curr_state - variável global
;;
game_loop PROC
MAIN_LOOP:
    call ClearBuffer

    call atualizarEstados
    call atualizaTela
    call buffer_print

    .if game_curr_state != GAME_STATE_QUIT
        jmp MAIN_LOOP
    .endif

    call ClrScr

    ret
game_loop ENDP 