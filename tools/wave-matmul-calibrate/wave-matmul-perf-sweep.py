#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2026 wave-mlir contributors
#
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
"""Run the recommended gfx950 matmul perf sweep."""

from __future__ import annotations

import argparse
import concurrent.futures
import csv
import os
import re
import shutil
import subprocess
import sys
from collections.abc import Sequence
from dataclasses import dataclass
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[2]
CALIBRATOR = REPO_ROOT / "tools/wave-matmul-calibrate/wave-matmul-calibrate.py"
RUNNER_SRC = REPO_ROOT / "tools/wave-matmul-calibrate/wave-matmul-calibrate-runner.cpp"
DEFAULT_BUILD = REPO_ROOT / "build"
DEFAULT_ARTIFACT_NAME = "wave-matmul-perf-sweep-artifacts"
F16_DOC_K_VALUES = (512, 1024, 2048, 3072, 4096, 8192, 16384)
MXFP4_DOC_K_VALUES = (1024, 2048, 3072, 4096, 8192, 16384, 32768)
DEFAULT_ITERS = 200
DEFAULT_WARMUP = 25
DEFAULT_REPEATS = 9
V9_K = 4096


@dataclass(frozen=True)
class KernelSpec:
    key: str
    label: str
    profile: str
    variants: str
    default_k_values: tuple[int, ...]
    sweep_k: bool


@dataclass(frozen=True)
class RunSpec:
    kernel: KernelSpec
    m: int
    n: int
    k: int
    variants: str


@dataclass(frozen=True)
class RunResult:
    spec: RunSpec
    command: list[str]
    returncode: int
    micros: float | None
    cycles: int | None
    check: str | None

    @property
    def tflops(self) -> float | None:
        if self.micros is None:
            return None
        flops = 2 * self.spec.m * self.spec.n * self.spec.k
        return flops / self.micros * 1.0e-6


@dataclass(frozen=True)
class PreparedRun:
    index: int
    spec: RunSpec
    hsaco: Path
    compile_command: list[str]
    run_command: list[str]


KERNELS = {
    "f16": KernelSpec(
        key="f16",
        label="f16",
        profile="gfx950-f16-256x256-8wave",
        variants="scheduled",
        default_k_values=F16_DOC_K_VALUES,
        sweep_k=True,
    ),
    "f16-4wave": KernelSpec(
        key="f16-4wave",
        label="f16-4wave",
        profile="gfx950-f16-256x256-4wave",
        variants="scheduled",
        default_k_values=F16_DOC_K_VALUES,
        sweep_k=True,
    ),
    "mxfp4": KernelSpec(
        key="mxfp4",
        label="mxfp4",
        profile="gfx950-mxfp4-256x256-8wave",
        variants="scheduled",
        default_k_values=MXFP4_DOC_K_VALUES,
        sweep_k=True,
    ),
    "mxfp4-4wave": KernelSpec(
        key="mxfp4-4wave",
        label="mxfp4-4wave",
        profile="gfx950-mxfp4-256x256-4wave",
        variants="scheduled",
        default_k_values=MXFP4_DOC_K_VALUES,
        sweep_k=True,
    ),
    "v9": KernelSpec(
        key="v9",
        label="v9",
        profile="v9-4096-original-wave",
        variants="scheduled",
        default_k_values=(V9_K,),
        sweep_k=False,
    ),
    "v9-transposed": KernelSpec(
        key="v9-transposed",
        label="v9-transposed",
        profile="v9-4096-transposed-wave",
        variants="scheduled",
        default_k_values=(V9_K,),
        sweep_k=False,
    ),
}

KERNEL_ALIASES = {
    "all": ("f16", "mxfp4", "mxfp4-4wave", "v9", "v9-transposed"),
    "mxfp": ("mxfp4",),
    "mxfp4": ("mxfp4",),
    "mxfp4-8wave": ("mxfp4",),
    "mxfp4-4wave": ("mxfp4-4wave",),
    "f16": ("f16",),
    "f16-8wave": ("f16",),
    "f16-4wave": ("f16-4wave",),
    "v9": ("v9",),
    "v9-original": ("v9",),
    "v9-transposed": ("v9-transposed",),
}


def rel(path: Path) -> str:
    try:
        return str(path.resolve().relative_to(REPO_ROOT))
    except ValueError:
        return str(path)


def parse_int_csv(text: str) -> list[int]:
    values: list[int] = []
    for raw in text.split(","):
        item = raw.strip()
        if not item:
            continue
        try:
            value = int(item)
        except ValueError as err:
            raise argparse.ArgumentTypeError(f"bad integer value: {item}") from err
        if value <= 0:
            raise argparse.ArgumentTypeError("shape values must be positive")
        values.append(value)
    if not values:
        raise argparse.ArgumentTypeError("empty value list")
    return values


def parse_kernel_csv(text: str) -> list[KernelSpec]:
    out: list[KernelSpec] = []
    seen: set[str] = set()
    for raw in text.split(","):
        item = raw.strip().lower()
        if not item:
            continue
        if item not in KERNEL_ALIASES:
            choices = ", ".join(sorted(KERNEL_ALIASES))
            raise argparse.ArgumentTypeError(f"unknown kernel '{item}' ({choices})")
        for key in KERNEL_ALIASES[item]:
            if key in seen:
                continue
            out.append(KERNELS[key])
            seen.add(key)
    if not out:
        raise argparse.ArgumentTypeError("empty kernel list")
    return out


def shell_join(cmd: Sequence[str]) -> str:
    return " ".join(subprocess.list2cmdline([part]) for part in cmd)


def run_command(
    cmd: list[str],
    *,
    env: dict[str, str],
    dry_run: bool,
    capture: bool,
) -> subprocess.CompletedProcess[str]:
    print(f"$ {shell_join(cmd)}", flush=True)
    if dry_run:
        return subprocess.CompletedProcess(cmd, 0, "", "")
    return subprocess.run(
        cmd,
        text=True,
        capture_output=capture,
        env=env,
        check=False,
    )


def run_command_silent(
    cmd: list[str],
    *,
    env: dict[str, str],
    dry_run: bool,
) -> subprocess.CompletedProcess[str]:
    if dry_run:
        return subprocess.CompletedProcess(cmd, 0, "", "")
    return subprocess.run(
        cmd,
        text=True,
        capture_output=True,
        env=env,
        check=False,
    )


def rebuild_tools(args: argparse.Namespace, env: dict[str, str]) -> None:
    if args.skip_rebuild:
        return
    cmd = [
        "cmake",
        "--build",
        str(args.build_dir),
        "--target",
        "wave-opt",
        "wave-translate",
        "WavePythonModules",
        "-j",
        str(args.build_jobs),
    ]
    proc = run_command(cmd, env=env, dry_run=args.dry_run, capture=False)
    if proc.returncode != 0:
        raise SystemExit(proc.returncode)


def resolved_hipcc(args: argparse.Namespace) -> str:
    return args.hipcc or os.environ.get("HIPCC", "/opt/rocm/bin/hipcc")


def compile_runner(args: argparse.Namespace, env: dict[str, str]) -> Path:
    runner = args.artifact_dir / "wave-matmul-calibrate-runner"
    hipcc = resolved_hipcc(args)
    if not args.dry_run and not Path(hipcc).exists() and shutil.which(hipcc) is None:
        raise SystemExit(f"hipcc not found: {hipcc}")
    cmd = [hipcc, "-O2", str(RUNNER_SRC), "-o", str(runner)]
    runner.parent.mkdir(parents=True, exist_ok=True)
    proc = run_command(cmd, env=env, dry_run=args.dry_run, capture=False)
    if proc.returncode != 0:
        raise SystemExit(proc.returncode)
    return runner


def build_run_specs(args: argparse.Namespace) -> list[RunSpec]:
    specs: list[RunSpec] = []
    for kernel in args.kernels:
        variants = parse_variant_csv(args.variants or kernel.variants)
        if kernel.sweep_k:
            k_values = args.k_values or kernel.default_k_values
        else:
            k_values = kernel.default_k_values
        for variant in variants:
            for k in k_values:
                specs.append(RunSpec(kernel, args.m, args.n, k, variant))
    return specs


def parse_variant_csv(text: str) -> list[str]:
    variants = [item.strip() for item in text.split(",") if item.strip()]
    if not variants:
        raise SystemExit("empty variant list")
    return variants


def safe_stem(text: str) -> str:
    return re.sub(r"[^A-Za-z0-9_.-]+", "_", text)


def artifact_stem(index: int, spec: RunSpec) -> str:
    parts = [
        f"{index:03d}",
        spec.kernel.key,
        f"m{spec.m}",
        f"n{spec.n}",
        f"k{spec.k}",
        spec.variants,
    ]
    return safe_stem("-".join(parts))


def calibrator_command(args: argparse.Namespace, spec: RunSpec) -> list[str]:
    cmd = [
        sys.executable,
        str(CALIBRATOR),
        "--chip",
        args.chip,
        "--build-dir",
        str(args.build_dir),
        "--kernel-profile",
        spec.kernel.profile,
        "--m",
        str(spec.m),
        "--n",
        str(spec.n),
        "--k",
        str(spec.k),
        "--variants",
        spec.variants,
        "--iters",
        str(args.iters),
        "--warmup",
        str(args.warmup),
        "--repeats",
        str(args.repeats),
        "--sim-trip-count",
        str(args.sim_trip_count),
        "--seed",
        str(args.seed),
    ]
    if not args.check:
        cmd.append("--no-check")
    if args.all_ones:
        cmd.append("--all-ones")
    if args.rand_int:
        cmd.append("--rand-int")
    if args.rocm_lib:
        cmd.extend(["--rocm-lib", args.rocm_lib])
    cmd.extend(args.extra_calibrator_arg)
    return cmd


def prepare_runs(
    args: argparse.Namespace, specs: list[RunSpec], runner: Path
) -> list[PreparedRun]:
    prepared: list[PreparedRun] = []
    for index, spec in enumerate(specs):
        hsaco = args.artifact_dir / f"{artifact_stem(index, spec)}.hsaco"
        base = calibrator_command(args, spec)
        compile_cmd = [*base, "--emit-hsaco", str(hsaco)]
        run_cmd = [
            *base,
            "--run-hsaco",
            str(hsaco),
            "--runner",
            str(runner),
        ]
        prepared.append(PreparedRun(index, spec, hsaco, compile_cmd, run_cmd))
    return prepared


def parse_result(
    spec: RunSpec, command: list[str], proc: subprocess.CompletedProcess[str]
) -> RunResult:
    stdout = proc.stdout or ""
    micros_match = re.search(r"^  hw_per_launch_us:\s+([0-9.]+)$", stdout, re.M)
    cycles_match = re.search(r"^  hw_cycles_wallclock:\s+(\d+)$", stdout, re.M)
    check_match = re.search(r"^  hw_output_check:\s+(\w+)$", stdout, re.M)
    return RunResult(
        spec=spec,
        command=command,
        returncode=proc.returncode,
        micros=float(micros_match.group(1)) if micros_match else None,
        cycles=int(cycles_match.group(1)) if cycles_match else None,
        check=check_match.group(1) if check_match else None,
    )


def run_compile_jobs(
    args: argparse.Namespace, env: dict[str, str], prepared: list[PreparedRun]
) -> dict[int, subprocess.CompletedProcess[str]]:
    completed: dict[int, subprocess.CompletedProcess[str]] = {}
    jobs = min(args.compile_jobs or args.build_jobs, len(prepared))
    with concurrent.futures.ThreadPoolExecutor(max_workers=jobs) as executor:
        futures = {
            executor.submit(
                run_command_silent,
                item.compile_command,
                env=env,
                dry_run=False,
            ): item
            for item in prepared
        }
        for future in concurrent.futures.as_completed(futures):
            item = futures[future]
            proc = future.result()
            completed[item.index] = proc
            if proc.returncode == 0:
                print(f"compiled: {rel(item.hsaco)}", flush=True)
            else:
                print_compile_failure(item, proc)
    return completed


def print_compile_failure(
    item: PreparedRun, proc: subprocess.CompletedProcess[str]
) -> None:
    print(f"compile failed: {rel(item.hsaco)}", file=sys.stderr)
    if proc.stdout:
        sys.stdout.write(proc.stdout)
    if proc.stderr:
        sys.stderr.write(proc.stderr)


def partition_compile_results(
    prepared: list[PreparedRun],
    completed: dict[int, subprocess.CompletedProcess[str]],
) -> tuple[list[PreparedRun], list[RunResult]]:
    failures: list[RunResult] = []
    ok: list[PreparedRun] = []
    for item in prepared:
        proc = completed[item.index]
        if proc.returncode == 0:
            ok.append(item)
        else:
            failures.append(parse_result(item.spec, item.compile_command, proc))
    return ok, failures


def compile_hsacos(
    args: argparse.Namespace, env: dict[str, str], prepared: list[PreparedRun]
) -> tuple[list[PreparedRun], list[RunResult]]:
    if not prepared:
        return [], []
    jobs = min(args.compile_jobs or args.build_jobs, len(prepared))
    print(f"\ncompile phase: {len(prepared)} HSACO(s), jobs={jobs}", flush=True)
    for item in prepared:
        print(f"$ {shell_join(item.compile_command)}", flush=True)
    if args.dry_run:
        return prepared, []

    ok, failures = partition_compile_results(
        prepared, run_compile_jobs(args, env, prepared)
    )
    if failures and not args.keep_going:
        raise SystemExit(failures[0].returncode)
    return ok, failures


def run_sweep(
    args: argparse.Namespace, env: dict[str, str], prepared: list[PreparedRun]
) -> list[RunResult]:
    results: list[RunResult] = []
    for item in prepared:
        spec = item.spec
        print(
            f"\n=== {spec.kernel.label} m={spec.m} n={spec.n} k={spec.k} "
            f"variants={spec.variants} ===",
            flush=True,
        )
        cmd = item.run_command
        proc = run_command(cmd, env=env, dry_run=args.dry_run, capture=True)
        if proc.stdout:
            sys.stdout.write(proc.stdout)
        if proc.stderr:
            sys.stderr.write(proc.stderr)
        result = parse_result(spec, cmd, proc)
        results.append(result)
        if proc.returncode != 0 and not args.keep_going:
            raise SystemExit(proc.returncode)
    return results


def print_summary(results: list[RunResult]) -> None:
    if not results:
        return
    print("\nsummary:")
    print("kernel          M     N     K      variant    us        TFLOP/s   check")
    print("--------------  ----  ----  -----  ---------  --------  --------  -------")
    for result in results:
        spec = result.spec
        micros = f"{result.micros:.3f}" if result.micros is not None else "-"
        tflops = f"{result.tflops:.2f}" if result.tflops is not None else "-"
        check = result.check or ("failed" if result.returncode != 0 else "-")
        print(
            f"{spec.kernel.label:<14}  {spec.m:<4}  {spec.n:<4}  {spec.k:<5}  "
            f"{spec.variants:<9}  {micros:>8}  {tflops:>8}  {check}"
        )


def write_csv(path: Path, results: list[RunResult]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", newline="", encoding="utf-8") as f:
        writer = csv.writer(f)
        writer.writerow(
            [
                "kernel",
                "profile",
                "m",
                "n",
                "k",
                "variants",
                "iters",
                "warmup",
                "repeats",
                "us",
                "tflops",
                "cycles",
                "check",
                "returncode",
                "command",
            ]
        )
        for result in results:
            spec = result.spec
            writer.writerow(
                [
                    spec.kernel.label,
                    spec.kernel.profile,
                    spec.m,
                    spec.n,
                    spec.k,
                    spec.variants,
                    result.command[result.command.index("--iters") + 1],
                    result.command[result.command.index("--warmup") + 1],
                    result.command[result.command.index("--repeats") + 1],
                    result.micros,
                    result.tflops,
                    result.cycles,
                    result.check,
                    result.returncode,
                    shell_join(result.command),
                ]
            )


def build_argparser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--kernels",
        type=parse_kernel_csv,
        default=parse_kernel_csv("all"),
        help=(
            "comma-separated f16,f16-4wave,mxfp4,mxfp4-4wave,v9,"
            "v9-transposed,all; f16-8wave aliases f16 and "
            "mxfp/mxfp4-8wave alias mxfp4"
        ),
    )
    parser.add_argument("--m", type=int, default=4096)
    parser.add_argument("--n", type=int, default=4096)
    parser.add_argument(
        "--k-values",
        type=parse_int_csv,
        default=None,
        help=(
            "comma-separated K override for f16/MXFP4 sweep kernels; defaults match "
            "docs/Gfx950MatmulProfiles.md; v9 variants always use K=4096"
        ),
    )
    parser.add_argument(
        "--iters",
        type=int,
        default=DEFAULT_ITERS,
        help="timed launches per repeat",
    )
    parser.add_argument("--warmup", type=int, default=DEFAULT_WARMUP)
    parser.add_argument("--repeats", type=int, default=DEFAULT_REPEATS)
    parser.add_argument("--seed", type=int, default=0)
    parser.add_argument("--chip", default="gfx950")
    parser.add_argument("--build-dir", type=Path, default=DEFAULT_BUILD)
    parser.add_argument("--sim-trip-count", type=int, default=0)
    parser.add_argument(
        "--variants",
        default="",
        help=(
            "override variants for every kernel; defaults are scheduled "
            "f16/mxfp4/v9 variants"
        ),
    )
    parser.add_argument(
        "--check",
        action="store_true",
        help="enable CPU output checks; default perf sweep skips them",
    )
    input_mode = parser.add_mutually_exclusive_group()
    input_mode.add_argument("--all-ones", action="store_true")
    input_mode.add_argument("--rand-int", action="store_true")
    parser.add_argument("--keep-going", action="store_true")
    parser.add_argument("--dry-run", action="store_true")
    parser.add_argument("--skip-rebuild", action="store_true")
    parser.add_argument(
        "--build-jobs",
        type=int,
        default=max(1, os.cpu_count() or 1),
    )
    parser.add_argument(
        "--compile-jobs",
        type=int,
        default=0,
        help="parallel HSACO compile jobs; default follows --build-jobs",
    )
    parser.add_argument(
        "--artifact-dir",
        type=Path,
        default=None,
        help="directory for precompiled sweep HSACOs and the runner",
    )
    parser.add_argument(
        "--hipcc",
        default=os.environ.get("HIPCC"),
        help="HIP compiler for the shared benchmark runner",
    )
    parser.add_argument(
        "--rocm-lib",
        default=os.environ.get("ROCM_LIB"),
        help="ROCm library path passed to wave-matmul-calibrate.py",
    )
    parser.add_argument(
        "--hip-visible-devices",
        help="set HIP_VISIBLE_DEVICES for all benchmark runs",
    )
    parser.add_argument("--csv", type=Path, help="write summary CSV")
    parser.add_argument(
        "--extra-calibrator-arg",
        action="append",
        default=[],
        help="append one raw argument to wave-matmul-calibrate.py",
    )
    return parser


def validate_input_mode(args: argparse.Namespace) -> None:
    if args.rand_int and any(kernel.key.startswith("mxfp4") for kernel in args.kernels):
        raise SystemExit("--rand-int supports f16 kernels only")


def validate_args(args: argparse.Namespace) -> None:
    for name in ("m", "n", "iters", "warmup", "repeats", "build_jobs"):
        if getattr(args, name) <= 0:
            raise SystemExit(f"--{name.replace('_', '-')} must be positive")
    if args.compile_jobs < 0:
        raise SystemExit("--compile-jobs must be non-negative")
    if args.sim_trip_count < -1:
        raise SystemExit("--sim-trip-count must be >= -1")
    validate_input_mode(args)
    if any(kernel.key.startswith("v9") for kernel in args.kernels) and (
        args.m % 256 != 0 or args.n % 256 != 0
    ):
        raise SystemExit("v9 variants require --m/--n multiples of 256")


def main(argv: list[str]) -> int:
    args = build_argparser().parse_args(argv)
    validate_args(args)
    if args.artifact_dir is None:
        args.artifact_dir = args.build_dir / DEFAULT_ARTIFACT_NAME
    env = os.environ.copy()
    if args.hip_visible_devices is not None:
        env["HIP_VISIBLE_DEVICES"] = args.hip_visible_devices

    rebuild_tools(args, env)
    specs = build_run_specs(args)
    runner = compile_runner(args, env)
    prepared = prepare_runs(args, specs, runner)
    runnable, compile_failures = compile_hsacos(args, env, prepared)
    results = [*compile_failures, *run_sweep(args, env, runnable)]
    print_summary(results)
    if args.csv is not None and not args.dry_run:
        write_csv(args.csv, results)
        print(f"\nwrote {rel(args.csv)}")
    return 1 if any(result.returncode != 0 for result in results) else 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
