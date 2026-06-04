// RUN: wave-opt --waveamd-reg-alloc='mark-overflow=true sgpr-limit=2 vgpr-limit=2' %s | FileCheck %s

// CHECK: module
// CHECK-SAME: waveamdmachine.regalloc_overflowed_count = 1 : i64
// CHECK-LABEL: func.func @sgpr_overflow_reported_before_vgpr
// CHECK-SAME: waveamdmachine.regalloc_pressure_class = "SGPR"
// CHECK-SAME: waveamdmachine.regalloc_pressure_limit = 2 : i64
// CHECK-SAME: waveamdmachine.regalloc_pressure_position = 3 : i64
// CHECK-SAME: waveamdmachine.regalloc_pressure_required_relief = 1 : i64

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

func.func @sgpr_overflow_reported_before_vgpr() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %s0 = waveamdmachine.s_mov_b32_value %zero
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %s1 = waveamdmachine.s_mov_b32_value %zero
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %s2 = waveamdmachine.s_mov_b32_value %zero
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %v0 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v1 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %v2 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %use_s0 = waveamdmachine.s_mov_b32_value %s0
      : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
  %use_s1 = waveamdmachine.s_mov_b32_value %s1
      : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
  %use_s2 = waveamdmachine.s_mov_b32_value %s2
      : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
  %use_v0 = waveamdmachine.v_mov_b32_tuple %v0 {registers = 1 : i64}
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %use_v1 = waveamdmachine.v_mov_b32_tuple %v1 {registers = 1 : i64}
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %use_v2 = waveamdmachine.v_mov_b32_tuple %v2 {registers = 1 : i64}
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  return
}

}
