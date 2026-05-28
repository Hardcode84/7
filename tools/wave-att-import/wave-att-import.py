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

COUNTER_LATENCIES = dict(MODEL_LATENCIES)

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
    ("v_wmma", "Write32Bit"),
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
    wave_code_resolved: int = 0
    wave_position_resolved: int = 0
    wave_unresolved: int = 0
    wave_position_mismatched: int = 0


@dataclass(frozen=True)
class WaitWindow:
    wait: StaticInst
    phase: str
    counter: str
    limit: int
    pending: tuple[StaticInst, ...]
    drained: tuple[StaticInst, ...]


NON_ATT_MNEMONICS = {"s_delay_alu"}


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


def producer_counter(inst: StaticInst) -> str | None:
    mnemonic = inst.mnemonic
    if mnemonic.startswith(("s_load", "ds_load", "ds_store")):
        return "lgkm"
    if mnemonic.startswith(("buffer_load", "global_load", "flat_load")):
        return "vmem"
    if mnemonic.startswith(("buffer_store", "global_store", "flat_store")):
        return "vscnt"
    return None


def parse_wait_counters(inst: StaticInst) -> list[tuple[str, int]]:
    counter_names = {"lgkmcnt": "lgkm", "vmcnt": "vmem"}
    waits = []
    for counter, limit in re.findall(
        r"\b(vmcnt|lgkmcnt)\((0x[0-9a-fA-F]+|\d+)\)", inst.instruction
    ):
        waits.append((counter_names[counter], parse_int(limit)))
    if inst.mnemonic == "s_waitcnt_vscnt":
        match = re.search(r",\s*(0x[0-9a-fA-F]+|\d+)\s*$", inst.instruction)
        if match:
            waits.append(("vscnt", parse_int(match.group(1))))
    return waits


def parse_branch_imm(inst: StaticInst) -> int | None:
    match = re.match(r"s_cbranch_\w+\s+(0x[0-9a-fA-F]+|\d+)\b", inst.instruction)
    if not match:
        return None
    return parse_int(match.group(1))


def is_backedge_branch(inst: StaticInst) -> bool:
    imm = parse_branch_imm(inst)
    return imm is not None and imm >= 0x8000


def is_forward_branch(inst: StaticInst) -> bool:
    imm = parse_branch_imm(inst)
    return imm is not None and imm < 0x8000


def infer_loop_indices(static: dict[int, StaticInst]) -> tuple[int, int] | None:
    ordered = [static[pc] for pc in sorted(static)]
    backedges = [inst.index for inst in ordered if is_backedge_branch(inst)]
    if not backedges:
        return None
    loop_end = backedges[0]
    exit_branches = [
        inst.index for inst in ordered[:loop_end] if is_forward_branch(inst)
    ]
    if not exit_branches:
        return None
    return exit_branches[-1] + 1, loop_end


def classify_phase(inst: StaticInst, loop_indices: tuple[int, int] | None) -> str:
    if loop_indices is None:
        return "unknown"
    loop_start, loop_end = loop_indices
    if inst.index < loop_start:
        return "prologue"
    if inst.index <= loop_end:
        return "loop"
    return "epilogue"


def build_wait_windows(static: dict[int, StaticInst]) -> list[WaitWindow]:
    pending: dict[str, list[StaticInst]] = {"lgkm": [], "vmem": [], "vscnt": []}
    windows: list[WaitWindow] = []
    loop_indices = infer_loop_indices(static)
    for pc in sorted(static):
        inst = static[pc]
        waits = parse_wait_counters(inst)
        if waits:
            for counter, limit in waits:
                current = pending[counter]
                drain_count = max(0, len(current) - limit)
                drained = tuple(current[:drain_count])
                windows.append(
                    WaitWindow(
                        wait=inst,
                        phase=classify_phase(inst, loop_indices),
                        counter=counter,
                        limit=limit,
                        pending=tuple(current),
                        drained=drained,
                    )
                )
                del current[:drain_count]
            continue

        counter = producer_counter(inst)
        if counter:
            pending[counter].append(inst)
    return windows


def att_emits(inst: StaticInst) -> bool:
    return inst.mnemonic not in NON_ATT_MNEMONICS


def build_dynamic_trace(
    static: dict[int, StaticInst], trip_count: int | None
) -> list[StaticInst] | None:
    if trip_count is None:
        return None
    ordered = [static[pc] for pc in sorted(static)]
    loop_indices = infer_loop_indices(static)
    if loop_indices is None:
        expanded = ordered
    else:
        loop_start, loop_end = loop_indices
        expanded = [
            *ordered[:loop_start],
            *(ordered[loop_start : loop_end + 1] * trip_count),
            *ordered[loop_end + 1 :],
        ]
    return [inst for inst in expanded if att_emits(inst)]


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


def resolve_wave_pc(
    row: list[object],
    idx: int,
    line_to_pc: dict[int, int],
    dynamic_trace: list[StaticInst] | None,
    use_position: bool,
) -> tuple[int | None, bool]:
    asmline = int(row[4])
    pc = line_to_pc.get(asmline) if asmline else None
    if pc is not None or not use_position:
        return pc, False
    assert dynamic_trace is not None
    return dynamic_trace[idx].pc, True


def add_wave_row(
    stats: dict[int, WaveStats],
    pc: int,
    row: list[object],
    resolved_by_position: bool,
    summary: ImportSummary,
) -> None:
    time, _, stall, duration, _ = row[:5]
    summary.wave_resolved += 1
    if resolved_by_position:
        summary.wave_position_resolved += 1
    else:
        summary.wave_code_resolved += 1
    stats.setdefault(pc, WaveStats()).add(float(time), float(duration), float(stall))


def parse_wave_json(
    att_dir: Path,
    static_pcs: set[int],
    code_maps: dict[Path, dict[int, int]],
    dynamic_trace: list[StaticInst] | None,
    summary: ImportSummary,
) -> dict[int, WaveStats]:
    stats: dict[int, WaveStats] = {}
    for path in sorted(att_dir.glob("ui_output_*/se*_wv*.json")):
        summary.wave_files += 1
        line_to_pc = code_maps.get(path.parent, {})
        data = json.loads(path.read_text())
        instructions = data.get("wave", {}).get("instructions", [])
        summary.wave_rows += len(instructions)
        use_position = dynamic_trace is not None and len(instructions) == len(
            dynamic_trace
        )
        if dynamic_trace is not None and not use_position:
            summary.wave_position_mismatched += 1
        for idx, row in enumerate(instructions):
            if len(row) < 5:
                summary.wave_unresolved += 1
                continue
            pc, resolved_by_position = resolve_wave_pc(
                row, idx, line_to_pc, dynamic_trace, use_position
            )
            if pc is None or pc not in static_pcs:
                summary.wave_unresolved += 1
                continue
            add_wave_row(stats, pc, row, resolved_by_position, summary)
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
        out.write(f"  wave_code_resolved: {summary.wave_code_resolved}\n")
        out.write(f"  wave_position_resolved: {summary.wave_position_resolved}\n")
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


def table_latency(table: dict[str, int | str], inst: StaticInst) -> int | None:
    latency = table[classify_mnemonic(inst.mnemonic)]
    if isinstance(latency, int):
        return latency
    return None


def model_latency(inst: StaticInst) -> int | None:
    return table_latency(MODEL_LATENCIES, inst)


def counter_latency(
    inst: StaticInst, counter_latencies: dict[str, int | str]
) -> int | None:
    return table_latency(counter_latencies, inst)


def join_pcs(insts: tuple[StaticInst, ...]) -> str:
    return ";".join(f"0x{inst.pc:x}" for inst in insts)


def join_classes(insts: tuple[StaticInst, ...]) -> str:
    return ";".join(classify_mnemonic(inst.mnemonic) for inst in insts)


def max_model_latency(insts: tuple[StaticInst, ...]) -> int | None:
    latencies = [model_latency(inst) for inst in insts]
    known = [latency for latency in latencies if latency is not None]
    if not known:
        return None
    return max(known)


def max_counter_latency(
    insts: tuple[StaticInst, ...], counter_latencies: dict[str, int | str]
) -> int | None:
    latencies = [counter_latency(inst, counter_latencies) for inst in insts]
    known = [latency for latency in latencies if latency is not None]
    if not known:
        return None
    return max(known)


def static_order_model_stall(window: WaitWindow) -> int:
    ready_cycles = []
    for inst in window.drained:
        latency = model_latency(inst)
        if latency is not None:
            ready_cycles.append(inst.index + latency)
    if not ready_cycles:
        return 0
    return max(0, max(ready_cycles) - window.wait.index)


def static_order_counter_stall(
    window: WaitWindow, counter_latencies: dict[str, int | str]
) -> int:
    ready_cycles = []
    for inst in window.drained:
        latency = counter_latency(inst, counter_latencies)
        if latency is not None:
            ready_cycles.append(inst.index + latency)
    if not ready_cycles:
        return 0
    return max(0, max(ready_cycles) - window.wait.index)


def classify_window_class(window: WaitWindow) -> str:
    classes = set(join_classes(window.pending).split(";"))
    if window.counter == "vscnt":
        return "VMEM store"
    if "WriteVMEM" in classes:
        return "VMEM load"
    if "WriteLDS" in classes and "WriteSMEM" in classes:
        return "LGKM mixed"
    if "WriteLDS" in classes:
        return "LDS"
    if "WriteSMEM" in classes:
        return "SMEM"
    return window.counter


def build_window_report(
    static: dict[int, StaticInst],
    att_stats: dict[int, AttStats],
    wave_stats: dict[int, WaveStats],
    summary: ImportSummary,
    counter_latencies: dict[str, int | str],
    *,
    include_summary: bool,
) -> str:
    windows = build_wait_windows(static)
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
        out.write(f"  wave_code_resolved: {summary.wave_code_resolved}\n")
        out.write(f"  wave_position_resolved: {summary.wave_position_resolved}\n")
        out.write(f"  wave_unresolved: {summary.wave_unresolved}\n")
        out.write(f"  wave_position_mismatched: {summary.wave_position_mismatched}\n")
        out.write(f"  wait_windows: {len(windows)}\n\n")

    writer = csv.writer(out, lineterminator="\n")
    writer.writerow(
        [
            "wait_pc_hex",
            "wait_pc_dec",
            "wait_instruction",
            "phase",
            "counter",
            "limit",
            "pending_count",
            "drained_count",
            "pending_pcs",
            "drained_pcs",
            "pending_classes",
            "model_max_latency",
            "model_static_wait",
            "counter_max_latency",
            "counter_static_wait",
            "att_stats_hitcount",
            "att_stats_avg_latency",
            "att_stats_avg_stall",
            "wave_hitcount",
            "wave_avg_duration",
            "wave_avg_stall",
        ]
    )
    for window in windows:
        att = att_stats.get(window.wait.pc, AttStats())
        wave = wave_stats.get(window.wait.pc, WaveStats())
        writer.writerow(
            [
                f"0x{window.wait.pc:x}",
                window.wait.pc,
                window.wait.instruction,
                window.phase,
                window.counter,
                window.limit,
                len(window.pending),
                len(window.drained),
                join_pcs(window.pending),
                join_pcs(window.drained),
                join_classes(window.pending),
                format_number(max_model_latency(window.pending)),
                static_order_model_stall(window),
                format_number(max_counter_latency(window.pending, counter_latencies)),
                static_order_counter_stall(window, counter_latencies),
                att.hitcount or "",
                format_number(att.avg_latency),
                format_number(att.avg_stall),
                wave.hitcount or "",
                format_number(wave.avg_duration),
                format_number(wave.avg_stall),
            ]
        )
    return out.getvalue()


@dataclass
class WindowSummary:
    windows: int = 0
    model_static_wait: float = 0.0
    counter_static_wait: float = 0.0
    att_wave_duration: float = 0.0
    att_wave_stall: float = 0.0


def add_window_summary(
    summaries: dict[tuple[str, str], WindowSummary],
    key: tuple[str, str],
    window: WaitWindow,
    wave: WaveStats,
    wave_files: int,
    counter_latencies: dict[str, int | str],
) -> None:
    summary = summaries.setdefault(key, WindowSummary())
    summary.windows += 1
    if wave_files == 0 or wave.hitcount == 0:
        return
    scale = wave.hitcount / wave_files
    summary.model_static_wait += static_order_model_stall(window) * scale
    summary.counter_static_wait += (
        static_order_counter_stall(window, counter_latencies) * scale
    )
    summary.att_wave_duration += (wave.avg_duration or 0.0) * scale
    summary.att_wave_stall += (wave.avg_stall or 0.0) * scale


def build_window_summary_report(
    static: dict[int, StaticInst],
    wave_stats: dict[int, WaveStats],
    summary: ImportSummary,
    counter_latencies: dict[str, int | str],
    *,
    include_summary: bool,
) -> str:
    windows = build_wait_windows(static)
    summaries: dict[tuple[str, str], WindowSummary] = {}
    for window in windows:
        wave = wave_stats.get(window.wait.pc, WaveStats())
        window_class = classify_window_class(window)
        add_window_summary(
            summaries,
            ("all", "all"),
            window,
            wave,
            summary.wave_files,
            counter_latencies,
        )
        add_window_summary(
            summaries,
            ("phase", window.phase),
            window,
            wave,
            summary.wave_files,
            counter_latencies,
        )
        add_window_summary(
            summaries,
            ("class", window_class),
            window,
            wave,
            summary.wave_files,
            counter_latencies,
        )
        add_window_summary(
            summaries,
            (f"phase:{window.phase}", window_class),
            window,
            wave,
            summary.wave_files,
            counter_latencies,
        )

    out = io.StringIO()
    if include_summary:
        out.write("summary:\n")
        out.write(f"  static_instructions: {len(static)}\n")
        out.write(f"  wave_files: {summary.wave_files}\n")
        out.write(f"  wave_rows: {summary.wave_rows}\n")
        out.write(f"  wave_resolved: {summary.wave_resolved}\n")
        out.write(f"  wave_unresolved: {summary.wave_unresolved}\n")
        out.write(f"  wave_position_mismatched: {summary.wave_position_mismatched}\n")
        out.write(f"  wait_windows: {len(windows)}\n\n")

    writer = csv.writer(out, lineterminator="\n")
    writer.writerow(
        [
            "scope",
            "name",
            "windows",
            "model_static_wait_per_wave",
            "counter_static_wait_per_wave",
            "att_wave_duration_per_wave",
            "att_wave_stall_per_wave",
        ]
    )
    for key in sorted(summaries):
        row = summaries[key]
        writer.writerow(
            [
                key[0],
                key[1],
                row.windows,
                format_number(row.model_static_wait),
                format_number(row.counter_static_wait),
                format_number(row.att_wave_duration),
                format_number(row.att_wave_stall),
            ]
        )
    return out.getvalue()


def parse_counter_latency_override(text: str) -> tuple[str, int]:
    if "=" not in text:
        raise argparse.ArgumentTypeError("expected CLASS=LATENCY")
    name, value_text = text.split("=", 1)
    name = name.strip()
    if name not in COUNTER_LATENCIES or not isinstance(COUNTER_LATENCIES[name], int):
        raise argparse.ArgumentTypeError(f"unknown latency class: {name}")
    try:
        value = int(value_text, 10)
    except ValueError as exc:
        raise argparse.ArgumentTypeError("latency must be an integer") from exc
    if value < 0:
        raise argparse.ArgumentTypeError("latency must be non-negative")
    return name, value


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
    parser.add_argument(
        "--windows",
        action="store_true",
        help="print wait-window calibration rows instead of per-PC rows",
    )
    parser.add_argument(
        "--window-summary",
        action="store_true",
        help="print per-wave wait totals by phase and producer class",
    )
    parser.add_argument(
        "--trip-count",
        type=int,
        help="recover unresolved per-wave rows by expanded static order",
    )
    parser.add_argument(
        "--counter-latency",
        action="append",
        default=[],
        metavar="CLASS=LATENCY",
        type=parse_counter_latency_override,
        help="override wait-counter timing for a model class",
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
    dynamic_trace = build_dynamic_trace(static, args.trip_count)
    wave_stats = parse_wave_json(
        args.att_dir, static_pcs, code_maps, dynamic_trace, summary
    )
    counter_latencies = dict(COUNTER_LATENCIES)
    for cls, latency in args.counter_latency:
        counter_latencies[cls] = latency
    if args.window_summary:
        report = build_window_summary_report(
            static,
            wave_stats,
            summary,
            counter_latencies,
            include_summary=args.summary,
        )
    elif args.windows:
        report = build_window_report(
            static,
            att_stats,
            wave_stats,
            summary,
            counter_latencies,
            include_summary=args.summary,
        )
    else:
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
