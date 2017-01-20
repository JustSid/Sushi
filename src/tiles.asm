IF !DEF(__TILES_ASM__)
__TILES_ASM__ SET 1

tileData:

levelTiles:
INCBIN "level"
levelTilesEnd:

font:
; ASCII has 32 elements per row, the font however only has 26
INCBIN "font", 0, 26 * 16
DS 7 * 16

INCBIN "font", 26 * 16, 26 * 16
DS 6 * 16

INCBIN "font", 52 * 16, 26 * 16
INCBIN "font", 78 * 16, 14 * 16 ; The last row only has 14 elements and they don't need any padding
fontEnd:

tileDataEnd:

ENDC