// RUN: wave-opt %s --split-input-file --waveamd-machine-schedule='apply-schedule=1' | FileCheck %s --check-prefix=IR
// RUN: wave-opt %s --split-input-file --waveamd-machine-schedule='apply-schedule=1' --waveamd-barrier-cleanup | FileCheck %s --check-prefix=CLEANUP
// RUN: wave-opt %s --split-input-file --waveamd-machine-schedule='apply-schedule=1' 2>&1 >/dev/null | FileCheck %s --check-prefix=DIAG
// RUN: wave-opt %s --split-input-file --waveamd-machine-schedule-report='print-classes=1' 2>&1 >/dev/null | FileCheck %s --check-prefix=CLASS
// RUN: wave-opt %s --split-input-file --waveamd-machine-schedule='apply-schedule=1 max-region-ops=2' | FileCheck %s --check-prefix=CAP

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @m0_fill(%base: !waveamdmachine.reg<sgpr, 1>,
                   %off: !waveamdmachine.reg<vgpr, 1>,
                   %ptr: !waveamdmachine.reg<sgpr, 2>,
                   %a: !waveamdmachine.reg<vgpr, 1>,
                   %b: !waveamdmachine.reg<vgpr, 1>,
                   %dep: !waveamdmachine.mem.token) {
  %m0 = waveamdmachine.s_mov_m0 %base
      : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.m0
  %tok = waveamdmachine.global_load_lds_b32 %off, %ptr, %m0 after %dep
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.m0, !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  %x = waveamdmachine.v_add_u32 %a, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  return
}
}

// IR-LABEL: func.func @m0_fill
// IR: [[M0:%.*]] = waveamdmachine.s_mov_m0
// IR-NEXT: [[FILL:%.*]] = waveamdmachine.v_add_u32
// IR-NEXT: waveamdmachine.global_load_lds_b32 {{.*}}, [[M0]] after
// CAP-LABEL: func.func @m0_fill
// CAP: [[M0:%.*]] = waveamdmachine.s_mov_m0
// CAP-NEXT: waveamdmachine.global_load_lds_b32 {{.*}}, [[M0]] after
// DIAG: waveamd-machine-schedule region func=m0_fill
// DIAG-SAME: action=apply reason=m0_hazard
// DIAG-SAME: filled_gaps=1
// DIAG-SAME: m0_gaps=1

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @store_data_fill(
    %off0: !waveamdmachine.reg<vgpr, 1>,
    %data0: !waveamdmachine.reg<vgpr, 4>,
    %desc: !waveamdmachine.reg<sgpr, 4>,
    %x: !waveamdmachine.reg<vgpr, 1>,
    %y: !waveamdmachine.reg<vgpr, 1>,
    %stride: !waveamdmachine.reg<sgpr, 1>,
    %index: !waveamdmachine.reg<vgpr, 1>,
    %base: !waveamdmachine.reg<vgpr, 1>) {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %tok0 = waveamdmachine.buffer_store_b128 %off0, %data0, %desc, %zero
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<sgpr, 4>, !waveamdmachine.imm)
        -> !waveamdmachine.mem.token
  %p0 = waveamdmachine.v_cvt_pk_f16_f32 %x, %y
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %p1 = waveamdmachine.v_cvt_pk_f16_f32 %x, %y
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %p2 = waveamdmachine.v_cvt_pk_f16_f32 %x, %y
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %p3 = waveamdmachine.v_cvt_pk_f16_f32 %x, %y
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %data1 = waveamdmachine.tuple_from_elements %p0, %p1, %p2, %p3
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 4>
  %scaled = waveamdmachine.v_mul_lo_u32 %stride, %index
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %off1 = waveamdmachine.v_lshl_add_u32 %scaled, %one, %base
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm,
         !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %tok1 = waveamdmachine.buffer_store_b128 %off1, %data1, %desc, %zero
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<sgpr, 4>, !waveamdmachine.imm)
        -> !waveamdmachine.mem.token
  return
}
}

// IR-LABEL: func.func @store_data_fill
// IR: waveamdmachine.buffer_store_b128
// IR-NEXT: [[SCALED:%.*]] = waveamdmachine.v_mul_lo_u32
// IR-NEXT: [[OFF:%.*]] = waveamdmachine.v_lshl_add_u32 [[SCALED]]
// IR-NEXT: [[P0:%.*]] = waveamdmachine.v_cvt_pk_f16_f32
// IR-NEXT: [[P1:%.*]] = waveamdmachine.v_cvt_pk_f16_f32
// IR-NEXT: [[P2:%.*]] = waveamdmachine.v_cvt_pk_f16_f32
// IR-NEXT: [[P3:%.*]] = waveamdmachine.v_cvt_pk_f16_f32
// IR-NEXT: [[DATA:%.*]] = waveamdmachine.tuple_from_elements [[P0]], [[P1]], [[P2]], [[P3]]
// IR-NEXT: waveamdmachine.buffer_store_b128 [[OFF]], [[DATA]]
// DIAG: waveamd-machine-schedule region func=store_data_fill
// DIAG-SAME: action=apply reason=store_data_hazard
// DIAG-SAME: filled_gaps=2
// DIAG-SAME: store_data_gaps=2

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @memory_prefetch(
    %off: !waveamdmachine.reg<vgpr, 1>,
    %ptr: !waveamdmachine.reg<sgpr, 2>,
    %a: !waveamdmachine.reg<vgpr, 1>,
    %b: !waveamdmachine.reg<vgpr, 1>,
    %c: !waveamdmachine.reg<vgpr, 1>,
    %dep: !waveamdmachine.mem.token) {
  %x = waveamdmachine.v_add_u32 %a, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %y = waveamdmachine.v_add_u32 %x, %c
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %load_off = waveamdmachine.v_add_u32 %off, %c
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %loaded, %tok = waveamdmachine.global_load_b32 %load_off, %ptr after %dep
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %sum = waveamdmachine.v_add_u32 %y, %loaded
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  return
}
}

// IR-LABEL: func.func @memory_prefetch
// IR: [[OFF:%.*]] = waveamdmachine.v_add_u32
// IR-NEXT: [[LOADED:%.*]], {{%.*}} = waveamdmachine.global_load_b32 [[OFF]]
// IR-NEXT: [[X:%.*]] = waveamdmachine.v_add_u32
// IR-NEXT: [[Y:%.*]] = waveamdmachine.v_add_u32 [[X]]
// IR-NEXT: waveamdmachine.v_add_u32 [[Y]], [[LOADED]]
// DIAG: waveamd-machine-schedule region func=memory_prefetch
// DIAG-SAME: action=apply reason=vmem_prefetch
// DIAG-SAME: vmem_prefetch_moves=2

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @m0_fill_keeps_same_counter_order(%base: !waveamdmachine.reg<sgpr, 1>,
                                            %off0: !waveamdmachine.reg<vgpr, 1>,
                                            %off1: !waveamdmachine.reg<vgpr, 1>,
                                            %ptr: !waveamdmachine.reg<sgpr, 2>,
                                            %dep0: !waveamdmachine.mem.token,
                                            %dep1: !waveamdmachine.mem.token) {
  %m0 = waveamdmachine.s_mov_m0 %base
      : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.m0
  %tok0 = waveamdmachine.global_load_lds_b32 %off0, %ptr, %m0 after %dep0
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.m0, !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  %loaded, %tok1 = waveamdmachine.global_load_b32 %off1, %ptr after %dep1
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  return
}
}

// IR-LABEL: func.func @m0_fill_keeps_same_counter_order
// IR: [[M0:%.*]] = waveamdmachine.s_mov_m0
// IR-NEXT: waveamdmachine.global_load_lds_b32 {{.*}}, [[M0]] after
// IR-NEXT: waveamdmachine.global_load_b32
// DIAG: waveamd-machine-schedule region func=m0_fill_keeps_same_counter_order
// DIAG-SAME: action=keep reason=same_order
// DIAG-SAME: unfilled_gaps=1

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @m0_fill_keeps_same_counter_order_through_loop_arg(
    %base: !waveamdmachine.reg<sgpr, 1>,
    %off: !waveamdmachine.reg<vgpr, 1>,
    %ptr: !waveamdmachine.reg<sgpr, 2>,
    %addr: !waveamdmachine.reg<vgpr, 1>,
    %value: !waveamdmachine.reg<vgpr, 1>,
    %scc: !waveamdmachine.reg<scc, 1>) {
  %root = waveamdmachine.token : !waveamdmachine.mem.token
  %m0 = waveamdmachine.s_mov_m0 %base
      : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.m0
  %init = waveamdmachine.global_load_lds_b32 %off, %ptr, %m0 after %root
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.m0, !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  %result = waveamdmachine.uniform_loop if %scc : !waveamdmachine.reg<scc, 1>
      carries(%init : !waveamdmachine.mem.token) {
  ^bb0(%tok: !waveamdmachine.mem.token):
    %next_m0 = waveamdmachine.s_mov_m0 %base
        : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.m0
    %next = waveamdmachine.global_load_lds_b32 %off, %ptr, %next_m0 after %tok
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>,
           !waveamdmachine.m0, !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
    %store = waveamdmachine.ds_store_b32 %addr, %value after %tok
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
           !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
    waveamdmachine.continue_if %scc : !waveamdmachine.reg<scc, 1>
        carries(%next : !waveamdmachine.mem.token)
  } -> !waveamdmachine.mem.token
  return
}
}

// IR-LABEL: func.func @m0_fill_keeps_same_counter_order_through_loop_arg
// IR: ^bb0([[TOK:%.*]]: !waveamdmachine.mem.token):
// IR-NEXT: [[M0:%.*]] = waveamdmachine.s_mov_m0
// IR-NEXT: waveamdmachine.global_load_lds_b32 {{.*}}, [[M0]] after [[TOK]]
// IR-NEXT: waveamdmachine.ds_store_b32 {{.*}} after [[TOK]]
// DIAG: waveamd-machine-schedule region func=m0_fill_keeps_same_counter_order_through_loop_arg
// DIAG-SAME: action=keep reason=same_order

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @m0_fill_through_noinst(%base: !waveamdmachine.reg<sgpr, 1>,
                                  %off: !waveamdmachine.reg<vgpr, 1>,
                                  %ptr: !waveamdmachine.reg<sgpr, 2>,
                                  %wide: !waveamdmachine.reg<vgpr, 2>,
                                  %dep: !waveamdmachine.mem.token) {
  %m0 = waveamdmachine.s_mov_m0 %base
      : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.m0
  %tok = waveamdmachine.global_load_lds_b32 %off, %ptr, %m0 after %dep
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.m0, !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  %parts:2 = waveamdmachine.tuple_to_elements %wide
      : (!waveamdmachine.reg<vgpr, 2>)
        -> (!waveamdmachine.reg<vgpr, 1>,
            !waveamdmachine.reg<vgpr, 1>)
  %x = waveamdmachine.v_add_u32 %parts#0, %parts#1
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  return
}
}

// IR-LABEL: func.func @m0_fill_through_noinst
// IR: [[PARTS:%.*]]:2 = waveamdmachine.tuple_to_elements
// IR-NEXT: [[M0:%.*]] = waveamdmachine.s_mov_m0
// IR-NEXT: [[FILL:%.*]] = waveamdmachine.v_add_u32 [[PARTS]]#0, [[PARTS]]#1
// IR-NEXT: waveamdmachine.global_load_lds_b32 {{.*}}, [[M0]] after

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @valu_addr_gap_not_overfilled(%base: !waveamdmachine.reg<vgpr, 1>,
                                        %offset: !waveamdmachine.reg<vgpr, 1>,
                                        %lhs: !waveamdmachine.reg<sgpr, 1>,
                                        %rhs: !waveamdmachine.reg<sgpr, 1>,
                                        %tok: !waveamdmachine.mem.token) {
  %addr = waveamdmachine.v_add_u32 %base, %offset
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %ld, %next = waveamdmachine.ds_load_b32 %addr after %tok
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %sum, %scc = waveamdmachine.s_add_i32 %lhs, %rhs
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  return
}
}

// IR-LABEL: func.func @valu_addr_gap_not_overfilled
// IR: [[ADDR:%.*]] = waveamdmachine.v_add_u32
// IR-NEXT: {{%.*}}, {{%.*}} = waveamdmachine.ds_load_b32 [[ADDR]]
// IR-NEXT: waveamdmachine.s_add_i32
// DIAG: waveamd-machine-schedule region func=valu_addr_gap_not_overfilled
// DIAG-SAME: action=keep reason=same_order

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @barrier_memory_gap_fill(%addr: !waveamdmachine.reg<vgpr, 1>,
                                   %s0: !waveamdmachine.reg<sgpr, 1>,
                                   %s1: !waveamdmachine.reg<sgpr, 1>,
                                   %s2: !waveamdmachine.reg<sgpr, 1>,
                                   %tok: !waveamdmachine.mem.token) {
  %ld0, %t0 = waveamdmachine.ds_load_b32 %addr after %tok
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %ld1, %t1 = waveamdmachine.ds_load_b32 %addr after %t0 offset 4
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %bt = waveamdmachine.s_barrier %t1
      : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %x, %sx = waveamdmachine.s_lshl_b32 %s0, %s1
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  %y, %sy = waveamdmachine.s_add_i32 %x, %s2
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  return
}
}

// IR-LABEL: func.func @barrier_memory_gap_fill
// IR: waveamdmachine.ds_load_b32
// IR-NEXT: waveamdmachine.ds_load_b32
// IR-NEXT: [[SHIFT:%.*]], {{%.*}} = waveamdmachine.s_lshl_b32
// IR-NEXT: waveamdmachine.s_add_i32 [[SHIFT]]
// IR-NEXT: waveamdmachine.s_barrier
// DIAG: waveamd-machine-schedule region func=barrier_memory_gap_fill
// DIAG-SAME: action=apply reason=barrier_memory
// DIAG-SAME: filled_gaps=2
// DIAG-SAME: memory_token_gaps={{[2-9][0-9]*}}
// DIAG-SAME: filled_barrier_memory_gaps=2

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @trans_hazard_fill(%a: !waveamdmachine.reg<vgpr, 1>,
                             %b: !waveamdmachine.reg<vgpr, 1>,
                             %c: !waveamdmachine.reg<vgpr, 1>) {
  %trans = waveamdmachine.v_rcp_f32 %a
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %use = waveamdmachine.v_mul_f32 %trans, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %fill = waveamdmachine.v_add_u32 %b, %c
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  return
}
}

// IR-LABEL: func.func @trans_hazard_fill
// IR: [[TRANS:%.*]] = waveamdmachine.v_rcp_f32
// IR-NEXT: waveamdmachine.v_add_u32
// IR-NEXT: waveamdmachine.v_mul_f32 [[TRANS]]

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @readfirstlane_hazard_fill(%a: !waveamdmachine.reg<vgpr, 1>,
                                     %b: !waveamdmachine.reg<vgpr, 1>,
                                     %c: !waveamdmachine.reg<vgpr, 1>) {
  %sum = waveamdmachine.v_add_u32 %a, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %first = waveamdmachine.v_readfirstlane_b32 %sum
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
  %fill = waveamdmachine.v_xor_b32 %b, %c
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  return
}
}

// IR-LABEL: func.func @readfirstlane_hazard_fill
// IR: [[SUM:%.*]] = waveamdmachine.v_add_u32
// IR-NEXT: waveamdmachine.v_xor_b32
// IR-NEXT: waveamdmachine.v_readfirstlane_b32 [[SUM]]

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @vcc_hazard_fill(%a: !waveamdmachine.reg<vgpr, 1>,
                           %b: !waveamdmachine.reg<vgpr, 1>,
                           %c: !waveamdmachine.reg<vgpr, 1>,
                           %d: !waveamdmachine.reg<vgpr, 1>) {
  %mask, %vcc = waveamdmachine.v_cmp_ge_u32_vcc %a, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.reg<vcc, 1>)
  %sum = waveamdmachine.v_add_u32 %a, %c
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %pick = waveamdmachine.v_cndmask_b32_vcc %a, %sum, %vcc
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vcc, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %fill = waveamdmachine.v_xor_b32 %c, %d
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  return
}
}

// IR-LABEL: func.func @vcc_hazard_fill
// IR: {{%.*}}, [[VCC:%.*]] = waveamdmachine.v_cmp_ge_u32_vcc
// IR-NEXT: [[SUM:%.*]] = waveamdmachine.v_add_u32
// IR-NEXT: waveamdmachine.v_xor_b32
// IR-NEXT: waveamdmachine.v_cndmask_b32_vcc {{.*}}, [[SUM]], [[VCC]]

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @cluster_barrier_pair_after_compute(
    %a: !waveamdmachine.reg<vgpr, 4>,
    %b: !waveamdmachine.reg<vgpr, 4>,
    %acc: !waveamdmachine.reg<vgpr, 4>,
    %x: !waveamdmachine.reg<sgpr, 1>,
    %y: !waveamdmachine.reg<sgpr, 1>,
    %tok0: !waveamdmachine.mem.token,
    %tok1: !waveamdmachine.mem.token) {
  %mma = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %barrier0 = waveamdmachine.s_barrier %tok0
      : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %sum, %scc = waveamdmachine.s_add_i32 %x, %y
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  %barrier1 = waveamdmachine.s_barrier %tok1
      : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %joined = waveamdmachine.token_join %barrier0, %barrier1
      : (!waveamdmachine.mem.token, !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  return
}
}

// IR-LABEL: func.func @cluster_barrier_pair_after_compute
// IR: waveamdmachine.mfma_f32_16x16x32_f16
// IR-NEXT: waveamdmachine.s_add_i32
// IR-NEXT: [[BARRIER0:%.*]] = waveamdmachine.s_barrier
// IR-NEXT: [[BARRIER1:%.*]] = waveamdmachine.s_barrier
// IR-NEXT: waveamdmachine.token_join [[BARRIER0]], [[BARRIER1]]
// DIAG: waveamd-machine-schedule region func=cluster_barrier_pair_after_compute
// DIAG-SAME: action=apply reason=greedy
// CLEANUP-LABEL: func.func @cluster_barrier_pair_after_compute
// CLEANUP: waveamdmachine.mfma_f32_16x16x32_f16
// CLEANUP-NEXT: waveamdmachine.s_add_i32
// CLEANUP-NEXT: [[BARRIER:%.*]] = waveamdmachine.s_barrier
// CLEANUP-NOT: waveamdmachine.s_barrier
// CLEANUP: return

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @split_barrier_arrive_token_gap_fill(
    %addr_base: !waveamdmachine.reg<vgpr, 1>,
    %addr_off: !waveamdmachine.reg<vgpr, 1>,
    %value: !waveamdmachine.reg<vgpr, 1>,
    %s0: !waveamdmachine.reg<sgpr, 1>,
    %s1: !waveamdmachine.reg<sgpr, 1>,
    %s2: !waveamdmachine.reg<sgpr, 1>,
    %s3: !waveamdmachine.reg<sgpr, 1>) {
  %state = waveamdmachine.barrier_init : !waveamdmachine.barrier
  %root = waveamdmachine.token : !waveamdmachine.mem.token
  %addr = waveamdmachine.v_add_u32 %addr_base, %addr_off
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %stored = waveamdmachine.ds_store_b32 %addr, %value after %root
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  %x, %sx = waveamdmachine.s_add_i32 %s0, %s1
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  %ticket, %arrived = waveamdmachine.barrier_arrive %state after %stored
      : (!waveamdmachine.barrier, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %ready = waveamdmachine.barrier_wait %state, %ticket after %arrived
      : (!waveamdmachine.barrier, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  %y, %sy = waveamdmachine.s_lshl_b32 %s2, %s3
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  return
}
}

// IR-LABEL: func.func @split_barrier_arrive_token_gap_fill
// IR: [[STATE:%.*]] = waveamdmachine.barrier_init
// IR-NEXT: [[ROOT:%.*]] = waveamdmachine.token
// IR-NEXT: [[ADDR:%.*]] = waveamdmachine.v_add_u32
// IR-NEXT: [[STORED:%.*]] = waveamdmachine.ds_store_b32 [[ADDR]]{{.*}} after [[ROOT]]
// IR-NEXT: waveamdmachine.s_add_i32
// IR-NEXT: waveamdmachine.s_lshl_b32
// IR-NEXT: [[TICKET:%.*]], [[ARRIVED:%.*]] = waveamdmachine.barrier_arrive [[STATE]] after [[STORED]]
// IR-NEXT: {{%.*}} = waveamdmachine.barrier_wait [[STATE]], [[TICKET]] after [[ARRIVED]]
// DIAG: waveamd-machine-schedule region func=split_barrier_arrive_token_gap_fill
// DIAG-SAME: action=apply reason=greedy
// CLASS: op func=split_barrier_arrive_token_gap_fill{{.*}}name=waveamdmachine.barrier_arrive
// CLASS-SAME: class=WriteLDS fu=LGKM
// CLASS: op func=split_barrier_arrive_token_gap_fill{{.*}}name=waveamdmachine.barrier_wait
// CLASS-SAME: class=WriteBarrier fu=BRANCH

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @split_barrier_arrive_after_valu_token_delay(
    %addr: !waveamdmachine.reg<vgpr, 1>,
    %value: !waveamdmachine.reg<vgpr, 1>,
    %a: !waveamdmachine.reg<vgpr, 1>,
    %b: !waveamdmachine.reg<vgpr, 1>) {
  %state = waveamdmachine.barrier_init : !waveamdmachine.barrier
  %root = waveamdmachine.token : !waveamdmachine.mem.token
  %stored = waveamdmachine.ds_store_b32 %addr, %value after %root
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  %v0 = waveamdmachine.v_add_u32 %a, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %v1 = waveamdmachine.v_add_u32 %a, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %v2 = waveamdmachine.v_add_u32 %a, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %v3 = waveamdmachine.v_add_u32 %a, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %v4 = waveamdmachine.v_add_u32 %a, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %v5 = waveamdmachine.v_add_u32 %a, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %v6 = waveamdmachine.v_add_u32 %a, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %v7 = waveamdmachine.v_add_u32 %a, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %v8 = waveamdmachine.v_add_u32 %a, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %v9 = waveamdmachine.v_add_u32 %a, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %v10 = waveamdmachine.v_add_u32 %a, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %v11 = waveamdmachine.v_add_u32 %a, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %v12 = waveamdmachine.v_add_u32 %a, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %v13 = waveamdmachine.v_add_u32 %a, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %v14 = waveamdmachine.v_add_u32 %a, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %v15 = waveamdmachine.v_add_u32 %a, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %ticket, %arrived = waveamdmachine.barrier_arrive %state after %stored
      : (!waveamdmachine.barrier, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %ready = waveamdmachine.barrier_wait %state, %ticket after %arrived
      : (!waveamdmachine.barrier, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  return
}
}

// IR-LABEL: func.func @split_barrier_arrive_after_valu_token_delay
// IR: [[STATE:%.*]] = waveamdmachine.barrier_init
// IR-NEXT: [[ROOT:%.*]] = waveamdmachine.token
// IR-NEXT: [[STORED:%.*]] = waveamdmachine.ds_store_b32{{.*}} after [[ROOT]]
// IR-NEXT: waveamdmachine.v_add_u32
// IR-NEXT: waveamdmachine.v_add_u32
// IR-NEXT: waveamdmachine.v_add_u32
// IR-NEXT: waveamdmachine.v_add_u32
// IR-NEXT: [[TICKET:%.*]], [[ARRIVED:%.*]] = waveamdmachine.barrier_arrive [[STATE]] after [[STORED]]
// IR-NEXT: waveamdmachine.v_add_u32
// IR: {{%.*}} = waveamdmachine.barrier_wait [[STATE]], [[TICKET]] after [[ARRIVED]]
// DIAG: waveamd-machine-schedule region func=split_barrier_arrive_after_valu_token_delay
// DIAG-SAME: action=apply reason=greedy

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @split_barrier_arrive_after_mfma_token_delay(
    %addr: !waveamdmachine.reg<vgpr, 1>,
    %value: !waveamdmachine.reg<vgpr, 1>,
    %a: !waveamdmachine.reg<vgpr, 4>,
    %b: !waveamdmachine.reg<vgpr, 4>,
    %acc: !waveamdmachine.reg<vgpr, 4>) {
  %state = waveamdmachine.barrier_init : !waveamdmachine.barrier
  %root = waveamdmachine.token : !waveamdmachine.mem.token
  %stored = waveamdmachine.ds_store_b32 %addr, %value after %root
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  %r0 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r1 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r2 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r3 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r4 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r5 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r6 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r7 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r8 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r9 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r10 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r11 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r12 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r13 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r14 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r15 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %ticket, %arrived = waveamdmachine.barrier_arrive %state after %stored
      : (!waveamdmachine.barrier, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %ready = waveamdmachine.barrier_wait %state, %ticket after %arrived
      : (!waveamdmachine.barrier, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  return
}
}

// IR-LABEL: func.func @split_barrier_arrive_after_mfma_token_delay
// IR: [[STORED:%.*]] = waveamdmachine.ds_store_b32
// IR-NEXT: waveamdmachine.mfma_f32_16x16x32_f16
// IR-NEXT: waveamdmachine.mfma_f32_16x16x32_f16
// IR-NEXT: waveamdmachine.mfma_f32_16x16x32_f16
// IR-NEXT: waveamdmachine.mfma_f32_16x16x32_f16
// IR-NEXT: [[TICKET:%.*]], [[ARRIVED:%.*]] = waveamdmachine.barrier_arrive {{%.*}} after [[STORED]]
// IR-NEXT: waveamdmachine.mfma_f32_16x16x32_f16
// IR: {{%.*}} = waveamdmachine.barrier_wait {{%.*}}, [[TICKET]] after [[ARRIVED]]
// DIAG: waveamd-machine-schedule region func=split_barrier_arrive_after_mfma_token_delay
// DIAG-SAME: action=apply reason=greedy

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @split_barrier_arrive_keeps_lgkm_producer_before_arrive(
    %addr: !waveamdmachine.reg<vgpr, 1>,
    %value: !waveamdmachine.reg<vgpr, 1>,
    %a: !waveamdmachine.reg<vgpr, 4>,
    %b: !waveamdmachine.reg<vgpr, 4>,
    %acc: !waveamdmachine.reg<vgpr, 4>) {
  %state = waveamdmachine.barrier_init : !waveamdmachine.barrier
  %root = waveamdmachine.token : !waveamdmachine.mem.token
  %stored = waveamdmachine.ds_store_b32 %addr, %value after %root
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  %read, %read_token = waveamdmachine.ds_read_tr_b64_b8 %addr after %root
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.mem.token)
  %r0 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r1 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r2 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r3 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r4 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r5 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r6 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r7 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r8 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r9 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r10 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r11 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r12 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r13 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r14 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %r15 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %ticket, %arrived = waveamdmachine.barrier_arrive %state after %stored
      : (!waveamdmachine.barrier, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %ready = waveamdmachine.barrier_wait %state, %ticket after %arrived
      : (!waveamdmachine.barrier, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  return
}
}

// IR-LABEL: func.func @split_barrier_arrive_keeps_lgkm_producer_before_arrive
// IR: [[STORED:%.*]] = waveamdmachine.ds_store_b32
// IR-NEXT: {{%.*}}, {{%.*}} = waveamdmachine.ds_read_tr_b64_b8
// IR-NEXT: waveamdmachine.mfma_f32_16x16x32_f16
// IR-NEXT: waveamdmachine.mfma_f32_16x16x32_f16
// IR-NEXT: waveamdmachine.mfma_f32_16x16x32_f16
// IR-NEXT: [[TICKET:%.*]], [[ARRIVED:%.*]] = waveamdmachine.barrier_arrive {{%.*}} after [[STORED]]
// IR-NEXT: waveamdmachine.mfma_f32_16x16x32_f16
// IR: {{%.*}} = waveamdmachine.barrier_wait {{%.*}}, [[TICKET]] after [[ARRIVED]]
// DIAG: waveamd-machine-schedule region func=split_barrier_arrive_keeps_lgkm_producer_before_arrive
// DIAG-SAME: action=apply reason=greedy

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @split_barrier_arrive_memory_window_keep(
    %addr: !waveamdmachine.reg<vgpr, 1>,
    %base: !waveamdmachine.reg<sgpr, 2>,
    %value: !waveamdmachine.reg<vgpr, 1>) {
  %state = waveamdmachine.barrier_init : !waveamdmachine.barrier
  %root = waveamdmachine.token : !waveamdmachine.mem.token
  %stored = waveamdmachine.ds_store_b32 %addr, %value after %root
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  %g0, %t0 = waveamdmachine.global_load_b32 %addr, %base after %root
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %g1, %t1 = waveamdmachine.global_load_b32 %addr, %base after %root
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %g2, %t2 = waveamdmachine.global_load_b32 %addr, %base after %root
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %g3, %t3 = waveamdmachine.global_load_b32 %addr, %base after %root
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %ticket, %arrived = waveamdmachine.barrier_arrive %state after %stored
      : (!waveamdmachine.barrier, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %ready = waveamdmachine.barrier_wait %state, %ticket after %arrived
      : (!waveamdmachine.barrier, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  return
}
}

// IR-LABEL: func.func @split_barrier_arrive_memory_window_keep
// IR: [[STORED:%.*]] = waveamdmachine.ds_store_b32
// IR-NEXT: waveamdmachine.global_load_b32
// IR-NEXT: waveamdmachine.global_load_b32
// IR-NEXT: waveamdmachine.global_load_b32
// IR-NEXT: waveamdmachine.global_load_b32
// IR-NEXT: [[TICKET:%.*]], [[ARRIVED:%.*]] = waveamdmachine.barrier_arrive {{%.*}} after [[STORED]]
// IR-NEXT: {{%.*}} = waveamdmachine.barrier_wait {{%.*}}, [[TICKET]] after [[ARRIVED]]
// DIAG: waveamd-machine-schedule region func=split_barrier_arrive_memory_window_keep
// DIAG-SAME: action=keep reason=same_order

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @barrier_keep(%off: !waveamdmachine.reg<vgpr, 1>,
                        %base: !waveamdmachine.reg<sgpr, 2>,
                        %a: !waveamdmachine.reg<vgpr, 1>,
                        %b: !waveamdmachine.reg<vgpr, 1>) {
  %tok0 = waveamdmachine.token : !waveamdmachine.mem.token
  %loaded, %tok1 = waveamdmachine.global_load_b32 %off, %base after %tok0
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %tok2 = waveamdmachine.s_barrier %tok1
      : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %x = waveamdmachine.v_add_u32 %a, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  return
}
}

// IR-LABEL: func.func @barrier_keep
// IR: [[TOK0:%.*]] = waveamdmachine.token
// IR-NEXT: {{%.*}}, [[TOK1:%.*]] = waveamdmachine.global_load_b32
// IR-NEXT: waveamdmachine.v_add_u32
// IR-NEXT: {{%.*}} = waveamdmachine.s_barrier [[TOK1]]
// DIAG: waveamd-machine-schedule region func=barrier_keep
// DIAG-SAME: action=apply reason=barrier_memory
// DIAG-SAME: filled_gaps=1
// DIAG-SAME: memory_token_gaps={{[1-9][0-9]*}}
// DIAG-SAME: filled_barrier_memory_gaps=1

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @single_barrier_memory_gap_fill(%addr: !waveamdmachine.reg<vgpr, 1>,
                                          %s0: !waveamdmachine.reg<sgpr, 1>,
                                          %s1: !waveamdmachine.reg<sgpr, 1>,
                                          %s2: !waveamdmachine.reg<sgpr, 1>,
                                          %s3: !waveamdmachine.reg<sgpr, 1>,
                                          %tok: !waveamdmachine.mem.token) {
  %ld, %t0 = waveamdmachine.ds_load_b32 %addr after %tok
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %t1 = waveamdmachine.s_barrier %t0
      : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %x, %sx = waveamdmachine.s_add_i32 %s0, %s1
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  %y, %sy = waveamdmachine.s_lshl_b32 %s2, %s3
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  return
}
}

// IR-LABEL: func.func @single_barrier_memory_gap_fill
// IR: [[LD:%.*]], [[TOK:%.*]] = waveamdmachine.ds_load_b32
// IR-NEXT: waveamdmachine.s_add_i32
// IR-NEXT: waveamdmachine.s_lshl_b32
// IR-NEXT: {{%.*}} = waveamdmachine.s_barrier [[TOK]]
// DIAG: waveamd-machine-schedule region func=single_barrier_memory_gap_fill
// DIAG-SAME: action=apply reason=barrier_memory
// DIAG-SAME: filled_gaps=2
// DIAG-SAME: memory_token_gaps={{[2-9][0-9]*}}
// DIAG-SAME: filled_barrier_memory_gaps=2
