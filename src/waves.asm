startWaveToRight:
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

	ld a, 1
	ld [WaveType], a
	ld a, 0
	ld [WaveX], a
	ld a, [CursorY]
	dec a
	ld [WaveY], a

	call playWaveSound
	ret

startWaveToLeft:
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

	ld a, 2
	ld [WaveType], a
	ld a, 17
	ld [WaveX], a
	ld a, [CursorY]
	dec a
	ld [WaveY], a

	call playWaveSound
	ret

startWaveToBottom:
	ld a, 9
	ld [WaveTilesOld+0], a
	ld a, 13
	ld [WaveTilesOld+1], a
	ld a, 9
	ld [WaveTilesOld+2], a
	ld a, 13
	ld [WaveTilesOld+3], a
	ld a, 9
	ld [WaveTilesOld+4], a
	ld a, 10
	ld [WaveTilesOld+5], a

	ld a, 3
	ld [WaveType], a
	ld a, 0
	ld [WaveY], a
	ld a, [CursorX]
	dec a
	ld [WaveX], a

	call playWaveSound
	ret

startWaveToTop:
	ld a, 11
	ld [WaveTilesOld+0], a
	ld a, 14
	ld [WaveTilesOld+1], a
	ld a, 11
	ld [WaveTilesOld+2], a
	ld a, 14
	ld [WaveTilesOld+3], a
	ld a, 11
	ld [WaveTilesOld+4], a
	ld a, 12
	ld [WaveTilesOld+5], a

	ld a, 4
	ld [WaveType], a
	ld a, 17
	ld [WaveY], a
	ld a, [CursorX]
	dec a
	ld [WaveX], a

	call playWaveSound
	ret


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

	ld a, [WaveType]
	cp 3
	call z, updateWaveToBottom

	ld a, [WaveType]
	cp 4
	call z, updateWaveToTop

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

	ld a, 0
	ld [WaveType], a
	ret



updateWaveToBottom:

	ld a, [WaveX]
	ld b, a
	add b
	add b
	add a
	ld l, a
	ld h, 0

	ld a, [WaveY]
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
	ld d, h
	ld e, l

	ld a, [WaveTilesOld+0]
	ld [hl+], a
	ld a, [WaveTilesOld+1]
	ld [hl+], a
	ld a, [WaveTilesOld+2]
	ld [hl+], a
	ld a, [WaveTilesOld+3]
	ld [hl+], a
	ld a, [WaveTilesOld+4]
	ld [hl+], a
	ld a, [WaveTilesOld+5]
	ld [hl], a

	ld bc, 27
	add hl, bc

	ld a, [hl]
	ld [WaveTilesOld+0], a
	ld a, 27
	ld [hl+], a

	ld a, [hl]
	ld [WaveTilesOld+1], a
	ld a, 28
	ld [hl+], a

	ld a, [hl]
	ld [WaveTilesOld+2], a
	ld a, 28
	ld [hl+], a

	ld a, [hl]
	ld [WaveTilesOld+3], a
	ld a, 28
	ld [hl+], a

	ld a, [hl]
	ld [WaveTilesOld+4], a
	ld a, 28
	ld [hl+], a

	ld a, [hl]
	ld [WaveTilesOld+5], a
	ld a, 29
	ld [hl], a

	; Move wave one unit
	ld a, [WaveY]
	inc a
	cp 18
	jr z, .reset
	ld [WaveY], a
	ret

.reset:
	ld h, d
	ld l, e
	ld b, 0
	ld c, 32
	add hl, bc

	ld a, [WaveTilesOld+0]
	ld [hl+], a

	ld a, [WaveTilesOld+1]
	ld [hl+], a

	ld a, [WaveTilesOld+2]
	ld [hl+], a

	ld a, [WaveTilesOld+3]
	ld [hl+], a

	ld a, [WaveTilesOld+4]
	ld [hl+], a

	ld a, [WaveTilesOld+5]
	ld [hl], a

	ld a, 0
	ld [WaveType], a
	ret




updateWaveToTop:

	ld a, [WaveX]
	ld b, a
	add b
	add b
	add a
	ld l, a
	ld h, 0

	ld a, [WaveY]
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
	ld d, h
	ld e, l

	ld a, [WaveTilesOld+0]
	ld [hl+], a
	ld a, [WaveTilesOld+1]
	ld [hl+], a
	ld a, [WaveTilesOld+2]
	ld [hl+], a
	ld a, [WaveTilesOld+3]
	ld [hl+], a
	ld a, [WaveTilesOld+4]
	ld [hl+], a
	ld a, [WaveTilesOld+5]
	ld [hl], a

	sub16_8 h, l, 37

	ld a, [hl]
	ld [WaveTilesOld+0], a
	ld a, 30
	ld [hl+], a

	ld a, [hl]
	ld [WaveTilesOld+1], a
	ld a, 31
	ld [hl+], a

	ld a, [hl]
	ld [WaveTilesOld+2], a
	ld a, 31
	ld [hl+], a

	ld a, [hl]
	ld [WaveTilesOld+3], a
	ld a, 31
	ld [hl+], a

	ld a, [hl]
	ld [WaveTilesOld+4], a
	ld a, 31
	ld [hl+], a

	ld a, [hl]
	ld [WaveTilesOld+5], a
	ld a, 32
	ld [hl], a

	; Move wave one unit
	ld a, [WaveY]
	dec a
	cp 0
	jr z, .reset
	ld [WaveY], a
	ret

.reset:
	ld h, d
	ld l, e
	sub16_8 h, l, 32

	ld a, [WaveTilesOld+0]
	ld [hl+], a

	ld a, [WaveTilesOld+1]
	ld [hl+], a

	ld a, [WaveTilesOld+2]
	ld [hl+], a

	ld a, [WaveTilesOld+3]
	ld [hl+], a

	ld a, [WaveTilesOld+4]
	ld [hl+], a

	ld a, [WaveTilesOld+5]
	ld [hl], a

	ld a, 0
	ld [WaveType], a
	ret


playWaveSound:
	ld a, %00000000
	ld [rNR41], a
	ld a, %11110011
	ld [rNR42], a
	ld a, %01010001
	ld [rNR42_2], a
	ld a, %10000110
	ld [rNR43], a
	ret