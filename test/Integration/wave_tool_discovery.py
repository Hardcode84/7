# RUN: %python %s | FileCheck %s

# CHECK: default-build: ok
# CHECK: build-override: ok
# CHECK: wave-path-fallback: ok
# CHECK: llvm-tools: ok
# CHECK: shared-libs: ok
# CHECK: alternate-callers: ok

from __future__ import annotations

import argparse
import importlib.util
import os
import subprocess
import sys
from pathlib import Path
from tempfile import TemporaryDirectory
from types import ModuleType
from unittest.mock import patch

REPO_ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(REPO_ROOT / "examples" / "wave"))

import common  # noqa: E402
from common import (  # noqa: E402
    default_build_dir,
    default_shared_libs,
    resolve_llvm_tool,
    resolve_wave_tool,
)


def make_file(path: Path) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.touch()


def load_module(name: str, path: Path) -> ModuleType:
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec is not None and spec.loader is not None
    loaded = importlib.util.module_from_spec(spec)
    sys.modules[name] = loaded
    spec.loader.exec_module(loaded)
    return loaded


microbench = load_module(
    "wave_microbench_test",
    REPO_ROOT / "tools" / "wave-microbench" / "wave-microbench.py",
)
fa_calibrate = load_module(
    "wave_fa_calibrate_test",
    REPO_ROOT / "tools" / "wave-fa-calibrate" / "wave-fa-calibrate.py",
)


with TemporaryDirectory() as temp_dir:
    temp = Path(temp_dir)

    flat_root = temp / "flat"
    make_file(flat_root / "build" / "bin" / "wave-opt")
    nested_root = temp / "nested"
    make_file(nested_root / "build" / "wave-build" / "bin" / "wave-opt")
    with patch.dict(os.environ, {}, clear=True):
        assert default_build_dir(flat_root) == flat_root / "build"
        assert default_build_dir(nested_root) == nested_root / "build" / "wave-build"
    print("default-build: ok")

    custom_build = temp / "custom-build"
    wave_translate = custom_build / "bin" / "wave-translate"
    make_file(wave_translate)
    with patch.dict(os.environ, {"WAVE_BUILD_DIR": str(custom_build)}, clear=True):
        assert default_build_dir(flat_root) == custom_build
        assert resolve_wave_tool("wave-translate") == wave_translate
    print("build-override: ok")

    path_tool = temp / "path-tools" / "wave-opt"
    with (
        patch.dict(os.environ, {}, clear=True),
        patch.object(common.shutil, "which", return_value=str(path_tool)),
    ):
        assert resolve_wave_tool("wave-opt", temp / "missing-build") == path_tool
    print("wave-path-fallback: ok")

    llvm_bin = temp / "custom-llvm" / "bin"
    llvm_mc = llvm_bin / "llvm-mc"
    make_file(llvm_mc)
    with patch.dict(os.environ, {"WAVE_LLVM_TOOLS_DIR": str(llvm_bin)}, clear=True):
        assert resolve_llvm_tool("llvm-mc", custom_build) == llvm_mc
    print("llvm-tools: ok")

    with patch.dict(
        os.environ,
        {
            "WAVE_BUILD_DIR": str(custom_build),
            "WAVE_LLVM_TOOLS_DIR": str(llvm_bin),
        },
        clear=True,
    ):
        assert default_shared_libs(flat_root) == [
            llvm_bin.parent / "lib" / "libmlir_rocm_runtime.so",
            llvm_bin.parent / "lib" / "libmlir_runner_utils.so",
            custom_build / "lib" / "libwave_runtime.so",
        ]
    print("shared-libs: ok")

    alternate_build = temp / "alternate-build"
    alternate_wave_tools = [
        alternate_build / "bin" / name
        for name in ("wave-opt", "wave-translate", "wave-sim-report")
    ]
    alternate_llvm_tools = [
        alternate_build / "llvm-install" / "bin" / name
        for name in ("llvm-mc", "ld.lld")
    ]
    for tool in alternate_wave_tools + alternate_llvm_tools:
        make_file(tool)
    package_path = alternate_build / "python_packages" / "wave_mlir"
    package_path.mkdir(parents=True)

    mlir_source = temp / "kernel.mlir"
    mlir_source.write_text(
        'module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {}'
    )
    commands: list[list[str]] = []

    def record_subprocess(command, **kwargs):
        commands.append([str(arg) for arg in command])
        return subprocess.CompletedProcess(
            command, 0, stdout="<<<i64 : 7>>>", stderr=""
        )

    microbench_tmp = temp / "microbench"
    microbench_tmp.mkdir()
    with (
        patch.dict(os.environ, {}, clear=True),
        patch.object(microbench.subprocess, "run", side_effect=record_subprocess),
    ):
        microbench.lower_to_hsaco(
            alternate_build, "gfx1100", mlir_source, microbench_tmp
        )
        assert (
            microbench.predict_cycles(
                alternate_build,
                mlir_source,
                "gfx1100",
                "kernel",
                microbench_tmp,
            )
            == 7
        )
    expected_commands = [
        alternate_build / "bin" / "wave-translate",
        alternate_build / "llvm-install" / "bin" / "llvm-mc",
        alternate_build / "llvm-install" / "bin" / "ld.lld",
        alternate_build / "bin" / "wave-opt",
    ]
    actual_commands = [Path(command[0]) for command in commands]
    assert actual_commands == expected_commands, actual_commands

    fa_args = argparse.Namespace(
        block_m=16,
        block_n=16,
        build_dir=alternate_build,
        calibration_file=None,
        head_dim=32,
        seed=0,
        seq_n=16,
        target_waves=0,
        tile_loop_unroll=0,
    )
    example_env = []

    def record_example(command, *, env):
        example_env.append(env)
        return ""

    with (
        patch.object(fa_calibrate, "run", side_effect=record_example),
        patch.object(
            fa_calibrate,
            "extract_kernel_op",
            return_value="func.func @flash_attention_f32()",
        ),
    ):
        fa_calibrate.generate_kernel_module(fa_args, "gfx1100")
    assert example_env[0]["PYTHONPATH"].split(os.pathsep)[0] == str(package_path)

    pipeline = temp / "pipelines.mlir"
    pipeline.touch()
    fa_commands: list[list[str]] = []
    fa_outputs = iter(("machine", "asm", "total_cycles: 9"))

    def record_fa_command(command, **kwargs):
        fa_commands.append([str(arg) for arg in command])
        return next(fa_outputs)

    with patch.object(fa_calibrate, "run", side_effect=record_fa_command):
        machine = fa_calibrate.lower_machine(
            alternate_build, mlir_source, pipeline, temp, "alternate"
        )
        fa_calibrate.lower_asm(alternate_build, machine, pipeline, temp, "alternate")
        assert fa_calibrate.run_sim_report(alternate_build, machine, fa_args) == 9
    assert [Path(command[0]) for command in fa_commands] == alternate_wave_tools

    with patch.dict(os.environ, {"WAVE_BUILD_DIR": str(alternate_build)}, clear=True):
        assert (
            microbench.build_argparser().parse_args([str(mlir_source)]).build_dir
            == alternate_build
        )
        assert (
            fa_calibrate.build_argparser().parse_args([]).build_dir == alternate_build
        )
    print("alternate-callers: ok")
