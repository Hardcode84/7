# RUN: %python %s wave-opt | FileCheck %s
# CHECK: shared DAG: 28 nodes simplified to one expression
# SPDX-FileCopyrightText: 2026 wave-mlir contributors
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

import subprocess
import sys


def main():
    simd = "!wave.simd<i32, 32>"
    pointer = "!wave.ptr<#wave.global, i8>"
    pointers = f"!wave.simd<{pointer}, 32>"
    lines = [
        f"func.func @fanout(%p: {pointer}, %q: {pointer}, %x: {simd}) "
        f"-> ({pointers}, {pointers}) {{"
    ]
    previous = "%x"
    for index in range(28):
        value = f"%a{index}"
        lines.append(
            f"{value} = wave.binary addi {previous}, {previous} overflow<nsw> "
            f": {simd}, {simd} -> {simd}"
        )
        previous = value
    for value, base in (("a", "p"), ("b", "q")):
        lines.append(
            f"%{value} = wave.ptr_add %{base}, {previous} "
            f": {pointer}, {simd} -> {pointers}"
        )
    lines.append(f"return %a, %b : {pointers}, {pointers}\n}}")
    result = subprocess.run(
        [sys.argv[1], "--wave-generate-index-exprs", "--canonicalize", "--cse"],
        input="\n".join(lines),
        text=True,
        capture_output=True,
        timeout=30,
        check=True,
    )
    assert "wave.binary" not in result.stdout, result.stdout
    assert result.stdout.count("wave.index_expr") == 1, result.stdout
    assert '<"268435456*raw0">' in result.stdout, result.stdout
    print("shared DAG: 28 nodes simplified to one expression")


if __name__ == "__main__":
    main()
