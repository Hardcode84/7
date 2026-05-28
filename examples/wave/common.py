#!/usr/bin/env python3
#  Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
#  See https://llvm.org/LICENSE.txt for license information.
#  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

from __future__ import annotations

import argparse
import importlib
import math
import re
import subprocess
import sys
from collections.abc import Sequence
from pathlib import Path


def repo_root() -> Path:
    return Path(__file__).resolve().parents[2]


def ensure_package_on_path(module_name: str) -> None:
    try:
        importlib.import_module(module_name)
        return
    except ImportError:
        pass
    path = repo_root() / "build" / "python_packages" / "wave_mlir"
    if (path / "mlir" / "dialects").is_dir():
        sys.path.insert(0, str(path))


def add_execution_args(
    parser: argparse.ArgumentParser,
    *,
    default_atol: float,
    default_rtol: float,
) -> None:
    parser.add_argument(
        "--seed",
        type=int,
        default=0,
        help="seed for deterministic pseudo-random input data",
    )
    parser.add_argument(
        "--chip",
        default="",
        help="AMDGPU chip used for target lowering",
    )
    parser.add_argument(
        "--run",
        action="store_true",
        help="run wave-opt and mlir-runner instead of only printing MLIR",
    )
    parser.add_argument(
        "--compare-cpu",
        action="store_true",
        help="run deterministic random data and compare with CPU",
    )
    parser.add_argument(
        "--dump-asm",
        action="store_true",
        help="lower the kernel through the backend pipeline and print AMDGPU asm",
    )
    parser.add_argument(
        "--wave-opt",
        type=Path,
        default=None,
        help="path to wave-opt; defaults to build/bin/wave-opt",
    )
    parser.add_argument(
        "--wave-translate",
        type=Path,
        default=None,
        help="path to wave-translate; defaults to build/bin/wave-translate",
    )
    parser.add_argument(
        "--mlir-runner",
        type=Path,
        default=None,
        help="path to mlir-runner; defaults to build/llvm-install/bin/mlir-runner",
    )
    parser.add_argument(
        "--shared-lib",
        action="append",
        default=None,
        type=Path,
        help="shared library for mlir-runner; defaults to the usual Wave/MLIR libs",
    )
    parser.add_argument(
        "--atol",
        type=float,
        default=default_atol,
        help="absolute tolerance for --compare-cpu",
    )
    parser.add_argument(
        "--rtol",
        type=float,
        default=default_rtol,
        help="relative tolerance for --compare-cpu",
    )


def default_shared_libs(root: Path | None = None) -> list[Path]:
    root = repo_root() if root is None else root
    return [
        root / "build" / "llvm-install" / "lib" / "libmlir_rocm_runtime.so",
        root / "build" / "llvm-install" / "lib" / "libmlir_runner_utils.so",
        root / "build" / "lib" / "libwave_runtime.so",
    ]


def run_command(cmd: Sequence[str], *, input_text: str) -> str:
    proc = subprocess.run(
        list(cmd),
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


def _extract_generic_func(module_text: str, kernel_name: str) -> str | None:
    marker = f'sym_name = "{kernel_name}"'
    lines = module_text.splitlines()
    for start, line in enumerate(lines):
        if '"func.func"' not in line or marker not in line:
            continue
        indent = len(line) - len(line.lstrip())
        end_prefix = " " * indent + "}) "
        for end in range(start + 1, len(lines)):
            if lines[end].startswith(end_prefix) and lines[end].rstrip().endswith(
                " : () -> ()"
            ):
                return "\n".join(lines[start : end + 1])
    return None


def extract_kernel_op(
    module_text: str, *, kernel_regex: str, kernel_name: str | None = None
) -> str | None:
    match = re.search(kernel_regex, module_text, re.S)
    if match:
        return match.group(1).replace("\n    ", "\n  ")
    if kernel_name is None:
        return None
    return _extract_generic_func(module_text, kernel_name)


def dump_kernel_asm(
    module_text: str,
    *,
    chip: str,
    wave_translate: Path | None,
    kernel_regex: str,
    kernel_name: str | None = None,
    missing_message: str,
) -> str:
    if not chip:
        raise SystemExit("--dump-asm needs --chip=<gfx>")
    root = repo_root()
    wave_translate = wave_translate or root / "build/bin/wave-translate"
    kernel = extract_kernel_op(
        module_text, kernel_regex=kernel_regex, kernel_name=kernel_name
    )
    if kernel is None:
        raise SystemExit(missing_message)
    target = f"amdgcn-amd-amdhsa--{chip}"
    wrapped = (
        f'module attributes {{waveamdmachine.target = "{target}"}} {{\n{kernel}\n}}\n'
    )
    return run_command(
        [str(wave_translate), "--wave-to-amdgpu-asm", "-"], input_text=wrapped
    )


def run_module(
    module_text: str,
    *,
    chip: str,
    wave_opt: Path | None,
    mlir_runner: Path | None,
    shared_libs: Sequence[Path] | None,
) -> str:
    if not chip:
        raise SystemExit("--run/--compare-cpu needs --chip=<gfx>")
    root = repo_root()
    wave_opt = wave_opt or root / "build" / "bin" / "wave-opt"
    mlir_runner = mlir_runner or root / "build" / "llvm-install" / "bin" / "mlir-runner"
    pipeline_lib = (
        root / "build" / "share" / "wave-mlir" / "pipelines" / "pipelines.mlir"
    )
    pass_pipeline = (
        "builtin.module("
        f"wave-set-target-attr{{chip={chip}}},"
        f"transform-preload-library{{transform-library-paths={pipeline_lib}}},"
        "transform-interpreter{entry-point=compile_kernels},"
        "convert-scf-to-cf,"
        "gpu-to-llvm{use-bare-pointers-for-kernels=true},"
        "convert-to-llvm,"
        "reconcile-unrealized-casts)"
    )
    lowered = run_command(
        [str(wave_opt), f"--pass-pipeline={pass_pipeline}"],
        input_text=module_text,
    )
    runner_cmd = [str(mlir_runner)]
    for lib in shared_libs or default_shared_libs(root):
        runner_cmd.append(f"--shared-libs={lib}")
    runner_cmd.append("--entry-point-result=void")
    return run_command(runner_cmd, input_text=lowered)


def parse_runner_values(output: str) -> tuple[float, ...]:
    try:
        data = output.split("data =", 1)[1]
    except IndexError as exc:
        raise ValueError("mlir-runner output has no memref data payload") from exc
    pattern = r"[-+]?(?:\d+(?:\.\d*)?|\.\d+)(?:[eE][-+]?\d+)?"
    return tuple(float(x) for x in re.findall(pattern, data))


def compare_values(
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
