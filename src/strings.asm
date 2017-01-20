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



stringTest:
	STRING "Test"
stringTestEnd:
