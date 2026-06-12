// RUN: wave-opt --waveamd-reg-alloc -split-input-file %s | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  // CHECK-LABEL: func.func @scratch_plan_available
  // CHECK-SAME: waveamdmachine.regalloc_debug_scratch_spill_plan =
  // CHECK-SAME: existing_private_bytes = 16 : i64
  // CHECK-SAME: reserved_spill_bytes = 4 : i64
  // CHECK-SAME: slot_base = 20 : i64
  // CHECK-SAME: slot_bytes = 4 : i64
  // CHECK-SAME: status = "available"
  // CHECK-SAME: uses_flat_scratch = false
  // CHECK-SAME: value_bytes = 4 : i64
  func.func @scratch_plan_available() attributes {
    wave.kernel,
    waveamdmachine.private_segment_fixed_size = 20 : i64,
    waveamdmachine.scratch_spill_bytes = 4 : i64,
    waveamdmachine.target_waves = 4 : i64
  } {
    return
  }
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx900"} {
  // CHECK-LABEL: func.func @scratch_plan_unsupported_target
  // CHECK-SAME: waveamdmachine.regalloc_debug_scratch_spill_plan =
  // CHECK-SAME: status = "unsupported_target"
  func.func @scratch_plan_unsupported_target() attributes {
    wave.kernel,
    waveamdmachine.target_waves = 4 : i64
  } {
    return
  }
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  // CHECK-LABEL: func.func @scratch_plan_wave_private_segment
  // CHECK-SAME: waveamdmachine.regalloc_debug_scratch_spill_plan =
  // CHECK-SAME: existing_private_bytes = 16 : i64
  // CHECK-SAME: reserved_spill_bytes = 4 : i64
  // CHECK-SAME: slot_base = 20 : i64
  // CHECK-SAME: slot_bytes = 4 : i64
  // CHECK-SAME: status = "available"
  func.func @scratch_plan_wave_private_segment() attributes {
    wave.kernel,
    wave.private_segment_fixed_size = 16 : i64,
    waveamdmachine.scratch_spill_bytes = 4 : i64,
    waveamdmachine.target_waves = 4 : i64
  } {
    return
  }
}
