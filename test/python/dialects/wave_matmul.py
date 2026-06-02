# RUN: %PYTHON %s | FileCheck %s

from mlir.dialects.wave_matmul import (
    build_wmma_f16_matmul_module,
    compute_wmma_f16_matmul_reference_buffer,
    generate_wmma_f16_matmul_inputs,
)

a0, b0 = generate_wmma_f16_matmul_inputs(32, 32, 32, random_data=True, random_seed=7)
a1, b1 = generate_wmma_f16_matmul_inputs(32, 32, 32, random_data=True, random_seed=7)
a2, _ = generate_wmma_f16_matmul_inputs(32, 32, 32, random_data=True, random_seed=8)
assert a0 == a1 and b0 == b1
assert a0 != a2
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

# CHECK: random-ref 1024 1024 1024
# CHECK: f16-ref-rounding -132.5625 -132.5
# CHECK-LABEL: func.func @wmma_f16_matmul_tiled
# CHECK-SAME: wave.lds_size = 2048
# CHECK-NOT: wavemeta.
# CHECK: %[[TRIP:.*]] = wave.assume_range %arg3, [0, 0] : i32
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
