# REQUIRES: wave-python-bindings
# RUN: %python %s | FileCheck %s

# CHECK: matmul_pressure_disabled: ok
# CHECK: matmul_hard_cap_beam_report: ok
# CHECK: fa_seq32_d16_u4_beam_report: ok
# CHECK: cma_dma_beam_cap: ok
# CHECK: lazy_hard_cap_issue_window_tie: ok

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


def lazy_issue_window_tie_mlir() -> str:
    lines = [
        'module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {',
        "func.func @lazy_issue_window_tie(",
        "    %a: !waveamdmachine.reg<vgpr, 4>,",
        "    %b: !waveamdmachine.reg<vgpr, 4>,",
        "    %acc0: !waveamdmachine.reg<vgpr, 4>,",
        "    %acc1: !waveamdmachine.reg<vgpr, 4>,",
        "    %s: !waveamdmachine.reg<sgpr, 1>) {",
        "  %m0 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc0",
        "      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,",
        "         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>",
    ]
    for i in range(128):
        lines.append(f"  %i{i} = waveamdmachine.imm {i % 17} : !waveamdmachine.imm")
    lines.extend(
        [
            "  %next:2 = waveamdmachine.s_add_i32 %s, %i127",
            "      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)",
            "        -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)",
            "  %m1 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc1",
            "      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,",
            "         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>",
            "  %e0, %e1, %e2, %e3 = waveamdmachine.tuple_to_elements %m1",
            "      : (!waveamdmachine.reg<vgpr, 4>) -> (",
            "          !waveamdmachine.reg<vgpr, 1>,",
            "          !waveamdmachine.reg<vgpr, 1>,",
            "          !waveamdmachine.reg<vgpr, 1>,",
            "          !waveamdmachine.reg<vgpr, 1>)",
            "  %sum = waveamdmachine.v_add_u32 %e0, %e1",
            "      : (!waveamdmachine.reg<vgpr, 1>,",
            "         !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>",
            "  return",
            "}",
            "}",
        ]
    )
    return "\n".join(lines)


def cma_dma_beam_cap_mlir(cma_count: int = 32) -> str:
    lines = [
        'module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {',
        "func.func @cma_dma_beam_cap(",
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


def check_cma_dma_beam_cap() -> None:
    text = run_case(
        "cma_dma_beam_cap",
        [
            str(REPO_ROOT / "build/bin/wave-opt"),
            "-",
            "--waveamd-machine-schedule-report=print-candidates=1 "
            "beam-search=1 max-beam-work=1000000",
        ],
        input_text=cma_dma_beam_cap_mlir(),
        timeout=10.0,
    )
    cma_candidates = re.findall(
        r"candidate func=cma_dma_beam_cap region=0 name=cma_dma_place_", text
    )
    if len(cma_candidates) != 8:
        print(
            f"cma_dma_beam_cap: expected 8 placement candidates, "
            f"got {len(cma_candidates)}",
            file=sys.stderr,
        )
        print(text[-4000:], file=sys.stderr)
        raise SystemExit(1)
    require("cma_dma_beam_cap", text, r"name=beam_0")
    reject("cma_dma_beam_cap", text, r"reason=max_beam_work")


def check_lazy_hard_cap_issue_window_tie() -> None:
    text = run_case(
        "lazy_hard_cap_issue_window_tie",
        [
            str(REPO_ROOT / "build/bin/wave-opt"),
            "-",
            "--waveamd-machine-schedule-report=print-candidates=1 "
            "pressure-aware-selection=1 pressure-vgpr-budget=256 "
            "pressure-target-waves-override=-1",
            "--waveamd-machine-schedule=apply-schedule=1 "
            "pressure-aware-selection=1 pressure-vgpr-budget=256 "
            "pressure-target-waves-override=-1",
        ],
        input_text=lazy_issue_window_tie_mlir(),
        timeout=10.0,
    )
    require(
        "lazy_hard_cap_issue_window_tie",
        text,
        r"waveamdmachine\.mfma_f32_16x16x32_f16 %arg0, %arg1, %arg3[^\n]*\n"
        r"\s*%[0-9]+ = waveamdmachine\.mfma_f32_16x16x32_f16 "
        r"%arg0, %arg1, %arg2[^\n]*\n"
        r"\s*%[0-9]+:4 = waveamdmachine\.tuple_to_elements %[0-9]+[^\n]*\n"
        r"\s*%[0-9]+ = waveamdmachine\.v_add_u32 %[0-9]+#0, %[0-9]+#1[^\n]*\n"
        r"\s*%[0-9]+ = waveamdmachine\.imm 8[^\n]*\n"
        r"\s*%[A-Za-z0-9_]+, %[A-Za-z0-9_]+ = waveamdmachine\.s_add_i32",
    )
    require(
        "lazy_hard_cap_issue_window_tie",
        text,
        r"waveamd-machine-schedule-report candidate "
        r"func=lazy_issue_window_tie region=0 name=[^\n]*"
        r"hazard_wait_cycles=[1-9][0-9]*",
    )


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
        r"sim_cycles waves=2 simds=2 start_delay=0: 9922",
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
    require("fa_seq32_d16_u4_beam_report", text, r"name=issue_window")
    require("fa_seq32_d16_u4_beam_report", text, r"name=local_issue")
    require(
        "fa_seq32_d16_u4_beam_report",
        text,
        r"selected func=flash_attention_f32 region=0 name=critical_path",
    )
    require(
        "fa_seq32_d16_u4_beam_report",
        text,
        r"skipped func=flash_attention_f32 region=1 reason=max_region_ops "
        r"ops=671 instruction_ops=668 limit=512",
    )
    require(
        "fa_seq32_d16_u4_beam_report",
        text,
        r"skipped func=flash_attention_f32 region=4 reason=max_region_ops "
        r"ops=704 instruction_ops=704 limit=512",
    )
    require(
        "fa_seq32_d16_u4_beam_report",
        text,
        r"sim_cycles waves=1 simds=1 start_delay=0: 30216",
    )
    reject("fa_seq32_d16_u4_beam_report", text, r"pressure_fallback")

    check_cma_dma_beam_cap()
    check_lazy_hard_cap_issue_window_tie()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
