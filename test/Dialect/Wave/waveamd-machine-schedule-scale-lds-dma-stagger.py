# RUN: %python %s | FileCheck %s

# CHECK: scale_lds_dma_gap_fill: ok
# CHECK: large_scale_lds_dma_gap_fill: ok
# CHECK: resident_wave_lds_dma_order: ok

from __future__ import annotations

import re
import subprocess
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[3]
sys.path.insert(0, str(REPO_ROOT / "examples" / "wave"))

from common import resolve_wave_tool  # noqa: E402


def run_schedule_report(input_text: str) -> str:
    proc = subprocess.run(
        [
            str(resolve_wave_tool("wave-opt")),
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


def scale_lds_dma_stagger_mlir(
    dma_count: int,
    mfma_count: int,
    func_name: str,
    *,
    target_waves: int | None = None,
) -> str:
    reg4 = "!waveamdmachine.reg<vgpr, 4>"
    reg1 = "!waveamdmachine.reg<vgpr, 1>"
    rsrc = "!waveamdmachine.reg<sgpr, 4>"
    wave_attr = (
        f", waveamdmachine.target_waves = {target_waves} : i64"
        if target_waves is not None
        else ""
    )
    lines = [
        "module attributes {waveamdmachine.target = "
        f'"amdgcn-amd-amdhsa--gfx950"{wave_attr}}} {{',
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


def greedy_order_sequence(
    text: str, dma_count: int, mfma_count: int
) -> tuple[list[str], int, int, int]:
    cats = ["other"] + ["dma"] * dma_count + ["join"] + ["mfma"] * mfma_count
    match = re.search(
        r"name=greedy[^\n]* filled_gaps=([0-9]+)[^\n]*"
        r" resource_gaps=([0-9]+)[^\n]*"
        r" memory_token_gaps=([0-9]+)[^\n]* order=([0-9,]+)",
        text,
    )
    if not match:
        print(text[-4000:], file=sys.stderr)
        raise SystemExit("missing greedy candidate")
    order = [int(piece) for piece in match.group(4).split(",")]
    return (
        [cats[index] for index in order if cats[index] != "other"],
        int(match.group(1)),
        int(match.group(2)),
        int(match.group(3)),
    )


def require(label: str, condition: bool, message: str) -> None:
    if not condition:
        print(f"{label}: {message}", file=sys.stderr)
        raise SystemExit(1)


def check_small_scale_lds_dma() -> None:
    label = "scale_lds_dma_gap_fill"
    text = run_schedule_report(scale_lds_dma_stagger_mlir(12, 64, label))
    seq, filled_gaps, resource_gaps, memory_token_gaps = greedy_order_sequence(
        text, 12, 64
    )
    require(label, filled_gaps > 0, "expected resource gap fill")
    require(
        label,
        resource_gaps >= filled_gaps,
        "expected resource gaps to dominate, "
        f"got filled={filled_gaps} resource={resource_gaps}",
    )
    require(
        label,
        memory_token_gaps == 0,
        f"expected no memory-token gaps, got {memory_token_gaps}",
    )
    require(label, seq.count("dma") == 12, f"expected 12 DMA ops, got {seq}")
    require(label, seq.count("mfma") == 64, "missing scale MFMA ops")
    require(label, seq.count("join") == 1, "missing token join")

    first_mfma = seq.index("mfma")
    last_dma = max(index for index, op in enumerate(seq) if op == "dma")
    join = seq.index("join")
    require(
        label, first_mfma == 1, f"compute should fill first service gap: {seq[:16]}"
    )
    require(label, first_mfma < last_dma, f"compute should fill DMA stall: {seq[:32]}")
    require(label, join == last_dma + 1, "token join should drain after DMA issuers")
    require(
        label,
        filled_gaps == seq[:join].count("mfma"),
        "filled gaps should be MFMA before join",
    )
    print(f"{label}: ok")


def check_large_scale_lds_dma() -> None:
    label = "large_scale_lds_dma_gap_fill"
    text = run_schedule_report(scale_lds_dma_stagger_mlir(32, 64, label))
    seq, filled_gaps, resource_gaps, memory_token_gaps = greedy_order_sequence(
        text, 32, 64
    )
    require(label, filled_gaps > 0, "expected resource gap fill")
    require(
        label,
        resource_gaps >= filled_gaps,
        "expected resource gaps to dominate, "
        f"got filled={filled_gaps} resource={resource_gaps}",
    )
    require(
        label,
        memory_token_gaps == 0,
        f"expected no memory-token gaps, got {memory_token_gaps}",
    )
    require(label, seq.count("dma") == 32, f"expected 32 DMA ops, got {seq}")
    require(label, seq.count("mfma") == 64, "missing scale MFMA ops")
    require(label, seq.count("join") == 1, "missing token join")
    first_mfma = seq.index("mfma")
    last_dma = max(index for index, op in enumerate(seq) if op == "dma")
    join = seq.index("join")
    require(
        label, first_mfma == 1, f"compute should fill first service gap: {seq[:16]}"
    )
    require(label, first_mfma < last_dma, f"compute should fill DMA stall: {seq[:48]}")
    require(label, join == last_dma + 1, "token join should drain after DMA issuers")
    require(
        label,
        filled_gaps == seq[:join].count("mfma"),
        "filled gaps should be MFMA before join",
    )
    print(f"{label}: ok")


def check_resident_wave_lds_dma_order() -> None:
    label = "resident_wave_lds_dma_order"
    text = run_schedule_report(
        scale_lds_dma_stagger_mlir(12, 64, label, target_waves=2)
    )
    seq, _, _, _ = greedy_order_sequence(text, 12, 64)
    require(
        label,
        seq.index("mfma") == 7,
        f"resident waves should preserve queue lead: {seq[:16]}",
    )
    print(f"{label}: ok")


def main() -> int:
    check_small_scale_lds_dma()
    check_large_scale_lds_dma()
    check_resident_wave_lds_dma_order()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
