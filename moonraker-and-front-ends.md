# Moonraker and the Front Ends

You finish this chapter able to draw
the layer between a browser and
klippy, say what Moonraker adds that
klippy does not have, and choose
between the two common front ends
with your eyes open. This layer is
**documented only** in the lab — the
lab spoke to klippy's API directly,
which turns out to be the honest way
to see what the layer is for.

## What klippy exposes

Klippy's **API socket** is a channel
on the host machine: programs connect
and exchange small JSON messages —
a request (`info`, `objects/query`,
`gcode/script`), a reply, and a
stream of notifications as the
printer's state changes. The lab's
`api_probe.py` is forty lines of
exactly that, and transcript
`klipper-lab/transcripts/t01-live-pair.txt`
is it working: the state report, an
`M115` answered, an object query
returned as data. Nothing about the
exchange is web-shaped — no HTTP, no
browser, no files. Klippy is a
printer engine with a socket, and it
stops there on purpose.

## Moonraker: the missing middle

**Moonraker** is a separate program
that lives on that socket as a
permanent client and re-serves
everything as a web API. What it
adds is everything about *being a
service* that an engine should not
carry:

- **Files.** Upload a G-code file,
  list the folder, start a print —
  Moonraker holds the files and feeds
  klippy; klippy never sees a
  directory.
- **History and state.** Past prints,
  durations, filament used, reprint
  buttons — kept across restarts.
- **The machine around the printer.**
  Webcam streams, host temperatures
  and updates, power devices, and the
  update manager that keeps Klipper,
  Moonraker and the front ends
  current together.
- **A door for everything else.**
  Slicers "print" to it directly;
  phone apps, dashboards and
  timelapse tools all speak its HTTP
  or websocket API instead of
  klippy's rawer one.

When a front end shows a temperature
graph, the data travelled sensor →
MCU → klippy → Moonraker → browser.
Four hops, each one chapter 3's
division of labour holding.

## Mainsail and Fluidd

The two standard faces are both web
pages served on the host, both free,
both driving the same Moonraker API:

- **Mainsail** is the project's
  favoured default: a clean,
  considered interface, conservative
  about adding features, with
  presets and a console that stays
  close to klippy's own vocabulary.
- **Fluidd** grew from the community
  side: denser, more configurable,
  fond of showing everything at
  once, with strong file and job
  management.

Choosing between them is choosing a
dashboard, not a driver — the same
printer, config and prints underneath,
and switching costs an afternoon of
muscle memory, nothing more. What
both give you over the raw socket is
the working surface of Klipper
ownership: the console where chapters
6, 9 and 10's commands are typed, the
config editor where chapter 5's file
is maintained (with restarts a button
away), and the emergency stop that is
always on screen — a front-end
feature with a safety chapter's
weight (chapter 14).

## Why the lab skipped it, and when you shouldn't

Driving the API by hand taught what
the layer *is*; nobody should run a
real printer that way. Install the
front end (KIAUH, chapter 4, installs
Moonraker and your pick together),
do the first checks of chapter 6 in
its console so the answers are the
ones you'll recognise later — and
keep one fact from this chapter in
front of you when something looks
wrong in the browser: the front end
displays the printer, it does not run
it. A frozen page is a window stuck,
not a print stopped, and the API
socket will still answer a small
program that asks politely.
