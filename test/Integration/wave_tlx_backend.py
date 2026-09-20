# RUN: %python %s
# REQUIRES: wave-python-bindings, tlx-wave-backend
# SPDX-FileCopyrightText: 2026 wave-mlir contributors
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

import tempfile

import triton
import triton.language as tl
from triton import knobs
from triton.backends import backends
from triton.backends.compiler import GPUTarget
from triton.compiler import ASTSource


@triton.jit
def add_one(source, output, BLOCK: tl.constexpr):
    offsets = tl.arange(0, BLOCK)
    value = tl.load(source + offsets)
    tl.store(output + offsets, value + 1)


def main():
    assert backends["tlx_wave"].compiler.__module__ == "wave_tlx.compiler"
    assert backends["tlx_wave"].driver.__module__ == "wave_tlx.driver"
    with tempfile.TemporaryDirectory() as cache, knobs.cache.scope():
        knobs.cache.dir = cache
        for arch, block in (("gfx942", 64), ("gfx950", 128)):
            source = ASTSource(
                fn=add_one,
                signature={"source": "*i32", "output": "*i32", "BLOCK": "constexpr"},
                constexprs={"BLOCK": block},
                attrs={
                    (0,): [["tt.pointer_range", 32]],
                    (1,): [["tt.pointer_range", 32]],
                },
            )
            compiled = triton.compile(
                source,
                target=GPUTarget("tlx_wave", arch, 64),
                options={"num_warps": 1},
            )
            assert compiled.asm["hsaco"].startswith(b"\x7fELF")
            assert "wave.scatter" in compiled.asm["wave"]
            assert compiled.metadata.tlx_wave_arch == arch
            assert compiled.metadata.tlx_wave_num_kernel_args == 2
            assert compiled.metadata.tlx_wave_workgroup_size == 64
            assert compiled.metadata.shared == 0


if __name__ == "__main__":
    main()
