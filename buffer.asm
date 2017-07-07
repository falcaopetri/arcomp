.code

ClearBuffer PROC USES eax 
    xor eax, eax

BLANKS:  
    mov buffer[eax * CHAR_INFO].Char, ' '
    inc eax
    cmp eax, ROWS * COLS
    jl BLANKS

    ret       
ClearBuffer ENDP

;;
; Dá fill no buffer com o conteúdo do menu MAIN
; @param game_curr_state - variável global
; @return buffer - modifica a variável global
;;
buffer_fill_menu_main PROC USES eax edx ecx
    CALL ClearBuffer

    ; render 10 by 7 rectangle
    mov edx, y
    mov ecx, 7
ONELINE:
    mov eax, x

    push ecx
    mov ecx, 10

ONECHAR:
    ;INVOKE CharToBuffer, eax, edx, character
    inc eax
    loop ONECHAR    ; inner loop prints characters

    inc edx
    pop ecx
    loop ONELINE    ; outer loop prints lines

    inc x           ; increment x for the next frame
    inc character   ; change fill character for the next frame

    ret
buffer_fill_menu_main ENDP

buffer_print PROC
    invoke WriteConsoleOutput, console, 
           ADDR buffer, bufferSize, bufferCoord, ADDR region
    INVOKE Sleep, DELAY_BETWEEN_FRAMES

    ret
buffer_print ENDP

insertStringIntoBuffer PROC USES ecx esi eax ebx edi string:PTR BYTE, len:WORD, start:COORD
    cld
    movzx ecx, len
    mov esi, string

    movzx eax, start.Y
    imul eax, 80
    movzx ebx, start.X
    add eax, ebx
    imul eax, TYPE CHAR_INFO
    lea edi, buffer[eax]

L1:
    movzx ax, BYTE PTR [esi]
    mov (CHAR_INFO PTR [edi]).Char, ax
    add esi, TYPE BYTE
    add edi, TYPE CHAR_INFO
    loop L1
    ret
insertStringIntoBuffer ENDP

; Insere região no buffer
insertRegionIntoBuffer PROC USES eax esi ecx string:PTR BYTE, dimension:COORD, start:COORD
    LOCAL curr:COORD
    ; curr <- start
    mov ax, start.X
    mov curr.X, ax
    mov ax, start.Y
    mov curr.Y, ax
    
    mov esi, string
    movzx eax, dimension.X
    ; for i in range(0, dimension.Y):
    movzx ecx, dimension.Y
    ; insere cada linha do desenho na posição adequada no buffer
EACH_LINE:
    INVOKE insertStringIntoBuffer, esi, dimension.X, curr
    inc curr.Y
    add esi, eax
    loop EACH_LINE

    ret
insertRegionIntoBuffer ENDP

;DESENHA NAVE
desenhaNave PROC
    INVOKE insertRegionIntoBuffer, OFFSET nave, nave_dimension, nave_curr_pos
    ret
desenhaNave ENDP


;DESENHA INIMIGO
desenhaInimigo PROC USES ecx esi eax
    movzx ecx, numInimigos
    cmp ecx, 0
    je fim
    mov esi, 0
L1:
    INVOKE insertRegionIntoBuffer, OFFSET inimigo, inimigo_dimension, inimigo_curr_pos[esi]
    dec inimigo_curr_pos[esi].X
    add esi, TYPE COORD

    
    loop L1
fim:

    ret
desenhaInimigo ENDP

;DESENHA TIRO
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


;DESENHA INTRO
desenhaIntro PROC
    call ClearBuffer
    INVOKE insertRegionIntoBuffer, OFFSET intro_img1, intro_dimension, intro_pos1
    INVOKE insertRegionIntoBuffer, OFFSET intro_img2, intro_dimension, intro_pos2
    INVOKE insertRegionIntoBuffer, OFFSET intro_img3, intro_dimension, intro_pos3
    ret
desenhaIntro ENDP

;DESENHA INTRO
desenhaInstrucao PROC
    call ClearBuffer
    INVOKE insertRegionIntoBuffer, OFFSET instru_img1, instru_dimension, instru_pos1
    INVOKE insertRegionIntoBuffer, OFFSET instru_img2, instru_dimension, instru_pos2
    INVOKE insertRegionIntoBuffer, OFFSET instru_img3, instru_dimension, instru_pos3
    INVOKE insertRegionIntoBuffer, OFFSET instru_img4, instru_dimension, instru_pos4
    INVOKE insertRegionIntoBuffer, OFFSET instru_img5, instru_dimension, instru_pos5
    ret
desenhaInstrucao ENDP


;DESENHA MUINICAO DISPONIVEL
desenhaMunicao PROC
    movzx ecx, num_max_tiros
    movzx eax, numTiros
    .if ecx > 0   
    .if eax < 1 
        INVOKE insertRegionIntoBuffer, OFFSET municao, municao_dimension, municao_curr_pos
    .endif
    .endif
    ret
desenhaMunicao ENDP
; Atualiza tela
atualizaTela PROC
    mov edx, 0
    call gotoXY
    
    call ClearBuffer
    call desenhaNave
    call desenhaInimigo
    call desenhaTiro
    call desenhaMunicao
    ;call desenhaMoldura
 
    ret
atualizaTela ENDP