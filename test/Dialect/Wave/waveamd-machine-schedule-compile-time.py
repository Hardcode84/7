# REQUIRES: wave-python-bindings
# RUN: %python %s | FileCheck %s

# CHECK: matmul_pressure_disabled: ok
# CHECK: matmul_hard_cap_beam_report: ok
# CHECK: fa_seq32_d16_u4_beam_report: ok

from __future__ import annotations

import re
import subprocess
import sys
import time
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[3]
PYTHON = sys.executable


def dump_tail(label: str, stdout: str, stderr: str) -> None:
    print(f"{label}: stdout tail", file=sys.stderr)
    print(stdout[-4000:], file=sys.stderr)
    print(f"{label}: stderr tail", file=sys.stderr)
    print(stderr[-4000:], file=sys.stderr)


def require(label: str, text: str, pattern: str) -> None:
    if not re.search(pattern, text):
        print(f"{label}: missing pattern: {pattern}", file=sys.stderr)
        raise SystemExit(1)


def reject(label: str, text: str, pattern: str) -> None:
    if re.search(pattern, text):
        print(f"{label}: rejected pattern present: {pattern}", file=sys.stderr)
        raise SystemExit(1)


def run_case(label: str, cmd: list[str], timeout: float) -> str:
    start = time.monotonic()
    try:
        proc = subprocess.run(
            cmd,
            cwd=REPO_ROOT,
            text=True,
            capture_output=True,
            timeout=timeout,
            check=False,
        )
    except subprocess.TimeoutExpired:
        print(f"{label}: timed out after {timeout:.1f}s", file=sys.stderr)
        raise SystemExit(1) from None

    elapsed = time.monotonic() - start
    if proc.returncode != 0:
        print(f"{label}: exit code {proc.returncode}", file=sys.stderr)
        dump_tail(label, proc.stdout, proc.stderr)
        raise SystemExit(proc.returncode)
    print(f"{label}: ok elapsed={elapsed:.2f}s timeout={timeout:.1f}s")
    return proc.stdout + proc.stderr


def matmul_base_cmd() -> list[str]:
    return [
        PYTHON,
        str(REPO_ROOT / "tools/wave-matmul-calibrate/wave-matmul-calibrate.py"),
        "--chip=gfx1100",
        "--m=32",
        "--n=32",
        "--k=64",
        "--bm=1",
        "--bn=2",
        "--variants=scheduled",
        "--skip-hw",
    ]


def fa_base_cmd() -> list[str]:
    return [
        PYTHON,
        str(REPO_ROOT / "tools/wave-fa-calibrate/wave-fa-calibrate.py"),
        "--chip=gfx1100",
        "--block-m=16",
        "--block-n=16",
        "--seq-n=32",
        "--head-dim=16",
        "--tile-loop-unroll=4",
        "--variants=scheduled",
        "--skip-hw",
    ]


def main() -> int:
    text = run_case(
        "matmul_pressure_disabled",
        [*matmul_base_cmd(), "--no-pressure-aware-schedule"],
        timeout=10.0,
    )
    require("matmul_pressure_disabled", text, r"variant: scheduled")
    require(
        "matmul_pressure_disabled",
        text,
        r"sim_cycles waves=2 simds=2 start_delay=0: 9906",
    )
    reject("matmul_pressure_disabled", text, r"waveamd-machine-schedule-report")

    text = run_case(
        "matmul_hard_cap_beam_report",
        [
            *matmul_base_cmd(),
            "--beam-search",
            "--print-candidates",
            "--pressure-vgpr-budget=256",
        ],
        timeout=10.0,
    )
    require("matmul_hard_cap_beam_report", text, r"name=beam_0")
    require(
        "matmul_hard_cap_beam_report",
        text,
        r"selected func=wmma_f16_matmul_tiled region=1 name=critical_path",
    )
    require("matmul_hard_cap_beam_report", text, r"vgpr_hard_excess=0")
    reject("matmul_hard_cap_beam_report", text, r"pressure_fallback")

    text = run_case(
        "fa_seq32_d16_u4_beam_report",
        [
            *fa_base_cmd(),
            "--beam-search",
            "--print-candidates",
            "--pressure-vgpr-budget=255",
        ],
        timeout=20.0,
    )
    require("fa_seq32_d16_u4_beam_report", text, r"name=beam_0")
    require(
        "fa_seq32_d16_u4_beam_report",
        text,
        r"selected func=flash_attention_f32 region=1 name=critical_path",
    )
    require(
        "fa_seq32_d16_u4_beam_report",
        text,
        r"selected func=flash_attention_f32 region=4 name=critical_path",
    )
    require(
        "fa_seq32_d16_u4_beam_report",
        text,
        r"sim_cycles waves=1 simds=1 start_delay=0: 29877",
    )
    reject("fa_seq32_d16_u4_beam_report", text, r"pressure_fallback")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
