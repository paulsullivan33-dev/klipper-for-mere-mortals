# printer.cfg, Section by Section

You finish this chapter able to read
a real `printer.cfg` top to bottom and
say what every section promises, what
every value's unit is, and which lines
you would never copy from someone
else's file. The worked example is
this guide's own lab config,
`klipper-lab/printer.cfg` — an
invented, generic Cartesian printer.
It ran, against the simulator, exactly
as printed here; its transcripts are
the checks.

## The shape of the file

The file is a list of **sections**. A
section starts with a header in square
brackets — `[stepper_x]` — and
continues with `name: value` lines
until the next header. Klippy reads
the whole file at startup. A section
it does not recognise, a value it
cannot parse, or a pin name the board
does not have each stop the startup
with an error naming the culprit —
chapter 15 shows one, caught live.
There is no partial credit and no
quiet default for a mistyped line;
the file either describes a printer
klippy believes in, or nothing moves.
That strictness is a favour.

## The motors: [stepper_x], [stepper_y], [stepper_z]

```ini
[stepper_x]
step_pin: gpio2
dir_pin: gpio3
enable_pin: !gpio4
microsteps: 16
rotation_distance: 40
endstop_pin: ^gpio5
position_endstop: 0
position_min: 0
position_max: 220
homing_speed: 50
```

Three pins run each motor. The **step
pin** receives one pulse per step;
the **dir pin** sets direction; the
**enable pin** turns the driver on
(the `!` inverts the signal, as many
boards need; the `^` on the endstop
pin enables a pull-up resistor). Pin
*names* belong to the board — `gpio2`
is the simulator's vocabulary; a real
board's manual names its own. This is
the first line you never copy blind:
the same section for another board
differs here even when every number
below matches.

The numbers carry the machine.
**Microsteps** (16) divide each full
step. **Rotation distance** (40, in
millimetres) is how far the axis
travels in one full motor turn — for
a belt axis, the pulley's
circumference; for the Z **leadscrew**
(the threaded rod that lifts the
gantry), 8, the distance per turn of
the screw. Get rotation distance
wrong and every move is wrong by the
same ratio, calmly and consistently.
**Position min/max** (0 and 220 mm)
are the fence klippy will not plan
past, and **position_endstop** is
where the axis's switch sits in that
same coordinate system. **Homing
speed** is in mm/s — Z homes at 8,
not 50, because Z mistakes are the
expensive kind.

## The hot end: [extruder] and [heater_bed]

```ini
[extruder]
step_pin: gpio14
dir_pin: gpio15
enable_pin: !gpio16
microsteps: 16
rotation_distance: 33
gear_ratio: 3:1
nozzle_diameter: 0.400
filament_diameter: 1.750
heater_pin: gpio17
sensor_type: EPCOS 100K B57560G104F
sensor_pin: analog0
pressure_advance: 0.040
control: pid
pid_Kp: 22.2
pid_Ki: 1.08
pid_Kd: 114
min_temp: 0
max_temp: 250
```

The extruder is a stepper with two
extra jobs. Its rotation distance,
divided by the **gear ratio**, turns
file millimetres of filament into
motor turns — the number calibration
prints exist to measure. And it owns
a **heater** and a **temperature
sensor**: `heater_pin` switches the
heating cartridge, `sensor_pin` reads
the **thermistor** (a resistor whose
value tracks temperature), and
`sensor_type` names which thermistor,
because the conversion from resistance
to degrees is different for each.
**`min_temp` and `max_temp` are the
safety contract**: a reading outside
them — a disconnected sensor reads as
nonsense, not as "cold" — shuts the
printer down rather than heating on a
guess. Never raise `max_temp` to make
an error go away; the error is the
sensor asking for help (chapter 14).

`control: pid` and its three numbers
are how klippy holds a temperature
steady; the project's PID tuning
command exists to measure yours, and
copied values (these are the sample
ones) are a starting point, not a
result. The bed's section is the same
idea with `control: watermark` — a
simpler on/off-with-tolerance scheme
suited to a big slow plate.

## The supporting cast

`[fan]` is one pin and a promise the
part-cooling fan answers to `M106`.
`[input_shaper]` holds chapter 9's
calibration, as plain values:

```ini
[input_shaper]
shaper_type_x: mzv
shaper_freq_x: 42.0
shaper_type_y: mzv
shaper_freq_y: 38.0
```

`[mcu]` is one line in the lab —
`serial: /tmp/klipper_host_mcu`, the
simulated board's address; a real
board gives its USB or serial device
path here instead. `[printer]` closes
the file with the machine's envelope:
**kinematics** (`cartesian` — the
style of motion, three independent
axes), `max_velocity` 300 mm/s,
`max_accel` 3000 mm/s², and separate,
much lower Z limits, because a
leadscrew axis is strong and slow.

## Reading someone else's config

Sample configs are how real installs
start, and they are safe to learn
from if you read them as claims, not
as truth: every pin checked against
*your* board's manual, every limit
checked against *your* machine's
travel, every temperature limit left
at or below the hardware's rating.
The file is the printer. Klippy will
believe exactly what it says — which
is why this chapter, and not a
download, is the middle of the book.
