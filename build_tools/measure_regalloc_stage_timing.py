#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2026 wave-mlir contributors
#
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
"""Measure Wave regalloc transform stage timings from MLIR timing output."""

from __future__ import annotations

import argparse
import csv
import os
import re
import runpy
import shutil
import statistics
import subprocess
import sys
import tempfile
from collections import defaultdict
from collections.abc import Callable
from dataclasses import dataclass
from pathlib import Path
from typing import Any

REPO_ROOT = Path(__file__).resolve().parents[1]
DEFAULT_PERF_GOLDEN = REPO_ROOT / "test/PerfGolden/test_v9_4096_original_wave.py"
TIMING_RE = re.compile(
    r"^\s*([0-9]+(?:\.[0-9]+)?)\s+\(\s*[0-9.]+%\)\s+([A-Za-z0-9_]+)\s*$"
)
STAGES = [
    "wave_regalloc_transform_stages",
    "regalloc_build_alias_state",
    "regalloc_linear_scan",
    "regalloc_agpr_relief",
    "regalloc_remat_relief",
    "regalloc_sgpr_to_vgpr_relief",
    "regalloc_lds_relief",
    "regalloc_scratch_relief",
]


@dataclass(frozen=True)
class TimingTool:
    label: str
    path: Path


@dataclass(frozen=True)
class PerfGoldenInput:
    name: str
    script: Path
    source: Path | None
    golden: Path
    isolate_kernel: Callable[[Path], Path] | None
    normalize_asm: Callable[[str], str]


@dataclass(frozen=True)
class TimingSample:
    label: str
    run: int
    stage: str
    seconds: float


def rel(path: Path) -> str:
    try:
        return str(path.resolve().relative_to(REPO_ROOT))
    except ValueError:
        return str(path)


def load_perf_golden(path: Path) -> PerfGoldenInput:
    data: dict[str, Any] = runpy.run_path(str(path))
    missing = [name for name in ["NAME", "GOLDEN", "normalize_asm"] if name not in data]
    if missing:
        raise SystemExit(f"{rel(path)}: missing {', '.join(missing)}")
    source = data.get("SOURCE")
    isolate_kernel = data.get("isolate_kernel")
    if (source is None) != (isolate_kernel is None):
        raise SystemExit(f"{rel(path)}: SOURCE and isolate_kernel must appear together")
    return PerfGoldenInput(
        name=str(data["NAME"]),
        script=path,
        source=Path(source) if source is not None else None,
        golden=Path(data["GOLDEN"]),
        isolate_kernel=isolate_kernel,
        normalize_asm=data["normalize_asm"],
    )


def parse_tool(spec: str) -> TimingTool:
    if "=" in spec:
        label, raw_path = spec.split("=", 1)
        if not label:
            raise SystemExit(f"empty tool label in {spec!r}")
        path = Path(raw_path)
    else:
        path = Path(spec)
        label = path.stem
    if not path.is_absolute():
        path = REPO_ROOT / path
    if not path.exists():
        raise SystemExit(f"{label}: wave-translate missing: {rel(path)}")
    return TimingTool(label=label, path=path)


def get_tools(specs: list[str], build_dir: Path) -> list[TimingTool]:
    if not specs:
        specs = [f"current={build_dir / 'bin/wave-translate'}"]
    tools = [parse_tool(spec) for spec in specs]
    seen: set[str] = set()
    for tool in tools:
        if tool.label in seen:
            raise SystemExit(f"duplicate tool label: {tool.label}")
        seen.add(tool.label)
    return tools


def rotated_order(tools: list[TimingTool], run: int) -> list[TimingTool]:
    if len(tools) <= 1:
        return tools
    offset = (run - 1) % len(tools)
    return [*tools[offset:], *tools[:offset]]


def parse_timing(text: str, timing_path: Path) -> dict[str, float]:
    timings: dict[str, float] = {}
    for line in text.splitlines():
        match = TIMING_RE.match(line)
        if not match:
            continue
        stage = match.group(2)
        if stage == "wave_regalloc_transform_stages" or stage.startswith("regalloc_"):
            timings[stage] = float(match.group(1))
    missing = [stage for stage in STAGES if stage not in timings]
    if missing:
        raise SystemExit(f"{timing_path}: missing timing stages: {', '.join(missing)}")
    return timings


def prepare_source(
    perf_golden: PerfGoldenInput, build_dir: Path, output_dir: Path
) -> Path:
    if perf_golden.source is not None and perf_golden.isolate_kernel is not None:
        return perf_golden.isolate_kernel(output_dir)

    source = output_dir / f"{perf_golden.name}.mlir"
    asm = output_dir / f"{perf_golden.name}.bootstrap.s"
    stdout_path = output_dir / f"{perf_golden.name}.emit.stdout.txt"
    stderr_path = output_dir / f"{perf_golden.name}.emit.stderr.txt"
    proc = subprocess.run(
        [
            sys.executable,
            str(perf_golden.script),
            f"--build-dir={build_dir}",
            f"--generated-out={asm}",
            f"--emit-mlir={source}",
            "--max-diff-lines=0",
        ],
        capture_output=True,
        text=True,
        check=False,
    )
    stdout_path.write_text(proc.stdout, encoding="utf-8")
    stderr_path.write_text(proc.stderr, encoding="utf-8")
    if proc.returncode != 0:
        raise SystemExit(
            f"{rel(perf_golden.script)}: --emit-mlir failed; see {stderr_path}"
        )
    if not source.exists():
        raise SystemExit(f"{rel(perf_golden.script)}: did not write {source}")
    return source


def run_translate(
    tool: TimingTool,
    source: Path,
    golden: str,
    normalize_asm: Callable[[str], str],
    pipeline_dir: Path,
    output_dir: Path,
    name: str,
    disable_threading: bool,
) -> dict[str, float]:
    asm_path = output_dir / f"{name}.s"
    timing_path = output_dir / f"{name}.timing.txt"
    cmd = [
        str(tool.path),
        "--wave-to-amdgpu-asm",
        "--mlir-timing",
        "--mlir-timing-display=tree",
    ]
    if disable_threading:
        cmd.append("--mlir-disable-threading")
    cmd.append(str(source))
    env = os.environ.copy()
    env["WAVE_PIPELINES_DIR"] = str(pipeline_dir)
    env["LC_ALL"] = "C"
    proc = subprocess.run(cmd, capture_output=True, text=True, env=env, check=False)
    asm_path.write_text(proc.stdout, encoding="utf-8")
    timing_path.write_text(proc.stderr, encoding="utf-8")
    if proc.returncode != 0:
        raise SystemExit(f"{tool.label}: wave-translate failed; see {timing_path}")
    generated = normalize_asm(proc.stdout)
    if generated != golden:
        raise SystemExit(f"{tool.label}: ASM differs from golden; see {asm_path}")
    return parse_timing(proc.stderr, timing_path)


def measure(
    perf_golden: PerfGoldenInput,
    source: Path,
    tools: list[TimingTool],
    build_dir: Path,
    runs: int,
    warmups: int,
    output_dir: Path,
    disable_threading: bool,
) -> list[TimingSample]:
    pipeline_dir = build_dir / "share/wave-mlir/pipelines"
    if not pipeline_dir.exists():
        raise SystemExit(f"pipeline dir missing: {rel(pipeline_dir)}")
    golden = perf_golden.normalize_asm(perf_golden.golden.read_text(encoding="utf-8"))
    samples: list[TimingSample] = []

    for warmup in range(1, warmups + 1):
        for tool in rotated_order(tools, warmup):
            run_translate(
                tool,
                source,
                golden,
                perf_golden.normalize_asm,
                pipeline_dir,
                output_dir,
                f"warmup-{warmup}-{tool.label}",
                disable_threading,
            )

    for run in range(1, runs + 1):
        for tool in rotated_order(tools, run):
            timings = run_translate(
                tool,
                source,
                golden,
                perf_golden.normalize_asm,
                pipeline_dir,
                output_dir,
                f"run-{run}-{tool.label}",
                disable_threading,
            )
            for stage in STAGES:
                samples.append(
                    TimingSample(
                        label=tool.label,
                        run=run,
                        stage=stage,
                        seconds=timings[stage],
                    )
                )
            print(f"completed {tool.label} run {run}", file=sys.stderr, flush=True)
    return samples


def write_samples_csv(samples: list[TimingSample], path: Path) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", newline="", encoding="utf-8") as file:
        writer = csv.writer(file, lineterminator="\n")
        writer.writerow(["label", "run", "stage", "seconds"])
        for sample in samples:
            writer.writerow(
                [sample.label, sample.run, sample.stage, f"{sample.seconds:.6f}"]
            )


def print_summary(samples: list[TimingSample], tools: list[TimingTool]) -> None:
    by_label_stage: dict[tuple[str, str], list[float]] = defaultdict(list)
    for sample in samples:
        by_label_stage[(sample.label, sample.stage)].append(sample.seconds)

    header = ["stage"]
    for tool in tools:
        header.extend(
            [
                f"{tool.label}_runs",
                f"{tool.label}_median",
                f"{tool.label}_min",
                f"{tool.label}_max",
            ]
        )
    if len(tools) >= 2:
        baseline = tools[0].label
        candidate = tools[-1].label
        header.extend(
            [
                f"delta_{candidate}_minus_{baseline}",
                "delta_pct",
            ]
        )

    writer = csv.writer(sys.stdout, lineterminator="\n")
    writer.writerow(header)
    for stage in STAGES:
        row: list[str] = [stage]
        medians: dict[str, float] = {}
        for tool in tools:
            values = by_label_stage[(tool.label, stage)]
            if not values:
                raise SystemExit(f"{tool.label}: no samples for {stage}")
            median = statistics.median(values)
            medians[tool.label] = median
            row.extend(
                [
                    " ".join(f"{value:.4f}" for value in values),
                    f"{median:.4f}",
                    f"{min(values):.4f}",
                    f"{max(values):.4f}",
                ]
            )
        if len(tools) >= 2:
            baseline = tools[0].label
            candidate = tools[-1].label
            delta = medians[candidate] - medians[baseline]
            row.extend([f"{delta:+.4f}", f"{delta / medians[baseline] * 100:+.2f}%"])
        writer.writerow(row)


def parse_args(argv: list[str]) -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        formatter_class=argparse.ArgumentDefaultsHelpFormatter
    )
    parser.add_argument(
        "--perf-golden-test",
        type=Path,
        default=DEFAULT_PERF_GOLDEN,
        help="PerfGolden helper; generated helpers must support --emit-mlir",
    )
    parser.add_argument("--build-dir", type=Path, default=REPO_ROOT / "build")
    parser.add_argument(
        "--tool",
        action="append",
        default=[],
        metavar="LABEL=PATH",
        help="wave-translate binary to measure; repeat for A/B",
    )
    parser.add_argument("--runs", type=int, default=5)
    parser.add_argument("--warmups", type=int, default=1)
    parser.add_argument("--samples-csv", type=Path)
    parser.add_argument("--output-dir", type=Path)
    parser.add_argument("--keep-temps", action="store_true")
    parser.add_argument("--mlir-disable-threading", action="store_true")
    return parser.parse_args(argv)


def validate_args(args: argparse.Namespace) -> None:
    if args.runs <= 0:
        raise SystemExit("--runs must be positive")
    if args.warmups < 0:
        raise SystemExit("--warmups must be non-negative")


def make_output_dir(args: argparse.Namespace) -> tuple[Path, bool]:
    output_dir = args.output_dir or Path(
        tempfile.mkdtemp(prefix="wave-regalloc-timing.")
    )
    output_dir.mkdir(parents=True, exist_ok=True)
    remove_output_dir = not args.keep_temps and args.output_dir is None
    return output_dir, remove_output_dir


def run(args: argparse.Namespace) -> int:
    validate_args(args)
    build_dir = args.build_dir.resolve()
    perf_golden = load_perf_golden(args.perf_golden_test.resolve())
    tools = get_tools(args.tool, build_dir)
    output_dir, remove_output_dir = make_output_dir(args)
    succeeded = False

    try:
        source = prepare_source(perf_golden, build_dir, output_dir)
        samples = measure(
            perf_golden,
            source,
            tools,
            build_dir,
            args.runs,
            args.warmups,
            output_dir,
            args.mlir_disable_threading,
        )
        if args.samples_csv:
            write_samples_csv(samples, args.samples_csv)
        print(f"perf_golden={perf_golden.name}")
        print(f"source={rel(source)}")
        print(f"golden={rel(perf_golden.golden)}")
        if args.keep_temps or args.output_dir is not None:
            print(f"output_dir={output_dir}")
        else:
            print(f"output_dir={output_dir} (removed)")
        print("asm=matched")
        print_summary(samples, tools)
        succeeded = True
    except BaseException:
        print(f"kept output_dir={output_dir}", file=sys.stderr)
        raise
    finally:
        if succeeded and remove_output_dir:
            shutil.rmtree(output_dir, ignore_errors=True)
    return 0


def main(argv: list[str]) -> int:
    return run(parse_args(argv))


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
