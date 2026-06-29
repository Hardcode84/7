// RUN: wave-opt %s --waveamd-machine-schedule-report='print-deps' -verify-diagnostics

module {
  // expected-error @below {{waveamdmachine.schedule_max_region_ops must be -1 or non-negative}}
  func.func @bad_region_limit()
      attributes {waveamdmachine.schedule_max_region_ops = -2 : i64} {
    return
  }
}
