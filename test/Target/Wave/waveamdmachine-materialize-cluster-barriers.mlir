// RUN: wave-opt %s --waveamd-materialize-split-barriers | FileCheck %s --check-prefix=LOWER
// RUN: wave-opt %s --pass-pipeline='builtin.module(waveamd-materialize-split-barriers,waveamd-preserve-hw-regs,canonicalize,cse)' | FileCheck %s --check-prefix=CSE

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"} {

// LOWER-LABEL: func.func @cluster_and_workgroup_barriers(
// LOWER-SAME: wave.lds_size = 64 : i64
// LOWER: [[ROOT:%.*]] = waveamdmachine.token
// LOWER-NEXT: [[SEED0:%.*]] = waveamdmachine.s_cmp_eq_u32_barrier_seed
// LOWER-NEXT: [[FIRST0:%.*]], [[ARRIVED0:%.*]] = waveamdmachine.s_barrier_signal_isfirst [[SEED0]] after [[ROOT]]
// LOWER-NEXT: [[LOCAL0:%.*]] = waveamdmachine.s_barrier_wait [[ARRIVED0]]
// LOWER-NEXT: [[ELECTED0:%.*]] = waveamdmachine.uniform_if [[FIRST0]] {
// LOWER-NEXT:   [[CLUSTER_SIGNAL0:%.*]] = waveamdmachine.s_barrier_signal [[LOCAL0]] scope cluster
// LOWER-NEXT:   waveamdmachine.yield [[CLUSTER_SIGNAL0]]
// LOWER-NEXT: } otherwise {
// LOWER-NEXT:   waveamdmachine.yield [[LOCAL0]]
// LOWER-NEXT: }
// LOWER-NEXT: [[READY0:%.*]] = waveamdmachine.s_barrier_wait [[ELECTED0]] scope cluster
// LOWER-NEXT: [[SEED1:%.*]] = waveamdmachine.s_cmp_eq_u32_barrier_seed
// LOWER-NEXT: [[FIRST1:%.*]], [[ARRIVED1:%.*]] = waveamdmachine.s_barrier_signal_isfirst [[SEED1]] after [[READY0]]
// LOWER-NEXT: [[LOCAL1:%.*]] = waveamdmachine.s_barrier_wait [[ARRIVED1]]
// LOWER-NEXT: [[ELECTED1:%.*]] = waveamdmachine.uniform_if [[FIRST1]] {
// LOWER-NEXT:   [[CLUSTER_SIGNAL1:%.*]] = waveamdmachine.s_barrier_signal [[LOCAL1]] scope cluster
// LOWER-NEXT:   waveamdmachine.yield [[CLUSTER_SIGNAL1]]
// LOWER-NEXT: } otherwise {
// LOWER-NEXT:   waveamdmachine.yield [[LOCAL1]]
// LOWER-NEXT: }
// LOWER-NEXT: [[READY1:%.*]] = waveamdmachine.s_barrier_wait [[ELECTED1]] scope cluster
// LOWER-NEXT: [[WORKGROUP_SIGNAL:%.*]] = waveamdmachine.s_barrier_signal [[READY1]]
// LOWER-NEXT: [[WORKGROUP_READY:%.*]] = waveamdmachine.s_barrier_wait [[WORKGROUP_SIGNAL]]
// LOWER-NEXT: waveamdmachine.after [[WORKGROUP_READY]]
// LOWER-NOT: waveamdmachine.barrier_init
// LOWER-NOT: waveamdmachine.ds_add_rtn_u32
// LOWER-NOT: waveamdmachine.ds_load_b32
// LOWER-NOT: waveamdmachine.s_sleep
// CSE: waveamdmachine.s_cmp_eq_u32_barrier_seed
// CSE-NEXT: waveamdmachine.s_barrier_signal_isfirst
// CSE: waveamdmachine.s_barrier_signal {{.*}} scope cluster
// CSE: waveamdmachine.s_barrier_wait {{.*}} scope cluster
// CSE: waveamdmachine.s_cmp_eq_u32_barrier_seed
// CSE-NEXT: waveamdmachine.s_barrier_signal_isfirst
// CSE: waveamdmachine.s_barrier_signal {{.*}} scope cluster
// CSE: waveamdmachine.s_barrier_wait {{.*}} scope cluster
// CSE-NOT: waveamdmachine.barrier_init
// CSE-NOT: waveamdmachine.ds_add_rtn_u32
func.func @cluster_and_workgroup_barriers()
    attributes {wave.kernel, wave.lds_size = 64 : i64} {
  %root = waveamdmachine.token : !waveamdmachine.mem.token
  %cluster0 = waveamdmachine.cluster_barrier %root
      : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %cluster1 = waveamdmachine.cluster_barrier %cluster0
      : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %workgroup = waveamdmachine.s_barrier %cluster1
      : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %use = waveamdmachine.after %workgroup
      : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  return
}

}
