// RUN: wave-opt --split-input-file --waveamd-machine-cleanup --cse %s | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// CHECK-LABEL: func.func @hoist_exec_if_local_addr(
// CHECK-SAME: [[COND:%[^:]+]]: !waveamdmachine.reg<sgpr, 1>
// CHECK-SAME: [[X:%[^:]+]]: !waveamdmachine.reg<vgpr, 1>
// CHECK: [[SHIFT:%.*]] = waveamdmachine.imm 12
// CHECK-NEXT: [[ADDR:%.*]] = waveamdmachine.v_lshlrev_b32 [[SHIFT]], [[X]]
// CHECK-NEXT: waveamdmachine.exec_if [[COND]] {
// CHECK-NOT: waveamdmachine.v_lshlrev_b32
// CHECK: waveamdmachine.ds_load_b32 [[ADDR]]
// CHECK: waveamdmachine.ds_load_b32 [[ADDR]]
// CHECK: } : !waveamdmachine.reg<sgpr, 1>
func.func @hoist_exec_if_local_addr(%cond: !waveamdmachine.reg<sgpr, 1>,
                                    %x: !waveamdmachine.reg<vgpr, 1>) {
  waveamdmachine.exec_if %cond {
    %shift = waveamdmachine.imm 12 : !waveamdmachine.imm
    %addr0 = waveamdmachine.v_lshlrev_b32 %shift, %x
        : (!waveamdmachine.imm, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
    %addr1 = waveamdmachine.v_lshlrev_b32 %shift, %x
        : (!waveamdmachine.imm, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
    %load0 = waveamdmachine.ds_load_b32 %addr0
        : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
    %load1 = waveamdmachine.ds_load_b32 %addr1
        : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
    waveamdmachine.yield
  } : !waveamdmachine.reg<sgpr, 1>
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// CHECK-LABEL: func.func @keep_yielded_value(
// CHECK-SAME: [[COND:%[^:]+]]: !waveamdmachine.reg<sgpr, 1>
// CHECK-SAME: [[X:%[^:]+]]: !waveamdmachine.reg<vgpr, 1>
// CHECK: [[SHIFT:%.*]] = waveamdmachine.imm 12
// CHECK-NEXT: [[VALUE:%.*]] = waveamdmachine.exec_if [[COND]] {
// CHECK-NEXT: [[ADDR:%.*]] = waveamdmachine.v_lshlrev_b32 [[SHIFT]], [[X]]
// CHECK-NEXT: waveamdmachine.yield [[ADDR]]
// CHECK: [[SUM:%.*]] = waveamdmachine.v_add_u32 [[VALUE]], [[X]]
// CHECK-NEXT: waveamdmachine.ds_load_b32 [[SUM]]
func.func @keep_yielded_value(%cond: !waveamdmachine.reg<sgpr, 1>,
                              %x: !waveamdmachine.reg<vgpr, 1>) {
  %shift = waveamdmachine.imm 12 : !waveamdmachine.imm
  %value = waveamdmachine.exec_if %cond {
    %addr = waveamdmachine.v_lshlrev_b32 %shift, %x
        : (!waveamdmachine.imm, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
    waveamdmachine.yield %addr : !waveamdmachine.reg<vgpr, 1>
  } : !waveamdmachine.reg<sgpr, 1> -> !waveamdmachine.reg<vgpr, 1>
  %sum = waveamdmachine.v_add_u32 %value, %x
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
      -> !waveamdmachine.reg<vgpr, 1>
  %load = waveamdmachine.ds_load_b32 %sum
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// CHECK-LABEL: func.func @keep_scc_writer(
// CHECK: [[ONE:%.*]] = waveamdmachine.imm 1
// CHECK-NEXT: waveamdmachine.exec_if [[COND:%.*]] {
// CHECK-NEXT: [[SUM:%.*]], [[SCC:%.*]] = waveamdmachine.s_add_i32 [[X:%.*]], [[ONE]]
// CHECK-NEXT: [[VALUE:%.*]] = waveamdmachine.v_mov_b32_tuple [[SUM]]
// CHECK-NEXT: waveamdmachine.ds_store_b32 [[ADDR:%.*]], [[VALUE]]
func.func @keep_scc_writer(%cond: !waveamdmachine.reg<sgpr, 1>,
                           %x: !waveamdmachine.reg<sgpr, 1>,
                           %addr: !waveamdmachine.reg<vgpr, 1>) {
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  waveamdmachine.exec_if %cond {
    %sum, %scc = waveamdmachine.s_add_i32 %x, %one
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
        -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %value = waveamdmachine.v_mov_b32_tuple %sum {registers = 1 : i64}
        : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
    %store = waveamdmachine.ds_store_b32 %addr, %value
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.mem.token
    waveamdmachine.yield
  } : !waveamdmachine.reg<sgpr, 1>
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// CHECK-LABEL: func.func @keep_exec_dependent_readfirstlane(
// CHECK-SAME: [[COND:%[^:]+]]: !waveamdmachine.reg<sgpr, 1>
// CHECK-SAME: [[X:%[^:]+]]: !waveamdmachine.reg<vgpr, 1>
// CHECK: waveamdmachine.exec_if [[COND]] {
// CHECK-NEXT: [[FIRST:%.*]] = waveamdmachine.v_readfirstlane_b32 [[X]]
// CHECK-NEXT: [[VALUE:%.*]] = waveamdmachine.v_mov_b32_tuple [[FIRST]]
// CHECK-NEXT: waveamdmachine.ds_store_b32
func.func @keep_exec_dependent_readfirstlane(
    %cond: !waveamdmachine.reg<sgpr, 1>,
    %x: !waveamdmachine.reg<vgpr, 1>,
    %addr: !waveamdmachine.reg<vgpr, 1>) {
  waveamdmachine.exec_if %cond {
    %first = waveamdmachine.v_readfirstlane_b32 %x
        : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
    %value = waveamdmachine.v_mov_b32_tuple %first {registers = 1 : i64}
        : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
    %store = waveamdmachine.ds_store_b32 %addr, %value
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.mem.token
    waveamdmachine.yield
  } : !waveamdmachine.reg<sgpr, 1>
  return
}

}
