// RUN: wave-opt --waveamd-to-machine %s | FileCheck %s --check-prefix=SELECT
// RUN: wave-opt --waveamd-to-machine %s | wave-opt | FileCheck %s --check-prefix=SELECT
// RUN: wave-opt --waveamd-to-machine --waveamd-abi-lowering --waveamd-insert-ticket-waits %s | FileCheck %s --check-prefix=TICKET
// RUN: wave-opt --waveamd-to-machine --waveamd-machine-schedule='apply-schedule=true require-selected-input=true' --waveamd-prepare-regalloc %s | FileCheck %s --check-prefix=REGALLOC

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// SELECT-LABEL: func.func @token_kernel
// SELECT: waveamdmachine.global_store_b32{{.*}} : {{.*}} -> !waveamdmachine.mem.token
// SELECT: waveamdmachine.after{{.*}} : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
// SELECT: waveamdmachine.global_store_b32{{.*}} after {{.*}} : {{.*}} !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
// SELECT: waveamdmachine.s_barrier{{.*}} : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token

// TICKET-LABEL: func.func @token_kernel
// TICKET: waveamdmachine.global_store_b32{{.*}} : {{.*}} -> !waveamdmachine.mem.token
// TICKET: waveamdmachine.s_waitcnt_vscnt
// TICKET-NEXT: waveamdmachine.global_store_b32{{.*}} after {{.*}} : {{.*}} !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
// TICKET: waveamdmachine.s_waitcnt_vscnt
// TICKET-NEXT: waveamdmachine.s_barrier
// TICKET-NOT: waveamdmachine.s_waitcnt_vscnt
// TICKET: waveamdmachine.s_endpgm
func.func @token_kernel(%out: !wave.ptr<#wave.global, i32>, %x: i32) attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %vx = wave.splat %x : i32 -> !wave.simd<i32, 32>
  %ptrs = wave.ptr_add %out, %lane : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32> -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %t0 = wave.store %vx -> %ptrs : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>) -> !wave.mem.token
  %t1 = wave.after %t0 : !wave.mem.token -> !wave.mem.token
  %t2 = wave.store %vx -> %ptrs after %t1 : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>, !wave.mem.token) -> !wave.mem.token
  %ready = wave.barrier %t2 : (!wave.mem.token) -> !wave.mem.token
  return
}

// SELECT-LABEL: func.func @join_kernel
// SELECT: waveamdmachine.token_join{{.*}} : (!waveamdmachine.mem.token, !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
// SELECT: waveamdmachine.s_barrier

// TICKET-LABEL: func.func @join_kernel
// TICKET: waveamdmachine.global_store_b32
// TICKET: waveamdmachine.global_store_b32
// TICKET: waveamdmachine.token_join
// TICKET: waveamdmachine.s_waitcnt_vscnt
// TICKET-NEXT: waveamdmachine.s_barrier
func.func @join_kernel(%out: !wave.ptr<#wave.global, i32>, %x: i32) attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %vx = wave.splat %x : i32 -> !wave.simd<i32, 32>
  %ptrs = wave.ptr_add %out, %lane : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32> -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %a = wave.store %vx -> %ptrs : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>) -> !wave.mem.token
  %b = wave.store %vx -> %ptrs : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>) -> !wave.mem.token
  %both = wave.join %a, %b : !wave.mem.token, !wave.mem.token -> !wave.mem.token
  %ready = wave.barrier %both : (!wave.mem.token) -> !wave.mem.token
  return
}

// SELECT-LABEL: func.func @schedule_token_kernel
// SELECT: %[[LANE:.*]] = waveamdmachine.v_mbcnt_lo
// SELECT: %[[ORDERED:.*]] = waveamdmachine.schedule_token %[[LANE]] : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.mem.token
// SELECT: waveamdmachine.s_barrier %[[ORDERED]]
// REGALLOC-LABEL: func.func @schedule_token_kernel
// REGALLOC-NOT: waveamdmachine.schedule_token
// REGALLOC-NOT: waveamdmachine.v_mbcnt
// REGALLOC: waveamdmachine.s_barrier
func.func @schedule_token_kernel() attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %ordered = wave.schedule_token %lane : !wave.simd<i32, 32> -> !wave.mem.token
  %ready = wave.barrier %ordered : (!wave.mem.token) -> !wave.mem.token
  return
}

}
