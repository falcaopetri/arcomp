INCLUDE game.asm


.code
main PROC
	;int 3	
	call game_setup
	call ClearBuffer
	
	;call intro
	call desenhaIntro
	call game_print
	call readInt ; esperar enter
	call instrucao
	call readInt ; esperar enter


	call ClrScr
	call game_loop

	invoke ExitProcess, 0
main ENDP

END main