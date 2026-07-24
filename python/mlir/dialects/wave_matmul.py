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
    wave-id decomposition uses ``andi`` + ``shrui``).
  * ``wave_k_tiles`` divides ``K / 16``.
  * ``BM * BN <= 32`` (RDNA3 caps a workgroup at 32 waves of 32 lanes).
"""

from __future__ import annotations

import struct
from dataclasses import dataclass
from typing import Literal

from mlir._mlir_libs._waveDialectsNanobind import PTupleType
from mlir.dialects import scf, wave, waveamd, wavemeta
from mlir.dialects import wave_dsl as dsl
from mlir.ir import (
    Attribute,
    DictAttr,
    IndexType,
    IntegerAttr,
    IntegerType,
    Module,
    StringAttr,
    UnitAttr,
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


def _validate_phased_dma_fetch(alignment: int, phase: int) -> None:
    if alignment < 4 or alignment > 256 or alignment & (alignment - 1):
        raise ValueError(
            "phased DMA fetch alignment must be a power of two from 4 to 256"
        )
    if phase < 0 or phase >= alignment:
        raise ValueError("phased DMA fetch phase must be within its alignment")
    if phase % 4:
        raise ValueError("phased DMA fetch phase must be 4-byte aligned")


@dataclass(frozen=True)
class PhasedDmaSchedule:
    issue_group_size: int
    initial_delay_cycles: int
    loop_delay_cycles: int
    loop_overlap_cycles: int
    delayed_waves: int
    fetch_alignment: int
    fetch_phase: int
    subpanel_pipeline: bool = False

    def __post_init__(self) -> None:
        if self.issue_group_size < 1:
            raise ValueError("phased DMA issue group size must be positive")
        delays = (
            self.initial_delay_cycles,
            self.loop_delay_cycles,
            self.loop_overlap_cycles,
            self.delayed_waves,
        )
        if any(value < 0 for value in delays):
            raise ValueError("phased DMA schedule values must be non-negative")
        if self.loop_overlap_cycles > self.loop_delay_cycles:
            raise ValueError("phased DMA loop overlap cannot exceed its delay")
        _validate_phased_dma_fetch(self.fetch_alignment, self.fetch_phase)


_OUTPUT_STORE_CACHE_KINDS = {
    "wb": dsl.StoreCacheAttr.WB,
    "cg": dsl.StoreCacheAttr.CG,
    "cs": dsl.StoreCacheAttr.CS,
    "wt": dsl.StoreCacheAttr.WT,
}


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
    output_store_cache: str = "none"
    mxfp4_scale_path: str = "dma"
    random_data: bool = False
    random_seed: int = 0
    cta_swizzle_xcds: int = 1
    cta_group_m: int = 1
    target_waves: int | None = None
    enable_split_barriers: bool = False
    enable_multi_wave_specialization: bool = False
    phased_dma_schedule: PhasedDmaSchedule | None = None
    coalesced_mfma_output: bool = False

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
            if self.coalesced_mfma_output:
                return _dma_cta_buffer_dwords(self) * _dma_buffer_count(self) * 4
            one_buffer = (
                self.wave_k_tiles
                * (self.BM * self.wave_m_tiles + self.BN * self.wave_n_tiles)
                * self.mma.lds_dwords_per_frag
                * 4
            )
            return one_buffer * _dma_buffer_count(self)
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
        scale_tiles = self.BM * _mxfp4_scale_tiles_per_wave(
            self.wave_m_tiles
        ) + self.BN * _mxfp4_scale_tiles_per_wave(self.wave_n_tiles)
        if self.use_dma_lds:
            return 2 * self.wave_k_tiles * scale_tiles * 512
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
    _validate_choice(
        "output_store_cache",
        cfg.output_store_cache,
        ("none", *_OUTPUT_STORE_CACHE_KINDS),
    )
    _validate_choice("input_type", cfg.input_type, ("f16", "bf16", "mxfp4"))
    _validate_choice("mxfp4_scale_path", cfg.mxfp4_scale_path, ("dma", "regs"))


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
    _validate_coalesced_mfma_output(cfg)
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


def _validate_coalesced_mfma_output(cfg: _MatmulConfig) -> None:
    if not cfg.coalesced_mfma_output:
        return
    if cfg.mma.name != "mfma_gfx950" or cfg.input_type != "f16":
        raise ValueError("coalesced MFMA output requires gfx950 f16 MFMA")
    if cfg.output_type != "f16":
        raise ValueError("coalesced MFMA output requires f16 output")
    if (
        cfg.mma.wave_size != 64
        or cfg.mma.acc_registers != 4
        or cfg.wave_m_tiles != 8
        or cfg.wave_n_tiles != 8
        or cfg.BM != cfg.BN
    ):
        raise ValueError("coalesced MFMA output requires a square 8x8 wave64 tile")


def _validate_phased_dma_schedule(cfg: _MatmulConfig) -> None:
    schedule = cfg.phased_dma_schedule
    if schedule is None:
        return
    if not cfg.use_dma_lds:
        raise ValueError("phased DMA schedule requires use_dma_lds")
    if schedule.delayed_waves > cfg.waves_per_workgroup:
        raise ValueError("phased DMA delayed waves exceed workgroup wave count")
    if schedule.subpanel_pipeline and cfg.uses_packed_mxfp4:
        raise ValueError("DMA subpanel pipeline does not support packed MXFP4")
    if schedule.subpanel_pipeline and cfg.wave_k_tiles != 2:
        raise ValueError("DMA subpanel pipeline requires two K32 phases")
    if schedule.subpanel_pipeline and cfg.wave_m_tiles < 2:
        raise ValueError("DMA subpanel pipeline requires at least two M tiles per wave")


def _validate_dma_lds_shape(cfg: _MatmulConfig) -> None:
    _validate_phased_dma_schedule(cfg)
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
    if _uses_dma_subpanel_pipeline(cfg):
        block_m_tiles = cfg.BM * cfg.wave_m_tiles
        block_n_tiles = cfg.BN * cfg.wave_n_tiles
        if block_m_tiles % cfg.waves_per_workgroup != 0:
            raise ValueError("DMA LDS A subpanels must divide evenly across waves")
        if block_n_tiles % cfg.waves_per_workgroup != 0:
            raise ValueError("DMA LDS B subpanels must divide evenly across waves")


def _validate_mxfp4_shape(cfg: _MatmulConfig) -> None:
    if not cfg.uses_packed_mxfp4:
        return


_KERNEL_NAME = "wmma_f16_matmul_tiled"
_GPU_MODULE_NAME = "kernels"
_F16_PTR_HELPER = "wave_memref_to_ptr_global_f16"
_BF16_PTR_HELPER = "wave_memref_to_ptr_global_bf16"
_I8_PTR_HELPER = "wave_memref_to_ptr_global_i8"
_F32_PTR_HELPER = "wave_memref_to_ptr_global_f32"
_PRINT_HELPER = "printMemrefF32"
_PRINT_F16_HELPER = "printMemrefF16"
_TARGET_WAVES_ATTR = "waveamdmachine.target_waves"
_ENABLE_SPLIT_BARRIERS_ATTR = "waveamdmachine.enable_split_barriers"
_ENABLE_MULTI_WAVE_SPECIALIZATION_ATTR = (
    "waveamdmachine.enable_multi_wave_specialization"
)
_DYNAMIC_LDS_ATTR = "wave.dynamic_lds_size"
_STATIC_LDS_LIMIT = 64 * 1024
_MXFP4_SCALE_PACK = 4
_Mxfp4ScaleAxis = Literal["m", "n"]


def _mxfp4_scale_tiles_per_wave(tile_count: int) -> int:
    if tile_count % _MXFP4_SCALE_PACK != 0:
        return tile_count
    return tile_count // _MXFP4_SCALE_PACK


def _splat_const(bld: dsl.FunctionBuilder, value: int) -> dsl.Value:
    return bld.splat(bld.constant(dsl.i32(), value))


def _target_waves_attrs(target_waves: int | None) -> dict[str, dsl.Attribute]:
    if target_waves is None:
        return {}
    if target_waves <= 0:
        raise ValueError(f"target_waves must be positive; got {target_waves}")
    return {_TARGET_WAVES_ATTR: dsl.i64_attr(target_waves)}


def _dynamic_lds_bytes(cfg: _MatmulConfig) -> int:
    return cfg.lds_bytes if cfg.lds_bytes >= _STATIC_LDS_LIMIT else 0


def _fixed_lds_bytes(cfg: _MatmulConfig) -> int:
    return 0 if _dynamic_lds_bytes(cfg) else cfg.lds_bytes


def _kernel_attrs(
    cfg: _MatmulConfig, target_waves: int | None
) -> dict[str, dsl.Attribute]:
    attrs = _target_waves_attrs(target_waves)
    if cfg.enable_split_barriers:
        attrs[_ENABLE_SPLIT_BARRIERS_ATTR] = UnitAttr.get()
    if cfg.enable_multi_wave_specialization:
        attrs[_ENABLE_MULTI_WAVE_SPECIALIZATION_ATTR] = UnitAttr.get()
    dynamic_lds = _dynamic_lds_bytes(cfg)
    if dynamic_lds:
        attrs[_DYNAMIC_LDS_ATTR] = dsl.i64_attr(dynamic_lds)
    return attrs


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
        for group in range(groups)
        for row in range(rows)
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
                    a *= _e8m0_to_f32(a_scales[group * cfg.M + m])
                    b *= _e8m0_to_f32(b_scales[group * cfg.N + n])
                acc += a * b
            tile.append(acc)
    return tuple(tile)


def _store_reference_tile(
    out: list[float],
    cfg: _MatmulConfig,
    tile: tuple[float, ...],
    m_tile: int,
    n_tile: int,
    coalesced_mfma_output: bool,
) -> None:
    if not coalesced_mfma_output:
        out.extend(tile)
        return
    for mi in range(16):
        for nj in range(16):
            m = m_tile * 16 + mi
            n = n_tile * 16 + nj
            out[n * cfg.M + m] = tile[mi * 16 + nj]


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
    coalesced_mfma_output: bool = False,
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
        coalesced_mfma_output=coalesced_mfma_output,
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
    out: list[float] = [0.0] * cfg.total_elements if coalesced_mfma_output else []
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
                        tile = _reference_tile(
                            cfg,
                            a_values,
                            b_values,
                            m_tile,
                            n_tile,
                            a_scales,
                            b_scales,
                        )
                        _store_reference_tile(
                            out,
                            cfg,
                            tile,
                            m_tile,
                            n_tile,
                            coalesced_mfma_output,
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
    return wg_m_val, wg_n_val


def _emit_c_ptr(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    c_arg: dsl.Value,
    wg_m: dsl.Expr,
    wg_n: dsl.Expr,
    wave_id: dsl.Expr,
    m_wave: dsl.Expr,
    n_wave: dsl.Expr,
    bindings: dict[dsl.Expr, dsl.Value],
) -> dsl.Value:
    if cfg.coalesced_mfma_output:
        wave_m = 16 * cfg.wave_m_tiles
        wave_n = 16 * cfg.wave_n_tiles
        c_wave_off = bld.index_expr(
            wg_m * (cfg.BM * wave_m)
            + n_wave * wave_m
            + (wg_n * (cfg.BN * wave_n) + m_wave * wave_n) * cfg.M,
            bindings=bindings,
        )
        return bld.ptr_add(c_arg, c_wave_off)

    c_cta_off = bld.index_expr(
        wg_m * (cfg.N_blocks * cfg.waves_per_workgroup * cfg.tiles_per_wave * 256)
        + wg_n * (cfg.waves_per_workgroup * cfg.tiles_per_wave * 256),
        bindings=bindings,
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
        bindings=bindings,
    )
    return bld.ptr_add(c_base, c_wave_off)


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
        if cfg.coalesced_mfma_output:
            c_arg = _wrap_in_buffer(
                bld,
                c_arg,
                cfg.c_elements,
                _output_element_type(cfg),
                cfg.c_element_bytes,
            )

    wi_val = bld.workitem_id(axis=0, width=cfg.mma.wave_size)
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

    c_ptr = _emit_c_ptr(
        bld,
        cfg,
        c_arg,
        wg_m,
        wg_n,
        wave_id,
        m_wave,
        n_wave,
        sym_to_val,
    )

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
    a_dma_lds_byte_ptrs: tuple[dsl.Value, ...] = ()
    b_dma_lds_byte_ptrs: tuple[dsl.Value, ...] = ()
    dma_lds_wave_byte_base: dsl.Value | None = None
    dma_read_lds: dsl.Value | None = None
    a_dma_read_base_offset: dsl.Value | None = None
    b_dma_read_base_offset: dsl.Value | None = None
    a_dma_read_offsets: tuple[int, ...] = ()
    b_dma_read_offsets: tuple[int, ...] = ()


@dataclass(frozen=True)
class _DmaCtaStagingPtrs:
    a_src: tuple[dsl.Value, ...]
    b_src: tuple[dsl.Value, ...]
    a_lds: tuple[dsl.Value, ...]
    b_lds: tuple[dsl.Value, ...]
    a_lds_bytes: tuple[dsl.Value, ...]
    b_lds_bytes: tuple[dsl.Value, ...]
    lds_wave_byte_base: dsl.Value
    a_read: tuple[dsl.Value, ...]
    b_read: tuple[dsl.Value, ...]
    a_read_base_offset: dsl.Value
    b_read_base_offset: dsl.Value
    a_read_offsets: tuple[int, ...]
    b_read_offsets: tuple[int, ...]


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
    if cfg.coalesced_mfma_output:
        dwords += cfg.mma.ab_registers
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


def _uses_phased_dma_schedule(cfg: _MatmulConfig) -> bool:
    return cfg.phased_dma_schedule is not None


def _uses_dma_subpanel_pipeline(cfg: _MatmulConfig) -> bool:
    schedule = cfg.phased_dma_schedule
    return schedule is not None and schedule.subpanel_pipeline


def _dma_buffer_count(cfg: _MatmulConfig) -> int:
    if not cfg.use_dma_lds or cfg.virtual_k_steps <= 1:
        return 1
    if (
        not cfg.uses_packed_mxfp4
        and not _uses_phased_dma_schedule(cfg)
        and cfg.virtual_k_steps > 2
    ):
        return 4
    return 2


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


@dataclass(frozen=True)
class _DmaCtaStagingContext:
    bld: dsl.FunctionBuilder
    cfg: _MatmulConfig
    coords: _TileCoords
    lds: dsl.Value
    lds_bytes: dsl.Value
    geom: _DmaCtaGeometry
    first_bindings: dict[dsl.Expr, dsl.Value]
    bindings: dict[dsl.Expr, dsl.Value]
    wg_m: dsl.Expr
    wg_n: dsl.Expr
    wave_id: dsl.Expr
    wave_id_uniform: dsl.Expr
    lane: dsl.Expr
    lane_mod16: dsl.Expr
    lane_k_group: dsl.Expr
    src_row: dsl.Expr
    src_k_group: int | dsl.Expr
    read_k_group: int | dsl.Expr
    lds_wave_byte_base: dsl.Value
    chunks_per_row: int


@dataclass(frozen=True)
class _DmaCtaCommonPtrs:
    a_src: tuple[dsl.Value, ...]
    b_src: tuple[dsl.Value, ...]
    a_lds: tuple[dsl.Value, ...]
    b_lds: tuple[dsl.Value, ...]
    a_lds_bytes: tuple[dsl.Value, ...]
    b_lds_bytes: tuple[dsl.Value, ...]


def _make_dma_cta_staging_context(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    coords: _TileCoords,
    lds: dsl.Value,
) -> _DmaCtaStagingContext:
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
    lds_bytes = bld.shared_memory_base(dsl.i8())
    lds_wave_byte_offset = bld.index_expr(
        4 * wave_id_uniform * geom.dwords_per_slot,
        bindings=first_bindings,
    )
    lds_wave_byte_base = bld.cast(
        lds_wave_byte_offset, dsl.i32(), dsl.CastKind.IntConvert
    )
    return _DmaCtaStagingContext(
        bld=bld,
        cfg=cfg,
        coords=coords,
        lds=lds,
        lds_bytes=lds_bytes,
        geom=geom,
        first_bindings=first_bindings,
        bindings=bindings,
        wg_m=wg_m,
        wg_n=wg_n,
        wave_id=wave_id,
        wave_id_uniform=wave_id_uniform,
        lane=lane,
        lane_mod16=lane_mod16,
        lane_k_group=lane_k_group,
        src_row=src_row,
        src_k_group=src_k_group,
        read_k_group=read_k_group,
        lds_wave_byte_base=lds_wave_byte_base,
        chunks_per_row=chunks_per_row,
    )


def _dma_lds_ptr(
    ctx: _DmaCtaStagingContext, slot_per_wave: int, base: int
) -> dsl.Value:
    slot_off = ctx.bld.index_expr(
        base
        + _dma_slot_expr(ctx.cfg, slot_per_wave, ctx.wave_id_uniform)
        * ctx.geom.dwords_per_slot,
        bindings=ctx.first_bindings,
    )
    return ctx.bld.ptr_add(ctx.lds, slot_off)


def _dma_lds_byte_ptr(
    ctx: _DmaCtaStagingContext, slot_per_wave: int, base: int
) -> dsl.Value:
    byte_offset = 4 * (
        base + slot_per_wave * ctx.cfg.waves_per_workgroup * ctx.geom.dwords_per_slot
    )
    return ctx.bld.ptr_add(ctx.lds_bytes, ctx.bld.constant(dsl.i32(), byte_offset))


def _a_dma_src_ptr(ctx: _DmaCtaStagingContext, slot_per_wave: int) -> dsl.Value:
    cfg = ctx.cfg
    slot = _dma_slot_expr(cfg, slot_per_wave, ctx.wave_id)
    if cfg.coalesced_mfma_output:
        row = slot * cfg.wave_m_tiles + dsl.floor(
            ctx.lane / (ctx.chunks_per_row * cfg.wave_k_tiles)
        )
        k_group = dsl.mod(ctx.lane, ctx.chunks_per_row * cfg.wave_k_tiles)
        off = ctx.bld.index_expr(
            ctx.wg_m * (ctx.geom.block_m_tiles * 16 * cfg.storage_K)
            + row * cfg.storage_K
            + k_group * cfg.storage_lane_k_elems,
            bindings=ctx.bindings,
        )
        return ctx.bld.ptr_add(ctx.coords.a_base, off)
    k_tile, m_tile = _dma_slot_major_minor(slot, ctx.geom.block_m_tiles)
    off = ctx.bld.index_expr(
        ctx.wg_m * (ctx.geom.block_m_tiles * 16 * cfg.storage_K)
        + m_tile * (16 * cfg.storage_K)
        + k_tile * cfg.storage_k_tile
        + ctx.src_row * cfg.storage_K
        + ctx.src_k_group * cfg.storage_lane_k_elems,
        bindings=ctx.bindings,
    )
    return ctx.bld.ptr_add(ctx.coords.a_base, off)


def _b_dma_src_ptr(ctx: _DmaCtaStagingContext, slot_per_wave: int) -> dsl.Value:
    cfg = ctx.cfg
    slot = _dma_slot_expr(cfg, slot_per_wave, ctx.wave_id)
    if cfg.coalesced_mfma_output:
        row = slot * cfg.wave_n_tiles + dsl.floor(
            ctx.lane / (ctx.chunks_per_row * cfg.wave_k_tiles)
        )
        k_group = dsl.mod(ctx.lane, ctx.chunks_per_row * cfg.wave_k_tiles)
        off = ctx.bld.index_expr(
            ctx.wg_n * (ctx.geom.block_n_tiles * 16 * cfg.storage_K)
            + row * cfg.storage_K
            + k_group * cfg.storage_lane_k_elems,
            bindings=ctx.bindings,
        )
        return ctx.bld.ptr_add(ctx.coords.b_base, off)
    k_tile, n_tile = _dma_slot_major_minor(slot, ctx.geom.block_n_tiles)
    off = ctx.bld.index_expr(
        ctx.wg_n * (ctx.geom.block_n_tiles * 16 * cfg.storage_K)
        + n_tile * (16 * cfg.storage_K)
        + k_tile * cfg.storage_k_tile
        + ctx.src_row * cfg.storage_K
        + ctx.src_k_group * cfg.storage_lane_k_elems,
        bindings=ctx.bindings,
    )
    return ctx.bld.ptr_add(ctx.coords.b_base, off)


def _dma_read_ptr(
    ctx: _DmaCtaStagingContext, slot: int | dsl.Expr, base: int
) -> dsl.Value:
    slot_off = ctx.bld.index_expr(
        base
        + slot * ctx.geom.dwords_per_slot
        + ctx.lane_mod16 * ctx.cfg.storage_k_tile_dwords
        + ctx.read_k_group * ctx.cfg.storage_lane_k_dwords,
        bindings=ctx.bindings,
    )
    return ctx.bld.ptr_add(ctx.lds, slot_off)


def _dma_read_base_offset(
    ctx: _DmaCtaStagingContext, slot: int | dsl.Expr, base: int
) -> dsl.Value:
    offset = ctx.bld.index_expr(
        4
        * (
            base
            + slot * ctx.geom.dwords_per_slot
            + ctx.lane_mod16 * ctx.cfg.storage_k_tile_dwords
            + ctx.read_k_group * ctx.cfg.storage_lane_k_dwords
        ),
        bindings=ctx.bindings,
    )
    return ctx.bld.cast(
        offset,
        dsl.simd_type(dsl.i32(), ctx.cfg.mma.wave_size),
        dsl.CastKind.IntConvert,
    )


def _regular_dma_read_offsets(
    cfg: _MatmulConfig,
    geom: _DmaCtaGeometry,
    block_tiles: int,
    wave_tiles: int,
) -> tuple[int, ...]:
    return tuple(
        4 * (k * block_tiles + tile) * geom.dwords_per_slot
        for k in range(cfg.wave_k_tiles)
        for tile in range(wave_tiles)
    )


def _coalesced_dma_read_ptr(
    ctx: _DmaCtaStagingContext,
    tile: int,
    phase: int,
    group: dsl.Expr,
    base: int,
) -> dsl.Value:
    cfg = ctx.cfg
    line = group * 16 + ctx.lane_mod16
    tile_stride = cfg.wave_k_tiles * cfg.storage_k_tile_dwords
    off = ctx.bld.index_expr(
        base
        + line * ctx.geom.dwords_per_slot
        + tile * tile_stride
        + phase * cfg.storage_k_tile_dwords
        + ctx.lane_k_group * cfg.storage_lane_k_dwords,
        bindings=ctx.bindings,
    )
    return ctx.bld.ptr_add(ctx.lds, off)


def _coalesced_dma_read_base_offset(
    ctx: _DmaCtaStagingContext, group: dsl.Expr, base: int
) -> dsl.Value:
    line = group * 16 + ctx.lane_mod16
    offset = ctx.bld.index_expr(
        4
        * (
            base
            + line * ctx.geom.dwords_per_slot
            + ctx.lane_k_group * ctx.cfg.storage_lane_k_dwords
        ),
        bindings=ctx.bindings,
    )
    return ctx.bld.cast(
        offset,
        dsl.simd_type(dsl.i32(), ctx.cfg.mma.wave_size),
        dsl.CastKind.IntConvert,
    )


def _emit_dma_cta_common_ptrs(
    ctx: _DmaCtaStagingContext,
) -> _DmaCtaCommonPtrs:
    geom = ctx.geom
    return _DmaCtaCommonPtrs(
        a_src=tuple(_a_dma_src_ptr(ctx, i) for i in range(geom.a_slots_per_wave)),
        b_src=tuple(_b_dma_src_ptr(ctx, i) for i in range(geom.b_slots_per_wave)),
        a_lds=tuple(_dma_lds_ptr(ctx, i, 0) for i in range(geom.a_slots_per_wave)),
        b_lds=tuple(
            _dma_lds_ptr(ctx, i, geom.b_lds_base) for i in range(geom.b_slots_per_wave)
        ),
        a_lds_bytes=tuple(
            _dma_lds_byte_ptr(ctx, i, 0) for i in range(geom.a_slots_per_wave)
        ),
        b_lds_bytes=tuple(
            _dma_lds_byte_ptr(ctx, i, geom.b_lds_base)
            for i in range(geom.b_slots_per_wave)
        ),
    )


def _emit_coalesced_dma_cta_staging_ptrs(
    ctx: _DmaCtaStagingContext,
) -> _DmaCtaStagingPtrs:
    cfg = ctx.cfg
    geom = ctx.geom
    m_wave = dsl.floor(ctx.wave_id / cfg.BN)
    n_wave = dsl.mod(ctx.wave_id, cfg.BN)
    tile_stride = cfg.wave_k_tiles * cfg.storage_k_tile_dwords
    a_read_base_offset = _coalesced_dma_read_base_offset(ctx, n_wave, 0)
    b_read_base_offset = _coalesced_dma_read_base_offset(ctx, m_wave, geom.b_lds_base)
    a_read_offsets = tuple(
        4 * (i * tile_stride + k * cfg.storage_k_tile_dwords)
        for k in range(cfg.wave_k_tiles)
        for i in range(cfg.wave_m_tiles)
    )
    b_read_offsets = tuple(
        4 * (j * tile_stride + k * cfg.storage_k_tile_dwords)
        for k in range(cfg.wave_k_tiles)
        for j in range(cfg.wave_n_tiles)
    )
    common = _emit_dma_cta_common_ptrs(ctx)
    return _DmaCtaStagingPtrs(
        a_src=common.a_src,
        b_src=common.b_src,
        a_lds=common.a_lds,
        b_lds=common.b_lds,
        a_lds_bytes=common.a_lds_bytes,
        b_lds_bytes=common.b_lds_bytes,
        lds_wave_byte_base=ctx.lds_wave_byte_base,
        a_read=tuple(
            _coalesced_dma_read_ptr(ctx, i, k, n_wave, 0)
            for k in range(cfg.wave_k_tiles)
            for i in range(cfg.wave_m_tiles)
        ),
        b_read=tuple(
            _coalesced_dma_read_ptr(ctx, j, k, m_wave, geom.b_lds_base)
            for k in range(cfg.wave_k_tiles)
            for j in range(cfg.wave_n_tiles)
        ),
        a_read_base_offset=a_read_base_offset,
        b_read_base_offset=b_read_base_offset,
        a_read_offsets=a_read_offsets,
        b_read_offsets=b_read_offsets,
    )


def _emit_regular_dma_cta_staging_ptrs(
    ctx: _DmaCtaStagingContext,
) -> _DmaCtaStagingPtrs:
    cfg = ctx.cfg
    geom = ctx.geom
    a_wave = dsl.floor(ctx.wave_id / cfg.BN)
    b_wave = dsl.mod(ctx.wave_id, cfg.BN)
    a_read_slots = tuple(
        k * geom.block_m_tiles + a_wave * cfg.wave_m_tiles + i
        for k in range(cfg.wave_k_tiles)
        for i in range(cfg.wave_m_tiles)
    )
    b_read_slots = tuple(
        k * geom.block_n_tiles + b_wave * cfg.wave_n_tiles + j
        for k in range(cfg.wave_k_tiles)
        for j in range(cfg.wave_n_tiles)
    )
    common = _emit_dma_cta_common_ptrs(ctx)
    return _DmaCtaStagingPtrs(
        a_src=common.a_src,
        b_src=common.b_src,
        a_lds=common.a_lds,
        b_lds=common.b_lds,
        a_lds_bytes=common.a_lds_bytes,
        b_lds_bytes=common.b_lds_bytes,
        lds_wave_byte_base=ctx.lds_wave_byte_base,
        a_read=tuple(_dma_read_ptr(ctx, slot, 0) for slot in a_read_slots),
        b_read=tuple(
            _dma_read_ptr(ctx, slot, geom.b_lds_base) for slot in b_read_slots
        ),
        a_read_base_offset=_dma_read_base_offset(ctx, a_wave * cfg.wave_m_tiles, 0),
        b_read_base_offset=_dma_read_base_offset(
            ctx, b_wave * cfg.wave_n_tiles, geom.b_lds_base
        ),
        a_read_offsets=_regular_dma_read_offsets(
            cfg, geom, geom.block_m_tiles, cfg.wave_m_tiles
        ),
        b_read_offsets=_regular_dma_read_offsets(
            cfg, geom, geom.block_n_tiles, cfg.wave_n_tiles
        ),
    )


def _emit_dma_cta_staging_ptrs(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    coords: _TileCoords,
    lds: dsl.Value,
) -> _DmaCtaStagingPtrs:
    ctx = _make_dma_cta_staging_context(bld, cfg, coords, lds)
    if cfg.coalesced_mfma_output:
        return _emit_coalesced_dma_cta_staging_ptrs(ctx)
    return _emit_regular_dma_cta_staging_ptrs(ctx)


def _emit_lds_staging(
    bld: dsl.FunctionBuilder, cfg: _MatmulConfig, coords: _TileCoords
) -> _LdsStaging:
    """Materialize per-wave A/B LDS slot pointers."""
    reg_simd_type = dsl.simd_type(
        dsl.vector_type(cfg.mma.ab_registers, dsl.i32()), width=cfg.mma.wave_size
    )
    lds = bld.shared_memory_base()
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

    dma = _emit_dma_cta_staging_ptrs(
        bld,
        cfg,
        coords,
        lds,
    )
    return _LdsStaging(
        reg_simd_type=reg_simd_type,
        a_lds_ptrs=a_lds_ptrs,
        b_lds_ptrs=b_lds_ptrs,
        a_dma_lds_ptrs=dma.a_lds,
        b_dma_lds_ptrs=dma.b_lds,
        a_dma_read_ptrs=dma.a_read,
        b_dma_read_ptrs=dma.b_read,
        a_dma_src_ptrs=dma.a_src,
        b_dma_src_ptrs=dma.b_src,
        a_dma_lds_byte_ptrs=dma.a_lds_bytes,
        b_dma_lds_byte_ptrs=dma.b_lds_bytes,
        dma_lds_wave_byte_base=dma.lds_wave_byte_base,
        dma_read_lds=bld.shared_memory_base(dsl.i8()),
        a_dma_read_base_offset=dma.a_read_base_offset,
        b_dma_read_base_offset=dma.b_read_base_offset,
        a_dma_read_offsets=dma.a_read_offsets,
        b_dma_read_offsets=dma.b_read_offsets,
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
    dma_tokens = _dma_issue(bld, cfg, a_ptrs, b_ptrs, staging, in_loop=False)
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


def _dep_or_token(bld: dsl.FunctionBuilder, dep: dsl.Value | None) -> dsl.Value:
    return dep if dep is not None else bld.token()


def _dma_issue_delay_options(
    cfg: _MatmulConfig, request: int, in_loop: bool
) -> tuple[int | None, int | None, int | None]:
    schedule = cfg.phased_dma_schedule
    if schedule is None:
        return None, None, None
    delayed = request % schedule.issue_group_size == 0
    configured_delay = (
        schedule.loop_delay_cycles if in_loop else schedule.initial_delay_cycles
    )
    delay_cycles = configured_delay if delayed and configured_delay > 0 else None
    overlap_cycles = (
        schedule.loop_overlap_cycles if in_loop and delay_cycles is not None else None
    )
    skip_threshold = (
        schedule.delayed_waves * cfg.mma.wave_size
        if in_loop
        and delay_cycles is not None
        and schedule.delayed_waves < cfg.waves_per_workgroup
        else None
    )
    return delay_cycles, overlap_cycles, skip_threshold


def _dma_issue(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    a_ptrs: tuple[dsl.Value, ...],
    b_ptrs: tuple[dsl.Value, ...],
    staging: _LdsStaging,
    *,
    after: dsl.Value | None = None,
    lds_offset: int | dsl.Value = 0,
    in_loop: bool,
    request_offset: int = 0,
) -> list[dsl.Value]:
    dep = after if after is not None else bld.token()
    a_lds_ptrs = _offset_ptrs(bld, staging.a_dma_lds_ptrs, lds_offset)
    b_lds_ptrs = _offset_ptrs(bld, staging.b_dma_lds_ptrs, lds_offset)
    requests = [
        *zip(a_ptrs, a_lds_ptrs, strict=True),
        *zip(b_ptrs, b_lds_ptrs, strict=True),
    ]
    return _dma_issue_requests(
        bld,
        cfg,
        requests,
        after=dep,
        in_loop=in_loop,
        request_offset=request_offset,
    )


def _dma_issue_requests(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    requests: list[tuple[dsl.Value, dsl.Value]],
    *,
    after: dsl.Value | None,
    in_loop: bool,
    request_offset: int,
) -> list[dsl.Value]:
    dep = after if after is not None else bld.token()
    dma_tokens: list[dsl.Value] = []
    for request, (ptr, lds_ptr) in enumerate(requests, start=request_offset + 1):
        delay_cycles, overlap_cycles, skip_threshold = _dma_issue_delay_options(
            cfg, request, in_loop
        )
        tok = bld.dma_load_lds(
            ptr,
            lds_ptr,
            after=dep,
            bytes=16,
            zero_fill_inactive=True,
            issue_delay_cycles=delay_cycles,
            issue_delay_overlap_cycles=overlap_cycles,
            issue_delay_skip_thread_threshold=skip_threshold,
        )
        dma_tokens.append(tok)
    return dma_tokens


def _dma_b_wave_n_slice_indices(
    cfg: _MatmulConfig, n_begin: int, n_end: int
) -> tuple[int, ...] | None:
    geom = _dma_cta_geometry(cfg)
    indices: list[int] = []
    for slot_per_wave in range(geom.b_slots_per_wave):
        in_slice: list[bool] = []
        for wave_id in range(cfg.waves_per_workgroup):
            slot = slot_per_wave * cfg.waves_per_workgroup + wave_id
            n_tile = slot % geom.block_n_tiles
            j = n_tile % cfg.wave_n_tiles
            in_slice.append(n_begin <= j < n_end)
        if any(in_slice):
            if not all(in_slice):
                return None
            indices.append(slot_per_wave)
    return tuple(indices)


def _select_values(
    values: tuple[dsl.Value, ...], indices: tuple[int, ...]
) -> tuple[dsl.Value, ...]:
    return tuple(values[i] for i in indices)


def _dma_issue_parts(
    bld: dsl.FunctionBuilder,
    a_ptrs: tuple[dsl.Value, ...],
    b_ptrs: tuple[dsl.Value, ...],
    staging: _LdsStaging,
    *,
    after: dsl.Value | None,
    lds_offset: int | dsl.Value,
    include_a: bool,
    b_indices: tuple[int, ...],
) -> list[dsl.Value]:
    dep = after if after is not None else bld.token()
    dma_tokens: list[dsl.Value] = []
    if include_a:
        a_lds_ptrs = _offset_ptrs(bld, staging.a_dma_lds_ptrs, lds_offset)
        for ptr, lds_ptr in zip(a_ptrs, a_lds_ptrs, strict=True):
            dma_tokens.append(
                bld.dma_load_lds(
                    ptr, lds_ptr, after=dep, bytes=16, zero_fill_inactive=True
                )
            )
    b_lds_ptrs = _offset_ptrs(
        bld, _select_values(staging.b_dma_lds_ptrs, b_indices), lds_offset
    )
    for ptr, lds_ptr in zip(_select_values(b_ptrs, b_indices), b_lds_ptrs, strict=True):
        dma_tokens.append(
            bld.dma_load_lds(ptr, lds_ptr, after=dep, bytes=16, zero_fill_inactive=True)
        )
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
    return _dma_read_ready(
        bld,
        bld.barrier(dma_token),
        a_type,
        b_type,
        staging,
        lds_offset=lds_offset,
    )


def _dma_read_ready(
    bld: dsl.FunctionBuilder,
    ready_token: dsl.Value,
    a_type: dsl.Type,
    b_type: dsl.Type,
    staging: _LdsStaging,
    *,
    lds_offset: int | dsl.Value = 0,
) -> tuple[tuple[dsl.Value, ...], tuple[dsl.Value, ...], dsl.Value]:
    a_frags: list[dsl.Value] = []
    b_frags: list[dsl.Value] = []
    load_tokens: list[dsl.Value] = []
    a_read_ptrs = _offset_ptrs(bld, staging.a_dma_read_ptrs, lds_offset)
    b_read_ptrs = _offset_ptrs(bld, staging.b_dma_read_ptrs, lds_offset)
    for lds_ptr in a_read_ptrs:
        regs, tok = bld.load(lds_ptr, staging.reg_simd_type, after=ready_token)
        load_tokens.append(tok)
        a_frags.append(bld.fragment_pack(regs, a_type))
    for lds_ptr in b_read_ptrs:
        regs, tok = bld.load(lds_ptr, staging.reg_simd_type, after=ready_token)
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
    scale_token: dsl.Value | None = None
    next_scale_token: dsl.Value | None = None


@dataclass(frozen=True)
class _InitialLoadState:
    a_frags: tuple[dsl.Value, ...]
    b_frags: tuple[dsl.Value, ...]
    ready_token: dsl.Value | None
    reuse_token: dsl.Value
    scale_token: dsl.Value | None = None
    next_scale_token: dsl.Value | None = None


@dataclass(frozen=True)
class _DmaSubpanelTokens:
    a: tuple[dsl.Value, ...]
    b: tuple[dsl.Value, ...]


@dataclass(frozen=True)
class _DmaSubpanelReadBases:
    a: dsl.Value
    b: dsl.Value


@dataclass(frozen=True)
class _DmaSubpanelLoopState:
    accs: tuple[dsl.Value, ...]
    a_frags: tuple[dsl.Value, ...]
    b_frags: tuple[dsl.Value, ...]
    a_read: dsl.Value
    b_read: dsl.Value
    current_access: dsl.Value
    current_read_bases: _DmaSubpanelReadBases
    current_lds_offset: dsl.Value
    current_dma_lds_byte_base: dsl.Value
    ready: _DmaSubpanelTokens


@dataclass(frozen=True)
class _DmaSubpanelReuseState:
    accs: tuple[dsl.Value, ...]
    a1_frags: tuple[dsl.Value, ...]
    b1_frags: tuple[dsl.Value, ...]
    reuse_access: dsl.Value
    next_a0: dsl.Value
    next_a1_early: dsl.Value | None
    release_mmas: int


def _kernel_types(cfg: _MatmulConfig) -> _KernelTypes:
    a_role = 1 if cfg.coalesced_mfma_output else 0
    b_role = 0 if cfg.coalesced_mfma_output else 1
    return _KernelTypes(
        a=dsl.fragment_type(
            a_role,
            cfg.input_element_type,
            16,
            16,
            cfg.mma.wave_size,
            cfg.mma.ab_registers,
        ),
        b=dsl.fragment_type(
            b_role,
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


def _mma_acc_index(cfg: _MatmulConfig, i: int, j: int) -> int:
    if cfg.coalesced_mfma_output:
        return j * cfg.wave_m_tiles + i
    return i * cfg.wave_n_tiles + j


def _emit_mma(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    af: dsl.Value,
    bf: dsl.Value,
    acc: dsl.Value,
) -> dsl.Value:
    if cfg.coalesced_mfma_output:
        return bld.mma(cfg.mma.kind, bf, af, acc)
    return bld.mma(cfg.mma.kind, af, bf, acc)


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


def _dma_subpanel_read_bases(
    bld: dsl.FunctionBuilder,
    staging: _LdsStaging,
    lds_offset: int | dsl.Value,
) -> _DmaSubpanelReadBases:
    assert (
        staging.a_dma_read_base_offset is not None
        and staging.b_dma_read_base_offset is not None
    )
    offsets = _DmaSubpanelReadBases(
        staging.a_dma_read_base_offset, staging.b_dma_read_base_offset
    )
    if not (isinstance(lds_offset, int) and lds_offset == 0):
        offset = (
            bld.constant(dsl.i32(), 4 * lds_offset)
            if isinstance(lds_offset, int)
            else bld.muli(lds_offset, bld.constant(dsl.i32(), 4))
        )
        offsets = _DmaSubpanelReadBases(
            bld.addi(offsets.a, offset), bld.addi(offsets.b, offset)
        )
    return offsets


def _next_dma_subpanel_read_state(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    staging: _LdsStaging,
    current_lds_offset: dsl.Value,
) -> tuple[_DmaSubpanelReadBases, dsl.Value]:
    assert _dma_buffer_count(cfg) == 2
    buffer_dwords = _dma_cta_buffer_dwords(cfg)
    next_lds_offset = bld.subi(
        bld.constant(dsl.i32(), buffer_dwords), current_lds_offset
    )
    return _dma_subpanel_read_bases(bld, staging, next_lds_offset), next_lds_offset


def _dma_subpanel_lds_byte_base(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    staging: _LdsStaging,
    step: int | dsl.Value,
) -> dsl.Value:
    assert staging.dma_lds_wave_byte_base is not None
    buffer_bytes = 4 * _dma_cta_buffer_dwords(cfg)
    if isinstance(step, int):
        byte_offset = (step % _dma_buffer_count(cfg)) * buffer_bytes
        if byte_offset == 0:
            result = staging.dma_lds_wave_byte_base
        else:
            offset = bld.constant(dsl.i32(), byte_offset)
            result = bld.addi(staging.dma_lds_wave_byte_base, offset)
    else:
        i = dsl.sym("i")
        offset = bld.index_expr(
            dsl.mod(i, _dma_buffer_count(cfg)) * buffer_bytes,
            bindings={i: step},
        )
        offset = bld.cast(offset, dsl.i32(), dsl.CastKind.IntConvert)
        result = bld.addi(staging.dma_lds_wave_byte_base, offset)
    return result


def _dma_subpanel_read_ptrs(
    bld: dsl.FunctionBuilder,
    staging: _LdsStaging,
    base_offset: dsl.Value,
    offsets: tuple[int, ...],
) -> tuple[dsl.Value, ...]:
    assert staging.dma_read_lds is not None
    base = bld.ptr_add(staging.dma_read_lds, base_offset)
    return tuple(_ptr_add_const(bld, base, offset) for offset in offsets)


def _dma_buffer_offset(
    bld: dsl.FunctionBuilder, cfg: _MatmulConfig, step: dsl.Value | int
) -> dsl.Value | int:
    buffer_dwords = _dma_cta_buffer_dwords(cfg)
    buffer_count = _dma_buffer_count(cfg)
    if isinstance(step, int):
        return (step % buffer_count) * buffer_dwords
    i = dsl.sym("i")
    return bld.index_expr(dsl.mod(i, buffer_count) * buffer_dwords, bindings={i: step})


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
    step = bld.addi(loop_iv, bld.constant(dsl.i32(), step_base))
    offset = bld.muli(step, virtual_k_stride)

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


@dataclass(frozen=True)
class _Mxfp4ScaleStagingAxis:
    global_base: dsl.Value
    packed_scale_base: dsl.Expr
    unpacked_scale_base: dsl.Expr
    tile_base: dsl.Expr
    dimension: int
    tile_count: int
    tiles_per_wave: int


@dataclass(frozen=True)
class _Mxfp4ScaleSet:
    a_scales: list[dsl.Value]
    a_scale_idxs: list[int]
    b_scales: list[dsl.Value]
    b_scale_idxs: list[int]
    token: dsl.Value


@dataclass(frozen=True)
class _DeferredScaleStore:
    raw: dsl.Value
    dest: dsl.Value
    load_token: dsl.Value
    dep: dsl.Value | None


@dataclass(frozen=True)
class _DeferredScaleRegBatch:
    a_mask: dsl.Value
    b_mask: dsl.Value
    a_loaded: tuple[tuple[dsl.Value, dsl.Value, dsl.Value], ...]
    b_loaded: tuple[tuple[dsl.Value, dsl.Value, dsl.Value], ...]
    dep: dsl.Value | None
    barrier_after: bool


@dataclass(frozen=True)
class _Mxfp4ScaleDmaPlan:
    bindings: dict[dsl.Expr, dsl.Value]
    first_bindings: dict[dsl.Expr, dsl.Value]
    m_wave: dsl.Expr
    n_wave: dsl.Expr
    scale_k: int | dsl.Expr
    lds: dsl.Value
    lds_offset: dsl.Value | int
    dep: dsl.Value | None


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


def _mxfp4_scale_staging_axis(
    cfg: _MatmulConfig,
    coords: _TileCoords,
    layout: _Mxfp4ScaleLayout,
    axis: _Mxfp4ScaleAxis,
    m_wave: dsl.Expr,
    n_wave: dsl.Expr,
) -> _Mxfp4ScaleStagingAxis:
    if axis == "m":
        tile_count = cfg.wave_m_tiles
        workgroup_waves = cfg.BM
        workgroup = layout.wg_m
        wave = m_wave
        dimension = cfg.M
        global_base = coords.a_scale_base
    else:
        tile_count = cfg.wave_n_tiles
        workgroup_waves = cfg.BN
        workgroup = layout.wg_n
        wave = n_wave
        dimension = cfg.N
        global_base = coords.b_scale_base
    if global_base is None:
        raise ValueError("MXFP4 scale buffers are required")
    tiles_per_wave = _mxfp4_scale_tiles_per_wave(tile_count)
    if axis == "m":
        packed_scale_base = wave * tiles_per_wave
        unpacked_scale_base = wave * tile_count
    else:
        scale_base = cfg.BM * _mxfp4_scale_tiles_per_wave(cfg.wave_m_tiles)
        packed_scale_base = scale_base + wave * tiles_per_wave
        unpacked_scale_base = scale_base + wave * tile_count
    return _Mxfp4ScaleStagingAxis(
        global_base=global_base,
        packed_scale_base=packed_scale_base,
        unpacked_scale_base=unpacked_scale_base,
        tile_base=workgroup * (workgroup_waves * tile_count) + wave * tile_count,
        dimension=dimension,
        tile_count=tile_count,
        tiles_per_wave=tiles_per_wave,
    )


def _scale_shared_memory_base(
    bld: dsl.FunctionBuilder, cfg: _MatmulConfig, lds_offset: dsl.Value | int
) -> dsl.Value:
    lds = bld.shared_memory_base(dsl.i8(), offset=cfg.data_lds_bytes)
    if isinstance(lds_offset, int):
        if lds_offset == 0:
            return lds
        return _ptr_add_const(bld, lds, lds_offset * 4)
    offset = dsl.sym("scale_lds_offset")
    byte_offset = bld.index_expr(offset * 4, bindings={offset: lds_offset})
    return bld.ptr_add(lds, byte_offset)


def _scale_lds_batch_stride_dwords(cfg: _MatmulConfig) -> int:
    return cfg.wave_k_tiles * _mxfp4_scale_lds_stride_dwords(cfg)


def _scale_buffer_offset(
    bld: dsl.FunctionBuilder, cfg: _MatmulConfig, step: dsl.Value | int
) -> dsl.Value | int:
    buffer_dwords = _scale_lds_batch_stride_dwords(cfg)
    if isinstance(step, int):
        return (step & 1) * buffer_dwords
    i = dsl.sym("i")
    return bld.index_expr(dsl.mod(i, 2) * buffer_dwords, bindings={i: step})


def _mxfp4_scale_lds_stride_dwords(cfg: _MatmulConfig) -> int:
    a_tiles = cfg.BM * _mxfp4_scale_tiles_per_wave(cfg.wave_m_tiles)
    b_tiles = cfg.BN * _mxfp4_scale_tiles_per_wave(cfg.wave_n_tiles)
    return (a_tiles + b_tiles) * 128


def _add_lds_dword_offset(
    bld: dsl.FunctionBuilder, base: dsl.Value | int, offset: int
) -> dsl.Value | int:
    if offset == 0:
        return base
    if isinstance(base, int):
        return base + offset
    base_sym = dsl.sym("scale_lds_base")
    return bld.index_expr(base_sym + offset, bindings={base_sym: base})


def _use_mxfp4_scale_dma(cfg: _MatmulConfig) -> bool:
    return cfg.use_dma_lds and cfg.mxfp4_scale_path == "dma"


def _stage_mxfp4_scale_tiles_after_dep(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    coords: _TileCoords,
    step: dsl.Value | int,
    *,
    lds_offset: dsl.Value | int = 0,
    dep: dsl.Value | None = None,
) -> tuple[_Mxfp4ScaleLayout, dsl.Value]:
    if coords.a_scale_base is None or coords.b_scale_base is None:
        raise ValueError("MXFP4 scale buffers are required")
    layout = _mxfp4_scale_layout(cfg, coords, step)
    if _use_mxfp4_scale_dma(cfg):
        return layout, _stage_mxfp4_scale_tiles_dma_after_dep(
            bld, cfg, coords, layout, step, lds_offset=lds_offset, dep=dep
        )
    if cfg.use_dma_lds and _use_cta_owned_mxfp4_scale_dma(cfg):
        return layout, _stage_mxfp4_scale_tiles_regs_cta_after_dep(
            bld, cfg, coords, layout, step, lds_offset=lds_offset, dep=dep
        )
    return layout, _stage_mxfp4_scale_tiles_wave_regs_after_dep(
        bld, cfg, coords, layout, lds_offset=lds_offset, dep=dep
    )


def _stage_mxfp4_scale_tiles_wave_regs_after_dep(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    coords: _TileCoords,
    layout: _Mxfp4ScaleLayout,
    *,
    lds_offset: dsl.Value | int,
    dep: dsl.Value | None,
) -> dsl.Value:
    row_sliced = _use_mxfp4_scale_reg_dword_staging(cfg)
    packed_dword = _use_mxfp4_scale_reg_packed_dword_staging(cfg)
    load_width = 4 if row_sliced else 16
    load_type = dsl.simd_type(
        dsl.vector_type(load_width, dsl.i8()), width=cfg.mma.wave_size
    )
    lds = _scale_shared_memory_base(bld, cfg, lds_offset)
    lane_mask = 0 if packed_dword else (12 if row_sliced else 15)
    lane_mod16 = bld.binary(
        dsl.BinaryKind.AndI,
        coords.wi,
        bld.splat(bld.constant(dsl.i32(), lane_mask), width=cfg.mma.wave_size),
    )
    zero = bld.splat(bld.constant(dsl.i32(), 0), width=cfg.mma.wave_size)
    lane_group_mask = bld.cmpi("eq", lane_mod16, zero)

    with bld.where(lane_group_mask, [dsl.mem_token_type()]) as active:
        tokens: list[dsl.Value] = []
        _stage_mxfp4_scale_regs(
            bld,
            cfg,
            coords,
            layout,
            "m",
            load_type,
            lds,
            dep,
            tokens,
            row_sliced,
            packed_dword,
        )
        _stage_mxfp4_scale_regs(
            bld,
            cfg,
            coords,
            layout,
            "n",
            load_type,
            lds,
            dep,
            tokens,
            row_sliced,
            packed_dword,
        )
        bld.yield_([_join_tokens(bld, tokens)])

    return active.results[0]


def _flush_mxfp4_scale_reg_stores(
    bld: dsl.FunctionBuilder,
    loaded: list[tuple[dsl.Value, dsl.Value, dsl.Value]],
    dep: dsl.Value | None,
    tokens: list[dsl.Value],
) -> None:
    if not loaded:
        return
    store_dep = _join_tokens(bld, [tok for _, _, tok in loaded])
    if dep is not None:
        store_dep = bld.join(dep, store_dep)
    tokens.append(
        _join_tokens(
            bld, [bld.store(raw, dest, after=store_dep) for raw, dest, _ in loaded]
        )
    )
    loaded.clear()


def _append_mxfp4_scale_reg_load(
    bld: dsl.FunctionBuilder,
    load_type: dsl.Type,
    loaded: list[tuple[dsl.Value, dsl.Value, dsl.Value]],
    global_base: dsl.Value,
    global_off: dsl.Value,
    shared_memory_base: dsl.Value,
    lds_off: dsl.Value,
) -> None:
    raw, load_token = bld.load(bld.ptr_add(global_base, global_off), load_type)
    loaded.append((raw, bld.ptr_add(shared_memory_base, lds_off), load_token))


def _stage_mxfp4_scale_tiles_regs_cta_after_dep(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    coords: _TileCoords,
    layout: _Mxfp4ScaleLayout,
    step: dsl.Value | int,
    *,
    lds_offset: dsl.Value | int,
    dep: dsl.Value | None,
) -> dsl.Value:
    row_sliced = _use_mxfp4_scale_reg_dword_staging(cfg)
    packed_dword = _use_mxfp4_scale_reg_packed_dword_staging(cfg)
    load_width = 4 if row_sliced else 16
    load_type = dsl.simd_type(
        dsl.vector_type(load_width, dsl.i8()), width=cfg.mma.wave_size
    )
    lds = _scale_shared_memory_base(bld, cfg, lds_offset)
    with bld.where(
        _mxfp4_scale_regs_cta_mask(bld, cfg, coords, "m"),
        [dsl.mem_token_type()],
    ) as active_a:
        a_tokens: list[dsl.Value] = []
        _stage_mxfp4_scale_regs(
            bld,
            cfg,
            coords,
            layout,
            "m",
            load_type,
            lds,
            dep,
            a_tokens,
            row_sliced,
            packed_dword,
        )
        bld.yield_([_join_tokens(bld, a_tokens)])
        with active_a.otherwise():
            bld.yield_([_dep_or_token(bld, dep)])
    with bld.where(
        _mxfp4_scale_regs_cta_mask(bld, cfg, coords, "n"),
        [dsl.mem_token_type()],
    ) as active_b:
        b_tokens: list[dsl.Value] = []
        _stage_mxfp4_scale_regs(
            bld,
            cfg,
            coords,
            layout,
            "n",
            load_type,
            lds,
            dep,
            b_tokens,
            row_sliced,
            packed_dword,
        )
        bld.yield_([_join_tokens(bld, b_tokens)])
        with active_b.otherwise():
            bld.yield_([_dep_or_token(bld, dep)])
    return bld.join(active_a.results[0], active_b.results[0])


def _stage_mxfp4_scale_regs(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    coords: _TileCoords,
    layout: _Mxfp4ScaleLayout,
    axis: _Mxfp4ScaleAxis,
    load_type: dsl.Type,
    lds: dsl.Value,
    dep: dsl.Value | None,
    tokens: list[dsl.Value],
    row_sliced: bool,
    packed_dword: bool,
    loaded: list[tuple[dsl.Value, dsl.Value, dsl.Value]] | None = None,
) -> None:
    local_loaded: list[tuple[dsl.Value, dsl.Value, dsl.Value]] = (
        [] if loaded is None else loaded
    )
    staging_axis = _mxfp4_scale_staging_axis(
        cfg, coords, layout, axis, layout.m_wave, layout.n_wave
    )
    global_base = staging_axis.global_base
    packed_scale_base = staging_axis.packed_scale_base
    unpacked_scale_base = staging_axis.unpacked_scale_base
    tile_base = staging_axis.tile_base
    dimension = staging_axis.dimension
    tile_count = staging_axis.tile_count
    tiles_per_wave = staging_axis.tiles_per_wave
    pack = tile_count % _MXFP4_SCALE_PACK == 0
    if packed_dword:
        for packed_idx in range(tiles_per_wave):
            scale_tile = packed_scale_base + packed_idx
            tile = tile_base + packed_idx * _MXFP4_SCALE_PACK
            row_quad = layout.lane_mod16 * 4
            global_off = bld.index_expr(
                layout.scale_k * dimension + tile * 16 + row_quad,
                bindings=layout.bindings,
            )
            lds_off = bld.index_expr(
                scale_tile * 512 + layout.lane_scale_group * 128 + row_quad,
                bindings=layout.bindings,
            )
            _append_mxfp4_scale_reg_load(
                bld,
                load_type,
                local_loaded,
                global_base,
                global_off,
                lds,
                lds_off,
            )
        if loaded is None:
            _flush_mxfp4_scale_reg_stores(bld, local_loaded, dep, tokens)
        return

    for tile_idx in range(tile_count):
        scale_tile = (
            packed_scale_base + tile_idx // _MXFP4_SCALE_PACK
            if pack
            else unpacked_scale_base + tile_idx
        )
        scale_idx = tile_idx % _MXFP4_SCALE_PACK if pack else 0
        tile = tile_base + tile_idx
        row_quad = layout.lane_mod16 * 4 if row_sliced else 0
        global_off = bld.index_expr(
            layout.scale_k * dimension + tile * 16 + row_quad,
            bindings=layout.bindings,
        )
        lds_off = bld.index_expr(
            scale_tile * 512
            + layout.lane_scale_group * 128
            + scale_idx * 16
            + row_quad,
            bindings=layout.bindings,
        )
        _append_mxfp4_scale_reg_load(
            bld, load_type, local_loaded, global_base, global_off, lds, lds_off
        )
    if loaded is None:
        _flush_mxfp4_scale_reg_stores(bld, local_loaded, dep, tokens)


def _use_batched_mxfp4_scale_regs_cta(cfg: _MatmulConfig) -> bool:
    return (
        cfg.use_dma_lds
        and _use_cta_owned_mxfp4_scale_dma(cfg)
        and _use_mxfp4_scale_reg_packed_dword_staging(cfg)
        and cfg.wave_k_tiles > 1
    )


def _flatten_scale_reg_loads(
    loaded: list[tuple[dsl.Value, dsl.Value, dsl.Value]],
) -> list[dsl.Value]:
    return [value for triple in loaded for value in triple]


def _scale_reg_loads_from_results(
    results: tuple[dsl.Value, ...],
) -> tuple[tuple[dsl.Value, dsl.Value, dsl.Value], ...]:
    if len(results) % 3 != 0:
        raise ValueError("scale-reg load tuple must be raw/dest/token triples")
    return tuple(
        (results[i], results[i + 1], results[i + 2]) for i in range(0, len(results), 3)
    )


def _defer_mxfp4_scale_batch_regs_cta_after_dep(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    coords: _TileCoords,
    scale_step: dsl.Value | int,
    scale_lds_offset: dsl.Value | int,
    *,
    dep: dsl.Value | None,
    barrier_after: bool,
) -> tuple[list[tuple[_Mxfp4ScaleLayout, dsl.Value | int]], _DeferredScaleRegBatch]:
    if not _use_batched_mxfp4_scale_regs_cta(cfg):
        raise ValueError("deferred scale-reg batch requires packed CTA regs staging")
    load_type = dsl.simd_type(dsl.vector_type(4, dsl.i8()), width=cfg.mma.wave_size)
    stride = _mxfp4_scale_lds_stride_dwords(cfg)
    staged: list[tuple[_Mxfp4ScaleLayout, dsl.Value | int]] = []
    for k in range(cfg.wave_k_tiles):
        raw_step = _mxfp4_raw_k_step(bld, cfg, scale_step, k)
        offset = _add_lds_dword_offset(bld, scale_lds_offset, k * stride)
        staged.append((_mxfp4_scale_layout(cfg, coords, raw_step), offset))

    a_tiles_per_wave = _mxfp4_scale_tiles_per_wave(cfg.wave_m_tiles)
    lds_simd_type = dsl.simd_type(
        _scale_shared_memory_base(bld, cfg, scale_lds_offset).type, cfg.mma.wave_size
    )
    load_entry_types = (
        load_type,
        lds_simd_type,
        dsl.mem_token_type(),
    )
    a_result_types = [
        item
        for _ in range(cfg.wave_k_tiles * a_tiles_per_wave)
        for item in load_entry_types
    ]
    a_mask = _mxfp4_scale_regs_cta_mask(bld, cfg, coords, "m")
    with bld.where(a_mask, a_result_types) as active_a:
        a_loaded: list[tuple[dsl.Value, dsl.Value, dsl.Value]] = []
        for layout, offset in staged:
            _stage_mxfp4_scale_regs(
                bld,
                cfg,
                coords,
                layout,
                "m",
                load_type,
                _scale_shared_memory_base(bld, cfg, offset),
                dep,
                [],
                row_sliced=True,
                packed_dword=True,
                loaded=a_loaded,
            )
        bld.yield_(_flatten_scale_reg_loads(a_loaded))

    b_tiles_per_wave = _mxfp4_scale_tiles_per_wave(cfg.wave_n_tiles)
    b_result_types = [
        item
        for _ in range(cfg.wave_k_tiles * b_tiles_per_wave)
        for item in load_entry_types
    ]
    b_mask = _mxfp4_scale_regs_cta_mask(bld, cfg, coords, "n")
    with bld.where(b_mask, b_result_types) as active_b:
        b_loaded: list[tuple[dsl.Value, dsl.Value, dsl.Value]] = []
        for layout, offset in staged:
            _stage_mxfp4_scale_regs(
                bld,
                cfg,
                coords,
                layout,
                "n",
                load_type,
                _scale_shared_memory_base(bld, cfg, offset),
                dep,
                [],
                row_sliced=True,
                packed_dword=True,
                loaded=b_loaded,
            )
        bld.yield_(_flatten_scale_reg_loads(b_loaded))

    return staged, _DeferredScaleRegBatch(
        a_mask=a_mask,
        b_mask=b_mask,
        a_loaded=_scale_reg_loads_from_results(tuple(active_a.results)),
        b_loaded=_scale_reg_loads_from_results(tuple(active_b.results)),
        dep=dep,
        barrier_after=barrier_after,
    )


def _flush_deferred_mxfp4_scale_reg_batch(
    bld: dsl.FunctionBuilder, batch: _DeferredScaleRegBatch
) -> dsl.Value:
    with bld.where(batch.a_mask, [dsl.mem_token_type()]) as active_a:
        a_tokens: list[dsl.Value] = []
        _flush_mxfp4_scale_reg_stores(bld, list(batch.a_loaded), batch.dep, a_tokens)
        bld.yield_([_join_tokens(bld, a_tokens)])
        with active_a.otherwise():
            bld.yield_([_dep_or_token(bld, batch.dep)])
    with bld.where(batch.b_mask, [dsl.mem_token_type()]) as active_b:
        b_tokens: list[dsl.Value] = []
        _flush_mxfp4_scale_reg_stores(bld, list(batch.b_loaded), batch.dep, b_tokens)
        bld.yield_([_join_tokens(bld, b_tokens)])
        with active_b.otherwise():
            bld.yield_([_dep_or_token(bld, batch.dep)])
    token = bld.join(active_a.results[0], active_b.results[0])
    return bld.barrier(token) if batch.barrier_after else token


def _stage_mxfp4_scale_batch_regs_cta_after_dep(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    coords: _TileCoords,
    scale_step: dsl.Value | int,
    scale_lds_offset: dsl.Value | int,
    *,
    dep: dsl.Value | None,
    barrier_after: bool,
) -> tuple[list[tuple[_Mxfp4ScaleLayout, dsl.Value | int]], dsl.Value]:
    row_sliced = _use_mxfp4_scale_reg_dword_staging(cfg)
    packed_dword = _use_mxfp4_scale_reg_packed_dword_staging(cfg)
    load_width = 4 if row_sliced else 16
    load_type = dsl.simd_type(
        dsl.vector_type(load_width, dsl.i8()), width=cfg.mma.wave_size
    )
    stride = _mxfp4_scale_lds_stride_dwords(cfg)
    staged: list[tuple[_Mxfp4ScaleLayout, dsl.Value | int]] = []
    for k in range(cfg.wave_k_tiles):
        raw_step = _mxfp4_raw_k_step(bld, cfg, scale_step, k)
        offset = _add_lds_dword_offset(bld, scale_lds_offset, k * stride)
        staged.append((_mxfp4_scale_layout(cfg, coords, raw_step), offset))
    with bld.where(
        _mxfp4_scale_regs_cta_mask(bld, cfg, coords, "m"),
        [dsl.mem_token_type()],
    ) as active_a:
        a_tokens: list[dsl.Value] = []
        a_loaded: list[tuple[dsl.Value, dsl.Value, dsl.Value]] = []
        for layout, offset in staged:
            _stage_mxfp4_scale_regs(
                bld,
                cfg,
                coords,
                layout,
                "m",
                load_type,
                _scale_shared_memory_base(bld, cfg, offset),
                dep,
                a_tokens,
                row_sliced,
                packed_dword,
                loaded=a_loaded,
            )
        _flush_mxfp4_scale_reg_stores(bld, a_loaded, dep, a_tokens)
        bld.yield_([_join_tokens(bld, a_tokens)])
        with active_a.otherwise():
            bld.yield_([_dep_or_token(bld, dep)])
    with bld.where(
        _mxfp4_scale_regs_cta_mask(bld, cfg, coords, "n"),
        [dsl.mem_token_type()],
    ) as active_b:
        b_tokens: list[dsl.Value] = []
        b_loaded: list[tuple[dsl.Value, dsl.Value, dsl.Value]] = []
        for layout, offset in staged:
            _stage_mxfp4_scale_regs(
                bld,
                cfg,
                coords,
                layout,
                "n",
                load_type,
                _scale_shared_memory_base(bld, cfg, offset),
                dep,
                b_tokens,
                row_sliced,
                packed_dword,
                loaded=b_loaded,
            )
        _flush_mxfp4_scale_reg_stores(bld, b_loaded, dep, b_tokens)
        bld.yield_([_join_tokens(bld, b_tokens)])
        with active_b.otherwise():
            bld.yield_([_dep_or_token(bld, dep)])
    token = bld.join(active_a.results[0], active_b.results[0])
    return staged, bld.barrier(token) if barrier_after else token


def _use_mxfp4_delayed_b_scale_lw(cfg: _MatmulConfig) -> bool:
    return (
        _use_mxfp4_regional_scale_read_step(cfg)
        and _use_mxfp4_scale_reg_packed_dword_staging(cfg)
        and cfg.BM == 1
        and cfg.wave_k_tiles == 1
        and _mxfp4_scale_tiles_per_wave(cfg.wave_n_tiles) == 1
    )


def _stage_mxfp4_b_scale_reg_load_deferred(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    coords: _TileCoords,
    layout: _Mxfp4ScaleLayout,
    load_type: dsl.Type,
    lds: dsl.Value,
) -> tuple[dsl.Value, dsl.Value, dsl.Value]:
    a_tiles_per_wave = _mxfp4_scale_tiles_per_wave(cfg.wave_m_tiles)
    b_scale_base = cfg.BM * a_tiles_per_wave
    scale_tile = b_scale_base + layout.n_wave
    n_tile = (
        layout.wg_n * (cfg.BN * cfg.wave_n_tiles) + layout.n_wave * cfg.wave_n_tiles
    )
    row_quad = layout.lane_mod16 * 4
    global_off = bld.index_expr(
        layout.scale_k * cfg.N + n_tile * 16 + row_quad,
        bindings=layout.bindings,
    )
    lds_off = bld.index_expr(
        scale_tile * 512 + layout.lane_scale_group * 128 + row_quad,
        bindings=layout.bindings,
    )
    raw, load_token = bld.load(bld.ptr_add(coords.b_scale_base, global_off), load_type)
    return raw, bld.ptr_add(lds, lds_off), load_token


def _flush_deferred_mxfp4_scale_store(
    bld: dsl.FunctionBuilder,
    store: _DeferredScaleStore,
) -> dsl.Value:
    deps = [store.load_token]
    if store.dep is not None:
        deps.append(store.dep)
    return bld.store(store.raw, store.dest, after=_join_tokens(bld, deps))


def _stage_mxfp4_scale_tiles_dma_after_dep(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    coords: _TileCoords,
    layout: _Mxfp4ScaleLayout,
    step: dsl.Value | int,
    *,
    lds_offset: dsl.Value | int,
    dep: dsl.Value | None,
) -> dsl.Value:
    plan = _mxfp4_scale_dma_plan(bld, cfg, coords, layout, step, lds_offset, dep)
    if not _use_cta_owned_mxfp4_scale_dma(cfg):
        with bld.where(
            _mxfp4_scale_dma_lane_mask(bld, cfg, coords), [dsl.mem_token_type()]
        ) as active:
            tokens: list[dsl.Value] = []
            _stage_mxfp4_scale_dma(bld, cfg, coords, layout, plan, "m", tokens)
            _stage_mxfp4_scale_dma(bld, cfg, coords, layout, plan, "n", tokens)
            bld.yield_([_join_tokens(bld, tokens)])
        return active.results[0]

    with bld.where(
        _mxfp4_scale_dma_mask(bld, cfg, coords, "m"),
        [dsl.mem_token_type()],
    ) as active_a:
        a_tokens: list[dsl.Value] = []
        _stage_mxfp4_scale_dma(bld, cfg, coords, layout, plan, "m", a_tokens)
        bld.yield_([_join_tokens(bld, a_tokens)])
        with active_a.otherwise():
            bld.yield_([_dep_or_token(bld, dep)])
    with bld.where(
        _mxfp4_scale_dma_mask(bld, cfg, coords, "n"),
        [dsl.mem_token_type()],
    ) as active_b:
        b_tokens: list[dsl.Value] = []
        _stage_mxfp4_scale_dma(bld, cfg, coords, layout, plan, "n", b_tokens)
        bld.yield_([_join_tokens(bld, b_tokens)])
        with active_b.otherwise():
            bld.yield_([_dep_or_token(bld, dep)])
    return bld.join(active_a.results[0], active_b.results[0])


def _use_cta_owned_mxfp4_scale_dma(cfg: _MatmulConfig) -> bool:
    return cfg.virtual_k_steps > 1


def _use_mxfp4_scale_reg_dword_staging(cfg: _MatmulConfig) -> bool:
    return cfg.mxfp4_scale_path == "regs" and cfg.target_waves == 1


def _use_mxfp4_scale_reg_packed_dword_staging(cfg: _MatmulConfig) -> bool:
    return (
        _use_mxfp4_scale_reg_dword_staging(cfg)
        and cfg.wave_m_tiles % _MXFP4_SCALE_PACK == 0
        and cfg.wave_n_tiles % _MXFP4_SCALE_PACK == 0
    )


def _mxfp4_scale_dma_wave_id(
    bld: dsl.FunctionBuilder, cfg: _MatmulConfig, coords: _TileCoords
) -> dsl.Value:
    return bld.binary(
        dsl.BinaryKind.ShRUI,
        coords.wi,
        bld.splat(
            bld.constant(dsl.i32(), cfg.mma.wave_size.bit_length() - 1),
            width=cfg.mma.wave_size,
        ),
    )


def _mxfp4_scale_dma_plan(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    coords: _TileCoords,
    layout: _Mxfp4ScaleLayout,
    step: dsl.Value | int,
    lds_offset: dsl.Value | int,
    dep: dsl.Value | None,
) -> _Mxfp4ScaleDmaPlan:
    wi_first = dsl.sym("wi_first")
    first_bindings = {wi_first: bld.read_first(coords.wi)}
    wave_id = dsl.floor(wi_first / cfg.mma.wave_size)
    m_wave = dsl.floor(wave_id / cfg.BN)
    n_wave = dsl.mod(wave_id, cfg.BN)
    dma_scale_group = dsl.floor(layout.lane / 8)
    bindings = dict(layout.bindings)
    bindings.update(first_bindings)
    if isinstance(step, int):
        scale_k = step * (cfg.mma.k_tile // 32) + dma_scale_group
    else:
        step_sym = dsl.sym("dma_scale_step")
        bindings[step_sym] = step
        scale_k = step_sym * (cfg.mma.k_tile // 32) + dma_scale_group
    lds = bld.shared_memory_base(dsl.i32(), offset=cfg.data_lds_bytes)
    return _Mxfp4ScaleDmaPlan(
        bindings=bindings,
        first_bindings=first_bindings,
        m_wave=m_wave,
        n_wave=n_wave,
        scale_k=scale_k,
        lds=lds,
        lds_offset=lds_offset,
        dep=dep,
    )


def _mxfp4_scale_owner_mask(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    coords: _TileCoords,
    axis: _Mxfp4ScaleAxis,
    lane_mask: int,
) -> dsl.Value:
    if axis == "m":
        owner_kind = dsl.BinaryKind.AndI
        owner_arg = cfg.BN - 1
    else:
        owner_kind = dsl.BinaryKind.ShRUI
        owner_arg = cfg.log2_BN
    wave_id = _mxfp4_scale_dma_wave_id(bld, cfg, coords)
    owner_value = bld.binary(
        owner_kind,
        wave_id,
        bld.splat(bld.constant(dsl.i32(), owner_arg), width=cfg.mma.wave_size),
    )
    lane_value = bld.binary(
        dsl.BinaryKind.AndI,
        coords.wi,
        bld.splat(bld.constant(dsl.i32(), lane_mask), width=cfg.mma.wave_size),
    )
    active_value = bld.binary(dsl.BinaryKind.OrI, lane_value, owner_value)
    zero = bld.splat(bld.constant(dsl.i32(), 0), width=cfg.mma.wave_size)
    return bld.cmpi("eq", active_value, zero)


def _mxfp4_scale_dma_mask(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    coords: _TileCoords,
    axis: _Mxfp4ScaleAxis,
) -> dsl.Value:
    return _mxfp4_scale_owner_mask(bld, cfg, coords, axis, 39)


def _mxfp4_scale_regs_cta_mask(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    coords: _TileCoords,
    axis: _Mxfp4ScaleAxis,
) -> dsl.Value:
    if _use_mxfp4_scale_reg_packed_dword_staging(cfg):
        lane_mask = 0
    else:
        lane_mask = 12 if _use_mxfp4_scale_reg_dword_staging(cfg) else 15
    return _mxfp4_scale_owner_mask(bld, cfg, coords, axis, lane_mask)


def _mxfp4_scale_dma_lane_mask(
    bld: dsl.FunctionBuilder, cfg: _MatmulConfig, coords: _TileCoords
) -> dsl.Value:
    lane_dma = bld.binary(
        dsl.BinaryKind.AndI,
        coords.wi,
        bld.splat(bld.constant(dsl.i32(), 39), width=cfg.mma.wave_size),
    )
    zero = bld.splat(bld.constant(dsl.i32(), 0), width=cfg.mma.wave_size)
    return bld.cmpi("eq", lane_dma, zero)


def _mxfp4_scale_dma_dest(
    bld: dsl.FunctionBuilder, plan: _Mxfp4ScaleDmaPlan, base_dwords: dsl.Value | int
) -> dsl.Value:
    if isinstance(plan.lds_offset, int):
        offset = base_dwords
        if plan.lds_offset != 0:
            if isinstance(base_dwords, int):
                offset = base_dwords + plan.lds_offset
            else:
                base = dsl.sym("scale_dma_dest")
                offset = bld.index_expr(
                    base + plan.lds_offset, bindings={base: base_dwords}
                )
    elif isinstance(base_dwords, int):
        offset = _add_lds_dword_offset(bld, plan.lds_offset, base_dwords)
    else:
        base = dsl.sym("scale_dma_dest")
        dyn = dsl.sym("scale_dma_buffer")
        offset = bld.index_expr(
            base + dyn, bindings={base: base_dwords, dyn: plan.lds_offset}
        )
    if isinstance(offset, int):
        return _ptr_add_const(bld, plan.lds, offset)
    return bld.ptr_add(plan.lds, offset)


def _append_mxfp4_scale_dma(
    bld: dsl.FunctionBuilder,
    plan: _Mxfp4ScaleDmaPlan,
    tokens: list[dsl.Value],
    global_base: dsl.Value,
    global_off: dsl.Value,
    lds_off: dsl.Value,
) -> None:
    source = bld.ptr_add(global_base, global_off)
    after = plan.dep if plan.dep is not None else bld.token()
    tokens.append(bld.dma_load_lds(source, lds_off, after=after, bytes=16))


def _stage_mxfp4_scale_dma(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    coords: _TileCoords,
    layout: _Mxfp4ScaleLayout,
    plan: _Mxfp4ScaleDmaPlan,
    axis: _Mxfp4ScaleAxis,
    tokens: list[dsl.Value],
) -> None:
    staging_axis = _mxfp4_scale_staging_axis(
        cfg, coords, layout, axis, plan.m_wave, plan.n_wave
    )
    global_base = staging_axis.global_base
    packed_scale_base = staging_axis.packed_scale_base
    unpacked_scale_base = staging_axis.unpacked_scale_base
    tile_base = staging_axis.tile_base
    dimension = staging_axis.dimension
    tile_count = staging_axis.tile_count
    pack = tile_count % _MXFP4_SCALE_PACK == 0
    for tile_idx in range(tile_count):
        scale_tile = (
            packed_scale_base + tile_idx // _MXFP4_SCALE_PACK
            if pack
            else unpacked_scale_base + tile_idx
        )
        scale_idx = tile_idx % _MXFP4_SCALE_PACK if pack else 0
        tile = tile_base + tile_idx
        global_off = bld.index_expr(
            plan.scale_k * dimension + tile * 16, bindings=plan.bindings
        )
        lds_off = bld.index_expr(
            scale_tile * 128 + scale_idx * 4,
            bindings=plan.first_bindings,
        )
        _append_mxfp4_scale_dma(
            bld,
            plan,
            tokens,
            global_base,
            global_off,
            _mxfp4_scale_dma_dest(bld, plan, lds_off),
        )


def _stage_mxfp4_scale_tiles(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    coords: _TileCoords,
    step: dsl.Value | int,
    *,
    lds_offset: dsl.Value | int = 0,
    after: dsl.Value | None = None,
) -> tuple[_Mxfp4ScaleLayout, dsl.Value]:
    dep = bld.barrier(after) if after is not None else None
    layout, token = _stage_mxfp4_scale_tiles_after_dep(
        bld, cfg, coords, step, lds_offset=lds_offset, dep=dep
    )
    return layout, bld.barrier(token)


def _read_mxfp4_scale_tile(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    layout: _Mxfp4ScaleLayout,
    tile: int | dsl.Expr,
    ready_token: dsl.Value,
    *,
    lds_offset: dsl.Value | int = 0,
) -> tuple[dsl.Value, dsl.Value]:
    lds = _scale_shared_memory_base(bld, cfg, lds_offset)
    load_type = dsl.simd_type(dsl.vector_type(8, dsl.i8()), width=cfg.mma.wave_size)
    item = dsl.sym("item")
    slot = dsl.sym("slot")
    if isinstance(tile, dsl.Expr):
        tile = tile.subs({dsl.sym("wi"): item})
    lane = dsl.mod(item, cfg.mma.wave_size)
    byte_offset = (
        tile * 512
        + dsl.floor(lane / 16) * 128
        + dsl.mod(item, 16) * 4
        + dsl.floor(slot / 2)
    )
    value, token = bld.gather(
        lds,
        load_type,
        bit_offset=byte_offset * 8,
        bindings=layout.bindings,
        after=ready_token,
    )
    return value, token


def _read_mxfp4_scale_set(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    layout: _Mxfp4ScaleLayout,
    base_tile: int | dsl.Expr,
    tile_count: int,
    ready_token: dsl.Value,
    lds_offset: dsl.Value | int,
) -> tuple[list[dsl.Value], list[int], list[dsl.Value]]:
    pack = tile_count % _MXFP4_SCALE_PACK == 0
    packed_count = _mxfp4_scale_tiles_per_wave(tile_count)
    packed_scales: list[dsl.Value] = []
    tokens: list[dsl.Value] = []
    for i in range(packed_count):
        scale, token = _read_mxfp4_scale_tile(
            bld, cfg, layout, base_tile + i, ready_token, lds_offset=lds_offset
        )
        packed_scales.append(scale)
        tokens.append(token)
    scales = [
        packed_scales[i // _MXFP4_SCALE_PACK] if pack else packed_scales[i]
        for i in range(tile_count)
    ]
    scale_idxs = [i % _MXFP4_SCALE_PACK if pack else 0 for i in range(tile_count)]
    return scales, scale_idxs, tokens


def _read_mxfp4_b_scale_set_slice(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    layout: _Mxfp4ScaleLayout,
    base_tile: int | dsl.Expr,
    n_begin: int,
    n_end: int,
    ready_token: dsl.Value,
    lds_offset: dsl.Value | int,
) -> tuple[list[dsl.Value], list[int], list[dsl.Value]]:
    pack = cfg.wave_n_tiles % _MXFP4_SCALE_PACK == 0
    if pack:
        packed_begin = n_begin // _MXFP4_SCALE_PACK
        packed_end = (n_end + _MXFP4_SCALE_PACK - 1) // _MXFP4_SCALE_PACK
    else:
        packed_begin = n_begin
        packed_end = n_end
    packed_scales: dict[int, dsl.Value] = {}
    tokens: list[dsl.Value] = []
    for packed_idx in range(packed_begin, packed_end):
        scale, token = _read_mxfp4_scale_tile(
            bld,
            cfg,
            layout,
            base_tile + packed_idx,
            ready_token,
            lds_offset=lds_offset,
        )
        packed_scales[packed_idx] = scale
        tokens.append(token)

    first_scale = packed_scales[packed_begin]
    scales = [first_scale for _ in range(cfg.wave_n_tiles)]
    scale_idxs = [0 for _ in range(cfg.wave_n_tiles)]
    for j in range(n_begin, n_end):
        packed_idx = j // _MXFP4_SCALE_PACK if pack else j
        scales[j] = packed_scales[packed_idx]
        scale_idxs[j] = j % _MXFP4_SCALE_PACK if pack else 0
    return scales, scale_idxs, tokens


def _stage_read_mxfp4_scales(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    coords: _TileCoords,
    scale_step: dsl.Value | int,
    scale_lds_offset: dsl.Value | int,
    scale_after: dsl.Value | None,
) -> _Mxfp4ScaleSet:
    layout, scale_token = _stage_mxfp4_scale_tiles(
        bld,
        cfg,
        coords,
        scale_step,
        lds_offset=scale_lds_offset,
        after=scale_after,
    )
    return _read_mxfp4_scales_from_layout(
        bld, cfg, layout, scale_lds_offset, scale_token
    )


def _read_mxfp4_scales_from_layout_slice(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    layout: _Mxfp4ScaleLayout,
    scale_lds_offset: dsl.Value | int,
    scale_token: dsl.Value,
    n_begin: int,
    n_end: int,
) -> _Mxfp4ScaleSet:
    a_tiles_per_wave = _mxfp4_scale_tiles_per_wave(cfg.wave_m_tiles)
    b_tiles_per_wave = _mxfp4_scale_tiles_per_wave(cfg.wave_n_tiles)
    a_scales, a_scale_idxs, a_tokens = _read_mxfp4_scale_set(
        bld,
        cfg,
        layout,
        layout.m_wave * a_tiles_per_wave,
        cfg.wave_m_tiles,
        scale_token,
        scale_lds_offset,
    )
    b_scales, b_scale_idxs, b_tokens = _read_mxfp4_b_scale_set_slice(
        bld,
        cfg,
        layout,
        cfg.BM * a_tiles_per_wave + layout.n_wave * b_tiles_per_wave,
        n_begin,
        n_end,
        scale_token,
        scale_lds_offset,
    )
    return _Mxfp4ScaleSet(
        a_scales=a_scales,
        a_scale_idxs=a_scale_idxs,
        b_scales=b_scales,
        b_scale_idxs=b_scale_idxs,
        token=_join_tokens(bld, [*a_tokens, *b_tokens]),
    )


def _read_mxfp4_scales_from_layout(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    layout: _Mxfp4ScaleLayout,
    scale_lds_offset: dsl.Value | int,
    scale_token: dsl.Value,
) -> _Mxfp4ScaleSet:
    a_tiles_per_wave = _mxfp4_scale_tiles_per_wave(cfg.wave_m_tiles)
    b_tiles_per_wave = _mxfp4_scale_tiles_per_wave(cfg.wave_n_tiles)
    a_scales, a_scale_idxs, a_tokens = _read_mxfp4_scale_set(
        bld,
        cfg,
        layout,
        layout.m_wave * a_tiles_per_wave,
        cfg.wave_m_tiles,
        scale_token,
        scale_lds_offset,
    )
    b_scales, b_scale_idxs, b_tokens = _read_mxfp4_scale_set(
        bld,
        cfg,
        layout,
        cfg.BM * a_tiles_per_wave + layout.n_wave * b_tiles_per_wave,
        cfg.wave_n_tiles,
        scale_token,
        scale_lds_offset,
    )
    return _Mxfp4ScaleSet(
        a_scales=a_scales,
        a_scale_idxs=a_scale_idxs,
        b_scales=b_scales,
        b_scale_idxs=b_scale_idxs,
        token=_join_tokens(bld, [*a_tokens, *b_tokens]),
    )


def _stage_mxfp4_scale_batch(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    coords: _TileCoords,
    scale_step: dsl.Value | int,
    scale_lds_offset: dsl.Value | int,
    scale_after: dsl.Value | None,
    *,
    barrier_after: bool = True,
    barrier_before: bool = True,
) -> tuple[list[tuple[_Mxfp4ScaleLayout, dsl.Value | int]], dsl.Value]:
    if scale_after is None:
        dep = None
    elif barrier_before:
        dep = bld.barrier(scale_after)
    else:
        dep = scale_after
    if _use_batched_mxfp4_scale_regs_cta(cfg):
        return _stage_mxfp4_scale_batch_regs_cta_after_dep(
            bld,
            cfg,
            coords,
            scale_step,
            scale_lds_offset,
            dep=dep,
            barrier_after=barrier_after,
        )
    stride = _mxfp4_scale_lds_stride_dwords(cfg)
    staged: list[tuple[_Mxfp4ScaleLayout, dsl.Value | int]] = []
    tokens: list[dsl.Value] = []
    for k in range(cfg.wave_k_tiles):
        raw_step = _mxfp4_raw_k_step(bld, cfg, scale_step, k)
        offset = _add_lds_dword_offset(bld, scale_lds_offset, k * stride)
        layout, token = _stage_mxfp4_scale_tiles_after_dep(
            bld, cfg, coords, raw_step, lds_offset=offset, dep=dep
        )
        staged.append((layout, offset))
        tokens.append(token)
    token = _join_tokens(bld, tokens)
    return staged, bld.barrier(token) if barrier_after else token


def _stage_mxfp4_scale_batch_delayed_b_lw(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    coords: _TileCoords,
    scale_step: dsl.Value | int,
    scale_lds_offset: dsl.Value | int,
    scale_after: dsl.Value,
    *,
    barrier_before: bool = True,
) -> tuple[dsl.Value, _DeferredScaleStore]:
    if not _use_mxfp4_delayed_b_scale_lw(cfg):
        raise ValueError("delayed B-scale LW requires packed k1 regs scale staging")
    dep = bld.barrier(scale_after) if barrier_before else scale_after
    raw_step = _mxfp4_raw_k_step(bld, cfg, scale_step, 0)
    layout = _mxfp4_scale_layout(cfg, coords, raw_step)
    lds = _scale_shared_memory_base(bld, cfg, scale_lds_offset)
    load_type = dsl.simd_type(dsl.vector_type(4, dsl.i8()), width=cfg.mma.wave_size)
    with bld.where(
        _mxfp4_scale_regs_cta_mask(bld, cfg, coords, "m"),
        [dsl.mem_token_type()],
    ) as active_a:
        a_tokens: list[dsl.Value] = []
        _stage_mxfp4_scale_regs(
            bld,
            cfg,
            coords,
            layout,
            "m",
            load_type,
            lds,
            dep,
            a_tokens,
            row_sliced=True,
            packed_dword=True,
        )
        bld.yield_([_join_tokens(bld, a_tokens)])
        with active_a.otherwise():
            bld.yield_([dep])
    raw, dest, load_token = _stage_mxfp4_b_scale_reg_load_deferred(
        bld, cfg, coords, layout, load_type, lds
    )
    return active_a.results[0], _DeferredScaleStore(
        raw=raw,
        dest=dest,
        load_token=load_token,
        dep=dep,
    )


def _read_mxfp4_scale_batch(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    coords: _TileCoords,
    scale_step: dsl.Value | int,
    scale_lds_offset: dsl.Value | int,
    ready_token: dsl.Value,
) -> tuple[list[tuple[int, _Mxfp4ScaleSet]], dsl.Value]:
    ready_token = bld.barrier(ready_token)
    stride = _mxfp4_scale_lds_stride_dwords(cfg)
    scales: list[tuple[int, _Mxfp4ScaleSet]] = []
    tokens: list[dsl.Value] = []
    for k in range(cfg.wave_k_tiles):
        raw_step = _mxfp4_raw_k_step(bld, cfg, scale_step, k)
        offset = _add_lds_dword_offset(bld, scale_lds_offset, k * stride)
        layout = _mxfp4_scale_layout(cfg, coords, raw_step)
        scale_set = _read_mxfp4_scales_from_layout(
            bld, cfg, layout, offset, ready_token
        )
        scales.append((k, scale_set))
        tokens.append(scale_set.token)
    return scales, _join_tokens(bld, tokens)


def _read_mxfp4_scale_batch_region(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    coords: _TileCoords,
    scale_step: dsl.Value | int,
    scale_lds_offset: dsl.Value | int,
    ready_token: dsl.Value,
    n_begin: int,
    n_end: int,
    *,
    include_a: bool,
    a_scale_sets: list[tuple[int, _Mxfp4ScaleSet]] | None = None,
    barrier_before_read: bool = True,
) -> tuple[list[tuple[int, _Mxfp4ScaleSet]], dsl.Value]:
    if barrier_before_read:
        ready_token = bld.barrier(ready_token)
    stride = _mxfp4_scale_lds_stride_dwords(cfg)
    scale_sets: list[tuple[int, _Mxfp4ScaleSet]] = []
    tokens: list[dsl.Value] = []
    for k in range(cfg.wave_k_tiles):
        raw_step = _mxfp4_raw_k_step(bld, cfg, scale_step, k)
        offset = _add_lds_dword_offset(bld, scale_lds_offset, k * stride)
        layout = _mxfp4_scale_layout(cfg, coords, raw_step)
        if include_a:
            scale_set = _read_mxfp4_scales_from_layout_slice(
                bld, cfg, layout, offset, ready_token, n_begin, n_end
            )
        else:
            if a_scale_sets is None:
                raise ValueError("right MXFP4 scale region needs A scales")
            a_scale_set = a_scale_sets[k][1]
            a_tiles_per_wave = _mxfp4_scale_tiles_per_wave(cfg.wave_m_tiles)
            b_tiles_per_wave = _mxfp4_scale_tiles_per_wave(cfg.wave_n_tiles)
            b_scales, b_scale_idxs, b_tokens = _read_mxfp4_b_scale_set_slice(
                bld,
                cfg,
                layout,
                cfg.BM * a_tiles_per_wave + layout.n_wave * b_tiles_per_wave,
                n_begin,
                n_end,
                ready_token,
                offset,
            )
            scale_set = _Mxfp4ScaleSet(
                a_scales=a_scale_set.a_scales,
                a_scale_idxs=a_scale_set.a_scale_idxs,
                b_scales=b_scales,
                b_scale_idxs=b_scale_idxs,
                token=_join_tokens(bld, b_tokens),
            )
        scale_sets.append((k, scale_set))
        tokens.append(scale_set.token)
    return scale_sets, _join_tokens(bld, tokens)


def _mxfp4_raw_k_step(
    bld: dsl.FunctionBuilder, cfg: _MatmulConfig, step: dsl.Value | int, k: int
) -> dsl.Value | int:
    if cfg.wave_k_tiles == 1 and k == 0:
        return step
    if isinstance(step, int):
        return step * cfg.wave_k_tiles + k
    step_sym = dsl.sym("__wave_dsl_mxfp4_step")
    raw_step = step_sym * cfg.wave_k_tiles + k
    return bld.index_expr(
        raw_step,
        {step_sym: step},
    )


def _initial_scale_state(
    bld: dsl.FunctionBuilder, cfg: _MatmulConfig, coords: _TileCoords
) -> tuple[dsl.Value | None, dsl.Value | None]:
    if not cfg.uses_packed_mxfp4:
        return None, None
    _, scale_token = _stage_mxfp4_scale_batch(
        bld,
        cfg,
        coords,
        0,
        _scale_buffer_offset(bld, cfg, 0),
        None,
        barrier_after=False,
    )
    if cfg.virtual_k_steps <= 1:
        return scale_token, None
    _, next_scale_token = _stage_mxfp4_scale_batch(
        bld,
        cfg,
        coords,
        1,
        _scale_buffer_offset(bld, cfg, 1),
        None,
        barrier_after=False,
    )
    return scale_token, next_scale_token


def _initial_dma_load_state(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    types: _KernelTypes,
    staging: _LdsStaging,
    coords: _TileCoords,
    a0: tuple[dsl.Value, ...],
    b0: tuple[dsl.Value, ...],
    virtual_k_stride: dsl.Value,
) -> _InitialLoadState:
    dma_tokens = _dma_issue(bld, cfg, a0, b0, staging, lds_offset=0, in_loop=False)
    scale_token, next_scale_token = _initial_scale_state(bld, cfg, coords)
    ready_token = None
    if cfg.virtual_k_steps > 1:
        a1 = _advance_ptrs(bld, a0, virtual_k_stride)
        b1 = _advance_ptrs(bld, b0, virtual_k_stride)
        ready_token = _join_tokens(
            bld,
            _dma_issue(
                bld,
                cfg,
                a1,
                b1,
                staging,
                lds_offset=_dma_buffer_offset(bld, cfg, 1),
                in_loop=False,
                request_offset=len(a0) + len(b0),
            ),
        )
    a_frags, b_frags, reuse_token = _dma_drain(
        bld, _join_tokens(bld, dma_tokens), types.a, types.b, staging, lds_offset=0
    )
    return _InitialLoadState(
        a_frags,
        b_frags,
        ready_token,
        reuse_token,
        scale_token,
        next_scale_token,
    )


def _initial_load_state(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    types: _KernelTypes,
    staging: _LdsStaging,
    coords: _TileCoords,
    ptrs: _TilePtrs,
    virtual_k_stride: dsl.Value,
) -> _InitialLoadState:
    a0 = staging.a_dma_src_ptrs if cfg.use_dma_lds else ptrs.a0
    b0 = staging.b_dma_src_ptrs if cfg.use_dma_lds else ptrs.b0
    if cfg.use_dma_lds:
        return _initial_dma_load_state(
            bld, cfg, types, staging, coords, a0, b0, virtual_k_stride
        )
    a_frags, b_frags, reuse_token = _load_fragment_group(
        bld, cfg, a0, b0, types, staging
    )
    return _InitialLoadState(a_frags, b_frags, None, reuse_token)


def _initial_loop_token_args(
    cfg: _MatmulConfig, loads: _InitialLoadState
) -> tuple[dsl.Value, ...]:
    args: list[dsl.Value] = []
    if loads.ready_token is not None:
        args.append(loads.ready_token)
    if cfg.uses_packed_mxfp4 or (cfg.use_dma_lds and cfg.virtual_k_steps > 1):
        args.append(loads.reuse_token)
    if cfg.use_dma_lds and cfg.uses_packed_mxfp4:
        assert loads.scale_token is not None
        args.append(loads.scale_token)
        if cfg.virtual_k_steps > 1:
            assert loads.next_scale_token is not None
            args.append(loads.next_scale_token)
    return tuple(args)


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
    loads = _initial_load_state(
        bld, cfg, types, staging, coords, ptrs, virtual_k_stride
    )
    init_accs = tuple(init_acc for _ in range(cfg.tiles_per_wave))
    wave_k = bld.static_param("wave_k_tiles", IndexType.get())
    a_pt = _pack_frags_into_nested_parametric_ptuple(
        bld, loads.a_frags, cfg.wave_m_tiles, cfg.wave_k_tiles, wave_k
    )
    b_pt = _pack_frags_into_nested_parametric_ptuple(
        bld, loads.b_frags, cfg.wave_n_tiles, cfg.wave_k_tiles, wave_k
    )
    return (
        *init_accs,
        a_pt,
        b_pt,
        *_initial_loop_token_args(cfg, loads),
    )


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
        cursor += 1
    scale_token = None
    next_scale_token = None
    if cfg.use_dma_lds and cfg.uses_packed_mxfp4:
        scale_token = values[cursor]
        cursor += 1
        if cfg.virtual_k_steps > 1:
            next_scale_token = values[cursor]
            cursor += 1
    return _LoopState(
        accs=values[:acc_end],
        afs=(values[acc_end],),
        bfs=(values[acc_end + 1],),
        dma_token=dma_token,
        reuse_token=reuse_token,
        scale_token=scale_token,
        next_scale_token=next_scale_token,
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
    scale_ready_token: dsl.Value | None,
) -> tuple[dsl.Value, ...]:
    if scale_ready_token is not None:
        if scale_after is not None:
            scale_ready_token = _join_tokens(bld, [scale_ready_token, scale_after])
        scale_sets, token = _read_mxfp4_scale_batch(
            bld, cfg, coords, scale_step, scale_lds_offset, scale_ready_token
        )
        if scale_tokens is not None:
            scale_tokens.append(token)
        return _emit_mxfp4_mma_grid_scale_sets(bld, cfg, afs, bfs, accs, scale_sets)

    if cfg.use_dma_lds and cfg.wave_k_tiles > 1:
        return _emit_mxfp4_mma_grid_staged(
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

    return _emit_mxfp4_mma_grid_inline(
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


def _emit_mxfp4_mma_grid_staged(
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
    staged_scales, ready_token = _stage_mxfp4_scale_batch(
        bld, cfg, coords, scale_step, scale_lds_offset, scale_after
    )
    scale_sets: list[tuple[int, _Mxfp4ScaleSet]] = []
    for k, (layout, offset) in enumerate(staged_scales):
        scales = _read_mxfp4_scales_from_layout(bld, cfg, layout, offset, ready_token)
        scale_sets.append((k, scales))
        if scale_tokens is not None:
            scale_tokens.append(scales.token)
    return _emit_mxfp4_mma_grid_scale_sets(bld, cfg, afs, bfs, accs, scale_sets)


def _emit_mxfp4_mma_grid_inline(
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
    scale_sets: list[tuple[int, _Mxfp4ScaleSet]] = []
    next_scale_after = scale_after
    for k in range(cfg.wave_k_tiles):
        raw_step = _mxfp4_raw_k_step(bld, cfg, scale_step, k)
        scales = _stage_read_mxfp4_scales(
            bld,
            cfg,
            coords,
            raw_step,
            scale_lds_offset,
            next_scale_after,
        )
        scale_sets.append((k, scales))
        next_scale_after = scales.token
        if scale_tokens is not None:
            scale_tokens.append(scales.token)
    return _emit_mxfp4_mma_grid_scale_sets(bld, cfg, afs, bfs, accs, scale_sets)


def _emit_mxfp4_mma_grid_scale_sets(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    afs: tuple[dsl.Value, ...],
    bfs: tuple[dsl.Value, ...],
    accs: tuple[dsl.Value, ...],
    scale_sets: list[tuple[int, _Mxfp4ScaleSet]],
) -> tuple[dsl.Value, ...]:
    return _emit_mxfp4_mma_grid_scale_sets_slice(
        bld, cfg, afs, bfs, accs, scale_sets, 0, cfg.wave_n_tiles
    )


def _emit_mxfp4_mma_grid_scale_sets_slice(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    afs: tuple[dsl.Value, ...],
    bfs: tuple[dsl.Value, ...],
    accs: tuple[dsl.Value, ...],
    scale_sets: list[tuple[int, _Mxfp4ScaleSet]],
    n_begin: int,
    n_end: int,
    m_begin: int = 0,
    m_end: int | None = None,
) -> tuple[dsl.Value, ...]:
    a_outer_type = PTupleType(afs[0].type)
    b_outer_type = PTupleType(bfs[0].type)
    a_row_type = a_outer_type.element_type
    b_row_type = b_outer_type.element_type
    af_type = PTupleType(a_row_type).element_type
    bf_type = PTupleType(b_row_type).element_type
    new_accs = list(accs)
    for k, scales in scale_sets:
        _emit_mxfp4_mma_grid_step(
            bld,
            cfg,
            afs[0],
            bfs[0],
            new_accs,
            k,
            a_row_type,
            b_row_type,
            af_type,
            bf_type,
            scales,
            n_begin,
            n_end,
            m_begin,
            m_end,
        )
    return tuple(new_accs)


def _emit_mxfp4_mma_grid_step(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    afs: dsl.Value,
    bfs: dsl.Value,
    accs: list[dsl.Value],
    k: int,
    a_row_type: dsl.Type,
    b_row_type: dsl.Type,
    af_type: dsl.Type,
    bf_type: dsl.Type,
    scales: _Mxfp4ScaleSet,
    n_begin: int = 0,
    n_end: int | None = None,
    m_begin: int = 0,
    m_end: int | None = None,
) -> None:
    if n_end is None:
        n_end = cfg.wave_n_tiles
    if m_end is None:
        m_end = cfg.wave_m_tiles
    index = IndexType.get()
    k_c = bld.constant(index, k)
    a_row = wavemeta.TupleGetOp(a_row_type, afs, k_c).result
    b_row = wavemeta.TupleGetOp(b_row_type, bfs, k_c).result
    for i in range(m_begin, m_end):
        i_c = bld.constant(index, i)
        af = wavemeta.TupleGetOp(af_type, a_row, i_c).result
        for j in range(n_begin, n_end):
            j_c = bld.constant(index, j)
            bf = wavemeta.TupleGetOp(bf_type, b_row, j_c).result
            acc_idx = i * cfg.wave_n_tiles + j
            accs[acc_idx] = bld.mma_scale(
                cfg.mma.kind,
                af,
                scales.a_scales[i],
                bf,
                scales.b_scales[j],
                accs[acc_idx],
                scale_idx_a=scales.a_scale_idxs[i],
                scale_idx_b=scales.b_scale_idxs[j],
            )


def _emit_mxfp4_mma_state_step(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    state: _LoopState,
    scales: _Mxfp4ScaleSet,
) -> tuple[dsl.Value, ...]:
    a_outer_type = PTupleType(state.afs[0].type)
    b_outer_type = PTupleType(state.bfs[0].type)
    a_row_type = a_outer_type.element_type
    b_row_type = b_outer_type.element_type
    af_type = PTupleType(a_row_type).element_type
    bf_type = PTupleType(b_row_type).element_type
    new_accs = list(state.accs)
    _emit_mxfp4_mma_grid_step(
        bld,
        cfg,
        state.afs[0],
        state.bfs[0],
        new_accs,
        0,
        a_row_type,
        b_row_type,
        af_type,
        bf_type,
        scales,
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
    scale_ready_token: dsl.Value | None = None,
    k_begin: int = 0,
    k_end: int | None = None,
) -> tuple[dsl.Value, ...]:
    """Triply-nested `wavemeta.static_for` over (k, i, j); the
    specialiser unrolls all three once the tile-factor params bind.
    Accumulator state rides through as a `!wavemeta.ptuple` so the
    inner body can address it by `i * wave_n + j`.
    """
    if not accs:
        return ()
    if cfg.uses_packed_mxfp4:
        if k_begin != 0 or k_end is not None:
            raise ValueError("MXFP4 MMA grid does not support K ranges")
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
            scale_ready_token,
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
    i_sym = dsl.sym("__wave_dsl_mma_i")
    j_sym = dsl.sym("__wave_dsl_mma_j")
    if cfg.coalesced_mfma_output:
        wave_m_sym = dsl.sym("__wave_dsl_mma_wave_m")
        acc_index_expr = j_sym * wave_m_sym + i_sym
        acc_index_params = {wave_m_sym: wave_m}
    else:
        wave_n_sym = dsl.sym("__wave_dsl_mma_wave_n")
        acc_index_expr = i_sym * wave_n_sym + j_sym
        acc_index_params = {wave_n_sym: wave_n}

    k_lower = c0 if k_begin == 0 else bld.constant(index, k_begin)
    k_upper = wave_k if k_end is None else bld.constant(index, k_end)
    with bld.static_for(k_lower, k_upper, c1, init_args=[accs_t]) as outer:
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
                acc_idx = bld.index_expr(
                    acc_index_expr,
                    acc_index_params | {i_sym: i_iv, j_sym: j_iv},
                )
                bf = wavemeta.TupleGetOp(bf_type, b_row, j_iv).result
                acc_old = wavemeta.TupleGetOp(acc_type, accs_kij, acc_idx).result
                acc_new = _emit_mma(bld, cfg, af, bf, acc_old)
                accs_kij_new = wavemeta.TupleSetOp(
                    acc_pt_type, accs_kij, acc_idx, acc_new
                ).result
                wavemeta.YieldOp([accs_kij_new])
            wavemeta.YieldOp([inner.results[0]])
        wavemeta.YieldOp([mid.results[0]])

    return _flat_extract(bld, outer.results[0], acc_type, acc_count)


def _emit_mma_phase_with_dma_reads(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    afs: tuple[dsl.Value, ...],
    bfs: tuple[dsl.Value, ...],
    accs: tuple[dsl.Value, ...],
    k: int,
    ready_token: dsl.Value,
    a_type: dsl.Type,
    b_type: dsl.Type,
    staging: _LdsStaging,
    a_read_ptrs: tuple[dsl.Value, ...],
    b_read_ptrs: tuple[dsl.Value, ...],
) -> tuple[
    tuple[dsl.Value, ...],
    tuple[dsl.Value, ...],
    tuple[dsl.Value, ...],
    dsl.Value,
]:
    a_outer_type = PTupleType(afs[0].type)
    b_outer_type = PTupleType(bfs[0].type)
    a_row_type = a_outer_type.element_type
    b_row_type = b_outer_type.element_type
    af_type = PTupleType(a_row_type).element_type
    bf_type = PTupleType(b_row_type).element_type

    index_type = IndexType.get()
    k_value = bld.constant(index_type, k)
    a_row = wavemeta.TupleGetOp(a_row_type, afs[0], k_value).result
    b_row = wavemeta.TupleGetOp(b_row_type, bfs[0], k_value).result
    new_accs = list(accs)

    a_frags: list[dsl.Value | None] = [None] * len(a_read_ptrs)
    b_frags: list[dsl.Value | None] = [None] * len(b_read_ptrs)
    early_reads: list[tuple[bool, int, dsl.Value]] = []
    for phase in range(cfg.wave_k_tiles - 1):
        for tile in range(max(cfg.wave_m_tiles, cfg.wave_n_tiles)):
            if tile < cfg.wave_m_tiles:
                a_index = phase * cfg.wave_m_tiles + tile
                early_reads.append((True, a_index, a_read_ptrs[a_index]))
            if tile < cfg.wave_n_tiles:
                b_index = phase * cfg.wave_n_tiles + tile
                early_reads.append((False, b_index, b_read_ptrs[b_index]))

    load_tokens: list[dsl.Value] = []

    def emit_read(is_a: bool, frag_index: int, ptr: dsl.Value) -> None:
        regs, token = bld.load(ptr, staging.reg_simd_type, after=ready_token)
        frag = bld.fragment_pack(regs, a_type if is_a else b_type)
        if is_a:
            a_frags[frag_index] = frag
        else:
            b_frags[frag_index] = frag
        load_tokens.append(token)

    early_emitted = 0
    early_mmas = max(1, (cfg.wave_m_tiles - 1) * cfg.wave_n_tiles)
    last_phase = cfg.wave_k_tiles - 1
    for i in range(cfg.wave_m_tiles):
        i_value = bld.constant(index_type, i)
        af = wavemeta.TupleGetOp(af_type, a_row, i_value).result
        for j in range(cfg.wave_n_tiles):
            j_value = bld.constant(index_type, j)
            bf = wavemeta.TupleGetOp(bf_type, b_row, j_value).result
            acc_index = _mma_acc_index(cfg, i, j)
            new_accs[acc_index] = _emit_mma(bld, cfg, af, bf, new_accs[acc_index])

            if i < cfg.wave_m_tiles - 1:
                early_done = i * cfg.wave_n_tiles + j + 1
                early_target = early_done * len(early_reads) // early_mmas
                while early_emitted < early_target:
                    emit_read(*early_reads[early_emitted])
                    early_emitted += 1
            if i == cfg.wave_m_tiles - 1:
                b_index = last_phase * cfg.wave_n_tiles + j
                emit_read(False, b_index, b_read_ptrs[b_index])

        a_index = last_phase * cfg.wave_m_tiles + i
        emit_read(True, a_index, a_read_ptrs[a_index])

    if early_emitted != len(early_reads):
        raise ValueError("DMA read cadence did not emit all fragments")
    return (
        tuple(new_accs),
        tuple(frag for frag in a_frags if frag is not None),
        tuple(frag for frag in b_frags if frag is not None),
        _join_tokens(bld, load_tokens),
    )


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
    new_scale_token: dsl.Value | None = None
    new_next_scale_token: dsl.Value | None = None
    if cfg.use_dma_lds:
        (
            new_accs,
            next_token,
            new_afs,
            new_bfs,
            reuse_token,
            new_scale_token,
            new_next_scale_token,
        ) = _emit_dma_step(
            bld,
            cfg,
            types,
            staging,
            coords,
            state,
            a_ptrs,
            b_ptrs,
            scale_step,
            current_lds_offset,
            ready_lds_offset,
            next_lds_offset,
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
        *(() if new_scale_token is None else (new_scale_token,)),
        *(() if new_next_scale_token is None else (new_next_scale_token,)),
    ]


def _use_mxfp4_regional_dma_step(cfg: _MatmulConfig) -> bool:
    return (
        cfg.use_dma_lds
        and cfg.uses_packed_mxfp4
        and cfg.wave_n_tiles > 1
        and cfg.wave_n_tiles % 2 == 0
    )


def _use_mxfp4_regional_scale_read_step(cfg: _MatmulConfig) -> bool:
    return _use_mxfp4_regional_dma_step(cfg) and cfg.mxfp4_scale_path == "regs"


def _use_mxfp4_shared_scale_barrier(cfg: _MatmulConfig) -> bool:
    regional = _use_mxfp4_regional_scale_read_step(cfg)
    batched_regs = _use_batched_mxfp4_scale_regs_cta(cfg)
    return regional and batched_regs


def _use_reuse_data_dma_issue(cfg: _MatmulConfig) -> bool:
    return cfg.use_dma_lds and cfg.virtual_k_steps > 2


def _emit_dma_step(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    types: _KernelTypes,
    staging: _LdsStaging,
    coords: _TileCoords,
    state: _LoopState,
    a_ptrs: tuple[dsl.Value, ...],
    b_ptrs: tuple[dsl.Value, ...],
    scale_step: dsl.Value | int,
    current_lds_offset: int | dsl.Value,
    ready_lds_offset: int | dsl.Value,
    next_lds_offset: int | dsl.Value,
) -> tuple[
    tuple[dsl.Value, ...],
    dsl.Value,
    tuple[dsl.Value, ...],
    tuple[dsl.Value, ...],
    dsl.Value,
    dsl.Value | None,
    dsl.Value | None,
]:
    if state.dma_token is None or state.reuse_token is None:
        raise ValueError("DMA pipeline step requires ready and reuse tokens")
    scale_tokens: list[dsl.Value] = []
    next_token: dsl.Value | None = None
    next_split_tokens: list[dsl.Value] = []
    new_scale_token: dsl.Value | None = None
    new_next_scale_token: dsl.Value | None = None
    ready_token: dsl.Value | None = None

    def get_ready_token() -> dsl.Value:
        nonlocal ready_token
        if ready_token is None:
            ready_token = bld.barrier(state.dma_token, state.reuse_token)
        return ready_token

    def dma_after_token() -> dsl.Value:
        return (
            state.reuse_token if _use_reuse_data_dma_issue(cfg) else get_ready_token()
        )

    def issue_next_dma() -> dsl.Value:
        nonlocal next_token
        if next_token is None:
            next_token = _join_tokens(
                bld,
                _dma_issue(
                    bld,
                    cfg,
                    a_ptrs,
                    b_ptrs,
                    staging,
                    after=dma_after_token(),
                    lds_offset=next_lds_offset,
                    in_loop=True,
                ),
            )
        return next_token

    def can_split_next_dma(n_mid: int) -> bool:
        return (
            _dma_b_wave_n_slice_indices(cfg, 0, n_mid) is not None
            and _dma_b_wave_n_slice_indices(cfg, n_mid, cfg.wave_n_tiles) is not None
        )

    def issue_next_dma_slice(n_begin: int, n_end: int, *, include_a: bool) -> dsl.Value:
        if next_token is not None:
            return next_token
        b_indices = _dma_b_wave_n_slice_indices(cfg, n_begin, n_end)
        if b_indices is None:
            return issue_next_dma()
        token = _join_tokens(
            bld,
            _dma_issue_parts(
                bld,
                a_ptrs,
                b_ptrs,
                staging,
                after=dma_after_token(),
                lds_offset=next_lds_offset,
                include_a=include_a,
                b_indices=b_indices,
            ),
        )
        next_split_tokens.append(token)
        return token

    def finish_next_dma() -> dsl.Value:
        nonlocal next_token
        if next_token is None and next_split_tokens:
            next_token = _join_tokens(bld, next_split_tokens)
        return issue_next_dma() if next_token is None else next_token

    early_dma = cfg.uses_packed_mxfp4 and cfg.wave_k_tiles == 1
    uses_prefetched_scales = cfg.uses_packed_mxfp4 and state.scale_token is not None
    if uses_prefetched_scales:
        if state.next_scale_token is None:
            raise ValueError("DMA MXFP4 loop requires next prefetched scales")
        next_scale_step = bld.addi(scale_step, bld.constant(dsl.i32(), 2))
        new_scale_token = state.next_scale_token
        if _use_mxfp4_regional_scale_read_step(cfg):
            n_mid = cfg.wave_n_tiles // 2
            scale_offset = _scale_buffer_offset(bld, cfg, scale_step)
            scale_ready_token = _join_tokens(
                bld, [state.scale_token, state.reuse_token]
            )
            barrier_before_scale_read = True
            if _use_mxfp4_shared_scale_barrier(cfg):
                scale_ready_token = bld.barrier(scale_ready_token)
                barrier_before_scale_read = False
            left_scale_sets, left_scale_token = _read_mxfp4_scale_batch_region(
                bld,
                cfg,
                coords,
                scale_step,
                scale_offset,
                scale_ready_token,
                0,
                n_mid,
                include_a=True,
                barrier_before_read=barrier_before_scale_read,
            )
            scale_tokens.append(left_scale_token)
            right_scale_sets, right_scale_token = _read_mxfp4_scale_batch_region(
                bld,
                cfg,
                coords,
                scale_step,
                scale_offset,
                scale_ready_token,
                n_mid,
                cfg.wave_n_tiles,
                include_a=False,
                a_scale_sets=left_scale_sets,
                barrier_before_read=barrier_before_scale_read,
            )
            scale_tokens.append(right_scale_token)
            scale_read_token = _join_tokens(bld, [left_scale_token, right_scale_token])
            scale_read_done = bld.barrier(scale_read_token)
            left_accs = _emit_mxfp4_mma_grid_scale_sets_slice(
                bld,
                cfg,
                state.afs,
                state.bfs,
                state.accs,
                left_scale_sets,
                0,
                n_mid,
            )
            if _use_mxfp4_delayed_b_scale_lw(cfg):
                next_a_scale_token, delayed_b_scale = (
                    _stage_mxfp4_scale_batch_delayed_b_lw(
                        bld,
                        cfg,
                        coords,
                        next_scale_step,
                        _scale_buffer_offset(bld, cfg, next_scale_step),
                        scale_read_done,
                        barrier_before=False,
                    )
                )
                right_head = _emit_mxfp4_mma_grid_scale_sets_slice(
                    bld,
                    cfg,
                    state.afs,
                    state.bfs,
                    left_accs,
                    right_scale_sets,
                    n_mid,
                    cfg.wave_n_tiles,
                    m_end=2,
                )
                next_b_scale_token = _flush_deferred_mxfp4_scale_store(
                    bld, delayed_b_scale
                )
                new_next_scale_token = bld.join(next_a_scale_token, next_b_scale_token)
                new_accs = _emit_mxfp4_mma_grid_scale_sets_slice(
                    bld,
                    cfg,
                    state.afs,
                    state.bfs,
                    right_head,
                    right_scale_sets,
                    n_mid,
                    cfg.wave_n_tiles,
                    m_begin=2,
                )
            else:
                read_deferred_scales: _DeferredScaleRegBatch | None = None
                if _use_batched_mxfp4_scale_regs_cta(cfg):
                    _, read_deferred_scales = (
                        _defer_mxfp4_scale_batch_regs_cta_after_dep(
                            bld,
                            cfg,
                            coords,
                            next_scale_step,
                            _scale_buffer_offset(bld, cfg, next_scale_step),
                            dep=scale_read_done,
                            barrier_after=False,
                        )
                    )
                    if can_split_next_dma(n_mid):
                        issue_next_dma_slice(0, n_mid, include_a=True)
                    else:
                        issue_next_dma()
                else:
                    _, new_next_scale_token = _stage_mxfp4_scale_batch(
                        bld,
                        cfg,
                        coords,
                        next_scale_step,
                        _scale_buffer_offset(bld, cfg, next_scale_step),
                        scale_read_done,
                        barrier_after=False,
                        barrier_before=False,
                    )
                new_accs = _emit_mxfp4_mma_grid_scale_sets_slice(
                    bld,
                    cfg,
                    state.afs,
                    state.bfs,
                    left_accs,
                    right_scale_sets,
                    n_mid,
                    cfg.wave_n_tiles,
                )
                if read_deferred_scales is not None:
                    new_next_scale_token = _flush_deferred_mxfp4_scale_reg_batch(
                        bld, read_deferred_scales
                    )
                    if can_split_next_dma(n_mid):
                        issue_next_dma_slice(n_mid, cfg.wave_n_tiles, include_a=False)
            if new_next_scale_token is None:
                raise ValueError("MXFP4 next scale token was not produced")
        else:
            scale_ready_token = _join_tokens(
                bld, [state.scale_token, state.reuse_token]
            )
            scale_sets, scale_reuse_token = _read_mxfp4_scale_batch(
                bld,
                cfg,
                coords,
                scale_step,
                _scale_buffer_offset(bld, cfg, scale_step),
                scale_ready_token,
            )
            scale_tokens.append(scale_reuse_token)
            if _use_mxfp4_regional_dma_step(cfg):
                n_mid = cfg.wave_n_tiles // 2
                left_accs = _emit_mxfp4_mma_grid_scale_sets_slice(
                    bld, cfg, state.afs, state.bfs, state.accs, scale_sets, 0, n_mid
                )
                reuse_deferred_scales: _DeferredScaleRegBatch | None = None
                if _use_batched_mxfp4_scale_regs_cta(cfg):
                    _, reuse_deferred_scales = (
                        _defer_mxfp4_scale_batch_regs_cta_after_dep(
                            bld,
                            cfg,
                            coords,
                            next_scale_step,
                            _scale_buffer_offset(bld, cfg, next_scale_step),
                            dep=bld.barrier(scale_reuse_token),
                            barrier_after=False,
                        )
                    )
                    if can_split_next_dma(n_mid):
                        issue_next_dma_slice(0, n_mid, include_a=True)
                    else:
                        issue_next_dma()
                else:
                    _, new_next_scale_token = _stage_mxfp4_scale_batch(
                        bld,
                        cfg,
                        coords,
                        next_scale_step,
                        _scale_buffer_offset(bld, cfg, next_scale_step),
                        scale_reuse_token,
                        barrier_after=False,
                    )
                new_accs = _emit_mxfp4_mma_grid_scale_sets_slice(
                    bld,
                    cfg,
                    state.afs,
                    state.bfs,
                    left_accs,
                    scale_sets,
                    n_mid,
                    cfg.wave_n_tiles,
                )
                if reuse_deferred_scales is not None:
                    new_next_scale_token = _flush_deferred_mxfp4_scale_reg_batch(
                        bld, reuse_deferred_scales
                    )
                    if can_split_next_dma(n_mid):
                        issue_next_dma_slice(n_mid, cfg.wave_n_tiles, include_a=False)
                if new_next_scale_token is None:
                    raise ValueError("MXFP4 next scale token was not produced")
            else:
                _, new_next_scale_token = _stage_mxfp4_scale_batch(
                    bld,
                    cfg,
                    coords,
                    next_scale_step,
                    _scale_buffer_offset(bld, cfg, next_scale_step),
                    scale_reuse_token,
                    barrier_after=False,
                )
                new_accs = _emit_mxfp4_mma_grid_scale_sets(
                    bld, cfg, state.afs, state.bfs, state.accs, scale_sets
                )
    elif early_dma:
        scales = _stage_read_mxfp4_scales(
            bld, cfg, coords, scale_step, current_lds_offset, get_ready_token()
        )
        scale_tokens.append(scales.token)
    else:
        ready_read_ptrs: tuple[tuple[dsl.Value, ...], tuple[dsl.Value, ...]] | None = (
            None
        )
        if (
            not cfg.uses_packed_mxfp4
            and cfg.wave_k_tiles > 1
            and _uses_phased_dma_schedule(cfg)
        ):
            ready_read_ptrs = (
                _offset_ptrs(bld, staging.a_dma_read_ptrs, ready_lds_offset),
                _offset_ptrs(bld, staging.b_dma_read_ptrs, ready_lds_offset),
            )
        if _use_reuse_data_dma_issue(cfg):
            issue_next_dma()
        if (
            not cfg.uses_packed_mxfp4
            and cfg.wave_k_tiles > 1
            and _uses_phased_dma_schedule(cfg)
        ):
            assert ready_read_ptrs is not None
            new_accs = state.accs
            for k in range(cfg.wave_k_tiles - 1):
                new_accs = _emit_mma_grid(
                    bld,
                    cfg,
                    state.afs,
                    state.bfs,
                    new_accs,
                    k_begin=k,
                    k_end=k + 1,
                )
            new_accs, ready_afs, ready_bfs, reuse_token = (
                _emit_mma_phase_with_dma_reads(
                    bld,
                    cfg,
                    state.afs,
                    state.bfs,
                    new_accs,
                    cfg.wave_k_tiles - 1,
                    get_ready_token(),
                    types.a,
                    types.b,
                    staging,
                    *ready_read_ptrs,
                )
            )
            ready_loads = (ready_afs, ready_bfs, reuse_token)
        else:
            new_accs = _emit_mma_grid(
                bld,
                cfg,
                state.afs,
                state.bfs,
                state.accs,
                coords=coords,
                scale_step=scale_step,
                scale_lds_offset=(
                    _scale_buffer_offset(bld, cfg, scale_step)
                    if state.scale_token is not None
                    else current_lds_offset
                ),
                scale_after=get_ready_token() if cfg.uses_packed_mxfp4 else None,
                scale_tokens=scale_tokens,
                scale_ready_token=state.scale_token,
            )
            ready_loads = None
    if next_token is None:
        finish_next_dma()
    if early_dma and not uses_prefetched_scales:
        new_accs = _emit_mxfp4_mma_state_step(bld, cfg, state, scales)
    if cfg.uses_packed_mxfp4 or ready_loads is None:
        ready_loads = _dma_read_ready(
            bld,
            get_ready_token(),
            types.a,
            types.b,
            staging,
            lds_offset=ready_lds_offset,
        )
    new_afs, new_bfs, reuse_token = ready_loads
    return (
        new_accs,
        next_token,
        new_afs,
        new_bfs,
        reuse_token,
        new_scale_token,
        new_next_scale_token,
    )


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
        scale_lds_offset=(
            _scale_buffer_offset(bld, cfg, current_step)
            if state.scale_token is not None
            else _dma_buffer_offset(bld, cfg, current_step)
        ),
        scale_after=state.reuse_token,
        scale_tokens=scale_tokens,
        scale_ready_token=state.scale_token,
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
        scale_token=state.next_scale_token,
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
    if _can_split_mxfp4_epilogue(cfg, state):
        _store_final_mxfp4_tiles_split(
            bld, cfg, state, coords, c_ptrs, scale_step, scale_lds_offset
        )
        return

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
        scale_ready_token=state.scale_token,
    )
    store_after = scale_tokens[-1] if scale_tokens else None
    _store_acc_tiles(
        bld,
        cfg,
        final_accs,
        c_ptrs,
        0,
        cfg.wave_n_tiles,
        after=store_after,
    )


def _can_split_mxfp4_epilogue(cfg: _MatmulConfig, state: _LoopState) -> bool:
    return (
        cfg.uses_packed_mxfp4
        and cfg.output_type == "f16"
        and cfg.wave_n_tiles > 1
        and cfg.wave_n_tiles % 2 == 0
        and state.scale_token is not None
    )


def _mxfp4_output_lds_bytes(cfg: _MatmulConfig) -> int:
    return cfg.waves_per_workgroup * cfg.tiles_per_wave * 256 * cfg.c_element_bytes


def _can_coalesce_mxfp4_epilogue(cfg: _MatmulConfig) -> bool:
    return (
        cfg.uses_packed_mxfp4
        and cfg.output_type == "f16"
        and cfg.waves_per_workgroup <= 4
        and cfg.mma.acc_registers * 16 == 64
        and _mxfp4_output_lds_bytes(cfg) <= cfg.data_lds_bytes
    )


def _store_final_mxfp4_tiles_split(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    state: _LoopState,
    coords: _TileCoords,
    c_ptrs: tuple[dsl.Value, ...],
    scale_step: dsl.Value | int,
    scale_lds_offset: dsl.Value | int,
) -> None:
    assert state.scale_token is not None
    scale_ready_token = state.scale_token
    if state.reuse_token is not None:
        scale_ready_token = _join_tokens(bld, [scale_ready_token, state.reuse_token])
    scale_sets, scale_token = _read_mxfp4_scale_batch(
        bld, cfg, coords, scale_step, scale_lds_offset, scale_ready_token
    )
    right_scale_sets = scale_sets
    n_mid = cfg.wave_n_tiles // 2
    left_accs = _emit_mxfp4_mma_grid_scale_sets_slice(
        bld, cfg, state.afs, state.bfs, state.accs, scale_sets, 0, n_mid
    )
    scale_read_done = scale_token
    if _can_coalesce_mxfp4_epilogue(cfg):
        scale_read_done = bld.barrier(scale_token)
        _store_acc_tiles_lds_coalesced(
            bld, cfg, coords, left_accs, c_ptrs, 0, n_mid, after=scale_read_done
        )
    else:
        _store_acc_tiles(bld, cfg, left_accs, c_ptrs, 0, n_mid, after=scale_token)

    right_accs = _emit_mxfp4_mma_grid_scale_sets_slice(
        bld,
        cfg,
        state.afs,
        state.bfs,
        state.accs,
        right_scale_sets,
        n_mid,
        cfg.wave_n_tiles,
    )
    if _can_coalesce_mxfp4_epilogue(cfg):
        _store_acc_tiles_lds_coalesced(
            bld,
            cfg,
            coords,
            right_accs,
            c_ptrs,
            n_mid,
            cfg.wave_n_tiles,
            after=scale_read_done,
        )
    else:
        _store_acc_tiles(
            bld, cfg, right_accs, c_ptrs, n_mid, cfg.wave_n_tiles, after=scale_token
        )


def _store_acc_tiles(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    accs: tuple[dsl.Value, ...],
    c_ptrs: tuple[dsl.Value, ...],
    n_begin: int,
    n_end: int,
    *,
    after: dsl.Value | None = None,
) -> None:
    cache = _output_store_cache(cfg)
    if cfg.coalesced_mfma_output:
        _store_acc_tiles_mfma_coalesced(
            bld, cfg, accs, c_ptrs[0], n_begin, n_end, after=after
        )
        return
    for i in range(cfg.wave_m_tiles):
        for j in range(n_begin, n_end):
            acc_idx = i * cfg.wave_n_tiles + j
            if cfg.output_type == "f16":
                _fragment_store_f16(
                    bld,
                    cfg,
                    accs[acc_idx],
                    c_ptrs[acc_idx],
                    after=after,
                    cache=cache,
                )
            else:
                bld.fragment_store(
                    accs[acc_idx], c_ptrs[acc_idx], after=after, cache=cache
                )


def _output_store_cache(cfg: _MatmulConfig) -> Attribute | None:
    kind = _OUTPUT_STORE_CACHE_KINDS.get(cfg.output_store_cache)
    if kind is None:
        return None
    return dsl.store_cache(kind)


def _store_acc_tiles_mfma_coalesced(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    accs: tuple[dsl.Value, ...],
    c_ptr: dsl.Value,
    n_begin: int,
    n_end: int,
    *,
    after: dsl.Value | None = None,
) -> None:
    cache = _output_store_cache(cfg)
    regs_type = dsl.simd_type(
        dsl.vector_type(cfg.mma.acc_registers, dsl.f32()), width=cfg.mma.wave_size
    )
    unpacked = tuple(
        waveamd.FragmentUnpackOp(regs_type, fragment).result for fragment in accs
    )
    f32_simd = dsl.simd_type(dsl.f32(), width=cfg.mma.wave_size)
    f16_simd = dsl.simd_type(dsl.f16(), width=cfg.mma.wave_size)
    packed_type = dsl.simd_type(
        dsl.vector_type(cfg.wave_m_tiles, dsl.f16()), width=cfg.mma.wave_size
    )
    wi_sym = dsl.sym("__wave_dsl_coalesced_wi")
    wi_val = bld.workitem_id(axis=0, width=cfg.mma.wave_size)
    lane = dsl.mod(wi_sym, cfg.mma.wave_size)
    lane_m = dsl.mod(lane, 16) * cfg.wave_m_tiles
    lane_n = dsl.floor(lane / 16) * (cfg.mma.acc_registers * cfg.wave_n_tiles)
    for reg in range(cfg.mma.acc_registers):
        for j in range(n_begin, n_end):
            values = [
                bld.fpconvert(
                    wave.ExtractOp(
                        f32_simd, unpacked[_mma_acc_index(cfg, i, j)], reg
                    ).result,
                    f16_simd,
                )
                for i in range(cfg.wave_m_tiles)
            ]
            offset = bld.index_expr(
                lane_m + (lane_n + reg * cfg.wave_n_tiles + j) * cfg.M,
                bindings={wi_sym: wi_val},
            )
            bld.store(
                wave.PackOp(packed_type, values).result,
                bld.ptr_add(c_ptr, offset),
                after=after,
                cache=cache,
            )


def _store_acc_tiles_lds_coalesced(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    coords: _TileCoords,
    accs: tuple[dsl.Value, ...],
    c_ptrs: tuple[dsl.Value, ...],
    n_begin: int,
    n_end: int,
    *,
    after: dsl.Value | None = None,
) -> None:
    cache = _output_store_cache(cfg)
    lds = bld.shared_memory_base(dsl.f16())
    wi = dsl.sym("__wave_dsl_epilogue_wi")
    bindings = {wi: coords.wi}
    lane = dsl.mod(wi, cfg.mma.wave_size)
    wave_id = dsl.floor(wi / cfg.mma.wave_size)
    wave_stride = cfg.tiles_per_wave * 256
    lds_tokens: list[dsl.Value] = []
    for i in range(cfg.wave_m_tiles):
        for j in range(n_begin, n_end):
            acc_idx = i * cfg.wave_n_tiles + j
            lds_off = bld.index_expr(
                wave_id * wave_stride + acc_idx * 256 + lane * cfg.mma.acc_registers,
                bindings=bindings,
            )
            lds_tokens.append(
                bld.store(
                    _pack_fragment_f16(bld, cfg, accs[acc_idx]),
                    bld.ptr_add(lds, lds_off),
                    after=after,
                )
            )
    ready = bld.barrier(_join_tokens(bld, lds_tokens))

    lane_id = bld.binary(
        dsl.BinaryKind.AndI,
        coords.wi,
        bld.splat(
            bld.constant(dsl.i32(), cfg.mma.wave_size - 1),
            width=cfg.mma.wave_size,
        ),
    )
    active = bld.cmpi(
        "ult",
        lane_id,
        bld.splat(
            bld.constant(dsl.i32(), cfg.mma.wave_size // 2),
            width=cfg.mma.wave_size,
        ),
    )
    load_type = dsl.simd_type(
        dsl.vector_type(2 * cfg.mma.acc_registers, dsl.f16()),
        width=cfg.mma.wave_size,
    )
    with bld.where(active, [dsl.mem_token_type()]):
        store_tokens: list[dsl.Value] = []
        for i in range(cfg.wave_m_tiles):
            for j in range(n_begin, n_end):
                acc_idx = i * cfg.wave_n_tiles + j
                lds_off = bld.index_expr(
                    wave_id * wave_stride + acc_idx * 256 + lane * 8,
                    bindings=bindings,
                )
                value, load_token = bld.load(
                    bld.ptr_add(lds, lds_off), load_type, after=ready
                )
                global_off = bld.index_expr(lane * 8, bindings=bindings)
                store_tokens.append(
                    bld.store(
                        value,
                        bld.ptr_add(c_ptrs[acc_idx], global_off),
                        after=load_token,
                        cache=cache,
                    )
                )
        bld.yield_([_join_tokens(bld, store_tokens)])


def _pack_fragment_f16(
    bld: dsl.FunctionBuilder, cfg: _MatmulConfig, fragment: dsl.Value
) -> dsl.Value:
    regs_type = dsl.simd_type(
        dsl.vector_type(cfg.mma.acc_registers, dsl.f32()), width=cfg.mma.wave_size
    )
    regs = waveamd.FragmentUnpackOp(regs_type, fragment).result
    f32_simd = dsl.simd_type(dsl.f32(), width=cfg.mma.wave_size)
    f16_simd = dsl.simd_type(dsl.f16(), width=cfg.mma.wave_size)
    f16_regs = [
        bld.fpconvert(wave.ExtractOp(f32_simd, regs, i).result, f16_simd)
        for i in range(cfg.mma.acc_registers)
    ]
    packed_type = dsl.simd_type(
        dsl.vector_type(cfg.mma.acc_registers, dsl.f16()),
        width=cfg.mma.wave_size,
    )
    return wave.PackOp(packed_type, f16_regs).result


def _fragment_store_f16(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    fragment: dsl.Value,
    ptr: dsl.Value,
    *,
    after: dsl.Value | None = None,
    cache: Attribute | None = None,
) -> dsl.Value:
    if cfg.mma.acc_registers % 2 != 0:
        raise ValueError("f16 output needs an even accumulator register count")
    wi_sym = dsl.sym("__wave_dsl_frag_wi")
    wi_val = bld.workitem_id(axis=0, width=cfg.mma.wave_size)
    lane_off = bld.index_expr(
        dsl.mod(wi_sym, cfg.mma.wave_size) * cfg.mma.acc_registers,
        {wi_sym: wi_val},
    )
    base = bld.ptr_add(ptr, lane_off)
    return bld.store(
        _pack_fragment_f16(bld, cfg, fragment), base, after=after, cache=cache
    )


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
    dynamic_lds = _dynamic_lds_bytes(cfg)
    bld.launch(
        _GPU_MODULE_NAME,
        _KERNEL_NAME,
        grid=grid,
        block=block,
        operands=operands,
        dynamic_shared_memory_size=(
            bld.constant(dsl.i32(), dynamic_lds) if dynamic_lds else None
        ),
    )


def _kernel_trip_count_source(
    bld: dsl.FunctionBuilder, cfg: _MatmulConfig
) -> dsl.Value:
    if len(bld.args) > cfg.trip_count_arg_index:
        return bld.args[cfg.trip_count_arg_index]
    return bld.constant(dsl.i32(), max(cfg.virtual_k_steps - 1, 0))


def _attach_phased_dma_loop_attrs(forop: scf.ForOp, cfg: _MatmulConfig) -> None:
    schedule = cfg.phased_dma_schedule
    if schedule is None:
        return
    i64 = IntegerType.get_signless(64)
    forop.operation.attributes["waveamdmachine.fetch_alignment"] = IntegerAttr.get(
        i64, schedule.fetch_alignment
    )
    forop.operation.attributes["waveamdmachine.fetch_phase"] = IntegerAttr.get(
        i64, schedule.fetch_phase
    )


def _dma_phase_slice(
    values: tuple[dsl.Value, ...], phase: int, phases: int
) -> tuple[dsl.Value, ...]:
    width = len(values) // phases
    begin = phase * width
    return values[begin : begin + width]


def _flatten_dma_subpanel_tokens(tokens: _DmaSubpanelTokens) -> tuple[dsl.Value, ...]:
    return (*tokens.a, *tokens.b)


def _split_dma_subpanel_tokens(
    values: tuple[dsl.Value, ...], cfg: _MatmulConfig
) -> _DmaSubpanelTokens:
    phases = cfg.wave_k_tiles
    return _DmaSubpanelTokens(values[:phases], values[phases : 2 * phases])


def _split_dma_subpanel_loop_state(
    values: tuple[dsl.Value, ...], cfg: _MatmulConfig
) -> _DmaSubpanelLoopState:
    acc_end = cfg.tiles_per_wave
    a_end = acc_end + cfg.wave_m_tiles
    b_end = a_end + cfg.wave_n_tiles
    ready_begin = b_end + 7
    token_count = 2 * cfg.wave_k_tiles
    return _DmaSubpanelLoopState(
        accs=values[:acc_end],
        a_frags=values[acc_end:a_end],
        b_frags=values[a_end:b_end],
        a_read=values[b_end],
        b_read=values[b_end + 1],
        current_access=values[b_end + 2],
        current_read_bases=_DmaSubpanelReadBases(values[b_end + 3], values[b_end + 4]),
        current_lds_offset=values[b_end + 5],
        current_dma_lds_byte_base=values[b_end + 6],
        ready=_split_dma_subpanel_tokens(
            values[ready_begin : ready_begin + token_count], cfg
        ),
    )


def _issue_dma_operand_subpanels(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    src_ptrs: tuple[dsl.Value, ...],
    dst_ptrs: tuple[dsl.Value, ...],
    after: tuple[dsl.Value, ...],
    *,
    lds_byte_base: dsl.Value,
    in_loop: bool,
    request_offset: int,
) -> tuple[dsl.Value, ...]:
    tokens: list[dsl.Value] = []
    for phase in range(cfg.wave_k_tiles):
        tokens.append(
            _issue_dma_operand_phase(
                bld,
                cfg,
                src_ptrs,
                dst_ptrs,
                phase,
                after[phase],
                lds_byte_base=lds_byte_base,
                in_loop=in_loop,
                request_offset=request_offset,
            )
        )
    return tuple(tokens)


def _issue_dma_operand_phase(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    src_ptrs: tuple[dsl.Value, ...],
    dst_ptrs: tuple[dsl.Value, ...],
    phase: int,
    after: dsl.Value,
    *,
    lds_byte_base: dsl.Value,
    in_loop: bool,
    request_offset: int,
) -> dsl.Value:
    phase_width = len(src_ptrs) // cfg.wave_k_tiles
    return _issue_dma_operand_phase_requests(
        bld,
        cfg,
        src_ptrs,
        dst_ptrs,
        phase,
        0,
        phase_width,
        after,
        lds_byte_base=lds_byte_base,
        in_loop=in_loop,
        request_offset=request_offset,
    )


def _issue_dma_operand_phase_requests(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    src_ptrs: tuple[dsl.Value, ...],
    dst_ptrs: tuple[dsl.Value, ...],
    phase: int,
    begin: int,
    end: int,
    after: dsl.Value,
    *,
    lds_byte_base: dsl.Value,
    in_loop: bool,
    request_offset: int,
) -> dsl.Value:
    byte_base = dsl.sym("byte_base")
    byte_offset = bld.index_expr(
        byte_base,
        bindings={byte_base: lds_byte_base},
    )
    dst_ptrs = _offset_ptrs(bld, dst_ptrs, byte_offset)
    dma_lds_type = dsl.ptr_type(dsl.i32(), dsl.shared_address_space())
    dst_ptrs = tuple(bld.ptr_cast(ptr, dma_lds_type) for ptr in dst_ptrs)
    phase_requests = list(
        zip(
            _dma_phase_slice(src_ptrs, phase, cfg.wave_k_tiles),
            _dma_phase_slice(dst_ptrs, phase, cfg.wave_k_tiles),
            strict=True,
        )
    )
    requests = phase_requests[begin:end]
    phase_offset = request_offset + phase * len(phase_requests) + begin
    return _join_tokens(
        bld,
        _dma_issue_requests(
            bld,
            cfg,
            requests,
            after=after,
            in_loop=in_loop,
            request_offset=phase_offset,
        ),
    )


def _issue_dma_subpanels(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    a_ptrs: tuple[dsl.Value, ...],
    b_ptrs: tuple[dsl.Value, ...],
    staging: _LdsStaging,
    after: _DmaSubpanelTokens,
    *,
    lds_byte_base: dsl.Value,
    in_loop: bool,
    request_offset: int = 0,
) -> _DmaSubpanelTokens:
    a = _issue_dma_operand_subpanels(
        bld,
        cfg,
        a_ptrs,
        staging.a_dma_lds_byte_ptrs,
        after.a,
        lds_byte_base=lds_byte_base,
        in_loop=in_loop,
        request_offset=request_offset,
    )
    b = _issue_dma_operand_subpanels(
        bld,
        cfg,
        b_ptrs,
        staging.b_dma_lds_byte_ptrs,
        after.b,
        lds_byte_base=lds_byte_base,
        in_loop=in_loop,
        request_offset=request_offset + len(a_ptrs),
    )
    return _DmaSubpanelTokens(a, b)


def _read_dma_subpanel(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    base: dsl.Value,
    offsets: tuple[int, ...],
    phase: int,
    ready: dsl.Value,
    frag_type: dsl.Type,
    staging: _LdsStaging,
) -> tuple[tuple[dsl.Value, ...], dsl.Value]:
    read_ptrs = _dma_subpanel_read_ptrs(bld, staging, base, offsets)
    fragments: list[dsl.Value] = []
    tokens: list[dsl.Value] = []
    for ptr in _dma_phase_slice(read_ptrs, phase, cfg.wave_k_tiles):
        fragment, token = _read_dma_subpanel_fragment(
            bld, ptr, ready, frag_type, staging
        )
        fragments.append(fragment)
        tokens.append(token)
    return tuple(fragments), _join_tokens(bld, tokens)


def _read_dma_subpanel_fragment(
    bld: dsl.FunctionBuilder,
    ptr: dsl.Value,
    ready: dsl.Value,
    frag_type: dsl.Type,
    staging: _LdsStaging,
) -> tuple[dsl.Value, dsl.Value]:
    regs, token = bld.load(ptr, staging.reg_simd_type, after=ready)
    return bld.fragment_pack(regs, frag_type), token


def _emit_dma_subpanel_mmas(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    a_frags: tuple[dsl.Value, ...],
    b_frags: tuple[dsl.Value, ...],
    accs: tuple[dsl.Value, ...],
    *,
    m_begin: int = 0,
    m_end: int | None = None,
) -> tuple[dsl.Value, ...]:
    if m_end is None:
        m_end = len(a_frags)
    return _emit_dma_subpanel_mma_range(
        bld,
        cfg,
        a_frags,
        b_frags,
        accs,
        m_begin * len(b_frags),
        m_end * len(b_frags),
    )


def _serpentine_mma_coords(a_count: int, ordinal: int) -> tuple[int, int]:
    j, i = divmod(ordinal, a_count)
    if j % 2:
        i = a_count - i - 1
    return i, j


def _emit_dma_subpanel_mma_range(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    a_frags: tuple[dsl.Value, ...],
    b_frags: tuple[dsl.Value, ...],
    accs: tuple[dsl.Value, ...],
    begin: int,
    end: int,
) -> tuple[dsl.Value, ...]:
    total = len(a_frags) * len(b_frags)
    if not 0 <= begin <= end <= total:
        raise ValueError("MFMA range must fit the subpanel")
    new_accs = list(accs)
    for ordinal in range(begin, end):
        i, j = _serpentine_mma_coords(len(a_frags), ordinal)
        index = _mma_acc_index(cfg, i, j)
        new_accs[index] = _emit_mma(bld, cfg, a_frags[i], b_frags[j], new_accs[index])
    return tuple(new_accs)


def _emit_dma_subpanel_mma_prefix(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    a_frags: tuple[dsl.Value, ...],
    b_frags: tuple[dsl.Value, ...],
    accs: tuple[dsl.Value, ...],
    count: int,
) -> tuple[dsl.Value, ...]:
    return _emit_dma_subpanel_mma_range(bld, cfg, a_frags, b_frags, accs, 0, count)


def _emit_dma_subpanel_phase0(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    types: _KernelTypes,
    staging: _LdsStaging,
    a_frags: tuple[dsl.Value, ...],
    b_frags: tuple[dsl.Value, ...],
    accs: tuple[dsl.Value, ...],
    b1_ptrs: tuple[dsl.Value, ...],
    access: dsl.Value,
    *,
    m_end: int | None = None,
) -> tuple[tuple[dsl.Value, ...], tuple[dsl.Value, ...], dsl.Value]:
    if m_end is None:
        m_end = len(a_frags)
    new_accs = list(accs)
    b1_frags: list[dsl.Value] = []
    b1_tokens: list[dsl.Value] = []
    for i in range(m_end):
        af = a_frags[i]
        for j, bf in enumerate(b_frags):
            index = _mma_acc_index(cfg, i, j)
            new_accs[index] = _emit_mma(bld, cfg, af, bf, new_accs[index])
            if i == 0:
                fragment, token = _read_dma_subpanel_fragment(
                    bld, b1_ptrs[j], access, types.b, staging
                )
                b1_frags.append(fragment)
                b1_tokens.append(token)
    return tuple(new_accs), tuple(b1_frags), _join_tokens(bld, b1_tokens)


def _emit_dma_subpanel_phase1_with_reads(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    types: _KernelTypes,
    staging: _LdsStaging,
    a_frags: tuple[dsl.Value, ...],
    b_frags: tuple[dsl.Value, ...],
    accs: tuple[dsl.Value, ...],
    access: dsl.Value,
    ready_read_bases: _DmaSubpanelReadBases,
    mma_begin: int,
) -> tuple[
    tuple[dsl.Value, ...],
    tuple[dsl.Value, ...],
    tuple[dsl.Value, ...],
    dsl.Value,
    dsl.Value,
]:
    ready_a_ptrs = _dma_phase_slice(
        _dma_subpanel_read_ptrs(
            bld, staging, ready_read_bases.a, staging.a_dma_read_offsets
        ),
        0,
        cfg.wave_k_tiles,
    )
    ready_b_ptrs = _dma_phase_slice(
        _dma_subpanel_read_ptrs(
            bld, staging, ready_read_bases.b, staging.b_dma_read_offsets
        ),
        0,
        cfg.wave_k_tiles,
    )
    reads: list[tuple[bool, dsl.Value]] = []
    for tile in range(max(len(ready_a_ptrs), len(ready_b_ptrs))):
        if tile < len(ready_a_ptrs):
            reads.append((True, ready_a_ptrs[tile]))
        if tile < len(ready_b_ptrs):
            reads.append((False, ready_b_ptrs[tile]))

    new_accs = list(accs)
    ready_a: list[dsl.Value] = []
    ready_b: list[dsl.Value] = []
    ready_a_tokens: list[dsl.Value] = []
    ready_b_tokens: list[dsl.Value] = []
    total_mmas = len(a_frags) * len(b_frags)
    read_span = total_mmas - mma_begin
    emitted = 0
    for ordinal in range(mma_begin, total_mmas):
        i, j = _serpentine_mma_coords(len(a_frags), ordinal)
        index = _mma_acc_index(cfg, i, j)
        new_accs[index] = _emit_mma(bld, cfg, a_frags[i], b_frags[j], new_accs[index])
        suffix_ordinal = ordinal - mma_begin + 1
        target = (suffix_ordinal * len(reads) + read_span - 1) // read_span
        while emitted < target:
            is_a, ptr = reads[emitted]
            fragment, token = _read_dma_subpanel_fragment(
                bld, ptr, access, types.a if is_a else types.b, staging
            )
            if is_a:
                ready_a.append(fragment)
                ready_a_tokens.append(token)
            else:
                ready_b.append(fragment)
                ready_b_tokens.append(token)
            emitted += 1
    if emitted != len(reads):
        raise ValueError("DMA subpanel read cadence did not emit all fragments")
    return (
        tuple(new_accs),
        tuple(ready_a),
        tuple(ready_b),
        _join_tokens(bld, ready_a_tokens),
        _join_tokens(bld, ready_b_tokens),
    )


def _emit_dma_subpanel_phase0_with_a1_reads(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    types: _KernelTypes,
    staging: _LdsStaging,
    a_frags: tuple[dsl.Value, ...],
    b_frags: tuple[dsl.Value, ...],
    accs: tuple[dsl.Value, ...],
    access: dsl.Value,
    current_read_base: dsl.Value,
    m_begin: int,
    m_end: int,
) -> tuple[tuple[dsl.Value, ...], tuple[dsl.Value, ...], dsl.Value]:
    a1_ptrs = _dma_phase_slice(
        _dma_subpanel_read_ptrs(
            bld, staging, current_read_base, staging.a_dma_read_offsets
        ),
        1,
        cfg.wave_k_tiles,
    )
    return _emit_dma_subpanel_rows_with_reads(
        bld,
        cfg,
        staging,
        a_frags,
        b_frags,
        accs,
        a1_ptrs,
        types.a,
        access,
        m_begin,
        m_end,
    )


def _emit_dma_subpanel_rows_with_reads(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    staging: _LdsStaging,
    a_frags: tuple[dsl.Value, ...],
    b_frags: tuple[dsl.Value, ...],
    accs: tuple[dsl.Value, ...],
    read_ptrs: tuple[dsl.Value, ...],
    read_type: dsl.Type,
    access: dsl.Value,
    m_begin: int,
    m_end: int,
    read_mma_span: int | None = None,
) -> tuple[tuple[dsl.Value, ...], tuple[dsl.Value, ...], dsl.Value]:
    return _emit_dma_subpanel_mma_range_with_reads(
        bld,
        cfg,
        staging,
        a_frags,
        b_frags,
        accs,
        read_ptrs,
        read_type,
        access,
        m_begin * len(b_frags),
        m_end * len(b_frags),
        read_mma_span,
    )


def _emit_dma_subpanel_mma_range_with_reads(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    staging: _LdsStaging,
    a_frags: tuple[dsl.Value, ...],
    b_frags: tuple[dsl.Value, ...],
    accs: tuple[dsl.Value, ...],
    read_ptrs: tuple[dsl.Value, ...],
    read_type: dsl.Type,
    access: dsl.Value,
    begin: int,
    end: int,
    read_mma_span: int | None = None,
) -> tuple[tuple[dsl.Value, ...], tuple[dsl.Value, ...], dsl.Value]:
    total = len(a_frags) * len(b_frags)
    if not 0 <= begin < end <= total:
        raise ValueError("MFMA range must fit the subpanel")
    new_accs = list(accs)
    read_frags: list[dsl.Value] = []
    read_tokens: list[dsl.Value] = []
    total_mmas = end - begin
    if read_mma_span is None:
        read_mma_span = total_mmas
    if not 0 < read_mma_span <= total_mmas:
        raise ValueError("read MMA span must fit the emitted MMA range")
    emitted = 0
    for local_ordinal, mma_ordinal in enumerate(range(begin, end), start=1):
        i, j = _serpentine_mma_coords(len(a_frags), mma_ordinal)
        index = _mma_acc_index(cfg, i, j)
        new_accs[index] = _emit_mma(bld, cfg, a_frags[i], b_frags[j], new_accs[index])
        read_ordinal = min(local_ordinal, read_mma_span)
        target = (read_ordinal * len(read_ptrs) + read_mma_span - 1) // read_mma_span
        while emitted < target:
            fragment, token = _read_dma_subpanel_fragment(
                bld, read_ptrs[emitted], access, read_type, staging
            )
            read_frags.append(fragment)
            read_tokens.append(token)
            emitted += 1
    return tuple(new_accs), tuple(read_frags), _join_tokens(bld, read_tokens)


def _emit_coalesced_dma_subpanel_reuse(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    types: _KernelTypes,
    staging: _LdsStaging,
    state: _DmaSubpanelLoopState,
    a_ptrs: tuple[dsl.Value, ...],
) -> _DmaSubpanelReuseState:
    a1_ptrs = _dma_phase_slice(
        _dma_subpanel_read_ptrs(
            bld,
            staging,
            state.current_read_bases.a,
            staging.a_dma_read_offsets,
        ),
        1,
        cfg.wave_k_tiles,
    )
    a_read_mmas = 2 * len(a1_ptrs)
    a_release_mmas = a_read_mmas + len(state.b_frags) - cfg.wave_k_tiles
    accs, a1_frags, a1_read = _emit_dma_subpanel_mma_range_with_reads(
        bld,
        cfg,
        staging,
        state.a_frags,
        state.b_frags,
        state.accs,
        a1_ptrs,
        types.a,
        state.current_access,
        0,
        a_release_mmas,
        read_mma_span=a_read_mmas,
    )
    a_reuse_access = bld.barrier(state.current_access, state.a_read, a1_read)
    next_a0 = _issue_dma_operand_phase(
        bld,
        cfg,
        a_ptrs,
        staging.a_dma_lds_byte_ptrs,
        0,
        a_reuse_access,
        lds_byte_base=state.current_dma_lds_byte_base,
        in_loop=True,
        request_offset=0,
    )
    a_phase_width = len(a_ptrs) // cfg.wave_k_tiles
    a1_early_width = max(1, a_phase_width // cfg.waves_per_workgroup)
    next_a1_early = _issue_dma_operand_phase_requests(
        bld,
        cfg,
        a_ptrs,
        staging.a_dma_lds_byte_ptrs,
        1,
        0,
        a1_early_width,
        a_reuse_access,
        lds_byte_base=state.current_dma_lds_byte_base,
        in_loop=True,
        request_offset=0,
    )

    b1_ptrs = _dma_phase_slice(
        _dma_subpanel_read_ptrs(
            bld,
            staging,
            state.current_read_bases.b,
            staging.b_dma_read_offsets,
        ),
        1,
        cfg.wave_k_tiles,
    )
    b_read_mmas = 2 * len(b1_ptrs) + cfg.wave_k_tiles + 3
    b_release_mmas = a_release_mmas + b_read_mmas + len(state.b_frags) + 1
    accs, b1_frags, b1_read = _emit_dma_subpanel_mma_range_with_reads(
        bld,
        cfg,
        staging,
        state.a_frags,
        state.b_frags,
        accs,
        b1_ptrs,
        types.b,
        a_reuse_access,
        a_release_mmas,
        b_release_mmas,
        read_mma_span=b_read_mmas,
    )
    b_reuse_access = bld.barrier(state.b_read, b1_read)
    return _DmaSubpanelReuseState(
        accs,
        a1_frags,
        b1_frags,
        b_reuse_access,
        next_a0,
        next_a1_early,
        b_release_mmas,
    )


def _emit_dma_subpanel_reuse(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    types: _KernelTypes,
    staging: _LdsStaging,
    state: _DmaSubpanelLoopState,
    a_ptrs: tuple[dsl.Value, ...],
) -> _DmaSubpanelReuseState:
    if cfg.coalesced_mfma_output:
        return _emit_coalesced_dma_subpanel_reuse(
            bld, cfg, types, staging, state, a_ptrs
        )
    current_b_ptrs = _dma_subpanel_read_ptrs(
        bld, staging, state.current_read_bases.b, staging.b_dma_read_offsets
    )
    b1_ptrs = _dma_phase_slice(current_b_ptrs, 1, cfg.wave_k_tiles)
    reuse_rows = max(1, (cfg.wave_m_tiles + 2) // 3)
    accs, b1_frags, b1_read = _emit_dma_subpanel_phase0(
        bld,
        cfg,
        types,
        staging,
        state.a_frags,
        state.b_frags,
        state.accs,
        b1_ptrs,
        state.current_access,
        m_end=reuse_rows,
    )

    a_reuse_access = bld.barrier(state.current_access, state.a_read)
    next_a0 = a_reuse_access
    if not cfg.coalesced_mfma_output:
        next_a0 = _issue_dma_operand_phase(
            bld,
            cfg,
            a_ptrs,
            staging.a_dma_lds_byte_ptrs,
            0,
            a_reuse_access,
            lds_byte_base=state.current_dma_lds_byte_base,
            in_loop=True,
            request_offset=0,
        )
    release_rows = min(cfg.wave_m_tiles, 2 * reuse_rows)
    accs, a1_frags, a1_read = _emit_dma_subpanel_phase0_with_a1_reads(
        bld,
        cfg,
        types,
        staging,
        state.a_frags,
        state.b_frags,
        accs,
        a_reuse_access,
        state.current_read_bases.a,
        reuse_rows,
        release_rows,
    )

    reuse_access = bld.barrier(state.b_read, a1_read, b1_read)
    return _DmaSubpanelReuseState(
        accs,
        a1_frags,
        b1_frags,
        reuse_access,
        next_a0,
        None,
        release_rows * len(state.b_frags),
    )


def _issue_next_dma_subpanel_a(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    staging: _LdsStaging,
    state: _DmaSubpanelLoopState,
    reuse: _DmaSubpanelReuseState,
    a_ptrs: tuple[dsl.Value, ...],
) -> tuple[dsl.Value, dsl.Value]:
    next_a0 = reuse.next_a0
    if reuse.next_a1_early is None:
        next_a1 = _issue_dma_operand_phase(
            bld,
            cfg,
            a_ptrs,
            staging.a_dma_lds_byte_ptrs,
            1,
            reuse.reuse_access,
            lds_byte_base=state.current_dma_lds_byte_base,
            in_loop=True,
            request_offset=0,
        )
        return next_a0, next_a1

    a_phase_width = len(a_ptrs) // cfg.wave_k_tiles
    a1_early_width = max(1, a_phase_width // cfg.waves_per_workgroup)
    next_a1_late = _issue_dma_operand_phase_requests(
        bld,
        cfg,
        a_ptrs,
        staging.a_dma_lds_byte_ptrs,
        1,
        a1_early_width,
        a_phase_width,
        reuse.reuse_access,
        lds_byte_base=state.current_dma_lds_byte_base,
        in_loop=True,
        request_offset=0,
    )
    return next_a0, bld.join(reuse.next_a1_early, next_a1_late)


def _issue_next_dma_subpanel_b_prefix(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    staging: _LdsStaging,
    state: _DmaSubpanelLoopState,
    reuse: _DmaSubpanelReuseState,
    a_ptrs: tuple[dsl.Value, ...],
    b_ptrs: tuple[dsl.Value, ...],
) -> tuple[dsl.Value, dsl.Value, int, int]:
    request_offset = len(a_ptrs)
    next_b0 = _issue_dma_operand_phase(
        bld,
        cfg,
        b_ptrs,
        staging.b_dma_lds_byte_ptrs,
        0,
        reuse.reuse_access,
        lds_byte_base=state.current_dma_lds_byte_base,
        in_loop=True,
        request_offset=request_offset,
    )
    phase_width = len(b_ptrs) // cfg.wave_k_tiles
    early_width = max(1, phase_width // cfg.waves_per_workgroup)
    next_b1_early = _issue_dma_operand_phase_requests(
        bld,
        cfg,
        b_ptrs,
        staging.b_dma_lds_byte_ptrs,
        1,
        0,
        early_width,
        reuse.reuse_access,
        lds_byte_base=state.current_dma_lds_byte_base,
        in_loop=True,
        request_offset=request_offset,
    )
    return next_b0, next_b1_early, phase_width, early_width


def _finish_dma_subpanel_step(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    types: _KernelTypes,
    staging: _LdsStaging,
    state: _DmaSubpanelLoopState,
    reuse: _DmaSubpanelReuseState,
    a_ptrs: tuple[dsl.Value, ...],
    b_ptrs: tuple[dsl.Value, ...],
    next_dma_lds_byte_base: dsl.Value,
) -> tuple[dsl.Value, ...]:
    next_a0, next_a1 = _issue_next_dma_subpanel_a(
        bld, cfg, staging, state, reuse, a_ptrs
    )
    next_b0, next_b1_early, b_phase_width, b1_early_width = (
        _issue_next_dma_subpanel_b_prefix(
            bld, cfg, staging, state, reuse, a_ptrs, b_ptrs
        )
    )
    accs = _emit_dma_subpanel_mma_range(
        bld,
        cfg,
        state.a_frags,
        state.b_frags,
        reuse.accs,
        reuse.release_mmas,
        len(state.a_frags) * len(state.b_frags),
    )
    ready_read_count = (
        len(staging.a_dma_read_offsets) + len(staging.b_dma_read_offsets)
    ) // cfg.wave_k_tiles
    phase1_mmas = len(reuse.a1_frags) * len(reuse.b1_frags)
    read_suffix_mmas = min(phase1_mmas, 2 * ready_read_count + 3)
    phase1_prefix_mmas = phase1_mmas - read_suffix_mmas
    accs = _emit_dma_subpanel_mma_prefix(
        bld,
        cfg,
        reuse.a1_frags,
        reuse.b1_frags,
        accs,
        phase1_prefix_mmas,
    )
    ready_access = bld.barrier(*_flatten_dma_subpanel_tokens(state.ready))
    late_access = bld.join(reuse.reuse_access, ready_access)
    next_b1_late = _issue_dma_operand_phase_requests(
        bld,
        cfg,
        b_ptrs,
        staging.b_dma_lds_byte_ptrs,
        1,
        b1_early_width,
        b_phase_width,
        late_access,
        lds_byte_base=state.current_dma_lds_byte_base,
        in_loop=True,
        request_offset=len(a_ptrs),
    )
    ready_read_bases, ready_lds_offset = _next_dma_subpanel_read_state(
        bld, cfg, staging, state.current_lds_offset
    )
    accs, ready_a, ready_b, ready_a_read, ready_b_read = (
        _emit_dma_subpanel_phase1_with_reads(
            bld,
            cfg,
            types,
            staging,
            reuse.a1_frags,
            reuse.b1_frags,
            accs,
            ready_access,
            ready_read_bases,
            phase1_prefix_mmas,
        )
    )
    next_b1 = bld.join(next_b1_early, next_b1_late)
    return (
        *accs,
        *ready_a,
        *ready_b,
        ready_a_read,
        ready_b_read,
        ready_access,
        ready_read_bases.a,
        ready_read_bases.b,
        ready_lds_offset,
        next_dma_lds_byte_base,
        *_flatten_dma_subpanel_tokens(
            _DmaSubpanelTokens(
                (next_a0, next_a1),
                (next_b0, next_b1),
            )
        ),
    )


def _emit_dma_subpanel_step(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    types: _KernelTypes,
    staging: _LdsStaging,
    state: _DmaSubpanelLoopState,
    a_ptrs: tuple[dsl.Value, ...],
    b_ptrs: tuple[dsl.Value, ...],
    loop_iv: dsl.Value,
) -> tuple[dsl.Value, ...]:
    reuse = _emit_dma_subpanel_reuse(
        bld,
        cfg,
        types,
        staging,
        state,
        a_ptrs,
    )
    next_dma_lds_byte_base = _dma_subpanel_lds_byte_base(
        bld, cfg, staging, bld.addi(loop_iv, bld.constant(dsl.i32(), 1))
    )
    return _finish_dma_subpanel_step(
        bld,
        cfg,
        types,
        staging,
        state,
        reuse,
        a_ptrs,
        b_ptrs,
        next_dma_lds_byte_base,
    )


def _drain_dma_subpanel_tile(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    types: _KernelTypes,
    staging: _LdsStaging,
    ready: _DmaSubpanelTokens,
    accs: tuple[dsl.Value, ...],
    read_bases: _DmaSubpanelReadBases,
) -> tuple[dsl.Value, ...]:
    access = bld.barrier(*_flatten_dma_subpanel_tokens(ready))
    a0, _ = _read_dma_subpanel(
        bld,
        cfg,
        read_bases.a,
        staging.a_dma_read_offsets,
        0,
        access,
        types.a,
        staging,
    )
    b0, _ = _read_dma_subpanel(
        bld,
        cfg,
        read_bases.b,
        staging.b_dma_read_offsets,
        0,
        access,
        types.b,
        staging,
    )
    b_ptrs = _dma_subpanel_read_ptrs(
        bld, staging, read_bases.b, staging.b_dma_read_offsets
    )
    b1_ptrs = _dma_phase_slice(b_ptrs, 1, cfg.wave_k_tiles)
    accs, b1, _ = _emit_dma_subpanel_phase0(
        bld, cfg, types, staging, a0, b0, accs, b1_ptrs, access
    )
    a1, _ = _read_dma_subpanel(
        bld,
        cfg,
        read_bases.a,
        staging.a_dma_read_offsets,
        1,
        access,
        types.a,
        staging,
    )
    return _emit_dma_subpanel_mmas(bld, cfg, a1, b1, accs)


def _emit_dma_subpanel_tail(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    types: _KernelTypes,
    staging: _LdsStaging,
    state: _DmaSubpanelLoopState,
) -> tuple[dsl.Value, ...]:
    current_b_ptrs = _dma_subpanel_read_ptrs(
        bld, staging, state.current_read_bases.b, staging.b_dma_read_offsets
    )
    b1_ptrs = _dma_phase_slice(current_b_ptrs, 1, cfg.wave_k_tiles)
    accs, b1, _ = _emit_dma_subpanel_phase0(
        bld,
        cfg,
        types,
        staging,
        state.a_frags,
        state.b_frags,
        state.accs,
        b1_ptrs,
        state.current_access,
    )
    a1, _ = _read_dma_subpanel(
        bld,
        cfg,
        state.current_read_bases.a,
        staging.a_dma_read_offsets,
        1,
        state.current_access,
        types.a,
        staging,
    )
    accs = _emit_dma_subpanel_mmas(bld, cfg, a1, b1, accs)
    ready_read_bases, _ = _next_dma_subpanel_read_state(
        bld, cfg, staging, state.current_lds_offset
    )
    return _drain_dma_subpanel_tile(
        bld, cfg, types, staging, state.ready, accs, ready_read_bases
    )


def _init_dma_subpanel_kernel(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    types: _KernelTypes,
    staging: _LdsStaging,
) -> tuple[tuple[dsl.Value, ...], _DmaSubpanelTokens, _DmaSubpanelTokens]:
    root = bld.token()
    roots = tuple(root for _ in range(cfg.wave_k_tiles))
    empty = _DmaSubpanelTokens(roots, roots)
    first_dma_lds_byte_base = _dma_subpanel_lds_byte_base(bld, cfg, staging, 0)
    first_ready = _issue_dma_subpanels(
        bld,
        cfg,
        staging.a_dma_src_ptrs,
        staging.b_dma_src_ptrs,
        staging,
        empty,
        lds_byte_base=first_dma_lds_byte_base,
        in_loop=False,
    )
    init_acc = bld.fragment_fill(bld.constant(dsl.i32(), 0), types.acc)
    init_accs = tuple(init_acc for _ in range(cfg.tiles_per_wave))
    return init_accs, first_ready, empty


def _init_dma_subpanel_loop(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    types: _KernelTypes,
    staging: _LdsStaging,
    first_ready: _DmaSubpanelTokens,
    empty: _DmaSubpanelTokens,
    init_accs: tuple[dsl.Value, ...],
    virtual_k_stride: dsl.Value,
) -> tuple[dsl.Value, ...]:
    current_read_bases = _dma_subpanel_read_bases(bld, staging, 0)
    current_lds_offset = bld.constant(dsl.i32(), 0)
    current_dma_lds_byte_base = _dma_subpanel_lds_byte_base(bld, cfg, staging, 0)
    second_a_ptrs = _advance_ptrs(bld, staging.a_dma_src_ptrs, virtual_k_stride)
    second_b_ptrs = _advance_ptrs(bld, staging.b_dma_src_ptrs, virtual_k_stride)
    second_dma_lds_byte_base = _dma_subpanel_lds_byte_base(bld, cfg, staging, 1)
    second_ready = _issue_dma_subpanels(
        bld,
        cfg,
        second_a_ptrs,
        second_b_ptrs,
        staging,
        empty,
        lds_byte_base=second_dma_lds_byte_base,
        in_loop=False,
        request_offset=len(second_a_ptrs) + len(second_b_ptrs),
    )
    first_access = bld.barrier(*_flatten_dma_subpanel_tokens(first_ready))
    first_a, first_a_read = _read_dma_subpanel(
        bld,
        cfg,
        current_read_bases.a,
        staging.a_dma_read_offsets,
        0,
        first_access,
        types.a,
        staging,
    )
    first_b, first_b_read = _read_dma_subpanel(
        bld,
        cfg,
        current_read_bases.b,
        staging.b_dma_read_offsets,
        0,
        first_access,
        types.b,
        staging,
    )
    return (
        *init_accs,
        *first_a,
        *first_b,
        first_a_read,
        first_b_read,
        first_access,
        current_read_bases.a,
        current_read_bases.b,
        current_lds_offset,
        current_dma_lds_byte_base,
        *_flatten_dma_subpanel_tokens(second_ready),
    )


def _emit_dma_subpanel_loop(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    types: _KernelTypes,
    staging: _LdsStaging,
    virtual_k_stride: dsl.Value,
    init_args: tuple[dsl.Value, ...],
) -> tuple[dsl.Value, ...]:
    zero = bld.constant(dsl.i32(), 0)
    one = bld.constant(dsl.i32(), 1)
    trip_count = bld.constant(dsl.i32(), max(cfg.virtual_k_steps - 2, 0))
    loop_a_ptrs = _advance_ptrs(bld, staging.a_dma_src_ptrs, virtual_k_stride)
    loop_b_ptrs = _advance_ptrs(bld, staging.b_dma_src_ptrs, virtual_k_stride)
    state_count = len(init_args)
    a_count = len(loop_a_ptrs)
    loop_init_args = (*init_args, *loop_a_ptrs, *loop_b_ptrs)
    with bld.for_loop(zero, trip_count, one, init_args=loop_init_args) as forop:
        _attach_phased_dma_loop_attrs(forop, cfg)
        loop_args = tuple(forop.inner_iter_args)
        state = _split_dma_subpanel_loop_state(loop_args[:state_count], cfg)
        loop_iv = forop.induction_variable
        previous_a_ptrs = loop_args[state_count : state_count + a_count]
        previous_b_ptrs = loop_args[state_count + a_count :]
        a_ptrs = _advance_ptrs(bld, previous_a_ptrs, virtual_k_stride)
        b_ptrs = _advance_ptrs(bld, previous_b_ptrs, virtual_k_stride)
        step_results = _emit_dma_subpanel_step(
            bld,
            cfg,
            types,
            staging,
            state,
            a_ptrs,
            b_ptrs,
            loop_iv,
        )
        bld.yield_((*step_results, *a_ptrs, *b_ptrs))

    final_state = _split_dma_subpanel_loop_state(
        tuple(forop.results)[:state_count], cfg
    )
    return _emit_dma_subpanel_tail(bld, cfg, types, staging, final_state)


def _emit_dma_subpanel_kernel(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    types: _KernelTypes,
    staging: _LdsStaging,
    ptrs: _TilePtrs,
    virtual_k_stride: dsl.Value,
) -> None:
    init_accs, first_ready, empty = _init_dma_subpanel_kernel(bld, cfg, types, staging)
    if cfg.virtual_k_steps == 1:
        final_accs = _drain_dma_subpanel_tile(
            bld,
            cfg,
            types,
            staging,
            first_ready,
            init_accs,
            _dma_subpanel_read_bases(bld, staging, 0),
        )
    else:
        init_args = _init_dma_subpanel_loop(
            bld,
            cfg,
            types,
            staging,
            first_ready,
            empty,
            init_accs,
            virtual_k_stride,
        )
        final_accs = _emit_dma_subpanel_loop(
            bld, cfg, types, staging, virtual_k_stride, init_args
        )
    _store_acc_tiles(bld, cfg, final_accs, ptrs.c, 0, cfg.wave_n_tiles)


def _dma_loop_offsets(
    bld: dsl.FunctionBuilder, cfg: _MatmulConfig, loop_iv: dsl.Value
) -> tuple[int | dsl.Value, int | dsl.Value, int | dsl.Value]:
    if not cfg.use_dma_lds:
        return 0, 0, 0
    current = _dma_buffer_offset(bld, cfg, loop_iv)
    ready = _dma_buffer_offset(bld, cfg, bld.addi(loop_iv, bld.constant(dsl.i32(), 1)))
    next_offset = _dma_buffer_offset(
        bld, cfg, bld.addi(loop_iv, bld.constant(dsl.i32(), 2))
    )
    return current, ready, next_offset


def _kernel_loop_trip_count(bld: dsl.FunctionBuilder, cfg: _MatmulConfig) -> dsl.Value:
    if cfg.use_dma_lds and cfg.virtual_k_steps > 1:
        return bld.constant(dsl.i32(), max(cfg.virtual_k_steps - 2, 0))
    trip_count = _kernel_trip_count_source(bld, cfg)
    if len(bld.args) > cfg.trip_count_arg_index:
        trip_count = bld.assume_range(trip_count, 0, max(cfg.virtual_k_steps - 1, 0))
    return trip_count


def _emit_kernel(bld: dsl.FunctionBuilder, cfg: _MatmulConfig) -> None:
    """Populate tiled matmul kernel body."""
    coords = _emit_tile_coords(bld, cfg)
    types = _kernel_types(cfg)
    staging = _emit_lds_staging(bld, cfg, coords)
    virtual_k_stride = bld.constant(dsl.i32(), cfg.storage_k_tile * cfg.wave_k_tiles)
    ptrs = _initial_tile_ptrs(bld, cfg, coords)
    if _uses_dma_subpanel_pipeline(cfg):
        _emit_dma_subpanel_kernel(bld, cfg, types, staging, ptrs, virtual_k_stride)
        return
    init_args = _initial_loop_args(
        bld, cfg, types, staging, coords, ptrs, virtual_k_stride
    )
    if cfg.use_dma_lds and cfg.virtual_k_steps == 1:
        _store_final_tiles(
            bld, cfg, _split_loop_state(tuple(init_args), cfg), coords, ptrs.c, 0
        )
        return

    trip_count_i32 = _kernel_loop_trip_count(bld, cfg)
    zero_i32 = bld.constant(dsl.i32(), 0)
    one_i32 = bld.constant(dsl.i32(), 1)

    with bld.for_loop(
        zero_i32,
        trip_count_i32,
        one_i32,
        init_args=init_args,
    ) as forop:
        _attach_phased_dma_loop_attrs(forop, cfg)
        state = _split_loop_state(tuple(forop.inner_iter_args), cfg)
        loop_iv = forop.induction_variable
        a_ptrs, b_ptrs = _load_ptrs_for_step(
            bld,
            cfg,
            staging,
            ptrs,
            loop_iv,
            virtual_k_stride,
            step_base=2 if cfg.use_dma_lds else 1,
        )
        current_lds_offset, ready_lds_offset, next_lds_offset = _dma_loop_offsets(
            bld, cfg, loop_iv
        )
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
        final_scale_lds_offset = (
            _scale_buffer_offset(bld, cfg, final_scale_step)
            if cfg.uses_packed_mxfp4
            else _dma_buffer_offset(bld, cfg, final_scale_step)
        )
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
    mxfp4_scale_path: str,
    random_data: bool,
    random_seed: int,
    cta_swizzle_xcds: int,
    cta_group_m: int,
    output_store_cache: str = "none",
    target_waves: int | None = None,
    enable_split_barriers: bool = False,
    enable_multi_wave_specialization: bool = False,
    phased_dma_schedule: PhasedDmaSchedule | None = None,
    coalesced_mfma_output: bool = False,
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
        output_store_cache=output_store_cache,
        mxfp4_scale_path=mxfp4_scale_path,
        random_data=random_data,
        random_seed=random_seed,
        cta_swizzle_xcds=cta_swizzle_xcds,
        cta_group_m=cta_group_m,
        target_waves=target_waves,
        enable_split_barriers=enable_split_barriers,
        enable_multi_wave_specialization=enable_multi_wave_specialization,
        phased_dma_schedule=phased_dma_schedule,
        coalesced_mfma_output=coalesced_mfma_output,
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
    output_store_cache: str = "none",
    mxfp4_scale_path: str = "dma",
    random_data: bool = False,
    random_seed: int = 0,
    cta_swizzle_xcds: int = 1,
    cta_group_m: int = 1,
    skip_specialize: bool = False,
    target_waves: int | None = None,
    enable_split_barriers: bool = False,
    enable_multi_wave_specialization: bool = False,
    phased_dma_schedule: PhasedDmaSchedule | None = None,
    coalesced_mfma_output: bool = False,
    include_host: bool = True,
) -> Module:
    """Return an MLIR module for tiled matmul."""
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
        output_store_cache=output_store_cache,
        mxfp4_scale_path=mxfp4_scale_path,
        random_data=random_data,
        random_seed=random_seed,
        cta_swizzle_xcds=cta_swizzle_xcds,
        cta_group_m=cta_group_m,
        target_waves=target_waves,
        enable_split_barriers=enable_split_barriers,
        enable_multi_wave_specialization=enable_multi_wave_specialization,
        phased_dma_schedule=phased_dma_schedule,
        coalesced_mfma_output=coalesced_mfma_output,
    )
    bld = dsl.ModuleBuilder()
    with bld:
        _declare_matmul_externals(bld, cfg)
        with (
            bld.gpu_module(_GPU_MODULE_NAME) as gmod,
            gmod.kernel(
                _KERNEL_NAME,
                _kernel_input_types(cfg),
                lds_size=_fixed_lds_bytes(cfg),
                workgroup_size=[cfg.threads_per_workgroup, 1, 1],
                attrs=_kernel_attrs(cfg, target_waves),
            ) as fb,
        ):
            _emit_kernel(fb, cfg)

        if include_host:
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
    "PhasedDmaSchedule",
    "build_wmma_f16_matmul_module",
    "compute_wmma_f16_matmul_reference_buffer",
    "generate_mxfp4_packed_matmul_inputs",
    "generate_mxfp4_scale_inputs",
    "generate_wmma_f16_matmul_inputs",
]
