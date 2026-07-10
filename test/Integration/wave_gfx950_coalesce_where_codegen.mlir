// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_backend})' \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm - \
// RUN:   | FileCheck %s --check-prefix=ASM
// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_backend})' \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm - \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// ASM-LABEL: coalesce_where_codegen:
// ASM: s_and_saveexec_b64
// ASM: buffer_store_dword
// ASM: buffer_store_dword
// ASM: buffer_store_dword
// ASM-NOT: s_and_saveexec_b64
// ASM: s_endpgm
func.func @coalesce_where_codegen(
    %out0: !wave.ptr<#wave.global, i32>,
    %out1: !wave.ptr<#wave.global, i32>,
    %out2: !wave.ptr<#wave.global, i32>,
    %limit: i32) attributes {wave.kernel} {
  %one = arith.constant 1 : i32
  %range = arith.constant 4096 : i32
  %buffer0 = waveamd.make_buffer %out0, %range
      : !wave.ptr<#wave.global, i32>, i32
      -> !wave.ptr<#waveamd.buffer, i32>
  %buffer1 = waveamd.make_buffer %out1, %range
      : !wave.ptr<#wave.global, i32>, i32
      -> !wave.ptr<#waveamd.buffer, i32>
  %buffer2 = waveamd.make_buffer %out2, %range
      : !wave.ptr<#wave.global, i32>, i32
      -> !wave.ptr<#waveamd.buffer, i32>
  %lane = wave.lane_id : !wave.simd<i32, 64>
  %vlimit = wave.splat %limit : i32 -> !wave.simd<i32, 64>
  %active = wave.cmpi ult %lane, %vlimit
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  %ptr0 = wave.ptr_add %buffer0, %lane
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
  %ptr1 = wave.ptr_add %buffer1, %lane
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
  %token0, %token1 = wave.where %active {
    %stored0 = wave.store %lane -> %ptr0
        : (!wave.simd<i32, 64>,
           !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>)
        -> !wave.mem.token
    %stored1 = wave.store %lane -> %ptr1 after %stored0
        : (!wave.simd<i32, 64>,
           !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
           !wave.mem.token) -> !wave.mem.token
    wave.yield %stored0, %stored1 : !wave.mem.token, !wave.mem.token
  } : !wave.mask<64> -> !wave.mem.token, !wave.mem.token
  %vone = wave.splat %one : i32 -> !wave.simd<i32, 64>
  %next = wave.binary addi %lane, %vone
      : !wave.simd<i32, 64>, !wave.simd<i32, 64>
      -> !wave.simd<i32, 64>
  %ptr2 = wave.ptr_add %buffer2, %next
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
  %token2 = wave.where %active {
    %stored = wave.store %next -> %ptr2 after %token1
        : (!wave.simd<i32, 64>,
           !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
           !wave.mem.token) -> !wave.mem.token
    wave.yield %stored : !wave.mem.token
  } : !wave.mask<64> -> !wave.mem.token
  %joined = wave.join %token0, %token1, %token2
      : !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
  return
}

// ASM-LABEL: keep_effectful_gap_codegen:
// ASM: s_and_saveexec_b64
// ASM: buffer_store_dword
// ASM: buffer_store_dword
// ASM: s_and_saveexec_b64
// ASM: buffer_store_dword
// ASM-NOT: s_and_saveexec_b64
// ASM: s_endpgm
func.func @keep_effectful_gap_codegen(
    %out0: !wave.ptr<#wave.global, i32>,
    %out1: !wave.ptr<#wave.global, i32>,
    %out2: !wave.ptr<#wave.global, i32>,
    %limit: i32) attributes {wave.kernel} {
  %range = arith.constant 4096 : i32
  %buffer0 = waveamd.make_buffer %out0, %range
      : !wave.ptr<#wave.global, i32>, i32
      -> !wave.ptr<#waveamd.buffer, i32>
  %buffer1 = waveamd.make_buffer %out1, %range
      : !wave.ptr<#wave.global, i32>, i32
      -> !wave.ptr<#waveamd.buffer, i32>
  %buffer2 = waveamd.make_buffer %out2, %range
      : !wave.ptr<#wave.global, i32>, i32
      -> !wave.ptr<#waveamd.buffer, i32>
  %lane = wave.lane_id : !wave.simd<i32, 64>
  %vlimit = wave.splat %limit : i32 -> !wave.simd<i32, 64>
  %active = wave.cmpi ult %lane, %vlimit
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  %ptr0 = wave.ptr_add %buffer0, %lane
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
  %ptr1 = wave.ptr_add %buffer1, %lane
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
  %ptr2 = wave.ptr_add %buffer2, %lane
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
  %token0 = wave.where %active {
    %stored = wave.store %lane -> %ptr0
        : (!wave.simd<i32, 64>,
           !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>)
        -> !wave.mem.token
    wave.yield %stored : !wave.mem.token
  } : !wave.mask<64> -> !wave.mem.token
  %token1 = wave.store %lane -> %ptr1 after %token0
      : (!wave.simd<i32, 64>,
         !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
         !wave.mem.token) -> !wave.mem.token
  %token2 = wave.where %active {
    %stored = wave.store %lane -> %ptr2 after %token1
        : (!wave.simd<i32, 64>,
           !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
           !wave.mem.token) -> !wave.mem.token
    wave.yield %stored : !wave.mem.token
  } : !wave.mask<64> -> !wave.mem.token
  return
}

// ASM-LABEL: keep_readfirstlane_outside_exec_codegen:
// ASM: s_and_saveexec_b64
// ASM: v_readfirstlane_b32
// ASM: s_and_saveexec_b64
// ASM-NOT: s_and_saveexec_b64
// ASM: s_endpgm
func.func @keep_readfirstlane_outside_exec_codegen(
    %out: !wave.ptr<#wave.global, i32>,
    %limit: i32) attributes {wave.kernel} {
  %one = arith.constant 1 : i32
  %range = arith.constant 4096 : i32
  %buffer = waveamd.make_buffer %out, %range
      : !wave.ptr<#wave.global, i32>, i32
      -> !wave.ptr<#waveamd.buffer, i32>
  %lane = wave.lane_id : !wave.simd<i32, 64>
  %vone = wave.splat %one : i32 -> !wave.simd<i32, 64>
  %vlimit = wave.splat %limit : i32 -> !wave.simd<i32, 64>
  %active = wave.cmpi ult %lane, %vlimit
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  %masked = wave.where %active {
    %sum = wave.binary addi %lane, %vone
        : !wave.simd<i32, 64>, !wave.simd<i32, 64>
        -> !wave.simd<i32, 64>
    wave.yield %sum : !wave.simd<i32, 64>
  } : !wave.mask<64> -> !wave.simd<i32, 64>
  %first = wave.read_first %masked : !wave.simd<i32, 64> -> i32
  %broadcast = wave.splat %first : i32 -> !wave.simd<i32, 64>
  %ptr = wave.ptr_add %buffer, %lane
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
  wave.where %active {
    %stored = wave.store %broadcast -> %ptr
        : (!wave.simd<i32, 64>,
           !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>)
        -> !wave.mem.token
    wave.yield
  } : !wave.mask<64>
  return
}

}
