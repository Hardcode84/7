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
// IR-NEXT: waveamdmachine.v_add_u32
// IR-NEXT: waveamdmachine.s_add_i32
// IR-NEXT: waveamdmachine.buffer_load_lds_b128
// DIAG: waveamd-machine-schedule region func=fill_loop_carried_wait index=1
// DIAG-SAME: action=apply reason=loop_wait
// DIAG-SAME: steady_state_fills=2
// DIAG-SAME: steady_state_iterations=4
// DIAG-SAME: steady_state_refinements=2

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @fill_steady_dma_queue(
    %off: !waveamdmachine.reg<vgpr, 1>,
    %desc: !waveamdmachine.reg<sgpr, 4>,
    %soff: !waveamdmachine.reg<sgpr, 1>,
    %m0: !waveamdmachine.m0,
    %iv: !waveamdmachine.reg<sgpr, 1>,
    %step: !waveamdmachine.reg<sgpr, 1>,
    %cond: !waveamdmachine.reg<scc, 1>,
    %root: !waveamdmachine.mem.token) {
  %loop = waveamdmachine.uniform_loop if %cond
      : !waveamdmachine.reg<scc, 1>
      carries(%iv : !waveamdmachine.reg<sgpr, 1>) {
  ^bb0(%iter: !waveamdmachine.reg<sgpr, 1>):
    %dma0 = waveamdmachine.buffer_load_lds_b128
        %off, %desc, %soff, %m0 after %root
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
           !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.m0,
           !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    %dma1 = waveamdmachine.buffer_load_lds_b128
        %off, %desc, %soff, %m0 after %root
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
           !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.m0,
           !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    %dma2 = waveamdmachine.buffer_load_lds_b128
        %off, %desc, %soff, %m0 after %root
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
           !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.m0,
           !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    %dma3 = waveamdmachine.buffer_load_lds_b128
        %off, %desc, %soff, %m0 after %root
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
           !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.m0,
           !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    %dma4 = waveamdmachine.buffer_load_lds_b128
        %off, %desc, %soff, %m0 after %root
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
           !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.m0,
           !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    %dma5 = waveamdmachine.buffer_load_lds_b128
        %off, %desc, %soff, %m0 after %root
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
           !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.m0,
           !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    %dma6 = waveamdmachine.buffer_load_lds_b128
        %off, %desc, %soff, %m0 after %root
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
           !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.m0,
           !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    %dma7 = waveamdmachine.buffer_load_lds_b128
        %off, %desc, %soff, %m0 after %root
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
           !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.m0,
           !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    %next0, %scc0 = waveamdmachine.s_add_i32 %iter, %step
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
          -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %next1, %scc1 = waveamdmachine.s_add_i32 %next0, %step
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
          -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %next2, %scc2 = waveamdmachine.s_add_i32 %next1, %step
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
          -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %next3, %scc3 = waveamdmachine.s_add_i32 %next2, %step
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
          -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %next4, %scc4 = waveamdmachine.s_add_i32 %next3, %step
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
          -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %next5, %scc5 = waveamdmachine.s_add_i32 %next4, %step
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
          -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %next6, %scc6 = waveamdmachine.s_add_i32 %next5, %step
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
          -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %next7, %scc7 = waveamdmachine.s_add_i32 %next6, %step
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
          -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %next8, %scc8 = waveamdmachine.s_add_i32 %next7, %step
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
          -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %next9, %scc9 = waveamdmachine.s_add_i32 %next8, %step
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
          -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %next10, %scc10 = waveamdmachine.s_add_i32 %next9, %step
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
          -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %next11, %scc11 = waveamdmachine.s_add_i32 %next10, %step
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
          -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %next12, %scc12 = waveamdmachine.s_add_i32 %next11, %step
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
          -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %next13, %scc13 = waveamdmachine.s_add_i32 %next12, %step
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
          -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %next14, %scc14 = waveamdmachine.s_add_i32 %next13, %step
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
          -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %next15, %scc15 = waveamdmachine.s_add_i32 %next14, %step
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
          -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %next16, %scc16 = waveamdmachine.s_add_i32 %next15, %step
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
          -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    waveamdmachine.continue_if %scc16 : !waveamdmachine.reg<scc, 1>
        carries(%next16 : !waveamdmachine.reg<sgpr, 1>)
  } -> !waveamdmachine.reg<sgpr, 1>
  return
}
}

// IR-LABEL: func.func @fill_steady_dma_queue
// IR: ^bb0
// IR-COUNT-16: waveamdmachine.s_add_i32
// IR-NEXT: waveamdmachine.buffer_load_lds_b128
// DIAG: waveamd-machine-schedule region func=fill_steady_dma_queue index=0
// DIAG-SAME: action=apply reason=loop_wait
// DIAG-SAME: steady_state_fills=17
// DIAG-SAME: steady_state_iterations=4
// DIAG-SAME: steady_state_refinements=3

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @fill_same_counter_value(
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

// IR-LABEL: func.func @fill_same_counter_value
// IR: ^bb0
// IR-NEXT: waveamdmachine.v_add_u32
// IR-NEXT: waveamdmachine.buffer_load_lds_b128
// DIAG: waveamd-machine-schedule region func=fill_same_counter_value index=1
// DIAG-SAME: action=apply reason=loop_wait
// DIAG-SAME: steady_state_fills=1
// DIAG-SAME: steady_state_iterations=4

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @fill_transitive_memory_value(
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

// IR-LABEL: func.func @fill_transitive_memory_value
// IR: ^bb0
// IR-NEXT: [[PARTS:%.*]]:2 = waveamdmachine.tuple_to_elements
// IR-NEXT: waveamdmachine.v_add_u32 [[PARTS]]#0
// IR-NEXT: waveamdmachine.buffer_load_lds_b128
// DIAG: waveamd-machine-schedule region func=fill_transitive_memory_value index=1
// DIAG-SAME: action=apply reason=loop_wait
// DIAG-SAME: steady_state_fills=1
// DIAG-SAME: steady_state_iterations=4

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @enable_every_uniform_loop(
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

// IR-LABEL: func.func @enable_every_uniform_loop
// IR: %{{.*}}:2 = waveamdmachine.uniform_loop
// IR: ^bb0
// IR-NEXT: waveamdmachine.s_add_i32
// IR-NEXT: waveamdmachine.buffer_load_lds_b128
// IR: %{{.*}}:2 = waveamdmachine.uniform_loop
// IR: ^bb0
// IR-NEXT: waveamdmachine.s_add_i32
// IR-NEXT: waveamdmachine.buffer_load_lds_b128
// DIAG: waveamd-machine-schedule region func=enable_every_uniform_loop index=1
// DIAG-SAME: action=apply reason=loop_wait
// DIAG-SAME: steady_state_fills=1
// DIAG-SAME: steady_state_iterations=4
// DIAG: waveamd-machine-schedule region func=enable_every_uniform_loop index=3
// DIAG-SAME: action=apply reason=loop_wait
// DIAG-SAME: steady_state_fills=1
// DIAG-SAME: steady_state_iterations=4

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @model_under_tight_pressure(
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

// IR-LABEL: func.func @model_under_tight_pressure
// IR: ^bb0
// IR-NEXT: [[DESC:%.*]] = waveamdmachine.tuple_from_elements
// IR-NEXT: waveamdmachine.buffer_load_lds_b128 {{.*}}, [[DESC]]
// IR-NEXT: waveamdmachine.s_add_i32
// DIAG: waveamd-machine-schedule region func=model_under_tight_pressure index=1
// DIAG-SAME: action=keep reason=pressure
// DIAG-SAME: steady_state_fills=1
// DIAG-SAME: steady_state_iterations=4
// DIAG-SAME: steady_state_refinements=2

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @keep_steady_fill_after_split_barrier(
    %off: !waveamdmachine.reg<vgpr, 1>,
    %desc: !waveamdmachine.reg<sgpr, 4>,
    %soff: !waveamdmachine.reg<sgpr, 1>,
    %m0: !waveamdmachine.m0,
    %iv: !waveamdmachine.reg<sgpr, 1>,
    %step: !waveamdmachine.reg<sgpr, 1>,
    %cond: !waveamdmachine.reg<scc, 1>,
    %root: !waveamdmachine.mem.token) {
  %state = waveamdmachine.barrier_init : !waveamdmachine.barrier
  %loop:2 = waveamdmachine.uniform_loop if %cond
      : !waveamdmachine.reg<scc, 1>
      carries(%root, %iv : !waveamdmachine.mem.token,
              !waveamdmachine.reg<sgpr, 1>) {
  ^bb0(%tok: !waveamdmachine.mem.token,
       %iter: !waveamdmachine.reg<sgpr, 1>):
    %dma = waveamdmachine.buffer_load_lds_b128
        %off, %desc, %soff, %m0 after %tok
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
           !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.m0,
           !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    %ticket, %arrived = waveamdmachine.barrier_arrive %state after %dma
        : (!waveamdmachine.barrier, !waveamdmachine.mem.token)
          -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
    %ready = waveamdmachine.barrier_wait %state, %ticket after %arrived
        : (!waveamdmachine.barrier, !waveamdmachine.reg<vgpr, 1>,
           !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    %next, %scc = waveamdmachine.s_add_i32 %iter, %step
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
          -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    waveamdmachine.continue_if %scc : !waveamdmachine.reg<scc, 1>
        carries(%ready, %next : !waveamdmachine.mem.token,
                !waveamdmachine.reg<sgpr, 1>)
  } -> !waveamdmachine.mem.token, !waveamdmachine.reg<sgpr, 1>
  return
}
}

// IR-LABEL: func.func @keep_steady_fill_after_split_barrier
// IR: ^bb0
// IR-NEXT: waveamdmachine.buffer_load_lds_b128
// IR-NEXT: waveamdmachine.s_add_i32
// IR-NEXT: [[TICKET:%.*]], [[ARRIVED:%.*]] = waveamdmachine.barrier_arrive
// IR-NEXT: waveamdmachine.barrier_wait {{.*}}[[TICKET]] after [[ARRIVED]]
// DIAG: waveamd-machine-schedule region func=keep_steady_fill_after_split_barrier index=1
// DIAG-SAME: steady_state_fills=0
// DIAG-SAME: steady_state_iterations=4

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @skip_sliced_uniform_loop(
    %x: !waveamdmachine.reg<sgpr, 1>,
    %y: !waveamdmachine.reg<sgpr, 1>,
    %mask: !waveamdmachine.reg<sgpr, 1>,
    %cond: !waveamdmachine.reg<scc, 1>) {
  %loop = waveamdmachine.uniform_loop if %cond
      : !waveamdmachine.reg<scc, 1>
      carries(%x : !waveamdmachine.reg<sgpr, 1>) {
  ^bb0(%iter: !waveamdmachine.reg<sgpr, 1>):
    %pre, %pre_scc = waveamdmachine.s_add_i32 %iter, %y
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
          -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    waveamdmachine.exec_if %mask {
      %inside, %inside_scc = waveamdmachine.s_add_i32 %pre, %y
          : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
            -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
      waveamdmachine.yield
    } : !waveamdmachine.reg<sgpr, 1>
    %post, %post_scc = waveamdmachine.s_add_i32 %pre, %y
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
          -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    waveamdmachine.continue_if %post_scc : !waveamdmachine.reg<scc, 1>
        carries(%post : !waveamdmachine.reg<sgpr, 1>)
  } -> !waveamdmachine.reg<sgpr, 1>
  return
}
}

// IR-LABEL: func.func @skip_sliced_uniform_loop
// DIAG: waveamd-machine-schedule region func=skip_sliced_uniform_loop index=0
// DIAG-SAME: steady_state_iterations=0
// DIAG: waveamd-machine-schedule region func=skip_sliced_uniform_loop index=1
// DIAG-SAME: steady_state_iterations=0
// DIAG: waveamd-machine-schedule region func=skip_sliced_uniform_loop index=2
// DIAG-SAME: steady_state_iterations=0
// DIAG-NOT: waveamd-machine-schedule region func=skip_sliced_uniform_loop{{.*}}steady_state_iterations=4

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @prefetch_tail_loop_carried_lds(
    %addr0: !waveamdmachine.reg<vgpr, 1>,
    %addr1: !waveamdmachine.reg<vgpr, 1>,
    %seed: !waveamdmachine.reg<vgpr, 1>,
    %cond: !waveamdmachine.reg<scc, 1>,
    %root: !waveamdmachine.mem.token) {
  %init0, %init_t0 = waveamdmachine.ds_load_b32 %addr0 after %root
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %init1, %init_t1 = waveamdmachine.ds_load_b32 %addr1 after %root
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %init_token = waveamdmachine.token_join %init_t0, %init_t1
      : (!waveamdmachine.mem.token, !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  %loop:3 = waveamdmachine.uniform_loop if %cond
      : !waveamdmachine.reg<scc, 1>
      carries(%init0, %init1, %init_token :
              !waveamdmachine.reg<vgpr, 1>,
              !waveamdmachine.reg<vgpr, 1>,
              !waveamdmachine.mem.token) {
  ^bb0(%tile0: !waveamdmachine.reg<vgpr, 1>,
       %tile1: !waveamdmachine.reg<vgpr, 1>,
       %tok: !waveamdmachine.mem.token):
    %ready = waveamdmachine.s_barrier %tok
        : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    %used = waveamdmachine.v_add_u32 %tile0, %tile1
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    %work0 = waveamdmachine.v_add_u32 %used, %seed
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    %work1 = waveamdmachine.v_add_u32 %work0, %seed
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    %work2 = waveamdmachine.v_add_u32 %work1, %seed
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    %work3 = waveamdmachine.v_add_u32 %work2, %seed
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    %work4 = waveamdmachine.v_add_u32 %work3, %seed
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    %work5 = waveamdmachine.v_add_u32 %work4, %seed
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    %next0, %read0 = waveamdmachine.ds_load_b32 %addr0 after %ready
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
          -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
    %next1, %read1 = waveamdmachine.ds_load_b32 %addr1 after %ready
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
          -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
    %next_token = waveamdmachine.token_join %read0, %read1
        : (!waveamdmachine.mem.token, !waveamdmachine.mem.token)
          -> !waveamdmachine.mem.token
    waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
        carries(%next0, %next1, %next_token :
                !waveamdmachine.reg<vgpr, 1>,
                !waveamdmachine.reg<vgpr, 1>,
                !waveamdmachine.mem.token)
  } -> !waveamdmachine.reg<vgpr, 1>,
       !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token
  return
}
}

// IR-LABEL: func.func @prefetch_tail_loop_carried_lds
// IR: ^bb0
// IR-NEXT: [[READY:%.*]] = waveamdmachine.s_barrier
// IR-NEXT: waveamdmachine.v_add_u32
// IR-NEXT: [[NEXT0:%.*]], {{%.*}} = waveamdmachine.ds_load_b32 {{.*}} after [[READY]]
// IR-NEXT: waveamdmachine.v_add_u32
// IR-NEXT: waveamdmachine.v_add_u32
// IR-NEXT: waveamdmachine.v_add_u32
// IR-NEXT: [[NEXT1:%.*]], {{%.*}} = waveamdmachine.ds_load_b32 {{.*}} after [[READY]]
// IR-NEXT: waveamdmachine.token_join
// IR-NEXT: waveamdmachine.v_add_u32
// IR-NEXT: waveamdmachine.v_add_u32
// IR-NEXT: waveamdmachine.v_add_u32
// IR-NEXT: waveamdmachine.continue_if {{.*}} carries([[NEXT0]], [[NEXT1]],
// DIAG: waveamd-machine-schedule region func=prefetch_tail_loop_carried_lds index=1
// DIAG-SAME: loop_carried_lds_prefetch_moves={{[1-9][0-9]*}}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @preserve_interleaved_loop_carried_lds(
    %addr0: !waveamdmachine.reg<vgpr, 1>,
    %addr1: !waveamdmachine.reg<vgpr, 1>,
    %seed: !waveamdmachine.reg<vgpr, 1>,
    %cond: !waveamdmachine.reg<scc, 1>,
    %root: !waveamdmachine.mem.token) {
  %init0, %init_t0 = waveamdmachine.ds_load_b32 %addr0 after %root
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %init1, %init_t1 = waveamdmachine.ds_load_b32 %addr1 after %root
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %init_token = waveamdmachine.token_join %init_t0, %init_t1
      : (!waveamdmachine.mem.token, !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  %loop:3 = waveamdmachine.uniform_loop if %cond
      : !waveamdmachine.reg<scc, 1>
      carries(%init0, %init1, %init_token :
              !waveamdmachine.reg<vgpr, 1>,
              !waveamdmachine.reg<vgpr, 1>,
              !waveamdmachine.mem.token) {
  ^bb0(%tile0: !waveamdmachine.reg<vgpr, 1>,
       %tile1: !waveamdmachine.reg<vgpr, 1>,
       %tok: !waveamdmachine.mem.token):
    %used0 = waveamdmachine.v_add_u32 %tile0, %seed
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    %next0, %read0 = waveamdmachine.ds_load_b32 %addr0 after %tok
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
          -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
    %used1 = waveamdmachine.v_add_u32 %tile1, %used0
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    %next1, %read1 = waveamdmachine.ds_load_b32 %addr1 after %tok
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
          -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
    %next_token = waveamdmachine.token_join %read0, %read1
        : (!waveamdmachine.mem.token, !waveamdmachine.mem.token)
          -> !waveamdmachine.mem.token
    waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
        carries(%next0, %next1, %next_token :
                !waveamdmachine.reg<vgpr, 1>,
                !waveamdmachine.reg<vgpr, 1>,
                !waveamdmachine.mem.token)
  } -> !waveamdmachine.reg<vgpr, 1>,
       !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token
  return
}
}

// IR-LABEL: func.func @preserve_interleaved_loop_carried_lds
// IR: ^bb0
// IR-NEXT: waveamdmachine.v_add_u32
// IR-NEXT: waveamdmachine.ds_load_b32
// IR-NEXT: waveamdmachine.v_add_u32
// IR-NEXT: waveamdmachine.ds_load_b32
// DIAG: waveamd-machine-schedule region func=preserve_interleaved_loop_carried_lds index=1
// DIAG-SAME: loop_carried_lds_prefetch_moves=0

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @prefetch_after_each_recurrence_last_use(
    %addr0: !waveamdmachine.reg<vgpr, 1>,
    %addr1: !waveamdmachine.reg<vgpr, 1>,
    %seed: !waveamdmachine.reg<vgpr, 1>,
    %cond: !waveamdmachine.reg<scc, 1>,
    %root: !waveamdmachine.mem.token) {
  %init0, %init_t0 = waveamdmachine.ds_load_b32 %addr0 after %root
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %init1, %init_t1 = waveamdmachine.ds_load_b32 %addr1 after %root
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %init_token = waveamdmachine.token_join %init_t0, %init_t1
      : (!waveamdmachine.mem.token, !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  %loop:3 = waveamdmachine.uniform_loop if %cond
      : !waveamdmachine.reg<scc, 1>
      carries(%init0, %init1, %init_token :
              !waveamdmachine.reg<vgpr, 1>,
              !waveamdmachine.reg<vgpr, 1>,
              !waveamdmachine.mem.token) {
  ^bb0(%tile0: !waveamdmachine.reg<vgpr, 1>,
       %tile1: !waveamdmachine.reg<vgpr, 1>,
       %tok: !waveamdmachine.mem.token):
    %used0 = waveamdmachine.v_add_u32 %tile0, %seed
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    %work0 = waveamdmachine.v_add_u32 %used0, %seed
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    %used1 = waveamdmachine.v_add_u32 %tile1, %work0
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    %work1 = waveamdmachine.v_add_u32 %used1, %seed
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    %next0, %read0 = waveamdmachine.ds_load_b32 %addr0 after %tok
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
          -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
    %next1, %read1 = waveamdmachine.ds_load_b32 %addr1 after %tok
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
          -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
    %next_token = waveamdmachine.token_join %read0, %read1
        : (!waveamdmachine.mem.token, !waveamdmachine.mem.token)
          -> !waveamdmachine.mem.token
    waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
        carries(%next0, %next1, %next_token :
                !waveamdmachine.reg<vgpr, 1>,
                !waveamdmachine.reg<vgpr, 1>,
                !waveamdmachine.mem.token)
  } -> !waveamdmachine.reg<vgpr, 1>,
       !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token
  return
}
}

// IR-LABEL: func.func @prefetch_after_each_recurrence_last_use
// IR: ^bb0
// IR-NEXT: waveamdmachine.v_add_u32
// IR-NEXT: [[NEXT0:%.*]], {{%.*}} = waveamdmachine.ds_load_b32
// IR-NEXT: waveamdmachine.v_add_u32
// IR-NEXT: waveamdmachine.v_add_u32
// IR-NEXT: [[NEXT1:%.*]], {{%.*}} = waveamdmachine.ds_load_b32
// IR-NEXT: waveamdmachine.token_join
// IR-NEXT: waveamdmachine.v_add_u32
// IR-NEXT: waveamdmachine.continue_if {{.*}} carries([[NEXT0]], [[NEXT1]],
// DIAG: waveamd-machine-schedule region func=prefetch_after_each_recurrence_last_use index=1
// DIAG-SAME: loop_carried_lds_prefetch_moves={{[1-9][0-9]*}}
