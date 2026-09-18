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

from hip_runtime import Hip, kernel_arguments

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
    params = kernel_arguments((scratch, output))
    launch_kernel_ex = hip.bind(
        "hipDrvLaunchKernelEx",
        [
            ctypes.POINTER(HipLaunchConfig),
            ctypes.c_void_p,
            ctypes.POINTER(ctypes.c_void_p),
            ctypes.c_void_p,
        ],
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
        launch_kernel_ex(
            ctypes.byref(config),
            function,
            params,
            None,
        ),
        "hipDrvLaunchKernelEx",
    )
    hip.synchronize()


def run_kernel(
    hip: Hip,
    module: ctypes.c_void_p,
    kernel: str,
    scratch: ctypes.c_void_p,
    output: ctypes.c_void_p,
):
    function = hip.get_function(module, kernel)
    scratch_host = int_array(SENTINEL)
    output_host = int_array(SENTINEL)
    hip.copy_to_device(scratch, scratch_host)
    hip.copy_to_device(output, output_host)
    launch(hip, function, scratch, output)
    hip.copy_from_device(scratch, scratch_host)
    hip.copy_from_device(output, output_host)
    verify_scratch(scratch_host)
    verify_broadcast(output_host)


def run(args: argparse.Namespace):
    if not system_has_gfx1250():
        print("gfx1250 cluster runtime skipped: gfx1250 unavailable")
        return

    byte_count = WORKGROUPS * THREADS_PER_WORKGROUP * ctypes.sizeof(ctypes.c_int32)
    with Hip(find_hip_runtime()) as hip:
        binary = hip.load_module(args.hsaco)
        scratch = hip.allocate(byte_count)
        output = hip.allocate(byte_count)
        for kernel in ("gfx1250_cluster_load", "gfx1250_cluster_load_async"):
            run_kernel(hip, binary, kernel, scratch, output)
    print("gfx1250 cluster runtime passed")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--hsaco", type=Path, required=True)
    run(parser.parse_args())


if __name__ == "__main__":
    main()
