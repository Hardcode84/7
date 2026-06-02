#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2026 wave-mlir contributors
#
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
"""Calibrate matmul scheduling variants against simulator + hardware timing."""

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
EXAMPLE = REPO_ROOT / "examples/wave/wmma_matmul_tiled.py"
RUNNER_SRC = REPO_ROOT / "tools/wave-matmul-calibrate/wave-matmul-calibrate-runner.cpp"
KERNEL_NAME = "wmma_f16_matmul_tiled"


@dataclass(frozen=True)
class Variant:
    name: str
    apply_schedule: bool
    schedule_model: str = "single"


@dataclass
class VariantResult:
    name: str
    sim_cycles: dict[tuple[int, int, int], int]
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
        "scheduled_multiwave",
        apply_schedule=True,
        schedule_model="multi",
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
    options["model-waves"] = waves_per_workgroup(args)
    options["model-simds"] = spread_simds(args)
    options["model-start-delay"] = 0


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
        f"--m={args.m}",
        f"--n={args.n}",
        f"--k={args.k}",
        f"--bm={args.bm}",
        f"--bn={args.bn}",
        f"--wave-m-tiles={args.wave_m_tiles}",
        f"--wave-n-tiles={args.wave_n_tiles}",
        f"--wave-k-tiles={args.wave_k_tiles}",
    ]
    if args.use_buffer:
        cmd.append("--use-buffer")
    if args.use_dma_lds:
        cmd.append("--use-dma-lds")
    if args.matrix_intrinsic != "auto":
        cmd.append(f"--matrix-intrinsic={args.matrix_intrinsic}")
    if args.output_type != "f32":
        cmd.append(f"--output-type={args.output_type}")
    if args.target_waves:
        cmd.append(f"--target-waves={args.target_waves}")
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
    match = re.search(r"(func\.func @wmma\w+.*?\n    \})", module_text, re.S)
    if not match:
        sys.exit("could not isolate matmul kernel from generated module")
    kernel = match.group(1).replace("\n    ", "\n  ")
    target = f"amdgcn-amd-amdhsa--{chip}"
    return (
        f'module attributes {{waveamdmachine.target = "{target}"}} '
        f"{{\n{kernel}\n}}\n"
    )


def waves_per_workgroup(args: argparse.Namespace) -> int:
    return args.bm * args.bn


def spread_simds(args: argparse.Namespace) -> int:
    return min(max(waves_per_workgroup(args), 1), 4)


def sim_report_specs(args: argparse.Namespace) -> list[tuple[int, int, int]]:
    waves = waves_per_workgroup(args)
    specs = [(1, 1, 0), (waves, 1, 0), (waves, spread_simds(args), 0)]
    out: list[tuple[int, int, int]] = []
    seen: set[tuple[int, int, int]] = set()
    for spec in specs:
        if spec in seen:
            continue
        out.append(spec)
        seen.add(spec)
    return out


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
        from mlir.dialects import transform
    except ModuleNotFoundError as err:
        raise SystemExit(
            f"MLIR Python bindings missing under {package_path}: {err}"
        ) from err
    return ir, transform


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
        lowered = transform.IncludeOp(
            [any_op],
            "waveamd_backend_lower",
            transform.FailurePropagationMode.Propagate,
            [root],
        ).result
        finish_input = lowered
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
                "waveamd-machine-schedule",
                options=schedule_options,
            ).result
        finish_input = transform.IncludeOp(
            [any_op],
            "waveamd_backend_finish",
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
    ir, transform = import_mlir_bindings(build_dir)
    with ir.Context() as ctx, ir.Location.unknown(ctx):
        module = ir.Module.parse(read_backend_pipeline(build_dir))
        erase_default_entry(ir, module)
        append_calibration_entry(
            ir, transform, module, schedule_options, report_options
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
            schedule_options=schedule_pass_options(variant, args),
            report_options=schedule_report_options(variant, args),
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
            str(source),
            "--pass-pipeline=builtin.module("
            f"transform-preload-library{{transform-library-paths={pipeline}}},"
            "transform-interpreter)",
        ]
    )
    out.write_text(text)
    return out


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


def detect_asm_chip(source: Path) -> str:
    text = source.read_text()
    match = re.search(r'waveamdmachine\.target = "amdgcn-amd-amdhsa--([^"]+)"', text)
    if not match:
        sys.exit("source missing waveamdmachine.target")
    return match.group(1)


def parse_total_cycles(text: str) -> int:
    match = re.search(r"^total_cycles:\s+(\d+)$", text, re.M)
    if not match:
        sys.exit("wave-sim-report output missing total_cycles")
    return int(match.group(1))


def compute_loop_trip_count(args: argparse.Namespace) -> int:
    virtual_k_steps = div_exact(args.k, 16 * args.wave_k_tiles, "bad K blocking")
    return max(virtual_k_steps - 1, 0)


def div_exact(num: int, den: int, what: str) -> int:
    if den <= 0 or num % den != 0:
        sys.exit(what)
    return num // den


def run_sim_reports(
    build_dir: Path, machine_mlir: Path, args: argparse.Namespace
) -> dict[tuple[int, int, int], int]:
    wave_sim = build_dir / "bin/wave-sim-report"
    trip_count = compute_loop_trip_count(args)
    out: dict[tuple[int, int, int], int] = {}
    for waves, simds, delay in sim_report_specs(args):
        text = run(
            [
                str(wave_sim),
                f"--func={KERNEL_NAME}",
                f"--waves={waves}",
                f"--simds={simds}",
                f"--start-delay={delay}",
                f"--trip-count={trip_count}",
                *(
                    [f"--calibration-file={args.calibration_file}"]
                    if args.calibration_file
                    else []
                ),
                str(machine_mlir),
            ]
        )
        out[(waves, simds, delay)] = parse_total_cycles(text)
    return out


def compile_runner(args: argparse.Namespace, tmp: Path) -> Path:
    hipcc = args.hipcc
    if not Path(hipcc).exists() and shutil.which(hipcc) is None:
        sys.exit(f"hipcc not found: {hipcc}")
    runner = tmp / "wave-matmul-calibrate-runner"
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
        "--m",
        str(args.m),
        "--n",
        str(args.n),
        "--k",
        str(args.k),
        "--bm",
        str(args.bm),
        "--bn",
        str(args.bn),
        "--wave-m-tiles",
        str(args.wave_m_tiles),
        "--wave-n-tiles",
        str(args.wave_n_tiles),
        "--wave-k-tiles",
        str(args.wave_k_tiles),
        "--c-type",
        args.output_type,
        "--iters",
        str(args.iters),
        "--warmup",
        str(args.warmup),
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
    sim_cycles = run_sim_reports(args.build_dir, machine, args)
    if runner is None:
        return VariantResult(variant.name, sim_cycles, [], [], None)
    hsaco = lower_hsaco(args.build_dir, source, pipeline, tmp, variant.name)
    hw_cycles, hw_us, hw_check = run_hw_repeats(runner, hsaco, args)
    return VariantResult(variant.name, sim_cycles, hw_cycles, hw_us, hw_check)


def print_result(result: VariantResult) -> None:
    print(f"variant: {result.name}")
    for (waves, simds, delay), cycles in sorted(result.sim_cycles.items()):
        print(
            f"  sim_cycles waves={waves} simds={simds} "
            f"start_delay={delay}: {cycles}"
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
        for spec, cycles in sorted(result.sim_cycles.items()):
            if spec in base.sim_cycles:
                print(f"  sim_cycles {spec}: {cycles - base.sim_cycles[spec]:+d}")
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


def build_argparser() -> argparse.ArgumentParser:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--chip", default="", help="gfx target; default from rocminfo")
    ap.add_argument("--m", type=int, default=32)
    ap.add_argument("--n", type=int, default=32)
    ap.add_argument("--k", type=int, default=32)
    ap.add_argument("--bm", type=int, default=1)
    ap.add_argument("--bn", type=int, default=2)
    ap.add_argument("--wave-m-tiles", type=int, default=1)
    ap.add_argument("--wave-n-tiles", type=int, default=1)
    ap.add_argument("--wave-k-tiles", type=int, default=1)
    ap.add_argument("--target-waves", type=int, default=0)
    ap.add_argument("--use-buffer", action="store_true")
    ap.add_argument("--use-dma-lds", action="store_true")
    ap.add_argument(
        "--matrix-intrinsic",
        choices=("auto", "wmma", "mfma", "mfma_gfx950"),
        default="auto",
    )
    ap.add_argument("--output-type", choices=("f32", "f16"), default="f32")
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


def validate_args(args: argparse.Namespace) -> None:
    if args.repeats <= 0:
        sys.exit("--repeats must be positive")
    if args.target_waves < 0:
        sys.exit("--target-waves must be non-negative")
    if args.calibration_file is not None and not args.calibration_file.exists():
        sys.exit(f"--calibration-file does not exist: {args.calibration_file}")
    for _, name in PRESSURE_BUDGET_OPTIONS:
        if getattr(args, name) < -1:
            sys.exit(f"--{name.replace('_', '-')} must be >= -1")


def main() -> int:
    args = build_argparser().parse_args()
    validate_args(args)
    chip = args.chip or detect_chip()
    variants = args.variants

    tmp_ctx = None if args.keep_tmp else tempfile.TemporaryDirectory()
    tmp = Path(tempfile.mkdtemp() if args.keep_tmp else tmp_ctx.name)
    try:
        source = tmp / "matmul_kernel.mlir"
        source.write_text(generate_kernel_module(args, chip))
        runner = None if args.skip_hw else compile_runner(args, tmp)
        print(
            f"chip: {chip}\n"
            f"shape: m={args.m} n={args.n} k={args.k} bm={args.bm} bn={args.bn} "
            f"wave_m_tiles={args.wave_m_tiles} wave_n_tiles={args.wave_n_tiles} "
            f"wave_k_tiles={args.wave_k_tiles} target_waves={args.target_waves}\n"
            f"sim_loop_trip_count: {compute_loop_trip_count(args)}"
        )
        results: list[VariantResult] = []
        for variant in variants:
            result = run_variant(variant, args, source, runner, tmp)
            print_result(result)
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
