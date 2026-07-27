// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_backend})' \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm - \
// RUN:   | FileCheck %s --check-prefix=ASM
// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_backend})' \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm - \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// ASM-LABEL: global_atomic_acq_rel_codegen:
// ASM: buffer_wbl2 sc1
// ASM-NEXT: s_waitcnt vmcnt(0) lgkmcnt(0)
// ASM-NEXT: global_atomic_add {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}, {{s\[[0-9]+:[0-9]+\]}} sc0
// ASM-NEXT: s_waitcnt vmcnt(0)
// ASM-NEXT: buffer_inv sc1
// ASM: buffer_store_dword
// ASM: s_endpgm
func.func @global_atomic_acq_rel_codegen(
    %counter: !wave.ptr<#wave.global, i32>,
    %out: !wave.ptr<#wave.global, i32>, %increment: i32)
    attributes {
      wave.kernel,
      wave.workgroup_size = array<i32: 64, 1, 1>
    } {
  %root = wave.token : !wave.mem.token
  %value = wave.splat %increment : i32 -> !wave.simd<i32, 64>
  %old, %atomic = waveamd.global_atomic_add_acq_rel %value to %counter after %root
      : (!wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>, !wave.mem.token)
        -> (!wave.simd<i32, 64>, !wave.mem.token)
  %lane = wave.lane_id : !wave.simd<i32, 64>
  %out_ptrs = wave.ptr_add %out, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>
        -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %stored = wave.store %old -> %out_ptrs after %atomic
      : (!wave.simd<i32, 64>, !wave.simd<!wave.ptr<#wave.global, i32>, 64>,
         !wave.mem.token) -> !wave.mem.token
  return
}

// ASM-LABEL: global_atomic_acq_rel_simd_pointer_codegen:
// ASM: buffer_wbl2 sc1
// ASM-NEXT: s_waitcnt vmcnt(0) lgkmcnt(0)
// ASM-NEXT: global_atomic_add {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}, {{s\[[0-9]+:[0-9]+\]}} sc0
// ASM-NEXT: s_waitcnt vmcnt(0)
// ASM-NEXT: buffer_inv sc1
// ASM: buffer_store_dword
// ASM: s_endpgm
func.func @global_atomic_acq_rel_simd_pointer_codegen(
    %counters: !wave.ptr<#wave.global, i32>,
    %out: !wave.ptr<#wave.global, i32>, %increment: i32)
    attributes {
      wave.kernel,
      wave.workgroup_size = array<i32: 64, 1, 1>
    } {
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
