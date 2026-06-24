// RUN: wave-opt --waveamd-reg-alloc='sgpr-limit=2 vgpr-limit=1 agpr-limit=8' %s | FileCheck %s --implicit-check-not='waveamd-reg-alloc ran out' --implicit-check-not='unsupported promotion SGPR -> AGPR'

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// CHECK-LABEL: func.func @sgpr_chain_promotion_probe
// CHECK-SAME: waveamdmachine.regalloc_assignments
// CHECK: [[A:%.*]] = waveamdmachine.s_mov_b32_value
// CHECK: [[AV:%.*]] = waveamdmachine.v_mov_b32_tuple [[A]]
// CHECK: [[AA:%.*]] = waveamdmachine.v_accvgpr_write_b32_tuple [[AV]]
// CHECK: [[B:%.*]] = waveamdmachine.s_mov_b32_value
// CHECK: [[BV:%.*]] = waveamdmachine.v_mov_b32_tuple [[B]]
// CHECK: [[BA:%.*]] = waveamdmachine.v_accvgpr_write_b32_tuple [[BV]]
// CHECK: [[C:%.*]] = waveamdmachine.s_mov_b32_value
// CHECK: [[CV:%.*]] = waveamdmachine.v_mov_b32_tuple [[C]]
// CHECK: [[CA:%.*]] = waveamdmachine.v_accvgpr_write_b32_tuple [[CV]]
// CHECK: [[AR:%.*]] = waveamdmachine.v_accvgpr_read_b32_tuple [[AA]]
// CHECK: [[AS:%.*]] = waveamdmachine.v_readfirstlane_b32 [[AR]]
// CHECK: waveamdmachine.exec_if [[AS]]
// CHECK: [[BR:%.*]] = waveamdmachine.v_accvgpr_read_b32_tuple [[BA]]
// CHECK: [[BS:%.*]] = waveamdmachine.v_readfirstlane_b32 [[BR]]
// CHECK: waveamdmachine.exec_if [[BS]]
// CHECK: [[CR:%.*]] = waveamdmachine.v_accvgpr_read_b32_tuple [[CA]]
// CHECK: [[CS:%.*]] = waveamdmachine.v_readfirstlane_b32 [[CR]]
// CHECK: waveamdmachine.exec_if [[CS]]
func.func @sgpr_chain_promotion_probe() {
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %a = waveamdmachine.s_mov_b32_value %one
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %b = waveamdmachine.s_mov_b32_value %one
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %c = waveamdmachine.s_mov_b32_value %one
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  waveamdmachine.exec_if %a {
    waveamdmachine.yield
  } : !waveamdmachine.reg<sgpr, 1>
  waveamdmachine.exec_if %b {
    waveamdmachine.yield
  } : !waveamdmachine.reg<sgpr, 1>
  waveamdmachine.exec_if %c {
    waveamdmachine.yield
  } : !waveamdmachine.reg<sgpr, 1>
  return
}

}
