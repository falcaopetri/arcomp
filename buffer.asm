.code

;;
; Limpa buffer da tela
;;
ClearBuffer PROC USES eax 
    xor eax, eax

BLANKS:  
    mov buffer[eax * CHAR_INFO].Char, ' '
    mov buffer[eax * CHAR_INFO].Attributes, 7h
    inc eax
    cmp eax, ROWS * COLS
    jl BLANKS

    ret       
ClearBuffer ENDP

;;
; Imprime buffer na tela e espera DELAY_BETWEEN_FRAMES
;;
buffer_print PROC
    invoke WriteConsoleOutput, console, 
           ADDR buffer, bufferSize, bufferCoord, ADDR region
    INVOKE Sleep, DELAY_BETWEEN_FRAMES

    ret
buffer_print ENDP

;;
; Insere string na posição start do buffer
;;
insertStringIntoBuffer PROC USES ecx esi eax ebx edi string:PTR BYTE, len:WORD, start:COORD
    cld
    movzx ecx, len

    movzx eax, start.Y
    imul eax, 80
    movzx ebx, start.X
    add eax, ebx
    imul eax, TYPE CHAR_INFO
    lea edi, buffer[eax]
    mov ebx, string
L1:
    movzx ax, BYTE PTR [ebx]
    mov (CHAR_INFO PTR [edi]).Char, ax
    add ebx, TYPE BYTE
    add edi, TYPE CHAR_INFO
    loop L1
    ret
insertStringIntoBuffer ENDP

;;
; Insere string com cor color na posição start do buffer
; FIXME copy'n'paste de insertStringIntoBuffer
;;
insertStringIntoBufferWithColor PROC USES ecx esi eax ebx edx edi string:PTR BYTE, color: PTR WORD, len:WORD, start:COORD
    cld
    movzx ecx, len
    
    movzx eax, start.Y
    imul eax, 80
    movzx ebx, start.X
    add eax, ebx
    imul eax, TYPE CHAR_INFO
    lea edi, buffer[eax]
    mov ebx, string
    mov edx, color
L1:
    movzx ax, BYTE PTR [ebx]
    mov (CHAR_INFO PTR [edi]).Char, ax

    mov ax, WORD PTR [edx]
    mov (CHAR_INFO PTR [edi]).Attributes, ax

    add ebx, TYPE BYTE
    add edx, TYPE WORD
    add edi, TYPE CHAR_INFO
    loop L1

    ret
insertStringIntoBufferWithColor ENDP

;;
; Insere região definida por string e delimitada por dimension na posição start do buffer
;;
insertRegionIntoBuffer PROC USES eax ebx ecx string:PTR BYTE, dimension:COORD, start:COORD
    LOCAL curr:COORD
    ; curr <- start
    mov ax, start.X
    mov curr.X, ax
    mov ax, start.Y
    mov curr.Y, ax
    
    movzx eax, dimension.X
    mov ebx, string
    ; for i in range(0, dimension.Y):
    movzx ecx, dimension.Y
    ; insere cada linha do desenho na posição adequada no buffer
EACH_LINE:
    INVOKE insertStringIntoBuffer, ebx, dimension.X, curr
    inc curr.Y
    add ebx, eax
    loop EACH_LINE

    ret
insertRegionIntoBuffer ENDP

;;
; Insere região definida por string, com cor color e delimitada por dimension na posição start do buffer
; FIXME copy'n'paste de insertRegionIntoBuffer
;;
insertRegionIntoBufferWithColor PROC USES eax ebx edx ecx string:PTR BYTE, color:PTR WORD, dimension:COORD, start:COORD
    LOCAL curr:COORD
    ; curr <- start
    mov ax, start.X
    mov curr.X, ax
    mov ax, start.Y
    mov curr.Y, ax
    
    mov ebx, string
    mov edx, color
    movzx eax, dimension.X
    ; for i in range(0, dimension.Y):
    movzx ecx, dimension.Y
    ; insere cada linha do desenho na posição adequada no buffer
EACH_LINE:
    INVOKE insertStringIntoBufferWithColor, ebx, edx, dimension.X, curr
    inc curr.Y
    add ebx, eax
    add edx, eax
    add edx, eax
    loop EACH_LINE

    ret
insertRegionIntoBufferWithColor ENDP

;;
; Desenha nave
;;
desenhaNave PROC
    INVOKE insertRegionIntoBuffer, OFFSET nave, nave_dimension, nave_curr_pos
    ret
desenhaNave ENDP


;;
; Desenha todos os inimigos
;;
desenhaInimigo PROC USES ecx esi eax
    movzx ecx, numInimigos
    cmp ecx, 0
    je fim
    mov esi, 0
L1:
    ;INVOKE insertRegionIntoBuffer, OFFSET inimigo, inimigo_dimension, inimigo_curr_pos[esi]
    INVOKE insertRegionIntoBufferWithColor, OFFSET inimigo, OFFSET inimigo_color, inimigo_dimension, inimigo_curr_pos[esi]
    dec inimigo_curr_pos[esi].X
    add esi, TYPE COORD

    
    loop L1
fim:

    ret
desenhaInimigo ENDP

;;
; Desenha todos os tiros
;;
desenhaTiro PROC USES ecx esi eax
    movzx ecx, numTiros
    cmp ecx, 0
    je fim
    mov esi, 0
L1:
    INVOKE insertRegionIntoBuffer, OFFSET tiro, tiro_dimension, tiro_curr_pos[esi]
    add tiro_curr_pos[esi].X, 2
    add esi, TYPE COORD
    loop L1
fim:

    ret
desenhaTiro ENDP

;;
; Desenha todas as estrelas, junto com as respostas das perguntas
;;
desenhaEstrelas PROC USES ecx esi eax ebx
    mov ecx, NUM_STARS
    mov esi, 0
    mov ebx, 0
L1:
    ;INVOKE insertRegionIntoBuffer, OFFSET star, star_dimension, star_curr_pos[esi]
    INVOKE insertRegionIntoBufferWithColor, OFFSET star, OFFSET star_color, star_dimension, star_curr_pos[esi]
    mov eax, OFFSET OPS
    add eax, ebx
   
    push edx
    mov dx, star_curr_pos[esi].X
    add dx,2
    mov resposta_curr_pos.X, dx

    mov dx, star_curr_pos[esi].Y
    add dx,1
    mov resposta_curr_pos.Y, dx
    pop edx

    INVOKE insertRegionIntoBufferWithColor, eax,OFFSET resposta_color, digit_dimension, resposta_curr_pos
    dec star_curr_pos[esi].X
    add esi, TYPE COORD
    inc ebx

    
    loop L1

    ret
desenhaEstrelas ENDP

;;
; Desenha introdução
;;
desenhaIntro PROC
    call ClearBuffer
    INVOKE insertRegionIntoBufferWithColor, OFFSET intro_img1, OFFSET intro_color1, intro_dimension, intro_pos1
    INVOKE insertRegionIntoBufferWithColor, OFFSET intro_img2, OFFSET intro_color2, intro_dimension, intro_pos2
    INVOKE insertRegionIntoBufferWithColor, OFFSET intro_img3, OFFSET intro_color3, intro_dimension, intro_pos3
    INVOKE insertRegionIntoBufferWithColor, OFFSET intro_img4, OFFSET intro_color4, intro_dimension, intro_pos4
    INVOKE insertRegionIntoBufferWithColor, OFFSET intro_img5, OFFSET intro_color5, intro_dimension, intro_pos5
    ret
desenhaIntro ENDP

;;
; Desenha tela final do jogo (Arcomp)
;;
desenhaArcomp PROC
    call ClearBuffer
    INVOKE insertRegionIntoBufferWithColor, OFFSET arcomp_img1, OFFSET arcomp_color1, arcomp_dimension, arcomp_pos1
    INVOKE insertRegionIntoBufferWithColor, OFFSET arcomp_img2, OFFSET arcomp_color2, arcomp_dimension, arcomp_pos2
    INVOKE insertRegionIntoBufferWithColor, OFFSET arcomp_img3, OFFSET arcomp_color3, arcomp_dimension, arcomp_pos3
    INVOKE insertRegionIntoBufferWithColor, OFFSET arcomp_img4, OFFSET arcomp_color4, arcomp_dimension, arcomp_pos4
    INVOKE insertRegionIntoBufferWithColor, OFFSET arcomp_img5, OFFSET arcomp_color5, arcomp_dimension, arcomp_pos5
    ret
desenhaArcomp ENDP

;;
; Desenha tela de lose
;;
desenhaLose PROC
    call ClearBuffer
    INVOKE insertRegionIntoBufferWithColor, OFFSET lose_img1, OFFSET lose_color1, lose_dimension, lose_pos1
    INVOKE insertRegionIntoBufferWithColor, OFFSET lose_img2, OFFSET lose_color2, lose_dimension, lose_pos2
    INVOKE insertRegionIntoBufferWithColor, OFFSET lose_img3, OFFSET lose_color3, lose_dimension, lose_pos3
    INVOKE insertRegionIntoBufferWithColor, OFFSET lose_img4, OFFSET lose_color4, lose_dimension, lose_pos4
    INVOKE insertRegionIntoBufferWithColor, OFFSET lose_img5, OFFSET lose_color5, lose_dimension, lose_pos5
    ret
desenhaLose ENDP

;;
; Desenha tela de instruções
;;
desenhaInstrucao PROC
    call ClearBuffer
    INVOKE insertRegionIntoBuffer, OFFSET instru_img1, instru_dimension, instru_pos1
    INVOKE insertRegionIntoBuffer, OFFSET instru_img2, instru_dimension, instru_pos2
    INVOKE insertRegionIntoBuffer, OFFSET instru_img3, instru_dimension, instru_pos3
    INVOKE insertRegionIntoBuffer, OFFSET instru_img4, instru_dimension, instru_pos4
    INVOKE insertRegionIntoBuffer, OFFSET instru_img5, instru_dimension, instru_pos5
    ret
desenhaInstrucao ENDP


;;
; Desenha munição disponível
;;
desenhaMunicao PROC
    movzx ecx, num_max_tiros
    movzx eax, numTiros
    .if ecx > 0   
    .if eax < 1 
        ;INVOKE insertRegionIntoBuffer, OFFSET municao, municao_dimension, municao_curr_pos
        INVOKE insertRegionIntoBufferWithColor, OFFSET municao, OFFSET municao_color, municao_dimension, municao_curr_pos
    .endif
    .endif
    ret
desenhaMunicao ENDP

;;
; Desenha informação do nível
;;
desenhaLevel PROC
    INVOKE insertRegionIntoBuffer, OFFSET level, level_dimension, level_pos
    push eax
    mov al, game_level_curr
    mov digit, al
    pop eax
    add digit, '0'
    INVOKE insertRegionIntoBuffer, OFFSET digit, digit_dimension, digit_pos
    ret
desenhaLevel ENDP

;;
; Desenha pergunta do nível
;;
desenhaPergunta PROC
    INVOKE insertRegionIntoBuffer, OFFSET game_level_question, digit_dimension, pergunta_pos
    add pergunta_pos.X, 2
    INVOKE insertRegionIntoBuffer, OFFSET QUESTION, digit_dimension, pergunta_pos
    add pergunta_pos.X, 2
    INVOKE insertRegionIntoBuffer, OFFSET game_level_question.B, digit_dimension, pergunta_pos
    add pergunta_pos.X, 2
    INVOKE insertRegionIntoBuffer, OFFSET EQUAL, digit_dimension, pergunta_pos
    add pergunta_pos.X, 2
    INVOKE insertRegionIntoBuffer, OFFSET game_level_question.R, digit_dimension, pergunta_pos
    sub pergunta_pos.X, 8   
    ret
desenhaPergunta ENDP

;;
; Desenha informações apropriadas para o estado atual do jogo
;;
desenhaInfo PROC
    .if game_curr_state == GAME_STATE_PLAYING
        call desenhaMunicao
    .elseif game_curr_state == GAME_STATE_STAR
        call desenhaPergunta
    .endif
    call desenhaLevel
    ret
desenhaInfo ENDP

;;
; Desenha as informações apropriadas para o estado atual do jogo
;;
atualizaTela PROC
    call desenhaNave
    
    .if game_curr_state == GAME_STATE_PLAYING
        call desenhaInimigo
        call desenhaTiro
        call desenhaInfo
    .elseif game_curr_state == GAME_STATE_STAR
       call desenhaEstrelas
       call desenhaInfo
    .elseif game_curr_state == GAME_STATE_ARCOMP
        call desenhaArcomp
    .elseif game_curr_state == GAME_STATE_LOSE_STAR
        call desenhaLose
    .elseif game_curr_state == GAME_STATE_INTRO
        call desenhaIntro   
    .elseif game_curr_state == GAME_STATE_INSTRU
	    call desenhaInstrucao
    .endif
 
    ret
atualizaTela ENDP