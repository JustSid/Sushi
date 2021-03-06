
IF !DEF(__MACROS_ASM__)
__MACROS_ASM__ SET 1

LineLength EQU 18

store: MACRO

	ld a, \2
	ld [\1 + 0], a
	ld a, \3
	ld [\1 + 1], a

ENDM

load: MACRO

	ld a, [\1 + 0]
	ld \2, a

	ld a, [\1 + 1]
	ld \3, a

ENDM

shiftLeft: MACRO

	sla \1
	sla \2
	jr nc, .skipCarry\@
	set 0, \1
.skipCarry\@:

ENDM

sub16_8: MACRO
	ld a, \2
	sub \3
	ld \2, a

	ld a, \1
	sbc 0
	ld \1, a
ENDM
add16_8: MACRO
	ld a, \2
	add \3
	ld \2, a

	ld a, \1
	adc 0
	ld \1, a
ENDM


ENDC
