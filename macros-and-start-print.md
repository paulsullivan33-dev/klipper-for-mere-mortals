# Macros and Start Print

You finish this chapter able to write
a small **macro** — a named bundle of
commands kept in the config file —
and able to say what a sane
**start-print** sequence does, in
what order, and why the order is the
safety feature.

## Macros: the config learns tricks

Anything you type at a printer twice,
you should type into the config once.
A `[gcode_macro NAME]` section holds
a `gcode:` block: lines of G-code and
klippy commands, run in order whenever
the name is invoked. The lab's config
carries two, and both ran in its
transcripts. The smaller one teaches
the shape:

```ini
[gcode_macro PARK_TOOLHEAD]
description: Raise Z a little and park at the back left
gcode:
    G91
    G1 Z5 F600
    G90
    G1 X5 Y215 F3000
```

Relative mode (`G91`), up five
millimetres so the nozzle clears the
print, absolute mode (`G90`) again,
then travel to the back corner. The
`description:` is not decoration; it
is what the front ends show in their
macro list, and it is what a future
reader — usually you, at midnight —
gets instead of a riddle.

Macros can take parameters, test
conditions and compute, because the
`gcode:` block is a small template
(the Jinja language, the same one
Python web tools use): temperatures
read from the printer's state,
defaults filled in, a filament name
changing a pressure-advance value via
the `SET_` commands of chapters 9
and 10. That power is why macros are
the right home for per-filament
settings, and also why a macro copied
from a stranger deserves the same
reading as a config file: it is a
program your printer will run.

One trap the lab stepped in, kept
because it is typical: its first
`START_PRINT` used `RESPOND` to
announce itself, and the run answered
*Unknown command*. `RESPOND` belongs
to an optional module that a bare
`[respond]` section switches on.
Nothing about the error says that;
the fix is one line, and it is in the
lab's config now, commented, as a
kept lesson (see
`examples/lab-notes.txt`).

## Start print: an order with reasons

Every print begins with the same
choreography, and the macro that owns
it — usually called `START_PRINT`,
called by the slicer's start G-code
with the print's temperatures passed
in — exists to get the order right
every time. The lab's version is a
deliberate skeleton:

```ini
[gcode_macro START_PRINT]
description: Home, park, and announce ready
gcode:
    G28
    G1 Z5 F600
    G1 X5 Y5 F3000
    M400
    RESPOND MSG="Printer ready"
```

It ran in transcript
`klipper-lab/transcripts/t02-batch-checks.txt`:
after it completes, the position
report shows the toolhead parked at
X5 Y5 Z5 — homed, lifted clear, out
of the way. A production start-print
inserts, in order:

1. **Heat, soaks first.** Bed to
   temperature early (it is slow and
   it moves the bed's shape as it
   warms), nozzle to a no-ooze
   standby, then to print temperature
   late. The lab's skeleton omits all
   of it, and says why in the config:
   heat commands *wait*, and a
   simulator run would wait forever.
2. **Home** — after warming, because
   chapter 8's mesh and offset are
   measured warm.
3. **Mesh or level** — load the saved
   mesh, or probe a fresh one.
4. **Prime** — a line or skirt of
   real extrusion at the bed's edge,
   so pressure (chapter 10) and flow
   are established before the part
   begins, and the nozzle arrives
   clean.
5. **Announce and begin** — `M400`
   drains the queue so the print
   proper starts from stillness.

The order is the safety feature.
Priming before homing drags a hot
nozzle across clips; homing cold and
printing hot spends chapter 8's
calibration on a bed that has since
moved; a macro that *ends* hot and
idle is a macro missing its other
half. Write `END_PRINT` with the
same care: heaters **off** — stated
as commands, never assumed — toolhead
parked, motors released. A start you
can trust and an end that leaves the
machine cold and still: that is the
whole chapter, and most of what
separates a printer that feels
professional from one that feels
haunted.
