// RUN: wave-opt --split-input-file %s --waveamd-hazard-repair | FileCheck %s

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
}
