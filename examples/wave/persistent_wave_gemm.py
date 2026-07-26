#!/usr/bin/env python3
#  Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
#  See https://llvm.org/LICENSE.txt for license information.
#  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

"""Emit the gfx950 asymmetric persistent-wave f16 GEMM."""

from __future__ import annotations

import argparse
import sys

from common import ensure_package_on_path


def _parse_args(argv: list[str]) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--chip", default="gfx950")
    parser.add_argument("--m", type=int, required=True)
    parser.add_argument("--n", type=int, required=True)
    parser.add_argument("--k", type=int, required=True)
    parser.add_argument(
        "--completion",
        choices=("poll", "waitcnt"),
        default="poll",
    )
    parser.add_argument("--poll-sleep-cycles", type=int, default=1)
    return parser.parse_args(argv)


def main(argv: list[str] | None = None) -> int:
    args = _parse_args(sys.argv[1:] if argv is None else argv)
    if args.chip != "gfx950":
        raise SystemExit("persistent-wave GEMM requires --chip=gfx950")
    ensure_package_on_path("mlir.dialects.wave_persistent_gemm")
    from mlir.dialects.wave_persistent_gemm import (
        build_gfx950_persistent_f16_gemm_module,
    )

    module = build_gfx950_persistent_f16_gemm_module(
        args.m,
        args.n,
        args.k,
        poll_vmem=args.completion == "poll",
        poll_sleep_cycles=args.poll_sleep_cycles,
    )
    sys.stdout.write(str(module))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
