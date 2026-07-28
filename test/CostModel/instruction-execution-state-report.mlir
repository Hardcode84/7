// RUN: wave-instruction-state-report --func=smem_value_ready --smem-value-latency=7 %s | FileCheck %s --check-prefix=SMEMVALUE
// RUN: wave-instruction-state-report --func=smem_wait --smem-counter-latency=7 %s | FileCheck %s --check-prefix=SMEMWAIT
// RUN: wave-instruction-state-report --func=token_store_wait --vmem-counter-latency=7 %s | FileCheck %s --check-prefix=TOKENWAIT
// RUN: wave-instruction-state-report --func=store_then_load_carries_token --vmem-counter-latency=7 --vscnt-counter-latency=7 %s | FileCheck %s --check-prefix=TOKENCARRY
// RUN: wave-instruction-state-report --func=barrier_does_not_drain --vmem-counter-latency=7 %s | FileCheck %s --check-prefix=BARRIER
// RUN: wave-instruction-state-report --func=m0_gap %s | FileCheck %s --check-prefix=M0
// RUN: wave-instruction-state-report --func=m0_dma_capture_gap --arch=gfx950 %s | FileCheck %s --check-prefix=M0DMA
// RUN: wave-instruction-state-report --func=m0_tagged_dma_capture_gap --arch=gfx950 %s | FileCheck %s --check-prefix=M0DMATAGGED
// RUN: wave-instruction-state-report --func=m0_dma_capture_filled --arch=gfx950 %s | FileCheck %s --check-prefix=M0DMAFILL
// RUN: wave-instruction-state-report --func=m0_dma_capture_gap --arch=gfx942 %s | FileCheck %s --check-prefix=M0DMACDNA3
// RUN: wave-instruction-state-report --func=salu_pipe_cap --pipe-backpressure --salu-max-in-flight=1 %s | FileCheck %s --check-prefix=PIPE
// RUN: wave-instruction-state-report --func=lds_dma_issue_backpressure --arch=gfx950 %s | FileCheck %s --check-prefix=LDSDMA
// RUN: wave-instruction-state-report --func=trans_forwarding_gap --arch=gfx950 %s | FileCheck %s --check-prefix=TRANS
// RUN: wave-instruction-state-report --func=readfirstlane_gap --arch=gfx950 %s | FileCheck %s --check-prefix=READLANE
// RUN: wave-instruction-state-report --func=vcc_gap --arch=gfx950 %s | FileCheck %s --check-prefix=VCC
// RUN: wave-instruction-state-report --func=noinst_memory_alias_zero_cycle --arch=gfx950 --vmem-value-latency=20 %s | FileCheck %s --check-prefix=ALIAS
// RUN: wave-instruction-state-report --func=noinst_token_alias --arch=gfx950 --vmem-counter-latency=20 %s | FileCheck %s --check-prefix=TOKENALIAS
// RUN: wave-instruction-state-report --func=issue_token_drops_completion --arch=gfx950 --vmem-counter-latency=20 %s | FileCheck %s --check-prefix=ISSUETOKEN
// RUN: wave-instruction-state-report --func=noinst_issue_hazard_alias --arch=gfx950 %s | FileCheck %s --check-prefix=HAZARDALIAS
// RUN: wave-instruction-state-report --func=salu_pipe_cap --arch=gfx942 %s | FileCheck %s --check-prefix=CDNA3
// RUN: wave-instruction-state-report --func=salu_pipe_cap --arch=gfx950 %s | FileCheck %s --check-prefix=CDNA4
// RUN: wave-instruction-state-report --func=dma_issue_delay_chunks --arch=gfx950 %s | FileCheck %s --check-prefix=DMACHUNKS
// RUN: wave-instruction-state-report --func=dma_issue_delay_conditional --arch=gfx950 %s | FileCheck %s --check-prefix=DMADELAY
// RUN: wave-instruction-state-report --func=dma_issue_delay_conditional --arch=gfx950 --dma-issue-delay-cohort=skipped %s | FileCheck %s --check-prefix=DMASKIP
// RUN: wave-instruction-state-report --func=mfma_packed_coissue --arch=gfx950 %s | FileCheck %s --check-prefix=MFMA-PACKED
// RUN: wave-instruction-state-report --func=mfma_packed_coissue --arch=gfx942 %s | FileCheck %s --check-prefix=MFMA-PACKED-CDNA3
// RUN: wave-instruction-state-report --func=mfma_scalar_coissue --arch=gfx950 %s | FileCheck %s --check-prefix=MFMA-SCALAR
// RUN: wave-instruction-state-report --func=mfma_trans_coissue --arch=gfx950 %s | FileCheck %s --check-prefix=MFMA-TRANS

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
  func.func @smem_value_ready(%zero: !waveamdmachine.imm,
                              %step: !waveamdmachine.imm) {
    %load = waveamdmachine.s_load_b32 %zero, "s[0:1]" :
        (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
    %sum:2 = waveamdmachine.s_add_i32 %load, %step :
        (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) ->
        (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    return
  }

  func.func @smem_wait(%zero: !waveamdmachine.imm) {
    %load = waveamdmachine.s_load_b32 %zero, "s[0:1]" :
        (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
    waveamdmachine.s_waitcnt lgkmcnt(0)
    return
  }

  func.func @token_store_wait(%off: !waveamdmachine.reg<vgpr, 1>,
                              %base: !waveamdmachine.reg<sgpr, 2>,
                              %value: !waveamdmachine.reg<vgpr, 1>) {
    %tok0 = waveamdmachine.token : !waveamdmachine.mem.token
    %load, %tok1 = waveamdmachine.global_load_b32 %off, %base after %tok0
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>,
           !waveamdmachine.mem.token)
          -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
    %store = waveamdmachine.global_store_b32 %off, %value, %base after %tok1
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
           !waveamdmachine.reg<sgpr, 2>, !waveamdmachine.mem.token)
          -> !waveamdmachine.mem.token
    return
  }

  func.func @store_then_load_carries_token(%off: !waveamdmachine.reg<vgpr, 1>,
                                           %base: !waveamdmachine.reg<sgpr, 2>,
                                           %value: !waveamdmachine.reg<vgpr, 1>) {
    %tok0 = waveamdmachine.token : !waveamdmachine.mem.token
    %store = waveamdmachine.global_store_b32 %off, %value, %base after %tok0
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
           !waveamdmachine.reg<sgpr, 2>, !waveamdmachine.mem.token)
          -> !waveamdmachine.mem.token
    %load, %tok1 = waveamdmachine.global_load_b32 %off, %base after %store
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>,
           !waveamdmachine.mem.token)
          -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
    waveamdmachine.s_barrier %tok1 : (!waveamdmachine.mem.token) -> ()
    return
  }

  func.func @barrier_does_not_drain(%off: !waveamdmachine.reg<vgpr, 1>,
                                    %base: !waveamdmachine.reg<sgpr, 2>) {
    %tok0 = waveamdmachine.token : !waveamdmachine.mem.token
    %load, %tok1 = waveamdmachine.global_load_b32 %off, %base after %tok0
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>,
           !waveamdmachine.mem.token)
          -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
    waveamdmachine.s_barrier : () -> ()
    waveamdmachine.s_waitcnt vmcnt(0)
    return
  }

  func.func @m0_gap(%src: !waveamdmachine.reg<sgpr, 1>) {
    %m0 = waveamdmachine.s_mov_m0 %src
        : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.m0
    %load, %tok = waveamdmachine.ds_load_addtid_b32 %m0
        : (!waveamdmachine.m0)
          -> (!waveamdmachine.reg<agpr, 1>, !waveamdmachine.mem.token)
    return
  }

  func.func @m0_dma_capture_gap(
      %off: !waveamdmachine.reg<vgpr, 1>,
      %base: !waveamdmachine.reg<sgpr, 2>,
      %m0: !waveamdmachine.m0,
      %dst: !waveamdmachine.reg<sgpr, 1>) {
    %root = waveamdmachine.token : !waveamdmachine.mem.token
    %tok = waveamdmachine.global_load_lds_b128 %off, %base, %m0 after %root
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>,
           !waveamdmachine.m0, !waveamdmachine.mem.token)
          -> !waveamdmachine.mem.token
    %next = waveamdmachine.s_mov_m0 %dst
        : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.m0
    return
  }

  func.func @m0_tagged_dma_capture_gap(
      %off: !waveamdmachine.reg<vgpr, 1>,
      %base: !waveamdmachine.reg<sgpr, 2>,
      %m0: !waveamdmachine.m0,
      %dst: !waveamdmachine.reg<sgpr, 1>) {
    %root = waveamdmachine.token : !waveamdmachine.mem.token
    %tok = waveamdmachine.global_load_lds_b128 %off, %base, %m0 after %root
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>,
           !waveamdmachine.m0, !waveamdmachine.mem.token)
          -> !waveamdmachine.mem.token
    %next = waveamdmachine.s_mov_m0 %dst
        : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.m0
    return
  }

  func.func @m0_dma_capture_filled(
      %off: !waveamdmachine.reg<vgpr, 1>,
      %base: !waveamdmachine.reg<sgpr, 2>,
      %m0: !waveamdmachine.m0,
      %dst: !waveamdmachine.reg<sgpr, 1>,
      %a: !waveamdmachine.reg<vgpr, 4>,
      %b: !waveamdmachine.reg<vgpr, 4>,
      %acc: !waveamdmachine.reg<vgpr, 4>) {
    %root = waveamdmachine.token : !waveamdmachine.mem.token
    %tok = waveamdmachine.global_load_lds_b128 %off, %base, %m0 after %root
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>,
           !waveamdmachine.m0, !waveamdmachine.mem.token)
          -> !waveamdmachine.mem.token
    %result = waveamdmachine.mfma_f32_16x16x32_f16 %a, %b, %acc
        : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
           !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>
    %next = waveamdmachine.s_mov_m0 %dst
        : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.m0
    return
  }

  func.func @salu_pipe_cap(%a: !waveamdmachine.reg<sgpr, 1>,
                           %b: !waveamdmachine.reg<sgpr, 1>,
                           %c: !waveamdmachine.reg<sgpr, 1>) {
    %x:2 = waveamdmachine.s_add_i32 %a, %b :
        (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>) ->
        (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %y:2 = waveamdmachine.s_add_i32 %a, %c :
        (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>) ->
        (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    return
  }

  func.func @lds_dma_issue_backpressure(%off: !waveamdmachine.reg<vgpr, 1>,
                                        %base: !waveamdmachine.reg<sgpr, 2>,
                                        %m0: !waveamdmachine.m0) {
    %root = waveamdmachine.token : !waveamdmachine.mem.token
    %tok0 = waveamdmachine.global_load_lds_b128 %off, %base, %m0 after %root
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>,
           !waveamdmachine.m0, !waveamdmachine.mem.token)
          -> !waveamdmachine.mem.token
    %tok1 = waveamdmachine.global_load_lds_b128 %off, %base, %m0 after %root
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>,
           !waveamdmachine.m0, !waveamdmachine.mem.token)
          -> !waveamdmachine.mem.token
    %tok2 = waveamdmachine.global_load_lds_b128 %off, %base, %m0 after %root
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>,
           !waveamdmachine.m0, !waveamdmachine.mem.token)
          -> !waveamdmachine.mem.token
    %tok3 = waveamdmachine.global_load_lds_b128 %off, %base, %m0 after %root
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>,
           !waveamdmachine.m0, !waveamdmachine.mem.token)
          -> !waveamdmachine.mem.token
    %tok4 = waveamdmachine.global_load_lds_b128 %off, %base, %m0 after %root
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>,
           !waveamdmachine.m0, !waveamdmachine.mem.token)
          -> !waveamdmachine.mem.token
    %tok5 = waveamdmachine.global_load_lds_b128 %off, %base, %m0 after %root
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>,
           !waveamdmachine.m0, !waveamdmachine.mem.token)
          -> !waveamdmachine.mem.token
    %tok6 = waveamdmachine.global_load_lds_b128 %off, %base, %m0 after %root
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>,
           !waveamdmachine.m0, !waveamdmachine.mem.token)
          -> !waveamdmachine.mem.token
    %tok7 = waveamdmachine.global_load_lds_b128 %off, %base, %m0 after %root
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>,
           !waveamdmachine.m0, !waveamdmachine.mem.token)
          -> !waveamdmachine.mem.token
    return
  }

  func.func @trans_forwarding_gap(%a: !waveamdmachine.reg<vgpr, 1>,
                                  %b: !waveamdmachine.reg<vgpr, 1>) {
    %trans = waveamdmachine.v_rcp_f32 %a
        : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
    %use = waveamdmachine.v_mul_f32 %trans, %b
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    return
  }

  func.func @readfirstlane_gap(%a: !waveamdmachine.reg<vgpr, 1>,
                               %b: !waveamdmachine.reg<vgpr, 1>) {
    %sum = waveamdmachine.v_add_u32 %a, %b
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    %first = waveamdmachine.v_readfirstlane_b32 %sum
        : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
    return
  }

  func.func @vcc_gap(%a: !waveamdmachine.reg<vgpr, 1>,
                     %b: !waveamdmachine.reg<vgpr, 1>,
                     %c: !waveamdmachine.reg<vgpr, 1>) {
    %mask, %vcc = waveamdmachine.v_cmp_ge_u32_vcc %a, %b
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.reg<vcc, 1>)
    %sum = waveamdmachine.v_add_u32 %a, %c
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    %pick = waveamdmachine.v_cndmask_b32_vcc %a, %sum, %vcc
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
           !waveamdmachine.reg<vcc, 1>) -> !waveamdmachine.reg<vgpr, 1>
    return
  }

  func.func @noinst_memory_alias_zero_cycle(
      %off: !waveamdmachine.reg<vgpr, 1>,
      %base: !waveamdmachine.reg<sgpr, 2>,
      %a: !waveamdmachine.reg<vgpr, 1>,
      %b: !waveamdmachine.reg<vgpr, 1>) {
    %loaded, %token = waveamdmachine.global_load_b64 %off, %base
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>)
          -> (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.mem.token)
    %parts:2 = waveamdmachine.tuple_to_elements %loaded
        : (!waveamdmachine.reg<vgpr, 2>)
          -> (!waveamdmachine.reg<vgpr, 1>,
              !waveamdmachine.reg<vgpr, 1>)
    %independent = waveamdmachine.v_add_u32 %a, %b
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    %use = waveamdmachine.v_add_u32 %parts#0, %parts#1
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    return
  }

  func.func @noinst_token_alias(%off: !waveamdmachine.reg<vgpr, 1>,
                                %base: !waveamdmachine.reg<sgpr, 2>,
                                %value: !waveamdmachine.reg<vgpr, 1>) {
    %loaded, %loaded_token = waveamdmachine.global_load_b32 %off, %base
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>)
          -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
    %joined = waveamdmachine.token_join %loaded_token
        : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    %stored = waveamdmachine.global_store_b32 %off, %value, %base after %joined
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
           !waveamdmachine.reg<sgpr, 2>, !waveamdmachine.mem.token)
          -> !waveamdmachine.mem.token
    return
  }

  func.func @issue_token_drops_completion(
      %off: !waveamdmachine.reg<vgpr, 1>,
      %base: !waveamdmachine.reg<sgpr, 2>) {
    %loaded, %loaded_token = waveamdmachine.global_load_b32 %off, %base
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>)
          -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
    %issued = waveamdmachine.issue_token %loaded_token
        : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    waveamdmachine.s_barrier %issued : (!waveamdmachine.mem.token) -> ()
    return
  }

  func.func @noinst_issue_hazard_alias(
      %a: !waveamdmachine.reg<vgpr, 1>,
      %b: !waveamdmachine.reg<vgpr, 1>) {
    %sum = waveamdmachine.v_add_u32 %a, %b
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    %alias = waveamdmachine.tuple_from_elements %sum
        : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
    %first = waveamdmachine.v_readfirstlane_b32 %alias
        : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
    return
  }

  func.func @dma_issue_delay_chunks(%m0: !waveamdmachine.m0) {
    %dep = waveamdmachine.token : !waveamdmachine.mem.token
    %first = waveamdmachine.dma_issue_delay %dep, %m0
        {cycles = 16 : i64}
        : (!waveamdmachine.mem.token, !waveamdmachine.m0)
          -> !waveamdmachine.m0
    %second = waveamdmachine.dma_issue_delay %dep, %first
        {cycles = 17 : i64}
        : (!waveamdmachine.mem.token, !waveamdmachine.m0)
          -> !waveamdmachine.m0
    return
  }

  func.func @dma_issue_delay_conditional(
      %m0: !waveamdmachine.m0,
      %skip: !waveamdmachine.reg<vcc, 1>) {
    %dep = waveamdmachine.token : !waveamdmachine.mem.token
    %delayed = waveamdmachine.dma_issue_delay %dep, %m0 unless %skip
        {cycles = 17 : i64, overlap_cycles = 3 : i64}
        : (!waveamdmachine.mem.token, !waveamdmachine.m0,
           !waveamdmachine.reg<vcc, 1>) -> !waveamdmachine.m0
    return
  }

  func.func @mfma_packed_coissue(
      %a: !waveamdmachine.reg<vgpr, 4>,
      %b: !waveamdmachine.reg<vgpr, 4>,
      %acc: !waveamdmachine.reg<vgpr, 16>,
      %x: !waveamdmachine.reg<vgpr, 2>,
      %y: !waveamdmachine.reg<vgpr, 2>) {
    %mfma = waveamdmachine.mfma_f32_32x32x16_f16 %a, %b, %acc
        : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
           !waveamdmachine.reg<vgpr, 16>)
          -> !waveamdmachine.reg<vgpr, 16>
    %packed = waveamdmachine.v_pk_add_f32 %x, %y
        : (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>)
          -> !waveamdmachine.reg<vgpr, 2>
    return
  }

  func.func @mfma_scalar_coissue(
      %a: !waveamdmachine.reg<vgpr, 4>,
      %b: !waveamdmachine.reg<vgpr, 4>,
      %acc: !waveamdmachine.reg<vgpr, 16>,
      %x: !waveamdmachine.reg<vgpr, 1>,
      %y: !waveamdmachine.reg<vgpr, 1>) {
    %mfma = waveamdmachine.mfma_f32_32x32x16_f16 %a, %b, %acc
        : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
           !waveamdmachine.reg<vgpr, 16>)
          -> !waveamdmachine.reg<vgpr, 16>
    %scalar = waveamdmachine.v_add_f32 %x, %y
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    return
  }

  func.func @mfma_trans_coissue(
      %a: !waveamdmachine.reg<vgpr, 4>,
      %b: !waveamdmachine.reg<vgpr, 4>,
      %acc: !waveamdmachine.reg<vgpr, 16>,
      %x: !waveamdmachine.reg<vgpr, 1>) {
    %mfma = waveamdmachine.mfma_f32_32x32x16_f16 %a, %b, %acc
        : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
           !waveamdmachine.reg<vgpr, 16>)
          -> !waveamdmachine.reg<vgpr, 16>
    %trans = waveamdmachine.v_exp_f32 %x
        : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
    return
  }
}

// SMEMVALUE: func: smem_value_ready
// SMEMVALUE: query op_index=0 cycle=0 op=waveamdmachine.s_load_b32 stall=none cycles=0
// SMEMVALUE: commit op_index=0 issue=0 next=1 value_ready=7
// SMEMVALUE: query op_index=1 cycle=1 op=waveamdmachine.s_add_i32 stall=memory_value cycles=6 components=memory_value:6

// SMEMWAIT: func: smem_wait
// SMEMWAIT: query op_index=0 cycle=0 op=waveamdmachine.s_load_b32 stall=none cycles=0
// SMEMWAIT: query op_index=1 cycle=1 op=waveamdmachine.s_waitcnt stall=waitcnt cycles=6 components=waitcnt:6

// TOKENWAIT: func: token_store_wait
// TOKENWAIT: query op_index=2 cycle=1 op=waveamdmachine.global_store_b32 stall=memory_token cycles=6 components=memory_token:6

// TOKENCARRY: func: store_then_load_carries_token
// TOKENCARRY: query op_index=2 cycle=1 op=waveamdmachine.global_load_b32 stall=none cycles=0
// TOKENCARRY: query op_index=3 cycle=2 op=waveamdmachine.s_barrier stall=memory_token cycles=6 components=memory_token:6

// BARRIER: func: barrier_does_not_drain
// BARRIER: query op_index=2 cycle=1 op=waveamdmachine.s_barrier stall=none cycles=0
// BARRIER: query op_index=3 cycle=2 op=waveamdmachine.s_waitcnt stall=waitcnt cycles=5 components=waitcnt:5

// M0: func: m0_gap
// M0: query op_index=1 cycle=1 op=waveamdmachine.ds_load_addtid_b32 stall=m0_read_write cycles=1 components=m0_read_write:1

// M0DMA: func: m0_dma_capture_gap
// M0DMA: query op_index=2 cycle=4 op=waveamdmachine.s_mov_m0 stall=m0_read_write cycles=1 components=m0_read_write:1

// M0DMATAGGED: func: m0_tagged_dma_capture_gap
// M0DMATAGGED: query op_index=2 cycle=4 op=waveamdmachine.s_mov_m0 stall=m0_read_write cycles=1 components=m0_read_write:1

// M0DMAFILL: func: m0_dma_capture_filled
// M0DMAFILL: query op_index=3 cycle=8 op=waveamdmachine.s_mov_m0 stall=none cycles=0 components=none

// M0DMACDNA3: func: m0_dma_capture_gap
// M0DMACDNA3: arch: gfx942
// M0DMACDNA3: query op_index=2 cycle=4 op=waveamdmachine.s_mov_m0 stall=none cycles=0 components=none

// PIPE: func: salu_pipe_cap
// PIPE: query op_index=1 cycle=1 op=waveamdmachine.s_add_i32 stall=issue_backpressure cycles=1 components=issue_backpressure:1

// LDSDMA: func: lds_dma_issue_backpressure
// LDSDMA: query op_index=8 cycle=28 op=waveamdmachine.global_load_lds_b128 stall=issue_backpressure cycles=152 components=issue_backpressure:152
// LDSDMA: commit op_index=8 issue=180 next=184

// TRANS: query op_index=1 cycle=4 op=waveamdmachine.v_mul_f32 stall=instruction_hazard cycles=1 components=instruction_hazard:1

// READLANE: query op_index=1 cycle=4 op=waveamdmachine.v_readfirstlane_b32 stall=instruction_hazard cycles=1 components=instruction_hazard:1

// VCC: query op_index=2 cycle=8 op=waveamdmachine.v_cndmask_b32_vcc stall=instruction_hazard cycles=1 components=instruction_hazard:1

// ALIAS: query op_index=1 cycle=4 op=waveamdmachine.tuple_to_elements stall=none cycles=0 components=none
// ALIAS: commit op_index=1 issue=4 next=4 value_ready=20
// ALIAS: commit op_index=2 issue=4 next=8
// ALIAS: query op_index=3 cycle=8 op=waveamdmachine.v_add_u32 stall=memory_value cycles=12 components=memory_value:12

// TOKENALIAS: commit op_index=1 issue=4 next=4 value_ready=4 token_ready=20
// TOKENALIAS: query op_index=2 cycle=4 op=waveamdmachine.global_store_b32 stall=memory_token cycles=16 components=memory_token:16

// ISSUETOKEN: func: issue_token_drops_completion
// ISSUETOKEN: commit op_index=1 issue=4 next=4 value_ready=4 token_ready=4 pending_vmem=1
// ISSUETOKEN: query op_index=2 cycle=4 op=waveamdmachine.s_barrier stall=none cycles=0 components=none

// HAZARDALIAS: query op_index=1 cycle=4 op=waveamdmachine.tuple_from_elements stall=none cycles=0 components=none
// HAZARDALIAS: query op_index=2 cycle=4 op=waveamdmachine.v_readfirstlane_b32 stall=instruction_hazard cycles=1 components=instruction_hazard:1

// CDNA3: arch: gfx942
// CDNA3: query op_index=0 cycle=0 op=waveamdmachine.s_add_i32 stall=none cycles=0

// CDNA4: arch: gfx950
// CDNA4: query op_index=0 cycle=0 op=waveamdmachine.s_add_i32 stall=none cycles=0

// DMACHUNKS: func: dma_issue_delay_chunks
// DMACHUNKS: commit op_index=1 issue=0 next=16 value_ready=16
// DMACHUNKS: commit op_index=2 issue=16 next=36 value_ready=36

// DMADELAY: func: dma_issue_delay_conditional
// DMADELAY: query op_index=1 cycle=0 op=waveamdmachine.dma_issue_delay stall=operand_value cycles=3 components=operand_value:3
// DMADELAY: commit op_index=1 issue=3 next=27 value_ready=27

// DMASKIP: func: dma_issue_delay_conditional
// DMASKIP: query op_index=1 cycle=0 op=waveamdmachine.dma_issue_delay stall=operand_value cycles=3 components=operand_value:3
// DMASKIP: commit op_index=1 issue=3 next=7 value_ready=7

// MFMA-PACKED: func: mfma_packed_coissue
// MFMA-PACKED: query op_index=1 cycle=4 op=waveamdmachine.v_pk_add_f32 stall=issue_backpressure cycles=4 components=issue_backpressure:4@simd/mfma_coissue

// MFMA-PACKED-CDNA3: arch: gfx942
// MFMA-PACKED-CDNA3: query op_index=1 cycle=4 op=waveamdmachine.v_pk_add_f32 stall=issue_backpressure cycles=4 components=issue_backpressure:4@simd/mfma_coissue

// MFMA-SCALAR: query op_index=1 cycle=4 op=waveamdmachine.v_add_f32 stall=none cycles=0 components=none

// MFMA-TRANS: query op_index=1 cycle=4 op=waveamdmachine.v_exp_f32 stall=issue_backpressure cycles=4 components=issue_backpressure:4@simd/mfma_coissue
