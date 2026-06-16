// RUN: wave-opt --waveamd-to-machine %s | FileCheck %s --check-prefix=SELECT
// RUN: wave-opt --waveamd-to-machine %s | wave-translate --wave-to-amdgpu-asm - | FileCheck %s --check-prefix=ASM
// RUN: wave-opt --waveamd-to-machine %s | wave-translate --wave-to-amdgpu-asm - | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// SELECT-LABEL: func.func @f16_global_shared
// SELECT: waveamdmachine.global_load_b16
// SELECT: waveamdmachine.ds_store_b16
// SELECT: waveamdmachine.ds_load_b16
// SELECT: waveamdmachine.global_store_b16
// ASM-LABEL: f16_global_shared:
// ASM: global_load_u16
// ASM: ds_store_b16
// ASM: ds_load_u16
// ASM: global_store_b16
func.func @f16_global_shared(%in: !wave.ptr<#wave.global, f16>,
                             %out: !wave.ptr<#wave.global, f16>)
    attributes {wave.kernel, wave.lds_size = 64 : i64} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %ip = wave.ptr_add %in, %lane
      : !wave.ptr<#wave.global, f16>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, f16>, 32>
  %v, %tok = wave.load %ip
      : (!wave.simd<!wave.ptr<#wave.global, f16>, 32>)
      -> (!wave.simd<f16, 32>, !wave.mem.token)
  %lds = wave.lds_base : !wave.ptr<#wave.shared, f16>
  %lp = wave.ptr_add %lds, %lane
      : !wave.ptr<#wave.shared, f16>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.shared, f16>, 32>
  %st = wave.store %v -> %lp after %tok
      : (!wave.simd<f16, 32>, !wave.simd<!wave.ptr<#wave.shared, f16>, 32>,
         !wave.mem.token)
      -> !wave.mem.token
  %barrier = wave.barrier %st : (!wave.mem.token) -> !wave.mem.token
  %lv:2 = wave.load %lp after %barrier
      : (!wave.simd<!wave.ptr<#wave.shared, f16>, 32>, !wave.mem.token)
      -> (!wave.simd<f16, 32>, !wave.mem.token)
  %op = wave.ptr_add %out, %lane
      : !wave.ptr<#wave.global, f16>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, f16>, 32>
  %final = wave.store %lv#0 -> %op after %lv#1
      : (!wave.simd<f16, 32>, !wave.simd<!wave.ptr<#wave.global, f16>, 32>,
         !wave.mem.token)
      -> !wave.mem.token
  return
}

// SELECT-LABEL: func.func @f16_buffer
// SELECT: waveamdmachine.buffer_load_b16
// SELECT: waveamdmachine.buffer_store_b16
// ASM-LABEL: f16_buffer:
// ASM: buffer_load_u16
// ASM: buffer_store_b16
func.func @f16_buffer(%base: !wave.ptr<#wave.global, f16>)
    attributes {wave.kernel} {
  %range = arith.constant 128 : i32
  %buffer = waveamd.make_buffer %base, %range
      : !wave.ptr<#wave.global, f16>, i32 -> !wave.ptr<#waveamd.buffer, f16>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %ptrs = wave.ptr_add %buffer, %lane
      : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 32>
  %v, %tok = wave.load %ptrs
      : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 32>)
      -> (!wave.simd<f16, 32>, !wave.mem.token)
  %st = wave.store %v -> %ptrs after %tok
      : (!wave.simd<f16, 32>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 32>,
         !wave.mem.token)
      -> !wave.mem.token
  return
}

}
