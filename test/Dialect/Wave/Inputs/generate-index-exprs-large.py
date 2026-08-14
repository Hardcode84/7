# SPDX-FileCopyrightText: 2026 wave-mlir contributors
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

from __future__ import annotations

LEAF_COUNT = 64
ROOT_COUNT = 8


def build_source() -> str:
    arguments = ", ".join(f"%raw{i}: i32" for i in range(LEAF_COUNT))
    result_types = ", ".join("index" for _ in range(ROOT_COUNT))
    lines = [
        "module {",
        f"  func.func @large_fully_merged({arguments}) -> ({result_types}) {{",
        "    %c64 = arith.constant 64 : i32",
    ]
    values = []
    for i in range(LEAF_COUNT):
        lines.extend(
            [
                f'    %bounded{i} = wave.assume %raw{i} as "value" '
                '[#wave.pred<"value >= 0">, '
                '#wave.pred<"value <= 1023">] : i32',
                f"    %offset{i} = arith.constant {i} : i32",
                f"    %shifted{i} = wave.binary addi %bounded{i}, %offset{i} "
                "overflow<nsw, nuw> : i32, i32 -> i32",
                f"    %mod{i} = wave.binary remui %shifted{i}, %c64 "
                ": i32, i32 -> i32",
                f"    %condition{i} = arith.cmpi slt, %bounded{i}, %c64 : i32",
                f"    %selected{i} = wave.select %condition{i}, %mod{i}, "
                f"%shifted{i} : i32",
            ]
        )
        values.append(f"%selected{i}")

    sum_index = 0
    while len(values) > 1:
        next_values = []
        for i in range(0, len(values), 2):
            name = f"%sum{sum_index}"
            lines.append(
                f"    {name} = wave.binary addi {values[i]}, {values[i + 1]} "
                ": i32, i32 -> i32"
            )
            next_values.append(name)
            sum_index += 1
        values = next_values

    for i in range(ROOT_COUNT):
        lines.append(
            f'    %root{i} = wave.index_expr <"{i} + binding"> '
            f'["binding"]({values[0]}) : (i32) -> index'
        )
    results = ", ".join(f"%root{i}" for i in range(ROOT_COUNT))
    lines.extend([f"    return {results} : {result_types}", "  }", "}"])
    return "\n".join(lines) + "\n"


if __name__ == "__main__":
    print(build_source(), end="")
