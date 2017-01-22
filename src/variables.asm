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

AnimationCounter: ds 1 ; Used to show the next animation frame every nth frame
AnimationFrame: ds 1 ; The current animation frame shared by all fishes

; Level section
PlayerFishCounter: ds 1 ; the number of fishes the player ate at the current size
PlayerLevel: ds 1 ; The fish level of the player
PlayerSpeed: ds 1 ; The speed of the player, 2 or 1
LevelData: ds 9 * 9 ; Live Level data
; 0 = Empty
; 1 = Level 1 Fish
; 2 = Level 2 Fish
; 3 = Level 3 Fish
; 9 = Player Fish

.end:

CursorX: ds 1 ; The wave cursor x position
CursorY: ds 1 ; The wave cursor y position
CursorAddress: ds 2 ; Cursor tile address
CursorAddress2: ds 2 ; Cursor tile address
CursorTileOld: ds 1 ; Previous tile before cursor was there
CursorTileOld2: ds 1 ; Previous tile before cursor was there

WaveTilesOld: ds 6 ; Wave background tiles
WaveX: ds 1 ; Wave x position
WaveY: ds 1 ; Wave y position
WaveType: ds 1 ; Wave type, 0 no wave, 1 left to right, 2 right to left, 3 top to bottom, 4 bottom to top
WaveUpdateCounter: ds 1 ; Used to update only every nth frame

; Misc
__Scratch: ds 1

VariablesEnd:

POPS

ENDC
