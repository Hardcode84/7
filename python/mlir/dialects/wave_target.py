#  Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
#  See https://llvm.org/LICENSE.txt for license information.
#  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

"""AMDGPU matmul target profiles backed by LLVM target descriptions."""

from __future__ import annotations

from dataclasses import dataclass
from enum import Enum
from functools import cache

from mlir._mlir_libs import _waveDialectsNanobind as _wave_ext
from mlir.dialects import waveamd

GFX1250_CHIP = "gfx1250"
GFX1250_MATRIX_INTRINSIC = "wmma_gfx1250"
MATRIX_INTRINSIC_CHOICES = (
    "auto",
    "wmma",
    "mfma",
    "mfma_gfx950",
    GFX1250_MATRIX_INTRINSIC,
)

_GFX950_CHIP = "gfx950"


class MemoryStaging(Enum):
    BASE = "base"


@dataclass(frozen=True)
class MmaProfile:
    kind: waveamd.MmaKind
    m_tile: int
    n_tile: int
    k_tile: int
    operand_dwords: int
    accumulator_dwords: int
    operand_alignment: int
    accumulator_alignment: int
    lane_k_elements: int
    operand_bank: _wave_ext.RegClass
    accumulator_bank: _wave_ext.RegClass

    @property
    def kind_name(self) -> str:
        return str(self.kind)


@dataclass(frozen=True)
class MatmulTargetProfile:
    chip: str
    matrix_intrinsic: str
    wave_size: int
    local_memory_bytes: int
    addressable_local_memory_bytes: int
    local_memory_bank_count: int
    addressable_vgprs: int
    addressable_agprs: int
    vgpr_allocation_granule: int
    vgpr_tuple_alignment: int
    max_waves_per_eu: int
    staging: MemoryStaging
    f16_mma: MmaProfile
    bf16_mma: MmaProfile

    @property
    def accumulator_bank(self) -> _wave_ext.RegClass:
        return self.f16_mma.accumulator_bank

    @property
    def static_lds_limit_bytes(self) -> int:
        return self.addressable_local_memory_bytes

    def mma(self, input_type: str) -> MmaProfile:
        if input_type == "f16":
            return self.f16_mma
        if input_type == "bf16":
            return self.bf16_mma
        raise ValueError(f"{self.chip} profile does not support {input_type} MMA")


def _mma_profile(chip: str, kind: waveamd.MmaKind) -> MmaProfile:
    capabilities = _wave_ext.get_mma_capabilities(chip, kind)
    if capabilities is None:
        raise RuntimeError(f"LLVM does not expose {kind} capabilities for {chip}")
    return MmaProfile(
        kind=kind,
        m_tile=capabilities.m_tile,
        n_tile=capabilities.n_tile,
        k_tile=capabilities.k_tile,
        operand_dwords=capabilities.operand_dwords,
        accumulator_dwords=capabilities.accumulator_dwords,
        operand_alignment=capabilities.operand_alignment,
        accumulator_alignment=capabilities.accumulator_alignment,
        lane_k_elements=capabilities.lane_k_elements,
        operand_bank=capabilities.operand_bank,
        accumulator_bank=capabilities.accumulator_bank,
    )


@cache
def get_matmul_target_profile(chip: str) -> MatmulTargetProfile | None:
    if chip != GFX1250_CHIP:
        return None
    capabilities = _wave_ext.get_target_capabilities(chip)
    if capabilities is None:
        return None
    if capabilities.matrix_family != _wave_ext.MatrixFamily.Gfx1250:
        return None

    f16_mma = _mma_profile(
        chip,
        waveamd.MmaKind.WmmaF32_16x16x32_F16,
    )
    bf16_mma = _mma_profile(
        chip,
        waveamd.MmaKind.WmmaF32_16x16x32_BF16,
    )
    if (
        f16_mma.operand_bank != bf16_mma.operand_bank
        or f16_mma.accumulator_bank != bf16_mma.accumulator_bank
    ):
        raise RuntimeError(f"LLVM reports inconsistent {chip} WMMA register banks")
    return MatmulTargetProfile(
        chip=chip,
        matrix_intrinsic=GFX1250_MATRIX_INTRINSIC,
        wave_size=capabilities.default_wavefront_size,
        local_memory_bytes=capabilities.local_memory_bytes,
        addressable_local_memory_bytes=capabilities.addressable_local_memory_bytes,
        local_memory_bank_count=capabilities.local_memory_bank_count,
        addressable_vgprs=capabilities.addressable_vgprs,
        addressable_agprs=capabilities.addressable_agprs,
        vgpr_allocation_granule=capabilities.vgpr_allocation_granule,
        vgpr_tuple_alignment=capabilities.vgpr_tuple_alignment,
        max_waves_per_eu=capabilities.max_waves_per_eu,
        staging=MemoryStaging.BASE,
        f16_mma=f16_mma,
        bf16_mma=bf16_mma,
    )


def require_matmul_target_profile(chip: str) -> MatmulTargetProfile:
    profile = get_matmul_target_profile(chip)
    if profile is None:
        raise ValueError(f"no matmul target profile for {chip}")
    return profile


def select_matrix_intrinsic(chip: str, requested: str) -> str:
    if requested not in MATRIX_INTRINSIC_CHOICES:
        choices = ", ".join(MATRIX_INTRINSIC_CHOICES)
        raise ValueError(f"unknown matrix intrinsic {requested}; expected {choices}")

    profile = get_matmul_target_profile(chip)
    if profile is not None:
        expected = profile.matrix_intrinsic
    elif not chip:
        return "wmma" if requested == "auto" else requested
    elif chip == _GFX950_CHIP:
        expected = "mfma_gfx950"
    elif chip.startswith("gfx9"):
        expected = "mfma"
    elif chip.startswith("gfx11"):
        expected = "wmma"
    else:
        raise ValueError(f"no matrix intrinsic profile for target {chip}")

    if requested not in ("auto", expected):
        raise ValueError(
            f"matrix intrinsic {requested} is incompatible with {chip}; "
            f"expected {expected}"
        )
    return expected
