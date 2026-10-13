# SPDX-FileCopyrightText: 2026 wave-mlir contributors
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

"""Check all joined tuple fields across zero, one, and three loop iterations."""

import ctypes
import sys
from array import array

from hip_runtime import Hip


def expected_values(choice, trips):
    a, b, scalar = ((11, 17, 17), (23, 31, 23), (41, 47, 41))[min(choice, 2)]
    for _ in range(trips):
        if choice == 1:
            a, b = scalar + 1, b + 2
        else:
            a, b = a + 1, scalar + 2
        scalar = a
    return [a, b, scalar] * 64


def main():
    with Hip(sys.argv[2]) as hip:
        binary = hip.load_module(sys.argv[1])
        function = hip.get_function(binary, "joined_tuple_runtime")
        output = array("I", [0] * (3 * 64))
        device = hip.allocate(len(output) * output.itemsize)
        for choice in range(4):
            for trips in (0, 1, 3):
                hip.copy_to_device(device, array("I", [0xDEADBEEF] * len(output)))
                args = [device, ctypes.c_uint(choice), ctypes.c_uint(trips)]
                hip.launch(function, args, block=(64, 1, 1))
                hip.copy_from_device(device, output)
                expected = expected_values(choice, trips)
                assert list(output) == expected, (choice, trips, list(output), expected)
        print("PASS: 12 branch/loop cases, 192 output words each")
        function = hip.get_function(binary, "independent_join_runtime")
        for choice, values in enumerate(((11, 17, 17), (23, 31, 47))):
            hip.copy_to_device(device, array("I", [0xDEADBEEF] * len(output)))
            hip.launch(
                function,
                [device, ctypes.c_uint(choice), ctypes.c_uint(0)],
                block=(64, 1, 1),
            )
            hip.copy_from_device(device, output)
            assert list(output) == list(values) * 64, (choice, list(output))
        print("PASS: aliased and independent join inputs")


if __name__ == "__main__":
    main()
