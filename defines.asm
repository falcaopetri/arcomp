GAME_STATE_QUIT = 1                          ; encerrar o jogo
GAME_STATE_MENU_MAIN = 2                     ; mostrar menu principal

COLS = 80               ; number of columns
ROWS = 25               ; number of rows
CHAR_ATTRIBUTE = 0Fh    ; bright white foreground

DELAY_BETWEEN_FRAMES = 250

.data

game_curr_state DWORD GAME_STATE_MENU_MAIN

console HANDLE 0
buffer CHAR_INFO ROWS * COLS DUP(<<'-'>, CHAR_ATTRIBUTE>)
bufferSize COORD <COLS, ROWS>
bufferCoord COORD <0, 0>
region SMALL_RECT <0, 0, COLS-1, ROWS-1>

x DWORD 0               ; current position
y DWORD 2               ; of the figure
character WORD '0'      ; filled with this symbol