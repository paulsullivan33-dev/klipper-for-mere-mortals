# Glossary

**Bed mesh** — a grid of probed bed
heights that klippy follows during
the first layers, keeping the
nozzle's distance to the surface
constant across an uneven bed
(chapter 8).

**Config file (`printer.cfg`)** — the
plain-text file that describes one
printer completely: sections per
part, pins, and values with units.
Read by klippy at startup; the
printer, as far as the software is
concerned (chapter 5).

**Dictionary** — the table built
alongside the MCU firmware that lets
klippy speak that exact build's
protocol dialect (chapter 4).

**Endstop** — the switch or sensor
that marks a known physical position
on an axis; homing drives into it to
locate the machine (chapter 7).

**Firmware** — the software that runs
a printer. In Klipper it is split:
klippy on the host, and the MCU
firmware on the board (chapter 1).

**Flashing** — writing firmware into
a board's memory, by SD card, USB or
serial, board by board (chapter 4).

**Front end** — the web interface a
human drives — Mainsail or Fluidd —
a window onto the printer, not the
thing running it (chapters 3, 12).

**G-code** — the line-by-line command
language print files are written in:
moves, temperatures, fan speeds, and
klippy's own extended commands in the
same stream.

**Homing** — driving each axis to its
endstop to establish known positions;
the precondition for all motion
(chapter 7). The command is `G28`.

**Host** — the real computer (usually
a Raspberry Pi) that runs klippy and
does the planning the board cannot
(chapter 1).

**Input shaping** — cancelling frame
vibration by issuing each move as a
short train of impulses timed to the
machine's resonant frequency, so the
vibrations sum to stillness
(chapters 2, 9).

**KIAUH** — the Klipper Installation
And Update Helper: a menu script that
installs and updates the host side
(chapter 4).

**Klippy** — Klipper's host program,
written in Python: reads the config,
plans moves, watches temperatures,
schedules the boards (chapter 3).

**Leadscrew** — the threaded rod that
raises and lowers a Cartesian
printer's gantry; its rotation
distance is millimetres per turn
(chapter 5).

**Lookahead** — klippy's planning
across many upcoming moves, setting
each junction's speed from what
follows it (chapter 2).

**Macro** — a named block of commands
stored in the config file and run on
invocation; start-print is the
canonical one (chapter 11).

**MCU** — microcontroller unit: the
printer board's chip, and by
extension the small firmware it runs
— timing only, no planning
(chapters 1, 3).

**Moonraker** — the companion program
that turns klippy's API socket into a
web service: files, history, cameras,
updates (chapter 12).

**Pressure advance** — extra extruder
motion, applied early in proportion
to flow changes, that compensates for
the lag of pressure in the melt zone
(chapter 10). Its value is in
seconds.

**Probe** — a sensor lowered to touch
or sense the bed itself, measuring
printing height where printing
happens (chapter 8).

**Resonant frequency** — the rate, in
hertz, at which a printer's frame and
belts naturally ring after a sharp
move; the number input shaping is
built from (chapter 9).

**Ringing** — ghost ripples in a
print's walls after corners, the
visible trace of frame vibration
(chapters 2, 9).

**Rotation distance** — millimetres
an axis or extruder travels per full
motor turn; the number that turns
steps into distance (chapter 5).

**Shutdown** — Klipper's full stop on
a fault it will not improvise past,
always accompanied by the cause;
ended by fixing the cause and
issuing `FIRMWARE_RESTART`
(chapters 6, 14).

**Simulator (Linux process build)** —
the MCU firmware compiled as an
ordinary Linux program, the target
this guide's lab ran: real firmware,
no board (chapter 4).

**Thermistor** — the temperature
sensor in hot ends and beds: a
resistor whose value tracks
temperature, named in the config by
exact type (chapter 5).

**Z offset** — the measured distance
between where a probe triggers and
where the nozzle actually prints;
set by calibration, specific to one
probe, mount and nozzle (chapter 8).
