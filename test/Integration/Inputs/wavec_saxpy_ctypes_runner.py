# SPDX-FileCopyrightText: 2026 wave-mlir contributors
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

import argparse
import ctypes
import random
import re
from pathlib import Path

HIP_MEMCPY_HOST_TO_DEVICE = 1
HIP_MEMCPY_DEVICE_TO_HOST = 2


class Hip:
    def __init__(self, lib_path: str):
        self.lib = ctypes.CDLL(lib_path)
        self._bind()

    def _bind(self):
        self.lib.hipInit.argtypes = [ctypes.c_uint]
        self.lib.hipInit.restype = ctypes.c_int
        self.lib.hipGetErrorString.argtypes = [ctypes.c_int]
        self.lib.hipGetErrorString.restype = ctypes.c_char_p
        self.lib.hipMalloc.argtypes = [ctypes.POINTER(ctypes.c_void_p), ctypes.c_size_t]
        self.lib.hipMalloc.restype = ctypes.c_int
        self.lib.hipFree.argtypes = [ctypes.c_void_p]
        self.lib.hipFree.restype = ctypes.c_int
        self.lib.hipMemcpy.argtypes = [
            ctypes.c_void_p,
            ctypes.c_void_p,
            ctypes.c_size_t,
            ctypes.c_int,
        ]
        self.lib.hipMemcpy.restype = ctypes.c_int
        self.lib.hipModuleLoad.argtypes = [
            ctypes.POINTER(ctypes.c_void_p),
            ctypes.c_char_p,
        ]
        self.lib.hipModuleLoad.restype = ctypes.c_int
        self.lib.hipModuleUnload.argtypes = [ctypes.c_void_p]
        self.lib.hipModuleUnload.restype = ctypes.c_int
        self.lib.hipModuleGetFunction.argtypes = [
            ctypes.POINTER(ctypes.c_void_p),
            ctypes.c_void_p,
            ctypes.c_char_p,
        ]
        self.lib.hipModuleGetFunction.restype = ctypes.c_int
        self.lib.hipModuleLaunchKernel.argtypes = [
            ctypes.c_void_p,
            ctypes.c_uint,
            ctypes.c_uint,
            ctypes.c_uint,
            ctypes.c_uint,
            ctypes.c_uint,
            ctypes.c_uint,
            ctypes.c_uint,
            ctypes.c_void_p,
            ctypes.POINTER(ctypes.c_void_p),
            ctypes.c_void_p,
        ]
        self.lib.hipModuleLaunchKernel.restype = ctypes.c_int
        self.lib.hipDeviceSynchronize.argtypes = []
        self.lib.hipDeviceSynchronize.restype = ctypes.c_int

    def check(self, code: int, what: str):
        if code == 0:
            return
        raw = self.lib.hipGetErrorString(code)
        message = raw.decode() if raw else f"hip error {code}"
        raise RuntimeError(f"{what}: {message}")


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


def ptr_to(value) -> ctypes.c_void_p:
    return ctypes.cast(ctypes.pointer(value), ctypes.c_void_p)


def copy_to_device(hip: Hip, device: ctypes.c_void_p, values: list[float]):
    host = as_float_array(values)
    hip.check(
        hip.lib.hipMemcpy(
            device,
            ctypes.cast(host, ctypes.c_void_p),
            ctypes.sizeof(host),
            HIP_MEMCPY_HOST_TO_DEVICE,
        ),
        "hipMemcpy host-to-device",
    )


def copy_from_device(hip: Hip, device: ctypes.c_void_p, count: int) -> list[float]:
    host = (ctypes.c_float * count)()
    hip.check(
        hip.lib.hipMemcpy(
            ctypes.cast(host, ctypes.c_void_p),
            device,
            ctypes.sizeof(host),
            HIP_MEMCPY_DEVICE_TO_HOST,
        ),
        "hipMemcpy device-to-host",
    )
    return list(host)


def free_device(hip: Hip, device: ctypes.c_void_p, what: str):
    if device.value:
        hip.check(hip.lib.hipFree(device), what)


def launch_saxpy(
    hip: Hip,
    function: ctypes.c_void_p,
    workgroup_size: int,
    grid_x: int,
    device_x: ctypes.c_void_p,
    device_y: ctypes.c_void_p,
    alpha: float,
    n: int,
):
    x_arg = ctypes.c_void_p(device_x.value)
    y_arg = ctypes.c_void_p(device_y.value)
    alpha_arg = ctypes.c_float(alpha)
    n_arg = ctypes.c_uint32(n)
    params = (ctypes.c_void_p * 4)(
        ptr_to(x_arg),
        ptr_to(y_arg),
        ptr_to(alpha_arg),
        ptr_to(n_arg),
    )
    hip.check(
        hip.lib.hipModuleLaunchKernel(
            function,
            grid_x,
            1,
            1,
            workgroup_size,
            1,
            1,
            0,
            None,
            params,
            None,
        ),
        "hipModuleLaunchKernel",
    )
    hip.check(hip.lib.hipDeviceSynchronize(), "hipDeviceSynchronize")


def check_result(
    got: list[float],
    x: list[float],
    y: list[float],
    alpha: float,
    n: int,
):
    for index, actual in enumerate(got):
        expected = y[index] + alpha * x[index] if index < n else y[index]
        if abs(actual - expected) > 0.001:
            raise AssertionError(
                f"n={n} index={index} expected={expected} actual={actual}"
            )


def run(args: argparse.Namespace):
    workgroup_size = resolve_workgroup_size(args)
    sizes = parse_sizes(args.sizes, args.wave_size, workgroup_size)
    elem_count = round_up(max([*sizes, 1]), workgroup_size)
    x, y = make_data(elem_count, args.seed)

    hip = Hip(args.hip_lib)
    hip.check(hip.lib.hipInit(0), "hipInit")

    module = ctypes.c_void_p()
    function = ctypes.c_void_p()
    device_x = ctypes.c_void_p()
    device_y = ctypes.c_void_p()
    byte_count = elem_count * ctypes.sizeof(ctypes.c_float)

    hip.check(
        hip.lib.hipModuleLoad(ctypes.byref(module), str(args.hsaco).encode()),
        "hipModuleLoad",
    )
    try:
        hip.check(
            hip.lib.hipModuleGetFunction(
                ctypes.byref(function), module, args.kernel.encode()
            ),
            "hipModuleGetFunction",
        )
        hip.check(hip.lib.hipMalloc(ctypes.byref(device_x), byte_count), "hipMalloc x")
        hip.check(hip.lib.hipMalloc(ctypes.byref(device_y), byte_count), "hipMalloc y")
        try:
            copy_to_device(hip, device_x, x)
            grid_x = elem_count // workgroup_size
            for n in sizes:
                copy_to_device(hip, device_y, y)
                launch_saxpy(
                    hip,
                    function,
                    workgroup_size,
                    grid_x,
                    device_x,
                    device_y,
                    args.alpha,
                    n,
                )
                got = copy_from_device(hip, device_y, elem_count)
                check_result(got, x, y, args.alpha, n)
                print(f"n={n} ok")
        finally:
            free_device(hip, device_x, "hipFree x")
            free_device(hip, device_y, "hipFree y")
    finally:
        hip.check(hip.lib.hipModuleUnload(module), "hipModuleUnload")
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
