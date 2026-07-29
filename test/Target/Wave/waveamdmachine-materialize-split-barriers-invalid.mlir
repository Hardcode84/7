// RUN: wave-opt %s --split-input-file --waveamd-materialize-split-barriers --verify-diagnostics

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"} {
  func.func @ticket_escape() {
    %state = waveamdmachine.barrier_init : !waveamdmachine.barrier
    %root = waveamdmachine.token : !waveamdmachine.mem.token
    // expected-error @below {{native split barrier ticket must only feed barrier_wait}}
    %ticket, %arrived = waveamdmachine.barrier_arrive %state after %root
        : (!waveamdmachine.barrier, !waveamdmachine.mem.token)
          -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
    %extra = waveamdmachine.v_add_u32 %ticket, %ticket
        : (!waveamdmachine.reg<vgpr, 1>,
           !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    %ready = waveamdmachine.barrier_wait %state, %ticket after %arrived
        : (!waveamdmachine.barrier, !waveamdmachine.reg<vgpr, 1>,
           !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    return
  }
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"} {
  func.func @overlapping_pairs() {
    %state0 = waveamdmachine.barrier_init : !waveamdmachine.barrier
    %state1 = waveamdmachine.barrier_init : !waveamdmachine.barrier
    %root = waveamdmachine.token : !waveamdmachine.mem.token
    %ticket0, %arrived0 =
        waveamdmachine.barrier_arrive %state0 after %root
        : (!waveamdmachine.barrier, !waveamdmachine.mem.token)
          -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
    // expected-error @below {{native workgroup barrier pairs overlap}}
    %ticket1, %arrived1 = waveamdmachine.barrier_arrive %state1 after %root
        : (!waveamdmachine.barrier, !waveamdmachine.mem.token)
          -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
    %ready1 =
        waveamdmachine.barrier_wait %state1, %ticket1 after %arrived1
        : (!waveamdmachine.barrier, !waveamdmachine.reg<vgpr, 1>,
           !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    %ready0 =
        waveamdmachine.barrier_wait %state0, %ticket0 after %arrived0
        : (!waveamdmachine.barrier, !waveamdmachine.reg<vgpr, 1>,
           !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    return
  }
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"} {
  func.func private @callee()

  func.func @call_between_phases() {
    %state = waveamdmachine.barrier_init : !waveamdmachine.barrier
    %root = waveamdmachine.token : !waveamdmachine.mem.token
    %ticket, %arrived = waveamdmachine.barrier_arrive %state after %root
        : (!waveamdmachine.barrier, !waveamdmachine.mem.token)
          -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
    // expected-error @below {{native split barrier pair cannot cross a call}}
    func.call @callee() : () -> ()
    %ready = waveamdmachine.barrier_wait %state, %ticket after %arrived
        : (!waveamdmachine.barrier, !waveamdmachine.reg<vgpr, 1>,
           !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    return
  }
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"} {
  func.func @foreign_handle(%state: !waveamdmachine.barrier) {
    %unused = waveamdmachine.barrier_init : !waveamdmachine.barrier
    %root = waveamdmachine.token : !waveamdmachine.mem.token
    // expected-error @below {{native split barrier requires a local barrier_init}}
    %ticket, %arrived = waveamdmachine.barrier_arrive %state after %root
        : (!waveamdmachine.barrier, !waveamdmachine.mem.token)
          -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
    %ready = waveamdmachine.barrier_wait %state, %ticket after %arrived
        : (!waveamdmachine.barrier, !waveamdmachine.reg<vgpr, 1>,
           !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    return
  }
}
