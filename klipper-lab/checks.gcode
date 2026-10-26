; checks.gcode — the batch-mode input script.
; Klippy reads these lines in order, exactly as if a
; host program had sent them, then the run ends.
; Commands whose answers travel the reply stream
; (M115, M105, M114) are exercised against the live
; API in transcript t01 instead; this script uses
; GET_POSITION, whose report klippy writes to its
; log where the transcript can keep it.
M115
GET_POSITION
G28
G1 X100 Y100 F3000
G1 Z10 F600
GET_POSITION
START_PRINT
M400
GET_POSITION
