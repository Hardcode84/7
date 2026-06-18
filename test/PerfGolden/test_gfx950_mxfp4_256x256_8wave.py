# RUN: %PYTHON %s --wave-translate wave-translate --generated-out %t.s | FileCheck %s

# CHECK: perf-golden: gfx950-mxfp4-256x256-8wave: asm matches golden

from __future__ import annotations

import argparse
import difflib
import os
import shutil
import subprocess
import sys
from pathlib import Path

NAME = "gfx950-mxfp4-256x256-8wave"
HERE = Path(__file__).resolve().parent
SOURCE = HERE / "Inputs" / f"{NAME}.mlir"
GOLDEN = HERE / "Inputs" / f"{NAME}.s"


def normalize_asm(text: str) -> str:
    text = text.replace("\r\n", "\n").replace("\r", "\n")
    lines = [line.rstrip() for line in text.split("\n")]
    while lines and lines[-1] == "":
        lines.pop()
    return "\n".join(lines) + "\n"


def run_wave_translate(wave_translate: str) -> str:
    proc = subprocess.run(
        [wave_translate, "--wave-to-amdgpu-asm", str(SOURCE)],
        capture_output=True,
        text=True,
        check=False,
    )
    if proc.returncode == 0:
        return proc.stdout
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
    wave_translate: str, generated_out: Path | None = None, max_diff_lines: int = 200
) -> None:
    generated = normalize_asm(run_wave_translate(wave_translate))
    golden = normalize_asm(GOLDEN.read_text(encoding="utf-8"))

    if generated_out:
        generated_out.parent.mkdir(parents=True, exist_ok=True)
        generated_out.write_text(generated, encoding="utf-8")

    if generated == golden:
        print(f"perf-golden: {NAME}: asm matches golden")
        return

    print(f"perf-golden: {NAME}: ASM DRIFT DETECTED")
    print(f"golden: {GOLDEN}")
    if generated_out:
        print(f"generated: {generated_out}")
    print("rerun HW perf for both golden and generated asm before updating")
    print_diff(golden, generated, str(generated_out or "generated"), max_diff_lines)
    raise SystemExit(1)


def default_wave_translate() -> str:
    env = os.environ.get("WAVE_TRANSLATE")
    if env:
        return env
    tool = shutil.which("wave-translate")
    if tool:
        return tool
    raise SystemExit("pass --wave-translate or set WAVE_TRANSLATE")


def test_gfx950_mxfp4_256x256_8wave() -> None:
    check_asm(default_wave_translate())


def main(argv: list[str]) -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--wave-translate")
    parser.add_argument("--generated-out", type=Path)
    parser.add_argument("--max-diff-lines", type=int, default=200)
    args = parser.parse_args(argv)

    wave_translate = args.wave_translate or default_wave_translate()
    check_asm(wave_translate, args.generated_out, args.max_diff_lines)
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
