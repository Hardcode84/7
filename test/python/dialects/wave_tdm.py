# RUN: %PYTHON %s | FileCheck %s

from mlir.dialects import wave_dsl as w


def run(test):
    print("\nTEST:", test.__name__)
    test()


def assert_raises(error_type, message, callback):
    try:
        callback()
    except error_type as exc:
        assert str(exc) == message
        return
    raise AssertionError(f"expected {error_type.__name__}: {message}")


# CHECK-LABEL: TEST: test_pack_d2_descriptor
@run
def test_pack_d2_descriptor():
    descriptor = w.pack_gfx1250_tdm_descriptor(
        (1 << 57) - 1 - 0x820,
        [64, 128],
        [128, 1],
        [32, 64],
        element_bit_width=16,
        offsets=[8, 16],
        lds_address=0x400,
    )
    assert descriptor.kind is w.TDMDescriptorKind.D2
    assert descriptor.groups == (
        (1, 0x400, 0xFFFFFFFF, 0x81FFFFFF),
        (
            0x00010000,
            0x00700000,
            0x00380000,
            0x00400000,
            0x00000020,
            0x00000080,
            0,
            0,
        ),
    )
    print("packed d2")


# CHECK-LABEL: TEST: test_pack_d4_descriptor
@run
def test_pack_d4_descriptor():
    descriptor = w.pack_gfx1250_tdm_descriptor(
        0x1000,
        [2, 3, 4, 5, 6],
        [360, 120, 30, 6, 1],
        [2, 3, 4, 5, 6],
        element_bit_width=32,
    )
    assert descriptor.kind is w.TDMDescriptorKind.D4
    assert descriptor.groups == (
        (1, 0, 0x1000, 0x80000000),
        (
            0x00020000,
            0x00060000,
            0x00050000,
            0x00060000,
            0x00040005,
            6,
            0x001E0000,
            0,
        ),
        (4, 3, 120, 0x00030000),
        (360, 0x00020000, 0x00020000, 0),
    )
    print("packed d4")


# CHECK-LABEL: TEST: test_pack_padded_descriptors
@run
def test_pack_padded_descriptors():
    kwargs = {
        "global_address": 0x123456780000,
        "shape": [64, 128],
        "strides": [128, 1],
        "block_shape": [32, 64],
        "element_bit_width": 16,
        "offsets": [8, 16],
        "lds_address": 0x400,
        "padding": (64, 8),
    }
    load = w.pack_gfx1250_tdm_descriptor(**kwargs, is_store=False)
    store = w.pack_gfx1250_tdm_descriptor(**kwargs, is_store=True)
    assert load.groups == (
        (1, 0x400, 0x56780820, 0x80001234),
        (
            0x07110000,
            0x00700000,
            0x00380000,
            0x00400000,
            0x00000020,
            0x00000080,
            0,
            0,
        ),
    )
    assert store.groups == (
        (1, 0x400, 0x56780820, 0x80001234),
        (
            0x07110000,
            0x00400000,
            0x00380000,
            0x00480000,
            0x00000020,
            0x00000080,
            0,
            0,
        ),
    )
    print("packed padded load and store")


# CHECK-LABEL: TEST: test_enum_stringifiers
@run
def test_enum_stringifiers():
    assert str(w.TDMDescriptorKind.D2) == "d2"
    assert str(w.TDMDescriptorKind.D4) == "d4"
    assert str(w.TDMPrefetchMode.Regular) == "regular"
    assert str(w.TDMPrefetchMode.Speculative) == "speculative"
    print("enum stringifiers")


# CHECK-LABEL: TEST: test_tdm_d2_builders
@run
def test_tdm_d2_builders():
    with w.module() as m:
        with m.function(
            "tdm_d2_builders",
            [w.simd_type(w.i32())],
            kernel=True,
        ) as f:
            (byte_offset,) = f.args
            dependency = f.token()
            descriptor = f.gfx1250_tdm_descriptor(
                0x1000,
                [8, 16],
                [16, 1],
                [8, 16],
                element_bit_width=16,
            )
            loaded = f.tdm_load(descriptor, after=dependency)
            prefetched = f.tdm_prefetch(
                descriptor,
                byte_offset,
                after=loaded,
            )
            f.tdm_store(descriptor, after=prefetched)

        # CHECK: [[D2_DEP:%.*]] = wave.token
        # CHECK: [[D2_LOAD:%.*]] = waveamd.tdm_load d2 [[D2_D0:%.*]], [[D2_D1:%.*]] after [[D2_DEP]]
        # CHECK: [[D2_PREFETCH:%.*]] = waveamd.tdm_prefetch regular [[D2_D0]], %arg0 after [[D2_LOAD]]
        # CHECK: waveamd.tdm_store d2 [[D2_D0]], [[D2_D1]] after [[D2_PREFETCH]]
        assert m.module.operation.verify()
        print(m.module)


# CHECK-LABEL: TEST: test_tdm_d4_builders_and_select
@run
def test_tdm_d4_builders_and_select():
    second_words = w.pack_gfx1250_tdm_descriptor(
        0x2000,
        [4, 8, 16],
        [128, 16, 1],
        [4, 8, 16],
        element_bit_width=16,
    )
    with w.module() as m:
        with m.function(
            "tdm_builders",
            [w.i1(), w.simd_type(w.i32())],
            kernel=True,
        ) as f:
            condition, byte_offset = f.args
            dependency = f.token()
            first = f.gfx1250_tdm_descriptor(
                0x1000,
                [4, 8, 16],
                [128, 16, 1],
                [4, 8, 16],
                element_bit_width=16,
            )
            second = second_words.materialize(f)
            selected = f.tdm_select(condition, first, second)
            loaded = f.tdm_load(selected, after=dependency)
            stored = f.tdm_store(selected, after=loaded)
            f.tdm_prefetch(
                selected,
                byte_offset,
                after=stored,
                mode=w.TDMPrefetchMode.Speculative,
            )

        # CHECK: [[DEP:%.*]] = wave.token
        # CHECK: [[D0:%.*]] = wave.select {{.*}} : vector<4xi32>
        # CHECK: [[D1:%.*]] = wave.select {{.*}} : vector<8xi32>
        # CHECK: [[D2:%.*]] = wave.select {{.*}} : vector<4xi32>
        # CHECK: [[D3:%.*]] = wave.select {{.*}} : vector<4xi32>
        # CHECK: [[LOAD:%.*]] = waveamd.tdm_load d4 [[D0]], [[D1]], [[D2]], [[D3]] after [[DEP]]
        # CHECK: [[STORE:%.*]] = waveamd.tdm_store d4 [[D0]], [[D1]], [[D2]], [[D3]] after [[LOAD]]
        # CHECK: waveamd.tdm_prefetch speculative [[D0]], %arg1 after [[STORE]]
        assert m.module.operation.verify()
        print(m.module)


# CHECK-LABEL: TEST: test_dynamic_descriptor_builder
@run
def test_dynamic_descriptor_builder():
    with w.module() as m:
        with m.function("dynamic_descriptor", [w.i64()], kernel=True) as f:
            (address,) = f.args
            descriptor = f.gfx1250_tdm_descriptor(
                address,
                [16, 32],
                [128, 1],
                [16, 32],
                element_bit_width=16,
                lds_address=1024,
            )
            f.tdm_load(descriptor, after=f.token())

        # CHECK: [[LOW:%.*]] = wave.cast intconvert %arg0 : i64 -> i32
        # CHECK: [[SHIFTED:%.*]] = wave.binary shrui %arg0, {{.*}} : i64, i64 -> i64
        # CHECK: [[HIGH:%.*]] = wave.cast intconvert [[SHIFTED]] : i64 -> i32
        # CHECK: [[HIGH_MASKED:%.*]] = wave.binary andi [[HIGH]], {{.*}} : i32, i32 -> i32
        # CHECK: [[HIGH_VALID:%.*]] = wave.binary ori [[HIGH_MASKED]], {{.*}} : i32, i32 -> i32
        # CHECK: [[D0:%.*]] = wave.pack {{.*}}, {{.*}}, [[LOW]], [[HIGH_VALID]] : i32, i32, i32, i32 -> vector<4xi32>
        # CHECK: waveamd.tdm_load d2 [[D0]],
        assert m.module.operation.verify()
        print(m.module)


# CHECK-LABEL: TEST: test_dynamic_index_descriptor_builder
@run
def test_dynamic_index_descriptor_builder():
    with w.module() as m:
        with m.function("dynamic_index_descriptor", [w.index_type()]) as f:
            (address,) = f.args
            descriptor = f.gfx1250_tdm_descriptor(
                address,
                [16, 32],
                [128, 1],
                [16, 32],
                element_bit_width=16,
            )
            f.tdm_load(descriptor, after=f.token())

        # CHECK: [[LOW:%.*]] = wave.cast intconvert %arg0 : index -> i32
        # CHECK: [[SHIFTED:%.*]] = wave.binary shrui %arg0, {{.*}} : index, index -> index
        # CHECK: wave.cast intconvert [[SHIFTED]] : index -> i32
        assert m.module.operation.verify()
        print(m.module)


# CHECK-LABEL: TEST: test_intconvert_extension_builder
@run
def test_intconvert_extension_builder():
    with w.module() as m:
        with m.function("intconvert_extension", [w.i32()]) as f:
            (value,) = f.args
            f.intconvert(value, w.i64(), extension=w.CastExtension.Zero)

        # CHECK: wave.cast intconvert %arg0 policy {extension = #wave.cast_extension<zero>} : i32 -> i64
        assert m.module.operation.verify()
        print(m.module)


# CHECK-LABEL: TEST: test_static_descriptor_errors
@run
def test_static_descriptor_errors():
    assert_raises(
        ValueError,
        "global_address must fit 57 bits",
        lambda: w.pack_gfx1250_tdm_descriptor(
            1 << 57,
            [4],
            [1],
            [4],
            element_bit_width=16,
        ),
    )
    assert_raises(
        ValueError,
        "offset global address must fit 57 bits",
        lambda: w.pack_gfx1250_tdm_descriptor(
            (1 << 57) - 1,
            [4],
            [1],
            [4],
            element_bit_width=8,
            offsets=[1],
        ),
    )
    assert_raises(
        ValueError,
        "static TDM descriptors require one issuing wave",
        lambda: w.pack_gfx1250_tdm_descriptor(
            0,
            [4],
            [1],
            [4],
            element_bit_width=16,
            num_warps=2,
        ),
    )
    assert_raises(
        ValueError,
        "padded TDM descriptors require is_store",
        lambda: w.pack_gfx1250_tdm_descriptor(
            0,
            [4],
            [1],
            [4],
            element_bit_width=16,
            padding=(64, 8),
        ),
    )
    assert_raises(
        ValueError,
        "padded TDM store requires padding interval to equal innermost block dimension",
        lambda: w.pack_gfx1250_tdm_descriptor(
            0,
            [64],
            [1],
            [64],
            element_bit_width=16,
            padding=(32, 8),
            is_store=True,
        ),
    )
    non_power_of_two_padding = w.pack_gfx1250_tdm_descriptor(
        0,
        [64],
        [1],
        [64],
        element_bit_width=16,
        padding=(64, 6),
        is_store=False,
    )
    assert non_power_of_two_padding.d1[0] >> 25 & 0x7F == 2
    with w.module() as m, m.function("dynamic_errors", [w.i32()]) as f:
        (address,) = f.args
        assert_raises(
            TypeError,
            "dynamic TDM address must be uniform i64 or index",
            lambda: f.gfx1250_tdm_descriptor(
                address,
                [16, 32],
                [32, 1],
                [16, 32],
                element_bit_width=16,
            ),
        )
        address64 = f.constant(w.i64(), 0)
        assert_raises(
            ValueError,
            "dynamic TDM descriptor offsets must be folded into global_address",
            lambda: f.gfx1250_tdm_descriptor(
                address64,
                [16, 32],
                [32, 1],
                [16, 32],
                element_bit_width=16,
                offsets=[1, 0],
            ),
        )
    print("static errors")


# CHECK-LABEL: TEST: test_raw_descriptor_validation
@run
def test_raw_descriptor_validation():
    assert_raises(
        ValueError,
        "d0 must contain 4 dwords",
        lambda: w.TDMDescriptorWords((0,) * 3, (0,) * 8),
    )
    assert_raises(
        ValueError,
        "d2 and d3 must both be present or absent",
        lambda: w.TDMDescriptorWords((0,) * 4, (0,) * 8, (0,) * 4),
    )
    print("raw validation")


# CHECK-LABEL: TEST: test_raw_descriptor_builder
@run
def test_raw_descriptor_builder():
    with w.module() as m:
        with m.function(
            "raw_descriptor_builder",
            [
                w.vector_type(4, w.i32()),
                w.vector_type(8, w.i32()),
                w.vector_type(4, w.i32()),
                w.vector_type(4, w.i32()),
            ],
        ) as f:
            descriptor = w.TDMDescriptor.from_groups(f.args)
            dependency = f.token()
            f.tdm_load(descriptor, after=dependency)

        # CHECK: waveamd.tdm_load d4 %arg0, %arg1, %arg2, %arg3
        assert m.module.operation.verify()
        print(m.module)


# CHECK-LABEL: TEST: test_tdm_select_mismatch
@run
def test_tdm_select_mismatch():
    d2 = w.TDMDescriptorWords((0,) * 4, (0,) * 8)
    d4 = w.TDMDescriptorWords((0,) * 4, (0,) * 8, (0,) * 4, (0,) * 4)
    with w.module() as m:
        with m.function("tdm_select_mismatch", [w.i1()]) as f:
            (condition,) = f.args
            assert_raises(
                ValueError,
                "tdm_select requires matching descriptor forms",
                lambda: f.tdm_select(condition, d2, d4),
            )

        assert "wave.select" not in str(m.module)
        assert m.module.operation.verify()
    print("mismatch rejected")


# CHECK-LABEL: TEST: test_tdm_select_lane_mask
@run
def test_tdm_select_lane_mask():
    descriptor = w.TDMDescriptorWords((0,) * 4, (0,) * 8)
    with w.module() as m:
        with m.function("tdm_select_lane_mask", [w.mask_type()]) as f:
            (condition,) = f.args
            assert_raises(
                TypeError,
                "tdm_select condition must be uniform i1",
                lambda: f.tdm_select(condition, descriptor, descriptor),
            )

        assert "wave.select" not in str(m.module)
        assert m.module.operation.verify()
    print("lane mask rejected")
