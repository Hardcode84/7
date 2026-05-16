#  Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
#  See https://llvm.org/LICENSE.txt for license information.
#  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

"""Textual MLIR builder for the tiled WMMA iu8 matmul kernel.

This module emits the MLIR module as a string instead of going through the
upstream MLIR Python bindings, since this checkout does not enable
``MLIR_ENABLE_BINDINGS_PYTHON``. Once the bindings come online, the same
shape can be re-expressed against :mod:`wave_dsl` without changing the
public API.
"""

from __future__ import annotations

from dataclasses import dataclass


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
                raise ValueError(
                    f"{dim} must be a positive multiple of 16; got {val}"
                )
        tile = self.BM * self.BN
        if tile not in (1, 2, 4, 8):
            raise ValueError(
                "BM*BN must be a power of two in {1, 2, 4, 8}; "
                f"got BM={self.BM}, BN={self.BN} (product={tile})"
            )
        # Number of output i32 elements per workgroup = 256 (one 16x16 tile)
        # * BM*BN waves. The grid lays them out contiguously, so the total
        # output size must divide evenly.
        total = self.M * self.N
        per_wg = 256 * tile
        if total % per_wg != 0:
            raise ValueError(
                f"M*N (={total}) must be divisible by 256 * BM*BN (={per_wg})"
            )
        if not _is_power_of_two(per_wg):
            # The kernel uses a single `shli` to scale workgroup_id_x into a
            # byte offset, so the workgroup stride must be a power of two.
            raise ValueError(
                "256 * BM*BN must be a power of two; "
                f"got 256 * {tile} = {per_wg}"
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


_KERNEL_NAME = "wmma_iu8_matmul_tiled"


def _emit_kernel(cfg: _MatmulConfig) -> str:
    """Emit the gpu.module @kernels with a tiled matmul kernel.

    The kernel runs one wave per 16x16 output tile. Each wave computes:
    - wave's byte slot within the workgroup:
        ``(workitem_id_x AND ~31) * 32``  (= wave_id * 1024 bytes)
    - workgroup's byte slot in the output:
        ``workgroup_id_x * (256 * BM*BN * 4)``  bytes
    The K-loop is unrolled in Python; we chain ``waveamd.mma`` calls with
    ``fragment_fill``-initialised A/B operands so that each output element
    ends up equal to K.
    """
    lines: list[str] = []
    lines.append("gpu.module @kernels {")
    lines.append(
        f"  func.func @{_KERNEL_NAME}"
        "(%out: !wave.ptr<i32, #wave.global>)"
    )
    lines.append("      attributes {gpu.kernel, wave.kernel} {")
    lines.append("    %ones_i8x4 = arith.constant 0x01010101 : i32")
    lines.append("    %acc_init  = arith.constant 0 : i32")
    lines.append("    %neg32     = arith.constant -32 : i32")
    lines.append("    %c3        = arith.constant 3 : i32")
    lines.append(
        f"    %wg_shift  = arith.constant {cfg.log2_workgroup_i32_stride} : i32"
    )

    # Per-lane workitem_id (each lane has a unique value 0..threads-1).
    lines.append(
        "    %wi = wave.workitem_id 0 : !wave.simd<i32, 32>"
    )
    lines.append(
        "    %vneg32 = wave.splat %neg32 : i32 -> !wave.simd<i32, 32>"
    )
    lines.append(
        "    %wave_base = wave.binary \"andi\" %wi, %vneg32"
        " : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>"
    )
    lines.append(
        "    %v3 = wave.splat %c3 : i32 -> !wave.simd<i32, 32>"
    )
    lines.append(
        "    %wave_off = wave.binary \"shli\" %wave_base, %v3"
        " : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>"
    )

    lines.append("    %wg = wave.workgroup_id 0")
    lines.append(
        "    %vwg = wave.splat %wg : i32 -> !wave.simd<i32, 32>"
    )
    lines.append(
        "    %vshift = wave.splat %wg_shift : i32 -> !wave.simd<i32, 32>"
    )
    lines.append(
        "    %wg_off = wave.binary \"shli\" %vwg, %vshift"
        " : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>"
    )
    lines.append(
        "    %total = wave.binary \"addi\" %wg_off, %wave_off"
        " : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>"
    )
    lines.append(
        "    %ptr = wave.ptr_add %out, %total"
        " : !wave.ptr<i32, #wave.global>, !wave.simd<i32, 32>"
        " -> !wave.simd<!wave.ptr<i32, #wave.global>, 32>"
    )

    # Build the unrolled K-loop. Each iteration consumes a fresh A=B=1s
    # fragment_fill so verification stays element-wise == K.
    a_type = "!waveamd.fragment<0, i8, 16, 16, 32, 4>"
    b_type = "!waveamd.fragment<1, i8, 16, 16, 32, 4>"
    acc_type = "!waveamd.fragment<2, i32, 16, 16, 32, 8>"
    lines.append(f"    %acc0 = waveamd.fragment_fill %acc_init : i32 -> {acc_type}")
    prev_acc = "%acc0"
    for step in range(cfg.k_steps):
        a_name = f"%a_{step}"
        b_name = f"%b_{step}"
        next_acc = f"%acc{step + 1}"
        lines.append(
            f"    {a_name} = waveamd.fragment_fill %ones_i8x4 : i32 -> {a_type}"
        )
        lines.append(
            f"    {b_name} = waveamd.fragment_fill %ones_i8x4 : i32 -> {b_type}"
        )
        lines.append(
            f"    {next_acc} = waveamd.mma \"wmma.i32.16x16x16.iu8\""
            f" {a_name}, {b_name}, {prev_acc}"
            f" : {a_type}, {b_type}, {acc_type} -> {acc_type}"
        )
        prev_acc = next_acc
    lines.append(
        f"    %tok = waveamd.fragment_store {prev_acc} -> %ptr"
        f" : ({acc_type}, !wave.simd<!wave.ptr<i32, #wave.global>, 32>)"
        " -> !wave.mem.token"
    )
    lines.append("    return")
    lines.append("  }")
    lines.append("}")
    return "\n".join(lines)


def _emit_host(cfg: _MatmulConfig) -> str:
    """Emit the host-side ``main`` that allocates, launches, and prints."""
    total = cfg.total_elements
    threads = cfg.threads_per_workgroup
    blocks = cfg.num_workgroups
    lines = [
        f"func.func private @wave_memref_to_ptr_global_i32(memref<{total}xi32>)",
        "    -> !wave.ptr<i32, #wave.global> attributes {llvm.emit_c_interface}",
        "",
        "func.func private @printMemrefI32(memref<*xi32>)",
        "    attributes {llvm.emit_c_interface}",
        "",
        "func.func @main() {",
        "  %c0     = arith.constant 0 : index",
        "  %c1     = arith.constant 1 : index",
        f"  %blocks  = arith.constant {blocks} : index",
        f"  %threads = arith.constant {threads} : index",
        f"  %ctotal  = arith.constant {total} : index",
        "  %zero   = arith.constant 0 : i32",
        "",
        f"  %storage = memref.alloc() : memref<{total}xi32>",
        "  scf.for %i = %c0 to %ctotal step %c1 {",
        f"    memref.store %zero, %storage[%i] : memref<{total}xi32>",
        "  }",
        f"  %unranked = memref.cast %storage : memref<{total}xi32> to memref<*xi32>",
        "  gpu.host_register %unranked : memref<*xi32>",
        "",
        "  %p = func.call @wave_memref_to_ptr_global_i32(%storage)",
        f"      : (memref<{total}xi32>) -> !wave.ptr<i32, #wave.global>",
        "",
        f"  gpu.launch_func @kernels::@{_KERNEL_NAME}",
        "      blocks in (%blocks, %c1, %c1) threads in (%threads, %c1, %c1)",
        "      args(%p : !wave.ptr<i32, #wave.global>)",
        "",
        "  func.call @printMemrefI32(%unranked) : (memref<*xi32>) -> ()",
        "  return",
        "}",
    ]
    return "\n".join(lines)


def build_wmma_iu8_matmul_module(
    M: int, N: int, K: int, *, BM: int = 1, BN: int = 1
) -> str:
    """Return the MLIR module text for a tiled WMMA iu8 matmul.

    The kernel multiplies ``MxK`` by ``KxN`` (both filled with 1s via
    ``waveamd.fragment_fill``) and writes the result into an
    ``MxN``-element i32 buffer. The output layout is "tile block": each
    16x16 tile occupies 256 contiguous i32 elements (1024 bytes), so the
    host check is trivially ``output[i] == K`` for all ``i``.

    Constraints:
      * ``M``, ``N``, ``K`` are positive multiples of 16.
      * ``BM*BN`` is a power of two in ``{1, 2, 4, 8}`` (one wave per tile,
        ``BM*BN`` waves per workgroup).
      * ``M*N`` is divisible by ``256 * BM * BN``.
    """
    cfg = _MatmulConfig(M=M, N=N, K=K, BM=BM, BN=BN)
    body = _emit_kernel(cfg) + "\n\n" + _emit_host(cfg)
    indented = "\n".join("  " + line if line else "" for line in body.split("\n"))
    return (
        "module attributes {gpu.container_module} {\n"
        + indented
        + "\n}\n"
    )


__all__ = ["build_wmma_iu8_matmul_module"]
