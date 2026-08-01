// RUN: wave-opt %s --pass-pipeline='builtin.module(waveamd-prepare-regalloc,transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_regalloc_transform_loop},waveamd-resource-info)' \
// RUN:   | FileCheck %s --check-prefix=ALLOC
// RUN: wave-opt %s --pass-pipeline='builtin.module(waveamd-prepare-regalloc,transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_regalloc_transform_loop},waveamd-resource-info)' \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm - \
// RUN:   | FileCheck %s --check-prefix=ASM
// RUN: wave-opt %s --pass-pipeline='builtin.module(waveamd-prepare-regalloc,transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_regalloc_transform_loop},waveamd-resource-info)' \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm - \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx90a -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx90a"} {

// ALLOC-LABEL: func.func @nested_region_carry_codegen()
// ALLOC-SAME: waveamdmachine.regalloc_assignments
// ALLOC: waveamdmachine.uniform_loop
// ALLOC: waveamdmachine.uniform_if
// ALLOC: waveamdmachine.update_tuple
// ALLOC: waveamdmachine.continue_if
// ASM-LABEL: nested_region_carry_codegen:
// ASM: s_cbranch_scc0
// ASM: [[LOOP:.Lnested_region_carry_codegen.loop_head_[0-9]+]]:
// ASM: s_cbranch_scc0
// ASM: s_branch
// ASM: v_add_u32
// ASM: s_cbranch_scc1 [[LOOP]]
// ASM: v_cmpx_eq_u32
// ASM: s_endpgm
func.func @nested_region_carry_codegen()
    attributes {wave.kernel, wave.workgroup_size = array<i32: 64, 1, 1>,
                waveamdmachine.target_waves = 4 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %condition = waveamdmachine.s_cmp_lt_i32 %one, %zero
      : (!waveamdmachine.imm, !waveamdmachine.imm)
        -> !waveamdmachine.reg<scc, 1>
  %lhs = waveamdmachine.v_mov_b32_tuple %zero
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %rhs = waveamdmachine.v_mov_b32_tuple %one
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %results:2 = waveamdmachine.uniform_loop if %condition
      : !waveamdmachine.reg<scc, 1>
      carries(%lhs, %rhs : !waveamdmachine.reg<vgpr, 1>,
              !waveamdmachine.reg<vgpr, 1>) {
  ^bb0(%lhs_iter: !waveamdmachine.reg<vgpr, 1>,
       %rhs_iter: !waveamdmachine.reg<vgpr, 1>):
    %selected = waveamdmachine.uniform_if %condition {
      waveamdmachine.yield %rhs_iter : !waveamdmachine.reg<vgpr, 1>
    } otherwise {
      %changed = waveamdmachine.v_add_u32 %lhs_iter, %rhs_iter
          : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
            -> !waveamdmachine.reg<vgpr, 1>
      waveamdmachine.yield %changed : !waveamdmachine.reg<vgpr, 1>
    } : !waveamdmachine.reg<scc, 1> -> !waveamdmachine.reg<vgpr, 1>
    waveamdmachine.continue_if %condition : !waveamdmachine.reg<scc, 1>
        carries(%selected, %lhs_iter : !waveamdmachine.reg<vgpr, 1>,
                !waveamdmachine.reg<vgpr, 1>)
  } -> !waveamdmachine.reg<vgpr, 1>,
       !waveamdmachine.reg<vgpr, 1>
  %sum = waveamdmachine.v_add_u32 %results#0, %results#1
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  waveamdmachine.v_cmpx_eq_u32 %sum, %sum
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> ()
  waveamdmachine.s_endpgm
  return
}

}
