INCLUDE "gbhw.inc"
INCLUDE "gbt_player.inc"
INCLUDE "interrupts.asm"
INCLUDE "variables.asm"
INCLUDE "macros.asm"

GLOBAL song_data

SECTION	"start",HOME[$0100]
start:
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

	; Zero the SCX and SCY position
	ld a, 0
	ld [rSCX], a
	ld [rSCY], a

	; Zero out BSS section
	ld a, 0
	ld hl, VariablesBegin
	ld c, VariablesEnd - VariablesBegin
	call memset_quick

	ld a, LCDCF_ON | LCDCF_BG8000 | LCDCF_WIN9C00 | LCDCF_WINOFF | LCDCF_BG9800 | LCDCF_BGON | LCDCF_OBJ8 | LCDCF_OBJON
	ld [displayMode], a

	jp showStartScreen

backToMenu:
	di
	ld sp, $ffff

	call disableLCD
	call clearSprites

	jp showStartScreen

startGame:
	di
	call disableLCD

	; Load palette
	ld a, %11100100
	;ld a, %11011000
	ld [rBGP], a
	ld [rOBP0], a

	; Load background tiles
	ld de, _VRAM ; $8000
	ld hl, tileData
	ld bc, tileDataEnd - tileData
	call memcpy ; load tile data

	; Enable the LCD again
	ld a, LCDCF_ON | LCDCF_BG8000 | LCDCF_WIN9C00 | LCDCF_WINOFF | LCDCF_BG9800 | LCDCF_BGON | LCDCF_OBJ8 | LCDCF_OBJON
	ld [displayMode], a

	call enableLCD

	ld a, 1
	ld [CurrentLevelNumber], a

	ld hl, LevelStart
	store CurrentLevel, h, l

	call loadLevel

	; Set the cursor to the upper left corner
	ld a, 1
	ld [CursorX], a
	ld a, 0
	ld [CursorY], a

	; Enable interrupts
	ld a, 0
	ld [rIF], a ; Set the interrupt pending flags to 0
	ld a, %00000011
	ld [rIE], a ; Unmask all interrupts
	ei ; Enable interrupts

	; Enable timer interrupt to be triggered at 16Hz
	ld a, 0
	ld [rTMA], a
	ld a, %00000100
	ld [rTAC], a

	; Play music
	ld de, song_data
	ld bc, BANK(song_data)
	ld a, $05
	call gbt_play
	ld a, 1
	call gbt_loop

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

	; Check wether the player has won or lost the game
	ld a, [WaveType]
	cp a, 0
	jp nz, .skipLevelWon

	ld a, [LevelWon]
	cp a, 0
	jr z, .skipLevelWon

	cp a, 2
	jr z, .levelLost

.levelWon:
	load CurrentLevel, h, l
	ld bc, 9 * 9
	add hl, bc
	store CurrentLevel, h, l

	; Check if this was the last level
	ld bc, LevelEnd

	ld a, h
	cp a, b
	jr nz, .normalWon

	ld a, l
	cp a, c
	jr nz, .normalWon

	; Show the final "You won" message
	ld hl, backToMenu
	store UICallBack, h, l

	ld hl, stringVictory
	ld c, ((stringVictoryEnd - stringVictory) / LineLength)
	call showText
	call showUI

	jr .wonFinish

.normalWon:
	ld hl, startLevel
	store UICallBack, h, l

	ld a, [CurrentLevelNumber]
	inc a
	ld [CurrentLevelNumber], a

	ld hl, stringWon
	ld c, ((stringWonEnd - stringWon) / LineLength)
	call showText
	call showUI

.wonFinish
	ld a, 0
	ld [LevelWon], a
	jr .skipLevelWon

.levelLost:
	ld hl, startLevel
	store UICallBack, h, l

	ld hl, stringLost
	ld c, ((stringLostEnd - stringLost) / LineLength)
	call showText
	call showUI

	ld a, 0
	ld [LevelWon], a


.skipLevelWon:
	; If the UI is active, update the UI, otherwise update the game
	ld a, [UIActive]
	or a

	call z, updateGame
	call gbt_update ; Update music player

	jp main


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


startLevel:
	load CurrentLevel, h, l
	call loadLevel
	ret


INCLUDE "start.asm"
INCLUDE "controls.asm"
INCLUDE "game.asm"
INCLUDE "oam.asm"
INCLUDE "memory.asm"
INCLUDE "input.asm"
INCLUDE "tiles.asm"
INCLUDE "ui.asm"
INCLUDE "strings.asm"
INCLUDE "waves.asm"
INCLUDE "ingameui.asm"
INCLUDE "animations.asm"

PRINTV mapVRAMToScreen - start
