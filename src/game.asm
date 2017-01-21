IF !DEF(__GAME_ASM__)
__GAME_ASM__ SET 1

updateGame:

	call handleControls
	call updateControlTiles

	ret


updateControlTiles:
	ld a, [CursorPreviousX]
	and %11111011
	jr nz, .skipLeftRightBorder
	ld a, [CursorPreviousY]
	dec a ; change from 1-3 to 0 to 2 range

	; a = a*6+2 to get to the top center of the row
	ld b, a
	add b
	add b
	add a
	add 2

	; store y coordinate in hl register
	ld l, a
	ld h, 0

	; shift hl five times to the left (*32) -> (y tile index) * 32 tiles per line
	shiftLeft h, l
	shiftLeft h, l
	shiftLeft h, l
	shiftLeft h, l
	shiftLeft h, l

	ld a, [CursorPreviousX]
	cp 0
	jr nz, .skipRightBorder
	ld b, 0
	ld c, 19
	add hl, bc
.skipRightBorder

	ld bc, _SCRN0
	add hl, bc
	ld [hl], 0

	jr .endReset
.skipLeftRightBorder

	ld a, [CursorPreviousY]
	and %11111011
	jr nz, .skipTopBottomBorder
	ld a, [CursorPreviousX]
	dec a ; change from 1-3 to 0 to 2 range

	; a = a*6+2 to get to the top center of the row
	ld b, a
	add b
	add b
	add a
	add 2

	; store y coordinate in hl register
	ld l, a
	ld h, 0

	ld a, [CursorPreviousY]
	cp 0
	jr nz, .skipBottomBorder
	ld b, 2
	ld c, 32
	add hl, bc
.skipBottomBorder

	ld bc, _SCRN0
	add hl, bc
	ld [hl], 0
.skipTopBottomBorder
.endReset



	ld a, [CursorX]
	and %11111011
	jr nz, .skipLeftRightBorderWrite
	ld a, [CursorY]
	dec a ; change from 1-3 to 0 to 2 range

	; a = a*6+2 to get to the top center of the row
	ld b, a
	add b
	add b
	add a
	add 2

	; store y coordinate in hl register
	ld l, a
	ld h, 0

	; shift hl five times to the left (*32) -> (y tile index) * 32 tiles per line
	shiftLeft h, l
	shiftLeft h, l
	shiftLeft h, l
	shiftLeft h, l
	shiftLeft h, l

	ld d, 1
	ld a, [CursorX]
	cp 0
	jr nz, .skipRightBorderWrite
	ld d, 2
	ld b, 0
	ld c, 19
	add hl, bc
.skipRightBorderWrite

	ld bc, _SCRN0
	add hl, bc
	ld [hl], d

	jr .end
.skipLeftRightBorderWrite

	ld a, [CursorY]
	and %11111011
	jr nz, .skipTopBottomBorderWrite
	ld a, [CursorX]
	dec a ; change from 1-3 to 0 to 2 range

	; a = a*6+2 to get to the top center of the row
	ld b, a
	add b
	add b
	add a
	add 2

	; store y coordinate in hl register
	ld l, a
	ld h, 0

	ld d, 3
	ld a, [CursorY]
	cp 0
	jr nz, .skipBottomBorderWrite
	ld d, 4
	ld b, 2
	ld c, 32
	add hl, bc
.skipBottomBorderWrite

	ld bc, _SCRN0
	add hl, bc
	ld [hl], d
.skipTopBottomBorderWrite
.end
	ret

; Loads a level
; hl = level address
loadLevel:

	; Copy the level data into RAM
	push hl

	ld de, LevelData
	ld c, 9 * 9
	call memcpy_quick

	pop hl

	call updateLevel
	ret



PlaceFish: MACRO
	ld a, \1
	ld [de], a
	inc de

	ld a, 0
	ld [de], a
	inc de
ENDM

; Update the sprites to match the level data
updateLevel:
	ld hl, LevelData

	ld de, OAMBuffer

	ld b, 9 * 9
	ld c, 8 ; Current tile X

	; Zero out the scratch value since it's used to keep track of the current Y tile
	ld a, 16
	ld [__Scratch], a

.loop:
	ld a, [hl+]

	cp a, 0
	jr z, .loopCompare ; No fish, no problem!

	push af

	; Prepare the common sprite attributes (X and Y position)
	; Y Position
	ld a, [__Scratch]
	ld [de], a
	inc de

	; X Position
	ld a, c
	ld [de], a
	inc de

	pop af

	; Check for Fish Level 1
	cp a, 1
	jr nz, .skipFish1

	; Fish Level 1
	PlaceFish $10
	jr .loopCompare

.skipFish1:
	; Check for Fish Level 2
	cp a, 2
	jr nz, .skipFish2

	; Fish Level 1
	PlaceFish $11
	jr .loopCompare

.skipFish2:
	; Check for Fish Level 3
	cp a, 3
	jr nz, .skipFish3

	; Fish Level 1
	PlaceFish $12
	jr .loopCompare

.skipFish3
	PlaceFish $13 ; Player

.loopCompare:
	ld a, c
	add a, 16
	ld c, a

	cp a, 152
	jr nz, .notFullLine

	ld c, 8

	ld a, [__Scratch]
	add a, 16
	ld [__Scratch], a

.notFullLine:
	dec b
	jr nz, .loop

	ret


testLevel:
	;         |          |
	db 0, 0, 0,   0, 0, 0,   0, 0, 0
	db 0, 0, 0,   0, 0, 0,   0, 0, 0
	db 0, 0, 0,   2, 0, 0,   0, 0, 0 ; ----

	db 0, 0, 0,   0, 0, 0,   0, 3, 0
	db 0, 0, 0,   0, 2, 1,   0, 0, 0
	db 0, 0, 0,   0, 0, 0,   0, 0, 0 ; ----

	db 0, 0, 1,   0, 0, 0,   0, 0, 0
	db 0, 0, 0,   0, 0, 0,   0, 0, 0
	db 0, 0, 0,   0, 0, 0,   0, 0, 0

ENDC
