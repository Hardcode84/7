// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_backend_lower},transform-interpreter{entry-point=waveamd_backend_finish})' \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline \
// RUN:       wave-translate --wave-to-amdgpu-asm - > %t.s
// RUN: FileCheck %s --check-prefix=ASM < %t.s
// RUN: not grep -E '(^|[[:space:]])s_waitcnt([[:space:]]|$)|s_waitcnt_vscnt' %t.s
// RUN: llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1250 \
// RUN:   -filetype=obj -o %t.o %t.s 2> %t.mc.err
// RUN: not grep -i warning %t.mc.err
// RUN: llvm-objdump -d --mcpu=gfx1250 %t.o > %t.dis
// RUN: FileCheck %s --check-prefix=DIS < %t.dis
// RUN: not grep -E '(^|[[:space:]])s_waitcnt([[:space:]]|$)|s_waitcnt_vscnt' %t.dis

module attributes {
  waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"
} {

// ASM-LABEL: global_atomic_acq_rel_codegen:
// ASM: s_wait_loadcnt 0x0
// ASM-NEXT: s_wait_storecnt 0x0
// ASM-NEXT: global_wb scope:SCOPE_DEV
// ASM-NEXT: s_wait_storecnt 0x0
// ASM-NEXT: s_wait_xcnt 0x0
// ASM-NEXT: s_wait_loadcnt_dscnt 0x0
// ASM-NEXT: global_atomic_add_u32 {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}, {{s\[[0-9]+:[0-9]+\]}} th:TH_ATOMIC_RETURN scope:SCOPE_DEV
// ASM-NEXT: s_wait_loadcnt 0x0
// ASM-NEXT: global_inv scope:SCOPE_DEV
// ASM-NEXT: s_wait_loadcnt 0x0
// ASM: buffer_store_b32
// ASM: s_endpgm
// DIS-LABEL: <global_atomic_acq_rel_codegen>:
// DIS: global_wb scope:SCOPE_DEV
// DIS: global_atomic_add_u32 {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}, {{s\[[0-9]+:[0-9]+\]}} th:TH_ATOMIC_RETURN scope:SCOPE_DEV
// DIS: global_inv scope:SCOPE_DEV
func.func @global_atomic_acq_rel_codegen(
    %counter: !wave.ptr<#wave.global, i32>,
    %out: !wave.ptr<#wave.global, i32>, %increment: i32)
    attributes {
      wave.kernel,
      wave.workgroup_size = array<i32: 32, 1, 1>
    } {
  %root = wave.token : !wave.mem.token
  %value = wave.splat %increment : i32 -> !wave.simd<i32, 32>
  %old, %atomic = waveamd.global_atomic_add_acq_rel
      %value to %counter after %root
      : (!wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>, !wave.mem.token)
        -> (!wave.simd<i32, 32>, !wave.mem.token)
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %out_ptrs = wave.ptr_add %out, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
        -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %stored = wave.store %old -> %out_ptrs after %atomic
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>,
         !wave.mem.token) -> !wave.mem.token
  return
}

// ASM-LABEL: global_atomic_acq_rel_simd_pointer_codegen:
// ASM: s_wait_loadcnt 0x0
// ASM-NEXT: s_wait_storecnt 0x0
// ASM-NEXT: global_wb scope:SCOPE_DEV
// ASM-NEXT: s_wait_storecnt 0x0
// ASM-NEXT: s_wait_xcnt 0x0
// ASM-NEXT: s_wait_loadcnt_dscnt 0x0
// ASM-NEXT: global_atomic_add_u32 {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}, {{s\[[0-9]+:[0-9]+\]}} th:TH_ATOMIC_RETURN scope:SCOPE_DEV
// ASM-NEXT: s_wait_loadcnt 0x0
// ASM-NEXT: global_inv scope:SCOPE_DEV
// ASM-NEXT: s_wait_loadcnt 0x0
// ASM: buffer_store_b32
// ASM: s_endpgm
// DIS-LABEL: <global_atomic_acq_rel_simd_pointer_codegen>:
// DIS: global_wb scope:SCOPE_DEV
// DIS: global_atomic_add_u32 {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}, {{s\[[0-9]+:[0-9]+\]}} th:TH_ATOMIC_RETURN scope:SCOPE_DEV
// DIS: global_inv scope:SCOPE_DEV
func.func @global_atomic_acq_rel_simd_pointer_codegen(
    %counters: !wave.ptr<#wave.global, i32>,
    %out: !wave.ptr<#wave.global, i32>, %increment: i32)
    attributes {
      wave.kernel,
      wave.workgroup_size = array<i32: 32, 1, 1>
    } {
  %root = wave.token : !wave.mem.token
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %counter_ptrs = wave.ptr_add %counters, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
        -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %value = wave.splat %increment : i32 -> !wave.simd<i32, 32>
  %old, %atomic = waveamd.global_atomic_add_acq_rel
      %value to %counter_ptrs after %root
      : (!wave.simd<!wave.ptr<#wave.global, i32>, 32>,
         !wave.simd<i32, 32>, !wave.mem.token)
        -> (!wave.simd<i32, 32>, !wave.mem.token)
  %out_ptrs = wave.ptr_add %out, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
        -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %stored = wave.store %old -> %out_ptrs after %atomic
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>,
         !wave.mem.token) -> !wave.mem.token
  return
}

}
