INCLUDE "gbhw.inc"

; Interrupts
SECTION	"Vblank",HOME[$0040]
	jp vblankHandler

SECTION	"LCDC",HOME[$0048]
	reti

SECTION	"Timer_Overflow",HOME[$0050]
	jp timeHandler

SECTION	"Serial",HOME[$0058]
	reti

SECTION	"p1thru4",HOME[$0060]
	reti


vblankHandler:
	push af
	call OAMFunction

	push bc
	push de
	push hl

	call blitBackbuffer

	ld a, [UIActive] ; Check if the UI is visible
	or a
	call nz, updateUI

	pop hl
	pop de
	pop bc
	pop af

	reti

blitBackbuffer:
	ld hl, Backbuffer
	ld de, _SCRN0

	ld a, 0
	ld [BlitRowLength + 0], a
	ld a, 20
	ld [BlitRowLength + 1], a

	ld c, 20
	ld b, 18

	call blit

	ret


timeHandler:
	push af
	push bc
	push de
	push hl



.exit:
	pop hl
	pop de
	pop bc
	pop af

	reti
