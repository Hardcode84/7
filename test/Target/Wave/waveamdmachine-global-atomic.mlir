// RUN: wave-opt --waveamd-to-machine %s | FileCheck %s --check-prefix=SELECT
// RUN: wave-opt --waveamd-to-machine %s | wave-opt | FileCheck %s --check-prefix=SELECT
// RUN: wave-opt --waveamd-to-machine --waveamd-abi-lowering --waveamd-insert-ticket-waits %s | FileCheck %s --check-prefix=WAIT
// RUN: wave-opt --waveamd-to-machine %s | wave-translate --wave-to-amdgpu-asm - | FileCheck %s --check-prefix=ASM
// RUN: wave-opt --waveamd-to-machine %s | wave-translate --wave-to-amdgpu-asm - | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// SELECT-LABEL: func.func @scalar_pointer
// SELECT: [[ROOT:%.*]] = waveamdmachine.token
// SELECT: [[VALUE:%.*]], [[LOADED:%.*]] = waveamdmachine.global_load_b32 {{.*}} after [[ROOT]]
// SELECT: [[OLD:%.*]], [[ATOMIC:%.*]] = waveamdmachine.global_atomic_add_acq_rel_u32 {{.*}} after [[LOADED]]
// SELECT: waveamdmachine.global_store_b32 {{.*}}, [[OLD]], {{.*}} after [[ATOMIC]]

// WAIT-LABEL: func.func @scalar_pointer
// WAIT: waveamdmachine.global_load_b32
// WAIT: waveamdmachine.s_waitcnt
// WAIT-NEXT: {{.*}} = waveamdmachine.global_atomic_add_acq_rel_u32

// ASM-LABEL: scalar_pointer:
// ASM: buffer_wbl2 sc1
// ASM-NEXT: s_waitcnt vmcnt(0) lgkmcnt(0)
// ASM-NEXT: global_atomic_add {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}, {{s\[[0-9]+:[0-9]+\]}} sc0
// ASM-NEXT: s_waitcnt vmcnt(0)
// ASM-NEXT: buffer_inv sc1
func.func @scalar_pointer(
    %counter: !wave.ptr<#wave.global, i32>,
    %increments: !wave.ptr<#wave.global, i32>,
    %out: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel, wave.workgroup_size = array<i32: 64, 1, 1>} {
  %root = wave.token : !wave.mem.token
  %lane = wave.lane_id : !wave.simd<i32, 64>
  %increment_ptrs = wave.ptr_add %increments, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>
        -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %value, %loaded = wave.load %increment_ptrs after %root
      : (!wave.simd<!wave.ptr<#wave.global, i32>, 64>, !wave.mem.token)
        -> (!wave.simd<i32, 64>, !wave.mem.token)
  %old, %atomic = waveamd.global_atomic_add_acq_rel
      %value to %counter after %loaded
      : (!wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>, !wave.mem.token)
        -> (!wave.simd<i32, 64>, !wave.mem.token)
  %out_ptrs = wave.ptr_add %out, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>
        -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %stored = wave.store %old -> %out_ptrs after %atomic
      : (!wave.simd<i32, 64>, !wave.simd<!wave.ptr<#wave.global, i32>, 64>,
         !wave.mem.token) -> !wave.mem.token
  return
}

// SELECT-LABEL: func.func @simd_pointer
// SELECT: [[ROOT:%.*]] = waveamdmachine.token
// SELECT: [[OLD:%.*]], [[ATOMIC:%.*]] = waveamdmachine.global_atomic_add_acq_rel_u32 {{.*}} after [[ROOT]]
// SELECT: waveamdmachine.global_store_b32 {{.*}}, [[OLD]], {{.*}} after [[ATOMIC]]

// ASM-LABEL: simd_pointer:
// ASM: buffer_wbl2 sc1
// ASM-NEXT: s_waitcnt vmcnt(0) lgkmcnt(0)
// ASM-NEXT: global_atomic_add {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}, {{s\[[0-9]+:[0-9]+\]}} sc0
// ASM-NEXT: s_waitcnt vmcnt(0)
// ASM-NEXT: buffer_inv sc1
func.func @simd_pointer(
    %counters: !wave.ptr<#wave.global, i32>,
    %out: !wave.ptr<#wave.global, i32>, %increment: i32)
    attributes {wave.kernel, wave.workgroup_size = array<i32: 64, 1, 1>} {
  %root = wave.token : !wave.mem.token
  %lane = wave.lane_id : !wave.simd<i32, 64>
  %counter_ptrs = wave.ptr_add %counters, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>
        -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %value = wave.splat %increment : i32 -> !wave.simd<i32, 64>
  %old, %atomic = waveamd.global_atomic_add_acq_rel
      %value to %counter_ptrs after %root
      : (!wave.simd<!wave.ptr<#wave.global, i32>, 64>,
         !wave.simd<i32, 64>, !wave.mem.token)
        -> (!wave.simd<i32, 64>, !wave.mem.token)
  %out_ptrs = wave.ptr_add %out, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>
        -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %stored = wave.store %old -> %out_ptrs after %atomic
      : (!wave.simd<i32, 64>, !wave.simd<!wave.ptr<#wave.global, i32>, 64>,
         !wave.mem.token) -> !wave.mem.token
  return
}

}
