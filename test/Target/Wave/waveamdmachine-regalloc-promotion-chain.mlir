// RUN: wave-opt --waveamd-reg-alloc='mark-overflow=true sgpr-limit=2 vgpr-limit=1 agpr-limit=8' %s | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// CHECK-LABEL: func.func @sgpr_chain_promotion_probe
// CHECK-SAME: waveamdmachine.regalloc_overflowed = 1 : i64
// CHECK: [[A:%.*]] = waveamdmachine.s_mov_b32_value
// CHECK: [[AV:%.*]] = waveamdmachine.v_mov_b32_tuple [[A]]
// CHECK: [[B:%.*]] = waveamdmachine.s_mov_b32_value
// CHECK: [[C:%.*]] = waveamdmachine.s_mov_b32_value
// CHECK-NOT: waveamdmachine.v_accvgpr_write_b32_tuple
// CHECK: [[AS:%.*]] = waveamdmachine.v_readfirstlane_b32 [[AV]]
// CHECK: waveamdmachine.exec_if [[AS]]
// CHECK: waveamdmachine.exec_if [[B]]
// CHECK: waveamdmachine.exec_if [[C]]
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
