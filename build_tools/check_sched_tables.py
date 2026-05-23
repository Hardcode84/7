#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2026 wave-mlir contributors
#
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
"""Sched-table divergence detector.

Parses LLVM's ``SISchedule.td`` (from
``build/_deps/llvm-project`` or ``$LLVM_PROJECT_SOURCE_DIR``)
and ``lib/Dialect/WaveAMDMachine/CostModel/LatencyTable.cpp``;
verifies that every (arch, SchedClass) cycle count in our
hand-copy matches what LLVM's HWWriteRes lines actually say.

Skips classes LLVM does not bind for a given model (e.g. WMMA on
CDNA, MAI on RDNA) and pseudo SchedClasses that have no LLVM
equivalent (``NoInst``, ``WaitcntPseudo``).

Exit codes:
    0  every bound (arch, class) matches LLVM (or no LLVM source).
    1  at least one (arch, class) value diverges.

If no LLVM source tree is reachable the script returns 0 with a
note on stderr; contributors without an LLVM checkout still get
clean pre-commit runs, but CI catches drift by virtue of always
having one.
"""

from __future__ import annotations

import os
import re
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
LATENCY_CPP = REPO_ROOT / "lib/Dialect/WaveAMDMachine/CostModel/LatencyTable.cpp"

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

# Map our arch suffix (kLatencyGfxNNN) to (LLVM SchedModel name,
# inherits SICommonWriteRes?). The CDNA models start from the
# common defaults; the GFX10+ models are self-contained.
ARCH_MODEL: dict[str, tuple[str, bool]] = {
    "Gfx942": ("SIDPGFX942FullSpeedModel", True),
    "Gfx950": ("SIDPGFX950FullSpeedModel", True),
    "Gfx1100": ("GFX11SpeedModel", False),
    "Gfx1200": ("GFX12SpeedModel", False),
}

# HWWriteRes<Class, [resources], cycles> -- cycles is the last int.
# HWVALUWriteRes<Class, cycles>.
WRITE_RES_RE = re.compile(r"HW(?:VALU)?WriteRes<(\w+),\s*(?:\[[^\]]*\],\s*)?(\d+)>")


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


def parse_block(td_text: str, header_re: str) -> dict[str, int]:
    """Parse one ``multiclass`` or ``let SchedModel = X in`` block
    and return {SchedWrite -> cycles}. Later writes win on
    duplicates (matches LLVM's let-override semantics)."""
    m = re.search(header_re, td_text)
    if not m:
        return {}
    body = extract_braced_block(td_text, m.end())
    result: dict[str, int] = {}
    for raw in body.splitlines():
        line = raw.split("//", 1)[0].strip()
        mm = WRITE_RES_RE.search(line)
        if mm:
            result[mm.group(1)] = int(mm.group(2))
    return result


def parse_td(path: Path) -> dict[str, dict[str, int]]:
    text = path.read_text()
    out: dict[str, dict[str, int]] = {
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


def parse_cpp(path: Path) -> dict[str, dict[str, int]]:
    text = path.read_text()
    out: dict[str, dict[str, int]] = {}
    table_re = re.compile(
        r"static\s+constexpr\s+ClassLatencies\s+kLatency(\w+)\s*=\s*\{" r"([^}]*)\};",
        re.DOTALL,
    )
    for m in table_re.finditer(text):
        arch = m.group(1)
        body = m.group(2)
        entries: dict[str, int] = {}
        for em in re.finditer(r"/\*(\w+)=\*/\s*(\d+)", body):
            entries[em.group(1)] = int(em.group(2))
        out[arch] = entries
    alias_re = re.compile(
        r"static\s+constexpr\s+ClassLatencies\s+kLatency(\w+)\s*=\s*" r"kLatency(\w+);"
    )
    for m in alias_re.finditer(text):
        out[m.group(1)] = out[m.group(2)]
    return out


def check_arch(
    arch_key: str,
    model_name: str,
    inherits: bool,
    cpp_tables: dict[str, dict[str, int]],
    td_tables: dict[str, dict[str, int]],
) -> list[str]:
    if arch_key not in cpp_tables:
        return [f"{arch_key}: missing table in {LATENCY_CPP.name}"]
    cpp_entries = cpp_tables[arch_key]
    td_entries: dict[str, int] = {}
    if inherits:
        td_entries.update(td_tables["SICommonWriteRes"])
    td_entries.update(td_tables.get(model_name, {}))
    errors: list[str] = []
    for our_class, llvm_class in CLASS_TO_LLVM.items():
        if llvm_class is None or llvm_class not in td_entries:
            continue
        expected = td_entries[llvm_class]
        actual = cpp_entries.get(our_class)
        if actual is None:
            errors.append(f"{arch_key}: missing entry for {our_class}")
        elif actual != expected:
            errors.append(
                f"{arch_key}.{our_class}: cpp says {actual}, "
                f"SISchedule.td/{model_name}/{llvm_class} "
                f"says {expected}"
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
    cpp_tables = parse_cpp(LATENCY_CPP)

    errors: list[str] = []
    for arch_key, (model_name, inherits) in ARCH_MODEL.items():
        errors.extend(check_arch(arch_key, model_name, inherits, cpp_tables, td_tables))

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
