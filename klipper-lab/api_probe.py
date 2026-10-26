#!/usr/bin/env python3
"""api_probe.py — ask klippy questions over its API socket.

Connects to the unix socket klippy was started with (-a),
sends a handful of JSON requests, and prints every reply
verbatim. Written for the Klipper guide's lab so the
transcript is the program's real output, not a retelling.

Usage: api_probe.py /path/to/api.sock
"""

import json
import socket
import sys
import time


def main():
    path = sys.argv[1]
    conn = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
    conn.connect(path)
    conn.settimeout(0.5)

    requests = [
        {"id": 1, "method": "info"},
        {"id": 2, "method": "gcode/subscribe_output"},
        {"id": 3, "method": "gcode/script", "params": {"script": "M115"}},
        {"id": 4, "method": "objects/query",
         "params": {"objects": {"toolhead": ["position"],
                                "motion_report": ["live_position"],
                                "extruder": ["temperature"],
                                "heater_bed": ["temperature"]}}},
    ]
    buf = b""
    for req in requests:
        conn.sendall(json.dumps(req).encode() + b"\x03")
        print(">>> sent:", json.dumps(req))
        # Collect whatever comes back for a moment.
        wait_until = time.time() + 2.0
        while time.time() < wait_until:
            try:
                data = conn.recv(65536)
            except socket.timeout:
                continue
            if not data:
                break
            buf += data
            while b"\x03" in buf:
                raw, buf = buf.split(b"\x03", 1)
                if raw.strip():
                    print("<<< recv:", raw.decode(errors="replace"))
    conn.close()


if __name__ == "__main__":
    main()
