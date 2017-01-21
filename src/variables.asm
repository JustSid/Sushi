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

; Level section
PlayerLevel: ds 1 ; The fish level of the player
LevelData: ds 9 * 9 ; Live Level data
; 0 = Empty
; 1 = Level 1 Fish
; 2 = Level 2 Fish
; 3 = Level 3 Fish
; 9 = Player Fish

CursorX: ds 1 ; The wave cursor x position
CursorY: ds 1 ; The wave cursor y position
CursorPreviousX: ds 1 ; The previous wave cursor x position
CursorPreviousY: ds 1 ; The previous wave cursor y position

; Misc
__Scratch: ds 1

VariablesEnd:

POPS

ENDC
