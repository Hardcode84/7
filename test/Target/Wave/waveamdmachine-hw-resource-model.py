# RUN: %python %s

from __future__ import annotations

import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
OPS_TD = ROOT / "include/mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineOps.td"


def main() -> int:
    text = OPS_TD.read_text()
    ops = re.finditer(
        r"def\s+(WaveAMDMachine_\w+Op)\b(?P<body>.*?)(?=\ndef\s+WaveAMDMachine_\w+Op\b|\Z)",
        text,
        re.S,
    )
    errors: list[str] = []
    for match in ops:
        name = match.group(1)
        body = match.group("body")
        if (
            "Exec" in name
            and "WaveAMDMachine_ReadsExec" not in body
            and "WaveAMDMachine_WritesExec" not in body
        ):
            errors.append(f"{name} lacks EXEC resource traits")
        if ("M0" in name or "$m0" in body) and "WaveAMDMachine_M0" not in body:
            errors.append(f"{name} lacks M0-typed operand/result")
    if errors:
        print("\n".join(errors))
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
