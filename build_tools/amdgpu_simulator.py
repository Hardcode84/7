#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2026 wave-mlir contributors
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
"""Set up Mirage and run Wave tests on simulated AMDGPU targets."""

from __future__ import annotations

import argparse
import json
import os
import re
import shlex
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SDK_VERSION = "10.1.0a20260909"
CONFIGS = {
    "gfx942": "gfx942_cdna3.json",
    "gfx950": "gfx950_mi355x.json",
    "gfx1250": "gfx1250_mi455x.json",
}
SMOKE_TESTS = {
    "gfx942": (
        "wavec_saxpy_runtime",
        "wave_mfma_tiled",
        "wave_mfma_gfx942_bf16_runtime",
    ),
    "gfx950": ("wavec_saxpy_runtime", "wave_mfma_tiled"),
    "gfx1250": ("wavec_saxpy_runtime", "wave_gfx1250_tdm_gemm_runtime"),
}
PASS_ENV = (
    "ROCM_LIB",
    "HIPCC",
    "HIP_RUNTIME_LIB",
    "MLIR_ROCM_RUNTIME",
    "ROCJITSU_RUNTIME_DIR",
    "MIRAGE_RUNTIME",
    "MIRAGE_SESSION",
)


def run_checked(command: list[str]) -> None:
    print(shlex.join(command), flush=True)
    subprocess.run(command, check=True)


def sdk_output(venv: Path, *args: str) -> str:
    return subprocess.check_output(
        [str(venv / "bin/rocm-sdk"), *args], text=True
    ).strip()


def prepare_build(args: argparse.Namespace, sdk: Path) -> None:
    build = args.build_dir
    run_checked(
        [
            "cmake",
            "--build",
            str(build),
            "--target",
            "wave-opt",
            "wave-translate",
            "wave-target-info",
            "WavePythonModules",
            "wavec",
            "-j",
            str(len(os.sched_getaffinity(0))),
        ]
    )
    source = args.llvm_source or build / "_deps/llvm-project"
    run_checked(
        [
            *shlex.split(args.cxx),
            "-shared",
            "-fPIC",
            "-O2",
            "-D__HIP_PLATFORM_AMD__",
            "-I",
            str(sdk / "include"),
            "-I",
            str(build / "llvm-install/include"),
            str(source / "mlir/lib/ExecutionEngine/RocmRuntimeWrappers.cpp"),
            str(sdk / "lib/libamdhip64.so"),
            "-o",
            str(build / "simulator/libmlir_rocm_runtime.so"),
        ]
    )


def setup(args: argparse.Namespace) -> None:
    run_checked([sys.executable, "-m", "venv", str(args.sdk_venv)])
    run_checked(
        [
            str(args.sdk_venv / "bin/python"),
            "-m",
            "pip",
            "install",
            "--pre",
            "--index-url",
            "https://nightly.repo.amd.com/rocm/whl-next/",
            f"rocm[libraries,devel]=={SDK_VERSION}",
        ]
    )
    run_checked([str(args.sdk_venv / "bin/rocm-sdk"), "init"])
    sdk = Path(sdk_output(args.sdk_venv, "path", "--root"))
    prepare_build(args, sdk)
    print(f"SDK {sdk_output(args.sdk_venv, 'version')}: {sdk}")


def run_session(
    args: argparse.Namespace,
    sdk: Path,
    config: Path,
    log_dir: Path,
    command: list[str],
) -> bool:
    log_dir.mkdir(parents=True)
    environment = {
        "PATH": f"{sdk / 'bin'}{os.pathsep}{os.environ['PATH']}",
        "LD_LIBRARY_PATH": str(sdk / "lib"),
        "USER": os.environ["USER"],
        "ROCM_LIB": str(sdk / "lib"),
        "HIPCC": str(sdk / "bin/hipcc"),
        "HIP_RUNTIME_LIB": str(sdk / "lib/libamdhip64.so"),
        "MLIR_ROCM_RUNTIME": str(args.build_dir / "simulator/libmlir_rocm_runtime.so"),
        "WAVE_BUILD_DIR": str(args.build_dir),
    }
    with tempfile.TemporaryDirectory(prefix="wsim.", dir=args.runtime_dir) as runtime:
        invocation = [
            "timeout",
            "--signal=TERM",
            "--kill-after=10",
            str(args.timeout),
            str(sdk / "bin/mirage"),
            "run",
            "--config",
            str(config),
            "--workdir",
            str(ROOT),
        ]
        for name, value in environment.items():
            invocation.extend(["--env", f"{name}={value}"])
        invocation.extend(["--", *command])
        (log_dir / "command.json").write_text(json.dumps(invocation, indent=2) + "\n")
        print(f"Running: {log_dir.name}; log: {log_dir / 'output.log'}", flush=True)
        with (log_dir / "output.log").open("w") as output:
            result = subprocess.run(
                invocation,
                env={**os.environ, "MIRAGE_RUNTIME": runtime},
                stdout=output,
                stderr=subprocess.STDOUT,
                check=False,
            )
    (log_dir / "exit-code.txt").write_text(f"{result.returncode}\n")
    if result.returncode:
        print(f"FAILED: exit status {result.returncode}", file=sys.stderr)
        print((log_dir / "output.log").read_text(), file=sys.stderr)
    return result.returncode == 0


def test_path(name: str) -> Path:
    path = Path(name)
    if path.parent == Path():
        path = Path("Integration") / path
    if not path.suffix:
        path = path.with_suffix(".mlir")
    source = (ROOT / "test" / path).resolve()
    relative = source.relative_to(ROOT / "test")
    if not source.is_file() or source.suffix not in (".mlir", ".py"):
        raise ValueError(f"Not a lit test file: {name}")
    return relative


def run_test(
    args: argparse.Namespace, sdk: Path, config: Path, log_dir: Path, path: Path
) -> bool:
    report = log_dir / "results.json"
    command = [
        str(args.build_dir / "bin/llvm-lit"),
        "-sv",
        "-j",
        "1",
        "-D",
        f"wave_test_exec_root={log_dir / 'lit-output'}",
        "-o",
        str(report),
        *(f"--pass-env={name}" for name in PASS_ENV),
        str(args.build_dir / "test" / path),
    ]
    if not run_session(args, sdk, config, log_dir, command):
        return False
    tests = json.loads(report.read_text())["tests"]
    if len(tests) != 1 or tests[0]["code"] != "PASS":
        print(f"FAILED: expected one PASS: {report}", file=sys.stderr)
        print(report.read_text(), file=sys.stderr)
        return False
    print(f"PASS: {path}", flush=True)
    return True


def probe_target(
    args: argparse.Namespace, sdk: Path, config: Path, log_dir: Path, target: str
) -> bool:
    if not run_session(args, sdk, config, log_dir, [str(sdk / "bin/rocminfo")]):
        return False
    chips = set(
        re.findall(
            r"^\s*Name:\s+(gfx\w+)\s*$", (log_dir / "output.log").read_text(), re.M
        )
    )
    if chips != {target}:
        raise ValueError(f"Requested {target}; rocminfo reported {sorted(chips)}")
    return True


def test(args: argparse.Namespace) -> int:
    sdk = Path(sdk_output(args.sdk_venv, "path", "--root"))
    version = sdk_output(args.sdk_venv, "version")
    if not args.skip_build:
        prepare_build(args, sdk)
    logs = args.build_dir / "simulator/logs"
    logs.mkdir(parents=True, exist_ok=True)
    run_dir = Path(tempfile.mkdtemp(prefix="run-", dir=logs))
    (run_dir / "sdk-version.txt").write_text(version + "\n")
    print(f"Results: {run_dir}", flush=True)
    failed = False
    for target in dict.fromkeys(args.targets or CONFIGS):
        config = sdk / "share/rocjitsu/configs" / CONFIGS[target]
        shutil.copyfile(config, run_dir / f"{target}.json")
        probe_dir = run_dir / f"{target}-probe"
        if not probe_target(args, sdk, config, probe_dir, target):
            failed = True
            continue
        paths = args.tests or [test_path(name) for name in SMOKE_TESTS[target]]
        for index, path in enumerate(paths):
            log_dir = run_dir / f"{target}-{index}-{path.stem}"
            if not run_test(args, sdk, config, log_dir, path):
                failed = True
    return int(failed)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    commands = parser.add_subparsers(dest="command", required=True)
    for name in ("setup", "test"):
        command = commands.add_parser(name)
        command.add_argument("--build-dir", type=Path, default=ROOT / "build")
        command.add_argument(
            "--sdk-venv", type=Path, help="default: BUILD/simulator/sdk-venv"
        )
        command.add_argument(
            "--llvm-source", type=Path, help="default: BUILD/_deps/llvm-project"
        )
        command.add_argument("--cxx", default=os.environ.get("CXX", "c++"))
        if name == "test":
            command.add_argument(
                "--target",
                dest="targets",
                choices=CONFIGS,
                action="append",
                help="repeat to select targets; default: all three",
            )
            command.add_argument(
                "--test",
                dest="tests",
                action="append",
                type=test_path,
                help="test basename or path relative to test/; repeat to select tests",
            )
            command.add_argument("--timeout", type=int, default=180)
            command.add_argument(
                "--runtime-dir",
                type=Path,
                help="short temporary parent directory for simulator sockets",
            )
            command.add_argument(
                "--skip-build",
                action="store_true",
                help="use the tools and wrapper from the last build",
            )
    args = parser.parse_args()
    args.build_dir = args.build_dir.resolve()
    if not (args.build_dir / "CMakeCache.txt").is_file():
        parser.error("--build-dir must contain a configured Wave build")
    args.sdk_venv = (args.sdk_venv or args.build_dir / "simulator/sdk-venv").resolve()
    (args.build_dir / "simulator").mkdir(parents=True, exist_ok=True)
    if args.command == "setup":
        setup(args)
        return 0
    if args.timeout <= 0:
        parser.error("--timeout must be positive")
    return test(args)


if __name__ == "__main__":
    try:
        sys.exit(main())
    except (OSError, ValueError, KeyError, subprocess.CalledProcessError) as error:
        sys.exit(f"error: {error}")
