#  Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
#  See https://llvm.org/LICENSE.txt for license information.
#  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

"""Builder for tiled Wave f16xf16xf32 matmul kernels + host driver.

This module assembles the module *programmatically* through the MLIR
Python bindings (see :mod:`wave_dsl`). It returns a live
:class:`mlir.ir.Module` that everything else (``wave-opt``,
``mlir-runner``, ...) can consume.

The kernel reads A and B from global memory through ``wave.load`` +
``waveamd.fragment_pack`` (the ``fragment_load`` DSL helper), stages
each per-K-step A/B fragment through a per-wave LDS slot, and stores
the f32 accumulator via the ``fragment_unpack`` + tuple ``wave.store``
chain (the :meth:`wave_dsl.FunctionBuilder.fragment_store` helper).
The LDS round-trip
-- tuple ``wave.store`` to the slot, workgroup ``wave.barrier``, tuple
``wave.load`` from the same slot, then ``fragment_pack`` / ``mma`` --
keeps the transport a pure identity but exercises every LDS code path
the AMDGPU backend supports (tuple ``ds_store_b32`` / ``ds_load_b32``
sequences, ``s_barrier``, and the kernel's ``wave.lds_size`` ->
``group_segment_fixed_size`` propagation) in the matmul context.

Setting ``use_buffer=True`` also wraps the A and B kernel inputs in
``waveamd.make_buffer`` at the very top of the kernel, turning the
subsequent per-K-step fragment loads into tuple ``buffer_load_b32``
ops (lowered to ``buffer_load_dword ..., 0 offen offset:i*4``) before
they stage through LDS. The C fragment store stays on the global path,
so the lit/integration tests can exercise the buffer load lowering
end-to-end without disturbing the existing fragment-store codegen.

Tile-to-wave mapping:
  * The grid is launched 2-D as ``(M_blocks, N_blocks)`` and each
    workgroup runs ``BM * BN`` waves.
  * The wave's local id within its workgroup is ``workitem_id_x >> 5``,
    decomposed into ``(m_wave, n_wave)`` via ``BN`` being a power of 2.
  * Each wave computes a virtual
    ``wave_m_tiles x wave_n_tiles x wave_k_tiles`` tile. The K axis is
    folded into the same accumulator rectangle.

Shape constraints:
  * ``M``, ``N``, ``K`` are positive multiples of 16.
  * ``BM * wave_m_tiles`` divides ``M / 16``.
  * ``BN * wave_n_tiles`` divides ``N / 16``; ``BN`` is a power of 2 (so the
    wave-id decomposition uses ``andi`` + ``shri``).
  * ``wave_k_tiles`` divides ``K / 16``.
  * ``BM * BN <= 32`` (RDNA3 caps a workgroup at 32 waves of 32 lanes).
"""

from __future__ import annotations

import struct
from dataclasses import dataclass

from mlir._mlir_libs._waveDialectsNanobind import PTupleType
from mlir.dialects import wave, waveamd, wavemeta
from mlir.dialects import wave_dsl as dsl
from mlir.ir import (
    DictAttr,
    IndexType,
    IntegerAttr,
    IntegerType,
    Module,
    StringAttr,
)


def _is_power_of_two(value: int) -> bool:
    return value > 0 and (value & (value - 1)) == 0


@dataclass(frozen=True)
class _MmaVariant:
    name: str
    kind: str
    ab_registers: int
    acc_registers: int
    wave_size: int = 32
    lane_k_elems: int = 0
    k_tile: int = 16

    @property
    def lds_dwords_per_frag(self) -> int:
        return self.ab_registers * self.wave_size


_MMA_VARIANTS = {
    "wmma": _MmaVariant("wmma", "wmma.f32.16x16x16.f16", 8, 8),
    "mfma": _MmaVariant("mfma", "mfma.f32.16x16x16.f16", 2, 4),
    "mfma_gfx950": _MmaVariant("mfma_gfx950", "mfma.f32.16x16x32.f16", 4, 4, 64, 8, 32),
}


def _select_mma_variant(name: str) -> _MmaVariant:
    try:
        return _MMA_VARIANTS[name]
    except KeyError as exc:
        choices = ", ".join(sorted(_MMA_VARIANTS))
        raise ValueError(
            f"unknown matrix intrinsic '{name}'; expected {choices}"
        ) from exc


@dataclass(frozen=True)
class _MatmulConfig:
    M: int
    N: int
    K: int
    BM: int
    BN: int
    wave_m_tiles: int = 1
    wave_n_tiles: int = 1
    wave_k_tiles: int = 1
    use_buffer: bool = False
    use_dma_lds: bool = False
    matrix_intrinsic: str = "wmma"
    output_type: str = "f32"
    random_data: bool = False
    random_seed: int = 0

    def __post_init__(self) -> None:
        _validate_positive_shape(self)
        _validate_tile_shape(self)

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
    def c_type(self) -> dsl.Type:
        return dsl.f16() if self.output_type == "f16" else dsl.f32()

    @property
    def waves_per_workgroup(self) -> int:
        return self.BM * self.BN

    @property
    def tiles_per_wave(self) -> int:
        return self.wave_m_tiles * self.wave_n_tiles

    @property
    def threads_per_workgroup(self) -> int:
        return self.mma.wave_size * self.waves_per_workgroup

    @property
    def M_blocks(self) -> int:
        return self.M // (16 * self.BM * self.wave_m_tiles)

    @property
    def N_blocks(self) -> int:
        return self.N // (16 * self.BN * self.wave_n_tiles)

    @property
    def k_steps(self) -> int:
        return self.K // self.mma.k_tile

    @property
    def virtual_k_steps(self) -> int:
        return self.k_steps // self.wave_k_tiles

    @property
    def log2_BN(self) -> int:
        return self.BN.bit_length() - 1

    @property
    def lds_bytes(self) -> int:
        return (
            self.wave_k_tiles
            * (self.wave_m_tiles + self.wave_n_tiles)
            * self.waves_per_workgroup
            * self.mma.lds_dwords_per_frag
            * 4
        )

    @property
    def mma(self) -> _MmaVariant:
        return _select_mma_variant(self.matrix_intrinsic)


def _validate_positive_shape(cfg: _MatmulConfig) -> None:
    for dim, val in (("M", cfg.M), ("N", cfg.N), ("K", cfg.K)):
        if val <= 0 or val % 16 != 0:
            raise ValueError(f"{dim} must be a positive multiple of 16; got {val}")
    if cfg.BM < 1 or cfg.BN < 1:
        raise ValueError(f"BM and BN must be >= 1; got BM={cfg.BM}, BN={cfg.BN}")
    if cfg.wave_m_tiles < 1 or cfg.wave_n_tiles < 1 or cfg.wave_k_tiles < 1:
        raise ValueError(
            f"wave_m_tiles, wave_n_tiles and wave_k_tiles must be >= 1; "
            f"got wave_m_tiles={cfg.wave_m_tiles}, "
            f"wave_n_tiles={cfg.wave_n_tiles}, "
            f"wave_k_tiles={cfg.wave_k_tiles}"
        )
    if cfg.output_type not in ("f32", "f16"):
        raise ValueError(f"output_type must be 'f32' or 'f16'; got {cfg.output_type}")


def _validate_tile_shape(cfg: _MatmulConfig) -> None:
    if not _is_power_of_two(cfg.BN):
        raise ValueError(
            f"BN must be a positive power of two (for the wave-id "
            f"decomposition); got BN={cfg.BN}"
        )
    m_tiles_per_block = cfg.BM * cfg.wave_m_tiles
    n_tiles_per_block = cfg.BN * cfg.wave_n_tiles
    if (cfg.M // 16) % m_tiles_per_block != 0:
        raise ValueError(
            f"BM * wave_m_tiles (={m_tiles_per_block}) must divide "
            f"M/16 (={cfg.M // 16})"
        )
    if (cfg.N // 16) % n_tiles_per_block != 0:
        raise ValueError(
            f"BN * wave_n_tiles (={n_tiles_per_block}) must divide "
            f"N/16 (={cfg.N // 16})"
        )
    if cfg.K % cfg.mma.k_tile != 0:
        raise ValueError(
            f"K must be a multiple of {cfg.mma.k_tile} for "
            f"{cfg.matrix_intrinsic}; got {cfg.K}"
        )
    if cfg.k_steps % cfg.wave_k_tiles != 0:
        raise ValueError(
            f"wave_k_tiles (={cfg.wave_k_tiles}) must divide "
            f"K/{cfg.mma.k_tile} (={cfg.k_steps})"
        )
    if cfg.use_dma_lds and cfg.mma.name != "mfma_gfx950":
        raise ValueError("use_dma_lds is currently supported only for gfx950 MFMA")
    if cfg.waves_per_workgroup > 32:
        raise ValueError(
            f"BM * BN must be <= 32 (RDNA3 workgroup wave cap); "
            f"got BM={cfg.BM}, BN={cfg.BN} (product={cfg.waves_per_workgroup})"
        )


_KERNEL_NAME = "wmma_f16_matmul_tiled"
_GPU_MODULE_NAME = "kernels"
_F16_PTR_HELPER = "wave_memref_to_ptr_global_f16"
_F32_PTR_HELPER = "wave_memref_to_ptr_global_f32"
_PRINT_HELPER = "printMemrefF32"
_PRINT_F16_HELPER = "printMemrefF16"
_TARGET_WAVES_ATTR = "waveamdmachine.target_waves"


def _splat_const(bld: dsl.FunctionBuilder, value: int) -> dsl.Value:
    return bld.splat(bld.constant(dsl.i32(), value))


def _target_waves_attrs(target_waves: int | None) -> dict[str, dsl.Attribute]:
    if target_waves is None:
        return {}
    if target_waves <= 0:
        raise ValueError(f"target_waves must be positive; got {target_waves}")
    return {_TARGET_WAVES_ATTR: dsl.i64_attr(target_waves)}


def _deterministic_random_values(
    count: int, *, seed: int, stream: int
) -> tuple[float, ...]:
    state = (seed ^ ((stream + 1) * 0x9E3779B9)) & 0xFFFFFFFF
    values: list[float] = []
    for _ in range(count):
        state = (1664525 * state + 1013904223) & 0xFFFFFFFF
        values.append((((state >> 24) % 17) - 8) * 0.25)
    return tuple(values)


def _round_f16(value: float) -> float:
    return float(struct.unpack("<e", struct.pack("<e", value))[0])


def generate_wmma_f16_matmul_inputs(
    M: int,
    N: int,
    K: int,
    *,
    random_data: bool = False,
    random_seed: int = 0,
) -> tuple[tuple[float, ...], tuple[float, ...]]:
    if random_data:
        return (
            _deterministic_random_values(M * K, seed=random_seed, stream=0),
            _deterministic_random_values(N * K, seed=random_seed, stream=1),
        )

    a_half = (M * K) // 2
    b_half = (N * K) // 2
    return (
        tuple([1.0] * a_half + [2.0] * (M * K - a_half)),
        tuple([1.0] * b_half + [2.0] * (N * K - b_half)),
    )


def _reference_tile(
    cfg: _MatmulConfig,
    a_values: tuple[float, ...],
    b_values: tuple[float, ...],
    m_tile: int,
    n_tile: int,
) -> tuple[float, ...]:
    tile: list[float] = []
    for mi in range(16):
        m = m_tile * 16 + mi
        for nj in range(16):
            n = n_tile * 16 + nj
            acc = 0.0
            for k in range(cfg.K):
                acc += a_values[m * cfg.K + k] * b_values[n * cfg.K + k]
            tile.append(acc)
    return tuple(tile)


def compute_wmma_f16_matmul_reference_buffer(
    M: int,
    N: int,
    K: int,
    *,
    BM: int = 1,
    BN: int = 1,
    wave_m_tiles: int = 1,
    wave_n_tiles: int = 1,
    wave_k_tiles: int = 1,
    random_data: bool = False,
    random_seed: int = 0,
    matrix_intrinsic: str = "wmma",
    output_type: str = "f32",
) -> tuple[float, ...]:
    cfg = _MatmulConfig(
        M=M,
        N=N,
        K=K,
        BM=BM,
        BN=BN,
        wave_m_tiles=wave_m_tiles,
        wave_n_tiles=wave_n_tiles,
        wave_k_tiles=wave_k_tiles,
        random_data=random_data,
        random_seed=random_seed,
        matrix_intrinsic=matrix_intrinsic,
        output_type=output_type,
    )
    a_values, b_values = generate_wmma_f16_matmul_inputs(
        M, N, K, random_data=random_data, random_seed=random_seed
    )
    out: list[float] = []
    for wg_m in range(cfg.M_blocks):
        for wg_n in range(cfg.N_blocks):
            for wave_id in range(cfg.waves_per_workgroup):
                m_wave = wave_id // cfg.BN
                n_wave = wave_id % cfg.BN
                m_base = wg_m * cfg.BM * cfg.wave_m_tiles
                n_base = wg_n * cfg.BN * cfg.wave_n_tiles
                for i in range(cfg.wave_m_tiles):
                    for j in range(cfg.wave_n_tiles):
                        m_tile = m_base + m_wave * cfg.wave_m_tiles + i
                        n_tile = n_base + n_wave * cfg.wave_n_tiles + j
                        out.extend(
                            _reference_tile(cfg, a_values, b_values, m_tile, n_tile)
                        )
    if cfg.output_type == "f16":
        return tuple(_round_f16(value) for value in out)
    return tuple(out)


@dataclass(frozen=True)
class _TileCoords:
    """Per-wave coordinates derived from `workitem_id` / `workgroup_id`."""

    wi: dsl.Value  # raw workitem_id; wave_id = wi // 32 lives in index_expr
    a_tile_base: dsl.Value
    b_tile_base: dsl.Value
    a_lane_base: dsl.Value
    b_lane_base: dsl.Value
    c_ptr: dsl.Value


def _wrap_in_buffer(
    bld: dsl.FunctionBuilder, ptr: dsl.Value, num_elements: int
) -> dsl.Value:
    """Build a ``!wave.ptr<#waveamd.buffer, f16>`` from a global f16 pointer.

    The buffer descriptor's NUM_RECORDS field is set in bytes (the
    32-bit/format flag in :func:`MakeBufferRsrcOp` => byte-stride
    addressing), so we pass ``num_elements * 2``.
    """
    range_bytes = bld.constant(dsl.i32(), num_elements * 2)
    return bld.make_buffer(ptr, range_bytes, dsl.buffer_ptr_type(dsl.f16()))


def _emit_tile_coords(bld: dsl.FunctionBuilder, cfg: _MatmulConfig) -> _TileCoords:
    """Compute the per-wave (lane, A/B/C base ptrs) from workitem ids.

    All address arithmetic -- including the shri / andi pieces that
    decompose `wi` into `wave_id`, `m_wave`, `n_wave`, and lane into
    `lane_mod16` -- lives inside one `wave.index_expr` per pointer.
    Address expression materialization lowers the non-linear
    bits to shr / and at code-emit time, so the kernel surface stays
    structurally symbolic.
    """
    a_arg, b_arg, c_arg = bld.args[0], bld.args[1], bld.args[2]
    if cfg.use_buffer:
        a_arg = _wrap_in_buffer(bld, a_arg, cfg.a_elements)
        b_arg = _wrap_in_buffer(bld, b_arg, cfg.b_elements)

    wi_val = bld.assume_range(
        bld.workitem_id(axis=0, width=cfg.mma.wave_size),
        0,
        cfg.threads_per_workgroup - 1,
    )
    wg_m_val = bld.assume_range(bld.workgroup_id(axis=0), 0, cfg.M_blocks - 1)
    wg_n_val = bld.assume_range(bld.workgroup_id(axis=1), 0, cfg.N_blocks - 1)

    # Symbolic offset side via the shared `dsl.sym_ctx`. wave_id /
    # m_wave / n_wave / lane_mod16 ride floor / mod nodes lowered to shr / and.
    wi = dsl.sym("wi")
    wg_m = dsl.sym("wg_m")
    wg_n = dsl.sym("wg_n")
    wave_id = dsl.floor(wi / cfg.mma.wave_size)
    m_wave = dsl.floor(wi / (cfg.mma.wave_size * cfg.BN))
    n_wave = dsl.mod(wave_id, cfg.BN)
    lane = dsl.mod(wi, cfg.mma.wave_size)
    lane_mod16 = dsl.mod(wi, 16)
    lane_k_off = dsl.floor(lane / 16) * cfg.mma.lane_k_elems
    sym_to_val = {wi: wi_val, wg_m: wg_m_val, wg_n: wg_n_val}

    stride_per_tile = 16 * cfg.K
    a_tile_off = bld.index_expr(
        wg_m * (cfg.BM * cfg.wave_m_tiles * stride_per_tile)
        + m_wave * (cfg.wave_m_tiles * stride_per_tile),
        bindings=sym_to_val,
    )
    a_tile_base = bld.ptr_add(a_arg, a_tile_off)
    a_off = bld.index_expr(lane_mod16 * cfg.K + lane_k_off, bindings=sym_to_val)
    a_lane_base = bld.ptr_add(a_tile_base, a_off)

    b_tile_off = bld.index_expr(
        wg_n * (cfg.BN * cfg.wave_n_tiles * stride_per_tile)
        + n_wave * (cfg.wave_n_tiles * stride_per_tile),
        bindings=sym_to_val,
    )
    b_tile_base = bld.ptr_add(b_arg, b_tile_off)
    b_off = bld.index_expr(lane_mod16 * cfg.K + lane_k_off, bindings=sym_to_val)
    b_lane_base = bld.ptr_add(b_tile_base, b_off)

    c_off = bld.index_expr(
        wg_m * (cfg.N_blocks * cfg.waves_per_workgroup * cfg.tiles_per_wave * 256)
        + wg_n * (cfg.waves_per_workgroup * cfg.tiles_per_wave * 256)
        + wave_id * (cfg.tiles_per_wave * 256),
        bindings=sym_to_val,
    )
    c_ptr = bld.ptr_add(c_arg, c_off)

    return _TileCoords(
        wi=wi_val,
        a_tile_base=a_tile_base,
        b_tile_base=b_tile_base,
        a_lane_base=a_lane_base,
        b_lane_base=b_lane_base,
        c_ptr=c_ptr,
    )


@dataclass(frozen=True)
class _LdsStaging:
    """Per-wave LDS slots for the matmul fragment round-trip."""

    reg_simd_type: dsl.Type
    a_lds_ptrs: tuple[dsl.Value, ...]
    b_lds_ptrs: tuple[dsl.Value, ...]
    a_dma_lds_ptrs: tuple[dsl.Value, ...]
    b_dma_lds_ptrs: tuple[dsl.Value, ...]
    a_dma_read_ptrs: tuple[dsl.Value, ...]
    b_dma_read_ptrs: tuple[dsl.Value, ...]


def _fragment_slot_indices(
    cfg: _MatmulConfig, base: int, count: int
) -> tuple[int, ...]:
    stride = cfg.wave_m_tiles + cfg.wave_n_tiles
    return tuple(
        k * stride + base + i for k in range(cfg.wave_k_tiles) for i in range(count)
    )


def _dma_swizzle_phase(cfg: _MatmulConfig) -> int:
    if cfg.mma.name != "mfma_gfx950":
        return 1
    return min(8, cfg.mma.k_tile // cfg.mma.lane_k_elems)


def _dma_swizzle_rows_per_phase(cfg: _MatmulConfig) -> int:
    if cfg.mma.name != "mfma_gfx950":
        return 1
    return 2


def _dma_logical_col(
    cfg: _MatmulConfig, row: int | dsl.Expr, physical_col: int | dsl.Expr
) -> int | dsl.Expr:
    phase = _dma_swizzle_phase(cfg)
    if phase < 2:
        return physical_col
    row_phase = dsl.floor(row / _dma_swizzle_rows_per_phase(cfg))
    return dsl.xor(dsl.mod(row_phase, phase), physical_col)


def _emit_dma_staging_ptrs(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    coords: _TileCoords,
    lds: dsl.Value,
    slots_per_wave: int,
    slots: tuple[int, ...],
) -> tuple[tuple[dsl.Value, ...], tuple[dsl.Value, ...]]:
    wi = dsl.sym("wi")
    wi_first = dsl.sym("wi_first")
    first_bindings = {wi_first: bld.read_first(coords.wi)}
    bindings = {wi: coords.wi}
    wave_id = dsl.floor(wi / cfg.mma.wave_size)
    wave_id_uniform = dsl.floor(wi_first / cfg.mma.wave_size)
    lane = dsl.mod(wi, cfg.mma.wave_size)
    lane_mod16 = dsl.mod(wi, 16)
    lane_k_group = dsl.floor(lane / 16)
    read_k_group = _dma_logical_col(cfg, lane_mod16, lane_k_group)

    def dma_slot_ptr(slot: int) -> dsl.Value:
        slot_off = bld.index_expr(
            wave_id_uniform * (slots_per_wave * cfg.mma.lds_dwords_per_frag)
            + slot * cfg.mma.lds_dwords_per_frag,
            bindings=first_bindings,
        )
        return bld.ptr_add(lds, slot_off)

    def dma_read_ptr(slot: int) -> dsl.Value:
        slot_off = bld.index_expr(
            wave_id * (slots_per_wave * cfg.mma.lds_dwords_per_frag)
            + slot * cfg.mma.lds_dwords_per_frag
            + lane_mod16 * (cfg.mma.k_tile // 2)
            + read_k_group * (cfg.mma.lane_k_elems // 2),
            bindings=bindings,
        )
        return bld.ptr_add(lds, slot_off)

    return (
        tuple(dma_slot_ptr(slot) for slot in slots),
        tuple(dma_read_ptr(slot) for slot in slots),
    )


def _emit_lds_staging(
    bld: dsl.FunctionBuilder, cfg: _MatmulConfig, coords: _TileCoords
) -> _LdsStaging:
    """Materialize per-wave A/B LDS slot pointers."""
    reg_simd_type = dsl.simd_type(
        dsl.vector_type(cfg.mma.ab_registers, dsl.i32()), width=cfg.mma.wave_size
    )
    lds = bld.lds_base()
    wi = dsl.sym("wi")
    lane = dsl.mod(wi, cfg.mma.wave_size)
    wave_id = dsl.floor(wi / cfg.mma.wave_size)
    bindings = {wi: coords.wi}
    slots_per_wave = cfg.wave_k_tiles * (cfg.wave_m_tiles + cfg.wave_n_tiles)
    a_slots = _fragment_slot_indices(cfg, 0, cfg.wave_m_tiles)
    b_slots = _fragment_slot_indices(cfg, cfg.wave_m_tiles, cfg.wave_n_tiles)

    def slot_ptr(slot: int) -> dsl.Value:
        slot_off = bld.index_expr(
            wave_id * (slots_per_wave * cfg.mma.lds_dwords_per_frag)
            + slot * cfg.mma.lds_dwords_per_frag
            + lane * cfg.mma.ab_registers,
            bindings=bindings,
        )
        return bld.ptr_add(lds, slot_off)

    a_lds_ptrs = tuple(slot_ptr(slot) for slot in a_slots)
    b_lds_ptrs = tuple(slot_ptr(slot) for slot in b_slots)
    if not cfg.use_dma_lds:
        return _LdsStaging(
            reg_simd_type=reg_simd_type,
            a_lds_ptrs=a_lds_ptrs,
            b_lds_ptrs=b_lds_ptrs,
            a_dma_lds_ptrs=(),
            b_dma_lds_ptrs=(),
            a_dma_read_ptrs=(),
            b_dma_read_ptrs=(),
        )

    a_dma_lds_ptrs, a_dma_read_ptrs = _emit_dma_staging_ptrs(
        bld, cfg, coords, lds, slots_per_wave, a_slots
    )
    b_dma_lds_ptrs, b_dma_read_ptrs = _emit_dma_staging_ptrs(
        bld, cfg, coords, lds, slots_per_wave, b_slots
    )
    return _LdsStaging(
        reg_simd_type=reg_simd_type,
        a_lds_ptrs=a_lds_ptrs,
        b_lds_ptrs=b_lds_ptrs,
        a_dma_lds_ptrs=a_dma_lds_ptrs,
        b_dma_lds_ptrs=b_dma_lds_ptrs,
        a_dma_read_ptrs=a_dma_read_ptrs,
        b_dma_read_ptrs=b_dma_read_ptrs,
    )


def _load_fragment_group_through_lds(
    bld: dsl.FunctionBuilder,
    a_ptrs: tuple[dsl.Value, ...],
    b_ptrs: tuple[dsl.Value, ...],
    a_type: dsl.Type,
    b_type: dsl.Type,
    staging: _LdsStaging,
) -> tuple[tuple[dsl.Value, ...], tuple[dsl.Value, ...]]:
    """Round-trip one K-step's A/B fragment group through LDS."""
    a_loads, b_loads = _lds_global_loads(bld, a_ptrs, b_ptrs, staging)
    return _lds_store_reload(bld, a_loads, b_loads, a_type, b_type, staging)


def _lds_global_loads(
    bld: dsl.FunctionBuilder,
    a_ptrs: tuple[dsl.Value, ...],
    b_ptrs: tuple[dsl.Value, ...],
    staging: _LdsStaging,
) -> tuple[
    tuple[tuple[dsl.Value, dsl.Value], ...], tuple[tuple[dsl.Value, dsl.Value], ...]
]:
    a_loads = tuple(bld.load(ptr, staging.reg_simd_type) for ptr in a_ptrs)
    b_loads = tuple(bld.load(ptr, staging.reg_simd_type) for ptr in b_ptrs)
    return a_loads, b_loads


def _lds_store_reload(
    bld: dsl.FunctionBuilder,
    a_loads: tuple[tuple[dsl.Value, dsl.Value], ...],
    b_loads: tuple[tuple[dsl.Value, dsl.Value], ...],
    a_type: dsl.Type,
    b_type: dsl.Type,
    staging: _LdsStaging,
) -> tuple[tuple[dsl.Value, ...], tuple[dsl.Value, ...]]:
    store_tokens: list[dsl.Value] = []
    for (regs, glob_tok), lds_ptr in zip(a_loads, staging.a_lds_ptrs, strict=True):
        store_tokens.append(bld.store(regs, lds_ptr, after=glob_tok))
    for (regs, glob_tok), lds_ptr in zip(b_loads, staging.b_lds_ptrs, strict=True):
        store_tokens.append(bld.store(regs, lds_ptr, after=glob_tok))

    barrier_tok = bld.barrier(*store_tokens)
    a_frags: list[dsl.Value] = []
    b_frags: list[dsl.Value] = []
    for lds_ptr in staging.a_lds_ptrs:
        regs, _ = bld.load(lds_ptr, staging.reg_simd_type, after=barrier_tok)
        a_frags.append(bld.fragment_pack(regs, a_type))
    for lds_ptr in staging.b_lds_ptrs:
        regs, _ = bld.load(lds_ptr, staging.reg_simd_type, after=barrier_tok)
        b_frags.append(bld.fragment_pack(regs, b_type))
    return tuple(a_frags), tuple(b_frags)


def _load_fragment_group_through_dma_lds(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    a_ptrs: tuple[dsl.Value, ...],
    b_ptrs: tuple[dsl.Value, ...],
    a_type: dsl.Type,
    b_type: dsl.Type,
    staging: _LdsStaging,
) -> tuple[tuple[dsl.Value, ...], tuple[dsl.Value, ...]]:
    dma_tokens = _dma_issue(bld, a_ptrs, b_ptrs, staging)
    return _dma_drain(bld, dma_tokens, a_type, b_type, staging)


def _dma_issue(
    bld: dsl.FunctionBuilder,
    a_ptrs: tuple[dsl.Value, ...],
    b_ptrs: tuple[dsl.Value, ...],
    staging: _LdsStaging,
) -> list[dsl.Value]:
    dep = bld.token()
    dma_tokens: list[dsl.Value] = []
    for ptr, lds_ptr in zip(a_ptrs, staging.a_dma_lds_ptrs, strict=True):
        tok = bld.dma_load_lds(ptr, lds_ptr, after=dep, bytes=16)
        dma_tokens.append(tok)
    for ptr, lds_ptr in zip(b_ptrs, staging.b_dma_lds_ptrs, strict=True):
        tok = bld.dma_load_lds(ptr, lds_ptr, after=dep, bytes=16)
        dma_tokens.append(tok)
    return dma_tokens


def _dma_drain(
    bld: dsl.FunctionBuilder,
    dma_tokens: list[dsl.Value],
    a_type: dsl.Type,
    b_type: dsl.Type,
    staging: _LdsStaging,
) -> tuple[tuple[dsl.Value, ...], tuple[dsl.Value, ...]]:
    barrier_tok = bld.barrier(*dma_tokens)
    a_frags: list[dsl.Value] = []
    b_frags: list[dsl.Value] = []
    for lds_ptr in staging.a_dma_read_ptrs:
        regs, _ = bld.load(lds_ptr, staging.reg_simd_type, after=barrier_tok)
        a_frags.append(bld.fragment_pack(regs, a_type))
    for lds_ptr in staging.b_dma_read_ptrs:
        regs, _ = bld.load(lds_ptr, staging.reg_simd_type, after=barrier_tok)
        b_frags.append(bld.fragment_pack(regs, b_type))
    return tuple(a_frags), tuple(b_frags)


def _load_fragment_group(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    a_ptrs: tuple[dsl.Value, ...],
    b_ptrs: tuple[dsl.Value, ...],
    types: _KernelTypes,
    staging: _LdsStaging,
) -> tuple[tuple[dsl.Value, ...], tuple[dsl.Value, ...]]:
    if cfg.use_dma_lds:
        return _load_fragment_group_through_dma_lds(
            bld, cfg, a_ptrs, b_ptrs, types.a, types.b, staging
        )
    return _load_fragment_group_through_lds(
        bld, a_ptrs, b_ptrs, types.a, types.b, staging
    )


def _ptr_add_const(bld: dsl.FunctionBuilder, ptr: dsl.Value, offset: int) -> dsl.Value:
    if offset == 0:
        return ptr
    return bld.ptr_add(ptr, bld.constant(dsl.i32(), offset))


def _tile_fragment_ptrs(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    base: dsl.Value,
    count: int,
) -> tuple[dsl.Value, ...]:
    return tuple(
        _ptr_add_const(bld, base, i * 16 * cfg.K + k * cfg.mma.k_tile)
        for k in range(cfg.wave_k_tiles)
        for i in range(count)
    )


@dataclass(frozen=True)
class _KernelTypes:
    a: dsl.Type
    b: dsl.Type
    acc: dsl.Type


@dataclass(frozen=True)
class _TilePtrs:
    a0: tuple[dsl.Value, ...]
    b0: tuple[dsl.Value, ...]
    a_dma0: tuple[dsl.Value, ...]
    b_dma0: tuple[dsl.Value, ...]
    c: tuple[dsl.Value, ...]


@dataclass(frozen=True)
class _LoopState:
    accs: tuple[dsl.Value, ...]
    afs: tuple[dsl.Value, ...]
    bfs: tuple[dsl.Value, ...]


def _kernel_types(cfg: _MatmulConfig) -> _KernelTypes:
    return _KernelTypes(
        a=dsl.fragment_type(
            0, dsl.f16(), 16, 16, cfg.mma.wave_size, cfg.mma.ab_registers
        ),
        b=dsl.fragment_type(
            1, dsl.f16(), 16, 16, cfg.mma.wave_size, cfg.mma.ab_registers
        ),
        acc=dsl.fragment_type(
            2, dsl.f32(), 16, 16, cfg.mma.wave_size, cfg.mma.acc_registers
        ),
    )


def _initial_tile_ptrs(
    bld: dsl.FunctionBuilder, cfg: _MatmulConfig, coords: _TileCoords
) -> _TilePtrs:
    a0 = _tile_fragment_ptrs(bld, cfg, coords.a_lane_base, cfg.wave_m_tiles)
    b0 = _tile_fragment_ptrs(bld, cfg, coords.b_lane_base, cfg.wave_n_tiles)
    a_dma0: tuple[dsl.Value, ...] = ()
    b_dma0: tuple[dsl.Value, ...] = ()
    if cfg.use_dma_lds:
        wi = dsl.sym("wi")
        lane = dsl.mod(wi, cfg.mma.wave_size)
        chunks_per_row = cfg.mma.k_tile // cfg.mma.lane_k_elems
        row = dsl.floor(lane / chunks_per_row)
        physical_col = dsl.mod(lane, chunks_per_row)
        logical_col = _dma_logical_col(cfg, row, physical_col)
        dma_lane_off = bld.index_expr(
            row * cfg.K + logical_col * cfg.mma.lane_k_elems,
            bindings={wi: coords.wi},
        )
        a_dma_base = bld.ptr_add(coords.a_tile_base, dma_lane_off)
        b_dma_base = bld.ptr_add(coords.b_tile_base, dma_lane_off)
        a_dma0 = _tile_fragment_ptrs(bld, cfg, a_dma_base, cfg.wave_m_tiles)
        b_dma0 = _tile_fragment_ptrs(bld, cfg, b_dma_base, cfg.wave_n_tiles)
    c = tuple(
        _ptr_add_const(bld, coords.c_ptr, i * 256) for i in range(cfg.tiles_per_wave)
    )
    return _TilePtrs(a0=a0, b0=b0, a_dma0=a_dma0, b_dma0=b_dma0, c=c)


def _advance_ptrs(
    bld: dsl.FunctionBuilder, ptrs: tuple[dsl.Value, ...], offset: dsl.Value
) -> tuple[dsl.Value, ...]:
    return tuple(bld.ptr_add(ptr, offset) for ptr in ptrs)


def _load_ptrs_for_step(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    ptrs: _TilePtrs,
    loop_iv: dsl.Value,
    virtual_k_stride: dsl.Value,
) -> tuple[tuple[dsl.Value, ...], tuple[dsl.Value, ...]]:
    a0 = ptrs.a_dma0 if cfg.use_dma_lds else ptrs.a0
    b0 = ptrs.b_dma0 if cfg.use_dma_lds else ptrs.b0
    max_step = max(cfg.virtual_k_steps - 1, 1)
    step = bld.addi(loop_iv, bld.constant(dsl.i32(), 1))
    step = bld.assume_range(step, 1, max_step)
    offset = bld.muli(step, virtual_k_stride)
    offset = bld.assume_range(
        offset,
        cfg.mma.k_tile * cfg.wave_k_tiles,
        cfg.mma.k_tile * cfg.wave_k_tiles * max_step,
    )
    return _advance_ptrs(bld, a0, offset), _advance_ptrs(bld, b0, offset)


def _initial_loop_args(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    types: _KernelTypes,
    staging: _LdsStaging,
    ptrs: _TilePtrs,
) -> tuple[dsl.Value, ...]:
    init_acc = bld.fragment_fill(bld.constant(dsl.i32(), 0), types.acc)
    a0 = ptrs.a_dma0 if cfg.use_dma_lds else ptrs.a0
    b0 = ptrs.b_dma0 if cfg.use_dma_lds else ptrs.b0
    a_frags, b_frags = _load_fragment_group(bld, cfg, a0, b0, types, staging)
    init_accs = tuple(init_acc for _ in range(cfg.tiles_per_wave))
    wave_k = bld.static_param("wave_k_tiles", IndexType.get())
    a_pt = _pack_frags_into_nested_parametric_ptuple(
        bld, a_frags, cfg.wave_m_tiles, cfg.wave_k_tiles, wave_k
    )
    b_pt = _pack_frags_into_nested_parametric_ptuple(
        bld, b_frags, cfg.wave_n_tiles, cfg.wave_k_tiles, wave_k
    )
    return (
        *init_accs,
        a_pt,
        b_pt,
    )


def _split_loop_state(values: tuple[dsl.Value, ...], cfg: _MatmulConfig) -> _LoopState:
    acc_end = cfg.tiles_per_wave
    return _LoopState(
        accs=values[:acc_end],
        afs=(values[acc_end],),
        bfs=(values[acc_end + 1],),
    )


def _ptuple_type(element_type: dsl.Type, count: int) -> dsl.Type:
    i64 = IntegerType.get_signless(64)
    return PTupleType.get(element_type, IntegerAttr.get(i64, count))


def _param_ptuple_type(element_type: dsl.Type, name: str) -> dsl.Type:
    return PTupleType.get(element_type, StringAttr.get(name))


def _pack_frags_into_nested_parametric_ptuple(
    bld: dsl.FunctionBuilder,
    frags: tuple[dsl.Value, ...],
    rows: int,
    cols: int,
    k_param: dsl.Value,
    width_name: str = "wave_k_tiles",
) -> dsl.Value:
    """Wrap a `rows * cols` flat frag list (laid out as `k * rows + i`)
    into a single nested parametric ptuple
    `ptuple<ptuple<af, rows>, $width_name>`. Outer width is parametric
    in `wave_k_tiles`, inner stays concrete -- so `bind_param
    wave_k_tiles` shrinks the K dimension while M stays at its
    build-time count.
    """
    if cols == 0:
        raise ValueError("need at least one K-tile worth of frags")
    element_type = frags[0].type
    index = IndexType.get()
    inner_pt_type = _ptuple_type(element_type, rows)
    inners: list[dsl.Value] = []
    for k in range(cols):
        row = list(frags[k * rows : (k + 1) * rows])
        inners.append(wavemeta.TupleMakeOp(inner_pt_type, row).result)
    max_outer_pt_type = _ptuple_type(inner_pt_type, cols)
    max_outer = wavemeta.TupleMakeOp(max_outer_pt_type, inners).result
    param_pt_type = _param_ptuple_type(inner_pt_type, width_name)
    init = wavemeta.TupleMakeBroadcastOp(param_pt_type, inners[0]).result
    c0 = bld.constant(index, 0)
    c1 = bld.constant(index, 1)
    with bld.static_for(c0, k_param, c1, init_args=[init]) as loop:
        k_iv = loop.induction_variable
        (acc,) = loop.inner_iter_args
        inner = wavemeta.TupleGetOp(inner_pt_type, max_outer, k_iv).result
        new = wavemeta.TupleSetOp(param_pt_type, acc, k_iv, inner).result
        wavemeta.YieldOp([new])
    return loop.results[0]


def _flat_extract(
    bld: dsl.FunctionBuilder,
    ptuple_value: dsl.Value,
    element_type: dsl.Type,
    count: int,
) -> tuple[dsl.Value, ...]:
    """Constant-index tuple_get for every slot. The specialiser folds
    these to the producing tuple_make's operands.
    """
    index = IndexType.get()
    out = []
    for i in range(count):
        idx = bld.constant(index, i)
        out.append(wavemeta.TupleGetOp(element_type, ptuple_value, idx).result)
    return tuple(out)


def _emit_mma_grid(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    afs: tuple[dsl.Value, ...],
    bfs: tuple[dsl.Value, ...],
    accs: tuple[dsl.Value, ...],
) -> tuple[dsl.Value, ...]:
    """Triply-nested `wavemeta.static_for` over (k, i, j); the
    specialiser unrolls all three once the tile-factor params bind.
    Accumulator state rides through as a `!wavemeta.ptuple` so the
    inner body can address it by `i * wave_n + j`.
    """
    if not accs:
        return ()

    acc_type = accs[0].type
    a_outer_type = PTupleType(afs[0].type)
    b_outer_type = PTupleType(bfs[0].type)
    a_row_type = a_outer_type.element_type
    b_row_type = b_outer_type.element_type
    af_type = PTupleType(a_row_type).element_type
    bf_type = PTupleType(b_row_type).element_type

    acc_count = cfg.tiles_per_wave
    acc_pt_type = _ptuple_type(acc_type, acc_count)
    accs_t = wavemeta.TupleMakeOp(acc_pt_type, list(accs)).result

    index = IndexType.get()
    c0 = bld.constant(index, 0)
    c1 = bld.constant(index, 1)
    wave_k = bld.static_param("wave_k_tiles", index)
    wave_m = bld.static_param("wave_m_tiles", index)
    wave_n = bld.static_param("wave_n_tiles", index)

    with bld.static_for(c0, wave_k, c1, init_args=[accs_t]) as outer:
        k_iv = outer.induction_variable
        (accs_k,) = outer.inner_iter_args
        a_row = wavemeta.TupleGetOp(a_row_type, afs[0], k_iv).result
        b_row = wavemeta.TupleGetOp(b_row_type, bfs[0], k_iv).result
        with bld.static_for(c0, wave_m, c1, init_args=[accs_k]) as mid:
            i_iv = mid.induction_variable
            (accs_ki,) = mid.inner_iter_args
            af = wavemeta.TupleGetOp(af_type, a_row, i_iv).result
            with bld.static_for(c0, wave_n, c1, init_args=[accs_ki]) as inner:
                j_iv = inner.induction_variable
                (accs_kij,) = inner.inner_iter_args
                wn = dsl.idx(wave_n)
                i = dsl.idx(i_iv)
                j = dsl.idx(j_iv)
                acc_idx = (i * wn + j).v
                bf = wavemeta.TupleGetOp(bf_type, b_row, j_iv).result
                acc_old = wavemeta.TupleGetOp(acc_type, accs_kij, acc_idx).result
                acc_new = bld.mma(cfg.mma.kind, af, bf, acc_old)
                accs_kij_new = wavemeta.TupleSetOp(
                    acc_pt_type, accs_kij, acc_idx, acc_new
                ).result
                wavemeta.YieldOp([accs_kij_new])
            wavemeta.YieldOp([inner.results[0]])
        wavemeta.YieldOp([mid.results[0]])

    return _flat_extract(bld, outer.results[0], acc_type, acc_count)


def _emit_pipelined_step(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    types: _KernelTypes,
    staging: _LdsStaging,
    state: _LoopState,
    a_ptrs: tuple[dsl.Value, ...],
    b_ptrs: tuple[dsl.Value, ...],
) -> list[dsl.Value]:
    # Tokens keep this step's VMEM/DMA live across the previous MMA grid.
    if cfg.use_dma_lds:
        dma_tokens = _dma_issue(bld, a_ptrs, b_ptrs, staging)
        new_accs = _emit_mma_grid(bld, cfg, state.afs, state.bfs, state.accs)
        new_afs, new_bfs = _dma_drain(bld, dma_tokens, types.a, types.b, staging)
    else:
        a_loads, b_loads = _lds_global_loads(bld, a_ptrs, b_ptrs, staging)
        new_accs = _emit_mma_grid(bld, cfg, state.afs, state.bfs, state.accs)
        new_afs, new_bfs = _lds_store_reload(
            bld, a_loads, b_loads, types.a, types.b, staging
        )
    wave_k = bld.static_param("wave_k_tiles", IndexType.get())
    a_pt = _pack_frags_into_nested_parametric_ptuple(
        bld, new_afs, cfg.wave_m_tiles, cfg.wave_k_tiles, wave_k
    )
    b_pt = _pack_frags_into_nested_parametric_ptuple(
        bld, new_bfs, cfg.wave_n_tiles, cfg.wave_k_tiles, wave_k
    )
    return [
        *new_accs,
        a_pt,
        b_pt,
    ]


def _store_final_tiles(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    state: _LoopState,
    c_ptrs: tuple[dsl.Value, ...],
) -> None:
    final_accs = _emit_mma_grid(bld, cfg, state.afs, state.bfs, state.accs)
    for acc, c_ptr in zip(final_accs, c_ptrs, strict=True):
        if cfg.output_type == "f16":
            _fragment_store_f16(bld, cfg, acc, c_ptr)
        else:
            bld.fragment_store(acc, c_ptr)


def _fragment_store_f16(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    fragment: dsl.Value,
    ptr: dsl.Value,
    *,
    after: dsl.Value | None = None,
) -> dsl.Value:
    if cfg.mma.acc_registers % 2 != 0:
        raise ValueError("f16 output needs an even accumulator register count")
    regs_type = dsl.simd_type(
        dsl.vector_type(cfg.mma.acc_registers, dsl.f32()), width=cfg.mma.wave_size
    )
    regs = waveamd.FragmentUnpackOp(regs_type, fragment).result
    wi_sym = dsl.sym("__wave_dsl_frag_wi")
    wi_val = bld.assume_range(
        bld.workitem_id(axis=0, width=cfg.mma.wave_size),
        0,
        cfg.threads_per_workgroup - 1,
    )
    lane_off = bld.index_expr(
        dsl.mod(wi_sym, cfg.mma.wave_size) * cfg.mma.acc_registers,
        {wi_sym: wi_val},
    )
    lane_off = bld.assume_range(
        lane_off, 0, (cfg.mma.wave_size - 1) * cfg.mma.acc_registers
    )
    base = bld.ptr_add(ptr, lane_off)
    f32_simd = dsl.simd_type(dsl.f32(), width=cfg.mma.wave_size)
    f16_simd = dsl.simd_type(dsl.f16(), width=cfg.mma.wave_size)
    f16_pair = dsl.simd_type(dsl.vector_type(2, dsl.f16()), width=cfg.mma.wave_size)
    tokens: list[dsl.Value] = []
    for i in range(0, cfg.mma.acc_registers, 2):
        lo = wave.ExtractOp(f32_simd, regs, i).result
        hi = wave.ExtractOp(f32_simd, regs, i + 1).result
        packed = wave.PackOp(
            f16_pair,
            [bld.fpconvert(lo, f16_simd), bld.fpconvert(hi, f16_simd)],
        ).result
        tokens.append(bld.store(packed, _ptr_add_const(bld, base, i), after=after))
    return tokens[0] if len(tokens) == 1 else bld.join(*tokens)


def _emit_constant_fill(
    bld: dsl.FunctionBuilder,
    buf: dsl.Value,
    values: tuple[float, ...],
    element_type: dsl.Type,
    index_type: dsl.Type,
) -> None:
    for i, value in enumerate(values):
        bld.memref_store(
            bld.constant(element_type, value),
            buf,
            [bld.constant(index_type, i)],
        )


def _emit_kernel(bld: dsl.FunctionBuilder, cfg: _MatmulConfig) -> None:
    """Populate tiled matmul kernel body."""
    coords = _emit_tile_coords(bld, cfg)
    types = _kernel_types(cfg)
    staging = _emit_lds_staging(bld, cfg, coords)
    virtual_k_stride = bld.constant(dsl.i32(), cfg.mma.k_tile * cfg.wave_k_tiles)
    ptrs = _initial_tile_ptrs(bld, cfg, coords)
    init_args = _initial_loop_args(bld, cfg, types, staging, ptrs)

    # The fourth kernel arg is the pipelined-loop trip count
    # (`K / (16 * wave_k_tiles) - 1`, precomputed on host).
    trip_count_i32 = bld.assume_range(bld.args[3], 0, max(cfg.virtual_k_steps - 1, 0))
    zero_i32 = bld.constant(dsl.i32(), 0)
    one_i32 = bld.constant(dsl.i32(), 1)

    with bld.for_loop(
        zero_i32,
        trip_count_i32,
        one_i32,
        init_args=init_args,
    ) as forop:
        state = _split_loop_state(tuple(forop.inner_iter_args), cfg)
        loop_iv = bld.assume_range(
            forop.induction_variable, 0, max(cfg.virtual_k_steps - 2, 0)
        )
        a_ptrs, b_ptrs = _load_ptrs_for_step(bld, cfg, ptrs, loop_iv, virtual_k_stride)
        bld.yield_(
            _emit_pipelined_step(
                bld,
                cfg,
                types,
                staging,
                state,
                a_ptrs,
                b_ptrs,
            )
        )

    final_state = _split_loop_state(tuple(forop.results), cfg)
    _store_final_tiles(bld, cfg, final_state, ptrs.c)


def _emit_host(bld: dsl.FunctionBuilder, cfg: _MatmulConfig) -> None:
    """Populate the host ``main`` that allocates, launches, and prints.

    The validation fill uses a per-axis split so each output element
    depends on *both* A and B (so we can distinguish "matmul actually
    ran" from "kernel happened to sum K ones"):

      * A[i, k] = 1.0 for i in [0, M/2) and 2.0 for i in [M/2, M).
      * B[k, j] = 1.0 for j in [0, N/2) and 2.0 for j in [N/2, N).

    With that fill, C[i, j] = K * a(i) * b(j) takes values K, 2K, 4K
    across the four output quadrants -- a pattern the lit CHECK lines
    pin down directly.
    """
    index = dsl.index_type()
    f16 = dsl.f16()
    f16_ptr = dsl.ptr_type(f16)
    c_type = cfg.c_type
    c_ptr_type = dsl.ptr_type(c_type)

    c0 = bld.constant(index, 0)
    c1 = bld.constant(index, 1)
    blocks_m = bld.constant(index, cfg.M_blocks)
    blocks_n = bld.constant(index, cfg.N_blocks)
    threads = bld.constant(index, cfg.threads_per_workgroup)
    c_total = bld.constant(index, cfg.total_elements)

    one_f16 = bld.constant(f16, 1.0)
    two_f16 = bld.constant(f16, 2.0)
    zero_c = bld.constant(c_type, 0.0)

    a_buf = bld.alloc([cfg.a_elements], f16)
    b_buf = bld.alloc([cfg.b_elements], f16)
    c_buf = bld.alloc([cfg.total_elements], c_type)

    if cfg.random_data:
        a_values, b_values = generate_wmma_f16_matmul_inputs(
            cfg.M,
            cfg.N,
            cfg.K,
            random_data=True,
            random_seed=cfg.random_seed,
        )
        _emit_constant_fill(bld, a_buf, a_values, f16, index)
        _emit_constant_fill(bld, b_buf, b_values, f16, index)
    else:
        # A is row-major MxK: rows [0, M/2) -> first M*K/2 elements (1.0);
        # rows [M/2, M) -> the rest (2.0).
        a_half = bld.constant(index, cfg.a_elements // 2)
        a_total = bld.constant(index, cfg.a_elements)
        with bld.for_loop(c0, a_half, c1) as i:
            bld.memref_store(one_f16, a_buf, [i])
        with bld.for_loop(a_half, a_total, c1) as i:
            bld.memref_store(two_f16, a_buf, [i])

        # B is column-major KxN (== row-major NxK): columns [0, N/2) -> first
        # N*K/2 elements (1.0); columns [N/2, N) -> the rest (2.0).
        b_half = bld.constant(index, cfg.b_elements // 2)
        b_total = bld.constant(index, cfg.b_elements)
        with bld.for_loop(c0, b_half, c1) as i:
            bld.memref_store(one_f16, b_buf, [i])
        with bld.for_loop(b_half, b_total, c1) as i:
            bld.memref_store(two_f16, b_buf, [i])

    with bld.for_loop(c0, c_total, c1) as i:
        bld.memref_store(zero_c, c_buf, [i])

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
    if cfg.output_type == "f16":
        [c_ptr] = bld.call(
            _F16_PTR_HELPER, [bld.memref_cast(c_buf, dyn_f16)], [c_ptr_type]
        )
    else:
        [c_ptr] = bld.call(_F32_PTR_HELPER, [c_buf], [c_ptr_type])

    trip_count_value = bld.constant(dsl.i32(), max(cfg.virtual_k_steps - 1, 0))
    launch_operands = [a_ptr, b_ptr, c_ptr, trip_count_value]
    bld.launch(
        _GPU_MODULE_NAME,
        _KERNEL_NAME,
        grid=(blocks_m, blocks_n, c1),
        block=(threads, c1, c1),
        operands=launch_operands,
    )
    print_helper = _PRINT_F16_HELPER if cfg.output_type == "f16" else _PRINT_HELPER
    bld.call(print_helper, [c_unranked])


def build_wmma_f16_matmul_module(
    M: int,
    N: int,
    K: int,
    *,
    BM: int = 1,
    BN: int = 1,
    wave_m_tiles: int = 1,
    wave_n_tiles: int = 1,
    wave_k_tiles: int = 1,
    use_buffer: bool = False,
    use_dma_lds: bool = False,
    matrix_intrinsic: str = "wmma",
    output_type: str = "f32",
    random_data: bool = False,
    random_seed: int = 0,
    skip_specialize: bool = False,
    target_waves: int | None = None,
) -> Module:
    """Return an MLIR module for the tiled f16 matmul host + kernel."""
    cfg = _MatmulConfig(
        M=M,
        N=N,
        K=K,
        BM=BM,
        BN=BN,
        wave_m_tiles=wave_m_tiles,
        wave_n_tiles=wave_n_tiles,
        wave_k_tiles=wave_k_tiles,
        use_buffer=use_buffer,
        use_dma_lds=use_dma_lds,
        matrix_intrinsic=matrix_intrinsic,
        output_type=output_type,
        random_data=random_data,
        random_seed=random_seed,
    )
    bld = dsl.ModuleBuilder()
    with bld:
        bld.declare_external(
            _F16_PTR_HELPER,
            [dsl.dynamic_1d_memref_type(dsl.f16())],
            [dsl.ptr_type(dsl.f16())],
        )
        if cfg.output_type == "f16":
            bld.declare_external(
                _PRINT_F16_HELPER,
                [dsl.unranked_memref_type(dsl.f16())],
                [],
            )
        else:
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
            dsl.ptr_type(cfg.c_type),
            # Software-pipeline loop trip count: K // 16 - 1.
            dsl.i32(),
        ]
        lds_size = cfg.lds_bytes
        with (
            bld.gpu_module(_GPU_MODULE_NAME) as gmod,
            gmod.kernel(
                _KERNEL_NAME,
                kernel_inputs,
                lds_size=lds_size,
                attrs=_target_waves_attrs(target_waves),
            ) as fb,
        ):
            _emit_kernel(fb, cfg)

        with bld.host_main() as fb:
            _emit_host(fb, cfg)

        _attach_wavemeta_params(bld.module, cfg)
        if not skip_specialize:
            dsl.specialize_wavemeta(bld.module)

    return bld.module


def _attach_wavemeta_params(module: Module, cfg: _MatmulConfig) -> None:
    """Install the `wavemeta.params` dict the specialiser reads."""
    index = IndexType.get()
    bindings = {
        "wave_k_tiles": IntegerAttr.get(index, cfg.wave_k_tiles),
        "wave_m_tiles": IntegerAttr.get(index, cfg.wave_m_tiles),
        "wave_n_tiles": IntegerAttr.get(index, cfg.wave_n_tiles),
    }
    module.operation.attributes[wavemeta.PARAMS_ATTR_NAME] = DictAttr.get(bindings)


__all__ = [
    "build_wmma_f16_matmul_module",
    "compute_wmma_f16_matmul_reference_buffer",
    "generate_wmma_f16_matmul_inputs",
]
