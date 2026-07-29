#!/usr/bin/env python3
#  Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
#  See https://llvm.org/LICENSE.txt for license information.
#  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

"""Emit a tiled Wave matmul MLIR module for a given shape.

The kernel allocates host-side ``MxK`` (A) and ``NxK`` (B) input buffers
filled with 1.0 and an ``MxN`` output, then issues ``wave.load`` +
``waveamd.fragment_pack`` per K-tile, accumulates with ``waveamd.mma``,
and stores the accumulator. With the all-ones fill the host can
check the result element-wise against ``K`` (each output element is
:math:`\\sum_{k=0}^{K-1} 1.0 \\cdot 1.0 = K`).

Pipe the output through the Wave transform pipeline and the standard
host-lowering passes followed by ``mlir-runner``.

Example:

    PIPELINES=build/share/wave-mlir/pipelines/pipelines.mlir
    PASS_PIPELINE="builtin.module(\\
    wave-set-target-attr{chip=gfx950},\\
    transform-preload-library{transform-library-paths=${PIPELINES}},\\
    transform-interpreter{entry-point=compile_kernels},\\
    convert-scf-to-cf,\\
    gpu-to-llvm{use-bare-pointers-for-kernels=true},\\
    convert-to-llvm,\\
    reconcile-unrealized-casts)"
    wmma_matmul_tiled.py --chip=gfx950 --m=16 --n=64 --k=32 \\
        | wave-opt --pass-pipeline="${PASS_PIPELINE}" \\
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
from typing import TYPE_CHECKING

from common import (
    add_execution_args,
    dump_kernel_asm,
    ensure_package_on_path,
    parse_runner_values,
    run_module,
)

if TYPE_CHECKING:
    from mlir.dialects.wave_matmul import PhasedDmaSchedule

_ProfileValue = bool | int | str
_PHASED_DMA_PROFILE = "gfx950-f16-256x256-8wave"
_SPATIAL_DMA_PROFILE = "gfx950-f16-256x256-8wave-spatial"
_FOUR_WAVE_PHASED_DMA_PROFILE = "gfx950-f16-256x256-4wave"
_PHASED_DMA_SCHEDULE_ARGS: dict[str, dict[str, int | bool]] = {
    _PHASED_DMA_PROFILE: {
        "issue_group_size": 7,
        "initial_delay_cycles": 68,
        "loop_delay_cycles": 46,
        "loop_overlap_cycles": 33,
        "delayed_waves": 4,
        "fetch_alignment": 32,
        "fetch_phase": 16,
    },
    _SPATIAL_DMA_PROFILE: {
        "issue_group_size": 7,
        "initial_delay_cycles": 0,
        "loop_delay_cycles": 0,
        "loop_overlap_cycles": 0,
        "delayed_waves": 0,
        "fetch_alignment": 32,
        "fetch_phase": 12,
        "spatial_subpanel_pipeline": True,
    },
    _FOUR_WAVE_PHASED_DMA_PROFILE: {
        "issue_group_size": 7,
        "initial_delay_cycles": 0,
        "loop_delay_cycles": 0,
        "loop_overlap_cycles": 0,
        "delayed_waves": 0,
        "fetch_alignment": 32,
        "fetch_phase": 12,
        "subpanel_pipeline": True,
    },
}


def _make_phased_dma_schedule(
    constructor: type[PhasedDmaSchedule], kernel_profile: str
) -> PhasedDmaSchedule | None:
    schedule_args = _PHASED_DMA_SCHEDULE_ARGS.get(kernel_profile)
    return constructor(**schedule_args) if schedule_args else None


_GFX950_SW_PIPELINE: dict[str, _ProfileValue] = {
    "bm": 2,
    "bn": 2,
    "wave_m_tiles": 4,
    "wave_n_tiles": 4,
    "wave_k_tiles": 2,
    "use_buffer": True,
    "use_dma_lds": True,
    "matrix_intrinsic": "mfma_gfx950",
}

_GFX950_F16_256X256_16WAVE: dict[str, _ProfileValue] = {
    "bm": 4,
    "bn": 4,
    "wave_m_tiles": 4,
    "wave_n_tiles": 4,
    "wave_k_tiles": 1,
    "use_buffer": True,
    "use_dma_lds": True,
    "matrix_intrinsic": "mfma_gfx950",
    "input_type": "f16",
    "output_type": "f16",
    "cta_swizzle_xcds": 8,
    "cta_group_m": 4,
}

_GFX950_F16_256X256_8WAVE: dict[str, _ProfileValue] = {
    "bm": 2,
    "bn": 4,
    "wave_m_tiles": 8,
    "wave_n_tiles": 4,
    "wave_k_tiles": 2,
    "target_waves": 2,
    "use_buffer": True,
    "use_dma_lds": True,
    "matrix_intrinsic": "mfma_gfx950",
    "input_type": "f16",
    "output_type": "f16",
    "cta_swizzle_xcds": 8,
    "cta_group_m": 4,
}

_GFX950_F16_256X256_4WAVE: dict[str, _ProfileValue] = {
    "bm": 2,
    "bn": 2,
    "wave_m_tiles": 8,
    "wave_n_tiles": 8,
    "wave_k_tiles": 2,
    "target_waves": 1,
    "use_buffer": True,
    "use_dma_lds": True,
    "matrix_intrinsic": "mfma_gfx950",
    "input_type": "f16",
    "output_type": "f16",
    "output_store_cache": "cs",
    "cta_swizzle_xcds": 8,
    "cta_group_m": 4,
    "coalesced_mfma_output": True,
}

_GFX950_MXFP4_256X256_8WAVE: dict[str, _ProfileValue] = {
    "bm": 4,
    "bn": 2,
    "wave_m_tiles": 4,
    "wave_n_tiles": 8,
    "wave_k_tiles": 2,
    "use_buffer": True,
    "use_dma_lds": True,
    "matrix_intrinsic": "mfma_gfx950",
    "input_type": "mxfp4",
    "output_type": "f16",
    "cta_swizzle_xcds": 8,
    "cta_group_m": 4,
}

_GFX950_MXFP4_256X256_4WAVE: dict[str, _ProfileValue] = {
    "bm": 2,
    "bn": 2,
    "wave_m_tiles": 8,
    "wave_n_tiles": 8,
    "wave_k_tiles": 2,
    "target_waves": 1,
    "use_buffer": True,
    "use_dma_lds": True,
    "matrix_intrinsic": "mfma_gfx950",
    "input_type": "mxfp4",
    "output_type": "f16",
    "mxfp4_scale_path": "regs",
    "cta_swizzle_xcds": 8,
    "cta_group_m": 4,
}

_KERNEL_PROFILES: dict[str, dict[str, _ProfileValue]] = {
    "gfx950-sw-pipeline": _GFX950_SW_PIPELINE,
    "gfx950-f16-256x256-16wave": _GFX950_F16_256X256_16WAVE,
    "gfx950-f16-256x256-8wave": _GFX950_F16_256X256_8WAVE,
    _SPATIAL_DMA_PROFILE: _GFX950_F16_256X256_8WAVE,
    "gfx950-f16-256x256-4wave": _GFX950_F16_256X256_4WAVE,
    "gfx950-mxfp4-256x256-8wave": _GFX950_MXFP4_256X256_8WAVE,
    "gfx950-mxfp4-256x256-4wave": _GFX950_MXFP4_256X256_4WAVE,
}

_DEFAULT_ATOL = 1.0e-3
_DEFAULT_RTOL = 1.0e-3


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
    ensure_package_on_path("mlir.dialects.wave_target")
    from mlir.dialects.wave_target import MATRIX_INTRINSIC_CHOICES

    parser.add_argument(
        "--kernel-profile",
        choices=("manual", *_KERNEL_PROFILES),
        default="manual",
        help="preload a high-level kernel shape; manual leaves tile args unchanged",
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
        "--use-dma-lds",
        action="store_true",
        help="stage gfx950 MFMA A fragments through waveamd.dma_load_lds",
    )
    parser.add_argument(
        "--matrix-intrinsic",
        choices=MATRIX_INTRINSIC_CHOICES,
        default="auto",
        help="matrix instruction family to emit; auto uses the exact target profile",
    )
    parser.add_argument(
        "--target-waves",
        type=int,
        default=0,
        help="stamp waveamdmachine.target_waves on the kernel; 0 omits it",
    )
    parser.add_argument(
        "--enable-split-barriers",
        action="store_true",
        help="stamp waveamdmachine.enable_split_barriers on the kernel",
    )
    parser.add_argument(
        "--multi-wave-specialize",
        action="store_true",
        help=("stamp waveamdmachine.enable_multi_wave_specialization on the kernel"),
    )
    parser.add_argument(
        "--coalesced-mfma-output",
        action="store_true",
        help="transpose gfx950 MFMA accumulation for direct column-major stores",
    )
    parser.add_argument(
        "--cta-swizzle-xcds",
        type=int,
        default=1,
        help="remap CTAs across this many XCDs; 1 disables XCD remap",
    )
    parser.add_argument(
        "--cta-group-m",
        type=int,
        default=1,
        help="Gluon-style M grouping after linear CTA remap; 1 disables grouping",
    )
    parser.add_argument(
        "--input-type",
        choices=("f16", "bf16", "mxfp4"),
        default="f16",
        help="input element type for A and B",
    )
    parser.add_argument(
        "--output-type",
        choices=("f32", "f16"),
        default="f32",
        help="output element type for C",
    )
    parser.add_argument(
        "--output-store-cache",
        choices=("none", "wb", "cg", "cs", "wt"),
        default="none",
        help="cache policy for output stores",
    )
    parser.add_argument(
        "--mxfp4-scale-path",
        choices=("dma", "regs"),
        default="dma",
        help="MXFP4 scale staging path when A/B use LDS DMA",
    )
    parser.add_argument(
        "--kernel-only",
        action="store_true",
        help="emit only the GPU kernel module, skipping host setup",
    )


def _add_runner_args(parser: argparse.ArgumentParser) -> None:
    parser.add_argument(
        "--random-data",
        action="store_true",
        help="fill A/B with deterministic pseudo-random input values",
    )
    add_execution_args(parser, default_atol=_DEFAULT_ATOL, default_rtol=_DEFAULT_RTOL)


def _parse_args(argv: list[str]) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__.split("\n\n", 1)[0])
    _add_shape_args(parser)
    _add_tile_args(parser)
    _add_codegen_args(parser)
    _add_runner_args(parser)
    parser.set_defaults(**_profile_defaults(argv))
    args = parser.parse_args(argv)
    if args.target_waves < 0:
        parser.error("--target-waves must be non-negative")
    if args.mxfp4_scale_path != "dma" and args.input_type != "mxfp4":
        parser.error("--mxfp4-scale-path=regs requires --input-type=mxfp4")
    if args.kernel_only and (args.run or args.compare_cpu):
        parser.error("--kernel-only cannot be used with --run/--compare-cpu")
    try:
        args.matrix_intrinsic = _select_matrix_intrinsic(
            args.chip, args.matrix_intrinsic
        )
    except ValueError as exc:
        parser.error(str(exc))
    return args


def _profile_defaults(argv: list[str]) -> dict[str, bool | int | str]:
    parser = argparse.ArgumentParser(add_help=False, allow_abbrev=False)
    parser.add_argument(
        "--kernel-profile",
        choices=("manual", *_KERNEL_PROFILES),
        default="manual",
    )
    args, _ = parser.parse_known_args(argv)
    if args.kernel_profile == "manual":
        return {}
    return _KERNEL_PROFILES[args.kernel_profile]


def _select_matrix_intrinsic(chip: str, requested: str) -> str:
    ensure_package_on_path("mlir.dialects.wave_target")
    from mlir.dialects.wave_target import select_matrix_intrinsic

    return str(select_matrix_intrinsic(chip, requested))


def _split_barriers_enabled(requested: bool, matrix_intrinsic: str) -> bool:
    ensure_package_on_path("mlir.dialects.wave_target")
    from mlir.dialects.wave_target import GFX1250_MATRIX_INTRINSIC

    return requested or matrix_intrinsic == GFX1250_MATRIX_INTRINSIC


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


def _compare_buffers(
    actual: tuple[float, ...],
    expected: tuple[float, ...],
    *,
    atol: float,
    rtol: float,
) -> tuple[bool, str]:
    if len(actual) != len(expected):
        return False, f"length mismatch: gpu={len(actual)} cpu={len(expected)}"
    worst = (0.0, 0, 0.0, 0.0)
    for index, (got, exp) in enumerate(zip(actual, expected, strict=True)):
        diff = abs(got - exp)
        if diff > worst[0]:
            worst = (diff, index, got, exp)
        if not math.isclose(got, exp, rel_tol=rtol, abs_tol=atol):
            return False, f"element {index}: gpu={got} cpu={exp} abs_diff={diff}"
    diff, index, got, exp = worst
    return True, f"elements={len(actual)} max_abs_diff={diff} at {index} ({got}, {exp})"


def _compare_output(
    actual: tuple[float, ...],
    expected: tuple[float, ...],
    *,
    coalesced_mfma_output: bool,
    atol: float,
    rtol: float,
) -> tuple[bool, str]:
    compare = _compare_buffers if coalesced_mfma_output else _compare_tile_multisets
    return compare(actual, expected, atol=atol, rtol=rtol)


def main(argv: list[str] | None = None) -> int:
    args = _parse_args(sys.argv[1:] if argv is None else argv)
    ensure_package_on_path("mlir.dialects.wave_matmul")
    from mlir.dialects.wave_matmul import (
        PhasedDmaSchedule,
        build_wmma_f16_matmul_module,
        compute_wmma_f16_matmul_reference_buffer,
    )

    random_data = args.random_data or (args.compare_cpu and args.input_type != "mxfp4")
    phased_dma_schedule = _make_phased_dma_schedule(
        PhasedDmaSchedule, args.kernel_profile
    )
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
        matrix_intrinsic=args.matrix_intrinsic,
        input_type=args.input_type,
        output_type=args.output_type,
        output_store_cache=args.output_store_cache,
        mxfp4_scale_path=args.mxfp4_scale_path,
        random_data=random_data,
        random_seed=args.seed,
        cta_swizzle_xcds=args.cta_swizzle_xcds,
        cta_group_m=args.cta_group_m,
        target_waves=args.target_waves or None,
        enable_split_barriers=_split_barriers_enabled(
            args.enable_split_barriers, args.matrix_intrinsic
        ),
        enable_multi_wave_specialization=args.multi_wave_specialize,
        phased_dma_schedule=phased_dma_schedule,
        coalesced_mfma_output=args.coalesced_mfma_output,
        include_host=not args.kernel_only,
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
        random_data=random_data,
        random_seed=args.seed,
        matrix_intrinsic=args.matrix_intrinsic,
        input_type=args.input_type,
        output_type=args.output_type,
        cta_swizzle_xcds=args.cta_swizzle_xcds,
        cta_group_m=args.cta_group_m,
        coalesced_mfma_output=args.coalesced_mfma_output,
    )
    ok, message = _compare_output(
        parse_runner_values(output),
        expected,
        coalesced_mfma_output=args.coalesced_mfma_output,
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
