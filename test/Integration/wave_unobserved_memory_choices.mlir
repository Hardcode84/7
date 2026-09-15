// RUN: wave-opt %s --wave-materialize-memory-variants | FileCheck %s --check-prefix=MATERIALIZE
// RUN: wave-opt %s --wave-materialize-memory-variants --canonicalize | FileCheck %s --check-prefix=DEAD
// RUN: wave-opt %s --waveamd-to-machine --waveamd-expand-materialization-variants=max-candidates=1 --waveamd-collapse-materialization-variants --canonicalize | FileCheck %s --check-prefix=OBSERVED
// RUN: wave-translate %s --wave-to-amdgpu-asm | FileCheck %s --check-prefix=ASM

// MATERIALIZE-LABEL: func.func @unobserved_choice
// MATERIALIZE-COUNT-2: wave.store
// DEAD-LABEL: func.func @unobserved_choice
// DEAD-NEXT: return
// ASM-LABEL: unobserved_choice:
// ASM-NOT: store
// ASM: s_endpgm
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @unobserved_choice(%out: !wave.ptr<#wave.global, i32>) attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 64>
  %two = arith.constant 2 : i32
  %a = wave.binary muli %lane, %two : !wave.simd<i32, 64>, i32 -> !wave.simd<i32, 64>
  %b = wave.binary addi %lane, %lane : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %offset = wave.materialization_variants %a, %b : !wave.simd<i32, 64>
  %ptr = wave.ptr_add %out, %offset : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %write = wave.store %lane -> %ptr : (!wave.simd<i32, 64>, !wave.simd<!wave.ptr<#wave.global, i32>, 64>) -> !wave.mem.token
  return
}

// OBSERVED-LABEL: func.func @externally_observed_alternative
// OBSERVED-COUNT-2: waveamdmachine.global_store_b32
// OBSERVED: waveamdmachine.s_endpgm after
// ASM-LABEL: externally_observed_alternative:
// ASM-COUNT-2: buffer_store_dword
// ASM: s_endpgm
func.func @externally_observed_alternative(%out: !wave.ptr<#wave.global, i32>) -> (!wave.mem.token, !wave.mem.token, !wave.mem.token) attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 64>
  %ptr = wave.ptr_add %out, %lane : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %first = wave.store %lane -> %ptr : (!wave.simd<i32, 64>, !wave.simd<!wave.ptr<#wave.global, i32>, 64>) -> !wave.mem.token
  %second = wave.store %lane -> %ptr : (!wave.simd<i32, 64>, !wave.simd<!wave.ptr<#wave.global, i32>, 64>) -> !wave.mem.token
  %choice = wave.materialization_variants %first, %second : !wave.mem.token
  return %choice, %first, %second : !wave.mem.token, !wave.mem.token, !wave.mem.token
}

}
