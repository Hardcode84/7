#  Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
#  See https://llvm.org/LICENSE.txt for license information.
#  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

"""Builder for tiled Wave matmul kernels + host driver.

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

Setting ``use_buffer=True`` wraps the A, B, and C kernel inputs in
``waveamd.make_buffer`` at the very top of the kernel, turning the
subsequent per-K-step fragment loads into tuple ``buffer_load_b32``
ops (lowered to ``buffer_load_dword ..., 0 offen offset:i*4``) before
they stage through LDS and the C fragment stores into buffer stores.

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
    ("wmma", "f16"): _MmaVariant("wmma", "wmma.f32.16x16x16.f16", 8, 8),
    ("wmma", "bf16"): _MmaVariant("wmma", "wmma.f32.16x16x16.bf16", 8, 8),
    ("mfma", "f16"): _MmaVariant("mfma", "mfma.f32.16x16x16.f16", 2, 4),
    ("mfma", "bf16"): _MmaVariant("mfma", "mfma.f32.16x16x16.bf16", 2, 4),
    ("mfma_gfx950", "f16"): _MmaVariant(
        "mfma_gfx950", "mfma.f32.16x16x32.f16", 4, 4, 64, 8, 32
    ),
    ("mfma_gfx950", "bf16"): _MmaVariant(
        "mfma_gfx950", "mfma.f32.16x16x32.bf16", 4, 4, 64, 8, 32
    ),
    ("mfma_gfx950", "mxfp4"): _MmaVariant(
        "mfma_gfx950", "mfma.scale.f32.16x16x128.f4.f4", 4, 4, 64, 32, 128
    ),
}


def _select_mma_variant(name: str, input_type: str) -> _MmaVariant:
    try:
        return _MMA_VARIANTS[(name, input_type)]
    except KeyError as exc:
        choices = ", ".join(
            f"{variant}/{dtype}" for variant, dtype in sorted(_MMA_VARIANTS)
        )
        raise ValueError(
            f"unknown matrix intrinsic/input type '{name}/{input_type}'; "
            f"expected {choices}"
        ) from exc


def _validate_choice(name: str, value: str, choices: tuple[str, ...]) -> None:
    if value not in choices:
        expected = " or ".join(f"'{choice}'" for choice in choices)
        raise ValueError(f"{name} must be {expected}; got {value}")


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
    input_type: str = "f16"
    output_type: str = "f32"
    random_data: bool = False
    random_seed: int = 0
    cta_swizzle_xcds: int = 1
    cta_group_m: int = 1

    def __post_init__(self) -> None:
        _validate_positive_shape(self)
        _validate_tile_shape(self)

    @property
    def total_elements(self) -> int:
        return self.M * self.N

    @property
    def a_elements(self) -> int:
        return self.M * self.storage_K

    @property
    def b_elements(self) -> int:
        # B is laid out in column-major K x N order (== row-major N x K), so
        # lane L's contiguous-16 slice for column j lives at j * K.
        return self.N * self.storage_K

    @property
    def c_elements(self) -> int:
        return self.M * self.N

    @property
    def c_type(self) -> dsl.Type:
        return dsl.f16() if self.output_type == "f16" else dsl.f32()

    @property
    def input_element_type(self) -> dsl.Type:
        if self.input_type == "mxfp4":
            return dsl.i8()
        return dsl.bf16() if self.input_type == "bf16" else dsl.f16()

    @property
    def input_element_bytes(self) -> int:
        return 1 if self.uses_packed_mxfp4 else 2

    @property
    def uses_packed_mxfp4(self) -> bool:
        return self.input_type == "mxfp4"

    @property
    def storage_K(self) -> int:
        return self.K // 2 if self.uses_packed_mxfp4 else self.K

    @property
    def storage_k_tile(self) -> int:
        return self.mma.k_tile // 2 if self.uses_packed_mxfp4 else self.mma.k_tile

    @property
    def storage_lane_k_elems(self) -> int:
        if self.uses_packed_mxfp4:
            return self.mma.lane_k_elems // 2
        return self.mma.lane_k_elems

    @property
    def storage_k_tile_dwords(self) -> int:
        return self.storage_k_tile * self.input_element_bytes // 4

    @property
    def storage_lane_k_dwords(self) -> int:
        return self.storage_lane_k_elems * self.input_element_bytes // 4

    @property
    def scale_groups(self) -> int:
        return self.K // 32

    @property
    def a_scale_elements(self) -> int:
        return self.M * self.scale_groups

    @property
    def b_scale_elements(self) -> int:
        return self.N * self.scale_groups

    @property
    def trip_count_arg_index(self) -> int:
        return 5 if self.uses_packed_mxfp4 else 3

    @property
    def c_element_bytes(self) -> int:
        return 2 if self.output_type == "f16" else 4

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
        return self.data_lds_bytes + self.scale_lds_bytes

    @property
    def data_lds_bytes(self) -> int:
        if self.use_dma_lds:
            one_buffer = (
                self.wave_k_tiles
                * (self.BM * self.wave_m_tiles + self.BN * self.wave_n_tiles)
                * self.mma.lds_dwords_per_frag
                * 4
            )
            return one_buffer * (2 if self.virtual_k_steps > 1 else 1)
        return (
            self.wave_k_tiles
            * (self.wave_m_tiles + self.wave_n_tiles)
            * self.waves_per_workgroup
            * self.mma.lds_dwords_per_frag
            * 4
        )

    @property
    def scale_lds_bytes(self) -> int:
        if not self.uses_packed_mxfp4:
            return 0
        if self.use_dma_lds:
            return 0
        scale_tiles = self.BM * self.wave_m_tiles + self.BN * self.wave_n_tiles
        return scale_tiles * 512

    @property
    def mma(self) -> _MmaVariant:
        return _select_mma_variant(self.matrix_intrinsic, self.input_type)


def _validate_positive_shape(cfg: _MatmulConfig) -> None:
    for dim, val in (("M", cfg.M), ("N", cfg.N), ("K", cfg.K)):
        if val <= 0 or val % 16 != 0:
            raise ValueError(f"{dim} must be a positive multiple of 16; got {val}")
    if cfg.BM < 1 or cfg.BN < 1:
        raise ValueError(f"BM and BN must be >= 1; got BM={cfg.BM}, BN={cfg.BN}")
    _validate_cta_remap_params(cfg)
    _validate_wave_tile_counts(cfg)
    _validate_choice("output_type", cfg.output_type, ("f32", "f16"))
    _validate_choice("input_type", cfg.input_type, ("f16", "bf16", "mxfp4"))


def _validate_cta_remap_params(cfg: _MatmulConfig) -> None:
    if cfg.cta_swizzle_xcds < 1:
        raise ValueError(f"cta_swizzle_xcds must be >= 1; got {cfg.cta_swizzle_xcds}")
    if cfg.cta_group_m < 1:
        raise ValueError(f"cta_group_m must be >= 1; got {cfg.cta_group_m}")


def _validate_wave_tile_counts(cfg: _MatmulConfig) -> None:
    if cfg.wave_m_tiles < 1 or cfg.wave_n_tiles < 1 or cfg.wave_k_tiles < 1:
        raise ValueError(
            f"wave_m_tiles, wave_n_tiles and wave_k_tiles must be >= 1; "
            f"got wave_m_tiles={cfg.wave_m_tiles}, "
            f"wave_n_tiles={cfg.wave_n_tiles}, "
            f"wave_k_tiles={cfg.wave_k_tiles}"
        )


def _validate_tile_shape(cfg: _MatmulConfig) -> None:
    _validate_mxfp4_shape(cfg)
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
    _validate_dma_lds_shape(cfg)
    if cfg.waves_per_workgroup > 32:
        raise ValueError(
            f"BM * BN must be <= 32 (RDNA3 workgroup wave cap); "
            f"got BM={cfg.BM}, BN={cfg.BN} (product={cfg.waves_per_workgroup})"
        )
    if cfg.cta_swizzle_xcds > 1:
        total_ctas = cfg.M_blocks * cfg.N_blocks
        if total_ctas % cfg.cta_swizzle_xcds != 0:
            raise ValueError(
                "cta_swizzle_xcds currently requires total CTA count to divide "
                f"evenly; got total={total_ctas}, xcds={cfg.cta_swizzle_xcds}"
            )
    if cfg.M_blocks % cfg.cta_group_m != 0:
        raise ValueError(
            "cta_group_m currently requires M_blocks to divide evenly; "
            f"got M_blocks={cfg.M_blocks}, cta_group_m={cfg.cta_group_m}"
        )


def _validate_dma_lds_shape(cfg: _MatmulConfig) -> None:
    if not cfg.use_dma_lds:
        return
    if cfg.mma.name != "mfma_gfx950":
        raise ValueError("use_dma_lds is currently supported only for gfx950 MFMA")
    a_slots = cfg.wave_k_tiles * cfg.BM * cfg.wave_m_tiles
    b_slots = cfg.wave_k_tiles * cfg.BN * cfg.wave_n_tiles
    if a_slots % cfg.waves_per_workgroup != 0:
        raise ValueError("DMA LDS A slots must divide evenly across waves")
    if b_slots % cfg.waves_per_workgroup != 0:
        raise ValueError("DMA LDS B slots must divide evenly across waves")


def _validate_mxfp4_shape(cfg: _MatmulConfig) -> None:
    if not cfg.uses_packed_mxfp4:
        return
    if cfg.wave_k_tiles != 1:
        raise ValueError("MXFP4 scaled MFMA currently supports wave_k_tiles=1")


_KERNEL_NAME = "wmma_f16_matmul_tiled"
_GPU_MODULE_NAME = "kernels"
_F16_PTR_HELPER = "wave_memref_to_ptr_global_f16"
_BF16_PTR_HELPER = "wave_memref_to_ptr_global_bf16"
_I8_PTR_HELPER = "wave_memref_to_ptr_global_i8"
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


def _round_bf16(value: float) -> float:
    bits = struct.unpack("<I", struct.pack("<f", float(value)))[0]
    rounded = bits + 0x7FFF + ((bits >> 16) & 1)
    return float(struct.unpack("<f", struct.pack("<I", rounded & 0xFFFF0000))[0])


def _round_input(value: float, input_type: str) -> float:
    if input_type == "mxfp4":
        return value
    return _round_bf16(value) if input_type == "bf16" else _round_f16(value)


def _e8m0_to_f32(raw: int) -> float:
    return 2.0 ** (raw - 127)


def _deterministic_mxfp4_codes(
    count: int, *, seed: int, stream: int
) -> tuple[int, ...]:
    state = (seed ^ ((stream + 1) * 0x9E3779B9)) & 0xFFFFFFFF
    values: list[int] = []
    for _ in range(count):
        state = (1664525 * state + 1013904223) & 0xFFFFFFFF
        values.append(0x2 if ((state >> 31) & 1) else 0x4)
    return tuple(values)


def _mxfp4_code_to_f32(raw: int) -> float:
    if raw == 0x2:
        return 1.0
    if raw == 0x4:
        return 2.0
    raise ValueError(f"unsupported MXFP4 test code {raw}")


def _pack_mxfp4_codes(values: tuple[int, ...]) -> tuple[int, ...]:
    if len(values) % 2 != 0:
        raise ValueError("MXFP4 packed input length must be even")
    return tuple(values[i] | (values[i + 1] << 4) for i in range(0, len(values), 2))


def generate_mxfp4_packed_matmul_inputs(
    M: int,
    N: int,
    K: int,
    *,
    random_seed: int = 0,
) -> tuple[tuple[int, ...], tuple[int, ...]]:
    a_codes = _deterministic_mxfp4_codes(M * K, seed=random_seed, stream=0)
    b_codes = _deterministic_mxfp4_codes(N * K, seed=random_seed, stream=1)
    return _pack_mxfp4_codes(a_codes), _pack_mxfp4_codes(b_codes)


def _mxfp4_scale_raw_values(
    rows: int, groups: int, high: int, low: int
) -> tuple[int, ...]:
    half_rows = rows // 2
    return tuple(
        (high if row < half_rows else low) - group
        for row in range(rows)
        for group in range(groups)
    )


def generate_mxfp4_scale_inputs(
    M: int, N: int, K: int
) -> tuple[tuple[int, ...], tuple[int, ...]]:
    groups = K // 32
    return (
        _mxfp4_scale_raw_values(M, groups, 0x7F, 0x7E),
        _mxfp4_scale_raw_values(N, groups, 0x7F, 0x7D),
    )


def generate_wmma_f16_matmul_inputs(
    M: int,
    N: int,
    K: int,
    *,
    input_type: str = "f16",
    random_data: bool = False,
    random_seed: int = 0,
) -> tuple[tuple[float, ...], tuple[float, ...]]:
    if random_data:
        if input_type == "mxfp4":
            a_codes = _deterministic_mxfp4_codes(M * K, seed=random_seed, stream=0)
            b_codes = _deterministic_mxfp4_codes(N * K, seed=random_seed, stream=1)
            return (
                tuple(_mxfp4_code_to_f32(value) for value in a_codes),
                tuple(_mxfp4_code_to_f32(value) for value in b_codes),
            )
        a_values = _deterministic_random_values(M * K, seed=random_seed, stream=0)
        b_values = _deterministic_random_values(N * K, seed=random_seed, stream=1)
    else:
        a_half = (M * K) // 2
        b_half = (N * K) // 2
        a_values = tuple([1.0] * a_half + [2.0] * (M * K - a_half))
        b_values = tuple([1.0] * b_half + [2.0] * (N * K - b_half))

    return (
        tuple(_round_input(value, input_type) for value in a_values),
        tuple(_round_input(value, input_type) for value in b_values),
    )


def _reference_tile(
    cfg: _MatmulConfig,
    a_values: tuple[float, ...],
    b_values: tuple[float, ...],
    m_tile: int,
    n_tile: int,
    a_scales: tuple[int, ...] | None = None,
    b_scales: tuple[int, ...] | None = None,
) -> tuple[float, ...]:
    tile: list[float] = []
    for mi in range(16):
        m = m_tile * 16 + mi
        for nj in range(16):
            n = n_tile * 16 + nj
            acc = 0.0
            for k in range(cfg.K):
                a = a_values[m * cfg.K + k]
                b = b_values[n * cfg.K + k]
                if cfg.uses_packed_mxfp4:
                    assert a_scales is not None and b_scales is not None
                    group = k // 32
                    a *= _e8m0_to_f32(a_scales[m * cfg.scale_groups + group])
                    b *= _e8m0_to_f32(b_scales[n * cfg.scale_groups + group])
                acc += a * b
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
    input_type: str = "f16",
    output_type: str = "f32",
    cta_swizzle_xcds: int = 1,
    cta_group_m: int = 1,
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
        input_type=input_type,
        output_type=output_type,
        cta_swizzle_xcds=cta_swizzle_xcds,
        cta_group_m=cta_group_m,
    )
    a_values, b_values = generate_wmma_f16_matmul_inputs(
        M,
        N,
        K,
        input_type=input_type,
        random_data=random_data,
        random_seed=random_seed,
    )
    a_scales: tuple[int, ...] | None = None
    b_scales: tuple[int, ...] | None = None
    if cfg.uses_packed_mxfp4:
        a_scales, b_scales = generate_mxfp4_scale_inputs(M, N, K)
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
                            _reference_tile(
                                cfg,
                                a_values,
                                b_values,
                                m_tile,
                                n_tile,
                                a_scales,
                                b_scales,
                            )
                        )
    if cfg.output_type == "f16":
        return tuple(_round_f16(value) for value in out)
    return tuple(out)


@dataclass(frozen=True)
class _TileCoords:
    """Per-wave coordinates derived from `workitem_id` / `workgroup_id`."""

    wi: dsl.Value  # raw workitem_id; wave_id = wi // 32 lives in index_expr
    wg_m: dsl.Value
    wg_n: dsl.Value
    a_base: dsl.Value
    b_base: dsl.Value
    a_tile_base: dsl.Value
    b_tile_base: dsl.Value
    a_lane_base: dsl.Value
    b_lane_base: dsl.Value
    a_scale_base: dsl.Value | None
    b_scale_base: dsl.Value | None
    c_ptr: dsl.Value


def _wrap_in_buffer(
    bld: dsl.FunctionBuilder,
    ptr: dsl.Value,
    num_elements: int,
    element_type: dsl.Type,
    element_bytes: int,
) -> dsl.Value:
    range_bytes = bld.constant(dsl.i32(), num_elements * element_bytes)
    return bld.make_buffer(ptr, range_bytes, dsl.buffer_ptr_type(element_type))


def _output_element_type(cfg: _MatmulConfig) -> dsl.Type:
    return dsl.f16() if cfg.output_type == "f16" else dsl.f32()


def _emit_cta_coords(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
) -> tuple[dsl.Value, dsl.Value]:
    wg_m_raw = bld.assume_range(bld.workgroup_id(axis=0), 0, cfg.M_blocks - 1)
    wg_n_raw = bld.assume_range(bld.workgroup_id(axis=1), 0, cfg.N_blocks - 1)
    if cfg.cta_swizzle_xcds == 1 and cfg.cta_group_m == 1:
        return wg_m_raw, wg_n_raw

    raw_m = dsl.sym("wg_m_raw")
    raw_n = dsl.sym("wg_n_raw")
    raw_pid = raw_n * cfg.M_blocks + raw_m
    pid = raw_pid
    if cfg.cta_swizzle_xcds > 1:
        pids_per_xcd = (cfg.M_blocks * cfg.N_blocks) // cfg.cta_swizzle_xcds
        pid = dsl.mod(raw_pid, cfg.cta_swizzle_xcds) * pids_per_xcd + dsl.floor(
            raw_pid / cfg.cta_swizzle_xcds
        )

    group_span = cfg.cta_group_m * cfg.N_blocks
    pid_in_group = dsl.mod(pid, group_span)
    wg_m = dsl.floor(pid / group_span) * cfg.cta_group_m + dsl.mod(
        pid_in_group, cfg.cta_group_m
    )
    wg_n = dsl.floor(pid_in_group / cfg.cta_group_m)
    bindings = {raw_m: wg_m_raw, raw_n: wg_n_raw}
    wg_m_val = bld.index_expr(wg_m, bindings=bindings)
    wg_n_val = bld.index_expr(wg_n, bindings=bindings)
    return (
        bld.assume_range(wg_m_val, 0, cfg.M_blocks - 1),
        bld.assume_range(wg_n_val, 0, cfg.N_blocks - 1),
    )


def _emit_tile_coords(bld: dsl.FunctionBuilder, cfg: _MatmulConfig) -> _TileCoords:
    """Compute per-wave A/B/C pointer coordinates."""
    a_arg, b_arg, c_arg = bld.args[0], bld.args[1], bld.args[2]
    a_scale_arg = bld.args[3] if cfg.uses_packed_mxfp4 else None
    b_scale_arg = bld.args[4] if cfg.uses_packed_mxfp4 else None
    if cfg.use_buffer:
        a_arg = _wrap_in_buffer(
            bld,
            a_arg,
            cfg.a_elements,
            cfg.input_element_type,
            cfg.input_element_bytes,
        )
        b_arg = _wrap_in_buffer(
            bld,
            b_arg,
            cfg.b_elements,
            cfg.input_element_type,
            cfg.input_element_bytes,
        )

    wi_val = bld.assume_range(
        bld.workitem_id(axis=0, width=cfg.mma.wave_size),
        0,
        cfg.threads_per_workgroup - 1,
    )
    wg_m_val, wg_n_val = _emit_cta_coords(bld, cfg)

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
    lane_k_off = dsl.floor(lane / 16) * cfg.storage_lane_k_elems
    sym_to_val = {wi: wi_val, wg_m: wg_m_val, wg_n: wg_n_val}

    stride_per_tile = 16 * cfg.storage_K
    a_tile_off = bld.index_expr(
        wg_m * (cfg.BM * cfg.wave_m_tiles * stride_per_tile)
        + m_wave * (cfg.wave_m_tiles * stride_per_tile),
        bindings=sym_to_val,
    )
    a_tile_base = bld.ptr_add(a_arg, a_tile_off)
    a_off = bld.index_expr(lane_mod16 * cfg.storage_K + lane_k_off, bindings=sym_to_val)
    a_lane_base = bld.ptr_add(a_tile_base, a_off)

    b_tile_off = bld.index_expr(
        wg_n * (cfg.BN * cfg.wave_n_tiles * stride_per_tile)
        + n_wave * (cfg.wave_n_tiles * stride_per_tile),
        bindings=sym_to_val,
    )
    b_tile_base = bld.ptr_add(b_arg, b_tile_off)
    b_off = bld.index_expr(lane_mod16 * cfg.storage_K + lane_k_off, bindings=sym_to_val)
    b_lane_base = bld.ptr_add(b_tile_base, b_off)

    c_cta_off = bld.index_expr(
        wg_m * (cfg.N_blocks * cfg.waves_per_workgroup * cfg.tiles_per_wave * 256)
        + wg_n * (cfg.waves_per_workgroup * cfg.tiles_per_wave * 256),
        bindings=sym_to_val,
    )
    c_base = bld.ptr_add(c_arg, c_cta_off)
    if cfg.use_buffer:
        c_base = _wrap_in_buffer(
            bld,
            c_base,
            cfg.waves_per_workgroup * cfg.tiles_per_wave * 256,
            _output_element_type(cfg),
            cfg.c_element_bytes,
        )
    c_wave_off = bld.index_expr(
        wave_id * (cfg.tiles_per_wave * 256),
        bindings=sym_to_val,
    )
    c_ptr = bld.ptr_add(c_base, c_wave_off)

    return _TileCoords(
        wi=wi_val,
        wg_m=wg_m_val,
        wg_n=wg_n_val,
        a_base=a_arg,
        b_base=b_arg,
        a_tile_base=a_tile_base,
        b_tile_base=b_tile_base,
        a_lane_base=a_lane_base,
        b_lane_base=b_lane_base,
        a_scale_base=a_scale_arg,
        b_scale_base=b_scale_arg,
        c_ptr=c_ptr,
    )


@dataclass(frozen=True)
class _LdsStaging:
    """LDS slots for the matmul fragment round-trip."""

    reg_simd_type: dsl.Type
    a_lds_ptrs: tuple[dsl.Value, ...]
    b_lds_ptrs: tuple[dsl.Value, ...]
    a_dma_lds_ptrs: tuple[dsl.Value, ...]
    b_dma_lds_ptrs: tuple[dsl.Value, ...]
    a_dma_read_ptrs: tuple[dsl.Value, ...]
    b_dma_read_ptrs: tuple[dsl.Value, ...]
    a_dma_src_ptrs: tuple[dsl.Value, ...] = ()
    b_dma_src_ptrs: tuple[dsl.Value, ...] = ()


@dataclass(frozen=True)
class _DmaCtaGeometry:
    block_m_tiles: int
    block_n_tiles: int
    a_total_slots: int
    b_total_slots: int
    a_slots_per_wave: int
    b_slots_per_wave: int
    dwords_per_slot: int
    b_lds_base: int


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


def _dma_cta_geometry(cfg: _MatmulConfig) -> _DmaCtaGeometry:
    block_m_tiles = cfg.BM * cfg.wave_m_tiles
    block_n_tiles = cfg.BN * cfg.wave_n_tiles
    a_total_slots = cfg.wave_k_tiles * block_m_tiles
    b_total_slots = cfg.wave_k_tiles * block_n_tiles
    dwords = cfg.mma.lds_dwords_per_frag
    return _DmaCtaGeometry(
        block_m_tiles=block_m_tiles,
        block_n_tiles=block_n_tiles,
        a_total_slots=a_total_slots,
        b_total_slots=b_total_slots,
        a_slots_per_wave=a_total_slots // cfg.waves_per_workgroup,
        b_slots_per_wave=b_total_slots // cfg.waves_per_workgroup,
        dwords_per_slot=dwords,
        b_lds_base=a_total_slots * dwords,
    )


def _dma_cta_buffer_dwords(cfg: _MatmulConfig) -> int:
    geom = _dma_cta_geometry(cfg)
    return (geom.a_total_slots + geom.b_total_slots) * geom.dwords_per_slot


def _dma_slot_expr(
    cfg: _MatmulConfig, slot_per_wave: int, wave: int | dsl.Expr
) -> int | dsl.Expr:
    return slot_per_wave * cfg.waves_per_workgroup + wave


def _dma_slot_major_minor(
    slot: int | dsl.Expr, rows: int
) -> tuple[int | dsl.Expr, int | dsl.Expr]:
    major = dsl.floor(slot / rows)
    minor = slot - major * rows
    return major, minor


def _emit_dma_cta_staging_ptrs(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    coords: _TileCoords,
    lds: dsl.Value,
) -> tuple[
    tuple[dsl.Value, ...],
    tuple[dsl.Value, ...],
    tuple[dsl.Value, ...],
    tuple[dsl.Value, ...],
    tuple[dsl.Value, ...],
    tuple[dsl.Value, ...],
]:
    wi = dsl.sym("wi")
    wi_first = dsl.sym("wi_first")
    wg_m = dsl.sym("wg_m")
    wg_n = dsl.sym("wg_n")
    first_bindings = {wi_first: bld.read_first(coords.wi)}
    bindings = {wi: coords.wi, wg_m: coords.wg_m, wg_n: coords.wg_n}
    wave_id = dsl.floor(wi / cfg.mma.wave_size)
    wave_id_uniform = dsl.floor(wi_first / cfg.mma.wave_size)
    lane = dsl.mod(wi, cfg.mma.wave_size)
    lane_mod16 = dsl.mod(wi, 16)
    lane_k_group = dsl.floor(lane / 16)
    chunks_per_row = cfg.mma.k_tile // cfg.mma.lane_k_elems
    src_row = dsl.floor(lane / chunks_per_row)
    src_k_group = dsl.mod(lane, chunks_per_row)
    src_k_group = _dma_logical_col(cfg, src_row, src_k_group)
    read_k_group = _dma_logical_col(cfg, lane_mod16, lane_k_group)
    geom = _dma_cta_geometry(cfg)

    def dma_lds_ptr(slot_per_wave: int, base: int) -> dsl.Value:
        slot_off = bld.index_expr(
            base
            + _dma_slot_expr(cfg, slot_per_wave, wave_id_uniform)
            * geom.dwords_per_slot,
            bindings=first_bindings,
        )
        return bld.ptr_add(lds, slot_off)

    def a_dma_src_ptr(slot_per_wave: int) -> dsl.Value:
        slot = _dma_slot_expr(cfg, slot_per_wave, wave_id)
        k_tile, m_tile = _dma_slot_major_minor(slot, geom.block_m_tiles)
        off = bld.index_expr(
            wg_m * (geom.block_m_tiles * 16 * cfg.storage_K)
            + m_tile * (16 * cfg.storage_K)
            + k_tile * cfg.storage_k_tile
            + src_row * cfg.storage_K
            + src_k_group * cfg.storage_lane_k_elems,
            bindings=bindings,
        )
        return bld.ptr_add(coords.a_base, off)

    def b_dma_src_ptr(slot_per_wave: int) -> dsl.Value:
        slot = _dma_slot_expr(cfg, slot_per_wave, wave_id)
        k_tile, n_tile = _dma_slot_major_minor(slot, geom.block_n_tiles)
        off = bld.index_expr(
            wg_n * (geom.block_n_tiles * 16 * cfg.storage_K)
            + n_tile * (16 * cfg.storage_K)
            + k_tile * cfg.storage_k_tile
            + src_row * cfg.storage_K
            + src_k_group * cfg.storage_lane_k_elems,
            bindings=bindings,
        )
        return bld.ptr_add(coords.b_base, off)

    def dma_read_ptr(slot: int | dsl.Expr, base: int) -> dsl.Value:
        slot_off = bld.index_expr(
            base
            + slot * geom.dwords_per_slot
            + lane_mod16 * cfg.storage_k_tile_dwords
            + read_k_group * cfg.storage_lane_k_dwords,
            bindings=bindings,
        )
        return bld.ptr_add(lds, slot_off)

    m_wave = dsl.floor(wave_id / cfg.BN)
    n_wave = dsl.mod(wave_id, cfg.BN)
    a_read_slots = tuple(
        k * geom.block_m_tiles + m_wave * cfg.wave_m_tiles + i
        for k in range(cfg.wave_k_tiles)
        for i in range(cfg.wave_m_tiles)
    )
    b_read_slots = tuple(
        k * geom.block_n_tiles + n_wave * cfg.wave_n_tiles + j
        for k in range(cfg.wave_k_tiles)
        for j in range(cfg.wave_n_tiles)
    )

    return (
        tuple(a_dma_src_ptr(i) for i in range(geom.a_slots_per_wave)),
        tuple(b_dma_src_ptr(i) for i in range(geom.b_slots_per_wave)),
        tuple(dma_lds_ptr(i, 0) for i in range(geom.a_slots_per_wave)),
        tuple(dma_lds_ptr(i, geom.b_lds_base) for i in range(geom.b_slots_per_wave)),
        tuple(dma_read_ptr(slot, 0) for slot in a_read_slots),
        tuple(dma_read_ptr(slot, geom.b_lds_base) for slot in b_read_slots),
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
    a_slots = _fragment_slot_indices(cfg, 0, cfg.wave_m_tiles)
    b_slots = _fragment_slot_indices(cfg, cfg.wave_m_tiles, cfg.wave_n_tiles)

    def slot_ptr(slot: int) -> dsl.Value:
        slots_per_wave = cfg.wave_k_tiles * (cfg.wave_m_tiles + cfg.wave_n_tiles)
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

    (
        a_dma_src_ptrs,
        b_dma_src_ptrs,
        a_dma_lds_ptrs,
        b_dma_lds_ptrs,
        a_dma_read_ptrs,
        b_dma_read_ptrs,
    ) = _emit_dma_cta_staging_ptrs(
        bld,
        cfg,
        coords,
        lds,
    )
    return _LdsStaging(
        reg_simd_type=reg_simd_type,
        a_lds_ptrs=a_lds_ptrs,
        b_lds_ptrs=b_lds_ptrs,
        a_dma_lds_ptrs=a_dma_lds_ptrs,
        b_dma_lds_ptrs=b_dma_lds_ptrs,
        a_dma_read_ptrs=a_dma_read_ptrs,
        b_dma_read_ptrs=b_dma_read_ptrs,
        a_dma_src_ptrs=a_dma_src_ptrs,
        b_dma_src_ptrs=b_dma_src_ptrs,
    )


def _load_fragment_group_through_lds(
    bld: dsl.FunctionBuilder,
    a_ptrs: tuple[dsl.Value, ...],
    b_ptrs: tuple[dsl.Value, ...],
    a_type: dsl.Type,
    b_type: dsl.Type,
    staging: _LdsStaging,
) -> tuple[tuple[dsl.Value, ...], tuple[dsl.Value, ...], dsl.Value]:
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
) -> tuple[tuple[dsl.Value, ...], tuple[dsl.Value, ...], dsl.Value]:
    store_tokens: list[dsl.Value] = []
    for (regs, glob_tok), lds_ptr in zip(a_loads, staging.a_lds_ptrs, strict=True):
        store_tokens.append(bld.store(regs, lds_ptr, after=glob_tok))
    for (regs, glob_tok), lds_ptr in zip(b_loads, staging.b_lds_ptrs, strict=True):
        store_tokens.append(bld.store(regs, lds_ptr, after=glob_tok))

    barrier_tok = bld.barrier(*store_tokens)
    a_frags: list[dsl.Value] = []
    b_frags: list[dsl.Value] = []
    load_tokens: list[dsl.Value] = []
    for lds_ptr in staging.a_lds_ptrs:
        regs, tok = bld.load(lds_ptr, staging.reg_simd_type, after=barrier_tok)
        load_tokens.append(tok)
        a_frags.append(bld.fragment_pack(regs, a_type))
    for lds_ptr in staging.b_lds_ptrs:
        regs, tok = bld.load(lds_ptr, staging.reg_simd_type, after=barrier_tok)
        load_tokens.append(tok)
        b_frags.append(bld.fragment_pack(regs, b_type))
    return tuple(a_frags), tuple(b_frags), _join_tokens(bld, load_tokens)


def _load_fragment_group_through_dma_lds(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    a_ptrs: tuple[dsl.Value, ...],
    b_ptrs: tuple[dsl.Value, ...],
    a_type: dsl.Type,
    b_type: dsl.Type,
    staging: _LdsStaging,
) -> tuple[tuple[dsl.Value, ...], tuple[dsl.Value, ...], dsl.Value]:
    dma_tokens = _dma_issue(bld, a_ptrs, b_ptrs, staging)
    a_frags, b_frags, reuse_token = _dma_drain(
        bld, _join_tokens(bld, dma_tokens), a_type, b_type, staging
    )
    return a_frags, b_frags, reuse_token


def _join_tokens(bld: dsl.FunctionBuilder, tokens: list[dsl.Value]) -> dsl.Value:
    if not tokens:
        return bld.token()
    if len(tokens) == 1:
        return tokens[0]
    return bld.join(*tokens)


def _dma_issue(
    bld: dsl.FunctionBuilder,
    a_ptrs: tuple[dsl.Value, ...],
    b_ptrs: tuple[dsl.Value, ...],
    staging: _LdsStaging,
    *,
    after: dsl.Value | None = None,
    lds_offset: int | dsl.Value = 0,
) -> list[dsl.Value]:
    dep = after if after is not None else bld.token()
    dma_tokens: list[dsl.Value] = []
    a_lds_ptrs = _offset_ptrs(bld, staging.a_dma_lds_ptrs, lds_offset)
    b_lds_ptrs = _offset_ptrs(bld, staging.b_dma_lds_ptrs, lds_offset)
    for ptr, lds_ptr in zip(a_ptrs, a_lds_ptrs, strict=True):
        tok = bld.dma_load_lds(ptr, lds_ptr, after=dep, bytes=16)
        dma_tokens.append(tok)
    for ptr, lds_ptr in zip(b_ptrs, b_lds_ptrs, strict=True):
        tok = bld.dma_load_lds(ptr, lds_ptr, after=dep, bytes=16)
        dma_tokens.append(tok)
    return dma_tokens


def _dma_drain(
    bld: dsl.FunctionBuilder,
    dma_token: dsl.Value,
    a_type: dsl.Type,
    b_type: dsl.Type,
    staging: _LdsStaging,
    *,
    lds_offset: int | dsl.Value = 0,
) -> tuple[tuple[dsl.Value, ...], tuple[dsl.Value, ...], dsl.Value]:
    barrier_tok = bld.barrier(dma_token)
    a_frags: list[dsl.Value] = []
    b_frags: list[dsl.Value] = []
    load_tokens: list[dsl.Value] = []
    a_read_ptrs = _offset_ptrs(bld, staging.a_dma_read_ptrs, lds_offset)
    b_read_ptrs = _offset_ptrs(bld, staging.b_dma_read_ptrs, lds_offset)
    for lds_ptr in a_read_ptrs:
        regs, tok = bld.load(lds_ptr, staging.reg_simd_type, after=barrier_tok)
        load_tokens.append(tok)
        a_frags.append(bld.fragment_pack(regs, a_type))
    for lds_ptr in b_read_ptrs:
        regs, tok = bld.load(lds_ptr, staging.reg_simd_type, after=barrier_tok)
        load_tokens.append(tok)
        b_frags.append(bld.fragment_pack(regs, b_type))
    return tuple(a_frags), tuple(b_frags), _join_tokens(bld, load_tokens)


def _load_fragment_group(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    a_ptrs: tuple[dsl.Value, ...],
    b_ptrs: tuple[dsl.Value, ...],
    types: _KernelTypes,
    staging: _LdsStaging,
) -> tuple[tuple[dsl.Value, ...], tuple[dsl.Value, ...], dsl.Value]:
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
        _ptr_add_const(bld, base, i * 16 * cfg.storage_K + k * cfg.storage_k_tile)
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
    dma_token: dsl.Value | None = None
    reuse_token: dsl.Value | None = None


def _kernel_types(cfg: _MatmulConfig) -> _KernelTypes:
    return _KernelTypes(
        a=dsl.fragment_type(
            0,
            cfg.input_element_type,
            16,
            16,
            cfg.mma.wave_size,
            cfg.mma.ab_registers,
        ),
        b=dsl.fragment_type(
            1,
            cfg.input_element_type,
            16,
            16,
            cfg.mma.wave_size,
            cfg.mma.ab_registers,
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
    c = tuple(
        _ptr_add_const(bld, coords.c_ptr, i * 256) for i in range(cfg.tiles_per_wave)
    )
    return _TilePtrs(a0=a0, b0=b0, a_dma0=(), b_dma0=(), c=c)


def _advance_ptrs(
    bld: dsl.FunctionBuilder, ptrs: tuple[dsl.Value, ...], offset: dsl.Value
) -> tuple[dsl.Value, ...]:
    return tuple(bld.ptr_add(ptr, offset) for ptr in ptrs)


def _offset_ptrs(
    bld: dsl.FunctionBuilder, ptrs: tuple[dsl.Value, ...], offset: int | dsl.Value
) -> tuple[dsl.Value, ...]:
    if isinstance(offset, int) and offset == 0:
        return ptrs
    offset_value = (
        bld.constant(dsl.i32(), offset) if isinstance(offset, int) else offset
    )
    return tuple(bld.ptr_add(ptr, offset_value) for ptr in ptrs)


def _dma_buffer_offset(
    bld: dsl.FunctionBuilder, cfg: _MatmulConfig, step: dsl.Value | int
) -> dsl.Value | int:
    buffer_dwords = _dma_cta_buffer_dwords(cfg)
    if isinstance(step, int):
        return (step & 1) * buffer_dwords
    i = dsl.sym("i")
    return bld.index_expr(dsl.mod(i, 2) * buffer_dwords, bindings={i: step})


def _load_ptrs_for_step(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    staging: _LdsStaging,
    ptrs: _TilePtrs,
    loop_iv: dsl.Value,
    virtual_k_stride: dsl.Value,
    *,
    step_base: int = 1,
) -> tuple[tuple[dsl.Value, ...], tuple[dsl.Value, ...]]:
    a0 = staging.a_dma_src_ptrs if cfg.use_dma_lds else ptrs.a0
    b0 = staging.b_dma_src_ptrs if cfg.use_dma_lds else ptrs.b0
    max_step = max(cfg.virtual_k_steps - 1, step_base)
    step = bld.addi(loop_iv, bld.constant(dsl.i32(), step_base))
    step = bld.assume_range(step, step_base, max_step)
    offset = bld.muli(step, virtual_k_stride)
    offset = bld.assume_range(
        offset,
        cfg.storage_k_tile * cfg.wave_k_tiles,
        cfg.storage_k_tile * cfg.wave_k_tiles * max_step,
    )
    return _advance_ptrs(bld, a0, offset), _advance_ptrs(bld, b0, offset)


@dataclass(frozen=True)
class _Mxfp4ScaleLayout:
    bindings: dict[dsl.Expr, dsl.Value]
    wg_m: dsl.Expr
    wg_n: dsl.Expr
    m_wave: dsl.Expr
    n_wave: dsl.Expr
    lane: dsl.Expr
    lane_mod16: dsl.Expr
    lane_scale_group: dsl.Expr
    scale_k: int | dsl.Expr


def _mxfp4_scale_layout(
    cfg: _MatmulConfig, coords: _TileCoords, step: dsl.Value | int
) -> _Mxfp4ScaleLayout:
    if coords.a_scale_base is None or coords.b_scale_base is None:
        raise ValueError("MXFP4 scale buffers are required")
    wi = dsl.sym("wi")
    wg_m = dsl.sym("wg_m")
    wg_n = dsl.sym("wg_n")
    bindings = {wi: coords.wi, wg_m: coords.wg_m, wg_n: coords.wg_n}
    step_expr: int | dsl.Expr
    if isinstance(step, int):
        step_expr = step
    else:
        step_sym = dsl.sym("step")
        bindings[step_sym] = step
        step_expr = step_sym
    wave_id = dsl.floor(wi / cfg.mma.wave_size)
    m_wave = dsl.floor(wave_id / cfg.BN)
    n_wave = dsl.mod(wave_id, cfg.BN)
    lane = dsl.mod(wi, cfg.mma.wave_size)
    lane_mod16 = dsl.mod(wi, 16)
    lane_scale_group = dsl.floor(lane / 16)
    scale_k = step_expr * (cfg.mma.k_tile // 32) + lane_scale_group
    return _Mxfp4ScaleLayout(
        bindings=bindings,
        wg_m=wg_m,
        wg_n=wg_n,
        m_wave=m_wave,
        n_wave=n_wave,
        lane=lane,
        lane_mod16=lane_mod16,
        lane_scale_group=lane_scale_group,
        scale_k=scale_k,
    )


def _scale_lds_base(
    bld: dsl.FunctionBuilder, cfg: _MatmulConfig, lds_offset: dsl.Value | int
) -> dsl.Value:
    lds_base_offset = 0 if cfg.use_dma_lds else cfg.data_lds_bytes
    lds = bld.lds_base(dsl.i8(), offset=lds_base_offset)
    if isinstance(lds_offset, int):
        if lds_offset == 0:
            return lds
        return _ptr_add_const(bld, lds, lds_offset * 4)
    offset = dsl.sym("scale_lds_offset")
    byte_offset = bld.index_expr(offset * 4, bindings={offset: lds_offset})
    return bld.ptr_add(lds, byte_offset)


def _stage_mxfp4_scale_tiles(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    coords: _TileCoords,
    step: dsl.Value | int,
    *,
    lds_offset: dsl.Value | int = 0,
    after: dsl.Value | None = None,
) -> tuple[_Mxfp4ScaleLayout, dsl.Value]:
    if coords.a_scale_base is None or coords.b_scale_base is None:
        raise ValueError("MXFP4 scale buffers are required")
    layout = _mxfp4_scale_layout(cfg, coords, step)
    load_type = dsl.simd_type(dsl.vector_type(4, dsl.i8()), width=cfg.mma.wave_size)
    store_type = dsl.simd_type(dsl.i8(), width=cfg.mma.wave_size)
    lds = _scale_lds_base(bld, cfg, lds_offset)
    dep = bld.barrier(after) if after is not None else None
    tokens: list[dsl.Value] = []

    def store_scale(
        global_base: dsl.Value, global_off: dsl.Value, tile: int | dsl.Expr
    ) -> None:
        raw, load_token = bld.load(bld.ptr_add(global_base, global_off), load_type)
        lds_off = bld.index_expr(
            tile * 512 + layout.lane_scale_group * 128 + layout.lane_mod16,
            bindings=layout.bindings,
        )
        low = wave.ExtractOp(store_type, raw, 0).result
        store_dep = load_token if dep is None else bld.join(dep, load_token)
        tokens.append(bld.store(low, bld.ptr_add(lds, lds_off), after=store_dep))

    for i in range(cfg.wave_m_tiles):
        scale_tile = layout.m_wave * cfg.wave_m_tiles + i
        m_tile = (
            layout.wg_m * (cfg.BM * cfg.wave_m_tiles)
            + layout.m_wave * cfg.wave_m_tiles
            + i
        )
        m = m_tile * 16 + layout.lane_mod16
        a_off = bld.index_expr(
            m * cfg.scale_groups + layout.scale_k, bindings=layout.bindings
        )
        store_scale(coords.a_scale_base, a_off, scale_tile)

    b_scale_base = cfg.BM * cfg.wave_m_tiles
    for j in range(cfg.wave_n_tiles):
        scale_tile = b_scale_base + layout.n_wave * cfg.wave_n_tiles + j
        n_tile = (
            layout.wg_n * (cfg.BN * cfg.wave_n_tiles)
            + layout.n_wave * cfg.wave_n_tiles
            + j
        )
        n = n_tile * 16 + layout.lane_mod16
        b_off = bld.index_expr(
            n * cfg.scale_groups + layout.scale_k, bindings=layout.bindings
        )
        store_scale(coords.b_scale_base, b_off, scale_tile)

    return layout, bld.barrier(*tokens)


def _read_mxfp4_scale_tile(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    layout: _Mxfp4ScaleLayout,
    tile: int | dsl.Expr,
    ready_token: dsl.Value,
    *,
    lds_offset: dsl.Value | int = 0,
) -> tuple[dsl.Value, dsl.Value]:
    lds = _scale_lds_base(bld, cfg, lds_offset)
    load_type = dsl.simd_type(dsl.vector_type(8, dsl.i8()), width=cfg.mma.wave_size)
    read_off = bld.index_expr(tile * 512 + layout.lane * 8, bindings=layout.bindings)
    value: dsl.Value
    token: dsl.Value
    value, token = bld.transpose_load(
        bld.ptr_add(lds, read_off), load_type, after=ready_token
    )
    return value, token


def _initial_loop_args(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    types: _KernelTypes,
    staging: _LdsStaging,
    coords: _TileCoords,
    ptrs: _TilePtrs,
    virtual_k_stride: dsl.Value,
) -> tuple[dsl.Value, ...]:
    init_acc = bld.fragment_fill(bld.constant(dsl.i32(), 0), types.acc)
    a0 = staging.a_dma_src_ptrs if cfg.use_dma_lds else ptrs.a0
    b0 = staging.b_dma_src_ptrs if cfg.use_dma_lds else ptrs.b0
    reuse_token: dsl.Value | None = None
    if cfg.use_dma_lds:
        dma_tokens = _dma_issue(bld, a0, b0, staging, lds_offset=0)
        ready_token: dsl.Value | None = None
        if cfg.virtual_k_steps > 1:
            a1 = _advance_ptrs(bld, a0, virtual_k_stride)
            b1 = _advance_ptrs(bld, b0, virtual_k_stride)
            ready_token = _join_tokens(
                bld,
                _dma_issue(
                    bld,
                    a1,
                    b1,
                    staging,
                    lds_offset=_dma_buffer_offset(bld, cfg, 1),
                ),
            )
        a_frags, b_frags, reuse_token = _dma_drain(
            bld,
            _join_tokens(bld, dma_tokens),
            types.a,
            types.b,
            staging,
            lds_offset=0,
        )
    else:
        ready_token = None
        a_frags, b_frags, reuse_token = _load_fragment_group(
            bld, cfg, a0, b0, types, staging
        )
    init_accs = tuple(init_acc for _ in range(cfg.tiles_per_wave))
    wave_k = bld.static_param("wave_k_tiles", IndexType.get())
    a_pt = _pack_frags_into_nested_parametric_ptuple(
        bld, a_frags, cfg.wave_m_tiles, cfg.wave_k_tiles, wave_k
    )
    b_pt = _pack_frags_into_nested_parametric_ptuple(
        bld, b_frags, cfg.wave_n_tiles, cfg.wave_k_tiles, wave_k
    )
    args = [
        *init_accs,
        a_pt,
        b_pt,
    ]
    if ready_token is not None:
        assert reuse_token is not None
        args.append(ready_token)
    if cfg.uses_packed_mxfp4 or (cfg.use_dma_lds and cfg.virtual_k_steps > 1):
        assert reuse_token is not None
        args.append(reuse_token)
    return tuple(args)


def _split_loop_state(values: tuple[dsl.Value, ...], cfg: _MatmulConfig) -> _LoopState:
    acc_end = cfg.tiles_per_wave
    cursor = acc_end + 2
    dma_token = None
    if cfg.use_dma_lds and cfg.virtual_k_steps > 1:
        dma_token = values[cursor]
        cursor += 1
    reuse_token = None
    if cfg.uses_packed_mxfp4 or (cfg.use_dma_lds and cfg.virtual_k_steps > 1):
        reuse_token = values[cursor]
    return _LoopState(
        accs=values[:acc_end],
        afs=(values[acc_end],),
        bfs=(values[acc_end + 1],),
        dma_token=dma_token,
        reuse_token=reuse_token,
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


def _emit_mxfp4_mma_grid(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    coords: _TileCoords,
    afs: tuple[dsl.Value, ...],
    bfs: tuple[dsl.Value, ...],
    accs: tuple[dsl.Value, ...],
    scale_step: dsl.Value | int,
    scale_lds_offset: dsl.Value | int,
    scale_after: dsl.Value | None,
    scale_tokens: list[dsl.Value] | None,
) -> tuple[dsl.Value, ...]:
    layout, scale_token = _stage_mxfp4_scale_tiles(
        bld, cfg, coords, scale_step, lds_offset=scale_lds_offset, after=scale_after
    )
    index = IndexType.get()
    c0 = bld.constant(index, 0)
    a_outer_type = PTupleType(afs[0].type)
    b_outer_type = PTupleType(bfs[0].type)
    a_row_type = a_outer_type.element_type
    b_row_type = b_outer_type.element_type
    af_type = PTupleType(a_row_type).element_type
    bf_type = PTupleType(b_row_type).element_type
    a_row = wavemeta.TupleGetOp(a_row_type, afs[0], c0).result
    b_row = wavemeta.TupleGetOp(b_row_type, bfs[0], c0).result

    read_tokens: list[dsl.Value] = []
    a_scales: list[dsl.Value] = []
    for i in range(cfg.wave_m_tiles):
        a_tile = layout.m_wave * cfg.wave_m_tiles + i
        scale, token = _read_mxfp4_scale_tile(
            bld, cfg, layout, a_tile, scale_token, lds_offset=scale_lds_offset
        )
        a_scales.append(scale)
        read_tokens.append(token)

    b_scales: list[dsl.Value] = []
    b_scale_base = cfg.BM * cfg.wave_m_tiles
    for j in range(cfg.wave_n_tiles):
        b_tile = b_scale_base + layout.n_wave * cfg.wave_n_tiles + j
        scale, token = _read_mxfp4_scale_tile(
            bld, cfg, layout, b_tile, scale_token, lds_offset=scale_lds_offset
        )
        b_scales.append(scale)
        read_tokens.append(token)
    if scale_tokens is not None:
        scale_tokens.append(_join_tokens(bld, read_tokens))

    new_accs = list(accs)
    for i in range(cfg.wave_m_tiles):
        i_c = bld.constant(index, i)
        af = wavemeta.TupleGetOp(af_type, a_row, i_c).result
        for j in range(cfg.wave_n_tiles):
            j_c = bld.constant(index, j)
            bf = wavemeta.TupleGetOp(bf_type, b_row, j_c).result
            acc_idx = i * cfg.wave_n_tiles + j
            new_accs[acc_idx] = bld.mma_scale(
                cfg.mma.kind, af, a_scales[i], bf, b_scales[j], new_accs[acc_idx]
            )
    return tuple(new_accs)


def _emit_mma_grid(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    afs: tuple[dsl.Value, ...],
    bfs: tuple[dsl.Value, ...],
    accs: tuple[dsl.Value, ...],
    *,
    coords: _TileCoords | None = None,
    scale_step: dsl.Value | int | None = None,
    scale_lds_offset: dsl.Value | int = 0,
    scale_after: dsl.Value | None = None,
    scale_tokens: list[dsl.Value] | None = None,
) -> tuple[dsl.Value, ...]:
    """Triply-nested `wavemeta.static_for` over (k, i, j); the
    specialiser unrolls all three once the tile-factor params bind.
    Accumulator state rides through as a `!wavemeta.ptuple` so the
    inner body can address it by `i * wave_n + j`.
    """
    if not accs:
        return ()
    if cfg.uses_packed_mxfp4:
        if coords is None or scale_step is None:
            raise ValueError("MXFP4 scaled MFMA requires scale coordinates")
        return _emit_mxfp4_mma_grid(
            bld,
            cfg,
            coords,
            afs,
            bfs,
            accs,
            scale_step,
            scale_lds_offset,
            scale_after,
            scale_tokens,
        )

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
    coords: _TileCoords,
    state: _LoopState,
    a_ptrs: tuple[dsl.Value, ...],
    b_ptrs: tuple[dsl.Value, ...],
    scale_step: dsl.Value | int,
    current_lds_offset: int | dsl.Value = 0,
    ready_lds_offset: int | dsl.Value = 0,
    next_lds_offset: int | dsl.Value = 0,
) -> list[dsl.Value]:
    scale_tokens: list[dsl.Value] = []
    if cfg.use_dma_lds:
        if state.dma_token is None or state.reuse_token is None:
            raise ValueError("DMA pipeline step requires ready and reuse tokens")
        new_accs = _emit_mma_grid(
            bld,
            cfg,
            state.afs,
            state.bfs,
            state.accs,
            coords=coords,
            scale_step=scale_step,
            scale_lds_offset=current_lds_offset,
            scale_after=state.reuse_token,
            scale_tokens=scale_tokens,
        )
        dma_after = (
            _join_tokens(bld, [state.reuse_token, *scale_tokens])
            if cfg.uses_packed_mxfp4
            else state.reuse_token
        )
        next_token = _join_tokens(
            bld,
            _dma_issue(
                bld,
                a_ptrs,
                b_ptrs,
                staging,
                after=dma_after,
                lds_offset=next_lds_offset,
            ),
        )
        new_afs, new_bfs, reuse_token = _dma_drain(
            bld,
            state.dma_token,
            types.a,
            types.b,
            staging,
            lds_offset=ready_lds_offset,
        )
    else:
        next_token = None
        reuse_token = None
        a_loads, b_loads = _lds_global_loads(bld, a_ptrs, b_ptrs, staging)
        new_accs = _emit_mma_grid(
            bld,
            cfg,
            state.afs,
            state.bfs,
            state.accs,
            coords=coords,
            scale_step=scale_step,
            scale_lds_offset=current_lds_offset,
            scale_after=state.reuse_token,
            scale_tokens=scale_tokens,
        )
        new_afs, new_bfs, reload_token = _lds_store_reload(
            bld, a_loads, b_loads, types.a, types.b, staging
        )
        if cfg.uses_packed_mxfp4:
            reuse_token = _join_tokens(bld, [reload_token, *scale_tokens])
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
        *(() if next_token is None else (next_token,)),
        *(() if reuse_token is None else (reuse_token,)),
    ]


def _emit_dma_tail_step(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    types: _KernelTypes,
    staging: _LdsStaging,
    coords: _TileCoords,
    state: _LoopState,
) -> _LoopState:
    if state.dma_token is None:
        raise ValueError("DMA tail step requires a ready token")
    scale_tokens: list[dsl.Value] = []
    current_step = cfg.virtual_k_steps - 2
    new_accs = _emit_mma_grid(
        bld,
        cfg,
        state.afs,
        state.bfs,
        state.accs,
        coords=coords,
        scale_step=current_step,
        scale_lds_offset=_dma_buffer_offset(bld, cfg, current_step),
        scale_after=state.reuse_token,
        scale_tokens=scale_tokens,
    )
    tail_step = cfg.virtual_k_steps - 1
    new_afs, new_bfs, reuse_token = _dma_drain(
        bld,
        state.dma_token,
        types.a,
        types.b,
        staging,
        lds_offset=_dma_buffer_offset(bld, cfg, tail_step),
    )
    wave_k = bld.static_param("wave_k_tiles", IndexType.get())
    a_pt = _pack_frags_into_nested_parametric_ptuple(
        bld, new_afs, cfg.wave_m_tiles, cfg.wave_k_tiles, wave_k
    )
    b_pt = _pack_frags_into_nested_parametric_ptuple(
        bld, new_bfs, cfg.wave_n_tiles, cfg.wave_k_tiles, wave_k
    )
    return _LoopState(
        accs=tuple(new_accs),
        afs=(a_pt,),
        bfs=(b_pt,),
        reuse_token=_join_tokens(bld, [reuse_token, *scale_tokens]),
    )


def _store_final_tiles(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    state: _LoopState,
    coords: _TileCoords,
    c_ptrs: tuple[dsl.Value, ...],
    scale_step: dsl.Value | int,
    scale_lds_offset: dsl.Value | int = 0,
) -> None:
    scale_tokens: list[dsl.Value] = []
    final_accs = _emit_mma_grid(
        bld,
        cfg,
        state.afs,
        state.bfs,
        state.accs,
        coords=coords,
        scale_step=scale_step,
        scale_lds_offset=scale_lds_offset,
        scale_after=state.reuse_token,
        scale_tokens=scale_tokens,
    )
    if scale_tokens:
        bld.wait(scale_tokens[-1])
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
    values: tuple[int | float, ...],
    element_type: dsl.Type,
    index_type: dsl.Type,
) -> None:
    for i, value in enumerate(values):
        bld.memref_store(
            bld.constant(element_type, value),
            buf,
            [bld.constant(index_type, i)],
        )


def _emit_input_ptr(
    bld: dsl.FunctionBuilder, buf: dsl.Value, cfg: _MatmulConfig
) -> dsl.Value:
    input_type = cfg.input_element_type
    if cfg.input_type == "mxfp4":
        input_helper = _I8_PTR_HELPER
    else:
        input_helper = _BF16_PTR_HELPER if cfg.input_type == "bf16" else _F16_PTR_HELPER
    [ptr] = bld.call(
        input_helper,
        [bld.memref_cast(buf, dsl.dynamic_1d_memref_type(input_type))],
        [dsl.ptr_type(input_type)],
    )
    return ptr


def _emit_i8_ptr(bld: dsl.FunctionBuilder, buf: dsl.Value) -> dsl.Value:
    [ptr] = bld.call(
        _I8_PTR_HELPER,
        [bld.memref_cast(buf, dsl.dynamic_1d_memref_type(dsl.i8()))],
        [dsl.ptr_type(dsl.i8())],
    )
    return ptr


@dataclass(frozen=True)
class _HostBuffers:
    a: dsl.Value
    b: dsl.Value
    c: dsl.Value
    a_scale: dsl.Value | None = None
    b_scale: dsl.Value | None = None


def _host_input_constants(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    input_type: dsl.Type,
    c_type: dsl.Type,
) -> tuple[dsl.Value, dsl.Value, dsl.Value]:
    if cfg.uses_packed_mxfp4:
        return (
            bld.constant(input_type, 0x22),
            bld.constant(input_type, 0x44),
            bld.constant(c_type, 0.0),
        )
    return (
        bld.constant(input_type, 1.0),
        bld.constant(input_type, 2.0),
        bld.constant(c_type, 0.0),
    )


def _alloc_host_buffers(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    input_type: dsl.Type,
    c_type: dsl.Type,
) -> _HostBuffers:
    a_scale = (
        bld.alloc([cfg.a_scale_elements], dsl.i8()) if cfg.uses_packed_mxfp4 else None
    )
    b_scale = (
        bld.alloc([cfg.b_scale_elements], dsl.i8()) if cfg.uses_packed_mxfp4 else None
    )
    return _HostBuffers(
        a=bld.alloc([cfg.a_elements], input_type),
        b=bld.alloc([cfg.b_elements], input_type),
        c=bld.alloc([cfg.total_elements], c_type),
        a_scale=a_scale,
        b_scale=b_scale,
    )


def _fill_host_inputs(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    buffers: _HostBuffers,
    one_input: dsl.Value,
    two_input: dsl.Value,
    index: dsl.Type,
    c0: dsl.Value,
    c1: dsl.Value,
) -> None:
    if cfg.random_data:
        if cfg.uses_packed_mxfp4:
            a_packed, b_packed = generate_mxfp4_packed_matmul_inputs(
                cfg.M,
                cfg.N,
                cfg.K,
                random_seed=cfg.random_seed,
            )
            _emit_constant_fill(bld, buffers.a, a_packed, cfg.input_element_type, index)
            _emit_constant_fill(bld, buffers.b, b_packed, cfg.input_element_type, index)
            return
        a_values, b_values = generate_wmma_f16_matmul_inputs(
            cfg.M,
            cfg.N,
            cfg.K,
            input_type=cfg.input_type,
            random_data=True,
            random_seed=cfg.random_seed,
        )
        _emit_constant_fill(bld, buffers.a, a_values, cfg.input_element_type, index)
        _emit_constant_fill(bld, buffers.b, b_values, cfg.input_element_type, index)
        return

    a_half = bld.constant(index, cfg.a_elements // 2)
    a_total = bld.constant(index, cfg.a_elements)
    with bld.for_loop(c0, a_half, c1) as i:
        bld.memref_store(one_input, buffers.a, [i])
    with bld.for_loop(a_half, a_total, c1) as i:
        bld.memref_store(two_input, buffers.a, [i])

    b_half = bld.constant(index, cfg.b_elements // 2)
    b_total = bld.constant(index, cfg.b_elements)
    with bld.for_loop(c0, b_half, c1) as i:
        bld.memref_store(one_input, buffers.b, [i])
    with bld.for_loop(b_half, b_total, c1) as i:
        bld.memref_store(two_input, buffers.b, [i])


def _fill_mxfp4_scales(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    buffers: _HostBuffers,
    index: dsl.Type,
) -> None:
    if not cfg.uses_packed_mxfp4:
        return
    assert buffers.a_scale is not None and buffers.b_scale is not None
    a_scales, b_scales = generate_mxfp4_scale_inputs(cfg.M, cfg.N, cfg.K)
    _emit_constant_fill(bld, buffers.a_scale, a_scales, dsl.i8(), index)
    _emit_constant_fill(bld, buffers.b_scale, b_scales, dsl.i8(), index)


def _zero_host_output(
    bld: dsl.FunctionBuilder,
    buffers: _HostBuffers,
    c_total: dsl.Value,
    zero_c: dsl.Value,
    c0: dsl.Value,
    c1: dsl.Value,
) -> None:
    with bld.for_loop(c0, c_total, c1) as i:
        bld.memref_store(zero_c, buffers.c, [i])


def _host_register_buffers(
    bld: dsl.FunctionBuilder, cfg: _MatmulConfig, buffers: _HostBuffers
) -> dsl.Value:
    c_unranked = bld.cast_unranked(buffers.c)
    bld.host_register(bld.cast_unranked(buffers.a))
    bld.host_register(bld.cast_unranked(buffers.b))
    if cfg.uses_packed_mxfp4:
        assert buffers.a_scale is not None and buffers.b_scale is not None
        bld.host_register(bld.cast_unranked(buffers.a_scale))
        bld.host_register(bld.cast_unranked(buffers.b_scale))
    bld.host_register(c_unranked)
    return c_unranked


def _emit_output_ptr(
    bld: dsl.FunctionBuilder, cfg: _MatmulConfig, c_buf: dsl.Value
) -> dsl.Value:
    c_ptr_type = dsl.ptr_type(cfg.c_type)
    if cfg.output_type == "f16":
        dyn_f16 = dsl.dynamic_1d_memref_type(dsl.f16())
        [c_ptr] = bld.call(
            _F16_PTR_HELPER, [bld.memref_cast(c_buf, dyn_f16)], [c_ptr_type]
        )
        return c_ptr
    [c_ptr] = bld.call(_F32_PTR_HELPER, [c_buf], [c_ptr_type])
    return c_ptr


def _emit_matmul_launch(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    buffers: _HostBuffers,
    grid: tuple[dsl.Value, dsl.Value, dsl.Value],
    block: tuple[dsl.Value, dsl.Value, dsl.Value],
) -> None:
    a_ptr = _emit_input_ptr(bld, buffers.a, cfg)
    b_ptr = _emit_input_ptr(bld, buffers.b, cfg)
    c_ptr = _emit_output_ptr(bld, cfg, buffers.c)
    trip_count = bld.constant(dsl.i32(), max(cfg.virtual_k_steps - 1, 0))
    operands = [a_ptr, b_ptr, c_ptr, trip_count]
    if cfg.uses_packed_mxfp4:
        assert buffers.a_scale is not None and buffers.b_scale is not None
        operands = [
            a_ptr,
            b_ptr,
            c_ptr,
            _emit_i8_ptr(bld, buffers.a_scale),
            _emit_i8_ptr(bld, buffers.b_scale),
            trip_count,
        ]
    bld.launch(
        _GPU_MODULE_NAME,
        _KERNEL_NAME,
        grid=grid,
        block=block,
        operands=operands,
    )


def _kernel_trip_count_source(
    bld: dsl.FunctionBuilder, cfg: _MatmulConfig
) -> dsl.Value:
    if len(bld.args) > cfg.trip_count_arg_index:
        return bld.args[cfg.trip_count_arg_index]
    return bld.constant(dsl.i32(), max(cfg.virtual_k_steps - 1, 0))


def _emit_kernel(bld: dsl.FunctionBuilder, cfg: _MatmulConfig) -> None:
    """Populate tiled matmul kernel body."""
    coords = _emit_tile_coords(bld, cfg)
    types = _kernel_types(cfg)
    staging = _emit_lds_staging(bld, cfg, coords)
    virtual_k_stride = bld.constant(dsl.i32(), cfg.storage_k_tile * cfg.wave_k_tiles)
    ptrs = _initial_tile_ptrs(bld, cfg, coords)
    init_args = _initial_loop_args(
        bld, cfg, types, staging, coords, ptrs, virtual_k_stride
    )
    if cfg.use_dma_lds and cfg.virtual_k_steps == 1:
        _store_final_tiles(
            bld, cfg, _split_loop_state(tuple(init_args), cfg), coords, ptrs.c, 0
        )
        return

    trip_count_i32 = bld.assume_range(
        _kernel_trip_count_source(bld, cfg), 0, max(cfg.virtual_k_steps - 1, 0)
    )
    if cfg.use_dma_lds and cfg.virtual_k_steps > 1:
        trip_count_i32 = bld.constant(dsl.i32(), max(cfg.virtual_k_steps - 2, 0))
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
        a_ptrs, b_ptrs = _load_ptrs_for_step(
            bld,
            cfg,
            staging,
            ptrs,
            loop_iv,
            virtual_k_stride,
            step_base=2 if cfg.use_dma_lds else 1,
        )
        if cfg.use_dma_lds:
            current_lds_offset: int | dsl.Value = _dma_buffer_offset(bld, cfg, loop_iv)
            ready_lds_offset: int | dsl.Value = _dma_buffer_offset(
                bld, cfg, bld.addi(loop_iv, bld.constant(dsl.i32(), 1))
            )
            next_lds_offset: int | dsl.Value = _dma_buffer_offset(
                bld, cfg, bld.addi(loop_iv, bld.constant(dsl.i32(), 2))
            )
        else:
            current_lds_offset = 0
            ready_lds_offset = 0
            next_lds_offset = 0
        bld.yield_(
            _emit_pipelined_step(
                bld,
                cfg,
                types,
                staging,
                coords,
                state,
                a_ptrs,
                b_ptrs,
                loop_iv,
                current_lds_offset,
                ready_lds_offset,
                next_lds_offset,
            )
        )

    final_state = _split_loop_state(tuple(forop.results), cfg)
    final_scale_step = cfg.virtual_k_steps - 1
    final_scale_lds_offset: dsl.Value | int = 0
    if cfg.use_dma_lds and cfg.virtual_k_steps > 1:
        final_state = _emit_dma_tail_step(bld, cfg, types, staging, coords, final_state)
        final_scale_lds_offset = _dma_buffer_offset(bld, cfg, final_scale_step)
    _store_final_tiles(
        bld,
        cfg,
        final_state,
        coords,
        ptrs.c,
        final_scale_step,
        final_scale_lds_offset,
    )


def _emit_host(bld: dsl.FunctionBuilder, cfg: _MatmulConfig) -> None:
    """Populate host main."""
    index = dsl.index_type()
    input_type = cfg.input_element_type
    c_type = cfg.c_type

    c0 = bld.constant(index, 0)
    c1 = bld.constant(index, 1)
    blocks_m = bld.constant(index, cfg.M_blocks)
    blocks_n = bld.constant(index, cfg.N_blocks)
    threads = bld.constant(index, cfg.threads_per_workgroup)
    c_total = bld.constant(index, cfg.total_elements)

    one_input, two_input, zero_c = _host_input_constants(bld, cfg, input_type, c_type)
    buffers = _alloc_host_buffers(bld, cfg, input_type, c_type)
    _fill_host_inputs(bld, cfg, buffers, one_input, two_input, index, c0, c1)
    _fill_mxfp4_scales(bld, cfg, buffers, index)
    _zero_host_output(bld, buffers, c_total, zero_c, c0, c1)

    c_unranked = _host_register_buffers(bld, cfg, buffers)
    _emit_matmul_launch(
        bld,
        cfg,
        buffers,
        grid=(blocks_m, blocks_n, c1),
        block=(threads, c1, c1),
    )
    print_helper = _PRINT_F16_HELPER if cfg.output_type == "f16" else _PRINT_HELPER
    bld.call(print_helper, [c_unranked])


def _make_matmul_config(
    M: int,
    N: int,
    K: int,
    *,
    BM: int,
    BN: int,
    wave_m_tiles: int,
    wave_n_tiles: int,
    wave_k_tiles: int,
    use_buffer: bool,
    use_dma_lds: bool,
    matrix_intrinsic: str,
    input_type: str,
    output_type: str,
    random_data: bool,
    random_seed: int,
    cta_swizzle_xcds: int,
    cta_group_m: int,
) -> _MatmulConfig:
    return _MatmulConfig(
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
        input_type=input_type,
        output_type=output_type,
        random_data=random_data,
        random_seed=random_seed,
        cta_swizzle_xcds=cta_swizzle_xcds,
        cta_group_m=cta_group_m,
    )


def _declare_matmul_externals(bld: dsl.ModuleBuilder, cfg: _MatmulConfig) -> None:
    if cfg.input_type == "mxfp4":
        input_helper = _I8_PTR_HELPER
    else:
        input_helper = _BF16_PTR_HELPER if cfg.input_type == "bf16" else _F16_PTR_HELPER
    bld.declare_external(
        input_helper,
        [dsl.dynamic_1d_memref_type(cfg.input_element_type)],
        [dsl.ptr_type(cfg.input_element_type)],
    )
    if cfg.output_type == "f16":
        if cfg.input_type != "f16":
            bld.declare_external(
                _F16_PTR_HELPER,
                [dsl.dynamic_1d_memref_type(dsl.f16())],
                [dsl.ptr_type(dsl.f16())],
            )
        bld.declare_external(
            _PRINT_F16_HELPER,
            [dsl.unranked_memref_type(dsl.f16())],
            [],
        )
        return
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


def _kernel_input_types(
    cfg: _MatmulConfig, *, include_trip_count: bool = True
) -> list[dsl.Type]:
    args = [
        dsl.ptr_type(cfg.input_element_type),
        dsl.ptr_type(cfg.input_element_type),
        dsl.ptr_type(cfg.c_type),
    ]
    if cfg.uses_packed_mxfp4:
        args.extend([dsl.ptr_type(dsl.i8()), dsl.ptr_type(dsl.i8())])
    if include_trip_count:
        args.append(dsl.i32())
    return args


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
    input_type: str = "f16",
    output_type: str = "f32",
    random_data: bool = False,
    random_seed: int = 0,
    cta_swizzle_xcds: int = 1,
    cta_group_m: int = 1,
    skip_specialize: bool = False,
    target_waves: int | None = None,
) -> Module:
    """Return an MLIR module for the tiled matmul host + kernel."""
    cfg = _make_matmul_config(
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
        input_type=input_type,
        output_type=output_type,
        random_data=random_data,
        random_seed=random_seed,
        cta_swizzle_xcds=cta_swizzle_xcds,
        cta_group_m=cta_group_m,
    )
    bld = dsl.ModuleBuilder()
    with bld:
        _declare_matmul_externals(bld, cfg)
        with (
            bld.gpu_module(_GPU_MODULE_NAME) as gmod,
            gmod.kernel(
                _KERNEL_NAME,
                _kernel_input_types(cfg),
                lds_size=cfg.lds_bytes,
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
    "generate_mxfp4_packed_matmul_inputs",
    "generate_mxfp4_scale_inputs",
    "generate_wmma_f16_matmul_inputs",
]
