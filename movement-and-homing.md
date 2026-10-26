# Movement and Homing

You finish this chapter knowing why
Klipper refuses to move a printer it
has not located, what homing actually
establishes, and what the position
report's several sets of numbers each
mean — with the lab's real homing run
as the worked example.

## The refusal comes first

The lab staged the classic first-day
mistake on purpose (transcript
`klipper-lab/transcripts/t90-move-before-homing.txt`).
A fresh start, one innocent line —
`G1 X10 F600`, move X by 10 mm — and:

```text
WARNING:root:Must home axis first: 10.000 0.000 0.000 [0.000]
(exit status: 255)
```

Klippy is not being difficult. At
startup it knows how many steps each
motor has taken since power-on —
nothing — and nothing about where the
toolhead physically is. The bed could
be anywhere under the nozzle. A move
planned from a guessed position is a
crash scheduled politely. So the
rule is absolute: **no motion until
the machine has been located**, and
locating it is homing.

## What homing establishes

**Homing** (`G28`) drives each axis,
slowly and in a chosen order, toward
its **endstop** — a switch (or a
sensorless stall detection, or a
probe) at a known physical place.
The instant the switch triggers, the
unknowable becomes known: *this axis
is at its `position_endstop`.* From
that single fact and the step counts,
every position follows by arithmetic.
Home Z last and gently is the common
order, because Z is the axis whose
mistake digs a nozzle into a bed.

Check: the lab's batch run (transcript
`klipper-lab/transcripts/t02-batch-checks.txt`)
homes the invented printer and then
moves it, and klippy's position
report shows the result of each
stage. After `G28` and two moves, the
report reads:

```text
toolhead: X:100.000000 Y:100.000000 Z:10.000000 E:0.000000
gcode: X:100.000000 Y:100.000000 Z:10.000000 E:0.000000
```

The machine is where it was told to
be, in millimetres, in bed
coordinates. The same report carries
the stepper counts underneath (the
`mcu:` line, tens of thousands of
steps) — the plan and the schedule,
side by side, exactly as chapter 1
promised.

## Reading a position report

`GET_POSITION` prints several sets of
numbers, and they answer different
questions:

- **mcu / stepper** — raw step counts
  per motor. The schedule's view.
- **kinematic** — where the mechanics
  are, after the kinematics maths.
- **toolhead** — where the planner
  believes the nozzle is, in machine
  coordinates.
- **gcode** — where the *file* thinks
  it is: toolhead position plus any
  offsets the user has applied.
- **gcode base / gcode homing** — the
  offsets themselves, and the homing
  origin the current coordinates hang
  from.

When the sets agree, printing is
boring, which is the goal. When they
differ, the difference *is* the
diagnosis: an offset applied
(chapter 10's tuning run sets one,
and its transcript shows the gcode
lines shifted by exactly 0.10 mm),
a homing origin moved, a step lost.
Learn to read the report here, on
numbers a simulator produced, and it
will read plainly on a real machine
at a worse moment.

## Moves, speeds and the fence

Once homed, `G1` moves are planned
against the fence from chapter 5:
`position_min`/`position_max` per
axis, `max_velocity` and `max_accel`
for the machine. A commanded move
past the fence is not clipped
quietly; it is an error, because a
file that asks for 250 mm on a 220 mm
machine is a file that would have
crashed, and quiet clipping would
print it wrong *and* hide why. The
lab's run stays politely inside:
X100 Y100, Z10, and finally the
start-print macro's park at X5 Y5 Z5,
visible as the third position report
in transcript t02.

Homing is also a *repeatable* act,
not a ceremony for birthdays: after
any shutdown, any motor power loss,
any moment of doubt about where the
toolhead is, the answer is the same —
`G28`, and the machine is known
again.
