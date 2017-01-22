IF !DEF(__ANIMATIONS_ASM__)
__ANIMATIONS_ASM__ SET 1

updateAnimations:
	ld a, [AnimationCounter]
	inc a
	ld [AnimationCounter], a

	cp 16
	jr z, .end

	srl a
	srl a

	; now a is a value between 0 and 3 and can be used for indexing the animation frame
	ld [AnimationFrame], a
	ret

.end:
	ld a, 0
	ld [AnimationFrame], a
	ld [AnimationCounter], a
	ret


ENDC
