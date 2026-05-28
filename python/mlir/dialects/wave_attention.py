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
    def output_chunks(self) -> int:
        return self.out_elements // self.mma.wave_size

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


def _validate_positive_config(cfg: _FlashAttentionConfig) -> None:
    for name, value in (
        ("block_m", cfg.block_m),
        ("block_n", cfg.block_n),
        ("head_dim", cfg.head_dim),
    ):
        _require_positive(name, value)
    if cfg.seq_n is not None:
        _require_positive("seq_n", cfg.seq_n)


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
    return q_values, tuple(_round_f16(x) for x in k_values), v_values


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


def _load_f32(bld: dsl.FunctionBuilder, ptr: dsl.Value, wave_size: int) -> dsl.Value:
    value, _ = bld.load(ptr, dsl.simd_type(dsl.f32(), width=wave_size))
    return value


@dataclass(frozen=True)
class _KernelTypes:
    a: dsl.Type
    b: dsl.Type
    acc: dsl.Type


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
    start_n: int,
    k_step: int,
) -> dsl.Value:
    lane_sym = dsl.sym("fa_lane")
    lane_expr = dsl.mod(lane_sym, cfg.mma.wave_size)
    lane_mod16 = dsl.mod(lane_expr, 16)
    lane_k_off = dsl.floor(lane_expr / 16) * cfg.mma.lane_k_elems
    k_off = bld.index_expr(
        (start_n + lane_mod16) * cfg.head_dim + lane_k_off + k_step * cfg.mma.k_tile,
        bindings={lane_sym: lane_value},
    )
    frag, _ = bld.fragment_load(bld.ptr_add(k_ptr, k_off), types.b)
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
    start_n: int,
) -> dsl.Value:
    acc = bld.fragment_fill(bld.constant(dsl.i32(), 0), types.acc)
    for k_step in range(cfg.head_dim // cfg.mma.k_tile):
        q_frag = _load_q_fragment(bld, cfg, types, q_ptr, lane, k_step)
        k_frag = _load_k_fragment(bld, cfg, types, k_ptr, lane, start_n, k_step)
        acc = bld.mma(cfg.mma.kind, q_frag, k_frag, acc)
    return acc


def _score_slot_expr(
    cfg: _FlashAttentionConfig, row: ixsimpl.Expr, col: int
) -> ixsimpl.Expr:
    if cfg.mma.score_layout == "wmma":
        return (dsl.mod(row, 2) * 16 + col) * cfg.mma.acc_registers + dsl.floor(row / 2)
    if cfg.mma.score_layout == "mfma":
        return (row * 4 + (col % 4)) * cfg.mma.acc_registers + (col // 4)
    raise AssertionError(f"unknown score layout {cfg.mma.score_layout}")


def _load_score_values(
    bld: dsl.FunctionBuilder,
    cfg: _FlashAttentionConfig,
    score_ptr: dsl.Value,
    lane: dsl.Value,
    chunk: int,
    after: dsl.Value,
) -> tuple[tuple[int, ...], tuple[dsl.Value, ...], tuple[dsl.Value, ...]]:
    lane_sym = dsl.sym("fa_lane")
    out_idx = lane_sym + chunk * cfg.mma.wave_size
    row = dsl.floor(out_idx / cfg.head_dim)
    bindings = {lane_sym: lane}
    ns = tuple(range(cfg.block_n))
    scores: list[dsl.Value] = []
    tokens: list[dsl.Value] = []
    for col in ns:
        score_idx = bld.index_expr(_score_slot_expr(cfg, row, col), bindings=bindings)
        score, token = bld.load(
            bld.ptr_add(score_ptr, score_idx),
            dsl.simd_type(dsl.f32(), width=cfg.mma.wave_size),
            after=after,
        )
        scores.append(score)
        tokens.append(token)
    return ns, tuple(scores), tuple(tokens)


def _emit_first_tile(
    bld: dsl.FunctionBuilder,
    cfg: _FlashAttentionConfig,
    v_ptr: dsl.Value,
    d_expr: ixsimpl.Expr,
    bindings: dict[ixsimpl.Expr, dsl.Value],
    start_n: int,
    ns: tuple[int, ...],
    scores: tuple[dsl.Value, ...],
) -> tuple[dsl.Value, dsl.Value, dsl.Value]:
    row_max = _max_all(bld, scores)
    denom: dsl.Value | None = None
    numer: dsl.Value | None = None

    for n, score in zip(ns, scores, strict=True):
        prob = bld.fexp2(bld.fsub(score, row_max))
        denom = prob if denom is None else bld.fadd(denom, prob)
        v_off = bld.index_expr((start_n + n) * cfg.head_dim + d_expr, bindings=bindings)
        v_val = _load_f32(bld, bld.ptr_add(v_ptr, v_off), cfg.mma.wave_size)
        weighted = bld.fmul(prob, v_val)
        numer = weighted if numer is None else bld.fadd(numer, weighted)

    assert denom is not None and numer is not None
    return row_max, denom, numer


def _emit_online_tile(
    bld: dsl.FunctionBuilder,
    cfg: _FlashAttentionConfig,
    v_ptr: dsl.Value,
    d_expr: ixsimpl.Expr,
    bindings: dict[ixsimpl.Expr, dsl.Value],
    start_n: int,
    row_max: dsl.Value,
    denom: dsl.Value,
    numer: dsl.Value,
    ns: tuple[int, ...],
    scores: tuple[dsl.Value, ...],
) -> tuple[dsl.Value, dsl.Value, dsl.Value]:
    next_max = bld.fmax(row_max, _max_all(bld, scores))
    alpha = bld.fexp2(bld.fsub(row_max, next_max))
    next_denom = bld.fmul(denom, alpha)
    next_numer = bld.fmul(numer, alpha)

    for n, score in zip(ns, scores, strict=True):
        prob = bld.fexp2(bld.fsub(score, next_max))
        next_denom = bld.fadd(next_denom, prob)
        v_off = bld.index_expr((start_n + n) * cfg.head_dim + d_expr, bindings=bindings)
        v_val = _load_f32(bld, bld.ptr_add(v_ptr, v_off), cfg.mma.wave_size)
        next_numer = bld.fadd(next_numer, bld.fmul(prob, v_val))

    return next_max, next_denom, next_numer


def _emit_kernel(bld: dsl.FunctionBuilder, cfg: _FlashAttentionConfig) -> None:
    q_arg, k_arg, v_arg, out_arg = bld.args
    lane = bld.assume_range(
        bld.workitem_id(axis=0, width=cfg.mma.wave_size),
        0,
        cfg.threads_per_workgroup - 1,
    )
    lane_sym = dsl.sym("fa_lane")
    types = _kernel_types(cfg)
    score_ptr = bld.lds_base(dsl.f32())
    states: list[tuple[dsl.Value, dsl.Value, dsl.Value] | None] = [
        None for _ in range(cfg.output_chunks)
    ]
    scratch_dep = bld.token()

    for start_n in range(0, cfg.seq_len, cfg.block_n):
        qk = _emit_qk_tile(bld, cfg, types, q_arg, k_arg, lane, start_n)
        score_store = bld.fragment_store(qk, score_ptr, after=scratch_dep)
        score_ready = bld.barrier(score_store)
        score_tokens: list[dsl.Value] = []

        for chunk in range(cfg.output_chunks):
            out_idx = lane_sym + chunk * cfg.mma.wave_size
            d_expr = dsl.mod(out_idx, cfg.head_dim)
            bindings = {lane_sym: lane}
            ns, scores, tokens = _load_score_values(
                bld, cfg, score_ptr, lane, chunk, score_ready
            )
            score_tokens.extend(tokens)
            state = states[chunk]
            if state is None:
                states[chunk] = _emit_first_tile(
                    bld, cfg, v_arg, d_expr, bindings, start_n, ns, scores
                )
            else:
                row_max, denom, numer = state
                states[chunk] = _emit_online_tile(
                    bld,
                    cfg,
                    v_arg,
                    d_expr,
                    bindings,
                    start_n,
                    row_max,
                    denom,
                    numer,
                    ns,
                    scores,
                )

        scratch_dep = bld.barrier(*score_tokens)

    for chunk, state in enumerate(states):
        assert state is not None
        _, denom, numer = state
        out_idx = lane_sym + chunk * cfg.mma.wave_size
        out_val = bld.fmul(numer, bld.frcp(denom))
        out_off = bld.index_expr(out_idx, bindings={lane_sym: lane})
        bld.store(out_val, bld.ptr_add(out_arg, out_off), after=scratch_dep)


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
    v_buf = bld.alloc([cfg.kv_elements], f32)
    out_buf = bld.alloc([cfg.out_elements], f32)

    _emit_constant_fill(bld, q_buf, q_values, f16, index)
    _emit_constant_fill(bld, k_buf, k_values, f16, index)
    _emit_constant_fill(bld, v_buf, v_values, f32, index)
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
    [v_ptr] = bld.call(_F32_PTR_HELPER, [bld.memref_cast(v_buf, dyn_f32)], [f32_ptr])
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
) -> Module:
    cfg = _FlashAttentionConfig(
        block_m,
        block_n,
        head_dim,
        random_seed=random_seed,
        seq_n=seq_n,
        matrix_intrinsic=matrix_intrinsic,
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
            dsl.ptr_type(dsl.f32()),
            dsl.ptr_type(dsl.f32()),
        ]
        with (
            bld.gpu_module(_GPU_MODULE_NAME) as gmod,
            gmod.kernel(
                _KERNEL_NAME,
                kernel_inputs,
                lds_size=cfg.score_lds_bytes,
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
