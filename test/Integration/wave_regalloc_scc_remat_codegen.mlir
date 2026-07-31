// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_regalloc_transform_loop},waveamd-resource-info)' \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm - \
// RUN:   | FileCheck %s --check-prefix=ASM
// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_regalloc_transform_loop},waveamd-resource-info)' \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm - \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// ASM-LABEL: regalloc_scc_remat:
// ASM-NOT: scratch_
// ASM: s_cmp_lt_i32
// ASM: s_cselect_b32 [[SAVED:s[0-9]+]], 1, 0
// ASM-NEXT: s_add_i32
// ASM: s_cmp_lg_u32 [[SAVED]], 0
// ASM: s_cbranch_scc1
// ASM-NOT: scratch_
func.func @regalloc_scc_remat()
    attributes {wave.kernel, wave.workgroup_size = array<i32: 64, 1, 1>,
                waveamdmachine.vgpr_count_max = 3 : i64,
                waveamdmachine.agpr_count_max = 0 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %two = waveamdmachine.imm 2 : !waveamdmachine.imm
  %sg = waveamdmachine.uninit {waveamdmachine.regalloc_remat_temp}
      : !waveamdmachine.reg<sgpr, 1>
  %sum, %sum_scc = waveamdmachine.s_add_i32 %sg, %one
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
        -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  %scalar = waveamdmachine.v_mov_b32_tuple %sum {registers = 1 : i64}
      : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %tid = waveamdmachine.v_workitem_id_x
      : !waveamdmachine.reg<vgpr, 1, 0>
  %shared = waveamdmachine.v_and_b32 %tid, %scalar
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %root0 = waveamdmachine.v_xor_b32 %shared, %one
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
        -> !waveamdmachine.reg<vgpr, 1>
  %root1 = waveamdmachine.v_xor_b32 %shared, %two
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
        -> !waveamdmachine.reg<vgpr, 1>
  %cond = waveamdmachine.s_cmp_lt_i32 %zero, %one
      : (!waveamdmachine.imm, !waveamdmachine.imm)
        -> !waveamdmachine.reg<scc, 1>
  waveamdmachine.uniform_loop if %cond : !waveamdmachine.reg<scc, 1> {
    %a = waveamdmachine.uninit {waveamdmachine.regalloc_remat_temp}
        : !waveamdmachine.reg<vgpr, 1>
    %b = waveamdmachine.uninit {waveamdmachine.regalloc_remat_temp}
        : !waveamdmachine.reg<vgpr, 1>
    %pressure = waveamdmachine.v_add_u32 %a, %b
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    %use0 = waveamdmachine.v_add_u32 %root0, %one
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
          -> !waveamdmachine.reg<vgpr, 1>
    %use1 = waveamdmachine.v_add_u32 %root1, %two
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
          -> !waveamdmachine.reg<vgpr, 1>
    %root_sum = waveamdmachine.v_add_u32 %use0, %use1
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
  }
  waveamdmachine.s_endpgm
  return
}

}
