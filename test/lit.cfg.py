import shutil
import subprocess
import sys
from pathlib import Path

import lit.formats
from lit.llvm import llvm_config
from lit.llvm.subst import ToolSubst

config.name = "wave-mlir"
config.test_format = lit.formats.ShTest(not llvm_config.use_lit_shell)
config.suffixes = [".mlir"]

# Python bindings aren't wired into CMake yet; skip the bindings test
# until they are.
config.excludes = ["python", "Inputs"]

config.test_source_root = str(Path(__file__).parent)
config.test_exec_root = str(Path(config.wave_mlir_obj_root) / "test")

config.substitutions.append(("%PATH%", config.environment["PATH"]))
config.substitutions.append(("%shlibext", config.llvm_shlib_ext))
config.substitutions.append(("%python", f'"{sys.executable}"'))

llvm_config.with_system_environment(["HOME", "INCLUDE", "LIB", "TMP", "TEMP"])


def _detect_amdgpu_chip() -> str | None:
    """Return the first AMDGPU gfx target reported by rocminfo, or None."""
    rocminfo = shutil.which("rocminfo") or "/opt/rocm/bin/rocminfo"
    if not Path(rocminfo).exists():
        return None
    try:
        out = subprocess.run(
            [rocminfo], capture_output=True, text=True, timeout=5, check=False
        ).stdout
    except (OSError, subprocess.SubprocessError):
        return None
    for line in out.splitlines():
        token = line.strip()
        if token.startswith("Name:") and "gfx" in token:
            return token.split()[-1]
    return None


_chip = _detect_amdgpu_chip()
if _chip:
    config.available_features.add("host-supports-amdgpu")
    config.substitutions.append(("%chip", _chip))

# Runtime shared libs for the MLIR GPU integration tests.
for name, env_key in [
    ("mlir_rocm_runtime", "MLIR_ROCM_RUNTIME"),
    ("mlir_runner_utils", "MLIR_RUNNER_UTILS"),
]:
    override = config.environment.get(env_key)
    candidates = (
        [override]
        if override
        else [
            str(Path(config.llvm_tools_dir).parent / "lib" / f"lib{name}.so"),
        ]
    )
    for path in candidates:
        if path and Path(path).exists():
            config.substitutions.append((f"%{name}", path))
            break

# Wave host-side runtime helpers (memref -> wave.ptr glue).
_wave_runtime = Path(config.wave_mlir_obj_root) / "lib" / "libwave_runtime.so"
if _wave_runtime.exists():
    config.substitutions.append(("%wave_runtime", str(_wave_runtime)))

# Tool search order: our build's bin first (wave-opt, wave-translate),
# then the LLVM install (llvm-mc, ld.lld, llvm-readelf, FileCheck if
# LLVM_INSTALL_UTILS was on), then the LLVM build dir as a fallback for
# installs that didn't ship the test utilities.
#
# We deliberately don't call `use_default_substitutions()` because it
# resolves FileCheck/count/not against only `config.llvm_tools_dir`,
# which fatally fails when the install was built without
# `LLVM_INSTALL_UTILS=ON`.
tool_dirs = [config.wave_mlir_tools_dir, config.llvm_tools_dir]
extra = getattr(config, "llvm_build_tools_dir", "")
if extra and extra not in tool_dirs:
    tool_dirs.append(extra)

tools = [
    ToolSubst("FileCheck", unresolved="fatal"),
    ToolSubst("count", unresolved="fatal"),
    ToolSubst("not", unresolved="fatal"),
    ToolSubst("wave-opt", unresolved="fatal"),
    ToolSubst("wave-translate", unresolved="fatal"),
    ToolSubst("llvm-mc", unresolved="ignore"),
    ToolSubst("ld.lld", unresolved="ignore"),
    ToolSubst("llvm-readelf", unresolved="ignore"),
    ToolSubst("mlir-runner", unresolved="ignore"),
]
llvm_config.add_tool_substitutions(tools, tool_dirs)
