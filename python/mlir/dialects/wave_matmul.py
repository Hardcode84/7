#  Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
#  See https://llvm.org/LICENSE.txt for license information.
#  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

"""Builder for the tiled WMMA f16xf16xf32 matmul kernel + host driver.

This module assembles the module *programmatically* through the MLIR
Python bindings (see :mod:`wave_dsl`). It returns a live
:class:`mlir.ir.Module` that everything else (``wave-opt``,
``mlir-runner``, ...) can consume.
"""

from __future__ import annotations

from dataclasses import dataclass

from mlir.ir import Module

from . import wave_dsl as dsl


def _is_power_of_two(value: int) -> bool:
    return value > 0 and (value & (value - 1)) == 0


@dataclass(frozen=True)
class _MatmulConfig:
    M: int
    N: int
    K: int
    BM: int
    BN: int

    def __post_init__(self) -> None:
        for dim, val in (("M", self.M), ("N", self.N), ("K", self.K)):
            if val <= 0 or val % 16 != 0:
                raise ValueError(f"{dim} must be a positive multiple of 16; got {val}")
        tile = self.BM * self.BN
        if tile not in (1, 2, 4, 8):
            raise ValueError(
                "BM*BN must be a power of two in {1, 2, 4, 8}; "
                f"got BM={self.BM}, BN={self.BN} (product={tile})"
            )
        total = self.M * self.N
        per_wg = 256 * tile
        if total % per_wg != 0:
            raise ValueError(
                f"M*N (={total}) must be divisible by 256 * BM*BN (={per_wg})"
            )
        if not _is_power_of_two(per_wg):
            raise ValueError(
                "256 * BM*BN must be a power of two; " f"got 256 * {tile} = {per_wg}"
            )

    @property
    def total_elements(self) -> int:
        return self.M * self.N

    @property
    def waves_per_workgroup(self) -> int:
        return self.BM * self.BN

    @property
    def threads_per_workgroup(self) -> int:
        return 32 * self.waves_per_workgroup

    @property
    def num_workgroups(self) -> int:
        return self.total_elements // (256 * self.waves_per_workgroup)

    @property
    def k_steps(self) -> int:
        return self.K // 16

    @property
    def log2_workgroup_i32_stride(self) -> int:
        # i32 element stride per workgroup = 256 * BM*BN.
        return (256 * self.waves_per_workgroup).bit_length() - 1


_KERNEL_NAME = "wmma_f16_matmul_tiled"
_GPU_MODULE_NAME = "kernels"
_RUNTIME_HELPER = "wave_memref_to_ptr_global_f32"
_PRINT_HELPER = "printMemrefF32"
_MMA_KIND = "wmma.f32.16x16x16.f16"

# (f16)1.0 packed twice into one i32, the source bit pattern that
# `waveamd.fragment_fill` uses to broadcast a constant into each
# 32-bit register of an A/B f16 fragment.
_F16_ONES_BITS = 0x3C003C00


def _emit_kernel(bld: dsl.FunctionBuilder, cfg: _MatmulConfig) -> None:
    """Populate the tiled matmul kernel body.

    Each wave owns one 16x16 output tile. The kernel computes:

    * wave byte slot inside the workgroup:
        ``(workitem_id_x AND ~31) * 32``  (= wave_id * 1024 bytes)
    * workgroup byte slot inside the output buffer:
        ``workgroup_id_x * (256 * BM*BN * 4)``  bytes

    The K-loop is unrolled in Python: each step chains a
    ``waveamd.mma`` whose A/B operands come from ``waveamd.fragment_fill``
    of an all-ones f16 vector, so the per-element output is exactly
    ``K`` (as an f32).
    """
    ones_f16x2 = bld.constant_i32(_F16_ONES_BITS)
    # (f32)0.0 shares its bit pattern with i32 zero, so fragment_fill can
    # still take an i32 source even though the accumulator is f32.
    acc_init = bld.constant_i32(0)
    neg32 = bld.constant_i32(-32)
    c3 = bld.constant_i32(3)
    wg_shift = bld.constant_i32(cfg.log2_workgroup_i32_stride)

    wi = bld.workitem_id(axis=0)
    vneg32 = bld.splat(neg32)
    wave_base = bld.binary("andi", wi, vneg32)
    v3 = bld.splat(c3)
    wave_off = bld.binary("shli", wave_base, v3)

    wg = bld.workgroup_id(axis=0)
    vwg = bld.splat(wg)
    vshift = bld.splat(wg_shift)
    wg_off = bld.binary("shli", vwg, vshift)

    total = bld.binary("addi", wg_off, wave_off)
    ptr = bld.ptr_add(bld.args[0], total)

    a_type = dsl.fragment_type(0, dsl.f16(), 16, 16, 32, 8)
    b_type = dsl.fragment_type(1, dsl.f16(), 16, 16, 32, 8)
    acc_type = dsl.fragment_type(2, dsl.f32(), 16, 16, 32, 8)

    acc = bld.fragment_fill(acc_init, acc_type)
    for _ in range(cfg.k_steps):
        a = bld.fragment_fill(ones_f16x2, a_type)
        b = bld.fragment_fill(ones_f16x2, b_type)
        acc = bld.mma(_MMA_KIND, a, b, acc)

    bld.fragment_store(acc, ptr)


def _emit_host(bld: dsl.FunctionBuilder, cfg: _MatmulConfig) -> None:
    """Populate the host ``main`` that allocates, launches, and prints."""
    c0 = bld.constant_index(0)
    c1 = bld.constant_index(1)
    blocks = bld.constant_index(cfg.num_workgroups)
    threads = bld.constant_index(cfg.threads_per_workgroup)
    ctotal = bld.constant_index(cfg.total_elements)
    zero = bld.constant_f32(0.0)

    storage = bld.alloc([cfg.total_elements], dsl.f32())
    with bld.for_loop(c0, ctotal, c1) as i:
        bld.memref_store(zero, storage, [i])
    unranked = bld.cast_unranked(storage)
    bld.host_register(unranked)

    [ptr] = bld.call(_RUNTIME_HELPER, [storage], [dsl.ptr_type(dsl.f32())])
    bld.launch(
        _GPU_MODULE_NAME,
        _KERNEL_NAME,
        grid=(blocks, c1, c1),
        block=(threads, c1, c1),
        operands=[ptr],
    )
    bld.call(_PRINT_HELPER, [unranked])


def build_wmma_f16_matmul_module(
    M: int, N: int, K: int, *, BM: int = 1, BN: int = 1
) -> Module:
    """Return an MLIR :class:`Module` for the tiled WMMA f16 matmul.

    The kernel multiplies ``MxK`` by ``KxN`` (both filled with ones via
    ``waveamd.fragment_fill``, the A/B operands are f16) and writes the
    result into an ``MxN``-element ``f32`` buffer using
    ``wmma.f32.16x16x16.f16``. The output layout is "tile block": each
    16x16 tile occupies 256 contiguous f32 elements (1024 bytes), so
    the host-side check is trivially ``output[i] == K`` for all ``i``.

    Constraints:
      * ``M``, ``N``, ``K`` are positive multiples of 16.
      * ``BM * BN`` is a power of two in ``{1, 2, 4, 8}`` (one wave per
        16x16 tile, ``BM * BN`` waves per workgroup).
      * ``M * N`` is divisible by ``256 * BM * BN``.

    Note: the returned :class:`Module` is bound to a fresh MLIR
    :class:`Context` owned by the temporary :class:`ModuleBuilder`. The
    ``__exit__`` releases all thread-local handles before returning, so
    callers can keep using the module (e.g. printing, pass-managing)
    without further setup.
    """
    cfg = _MatmulConfig(M=M, N=N, K=K, BM=BM, BN=BN)
    bld = dsl.ModuleBuilder()
    with bld:
        bld.declare_external(
            _RUNTIME_HELPER,
            [dsl.MemRefType.get([cfg.total_elements], dsl.f32())],
            [dsl.ptr_type(dsl.f32())],
        )
        bld.declare_external(
            _PRINT_HELPER,
            [dsl.unranked_memref_type(dsl.f32())],
            [],
        )

        with (
            bld.gpu_module(_GPU_MODULE_NAME) as gmod,
            gmod.kernel(_KERNEL_NAME, [dsl.ptr_type(dsl.f32())]) as fb,
        ):
            _emit_kernel(fb, cfg)

        with bld.host_main() as fb:
            _emit_host(fb, cfg)

    return bld.module


__all__ = ["build_wmma_f16_matmul_module"]
