# Probes and Bed Mesh

You finish this chapter able to say
what a probe measures (and what it
does not), what the Z offset really
is, and what a bed mesh can and
cannot fix — the judgement calls,
since the lab, having no printer,
could run none of this. The chapter
is **documented only**, taught from
the project's documentation; the
config shapes it shows are the
project's standard ones, and
`criteria.md` records that no probe
ever fired in the lab.

## Why a switch is not enough

Chapter 7's endstop tells the
printer where Z is at one point,
against a switch that never moves.
But printing happens against the
*bed*, and beds move: they tilt on
their mounts, bow with heat, and sit
a hair differently after every
removal of a spring-steel sheet. The
gap that matters — nozzle to surface,
at printing height — is the one
number a frame-mounted switch cannot
know.

A **probe** is a finger the printer
lowers until it touches the bed
itself: a switch on a pin (BLTouch
and its relatives), an inductive or
capacitive sensor that feels the
surface near, a load cell that feels
the nozzle's own touch. Mounted
beside the nozzle, it measures the
bed's height *where printing happens*,
in the bed's own terms.

## The Z offset is a confession

The probe does not touch where the
nozzle prints; it touches where the
probe *is*, and it triggers before or
after the nozzle would. The
difference — how far the nozzle sits
from the surface when the probe
fires — is the **Z offset**, and
setting it is the famous paper test:
home, lower the nozzle in small
steps onto a sheet of paper until it
just drags, and tell the printer
that *this* is zero. `PROBE_CALIBRATE`
walks the operator through exactly
that conversation and saves the
answer.

Hold the shape of it: the offset is
a measured property of *your* probe,
*your* mount and *your* nozzle,
today. Change the nozzle and it
changes. This is the second number
in the guide, after pin names, that
you never copy from another machine.

## The mesh: a map, not a repair

One point is not a surface. **Bed
mesh** probing (`BED_MESH_CALIBRATE`)
touches the bed in a grid — 5×5,
7×7, more for a big plate — and
builds a height map, which klippy
then follows during a print: the
whole toolhead rides up and down by
fractions of a millimetre, keeping
the nozzle's distance to the surface
constant across a bed that is level
in no place and flat in fewer.

Read a mesh the way the chapter
intends and it is a diagnostic, not
just a correction. A smooth tilt
says the bed needs levelling at its
screws first — a mesh can follow a
tilt, but a first layer laid on a
slope is still laid on a slope, and
the knobs are free. A local crater
or peak says something is under the
plate, or the plate is sprung. A
mesh that changes between runs says
the probe, its mount, or the bed's
temperature is not stable — and no
density of grid points fixes an
unrepeatable measurement.

The honest limit, stated before
chapter 14 repeats it: **a mesh
compensates for the bed you have; it
does not give you a different bed.**
It spends its accuracy in the first
layers and fades out with height
(the `fade` settings exist precisely
so tall prints are not printed
leaning). Level first, with screws
and patience; probe second; mesh
third. Readers who keep that order
rarely fight their first layer.

What the lab can honestly add is
small but real: the invented
printer's config homes Z against a
fixed endstop (chapter 5), so the
transcripts' Z zero is the switch's
word, not the bed's. Every claim in
this chapter beyond that is the
documentation's, labelled.
