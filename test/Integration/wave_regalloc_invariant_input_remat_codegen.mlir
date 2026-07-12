// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_regalloc_transform_loop},waveamd-resource-info)' \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm - \
// RUN:   | FileCheck %s --check-prefix=ASM
// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_regalloc_transform_loop},waveamd-resource-info)' \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm - \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// ASM-LABEL: regalloc_profitable_mfma_input_remat:
// ASM-COUNT-4: v_mov_b32_e32 {{v[0-9]+}}, {{[01]}}
// ASM-NEXT: v_mfma_f32_16x16x32_f16
// ASM-COUNT-4: v_mov_b32_e32 {{v[0-9]+}}, {{[01]}}
// ASM-NEXT: v_mfma_f32_16x16x32_f16
func.func @regalloc_profitable_mfma_input_remat()
    attributes {wave.kernel, wave.workgroup_size = array<i32: 64, 1, 1>} {
  %a = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4>
  %b = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4>
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %acc0 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %acc1 = waveamdmachine.v_mov_b32_tuple %one {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %acc2 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %acc3 = waveamdmachine.v_mov_b32_tuple %one {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %acc = waveamdmachine.tuple_from_elements %acc0, %acc1, %acc2, %acc3
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 4>
  %mma0 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %mma1 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  waveamdmachine.s_endpgm
  return
}

// ASM-LABEL: regalloc_expensive_loop_input_copy:
// ASM: v_mov_b32_e32 [[BASE:v[0-9]+]], 0
// ASM-NEXT: v_add_u32_e32 [[INIT:v[0-9]+]], 1, [[BASE]]
// ASM-NEXT: v_mov_b32_e32 {{v[0-9]+}}, [[INIT]]
// ASM-NOT: v_add_u32
// ASM: [[LOOP:.Lregalloc_expensive_loop_input_copy.loop_head_[0-9]+]]:
// ASM: s_cbranch_scc1 [[LOOP]]
func.func @regalloc_expensive_loop_input_copy()
    attributes {wave.kernel, wave.workgroup_size = array<i32: 64, 1, 1>} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %cond = waveamdmachine.s_cmp_lt_i32 %zero, %one
      : (!waveamdmachine.imm, !waveamdmachine.imm)
        -> !waveamdmachine.reg<scc, 1>
  %base = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %init = waveamdmachine.v_add_u32 %base, %one
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
        -> !waveamdmachine.reg<vgpr, 1>
  %loop:2 = waveamdmachine.uniform_loop if %cond
      : !waveamdmachine.reg<scc, 1>
      carries(%init, %init : !waveamdmachine.reg<vgpr, 1>,
              !waveamdmachine.reg<vgpr, 1>) {
  ^bb0(%lhs: !waveamdmachine.reg<vgpr, 1>,
       %rhs: !waveamdmachine.reg<vgpr, 1>):
    waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
        carries(%lhs, %rhs : !waveamdmachine.reg<vgpr, 1>,
                !waveamdmachine.reg<vgpr, 1>)
  } -> !waveamdmachine.reg<vgpr, 1>,
       !waveamdmachine.reg<vgpr, 1>
  waveamdmachine.s_endpgm
  return
}

}
