IF !DEF(__INPUT_ASM__)
__INPUT_ASM__ SET 1

INCLUDE "gbhw.inc"

; Processes the input register
; Clobbers registers A and B

processInput:
	ld a, %00010000 ; Select the P14 port
	ld [rP1], a

	ld a, [rP1]
	ld a, [rP1]

	cpl ; Invert all bits and grab the first 4
	and $0f

	swap a ; Move the lower 4 bits into the upper 4 bits
	ld b, a ; Store in b

	ld a, %00100000 ; Select the P15 port
	ld [rP1], a

	ld a, [rP1]
	ld a, [rP1]

	cpl
	and $0f

	or b ; Combine with the result read from P14
	ld b, a

	ld a, [Input_Continuous] ; XOR with the previous input
	xor b
	and b

	ld [Input_Once], a
	ld a, b
	ld [Input_Continuous], a

	ld a, $0
	ld [rP1], a

	ret

ENDC