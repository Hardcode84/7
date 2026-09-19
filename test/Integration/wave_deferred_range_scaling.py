# RUN: %python %s wave-translate llvm-mc | FileCheck %s
# CHECK: shared loop-bound DAG: 40 nodes compiled and assembled
# SPDX-FileCopyrightText: 2026 wave-mlir contributors
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

import subprocess
import sys


def kernel():
    lines = [
        'module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {',
        "func.func @range_loop(%out: !wave.ptr<#wave.global, i32>, %input: index) "
        "-> !wave.mem.token attributes {wave.kernel} {",
        '%x = wave.assume %input as "x" [#wave.pred<"x >= 0">, '
        '#wave.pred<"x <= 4611686018427387903">] : index',
    ]
    previous = "%x"
    for index in range(40):
        value = f"%a{index}"
        lines.append(
            f"{value} = wave.binary addi {previous}, {previous} "
            ": index, index -> index"
        )
        previous = value
    lines.extend(
        [
            "%zero = arith.constant 0 : index",
            "%one = arith.constant 1 : index",
            "%root = wave.token : !wave.mem.token",
            "%lane = wave.lane_id : !wave.simd<i32, 32>",
            f"%done = scf.for %i = %zero to {previous} step %one "
            "iter_args(%dep = %root) -> (!wave.mem.token) {",
            "%t = wave.store %lane -> %out after %dep : "
            "(!wave.simd<i32, 32>, !wave.ptr<#wave.global, i32>, "
            "!wave.mem.token) -> !wave.mem.token",
            "scf.yield %t : !wave.mem.token",
            "}",
            "return %done : !wave.mem.token",
            "}",
            "}",
        ]
    )
    return "\n".join(lines)


def main():
    result = subprocess.run(
        [sys.argv[1], "--wave-to-amdgpu-asm", "-"],
        input=kernel(),
        text=True,
        capture_output=True,
        timeout=30,
        check=True,
    )
    assert "range_loop:" in result.stdout, result.stdout
    assert "s_endpgm" in result.stdout, result.stdout
    subprocess.run(
        [
            sys.argv[2],
            "--triple=amdgcn-amd-amdhsa",
            "--mcpu=gfx1100",
            "--filetype=obj",
            "-o",
            "/dev/null",
        ],
        input=result.stdout,
        text=True,
        timeout=30,
        check=True,
    )
    print("shared loop-bound DAG: 40 nodes compiled and assembled")


if __name__ == "__main__":
    main()
