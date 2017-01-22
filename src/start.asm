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


__disableLCD:
	di
	call disableLCD

	ret

__enableLCD:
	ld a, [displayMode]
	call enableLCD

	; Enable interrupts
	ld a, 0
	ld [rIF], a ; Set the interrupt pending flags to 0
	ld a, %00000011
	ld [rIE], a ; Unmask all interrupts
	ei ; Enable interrupts

	ret



showTutorial01:
	call __disableLCD

	; Load background tiles
	ld de, _VRAM ; $8000
	ld hl, tutorial01ScreenData
	ld bc, tutorial01ScreenDataEnd - tutorial01ScreenData
	call memcpy ; load tile data

	; Clear the screen
	ld hl, _SCRN0
	ld bc, 32 * 32
	ld a, 0

	call memset

	; Load the top part
	ld hl, _SCRN0 + 3 + (4 * 32)
	ld a, 1
	ld c, 14
	ld b, 2

	call mapVRAMToScreen

	; Load the middle part
	ld hl, _SCRN0 + 3 + (7 * 32)
	ld c, 16
	ld b, 2

	call mapVRAMToScreen


	; Load the bottom part
	ld hl, _SCRN0 + 2 + (11 * 32)
	ld c, 16
	ld b, 2

	call mapVRAMToScreen


	ld a, [displayMode]
	call __enableLCD
	ret

showStartScreen:
	; Load palette
	ld a, %11011000
	ld [rBGP], a
	ld [rOBP0], a

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
	ld hl, _SCRN0 + 5 + (5 * 32)
	ld a, 1
	ld c, 10
	ld b, 5

	call mapVRAMToScreen

	; Load the "Press A to start"
	ld hl, _SCRN0 + 5 + (10 * 32)
	ld c, 10
	ld b, 3

	call mapVRAMToScreen

	; Add the GGJ 2017 logo
	ld hl, _SCRN0 + 5 + (17 * 32)
	ld c, 10
	ld b, 1

	call mapVRAMToScreen

	call __enableLCD

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

	ld a, [tutorialMode]
	or a

	jp nz, startGame

	inc a
	ld [tutorialMode], a
	call showTutorial01

.noInput:
	jr .loop


ENDC
