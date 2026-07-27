#!/usr/bin/env python3
#  Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
#  See https://llvm.org/LICENSE.txt for license information.
#  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

"""Emit the gfx950 four-wave f16 Stream-K GEMM kernel."""

from __future__ import annotations

import argparse
import sys

from common import ensure_package_on_path


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--chip", default="gfx950")
    parser.add_argument("--m", type=int, required=True)
    parser.add_argument("--n", type=int, required=True)
    parser.add_argument("--k", type=int, required=True)
    parser.add_argument("--workers", type=int, required=True)
    parser.add_argument("--cta-swizzle-xcds", type=int, default=8)
    parser.add_argument("--cta-group-m", type=int, default=4)
    args = parser.parse_args(sys.argv[1:] if argv is None else argv)
    if args.chip != "gfx950":
        parser.error("Stream-K kernel requires gfx950")

    ensure_package_on_path("mlir.dialects.wave_matmul")
    from mlir.dialects.wave_matmul import (
        build_gfx950_f16_streamk_matmul_module,
    )

    module = build_gfx950_f16_streamk_matmul_module(
        args.m,
        args.n,
        args.k,
        workers=args.workers,
        cta_swizzle_xcds=args.cta_swizzle_xcds,
        cta_group_m=args.cta_group_m,
    )
    sys.stdout.write(str(module))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
