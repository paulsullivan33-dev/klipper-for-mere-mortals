# Installing Klipper

You finish this chapter knowing the
shape of a real install — what goes
where, in what order, and where the
traps are — and having seen the one
part of an install this guide's lab
could perform for real: building the
board firmware itself.

A real install has four movements.
This chapter names all four, teaches
the decisions inside them, and is
honest about which ones the lab
demonstrated. The lab had no printer
and no Raspberry Pi, so movements
one, three and four are **documented
only**, taught from the project's own
installation guide. Movement two —
building the firmware — the lab did,
for the one target that needs no
hardware: the project's simulated
board. Its transcript is real.

## 1. The host (documented only)

Klippy needs a small always-on Linux
computer. The standard choice is a
Raspberry Pi running the project's
own image, **MainsailOS** (a Pi OS
with Klipper, Moonraker and Mainsail
preinstalled), written to a card with
the Pi Imager like any other Pi
system. Any modest Linux box works;
the requirements are a reliable USB
or serial link to the board and a
machine you will not also use as a
gaming rig — chapter 2 explained why
the host's spare attention is part of
the printer's timing.

## 2. Building the board firmware

The firmware is compiled per chip,
not per printer. The tool is the
familiar embedded one: inside a clone
of the project, `make menuconfig`
opens a menu where you choose the
board's processor family and its
connection details (USB, serial, CAN),
and `make` produces the firmware file
plus the **dictionary** — the table
that lets klippy speak this build's
exact dialect. Keep both; a klippy
that cannot find a matching
dictionary cannot talk to the board.

The lab built the project's own
practice target, the **Linux process**
build — the same C firmware compiled
to run as an ordinary program, which
the project ships so the firmware can
be exercised without a board
(transcript
`klipper-lab/transcripts/t00-build.txt`):

```bash
git clone https://github.com/Klipper3d/klipper.git
cd klipper
cp test/configs/linuxprocess.config .config
make olddefconfig
make -j2
```

```text
Version: ee2c6fb
  Linking out/klipper.elf
$ ls -la out/klipper.elf out/klipper.dict
-rw-rw---- 1 root root   12515 out/klipper.dict
-rwxrwx--- 1 root root  883424 out/klipper.elf
```

Check: `out/klipper.elf` is the
firmware as a program, `out/klipper.dict`
its dictionary. Every real board build
ends at the same pair of artefacts,
with a board-specific binary in place
of the `.elf`.

Klippy itself is Python. The lab's
environment, and the one the project
installs on a real host:

```bash
python3 -m venv ~/klippy-env
~/klippy-env/bin/pip install -r klipper/scripts/klippy-requirements.txt
```

## 3. Flashing the board (documented only)

The built firmware is written to the
board by whatever door that board
provides: an SD card it reads at boot,
a USB bootloader, or a serial flasher.
This is the step with real teeth —
the wrong build leaves a board that
does nothing until it is flashed
again, and some boards make the
second attempt harder than the first.
The project's documentation covers
each supported board; follow it for
*yours*, identify the board out loud
before you write anything to it, and
never flash a board that is currently
the only thing keeping a heater off.
Klipper cannot help a board it has
not reached yet, and neither can this
guide.

## 4. The helper: KIAUH (documented only)

Most people do not assemble the host
side by hand. **KIAUH** (the Klipper
Installation And Update Helper) is a
menu-driven script that installs and
updates klippy, Moonraker, the front
ends and extras on a Pi-class host,
and keeps them updated together. It
is the route this guide recommends
for a first real install, with one
caution: a helper that hides the
pieces can hide the model too. Read
chapter 3 first; when KIAUH's menu
says *Moonraker*, you should already
know which piece that is and why it
is separate.

However it was installed, an install
is finished when chapter 6's checks
pass: klippy starts on your config
without an error, the board answers,
and the temperatures it reports at
rest are the temperature of the room.
Everything before that is assembly.
