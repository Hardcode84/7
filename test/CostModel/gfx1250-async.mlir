// RUN: wave-sim-report --func=async_classes --op-latencies %s | FileCheck %s --check-prefix=CLASS
// RUN: wave-sim-report --func=async_classes --timeline %s | FileCheck %s --check-prefix=TIMELINE
// RUN: wave-sim-report --func=cluster_async_class --op-latencies %s | FileCheck %s --check-prefix=CLUSTER
// RUN: wave-instruction-state-report --func=async_partial_wait %s | FileCheck %s --check-prefix=WAIT

// CLASS: op=waveamdmachine.global_load_async_to_lds_b8 class=WriteVMEM fu=VMEM latency=320 counter_latency=320 issues=2
// TIMELINE: counter_drained cycle=320 fu=VMEM counter=async op=waveamdmachine.global_load_async_to_lds_b8
// CLUSTER: op=waveamdmachine.cluster_load_async_to_lds_b32 class=WriteVMEM fu=VMEM latency=320 counter_latency=320 issues=2
// WAIT: query op_index=3 cycle=4 op=waveamdmachine.s_waitcnt_split stall=waitcnt cycles=316 components=waitcnt:316
// WAIT: commit op_index=3 issue=320 next=320
// WAIT: query op_index=4 cycle=320 op=waveamdmachine.s_waitcnt_split stall=waitcnt cycles=2 components=waitcnt:2
// WAIT: commit op_index=4 issue=322 next=322

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"} {
  func.func @async_classes(
      %lds: !waveamdmachine.reg<vgpr, 1>,
      %offset: !waveamdmachine.reg<vgpr, 1>,
      %base: !waveamdmachine.reg<sgpr, 2>) {
    %root = waveamdmachine.token : !waveamdmachine.mem.token
    %loaded = waveamdmachine.global_load_async_to_lds_b8
        %lds, %offset, %base after %root
        : (!waveamdmachine.reg<vgpr, 1>,
           !waveamdmachine.reg<vgpr, 1>,
           !waveamdmachine.reg<sgpr, 2>,
           !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    return
  }

  func.func @cluster_async_class(
      %lds: !waveamdmachine.reg<vgpr, 1>,
      %offset: !waveamdmachine.reg<vgpr, 1>,
      %base: !waveamdmachine.reg<sgpr, 2>,
      %m0: !waveamdmachine.m0) {
    %root = waveamdmachine.token : !waveamdmachine.mem.token
    %loaded = waveamdmachine.cluster_load_async_to_lds_b32
        %lds, %offset, %base, %m0 after %root
        : (!waveamdmachine.reg<vgpr, 1>,
           !waveamdmachine.reg<vgpr, 1>,
           !waveamdmachine.reg<sgpr, 2>,
           !waveamdmachine.m0,
           !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    return
  }

  func.func @async_partial_wait(
      %lds: !waveamdmachine.reg<vgpr, 1>,
      %offset: !waveamdmachine.reg<vgpr, 1>,
      %base: !waveamdmachine.reg<sgpr, 2>) {
    %root = waveamdmachine.token : !waveamdmachine.mem.token
    %first = waveamdmachine.global_load_async_to_lds_b8
        %lds, %offset, %base after %root
        : (!waveamdmachine.reg<vgpr, 1>,
           !waveamdmachine.reg<vgpr, 1>,
           !waveamdmachine.reg<sgpr, 2>,
           !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    %second = waveamdmachine.global_load_async_to_lds_b32
        %lds, %offset, %base after %root
        : (!waveamdmachine.reg<vgpr, 1>,
           !waveamdmachine.reg<vgpr, 1>,
           !waveamdmachine.reg<sgpr, 2>,
           !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    waveamdmachine.s_waitcnt_split asynccnt(1)
    waveamdmachine.s_waitcnt_split asynccnt(0)
    return
  }
}
