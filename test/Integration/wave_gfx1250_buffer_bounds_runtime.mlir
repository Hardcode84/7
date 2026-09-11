// REQUIRES: host-supports-amdgpu-gfx1250, host-has-hip-runtime, host-has-hipcc
// RUN: wave-translate --wave-to-amdgpu-asm %s > %t.s
// RUN: llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1250 -filetype=obj %t.s -o %t.o
// RUN: ld.lld -shared %t.o -o %t.hsaco
// RUN: %hipcc -O2 %S/../../tools/wave-microbench/wave-microbench-runner.cpp -o %t.runner
// RUN: env LD_LIBRARY_PATH=%rocm_lib %t.runner --iters 1 --warmup 0 \
// RUN:   --grid 1,1,1 --block 32,1,1 --buf-elems 32 --dump-out 32 --args 2 --x 64 \
// RUN:   %t.hsaco buffer_bounds | FileCheck %s

// CHECK: out[0]: 1
// CHECK-NEXT: out[1]: 2
// CHECK-NEXT: out[2]: 3
// CHECK-NEXT: out[3]: 4
// CHECK-NEXT: out[4]: 5
// CHECK-NEXT: out[5]: 6
// CHECK-NEXT: out[6]: 7
// CHECK-NEXT: out[7]: 8
// CHECK-NEXT: out[8]: 9
// CHECK-NEXT: out[9]: 10
// CHECK-NEXT: out[10]: 11
// CHECK-NEXT: out[11]: 12
// CHECK-NEXT: out[12]: 13
// CHECK-NEXT: out[13]: 14
// CHECK-NEXT: out[14]: 15
// CHECK-NEXT: out[15]: 16
// CHECK-NEXT: out[16]: -1
// CHECK-NEXT: out[17]: -1
// CHECK-NEXT: out[18]: -1
// CHECK-NEXT: out[19]: -1
// CHECK-NEXT: out[20]: -1
// CHECK-NEXT: out[21]: -1
// CHECK-NEXT: out[22]: -1
// CHECK-NEXT: out[23]: -1
// CHECK-NEXT: out[24]: -1
// CHECK-NEXT: out[25]: -1
// CHECK-NEXT: out[26]: -1
// CHECK-NEXT: out[27]: -1
// CHECK-NEXT: out[28]: -1
// CHECK-NEXT: out[29]: -1
// CHECK-NEXT: out[30]: -1
// CHECK-NEXT: out[31]: -1

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"} {
func.func @buffer_bounds(%out: !wave.ptr<#wave.global, i32>, %range: i32)
    attributes {wave.kernel, wave.workgroup_size = array<i32: 32, 1, 1>} {
  %buffer = waveamd.make_buffer %out, %range
      : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %one = arith.constant 1 : i32
  %value = wave.binary addi %lane, %one
      : !wave.simd<i32, 32>, i32 -> !wave.simd<i32, 32>
  %ptrs = wave.ptr_add %buffer, %lane
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
  %sentinel = wave.constant -1 : i32 -> !wave.simd<i32, 32>
  %initial_ptrs = wave.ptr_add %out, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %initialized = wave.store %sentinel -> %initial_ptrs
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> !wave.mem.token
  %written = wave.store %value -> %ptrs after %initialized
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>,
         !wave.mem.token)
      -> !wave.mem.token
  return
}
}
