#!/usr/bin/env python3
#  Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
#  See https://llvm.org/LICENSE.txt for license information.
#  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

"""Emit a gfx950 MXFP4 Wave kernel shaped after TensileLite subtile GEMM."""

from __future__ import annotations

import argparse
import sys
from collections.abc import Callable
from dataclasses import dataclass

from common import dump_kernel_asm, ensure_package_on_path

ensure_package_on_path("mlir.dialects.wave_dsl")

from mlir.dialects import wave, waveamd  # noqa: E402
from mlir.dialects import wave_dsl as dsl  # noqa: E402
from mlir.ir import Attribute, Module  # noqa: E402

_GPU_MODULE_NAME = "kernels"
_KERNEL_NAME = "wmma_f16_matmul_tiled"
_TARGET_WAVES_ATTR = "waveamdmachine.target_waves"
_DYNAMIC_LDS_ATTR = "wave.dynamic_lds_size"
_STATIC_LDS_LIMIT = 64 * 1024
_WAVE_SIZE = 64
_MMA_K = 128
_MX_BLOCK = 32
_AB_REGS = 4
_ACC_REGS = 4
_SCALE_GROUP_BYTES = 256


@dataclass(frozen=True)
class Config:
    m: int
    n: int
    k: int
    bm: int
    bn: int
    wave_m_tiles: int
    wave_n_tiles: int
    wave_k_tiles: int
    target_waves: int
    scale_input: str

    @property
    def waves_per_workgroup(self) -> int:
        return self.bm * self.bn

    @property
    def threads_per_workgroup(self) -> int:
        return _WAVE_SIZE * self.waves_per_workgroup

    @property
    def block_m_tiles(self) -> int:
        return self.bm * self.wave_m_tiles

    @property
    def block_n_tiles(self) -> int:
        return self.bn * self.wave_n_tiles

    @property
    def m_blocks(self) -> int:
        return self.m // (16 * self.block_m_tiles)

    @property
    def n_blocks(self) -> int:
        return self.n // (16 * self.block_n_tiles)

    @property
    def storage_k(self) -> int:
        return self.k // 2

    @property
    def storage_k_tile(self) -> int:
        return _MMA_K // 2

    @property
    def storage_lane_k_bytes(self) -> int:
        return _MX_BLOCK // 2

    @property
    def storage_k_tile_dwords(self) -> int:
        return self.storage_k_tile // 4

    @property
    def storage_lane_k_dwords(self) -> int:
        return self.storage_lane_k_bytes // 4

    @property
    def k_steps(self) -> int:
        return self.k // _MMA_K

    @property
    def virtual_k_steps(self) -> int:
        return self.k_steps // self.wave_k_tiles

    @property
    def tiles_per_wave(self) -> int:
        return self.wave_m_tiles * self.wave_n_tiles

    @property
    def a_elements(self) -> int:
        return self.m * self.storage_k

    @property
    def b_elements(self) -> int:
        return self.n * self.storage_k

    @property
    def c_elements(self) -> int:
        return self.m * self.n

    @property
    def scale_groups(self) -> int:
        return self.k // _MX_BLOCK

    @property
    def canonical_a_scale_elements(self) -> int:
        return self.m * self.scale_groups

    @property
    def canonical_b_scale_elements(self) -> int:
        return self.n * self.scale_groups

    @property
    def a_data_slots(self) -> int:
        return self.wave_k_tiles * self.block_m_tiles

    @property
    def b_data_slots(self) -> int:
        return self.wave_k_tiles * self.block_n_tiles

    @property
    def dwords_per_data_slot(self) -> int:
        return _AB_REGS * _WAVE_SIZE

    @property
    def data_stage_lds_bytes(self) -> int:
        return (self.a_data_slots + self.b_data_slots) * self.dwords_per_data_slot * 4

    @property
    def data_stage_lds_dwords(self) -> int:
        return self.data_stage_lds_bytes // 4

    @property
    def data_lds_bytes(self) -> int:
        return 2 * self.data_stage_lds_bytes

    @property
    def k_scale_groups_per_step(self) -> int:
        return self.wave_k_tiles // 2

    @property
    def a_scale_groups_per_partition(self) -> int:
        return (self.wave_m_tiles // 2) * self.k_scale_groups_per_step

    @property
    def b_scale_groups_per_partition(self) -> int:
        return (self.wave_n_tiles // 2) * self.k_scale_groups_per_step

    @property
    def a_scale_partition_bytes(self) -> int:
        return self.a_scale_groups_per_partition * _SCALE_GROUP_BYTES

    @property
    def b_scale_partition_bytes(self) -> int:
        return self.b_scale_groups_per_partition * _SCALE_GROUP_BYTES

    @property
    def scale_lds_base(self) -> int:
        return self.data_lds_bytes

    @property
    def scale_a_lds_base(self) -> int:
        return self.scale_lds_base

    @property
    def scale_b_lds_base(self) -> int:
        return self.scale_a_lds_base + self.bm * self.a_scale_partition_bytes

    @property
    def scale_stage_lds_bytes(self) -> int:
        return (
            self.bm * self.a_scale_partition_bytes
            + self.bn * self.b_scale_partition_bytes
        )

    @property
    def scale_stage_lds_dwords(self) -> int:
        return self.scale_stage_lds_bytes // 4

    @property
    def scale_lds_bytes(self) -> int:
        return 2 * self.scale_stage_lds_bytes

    @property
    def lds_bytes(self) -> int:
        return self.data_lds_bytes + self.scale_lds_bytes

    @property
    def dynamic_lds_bytes(self) -> int:
        return self.lds_bytes if self.lds_bytes >= _STATIC_LDS_LIMIT else 0

    @property
    def fixed_lds_bytes(self) -> int:
        return 0 if self.dynamic_lds_bytes else self.lds_bytes


@dataclass(frozen=True)
class Coords:
    wi: dsl.Value
    wg_m: dsl.Value
    wg_n: dsl.Value


@dataclass(frozen=True)
class DataPtrs:
    a_src: tuple[dsl.Value, ...]
    b_src: tuple[dsl.Value, ...]
    a_dest: tuple[dsl.Value, ...]
    b_dest: tuple[dsl.Value, ...]
    a_read: tuple[dsl.Value, ...]
    b_read: tuple[dsl.Value, ...]


@dataclass(frozen=True)
class DmaRequest:
    src: dsl.Value
    dest: dsl.Value
    bytes: int
    zero_fill_inactive: bool = False


@dataclass(frozen=True)
class StageState:
    ready: dsl.Value
    a_frags: tuple[dsl.Value, ...]
    b_frags: tuple[dsl.Value, ...]
    a_scales: tuple[dsl.Value, ...]
    b_scales: tuple[dsl.Value, ...]


def _reject_if(cond: bool, message: str) -> None:
    if cond:
        raise ValueError(message)


def _validate_config(cfg: Config) -> None:
    _reject_if(
        cfg.scale_input not in ("canonical", "tensilelite"),
        "--scale-input must be canonical or tensilelite",
    )
    for name, value in (
        ("m", cfg.m),
        ("n", cfg.n),
        ("k", cfg.k),
        ("bm", cfg.bm),
        ("bn", cfg.bn),
        ("wave_m_tiles", cfg.wave_m_tiles),
        ("wave_n_tiles", cfg.wave_n_tiles),
        ("wave_k_tiles", cfg.wave_k_tiles),
    ):
        _reject_if(value <= 0, f"{name} must be positive")
    _reject_if(cfg.k % _MMA_K != 0, "k must divide by 128")
    _reject_if(cfg.k_steps % cfg.wave_k_tiles != 0, "wave_k_tiles must divide k/128")
    _reject_if(
        cfg.wave_k_tiles % 2 != 0,
        "wave_k_tiles must be even for 2x2 scale groups",
    )
    _reject_if(
        cfg.scale_input == "tensilelite" and cfg.wave_k_tiles != 2,
        "tensilelite subtile example models the 2-pass TensileLite mainloop",
    )
    _reject_if(
        cfg.scale_input == "tensilelite"
        and cfg.virtual_k_steps > 1
        and cfg.virtual_k_steps % 2 != 0,
        "tensilelite subtile example models PGR2 and requires even virtual K steps",
    )
    _reject_if(
        cfg.wave_m_tiles % 2 != 0 or cfg.wave_n_tiles % 2 != 0,
        "wave M/N tiles must be even for 2x2 scale groups",
    )
    _reject_if(
        (cfg.m // 16) % cfg.block_m_tiles != 0, "bm * wave_m_tiles must divide m/16"
    )
    _reject_if(
        (cfg.n // 16) % cfg.block_n_tiles != 0, "bn * wave_n_tiles must divide n/16"
    )
    _reject_if(
        cfg.a_data_slots % cfg.waves_per_workgroup != 0,
        "A DTL slots must divide evenly across waves",
    )
    _reject_if(
        cfg.b_data_slots % cfg.waves_per_workgroup != 0,
        "B DTL slots must divide evenly across waves",
    )
    _reject_if(cfg.target_waves < 0, "target_waves must be non-negative")


def _kernel_attrs(cfg: Config) -> dict[str, Attribute]:
    attrs: dict[str, Attribute] = {}
    if cfg.target_waves:
        attrs[_TARGET_WAVES_ATTR] = dsl.i64_attr(cfg.target_waves)
    if cfg.dynamic_lds_bytes:
        attrs[_DYNAMIC_LDS_ATTR] = dsl.i64_attr(cfg.dynamic_lds_bytes)
    return attrs


def _kernel_inputs() -> list[dsl.Type]:
    return [
        dsl.ptr_type(dsl.i8()),
        dsl.ptr_type(dsl.i8()),
        dsl.ptr_type(dsl.f16()),
        dsl.ptr_type(dsl.i8()),
        dsl.ptr_type(dsl.i8()),
        dsl.i32(),
    ]


def _buffer(
    bld: dsl.FunctionBuilder, ptr: dsl.Value, elements: int, element_type: dsl.Type
) -> dsl.Value:
    return bld.make_buffer(
        ptr,
        bld.constant(dsl.i32(), elements),
        dsl.buffer_ptr_type(element_type),
    )


def _bounded_offset(
    bld: dsl.FunctionBuilder, offset: dsl.Value, elements: int
) -> dsl.Value:
    return bld.assume_range(offset, 0, max(elements - 1, 0))


def _emit_coords(bld: dsl.FunctionBuilder, cfg: Config) -> Coords:
    wi = bld.assume_range(
        bld.workitem_id(axis=0, width=_WAVE_SIZE), 0, cfg.threads_per_workgroup - 1
    )
    wg_m = bld.assume_range(bld.workgroup_id(axis=0), 0, cfg.m_blocks - 1)
    wg_n = bld.assume_range(bld.workgroup_id(axis=1), 0, cfg.n_blocks - 1)
    return Coords(wi=wi, wg_m=wg_m, wg_n=wg_n)


def _logical_col(row: int | dsl.Expr, physical_col: int | dsl.Expr) -> dsl.Expr:
    return dsl.xor(dsl.mod(dsl.floor(row / 2), 4), physical_col)


def _major_minor(slot: int | dsl.Expr, rows: int) -> tuple[dsl.Expr, dsl.Expr]:
    major = dsl.floor(slot / rows)
    return major, slot - major * rows


def _read_slots(
    wave_k_tiles: int,
    block_tiles: int,
    wave_tiles: int,
    wave_coord: dsl.Expr,
) -> tuple[dsl.Expr, ...]:
    slots: list[dsl.Expr] = []
    for k in range(wave_k_tiles):
        for i in range(wave_tiles):
            slots.append(k * block_tiles + wave_coord * wave_tiles + i)
    return tuple(slots)


def _tuple_from_count(
    count: int, make: Callable[[int], dsl.Value]
) -> tuple[dsl.Value, ...]:
    return tuple(make(i) for i in range(count))


def _tuple_from_slots(
    slots: tuple[dsl.Expr, ...], make: Callable[[dsl.Expr], dsl.Value]
) -> tuple[dsl.Value, ...]:
    return tuple(make(slot) for slot in slots)


def _data_ptrs(
    bld: dsl.FunctionBuilder,
    cfg: Config,
    coords: Coords,
    a_base: dsl.Value,
    b_base: dsl.Value,
    step: dsl.Value,
) -> DataPtrs:
    lds = bld.shared_memory_base(dsl.i32())
    wi = dsl.sym("wi")
    wi_first = dsl.sym("wi_first")
    wg_m = dsl.sym("wg_m")
    wg_n = dsl.sym("wg_n")
    step_sym = dsl.sym("step")
    bindings = {wi: coords.wi, wg_m: coords.wg_m, wg_n: coords.wg_n, step_sym: step}
    first_bindings = {wi_first: bld.read_first(coords.wi)}
    stage = dsl.mod(step_sym, 2)
    wave = dsl.floor(wi / _WAVE_SIZE)
    wave_first = dsl.floor(wi_first / _WAVE_SIZE)
    lane = dsl.mod(wi, _WAVE_SIZE)
    lane_mod16 = dsl.mod(wi, 16)
    lane_k_group = dsl.floor(lane / 16)
    src_row = dsl.floor(lane / 4)
    src_k_group = _logical_col(src_row, dsl.mod(lane, 4))
    read_k_group = _logical_col(lane_mod16, lane_k_group)
    a_slots_per_wave = cfg.a_data_slots // cfg.waves_per_workgroup
    b_slots_per_wave = cfg.b_data_slots // cfg.waves_per_workgroup
    data_stage_base = stage * cfg.data_stage_lds_dwords
    b_data_base = cfg.a_data_slots * cfg.dwords_per_data_slot

    def data_dest(slot_per_wave: int, base: int) -> dsl.Value:
        off = bld.index_expr(
            data_stage_base
            + base
            + (slot_per_wave * cfg.waves_per_workgroup + wave_first)
            * cfg.dwords_per_data_slot,
            {**bindings, **first_bindings},
        )
        return bld.ptr_add(lds, off)

    def a_src(slot_per_wave: int) -> dsl.Value:
        slot = slot_per_wave * cfg.waves_per_workgroup + wave
        k_tile, m_tile = _major_minor(slot, cfg.block_m_tiles)
        off = bld.index_expr(
            wg_m * (cfg.block_m_tiles * 16 * cfg.storage_k)
            + m_tile * (16 * cfg.storage_k)
            + (step_sym * cfg.wave_k_tiles + k_tile) * cfg.storage_k_tile
            + src_row * cfg.storage_k
            + src_k_group * cfg.storage_lane_k_bytes,
            bindings,
        )
        off = _bounded_offset(bld, off, cfg.a_elements)
        return bld.ptr_add(a_base, off)

    def b_src(slot_per_wave: int) -> dsl.Value:
        slot = slot_per_wave * cfg.waves_per_workgroup + wave
        k_tile, n_tile = _major_minor(slot, cfg.block_n_tiles)
        off = bld.index_expr(
            wg_n * (cfg.block_n_tiles * 16 * cfg.storage_k)
            + n_tile * (16 * cfg.storage_k)
            + (step_sym * cfg.wave_k_tiles + k_tile) * cfg.storage_k_tile
            + src_row * cfg.storage_k
            + src_k_group * cfg.storage_lane_k_bytes,
            bindings,
        )
        off = _bounded_offset(bld, off, cfg.b_elements)
        return bld.ptr_add(b_base, off)

    def data_read(slot: int | dsl.Expr, base: int) -> dsl.Value:
        off = bld.index_expr(
            data_stage_base
            + base
            + slot * cfg.dwords_per_data_slot
            + lane_mod16 * cfg.storage_k_tile_dwords
            + read_k_group * cfg.storage_lane_k_dwords,
            bindings,
        )
        return bld.ptr_add(lds, off)

    m_wave = dsl.floor(wave / cfg.bn)
    n_wave = dsl.mod(wave, cfg.bn)
    a_read_slots = _read_slots(
        cfg.wave_k_tiles, cfg.block_m_tiles, cfg.wave_m_tiles, m_wave
    )
    b_read_slots = _read_slots(
        cfg.wave_k_tiles, cfg.block_n_tiles, cfg.wave_n_tiles, n_wave
    )
    return DataPtrs(
        a_src=_tuple_from_count(a_slots_per_wave, a_src),
        b_src=_tuple_from_count(b_slots_per_wave, b_src),
        a_dest=_tuple_from_count(a_slots_per_wave, lambda i: data_dest(i, 0)),
        b_dest=_tuple_from_count(b_slots_per_wave, lambda i: data_dest(i, b_data_base)),
        a_read=_tuple_from_slots(a_read_slots, lambda slot: data_read(slot, 0)),
        b_read=_tuple_from_slots(
            b_read_slots, lambda slot: data_read(slot, b_data_base)
        ),
    )


def _issue_data_dma(
    bld: dsl.FunctionBuilder, data: DataPtrs, dep: dsl.Value
) -> list[dsl.Value]:
    return _issue_dma_requests(bld, _data_dma_requests(data), dep)


def _data_dma_requests(data: DataPtrs) -> list[DmaRequest]:
    requests: list[DmaRequest] = []
    for src, dest in zip(data.a_src, data.a_dest, strict=True):
        requests.append(DmaRequest(src, dest, 16, zero_fill_inactive=True))
    for src, dest in zip(data.b_src, data.b_dest, strict=True):
        requests.append(DmaRequest(src, dest, 16, zero_fill_inactive=True))
    return requests


def _issue_dma_requests(
    bld: dsl.FunctionBuilder, requests: list[DmaRequest], dep: dsl.Value
) -> list[dsl.Value]:
    return [
        bld.dma_load_lds(
            request.src,
            request.dest,
            after=dep,
            bytes=request.bytes,
            zero_fill_inactive=request.zero_fill_inactive,
        )
        for request in requests
    ]


def _stage_scale_byte(
    bld: dsl.FunctionBuilder,
    base: dsl.Value,
    elements: int,
    lds: dsl.Value,
    global_off: dsl.Value,
    lds_off: dsl.Value,
    tokens: list[dsl.Value],
) -> None:
    global_off = _bounded_offset(bld, global_off, elements)
    value, load_token = bld.load(
        bld.ptr_add(base, global_off),
        dsl.simd_type(dsl.i8(), width=_WAVE_SIZE),
    )
    tokens.append(bld.store(value, bld.ptr_add(lds, lds_off), after=load_token))


def _stage_canonical_scales(
    bld: dsl.FunctionBuilder,
    cfg: Config,
    coords: Coords,
    a_scale: dsl.Value,
    b_scale: dsl.Value,
    step: dsl.Value,
) -> list[dsl.Value]:
    lds_a = bld.shared_memory_base(dsl.i8(), offset=cfg.scale_a_lds_base)
    lds_b = bld.shared_memory_base(dsl.i8(), offset=cfg.scale_b_lds_base)
    wi = dsl.sym("wi")
    wg_m = dsl.sym("wg_m")
    wg_n = dsl.sym("wg_n")
    step_sym = dsl.sym("step")
    bindings = {wi: coords.wi, wg_m: coords.wg_m, wg_n: coords.wg_n, step_sym: step}
    stage = dsl.mod(step_sym, 2)
    wave = dsl.floor(wi / _WAVE_SIZE)
    m_wave = dsl.floor(wave / cfg.bn)
    n_wave = dsl.mod(wave, cfg.bn)
    lane = dsl.mod(wi, _WAVE_SIZE)
    lane_mn = dsl.mod(wi, 16)
    lane_scale_k = dsl.floor(lane / 16)
    tokens: list[dsl.Value] = []

    for axis_group in range(cfg.wave_m_tiles // 2):
        for k_group in range(cfg.k_scale_groups_per_step):
            group = axis_group * cfg.k_scale_groups_per_step + k_group
            for k_sel in range(2):
                for axis_sel in range(2):
                    selector = axis_sel + 2 * k_sel
                    tile_m = (
                        wg_m * cfg.block_m_tiles
                        + m_wave * cfg.wave_m_tiles
                        + axis_group * 2
                        + axis_sel
                    )
                    raw_k = step_sym * cfg.wave_k_tiles + k_group * 2 + k_sel
                    scale_k = raw_k * (_MMA_K // _MX_BLOCK) + lane_scale_k
                    global_off = bld.index_expr(
                        scale_k * cfg.m + tile_m * 16 + lane_mn,
                        bindings,
                    )
                    lds_off = bld.index_expr(
                        stage * cfg.scale_stage_lds_bytes
                        + m_wave * cfg.a_scale_partition_bytes
                        + group * _SCALE_GROUP_BYTES
                        + lane * 4
                        + selector,
                        bindings,
                    )
                    _stage_scale_byte(
                        bld,
                        a_scale,
                        cfg.canonical_a_scale_elements,
                        lds_a,
                        global_off,
                        lds_off,
                        tokens,
                    )

    for axis_group in range(cfg.wave_n_tiles // 2):
        for k_group in range(cfg.k_scale_groups_per_step):
            group = axis_group * cfg.k_scale_groups_per_step + k_group
            for k_sel in range(2):
                for axis_sel in range(2):
                    selector = axis_sel + 2 * k_sel
                    tile_n = (
                        wg_n * cfg.block_n_tiles
                        + n_wave * cfg.wave_n_tiles
                        + axis_group * 2
                        + axis_sel
                    )
                    raw_k = step_sym * cfg.wave_k_tiles + k_group * 2 + k_sel
                    scale_k = raw_k * (_MMA_K // _MX_BLOCK) + lane_scale_k
                    global_off = bld.index_expr(
                        scale_k * cfg.n + tile_n * 16 + lane_mn,
                        bindings,
                    )
                    lds_off = bld.index_expr(
                        stage * cfg.scale_stage_lds_bytes
                        + n_wave * cfg.b_scale_partition_bytes
                        + group * _SCALE_GROUP_BYTES
                        + lane * 4
                        + selector,
                        bindings,
                    )
                    _stage_scale_byte(
                        bld,
                        b_scale,
                        cfg.canonical_b_scale_elements,
                        lds_b,
                        global_off,
                        lds_off,
                        tokens,
                    )
    return tokens


def _stage_tensilelite_scales(
    bld: dsl.FunctionBuilder,
    cfg: Config,
    coords: Coords,
    a_scale: dsl.Value,
    b_scale: dsl.Value,
    step: dsl.Value,
    dep: dsl.Value,
) -> list[dsl.Value]:
    return _issue_dma_requests(
        bld,
        _tensilelite_scale_dma_requests(bld, cfg, coords, a_scale, b_scale, step),
        dep,
    )


def _tensilelite_scale_dma_requests(
    bld: dsl.FunctionBuilder,
    cfg: Config,
    coords: Coords,
    a_scale: dsl.Value,
    b_scale: dsl.Value,
    step: dsl.Value,
) -> list[DmaRequest]:
    lds = bld.shared_memory_base(dsl.i32(), offset=cfg.scale_lds_base)
    wi = dsl.sym("wi")
    wi_first = dsl.sym("wi_first")
    wg_m = dsl.sym("wg_m")
    wg_n = dsl.sym("wg_n")
    step_sym = dsl.sym("step")
    bindings = {wi: coords.wi, wg_m: coords.wg_m, wg_n: coords.wg_n, step_sym: step}
    first_bindings = {wi_first: bld.read_first(coords.wi)}
    stage = dsl.mod(step_sym, 2)
    wave = dsl.floor(wi / _WAVE_SIZE)
    wave_first = dsl.floor(wi_first / _WAVE_SIZE)
    m_wave = dsl.floor(wave / cfg.bn)
    n_wave = dsl.mod(wave, cfg.bn)
    m_wave_first = dsl.floor(wave_first / cfg.bn)
    n_wave_first = dsl.mod(wave_first, cfg.bn)
    lane = dsl.mod(wi, _WAVE_SIZE)
    requests: list[DmaRequest] = []
    a_groups = cfg.a_scale_groups_per_partition
    b_groups = cfg.b_scale_groups_per_partition
    cta = wg_m * cfg.n_blocks + wg_n
    a_cta_bytes = cfg.bm * cfg.a_scale_partition_bytes * cfg.virtual_k_steps
    b_cta_bytes = cfg.bn * cfg.b_scale_partition_bytes * cfg.virtual_k_steps
    ctas = cfg.m_blocks * cfg.n_blocks
    a_elements = ctas * a_cta_bytes
    b_elements = ctas * b_cta_bytes
    b_stage_base = cfg.bm * (cfg.a_scale_partition_bytes // 4)

    group = 0
    while group < a_groups:
        chunk_groups = 4 if a_groups - group >= 4 else 1
        src = bld.index_expr(
            cta * a_cta_bytes
            + step_sym * (cfg.bm * cfg.a_scale_partition_bytes)
            + m_wave * cfg.a_scale_partition_bytes
            + group * _SCALE_GROUP_BYTES
            + lane * (chunk_groups * 4),
            bindings,
        )
        src = _bounded_offset(bld, src, a_elements)
        dest = bld.index_expr(
            stage * cfg.scale_stage_lds_dwords
            + m_wave_first * (cfg.a_scale_partition_bytes // 4)
            + group * (_SCALE_GROUP_BYTES // 4),
            {**bindings, **first_bindings},
        )
        requests.append(
            DmaRequest(
                bld.ptr_add(a_scale, src),
                bld.ptr_add(lds, dest),
                chunk_groups * 4,
            )
        )
        group += chunk_groups
    group = 0
    while group < b_groups:
        chunk_groups = 4 if b_groups - group >= 4 else 1
        src = bld.index_expr(
            cta * b_cta_bytes
            + step_sym * (cfg.bn * cfg.b_scale_partition_bytes)
            + n_wave * cfg.b_scale_partition_bytes
            + group * _SCALE_GROUP_BYTES
            + lane * (chunk_groups * 4),
            bindings,
        )
        src = _bounded_offset(bld, src, b_elements)
        dest = bld.index_expr(
            stage * cfg.scale_stage_lds_dwords
            + b_stage_base
            + n_wave_first * (cfg.b_scale_partition_bytes // 4)
            + group * (_SCALE_GROUP_BYTES // 4),
            {**bindings, **first_bindings},
        )
        requests.append(
            DmaRequest(
                bld.ptr_add(b_scale, src),
                bld.ptr_add(lds, dest),
                chunk_groups * 4,
            )
        )
        group += chunk_groups
    return requests


def _stage_scales(
    bld: dsl.FunctionBuilder,
    cfg: Config,
    coords: Coords,
    a_scale: dsl.Value,
    b_scale: dsl.Value,
    step: dsl.Value,
    dep: dsl.Value,
) -> list[dsl.Value]:
    if cfg.scale_input == "tensilelite":
        return _stage_tensilelite_scales(bld, cfg, coords, a_scale, b_scale, step, dep)
    return _stage_canonical_scales(bld, cfg, coords, a_scale, b_scale, step)


def _read_scale_groups(
    bld: dsl.FunctionBuilder,
    cfg: Config,
    coords: Coords,
    step: dsl.Value,
    ready: dsl.Value,
) -> tuple[list[dsl.Value], list[dsl.Value], list[dsl.Value]]:
    lds = bld.shared_memory_base(dsl.i32(), offset=cfg.scale_lds_base)
    wi = dsl.sym("wi")
    step_sym = dsl.sym("step_scale_read")
    bindings = {wi: coords.wi, step_sym: step}
    stage = dsl.mod(step_sym, 2)
    wave = dsl.floor(wi / _WAVE_SIZE)
    m_wave = dsl.floor(wave / cfg.bn)
    n_wave = dsl.mod(wave, cfg.bn)
    lane = dsl.mod(wi, _WAVE_SIZE)
    b_stage_base = cfg.bm * (cfg.a_scale_partition_bytes // 4)
    a_scales: list[dsl.Value] = []
    b_scales: list[dsl.Value] = []
    tokens: list[dsl.Value] = []
    for group in range(cfg.a_scale_groups_per_partition):
        off = bld.index_expr(
            stage * cfg.scale_stage_lds_dwords
            + m_wave * (cfg.a_scale_partition_bytes // 4)
            + group * (_SCALE_GROUP_BYTES // 4)
            + lane,
            bindings,
        )
        scale, token = bld.load(
            bld.ptr_add(lds, off),
            dsl.simd_type(dsl.i32(), width=_WAVE_SIZE),
            after=ready,
        )
        a_scales.append(scale)
        tokens.append(token)
    for group in range(cfg.b_scale_groups_per_partition):
        off = bld.index_expr(
            stage * cfg.scale_stage_lds_dwords
            + b_stage_base
            + n_wave * (cfg.b_scale_partition_bytes // 4)
            + group * (_SCALE_GROUP_BYTES // 4)
            + lane,
            bindings,
        )
        scale, token = bld.load(
            bld.ptr_add(lds, off),
            dsl.simd_type(dsl.i32(), width=_WAVE_SIZE),
            after=ready,
        )
        b_scales.append(scale)
        tokens.append(token)
    return a_scales, b_scales, tokens


def _read_data_frags(
    bld: dsl.FunctionBuilder, cfg: Config, data: DataPtrs, ready: dsl.Value
) -> tuple[list[dsl.Value], list[dsl.Value], list[dsl.Value]]:
    load_type = dsl.simd_type(dsl.vector_type(_AB_REGS, dsl.i32()), width=_WAVE_SIZE)
    a_type = dsl.fragment_type(0, dsl.i8(), 16, 16, _WAVE_SIZE, _AB_REGS)
    b_type = dsl.fragment_type(1, dsl.i8(), 16, 16, _WAVE_SIZE, _AB_REGS)
    a_frags: list[dsl.Value] = []
    b_frags: list[dsl.Value] = []
    tokens: list[dsl.Value] = []
    for ptr in data.a_read:
        regs, token = bld.load(ptr, load_type, after=ready)
        a_frags.append(bld.fragment_pack(regs, a_type))
        tokens.append(token)
    for ptr in data.b_read:
        regs, token = bld.load(ptr, load_type, after=ready)
        b_frags.append(bld.fragment_pack(regs, b_type))
        tokens.append(token)
    return a_frags, b_frags, tokens


def _load_data_frag(
    bld: dsl.FunctionBuilder, ptr: dsl.Value, operand: int, ready: dsl.Value
) -> tuple[dsl.Value, dsl.Value]:
    load_type = dsl.simd_type(dsl.vector_type(_AB_REGS, dsl.i32()), width=_WAVE_SIZE)
    frag_type = dsl.fragment_type(operand, dsl.i8(), 16, 16, _WAVE_SIZE, _AB_REGS)
    regs, token = bld.load(ptr, load_type, after=ready)
    return bld.fragment_pack(regs, frag_type), token


def _read_data_k_tile(
    bld: dsl.FunctionBuilder,
    cfg: Config,
    data: DataPtrs,
    ready: dsl.Value,
    k_tile: int,
) -> tuple[tuple[dsl.Value, ...], tuple[dsl.Value, ...], list[dsl.Value]]:
    a_frags: list[dsl.Value] = []
    b_frags: list[dsl.Value] = []
    tokens: list[dsl.Value] = []
    a_base = k_tile * cfg.wave_m_tiles
    b_base = k_tile * cfg.wave_n_tiles
    for ptr in data.a_read[a_base : a_base + cfg.wave_m_tiles]:
        frag, token = _load_data_frag(bld, ptr, 0, ready)
        a_frags.append(frag)
        tokens.append(token)
    for ptr in data.b_read[b_base : b_base + cfg.wave_n_tiles]:
        frag, token = _load_data_frag(bld, ptr, 1, ready)
        b_frags.append(frag)
        tokens.append(token)
    return tuple(a_frags), tuple(b_frags), tokens


def _read_stage_k0(
    bld: dsl.FunctionBuilder,
    cfg: Config,
    coords: Coords,
    data: DataPtrs,
    step: dsl.Value,
    ready: dsl.Value,
) -> tuple[StageState, list[dsl.Value]]:
    a_frags, b_frags, data_tokens = _read_data_k_tile(bld, cfg, data, ready, 0)
    a_scales, b_scales, scale_tokens = _read_scale_groups(bld, cfg, coords, step, ready)
    return (
        StageState(
            ready,
            a_frags,
            b_frags,
            tuple(a_scales),
            tuple(b_scales),
        ),
        [*data_tokens, *scale_tokens],
    )


def _flatten_stage(state: StageState) -> tuple[dsl.Value, ...]:
    return (
        state.ready,
        *state.a_frags,
        *state.b_frags,
        *state.a_scales,
        *state.b_scales,
    )


def _unflatten_stage(cfg: Config, values: tuple[dsl.Value, ...]) -> StageState:
    offset = 0
    ready = values[offset]
    offset += 1
    a_frags = values[offset : offset + cfg.wave_m_tiles]
    offset += cfg.wave_m_tiles
    b_frags = values[offset : offset + cfg.wave_n_tiles]
    offset += cfg.wave_n_tiles
    a_scales = values[offset : offset + cfg.wave_m_tiles // 2]
    offset += cfg.wave_m_tiles // 2
    b_scales = values[offset : offset + cfg.wave_n_tiles // 2]
    return StageState(ready, a_frags, b_frags, a_scales, b_scales)


def _emit_mma_step(
    bld: dsl.FunctionBuilder,
    cfg: Config,
    accs: tuple[dsl.Value, ...],
    a_frags: list[dsl.Value],
    b_frags: list[dsl.Value],
    a_scales: list[dsl.Value],
    b_scales: list[dsl.Value],
) -> tuple[dsl.Value, ...]:
    out = list(accs)
    for k in range(cfg.wave_k_tiles):
        k_group = k // 2
        k_sel = k % 2
        for i in range(cfg.wave_m_tiles):
            a_frag = a_frags[k * cfg.wave_m_tiles + i]
            a_group = (i // 2) * cfg.k_scale_groups_per_step + k_group
            a_sel = (i % 2) + 2 * k_sel
            for j in range(cfg.wave_n_tiles):
                b_frag = b_frags[k * cfg.wave_n_tiles + j]
                b_group = (j // 2) * cfg.k_scale_groups_per_step + k_group
                b_sel = (j % 2) + 2 * k_sel
                acc_idx = i * cfg.wave_n_tiles + j
                out[acc_idx] = bld.mma_scale(
                    "mfma.scale.f32.16x16x128.f4.f4",
                    a_frag,
                    a_scales[a_group],
                    b_frag,
                    b_scales[b_group],
                    out[acc_idx],
                    scale_idx_a=a_sel,
                    scale_idx_b=b_sel,
                )
    return tuple(out)


def _emit_mma_k_tile(
    bld: dsl.FunctionBuilder,
    cfg: Config,
    accs: tuple[dsl.Value, ...],
    a_frags: tuple[dsl.Value, ...],
    b_frags: tuple[dsl.Value, ...],
    a_scales: tuple[dsl.Value, ...],
    b_scales: tuple[dsl.Value, ...],
    k_sel: int,
    after_mfma: Callable[[int], None] | None = None,
) -> tuple[dsl.Value, ...]:
    out = list(accs)
    issued = 0
    for i in range(cfg.wave_m_tiles):
        a_frag = a_frags[i]
        a_group = i // 2
        a_sel = (i % 2) + 2 * k_sel
        for j in range(cfg.wave_n_tiles):
            b_frag = b_frags[j]
            b_group = j // 2
            b_sel = (j % 2) + 2 * k_sel
            acc_idx = i * cfg.wave_n_tiles + j
            out[acc_idx] = bld.mma_scale(
                "mfma.scale.f32.16x16x128.f4.f4",
                a_frag,
                a_scales[a_group],
                b_frag,
                b_scales[b_group],
                out[acc_idx],
                scale_idx_a=a_sel,
                scale_idx_b=b_sel,
            )
            issued += 1
            if after_mfma is not None:
                after_mfma(issued)
    return tuple(out)


class _DmaEmitter:
    def __init__(
        self, bld: dsl.FunctionBuilder, requests: list[DmaRequest], dep: dsl.Value
    ) -> None:
        self.bld = bld
        self.requests = requests
        self.dep = dep
        self.index = 0
        self.tokens: list[dsl.Value] = []

    def emit_one(self) -> bool:
        if self.index >= len(self.requests):
            return False
        request = self.requests[self.index]
        self.tokens.append(
            self.bld.dma_load_lds(
                request.src,
                request.dest,
                after=self.dep,
                bytes=request.bytes,
                zero_fill_inactive=request.zero_fill_inactive,
            )
        )
        self.index += 1
        return True

    def emit_remaining(self) -> None:
        while self.emit_one():
            pass

    @property
    def done(self) -> bool:
        return self.index >= len(self.requests)


def _stage_dma_emitter(
    bld: dsl.FunctionBuilder,
    cfg: Config,
    coords: Coords,
    a_scale: dsl.Value,
    b_scale: dsl.Value,
    next_data: DataPtrs,
    next_step: dsl.Value,
    dep: dsl.Value,
) -> _DmaEmitter:
    return _DmaEmitter(
        bld,
        [
            *_data_dma_requests(next_data),
            *_tensilelite_scale_dma_requests(
                bld, cfg, coords, a_scale, b_scale, next_step
            ),
        ],
        dep,
    )


class _StageReadEmitter:
    def __init__(
        self,
        bld: dsl.FunctionBuilder,
        cfg: Config,
        coords: Coords,
        data: DataPtrs,
        step: dsl.Value,
        ready: dsl.Value,
    ) -> None:
        self.bld = bld
        self.cfg = cfg
        self.coords = coords
        self.data = data
        self.step = step
        self.ready = ready
        self.a_index = 0
        self.b_index = 0
        self.scales_read = False
        self.a_frags: list[dsl.Value] = []
        self.b_frags: list[dsl.Value] = []
        self.a_scales: tuple[dsl.Value, ...] = ()
        self.b_scales: tuple[dsl.Value, ...] = ()
        self.tokens: list[dsl.Value] = []

    def emit_one(self) -> bool:
        if self.a_index < self.cfg.wave_m_tiles:
            ptr = self.data.a_read[self.a_index]
            frag, token = _load_data_frag(self.bld, ptr, 0, self.ready)
            self.a_frags.append(frag)
            self.tokens.append(token)
            self.a_index += 1
            return True
        if self.b_index < self.cfg.wave_n_tiles:
            ptr = self.data.b_read[self.b_index]
            frag, token = _load_data_frag(self.bld, ptr, 1, self.ready)
            self.b_frags.append(frag)
            self.tokens.append(token)
            self.b_index += 1
            return True
        if not self.scales_read:
            a_scales, b_scales, scale_tokens = _read_scale_groups(
                self.bld, self.cfg, self.coords, self.step, self.ready
            )
            self.a_scales = tuple(a_scales)
            self.b_scales = tuple(b_scales)
            self.tokens.extend(scale_tokens)
            self.scales_read = True
            return True
        return False

    def emit_remaining(self) -> None:
        while self.emit_one():
            pass

    def finish(self) -> StageState:
        self.emit_remaining()
        return StageState(
            self.ready,
            tuple(self.a_frags),
            tuple(self.b_frags),
            self.a_scales,
            self.b_scales,
        )


def _emit_stage_final(
    bld: dsl.FunctionBuilder,
    cfg: Config,
    current_data: DataPtrs,
    current: StageState,
    accs: tuple[dsl.Value, ...],
) -> tuple[dsl.Value, ...]:
    a_k1: list[dsl.Value] = []
    b_k1: list[dsl.Value] = []
    a_read_index = 0
    b_read_index = 0

    def read_next_local(_: int) -> None:
        nonlocal a_read_index, b_read_index
        if a_read_index < cfg.wave_m_tiles:
            ptr = current_data.a_read[cfg.wave_m_tiles + a_read_index]
            frag, _ = _load_data_frag(bld, ptr, 0, current.ready)
            a_k1.append(frag)
            a_read_index += 1
            return
        if b_read_index < cfg.wave_n_tiles:
            ptr = current_data.b_read[cfg.wave_n_tiles + b_read_index]
            frag, _ = _load_data_frag(bld, ptr, 1, current.ready)
            b_k1.append(frag)
            b_read_index += 1

    next_accs = _emit_mma_k_tile(
        bld,
        cfg,
        accs,
        current.a_frags,
        current.b_frags,
        current.a_scales,
        current.b_scales,
        0,
        after_mfma=read_next_local,
    )
    while a_read_index < cfg.wave_m_tiles or b_read_index < cfg.wave_n_tiles:
        read_next_local(0)
    return _emit_mma_k_tile(
        bld,
        cfg,
        next_accs,
        tuple(a_k1),
        tuple(b_k1),
        current.a_scales,
        current.b_scales,
        1,
    )


def _emit_stage_with_next(
    bld: dsl.FunctionBuilder,
    cfg: Config,
    coords: Coords,
    a_scale: dsl.Value,
    b_scale: dsl.Value,
    current_data: DataPtrs,
    next_data: DataPtrs,
    next_step: dsl.Value,
    current: StageState,
    accs: tuple[dsl.Value, ...],
) -> tuple[tuple[dsl.Value, ...], StageState]:
    dep = bld.token()
    dma = _stage_dma_emitter(
        bld, cfg, coords, a_scale, b_scale, next_data, next_step, dep
    )
    a_k1: list[dsl.Value] = []
    b_k1: list[dsl.Value] = []
    next_ready: dsl.Value | None = None
    next_reads: _StageReadEmitter | None = None
    a_read_index = 0
    b_read_index = 0

    def read_next_local() -> bool:
        nonlocal a_read_index, b_read_index
        if a_read_index < cfg.wave_m_tiles:
            ptr = current_data.a_read[cfg.wave_m_tiles + a_read_index]
            frag, _ = _load_data_frag(bld, ptr, 0, current.ready)
            a_k1.append(frag)
            a_read_index += 1
            return True
        if b_read_index < cfg.wave_n_tiles:
            ptr = current_data.b_read[cfg.wave_n_tiles + b_read_index]
            frag, _ = _load_data_frag(bld, ptr, 1, current.ready)
            b_k1.append(frag)
            b_read_index += 1
            return True
        return False

    def read_next_stage() -> bool:
        nonlocal next_ready, next_reads
        if next_ready is None:
            next_ready = bld.barrier(*dma.tokens)
            next_reads = _StageReadEmitter(
                bld, cfg, coords, next_data, next_step, next_ready
            )
        assert next_reads is not None
        return next_reads.emit_one()

    def after_mfma(_: int) -> None:
        if read_next_local():
            return
        if dma.emit_one():
            return
        if read_next_stage():
            return

    next_accs = _emit_mma_k_tile(
        bld,
        cfg,
        accs,
        current.a_frags,
        current.b_frags,
        current.a_scales,
        current.b_scales,
        0,
        after_mfma=after_mfma,
    )
    while read_next_local():
        pass
    dma.emit_remaining()
    if next_ready is None:
        assert next_ready is None
        next_ready = bld.barrier(*dma.tokens)
        next_reads = _StageReadEmitter(
            bld, cfg, coords, next_data, next_step, next_ready
        )
    assert next_reads is not None
    next_state = next_reads.finish()
    next_accs = _emit_mma_k_tile(
        bld,
        cfg,
        next_accs,
        tuple(a_k1),
        tuple(b_k1),
        current.a_scales,
        current.b_scales,
        1,
    )
    return next_accs, next_state


def _emit_stage_with_next_ready(
    bld: dsl.FunctionBuilder,
    cfg: Config,
    coords: Coords,
    a_scale: dsl.Value,
    b_scale: dsl.Value,
    current_data: DataPtrs,
    next_data: DataPtrs,
    next_step: dsl.Value,
    current: StageState,
    accs: tuple[dsl.Value, ...],
) -> tuple[tuple[dsl.Value, ...], dsl.Value]:
    dep = bld.token()
    dma = _stage_dma_emitter(
        bld, cfg, coords, a_scale, b_scale, next_data, next_step, dep
    )
    a_k1: list[dsl.Value] = []
    b_k1: list[dsl.Value] = []
    a_read_index = 0
    b_read_index = 0

    def read_next_local() -> bool:
        nonlocal a_read_index, b_read_index
        if a_read_index < cfg.wave_m_tiles:
            ptr = current_data.a_read[cfg.wave_m_tiles + a_read_index]
            frag, _ = _load_data_frag(bld, ptr, 0, current.ready)
            a_k1.append(frag)
            a_read_index += 1
            return True
        if b_read_index < cfg.wave_n_tiles:
            ptr = current_data.b_read[cfg.wave_n_tiles + b_read_index]
            frag, _ = _load_data_frag(bld, ptr, 1, current.ready)
            b_k1.append(frag)
            b_read_index += 1
            return True
        return False

    def after_mfma(_: int) -> None:
        if read_next_local():
            return
        dma.emit_one()

    next_accs = _emit_mma_k_tile(
        bld,
        cfg,
        accs,
        current.a_frags,
        current.b_frags,
        current.a_scales,
        current.b_scales,
        0,
        after_mfma=after_mfma,
    )
    while read_next_local():
        pass
    dma.emit_remaining()
    next_ready = bld.barrier(*dma.tokens)
    next_accs = _emit_mma_k_tile(
        bld,
        cfg,
        next_accs,
        tuple(a_k1),
        tuple(b_k1),
        current.a_scales,
        current.b_scales,
        1,
    )
    return next_accs, next_ready


def _join_tokens(bld: dsl.FunctionBuilder, tokens: list[dsl.Value]) -> dsl.Value:
    if not tokens:
        return bld.token()
    if len(tokens) == 1:
        return tokens[0]
    return bld.join(*tokens)


def _step(
    bld: dsl.FunctionBuilder,
    cfg: Config,
    coords: Coords,
    a_base: dsl.Value,
    b_base: dsl.Value,
    a_scale: dsl.Value,
    b_scale: dsl.Value,
    step: dsl.Value,
    accs: tuple[dsl.Value, ...],
) -> tuple[dsl.Value, ...]:
    dep = bld.token()
    data = _data_ptrs(bld, cfg, coords, a_base, b_base, step)
    tokens = _issue_data_dma(bld, data, dep)
    tokens.extend(_stage_scales(bld, cfg, coords, a_scale, b_scale, step, dep))
    ready = bld.barrier(*tokens)
    a_frags, b_frags, _ = _read_data_frags(bld, cfg, data, ready)
    a_scales, b_scales, _ = _read_scale_groups(bld, cfg, coords, step, ready)
    return _emit_mma_step(bld, cfg, accs, a_frags, b_frags, a_scales, b_scales)


def _stage_initial(
    bld: dsl.FunctionBuilder,
    cfg: Config,
    coords: Coords,
    a_base: dsl.Value,
    b_base: dsl.Value,
    a_scale: dsl.Value,
    b_scale: dsl.Value,
    step: dsl.Value,
) -> tuple[DataPtrs, StageState]:
    data, ready = _stage_ready(bld, cfg, coords, a_base, b_base, a_scale, b_scale, step)
    state, _ = _read_stage_k0(bld, cfg, coords, data, step, ready)
    return data, state


def _stage_ready(
    bld: dsl.FunctionBuilder,
    cfg: Config,
    coords: Coords,
    a_base: dsl.Value,
    b_base: dsl.Value,
    a_scale: dsl.Value,
    b_scale: dsl.Value,
    step: dsl.Value,
) -> tuple[DataPtrs, dsl.Value]:
    dep = bld.token()
    data = _data_ptrs(bld, cfg, coords, a_base, b_base, step)
    tokens = _issue_data_dma(bld, data, dep)
    tokens.extend(
        _stage_tensilelite_scales(bld, cfg, coords, a_scale, b_scale, step, dep)
    )
    ready = bld.barrier(*tokens)
    return data, ready


def _emit_tensilelite_main_loop(
    bld: dsl.FunctionBuilder,
    cfg: Config,
    coords: Coords,
    a_base: dsl.Value,
    b_base: dsl.Value,
    a_scale: dsl.Value,
    b_scale: dsl.Value,
    trip_count: dsl.Value,
    accs: tuple[dsl.Value, ...],
    current_data: DataPtrs,
    current: StageState,
    lookahead_data: DataPtrs,
    lookahead_ready: dsl.Value,
    one: dsl.Value,
    two: dsl.Value,
) -> tuple[tuple[dsl.Value, ...], DataPtrs, StageState, DataPtrs, dsl.Value]:
    if cfg.virtual_k_steps <= 2:
        return accs, current_data, current, lookahead_data, lookahead_ready

    state_values = _flatten_stage(current)
    state_size = len(state_values)
    upper = bld.addi(trip_count, one)
    init_args = (*accs, *state_values, lookahead_ready)
    with bld.for_loop(two, upper, two, init_args=init_args, nonzero_trip=True) as loop:
        loop_values = tuple(loop.inner_iter_args)
        loop_accs = loop_values[: cfg.tiles_per_wave]
        loop_state_values = loop_values[cfg.tiles_per_wave :]
        loop_current = _unflatten_stage(cfg, loop_state_values[:state_size])
        loop_lookahead_ready = loop_state_values[state_size]
        current_step = bld.subi(loop.induction_variable, two)
        lookahead_step = bld.subi(loop.induction_variable, one)
        loop_current_data = _data_ptrs(bld, cfg, coords, a_base, b_base, current_step)
        loop_lookahead_data = _data_ptrs(
            bld, cfg, coords, a_base, b_base, lookahead_step
        )
        next_current_data = _data_ptrs(
            bld, cfg, coords, a_base, b_base, loop.induction_variable
        )
        next_accs, next_current = _emit_stage_with_next(
            bld,
            cfg,
            coords,
            a_scale,
            b_scale,
            loop_current_data,
            next_current_data,
            loop.induction_variable,
            loop_current,
            loop_accs,
        )
        loop_lookahead, _ = _read_stage_k0(
            bld,
            cfg,
            coords,
            loop_lookahead_data,
            lookahead_step,
            loop_lookahead_ready,
        )
        next_lookahead_step = bld.addi(loop.induction_variable, one)
        next_lookahead_data = _data_ptrs(
            bld, cfg, coords, a_base, b_base, next_lookahead_step
        )
        next_accs, next_lookahead_ready = _emit_stage_with_next_ready(
            bld,
            cfg,
            coords,
            a_scale,
            b_scale,
            loop_lookahead_data,
            next_lookahead_data,
            next_lookahead_step,
            loop_lookahead,
            next_accs,
        )
        bld.yield_((*next_accs, *_flatten_stage(next_current), next_lookahead_ready))
    loop_results = tuple(loop.results)
    accs = loop_results[: cfg.tiles_per_wave]
    result_state_values = loop_results[cfg.tiles_per_wave :]
    current = _unflatten_stage(cfg, result_state_values[:state_size])
    lookahead_ready = result_state_values[state_size]
    current_data = _data_ptrs(
        bld, cfg, coords, a_base, b_base, bld.subi(trip_count, one)
    )
    lookahead_data = _data_ptrs(bld, cfg, coords, a_base, b_base, trip_count)
    return accs, current_data, current, lookahead_data, lookahead_ready


def _emit_tensilelite_pipeline(
    bld: dsl.FunctionBuilder,
    cfg: Config,
    coords: Coords,
    a_base: dsl.Value,
    b_base: dsl.Value,
    a_scale: dsl.Value,
    b_scale: dsl.Value,
    trip_count: dsl.Value,
    init_accs: tuple[dsl.Value, ...],
) -> tuple[dsl.Value, ...]:
    zero = bld.constant(dsl.i32(), 0)
    one = bld.constant(dsl.i32(), 1)
    two = bld.constant(dsl.i32(), 2)
    current_data, current = _stage_initial(
        bld, cfg, coords, a_base, b_base, a_scale, b_scale, zero
    )
    accs = init_accs
    if cfg.virtual_k_steps == 1:
        return _emit_stage_final(bld, cfg, current_data, current, accs)

    lookahead_data, lookahead_ready = _stage_ready(
        bld, cfg, coords, a_base, b_base, a_scale, b_scale, one
    )
    accs, current_data, current, lookahead_data, lookahead_ready = (
        _emit_tensilelite_main_loop(
            bld,
            cfg,
            coords,
            a_base,
            b_base,
            a_scale,
            b_scale,
            trip_count,
            accs,
            current_data,
            current,
            lookahead_data,
            lookahead_ready,
            one,
            two,
        )
    )
    accs = _emit_stage_final(bld, cfg, current_data, current, accs)
    lookahead, _ = _read_stage_k0(
        bld, cfg, coords, lookahead_data, trip_count, lookahead_ready
    )
    return _emit_stage_final(bld, cfg, lookahead_data, lookahead, accs)


def _pack_fragment_f16(bld: dsl.FunctionBuilder, fragment: dsl.Value) -> dsl.Value:
    regs_type = dsl.simd_type(dsl.vector_type(_ACC_REGS, dsl.f32()), width=_WAVE_SIZE)
    regs = waveamd.FragmentUnpackOp(regs_type, fragment).result
    f32_simd = dsl.simd_type(dsl.f32(), width=_WAVE_SIZE)
    f16_simd = dsl.simd_type(dsl.f16(), width=_WAVE_SIZE)
    f16_regs = [
        bld.fpconvert(wave.ExtractOp(f32_simd, regs, i).result, f16_simd)
        for i in range(_ACC_REGS)
    ]
    return wave.PackOp(
        dsl.simd_type(dsl.vector_type(_ACC_REGS, dsl.f16()), width=_WAVE_SIZE),
        f16_regs,
    ).result


def _store_fragment_f16(
    bld: dsl.FunctionBuilder, cfg: Config, fragment: dsl.Value, ptr: dsl.Value
) -> dsl.Value:
    wi = dsl.sym("wi_store")
    wi_val = bld.assume_range(
        bld.workitem_id(axis=0, width=_WAVE_SIZE), 0, cfg.threads_per_workgroup - 1
    )
    lane_off = bld.index_expr(dsl.mod(wi, _WAVE_SIZE) * _ACC_REGS, {wi: wi_val})
    return bld.store(_pack_fragment_f16(bld, fragment), bld.ptr_add(ptr, lane_off))


def _store_results(
    bld: dsl.FunctionBuilder,
    cfg: Config,
    coords: Coords,
    c_base: dsl.Value,
    accs: tuple[dsl.Value, ...],
) -> None:
    wi = dsl.sym("wi")
    wg_m = dsl.sym("wg_m")
    wg_n = dsl.sym("wg_n")
    bindings = {wi: coords.wi, wg_m: coords.wg_m, wg_n: coords.wg_n}
    wave = dsl.floor(wi / _WAVE_SIZE)
    cta_off = wg_m * (
        cfg.n_blocks * cfg.waves_per_workgroup * cfg.tiles_per_wave * 256
    ) + wg_n * (cfg.waves_per_workgroup * cfg.tiles_per_wave * 256)
    for i in range(cfg.wave_m_tiles):
        for j in range(cfg.wave_n_tiles):
            tile = i * cfg.wave_n_tiles + j
            off = bld.index_expr(
                cta_off + wave * (cfg.tiles_per_wave * 256) + tile * 256,
                bindings,
            )
            _store_fragment_f16(bld, cfg, accs[tile], bld.ptr_add(c_base, off))


def _emit_kernel(bld: dsl.FunctionBuilder, cfg: Config) -> None:
    a_arg, b_arg, c_arg, a_scale_arg, b_scale_arg, trip_count = bld.args
    a_base = _buffer(bld, a_arg, cfg.a_elements, dsl.i8())
    b_base = _buffer(bld, b_arg, cfg.b_elements, dsl.i8())
    if cfg.scale_input == "canonical":
        a_scale_elements = cfg.canonical_a_scale_elements
        b_scale_elements = cfg.canonical_b_scale_elements
    else:
        ctas = cfg.m_blocks * cfg.n_blocks
        a_scale_elements = (
            ctas * cfg.virtual_k_steps * cfg.bm * cfg.a_scale_partition_bytes
        )
        b_scale_elements = (
            ctas * cfg.virtual_k_steps * cfg.bn * cfg.b_scale_partition_bytes
        )
    a_scale = _buffer(bld, a_scale_arg, a_scale_elements, dsl.i8())
    b_scale = _buffer(bld, b_scale_arg, b_scale_elements, dsl.i8())
    coords = _emit_coords(bld, cfg)
    acc_type = dsl.fragment_type(2, dsl.f32(), 16, 16, _WAVE_SIZE, _ACC_REGS)
    init = tuple(
        bld.fragment_fill(bld.constant(dsl.i32(), 0), acc_type)
        for _ in range(cfg.tiles_per_wave)
    )
    if cfg.scale_input == "tensilelite":
        accs = _emit_tensilelite_pipeline(
            bld,
            cfg,
            coords,
            a_base,
            b_base,
            a_scale,
            b_scale,
            trip_count,
            init,
        )
        _store_results(bld, cfg, coords, c_arg, accs)
        return

    zero = bld.constant(dsl.i32(), 0)
    one = bld.constant(dsl.i32(), 1)
    upper = bld.addi(trip_count, one)
    with bld.for_loop(zero, upper, one, init_args=init, nonzero_trip=True) as loop:
        next_accs = _step(
            bld,
            cfg,
            coords,
            a_base,
            b_base,
            a_scale,
            b_scale,
            loop.induction_variable,
            tuple(loop.inner_iter_args),
        )
        bld.yield_(next_accs)
    _store_results(bld, cfg, coords, c_arg, tuple(loop.results))


def build_module(cfg: Config) -> Module:
    _validate_config(cfg)
    bld = dsl.ModuleBuilder()
    with (
        bld,
        bld.gpu_module(_GPU_MODULE_NAME) as gmod,
        gmod.kernel(
            _KERNEL_NAME,
            _kernel_inputs(),
            lds_size=cfg.fixed_lds_bytes,
            workgroup_size=[cfg.threads_per_workgroup, 1, 1],
            attrs=_kernel_attrs(cfg),
        ) as fb,
    ):
        _emit_kernel(fb, cfg)
    assert bld.module is not None
    return bld.module


def _parse_args(argv: list[str]) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--m", type=int, default=4096)
    parser.add_argument("--n", type=int, default=4096)
    parser.add_argument("--k", type=int, default=32768)
    parser.add_argument("--bm", type=int, default=2)
    parser.add_argument("--bn", type=int, default=2)
    parser.add_argument("--wave-m-tiles", type=int, default=8)
    parser.add_argument("--wave-n-tiles", type=int, default=8)
    parser.add_argument("--wave-k-tiles", type=int, default=2)
    parser.add_argument("--target-waves", type=int, default=1)
    parser.add_argument(
        "--scale-input",
        choices=("canonical", "tensilelite"),
        default="canonical",
        help=(
            "canonical matches the local runner; tensilelite expects "
            "host-pre-swizzled scale buffers"
        ),
    )
    parser.add_argument("--chip", default="")
    parser.add_argument("--dump-asm", action="store_true")
    parser.add_argument("--wave-translate", default=None)
    return parser.parse_args(argv)


def main(argv: list[str] | None = None) -> int:
    args = _parse_args(sys.argv[1:] if argv is None else argv)
    cfg = Config(
        m=args.m,
        n=args.n,
        k=args.k,
        bm=args.bm,
        bn=args.bn,
        wave_m_tiles=args.wave_m_tiles,
        wave_n_tiles=args.wave_n_tiles,
        wave_k_tiles=args.wave_k_tiles,
        target_waves=args.target_waves,
        scale_input=args.scale_input,
    )
    try:
        module = build_module(cfg)
    except ValueError as exc:
        raise SystemExit(str(exc)) from exc
    module_text = str(module)
    if args.dump_asm:
        sys.stdout.write(
            dump_kernel_asm(
                module_text,
                chip=args.chip,
                wave_translate=args.wave_translate,
                kernel_regex=r"(func\.func @wmma\w+.*?\n    \})",
                kernel_name=_KERNEL_NAME,
                missing_message="could not isolate generated kernel",
            )
        )
        return 0
    sys.stdout.write(module_text)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
