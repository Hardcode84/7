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
    score_layout: str = "wmma"


_MMA_VARIANTS = {
    "wmma": _MmaVariant("wmma", "wmma.f32.16x16x16.f16", 8, 8),
    "mfma_gfx950": _MmaVariant(
        "mfma_gfx950", "mfma.f32.16x16x32.f16", 4, 4, 64, 8, 32, "mfma"
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
        return self.block_m * self.block_n * 4

    @property
    def prob_lds_bytes(self) -> int:
        return self.block_m * self.mma.k_tile * 2

    @property
    def value_lds_bytes(self) -> int:
        return 16 * self.mma.k_tile * 2

    @property
    def denom_lds_bytes(self) -> int:
        return self.block_m * 16 * 4

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
    if cfg.block_m != 16 or cfg.block_n != 16:
        raise ValueError(
            "MMA FA kernel requires block_m=16 and block_n=16; "
            f"got block_m={cfg.block_m}, block_n={cfg.block_n}"
        )
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


@dataclass(frozen=True)
class _KernelTypes:
    a: dsl.Type
    b: dsl.Type
    acc: dsl.Type


@dataclass(frozen=True)
class _OnlineSoftmaxState:
    row_max: dsl.Value
    denom: dsl.Value


def _kernel_types(cfg: _FlashAttentionConfig) -> _KernelTypes:
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
    lane_mod16 = dsl.mod(lane_expr, 16)
    lane_k_off = dsl.floor(lane_expr / 16) * cfg.mma.lane_k_elems
    q_off = bld.index_expr(
        lane_mod16 * cfg.head_dim + lane_k_off + k_step * cfg.mma.k_tile,
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
    lane_mod16 = dsl.mod(lane_expr, 16)
    lane_k_off = dsl.floor(lane_expr / 16) * cfg.mma.lane_k_elems
    expr_bindings = dict(bindings or {})
    expr_bindings[lane_sym] = lane_value
    k_off = bld.index_expr(
        (start_n + lane_mod16) * cfg.head_dim + lane_k_off + k_step * cfg.mma.k_tile,
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
    lane_mod16 = dsl.mod(lane_expr, 16)
    lane_k_off = dsl.floor(lane_expr / 16) * cfg.mma.lane_k_elems
    off = bld.index_expr(
        lane_mod16 * row_stride + lane_k_off,
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
        return (_mod_expr(row, 2) * 16 + col) * cfg.mma.acc_registers + _floor_div_expr(
            row, 2
        )
    if cfg.mma.score_layout == "mfma":
        return (row * 4 + _mod_expr(col, 4)) * cfg.mma.acc_registers + (
            _floor_div_expr(col, 4)
        )
    raise AssertionError(f"unknown score layout {cfg.mma.score_layout}")


def _online_state_steps(cfg: _FlashAttentionConfig) -> int:
    return (cfg.block_m * cfg.block_n) // cfg.mma.wave_size


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

    for step in range(_online_state_steps(cfg)):
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

    pad_cols = cfg.mma.k_tile - cfg.block_n
    if pad_cols:
        zero = _zero_f16_simd(bld, cfg.mma.wave_size)
        for step in range((cfg.block_m * pad_cols) // cfg.mma.wave_size):
            elem = lane_expr + step * cfg.mma.wave_size
            row = dsl.floor(elem / pad_cols)
            col = cfg.block_n + dsl.mod(elem, pad_cols)
            p_off = bld.index_expr(row * cfg.mma.k_tile + col, bindings=bindings)
            tokens.append(bld.store(zero, bld.ptr_add(prob_ptr, p_off), after=after))

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

    for step in range(_online_state_steps(cfg)):
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

    pad_cols = cfg.mma.k_tile - cfg.block_n
    if pad_cols:
        zero = _zero_f16_simd(bld, cfg.mma.wave_size)
        for step in range((cfg.block_m * pad_cols) // cfg.mma.wave_size):
            elem = lane_expr + step * cfg.mma.wave_size
            row = dsl.floor(elem / pad_cols)
            col = cfg.block_n + dsl.mod(elem, pad_cols)
            p_off = bld.index_expr(row * cfg.mma.k_tile + col, bindings=bindings)
            tokens.append(bld.store(zero, bld.ptr_add(prob_ptr, p_off), after=after))

    return states, bld.barrier(*tokens)


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

    for step in range((16 * cfg.block_n) // cfg.mma.wave_size):
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

    pad_cols = cfg.mma.k_tile - cfg.block_n
    if pad_cols:
        zero = _zero_f16_simd(bld, cfg.mma.wave_size)
        for step in range((16 * pad_cols) // cfg.mma.wave_size):
            elem = lane_expr + step * cfg.mma.wave_size
            d_col = dsl.floor(elem / pad_cols)
            n = cfg.block_n + dsl.mod(elem, pad_cols)
            lds_off = bld.index_expr(
                d_col * cfg.mma.k_tile + n,
                bindings=expr_bindings,
            )
            tokens.append(bld.store(zero, bld.ptr_add(value_ptr, lds_off), after=after))

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
    for step in range((16 * 16) // cfg.mma.wave_size):
        elem = lane_expr + step * cfg.mma.wave_size
        row = dsl.floor(elem / 16)
        col = dsl.mod(elem, 16)
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
        row = dsl.floor(elem / 16)
        col = dsl.mod(elem, 16)
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
        row = dsl.floor(elem / 16)
        col = dsl.mod(elem, 16)
        off = bld.index_expr(row * 16 + col, bindings=bindings)
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

    for step in range(_online_state_steps(cfg)):
        elem = lane_expr + step * cfg.mma.wave_size
        row = dsl.floor(elem / 16)
        col = dsl.mod(elem, 16)
        scratch_off = bld.index_expr(_score_slot_expr(cfg, row, col), bindings=bindings)
        denom_off = bld.index_expr(row * 16 + col, bindings=bindings)
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
    lane_sym = dsl.sym("fa_lane")
    score_ptr = bld.lds_base(dsl.f32())
    prob_ptr = bld.lds_base(dsl.f16(), offset=cfg.score_lds_bytes)
    value_ptr = bld.lds_base(dsl.f16(), offset=cfg.score_lds_bytes + cfg.prob_lds_bytes)
    denom_ptr = bld.lds_base(
        dsl.f32(),
        offset=cfg.score_lds_bytes + cfg.prob_lds_bytes + cfg.value_lds_bytes,
    )
    scratch_dep = bld.token()
    qk = _emit_qk_tile(bld, cfg, types, q_arg, k_arg, lane, 0)
    score_store = bld.fragment_store(qk, score_ptr, after=scratch_dep)
    score_ready = bld.barrier(score_store)
    states, prob_ready = _stage_online_probability_tile(
        bld, cfg, score_ptr, prob_ptr, lane, score_ready
    )
    accs = _emit_first_online_accs(
        bld, cfg, types, v_arg, prob_ptr, value_ptr, lane, score_ready, prob_ready
    )

    num_tiles = cfg.seq_len // cfg.block_n
    if num_tiles > 1:
        c1 = bld.constant(dsl.i32(), 1)
        upper = bld.constant(dsl.i32(), num_tiles)
        state_steps = _online_state_steps(cfg)
        init_args = (*_flatten_online_state(states), *accs)
        with bld.for_loop(
            c1, upper, c1, init_args=init_args, unroll=cfg.tile_loop_unroll
        ) as loop:
            tile_sym = dsl.sym("fa_tile")
            loop_args = tuple(loop.inner_iter_args)
            loop_states = _split_online_state(loop_args, state_steps)
            loop_accs = loop_args[state_steps * 2 :]
            start_n = tile_sym * cfg.block_n
            bindings = {lane_sym: lane, tile_sym: loop.induction_variable}
            qk = _emit_qk_tile(bld, cfg, types, q_arg, k_arg, lane, start_n, bindings)
            score_store = bld.fragment_store(qk, score_ptr, after=bld.token())
            score_ready = bld.barrier(score_store)
            next_states, prob_ready = _stage_online_probability_tile(
                bld, cfg, score_ptr, prob_ptr, lane, score_ready, loop_states
            )
            next_accs: list[dsl.Value] = []

            for d_tile, old_acc in enumerate(loop_accs):
                value_ready = _stage_value_tile(
                    bld,
                    cfg,
                    v_arg,
                    value_ptr,
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
                    score_ptr,
                    lane,
                    loop_states,
                    next_states,
                    operands_ready,
                )
                p_frag = _load_row_major_fragment(
                    bld, cfg, prob_ptr, types.a, cfg.mma.k_tile, lane, operands_ready
                )
                v_frag = _load_row_major_fragment(
                    bld, cfg, value_ptr, types.b, cfg.mma.k_tile, lane, operands_ready
                )
                next_accs.append(bld.mma(cfg.mma.kind, p_frag, v_frag, scaled_acc))

            bld.yield_((*_flatten_online_state(next_states), *next_accs))
        result_values = tuple(loop.results)
        states = _split_online_state(result_values, state_steps)
        accs = list(result_values[state_steps * 2 :])

    scratch_dep = _store_denoms(bld, cfg, denom_ptr, lane, states, scratch_dep)
    for d_tile, acc in enumerate(accs):
        scratch_dep = _store_normalized_fragment_as_row_major(
            bld, cfg, acc, score_ptr, denom_ptr, out_arg, lane, d_tile, scratch_dep
        )


def _emit_kernel(bld: dsl.FunctionBuilder, cfg: _FlashAttentionConfig) -> None:
    q_arg, k_arg, v_arg, out_arg = bld.args
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
