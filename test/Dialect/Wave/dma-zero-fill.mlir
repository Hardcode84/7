// RUN: wave-opt --waveamd-dma-zero-fill %s | FileCheck %s --check-prefix=ZF

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// ZF-LABEL: func.func @loop_carried_buffer_dma_zero_fill
// ZF-NOT: wave.where
// ZF: [[OOB:%.*]] = wave.ptr_add {{%.*}}, {{%.*}} : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
// ZF: [[OOB_CAST:%.*]] = wave.ptr_cast [[OOB]]
// ZF: [[SELECT:%.*]] = wave.select {{%.*}}, {{%.*}}, [[OOB_CAST]]
// ZF: waveamd.dma_load_lds [[SELECT]]
func.func @loop_carried_buffer_dma_zero_fill(
    %src: !wave.ptr<#wave.global, f16>,
    %limit_raw: i32)
    attributes {wave.kernel, waveamdmachine.lds_size = 512 : i64} {
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  %c2 = arith.constant 2 : index
  %c64 = arith.constant 64 : index
  %range = arith.constant 1024 : i32
  %buffer = waveamd.make_buffer %src, %range
      : !wave.ptr<#wave.global, f16>, i32 -> !wave.ptr<#waveamd.buffer, f16>
  %lane = wave.workitem_id 0 : !wave.simd<i32, 64>
  %source = wave.ptr_add %buffer, %lane
      : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
  %dest = wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
  %tok0 = wave.token : !wave.mem.token
  %limit = wave.splat %limit_raw : i32 -> !wave.simd<i32, 64>
  %cond = wave.cmpi slt %lane, %limit
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  %result:2 = scf.for %i = %c0 to %c2 step %c1
      iter_args(%carried_src = %source, %tok = %tok0)
      -> (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.mem.token) {
    %next_tok = wave.where %cond {
      %dma_tok = waveamd.dma_load_lds %carried_src -> %dest after %tok
          {bytes = 16 : i64, zero_fill_inactive}
          : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>,
             !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      wave.yield %dma_tok : !wave.mem.token
    } : !wave.mask<64> -> !wave.mem.token
    %next_src = wave.ptr_add %carried_src, %c64
        : !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, index
        -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
    scf.yield %next_src, %next_tok
        : !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.mem.token
  }
  return
}

}
