# REQUIRES: wave-python-bindings
#
# RUN: %PYTHON %s --build-dir %wave_obj_root --generated-out %t.s | FileCheck %s
# RUN: %PYTHON %s --build-dir %t.no-build --emit-mlir %t.mlir
# RUN: FileCheck %s --check-prefix=SOURCE --input-file=%t.mlir

# CHECK: perf-golden: gfx950-f16-256x256-4wave: asm matches golden
# SOURCE: module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"}

from __future__ import annotations

import subprocess
import sys
from pathlib import Path

NAME = "gfx950-f16-256x256-4wave"
HERE = Path(__file__).resolve().parent
REPO_ROOT = HERE.parents[1]
sys.path.insert(0, str(HERE / "Inputs"))

import perf_golden_mlir  # noqa: E402

CALIBRATOR = REPO_ROOT / "tools/wave-matmul-calibrate/wave-matmul-calibrate.py"
GOLDEN = HERE / "Inputs" / f"{NAME}.s"
normalize_asm = perf_golden_mlir.normalize_asm


def run_calibrator(
    build_dir: Path, generated_out: Path | None, emit_mlir: Path | None
) -> None:
    cmd = [
        sys.executable,
        str(CALIBRATOR),
        "--chip=gfx950",
        f"--build-dir={build_dir}",
        f"--kernel-profile={NAME}",
        "--m=8192",
        "--n=8192",
        "--k=8192",
        "--variants=scheduled",
        "--skip-hw",
    ]
    if generated_out is not None:
        cmd.append(f"--emit-asm={generated_out}")
    if emit_mlir is not None:
        cmd.append(f"--emit-mlir={emit_mlir}")
    proc = subprocess.run(cmd, capture_output=True, text=True, check=False)
    if proc.returncode == 0:
        if generated_out is not None and not generated_out.exists():
            raise SystemExit(f"calibrator did not write {generated_out}")
        if emit_mlir is not None and not emit_mlir.exists():
            raise SystemExit(f"calibrator did not write {emit_mlir}")
        return
    if proc.stdout:
        sys.stdout.write(proc.stdout)
    if proc.stderr:
        sys.stderr.write(proc.stderr)
    raise SystemExit(proc.returncode)


def check_asm(
    build_dir: Path,
    generated_out: Path | None = None,
    emit_mlir: Path | None = None,
    max_diff_lines: int = 200,
) -> None:
    perf_golden_mlir.check_generated_asm(
        NAME,
        GOLDEN,
        run_calibrator,
        build_dir,
        generated_out,
        emit_mlir,
        max_diff_lines,
    )


def test_gfx950_f16_256x256_4wave() -> None:
    check_asm(REPO_ROOT / "build")


def main(argv: list[str]) -> int:
    return perf_golden_mlir.generated_main(
        REPO_ROOT / "build", argv, run_calibrator, check_asm
    )


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
