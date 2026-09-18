# SPDX-FileCopyrightText: 2026 wave-mlir contributors
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

import argparse
from pathlib import Path

import numpy as np
from hip_runtime import Hip

CASES = {
    "redistribute_broadcast_pair": (0xFFFFFFFFFFFFFFFF, False),
    "lower_first": (0xFFFFFFFFFFFFFFFF, False),
    "upper_first": (0xFFFFFFFFFFFFFFFF, False),
    "active_lower": (0x00000000FFFFFFFF, False),
    "active_upper": (0xFFFFFFFF00000000, False),
    "active_sparse": (0x55555555AAAAAAAA, False),
    "changed_exec": (0x00000000FFFFFFFF, True),
}


def expected_output(mask, changed):
    expected = np.full(512, -1, dtype=np.int32)
    for item in range(256):
        lane = item % 64
        if not ((mask >> lane) & 1):
            continue
        for half in range(2):
            source = lane % 32 + half * 32
            active = (mask >> source) & 1 or (changed and half == 1)
            value = ((item // 64 * 64 + source) ^ 0x13579BDF) + 17
            expected[half * 256 + item] = value if active else 0
    return expected


def launch(hip, binary, name, device):
    output = np.full(512, -1, dtype=np.int32)
    hip.copy_to_device(device, output)
    function = hip.get_function(binary, name)
    hip.launch(function, (device,), block=(256, 1, 1))
    hip.copy_from_device(device, output)
    return output


def run(args):
    with Hip(args.hip_lib) as hip:
        device = hip.allocate(512 * 4)
        binaries = []
        for path in [args.original, args.optimized]:
            binary = hip.load_module(path)
            binaries.append(binary)
        for name, (mask, changed) in CASES.items():
            original, optimized = [launch(hip, b, name, device) for b in binaries]
            expected = expected_output(mask, changed)
            if name == "redistribute_broadcast_pair":
                expected = expected.reshape(2, 256).T.flatten()
            np.testing.assert_array_equal(
                original, expected, err_msg=f"original {name}"
            )
            np.testing.assert_array_equal(
                optimized, original, err_msg=f"optimized {name}"
            )
    print("Half broadcasts: 7 kernels, 4 waves, 7168 outputs passed")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--hip-lib", required=True)
    parser.add_argument("original", type=Path)
    parser.add_argument("optimized", type=Path)
    run(parser.parse_args())


if __name__ == "__main__":
    main()
