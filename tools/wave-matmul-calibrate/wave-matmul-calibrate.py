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

REPO_ROOT = Path(__file__).resolve().parents[2]
DEFAULT_BUILD = REPO_ROOT / "build"
EXAMPLE = REPO_ROOT / "examples/wave/wmma_matmul_tiled.py"
RUNNER_SRC = REPO_ROOT / "tools/wave-matmul-calibrate/wave-matmul-calibrate-runner.cpp"
KERNEL_NAME = "wmma_f16_matmul_tiled"


@dataclass(frozen=True)
class Variant:
    name: str
    insert_pingpong: bool


@dataclass
class VariantResult:
    name: str
    sim_cycles: dict[tuple[int, int, int], int]
    hw_cycles: int | None
    hw_us: float | None


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


def pipeline_text(*, insert_pingpong: bool) -> str:
    insert = ""
    if insert_pingpong:
        insert = (
            "    wave.transform.insert_pingpong_barriers from %rl\n"
            "        : (!transform.any_op) -> ()\n"
        )
    return f"""module attributes {{transform.with_named_sequence}} {{
  transform.named_sequence @__transform_main(
      %root: !transform.any_op {{transform.consumed}}) -> !transform.any_op {{
    %r0 = transform.apply_registered_pass "waveamd-to-machine" to %root
        : (!transform.any_op) -> !transform.any_op
    %rk = transform.apply_registered_pass "canonicalize" to %r0
        : (!transform.any_op) -> !transform.any_op
    %rc = transform.apply_registered_pass "cse" to %rk
        : (!transform.any_op) -> !transform.any_op
    %rl = transform.apply_registered_pass "loop-invariant-code-motion" to %rc
        : (!transform.any_op) -> !transform.any_op
{insert}    %r1 = transform.apply_registered_pass "waveamd-abi-lowering" to %rl
        : (!transform.any_op) -> !transform.any_op
    %r2 = transform.apply_registered_pass "waveamd-decompose-mem-tuples" to %r1
        : (!transform.any_op) -> !transform.any_op
    %r3 = transform.apply_registered_pass "waveamd-insert-ticket-waits" to %r2
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


def write_pipeline(tmp: Path, variant: Variant) -> Path:
    path = tmp / variant.name / "pipelines.mlir"
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(pipeline_text(insert_pingpong=variant.insert_pingpong))
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


def run_sim_reports(
    build_dir: Path, machine_mlir: Path, args: argparse.Namespace
) -> dict[tuple[int, int, int], int]:
    wave_sim = build_dir / "bin/wave-sim-report"
    waves_per_workgroup = args.bm * args.bn
    specs = [(1, 1, 0), (waves_per_workgroup, 1, 0)]
    spread_simds = min(max(waves_per_workgroup, 1), 4)
    if spread_simds != 1:
        specs.append((waves_per_workgroup, spread_simds, 0))
    out: dict[tuple[int, int, int], int] = {}
    for waves, simds, delay in specs:
        text = run(
            [
                str(wave_sim),
                f"--func={KERNEL_NAME}",
                f"--waves={waves}",
                f"--simds={simds}",
                f"--start-delay={delay}",
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


def parse_hw(stdout: str) -> tuple[int, float]:
    cycles = re.search(r"^per_launch_cycles_wallclock:\s+(\d+)$", stdout, re.M)
    micros = re.search(r"^per_launch_us:\s+([0-9.]+)$", stdout, re.M)
    if not cycles or not micros:
        sys.exit("runner output missing timing fields")
    return int(cycles.group(1)), float(micros.group(1))


def run_hw(
    runner: Path, hsaco: Path, args: argparse.Namespace, rocm_lib: str
) -> tuple[int, float]:
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
    return parse_hw(stdout)


def print_result(result: VariantResult) -> None:
    print(f"variant: {result.name}")
    for (waves, simds, delay), cycles in sorted(result.sim_cycles.items()):
        print(
            f"  sim_cycles waves={waves} simds={simds} "
            f"start_delay={delay}: {cycles}"
        )
    if result.hw_cycles is not None and result.hw_us is not None:
        print(f"  hw_per_launch_us: {result.hw_us:.3f}")
        print(f"  hw_cycles_wallclock: {result.hw_cycles}")


def print_delta(results: list[VariantResult]) -> None:
    by_name = {r.name: r for r in results}
    base = by_name.get("baseline")
    pp = by_name.get("pingpong")
    if not base or not pp:
        return
    print("delta: pingpong - baseline")
    for spec, pp_cycles in sorted(pp.sim_cycles.items()):
        if spec in base.sim_cycles:
            print(f"  sim_cycles {spec}: {pp_cycles - base.sim_cycles[spec]:+d}")
    if base.hw_cycles is not None and pp.hw_cycles is not None:
        delta = pp.hw_cycles - base.hw_cycles
        pct = 100.0 * delta / max(base.hw_cycles, 1)
        print(f"  hw_cycles_wallclock: {delta:+d} ({pct:+.1f}%)")


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
    ap.add_argument("--use-buffer", action="store_true")
    ap.add_argument("--use-dma-lds", action="store_true")
    ap.add_argument(
        "--matrix-intrinsic",
        choices=("auto", "wmma", "mfma", "mfma_gfx950"),
        default="auto",
    )
    ap.add_argument("--iters", type=int, default=1000)
    ap.add_argument("--warmup", type=int, default=10)
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


def main() -> int:
    args = build_argparser().parse_args()
    chip = args.chip or detect_chip()
    variants = [
        Variant("baseline", insert_pingpong=False),
        Variant("pingpong", insert_pingpong=True),
    ]

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
            f"wave_k_tiles={args.wave_k_tiles}"
        )
        results: list[VariantResult] = []
        for variant in variants:
            pipeline = write_pipeline(tmp, variant)
            machine = lower_machine(args.build_dir, source, pipeline, tmp, variant.name)
            sim_cycles = run_sim_reports(args.build_dir, machine, args)
            hw_cycles = None
            hw_us = None
            if runner is not None:
                hsaco = lower_hsaco(args.build_dir, source, pipeline, tmp, variant.name)
                hw_cycles, hw_us = run_hw(runner, hsaco, args, args.rocm_lib)
            result = VariantResult(variant.name, sim_cycles, hw_cycles, hw_us)
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
