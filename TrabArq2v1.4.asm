TITLE MASM Template						(main.asm)

; Description:
; 
; Revision date:

INCLUDE Irvine32.inc
.data

	;desenho da nave
	nv1 BYTE "     _     ", 0
	nv2 BYTE "    / \    ", 0 
	nv3 BYTE "  _|   |_  ", 0
	nv4 BYTE " /_______\ ", 0
	nv5 BYTE "  !*! !*!  ", 0

	T1 BYTE "*", 0     ;tiro da nave

	; ______ Variáveis explosão ____________
	E1 BYTE " \ / ", 0Dh, 0Ah, 0
	E2 BYTE "-   -", 0Dh, 0Ah, 0
	E3 BYTE " / \ ", 0Dh, 0Ah, 0

	; _______ Variáveis do inimigo _________

	IN1 BYTE "  !___!  ", 0Dh, 0Ah, 0
    IN2 BYTE " (_____) ", 0Dh, 0Ah, 0
    IN3 BYTE "   / \   ", 0Dh, 0Ah, 0

	; _________ Variáveis para linhas em comum _________
	PL BYTE " * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * ", 0Dh, 0Ah, 0  ;Primeira Linha
	EL BYTE " *                                                                 * ", 0Dh, 0Ah, 0  ;Linha de espaço
	
	; _________ Variáveis para  a tela inicial _________
	
	I1 BYTE " *        ", 0
	I2 BYTE "####   ########      ###         ########  ########", 0
	I3 BYTE "      * ", 0Dh, 0Ah, 0
	I4 BYTE " *       ", 0
	I5 BYTE "######  #########    #####       #########  ########", 0
	I6 BYTE "      * ", 0Dh, 0Ah, 0
	I7 BYTE " *      ", 0
	I8 BYTE "###  ##  ###   ###   #######      ####       ###", 0
	I9 BYTE "           * ", 0Dh, 0Ah, 0
	I10 BYTE " *     ", 0
	I11 BYTE "####      ###   ###  #########     ###        ###", 0
	I12 BYTE "           * ", 0Dh, 0Ah, 0
	I13 BYTE " *      ", 0
	I14 BYTE "####     ######### ####   ####    ##         ######", 0
	I15 BYTE "        * ", 0Dh, 0Ah, 0
	I16 BYTE " *       ", 0
	I17 BYTE "####    ########  ####   ####    ##         ######", 0
	I18 BYTE "        * ", 0Dh, 0Ah, 0
	I19 BYTE " *         ", 0
	I20 BYTE "###   ###      #############   ###        ###", 0
	I21 BYTE "           * ", 0Dh, 0Ah, 0
	I22 BYTE " *     ", 0
	I23 BYTE "##  ###   ###     ###############  ####       ###", 0
	I24 BYTE "           * ", 0Dh, 0Ah, 0
	I25 BYTE " *     ",0
	I26 BYTE "######    ###     #####     #####  #########  ########", 0
	I27 BYTE "      * ", 0Dh, 0Ah, 0
	I28 BYTE " *      ",0
	I29 BYTE "####     ###     #####     #####   ########  ########",0
	I30 BYTE "      * ", 0Dh, 0Ah, 0
	; até aqui SPACE
	I31 BYTE " *     ",0
	I32 BYTE"#  ##   # #       #   #     ######  ##### ######   ####",0
	I33 BYTE "     * ", 0Dh, 0Ah, 0
	I34 BYTE " *     ",0
	I35 BYTE "#  ###  # #       #  # #    #     # #     #    #  ##",0
	I36 BYTE "        * ", 0Dh, 0Ah, 0
	I37 BYTE " *     ",0
	I38 BYTE "#  # ## #  #     #  #   #   #     # ###   #####    #",0
	I39 BYTE "        * ", 0Dh, 0Ah, 0
	I40 BYTE " *     ",0
	I41 BYTE "#  #  ###   #   #  #######  #     # #     #  #      ##", 0
	I42 BYTE "      * ", 0Dh, 0Ah, 0
	I43 BYTE " *     ",0
	I44 BYTE "#  #   ##    ###  #       # ######  ##### #   #  #####",0
	I45 BYTE "      * ", 0Dh, 0Ah, 0
	; até aqui INVADERS
	I46 BYTE " *               ",0
	I47 BYTE "P R E S S I O N E   E N T E R",0
	I48 BYTE "                     * ", 0Dh, 0Ah, 0
	I49 BYTE " *   Jessica Caroline                                              * ", 0Dh, 0Ah, 0 
	I50 BYTE " *   Felipe Galeno                                                 * ", 0Dh, 0Ah, 0
	
	; _______ Variáveis para a tela de instruções ________
	
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

	; __________ Variáveis da tela Game Over ___________

	G1 BYTE " *    ",0
	G2 BYTE "#########         ###        #####       #####  ########",0
	G3 BYTE "     * ", 0Dh, 0Ah, 0
	G4 BYTE " *    ",0
	G5 BYTE"##########       #####       ######     ######  ########",0
	G6 BYTE "     * ", 0Dh, 0Ah, 0
	G7 BYTE " *    ",0
	G8 BYTE "###    ###      #######      ### ###   ### ###  ###",0
	G9 BYTE "          * ", 0Dh, 0Ah, 0
	G10 BYTE " *    ",0
	G11 BYTE "###            #########     ###  ### ###  ###  ###",0
	G12 BYTE "          * ", 0Dh, 0Ah, 0
	G13 BYTE " *    ",0
	G14 BYTE "###           ####   ####    ###   ####    ###  #####",0
	G15 BYTE "        * ", 0Dh, 0Ah, 0
	G16 BYTE " *    ",0
	G17 BYTE "###           ####   ####    ###    ##     ###  #####",0
	G18 BYTE "        * ", 0Dh, 0Ah, 0
	G19 BYTE " *    ",0 
	G62 BYTE"###   #####  #############   ###           ###  ###",0
	G20 BYTE "          * ", 0Dh, 0Ah, 0
	G21 BYTE " *    ",0
	G22 BYTE "###    ###  ###############  ###           ###  ###",0
	G23 BYTE "          * ", 0Dh, 0Ah, 0
	G24 BYTE " *    ",0
	G25 BYTE "##########  #####     #####  ###           ###  ########",0
	G26 BYTE "     * ", 0Dh, 0Ah, 0
	G27 BYTE " *    ",0
	G28 BYTE "##########  #####     #####  ###           ###  ########",0
	G29 BYTE "     * ", 0Dh, 0Ah, 0
	; até aqui GAME
	G30 BYTE " *       ",0
	G31 BYTE "##########  ###          ###  ########  #########",0
	G32 BYTE "         * ", 0Dh, 0Ah, 0
	G33 BYTE " *       ",0
	G34 BYTE "##########  ###          ###  ########  ##########",0
	G35 BYTE "        * ", 0Dh, 0Ah, 0
	G36 BYTE " *       ",0
	G37 BYTE "###    ###  ###          ###  ###       ###    ###",0
	G38 BYTE "        * ", 0Dh, 0Ah, 0
	G39 BYTE " *       ",0
	G40 BYTE "###    ###  ###          ###  ###       ###    ###",0
	G41 BYTE "        * ", 0Dh, 0Ah, 0
	G42 BYTE " *       ",0
	G43 BYTE "###    ###   ###        ###   #####     ##########",0
	G44 BYTE "        * ", 0Dh, 0Ah, 0
	G45 BYTE " *       ",0
	G46 BYTE "###    ###    ###      ###    #####     #########",0
	G47 BYTE "         * ", 0Dh, 0Ah, 0
	G48 BYTE " *       ",0 
	G49 BYTE "###    ###     ###    ###     ###       ### ###",0
	G50 BYTE "           * ", 0Dh, 0Ah, 0
	G51 BYTE " *       ",0
	G52 BYTE "###    ###      ###  ###      ###       ###  ###",0
	G53 BYTE "          * ", 0Dh, 0Ah, 0
	G54 BYTE " *       ",0
	G55 BYTE "##########       ######       ########  ###   ###",0
	G56 BYTE "         * ", 0Dh, 0Ah, 0
	G57 BYTE " *       ",0
	G58 BYTE "##########        ###         ########  ###    ###",0
	G59 BYTE "        * ", 0Dh, 0Ah, 0
	G60 BYTE " *                  PRESSIONE  1  PARA SAIR                        * ", 0Dh, 0Ah, 0
	G61 BYTE " *            PRESSIONE   2   PARA JOGAR NOVAMENTE                 * ", 0Dh, 0Ah, 0
	
	telaVida BYTE "VIDAS: ", 0
	telaPonto BYTE "  PONTOS: ", 0

;variaveis da nave
vida BYTE 39h, 0
naveX BYTE 19
naveY BYTE 23

;variaveis do tiro
tiroX BYTE 200 dup (0)		;vetor que contem a coordenada X do tiro[n]
tiroY BYTE 200 dup (0)		;vetor que contem a coordenada Y do tiro[n]
numTiros BYTE 0

;variaveis dos inimigos
inimigoX BYTE 50 dup (0)	;vetor que contem a coordenada X do inimigo[n] 
inimigoY BYTE 50 dup (0)	;vetor que contem a coordenada Y do inimigo[n]
numInimigos BYTE 0


;variaveis geral
dificuldade DWORD 20		;dificuldade do jogo, quanto menor, mais rapido fica
pontos DWORD 0
criacaoInimigo DWORD 70

;Tela do jogo
telaJogo BYTE 2000 dup (" ") ;25*80

.code
main PROC

	mov edx, OFFSET numTiros
	
	call intro
	call readInt
	call instrucao
	call readInt
	call ClrScr
	call refreshTela

	mov ecx, 0
	;começa o jogo
	jmp LoopJogo
aumDif:
	;deixa mais rapido a velocidade dos inimigos e a criação deles
	inc pontos
	mov dificuldade, 10
	mov criacaoInimigo, 40
	mov ecx, 0
	jmp LoopJogo
	
aumDifmais:
	;deixa mais rapido a velocidade dos inimigos e a criação deles
	inc pontos
	mov dificuldade, 5
	mov criacaoInimigo, 20
	mov ecx, 0
	jmp LoopJogo
LoopReset:
	;reseta as variaveis
	add vida, 9
	mov ecx, 0
	mov naveX, 19
	mov naveY, 23

	mov numTiros, 0
	mov numInimigos, 0
	mov dificuldade, 20
	mov pontos, 0
	call ClrScr
LoopJogo:
	;testa para ver se a vida chegou a 0
	cmp vida, 30h
		jna gameFim
	;testa para aumentar a dificuldade
	cmp pontos, 50
		je aumDif
	cmp pontos, 101
		je aumDifMais
	;seta a duração do delay
	mov eax, 41
	call delay
	;testa para ver se já deve criar um inimigo novo
	cmp ecx, criacaoInimigo
		jne naoCriaInimigo
	mov ecx, 0
	call criaInimigo
naoCriaInimigo:
	;lê a tecla
	call readkey
	jz nokey
	push eax
	push ecx
	call ReadKeyflush			;Limpa o buffer, ajuda na performance
	pop ecx
	pop eax
		cmp ah, 75				;Verifica quais teclas foram apertadas, pelo codigo em ax(retornado por ReadKey!)
			je SetaEsquerda
		cmp ah, 77
			je SetaDireita
		cmp ah, 57
			je BarraEspaco
		cmp ah, 01
			je escape
		jmp nokey

SetaEsquerda: 
	;nave vai uma posição para a esquerda se não estiver do lado da parede
	cmp naveY, 0
		je nokey
	dec naveY
	jmp nokey
SetaDireita:
	;nave vai uma posição para a direita se não estiver do lado da parede
	cmp naveY, 50
		je nokey
	inc naveY
	jmp nokey
BarraEspaco:
	;cria um novo tiro
	call novoTiro

nokey:
	;testa para ver se os inimigos devem se movimentar ou nao
	push ecx
	mov dx, 0
	mov ax, cx
	mov ecx, dificuldade
	div cx
	cmp dx, 0
		jne naoMexeInimigo
	call movimentoInimigos
naoMexeInimigo:
	;atualiza a tela
	call refreshTela
	pop ecx
	inc ecx

	jmp LoopJogo

gameFim:
	call ClrScr
	call gameOver
	call readInt
	;eax=1 para sair do jogo
	cmp eax, 1
		je escape
	jmp LoopReset
	
escape:

exit
main ENDP

; ===================================
; IMAGEM TELA INICIAL 

intro PROC

	call ClrScr

	mov ax, white
	call SetTextColor
	mov edx, OFFSET PL
	call writeString
	mov edx, OFFSET EL
	call writeString
	mov edx, OFFSET I1
	call writeString

	mov ax, lightBlue
	call SetTextColor
	mov edx, OFFSET I2
	call writeString

	mov ax, white
	call SetTextColor
	mov edx, OFFSET I3
	call writeString
	mov edx, OFFSET I4
	call writeString

	mov ax, lightBlue
	call SetTextColor
	mov edx, OFFSET I5
	call writeString

	mov ax, white
	call SetTextColor
	mov edx, OFFSET I6
	call writeString
	mov edx, OFFSET I7
	call writeString

	mov ax, lightBlue
	call SetTextColor
	mov edx, OFFSET I8
	call writeString

	mov ax, white
	call SetTextColor
	mov edx, OFFSET I9
	call writeString
	mov edx, OFFSET I10
	call writeString
	
	mov ax, lightBlue
	call SetTextColor
	mov edx, OFFSET I11
	call writeString

	mov ax, white
	call SetTextColor
	mov edx, OFFSET I12
	call writeString
	mov edx, OFFSET I13
	call writeString

	mov ax, lightBlue
	call SetTextColor
	mov edx, OFFSET I14
	call writeString

	mov ax, white
	call SetTextColor
	mov edx, OFFSET I15
	call writeString
	mov edx, OFFSET I16
	call writeString
	
	mov ax, lightBlue
	call SetTextColor
	mov edx, OFFSET I17
	call writeString
	
	mov ax, white
	call SetTextColor
	mov edx, OFFSET I18
	call writeString
	mov edx, OFFSET I19
	call writeString

	mov ax, lightBlue
	call SetTextColor
	mov edx, OFFSET I20
	call writeString

	mov ax, white
	call SetTextColor
	mov edx, OFFSET I21
	call writeString
	mov edx, OFFSET I22
	call writeString

	mov ax, lightBlue
	call SetTextColor
	mov edx, OFFSET I23
	call writeString

	mov ax, white
	call SetTextColor
	mov edx, OFFSET I24
	call writeString
	mov edx, OFFSET I25
	call writeString

	mov ax, lightBlue
	call SetTextColor
	mov edx, OFFSET I26
	call writeString

	mov ax, white
	call SetTextColor
	mov edx, OFFSET I27
	call writeString
	mov edx, OFFSET I28
	call writeString

	mov ax, lightBlue
	call SetTextColor
	mov edx, OFFSET I29
	call writeString

	mov ax, white
	call SetTextColor
	mov edx, OFFSET I30
	call writeString
	mov edx, OFFSET EL
	call writeString
	mov edx, OFFSET I31
	call writeString

	mov ax, blue
	call SetTextColor
	mov edx, OFFSET I32
	call writeString

	mov ax, white
	call SetTextColor
	mov edx, OFFSET I33
	call writeString
	mov edx, OFFSET I34
	call writeString

	mov ax, blue
	call SetTextColor
	mov edx, OFFSET I35
	call writeString

	mov ax, white
	call SetTextColor
	mov edx, OFFSET I36
	call writeString
	mov edx, OFFSET I37
	call writeString

	mov ax, blue
	call SetTextColor
	mov edx, OFFSET I38
	call writeString

	mov ax, white
	call SetTextColor
	mov edx, OFFSET I39
	call writeString
	mov edx, OFFSET I40
	call writeString
	
	mov ax, blue
	call SetTextColor
	mov edx, OFFSET I41
	call writeString

	mov ax, white
	call SetTextColor
	mov edx, OFFSET I42
	call writeString
	mov edx, OFFSET I43
	call writeString

	mov ax, blue
	call SetTextColor
	mov edx, OFFSET I44
	call writeString

	mov ax, white
	call SetTextColor
	mov edx, OFFSET I45
	call writeString
	mov edx, OFFSET EL
	call writeString
	mov edx, OFFSET EL
	call writeString
	mov edx, OFFSET EL
	call writeString
	mov edx, OFFSET I46
	call writeString
	mov edx, OFFSET I47
	call writeString
	mov edx, OFFSET I48
	call writeString
	mov edx, OFFSET EL
	call writeString
	mov edx, OFFSET EL
	call writeString
	mov edx, OFFSET EL
	call writeString
	mov edx, OFFSET EL
	call writeString
	mov edx, OFFSET I49
	call writeString
	mov edx, OFFSET I50
	call writeString
	mov edx, OFFSET EL
	call writeString
	mov edx, OFFSET PL
	call writeString

	ret
intro ENDP

; ===================================
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

; ===================================
; IMAGEM TELA GAMEOVER 

gameOver PROC

	mov ax, white
	call SetTextColor
	mov edx, OFFSET PL
	call writeString
	mov edx, OFFSET EL
	call writeString
	mov edx, OFFSET EL
	call writeString
	mov edx, OFFSET EL
	call writeString
	mov edx, OFFSET G1
	call writeString

	mov ax, lightblue
	call SetTextColor
	mov edx, OFFSET G2
	call writeString

	mov ax, white
	call SetTextColor
	mov edx, OFFSET G3
	call writeString
	mov edx, OFFSET G4
	call writeString

	mov ax, lightblue
	call SetTextColor
	mov edx, OFFSET G5
	call writeString

	mov ax, white
	call SetTextColor
	mov edx, OFFSET G6
	call writeString
	mov edx, OFFSET G7
	call writeString

	mov ax, lightblue
	call SetTextColor
	mov edx, OFFSET G8
	call writeString

	mov ax, white
	call SetTextColor
	mov edx, OFFSET G9
	call writeString
	mov edx, OFFSET G10
	call writeString

	mov ax, lightblue
	call SetTextColor
	mov edx, OFFSET G11
	call writeString

	mov ax, white
	call SetTextColor
	mov edx, OFFSET G12
	call writeString
	mov edx, OFFSET G13
	call writeString

	mov ax, lightblue
	call SetTextColor
	mov edx, OFFSET G14
	call writeString

	mov ax, white
	call SetTextColor
	mov edx, OFFSET G15
	call writeString
	mov edx, OFFSET G16
	call writeString

	mov ax, lightblue
	call SetTextColor
	mov edx, OFFSET G17
	call writeString

	mov ax, white
	call SetTextColor
	mov edx, OFFSET G18
	call writeString
	mov edx, OFFSET G19
	call writeString

	mov ax, lightblue
	call SetTextColor
	mov edx, OFFSET G62
	call writeString
	
	mov ax, white
	call SetTextColor
	mov edx, OFFSET G20
	call writeString
	mov edx, OFFSET G21
	call writeString

	mov ax, lightblue
	call SetTextColor
	mov edx, OFFSET G22
	call writeString
	
	mov ax, white
	call SetTextColor
	mov edx, OFFSET G23
	call writeString
	mov edx, OFFSET G24
	call writeString

	mov ax, lightblue
	call SetTextColor
	mov edx, OFFSET G25
	call writeString
	
	mov ax, white
	call SetTextColor
	mov edx, OFFSET G26
	call writeString
	mov edx, OFFSET G27
	call writeString

	mov ax, lightblue
	call SetTextColor
	mov edx, OFFSET G28
	call writeString
	
	mov ax, white
	call SetTextColor
	mov edx, OFFSET G29
	call writeString
	mov edx, OFFSET EL
	call writeString
	mov edx, OFFSET EL
	call writeString
	mov edx, OFFSET EL
	call writeString
	mov edx, OFFSET G30
	call writeString

	mov ax, blue
	call SetTextColor
	mov edx, OFFSET G31
	call writeString
	
	mov ax, white
	call SetTextColor
	mov edx, OFFSET G32
	call writeString
	mov edx, OFFSET G33
	call writeString

	mov ax, blue
	call SetTextColor
	mov edx, OFFSET G34
	call writeString

	mov ax, white
	call SetTextColor
	mov edx, OFFSET G35
	call writeString
	mov edx, OFFSET G36
	call writeString

	mov ax, blue
	call SetTextColor
	mov edx, OFFSET G37
	call writeString

	mov ax, white
	call SetTextColor
	mov edx, OFFSET G38
	call writeString
	mov edx, OFFSET G39
	call writeString

	mov ax, blue
	call SetTextColor
	mov edx, OFFSET G40
	call writeString

	mov ax, white
	call SetTextColor
	mov edx, OFFSET G41
	call writeString
	mov edx, OFFSET G42
	call writeString

	mov ax, blue
	call SetTextColor
	mov edx, OFFSET G43
	call writeString

	mov ax, white
	call SetTextColor
	mov edx, OFFSET G44
	call writeString
	mov edx, OFFSET G45
	call writeString

	mov ax, blue
	call SetTextColor
	mov edx, OFFSET G46
	call writeString

	mov ax, white
	call SetTextColor
	mov edx, OFFSET G47
	call writeString
	mov edx, OFFSET G48
	call writeString

	mov ax, blue
	call SetTextColor
	mov edx, OFFSET G49
	call writeString

	mov ax, white
	call SetTextColor
	mov edx, OFFSET G50
	call writeString
	mov edx, OFFSET G51
	call writeString

	mov ax, blue
	call SetTextColor
	mov edx, OFFSET G52
	call writeString

	mov ax, white
	call SetTextColor
	mov edx, OFFSET G53
	call writeString
	mov edx, OFFSET G54
	call writeString

	mov ax, blue
	call SetTextColor
	mov edx, OFFSET G55
	call writeString

	mov ax, white
	call SetTextColor
	mov edx, OFFSET G56
	call writeString
	mov edx, OFFSET G57
	call writeString

	mov ax, blue
	call SetTextColor
	mov edx, OFFSET G58
	call writeString

	mov ax, white
	call SetTextColor
	mov edx, OFFSET G59
	call writeString
	mov edx, OFFSET EL
	call writeString
	mov edx, OFFSET EL
	call writeString
	mov edx, OFFSET EL
	call writeString
	mov edx, OFFSET EL
	call writeString
	mov edx, OFFSET G60
	call writeString
	mov edx, OFFSET EL
	call writeString
	mov edx, OFFSET EL
	call writeString
	mov edx, OFFSET G61
	call writeString
	mov edx, OFFSET EL
	call writeString
	mov edx, OFFSET EL
	call writeString
	mov edx, OFFSET EL
	call writeString
	mov edx, OFFSET PL
	call writeString

	ret
gameOver ENDP

;==================================

desenhaInimigo PROC
	;desenha todos os inimigos nas posições atuais
	movzx ecx, numInimigos
	cmp ecx, 0
	je fim
	mov esi, 0
L1:
	movzx eax, inimigoX[esi]
	mov ebx, 80
	mul ebx
	movzx ebx, inimigoY[esi]
	add eax, ebx

	inc esi
	push esi
	
	mov esi,0
L2:

	mov bl, IN1[esi]
	
	mov telaJogo[eax], bl

	inc esi
	inc eax
	cmp esi, 9
	jne L2

	add eax, 71
	mov esi, 0
L3:

	mov bl, IN2[esi]
	
	mov telaJogo[eax], bl
	inc esi
	inc eax
	cmp esi, 9
	jne L3

	add eax, 71
	mov esi, 0
L4:
	mov bl, IN3[esi]
	
	mov telaJogo[eax], bl
	inc esi
	inc eax
	cmp esi, 9
	jne L4

printa:

	pop esi
	loop L1

fim:
	ret

desenhaInimigo ENDP

;==================================

desenhaNave PROC
	;desenha a nave na posição atual
	movzx eax, naveX
	mov ebx, 80
	mul ebx
	movzx ebx, naveY
	add eax, ebx
	mov ebx, 0

	mov esi, 0
	mov ecx, 11
L1:
	mov bl, nv1[esi]
	mov bh, nv2[esi]
	mov dl, nv3[esi]
	mov dh, nv4[esi]
	mov telaJogo[eax], bl
	push eax
	add eax, 80
	mov telaJogo[eax], bh
	add eax, 80
	mov telaJogo[eax], dl
	add eax, 80
	mov telaJogo[eax], dh
	
	mov bl, nv5[esi]
	add eax, 80
	mov telaJogo[eax], bl

	pop eax
	inc esi
	inc eax
	loop L1
	
	ret

desenhaNave ENDP

;=================================

desenhaTiros PROC
	;desenha todos os tiros
	movzx ecx, numTiros	
	cmp ecx, 0
	je fim
	mov esi, 0

L1:
	movzx eax, tiroX[esi]
	cmp eax, 0
		jna naoMostra
	mov ebx, 80
	mul ebx
	movzx ebx, tiroY[esi]
	add eax, ebx

	mov bl, T1

	mov telaJogo[eax], bl
	mov ebx, eax
	add ebx, 80
	mov telaJogo[ebx], " "
naoMostra:
	inc esi
 
	loop L1
fim:	

	ret

desenhaTiros ENDP

;=================================

movimentosTiro PROC

	mov esi, 0
	movzx ecx, numTiros
	cmp ecx, 0
		je fim
sobeTiros:
	;testa parar ver se já chegou no topo da tela
	cmp tiroX[esi], 0
		jne naoApagaTiro
	;chegou no topo
	movzx eax, numTiros
	dec eax
	;testa se o tiro que vai ser apagado é o unico tiro da tela ou nao
	cmp esi, eax
		je diminuiNumTiro
	mov bl, tiroX[eax]
	mov bh, tiroY[eax]
	mov tiroX[esi], bl
	mov tiroY[esi], bh

diminuiNumTiro:
	dec numTiros

naoApagaTiro:
	dec tiroX[esi]

	inc esi
	loop sobeTiros

fim:
	ret
	
movimentosTiro ENDP

;===========================================

novoTiro PROC
	;cria um novo tiro no lugar que a nave está
	movzx ebx, numTiros

	mov al, naveX
	inc al

	mov tiroX[ebx], al

	mov al, naveY
	add al, 5

	mov tiroY[ebx], al

	inc ebx

	mov numTiros, bl
	

	ret

novoTiro ENDP

;=======================================

limpaTela PROC
	mov ecx, 2000
	mov esi, 0
L1:
	mov telaJogo[esi], " "
	inc esi
	loop L1

	ret

limpaTela ENDP

;=========================================

desenhaMoldura PROC

	mov ecx, 61
	mov esi, 0
L1:
	mov telaJogo[esi], "="
	inc esi
	loop L1
	mov esi, 80
	mov ecx, 24
L2:
	mov telaJogo[esi], "="
	add esi, 60
	mov telaJogo[esi], "="
	add esi, 20
	loop L2
	mov ecx, 60
	mov esi, 1920
L3:
	mov telaJogo[esi], "="
	inc esi
	loop L3


	ret

desenhaMoldura ENDP

;====================================

refreshTela PROC
	mov edx, 0
	call gotoXY
	
	call limpaTela
	;atualiza a tela
	call testaColisao
	call movimentosTiro
	call desenhaTiros
	call desenhaNave
	call desenhaInimigo
	call desenhaMoldura

	mov edx, OFFSET telaJogo
	call WriteString

	;placar e numero de vidas restantes
	mov edx, OFFSET telaVida
	call WriteString
	mov edx, OFFSET vida
	call WriteString

	mov edx, OFFSET telaPonto
	call WriteString
	mov eax, pontos
	call writeDec


	ret

refreshTela ENDP

;===============================================

criaInimigo PROC
	
	call Randomize
	mov  eax, 50     ;get random 0 to 50
    call RandomRange ;
    inc  eax         ;make range 1 to 51

	movzx esi, numInimigos

	mov inimigoX[esi], 0
	;coloca em uma posicao aleatória da tela
	mov inimigoY[esi], al

	inc numInimigos
	ret

criaInimigo ENDP

;=======================================

movimentoInimigos PROC
	mov esi, 0
	movzx ecx, numInimigos
	cmp ecx, 0
		je fim
descendo:
	;testa e ve se já chegou no fim da tela
	cmp inimigoX[esi], 25
		je naoMoveInimigo
	;nao chegou no fim da tela
	inc inimigoX[esi]
naoMoveInimigo:
	inc esi
	loop descendo

fim:
	ret

movimentoInimigos ENDP

;===========================================

testaColisao PROC

;teste parar ver se bateu no fim da tela
	movzx ecx, numInimigos
	cmp ecx, 0
		je fim
	mov esi, 0
L1:
	cmp inimigoX[esi], 22
		jne proxInimigo
		;inimigo chegou no fim da tela
	movzx edx, numInimigos
	mov al, inimigoX[edx-1]
	mov ah, inimigoY[edx-1]

	mov inimigoX[esi], al
	mov inimigoY[esi], ah
	dec numInimigos

	dec vida
proxInimigo:
	inc esi
	loop L1

;fim teste1
;teste para ver se bateu na nave
	movzx ecx, numInimigos
	mov esi, 0
L2:
	cmp inimigoX[esi], 18
		jb proxInimigo2
	mov al, naveY
	sub al, 5
	cmp inimigoY[esi], al
		jb proxInimigo2
	add al, 11
	cmp inimigoY[esi], al
		ja proxInimigo2
		;houve colisão entre nave e inimigo
	movzx edx, numInimigos
	mov al, inimigoX[edx-1]
	mov ah, inimigoY[edx-1]

	mov inimigoX[esi], al
	mov inimigoY[esi], ah
	dec numInimigos

	dec vida

proxInimigo2:
	inc esi
	loop L2

;fim teste3
;teste para ver se o tiro acertou algum inimigo

	movzx ecx, numTiros
	cmp ecx, 0
		je fim
			

L3:
	push ecx

	mov esi, ecx
	dec esi

	movzx ecx, numInimigos
	L4:
		mov al, inimigoX[ecx-1]
		cmp tiroX[esi], al
			jb proxInimigo3
		add al, 3
		cmp tiroX[esi], al
			ja proxInimigo3

		mov al, inimigoY[ecx-1]
		cmp tiroY[esi], al
			jb proxInimigo3
		
		add al,9
		cmp tiroY[esi], al
			ja proxInimigo3
		;houve colisao entre o tiro e o inimigo
		jmp colisao
		
	proxInimigo3:
		loop L4
	pop ecx
	loop L3
	jmp fim

colisao:
	;apagar inimigo
	movzx edx, numInimigos
	mov al, inimigoX[edx-1]
	mov ah, inimigoY[edx-1]
	mov inimigoX[ecx-1], al
	mov inimigoY[ecx-1], ah
	dec numInimigos
	;apagar tiro
	movzx edx, numTiros
	dec edx
	cmp edx, esi
		je decNumTiros
	mov al, tiroX[edx]
	mov ah, tiroY[edx]
	mov tiroX[esi], al
	mov tiroY[esi], ah
decNumTiros:
	dec numTiros
		;aumenta os pontos
	add pontos, 10
	jmp proxInimigo3
fim:
	ret

testaColisao ENDP

END main