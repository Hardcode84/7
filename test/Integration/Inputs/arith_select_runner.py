# SPDX-FileCopyrightText: 2026 wave-mlir contributors
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

import argparse
import ctypes
from contextlib import ExitStack
from pathlib import Path

from wavec_saxpy_ctypes_runner import (
    HIP_MEMCPY_DEVICE_TO_HOST,
    HIP_MEMCPY_HOST_TO_DEVICE,
    Hip,
    ptr_to,
)


def run(args):
    hip = Hip(args.hip_lib)
    hip.check(hip.lib.hipInit(0), "initialize")
    binary = ctypes.c_void_p()
    function = ctypes.c_void_p()
    host_type = ctypes.c_int32 * args.wave_size
    size = ctypes.sizeof(host_type)
    with ExitStack() as cleanup:
        hip.check(
            hip.lib.hipModuleLoad(ctypes.byref(binary), str(args.hsaco).encode()),
            "load kernel",
        )
        cleanup.callback(lambda: hip.check(hip.lib.hipModuleUnload(binary), "unload"))
        hip.check(
            hip.lib.hipModuleGetFunction(
                ctypes.byref(function), binary, b"arith_select_pointer"
            ),
            "get kernel",
        )
        buffers = [ctypes.c_void_p() for _ in range(3)]
        for buffer in buffers:
            hip.check(hip.lib.hipMalloc(ctypes.byref(buffer), size), "allocate")
            cleanup.callback(lambda p=buffer: hip.check(hip.lib.hipFree(p), "free"))
        inputs = [
            [17 * i + 5 for i in range(args.wave_size)],
            [-11 * i - 7 for i in range(args.wave_size)],
        ]
        for buffer, values in zip(buffers[:2], inputs, strict=True):
            hip.check(
                hip.lib.hipMemcpy(
                    buffer, host_type(*values), size, HIP_MEMCPY_HOST_TO_DEVICE
                ),
                "write input",
            )
        for flag in [0, 1, -1]:
            output = host_type(*([-1] * args.wave_size))
            hip.check(
                hip.lib.hipMemcpy(buffers[2], output, size, HIP_MEMCPY_HOST_TO_DEVICE),
                "reset output",
            )
            params = [*buffers, ctypes.c_int32(flag)]
            kernel_args = (ctypes.c_void_p * len(params))(*(ptr_to(p) for p in params))
            hip.check(
                hip.lib.hipModuleLaunchKernel(
                    function, 1, 1, 1, args.wave_size, 1, 1, 0, None, kernel_args, None
                ),
                "launch",
            )
            hip.check(hip.lib.hipDeviceSynchronize(), "synchronize")
            hip.check(
                hip.lib.hipMemcpy(output, buffers[2], size, HIP_MEMCPY_DEVICE_TO_HOST),
                "read output",
            )
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
