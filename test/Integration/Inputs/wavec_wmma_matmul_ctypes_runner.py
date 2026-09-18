# SPDX-FileCopyrightText: 2026 wave-mlir contributors
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

import argparse
import ctypes
import math
import random
import struct
from pathlib import Path

from hip_runtime import Hip


def half_bits(value: float) -> int:
    return struct.unpack("<H", struct.pack("<e", value))[0]


def make_inputs(m: int, n: int, k: int, seed: int) -> tuple[list[int], list[int]]:
    rng = random.Random(seed)
    a = [half_bits(rng.randint(-8, 8) * 0.25) for _ in range(m * k)]
    b = [half_bits(rng.randint(-8, 8) * 0.25) for _ in range(n * k)]
    return a, b


def half_values(raw: list[int]) -> list[float]:
    return [struct.unpack("<e", struct.pack("<H", value))[0] for value in raw]


def reference_output(
    a_raw: list[int], b_raw: list[int], m: int, n: int, k: int
) -> list[float]:
    a = half_values(a_raw)
    b = half_values(b_raw)
    out = []
    for tile_m in range(m // 16):
        for tile_n in range(n // 16):
            for lane in range(32):
                for reg in range(8):
                    # fragment_unpack stores eight registers per lane.
                    row = tile_m * 16 + lane // 16 + 2 * reg
                    col = tile_n * 16 + lane % 16
                    acc = 0.0
                    for kk in range(k):
                        acc += a[row * k + kk] * b[col * k + kk]
                    out.append(acc)
    return out


def as_array(ctype, values: list[int] | list[float]):
    array_type = ctype * len(values)
    return array_type(*values)


def check_close(got: list[float], expected: list[float], tolerance: float):
    if len(got) != len(expected) or len(got) % 256:
        raise AssertionError(
            "matmul output must match reference size and contain whole tiles"
        )
    if not math.isfinite(tolerance) or tolerance < 0:
        raise ValueError("tolerance must be finite and nonnegative")
    worst = 0.0
    for index, (actual, ref) in enumerate(zip(got, expected, strict=True)):
        diff = abs(actual - ref)
        if not math.isfinite(actual) or not math.isfinite(ref) or diff > tolerance:
            raise AssertionError(
                f"tile={index // 256} lane={index % 256 // 8} reg={index % 8} "
                f"expected={ref} actual={actual} diff={diff}"
            )
        worst = max(worst, diff)
    print(f"max_abs_error={worst:.6f}")


def run(args: argparse.Namespace):
    if args.m % 16 or args.n % 16 or args.k % 16:
        raise ValueError("m, n, and k must be multiples of 16")
    a_raw, b_raw = make_inputs(args.m, args.n, args.k, args.seed)
    expected = reference_output(a_raw, b_raw, args.m, args.n, args.k)
    a_host = as_array(ctypes.c_uint16, a_raw)
    b_host = as_array(ctypes.c_uint16, b_raw)
    c_host = as_array(ctypes.c_float, [float("nan")] * len(expected))

    with Hip(args.hip_lib) as hip:
        binary = hip.load_module(args.hsaco)
        function = hip.get_function(binary, args.kernel)
        hosts = (a_host, b_host, c_host)
        devices = [hip.allocate(ctypes.sizeof(host)) for host in hosts]
        for device, host in zip(devices, hosts, strict=True):
            hip.copy_to_device(device, host)
        hip.launch(
            function, devices, grid=(args.m // 16, args.n // 16, 1), block=(32, 1, 1)
        )
        hip.copy_from_device(devices[2], c_host)
        check_close(list(c_host), expected, args.tolerance)
    print("wavec WMMA matmul random ok")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--hip-lib", required=True)
    parser.add_argument("--m", type=int, default=16)
    parser.add_argument("--n", type=int, default=16)
    parser.add_argument("--k", type=int, default=16)
    parser.add_argument("--seed", type=int, default=19)
    parser.add_argument("--tolerance", type=float, default=0.01)
    parser.add_argument("hsaco", type=Path)
    parser.add_argument("kernel")
    run(parser.parse_args())
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
