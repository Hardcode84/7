#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2026 wave-mlir contributors
#
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
"""Generate AMDGPU scheduler latency tables from LLVM SISchedule.td."""

from __future__ import annotations

import argparse
import difflib
import os
import re
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
SCHED_CLASS_H = REPO_ROOT / "include/mlir/Dialect/WaveAMDMachine/CostModel/SchedClass.h"
LATENCY_INC = REPO_ROOT / "lib/Dialect/WaveAMDMachine/CostModel/LatencyTable.inc"
FU_CPP = REPO_ROOT / "lib/Dialect/WaveAMDMachine/CostModel/FunctionalUnit.cpp"
SPDX_COPYRIGHT = "SPDX-FileCopyrightText"
SPDX_LICENSE = "SPDX-License-Identifier"

CLASS_TO_LLVM: dict[str, str | None] = {
    "NoInst": None,
    "WriteSALU": "WriteSALU",
    "Write32Bit": "Write32Bit",
    "Write64Bit": "Write64Bit",
    "WriteFloatFMA": "WriteFloatFMA",
    "WriteDouble": "WriteDouble",
    "WriteTrans32": "WriteTrans32",
    "WriteSFPU": "WriteSFPU",
    "Write2PassMAI": "Write2PassMAI",
    "Write4PassMAI": "Write4PassMAI",
    "Write8PassMAI": "Write8PassMAI",
    "Write16PassMAI": "Write16PassMAI",
    "WriteXDL2PassWMMA": None,
    "WriteXDL4PassWMMA": None,
    "Write4PassWMMA": None,
    "Write8PassWMMA": None,
    "Write16PassWMMA": None,
    "WriteVMEM": "WriteVMEM",
    "WriteSMEM": "WriteSMEM",
    "WriteLDS": "WriteLDS",
    "WriteBranch": "WriteBranch",
    "WriteBarrier": "WriteBarrier",
    "WriteExport": "WriteExport",
    "WaitcntPseudo": None,
}

UNBOUND_LATENCY_DEFAULTS: dict[str, int] = {
    "NoInst": 0,
    "WriteSFPU": 0,
    "Write2PassMAI": 2,
    "Write4PassMAI": 4,
    "Write8PassMAI": 8,
    "Write16PassMAI": 16,
    "WriteXDL2PassWMMA": 8,
    "WriteXDL4PassWMMA": 16,
    "Write4PassWMMA": 16,
    "Write8PassWMMA": 32,
    "Write16PassWMMA": 64,
    "WaitcntPseudo": 0,
}

LLVM_RES_TO_OURS: dict[str, str] = {
    "HWVALU": "VALU",
    "HWSALU": "SALU",
    "HWVMEM": "VMEM",
    "HWLGKM": "LGKM",
    "HWXDL": "MFMA_XDL",
    "HWTransVALU": "TRANS",
    "HWBranch": "BRANCH",
    "HWExport": "EXPORT",
}

ARCHES: tuple[tuple[str, tuple[int, int, int], str, bool], ...] = (
    ("Gfx942", (9, 4, 2), "SIDPGFX942FullSpeedModel", True),
    ("Gfx950", (9, 5, 0), "SIDPGFX950FullSpeedModel", True),
    ("Gfx1100", (11, 0, 0), "GFX11SpeedModel", False),
    ("Gfx1200", (12, 0, 0), "GFX12SpeedModel", False),
)

HWWRITERES_RE = re.compile(r"HWWriteRes<(\w+),\s*\[([^\]]*)\],\s*(\d+)>")
HWVALUWRITERES_RE = re.compile(r"HWVALUWriteRes<(\w+),\s*(\d+)>")


def find_sischedule_td() -> Path | None:
    candidates: list[Path] = []
    env = os.environ.get("LLVM_PROJECT_SOURCE_DIR")
    if env:
        candidates.append(Path(env) / "llvm/lib/Target/AMDGPU/SISchedule.td")
    candidates.append(
        REPO_ROOT / "build/_deps/llvm-project/llvm/lib/Target/AMDGPU/SISchedule.td"
    )
    return next((c for c in candidates if c.exists()), None)


def extract_braced_block(text: str, start: int) -> str:
    depth = 1
    i = start
    while i < len(text) and depth > 0:
        if text[i] == "{":
            depth += 1
        elif text[i] == "}":
            depth -= 1
        i += 1
    if depth != 0:
        raise ValueError("unbalanced braces in SISchedule.td block")
    return text[start : i - 1]


def primary_fu_from_resources(res_list_text: str) -> str | None:
    for resource in res_list_text.split(","):
        name = resource.strip()
        if name and name != "HWRC":
            return LLVM_RES_TO_OURS.get(name)
    return None


def parse_block(td_text: str, header_re: str) -> dict[str, dict[str, int | str | None]]:
    match = re.search(header_re, td_text)
    if not match:
        return {}
    body = extract_braced_block(td_text, match.end())
    result: dict[str, dict[str, int | str | None]] = {}
    for raw in body.splitlines():
        line = raw.split("//", 1)[0].strip()
        match = HWWRITERES_RE.search(line)
        if match:
            result[match.group(1)] = {
                "cycles": int(match.group(3)),
                "fu": primary_fu_from_resources(match.group(2)),
            }
            continue
        match = HWVALUWRITERES_RE.search(line)
        if match:
            result[match.group(1)] = {"cycles": int(match.group(2)), "fu": "VALU"}
    return result


def parse_td(path: Path) -> dict[str, dict[str, dict[str, int | str | None]]]:
    text = path.read_text()
    out = {"SICommonWriteRes": parse_block(text, r"multiclass\s+SICommonWriteRes\s*\{")}
    for model_name in {arch[2] for arch in ARCHES}:
        out[model_name] = parse_block(
            text, rf"let\s+SchedModel\s*=\s*{model_name}\s+in\s*\{{"
        )
    return out


def parse_sched_class_order(path: Path) -> list[str]:
    text = path.read_text()
    match = re.search(
        r"enum\s+class\s+SchedClass\s*:\s*uint8_t\s*\{(.*?)\};", text, re.S
    )
    if not match:
        raise ValueError(f"could not find SchedClass enum in {path}")
    names: list[str] = []
    for raw in match.group(1).splitlines():
        line = raw.split("//", 1)[0].strip().rstrip(",")
        if line and line != "NumSchedClasses":
            names.append(line)
    return names


def merged_td_entries(
    model_name: str, inherits: bool, td_tables: dict[str, dict[str, dict]]
) -> dict[str, dict]:
    entries: dict[str, dict] = {}
    if inherits:
        entries.update(td_tables["SICommonWriteRes"])
    entries.update(td_tables.get(model_name, {}))
    return entries


def latency_for_class(
    class_name: str, td_entries: dict[str, dict], arch_key: str
) -> int:
    llvm_class = CLASS_TO_LLVM[class_name]
    if llvm_class is not None and llvm_class in td_entries:
        return int(td_entries[llvm_class]["cycles"])
    if class_name in UNBOUND_LATENCY_DEFAULTS:
        return UNBOUND_LATENCY_DEFAULTS[class_name]
    raise ValueError(f"{arch_key}: no latency source for {class_name}")


def build_latency_tables(
    class_order: list[str], td_tables: dict[str, dict[str, dict]]
) -> dict[str, list[int]]:
    tables: dict[str, list[int]] = {}
    for arch_key, _, model_name, inherits in ARCHES:
        td_entries = merged_td_entries(model_name, inherits, td_tables)
        tables[arch_key] = [
            latency_for_class(class_name, td_entries, arch_key)
            for class_name in class_order
        ]
    return tables


def render_latency_inc(class_order: list[str], tables: dict[str, list[int]]) -> str:
    lines = [
        "//===- LatencyTable.inc - Generated AMDGPU latencies --------*- C++ -*-===//",
        "//",
        "// Part of the LLVM Project, under the Apache License v2.0 with LLVM",
        "// Exceptions. See https://llvm.org/LICENSE.txt for license information.",
        f"// {SPDX_COPYRIGHT}: 2026 wave-mlir contributors",
        f"// {SPDX_LICENSE}: Apache-2.0 WITH LLVM-exception",
        "//",
        "// Generated by build_tools/gen_sched_table.py from LLVM SISchedule.td.",
        "// Do not edit by hand.",
        "//",
        "//===----------------------------------------------------------------------===//",
        "",
    ]
    for arch_key, _, _, _ in ARCHES:
        lines.append(f"static constexpr ClassLatencies kLatency{arch_key} = {{")
        for class_name, value in zip(class_order, tables[arch_key], strict=True):
            lines.append(f"    /*{class_name}=*/{value},")
        lines.append("};")
        if arch_key != ARCHES[-1][0]:
            lines.append("")
    return "\n".join(lines)


def parse_cpp_table(
    path: Path, struct_name: str, entry_pattern: str
) -> dict[str, dict[str, str]]:
    text = path.read_text()
    table_re = re.compile(
        rf"static\s+constexpr\s+{struct_name}\s+k\w+Gfx(\w+)\s*=\s*\{{" r"([^}]*)\};",
        re.S,
    )
    out: dict[str, dict[str, str]] = {}
    for match in table_re.finditer(text):
        entries = {
            entry.group(1): entry.group(2)
            for entry in re.finditer(
                rf"/\*(\w+)=\*/\s*({entry_pattern})", match.group(2)
            )
        }
        out["Gfx" + match.group(1)] = entries
    alias_re = re.compile(
        rf"static\s+constexpr\s+{struct_name}\s+k\w+Gfx(\w+)\s*=\s*" r"k\w+Gfx(\w+);"
    )
    for match in alias_re.finditer(text):
        out["Gfx" + match.group(1)] = out["Gfx" + match.group(2)]
    return out


def parse_cpp_fus(path: Path) -> dict[str, dict[str, str]]:
    raw = parse_cpp_table(path, "ClassFUs", r"FunctionalUnit::\w+")
    return {
        arch: {k: v.removeprefix("FunctionalUnit::") for k, v in entries.items()}
        for arch, entries in raw.items()
    }


def check_fu_tables(td_tables: dict[str, dict[str, dict]]) -> list[str]:
    cpp_fu = parse_cpp_fus(FU_CPP)
    errors: list[str] = []
    for arch_key, _, model_name, inherits in ARCHES:
        if arch_key not in cpp_fu:
            errors.append(f"{arch_key}: missing FU table in {FU_CPP.name}")
            continue
        td_entries = merged_td_entries(model_name, inherits, td_tables)
        for our_class, llvm_class in CLASS_TO_LLVM.items():
            if llvm_class is None or llvm_class not in td_entries:
                continue
            expected = td_entries[llvm_class]["fu"]
            if expected is None:
                continue
            actual = cpp_fu[arch_key].get(our_class)
            if actual != expected:
                errors.append(
                    f"{arch_key}.{our_class}: FU cpp={actual}, "
                    f"SISchedule.td/{model_name}={expected}"
                )
    return errors


def diff_text(expected: str, actual: str, path: Path) -> str:
    return "".join(
        difflib.unified_diff(
            actual.splitlines(keepends=True),
            expected.splitlines(keepends=True),
            fromfile=str(path),
            tofile=f"{path} (generated)",
        )
    )


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--td", type=Path, default=None, help="SISchedule.td path")
    parser.add_argument("--output", type=Path, default=LATENCY_INC)
    parser.add_argument("--check", action="store_true", help="diff generated output")
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    td_path = args.td or find_sischedule_td()
    if td_path is None:
        print(
            "gen-sched-table: no LLVM source tree found "
            "(set LLVM_PROJECT_SOURCE_DIR or run build_tools/build_llvm.py); skipping.",
            file=sys.stderr,
        )
        return 0

    td_tables = parse_td(td_path)
    class_order = parse_sched_class_order(SCHED_CLASS_H)
    generated = render_latency_inc(
        class_order, build_latency_tables(class_order, td_tables)
    )
    generated += "\n"

    if not args.check:
        args.output.write_text(generated)
        return 0

    errors = check_fu_tables(td_tables)
    if not args.output.exists() or args.output.read_text() != generated:
        errors.append(
            f"{args.output} is stale; run python build_tools/gen_sched_table.py"
        )
        if args.output.exists():
            errors.append(diff_text(generated, args.output.read_text(), args.output))
    if errors:
        print(f"gen-sched-table: {len(errors)} error(s) vs {td_path}:", file=sys.stderr)
        for error in errors:
            print(error, file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
