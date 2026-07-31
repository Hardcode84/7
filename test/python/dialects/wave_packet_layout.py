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


# CHECK-LABEL: TEST: test_packet_layout_diagnostics
@run
def test_packet_layout_diagnostics():
    check_packet_layout_diagnostics()
    check_packet_transform_diagnostics()
    check_packet_relation_diagnostics()
    print("ok")
    # CHECK: ok
