# SPDX-FileCopyrightText: 2026 wave-mlir contributors
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

import argparse
from pathlib import Path

import numpy as np
from hip_runtime import Hip


def run(args):
    initial = np.arange(256, dtype=np.int32) + 100
    output = initial.copy()
    expected = initial.copy()
    width = args.wave_width
    expected[:width] = np.arange(width)
    expected[64 : 64 + width] = np.arange(width)
    expected[192 : 192 + width] = initial[128 : 128 + width]
    with Hip(args.hip_lib) as hip:
        binary = hip.load_module(args.hsaco)
        device = hip.allocate(output.nbytes)
        hip.copy_to_device(device, output)
        function = hip.get_function(binary, "preserve_effects")
        hip.launch(function, (device,), block=(width, 1, 1))
        hip.copy_from_device(device, output)
        np.testing.assert_array_equal(output, expected)
    print("Materialization prerequisites: 256 outputs passed")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--hip-lib", required=True)
    parser.add_argument("--wave-width", type=int, required=True)
    parser.add_argument("hsaco", type=Path)
    run(parser.parse_args())


if __name__ == "__main__":
    main()
