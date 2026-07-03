// RUN: wave-opt %s --split-input-file --waveamd-machine-schedule='apply-schedule=1' | FileCheck %s --check-prefix=APPLY
// RUN: wave-opt %s --split-input-file --waveamd-machine-schedule='apply-schedule=1 barriered-lds-dma-hoist=1' | FileCheck %s --check-prefix=APPLY
// RUN: wave-opt %s --split-input-file --waveamd-machine-schedule='apply-schedule=1 barriered-lds-dma-hoist=0' | FileCheck %s --check-prefix=NOHOIST

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @barriered_lds_dma_hoist(
    %a: !waveamdmachine.reg<vgpr, 4>,
    %b: !waveamdmachine.reg<vgpr, 4>,
    %acc: !waveamdmachine.reg<vgpr, 4>,
    %off: !waveamdmachine.reg<vgpr, 1>,
    %base: !waveamdmachine.reg<sgpr, 2>,
    %dst: !waveamdmachine.reg<sgpr, 1>,
    %tok: !waveamdmachine.mem.token) {
  %c0 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %c1 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %c0
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %btok = waveamdmachine.s_barrier %tok
      : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %m0 = waveamdmachine.s_mov_m0 %dst
      : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.m0
  %ld = waveamdmachine.global_load_lds_b128 %off, %base, %m0 after %btok
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.m0, !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  return
}
}

// APPLY-LABEL: func.func @barriered_lds_dma_hoist
// APPLY-NOT: waveamdmachine.mfma
// APPLY: [[BTOK:%.*]] = waveamdmachine.s_barrier
// APPLY: [[C0:%.*]] = waveamdmachine.mfma_f32_16x16x32_f16
// APPLY: [[C1:%.*]] = waveamdmachine.mfma_f32_16x16x32_f16
// APPLY: [[M0:%.*]] = waveamdmachine.s_mov_m0
// APPLY: [[LD:%.*]] = waveamdmachine.global_load_lds_b128 {{.*}} [[M0]] after [[BTOK]]

// NOHOIST-LABEL: func.func @barriered_lds_dma_hoist
// NOHOIST: [[C0:%.*]] = waveamdmachine.mfma_f32_16x16x32_f16
// NOHOIST: [[C1:%.*]] = waveamdmachine.mfma_f32_16x16x32_f16
// NOHOIST: [[BTOK:%.*]] = waveamdmachine.s_barrier
// NOHOIST: [[M0:%.*]] = waveamdmachine.s_mov_m0
// NOHOIST: [[LD:%.*]] = waveamdmachine.global_load_lds_b128

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @wait_barrier_lds_dma_prefix_hoist(
    %idx: !waveamdmachine.reg<sgpr, 1>,
    %base_off: !waveamdmachine.reg<sgpr, 1>,
    %lane: !waveamdmachine.reg<vgpr, 1>,
    %rsrc: !waveamdmachine.reg<sgpr, 4>,
    %dst: !waveamdmachine.reg<sgpr, 1>,
    %tok: !waveamdmachine.mem.token) {
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  waveamdmachine.wait %tok : (!waveamdmachine.mem.token) -> ()
  %btok = waveamdmachine.s_barrier %tok
      : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %m0 = waveamdmachine.s_mov_m0 %dst
      : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.m0
  %shl, %scc0 = waveamdmachine.s_lshl_b32 %idx, %one
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
        -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  %sum, %scc1 = waveamdmachine.s_add_i32 %base_off, %shl
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  %vo = waveamdmachine.v_add_u32 %sum, %lane
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %ld = waveamdmachine.buffer_load_lds_b128 %vo, %rsrc, %zero, %m0 after %btok
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.imm, !waveamdmachine.m0, !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  return
}
}

// APPLY-LABEL: func.func @wait_barrier_lds_dma_prefix_hoist
// APPLY: [[M0:%.*]] = waveamdmachine.s_mov_m0
// APPLY-NEXT: [[SHL:%.*]], {{%.*}} = waveamdmachine.s_lshl_b32
// APPLY-NEXT: [[SUM:%.*]], {{%.*}} = waveamdmachine.s_add_i32
// APPLY-NEXT: [[VO:%.*]] = waveamdmachine.v_add_u32 [[SUM]]
// APPLY-NEXT: waveamdmachine.wait
// APPLY-NEXT: [[BTOK:%.*]] = waveamdmachine.s_barrier
// APPLY-NEXT: [[LD:%.*]] = waveamdmachine.buffer_load_lds_b128 [[VO]], {{.*}}, [[M0]] after [[BTOK]]

// NOHOIST-LABEL: func.func @wait_barrier_lds_dma_prefix_hoist
// NOHOIST: waveamdmachine.wait
// NOHOIST-NEXT: [[BTOK:%.*]] = waveamdmachine.s_barrier
// NOHOIST-NEXT: [[M0:%.*]] = waveamdmachine.s_mov_m0
// NOHOIST-NEXT: [[SHL:%.*]], {{%.*}} = waveamdmachine.s_lshl_b32

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @barriered_lds_dma_nonproducer_prefix(
    %a: !waveamdmachine.reg<vgpr, 4>,
    %b: !waveamdmachine.reg<vgpr, 4>,
    %acc: !waveamdmachine.reg<vgpr, 4>,
    %off: !waveamdmachine.reg<vgpr, 1>,
    %base: !waveamdmachine.reg<sgpr, 2>,
    %dst: !waveamdmachine.reg<sgpr, 1>,
    %tok: !waveamdmachine.mem.token) {
  %c0 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %btok = waveamdmachine.s_barrier %tok
      : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %dead = waveamdmachine.s_mov_m0 %dst
      : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.m0
  %m0 = waveamdmachine.s_mov_m0 %dst
      : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.m0
  %ld = waveamdmachine.global_load_lds_b128 %off, %base, %m0 after %btok
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.m0, !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  return
}
}

// APPLY-LABEL: func.func @barriered_lds_dma_nonproducer_prefix
// APPLY: [[BTOK:%.*]] = waveamdmachine.s_barrier
// APPLY: [[C0:%.*]] = waveamdmachine.mfma_f32_16x16x32_f16
// APPLY: [[DEAD:%.*]] = waveamdmachine.s_mov_m0
// APPLY: [[M0:%.*]] = waveamdmachine.s_mov_m0
// APPLY: [[LD:%.*]] = waveamdmachine.global_load_lds_b128 {{.*}} [[M0]] after [[BTOK]]

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @barriered_ds_read_mfma(
    %a: !waveamdmachine.reg<vgpr, 4>,
    %b: !waveamdmachine.reg<vgpr, 4>,
    %acc: !waveamdmachine.reg<vgpr, 4>,
    %addr: !waveamdmachine.reg<vgpr, 1>,
    %cond: !waveamdmachine.reg<scc, 1>,
    %tok: !waveamdmachine.mem.token) {
  waveamdmachine.uniform_loop if %cond : !waveamdmachine.reg<scc, 1> {
    %c0 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
        : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
           !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
    %btok = waveamdmachine.s_barrier %tok
        : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    %ld0, %t0 = waveamdmachine.ds_load_b64 %addr after %btok
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
          -> (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.mem.token)
    %ld1, %t1 = waveamdmachine.ds_load_b64 %addr after %t0
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
          -> (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.mem.token)
    %c1 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %c0
        : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
           !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
    waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
  }
  return
}
}

// APPLY-LABEL: func.func @barriered_ds_read_mfma
// APPLY: [[BTOK:%.*]] = waveamdmachine.s_barrier
// APPLY: [[LD0:%.*]], [[T0:%.*]] = waveamdmachine.ds_load_b64 {{.*}} after [[BTOK]]
// APPLY: [[LD1:%.*]], [[T1:%.*]] = waveamdmachine.ds_load_b64 {{.*}} after [[T0]]
// APPLY: [[C0:%.*]] = waveamdmachine.mfma_f32_16x16x32_f16
// APPLY: [[C1:%.*]] = waveamdmachine.mfma_f32_16x16x32_f16

// NOHOIST-LABEL: func.func @barriered_ds_read_mfma
// NOHOIST: [[C0:%.*]] = waveamdmachine.mfma_f32_16x16x32_f16
// NOHOIST: [[BTOK:%.*]] = waveamdmachine.s_barrier
// NOHOIST: [[LD0:%.*]], [[T0:%.*]] = waveamdmachine.ds_load_b64
// NOHOIST: [[LD1:%.*]], [[T1:%.*]] = waveamdmachine.ds_load_b64
// NOHOIST: [[C1:%.*]] = waveamdmachine.mfma_f32_16x16x32_f16

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @barriered_ds_tuple_mfma(
    %b: !waveamdmachine.reg<vgpr, 4>,
    %acc: !waveamdmachine.reg<vgpr, 4>,
    %addr: !waveamdmachine.reg<vgpr, 1>,
    %cond: !waveamdmachine.reg<scc, 1>,
    %tok: !waveamdmachine.mem.token) {
  waveamdmachine.uniform_loop if %cond : !waveamdmachine.reg<scc, 1> {
    %guard = waveamdmachine.v_add_u32 %addr, %addr
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    %btok = waveamdmachine.s_barrier %tok
        : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    %ld0, %t0 = waveamdmachine.ds_load_b64 %addr after %btok
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
          -> (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.mem.token)
    %ld1, %t1 = waveamdmachine.ds_load_b64 %addr after %t0 offset 64
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
          -> (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.mem.token)
    %ld2, %t2 = waveamdmachine.ds_load_b64 %addr after %t1 offset 128
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
          -> (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.mem.token)
    %ld3, %t3 = waveamdmachine.ds_load_b64 %addr after %t2 offset 192
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
          -> (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.mem.token)
    %ld4, %t4 = waveamdmachine.ds_load_b64 %addr after %t3 offset 256
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
          -> (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.mem.token)
    %ld5, %t5 = waveamdmachine.ds_load_b64 %addr after %t4 offset 320
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
          -> (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.mem.token)
    %lhs0 = waveamdmachine.tuple_from_elements %ld0, %ld1
        : (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>)
          -> !waveamdmachine.reg<vgpr, 4>
    %lhs1 = waveamdmachine.tuple_from_elements %ld2, %ld3
        : (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>)
          -> !waveamdmachine.reg<vgpr, 4>
    %lhs2 = waveamdmachine.tuple_from_elements %ld4, %ld5
        : (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>)
          -> !waveamdmachine.reg<vgpr, 4>
    %c1 = waveamdmachine.mfma_f32_16x16x32_f16 %lhs0, %b, %acc
        : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
           !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
    %c2 = waveamdmachine.mfma_f32_16x16x32_f16 %lhs1, %b, %c1
        : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
           !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
    %c3 = waveamdmachine.mfma_f32_16x16x32_f16 %lhs2, %b, %c2
        : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
           !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
    waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
  }
  return
}
}

// APPLY-LABEL: func.func @barriered_ds_tuple_mfma
// APPLY: [[BTOK:%.*]] = waveamdmachine.s_barrier
// APPLY: [[LD0:%.*]], [[T0:%.*]] = waveamdmachine.ds_load_b64 {{.*}} after [[BTOK]]
// APPLY: [[LD1:%.*]], [[T1:%.*]] = waveamdmachine.ds_load_b64 {{.*}} after [[T0]]
// APPLY: [[LD2:%.*]], [[T2:%.*]] = waveamdmachine.ds_load_b64 {{.*}} after [[T1]]
// APPLY: [[LD3:%.*]], [[T3:%.*]] = waveamdmachine.ds_load_b64 {{.*}} after [[T2]]
// APPLY: [[LD4:%.*]], [[T4:%.*]] = waveamdmachine.ds_load_b64 {{.*}} after [[T3]]
// APPLY-NOT: waveamdmachine.ds_load_b64
// APPLY: [[LHS0:%.*]] = waveamdmachine.tuple_from_elements [[LD0]], [[LD1]]
// APPLY: [[C1:%.*]] = waveamdmachine.mfma_f32_16x16x32_f16 [[LHS0]]
// APPLY: [[LD5:%.*]], {{%.*}} = waveamdmachine.ds_load_b64 {{.*}} after [[T4]]

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @wait_barrier_post_ds_tuple_mfma(
    %b: !waveamdmachine.reg<vgpr, 4>,
    %acc: !waveamdmachine.reg<vgpr, 4>,
    %addr: !waveamdmachine.reg<vgpr, 1>,
    %tok: !waveamdmachine.mem.token) {
  waveamdmachine.wait %tok : (!waveamdmachine.mem.token) -> ()
  %btok = waveamdmachine.s_barrier %tok
      : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %ld0, %t0 = waveamdmachine.ds_load_b64 %addr after %btok
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.mem.token)
  %ld1, %t1 = waveamdmachine.ds_load_b64 %addr after %t0 offset 64
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.mem.token)
  %ld2, %t2 = waveamdmachine.ds_load_b64 %addr after %t1 offset 128
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.mem.token)
  %ld3, %t3 = waveamdmachine.ds_load_b64 %addr after %t2 offset 192
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.mem.token)
  %ld4, %t4 = waveamdmachine.ds_load_b64 %addr after %t3 offset 256
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.mem.token)
  %ld5, %t5 = waveamdmachine.ds_load_b64 %addr after %t4 offset 320
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.mem.token)
  %lhs0 = waveamdmachine.tuple_from_elements %ld0, %ld1
      : (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>)
        -> !waveamdmachine.reg<vgpr, 4>
  %lhs1 = waveamdmachine.tuple_from_elements %ld2, %ld3
      : (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>)
        -> !waveamdmachine.reg<vgpr, 4>
  %lhs2 = waveamdmachine.tuple_from_elements %ld4, %ld5
      : (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>)
        -> !waveamdmachine.reg<vgpr, 4>
  %c1 = waveamdmachine.mfma_f32_16x16x32_f16 %lhs0, %b, %acc
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %c2 = waveamdmachine.mfma_f32_16x16x32_f16 %lhs1, %b, %c1
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  %c3 = waveamdmachine.mfma_f32_16x16x32_f16 %lhs2, %b, %c2
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
  return
}
}

// APPLY-LABEL: func.func @wait_barrier_post_ds_tuple_mfma
// APPLY: waveamdmachine.wait
// APPLY-NEXT: [[BTOK:%.*]] = waveamdmachine.s_barrier
// APPLY: [[LD0:%.*]], [[T0:%.*]] = waveamdmachine.ds_load_b64 {{.*}} after [[BTOK]]
// APPLY: [[LD1:%.*]], [[T1:%.*]] = waveamdmachine.ds_load_b64 {{.*}} after [[T0]]
// APPLY: [[LD2:%.*]], [[T2:%.*]] = waveamdmachine.ds_load_b64 {{.*}} after [[T1]]
// APPLY: [[LD3:%.*]], [[T3:%.*]] = waveamdmachine.ds_load_b64 {{.*}} after [[T2]]
// APPLY: [[LD4:%.*]], [[T4:%.*]] = waveamdmachine.ds_load_b64 {{.*}} after [[T3]]
// APPLY-NOT: waveamdmachine.ds_load_b64
// APPLY: [[LHS0:%.*]] = waveamdmachine.tuple_from_elements [[LD0]], [[LD1]]
// APPLY: [[C1:%.*]] = waveamdmachine.mfma_f32_16x16x32_f16 [[LHS0]]
// APPLY: [[LD5:%.*]], {{%.*}} = waveamdmachine.ds_load_b64 {{.*}} after [[T4]]

// NOHOIST-LABEL: func.func @wait_barrier_post_ds_tuple_mfma
// NOHOIST: waveamdmachine.wait
// NOHOIST-NEXT: [[BTOK:%.*]] = waveamdmachine.s_barrier
// NOHOIST: [[LD0:%.*]], [[T0:%.*]] = waveamdmachine.ds_load_b64 {{.*}} after [[BTOK]]
// NOHOIST: [[LD1:%.*]], [[T1:%.*]] = waveamdmachine.ds_load_b64 {{.*}} after [[T0]]
// NOHOIST: [[LD2:%.*]], [[T2:%.*]] = waveamdmachine.ds_load_b64 {{.*}} after [[T1]]
// NOHOIST: [[LD3:%.*]], [[T3:%.*]] = waveamdmachine.ds_load_b64 {{.*}} after [[T2]]
// NOHOIST: [[LD4:%.*]], [[T4:%.*]] = waveamdmachine.ds_load_b64 {{.*}} after [[T3]]
// NOHOIST: [[LD5:%.*]], {{%.*}} = waveamdmachine.ds_load_b64 {{.*}} after [[T4]]
// NOHOIST: [[LHS0:%.*]] = waveamdmachine.tuple_from_elements [[LD0]], [[LD1]]
// NOHOIST: [[C1:%.*]] = waveamdmachine.mfma_f32_16x16x32_f16 [[LHS0]]

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @barriered_ds_read_prefetch_second_barrier(
    %a: !waveamdmachine.reg<vgpr, 4>,
    %b: !waveamdmachine.reg<vgpr, 4>,
    %acc: !waveamdmachine.reg<vgpr, 4>,
    %addr0: !waveamdmachine.reg<vgpr, 1>,
    %addr1: !waveamdmachine.reg<vgpr, 1>,
    %scale: !waveamdmachine.reg<vgpr, 1>,
    %tok0: !waveamdmachine.mem.token,
    %tok1: !waveamdmachine.mem.token) {
  %first = waveamdmachine.s_barrier %tok0
      : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %store = waveamdmachine.ds_store_b32 %addr1, %scale after %tok1 offset 5952
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %second = waveamdmachine.s_barrier %store
      : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %ld0, %t0 = waveamdmachine.ds_read_tr_b64_b8 %addr0 after %first offset 3904
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.mem.token)
  %ld1, %t1 = waveamdmachine.ds_read_tr_b64_b8 %addr0 after %first offset 4032
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.mem.token)
  %join = waveamdmachine.token_join %t0, %t1
      : (!waveamdmachine.mem.token, !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  %ld2, %t2 = waveamdmachine.ds_read_tr_b64_b8 %addr1 after %second offset 5952
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.mem.token)
  %s0:2 = waveamdmachine.tuple_to_elements %ld0
      : (!waveamdmachine.reg<vgpr, 2>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
  %s2:2 = waveamdmachine.tuple_to_elements %ld2
      : (!waveamdmachine.reg<vgpr, 2>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
  %c0 = waveamdmachine.mfma_scale_f32_16x16x128_f4_f4
      %a, %b, %acc, %s2#0, %s0#0
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 4>
  %c1 = waveamdmachine.mfma_scale_f32_16x16x128_f4_f4
      %a, %b, %c0, %s2#0, %s0#0
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
         !waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 4>
  return
}
}

// APPLY-LABEL: func.func @barriered_ds_read_prefetch_second_barrier
// APPLY: [[FIRST:%.*]] = waveamdmachine.s_barrier
// APPLY-NEXT: [[STORE:%.*]] = waveamdmachine.ds_store_b32
// APPLY-NEXT: [[LD0:%.*]], [[T0:%.*]] = waveamdmachine.ds_read_tr_b64_b8 {{.*}} after [[FIRST]] offset 3904
// APPLY-NEXT: [[LD1:%.*]], [[T1:%.*]] = waveamdmachine.ds_read_tr_b64_b8 {{.*}} after [[FIRST]] offset 4032
// APPLY-NEXT: [[SECOND:%.*]] = waveamdmachine.s_barrier [[STORE]]
// APPLY: [[LD2:%.*]], [[T2:%.*]] = waveamdmachine.ds_read_tr_b64_b8 {{.*}} after [[SECOND]] offset 5952

// NOHOIST-LABEL: func.func @barriered_ds_read_prefetch_second_barrier
// NOHOIST: [[FIRST:%.*]] = waveamdmachine.s_barrier
// NOHOIST-NEXT: [[STORE:%.*]] = waveamdmachine.ds_store_b32
// NOHOIST-NEXT: [[SECOND:%.*]] = waveamdmachine.s_barrier [[STORE]]
// NOHOIST-NEXT: [[LD0:%.*]], [[T0:%.*]] = waveamdmachine.ds_read_tr_b64_b8 {{.*}} after [[FIRST]] offset 3904
// NOHOIST-NEXT: [[LD1:%.*]], [[T1:%.*]] = waveamdmachine.ds_read_tr_b64_b8 {{.*}} after [[FIRST]] offset 4032
// NOHOIST: [[LD2:%.*]], [[T2:%.*]] = waveamdmachine.ds_read_tr_b64_b8 {{.*}} after [[SECOND]] offset 5952

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @barriered_loop_carried_memory_consumer(
    %lhs_init: !waveamdmachine.reg<vgpr, 4>,
    %rhs_init: !waveamdmachine.reg<vgpr, 4>,
    %acc: !waveamdmachine.reg<vgpr, 4>,
    %addr: !waveamdmachine.reg<vgpr, 1>,
    %cond: !waveamdmachine.reg<scc, 1>,
    %tok: !waveamdmachine.mem.token) {
  %r:2 = waveamdmachine.uniform_loop if %cond : !waveamdmachine.reg<scc, 1>
      carries(%lhs_init, %rhs_init
              : !waveamdmachine.reg<vgpr, 4>,
                !waveamdmachine.reg<vgpr, 4>) {
  ^bb0(%lhs: !waveamdmachine.reg<vgpr, 4>,
       %rhs: !waveamdmachine.reg<vgpr, 4>):
    %c0 = waveamdmachine.mfma_f32_16x16x32_f16 %lhs, %rhs, %acc
        : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
           !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
    %btok = waveamdmachine.s_barrier %tok
        : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    %next_lhs, %t0 = waveamdmachine.ds_load_b128 %addr after %btok
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
          -> (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.mem.token)
    %next_rhs, %t1 = waveamdmachine.ds_load_b128 %addr after %t0 offset 1024
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
          -> (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.mem.token)
    waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
        carries(%next_lhs, %next_rhs
                : !waveamdmachine.reg<vgpr, 4>,
                  !waveamdmachine.reg<vgpr, 4>)
  } -> !waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>
  return
}
}

// APPLY-LABEL: func.func @barriered_loop_carried_memory_consumer
// APPLY: [[BTOK:%.*]] = waveamdmachine.s_barrier
// APPLY: [[LD0:%.*]], [[T0:%.*]] = waveamdmachine.ds_load_b128 {{.*}} after [[BTOK]]
// APPLY: [[LD1:%.*]], [[T1:%.*]] = waveamdmachine.ds_load_b128 {{.*}} after [[T0]]
// APPLY: [[C0:%.*]] = waveamdmachine.mfma_f32_16x16x32_f16

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @barriered_loop_carried_token_drain_cost(
    %lhs_init: !waveamdmachine.reg<vgpr, 4>,
    %rhs_init: !waveamdmachine.reg<vgpr, 4>,
    %acc: !waveamdmachine.reg<vgpr, 4>,
    %addr: !waveamdmachine.reg<vgpr, 1>,
    %cond: !waveamdmachine.reg<scc, 1>,
    %tok: !waveamdmachine.mem.token,
    %lds_tok_init: !waveamdmachine.mem.token) {
  %r:3 = waveamdmachine.uniform_loop if %cond : !waveamdmachine.reg<scc, 1>
      carries(%lhs_init, %rhs_init, %lds_tok_init
              : !waveamdmachine.reg<vgpr, 4>,
                !waveamdmachine.reg<vgpr, 4>,
                !waveamdmachine.mem.token) {
  ^bb0(%lhs: !waveamdmachine.reg<vgpr, 4>,
       %rhs: !waveamdmachine.reg<vgpr, 4>,
       %lds_tok: !waveamdmachine.mem.token):
    %c0 = waveamdmachine.mfma_f32_16x16x32_f16 %lhs, %rhs, %acc
        : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
           !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
    %btok = waveamdmachine.s_barrier %tok, %lds_tok
        : (!waveamdmachine.mem.token, !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
    %next_lhs, %t0 = waveamdmachine.ds_load_b128 %addr after %btok
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
          -> (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.mem.token)
    %next_rhs, %t1 = waveamdmachine.ds_load_b128 %addr after %t0 offset 1024
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
          -> (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.mem.token)
    waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
        carries(%next_lhs, %next_rhs, %t1
                : !waveamdmachine.reg<vgpr, 4>,
                  !waveamdmachine.reg<vgpr, 4>,
                  !waveamdmachine.mem.token)
  } -> !waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
       !waveamdmachine.mem.token
  return
}
}

// APPLY-LABEL: func.func @barriered_loop_carried_token_drain_cost
// APPLY: [[C0:%.*]] = waveamdmachine.mfma_f32_16x16x32_f16
// APPLY: [[BTOK:%.*]] = waveamdmachine.s_barrier
// APPLY: [[LD0:%.*]], [[T0:%.*]] = waveamdmachine.ds_load_b128 {{.*}} after [[BTOK]]
// APPLY: [[LD1:%.*]], [[T1:%.*]] = waveamdmachine.ds_load_b128 {{.*}} after [[T0]]
