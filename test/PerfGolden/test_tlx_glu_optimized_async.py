# REQUIRES: wave-python-bindings
#
# RUN: %PYTHON %s --build-dir %wave_obj_root --generated-out %t.s | FileCheck %s

# CHECK: perf-golden: tlx_glu_optimized_async: asm matches golden

from __future__ import annotations

import sys
from pathlib import Path

NAME = "tlx_glu_optimized_async"
HERE = Path(__file__).resolve().parent
REPO_ROOT = HERE.parents[1]
sys.path.insert(0, str(HERE / "Inputs"))

import perf_golden_mlir  # noqa: E402

_SOURCE = HERE / "Inputs" / f"{NAME}.mlir"
GOLDEN = HERE / "Inputs" / f"{NAME}.s"
normalize_asm = perf_golden_mlir.normalize_asm


def test_tlx_glu_optimized_async() -> None:
    perf_golden_mlir.check_asm(NAME, _SOURCE, GOLDEN, REPO_ROOT / "build")


def main(argv: list[str]) -> int:
    return perf_golden_mlir.main(NAME, _SOURCE, GOLDEN, REPO_ROOT / "build", argv)


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
