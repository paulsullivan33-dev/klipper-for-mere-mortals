# Klipper for Mere Mortals

A 3D printer has two jobs that want very
different computers. One job is thinking:
reading a file of instructions, planning
smooth moves, deciding exactly when each
motor should speed up, slow down and
change direction. The other job is
timing: delivering thousands of motor
pulses at exactly the right microsecond,
never late, never early. **Klipper** is
**firmware** — the software that runs a
printer — that splits the two jobs
between two machines. The thinking moves
to a real computer, usually a small
single-board computer like a Raspberry
Pi. The printer's own board keeps only
the timing, following a schedule the
computer worked out ahead of it.

This guide explains how that split
works, what the three pieces are, and
how to read — really read, section by
section — the one file that describes
your printer to the software:
`printer.cfg`. It covers the first
checks you run after connecting, why
nothing moves until the printer has
**homed**, what a **probe** and a **bed
mesh** add, and the two calibrations
Klipper is famous for: **input shaping**,
which cancels the ringing that fast
moves leave in a print's walls, and
**pressure advance**, which keeps
corners sharp by managing the pressure
inside the nozzle. It finishes with the
limits and the safety rules, which in
this corner of the world are not fine
print.

The rule that governs everything here is
stated now and repeated in the last
chapters: **firmware commands real motion
and real heat.** A wrong number in a
config file is not a typo on a screen;
it is a toolhead driven into a bed, or a
heater left without a working
temperature limit. Klipper's own
protections — checked temperatures,
position limits, a shutdown that stops
everything when the numbers stop making
sense — are part of the design, and this
guide treats them as load-bearing, not
optional. **Thermal protection is not a
feature to tune away.**

The lab behind this guide ran the real
software with no printer attached:
**Klipper ee2c6fb**, cloned from the
project's repository. Its board side was
compiled for the project's own **Linux
process** target — the board firmware
built as an ordinary program — and its
host side, klippy, ran on Python 3.12
against an invented printer: a generic
Cartesian machine described by the lab's
own `printer.cfg`. Against that pair the
lab connected the two halves for real
over the link the simulated board
creates, asked the firmware its name
through the API socket and got it,
watched the simulated board shut down at
the temperature sensor (a sandbox has no
analogue hardware for it to read — the
transcript shows the exact message), and
then drove the same config through
klippy's batch mode, where homing, moves
to named positions, a start-print macro,
runtime changes to pressure advance and
input shaping, a deliberately mistyped
pin, and a move ordered before homing
all produced their real answers,
kept as transcripts.

What the lab could not do, it did not
fake. There was no printer, no
Raspberry Pi and no accelerometer in the
lab, so flashing a real board, wiring an
endstop, probing a real bed, measuring
resonances and printing an actual part
are taught from the project's
documentation and labelled as such
wherever they appear. `criteria.md`
keeps the full ledger of what was run
and what was only read.

## What this guide covers

- [**What Klipper is**](what-klipper-is.md) —
  the split brain: planning on a real
  computer, timing on the board, and
  why the split changes what a printer
  can do
- [**Why Klipper is fast**](why-klipper-is-fast.md) —
  looking ahead through a queue of
  moves, and input shaping explained
  as pushing a swing at the right
  moment
- [**The three pieces**](the-three-pieces.md) —
  klippy the host program, the MCU
  firmware on the board, and the front
  end you drive, and which piece holds
  what
- [**Installing Klipper**](installing-klipper.md) —
  the shape of a real install (a host,
  a flashed board), the KIAUH helper,
  and the lab's own build of the
  simulated board
- [**printer.cfg, section by section**](printer-cfg-anatomy.md) —
  the file that is the printer:
  steppers, heaters, pins, and values
  with units, read line by line
- [**First checks**](first-checks.md) —
  connecting, asking the firmware its
  name, temperatures at rest, and
  what a healthy answer looks like
- [**Movement and homing**](movement-and-homing.md) —
  why the printer refuses to move
  until it knows where it is, and
  what homing actually establishes
- [**Probes and bed mesh**](probes-and-bed-mesh.md) —
  touching the bed on purpose: the
  probe as a finger, and the mesh as
  a map of a bed that is not flat
- [**Input shaping**](input-shaping.md) —
  ringing, resonance, and cancelling
  a vibration by adding its opposite,
  with the values the lab set and saw
  accepted
- [**Pressure advance**](pressure-advance.md) —
  the nozzle as a garden hose:
  pressure that builds and releases,
  and the advance that compensates
- [**Macros and start print**](macros-and-start-print.md) —
  small programs in the config file,
  and a sane order for the first
  minutes of every print
- [**Moonraker and the front ends**](moonraker-and-front-ends.md) —
  the API in the middle, and
  Mainsail and Fluidd, the two web
  interfaces most people drive
- [**The neighbours**](the-neighbours.md) —
  Marlin on the board alone, OctoPrint
  as a host, and vendor firmware:
  what each does instead, and when
  each is the right answer
- [**Limits and safety**](limits-and-safety.md) —
  what Klipper cannot do, what it
  must not be asked to do, and the
  safety rules stated as rules
- [**Troubleshooting**](troubleshooting.md) —
  the shutdown message, the mistyped
  pin, the move refused before
  homing, and the traps this guide's
  lab fell into so you don't have to
- [**Glossary**](glossary.md) — the
  terms, collected in one place

## What it doesn't cover

Converting a specific printer, model by
model — the project and its community
keep per-printer guides and sample
configs, and chapter 5 teaches you to
read them rather than copy them
blindfold. Designing printer hardware,
choosing motors or boards, and mains
wiring are out; the last is out twice
over, because it can kill. CoreXY,
delta and other kinematics are named
where they change the story, but the
worked example is one Cartesian
machine. This guide also stops at the
printer's own computer: running the
rest of a workshop's network is
pointed at, not taught.

## How to use this guide

Read chapter 1 for the model and
chapter 3 before installing anything —
knowing which piece holds what turns
later confusion into a named problem.
Chapter 5 is the long one; read it with
a config file open, ideally the lab's,
and check each section against the
anatomy as it is introduced. Change one
value at a time on a real machine, and
keep the old file: `printer.cfg` is
small, and a folder of dated copies is
the cheapest insurance in this whole
subject. The lab's transcripts live in
`klipper-lab/transcripts/`; its config
is `klipper-lab/printer.cfg`; its notes
are `examples/lab-notes.txt`.

---

## Part of the series

This guide is one of the [For Mere Mortals](https://paulsullivan33-dev.github.io/mere-mortals/) guides: plain-language guides to the tools programmers and makers use.

Related guides:

- [3D Printing for Mere Mortals](https://paulsullivan33-dev.github.io/3d-printing-for-mere-mortals/)
- [CAD for Mere Mortals](https://paulsullivan33-dev.github.io/cad-for-mere-mortals/)
- [OpenSCAD for Mere Mortals](https://paulsullivan33-dev.github.io/openscad-for-mere-mortals/)

## License

The writing in this guide is licensed under [CC BY 4.0](https://github.com/paulsullivan33-dev/klipper-for-mere-mortals/blob/main/LICENSE). Code examples and lab scripts are licensed under the [MIT License](https://github.com/paulsullivan33-dev/klipper-for-mere-mortals/blob/main/LICENSE-CODE).
