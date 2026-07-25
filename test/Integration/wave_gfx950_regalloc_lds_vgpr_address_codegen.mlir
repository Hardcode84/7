// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_regalloc_transform_loop},waveamd-insert-ticket-waits,waveamd-insert-hazard-waits,waveamd-resource-info)' \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm - \
// RUN:   | FileCheck %s --check-prefix=ASM
// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_regalloc_transform_loop},waveamd-insert-ticket-waits,waveamd-insert-hazard-waits,waveamd-resource-info)' \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm - \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// ASM-LABEL: regalloc_lds_vgpr_address_codegen:
// ASM-NOT: v_add_u32{{(_e32)?}} {{.*}}0x200
// ASM: v_add_u32{{(_e32)?}} [[ADDR:v[0-9]+]], 0x500, v0
// ASM-COUNT-2: ds_write_b32 [[ADDR]],
// ASM-NOT: v_add_u32{{(_e32)?}} {{.*}}0x500
func.func @regalloc_lds_vgpr_address_codegen()
    attributes {wave.kernel, wave.workgroup_size = array<i32: 64, 1, 1>,
                wave.dynamic_lds_size = 1024 : i64,
                waveamdmachine.vgpr_count_max = 3 : i64,
                waveamdmachine.agpr_count_max = 0 : i64} {
  %base = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2>
  %off = waveamdmachine.v_workitem_id_x
      : !waveamdmachine.reg<vgpr, 1, 0>
  %half = waveamdmachine.imm 512 : !waveamdmachine.imm
  %half_addr = waveamdmachine.v_add_u32 %off, %half
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.imm)
        -> !waveamdmachine.reg<vgpr, 1>
  %addr = waveamdmachine.v_add_u32 %half_addr, %half
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
        -> !waveamdmachine.reg<vgpr, 1>
  %tok0 = waveamdmachine.token : !waveamdmachine.mem.token
  %lds0 = waveamdmachine.ds_store_b32 %addr, %off after %tok0
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %lds1 = waveamdmachine.ds_store_b32 %addr, %off after %lds0
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %spill, %tok1 = waveamdmachine.global_load_b32 %off, %base after %lds1
      : (!waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>,
            !waveamdmachine.mem.token)
  %a, %tok2 = waveamdmachine.global_load_b32 %off, %base after %tok1
      : (!waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>,
            !waveamdmachine.mem.token)
  %b, %tok3 = waveamdmachine.global_load_b32 %off, %base after %tok2
      : (!waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>,
            !waveamdmachine.mem.token)
  %sum = waveamdmachine.v_add_u32 %a, %b
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %use = waveamdmachine.v_add_u32 %spill, %sum
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  waveamdmachine.s_endpgm
  return
}

}
