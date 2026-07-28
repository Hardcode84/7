#!/usr/bin/env python3
#  Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
#  See https://llvm.org/LICENSE.txt for license information.
#  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

"""Build, check, and benchmark the Wave DSL gfx950 FlashAttention kernel."""

from __future__ import annotations

import argparse
import math
import os
import re
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path
from statistics import median

ROOT = Path(__file__).resolve().parents[2]
EXAMPLES = ROOT / "examples/wave"
RUNNER = Path(__file__).with_name("wave-fa-gfx950-runner.cpp")
KERNEL = "flash_attention_bf16_gfx950"
sys.path.insert(0, str(EXAMPLES))

from common import (  # noqa: E402
    default_build_dir,
    extract_kernel_op,
    resolve_llvm_tool,
    resolve_wave_tool,
)


def _run(
    command: list[str],
    *,
    input_text: str | None = None,
    env: dict[str, str] | None = None,
) -> str:
    process = subprocess.run(
        command,
        input=input_text,
        text=True,
        capture_output=True,
        env=env,
        check=False,
    )
    if process.stderr:
        sys.stderr.write(process.stderr)
    if process.returncode:
        if process.stdout:
            sys.stdout.write(process.stdout)
        raise SystemExit(process.returncode)
    return process.stdout


def _validate_positive_args(
    parser: argparse.ArgumentParser, args: argparse.Namespace
) -> None:
    for name in ("batch", "heads", "sequence", "iters", "repeats", "input_scale"):
        if getattr(args, name) <= 0:
            parser.error(f"--{name} must be positive")
    if args.warmup < 0:
        parser.error("--warmup must be non-negative")
    if args.device is not None and args.device < 0:
        parser.error("--device must be non-negative")


def _validate_qk_args(
    parser: argparse.ArgumentParser, args: argparse.Namespace
) -> None:
    if args.qk_max_abs is None:
        return
    if not math.isfinite(args.qk_max_abs) or args.qk_max_abs <= 0:
        parser.error("--qk-max-abs must be finite and positive")
    if args.qk_max_abs < args.input_scale:
        parser.error("--qk-max-abs must cover the generated input range")


def _validate_output_args(
    parser: argparse.ArgumentParser, args: argparse.Namespace
) -> None:
    if args.run_hsaco is not None and any(
        output is not None
        for output in (args.mlir_out, args.generated_out, args.emit_hsaco)
    ):
        parser.error("--run-hsaco cannot be combined with generation outputs")
    if args.runner is not None and args.run_hsaco is None:
        parser.error("--runner requires --run-hsaco")
    if args.generated_out is not None and args.emit_hsaco is not None:
        parser.error("--generated-out and --emit-hsaco are mutually exclusive")


def _parse_args(argv: list[str]) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--build-dir", type=Path, default=default_build_dir(ROOT))
    parser.add_argument("--batch", type=int, default=2)
    parser.add_argument("--heads", type=int, default=64)
    parser.add_argument("--sequence", type=int, default=8192)
    parser.add_argument("--xcds", type=int, default=8)
    parser.add_argument("--waves", type=int, choices=(4, 8), default=8)
    parser.add_argument(
        "--qk-max-abs",
        type=float,
        help="use fixed softmax reference for |Q|,|K| <= VALUE",
    )
    parser.add_argument("--seed", type=int, default=17)
    parser.add_argument("--input-scale", type=int, default=1)
    parser.add_argument("--iters", type=int, default=20)
    parser.add_argument("--warmup", type=int, default=5)
    parser.add_argument("--repeats", type=int, default=1)
    parser.add_argument("--check", action="store_true")
    parser.add_argument("--zero-qk", action="store_true")
    parser.add_argument("--skip-rebuild", action="store_true")
    parser.add_argument("--hipcc", default="hipcc")
    parser.add_argument(
        "--rocm-lib",
        type=Path,
        default=Path(os.environ.get("ROCM_LIB", "/opt/rocm/lib")),
    )
    parser.add_argument("--device", type=int)
    parser.add_argument("--mlir-out", type=Path, default=None)
    parser.add_argument("--generated-out", type=Path, default=None)
    parser.add_argument("--emit-hsaco", type=Path, default=None)
    parser.add_argument("--run-hsaco", type=Path, default=None)
    parser.add_argument("--runner", type=Path, default=None)
    args = parser.parse_args(argv)
    _validate_positive_args(parser, args)
    _validate_qk_args(parser, args)
    _validate_output_args(parser, args)
    return args


def _rebuild(args: argparse.Namespace) -> None:
    if args.skip_rebuild:
        return
    _run(
        [
            "cmake",
            "--build",
            str(args.build_dir),
            "--target",
            "wave-opt",
            "wave-translate",
            "WavePythonModules",
            "-j",
            str(os.cpu_count() or 1),
        ]
    )


def _import_builder(build_dir: Path):
    sys.path.insert(0, str(build_dir / "python_packages/wave_mlir"))
    from mlir.dialects.wave_flash_attention import (
        build_gfx950_flash_attention_module,
    )

    return build_gfx950_flash_attention_module


def _dynamic_lds_bytes(args: argparse.Namespace) -> int:
    sys.path.insert(0, str(args.build_dir / "python_packages/wave_mlir"))
    from mlir.dialects.wave_flash_attention import Gfx950FlashAttentionConfig

    return Gfx950FlashAttentionConfig(
        batch=args.batch,
        heads=args.heads,
        sequence=args.sequence,
        xcds=args.xcds,
        waves=args.waves,
        qk_max_abs=args.qk_max_abs,
    ).dynamic_lds_bytes


def _source(args: argparse.Namespace) -> str:
    build = _import_builder(args.build_dir)
    try:
        module = build(
            batch=args.batch,
            heads=args.heads,
            sequence=args.sequence,
            xcds=args.xcds,
            waves=args.waves,
            qk_max_abs=args.qk_max_abs,
        )
    except ValueError as error:
        raise SystemExit(str(error)) from error
    kernel = extract_kernel_op(
        str(module),
        kernel_regex=rf"(func\.func @{KERNEL}.*?\n    \}})",
        kernel_name=KERNEL,
    )
    if kernel is None:
        sys.exit(f"could not isolate {KERNEL}")
    return (
        "module attributes {waveamdmachine.target = "
        '"amdgcn-amd-amdhsa--gfx950"} {\n'
        f"{kernel}\n}}\n"
    )


def _require_tool(path: Path) -> Path:
    if not path.exists():
        sys.exit(f"missing tool: {path}")
    return path


def _assembly(args: argparse.Namespace, source: str) -> str:
    return _run(
        [
            str(_require_tool(resolve_wave_tool("wave-translate", args.build_dir))),
            "--wave-to-amdgpu-asm",
            "-",
        ],
        input_text=source,
    )


def _hsaco(
    args: argparse.Namespace, assembly: str, tmp: Path, output: Path | None = None
) -> Path:
    asm = tmp / "flash_attention.s"
    obj = tmp / "flash_attention.o"
    hsaco = output or tmp / "flash_attention.hsaco"
    hsaco.parent.mkdir(parents=True, exist_ok=True)
    asm.write_text(assembly)
    _run(
        [
            str(_require_tool(resolve_llvm_tool("llvm-mc", args.build_dir))),
            "-triple=amdgcn-amd-amdhsa",
            "-mcpu=gfx950",
            "-filetype=obj",
            "-o",
            str(obj),
            str(asm),
        ]
    )
    _run(
        [
            str(_require_tool(resolve_llvm_tool("ld.lld", args.build_dir))),
            "-shared",
            str(obj),
            "-o",
            str(hsaco),
        ]
    )
    return hsaco


def _runner(args: argparse.Namespace, tmp: Path) -> Path:
    hipcc = shutil.which(args.hipcc) or args.hipcc
    output = tmp / "wave-fa-gfx950-runner"
    _run([str(hipcc), "-O2", "-std=c++20", str(RUNNER), "-o", str(output)])
    return output


def _run_hardware(
    args: argparse.Namespace, runner: Path, hsaco: Path
) -> tuple[float, float]:
    command = [
        str(runner),
        "--batch",
        str(args.batch),
        "--heads",
        str(args.heads),
        "--sequence",
        str(args.sequence),
        "--threads",
        str(args.waves * 64),
        "--dynamic-lds",
        str(_dynamic_lds_bytes(args)),
        "--seed",
        str(args.seed),
        "--input-scale",
        str(args.input_scale),
        "--iters",
        str(args.iters),
        "--warmup",
        str(args.warmup),
    ]
    if args.check:
        command.append("--check")
    if args.zero_qk:
        command.append("--zero-qk")
    command.extend([str(hsaco), KERNEL])
    env = os.environ.copy()
    existing_ld = env.get("LD_LIBRARY_PATH", "")
    env["LD_LIBRARY_PATH"] = str(args.rocm_lib) + (
        os.pathsep + existing_ld if existing_ld else ""
    )
    if args.device is not None:
        env["ROCR_VISIBLE_DEVICES"] = str(args.device)
    output = _run(command, env=env)
    sys.stdout.write(output)
    time_match = re.search(r"^per_launch_us: ([0-9.]+)$", output, re.M)
    perf_match = re.search(r"^tflops: ([0-9.]+)$", output, re.M)
    if not time_match or not perf_match:
        sys.exit("runner output missing timing")
    return float(time_match.group(1)), float(perf_match.group(1))


def _benchmark(args: argparse.Namespace, runner: Path, hsaco: Path) -> None:
    samples = [_run_hardware(args, runner, hsaco) for _ in range(args.repeats)]
    times = [sample[0] for sample in samples]
    rates = [sample[1] for sample in samples]
    print(f"median_per_launch_us: {median(times):.3f}")
    print(f"median_tflops: {median(rates):.3f}")


def main(argv: list[str] | None = None) -> int:
    args = _parse_args(sys.argv[1:] if argv is None else argv)
    _rebuild(args)
    if args.run_hsaco is not None:
        if args.runner is not None:
            _benchmark(args, args.runner, args.run_hsaco)
            return 0
        with tempfile.TemporaryDirectory(prefix="wave-fa-gfx950-") as path:
            _benchmark(args, _runner(args, Path(path)), args.run_hsaco)
        return 0

    source = _source(args)
    if args.mlir_out is not None:
        args.mlir_out.parent.mkdir(parents=True, exist_ok=True)
        args.mlir_out.write_text(source)
        print(f"generated: {args.mlir_out}")
        if args.generated_out is None and args.emit_hsaco is None:
            return 0

    assembly = _assembly(args, source)
    if args.generated_out is not None:
        args.generated_out.parent.mkdir(parents=True, exist_ok=True)
        args.generated_out.write_text(assembly)
        print(f"generated: {args.generated_out}")
        return 0
    if args.emit_hsaco is not None:
        with tempfile.TemporaryDirectory(prefix="wave-fa-gfx950-") as path:
            _hsaco(args, assembly, Path(path), args.emit_hsaco)
        print(f"generated: {args.emit_hsaco}")
        return 0

    with tempfile.TemporaryDirectory(prefix="wave-fa-gfx950-") as path:
        tmp = Path(path)
        hsaco = _hsaco(args, assembly, tmp)
        runner = _runner(args, tmp)
        _benchmark(args, runner, hsaco)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
