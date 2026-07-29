// RUN: wave-opt %s --split-input-file --waveamd-split-barriers | FileCheck %s

// CHECK-LABEL: func.func @split_barrier(
// CHECK: [[BARRIER:%.*]] = waveamdmachine.barrier_init
// CHECK: [[ROOT:%.*]] = waveamdmachine.token
// CHECK: [[TICKET:%.*]], [[ARRIVE:%.*]] = waveamdmachine.barrier_arrive [[BARRIER]] after [[ROOT]]
// CHECK-SAME: -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
// CHECK-NEXT: [[WAIT:%.*]] = waveamdmachine.barrier_wait [[BARRIER]], [[TICKET]] after [[ARRIVE]]
// CHECK: waveamdmachine.token_join [[WAIT]]
// CHECK-NOT: waveamdmachine.s_barrier
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  func.func @split_barrier()
      attributes {wave.kernel, wave.workgroup_size = array<i32: 512, 1, 1>,
                  wave.waves_per_workgroup = 8 : i64,
                  waveamdmachine.enable_split_barriers} {
    %root = waveamdmachine.token : !waveamdmachine.mem.token
    %ready = waveamdmachine.s_barrier %root
        : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    %joined = waveamdmachine.token_join %ready
        : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    return
  }
}

// -----

// CHECK-LABEL: func.func @split_barrier_no_result(
// CHECK: waveamdmachine.barrier_init
// CHECK: waveamdmachine.barrier_arrive
// CHECK-NEXT: waveamdmachine.barrier_wait
// CHECK-NOT: waveamdmachine.s_barrier
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  func.func @split_barrier_no_result()
      attributes {wave.kernel, wave.workgroup_size = array<i32: 512, 1, 1>,
                  wave.waves_per_workgroup = 8 : i64,
                  waveamdmachine.enable_split_barriers} {
    %root = waveamdmachine.token : !waveamdmachine.mem.token
    waveamdmachine.s_barrier %root : (!waveamdmachine.mem.token) -> ()
    return
  }
}

// -----

// CHECK-LABEL: func.func @split_barrier_multi_result(
// CHECK: [[BARRIER:%.*]] = waveamdmachine.barrier_init
// CHECK: [[LEFT:%.*]] = waveamdmachine.token
// CHECK: [[RIGHT:%.*]] = waveamdmachine.token
// CHECK: [[TICKET:%.*]], [[ARRIVE:%.*]] = waveamdmachine.barrier_arrive [[BARRIER]] after [[LEFT]], [[RIGHT]]
// CHECK-NEXT: [[WAIT:%.*]] = waveamdmachine.barrier_wait [[BARRIER]], [[TICKET]] after [[ARRIVE]]
// CHECK: waveamdmachine.token_join [[WAIT]], [[WAIT]]
// CHECK-NOT: waveamdmachine.s_barrier
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  func.func @split_barrier_multi_result()
      attributes {wave.kernel, wave.workgroup_size = array<i32: 512, 1, 1>,
                  wave.waves_per_workgroup = 8 : i64,
                  waveamdmachine.enable_split_barriers} {
    %left = waveamdmachine.token : !waveamdmachine.mem.token
    %right = waveamdmachine.token : !waveamdmachine.mem.token
    %ready_left, %ready_right = waveamdmachine.s_barrier %left, %right
        : (!waveamdmachine.mem.token, !waveamdmachine.mem.token)
          -> (!waveamdmachine.mem.token, !waveamdmachine.mem.token)
    %joined = waveamdmachine.token_join %ready_left, %ready_right
        : (!waveamdmachine.mem.token, !waveamdmachine.mem.token)
          -> !waveamdmachine.mem.token
    return
  }
}

// -----

// CHECK-LABEL: func.func @split_barrier_3d_workgroup(
// CHECK: waveamdmachine.barrier_init
// CHECK: waveamdmachine.barrier_arrive
// CHECK: waveamdmachine.barrier_wait
// CHECK-NOT: waveamdmachine.s_barrier
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  func.func @split_barrier_3d_workgroup()
      attributes {wave.kernel, wave.workgroup_size = array<i32: 16, 16, 2>,
                  wave.waves_per_workgroup = 8 : i64,
                  waveamdmachine.enable_split_barriers} {
    %root = waveamdmachine.token : !waveamdmachine.mem.token
    %ready = waveamdmachine.s_barrier %root
        : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    return
  }
}

// -----

// CHECK-LABEL: func.func @splits_non_gfx950(
// CHECK: waveamdmachine.barrier_init
// CHECK: waveamdmachine.barrier_arrive
// CHECK: waveamdmachine.barrier_wait
// CHECK-NOT: waveamdmachine.s_barrier
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
  func.func @splits_non_gfx950()
      attributes {wave.kernel, wave.workgroup_size = array<i32: 256, 1, 1>,
                  wave.waves_per_workgroup = 8 : i64,
                  waveamdmachine.enable_split_barriers} {
    %root = waveamdmachine.token : !waveamdmachine.mem.token
    %ready = waveamdmachine.s_barrier %root
        : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    return
  }
}

// -----

// CHECK-LABEL: func.func @splits_gfx1250(
// CHECK: waveamdmachine.barrier_init
// CHECK: waveamdmachine.barrier_arrive
// CHECK: waveamdmachine.barrier_wait
// CHECK-NOT: waveamdmachine.s_barrier
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"} {
  func.func @splits_gfx1250()
      attributes {wave.kernel, wave.workgroup_size = array<i32: 256, 1, 1>,
                  wave.waves_per_workgroup = 8 : i64,
                  waveamdmachine.enable_split_barriers} {
    %root = waveamdmachine.token : !waveamdmachine.mem.token
    %ready = waveamdmachine.s_barrier %root
        : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    return
  }
}

// -----

// CHECK-LABEL: func.func @keeps_four_wave_gfx950(
// CHECK: waveamdmachine.s_barrier
// CHECK-NOT: waveamdmachine.barrier_init
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  func.func @keeps_four_wave_gfx950()
      attributes {wave.kernel, wave.workgroup_size = array<i32: 256, 1, 1>,
                  wave.waves_per_workgroup = 4 : i64,
                  waveamdmachine.enable_split_barriers} {
    %root = waveamdmachine.token : !waveamdmachine.mem.token
    %ready = waveamdmachine.s_barrier %root
        : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    return
  }
}

// -----

// CHECK-LABEL: func.func @keeps_disabled_by_default(
// CHECK: waveamdmachine.s_barrier
// CHECK-NOT: waveamdmachine.barrier_init
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  func.func @keeps_disabled_by_default()
      attributes {wave.kernel, wave.workgroup_size = array<i32: 256, 1, 1>,
                  wave.waves_per_workgroup = 4 : i64} {
    %root = waveamdmachine.token : !waveamdmachine.mem.token
    %ready = waveamdmachine.s_barrier %root
        : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    return
  }
}

// -----

// CHECK-LABEL: func.func @keeps_disabled_on_gfx1250(
// CHECK: waveamdmachine.s_barrier
// CHECK-NOT: waveamdmachine.barrier_init
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"} {
  func.func @keeps_disabled_on_gfx1250()
      attributes {wave.kernel, wave.workgroup_size = array<i32: 256, 1, 1>,
                  wave.waves_per_workgroup = 4 : i64} {
    %root = waveamdmachine.token : !waveamdmachine.mem.token
    %ready = waveamdmachine.s_barrier %root
        : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    return
  }
}

// -----

// CHECK-LABEL: func.func @keeps_unknown_workgroup(
// CHECK: waveamdmachine.s_barrier
// CHECK-NOT: waveamdmachine.barrier_init
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  func.func @keeps_unknown_workgroup()
      attributes {wave.kernel, waveamdmachine.enable_split_barriers} {
    %root = waveamdmachine.token : !waveamdmachine.mem.token
    %ready = waveamdmachine.s_barrier %root
        : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    return
  }
}

// -----

// CHECK-LABEL: func.func @keeps_uniform_if_barrier(
// CHECK: waveamdmachine.uniform_if
// CHECK: waveamdmachine.s_barrier
// CHECK-NOT: waveamdmachine.barrier_init
// CHECK-NOT: waveamdmachine.barrier_arrive
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  func.func @keeps_uniform_if_barrier(
      %cond: !waveamdmachine.reg<scc, 1>)
      attributes {wave.kernel, wave.workgroup_size = array<i32: 512, 1, 1>,
                  wave.waves_per_workgroup = 8 : i64,
                  waveamdmachine.enable_split_barriers} {
    %root = waveamdmachine.token : !waveamdmachine.mem.token
    waveamdmachine.uniform_if %cond {
      %ready = waveamdmachine.s_barrier %root
          : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
      waveamdmachine.yield
    } otherwise {
      waveamdmachine.yield
    } : !waveamdmachine.reg<scc, 1>
    return
  }
}
