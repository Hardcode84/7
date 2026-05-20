# RUN: %PYTHON %s | FileCheck %s

from mlir.dialects.wave_matmul import build_wmma_f16_matmul_module

module = build_wmma_f16_matmul_module(
    M=32,
    N=32,
    K=64,
    BM=2,
    BN=2,
    wave_k_tiles=2,
    matrix_intrinsic="mfma_gfx950",
    use_dma_lds=True,
)
print(module)

# CHECK-LABEL: func.func @wmma_f16_matmul_tiled
# CHECK-SAME: wave.lds_size = 16384
# CHECK: wave.read_first
# CHECK: waveamd.dma_load_lds
# CHECK: wave.wait
# CHECK: waveamd.mma "mfma.f32.16x16x32.f16"
