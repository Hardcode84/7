// RUN: wave-opt --waveamd-resource-info -split-input-file -verify-diagnostics %s

func.func @unallocated_register() {
  // expected-error @below {{waveamd-resource-info requires allocated register values}}
  %reg = waveamdmachine.v_mbcnt_lo : !waveamdmachine.reg<vgpr, 1>
  return
}

// -----

func.func @duplicate_tuple_alias_slot_mismatch(
    %value: !waveamdmachine.reg<vgpr, 1, 5>) {
  // expected-error @below {{coalesce: alias slot offset mismatch, existing 0 requested 1}}
  %tuple = waveamdmachine.tuple_from_elements %value, %value
      : (!waveamdmachine.reg<vgpr, 1, 5>, !waveamdmachine.reg<vgpr, 1, 5>)
        -> !waveamdmachine.reg<vgpr, 2, 5>
  return
}

// -----

func.func @duplicate_loop_carry_tuple_alias_slot_mismatch() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %init = waveamdmachine.s_mov_b32_value %zero
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1, 5>
  %cond = waveamdmachine.s_cmp_lt_i32 %init, %init
      : (!waveamdmachine.reg<sgpr, 1, 5>, !waveamdmachine.reg<sgpr, 1, 5>)
        -> !waveamdmachine.reg<scc, 1>
  %result = waveamdmachine.uniform_loop if %cond : !waveamdmachine.reg<scc, 1>
      carries(%init : !waveamdmachine.reg<sgpr, 1, 5>) {
  ^bb0(%iv: !waveamdmachine.reg<sgpr, 1, 5>):
    // expected-error @below {{coalesce: alias slot offset mismatch, existing 0 requested 1}}
    %tuple = waveamdmachine.tuple_from_elements %iv, %iv
        : (!waveamdmachine.reg<sgpr, 1, 5>, !waveamdmachine.reg<sgpr, 1, 5>)
          -> !waveamdmachine.reg<sgpr, 2, 5>
    waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
        carries(%iv : !waveamdmachine.reg<sgpr, 1, 5>)
  } -> !waveamdmachine.reg<sgpr, 1, 5>
  return
}

// -----

func.func @duplicate_fixed_loop_carry_slots() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  // expected-note @below {{slot 0 phys=[5, 6)}}
  // expected-note @below {{slot 1 phys=[5, 6)}}
  %init = waveamdmachine.s_mov_b32_value %zero
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1, 5>
  %cond = waveamdmachine.s_cmp_lt_i32 %init, %init
      : (!waveamdmachine.reg<sgpr, 1, 5>, !waveamdmachine.reg<sgpr, 1, 5>)
        -> !waveamdmachine.reg<scc, 1>
  // expected-error @below {{waveamd-resource-info found distinct fixed loop carry slots sharing SGPR register range}}
  %result:2 = waveamdmachine.uniform_loop if %cond : !waveamdmachine.reg<scc, 1>
      carries(%init, %init : !waveamdmachine.reg<sgpr, 1, 5>,
                             !waveamdmachine.reg<sgpr, 1, 5>) {
  ^bb0(%lhs: !waveamdmachine.reg<sgpr, 1, 5>,
       %rhs: !waveamdmachine.reg<sgpr, 1, 5>):
    waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
        carries(%lhs, %rhs : !waveamdmachine.reg<sgpr, 1, 5>,
                              !waveamdmachine.reg<sgpr, 1, 5>)
  } -> !waveamdmachine.reg<sgpr, 1, 5>,
       !waveamdmachine.reg<sgpr, 1, 5>
  return
}

// -----

// expected-error @below {{waveamd-resource-info found interfering VGPR register live ranges}}
func.func @interfering_vgprs() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  // expected-note @below {{lhs phys=[0, 1) live=[1, 3]}}
  %a = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1, 0>
  // expected-note @below {{rhs phys=[0, 1) live=[2, 4]}}
  %b = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1, 0>
  %use_a = waveamdmachine.v_mov_b32_tuple %a {registers = 1 : i64}
      : (!waveamdmachine.reg<vgpr, 1, 0>) -> !waveamdmachine.reg<vgpr, 1, 1>
  %use_b = waveamdmachine.v_mov_b32_tuple %b {registers = 1 : i64}
      : (!waveamdmachine.reg<vgpr, 1, 0>) -> !waveamdmachine.reg<vgpr, 1, 2>
  return
}

// -----

// expected-error @below {{waveamd-resource-info found interfering VGPR register live ranges}}
func.func @exec_if_yield_region_interference() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %cond = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 1, 0>
  // expected-note @below {{lhs phys=[0, 1) live=[2, 5]}}
  %a = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1, 0>
  // expected-note @below {{rhs phys=[0, 1) live=[3, 7]}}
  %b = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1, 0>
  %r = waveamdmachine.exec_if %cond {
    %use_a = waveamdmachine.v_mov_b32_tuple %a {registers = 1 : i64}
        : (!waveamdmachine.reg<vgpr, 1, 0>) -> !waveamdmachine.reg<vgpr, 1, 1>
    waveamdmachine.yield %use_a : !waveamdmachine.reg<vgpr, 1, 1>
  } : !waveamdmachine.reg<sgpr, 1, 0> -> !waveamdmachine.reg<vgpr, 1, 1>
  %use_b = waveamdmachine.v_mov_b32_tuple %b {registers = 1 : i64}
      : (!waveamdmachine.reg<vgpr, 1, 0>) -> !waveamdmachine.reg<vgpr, 1, 2>
  return
}

// -----

func.func @exec_if_mixed_merge_sources() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %cond = waveamdmachine.s_mov_b32_value %one
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1, 0>
  %sgpr = waveamdmachine.s_mov_b32_value %one
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1, 1>
  %r = waveamdmachine.exec_if %cond {
    waveamdmachine.yield %sgpr : !waveamdmachine.reg<sgpr, 1, 1>
  } otherwise {
    waveamdmachine.yield %zero : !waveamdmachine.imm
  } : !waveamdmachine.reg<sgpr, 1, 0> -> !waveamdmachine.reg<vgpr, 1, 0>
  return
}

// -----

// expected-error @below {{waveamd-resource-info found interfering SGPR register live ranges}}
func.func @exec_if_condition_then_interference() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  // expected-note @below {{lhs phys=[0, 1) live=[1, 4]}}
  %cond = waveamdmachine.s_mov_b32_value %zero
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1, 0>
  waveamdmachine.exec_if %cond {
    // expected-note @below {{rhs phys=[0, 1) live=[3, 3]}}
    %clobber = waveamdmachine.s_mov_b32_value %zero
        : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1, 0>
    waveamdmachine.yield
  } otherwise {
    waveamdmachine.yield
  } : !waveamdmachine.reg<sgpr, 1, 0>
  return
}

// -----

// expected-error @below {{waveamd-resource-info found interfering SGPR register live ranges}}
func.func @exec_if_condition_else_data_interference() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  // expected-note @below {{lhs phys=[0, 1) live=[2, 7]}}
  %cond = waveamdmachine.s_mov_b32_value %one
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1, 0>
  %sgpr = waveamdmachine.s_mov_b32_value %one
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1, 1>
  %r = waveamdmachine.exec_if %cond {
    waveamdmachine.yield %sgpr : !waveamdmachine.reg<sgpr, 1, 1>
  } otherwise {
    // expected-note @below {{rhs phys=[0, 1) live=[6, 6]}}
    %clobber = waveamdmachine.s_mov_b32_value %zero
        : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1, 0>
    waveamdmachine.yield %zero : !waveamdmachine.imm
  } : !waveamdmachine.reg<sgpr, 1, 0> -> !waveamdmachine.reg<vgpr, 1, 0>
  return
}

// -----

// expected-error @below {{waveamd-resource-info found interfering SGPR register live ranges}}
func.func @interfering_sgprs() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  // expected-note @below {{lhs phys=[0, 1) live=[1, 3]}}
  %a = waveamdmachine.s_mov_b32_value %zero
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1, 0>
  // expected-note @below {{rhs phys=[0, 1) live=[2, 4]}}
  %b = waveamdmachine.s_mov_b32_value %zero
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1, 0>
  %use_a = waveamdmachine.s_mov_b32_value %a
      : (!waveamdmachine.reg<sgpr, 1, 0>) -> !waveamdmachine.reg<sgpr, 1, 1>
  %use_b = waveamdmachine.s_mov_b32_value %b
      : (!waveamdmachine.reg<sgpr, 1, 0>) -> !waveamdmachine.reg<sgpr, 1, 2>
  return
}

// -----

// expected-error @below {{waveamd-resource-info found interfering AGPR register live ranges}}
func.func @interfering_agprs() {
  %off = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 1>
  %base = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2, 6>
  // expected-note @below {{lhs phys=[0, 1) live=[2, 4]}}
  %a = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 1, 0>
  // expected-note @below {{rhs phys=[0, 1) live=[3, 5]}}
  %b = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 1, 0>
  %read_a = waveamdmachine.v_accvgpr_read_b32_tuple %a
      : (!waveamdmachine.reg<agpr, 1, 0>) -> !waveamdmachine.reg<vgpr, 1, 2>
  %read_b = waveamdmachine.v_accvgpr_read_b32_tuple %b
      : (!waveamdmachine.reg<agpr, 1, 0>) -> !waveamdmachine.reg<vgpr, 1, 3>
  %store_a = waveamdmachine.global_store_b32 %off, %read_a, %base
      : (!waveamdmachine.reg<vgpr, 1, 1>, !waveamdmachine.reg<vgpr, 1, 2>,
         !waveamdmachine.reg<sgpr, 2, 6>) -> !waveamdmachine.mem.token
  %store_b = waveamdmachine.global_store_b32 %off, %read_b, %base after %store_a
      : (!waveamdmachine.reg<vgpr, 1, 1>, !waveamdmachine.reg<vgpr, 1, 3>,
         !waveamdmachine.reg<sgpr, 2, 6>, !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  return
}
