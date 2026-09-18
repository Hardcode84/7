# SPDX-FileCopyrightText: 2026 wave-mlir contributors
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

import argparse
import ctypes
from pathlib import Path

import numpy as np
from hip_runtime import Hip

CASES = [
    (3, 7, 2, 0, 4, 1),
    (3, 7, 2, 3, 11, 2),
    (3, 7, 2, 67108859, 67108863, 1),
    (3, 7, 2, 67108859, 67108871, 3),
    (3, 7, 2, 33554429, 33554433, 1),
    (3, 7, 2, 2147483633, 2147483645, 3),
    (3, 7, 2, 3, 3, 1),
    (3, 3, 2, 0, 4, 1),
]


def expected_output(initial, bounds, width):
    result = initial.copy()
    outer_lower, outer_upper, outer_step, lower, upper, step = bounds
    for outer in range(outer_lower, outer_upper, outer_step):
        for row, iv in enumerate(range(lower, upper, step)):
            base = (outer - outer_lower) * 512 + row * 256
            for scale, bias, extra, increment in [(64, 4, 0, 1), (128, 2, 16, 7)]:
                offsets = (scale * (iv + bias) + 4 * np.arange(width) + extra) % 2**32
                words = offsets[offsets < 1024] // 4
                result[base + words] += increment
    return result


def execute(hip, binary, device, initial, bounds, width):
    result = initial.copy()
    hip.copy_to_device(device, result)
    function = hip.get_function(binary, "nested_offsets")
    params = [device, *(ctypes.c_int32(x) for x in bounds)]
    hip.launch(function, params, block=(width, 1, 1))
    hip.copy_from_device(device, result)
    return result


def run(args):
    initial = np.arange(2048, dtype=np.int32) * 3 + 11
    with Hip(args.hip_lib) as hip:
        device = hip.allocate(initial.nbytes)
        binaries = [hip.load_module(path) for path in args.hsaco]
        for bounds in CASES:
            expected = expected_output(initial, bounds, args.wave_width)
            for path, binary in zip(args.hsaco, binaries, strict=True):
                result = execute(hip, binary, device, initial, bounds, args.wave_width)
                np.testing.assert_array_equal(
                    result, expected, err_msg=f"{path} {bounds}"
                )
    print(f"Nested offsets: {len(binaries)} forms, 8 cases, 2048 words passed")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--hip-lib", required=True)
    parser.add_argument("--wave-width", type=int, required=True)
    parser.add_argument("hsaco", type=Path, nargs=4)
    run(parser.parse_args())


if __name__ == "__main__":
    main()
