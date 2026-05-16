#  Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
#  See https://llvm.org/LICENSE.txt for license information.
#  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

"""Builder for the tiled WMMA f16xf16xf32 matmul kernel + host driver.

This module assembles the module *programmatically* through the MLIR
Python bindings (see :mod:`wave_dsl`). It returns a live
:class:`mlir.ir.Module` that everything else (``wave-opt``,
``mlir-runner``, ...) can consume.

The kernel reads A and B from global memory through ``wave.load`` +
``waveamd.fragment_pack`` (the ``fragment_load`` DSL helper) and stores
the f32 accumulator with ``waveamd.fragment_store``. To keep the per-lane
address arithmetic representable with the shift/and ops the current Wave
backend exposes, the builder restricts itself to:

* ``M = 16`` (one M-tile, no m_tile decomposition needed)
* ``N`` is a power-of-two multiple of 16 (``n_tile = workgroup_id``)
* ``K`` is a power-of-two multiple of 16 (per-row stride is a shift)
* ``BM = BN = 1`` (one wave per workgroup, one 16x16 tile per workgroup)
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
        if self.M != 16:
            raise ValueError(
                "v1 of the real-load matmul only supports M=16 (single M-tile); "
                f"got M={self.M}"
            )
        if not _is_power_of_two(self.N // 16):
            raise ValueError(
                "N/16 must be a power of two (so n_tile = workgroup_id with no "
                f"divisions); got N={self.N}"
            )
        if not _is_power_of_two(self.K // 16):
            raise ValueError(
                "K/16 must be a power of two (so per-row stride is a shift); "
                f"got K={self.K}"
            )
        if self.BM != 1 or self.BN != 1:
            raise ValueError(
                "v1 of the real-load matmul only supports BM=BN=1 (one wave per "
                f"workgroup); got BM={self.BM}, BN={self.BN}"
            )

    @property
    def total_elements(self) -> int:
        return self.M * self.N

    @property
    def a_elements(self) -> int:
        return self.M * self.K

    @property
    def b_elements(self) -> int:
        # B is laid out in column-major K x N order (== row-major N x K), so
        # lane L's contiguous-16-f16 slice for column j lives at j * K.
        return self.N * self.K

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

    @property
    def log2_K(self) -> int:
        return self.K.bit_length() - 1


_KERNEL_NAME = "wmma_f16_matmul_tiled"
_GPU_MODULE_NAME = "kernels"
_F16_PTR_HELPER = "wave_memref_to_ptr_global_f16"
_F32_PTR_HELPER = "wave_memref_to_ptr_global_f32"
_PRINT_HELPER = "printMemrefF32"
_MMA_KIND = "wmma.f32.16x16x16.f16"


def _emit_kernel(bld: dsl.FunctionBuilder, cfg: _MatmulConfig) -> None:
    """Populate the tiled matmul kernel body.

    Memory layout (all dims in f16 elements, addresses in element units):
      * A is row-major ``M x K``; lane ``L`` of the A fragment owns row
        ``L % 16`` so its per-tile base is ``A + (L % 16) * K + k * 16``.
      * B is column-major ``K x N`` (equivalent to row-major ``N x K``);
        lane ``L`` owns column ``n_tile * 16 + L % 16`` so its per-tile
        base is ``B + (n_tile * 16 + L % 16) * K + k * 16``.
      * Output C is f32 in "tile block" layout: workgroup ``wg`` writes
        256 contiguous f32 elements starting at ``wg * 256``.
    """
    a_arg, b_arg, c_arg = bld.args
    i32 = dsl.i32()

    # ---- C output address (1 wave per wg, 1 tile per wg) ---------------
    wi = bld.workitem_id(axis=0)
    neg32 = bld.constant(i32, -32)
    wave_base = bld.binary("andi", wi, bld.splat(neg32))
    c3 = bld.constant(i32, 3)
    wave_off = bld.binary("shli", wave_base, bld.splat(c3))

    wg = bld.workgroup_id(axis=0)
    wg_shift = bld.constant(i32, cfg.log2_workgroup_i32_stride)
    wg_off = bld.binary("shli", bld.splat(wg), bld.splat(wg_shift))
    c_off = bld.binary("addi", wg_off, wave_off)
    c_ptr = bld.ptr_add(c_arg, c_off)

    # ---- per-lane base addresses for A and B ---------------------------
    # lane % 16 lets the second half of the wave (lanes 16..31) reuse the
    # same row/column slice the first half computes, matching the RDNA3
    # WMMA fragment layout (every value is held in two lanes).
    lane = bld.lane_id()
    c15 = bld.constant(i32, 15)
    lane_mod16 = bld.binary("andi", lane, bld.splat(c15))

    log2_K = bld.constant(i32, cfg.log2_K)
    a_row_off = bld.binary("shli", lane_mod16, bld.splat(log2_K))
    a_lane_base = bld.ptr_add(a_arg, a_row_off)

    # n_tile == wg (since N/16 is a power of two). The per-workgroup B
    # offset jumps 16*K elements between adjacent n_tiles.
    log2_16K = bld.constant(i32, cfg.log2_K + 4)
    b_wg_off = bld.binary("shli", bld.splat(wg), bld.splat(log2_16K))
    b_lane_off = bld.binary("addi", b_wg_off, a_row_off)
    b_lane_base = bld.ptr_add(b_arg, b_lane_off)

    # ---- fragment types ------------------------------------------------
    a_type = dsl.fragment_type(0, dsl.f16(), 16, 16, 32, 8)
    b_type = dsl.fragment_type(1, dsl.f16(), 16, 16, 32, 8)
    acc_type = dsl.fragment_type(2, dsl.f32(), 16, 16, 32, 8)

    # ---- K-loop: load A and B tiles, accumulate, advance pointers ------
    acc = bld.fragment_fill(bld.constant(i32, 0), acc_type)
    c16 = bld.constant(i32, 16)
    a_ptr_iter = a_lane_base
    b_ptr_iter = b_lane_base
    for _ in range(cfg.k_steps):
        a_frag, _atok = bld.fragment_load(a_ptr_iter, a_type)
        b_frag, _btok = bld.fragment_load(b_ptr_iter, b_type)
        acc = bld.mma(_MMA_KIND, a_frag, b_frag, acc)
        a_ptr_iter = bld.ptr_add(a_ptr_iter, bld.splat(c16))
        b_ptr_iter = bld.ptr_add(b_ptr_iter, bld.splat(c16))

    bld.fragment_store(acc, c_ptr)


def _emit_host(bld: dsl.FunctionBuilder, cfg: _MatmulConfig) -> None:
    """Populate the host ``main`` that allocates, launches, and prints."""
    index = dsl.index_type()
    f16 = dsl.f16()
    f32 = dsl.f32()
    f16_ptr = dsl.ptr_type(f16)
    f32_ptr = dsl.ptr_type(f32)

    c0 = bld.constant(index, 0)
    c1 = bld.constant(index, 1)
    blocks = bld.constant(index, cfg.num_workgroups)
    threads = bld.constant(index, cfg.threads_per_workgroup)
    a_total = bld.constant(index, cfg.a_elements)
    b_total = bld.constant(index, cfg.b_elements)
    c_total = bld.constant(index, cfg.total_elements)

    one_f16 = bld.constant(f16, 1.0)
    zero_f32 = bld.constant(f32, 0.0)

    a_buf = bld.alloc([cfg.a_elements], f16)
    b_buf = bld.alloc([cfg.b_elements], f16)
    c_buf = bld.alloc([cfg.total_elements], f32)

    with bld.for_loop(c0, a_total, c1) as i:
        bld.memref_store(one_f16, a_buf, [i])
    with bld.for_loop(c0, b_total, c1) as i:
        bld.memref_store(one_f16, b_buf, [i])
    with bld.for_loop(c0, c_total, c1) as i:
        bld.memref_store(zero_f32, c_buf, [i])

    c_unranked = bld.cast_unranked(c_buf)
    bld.host_register(bld.cast_unranked(a_buf))
    bld.host_register(bld.cast_unranked(b_buf))
    bld.host_register(c_unranked)

    # The f16 helper is declared with a dynamic 1-D shape so it can take
    # both A (M*K) and B (N*K) memrefs through a single C symbol; the cast
    # is purely a static-vs-dynamic shape erasure.
    dyn_f16 = dsl.dynamic_1d_memref_type(f16)
    [a_ptr] = bld.call(_F16_PTR_HELPER, [bld.memref_cast(a_buf, dyn_f16)], [f16_ptr])
    [b_ptr] = bld.call(_F16_PTR_HELPER, [bld.memref_cast(b_buf, dyn_f16)], [f16_ptr])
    [c_ptr] = bld.call(_F32_PTR_HELPER, [c_buf], [f32_ptr])

    bld.launch(
        _GPU_MODULE_NAME,
        _KERNEL_NAME,
        grid=(blocks, c1, c1),
        block=(threads, c1, c1),
        operands=[a_ptr, b_ptr, c_ptr],
    )
    bld.call(_PRINT_HELPER, [c_unranked])


def build_wmma_f16_matmul_module(
    M: int, N: int, K: int, *, BM: int = 1, BN: int = 1
) -> Module:
    """Return an MLIR :class:`Module` for the tiled WMMA f16 matmul.

    The host allocates ``MxK`` (A) and ``NxK`` (B) f16 buffers filled
    with 1.0, plus an ``MxN`` f32 output buffer, registers them with the
    GPU runtime, and launches the kernel. Each output element is
    therefore :math:`\\sum_{k=0}^{K-1} 1.0 \\cdot 1.0 = K`.

    Constraints (see module docstring for the rationale):
      * ``M = 16``.
      * ``N`` is a power-of-two multiple of 16.
      * ``K`` is a power-of-two multiple of 16.
      * ``BM = BN = 1``.

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
            _F16_PTR_HELPER,
            [dsl.dynamic_1d_memref_type(dsl.f16())],
            [dsl.ptr_type(dsl.f16())],
        )
        bld.declare_external(
            _F32_PTR_HELPER,
            [dsl.MemRefType.get([cfg.total_elements], dsl.f32())],
            [dsl.ptr_type(dsl.f32())],
        )
        bld.declare_external(
            _PRINT_HELPER,
            [dsl.unranked_memref_type(dsl.f32())],
            [],
        )

        kernel_inputs = [
            dsl.ptr_type(dsl.f16()),
            dsl.ptr_type(dsl.f16()),
            dsl.ptr_type(dsl.f32()),
        ]
        with (
            bld.gpu_module(_GPU_MODULE_NAME) as gmod,
            gmod.kernel(_KERNEL_NAME, kernel_inputs) as fb,
        ):
            _emit_kernel(fb, cfg)

        with bld.host_main() as fb:
            _emit_host(fb, cfg)

    return bld.module


__all__ = ["build_wmma_f16_matmul_module"]
