// RUN: wave-opt --verify-diagnostics --split-input-file %s

module {
  func.func @negative_offset() {
    // expected-error @below {{offset must be in [0, 31]}}
    %id = waveamdmachine.s_getreg_hw_id offset -1 width 1
        : !waveamdmachine.reg<sgpr, 1>
    return
  }
}

// -----

module {
  func.func @large_offset() {
    // expected-error @below {{offset must be in [0, 31]}}
    %id = waveamdmachine.s_getreg_hw_id offset 32 width 1
        : !waveamdmachine.reg<sgpr, 1>
    return
  }
}

// -----

module {
  func.func @zero_width() {
    // expected-error @below {{width must be in [1, 32 - offset]}}
    %id = waveamdmachine.s_getreg_hw_id offset 0 width 0
        : !waveamdmachine.reg<sgpr, 1>
    return
  }
}

// -----

module {
  func.func @crosses_register() {
    // expected-error @below {{width must be in [1, 32 - offset]}}
    %id = waveamdmachine.s_getreg_hw_id offset 31 width 2
        : !waveamdmachine.reg<sgpr, 1>
    return
  }
}
