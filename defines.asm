GAME_STATE_QUIT = 1                          ; encerrar o jogo
GAME_STATE_MENU_MAIN = 2                     ; mostrar menu principal
GAME_STATE_PLAYING = 3                     ; jogando

COLS = 80               ; number of columns
ROWS = 25               ; number of rows
CHAR_ATTRIBUTE = 0Fh    ; bright white foreground

DELAY_BETWEEN_FRAMES = 50
DELAY_BETWEEN_SPAWNS = 700

KEY_UP_CODE = 48h
KEY_DOWN_CODE = 50h
KEY_SPACE_CODE = 57
.data

last_spawn DWORD 0
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
;tiros deixexi apenas um tiro
numTiros BYTE 0
NUM_MAX_TIROS = 1
tiro_curr_pos COORD <1,1>
tiro_dimension COORD <1, 1>
tiro BYTE "o",



;desenho do inimigo
;variaveis dos inimigos
numInimigos BYTE 0
NUM_MAX_INIMIGOS = 3
inimigo_curr_pos COORD NUM_MAX_INIMIGOS DUP (<20,20>)

inimigo_dimension COORD <11, 6>
inimigo BYTE 	"  _....._  ",
				".'     - `.",
				":  o      :",
				":       O :",
				"`.    .  .'",
				"  `-...-'  "


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

;!!!!TODO!!!!! instruções 
; desenho das instruções
; dividida em 5 parte por causa de uma limitação do MASM: [ML Nonfatal Error A2039](https://docs.microsoft.com/en-us/cpp/assembler/masm/ml-nonfatal-error-a2039)	
instru_pos1 COORD <0, 0>
instru_pos2 COORD <0, 5>
instru_pos3 COORD <0, 10>
instru_pos4 COORD <0, 15>
instru_pos5 COORD <0, 20>
instru_dimension COORD <67, 5>
instru_img1 BYTE 	"* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *",
					"*                                                                 *",
					"*                     @@                @@                        *",
					"*                     @@                @@                        *",
					"*                       @@            @@                          *"
instru_img2 BYTE 	"*                       @@            @@                          *",
					"*                     @@@@@@@@@@@@@@@@@@@@                        *",
					"*                     @@@@@@@@@@@@@@@@@@@@                        *",
					"*                  @@@@@@    @@@@@@    @@@@@@                     *",
					"*                  @@@@@@    @@@@@@    @@@@@@                     *"
instru_img3 BYTE 	"*               @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                  *",
					"*               @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                  *",
					"*               @@@   @@@@@@@@@@@@@@@@@@@@   @@@                  *",
					"*               @@@   @@@@@@@@@@@@@@@@@@@@   @@@                  *",
					"*               @@@   @@@              @@@   @@@                  *"
instru_img4 BYTE 	"*               @@@   @@@              @@@   @@@                  *",
					"*                        @@@@@@  @@@@@@                           *",
					"*                                                                 *",
					"*                                                                 *",
					"*        UTILIZE AS SETAS <- E -> PARA MOVIMENTAR A NAVE          *"
instru_img5 BYTE 	"*       E A BARRA DE ESPACO PARA ATIRAR CONTRA O INIMIGO          *",
					"*                                                                 *",
					"*             PRESSIONE ENTER PARA INICIAR O JOGO                 *",
					"*                                                                 *",
		 			"* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *"

