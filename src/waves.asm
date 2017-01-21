updateWave:
	ld a, [WaveUpdateCounter]
	inc a
	ld [WaveUpdateCounter], a
	cp 3
	jr nz, .end

	ld a, 0
	ld [WaveUpdateCounter], a

	ld a, [WaveType]
	cp 1
	call z, updateWaveToRight

	ld a, [WaveType]
	cp 2
	call z, updateWaveToLeft

.end:
	ret


updateWaveToRight:

	ld a, [WaveX]
	ld l, a
	ld h, 0

	ld a, [WaveY]
	ld b, a
	add b
	add b
	add a
	ld b, 0
	ld c, a

	shiftLeft b, c
	shiftLeft b, c
	shiftLeft b, c
	shiftLeft b, c
	shiftLeft b, c
	add hl, bc

	; Set new wave tiles and store their old values
	ld bc, _SCRN0
	add hl, bc
	ld b, 0
	ld c, 31
	ld d, h
	ld e, l

	ld a, [WaveTilesOld+0]
	ld [hl+], a
	ld a, [hl]
	ld [WaveTilesOld+0], a
	ld a, 21
	ld [hl], a
	add hl, bc

	ld a, [WaveTilesOld+1]
	ld [hl+], a
	ld a, [hl]
	ld [WaveTilesOld+1], a
	ld a, 22
	ld [hl], a
	add hl, bc

	ld a, [WaveTilesOld+2]
	ld [hl+], a
	ld a, [hl]
	ld [WaveTilesOld+2], a
	ld a, 22
	ld [hl], a
	add hl, bc

	ld a, [WaveTilesOld+3]
	ld [hl+], a
	ld a, [hl]
	ld [WaveTilesOld+3], a
	ld a, 22
	ld [hl], a
	add hl, bc

	ld a, [WaveTilesOld+4]
	ld [hl+], a
	ld a, [hl]
	ld [WaveTilesOld+4], a
	ld a, 22
	ld [hl], a
	add hl, bc

	ld a, [WaveTilesOld+5]
	ld [hl+], a
	ld a, [hl]
	ld [WaveTilesOld+5], a
	ld a, 23
	ld [hl], a

	; Move wave one unit
	ld a, [WaveX]
	inc a
	cp 18
	jr z, .reset
	ld [WaveX], a
	ret

.reset:
	ld h, d
	ld l, e
	inc hl
	ld b, 0
	ld c, 32

	ld a, [WaveTilesOld+0]
	ld [hl], a
	add hl, bc

	ld a, [WaveTilesOld+1]
	ld [hl], a
	add hl, bc

	ld a, [WaveTilesOld+2]
	ld [hl], a
	add hl, bc

	ld a, [WaveTilesOld+3]
	ld [hl], a
	add hl, bc

	ld a, [WaveTilesOld+4]
	ld [hl], a
	add hl, bc

	ld a, [WaveTilesOld+5]
	ld [hl], a
	add hl, bc

	ld a, 9
	ld [WaveTilesOld+0], a
	ld a, 15
	ld [WaveTilesOld+1], a
	ld a, 9
	ld [WaveTilesOld+2], a
	ld a, 15
	ld [WaveTilesOld+3], a
	ld a, 9
	ld [WaveTilesOld+4], a
	ld a, 11
	ld [WaveTilesOld+5], a

	ld a, 0
	ld [WaveType], a
	ret


updateWaveToLeft:

	ld a, [WaveX]
	ld l, a
	ld h, 0

	ld a, [WaveY]
	ld b, a
	add b
	add b
	add a
	ld b, 0
	ld c, a

	shiftLeft b, c
	shiftLeft b, c
	shiftLeft b, c
	shiftLeft b, c
	shiftLeft b, c
	add hl, bc

	; Set new wave tiles and store their old values
	ld bc, _SCRN0
	add hl, bc
	ld b, 0
	ld c, 33
	ld d, h
	ld e, l

	ld a, [WaveTilesOld+0]
	ld [hl-], a
	ld a, [hl]
	ld [WaveTilesOld+0], a
	ld a, 24
	ld [hl], a
	add hl, bc

	ld a, [WaveTilesOld+1]
	ld [hl-], a
	ld a, [hl]
	ld [WaveTilesOld+1], a
	ld a, 25
	ld [hl], a
	add hl, bc

	ld a, [WaveTilesOld+2]
	ld [hl-], a
	ld a, [hl]
	ld [WaveTilesOld+2], a
	ld a, 25
	ld [hl], a
	add hl, bc

	ld a, [WaveTilesOld+3]
	ld [hl-], a
	ld a, [hl]
	ld [WaveTilesOld+3], a
	ld a, 25
	ld [hl], a
	add hl, bc

	ld a, [WaveTilesOld+4]
	ld [hl-], a
	ld a, [hl]
	ld [WaveTilesOld+4], a
	ld a, 25
	ld [hl], a
	add hl, bc

	ld a, [WaveTilesOld+5]
	ld [hl-], a
	ld a, [hl]
	ld [WaveTilesOld+5], a
	ld a, 26
	ld [hl], a

	; Move wave one unit
	ld a, [WaveX]
	dec a
	jr z, .reset
	ld [WaveX], a
	ret

.reset:
	ld h, d
	ld l, e
	dec hl
	ld b, 0
	ld c, 32

	ld a, [WaveTilesOld+0]
	ld [hl], a
	add hl, bc

	ld a, [WaveTilesOld+1]
	ld [hl], a
	add hl, bc

	ld a, [WaveTilesOld+2]
	ld [hl], a
	add hl, bc

	ld a, [WaveTilesOld+3]
	ld [hl], a
	add hl, bc

	ld a, [WaveTilesOld+4]
	ld [hl], a
	add hl, bc

	ld a, [WaveTilesOld+5]
	ld [hl], a
	add hl, bc

	ld a, 10
	ld [WaveTilesOld+0], a
	ld a, 16
	ld [WaveTilesOld+1], a
	ld a, 10
	ld [WaveTilesOld+2], a
	ld a, 16
	ld [WaveTilesOld+3], a
	ld a, 10
	ld [WaveTilesOld+4], a
	ld a, 12
	ld [WaveTilesOld+5], a

	ld a, 0
	ld [WaveType], a
	ret
