#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2026 wave-mlir contributors
#
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
"""Calibrate FlashAttention scheduling variants against simulator + HW timing."""

from __future__ import annotations

import argparse
import os
import re
import shutil
import subprocess
import sys
import tempfile
from dataclasses import dataclass
from pathlib import Path
from statistics import median

REPO_ROOT = Path(__file__).resolve().parents[2]
DEFAULT_BUILD = REPO_ROOT / "build"
EXAMPLE = REPO_ROOT / "examples/wave/flash_attention.py"
RUNNER_SRC = REPO_ROOT / "tools/wave-fa-calibrate/wave-fa-calibrate-runner.cpp"
KERNEL_NAME = "flash_attention_f32"
sys.path.insert(0, str(REPO_ROOT / "examples/wave"))

from common import extract_kernel_op  # noqa: E402


@dataclass(frozen=True)
class Variant:
    name: str
    apply_schedule: bool
    schedule_model: str = "single"


@dataclass
class VariantResult:
    name: str
    sim_cycles: int
    hw_cycles_samples: list[int]
    hw_us_samples: list[float]
    hw_check: str | None

    @property
    def hw_cycles(self) -> int | None:
        if not self.hw_cycles_samples:
            return None
        return round(median(self.hw_cycles_samples))

    @property
    def hw_us(self) -> float | None:
        if not self.hw_us_samples:
            return None
        return median(self.hw_us_samples)


VARIANTS = {
    "baseline": Variant("baseline", apply_schedule=False),
    "scheduled": Variant("scheduled", apply_schedule=True),
    "scheduled_multiwave": Variant(
        "scheduled_multiwave", apply_schedule=True, schedule_model="multi"
    ),
}

PRESSURE_BUDGET_OPTIONS = (
    ("pressure-vgpr-budget", "pressure_vgpr_budget"),
    ("pressure-sgpr-budget", "pressure_sgpr_budget"),
    ("pressure-critical-vgpr-budget", "pressure_critical_vgpr_budget"),
    ("pressure-critical-sgpr-budget", "pressure_critical_sgpr_budget"),
)


def add_pressure_budget_options(
    options: dict[str, bool | int | str], args: argparse.Namespace
) -> None:
    for option, attr in PRESSURE_BUDGET_OPTIONS:
        value = getattr(args, attr)
        if value >= 0:
            options[option] = value


def add_common_scheduler_options(
    options: dict[str, bool | int | str], args: argparse.Namespace
) -> None:
    if args.beam_search:
        options["beam-search"] = True
    if not args.no_pressure_aware_schedule:
        options["pressure-aware-selection"] = True
    if args.calibration_file:
        options["calibration-file"] = str(args.calibration_file)
    add_pressure_budget_options(options, args)


def add_schedule_model_options(
    options: dict[str, bool | int | str], variant: Variant, args: argparse.Namespace
) -> None:
    if variant.schedule_model == "single":
        return
    if variant.schedule_model != "multi":
        sys.exit(f"unknown schedule model: {variant.schedule_model}")
    options["model-waves"] = args.model_waves
    options["model-simds"] = args.model_simds
    options["model-start-delay"] = args.model_start_delay


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


def build_example_args(args: argparse.Namespace, chip: str) -> list[str]:
    cmd = [
        sys.executable,
        str(EXAMPLE),
        f"--chip={chip}",
        f"--block-m={args.block_m}",
        f"--block-n={args.block_n}",
        f"--head-dim={args.head_dim}",
        f"--seq-n={args.seq_n}",
        f"--seed={args.seed}",
    ]
    if args.target_waves:
        cmd.append(f"--target-waves={args.target_waves}")
    if args.tile_loop_unroll:
        cmd.append(f"--tile-loop-unroll={args.tile_loop_unroll}")
    return cmd


def generate_kernel_module(args: argparse.Namespace, chip: str) -> str:
    env = os.environ.copy()
    package_path = REPO_ROOT / "build/python_packages/wave_mlir"
    env["PYTHONPATH"] = (
        str(package_path)
        if not env.get("PYTHONPATH")
        else str(package_path) + os.pathsep + env["PYTHONPATH"]
    )
    module_text = run(build_example_args(args, chip), env=env)
    kernel = extract_kernel_op(
        module_text,
        kernel_regex=r"(func\.func @flash_attention_f32.*?\n    \})",
        kernel_name=KERNEL_NAME,
    )
    if kernel is None:
        sys.exit("could not isolate flash_attention_f32 kernel from generated module")
    target = f"amdgcn-amd-amdhsa--{chip}"
    return (
        f'module attributes {{waveamdmachine.target = "{target}"}} '
        f"{{\n{kernel}\n}}\n"
    )


def scheduler_policy_options(
    variant: Variant, args: argparse.Namespace
) -> dict[str, bool | int | str]:
    if not variant.apply_schedule:
        return {}
    options: dict[str, bool | int | str] = {}
    add_common_scheduler_options(options, args)
    add_schedule_model_options(options, variant, args)
    return {name: value for name, value in options.items() if value is not False}


def schedule_pass_options(
    variant: Variant, args: argparse.Namespace
) -> dict[str, bool | int | str]:
    if not variant.apply_schedule:
        return {}
    return {"apply-schedule": True, **scheduler_policy_options(variant, args)}


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
    return {**report_options, **scheduler_policy_options(variant, args)}


def format_pass_options(options: dict[str, bool | int | str]) -> str:
    pieces: list[str] = []
    for name, value in options.items():
        if isinstance(value, bool):
            value_text = "true" if value else "false"
        elif isinstance(value, str):
            value_text = '"' + value.replace("\\", "\\\\").replace('"', '\\"') + '"'
        else:
            value_text = str(value)
        pieces.append(f'"{name}" = {value_text}')
    return ", ".join(pieces)


def pipeline_text(
    schedule_options: dict[str, bool | int | str],
    report_options: dict[str, bool | int | str],
) -> str:
    report = ""
    schedule = ""
    schedule_input = "%r2"
    wait_input = schedule_input
    if report_options:
        option_text = format_pass_options(report_options)
        report = (
            "    %rr = transform.apply_registered_pass "
            '"waveamd-machine-schedule-report" '
            "with\n"
            f"        options = {{ {option_text} }}\n"
            f"        to {schedule_input} : (!transform.any_op) -> !transform.any_op\n"
        )
        schedule_input = "%rr"
        wait_input = schedule_input
    if schedule_options:
        option_text = format_pass_options(schedule_options)
        schedule = (
            '    %rs = transform.apply_registered_pass "waveamd-machine-schedule" '
            "with\n"
            f"        options = {{ {option_text} }}\n"
            f"        to {schedule_input} : (!transform.any_op) -> !transform.any_op\n"
        )
        wait_input = "%rs"
    ticket_wait = (
        '    %r3 = transform.apply_registered_pass "waveamd-insert-ticket-waits" '
        f"to {wait_input}"
    )
    return f"""module attributes {{transform.with_named_sequence}} {{
  transform.named_sequence @__transform_main(
      %root: !transform.any_op {{transform.consumed}}) -> !transform.any_op {{
    %rm = transform.apply_registered_pass "wavemeta-specialize" to %root
        : (!transform.any_op) -> !transform.any_op
    %rmeta = transform.apply_registered_pass "canonicalize" to %rm
        : (!transform.any_op) -> !transform.any_op
    %rpack = transform.apply_registered_pass "wave-form-packed-math" to %rmeta
        : (!transform.any_op) -> !transform.any_op
    %r0 = transform.apply_registered_pass "waveamd-to-machine" to %rpack
        : (!transform.any_op) -> !transform.any_op
    %rk = transform.apply_registered_pass "canonicalize" to %r0
        : (!transform.any_op) -> !transform.any_op
    %rc = transform.apply_registered_pass "cse" to %rk
        : (!transform.any_op) -> !transform.any_op
    %rl = transform.apply_registered_pass "loop-invariant-code-motion" to %rc
        : (!transform.any_op) -> !transform.any_op
    %r1 = transform.apply_registered_pass "waveamd-abi-lowering" to %rl
        : (!transform.any_op) -> !transform.any_op
    %r2 = transform.apply_registered_pass "waveamd-decompose-mem-tuples" to %r1
        : (!transform.any_op) -> !transform.any_op
{report}{schedule}{ticket_wait}
        : (!transform.any_op) -> !transform.any_op
    %r4 = transform.apply_registered_pass "waveamd-insert-hazard-waits" to %r3
        : (!transform.any_op) -> !transform.any_op
    %r5 = transform.apply_registered_pass "waveamd-reg-alloc" to %r4
        : (!transform.any_op) -> !transform.any_op
    %r6 = transform.apply_registered_pass "waveamd-resource-info" to %r5
        : (!transform.any_op) -> !transform.any_op
    %r7 = transform.apply_registered_pass "waveamd-metadata" to %r6
        : (!transform.any_op) -> !transform.any_op
    transform.yield %r7 : !transform.any_op
  }}
}}
"""


def write_pipeline(tmp: Path, variant: Variant, args: argparse.Namespace) -> Path:
    path = tmp / variant.name / "pipelines.mlir"
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(
        pipeline_text(
            schedule_pass_options(variant, args),
            schedule_report_options(variant, args),
        )
    )
    return path


def lower_machine(
    build_dir: Path, source: Path, pipeline: Path, tmp: Path, name: str
) -> Path:
    out = tmp / f"{name}.machine.mlir"
    wave_opt = build_dir / "bin/wave-opt"
    text = run(
        [
            str(wave_opt),
            "--mlir-disable-threading",
            str(source),
            "--pass-pipeline=builtin.module("
            f"wave-set-target-attr{{chip={detect_asm_chip(source)}}},"
            f"transform-preload-library{{transform-library-paths={pipeline}}},"
            "transform-interpreter)",
        ]
    )
    out.write_text(text)
    return out


def detect_asm_chip(source: Path) -> str:
    text = source.read_text()
    match = re.search(r'waveamdmachine\.target = "amdgcn-amd-amdhsa--([^"]+)"', text)
    if not match:
        sys.exit("source missing waveamdmachine.target")
    return match.group(1)


def lower_hsaco(
    build_dir: Path, source: Path, pipeline: Path, tmp: Path, name: str
) -> Path:
    variant_tmp = tmp / name
    variant_tmp.mkdir(parents=True, exist_ok=True)
    wave_translate = build_dir / "bin/wave-translate"
    llvm_mc = build_dir / "llvm-install/bin/llvm-mc"
    ld_lld = build_dir / "llvm-install/bin/ld.lld"
    for tool in (wave_translate, llvm_mc, ld_lld):
        if not tool.exists():
            sys.exit(f"required tool missing: {tool}")
    env = os.environ.copy()
    env["WAVE_PIPELINES_DIR"] = str(pipeline.parent)
    asm = variant_tmp / f"{name}.s"
    obj = variant_tmp / f"{name}.o"
    hsaco = variant_tmp / f"{name}.hsaco"
    asm.write_text(
        run([str(wave_translate), "--wave-to-amdgpu-asm", str(source)], env=env)
    )
    run(
        [
            str(llvm_mc),
            "-triple=amdgcn-amd-amdhsa",
            f"-mcpu={detect_asm_chip(source)}",
            "-filetype=obj",
            "-o",
            str(obj),
            str(asm),
        ]
    )
    run([str(ld_lld), "-shared", str(obj), "-o", str(hsaco)])
    return hsaco


def parse_total_cycles(text: str) -> int:
    match = re.search(r"^total_cycles:\s+(\d+)$", text, re.M)
    if not match:
        sys.exit("wave-sim-report output missing total_cycles")
    return int(match.group(1))


def run_sim_report(
    build_dir: Path, machine_mlir: Path, args: argparse.Namespace
) -> int:
    wave_sim = build_dir / "bin/wave-sim-report"
    text = run(
        [
            str(wave_sim),
            f"--func={KERNEL_NAME}",
            f"--waves={args.sim_waves}",
            f"--simds={args.sim_simds}",
            f"--start-delay={args.sim_start_delay}",
            *(
                [f"--calibration-file={args.calibration_file}"]
                if args.calibration_file
                else []
            ),
            str(machine_mlir),
        ]
    )
    return parse_total_cycles(text)


def compile_runner(args: argparse.Namespace, tmp: Path) -> Path:
    hipcc = args.hipcc
    if not Path(hipcc).exists() and shutil.which(hipcc) is None:
        sys.exit(f"hipcc not found: {hipcc}")
    runner = tmp / "wave-fa-calibrate-runner"
    run([hipcc, "-O2", str(RUNNER_SRC), "-o", str(runner)])
    return runner


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


def run_hw(
    runner: Path, hsaco: Path, args: argparse.Namespace, rocm_lib: str
) -> tuple[int, float, str]:
    env = os.environ.copy()
    existing_ld = env.get("LD_LIBRARY_PATH", "")
    env["LD_LIBRARY_PATH"] = rocm_lib + (":" + existing_ld if existing_ld else "")
    cmd = [
        str(runner),
        "--block-m",
        str(args.block_m),
        "--block-n",
        str(args.block_n),
        "--head-dim",
        str(args.head_dim),
        "--seq-n",
        str(args.seq_n),
        "--seed",
        str(args.seed),
        "--iters",
        str(args.iters),
        "--warmup",
        str(args.warmup),
        "--threads",
        str(threads_per_workgroup(args.chip)),
    ]
    if args.no_check:
        cmd.append("--no-check")
    cmd += [str(hsaco), KERNEL_NAME]
    stdout = run(cmd, env=env)
    sys.stdout.write(stdout)
    return parse_hw(stdout, check_output=not args.no_check)


def run_hw_repeats(
    runner: Path, hsaco: Path, args: argparse.Namespace
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


def run_variant(
    variant: Variant,
    args: argparse.Namespace,
    source: Path,
    runner: Path | None,
    tmp: Path,
) -> VariantResult:
    pipeline = write_pipeline(tmp, variant, args)
    machine = lower_machine(args.build_dir, source, pipeline, tmp, variant.name)
    sim_cycles = run_sim_report(args.build_dir, machine, args)
    if runner is None:
        return VariantResult(variant.name, sim_cycles, [], [], None)
    hsaco = lower_hsaco(args.build_dir, source, pipeline, tmp, variant.name)
    hw_cycles, hw_us, hw_check = run_hw_repeats(runner, hsaco, args)
    return VariantResult(variant.name, sim_cycles, hw_cycles, hw_us, hw_check)


def print_result(result: VariantResult, args: argparse.Namespace) -> None:
    print(f"variant: {result.name}")
    print(
        f"  sim_cycles waves={args.sim_waves} simds={args.sim_simds} "
        f"start_delay={args.sim_start_delay}: {result.sim_cycles}"
    )
    if result.hw_cycles_samples and result.hw_us_samples:
        if len(result.hw_cycles_samples) > 1:
            cycles = ",".join(str(x) for x in result.hw_cycles_samples)
            micros = ",".join(f"{x:.3f}" for x in result.hw_us_samples)
            print(f"  hw_cycles_wallclock_samples: {cycles}")
            print(f"  hw_per_launch_us_samples: {micros}")
        print(f"  hw_per_launch_us: {result.hw_us:.3f}")
        print(f"  hw_cycles_wallclock: {result.hw_cycles}")
    if result.hw_check is not None:
        print(f"  hw_output_check: {result.hw_check}")


def print_delta(results: list[VariantResult]) -> None:
    by_name = {r.name: r for r in results}
    base = by_name.get("baseline")
    if not base:
        return
    for result in results:
        if result.name == "baseline":
            continue
        print(f"delta: {result.name} - baseline")
        print(f"  sim_cycles: {result.sim_cycles - base.sim_cycles:+d}")
        if base.hw_cycles is not None and result.hw_cycles is not None:
            delta = result.hw_cycles - base.hw_cycles
            pct = 100.0 * delta / max(base.hw_cycles, 1)
            print(f"  hw_cycles_wallclock: {delta:+d} ({pct:+.1f}%)")


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


def threads_per_workgroup(chip: str) -> int:
    return 64 if chip.startswith("gfx950") else 32


def exit_if(condition: bool, message: str) -> None:
    if condition:
        sys.exit(message)


def build_argparser() -> argparse.ArgumentParser:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--chip", default="", help="gfx target; default from rocminfo")
    ap.add_argument("--block-m", type=int, default=16)
    ap.add_argument("--block-n", type=int, default=16)
    ap.add_argument("--head-dim", type=int, default=32)
    ap.add_argument("--seq-n", type=int, default=16)
    ap.add_argument("--seed", type=int, default=0)
    ap.add_argument("--iters", type=int, default=1000)
    ap.add_argument("--warmup", type=int, default=10)
    ap.add_argument(
        "--repeats",
        type=int,
        default=1,
        help="hardware timing repeats per variant; reports median",
    )
    ap.add_argument(
        "--variants",
        type=parse_variants,
        default=parse_variants("baseline,scheduled"),
        help="comma-separated variants: baseline, scheduled, scheduled_multiwave",
    )
    ap.add_argument("--sim-waves", type=int, default=1)
    ap.add_argument("--sim-simds", type=int, default=1)
    ap.add_argument("--sim-start-delay", type=int, default=0)
    ap.add_argument("--model-waves", type=int, default=4)
    ap.add_argument("--model-simds", type=int, default=4)
    ap.add_argument("--model-start-delay", type=int, default=0)
    ap.add_argument("--print-candidates", action="store_true")
    ap.add_argument("--print-score", action="store_true")
    ap.add_argument("--print-regions", action="store_true")
    ap.add_argument("--beam-search", action="store_true")
    ap.add_argument("--no-pressure-aware-schedule", action="store_true")
    ap.add_argument("--pressure-vgpr-budget", type=int, default=-1)
    ap.add_argument("--pressure-sgpr-budget", type=int, default=-1)
    ap.add_argument("--pressure-critical-vgpr-budget", type=int, default=-1)
    ap.add_argument("--pressure-critical-sgpr-budget", type=int, default=-1)
    ap.add_argument("--calibration-file", type=Path, default=None)
    ap.add_argument("--target-waves", type=int, default=0)
    ap.add_argument("--tile-loop-unroll", type=int, default=0)
    ap.add_argument("--skip-hw", action="store_true")
    ap.add_argument("--no-check", action="store_true")
    ap.add_argument("--keep-tmp", action="store_true")
    ap.add_argument(
        "--build-dir",
        type=Path,
        default=Path(os.environ.get("WAVE_BUILD_DIR", str(DEFAULT_BUILD))),
    )
    ap.add_argument(
        "--hipcc",
        default=os.environ.get("HIPCC", "/opt/rocm/bin/hipcc"),
    )
    ap.add_argument(
        "--rocm-lib",
        default=os.environ.get("ROCM_LIB", "/opt/rocm/lib"),
    )
    return ap


def validate_args(args: argparse.Namespace, chip: str) -> None:
    positive = (
        "block_m",
        "block_n",
        "head_dim",
        "seq_n",
        "iters",
        "repeats",
        "sim_waves",
        "sim_simds",
        "model_waves",
        "model_simds",
    )
    for name in positive:
        exit_if(
            getattr(args, name) <= 0,
            f"--{name.replace('_', '-')} must be positive",
        )
    exit_if(args.warmup < 0, "--warmup must be non-negative")
    exit_if(args.target_waves < 0, "--target-waves must be non-negative")
    exit_if(args.tile_loop_unroll < 0, "--tile-loop-unroll must be non-negative")
    exit_if(
        args.calibration_file is not None and not args.calibration_file.exists(),
        f"--calibration-file does not exist: {args.calibration_file}",
    )
    for _, name in PRESSURE_BUDGET_OPTIONS:
        exit_if(getattr(args, name) < -1, f"--{name.replace('_', '-')} must be >= -1")
    exit_if(
        bool(args.head_dim & (args.head_dim - 1)), "--head-dim must be a power of two"
    )
    exit_if(
        args.block_m != 16 or args.block_n != 16,
        "MMA FA kernel requires --block-m=16 and --block-n=16",
    )
    exit_if(args.seq_n % args.block_n != 0, "--seq-n must be a multiple of --block-n")
    k_tile = 32 if chip.startswith("gfx950") else 16
    exit_if(args.head_dim % k_tile != 0, f"--head-dim must be a multiple of {k_tile}")


def main() -> int:
    args = build_argparser().parse_args()
    chip = args.chip or detect_chip()
    args.chip = chip
    validate_args(args, chip)

    tmp_ctx = None if args.keep_tmp else tempfile.TemporaryDirectory()
    tmp = Path(tempfile.mkdtemp() if args.keep_tmp else tmp_ctx.name)
    try:
        source = tmp / "flash_attention_kernel.mlir"
        source.write_text(generate_kernel_module(args, chip))
        runner = None if args.skip_hw else compile_runner(args, tmp)
        print(
            f"chip: {chip}\n"
            f"shape: block_m={args.block_m} block_n={args.block_n} "
            f"seq_n={args.seq_n} head_dim={args.head_dim} "
            f"waves_per_workgroup={threads_per_workgroup(chip) // 32} "
            f"target_waves={args.target_waves}"
        )
        results: list[VariantResult] = []
        for variant in args.variants:
            result = run_variant(variant, args, source, runner, tmp)
            print_result(result, args)
            results.append(result)
        print_delta(results)
        if args.keep_tmp:
            print(f"tmp: {tmp}")
    finally:
        if tmp_ctx is not None:
            tmp_ctx.cleanup()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
