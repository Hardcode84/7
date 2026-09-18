# SPDX-FileCopyrightText: 2026 wave-mlir contributors
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

"""HIP resources and synchronous launches for Integration tests."""

import ctypes
from contextlib import ExitStack


def kernel_arguments(values):
    return (ctypes.c_void_p * len(values))(
        *(ctypes.cast(ctypes.pointer(value), ctypes.c_void_p) for value in values)
    )


def host_bytes(host):
    return (ctypes.c_ubyte * memoryview(host).nbytes).from_buffer(host)


class Hip(ExitStack):
    def __init__(self, lib_path):
        super().__init__()
        self.lib = ctypes.CDLL(lib_path)
        pointer = ctypes.c_void_p
        pointer_out = ctypes.POINTER(pointer)
        uint = ctypes.c_uint
        self.bind("hipInit", [uint])
        self.bind("hipGetErrorString", [ctypes.c_int], ctypes.c_char_p)
        self.bind("hipMalloc", [pointer_out, ctypes.c_size_t])
        self.bind("hipFree", [pointer])
        self.bind("hipMemcpy", [pointer, pointer, ctypes.c_size_t, ctypes.c_int])
        self.bind("hipModuleLoad", [pointer_out, ctypes.c_char_p])
        self.bind("hipModuleUnload", [pointer])
        self.bind("hipModuleGetFunction", [pointer_out, pointer, ctypes.c_char_p])
        self.bind(
            "hipModuleLaunchKernel",
            [pointer, *([uint] * 7), pointer, pointer_out, pointer],
        )
        self.bind("hipDeviceSynchronize", [])
        self.check(self.lib.hipInit(0), "hipInit")

    def bind(self, name, arguments, result=ctypes.c_int):
        try:
            function = getattr(self.lib, name)
        except AttributeError as error:
            raise RuntimeError(f"HIP runtime does not provide {name}") from error
        function.argtypes = arguments
        function.restype = result
        return function

    def check(self, code, what):
        if code == 0:
            return
        raw = self.lib.hipGetErrorString(code)
        message = raw.decode() if raw else f"hip error {code}"
        raise RuntimeError(f"{what}: {message}")

    def allocate(self, size):
        device = ctypes.c_void_p()
        self.check(self.lib.hipMalloc(ctypes.byref(device), size), "hipMalloc")
        self.callback(lambda: self.check(self.lib.hipFree(device), "hipFree"))
        return device

    def load_module(self, path):
        binary = ctypes.c_void_p()
        self.check(
            self.lib.hipModuleLoad(ctypes.byref(binary), str(path).encode()),
            "hipModuleLoad",
        )
        self.callback(
            lambda: self.check(self.lib.hipModuleUnload(binary), "hipModuleUnload")
        )
        return binary

    def get_function(self, binary, name):
        function = ctypes.c_void_p()
        self.check(
            self.lib.hipModuleGetFunction(
                ctypes.byref(function), binary, name.encode()
            ),
            f"hipModuleGetFunction {name}",
        )
        return function

    def copy_to_device(self, device, host):
        data = host_bytes(host)
        self.check(
            self.lib.hipMemcpy(device, data, ctypes.sizeof(data), 1),
            "hipMemcpy host-to-device",
        )

    def copy_from_device(self, device, host):
        data = host_bytes(host)
        self.check(
            self.lib.hipMemcpy(data, device, ctypes.sizeof(data), 2),
            "hipMemcpy device-to-host",
        )

    def synchronize(self):
        self.check(self.lib.hipDeviceSynchronize(), "hipDeviceSynchronize")

    def launch(self, function, arguments, *, block, grid=(1, 1, 1), shared_mem=0):
        params = kernel_arguments(arguments)
        self.check(
            self.lib.hipModuleLaunchKernel(
                function, *grid, *block, shared_mem, None, params, None
            ),
            "hipModuleLaunchKernel",
        )
        self.synchronize()
