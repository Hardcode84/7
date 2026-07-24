# RUN: %python %s | FileCheck %s

# CHECK: default-build: ok
# CHECK: build-override: ok
# CHECK: wave-path-fallback: ok
# CHECK: llvm-tools: ok
# CHECK: shared-libs: ok

from __future__ import annotations

import os
import sys
from pathlib import Path
from tempfile import TemporaryDirectory
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
