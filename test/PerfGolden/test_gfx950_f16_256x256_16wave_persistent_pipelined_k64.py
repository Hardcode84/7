# REQUIRES: wave-python-bindings
#
# RUN: %PYTHON %s --build-dir %wave_obj_root --generated-out %t.s | FileCheck %s
# RUN: %PYTHON %s --build-dir %t.no-build --emit-mlir %t.mlir
# RUN: FileCheck %s --check-prefix=SOURCE --input-file=%t.mlir

# CHECK: perf-golden: {{.*}}persistent-pipelined-k64: asm matches golden
# SOURCE: module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"}

from __future__ import annotations

import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE / "Inputs"))

from persistent_gemm_perf_golden import REPO_ROOT, check_asm, run_main  # noqa: E402

NAME = "gfx950-f16-256x256-16wave-persistent-pipelined-k64"
GOLDEN = REPO_ROOT / "test/PerfGolden/Inputs" / f"{NAME}.s"


def test_gfx950_f16_256x256_16wave_persistent_pipelined_k64() -> None:
    check_asm(NAME, REPO_ROOT / "build")


if __name__ == "__main__":
    raise SystemExit(run_main(NAME, sys.argv[1:]))
