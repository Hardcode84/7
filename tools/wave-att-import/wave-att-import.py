#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2026 wave-mlir contributors
#
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
"""Join AMDGPU ATT timing output to static ISA by PC."""

from __future__ import annotations

import argparse
import csv
import io
import json
import math
import re
import subprocess
import sys
from dataclasses import dataclass
from pathlib import Path

OBJDUMP_INST_RE = re.compile(r"^\s*(?P<inst>.+?)\s*//\s*(?P<pc>[0-9a-fA-F]+):")

MODEL_LATENCIES = {
    "NoInst": 0,
    "WaitcntPseudo": 0,
    "WriteSMEM": 20,
    "WriteSALU": 2,
    "Write32Bit": 5,
    "WriteVMEM": 320,
    "WriteLDS": 20,
    "WriteBarrier": 2000,
    "Write16PassWMMA": 64,
    "WriteBranch": 32,
    "Unknown": "",
}

EXACT_CLASSES = {
    "s_barrier": "WriteBarrier",
    "s_endpgm": "WriteBranch",
}

PREFIX_CLASSES = (
    ("s_waitcnt", "WaitcntPseudo"),
    ("s_load", "WriteSMEM"),
    (("buffer_load", "global_load", "flat_load"), "WriteVMEM"),
    (("buffer_store", "global_store", "flat_store"), "WriteVMEM"),
    (("ds_load", "ds_store"), "WriteLDS"),
    ("v_wmma", "Write16PassWMMA"),
    ("s_cbranch", "WriteBranch"),
    ("s_", "WriteSALU"),
    ("v_", "Write32Bit"),
)


@dataclass(frozen=True)
class StaticInst:
    index: int
    pc: int
    instruction: str

    @property
    def mnemonic(self) -> str:
        return self.instruction.split(maxsplit=1)[0]


@dataclass
class AttStats:
    hitcount: int = 0
    latency: float = 0.0
    stall: float = 0.0
    idle: float = 0.0

    def add(self, hitcount: int, latency: float, stall: float, idle: float) -> None:
        self.hitcount += hitcount
        self.latency += latency
        self.stall += stall
        self.idle += idle

    @property
    def avg_latency(self) -> float | None:
        if self.hitcount == 0:
            return None
        return self.latency / self.hitcount

    @property
    def avg_stall(self) -> float | None:
        if self.hitcount == 0:
            return None
        return self.stall / self.hitcount


@dataclass
class WaveStats:
    hitcount: int = 0
    duration: float = 0.0
    stall: float = 0.0
    first_time: float = 0.0

    def add(self, time: float, duration: float, stall: float) -> None:
        self.hitcount += 1
        self.duration += duration
        self.stall += stall
        self.first_time += time

    @property
    def avg_duration(self) -> float | None:
        if self.hitcount == 0:
            return None
        return self.duration / self.hitcount

    @property
    def avg_stall(self) -> float | None:
        if self.hitcount == 0:
            return None
        return self.stall / self.hitcount

    @property
    def avg_first_time(self) -> float | None:
        if self.hitcount == 0:
            return None
        return self.first_time / self.hitcount


@dataclass
class ImportSummary:
    stats_rows: int = 0
    stats_resolved: int = 0
    stats_unresolved: int = 0
    code_json_files: int = 0
    code_lines: int = 0
    wave_files: int = 0
    wave_rows: int = 0
    wave_resolved: int = 0
    wave_unresolved: int = 0


def parse_int(text: str) -> int:
    value = text.strip()
    if value.lower().startswith("0x"):
        return int(value, 16)
    return int(value, 10)


def parse_float(text: str) -> float:
    value = text.strip()
    if not value:
        return 0.0
    return float(value)


def read_objdump_text(args: argparse.Namespace) -> str:
    if args.objdump:
        return Path(args.objdump).read_text()

    cmd = [str(args.llvm_objdump), "-d"]
    if args.arch:
        cmd.append(f"--mcpu={args.arch}")
    cmd.append(str(args.code_object))
    proc = subprocess.run(cmd, text=True, capture_output=True, check=False)
    if proc.returncode != 0:
        if proc.stdout:
            sys.stdout.write(proc.stdout)
        if proc.stderr:
            sys.stderr.write(proc.stderr)
        raise SystemExit(proc.returncode)
    return proc.stdout


def parse_objdump(text: str) -> dict[int, StaticInst]:
    insts: dict[int, StaticInst] = {}
    for line in text.splitlines():
        match = OBJDUMP_INST_RE.match(line)
        if not match:
            continue
        pc = int(match.group("pc"), 16)
        instruction = match.group("inst").strip()
        insts[pc] = StaticInst(len(insts), pc, instruction)
    return insts


def classify_mnemonic(mnemonic: str) -> str:
    exact = EXACT_CLASSES.get(mnemonic)
    if exact:
        return exact
    for prefix, cls in PREFIX_CLASSES:
        if mnemonic.startswith(prefix):
            return cls
    return "Unknown"


def parse_stats(
    att_dir: Path, static_pcs: set[int], summary: ImportSummary
) -> dict[int, AttStats]:
    stats: dict[int, AttStats] = {}
    for path in sorted(att_dir.glob("stats_ui_output_*.csv")):
        with path.open(newline="") as stream:
            for row in csv.DictReader(stream):
                instruction = row.get("Instruction", "").strip()
                if not instruction or instruction.startswith(";"):
                    continue
                pc = parse_int(row["Vaddr"])
                hitcount = int(parse_float(row.get("Hitcount", "")))
                latency = parse_float(row.get("Latency", ""))
                stall = parse_float(row.get("Stall", ""))
                idle = parse_float(row.get("Idle", ""))
                summary.stats_rows += 1
                if pc not in static_pcs:
                    summary.stats_unresolved += 1
                    continue
                summary.stats_resolved += 1
                stats.setdefault(pc, AttStats()).add(hitcount, latency, stall, idle)
    return stats


def parse_code_maps(
    att_dir: Path, summary: ImportSummary
) -> dict[Path, dict[int, int]]:
    maps: dict[Path, dict[int, int]] = {}
    for path in sorted(att_dir.glob("ui_output_*/code.json")):
        summary.code_json_files += 1
        line_to_pc: dict[int, int] = {}
        data = json.loads(path.read_text())
        for row in data.get("code", []):
            if len(row) < 6:
                continue
            instruction = str(row[0]).strip()
            if not instruction or instruction.startswith(";"):
                continue
            line = int(row[2])
            pc = int(row[5])
            line_to_pc[line] = pc
        summary.code_lines += len(line_to_pc)
        maps[path.parent] = line_to_pc
    return maps


def parse_wave_json(
    att_dir: Path,
    static_pcs: set[int],
    code_maps: dict[Path, dict[int, int]],
    summary: ImportSummary,
) -> dict[int, WaveStats]:
    stats: dict[int, WaveStats] = {}
    for path in sorted(att_dir.glob("ui_output_*/se*_wv*.json")):
        summary.wave_files += 1
        line_to_pc = code_maps.get(path.parent, {})
        data = json.loads(path.read_text())
        instructions = data.get("wave", {}).get("instructions", [])
        summary.wave_rows += len(instructions)
        for row in instructions:
            if len(row) < 5:
                summary.wave_unresolved += 1
                continue
            time, _, stall, duration, asmline = row[:5]
            pc = line_to_pc.get(int(asmline)) if asmline else None
            if pc is None or pc not in static_pcs:
                summary.wave_unresolved += 1
                continue
            summary.wave_resolved += 1
            stats.setdefault(pc, WaveStats()).add(
                float(time), float(duration), float(stall)
            )
    return stats


def format_number(value: float | int | None | str) -> str:
    if value is None:
        return ""
    if isinstance(value, str):
        return value
    if isinstance(value, int):
        return str(value)
    number = float(value)
    if math.isclose(number, round(number)):
        return f"{number:.1f}"
    return f"{number:.3f}".rstrip("0").rstrip(".")


def build_report(
    static: dict[int, StaticInst],
    att_stats: dict[int, AttStats],
    wave_stats: dict[int, WaveStats],
    summary: ImportSummary,
    *,
    include_summary: bool,
) -> str:
    out = io.StringIO()
    if include_summary:
        out.write("summary:\n")
        out.write(f"  static_instructions: {len(static)}\n")
        out.write(f"  stats_rows: {summary.stats_rows}\n")
        out.write(f"  stats_resolved: {summary.stats_resolved}\n")
        out.write(f"  stats_unresolved: {summary.stats_unresolved}\n")
        out.write(f"  code_json_files: {summary.code_json_files}\n")
        out.write(f"  code_lines: {summary.code_lines}\n")
        out.write(f"  wave_files: {summary.wave_files}\n")
        out.write(f"  wave_rows: {summary.wave_rows}\n")
        out.write(f"  wave_resolved: {summary.wave_resolved}\n")
        out.write(f"  wave_unresolved: {summary.wave_unresolved}\n\n")

    writer = csv.writer(out, lineterminator="\n")
    writer.writerow(
        [
            "pc_hex",
            "pc_dec",
            "instruction",
            "mnemonic",
            "class",
            "model_latency",
            "static_index",
            "att_stats_hitcount",
            "att_stats_avg_latency",
            "att_stats_avg_stall",
            "att_stats_idle_total",
            "wave_hitcount",
            "wave_avg_duration",
            "wave_avg_stall",
            "wave_first_time_avg",
        ]
    )
    for pc in sorted(static):
        inst = static[pc]
        cls = classify_mnemonic(inst.mnemonic)
        att = att_stats.get(pc, AttStats())
        wave = wave_stats.get(pc, WaveStats())
        writer.writerow(
            [
                f"0x{pc:x}",
                pc,
                inst.instruction,
                inst.mnemonic,
                cls,
                format_number(MODEL_LATENCIES[cls]),
                inst.index,
                att.hitcount or "",
                format_number(att.avg_latency),
                format_number(att.avg_stall),
                format_number(att.idle if att.hitcount else None),
                wave.hitcount or "",
                format_number(wave.avg_duration),
                format_number(wave.avg_stall),
                format_number(wave.avg_first_time),
            ]
        )
    return out.getvalue()


def parse_args(argv: list[str]) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--att-dir", type=Path, required=True, help="rocprof ATT output"
    )
    parser.add_argument(
        "--arch", default="", help="AMDGPU gfx target passed to llvm-objdump"
    )
    parser.add_argument(
        "--llvm-objdump",
        type=Path,
        default=Path("llvm-objdump"),
        help="llvm-objdump path for --code-object",
    )
    parser.add_argument(
        "--summary",
        action="store_true",
        help="print import coverage summary before CSV",
    )
    parser.add_argument("--output", type=Path, help="write report to file")
    source = parser.add_mutually_exclusive_group(required=True)
    source.add_argument("--objdump", type=Path, help="precomputed llvm-objdump -d text")
    source.add_argument(
        "--code-object", type=Path, help="HSACO/code object to disassemble"
    )
    return parser.parse_args(argv)


def main(argv: list[str]) -> int:
    args = parse_args(argv)
    static = parse_objdump(read_objdump_text(args))
    if not static:
        sys.stderr.write("no static instructions parsed from objdump\n")
        return 1

    summary = ImportSummary()
    static_pcs = set(static)
    att_stats = parse_stats(args.att_dir, static_pcs, summary)
    code_maps = parse_code_maps(args.att_dir, summary)
    wave_stats = parse_wave_json(args.att_dir, static_pcs, code_maps, summary)
    report = build_report(
        static, att_stats, wave_stats, summary, include_summary=args.summary
    )
    if args.output:
        args.output.write_text(report)
    else:
        sys.stdout.write(report)
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
