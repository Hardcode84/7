# SPDX-FileCopyrightText: 2026 wave-mlir contributors
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

import argparse
import ctypes
import random
import struct
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


def half_bits(value: float) -> int:
    return struct.unpack("<H", struct.pack("<e", value))[0]


def make_inputs(m: int, n: int, k: int, seed: int) -> tuple[list[int], list[int]]:
    rng = random.Random(seed)
    a = [half_bits(rng.randint(-8, 8) * 0.25) for _ in range(m * k)]
    b = [half_bits(rng.randint(-8, 8) * 0.25) for _ in range(n * k)]
    return a, b


def half_values(raw: list[int]) -> list[float]:
    return [struct.unpack("<e", struct.pack("<H", value))[0] for value in raw]


def reference_tile_major(
    a_raw: list[int], b_raw: list[int], m: int, n: int, k: int
) -> list[float]:
    a = half_values(a_raw)
    b = half_values(b_raw)
    out = []
    for tile_m in range(m // 16):
        for tile_n in range(n // 16):
            for mi in range(16):
                row = tile_m * 16 + mi
                for nj in range(16):
                    col = tile_n * 16 + nj
                    acc = 0.0
                    for kk in range(k):
                        acc += a[row * k + kk] * b[col * k + kk]
                    out.append(acc)
    return out


def as_array(ctype, values: list[int] | list[float]):
    array_type = ctype * len(values)
    return array_type(*values)


def ptr_to(value) -> ctypes.c_void_p:
    return ctypes.cast(ctypes.pointer(value), ctypes.c_void_p)


def copy_to_device(hip: Hip, device: ctypes.c_void_p, host):
    hip.check(
        hip.lib.hipMemcpy(
            device,
            ctypes.cast(host, ctypes.c_void_p),
            ctypes.sizeof(host),
            HIP_MEMCPY_HOST_TO_DEVICE,
        ),
        "hipMemcpy host-to-device",
    )


def copy_f32_from_device(hip: Hip, device: ctypes.c_void_p, count: int) -> list[float]:
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


def launch(hip: Hip, function: ctypes.c_void_p, grid_x: int, grid_y: int, *devs):
    args = [ctypes.c_void_p(dev.value) for dev in devs]
    params = (ctypes.c_void_p * len(args))(*(ptr_to(arg) for arg in args))
    hip.check(
        hip.lib.hipModuleLaunchKernel(
            function, grid_x, grid_y, 1, 32, 1, 1, 0, None, params, None
        ),
        "hipModuleLaunchKernel",
    )
    hip.check(hip.lib.hipDeviceSynchronize(), "hipDeviceSynchronize")


def check_close(got: list[float], expected: list[float], tolerance: float):
    tile_size = 256
    if len(got) % tile_size or len(expected) % tile_size:
        raise AssertionError("matmul output must contain whole 16x16 tiles")
    worst = 0.0
    worst_tile = 0
    worst_index = 0
    worst_actual = 0.0
    worst_ref = 0.0
    for tile in range(len(got) // tile_size):
        start = tile * tile_size
        got_tile = sorted(got[start : start + tile_size])
        ref_tile = sorted(expected[start : start + tile_size])
        for index, (actual, ref) in enumerate(zip(got_tile, ref_tile, strict=True)):
            diff = abs(actual - ref)
            if diff > worst:
                worst = diff
                worst_tile = tile
                worst_index = index
                worst_actual = actual
                worst_ref = ref
    if worst > tolerance:
        raise AssertionError(
            f"tile={worst_tile} index={worst_index} expected={worst_ref} "
            f"actual={worst_actual} diff={worst}"
        )
    print(f"max_abs_error={worst:.6f}")


def free_device(hip: Hip, device: ctypes.c_void_p, what: str):
    if device.value:
        hip.check(hip.lib.hipFree(device), what)


def run(args: argparse.Namespace):
    if args.m % 16 or args.n % 16 or args.k % 16:
        raise ValueError("m, n, and k must be multiples of 16")
    a_raw, b_raw = make_inputs(args.m, args.n, args.k, args.seed)
    expected = reference_tile_major(a_raw, b_raw, args.m, args.n, args.k)
    a_host = as_array(ctypes.c_uint16, a_raw)
    b_host = as_array(ctypes.c_uint16, b_raw)
    c_host = as_array(ctypes.c_float, [0.0] * len(expected))

    hip = Hip(args.hip_lib)
    hip.check(hip.lib.hipInit(0), "hipInit")
    module = ctypes.c_void_p()
    function = ctypes.c_void_p()
    devs = [ctypes.c_void_p() for _ in range(3)]

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
        for dev, host, name in zip(devs, (a_host, b_host, c_host), "abc", strict=True):
            hip.check(hip.lib.hipMalloc(ctypes.byref(dev), ctypes.sizeof(host)), name)
            copy_to_device(hip, dev, host)
        launch(hip, function, args.m // 16, args.n // 16, *devs)
        got = copy_f32_from_device(hip, devs[2], len(expected))
        check_close(got, expected, args.tolerance)
    finally:
        for dev, name in zip(
            devs, ("hipFree a", "hipFree b", "hipFree c"), strict=True
        ):
            free_device(hip, dev, name)
        hip.check(hip.lib.hipModuleUnload(module), "hipModuleUnload")
    print("wavec WMMA matmul random ok")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--hip-lib", required=True)
    parser.add_argument("--m", type=int, default=16)
    parser.add_argument("--n", type=int, default=16)
    parser.add_argument("--k", type=int, default=16)
    parser.add_argument("--seed", type=int, default=19)
    parser.add_argument("--tolerance", type=float, default=0.01)
    parser.add_argument("hsaco", type=Path)
    parser.add_argument("kernel")
    run(parser.parse_args())
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
