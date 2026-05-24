#!/usr/bin/env python3
#  Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
#  See https://llvm.org/LICENSE.txt for license information.
#  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

"""Emit a tiled Wave f16xf16xf32 matmul MLIR module for a given shape.

The kernel allocates host-side ``MxK`` (A) and ``NxK`` (B) f16 buffers
filled with 1.0 and an ``MxN`` f32 output, then issues ``wave.load`` +
``waveamd.fragment_pack`` per K-tile, accumulates with ``waveamd.mma``,
and stores the f32 accumulator. With the all-ones fill the host can
check the result element-wise against ``K`` (each output element is
:math:`\\sum_{k=0}^{K-1} 1.0 \\cdot 1.0 = K`).

Pipe the output through ``wave-opt --wave-compile-kernels='chip=<gfx>'`` and
the standard host-lowering passes followed by ``mlir-runner``.

Example:

    wmma_matmul_tiled.py --chip=gfx950 --m=16 --n=64 --k=32 \\
        | wave-opt --wave-compile-kernels='chip=gfx950' \\
            --convert-scf-to-cf \\
            --gpu-to-llvm=use-bare-pointers-for-kernels=true \\
            --convert-to-llvm \\
            --reconcile-unrealized-casts \\
        | mlir-runner --shared-libs=...

Shape constraints (see :mod:`mlir.dialects.wave_matmul` for the
rationale): ``M``, ``N`` and ``K`` are positive multiples of 16;
``BM * wave_m_tiles`` divides ``M/16``; ``BN * wave_n_tiles`` divides
``N/16``; ``wave_k_tiles`` divides ``K/16``; ``BN`` is a power of two;
and ``BM * BN <= 32``.
"""

from __future__ import annotations

import argparse
import math
import re
import subprocess
import sys
from pathlib import Path


def _ensure_package_on_path() -> None:
    """Allow running the script directly from a source checkout.

    When invoked as ``python examples/wave/wmma_matmul_tiled.py`` the
    built ``python_packages/wave_mlir`` tree must be importable so that
    ``mlir.dialects.wave_matmul`` resolves alongside the upstream
    bindings and our nanobind extension. We only prepend it if the
    module is not already importable, so installed setups remain
    untouched.
    """
    try:
        import mlir.dialects.wave_matmul  # noqa: F401

        return
    except ImportError:
        pass
    repo_root = Path(__file__).resolve().parents[2]
    for path in [repo_root / "build" / "python_packages" / "wave_mlir"]:
        if (path / "mlir" / "dialects").is_dir():
            sys.path.insert(0, str(path))
            return


def _add_shape_args(parser: argparse.ArgumentParser) -> None:
    parser.add_argument(
        "--m",
        type=int,
        default=16,
        help="output rows; positive multiple of 16",
    )
    parser.add_argument(
        "--n",
        type=int,
        default=64,
        help="output cols; positive multiple of 16",
    )
    parser.add_argument(
        "--k",
        type=int,
        default=32,
        help="contraction dim; positive multiple of 16",
    )


def _add_tile_args(parser: argparse.ArgumentParser) -> None:
    parser.add_argument(
        "--bm",
        "--m-waves-per-block",
        type=int,
        default=1,
        help="waves per workgroup along M tiles; must divide M/16",
    )
    parser.add_argument(
        "--bn",
        "--n-waves-per-block",
        type=int,
        default=1,
        help="waves per workgroup along N tiles; power of two dividing N/16",
    )
    parser.add_argument(
        "--wave-m-tiles",
        type=int,
        default=1,
        help="16x16 M tiles computed by each wave",
    )
    parser.add_argument(
        "--wave-n-tiles",
        type=int,
        default=1,
        help="16x16 N tiles computed by each wave",
    )
    parser.add_argument(
        "--k-tiles",
        "--wave-k-tiles",
        dest="wave_k_tiles",
        type=int,
        default=1,
        help="16-wide K slices folded by each virtual wave tile",
    )


def _add_codegen_args(parser: argparse.ArgumentParser) -> None:
    parser.add_argument(
        "--use-buffer",
        action="store_true",
        help="wrap the A and B kernel inputs in waveamd.make_buffer so "
        "every per-K-step fragment load uses tuple buffer_load_b32 "
        "(buffer_load_dword ..., 0 offen offset:i*4) before the LDS "
        "round-trip",
    )
    parser.add_argument(
        "--use-dma-lds",
        action="store_true",
        help="stage gfx950 MFMA A fragments through waveamd.dma_load_lds",
    )
    parser.add_argument(
        "--chip",
        default="",
        help="AMDGPU chip used for auto intrinsic selection; gfx9/gfx950 use MFMA",
    )
    parser.add_argument(
        "--matrix-intrinsic",
        choices=("auto", "wmma", "mfma", "mfma_gfx950"),
        default="auto",
        help="matrix instruction family to emit; auto picks MFMA for gfx9/gfx950",
    )
    parser.add_argument(
        "--dump-asm",
        action="store_true",
        help="lower the kernel through the backend pipeline and print AMDGPU "
        "asm instead of MLIR (needs --chip; pinned via wave-translate)",
    )
    parser.add_argument(
        "--wave-translate",
        type=Path,
        default=None,
        help="path to wave-translate; defaults to build/bin/wave-translate",
    )


def _add_runner_args(parser: argparse.ArgumentParser) -> None:
    parser.add_argument(
        "--random-data",
        action="store_true",
        help="fill A/B with deterministic pseudo-random f16 values",
    )
    parser.add_argument(
        "--seed",
        type=int,
        default=0,
        help="seed for --random-data",
    )
    parser.add_argument(
        "--run",
        action="store_true",
        help="run wave-opt and mlir-runner instead of only printing MLIR",
    )
    parser.add_argument(
        "--compare-cpu",
        action="store_true",
        help="run deterministic random data and compare each output tile with CPU",
    )
    parser.add_argument(
        "--wave-opt",
        type=Path,
        default=None,
        help="path to wave-opt; defaults to build/bin/wave-opt",
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
        default=1.0e-3,
        help="absolute tolerance for --compare-cpu",
    )
    parser.add_argument(
        "--rtol",
        type=float,
        default=1.0e-3,
        help="relative tolerance for --compare-cpu",
    )


def _parse_args(argv: list[str]) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__.split("\n\n", 1)[0])
    _add_shape_args(parser)
    _add_tile_args(parser)
    _add_codegen_args(parser)
    _add_runner_args(parser)
    return parser.parse_args(argv)


def _select_matrix_intrinsic(chip: str, requested: str) -> str:
    if requested != "auto":
        return requested
    if chip.startswith("gfx95"):
        return "mfma_gfx950"
    return "mfma" if chip.startswith("gfx9") else "wmma"


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
    # Hoist the kernel func into a standalone target module: wave-translate
    # lowers a target-attr module, not the gpu.container_module wrapper.
    m = re.search(r"(func\.func @wmma\w+.*?\n    \})", module_text, re.S)
    if not m:
        raise SystemExit("could not isolate kernel func from generated module")
    kernel = m.group(1).replace("\n    ", "\n  ")
    target = f"amdgcn-amd-amdhsa--{args.chip}"
    wrapped = (
        f'module attributes {{waveamdmachine.target = "{target}"}} {{\n{kernel}\n}}\n'
    )
    return _run_command(
        [str(wave_translate), "--wave-to-amdgpu-asm", "-"], input_text=wrapped
    )


def _run_module(module_text: str, args: argparse.Namespace) -> str:
    if not args.chip:
        raise SystemExit("--run needs --chip=<gfx>")
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


def _compare_tile_multisets(
    actual: tuple[float, ...],
    expected: tuple[float, ...],
    *,
    atol: float,
    rtol: float,
) -> tuple[bool, str]:
    if len(actual) != len(expected):
        return False, f"length mismatch: gpu={len(actual)} cpu={len(expected)}"
    tile_size = 256
    worst = (0.0, 0, 0, 0.0, 0.0)
    for tile in range(len(actual) // tile_size):
        base = tile * tile_size
        got_tile = sorted(actual[base : base + tile_size])
        exp_tile = sorted(expected[base : base + tile_size])
        for slot, (got, exp) in enumerate(zip(got_tile, exp_tile, strict=True)):
            diff = abs(got - exp)
            if diff > worst[0]:
                worst = (diff, tile, slot, got, exp)
            if not math.isclose(got, exp, rel_tol=rtol, abs_tol=atol):
                return (
                    False,
                    f"tile {tile} slot {slot}: gpu={got} cpu={exp} " f"abs_diff={diff}",
                )
    diff, tile, slot, got, exp = worst
    return (
        True,
        f"tiles={len(actual) // tile_size} max_abs_diff={diff} "
        f"at tile {tile} slot {slot} (gpu={got}, cpu={exp})",
    )


def main(argv: list[str] | None = None) -> int:
    args = _parse_args(sys.argv[1:] if argv is None else argv)
    _ensure_package_on_path()
    from mlir.dialects.wave_matmul import (
        build_wmma_f16_matmul_module,
        compute_wmma_f16_matmul_reference_buffer,
    )

    matrix_intrinsic = _select_matrix_intrinsic(args.chip, args.matrix_intrinsic)
    random_data = args.random_data or args.compare_cpu
    module = build_wmma_f16_matmul_module(
        M=args.m,
        N=args.n,
        K=args.k,
        BM=args.bm,
        BN=args.bn,
        wave_m_tiles=args.wave_m_tiles,
        wave_n_tiles=args.wave_n_tiles,
        wave_k_tiles=args.wave_k_tiles,
        use_buffer=args.use_buffer,
        use_dma_lds=args.use_dma_lds,
        matrix_intrinsic=matrix_intrinsic,
        random_data=random_data,
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

    expected = compute_wmma_f16_matmul_reference_buffer(
        M=args.m,
        N=args.n,
        K=args.k,
        BM=args.bm,
        BN=args.bn,
        wave_m_tiles=args.wave_m_tiles,
        wave_n_tiles=args.wave_n_tiles,
        wave_k_tiles=args.wave_k_tiles,
        random_data=True,
        random_seed=args.seed,
        matrix_intrinsic=matrix_intrinsic,
    )
    ok, message = _compare_tile_multisets(
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
