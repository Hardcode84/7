// RUN: wave-opt --waveamd-reg-alloc='vgpr-limit=2 agpr-limit=0' \
// RUN:   --waveamd-resource-info %s | FileCheck %s \
// RUN:   --implicit-check-not=waveamdmachine.regalloc_overflowed \
// RUN:   --implicit-check-not=waveamdmachine.lds_spill_bytes \
// RUN:   --implicit-check-not=waveamdmachine.scratch_spill_bytes \
// RUN:   --implicit-check-not=waveamdmachine.ds_ \
// RUN:   --implicit-check-not=waveamdmachine.scratch_

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// CHECK-LABEL: func.func @noncombined_vgpr_remat_before_memory_spill
// CHECK-SAME: waveamdmachine.agpr_count = 0 : i64
// CHECK-SAME: waveamdmachine.regalloc_assignments
// CHECK-SAME: waveamdmachine.vgpr_count = 2 : i64
// CHECK: [[ZERO:%.*]] = waveamdmachine.imm 0
// CHECK: [[ROOT0:%.*]] = waveamdmachine.v_mov_b32_tuple [[ZERO]]
// CHECK: waveamdmachine.v_mov_b32_tuple [[ROOT0]]
// CHECK: [[ROOT1:%.*]] = waveamdmachine.v_mov_b32_tuple [[ZERO]]
// CHECK: waveamdmachine.v_mov_b32_tuple [[ROOT1]]
// CHECK: [[ROOT2:%.*]] = waveamdmachine.v_mov_b32_tuple [[ZERO]]
// CHECK: waveamdmachine.v_mov_b32_tuple [[ROOT2]]
func.func @noncombined_vgpr_remat_before_memory_spill()
    attributes {wave.kernel, wave.workgroup_size = array<i32: 64, 1, 1>,
                waveamdmachine.target_waves = 4 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %v0 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v1 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v2 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %use0 = waveamdmachine.v_mov_b32_tuple %v0 {registers = 1 : i64}
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %use1 = waveamdmachine.v_mov_b32_tuple %v1 {registers = 1 : i64}
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %use2 = waveamdmachine.v_mov_b32_tuple %v2 {registers = 1 : i64}
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  return
}

}
