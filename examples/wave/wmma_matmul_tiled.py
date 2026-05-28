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
import sys

from common import (
    add_execution_args,
    dump_kernel_asm,
    ensure_package_on_path,
    parse_runner_values,
    run_module,
)


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
        "--matrix-intrinsic",
        choices=("auto", "wmma", "mfma", "mfma_gfx950"),
        default="auto",
        help="matrix instruction family to emit; auto picks MFMA for gfx9/gfx950",
    )


def _add_runner_args(parser: argparse.ArgumentParser) -> None:
    parser.add_argument(
        "--random-data",
        action="store_true",
        help="fill A/B with deterministic pseudo-random f16 values",
    )
    add_execution_args(parser, default_atol=1.0e-3, default_rtol=1.0e-3)


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


def _dump_asm(module_text: str, args: argparse.Namespace) -> str:
    return dump_kernel_asm(
        module_text,
        chip=args.chip,
        wave_translate=args.wave_translate,
        kernel_regex=r"(func\.func @wmma\w+.*?\n    \})",
        missing_message="could not isolate kernel func from generated module",
    )


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
    ensure_package_on_path("mlir.dialects.wave_matmul")
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

    output = run_module(
        module_text,
        chip=args.chip,
        wave_opt=args.wave_opt,
        mlir_runner=args.mlir_runner,
        shared_libs=args.shared_lib,
    )
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
        parse_runner_values(output),
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
