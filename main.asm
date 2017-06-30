INCLUDE game.asm


.code
main PROC
	;int 3	
	call intro
	call readInt ; esperar enter
	call instrucao
	call readInt ; esperar enter

	call game_setup
	call ClrScr
	call game_loop

	invoke ExitProcess, 0
main ENDP

END main