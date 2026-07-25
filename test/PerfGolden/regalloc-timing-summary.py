# RUN: %python %s %S/../../build_tools/measure_regalloc_stage_timing.py | FileCheck %s

# CHECK-LABEL: stage,baseline_runs{{.*}},delta_pct
# CHECK-NEXT: wave_regalloc_transform_stages,{{.*}},+0.0000,n/a
# CHECK-NEXT: regalloc_build_alias_state,{{.*}},+0.1000,n/a
# CHECK-NEXT: regalloc_linear_scan,{{.*}},+0.1000,+100.00%

# SPDX-FileCopyrightText: 2026 wave-mlir contributors
#
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

from __future__ import annotations

import importlib.util
import sys
from pathlib import Path


def load_module(path: Path):
    spec = importlib.util.spec_from_file_location("regalloc_timing", path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot load {path}")
    timing = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = timing
    spec.loader.exec_module(timing)
    return timing


timing = load_module(Path(sys.argv[1]))
tools = [
    timing.TimingTool("baseline", Path("baseline")),
    timing.TimingTool("candidate", Path("candidate")),
]
values = [(0.0, 0.0), (0.0, 0.1), (0.1, 0.2)]
values.extend([(1.0, 1.0)] * (len(timing.STAGES) - len(values)))
samples = [
    timing.TimingSample(label, 0, stage, seconds)
    for stage, pair in zip(timing.STAGES, values, strict=True)
    for label, seconds in zip(("baseline", "candidate"), pair, strict=True)
]
timing.print_summary(samples, tools)
