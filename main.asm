INCLUDE game.asm


.code
main PROC
	;int 3	

	call game_setup
	call game_loop

	invoke ExitProcess, 0
main ENDP

END main