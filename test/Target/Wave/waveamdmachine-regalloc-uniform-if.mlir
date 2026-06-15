// RUN: wave-opt --waveamd-reg-alloc --split-input-file %s | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @uniform_if_sgpr_live_through
// CHECK: %[[X:.*]] = waveamdmachine.s_mov_b32_value {{.*}} -> !waveamdmachine.reg<sgpr, 1, {{[0-9]+}}>
// CHECK: %[[Y:.*]] = waveamdmachine.s_mov_b32_value {{.*}} -> !waveamdmachine.reg<sgpr, 1, {{[0-9]+}}>
// CHECK: %[[R:.*]] = waveamdmachine.uniform_if
// CHECK: %[[TCOPY:.*]] = waveamdmachine.s_mov_b32_tuple %[[X]] {{.*}} -> !waveamdmachine.reg<sgpr, 1, [[#RREG:]]>
// CHECK: waveamdmachine.yield %[[TCOPY]] : !waveamdmachine.reg<sgpr, 1, [[#RREG]]>
// CHECK: %[[ECOPY:.*]] = waveamdmachine.s_mov_b32_tuple %[[Y]] {{.*}} -> !waveamdmachine.reg<sgpr, 1, [[#RREG]]>
// CHECK: waveamdmachine.yield %[[ECOPY]] : !waveamdmachine.reg<sgpr, 1, [[#RREG]]>
// CHECK: } : !waveamdmachine.reg<scc, 1> -> !waveamdmachine.reg<sgpr, 1, [[#RREG]]>
// CHECK: waveamdmachine.s_add_i32 %[[R]], %[[X]]
func.func @uniform_if_sgpr_live_through(%cond: !waveamdmachine.reg<scc, 1>)
    attributes {wave.kernel} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %x = waveamdmachine.s_mov_b32_value %zero
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %y = waveamdmachine.s_mov_b32_value %one
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %r = waveamdmachine.uniform_if %cond {
    waveamdmachine.yield %x : !waveamdmachine.reg<sgpr, 1>
  } otherwise {
    waveamdmachine.yield %y : !waveamdmachine.reg<sgpr, 1>
  } : !waveamdmachine.reg<scc, 1> -> !waveamdmachine.reg<sgpr, 1>
  %sum, %scc = waveamdmachine.s_add_i32 %r, %x
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  waveamdmachine.s_endpgm
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @uniform_if_vgpr_live_through
// CHECK: %[[X:.*]] = waveamdmachine.v_mov_b32_tuple {{.*}} -> !waveamdmachine.reg<vgpr, 1, {{[0-9]+}}>
// CHECK: %[[Y:.*]] = waveamdmachine.v_mov_b32_tuple {{.*}} -> !waveamdmachine.reg<vgpr, 1, {{[0-9]+}}>
// CHECK: %[[R:.*]] = waveamdmachine.uniform_if
// CHECK: %[[TCOPY:.*]] = waveamdmachine.v_mov_b32_tuple {{.*}} -> !waveamdmachine.reg<vgpr, 1, [[#RREG:]]>
// CHECK: waveamdmachine.yield %[[TCOPY]] : !waveamdmachine.reg<vgpr, 1, [[#RREG]]>
// CHECK: %[[ECOPY:.*]] = waveamdmachine.v_mov_b32_tuple {{.*}} -> !waveamdmachine.reg<vgpr, 1, [[#RREG]]>
// CHECK: waveamdmachine.yield %[[ECOPY]] : !waveamdmachine.reg<vgpr, 1, [[#RREG]]>
// CHECK: } : !waveamdmachine.reg<scc, 1> -> !waveamdmachine.reg<vgpr, 1, [[#RREG]]>
// CHECK: waveamdmachine.v_add_u32 %[[R]], %[[X]]
func.func @uniform_if_vgpr_live_through(%cond: !waveamdmachine.reg<scc, 1>)
    attributes {wave.kernel} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %x = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %y = waveamdmachine.v_mov_b32_tuple %one {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %r = waveamdmachine.uniform_if %cond {
    waveamdmachine.yield %x : !waveamdmachine.reg<vgpr, 1>
  } otherwise {
    waveamdmachine.yield %y : !waveamdmachine.reg<vgpr, 1>
  } : !waveamdmachine.reg<scc, 1> -> !waveamdmachine.reg<vgpr, 1>
  %sum = waveamdmachine.v_add_u32 %r, %x
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  waveamdmachine.s_endpgm
  return
}

}
