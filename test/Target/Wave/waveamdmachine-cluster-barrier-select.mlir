// RUN: wave-opt --waveamd-to-machine --verify-diagnostics --split-input-file %s | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"} {

// CHECK-LABEL: func.func @select_barrier_scopes(
// CHECK: [[ROOT:%.*]] = waveamdmachine.token
// CHECK-NEXT: [[WORKGROUP:%.*]] = waveamdmachine.s_barrier [[ROOT]]
// CHECK-NEXT: waveamdmachine.cluster_barrier [[WORKGROUP]]
func.func @select_barrier_scopes() {
  %root = wave.token : !wave.mem.token
  %workgroup = wave.barrier %root
      : (!wave.mem.token) -> !wave.mem.token
  %cluster = wave.barrier %workgroup scope cluster
      : (!wave.mem.token) -> !wave.mem.token
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

func.func @reject_cluster_barrier() {
  %root = wave.token : !wave.mem.token
  // expected-error @below {{cluster barrier unsupported on target}}
  %cluster = wave.barrier %root scope cluster
      : (!wave.mem.token) -> !wave.mem.token
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1251"} {

func.func @reject_other_isa_stepping() {
  %root = wave.token : !wave.mem.token
  // expected-error @below {{cluster barrier unsupported on target}}
  %cluster = wave.barrier %root scope cluster
      : (!wave.mem.token) -> !wave.mem.token
  return
}

}
