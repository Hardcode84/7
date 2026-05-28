#  Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
#  See https://llvm.org/LICENSE.txt for license information.
#  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

"""Builder for a one-wave f32 FlashAttention forward kernel."""

from __future__ import annotations

import math
from dataclasses import dataclass

from mlir.dialects import wave_dsl as dsl
from mlir.ir import Module

_KERNEL_NAME = "flash_attention_f32"
_GPU_MODULE_NAME = "kernels"
_F32_PTR_HELPER = "wave_memref_to_ptr_global_f32"
_PRINT_HELPER = "printMemrefF32"


@dataclass(frozen=True)
class _FlashAttentionConfig:
    block_m: int
    block_n: int
    head_dim: int
    random_seed: int = 0

    def __post_init__(self) -> None:
        for name, value in (
            ("block_m", self.block_m),
            ("block_n", self.block_n),
            ("head_dim", self.head_dim),
        ):
            if value <= 0:
                raise ValueError(f"{name} must be positive; got {value}")
        if self.block_m * self.head_dim != 32:
            raise ValueError(
                "current one-wave FA kernel requires block_m * head_dim == 32; "
                f"got {self.block_m} * {self.head_dim}"
            )
        if self.head_dim & (self.head_dim - 1):
            raise ValueError(f"head_dim must be a power of two; got {self.head_dim}")

    @property
    def q_elements(self) -> int:
        return self.block_m * self.head_dim

    @property
    def kv_elements(self) -> int:
        return self.block_n * self.head_dim

    @property
    def out_elements(self) -> int:
        return self.q_elements


def _rand_values(
    count: int, *, seed: int, stream: int, scale: float
) -> tuple[float, ...]:
    state = (seed ^ ((stream + 1) * 0x9E3779B9)) & 0xFFFFFFFF
    values: list[float] = []
    for _ in range(count):
        state = (1664525 * state + 1013904223) & 0xFFFFFFFF
        values.append((((state >> 24) % 17) - 8) * scale)
    return tuple(values)


def generate_flash_attention_f32_inputs(
    block_m: int,
    block_n: int,
    head_dim: int,
    *,
    random_seed: int = 0,
) -> tuple[tuple[float, ...], tuple[float, ...], tuple[float, ...]]:
    cfg = _FlashAttentionConfig(block_m, block_n, head_dim, random_seed)
    q_base = _rand_values(cfg.q_elements, seed=random_seed, stream=0, scale=0.0625)
    k_values = _rand_values(cfg.kv_elements, seed=random_seed, stream=1, scale=0.0625)
    v_values = _rand_values(cfg.kv_elements, seed=random_seed, stream=2, scale=0.125)
    scale = math.log2(math.e) / math.sqrt(cfg.head_dim)
    q_values = tuple(x * scale for x in q_base)
    return q_values, k_values, v_values


def compute_flash_attention_f32_reference(
    block_m: int,
    block_n: int,
    head_dim: int,
    *,
    random_seed: int = 0,
) -> tuple[float, ...]:
    cfg = _FlashAttentionConfig(block_m, block_n, head_dim, random_seed)
    q_values, k_values, v_values = generate_flash_attention_f32_inputs(
        block_m, block_n, head_dim, random_seed=random_seed
    )
    out: list[float] = []
    for m in range(cfg.block_m):
        scores: list[float] = []
        for n in range(cfg.block_n):
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


def _ptr_add_const(bld: dsl.FunctionBuilder, ptr: dsl.Value, offset: int) -> dsl.Value:
    if offset == 0:
        return ptr
    return bld.ptr_add(ptr, bld.constant(dsl.i32(), offset))


def _load_f32(bld: dsl.FunctionBuilder, ptr: dsl.Value) -> dsl.Value:
    value, _ = bld.load(ptr, dsl.simd_type(dsl.f32()))
    return value


def _load_q(
    bld: dsl.FunctionBuilder,
    q_ptr: dsl.Value,
    lane: dsl.Value,
    head_dim: int,
    k: int,
) -> dsl.Value:
    lane_sym = dsl.sym("fa_lane")
    q_off = bld.index_expr(
        dsl.floor(lane_sym / head_dim) * head_dim + k,
        bindings={lane_sym: lane},
    )
    return _load_f32(bld, bld.ptr_add(q_ptr, q_off))


def _score_for_n(
    bld: dsl.FunctionBuilder,
    cfg: _FlashAttentionConfig,
    q_ptr: dsl.Value,
    k_ptr: dsl.Value,
    lane: dsl.Value,
    n: int,
) -> dsl.Value:
    score: dsl.Value | None = None
    for k in range(cfg.head_dim):
        q = _load_q(bld, q_ptr, lane, cfg.head_dim, k)
        kval = _load_f32(bld, _ptr_add_const(bld, k_ptr, n * cfg.head_dim + k))
        term = bld.fmul(q, kval)
        score = term if score is None else bld.fadd(score, term)
    assert score is not None
    return score


def _emit_kernel(bld: dsl.FunctionBuilder, cfg: _FlashAttentionConfig) -> None:
    q_arg, k_arg, v_arg, out_arg = bld.args
    lane = bld.assume_range(bld.workitem_id(axis=0), 0, 31)
    lane_sym = dsl.sym("fa_lane")
    d_expr = dsl.mod(lane_sym, cfg.head_dim)
    bindings = {lane_sym: lane}

    scores = tuple(
        _score_for_n(bld, cfg, q_arg, k_arg, lane, n) for n in range(cfg.block_n)
    )
    row_max = scores[0]
    for score in scores[1:]:
        row_max = bld.fmax(row_max, score)

    probs: list[dsl.Value] = []
    denom: dsl.Value | None = None
    numer: dsl.Value | None = None
    for n, score in enumerate(scores):
        prob = bld.fexp2(bld.fsub(score, row_max))
        probs.append(prob)
        denom = prob if denom is None else bld.fadd(denom, prob)
        v_off = bld.index_expr(n * cfg.head_dim + d_expr, bindings=bindings)
        v_val = _load_f32(bld, bld.ptr_add(v_arg, v_off))
        term = bld.fmul(prob, v_val)
        numer = term if numer is None else bld.fadd(numer, term)

    assert denom is not None and numer is not None
    out_val = bld.fmul(numer, bld.frcp(denom))
    out_off = bld.index_expr(lane_sym, bindings=bindings)
    bld.store(out_val, bld.ptr_add(out_arg, out_off))


def _emit_constant_fill(
    bld: dsl.FunctionBuilder,
    buf: dsl.Value,
    values: tuple[float, ...],
    index_type: dsl.Type,
) -> None:
    f32 = dsl.f32()
    for i, value in enumerate(values):
        bld.memref_store(bld.constant(f32, value), buf, [bld.constant(index_type, i)])


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
    f32 = dsl.f32()
    f32_ptr = dsl.ptr_type(f32)
    c1 = bld.constant(index, 1)
    threads = bld.constant(index, 32)

    q_values, k_values, v_values = generate_flash_attention_f32_inputs(
        cfg.block_m, cfg.block_n, cfg.head_dim, random_seed=cfg.random_seed
    )
    q_buf = bld.alloc([cfg.q_elements], f32)
    k_buf = bld.alloc([cfg.kv_elements], f32)
    v_buf = bld.alloc([cfg.kv_elements], f32)
    out_buf = bld.alloc([cfg.out_elements], f32)

    _emit_constant_fill(bld, q_buf, q_values, index)
    _emit_constant_fill(bld, k_buf, k_values, index)
    _emit_constant_fill(bld, v_buf, v_values, index)
    _emit_zero_fill(bld, out_buf, cfg.out_elements, index)

    q_unranked = bld.cast_unranked(q_buf)
    k_unranked = bld.cast_unranked(k_buf)
    v_unranked = bld.cast_unranked(v_buf)
    out_unranked = bld.cast_unranked(out_buf)
    bld.host_register(q_unranked)
    bld.host_register(k_unranked)
    bld.host_register(v_unranked)
    bld.host_register(out_unranked)

    dyn_f32 = dsl.dynamic_1d_memref_type(f32)
    [q_ptr] = bld.call(_F32_PTR_HELPER, [bld.memref_cast(q_buf, dyn_f32)], [f32_ptr])
    [k_ptr] = bld.call(_F32_PTR_HELPER, [bld.memref_cast(k_buf, dyn_f32)], [f32_ptr])
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
    block_m: int = 4,
    block_n: int = 8,
    head_dim: int = 8,
    random_seed: int = 0,
) -> Module:
    cfg = _FlashAttentionConfig(block_m, block_n, head_dim, random_seed)
    bld = dsl.ModuleBuilder()
    with bld:
        dyn_f32 = dsl.dynamic_1d_memref_type(dsl.f32())
        bld.declare_external(_F32_PTR_HELPER, [dyn_f32], [dsl.ptr_type(dsl.f32())])
        bld.declare_external(_PRINT_HELPER, [dsl.unranked_memref_type(dsl.f32())], [])
        kernel_inputs = [
            dsl.ptr_type(dsl.f32()),
            dsl.ptr_type(dsl.f32()),
            dsl.ptr_type(dsl.f32()),
            dsl.ptr_type(dsl.f32()),
        ]
        with (
            bld.gpu_module(_GPU_MODULE_NAME) as gmod,
            gmod.kernel(_KERNEL_NAME, kernel_inputs) as fb,
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
