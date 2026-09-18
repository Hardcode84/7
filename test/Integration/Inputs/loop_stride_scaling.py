# SPDX-FileCopyrightText: 2026 wave-mlir contributors
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

"""Check batched exact carries with observed memory and independent kernels."""

import argparse
import subprocess


def offset_access(index, dependency):
    return f"""
    %math{index} = wave.index_expr <"64*({4 + index} + i)"> ["i"](%i)
        : (i32) -> index
    %bits{index} = wave.cast intconvert %math{index} : index -> i32
    %lanes{index} = wave.splat %bits{index} : i32 -> !wave.simd<i32, 32>
    %offset{index} = wave.cast intconvert %lanes{index}
        policy {{extension = #wave.cast_extension<zero>}}
        : !wave.simd<i32, 32> -> !wave.simd<index, 32>
    %ptr{index} = wave.ptr_add %buffer, %offset{index}
        : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<index, 32>
        -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
    %value{index}, %read{index} = wave.load %ptr{index} after %{dependency}
        : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>, !wave.mem.token)
        -> (!wave.simd<i32, 32>, !wave.mem.token)
    %next{index} = wave.binary addi %value{index}, %one
        : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
    %stored{index} = wave.store %next{index} -> %ptr{index} after %read{index}
        : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>,
           !wave.mem.token) -> !wave.mem.token
"""


def kernel(name, size):
    accesses = "".join(
        offset_access(index, f"stored{index - 1}" if index else "dep")
        for index in range(size)
    )
    return f"""
func.func @{name}(%buffer: !wave.ptr<#waveamd.buffer, i32>, %n: i32)
    -> !wave.mem.token attributes {{wave.kernel}} {{
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %one = wave.constant 1 : i32 -> !wave.simd<i32, 32>
  %seed = wave.token : !wave.mem.token
  %done = scf.for %i = %c0 to %n step %c1 iter_args(%dep = %seed)
      -> !wave.mem.token : i32 {{
{accesses}
    scf.yield %stored{size - 1} : !wave.mem.token
  }}
  return %done : !wave.mem.token
}}
"""


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--wave-opt", required=True)
    parser.add_argument("--size", type=int, default=128)
    parser.add_argument("--kernels", type=int, default=4)
    args = parser.parse_args()
    code = (
        "module {"
        + "".join(kernel(f"batch_{index}", args.size) for index in range(args.kernels))
        + "}"
    )
    command = [args.wave_opt, "--wave-extract-loop-strides"]
    first = subprocess.run(
        command, input=code, text=True, capture_output=True, timeout=30, check=True
    ).stdout
    assert first.count("wave.materialization_variants") == args.size * args.kernels
    assert first.count("wave.load") == args.size * args.kernels
    assert first.count("wave.store") == args.size * args.kernels
    second = subprocess.run(
        command, input=first, text=True, capture_output=True, timeout=30, check=True
    ).stdout
    assert first == second
    print(f"{args.kernels} kernels, {args.size} carries each: stable")


if __name__ == "__main__":
    main()
