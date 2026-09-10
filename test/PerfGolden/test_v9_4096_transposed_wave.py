# REQUIRES: wave-python-bindings
#
# RUN: %PYTHON %s --build-dir %wave_obj_root --generated-out %t.s | FileCheck %s

# CHECK: perf-golden: v9_4096.transposed.wave: asm matches golden

from __future__ import annotations

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
sys.path.insert(0, str(HERE / "Inputs"))

import perf_golden_mlir  # noqa: E402

SOURCE = HERE / "Inputs" / f"{NAME}.mlir"
GOLDEN = HERE / "Inputs" / f"{NAME}.s"
normalize_asm = perf_golden_mlir.normalize_asm


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

        perf_golden_mlir.compare_asm(
            NAME, GOLDEN, golden, generated, str(out), max_diff_lines
        )


def test_v9_4096_transposed_wave() -> None:
    check_asm(REPO_ROOT / "build")


def main(argv: list[str]) -> int:
    return perf_golden_mlir.main_with_check(REPO_ROOT / "build", argv, check_asm)


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
