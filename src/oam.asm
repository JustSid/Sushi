IF !DEF(__OAM_ASM__)
__OAM_ASM__ SET 1

performDMA:
	ld a, (OAMBuffer / $100)
	ld [rDMA], a

	ld a, $28
.loop:
	dec a
	jr nz, .loop

	ret
__performDMAEnd:


initDMA:
	; Copy the DMA function
	ld de, OAMFunction
	ld bc, (__performDMAEnd - performDMA)
	ld hl, performDMA

	call memcpy


	; Zero out the OAMBuffer
	ld hl, OAMBuffer
	ld a, 0
	ld c, 160
	call memset_quick

	ret


PUSHS

SECTION "OAMBuffer", WRAM0[$cf00]
OAMBuffer: ds 160

SECTION "OAMCodeSection", HRAM[$FF80]
OAMFunction: ds (__performDMAEnd - performDMA)

POPS

ENDC
