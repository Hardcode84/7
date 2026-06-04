# REQUIRES: linux, wave-python-bindings
# RUN: %python %s %wave_python_mlir_libs %llvm_nm %llvm_readelf

import re
import subprocess
import sys
from pathlib import Path

lib_dir = Path(sys.argv[1])
llvm_nm = sys.argv[2]
llvm_readelf = sys.argv[3]


def nm_symbols(path, *args):
    result = subprocess.run(
        [llvm_nm, "-D", *args, str(path)],
        check=True,
        capture_output=True,
        text=True,
    )
    symbols = []
    for line in result.stdout.splitlines():
        parts = line.split()
        if parts:
            symbols.append(parts[-1])
    return symbols


modules = sorted(lib_dir.glob("_*.so"))
real_paths = {module.resolve() for module in modules}
if len(real_paths) != 1:
    print("expected all Python modules to point at one shared library", file=sys.stderr)
    for module in modules:
        print(f"{module.name} -> {module.resolve()}", file=sys.stderr)
    sys.exit(1)

for header in [
    lib_dir / "include" / "mlir-c" / "IR.h",
    lib_dir / "include" / "mlir-c" / "Bindings" / "Python" / "Interop.h",
]:
    if not header.exists():
        print(f"missing installed Python C API header: {header}", file=sys.stderr)
        sys.exit(1)

bundle = next(iter(real_paths))
defined = set(nm_symbols(bundle, "--defined-only"))
required = {
    "PyInit__mlir",
    "PyInit__mlirRegisterEverything",
    "PyInit__waveDialectsNanobind",
}
missing = sorted(required - defined)
if missing:
    print("single Python library missing required exports:", file=sys.stderr)
    print("\n".join(missing), file=sys.stderr)
    sys.exit(1)

bad_exports = [sym for sym in sorted(defined) if not sym.startswith("PyInit_")]
if bad_exports:
    print("single Python library exports non-Python-init symbols:", file=sys.stderr)
    print("\n".join(bad_exports[:20]), file=sys.stderr)
    sys.exit(1)

bad_undefined = [
    sym
    for sym in nm_symbols(bundle, "--undefined-only")
    if sym.startswith(("mlir", "LLVM", "_ZN4mlir", "_ZN4llvm"))
]
if bad_undefined:
    print("single Python library imports MLIR/LLVM symbols:", file=sys.stderr)
    print("\n".join(bad_undefined[:20]), file=sys.stderr)
    sys.exit(1)

result = subprocess.run(
    [llvm_readelf, "-d", str(bundle)],
    check=True,
    capture_output=True,
    text=True,
)
bad_needed = [
    line
    for line in result.stdout.splitlines()
    if "NEEDED" in line
    and re.search(r"lib(LLVM|MLIR|WavePythonCAPI|nanobind-mlir)", line)
]
if bad_needed:
    print("single Python library depends on split MLIR/Wave dylibs:", file=sys.stderr)
    print("\n".join(bad_needed), file=sys.stderr)
    sys.exit(1)
