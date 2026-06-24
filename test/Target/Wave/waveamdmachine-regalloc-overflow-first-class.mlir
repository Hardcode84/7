// RUN: rm -f %t.yaml
// RUN: wave-opt --waveamd-reg-alloc='mark-overflow=true sgpr-limit=2 vgpr-limit=2' \
// RUN:   --remarks-filter=waveamdmachine-regalloc --remark-policy=all --remark-format=yaml \
// RUN:   --remarks-output-file=%t.yaml %s | FileCheck %s
// RUN: FileCheck %s --input-file=%t.yaml --check-prefix=REMARK

// CHECK: module
// CHECK-SAME: waveamdmachine.regalloc_overflowed_count = 1 : i64
// CHECK-LABEL: func.func @sgpr_promotes_then_vgpr_overflows
// CHECK-SAME: waveamdmachine.regalloc_overflowed = 1 : i64
// CHECK-NOT: waveamdmachine.regalloc_pressure_

// REMARK: Name:            regalloc-pressure-failure
// REMARK: Function:        sgpr_promotes_then_vgpr_overflows
// REMARK: class:           VGPR
// REMARK: limit:           '2'
// REMARK: position:        '6'
// REMARK: required_relief: '1'

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

func.func @sgpr_promotes_then_vgpr_overflows() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %s0 = waveamdmachine.s_mov_b32_value %zero
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %s1 = waveamdmachine.s_mov_b32_value %zero
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %s2 = waveamdmachine.s_mov_b32_value %zero
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %v0 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
  %v1 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
  %v2 = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
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
