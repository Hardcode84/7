// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_backend_unscheduled})' | FileCheck %s --check-prefix=UNSCHEDULED
// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_backend})' | FileCheck %s --check-prefix=SCHEDULED

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100", wavemeta.params = {}} {
func.func @load_source_dialects(%p: !wave.ptr<i32, #wave.global>, %range: i32) {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %buf = waveamd.make_buffer %p, %range : !wave.ptr<i32, #wave.global>, i32 -> !wave.ptr<i32, #waveamd.buffer>
  return
}

// UNSCHEDULED-LABEL: func.func @candidate_lower
// UNSCHEDULED: [[TOK:%.*]] = waveamdmachine.token
// UNSCHEDULED-NEXT: [[IND:%.*]] = waveamdmachine.v_add_u32
// UNSCHEDULED-NEXT: [[LOAD:%.*]], [[LOADTOK:%.*]] = waveamdmachine.global_load_b32
// UNSCHEDULED: waveamdmachine.s_waitcnt
// UNSCHEDULED-NEXT: [[DEP:%.*]] = waveamdmachine.v_add_u32 [[LOAD]], [[IND]]
// UNSCHEDULED-NEXT: waveamdmachine.global_store_b32 {{.*}} [[DEP]]
//
// SCHEDULED-LABEL: func.func @candidate_lower
// SCHEDULED: [[TOK:%.*]] = waveamdmachine.token
// SCHEDULED-NEXT: [[LOAD:%.*]], [[LOADTOK:%.*]] = waveamdmachine.global_load_b32
// SCHEDULED-NEXT: [[IND:%.*]] = waveamdmachine.v_add_u32
// SCHEDULED: waveamdmachine.s_waitcnt
// SCHEDULED-NEXT: [[DEP:%.*]] = waveamdmachine.v_add_u32 [[LOAD]], [[IND]]
// SCHEDULED-NEXT: waveamdmachine.global_store_b32 {{.*}} [[DEP]]
func.func @candidate_lower(%off: !waveamdmachine.reg<vgpr, 1>,
                           %base: !waveamdmachine.reg<sgpr, 2>,
                           %a: !waveamdmachine.reg<vgpr, 1>,
                           %b: !waveamdmachine.reg<vgpr, 1>) {
  %tok0 = waveamdmachine.token : !waveamdmachine.mem.token
  %ind = waveamdmachine.v_add_u32 %a, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %loaded, %tok1 = waveamdmachine.global_load_b32 %off, %base after %tok0
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %dep = waveamdmachine.v_add_u32 %loaded, %ind
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  %tok2 = waveamdmachine.global_store_b32 %off, %dep, %base after %tok1
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>, !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  %tok3 = waveamdmachine.global_store_b32 %off, %ind, %base after %tok2
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>, !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  return
}
}
