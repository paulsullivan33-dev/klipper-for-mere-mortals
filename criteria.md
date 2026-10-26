# Writing criteria for this guide

Every "for Mere Mortals" guide is written to the same nine-point
standard, so a reader who trusts one can trust the rest. Here it
is, with the verification notes for this particular guide below.

1. **Fix it first.** Reader outcomes lead, not action items: each
   chapter opens by naming the outcome it delivers, shows a check
   the reader can run to confirm they got it, and a reasonable
   reader finishes able to state what was done, what it means,
   and what to try next.
2. **Plain language.** Short sentences, everyday vocabulary,
   technical terms defined on first use. No slang, and no
   idioms that only make sense in one country — the reader may
   be translating as they go.
3. **No dead ends.** A guide never tells the reader to do
   something it cannot show them how to verify. Every claim a
   reader relies on — an install, a command, an output — is
   something this guide demonstrates or clearly labels
   documented-only below.
4. **Live-verified where it matters.** Procedures are run for
   real in the guide's lab wherever the build machine allows it,
   and the transcripts kept in the repository are the evidence.
   What could not be run is listed honestly below, never
   presented as if it had been.
5. **General audiences.** Nothing in this guide — examples,
   fixtures, names, addresses — is modelled on any particular
   reader or author's real life, network, or organisations.
   The lab's printer is invented, and exists only as a file.
6. **Standalone.** A reader needs this guide, its lab, and
   nothing else. Where another guide would genuinely help, it
   is pointed to once, by name, and the chapter still completes
   without it.
7. **Honest about limits.** Chapter 14 names what the tool
   cannot do: a host that must never sleep, a config file that
   is a claim rather than a measurement, simulation that proves
   logic and nothing physical, calibration that cancels faults
   instead of repairing them, and documentation that moves
   faster than any book.
8. **The safety rule is in the text, early.** The README and
   chapter 1 state it plainly — *firmware commands real motion
   and real heat, and thermal protection is not optional* —
   before any procedure depends on it, and chapter 14 states
   the full set as rules: working sensors with honest limits,
   a shutdown treated as an order, config changes made one at
   a time with the previous file kept, no unattended heating,
   and mains electricity out of bounds.
9. **Builds clean.** The site builds with MkDocs in strict mode
   with no warnings, and a fresh reader following the chapters
   in order reaches the stated outcome of each.

## Verification notes for this guide

The build machine is a 2-CPU, 7.7 GB Ubuntu 24.04 sandbox.
Klipper **ee2c6fb** (a clone of the project's repository,
2026-10-21) was built there for its own **Linux process**
target, and its host side ran on Python 3.12.3 in a fresh
virtual environment, against one invented printer
(`klipper-lab/printer.cfg`: a generic Cartesian machine,
220 x 220 x 250 mm, single Z leadscrew). All transcripts
live in `klipper-lab/transcripts/`; the lab's own programs
are `klipper-lab/run-live.sh` and `klipper-lab/api_probe.py`.

Run for real, with transcripts as evidence:

- The MCU build itself: the Linux process configuration
  from the project's test configs, `make`, and the two
  products — `out/klipper.elf` (883 KB) and
  `out/klipper.dict` (t00).
- The live pair: the compiled board firmware started as a
  process, created its `/tmp/klipper_host_mcu` link, and
  klippy connected to it, identified the firmware as its
  own build (version ee2c6fb, matching in klippy's log, the
  API info report and the M115 reply), and sent it the
  lab's full config (t01).
- The API socket exercised with a program the lab wrote:
  the `info` report, `gcode/subscribe_output`, an `M115`
  script answered with the firmware name and version, and
  an `objects/query` for toolhead position and both
  heater temperatures (t01).
- Klippy's batch mode (the project's own mechanism for
  driving the simulated board from the build's
  dictionary) running the lab's config end to end:
  config accepted, position reported at zero, `G28`
  homing all three axes, planned moves to X100 Y100 Z10,
  and the START_PRINT macro homing and parking the
  toolhead at X5 Y5 Z5, exit status 0 (t02).
- Runtime tuning accepted and logged as in force:
  `SET_PRESSURE_ADVANCE ADVANCE=0.060` and
  `SET_INPUT_SHAPER` frequencies of 45/41 Hz, plus a
  0.10 mm Z gcode offset visible in the position
  report (t03).
- Failure behaviour, staged and real: one mistyped pin
  (`gpio999`) refused at startup with
  "Pin 'gpio999' is not a valid pin name on mcu 'mcu'",
  exit 255 (t04); and a move before homing refused with
  "Must home axis first", exit 255 (t90).

Documented only — described from the project's
documentation, not run, and the text does not claim
otherwise:

- The live run's honest boundary: the simulated board
  shut down at the extruder's temperature sensor —
  "Unable to open adc device" — because its analogue
  pins read a real IIO device (`/sys/bus/iio/...`) and
  its digital pins a real GPIO chip (`/dev/gpiochip*`),
  and the sandbox has neither. Klippy therefore never
  held a "ready" live printer in this lab; the movement
  transcripts (t02, t03) are batch-mode runs against
  the same firmware build's dictionary, which simulates
  the board's replies. The text says which is which
  wherever the evidence is used.
- Flashing a real board, KIAUH and MainsailOS installs,
  and the per-board menus of `make menuconfig` (the lab
  built one target, from the project's shipped config
  for it).
- Real homing behaviour and endstop wiring; probes,
  `PROBE_CALIBRATE` and bed mesh calibration (chapter 8
  is judgement taught from the documentation — no probe
  existed in the lab).
- Resonance measurement with an accelerometer,
  `SHAPER_CALIBRATE`, and the ringing-tower test print:
  chapter 9's shaper values are plausible placeholders
  that let the commands be exercised, and the chapter
  says they were not measured.
- The pressure-advance tuning print (chapter 10): the
  lab set and read back values; it melted no plastic.
- Moonraker, Mainsail and Fluidd in a browser
  (chapter 12): the lab used klippy's API socket
  directly, which is the layer those tools are built
  on, and says so.
- Printing an actual part, and everything in chapter 14
  that only a physical machine can teach.

Fixtures are this guide's own and deliberately generic:
one invented Cartesian printer whose every value is a
typical sample rather than a measurement, two small
macros, and G-code scripts that move a simulated
toolhead and heat nothing. No example is modelled on
any real person, printer, workshop or organisation,
and nothing physical was ever connected, powered or
heated by the lab.
