# The Three Pieces

You finish this chapter able to name
the three pieces of a Klipper system,
say which one holds the config, the
plan and the schedule, and point a
problem at the piece that owns it —
the single most useful troubleshooting
skill in this guide.

## Klippy, the brain

**Klippy** is a Python program that
runs on the host computer — a
Raspberry Pi in most installs, any
modest Linux machine in principle. It
is the piece you configure and the
piece that thinks. Klippy:

- reads `printer.cfg` at startup and
  builds its whole picture of the
  printer from it;
- accepts **G-code**, the line-by-line
  movement language a slicer produces
  (`G1 X100 Y100` and friends), from a
  file, a front end, or its API;
- plans moves, watches temperatures,
  runs macros, and translates
  everything into scheduled commands
  for the board;
- keeps the **API socket**, a channel
  other programs use to ask it
  questions and give it orders —
  chapter 12's front ends live on it,
  and this guide's lab used it
  directly (transcript
  `klipper-lab/transcripts/t01-live-pair.txt`).

When this guide says "Klipper
decided" or "Klipper refused", it
means klippy. The refusal in
transcript t90 — *Must home axis
first* — is klippy declining an order
it cannot safely interpret.

## The MCU firmware, the metronome

The board runs Klipper's other half:
small firmware written in C, compiled
for that board's chip, and **flashed**
(written into the board's memory) once
per board. It knows nothing about
your printer. It exposes the chip's
abilities — these pins can pulse a
motor, that pin can read a temperature
sensor, this one can switch a heater —
and it executes timestamped commands
from klippy against its own clock.

Two facts about it repay remembering.
It is **generic per chip, not per
printer**: the same build serves any
printer using that board, because
everything printer-shaped lives in
the config on the host. And it is
**honest about failure**: if a sensor
reading is impossible or a command
cannot be scheduled, the firmware
does not improvise — it shuts down
and says why, and klippy relays the
message. The lab's live run ended
exactly that way, thirty seconds in,
over a temperature sensor the sandbox
could not provide (transcript t01).
That bluntness is a safety feature,
and chapter 14 treats it as one.

A system may have several MCUs — a
main board, a toolhead board on a
CAN bus, a display board. Klippy
schedules all of them from the same
plan and the same config file, which
is why pins in `printer.cfg` can be
written as `boardname:gpio2`-style
names when more than one board
exists. The lab had exactly one.

## The front end, the face

Humans rarely talk to klippy raw.
They use a **front end**: a web
interface — usually **Mainsail** or
**Fluidd** — served by **Moonraker**,
the companion program that sits
between the browser and klippy's API,
adding file uploads, print history
and camera handling. Chapter 12 takes
that layer apart. For now, hold the
one fact that prevents a whole class
of confusion: the front end *displays*
the printer; it does not *run* it.
Close the browser and the print
continues. Restart Moonraker and the
print continues. It is a window, not
a wheel.

## Who holds what

| Question | Answer lives in |
|---|---|
| How big is the bed? | `printer.cfg`, read by klippy |
| What temperature is the nozzle? | A sensor, read by the MCU, reported to klippy |
| When does the next step pulse fire? | The MCU's schedule, from klippy's plan |
| Where is the print file? | The host, managed through Moonraker |
| Why did it stop? | The shutdown message: raised by whichever piece saw the fault, kept by klippy |

Check: cover the right column and
quiz yourself down the left. If you
can place all five, the rest of this
guide will keep making sense — most
Klipper confusion is a question asked
of the wrong piece.
