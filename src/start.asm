IF !DEF(__START_ASM__)
__START_ASM__ SET 1

; hl = The address in _SCRN0 to where to map it
; a = Start tile number
; b = Row count
; c = column count

mapVRAMToScreen:

.copyRow:
	ld e, c

.copyColumn:
	ld [hl+], a
	inc a

	dec e
	jr nz, .copyColumn

	push bc
	push af

	ld a, 32
	sub a, c

	ld b, 0
	ld c, a

	add hl, bc

	pop af
	pop bc

	dec b
	jr nz, .copyRow

	ret



showStartScreen:
	; Load background tiles
	ld de, _VRAM ; $8000
	ld hl, startScreenData
	ld bc, startScreenDataEnd - startScreenData
	call memcpy ; load tile data

	; Clear the screen
	ld hl, _SCRN0
	ld bc, 32 * 32
	ld a, 0

	call memset

	; Load the Sushi into the screen
	ld hl, _SCRN0 + 6 + (4 * 32)
	ld a, 1
	ld b, 3
	ld c, 7

	call mapVRAMToScreen

	; Load the "Press A to start"
	ld hl, _SCRN0 + 3 + (10 * 32)
	ld a, 22
	ld b, 2
	ld c, 14

	call mapVRAMToScreen


	ld a, LCDCF_ON | LCDCF_BG8000 | LCDCF_WIN9C00 | LCDCF_WINOFF | LCDCF_BG9800 | LCDCF_BGON | LCDCF_OBJ8 | LCDCF_OBJON
	ld [displayMode], a
	call enableLCD

	; Enable interrupts
	ld a, 0
	ld [rIF], a ; Set the interrupt pending flags to 0
	ld a, %00000011
	ld [rIE], a ; Unmask all interrupts
	ei ; Enable interrupts

.loop:
	halt
	nop

	; Verify we are at a vblank interrupt
	ld a, [rSTAT]
	or a
	jr z, .loop

	xor a
	ld [rSTAT], a

	; Get to the next frame
	; Process input
	call processInput

	ld a, [Input_Once]
	bit 4, a
	jr z, .noInput

	jp startGame

.noInput:
	jr .loop


ENDC
