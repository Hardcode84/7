#  Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
#  See https://llvm.org/LICENSE.txt for license information.
#  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

"""gfx950 BF16 FlashAttention forward kernel in the Wave Python DSL."""

from __future__ import annotations

import math
from dataclasses import dataclass

import ixsimpl
from mlir.dialects import wave_dsl as dsl
from mlir.ir import Module, UnitAttr

_KERNEL_NAME = "flash_attention_bf16_gfx950"
_GPU_MODULE_NAME = "kernels"
_TARGET_WAVES_ATTR = "waveamdmachine.target_waves"
_MULTI_WAVE_SPECIALIZATION_ATTR = "waveamdmachine.enable_multi_wave_specialization"
_DYNAMIC_LDS_ATTR = "wave.dynamic_lds_size"

_WAVE_SIZE = 64
_DEFAULT_WAVES = 8
_BLOCK_M = 256
_BLOCK_N = 64
_HEAD_DIM = 128
_MFMA_TILE = 32
_MFMA_K = 16
_AB_REGISTERS = 4
_ACC_REGISTERS = 16
_PV_PREFIX_MFMAS = 3
_HEAD_EXP_COUNT = 21
_BF16_MIN_NORMAL_LOG2 = -126.0
_K_ROW_GROUPS = _BLOCK_N // 8
_K_STRIDE = 512 + 8
_V_STRIDE = 8 * _BLOCK_N + 32
_K_TILE_ELEMENTS = 2 * _K_ROW_GROUPS * _K_STRIDE
_V_TILE_ELEMENTS = 2 * 8 * _V_STRIDE
_K_TILE_BYTES = 2 * _K_TILE_ELEMENTS
_V_TILE_BYTES = 2 * _V_TILE_ELEMENTS
_PING_PONG_STAGES = 2


@dataclass(frozen=True)
class Gfx950FlashAttentionConfig:
    batch: int = 2
    heads: int = 64
    sequence: int = 8192
    xcds: int = 8
    waves: int = _DEFAULT_WAVES
    qk_max_abs: float | None = None

    def _validate_positive(self) -> None:
        for name, value in (
            ("batch", self.batch),
            ("heads", self.heads),
            ("sequence", self.sequence),
            ("xcds", self.xcds),
            ("waves", self.waves),
        ):
            if value <= 0:
                raise ValueError(f"{name} must be positive; got {value}")

    def _validate_qk_bound(self) -> None:
        if self.qk_max_abs is None:
            return
        if not math.isfinite(self.qk_max_abs) or self.qk_max_abs <= 0:
            raise ValueError(
                f"qk_max_abs must be finite and positive; got {self.qk_max_abs}"
            )
        score_bound = self.log2_score_bound
        if score_bound is not None and -2.0 * score_bound < _BF16_MIN_NORMAL_LOG2:
            raise ValueError(
                "qk_max_abs fixed reference exceeds BF16 range; "
                "use adaptive reference"
            )

    def __post_init__(self) -> None:
        self._validate_positive()
        if self.xcds not in (1, 2, 4, 8):
            raise ValueError(f"xcds must be 1, 2, 4, or 8; got {self.xcds}")
        if self.waves not in (4, 8):
            raise ValueError(f"waves must be 4 or 8; got {self.waves}")
        self._validate_qk_bound()
        if self.sequence % _BLOCK_M:
            raise ValueError(
                f"sequence must be a multiple of {_BLOCK_M}; got {self.sequence}"
            )
        if self.tile_count < 4:
            raise ValueError(f"sequence must be at least 256; got {self.sequence}")

    @property
    def grid(self) -> tuple[int, int, int]:
        return self.sequence // _BLOCK_M, self.batch * self.heads, 1

    @property
    def elements(self) -> int:
        return self.batch * self.heads * self.sequence * _HEAD_DIM

    @property
    def head_elements(self) -> int:
        return self.sequence * _HEAD_DIM

    @property
    def tile_count(self) -> int:
        return self.sequence // _BLOCK_N

    @property
    def log2_score_bound(self) -> float | None:
        if self.qk_max_abs is None:
            return None
        return (
            math.log2(math.e) * math.sqrt(_HEAD_DIM) * self.qk_max_abs * self.qk_max_abs
        )

    @property
    def threads(self) -> int:
        return self.waves * _WAVE_SIZE

    @property
    def query_groups(self) -> int:
        return _BLOCK_M // (self.waves * _MFMA_TILE)

    @property
    def dynamic_lds_bytes(self) -> int:
        return self.data_lds_bytes

    @property
    def data_lds_bytes(self) -> int:
        return self.k_lds_stages * _K_TILE_BYTES + self.v_lds_stages * _V_TILE_BYTES

    @property
    def k_lds_stages(self) -> int:
        if self.waves == 8:
            return 2 * _PING_PONG_STAGES
        return _PING_PONG_STAGES

    @property
    def v_lds_stages(self) -> int:
        return self.k_lds_stages

    @property
    def flops(self) -> int:
        return 4 * self.batch * self.heads * self.sequence * self.sequence * _HEAD_DIM


@dataclass(frozen=True)
class _KernelTypes:
    a: dsl.Type
    b: dsl.Type
    acc: dsl.Type
    ab_packet: dsl.Type
    acc_packet: dsl.Type
    scalar: dsl.Type


@dataclass(frozen=True)
class _LdsBuffer:
    k: dsl.Value
    v: dsl.Value


@dataclass(frozen=True)
class _AttentionState:
    outputs: tuple[dsl.Value, ...]
    row_max: dsl.Value
    row_sum: dsl.Value


@dataclass(frozen=True)
class _KernelContext:
    cfg: Gfx950FlashAttentionConfig
    types: _KernelTypes
    workgroup_m: dsl.Value
    workitem: dsl.Value
    workitem_first: dsl.Value
    k_buffer: dsl.Value
    v_buffer: dsl.Value
    output_buffer: dsl.Value
    lds: tuple[_LdsBuffer, ...]
    q_fragments: tuple[tuple[dsl.Value, ...], ...]
    root: dsl.Value


@dataclass(frozen=True)
class _PipelineTokens:
    k_ready: tuple[dsl.Value, ...]
    k_free: tuple[dsl.Value, ...]
    previous_v_ready: dsl.Value
    v_free: tuple[dsl.Value, ...]


@dataclass(frozen=True)
class _PipelineSeed:
    scores: tuple[tuple[dsl.Value, ...], ...]
    states: tuple[_AttentionState, ...]
    tokens: _PipelineTokens


@dataclass(frozen=True)
class _PendingSoftmax:
    state: _AttentionState
    previous_max: dsl.Value
    scale: dsl.Value
    initialize: bool


def _kernel_types() -> _KernelTypes:
    return _KernelTypes(
        a=dsl.fragment_type(
            1, dsl.bf16(), _MFMA_TILE, _MFMA_TILE, _WAVE_SIZE, _AB_REGISTERS
        ),
        b=dsl.fragment_type(
            0, dsl.bf16(), _MFMA_TILE, _MFMA_TILE, _WAVE_SIZE, _AB_REGISTERS
        ),
        acc=dsl.fragment_type(
            2, dsl.f32(), _MFMA_TILE, _MFMA_TILE, _WAVE_SIZE, _ACC_REGISTERS
        ),
        ab_packet=dsl.simd_type(dsl.vector_type(8, dsl.bf16()), _WAVE_SIZE),
        acc_packet=dsl.simd_type(dsl.vector_type(16, dsl.f32()), _WAVE_SIZE),
        scalar=dsl.simd_type(dsl.f32(), _WAVE_SIZE),
    )


def _join(bld: dsl.FunctionBuilder, tokens: list[dsl.Value]) -> dsl.Value:
    if len(tokens) == 1:
        return tokens[0]
    return bld.join(*tokens)


def _stage_end(bld: dsl.FunctionBuilder, *dependencies: dsl.Value) -> dsl.Value:
    bld.sched_barrier()
    token = bld.barrier(*dependencies)
    bld.sched_barrier()
    return token


def _tile_expr(
    tile: int | dsl.Value, name: str
) -> tuple[int | ixsimpl.Expr, dict[ixsimpl.Expr, dsl.Value]]:
    if isinstance(tile, int):
        return tile, {}
    symbol = dsl.sym(name)
    return symbol, {symbol: tile}


def _head_buffer(
    bld: dsl.FunctionBuilder,
    base: dsl.Value,
    head: dsl.Value,
    cfg: Gfx950FlashAttentionConfig,
) -> dsl.Value:
    head_symbol = dsl.sym("fa_head")
    offset = bld.index_expr(
        head_symbol * cfg.head_elements, bindings={head_symbol: head}
    )
    ptr = bld.ptr_add(base, offset)
    size = bld.constant(dsl.i32(), cfg.head_elements * 2)
    return bld.make_buffer(ptr, size, dsl.buffer_ptr_type(dsl.bf16()))


def _workgroup_coords(
    bld: dsl.FunctionBuilder, cfg: Gfx950FlashAttentionConfig
) -> tuple[dsl.Value, dsl.Value]:
    m_blocks = cfg.sequence // _BLOCK_M
    head_blocks = cfg.batch * cfg.heads
    raw_m = bld.assume_range(bld.workgroup_id(0), 0, m_blocks - 1)
    raw_head = bld.assume_range(bld.workgroup_id(1), 0, head_blocks - 1)
    total = m_blocks * head_blocks
    if total % cfg.xcds:
        return raw_m, raw_head

    m = dsl.sym("fa_wg_m_raw")
    head = dsl.sym("fa_wg_head_raw")
    raw_pid = head * m_blocks + m
    pids_per_xcd = total // cfg.xcds
    pid = dsl.mod(raw_pid, cfg.xcds) * pids_per_xcd + dsl.floor(raw_pid / cfg.xcds)
    bindings = {m: raw_m, head: raw_head}
    return (
        bld.index_expr(dsl.mod(pid, m_blocks), bindings=bindings),
        bld.index_expr(dsl.floor(pid / m_blocks), bindings=bindings),
    )


def _lds_buffers(
    bld: dsl.FunctionBuilder,
    cfg: Gfx950FlashAttentionConfig,
) -> tuple[_LdsBuffer, ...]:
    k_base = bld.shared_memory_base(dsl.bf16())
    v_base = bld.shared_memory_base(
        dsl.bf16(),
        offset=cfg.k_lds_stages * _K_TILE_BYTES,
    )
    return tuple(
        _LdsBuffer(
            bld.ptr_add(
                k_base,
                bld.constant(
                    dsl.index_type(),
                    stage * _K_TILE_ELEMENTS,
                ),
            ),
            bld.ptr_add(
                v_base,
                bld.constant(
                    dsl.index_type(),
                    stage * _V_TILE_ELEMENTS,
                ),
            ),
        )
        for stage in range(cfg.k_lds_stages)
    )


def _issue_operand(
    bld: dsl.FunctionBuilder,
    cfg: Gfx950FlashAttentionConfig,
    source_buffer: dsl.Value,
    lds: dsl.Value,
    lds_stride: int,
    workitem: dsl.Value,
    workitem_first: dsl.Value,
    tile: int | dsl.Value,
    after: dsl.Value,
    *,
    name: str,
) -> dsl.Value:
    tile_value, tile_bindings = _tile_expr(tile, name)
    wi = dsl.sym("fa_dma_wi")
    wi_first = dsl.sym("fa_dma_wi_first")
    lane = dsl.mod(wi, _WAVE_SIZE)
    wave = dsl.floor(wi / _WAVE_SIZE)
    wave_first = dsl.floor(wi_first / _WAVE_SIZE)
    bindings = {wi: workitem, **tile_bindings}
    first_bindings = {wi_first: workitem_first}
    row_group = dsl.floor(lane / 8)
    d_group = dsl.mod(lane, 8) * 8
    dma_ptr_type = dsl.ptr_type(dsl.i32(), dsl.shared_address_space())
    dma_lds = bld.ptr_cast(lds, dma_ptr_type)

    tokens: list[dsl.Value] = []
    dma_waves = _BLOCK_N * _HEAD_DIM * 2 // (_WAVE_SIZE * 16)
    for wave_packet in range(dma_waves // cfg.waves):
        packet_wave = wave + wave_packet * cfg.waves
        packet_wave_first = wave_first + wave_packet * cfg.waves
        row = (
            tile_value * _BLOCK_N
            + dsl.mod(packet_wave, _K_ROW_GROUPS)
            + _K_ROW_GROUPS * row_group
        )
        d_chunk = dsl.floor(packet_wave / _K_ROW_GROUPS)
        src_offset = bld.index_expr(
            row * _HEAD_DIM + d_chunk * 64 + d_group,
            bindings=bindings,
        )
        src_offset = bld.assume_range(
            src_offset,
            0,
            cfg.head_elements + 3 * _BLOCK_N * _HEAD_DIM,
        )
        source = bld.ptr_add(source_buffer, src_offset)
        lds_offset = bld.index_expr(
            packet_wave_first * (lds_stride // 2),
            bindings=first_bindings,
        )
        tokens.append(
            bld.dma_load_lds(
                source,
                bld.ptr_add(dma_lds, lds_offset),
                after=after,
                bytes=16,
                zero_fill_inactive=True,
            )
        )
    return _join(bld, tokens)


def _load_q(
    bld: dsl.FunctionBuilder,
    cfg: Gfx950FlashAttentionConfig,
    types: _KernelTypes,
    q_buffer: dsl.Value,
    workgroup_m: dsl.Value,
    workitem: dsl.Value,
) -> tuple[tuple[dsl.Value, ...], ...]:
    wi = dsl.sym("fa_q_wi")
    block = dsl.sym("fa_q_block")
    lane = dsl.mod(wi, _WAVE_SIZE)
    wave = dsl.floor(wi / _WAVE_SIZE)
    k_half = dsl.floor(lane / _MFMA_TILE) * 8
    bindings = {wi: workitem, block: workgroup_m}
    groups: list[tuple[dsl.Value, ...]] = []
    for query_group in range(cfg.query_groups):
        row = (
            block * _BLOCK_M
            + (query_group * cfg.waves + wave) * _MFMA_TILE
            + dsl.mod(lane, _MFMA_TILE)
        )
        fragments: list[dsl.Value] = []
        for k_step in range(_HEAD_DIM // _MFMA_K):
            offset = bld.index_expr(
                row * _HEAD_DIM + k_step * _MFMA_K + k_half, bindings=bindings
            )
            offset = bld.assume_range(offset, 0, cfg.head_elements - 1)
            packet, _ = bld.load(bld.ptr_add(q_buffer, offset), types.ab_packet)
            fragments.append(bld.fragment_pack(packet, types.a))
        groups.append(tuple(fragments))
    return tuple(groups)


def _zero_acc(bld: dsl.FunctionBuilder, types: _KernelTypes) -> dsl.Value:
    zero = bld.splat(bld.constant(dsl.f32(), 0.0), dsl.f32(), _WAVE_SIZE)
    return bld.fragment_pack(bld.pack([zero] * 16, types.acc_packet), types.acc)


def _load_k_fragment(
    bld: dsl.FunctionBuilder,
    types: _KernelTypes,
    lds: dsl.Value,
    workitem: dsl.Value,
    n_tile: int,
    k_step: int,
    *,
    after: dsl.Value | None = None,
) -> tuple[dsl.Value, dsl.Value]:
    wi = dsl.sym("fa_k_wi")
    lane = dsl.mod(wi, _WAVE_SIZE)
    n = n_tile * _MFMA_TILE + dsl.mod(lane, _MFMA_TILE)
    d = k_step * _MFMA_K + dsl.floor(lane / _MFMA_TILE) * 8
    offset = bld.index_expr(
        _K_STRIDE * (dsl.mod(n, _K_ROW_GROUPS) + _K_ROW_GROUPS * dsl.floor(d / 64))
        + 64 * dsl.floor(n / _K_ROW_GROUPS)
        + dsl.mod(d, 64),
        bindings={wi: workitem},
    )
    packet, token = bld.load(bld.ptr_add(lds, offset), types.ab_packet, after=after)
    return bld.fragment_pack(packet, types.b), token


def _load_k_tile(
    bld: dsl.FunctionBuilder,
    types: _KernelTypes,
    k_lds: dsl.Value,
    workitem: dsl.Value,
    *,
    after: dsl.Value | None = None,
) -> tuple[tuple[dsl.Value, ...], list[dsl.Value]]:
    fragments: list[dsl.Value] = []
    tokens: list[dsl.Value] = []
    for k_step in range(_HEAD_DIM // _MFMA_K):
        for n_tile in range(_BLOCK_N // _MFMA_TILE):
            k_fragment, token = _load_k_fragment(
                bld, types, k_lds, workitem, n_tile, k_step, after=after
            )
            fragments.append(k_fragment)
            tokens.append(token)
    return tuple(fragments), tokens


def _score_tiles(
    bld: dsl.FunctionBuilder,
    types: _KernelTypes,
    q_fragments: tuple[tuple[dsl.Value, ...], ...],
    k_fragments: tuple[dsl.Value, ...],
) -> tuple[tuple[dsl.Value, ...], ...]:
    grouped_scores = [
        [_zero_acc(bld, types) for _ in range(_BLOCK_N // _MFMA_TILE)]
        for _ in q_fragments
    ]
    for k_step in range(_HEAD_DIM // _MFMA_K):
        for query_group, group_fragments in enumerate(q_fragments):
            for n_tile in range(_BLOCK_N // _MFMA_TILE):
                grouped_scores[query_group][n_tile] = bld.mma(
                    "mfma.f32.32x32x16.bf16",
                    k_fragments[(_BLOCK_N // _MFMA_TILE) * k_step + n_tile],
                    group_fragments[k_step],
                    grouped_scores[query_group][n_tile],
                )
    return tuple(
        tuple(bld.fragment_unpack(score, types.acc_packet) for score in scores)
        for scores in grouped_scores
    )


def _extract_components(
    bld: dsl.FunctionBuilder,
    packet: dsl.Value,
    scalar_type: dsl.Type,
) -> list[dsl.Value]:
    return [bld.extract(packet, i, scalar_type) for i in range(16)]


def _scale_packet(
    bld: dsl.FunctionBuilder,
    packet: dsl.Value,
    scale: dsl.Value,
    scalar_type: dsl.Type,
    packet_type: dsl.Type,
) -> dsl.Value:
    return bld.pack(
        [bld.fmul(bld.extract(packet, i, scalar_type), scale) for i in range(16)],
        packet_type,
    )


def _reduce_max(bld: dsl.FunctionBuilder, values: list[dsl.Value]) -> dsl.Value:
    result = values[0]
    for value in values[1:]:
        result = bld.fmax(result, value)
    return result


def _reduce_sum(bld: dsl.FunctionBuilder, values: list[dsl.Value]) -> dsl.Value:
    result = values[0]
    for value in values[1:]:
        result = bld.fadd(result, value)
    return result


def _exchange_half(
    bld: dsl.FunctionBuilder,
    value: dsl.Value,
    scalar_type: dsl.Type,
    *,
    items: int,
) -> dsl.Value:
    packet_type = dsl.simd_type(dsl.vector_type(1, dsl.f32()), _WAVE_SIZE)
    packet = bld.pack([value], packet_type)
    item = dsl.sym("item")
    moved = bld.redistribute(
        packet,
        packet_type,
        items=items,
        source_item=dsl.xor(item, dsl.sym_ctx.int_(32)),
        source_slot=dsl.sym("slot"),
    )
    return bld.extract(moved, 0, scalar_type)


def _rescale_outputs(
    bld: dsl.FunctionBuilder,
    types: _KernelTypes,
    state: _AttentionState,
    previous_max: dsl.Value,
) -> _AttentionState:
    alpha = bld.fexp2(bld.fsub(previous_max, state.row_max))
    outputs = [
        bld.fragment_pack(
            _scale_packet(
                bld,
                bld.fragment_unpack(output, types.acc_packet),
                alpha,
                types.scalar,
                types.acc_packet,
            ),
            types.acc,
        )
        for output in state.outputs
    ]
    return _AttentionState(
        tuple(outputs), state.row_max, bld.fmul(state.row_sum, alpha)
    )


def _lazy_rescale_outputs(
    bld: dsl.FunctionBuilder,
    types: _KernelTypes,
    state: _AttentionState,
    previous_max: dsl.Value,
) -> _AttentionState:
    advance = bld.fsub(state.row_max, previous_max)
    threshold = bld.splat(bld.constant(dsl.f32(), 8.0), dsl.f32(), _WAVE_SIZE)
    below = bld.cmpf("ole", advance, threshold)
    below_bits = bld.ballot(below, dsl.i64())
    all_below = bld.scalar_cmpi("eq", below_bits, bld.constant(dsl.i64(), -1))
    result_types = [types.acc] * len(state.outputs) + [types.scalar] * 2
    with bld.if_(all_below, result_types, otherwise=True) as branch:
        kept_outputs = tuple(
            bld.fragment_pack(bld.fragment_unpack(output, types.acc_packet), types.acc)
            for output in state.outputs
        )
        kept_max = bld.fmax(previous_max, previous_max)
        kept_sum = bld.fmax(state.row_sum, state.row_sum)
        bld.yield_((*kept_outputs, kept_max, kept_sum))
        with branch.otherwise():
            rescaled = _rescale_outputs(bld, types, state, previous_max)
            changed_max = bld.fmax(rescaled.row_max, rescaled.row_max)
            bld.yield_((*rescaled.outputs, changed_max, rescaled.row_sum))
    return _AttentionState(
        tuple(branch.results[:-2]), branch.results[-2], branch.results[-1]
    )


def _prepare_softmax_head(
    bld: dsl.FunctionBuilder,
    types: _KernelTypes,
    scores: tuple[dsl.Value, ...],
    state: _AttentionState,
    *,
    items: int,
    initialize: bool = False,
    log2_score_bound: float | None = None,
) -> _PendingSoftmax:
    scale = bld.splat(
        bld.constant(dsl.f32(), math.log2(math.e) / math.sqrt(_HEAD_DIM)),
        dsl.f32(),
        _WAVE_SIZE,
    )
    previous_max = state.row_max
    if log2_score_bound is not None:
        row_max = state.row_max
        if initialize:
            row_max = bld.splat(
                bld.constant(dsl.f32(), log2_score_bound),
                dsl.f32(),
                _WAVE_SIZE,
            )
    else:
        score_components = [
            _extract_components(bld, score, types.scalar) for score in scores
        ]
        flattened = [component for packet in score_components for component in packet]
        local_max = _reduce_max(bld, flattened)
        tile_max = bld.fmax(
            local_max, _exchange_half(bld, local_max, types.scalar, items=items)
        )
        tile_max = bld.fmul(tile_max, scale)
        row_max = tile_max if initialize else bld.fmax(state.row_max, tile_max)
    state = _AttentionState(state.outputs, row_max, state.row_sum)
    return _PendingSoftmax(state, previous_max, scale, initialize)


def _finish_softmax_head(
    bld: dsl.FunctionBuilder,
    types: _KernelTypes,
    scores: tuple[dsl.Value, ...],
    pending: _PendingSoftmax,
    *,
    adaptive_reference: bool,
) -> tuple[tuple[dsl.Value, ...], _AttentionState]:
    state = pending.state
    if not pending.initialize and adaptive_reference:
        state = _lazy_rescale_outputs(bld, types, state, pending.previous_max)
    score_components = [
        _extract_components(bld, score, types.scalar) for score in scores
    ]
    zero = bld.splat(bld.constant(dsl.f32(), 0.0), dsl.f32(), _WAVE_SIZE)
    neg_row_max = bld.fsub(zero, state.row_max)
    shifted_packets: list[dsl.Value] = []
    for packet_index, components in enumerate(score_components):
        shifted = [
            bld.fma(component, pending.scale, neg_row_max) for component in components
        ]
        shifted = [
            (
                bld.fexp2(component)
                if packet_index * 16 + index < _HEAD_EXP_COUNT
                else component
            )
            for index, component in enumerate(shifted)
        ]
        shifted_packets.append(bld.pack(shifted, types.acc_packet))
    return tuple(shifted_packets), state


def _softmax_head(
    bld: dsl.FunctionBuilder,
    types: _KernelTypes,
    scores: tuple[dsl.Value, ...],
    state: _AttentionState,
    *,
    items: int,
    initialize: bool = False,
    log2_score_bound: float | None = None,
) -> tuple[tuple[dsl.Value, ...], _AttentionState]:
    pending = _prepare_softmax_head(
        bld,
        types,
        scores,
        state,
        items=items,
        initialize=initialize,
        log2_score_bound=log2_score_bound,
    )
    return _finish_softmax_head(
        bld,
        types,
        scores,
        pending,
        adaptive_reference=log2_score_bound is None,
    )


def _softmax_tail(
    bld: dsl.FunctionBuilder,
    types: _KernelTypes,
    scores: tuple[dsl.Value, ...],
    state: _AttentionState,
    *,
    items: int,
) -> tuple[tuple[dsl.Value, ...], _AttentionState]:
    score_components = [
        _extract_components(bld, score, types.scalar) for score in scores
    ]
    for packet_index, components in enumerate(score_components):
        score_components[packet_index] = [
            (
                component
                if packet_index * 16 + index < _HEAD_EXP_COUNT
                else bld.fexp2(component)
            )
            for index, component in enumerate(components)
        ]
    local_sum = _reduce_sum(
        bld,
        [component for packet in score_components for component in packet],
    )
    bf16_packet_type = dsl.simd_type(dsl.vector_type(16, dsl.bf16()), _WAVE_SIZE)
    bf16_packets = [
        bld.fpconvert(
            bld.pack(components, types.acc_packet),
            bf16_packet_type,
        )
        for components in score_components
    ]

    tile_sum = bld.fadd(
        local_sum, _exchange_half(bld, local_sum, types.scalar, items=items)
    )
    row_sum = bld.fadd(state.row_sum, tile_sum)
    p_fragments: list[dsl.Value] = []
    for packet in bf16_packets:
        for offset in (0, 8):
            half = bld.extract(packet, offset, types.ab_packet)
            p_fragments.append(bld.fragment_pack(half, types.a))
    return tuple(p_fragments), _AttentionState(state.outputs, state.row_max, row_sum)


def _v_offset_expr(n_tile: int, k_step: int, half: int) -> ixsimpl.Expr:
    item = dsl.sym("fa_v_wi")
    lane = dsl.mod(item, _WAVE_SIZE)
    return (
        4 * dsl.mod(lane, 4)
        + _V_STRIDE * dsl.floor(dsl.mod(lane, 16) / 4)
        + 4 * _V_STRIDE * dsl.floor(lane / 32)
        + 16 * dsl.mod(dsl.floor(lane / 16), 2)
        + 8 * _V_STRIDE * (n_tile // 2)
        + 32 * (n_tile % 2)
        + 128 * k_step
        + 64 * half
    )


def _load_v_fragment(
    bld: dsl.FunctionBuilder,
    types: _KernelTypes,
    v_lds: dsl.Value,
    workitem: dsl.Value,
    n_tile: int,
    k_step: int,
    *,
    after: dsl.Value | None = None,
) -> tuple[dsl.Value, tuple[dsl.Value, dsl.Value]]:
    packets: list[dsl.Value] = []
    tokens: list[dsl.Value] = []
    result_type = dsl.simd_type(dsl.vector_type(4, dsl.bf16()), _WAVE_SIZE)
    for half in range(2):
        offset = bld.index_expr(
            _v_offset_expr(n_tile, k_step, half),
            bindings={dsl.sym("fa_v_wi"): workitem},
        )
        packet, token = bld.transpose_load(
            bld.ptr_add(v_lds, offset), result_type, after=after
        )
        packets.append(packet)
        tokens.append(token)
    packed = bld.pack(packets, types.ab_packet)
    return bld.fragment_pack(packed, types.b), (tokens[0], tokens[1])


def _load_v_tile(
    bld: dsl.FunctionBuilder,
    types: _KernelTypes,
    v_lds: dsl.Value,
    workitem: dsl.Value,
    *,
    after: dsl.Value | None = None,
) -> tuple[tuple[dsl.Value, ...], list[dsl.Value]]:
    fragments: list[dsl.Value] = []
    tokens: list[dsl.Value] = []
    for k_step in range(_BLOCK_N // _MFMA_K):
        for n_tile in range(4):
            v_fragment, fragment_tokens = _load_v_fragment(
                bld, types, v_lds, workitem, n_tile, k_step, after=after
            )
            fragments.append(v_fragment)
            tokens.extend(fragment_tokens)
    return tuple(fragments), tokens


def _pv_tiles_mfma_range(
    bld: dsl.FunctionBuilder,
    probabilities: tuple[tuple[dsl.Value, ...], ...],
    outputs: tuple[tuple[dsl.Value, ...], ...],
    v_fragments: tuple[dsl.Value, ...],
    begin: int,
    end: int,
) -> tuple[tuple[dsl.Value, ...], ...]:
    next_outputs = [list(group) for group in outputs]
    for index in range(begin, end):
        k_step, n_tile = divmod(index, 4)
        for query_group, group_probabilities in enumerate(probabilities):
            next_outputs[query_group][n_tile] = bld.mma(
                "mfma.f32.32x32x16.bf16",
                v_fragments[index],
                group_probabilities[k_step],
                next_outputs[query_group][n_tile],
            )
    return tuple(tuple(group) for group in next_outputs)


def _pv_tiles(
    bld: dsl.FunctionBuilder,
    probabilities: tuple[tuple[dsl.Value, ...], ...],
    outputs: tuple[tuple[dsl.Value, ...], ...],
    v_fragments: tuple[dsl.Value, ...],
) -> tuple[tuple[dsl.Value, ...], ...]:
    return _pv_tiles_mfma_range(
        bld, probabilities, outputs, v_fragments, 0, len(v_fragments)
    )


def _pipeline_phase_bulk(
    bld: dsl.FunctionBuilder,
    cfg: Gfx950FlashAttentionConfig,
    types: _KernelTypes,
    q_fragments: tuple[tuple[dsl.Value, ...], ...],
    k_buffer: dsl.Value,
    v_buffer: dsl.Value,
    current_lds: _LdsBuffer,
    previous_lds: _LdsBuffer,
    prefetch_lds: _LdsBuffer,
    workitem: dsl.Value,
    workitem_first: dsl.Value,
    tile: dsl.Value,
    prefetch_tile: dsl.Value | None,
    current_k_ready: dsl.Value,
    publish_k_ready: dsl.Value,
    prefetch_k_free: dsl.Value,
    previous_v_ready: dsl.Value,
    current_v_free: dsl.Value,
    previous_scores: tuple[tuple[dsl.Value, ...], ...],
    states: tuple[_AttentionState, ...],
    *,
    name: str,
) -> tuple[
    tuple[tuple[dsl.Value, ...], ...],
    tuple[_AttentionState, ...],
    dsl.Value,
    dsl.Value,
    dsl.Value,
    dsl.Value,
]:
    current_v_ready = _issue_operand(
        bld,
        cfg,
        v_buffer,
        current_lds.v,
        _V_STRIDE,
        workitem,
        workitem_first,
        tile,
        current_v_free,
        name=f"{name}_v",
    )
    k_access_dependencies = [current_k_ready]
    if cfg.waves == 8:
        k_access_dependencies.append(previous_v_ready)
    k_access = _stage_end(bld, *k_access_dependencies)
    k_fragments, k_tokens = _load_k_tile(
        bld, types, current_lds.k, workitem, after=k_access
    )
    probabilities: list[tuple[dsl.Value, ...]] = []
    next_states: list[_AttentionState] = []
    for group_scores, state in zip(previous_scores, states, strict=True):
        group_probabilities, state = _softmax_tail(
            bld,
            types,
            group_scores,
            state,
            items=cfg.threads,
        )
        probabilities.append(group_probabilities)
        next_states.append(state)
    states = tuple(next_states)
    current_k_done = _stage_end(bld, *k_tokens)
    next_k_ready = prefetch_k_free
    if prefetch_tile is not None:
        prefetch_access = prefetch_k_free
        if cfg.k_lds_stages == _PING_PONG_STAGES:
            prefetch_access = bld.join(current_k_done, prefetch_k_free)
        next_k_ready = _issue_operand(
            bld,
            cfg,
            k_buffer,
            prefetch_lds.k,
            _K_STRIDE,
            workitem,
            workitem_first,
            prefetch_tile,
            prefetch_access,
            name=f"{name}_k",
        )
    scores = _score_tiles(bld, types, q_fragments, k_fragments)
    bld.sched_barrier()
    v_access_dependencies = [previous_v_ready]
    if cfg.waves == 8:
        # Trailing cohort publishes next K before the leading cohort reads it.
        v_access_dependencies = [k_access, publish_k_ready]
    v_access = _stage_end(bld, *v_access_dependencies)
    v_fragments, v_tokens = _load_v_tile(
        bld, types, previous_lds.v, workitem, after=v_access
    )
    v_done = _stage_end(bld, *v_tokens)
    outputs = _pv_tiles_mfma_range(
        bld,
        tuple(probabilities),
        tuple(state.outputs for state in states),
        v_fragments,
        0,
        _PV_PREFIX_MFMAS,
    )
    bld.sched_barrier()
    pending = tuple(
        _prepare_softmax_head(
            bld,
            types,
            group_scores,
            _AttentionState(group_outputs, state.row_max, state.row_sum),
            items=cfg.threads,
            log2_score_bound=cfg.log2_score_bound,
        )
        for group_scores, group_outputs, state in zip(
            scores, outputs, states, strict=True
        )
    )
    outputs = _pv_tiles_mfma_range(
        bld,
        tuple(probabilities),
        tuple(group.state.outputs for group in pending),
        v_fragments,
        _PV_PREFIX_MFMAS,
        len(v_fragments),
    )
    pending = tuple(
        _PendingSoftmax(
            _AttentionState(group_outputs, group.state.row_max, group.state.row_sum),
            group.previous_max,
            group.scale,
            group.initialize,
        )
        for group_outputs, group in zip(outputs, pending, strict=True)
    )
    next_scores: list[tuple[dsl.Value, ...]] = []
    next_states = []
    for group_scores, group in zip(scores, pending, strict=True):
        group_scores, state = _finish_softmax_head(
            bld,
            types,
            group_scores,
            group,
            adaptive_reference=cfg.qk_max_abs is None,
        )
        next_scores.append(group_scores)
        next_states.append(state)
    return (
        tuple(next_scores),
        tuple(next_states),
        next_k_ready,
        current_k_done,
        current_v_ready,
        v_done,
    )


def _pipeline_phase(
    bld: dsl.FunctionBuilder,
    cfg: Gfx950FlashAttentionConfig,
    types: _KernelTypes,
    q_fragments: tuple[tuple[dsl.Value, ...], ...],
    k_buffer: dsl.Value,
    v_buffer: dsl.Value,
    current_lds: _LdsBuffer,
    previous_lds: _LdsBuffer,
    prefetch_lds: _LdsBuffer,
    workitem: dsl.Value,
    workitem_first: dsl.Value,
    tile: dsl.Value,
    prefetch_tile: dsl.Value | None,
    current_k_ready: dsl.Value,
    publish_k_ready: dsl.Value,
    prefetch_k_free: dsl.Value,
    previous_v_ready: dsl.Value,
    current_v_free: dsl.Value,
    previous_scores: tuple[tuple[dsl.Value, ...], ...],
    states: tuple[_AttentionState, ...],
    *,
    name: str,
) -> tuple[
    tuple[tuple[dsl.Value, ...], ...],
    tuple[_AttentionState, ...],
    dsl.Value,
    dsl.Value,
    dsl.Value,
    dsl.Value,
]:
    return _pipeline_phase_bulk(
        bld,
        cfg,
        types,
        q_fragments,
        k_buffer,
        v_buffer,
        current_lds,
        previous_lds,
        prefetch_lds,
        workitem,
        workitem_first,
        tile,
        prefetch_tile,
        current_k_ready,
        publish_k_ready,
        prefetch_k_free,
        previous_v_ready,
        current_v_free,
        previous_scores,
        states,
        name=name,
    )


def _store_output(
    bld: dsl.FunctionBuilder,
    cfg: Gfx950FlashAttentionConfig,
    types: _KernelTypes,
    output_buffer: dsl.Value,
    workgroup_m: dsl.Value,
    workitem: dsl.Value,
    state: _AttentionState,
    query_group: int,
) -> None:
    inv_sum = bld.frcp(state.row_sum)
    bf16 = dsl.simd_type(dsl.vector_type(16, dsl.bf16()), _WAVE_SIZE)
    packets = [
        bld.fpconvert(
            _scale_packet(
                bld,
                bld.fragment_unpack(output, types.acc_packet),
                inv_sum,
                types.scalar,
                types.acc_packet,
            ),
            bf16,
        )
        for output in state.outputs
    ]
    source_type = dsl.simd_type(dsl.vector_type(64, dsl.bf16()), _WAVE_SIZE)
    source = bld.pack(packets, source_type)
    item = dsl.sym("item")
    slot = dsl.sym("slot")
    lane = dsl.mod(item, _WAVE_SIZE)
    moved = bld.redistribute(
        source,
        source_type,
        items=cfg.threads,
        source_item=(
            64 * dsl.floor(item / 64)
            + dsl.mod(item, 32)
            + 32 * dsl.floor(dsl.mod(slot, 8) / 4)
        ),
        source_slot=(
            8 * dsl.floor(slot / 8) + 4 * dsl.floor(lane / 32) + dsl.mod(slot, 4)
        ),
    )

    wi = dsl.sym("fa_store_wi")
    block = dsl.sym("fa_store_block")
    physical_lane = dsl.mod(wi, _WAVE_SIZE)
    row = (
        block * _BLOCK_M
        + (query_group * cfg.waves + dsl.floor(wi / _WAVE_SIZE)) * _MFMA_TILE
        + dsl.mod(physical_lane, _MFMA_TILE)
    )
    lane_half = dsl.floor(physical_lane / _MFMA_TILE)
    bindings = {wi: workitem, block: workgroup_m}
    store_type = dsl.simd_type(dsl.vector_type(8, dsl.bf16()), _WAVE_SIZE)
    for group in range(8):
        values = bld.extract(moved, group * 8, store_type)
        offset = bld.index_expr(
            row * _HEAD_DIM + group * 16 + lane_half * 8, bindings=bindings
        )
        offset = bld.assume_range(offset, 0, cfg.head_elements - 1)
        bld.store(values, bld.ptr_add(output_buffer, offset))


def _setup_kernel(
    bld: dsl.FunctionBuilder, cfg: Gfx950FlashAttentionConfig
) -> _KernelContext:
    q_arg, k_arg, v_arg, output_arg = bld.args
    workgroup_m, head = _workgroup_coords(bld, cfg)
    workitem = bld.workitem_id(axis=0, width=_WAVE_SIZE)
    workitem = bld.assume_range(workitem, 0, cfg.threads - 1)
    workitem_first = bld.read_first(workitem)
    q_buffer = _head_buffer(bld, q_arg, head, cfg)
    k_buffer = _head_buffer(bld, k_arg, head, cfg)
    v_buffer = _head_buffer(bld, v_arg, head, cfg)
    output_buffer = _head_buffer(bld, output_arg, head, cfg)
    lds = _lds_buffers(bld, cfg)
    types = _kernel_types()
    q_fragments = _load_q(bld, cfg, types, q_buffer, workgroup_m, workitem)
    root = bld.token()
    return _KernelContext(
        cfg,
        types,
        workgroup_m,
        workitem,
        workitem_first,
        k_buffer,
        v_buffer,
        output_buffer,
        lds,
        q_fragments,
        root,
    )


def _kernel_pipeline_phase(
    bld: dsl.FunctionBuilder,
    ctx: _KernelContext,
    current_lds: _LdsBuffer,
    previous_lds: _LdsBuffer,
    prefetch_lds: _LdsBuffer,
    tile: dsl.Value,
    prefetch_tile: dsl.Value | None,
    current_k_ready: dsl.Value,
    publish_k_ready: dsl.Value,
    prefetch_k_free: dsl.Value,
    previous_v_ready: dsl.Value,
    current_v_free: dsl.Value,
    previous_scores: tuple[tuple[dsl.Value, ...], ...],
    states: tuple[_AttentionState, ...],
    *,
    name: str,
) -> tuple[
    tuple[tuple[dsl.Value, ...], ...],
    tuple[_AttentionState, ...],
    dsl.Value,
    dsl.Value,
    dsl.Value,
    dsl.Value,
]:
    return _pipeline_phase(
        bld,
        ctx.cfg,
        ctx.types,
        ctx.q_fragments,
        ctx.k_buffer,
        ctx.v_buffer,
        current_lds,
        previous_lds,
        prefetch_lds,
        ctx.workitem,
        ctx.workitem_first,
        tile,
        prefetch_tile,
        current_k_ready,
        publish_k_ready,
        prefetch_k_free,
        previous_v_ready,
        current_v_free,
        previous_scores,
        states,
        name=name,
    )


def _initial_states(
    bld: dsl.FunctionBuilder, ctx: _KernelContext
) -> tuple[_AttentionState, ...]:
    zero = bld.splat(bld.constant(dsl.f32(), 0.0), dsl.f32(), _WAVE_SIZE)
    neg_large = bld.splat(bld.constant(dsl.f32(), -1.0e30), dsl.f32(), _WAVE_SIZE)
    return tuple(
        _AttentionState(
            tuple(_zero_acc(bld, ctx.types) for _ in range(4)), neg_large, zero
        )
        for _ in range(ctx.cfg.query_groups)
    )


def _initial_softmax(
    bld: dsl.FunctionBuilder,
    ctx: _KernelContext,
    scores: tuple[tuple[dsl.Value, ...], ...],
    states: tuple[_AttentionState, ...],
) -> tuple[tuple[tuple[dsl.Value, ...], ...], tuple[_AttentionState, ...]]:
    next_scores: list[tuple[dsl.Value, ...]] = []
    next_states: list[_AttentionState] = []
    for group_scores, state in zip(scores, states, strict=True):
        group_scores, state = _softmax_head(
            bld,
            ctx.types,
            group_scores,
            state,
            items=ctx.cfg.threads,
            initialize=True,
            log2_score_bound=ctx.cfg.log2_score_bound,
        )
        next_scores.append(group_scores)
        next_states.append(state)
    return tuple(next_scores), tuple(next_states)


def _flatten_pipeline_state(
    scores: tuple[tuple[dsl.Value, ...], ...],
    states: tuple[_AttentionState, ...],
    tokens: _PipelineTokens,
) -> tuple[dsl.Value, ...]:
    return (
        *(score for group in scores for score in group),
        *(
            value
            for state in states
            for value in (*state.outputs, state.row_max, state.row_sum)
        ),
        *tokens.k_ready,
        *tokens.k_free,
        tokens.previous_v_ready,
        *tokens.v_free,
    )


def _unpack_pipeline_state(
    ctx: _KernelContext,
    args: tuple[dsl.Value, ...],
) -> tuple[
    tuple[tuple[dsl.Value, ...], ...],
    tuple[_AttentionState, ...],
    _PipelineTokens,
]:
    score_count = _BLOCK_N // _MFMA_TILE
    state_base = ctx.cfg.query_groups * score_count
    token_base = state_base + ctx.cfg.query_groups * 6
    scores = tuple(
        tuple(args[group * score_count : (group + 1) * score_count])
        for group in range(ctx.cfg.query_groups)
    )
    states = tuple(
        _AttentionState(
            tuple(args[state_base + group * 6 : state_base + group * 6 + 4]),
            args[state_base + group * 6 + 4],
            args[state_base + group * 6 + 5],
        )
        for group in range(ctx.cfg.query_groups)
    )
    stages = ctx.cfg.k_lds_stages
    k_ready = tuple(args[token_base : token_base + stages])
    k_free_base = token_base + stages
    k_free = tuple(args[k_free_base : k_free_base + stages])
    previous_v_ready = args[k_free_base + stages]
    v_free_base = k_free_base + stages + 1
    v_free = tuple(args[v_free_base : v_free_base + ctx.cfg.v_lds_stages])
    return (
        scores,
        states,
        _PipelineTokens(k_ready, k_free, previous_v_ready, v_free),
    )


def _run_pipeline_phase(
    bld: dsl.FunctionBuilder,
    ctx: _KernelContext,
    scores: tuple[tuple[dsl.Value, ...], ...],
    states: tuple[_AttentionState, ...],
    current_lds: _LdsBuffer,
    previous_lds: _LdsBuffer,
    prefetch_lds: _LdsBuffer,
    tile: dsl.Value,
    prefetch_tile: dsl.Value | None,
    current_k_ready: dsl.Value,
    publish_k_ready: dsl.Value,
    prefetch_k_free: dsl.Value,
    previous_v_ready: dsl.Value,
    current_v_free: dsl.Value,
    *,
    name: str,
) -> tuple[
    tuple[tuple[dsl.Value, ...], ...],
    tuple[_AttentionState, ...],
    dsl.Value,
    dsl.Value,
    dsl.Value,
    dsl.Value,
]:
    return _kernel_pipeline_phase(
        bld,
        ctx,
        current_lds,
        previous_lds,
        prefetch_lds,
        tile,
        prefetch_tile,
        current_k_ready,
        publish_k_ready,
        prefetch_k_free,
        previous_v_ready,
        current_v_free,
        scores,
        states,
        name=name,
    )


def _run_indexed_pipeline_phase(
    bld: dsl.FunctionBuilder,
    ctx: _KernelContext,
    scores: tuple[tuple[dsl.Value, ...], ...],
    states: tuple[_AttentionState, ...],
    tokens: _PipelineTokens,
    tile: dsl.Value,
    prefetch_tile: dsl.Value | None,
    current_k_stage: int,
    current_v_stage: int,
    previous_v_stage: int,
    prefetch_k_stage: int,
    *,
    name: str,
) -> tuple[
    tuple[tuple[dsl.Value, ...], ...],
    tuple[_AttentionState, ...],
    _PipelineTokens,
]:
    publish_k_ready = ctx.root
    if ctx.cfg.waves == 8:
        publish_k_stage = (current_k_stage + 1) % ctx.cfg.k_lds_stages
        publish_k_ready = tokens.k_ready[publish_k_stage]
    (
        scores,
        states,
        next_k_ready,
        current_k_done,
        current_v_ready,
        previous_v_done,
    ) = _run_pipeline_phase(
        bld,
        ctx,
        scores,
        states,
        _LdsBuffer(ctx.lds[current_k_stage].k, ctx.lds[current_v_stage].v),
        ctx.lds[previous_v_stage],
        ctx.lds[prefetch_k_stage],
        tile,
        prefetch_tile,
        tokens.k_ready[current_k_stage],
        publish_k_ready,
        tokens.k_free[prefetch_k_stage],
        tokens.previous_v_ready,
        tokens.v_free[current_v_stage],
        name=name,
    )
    k_ready = list(tokens.k_ready)
    k_free = list(tokens.k_free)
    v_free = list(tokens.v_free)
    k_ready[prefetch_k_stage] = next_k_ready
    k_free[current_k_stage] = current_k_done
    v_free[previous_v_stage] = previous_v_done
    return (
        scores,
        states,
        _PipelineTokens(
            tuple(k_ready),
            tuple(k_free),
            current_v_ready,
            tuple(v_free),
        ),
    )


def _emit_prologue(bld: dsl.FunctionBuilder, ctx: _KernelContext) -> _PipelineSeed:
    k_ready0 = _issue_operand(
        bld,
        ctx.cfg,
        ctx.k_buffer,
        ctx.lds[0].k,
        _K_STRIDE,
        ctx.workitem,
        ctx.workitem_first,
        0,
        ctx.root,
        name="fa_prologue_k0",
    )
    k_ready1 = _issue_operand(
        bld,
        ctx.cfg,
        ctx.k_buffer,
        ctx.lds[1].k,
        _K_STRIDE,
        ctx.workitem,
        ctx.workitem_first,
        1,
        ctx.root,
        name="fa_prologue_k1",
    )
    v_ready0 = _issue_operand(
        bld,
        ctx.cfg,
        ctx.v_buffer,
        ctx.lds[0].v,
        _V_STRIDE,
        ctx.workitem,
        ctx.workitem_first,
        0,
        ctx.root,
        name="fa_prologue_v0",
    )
    states = _initial_states(bld, ctx)
    operands_ready = _stage_end(bld, k_ready0, k_ready1, v_ready0)
    first_k_fragments, first_k_tokens = _load_k_tile(
        bld, ctx.types, ctx.lds[0].k, ctx.workitem, after=operands_ready
    )
    _stage_end(bld, *first_k_tokens)
    first_scores = _score_tiles(bld, ctx.types, ctx.q_fragments, first_k_fragments)
    first_k_done = _stage_end(bld, *first_k_tokens)
    k2_stage = 2 % ctx.cfg.k_lds_stages
    k_ready2 = _issue_operand(
        bld,
        ctx.cfg,
        ctx.k_buffer,
        ctx.lds[k2_stage].k,
        _K_STRIDE,
        ctx.workitem,
        ctx.workitem_first,
        bld.constant(dsl.i32(), 2),
        first_k_done,
        name="fa_prologue_k2",
    )
    scores, states = _initial_softmax(bld, ctx, first_scores, states)
    if ctx.cfg.waves == 8:
        stagger = bld.scalar_cmpi(
            "uge",
            ctx.workitem_first,
            bld.constant(dsl.i32(), ctx.cfg.waves // 2 * _WAVE_SIZE),
        )
        bld.sched_barrier()
        with bld.if_(stagger):
            # One barrier event separates cohorts until the matching exit barrier.
            _stage_end(bld)
            bld.set_priority(3)
        bld.sched_barrier()
    k_ready = [ctx.root] * ctx.cfg.k_lds_stages
    k_ready[0] = k_ready0
    k_ready[1] = k_ready1
    k_ready[k2_stage] = k_ready2
    k_free = [ctx.root] * ctx.cfg.k_lds_stages
    k_free[0] = first_k_done
    tokens = _PipelineTokens(
        tuple(k_ready),
        tuple(k_free),
        v_ready0,
        (ctx.root,) * ctx.cfg.v_lds_stages,
    )
    scores, states, tokens = _run_indexed_pipeline_phase(
        bld,
        ctx,
        scores,
        states,
        tokens,
        bld.constant(dsl.i32(), 1),
        bld.constant(dsl.i32(), 3),
        1,
        1,
        0,
        3 % ctx.cfg.k_lds_stages,
        name="fa_pipeline_1",
    )
    return _PipelineSeed(scores, states, tokens)


def _emit_pipeline_iteration(
    bld: dsl.FunctionBuilder,
    ctx: _KernelContext,
    args: tuple[dsl.Value, ...],
    first_tile: dsl.Value,
) -> tuple[dsl.Value, ...]:
    scores, states, tokens = _unpack_pipeline_state(ctx, args)
    tile_count = bld.constant(dsl.i32(), ctx.cfg.tile_count)
    if ctx.cfg.k_lds_stages == _PING_PONG_STAGES:
        odd_tile = bld.addi(first_tile, bld.constant(dsl.i32(), 1))
        prefetch_even_raw = bld.addi(first_tile, bld.constant(dsl.i32(), 2))
        prefetch_odd_raw = bld.addi(first_tile, bld.constant(dsl.i32(), 3))
        prefetch_even = bld.select(
            bld.scalar_cmpi("ult", prefetch_even_raw, tile_count),
            prefetch_even_raw,
            bld.constant(dsl.i32(), ctx.cfg.tile_count - 2),
        )
        prefetch_odd = bld.select(
            bld.scalar_cmpi("ult", prefetch_odd_raw, tile_count),
            prefetch_odd_raw,
            bld.constant(dsl.i32(), ctx.cfg.tile_count - 1),
        )
        scores, states, tokens = _run_indexed_pipeline_phase(
            bld,
            ctx,
            scores,
            states,
            tokens,
            first_tile,
            prefetch_even,
            0,
            0,
            1,
            0,
            name="fa_pipeline_even",
        )
        scores, states, tokens = _run_indexed_pipeline_phase(
            bld,
            ctx,
            scores,
            states,
            tokens,
            odd_tile,
            prefetch_odd,
            1,
            1,
            0,
            1,
            name="fa_pipeline_odd",
        )
        return _flatten_pipeline_state(scores, states, tokens)

    phase_count = math.lcm(ctx.cfg.k_lds_stages, ctx.cfg.v_lds_stages)
    tiles = tuple(
        bld.addi(first_tile, bld.constant(dsl.i32(), offset))
        for offset in range(phase_count)
    )
    prefetches = tuple(
        bld.addi(first_tile, bld.constant(dsl.i32(), offset))
        for offset in range(2, phase_count + 2)
    )
    prefetches = tuple(
        bld.select(
            bld.scalar_cmpi("ult", prefetch, tile_count),
            prefetch,
            bld.constant(dsl.i32(), ctx.cfg.tile_count - 1),
        )
        for prefetch in prefetches
    )
    for phase in range(phase_count):
        tile_stage = 2 + phase
        scores, states, tokens = _run_indexed_pipeline_phase(
            bld,
            ctx,
            scores,
            states,
            tokens,
            tiles[phase],
            prefetches[phase],
            tile_stage % ctx.cfg.k_lds_stages,
            tile_stage % ctx.cfg.v_lds_stages,
            (tile_stage - 1) % ctx.cfg.v_lds_stages,
            (tile_stage + 2) % ctx.cfg.k_lds_stages,
            name=f"fa_pipeline_ring{phase}",
        )
    return _flatten_pipeline_state(scores, states, tokens)


def _emit_pipeline_remainder(
    bld: dsl.FunctionBuilder,
    ctx: _KernelContext,
    args: tuple[dsl.Value, ...],
    first_tile: int,
) -> tuple[dsl.Value, ...]:
    scores, states, tokens = _unpack_pipeline_state(ctx, args)
    for tile in range(first_tile, ctx.cfg.tile_count):
        k_stage = tile % ctx.cfg.k_lds_stages
        v_stage = tile % ctx.cfg.v_lds_stages
        prefetch_tile = tile + 2
        prefetch = prefetch_tile if prefetch_tile < ctx.cfg.tile_count else None
        scores, states, tokens = _run_indexed_pipeline_phase(
            bld,
            ctx,
            scores,
            states,
            tokens,
            bld.constant(dsl.i32(), tile),
            prefetch,
            k_stage,
            v_stage,
            (v_stage - 1) % ctx.cfg.v_lds_stages,
            prefetch_tile % ctx.cfg.k_lds_stages,
            name=f"fa_pipeline_tail{tile - first_tile}",
        )
    return _flatten_pipeline_state(scores, states, tokens)


def _emit_pipeline_loop(
    bld: dsl.FunctionBuilder, ctx: _KernelContext, seed: _PipelineSeed
) -> tuple[dsl.Value, ...]:
    init_args = _flatten_pipeline_state(seed.scores, seed.states, seed.tokens)
    lower = bld.constant(dsl.i32(), 2)
    step_value = math.lcm(ctx.cfg.k_lds_stages, ctx.cfg.v_lds_stages)
    grouped_tiles = (ctx.cfg.tile_count - 2) // step_value * step_value
    grouped_end = 2 + grouped_tiles
    if grouped_tiles == 0:
        return _emit_pipeline_remainder(bld, ctx, init_args, grouped_end)
    upper = bld.constant(dsl.i32(), grouped_end)
    step = bld.constant(dsl.i32(), step_value)
    with bld.for_loop(
        lower,
        upper,
        step,
        init_args=init_args,
        nonzero_trip=True,
    ) as loop:
        bld.yield_(
            _emit_pipeline_iteration(
                bld,
                ctx,
                tuple(loop.inner_iter_args),
                loop.induction_variable,
            )
        )
    return _emit_pipeline_remainder(bld, ctx, tuple(loop.results), grouped_end)


def _emit_epilogue(
    bld: dsl.FunctionBuilder,
    ctx: _KernelContext,
    tail_args: tuple[dsl.Value, ...],
) -> None:
    final_scores, final_states, tokens = _unpack_pipeline_state(ctx, tail_args)
    final_probabilities: list[tuple[dsl.Value, ...]] = []
    next_states: list[_AttentionState] = []
    for group_scores, state in zip(final_scores, final_states, strict=True):
        probabilities, state = _softmax_tail(
            bld, ctx.types, group_scores, state, items=ctx.cfg.threads
        )
        final_probabilities.append(probabilities)
        next_states.append(state)
    final_states = tuple(next_states)
    final_v_ready = _stage_end(bld, tokens.previous_v_ready)
    final_v_fragments, final_v_tokens = _load_v_tile(
        bld,
        ctx.types,
        ctx.lds[(ctx.cfg.tile_count - 1) % ctx.cfg.v_lds_stages].v,
        ctx.workitem,
        after=final_v_ready,
    )
    _stage_end(bld, *final_v_tokens)
    final_outputs = _pv_tiles(
        bld,
        tuple(final_probabilities),
        tuple(state.outputs for state in final_states),
        final_v_fragments,
    )
    final_states = tuple(
        _AttentionState(outputs, state.row_max, state.row_sum)
        for outputs, state in zip(final_outputs, final_states, strict=True)
    )
    if ctx.cfg.waves == 8:
        leading = bld.scalar_cmpi(
            "ult",
            ctx.workitem_first,
            bld.constant(dsl.i32(), ctx.cfg.waves // 2 * _WAVE_SIZE),
        )
        bld.sched_barrier()
        with bld.if_(leading):
            _stage_end(bld)
        bld.set_priority(0)
        bld.sched_barrier()
    for query_group, final_state in enumerate(final_states):
        _store_output(
            bld,
            ctx.cfg,
            ctx.types,
            ctx.output_buffer,
            ctx.workgroup_m,
            ctx.workitem,
            final_state,
            query_group,
        )


def _emit_kernel(
    bld: dsl.FunctionBuilder,
    cfg: Gfx950FlashAttentionConfig,
) -> None:
    ctx = _setup_kernel(bld, cfg)
    seed = _emit_prologue(bld, ctx)

    tail_args = _emit_pipeline_loop(bld, ctx, seed)

    _emit_epilogue(bld, ctx, tail_args)


def build_gfx950_flash_attention_module(
    *,
    batch: int = 2,
    heads: int = 64,
    sequence: int = 8192,
    xcds: int = 8,
    waves: int = _DEFAULT_WAVES,
    qk_max_abs: float | None = None,
) -> Module:
    cfg = Gfx950FlashAttentionConfig(
        batch=batch,
        heads=heads,
        sequence=sequence,
        xcds=xcds,
        waves=waves,
        qk_max_abs=qk_max_abs,
    )
    bld = dsl.ModuleBuilder()
    with bld:
        attrs: dict[str, dsl.Attribute] = {
            _TARGET_WAVES_ATTR: dsl.i64_attr(cfg.waves // 4),
            _MULTI_WAVE_SPECIALIZATION_ATTR: UnitAttr.get(),
            _DYNAMIC_LDS_ATTR: dsl.i64_attr(cfg.dynamic_lds_bytes),
        }
        with (
            bld.gpu_module(_GPU_MODULE_NAME) as gpu_module,
            gpu_module.kernel(
                _KERNEL_NAME,
                [dsl.ptr_type(dsl.bf16())] * 4,
                lds_size=0,
                workgroup_size=[cfg.threads, 1, 1],
                attrs=attrs,
            ) as kernel,
        ):
            _emit_kernel(kernel, cfg)
    return bld.module


__all__ = [
    "Gfx950FlashAttentionConfig",
    "build_gfx950_flash_attention_module",
]
