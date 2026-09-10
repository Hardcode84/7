# REQUIRES: wave-python-bindings
#
# RUN: %PYTHON %s --build-dir %wave_obj_root --generated-out %t.s | FileCheck %s
# RUN: %PYTHON %s --build-dir %t.no-build --emit-mlir %t.mlir
# RUN: FileCheck %s --check-prefix=SOURCE --input-file=%t.mlir
# RUN: %PYTHON %S/../../tools/wave-matmul-calibrate/wave-matmul-calibrate.py \
# RUN:   --chip=gfx950 --build-dir=%t.no-build \
# RUN:   --kernel-profile=gfx950-f16-256x256-4wave-streamk \
# RUN:   --m=8192 --n=8192 --k=8192 --streamk-workers=8192 \
# RUN:   --variants=scheduled --skip-hw --emit-mlir=%t.fallback.mlir
# RUN: FileCheck %s --check-prefix=FALLBACK --input-file=%t.fallback.mlir

# CHECK: perf-golden: gfx950-f16-256x256-4wave-streamk: asm matches golden
# SOURCE: module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"}
# SOURCE-LABEL: func.func @gfx950_f16_streamk_gemm
# SOURCE-DAG: [[WORKERS:%.*]] = arith.constant 256 : i32
# SOURCE-DAG: [[TRANSITION_END:%.*]] = arith.constant 768 : i32
# SOURCE: [[RAW_WORKER:%.*]] = wave.workgroup_id 0
# SOURCE: [[WORKER:%.*]] = wave.assume [[RAW_WORKER]]
# SOURCE-NOT: waveamd.make_buffer %arg3
# SOURCE: scf.for [[TILE:%.*]] = [[WORKER]] to [[TRANSITION_END]] step [[WORKERS]]
# SOURCE-NOT: waveamd.global_atomic_add_acq_rel
# SOURCE-NOT: waveamd.make_buffer %arg3
# SOURCE: return
# FALLBACK-LABEL: func.func @gfx950_f16_streamk_gemm
# FALLBACK-NOT: waveamd.make_buffer %arg3
# FALLBACK: wave.ptr_add %arg3
# FALLBACK-SAME: !wave.simd<index, 64>

from __future__ import annotations

import subprocess
import sys
from pathlib import Path

NAME = "gfx950-f16-256x256-4wave-streamk"
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
        "--streamk-workers=256",
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


def test_gfx950_f16_256x256_4wave_streamk() -> None:
    check_asm(REPO_ROOT / "build")


def main(argv: list[str]) -> int:
    return perf_golden_mlir.generated_main(
        REPO_ROOT / "build", argv, run_calibrator, check_asm
    )


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
