# SPDX-FileCopyrightText: 2026 wave-mlir contributors
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

import argparse
import ctypes
import math
import random
import re
from pathlib import Path

from hip_runtime import Hip


def parse_sizes(raw: str, wave_size: int, workgroup_size: int) -> list[int]:
    if raw:
        return [int(item) for item in raw.split(",") if item]
    values = [
        0,
        1,
        wave_size - 1,
        wave_size,
        wave_size + 7,
        workgroup_size - 1,
        workgroup_size,
        workgroup_size + 7,
        2 * workgroup_size + 3,
    ]
    return sorted({value for value in values if value >= 0})


def parse_workgroup_size_from_wave_ir(path: Path, kernel: str) -> int | None:
    text = path.read_text()
    func_pattern = rf"func\.func\s+@{re.escape(kernel)}\b.*?attributes\s+\{{([^}}]*)\}}"
    func = re.search(func_pattern, text, re.DOTALL)
    if not func:
        return None
    attr_pattern = (
        r"(?:gpu\.known_block_size|wave\.workgroup_size)\s*=\s*"
        r"array<i32:\s*([0-9]+),\s*1,\s*1>"
    )
    match = re.search(attr_pattern, func.group(1))
    if not match:
        return None
    return int(match.group(1))


def resolve_workgroup_size(args: argparse.Namespace) -> int:
    workgroup_size = args.workgroup_size
    if args.wave_ir:
        sidecar_size = parse_workgroup_size_from_wave_ir(args.wave_ir, args.kernel)
        if sidecar_size is not None:
            workgroup_size = sidecar_size
    if workgroup_size is None:
        workgroup_size = args.wave_size
    if workgroup_size <= 0:
        raise ValueError("workgroup size must be positive")
    if workgroup_size % args.wave_size != 0:
        raise ValueError("workgroup size must be a multiple of wave size")
    return workgroup_size


def round_up(value: int, step: int) -> int:
    return ((value + step - 1) // step) * step


def make_data(count: int, seed: int) -> tuple[list[float], list[float]]:
    rng = random.Random(seed)
    x = [float(rng.randint(-17, 17)) for _ in range(count)]
    y = [float(rng.randint(-23, 23)) for _ in range(count)]
    return x, y


def as_float_array(values: list[float]):
    array_type = ctypes.c_float * len(values)
    return array_type(*values)


def check_result(
    got: list[float],
    x: list[float],
    y: list[float],
    alpha: float,
    n: int,
):
    if len(got) != len(x) or len(got) != len(y):
        raise AssertionError("SAXPY output and input sizes differ")
    for index, actual in enumerate(got):
        expected = y[index] + alpha * x[index] if index < n else y[index]
        if (
            not math.isfinite(actual)
            or not math.isfinite(expected)
            or abs(actual - expected) > 0.001
        ):
            raise AssertionError(
                f"n={n} index={index} expected={expected} actual={actual}"
            )


def run(args: argparse.Namespace):
    workgroup_size = resolve_workgroup_size(args)
    sizes = parse_sizes(args.sizes, args.wave_size, workgroup_size)
    elem_count = round_up(max([*sizes, 1]), workgroup_size)
    x, y = make_data(elem_count, args.seed)
    x_host, y_host = as_float_array(x), as_float_array(y)
    output = (ctypes.c_float * elem_count)()
    with Hip(args.hip_lib) as hip:
        binary = hip.load_module(args.hsaco)
        function = hip.get_function(binary, args.kernel)
        device_x = hip.allocate(ctypes.sizeof(x_host))
        device_y = hip.allocate(ctypes.sizeof(y_host))
        hip.copy_to_device(device_x, x_host)
        for n in sizes:
            hip.copy_to_device(device_y, y_host)
            hip.launch(
                function,
                (device_x, device_y, ctypes.c_float(args.alpha), ctypes.c_uint32(n)),
                block=(workgroup_size, 1, 1),
                grid=(elem_count // workgroup_size, 1, 1),
            )
            hip.copy_from_device(device_y, output)
            check_result(list(output), x, y, args.alpha, n)
            print(f"n={n} ok")
    print("saxpy ctypes runner ok")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--hip-lib", required=True)
    parser.add_argument("--wave-size", type=int, required=True)
    parser.add_argument("--workgroup-size", type=int)
    parser.add_argument("--wave-ir", type=Path)
    parser.add_argument("--alpha", type=float, default=1.5)
    parser.add_argument("--seed", type=int, default=17)
    parser.add_argument("--sizes", default="")
    parser.add_argument("hsaco", type=Path)
    parser.add_argument("kernel")
    run(parser.parse_args())
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
