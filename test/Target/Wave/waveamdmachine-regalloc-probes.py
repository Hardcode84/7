# RUN: wave-opt --waveamd-reg-alloc='debug-probes=true' \
# RUN:     %S/Inputs/regalloc-probe-repro.machine.mlir \
# RUN:   | %python %s

from __future__ import annotations

import re
import sys

LIMITS = {
    "assigned_lane_checks": 40_000,
    "assigned_lane_queries": 40_000,
    "base_fits": 40_000,
    "find_free_base": 1_000,
}


def fail(message: str) -> None:
    print(message, file=sys.stderr)
    raise SystemExit(1)


def get_probe(text: str, name: str) -> int:
    pattern = rf"waveamdmachine\.regalloc_debug_probe_{name} = ([0-9]+) : i64"
    match = re.search(pattern, text)
    if not match:
        fail(f"missing probe counter: {name}")
    value = int(match.group(1))
    if value <= 0:
        fail(f"non-positive probe counter: {name}={value}")
    return value


def main() -> int:
    text = sys.stdin.read()
    if "func.func @regalloc_probe_repro" not in text:
        fail("missing reduced repro function")

    probes = {name: get_probe(text, name) for name in LIMITS}
    for name, limit in LIMITS.items():
        value = probes[name]
        if value > limit:
            fail(f"{name}={value} exceeds limit {limit}")

    if probes["assigned_lane_checks"] > probes["assigned_lane_queries"]:
        fail("lane checks exceed same-register lane queries")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
