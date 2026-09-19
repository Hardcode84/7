# SPDX-FileCopyrightText: 2026 wave-mlir contributors
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

import argparse
import ctypes
from pathlib import Path

from hip_runtime import Hip


def run(args):
    count = 64
    output_count = 1024
    with Hip(args.hip_lib) as hip:
        binary = hip.load_module(args.hsaco)
        source = hip.allocate(count * 4)
        output = hip.allocate(output_count * 4)
        function = hip.get_function(binary, args.kernel)
        for shift in (0, 7, 31):
            inputs = (ctypes.c_int32 * count)(
                *((37 * lane + shift) % count for lane in range(count))
            )
            actual = (ctypes.c_int32 * output_count)(*([-1] * output_count))
            hip.copy_to_device(source, inputs)
            hip.copy_to_device(output, actual)
            hip.launch(
                function,
                [source, output, ctypes.c_int32(shift)],
                block=(count, 1, 1),
            )
            hip.copy_from_device(output, actual)
            expected = [-1] * output_count
            for value in inputs:
                offset = args.stride * (value + shift)
                expected[offset] = value
                expected[512 + offset] = 2 * value
            for index, (got, want) in enumerate(zip(actual, expected, strict=True)):
                assert got == want, (args.kernel, shift, index, got, want)
    print(f"{args.kernel}: 3072 output and guard values passed")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--hip-lib", required=True)
    parser.add_argument("--kernel", required=True)
    parser.add_argument("--stride", type=int, choices=[1, 4], required=True)
    parser.add_argument("hsaco", type=Path)
    run(parser.parse_args())


if __name__ == "__main__":
    main()
