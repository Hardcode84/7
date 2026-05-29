// RUN: wave-opt --waveamd-to-machine %s | FileCheck %s --check-prefix=SELECT
// RUN: wave-opt --waveamd-to-machine %s | wave-opt | FileCheck %s --check-prefix=SELECT
// RUN: wave-opt --waveamd-to-machine %s | wave-translate --wave-to-amdgpu-asm - | FileCheck %s --check-prefix=ASM
// RUN: wave-opt --waveamd-to-machine %s | wave-translate --wave-to-amdgpu-asm - | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// SELECT-LABEL: func.func @global_constant_overflow
// SELECT: waveamdmachine.global_store_b32_addr64
// SELECT-NOT: waveamdmachine.global_store_b32 %
// ASM-LABEL: global_constant_overflow:
// ASM: global_store_b32 v[{{[0-9]+}}:{{[0-9]+}}], v{{[0-9]+}}, off
func.func @global_constant_overflow(%out: !wave.ptr<i32, #wave.global>) attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %off = wave.index_expr <"1073741824 + lid"> ["lid"] (%lane)
      : (!wave.simd<i32, 32>) -> !wave.index<32>
  %ptrs = wave.ptr_add %out, %off
      : !wave.ptr<i32, #wave.global>, !wave.index<32>
      -> !wave.simd<!wave.ptr<i32, #wave.global>, 32>
  %tok = wave.store %lane -> %ptrs
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<i32, #wave.global>, 32>)
      -> !wave.mem.token
  return
}

// SELECT-LABEL: func.func @buffer_constant_overflow
// SELECT: waveamdmachine.make_buffer_rsrc
// SELECT-NOT: waveamdmachine.buffer_store_b32
// SELECT: waveamdmachine.global_store_b32_addr64
// ASM-LABEL: buffer_constant_overflow:
// ASM: global_store_b32 v[{{[0-9]+}}:{{[0-9]+}}], v{{[0-9]+}}, off
func.func @buffer_constant_overflow(%out: !wave.ptr<i32, #wave.global>) attributes {wave.kernel} {
  %range = arith.constant 64 : i32
  %buf = waveamd.make_buffer %out, %range
      : !wave.ptr<i32, #wave.global>, i32 -> !wave.ptr<i32, #waveamd.buffer>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %off = wave.index_expr <"1073741824 + lid"> ["lid"] (%lane)
      : (!wave.simd<i32, 32>) -> !wave.index<32>
  %ptrs = wave.ptr_add %buf, %off
      : !wave.ptr<i32, #waveamd.buffer>, !wave.index<32>
      -> !wave.simd<!wave.ptr<i32, #waveamd.buffer>, 32>
  %tok = wave.store %lane -> %ptrs
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<i32, #waveamd.buffer>, 32>)
      -> !wave.mem.token
  return
}

}
