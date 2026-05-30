// RUN: wave-opt --waveamd-preserve-hw-regs -split-input-file %s | FileCheck %s
// RUN: wave-opt --waveamd-preserve-hw-regs --waveamd-reg-alloc -split-input-file %s >/dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @preserve_scc
// CHECK: %[[SCC:.+]] = waveamdmachine.s_cmp_lt_i32
// CHECK: %[[ONE:.+]] = waveamdmachine.imm 1 : !waveamdmachine.imm
// CHECK: %[[ZERO:.+]] = waveamdmachine.imm 0 : !waveamdmachine.imm
// CHECK: %[[SAVED:.+]] = waveamdmachine.s_cselect_b32 %[[SCC]], %[[ONE]], %[[ZERO]]
// CHECK: %[[SUM:.+]], %[[SUM_SCC:.+]] = waveamdmachine.s_add_i32
// CHECK: %[[RELOAD_ZERO:.+]] = waveamdmachine.imm 0 : !waveamdmachine.imm
// CHECK: %[[RELOADED:.+]] = waveamdmachine.s_cmp_lg_u32 %[[SAVED]], %[[RELOAD_ZERO]]
// CHECK: waveamdmachine.s_cbranch_scc1 %[[RELOADED]]
func.func @preserve_scc(%a: !waveamdmachine.reg<sgpr, 1>,
                        %b: !waveamdmachine.reg<sgpr, 1>) {
  %scc = waveamdmachine.s_cmp_lt_i32 %a, %b
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
        -> !waveamdmachine.reg<scc, 1>
  %sum, %sum_scc = waveamdmachine.s_add_i32 %a, %b
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  waveamdmachine.s_cbranch_scc1 %scc : !waveamdmachine.reg<scc, 1>, "taken"
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @preserve_vcc
// CHECK: %[[SUM0:.+]], %[[VCC0:.+]] = waveamdmachine.v_add_u64
// CHECK: %[[SAVED:.+]] = waveamdmachine.s_read_vcc_b32 %[[VCC0]]
// CHECK: %[[SUM1:.+]], %[[VCC1:.+]] = waveamdmachine.v_add_u64
// CHECK: %[[RELOADED:.+]] = waveamdmachine.s_mov_vcc_b32 %[[SAVED]]
// CHECK: return %[[RELOADED]]
func.func @preserve_vcc(%a: !waveamdmachine.reg<vgpr, 2>,
                        %b: !waveamdmachine.reg<vgpr, 2>,
                        %c: !waveamdmachine.reg<vgpr, 2>)
    -> !waveamdmachine.reg<vcc, 1> {
  %sum0, %vcc0 = waveamdmachine.v_add_u64 %a, %b
      : (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>)
        -> (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vcc, 1>)
  %sum1, %vcc1 = waveamdmachine.v_add_u64 %a, %c
      : (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>)
        -> (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vcc, 1>)
  return %vcc0 : !waveamdmachine.reg<vcc, 1>
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @preserve_m0
// CHECK: %[[M0A:.+]] = waveamdmachine.s_mov_m0 [[DST0:%.*]]
// CHECK: %[[M0B:.+]] = waveamdmachine.s_mov_m0 [[DST1:%.*]]
// CHECK: %[[RELOADED:.+]] = waveamdmachine.s_mov_m0 [[DST0]]
// CHECK: %[[TOK:.+]] = waveamdmachine.global_load_lds_b32 {{.*}}, {{.*}}, %[[RELOADED]]
func.func @preserve_m0(%off: !waveamdmachine.reg<vgpr, 1>,
                       %base: !waveamdmachine.reg<sgpr, 2>,
                       %dst0: !waveamdmachine.reg<sgpr, 1>,
                       %dst1: !waveamdmachine.reg<sgpr, 1>,
                       %dep: !waveamdmachine.mem.token) {
  %m0a = waveamdmachine.s_mov_m0 %dst0
      : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.m0
  %m0b = waveamdmachine.s_mov_m0 %dst1
      : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.m0
  %tok = waveamdmachine.global_load_lds_b32 %off, %base, %m0a after %dep
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.m0, !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  return
}

}
