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
# CHECK-SAME: wave.lds_size = 0
# CHECK-COUNT-2: wave.alloc() {align = 16 : i64, bytesize = 4096 : i64}
# CHECK: wave.read_first
# CHECK-COUNT-2: waveamd.dma_load_lds
# CHECK: wave.barrier
# CHECK: waveamd.mma "mfma.f32.16x16x32.f16"
