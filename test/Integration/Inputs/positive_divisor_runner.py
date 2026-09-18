# SPDX-FileCopyrightText: 2026 wave-mlir contributors
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

import argparse
import ctypes
import random
from pathlib import Path

from hip_runtime import Hip


def launch_and_check(hip, function, params, output, dividends, divisor):
    hip.launch(function, params, block=(len(dividends), 1, 1))
    host = (ctypes.c_int32 * (2 * len(dividends)))()
    hip.copy_from_device(output, host)
    for lane, dividend in enumerate(dividends):
        quotient = abs(dividend) // abs(divisor)
        if (dividend < 0) != (divisor < 0):
            quotient = -quotient
        expected = (quotient, dividend - quotient * divisor)
        actual = (host[2 * lane], host[2 * lane + 1])
        if actual != expected:
            raise AssertionError(
                f"{dividend=} {divisor=} {lane=}: {actual=} != {expected=}"
            )


def check_kernel(
    hip, function, name, source, output, dividends, lanes, divisors, negative_constant
):
    for divisor in divisors:
        if name == "simd":
            params = [source, output]
            if not negative_constant:
                params.append(ctypes.c_int32(divisor))
            launch_and_check(hip, function, params, output, lanes, divisor)
        else:
            scalar = ctypes.c_int64 if name == "narrow" else ctypes.c_int32
            for dividend in dividends:
                params = [output, scalar(dividend)]
                if not negative_constant:
                    params.append(scalar(divisor))
                launch_and_check(
                    hip, function, params, output, [dividend] * len(lanes), divisor
                )


def run(args):
    rng = random.Random(37)
    dividends = [-(1 << 31), -(1 << 31) + 1, -17, -1, 0, 1, 17, (1 << 31) - 1]
    dividends += [rng.randint(-(1 << 31), (1 << 31) - 1) for _ in range(24)]
    divisors = [1, 2, 3, 7, 31, 65537, (1 << 31) - 1]
    divisors += [rng.randint(1, (1 << 31) - 1) for _ in range(5)]
    if args.negative_constant:
        divisors = [-3]
        dividends[2], dividends[6] = -7, 7
    prefix = (
        "negative_constant_divisor" if args.negative_constant else "positive_divisor"
    )
    lanes = [dividends[i % len(dividends)] for i in range(args.wave_size)]
    host_input = (ctypes.c_int32 * args.wave_size)(*lanes)
    with Hip(args.hip_lib) as hip:
        binary = hip.load_module(args.hsaco)
        source = hip.allocate(args.wave_size * 4)
        output = hip.allocate(args.wave_size * 8)
        hip.copy_to_device(source, host_input)
        for name in ["scalar", "narrow", "simd"]:
            function = hip.get_function(binary, f"{prefix}_{name}")
            check_kernel(
                hip,
                function,
                name,
                source,
                output,
                dividends,
                lanes,
                divisors,
                args.negative_constant,
            )
            count = len(dividends) * len(divisors)
            print(f"{name}: {count} signed div/rem pairs passed")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--hip-lib", required=True)
    parser.add_argument("--wave-size", type=int, choices=[32, 64], required=True)
    parser.add_argument("--negative-constant", action="store_true")
    parser.add_argument("hsaco", type=Path)
    run(parser.parse_args())


if __name__ == "__main__":
    main()
