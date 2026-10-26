# The Neighbours

You finish this chapter able to place
Klipper among the tools it is most
often compared with, and to say —
without tribal feeling — which jobs
each of them is genuinely the right
answer for.

## Marlin: the whole brain, on the board

**Marlin** is the firmware most
printers ship with: the planner, the
scheduler and the driver in one
program on the control board, no host
computer at all. The comparison is
not close-vs-far versions of one
idea; it is two architectures. Marlin
asks one small chip to do everything
and does it remarkably well —
millions of printers, decades of
accumulated printer-specific
knowledge, and a machine that is a
printer the moment it is switched on,
owing nothing to anything beside it.

Choose Marlin when the printer should
be an appliance: no second computer
to keep alive, no host to update, no
socket to secure. Accept its shape:
settings live in the firmware (so
changing hardware means a rebuild or
the subset Marlin exposes on its
screen), planning is short-horizon,
and input shaping — recent Marlin has
a fixed-time form of it — is a
simpler instrument than chapter 9's.
Choose Klipper when the thinking is
the point: the config as a file, the
long lookahead, the measured
calibrations, the multi-board reach.
A great many owners run both across
different machines and feel no need
to reconcile the fact.

## OctoPrint: a host, not a firmware

**OctoPrint** is often named beside
Klipper and does a different job: it
is a host program that feeds G-code
to a printer *still running its own
firmware* (usually Marlin) over USB,
and provides the web interface,
camera and plugin world around it.
The planning stays on the board; the
streaming is the host's problem —
and at high speeds the serial stream
itself can become the bottleneck
Klipper was designed to remove.

The two are not enemies and are even
combined (OctoPrint can front a
Klipper printer through a plugin),
but the modern Klipper stack —
Moonraker plus Mainsail or Fluidd —
covers OctoPrint's ground for Klipper
owners, which is why chapter 12
taught that pair. OctoPrint remains
the right answer for a Marlin printer
that deserves a good host, and its
plugin ecosystem is the deeper one.

## Vendor firmware: the printer as shipped

Manufacturers ship their own firmware
(increasingly, closed builds *of*
Klipper or Marlin, tuned to one
machine). Its virtues are real: it
matches the hardware exactly, the
first print is minutes away, and
support can assume it. Its limits
are the mirror of this guide's
themes: the config is not yours to
read, calibration tools are what the
vendor chose to expose, and updates
arrive on the vendor's schedule or
not at all.

The honest summary this chapter owes
you: converting a printer to mainline
Klipper is trading a warranty-shaped
certainty for a file you own and can
read. For a printer that prints
happily as shipped, that trade may be
a poor one. For a printer you intend
to modify, repair for a decade, or
understand — the trade is the hobby.

## RepRapFirmware, briefly

One more neighbour deserves a
sentence: **RepRapFirmware**, running
on Duet boards, keeps the brain on a
*capable* board — object-model
configuration in files, strong
motion control, no separate host.
It is proof the industry has more
than one good answer to "where should
the thinking live", and readers
choosing a from-scratch build should
know it exists.
