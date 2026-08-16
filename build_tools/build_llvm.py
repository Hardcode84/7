#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2026 wave-mlir contributors
#
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
"""Fetch and build LLVM/MLIR for wave-mlir.

By default, shallow-clones llvm/llvm-project at the commit pinned in
``llvm-commit.txt`` into ``build/_deps/llvm-project`` and installs MLIR
into ``build/llvm-install``. CMake picks up that install automatically.
Configured wave-mlir build trees are reconfigured and cleaned after the
install changes so stale objects cannot survive an LLVM ABI change.

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
DEFAULT_WAVE_BUILD_DIR = REPO_ROOT / "build"
STAMP_FILE = ".wave-mlir-commit"
LLVM_DISTRIBUTION_COMPONENTS = (
    "FileCheck",
    "clang",
    "clang-cmake-exports",
    "clang-headers",
    "clang-libraries",
    "clang-resource-headers",
    "cmake-exports",
    "count",
    "lld",
    "lld-cmake-exports",
    "llvm-headers",
    "llvm-libraries",
    "llvm-mc",
    "llvm-nm",
    "llvm-objcopy",
    "llvm-objdump",
    "llvm-readelf",
    "llvm-readobj",
    "mlir-cmake-exports",
    "mlir-headers",
    "mlir-libraries",
    "mlir-python-sources",
    "mlir-tblgen",
    "not",
    "split-file",
)
ROCM_RUNNER_DISTRIBUTION_COMPONENTS = (
    "mlir-runner",
    "mlir_apfloat_wrappers",
    "mlir_float16_utils",
    "mlir_rocm_runtime",
    "mlir_runner_utils",
)


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


def read_cmake_cache_value(cache: Path, key: str) -> str | None:
    if not cache.is_file():
        return None
    prefix = f"{key}:"
    for raw in cache.read_text().splitlines():
        if not raw.startswith(prefix):
            continue
        _, value = raw.split("=", 1)
        return value
    return None


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


def required_install_files(
    install_dir: Path,
    enable_python_bindings: bool,
    enable_rocm_runner: bool,
) -> list[Path]:
    tools = (
        "FileCheck",
        "count",
        "ld.lld",
        "llvm-mc",
        "llvm-nm",
        "llvm-objcopy",
        "llvm-objdump",
        "llvm-readelf",
        "llvm-readobj",
        "mlir-tblgen",
        "not",
        "split-file",
    )
    paths = [install_dir / "bin" / tool for tool in tools]
    if enable_python_bindings:
        paths.append(
            install_dir / "src" / "python" / "MLIRPythonSources.Core.Python" / "ir.py"
        )
    if enable_rocm_runner:
        paths.extend(
            (
                install_dir / "bin" / "mlir-runner",
                install_dir / "lib" / "libmlir_rocm_runtime.so",
                install_dir / "lib" / "libmlir_runner_utils.so",
            )
        )
    return paths


def already_installed(
    install_dir: Path,
    commit: str,
    enable_python_bindings: bool,
    enable_rocm_runner: bool,
) -> bool:
    stamp = install_dir / STAMP_FILE
    if not stamp.is_file() or stamp.read_text().strip() != commit:
        return False
    for package in ("llvm", "mlir", "clang", "lld"):
        if not (install_dir / "lib" / "cmake" / package).is_dir():
            return False
    required_files = required_install_files(
        install_dir,
        enable_python_bindings,
        enable_rocm_runner,
    )
    return all(path.is_file() for path in required_files)


def configure_and_build(
    source_dir: Path,
    build_dir: Path,
    install_dir: Path,
    build_type: str,
    jobs: int | None,
    enable_python_bindings: bool,
    enable_rocm_runner: bool,
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
        "-DLLVM_ENABLE_PROJECTS=clang;mlir;lld",
        "-DLLVM_TARGETS_TO_BUILD=AMDGPU;X86",
        "-DLLVM_ENABLE_ASSERTIONS=ON",
        "-DLLVM_ENABLE_RTTI=ON",
        "-DLLVM_ENABLE_ZSTD=OFF",
        "-DLLVM_INSTALL_UTILS=ON",
        "-DLLVM_ENABLE_BINDINGS=OFF",
        "-DLLVM_INCLUDE_BENCHMARKS=OFF",
        "-DLLVM_INCLUDE_EXAMPLES=OFF",
        "-DLLVM_INCLUDE_DOCS=OFF",
        "-DMLIR_INCLUDE_TESTS=OFF",
        "-DLLVM_DISTRIBUTION_COMPONENTS="
        + ";".join(
            (*LLVM_DISTRIBUTION_COMPONENTS, *ROCM_RUNNER_DISTRIBUTION_COMPONENTS)
            if enable_rocm_runner
            else LLVM_DISTRIBUTION_COMPONENTS
        ),
        f"-DMLIR_ENABLE_ROCM_RUNNER={'ON' if enable_rocm_runner else 'OFF'}",
        f"-DMLIR_ENABLE_BINDINGS_PYTHON={'ON' if enable_python_bindings else 'OFF'}",
        f"-DPython3_EXECUTABLE={sys.executable}",
    ]
    run(cmake_args)

    build_cmd = [
        "cmake",
        "--build",
        str(build_dir),
        "--target",
        "install-distribution",
    ]
    if jobs is not None:
        build_cmd += ["--", f"-j{jobs}"]
    run(build_cmd)


def refresh_wave_build(
    wave_build_dir: Path,
    source_dir: Path,
    llvm_build_dir: Path,
    install_dir: Path,
) -> None:
    if wave_build_dir == llvm_build_dir:
        print(f"Wave build dir equals LLVM build dir; skipping {wave_build_dir}")
        return

    cache = wave_build_dir / "CMakeCache.txt"
    if not cache.is_file():
        print(f"Wave build tree not configured at {wave_build_dir}; skipping clean.")
        return

    cached_install = read_cmake_cache_value(cache, "LLVM_INSTALL_DIR")
    if cached_install:
        cached_install_dir = Path(cached_install).resolve()
        if cached_install_dir != install_dir:
            print(
                f"Wave build at {wave_build_dir} uses LLVM_INSTALL_DIR="
                f"{cached_install_dir}; installed {install_dir}, skipping clean.",
            )
            return

    run(
        [
            "cmake",
            "-S",
            str(REPO_ROOT),
            "-B",
            str(wave_build_dir),
            f"-DLLVM_INSTALL_DIR={install_dir}",
            f"-DWAVE_LLVM_PROJECT_SRC_DIR={source_dir}",
            f"-DWAVE_LLVM_PROJECT_BUILD_DIR={llvm_build_dir}",
        ],
    )
    run(["cmake", "--build", str(wave_build_dir), "--target", "clean"])


def parse_args(argv: list[str] | None) -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Fetch and build LLVM/MLIR for wave-mlir.",
    )
    parser.add_argument("--source-dir", type=Path, default=DEFAULT_SOURCE_DIR)
    parser.add_argument("--build-dir", type=Path, default=DEFAULT_BUILD_DIR)
    parser.add_argument("--install-dir", type=Path, default=DEFAULT_INSTALL_DIR)
    parser.add_argument(
        "--wave-build-dir",
        type=Path,
        default=DEFAULT_WAVE_BUILD_DIR,
        help="Configured wave-mlir build tree to refresh after LLVM install.",
    )
    parser.add_argument("--build-type", default="Release")
    parser.add_argument("--jobs", "-j", type=int, default=None)
    parser.add_argument(
        "--python-bindings",
        action=argparse.BooleanOptionalAction,
        default=False,
        help="Build MLIR Python bindings (requires nanobind).",
    )
    parser.add_argument(
        "--rocm-runner",
        action=argparse.BooleanOptionalAction,
        default=True,
        help="Build mlir-runner and its ROCm runtime support.",
    )
    parser.add_argument(
        "--force",
        action="store_true",
        help="Rebuild even if the install matches the pinned commit.",
    )
    parser.add_argument(
        "--no-refresh-wave-build",
        action="store_true",
        help="Do not reconfigure and clean the wave-mlir build after LLVM install.",
    )
    return parser.parse_args(argv)


def main(argv: list[str] | None = None) -> int:
    args = parse_args(argv)

    if env_install := os.environ.get("LLVM_INSTALL_DIR"):
        print(f"LLVM_INSTALL_DIR={env_install} is set; nothing to do.")
        return 0

    install_dir = args.install_dir.resolve()
    commit = read_pinned_commit()

    if not args.force and already_installed(
        install_dir,
        commit,
        args.python_bindings,
        args.rocm_runner,
    ):
        print(
            f"LLVM already installed at {install_dir} "
            f"(commit {commit[:12]}); use --force to rebuild.",
        )
        return 0

    source_dir = resolve_source(args.source_dir.resolve(), commit)
    llvm_build_dir = args.build_dir.resolve()
    configure_and_build(
        source_dir=source_dir,
        build_dir=llvm_build_dir,
        install_dir=install_dir,
        build_type=args.build_type,
        jobs=args.jobs,
        enable_python_bindings=args.python_bindings,
        enable_rocm_runner=args.rocm_runner,
    )
    (install_dir / STAMP_FILE).write_text(commit + "\n")
    print(f"\nLLVM/MLIR installed at {install_dir} (commit {commit[:12]})")
    if not args.no_refresh_wave_build:
        refresh_wave_build(
            wave_build_dir=args.wave_build_dir.resolve(),
            source_dir=source_dir,
            llvm_build_dir=llvm_build_dir,
            install_dir=install_dir,
        )
    return 0


if __name__ == "__main__":
    sys.exit(main())
