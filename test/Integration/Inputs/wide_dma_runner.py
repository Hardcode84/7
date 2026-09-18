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

CASES = [(u, limit) for u in (0, 1, 2, 1023) for limit in (0, 1, 33, 64)]


def execute(hip, binary, source, device, initial, bounds):
    result = initial.copy()
    hip.check(
        hip.lib.hipMemcpy(
            device, result.ctypes.data, result.nbytes, HIP_MEMCPY_HOST_TO_DEVICE
        ),
        "initialize storage",
    )
    function = ctypes.c_void_p()
    hip.check(
        hip.lib.hipModuleGetFunction(ctypes.byref(function), binary, b"wide_dma"),
        "get function",
    )
    # Cancel the wide byte offset without allocating terabytes.
    biased = ctypes.c_void_p(source.value - (bounds[0] << 32))
    params = [biased, device, *(ctypes.c_int32(x) for x in bounds)]
    arguments = (ctypes.c_void_p * len(params))(*(ptr_to(x) for x in params))
    hip.check(
        hip.lib.hipModuleLaunchKernel(
            function, 1, 1, 1, 64, 1, 1, 0, None, arguments, None
        ),
        "launch",
    )
    hip.check(hip.lib.hipDeviceSynchronize(), "synchronize")
    hip.check(
        hip.lib.hipMemcpy(
            result.ctypes.data, device, result.nbytes, HIP_MEMCPY_DEVICE_TO_HOST
        ),
        "copy storage",
    )
    return result


def run(args):
    initial = np.full(128, -23, dtype=np.int32)
    inputs = np.arange(128, dtype=np.int32) * 3 + 11
    hip = Hip(args.hip_lib)
    hip.check(hip.lib.hipInit(0), "initialize HIP")
    with ExitStack() as cleanup:
        device = ctypes.c_void_p()
        hip.check(hip.lib.hipMalloc(ctypes.byref(device), initial.nbytes), "allocate")
        cleanup.callback(lambda: hip.check(hip.lib.hipFree(device), "free"))
        source = ctypes.c_void_p()
        hip.check(
            hip.lib.hipMalloc(ctypes.byref(source), inputs.nbytes), "allocate input"
        )
        cleanup.callback(lambda: hip.check(hip.lib.hipFree(source), "free input"))
        hip.check(
            hip.lib.hipMemcpy(
                source, inputs.ctypes.data, inputs.nbytes, HIP_MEMCPY_HOST_TO_DEVICE
            ),
            "copy input",
        )
        binaries = []
        for path in args.hsaco:
            binary = ctypes.c_void_p()
            hip.check(
                hip.lib.hipModuleLoad(ctypes.byref(binary), str(path).encode()), "load"
            )
            cleanup.callback(
                lambda b=binary: hip.check(hip.lib.hipModuleUnload(b), "unload")
            )
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
