IF !DEF(__UI_ASM__)
__UI_ASM__ SET 1

INCLUDE "gbhw.inc"
INCLUDE "macros.asm"

; Offsets for the corner pieces
UI_BASE_OFFSET EQU (font - tileData) / 16

UI_OFFSET_SPACE     EQU UI_BASE_OFFSET ; Space
UI_OFFSET_CORNER_TL EQU UI_BASE_OFFSET + (91 + 1) ; Top left
UI_OFFSET_CORNER_BL EQU UI_BASE_OFFSET + (91) ; Bottom left
UI_OFFSET_CORNER_TR EQU UI_BASE_OFFSET + (91 + 10) ; Top right
UI_OFFSET_CORNER_BR EQU UI_BASE_OFFSET + (91 + 11) ; bottom right

UI_OFFSET_HORIZONTAL EQU UI_BASE_OFFSET + (91 + 5) ; horizontal pipe
UI_OFFSET_VERTICAL   EQU UI_BASE_OFFSET + (91 + 9) ; vertical pipe
UI_OFFSET_CARET      EQU UI_BASE_OFFSET + (91 + 13) ; Downwards triangle

initUI:
	ld a, 7
	ld [rWX], a

	ld a, 143 - (4 * 8)
	ld [rWY], a

	call __UIBuildFrame
	ret

updateUI:

	ld a, [Input_Once]
	bit 4, a
	jr nz, showMoreText

	; Update caret
	ld a, [UIStringLength]
	or a
	jr z, .showPipe

	ld a, [UIStringTick]
	dec a
	jr nz, .outro

	ld a, [UIFlags]
	bit 1, a
	jr nz, .showPipe

.showCaret:
	set 1, a
	ld [UIFlags], a

	ld a, UI_OFFSET_CARET
	jr .updateCaret

.showPipe:
	res 1, a
	ld [UIFlags], a

	ld a, UI_OFFSET_HORIZONTAL


.updateCaret
	ld hl, _SCRN1 + $72
	ld [hl], a

	ld a, 30

.outro:
	ld [UIStringTick], a
	ret

; hl = address of the string
; c = length of the string to display

showText:

	store UIString, h, l

	ld a, c
	ld [UIStringLength], a

	ld a, 30
	ld [UIStringTick], a ; Set the caret timer

showMoreText:

	; Close the UI if the close flag is set
	ld a, [UIStringLength]
	or a
	call z, hideUI
	ret z

	ld de, _SCRN1 + 33
	call loadLines

	ld de, _SCRN1 + 65
	call loadLines

	ret

clearLine:
	ld a, UI_OFFSET_SPACE
	ld b, 18

	ld h, d
	ld l, e

.clrLoop:
	ld [hl+], a
	dec b
	jr nz, .clrLoop

	ret

; de = The address to which the text should be loaded
; Sets the carry flag if text was read

loadLines:

	; Load the remaining string length
	ld a, [UIStringLength]
	ld c, a

	; Check if the string length is 0 (aka no text remaining)
	or a
	jr nz, .displayText

	; Clear the line
	jr clearLine ; clearLine returns with carry flag == 0

	; Display the text
.displayText:
	load UIString, h, l

	ld b, 18

.loop:
	ld a, [hl+]
	sub (32 - UI_BASE_OFFSET)
	ld [de], a
	inc de

	; Check if we have written 18 characters
	dec b
	jr nz, .loop

	; Decrement c and check if this was the last line
	dec c

	ld a, c
	ld [UIStringLength], a

	store UIString, h, l

	scf ; Set the carry flag
	ret


showUI:
	ld a, 1
	ld [UIActive], a

	ld a, [displayMode]
	set 5, a
	ld [displayMode], a

	call enableLCD
	ret

hideUI:
	ld a, 0
	ld [UIActive], a

	ld a, [displayMode]
	res 5, a
	ld [displayMode], a

	call enableLCD


	load UICallBack, h, l

	ld a, h
	cp 0
	jr z, .noCallback

	ld a, l
	cp 0
	jr z, .noCallback

	jp hl

.noCallback

	ret

; ------------
; UI Frame
; -----------

__UIBuildFrame:
	ld hl, _SCRN1

	; Top Segment
	ld a, UI_OFFSET_CORNER_TL
	ld [hl+], a

	; Draw 18 horizontal pipes
	ld b, 18
.loopTop:
	ld a, UI_OFFSET_HORIZONTAL
	ld [hl+], a
	dec b
	jr nz, .loopTop

	ld a, UI_OFFSET_CORNER_TR
	ld [hl+], a

	; First Line
	; Jump to the next line
	ld bc, 12
	add hl, bc

	; Draw the vertical pipes
	ld a, UI_OFFSET_VERTICAL
	ld [hl+], a

	ld bc, 18
	add hl, bc

	ld [hl+], a

	; Second Line
	ld bc, 12
	add hl, bc

	; Draw the vertical pipes
	ld a, UI_OFFSET_VERTICAL
	ld [hl+], a

	ld bc, 18
	add hl, bc

	ld [hl+], a

	; Bottom segment
	ld bc, 12
	add hl, bc

	ld a, UI_OFFSET_CORNER_BL
	ld [hl+], a

	; Draw 18 horizontal pipes
	ld b, 18
.loopBottom:
	ld a, UI_OFFSET_HORIZONTAL
	ld [hl+], a
	dec b
	jr nz, .loopBottom

	ld a, UI_OFFSET_CORNER_BR
	ld [hl+], a

	ret


ENDC
