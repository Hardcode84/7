import json
import os
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

import lit.formats
from lit.llvm import llvm_config
from lit.llvm.subst import ToolSubst

config.name = "wave-mlir"
config.test_format = lit.formats.ShTest(False)
config.suffixes = [".mlir", ".py"]

# Exclude lit's own config files (they share the `.py` suffix); also drop
# build-system staging dirs that we never want walked.
config.excludes = ["Inputs", "lit.cfg.py", "lit.site.cfg.py"]

# Surface the staged Wave Python bindings to the test runners. The
# build target `WavePythonModules` drops everything (the upstream
# `mlir.*` modules + our `wave` / `waveamd` dialect bindings + the
# `_waveDialectsNanobind` nanobind extension) into
# `<build>/python_packages/wave_mlir`, so we prepend that path to
# PYTHONPATH when it exists.
_wave_python_root = str(
    Path(config.wave_mlir_obj_root) / "python_packages" / "wave_mlir"
)
_wave_python_mlir_libs = str(Path(_wave_python_root) / "mlir" / "_mlir_libs")
if Path(_wave_python_root).is_dir():
    llvm_config.with_environment("PYTHONPATH", _wave_python_root, append_path=True)
    config.available_features.add("wave-python-bindings")
    config.substitutions.append(("%wave_python_mlir_libs", _wave_python_mlir_libs))
else:
    # Without the bindings, the dialect-Python smoke tests cannot run.
    config.excludes = [*config.excludes, "python"]

config.test_source_root = str(Path(__file__).parent)
config.test_exec_root = str(Path(config.wave_mlir_obj_root) / "test")

llvm_config.with_environment("WAVE_BUILD_DIR", config.wave_mlir_obj_root)
llvm_config.with_environment("WAVE_LLVM_TOOLS_DIR", config.llvm_tools_dir)
config.substitutions.append(("%PATH%", config.environment["PATH"]))
config.substitutions.append(("%shlibext", config.llvm_shlib_ext))
config.substitutions.append(("%python", f'"{sys.executable}"'))
config.substitutions.append(("%PYTHON", f'"{sys.executable}"'))
config.substitutions.append(("%wave_obj_root", config.wave_mlir_obj_root))
if sys.platform.startswith("linux"):
    config.available_features.add("linux")

_host_environment = ["HOME", "HIP_RUNTIME_LIB", "INCLUDE", "LIB", "TMP", "TEMP"]
# Runtime selection uses HSA_* variables that lit does not preserve by default.
_host_environment.extend(sorted(name for name in os.environ if name.startswith("HSA_")))
llvm_config.with_system_environment(_host_environment)


def _detect_amdgpu_chip() -> str | None:
    """Return the first AMDGPU gfx target reported by rocminfo, or None."""
    rocminfo = shutil.which("rocminfo") or "/opt/rocm/bin/rocminfo"
    if not Path(rocminfo).exists():
        return None
    try:
        with tempfile.TemporaryDirectory(prefix="wave-rocminfo-") as work_dir:
            out = subprocess.run(
                [rocminfo],
                capture_output=True,
                text=True,
                timeout=5,
                check=False,
                cwd=work_dir,
            ).stdout
    except (OSError, subprocess.SubprocessError):
        return None
    for line in out.splitlines():
        token = line.strip()
        if token.startswith("Name:") and "gfx" in token:
            return token.split()[-1]
    return None


def _query_amdgpu_capabilities(chip: str) -> dict[str, object] | None:
    target_info = Path(config.wave_mlir_tools_dir) / "wave-target-info"
    if not target_info.exists():
        return None
    try:
        result = subprocess.run(
            [target_info, "--json", chip],
            capture_output=True,
            text=True,
            timeout=5,
            check=False,
        )
        capabilities = json.loads(result.stdout) if result.returncode == 0 else None
    except (json.JSONDecodeError, OSError, subprocess.SubprocessError):
        return None
    return capabilities if isinstance(capabilities, dict) else None


_chip = _detect_amdgpu_chip()
if _chip:
    config.available_features.add("host-supports-amdgpu")
    config.substitutions.append(("%chip", _chip))
    _capabilities = _query_amdgpu_capabilities(_chip)
    _wave_width = _capabilities.get("default_wavefront_size") if _capabilities else None
    if isinstance(_wave_width, int) and _wave_width > 0:
        config.available_features.add("host-supports-amdgpu-wave")
        config.available_features.add(f"host-supports-amdgpu-wave{_wave_width}")
        config.substitutions.append(("%wave_width", str(_wave_width)))
        config.substitutions.append(("%wave_last", str(_wave_width - 1)))
        config.substitutions.append(("%wave_bytes", str(_wave_width * 4)))
    if _capabilities and _capabilities.get("supports_legacy_wmma") is True:
        config.available_features.add("host-supports-amdgpu-wmma")
    if _capabilities and _capabilities.get("supports_mfma") is True:
        config.available_features.add("host-supports-amdgpu-mfma")
    _matrix_family = _capabilities.get("matrix_family") if _capabilities else None
    if _matrix_family == "gfx1250":
        config.available_features.add("host-supports-amdgpu-gfx1250")
        config.available_features.add("host-supports-amdgpu-gfx1250-wmma")
    if _capabilities and _capabilities.get("target") == "gfx950":
        config.available_features.add("host-supports-amdgpu-gfx950")

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


def _find_hip_runtime() -> tuple[Path, Path] | None:
    override = config.environment.get("ROCM_LIB")
    candidates = [
        Path(override) if override else None,
        Path("/opt/rocm/lib"),
        Path(sys.prefix) / "lib",
    ]
    for lib_dir in candidates:
        if lib_dir is None or not lib_dir.is_dir():
            continue
        libs = sorted(lib_dir.glob("libamdhip64.so*"))
        if libs:
            return lib_dir, libs[0]
    return None


_hip_runtime = _find_hip_runtime()
if _hip_runtime:
    _rocm_lib, _hip_runtime_lib = _hip_runtime
    config.available_features.add("host-has-hip-runtime")
    config.substitutions.append(("%rocm_lib", str(_rocm_lib)))
    config.substitutions.append(("%hip_runtime_lib", str(_hip_runtime_lib)))

_hipcc = (
    config.environment.get("HIPCC") or shutil.which("hipcc") or "/opt/rocm/bin/hipcc"
)
if Path(_hipcc).exists() or shutil.which(_hipcc):
    _hipcc_path = Path(shutil.which(_hipcc) or _hipcc).resolve()
    _hipcc_rocm = _hipcc_path.parent.parent
    _hipconfig = _hipcc_path.parent / "hipconfig"
    if _hipconfig.exists():
        _hipconfig_path = subprocess.run(
            [_hipconfig, "--path"], capture_output=True, text=True, check=False
        )
        if _hipconfig_path.returncode == 0 and _hipconfig_path.stdout.strip():
            _hipcc_rocm = Path(_hipconfig_path.stdout.strip())
    config.available_features.add("host-has-hipcc")
    config.substitutions.append(("%hipcc", f'"{_hipcc}"'))
    config.substitutions.append(("%compiler_rocm_lib", str(_hipcc_rocm / "lib")))

# Compilation pipeline library (transform.named_sequence file) staged
# next to the binary at build time; tests reach it via %wave_pipelines.
_wave_pipelines = (
    Path(config.wave_mlir_obj_root)
    / "share"
    / "wave-mlir"
    / "pipelines"
    / "pipelines.mlir"
)
if _wave_pipelines.exists():
    config.substitutions.append(("%wave_pipelines", str(_wave_pipelines)))
else:
    lit_config.fatal(f"missing Wave pipeline library: {_wave_pipelines}")

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
llvm_nm_subst = None
llvm_readelf_subst = None
for tool_dir in tool_dirs:
    llvm_nm = Path(tool_dir) / "llvm-nm"
    if llvm_nm.exists() and not llvm_nm_subst:
        llvm_nm_subst = str(llvm_nm)
    llvm_readelf = Path(tool_dir) / "llvm-readelf"
    if llvm_readelf.exists() and not llvm_readelf_subst:
        llvm_readelf_subst = str(llvm_readelf)
    if llvm_nm_subst and llvm_readelf_subst:
        break
if llvm_nm_subst:
    config.substitutions.append(("%llvm_nm", llvm_nm_subst))
if llvm_readelf_subst:
    config.substitutions.append(("%llvm_readelf", llvm_readelf_subst))

tools = [
    ToolSubst("FileCheck", unresolved="fatal"),
    ToolSubst("count", unresolved="fatal"),
    ToolSubst("not", unresolved="fatal"),
    ToolSubst("split-file", unresolved="fatal"),
    ToolSubst("llvm-nm", unresolved="fatal"),
    ToolSubst("wave-calibrate-report", unresolved="fatal"),
    ToolSubst("wave-instruction-state-report", unresolved="fatal"),
    ToolSubst("wavec", unresolved="fatal"),
    ToolSubst("wave-opt", unresolved="fatal"),
    ToolSubst("wave-sim-report", unresolved="fatal"),
    ToolSubst("wave-symbols-test", unresolved="fatal"),
    ToolSubst("wave-target-info", unresolved="fatal"),
    ToolSubst("wave-translate", unresolved="fatal"),
    ToolSubst("llvm-mc", unresolved="ignore"),
    ToolSubst("llvm-objcopy", unresolved="ignore"),
    ToolSubst("llvm-objdump", unresolved="ignore"),
    ToolSubst("llvm-readobj", unresolved="ignore"),
    ToolSubst("ld.lld", unresolved="ignore"),
    ToolSubst("llvm-readelf", unresolved="ignore"),
    ToolSubst("mlir-runner", unresolved="ignore"),
]
llvm_config.add_tool_substitutions(tools, tool_dirs)
