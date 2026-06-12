// RUN: wave-opt --waveamd-reg-alloc -split-input-file %s | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  // CHECK-LABEL: func.func @lds_plan_available
  // CHECK-SAME: waveamdmachine.regalloc_debug_lds_spill_plan =
  // CHECK-SAME: existing_dynamic_bytes = 128 : i64
  // CHECK-SAME: existing_fixed_bytes = 1024 : i64
  // CHECK-SAME: reserved_spill_bytes = 256 : i64
  // CHECK-SAME: slot_base = 1280 : i64
  // CHECK-SAME: slot_bytes = 512 : i64
  // CHECK-SAME: status = "available"
  // CHECK-SAME: value_bytes = 4 : i64
  // CHECK-SAME: wave_stride = 256 : i64
  // CHECK-SAME: wavefront_size = 64 : i64
  // CHECK-SAME: waves_per_workgroup = 2 : i64
  func.func @lds_plan_available() attributes {
    wave.kernel,
    wave.lds_size = 1024 : i64,
    wave.dynamic_lds_size = 128 : i64,
    wave.workgroup_size = array<i32: 128, 1, 1>,
    wave.waves_per_workgroup = 2 : i64,
    waveamdmachine.lds_spill_bytes = 256 : i64,
    waveamdmachine.target_waves = 4 : i64
  } {
    return
  }
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  // CHECK-LABEL: func.func @lds_plan_machine_lds
  // CHECK-SAME: existing_dynamic_bytes = 128 : i64
  // CHECK-SAME: existing_fixed_bytes = 1024 : i64
  // CHECK-SAME: status = "available"
  func.func @lds_plan_machine_lds() attributes {
    wave.kernel,
    wave.workgroup_size = array<i32: 64, 1, 1>,
    waveamdmachine.dynamic_lds_size = 128 : i64,
    waveamdmachine.lds_size = 1152 : i64,
    waveamdmachine.target_waves = 4 : i64
  } {
    return
  }
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  // CHECK-LABEL: func.func @lds_plan_missing_target_waves
  // CHECK-SAME: waveamdmachine.regalloc_debug_lds_spill_plan =
  // CHECK-SAME: status = "missing_target_waves"
  func.func @lds_plan_missing_target_waves() attributes {
    wave.kernel,
    wave.workgroup_size = array<i32: 64, 1, 1>
  } {
    return
  }
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  // CHECK-LABEL: func.func @lds_plan_missing_workgroup_shape
  // CHECK-SAME: waveamdmachine.regalloc_debug_lds_spill_plan =
  // CHECK-SAME: status = "missing_workgroup_shape"
  func.func @lds_plan_missing_workgroup_shape() attributes {
    wave.kernel,
    waveamdmachine.target_waves = 4 : i64
  } {
    return
  }
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  // CHECK-LABEL: func.func @lds_plan_invalid_workgroup_shape
  // CHECK-SAME: waveamdmachine.regalloc_debug_lds_spill_plan =
  // CHECK-SAME: status = "invalid_workgroup_shape"
  func.func @lds_plan_invalid_workgroup_shape() attributes {
    wave.kernel,
    wave.workgroup_size = array<i32: 64, 1, 1>,
    wave.waves_per_workgroup = 2 : i64,
    waveamdmachine.target_waves = 4 : i64
  } {
    return
  }
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  // CHECK-LABEL: func.func @lds_plan_insufficient_lds
  // CHECK-SAME: waveamdmachine.regalloc_debug_lds_spill_plan =
  // CHECK-SAME: status = "insufficient_lds"
  func.func @lds_plan_insufficient_lds() attributes {
    wave.kernel,
    wave.lds_size = 131072 : i64,
    wave.workgroup_size = array<i32: 64, 1, 1>,
    waveamdmachine.target_waves = 8 : i64
  } {
    return
  }
}
