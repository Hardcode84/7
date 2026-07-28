// RUN: not wave-opt %s \
// RUN:   --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_backend_lower})' \
// RUN:   > %t.mlir 2> %t.err
// RUN: FileCheck %s --check-prefix=ERR < %t.err
// RUN: not test -s %t.mlir

// ERR: 'waveamd.dma_load_lds' op gfx1250 does not support direct-to-LDS lowering
// ERR-NOT: waveamdmachine.{{global|buffer}}_load_lds

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"} {
func.func @gfx1250_rejects_direct_to_lds(
    %in: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel, wave.lds_size = 512 : i64} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %source = wave.ptr_add %in, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %destination = wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
  %root = wave.token : !wave.mem.token
  %loaded = waveamd.dma_load_lds %source -> %destination after %root
      {bytes = 16 : i64}
      : (!wave.simd<!wave.ptr<#wave.global, i32>, 32>,
         !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  return
}
}
