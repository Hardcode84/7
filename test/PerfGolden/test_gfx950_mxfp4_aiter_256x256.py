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

import argparse
import difflib
import re
import subprocess
import sys
import tempfile
from pathlib import Path

NAME = "gfx950-mxfp4-aiter-256x256"
HERE = Path(__file__).resolve().parent
REPO_ROOT = HERE.parents[1]
CALIBRATOR = REPO_ROOT / "tools/wave-matmul-calibrate/wave-matmul-calibrate.py"
GOLDEN = HERE / "Inputs" / f"{NAME}.s"
VMEM_LOAD = re.compile(r"^\s*(?:buffer|global)_load_\S+")
MAX_WIDTH_VMEM_LOAD = re.compile(
    r"^\s*(?:buffer_load_dwordx4|global_load_b128|global_load_lds_dwordx4)\b"
)


def normalize_asm(text: str) -> str:
    text = text.replace("\r\n", "\n").replace("\r", "\n")
    lines = [line.rstrip() for line in text.split("\n")]
    while lines and lines[-1] == "":
        lines.pop()
    return "\n".join(lines) + "\n"


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


def print_diff(
    golden: str, generated: str, generated_name: str, max_lines: int
) -> None:
    diff = list(
        difflib.unified_diff(
            golden.splitlines(),
            generated.splitlines(),
            fromfile=str(GOLDEN),
            tofile=generated_name,
            lineterm="",
            n=3,
        )
    )
    if max_lines >= 0 and len(diff) > max_lines:
        diff = [*diff[:max_lines], f"... {len(diff) - max_lines} diff lines omitted"]
    for line in diff:
        print(line)


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
        if generated == golden:
            print(f"perf-golden: {NAME}: asm matches golden")
            return
        print(f"perf-golden: {NAME}: ASM DRIFT DETECTED")
        print(f"golden: {GOLDEN}")
        print(f"generated: {out}")
        print("rerun HW perf for both golden and generated asm before updating")
        print_diff(golden, generated, str(out), max_diff_lines)
        raise SystemExit(1)


def test_gfx950_mxfp4_aiter_256x256() -> None:
    check_asm(REPO_ROOT / "build")


def main(argv: list[str]) -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--build-dir", type=Path, default=REPO_ROOT / "build")
    parser.add_argument("--generated-out", type=Path)
    parser.add_argument("--emit-mlir", type=Path)
    parser.add_argument("--max-diff-lines", type=int, default=200)
    args = parser.parse_args(argv)
    if args.emit_mlir is not None and args.generated_out is None:
        run_calibrator(args.build_dir, None, args.emit_mlir)
        return 0
    check_asm(args.build_dir, args.generated_out, args.emit_mlir, args.max_diff_lines)
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
