// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_regalloc_transform_loop},waveamd-insert-ticket-waits,waveamd-insert-hazard-waits,waveamd-resource-info)' \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm - \
// RUN:   | FileCheck %s --check-prefix=ASM
// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_regalloc_transform_loop},waveamd-insert-ticket-waits,waveamd-insert-hazard-waits,waveamd-resource-info)' \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm - \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1250 \
// RUN:       -filetype=obj -o /dev/null

module attributes {
  waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"
} {

// ASM-LABEL: global_async_to_lds_codegen:
// ASM: global_load_async_to_lds_b8 [[LDS:v[0-9]+]], [[GLOBAL:v[0-9]+]], [[BASE:s\[[0-9]+:[0-9]+\]]]
// ASM-NEXT: s_wait_asynccnt 0x0
// ASM-NEXT: global_load_async_to_lds_b32 [[LDS]], [[GLOBAL]], [[BASE]]
// ASM-NEXT: s_wait_asynccnt 0x0
// ASM-NEXT: global_load_async_to_lds_b64 [[LDS]], [[GLOBAL]], [[BASE]]
// ASM-NEXT: s_wait_asynccnt 0x0
// ASM-NEXT: global_load_async_to_lds_b128 [[LDS]], [[GLOBAL]], [[BASE]]
func.func @global_async_to_lds_codegen()
    attributes {wave.kernel,
                wave.workgroup_size = array<i32: 32, 1, 1>} {
  %lds = waveamdmachine.v_workitem_id_x
      : !waveamdmachine.reg<vgpr, 1, 0>
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %global = waveamdmachine.v_mov_b32_tuple %zero
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %base = waveamdmachine.uninit
      : !waveamdmachine.reg<sgpr, 2>
  %root = waveamdmachine.token : !waveamdmachine.mem.token
  %b8 = waveamdmachine.global_load_async_to_lds_b8
      %lds, %global, %base after %root
      : (!waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  %b32 = waveamdmachine.global_load_async_to_lds_b32
      %lds, %global, %base after %b8
      : (!waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  %b64 = waveamdmachine.global_load_async_to_lds_b64
      %lds, %global, %base after %b32
      : (!waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  %b128 = waveamdmachine.global_load_async_to_lds_b128
      %lds, %global, %base after %b64
      : (!waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm
  return
}

}
