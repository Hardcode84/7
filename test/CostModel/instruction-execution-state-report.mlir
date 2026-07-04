// RUN: wave-instruction-state-report --func=smem_value_ready --smem-value-latency=7 %s | FileCheck %s --check-prefix=SMEMVALUE
// RUN: wave-instruction-state-report --func=smem_wait --smem-counter-latency=7 %s | FileCheck %s --check-prefix=SMEMWAIT
// RUN: wave-instruction-state-report --func=token_store_wait --vmem-counter-latency=7 %s | FileCheck %s --check-prefix=TOKENWAIT
// RUN: wave-instruction-state-report --func=store_then_load_carries_token --vmem-counter-latency=7 --vscnt-counter-latency=7 %s | FileCheck %s --check-prefix=TOKENCARRY
// RUN: wave-instruction-state-report --func=barrier_does_not_drain --vmem-counter-latency=7 %s | FileCheck %s --check-prefix=BARRIER
// RUN: wave-instruction-state-report --func=m0_gap %s | FileCheck %s --check-prefix=M0
// RUN: wave-instruction-state-report --func=salu_pipe_cap --pipe-backpressure --salu-max-in-flight=1 %s | FileCheck %s --check-prefix=PIPE
// RUN: wave-instruction-state-report --func=salu_pipe_cap --arch=gfx942 %s | FileCheck %s --check-prefix=CDNA3
// RUN: wave-instruction-state-report --func=salu_pipe_cap --arch=gfx950 %s | FileCheck %s --check-prefix=CDNA4

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

// PIPE: func: salu_pipe_cap
// PIPE: query op_index=1 cycle=1 op=waveamdmachine.s_add_i32 stall=issue_backpressure cycles=1 components=issue_backpressure:1

// CDNA3: arch: gfx942
// CDNA3: query op_index=0 cycle=0 op=waveamdmachine.s_add_i32 stall=none cycles=0

// CDNA4: arch: gfx950
// CDNA4: query op_index=0 cycle=0 op=waveamdmachine.s_add_i32 stall=none cycles=0
