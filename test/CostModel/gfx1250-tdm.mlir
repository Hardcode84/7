// RUN: wave-sim-report --func=tdm_classes --op-latencies %s | FileCheck %s --check-prefix=CLASS
// RUN: wave-instruction-state-report --func=tdm_classes %s | FileCheck %s --check-prefix=ISSUE
// RUN: wave-instruction-state-report --func=tensor_partial_wait %s | FileCheck %s --check-prefix=WAIT
// RUN: wave-instruction-state-report --func=mixed_load_tensor_wait --vmem-counter-latency=400 %s | FileCheck %s --check-prefix=MIXED
// RUN: wave-instruction-state-report --func=split_store_wait --vscnt-counter-latency=11 %s | FileCheck %s --check-prefix=STORE
// RUN: wave-instruction-state-report --func=split_ds_km_wait --lds-counter-latency=7 --smem-counter-latency=11 %s | FileCheck %s --check-prefix=LGKM

// CLASS: op=waveamdmachine.tdm_load class=WriteTDM fu=LGKM latency=320 counter_latency=320 issues=2
// CLASS: op=waveamdmachine.tdm_store class=WriteTDM fu=LGKM latency=320 counter_latency=320 issues=2

// ISSUE: query op_index=1 cycle=0 op=waveamdmachine.tdm_load stall=none
// ISSUE: commit op_index=1 issue=0 next=2
// ISSUE: query op_index=2 cycle=2 op=waveamdmachine.tdm_store stall=none
// ISSUE: commit op_index=2 issue=2 next=4

// WAIT: query op_index=3 cycle=4 op=waveamdmachine.s_waitcnt_split stall=waitcnt cycles=316 components=waitcnt:316
// WAIT: commit op_index=3 issue=320 next=320
// WAIT: query op_index=4 cycle=320 op=waveamdmachine.s_waitcnt_split stall=waitcnt cycles=2 components=waitcnt:2
// WAIT: commit op_index=4 issue=322 next=322

// MIXED: query op_index=3 cycle=3 op=waveamdmachine.s_waitcnt_split stall=waitcnt cycles=399 components=waitcnt:399
// MIXED: commit op_index=3 issue=402 next=402

// STORE: query op_index=2 cycle=1 op=waveamdmachine.s_waitcnt_split stall=waitcnt cycles=10 components=waitcnt:10
// STORE: commit op_index=2 issue=11 next=11

// LGKM: query op_index=2 cycle=2 op=waveamdmachine.s_waitcnt_split stall=waitcnt cycles=5 components=waitcnt:5
// LGKM: commit op_index=2 issue=7 next=7
// LGKM: query op_index=3 cycle=7 op=waveamdmachine.s_waitcnt_split stall=waitcnt cycles=5 components=waitcnt:5
// LGKM: commit op_index=3 issue=12 next=12

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"} {
  func.func @tdm_classes(
      %d0: !waveamdmachine.reg<sgpr, 4>,
      %d1: !waveamdmachine.reg<sgpr, 8>) {
    %root = waveamdmachine.token : !waveamdmachine.mem.token
    %load = waveamdmachine.tdm_load %d0, %d1 after %root
        : (!waveamdmachine.reg<sgpr, 4>,
           !waveamdmachine.reg<sgpr, 8>,
           !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    %store = waveamdmachine.tdm_store %d0, %d1 after %root
        : (!waveamdmachine.reg<sgpr, 4>,
           !waveamdmachine.reg<sgpr, 8>,
           !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    return
  }

  func.func @tensor_partial_wait(
      %d0: !waveamdmachine.reg<sgpr, 4>,
      %d1: !waveamdmachine.reg<sgpr, 8>) {
    %root = waveamdmachine.token : !waveamdmachine.mem.token
    %first = waveamdmachine.tdm_load %d0, %d1 after %root
        : (!waveamdmachine.reg<sgpr, 4>,
           !waveamdmachine.reg<sgpr, 8>,
           !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    %second = waveamdmachine.tdm_load %d0, %d1 after %root
        : (!waveamdmachine.reg<sgpr, 4>,
           !waveamdmachine.reg<sgpr, 8>,
           !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    waveamdmachine.s_waitcnt_split tensorcnt(1)
    waveamdmachine.s_waitcnt_split tensorcnt(0)
    return
  }

  func.func @mixed_load_tensor_wait(
      %d0: !waveamdmachine.reg<sgpr, 4>,
      %d1: !waveamdmachine.reg<sgpr, 8>,
      %off: !waveamdmachine.reg<vgpr, 1>,
      %base: !waveamdmachine.reg<sgpr, 2>) {
    %root = waveamdmachine.token : !waveamdmachine.mem.token
    %tensor = waveamdmachine.tdm_load %d0, %d1 after %root
        : (!waveamdmachine.reg<sgpr, 4>,
           !waveamdmachine.reg<sgpr, 8>,
           !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    %value, %load = waveamdmachine.global_load_b32 %off, %base after %root
        : (!waveamdmachine.reg<vgpr, 1>,
           !waveamdmachine.reg<sgpr, 2>,
           !waveamdmachine.mem.token)
          -> (!waveamdmachine.reg<vgpr, 1>,
              !waveamdmachine.mem.token)
    waveamdmachine.s_waitcnt_split loadcnt(0) tensorcnt(0)
    return
  }

  func.func @split_store_wait(
      %off: !waveamdmachine.reg<vgpr, 1>,
      %value: !waveamdmachine.reg<vgpr, 1>,
      %base: !waveamdmachine.reg<sgpr, 2>) {
    %root = waveamdmachine.token : !waveamdmachine.mem.token
    %store = waveamdmachine.global_store_b32 %off, %value, %base after %root
        : (!waveamdmachine.reg<vgpr, 1>,
           !waveamdmachine.reg<vgpr, 1>,
           !waveamdmachine.reg<sgpr, 2>,
           !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    waveamdmachine.s_waitcnt_split storecnt(0)
    return
  }

  func.func @split_ds_km_wait(
      %addr: !waveamdmachine.reg<vgpr, 1>,
      %value: !waveamdmachine.reg<agpr, 1>,
      %zero: !waveamdmachine.imm) {
    %ds = waveamdmachine.ds_store_b32 %addr, %value
        : (!waveamdmachine.reg<vgpr, 1>,
           !waveamdmachine.reg<agpr, 1>) -> !waveamdmachine.mem.token
    %smem = waveamdmachine.s_load_b32 %zero, "s[0:1]"
        : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
    waveamdmachine.s_waitcnt_split dscnt(0)
    waveamdmachine.s_waitcnt_split kmcnt(0)
    return
  }
}
