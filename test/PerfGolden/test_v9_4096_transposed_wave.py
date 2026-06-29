# REQUIRES: wave-python-bindings
#
# RUN: %PYTHON %s --build-dir %wave_obj_root --generated-out %t.s | FileCheck %s

# CHECK: perf-golden: v9_4096.transposed.wave: asm matches golden

from __future__ import annotations

import argparse
import difflib
import os
import re
import subprocess
import sys
import tempfile
from pathlib import Path

NAME = "v9_4096.transposed.wave"
KERNEL_NAME = "v9_beyond_hotloop"
HERE = Path(__file__).resolve().parent
REPO_ROOT = HERE.parents[1]
SOURCE = HERE / "Inputs" / f"{NAME}.mlir"
GOLDEN = HERE / "Inputs" / f"{NAME}.s"


def normalize_asm(text: str) -> str:
    text = text.replace("\r\n", "\n").replace("\r", "\n")
    lines = [line.rstrip() for line in text.split("\n")]
    while lines and lines[-1] == "":
        lines.pop()
    return "\n".join(lines) + "\n"


def isolate_kernel(tmp: Path) -> Path:
    text = SOURCE.read_text(encoding="utf-8")
    match = re.search(rf"(func\.func @{KERNEL_NAME}.*?\n    \}})", text, re.S)
    if not match:
        raise SystemExit(f"could not isolate {KERNEL_NAME} from {SOURCE}")
    kernel = re.sub(r"^    ", "  ", match.group(1).lstrip(), flags=re.M)
    source = tmp / f"{NAME}.isolated.mlir"
    source.write_text(
        'module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} '
        f"{{\n{kernel}\n}}\n",
        encoding="utf-8",
    )
    return source


def generate_asm(
    build_dir: Path, generated_out: Path, tmp: Path, emit_mlir: Path | None
) -> str:
    wave_translate = build_dir / "bin/wave-translate"
    if not wave_translate.exists():
        raise SystemExit(f"required tool missing: {wave_translate}")
    pipeline_dir = build_dir / "share/wave-mlir/pipelines"
    if not pipeline_dir.exists():
        raise SystemExit(f"backend pipeline dir missing: {pipeline_dir}")

    env = os.environ.copy()
    env["WAVE_PIPELINES_DIR"] = str(pipeline_dir)
    source = isolate_kernel(tmp)
    if emit_mlir is not None:
        emit_mlir.parent.mkdir(parents=True, exist_ok=True)
        emit_mlir.write_text(source.read_text(encoding="utf-8"), encoding="utf-8")
    proc = subprocess.run(
        [str(wave_translate), "--wave-to-amdgpu-asm", str(source)],
        capture_output=True,
        text=True,
        env=env,
        check=False,
    )
    if proc.returncode != 0:
        if proc.stdout:
            sys.stdout.write(proc.stdout)
        if proc.stderr:
            sys.stderr.write(proc.stderr)
        raise SystemExit(proc.returncode)
    generated_out.write_text(proc.stdout, encoding="utf-8")
    return proc.stdout


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
        tmp = Path(td)
        out = generated_out or tmp / f"{NAME}.s"
        generated = normalize_asm(generate_asm(build_dir, out, tmp, emit_mlir))
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


def test_v9_4096_transposed_wave() -> None:
    check_asm(REPO_ROOT / "build")


def main(argv: list[str]) -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--build-dir", type=Path, default=REPO_ROOT / "build")
    parser.add_argument("--generated-out", type=Path)
    parser.add_argument("--emit-mlir", type=Path)
    parser.add_argument("--max-diff-lines", type=int, default=200)
    args = parser.parse_args(argv)

    check_asm(args.build_dir, args.generated_out, args.emit_mlir, args.max_diff_lines)
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
