# SPDX-FileCopyrightText: 2026 wave-mlir contributors
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

import argparse
import ctypes
from pathlib import Path

from hip_runtime import Hip


def quotient_remainder(value, divisor):
    value = ctypes.c_int32(value).value
    quotient = abs(value) // abs(divisor)
    if (value < 0) != (divisor < 0):
        quotient = -quotient
    return quotient, value - quotient * divisor


def expected_index(name, lane, case):
    x, d, y, e = case
    quotient, remainder = quotient_remainder(x + lane, d)
    if name == "inexact":
        remainder -= quotient
    if name == "multiple":
        remainder += quotient_remainder(y + lane, e)[1]
    return (4 * (128 + remainder)) % (1 << 32) // 4


def check_case(hip, function, source, output, name, case, wave_size):
    params = [source, output, *(ctypes.c_int32(v) for v in case)]
    sentinel = (ctypes.c_int32 * wave_size)(*([-1] * wave_size))
    hip.copy_to_device(output, sentinel)
    hip.launch(function, params, block=(wave_size, 1, 1))
    hip.copy_from_device(output, sentinel)
    for lane, actual in enumerate(sentinel):
        index = expected_index(name, lane, case)
        expected = 17 * index + 5 if index < 256 else 0
        if actual != expected:
            raise AssertionError(f"{name=} {case=} {lane=}: {actual=} != {expected=}")


def run(args):
    cases = [
        (-33, 7, 19, 5),
        (33, 7, -19, 5),
        (-33, -7, 19, -5),
        (33, -7, -19, -5),
        (-(1 << 31), 17, (1 << 31) - 1, -13),
        ((1 << 31) - 1, -17, -(1 << 31), 13),
        (-1, 1, 0, -1),
        (0, -3, -17, 7),
    ]
    with Hip(args.hip_lib) as hip:
        binary = hip.load_module(args.hsaco)
        source = hip.allocate(1024)
        output = hip.allocate(args.wave_size * 4)
        data = (ctypes.c_int32 * 256)(*(17 * i + 5 for i in range(256)))
        hip.copy_to_device(source, data)
        for name in ["distributed", "inexact", "multiple"]:
            function = hip.get_function(binary, f"{name}_remainder_address")
            for case in cases:
                check_case(hip, function, source, output, name, case, args.wave_size)
            print(f"{name}: {len(cases)} address cases passed")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--hip-lib", required=True)
    parser.add_argument("--wave-size", type=int, choices=[32, 64], required=True)
    parser.add_argument("hsaco", type=Path)
    run(parser.parse_args())


if __name__ == "__main__":
    main()
