# Limits and Safety

What Klipper cannot do, and what must
not be asked of it — the chapter the
rest of the guide has been promising.
The limits first, then the safety
rules stated as rules, because in
this subject the second half is why
the book exists.

## The limits

**Klipper is only as present as its
host.** The board holds seconds of
schedule. A host that sleeps, updates
itself mid-print, or is busy being
something else starves the printer
(and klippy's own statistics will
show the underruns). The little
computer is part of the machine;
treat its power supply, its card and
its cooling accordingly.

**A config file is a claim, not a
measurement.** Klippy believes
`printer.cfg`. It cannot know the bed
is really 220 mm, that the thermistor
is the type the file names, or that
the fan pin is a fan. Chapters 5
through 8 are a long exercise in
making the file true; nothing in the
software substitutes for having done
it.

**Simulation is not printing.** This
guide's lab proved klippy's logic
against a simulated board. It proved
nothing about any physical machine:
not its wiring, not its temperatures,
not its steppers under load. The gap
between "the config loads" and "the
printer is safe" is closed by the
checks in chapters 6 and 7, on the
machine, by a person who is present.

**Cancellation is not correction.**
Input shaping (chapter 9) hides
vibration; it does not tighten the
belt. Pressure advance (chapter 10)
compensates a lag; it does not unclog
the nozzle. Software that masks a
mechanical fault lets the fault grow
unseen, and both knobs work best on
machines that least need them.

**The ecosystem is the documentation.**
Support for a given board, a given
probe, a given screen lives in the
project's docs and community, and
changes faster than any book. This
guide teaches the model so the docs
make sense; it does not replace them
at the bench.

## The safety rules

These are not tips. They are the
conditions under which the rest of
the guide is safe to follow.

**Thermal protection is not
optional.** Every heater must have a
working sensor, named correctly in
the config, with `min_temp` and
`max_temp` at or below the hardware's
ratings. Klipper shuts down on
readings outside them — a broken
sensor wire, a sensor that fell out
of its block — and that shutdown is
the only thing standing between a
fault and a heater driven at full
power forever. Never widen the limits
to silence an error. Never run a
config that disables the checks. A
printer that errs toward shutdown is
a printer designed by people who
have seen the alternative.

**A shutdown is an order, not a
suggestion.** When klippy reports
*Printer is shutdown* — as the lab's
simulator did in transcript t01 — the
cause is printed with it. Read it,
fix the cause, then use
`FIRMWARE_RESTART`. Restarting first
and reading later trains exactly the
habit the shutdown exists to break.

**Config errors are physical.** A
wrong pin is a motor driving into a
frame, a fan's power sent to a
heater, an endstop that never
triggers while the gantry grinds.
Change one thing at a time; keep
dated copies of `printer.cfg`; after
any change, re-run chapter 6's checks
with your hand near the power switch
and the machine in sight. The lab
could mistype `gpio999` into a
transcript (t04) because its printer
was arithmetic. Yours is furniture,
and hot.

**Never leave a heating printer
unattended** — not because this guide
says so, but because every layer
above can fail together: a sensor
can lie plausibly, a MOSFET can fail
closed, a print can detach and pile
molten plastic around a hot block.
Smoke alarms where printers live,
a camera if you must watch from
another room, and no print started
"just to run overnight" on a machine
whose limits you set by copying a
file.

**Mains electricity is out of scope
and out of bounds.** Anything on the
wall side of the power supply —
wiring, relays, silent-switch mods —
belongs to qualified hands and local
code. This guide never asks you to
open that box, and neither should a
macro you found on the internet.
