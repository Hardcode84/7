# RUN: %python %s %wave_pipelines | FileCheck %s

# CHECK: matmul_pipeline: ok
# CHECK: fa_pipeline: ok
# CHECK: matmul_pingpong_removed: ok

from __future__ import annotations

import argparse
import importlib.util
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[3]
PIPELINE_PATH = Path(sys.argv[1])
BUILD_DIR = PIPELINE_PATH.parents[3]


def load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot load {path}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


def require(label: str, condition: bool, message: str) -> None:
    if not condition:
        print(f"{label}: {message}", file=sys.stderr)
        raise SystemExit(1)


def find_named_sequence(ir, module, name: str):
    for op in module.body.operations:
        attr = op.attributes.get("sym_name")
        if attr is not None and ir.StringAttr(attr).value == name:
            return op
    return None


def body_ops(named_sequence):
    return list(named_sequence.regions[0].blocks[0].operations)


def applied_passes(ir, named_sequence) -> list[str]:
    out: list[str] = []
    for op in body_ops(named_sequence):
        if op.name != "transform.apply_registered_pass":
            continue
        out.append(ir.StringAttr(op.attributes["pass_name"]).value)
    return out


def included_sequences(ir, named_sequence) -> list[str]:
    out: list[str] = []
    for op in body_ops(named_sequence):
        if op.name != "transform.include":
            continue
        out.append(ir.FlatSymbolRefAttr(op.attributes["target"]).value)
    return out


def check_calibration_entry(label: str, module) -> None:
    text = module.pipeline_text(
        BUILD_DIR,
        schedule_options={"apply-schedule": True, "pressure-aware-selection": True},
        report_options={"print-candidates": True},
    )
    ir, _ = module.import_mlir_bindings(BUILD_DIR)
    with ir.Context():
        parsed = ir.Module.parse(text)
        entry = find_named_sequence(ir, parsed, "__transform_main")
        finish = find_named_sequence(ir, parsed, "waveamd_backend_finish")
        require(label, entry is not None, "missing __transform_main")
        require(label, finish is not None, "missing backend finish")
        includes = included_sequences(ir, entry)
        require(label, "waveamd_backend_lower" in includes, "no lower include")
        require(label, "waveamd_backend_finish" in includes, "no finish include")
        entry_passes = applied_passes(ir, entry)
        require(label, "waveamd-reg-alloc" not in entry_passes, "entry spells regalloc")
        require(
            label,
            "waveamd-insert-hazard-waits" not in entry_passes,
            "entry spells hazard waits",
        )
        finish_passes = applied_passes(ir, finish)
        try:
            ticket = finish_passes.index("waveamd-insert-ticket-waits")
            regalloc = finish_passes.index("waveamd-reg-alloc")
            hazard = finish_passes.index("waveamd-insert-hazard-waits")
        except ValueError as err:
            require(label, False, f"missing finish pass: {err}")
        require(label, ticket < regalloc < hazard, "finish pass order drifted")
    print(f"{label}: ok")


def main() -> int:
    matmul = load_module(
        "wave_matmul_calibrate",
        REPO_ROOT / "tools/wave-matmul-calibrate/wave-matmul-calibrate.py",
    )
    fa = load_module(
        "wave_fa_calibrate",
        REPO_ROOT / "tools/wave-fa-calibrate/wave-fa-calibrate.py",
    )
    check_calibration_entry("matmul_pipeline", matmul)
    check_calibration_entry("fa_pipeline", fa)
    try:
        matmul.parse_variants("pingpong")
    except argparse.ArgumentTypeError:
        print("matmul_pingpong_removed: ok")
        return 0
    print("matmul_pingpong_removed: still accepted", file=sys.stderr)
    return 1


if __name__ == "__main__":
    raise SystemExit(main())
