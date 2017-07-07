GAME_STATE_QUIT = 1                          ; encerrar o jogo
GAME_STATE_MENU_MAIN = 2                     ; mostrar menu principal
GAME_STATE_PLAYING = 3                     ; jogando
GAME_STATE_STAR = 4                     ; respondendo pergunta

COLS = 80               ; number of columns
ROWS = 25               ; number of rows
CHAR_ATTRIBUTE = 0Fh    ; bright white foreground

DELAY_BETWEEN_FRAMES = 50
DELAY_BETWEEN_SPAWNS = 700

KEY_UP_CODE = 48h
KEY_DOWN_CODE = 50h
KEY_SPACE_CODE = 57
KEY_ESC_CODE = 1Bh

MAX_LEVELS = 10

.data

game_title BYTE "ARCOMP", 0
last_spawn DWORD 0
game_curr_state DWORD GAME_STATE_PLAYING
game_level_curr BYTE 1
game_level_remaining_enemies DWORD ?

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
num_max_tiros BYTE 1
tiro_curr_pos COORD <1,1>
tiro_dimension COORD <1, 1>
tiro BYTE "o",

;todo mudar desenho de tiro disponivel?
;municao
municao_curr_pos COORD <1,1>
municao_dimension COORD <10, 1>
municao BYTE "DISPONIVEL",


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

;desenho da estrela
;variaveis das estrelas
NUM_STARS = 3
star_initial_pos COORD <60, 0>, <60, 10>, <60, 20>
star_curr_pos COORD <60, 0>, <60, 10>, <60, 20>
star_dimension COORD <9, 5>
star BYTE 	"    |\   ",
			"|\  | \  ",
			"|===== )>",
			"|/  | /  ",
			"    |/   "


;explosao
explosao_curr_pos COORD NUM_MAX_INIMIGOS DUP (<20,20>)
explosao_dimension COORD <13, 6>
explosao BYTE "   \  |  /   ",
			  "  .-^~~~^-.  ",
		      " .~  ,     ~.",
		      "(;:   *   :;)",
              "(:         :)",
              " ':._ |._.:' "        
                                
                               
                               
                              
;!!!!TODO!!!!! instruções 
; desenho das instruções
; dividida em 5 parte por causa de uma limitação do MASM: [ML Nonfatal Error A2039](https://docs.microsoft.com/en-us/cpp/assembler/masm/ml-nonfatal-error-a2039)
instru_pos1 COORD <0, 0>
instru_pos2 COORD <0, 5>
instru_pos3 COORD <0, 10>
instru_pos4 COORD <0, 15>
instru_pos5 COORD <0, 20>
instru_dimension COORD <67, 5>

instru_img1 BYTE 	"    ______________________________________________________________ ",
					"   /                                                              \",
					"  |    ______________________________________________________     |",
					"  |   |                                                      |    |",
					"  |   |                                                      |    |"
instru_img2 BYTE 	"  |   |              CUIDADO! com os asteroides!             |    |",
					"  |   |                                                      |    |",
					"  |   |                                                      |    |",
					"  |   |                                    _....._           |    |",
					"  |   |      |\                          .'     - `.         |    |"
instru_img3 BYTE 	"  |   |  |\  | \                         :  o      :         |    |",
					"  |   |  |===== )>                       :       O :         |    |",
					"  |   |  |/  | /                         `.    .  .'         |    |",
					"  |   |      |/                            `-...-'           |    |",
					"  |   |                                                      |    |"
instru_img4 BYTE 	"  |   |                                                      |    |",
					"  |   |    Uilize as seta UP e DOWN para controlar a nave    |    |",
					"  |   |                e espaco para atirar                  |    |",
					"  |   |                                                      |    |",
					"  |   |                                                      |    |"
instru_img5 BYTE 	"  |   |           PRESSIONE ENTER PARA CONTINUAR             |    |",
					"  |   |______________________________________________________|    |",
					"  |                                                               |",
					"   \______________________________________________________________/",
		 			"         \________________________________________________/        "


; desenho da intro
; dividida em 3 parte por causa de uma limitação do MASM: [ML Nonfatal Error A2039](https://docs.microsoft.com/en-us/cpp/assembler/masm/ml-nonfatal-error-a2039)

intro_pos1 COORD <0, 0>
intro_pos2 COORD <0, 5>
intro_pos3 COORD <0, 10>
intro_pos4 COORD <0, 15>
intro_pos5 COORD <0, 20>
intro_dimension COORD <67, 5>

intro_color1 WORD 4 DUP(67 DUP(0004h))
intro_color2 WORD 4 DUP(67 DUP(0004h))
intro_color3 WORD 4 DUP(67 DUP(0007h))
intro_color4 WORD 4 DUP(67 DUP(0007h))
intro_color5 WORD 4 DUP(67 DUP(0007h))

intro_img1 BYTE 	"    ______________________________________________________________ ",
					"   /                                                              \",
					"  |    ______________________________________________________     |",
					"  |   |                                                      |    |",
					"  |   |                                                      |    |"
intro_img2 BYTE 	"  |   | ######   #####   ######  ########  ###    ###  ######|    |",
					"  |   |#      #  #    #  #       #      #  # #   #  #  #    #|    |",
					"  |   |#      #  #    #  #       #      #  #  # #   #  #    #|    |",
					"  |   |#      #  #   #   #       #      #  #   #    #  #    #|    |",
					"  |   |########  ####    #       #      #  #        #  ##### |    |"
intro_img3 BYTE 	"  |   |#      #  #  #    #       #      #  #        #  #     |    |",
					"  |   |#      #  #   #   #       #      #  #        #  #     |    |",
					"  |   |#      #  #    #  ######  ########  #        #  #     |    |",
					"  |   |                                                      |    |",
					"  |   |                                                      |    |"
intro_img4 BYTE 	"  |   |                                          Antonio     |    |",
					"  |   |                                          Jose Vitor  |    |",
					"  |   |                                          Thiago      |    |",
					"  |   |                                                      |    |",
					"  |   |                                                      |    |"
intro_img5 BYTE 	"  |   |           PRESSIONE ENTER PARA CONTINUAR             |    |",
					"  |   |______________________________________________________|    |",
					"  |                                                               |",
					"   \______________________________________________________________/",
		 			"         \________________________________________________/        "
