INCLUDE "gbhw.inc"
INCLUDE "interrupts.asm"
INCLUDE "variables.asm"
INCLUDE "macros.asm"

SECTION	"start",HOME[$0100]
	nop
	jp	begin
	ROM_HEADER	ROM_NOMBC, ROM_SIZE_32KBYTE, RAM_SIZE_0KBYTE

begin:
	; Disable interrupts and load the stack
	di
	ld sp, $ffff

init:
	call disableLCD
	call initDMA
	call initUI

	; Load palette
	ld a, %11100100
	;ld a, %00011011
	ld [rBGP], a
	ld [rOBP0], a

	; Zero the SCX and SCY position
	ld a, 0
	ld [rSCX], a
	ld [rSCY], a

	; Zero out BSS section
	ld a, 0
	ld hl, VariablesBegin
	ld c, VariablesEnd - VariablesBegin
	call memset_quick

	; Load background tiles
	ld de, _VRAM ; $8000
	ld hl, tileData
	ld bc, tileDataEnd - tileData
	call memcpy ; load tile data

	; Enable the LCD again
	ld a, LCDCF_ON | LCDCF_BG8000 | LCDCF_WIN9C00 | LCDCF_WINOFF | LCDCF_BG9800 | LCDCF_BGON | LCDCF_OBJ16 | LCDCF_OBJON
	ld [displayMode], a
	call enableLCD
	call showUI

	; Enable interrupts
	ld a, 0
	ld [rIF], a ; Set the interrupt pending flags to 0
	ld a, %00000011
	ld [rIE], a ; Unmask all interrupts
	ei ; Enable interrupts

	; Go to main loop
	jp main

main:
	halt
	nop

	; Verify we are at a vblank interrupt
	ld a, [rSTAT]
	or a
	jr z, main

	xor a
	ld [rSTAT], a

	; Get to the next frame
	; Process input
	call processInput

	; If the UI is active, update the UI, otherwise update the game
	ld a, [UIActive]
	or a

	call z, updateGame

	jr main

updateGame:
	ret


disableLCD:
	ld a, [rLCDC]
	rlca ; Put the high bit of LCDC into the Carry flag
	ret nc ; Screen is off already. Exit.

.wait:
	ld a, [rLY]
	cp 145 ; Is display on scan line 145 yet?
	jr nz, .wait ; no, keep waiting

	ld a, [rLCDC]
	res 7, a ; Reset bit 7 of LCDC
	ld [rLCDC], a

	ret

; a must contain the display mode
enableLCD:
	ld [rLCDC], a
	ret


INCLUDE "oam.asm"
INCLUDE "memory.asm"
INCLUDE "input.asm"
INCLUDE "tiles.asm"
INCLUDE "ui.asm"
INCLUDE "strings.asm"