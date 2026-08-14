# RUN: env PYTHONWARNINGS=error %PYTHON %s | FileCheck %s

import ixsimpl
from mlir.dialects import arith, gpu
from mlir.dialects import wave_dsl as w
from mlir.ir import ArrayAttr, Attribute, Context, Location, Module


def run(f):
    print("\nTEST:", f.__name__)
    f()


def assert_raises(error_type, message, callback):
    try:
        callback()
    except error_type as exc:
        assert str(exc) == message
        return
    raise AssertionError(f"expected {error_type.__name__}: {message}")


# CHECK-LABEL: TEST: test_ixs_check_uses_reusable_facts
@run
def test_ixs_check_uses_reusable_facts():
    x = w.sym("ixs_check_proof_carrier_x")
    bits = tuple(w.mod(w.floor(w.mod(x, 8) / (1 << bit)), 2) for bit in range(3))
    packed = sum(
        (digit * (1 << bit) for bit, digit in enumerate(bits)),
        w.ixs_int(0),
    )
    facts = (x >= 0, x <= 15, w.ixs_eq(packed, 0))
    normalized_carrier = (x < -(1 << 31)) | (x > -(1 << 31))
    queries = (
        w.ixs_eq(bits[-1], 0),
        normalized_carrier,
        w.ixs_eq(bits[-1], 1),
        w.ixs_eq(x, 0),
    )

    proofs, normalized = w.ixs_check(queries, facts)

    assert proofs == (True, True, False, None)
    assert str(normalized[0]) == "1"
    assert str(normalized[1]) == "1"


# CHECK-LABEL: TEST: test_rocdl_target_registration
@run
def test_rocdl_target_registration():
    with Context() as ctx, Location.unknown():
        w.register_dialects(ctx)
        module = Module.parse(r"""module attributes {gpu.container_module} {
  gpu.binary @kernels [#gpu.object<#rocdl.target<chip = "gfx950", O = 3>, bin = "\7FELF">]
}""")
        binary = module.body.operations[0]
        objects = ArrayAttr(binary.attributes["objects"])
        print(bytes(gpu.ObjectAttr(objects[0]).object))

    # CHECK: b'\x7fELF'


# CHECK-LABEL: TEST: test_generic_wave_kernel
@run
def test_generic_wave_kernel():
    with w.module() as m:
        with m.function(
            "generic_wave_kernel", [w.ptr_type(w.i32()), w.i32()], kernel=True
        ) as f:
            out, x = f.args
            lane = f.lane_id()
            vx = f.splat(x)
            ptrs = f.ptr_add(out, lane, w.simd_type(w.ptr_type(w.i32())))
            token = f.store(vx, ptrs)
            f.barrier(token)
        # CHECK: func.func @generic_wave_kernel
        # CHECK: wave.lane_id
        # CHECK: wave.splat
        # CHECK: wave.store
        # CHECK: wave.barrier
        print(m.module)


# CHECK-LABEL: TEST: test_sched_barrier
@run
def test_sched_barrier():
    with w.module() as m:
        with m.function("sched_barrier_kernel", [], kernel=True) as f:
            f.sched_barrier()
        # CHECK: func.func @sched_barrier_kernel
        # CHECK: wave.sched_barrier
        print(m.module)


# CHECK-LABEL: TEST: test_cluster_barrier
@run
def test_cluster_barrier():
    with w.module() as m:
        with m.function("cluster_barrier_kernel", [], kernel=True) as f:
            source = f.token()
            f.barrier(source, scope=w.BarrierScope.Cluster)
        # CHECK: [[SOURCE:%.*]] = wave.token
        # CHECK-NEXT: wave.barrier [[SOURCE]] scope cluster
        print(m.module)


# CHECK-LABEL: TEST: test_cluster_ids
@run
def test_cluster_ids():
    with w.module() as m:
        with m.function("cluster_ids", [], kernel=True, cluster_dims=(2, 2, 1)) as f:
            f.cluster_id(w.ClusterAxis.X)
            f.cluster_workgroup_id(1)
            f.cluster_workgroup_max_id(2)
        with (
            m.gpu_module("cluster_module") as g,
            g.kernel("cluster_kernel", [], cluster_dims=(4, 1, 1)) as f,
        ):
            f.cluster_id()
        # CHECK: func.func @cluster_ids()
        # CHECK-SAME: gpu.known_cluster_size = array<i32: 2, 2, 1>
        # CHECK-SAME: wave.cluster_dims = array<i32: 2, 2, 1>
        # CHECK: wave.cluster_id x
        # CHECK: wave.cluster_workgroup_id y
        # CHECK: wave.cluster_workgroup_max_id z
        # CHECK: func.func @cluster_kernel()
        # CHECK-SAME: gpu.known_cluster_size = array<i32: 4, 1, 1>
        # CHECK-SAME: wave.cluster_dims = array<i32: 4, 1, 1>
        # CHECK: wave.cluster_id x
        print(m.module)


# CHECK-LABEL: TEST: test_issue_token
@run
def test_issue_token():
    with w.module() as m:
        with m.function("issue_token_kernel", [], kernel=True) as f:
            source = f.token()
            issued = f.issue_token(source)
            f.barrier(issued)
        # CHECK: [[SOURCE:%.*]] = wave.token
        # CHECK: [[ISSUED:%.*]] = wave.issue_token [[SOURCE]]
        # CHECK: wave.barrier [[ISSUED]]
        print(m.module)


# CHECK-LABEL: TEST: test_set_priority
@run
def test_set_priority():
    with w.module() as m:
        with m.function("set_priority_kernel", [], kernel=True) as f:
            f.set_priority(2)
        # CHECK: waveamd.set_priority 2
        print(m.module)


# CHECK-LABEL: TEST: test_set_priority_inc_wg
@run
def test_set_priority_inc_wg():
    with w.module() as m:
        with m.function("set_priority_inc_wg_kernel", [], kernel=True) as f:
            f.set_priority_inc_wg(100)
        # CHECK: waveamd.set_priority_inc_wg 100
        print(m.module)


# CHECK-LABEL: TEST: test_generic_wave_kernel_attrs
@run
def test_generic_wave_kernel_attrs():
    with w.module() as m:
        with m.function(
            "generic_wave_kernel_attrs",
            [],
            kernel=True,
            lds_size=128,
            workgroup_size=[64, 1, 1],
            attrs={"waveamdmachine.target_waves": w.i64_attr(2)},
        ):
            pass
        # CHECK: func.func @generic_wave_kernel_attrs()
        # CHECK-SAME: gpu.known_block_size = array<i32: 64, 1, 1>
        # CHECK-SAME: wave.kernel
        # CHECK-SAME: wave.lds_size = 128 : i64
        # CHECK-SAME: wave.workgroup_size = array<i32: 64, 1, 1>
        # CHECK-SAME: waveamdmachine.target_waves = 2 : i64
        print(m.module)


# CHECK-LABEL: TEST: test_waveamd_matrix_kernel
@run
def test_waveamd_matrix_kernel():
    with w.module() as m:
        with m.function("matrix_kernel", [w.ptr_type(w.i32())], kernel=True) as f:
            (out,) = f.args
            zero = f.constant(w.i32(), 0)
            seven = f.constant(w.i32(), 7)
            base = f.constant(w.index_type(), 0)
            a_t = w.fragment_type(0, w.i8(), registers=4)
            b_t = w.fragment_type(1, w.i8(), registers=4)
            acc_t = w.fragment_type(2, w.i32(), registers=8)
            a = f.fragment_fill(zero, a_t)
            b = f.fragment_fill(zero, b_t)
            acc = f.fragment_fill(seven, acc_t)
            result = f.mma("wmma.i32.16x16x16.iu8", a, b, acc)
            ptr = f.ptr_add(out, base)
            token = f.fragment_store(result, ptr)
            f.barrier(token)
        # CHECK: func.func @matrix_kernel
        # CHECK: waveamd.fragment_fill
        # CHECK: waveamd.mma
        # CHECK: waveamd.fragment_unpack
        # CHECK: wave.store
        # CHECK: wave.barrier
        print(m.module)


# CHECK-LABEL: TEST: test_packed_fragment_math
@run
def test_packed_fragment_math():
    with w.module() as m:
        packet = w.simd_type(w.vector_type(16, w.f32()), width=64)
        scalar = w.simd_type(w.f32(), width=64)
        frag_t = w.fragment_type(2, w.f32(), 32, 32, 64, 16)
        with m.function("packed_fragment_math", [scalar], kernel=True) as f:
            (value,) = f.args
            packed = f.pack([value] * 16, packet)
            fragment = f.fragment_pack(packed, frag_t)
            unpacked = f.fragment_unpack(fragment, packet)
            first = f.extract(unpacked, 0, scalar)
            f.fma(first, first, first)
        # CHECK: wave.pack
        # CHECK: waveamd.fragment_pack
        # CHECK: waveamd.fragment_unpack
        # CHECK: wave.extract
        # CHECK: wave.fma
        print(m.module)


# CHECK-LABEL: TEST: test_float_fastmath
@run
def test_float_fastmath():
    with w.module() as m:
        scalar = w.simd_type(w.f32(), width=64)
        with m.function("float_fastmath", [scalar, scalar], kernel=True) as f:
            lhs, rhs = f.args
            add = f.fadd(lhs, rhs, fastmath=arith.FastMathFlags.reassoc)
            sub = f.fsub(add, rhs, fastmath=arith.FastMathFlags.nnan)
            mul = f.fmul(sub, rhs, fastmath=arith.FastMathFlags.ninf)
            f.fma(
                mul,
                lhs,
                rhs,
                fastmath=arith.FastMathFlags.reassoc | arith.FastMathFlags.contract,
            )
            f.fmax(lhs, rhs, fastmath=arith.FastMathFlags.nsz)
            f.fexp2(lhs, fastmath=arith.FastMathFlags.afn)
            f.frcp(rhs, fastmath=arith.FastMathFlags.arcp)
        # CHECK: wave.fadd {{.*}} fastmath<reassoc>
        # CHECK: wave.fsub {{.*}} fastmath<nnan>
        # CHECK: wave.fmul {{.*}} fastmath<ninf>
        # CHECK: wave.fma {{.*}} fastmath<reassoc,contract>
        # CHECK: wave.fmax {{.*}} fastmath<nsz>
        # CHECK: wave.fexp2 {{.*}} fastmath<afn>
        # CHECK: wave.frcp {{.*}} fastmath<arcp>
        print(m.module)


# CHECK-LABEL: TEST: test_waveamd_load_and_fragment_pack
@run
def test_waveamd_load_and_fragment_pack():
    with w.module() as m:
        with m.function(
            "load_pack_kernel",
            [w.ptr_type(w.i32()), w.ptr_type(w.i32())],
            kernel=True,
        ) as f:
            in_ptr, out_ptr = f.args
            lane = f.lane_id()
            simd_in = f.ptr_add(in_ptr, lane, w.simd_ptr_type(w.i32()))
            base = f.constant(w.index_type(), 0)
            scalar_out = f.ptr_add(out_ptr, base)

            tuple_t = w.simd_type(w.vector_type(8, w.i32()))
            acc_t = w.fragment_type(2, w.f32(), registers=8)
            regs, tok = f.load(simd_in, tuple_t)
            frag = f.fragment_pack(regs, acc_t)
            f.fragment_store(frag, scalar_out, after=tok)

            scalar_t = w.simd_type(w.i32())
            simd_out = f.ptr_add(out_ptr, lane, w.simd_ptr_type(w.i32()))
            scalar, scalar_tok = f.load(simd_in, scalar_t, after=tok)
            f.store(scalar, simd_out, after=scalar_tok)

            load_cache = w.load_cache(w.LoadCacheAttr.CS)
            store_cache = w.store_cache(w.StoreCacheAttr.WB)
            packed_frag, pack_tok = f.fragment_load(
                simd_in, acc_t, after=scalar_tok, cache=load_cache
            )
            f.fragment_store(packed_frag, scalar_out, after=pack_tok, cache=store_cache)
        # CHECK: func.func @load_pack_kernel
        # CHECK: wave.load {{.*}} -> (!wave.simd<vector<8xi32>, 32>, !wave.mem.token)
        # CHECK: waveamd.fragment_pack {{.*}} -> !waveamd.fragment<2, f32, 16, 16, 32, 8>
        # CHECK: wave.load {{.*}} after {{.*}} -> (!wave.simd<i32, 32>, !wave.mem.token)
        # CHECK: wave.load {{.*}} {cache = #waveamd.load_cache<cs>} {{.*}} -> (!wave.simd<vector<8xi32>, 32>, !wave.mem.token)
        # CHECK: waveamd.fragment_pack
        # CHECK: wave.store {{.*}} {cache = #waveamd.store_cache<wb>}
        print(m.module)


# CHECK-LABEL: TEST: test_cache_attrs
@run
def test_cache_attrs():
    with w.module() as m:
        with m.function("cache_kernel", [w.ptr_type(w.i32())], kernel=True) as f:
            (ptr,) = f.args
            lane = f.lane_id()
            ptrs = f.ptr_add(ptr, lane, w.simd_ptr_type(w.i32()))
            load_cache = w.load_cache(w.LoadCacheAttr.CG)
            store_cache = w.store_cache(w.StoreCacheAttr.WT)
            assert w.LoadCacheAttr.isinstance(load_cache)
            assert w.StoreCacheAttr.isinstance(store_cache)
            assert w.LoadCacheAttr(load_cache).value == w.LoadCacheAttr.CG
            assert w.StoreCacheAttr(store_cache).value == w.StoreCacheAttr.WT
            value, tok = f.load(ptrs, w.simd_type(w.i32()), cache=load_cache)
            f.store(value, ptrs, after=tok, cache=store_cache)
        # CHECK: wave.load {{.*}} {cache = #waveamd.load_cache<cg>}
        # CHECK: wave.store {{.*}} {cache = #waveamd.store_cache<wt>}
        print(m.module)


def _check_typed_type_bindings():
    i32, f32 = w.i32(), w.f32()
    global_addr = w.global_address_space()
    simd = w.simd_type(i32)
    assert w.SimdType.isinstance(simd)
    casted = w.SimdType(simd)
    assert casted.element_type == i32 and casted.width == 32

    ptr = w.ptr_type(f32, global_addr)
    assert w.PtrType.isinstance(ptr)
    casted_ptr = w.PtrType(ptr)
    assert casted_ptr.element_type == f32
    assert casted_ptr.address_space == global_addr

    opaque = w.opaque_ptr_type(global_addr)
    assert w.PtrType.isinstance(opaque)
    opaque_ptr = w.PtrType(opaque)
    assert opaque_ptr.element_type is None
    assert opaque_ptr.address_space == global_addr
    print(opaque)

    mask = w.mask_type(32)
    assert w.MaskType.isinstance(mask)
    assert w.MaskType(mask).width == 32
    assert w.MemTokenType.isinstance(w.mem_token_type())
    assert w.PtrType(w.buffer_ptr_type(f32)).address_space == w.buffer_address_space()

    frag = w.fragment_type(2, f32, registers=8)
    assert w.FragmentType.isinstance(frag)
    casted_frag = w.FragmentType(frag)
    assert casted_frag.role == 2
    assert casted_frag.element_type == f32
    assert casted_frag.rows == 16
    assert casted_frag.columns == 16
    assert casted_frag.wave_size == 32
    assert casted_frag.registers == 8

    idx = w.index_type()
    lane_idx = w.simd_type(idx, 32)
    assert str(idx) == "index"
    assert w.SimdType.isinstance(lane_idx)
    assert w.SimdType(lane_idx).element_type == idx


def _check_typed_expr_bindings():
    expr = w.ExprAttr.get("4*lid + K", context=w.Context.current)
    assert w.ExprAttr.isinstance(expr)
    raw_expr = 4 * w.sym("lid") + w.sym("K")
    expr_from_node = w.ExprAttr.get_from_node_ptr(
        raw_expr.node_ptr, context=w.Context.current
    )
    assert w.ExprAttr.isinstance(expr_from_node)
    assert expr_from_node == expr
    expr_from_bytes = w.ExprAttr.get_from_bytes(
        w.sym_ctx.serialize(raw_expr), context=w.Context.current
    )
    assert w.ExprAttr.isinstance(expr_from_bytes)
    assert expr_from_bytes == expr
    assert_raises(
        ValueError,
        "failed to import wave.expr node",
        lambda: w.ExprAttr.get_from_node_ptr(0, context=w.Context.current),
    )
    assert_raises(
        ValueError,
        "failed to import wave.pred node",
        lambda: w.PredAttr.get_from_node_ptr(0, context=w.Context.current),
    )
    assert_raises(
        ValueError,
        "failed to import wave.pred node",
        lambda: w.PredAttr.get_from_node_ptr(
            raw_expr.node_ptr, context=w.Context.current
        ),
    )

    source_context = ixsimpl.Context()
    source_expr = 4 * source_context.sym("source") + 1
    expr_from_foreign_node = w.ExprAttr.get_from_node_ptr(
        source_expr.node_ptr, context=w.Context.current
    )
    source_bytes = source_context.serialize(source_expr)
    del source_expr
    del source_context
    assert str(expr_from_foreign_node) == '#wave.expr<"1 + 4*source">'
    expr_after_source_lifetime = w.ExprAttr.get_from_bytes(
        source_bytes, context=w.Context.current
    )
    assert str(expr_after_source_lifetime) == '#wave.expr<"1 + 4*source">'

    attrs = {
        name: w.ExprAttr.get_from_node_ptr(
            w.sym(name).node_ptr, context=w.Context.current
        )
        for name in ("block", "item", "slot")
    }
    relation = w.RedistributionAttr.get(
        2, 64, attrs["block"], attrs["item"], attrs["slot"]
    )
    assert w.RedistributionAttr.isinstance(relation)
    assert relation.blocks == 2
    assert relation.items == 64
    assert str(relation.source_block) == '#wave.expr<"block">'
    assert str(relation.source_item) == '#wave.expr<"item">'
    assert str(relation.source_slot) == '#wave.expr<"slot">'
    return raw_expr


def _check_typed_predicate_bindings(raw_expr):
    pred = w.PredAttr.get("K >= 0", context=w.Context.current)
    assert w.PredAttr.isinstance(pred)
    raw_pred = w.sym_ctx.eq(w.mod(w.sym("K"), w.sym_ctx.int_(16)), w.sym_ctx.int_(0))
    pred_from_node = w.PredAttr.get_from_node_ptr(
        raw_pred.node_ptr, context=w.Context.current
    )
    assert w.PredAttr.isinstance(pred_from_node)
    pred_from_bytes = w.PredAttr.get_from_bytes(
        w.sym_ctx.serialize(raw_pred), context=w.Context.current
    )
    assert w.PredAttr.isinstance(pred_from_bytes)
    raw_piecewise = ixsimpl.pw(
        (w.sym("K") >= 0, w.sym("guard") >= 0),
        (w.sym_ctx.false_(), w.sym_ctx.true_()),
    )
    pred_piecewise = w.PredAttr.get_from_node_ptr(
        raw_piecewise.node_ptr, context=w.Context.current
    )
    assert w.PredAttr.isinstance(pred_piecewise)
    expr_piecewise = w.ExprAttr.get_from_node_ptr(
        raw_piecewise.node_ptr, context=w.Context.current
    )
    assert w.ExprAttr.isinstance(expr_piecewise)
    pred_piecewise_bytes = w.PredAttr.get_from_bytes(
        w.sym_ctx.serialize(raw_piecewise), context=w.Context.current
    )
    assert w.PredAttr.isinstance(pred_piecewise_bytes)
    expr_piecewise_bytes = w.ExprAttr.get_from_bytes(
        w.sym_ctx.serialize(raw_piecewise), context=w.Context.current
    )
    assert w.ExprAttr.isinstance(expr_piecewise_bytes)
    assert w.ExprAttr.isinstance(Attribute.parse(str(expr_piecewise_bytes)))
    raw_pred_expr = w.ExprAttr.get_from_bytes(
        w.sym_ctx.serialize(raw_pred), context=w.Context.current
    )
    assert w.ExprAttr.isinstance(raw_pred_expr)
    assert w.ExprAttr.isinstance(Attribute.parse(str(raw_pred_expr)))
    assert_raises(
        ValueError,
        "failed to deserialize wave.pred bytes",
        lambda: w.PredAttr.get_from_bytes(
            w.sym_ctx.serialize(raw_expr), context=w.Context.current
        ),
    )
    assert_raises(
        ValueError,
        "failed to deserialize wave.expr bytes",
        lambda: w.ExprAttr.get_from_bytes(
            w.sym_ctx.serialize(raw_expr)[:-1], context=w.Context.current
        ),
    )
    assert_raises(
        ValueError,
        "failed to deserialize wave.pred bytes",
        lambda: w.PredAttr.get_from_bytes(
            b"not-an-ixsimpl-blob", context=w.Context.current
        ),
    )


# CHECK-LABEL: TEST: test_typed_bindings
@run
def test_typed_bindings():
    with w.module():
        _check_typed_type_bindings()
        raw_expr = _check_typed_expr_bindings()
        _check_typed_predicate_bindings(raw_expr)
        print("ok")
        # CHECK: !wave.ptr<#wave.global>
        # CHECK: ok


# CHECK-LABEL: TEST: test_memory_mapping_attr
@run
def test_memory_mapping_attr():
    with w.module():
        attrs = {
            name: w.ExprAttr.get_from_node_ptr(
                w.sym(name).node_ptr, context=w.Context.current
            )
            for name in ("block", "item", "slot")
        }
        mapping = w.MemoryMappingAttr.get(
            attrs["slot"], base=attrs["block"], target_block=attrs["item"]
        )
        assert w.MemoryMappingAttr.isinstance(mapping)
        assert str(mapping.base) == '#wave.expr<"block">'
        assert str(mapping.target_block) == '#wave.expr<"item">'
        assert str(mapping.bit_offset) == '#wave.expr<"slot">'
        default_mapping = w.MemoryMappingAttr.get(attrs["slot"])
        assert default_mapping.base is None
        assert default_mapping.target_block is None
        print("ok")
        # CHECK: ok


# CHECK-LABEL: TEST: test_redistribute_builder
@run
def test_redistribute_builder():
    with w.module() as m:
        packet = w.simd_type(w.vector_type(2, w.i32()), 32)
        with m.function(
            "redistribute_kernel",
            [packet],
            kernel=True,
            workgroup_size=[64, 1, 1],
        ) as f:
            (source,) = f.args
            item = w.sym("item")
            slot = w.sym("slot")
            _result = f.redistribute(
                source,
                packet,
                items=64,
                source_item=w.xor(item, w.sym_ctx.int_(1)),
                source_slot=slot,
            )
        # CHECK: wave.redistribute
        # CHECK-SAME: <blocks = 1, items = 64, source_block = "block", source_item = "xor(1, item)", source_slot = "slot">
        print(m.module)
        w.PassManager.parse("builtin.module(wave-lower-redistribute)").run(
            m.module.operation
        )
        # CHECK: wave.shuffle
        # CHECK-NOT: wave.redistribute
        print(m.module)


# CHECK-LABEL: TEST: test_assume_helpers
@run
def test_assume_helpers():
    with w.module() as m:
        with m.function("assume_kernel", [w.i32()], kernel=True) as f:
            (x,) = f.args
            _bounded = f.assume_range(x, 0, 31)
            _divisible = f.assume_divisible(x, 16)
            y = w.sym("y")
            _manual = f.assume(x, [y >= w.sym_ctx.int_(0)], name="y")
        # CHECK: func.func @assume_kernel
        # CHECK: wave.assume {{.*}} as "x" {{\[.*\]}} : i32
        # CHECK: wave.assume {{.*}} as "x" [#wave.pred<"Mod(x, 16) == 0">] : i32
        # CHECK: wave.assume {{.*}} as "y" [#wave.pred<"y >= 0">] : i32
        print(m.module)


# CHECK-LABEL: TEST: test_waveamd_buffer_pointer_type
@run
def test_waveamd_buffer_pointer_type():
    with w.module() as m:
        with m.function("buffer_ptr_kernel", [w.ptr_type(w.i32())], kernel=True) as f:
            (out,) = f.args
            range_bytes = f.constant(w.i32(), 128)
            buffer = f.make_buffer(out, range_bytes, w.buffer_ptr_type(w.i32()))
            lane = f.lane_id()
            f.ptr_add(buffer, lane, w.simd_type(w.buffer_ptr_type(w.i32())))
        # CHECK: func.func @buffer_ptr_kernel
        # CHECK: waveamd.make_buffer
        # CHECK: !wave.ptr<#waveamd.buffer, i32>
        # CHECK: !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
        print(m.module)


# CHECK-LABEL: TEST: test_waveamd_dma_load_lds
@run
def test_waveamd_dma_load_lds():
    with w.module() as m:
        with m.function("dma_load_lds_kernel", [w.ptr_type(w.i32())], kernel=True) as f:
            (src_base,) = f.args
            lane = f.lane_id()
            src = f.ptr_add(src_base, lane, w.simd_ptr_type(w.i32()))
            lds = f.shared_memory_base()
            dep = f.token()
            f.dma_load_lds(
                src,
                lds,
                after=dep,
                issue_delay_cycles=46,
                issue_delay_overlap_cycles=33,
                issue_delay_skip_thread_threshold=256,
            )
        # CHECK: waveamd.dma_load_lds
        # CHECK-SAME: bytes = 4 : i64
        # CHECK-SAME: issue_delay_cycles = 46 : i64
        # CHECK-SAME: issue_delay_overlap_cycles = 33 : i64
        # CHECK-SAME: issue_delay_skip_thread_threshold = 256 : i64
        print(m.module)


# CHECK-LABEL: TEST: test_workgroup_alloc
@run
def test_workgroup_alloc():
    with w.module() as m:
        with m.function("alloc_kernel", [], kernel=True) as f:
            allocation = f.workgroup_alloc(128, 16, w.i8())
            f.release_alloc(allocation, after=f.token())
        # CHECK: wave.alloc() {align = 16 : i64, bytesize = 128 : i64} : !wave.ptr<#wave.shared, i8>
        # CHECK: wave.alloc_release
        print(m.module)


# CHECK-LABEL: TEST: test_waveamd_transpose_load
@run
def test_waveamd_transpose_load():
    with w.module() as m:
        with m.function("transpose_load_kernel", [], kernel=True) as f:
            lane = f.lane_id(width=64)
            lds = f.shared_memory_base(w.i8())
            ptr = f.ptr_add(
                lds, lane, w.simd_ptr_type(w.i8(), w.shared_address_space(), 64)
            )
            f.transpose_load(ptr)
            lds_i16 = f.shared_memory_base(w.i16())
            ptr_i16 = f.ptr_add(
                lds_i16,
                lane,
                w.simd_ptr_type(w.i16(), w.shared_address_space(), 64),
            )
            f.transpose_load(ptr_i16, w.simd_type(w.vector_type(4, w.i16()), width=64))
            lds_f16 = f.shared_memory_base(w.f16())
            ptr_f16 = f.ptr_add(
                lds_f16,
                lane,
                w.simd_ptr_type(w.f16(), w.shared_address_space(), 64),
            )
            f.transpose_load(ptr_f16, w.simd_type(w.vector_type(4, w.f16()), width=64))
            lds_bf16 = f.shared_memory_base(w.bf16())
            ptr_bf16 = f.ptr_add(
                lds_bf16,
                lane,
                w.simd_ptr_type(w.bf16(), w.shared_address_space(), 64),
            )
            f.transpose_load(
                ptr_bf16, w.simd_type(w.vector_type(4, w.bf16()), width=64)
            )
        # CHECK: waveamd.transpose_load
        # CHECK-SAME: -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
        # CHECK: waveamd.transpose_load
        # CHECK-SAME: -> (!wave.simd<vector<4xi16>, 64>, !wave.mem.token)
        # CHECK: waveamd.transpose_load
        # CHECK-SAME: -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        # CHECK: waveamd.transpose_load
        # CHECK-SAME: -> (!wave.simd<vector<4xbf16>, 64>, !wave.mem.token)
        print(m.module)


# CHECK-LABEL: TEST: test_symbolic_gather
@run
def test_symbolic_gather():
    with w.module() as m:
        with m.function(
            "symbolic_gather",
            [
                w.ptr_type(w.i8(), w.shared_address_space()),
                w.index_type(),
            ],
            workgroup_size=[64, 1, 1],
        ) as f:
            base, origin_value = f.args
            origin = w.sym("origin")
            item = w.sym("item")
            item_value = f.workitem_id(0, w.i32(), width=64)
            f.gather(
                base,
                w.simd_type(w.vector_type(8, w.i8()), width=64),
                bit_offset=8 * (origin + item + w.sym("slot")),
                bindings={origin: origin_value, item: item_value},
            )
            f.gather(
                base,
                w.simd_type(w.vector_type(8, w.i8()), width=64),
                bit_offset=8 * (origin + 2 * w.sym("slot")),
                bindings={origin: origin_value},
            )
        # CHECK: wave.workitem_id 0
        # CHECK: wave.gather %arg0 mapping
        # CHECK-SAME: bindings ["item", "origin"](%{{.*}}, %arg1)
        # CHECK-SAME: -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
        # CHECK: wave.gather %arg0 mapping
        # CHECK-SAME: bindings ["origin"](%arg1)
        print(m.module)


# CHECK-LABEL: TEST: test_symbolic_memory_builder_diagnostics
@run
def test_symbolic_memory_builder_diagnostics():
    with w.module() as m:
        with m.function(
            "symbolic_memory_diagnostics",
            [w.ptr_type(w.i32()), w.index_type()],
        ) as f:
            base, scalar_value = f.args
            index = w.sym("index")
            result_type = w.simd_type(w.vector_type(4, w.i32()), width=64)

            def gather(**kwargs):
                return f.gather(
                    base,
                    result_type,
                    bit_offset=32 * index,
                    **kwargs,
                )

            item = w.sym("item")

            def item_gather(**kwargs):
                return f.gather(
                    base,
                    result_type,
                    bit_offset=32 * (index + item),
                    **kwargs,
                )

            assert_raises(
                TypeError,
                "binding keys must be symbol expressions",
                lambda: gather(bindings={index + w.sym_ctx.int_(1): scalar_value}),
            )
            assert_raises(
                ValueError,
                "mapping symbols missing from bindings: ['item']",
                lambda: item_gather(bindings={index: scalar_value}),
            )
            wrong_item = f.workitem_id(0, w.i32(), width=32)
            assert_raises(
                TypeError,
                "item binding must be lane SIMD i32 with packet SIMD width",
                lambda: item_gather(
                    bindings={index: scalar_value, item: wrong_item},
                ),
            )

            other_context = ixsimpl.Context()
            duplicate_bindings = {
                index: scalar_value,
                other_context.sym("index"): scalar_value,
            }
            assert_raises(
                ValueError,
                "duplicate binding name 'index'",
                lambda: gather(bindings=duplicate_bindings),
            )
            assert_raises(
                TypeError,
                "binding 'index' must be one SSA value",
                lambda: gather(bindings={index: [scalar_value]}),
            )
            assert_raises(
                ValueError,
                "mapping symbols missing from bindings: ['index']",
                gather,
            )
        print("ok")
        # CHECK: ok


# CHECK-LABEL: TEST: test_wave_cast_helper
@run
def test_wave_cast_helper():
    with w.module() as m:
        with m.function("cast_kernel", [], kernel=True) as f:
            one = f.constant(w.f32(), 1.0)
            vx = f.splat(one, w.f32())
            f.fpconvert(vx, w.simd_type(w.f16()))
        # CHECK: wave.cast fpconvert
        # CHECK-SAME: !wave.simd<f32, 32> -> !wave.simd<f16, 32>
        print(m.module)


# CHECK-LABEL: TEST: test_index_expr
@run
def test_index_expr():
    with w.module() as m:
        with m.function("index_expr_kernel", [w.ptr_type(w.i32())], kernel=True) as f:
            (buffer,) = f.args
            lane = f.lane_id()
            wgid_y = f.workgroup_id(1)
            k = f.constant(w.i32(), 16)

            K = w.sym("K")
            wgid = w.sym("wgid_y")
            lid = w.sym("lid")

            # Uniform-only bindings -> result is `index`.
            _u = f.index_expr(K + wgid, {K: k, wgid: wgid_y})

            # Lane-varying binding pins the result to `!wave.simd<index, 32>`.
            off = f.index_expr(4 * lid + K, {K: k, lid: lane})

            _x = f.index_expr(w.xor(lid, w.sym_ctx.int_(31)), {lid: lane})

            # Zero bindings -> constant expression.
            _c = f.index_expr(w.sym_ctx.int_(42), {})

            ptrs = f.ptr_add(
                buffer,
                off,
                w.simd_type(w.ptr_type(w.i32())),
            )
            f.store(f.splat(f.constant(w.i32(), 0)), ptrs)
        # CHECK: func.func @index_expr_kernel
        # CHECK: wave.index_expr <"K + wgid_y"> ["K", "wgid_y"]
        # CHECK-SAME: -> index
        # CHECK: wave.index_expr <"K + 4*lid"> ["K", "lid"]
        # CHECK-SAME: -> !wave.simd<index, 32>
        # CHECK: wave.index_expr <"xor(31, lid)"> ["lid"]
        # CHECK-SAME: -> !wave.simd<index, 32>
        # CHECK: wave.index_expr <"42"> []()
        # CHECK-SAME: -> index
        # CHECK: wave.ptr_add {{.*}} !wave.simd<index, 32>
        print(m.module)


# CHECK-LABEL: TEST: test_mask_where
@run
def test_mask_where():
    with w.module() as m:
        with m.function(
            "where_kernel", [w.ptr_type(w.i32()), w.i32()], kernel=True
        ) as f:
            out, limit = f.args
            lane = f.lane_id()
            vlimit = f.splat(limit)
            active = f.cmpi("ult", lane, vlimit)
            ptrs = f.ptr_add(out, lane, w.simd_type(w.ptr_type(w.i32())))
            with f.where(active):
                f.store(lane, ptrs)
            bits = f.ballot(active)
            broadcast = f.read_first(lane)
            del bits, broadcast
        # CHECK: func.func @where_kernel
        # CHECK: [[LANE:%.*]] = wave.lane_id
        # CHECK: [[VLIM:%.*]] = wave.splat
        # CHECK: [[MASK:%.*]] = wave.cmpi ult [[LANE]], [[VLIM]]
        # CHECK-SAME: -> !wave.mask<32>
        # CHECK: wave.where [[MASK]] {
        # CHECK:   wave.store
        # CHECK: } : !wave.mask<32>
        # CHECK: wave.ballot [[MASK]] : !wave.mask<32> -> i32
        # CHECK: wave.read_first [[LANE]] : !wave.simd<i32, 32> -> i32
        print(m.module)


# CHECK-LABEL: TEST: test_float_mask
@run
def test_float_mask():
    with w.module() as m:
        with m.function("float_mask", [w.f32(), w.f32()]) as f:
            lhs, rhs = f.args
            vlhs = f.splat(lhs)
            vrhs = f.splat(rhs)
            mask = f.cmpf("ole", vlhs, vrhs)
            f.ballot(mask)
        # CHECK: [[LHS:%.*]] = wave.splat
        # CHECK: [[RHS:%.*]] = wave.splat
        # CHECK: [[MASK:%.*]] = wave.cmpf ole [[LHS]], [[RHS]]
        # CHECK-SAME: -> !wave.mask<32>
        # CHECK: wave.ballot [[MASK]]
        print(m.module)


# CHECK-LABEL: TEST: test_float_mask_uniform_vote
@run
def test_float_mask_uniform_vote():
    with w.module() as m:
        with m.function("float_mask_uniform_vote", [w.f32()]) as f:
            (limit,) = f.args
            lhs = f.splat(limit, width=64)
            rhs = f.splat(f.constant(w.f32(), 8.0), width=64)
            mask = f.cmpf("ole", lhs, rhs)
            bits = f.ballot(mask, w.i64())
            all_lanes = f.constant(w.i64(), -1)
            f.scalar_cmpi("eq", bits, all_lanes)
        # CHECK: wave.cmpf ole
        # CHECK: wave.ballot
        # CHECK: arith.cmpi eq
        print(m.module)


# CHECK-LABEL: TEST: test_mask_where_otherwise
@run
def test_mask_where_otherwise():
    with w.module() as m:
        with m.function("where_otherwise_kernel", [w.i32()], kernel=True) as f:
            (limit,) = f.args
            lane = f.lane_id()
            vlimit = f.splat(limit)
            active = f.cmpi("ult", lane, vlimit)
            with f.where(active, [w.simd_type(w.i32())]) as where:
                f.yield_([lane])
                with where.otherwise():
                    fallback = f.splat(f.constant(w.i32(), 7))
                    f.yield_([fallback])
            _selected = where.results[0]
        # CHECK: func.func @where_otherwise_kernel
        # CHECK: [[LANE:%.*]] = wave.lane_id
        # CHECK: [[VLIM:%.*]] = wave.splat
        # CHECK: [[MASK:%.*]] = wave.cmpi ult [[LANE]], [[VLIM]]
        # CHECK: [[SELECTED:%.*]] = wave.where [[MASK]] {
        # CHECK:   wave.yield [[LANE]]
        # CHECK: } otherwise {
        # CHECK:   [[FALLBACK:%.*]] = wave.splat
        # CHECK:   wave.yield [[FALLBACK]]
        # CHECK: } : !wave.mask<32> -> !wave.simd<i32, 32>
        print(m.module)


# CHECK-LABEL: TEST: test_uniform_if_otherwise
@run
def test_uniform_if_otherwise():
    with w.module() as m:
        with m.function("uniform_if_kernel", [], kernel=True) as f:
            cond = f.constant(w.i1(), 1)
            lhs = f.constant(w.i32(), 11)
            rhs = f.constant(w.i32(), 22)
            with f.if_(cond, [w.i32()], otherwise=True) as ifop:
                f.yield_([lhs])
                with ifop.otherwise():
                    f.yield_([rhs])
            _selected = ifop.results[0]
        # CHECK: func.func @uniform_if_kernel
        # CHECK: [[COND:%.*]] = arith.constant true
        # CHECK: [[LHS:%.*]] = arith.constant 11
        # CHECK: [[RHS:%.*]] = arith.constant 22
        # CHECK: [[SELECTED:%.*]] = scf.if [[COND]] -> (i32) {
        # CHECK:   scf.yield [[LHS]] : i32
        # CHECK: } else {
        # CHECK:   scf.yield [[RHS]] : i32
        # CHECK: }
        print(m.module)


# CHECK-LABEL: TEST: test_uniform_for_loop_nonzero_trip
@run
def test_uniform_for_loop_nonzero_trip():

    with w.module() as m:
        with m.function("loop_kernel", [w.ptr_type(w.i32())], kernel=True) as f:
            (_out,) = f.args
            lo = f.constant(w.i32(), 0)
            hi = f.constant(w.i32(), 8)
            step = f.constant(w.i32(), 1)
            with f.for_loop(lo, hi, step, nonzero_trip=True):
                pass
        # CHECK: func.func @loop_kernel
        # CHECK: scf.for {{.*}} : i32 {
        # CHECK: } {wave.nonzero_trip}
        print(m.module)


# CHECK-LABEL: TEST: test_uniform_for_loop_with_init_args
@run
def test_uniform_for_loop_with_init_args():
    with w.module() as m:
        with m.function("loop_carry_kernel", [w.ptr_type(w.i32())], kernel=True) as f:
            (_out,) = f.args
            lo = f.constant(w.i32(), 0)
            hi = f.constant(w.i32(), 4)
            step = f.constant(w.i32(), 1)
            init = f.constant(w.i32(), 7)
            with f.for_loop(lo, hi, step, init_args=(init,)) as forop:
                (acc,) = forop.inner_iter_args
                f.yield_([acc])
            _ = forop.results[0]
        # CHECK: func.func @loop_carry_kernel
        # CHECK: scf.for {{.*}} iter_args(%{{.+}} = %{{.+}}) -> (i32)  : i32 {
        # CHECK:   scf.yield {{.*}} : i32
        print(m.module)


# CHECK-LABEL: TEST: test_unrolled_for_loop_with_init_args
@run
def test_unrolled_for_loop_with_init_args():
    with w.module() as m:
        with m.function(
            "unrolled_loop_kernel", [w.ptr_type(w.i32())], kernel=True
        ) as f:
            (_out,) = f.args
            lo = f.constant(w.index_type(), 0)
            hi = f.constant(w.index_type(), 8)
            step = f.constant(w.index_type(), 1)
            init = f.constant(w.index_type(), 7)
            with f.for_loop(lo, hi, step, init_args=(init,), unroll=4) as loop:
                (acc,) = loop.inner_iter_args
                f.yield_([acc])
            _ = loop.results[0]
        # CHECK: func.func @unrolled_loop_kernel
        # CHECK: wavemeta.unrolled_for {{.*}} unroll {{.*}} iter_args(%{{.+}} : index)
        # CHECK:   wavemeta.yield {{.*}} : index
        print(m.module)
