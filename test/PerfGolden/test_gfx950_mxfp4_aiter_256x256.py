# REQUIRES: wave-python-bindings
#
# RUN: %PYTHON %s --build-dir %wave_obj_root --generated-out %t.s | FileCheck %s
# RUN: %PYTHON %s --build-dir %t.no-build --emit-mlir %t.mlir
# RUN: FileCheck %s --check-prefix=SOURCE --input-file=%t.mlir

# CHECK: perf-golden: gfx950-mxfp4-aiter-256x256: all VMEM loads are 128-bit
# CHECK-NEXT: perf-golden: gfx950-mxfp4-aiter-256x256: asm matches golden
# SOURCE: module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"}
# SOURCE: func.func @wmma_f16_matmul_tiled
# SOURCE-SAME: wave.dynamic_lds_size = 147456 : i64
# SOURCE-SAME: wave.lds_size = 0 : i64

from __future__ import annotations

import re
import subprocess
import sys
import tempfile
from pathlib import Path

NAME = "gfx950-mxfp4-aiter-256x256"
HERE = Path(__file__).resolve().parent
REPO_ROOT = HERE.parents[1]
sys.path.insert(0, str(HERE / "Inputs"))

import perf_golden_mlir  # noqa: E402

CALIBRATOR = REPO_ROOT / "tools/wave-matmul-calibrate/wave-matmul-calibrate.py"
GOLDEN = HERE / "Inputs" / f"{NAME}.s"
VMEM_LOAD = re.compile(r"^\s*(?:buffer|global)_load_\S+")
MAX_WIDTH_VMEM_LOAD = re.compile(
    r"^\s*(?:buffer_load_dwordx4|global_load_b128|global_load_lds_dwordx4)\b"
)
normalize_asm = perf_golden_mlir.normalize_asm
CALIBRATION_VARIANT = "scheduled"


def run_calibrator(
    build_dir: Path, generated_out: Path | None, emit_mlir: Path | None
) -> None:
    cmd = [
        sys.executable,
        str(CALIBRATOR),
        "--chip=gfx950",
        f"--build-dir={build_dir}",
        f"--kernel-profile={NAME}",
        "--m=2048",
        "--n=8192",
        "--k=4096",
        f"--variants={CALIBRATION_VARIANT}",
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


def check_max_width_vmem_loads(asm: str) -> None:
    loads = [line for line in asm.splitlines() if VMEM_LOAD.match(line)]
    if not loads:
        raise SystemExit("no VMEM loads found")
    narrow = [line for line in loads if not MAX_WIDTH_VMEM_LOAD.match(line)]
    if narrow:
        raise SystemExit("non-128-bit VMEM load:\n" + "\n".join(narrow))
    print(f"perf-golden: {NAME}: all VMEM loads are 128-bit")


def check_asm(
    build_dir: Path,
    generated_out: Path | None = None,
    emit_mlir: Path | None = None,
    max_diff_lines: int = 200,
) -> None:
    with tempfile.TemporaryDirectory() as td:
        out = generated_out or Path(td) / f"{NAME}.s"
        run_calibrator(build_dir, out, emit_mlir)
        generated = normalize_asm(out.read_text(encoding="utf-8"))
        check_max_width_vmem_loads(generated)
        golden = normalize_asm(GOLDEN.read_text(encoding="utf-8"))
        perf_golden_mlir.compare_asm(
            NAME, GOLDEN, golden, generated, str(out), max_diff_lines
        )


def test_gfx950_mxfp4_aiter_256x256() -> None:
    check_asm(REPO_ROOT / "build")


def main(argv: list[str]) -> int:
    return perf_golden_mlir.generated_main(
        REPO_ROOT / "build", argv, run_calibrator, check_asm
    )


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
