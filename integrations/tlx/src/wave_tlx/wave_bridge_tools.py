"""Wave tool discovery and verification helpers shared by bridge paths."""

import functools
import hashlib
import os
import shutil
import subprocess
import sys
from pathlib import Path

_WAVE_PIPELINE_FILE = "pipelines.mlir"
_WAVE_PIPELINE_REL = Path("share") / "wave-mlir" / "pipelines" / _WAVE_PIPELINE_FILE
_WAVE_PIPELINE_SOURCE = (
    Path("lib") / "Target" / "Wave" / "pipelines" / _WAVE_PIPELINE_FILE
)
_WAVE_MACHINE_PIPELINE_ENTRY = "waveamd_backend"
_WAVE_HSACO_PIPELINE_ENTRY = "compile_kernels"


def _wave_source_root():
    root = Path(__file__).resolve().parents[4]
    if (root / "llvm-commit.txt").is_file() and (root / "CMakeLists.txt").is_file():
        return root
    return None


def _wave_build_dirs():
    override = os.environ.get("TRITON_WAVE_BUILD_DIR")
    if override:
        yield Path(override)

    source_root = _wave_source_root()
    if source_root is not None:
        yield source_root / "build"
        yield source_root / "build" / "wave-build"


def _candidate_wave_python_paths():
    override = os.environ.get("TRITON_WAVE_PYTHONPATH")
    if override:
        for entry in override.split(os.pathsep):
            if entry:
                yield Path(entry)

    for wave_build_dir in _wave_build_dirs():
        yield wave_build_dir / "python_packages" / "wave_mlir"


def _candidate_wave_tool_paths(tool_name, override=None):
    if override:
        yield Path(override)

    tools_dir = os.environ.get("TRITON_WAVE_TOOLS_DIR")
    if tools_dir:
        yield Path(tools_dir) / tool_name

    for wave_build_dir in _wave_build_dirs():
        yield wave_build_dir / "bin" / tool_name

    installed = shutil.which(tool_name)
    if installed:
        yield Path(installed)


def _candidate_wave_pipeline_paths(wave_opt=None):
    override = os.environ.get("TRITON_WAVE_PIPELINES")
    if override:
        yield Path(override)

    if wave_opt:
        yield Path(wave_opt).resolve().parent.parent / _WAVE_PIPELINE_REL

    for wave_build_dir in _wave_build_dirs():
        yield wave_build_dir / _WAVE_PIPELINE_REL

    source_root = _wave_source_root()
    if source_root is not None:
        yield source_root / _WAVE_PIPELINE_SOURCE


def _existing_paths(candidates):
    seen = set()
    for path in candidates:
        path = path.resolve()
        if path in seen:
            continue
        seen.add(path)
        if path.exists():
            yield path


def _add_wave_python_paths():
    for path in _existing_paths(_candidate_wave_python_paths()):
        path_str = str(path)
        if path_str not in sys.path:
            sys.path.insert(0, path_str)


@functools.cache
def load_wave_dsl():
    _add_wave_python_paths()

    try:
        from mlir.dialects import wave_dsl as w
    except Exception as exc:
        candidates = "\n  ".join(str(path) for path in _candidate_wave_python_paths())
        raise RuntimeError(
            "tlx_wave requires Wave MLIR Python bindings. "
            "Build Wave with `WAVE_ENABLE_PYTHON_BINDINGS=ON`, install the bindings, or set "
            "TRITON_WAVE_PYTHONPATH. "
            f"Unable to import mlir.dialects.wave_dsl: {type(exc).__name__}: {exc}. "
            f"Checked Wave Python package candidates:\n  {candidates}"
        ) from exc
    return w


def _load_wave_ir():
    load_wave_dsl()
    try:
        from mlir import ir
        from mlir.dialects import gpu
    except Exception as exc:
        candidates = "\n  ".join(str(path) for path in _candidate_wave_python_paths())
        raise RuntimeError(
            "tlx_wave requires Wave MLIR Python bindings with the gpu dialect. "
            f"Unable to import MLIR IR/gpu bindings: {type(exc).__name__}: {exc}. "
            f"Checked Wave Python package candidates:\n  {candidates}"
        ) from exc
    return ir, gpu


def _wave_tool(tool_name, override_env=None):
    override = os.environ.get(override_env) if override_env else None
    for path in _existing_paths(_candidate_wave_tool_paths(tool_name, override)):
        if os.access(path, os.X_OK):
            return str(path)
    candidates = "\n  ".join(
        str(path) for path in _candidate_wave_tool_paths(tool_name, override)
    )
    raise RuntimeError(
        f"tlx_wave requires {tool_name} from a Wave build or installation. "
        "Build Wave, put the tool on PATH, or set TRITON_WAVE_TOOLS_DIR. "
        f"Checked {tool_name} candidates:\n  {candidates}"
    )


def _wave_opt():
    return _wave_tool("wave-opt", override_env="TRITON_WAVE_OPT")


def _wave_pipelines_mlir(wave_opt=None):
    for path in _existing_paths(_candidate_wave_pipeline_paths(wave_opt)):
        return path
    candidates = "\n  ".join(
        str(path) for path in _candidate_wave_pipeline_paths(wave_opt)
    )
    raise RuntimeError(
        "tlx_wave requires Wave's transform pipeline library. Install Wave or set "
        f"TRITON_WAVE_PIPELINES to {_WAVE_PIPELINE_FILE}. "
        f"Checked pipeline candidates:\n  {candidates}"
    )


@functools.cache
def _file_sha256(path):
    digest = hashlib.sha256()
    with Path(path).open("rb") as handle:
        while chunk := handle.read(1024 * 1024):
            digest.update(chunk)
    return digest.hexdigest()


def _wave_opt_sha256():
    return _file_sha256(_wave_opt())


def _wave_pipelines_sha256():
    wave_opt = _wave_opt()
    return _file_sha256(_wave_pipelines_mlir(wave_opt))


def _wave_transform_pipeline(entry_point, wave_opt=None, chip=None):
    pipelines = _wave_pipelines_mlir(wave_opt)
    passes = []
    if chip:
        chip = str(chip).split(":", maxsplit=1)[0]
        passes.append(f"wave-set-target-attr{{chip={chip}}}")
    passes.extend(
        [
            f"transform-preload-library{{transform-library-paths={pipelines}}}",
            f"transform-interpreter{{entry-point={entry_point}}}",
        ]
    )
    return "builtin.module(" + ",".join(passes) + ")"


def _wave_machine_pipeline_args(wave_opt=None, chip=None):
    return (
        f"--pass-pipeline={_wave_transform_pipeline(_WAVE_MACHINE_PIPELINE_ENTRY, wave_opt, chip)}",
    )


def _wave_hsaco_pipeline_args(wave_opt=None, chip=None):
    pipeline = _wave_transform_pipeline(_WAVE_HSACO_PIPELINE_ENTRY, wave_opt, chip)
    return (f"--pass-pipeline={pipeline}",)


def _verify_wave_module(wave_text, wave_opt):
    result = subprocess.run(
        [wave_opt, "-", "--verify-diagnostics"],
        input=wave_text,
        text=True,
        capture_output=True,
        check=False,
    )
    if result.returncode != 0:
        detail = (result.stderr or result.stdout).strip()
        raise RuntimeError(
            f"tlx_wave generated Wave module failed wave-opt verification: {detail}"
        )


def _compile_wave_module_to_hsaco(
    wave_text,
    wave_opt,
    chip,
):
    result = subprocess.run(
        [
            wave_opt,
            "-",
            *_wave_hsaco_pipeline_args(
                wave_opt,
                chip,
            ),
        ],
        input=wave_text,
        text=True,
        capture_output=True,
        check=False,
    )
    if result.returncode != 0:
        detail = (result.stderr or result.stdout).strip()
        raise RuntimeError(f"tlx_wave failed to compile Wave module to HSACO: {detail}")
    return _extract_hsaco_from_gpu_binary(result.stdout)


def _extract_hsaco_from_gpu_binary(binary_module_text):
    ir, gpu = _load_wave_ir()
    with ir.Context() as ctx, ir.Location.unknown():
        load_wave_dsl().register_dialects(ctx)
        module = ir.Module.parse(binary_module_text)
        binaries = [
            op for op in module.body.operations if op.operation.name == "gpu.binary"
        ]
        if len(binaries) != 1:
            raise RuntimeError(
                "tlx_wave expected exactly one gpu.binary after Wave HSACO compilation, "
                f"found {len(binaries)}"
            )
        objects = ir.ArrayAttr(binaries[0].attributes["objects"])
        if len(objects) != 1:
            raise RuntimeError(
                "tlx_wave expected exactly one GPU object after Wave HSACO compilation, "
                f"found {len(objects)}"
            )
        hsaco = bytes(gpu.ObjectAttr(objects[0]).object)
    if not hsaco.startswith(b"\x7fELF"):
        raise RuntimeError("tlx_wave Wave HSACO compilation produced a non-ELF object")
    return hsaco
