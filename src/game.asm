IF !DEF(__GAME_ASM__)
__GAME_ASM__ SET 1

INCLUDE "controls.asm"

updateGame:

	ld a, [WaveType]
	cp 0
	call z, handleControls
	call updateControlTiles
	call updateWave

	ld a, [WaveType]
	cp 0
	jr nz, .end
	ld a, [Input_Once]
	bit 4, a
	jr z, .end

	ld a, [CursorX]
	jpCorner .horizontalWave

.verticalWave:
	jr .end

.horizontalWave:
	or a
	jr nz, .left

	call z, sendWaveRight
	jr .end

.left:
	call sendWaveLeft
	jr .end

.end:
	call updateLevel
	ret



sendWaveRight:
	; Calculate the offset into LevelData
	ld hl, LevelData + 8

	ld a, 1
	ld [WaveType], a
	ld a, 0
	ld [WaveX], a

	ld a, [CursorY]
	dec a
	ld [WaveY], a

	jr z, .loopEnd
	ld bc, 27

.loop:
	dec a
	add hl, bc
	jr nz, .loop
.loopEnd:

	ld a, 3

.copyRowLoop:
	push af

	; Go over the columns
	ld b, 9

.loopColumn:
	ld a, [hl]
	or a
	jr z, .fishEnd ; No fish in that column

	ld d, b
	push bc

	; Remove the fish from the position
	ld b, a
	ld a, 0
	ld [hl], a
	ld a, b

	push hl
	push af

	; Calculate how far the fish has to move
	ld b, a
	ld a, 4
	sub b

	ld b, a
	push bc

	ld b, 0
	ld c, a
	add hl, bc

	pop bc

	ld a, d
	add b

	cp a, 10
	jr nc, .fishOverflow

	pop af

	ld [hl], a ; Put the fish into its new position

	pop hl
	pop bc

.fishEnd:
	dec hl
	dec b
	jr nz, .loopColumn

	add16_8 h, l, 18

	pop af
	dec a
	jr nz, .copyRowLoop
	jr .exit

.fishOverflow:
	pop af
	pop hl
	pop bc

	jr .fishEnd

.exit:
	ret


sendWaveLeft:
	; Calculate the offset into LevelData
	ld hl, LevelData

	ld a, 2
	ld [WaveType], a
	ld a, 17
	ld [WaveX], a

	ld a, [CursorY]
	dec a
	ld [WaveY], a

	jr z, .loopEnd
	ld bc, 27

.loop:
	dec a
	add hl, bc
	jr nz, .loop
.loopEnd:

	ld a, 3

.copyRowLoop:
	push af

	; Go over the columns
	ld b, 9

.loopColumn:
	ld a, [hl]
	or a
	jr z, .fishEnd ; No fish in that column

	ld d, b
	push bc

	; Remove the fish from the position
	ld b, a
	ld a, 0
	ld [hl], a
	ld a, b

	push hl
	push af

	; Calculate how far the fish has to move
	ld b, a
	ld a, 4
	sub b

	ld b, a
	push bc

	ld b, a
	sub16_8 h, l, b

	pop bc

	ld a, d
	add b

	cp a, 10
	jr nc, .fishOverflow

	pop af

	ld [hl], a ; Put the fish into its new position

	pop hl
	pop bc

.fishEnd:
	inc hl
	dec b
	jr nz, .loopColumn

	pop af
	dec a
	jr nz, .copyRowLoop
	jr .exit

.fishOverflow:
	pop af
	pop hl
	pop bc

	jr .fishEnd

.exit:
	ret



updateControlTiles:
	load CursorAddress, h, l
	ld a, [CursorTileOld]
	ld [hl], a
	load CursorAddress2, h, l
	ld a, [CursorTileOld2]
	ld [hl], a

	ld a, [CursorX]
	and %11111011
	jr nz, .skipLeftRightBorderWrite
	ld a, [CursorY]

	cp 0
	jp z, .end
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
	jr z, .skipRightBorderWrite
	ld d, 3
	ld b, 0
	ld c, 17
	add hl, bc
.skipRightBorderWrite

	ld bc, _SCRN0
	add hl, bc
	ld a, [hl]
	ld [hl], d
	ld [CursorTileOld], a
	store CursorAddress, h, l

	inc d
	ld b, 0
	ld c, 32
	add hl, bc
	ld a, [hl]
	ld [hl], d
	ld [CursorTileOld2], a
	store CursorAddress2, h, l

	jr .end
.skipLeftRightBorderWrite

	ld a, [CursorY]
	and %11111011
	jr nz, .skipTopBottomBorderWrite
	ld a, [CursorX]

	cp 0
	jr z, .end
	dec a ; change from 1-3 to 0 to 2 range

	; a = a*6+2 to get to the left center of the column
	ld b, a
	add b
	add b
	add a
	add 2

	; store y coordinate in hl register
	ld l, a
	ld h, 0

	ld d, 5
	ld a, [CursorY]
	cp 0
	jr z, .skipBottomBorderWrite
	ld d, 7
	ld b, 2
	ld c, 32
	add hl, bc
.skipBottomBorderWrite

	ld bc, _SCRN0
	add hl, bc
	ld a, [hl]
	ld [hl], d
	ld [CursorTileOld], a
	store CursorAddress, h, l

	inc d
	ld b, 0
	ld c, 1
	add hl, bc
	ld a, [hl]
	ld [hl], d
	ld [CursorTileOld2], a
	store CursorAddress2, h, l
.skipTopBottomBorderWrite
.end
	ret


; Loads a level
; hl = level address
loadLevel:

	; Set the cursor to the upper left corner
	ld a, 1
	ld [CursorX], a
	ld a, 0
	ld [CursorY], a

	; Copy the level data into RAM
	push hl

	ld de, LevelData
	ld c, 9 * 9
	call memcpy_quick

	pop hl

	call updateLevel
	ret



PlaceFish: MACRO
	ld a, \1 + (fish-levelTiles)/16
	ld [de], a
	inc de

	ld a, 0
	ld [de], a
	inc de
ENDM

; Update the sprites to match the level data
updateLevel:
	ld a, 0
	ld [__Scratch + 1], a

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

	ld a, [__Scratch + 1]
	inc a
	ld [__Scratch + 1], a

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
	PlaceFish $00
	jr .loopCompare

.skipFish1:
	; Check for Fish Level 2
	cp a, 2
	jr nz, .skipFish2

	; Fish Level 1
	PlaceFish $01
	jr .loopCompare

.skipFish2:
	; Check for Fish Level 3
	cp a, 3
	jr nz, .skipFish3

	; Fish Level 1
	PlaceFish $02
	jr .loopCompare

.skipFish3
	PlaceFish $05 ; Player

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

	; Zero out the remaining sprites
	ld a, [__Scratch + 1]
	ld b, a
	ld a, 10
	sub b
	jr z, .end

	ld b, a
	ld a, 0

	ld h, d
	ld l, e

.loopRemoveSprites:
	ld [hl+], a
	ld [hl+], a
	ld [hl+], a

	dec b
	jr nz, .loopRemoveSprites

.end:

	ret


testLevel:
	;         |          |
	db 0, 0, 0,   0, 1, 0,   0, 0, 0
	db 0, 0, 0,   0, 2, 0,   0, 0, 0
	db 0, 0, 0,   0, 3, 0,   0, 0, 0 ; ----

	db 0, 0, 0,   0, 3, 0,   0, 0, 0
	db 0, 0, 0,   0, 2, 0,   0, 0, 0
	db 0, 0, 0,   0, 1, 0,   0, 0, 0 ; ----

	db 0, 0, 0,   0, 1, 0,   0, 0, 0
	db 0, 0, 0,   0, 2, 0,   0, 0, 0
	db 0, 0, 0,   0, 3, 0,   0, 0, 0

ENDC
