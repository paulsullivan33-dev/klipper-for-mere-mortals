#!/usr/bin/env bash
# run-live.sh — start Klipper's two halves for real: the
# compiled Linux-process MCU (a normal program pretending
# to be the printer board) and klippy, the host brain.
# Then ask klippy four questions over its API socket with
# api_probe.py, show the two logs' key lines, and shut
# both halves down.
#
# Set KLIPPER to your Klipper clone (with out/klipper.elf
# already built — chapter 4) and PY to the venv python
# that has klippy's requirements installed.
set -u
KLIPPER=${KLIPPER:?set KLIPPER to your Klipper clone}
PY=${PY:?set PY to the venv python}
LAB=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
RUN="$LAB/.run"
rm -rf "$RUN"; mkdir -p "$RUN"
rm -f /tmp/klipper_host_mcu

echo "\$ klipper.elf &   (the simulated microcontroller)"
"$KLIPPER/out/klipper.elf" > "$RUN/mcu.log" 2>&1 &
MCU_PID=$!
for _ in $(seq 1 50); do [ -e /tmp/klipper_host_mcu ] && break; sleep 0.2; done
echo "\$ ls -l /tmp/klipper_host_mcu"
ls -l /tmp/klipper_host_mcu

echo "\$ klippy.py printer.cfg -a api.sock -l klippy.log &"
"$PY" "$KLIPPER/klippy/klippy.py" "$LAB/printer.cfg" \
    -a "$RUN/api.sock" -l "$RUN/klippy.log" &
KLIPPY_PID=$!
for _ in $(seq 1 75); do [ -S "$RUN/api.sock" ] && break; sleep 0.2; done
sleep 3

echo "\$ python3 api_probe.py api.sock"
"$PY" "$LAB/api_probe.py" "$RUN/api.sock"

echo "\$ cat mcu.log"
cat "$RUN/mcu.log"
echo "\$ grep -m1 'Git version' klippy.log"
grep -m1 "Git version" "$RUN/klippy.log"

kill $KLIPPY_PID $MCU_PID 2>/dev/null
wait 2>/dev/null
rm -rf "$RUN"
