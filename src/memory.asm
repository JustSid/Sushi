IF !DEF(__MEMORY_ASM__)
__MEMORY_ASM__ SET 1

; Fills a range in memory with a specified byte value.
; hl = destination address
; bc = byte count
; a = byte value
memset:
	inc c
	inc b
	jr .begin
.loop:
	ld [hl+], a
.begin:
	dec c
	jp nz, .loop
	dec b
	jp nz, .loop
	ret

; Fills a range in memory with a specified byte value.
; hl = destination address
; c = byte count
; a = byte value
memset_quick:
	inc c
	jr .begin
.loop:
	ld [hl+], a
.begin:
	dec c
	jp nz, .loop
	ret



; Copies count bytes from source to destination.
; de = destination address
; hl = source address
; bc = byte count
memcpy:
	inc c
	inc b
	jr .begin
.loop:
	ld a, [hl+]
	ld [de], a
	inc de
.begin:
	dec c
	jr nz, .loop
	dec b
	jr nz, .loop
	ret

; Copies count bytes from source to destination.
; de = destination address
; hl = source address
; c  = byte count
memcpy_quick:
	inc c
	jr .begin
.loop:
	ld a, [hl+]
	ld [de], a
	inc de
.begin:
	dec c
	jr nz, .loop
	ret


; hl = source address
; de = destination address
; b = rows
; c = columns
; [BlitRowLength] = The length of one row
blit:
	push hl

	; Calculate the effective offset (BlitRowLength - columns)
	ld a, [BlitRowLength + 0]
	ld h, a
	ld a, [BlitRowLength + 1]
	ld l, a

	sub c
	ld [BlitRowLength + 1], a

	ld a, h
	sbc 0 ; The "high" byte of this subtraction is always zero since columns is 1 byte
	ld [BlitRowLength + 0], a

	pop hl

.copyRow:
	push bc

.copyRowLoop:
	ld a, [hl+]
	ld [de], a
	inc de

	dec c ; Check if we have copied enough bytes
	jr nz, .copyRowLoop

	; restore bc and check if we have copied enough rows
	pop bc
	dec b
	jr z, .exit

	; Increment hl by the row length
	push bc

	ld a, [BlitRowLength + 0]
	ld b, a
	ld a, [BlitRowLength + 1]
	ld c, a
	add hl, bc

	pop bc

	jr .copyRow

.exit:
	ret


ENDC