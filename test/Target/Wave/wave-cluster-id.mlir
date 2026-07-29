// RUN: wave-opt --split-input-file --waveamd-to-machine --verify-diagnostics %s | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"} {

// CHECK-LABEL: func.func @fixed_cluster_ids
// CHECK-SAME: wave.cluster_dims = array<i32: 2, 2, 1>
// CHECK: waveamdmachine.s_cluster_id_x
// CHECK: waveamdmachine.s_cluster_workgroup_id_y
// CHECK: waveamdmachine.imm 0
// CHECK-COUNT-2: waveamdmachine.imm 1
// CHECK: waveamdmachine.imm 0
func.func @fixed_cluster_ids() attributes {
    wave.kernel,
    wave.cluster_dims = array<i32: 2, 2, 1>
  } {
  %cluster = wave.cluster_id x
  %local = wave.cluster_workgroup_id y
  %local_z = wave.cluster_workgroup_id z
  %max_x = wave.cluster_workgroup_max_id x
  %max_y = wave.cluster_workgroup_max_id y
  %max_z = wave.cluster_workgroup_max_id z
  return
}

// CHECK-LABEL: func.func @runtime_cluster_ids
// CHECK: waveamdmachine.s_cluster_id_z
// CHECK: waveamdmachine.s_cluster_workgroup_id_x
// CHECK: waveamdmachine.s_cluster_workgroup_max_id_y
func.func @runtime_cluster_ids() attributes {wave.kernel} {
  %cluster = wave.cluster_id z
  %local = wave.cluster_workgroup_id x
  %max = wave.cluster_workgroup_max_id y
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

func.func @wrong_target() attributes {wave.kernel} {
  // expected-error @below {{cluster ID lowering requires gfx1250}}
  %cluster = wave.cluster_id x
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"} {

// CHECK-LABEL: func.func @canonical_cluster_dims
// CHECK-SAME: gpu.known_cluster_size = array<i32: 2, 1, 1>
// CHECK: waveamdmachine.imm 1
func.func @canonical_cluster_dims() attributes {
    wave.kernel,
    gpu.known_cluster_size = array<i32: 2, 1, 1>
  } {
  %max = wave.cluster_workgroup_max_id x
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"} {

// expected-error @below {{WaveAMDMachine selection requires wave.cluster_dims to be a dense i32 array}}
func.func @wrong_cluster_type() attributes {
    wave.kernel,
    wave.cluster_dims = array<i64: 2, 2, 1>
  } {
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"} {

// expected-error @below {{WaveAMDMachine selection requires wave.cluster_dims and gpu.known_cluster_size to match}}
func.func @mismatched_cluster_dims() attributes {
    wave.kernel,
    wave.cluster_dims = array<i32: 2, 2, 1>,
    gpu.known_cluster_size = array<i32: 4, 1, 1>
  } {
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"} {

// expected-error @below {{WaveAMDMachine selection requires wave.cluster_dims with exactly three dimensions}}
func.func @bad_cluster_rank() attributes {
    wave.kernel,
    wave.cluster_dims = array<i32: 2, 2>
  } {
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"} {

// expected-error @below {{WaveAMDMachine selection requires positive wave.cluster_dims; axis 1 is 0}}
func.func @bad_cluster_dim() attributes {
    wave.kernel,
    wave.cluster_dims = array<i32: 2, 0, 1>
  } {
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"} {

// expected-error @below {{WaveAMDMachine selection requires wave.cluster_dims axes to fit 4 bits; axis 0 is 16}}
func.func @wide_cluster_dim() attributes {
    wave.kernel,
    wave.cluster_dims = array<i32: 16, 1, 1>
  } {
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"} {

// expected-error @below {{WaveAMDMachine selection requires at most 16 workgroups per cluster; product is 18}}
func.func @large_cluster() attributes {
    wave.kernel,
    wave.cluster_dims = array<i32: 3, 3, 2>
  } {
  return
}

}
