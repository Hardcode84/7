# SPDX-FileCopyrightText: 2026 wave-mlir contributors
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

import argparse
from pathlib import Path

import numpy as np
from cross_lane_exec import CASES, expected_output
from hip_runtime import Hip


def run(args):
    with Hip(args.hip_lib) as hip:
        device = hip.allocate(512 * 4)
        binaries = []
        for path in (args.original, args.optimized):
            binary = hip.load_module(path)
            binaries.append(binary)
        for kind, scenario in CASES:
            name = f"{kind}_{scenario}"
            expected = expected_output(kind, scenario)
            for variant, binary in zip(
                ("original", "optimized"), binaries, strict=True
            ):
                actual = np.full(512, -1, dtype=np.int32)
                hip.copy_to_device(device, actual)
                function = hip.get_function(binary, name)
                hip.launch(function, (device,), block=(256, 1, 1))
                hip.copy_from_device(device, actual)
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
