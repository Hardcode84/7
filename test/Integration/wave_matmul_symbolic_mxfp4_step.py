# REQUIRES: wave-python-bindings
# RUN: %python %s | wave-opt - --verify-diagnostics | FileCheck %s

from mlir.dialects.wave_matmul import build_wmma_f16_matmul_module

module = build_wmma_f16_matmul_module(
    M=32,
    N=32,
    K=1024,
    BM=1,
    BN=1,
    wave_m_tiles=2,
    wave_n_tiles=2,
    wave_k_tiles=2,
    use_buffer=True,
    use_dma_lds=True,
    matrix_intrinsic="mfma_gfx950",
    input_type="mxfp4",
    output_type="f16",
    include_host=False,
)
print(module)

# CHECK-COUNT-3: wave.assume
# CHECK-NOT: wave.assume
# CHECK: scf.for
# CHECK: wave.index_expr <"2*__wave_dsl_mxfp4_step"> ["__wave_dsl_mxfp4_step"]
# CHECK: wave.index_expr <"1 + 2*__wave_dsl_mxfp4_step"> ["__wave_dsl_mxfp4_step"]
