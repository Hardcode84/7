# REQUIRES: wave-python-bindings
#
# RUN: %PYTHON %s --build-dir %wave_obj_root --generated-out %t.s | FileCheck %s
# RUN: %PYTHON %s --build-dir %wave_obj_root --emit-mlir %t.mlir
# RUN: FileCheck %s --check-prefix=SOURCE --input-file=%t.mlir

# CHECK: perf-golden: gfx950-fa-b2-h64-n8192-d128-bf16-8wave: asm matches golden
# SOURCE: module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"}
# SOURCE-NOT: wave.fadd {{.*}} fastmath<reassoc>
# SOURCE-NOT: wave.ballot

from __future__ import annotations

import subprocess
import sys
from pathlib import Path

NAME = "gfx950-fa-b2-h64-n8192-d128-bf16-8wave"
HERE = Path(__file__).resolve().parent
REPO_ROOT = HERE.parents[1]
sys.path.insert(0, str(HERE / "Inputs"))

import perf_golden_mlir  # noqa: E402

CALIBRATOR = REPO_ROOT / "tools/wave-fa-calibrate/wave-fa-gfx950.py"
GOLDEN = HERE / "Inputs" / f"{NAME}.s"


normalize_asm = perf_golden_mlir.normalize_asm


def run_calibrator(
    build_dir: Path, generated_out: Path | None, emit_mlir: Path | None
) -> None:
    cmd = [
        sys.executable,
        str(CALIBRATOR),
        f"--build-dir={build_dir}",
        "--batch=2",
        "--heads=64",
        "--sequence=8192",
        "--xcds=8",
        "--waves=8",
        "--qk-max-abs=1",
        "--skip-rebuild",
    ]
    if generated_out is not None:
        cmd.append(f"--generated-out={generated_out}")
    if emit_mlir is not None:
        cmd.append(f"--mlir-out={emit_mlir}")
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


def test_gfx950_fa_b2_h64_n8192_d128_bf16_8wave() -> None:
    check_asm(REPO_ROOT / "build")


def main(argv: list[str]) -> int:
    return perf_golden_mlir.generated_main(
        REPO_ROOT / "build", argv, run_calibrator, check_asm
    )


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
