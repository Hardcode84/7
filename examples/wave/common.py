#!/usr/bin/env python3
#  Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
#  See https://llvm.org/LICENSE.txt for license information.
#  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

from __future__ import annotations

import argparse
import importlib
import math
import os
import re
import shutil
import subprocess
import sys
from collections.abc import Sequence
from pathlib import Path


def repo_root() -> Path:
    return Path(__file__).resolve().parents[2]


def default_build_dir(root: Path | None = None) -> Path:
    override = os.environ.get("WAVE_BUILD_DIR")
    if override:
        return Path(override)
    root = repo_root() if root is None else root
    candidates = (root / "build", root / "build" / "wave-build")
    return next(
        (path for path in candidates if (path / "bin" / "wave-opt").is_file()),
        candidates[0],
    )


def resolve_wave_tool(name: str, build_dir: Path | None = None) -> Path:
    build_dir = default_build_dir() if build_dir is None else build_dir
    candidate = build_dir / "bin" / name
    if candidate.is_file():
        return candidate
    path = shutil.which(name)
    return Path(path) if path else candidate


def llvm_install_dir(build_dir: Path | None = None) -> Path:
    override = os.environ.get("WAVE_LLVM_TOOLS_DIR")
    if override:
        return Path(override).parent
    build_dir = default_build_dir() if build_dir is None else build_dir
    candidates = (build_dir / "llvm-install", build_dir.parent / "llvm-install")
    return next((path for path in candidates if (path / "bin").is_dir()), candidates[0])


def resolve_llvm_tool(name: str, build_dir: Path | None = None) -> Path:
    candidate = llvm_install_dir(build_dir) / "bin" / name
    if candidate.is_file():
        return candidate
    path = shutil.which(name)
    return Path(path) if path else candidate


def ensure_package_on_path(module_name: str) -> None:
    try:
        importlib.import_module(module_name)
        return
    except ImportError:
        pass
    path = default_build_dir() / "python_packages" / "wave_mlir"
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


def default_shared_libs(
    root: Path | None = None, *, build_dir: Path | None = None
) -> list[Path]:
    root = repo_root() if root is None else root
    build_dir = default_build_dir(root) if build_dir is None else build_dir
    llvm_lib_dir = llvm_install_dir(build_dir) / "lib"
    return [
        llvm_lib_dir / "libmlir_rocm_runtime.so",
        llvm_lib_dir / "libmlir_runner_utils.so",
        build_dir / "lib" / "libwave_runtime.so",
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


def _dedent_op(text: str) -> str:
    lines = text.splitlines()
    nonempty = [line for line in lines if line.strip()]
    if not nonempty:
        return text
    indent = min(len(line) - len(line.lstrip()) for line in nonempty)
    if indent == 0:
        return text
    prefix = " " * indent
    return "\n".join(line.removeprefix(prefix) for line in lines)


def _extract_pretty_func(module_text: str, kernel_name: str) -> str | None:
    lines = module_text.splitlines()
    pattern = re.compile(rf"^\s*func\.func @{re.escape(kernel_name)}(?:\W|$)")
    for start, line in enumerate(lines):
        if not pattern.search(line):
            continue
        depth = 0
        for end in range(start, len(lines)):
            depth += lines[end].count("{") - lines[end].count("}")
            if end > start and depth == 0:
                return _dedent_op("\n".join(lines[start : end + 1]))
    return None


def extract_kernel_op(
    module_text: str, *, kernel_regex: str, kernel_name: str | None = None
) -> str | None:
    if kernel_name is not None:
        pretty = _extract_pretty_func(module_text, kernel_name)
        if pretty is not None:
            return pretty
    match = re.search(kernel_regex, module_text, re.S)
    if match:
        return _dedent_op(match.group(1))
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
    wave_translate = wave_translate or resolve_wave_tool("wave-translate")
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
    build_dir = wave_opt.parent.parent if wave_opt else default_build_dir(root)
    wave_opt = wave_opt or resolve_wave_tool("wave-opt", build_dir)
    mlir_runner = mlir_runner or resolve_llvm_tool("mlir-runner", build_dir)
    pipeline_lib = (
        build_dir / "share" / "wave-mlir" / "pipelines" / "pipelines.mlir"
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
    for lib in shared_libs or default_shared_libs(root, build_dir=build_dir):
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
