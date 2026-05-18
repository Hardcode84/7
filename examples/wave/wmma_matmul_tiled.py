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
rationale): ``M = 16``, ``N`` and ``K`` are power-of-two multiples of
16, ``BM = BN = 1``.
"""

from __future__ import annotations

import argparse
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


def _parse_args(argv: list[str]) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__.split("\n\n", 1)[0])
    parser.add_argument(
        "--m", type=int, default=16, help="output rows (only 16 supported for now)"
    )
    parser.add_argument(
        "--n",
        type=int,
        default=64,
        help="output cols (power-of-two multiple of 16)",
    )
    parser.add_argument(
        "--k",
        type=int,
        default=32,
        help="contraction dim (power-of-two multiple of 16)",
    )
    parser.add_argument(
        "--bm",
        type=int,
        default=1,
        help="waves per workgroup along M tiles (only 1 supported for now)",
    )
    parser.add_argument(
        "--bn",
        type=int,
        default=1,
        help="waves per workgroup along N tiles (only 1 supported for now)",
    )
    parser.add_argument(
        "--use-buffer",
        action="store_true",
        help="wrap the A and B kernel inputs in waveamd.make_buffer so "
        "every per-K-step fragment load uses tuple buffer_load_b32 "
        "(buffer_load_dword ..., 0 offen offset:i*4) before the LDS "
        "round-trip",
    )
    parser.add_argument(
        "--chip",
        default="",
        help="AMDGPU chip used for auto intrinsic selection; gfx9/gfx950 use MFMA",
    )
    parser.add_argument(
        "--matrix-intrinsic",
        choices=("auto", "wmma", "mfma"),
        default="auto",
        help="matrix instruction family to emit; auto picks MFMA for gfx9/gfx950",
    )
    return parser.parse_args(argv)


def _select_matrix_intrinsic(chip: str, requested: str) -> str:
    if requested != "auto":
        return requested
    return "mfma" if chip.startswith("gfx9") else "wmma"


def main(argv: list[str] | None = None) -> int:
    args = _parse_args(sys.argv[1:] if argv is None else argv)
    _ensure_package_on_path()
    from mlir.dialects.wave_matmul import build_wmma_f16_matmul_module

    module = build_wmma_f16_matmul_module(
        M=args.m,
        N=args.n,
        K=args.k,
        BM=args.bm,
        BN=args.bn,
        use_buffer=args.use_buffer,
        matrix_intrinsic=_select_matrix_intrinsic(args.chip, args.matrix_intrinsic),
    )
    sys.stdout.write(str(module))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
