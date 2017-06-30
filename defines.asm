GAME_STATE_QUIT = 1                          ; encerrar o jogo
GAME_STATE_MENU_MAIN = 2                     ; mostrar menu principal
GAME_STATE_PLAYING = 3                     ; jogando

COLS = 80               ; number of columns
ROWS = 25               ; number of rows
CHAR_ATTRIBUTE = 0Fh    ; bright white foreground

DELAY_BETWEEN_FRAMES = 100

.data

game_curr_state DWORD GAME_STATE_PLAYING

console HANDLE 0
buffer CHAR_INFO ROWS * COLS DUP(<<'-'>, CHAR_ATTRIBUTE>)
bufferSize COORD <COLS, ROWS>
bufferCoord COORD <0, 0>
region SMALL_RECT <0, 0, COLS-1, ROWS-1>

x DWORD 0               ; current position
y DWORD 2               ; of the figure
character WORD '0'      ; filled with this symbol

;variaveis da nave
;esta invertido 
vida BYTE 39h, 0
naveX BYTE 10
naveY BYTE 1

;desenho da nave
nave_curr_pos COORD <1, 10>
nave_dimension COORD <9, 5>
nave BYTE 	"    |\   ",
			"|\  | \  ",
			"|===== )>",
			"|/  | /  ",
			"    |/   "

; desenho do inimigo
inimigo_curr_pos COORD <20, 10>
inimigo_dimension COORD <9, 5>
inimigo BYTE 	"   /|    ",
				"  / |  /|",
				"<( =====|",
				"  \ |  \|",
				"   \|    "

; desenho da intro
; dividida em 3 parte por causa de uma limitação do MASM: [ML Nonfatal Error A2039](https://docs.microsoft.com/en-us/cpp/assembler/masm/ml-nonfatal-error-a2039)
intro_pos1 COORD <5, 4>
intro_pos2 COORD <5, 8>
intro_pos3 COORD <5, 15>
intro_dimension COORD <63, 4>
intro_img1 BYTE	" #######    #####    #######   #########   ###     ###   ######",
				"#       #   #    #   #         #       #   #  #   #  #   #    #",
				"#       #   #    #   #         #       #   #   # #   #   #    #",
				"#       #   #   #    #         #       #   #    #    #   #    #"
intro_img2 BYTE	"#########   ####     #         #       #   #         #   ##### ",
				"#       #   #  #     #         #       #   #         #   #     ",
				"#       #   #   #    #         #       #   #         #   #     ",
				"#       #   #    #   #######   #########   #         #   #     "
intro_img3 BYTE "               PRESSIONE ENTER PARA CONTINUAR                  ",
				"                                                     Antonio   ",
				"                                                  Jose Vitor   ",
				"                                                      Thiago   "

; _________ Variáveis para linhas em comum _________
	PL BYTE " * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * ", 0Dh, 0Ah, 0  ;Primeira Linha
	EL BYTE " *                                                                 * ", 0Dh, 0Ah, 0  ;Linha de espaço

;!!!!TODO!!!!! instruções 
	
	J1 BYTE " *                     ",0
	J2 BYTE "@@                @@",0
	J3 BYTE "                        * ", 0Dh, 0Ah, 0
	J4 BYTE " *                     ",0
	J5 BYTE "@@                @@",0
	J6 BYTE "                        * ", 0Dh, 0Ah, 0
	J7 BYTE " *                       ",0
	J8 BYTE "@@            @@",0
	J9 BYTE "                          * ", 0Dh, 0Ah, 0
	J10 BYTE " *                       ",0
	J11 BYTE "@@            @@",0
	J12 BYTE "                          * ", 0Dh, 0Ah, 0
	J13 BYTE " *                     ",0
	J14 BYTE "@@@@@@@@@@@@@@@@@@@@",0
	J15 BYTE "                        * ", 0Dh, 0Ah, 0
	J16 BYTE " *                     ",0
	J17 BYTE "@@@@@@@@@@@@@@@@@@@@",0
	J18 BYTE "                        * ", 0Dh, 0Ah, 0
	J19 BYTE " *                  ",0
	J20 BYTE "@@@@@@    @@@@@@    @@@@@@",0
	J21 BYTE "                     * ", 0Dh, 0Ah, 0
	J22 BYTE " *                  ",0
	J23 BYTE "@@@@@@    @@@@@@    @@@@@@",0
	J24 BYTE "                     * ", 0Dh, 0Ah, 0
	J25 BYTE " *               ",0
	J26 BYTE"@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@",0
	J27 BYTE"                  * ", 0Dh, 0Ah, 0
	J28 BYTE " *               ",0
	J29 BYTE"@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@",0
	J30 BYTE"                  * ", 0Dh, 0Ah, 0
	J31 BYTE " *               ",0
	J32 BYTE "@@@   @@@@@@@@@@@@@@@@@@@@   @@@",0
	J33 BYTE "                  * ", 0Dh, 0Ah, 0
	J34 BYTE " *               ",0
	J35 BYTE "@@@   @@@@@@@@@@@@@@@@@@@@   @@@",0
	J36 BYTE "                  * ", 0Dh, 0Ah, 0
	J37 BYTE " *               ",0
	J38 BYTE "@@@   @@@              @@@   @@@",0
	J39 BYTE "                  * ", 0Dh, 0Ah, 0
	J40 BYTE " *               ",0
	J41 BYTE "@@@   @@@              @@@   @@@",0
	J42 BYTE "                  * ", 0Dh, 0Ah, 0
	J43 BYTE " *                        ",0
	J44 BYTE "@@@@@@  @@@@@@",0
	J45 BYTE "                           * ", 0Dh, 0Ah, 0
	J46 BYTE " *        ",0
	J47 BYTE "UTILIZE AS SETAS <- E -> PARA MOVIMENTAR A NAVE",0
	J48 BYTE "          * ", 0Dh, 0Ah, 0
	J49 BYTE " *       ",0
	J50 BYTE "E A BARRA DE ESPACO PARA ATIRAR CONTRA O INIMIGO",0
	J51 BYTE "          * ", 0Dh, 0Ah, 0
	J52 BYTE " *             PRESSIONE ENTER PARA INICIAR O JOGO                 * ", 0Dh, 0Ah, 0

