#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2026 wave-mlir contributors
#
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
"""Regenerate checked-in perf-golden assembly."""

from __future__ import annotations

import argparse
import runpy
import shutil
import subprocess
import sys
from dataclasses import dataclass
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[1]
PERF_GOLDEN_DIR = REPO_ROOT / "test/PerfGolden"
DEFAULT_OUTPUT_DIR = REPO_ROOT / "build/test/PerfGolden/Regenerated"


@dataclass(frozen=True)
class GoldenTest:
    path: Path
    name: str
    golden: Path


def rel(path: Path) -> str:
    try:
        return str(path.resolve().relative_to(REPO_ROOT))
    except ValueError:
        return str(path)


def discover_tests(paths: list[Path]) -> list[GoldenTest]:
    test_paths = paths or sorted(PERF_GOLDEN_DIR.glob("test_*.py"))
    tests = []
    for path in test_paths:
        path = path if path.is_absolute() else REPO_ROOT / path
        data = runpy.run_path(str(path))
        golden = data.get("GOLDEN")
        if golden is None:
            raise SystemExit(f"{rel(path)}: missing GOLDEN")
        tests.append(
            GoldenTest(
                path=path,
                name=str(data.get("NAME", path.stem)),
                golden=Path(golden),
            )
        )
    if not tests:
        raise SystemExit("no perf-golden tests found")
    return tests


def run_helper(
    test: GoldenTest,
    build_dir: Path,
    generated: Path,
    max_diff_lines: int,
) -> None:
    cmd = [
        sys.executable,
        str(test.path),
        "--build-dir",
        str(build_dir),
        "--generated-out",
        str(generated),
        "--max-diff-lines",
        str(max_diff_lines),
    ]
    proc = subprocess.run(cmd, capture_output=True, text=True, check=False)
    if proc.returncode == 0:
        return
    if "ASM DRIFT DETECTED" in proc.stdout and generated.exists():
        return
    if proc.stdout:
        sys.stdout.write(proc.stdout)
    if proc.stderr:
        sys.stderr.write(proc.stderr)
    raise SystemExit(proc.returncode)


def copy_generated(test: GoldenTest, generated: Path) -> bool:
    if not generated.exists():
        raise SystemExit(f"{test.name}: generated asm missing: {rel(generated)}")
    new_data = generated.read_bytes()
    old_data = test.golden.read_bytes() if test.golden.exists() else None
    if old_data == new_data:
        return False
    shutil.copyfile(generated, test.golden)
    return True


def regenerate(
    tests: list[GoldenTest],
    build_dir: Path,
    output_dir: Path,
    max_diff_lines: int,
) -> None:
    output_dir.mkdir(parents=True, exist_ok=True)
    for index, test in enumerate(tests, start=1):
        generated = output_dir / test.golden.name
        print(f"[{index}/{len(tests)}] {test.name}", flush=True)
        run_helper(test, build_dir, generated, max_diff_lines)
        if copy_generated(test, generated):
            print(f"  updated {rel(test.golden)}", flush=True)
        else:
            print(f"  unchanged {rel(test.golden)}", flush=True)


def run_lit(build_dir: Path) -> None:
    lit = build_dir / "bin/llvm-lit"
    test_root = build_dir / "test"
    if not lit.exists():
        raise SystemExit(f"llvm-lit missing: {rel(lit)}")
    if not test_root.exists():
        raise SystemExit(f"lit test dir missing: {rel(test_root)}")
    subprocess.run(
        [str(lit), "-sv", str(test_root), "--filter=PerfGolden"],
        check=True,
    )


def main(argv: list[str]) -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("tests", nargs="*", type=Path)
    parser.add_argument("--build-dir", type=Path, default=REPO_ROOT / "build")
    parser.add_argument("--output-dir", type=Path, default=DEFAULT_OUTPUT_DIR)
    parser.add_argument("--max-diff-lines", type=int, default=0)
    parser.add_argument("--skip-lit", action="store_true")
    args = parser.parse_args(argv)

    tests = discover_tests(args.tests)
    regenerate(tests, args.build_dir, args.output_dir, args.max_diff_lines)
    if not args.skip_lit:
        run_lit(args.build_dir)
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
