#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2026 wave-mlir contributors
#
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
"""Fetch and build LLVM/MLIR for wave-mlir.

By default, shallow-clones llvm/llvm-project at the commit pinned in
``llvm-commit.txt`` into ``build/_deps/llvm-project`` and installs MLIR
into ``build/llvm-install``. CMake picks up that install automatically.

Environment overrides
---------------------
LLVM_INSTALL_DIR
    Path to an already-built LLVM install (containing
    ``lib/cmake/{llvm,mlir}``). If set, this script is a no-op.
LLVM_PROJECT_SOURCE_DIR
    Path to an existing ``llvm-project`` source checkout. Used in place
    of cloning.
LLVM_COMMIT
    Override the pinned commit (otherwise read from ``llvm-commit.txt``).
"""

from __future__ import annotations

import argparse
import os
import shlex
import subprocess
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
LLVM_URL = "https://github.com/llvm/llvm-project.git"
COMMIT_FILE = REPO_ROOT / "llvm-commit.txt"
DEFAULT_SOURCE_DIR = REPO_ROOT / "build" / "_deps" / "llvm-project"
DEFAULT_BUILD_DIR = REPO_ROOT / "build" / "llvm-build"
DEFAULT_INSTALL_DIR = REPO_ROOT / "build" / "llvm-install"
STAMP_FILE = ".wave-mlir-commit"


def read_pinned_commit() -> str:
    env = os.environ.get("LLVM_COMMIT")
    if env:
        return env.strip()
    if not COMMIT_FILE.is_file():
        raise SystemExit(f"Pinned commit file not found: {COMMIT_FILE}")
    for raw in COMMIT_FILE.read_text().splitlines():
        line = raw.split("#", 1)[0].strip()
        if line:
            return line
    raise SystemExit(f"No commit pinned in {COMMIT_FILE}")


def run(cmd: list[str], cwd: Path | None = None) -> None:
    pretty = " ".join(shlex.quote(c) for c in cmd)
    suffix = f"  (cwd={cwd})" if cwd else ""
    print(f"+ {pretty}{suffix}", flush=True)
    subprocess.run(cmd, cwd=cwd, check=True)


def fetch_source(source_dir: Path, commit: str) -> None:
    """Shallow-fetch llvm-project at *commit* into *source_dir*."""
    if (source_dir / ".git").is_dir():
        try:
            current = subprocess.check_output(
                ["git", "-C", str(source_dir), "rev-parse", "HEAD"],
                text=True,
            ).strip()
        except subprocess.CalledProcessError:
            current = ""
        if current == commit:
            print(f"llvm-project source already at {commit[:12]}")
            return
        print(f"Updating llvm-project: {current[:12] or '???'} -> {commit[:12]}")
    else:
        source_dir.mkdir(parents=True, exist_ok=True)
        run(["git", "init", "-q", "-b", "main"], cwd=source_dir)
        run(["git", "remote", "add", "origin", LLVM_URL], cwd=source_dir)

    run(
        [
            "git",
            "fetch",
            "--depth",
            "1",
            "--filter=blob:none",
            "origin",
            commit,
        ],
        cwd=source_dir,
    )
    run(["git", "checkout", "--detach", commit], cwd=source_dir)


def resolve_source(default_source: Path, commit: str) -> Path:
    env_src = os.environ.get("LLVM_PROJECT_SOURCE_DIR")
    if env_src:
        path = Path(env_src).resolve()
        if not (path / "llvm" / "CMakeLists.txt").is_file():
            raise SystemExit(
                f"LLVM_PROJECT_SOURCE_DIR={path} does not look like an "
                "llvm-project checkout (missing llvm/CMakeLists.txt).",
            )
        print(f"Using LLVM source at {path} (from $LLVM_PROJECT_SOURCE_DIR)")
        return path

    fetch_source(default_source, commit)
    return default_source


def already_installed(install_dir: Path, commit: str) -> bool:
    stamp = install_dir / STAMP_FILE
    if not stamp.is_file():
        return False
    return stamp.read_text().strip() == commit


def configure_and_build(
    source_dir: Path,
    build_dir: Path,
    install_dir: Path,
    build_type: str,
    jobs: int | None,
    enable_python_bindings: bool,
) -> None:
    build_dir.mkdir(parents=True, exist_ok=True)
    install_dir.mkdir(parents=True, exist_ok=True)
    cmake_args = [
        "cmake",
        "-G",
        "Ninja",
        "-S",
        str(source_dir / "llvm"),
        "-B",
        str(build_dir),
        f"-DCMAKE_BUILD_TYPE={build_type}",
        f"-DCMAKE_INSTALL_PREFIX={install_dir}",
        "-DLLVM_ENABLE_PROJECTS=mlir;lld",
        "-DLLVM_TARGETS_TO_BUILD=AMDGPU;X86",
        "-DLLVM_ENABLE_ASSERTIONS=ON",
        "-DLLVM_ENABLE_RTTI=ON",
        "-DLLVM_ENABLE_ZSTD=OFF",
        "-DLLVM_INSTALL_UTILS=ON",
        "-DLLVM_INCLUDE_BENCHMARKS=OFF",
        "-DLLVM_INCLUDE_EXAMPLES=OFF",
        "-DLLVM_INCLUDE_DOCS=OFF",
        # MLIR ROCm runner library (used by mlir-runner integration tests).
        "-DMLIR_ENABLE_ROCM_RUNNER=ON",
        f"-DMLIR_ENABLE_BINDINGS_PYTHON={'ON' if enable_python_bindings else 'OFF'}",
        f"-DPython3_EXECUTABLE={sys.executable}",
    ]
    run(cmake_args)

    build_cmd = ["cmake", "--build", str(build_dir), "--target", "install"]
    if jobs is not None:
        build_cmd += ["--", f"-j{jobs}"]
    run(build_cmd)


def parse_args(argv: list[str] | None) -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Fetch and build LLVM/MLIR for wave-mlir.",
    )
    parser.add_argument("--source-dir", type=Path, default=DEFAULT_SOURCE_DIR)
    parser.add_argument("--build-dir", type=Path, default=DEFAULT_BUILD_DIR)
    parser.add_argument("--install-dir", type=Path, default=DEFAULT_INSTALL_DIR)
    parser.add_argument("--build-type", default="Release")
    parser.add_argument("--jobs", "-j", type=int, default=None)
    parser.add_argument(
        "--python-bindings",
        action=argparse.BooleanOptionalAction,
        default=False,
        help="Build MLIR Python bindings (requires nanobind).",
    )
    parser.add_argument(
        "--force",
        action="store_true",
        help="Rebuild even if the install matches the pinned commit.",
    )
    return parser.parse_args(argv)


def main(argv: list[str] | None = None) -> int:
    args = parse_args(argv)

    if env_install := os.environ.get("LLVM_INSTALL_DIR"):
        print(f"LLVM_INSTALL_DIR={env_install} is set; nothing to do.")
        return 0

    install_dir = args.install_dir.resolve()
    commit = read_pinned_commit()

    if not args.force and already_installed(install_dir, commit):
        print(
            f"LLVM already installed at {install_dir} "
            f"(commit {commit[:12]}); use --force to rebuild.",
        )
        return 0

    source_dir = resolve_source(args.source_dir.resolve(), commit)
    configure_and_build(
        source_dir=source_dir,
        build_dir=args.build_dir.resolve(),
        install_dir=install_dir,
        build_type=args.build_type,
        jobs=args.jobs,
        enable_python_bindings=args.python_bindings,
    )
    (install_dir / STAMP_FILE).write_text(commit + "\n")
    print(f"\nLLVM/MLIR installed at {install_dir} (commit {commit[:12]})")
    return 0


if __name__ == "__main__":
    sys.exit(main())
