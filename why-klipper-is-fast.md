# Why Klipper Is Fast

You finish this chapter able to explain
the two distinct senses in which
Klipper is "fast" — thinking further
ahead, and cancelling vibration — and
able to tell them apart when someone
credits the wrong one.

## Looking ahead

A printer rarely moves in straight,
constant lines. It accelerates out of
corners, slows into them, and spends
much of a print changing speed. Doing
that well means knowing what comes
*after* the current move while you are
still in it: a corner can only be
taken at the speed the *next* segment
allows.

Firmware on a small chip plans a
handful of moves ahead, because memory
and arithmetic are scarce. Klippy, on
a real computer, plans with a generous
**lookahead**: it reads the coming
moves as one journey, works out entry
and exit speeds for every junction,
and hands the board a finished
schedule of pulses with clock times
attached. The board's job shrinks to
playing the schedule back, exactly —
a job it can do perfectly even though
it could never have composed it.

The board and the computer stay in
step through a shared sense of time.
Klippy measures the board's clock,
translates its own plans into that
clock's ticks, and keeps a queue of
scheduled moves deep enough that a
brief hiccup on the computer — a log
written, a network packet answered —
never starves the printer. This is
also why Klipper is honest about its
host: a computer that is overloaded
by other work can eventually miss,
and chapter 14 names the host's
health as part of the printer's
health.

Check: the lab's batch run (transcript
`klipper-lab/transcripts/t02-batch-checks.txt`)
shows the schedule in the small. After
homing, one line — `G1 X100 Y100
F3000` — becomes, in klippy's own
report, tens of thousands of counted
steps per motor (the `mcu:` line of
the position report: -26800 steps on
X and Y), planned as a single smooth
journey from rest to 50 mm/s and back
to rest at exactly (100, 100).

## Cancelling vibration

The second kind of fast is different,
and it is the one Klipper is famous
for. A printer's frame and belts are
springs. Every sharp change of
direction excites them, and the part
shows it as **ringing** — ghost
ripples trailing every corner and
hole, the signature of a machine
asked to move faster than its frame
settles.

You cannot stiffen the frame in
software. But the vibration is
predictable: it rings at a frequency
the machine has whether you measure
it or not. **Input shaping** exploits
that. Instead of commanding one sharp
move, klippy commands a short
sequence of smaller moves, timed so
that the vibration from the first is
cancelled by the vibration from the
later ones — pushing a child's swing
at exactly the moment that stops it.
The toolhead ends the move still, at
print speeds that would otherwise
leave the walls rippling.

That is the honest version of the
slogan. Klipper does not make a
printer's motors stronger or its
frame stiffer; it removes the
*penalty* for speed that vibration
imposed, up to the limits the frame
still sets. Chapter 9 covers how the
frequency is found (an accelerometer,
a test pattern, or a careful guess)
and shows the lab's shaper values
being set and read back.

Keeping the two apart matters when
you read other people's claims. A
print that finished sooner because
the planner stopped slowing for every
corner is lookahead at work. A print
that stayed clean at speeds that used
to ripple is shaping. Klipper does
both, on hardware that often costs
less than the printer it is driving —
because the expensive part, the
thinking, moved to a computer that
was already cheap.
