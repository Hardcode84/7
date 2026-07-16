# REQUIRES: wave-python-bindings
# RUN: %python %s | FileCheck %s

# CHECK: matmul_scheduled: ok
# CHECK: matmul_greedy_report: ok
# CHECK: fa_seq32_d16_u4_greedy_report: ok
# CHECK: gfx950_mfma_dma_report: ok

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


def run_case(
    label: str, cmd: list[str], timeout: float, input_text: str | None = None
) -> str:
    start = time.monotonic()
    try:
        proc = subprocess.run(
            cmd,
            cwd=REPO_ROOT,
            text=True,
            capture_output=True,
            input=input_text,
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
        "--enable-split-barriers",
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


def gfx950_mfma_dma_mlir(cma_count: int = 384) -> str:
    lines = [
        'module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {',
        "func.func @gfx950_mfma_dma(",
        "    %a: !waveamdmachine.reg<vgpr, 4>,",
        "    %b: !waveamdmachine.reg<vgpr, 4>,",
    ]
    for i in range(cma_count):
        lines.append(f"    %acc{i}: !waveamdmachine.reg<vgpr, 4>,")
    lines.extend(
        [
            "    %v: !waveamdmachine.reg<vgpr, 1>,",
            "    %rsrc: !waveamdmachine.reg<sgpr, 4>,",
            "    %m0: !waveamdmachine.m0,",
            "    %tok: !waveamdmachine.mem.token) {",
            "  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm",
        ]
    )
    for i in range(cma_count):
        lines.extend(
            [
                f"  %r{i} = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc{i}",
                "      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,",
                "         !waveamdmachine.reg<vgpr, 4>) -> "
                "!waveamdmachine.reg<vgpr, 4>",
            ]
        )
    lines.extend(
        [
            "  %ld0 = waveamdmachine.buffer_load_lds_b128 %v, %rsrc, %zero, "
            "%m0 after %tok",
            "      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,",
            "         !waveamdmachine.imm, !waveamdmachine.m0, "
            "!waveamdmachine.mem.token)",
            "        -> !waveamdmachine.mem.token",
            "  return",
            "}",
            "}",
        ]
    )
    return "\n".join(lines)


def check_gfx950_mfma_dma_report() -> None:
    text = run_case(
        "gfx950_mfma_dma_report",
        [
            str(REPO_ROOT / "build/bin/wave-opt"),
            "-",
            "--waveamd-machine-schedule-report=print-candidates=1",
        ],
        input_text=gfx950_mfma_dma_mlir(),
        timeout=10.0,
    )
    require(
        "gfx950_mfma_dma_report",
        text,
        r"candidate func=gfx950_mfma_dma region=0 name=original",
    )
    require(
        "gfx950_mfma_dma_report",
        text,
        r"candidate func=gfx950_mfma_dma region=0 name=greedy",
    )
    require(
        "gfx950_mfma_dma_report",
        text,
        r"selected func=gfx950_mfma_dma region=0 name=greedy "
        r".*action=apply reason=better",
    )
    reject("gfx950_mfma_dma_report", text, r"unsupported op")


def main() -> int:
    text = run_case(
        "matmul_scheduled",
        matmul_base_cmd(),
        timeout=10.0,
    )
    require("matmul_scheduled", text, r"variant: scheduled")
    require(
        "matmul_scheduled",
        text,
        r"sim_cycles: [0-9]+",
    )
    reject("matmul_scheduled", text, r"waveamd-machine-schedule-report")

    text = run_case(
        "matmul_greedy_report",
        [
            *matmul_base_cmd(),
            "--print-candidates",
        ],
        timeout=10.0,
    )
    require("matmul_greedy_report", text, r"name=greedy")
    require(
        "matmul_greedy_report",
        text,
        r"selected func=wmma_f16_matmul_tiled region=1 name=greedy " r".*action=apply",
    )
    require(
        "matmul_greedy_report",
        text,
        r"candidate func=wmma_f16_matmul_tiled region=1 name=greedy "
        r".*operand_gaps=1 .*memory_token_gaps=2 "
        r".*steady_state_iterations=4 .*steady_state_refinements=2",
    )

    text = run_case(
        "fa_seq32_d16_u4_greedy_report",
        [
            *fa_base_cmd(),
            "--print-candidates",
        ],
        timeout=20.0,
    )
    require(
        "fa_seq32_d16_u4_greedy_report",
        text,
        r"selected func=flash_attention_f32 region=0 name=greedy " r".*action=apply",
    )
    require(
        "fa_seq32_d16_u4_greedy_report",
        text,
        r"sim_cycles: [0-9]+",
    )

    check_gfx950_mfma_dma_report()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
