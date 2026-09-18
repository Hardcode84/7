# SPDX-FileCopyrightText: 2026 wave-mlir contributors
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

import argparse
import ctypes
from pathlib import Path

from hip_runtime import Hip


def run(args):
    host_type = ctypes.c_int32 * args.wave_size
    size = ctypes.sizeof(host_type)
    with Hip(args.hip_lib) as hip:
        binary = hip.load_module(args.hsaco)
        function = hip.get_function(binary, "arith_select_pointer")
        buffers = [hip.allocate(size) for _ in range(3)]
        inputs = [
            [17 * i + 5 for i in range(args.wave_size)],
            [-11 * i - 7 for i in range(args.wave_size)],
        ]
        for buffer, values in zip(buffers[:2], inputs, strict=True):
            hip.copy_to_device(buffer, host_type(*values))
        for flag in [0, 1, -1]:
            output = host_type(*([-1] * args.wave_size))
            hip.copy_to_device(buffers[2], output)
            params = [*buffers, ctypes.c_int32(flag)]
            hip.launch(function, params, block=(args.wave_size, 1, 1))
            hip.copy_from_device(buffers[2], output)
            expected = inputs[0 if flag else 1]
            if list(output) != expected:
                raise AssertionError(f"{flag=}: {list(output)} != {expected}")
        print("typed-pointer select: 3 cases passed")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--hip-lib", required=True)
    parser.add_argument("--wave-size", type=int, choices=[32, 64], required=True)
    parser.add_argument("hsaco", type=Path)
    run(parser.parse_args())


if __name__ == "__main__":
    main()
