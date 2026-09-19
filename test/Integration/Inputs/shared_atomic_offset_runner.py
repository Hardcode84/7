# SPDX-FileCopyrightText: 2026 wave-mlir contributors
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

import argparse
import ctypes
from pathlib import Path

from hip_runtime import Hip


def run(args):
    count = args.width + 2
    host_type = ctypes.c_int32 * count
    initial = [7 * index + 11 for index in range(count)]
    with Hip(args.hip_lib) as hip:
        binary = hip.load_module(args.hsaco)
        function = hip.get_function(binary, "shared_atomic_offset")
        counters = hip.allocate(count * 4)
        output = hip.allocate(count * 4)
        for increment in (-3, 0, 7):
            actual_counters = host_type(*initial)
            actual_output = host_type(*([-99] * count))
            hip.copy_to_device(counters, actual_counters)
            hip.copy_to_device(output, actual_output)
            hip.launch(
                function,
                [counters, output, ctypes.c_int32(increment)],
                block=(args.width, 1, 1),
            )
            hip.copy_from_device(counters, actual_counters)
            hip.copy_from_device(output, actual_output)
            expected_counters = initial.copy()
            expected_output = [-99] * count
            for index in range(1, args.width + 1):
                expected_counters[index] += increment
                expected_output[index] = initial[index]
            assert list(actual_counters) == expected_counters, (
                increment,
                list(actual_counters),
                expected_counters,
            )
            assert list(actual_output) == expected_output, (
                increment,
                list(actual_output),
                expected_output,
            )
    print("shared atomic offset: counters, old values, and guards passed")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--hip-lib", required=True)
    parser.add_argument("--width", type=int, choices=[32, 64], required=True)
    parser.add_argument("hsaco", type=Path)
    run(parser.parse_args())


if __name__ == "__main__":
    main()
