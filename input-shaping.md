# Input Shaping

You finish this chapter able to
explain what ringing is, where the
numbers in an `[input_shaper]` section
come from, and how a value gets
changed at run time — with the lab's
real record of its shaper values being
accepted. Measuring a real machine's
resonance is **documented only**; no
accelerometer existed in the lab, and
`criteria.md` says so.

## Ringing, in the part

Print a test tower with sharp corners
at speed and the walls show it:
ripples after every corner, fading
with distance, like the wake of a
boat. The frame and belts are
springs; each sharp change of
direction starts them vibrating at
the machine's natural **resonant
frequency**, and the extruder lays
plastic onto a toolhead that is still
swinging. The ripples' spacing is
the speed divided by the frequency —
which is why a flaw can be measured
with a ruler, and why the fix can be
a number.

## The counter-move

Chapter 2 gave the idea: shape the
input. Instead of one sharp command,
klippy issues a short train of
smaller ones, spaced by the resonant
period, so each new vibration starts
out of phase with the last and they
sum to stillness. The toolhead takes
a fractionally longer path through
the corner and arrives *calm*. The
cost is real and chapter 14 keeps it
honest: shaping rounds what it
touches, so an over-shaped machine
trades ripples for soft corners. It
is a cancellation, not a cure for a
loose belt — a mechanically sound
printer needs less of it.

The settings name a **shaper type**
and a **frequency** per axis:

```ini
[input_shaper]
shaper_type_x: mzv
shaper_freq_x: 42.0
shaper_type_y: mzv
shaper_freq_y: 38.0
```

The types — `zv`, `mzv`, `zvd`,
`ei`, `2hump_ei`, `3hump_ei` — are a
ladder: the later ones cancel across
a wider band of frequencies (kinder
to a measurement that was slightly
off, or a resonance that wanders)
and round corners a little more.
`mzv` is the common recommendation;
the frequencies in hertz are the part
that belongs to one machine, on one
day, with one toolhead weight.

## Where the frequency comes from

Two honest routes, both from the
project's documentation. The **test
print** route prints a ringing tower
at increasing speeds, and the reader
measures the ripples before and
after a marked height and computes
the frequency from the spacing — a
ruler, a formula, no extra hardware.
The **accelerometer** route tapes a
small sensor (an ADXL345 is the usual
one) to the toolhead and runs
`SHAPER_CALIBRATE`, which sweeps the
machine through frequencies, records
the shaking, and *recommends* a
shaper type and frequency per axis
from the graphs. It is the better
instrument and the usual one on
machines that live fast; it is also
wholly outside this lab, and nothing
in this chapter pretends the lab's
42 and 38 Hz were measured. They are
plausible placeholders, chosen so the
machinery could be exercised.

## The lab's check: values in force

What the lab could prove, it did
(transcript
`klipper-lab/transcripts/t03-batch-tuning.txt`):
the config's values load at startup,
and new ones can be set at run time —
`SET_INPUT_SHAPER SHAPER_FREQ_X=45
SHAPER_FREQ_Y=41` — whereupon klippy
logs what is now in force:

```text
INFO:root:shaper_type_x:mzv shaper_freq_x:45.000 damping_ratio_x:0.100000
INFO:root:shaper_type_y:mzv shaper_freq_y:41.000 damping_ratio_y:0.100000
```

That log line is the check to
remember on a real machine: after any
shaping change — a config edit, a
calibration, a macro that sets values
per filament — ask, and read what the
planner *believes*, not what you
intended to type. A shaper at 0 Hz
or absent entirely is shaping that
silently is not happening, and the
walls will say so before the log
does. Set, read back, then print.
