IF !DEF(__CONTROLS_ASM__)
__CONTROLS_ASM__ SET 1

handleControls:
	push af

	ld a, [CursorX]
	ld [CursorPreviousX], a
	ld a, [CursorY]
	ld [CursorPreviousY], a
	ld b, a

	ld a, [Input_Once]
	bit 1, a
	jr z, .skipLeft
	ld a, [CursorX]
	cp 0
	jr z, .skipLeft
	dec a
	ld [CursorX], a
	ld a, b
	and %11111011
	jr z, .skipLeft
	ld a, 0
	ld [CursorX], a
.skipLeft:

	ld a, [Input_Once]
	bit 0, a
	jr z, .skipRight
	ld a, [CursorX]
	cp 4
	jr z, .skipRight
	inc a
	ld [CursorX], a
	ld a, b
	and %11111011
	jr z, .skipRight
	ld a, 4
	ld [CursorX], a
.skipRight:

	ld a, [CursorX]
	ld b, a

	ld a, [Input_Once]
	bit 2, a
	jr z, .skipUp
	ld a, [CursorY]
	cp 0
	jr z, .skipUp
	dec a
	ld [CursorY], a
	ld a, b
	and %11111011
	jr z, .skipUp
	ld a, 0
	ld [CursorY], a
.skipUp:

	ld a, [Input_Once]
	bit 3, a
	jr z, .skipDown
	ld a, [CursorY]
	cp 4
	jr z, .skipDown
	inc a
	ld [CursorY], a
	ld a, b
	and %11111011
	jr z, .skipDown
	ld a, 4
	ld [CursorY], a
.skipDown:

	pop af
	ret

ENDC

