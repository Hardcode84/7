# SPDX-FileCopyrightText: 2026 wave-mlir contributors
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

import argparse
from pathlib import Path

from mlir.dialects.wave import register_dialects
from mlir.ir import Context, Module, Operation, WalkResult


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("source", type=Path)
    parser.add_argument("choice", type=int, choices=(0, 1))
    args = parser.parse_args()
    with Context() as context:
        register_dialects(context)
        program = Module.parse(args.source.read_text())
        choices = []

        def collect(op: Operation):
            if op.name == "wave.materialization_variants":
                choices.append(op)
            return WalkResult.ADVANCE

        program.operation.walk(collect)
        assert choices, "expected extracted address alternatives"
        for op in choices:
            op.results[0].replace_all_uses_with(op.operands[args.choice])
            op.erase()
        assert program.operation.verify()
        print(program)


if __name__ == "__main__":
    main()
