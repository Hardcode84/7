// RUN: wave-opt --waveamd-reg-alloc -split-input-file %s | FileCheck %s
// RUN: wave-opt --waveamd-reg-alloc='mark-overflow=true vgpr-limit=3' -split-input-file %s | FileCheck %s --check-prefix=PROMOTE
// RUN: wave-opt --waveamd-reg-alloc='sgpr-limit=2' -split-input-file %s | FileCheck %s --check-prefix=SGPRPROMOTE
// RUN: wave-opt --waveamd-reg-alloc='mark-overflow=true vgpr-limit=3 agpr-limit=0' -split-input-file %s | FileCheck %s --check-prefix=OVERFLOW

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// CHECK-LABEL: func.func @cfg_non_entry_block
// CHECK: cf.br
// CHECK: [[LATE:%.*]] = waveamdmachine.v_mov_b32_tuple
// CHECK-SAME: -> !waveamdmachine.reg<vgpr, 1, 0>
func.func @cfg_non_entry_block() {
  cf.br ^later
^later:
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %late = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// CHECK-LABEL: func.func @generic_region_body
// CHECK: scf.if
// CHECK: [[INNER:%.*]] = waveamdmachine.v_mov_b32_tuple
// CHECK-SAME: -> !waveamdmachine.reg<vgpr, 1, 0>
func.func @generic_region_body() {
  %cond = arith.constant true
  scf.if %cond {
    %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
    %inner = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
        : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
    scf.yield
  }
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// SGPRPROMOTE-LABEL: func.func @sgpr_promote
// SGPRPROMOTE: waveamdmachine.v_mov_b32_tuple
// SGPRPROMOTE: waveamdmachine.v_readfirstlane_b32
func.func @sgpr_promote() {
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %a = waveamdmachine.s_mov_b32_value %one
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %b = waveamdmachine.s_mov_b32_value %one
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  waveamdmachine.exec_if %a {
    waveamdmachine.yield
  } : !waveamdmachine.reg<sgpr, 1>
  waveamdmachine.exec_if %b {
    waveamdmachine.yield
  } : !waveamdmachine.reg<sgpr, 1>
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// PROMOTE-LABEL: func.func @promote_direct_agpr
// PROMOTE: !waveamdmachine.reg<agpr, 4, 0>
func.func @promote_direct_agpr() {
  %value = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4>
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// CHECK-LABEL: func.func @live_in
func.func @live_in(%arg0: !waveamdmachine.reg<vgpr, 1>) {
  %copy = waveamdmachine.v_mov_b32_tuple %arg0 {registers = 1 : i64}
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// CHECK-LABEL: func.func @live_in_tuple_alias
// CHECK-SAME: ([[ARG0:%.*]]: !waveamdmachine.reg<vgpr, 1>, [[ARG1:%.*]]: !waveamdmachine.reg<vgpr, 1>)
// CHECK: [[TUPLE:%.*]] = waveamdmachine.tuple_from_elements [[ARG0]], [[ARG1]]
// CHECK-SAME: -> !waveamdmachine.reg<vgpr, 2, 0>
func.func @live_in_tuple_alias(%arg0: !waveamdmachine.reg<vgpr, 1>,
                               %arg1: !waveamdmachine.reg<vgpr, 1>) {
  %tuple = waveamdmachine.tuple_from_elements %arg0, %arg1
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
      -> !waveamdmachine.reg<vgpr, 2>
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// CHECK-LABEL: func.func @tuple_component
// OVERFLOW-LABEL: func.func @tuple_component
// OVERFLOW-SAME: waveamdmachine.regalloc_overflowed = 1 : i64
// OVERFLOW-NOT: v_accvgpr
// OVERFLOW: return
func.func @tuple_component() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %tuple = waveamdmachine.v_mov_b32_tuple %zero {registers = 4 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4>
  %parts:2 = waveamdmachine.tuple_to_elements %tuple
      : (!waveamdmachine.reg<vgpr, 4>)
      -> (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>)
  %again = waveamdmachine.tuple_from_elements %parts#0, %parts#1
      : (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>)
      -> !waveamdmachine.reg<vgpr, 4>
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// CHECK-LABEL: func.func @fixed_wide
// CHECK: !waveamdmachine.reg<vgpr, 2, 0>
func.func @fixed_wide() {
  %fixed = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 2, 0>
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// CHECK-LABEL: func.func @loop_component
func.func @loop_component() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %init = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %ec = waveamdmachine.s_cmp_lt_i32 %zero, %one
      : (!waveamdmachine.imm, !waveamdmachine.imm) -> !waveamdmachine.reg<scc, 1>
  %r = waveamdmachine.uniform_loop if %ec : !waveamdmachine.reg<scc, 1>
      carries(%init : !waveamdmachine.reg<vgpr, 1>) {
  ^bb0(%cur: !waveamdmachine.reg<vgpr, 1>):
    waveamdmachine.continue_if %ec : !waveamdmachine.reg<scc, 1>
        carries(%cur : !waveamdmachine.reg<vgpr, 1>)
  } -> !waveamdmachine.reg<vgpr, 1>
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// CHECK-LABEL: func.func @loop_external_use
func.func @loop_external_use() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %ext = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %init = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %ec = waveamdmachine.s_cmp_lt_i32 %zero, %one
      : (!waveamdmachine.imm, !waveamdmachine.imm) -> !waveamdmachine.reg<scc, 1>
  %r = waveamdmachine.uniform_loop if %ec : !waveamdmachine.reg<scc, 1>
      carries(%init : !waveamdmachine.reg<vgpr, 1>) {
  ^bb0(%cur: !waveamdmachine.reg<vgpr, 1>):
    %use = waveamdmachine.v_mov_b32_tuple %ext {registers = 1 : i64}
        : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
    waveamdmachine.continue_if %ec : !waveamdmachine.reg<scc, 1>
        carries(%cur : !waveamdmachine.reg<vgpr, 1>)
  } -> !waveamdmachine.reg<vgpr, 1>
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// CHECK-LABEL: func.func @exec_if_component
func.func @exec_if_component() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %cond = waveamdmachine.s_mov_b32_value %one
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %r = waveamdmachine.exec_if %cond {
    %then = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
        : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
    waveamdmachine.yield %then : !waveamdmachine.reg<vgpr, 1>
  } otherwise {
    %else = waveamdmachine.v_mov_b32_tuple %one {registers = 1 : i64}
        : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
    waveamdmachine.yield %else : !waveamdmachine.reg<vgpr, 1>
  } : !waveamdmachine.reg<sgpr, 1> -> !waveamdmachine.reg<vgpr, 1>
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// CHECK-LABEL: func.func @exec_if_no_else_component
func.func @exec_if_no_else_component() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %cond = waveamdmachine.s_mov_b32_value %one
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %r = waveamdmachine.exec_if %cond {
    %then = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
        : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
    waveamdmachine.yield %then : !waveamdmachine.reg<vgpr, 1>
  } : !waveamdmachine.reg<sgpr, 1> -> !waveamdmachine.reg<vgpr, 1>
  return
}

}
