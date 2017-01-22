INCLUDE "macros.asm"

STRING: MACRO
.start\@:
	DB \1
.end\@:

	IF ((.end\@ - .start\@) % LineLength) > 0

	REPT (18 - ((.end\@ - .start\@) % LineLength))
	DB 32 ; Pad with spaces
	ENDR

	ENDC
	ENDM



stringWon:
	STRING "You won! Time to  move on to the    next challenge!"
stringWonEnd:
stringLost:
	STRING "You and your bloodline lost. Better luck next time... Oh wait."
stringLostEnd:
