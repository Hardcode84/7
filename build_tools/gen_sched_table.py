#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2026 wave-mlir contributors
#
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
"""Generate AMDGPU scheduler tables from LLVM scheduling data."""

from __future__ import annotations

import argparse
import difflib
import json
import os
import re
import subprocess
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
SCHED_CLASS_TD = (
    REPO_ROOT / "include/mlir/Dialect/WaveAMDMachine/CostModel/CostModelEnums.td"
)
LATENCY_INC = REPO_ROOT / "lib/Dialect/WaveAMDMachine/CostModel/LatencyTable.inc"
FU_INC = REPO_ROOT / "lib/Dialect/WaveAMDMachine/CostModel/FunctionalUnitTable.inc"
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
    "WriteXDL2PassWMMA": "WriteXDL2PassWMMA",
    "WriteXDL4PassWMMA": "WriteXDL4PassWMMA",
    "Write4PassWMMA": "Write4PassWMMA",
    "Write8PassWMMA": "Write8PassWMMA",
    "Write16PassWMMA": "Write16PassWMMA",
    "WriteVMEM": "WriteVMEM",
    "WriteSMEM": "WriteSMEM",
    "WriteLDS": "WriteLDS",
    "WriteBranch": "WriteBranch",
    "WriteBarrier": "WriteBarrier",
    "WriteExport": "WriteExport",
    "WaitcntPseudo": None,
}

WAVE_PSEUDO_CLASSES = frozenset(("NoInst", "WaitcntPseudo"))

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
FUNCTIONAL_UNITS = frozenset((*LLVM_RES_TO_OURS.values(), "None"))

LEGACY_ARCHES: tuple[tuple[str, tuple[int, int, int], str, tuple[str, ...]], ...] = (
    ("Gfx942", (9, 4, 2), "SIDPGFX942FullSpeedModel", ("SICommonWriteRes",)),
    ("Gfx950", (9, 5, 0), "SIDPGFX950FullSpeedModel", ("SICommonWriteRes",)),
    ("Gfx1100", (11, 0, 0), "GFX11SpeedModel", ()),
    ("Gfx1200", (12, 0, 0), "GFX12SpeedModel", ()),
)
QUERY_ARCH_KEY = "Gfx1250"
QUERY_CHIP = "gfx1250"
ARCH_KEYS = (*tuple(arch[0] for arch in LEGACY_ARCHES), QUERY_ARCH_KEY)

HWWRITERES_RE = re.compile(r"HWWriteRes<(\w+),\s*\[([^\]]*)\],\s*(\d+)>")
HWVALUWRITERES_RE = re.compile(r"HWVALUWriteRes<(\w+),\s*(\d+)>")
RELEASE_AT_CYCLES_RE = re.compile(r"let\s+ReleaseAtCycles\s*=\s*\[([^\]]*)\]\s+in")


def find_sischedule_td() -> Path | None:
    candidates: list[Path] = []
    env = os.environ.get("LLVM_PROJECT_SOURCE_DIR")
    if env:
        candidates.append(Path(env) / "llvm/lib/Target/AMDGPU/SISchedule.td")
    candidates.append(
        REPO_ROOT / "build/_deps/llvm-project/llvm/lib/Target/AMDGPU/SISchedule.td"
    )
    return next((c for c in candidates if c.exists()), None)


def executable_file(path: Path) -> Path | None:
    return path if path.is_file() and os.access(path, os.X_OK) else None


def find_schedule_query_tool(explicit: Path | None) -> Path | None:
    if explicit:
        return executable_file(explicit)
    env_tool = os.environ.get("WAVE_SCHED_QUERY_TOOL")
    if env_tool:
        return executable_file(Path(env_tool))
    candidates: list[Path] = []
    build_dir = os.environ.get("WAVE_BUILD_DIR")
    if build_dir:
        candidates.append(Path(build_dir) / "bin/wave-target-info")
    candidates.append(REPO_ROOT / "build/bin/wave-target-info")
    for candidate in candidates:
        tool = executable_file(candidate)
        if tool:
            return tool
    return None


def stale_default_query_inputs(tool: Path, td_path: Path) -> list[Path]:
    default_tool = REPO_ROOT / "build/bin/wave-target-info"
    if tool.resolve() != default_tool.resolve():
        return []
    inputs = (
        td_path,
        SCHED_CLASS_TD,
        REPO_ROOT / "include/mlir/Dialect/WaveAMDMachine/CMakeLists.txt",
        REPO_ROOT / "include/mlir/Dialect/WaveAMDMachine/CostModel/CMakeLists.txt",
        REPO_ROOT / "include/mlir/Dialect/WaveAMDMachine/CostModel/CostModelEnums.h",
        REPO_ROOT / "include/mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTarget.h",
        REPO_ROOT / "lib/Dialect/WaveAMDMachine/IR/WaveAMDMachineTarget.cpp",
        REPO_ROOT / "tools/wave-target-info/CMakeLists.txt",
        REPO_ROOT / "tools/wave-target-info/wave-target-info.cpp",
    )
    tool_mtime = tool.stat().st_mtime
    return [
        path for path in inputs if path.exists() and path.stat().st_mtime > tool_mtime
    ]


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


def resource_cycles_for_primary(
    res_list_text: str, release_at_cycles: list[int] | None
) -> int:
    for index, resource in enumerate(res_list_text.split(",")):
        name = resource.strip()
        if name and name != "HWRC" and name in LLVM_RES_TO_OURS:
            if release_at_cycles is not None and index < len(release_at_cycles):
                return release_at_cycles[index]
            return 1
    return 1


def parse_block(td_text: str, header_re: str) -> dict[str, dict[str, int | str | None]]:
    match = re.search(header_re, td_text)
    if not match:
        return {}
    body = extract_braced_block(td_text, match.end())
    result: dict[str, dict[str, int | str | None]] = {}
    release_at_cycles: list[int] | None = None
    for raw in body.splitlines():
        line = raw.split("//", 1)[0].strip()
        release_match = RELEASE_AT_CYCLES_RE.search(line)
        if release_match:
            values = release_match.group(1).strip()
            release_at_cycles = (
                [int(value.strip()) for value in values.split(",")] if values else []
            )
            line = line[release_match.end() :].strip()
        match = HWWRITERES_RE.search(line)
        if match:
            result[match.group(1)] = {
                "cycles": int(match.group(3)),
                "fu": primary_fu_from_resources(match.group(2)),
                "resource_cycles": resource_cycles_for_primary(
                    match.group(2), release_at_cycles
                ),
            }
            release_at_cycles = None
            continue
        match = HWVALUWRITERES_RE.search(line)
        if match:
            result[match.group(1)] = {
                "cycles": int(match.group(2)),
                "fu": "VALU",
                "resource_cycles": release_at_cycles[0] if release_at_cycles else 1,
            }
            release_at_cycles = None
    return result


def parse_td(path: Path) -> dict[str, dict[str, dict[str, int | str | None]]]:
    text = path.read_text()
    common_tables = {name for arch in LEGACY_ARCHES for name in arch[3]}
    out = {
        name: parse_block(text, rf"multiclass\s+{name}\s*\{{") for name in common_tables
    }
    for model_name in {arch[2] for arch in LEGACY_ARCHES}:
        out[model_name] = parse_block(
            text, rf"let\s+SchedModel\s*=\s*{model_name}\s+in\s*\{{"
        )
    return out


def parse_sched_class_order(path: Path) -> list[str]:
    text = path.read_text()
    sched_records = text.split("def SchedClassEnum", 1)[0]
    entries = [
        (int(match.group(2)), match.group(1))
        for match in re.finditer(
            r'I32EnumCase<"(\w+)",\s*(\d+),\s*"[^"]+">', sched_records
        )
        if match.group(1) != "NumSchedClasses"
    ]
    if not entries:
        raise ValueError(f"could not find SchedClass cases in {path}")
    entries.sort()
    if [value for value, _ in entries] != list(range(len(entries))):
        raise ValueError(f"SchedClass values are not contiguous in {path}")
    return [name for _, name in entries]


def merged_td_entries(
    model_name: str,
    inherited_tables: tuple[str, ...],
    td_tables: dict[str, dict[str, dict]],
) -> dict[str, dict]:
    entries: dict[str, dict] = {}
    for table_name in inherited_tables:
        table = td_tables.get(table_name)
        if not table:
            raise ValueError(f"missing or empty LLVM multiclass {table_name}")
        entries.update(table)
    entries.update(td_tables.get(model_name, {}))
    return entries


def is_class_supported(class_name: str, td_entries: dict[str, dict]) -> bool:
    if class_name in WAVE_PSEUDO_CLASSES:
        return True
    llvm_class = CLASS_TO_LLVM[class_name]
    return (
        llvm_class is not None
        and llvm_class in td_entries
        and td_entries[llvm_class]["fu"] is not None
    )


def latency_for_class(class_name: str, td_entries: dict[str, dict]) -> int:
    if class_name in WAVE_PSEUDO_CLASSES:
        return 0
    llvm_class = CLASS_TO_LLVM[class_name]
    if llvm_class is None or not is_class_supported(class_name, td_entries):
        return 0
    return int(td_entries[llvm_class]["cycles"])


def build_latency_tables(
    class_order: list[str], td_tables: dict[str, dict[str, dict]]
) -> dict[str, list[int]]:
    tables: dict[str, list[int]] = {}
    for arch_key, _, model_name, inherited_tables in LEGACY_ARCHES:
        td_entries = merged_td_entries(model_name, inherited_tables, td_tables)
        tables[arch_key] = [
            latency_for_class(class_name, td_entries) for class_name in class_order
        ]
    return tables


def resource_cycles_for_class(class_name: str, td_entries: dict[str, dict]) -> int:
    if class_name in WAVE_PSEUDO_CLASSES:
        return 0
    llvm_class = CLASS_TO_LLVM[class_name]
    if llvm_class is None or not is_class_supported(class_name, td_entries):
        return 0
    return int(td_entries[llvm_class]["resource_cycles"])


def build_resource_cycle_tables(
    class_order: list[str], td_tables: dict[str, dict[str, dict]]
) -> dict[str, list[int]]:
    tables: dict[str, list[int]] = {}
    for arch_key, _, model_name, inherited_tables in LEGACY_ARCHES:
        td_entries = merged_td_entries(model_name, inherited_tables, td_tables)
        tables[arch_key] = [
            resource_cycles_for_class(class_name, td_entries)
            for class_name in class_order
        ]
    return tables


def render_latency_inc(
    class_order: list[str],
    latency_tables: dict[str, list[int]],
    resource_cycle_tables: dict[str, list[int]],
    support_tables: dict[str, list[bool]],
) -> str:
    lines = [
        "//===- LatencyTable.inc - Generated AMDGPU latencies --------*- C++ -*-===//",
        "//",
        "// Part of the LLVM Project, under the Apache License v2.0 with LLVM",
        "// Exceptions. See https://llvm.org/LICENSE.txt for license information.",
        f"// {SPDX_COPYRIGHT}: 2026 wave-mlir contributors",
        f"// {SPDX_LICENSE}: Apache-2.0 WITH LLVM-exception",
        "//",
        "// Generated by build_tools/gen_sched_table.py from LLVM schedule data.",
        "// Do not edit by hand.",
        "//",
        "//===----------------------------------------------------------------------===//",
        "",
    ]
    for arch_key in ARCH_KEYS:
        lines.append(f"static constexpr ClassCycles kLatency{arch_key} = {{")
        for class_name, value in zip(
            class_order, latency_tables[arch_key], strict=True
        ):
            lines.append(f"    /*{class_name}=*/{value},")
        lines.append("};")
        lines.append("")
        lines.append(f"static constexpr ClassCycles kResourceCycles{arch_key} = {{")
        for class_name, value in zip(
            class_order, resource_cycle_tables[arch_key], strict=True
        ):
            lines.append(f"    /*{class_name}=*/{value},")
        lines.append("};")
        lines.append("")
        lines.append(f"static constexpr ClassSupport kSupported{arch_key} = {{")
        for class_name, value in zip(
            class_order, support_tables[arch_key], strict=True
        ):
            lines.append(f"    /*{class_name}=*/{'true' if value else 'false'},")
        lines.append("};")
        if arch_key != ARCH_KEYS[-1]:
            lines.append("")
    return "\n".join(lines)


def fu_for_class(class_name: str, td_entries: dict[str, dict]) -> str:
    if class_name in WAVE_PSEUDO_CLASSES:
        return "None"
    llvm_class = CLASS_TO_LLVM[class_name]
    if llvm_class is None or not is_class_supported(class_name, td_entries):
        return "None"
    return str(td_entries[llvm_class]["fu"])


def build_fu_tables(
    class_order: list[str], td_tables: dict[str, dict[str, dict]]
) -> dict[str, list[str]]:
    tables: dict[str, list[str]] = {}
    for arch_key, _, model_name, inherited_tables in LEGACY_ARCHES:
        td_entries = merged_td_entries(model_name, inherited_tables, td_tables)
        tables[arch_key] = [
            fu_for_class(class_name, td_entries) for class_name in class_order
        ]
    return tables


def build_support_tables(
    class_order: list[str], td_tables: dict[str, dict[str, dict]]
) -> dict[str, list[bool]]:
    tables: dict[str, list[bool]] = {}
    for arch_key, _, model_name, inherited_tables in LEGACY_ARCHES:
        td_entries = merged_td_entries(model_name, inherited_tables, td_tables)
        tables[arch_key] = [
            is_class_supported(class_name, td_entries) for class_name in class_order
        ]
    return tables


def load_schedule_manifest(tool: Path, chip: str) -> dict:
    command = [str(tool), "--schedule-model", "--json", chip]
    result = subprocess.run(command, capture_output=True, text=True, check=False)
    if result.returncode != 0:
        detail = result.stderr.strip() or result.stdout.strip()
        raise ValueError(f"{tool} schedule query failed: {detail}")
    try:
        manifest = json.loads(result.stdout)
    except json.JSONDecodeError as exc:
        raise ValueError(f"{tool} returned invalid schedule JSON: {exc}") from exc
    if not isinstance(manifest, dict):
        raise ValueError(f"{tool} schedule JSON root is not an object")
    return manifest


def is_integer(value: object) -> bool:
    return isinstance(value, int) and not isinstance(value, bool)


def get_raw_schedule_classes(tool: Path, chip: str, manifest: dict) -> list:
    if manifest.get("target") != chip:
        raise ValueError(
            f"{tool} schedule target is {manifest.get('target')!r}, "
            f"expected {chip!r}"
        )
    issue_width = manifest.get("issue_width")
    if not is_integer(issue_width) or issue_width <= 0:
        raise ValueError(f"{tool} returned invalid schedule issue width")
    raw_classes = manifest.get("classes")
    if not isinstance(raw_classes, list):
        raise ValueError(f"{tool} schedule JSON has no class list")
    return raw_classes


def index_schedule_classes(
    tool: Path, raw_classes: list, class_order: list[str]
) -> dict[str, dict]:
    by_name: dict[str, dict] = {}
    for entry in raw_classes:
        if not isinstance(entry, dict) or not isinstance(entry.get("name"), str):
            raise ValueError(f"{tool} returned an invalid schedule class entry")
        name = entry["name"]
        if name in by_name:
            raise ValueError(f"{tool} returned duplicate schedule class {name}")
        by_name[name] = entry
    missing = sorted(set(class_order) - by_name.keys())
    extra = sorted(by_name.keys() - set(class_order))
    if missing or extra:
        raise ValueError(
            f"{tool} schedule class mismatch; missing={missing}, extra={extra}"
        )
    return by_name


def get_schedule_numbers(tool: Path, name: str, entry: dict) -> tuple[int, int, str]:
    latency = entry.get("latency")
    cycles = entry.get("resource_cycles")
    functional_unit = entry.get("functional_unit")
    if not is_integer(latency) or latency < 0:
        raise ValueError(f"{tool} returned invalid latency for {name}")
    if not is_integer(cycles) or cycles < 0:
        raise ValueError(f"{tool} returned invalid resource cycles for {name}")
    if functional_unit not in FUNCTIONAL_UNITS:
        raise ValueError(f"{tool} returned invalid functional unit for {name}")
    return latency, cycles, functional_unit


def is_valid_schedule_resource(resource: object) -> bool:
    if not isinstance(resource, dict):
        return False
    if not isinstance(resource.get("name"), str):
        return False
    acquire = resource.get("acquire")
    release = resource.get("release")
    if not is_integer(acquire) or not is_integer(release):
        return False
    return release >= acquire


def get_schedule_lists(tool: Path, name: str, entry: dict) -> tuple[list[str], list]:
    opcodes = entry.get("opcodes")
    resources = entry.get("resources")
    if not isinstance(opcodes, list) or not all(
        isinstance(opcode, str) for opcode in opcodes
    ):
        raise ValueError(f"{tool} returned invalid opcodes for {name}")
    if not isinstance(resources, list):
        raise ValueError(f"{tool} returned invalid resources for {name}")
    if not all(is_valid_schedule_resource(resource) for resource in resources):
        raise ValueError(f"{tool} returned invalid resource for {name}")
    return opcodes, resources


def validate_schedule_source(
    tool: Path, name: str, entry: dict, opcodes: list[str], resources: list
) -> None:
    source = entry.get("source")
    if name in ("NoInst", "WaitcntPseudo"):
        if source != "wave-pseudo" or opcodes or resources:
            raise ValueError(f"{tool} returned invalid Wave pseudo {name}")
        return
    if source != "llvm-mc" or not opcodes or not resources:
        raise ValueError(f"{tool} returned incomplete LLVM schedule for {name}")


def get_schedule_class(
    tool: Path, name: str, entry: dict
) -> tuple[int, int, str, bool]:
    supported = entry.get("supported")
    if not isinstance(supported, bool):
        raise ValueError(f"{tool} returned invalid support state for {name}")
    if not supported:
        return 0, 0, "None", False
    latency, cycles, functional_unit = get_schedule_numbers(tool, name, entry)
    opcodes, resources = get_schedule_lists(tool, name, entry)
    validate_schedule_source(tool, name, entry, opcodes, resources)
    return latency, cycles, functional_unit, True


def query_schedule(
    tool: Path, chip: str, class_order: list[str]
) -> tuple[list[int], list[int], list[str], list[bool]]:
    manifest = load_schedule_manifest(tool, chip)
    raw_classes = get_raw_schedule_classes(tool, chip, manifest)
    by_name = index_schedule_classes(tool, raw_classes, class_order)
    schedules = [get_schedule_class(tool, name, by_name[name]) for name in class_order]
    latencies = [schedule[0] for schedule in schedules]
    resource_cycles = [schedule[1] for schedule in schedules]
    functional_units = [schedule[2] for schedule in schedules]
    supported_classes = [schedule[3] for schedule in schedules]
    return latencies, resource_cycles, functional_units, supported_classes


def merge_mc_fallback(
    arch_key: str,
    class_order: list[str],
    queried: tuple[list[int], list[int], list[str], list[bool]],
    latency_tables: dict[str, list[int]],
    resource_cycle_tables: dict[str, list[int]],
    fu_tables: dict[str, list[str]],
    support_tables: dict[str, list[bool]],
) -> None:
    queried_latencies, queried_cycles, queried_fus, queried_support = queried
    for index, class_name in enumerate(class_order):
        if not queried_support[index]:
            continue
        if support_tables[arch_key][index]:
            source = (
                latency_tables[arch_key][index],
                resource_cycle_tables[arch_key][index],
                fu_tables[arch_key][index],
            )
            direct = (
                queried_latencies[index],
                queried_cycles[index],
                queried_fus[index],
            )
            if source != direct:
                raise ValueError(
                    f"{arch_key} {class_name} LLVM source and MC schedules "
                    f"disagree: source={source}, mc={direct}"
                )
            continue
        latency_tables[arch_key][index] = queried_latencies[index]
        resource_cycle_tables[arch_key][index] = queried_cycles[index]
        fu_tables[arch_key][index] = queried_fus[index]
        support_tables[arch_key][index] = True


def render_fu_inc(class_order: list[str], fu_tables: dict[str, list[str]]) -> str:
    lines = [
        "//===- FunctionalUnitTable.inc - Generated AMDGPU FUs -------*- C++ -*-===//",
        "//",
        "// Part of the LLVM Project, under the Apache License v2.0 with LLVM",
        "// Exceptions. See https://llvm.org/LICENSE.txt for license information.",
        f"// {SPDX_COPYRIGHT}: 2026 wave-mlir contributors",
        f"// {SPDX_LICENSE}: Apache-2.0 WITH LLVM-exception",
        "//",
        "// Generated by build_tools/gen_sched_table.py from LLVM schedule data.",
        "// Do not edit by hand.",
        "//",
        "//===----------------------------------------------------------------------===//",
        "",
    ]
    for arch_key in ARCH_KEYS:
        lines.append(f"static constexpr ClassFUs kFUs{arch_key} = {{")
        for class_name, value in zip(class_order, fu_tables[arch_key], strict=True):
            lines.append(f"    /*{class_name}=*/FunctionalUnit::{value},")
        lines.append("};")
        if arch_key != ARCH_KEYS[-1]:
            lines.append("")
    return "\n".join(lines)


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
    parser.add_argument(
        "--query-tool",
        type=Path,
        default=None,
        help="wave-target-info binary for direct LLVM MC schedule queries",
    )
    parser.add_argument("--output", type=Path, default=LATENCY_INC)
    parser.add_argument("--fu-output", type=Path, default=FU_INC)
    parser.add_argument("--check", action="store_true", help="diff generated output")
    return parser.parse_args()


def resolve_generation_inputs(
    args: argparse.Namespace,
) -> tuple[Path, Path] | None:
    td_path = args.td or find_sischedule_td()
    if td_path is None:
        print(
            "gen-sched-table: no LLVM source tree found "
            "(set LLVM_PROJECT_SOURCE_DIR or run build_tools/build_llvm.py)",
            file=sys.stderr,
        )
        return None
    query_tool = find_schedule_query_tool(args.query_tool)
    if query_tool is None:
        print(
            "gen-sched-table: wave-target-info not found; build it with "
            "`cmake --build build --target wave-target-info`, pass "
            "`--query-tool`, or set WAVE_SCHED_QUERY_TOOL",
            file=sys.stderr,
        )
        return None
    stale_inputs = stale_default_query_inputs(query_tool, td_path)
    if stale_inputs:
        paths = ", ".join(str(path.relative_to(REPO_ROOT)) for path in stale_inputs)
        print(
            "gen-sched-table: build/bin/wave-target-info is stale relative to "
            f"{paths}; rebuild with "
            "`cmake --build build --target wave-target-info`",
            file=sys.stderr,
        )
        return None
    return td_path, query_tool


def build_schedule_tables(td_path: Path, query_tool: Path) -> tuple[
    list[str],
    dict[str, list[int]],
    dict[str, list[int]],
    dict[str, list[str]],
    dict[str, list[bool]],
]:
    td_tables = parse_td(td_path)
    class_order = parse_sched_class_order(SCHED_CLASS_TD)
    latency_tables = build_latency_tables(class_order, td_tables)
    resource_cycle_tables = build_resource_cycle_tables(class_order, td_tables)
    fu_tables = build_fu_tables(class_order, td_tables)
    support_tables = build_support_tables(class_order, td_tables)
    for arch_key, _, _, _ in LEGACY_ARCHES:
        merge_mc_fallback(
            arch_key,
            class_order,
            query_schedule(query_tool, arch_key.lower(), class_order),
            latency_tables,
            resource_cycle_tables,
            fu_tables,
            support_tables,
        )
    (
        latency_tables[QUERY_ARCH_KEY],
        resource_cycle_tables[QUERY_ARCH_KEY],
        fu_tables[QUERY_ARCH_KEY],
        gfx1250_support,
    ) = query_schedule(query_tool, QUERY_CHIP, class_order)
    support_tables[QUERY_ARCH_KEY] = gfx1250_support
    return (
        class_order,
        latency_tables,
        resource_cycle_tables,
        fu_tables,
        support_tables,
    )


def render_schedule_outputs(
    class_order: list[str],
    latency_tables: dict[str, list[int]],
    resource_cycle_tables: dict[str, list[int]],
    fu_tables: dict[str, list[str]],
    support_tables: dict[str, list[bool]],
) -> tuple[str, str]:
    generated = render_latency_inc(
        class_order,
        latency_tables,
        resource_cycle_tables,
        support_tables,
    )
    generated += "\n"
    generated_fu = render_fu_inc(class_order, fu_tables)
    generated_fu += "\n"
    return generated, generated_fu


def check_generated_file(path: Path, generated: str) -> list[str]:
    errors: list[str] = []
    if not path.exists() or path.read_text() != generated:
        errors.append(f"{path} is stale; run python build_tools/gen_sched_table.py")
        if path.exists():
            errors.append(diff_text(generated, path.read_text(), path))
    return errors


def write_or_check_outputs(
    args: argparse.Namespace, generated: str, generated_fu: str
) -> int:
    if not args.check:
        args.output.write_text(generated)
        args.fu_output.write_text(generated_fu)
        return 0

    errors = check_generated_file(args.output, generated)
    errors.extend(check_generated_file(args.fu_output, generated_fu))
    if not errors:
        return 0
    print(
        f"gen-sched-table: {len(errors)} error(s) vs LLVM schedule data:",
        file=sys.stderr,
    )
    for error in errors:
        print(error, file=sys.stderr)
    return 1


def main() -> int:
    args = parse_args()
    inputs = resolve_generation_inputs(args)
    if inputs is None:
        return 1
    try:
        tables = build_schedule_tables(*inputs)
    except (OSError, ValueError) as exc:
        print(f"gen-sched-table: {exc}", file=sys.stderr)
        return 1
    generated, generated_fu = render_schedule_outputs(*tables)
    return write_or_check_outputs(args, generated, generated_fu)


if __name__ == "__main__":
    sys.exit(main())
