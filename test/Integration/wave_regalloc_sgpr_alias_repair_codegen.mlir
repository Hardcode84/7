// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_regalloc_transform_loop},waveamd-pack-vgpr-zero-moves,waveamd-resource-info)' \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm - \
// RUN:   | FileCheck %s --check-prefix=ASM
// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_regalloc_transform_loop},waveamd-pack-vgpr-zero-moves,waveamd-resource-info)' \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm - \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// ASM-LABEL: sgpr_alias_repair:
// ASM-COUNT-2: v_readfirstlane_b32
// ASM: v_add_u32
// ASM-NOT: scratch_
// ASM: wave.regalloc.iterations: 2
// ASM: wave.regalloc.sgpr_to_vgpr.dwords: 2
func.func @sgpr_alias_repair()
    attributes {wave.kernel, wave.workgroup_size = array<i32: 64, 1, 1>,
                waveamdmachine.sgpr_count_max = 2 : i64,
                waveamdmachine.vgpr_count_max = 16 : i64,
                waveamdmachine.agpr_count_max = 0 : i64} {
  %src = waveamdmachine.uninit {waveamdmachine.regalloc_remat_temp}
      : !waveamdmachine.reg<sgpr, 2>
  %parts:2 = waveamdmachine.tuple_to_elements %src
      {waveamdmachine.regalloc_remat_temp}
      : (!waveamdmachine.reg<sgpr, 2>)
        -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
  %canonical = waveamdmachine.v_mov_b32_tuple %parts#0
      {waveamdmachine.regalloc_remat_temp,
       waveamdmachine.regalloc_sgpr_to_vgpr_temp}
      : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %fixed = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2, 0>
  %sunk = waveamdmachine.v_mov_b32_tuple %parts#1
      {waveamdmachine.regalloc_remat_temp,
       waveamdmachine.regalloc_sgpr_to_vgpr_temp}
      : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %duplicate = waveamdmachine.v_mov_b32_tuple %parts#1
      {waveamdmachine.regalloc_remat_temp,
       waveamdmachine.regalloc_sgpr_to_vgpr_temp}
      : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %sum = waveamdmachine.v_add_u32 %canonical, %duplicate
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %fixedV = waveamdmachine.v_mov_b32_tuple %fixed
      : (!waveamdmachine.reg<sgpr, 2, 0>) -> !waveamdmachine.reg<vgpr, 2>
  waveamdmachine.s_endpgm
  return
}

}
