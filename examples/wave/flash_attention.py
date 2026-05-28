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


def _parse_args(argv: list[str]) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--block-m", type=int, default=4)
    parser.add_argument("--block-n", type=int, default=8)
    parser.add_argument("--head-dim", type=int, default=8)
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
    if args.target_waves < 0:
        parser.error("--target-waves must be non-negative")
    for name in ("block_m", "block_n", "head_dim"):
        if getattr(args, name) <= 0:
            parser.error(f"--{name.replace('_', '-')} must be positive")
    if args.seq_n is not None and args.seq_n <= 0:
        parser.error("--seq-n must be positive")
    if args.head_dim & (args.head_dim - 1):
        parser.error("--head-dim must be a power of two")
    threads = args.block_m * args.head_dim
    if threads % 32:
        parser.error("--block-m * --head-dim must be a multiple of 32")
    if threads > 1024:
        parser.error("--block-m * --head-dim must be <= 1024")
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

    module = build_flash_attention_f32_module(
        block_m=args.block_m,
        block_n=args.block_n,
        head_dim=args.head_dim,
        random_seed=args.seed,
        seq_n=args.seq_n,
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
