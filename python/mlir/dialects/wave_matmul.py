#  Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
#  See https://llvm.org/LICENSE.txt for license information.
#  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

"""Builder for the tiled WMMA f16xf16xf32 matmul kernel + host driver.

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
    workgroup runs ``BM * BN`` waves (one wave per 16x16 output tile).
  * The wave's local id within its workgroup is ``workitem_id_x >> 5``,
    decomposed into ``(m_wave, n_wave)`` via ``BN`` being a power of 2.
  * The wave's global tile is then
    ``(m_tile, n_tile) = (workgroup_id_x * BM + m_wave,
                          workgroup_id_y * BN + n_wave)``.

Shape constraints:
  * ``M``, ``N``, ``K`` are positive multiples of 16.
  * ``BM`` is a positive integer dividing ``M / 16``.
  * ``BN`` is a positive *power of 2* dividing ``N / 16`` (so the
    wave-id decomposition uses ``andi`` + ``shri``).
  * ``BM * BN <= 32`` (RDNA3 caps a workgroup at 32 waves of 32 lanes).
"""

from __future__ import annotations

from dataclasses import dataclass

from mlir.dialects import scf
from mlir.dialects import wave_dsl as dsl
from mlir.ir import Module


def _is_power_of_two(value: int) -> bool:
    return value > 0 and (value & (value - 1)) == 0


_LDS_DWORDS_PER_FRAG = 8 * 32  # 8 registers/lane * 32 lanes (== 1024 bytes)
_LDS_DWORDS_PER_LANE = 8  # 8 dwords/lane in the fragment tuple


@dataclass(frozen=True)
class _MatmulConfig:
    M: int
    N: int
    K: int
    BM: int
    BN: int
    use_buffer: bool = False

    def __post_init__(self) -> None:
        for dim, val in (("M", self.M), ("N", self.N), ("K", self.K)):
            if val <= 0 or val % 16 != 0:
                raise ValueError(f"{dim} must be a positive multiple of 16; got {val}")
        if self.BM < 1 or self.BN < 1:
            raise ValueError(f"BM and BN must be >= 1; got BM={self.BM}, BN={self.BN}")
        if not _is_power_of_two(self.BN):
            raise ValueError(
                f"BN must be a positive power of two (for the wave-id "
                f"decomposition); got BN={self.BN}"
            )
        if (self.M // 16) % self.BM != 0:
            raise ValueError(f"BM (={self.BM}) must divide M/16 (={self.M // 16})")
        if (self.N // 16) % self.BN != 0:
            raise ValueError(f"BN (={self.BN}) must divide N/16 (={self.N // 16})")
        if self.waves_per_workgroup > 32:
            raise ValueError(
                f"BM * BN must be <= 32 (RDNA3 workgroup wave cap); "
                f"got BM={self.BM}, BN={self.BN} (product={self.waves_per_workgroup})"
            )

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
    def threads_per_workgroup(self) -> int:
        return 32 * self.waves_per_workgroup

    @property
    def M_blocks(self) -> int:
        return self.M // (16 * self.BM)

    @property
    def N_blocks(self) -> int:
        return self.N // (16 * self.BN)

    @property
    def k_steps(self) -> int:
        return self.K // 16

    @property
    def log2_BN(self) -> int:
        return self.BN.bit_length() - 1

    @property
    def lds_bytes(self) -> int:
        """Per-workgroup LDS arena (A and B fragment slots, one per wave)."""
        return 2 * self.waves_per_workgroup * _LDS_DWORDS_PER_FRAG * 4


_KERNEL_NAME = "wmma_f16_matmul_tiled"
_GPU_MODULE_NAME = "kernels"
_F16_PTR_HELPER = "wave_memref_to_ptr_global_f16"
_F32_PTR_HELPER = "wave_memref_to_ptr_global_f32"
_PRINT_HELPER = "printMemrefF32"
_MMA_KIND = "wmma.f32.16x16x16.f16"


def _splat_const(bld: dsl.FunctionBuilder, value: int) -> dsl.Value:
    return bld.splat(bld.constant(dsl.i32(), value))


@dataclass(frozen=True)
class _TileCoords:
    """Per-wave coordinates derived from `workitem_id` / `workgroup_id`."""

    wave_id: dsl.Value  # wave id within the workgroup, broadcast to lanes
    lane: dsl.Value  # lane id within the wave
    a_lane_base: dsl.Value  # per-lane pointer into A for this wave's tile
    b_lane_base: dsl.Value  # per-lane pointer into B for this wave's tile
    c_ptr: dsl.Value  # per-lane pointer into C for this wave's tile


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

    Address arithmetic flows through `wave.index_expr` so the
    WaveMachine bucketizer can route uniform symbols (workgroup ids)
    into the soffset slot and lane-varying symbols (lane, m_wave,
    n_wave) into voffset. Non-linear pieces (`>>`, `&`) stay on the
    wave-arith side and feed into the index_expr as bindings.
    """
    a_arg, b_arg, c_arg = bld.args[0], bld.args[1], bld.args[2]
    if cfg.use_buffer:
        a_arg = _wrap_in_buffer(bld, a_arg, cfg.a_elements)
        b_arg = _wrap_in_buffer(bld, b_arg, cfg.b_elements)

    wi = bld.workitem_id(axis=0)  # element[L] = wave_id_in_wg * 32 + L
    lane = bld.lane_id()  # element[L] = L
    wg_m_val = bld.assume_range(bld.workgroup_id(axis=0), 0, cfg.M_blocks - 1)
    wg_n_val = bld.assume_range(bld.workgroup_id(axis=1), 0, cfg.N_blocks - 1)

    # wave_id_in_wg = wi >> 5 (uniform across the wave since L < 32);
    # the BN power-of-two decomposition stays on the wave-arith side
    # because `>>` / `&` aren't linear.
    wave_id_raw = bld.binary("shri", wi, _splat_const(bld, 5))
    wave_id_val = bld.assume_range(wave_id_raw, 0, cfg.waves_per_workgroup - 1)
    n_wave_val = bld.binary("andi", wave_id_val, _splat_const(bld, cfg.BN - 1))
    m_wave_val = bld.binary("shri", wave_id_val, _splat_const(bld, cfg.log2_BN))
    lane_mod16_val = bld.binary("andi", lane, _splat_const(bld, 15))

    # Symbolic offset side: ixsimpl-built expressions feed `wave.index_expr`
    # via the shared `dsl.sym_ctx` so symbol identity stays stable.
    wg_m = dsl.sym("wg_m")
    wg_n = dsl.sym("wg_n")
    m_wave = dsl.sym("m_wave")
    n_wave = dsl.sym("n_wave")
    lane_mod16 = dsl.sym("lane_mod16")
    wave_id = dsl.sym("wave_id")

    # A address (in f16 elements; ptr_add scales by the pointer elt size):
    #   a_off = m_tile * 16*K + (lane & 15) * K
    #         = wg_m * BM*16*K + m_wave * 16*K + lane_mod16 * K
    stride_per_tile = 16 * cfg.K
    a_off = bld.index_expr(
        wg_m * (cfg.BM * stride_per_tile)
        + m_wave * stride_per_tile
        + lane_mod16 * cfg.K,
        bindings={
            "wg_m": wg_m_val,
            "m_wave": m_wave_val,
            "lane_mod16": lane_mod16_val,
        },
    )
    a_lane_base = bld.ptr_add(a_arg, a_off)

    # B address mirrors A with (wg_n, n_wave).
    b_off = bld.index_expr(
        wg_n * (cfg.BN * stride_per_tile)
        + n_wave * stride_per_tile
        + lane_mod16 * cfg.K,
        bindings={
            "wg_n": wg_n_val,
            "n_wave": n_wave_val,
            "lane_mod16": lane_mod16_val,
        },
    )
    b_lane_base = bld.ptr_add(b_arg, b_off)

    # C output offset (in f32 elements):
    #   c_off = ((wg_m * N_blocks + wg_n) * waves_per_wg + wave_id) * 256
    c_off = bld.index_expr(
        wg_m * (cfg.N_blocks * cfg.waves_per_workgroup * 256)
        + wg_n * (cfg.waves_per_workgroup * 256)
        + wave_id * 256,
        bindings={"wg_m": wg_m_val, "wg_n": wg_n_val, "wave_id": wave_id_val},
    )
    c_ptr = bld.ptr_add(c_arg, c_off)

    return _TileCoords(
        wave_id=wave_id_val,
        lane=lane,
        a_lane_base=a_lane_base,
        b_lane_base=b_lane_base,
        c_ptr=c_ptr,
    )


@dataclass(frozen=True)
class _LdsStaging:
    """Per-wave LDS slots for the matmul fragment round-trip."""

    reg_simd_type: dsl.Type
    a_lds_ptrs: dsl.Value
    b_lds_ptrs: dsl.Value


def _emit_lds_staging(
    bld: dsl.FunctionBuilder, cfg: _MatmulConfig, coords: _TileCoords
) -> _LdsStaging:
    """Materialize per-wave A/B LDS slot pointers.

    Offsets are in i32 ELEMENTS (`lds_base()` is `!wave.ptr<i32,
    shared>` and `wave.ptr_add` scales by the pointer element size).
    Each wave's A/B slot is 256 i32 elements (== 1024 bytes == one
    8-register WMMA fragment), with lane L occupying 8 contiguous
    dwords at `slot + L*8`. The B slabs live
    `waves_per_wg * 256` elements after the A slabs. The address
    arithmetic flows through `wave.index_expr` so the bucketizer
    classifies wave_id / lane into the right slot at lowering time.
    """
    reg_simd_type = dsl.simd_type(dsl.vector_type(8, dsl.i32()), width=32)
    lds = bld.lds_base()
    wave_id = dsl.sym("wave_id")
    lane = dsl.sym("lane")
    bindings = {"wave_id": coords.wave_id, "lane": coords.lane}
    a_lds_off = bld.index_expr(
        wave_id * _LDS_DWORDS_PER_FRAG + lane * _LDS_DWORDS_PER_LANE,
        bindings=bindings,
    )
    b_lds_off = bld.index_expr(
        (cfg.waves_per_workgroup * _LDS_DWORDS_PER_FRAG)
        + wave_id * _LDS_DWORDS_PER_FRAG
        + lane * _LDS_DWORDS_PER_LANE,
        bindings=bindings,
    )
    return _LdsStaging(
        reg_simd_type=reg_simd_type,
        a_lds_ptrs=bld.ptr_add(lds, a_lds_off),
        b_lds_ptrs=bld.ptr_add(lds, b_lds_off),
    )


def _load_fragments_through_lds(
    bld: dsl.FunctionBuilder,
    a_ptr: dsl.Value,
    b_ptr: dsl.Value,
    a_type: dsl.Type,
    b_type: dsl.Type,
    staging: _LdsStaging,
) -> tuple[dsl.Value, dsl.Value]:
    """Round-trip the A and B fragments through their LDS slots.

    Issues *both* global loads back-to-back before either `ds_store`,
    so the second tuple's vmem latency overlaps with the first
    tuple's drain. The ticket-wait pass observes that `ds_store A`
    only depends on the A load and emits `s_waitcnt vmcnt(N)` with
    `N == width(B_load)` -- i.e. B's dwords are allowed to remain in
    flight while A's drain, instead of the conservative `vmcnt(0)`
    we would get if every load were immediately followed by its
    store.

    Returns the packed `(a_frag, b_frag)` after the workgroup
    `wave.barrier` so the caller can feed them directly into `mma`.
    """
    a_regs, a_glob_tok = bld.load(a_ptr, staging.reg_simd_type)
    b_regs, b_glob_tok = bld.load(b_ptr, staging.reg_simd_type)
    a_store_tok = bld.store(a_regs, staging.a_lds_ptrs, after=a_glob_tok)
    b_store_tok = bld.store(b_regs, staging.b_lds_ptrs, after=b_glob_tok)
    barrier_tok = bld.barrier(a_store_tok, b_store_tok)
    a_regs2, _ = bld.load(staging.a_lds_ptrs, staging.reg_simd_type, after=barrier_tok)
    b_regs2, _ = bld.load(staging.b_lds_ptrs, staging.reg_simd_type, after=barrier_tok)
    return bld.fragment_pack(a_regs2, a_type), bld.fragment_pack(b_regs2, b_type)


def _emit_kernel(bld: dsl.FunctionBuilder, cfg: _MatmulConfig) -> None:
    """Populate the tiled matmul kernel body.

    Memory layout (in f16 elements, addresses in element units):
      * A is row-major ``M x K``; lane ``L`` of the A fragment owns row
        ``m_tile * 16 + L % 16``.
      * B is column-major ``K x N`` (equivalent to row-major ``N x K``);
        lane ``L`` owns column ``n_tile * 16 + L % 16``.
      * Output C is f32 in "tile block" layout: each wave writes 256
        contiguous f32 elements starting at
        ``((workgroup_id_x * N_blocks + workgroup_id_y) * waves_per_wg
          + wave_id_in_wg) * 256``.

    Software pipelining (RDNA3 has no direct global-to-LDS DMA, so the
    fragment staging is global_load -> VGPR -> ds_store -> barrier ->
    ds_load, a long synchronous chain). Each loop iteration overlaps
    the WMMA of the current K-step with the global+LDS prefetch of the
    next K-step, so the global_load latency is hidden behind WMMA
    issue. Schedule:

      prologue: prefetch frag[0] through LDS.
      loop body (k_steps - 1 iters):
        WMMA(frag[k], acc)              # current iter's compute
        prefetch frag[k+1] through LDS  # next iter's load (overlap)
      epilogue: WMMA(frag[K-1], acc).
    """
    coords = _emit_tile_coords(bld, cfg)

    a_type = dsl.fragment_type(0, dsl.f16(), 16, 16, 32, 8)
    b_type = dsl.fragment_type(1, dsl.f16(), 16, 16, 32, 8)
    acc_type = dsl.fragment_type(2, dsl.f32(), 16, 16, 32, 8)

    staging = _emit_lds_staging(bld, cfg, coords)

    init_acc = bld.fragment_fill(bld.constant(dsl.i32(), 0), acc_type)
    c16 = _splat_const(bld, 16)

    # Prologue: stage frag[0] through LDS so the loop's first WMMA has
    # data ready to consume.
    a_frag0, b_frag0 = _load_fragments_through_lds(
        bld, coords.a_lane_base, coords.b_lane_base, a_type, b_type, staging
    )
    a_ptr1 = bld.ptr_add(coords.a_lane_base, c16)
    b_ptr1 = bld.ptr_add(coords.b_lane_base, c16)

    # The fourth kernel arg is the pipelined-loop trip count
    # (`K/16 - 1`, precomputed on the host). The loop body always pairs
    # a WMMA on the carried fragment with a prefetch of the *next*
    # fragment, so we run one fewer iteration than there are K-tiles
    # and finish the last WMMA in the epilogue. The pre-tested
    # `scf.for` shape (no `wave.nonzero_trip`) keeps the K=16
    # (k_steps=1) edge case correct by collapsing the loop to zero
    # iterations.
    trip_count_i32 = bld.args[3]
    zero_i32 = bld.constant(dsl.i32(), 0)
    one_i32 = bld.constant(dsl.i32(), 1)

    with bld.for_loop(
        zero_i32,
        trip_count_i32,
        one_i32,
        init_args=(init_acc, a_frag0, b_frag0, a_ptr1, b_ptr1),
    ) as forop:
        carry_acc, carry_af, carry_bf, carry_ap, carry_bp = forop.inner_iter_args
        new_acc = bld.mma(_MMA_KIND, carry_af, carry_bf, carry_acc)
        new_af, new_bf = _load_fragments_through_lds(
            bld, carry_ap, carry_bp, a_type, b_type, staging
        )
        new_ap = bld.ptr_add(carry_ap, c16)
        new_bp = bld.ptr_add(carry_bp, c16)
        scf.YieldOp([new_acc, new_af, new_bf, new_ap, new_bp])

    final_acc_in = forop.results[0]
    final_af = forop.results[1]
    final_bf = forop.results[2]
    final_acc = bld.mma(_MMA_KIND, final_af, final_bf, final_acc_in)

    bld.fragment_store(final_acc, coords.c_ptr)


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

    # cfg.K is the buffer K used for allocation; the kernel runs a
    # software-pipelined loop whose trip count is `K/16 - 1` (the
    # prologue/epilogue absorb the first/last WMMA), so we pass that
    # value (clamped at 0) as the fourth i32 kernel arg.
    pipelined_trip_count = max(cfg.k_steps - 1, 0)
    trip_count_value = bld.constant(dsl.i32(), pipelined_trip_count)
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
    use_buffer: bool = False,
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
        use_buffer=use_buffer,
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
            # Per-tile K-step count (= K // 16). Passed by value as i32.
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


__all__ = ["build_wmma_f16_matmul_module"]
