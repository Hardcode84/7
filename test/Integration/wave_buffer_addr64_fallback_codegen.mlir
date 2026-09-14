// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s --check-prefix=ASM
// RUN: wave-translate --wave-to-amdgpu-asm %s \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// ASM-LABEL: buffer_addr64_fallback:
// ASM: global_load_b32 v{{[0-9]+}}, v[{{[0-9]+}}:{{[0-9]+}}], off
// ASM: s_waitcnt vmcnt(0)
// ASM: global_store_b32 v[{{[0-9]+}}:{{[0-9]+}}], v{{[0-9]+}}, off
func.func @buffer_addr64_fallback(
    %out: !wave.ptr<#wave.global, i32>, %raw: i32)
    attributes {wave.kernel,
                wave.workgroup_size = array<i32: 32, 1, 1>,
                wave.waves_per_workgroup = 1 : i64} {
  %range = arith.constant 4096 : i32
  %buf = waveamd.make_buffer %out, %range
      : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %ptr = wave.ptr_add %buf, %raw
      : !wave.ptr<#waveamd.buffer, i32>, i32
      -> !wave.ptr<#waveamd.buffer, i32>
  %ptrs = wave.ptr_add %ptr, %lane
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
  %value, %read = wave.load %ptrs
      : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>)
      -> (!wave.simd<i32, 32>, !wave.mem.token)
  %stored = wave.store %value -> %ptrs after %read
      : (!wave.simd<i32, 32>,
         !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>, !wave.mem.token)
      -> !wave.mem.token
  return
}

}
