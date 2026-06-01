// REQUIRES: host-supports-amdgpu-wave
// RUN: sed -e 's/@CHIP@/%chip/g' -e 's/@W@/%wave_width/g' -e 's/@BYTES@/%wave_bytes/g' %s | wave-translate --wave-to-amdgpu-asm - | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=%chip -filetype=obj -o %t.o
// RUN: ld.lld -shared %t.o -o %t.hsaco
// RUN: /opt/rocm/bin/hipcc %S/wave_buffer_runner.cpp -o %t.runner
// RUN: env LD_LIBRARY_PATH=/opt/rocm/lib %t.runner %t.hsaco | FileCheck %s --check-prefix=HW

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--@CHIP@"} {

// HW: buffer_store_kernel ok
func.func @buffer_store_kernel(%out: !wave.ptr<#wave.global, i32>, %x: i32) attributes {wave.kernel} {
  %range = arith.constant @BYTES@ : i32
  %buffer = waveamd.make_buffer %out, %range : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %lane = wave.lane_id : !wave.simd<i32, @W@>
  %vx = wave.splat %x : i32 -> !wave.simd<i32, @W@>
  %sum = wave.addi %lane, %vx : !wave.simd<i32, @W@>, !wave.simd<i32, @W@> -> !wave.simd<i32, @W@>
  %ptrs = wave.ptr_add %buffer, %lane : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, @W@> -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, @W@>
  %store_token = wave.store %sum -> %ptrs : (!wave.simd<i32, @W@>, !wave.simd<!wave.ptr<#waveamd.buffer, i32>, @W@>) -> !wave.mem.token
  return
}

}
