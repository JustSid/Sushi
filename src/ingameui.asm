IF !DEF(__INGAMEUI_ASM__)
__INGAMEUI_ASM__ SET 1

updateIngameUI:
	ld a, [PlayerFishCounter]
	cp 0
	jr nz, .greater0

	ld hl, _SCRN0 + 32*14 + 18
	ld a, 29
	ld [hl+], a
	ld a, 30
	ld [hl], a
	ld hl, _SCRN0 + 32*15 + 18
	ld a, 31
	ld [hl+], a
	ld a, 32
	ld [hl], a
	jr .endFish

.greater0:
	cp 1
	jr nz, .greater1
	ld hl, _SCRN0 + 32*14 + 18
	ld a, 33
	ld [hl+], a
	ld a, 30
	ld [hl], a
	ld hl, _SCRN0 + 32*15 + 18
	ld a, 35
	ld [hl+], a
	ld a, 32
	ld [hl], a
	jr .endFish

.greater1:
	ld hl, _SCRN0 + 32*14 + 18
	ld a, 33
	ld [hl+], a
	ld a, 34
	ld [hl], a
	ld hl, _SCRN0 + 32*15 + 18
	ld a, 35
	ld [hl+], a
	ld a, 36
	ld [hl], a

.endFish:
	ld a, [CurrentLevelNumber]
	sub a, 10
	jr nc, .levelgeq10

	ld hl, _SCRN0 + 32*17 + 18
	ld a, 37
	ld [hl+], a
	ld a, [CurrentLevelNumber]
	add a, 37
	ld [hl], a
	jr .endLevel

.levelgeq10:
	ld hl, _SCRN0 + 32*17 + 18
	ld a, 38
	ld [hl+], a
	ld a, [CurrentLevelNumber]
	add a, 27
	ld [hl], a
	jr .endLevel

.level03

.endLevel:
	ret

ENDC