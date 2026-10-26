# Pressure Advance

You finish this chapter able to
explain why corners bulge, what the
**pressure advance** value does about
it, and how it is tuned and checked —
with the lab's record of a new value
being set and read back. The tuning
print itself is **documented only**:
no plastic melted in the making of
this guide.

## The nozzle is a garden hose

Molten filament is not a rod that
pushes plastic out by existing. The
extruder squeezes filament into a
melt zone, pressure builds, and
plastic flows from the nozzle at a
rate set by that pressure. Squeeze
harder and the flow rises — after a
moment. Ease off and the flow falls —
after a moment. The system has
spring in it: the filament flexes,
the melt compresses, the tube (on a
Bowden machine, metres of it) bows.

Corners expose it. Entering a corner
the toolhead slows but the pressure
is still high, so plastic overflows:
a bulged corner. Leaving it, the
toolhead accelerates while pressure
is still building: a starved, thin
start. Speed changes print as
thickness changes, with the pressure
always one step behind the motion.

## The advance

Pressure advance is klippy
compensating in advance — the name is
the mechanism. When a move demands
more flow, the extruder is told to
turn *extra*, early, by an amount
proportional to the change: building
pressure before the motion needs it.
When the move ends, the extruder
backs off early, spending the stored
pressure instead of ooze. Tuned
well, the compensation is invisible
— which is the point: corners the
same width as straights, seams that
do not swell.

The value is a time, in seconds, and
it lives in the extruder's section:

```ini
[extruder]
pressure_advance: 0.040
```

Read it as *how many seconds of
extra extrusion buys the pressure
this move needs*. A direct-drive
extruder (short path, little spring)
wants a small value — hundredths.
A long Bowden tube (a spring the
whole way) can want ten times that.
Klippy also applies a
**pressure_advance_smooth_time**, a
short window over which the extra
motion is spread so the compensation
itself does not jerk the extruder;
the default 0.040 s is rarely the
thing to change first.

## Tuning it, honestly

The documented method is a printed
test: a pattern of lines printed at
varying speeds with the advance
stepped between lines
(`SET_PRESSURE_ADVANCE` per line, via
the project's tuning commands), after
which the reader picks the line whose
corners stay sharp and whose starts
stay full, and writes that value into
the config. It is per filament, in
principle — a soft filament springs
more than a stiff one — and most
drivers keep one value per material
and stop there. Over-advancing is
its own flaw: gaps at line starts,
a clicking extruder, in bad cases a
ground filament. The knob compensates
a physical lag; it cannot repeal it.

## The lab's check

The lab set the value the way the
tuning print does, minus the print
(transcript
`klipper-lab/transcripts/t03-batch-tuning.txt`).
With the config's 0.040 loaded, the
run issued:

```text
SET_PRESSURE_ADVANCE ADVANCE=0.060
```

and klippy logged the pair now in
force:

```text
INFO:root:extruder: pressure_advance: 0.060000
pressure_advance_smooth_time: 0.040000
```

Silent acceptance is the normal case
for the `SET_` commands, so a log
line like this one — or a macro that
reports the value back — is the
check to build the habit around on a
real machine: set it, see it, then
trust the print. And a value set at
run time is a guest, not a resident:
it lasts until restart. What chapter
11's macros set per filament and
what the config holds as the
machine's default are two different
decisions, and confusing them is a
quiet way to print all weekend on a
number you tested once.
