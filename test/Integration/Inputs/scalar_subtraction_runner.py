# SPDX-FileCopyrightText: 2026 wave-mlir contributors
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

import argparse
import ctypes
from pathlib import Path

from hip_runtime import Hip


def run(args):
    with Hip(args.hip_lib) as hip:
        binary = hip.load_module(args.hsaco)
        output = hip.allocate(args.wave_size * 4)
        function = hip.get_function(binary, "scalar_subtraction")
        values = [-(1 << 31), -17, -1, 0, 1, 17, (1 << 31) - 1]
        for lhs in values:
            for rhs in values:
                params = [output, ctypes.c_int32(lhs), ctypes.c_int32(rhs)]
                hip.launch(function, params, block=(args.wave_size, 1, 1))
                host = (ctypes.c_int32 * args.wave_size)()
                hip.copy_from_device(output, host)
                expected = ctypes.c_int32(17 * lhs - rhs).value
                for lane, actual in enumerate(host):
                    assert actual == expected, (lhs, rhs, lane, actual, expected)
        print("scalar subtraction: 49 interference cases passed")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--hip-lib", required=True)
    parser.add_argument("--wave-size", type=int, choices=[32, 64], required=True)
    parser.add_argument("hsaco", type=Path)
    run(parser.parse_args())


if __name__ == "__main__":
    main()
