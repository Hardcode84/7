# SPDX-FileCopyrightText: 2026 wave-mlir contributors
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

import argparse
import ctypes
import ctypes.util
import os
import re
import shutil
import subprocess
from pathlib import Path
from typing import ClassVar

HIP_MEMCPY_HOST_TO_DEVICE = 1
HIP_MEMCPY_DEVICE_TO_HOST = 2
HIP_LAUNCH_ATTRIBUTE_CLUSTER_DIMENSION = 4
WORKGROUPS = 8
WORKGROUPS_PER_CLUSTER = 4
THREADS_PER_WORKGROUP = 128
SENTINEL = -1


class HipDim3(ctypes.Structure):
    _fields_: ClassVar[list[tuple[str, object]]] = [
        ("x", ctypes.c_uint),
        ("y", ctypes.c_uint),
        ("z", ctypes.c_uint),
    ]


class HipLaunchAttributeValue(ctypes.Union):
    _fields_: ClassVar[list[tuple[str, object]]] = [
        ("pad", ctypes.c_char * 64),
        ("cluster_dim", HipDim3),
    ]


class HipLaunchAttribute(ctypes.Structure):
    _fields_: ClassVar[list[tuple[str, object]]] = [
        ("id", ctypes.c_int),
        ("pad", ctypes.c_char * 4),
        ("value", HipLaunchAttributeValue),
    ]


class HipLaunchConfig(ctypes.Structure):
    _fields_: ClassVar[list[tuple[str, object]]] = [
        ("grid_dim_x", ctypes.c_uint),
        ("grid_dim_y", ctypes.c_uint),
        ("grid_dim_z", ctypes.c_uint),
        ("block_dim_x", ctypes.c_uint),
        ("block_dim_y", ctypes.c_uint),
        ("block_dim_z", ctypes.c_uint),
        ("shared_mem_bytes", ctypes.c_uint),
        ("stream", ctypes.c_void_p),
        ("attrs", ctypes.POINTER(HipLaunchAttribute)),
        ("num_attrs", ctypes.c_uint),
    ]


assert HipLaunchAttribute.value.offset == 8
assert ctypes.sizeof(HipLaunchAttributeValue) == 64
assert ctypes.sizeof(HipLaunchAttribute) == 72
assert HipLaunchConfig.stream.offset == 32
assert HipLaunchConfig.attrs.offset == 40
assert HipLaunchConfig.num_attrs.offset == 48
assert ctypes.sizeof(HipLaunchConfig) == 56


class Hip:
    def __init__(self, lib_path: str):
        self.lib = ctypes.CDLL(lib_path)
        self._bind()

    def _bind(self):
        self.lib.hipInit.argtypes = [ctypes.c_uint]
        self.lib.hipInit.restype = ctypes.c_int
        self.lib.hipGetErrorString.argtypes = [ctypes.c_int]
        self.lib.hipGetErrorString.restype = ctypes.c_char_p
        self.lib.hipMalloc.argtypes = [
            ctypes.POINTER(ctypes.c_void_p),
            ctypes.c_size_t,
        ]
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
        try:
            self.launch_kernel_ex = self.lib.hipDrvLaunchKernelEx
        except AttributeError as error:
            raise RuntimeError(
                "gfx1250 cluster launch requires hipDrvLaunchKernelEx"
            ) from error
        self.launch_kernel_ex.argtypes = [
            ctypes.POINTER(HipLaunchConfig),
            ctypes.c_void_p,
            ctypes.POINTER(ctypes.c_void_p),
            ctypes.c_void_p,
        ]
        self.launch_kernel_ex.restype = ctypes.c_int
        self.lib.hipDeviceSynchronize.argtypes = []
        self.lib.hipDeviceSynchronize.restype = ctypes.c_int

    def check(self, code: int, what: str):
        if code == 0:
            return
        raw = self.lib.hipGetErrorString(code)
        message = raw.decode() if raw else f"hip error {code}"
        raise RuntimeError(f"{what}: {message}")


def system_has_gfx1250() -> bool:
    rocminfo = shutil.which("rocminfo")
    if not rocminfo:
        return False
    try:
        result = subprocess.run(
            [rocminfo],
            capture_output=True,
            text=True,
            timeout=30,
            check=False,
        )
    except (OSError, subprocess.SubprocessError):
        return False
    if result.returncode != 0:
        return False
    targets = set(re.findall(r"gfx[0-9]{3,4}[a-z0-9]*", result.stdout))
    return "gfx1250" in targets


def find_hip_runtime() -> str:
    override = os.environ.get("HIP_RUNTIME_LIB")
    candidates = [
        Path(override) if override else None,
        Path("/opt/rocm/lib/libamdhip64.so"),
        Path("/opt/rocm/lib64/libamdhip64.so"),
    ]
    for candidate in candidates:
        if candidate and candidate.is_file():
            return str(candidate)
    found = ctypes.util.find_library("amdhip64")
    if found:
        return found
    raise RuntimeError("gfx1250 runtime test requires libamdhip64.so")


def int_array(value: int):
    count = WORKGROUPS * THREADS_PER_WORKGROUP
    return (ctypes.c_int32 * count)(*([value] * count))


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


def copy_from_device(hip: Hip, device: ctypes.c_void_p):
    host = int_array(SENTINEL)
    hip.check(
        hip.lib.hipMemcpy(
            ctypes.cast(host, ctypes.c_void_p),
            device,
            ctypes.sizeof(host),
            HIP_MEMCPY_DEVICE_TO_HOST,
        ),
        "hipMemcpy device-to-host",
    )
    return host


def verify_scratch(values):
    for workgroup in range(WORKGROUPS):
        for thread in range(THREADS_PER_WORKGROUP):
            index = workgroup * THREADS_PER_WORKGROUP + thread
            if values[index] != index:
                raise AssertionError(
                    f"scratch[{index}] expected={index} actual={values[index]}"
                )


def verify_broadcast(values):
    for workgroup in range(WORKGROUPS):
        cluster_base = (workgroup // WORKGROUPS_PER_CLUSTER) * WORKGROUPS_PER_CLUSTER
        for thread in range(THREADS_PER_WORKGROUP):
            index = workgroup * THREADS_PER_WORKGROUP + thread
            expected = cluster_base * THREADS_PER_WORKGROUP + thread
            actual = values[index]
            if actual == SENTINEL:
                raise AssertionError(f"output[{index}] retained sentinel")
            if actual != expected:
                raise AssertionError(
                    f"output[{index}] expected={expected} actual={actual}"
                )


def launch(
    hip: Hip,
    function: ctypes.c_void_p,
    scratch: ctypes.c_void_p,
    output: ctypes.c_void_p,
):
    scratch_arg = ctypes.c_void_p(scratch.value)
    output_arg = ctypes.c_void_p(output.value)
    params = (ctypes.c_void_p * 2)(
        ptr_to(scratch_arg),
        ptr_to(output_arg),
    )
    attr = HipLaunchAttribute()
    attr.id = HIP_LAUNCH_ATTRIBUTE_CLUSTER_DIMENSION
    attr.value.cluster_dim = HipDim3(WORKGROUPS_PER_CLUSTER, 1, 1)
    config = HipLaunchConfig(
        WORKGROUPS,
        1,
        1,
        THREADS_PER_WORKGROUP,
        1,
        1,
        0,
        None,
        ctypes.pointer(attr),
        1,
    )
    hip.check(
        hip.launch_kernel_ex(
            ctypes.byref(config),
            function,
            params,
            None,
        ),
        "hipDrvLaunchKernelEx",
    )
    hip.check(hip.lib.hipDeviceSynchronize(), "hipDeviceSynchronize")


def run_kernel(
    hip: Hip,
    module: ctypes.c_void_p,
    kernel: str,
    scratch: ctypes.c_void_p,
    output: ctypes.c_void_p,
):
    function = ctypes.c_void_p()
    hip.check(
        hip.lib.hipModuleGetFunction(
            ctypes.byref(function),
            module,
            kernel.encode(),
        ),
        "hipModuleGetFunction",
    )
    scratch_seed = int_array(SENTINEL)
    output_seed = int_array(SENTINEL)
    copy_to_device(hip, scratch, scratch_seed)
    copy_to_device(hip, output, output_seed)
    launch(hip, function, scratch, output)
    verify_scratch(copy_from_device(hip, scratch))
    verify_broadcast(copy_from_device(hip, output))


def run(args: argparse.Namespace):
    if not system_has_gfx1250():
        print("gfx1250 cluster runtime skipped: gfx1250 unavailable")
        return

    hip = Hip(find_hip_runtime())
    hip.check(hip.lib.hipInit(0), "hipInit")
    module = ctypes.c_void_p()
    scratch = ctypes.c_void_p()
    output = ctypes.c_void_p()
    byte_count = WORKGROUPS * THREADS_PER_WORKGROUP * ctypes.sizeof(ctypes.c_int32)
    hip.check(
        hip.lib.hipModuleLoad(ctypes.byref(module), str(args.hsaco).encode()),
        "hipModuleLoad",
    )
    try:
        try:
            hip.check(
                hip.lib.hipMalloc(ctypes.byref(scratch), byte_count),
                "hipMalloc scratch",
            )
            hip.check(
                hip.lib.hipMalloc(ctypes.byref(output), byte_count),
                "hipMalloc output",
            )
            for kernel in ("gfx1250_cluster_load", "gfx1250_cluster_load_async"):
                run_kernel(hip, module, kernel, scratch, output)
        finally:
            if output.value:
                hip.check(hip.lib.hipFree(output), "hipFree output")
            if scratch.value:
                hip.check(hip.lib.hipFree(scratch), "hipFree scratch")
    finally:
        hip.check(hip.lib.hipModuleUnload(module), "hipModuleUnload")
    print("gfx1250 cluster runtime passed")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--hsaco", type=Path, required=True)
    run(parser.parse_args())


if __name__ == "__main__":
    main()
