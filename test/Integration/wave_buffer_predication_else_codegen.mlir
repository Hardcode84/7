// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s
// RUN: wave-translate --wave-to-amdgpu-asm %s | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null
// RUN: wave-opt --waveamd-lower-buffer-predication %s | wave-translate --wave-to-amdgpu-asm | FileCheck %s
// RUN: wave-opt --waveamd-lower-buffer-predication %s | wave-translate --wave-to-amdgpu-asm | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

// CHECK-LABEL: nonzero_fill_buffer_load:
// CHECK-NOT: s_and_saveexec
// CHECK: buffer_load_dword
// CHECK: v_cndmask_b32
// CHECK: buffer_store_dword
// CHECK-NOT: s_and_saveexec
// CHECK: s_endpgm
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @nonzero_fill_buffer_load(
    %base: !wave.ptr<#wave.global, i32>, %limit: i32)
    -> !wave.mem.token attributes {wave.kernel} {
  %range = arith.constant 4096 : i32
  %buffer = waveamd.make_buffer %base, %range
      : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %lane = wave.lane_id : !wave.simd<i32, 64>
  %ptr = wave.ptr_add %buffer, %lane
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
  %vlimit = wave.splat %limit : i32 -> !wave.simd<i32, 64>
  %active = wave.cmpi slt %lane, %vlimit : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  %dependency = wave.token : !wave.mem.token
  %result:2 = wave.where %active {
    %value, %token = wave.load %ptr after %dependency
        : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>, !wave.mem.token)
        -> (!wave.simd<i32, 64>, !wave.mem.token)
    wave.yield %value, %token : !wave.simd<i32, 64>, !wave.mem.token
  } otherwise {
    %else_value = wave.binary addi %lane, %lane : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
    wave.yield %else_value, %dependency : !wave.simd<i32, 64>, !wave.mem.token
  } : !wave.mask<64> -> !wave.simd<i32, 64>, !wave.mem.token
  %done = wave.store %result#0 -> %ptr after %result#1 : (!wave.simd<i32, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>, !wave.mem.token) -> !wave.mem.token
  return %done : !wave.mem.token
}

}
