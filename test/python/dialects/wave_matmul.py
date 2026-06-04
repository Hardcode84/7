# RUN: %PYTHON %s | FileCheck %s

from mlir.dialects.wave_matmul import (
    build_wmma_f16_matmul_module,
    compute_wmma_f16_matmul_reference_buffer,
    generate_mxfp4_scale_inputs,
    generate_wmma_f16_matmul_inputs,
)

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

module = build_wmma_f16_matmul_module(
    M=32,
    N=32,
    K=32,
    wave_m_tiles=2,
    wave_n_tiles=2,
    wave_k_tiles=2,
    matrix_intrinsic="mfma",
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
    K=128,
    wave_m_tiles=2,
    wave_n_tiles=2,
    matrix_intrinsic="mfma_gfx950",
    input_type="mxfp4",
)
print(module_mxfp4)

# CHECK: random-ref 1024 1024 1024
# CHECK: bf16-ref 256 32.0
# CHECK: mxfp4-scales 64 64 127 122
# CHECK: mxfp4-ref 256 42.5 21.25
# CHECK: f16-ref-rounding -132.5625 -132.5
# CHECK-LABEL: func.func @wmma_f16_matmul_tiled
# CHECK-SAME: wave.lds_size = 2048
# CHECK-NOT: wavemeta.
# CHECK: %[[TRIP:.*]] = wave.assume %arg3 as "x" {{\[.*\]}} : i32
# CHECK: scf.for %{{.*}} = %{{.*}} to %[[TRIP]] step
# CHECK-COUNT-8: waveamd.mma "mfma.f32.16x16x16.f16"
# CHECK: wave.load
# CHECK-COUNT-4: waveamd.fragment_unpack
# CHECK: func.func private @printMemrefF16
# CHECK: func.func @wmma_f16_matmul_tiled
# CHECK-SAME: !wave.ptr<#wave.global, f16>
# CHECK: waveamd.fragment_unpack
# CHECK-SAME: !waveamd.fragment<2, f32, 16, 16, 32, 8> -> !wave.simd<vector<8xf32>, 32>
# CHECK: wave.cast fpconvert
# CHECK-SAME: !wave.simd<f32, 32> -> !wave.simd<f16, 32>
# CHECK: wave.pack
# CHECK-SAME: -> !wave.simd<vector<2xf16>, 32>
# CHECK: func.func private @wave_memref_to_ptr_global_bf16
# CHECK: func.func @wmma_f16_matmul_tiled
# CHECK-SAME: !wave.ptr<#wave.global, bf16>
# CHECK: waveamd.mma "mfma.f32.16x16x32.bf16"
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
# CHECK-COUNT-4: waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4"
# CHECK-SAME: !wave.simd<i32, 64>
# CHECK-SAME: !wave.simd<i32, 64>
