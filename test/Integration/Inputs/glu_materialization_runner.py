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
    m, n, k = 128, 256, 256
    rng = np.random.default_rng(17)
    a = rng.uniform(-0.25, 0.25, (m, k)).astype(np.float16)
    b = rng.uniform(-0.25, 0.25, (k, n)).astype(np.float16)
    bias = rng.uniform(-0.25, 0.25, n).astype(np.float16)
    gate = rng.uniform(-0.5, 0.5, (m, n)).astype(np.float16)
    output = np.full((m, n), np.nan, dtype=np.float16)
    expected = a.astype(np.float32) @ b.astype(np.float32) + bias.astype(np.float32)
    expected = (expected * (1 + gate.astype(np.float32))).astype(np.float16)
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
        for host in [a, b, bias, gate, output]:
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
                ctypes.byref(function), binary, b"tlx_addmm_glu_kernel_optimized"
            ),
            "hipModuleGetFunction",
        )
        params = buffers + [ctypes.c_int32(v) for v in (m, n, k, k, n, n, n)]
        arguments = (ctypes.c_void_p * len(params))(*(ptr_to(p) for p in params))
        hip.check(
            hip.lib.hipModuleLaunchKernel(
                function, 1, 1, 1, 512, 1, 1, 0, None, arguments, None
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
        np.testing.assert_allclose(output, expected, rtol=0.003, atol=0.003)
    print("GLU materialization: 32768 outputs passed")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--hip-lib", required=True)
    parser.add_argument("hsaco", type=Path)
    run(parser.parse_args())


if __name__ == "__main__":
    main()
