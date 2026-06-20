# RUN: %python %s | FileCheck %s

# CHECK: scale_lds_dma_discovery: ok
# CHECK: large_scale_lds_dma_discovery: ok

from __future__ import annotations

import re
import subprocess
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[3]


def run_schedule_report(input_text: str) -> str:
    proc = subprocess.run(
        [
            str(REPO_ROOT / "build/bin/wave-opt"),
            "-",
            "--waveamd-machine-schedule-report=print-candidates=1",
        ],
        cwd=REPO_ROOT,
        text=True,
        input=input_text,
        capture_output=True,
        check=False,
    )
    if proc.returncode != 0:
        print(proc.stdout[-4000:], file=sys.stderr)
        print(proc.stderr[-4000:], file=sys.stderr)
        raise SystemExit(proc.returncode)
    return proc.stderr


def scale_lds_dma_stagger_mlir(dma_count: int, mfma_count: int, func_name: str) -> str:
    reg4 = "!waveamdmachine.reg<vgpr, 4>"
    reg1 = "!waveamdmachine.reg<vgpr, 1>"
    rsrc = "!waveamdmachine.reg<sgpr, 4>"
    lines = [
        'module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {',
        f"func.func @{func_name}(",
        f"    %off: {reg1},",
        f"    %rsrc: {rsrc},",
        "    %m0: !waveamdmachine.m0,",
        "    %tok: !waveamdmachine.mem.token,",
        f"    %a: {reg4},",
        f"    %b: {reg4},",
        f"    %acc: {reg4},",
        f"    %scale_a: {reg1},",
        f"    %scale_b: {reg1}) {{",
        "  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm",
    ]
    for index in range(dma_count):
        lines.extend(
            [
                f"  %ld{index} = waveamdmachine.buffer_load_lds_b128 "
                "%off, %rsrc, %zero, %m0 after %tok",
                f"      : ({reg1}, {rsrc}, !waveamdmachine.imm,",
                "         !waveamdmachine.m0, !waveamdmachine.mem.token)",
                "        -> !waveamdmachine.mem.token",
            ]
        )
    joined = ", ".join(f"%ld{index}" for index in range(dma_count))
    joined_types = ", ".join(["!waveamdmachine.mem.token"] * dma_count)
    lines.append(
        f"  %joined = waveamdmachine.token_join {joined} : ({joined_types}) "
        "-> !waveamdmachine.mem.token"
    )
    acc = "%acc"
    for index in range(mfma_count):
        result = f"%mfma{index}"
        lines.extend(
            [
                f"  {result} = waveamdmachine.mfma_scale_f32_16x16x128_f4_f4 "
                f"%a, %b, {acc}, %scale_a, %scale_b",
                f"      : ({reg4}, {reg4}, {reg4}, {reg1}, {reg1}) -> {reg4}",
            ]
        )
        acc = result
    lines.extend(["  return", "}", "}"])
    return "\n".join(lines)


def discovered_order_sequence(text: str, dma_count: int, mfma_count: int) -> list[str]:
    match = re.search(r"name=cma_dma_place_sliced_[^ ]+.* order=([0-9,]+)", text)
    if not match:
        return []
    order = [int(piece) for piece in match.group(1).split(",")]
    cats = ["other"] + ["dma"] * dma_count + ["join"] + ["mfma"] * mfma_count
    return [cats[index] for index in order if cats[index] != "other"]


def require(label: str, condition: bool, message: str) -> None:
    if not condition:
        print(f"{label}: {message}", file=sys.stderr)
        raise SystemExit(1)


def check_small_scale_lds_dma() -> None:
    label = "scale_lds_dma_discovery"
    text = run_schedule_report(scale_lds_dma_stagger_mlir(12, 64, label))
    seq = discovered_order_sequence(text, 12, 64)
    require(label, seq.count("dma") == 12, f"expected 12 DMA ops, got {seq}")
    require(label, seq.count("mfma") == 64, "missing scale MFMA ops")
    require(label, seq.count("join") == 1, "missing token join")

    first_mfma = seq.index("mfma")
    third_dma = [index for index, op in enumerate(seq) if op == "dma"][2]
    require(label, first_mfma == 2, f"expected 2 DMA ops before compute, got {seq[:8]}")
    require(
        label,
        seq[first_mfma:third_dma].count("mfma") == 4,
        f"third DMA should follow 4 scale MFMAs, got {seq[:12]}",
    )
    require(
        label,
        seq.index("join") > [i for i, op in enumerate(seq) if op == "dma"][-1],
        "token join moved before a DMA issuer",
    )
    print(f"{label}: ok")


def check_large_scale_lds_dma() -> None:
    label = "large_scale_lds_dma_discovery"
    text = run_schedule_report(scale_lds_dma_stagger_mlir(32, 64, label))
    seq = discovered_order_sequence(text, 32, 64)
    require(label, seq.count("dma") == 32, f"expected 32 DMA ops, got {seq}")
    require(label, seq.count("mfma") == 64, "missing scale MFMA ops")
    require(label, seq.count("join") == 1, "missing token join")
    require(
        label,
        seq.index("join") > [i for i, op in enumerate(seq) if op == "dma"][-1],
        "token join moved before a DMA issuer",
    )
    print(f"{label}: ok")


def main() -> int:
    check_small_scale_lds_dma()
    check_large_scale_lds_dma()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
