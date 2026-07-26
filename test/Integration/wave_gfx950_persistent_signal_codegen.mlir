// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_backend})' \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm - \
// RUN:   | FileCheck %s --check-prefix=ASM
// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_backend})' \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm - \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// ASM-LABEL: persistent_signal_codegen:
// ASM: buffer_load_dword
// ASM: s_getreg_b32 {{s[0-9]+}}, hwreg(HW_REG_IB_STS)
// ASM: s_and_b32 {{s[0-9]+}}, {{s[0-9]+}}, 15
// ASM: s_lshr_b32 {{s[0-9]+}}, {{s[0-9]+}}, 18
// ASM: s_and_b32 {{s[0-9]+}}, {{s[0-9]+}}, 48
// ASM: s_or_b32
// ASM: s_sleep 1
// ASM: s_getreg_b32 {{s[0-9]+}}, hwreg(HW_REG_IB_STS)
// ASM-NOT: s_waitcnt vmcnt
// ASM: ds_read_b32
// ASM: ds_add_rtn_u32
// ASM: s_wakeup
// ASM: s_endpgm
func.func @persistent_signal_codegen(%src: !wave.ptr<#wave.global, i32>)
    attributes {
      wave.kernel,
      wave.lds_size = 4 : i64,
      wave.workgroup_size = array<i32: 64, 1, 1>
    } {
  %zero = arith.constant 0 : i32
  %root = wave.token : !wave.mem.token
  %lane = wave.lane_id : !wave.simd<i32, 64>
  %srcs = wave.ptr_add %src, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %lds = wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
  %dma = waveamd.dma_load_lds %srcs -> %lds after %root {bytes = 4 : i64}
      : (!wave.simd<!wave.ptr<#wave.global, i32>, 64>,
         !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  %ready = waveamd.vmem_wait_poll %dma {sleep_cycles = 1 : i64}
      : (!wave.mem.token) -> !wave.mem.token
  %seen = waveamd.lds_poll_eq %lds equals %zero after %ready
      {sleep_cycles = 1 : i64}
      : (!wave.ptr<#wave.shared, i32>, i32, !wave.mem.token) -> !wave.mem.token
  %value = wave.splat %zero : i32 -> !wave.simd<i32, 64>
  %old, %published = waveamd.lds_atomic_add %value to %lds after %seen
      : (!wave.ptr<#wave.shared, i32>, !wave.simd<i32, 64>, !wave.mem.token)
      -> (!wave.simd<i32, 64>, !wave.mem.token)
  %wake = waveamd.wakeup %published
      : (!wave.mem.token) -> !wave.mem.token
  return
}

}
