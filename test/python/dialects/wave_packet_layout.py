# RUN: %PYTHON %s | FileCheck %s

from mlir.dialects import wave_dsl as w


def run(function):
    print(f"\nTEST: {function.__name__}")
    function()


def assert_raises(error_type, message, callback):
    try:
        callback()
    except error_type as exc:
        assert str(exc) == message
        return
    raise AssertionError(f"expected {error_type.__name__}: {message}")


LANE_BASES = ((1,), (2,), (4,), (8,), (16,))
IDENTITY_LAYOUT = w.PacketLayout(
    32,
    (("x", 32),),
    (("lane", LANE_BASES),),
)
BROADCAST_SOURCE = w.PacketLayout(
    32,
    (("broadcast", 1), ("x", 32)),
    (("lane", tuple((0, value) for (value,) in LANE_BASES)),),
)
BROADCAST_RESULT = w.PacketLayout(
    32,
    (("broadcast", 2), ("x", 32)),
    (
        ("register", ((1, 0),)),
        ("lane", tuple((0, value) for (value,) in LANE_BASES)),
    ),
)
EXPAND_RESULT = w.PacketLayout(
    32,
    (("unit", 1), ("x", 32)),
    (("lane", tuple((0, value) for (value,) in LANE_BASES)),),
)
RESHAPE_SOURCE = w.PacketLayout(
    32,
    (("m", 4), ("n", 8)),
    (("lane", ((0, 1), (0, 2), (0, 4), (1, 0), (2, 0))),),
)
RESHAPE_RESULT = w.PacketLayout(
    32,
    (("m", 2), ("n", 16)),
    (("lane", ((1, 0), (0, 1), (0, 2), (0, 4), (0, 8))),),
)
TRANSPOSE_RESULT = w.PacketLayout(
    32,
    (("n", 8), ("m", 4)),
    (("lane", ((0, 1), (0, 2), (1, 0), (2, 0), (4, 0))),),
)
SPLIT_SOURCE = w.PacketLayout(
    32,
    (("x", 32), ("part", 2)),
    (
        ("register", ((0, 1),)),
        ("lane", tuple((value, 0) for (value,) in LANE_BASES)),
    ),
)
REGISTER_REDUCTION_SOURCE = w.PacketLayout(
    32,
    (("x", 32), ("reduce", 4)),
    (
        ("register", ((0, 1), (0, 2))),
        ("lane", tuple((value, 0) for (value,) in LANE_BASES)),
    ),
)
LANE_REDUCTION_SOURCE = w.PacketLayout(
    32,
    (("reduce", 2), ("x", 16)),
    (("lane", ((1, 0), (0, 1), (0, 2), (0, 4), (0, 8))),),
)
LANE_REDUCTION_RESULT = w.PacketLayout(
    32,
    (("x", 16),),
    (("lane", ((0,), (1,), (2,), (4,), (8,))),),
)
WAVE_REDUCTION_SOURCE = w.PacketLayout(
    32,
    (("reduce", 2), ("x", 32)),
    (
        ("lane", ((0, 1), (0, 2), (0, 4), (0, 8), (0, 16))),
        ("warp", ((1, 0),)),
    ),
)
WAVE_REDUCTION_RESULT = w.PacketLayout(
    32,
    (("x", 32),),
    (
        ("lane", ((1,), (2,), (4,), (8,), (16,))),
        ("warp", ((0,),)),
    ),
)


# CHECK-LABEL: TEST: test_packet_layout_transforms
@run
def test_packet_layout_transforms():
    with w.module() as module_builder:
        scalar = w.simd_type(w.i32(), width=32)
        pair = w.simd_type(w.vector_type(2, w.i32()), width=32)
        with module_builder.function(
            "packet_layout_transforms",
            [scalar, scalar, scalar, scalar, scalar, pair],
        ) as function_builder:
            identity, broadcast, expand, reshape, transpose, split = (
                function_builder.args
            )
            function_builder.redistribute_layout(
                identity,
                scalar,
                source_layout=IDENTITY_LAYOUT,
                result_layout=IDENTITY_LAYOUT,
            )
            function_builder.redistribute_layout(
                broadcast,
                pair,
                source_layout=BROADCAST_SOURCE,
                result_layout=BROADCAST_RESULT,
                transform=w.PacketTransform.broadcast(),
            )
            function_builder.redistribute_layout(
                expand,
                scalar,
                source_layout=IDENTITY_LAYOUT,
                result_layout=EXPAND_RESULT,
                transform=w.PacketTransform.expand_dims(0),
            )
            function_builder.redistribute_layout(
                reshape,
                scalar,
                source_layout=RESHAPE_SOURCE,
                result_layout=RESHAPE_RESULT,
                transform=w.PacketTransform.reshape(),
            )
            function_builder.redistribute_layout(
                transpose,
                scalar,
                source_layout=RESHAPE_SOURCE,
                result_layout=TRANSPOSE_RESULT,
                transform=w.PacketTransform.transpose((1, 0)),
            )
            function_builder.redistribute_layout(
                split,
                scalar,
                source_layout=SPLIT_SOURCE,
                result_layout=IDENTITY_LAYOUT,
                transform=w.PacketTransform.split(1),
            )

        # CHECK: func.func @packet_layout_transforms
        # CHECK: wave.redistribute {{.*}}source_slot = "slot"
        # CHECK: wave.redistribute {{.*}}source_slot = "0"
        # CHECK: wave.redistribute {{.*}}source_slot = "slot"
        # CHECK: wave.redistribute {{.*}}source_slot = "slot"
        # CHECK: wave.redistribute {{.*}}source_slot = "slot"
        # CHECK: wave.redistribute {{.*}}source_slot = "1"
        print(module_builder.module)

    normalized = w.PacketLayout(
        32,
        [["x", 32]],
        [["lane", [[1], [2], [4], [8], [16]]]],
    )
    assert normalized == IDENTITY_LAYOUT
    joined = w.join_packet_layout(IDENTITY_LAYOUT, normalized)
    assert joined.shape == (32, 2)
    assert joined.slot_count == 2
    assert w.PacketTransform.identity().kind == "identity"
    assert w.PacketTransform.expand_dims(0).axis == 0
    assert w.PacketTransform.transpose([1, 0]).order == (1, 0)
    assert w.PacketTransform.split(1).selector == 1
    assert "PacketLayout" in w.__all__
    assert "PacketTransform" in w.__all__
    assert "join_packet_layout" in w.__all__
    print("ok")
    # CHECK: ok


# CHECK-LABEL: TEST: test_packet_layout_reductions
@run
def test_packet_layout_reductions():
    with w.module() as module_builder:
        scalar = w.simd_type(w.i32(), width=32)
        register_source = w.simd_type(w.vector_type(4, w.i32()), width=32)
        with module_builder.function(
            "packet_layout_reduce_register",
            [register_source],
            workgroup_size=[32, 1, 1],
        ) as function_builder:
            with function_builder.reduce_layout(
                function_builder.args[0],
                scalar,
                source_layout=REGISTER_REDUCTION_SOURCE,
                result_layout=IDENTITY_LAYOUT,
                axis=1,
                associative=True,
                commutative=True,
            ) as reduction:
                lhs, rhs = reduction.arguments
                assert lhs.type == scalar
                assert rhs.type == scalar
                function_builder.yield_((function_builder.addi(lhs, rhs),))
            assert reduction.result.type == scalar

        with (
            module_builder.function(
                "packet_layout_reduce_lane",
                [scalar],
                workgroup_size=[32, 1, 1],
            ) as function_builder,
            function_builder.reduce_layout(
                function_builder.args[0],
                scalar,
                source_layout=LANE_REDUCTION_SOURCE,
                result_layout=LANE_REDUCTION_RESULT,
                axis=0,
            ) as reduction,
        ):
            lhs, rhs = reduction.arguments
            function_builder.yield_((function_builder.addi(lhs, rhs),))

        with (
            module_builder.function(
                "packet_layout_reduce_wave",
                [scalar],
                workgroup_size=[64, 1, 1],
                attrs={"wave.waves_per_workgroup": w.i64_attr(2)},
            ) as function_builder,
            function_builder.reduce_layout(
                function_builder.args[0],
                scalar,
                source_layout=WAVE_REDUCTION_SOURCE,
                result_layout=WAVE_REDUCTION_RESULT,
                axis=0,
            ) as reduction,
        ):
            lhs, rhs = reduction.arguments
            function_builder.yield_((function_builder.addi(lhs, rhs),))

        print(module_builder.module)

        w.PassManager.parse("builtin.module(wave-lower-redistribute)").run(
            module_builder.module.operation
        )
        print("LOWERED")
        print(module_builder.module)


# CHECK-LABEL: func.func @packet_layout_reduce_register
# CHECK: wave.reduce
# CHECK-SAME: using <blocks = 1, items = 32
# CHECK-SAME: source_block = "block"
# CHECK-SAME: source_item = "item"
# CHECK-SAME: source_slot = "xor(2*Mod(floor(1/2*reduction), 2), Mod(reduction, 2))"
# CHECK-SAME: extent 4 {associative, commutative}
# CHECK: ^bb0(%[[REGISTER_LHS:.*]]: !wave.simd<i32, 32>, %[[REGISTER_RHS:.*]]: !wave.simd<i32, 32>):
# CHECK: wave.binary addi %[[REGISTER_LHS]], %[[REGISTER_RHS]]
# CHECK: wave.yield
# CHECK-LABEL: func.func @packet_layout_reduce_lane
# CHECK: wave.reduce
# CHECK-SAME: using <blocks = 1, items = 32
# CHECK-SAME: source_block = "block"
# CHECK-SAME: source_item = "32*floor(1/32*item) + xor(Mod(reduction, 2)
# CHECK-SAME: xor(16*Mod(floor(1/16*Mod(item, 32)), 2)
# CHECK-SAME: xor(8*Mod(floor(1/8*Mod(item, 32)), 2)
# CHECK-SAME: xor(2*Mod(floor(1/2*Mod(item, 32)), 2), 4*Mod(floor(1/4*Mod(item, 32)), 2)))))"
# CHECK-SAME: source_slot = "slot"
# CHECK-SAME: extent 2
# CHECK-LABEL: func.func @packet_layout_reduce_wave
# CHECK: wave.reduce
# CHECK-SAME: using <blocks = 1, items = 64
# CHECK-SAME: source_block = "block"
# CHECK-SAME: source_item = "Mod(item, 32) + 32*Mod(reduction, 2)"
# CHECK-SAME: source_slot = "slot"
# CHECK-SAME: extent 2
# CHECK-LABEL: LOWERED
# CHECK-LABEL: func.func @packet_layout_reduce_register
# CHECK: wave.extract
# CHECK: wave.binary addi
# CHECK-NOT: wave.reduce
# CHECK-LABEL: func.func @packet_layout_reduce_lane
# CHECK: wave.shuffle
# CHECK: wave.binary addi
# CHECK-NOT: wave.reduce
# CHECK-LABEL: func.func @packet_layout_reduce_wave
# CHECK: wave.alloc
# CHECK: wave.store
# CHECK: wave.barrier
# CHECK: wave.load
# CHECK: wave.join
# CHECK: wave.alloc_release
# CHECK: wave.binary addi
# CHECK-NOT: wave.reduce


def check_packet_layout_diagnostics():
    assert_raises(
        TypeError,
        "packet layout lane width must be an integer",
        lambda: w.PacketLayout(32.5, (("x", 32),), (("lane", LANE_BASES),)),
    )
    assert_raises(
        ValueError,
        "packet layout lane width must be a positive power of two",
        lambda: w.PacketLayout(24, (("x", 32),), (("lane", LANE_BASES),)),
    )
    assert_raises(
        ValueError,
        "packet layout tensor dimensions must be named positive powers of two",
        lambda: w.PacketLayout(1, (("x", 3),), ()),
    )
    assert_raises(
        ValueError,
        "packet layout tensor dimension names must be unique",
        lambda: w.PacketLayout(
            32,
            (("x", 32), ("x", 1)),
            (("lane", tuple((value, 0) for (value,) in LANE_BASES)),),
        ),
    )
    assert_raises(
        ValueError,
        "packet layout has an unsupported input dimension",
        lambda: w.PacketLayout(1, (("x", 1),), (("thread", ()),)),
    )
    assert_raises(
        ValueError,
        "packet layout basis rank does not match its tensor rank",
        lambda: w.PacketLayout(1, (("x", 1),), (("lane", ((0, 0),)),)),
    )
    assert_raises(
        ValueError,
        "packet layout lane domain does not match its lane width",
        lambda: w.PacketLayout(32, (("x", 32),), (("lane", LANE_BASES[:-1]),)),
    )


def check_packet_transform_diagnostics():
    assert_raises(
        ValueError,
        "unsupported packet transform 'unknown'",
        lambda: w.PacketTransform("unknown"),
    )
    assert_raises(
        ValueError,
        "identity packet transform takes no parameters",
        lambda: w.PacketTransform(axis=0),
    )
    assert_raises(
        ValueError,
        "transpose packet transform order must be a permutation",
        lambda: w.PacketTransform.transpose((0, 0)),
    )
    assert_raises(
        ValueError,
        "split packet transform requires selector 0 or 1",
        lambda: w.PacketTransform.split(2),
    )
    other_layout = w.PacketLayout(
        32,
        (("x", 32),),
        (("lane", ((2,), (1,), (4,), (8,), (16,))),),
    )
    assert_raises(
        ValueError,
        "joined packet operands must have identical layouts",
        lambda: w.join_packet_layout(IDENTITY_LAYOUT, other_layout),
    )


def check_packet_relation_diagnostics():
    nontotal_source = w.PacketLayout(
        32,
        (("x", 2),),
        (("lane", ((0,), (0,), (0,), (0,), (0,))),),
    )
    nontotal_result = w.PacketLayout(
        32,
        (("x", 2),),
        (("lane", ((1,), (0,), (0,), (0,), (0,))),),
    )
    incompatible_shape = w.PacketLayout(
        32,
        (("x", 64),),
        (("lane", LANE_BASES),),
    )
    wide_layout = w.PacketLayout(
        64,
        (("x", 64),),
        (("lane", ((1,), (2,), (4,), (8,), (16,), (32,))),),
    )
    with w.module() as module_builder:
        scalar = w.simd_type(w.i32(), width=32)
        pair = w.simd_type(w.vector_type(2, w.i32()), width=32)
        wide = w.simd_type(w.i32(), width=64)
        fp = w.simd_type(w.f32(), width=32)
        with module_builder.function("packet_layout_diagnostics", [scalar, wide]) as f:
            scalar_value, wide_value = f.args

            def redistribute(result_type, source_layout, result_layout, **kwargs):
                return f.redistribute_layout(
                    scalar_value,
                    result_type,
                    source_layout=source_layout,
                    result_layout=result_layout,
                    **kwargs,
                )

            assert_raises(
                ValueError,
                "packet layouts do not define a total redistribution",
                lambda: redistribute(scalar, nontotal_source, nontotal_result),
            )
            assert_raises(
                ValueError,
                "broadcast packet transform has incompatible shapes",
                lambda: redistribute(
                    scalar,
                    IDENTITY_LAYOUT,
                    incompatible_shape,
                    transform=w.PacketTransform.broadcast(),
                ),
            )
            assert_raises(
                ValueError,
                "result slot count does not match its packet layout",
                lambda: redistribute(pair, IDENTITY_LAYOUT, IDENTITY_LAYOUT),
            )
            assert_raises(
                ValueError,
                "source SIMD width does not match its packet layout",
                lambda: f.redistribute_layout(
                    wide_value,
                    scalar,
                    source_layout=IDENTITY_LAYOUT,
                    result_layout=IDENTITY_LAYOUT,
                ),
            )
            assert_raises(
                ValueError,
                "source and result packet element types must match",
                lambda: redistribute(fp, IDENTITY_LAYOUT, IDENTITY_LAYOUT),
            )
            assert_raises(
                ValueError,
                "packet redistribution changes its hardware domain",
                lambda: redistribute(wide, IDENTITY_LAYOUT, wide_layout),
            )


def check_packet_reduction_diagnostics():
    with w.module() as module_builder:
        scalar = w.simd_type(w.i32(), width=32)
        source_type = w.simd_type(w.vector_type(4, w.i32()), width=32)
        with module_builder.function(
            "packet_reduction_diagnostics", [source_type]
        ) as function_builder:
            source = function_builder.args[0]

            def reduce(axis, result_layout=IDENTITY_LAYOUT):
                return function_builder.reduce_layout(
                    source,
                    scalar,
                    source_layout=REGISTER_REDUCTION_SOURCE,
                    result_layout=result_layout,
                    axis=axis,
                )

            def enter_reduce(axis):
                with reduce(axis):
                    pass

            assert_raises(
                TypeError,
                "packet reduction axis must be an integer",
                lambda: enter_reduce(1.5),
            )
            assert_raises(
                ValueError,
                "packet reduction axis is out of range",
                lambda: enter_reduce(2),
            )
            assert_raises(
                ValueError,
                "packet reduction result shape does not remove its source axis",
                lambda: enter_reduce(0),
            )

            def missing_yield():
                with reduce(1):
                    pass

            assert_raises(
                RuntimeError,
                "wave.reduce combiner must end with wave.yield",
                missing_yield,
            )

            def empty_yield():
                with reduce(1):
                    function_builder.yield_()

            assert_raises(
                RuntimeError,
                "wave.reduce combiner must yield one value of its argument type",
                empty_yield,
            )


# CHECK-LABEL: TEST: test_packet_layout_diagnostics
@run
def test_packet_layout_diagnostics():
    check_packet_layout_diagnostics()
    check_packet_transform_diagnostics()
    check_packet_relation_diagnostics()
    check_packet_reduction_diagnostics()
    print("ok")
    # CHECK: ok
