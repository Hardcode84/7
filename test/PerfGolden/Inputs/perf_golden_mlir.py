# SPDX-FileCopyrightText: 2026 wave-mlir contributors
#
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

from __future__ import annotations

import argparse
import difflib
import os
import subprocess
import sys
import tempfile
from pathlib import Path


def normalize_asm(text: str) -> str:
    text = text.replace("\r\n", "\n").replace("\r", "\n")
    lines = [line.rstrip() for line in text.split("\n")]
    while lines and lines[-1] == "":
        lines.pop()
    return "\n".join(lines) + "\n"


def generate_asm(
    source: Path, build_dir: Path, generated_out: Path, emit_mlir: Path | None
) -> str:
    wave_translate = build_dir / "bin/wave-translate"
    if not wave_translate.exists():
        raise SystemExit(f"required tool missing: {wave_translate}")
    pipeline_dir = build_dir / "share/wave-mlir/pipelines"
    if not pipeline_dir.exists():
        raise SystemExit(f"backend pipeline dir missing: {pipeline_dir}")

    env = os.environ.copy()
    env["WAVE_PIPELINES_DIR"] = str(pipeline_dir)
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
    source: Path,
    golden_path: Path,
    build_dir: Path,
    generated_out: Path | None = None,
    emit_mlir: Path | None = None,
    max_diff_lines: int = 200,
) -> None:
    with tempfile.TemporaryDirectory() as td:
        out = generated_out or Path(td) / f"{name}.s"
        generated = normalize_asm(generate_asm(source, build_dir, out, emit_mlir))
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


def main(
    name: str, source: Path, golden_path: Path, default_build: Path, argv: list[str]
) -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--build-dir", type=Path, default=default_build)
    parser.add_argument("--generated-out", type=Path)
    parser.add_argument("--emit-mlir", type=Path)
    parser.add_argument("--max-diff-lines", type=int, default=200)
    args = parser.parse_args(argv)

    check_asm(
        name,
        source,
        golden_path,
        args.build_dir,
        args.generated_out,
        args.emit_mlir,
        args.max_diff_lines,
    )
    return 0
