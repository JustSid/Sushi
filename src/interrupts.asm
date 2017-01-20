INCLUDE "gbhw.inc"

; Interrupts
SECTION	"Vblank",HOME[$0040]
	jp vblankHandler

SECTION	"LCDC",HOME[$0048]
	reti

SECTION	"Timer_Overflow",HOME[$0050]
	reti

SECTION	"Serial",HOME[$0058]
	reti

SECTION	"p1thru4",HOME[$0060]
	reti


vblankHandler:
	push af
	call OAMFunction

	ld a, [UIActive] ; Check if the UI is visible
	or a
	jr z, .exit

	push bc
	push de
	push hl

	call updateUI

	pop bc
	pop de
	pop hl

.exit:
	pop af

	reti
