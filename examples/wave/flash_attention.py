#!/usr/bin/env python3
#  Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
#  See https://llvm.org/LICENSE.txt for license information.
#  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

"""Emit and run the one-wave f32 FlashAttention kernel."""

from __future__ import annotations

import argparse
import math
import re
import subprocess
import sys
from pathlib import Path


def _ensure_package_on_path() -> None:
    try:
        import mlir.dialects.wave_attention  # noqa: F401

        return
    except ImportError:
        pass
    repo_root = Path(__file__).resolve().parents[2]
    path = repo_root / "build" / "python_packages" / "wave_mlir"
    if (path / "mlir" / "dialects").is_dir():
        sys.path.insert(0, str(path))


def _parse_args(argv: list[str]) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--block-m", type=int, default=4)
    parser.add_argument("--block-n", type=int, default=8)
    parser.add_argument("--head-dim", type=int, default=8)
    parser.add_argument("--seed", type=int, default=0)
    parser.add_argument("--chip", default="")
    parser.add_argument("--run", action="store_true")
    parser.add_argument("--compare-cpu", action="store_true")
    parser.add_argument("--dump-asm", action="store_true")
    parser.add_argument("--wave-opt", type=Path, default=None)
    parser.add_argument("--wave-translate", type=Path, default=None)
    parser.add_argument("--mlir-runner", type=Path, default=None)
    parser.add_argument("--shared-lib", action="append", default=None, type=Path)
    parser.add_argument("--atol", type=float, default=3.0e-3)
    parser.add_argument("--rtol", type=float, default=3.0e-3)
    return parser.parse_args(argv)


def _repo_root() -> Path:
    return Path(__file__).resolve().parents[2]


def _default_shared_libs(repo_root: Path) -> list[Path]:
    return [
        repo_root / "build" / "llvm-install" / "lib" / "libmlir_rocm_runtime.so",
        repo_root / "build" / "llvm-install" / "lib" / "libmlir_runner_utils.so",
        repo_root / "build" / "lib" / "libwave_runtime.so",
    ]


def _run_command(cmd: list[str], *, input_text: str) -> str:
    proc = subprocess.run(
        cmd,
        input=input_text,
        text=True,
        capture_output=True,
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


def _dump_asm(module_text: str, args: argparse.Namespace) -> str:
    if not args.chip:
        raise SystemExit("--dump-asm needs --chip=<gfx>")
    repo_root = _repo_root()
    wave_translate = args.wave_translate or repo_root / "build/bin/wave-translate"
    match = re.search(
        r"(func\.func @flash_attention_f32.*?\n    \})", module_text, re.S
    )
    if not match:
        raise SystemExit("could not isolate flash_attention_f32 kernel")
    kernel = match.group(1).replace("\n    ", "\n  ")
    target = f"amdgcn-amd-amdhsa--{args.chip}"
    wrapped = (
        f'module attributes {{waveamdmachine.target = "{target}"}} {{\n{kernel}\n}}\n'
    )
    return _run_command(
        [str(wave_translate), "--wave-to-amdgpu-asm", "-"], input_text=wrapped
    )


def _run_module(module_text: str, args: argparse.Namespace) -> str:
    if not args.chip:
        raise SystemExit("--run/--compare-cpu needs --chip=<gfx>")
    repo_root = _repo_root()
    wave_opt = args.wave_opt or repo_root / "build" / "bin" / "wave-opt"
    mlir_runner = (
        args.mlir_runner or repo_root / "build" / "llvm-install" / "bin" / "mlir-runner"
    )
    pipeline_lib = (
        repo_root / "build" / "share" / "wave-mlir" / "pipelines" / "pipelines.mlir"
    )
    pass_pipeline = (
        "builtin.module("
        f"wave-set-target-attr{{chip={args.chip}}},"
        f"transform-preload-library{{transform-library-paths={pipeline_lib}}},"
        "transform-interpreter{entry-point=compile_kernels},"
        "convert-scf-to-cf,"
        "gpu-to-llvm{use-bare-pointers-for-kernels=true},"
        "convert-to-llvm,"
        "reconcile-unrealized-casts)"
    )
    lowered = _run_command(
        [str(wave_opt), f"--pass-pipeline={pass_pipeline}"],
        input_text=module_text,
    )
    runner_cmd = [str(mlir_runner)]
    for lib in args.shared_lib or _default_shared_libs(repo_root):
        runner_cmd.append(f"--shared-libs={lib}")
    runner_cmd.append("--entry-point-result=void")
    return _run_command(runner_cmd, input_text=lowered)


def _parse_runner_values(output: str) -> tuple[float, ...]:
    try:
        data = output.split("data =", 1)[1]
    except IndexError as exc:
        raise ValueError("mlir-runner output has no memref data payload") from exc
    pattern = r"[-+]?(?:\d+(?:\.\d*)?|\.\d+)(?:[eE][-+]?\d+)?"
    return tuple(float(x) for x in re.findall(pattern, data))


def _compare(
    actual: tuple[float, ...],
    expected: tuple[float, ...],
    *,
    atol: float,
    rtol: float,
) -> tuple[bool, str]:
    if len(actual) != len(expected):
        return False, f"length mismatch: gpu={len(actual)} cpu={len(expected)}"
    worst = (0.0, -1, 0.0, 0.0)
    for i, (got, exp) in enumerate(zip(actual, expected, strict=True)):
        diff = abs(got - exp)
        if diff > worst[0]:
            worst = (diff, i, got, exp)
        if not math.isclose(got, exp, rel_tol=rtol, abs_tol=atol):
            return False, f"slot {i}: gpu={got} cpu={exp} abs_diff={diff}"
    diff, i, got, exp = worst
    return (
        True,
        f"values={len(actual)} max_abs_diff={diff} at slot {i} (gpu={got}, cpu={exp})",
    )


def main(argv: list[str] | None = None) -> int:
    args = _parse_args(sys.argv[1:] if argv is None else argv)
    _ensure_package_on_path()
    from mlir.dialects.wave_attention import (
        build_flash_attention_f32_module,
        compute_flash_attention_f32_reference,
    )

    module = build_flash_attention_f32_module(
        block_m=args.block_m,
        block_n=args.block_n,
        head_dim=args.head_dim,
        random_seed=args.seed,
    )
    module_text = str(module)
    if args.dump_asm:
        sys.stdout.write(_dump_asm(module_text, args))
        return 0
    if not args.run and not args.compare_cpu:
        sys.stdout.write(module_text)
        return 0

    output = _run_module(module_text, args)
    if not args.compare_cpu:
        sys.stdout.write(output)
        return 0

    expected = compute_flash_attention_f32_reference(
        args.block_m,
        args.block_n,
        args.head_dim,
        random_seed=args.seed,
    )
    ok, message = _compare(
        _parse_runner_values(output),
        expected,
        atol=args.atol,
        rtol=args.rtol,
    )
    if not ok:
        sys.stderr.write(f"CPU comparison failed: {message}\n")
        return 1
    sys.stdout.write(f"CPU comparison passed: {message}\n")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
