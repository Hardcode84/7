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


def run(args):
    initial = np.arange(256, dtype=np.int32) + 100
    output = initial.copy()
    expected = initial.copy()
    width = args.wave_width
    expected[:width] = np.arange(width)
    expected[64 : 64 + width] = np.arange(width)
    expected[192 : 192 + width] = initial[128 : 128 + width]
    hip = Hip(args.hip_lib)
    hip.check(hip.lib.hipInit(0), "hipInit")
    binary = ctypes.c_void_p()
    with ExitStack() as cleanup:
        hip.check(
            hip.lib.hipModuleLoad(ctypes.byref(binary), str(args.hsaco).encode()),
            "hipModuleLoad",
        )
        cleanup.callback(lambda: hip.check(hip.lib.hipModuleUnload(binary), "unload"))
        buffers = []
        for host in [output]:
            device = ctypes.c_void_p()
            hip.check(hip.lib.hipMalloc(ctypes.byref(device), host.nbytes), "allocate")
            cleanup.callback(lambda p=device: hip.check(hip.lib.hipFree(p), "free"))
            hip.check(
                hip.lib.hipMemcpy(
                    device, host.ctypes.data, host.nbytes, HIP_MEMCPY_HOST_TO_DEVICE
                ),
                "copy input",
            )
            buffers.append(device)
        function = ctypes.c_void_p()
        hip.check(
            hip.lib.hipModuleGetFunction(
                ctypes.byref(function), binary, b"preserve_effects"
            ),
            "hipModuleGetFunction",
        )
        params = buffers
        arguments = (ctypes.c_void_p * len(params))(*(ptr_to(p) for p in params))
        hip.check(
            hip.lib.hipModuleLaunchKernel(
                function, 1, 1, 1, width, 1, 1, 0, None, arguments, None
            ),
            "launch",
        )
        hip.check(hip.lib.hipDeviceSynchronize(), "synchronize")
        hip.check(
            hip.lib.hipMemcpy(
                output.ctypes.data,
                buffers[-1],
                output.nbytes,
                HIP_MEMCPY_DEVICE_TO_HOST,
            ),
            "copy output",
        )
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
