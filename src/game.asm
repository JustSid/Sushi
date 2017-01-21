IF !DEF(__GAME_ASM__)
__GAME_ASM__ SET 1

updateGame:

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
	db 1, 0, 0,   0, 0, 0,   0, 0, 1
	db 0, 0, 0,   0, 0, 0,   0, 0, 0
	db 0, 0, 0,   2, 0, 0,   0, 0, 0 ; ----

	db 0, 0, 0,   0, 0, 0,   0, 3, 0
	db 0, 0, 0,   0, 4, 1,   0, 0, 0
	db 0, 0, 0,   0, 0, 0,   0, 0, 0 ; ----

	db 0, 0, 1,   0, 0, 0,   0, 0, 0
	db 0, 0, 0,   0, 0, 0,   0, 0, 0
	db 1, 0, 0,   0, 0, 0,   0, 0, 1

ENDC
