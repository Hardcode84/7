// RUN: wave-opt --waveamd-to-machine --canonicalize --cse %s | FileCheck %s
// RUN: wave-opt --waveamd-to-machine --canonicalize --cse --waveamd-abi-lowering --waveamd-reg-alloc --waveamd-insert-hazard-waits --waveamd-resource-info --waveamd-metadata %s | FileCheck %s --check-prefix=PIPE

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// The SIMD pointer result type comes from the lane binding, but IRA
// proves `floor(lid / 32) == 0`; the carried offset stays SGPR-side.
// CHECK-LABEL: func.func @uniform_buffer_pointer_carry
// CHECK: %[[WG:.*]] = waveamdmachine.s_workgroup_id_x
// CHECK: %[[SO:[^,]+]], %{{.*}} = waveamdmachine.s_lshl_b32 %[[WG]],
// CHECK: %[[LOOP:.*]]:2 = waveamdmachine.uniform_loop {{.*}} carries(%{{.*}}, %[[SO]] : !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
// CHECK: ^bb0(%{{.*}}: !waveamdmachine.reg<sgpr, 1>, %[[CARRY:.*]]: !waveamdmachine.reg<sgpr, 1>):
// CHECK: waveamdmachine.buffer_store_b32 %{{.*}}, %{{.*}}, %{{.*}}, %[[CARRY]]
// CHECK: %[[NEXT:[^,]+]], %{{.*}} = waveamdmachine.s_add_i32 %[[CARRY]],
// CHECK: waveamdmachine.continue_if {{.*}} carries(%{{.*}}, %[[NEXT]] : !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
// CHECK: waveamdmachine.buffer_store_b32 %{{.*}}, %{{.*}}, %{{.*}}, %[[LOOP]]#1
// CHECK-NOT: waveamdmachine.v_add_u32
//
// PIPE-LABEL: func.func @uniform_buffer_pointer_carry
// PIPE: waveamdmachine.uniform_loop
// PIPE: waveamdmachine.buffer_store_b32
func.func @uniform_buffer_pointer_carry(%a: !wave.ptr<i32, #wave.global>,
                                        %n: i32, %range: i32, %x: i32)
    attributes {wave.kernel} {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %n_bounded = wave.assume_range %n, [0, 1023] : i32
  %buf = waveamd.make_buffer %a, %range
      : !wave.ptr<i32, #wave.global>, i32 -> !wave.ptr<i32, #waveamd.buffer>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %wg_raw = wave.workgroup_id 0
  %wg = wave.assume_range %wg_raw, [0, 1023] : i32
  %vx = wave.splat %x : i32 -> !wave.simd<i32, 32>
  %off = wave.index_expr <"floor(1/32*lid) + wg"> ["lid", "wg"] (%lane, %wg)
      : (!wave.simd<i32, 32>, i32) -> !wave.index<32>
  %p0 = wave.ptr_add %buf, %off
      : !wave.ptr<i32, #waveamd.buffer>, !wave.index<32>
      -> !wave.simd<!wave.ptr<i32, #waveamd.buffer>, 32>
  %res = scf.for %i = %c0 to %n_bounded step %c1 iter_args(%q = %p0)
      -> (!wave.simd<!wave.ptr<i32, #waveamd.buffer>, 32>) : i32 {
    %tok = wave.store %vx -> %q
        : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<i32, #waveamd.buffer>, 32>)
        -> !wave.mem.token
    %nq = wave.ptr_add %q, %c1
        : !wave.simd<!wave.ptr<i32, #waveamd.buffer>, 32>, i32
        -> !wave.simd<!wave.ptr<i32, #waveamd.buffer>, 32>
    scf.yield %nq : !wave.simd<!wave.ptr<i32, #waveamd.buffer>, 32>
  }
  %tok2 = wave.store %vx -> %res
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<i32, #waveamd.buffer>, 32>)
      -> !wave.mem.token
  return
}

}
