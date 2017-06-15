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


CharToBuffer PROC USES eax edx bufx:DWORD, bufy:DWORD, char:WORD 
    mov eax, bufy
    mov edx, COLS
    mul edx
    add eax, bufx
    mov dx, char
    mov buffer[eax * CHAR_INFO].Char, dx
    ret
CharToBuffer ENDP

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