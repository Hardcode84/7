// RUN: wave-opt %s --waveamd-to-machine --canonicalize | FileCheck %s --check-prefix=MACHINE
// RUN: wave-opt %s --waveamd-to-machine --waveamd-to-machine --canonicalize | FileCheck %s --check-prefix=MACHINE
// RUN: wave-translate %s --wave-to-amdgpu-asm | FileCheck %s --check-prefix=ASM

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
// MACHINE-LABEL: func.func @observe_one
// MACHINE-SAME: attributes
// MACHINE-NOT: global_load_lds
// MACHINE: [[WRITE:%.*]] = waveamdmachine.global_store_b32
// MACHINE-NOT: global_store_b32
// MACHINE: waveamdmachine.s_endpgm after [[WRITE]] : !waveamdmachine.mem.token
// MACHINE-NEXT: return
// ASM-LABEL: observe_one:
// ASM-NOT: global_load_lds
// ASM: {{(global|buffer)}}_store_dword
// ASM-NOT: {{(global|buffer)}}_store_dword
// ASM: s_endpgm
func.func @observe_one(%out: !wave.ptr<#wave.global, i32>, %other: !wave.ptr<#wave.global, i32>) -> !wave.mem.token attributes {wave.kernel} {
  %one = arith.constant 1 : i32
  %value = wave.splat %one : i32 -> !wave.simd<i32, 64>
  %empty = wave.token : !wave.mem.token
  %lds = wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
  %lane = wave.lane_id : !wave.simd<i32, 64>
  %src = wave.ptr_add %other, %lane : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %dma = waveamd.dma_load_lds %src -> %lds after %empty {bytes = 4 : i64} : (!wave.simd<!wave.ptr<#wave.global, i32>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  %dead = wave.store %value -> %other after %dma : (!wave.simd<i32, 64>, !wave.ptr<#wave.global, i32>, !wave.mem.token) -> !wave.mem.token
  %live = wave.store %value -> %out : (!wave.simd<i32, 64>, !wave.ptr<#wave.global, i32>) -> !wave.mem.token
  return %live : !wave.mem.token
}

// MACHINE-LABEL: func.func @callable_observation
// MACHINE: [[WRITE:%.*]] = waveamdmachine.global_store_b32
// MACHINE: waveamdmachine.s_setpc_b64 after [[WRITE]] : !waveamdmachine.mem.token
// MACHINE-NEXT: return
// ASM-LABEL: callable_observation:
// ASM: {{(global|buffer)}}_store_dword
// ASM: s_setpc_b64
func.func @callable_observation(%out: !wave.ptr<#wave.global, i32>) -> !wave.mem.token {
  %one = arith.constant 1 : i32
  %value = wave.splat %one : i32 -> !wave.simd<i32, 64>
  %write = wave.store %value -> %out : (!wave.simd<i32, 64>, !wave.ptr<#wave.global, i32>) -> !wave.mem.token
  return %write : !wave.mem.token
}
}
