#!/usr/bin/env python3
#  Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
#  See https://llvm.org/LICENSE.txt for license information.
#  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

"""Emit the gfx950 BF16 D128 FlashAttention kernel."""

from __future__ import annotations

import argparse
import sys

from common import dump_kernel_asm, ensure_package_on_path

_KERNEL_NAME = "flash_attention_bf16_gfx950"


def _parse_args(argv: list[str]) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
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
    parser.add_argument("--chip", default="gfx950")
    parser.add_argument("--dump-asm", action="store_true")
    parser.add_argument("--wave-translate", type=str, default=None)
    parser.add_argument("--print-flops", action="store_true")
    args = parser.parse_args(argv)
    if args.chip != "gfx950":
        parser.error("this kernel requires --chip=gfx950")
    return args


def main(argv: list[str] | None = None) -> int:
    args = _parse_args(sys.argv[1:] if argv is None else argv)
    ensure_package_on_path("mlir.dialects.wave_flash_attention")
    from mlir.dialects.wave_flash_attention import (
        Gfx950FlashAttentionConfig,
        build_gfx950_flash_attention_module,
    )

    try:
        cfg = Gfx950FlashAttentionConfig(
            batch=args.batch,
            heads=args.heads,
            sequence=args.sequence,
            xcds=args.xcds,
            waves=args.waves,
            qk_max_abs=args.qk_max_abs,
        )
    except ValueError as error:
        raise SystemExit(str(error)) from error
    if args.print_flops:
        print(cfg.flops)
        return 0
    module = build_gfx950_flash_attention_module(
        batch=args.batch,
        heads=args.heads,
        sequence=args.sequence,
        xcds=args.xcds,
        waves=args.waves,
        qk_max_abs=args.qk_max_abs,
    )
    module_text = str(module)
    if args.dump_asm:
        sys.stdout.write(
            dump_kernel_asm(
                module_text,
                chip=args.chip,
                wave_translate=args.wave_translate,
                kernel_regex=rf"(func\.func @{_KERNEL_NAME}.*?\n    \}})",
                kernel_name=_KERNEL_NAME,
                missing_message=f"could not isolate {_KERNEL_NAME}",
            )
        )
        return 0
    sys.stdout.write(module_text)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
