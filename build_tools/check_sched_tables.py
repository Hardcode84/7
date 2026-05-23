#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2026 wave-mlir contributors
#
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
"""Sched-table divergence detector.

Parses LLVM's ``SISchedule.td`` (from
``build/_deps/llvm-project`` or ``$LLVM_PROJECT_SOURCE_DIR``)
and our two hand-copied tables:

* ``lib/Dialect/WaveAMDMachine/CostModel/LatencyTable.cpp``
* ``lib/Dialect/WaveAMDMachine/CostModel/FunctionalUnit.cpp``

Verifies that every (arch, SchedClass) cycle count + primary
functional-unit binding matches what LLVM's HWWriteRes /
HWVALUWriteRes lines actually say.

Skips classes LLVM does not bind for a given model (e.g. WMMA on
CDNA, MAI on RDNA) and pseudo SchedClasses with no LLVM
equivalent (``NoInst``, ``WaitcntPseudo``).

Exit codes:
    0  every bound (arch, class) matches LLVM (or no LLVM source).
    1  at least one (arch, class) value diverges.

If no LLVM source tree is reachable the script returns 0 with a
note on stderr; contributors without an LLVM checkout still get
clean pre-commit runs.
"""

from __future__ import annotations

import os
import re
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
LATENCY_CPP = REPO_ROOT / "lib/Dialect/WaveAMDMachine/CostModel/LatencyTable.cpp"
FU_CPP = REPO_ROOT / "lib/Dialect/WaveAMDMachine/CostModel/FunctionalUnit.cpp"

# Map our internal SchedClass enum name to upstream LLVM SchedWrite
# name. None = pseudo / no LLVM equivalent / not bound on any arch
# we care about; the script skips comparison for those.
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
    "WriteXDL2PassWMMA": None,  # only gfx1250 binds.
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

# LLVM resource enum -> our FunctionalUnit enum.
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

# Map our arch suffix (kLatency/kFUsGfxNNN) to (LLVM SchedModel
# name, inherits SICommonWriteRes?). CDNA models start from the
# common defaults; GFX10+ models are self-contained.
ARCH_MODEL: dict[str, tuple[str, bool]] = {
    "Gfx942": ("SIDPGFX942FullSpeedModel", True),
    "Gfx950": ("SIDPGFX950FullSpeedModel", True),
    "Gfx1100": ("GFX11SpeedModel", False),
    "Gfx1200": ("GFX12SpeedModel", False),
}

# HWWriteRes<Class, [resources], cycles>.
HWWRITERES_RE = re.compile(r"HWWriteRes<(\w+),\s*\[([^\]]*)\],\s*(\d+)>")
# HWVALUWriteRes<Class, cycles> -- implicit HWVALU resource.
HWVALUWRITERES_RE = re.compile(r"HWVALUWriteRes<(\w+),\s*(\d+)>")


def find_sischedule_td() -> Path | None:
    candidates: list[Path] = []
    env = os.environ.get("LLVM_PROJECT_SOURCE_DIR")
    if env:
        candidates.append(Path(env) / "llvm/lib/Target/AMDGPU/SISchedule.td")
    candidates.append(
        REPO_ROOT / "build/_deps/llvm-project/llvm/lib/Target/AMDGPU/SISchedule.td"
    )
    for c in candidates:
        if c.exists():
            return c
    return None


def extract_braced_block(text: str, start: int) -> str:
    """From an opening brace at ``text[start-1]``, return the
    contents up to (but not including) the matching close brace."""
    depth = 1
    i = start
    while i < len(text) and depth > 0:
        c = text[i]
        if c == "{":
            depth += 1
        elif c == "}":
            depth -= 1
        i += 1
    if depth != 0:
        raise ValueError("unbalanced braces in SISchedule.td block")
    return text[start : i - 1]


def primary_fu_from_resources(res_list_text: str) -> str | None:
    """Pick the primary FU from a comma-separated resource list.
    HWRC is the register-cache port and is always secondary."""
    for r in res_list_text.split(","):
        name = r.strip()
        if name and name != "HWRC":
            return LLVM_RES_TO_OURS.get(name)
    return None


def parse_block(td_text: str, header_re: str) -> dict[str, dict]:
    """Parse one ``multiclass`` or ``let SchedModel = X in`` block
    and return {SchedWrite: {"cycles": int, "fu": str | None}}.
    Later writes win on duplicates (LLVM's let-override semantics)."""
    m = re.search(header_re, td_text)
    if not m:
        return {}
    body = extract_braced_block(td_text, m.end())
    result: dict[str, dict] = {}
    for raw in body.splitlines():
        line = raw.split("//", 1)[0].strip()
        mm = HWWRITERES_RE.search(line)
        if mm:
            result[mm.group(1)] = {
                "cycles": int(mm.group(3)),
                "fu": primary_fu_from_resources(mm.group(2)),
            }
            continue
        mm = HWVALUWRITERES_RE.search(line)
        if mm:
            result[mm.group(1)] = {
                "cycles": int(mm.group(2)),
                "fu": "VALU",
            }
    return result


def parse_td(path: Path) -> dict[str, dict[str, dict]]:
    text = path.read_text()
    out: dict[str, dict[str, dict]] = {
        "SICommonWriteRes": parse_block(text, r"multiclass\s+SICommonWriteRes\s*\{")
    }
    seen_models: set[str] = set()
    for model_name, _ in ARCH_MODEL.values():
        if model_name in seen_models:
            continue
        seen_models.add(model_name)
        out[model_name] = parse_block(
            text, rf"let\s+SchedModel\s*=\s*{model_name}\s+in\s*\{{"
        )
    return out


def parse_cpp_table(
    path: Path, struct_name: str, entry_pattern: str
) -> dict[str, dict[str, str]]:
    """Parse per-arch tables from a CostModel cpp file. Returns
    {arch: {SchedClass: raw_value_text}}. Handles aliases like
    ``kLatencyGfx950 = kLatencyGfx942``."""
    text = path.read_text()
    out: dict[str, dict[str, str]] = {}
    table_re = re.compile(
        rf"static\s+constexpr\s+{struct_name}\s+k\w+Gfx(\w+)\s*=\s*\{{" r"([^}]*)\};",
        re.DOTALL,
    )
    for m in table_re.finditer(text):
        arch = "Gfx" + m.group(1)
        body = m.group(2)
        entries: dict[str, str] = {}
        for em in re.finditer(rf"/\*(\w+)=\*/\s*({entry_pattern})", body):
            entries[em.group(1)] = em.group(2)
        out[arch] = entries
    alias_re = re.compile(
        rf"static\s+constexpr\s+{struct_name}\s+k\w+Gfx(\w+)\s*=\s*" r"k\w+Gfx(\w+);"
    )
    for m in alias_re.finditer(text):
        out["Gfx" + m.group(1)] = out["Gfx" + m.group(2)]
    return out


def parse_cpp_latencies(path: Path) -> dict[str, dict[str, int]]:
    raw = parse_cpp_table(path, "ClassLatencies", r"\d+")
    return {
        arch: {k: int(v) for k, v in entries.items()} for arch, entries in raw.items()
    }


def parse_cpp_fus(path: Path) -> dict[str, dict[str, str]]:
    raw = parse_cpp_table(path, "ClassFUs", r"FunctionalUnit::\w+")
    out: dict[str, dict[str, str]] = {}
    for arch, entries in raw.items():
        out[arch] = {k: v.removeprefix("FunctionalUnit::") for k, v in entries.items()}
    return out


def check_latency_entry(
    arch_key: str,
    model_name: str,
    our_class: str,
    expected: int,
    cpp_lat: dict[str, int],
) -> list[str]:
    actual = cpp_lat.get(our_class)
    if actual is None:
        return [f"{arch_key}: missing latency entry for {our_class}"]
    if actual != expected:
        return [
            f"{arch_key}.{our_class}: latency cpp={actual}, "
            f"SISchedule.td/{model_name}={expected}"
        ]
    return []


def check_fu_entry(
    arch_key: str,
    model_name: str,
    our_class: str,
    expected: str,
    cpp_fu: dict[str, str],
) -> list[str]:
    actual = cpp_fu.get(our_class)
    if actual is None:
        return [f"{arch_key}: missing FU entry for {our_class}"]
    if actual != expected:
        return [
            f"{arch_key}.{our_class}: FU cpp={actual}, "
            f"SISchedule.td/{model_name}={expected}"
        ]
    return []


def check_arch(
    arch_key: str,
    model_name: str,
    inherits: bool,
    cpp_lat: dict[str, dict[str, int]],
    cpp_fu: dict[str, dict[str, str]],
    td_tables: dict[str, dict[str, dict]],
) -> list[str]:
    if arch_key not in cpp_lat:
        return [f"{arch_key}: missing latency table in {LATENCY_CPP.name}"]
    if arch_key not in cpp_fu:
        return [f"{arch_key}: missing FU table in {FU_CPP.name}"]
    arch_lat = cpp_lat[arch_key]
    arch_fu = cpp_fu[arch_key]
    td_entries: dict[str, dict] = {}
    if inherits:
        td_entries.update(td_tables["SICommonWriteRes"])
    td_entries.update(td_tables.get(model_name, {}))
    errors: list[str] = []
    for our_class, llvm_class in CLASS_TO_LLVM.items():
        if llvm_class is None or llvm_class not in td_entries:
            continue
        td_entry = td_entries[llvm_class]
        errors.extend(
            check_latency_entry(
                arch_key, model_name, our_class, td_entry["cycles"], arch_lat
            )
        )
        if td_entry["fu"] is not None:
            errors.extend(
                check_fu_entry(arch_key, model_name, our_class, td_entry["fu"], arch_fu)
            )
    return errors


def main() -> int:
    td_path = find_sischedule_td()
    if td_path is None:
        print(
            "check-sched-tables: no LLVM source tree found "
            "(set LLVM_PROJECT_SOURCE_DIR or run "
            "build_tools/build_llvm.py); skipping.",
            file=sys.stderr,
        )
        return 0
    td_tables = parse_td(td_path)
    cpp_lat = parse_cpp_latencies(LATENCY_CPP)
    cpp_fu = parse_cpp_fus(FU_CPP)

    errors: list[str] = []
    for arch_key, (model_name, inherits) in ARCH_MODEL.items():
        errors.extend(
            check_arch(arch_key, model_name, inherits, cpp_lat, cpp_fu, td_tables)
        )

    if errors:
        print(
            f"check-sched-tables: {len(errors)} mismatch(es) vs {td_path}:",
            file=sys.stderr,
        )
        for e in errors:
            print(f"  {e}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
