// RUN: wave-opt %s --waveamd-machine-schedule='apply-schedule=1' | FileCheck %s
// RUN: wave-opt %s --waveamd-machine-schedule='apply-schedule=1' 2>&1 >/dev/null | FileCheck %s --check-prefix=DIAG
// RUN: wave-opt %s --waveamd-machine-schedule-report='print-deps=1' 2>&1 | FileCheck %s --check-prefix=DEPS

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// CHECK-LABEL: func.func @post_barrier_fill
// CHECK: waveamdmachine.uniform_loop
// CHECK: [[PREFIX0:%.*]] = waveamdmachine.mfma_f32_16x16x32_f16 {{%.*}}, {{%.*}}, [[ACC:%.*]]
// CHECK: [[PREFIX1:%.*]] = waveamdmachine.mfma_f32_16x16x32_f16 {{%.*}}, {{%.*}}, [[PREFIX0]]
// CHECK-NEXT: waveamdmachine.buffer_load_lds_b128
// CHECK-NEXT: [[PREFIX2:%.*]] = waveamdmachine.mfma_f32_16x16x32_f16 {{%.*}}, {{%.*}}, [[PREFIX1]]
// CHECK-NEXT: waveamdmachine.s_add_m0_i32
// CHECK-NEXT: [[POST:%.*]] = waveamdmachine.mfma_f32_16x16x32_f16 {{%.*}}, {{%.*}}, [[ACC]]
// CHECK-NEXT: waveamdmachine.mfma_f32_16x16x32_f16 {{%.*}}, {{%.*}}, [[POST]]
// CHECK-NEXT: waveamdmachine.dma_issue_delay
// CHECK: waveamdmachine.s_barrier
// CHECK-NEXT: waveamdmachine.ds_load_b32
func.func @post_barrier_fill(
    %off: !waveamdmachine.reg<vgpr, 1>,
    %desc: !waveamdmachine.reg<sgpr, 4>,
    %soff: !waveamdmachine.reg<sgpr, 1>,
    %base: !waveamdmachine.reg<sgpr, 1>,
    %skip: !waveamdmachine.reg<vcc, 1>,
    %cond: !waveamdmachine.reg<scc, 1>,
    %addr: !waveamdmachine.reg<vgpr, 1>,
    %a: !waveamdmachine.reg<vgpr, 4>,
    %b: !waveamdmachine.reg<vgpr, 4>,
    %acc: !waveamdmachine.reg<vgpr, 4>,
    %root: !waveamdmachine.mem.token) {
  %inc = waveamdmachine.imm 8192 : !waveamdmachine.imm
  waveamdmachine.uniform_loop if %cond : !waveamdmachine.reg<scc, 1> {
    %m0 = waveamdmachine.s_mov_m0 %base
        : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.m0
    %t0 = waveamdmachine.buffer_load_lds_b128
        %off, %desc, %soff, %m0 after %root
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
           !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.m0,
           !waveamdmachine.mem.token)
          -> !waveamdmachine.mem.token
    %next_m0, %scc = waveamdmachine.s_add_m0_i32 %m0, %inc
        : (!waveamdmachine.m0, !waveamdmachine.imm)
          -> (!waveamdmachine.m0, !waveamdmachine.reg<scc, 1>)
    %delayed_m0 = waveamdmachine.dma_issue_delay %t0, %next_m0 unless %skip
        {cycles = 46 : i64, overlap_cycles = 33 : i64}
        : (!waveamdmachine.mem.token, !waveamdmachine.m0,
           !waveamdmachine.reg<vcc, 1>)
          -> !waveamdmachine.m0
    %t1 = waveamdmachine.buffer_load_lds_b128
        %off, %desc, %soff, %delayed_m0 after %root
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
           !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.m0,
           !waveamdmachine.mem.token)
          -> !waveamdmachine.mem.token
    %joined = waveamdmachine.token_join %t0, %t1
        : (!waveamdmachine.mem.token, !waveamdmachine.mem.token)
          -> !waveamdmachine.mem.token
    %prefix = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
        : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
           !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
    %prefix1 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %prefix
        : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
           !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
    %prefix2 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %prefix1
        : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
           !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
    %ready = waveamdmachine.s_barrier %joined
        : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    %loaded, %read = waveamdmachine.ds_load_b32 %addr after %ready
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
          -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
    %post = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
        : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
           !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
    %post1 = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %post
        : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
           !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
    waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
  }
  return
}

// CHECK-LABEL: func.func @queue_lead_after_delayed_dma
// CHECK: [[BASE_M0:%.*]] = waveamdmachine.s_mov_m0
// CHECK: [[DELAYED_M0:%.*]] = waveamdmachine.dma_issue_delay
// CHECK: waveamdmachine.buffer_load_lds_b128 {{.*}}, [[DELAYED_M0]]
// CHECK-NEXT: waveamdmachine.buffer_load_lds_b128 {{.*}}, [[BASE_M0]]
// CHECK-SAME: {waveamdmachine.dma_issue_after_delay}
// DIAG: waveamd-machine-schedule region func=queue_lead_after_delayed_dma index=1
// DIAG-SAME: resource_gaps=8
// DEPS: waveamd-machine-schedule-report deps func=queue_lead_after_delayed_dma region=1
// DEPS: edge region=1 kind=ssa {{[0-9]+}}->{{[0-9]+}} src=waveamdmachine.buffer_load_lds_b128 dst=waveamdmachine.dma_issue_delay
func.func @queue_lead_after_delayed_dma(
    %off: !waveamdmachine.reg<vgpr, 1>,
    %desc: !waveamdmachine.reg<sgpr, 4>,
    %soff: !waveamdmachine.reg<sgpr, 1>,
    %base: !waveamdmachine.reg<sgpr, 1>,
    %cond: !waveamdmachine.reg<scc, 1>,
  %root: !waveamdmachine.mem.token) {
  %inc = waveamdmachine.imm 8192 : !waveamdmachine.imm
  waveamdmachine.uniform_loop if %cond : !waveamdmachine.reg<scc, 1> {
    %m0 = waveamdmachine.s_mov_m0 %base
        : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.m0
    %t0 = waveamdmachine.buffer_load_lds_b128 %off, %desc, %soff, %m0 after %root
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
           !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.m0,
           !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    %m1, %s1 = waveamdmachine.s_add_m0_i32 %m0, %inc
        : (!waveamdmachine.m0, !waveamdmachine.imm)
          -> (!waveamdmachine.m0, !waveamdmachine.reg<scc, 1>)
    %t1 = waveamdmachine.buffer_load_lds_b128 %off, %desc, %soff, %m1 after %root
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
           !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.m0,
           !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    %m2, %s2 = waveamdmachine.s_add_m0_i32 %m1, %inc
        : (!waveamdmachine.m0, !waveamdmachine.imm)
          -> (!waveamdmachine.m0, !waveamdmachine.reg<scc, 1>)
    %t2 = waveamdmachine.buffer_load_lds_b128 %off, %desc, %soff, %m2 after %root
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
           !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.m0,
           !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    %m3, %s3 = waveamdmachine.s_add_m0_i32 %m2, %inc
        : (!waveamdmachine.m0, !waveamdmachine.imm)
          -> (!waveamdmachine.m0, !waveamdmachine.reg<scc, 1>)
    %t3 = waveamdmachine.buffer_load_lds_b128 %off, %desc, %soff, %m3 after %root
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
           !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.m0,
           !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    %m4, %s4 = waveamdmachine.s_add_m0_i32 %m3, %inc
        : (!waveamdmachine.m0, !waveamdmachine.imm)
          -> (!waveamdmachine.m0, !waveamdmachine.reg<scc, 1>)
    %t4 = waveamdmachine.buffer_load_lds_b128 %off, %desc, %soff, %m4 after %root
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
           !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.m0,
           !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    %m5, %s5 = waveamdmachine.s_add_m0_i32 %m4, %inc
        : (!waveamdmachine.m0, !waveamdmachine.imm)
          -> (!waveamdmachine.m0, !waveamdmachine.reg<scc, 1>)
    %t5 = waveamdmachine.buffer_load_lds_b128 %off, %desc, %soff, %m5 after %root
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
           !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.m0,
           !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    %m6, %s6 = waveamdmachine.s_add_m0_i32 %m5, %inc
        : (!waveamdmachine.m0, !waveamdmachine.imm)
          -> (!waveamdmachine.m0, !waveamdmachine.reg<scc, 1>)
    %t6 = waveamdmachine.buffer_load_lds_b128 %off, %desc, %soff, %m6 after %root
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
           !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.m0,
           !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    %m7, %s7 = waveamdmachine.s_add_m0_i32 %m6, %inc
        : (!waveamdmachine.m0, !waveamdmachine.imm)
          -> (!waveamdmachine.m0, !waveamdmachine.reg<scc, 1>)
    %delayed_m0 = waveamdmachine.dma_issue_delay %t6, %m7 {cycles = 1 : i64}
        : (!waveamdmachine.mem.token, !waveamdmachine.m0)
          -> !waveamdmachine.m0
    %t7 = waveamdmachine.buffer_load_lds_b128
        %off, %desc, %soff, %delayed_m0 after %root
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
           !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.m0,
           !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    %t8 = waveamdmachine.buffer_load_lds_b128
        %off, %desc, %soff, %m0 after %root
        {waveamdmachine.dma_issue_after_delay}
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
           !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.m0,
           !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
  }
  return
}

// DEPS: waveamd-machine-schedule-report deps func=loop_local_policy region=1
// DEPS-NOT: edge region=1 kind=singleton 0->1
// DEPS: edge region=1 kind=singleton 0->2 src=waveamdmachine.s_add_i32 dst=waveamdmachine.s_cmp_lt_i32
// DEPS: waveamd-machine-schedule-report deps func=loop_local_policy region=2
// DEPS-NOT: edge region=2 kind=singleton 0->1
// DEPS: edge region=2 kind=singleton 0->2 src=waveamdmachine.s_add_i32 dst=waveamdmachine.s_cmp_lt_i32
func.func @loop_local_policy(
    %iv0: !waveamdmachine.reg<sgpr, 1>,
    %dep: !waveamdmachine.mem.token,
    %m0: !waveamdmachine.m0) {
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %phased = waveamdmachine.uniform_loop carries(
      %iv0 : !waveamdmachine.reg<sgpr, 1>) {
  ^bb0(%iv: !waveamdmachine.reg<sgpr, 1>):
    %old:2 = waveamdmachine.s_add_i32 %iv, %one
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
          -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %next:2 = waveamdmachine.s_add_i32 %iv, %one
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
          -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %scc = waveamdmachine.s_cmp_lt_i32 %next#0, %one
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
          -> !waveamdmachine.reg<scc, 1>
    %delayed_m0 = waveamdmachine.dma_issue_delay %dep, %m0 {cycles = 1 : i64}
        : (!waveamdmachine.mem.token, !waveamdmachine.m0)
          -> !waveamdmachine.m0
    waveamdmachine.continue_if %scc : !waveamdmachine.reg<scc, 1>
        carries(%next#0 : !waveamdmachine.reg<sgpr, 1>)
  } -> !waveamdmachine.reg<sgpr, 1>
  %ordinary = waveamdmachine.uniform_loop carries(
      %iv0 : !waveamdmachine.reg<sgpr, 1>) {
  ^bb0(%iv: !waveamdmachine.reg<sgpr, 1>):
    %old:2 = waveamdmachine.s_add_i32 %iv, %one
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
          -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %next:2 = waveamdmachine.s_add_i32 %iv, %one
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
          -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %scc = waveamdmachine.s_cmp_lt_i32 %next#0, %one
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
          -> !waveamdmachine.reg<scc, 1>
    waveamdmachine.continue_if %scc : !waveamdmachine.reg<scc, 1>
        carries(%next#0 : !waveamdmachine.reg<sgpr, 1>)
  } -> !waveamdmachine.reg<sgpr, 1>
  return
}

}
