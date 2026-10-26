# Troubleshooting

You finish this chapter able to work
the four failures this guide's lab
actually met — because a
troubleshooting list written from
real transcripts beats a longer one
written from imagination — plus the
method that produced them: read the
message, name the piece (chapter 3),
fix the cause, restart last.

## "Printer is shutdown", with a reason attached

**Symptom.** Klippy answers, but the
state is `shutdown` and nothing
moves. **The lab's case** (transcript
`klipper-lab/transcripts/t01-live-pair.txt`):
the info report's message said *MCU
'mcu' shutdown: Unable to open adc
device*, and the board's own log had
one line — `Got error -1 in analog
open`. The simulated board could not
open the temperature sensor's
hardware, because the sandbox has no
analogue device for it. **On a real
machine** the same shape means a
sensor disconnected, shorted, or
assigned to the wrong pin: klippy
names the sensor, and the config's
`sensor_pin`/`sensor_type` lines are
the first suspects. **Rule:** the
shutdown message is the diagnosis,
not an obstacle. Fix the cause, then
`FIRMWARE_RESTART`; a restart that
only re-meets the fault will say so
identically.

## The config that will not load

**Symptom.** Klippy stops at startup
with a config error. **The lab's
case** (transcript
`klipper-lab/transcripts/t04-broken-config.txt`):
one pin mistyped as `gpio999` and the
whole startup ends —

```text
configparser.Error: Pin 'gpio999' is not a valid pin name on mcu 'mcu'
(exit status: 255)
```

**Reading it:** the error names the
value, the kind of thing it should
have been (a pin name *on that MCU*),
and the board. Check, in order: the
pin exists in that board's
documentation; it is written in that
board's vocabulary (the same board
family may spell pins `PA1`, `gpio2`
or `ar29`); and it is written in the
right section — a correct pin in the
wrong stepper's block loads cleanly
and misbehaves physically, which is
worse. Keep the previous config
beside you; a `diff` between the
file that loaded and the file that
didn't is the fastest reading in
this book.

## "Must home axis first"

**Symptom.** A move is refused with
*Must home axis first* (transcript
`klipper-lab/transcripts/t90-move-before-homing.txt`).
**Cause:** exactly what it says —
klippy does not know where the
toolhead is, and chapter 7 explains
why it will not guess. **Fix:** `G28`,
and note *why* the machine was
unhomed: a fresh start is innocent;
mid-session, it means a shutdown, a
motor power loss, or a `M84` happened
earlier and went unread. Homing
fixes the position; only reading
fixes the habit.

## The macro that says "Unknown command"

**Symptom.** A macro runs partway and
reports a command klippy does not
know — the lab's first `START_PRINT`
met it on `RESPOND`. **Cause:** the
command belongs to an optional module
that the config has not switched on
(`RESPOND` needs a `[respond]`
section; other commands have their
own). **Fix:** add the section the
project's config reference names for
that command, restart, and rerun the
macro against the simulator or a
homed, empty machine before it ever
introduces a print. A macro is a
program; chapter 11's warning stands:
read strangers' macros like configs,
because klippy will run them like
one.

## Temperatures that lie

**Symptom.** A cold printer reports a
hot (or impossible) temperature, or
klippy refuses to start over a
reading outside limits. **Causes, in
order of likelihood:** the wrong
`sensor_type` for the thermistor
fitted; a sensor unplugged (reads as
an extreme, by design); a short in
fine sensor wires; a `sensor_pin`
that belongs to another board on a
multi-board machine. **Rule:**
chapter 6's check — at rest, every
reading should equal the room. When
it doesn't, believe the disagreement,
not the number, and do not widen
`min_temp`/`max_temp` to make the
printer start (chapter 14). The
limits refusing is the protection
working on the only evidence it has.

## And when it is none of these

Klippy keeps a log (`klippy.log`) that
records the config it loaded, the
firmware it found and every shutdown
with its cause; the front ends keep
it one click away. Read the *last*
event, not the first fifty lines.
Work out which piece owns the fault
(chapter 3's table), change one
thing, and test with the printer
empty, homed, and watched. That
method — unglamorous, sequential,
one variable at a time — is the
chapter, and everything above is
just where it has been.
