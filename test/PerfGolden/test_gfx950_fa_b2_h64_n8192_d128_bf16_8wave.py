# REQUIRES: wave-python-bindings
#
# RUN: %PYTHON %s --build-dir %wave_obj_root --generated-out %t.s | FileCheck %s
# RUN: %PYTHON %s --build-dir %wave_obj_root --emit-mlir %t.mlir
# RUN: FileCheck %s --check-prefix=SOURCE --input-file=%t.mlir

# CHECK: perf-golden: gfx950-fa-b2-h64-n8192-d128-bf16-8wave: asm matches golden
# SOURCE: module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"}
# SOURCE-COUNT-31: wave.fadd {{.*}} fastmath<reassoc>

from __future__ import annotations

import argparse
import difflib
import subprocess
import sys
import tempfile
from pathlib import Path

NAME = "gfx950-fa-b2-h64-n8192-d128-bf16-8wave"
HERE = Path(__file__).resolve().parent
REPO_ROOT = HERE.parents[1]
CALIBRATOR = REPO_ROOT / "tools/wave-fa-calibrate/wave-fa-gfx950.py"
GOLDEN = HERE / "Inputs" / f"{NAME}.s"


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
        f"--build-dir={build_dir}",
        "--batch=2",
        "--heads=64",
        "--sequence=8192",
        "--xcds=8",
        "--waves=8",
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


def test_gfx950_fa_b2_h64_n8192_d128_bf16_8wave() -> None:
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
