# RUN: %PYTHON %s | FileCheck %s

import mlir.dialects.wave_matmul as wm
from mlir.dialects import wave_dsl as dsl
from mlir.dialects.wave_matmul import (
    build_wmma_f16_matmul_module,
    compute_wmma_f16_matmul_reference_buffer,
    generate_mxfp4_packed_matmul_inputs,
    generate_mxfp4_scale_inputs,
    generate_wmma_f16_matmul_inputs,
)


def assert_raises(error_type, message, callback):
    try:
        callback()
    except error_type as exc:
        assert str(exc) == message
        return
    raise AssertionError(f"expected {error_type.__name__}: {message}")


def operation_blocks(operation):
    for region in operation.regions:
        for block in region.blocks:
            yield block
            for child in block.operations:
                yield from operation_blocks(child)


def normalized_mma_pairs(mmas):
    a_ids = {}
    b_ids = {}
    pairs = []
    for mma in mmas:
        a, b = mma.operands[:2]
        if a not in a_ids:
            a_ids[a] = len(a_ids)
        if b not in b_ids:
            b_ids[b] = len(b_ids)
        pairs.append((a_ids[a], b_ids[b]))
    return pairs


def serpentine_mma_pairs(a_count, b_count):
    pairs = []
    for j in range(b_count):
        rows = range(a_count) if j % 2 == 0 else reversed(range(a_count))
        pairs.extend((i, j) for i in rows)
    return pairs


def normalized_mma_groups(module, group_size):
    groups = []
    for block in operation_blocks(module.operation):
        mmas = [op for op in block.operations if op.name == "waveamd.mma"]
        if not mmas:
            continue
        assert len(mmas) % group_size == 0
        for begin in range(0, len(mmas), group_size):
            groups.append(normalized_mma_pairs(mmas[begin : begin + group_size]))
    return groups


def assert_serpentine_subpanel(module, a_count, b_count):
    serpentine = serpentine_mma_pairs(a_count, b_count)
    row_major = [(i, j) for i in range(a_count) for j in range(b_count)]
    groups = normalized_mma_groups(module, a_count * b_count)

    range_boundary = b_count
    assert groups == [
        row_major,
        serpentine,
        row_major,
        serpentine,
        row_major[:range_boundary] + serpentine[range_boundary:],
        serpentine,
    ]


subpanel_schedule = wm.PhasedDmaSchedule(
    issue_group_size=1,
    initial_delay_cycles=0,
    loop_delay_cycles=0,
    loop_overlap_cycles=0,
    delayed_waves=0,
    fetch_alignment=4,
    fetch_phase=0,
    subpanel_pipeline=True,
)
assert_raises(
    ValueError,
    "DMA subpanel pipeline requires two K32 phases",
    lambda: build_wmma_f16_matmul_module(
        M=16,
        N=16,
        K=32,
        wave_k_tiles=1,
        use_dma_lds=True,
        matrix_intrinsic="mfma_gfx950",
        phased_dma_schedule=subpanel_schedule,
    ),
)
assert_raises(
    ValueError,
    "DMA subpanel pipeline does not support packed MXFP4",
    lambda: build_wmma_f16_matmul_module(
        M=16,
        N=16,
        K=256,
        wave_k_tiles=2,
        use_dma_lds=True,
        matrix_intrinsic="mfma_gfx950",
        input_type="mxfp4",
        phased_dma_schedule=subpanel_schedule,
    ),
)
assert_raises(
    ValueError,
    "DMA subpanel pipeline requires at least two M tiles per wave",
    lambda: build_wmma_f16_matmul_module(
        M=16,
        N=16,
        K=128,
        wave_m_tiles=1,
        wave_n_tiles=1,
        wave_k_tiles=2,
        use_dma_lds=True,
        matrix_intrinsic="mfma_gfx950",
        phased_dma_schedule=subpanel_schedule,
    ),
)
print("subpanel-validation ok")

module_regular_subpanel = build_wmma_f16_matmul_module(
    M=64,
    N=64,
    K=128,
    BM=2,
    BN=2,
    wave_m_tiles=2,
    wave_n_tiles=2,
    wave_k_tiles=2,
    use_dma_lds=True,
    matrix_intrinsic="mfma_gfx950",
    phased_dma_schedule=subpanel_schedule,
    include_host=False,
)
assert "waveamd.dma_load_lds" in str(module_regular_subpanel)
print("regular-subpanel ok")

module_rectangular_subpanel = build_wmma_f16_matmul_module(
    M=32,
    N=48,
    K=128,
    BM=1,
    BN=1,
    wave_m_tiles=2,
    wave_n_tiles=3,
    wave_k_tiles=2,
    use_dma_lds=True,
    matrix_intrinsic="mfma_gfx950",
    phased_dma_schedule=subpanel_schedule,
    include_host=False,
)
assert_serpentine_subpanel(module_rectangular_subpanel, 2, 3)
print("rectangular-subpanel-serpentine ok")

assert_raises(
    ValueError,
    "coalesced MFMA output requires gfx950 f16 MFMA",
    lambda: build_wmma_f16_matmul_module(
        M=128,
        N=128,
        K=32,
        wave_m_tiles=8,
        wave_n_tiles=8,
        output_type="f16",
        coalesced_mfma_output=True,
    ),
)
module_coalesced = build_wmma_f16_matmul_module(
    M=256,
    N=256,
    K=64,
    BM=2,
    BN=2,
    wave_m_tiles=8,
    wave_n_tiles=8,
    wave_k_tiles=2,
    use_buffer=True,
    use_dma_lds=True,
    matrix_intrinsic="mfma_gfx950",
    output_type="f16",
    coalesced_mfma_output=True,
    include_host=False,
)
coalesced_text = str(module_coalesced)
assert coalesced_text.count("wave.pack") == 32
assert coalesced_text.count("!wave.simd<vector<8xf16>, 64>") >= 32
assert "!waveamd.fragment<0, f16, 16, 16, 64, 4>" in coalesced_text
assert "!waveamd.fragment<1, f16, 16, 16, 64, 4>" in coalesced_text
print("coalesced-mfma-output ok")

a0, b0 = generate_wmma_f16_matmul_inputs(32, 32, 32, random_data=True, random_seed=7)
a1, b1 = generate_wmma_f16_matmul_inputs(32, 32, 32, random_data=True, random_seed=7)
a2, _ = generate_wmma_f16_matmul_inputs(32, 32, 32, random_data=True, random_seed=8)
abf16, bbf16 = generate_wmma_f16_matmul_inputs(
    32, 32, 32, input_type="bf16", random_data=True, random_seed=7
)
assert a0 == a1 and b0 == b1
assert a0 != a2
assert len(abf16) == len(a0) and len(bbf16) == len(b0)
ref = compute_wmma_f16_matmul_reference_buffer(
    32,
    32,
    32,
    wave_m_tiles=2,
    wave_n_tiles=2,
    wave_k_tiles=2,
    random_data=True,
    random_seed=7,
    matrix_intrinsic="mfma",
)
print("random-ref", len(a0), len(b0), len(ref))
ref_bf16 = compute_wmma_f16_matmul_reference_buffer(
    16,
    16,
    32,
    matrix_intrinsic="mfma_gfx950",
    input_type="bf16",
)
print("bf16-ref", len(ref_bf16), ref_bf16[0])
mxfp4_scales = generate_mxfp4_scale_inputs(16, 16, 128)
print(
    "mxfp4-scales",
    len(mxfp4_scales[0]),
    len(mxfp4_scales[1]),
    mxfp4_scales[0][0],
    mxfp4_scales[1][-1],
)
ref_mxfp4 = compute_wmma_f16_matmul_reference_buffer(
    16,
    16,
    128,
    matrix_intrinsic="mfma_gfx950",
    input_type="mxfp4",
)
print("mxfp4-ref", len(ref_mxfp4), ref_mxfp4[0], ref_mxfp4[-1])
mxfp4_a0, mxfp4_b0 = generate_mxfp4_packed_matmul_inputs(16, 16, 128, random_seed=7)
mxfp4_a1, mxfp4_b1 = generate_mxfp4_packed_matmul_inputs(16, 16, 128, random_seed=7)
mxfp4_a2, _ = generate_mxfp4_packed_matmul_inputs(16, 16, 128, random_seed=8)
assert mxfp4_a0 == mxfp4_a1 and mxfp4_b0 == mxfp4_b1
assert mxfp4_a0 != mxfp4_a2
print("mxfp4-packed-random", len(mxfp4_a0), len(mxfp4_b0), mxfp4_a0[0], mxfp4_b0[-1])
ref_mxfp4_random = compute_wmma_f16_matmul_reference_buffer(
    16,
    16,
    128,
    random_data=True,
    random_seed=7,
    matrix_intrinsic="mfma_gfx950",
    input_type="mxfp4",
)
print(
    "mxfp4-random-ref", len(ref_mxfp4_random), ref_mxfp4_random[0], ref_mxfp4_random[-1]
)
ref_f32 = compute_wmma_f16_matmul_reference_buffer(
    16,
    16,
    512,
    random_data=True,
    random_seed=91,
    output_type="f32",
)
ref_f16 = compute_wmma_f16_matmul_reference_buffer(
    16,
    16,
    512,
    random_data=True,
    random_seed=91,
    output_type="f16",
)
assert ref_f32 != ref_f16
rounding_pair = next(
    pair for pair in zip(ref_f32, ref_f16, strict=True) if pair[0] != pair[1]
)
print("f16-ref-rounding", rounding_pair[0], rounding_pair[1])

module_mxfp4_random = build_wmma_f16_matmul_module(
    M=16,
    N=16,
    K=128,
    matrix_intrinsic="mfma_gfx950",
    input_type="mxfp4",
    random_data=True,
    random_seed=7,
)
assert "memref.store" in str(module_mxfp4_random)
print("mxfp4-random-module ok")

module = build_wmma_f16_matmul_module(
    M=32,
    N=32,
    K=32,
    wave_m_tiles=2,
    wave_n_tiles=2,
    wave_k_tiles=2,
    matrix_intrinsic="mfma",
    enable_multi_wave_specialization=True,
)
print(module)

module_f16 = build_wmma_f16_matmul_module(
    M=16,
    N=16,
    K=32,
    output_type="f16",
)
print(module_f16)

module_bf16 = build_wmma_f16_matmul_module(
    M=16,
    N=16,
    K=32,
    matrix_intrinsic="mfma_gfx950",
    input_type="bf16",
)
print(module_bf16)

module_mxfp4 = build_wmma_f16_matmul_module(
    M=32,
    N=32,
    K=256,
    wave_m_tiles=2,
    wave_n_tiles=2,
    wave_k_tiles=2,
    matrix_intrinsic="mfma_gfx950",
    input_type="mxfp4",
)
print("mxfp4-module")
print(module_mxfp4)

module_dynamic_lds = build_wmma_f16_matmul_module(
    M=64,
    N=64,
    K=64,
    BM=4,
    BN=4,
    wave_k_tiles=2,
    matrix_intrinsic="mfma_gfx950",
)
print("dynamic-lds-module")
print(module_dynamic_lds)

static_cfg = wm._make_matmul_config(
    M=16,
    N=16,
    K=32,
    BM=1,
    BN=1,
    wave_m_tiles=1,
    wave_n_tiles=1,
    wave_k_tiles=1,
    use_buffer=False,
    use_dma_lds=False,
    matrix_intrinsic="wmma",
    input_type="f16",
    output_type="f32",
    mxfp4_scale_path="dma",
    random_data=False,
    random_seed=0,
    cta_swizzle_xcds=1,
    cta_group_m=1,
)
static_bld = dsl.ModuleBuilder()
with static_bld:
    wm._declare_matmul_externals(static_bld, static_cfg)
    with static_bld.function(
        "static_matmul_kernel",
        wm._kernel_input_types(static_cfg, include_trip_count=False),
        kernel=True,
        lds_size=static_cfg.lds_bytes,
    ) as fb:
        wm._emit_kernel(fb, static_cfg)
    wm._attach_wavemeta_params(static_bld.module, static_cfg)
    dsl.specialize_wavemeta(static_bld.module)
static_text = str(static_bld.module)
static_signature = static_text.split("func.func @static_matmul_kernel", 1)[1].split(
    ")", 1
)[0]
assert "i32" not in static_signature
print(static_bld.module)

# CHECK: subpanel-validation ok
# CHECK: regular-subpanel ok
# CHECK: rectangular-subpanel-serpentine ok
# CHECK: coalesced-mfma-output ok
# CHECK: random-ref 1024 1024 1024
# CHECK: bf16-ref 256 32.0
# CHECK: mxfp4-scales 64 64 127 122
# CHECK: mxfp4-ref 256 42.5 21.25
# CHECK: mxfp4-packed-random 1024 1024 68 34
# CHECK: mxfp4-random-ref 256 92.703125 12.6484375
# CHECK: f16-ref-rounding -132.5625 -132.5
# CHECK: mxfp4-random-module ok
# CHECK-LABEL: func.func @wmma_f16_matmul_tiled
# CHECK-SAME: wave.lds_size = 2048
# CHECK-SAME: waveamdmachine.enable_multi_wave_specialization
# CHECK-NOT: wavemeta.
# CHECK: %[[TRIP:.*]] = wave.assume %arg3 as "x" {{\[.*\]}} : i32
# CHECK: scf.for %{{.*}} = %{{.*}} to %[[TRIP]] step
# CHECK-COUNT-8: waveamd.mma "mfma.f32.16x16x16.f16"
# CHECK: wave.load
# CHECK-COUNT-4: waveamd.fragment_unpack
# CHECK: func.func private @printMemrefF16
# CHECK: func.func @wmma_f16_matmul_tiled(%{{.*}}!wave.ptr<#wave.global, f16>
# CHECK: waveamd.fragment_unpack
# CHECK-SAME: !waveamd.fragment<2, f32, 16, 16, 32, 8> -> !wave.simd<vector<8xf32>, 32>
# CHECK: wave.cast fpconvert
# CHECK-SAME: !wave.simd<f32, 32> -> !wave.simd<f16, 32>
# CHECK: wave.pack
# CHECK-SAME: -> !wave.simd<vector<8xf16>, 32>
# CHECK: func.func private @wave_memref_to_ptr_global_bf16
# CHECK: func.func @wmma_f16_matmul_tiled(%{{.*}}!wave.ptr<#wave.global, bf16>
# CHECK: waveamd.mma "mfma.f32.16x16x32.bf16"
# CHECK: mxfp4-module
# CHECK: func.func private @wave_memref_to_ptr_global_i8
# CHECK: func.func @wmma_f16_matmul_tiled
# CHECK-SAME: !wave.ptr<#wave.global, i8>
# CHECK-SAME: !wave.ptr<#wave.global, i8>
# CHECK-SAME: !wave.ptr<#wave.global, f32>
# CHECK-SAME: !wave.ptr<#wave.global, i8>
# CHECK-SAME: !wave.ptr<#wave.global, i8>
# CHECK-SAME: i32
# CHECK: %{{.*}}, %{{.*}} = wave.load
# CHECK-SAME: !wave.ptr<#wave.global, i8>
# CHECK: %{{.*}}, %{{.*}} = wave.load
# CHECK-SAME: !wave.ptr<#wave.global, i8>
# CHECK: wave.shared_memory_base
# CHECK-SAME: !wave.ptr<#wave.shared, i8>
# CHECK: wave.load
# CHECK-SAME: -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
# CHECK: wave.store
# CHECK-SAME: !wave.simd<vector<16xi8>, 64>
# CHECK: wave.gather
# CHECK-SAME: mapping <bit_offset =
# CHECK-SAME: -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
# CHECK-COUNT-8: waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4"
# CHECK-SAME: !wave.simd<vector<8xi8>, 64>
# CHECK-SAME: !wave.simd<vector<8xi8>, 64>
# CHECK: dynamic-lds-module
# CHECK: attributes {gpu.kernel, gpu.known_block_size = array<i32: 1024, 1, 1>, wave.dynamic_lds_size = 65536 : i64, wave.kernel, wave.lds_size = 0 : i64, wave.workgroup_size = array<i32: 1024, 1, 1>}
# CHECK: arith.constant 65536 : i32
# CHECK: gpu.launch_func
# CHECK-SAME: dynamic_shared_memory_size
# CHECK-LABEL: func.func @static_matmul_kernel
# CHECK-SAME: wave.lds_size = 2048 : i64
# CHECK: %[[TRIP:.*]] = arith.constant 1 : i32
# CHECK: %[[ASSUME:.*]] = wave.assume %[[TRIP]] as "x" {{\[.*\]}} : i32
# CHECK: scf.for %{{.*}} = %{{.*}} to %[[ASSUME]] step
