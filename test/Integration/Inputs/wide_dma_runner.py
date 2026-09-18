# SPDX-FileCopyrightText: 2026 wave-mlir contributors
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

import argparse
import ctypes
from pathlib import Path

import numpy as np
from hip_runtime import Hip

CASES = [(u, limit) for u in (0, 1, 2, 1023) for limit in (0, 1, 33, 64)]


def execute(hip, binary, source, device, initial, bounds):
    result = initial.copy()
    hip.copy_to_device(device, result)
    function = hip.get_function(binary, "wide_dma")
    # Cancel the wide byte offset without allocating terabytes.
    biased = ctypes.c_void_p(source.value - (bounds[0] << 32))
    params = [biased, device, *(ctypes.c_int32(x) for x in bounds)]
    hip.launch(function, params, block=(64, 1, 1))
    hip.copy_from_device(device, result)
    return result


def run(args):
    initial = np.full(128, -23, dtype=np.int32)
    inputs = np.arange(128, dtype=np.int32) * 3 + 11
    with Hip(args.hip_lib) as hip:
        device = hip.allocate(initial.nbytes)
        source = hip.allocate(inputs.nbytes)
        hip.copy_to_device(source, inputs)
        binaries = []
        for path in args.hsaco:
            binary = hip.load_module(path)
            binaries.append(binary)
        for bounds in CASES:
            expected = inputs.copy().reshape(2, 64)
            expected[:, bounds[1] :] = 0
            expected = expected.reshape(-1)
            for path, binary in zip(args.hsaco, binaries, strict=True):
                result = execute(hip, binary, source, device, initial, bounds)
                np.testing.assert_array_equal(
                    result, expected, err_msg=f"{path} {bounds}"
                )
    print(f"Wide DMA: {len(binaries)} forms, 16 cases, 128 words passed")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--hip-lib", required=True)
    parser.add_argument("hsaco", type=Path, nargs=2)
    run(parser.parse_args())


if __name__ == "__main__":
    main()
