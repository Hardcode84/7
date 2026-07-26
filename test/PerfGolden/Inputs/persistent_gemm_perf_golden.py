from __future__ import annotations

import argparse
import difflib
import subprocess
import sys
import tempfile
from pathlib import Path

INPUTS = Path(__file__).resolve().parent
REPO_ROOT = INPUTS.parents[2]
CALIBRATOR = REPO_ROOT / "tools/wave-matmul-calibrate/wave-matmul-calibrate.py"


def normalize_asm(text: str) -> str:
    text = text.replace("\r\n", "\n").replace("\r", "\n")
    lines = [line.rstrip() for line in text.split("\n")]
    while lines and lines[-1] == "":
        lines.pop()
    return "\n".join(lines) + "\n"


def run_calibrator(
    name: str,
    build_dir: Path,
    generated_out: Path | None,
    emit_mlir: Path | None,
) -> None:
    cmd = [
        sys.executable,
        str(CALIBRATOR),
        "--chip=gfx950",
        f"--build-dir={build_dir}",
        f"--kernel-profile={name}",
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


def print_diff(
    golden_path: Path,
    golden: str,
    generated: str,
    generated_name: str,
    max_lines: int,
) -> None:
    diff = list(
        difflib.unified_diff(
            golden.splitlines(),
            generated.splitlines(),
            fromfile=str(golden_path),
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
    name: str,
    build_dir: Path,
    generated_out: Path | None = None,
    emit_mlir: Path | None = None,
    max_diff_lines: int = 200,
) -> None:
    golden_path = INPUTS / f"{name}.s"
    with tempfile.TemporaryDirectory() as td:
        out = generated_out or Path(td) / f"{name}.s"
        run_calibrator(name, build_dir, out, emit_mlir)
        generated = normalize_asm(out.read_text(encoding="utf-8"))
        golden = normalize_asm(golden_path.read_text(encoding="utf-8"))

        if generated == golden:
            print(f"perf-golden: {name}: asm matches golden")
            return

        print(f"perf-golden: {name}: ASM DRIFT DETECTED")
        print(f"golden: {golden_path}")
        print(f"generated: {out}")
        print("rerun HW perf for both golden and generated asm before updating")
        print_diff(golden_path, golden, generated, str(out), max_diff_lines)
        raise SystemExit(1)


def run_main(name: str, argv: list[str]) -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--build-dir", type=Path, default=REPO_ROOT / "build")
    parser.add_argument("--generated-out", type=Path)
    parser.add_argument("--emit-mlir", type=Path)
    parser.add_argument("--max-diff-lines", type=int, default=200)
    args = parser.parse_args(argv)

    if args.emit_mlir is not None and args.generated_out is None:
        run_calibrator(name, args.build_dir, None, args.emit_mlir)
        return 0
    check_asm(
        name,
        args.build_dir,
        args.generated_out,
        args.emit_mlir,
        args.max_diff_lines,
    )
    return 0
