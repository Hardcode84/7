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


def quotient_remainder(value, divisor):
    value = ctypes.c_int32(value).value
    quotient = abs(value) // abs(divisor)
    if (value < 0) != (divisor < 0):
        quotient = -quotient
    return quotient, value - quotient * divisor


def expected_index(name, lane, case):
    x, d, y, e = case
    quotient, remainder = quotient_remainder(x + lane, d)
    if name == "inexact":
        remainder -= quotient
    if name == "multiple":
        remainder += quotient_remainder(y + lane, e)[1]
    return (4 * (128 + remainder)) % (1 << 32) // 4


def check_case(hip, function, source, output, name, case, wave_size):
    params = [source, output, *(ctypes.c_int32(v) for v in case)]
    args = (ctypes.c_void_p * len(params))(*(ptr_to(p) for p in params))
    sentinel = (ctypes.c_int32 * wave_size)(*([-1] * wave_size))
    hip.check(
        hip.lib.hipMemcpy(
            output, sentinel, ctypes.sizeof(sentinel), HIP_MEMCPY_HOST_TO_DEVICE
        ),
        "reset output",
    )
    hip.check(
        hip.lib.hipModuleLaunchKernel(
            function, 1, 1, 1, wave_size, 1, 1, 0, None, args, None
        ),
        "launch",
    )
    hip.check(hip.lib.hipDeviceSynchronize(), "synchronize")
    hip.check(
        hip.lib.hipMemcpy(
            sentinel, output, ctypes.sizeof(sentinel), HIP_MEMCPY_DEVICE_TO_HOST
        ),
        "read output",
    )
    for lane, actual in enumerate(sentinel):
        index = expected_index(name, lane, case)
        expected = 17 * index + 5 if index < 256 else 0
        if actual != expected:
            raise AssertionError(f"{name=} {case=} {lane=}: {actual=} != {expected=}")


def run(args):
    cases = [
        (-33, 7, 19, 5),
        (33, 7, -19, 5),
        (-33, -7, 19, -5),
        (33, -7, -19, -5),
        (-(1 << 31), 17, (1 << 31) - 1, -13),
        ((1 << 31) - 1, -17, -(1 << 31), 13),
        (-1, 1, 0, -1),
        (0, -3, -17, 7),
    ]
    hip = Hip(args.hip_lib)
    hip.check(hip.lib.hipInit(0), "hipInit")
    binary = ctypes.c_void_p()
    source = ctypes.c_void_p()
    output = ctypes.c_void_p()
    with ExitStack() as cleanup:
        hip.check(
            hip.lib.hipModuleLoad(ctypes.byref(binary), str(args.hsaco).encode()),
            "load kernel",
        )
        cleanup.callback(lambda: hip.check(hip.lib.hipModuleUnload(binary), "unload"))
        for device, size in [(source, 1024), (output, args.wave_size * 4)]:
            hip.check(hip.lib.hipMalloc(ctypes.byref(device), size), "allocate")
            cleanup.callback(lambda p=device: hip.check(hip.lib.hipFree(p), "free"))
        data = (ctypes.c_int32 * 256)(*(17 * i + 5 for i in range(256)))
        hip.check(
            hip.lib.hipMemcpy(
                source, data, ctypes.sizeof(data), HIP_MEMCPY_HOST_TO_DEVICE
            ),
            "write input",
        )
        for name in ["distributed", "inexact", "multiple"]:
            function = ctypes.c_void_p()
            hip.check(
                hip.lib.hipModuleGetFunction(
                    ctypes.byref(function), binary, f"{name}_remainder_address".encode()
                ),
                "get kernel",
            )
            for case in cases:
                check_case(hip, function, source, output, name, case, args.wave_size)
            print(f"{name}: {len(cases)} address cases passed")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--hip-lib", required=True)
    parser.add_argument("--wave-size", type=int, choices=[32, 64], required=True)
    parser.add_argument("hsaco", type=Path)
    run(parser.parse_args())


if __name__ == "__main__":
    main()
