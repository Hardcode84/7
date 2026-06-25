// RUN: wave-opt --waveamd-reg-alloc='mark-overflow=true agpr-limit=1' \
// RUN:   --waveamd-resource-info %s | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// CHECK-LABEL: func.func @agpr_temp_does_not_memory_spill
// CHECK-SAME: waveamdmachine.regalloc_overflowed = 1 : i64
// CHECK-NOT: waveamdmachine.lds_spill_bytes
// CHECK-NOT: waveamdmachine.scratch_spill_bytes
// CHECK: [[AG0:%.*]] = waveamdmachine.v_accvgpr_write_b32_tuple
// CHECK: [[AG1:%.*]] = waveamdmachine.v_accvgpr_write_b32_tuple
// CHECK: waveamdmachine.v_accvgpr_read_b32_tuple [[AG0]]
// CHECK: waveamdmachine.v_accvgpr_read_b32_tuple [[AG1]]
// CHECK-NOT: waveamdmachine.ds_store_b32
// CHECK-NOT: waveamdmachine.scratch_store_b32
func.func @agpr_temp_does_not_memory_spill() attributes {wave.kernel} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %src0 = waveamdmachine.v_mov_b32_tuple %zero
      {registers = 1 : i64, waveamdmachine.regalloc_debug_temp}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %src1 = waveamdmachine.v_mov_b32_tuple %zero
      {registers = 1 : i64, waveamdmachine.regalloc_debug_temp}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %ag0 = waveamdmachine.v_accvgpr_write_b32_tuple %src0
      {waveamdmachine.regalloc_debug_temp}
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<agpr, 1>
  %ag1 = waveamdmachine.v_accvgpr_write_b32_tuple %src1
      {waveamdmachine.regalloc_debug_temp}
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<agpr, 1>
  %read0 = waveamdmachine.v_accvgpr_read_b32_tuple %ag0
      : (!waveamdmachine.reg<agpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %read1 = waveamdmachine.v_accvgpr_read_b32_tuple %ag1
      : (!waveamdmachine.reg<agpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %sum = waveamdmachine.v_add_u32 %read0, %read1
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  waveamdmachine.s_endpgm
  return
}

}
