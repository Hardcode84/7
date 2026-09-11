# SPDX-FileCopyrightText: 2026 wave-mlir contributors
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

import argparse
import ctypes
import random
from contextlib import ExitStack
from pathlib import Path

from wavec_saxpy_ctypes_runner import (
    HIP_MEMCPY_DEVICE_TO_HOST,
    HIP_MEMCPY_HOST_TO_DEVICE,
    Hip,
    ptr_to,
)


def launch_and_check(hip, function, params, output, dividends, divisor):
    arguments = (ctypes.c_void_p * len(params))(*(ptr_to(p) for p in params))
    hip.check(
        hip.lib.hipModuleLaunchKernel(
            function, 1, 1, 1, len(dividends), 1, 1, 0, None, arguments, None
        ),
        "hipModuleLaunchKernel",
    )
    hip.check(hip.lib.hipDeviceSynchronize(), "hipDeviceSynchronize")
    host = (ctypes.c_int32 * (2 * len(dividends)))()
    hip.check(
        hip.lib.hipMemcpy(host, output, ctypes.sizeof(host), HIP_MEMCPY_DEVICE_TO_HOST),
        "hipMemcpy output",
    )
    for lane, dividend in enumerate(dividends):
        quotient = abs(dividend) // divisor
        if dividend < 0:
            quotient = -quotient
        expected = (quotient, dividend - quotient * divisor)
        actual = (host[2 * lane], host[2 * lane + 1])
        if actual != expected:
            raise AssertionError(
                f"{dividend=} {divisor=} {lane=}: {actual=} != {expected=}"
            )


def run(args):
    rng = random.Random(37)
    dividends = [-(1 << 31), -(1 << 31) + 1, -17, -1, 0, 1, 17, (1 << 31) - 1]
    dividends += [rng.randint(-(1 << 31), (1 << 31) - 1) for _ in range(24)]
    divisors = [1, 2, 3, 7, 31, 65537, (1 << 31) - 1]
    divisors += [rng.randint(1, (1 << 31) - 1) for _ in range(5)]
    lanes = [dividends[i % len(dividends)] for i in range(args.wave_size)]
    host_input = (ctypes.c_int32 * args.wave_size)(*lanes)
    hip = Hip(args.hip_lib)
    hip.check(hip.lib.hipInit(0), "hipInit")
    binary = ctypes.c_void_p()
    source = ctypes.c_void_p()
    output = ctypes.c_void_p()
    with ExitStack() as cleanup:
        hip.check(
            hip.lib.hipModuleLoad(ctypes.byref(binary), str(args.hsaco).encode()),
            "hipModuleLoad",
        )
        cleanup.callback(lambda: hip.check(hip.lib.hipModuleUnload(binary), "unload"))
        for device, size in [
            (source, args.wave_size * 4),
            (output, args.wave_size * 8),
        ]:
            hip.check(hip.lib.hipMalloc(ctypes.byref(device), size), "hipMalloc")
            cleanup.callback(lambda p=device: hip.check(hip.lib.hipFree(p), "hipFree"))
        hip.check(
            hip.lib.hipMemcpy(
                source, host_input, ctypes.sizeof(host_input), HIP_MEMCPY_HOST_TO_DEVICE
            ),
            "hipMemcpy input",
        )
        for name in ["scalar", "narrow", "simd"]:
            function = ctypes.c_void_p()
            hip.check(
                hip.lib.hipModuleGetFunction(
                    ctypes.byref(function), binary, f"positive_divisor_{name}".encode()
                ),
                "hipModuleGetFunction",
            )
            for divisor in divisors:
                if name == "simd":
                    params = [source, output, ctypes.c_int32(divisor)]
                    launch_and_check(hip, function, params, output, lanes, divisor)
                else:
                    scalar = ctypes.c_int64 if name == "narrow" else ctypes.c_int32
                    for dividend in dividends:
                        params = [output, scalar(dividend), scalar(divisor)]
                        launch_and_check(
                            hip,
                            function,
                            params,
                            output,
                            [dividend] * args.wave_size,
                            divisor,
                        )
            count = len(dividends) * len(divisors)
            print(f"{name}: {count} signed div/rem pairs passed")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--hip-lib", required=True)
    parser.add_argument("--wave-size", type=int, choices=[32, 64], required=True)
    parser.add_argument("hsaco", type=Path)
    run(parser.parse_args())


if __name__ == "__main__":
    main()
