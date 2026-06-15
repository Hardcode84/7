// RUN: rm -f %t.yaml
// RUN: wave-opt --waveamd-reg-alloc --remarks-filter=waveamdmachine-regalloc \
// RUN:   --remark-policy=all --remark-format=yaml --remarks-output-file=%t.yaml %s >/dev/null
// RUN: FileCheck %s --input-file=%t.yaml

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  // CHECK: Name:            regalloc-lds-plan
  // CHECK: Function:        lds_plan_available
  // CHECK: existing_dynamic_bytes: '128'
  // CHECK: existing_fixed_bytes: '1024'
  // CHECK: reserved_spill_bytes: '256'
  // CHECK: status:          unsupported_waves_per_workgroup
  // CHECK: value_bytes:     '4'
  // CHECK: slot_base:       '1280'
  // CHECK: slot_bytes:      '512'
  // CHECK: wave_stride:     '256'
  // CHECK: wavefront_size:  '64'
  // CHECK: waves_per_workgroup: '2'
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

  // CHECK: Name:            regalloc-lds-plan
  // CHECK: Function:        lds_plan_machine_lds
  // CHECK: existing_dynamic_bytes: '128'
  // CHECK: existing_fixed_bytes: '1024'
  // CHECK: status:          available
  func.func @lds_plan_machine_lds() attributes {
    wave.kernel,
    wave.workgroup_size = array<i32: 64, 1, 1>,
    waveamdmachine.dynamic_lds_size = 128 : i64,
    waveamdmachine.lds_size = 1152 : i64,
    waveamdmachine.target_waves = 4 : i64
  } {
    return
  }

  // CHECK: Name:            regalloc-lds-plan
  // CHECK: Function:        lds_plan_missing_target_waves
  // CHECK: status:          missing_target_waves
  func.func @lds_plan_missing_target_waves() attributes {
    wave.kernel,
    wave.workgroup_size = array<i32: 64, 1, 1>
  } {
    return
  }

  // CHECK: Name:            regalloc-lds-plan
  // CHECK: Function:        lds_plan_missing_workgroup_shape
  // CHECK: status:          missing_workgroup_shape
  func.func @lds_plan_missing_workgroup_shape() attributes {
    wave.kernel,
    waveamdmachine.target_waves = 4 : i64
  } {
    return
  }

  // CHECK: Name:            regalloc-lds-plan
  // CHECK: Function:        lds_plan_invalid_workgroup_shape
  // CHECK: status:          invalid_workgroup_shape
  func.func @lds_plan_invalid_workgroup_shape() attributes {
    wave.kernel,
    wave.workgroup_size = array<i32: 64, 1, 1>,
    wave.waves_per_workgroup = 2 : i64,
    waveamdmachine.target_waves = 4 : i64
  } {
    return
  }

  // CHECK: Name:            regalloc-lds-plan
  // CHECK: Function:        lds_plan_unsupported_workgroup_shape
  // CHECK: status:          unsupported_workgroup_shape
  func.func @lds_plan_unsupported_workgroup_shape() attributes {
    wave.kernel,
    wave.workgroup_size = array<i32: 8, 8, 1>,
    waveamdmachine.target_waves = 4 : i64
  } {
    return
  }

  // CHECK: Name:            regalloc-lds-plan
  // CHECK: Function:        lds_plan_insufficient_lds
  // CHECK: status:          insufficient_lds
  func.func @lds_plan_insufficient_lds() attributes {
    wave.kernel,
    wave.lds_size = 131072 : i64,
    wave.workgroup_size = array<i32: 64, 1, 1>,
    waveamdmachine.target_waves = 8 : i64
  } {
    return
  }
}
