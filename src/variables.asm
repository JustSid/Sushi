IF !DEF(__VARIABLES_ASM__)
__VARIABLES_ASM__ SET 1

PUSHS
SECTION "Variables", BSS

VariablesBegin:

Input_Continuous: ds 1
Input_Once: ds 1 ; $80 = Start, $40 = Select, $20 = B, $10 = A, $8 = Down, $4 = Up, $2 = Left, $1 = Right

displayMode: ds 1

; UI Section
UIActive: ds 1 ;
UIFlags: ds 1 ; Bitmask: 0 = UI visible, 1 = Caret Visible
UIString: ds 2 ; The address of the remaining UI text
UIStringLength: ds 1 ; The remaining lines of the string

UIStringTick: ds 1 ; The blinking caret timer

__Scratch: ds 1

VariablesEnd:

POPS

ENDC
