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

# CHECK: random-ref 1024 1024 1024
# CHECK-LABEL: func.func @wmma_f16_matmul_tiled
# CHECK-SAME: wave.lds_size = 2048
# CHECK: scf.for
# CHECK-COUNT-8: waveamd.mma "mfma.f32.16x16x16.f16"
# CHECK: wave.load
# CHECK-COUNT-4: waveamd.fragment_unpack
