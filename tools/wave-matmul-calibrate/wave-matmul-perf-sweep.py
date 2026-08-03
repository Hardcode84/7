#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2026 wave-mlir contributors
#
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
"""Run the recommended gfx950 kernel perf sweep."""

from __future__ import annotations

import argparse
import concurrent.futures
import csv
import math
import os
import re
import shutil
import subprocess
import sys
from collections.abc import Sequence
from dataclasses import dataclass
from enum import Enum
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[2]
MATMUL_CALIBRATOR = REPO_ROOT / "tools/wave-matmul-calibrate/wave-matmul-calibrate.py"
MATMUL_RUNNER_SRC = (
    REPO_ROOT / "tools/wave-matmul-calibrate/wave-matmul-calibrate-runner.cpp"
)
FA_CALIBRATOR = REPO_ROOT / "tools/wave-fa-calibrate/wave-fa-gfx950.py"
FA_RUNNER_SRC = REPO_ROOT / "tools/wave-fa-calibrate/wave-fa-gfx950-runner.cpp"
DEFAULT_BUILD = REPO_ROOT / "build"
DEFAULT_ARTIFACT_NAME = "wave-matmul-perf-sweep-artifacts"
F16_DOC_K_VALUES = (512, 1024, 2048, 3072, 4096, 8192, 16384)
MXFP4_DOC_K_VALUES = (1024, 2048, 3072, 4096, 8192, 16384, 32768)
FA_DEFAULT_BATCH = 2
FA_DEFAULT_HEADS = 64
FA_DEFAULT_SEQUENCE = 8192
FA_HEAD_DIM = 128
FA_DEFAULT_XCDS = 8
DEFAULT_ITERS = 200
DEFAULT_WARMUP = 25
DEFAULT_REPEATS = 9
DEFAULT_STREAMK_WORKERS = 256
V9_K = 4096


class Workload(Enum):
    MATMUL = "matmul"
    FLASH_ATTENTION = "flash-attention"


@dataclass(frozen=True)
class KernelSpec:
    key: str
    label: str
    workload: Workload
    profile: str
    variants: str
    default_k_values: tuple[int, ...]
    sweep_k: bool
    waves: int = 0
    default_streamk_workers: int = 0
    fixed_shapes: tuple[tuple[int, int, int], ...] = ()


@dataclass(frozen=True)
class MatmulShape:
    m: int
    n: int
    k: int

    @property
    def flops(self) -> int:
        return 2 * self.m * self.n * self.k

    def artifact_parts(self) -> tuple[str, ...]:
        return (f"m{self.m}", f"n{self.n}", f"k{self.k}")

    def display(self) -> str:
        return f"M={self.m},N={self.n},K={self.k}"


@dataclass(frozen=True)
class FlashAttentionShape:
    batch: int
    heads: int
    sequence: int
    head_dim: int
    xcds: int
    waves: int

    @property
    def flops(self) -> int:
        return 4 * self.batch * self.heads * self.sequence**2 * self.head_dim

    def artifact_parts(self) -> tuple[str, ...]:
        return (
            f"b{self.batch}",
            f"h{self.heads}",
            f"s{self.sequence}",
            f"d{self.head_dim}",
            f"w{self.waves}",
        )

    def display(self) -> str:
        return (
            f"B={self.batch},H={self.heads},S={self.sequence},"
            f"D={self.head_dim},W={self.waves}"
        )


RunShape = MatmulShape | FlashAttentionShape


@dataclass(frozen=True)
class RunSpec:
    kernel: KernelSpec
    shape: RunShape
    variants: str
    streamk_workers: int = 0

    @property
    def flops(self) -> int:
        return self.shape.flops


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
        return self.spec.flops / self.micros * 1.0e-6


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
        workload=Workload.MATMUL,
        profile="gfx950-f16-256x256-8wave",
        variants="scheduled",
        default_k_values=F16_DOC_K_VALUES,
        sweep_k=True,
    ),
    "f16-spatial": KernelSpec(
        key="f16-spatial",
        label="f16-spatial",
        workload=Workload.MATMUL,
        profile="gfx950-f16-256x256-8wave-spatial",
        variants="scheduled",
        default_k_values=F16_DOC_K_VALUES,
        sweep_k=True,
    ),
    "f16-4wave": KernelSpec(
        key="f16-4wave",
        label="f16-4wave",
        workload=Workload.MATMUL,
        profile="gfx950-f16-256x256-4wave",
        variants="scheduled",
        default_k_values=F16_DOC_K_VALUES,
        sweep_k=True,
    ),
    "f16-streamk": KernelSpec(
        key="f16-streamk",
        label="f16-streamk",
        workload=Workload.MATMUL,
        profile="gfx950-f16-256x256-4wave-streamk",
        variants="scheduled",
        default_k_values=F16_DOC_K_VALUES,
        sweep_k=True,
        default_streamk_workers=DEFAULT_STREAMK_WORKERS,
    ),
    "mxfp4": KernelSpec(
        key="mxfp4",
        label="mxfp4",
        workload=Workload.MATMUL,
        profile="gfx950-mxfp4-256x256-8wave",
        variants="scheduled",
        default_k_values=MXFP4_DOC_K_VALUES,
        sweep_k=True,
    ),
    "mxfp4-4wave": KernelSpec(
        key="mxfp4-4wave",
        label="mxfp4-4wave",
        workload=Workload.MATMUL,
        profile="gfx950-mxfp4-256x256-4wave",
        variants="scheduled",
        default_k_values=MXFP4_DOC_K_VALUES,
        sweep_k=True,
    ),
    "mxfp4-aiter-32x128": KernelSpec(
        key="mxfp4-aiter-32x128",
        label="mxfp4-aiter-32x128",
        workload=Workload.MATMUL,
        profile="gfx950-mxfp4-aiter-32x128",
        variants="scheduled",
        default_k_values=(),
        sweep_k=False,
        fixed_shapes=((256, 4096, 4096),),
    ),
    "mxfp4-aiter-64x128": KernelSpec(
        key="mxfp4-aiter-64x128",
        label="mxfp4-aiter-64x128",
        workload=Workload.MATMUL,
        profile="gfx950-mxfp4-aiter-64x128",
        variants="scheduled",
        default_k_values=(),
        sweep_k=False,
        fixed_shapes=((256, 8192, 4096), (512, 4096, 4096)),
    ),
    "mxfp4-aiter-128x128": KernelSpec(
        key="mxfp4-aiter-128x128",
        label="mxfp4-aiter-128x128",
        workload=Workload.MATMUL,
        profile="gfx950-mxfp4-aiter-128x128",
        variants="scheduled",
        default_k_values=(),
        sweep_k=False,
        fixed_shapes=((512, 8192, 4096),),
    ),
    "mxfp4-aiter-128x256": KernelSpec(
        key="mxfp4-aiter-128x256",
        label="mxfp4-aiter-128x256",
        workload=Workload.MATMUL,
        profile="gfx950-mxfp4-aiter-128x256",
        variants="scheduled",
        default_k_values=(),
        sweep_k=False,
        fixed_shapes=((2048, 4096, 8192),),
    ),
    "mxfp4-aiter-256x256": KernelSpec(
        key="mxfp4-aiter-256x256",
        label="mxfp4-aiter-256x256",
        workload=Workload.MATMUL,
        profile="gfx950-mxfp4-aiter-256x256",
        variants="scheduled",
        default_k_values=(),
        sweep_k=False,
        fixed_shapes=((2048, 8192, 4096), (2048, 8192, 8192)),
    ),
    "v9": KernelSpec(
        key="v9",
        label="v9",
        workload=Workload.MATMUL,
        profile="v9-4096-original-wave",
        variants="scheduled",
        default_k_values=(V9_K,),
        sweep_k=False,
    ),
    "v9-transposed": KernelSpec(
        key="v9-transposed",
        label="v9-transposed",
        workload=Workload.MATMUL,
        profile="v9-4096-transposed-wave",
        variants="scheduled",
        default_k_values=(V9_K,),
        sweep_k=False,
    ),
    "fa-8wave": KernelSpec(
        key="fa-8wave",
        label="fa-8wave",
        workload=Workload.FLASH_ATTENTION,
        profile="gfx950-fa-bf16-d128-8wave",
        variants="scheduled",
        default_k_values=(),
        sweep_k=False,
        waves=8,
    ),
}

KERNEL_ALIASES = {
    "all": (
        "f16",
        "f16-spatial",
        "f16-4wave",
        "f16-streamk",
        "mxfp4",
        "mxfp4-4wave",
        "v9",
        "v9-transposed",
        "fa-8wave",
    ),
    "mxfp": ("mxfp4",),
    "mxfp4": ("mxfp4",),
    "mxfp4-8wave": ("mxfp4",),
    "mxfp4-4wave": ("mxfp4-4wave",),
    "mxfp4-aiter": (
        "mxfp4-aiter-32x128",
        "mxfp4-aiter-64x128",
        "mxfp4-aiter-128x128",
        "mxfp4-aiter-128x256",
        "mxfp4-aiter-256x256",
    ),
    "f16": ("f16",),
    "f16-8wave": ("f16",),
    "f16-spatial": ("f16-spatial",),
    "f16-4wave": ("f16-4wave",),
    "f16-streamk": ("f16-streamk",),
    "v9": ("v9",),
    "v9-original": ("v9",),
    "v9-transposed": ("v9-transposed",),
    "fa": ("fa-8wave",),
    "fa-8wave": ("fa-8wave",),
    "flash-attention": ("fa-8wave",),
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


def compile_runner(
    args: argparse.Namespace, env: dict[str, str], workload: Workload
) -> Path:
    if workload == Workload.MATMUL:
        source = MATMUL_RUNNER_SRC
        runner = args.artifact_dir / "wave-matmul-calibrate-runner"
        flags: list[str] = []
    else:
        source = FA_RUNNER_SRC
        runner = args.artifact_dir / "wave-fa-gfx950-runner"
        flags = ["-std=c++20"]
    hipcc = resolved_hipcc(args)
    if not args.dry_run and not Path(hipcc).exists() and shutil.which(hipcc) is None:
        raise SystemExit(f"hipcc not found: {hipcc}")
    cmd = [hipcc, "-O2", *flags, str(source), "-o", str(runner)]
    runner.parent.mkdir(parents=True, exist_ok=True)
    proc = run_command(cmd, env=env, dry_run=args.dry_run, capture=False)
    if proc.returncode != 0:
        raise SystemExit(proc.returncode)
    return runner


def compile_runners(
    args: argparse.Namespace, env: dict[str, str]
) -> dict[Workload, Path]:
    workloads = {kernel.workload for kernel in args.kernels}
    return {
        workload: compile_runner(args, env, workload)
        for workload in sorted(workloads, key=lambda item: item.value)
    }


def resolve_streamk_workers(args: argparse.Namespace, kernel: KernelSpec) -> int:
    if not kernel.default_streamk_workers:
        return 0
    if args.streamk_workers is not None:
        return args.streamk_workers
    return kernel.default_streamk_workers


def _build_matmul_run_specs(
    args: argparse.Namespace, kernel: KernelSpec, variants: list[str]
) -> list[RunSpec]:
    if kernel.fixed_shapes:
        return [
            RunSpec(kernel, MatmulShape(*shape), variant)
            for variant in variants
            for shape in kernel.fixed_shapes
        ]
    k_values = (
        args.k_values or kernel.default_k_values
        if kernel.sweep_k
        else kernel.default_k_values
    )
    streamk_workers = resolve_streamk_workers(args, kernel)
    return [
        RunSpec(
            kernel,
            MatmulShape(args.m, args.n, k),
            variant,
            streamk_workers,
        )
        for variant in variants
        for k in k_values
    ]


def build_run_specs(args: argparse.Namespace) -> list[RunSpec]:
    specs: list[RunSpec] = []
    for kernel in args.kernels:
        variants = parse_variant_csv(args.variants or kernel.variants)
        if kernel.workload == Workload.FLASH_ATTENTION:
            shape = FlashAttentionShape(
                args.fa_batch,
                args.fa_heads,
                args.fa_sequence,
                FA_HEAD_DIM,
                args.fa_xcds,
                kernel.waves,
            )
            specs.extend(RunSpec(kernel, shape, variant) for variant in variants)
            continue
        specs.extend(_build_matmul_run_specs(args, kernel, variants))
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
        *spec.shape.artifact_parts(),
        *((f"w{spec.streamk_workers}",) if spec.streamk_workers else ()),
        spec.variants,
    ]
    return safe_stem("-".join(parts))


def matmul_calibrator_command(
    args: argparse.Namespace, spec: RunSpec, shape: MatmulShape
) -> list[str]:
    cmd = [
        sys.executable,
        str(MATMUL_CALIBRATOR),
        "--chip",
        args.chip,
        "--build-dir",
        str(args.build_dir),
        "--kernel-profile",
        spec.kernel.profile,
        "--m",
        str(shape.m),
        "--n",
        str(shape.n),
        "--k",
        str(shape.k),
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
    if args.hpl:
        cmd.append("--hpl")
    if spec.streamk_workers:
        cmd.extend(["--streamk-workers", str(spec.streamk_workers)])
    if args.multi_wave_specialize:
        cmd.append("--multi-wave-specialize")
    if args.rocm_lib:
        cmd.extend(["--rocm-lib", args.rocm_lib])
    cmd.extend(args.extra_calibrator_arg)
    return cmd


def flash_attention_calibrator_command(
    args: argparse.Namespace, shape: FlashAttentionShape
) -> list[str]:
    cmd = [
        sys.executable,
        str(FA_CALIBRATOR),
        "--build-dir",
        str(args.build_dir),
        "--batch",
        str(shape.batch),
        "--heads",
        str(shape.heads),
        "--sequence",
        str(shape.sequence),
        "--xcds",
        str(shape.xcds),
        "--waves",
        str(shape.waves),
        "--qk-max-abs",
        str(args.fa_qk_max_abs),
        "--iters",
        str(args.iters),
        "--warmup",
        str(args.warmup),
        "--repeats",
        str(args.repeats),
        "--seed",
        str(args.seed),
        "--skip-rebuild",
    ]
    if args.check:
        cmd.append("--check")
    if args.rocm_lib:
        cmd.extend(["--rocm-lib", args.rocm_lib])
    cmd.extend(args.extra_fa_calibrator_arg)
    return cmd


def calibrator_command(args: argparse.Namespace, spec: RunSpec) -> list[str]:
    if isinstance(spec.shape, MatmulShape):
        return matmul_calibrator_command(args, spec, spec.shape)
    return flash_attention_calibrator_command(args, spec.shape)


def prepare_runs(
    args: argparse.Namespace,
    specs: list[RunSpec],
    runners: dict[Workload, Path],
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
            str(runners[spec.kernel.workload]),
        ]
        prepared.append(PreparedRun(index, spec, hsaco, compile_cmd, run_cmd))
    return prepared


def parse_result(
    spec: RunSpec, command: list[str], proc: subprocess.CompletedProcess[str]
) -> RunResult:
    stdout = proc.stdout or ""
    micros_match = re.search(r"^  hw_per_launch_us:\s+([0-9.]+)$", stdout, re.M)
    if micros_match is None:
        micros_match = re.search(r"^median_per_launch_us:\s+([0-9.]+)$", stdout, re.M)
    cycles_match = re.search(r"^  hw_cycles_wallclock:\s+(\d+)$", stdout, re.M)
    check_match = re.search(r"^  hw_output_check:\s+(\w+)$", stdout, re.M)
    if check_match is None:
        check_match = re.search(r"^output_check:\s+(\w+)", stdout, re.M)
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
            f"\n=== {spec.kernel.label} {spec.shape.display()} "
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
    print(
        "kernel          shape                                    "
        "variant    us        TFLOP/s   check"
    )
    print(
        "--------------  ---------------------------------------  "
        "---------  --------  --------  -------"
    )
    for result in results:
        spec = result.spec
        micros = f"{result.micros:.3f}" if result.micros is not None else "-"
        tflops = f"{result.tflops:.2f}" if result.tflops is not None else "-"
        check = result.check or ("failed" if result.returncode != 0 else "-")
        print(
            f"{spec.kernel.label:<14}  {spec.shape.display():<39}  "
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
                "workload",
                "batch",
                "heads",
                "sequence",
                "head_dim",
                "xcds",
                "waves",
            ]
        )
        for result in results:
            spec = result.spec
            if isinstance(spec.shape, MatmulShape):
                matmul_fields = (spec.shape.m, spec.shape.n, spec.shape.k)
                fa_fields = ("", "", "", "", "", "")
            else:
                matmul_fields = ("", "", "")
                fa_fields = (
                    spec.shape.batch,
                    spec.shape.heads,
                    spec.shape.sequence,
                    spec.shape.head_dim,
                    spec.shape.xcds,
                    spec.shape.waves,
                )
            writer.writerow(
                [
                    spec.kernel.label,
                    spec.kernel.profile,
                    *matmul_fields,
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
                    spec.kernel.workload.value,
                    *fa_fields,
                ]
            )


def add_shape_arguments(parser: argparse.ArgumentParser) -> None:
    parser.add_argument(
        "--kernels",
        type=parse_kernel_csv,
        default=parse_kernel_csv("all"),
        help=(
            "comma-separated f16,f16-spatial,f16-4wave,f16-streamk,"
            "mxfp4,mxfp4-4wave,mxfp4-aiter,v9,v9-transposed,fa-8wave,all; "
            "f16-8wave aliases f16, "
            "mxfp/mxfp4-8wave alias mxfp4, and fa aliases fa-8wave"
        ),
    )
    parser.add_argument("--m", type=int, default=4096)
    parser.add_argument("--n", type=int, default=4096)
    parser.add_argument(
        "--streamk-workers",
        type=int,
        help=f"Stream-K workers; default {DEFAULT_STREAMK_WORKERS}",
    )
    parser.add_argument("--fa-batch", type=int, default=FA_DEFAULT_BATCH)
    parser.add_argument("--fa-heads", type=int, default=FA_DEFAULT_HEADS)
    parser.add_argument("--fa-sequence", type=int, default=FA_DEFAULT_SEQUENCE)
    parser.add_argument("--fa-xcds", type=int, default=FA_DEFAULT_XCDS)
    parser.add_argument(
        "--fa-qk-max-abs",
        type=float,
        default=1.0,
        help="fixed-reference |Q|,|K| bound for FA",
    )
    parser.add_argument(
        "--k-values",
        type=parse_int_csv,
        default=None,
        help=(
            "comma-separated K override for variable-shape f16/MXFP4 kernels; "
            "AITER and v9 use fixed documented shapes, and FA uses --fa-sequence"
        ),
    )


def add_run_arguments(parser: argparse.ArgumentParser) -> None:
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
            "f16/mxfp4/v9/FA variants"
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
    input_mode.add_argument("--hpl", action="store_true")
    parser.add_argument("--keep-going", action="store_true")
    parser.add_argument("--dry-run", action="store_true")
    parser.add_argument("--skip-rebuild", action="store_true")
    parser.add_argument("--multi-wave-specialize", action="store_true")


def add_tool_arguments(parser: argparse.ArgumentParser) -> None:
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
        help="ROCm library path passed to each calibrator",
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
    parser.add_argument(
        "--extra-fa-calibrator-arg",
        action="append",
        default=[],
        help="append one raw argument to wave-fa-gfx950.py",
    )


def build_argparser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description=__doc__)
    add_shape_arguments(parser)
    add_run_arguments(parser)
    add_tool_arguments(parser)
    return parser


def validate_input_mode(args: argparse.Namespace) -> None:
    if (args.all_ones or args.rand_int or args.hpl) and any(
        kernel.workload == Workload.FLASH_ATTENTION for kernel in args.kernels
    ):
        raise SystemExit("FA sweep supports random floating-point inputs only")
    if (args.rand_int or args.hpl) and any(
        kernel.key.startswith("mxfp4") for kernel in args.kernels
    ):
        raise SystemExit("--rand-int/--hpl support f16 kernels only")


def validate_positive_args(args: argparse.Namespace) -> None:
    for name in (
        "m",
        "n",
        "fa_batch",
        "fa_heads",
        "fa_sequence",
        "fa_xcds",
        "iters",
        "warmup",
        "repeats",
        "build_jobs",
    ):
        if getattr(args, name) <= 0:
            raise SystemExit(f"--{name.replace('_', '-')} must be positive")
    if args.compile_jobs < 0:
        raise SystemExit("--compile-jobs must be non-negative")
    if args.sim_trip_count < -1:
        raise SystemExit("--sim-trip-count must be >= -1")
    if args.streamk_workers is not None and args.streamk_workers <= 0:
        raise SystemExit("--streamk-workers must be positive")


def validate_streamk_args(args: argparse.Namespace) -> None:
    has_streamk = any(kernel.key == "f16-streamk" for kernel in args.kernels)
    if args.streamk_workers is not None and not has_streamk:
        raise SystemExit("--streamk-workers requires --kernels=f16-streamk")


def validate_v9_args(args: argparse.Namespace) -> None:
    if any(kernel.key.startswith("v9") for kernel in args.kernels) and (
        args.m % 256 != 0 or args.n % 256 != 0
    ):
        raise SystemExit("v9 variants require --m/--n multiples of 256")


def validate_fa_args(args: argparse.Namespace) -> None:
    has_fa = any(kernel.workload == Workload.FLASH_ATTENTION for kernel in args.kernels)
    if has_fa and args.chip != "gfx950":
        raise SystemExit("FA sweep requires --chip=gfx950")
    if has_fa and (not math.isfinite(args.fa_qk_max_abs) or args.fa_qk_max_abs <= 0):
        raise SystemExit("--fa-qk-max-abs must be finite and positive")
    if has_fa and args.variants:
        variants = parse_variant_csv(args.variants)
        if variants != ["scheduled"]:
            raise SystemExit("FA sweep supports only --variants=scheduled")


def validate_args(args: argparse.Namespace) -> None:
    validate_positive_args(args)
    validate_input_mode(args)
    validate_streamk_args(args)
    validate_v9_args(args)
    validate_fa_args(args)


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
    runners = compile_runners(args, env)
    prepared = prepare_runs(args, specs, runners)
    runnable, compile_failures = compile_hsacos(args, env, prepared)
    results = [*compile_failures, *run_sweep(args, env, runnable)]
    print_summary(results)
    if args.csv is not None and not args.dry_run:
        write_csv(args.csv, results)
        print(f"\nwrote {rel(args.csv)}")
    return 1 if any(result.returncode != 0 for result in results) else 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
