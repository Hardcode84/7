# SPDX-FileCopyrightText: 2026 wave-mlir contributors
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

import argparse
import ctypes
from contextlib import ExitStack
from pathlib import Path

import numpy as np
from wavec_saxpy_ctypes_runner import (
    HIP_MEMCPY_DEVICE_TO_HOST,
    HIP_MEMCPY_HOST_TO_DEVICE,
    Hip,
    ptr_to,
)

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
    hip.check(
        hip.lib.hipMemcpy(
            device, output.ctypes.data, output.nbytes, HIP_MEMCPY_HOST_TO_DEVICE
        ),
        "initialize output",
    )
    function = ctypes.c_void_p()
    hip.check(
        hip.lib.hipModuleGetFunction(ctypes.byref(function), binary, name.encode()),
        "get function",
    )
    arguments = (ctypes.c_void_p * 1)(ptr_to(device))
    hip.check(
        hip.lib.hipModuleLaunchKernel(
            function, 1, 1, 1, 256, 1, 1, 0, None, arguments, None
        ),
        "launch",
    )
    hip.check(hip.lib.hipDeviceSynchronize(), "synchronize")
    hip.check(
        hip.lib.hipMemcpy(
            output.ctypes.data, device, output.nbytes, HIP_MEMCPY_DEVICE_TO_HOST
        ),
        "copy output",
    )
    return output


def run(args):
    hip = Hip(args.hip_lib)
    hip.check(hip.lib.hipInit(0), "initialize HIP")
    with ExitStack() as cleanup:
        device = ctypes.c_void_p()
        hip.check(hip.lib.hipMalloc(ctypes.byref(device), 512 * 4), "allocate")
        cleanup.callback(lambda: hip.check(hip.lib.hipFree(device), "free"))
        binaries = []
        for path in [args.original, args.optimized]:
            binary = ctypes.c_void_p()
            hip.check(
                hip.lib.hipModuleLoad(ctypes.byref(binary), str(path).encode()), "load"
            )
            cleanup.callback(
                lambda b=binary: hip.check(hip.lib.hipModuleUnload(b), "unload")
            )
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
