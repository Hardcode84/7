#!/usr/bin/env python3
#  Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
#  See https://llvm.org/LICENSE.txt for license information.
#  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

"""Emit and run the wave f32 FlashAttention kernel."""

from __future__ import annotations

import argparse
import sys

from common import (
    add_execution_args,
    compare_values,
    dump_kernel_asm,
    ensure_package_on_path,
    parse_runner_values,
    run_module,
)


def _select_matrix_intrinsic(chip: str, requested: str) -> str:
    if requested != "auto":
        return requested
    return "mfma_gfx950" if chip.startswith("gfx950") else "wmma"


def _parser_error_if(
    parser: argparse.ArgumentParser, condition: bool, message: str
) -> None:
    if condition:
        parser.error(message)


def _validate_args(parser: argparse.ArgumentParser, args: argparse.Namespace) -> None:
    _parser_error_if(
        parser, args.target_waves < 0, "--target-waves must be non-negative"
    )
    for name in ("block_m", "block_n", "head_dim"):
        _parser_error_if(
            parser,
            getattr(args, name) <= 0,
            f"--{name.replace('_', '-')} must be positive",
        )
    _parser_error_if(
        parser, args.seq_n is not None and args.seq_n <= 0, "--seq-n must be positive"
    )
    _parser_error_if(
        parser,
        bool(args.head_dim & (args.head_dim - 1)),
        "--head-dim must be a power of two",
    )
    matrix_intrinsic = _select_matrix_intrinsic(args.chip, args.matrix_intrinsic)
    _parser_error_if(
        parser,
        args.block_m != 16 or args.block_n != 16,
        "--block-m and --block-n must both be 16 for MMA attention",
    )
    _parser_error_if(
        parser,
        args.seq_n is not None and args.seq_n % args.block_n != 0,
        "--seq-n must be a multiple of --block-n",
    )
    k_tile = 32 if matrix_intrinsic == "mfma_gfx950" else 16
    _parser_error_if(
        parser,
        args.head_dim % k_tile != 0,
        f"--head-dim must be a multiple of {k_tile}",
    )


def _parse_args(argv: list[str]) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--block-m", type=int, default=16)
    parser.add_argument("--block-n", type=int, default=16)
    parser.add_argument("--head-dim", type=int, default=32)
    parser.add_argument(
        "--matrix-intrinsic",
        choices=("auto", "wmma", "mfma_gfx950"),
        default="auto",
        help="matrix instruction family to emit; auto picks gfx950 MFMA only",
    )
    parser.add_argument(
        "--seq-n",
        type=int,
        default=None,
        help="total K/V sequence length; defaults to --block-n",
    )
    parser.add_argument(
        "--target-waves",
        type=int,
        default=0,
        help="stamp waveamdmachine.target_waves on the kernel; 0 omits it",
    )
    add_execution_args(parser, default_atol=3.0e-3, default_rtol=3.0e-3)
    args = parser.parse_args(argv)
    _validate_args(parser, args)
    return args


def _dump_asm(module_text: str, args: argparse.Namespace) -> str:
    return dump_kernel_asm(
        module_text,
        chip=args.chip,
        wave_translate=args.wave_translate,
        kernel_regex=r"(func\.func @flash_attention_f32.*?\n    \})",
        missing_message="could not isolate flash_attention_f32 kernel",
    )


def main(argv: list[str] | None = None) -> int:
    args = _parse_args(sys.argv[1:] if argv is None else argv)
    ensure_package_on_path("mlir.dialects.wave_attention")
    from mlir.dialects.wave_attention import (
        build_flash_attention_f32_module,
        compute_flash_attention_f32_reference,
    )

    matrix_intrinsic = _select_matrix_intrinsic(args.chip, args.matrix_intrinsic)
    module = build_flash_attention_f32_module(
        block_m=args.block_m,
        block_n=args.block_n,
        head_dim=args.head_dim,
        random_seed=args.seed,
        seq_n=args.seq_n,
        matrix_intrinsic=matrix_intrinsic,
        target_waves=args.target_waves or None,
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

    expected = compute_flash_attention_f32_reference(
        args.block_m,
        args.block_n,
        args.head_dim,
        random_seed=args.seed,
        seq_n=args.seq_n,
    )
    ok, message = compare_values(
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
