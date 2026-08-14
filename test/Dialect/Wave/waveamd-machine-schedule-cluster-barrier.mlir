// RUN: wave-opt %s -split-input-file --waveamd-machine-schedule-report='print-classes=1' 2>&1 >/dev/null | FileCheck %s --check-prefix=CLASS
// RUN: wave-opt %s -split-input-file --waveamd-machine-schedule='apply-schedule=1' | FileCheck %s --check-prefix=IR
// RUN: wave-opt %s -split-input-file --waveamd-machine-multi-wave-specialize | FileCheck %s --check-prefix=NOSPECIALIZE

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"} {

// CLASS: op func=cluster_barrier_boundary{{.*}}name=waveamdmachine.cluster_barrier
// CLASS-SAME: class=WriteBarrier fu=BRANCH
// IR-LABEL: func.func @cluster_barrier_boundary(
// IR: [[LOAD:%.*]], [[LOADED:%.*]] = waveamdmachine.ds_load_b32
// IR-NEXT: [[READY:%.*]] = waveamdmachine.cluster_barrier [[LOADED]]
// IR-NEXT: waveamdmachine.ds_store_b32 {{.*}} after [[READY]]
func.func @cluster_barrier_boundary(
    %address: !waveamdmachine.reg<vgpr, 1>,
    %value: !waveamdmachine.reg<vgpr, 1>,
    %root: !waveamdmachine.mem.token) {
  %loaded, %load = waveamdmachine.ds_load_b32 %address after %root
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %ready = waveamdmachine.cluster_barrier %load
      : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %stored = waveamdmachine.ds_store_b32 %address, %value after %ready
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// NOSPECIALIZE-LABEL: func.func @cluster_barrier_not_specialized(
// NOSPECIALIZE-NOT: waveamdmachine.uniform_if
// NOSPECIALIZE: waveamdmachine.uniform_loop
// NOSPECIALIZE: waveamdmachine.cluster_barrier
// NOSPECIALIZE: return
func.func @cluster_barrier_not_specialized(
    %root: !waveamdmachine.mem.token,
    %cond: !waveamdmachine.reg<scc, 1>)
    attributes {
      gpu.known_block_size = array<i32: 256, 1, 1>,
      wave.kernel,
      wave.workgroup_size = array<i32: 256, 1, 1>,
      waveamdmachine.enable_multi_wave_specialization,
      waveamdmachine.schedule_input,
      waveamdmachine.target_waves = 1 : i64
    } {
  waveamdmachine.uniform_loop {
    %ready = waveamdmachine.cluster_barrier %root
        : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1>
  }
  return
}

}
