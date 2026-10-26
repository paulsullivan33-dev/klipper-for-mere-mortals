# What Klipper Is

You finish this chapter able to say
where a Klipper printer's thinking
happens, where its timing happens, and
why the two were ever separated.

A conventional printer runs **firmware**
(the software burned into the machine,
in the family of Marlin) entirely on
the printer's own **control board** —
a small microcontroller, chosen to be
cheap and reliable, with about as much
thinking power as a microwave oven's
clock. That chip must do everything at
once: read the print file, decide how
the toolhead should move, and deliver
every motor pulse on time. It copes —
Marlin-copes, millions of printers
cope — but it copes by planning only a
few moves ahead and by keeping its
mathematics simple. When a move gets
complicated, the ceiling it hits is
not the motors. It is the arithmetic.

**Klipper moves the arithmetic.** The
planning — reading the file, working
out speeds, curves and timing for
whole sequences of moves — is done by
a program called **klippy**, running
on a real computer: usually a
Raspberry Pi or similar single-board
computer wired to the printer, always
awake next to it. What stays on the
printer's board is a much smaller
program, the **MCU firmware** (MCU is
**microcontroller unit**, the board's
chip), whose whole job is to receive a
schedule — *pulse this motor, this
many times, starting at this clock
tick* — and execute it exactly. The
board stops being the brain and
becomes the metronome.

Three consequences follow, and they
are the reasons people convert
printers that were working fine.

**The planning gets better.** A real
computer can look far ahead through
the queue of moves, smooth the path
through corners, and do mathematics
that a microwave-clock chip cannot
afford — including the vibration
cancellation of chapter 9. Chapter 2
takes this apart.

**The printer becomes a file.** In
most firmware, what the printer *is* —
its size, its motors, its sensors —
lives in the firmware, set when the
firmware was compiled. In Klipper it
lives in a plain text file,
`printer.cfg`, which klippy reads at
startup. Change the file, restart,
and the printer is changed. No
recompiling, no reflashing for a new
bed size or a different probe.
Chapter 5 reads that file the way
this guide believes it should be
read: slowly, with every value's
unit named.

**The board gets simpler, and can be
several.** Because the board's job
shrank to timing, one computer can
run several boards at once — the main
board, a toolhead board, a display
board — each just another metronome
following the same schedule. It also
means old, modest boards gain a
second life: the expensive thinking
moved off them.

The safety rule belongs here, before
any procedure depends on it, because
the split does not soften it:
**firmware commands real motion and
real heat.** Klippy's plans end in a
physical machine that can drive a
toolhead into its own bed, grind a
motor against a frame, or hold a block
of aluminium at 250 degrees. A number
typed into `printer.cfg` is not an
opinion; it is an instruction the
machine will try to obey. This guide's
lab ran everything against a
simulator precisely so that its
mistakes — and it made some, and kept
the transcripts — happened to a
program, not to a printer. Chapter 14
collects the safety rules as rules.
Treat them as part of the tool,
because they are.

One check before you move on. If the
split is clear, you can answer this:
your printer is mid-print and the
little computer beside it freezes
solid. What does the printer do? It
finishes the moves already scheduled
— seconds' worth, no more — and then
stops, because the metronome has run
out of music. The board never knew
the plan. That is the shape of the
whole system, and the rest of this
guide is detail hung on it.
