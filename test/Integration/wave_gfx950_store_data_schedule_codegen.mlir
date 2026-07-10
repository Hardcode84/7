// RUN: wave-opt %s --waveamd-machine-schedule='apply-schedule=1' \
// RUN:   --waveamd-insert-hazard-waits --waveamd-resource-info \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm - \
// RUN:   | FileCheck %s --check-prefix=ASM
// RUN: wave-opt %s --waveamd-machine-schedule='apply-schedule=1' \
// RUN:   --waveamd-insert-hazard-waits --waveamd-resource-info \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm - \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// ASM-LABEL: store_data_schedule_codegen:
// ASM: buffer_store_dwordx4 v[4:7], v1
// ASM-NEXT: v_mul_lo_u32 v0
// ASM-NEXT: v_lshl_add_u32 v0
// ASM-NEXT: v_cvt_pk_f16_f32 v4
// ASM-NEXT: v_cvt_pk_f16_f32 v5
// ASM-NEXT: v_cvt_pk_f16_f32 v6
// ASM-NEXT: v_cvt_pk_f16_f32 v7
// ASM-NOT: s_nop
// ASM-NEXT: buffer_store_dwordx4 v[4:7], v0
func.func @store_data_schedule_codegen() attributes {wave.kernel} {
  %off0 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 1>
  %data0 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4, 4>
  %desc = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 4, 0>
  %x = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 8>
  %y = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 9>
  %stride = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 1, 4>
  %index = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 10>
  %base = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 11>
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %tok0 = waveamdmachine.buffer_store_b128 %off0, %data0, %desc, %zero
      : (!waveamdmachine.reg<vgpr, 1, 1>, !waveamdmachine.reg<vgpr, 4, 4>,
         !waveamdmachine.reg<sgpr, 4, 0>, !waveamdmachine.imm)
        -> !waveamdmachine.mem.token
  %p0 = waveamdmachine.v_cvt_pk_f16_f32 %x, %y
      : (!waveamdmachine.reg<vgpr, 1, 8>, !waveamdmachine.reg<vgpr, 1, 9>)
        -> !waveamdmachine.reg<vgpr, 1, 4>
  %p1 = waveamdmachine.v_cvt_pk_f16_f32 %x, %y
      : (!waveamdmachine.reg<vgpr, 1, 8>, !waveamdmachine.reg<vgpr, 1, 9>)
        -> !waveamdmachine.reg<vgpr, 1, 5>
  %p2 = waveamdmachine.v_cvt_pk_f16_f32 %x, %y
      : (!waveamdmachine.reg<vgpr, 1, 8>, !waveamdmachine.reg<vgpr, 1, 9>)
        -> !waveamdmachine.reg<vgpr, 1, 6>
  %p3 = waveamdmachine.v_cvt_pk_f16_f32 %x, %y
      : (!waveamdmachine.reg<vgpr, 1, 8>, !waveamdmachine.reg<vgpr, 1, 9>)
        -> !waveamdmachine.reg<vgpr, 1, 7>
  %data1 = waveamdmachine.tuple_from_elements %p0, %p1, %p2, %p3
      : (!waveamdmachine.reg<vgpr, 1, 4>,
         !waveamdmachine.reg<vgpr, 1, 5>,
         !waveamdmachine.reg<vgpr, 1, 6>,
         !waveamdmachine.reg<vgpr, 1, 7>)
        -> !waveamdmachine.reg<vgpr, 4, 4>
  %scaled = waveamdmachine.v_mul_lo_u32 %stride, %index
      : (!waveamdmachine.reg<sgpr, 1, 4>, !waveamdmachine.reg<vgpr, 1, 10>)
        -> !waveamdmachine.reg<vgpr, 1, 0>
  %off1 = waveamdmachine.v_lshl_add_u32 %scaled, %one, %base
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.imm,
         !waveamdmachine.reg<vgpr, 1, 11>) -> !waveamdmachine.reg<vgpr, 1, 0>
  %tok1 = waveamdmachine.buffer_store_b128 %off1, %data1, %desc, %zero
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<vgpr, 4, 4>,
         !waveamdmachine.reg<sgpr, 4, 0>, !waveamdmachine.imm)
        -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm
  return
}

}
