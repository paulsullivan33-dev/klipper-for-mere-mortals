; tuning.gcode — change the famous knobs at run time.
; The SET_ commands answer silently when they accept a
; value, so the visible checks are: no error, a clean
; exit, and the position report at the end — whose
; gcode lines move by the Z offset set below.
G28
SET_PRESSURE_ADVANCE ADVANCE=0.060
SET_INPUT_SHAPER SHAPER_FREQ_X=45 SHAPER_FREQ_Y=41
SET_GCODE_OFFSET Z_ADJUST=0.10 MOVE=1
GET_POSITION
M400
