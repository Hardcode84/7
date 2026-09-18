# SPDX-FileCopyrightText: 2026 wave-mlir contributors
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

import argparse
import ctypes
from contextlib import ExitStack
from pathlib import Path

import numpy as np
from cross_lane_exec import CASES, expected_output
from half_broadcast_runner import launch
from wavec_saxpy_ctypes_runner import Hip


def run(args):
    hip = Hip(args.hip_lib)
    hip.check(hip.lib.hipInit(0), "initialize HIP")
    with ExitStack() as cleanup:
        device = ctypes.c_void_p()
        hip.check(hip.lib.hipMalloc(ctypes.byref(device), 512 * 4), "allocate")
        cleanup.callback(lambda: hip.check(hip.lib.hipFree(device), "free"))
        binaries = []
        for path in (args.original, args.optimized):
            binary = ctypes.c_void_p()
            hip.check(
                hip.lib.hipModuleLoad(ctypes.byref(binary), str(path).encode()), "load"
            )
            cleanup.callback(
                lambda b=binary: hip.check(hip.lib.hipModuleUnload(b), "unload")
            )
            binaries.append(binary)
        for kind, scenario in CASES:
            name = f"{kind}_{scenario}"
            expected = expected_output(kind, scenario)
            for variant, binary in zip(
                ("original", "optimized"), binaries, strict=True
            ):
                actual = launch(hip, binary, name, device)
                np.testing.assert_array_equal(
                    actual, expected, err_msg=f"{variant} {name}"
                )
    print(
        f"Cross-lane EXEC: {len(CASES)} kernels, 4 waves, "
        f"{len(CASES) * 1024} outputs passed"
    )


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--hip-lib", required=True)
    parser.add_argument("original", type=Path)
    parser.add_argument("optimized", type=Path)
    run(parser.parse_args())
