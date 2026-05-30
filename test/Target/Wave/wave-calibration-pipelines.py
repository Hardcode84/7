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


def check_finish_order(label: str, text: str) -> None:
    finish = text.split("transform.named_sequence @waveamd_backend_finish", 1)[1]
    finish = finish.split("transform.named_sequence @waveamd_backend_unscheduled", 1)[0]
    ticket = finish.find('"waveamd-insert-ticket-waits"')
    regalloc = finish.find('"waveamd-reg-alloc"')
    hazard = finish.find('"waveamd-insert-hazard-waits"')
    require(label, ticket >= 0, "missing ticket waits")
    require(label, regalloc >= 0, "missing regalloc")
    require(label, hazard >= 0, "missing hazard waits")
    require(label, ticket < regalloc < hazard, "finish pass order drifted")


def check_calibration_entry(label: str, module) -> None:
    text = module.pipeline_text(
        BUILD_DIR,
        schedule_options={"apply-schedule": True, "pressure-aware-selection": True},
        report_options={"print-candidates": True},
    )
    entry = text.split("transform.named_sequence @__transform_main", 1)[1]
    require(
        label, "transform.include @waveamd_backend_lower" in entry, "no lower include"
    )
    require(
        label, "transform.include @waveamd_backend_finish" in entry, "no finish include"
    )
    require(label, '"waveamd-reg-alloc"' not in entry, "entry spells regalloc")
    require(
        label, '"waveamd-insert-hazard-waits"' not in entry, "entry spells hazard waits"
    )
    check_finish_order(label, text)
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
