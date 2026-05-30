#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2026 wave-mlir contributors
#
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
"""Reject raw ixsimpl C API use outside WaveSymbols."""

from __future__ import annotations

import re
from collections.abc import Iterable
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
SOURCE_ROOTS = ("include", "lib", "tools")
SOURCE_SUFFIXES = {".c", ".cc", ".cpp", ".h", ".hpp", ".td"}
ALLOWED_PATHS = {
    Path("include/mlir/Dialect/Wave/IR/WaveSymbols.h"),
    Path("lib/Dialect/Wave/IR/WaveSymbols.cpp"),
}
RAW_IXS_RE = re.compile(
    r'#\s*include\s+[<"]ixsimpl\.h[>"]'
    r"|\b(?:IXS_[A-Z0-9_]+|ixs_[A-Za-z0-9_]+"
    r"|ixs_node|ixs_ctx|ixs_session|ixs_reader|ixs_cmp_op|ixs_tag)\b"
)
COMMENT_RE = re.compile(r"/\*.*?\*/|//.*?$", re.S | re.M)


def source_files() -> Iterable[Path]:
    for root_name in SOURCE_ROOTS:
        root = REPO_ROOT / root_name
        if not root.exists():
            continue
        for path in root.rglob("*"):
            if path.is_file() and path.suffix in SOURCE_SUFFIXES:
                yield path


def rel(path: Path) -> Path:
    return path.relative_to(REPO_ROOT)


def is_allowed(path: Path) -> bool:
    return rel(path) in ALLOWED_PATHS


def strip_comments(text: str) -> str:
    return COMMENT_RE.sub(lambda m: "\n" * m.group(0).count("\n"), text)


def scan(path: Path) -> list[tuple[int, str]]:
    if is_allowed(path):
        return []
    hits: list[tuple[int, str]] = []
    for line_no, line in enumerate(
        strip_comments(path.read_text()).splitlines(), start=1
    ):
        hits.extend((line_no, m.group(0).strip()) for m in RAW_IXS_RE.finditer(line))
    return hits


def main() -> int:
    failed = False
    for path in source_files():
        for line_no, token in scan(path):
            print(f"{rel(path)}:{line_no}: raw ixsimpl C API token `{token}`")
            failed = True
    return 1 if failed else 0


if __name__ == "__main__":
    raise SystemExit(main())
