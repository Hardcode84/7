#  Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
#  See https://llvm.org/LICENSE.txt for license information.
#  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

"""Builder for a tiled Wave FlashAttention forward kernel."""

from __future__ import annotations

import math
import struct
from dataclasses import dataclass

import ixsimpl
from mlir.dialects import wave_dsl as dsl
from mlir.ir import Module

_KERNEL_NAME = "flash_attention_f32"
_GPU_MODULE_NAME = "kernels"
_F16_PTR_HELPER = "wave_memref_to_ptr_global_f16"
_F32_PTR_HELPER = "wave_memref_to_ptr_global_f32"
_PRINT_HELPER = "printMemrefF32"
_TARGET_WAVES_ATTR = "waveamdmachine.target_waves"
type _ExprLike = int | ixsimpl.Expr


@dataclass(frozen=True)
class _MmaVariant:
    name: str
    kind: str
    ab_registers: int
    acc_registers: int
    wave_size: int = 32
    lane_k_elems: int = 0
    k_tile: int = 16
    m_tile: int = 16
    n_tile: int = 16
    score_layout: str = "wmma"


_MMA_VARIANTS = {
    "wmma": _MmaVariant("wmma", "wmma.f32.16x16x16.f16", 8, 8),
    "mfma_gfx950": _MmaVariant(
        "mfma_gfx950",
        "mfma.f32.16x16x32.f16",
        4,
        4,
        wave_size=64,
        lane_k_elems=8,
        k_tile=32,
        score_layout="mfma",
    ),
}


def _require_positive(name: str, value: int) -> None:
    if value <= 0:
        raise ValueError(f"{name} must be positive; got {value}")


def _select_mma_variant(name: str) -> _MmaVariant:
    try:
        return _MMA_VARIANTS[name]
    except KeyError as exc:
        choices = ", ".join(sorted(_MMA_VARIANTS))
        raise ValueError(
            f"unknown matrix intrinsic '{name}'; expected {choices}"
        ) from exc


@dataclass(frozen=True)
class _FlashAttentionConfig:
    block_m: int
    block_n: int
    head_dim: int
    random_seed: int = 0
    seq_n: int | None = None
    matrix_intrinsic: str = "wmma"
    tile_loop_unroll: int | None = None

    def __post_init__(self) -> None:
        _validate_positive_config(self)
        _validate_mma_config(self)

    @property
    def threads_per_workgroup(self) -> int:
        return self.mma.wave_size

    @property
    def mma(self) -> _MmaVariant:
        return _select_mma_variant(self.matrix_intrinsic)

    @property
    def q_elements(self) -> int:
        return self.block_m * self.head_dim

    @property
    def kv_elements(self) -> int:
        return self.seq_len * self.head_dim

    @property
    def out_elements(self) -> int:
        return self.q_elements

    @property
    def seq_len(self) -> int:
        return self.block_n if self.seq_n is None else self.seq_n

    @property
    def score_lds_bytes(self) -> int:
        return self.mma.m_tile * self.mma.n_tile * 4

    @property
    def prob_lds_bytes(self) -> int:
        return self.mma.m_tile * self.mma.k_tile * 2

    @property
    def value_lds_bytes(self) -> int:
        return self.mma.n_tile * self.mma.k_tile * 2

    @property
    def denom_lds_bytes(self) -> int:
        return self.block_m * self.mma.n_tile * 4

    @property
    def lds_bytes(self) -> int:
        size = self.score_lds_bytes + self.prob_lds_bytes + self.value_lds_bytes
        if self.seq_len > self.block_n:
            size += self.denom_lds_bytes
        return size


def _validate_positive_config(cfg: _FlashAttentionConfig) -> None:
    for name, value in (
        ("block_m", cfg.block_m),
        ("block_n", cfg.block_n),
        ("head_dim", cfg.head_dim),
    ):
        _require_positive(name, value)
    if cfg.seq_n is not None:
        _require_positive("seq_n", cfg.seq_n)
    if cfg.tile_loop_unroll is not None:
        _require_positive("tile_loop_unroll", cfg.tile_loop_unroll)


def _validate_mma_config(cfg: _FlashAttentionConfig) -> None:
    if cfg.block_m > cfg.mma.m_tile or cfg.block_n > cfg.mma.n_tile:
        raise ValueError(
            "MMA FA kernel requires block_m/block_n to fit in one MMA tile; "
            f"got block_m={cfg.block_m}, block_n={cfg.block_n}"
        )
    if cfg.block_n & (cfg.block_n - 1):
        raise ValueError(f"block_n must be a power of two; got {cfg.block_n}")
    if cfg.head_dim & (cfg.head_dim - 1):
        raise ValueError(f"head_dim must be a power of two; got {cfg.head_dim}")
    if cfg.head_dim % cfg.mma.k_tile:
        raise ValueError(
            f"head_dim must be a multiple of {cfg.mma.k_tile} for "
            f"{cfg.matrix_intrinsic}; got {cfg.head_dim}"
        )
    if cfg.seq_len % cfg.block_n:
        raise ValueError(
            f"seq_n must be a multiple of block_n={cfg.block_n}; got {cfg.seq_len}"
        )
    if cfg.out_elements % cfg.mma.wave_size:
        raise ValueError(
            "block_m * head_dim must be a multiple of the matrix wave size; "
            f"got {cfg.out_elements} and wave{cfg.mma.wave_size}"
        )
    for name, count in (
        ("block_m * block_n", cfg.block_m * cfg.block_n),
        ("block_m * mma_n", cfg.block_m * cfg.mma.n_tile),
        ("mma_n * block_n", cfg.mma.n_tile * cfg.block_n),
        (
            "block_m * padded probability columns",
            cfg.block_m * (cfg.mma.k_tile - cfg.block_n),
        ),
        (
            "padded probability rows * mma_k",
            (cfg.mma.m_tile - cfg.block_m) * cfg.mma.k_tile,
        ),
        (
            "mma_n * padded value columns",
            cfg.mma.n_tile * (cfg.mma.k_tile - cfg.block_n),
        ),
    ):
        if count % cfg.mma.wave_size:
            raise ValueError(
                f"{name} must be a multiple of wave{cfg.mma.wave_size}; " f"got {count}"
            )


def _rand_values(
    count: int, *, seed: int, stream: int, scale: float
) -> tuple[float, ...]:
    state = (seed ^ ((stream + 1) * 0x9E3779B9)) & 0xFFFFFFFF
    values: list[float] = []
    for _ in range(count):
        state = (1664525 * state + 1013904223) & 0xFFFFFFFF
        values.append((((state >> 24) % 17) - 8) * scale)
    return tuple(values)


def _round_f16(value: float) -> float:
    return float(struct.unpack("<e", struct.pack("<e", value))[0])


def generate_flash_attention_f32_inputs(
    block_m: int,
    block_n: int,
    head_dim: int,
    *,
    random_seed: int = 0,
    seq_n: int | None = None,
) -> tuple[tuple[float, ...], tuple[float, ...], tuple[float, ...]]:
    cfg = _FlashAttentionConfig(
        block_m, block_n, head_dim, random_seed=random_seed, seq_n=seq_n
    )
    q_base = _rand_values(cfg.q_elements, seed=random_seed, stream=0, scale=0.0625)
    k_values = _rand_values(cfg.kv_elements, seed=random_seed, stream=1, scale=0.0625)
    v_values = _rand_values(cfg.kv_elements, seed=random_seed, stream=2, scale=0.125)
    scale = math.log2(math.e) / math.sqrt(cfg.head_dim)
    q_values = tuple(_round_f16(x * scale) for x in q_base)
    return (
        q_values,
        tuple(_round_f16(x) for x in k_values),
        tuple(_round_f16(x) for x in v_values),
    )


def compute_flash_attention_f32_reference(
    block_m: int,
    block_n: int,
    head_dim: int,
    *,
    random_seed: int = 0,
    seq_n: int | None = None,
) -> tuple[float, ...]:
    cfg = _FlashAttentionConfig(
        block_m, block_n, head_dim, random_seed=random_seed, seq_n=seq_n
    )
    q_values, k_values, v_values = generate_flash_attention_f32_inputs(
        block_m, block_n, head_dim, random_seed=random_seed, seq_n=seq_n
    )
    out: list[float] = []
    for m in range(cfg.block_m):
        scores: list[float] = []
        for n in range(cfg.seq_len):
            score = 0.0
            for d in range(cfg.head_dim):
                score += q_values[m * cfg.head_dim + d] * k_values[n * cfg.head_dim + d]
            scores.append(score)
        row_max = max(scores)
        weights = [2.0 ** (score - row_max) for score in scores]
        denom = sum(weights)
        for d in range(cfg.head_dim):
            acc = 0.0
            for n, weight in enumerate(weights):
                acc += weight * v_values[n * cfg.head_dim + d]
            out.append(acc / denom)
    return tuple(out)


def _target_waves_attrs(target_waves: int | None) -> dict[str, dsl.Attribute]:
    if target_waves is None:
        return {}
    if target_waves <= 0:
        raise ValueError(f"target_waves must be positive; got {target_waves}")
    return {_TARGET_WAVES_ATTR: dsl.i64_attr(target_waves)}


def _zero_f16_simd(bld: dsl.FunctionBuilder, wave_size: int) -> dsl.Value:
    zero = bld.splat(bld.constant(dsl.f32(), 0.0), dsl.f32(), wave_size)
    return bld.fpconvert(zero, dsl.simd_type(dsl.f16(), width=wave_size))


def _wrap_in_buffer(
    bld: dsl.FunctionBuilder,
    ptr: dsl.Value,
    element_type: dsl.Type,
    num_elements: int,
    bytes_per_element: int,
) -> dsl.Value:
    range_bytes = bld.constant(dsl.i32(), num_elements * bytes_per_element)
    return bld.make_buffer(ptr, range_bytes, dsl.buffer_ptr_type(element_type))


@dataclass(frozen=True)
class _KernelTypes:
    a: dsl.Type
    b: dsl.Type
    acc: dsl.Type


@dataclass(frozen=True)
class _OnlineSoftmaxState:
    row_max: dsl.Value
    denom: dsl.Value


@dataclass(frozen=True)
class _OnlineScratch:
    score_ptr: dsl.Value
    prob_ptr: dsl.Value
    value_ptr: dsl.Value
    denom_ptr: dsl.Value


@dataclass(frozen=True)
class _OnlineTileState:
    score_states: list[_OnlineSoftmaxState]
    output_states: list[_OnlineSoftmaxState]
    accs: list[dsl.Value]


def _kernel_types(cfg: _FlashAttentionConfig) -> _KernelTypes:
    return _KernelTypes(
        a=dsl.fragment_type(
            0,
            dsl.f16(),
            cfg.mma.m_tile,
            cfg.mma.n_tile,
            cfg.mma.wave_size,
            cfg.mma.ab_registers,
        ),
        b=dsl.fragment_type(
            1,
            dsl.f16(),
            cfg.mma.m_tile,
            cfg.mma.n_tile,
            cfg.mma.wave_size,
            cfg.mma.ab_registers,
        ),
        acc=dsl.fragment_type(
            2,
            dsl.f32(),
            cfg.mma.m_tile,
            cfg.mma.n_tile,
            cfg.mma.wave_size,
            cfg.mma.acc_registers,
        ),
    )


def _load_q_fragment(
    bld: dsl.FunctionBuilder,
    cfg: _FlashAttentionConfig,
    types: _KernelTypes,
    q_ptr: dsl.Value,
    lane_value: dsl.Value,
    k_step: int,
) -> dsl.Value:
    lane_sym = dsl.sym("fa_lane")
    lane_expr = dsl.mod(lane_sym, cfg.mma.wave_size)
    lane_row = dsl.mod(lane_expr, cfg.mma.m_tile)
    lane_k_off = dsl.floor(lane_expr / cfg.mma.m_tile) * cfg.mma.lane_k_elems
    q_off = bld.index_expr(
        lane_row * cfg.head_dim + lane_k_off + k_step * cfg.mma.k_tile,
        bindings={lane_sym: lane_value},
    )
    frag, _ = bld.fragment_load(bld.ptr_add(q_ptr, q_off), types.a)
    return frag


def _load_k_fragment(
    bld: dsl.FunctionBuilder,
    cfg: _FlashAttentionConfig,
    types: _KernelTypes,
    k_ptr: dsl.Value,
    lane_value: dsl.Value,
    start_n: _ExprLike,
    k_step: int,
    bindings: dict[ixsimpl.Expr, dsl.Value] | None = None,
) -> dsl.Value:
    lane_sym = dsl.sym("fa_lane")
    lane_expr = dsl.mod(lane_sym, cfg.mma.wave_size)
    lane_col = dsl.mod(lane_expr, cfg.mma.n_tile)
    lane_k_off = dsl.floor(lane_expr / cfg.mma.n_tile) * cfg.mma.lane_k_elems
    expr_bindings = dict(bindings or {})
    expr_bindings[lane_sym] = lane_value
    k_off = bld.index_expr(
        (start_n + lane_col) * cfg.head_dim + lane_k_off + k_step * cfg.mma.k_tile,
        bindings=expr_bindings,
    )
    frag, _ = bld.fragment_load(bld.ptr_add(k_ptr, k_off), types.b)
    return frag


def _load_row_major_fragment(
    bld: dsl.FunctionBuilder,
    cfg: _FlashAttentionConfig,
    ptr: dsl.Value,
    frag_type: dsl.Type,
    row_stride: int,
    lane_value: dsl.Value,
    after: dsl.Value,
) -> dsl.Value:
    lane_sym = dsl.sym("fa_lane")
    lane_expr = dsl.mod(lane_sym, cfg.mma.wave_size)
    lane_row = dsl.mod(lane_expr, cfg.mma.m_tile)
    lane_k_off = dsl.floor(lane_expr / cfg.mma.m_tile) * cfg.mma.lane_k_elems
    off = bld.index_expr(
        lane_row * row_stride + lane_k_off,
        bindings={lane_sym: lane_value},
    )
    frag, _ = bld.fragment_load(bld.ptr_add(ptr, off), frag_type, after=after)
    return frag


def _max_all(bld: dsl.FunctionBuilder, values: tuple[dsl.Value, ...]) -> dsl.Value:
    result = values[0]
    for value in values[1:]:
        result = bld.fmax(result, value)
    return result


def _emit_qk_tile(
    bld: dsl.FunctionBuilder,
    cfg: _FlashAttentionConfig,
    types: _KernelTypes,
    q_ptr: dsl.Value,
    k_ptr: dsl.Value,
    lane: dsl.Value,
    start_n: _ExprLike,
    bindings: dict[ixsimpl.Expr, dsl.Value] | None = None,
) -> dsl.Value:
    acc = bld.fragment_fill(bld.constant(dsl.i32(), 0), types.acc)
    for k_step in range(cfg.head_dim // cfg.mma.k_tile):
        q_frag = _load_q_fragment(bld, cfg, types, q_ptr, lane, k_step)
        k_frag = _load_k_fragment(
            bld, cfg, types, k_ptr, lane, start_n, k_step, bindings
        )
        acc = bld.mma(cfg.mma.kind, q_frag, k_frag, acc)
    return acc


def _mod_expr(value: int | ixsimpl.Expr, divisor: int) -> int | ixsimpl.Expr:
    if isinstance(value, int):
        return value % divisor
    return dsl.mod(value, divisor)


def _floor_div_expr(value: int | ixsimpl.Expr, divisor: int) -> int | ixsimpl.Expr:
    if isinstance(value, int):
        return value // divisor
    return dsl.floor(value / divisor)


def _score_slot_expr(
    cfg: _FlashAttentionConfig,
    row: int | ixsimpl.Expr,
    col: int | ixsimpl.Expr,
) -> int | ixsimpl.Expr:
    if cfg.mma.score_layout == "wmma":
        return (
            _mod_expr(row, 2) * cfg.mma.n_tile + col
        ) * cfg.mma.acc_registers + _floor_div_expr(row, 2)
    if cfg.mma.score_layout == "mfma":
        return (row * 4 + _mod_expr(col, 4)) * cfg.mma.acc_registers + (
            _floor_div_expr(col, 4)
        )
    raise AssertionError(f"unknown score layout {cfg.mma.score_layout}")


def _score_state_steps(cfg: _FlashAttentionConfig) -> int:
    return (cfg.block_m * cfg.block_n) // cfg.mma.wave_size


def _output_state_steps(cfg: _FlashAttentionConfig) -> int:
    return (cfg.block_m * cfg.mma.n_tile) // cfg.mma.wave_size


def _score_states_match_output_layout(cfg: _FlashAttentionConfig) -> bool:
    return cfg.block_n == cfg.mma.n_tile


def _flatten_online_state(states: list[_OnlineSoftmaxState]) -> tuple[dsl.Value, ...]:
    values: list[dsl.Value] = []
    for state in states:
        values.extend((state.row_max, state.denom))
    return tuple(values)


def _split_online_state(
    values: tuple[dsl.Value, ...], steps: int
) -> list[_OnlineSoftmaxState]:
    return [
        _OnlineSoftmaxState(values[i], values[i + 1]) for i in range(0, steps * 2, 2)
    ]


def _stage_probability_tile(
    bld: dsl.FunctionBuilder,
    cfg: _FlashAttentionConfig,
    score_ptr: dsl.Value,
    prob_ptr: dsl.Value,
    lane: dsl.Value,
    after: dsl.Value,
) -> dsl.Value:
    lane_sym = dsl.sym("fa_lane")
    lane_expr = dsl.mod(lane_sym, cfg.mma.wave_size)
    bindings = {lane_sym: lane}
    f16_simd = dsl.simd_type(dsl.f16(), width=cfg.mma.wave_size)
    tokens: list[dsl.Value] = []

    for step in range(_score_state_steps(cfg)):
        elem = lane_expr + step * cfg.mma.wave_size
        row = dsl.floor(elem / cfg.block_n)
        col = dsl.mod(elem, cfg.block_n)
        scores: list[dsl.Value] = []
        for n in range(cfg.block_n):
            score_idx = bld.index_expr(_score_slot_expr(cfg, row, n), bindings=bindings)
            score, _ = bld.load(
                bld.ptr_add(score_ptr, score_idx),
                dsl.simd_type(dsl.f32(), width=cfg.mma.wave_size),
                after=after,
            )
            scores.append(score)
        row_max = _max_all(bld, tuple(scores))
        denom: dsl.Value | None = None
        for score in scores:
            prob = bld.fexp2(bld.fsub(score, row_max))
            denom = prob if denom is None else bld.fadd(denom, prob)
        assert denom is not None
        prob_idx = bld.index_expr(_score_slot_expr(cfg, row, col), bindings=bindings)
        score, _ = bld.load(
            bld.ptr_add(score_ptr, prob_idx),
            dsl.simd_type(dsl.f32(), width=cfg.mma.wave_size),
            after=after,
        )
        prob = bld.fmul(bld.fexp2(bld.fsub(score, row_max)), bld.frcp(denom))
        prob_h = bld.fpconvert(prob, f16_simd)
        p_off = bld.index_expr(row * cfg.mma.k_tile + col, bindings=bindings)
        tokens.append(bld.store(prob_h, bld.ptr_add(prob_ptr, p_off), after=after))

    tokens.extend(_stage_probability_padding(bld, cfg, prob_ptr, lane, after))

    return bld.barrier(*tokens)


def _stage_online_probability_tile(
    bld: dsl.FunctionBuilder,
    cfg: _FlashAttentionConfig,
    score_ptr: dsl.Value,
    prob_ptr: dsl.Value,
    lane: dsl.Value,
    after: dsl.Value,
    old_states: list[_OnlineSoftmaxState] | None = None,
) -> tuple[list[_OnlineSoftmaxState], dsl.Value]:
    lane_sym = dsl.sym("fa_lane")
    lane_expr = dsl.mod(lane_sym, cfg.mma.wave_size)
    bindings = {lane_sym: lane}
    f16_simd = dsl.simd_type(dsl.f16(), width=cfg.mma.wave_size)
    states: list[_OnlineSoftmaxState] = []
    tokens: list[dsl.Value] = []

    for step in range(_score_state_steps(cfg)):
        elem = lane_expr + step * cfg.mma.wave_size
        row = dsl.floor(elem / cfg.block_n)
        col = dsl.mod(elem, cfg.block_n)
        scores: list[dsl.Value] = []
        for n in range(cfg.block_n):
            score_idx = bld.index_expr(_score_slot_expr(cfg, row, n), bindings=bindings)
            score, _ = bld.load(
                bld.ptr_add(score_ptr, score_idx),
                dsl.simd_type(dsl.f32(), width=cfg.mma.wave_size),
                after=after,
            )
            scores.append(score)

        tile_max = _max_all(bld, tuple(scores))
        if old_states is None:
            row_max = tile_max
            denom: dsl.Value | None = None
        else:
            old = old_states[step]
            row_max = bld.fmax(old.row_max, tile_max)
            alpha = bld.fexp2(bld.fsub(old.row_max, row_max))
            denom = bld.fmul(old.denom, alpha)

        for score in scores:
            prob = bld.fexp2(bld.fsub(score, row_max))
            denom = prob if denom is None else bld.fadd(denom, prob)
        assert denom is not None

        prob_idx = bld.index_expr(_score_slot_expr(cfg, row, col), bindings=bindings)
        score, _ = bld.load(
            bld.ptr_add(score_ptr, prob_idx),
            dsl.simd_type(dsl.f32(), width=cfg.mma.wave_size),
            after=after,
        )
        prob = bld.fexp2(bld.fsub(score, row_max))
        prob_h = bld.fpconvert(prob, f16_simd)
        p_off = bld.index_expr(row * cfg.mma.k_tile + col, bindings=bindings)
        tokens.append(bld.store(prob_h, bld.ptr_add(prob_ptr, p_off), after=after))
        states.append(_OnlineSoftmaxState(row_max, denom))

    tokens.extend(_stage_probability_padding(bld, cfg, prob_ptr, lane, after))

    return states, bld.barrier(*tokens)


def _compute_output_online_states(
    bld: dsl.FunctionBuilder,
    cfg: _FlashAttentionConfig,
    score_ptr: dsl.Value,
    lane: dsl.Value,
    after: dsl.Value,
    old_states: list[_OnlineSoftmaxState] | None = None,
) -> list[_OnlineSoftmaxState]:
    lane_sym = dsl.sym("fa_lane")
    lane_expr = dsl.mod(lane_sym, cfg.mma.wave_size)
    bindings = {lane_sym: lane}
    states: list[_OnlineSoftmaxState] = []

    for step in range(_output_state_steps(cfg)):
        elem = lane_expr + step * cfg.mma.wave_size
        row = dsl.floor(elem / cfg.mma.n_tile)
        scores: list[dsl.Value] = []
        for n in range(cfg.block_n):
            score_idx = bld.index_expr(_score_slot_expr(cfg, row, n), bindings=bindings)
            score, _ = bld.load(
                bld.ptr_add(score_ptr, score_idx),
                dsl.simd_type(dsl.f32(), width=cfg.mma.wave_size),
                after=after,
            )
            scores.append(score)

        tile_max = _max_all(bld, tuple(scores))
        if old_states is None:
            row_max = tile_max
            denom: dsl.Value | None = None
        else:
            old = old_states[step]
            row_max = bld.fmax(old.row_max, tile_max)
            alpha = bld.fexp2(bld.fsub(old.row_max, row_max))
            denom = bld.fmul(old.denom, alpha)

        for score in scores:
            prob = bld.fexp2(bld.fsub(score, row_max))
            denom = prob if denom is None else bld.fadd(denom, prob)
        assert denom is not None
        states.append(_OnlineSoftmaxState(row_max, denom))

    return states


def _stage_probability_padding(
    bld: dsl.FunctionBuilder,
    cfg: _FlashAttentionConfig,
    prob_ptr: dsl.Value,
    lane: dsl.Value,
    after: dsl.Value,
) -> list[dsl.Value]:
    tokens: list[dsl.Value] = []
    tokens.extend(
        _store_zero_region(
            bld,
            cfg,
            prob_ptr,
            row_offset=0,
            row_count=cfg.block_m,
            col_offset=cfg.block_n,
            col_count=cfg.mma.k_tile - cfg.block_n,
            row_stride=cfg.mma.k_tile,
            lane=lane,
            after=after,
        )
    )
    tokens.extend(
        _store_zero_region(
            bld,
            cfg,
            prob_ptr,
            row_offset=cfg.block_m,
            row_count=cfg.mma.m_tile - cfg.block_m,
            col_offset=0,
            col_count=cfg.mma.k_tile,
            row_stride=cfg.mma.k_tile,
            lane=lane,
            after=after,
        )
    )
    return tokens


def _store_zero_region(
    bld: dsl.FunctionBuilder,
    cfg: _FlashAttentionConfig,
    ptr: dsl.Value,
    *,
    row_offset: int,
    row_count: int,
    col_offset: int,
    col_count: int,
    row_stride: int,
    lane: dsl.Value,
    after: dsl.Value,
) -> list[dsl.Value]:
    if row_count == 0 or col_count == 0:
        return []

    tokens: list[dsl.Value] = []
    offset = col_offset
    remaining = col_count
    while remaining:
        chunk = 1 << (remaining.bit_length() - 1)
        tokens.extend(
            _store_zero_region_chunk(
                bld,
                cfg,
                ptr,
                row_offset=row_offset,
                row_count=row_count,
                col_offset=offset,
                col_count=chunk,
                row_stride=row_stride,
                lane=lane,
                after=after,
            )
        )
        offset += chunk
        remaining -= chunk
    return tokens


def _store_zero_region_chunk(
    bld: dsl.FunctionBuilder,
    cfg: _FlashAttentionConfig,
    ptr: dsl.Value,
    *,
    row_offset: int,
    row_count: int,
    col_offset: int,
    col_count: int,
    row_stride: int,
    lane: dsl.Value,
    after: dsl.Value,
) -> list[dsl.Value]:
    if (row_count * col_count) % cfg.mma.wave_size:
        raise ValueError(
            "zero-fill region chunk must map to whole waves; "
            f"got rows={row_count}, cols={col_count}, wave={cfg.mma.wave_size}"
        )

    lane_sym = dsl.sym("fa_lane")
    lane_expr = dsl.mod(lane_sym, cfg.mma.wave_size)
    bindings = {lane_sym: lane}
    zero = _zero_f16_simd(bld, cfg.mma.wave_size)
    tokens: list[dsl.Value] = []

    for step in range((row_count * col_count) // cfg.mma.wave_size):
        elem = lane_expr + step * cfg.mma.wave_size
        row = row_offset + dsl.floor(elem / col_count)
        col = col_offset + dsl.mod(elem, col_count)
        off = bld.index_expr(row * row_stride + col, bindings=bindings)
        tokens.append(bld.store(zero, bld.ptr_add(ptr, off), after=after))
    return tokens


def _stage_value_padding(
    bld: dsl.FunctionBuilder,
    cfg: _FlashAttentionConfig,
    value_ptr: dsl.Value,
    lane: dsl.Value,
    after: dsl.Value,
) -> list[dsl.Value]:
    pad_cols = cfg.mma.k_tile - cfg.block_n
    return _store_zero_region(
        bld,
        cfg,
        value_ptr,
        row_offset=0,
        row_count=cfg.mma.n_tile,
        col_offset=cfg.block_n,
        col_count=pad_cols,
        row_stride=cfg.mma.k_tile,
        lane=lane,
        after=after,
    )


def _stage_value_tile(
    bld: dsl.FunctionBuilder,
    cfg: _FlashAttentionConfig,
    v_ptr: dsl.Value,
    value_ptr: dsl.Value,
    lane: dsl.Value,
    start_n: _ExprLike,
    d_tile: int,
    after: dsl.Value,
    bindings: dict[ixsimpl.Expr, dsl.Value] | None = None,
) -> dsl.Value:
    lane_sym = dsl.sym("fa_lane")
    lane_expr = dsl.mod(lane_sym, cfg.mma.wave_size)
    expr_bindings = dict(bindings or {})
    expr_bindings[lane_sym] = lane
    f16_simd = dsl.simd_type(dsl.f16(), width=cfg.mma.wave_size)
    tokens: list[dsl.Value] = []

    for step in range((cfg.mma.n_tile * cfg.block_n) // cfg.mma.wave_size):
        elem = lane_expr + step * cfg.mma.wave_size
        d_col = dsl.floor(elem / cfg.block_n)
        n = dsl.mod(elem, cfg.block_n)
        v_off = bld.index_expr(
            (start_n + n) * cfg.head_dim + d_tile * 16 + d_col,
            bindings=expr_bindings,
        )
        value, token = bld.load(bld.ptr_add(v_ptr, v_off), f16_simd, after=after)
        lds_off = bld.index_expr(d_col * cfg.mma.k_tile + n, bindings=expr_bindings)
        tokens.append(bld.store(value, bld.ptr_add(value_ptr, lds_off), after=token))

    tokens.extend(_stage_value_padding(bld, cfg, value_ptr, lane, after))

    return bld.barrier(*tokens)


def _store_fragment_as_row_major(
    bld: dsl.FunctionBuilder,
    cfg: _FlashAttentionConfig,
    scratch_ptr: dsl.Value,
    out_ptr: dsl.Value,
    lane: dsl.Value,
    d_tile: int,
    after: dsl.Value,
) -> dsl.Value:
    lane_sym = dsl.sym("fa_lane")
    lane_expr = dsl.mod(lane_sym, cfg.mma.wave_size)
    bindings = {lane_sym: lane}
    tokens: list[dsl.Value] = []
    for step in range(_output_state_steps(cfg)):
        elem = lane_expr + step * cfg.mma.wave_size
        row = dsl.floor(elem / cfg.mma.n_tile)
        col = dsl.mod(elem, cfg.mma.n_tile)
        scratch_off = bld.index_expr(_score_slot_expr(cfg, row, col), bindings=bindings)
        value, token = bld.load(
            bld.ptr_add(scratch_ptr, scratch_off),
            dsl.simd_type(dsl.f32(), width=cfg.mma.wave_size),
            after=after,
        )
        out_off = bld.index_expr(
            row * cfg.head_dim + d_tile * 16 + col,
            bindings=bindings,
        )
        tokens.append(bld.store(value, bld.ptr_add(out_ptr, out_off), after=token))
    return bld.barrier(*tokens)


def _reload_acc_fragment(
    bld: dsl.FunctionBuilder,
    cfg: _FlashAttentionConfig,
    types: _KernelTypes,
    scratch_ptr: dsl.Value,
    lane: dsl.Value,
    after: dsl.Value,
) -> dsl.Value:
    lane_sym = dsl.sym("fa_lane")
    lane_expr = dsl.mod(lane_sym, cfg.mma.wave_size)
    off = bld.index_expr(
        lane_expr * cfg.mma.acc_registers,
        bindings={lane_sym: lane},
    )
    frag, _ = bld.fragment_load(bld.ptr_add(scratch_ptr, off), types.acc, after=after)
    return frag


def _scale_acc_fragment_rows(
    bld: dsl.FunctionBuilder,
    cfg: _FlashAttentionConfig,
    types: _KernelTypes,
    fragment: dsl.Value,
    scratch_ptr: dsl.Value,
    lane: dsl.Value,
    old_states: list[_OnlineSoftmaxState],
    new_states: list[_OnlineSoftmaxState],
    after: dsl.Value,
) -> dsl.Value:
    store = bld.fragment_store(fragment, scratch_ptr, after=after)
    ready = bld.barrier(store)
    lane_sym = dsl.sym("fa_lane")
    lane_expr = dsl.mod(lane_sym, cfg.mma.wave_size)
    bindings = {lane_sym: lane}
    tokens: list[dsl.Value] = []

    for step, (old, new) in enumerate(zip(old_states, new_states, strict=True)):
        elem = lane_expr + step * cfg.mma.wave_size
        row = dsl.floor(elem / cfg.mma.n_tile)
        col = dsl.mod(elem, cfg.mma.n_tile)
        scratch_off = bld.index_expr(_score_slot_expr(cfg, row, col), bindings=bindings)
        value, token = bld.load(
            bld.ptr_add(scratch_ptr, scratch_off),
            dsl.simd_type(dsl.f32(), width=cfg.mma.wave_size),
            after=ready,
        )
        alpha = bld.fexp2(bld.fsub(old.row_max, new.row_max))
        scaled = bld.fmul(value, alpha)
        tokens.append(
            bld.store(scaled, bld.ptr_add(scratch_ptr, scratch_off), after=token)
        )

    scaled_ready = bld.barrier(*tokens)
    return _reload_acc_fragment(bld, cfg, types, scratch_ptr, lane, scaled_ready)


def _store_denoms(
    bld: dsl.FunctionBuilder,
    cfg: _FlashAttentionConfig,
    denom_ptr: dsl.Value,
    lane: dsl.Value,
    states: list[_OnlineSoftmaxState],
    after: dsl.Value,
) -> dsl.Value:
    lane_sym = dsl.sym("fa_lane")
    lane_expr = dsl.mod(lane_sym, cfg.mma.wave_size)
    bindings = {lane_sym: lane}
    tokens: list[dsl.Value] = []

    for step, state in enumerate(states):
        elem = lane_expr + step * cfg.mma.wave_size
        row = dsl.floor(elem / cfg.mma.n_tile)
        col = dsl.mod(elem, cfg.mma.n_tile)
        off = bld.index_expr(row * cfg.mma.n_tile + col, bindings=bindings)
        tokens.append(bld.store(state.denom, bld.ptr_add(denom_ptr, off), after=after))

    return bld.barrier(*tokens)


def _store_normalized_fragment_as_row_major(
    bld: dsl.FunctionBuilder,
    cfg: _FlashAttentionConfig,
    fragment: dsl.Value,
    scratch_ptr: dsl.Value,
    denom_ptr: dsl.Value,
    out_ptr: dsl.Value,
    lane: dsl.Value,
    d_tile: int,
    after: dsl.Value,
) -> dsl.Value:
    store = bld.fragment_store(fragment, scratch_ptr, after=after)
    ready = bld.barrier(store)
    lane_sym = dsl.sym("fa_lane")
    lane_expr = dsl.mod(lane_sym, cfg.mma.wave_size)
    bindings = {lane_sym: lane}
    tokens: list[dsl.Value] = []

    for step in range(_output_state_steps(cfg)):
        elem = lane_expr + step * cfg.mma.wave_size
        row = dsl.floor(elem / cfg.mma.n_tile)
        col = dsl.mod(elem, cfg.mma.n_tile)
        scratch_off = bld.index_expr(_score_slot_expr(cfg, row, col), bindings=bindings)
        denom_off = bld.index_expr(row * cfg.mma.n_tile + col, bindings=bindings)
        value, value_token = bld.load(
            bld.ptr_add(scratch_ptr, scratch_off),
            dsl.simd_type(dsl.f32(), width=cfg.mma.wave_size),
            after=ready,
        )
        denom, denom_token = bld.load(
            bld.ptr_add(denom_ptr, denom_off),
            dsl.simd_type(dsl.f32(), width=cfg.mma.wave_size),
            after=ready,
        )
        normalized = bld.fmul(value, bld.frcp(denom))
        out_off = bld.index_expr(
            row * cfg.head_dim + d_tile * 16 + col,
            bindings=bindings,
        )
        tokens.append(
            bld.store(
                normalized,
                bld.ptr_add(out_ptr, out_off),
                after=bld.after(value_token, denom_token),
            )
        )
    return bld.barrier(*tokens)


def _emit_single_tile_mma_kernel(
    bld: dsl.FunctionBuilder,
    cfg: _FlashAttentionConfig,
    types: _KernelTypes,
    q_arg: dsl.Value,
    k_arg: dsl.Value,
    v_arg: dsl.Value,
    out_arg: dsl.Value,
    lane: dsl.Value,
) -> None:
    score_ptr = bld.lds_base(dsl.f32())
    prob_ptr = bld.lds_base(dsl.f16(), offset=cfg.score_lds_bytes)
    value_ptr = bld.lds_base(dsl.f16(), offset=cfg.score_lds_bytes + cfg.prob_lds_bytes)
    scratch_dep = bld.token()

    qk = _emit_qk_tile(bld, cfg, types, q_arg, k_arg, lane, 0)
    score_store = bld.fragment_store(qk, score_ptr, after=scratch_dep)
    score_ready = bld.barrier(score_store)
    prob_ready = _stage_probability_tile(
        bld, cfg, score_ptr, prob_ptr, lane, score_ready
    )

    for d_tile in range(cfg.head_dim // 16):
        value_ready = _stage_value_tile(
            bld, cfg, v_arg, value_ptr, lane, 0, d_tile, score_ready
        )
        operands_ready = bld.barrier(prob_ready, value_ready)
        p_frag = _load_row_major_fragment(
            bld, cfg, prob_ptr, types.a, cfg.mma.k_tile, lane, operands_ready
        )
        v_frag = _load_row_major_fragment(
            bld, cfg, value_ptr, types.b, cfg.mma.k_tile, lane, operands_ready
        )
        acc = bld.fragment_fill(bld.constant(dsl.i32(), 0), types.acc)
        acc = bld.mma(cfg.mma.kind, p_frag, v_frag, acc)
        acc_store = bld.fragment_store(acc, score_ptr, after=operands_ready)
        acc_ready = bld.barrier(acc_store)
        scratch_dep = _store_fragment_as_row_major(
            bld, cfg, score_ptr, out_arg, lane, d_tile, acc_ready
        )


def _emit_first_online_accs(
    bld: dsl.FunctionBuilder,
    cfg: _FlashAttentionConfig,
    types: _KernelTypes,
    v_arg: dsl.Value,
    prob_ptr: dsl.Value,
    value_ptr: dsl.Value,
    lane: dsl.Value,
    score_ready: dsl.Value,
    prob_ready: dsl.Value,
) -> list[dsl.Value]:
    accs: list[dsl.Value] = []
    for d_tile in range(cfg.head_dim // 16):
        value_ready = _stage_value_tile(
            bld, cfg, v_arg, value_ptr, lane, 0, d_tile, score_ready
        )
        operands_ready = bld.barrier(prob_ready, value_ready)
        p_frag = _load_row_major_fragment(
            bld, cfg, prob_ptr, types.a, cfg.mma.k_tile, lane, operands_ready
        )
        v_frag = _load_row_major_fragment(
            bld, cfg, value_ptr, types.b, cfg.mma.k_tile, lane, operands_ready
        )
        acc = bld.fragment_fill(bld.constant(dsl.i32(), 0), types.acc)
        accs.append(bld.mma(cfg.mma.kind, p_frag, v_frag, acc))
    return accs


def _alloc_online_scratch(
    bld: dsl.FunctionBuilder, cfg: _FlashAttentionConfig
) -> _OnlineScratch:
    score_ptr = bld.lds_base(dsl.f32())
    prob_ptr = bld.lds_base(dsl.f16(), offset=cfg.score_lds_bytes)
    value_ptr = bld.lds_base(dsl.f16(), offset=cfg.score_lds_bytes + cfg.prob_lds_bytes)
    denom_ptr = bld.lds_base(
        dsl.f32(),
        offset=cfg.score_lds_bytes + cfg.prob_lds_bytes + cfg.value_lds_bytes,
    )
    return _OnlineScratch(score_ptr, prob_ptr, value_ptr, denom_ptr)


def _flatten_online_tile_state(
    cfg: _FlashAttentionConfig, state: _OnlineTileState
) -> tuple[dsl.Value, ...]:
    if _score_states_match_output_layout(cfg):
        return (*_flatten_online_state(state.score_states), *state.accs)
    return (
        *_flatten_online_state(state.score_states),
        *_flatten_online_state(state.output_states),
        *state.accs,
    )


def _split_online_tile_state(
    cfg: _FlashAttentionConfig, values: tuple[dsl.Value, ...]
) -> _OnlineTileState:
    score_steps = _score_state_steps(cfg)
    score_states = _split_online_state(values, score_steps)
    if _score_states_match_output_layout(cfg):
        return _OnlineTileState(
            score_states, score_states, list(values[score_steps * 2 :])
        )

    state_offset = score_steps * 2
    output_steps = _output_state_steps(cfg)
    output_states = _split_online_state(values[state_offset:], output_steps)
    accs = list(values[state_offset + output_steps * 2 :])
    return _OnlineTileState(score_states, output_states, accs)


def _emit_initial_online_tile(
    bld: dsl.FunctionBuilder,
    cfg: _FlashAttentionConfig,
    types: _KernelTypes,
    q_arg: dsl.Value,
    k_arg: dsl.Value,
    v_arg: dsl.Value,
    scratch: _OnlineScratch,
    lane: dsl.Value,
    scratch_dep: dsl.Value,
) -> _OnlineTileState:
    qk = _emit_qk_tile(bld, cfg, types, q_arg, k_arg, lane, 0)
    score_store = bld.fragment_store(qk, scratch.score_ptr, after=scratch_dep)
    score_ready = bld.barrier(score_store)
    score_states, prob_ready = _stage_online_probability_tile(
        bld, cfg, scratch.score_ptr, scratch.prob_ptr, lane, score_ready
    )
    if _score_states_match_output_layout(cfg):
        output_states = score_states
    else:
        output_states = _compute_output_online_states(
            bld, cfg, scratch.score_ptr, lane, score_ready
        )
    accs = _emit_first_online_accs(
        bld,
        cfg,
        types,
        v_arg,
        scratch.prob_ptr,
        scratch.value_ptr,
        lane,
        score_ready,
        prob_ready,
    )
    return _OnlineTileState(score_states, output_states, accs)


def _emit_next_online_accs(
    bld: dsl.FunctionBuilder,
    cfg: _FlashAttentionConfig,
    types: _KernelTypes,
    v_arg: dsl.Value,
    scratch: _OnlineScratch,
    lane: dsl.Value,
    start_n: _ExprLike,
    bindings: dict[ixsimpl.Expr, dsl.Value],
    prob_ready: dsl.Value,
    score_ready: dsl.Value,
    old_state: _OnlineTileState,
    next_output_states: list[_OnlineSoftmaxState],
) -> list[dsl.Value]:
    next_accs: list[dsl.Value] = []
    for d_tile, old_acc in enumerate(old_state.accs):
        value_ready = _stage_value_tile(
            bld,
            cfg,
            v_arg,
            scratch.value_ptr,
            lane,
            start_n,
            d_tile,
            score_ready,
            bindings=bindings,
        )
        operands_ready = bld.barrier(prob_ready, value_ready)
        scaled_acc = _scale_acc_fragment_rows(
            bld,
            cfg,
            types,
            old_acc,
            scratch.score_ptr,
            lane,
            old_state.output_states,
            next_output_states,
            operands_ready,
        )
        p_frag = _load_row_major_fragment(
            bld, cfg, scratch.prob_ptr, types.a, cfg.mma.k_tile, lane, operands_ready
        )
        v_frag = _load_row_major_fragment(
            bld, cfg, scratch.value_ptr, types.b, cfg.mma.k_tile, lane, operands_ready
        )
        next_accs.append(bld.mma(cfg.mma.kind, p_frag, v_frag, scaled_acc))
    return next_accs


def _emit_next_online_tile(
    bld: dsl.FunctionBuilder,
    cfg: _FlashAttentionConfig,
    types: _KernelTypes,
    q_arg: dsl.Value,
    k_arg: dsl.Value,
    v_arg: dsl.Value,
    scratch: _OnlineScratch,
    lane: dsl.Value,
    loop_iv: dsl.Value,
    old_state: _OnlineTileState,
) -> _OnlineTileState:
    lane_sym = dsl.sym("fa_lane")
    tile_sym = dsl.sym("fa_tile")
    start_n = tile_sym * cfg.block_n
    bindings = {lane_sym: lane, tile_sym: loop_iv}
    qk = _emit_qk_tile(bld, cfg, types, q_arg, k_arg, lane, start_n, bindings)
    score_store = bld.fragment_store(qk, scratch.score_ptr, after=bld.token())
    score_ready = bld.barrier(score_store)
    score_states, prob_ready = _stage_online_probability_tile(
        bld,
        cfg,
        scratch.score_ptr,
        scratch.prob_ptr,
        lane,
        score_ready,
        old_state.score_states,
    )
    if _score_states_match_output_layout(cfg):
        output_states = score_states
    else:
        output_states = _compute_output_online_states(
            bld, cfg, scratch.score_ptr, lane, score_ready, old_state.output_states
        )
    accs = _emit_next_online_accs(
        bld,
        cfg,
        types,
        v_arg,
        scratch,
        lane,
        start_n,
        bindings,
        prob_ready,
        score_ready,
        old_state,
        output_states,
    )
    return _OnlineTileState(score_states, output_states, accs)


def _emit_multi_tile_mma_kernel(
    bld: dsl.FunctionBuilder,
    cfg: _FlashAttentionConfig,
    types: _KernelTypes,
    q_arg: dsl.Value,
    k_arg: dsl.Value,
    v_arg: dsl.Value,
    out_arg: dsl.Value,
    lane: dsl.Value,
) -> None:
    scratch = _alloc_online_scratch(bld, cfg)
    scratch_dep = bld.token()
    state = _emit_initial_online_tile(
        bld, cfg, types, q_arg, k_arg, v_arg, scratch, lane, scratch_dep
    )

    num_tiles = cfg.seq_len // cfg.block_n
    if num_tiles > 1:
        c1 = bld.constant(dsl.i32(), 1)
        upper = bld.constant(dsl.i32(), num_tiles)
        with bld.for_loop(
            c1,
            upper,
            c1,
            init_args=_flatten_online_tile_state(cfg, state),
            unroll=cfg.tile_loop_unroll,
        ) as loop:
            loop_state = _split_online_tile_state(cfg, tuple(loop.inner_iter_args))
            next_state = _emit_next_online_tile(
                bld,
                cfg,
                types,
                q_arg,
                k_arg,
                v_arg,
                scratch,
                lane,
                loop.induction_variable,
                loop_state,
            )
            bld.yield_(_flatten_online_tile_state(cfg, next_state))
        state = _split_online_tile_state(cfg, tuple(loop.results))

    scratch_dep = _store_denoms(
        bld, cfg, scratch.denom_ptr, lane, state.output_states, scratch_dep
    )
    for d_tile, acc in enumerate(state.accs):
        scratch_dep = _store_normalized_fragment_as_row_major(
            bld,
            cfg,
            acc,
            scratch.score_ptr,
            scratch.denom_ptr,
            out_arg,
            lane,
            d_tile,
            scratch_dep,
        )


def _emit_kernel(bld: dsl.FunctionBuilder, cfg: _FlashAttentionConfig) -> None:
    q_arg, k_arg, v_arg, out_arg = bld.args
    q_arg = _wrap_in_buffer(bld, q_arg, dsl.f16(), cfg.q_elements, 2)
    k_arg = _wrap_in_buffer(bld, k_arg, dsl.f16(), cfg.kv_elements, 2)
    v_arg = _wrap_in_buffer(bld, v_arg, dsl.f16(), cfg.kv_elements, 2)
    out_arg = _wrap_in_buffer(bld, out_arg, dsl.f32(), cfg.out_elements, 4)
    lane = bld.assume_range(
        bld.workitem_id(axis=0, width=cfg.mma.wave_size),
        0,
        cfg.threads_per_workgroup - 1,
    )
    types = _kernel_types(cfg)
    if cfg.seq_len == cfg.block_n:
        _emit_single_tile_mma_kernel(
            bld, cfg, types, q_arg, k_arg, v_arg, out_arg, lane
        )
        return
    _emit_multi_tile_mma_kernel(bld, cfg, types, q_arg, k_arg, v_arg, out_arg, lane)


def _emit_constant_fill(
    bld: dsl.FunctionBuilder,
    buf: dsl.Value,
    values: tuple[float, ...],
    element_type: dsl.Type,
    index_type: dsl.Type,
) -> None:
    for i, value in enumerate(values):
        bld.memref_store(
            bld.constant(element_type, value), buf, [bld.constant(index_type, i)]
        )


def _emit_zero_fill(
    bld: dsl.FunctionBuilder,
    buf: dsl.Value,
    count: int,
    index_type: dsl.Type,
) -> None:
    c0 = bld.constant(index_type, 0)
    c1 = bld.constant(index_type, 1)
    total = bld.constant(index_type, count)
    zero = bld.constant(dsl.f32(), 0.0)
    with bld.for_loop(c0, total, c1) as i:
        bld.memref_store(zero, buf, [i])


def _emit_host(bld: dsl.FunctionBuilder, cfg: _FlashAttentionConfig) -> None:
    index = dsl.index_type()
    f16 = dsl.f16()
    f32 = dsl.f32()
    f16_ptr = dsl.ptr_type(f16)
    f32_ptr = dsl.ptr_type(f32)
    c1 = bld.constant(index, 1)
    threads = bld.constant(index, cfg.threads_per_workgroup)

    q_values, k_values, v_values = generate_flash_attention_f32_inputs(
        cfg.block_m,
        cfg.block_n,
        cfg.head_dim,
        random_seed=cfg.random_seed,
        seq_n=cfg.seq_n,
    )
    q_buf = bld.alloc([cfg.q_elements], f16)
    k_buf = bld.alloc([cfg.kv_elements], f16)
    v_buf = bld.alloc([cfg.kv_elements], f16)
    out_buf = bld.alloc([cfg.out_elements], f32)

    _emit_constant_fill(bld, q_buf, q_values, f16, index)
    _emit_constant_fill(bld, k_buf, k_values, f16, index)
    _emit_constant_fill(bld, v_buf, v_values, f16, index)
    _emit_zero_fill(bld, out_buf, cfg.out_elements, index)

    q_unranked = bld.cast_unranked(q_buf)
    k_unranked = bld.cast_unranked(k_buf)
    v_unranked = bld.cast_unranked(v_buf)
    out_unranked = bld.cast_unranked(out_buf)
    bld.host_register(q_unranked)
    bld.host_register(k_unranked)
    bld.host_register(v_unranked)
    bld.host_register(out_unranked)

    dyn_f16 = dsl.dynamic_1d_memref_type(f16)
    dyn_f32 = dsl.dynamic_1d_memref_type(f32)
    [q_ptr] = bld.call(_F16_PTR_HELPER, [bld.memref_cast(q_buf, dyn_f16)], [f16_ptr])
    [k_ptr] = bld.call(_F16_PTR_HELPER, [bld.memref_cast(k_buf, dyn_f16)], [f16_ptr])
    [v_ptr] = bld.call(_F16_PTR_HELPER, [bld.memref_cast(v_buf, dyn_f16)], [f16_ptr])
    [out_ptr] = bld.call(
        _F32_PTR_HELPER, [bld.memref_cast(out_buf, dyn_f32)], [f32_ptr]
    )

    bld.launch(
        _GPU_MODULE_NAME,
        _KERNEL_NAME,
        grid=(c1, c1, c1),
        block=(threads, c1, c1),
        operands=[q_ptr, k_ptr, v_ptr, out_ptr],
    )
    bld.call(_PRINT_HELPER, [out_unranked])


def build_flash_attention_f32_module(
    *,
    block_m: int = 16,
    block_n: int = 16,
    head_dim: int = 16,
    random_seed: int = 0,
    seq_n: int | None = None,
    matrix_intrinsic: str = "wmma",
    target_waves: int | None = None,
    tile_loop_unroll: int | None = None,
) -> Module:
    cfg = _FlashAttentionConfig(
        block_m,
        block_n,
        head_dim,
        random_seed=random_seed,
        seq_n=seq_n,
        matrix_intrinsic=matrix_intrinsic,
        tile_loop_unroll=tile_loop_unroll,
    )
    bld = dsl.ModuleBuilder()
    with bld:
        bld.declare_external(
            _F16_PTR_HELPER,
            [dsl.dynamic_1d_memref_type(dsl.f16())],
            [dsl.ptr_type(dsl.f16())],
        )
        dyn_f32 = dsl.dynamic_1d_memref_type(dsl.f32())
        bld.declare_external(_F32_PTR_HELPER, [dyn_f32], [dsl.ptr_type(dsl.f32())])
        bld.declare_external(_PRINT_HELPER, [dsl.unranked_memref_type(dsl.f32())], [])
        kernel_inputs = [
            dsl.ptr_type(dsl.f16()),
            dsl.ptr_type(dsl.f16()),
            dsl.ptr_type(dsl.f16()),
            dsl.ptr_type(dsl.f32()),
        ]
        with (
            bld.gpu_module(_GPU_MODULE_NAME) as gmod,
            gmod.kernel(
                _KERNEL_NAME,
                kernel_inputs,
                lds_size=cfg.lds_bytes,
                attrs=_target_waves_attrs(target_waves),
            ) as fb,
        ):
            _emit_kernel(fb, cfg)
        with bld.host_main() as fb:
            _emit_host(fb, cfg)
    return bld.module


__all__ = [
    "build_flash_attention_f32_module",
    "compute_flash_attention_f32_reference",
    "generate_flash_attention_f32_inputs",
]
