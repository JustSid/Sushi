IF !DEF(__CONTROLS_ASM__)
__CONTROLS_ASM__ SET 1

RollOverCorner: MACRO
	ld a, [\2]
	cp a, 0
	jr z, .rollOverDown\@

	ld a, 3
	ld [\2], a
	jr .end\@

.rollOverDown\@:
	ld a, 1
	ld [\2], a
.end\@
ENDM

jpCorner: MACRO
	cp a, 0
	jr z, \1
	cp a, 4
	jr z, \1
ENDM

handleControls:
	push af

	; Input Left
	ld a, [Input_Once]
	bit 1, a
	jr z, .inputRight
	ld a, [CursorX]
	jpCorner .inputRight

	dec a
	ld [CursorX], a
	jr nz, .inputRight

	ld a, [CursorY]
	cp a, 0

	; When reaching a corner, roll over into the Y direction
	RollOverCorner CursorX, CursorY

	; Input Right
.inputRight:
	ld a, [Input_Once]
	bit 0, a
	jr z, .inputUp
	ld a, [CursorX]
	jpCorner .inputUp

	inc a
	ld [CursorX], a
	cp a, 4
	jr nz, .inputUp

	; When reaching a corner, roll over into the Y direction
	RollOverCorner CursorX, CursorY

	; Input Up
.inputUp:
	ld a, [Input_Once]
	bit 2, a
	jr z, .inputDown
	ld a, [CursorY]
	jpCorner .inputDown

	dec a
	ld [CursorY], a
	jr nz, .inputDown


	RollOverCorner CursorY, CursorX

	; Input Down
.inputDown:
	ld a, [Input_Once]
	bit 3, a
	jr z, .end
	ld a, [CursorY]
	jpCorner .end

	inc a
	ld [CursorY], a
	cp a, 4
	jr nz, .end

	RollOverCorner CursorY, CursorX

.end:

	pop af
	ret

ENDC

