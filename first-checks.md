# First Checks

You finish this chapter with a short
list of questions to ask a freshly
started Klipper, the healthy shape of
each answer, and one worked example
of an unhealthy answer — this guide's
own — read line by line.

The checks assume klippy is running
with your config. They are the same
whether you send them from a front
end's console, from Moonraker, or,
as the lab did, straight through the
API socket with a small program
(`klipper-lab/api_probe.py`). What
matters is the questions, not the
door you ask them through.

## Is it up, and what does it think it is?

The API's `info` answer reports the
state, the config file in use, and
the software version. The lab's is in
transcript
`klipper-lab/transcripts/t01-live-pair.txt`,
and it is worth reading even though —
especially though — the state it
reports is `shutdown`:

```text
<<< recv: {"id":1,"result":{"state":"shutdown",
"state_message":"MCU 'mcu' shutdown: Unable to open adc device
...
"config_file":".../klipper-lab/printer.cfg",
"software_version":"ee2c6fb", ...}}
```

Three checks hide in that one answer.
The **version matches the firmware
build** — klippy and the board agree
they are `ee2c6fb`, the build from
transcript t00; a mismatch here is a
stale flash, caught in one glance.
The **config file is the one you
meant** — paths get confused exactly
when two printers or two test configs
share a machine. And the **state is
named, with a reason**: `shutdown`
plus the underlying cause, *Unable to
open adc device* — the simulated
board could not open the temperature
sensor's hardware, because the
sandbox has none. On a real machine
the same shape of answer names a
disconnected sensor or a shorted
thermistor, and it is the first thing
to read, not the last.

## Ask the firmware its name

`M115` is the oldest check in 3D
printing: *firmware, identify
yourself.* The lab's simulated board
answered through the API even in its
shutdown state:

```text
// FIRMWARE_NAME:Klipper FIRMWARE_VERSION:ee2c6fb
```

A printer that cannot answer `M115`
is not yet a printer — the link, the
board, or the config is undone, and
no later check means anything until
this one passes.

## Temperatures at rest

Before anything is allowed to heat,
ask what the sensors believe now.
Two ways: `M105` asks for a
temperature report in the reply
stream, and an object query returns
the same numbers as data — the lab's
probe asked for the extruder and bed
temperatures alongside the toolhead
position. In the lab's shutdown state
both read 0.0, which is the
*unconfigured* value, not a
measurement: the board died at the
sensor before it could report one.

On a healthy machine this check has a
precise expected answer, and it is
the most useful sentence in this
chapter: **at rest, every temperature
should read the temperature of the
room.** A nozzle reporting 240° on a
cold printer is not warm; it is lying
— wrong sensor type in the config,
a short, a pin that belongs to
something else — and klippy will
refuse to heat on a sensor it cannot
believe, which is the `min_temp` /
`max_temp` contract from chapter 5
doing its job. Believe the refusal.

## Position: known unknowns

The same query returned the toolhead
position as `[0.0, 0.0, 0.0, 0.0]`.
Do not be comforted by the zeros.
Before homing, position in Klipper is
a *placeholder*: the numbers print
neatly and mean nothing, because
nothing has yet related the motors'
counts to the physical machine.
Chapter 7 is about earning those
numbers. The check that belongs here
is only that the question is
answered at all — the planning half
is alive and talking.

Run these four — state and version,
`M115`, temperatures against the
room, position answered — and you
know whether you have a printer or a
puzzle, and if a puzzle, which piece
is holding it. Every later chapter
assumes them green.
