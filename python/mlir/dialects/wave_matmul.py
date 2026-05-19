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
the f32 accumulator with ``waveamd.fragment_store``. The LDS round-trip
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
end-to-end without disturbing the existing fragment_store codegen.

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

from dataclasses import dataclass

from mlir.dialects import scf
from mlir.dialects import wave_dsl as dsl
from mlir.ir import Module


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
    matrix_intrinsic: str = "wmma"
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


def _splat_const(bld: dsl.FunctionBuilder, value: int) -> dsl.Value:
    return bld.splat(bld.constant(dsl.i32(), value))


def _deterministic_random_values(
    count: int, *, seed: int, stream: int
) -> tuple[float, ...]:
    state = (seed ^ ((stream + 1) * 0x9E3779B9)) & 0xFFFFFFFF
    values: list[float] = []
    for _ in range(count):
        state = (1664525 * state + 1013904223) & 0xFFFFFFFF
        values.append((((state >> 24) % 17) - 8) * 0.25)
    return tuple(values)


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
    return tuple(out)


@dataclass(frozen=True)
class _TileCoords:
    """Per-wave coordinates derived from `workitem_id` / `workgroup_id`."""

    wi: dsl.Value  # raw workitem_id; wave_id = wi // 32 lives in index_expr
    a_lane_base: dsl.Value
    b_lane_base: dsl.Value
    c_ptr: dsl.Value


def _wrap_in_buffer(
    bld: dsl.FunctionBuilder, ptr: dsl.Value, num_elements: int
) -> dsl.Value:
    """Build a ``!wave.ptr<f16, #waveamd.buffer>`` from a global f16 pointer.

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
    The bucketizer's floor / mod materializer lowers the non-linear
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
    # m_wave / n_wave / lane_mod16 ride floor / mod nodes that the
    # bucketizer lowers to shr / and.
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
    a_off = bld.index_expr(
        wg_m * (cfg.BM * cfg.wave_m_tiles * stride_per_tile)
        + m_wave * (cfg.wave_m_tiles * stride_per_tile)
        + lane_mod16 * cfg.K
        + lane_k_off,
        bindings=sym_to_val,
    )
    a_lane_base = bld.ptr_add(a_arg, a_off)

    b_off = bld.index_expr(
        wg_n * (cfg.BN * cfg.wave_n_tiles * stride_per_tile)
        + n_wave * (cfg.wave_n_tiles * stride_per_tile)
        + lane_mod16 * cfg.K
        + lane_k_off,
        bindings=sym_to_val,
    )
    b_lane_base = bld.ptr_add(b_arg, b_off)

    c_off = bld.index_expr(
        wg_m * (cfg.N_blocks * cfg.waves_per_workgroup * cfg.tiles_per_wave * 256)
        + wg_n * (cfg.waves_per_workgroup * cfg.tiles_per_wave * 256)
        + wave_id * (cfg.tiles_per_wave * 256),
        bindings=sym_to_val,
    )
    c_ptr = bld.ptr_add(c_arg, c_off)

    return _TileCoords(
        wi=wi_val,
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

    def slot_ptr(slot: int) -> dsl.Value:
        slot_off = bld.index_expr(
            wave_id * (slots_per_wave * cfg.mma.lds_dwords_per_frag)
            + slot * cfg.mma.lds_dwords_per_frag
            + lane * cfg.mma.ab_registers,
            bindings=bindings,
        )
        return bld.ptr_add(lds, slot_off)

    a_lds_ptrs = tuple(
        slot_ptr(k * (cfg.wave_m_tiles + cfg.wave_n_tiles) + i)
        for k in range(cfg.wave_k_tiles)
        for i in range(cfg.wave_m_tiles)
    )
    b_lds_ptrs = tuple(
        slot_ptr(k * (cfg.wave_m_tiles + cfg.wave_n_tiles) + cfg.wave_m_tiles + i)
        for k in range(cfg.wave_k_tiles)
        for i in range(cfg.wave_n_tiles)
    )
    return _LdsStaging(
        reg_simd_type=reg_simd_type,
        a_lds_ptrs=a_lds_ptrs,
        b_lds_ptrs=b_lds_ptrs,
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
    a_loads = tuple(bld.load(ptr, staging.reg_simd_type) for ptr in a_ptrs)
    b_loads = tuple(bld.load(ptr, staging.reg_simd_type) for ptr in b_ptrs)

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


def _ptr_add_const(bld: dsl.FunctionBuilder, ptr: dsl.Value, offset: int) -> dsl.Value:
    if offset == 0:
        return ptr
    return bld.ptr_add(ptr, bld.constant(dsl.i32(), offset))


@dataclass(frozen=True)
class _KernelTypes:
    a: dsl.Type
    b: dsl.Type
    acc: dsl.Type


@dataclass(frozen=True)
class _TilePtrs:
    a0: tuple[dsl.Value, ...]
    b0: tuple[dsl.Value, ...]
    c: tuple[dsl.Value, ...]


@dataclass(frozen=True)
class _LoopState:
    accs: tuple[dsl.Value, ...]
    afs: tuple[dsl.Value, ...]
    bfs: tuple[dsl.Value, ...]
    aps: tuple[dsl.Value, ...]
    bps: tuple[dsl.Value, ...]


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
    a0 = tuple(
        _ptr_add_const(bld, coords.a_lane_base, i * 16 * cfg.K + k * cfg.mma.k_tile)
        for k in range(cfg.wave_k_tiles)
        for i in range(cfg.wave_m_tiles)
    )
    b0 = tuple(
        _ptr_add_const(bld, coords.b_lane_base, i * 16 * cfg.K + k * cfg.mma.k_tile)
        for k in range(cfg.wave_k_tiles)
        for i in range(cfg.wave_n_tiles)
    )
    c = tuple(
        _ptr_add_const(bld, coords.c_ptr, i * 256) for i in range(cfg.tiles_per_wave)
    )
    return _TilePtrs(a0=a0, b0=b0, c=c)


def _advance_ptrs(
    bld: dsl.FunctionBuilder, ptrs: tuple[dsl.Value, ...], offset: dsl.Value
) -> tuple[dsl.Value, ...]:
    return tuple(bld.ptr_add(ptr, offset) for ptr in ptrs)


def _initial_loop_args(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    types: _KernelTypes,
    staging: _LdsStaging,
    ptrs: _TilePtrs,
    a_step_offset: dsl.Value,
    b_step_offset: dsl.Value,
) -> tuple[dsl.Value, ...]:
    init_acc = bld.fragment_fill(bld.constant(dsl.i32(), 0), types.acc)
    a_frags, b_frags = _load_fragment_group_through_lds(
        bld, ptrs.a0, ptrs.b0, types.a, types.b, staging
    )
    init_accs = tuple(init_acc for _ in range(cfg.tiles_per_wave))
    return (
        *init_accs,
        *a_frags,
        *b_frags,
        *_advance_ptrs(bld, ptrs.a0, a_step_offset),
        *_advance_ptrs(bld, ptrs.b0, b_step_offset),
    )


def _split_loop_state(values: tuple[dsl.Value, ...], cfg: _MatmulConfig) -> _LoopState:
    acc_end = cfg.tiles_per_wave
    a_count = cfg.wave_k_tiles * cfg.wave_m_tiles
    b_count = cfg.wave_k_tiles * cfg.wave_n_tiles
    a_frag_end = acc_end + a_count
    b_frag_end = a_frag_end + b_count
    a_ptr_end = b_frag_end + a_count
    return _LoopState(
        accs=values[:acc_end],
        afs=values[acc_end:a_frag_end],
        bfs=values[a_frag_end:b_frag_end],
        aps=values[b_frag_end:a_ptr_end],
        bps=values[a_ptr_end:],
    )


def _emit_mma_grid(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    afs: tuple[dsl.Value, ...],
    bfs: tuple[dsl.Value, ...],
    accs: tuple[dsl.Value, ...],
) -> tuple[dsl.Value, ...]:
    acc_grid = list(accs)
    for k in range(cfg.wave_k_tiles):
        a_base = k * cfg.wave_m_tiles
        b_base = k * cfg.wave_n_tiles
        for i in range(cfg.wave_m_tiles):
            for j in range(cfg.wave_n_tiles):
                acc_index = i * cfg.wave_n_tiles + j
                acc_grid[acc_index] = bld.mma(
                    cfg.mma.kind,
                    afs[a_base + i],
                    bfs[b_base + j],
                    acc_grid[acc_index],
                )
    return tuple(acc_grid)


def _emit_pipelined_step(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    types: _KernelTypes,
    staging: _LdsStaging,
    state: _LoopState,
    a_step_offset: dsl.Value,
    b_step_offset: dsl.Value,
) -> list[dsl.Value]:
    new_accs = _emit_mma_grid(bld, cfg, state.afs, state.bfs, state.accs)
    new_afs, new_bfs = _load_fragment_group_through_lds(
        bld, state.aps, state.bps, types.a, types.b, staging
    )
    return [
        *new_accs,
        *new_afs,
        *new_bfs,
        *_advance_ptrs(bld, state.aps, a_step_offset),
        *_advance_ptrs(bld, state.bps, b_step_offset),
    ]


def _store_final_tiles(
    bld: dsl.FunctionBuilder,
    cfg: _MatmulConfig,
    state: _LoopState,
    c_ptrs: tuple[dsl.Value, ...],
) -> None:
    final_accs = _emit_mma_grid(bld, cfg, state.afs, state.bfs, state.accs)
    for acc, c_ptr in zip(final_accs, c_ptrs, strict=True):
        bld.fragment_store(acc, c_ptr)


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
    init_args = _initial_loop_args(
        bld, cfg, types, staging, ptrs, virtual_k_stride, virtual_k_stride
    )

    # The fourth kernel arg is the pipelined-loop trip count
    # (`K / (16 * wave_k_tiles) - 1`, precomputed on host).
    trip_count_i32 = bld.args[3]
    zero_i32 = bld.constant(dsl.i32(), 0)
    one_i32 = bld.constant(dsl.i32(), 1)

    with bld.for_loop(
        zero_i32,
        trip_count_i32,
        one_i32,
        init_args=init_args,
    ) as forop:
        state = _split_loop_state(tuple(forop.inner_iter_args), cfg)
        scf.YieldOp(
            _emit_pipelined_step(
                bld,
                cfg,
                types,
                staging,
                state,
                virtual_k_stride,
                virtual_k_stride,
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
    f32 = dsl.f32()
    f16_ptr = dsl.ptr_type(f16)
    f32_ptr = dsl.ptr_type(f32)

    c0 = bld.constant(index, 0)
    c1 = bld.constant(index, 1)
    blocks_m = bld.constant(index, cfg.M_blocks)
    blocks_n = bld.constant(index, cfg.N_blocks)
    threads = bld.constant(index, cfg.threads_per_workgroup)
    c_total = bld.constant(index, cfg.total_elements)

    one_f16 = bld.constant(f16, 1.0)
    two_f16 = bld.constant(f16, 2.0)
    zero_f32 = bld.constant(f32, 0.0)

    a_buf = bld.alloc([cfg.a_elements], f16)
    b_buf = bld.alloc([cfg.b_elements], f16)
    c_buf = bld.alloc([cfg.total_elements], f32)

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

    trip_count_value = bld.constant(dsl.i32(), max(cfg.virtual_k_steps - 1, 0))
    launch_operands = [a_ptr, b_ptr, c_ptr, trip_count_value]
    bld.launch(
        _GPU_MODULE_NAME,
        _KERNEL_NAME,
        grid=(blocks_m, blocks_n, c1),
        block=(threads, c1, c1),
        operands=launch_operands,
    )
    bld.call(_PRINT_HELPER, [c_unranked])


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
    matrix_intrinsic: str = "wmma",
    random_data: bool = False,
    random_seed: int = 0,
) -> Module:
    """Return an MLIR :class:`Module` for the tiled WMMA f16 matmul.

    The host allocates ``MxK`` (A) and ``NxK`` (B) f16 buffers (filled
    with a per-axis 1.0/2.0 split, see :func:`_emit_host`), plus an
    ``MxN`` f32 output buffer, registers them with the GPU runtime, and
    launches the kernel.

    Each per-K-step A/B fragment is round-tripped through a per-wave
    LDS slot (identity transport), so the kernel always exercises tuple
    ``ds_store_b32`` / ``ds_load_b32`` and ``s_barrier``; the kernel
    function carries ``wave.lds_size`` so the AMDGPU lowering programs
    the matching ``group_segment_fixed_size``.

    When ``use_buffer=True`` the A and B inputs are additionally
    wrapped in ``waveamd.make_buffer`` so every per-K-step fragment
    load comes out as a tuple ``buffer_load_b32`` (``buffer_load_dword
    ..., 0 offen offset:i*4``) feeding the LDS round-trip. The C output
    stays on the global pointer path.

    See the module docstring for shape constraints.

    Note: the returned :class:`Module` is bound to a fresh MLIR
    :class:`Context` owned by the temporary :class:`ModuleBuilder`. The
    ``__exit__`` releases all thread-local handles before returning, so
    callers can keep using the module (e.g. printing, pass-managing)
    without further setup.
    """
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
        matrix_intrinsic=matrix_intrinsic,
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
            # Software-pipeline loop trip count: K // 16 - 1.
            dsl.i32(),
        ]
        lds_size = cfg.lds_bytes
        with (
            bld.gpu_module(_GPU_MODULE_NAME) as gmod,
            gmod.kernel(_KERNEL_NAME, kernel_inputs, lds_size=lds_size) as fb,
        ):
            _emit_kernel(fb, cfg)

        with bld.host_main() as fb:
            _emit_host(fb, cfg)

    return bld.module


__all__ = [
    "build_wmma_f16_matmul_module",
    "compute_wmma_f16_matmul_reference_buffer",
    "generate_wmma_f16_matmul_inputs",
]
