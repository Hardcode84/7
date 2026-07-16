// RUN: wave-opt %s --split-input-file --waveamd-machine-schedule='apply-schedule=1' | FileCheck %s --check-prefix=IR
// RUN: wave-opt %s --split-input-file --waveamd-machine-schedule='apply-schedule=1' 2>&1 >/dev/null | FileCheck %s --check-prefix=DIAG

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @fill_loop_carried_wait(
    %addr: !waveamdmachine.reg<vgpr, 1>,
    %off: !waveamdmachine.reg<vgpr, 1>,
    %desc: !waveamdmachine.reg<sgpr, 4>,
    %soff: !waveamdmachine.reg<sgpr, 1>,
    %m0: !waveamdmachine.m0,
    %x: !waveamdmachine.reg<sgpr, 1>,
    %y: !waveamdmachine.reg<sgpr, 1>,
    %cond: !waveamdmachine.reg<scc, 1>,
    %root: !waveamdmachine.mem.token) {
  %loaded, %init = waveamdmachine.ds_load_b32 %addr after %root
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %loop:3 = waveamdmachine.uniform_loop if %cond
      : !waveamdmachine.reg<scc, 1>
      carries(%init, %loaded, %x : !waveamdmachine.mem.token,
              !waveamdmachine.reg<vgpr, 1>,
              !waveamdmachine.reg<sgpr, 1>) {
  ^bb0(%tok: !waveamdmachine.mem.token,
       %tile: !waveamdmachine.reg<vgpr, 1>,
       %iv: !waveamdmachine.reg<sgpr, 1>):
    %dma = waveamdmachine.buffer_load_lds_b128
        %off, %desc, %soff, %m0 after %tok
        {waveamdmachine.dma_issue_timing}
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
           !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.m0,
           !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    %dependent = waveamdmachine.v_add_u32 %tile, %addr
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    %sum, %scc = waveamdmachine.s_add_i32 %iv, %y
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
          -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
        carries(%dma, %dependent, %sum : !waveamdmachine.mem.token,
                !waveamdmachine.reg<vgpr, 1>,
                !waveamdmachine.reg<sgpr, 1>)
  } -> !waveamdmachine.mem.token, !waveamdmachine.reg<vgpr, 1>,
       !waveamdmachine.reg<sgpr, 1>
  return
}
}

// IR-LABEL: func.func @fill_loop_carried_wait
// IR: waveamdmachine.uniform_loop
// IR: ^bb0
// IR-NEXT: waveamdmachine.s_add_i32
// IR-NEXT: waveamdmachine.buffer_load_lds_b128
// IR: waveamdmachine.v_add_u32
// DIAG: waveamd-machine-schedule region func=fill_loop_carried_wait index=1
// DIAG-SAME: action=apply reason=loop_wait
// DIAG-SAME: loop_carried_wait_fills=1

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @reject_same_counter_value(
    %addr: !waveamdmachine.reg<vgpr, 1>,
    %off: !waveamdmachine.reg<vgpr, 1>,
    %desc: !waveamdmachine.reg<sgpr, 4>,
    %soff: !waveamdmachine.reg<sgpr, 1>,
    %m0: !waveamdmachine.m0,
    %cond: !waveamdmachine.reg<scc, 1>,
    %root: !waveamdmachine.mem.token) {
  %loaded, %init = waveamdmachine.ds_load_b32 %addr after %root
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %loop:2 = waveamdmachine.uniform_loop if %cond
      : !waveamdmachine.reg<scc, 1>
      carries(%init, %loaded : !waveamdmachine.mem.token,
              !waveamdmachine.reg<vgpr, 1>) {
  ^bb0(%tok: !waveamdmachine.mem.token,
       %tile: !waveamdmachine.reg<vgpr, 1>):
    %dma = waveamdmachine.buffer_load_lds_b128
        %off, %desc, %soff, %m0 after %tok
        {waveamdmachine.dma_issue_timing}
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
           !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.m0,
           !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    %dependent = waveamdmachine.v_add_u32 %tile, %addr
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
        carries(%dma, %dependent : !waveamdmachine.mem.token,
                !waveamdmachine.reg<vgpr, 1>)
  } -> !waveamdmachine.mem.token, !waveamdmachine.reg<vgpr, 1>
  return
}
}

// IR-LABEL: func.func @reject_same_counter_value
// IR: ^bb0
// IR-NEXT: waveamdmachine.buffer_load_lds_b128
// IR-NEXT: waveamdmachine.v_add_u32
// DIAG: waveamd-machine-schedule region func=reject_same_counter_value index=1
// DIAG-SAME: loop_carried_wait_fills=0

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @reject_transitive_memory_value(
    %off: !waveamdmachine.reg<vgpr, 1>,
    %desc: !waveamdmachine.reg<sgpr, 4>,
    %soff: !waveamdmachine.reg<sgpr, 1>,
    %m0: !waveamdmachine.m0,
    %ptr: !waveamdmachine.reg<sgpr, 2>,
    %cond: !waveamdmachine.reg<scc, 1>,
    %root: !waveamdmachine.mem.token) {
  %loaded, %init = waveamdmachine.global_load_b64 %off, %ptr after %root
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.mem.token)
  %loop:2 = waveamdmachine.uniform_loop if %cond
      : !waveamdmachine.reg<scc, 1>
      carries(%init, %loaded : !waveamdmachine.mem.token,
              !waveamdmachine.reg<vgpr, 2>) {
  ^bb0(%tok: !waveamdmachine.mem.token,
       %tile: !waveamdmachine.reg<vgpr, 2>):
    %dma = waveamdmachine.buffer_load_lds_b128
        %off, %desc, %soff, %m0 after %tok
        {waveamdmachine.dma_issue_timing}
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
           !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.m0,
           !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    %parts:2 = waveamdmachine.tuple_to_elements %tile
        : (!waveamdmachine.reg<vgpr, 2>)
          -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
    %derived = waveamdmachine.v_add_u32 %parts#0, %off
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
        carries(%dma, %tile : !waveamdmachine.mem.token,
                !waveamdmachine.reg<vgpr, 2>)
  } -> !waveamdmachine.mem.token, !waveamdmachine.reg<vgpr, 2>
  return
}
}

// IR-LABEL: func.func @reject_transitive_memory_value
// IR: ^bb0
// IR-NEXT: [[PARTS:%.*]]:2 = waveamdmachine.tuple_to_elements
// IR-NEXT: waveamdmachine.buffer_load_lds_b128
// IR-NEXT: waveamdmachine.v_add_u32 [[PARTS]]#0
// DIAG: waveamd-machine-schedule region func=reject_transitive_memory_value index=1
// DIAG-SAME: loop_carried_wait_fills=0

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @scope_fill_to_marked_loop(
    %addr: !waveamdmachine.reg<vgpr, 1>,
    %off: !waveamdmachine.reg<vgpr, 1>,
    %desc: !waveamdmachine.reg<sgpr, 4>,
    %soff: !waveamdmachine.reg<sgpr, 1>,
    %m0: !waveamdmachine.m0,
    %x: !waveamdmachine.reg<sgpr, 1>,
    %y: !waveamdmachine.reg<sgpr, 1>,
    %cond: !waveamdmachine.reg<scc, 1>,
    %root: !waveamdmachine.mem.token) {
  %first_init = waveamdmachine.ds_store_b32 %addr, %addr after %root
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %first:2 = waveamdmachine.uniform_loop if %cond
      : !waveamdmachine.reg<scc, 1>
      carries(%first_init, %x : !waveamdmachine.mem.token,
              !waveamdmachine.reg<sgpr, 1>) {
  ^bb0(%tok: !waveamdmachine.mem.token,
       %iv: !waveamdmachine.reg<sgpr, 1>):
    %dma = waveamdmachine.buffer_load_lds_b128
        %off, %desc, %soff, %m0 after %tok
        {waveamdmachine.dma_issue_timing}
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
           !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.m0,
           !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    %sum, %scc = waveamdmachine.s_add_i32 %iv, %y
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
          -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
        carries(%dma, %sum : !waveamdmachine.mem.token,
                !waveamdmachine.reg<sgpr, 1>)
  } -> !waveamdmachine.mem.token, !waveamdmachine.reg<sgpr, 1>
  %second_init = waveamdmachine.ds_store_b32 %addr, %addr after %root
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %second:2 = waveamdmachine.uniform_loop if %cond
      : !waveamdmachine.reg<scc, 1>
      carries(%second_init, %x : !waveamdmachine.mem.token,
              !waveamdmachine.reg<sgpr, 1>) {
  ^bb0(%tok: !waveamdmachine.mem.token,
       %iv: !waveamdmachine.reg<sgpr, 1>):
    %dma = waveamdmachine.buffer_load_lds_b128
        %off, %desc, %soff, %m0 after %tok
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
           !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.m0,
           !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    %sum, %scc = waveamdmachine.s_add_i32 %iv, %y
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
          -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
        carries(%dma, %sum : !waveamdmachine.mem.token,
                !waveamdmachine.reg<sgpr, 1>)
  } -> !waveamdmachine.mem.token, !waveamdmachine.reg<sgpr, 1>
  return
}
}

// IR-LABEL: func.func @scope_fill_to_marked_loop
// IR: %{{.*}}:2 = waveamdmachine.uniform_loop
// IR: ^bb0
// IR-NEXT: waveamdmachine.s_add_i32
// IR-NEXT: waveamdmachine.buffer_load_lds_b128
// IR: %{{.*}}:2 = waveamdmachine.uniform_loop
// IR: ^bb0
// IR-NEXT: waveamdmachine.buffer_load_lds_b128
// IR-NEXT: waveamdmachine.s_add_i32
// DIAG: waveamd-machine-schedule region func=scope_fill_to_marked_loop index=1
// DIAG-SAME: action=apply reason=loop_wait
// DIAG: waveamd-machine-schedule region func=scope_fill_to_marked_loop index=3
// DIAG-SAME: loop_carried_wait_fills=0

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @pressure_fallback_keeps_original_order(
    %addr: !waveamdmachine.reg<vgpr, 1>,
    %off: !waveamdmachine.reg<vgpr, 1>,
    %d0: !waveamdmachine.reg<sgpr, 1>,
    %d1: !waveamdmachine.reg<sgpr, 1>,
    %d2: !waveamdmachine.reg<sgpr, 1>,
    %d3: !waveamdmachine.reg<sgpr, 1>,
    %soff: !waveamdmachine.reg<sgpr, 1>,
    %m0: !waveamdmachine.m0,
    %x: !waveamdmachine.reg<sgpr, 1>,
    %y: !waveamdmachine.reg<sgpr, 1>,
    %cond: !waveamdmachine.reg<scc, 1>,
    %root: !waveamdmachine.mem.token)
    attributes {waveamdmachine.sgpr_count_max = 1 : i64} {
  %init = waveamdmachine.ds_store_b32 %addr, %addr after %root
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %loop:2 = waveamdmachine.uniform_loop if %cond
      : !waveamdmachine.reg<scc, 1>
      carries(%init, %x : !waveamdmachine.mem.token,
              !waveamdmachine.reg<sgpr, 1>) {
  ^bb0(%tok: !waveamdmachine.mem.token,
       %iv: !waveamdmachine.reg<sgpr, 1>):
    %desc = waveamdmachine.tuple_from_elements %d0, %d1, %d2, %d3
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>,
           !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
          -> !waveamdmachine.reg<sgpr, 4>
    %dma = waveamdmachine.buffer_load_lds_b128
        %off, %desc, %soff, %m0 after %tok
        {waveamdmachine.dma_issue_timing}
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
           !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.m0,
           !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    %sum, %scc = waveamdmachine.s_add_i32 %iv, %y
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
          -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
        carries(%dma, %sum : !waveamdmachine.mem.token,
                !waveamdmachine.reg<sgpr, 1>)
  } -> !waveamdmachine.mem.token, !waveamdmachine.reg<sgpr, 1>
  return
}
}

// IR-LABEL: func.func @pressure_fallback_keeps_original_order
// IR: ^bb0
// IR-NEXT: [[DESC:%.*]] = waveamdmachine.tuple_from_elements
// IR-NEXT: waveamdmachine.buffer_load_lds_b128 {{.*}}, [[DESC]]
// IR-NEXT: waveamdmachine.s_add_i32
// DIAG: waveamd-machine-schedule region func=pressure_fallback_keeps_original_order index=1
// DIAG-SAME: loop_carried_wait_fills=0
