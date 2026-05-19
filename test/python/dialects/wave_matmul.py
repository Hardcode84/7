# RUN: %PYTHON %s | FileCheck %s

from mlir.dialects.wave_matmul import build_wmma_f16_matmul_module

module = build_wmma_f16_matmul_module(
    M=32,
    N=32,
    K=32,
    wave_m_tiles=2,
    wave_n_tiles=2,
    matrix_intrinsic="mfma",
)
print(module)

# CHECK-LABEL: func.func @wmma_f16_matmul_tiled
# CHECK-SAME: wave.lds_size = 1024
# CHECK: scf.for
# CHECK-COUNT-4: waveamd.mma "mfma.f32.16x16x16.f16"
# CHECK: wave.load
# CHECK-COUNT-4: waveamd.fragment_store
