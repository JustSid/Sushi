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

SwapAxis: MACRO
	ld a, [\1]
	cp a, 0
	jr nz, .set0\@

	ld a, 4
	jr .end\@

.set0\@:
	ld a, 0
.end\@
	ld [\1], a
ENDM

handleControls:
	push af

	; Input Left
	ld a, [Input_Once]
	bit 1, a
	jr z, .inputRight
	ld a, [CursorX]
	jpCorner .swapInputLeft

	dec a
	ld [CursorX], a
	jr nz, .inputRight

	ld a, [CursorY]
	cp a, 0

	; When reaching a corner, roll over into the Y direction
	RollOverCorner CursorX, CursorY
	jr .inputRight

.swapInputLeft:
	SwapAxis CursorX



	; Input Right
.inputRight:
	ld a, [Input_Once]
	bit 0, a
	jr z, .inputUp
	ld a, [CursorX]
	jpCorner .swapInputRight

	inc a
	ld [CursorX], a
	cp a, 4
	jr nz, .inputUp

	; When reaching a corner, roll over into the Y direction
	RollOverCorner CursorX, CursorY
	jr .inputUp

.swapInputRight:
	SwapAxis CursorX



	; Input Up
.inputUp:
	ld a, [Input_Once]
	bit 2, a
	jr z, .inputDown
	ld a, [CursorY]
	jpCorner .swapInputUp

	dec a
	ld [CursorY], a
	jr nz, .inputDown

	RollOverCorner CursorY, CursorX
	jr .inputDown

.swapInputUp:
	SwapAxis CursorY



	; Input Down
.inputDown:
	ld a, [Input_Once]
	bit 3, a
	jr z, .end
	ld a, [CursorY]
	jpCorner .swapInputDown

	inc a
	ld [CursorY], a
	cp a, 4
	jr nz, .end

	RollOverCorner CursorY, CursorX
	jr .end

.swapInputDown:
	SwapAxis CursorY

.end:

	pop af
	ret

ENDC

