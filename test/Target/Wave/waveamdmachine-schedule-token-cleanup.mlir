// RUN: wave-opt %s --waveamd-prepare-regalloc | FileCheck %s
// RUN: wave-opt %s --waveamd-machine-schedule='apply-schedule=true require-selected-input=true' --waveamd-prepare-regalloc | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @shared_tree
// CHECK-NEXT: %[[TOKEN:.*]] = waveamdmachine.token
// CHECK-NEXT: return %[[TOKEN]]
func.func @shared_tree(%arg: !waveamdmachine.reg<sgpr, 1>)
    -> !waveamdmachine.mem.token {
  %two = waveamdmachine.imm 2 : !waveamdmachine.imm
  %a = waveamdmachine.s_mul_i32 %arg, %two
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
      -> !waveamdmachine.reg<sgpr, 1>
  %b = waveamdmachine.s_mul_i32 %a, %two
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
      -> !waveamdmachine.reg<sgpr, 1>
  %ordered = waveamdmachine.schedule_token %b, %a
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
      -> !waveamdmachine.mem.token
  return %ordered : !waveamdmachine.mem.token
}

// CHECK-LABEL: func.func @live_producer
// CHECK: %[[LIVE:.*]] = waveamdmachine.s_mul_i32
// CHECK-NOT: waveamdmachine.s_mul_i32
// CHECK: %[[TOKEN:.*]] = waveamdmachine.token
// CHECK-NEXT: return %[[LIVE]], %[[TOKEN]]
func.func @live_producer(%arg: !waveamdmachine.reg<sgpr, 1>)
    -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.mem.token) {
  %two = waveamdmachine.imm 2 : !waveamdmachine.imm
  %a = waveamdmachine.s_mul_i32 %arg, %two
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
      -> !waveamdmachine.reg<sgpr, 1>
  %b = waveamdmachine.s_mul_i32 %a, %two
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
      -> !waveamdmachine.reg<sgpr, 1>
  %ordered = waveamdmachine.schedule_token %b, %a
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
      -> !waveamdmachine.mem.token
  return %a, %ordered
      : !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.mem.token
}

}
