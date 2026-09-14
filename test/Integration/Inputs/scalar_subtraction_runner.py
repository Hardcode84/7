# SPDX-FileCopyrightText: 2026 wave-mlir contributors
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

import argparse
import ctypes
from contextlib import ExitStack
from pathlib import Path

from wavec_saxpy_ctypes_runner import HIP_MEMCPY_DEVICE_TO_HOST, Hip, ptr_to


def run(args):
    hip = Hip(args.hip_lib)
    hip.check(hip.lib.hipInit(0), "hipInit")
    binary = ctypes.c_void_p()
    output = ctypes.c_void_p()
    with ExitStack() as cleanup:
        hip.check(
            hip.lib.hipModuleLoad(ctypes.byref(binary), str(args.hsaco).encode()),
            "hipModuleLoad",
        )
        cleanup.callback(lambda: hip.check(hip.lib.hipModuleUnload(binary), "unload"))
        hip.check(hip.lib.hipMalloc(ctypes.byref(output), args.wave_size * 4), "malloc")
        cleanup.callback(lambda: hip.check(hip.lib.hipFree(output), "free"))
        function = ctypes.c_void_p()
        hip.check(
            hip.lib.hipModuleGetFunction(
                ctypes.byref(function), binary, b"scalar_subtraction"
            ),
            "hipModuleGetFunction",
        )
        values = [-(1 << 31), -17, -1, 0, 1, 17, (1 << 31) - 1]
        for lhs in values:
            for rhs in values:
                params = [output, ctypes.c_int32(lhs), ctypes.c_int32(rhs)]
                arguments = (ctypes.c_void_p * len(params))(
                    *(ptr_to(p) for p in params)
                )
                hip.check(
                    hip.lib.hipModuleLaunchKernel(
                        function,
                        1,
                        1,
                        1,
                        args.wave_size,
                        1,
                        1,
                        0,
                        None,
                        arguments,
                        None,
                    ),
                    "launch",
                )
                hip.check(hip.lib.hipDeviceSynchronize(), "synchronize")
                host = (ctypes.c_int32 * args.wave_size)()
                hip.check(
                    hip.lib.hipMemcpy(
                        host, output, ctypes.sizeof(host), HIP_MEMCPY_DEVICE_TO_HOST
                    ),
                    "copy output",
                )
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
