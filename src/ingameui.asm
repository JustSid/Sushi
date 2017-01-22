IF !DEF(__INGAMEUI_ASM__)
__INGAMEUI_ASM__ SET 1

updateIngameUI:
	ld a, [PlayerFishCounter]
	cp 0
	jr nz, .greater0

	ld hl, _SCRN0 + 32*2 + 18
	ld a, 29
	ld [hl+], a
	ld a, 30
	ld [hl], a
	ld hl, _SCRN0 + 32*3 + 18
	ld a, 31
	ld [hl+], a
	ld a, 32
	ld [hl], a
	ret

.greater0:
	cp 1
	jr nz, .greater1
	ld hl, _SCRN0 + 32*2 + 18
	ld a, 33
	ld [hl+], a
	ld a, 30
	ld [hl], a
	ld hl, _SCRN0 + 32*3 + 18
	ld a, 35
	ld [hl+], a
	ld a, 32
	ld [hl], a
	ret

.greater1:
	ld hl, _SCRN0 + 32*2 + 18
	ld a, 33
	ld [hl+], a
	ld a, 34
	ld [hl], a
	ld hl, _SCRN0 + 32*3 + 18
	ld a, 35
	ld [hl+], a
	ld a, 36
	ld [hl], a
	ret

ENDC