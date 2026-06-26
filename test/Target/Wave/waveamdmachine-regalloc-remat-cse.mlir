// RUN: wave-opt --canonicalize --cse %s | FileCheck %s --check-prefix=CSE
// RUN: wave-opt --canonicalize --cse \
// RUN:   --waveamd-reg-alloc='mark-overflow=true vgpr-limit=4 agpr-limit=0' \
// RUN:   --waveamd-resource-info %s | FileCheck %s --check-prefix=REGALLOC

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CSE-LABEL: func.func @loop_spanning_cse_remat
// CSE: [[ZERO:%.*]] = waveamdmachine.imm 0
// CSE: [[ONE:%.*]] = waveamdmachine.imm 1
// CSE: [[SEVEN:%.*]] = waveamdmachine.imm 7
// CSE: [[CSE_LANE:%.*]] = waveamdmachine.v_mov_b32_tuple [[ZERO]]
// CSE-NEXT: [[CSE_MUL:%.*]] = waveamdmachine.v_mul_lo_u32 [[CSE_LANE]], [[SEVEN]]
// CSE-NEXT: [[CSE_ADDR:%.*]] = waveamdmachine.v_lshlrev_b32 [[CSE_MUL]], [[ONE]]
// CSE: waveamdmachine.uniform_loop
// CSE-NOT: waveamdmachine.v_lshlrev_b32
// CSE: waveamdmachine.v_readfirstlane_b32 [[CSE_ADDR]]

// REGALLOC-LABEL: func.func @loop_spanning_cse_remat
// REGALLOC-SAME: waveamdmachine.regalloc_assignments
// REGALLOC-NOT: waveamdmachine.regalloc_overflowed
// REGALLOC: [[R_ZERO:%.*]] = waveamdmachine.imm 0
// REGALLOC: [[R_ONE:%.*]] = waveamdmachine.imm 1
// REGALLOC: [[R_SEVEN:%.*]] = waveamdmachine.imm 7
// REGALLOC: [[R_LANE0:%.*]] = waveamdmachine.v_mov_b32_tuple [[R_ZERO]]
// REGALLOC-NEXT: [[R_MUL0:%.*]] = waveamdmachine.v_mul_lo_u32 [[R_LANE0]], [[R_SEVEN]]
// REGALLOC-NEXT: [[R_ADDR0:%.*]] = waveamdmachine.v_lshlrev_b32 [[R_MUL0]], [[R_ONE]]
// REGALLOC-NEXT: waveamdmachine.v_readfirstlane_b32 [[R_ADDR0]]
// REGALLOC: waveamdmachine.uniform_loop
// REGALLOC-NOT: waveamdmachine.v_lshlrev_b32
// REGALLOC: waveamdmachine.continue_if
// REGALLOC: [[R_LANE1:%.*]] = waveamdmachine.v_mov_b32_tuple [[R_ZERO]]
// REGALLOC-NEXT: [[R_MUL1:%.*]] = waveamdmachine.v_mul_lo_u32 [[R_LANE1]], [[R_SEVEN]]
// REGALLOC-NEXT: [[R_ADDR1:%.*]] = waveamdmachine.v_lshlrev_b32 [[R_MUL1]], [[R_ONE]]
// REGALLOC-NEXT: waveamdmachine.v_readfirstlane_b32 [[R_ADDR1]]
func.func @loop_spanning_cse_remat()
    attributes {wave.kernel, waveamdmachine.target_waves = 4 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %two = waveamdmachine.imm 2 : !waveamdmachine.imm
  %three = waveamdmachine.imm 3 : !waveamdmachine.imm
  %four = waveamdmachine.imm 4 : !waveamdmachine.imm
  %five = waveamdmachine.imm 5 : !waveamdmachine.imm
  %seven = waveamdmachine.imm 7 : !waveamdmachine.imm
  %lane0 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %mul0 = waveamdmachine.v_mul_lo_u32 %lane0, %seven
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
        -> !waveamdmachine.reg<vgpr, 1>
  %addr0 = waveamdmachine.v_lshlrev_b32 %mul0, %one
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
        -> !waveamdmachine.reg<vgpr, 1>
  %pre = waveamdmachine.v_readfirstlane_b32 %addr0
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
  %cond = waveamdmachine.s_cmp_lt_i32 %zero, %one
      : (!waveamdmachine.imm, !waveamdmachine.imm)
        -> !waveamdmachine.reg<scc, 1>
  waveamdmachine.uniform_loop if %cond : !waveamdmachine.reg<scc, 1> {
    %v0 = waveamdmachine.v_mov_b32_tuple %two {registers = 1 : i64}
        : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
    %v1 = waveamdmachine.v_mov_b32_tuple %three {registers = 1 : i64}
        : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
    %v2 = waveamdmachine.v_mov_b32_tuple %four {registers = 1 : i64}
        : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
    %v3 = waveamdmachine.v_mov_b32_tuple %five {registers = 1 : i64}
        : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
    %s0 = waveamdmachine.v_readfirstlane_b32 %v0
        : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
    %s1 = waveamdmachine.v_readfirstlane_b32 %v1
        : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
    %s2 = waveamdmachine.v_readfirstlane_b32 %v2
        : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
    %s3 = waveamdmachine.v_readfirstlane_b32 %v3
        : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
    waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
  }
  %lane1 = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %mul1 = waveamdmachine.v_mul_lo_u32 %lane1, %seven
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
        -> !waveamdmachine.reg<vgpr, 1>
  %addr1 = waveamdmachine.v_lshlrev_b32 %mul1, %one
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
        -> !waveamdmachine.reg<vgpr, 1>
  %post = waveamdmachine.v_readfirstlane_b32 %addr1
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
  waveamdmachine.s_endpgm
  return
}

}
