// RUN: wave-opt --split-input-file %s --waveamd-hazard-repair | FileCheck %s
// RUN: wave-opt --split-input-file %s --waveamd-hazard-repair='hoist-m0-across-regions=0' | FileCheck %s --check-prefix=NO-CROSS
// RUN: wave-opt --split-input-file %s --waveamd-hazard-repair --mlir-timing --mlir-timing-display=tree 2>&1 >/dev/null | FileCheck %s --check-prefix=TIMING

// TIMING: wave_hazard_repair_stages
// TIMING: hazard_repair_setup
// TIMING: hazard_repair_hoist_m0
// TIMING: hazard_repair_collect_op_info
// TIMING: hazard_repair_blocks

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  // CHECK-LABEL: func.func @m0_gap_filled_by_later_valu
  // CHECK: waveamdmachine.s_mov_m0
  // CHECK-NEXT: waveamdmachine.v_add_u32
  // CHECK-NEXT: waveamdmachine.buffer_load_lds_b128
  func.func @m0_gap_filled_by_later_valu(
      %off: !waveamdmachine.reg<vgpr, 1, 0>,
      %desc: !waveamdmachine.reg<sgpr, 4, 4>,
      %soff: !waveamdmachine.reg<sgpr, 1, 8>,
      %dst: !waveamdmachine.reg<sgpr, 1, 9>,
      %x: !waveamdmachine.reg<vgpr, 1, 10>,
      %y: !waveamdmachine.reg<vgpr, 1, 11>,
      %dep: !waveamdmachine.mem.token) {
    %m0 = waveamdmachine.s_mov_m0 %dst
        : (!waveamdmachine.reg<sgpr, 1, 9>) -> !waveamdmachine.m0
    %tok = waveamdmachine.buffer_load_lds_b128 %off, %desc, %soff, %m0 after %dep
        : (!waveamdmachine.reg<vgpr, 1, 0>,
           !waveamdmachine.reg<sgpr, 4, 4>,
           !waveamdmachine.reg<sgpr, 1, 8>, !waveamdmachine.m0,
           !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    %fill = waveamdmachine.v_add_u32 %x, %y
        : (!waveamdmachine.reg<vgpr, 1, 10>,
           !waveamdmachine.reg<vgpr, 1, 11>) -> !waveamdmachine.reg<vgpr, 1, 12>
    return
  }

  // CHECK-LABEL: func.func @dead_scc_salu_fills_gap
  // CHECK: waveamdmachine.s_mov_m0
  // CHECK-NEXT: waveamdmachine.s_add_i32
  // CHECK-NEXT: waveamdmachine.buffer_load_lds_b128
  func.func @dead_scc_salu_fills_gap(
      %off: !waveamdmachine.reg<vgpr, 1, 0>,
      %desc: !waveamdmachine.reg<sgpr, 4, 4>,
      %soff: !waveamdmachine.reg<sgpr, 1, 8>,
      %dst: !waveamdmachine.reg<sgpr, 1, 9>,
      %x: !waveamdmachine.reg<sgpr, 1, 10>,
      %dep: !waveamdmachine.mem.token) {
    %inc = waveamdmachine.imm 256 : !waveamdmachine.imm
    %m0 = waveamdmachine.s_mov_m0 %dst
        : (!waveamdmachine.reg<sgpr, 1, 9>) -> !waveamdmachine.m0
    %tok = waveamdmachine.buffer_load_lds_b128 %off, %desc, %soff, %m0 after %dep
        : (!waveamdmachine.reg<vgpr, 1, 0>,
           !waveamdmachine.reg<sgpr, 4, 4>,
           !waveamdmachine.reg<sgpr, 1, 8>, !waveamdmachine.m0,
           !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    %fill, %scc = waveamdmachine.s_add_i32 %x, %inc
        : (!waveamdmachine.reg<sgpr, 1, 10>, !waveamdmachine.imm)
        -> (!waveamdmachine.reg<sgpr, 1, 11>, !waveamdmachine.reg<scc, 1>)
    return
  }

  // CHECK-LABEL: func.func @singleton_candidate_not_moved
  // CHECK: waveamdmachine.s_mov_m0
  // CHECK-NEXT: waveamdmachine.buffer_load_lds_b128
  // CHECK-NEXT: waveamdmachine.v_add_u32_vcc
  // CHECK-NEXT: waveamdmachine.s_read_vcc_b32
  func.func @singleton_candidate_not_moved(
      %off: !waveamdmachine.reg<vgpr, 1, 0>,
      %desc: !waveamdmachine.reg<sgpr, 4, 4>,
      %soff: !waveamdmachine.reg<sgpr, 1, 8>,
      %dst: !waveamdmachine.reg<sgpr, 1, 9>,
      %x: !waveamdmachine.reg<vgpr, 1, 10>,
      %y: !waveamdmachine.reg<vgpr, 1, 11>,
      %dep: !waveamdmachine.mem.token) {
    %m0 = waveamdmachine.s_mov_m0 %dst
        : (!waveamdmachine.reg<sgpr, 1, 9>) -> !waveamdmachine.m0
    %tok = waveamdmachine.buffer_load_lds_b128 %off, %desc, %soff, %m0 after %dep
        : (!waveamdmachine.reg<vgpr, 1, 0>,
           !waveamdmachine.reg<sgpr, 4, 4>,
           !waveamdmachine.reg<sgpr, 1, 8>, !waveamdmachine.m0,
           !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    %fill, %vcc = waveamdmachine.v_add_u32_vcc %x, %y
        : (!waveamdmachine.reg<vgpr, 1, 10>,
           !waveamdmachine.reg<vgpr, 1, 11>)
        -> (!waveamdmachine.reg<vgpr, 1, 12>, !waveamdmachine.reg<vcc, 1>)
    %saved = waveamdmachine.s_read_vcc_b32 %vcc
        : (!waveamdmachine.reg<vcc, 1>) -> !waveamdmachine.reg<sgpr, 1, 13>
    return
  }

  // CHECK-LABEL: func.func @source_hazard_rejects_move
  // CHECK: waveamdmachine.s_mov_m0
  // CHECK-NEXT: waveamdmachine.buffer_load_lds_b128
  // CHECK: waveamdmachine.s_mov_m0
  // CHECK-NEXT: waveamdmachine.v_add_u32
  // CHECK-NEXT: waveamdmachine.buffer_load_lds_b128
  func.func @source_hazard_rejects_move(
      %off0: !waveamdmachine.reg<vgpr, 1, 0>,
      %off1: !waveamdmachine.reg<vgpr, 1, 1>,
      %desc: !waveamdmachine.reg<sgpr, 4, 4>,
      %soff: !waveamdmachine.reg<sgpr, 1, 8>,
      %dst0: !waveamdmachine.reg<sgpr, 1, 9>,
      %dst1: !waveamdmachine.reg<sgpr, 1, 10>,
      %x: !waveamdmachine.reg<vgpr, 1, 11>,
      %y: !waveamdmachine.reg<vgpr, 1, 12>,
      %dep: !waveamdmachine.mem.token) {
    %m0a = waveamdmachine.s_mov_m0 %dst0
        : (!waveamdmachine.reg<sgpr, 1, 9>) -> !waveamdmachine.m0
    %tok0 = waveamdmachine.buffer_load_lds_b128 %off0, %desc, %soff, %m0a after %dep
        : (!waveamdmachine.reg<vgpr, 1, 0>,
           !waveamdmachine.reg<sgpr, 4, 4>,
           !waveamdmachine.reg<sgpr, 1, 8>, !waveamdmachine.m0,
           !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    %m0b = waveamdmachine.s_mov_m0 %dst1
        : (!waveamdmachine.reg<sgpr, 1, 10>) -> !waveamdmachine.m0
    %fill = waveamdmachine.v_add_u32 %x, %y
        : (!waveamdmachine.reg<vgpr, 1, 11>,
           !waveamdmachine.reg<vgpr, 1, 12>) -> !waveamdmachine.reg<vgpr, 1, 13>
    %tok1 = waveamdmachine.buffer_load_lds_b128 %off1, %desc, %soff, %m0b after %tok0
        : (!waveamdmachine.reg<vgpr, 1, 1>,
           !waveamdmachine.reg<sgpr, 4, 4>,
           !waveamdmachine.reg<sgpr, 1, 8>, !waveamdmachine.m0,
           !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    return
  }

  // CHECK-LABEL: func.func @m0_increment_stays_after_prior_consumer
  // CHECK: [[M0:%.*]] = waveamdmachine.s_mov_m0
  // CHECK-NEXT: waveamdmachine.s_barrier
  // CHECK-NEXT: [[TOK0:%.*]] = waveamdmachine.buffer_load_lds_b128 {{.*}}, [[M0]]
  // CHECK-NEXT: [[FILL:%.*]] = waveamdmachine.v_add_u32
  // CHECK-NEXT: [[NEXT:%.*]], {{%.*}} = waveamdmachine.s_add_m0_i32 [[M0]],
  // CHECK-NEXT: waveamdmachine.buffer_load_lds_b128 [[FILL]], {{.*}}, {{.*}}, [[NEXT]] after [[TOK0]]
  func.func @m0_increment_stays_after_prior_consumer(
      %off0: !waveamdmachine.reg<vgpr, 1, 0>,
      %x: !waveamdmachine.reg<vgpr, 1, 1>,
      %y: !waveamdmachine.reg<vgpr, 1, 2>,
      %desc: !waveamdmachine.reg<sgpr, 4, 4>,
      %soff: !waveamdmachine.reg<sgpr, 1, 8>,
      %dst: !waveamdmachine.reg<sgpr, 1, 9>,
      %dep: !waveamdmachine.mem.token) {
    %inc = waveamdmachine.imm 8192 : !waveamdmachine.imm
    %m0 = waveamdmachine.s_mov_m0 %dst
        : (!waveamdmachine.reg<sgpr, 1, 9>) -> !waveamdmachine.m0
    waveamdmachine.s_barrier : () -> ()
    %tok0 = waveamdmachine.buffer_load_lds_b128
        %off0, %desc, %soff, %m0 after %dep
        : (!waveamdmachine.reg<vgpr, 1, 0>,
           !waveamdmachine.reg<sgpr, 4, 4>,
           !waveamdmachine.reg<sgpr, 1, 8>, !waveamdmachine.m0,
           !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    %fill = waveamdmachine.v_add_u32 %x, %y
        : (!waveamdmachine.reg<vgpr, 1, 1>,
           !waveamdmachine.reg<vgpr, 1, 2>) -> !waveamdmachine.reg<vgpr, 1, 3>
    %next, %scc = waveamdmachine.s_add_m0_i32 %m0, %inc
        : (!waveamdmachine.m0, !waveamdmachine.imm)
          -> (!waveamdmachine.m0, !waveamdmachine.reg<scc, 1>)
    %tok1 = waveamdmachine.buffer_load_lds_b128
        %fill, %desc, %soff, %next after %tok0
        : (!waveamdmachine.reg<vgpr, 1, 3>,
           !waveamdmachine.reg<sgpr, 4, 4>,
           !waveamdmachine.reg<sgpr, 1, 8>, !waveamdmachine.m0,
           !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    return
  }

  // CHECK-LABEL: func.func @barrier_can_be_crossed
  // CHECK: waveamdmachine.s_mov_m0
  // CHECK-NEXT: waveamdmachine.v_add_u32
  // CHECK-NEXT: waveamdmachine.buffer_load_lds_b128
  // CHECK-NEXT: waveamdmachine.s_barrier
  func.func @barrier_can_be_crossed(
      %off: !waveamdmachine.reg<vgpr, 1, 0>,
      %desc: !waveamdmachine.reg<sgpr, 4, 4>,
      %soff: !waveamdmachine.reg<sgpr, 1, 8>,
      %dst: !waveamdmachine.reg<sgpr, 1, 9>,
      %x: !waveamdmachine.reg<vgpr, 1, 10>,
      %y: !waveamdmachine.reg<vgpr, 1, 11>,
      %dep: !waveamdmachine.mem.token) {
    %m0 = waveamdmachine.s_mov_m0 %dst
        : (!waveamdmachine.reg<sgpr, 1, 9>) -> !waveamdmachine.m0
    %tok = waveamdmachine.buffer_load_lds_b128 %off, %desc, %soff, %m0 after %dep
        : (!waveamdmachine.reg<vgpr, 1, 0>,
           !waveamdmachine.reg<sgpr, 4, 4>,
           !waveamdmachine.reg<sgpr, 1, 8>, !waveamdmachine.m0,
           !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    waveamdmachine.s_barrier %tok : (!waveamdmachine.mem.token) -> ()
    %fill = waveamdmachine.v_add_u32 %x, %y
        : (!waveamdmachine.reg<vgpr, 1, 10>,
           !waveamdmachine.reg<vgpr, 1, 11>) -> !waveamdmachine.reg<vgpr, 1, 12>
    return
  }

  // CHECK-LABEL: func.func @region_user_blocks_downward_move
  // CHECK: waveamdmachine.v_xor_b32
  // CHECK-NEXT: waveamdmachine.exec_if
  // CHECK: waveamdmachine.s_mov_m0
  // CHECK-NEXT: waveamdmachine.v_add_u32
  // CHECK-NEXT: waveamdmachine.buffer_load_lds_b128
  func.func @region_user_blocks_downward_move(
      %cond: !waveamdmachine.reg<sgpr, 1, 0>,
      %off: !waveamdmachine.reg<vgpr, 1, 1>,
      %desc: !waveamdmachine.reg<sgpr, 4, 4>,
      %soff: !waveamdmachine.reg<sgpr, 1, 8>,
      %dst: !waveamdmachine.reg<sgpr, 1, 9>,
      %x: !waveamdmachine.reg<vgpr, 1, 10>,
      %y: !waveamdmachine.reg<vgpr, 1, 11>,
      %z: !waveamdmachine.reg<vgpr, 1, 12>,
      %dep: !waveamdmachine.mem.token) {
    %region_fill = waveamdmachine.v_xor_b32 %x, %y
        : (!waveamdmachine.reg<vgpr, 1, 10>,
           !waveamdmachine.reg<vgpr, 1, 11>) -> !waveamdmachine.reg<vgpr, 1, 13>
    waveamdmachine.exec_if %cond {
      %use = waveamdmachine.v_add_u32 %region_fill, %z
          : (!waveamdmachine.reg<vgpr, 1, 13>,
             !waveamdmachine.reg<vgpr, 1, 12>) -> !waveamdmachine.reg<vgpr, 1, 14>
      waveamdmachine.yield
    } : !waveamdmachine.reg<sgpr, 1, 0>
    %m0 = waveamdmachine.s_mov_m0 %dst
        : (!waveamdmachine.reg<sgpr, 1, 9>) -> !waveamdmachine.m0
    %tok = waveamdmachine.buffer_load_lds_b128 %off, %desc, %soff, %m0 after %dep
        : (!waveamdmachine.reg<vgpr, 1, 1>,
           !waveamdmachine.reg<sgpr, 4, 4>,
           !waveamdmachine.reg<sgpr, 1, 8>, !waveamdmachine.m0,
           !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    %fill = waveamdmachine.v_add_u32 %x, %z
        : (!waveamdmachine.reg<vgpr, 1, 10>,
           !waveamdmachine.reg<vgpr, 1, 12>) -> !waveamdmachine.reg<vgpr, 1, 15>
    return
  }

  // CHECK-LABEL: func.func @outer_region_m0_hoisted
  // CHECK: [[ADDR:%.*]] = waveamdmachine.v_add_u32
  // CHECK-NEXT: waveamdmachine.v_xor_b32
  // CHECK-NEXT: [[M0:%.*]] = waveamdmachine.s_mov_m0
  // CHECK-NEXT: waveamdmachine.exec_if
  // CHECK-NEXT: waveamdmachine.buffer_load_lds_b128 [[ADDR]], {{.*}}, {{.*}}, [[M0]]
  func.func @outer_region_m0_hoisted(
      %cond: !waveamdmachine.reg<sgpr, 1, 0>,
      %off0: !waveamdmachine.reg<vgpr, 1, 1>,
      %off1: !waveamdmachine.reg<vgpr, 1, 2>,
      %desc: !waveamdmachine.reg<sgpr, 4, 4>,
      %soff: !waveamdmachine.reg<sgpr, 1, 8>,
      %dst: !waveamdmachine.reg<sgpr, 1, 9>,
      %dep: !waveamdmachine.mem.token) {
    %addr = waveamdmachine.v_add_u32 %off0, %off1
        : (!waveamdmachine.reg<vgpr, 1, 1>,
           !waveamdmachine.reg<vgpr, 1, 2>)
        -> !waveamdmachine.reg<vgpr, 1, 3>
    %dead = waveamdmachine.v_xor_b32 %off0, %off1
        : (!waveamdmachine.reg<vgpr, 1, 1>,
           !waveamdmachine.reg<vgpr, 1, 2>)
        -> !waveamdmachine.reg<vgpr, 1, 4>
    %tok = waveamdmachine.exec_if %cond {
      %m0 = waveamdmachine.s_mov_m0 %dst
          : (!waveamdmachine.reg<sgpr, 1, 9>) -> !waveamdmachine.m0
      %loaded = waveamdmachine.buffer_load_lds_b128
          %addr, %desc, %soff, %m0 after %dep
          : (!waveamdmachine.reg<vgpr, 1, 3>,
             !waveamdmachine.reg<sgpr, 4, 4>,
             !waveamdmachine.reg<sgpr, 1, 8>, !waveamdmachine.m0,
             !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
      waveamdmachine.yield %loaded : !waveamdmachine.mem.token
    } : !waveamdmachine.reg<sgpr, 1, 0> -> !waveamdmachine.mem.token
    return
  }

  // CHECK-LABEL: func.func @outer_uniform_if_m0_hoisted
  // CHECK: [[ADDR:%.*]] = waveamdmachine.v_add_u32
  // CHECK-NEXT: [[M0:%.*]] = waveamdmachine.s_mov_m0
  // CHECK-NEXT: waveamdmachine.uniform_if
  // CHECK-NEXT: waveamdmachine.buffer_load_lds_b128 [[ADDR]], {{.*}}, {{.*}}, [[M0]]
  func.func @outer_uniform_if_m0_hoisted(
      %cond: !waveamdmachine.reg<scc, 1>,
      %off0: !waveamdmachine.reg<vgpr, 1, 1>,
      %off1: !waveamdmachine.reg<vgpr, 1, 2>,
      %desc: !waveamdmachine.reg<sgpr, 4, 4>,
      %soff: !waveamdmachine.reg<sgpr, 1, 8>,
      %dst: !waveamdmachine.reg<sgpr, 1, 9>,
      %dep: !waveamdmachine.mem.token) {
    %addr = waveamdmachine.v_add_u32 %off0, %off1
        : (!waveamdmachine.reg<vgpr, 1, 1>,
           !waveamdmachine.reg<vgpr, 1, 2>)
        -> !waveamdmachine.reg<vgpr, 1, 3>
    %tok = waveamdmachine.uniform_if %cond {
      %m0 = waveamdmachine.s_mov_m0 %dst
          : (!waveamdmachine.reg<sgpr, 1, 9>) -> !waveamdmachine.m0
      %loaded = waveamdmachine.buffer_load_lds_b128
          %addr, %desc, %soff, %m0 after %dep
          : (!waveamdmachine.reg<vgpr, 1, 3>,
             !waveamdmachine.reg<sgpr, 4, 4>,
             !waveamdmachine.reg<sgpr, 1, 8>, !waveamdmachine.m0,
             !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
      waveamdmachine.yield %loaded : !waveamdmachine.mem.token
    } otherwise {
      waveamdmachine.yield %dep : !waveamdmachine.mem.token
    } : !waveamdmachine.reg<scc, 1> -> !waveamdmachine.mem.token
    return
  }

  // CHECK-LABEL: func.func @outer_loop_filler_not_pulled
  // CHECK: [[ADDR:%.*]] = waveamdmachine.v_add_u32
  // CHECK-NEXT: waveamdmachine.uniform_loop
  // CHECK: [[M0:%.*]] = waveamdmachine.s_mov_m0
  // CHECK-NEXT: waveamdmachine.buffer_load_lds_b128 [[ADDR]], {{.*}}, {{.*}}, [[M0]]
  func.func @outer_loop_filler_not_pulled(
      %cond: !waveamdmachine.reg<scc, 1>,
      %off0: !waveamdmachine.reg<vgpr, 1, 1>,
      %off1: !waveamdmachine.reg<vgpr, 1, 2>,
      %desc: !waveamdmachine.reg<sgpr, 4, 4>,
      %soff: !waveamdmachine.reg<sgpr, 1, 8>,
      %dst: !waveamdmachine.reg<sgpr, 1, 9>,
      %dep: !waveamdmachine.mem.token) {
    %addr = waveamdmachine.v_add_u32 %off0, %off1
        : (!waveamdmachine.reg<vgpr, 1, 1>,
           !waveamdmachine.reg<vgpr, 1, 2>)
        -> !waveamdmachine.reg<vgpr, 1, 3>
    %tok = waveamdmachine.uniform_loop if %cond
        : !waveamdmachine.reg<scc, 1>
        carries(%dep : !waveamdmachine.mem.token) {
    ^bb0(%iter: !waveamdmachine.mem.token):
      %m0 = waveamdmachine.s_mov_m0 %dst
          : (!waveamdmachine.reg<sgpr, 1, 9>) -> !waveamdmachine.m0
      %loaded = waveamdmachine.buffer_load_lds_b128
          %addr, %desc, %soff, %m0 after %iter
          : (!waveamdmachine.reg<vgpr, 1, 3>,
             !waveamdmachine.reg<sgpr, 4, 4>,
             !waveamdmachine.reg<sgpr, 1, 8>, !waveamdmachine.m0,
             !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
      waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
          carries(%loaded : !waveamdmachine.mem.token)
    } -> !waveamdmachine.mem.token
    return
  }

  // CHECK-LABEL: func.func @outer_result_user_blocks_pull
  // CHECK: [[ADDR:%.*]] = waveamdmachine.v_add_u32
  // CHECK-NEXT: [[M0:%.*]] = waveamdmachine.s_mov_m0
  // CHECK-NEXT: waveamdmachine.exec_if
  // CHECK-NEXT: waveamdmachine.buffer_load_lds_b128 [[ADDR]], {{.*}}, {{.*}}, [[M0]]
  func.func @outer_result_user_blocks_pull(
      %cond: !waveamdmachine.reg<sgpr, 1, 0>,
      %off0: !waveamdmachine.reg<vgpr, 1, 1>,
      %off1: !waveamdmachine.reg<vgpr, 1, 2>,
      %desc: !waveamdmachine.reg<sgpr, 4, 4>,
      %soff: !waveamdmachine.reg<sgpr, 1, 8>,
      %dst: !waveamdmachine.reg<sgpr, 1, 9>,
      %dep: !waveamdmachine.mem.token) {
    %addr = waveamdmachine.v_add_u32 %off0, %off1
        : (!waveamdmachine.reg<vgpr, 1, 1>,
           !waveamdmachine.reg<vgpr, 1, 2>)
        -> !waveamdmachine.reg<vgpr, 1, 3>
    %tok = waveamdmachine.exec_if %cond {
      %m0 = waveamdmachine.s_mov_m0 %dst
          : (!waveamdmachine.reg<sgpr, 1, 9>) -> !waveamdmachine.m0
      %loaded = waveamdmachine.buffer_load_lds_b128
          %addr, %desc, %soff, %m0 after %dep
          : (!waveamdmachine.reg<vgpr, 1, 3>,
             !waveamdmachine.reg<sgpr, 4, 4>,
             !waveamdmachine.reg<sgpr, 1, 8>, !waveamdmachine.m0,
             !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
      waveamdmachine.yield %loaded : !waveamdmachine.mem.token
    } : !waveamdmachine.reg<sgpr, 1, 0> -> !waveamdmachine.mem.token
    %use = waveamdmachine.v_xor_b32 %addr, %off0
        : (!waveamdmachine.reg<vgpr, 1, 3>,
           !waveamdmachine.reg<vgpr, 1, 1>)
        -> !waveamdmachine.reg<vgpr, 1, 10>
    return
  }

  // CHECK-LABEL: func.func @outer_source_hazard_blocks_pull
  // CHECK: [[M0A:%.*]] = waveamdmachine.s_mov_m0
  // CHECK-NEXT: [[ADDR:%.*]] = waveamdmachine.v_add_u32
  // CHECK-NEXT: [[TOK:%.*]] = waveamdmachine.buffer_load_lds_b128 {{.*}}, {{.*}}, {{.*}}, [[M0A]]
  // CHECK-NEXT: [[M0B:%.*]] = waveamdmachine.s_mov_m0
  // CHECK-NEXT: waveamdmachine.exec_if
  // CHECK-NEXT: waveamdmachine.buffer_load_lds_b128 [[ADDR]], {{.*}}, {{.*}}, [[M0B]] after [[TOK]]
  func.func @outer_source_hazard_blocks_pull(
      %cond: !waveamdmachine.reg<sgpr, 1, 0>,
      %off0: !waveamdmachine.reg<vgpr, 1, 1>,
      %off1: !waveamdmachine.reg<vgpr, 1, 2>,
      %desc: !waveamdmachine.reg<sgpr, 4, 4>,
      %soff: !waveamdmachine.reg<sgpr, 1, 8>,
      %dst0: !waveamdmachine.reg<sgpr, 1, 9>,
      %dst1: !waveamdmachine.reg<sgpr, 1, 10>,
      %dep: !waveamdmachine.mem.token) {
    %m0a = waveamdmachine.s_mov_m0 %dst0
        : (!waveamdmachine.reg<sgpr, 1, 9>) -> !waveamdmachine.m0
    %addr = waveamdmachine.v_add_u32 %off0, %off1
        : (!waveamdmachine.reg<vgpr, 1, 1>,
           !waveamdmachine.reg<vgpr, 1, 2>)
        -> !waveamdmachine.reg<vgpr, 1, 3>
    %tok0 = waveamdmachine.buffer_load_lds_b128
        %off0, %desc, %soff, %m0a after %dep
        : (!waveamdmachine.reg<vgpr, 1, 1>,
           !waveamdmachine.reg<sgpr, 4, 4>,
           !waveamdmachine.reg<sgpr, 1, 8>, !waveamdmachine.m0,
           !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    %tok1 = waveamdmachine.exec_if %cond {
      %m0b = waveamdmachine.s_mov_m0 %dst1
          : (!waveamdmachine.reg<sgpr, 1, 10>) -> !waveamdmachine.m0
      %loaded = waveamdmachine.buffer_load_lds_b128
          %addr, %desc, %soff, %m0b after %tok0
          : (!waveamdmachine.reg<vgpr, 1, 3>,
             !waveamdmachine.reg<sgpr, 4, 4>,
             !waveamdmachine.reg<sgpr, 1, 8>, !waveamdmachine.m0,
             !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
      waveamdmachine.yield %loaded : !waveamdmachine.mem.token
    } : !waveamdmachine.reg<sgpr, 1, 0> -> !waveamdmachine.mem.token
    return
  }

  // CHECK-LABEL: func.func @m0_add_hoisted_before_exec_if
  // CHECK: [[M0:%.*]], {{%.*}} = waveamdmachine.s_add_m0_i32
  // CHECK-NEXT: [[TOK:%.*]] = waveamdmachine.exec_if
  // CHECK-NEXT: waveamdmachine.buffer_load_lds_b128 {{.*}}, {{.*}}, {{.*}}, [[M0]]
  // NO-CROSS-LABEL: func.func @m0_add_hoisted_before_exec_if
  // NO-CROSS: waveamdmachine.exec_if
  // NO-CROSS-NEXT: waveamdmachine.s_add_m0_i32
  func.func @m0_add_hoisted_before_exec_if(
      %cond: !waveamdmachine.reg<sgpr, 1, 0>,
      %off: !waveamdmachine.reg<vgpr, 1, 1>,
      %desc: !waveamdmachine.reg<sgpr, 4, 4>,
      %soff: !waveamdmachine.reg<sgpr, 1, 8>,
      %dst: !waveamdmachine.reg<sgpr, 1, 9>,
      %dep: !waveamdmachine.mem.token) {
    %inc = waveamdmachine.imm 8448 : !waveamdmachine.imm
    %tok = waveamdmachine.exec_if %cond {
      %m0, %scc = waveamdmachine.s_add_m0_i32 %dst, %inc
          : (!waveamdmachine.reg<sgpr, 1, 9>, !waveamdmachine.imm)
          -> (!waveamdmachine.m0, !waveamdmachine.reg<scc, 1>)
      %loaded = waveamdmachine.buffer_load_lds_b128
          %off, %desc, %soff, %m0 after %dep
          : (!waveamdmachine.reg<vgpr, 1, 1>,
             !waveamdmachine.reg<sgpr, 4, 4>,
             !waveamdmachine.reg<sgpr, 1, 8>, !waveamdmachine.m0,
             !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
      waveamdmachine.yield %loaded : !waveamdmachine.mem.token
    } : !waveamdmachine.reg<sgpr, 1, 0> -> !waveamdmachine.mem.token
    return
  }

  // CHECK-LABEL: func.func @m0_increment_hoisted_after_prior_consumer
  // CHECK: [[M0:%.*]] = waveamdmachine.s_mov_m0
  // CHECK-NEXT: [[TOK0:%.*]] = waveamdmachine.buffer_load_lds_b128 {{.*}}, [[M0]]
  // CHECK-NEXT: [[NEXT:%.*]], {{%.*}} = waveamdmachine.s_add_m0_i32 [[M0]],
  // CHECK-NEXT: waveamdmachine.exec_if
  // CHECK-NEXT: waveamdmachine.buffer_load_lds_b128 {{.*}}, [[NEXT]] after [[TOK0]]
  // NO-CROSS-LABEL: func.func @m0_increment_hoisted_after_prior_consumer
  // NO-CROSS: [[NO_CROSS_M0:%.*]] = waveamdmachine.s_mov_m0
  // NO-CROSS-NEXT: [[NO_CROSS_TOK:%.*]] = waveamdmachine.buffer_load_lds_b128 {{.*}}, [[NO_CROSS_M0]]
  // NO-CROSS-NEXT: waveamdmachine.exec_if
  // NO-CROSS-NEXT: waveamdmachine.s_add_m0_i32 [[NO_CROSS_M0]],
  func.func @m0_increment_hoisted_after_prior_consumer(
      %cond: !waveamdmachine.reg<sgpr, 1, 0>,
      %off0: !waveamdmachine.reg<vgpr, 1, 1>,
      %off1: !waveamdmachine.reg<vgpr, 1, 2>,
      %desc: !waveamdmachine.reg<sgpr, 4, 4>,
      %soff: !waveamdmachine.reg<sgpr, 1, 8>,
      %dst: !waveamdmachine.reg<sgpr, 1, 9>,
      %dep: !waveamdmachine.mem.token) {
    %inc = waveamdmachine.imm 8192 : !waveamdmachine.imm
    %m0 = waveamdmachine.s_mov_m0 %dst
        : (!waveamdmachine.reg<sgpr, 1, 9>) -> !waveamdmachine.m0
    %tok0 = waveamdmachine.buffer_load_lds_b128
        %off0, %desc, %soff, %m0 after %dep
        : (!waveamdmachine.reg<vgpr, 1, 1>,
           !waveamdmachine.reg<sgpr, 4, 4>,
           !waveamdmachine.reg<sgpr, 1, 8>, !waveamdmachine.m0,
           !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    %tok1 = waveamdmachine.exec_if %cond {
      %next, %scc = waveamdmachine.s_add_m0_i32 %m0, %inc
          : (!waveamdmachine.m0, !waveamdmachine.imm)
            -> (!waveamdmachine.m0, !waveamdmachine.reg<scc, 1>)
      %loaded = waveamdmachine.buffer_load_lds_b128
          %off1, %desc, %soff, %next after %tok0
          : (!waveamdmachine.reg<vgpr, 1, 2>,
             !waveamdmachine.reg<sgpr, 4, 4>,
             !waveamdmachine.reg<sgpr, 1, 8>, !waveamdmachine.m0,
             !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
      waveamdmachine.yield %loaded : !waveamdmachine.mem.token
    } : !waveamdmachine.reg<sgpr, 1, 0> -> !waveamdmachine.mem.token
    return
  }

  // CHECK-LABEL: func.func @m0_mov_hoisted_before_uniform_if
  // CHECK: [[M0:%.*]] = waveamdmachine.s_mov_m0
  // CHECK-NEXT: [[TOK:%.*]] = waveamdmachine.uniform_if
  // CHECK-NEXT: waveamdmachine.buffer_load_lds_b128 {{.*}}, {{.*}}, {{.*}}, [[M0]]
  func.func @m0_mov_hoisted_before_uniform_if(
      %cond: !waveamdmachine.reg<scc, 1>,
      %off: !waveamdmachine.reg<vgpr, 1, 1>,
      %desc: !waveamdmachine.reg<sgpr, 4, 4>,
      %soff: !waveamdmachine.reg<sgpr, 1, 8>,
      %dst: !waveamdmachine.reg<sgpr, 1, 9>,
      %dep: !waveamdmachine.mem.token) {
    %tok = waveamdmachine.uniform_if %cond {
      %m0 = waveamdmachine.s_mov_m0 %dst
          : (!waveamdmachine.reg<sgpr, 1, 9>) -> !waveamdmachine.m0
      %loaded = waveamdmachine.buffer_load_lds_b128
          %off, %desc, %soff, %m0 after %dep
          : (!waveamdmachine.reg<vgpr, 1, 1>,
             !waveamdmachine.reg<sgpr, 4, 4>,
             !waveamdmachine.reg<sgpr, 1, 8>, !waveamdmachine.m0,
             !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
      waveamdmachine.yield %loaded : !waveamdmachine.mem.token
    } otherwise {
      waveamdmachine.yield %dep : !waveamdmachine.mem.token
    } : !waveamdmachine.reg<scc, 1> -> !waveamdmachine.mem.token
    return
  }

  // CHECK-LABEL: func.func @m0_not_hoisted_across_loop
  // CHECK: waveamdmachine.uniform_loop
  // CHECK: [[M0:%.*]] = waveamdmachine.s_mov_m0
  // CHECK-NEXT: waveamdmachine.global_load_lds_b128 {{.*}}, {{.*}}, [[M0]]
  func.func @m0_not_hoisted_across_loop(
      %cond: !waveamdmachine.reg<scc, 1>,
      %off: !waveamdmachine.reg<vgpr, 1, 1>,
      %base: !waveamdmachine.reg<sgpr, 2, 4>,
      %dst: !waveamdmachine.reg<sgpr, 1, 9>,
      %dep: !waveamdmachine.mem.token) {
    %tok = waveamdmachine.uniform_loop if %cond
        : !waveamdmachine.reg<scc, 1>
        carries(%dep : !waveamdmachine.mem.token) {
    ^bb0(%iter: !waveamdmachine.mem.token):
      %m0 = waveamdmachine.s_mov_m0 %dst
          : (!waveamdmachine.reg<sgpr, 1, 9>) -> !waveamdmachine.m0
      %loaded = waveamdmachine.global_load_lds_b128
          %off, %base, %m0 after %iter
          : (!waveamdmachine.reg<vgpr, 1, 1>,
             !waveamdmachine.reg<sgpr, 2, 4>, !waveamdmachine.m0,
             !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
      waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
          carries(%loaded : !waveamdmachine.mem.token)
    } -> !waveamdmachine.mem.token
    return
  }
}
