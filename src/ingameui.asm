IF !DEF(__INGAMEUI_ASM__)
__INGAMEUI_ASM__ SET 1

updateIngameUI:
	ld a, [PlayerFishCounter]
	cp 0
	jr nz, .greater0

	ld hl, _SCRN0 + 32*2 + 18
	ld a, 17
	ld [hl+], a
	ld a, 18
	ld [hl], a
	ld hl, _SCRN0 + 32*3 + 18
	ld a, 17
	ld [hl+], a
	ld a, 18
	ld [hl], a
	ret

.greater0:
	ld hl, _SCRN0 + 32*2 + 18
	ld a, 19
	ld [hl+], a
	ld a, 20
	ld [hl], a
	ld hl, _SCRN0 + 32*3 + 18
	ld a, 17
	ld [hl+], a
	ld a, 18
	ld [hl], a
	ret

ENDC