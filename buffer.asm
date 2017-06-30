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
    INVOKE CharToBuffer, eax, edx, character
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

; IMAGEM TELA INICIAL 

intro PROC

    call ClrScr

    mov ax, lightRed
    call SetTextColor
    mov edx, OFFSET A1
    call writeString
    call writeString
    call writeString
    call writeString
    mov edx, OFFSET A2
    call writeString
    mov edx, OFFSET A3
    call writeString
    mov edx, OFFSET A4
    call writeString
    mov edx, OFFSET A5
    call writeString
    mov edx, OFFSET A6
    call writeString
    mov edx, OFFSET A7
    call writeString
    mov edx, OFFSET A8
    call writeString
    mov edx, OFFSET A9
    call writeString

    mov ax, white
    call SetTextColor
    mov edx, OFFSET A1
    call writeString
    call writeString
    call writeString
    call writeString
    mov edx, OFFSET A10
    call writeString
    mov edx, OFFSET A1
    call writeString
    call writeString
    mov edx, OFFSET A11
    call writeString
    mov edx, OFFSET A12
    call writeString
    mov edx, OFFSET A13
    call writeString

    ret
intro ENDP

; IMAGEM TELA DE INSTRUÇÕES
instrucao PROC

    call ClrScr

    mov ax, white
    call SetTextColor
    mov edx, OFFSET PL
    call writeString
    mov edx, OFFSET EL
    call writeString
    mov edx, OFFSET EL
    call writeString
    mov edx, OFFSET J1
    call writeString

    mov ax, lightBlue
    call SetTextColor
    mov edx, OFFSET J2
    call writeString

    mov ax, white
    call SetTextColor
    mov edx, OFFSET J3
    call writeString
    mov edx, OFFSET J4
    call writeString

    mov ax, lightblue
    call SetTextColor
    mov edx, OFFSET J5
    call writeString

    mov ax, white
    call SetTextColor
    mov edx, OFFSET J6
    call writeString
    mov edx, OFFSET J7
    call writeString

    mov ax, lightblue
    call SetTextColor
    mov edx, OFFSET J8
    call writeString

    mov ax, white
    call SetTextColor
    mov edx, OFFSET J9
    call writeString
    mov edx, OFFSET J10
    call writeString

    mov ax, lightblue
    call SetTextColor
    mov edx, OFFSET J11
    call writeString

    mov ax, white
    call SetTextColor
    mov edx, OFFSET J12
    call writeString
    mov edx, OFFSET J13
    call writeString

    mov ax, lightblue
    call SetTextColor
    mov edx, OFFSET J14
    call writeString

    mov ax, white
    call SetTextColor
    mov edx, OFFSET J15
    call writeString
    mov edx, OFFSET J16
    call writeString

    mov ax, lightblue 
    call SetTextColor
    mov edx, OFFSET J17
    call writeString

    mov ax, white
    call SetTextColor
    mov edx, OFFSET J18
    call writeString
    mov edx, OFFSET J19
    call writeString

    mov ax, lightblue
    call SetTextColor
    mov edx, OFFSET J20
    call writeString

    mov ax, white
    call SetTextColor
    mov edx, OFFSET J21
    call writeString
    mov edx, OFFSET J22
    call writeString

    mov ax, lightblue
    call SetTextColor
    mov edx, OFFSET J23
    call writeString

    mov ax, white
    call SetTextColor
    mov edx, OFFSET J24
    call writeString
    mov edx, OFFSET J25
    call writeString

    mov ax, lightblue
    call SetTextColor
    mov edx, OFFSET J26
    call writeString

    mov ax, white
    call SetTextColor
    mov edx, OFFSET J27
    call writeString
    mov edx, OFFSET J28
    call writeString

    mov ax, lightblue
    call SetTextColor
    mov edx, OFFSET J29
    call writeString

    mov ax, white
    call SetTextColor
    mov edx, OFFSET J30
    call writeString
    mov edx, OFFSET J31
    call writeString

    mov ax, lightblue
    call SetTextColor
    mov edx, OFFSET J32
    call writeString

    mov ax, white
    call SetTextColor
    mov edx, OFFSET J33
    call writeString
    mov edx, OFFSET J34
    call writeString

    mov ax, lightblue
    call SetTextColor
    mov edx, OFFSET J35
    call writeString

    mov ax, white
    call SetTextColor
    mov edx, OFFSET J36
    call writeString
    mov edx, OFFSET J37
    call writeString

    mov ax, lightblue
    call SetTextColor
    mov edx, OFFSET J38
    call writeString

    mov ax, white
    call SetTextColor
    mov edx, OFFSET J39
    call writeString
    mov edx, OFFSET J40
    call writeString

    mov ax, lightblue
    call SetTextColor
    mov edx, OFFSET J41
    call writeString

    mov ax, white
    call SetTextColor
    mov edx, OFFSET J42
    call writeString
    mov edx, OFFSET J43
    call writeString

    mov ax, lightblue
    call SetTextColor
    mov edx, OFFSET J44
    call writeString

    mov ax, white
    call SetTextColor
    mov edx, OFFSET J45
    call writeString
    mov edx, OFFSET EL
    call writeString
    mov edx, OFFSET EL
    call writeString
    mov edx, OFFSET EL
    call writeString
    mov edx, OFFSET J46
    call writeString

    mov ax, blue
    call SetTextColor
    mov edx, OFFSET J47
    call writeString

    mov ax, white
    call SetTextColor
    mov edx, OFFSET J48
    call writeString
    mov edx, OFFSET EL
    call writeString
    mov edx, OFFSET J49
    call writeString

    mov ax, blue
    call SetTextColor
    mov edx, OFFSET J50
    call writeString

    mov ax, white
    call SetTextColor
    mov edx, OFFSET J51
    call writeString
    mov edx, OFFSET EL
    call writeString
    mov edx, OFFSET EL
    call writeString
    mov edx, OFFSET J52
    call writeString
    mov edx, OFFSET EL
    call writeString
    mov edx, OFFSET PL
    call writeString

    ret
instrucao ENDP

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

; Atualiza tela
atualizaTela PROC
    mov edx, 0
    call gotoXY
    
    call ClearBuffer
    call desenhaNave
    ;call desenhaInimigo
    ;call desenhaMoldura
 
    ret
atualizaTela ENDP