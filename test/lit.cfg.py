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
config.excludes = ["python"]

config.test_source_root = str(Path(__file__).parent)
config.test_exec_root = str(Path(config.wave_mlir_obj_root) / "test")

config.substitutions.append(("%PATH%", config.environment["PATH"]))
config.substitutions.append(("%shlibext", config.llvm_shlib_ext))
config.substitutions.append(("%python", f'"{sys.executable}"'))

llvm_config.with_system_environment(["HOME", "INCLUDE", "LIB", "TMP", "TEMP"])

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
]
llvm_config.add_tool_substitutions(tools, tool_dirs)
