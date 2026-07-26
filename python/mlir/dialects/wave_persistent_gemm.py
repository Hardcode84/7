#  Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
#  See https://llvm.org/LICENSE.txt for license information.
#  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

"""gfx950 asymmetric persistent-wave f16 GEMM."""

from __future__ import annotations

from collections.abc import Callable
from dataclasses import dataclass

from mlir.dialects import wave_dsl as dsl
from mlir.ir import Module, Type

KERNEL_NAME = "gfx950_persistent_f16_gemm"
GPU_MODULE_NAME = "kernels"

_WAVE_SIZE = 64
_WORKGROUP_WAVES = 16
_PRODUCER_WAVES = 4
_CONSUMER_WAVES = _WORKGROUP_WAVES - _PRODUCER_WAVES
_TILE_M = 256
_TILE_N = 256
_TILE_K = 32
_TILES_PER_PANEL = 16
_DWORDS_PER_TILE = 256
_LDS_ALLOCATION_GRANULE = 32

_READY_MASK = (1 << _PRODUCER_WAVES) - 1
_DONE_MASK = (1 << _CONSUMER_WAVES) - 1

_A_FRAGMENT_ROLE = 0
_B_FRAGMENT_ROLE = 1
_ACC_FRAGMENT_ROLE = 2
_AB_REGISTERS = 4
_ACC_REGISTERS = 4
_MMA_KIND = "mfma.f32.16x16x32.f16"


@dataclass(frozen=True)
class _PersistentConfig:
    k_slices: int
    ring_stages: int

    @property
    def generation_k(self) -> int:
        return self.k_slices * _TILE_K

    @property
    def dwords_per_tile(self) -> int:
        return self.k_slices * _DWORDS_PER_TILE

    @property
    def dwords_per_stage(self) -> int:
        return 2 * _TILES_PER_PANEL * self.dwords_per_tile

    @property
    def data_dwords(self) -> int:
        return self.ring_stages * self.dwords_per_stage

    @property
    def ready_dword(self) -> int:
        return self.data_dwords

    @property
    def done_dword(self) -> int:
        return self.ready_dword + self.ring_stages

    @property
    def lds_bytes(self) -> int:
        bytes_used = (self.done_dword + self.ring_stages) * 4
        granule = _LDS_ALLOCATION_GRANULE
        return (bytes_used + granule - 1) // granule * granule

    @property
    def ready_reuse_extra(self) -> int:
        return self.ring_stages * (1 << _PRODUCER_WAVES) - _READY_MASK

    @property
    def done_reuse_extra(self) -> int:
        return self.ring_stages * (1 << _CONSUMER_WAVES) - _DONE_MASK


_DEFAULT_CONFIG = _PersistentConfig(k_slices=1, ring_stages=3)
LDS_BYTES = _DEFAULT_CONFIG.lds_bytes


def _persistent_config(k_slices: int) -> _PersistentConfig:
    if k_slices == 1:
        return _DEFAULT_CONFIG
    if k_slices == 2:
        return _PersistentConfig(k_slices=2, ring_stages=2)
    raise ValueError(f"k_slices must be 1 or 2; got {k_slices}")


def _require_positive_multiple(name: str, value: int, multiple: int) -> None:
    if value <= 0 or value % multiple:
        raise ValueError(
            f"{name} must be a positive multiple of {multiple}; got {value}"
        )


def _validate_shape(
    M: int,
    N: int,
    K: int,
    poll_sleep_cycles: int,
    config: _PersistentConfig,
) -> None:
    _require_positive_multiple("M", M, _TILE_M)
    _require_positive_multiple("N", N, _TILE_N)
    _require_positive_multiple("K", K, config.generation_k)
    if config.k_slices == 2 and 3 * config.generation_k > K:
        raise ValueError(f"two-slice persistent GEMM requires K >= 192; got {K}")
    if poll_sleep_cycles < 0 or poll_sleep_cycles > 15:
        raise ValueError("poll_sleep_cycles must be in [0, 15]")


def _buffer(
    bld: dsl.FunctionBuilder,
    ptr: dsl.Value,
    elements: int,
) -> dsl.Value:
    size = bld.constant(dsl.i32(), elements * 2)
    return bld.make_buffer(ptr, size, dsl.buffer_ptr_type(dsl.f16()))


def _cta_coords(
    bld: dsl.FunctionBuilder,
    M: int,
    N: int,
) -> tuple[dsl.Value, dsl.Value]:
    blocks_m = M // _TILE_M
    blocks_n = N // _TILE_N
    raw_m = bld.assume_range(bld.workgroup_id(axis=0), 0, blocks_m - 1)
    raw_n = bld.assume_range(bld.workgroup_id(axis=1), 0, blocks_n - 1)
    if blocks_m % 4 or (blocks_m * blocks_n) % 8:
        return raw_m, raw_n

    m = dsl.sym("persistent_raw_m")
    n = dsl.sym("persistent_raw_n")
    raw_pid = n * blocks_m + m
    pids_per_xcd = blocks_m * blocks_n // 8
    pid = dsl.mod(raw_pid, 8) * pids_per_xcd + dsl.floor(raw_pid / 8)
    group_span = 4 * blocks_n
    in_group = dsl.mod(pid, group_span)
    wg_m = dsl.floor(pid / group_span) * 4 + dsl.mod(in_group, 4)
    wg_n = dsl.floor(in_group / 4)
    bindings = {m: raw_m, n: raw_n}
    return (
        bld.assume_range(bld.index_expr(wg_m, bindings), 0, blocks_m - 1),
        bld.assume_range(bld.index_expr(wg_n, bindings), 0, blocks_n - 1),
    )


def _lane_zero_mask(bld: dsl.FunctionBuilder, wi: dsl.Value) -> dsl.Value:
    lane = bld.binary(
        dsl.BinaryKind.AndI,
        wi,
        bld.splat(bld.constant(dsl.i32(), _WAVE_SIZE - 1), width=_WAVE_SIZE),
    )
    return bld.cmpi("eq", lane, bld.splat(bld.constant(dsl.i32(), 0), width=_WAVE_SIZE))


def _mailbox_ptr(
    bld: dsl.FunctionBuilder,
    lds: dsl.Value,
    stage: dsl.Value,
    config: _PersistentConfig,
    *,
    done: bool,
) -> dsl.Value:
    s = dsl.sym("persistent_mailbox_stage")
    base = config.done_dword if done else config.ready_dword
    offset = bld.index_expr(base + s, {s: stage})
    return bld.ptr_add(lds, offset)


def _initialize_mailboxes(
    bld: dsl.FunctionBuilder,
    lds: dsl.Value,
    wi: dsl.Value,
    config: _PersistentConfig,
) -> dsl.Value:
    root = bld.token()
    zero = bld.splat(bld.constant(dsl.i32(), 0), width=_WAVE_SIZE)
    global_zero = bld.cmpi("eq", wi, zero)
    with bld.where(global_zero, [dsl.mem_token_type()]) as active:
        stores = [
            bld.store(
                zero,
                bld.ptr_add(lds, bld.constant(dsl.i32(), config.ready_dword + i)),
                after=root,
            )
            for i in range(2 * config.ring_stages)
        ]
        bld.yield_([bld.join(*stores)])
        with active.otherwise():
            bld.yield_([root])
    return bld.barrier(active.results[0])


def _if_token(
    bld: dsl.FunctionBuilder,
    condition: dsl.Value,
    then_builder: Callable[[], dsl.Value],
    fallback: dsl.Value,
) -> dsl.Value:
    with bld.if_(condition, [dsl.mem_token_type()], otherwise=True) as conditional:
        bld.yield_([then_builder()])
        with conditional.otherwise():
            bld.yield_([fallback])
    return conditional.results[0]


def _generation_extra(
    bld: dsl.FunctionBuilder,
    generation: dsl.Value,
    participant: dsl.Value,
    *,
    shift: int,
    reused_extra: int,
    ring_stages: int,
) -> dsl.Value:
    zero = bld.constant(dsl.i32(), 0)
    is_coordinator = bld.scalar_cmpi("eq", participant, zero)

    def coordinator_extra() -> dsl.Value:
        initial = bld.scalar_cmpi(
            "ult", generation, bld.constant(dsl.i32(), ring_stages)
        )

        def initial_extra() -> dsl.Value:
            return bld.shli(generation, bld.constant(dsl.i32(), shift))

        return _if_value(
            bld,
            initial,
            initial_extra,
            bld.constant(dsl.i32(), reused_extra),
        )

    return _if_value(bld, is_coordinator, coordinator_extra, zero)


def _if_value(
    bld: dsl.FunctionBuilder,
    condition: dsl.Value,
    then_builder: Callable[[], dsl.Value],
    fallback: dsl.Value,
) -> dsl.Value:
    with bld.if_(condition, [fallback.type], otherwise=True) as conditional:
        bld.yield_([then_builder()])
        with conditional.otherwise():
            bld.yield_([fallback])
    return conditional.results[0]


def _issue_publication(
    bld: dsl.FunctionBuilder,
    ptr: dsl.Value,
    dependency: dsl.Value,
    contribution: dsl.Value,
    lane_zero: dsl.Value,
) -> tuple[dsl.Value, dsl.Value]:
    zero = bld.splat(bld.constant(dsl.i32(), 0), width=_WAVE_SIZE)
    value = bld.splat(contribution, width=_WAVE_SIZE)
    with bld.where(
        lane_zero,
        [dsl.simd_type(dsl.i32(), _WAVE_SIZE), dsl.mem_token_type()],
    ) as active:
        old, published = bld.lds_atomic_add(ptr, value, after=dependency)
        bld.yield_([old, published])
        with active.otherwise():
            bld.yield_([zero, dependency])
    return active.results[0], active.results[1]


def _finish_publication(
    bld: dsl.FunctionBuilder,
    old: dsl.Value,
    published: dsl.Value,
    contribution: dsl.Value,
    target: dsl.Value,
) -> dsl.Value:
    old = bld.read_first(old)
    complete = bld.scalar_cmpi("eq", bld.addi(old, contribution), target)
    return _if_token(bld, complete, lambda: bld.wakeup(published), published)


def _publish(
    bld: dsl.FunctionBuilder,
    ptr: dsl.Value,
    dependency: dsl.Value,
    contribution: dsl.Value,
    target: dsl.Value,
    lane_zero: dsl.Value,
) -> dsl.Value:
    old, published = _issue_publication(bld, ptr, dependency, contribution, lane_zero)
    return _finish_publication(bld, old, published, contribution, target)


def _stage_value(
    bld: dsl.FunctionBuilder,
    generation: dsl.Value,
    config: _PersistentConfig,
) -> dsl.Value:
    g = dsl.sym("persistent_stage_generation")
    return bld.index_expr(dsl.mod(g, config.ring_stages), {g: generation})


def _producer_source(
    bld: dsl.FunctionBuilder,
    buffer: dsl.Value,
    config: _PersistentConfig,
    *,
    cta: dsl.Value,
    slot: dsl.Value,
    generation: dsl.Value,
    k_slice: int,
    wi: dsl.Value,
    leading: int,
    elements: int,
) -> dsl.Value:
    c = dsl.sym("persistent_source_cta")
    t = dsl.sym("persistent_source_tile")
    g = dsl.sym("persistent_source_generation")
    w = dsl.sym("persistent_source_wi")
    lane = dsl.mod(w, _WAVE_SIZE)
    row = dsl.floor(lane / 4)
    physical_col = dsl.mod(lane, 4)
    logical_col = dsl.xor(dsl.mod(dsl.floor(row / 2), 4), physical_col)
    offset = (
        c * (_TILE_M * leading)
        + t * (16 * leading)
        + g * config.generation_k
        + k_slice * _TILE_K
        + row * leading
        + logical_col * 8
    )
    lane_offset = bld.assume_range(
        bld.index_expr(offset, {c: cta, t: slot, g: generation, w: wi}),
        0,
        elements - 1,
    )
    return bld.ptr_add(buffer, lane_offset)


def _producer_contribution(
    bld: dsl.FunctionBuilder,
    generation: dsl.Value,
    producer: dsl.Value,
    config: _PersistentConfig,
) -> tuple[dsl.Value, dsl.Value]:
    bit = bld.shli(bld.constant(dsl.i32(), 1), producer)
    extra = _generation_extra(
        bld,
        generation,
        producer,
        shift=_PRODUCER_WAVES,
        reused_extra=config.ready_reuse_extra,
        ring_stages=config.ring_stages,
    )
    contribution = bld.addi(bit, extra)
    target = bld.addi(
        bld.shli(generation, bld.constant(dsl.i32(), _PRODUCER_WAVES)),
        bld.constant(dsl.i32(), _READY_MASK),
    )
    return contribution, target


def _producer_reuse(
    bld: dsl.FunctionBuilder,
    generation: dsl.Value,
    done_ptr: dsl.Value,
    dependency: dsl.Value,
    sleep_cycles: int,
    config: _PersistentConfig,
) -> dsl.Value:
    reused = bld.scalar_cmpi(
        "uge", generation, bld.constant(dsl.i32(), config.ring_stages)
    )

    def poll() -> dsl.Value:
        prior = bld.subi(generation, bld.constant(dsl.i32(), config.ring_stages))
        expected = bld.addi(
            bld.shli(prior, bld.constant(dsl.i32(), _CONSUMER_WAVES)),
            bld.constant(dsl.i32(), _DONE_MASK),
        )
        return bld.lds_poll_eq(
            done_ptr,
            expected,
            after=dependency,
            sleep_cycles=sleep_cycles,
        )

    return _if_token(bld, reused, poll, dependency)


def _issue_producer_slice(
    bld: dsl.FunctionBuilder,
    config: _PersistentConfig,
    *,
    M: int,
    N: int,
    K: int,
    a: dsl.Value,
    b: dsl.Value,
    producer: dsl.Value,
    generation: dsl.Value,
    k_slice: int,
    wi: dsl.Value,
    wg_m: dsl.Value,
    wg_n: dsl.Value,
    lds: dsl.Value,
    stage: dsl.Value,
    dependency: dsl.Value,
) -> dsl.Value:
    tokens: list[dsl.Value] = []
    for index in range(4):
        slot = bld.assume_range(
            bld.addi(
                producer,
                bld.constant(dsl.i32(), _PRODUCER_WAVES * index),
            ),
            _PRODUCER_WAVES * index,
            _PRODUCER_WAVES * index + 3,
        )
        a_src = _producer_source(
            bld,
            a,
            config,
            cta=wg_m,
            slot=slot,
            generation=generation,
            k_slice=k_slice,
            wi=wi,
            leading=K,
            elements=M * K,
        )
        b_src = _producer_source(
            bld,
            b,
            config,
            cta=wg_n,
            slot=slot,
            generation=generation,
            k_slice=k_slice,
            wi=wi,
            leading=K,
            elements=N * K,
        )
        s = dsl.sym(f"persistent_dma_stage_{index}_{k_slice}")
        t = dsl.sym(f"persistent_dma_tile_{index}_{k_slice}")
        a_offset = bld.index_expr(
            s * config.dwords_per_stage
            + t * config.dwords_per_tile
            + k_slice * _DWORDS_PER_TILE,
            {s: stage, t: slot},
        )
        b_offset = bld.index_expr(
            s * config.dwords_per_stage
            + (_TILES_PER_PANEL + t) * config.dwords_per_tile
            + k_slice * _DWORDS_PER_TILE,
            {s: stage, t: slot},
        )
        tokens.append(
            bld.dma_load_lds(
                a_src,
                bld.ptr_add(lds, a_offset),
                after=dependency,
                bytes=16,
            )
        )
        tokens.append(
            bld.dma_load_lds(
                b_src,
                bld.ptr_add(lds, b_offset),
                after=dependency,
                bytes=16,
            )
        )
    return bld.join(*tokens)


def _emit_producer(
    bld: dsl.FunctionBuilder,
    config: _PersistentConfig,
    *,
    M: int,
    N: int,
    K: int,
    wi: dsl.Value,
    wave_id: dsl.Value,
    wg_m: dsl.Value,
    wg_n: dsl.Value,
    lds: dsl.Value,
    startup: dsl.Value,
    lane_zero: dsl.Value,
    trip_count: dsl.Value,
    poll_vmem: bool,
    poll_sleep_cycles: int,
) -> None:
    a = _buffer(bld, bld.args[0], M * K)
    b = _buffer(bld, bld.args[1], N * K)
    producer = bld.assume_range(bld.subi(wave_id, bld.constant(dsl.i32(), 12)), 0, 3)
    zero = bld.constant(dsl.i32(), 0)
    one = bld.constant(dsl.i32(), 1)
    upper = bld.addi(trip_count, one)

    with bld.for_loop(zero, upper, one, init_args=[startup], nonzero_trip=True) as loop:
        generation = bld.assume_range(
            loop.induction_variable, 0, K // config.generation_k - 1
        )
        dependency = loop.inner_iter_args[0]
        stage = _stage_value(bld, generation, config)
        ready_ptr = _mailbox_ptr(bld, lds, stage, config, done=False)
        done_ptr = _mailbox_ptr(bld, lds, stage, config, done=True)
        reuse = _producer_reuse(
            bld, generation, done_ptr, dependency, poll_sleep_cycles, config
        )

        slice_dependency = reuse
        for k_slice in range(config.k_slices):
            complete = _issue_producer_slice(
                bld,
                config,
                M=M,
                N=N,
                K=K,
                a=a,
                b=b,
                producer=producer,
                generation=generation,
                k_slice=k_slice,
                wi=wi,
                wg_m=wg_m,
                wg_n=wg_n,
                lds=lds,
                stage=stage,
                dependency=slice_dependency,
            )
            if k_slice != config.k_slices - 1:
                slice_dependency = bld.vmem_wait_poll(
                    complete, sleep_cycles=poll_sleep_cycles
                )
        if poll_vmem:
            complete = bld.vmem_wait_poll(complete, sleep_cycles=poll_sleep_cycles)
        contribution, target = _producer_contribution(bld, generation, producer, config)
        published = _publish(bld, ready_ptr, complete, contribution, target, lane_zero)
        bld.yield_([published])


def _consumer_read_ptr(
    bld: dsl.FunctionBuilder,
    lds: dsl.Value,
    config: _PersistentConfig,
    *,
    stage: dsl.Value,
    slot: dsl.Value,
    k_slice: int,
    wi: dsl.Value,
    is_b: bool,
) -> dsl.Value:
    s = dsl.sym("persistent_read_stage")
    t = dsl.sym("persistent_read_tile")
    w = dsl.sym("persistent_read_wi")
    lane = dsl.mod(w, _WAVE_SIZE)
    row = dsl.mod(lane, 16)
    physical_col = dsl.floor(lane / 16)
    logical_col = dsl.xor(dsl.mod(dsl.floor(row / 2), 4), physical_col)
    panel = _TILES_PER_PANEL if is_b else 0
    offset = (
        s * config.dwords_per_stage
        + (panel + t) * config.dwords_per_tile
        + k_slice * _DWORDS_PER_TILE
        + row * 16
        + logical_col * 4
    )
    return bld.ptr_add(lds, bld.index_expr(offset, {s: stage, t: slot, w: wi}))


def _consumer_contribution(
    bld: dsl.FunctionBuilder,
    generation: dsl.Value,
    consumer: dsl.Value,
    config: _PersistentConfig,
) -> tuple[dsl.Value, dsl.Value]:
    bit = bld.shli(bld.constant(dsl.i32(), 1), consumer)
    extra = _generation_extra(
        bld,
        generation,
        consumer,
        shift=_CONSUMER_WAVES,
        reused_extra=config.done_reuse_extra,
        ring_stages=config.ring_stages,
    )
    contribution = bld.addi(bit, extra)
    target = bld.addi(
        bld.shli(generation, bld.constant(dsl.i32(), _CONSUMER_WAVES)),
        bld.constant(dsl.i32(), _DONE_MASK),
    )
    return contribution, target


def _load_consumer_b(
    bld: dsl.FunctionBuilder,
    config: _PersistentConfig,
    *,
    index: int,
    n_start: dsl.Value,
    stage: dsl.Value,
    k_slice: int,
    wi: dsl.Value,
    lds: dsl.Value,
    ready: dsl.Value,
    load_type: Type,
    b_type: Type,
) -> tuple[dsl.Value, dsl.Value]:
    slot = bld.addi(n_start, bld.constant(dsl.i32(), index))
    regs, token = bld.load(
        _consumer_read_ptr(
            bld,
            lds,
            config,
            stage=stage,
            slot=slot,
            k_slice=k_slice,
            wi=wi,
            is_b=True,
        ),
        load_type,
        after=ready,
    )
    return bld.fragment_pack(regs, b_type), token


def _apply_consumer_b(
    bld: dsl.FunctionBuilder,
    *,
    width: int,
    column: int,
    a_frags: list[dsl.Value],
    b_frag: dsl.Value,
    accs: list[dsl.Value],
) -> None:
    for row, a_frag in enumerate(a_frags):
        index = row * width + column
        accs[index] = bld.mma(_MMA_KIND, a_frag, b_frag, accs[index])


def _append_consumer_b(
    bld: dsl.FunctionBuilder,
    config: _PersistentConfig,
    *,
    index: int,
    n_start: dsl.Value,
    stage: dsl.Value,
    k_slice: int,
    wi: dsl.Value,
    lds: dsl.Value,
    ready: dsl.Value,
    load_type: Type,
    b_type: Type,
    read_tokens: list[dsl.Value],
    b_frags: list[dsl.Value],
) -> None:
    b_frag, token = _load_consumer_b(
        bld,
        config,
        index=index,
        n_start=n_start,
        stage=stage,
        k_slice=k_slice,
        wi=wi,
        lds=lds,
        ready=ready,
        load_type=load_type,
        b_type=b_type,
    )
    b_frags.append(b_frag)
    read_tokens.append(token)


def _consumer_publication_inputs(
    bld: dsl.FunctionBuilder,
    config: _PersistentConfig,
    generation: dsl.Value,
    consumer: dsl.Value,
    publish_done: bool,
) -> tuple[dsl.Value, dsl.Value] | None:
    if not publish_done:
        return None
    return _consumer_contribution(bld, generation, consumer, config)


def _issue_consumer_publication(
    bld: dsl.FunctionBuilder,
    done_ptr: dsl.Value,
    read_tokens: list[dsl.Value],
    lane_zero: dsl.Value,
    inputs: tuple[dsl.Value, dsl.Value] | None,
) -> tuple[dsl.Value, dsl.Value] | None:
    if inputs is None:
        return None
    contribution, _ = inputs
    return _issue_publication(
        bld,
        done_ptr,
        bld.join(*read_tokens),
        contribution,
        lane_zero,
    )


def _finish_consumer_publication(
    bld: dsl.FunctionBuilder,
    publication: tuple[dsl.Value, dsl.Value] | None,
    inputs: tuple[dsl.Value, dsl.Value] | None,
) -> dsl.Value | None:
    if publication is None or inputs is None:
        return None
    old, published = publication
    contribution, target = inputs
    return _finish_publication(bld, old, published, contribution, target)


def _consume_b_baseline(
    bld: dsl.FunctionBuilder,
    config: _PersistentConfig,
    *,
    width: int,
    n_start: dsl.Value,
    consumer: dsl.Value,
    generation: dsl.Value,
    k_slice: int,
    publish_done: bool,
    wi: dsl.Value,
    lds: dsl.Value,
    lane_zero: dsl.Value,
    stage: dsl.Value,
    ready: dsl.Value,
    done_ptr: dsl.Value,
    read_tokens: list[dsl.Value],
    a_frags: list[dsl.Value],
    accs: list[dsl.Value],
    b_type: Type,
    load_type: Type,
) -> tuple[list[dsl.Value], dsl.Value | None]:
    for column in range(width):
        b_frag, token = _load_consumer_b(
            bld,
            config,
            index=column,
            n_start=n_start,
            stage=stage,
            k_slice=k_slice,
            wi=wi,
            lds=lds,
            ready=ready,
            load_type=load_type,
            b_type=b_type,
        )
        read_tokens.append(token)
        _apply_consumer_b(
            bld,
            width=width,
            column=column,
            a_frags=a_frags,
            b_frag=b_frag,
            accs=accs,
        )

    if not publish_done:
        return accs, None

    contribution, target = _consumer_contribution(bld, generation, consumer, config)
    published = _publish(
        bld,
        done_ptr,
        bld.join(*read_tokens),
        contribution,
        target,
        lane_zero,
    )
    return accs, published


def _consume_b_pipelined(
    bld: dsl.FunctionBuilder,
    config: _PersistentConfig,
    *,
    width: int,
    n_start: dsl.Value,
    consumer: dsl.Value,
    generation: dsl.Value,
    k_slice: int,
    publish_done: bool,
    wi: dsl.Value,
    lds: dsl.Value,
    lane_zero: dsl.Value,
    stage: dsl.Value,
    ready: dsl.Value,
    done_ptr: dsl.Value,
    read_tokens: list[dsl.Value],
    a_frags: list[dsl.Value],
    accs: list[dsl.Value],
    b_type: Type,
    load_type: Type,
) -> tuple[list[dsl.Value], dsl.Value | None]:
    prefetch = 4 if width == 5 else 2
    b_frags: list[dsl.Value] = []
    for column in range(prefetch):
        _append_consumer_b(
            bld,
            config,
            index=column,
            n_start=n_start,
            stage=stage,
            k_slice=k_slice,
            wi=wi,
            lds=lds,
            ready=ready,
            load_type=load_type,
            b_type=b_type,
            read_tokens=read_tokens,
            b_frags=b_frags,
        )

    publication_inputs = _consumer_publication_inputs(
        bld, config, generation, consumer, publish_done
    )
    last_column = width - 1
    _apply_consumer_b(
        bld,
        width=width,
        column=0,
        a_frags=a_frags,
        b_frag=b_frags[0],
        accs=accs,
    )
    for column in range(1, last_column):
        if len(b_frags) < width:
            _append_consumer_b(
                bld,
                config,
                index=len(b_frags),
                n_start=n_start,
                stage=stage,
                k_slice=k_slice,
                wi=wi,
                lds=lds,
                ready=ready,
                load_type=load_type,
                b_type=b_type,
                read_tokens=read_tokens,
                b_frags=b_frags,
            )
        _apply_consumer_b(
            bld,
            width=width,
            column=column,
            a_frags=a_frags,
            b_frag=b_frags[column],
            accs=accs,
        )

    publication = _issue_consumer_publication(
        bld,
        done_ptr,
        read_tokens,
        lane_zero,
        publication_inputs,
    )
    _apply_consumer_b(
        bld,
        width=width,
        column=last_column,
        a_frags=a_frags,
        b_frag=b_frags[last_column],
        accs=accs,
    )
    return accs, _finish_consumer_publication(bld, publication, publication_inputs)


def _consume_stage(
    bld: dsl.FunctionBuilder,
    config: _PersistentConfig,
    *,
    width: int,
    n_start: dsl.Value,
    consumer: dsl.Value,
    row_group: dsl.Value,
    wi: dsl.Value,
    lds: dsl.Value,
    lane_zero: dsl.Value,
    generation: dsl.Value,
    accs: list[dsl.Value],
    dependency: dsl.Value,
    a_type: Type,
    b_type: Type,
    load_type: Type,
    poll_sleep_cycles: int,
    consumer_pipeline: bool,
) -> tuple[list[dsl.Value], dsl.Value]:
    stage = _stage_value(bld, generation, config)
    ready_ptr = _mailbox_ptr(bld, lds, stage, config, done=False)
    done_ptr = _mailbox_ptr(bld, lds, stage, config, done=True)
    ready_target = bld.addi(
        bld.shli(generation, bld.constant(dsl.i32(), _PRODUCER_WAVES)),
        bld.constant(dsl.i32(), _READY_MASK),
    )
    ready = bld.lds_poll_eq(
        ready_ptr,
        ready_target,
        after=dependency,
        sleep_cycles=poll_sleep_cycles,
    )

    read_tokens: list[dsl.Value] = []
    published: dsl.Value | None = None
    consume_b = _consume_b_pipelined if consumer_pipeline else _consume_b_baseline
    for k_slice in range(config.k_slices):
        a_frags: list[dsl.Value] = []
        for i in range(4):
            slot = bld.addi(
                bld.muli(row_group, bld.constant(dsl.i32(), 4)),
                bld.constant(dsl.i32(), i),
            )
            regs, token = bld.load(
                _consumer_read_ptr(
                    bld,
                    lds,
                    config,
                    stage=stage,
                    slot=slot,
                    k_slice=k_slice,
                    wi=wi,
                    is_b=False,
                ),
                load_type,
                after=ready,
            )
            a_frags.append(bld.fragment_pack(regs, a_type))
            read_tokens.append(token)

        accs, slice_publication = consume_b(
            bld,
            config,
            width=width,
            n_start=n_start,
            consumer=consumer,
            generation=generation,
            k_slice=k_slice,
            publish_done=k_slice == config.k_slices - 1,
            wi=wi,
            lds=lds,
            lane_zero=lane_zero,
            stage=stage,
            ready=ready,
            done_ptr=done_ptr,
            read_tokens=read_tokens,
            a_frags=a_frags,
            accs=accs,
            b_type=b_type,
            load_type=load_type,
        )
        if slice_publication is not None:
            published = slice_publication

    assert published is not None
    return accs, published


def _store_consumer_tiles(
    bld: dsl.FunctionBuilder,
    *,
    M: int,
    N: int,
    width: int,
    n_start: dsl.Value,
    row_group: dsl.Value,
    wg_m: dsl.Value,
    wg_n: dsl.Value,
    wi: dsl.Value,
    accs: tuple[dsl.Value, ...],
) -> None:
    c = _buffer(bld, bld.args[2], M * N)
    unpack_type = dsl.simd_type(
        dsl.vector_type(_ACC_REGISTERS, dsl.f32()), width=_WAVE_SIZE
    )
    f32_simd = dsl.simd_type(dsl.f32(), width=_WAVE_SIZE)
    f16_simd = dsl.simd_type(dsl.f16(), width=_WAVE_SIZE)
    packed_type = dsl.simd_type(dsl.vector_type(4, dsl.f16()), width=_WAVE_SIZE)
    unpacked = tuple(bld.fragment_unpack(fragment, unpack_type) for fragment in accs)
    cache = dsl.store_cache(dsl.StoreCacheAttr.CS)

    gm = dsl.sym("persistent_store_wg_m")
    gn = dsl.sym("persistent_store_wg_n")
    ns = dsl.sym("persistent_store_n_start")
    rg = dsl.sym("persistent_store_row_group")
    w = dsl.sym("persistent_store_wi")
    lane = dsl.mod(w, _WAVE_SIZE)
    lane_m = dsl.floor(lane / 16) * _ACC_REGISTERS
    lane_n = dsl.mod(lane, 16)
    bindings = {gm: wg_m, gn: wg_n, ns: n_start, rg: row_group, w: wi}

    for i in range(4):
        for j in range(width):
            values = [
                bld.fpconvert(
                    bld.extract(unpacked[i * width + j], reg, f32_simd),
                    f16_simd,
                )
                for reg in range(_ACC_REGISTERS)
            ]
            offset = (
                gm * _TILE_M
                + rg * 64
                + i * 16
                + lane_m
                + (gn * _TILE_N + ns * 16 + j * 16 + lane_n) * M
            )
            store_offset = bld.assume_range(
                bld.index_expr(offset, bindings), 0, M * N - 1
            )
            bld.store(
                bld.pack(values, packed_type),
                bld.ptr_add(c, store_offset),
                cache=cache,
            )


def _emit_consumer_width(
    bld: dsl.FunctionBuilder,
    config: _PersistentConfig,
    *,
    M: int,
    N: int,
    K: int,
    width: int,
    n_start: dsl.Value,
    consumer: dsl.Value,
    row_group: dsl.Value,
    wg_m: dsl.Value,
    wg_n: dsl.Value,
    wi: dsl.Value,
    lds: dsl.Value,
    startup: dsl.Value,
    lane_zero: dsl.Value,
    trip_count: dsl.Value,
    poll_sleep_cycles: int,
    consumer_pipeline: bool,
) -> None:
    a_type = dsl.fragment_type(
        _A_FRAGMENT_ROLE,
        dsl.f16(),
        16,
        16,
        _WAVE_SIZE,
        _AB_REGISTERS,
    )
    b_type = dsl.fragment_type(
        _B_FRAGMENT_ROLE,
        dsl.f16(),
        16,
        16,
        _WAVE_SIZE,
        _AB_REGISTERS,
    )
    acc_type = dsl.fragment_type(
        _ACC_FRAGMENT_ROLE,
        dsl.f32(),
        16,
        16,
        _WAVE_SIZE,
        _ACC_REGISTERS,
    )
    load_type = dsl.simd_type(
        dsl.vector_type(_AB_REGISTERS, dsl.i32()), width=_WAVE_SIZE
    )
    zero = bld.constant(dsl.i32(), 0)
    one = bld.constant(dsl.i32(), 1)
    upper = bld.addi(trip_count, one)
    init = bld.fragment_fill(zero, acc_type)
    init_args = [init] * (4 * width) + [startup]

    with bld.for_loop(zero, upper, one, init_args=init_args, nonzero_trip=True) as loop:
        generation = bld.assume_range(
            loop.induction_variable, 0, K // config.generation_k - 1
        )
        accs = list(loop.inner_iter_args[:-1])
        dependency = loop.inner_iter_args[-1]
        accs, published = _consume_stage(
            bld,
            config,
            width=width,
            n_start=n_start,
            consumer=consumer,
            row_group=row_group,
            wi=wi,
            lds=lds,
            lane_zero=lane_zero,
            generation=generation,
            accs=accs,
            dependency=dependency,
            a_type=a_type,
            b_type=b_type,
            load_type=load_type,
            poll_sleep_cycles=poll_sleep_cycles,
            consumer_pipeline=consumer_pipeline,
        )
        bld.yield_([*accs, published])

    _store_consumer_tiles(
        bld,
        M=M,
        N=N,
        width=width,
        n_start=n_start,
        row_group=row_group,
        wg_m=wg_m,
        wg_n=wg_n,
        wi=wi,
        accs=tuple(loop.results[:-1]),
    )


def _emit_consumer(
    bld: dsl.FunctionBuilder,
    config: _PersistentConfig,
    *,
    M: int,
    N: int,
    K: int,
    wi: dsl.Value,
    wave_id: dsl.Value,
    wg_m: dsl.Value,
    wg_n: dsl.Value,
    lds: dsl.Value,
    startup: dsl.Value,
    lane_zero: dsl.Value,
    trip_count: dsl.Value,
    poll_sleep_cycles: int,
    consumer_pipeline: bool,
) -> None:
    consumer = wave_id
    quotient_hi = bld.binary(
        dsl.BinaryKind.MulHUI,
        consumer,
        bld.constant(dsl.i32(), 0xAAAAAAAB),
    )
    row_group = bld.assume_range(
        bld.binary(
            dsl.BinaryKind.ShRUI,
            quotient_hi,
            bld.constant(dsl.i32(), 1),
        ),
        0,
        3,
    )
    col_group = bld.assume_range(
        bld.subi(
            consumer,
            bld.muli(row_group, bld.constant(dsl.i32(), 3)),
        ),
        0,
        2,
    )
    last = bld.scalar_cmpi("eq", col_group, bld.constant(dsl.i32(), 2))
    with bld.if_(last, otherwise=True) as branch:
        _emit_consumer_width(
            bld,
            config,
            M=M,
            N=N,
            K=K,
            width=6,
            n_start=bld.constant(dsl.i32(), 10),
            consumer=consumer,
            row_group=row_group,
            wg_m=wg_m,
            wg_n=wg_n,
            wi=wi,
            lds=lds,
            startup=startup,
            lane_zero=lane_zero,
            trip_count=trip_count,
            poll_sleep_cycles=poll_sleep_cycles,
            consumer_pipeline=consumer_pipeline,
        )
        with branch.otherwise():
            _emit_consumer_width(
                bld,
                config,
                M=M,
                N=N,
                K=K,
                width=5,
                n_start=bld.muli(col_group, bld.constant(dsl.i32(), 5)),
                consumer=consumer,
                row_group=row_group,
                wg_m=wg_m,
                wg_n=wg_n,
                wi=wi,
                lds=lds,
                startup=startup,
                lane_zero=lane_zero,
                trip_count=trip_count,
                poll_sleep_cycles=poll_sleep_cycles,
                consumer_pipeline=consumer_pipeline,
            )


def _emit_kernel(
    bld: dsl.FunctionBuilder,
    config: _PersistentConfig,
    *,
    M: int,
    N: int,
    K: int,
    poll_vmem: bool,
    poll_sleep_cycles: int,
    consumer_pipeline: bool,
) -> None:
    wi = bld.assume_range(
        bld.workitem_id(axis=0, width=_WAVE_SIZE),
        0,
        _WORKGROUP_WAVES * _WAVE_SIZE - 1,
    )
    trip_count = bld.assume_range(bld.args[3], 0, K // config.generation_k - 1)
    wave_id = bld.assume_range(
        bld.binary(
            dsl.BinaryKind.ShRUI,
            bld.read_first(wi),
            bld.constant(dsl.i32(), 6),
        ),
        0,
        _WORKGROUP_WAVES - 1,
    )
    wg_m, wg_n = _cta_coords(bld, M, N)
    lds = bld.shared_memory_base(dsl.i32())
    lane_zero = _lane_zero_mask(bld, wi)
    startup = _initialize_mailboxes(bld, lds, wi, config)
    producer = bld.scalar_cmpi("uge", wave_id, bld.constant(dsl.i32(), _CONSUMER_WAVES))

    with bld.if_(producer, otherwise=True) as role:
        _emit_producer(
            bld,
            config,
            M=M,
            N=N,
            K=K,
            wi=wi,
            wave_id=wave_id,
            wg_m=wg_m,
            wg_n=wg_n,
            lds=lds,
            startup=startup,
            lane_zero=lane_zero,
            trip_count=trip_count,
            poll_vmem=poll_vmem,
            poll_sleep_cycles=poll_sleep_cycles,
        )
        with role.otherwise():
            _emit_consumer(
                bld,
                config,
                M=M,
                N=N,
                K=K,
                wi=wi,
                wave_id=wave_id,
                wg_m=wg_m,
                wg_n=wg_n,
                lds=lds,
                startup=startup,
                lane_zero=lane_zero,
                trip_count=trip_count,
                poll_sleep_cycles=poll_sleep_cycles,
                consumer_pipeline=consumer_pipeline,
            )


def build_gfx950_persistent_f16_gemm_module(
    M: int,
    N: int,
    K: int,
    *,
    poll_vmem: bool = True,
    poll_sleep_cycles: int = 1,
    consumer_pipeline: bool = False,
    k_slices: int = 1,
) -> Module:
    """Build fixed-shape asymmetric persistent-wave GEMM."""
    config = _persistent_config(k_slices)
    _validate_shape(M, N, K, poll_sleep_cycles, config)
    bld = dsl.ModuleBuilder()
    with bld:
        attrs = {
            "wave.dynamic_lds_size": dsl.i64_attr(config.lds_bytes),
            "waveamdmachine.target_waves": dsl.i64_attr(4),
        }
        with (
            bld.gpu_module(GPU_MODULE_NAME) as gpu_module,
            gpu_module.kernel(
                KERNEL_NAME,
                [
                    dsl.ptr_type(dsl.f16()),
                    dsl.ptr_type(dsl.f16()),
                    dsl.ptr_type(dsl.f16()),
                    dsl.i32(),
                ],
                lds_size=0,
                workgroup_size=[_WORKGROUP_WAVES * _WAVE_SIZE, 1, 1],
                attrs=attrs,
            ) as kernel,
        ):
            _emit_kernel(
                kernel,
                config,
                M=M,
                N=N,
                K=K,
                poll_vmem=poll_vmem,
                poll_sleep_cycles=poll_sleep_cycles,
                consumer_pipeline=consumer_pipeline,
            )
    return bld.module


__all__ = [
    "GPU_MODULE_NAME",
    "KERNEL_NAME",
    "LDS_BYTES",
    "build_gfx950_persistent_f16_gemm_module",
]
