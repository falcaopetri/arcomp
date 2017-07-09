; GAME STATES
GAME_STATE_QUIT = 1                         ; encerrar o jogo
;GAME_STATE_MENU_MAIN = 2                    ; mostrar menu principal
GAME_STATE_PLAYING = 3                     	; jogando
GAME_STATE_STAR = 4                     	; respondendo pergunta
GAME_STATE_ARCOMP = 5 						; jogo completo
GAME_STATE_LOSE_STAR = 6 					; lose por errar a estrela
GAME_STATE_LOSE_COLLISION = GAME_STATE_LOSE_STAR		; lose por colisão
GAME_STATE_INTRO = 8		; mostrar intro
GAME_STATE_INSTRU = 9		; mostrar instru

; TELA
COLS = 80               ; number of columns
ROWS = 25               ; number of rows
CHAR_ATTRIBUTE = 0Fh    ; bright white foreground

; DELAYS
DELAY_BETWEEN_FRAMES = 50
DELAY_BETWEEN_SPAWNS = 700

; TECLAS
KEY_UP_CODE = 48h
KEY_DOWN_CODE = 50h
KEY_SPACE_CODE = 39h
KEY_ESC_CODE = 1Bh
KEY_ENTER_CODE = 0Dh


.data
; PERGUNTAs
OPS BYTE '+', '-', '*'
QUESTION BYTE '?'
EQUAL BYTE '='

STAR_QUESTION STRUCT
	A BYTE '0'
	B BYTE '0'
	R BYTE '0'
	OP BYTE '0'
STAR_QUESTION ENDS
pergunta_pos COORD <40, 1>

; GAME
MAX_LEVELS = 2
game_level_question STAR_QUESTION <>

game_title BYTE "ARCOMP", 0
last_spawn DWORD 0
game_curr_state DWORD GAME_STATE_INTRO
game_level_curr BYTE 0
game_level_remaining_enemies DWORD ?

; TELA
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
tiro BYTE "o"

;todo mudar desenho de tiro disponivel?
;municao
municao_curr_pos COORD <1,1>
municao_dimension COORD <10, 1>
municao_color WORD 10 DUP(1 DUP(00E0h))
municao BYTE "DISPONIVEL"

level BYTE "Level: "
level_dimension COORD <7, 1>
level_pos COORD <20, 1> 
digit BYTE ?
digit_dimension COORD <1, 1>
digit_pos COORD <27, 1>

;desenho do inimigo
;variaveis dos inimigos
numInimigos BYTE 0
NUM_MAX_INIMIGOS = 3
inimigo_curr_pos COORD NUM_MAX_INIMIGOS DUP (<20,20>)
inimigo_color WORD 11 DUP(6 DUP(000Dh))
inimigo_dimension COORD <11, 6>
inimigo BYTE 	"  _....._  ",
				".'     - `.",
				":  o      :",
				":       O :",
				"`.    .  .'",
				"  `-...-'  "

;desenho da estrela
;variaveis das estrelas
resposta_curr_pos COORD <1,1>
resposta_color WORD 1 DUP(1 DUP(000Ah))
NUM_STARS = 3
star_initial_pos COORD <60, 0>, <60, 10>, <60, 20>
star_curr_pos COORD <60, 0>, <60, 10>, <60, 20>
star_dimension COORD <7, 4>
star_color WORD 4 DUP(7 DUP(000Eh))
star BYTE 	"__/ \__",
			"\     /",
			"/_   _\",
			"  \ /  "
 
;explosao
explosao_curr_pos COORD NUM_MAX_INIMIGOS DUP (<20,20>)
explosao_dimension COORD <13, 6>
explosao_color WORD 13 DUP(6 DUP(000Ch))
explosao BYTE "   \  |  /   ",
			  "  .-^~~~^-.  ",
		      " .~  ,     ~.",
		      "(;:   *   :;)",
              "(:         :)",
              " ':._ |._.:' "        
                                
                               
                               
                              
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

intro_color1 WORD 5 DUP(67 DUP(0002h))
intro_color2 WORD 5 DUP(67 DUP(0002h))
intro_color3 WORD 5 DUP(67 DUP(0002h))
intro_color4 WORD 5 DUP(67 DUP(0002h))
intro_color5 WORD 5 DUP(67 DUP(0002h))

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




lose_pos1 COORD <0, 0>
lose_pos2 COORD <0, 5>
lose_pos3 COORD <0, 10>
lose_pos4 COORD <0, 15>
lose_pos5 COORD <0, 20>
lose_dimension COORD <67, 5>

lose_color1 WORD 5 DUP(67 DUP(0004h))
lose_color2 WORD 5 DUP(67 DUP(0004h))
lose_color3 WORD 5 DUP(67 DUP(0004h))
lose_color4 WORD 5 DUP(67 DUP(0004h))
lose_color5 WORD 5 DUP(67 DUP(0004h))

lose_img1 BYTE 	    "    ______________________________________________________________ ",
					"   /                                                              \",
					"  |    ______________________________________________________     |",
					"  |   |                                                      |    |",
					"  |   |   _____                         ____                 |    |"
lose_img2 BYTE 	    "  |   |  / ____|                       / __ \                |    |",
					"  |   | | |  __  __ _ _ __ ___   ___  | |  | |_   _____ _ __ |    |",
					"  |   | | | |_ |/ _` | '_ ` _ \ / _ \ | |  | \ \ / / _ \ '__||    |",
					"  |   | | |__| | (_| | | | | | |  __/ | |__| |\ V /  __/ |   |    |",
					"  |   |  \_____|\__,_|_| |_| |_|\___|  \____/  \_/ \___|_|   |    |"
lose_img3 BYTE   	"  |   |                                                      |    |",
					"  |   |                                                      |    |",
					"  |   |                                                      |    |",
					"  |   |                                                      |    |",
					"  |   |                                                      |    |"
lose_img4 BYTE 	    "  |   |                                          Antonio     |    |",
					"  |   |                                          Jose Vitor  |    |",
					"  |   |                                          Thiago      |    |",
					"  |   |                                                      |    |",
					"  |   |                                                      |    |"
lose_img5 BYTE 	    "  |   |                                                      |    |",
					"  |   |______________________________________________________|    |",
					"  |                                                               |",
					"   \______________________________________________________________/",
		 			"         \________________________________________________/        "


arcomp_pos1 COORD <0, 0>
arcomp_pos2 COORD <0, 5>
arcomp_pos3 COORD <0, 10>
arcomp_pos4 COORD <0, 15>
arcomp_pos5 COORD <0, 20>
arcomp_dimension COORD <67, 5>

arcomp_color1 WORD 5 DUP(67 DUP(000Bh))
arcomp_color2 WORD 5 DUP(67 DUP(000Bh))
arcomp_color3 WORD 5 DUP(67 DUP(000Bh))
arcomp_color4 WORD 5 DUP(67 DUP(000Bh))
arcomp_color5 WORD 5 DUP(67 DUP(000Bh))

arcomp_img1 BYTE 	"    ______________________________________________________________ ",
					"   /                                                              \",
					"  |    ______________________________________________________     |",
					"  |   |                                                      |    |",
					"  |   |       _____                _                         |    |"
arcomp_img2 BYTE    "  |   |      |  __ \              | |                        |    |",
					"  |   |      | |__) |_ _ _ __ __ _| |__   ___ _ __  ___      |    |",
					"  |   |      |  ___/ _` | '__/ _` | '_ \ / _ \ '_ \/ __|     |    |",
					"  |   |      | |  | (_| | | | (_| | |_) |  __/ | | \__ \     |    |",
					"  |   |      |_|   \__,_|_|  \__,_|_.__/ \___|_| |_|___/     |    |"
arcomp_img3 BYTE   	"  |   |                                                      |    |",
					"  |   |                                                      |    |",
					"  |   |                     ,MMM8&&&.                        |    |",
					"  |   |                _...MMMMM88&&&&..._                   |    |",
					"  |   |             .::'''MMMMM88&&&&&&'''::.                |    |"
arcomp_img4 BYTE    "  |   |            ::     MMMMM88&&&&&&     ::               |    |",
					"  |   |            '::....MMMMM88&&&&&&....::'               |    |",
					"  |   |               `''''MMMMM88&&&&''''`                  |    |",
					"  |   |                     'MMM8&&&                         |    |",
					"  |   |                                                      |    |"
arcomp_img5 BYTE    "  |   |                                                      |    |",
					"  |   |______________________________________________________|    |",
					"  |                                                               |",
					"   \______________________________________________________________/",
		 			"         \________________________________________________/        "