// RUN: wave-opt --waveamd-reg-alloc -split-input-file %s | FileCheck %s
// RUN: wave-opt --waveamd-reg-alloc='mark-overflow=true vgpr-limit=3' -split-input-file %s | FileCheck %s --check-prefix=PROMOTE
// RUN: wave-opt --waveamd-reg-alloc='sgpr-limit=1' -split-input-file %s | FileCheck %s --check-prefix=SGPRPROMOTE
// RUN: wave-opt --waveamd-reg-alloc='mark-overflow=true vgpr-limit=3 agpr-limit=0' -split-input-file %s | FileCheck %s --check-prefix=OVERFLOW

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// SGPRPROMOTE-LABEL: func.func @sgpr_promote
// SGPRPROMOTE-SAME: waveamdmachine.regalloc_debug_peak_sgpr = 1 : i64
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
// PROMOTE-SAME: class = "AGPR"
// PROMOTE-SAME: storage_class = "AGPR"
// PROMOTE-SAME: waveamdmachine.regalloc_debug_peak_agpr = 4 : i64
// PROMOTE-SAME: waveamdmachine.regalloc_debug_peak_vgpr = 0 : i64
func.func @promote_direct_agpr() {
  %value = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4>
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// CHECK-LABEL: func.func @live_in
// CHECK-SAME: waveamdmachine.regalloc_debug_intervals = [{{.*}}position = 0 : i64{{.*}}result = -1 : i64
// CHECK-SAME: waveamdmachine.regalloc_debug_peak_vgpr = 2 : i64
func.func @live_in(%arg0: !waveamdmachine.reg<vgpr, 1>) {
  %copy = waveamdmachine.v_mov_b32_tuple %arg0 {registers = 1 : i64}
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// CHECK-LABEL: func.func @tuple_component
// CHECK-SAME: waveamdmachine.regalloc_debug_flat_ops = 5 : i64
// CHECK-SAME: waveamdmachine.regalloc_debug_intervals = [{{.*}}class = "VGPR"{{.*}}width = 1 : i64
// CHECK-SAME: waveamdmachine.regalloc_debug_peak_vgpr = 4 : i64
// CHECK-SAME: waveamdmachine.regalloc_debug_scalar_intervals = 4 : i64
// CHECK-SAME: waveamdmachine.regalloc_debug_tracked_values = 4 : i64
// OVERFLOW-LABEL: func.func @tuple_component
// OVERFLOW-SAME: waveamdmachine.regalloc_debug_overflowed = 1 : i64
// OVERFLOW-SAME: waveamdmachine.regalloc_debug_pressure_class = "VGPR"
// OVERFLOW-SAME: waveamdmachine.regalloc_debug_pressure_limit = 3 : i64
// OVERFLOW-SAME: waveamdmachine.regalloc_debug_pressure_live_dwords = 0 : i64
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
// CHECK-SAME: phys = 0 : i64
// CHECK-SAME: phys = 1 : i64
func.func @fixed_wide() {
  %fixed = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 2, 0>
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// CHECK-LABEL: func.func @loop_component
// CHECK-SAME: waveamdmachine.regalloc_debug_intervals =
// CHECK-SAME: waveamdmachine.regalloc_debug_peak_vgpr = 1 : i64
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
// CHECK-SAME: waveamdmachine.regalloc_debug_intervals = [{{.*}}end = 7 : i64{{.*}}position = 2 : i64
// CHECK-SAME: waveamdmachine.regalloc_debug_peak_vgpr = 3 : i64
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
// CHECK-SAME: waveamdmachine.regalloc_debug_peak_vgpr = 1 : i64
// CHECK-SAME: waveamdmachine.regalloc_debug_scalar_intervals = 2 : i64
// CHECK-SAME: waveamdmachine.regalloc_debug_tracked_values = 4 : i64
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
// CHECK-SAME: waveamdmachine.regalloc_debug_peak_sgpr = 1 : i64
// CHECK-SAME: waveamdmachine.regalloc_debug_peak_vgpr = 1 : i64
// CHECK-SAME: waveamdmachine.regalloc_debug_scalar_intervals = 2 : i64
// CHECK-SAME: waveamdmachine.regalloc_debug_tracked_values = 3 : i64
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
