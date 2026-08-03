// RUN: wave-opt %s --pass-pipeline='builtin.module(waveamd-machine-cleanup,waveamd-canonicalize-packed-tuples,canonicalize,waveamd-prepare-regalloc,transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_regalloc_transform_loop},waveamd-resource-info)' \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm - \
// RUN:   | FileCheck %s --check-prefix=ASM
// RUN: wave-opt %s --pass-pipeline='builtin.module(waveamd-machine-cleanup,waveamd-canonicalize-packed-tuples,canonicalize,waveamd-prepare-regalloc,transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_regalloc_transform_loop},waveamd-resource-info)' \
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

// ASM-LABEL: packed_f32_direct_mul_sub_codegen:
// ASM-NOT: v_pk_mul_f32
// ASM: v_pk_fma_f32 {{.*}} neg_lo:[0,0,1] neg_hi:[0,0,1]
// ASM-NOT: v_pk_add_f32
// ASM: v_add_f32
func.func @packed_f32_direct_mul_sub_codegen()
    attributes {wave.kernel, wave.workgroup_size = array<i32: 64, 1, 1>,
                waveamdmachine.target_waves = 4 : i64} {
  %a = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 2>
  %b = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 2>
  %c = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 2>
  %mul = waveamdmachine.v_pk_mul_f32 %a, %b {contract = true}
      : (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>)
        -> !waveamdmachine.reg<vgpr, 2>
  %sub = waveamdmachine.v_pk_add_f32 %mul, %c
      {neg_hi = 2, neg_lo = 2}
      : (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>)
        -> !waveamdmachine.reg<vgpr, 2>
  %parts:2 = waveamdmachine.tuple_to_elements %sub
      : (!waveamdmachine.reg<vgpr, 2>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
  %sum = waveamdmachine.v_add_f32 %parts#0, %parts#1
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  waveamdmachine.v_cmpx_eq_u32 %sum, %sum
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> ()
  waveamdmachine.s_endpgm
  return
}

// ASM-LABEL: packed_f32_tuple_repack_codegen:
// ASM-NOT: v_mov_b32
// ASM: v_pk_fma_f32 {{.*}} op_sel_hi:[1,1,0]
// ASM: v_pk_fma_f32 {{.*}} op_sel:[0,0,1]
// ASM-NOT: v_mov_b32
// ASM: s_endpgm
func.func @packed_f32_tuple_repack_codegen()
    attributes {wave.kernel, wave.workgroup_size = array<i32: 64, 1, 1>,
                waveamdmachine.target_waves = 4 : i64} {
  %a = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 2>
  %b = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 2>
  %c0 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
  %c1 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
  %c_low = waveamdmachine.tuple_from_elements %c0, %c0
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 2>
  %c_high = waveamdmachine.tuple_from_elements %c1, %c1
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 2>
  %low = waveamdmachine.v_pk_fma_f32 %a, %b, %c_low
      : (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>,
         !waveamdmachine.reg<vgpr, 2>) -> !waveamdmachine.reg<vgpr, 2>
  %high = waveamdmachine.v_pk_fma_f32 %a, %b, %c_high
      : (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>,
         !waveamdmachine.reg<vgpr, 2>) -> !waveamdmachine.reg<vgpr, 2>
  %c = waveamdmachine.tuple_from_elements %c0, %c1
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 2>
  %paired = waveamdmachine.v_pk_add_f32 %low, %c
      : (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>)
        -> !waveamdmachine.reg<vgpr, 2>
  %low_parts:2 = waveamdmachine.tuple_to_elements %paired
      : (!waveamdmachine.reg<vgpr, 2>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
  %high_parts:2 = waveamdmachine.tuple_to_elements %high
      : (!waveamdmachine.reg<vgpr, 2>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
  %sum0 = waveamdmachine.v_add_f32 %low_parts#0, %low_parts#1
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %sum1 = waveamdmachine.v_add_f32 %high_parts#0, %high_parts#1
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  waveamdmachine.v_cmpx_eq_u32 %sum0, %sum1
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> ()
  waveamdmachine.s_endpgm
  return
}

}
