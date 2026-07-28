// RUN: wave-opt --waveamd-insert-ticket-waits -split-input-file %s | FileCheck %s
// RUN: wave-opt --waveamd-insert-ticket-waits -split-input-file %s | wave-opt --waveamd-insert-ticket-waits -split-input-file | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"} {

// CHECK-LABEL: func.func @combined_load_ds
// CHECK: waveamdmachine.global_load_b32
// CHECK-NEXT: waveamdmachine.ds_load_b32
// CHECK-NEXT: waveamdmachine.s_waitcnt_split loadcnt(0) dscnt(0)
// CHECK-NEXT: waveamdmachine.v_add_u32
func.func @combined_load_ds(
    %off: !waveamdmachine.reg<vgpr, 1, 0>,
    %lds_addr: !waveamdmachine.reg<vgpr, 1, 1>,
    %base: !waveamdmachine.reg<sgpr, 2, 0>) {
  %global = waveamdmachine.global_load_b32 %off, %base
      : (!waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<sgpr, 2, 0>)
        -> !waveamdmachine.reg<vgpr, 1, 10>
  %lds = waveamdmachine.ds_load_b32 %lds_addr
      : (!waveamdmachine.reg<vgpr, 1, 1>)
        -> !waveamdmachine.reg<vgpr, 1, 11>
  %sum = waveamdmachine.v_add_u32 %global, %lds
      : (!waveamdmachine.reg<vgpr, 1, 10>,
         !waveamdmachine.reg<vgpr, 1, 11>)
        -> !waveamdmachine.reg<vgpr, 1, 12>
  return
}

// CHECK-LABEL: func.func @combined_store_ds
// CHECK: waveamdmachine.global_store_b32
// CHECK-NEXT: waveamdmachine.ds_store_b32
// CHECK-NEXT: waveamdmachine.s_waitcnt_split storecnt(0) dscnt(0)
// CHECK-NEXT: waveamdmachine.s_barrier
func.func @combined_store_ds(
    %off: !waveamdmachine.reg<vgpr, 1, 0>,
    %value: !waveamdmachine.reg<vgpr, 1, 1>,
    %lds_addr: !waveamdmachine.reg<vgpr, 1, 2>,
    %lds_value: !waveamdmachine.reg<vgpr, 1, 3>,
    %base: !waveamdmachine.reg<sgpr, 2, 0>) {
  %store = waveamdmachine.global_store_b32 %off, %value, %base
      : (!waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<vgpr, 1, 1>,
         !waveamdmachine.reg<sgpr, 2, 0>)
        -> !waveamdmachine.mem.token
  %ds = waveamdmachine.ds_store_b32 %lds_addr, %lds_value
      : (!waveamdmachine.reg<vgpr, 1, 2>,
         !waveamdmachine.reg<vgpr, 1, 3>)
        -> !waveamdmachine.mem.token
  waveamdmachine.s_barrier %store, %ds
      : (!waveamdmachine.mem.token, !waveamdmachine.mem.token) -> ()
  return
}

// CHECK-LABEL: func.func @km_and_x
// CHECK: [[SMEM:%.*]] = waveamdmachine.s_load_b32
// CHECK-NEXT: waveamdmachine.s_waitcnt_split kmcnt(0)
// CHECK-NEXT: waveamdmachine.s_add_i32 [[SMEM]]
// CHECK: waveamdmachine.s_load_b32
// CHECK-NEXT: waveamdmachine.s_waitcnt_split xcnt(0)
// CHECK-NEXT: waveamdmachine.s_add_i32
func.func @km_and_x(%source: !waveamdmachine.reg<sgpr, 1, 7>) {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %smem = waveamdmachine.s_load_b32 %zero, "s[0:1]"
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1, 4>
  %sum, %scc = waveamdmachine.s_add_i32 %smem, %one
      : (!waveamdmachine.reg<sgpr, 1, 4>, !waveamdmachine.imm)
        -> (!waveamdmachine.reg<sgpr, 1, 5>,
            !waveamdmachine.reg<scc, 1>)
  %unused = waveamdmachine.s_load_b32 %zero, "s[0:1]"
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1, 6>
  %clobber, %scc_2 = waveamdmachine.s_add_i32 %source, %one
      : (!waveamdmachine.reg<sgpr, 1, 7>, !waveamdmachine.imm)
        -> (!waveamdmachine.reg<sgpr, 1, 0>,
            !waveamdmachine.reg<scc, 1>)
  return
}

// CHECK-LABEL: func.func @partial_x
// CHECK: waveamdmachine.global_store_b32
// CHECK-NEXT: waveamdmachine.global_store_b32
// CHECK-NEXT: waveamdmachine.s_waitcnt_split xcnt(1)
// CHECK-NEXT: waveamdmachine.v_add_u32
func.func @partial_x(
    %off: !waveamdmachine.reg<vgpr, 1, 0>,
    %first: !waveamdmachine.reg<vgpr, 1, 1>,
    %second: !waveamdmachine.reg<vgpr, 1, 2>,
    %lhs: !waveamdmachine.reg<vgpr, 1, 3>,
    %rhs: !waveamdmachine.reg<vgpr, 1, 4>,
    %base: !waveamdmachine.reg<sgpr, 2, 0>) {
  waveamdmachine.global_store_b32 %off, %first, %base
      : (!waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<vgpr, 1, 1>,
         !waveamdmachine.reg<sgpr, 2, 0>) -> ()
  waveamdmachine.global_store_b32 %off, %second, %base
      : (!waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<vgpr, 1, 2>,
         !waveamdmachine.reg<sgpr, 2, 0>) -> ()
  %clobber = waveamdmachine.v_add_u32 %lhs, %rhs
      : (!waveamdmachine.reg<vgpr, 1, 3>,
         !waveamdmachine.reg<vgpr, 1, 4>)
        -> !waveamdmachine.reg<vgpr, 1, 1>
  return
}

// CHECK-LABEL: func.func @interleaved_smem_vmem_drains_x
// CHECK: waveamdmachine.s_load_b32
// CHECK-NEXT: waveamdmachine.global_store_b32
// CHECK-NOT: waveamdmachine.s_waitcnt_split
// CHECK-NEXT: waveamdmachine.s_add_i32
func.func @interleaved_smem_vmem_drains_x(
    %off: !waveamdmachine.reg<vgpr, 1, 0>,
    %value: !waveamdmachine.reg<vgpr, 1, 1>,
    %source: !waveamdmachine.reg<sgpr, 1, 7>,
    %base: !waveamdmachine.reg<sgpr, 2, 4>) {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %unused = waveamdmachine.s_load_b32 %zero, "s[0:1]"
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1, 6>
  waveamdmachine.global_store_b32 %off, %value, %base
      : (!waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<vgpr, 1, 1>,
         !waveamdmachine.reg<sgpr, 2, 4>) -> ()
  %clobber, %scc = waveamdmachine.s_add_i32 %source, %one
      : (!waveamdmachine.reg<sgpr, 1, 7>, !waveamdmachine.imm)
        -> (!waveamdmachine.reg<sgpr, 1, 0>,
            !waveamdmachine.reg<scc, 1>)
  return
}

// CHECK-LABEL: func.func @explicit_x_wait_is_observed
// CHECK: waveamdmachine.global_store_b32
// CHECK-NEXT: waveamdmachine.s_waitcnt_split xcnt(0)
// CHECK-NEXT: waveamdmachine.v_add_u32
func.func @explicit_x_wait_is_observed(
    %off: !waveamdmachine.reg<vgpr, 1, 0>,
    %value: !waveamdmachine.reg<vgpr, 1, 1>,
    %lhs: !waveamdmachine.reg<vgpr, 1, 2>,
    %rhs: !waveamdmachine.reg<vgpr, 1, 3>,
    %base: !waveamdmachine.reg<sgpr, 2, 0>) {
  waveamdmachine.global_store_b32 %off, %value, %base
      : (!waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<vgpr, 1, 1>,
         !waveamdmachine.reg<sgpr, 2, 0>) -> ()
  waveamdmachine.s_waitcnt_split xcnt(0)
  %clobber = waveamdmachine.v_add_u32 %lhs, %rhs
      : (!waveamdmachine.reg<vgpr, 1, 2>,
         !waveamdmachine.reg<vgpr, 1, 3>)
        -> !waveamdmachine.reg<vgpr, 1, 1>
  return
}

// CHECK-LABEL: func.func @load_wait_implies_x
// CHECK: waveamdmachine.global_load_b32
// CHECK-NEXT: waveamdmachine.s_waitcnt_split loadcnt(0)
// CHECK-NOT: waveamdmachine.s_waitcnt_split
// CHECK-NEXT: waveamdmachine.v_add_u32
func.func @load_wait_implies_x(
    %off: !waveamdmachine.reg<vgpr, 1, 0>,
    %lhs: !waveamdmachine.reg<vgpr, 1, 2>,
    %rhs: !waveamdmachine.reg<vgpr, 1, 3>,
    %base: !waveamdmachine.reg<sgpr, 2, 0>) {
  %unused = waveamdmachine.global_load_b32 %off, %base
      : (!waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<sgpr, 2, 0>)
        -> !waveamdmachine.reg<vgpr, 1, 4>
  waveamdmachine.s_waitcnt_split loadcnt(0)
  %clobber = waveamdmachine.v_add_u32 %lhs, %rhs
      : (!waveamdmachine.reg<vgpr, 1, 2>,
         !waveamdmachine.reg<vgpr, 1, 3>)
        -> !waveamdmachine.reg<vgpr, 1, 0>
  return
}

// CHECK-LABEL: func.func @km_wait_implies_x
// CHECK: waveamdmachine.s_load_b32
// CHECK-NEXT: waveamdmachine.s_waitcnt_split kmcnt(0)
// CHECK-NOT: waveamdmachine.s_waitcnt_split
// CHECK-NEXT: waveamdmachine.s_add_i32
func.func @km_wait_implies_x(%source: !waveamdmachine.reg<sgpr, 1, 7>) {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %unused = waveamdmachine.s_load_b32 %zero, "s[0:1]"
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1, 6>
  waveamdmachine.s_waitcnt_split kmcnt(0)
  %clobber, %scc = waveamdmachine.s_add_i32 %source, %one
      : (!waveamdmachine.reg<sgpr, 1, 7>, !waveamdmachine.imm)
        -> (!waveamdmachine.reg<sgpr, 1, 0>,
            !waveamdmachine.reg<scc, 1>)
  return
}

// CHECK-LABEL: func.func @vgpr_window_switch_drains_x
// CHECK: waveamdmachine.global_store_b32
// CHECK-NEXT: waveamdmachine.s_set_vgpr_msb
// CHECK-NOT: waveamdmachine.s_waitcnt_split
// CHECK-NEXT: waveamdmachine.v_add_u32
func.func @vgpr_window_switch_drains_x(
    %off: !waveamdmachine.reg<vgpr, 1, 0>,
    %value: !waveamdmachine.reg<vgpr, 1, 1>,
    %lhs: !waveamdmachine.reg<vgpr, 1, 2>,
    %rhs: !waveamdmachine.reg<vgpr, 1, 3>,
    %base: !waveamdmachine.reg<sgpr, 2, 0>) {
  %mode = waveamdmachine.imm 0 : !waveamdmachine.imm
  waveamdmachine.global_store_b32 %off, %value, %base
      : (!waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<vgpr, 1, 1>,
         !waveamdmachine.reg<sgpr, 2, 0>) -> ()
  waveamdmachine.s_set_vgpr_msb %mode : (!waveamdmachine.imm) -> ()
  %clobber = waveamdmachine.v_add_u32 %lhs, %rhs
      : (!waveamdmachine.reg<vgpr, 1, 2>,
         !waveamdmachine.reg<vgpr, 1, 3>)
        -> !waveamdmachine.reg<vgpr, 1, 1>
  return
}

// CHECK-LABEL: func.func @exec_if_restore_requires_x
// CHECK: waveamdmachine.exec_if
// CHECK: waveamdmachine.global_store_b32
// CHECK-NEXT: waveamdmachine.s_waitcnt_split xcnt(0)
// CHECK-NEXT: }
// CHECK: waveamdmachine.v_add_u32
func.func @exec_if_restore_requires_x(
    %cond: !waveamdmachine.reg<sgpr, 1, 8>,
    %off: !waveamdmachine.reg<vgpr, 1, 0>,
    %value: !waveamdmachine.reg<vgpr, 1, 1>,
    %lhs: !waveamdmachine.reg<vgpr, 1, 2>,
    %rhs: !waveamdmachine.reg<vgpr, 1, 3>,
    %base: !waveamdmachine.reg<sgpr, 2, 0>) {
  waveamdmachine.exec_if %cond {
    waveamdmachine.global_store_b32 %off, %value, %base
        : (!waveamdmachine.reg<vgpr, 1, 0>,
           !waveamdmachine.reg<vgpr, 1, 1>,
           !waveamdmachine.reg<sgpr, 2, 0>) -> ()
    waveamdmachine.yield
  } : !waveamdmachine.reg<sgpr, 1, 8>
  %clobber = waveamdmachine.v_add_u32 %lhs, %rhs
      : (!waveamdmachine.reg<vgpr, 1, 2>,
         !waveamdmachine.reg<vgpr, 1, 3>)
        -> !waveamdmachine.reg<vgpr, 1, 1>
  return
}

// CHECK-LABEL: func.func @writes_exec_requires_x
// CHECK: waveamdmachine.global_store_b32
// CHECK-NEXT: waveamdmachine.s_waitcnt_split xcnt(0)
// CHECK-NEXT: waveamdmachine.s_mov_exec_lo
func.func @writes_exec_requires_x(
    %mask: !waveamdmachine.reg<sgpr, 1, 8>,
    %off: !waveamdmachine.reg<vgpr, 1, 0>,
    %value: !waveamdmachine.reg<vgpr, 1, 1>,
    %base: !waveamdmachine.reg<sgpr, 2, 0>) {
  waveamdmachine.global_store_b32 %off, %value, %base
      : (!waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<vgpr, 1, 1>,
         !waveamdmachine.reg<sgpr, 2, 0>) -> ()
  waveamdmachine.s_mov_exec_lo %mask
      : (!waveamdmachine.reg<sgpr, 1, 8>) -> ()
  return
}

// CHECK-LABEL: func.func @exec_if_save_requires_x
// CHECK: waveamdmachine.global_store_b32
// CHECK-NEXT: waveamdmachine.s_waitcnt_split xcnt(0)
// CHECK-NEXT: waveamdmachine.exec_if
func.func @exec_if_save_requires_x(
    %cond: !waveamdmachine.reg<sgpr, 1, 8>,
    %off: !waveamdmachine.reg<vgpr, 1, 0>,
    %value: !waveamdmachine.reg<vgpr, 1, 1>,
    %base: !waveamdmachine.reg<sgpr, 2, 0>) {
  waveamdmachine.global_store_b32 %off, %value, %base
      : (!waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<vgpr, 1, 1>,
         !waveamdmachine.reg<sgpr, 2, 0>) -> ()
  waveamdmachine.exec_if %cond {
    waveamdmachine.yield
  } : !waveamdmachine.reg<sgpr, 1, 8>
  return
}

// CHECK-LABEL: func.func @exec_if_arm_transitions_require_x
// CHECK: waveamdmachine.exec_if
// CHECK: waveamdmachine.global_store_b32
// CHECK-NEXT: waveamdmachine.s_waitcnt_split xcnt(0)
// CHECK-NEXT: } otherwise {
// CHECK: waveamdmachine.global_store_b32
// CHECK-NEXT: waveamdmachine.s_waitcnt_split xcnt(0)
// CHECK-NEXT: }
func.func @exec_if_arm_transitions_require_x(
    %cond: !waveamdmachine.reg<sgpr, 1, 8>,
    %then_off: !waveamdmachine.reg<vgpr, 1, 0>,
    %then_value: !waveamdmachine.reg<vgpr, 1, 1>,
    %else_off: !waveamdmachine.reg<vgpr, 1, 2>,
    %else_value: !waveamdmachine.reg<vgpr, 1, 3>,
    %base: !waveamdmachine.reg<sgpr, 2, 0>) {
  waveamdmachine.exec_if %cond {
    waveamdmachine.global_store_b32 %then_off, %then_value, %base
        : (!waveamdmachine.reg<vgpr, 1, 0>,
           !waveamdmachine.reg<vgpr, 1, 1>,
           !waveamdmachine.reg<sgpr, 2, 0>) -> ()
    waveamdmachine.yield
  } otherwise {
    waveamdmachine.global_store_b32 %else_off, %else_value, %base
        : (!waveamdmachine.reg<vgpr, 1, 2>,
           !waveamdmachine.reg<vgpr, 1, 3>,
           !waveamdmachine.reg<sgpr, 2, 0>) -> ()
    waveamdmachine.yield
  } : !waveamdmachine.reg<sgpr, 1, 8>
  return
}

// CHECK-LABEL: func.func @exec_if_region_entry_drains_x
// CHECK: waveamdmachine.s_load_b32
// CHECK-NEXT: waveamdmachine.exec_if
// CHECK-NOT: waveamdmachine.s_waitcnt_split
// CHECK: waveamdmachine.s_mov_b32 "s0"
func.func @exec_if_region_entry_drains_x(
    %cond: !waveamdmachine.reg<sgpr, 1, 8>,
    %source: !waveamdmachine.reg<sgpr, 1, 7>) {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %unused = waveamdmachine.s_load_b32 %zero, "s[0:1]"
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1, 6>
  waveamdmachine.exec_if %cond {
    waveamdmachine.s_mov_b32 "s0", %source
        : (!waveamdmachine.reg<sgpr, 1, 7>) -> ()
    waveamdmachine.yield
  } : !waveamdmachine.reg<sgpr, 1, 8>
  return
}

// CHECK-LABEL: func.func @exec_if_hidden_save_requires_x
// CHECK: waveamdmachine.s_load_b32
// CHECK-NEXT: waveamdmachine.s_waitcnt_split xcnt(0)
// CHECK-NEXT: waveamdmachine.exec_if
func.func @exec_if_hidden_save_requires_x(
    %cond: !waveamdmachine.reg<sgpr, 1, 7>)
    attributes {waveamdmachine.sgpr_count = 10 : i64} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %unused = waveamdmachine.s_load_b32 %zero, "s[8:9]"
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1, 6>
  waveamdmachine.exec_if %cond {
    waveamdmachine.yield
  } : !waveamdmachine.reg<sgpr, 1, 7>
  return
}

// CHECK-LABEL: func.func @nested_exec_if_hidden_save_requires_x
// CHECK: waveamdmachine.exec_if
// CHECK: waveamdmachine.s_load_b32
// CHECK-NEXT: waveamdmachine.s_waitcnt_split xcnt(0)
// CHECK-NEXT: waveamdmachine.exec_if
func.func @nested_exec_if_hidden_save_requires_x(
    %seed: !waveamdmachine.reg<sgpr, 1, 4>) {
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %cond, %scc = waveamdmachine.s_add_i32 %seed, %one
      : (!waveamdmachine.reg<sgpr, 1, 4>, !waveamdmachine.imm)
        -> (!waveamdmachine.reg<sgpr, 1, 6>,
            !waveamdmachine.reg<scc, 1>)
  waveamdmachine.exec_if %cond {
    %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
    %unused = waveamdmachine.s_load_b32 %zero, "s[8:9]"
        : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1, 5>
    waveamdmachine.exec_if %cond {
      waveamdmachine.yield
    } : !waveamdmachine.reg<sgpr, 1, 6>
    waveamdmachine.yield
  } : !waveamdmachine.reg<sgpr, 1, 6>
  return
}

// CHECK-LABEL: func.func @implicit_drain_def_requires_x
// CHECK: waveamdmachine.s_load_b32
// CHECK-NEXT: waveamdmachine.s_waitcnt_split xcnt(0)
// CHECK-NEXT: waveamdmachine.s_getreg_hw_id
func.func @implicit_drain_def_requires_x() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %unused = waveamdmachine.s_load_b32 %zero, "s[0:1]"
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1, 6>
  %id = waveamdmachine.s_getreg_hw_id offset 0 width 1
      : !waveamdmachine.reg<sgpr, 1, 0>
  return
}

// CHECK-LABEL: func.func @group_switch_checks_def_before_drain
// CHECK: waveamdmachine.global_load_b32
// CHECK-NEXT: waveamdmachine.s_waitcnt_split xcnt(0)
// CHECK-NEXT: waveamdmachine.s_load_b32
func.func @group_switch_checks_def_before_drain(
    %off: !waveamdmachine.reg<vgpr, 1, 0>,
    %base: !waveamdmachine.reg<sgpr, 2, 0>) {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %vmem = waveamdmachine.global_load_b32 %off, %base
      : (!waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<sgpr, 2, 0>)
        -> !waveamdmachine.reg<vgpr, 1, 5>
  %smem = waveamdmachine.s_load_b32 %zero, "s[4:5]"
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1, 0>
  return
}

// CHECK-LABEL: func.func @exec_if_yield_copy_def
// CHECK: waveamdmachine.exec_if
// CHECK: waveamdmachine.global_store_b32
// CHECK-NEXT: waveamdmachine.s_waitcnt_split xcnt(0)
// CHECK-NEXT: waveamdmachine.yield
func.func @exec_if_yield_copy_def(
    %cond: !waveamdmachine.reg<sgpr, 1, 8>,
    %off: !waveamdmachine.reg<vgpr, 1, 0>,
    %value: !waveamdmachine.reg<vgpr, 1, 1>,
    %copy_source: !waveamdmachine.reg<vgpr, 1, 4>,
    %else_source: !waveamdmachine.reg<vgpr, 1, 5>,
    %base: !waveamdmachine.reg<sgpr, 2, 0>) {
  %copied = waveamdmachine.exec_if %cond {
    waveamdmachine.global_store_b32 %off, %value, %base
        : (!waveamdmachine.reg<vgpr, 1, 0>,
           !waveamdmachine.reg<vgpr, 1, 1>,
           !waveamdmachine.reg<sgpr, 2, 0>) -> ()
    waveamdmachine.yield %copy_source
        : !waveamdmachine.reg<vgpr, 1, 4>
  } otherwise {
    waveamdmachine.yield %else_source
        : !waveamdmachine.reg<vgpr, 1, 5>
  } : !waveamdmachine.reg<sgpr, 1, 8>
      -> !waveamdmachine.reg<vgpr, 1, 1>
  return
}

// CHECK-LABEL: func.func @fixed_sgpr_def_requires_x
// CHECK: waveamdmachine.s_load_b32
// CHECK-NEXT: waveamdmachine.s_waitcnt_split xcnt(0)
// CHECK-NEXT: waveamdmachine.s_mov_b32 "s0"
func.func @fixed_sgpr_def_requires_x(
    %source: !waveamdmachine.reg<sgpr, 1, 7>) {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %unused = waveamdmachine.s_load_b32 %zero, "s[0:1]"
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1, 6>
  waveamdmachine.s_mov_b32 "s0", %source
      : (!waveamdmachine.reg<sgpr, 1, 7>) -> ()
  return
}

// CHECK-LABEL: func.func @mixed_x_join_km_wait
// CHECK: scf.if
// CHECK: waveamdmachine.global_load_b32
// CHECK: else
// CHECK: waveamdmachine.s_load_b32
// CHECK: waveamdmachine.s_waitcnt_split kmcnt(0)
// CHECK-NEXT: waveamdmachine.s_waitcnt_split xcnt(0)
// CHECK-NEXT: waveamdmachine.s_add_i32
func.func @mixed_x_join_km_wait(
    %cond: i1,
    %off: !waveamdmachine.reg<vgpr, 1, 0>,
    %base: !waveamdmachine.reg<sgpr, 2, 0>,
    %source: !waveamdmachine.reg<sgpr, 1, 7>) {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  scf.if %cond {
    %unused = waveamdmachine.global_load_b32 %off, %base
        : (!waveamdmachine.reg<vgpr, 1, 0>,
           !waveamdmachine.reg<sgpr, 2, 0>)
          -> !waveamdmachine.reg<vgpr, 1, 5>
  } else {
    %unused = waveamdmachine.s_load_b32 %zero, "s[0:1]"
        : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1, 6>
  }
  waveamdmachine.s_waitcnt_split kmcnt(0)
  %clobber, %scc = waveamdmachine.s_add_i32 %source, %one
      : (!waveamdmachine.reg<sgpr, 1, 7>, !waveamdmachine.imm)
        -> (!waveamdmachine.reg<sgpr, 1, 0>,
            !waveamdmachine.reg<scc, 1>)
  return
}

// CHECK-LABEL: func.func @mixed_x_join_load_wait
// CHECK: scf.if
// CHECK: waveamdmachine.global_load_b32
// CHECK: else
// CHECK: waveamdmachine.s_load_b32
// CHECK: waveamdmachine.s_waitcnt_split loadcnt(0)
// CHECK-NEXT: waveamdmachine.s_waitcnt_split xcnt(0)
// CHECK-NEXT: waveamdmachine.s_add_i32
func.func @mixed_x_join_load_wait(
    %cond: i1,
    %off: !waveamdmachine.reg<vgpr, 1, 0>,
    %base: !waveamdmachine.reg<sgpr, 2, 0>,
    %source: !waveamdmachine.reg<sgpr, 1, 7>) {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  scf.if %cond {
    %unused = waveamdmachine.global_load_b32 %off, %base
        : (!waveamdmachine.reg<vgpr, 1, 0>,
           !waveamdmachine.reg<sgpr, 2, 0>)
          -> !waveamdmachine.reg<vgpr, 1, 5>
  } else {
    %unused = waveamdmachine.s_load_b32 %zero, "s[0:1]"
        : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1, 6>
  }
  waveamdmachine.s_waitcnt_split loadcnt(0)
  %clobber, %scc = waveamdmachine.s_add_i32 %source, %one
      : (!waveamdmachine.reg<sgpr, 1, 7>, !waveamdmachine.imm)
        -> (!waveamdmachine.reg<sgpr, 1, 0>,
            !waveamdmachine.reg<scc, 1>)
  return
}

// CHECK-LABEL: func.func @mixed_x_join_group_switch
// CHECK: scf.if
// CHECK: waveamdmachine.global_load_b32
// CHECK: else
// CHECK: waveamdmachine.s_load_b32
// CHECK: waveamdmachine.global_load_b32
// CHECK-NEXT: waveamdmachine.s_waitcnt_split xcnt(1)
// CHECK-NEXT: waveamdmachine.s_add_i32
func.func @mixed_x_join_group_switch(
    %cond: i1,
    %off: !waveamdmachine.reg<vgpr, 1, 0>,
    %new_off: !waveamdmachine.reg<vgpr, 1, 8>,
    %base: !waveamdmachine.reg<sgpr, 2, 0>,
    %new_base: !waveamdmachine.reg<sgpr, 2, 4>,
    %source: !waveamdmachine.reg<sgpr, 1, 7>) {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  scf.if %cond {
    %unused = waveamdmachine.global_load_b32 %off, %base
        : (!waveamdmachine.reg<vgpr, 1, 0>,
           !waveamdmachine.reg<sgpr, 2, 0>)
          -> !waveamdmachine.reg<vgpr, 1, 5>
  } else {
    %unused = waveamdmachine.s_load_b32 %zero, "s[0:1]"
        : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1, 6>
  }
  %new = waveamdmachine.global_load_b32 %new_off, %new_base
      : (!waveamdmachine.reg<vgpr, 1, 8>,
         !waveamdmachine.reg<sgpr, 2, 4>)
        -> !waveamdmachine.reg<vgpr, 1, 9>
  %clobber, %scc = waveamdmachine.s_add_i32 %source, %one
      : (!waveamdmachine.reg<sgpr, 1, 7>, !waveamdmachine.imm)
        -> (!waveamdmachine.reg<sgpr, 1, 0>,
            !waveamdmachine.reg<scc, 1>)
  return
}

// CHECK-LABEL: func.func @ds_atomics
// CHECK: waveamdmachine.ds_add_rtn_u32
// CHECK-NEXT: waveamdmachine.s_waitcnt_split dscnt(0)
// CHECK-NEXT: waveamdmachine.v_add_u32
// CHECK: waveamdmachine.ds_add_u32
// CHECK-NEXT: waveamdmachine.s_waitcnt_split dscnt(0)
// CHECK-NEXT: waveamdmachine.s_barrier
func.func @ds_atomics(
    %addr: !waveamdmachine.reg<vgpr, 1, 0>,
    %value: !waveamdmachine.reg<vgpr, 1, 1>,
    %other: !waveamdmachine.reg<vgpr, 1, 2>) {
  %old, %read = waveamdmachine.ds_add_rtn_u32 %addr, %value
      : (!waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<vgpr, 1, 1>)
        -> (!waveamdmachine.reg<vgpr, 1, 3>,
            !waveamdmachine.mem.token)
  %sum = waveamdmachine.v_add_u32 %old, %other
      : (!waveamdmachine.reg<vgpr, 1, 3>,
         !waveamdmachine.reg<vgpr, 1, 2>)
        -> !waveamdmachine.reg<vgpr, 1, 4>
  %write = waveamdmachine.ds_add_u32 %addr, %value
      : (!waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<vgpr, 1, 1>)
        -> !waveamdmachine.mem.token
  waveamdmachine.s_barrier %write
      : (!waveamdmachine.mem.token) -> ()
  return
}

// CHECK-LABEL: func.func @structured_for_ds
// CHECK: scf.for
// CHECK: waveamdmachine.ds_load_b32
// CHECK-NEXT: waveamdmachine.s_waitcnt_split dscnt(1)
// CHECK-NEXT: waveamdmachine.v_add_u32
func.func @structured_for_ds(%addr: !waveamdmachine.reg<vgpr, 1>) {
  %init = waveamdmachine.ds_load_b32 %addr
      : (!waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %c0 = arith.constant 0 : index
  %c4 = arith.constant 4 : index
  %c1 = arith.constant 1 : index
  %res = scf.for %i = %c0 to %c4 step %c1
      iter_args(%cur = %init) -> (!waveamdmachine.reg<vgpr, 1>) {
    %next = waveamdmachine.ds_load_b32 %addr
        : (!waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    %sum = waveamdmachine.v_add_u32 %addr, %cur
        : (!waveamdmachine.reg<vgpr, 1>,
           !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    scf.yield %next : !waveamdmachine.reg<vgpr, 1>
  }
  return
}

// CHECK-LABEL: func.func @cfg_store_join
// CHECK: waveamdmachine.exec_if
// CHECK: waveamdmachine.global_store_b32
// CHECK: otherwise
// CHECK: waveamdmachine.global_store_b32
// CHECK: waveamdmachine.s_waitcnt_split storecnt(0)
// CHECK-NEXT: waveamdmachine.s_barrier
func.func @cfg_store_join(
    %cond: !waveamdmachine.reg<sgpr, 1>,
    %off: !waveamdmachine.reg<vgpr, 1>,
    %value: !waveamdmachine.reg<vgpr, 1>,
    %base: !waveamdmachine.reg<sgpr, 2>) {
  %token = waveamdmachine.exec_if %cond {
    %then = waveamdmachine.global_store_b32 %off, %value, %base
        : (!waveamdmachine.reg<vgpr, 1>,
           !waveamdmachine.reg<vgpr, 1>,
           !waveamdmachine.reg<sgpr, 2>)
          -> !waveamdmachine.mem.token
    waveamdmachine.yield %then : !waveamdmachine.mem.token
  } otherwise {
    %else = waveamdmachine.global_store_b32 %off, %value, %base
        : (!waveamdmachine.reg<vgpr, 1>,
           !waveamdmachine.reg<vgpr, 1>,
           !waveamdmachine.reg<sgpr, 2>)
          -> !waveamdmachine.mem.token
    waveamdmachine.yield %else : !waveamdmachine.mem.token
  } : !waveamdmachine.reg<sgpr, 1> -> !waveamdmachine.mem.token
  waveamdmachine.s_barrier %token
      : (!waveamdmachine.mem.token) -> ()
  return
}

// CHECK-LABEL: func.func @terminal_scratch_store
// CHECK: waveamdmachine.scratch_store_b32
// CHECK-NOT: waveamdmachine.s_waitcnt
// CHECK-NOT: waveamdmachine.s_sendmsg_dealloc_vgprs
// CHECK-NEXT: waveamdmachine.s_endpgm
func.func @terminal_scratch_store() attributes {wave.kernel} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %value = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 97>
  waveamdmachine.scratch_store_b32 %zero, %value, %zero
      : (!waveamdmachine.imm,
         !waveamdmachine.reg<vgpr, 1, 97>,
         !waveamdmachine.imm) -> ()
  waveamdmachine.s_endpgm
  return
}

}
