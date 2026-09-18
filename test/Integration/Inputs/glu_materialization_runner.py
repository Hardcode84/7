# SPDX-FileCopyrightText: 2026 wave-mlir contributors
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

import argparse
import ctypes
from pathlib import Path

import numpy as np
from hip_runtime import Hip


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
    with Hip(args.hip_lib) as hip:
        binary = hip.load_module(args.hsaco)
        buffers = []
        for host in [a, b, bias, gate, output]:
            device = hip.allocate(host.nbytes)
            hip.copy_to_device(device, host)
            buffers.append(device)
        function = hip.get_function(binary, "tlx_addmm_glu_kernel_optimized")
        params = buffers + [ctypes.c_int32(v) for v in (m, n, k, k, n, n, n)]
        hip.launch(function, params, block=(512, 1, 1))
        hip.copy_from_device(buffers[-1], output)
        np.testing.assert_allclose(output, expected, rtol=0.003, atol=0.003)
    print("GLU materialization: 32768 outputs passed")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--hip-lib", required=True)
    parser.add_argument("hsaco", type=Path)
    run(parser.parse_args())


if __name__ == "__main__":
    main()
