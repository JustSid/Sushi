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

ENDC