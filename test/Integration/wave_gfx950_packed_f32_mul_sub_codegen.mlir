// RUN: wave-opt %s --pass-pipeline='builtin.module(waveamd-machine-cleanup,waveamd-prepare-regalloc,transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_regalloc_transform_loop},waveamd-resource-info)' \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm - \
// RUN:   | FileCheck %s --check-prefix=ASM
// RUN: wave-opt %s --pass-pipeline='builtin.module(waveamd-machine-cleanup,waveamd-prepare-regalloc,transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_regalloc_transform_loop},waveamd-resource-info)' \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm - \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// ASM-LABEL: packed_f32_mul_sub_codegen:
// ASM-NOT: v_pk_mul_f32
// ASM: v_pk_fma_f32 {{.*}} neg_lo:[0,0,1] neg_hi:[0,0,1]
// ASM-NOT: v_sub_f32
// ASM: v_add_f32
func.func @packed_f32_mul_sub_codegen()
    attributes {wave.kernel, wave.workgroup_size = array<i32: 64, 1, 1>,
                waveamdmachine.target_waves = 4 : i64} {
  %a = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 2>
  %b = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 2>
  %c0 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
  %c1 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
  %mul = waveamdmachine.v_pk_mul_f32 %a, %b {contract = true}
      : (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>)
        -> !waveamdmachine.reg<vgpr, 2>
  %parts:2 = waveamdmachine.tuple_to_elements %mul
      : (!waveamdmachine.reg<vgpr, 2>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
  %lo = waveamdmachine.v_sub_f32 %parts#0, %c0
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %hi = waveamdmachine.v_sub_f32 %parts#1, %c1
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %sum = waveamdmachine.v_add_f32 %lo, %hi
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  waveamdmachine.v_cmpx_eq_u32 %sum, %sum
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> ()
  waveamdmachine.s_endpgm
  return
}

}
