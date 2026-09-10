#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2026 wave-mlir contributors
#
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
"""Shared Wave calibration support."""

from __future__ import annotations

import argparse
import re
import shutil
import subprocess
import sys
from collections.abc import Callable
from dataclasses import dataclass
from pathlib import Path

EMIT_ONLY_ENTRY_POINT = "waveamd_backend_emit_only"


@dataclass(frozen=True)
class Variant:
    name: str
    apply_schedule: bool


VARIANTS = {
    "baseline": Variant("baseline", apply_schedule=False),
    "scheduled": Variant("scheduled", apply_schedule=True),
}


def run(
    cmd: list[str],
    *,
    input_text: str | None = None,
    env: dict[str, str] | None = None,
) -> str:
    proc = subprocess.run(
        cmd,
        input=input_text,
        text=True,
        capture_output=True,
        env=env,
        check=False,
    )
    if proc.returncode != 0:
        if proc.stdout:
            sys.stdout.write(proc.stdout)
        if proc.stderr:
            sys.stderr.write(proc.stderr)
        raise SystemExit(proc.returncode)
    if proc.stderr:
        sys.stderr.write(proc.stderr)
    return proc.stdout


def detect_chip() -> str:
    rocminfo = shutil.which("rocminfo")
    if rocminfo is None:
        sys.exit("no rocminfo on PATH; pass --chip")
    out = run([rocminfo])
    for line in out.splitlines():
        line = line.strip()
        if line.startswith("Name:") and "gfx" in line:
            return line.split()[-1]
    sys.exit("rocminfo did not report a gfx Name")


def schedule_pass_options(variant: Variant) -> dict[str, bool | int | str]:
    if not variant.apply_schedule:
        return {}
    return {"apply-schedule": True}


def schedule_report_options(
    variant: Variant, args: argparse.Namespace
) -> dict[str, bool | int | str]:
    if not variant.apply_schedule:
        return {}
    report_options: dict[str, bool | int] = {
        "print-candidates": args.print_candidates,
        "print-score": args.print_score,
        "print-regions": args.print_regions,
    }
    report_options = {
        name: value for name, value in report_options.items() if value is not False
    }
    if not report_options:
        return {}
    return report_options


def backend_pipeline_path(build_dir: Path) -> Path:
    return build_dir / "share/wave-mlir/pipelines/pipelines.mlir"


def read_backend_pipeline(build_dir: Path) -> str:
    path = backend_pipeline_path(build_dir)
    if not path.exists():
        sys.exit(f"backend pipeline library missing: {path}")
    return path.read_text()


def import_mlir_bindings(build_dir: Path):
    package_path = build_dir / "python_packages/wave_mlir"
    sys.path.insert(0, str(package_path))
    try:
        from mlir import ir
        from mlir.dialects import transform, wave
    except ModuleNotFoundError as err:
        raise SystemExit(
            f"MLIR Python bindings missing under {package_path}: {err}"
        ) from err
    return ir, transform, wave.register_dialects


def erase_default_entry(ir, module) -> None:
    for op in list(module.body.operations):
        attr = op.attributes.get("sym_name")
        if attr is not None and ir.StringAttr(attr).value == "__transform_main":
            op.operation.erase()
            return
    sys.exit("backend pipeline library missing __transform_main")


def append_calibration_entry(
    ir,
    transform,
    module,
    schedule_options: dict[str, bool | int | str],
    report_options: dict[str, bool | int | str],
) -> None:
    any_op = transform.AnyOpType.get()
    with ir.InsertionPoint(module.body):
        seq = transform.NamedSequenceOp(
            "__transform_main",
            [any_op],
            [any_op],
            arg_attrs=[{"transform.consumed": ir.UnitAttr.get()}],
        )

    block = seq.body
    root = block.arguments[0]
    with ir.InsertionPoint(block):
        prescheduled = transform.IncludeOp(
            [any_op],
            "waveamd_backend_preschedule",
            transform.FailurePropagationMode.Propagate,
            [root],
        ).result
        finish_input = prescheduled
        if report_options:
            finish_input = transform.ApplyRegisteredPassOp(
                any_op,
                finish_input,
                "waveamd-machine-schedule-report",
                options=report_options,
            ).result
        if schedule_options:
            finish_input = transform.ApplyRegisteredPassOp(
                any_op,
                finish_input,
                "waveamd-machine-multi-wave-specialize",
            ).result
            finish_input = transform.ApplyRegisteredPassOp(
                any_op,
                finish_input,
                "waveamd-machine-schedule",
                options=schedule_options,
            ).result
        finish_input = transform.IncludeOp(
            [any_op],
            "waveamd_backend_postschedule",
            transform.FailurePropagationMode.Propagate,
            [finish_input],
        ).result
        transform.YieldOp([finish_input])


def pipeline_text(
    build_dir: Path,
    *,
    schedule_options: dict[str, bool | int | str],
    report_options: dict[str, bool | int | str],
) -> str:
    ir, transform, register_dialects = import_mlir_bindings(build_dir)
    with ir.Context() as ctx, ir.Location.unknown(ctx):
        register_dialects(ctx)
        module = ir.Module.parse(read_backend_pipeline(build_dir))
        erase_default_entry(ir, module)
        append_calibration_entry(
            ir,
            transform,
            module,
            schedule_options,
            report_options,
        )
        if not module.operation.verify():
            sys.exit("generated calibration pipeline failed verification")
        return str(module)


def write_pipeline(tmp: Path, variant: Variant, args: argparse.Namespace) -> Path:
    path = tmp / variant.name / "pipelines.mlir"
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(
        pipeline_text(
            args.build_dir,
            schedule_options=schedule_pass_options(variant),
            report_options=schedule_report_options(variant, args),
        )
    )
    return path


def parse_total_cycles(text: str) -> int:
    match = re.search(r"^total_cycles:\s+(\d+)$", text, re.M)
    if not match:
        sys.exit("wave-sim-report output missing total_cycles")
    return int(match.group(1))


def parse_hw(stdout: str, *, check_output: bool) -> tuple[int, float, str]:
    cycles = re.search(r"^per_launch_cycles_wallclock:\s+(\d+)$", stdout, re.M)
    micros = re.search(r"^per_launch_us:\s+([0-9.]+)$", stdout, re.M)
    if not cycles or not micros:
        sys.exit("runner output missing timing fields")
    if not check_output:
        return int(cycles.group(1)), float(micros.group(1)), "skipped"
    if not re.search(r"^output_check:\s+passed\b", stdout, re.M):
        sys.exit("runner output missing successful output check")
    return int(cycles.group(1)), float(micros.group(1)), "passed"


def run_hw_repeats(
    runner: Path,
    hsaco: Path,
    args: argparse.Namespace,
    *,
    run_hw: Callable[[Path, Path, argparse.Namespace, str], tuple[int, float, str]],
) -> tuple[list[int], list[float], str]:
    cycles_samples: list[int] = []
    us_samples: list[float] = []
    checks: set[str] = set()
    for _ in range(args.repeats):
        cycles, micros, check = run_hw(runner, hsaco, args, args.rocm_lib)
        cycles_samples.append(cycles)
        us_samples.append(micros)
        checks.add(check)
    return cycles_samples, us_samples, checks.pop() if len(checks) == 1 else "mixed"


def parse_variants(text: str) -> list[Variant]:
    variants: list[Variant] = []
    seen: set[str] = set()
    for raw in text.split(","):
        name = raw.strip()
        if not name:
            raise argparse.ArgumentTypeError("empty variant name")
        if name not in VARIANTS:
            choices = ", ".join(sorted(VARIANTS))
            raise argparse.ArgumentTypeError(
                f"unknown variant '{name}' (choices: {choices})"
            )
        if name in seen:
            raise argparse.ArgumentTypeError(f"duplicate variant '{name}'")
        variants.append(VARIANTS[name])
        seen.add(name)
    if not variants:
        raise argparse.ArgumentTypeError("no variants selected")
    return variants


def detect_asm_chip(source: Path) -> str:
    text = source.read_text()
    match = re.search(r'waveamdmachine\.target = "amdgcn-amd-amdhsa--([^"]+)"', text)
    if not match:
        sys.exit("source missing waveamdmachine.target")
    return match.group(1)


def emit_machine_asm(
    lower_asm: Callable[..., Path],
    build_dir: Path,
    machine: Path,
    pipeline: Path,
    tmp: Path,
    name: str,
) -> Path:
    return lower_asm(
        build_dir,
        machine,
        pipeline,
        tmp,
        name,
        entry_point=EMIT_ONLY_ENTRY_POINT,
    )


def assemble_hsaco(
    resolve_llvm_tool: Callable[[str, Path], Path],
    build_dir: Path,
    asm: Path,
    target_ir: Path,
    tmp: Path,
    name: str,
) -> Path:
    variant_tmp = tmp / name
    variant_tmp.mkdir(parents=True, exist_ok=True)
    llvm_mc = resolve_llvm_tool("llvm-mc", build_dir)
    ld_lld = resolve_llvm_tool("ld.lld", build_dir)
    for tool in (llvm_mc, ld_lld):
        if not tool.exists():
            sys.exit(f"required tool missing: {tool}")
    obj = variant_tmp / f"{name}.o"
    hsaco = variant_tmp / f"{name}.hsaco"
    run(
        [
            str(llvm_mc),
            "-triple=amdgcn-amd-amdhsa",
            f"-mcpu={detect_asm_chip(target_ir)}",
            "-filetype=obj",
            "-o",
            str(obj),
            str(asm),
        ]
    )
    run([str(ld_lld), "-shared", str(obj), "-o", str(hsaco)])
    return hsaco
