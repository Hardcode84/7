// RUN: wave-opt --waveamd-to-machine --canonicalize --cse %s | FileCheck %s

// A uniform per-iter pointer advance on a global tile becomes a carried
// scalar base: the K-march rides s_add_u64_u32 on the SGPR2 carry, the
// voffset carry is loop-invariant, and the per-lane v_add disappears.
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @strided_kloop(%a: !wave.ptr<#wave.global, f16>, %n: i32)
    attributes {wave.kernel} {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %c16 = arith.constant 16 : i32
  %c1024 = arith.constant 1024 : i32
  %wi = wave.workitem_id 0 : !wave.simd<i32, 32>
  %off = wave.index_expr <"64*Mod(wi, 16)"> ["wi"](%wi)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %p0 = wave.ptr_add %a, %off : !wave.ptr<#wave.global, f16>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#wave.global, f16>, 32>
  %p1 = wave.ptr_add %p0, %c1024 : !wave.simd<!wave.ptr<#wave.global, f16>, 32>, i32
      -> !wave.simd<!wave.ptr<#wave.global, f16>, 32>
  scf.for %i = %c0 to %n step %c1
      iter_args(%q0 = %p0, %q1 = %p1) -> (!wave.simd<!wave.ptr<#wave.global, f16>, 32>,
                                          !wave.simd<!wave.ptr<#wave.global, f16>, 32>) : i32 {
    %v0, %t0 = wave.load %q0 : (!wave.simd<!wave.ptr<#wave.global, f16>, 32>)
        -> (!wave.simd<vector<8xi32>, 32>, !wave.mem.token)
    %v1, %t1 = wave.load %q1 : (!wave.simd<!wave.ptr<#wave.global, f16>, 32>)
        -> (!wave.simd<vector<8xi32>, 32>, !wave.mem.token)
    wave.store %v0 -> %q1 : (!wave.simd<vector<8xi32>, 32>, !wave.simd<!wave.ptr<#wave.global, f16>, 32>) -> !wave.mem.token
    wave.store %v1 -> %q0 : (!wave.simd<vector<8xi32>, 32>, !wave.simd<!wave.ptr<#wave.global, f16>, 32>) -> !wave.mem.token
    %n0 = wave.ptr_add %q0, %c16 : !wave.simd<!wave.ptr<#wave.global, f16>, 32>, i32
        -> !wave.simd<!wave.ptr<#wave.global, f16>, 32>
    %n1 = wave.ptr_add %q1, %c16 : !wave.simd<!wave.ptr<#wave.global, f16>, 32>, i32
        -> !wave.simd<!wave.ptr<#wave.global, f16>, 32>
    scf.yield %n0, %n1 : !wave.simd<!wave.ptr<#wave.global, f16>, 32>,
                         !wave.simd<!wave.ptr<#wave.global, f16>, 32>
  }
  return
}
}

// stride 32B = 16 f16; both tiles share the base carry, so one
// s_add_u64_u32 advances it on the backedge, no v_add in body.
// CHECK-LABEL: func.func @strided_kloop
// CHECK: uniform_loop
// CHECK-SAME: !waveamdmachine.reg<sgpr, 2>
// CHECK: ^bb0(%{{.*}}: !waveamdmachine.reg<sgpr, 1>, %[[V0:.*]]: !waveamdmachine.reg<vgpr, 1>, %[[V1:.*]]: !waveamdmachine.reg<vgpr, 1>, %[[B:.*]]: !waveamdmachine.reg<sgpr, 2>):
// CHECK-NOT: waveamdmachine.s_lshl_b32
// CHECK: global_load_tuple_b32 %[[V0]], %[[B]]
// CHECK: global_load_tuple_b32 %[[V1]], %[[B]]
// CHECK-NOT: waveamdmachine.v_add_u32
// CHECK: %[[RETAINED:.*]] = waveamdmachine.reg_after %[[B]] after
// CHECK: %[[NB:.*]], %{{.*}} = waveamdmachine.s_add_u64_u32 %[[RETAINED]], %{{.*}} : (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.imm)
// CHECK: %[[BC:.*]] = waveamdmachine.s_cmp_lt_i32
// CHECK-NEXT: waveamdmachine.continue_if %[[BC]]
// CHECK-SAME: %[[NB]]

// CHECK-LABEL: func.func @strided_two_base_kloop
// CHECK: uniform_loop
// CHECK-SAME: !waveamdmachine.reg<sgpr, 2>, !waveamdmachine.reg<sgpr, 2>
// CHECK: ^bb0(%{{.*}}: !waveamdmachine.reg<sgpr, 1>, %[[AV:.*]]: !waveamdmachine.reg<vgpr, 1>, %[[BV:.*]]: !waveamdmachine.reg<vgpr, 1>, %[[AB:.*]]: !waveamdmachine.reg<sgpr, 2>, %[[BB:.*]]: !waveamdmachine.reg<sgpr, 2>):
// CHECK-NOT: waveamdmachine.s_lshl_b32
// CHECK: global_load_tuple_b32 %[[AV]], %[[AB]]
// CHECK: global_load_tuple_b32 %[[BV]], %[[BB]]
// CHECK: %[[ARETAINED:.*]] = waveamdmachine.reg_after %[[AB]] after
// CHECK: %[[AN:.*]], %{{.*}} = waveamdmachine.s_add_u64_u32 %[[ARETAINED]], %{{.*}} : (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.imm)
// CHECK: %[[BRETAINED:.*]] = waveamdmachine.reg_after %[[BB]] after
// CHECK-NEXT: %[[BN:.*]], %{{.*}} = waveamdmachine.s_add_u64_u32 %[[BRETAINED]], %{{.*}} : (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.imm)
// CHECK: %[[BC2:.*]] = waveamdmachine.s_cmp_lt_i32
// CHECK-NEXT: waveamdmachine.continue_if %[[BC2]]
// CHECK-SAME: %[[AN]]
// CHECK-SAME: %[[BN]]
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @strided_two_base_kloop(%a: !wave.ptr<#wave.global, f16>,
                                  %b: !wave.ptr<#wave.global, f16>,
                                  %n: i32)
    attributes {wave.kernel} {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %c16 = arith.constant 16 : i32
  %wi = wave.workitem_id 0 : !wave.simd<i32, 32>
  %off = wave.index_expr <"64*Mod(wi, 16)"> ["wi"](%wi)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %p0 = wave.ptr_add %a, %off
      : !wave.ptr<#wave.global, f16>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#wave.global, f16>, 32>
  %p1 = wave.ptr_add %b, %off
      : !wave.ptr<#wave.global, f16>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#wave.global, f16>, 32>
  scf.for %i = %c0 to %n step %c1
      iter_args(%q0 = %p0, %q1 = %p1)
      -> (!wave.simd<!wave.ptr<#wave.global, f16>, 32>,
          !wave.simd<!wave.ptr<#wave.global, f16>, 32>) : i32 {
    %v0, %t0 = wave.load %q0
        : (!wave.simd<!wave.ptr<#wave.global, f16>, 32>)
        -> (!wave.simd<vector<8xi32>, 32>, !wave.mem.token)
    %v1, %t1 = wave.load %q1
        : (!wave.simd<!wave.ptr<#wave.global, f16>, 32>)
        -> (!wave.simd<vector<8xi32>, 32>, !wave.mem.token)
    wave.store %v0 -> %q1
        : (!wave.simd<vector<8xi32>, 32>,
           !wave.simd<!wave.ptr<#wave.global, f16>, 32>) -> !wave.mem.token
    wave.store %v1 -> %q0
        : (!wave.simd<vector<8xi32>, 32>,
           !wave.simd<!wave.ptr<#wave.global, f16>, 32>) -> !wave.mem.token
    %n0 = wave.ptr_add %q0, %c16
        : !wave.simd<!wave.ptr<#wave.global, f16>, 32>, i32
        -> !wave.simd<!wave.ptr<#wave.global, f16>, 32>
    %n1 = wave.ptr_add %q1, %c16
        : !wave.simd<!wave.ptr<#wave.global, f16>, 32>, i32
        -> !wave.simd<!wave.ptr<#wave.global, f16>, 32>
    scf.yield %n0, %n1 : !wave.simd<!wave.ptr<#wave.global, f16>, 32>,
                         !wave.simd<!wave.ptr<#wave.global, f16>, 32>
  }
  return
}
}

// CHECK-LABEL: func.func @strided_non_normalized_kloop
// CHECK: uniform_loop
// CHECK-SAME: !waveamdmachine.reg<sgpr, 2>
// CHECK: ^bb0(%{{.*}}: !waveamdmachine.reg<sgpr, 1>, %[[V:.*]]: !waveamdmachine.reg<vgpr, 1>, %[[B:.*]]: !waveamdmachine.reg<sgpr, 2>):
// CHECK-NOT: waveamdmachine.s_lshl_b32
// CHECK: global_load_tuple_b32 %[[V]], %[[B]]
// CHECK-NOT: waveamdmachine.v_add_u32
// CHECK: %[[RETAINED:.*]] = waveamdmachine.reg_after %[[B]] after
// CHECK: %[[NB:.*]], %{{.*}} = waveamdmachine.s_add_u64_u32 %[[RETAINED]], %{{.*}} : (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.imm)
// CHECK: %[[BC:.*]] = waveamdmachine.s_cmp_lt_i32
// CHECK-NEXT: waveamdmachine.continue_if %[[BC]]
// CHECK-SAME: %[[NB]]
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @strided_non_normalized_kloop(%a: !wave.ptr<#wave.global, f16>,
                                        %n: i32)
    attributes {wave.kernel} {
  %c2 = arith.constant 2 : i32
  %c4 = arith.constant 4 : i32
  %c16 = arith.constant 16 : i32
  %wi = wave.workitem_id 0 : !wave.simd<i32, 32>
  %off = wave.index_expr <"64*Mod(wi, 16)"> ["wi"](%wi)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %p0 = wave.ptr_add %a, %off
      : !wave.ptr<#wave.global, f16>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#wave.global, f16>, 32>
  scf.for %i = %c4 to %n step %c2 iter_args(%q = %p0)
      -> (!wave.simd<!wave.ptr<#wave.global, f16>, 32>) : i32 {
    %v, %t = wave.load %q
        : (!wave.simd<!wave.ptr<#wave.global, f16>, 32>)
        -> (!wave.simd<vector<8xi32>, 32>, !wave.mem.token)
    wave.store %v -> %q
        : (!wave.simd<vector<8xi32>, 32>,
           !wave.simd<!wave.ptr<#wave.global, f16>, 32>) -> !wave.mem.token
    %nq = wave.ptr_add %q, %c16
        : !wave.simd<!wave.ptr<#wave.global, f16>, 32>, i32
        -> !wave.simd<!wave.ptr<#wave.global, f16>, 32>
    scf.yield %nq : !wave.simd<!wave.ptr<#wave.global, f16>, 32>
  }
  return
}
}

// CHECK-LABEL: func.func @strided_dynamic_uniform_kloop
// CHECK: %[[STRIDE:.*]], %{{.*}} = waveamdmachine.s_lshl_b32
// CHECK: %[[LOOP:.*]]:4 = waveamdmachine.uniform_loop
// CHECK: ^bb0(%{{.*}}: !waveamdmachine.reg<sgpr, 1>, %[[V0:.*]]: !waveamdmachine.reg<vgpr, 1>, %[[V1:.*]]: !waveamdmachine.reg<vgpr, 1>, %[[B:.*]]: !waveamdmachine.reg<sgpr, 2>):
// CHECK: global_load_tuple_b32 %[[V0]], %[[B]]
// CHECK: global_load_tuple_b32 %[[V1]], %[[B]]
// CHECK-NOT: waveamdmachine.v_add_u32
// CHECK: %[[RETAINED:.*]] = waveamdmachine.reg_after %[[B]] after
// CHECK: %[[NB:.*]], %{{.*}} = waveamdmachine.s_add_u64_u32 %[[RETAINED]], %[[STRIDE]]
// CHECK: %[[BC:.*]] = waveamdmachine.s_cmp_lt_i32
// CHECK-NEXT: waveamdmachine.continue_if %[[BC]]
// CHECK-SAME: %[[NB]]
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @strided_dynamic_uniform_kloop(%a: !wave.ptr<#wave.global, f16>,
                                         %n: i32, %delta_raw: i32)
    attributes {wave.kernel} {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %c1024 = arith.constant 1024 : i32
  %wi = wave.workitem_id 0 : !wave.simd<i32, 32>
  %off = wave.index_expr <"64*Mod(wi, 16)"> ["wi"](%wi)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %delta = wave.assume %delta_raw as "x" [#wave.pred<"x >= 1">, #wave.pred<"x <= 32">] : i32
  %p0 = wave.ptr_add %a, %off
      : !wave.ptr<#wave.global, f16>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#wave.global, f16>, 32>
  %p1 = wave.ptr_add %p0, %c1024
      : !wave.simd<!wave.ptr<#wave.global, f16>, 32>, i32
      -> !wave.simd<!wave.ptr<#wave.global, f16>, 32>
  scf.for %i = %c0 to %n step %c1 iter_args(%q0 = %p0, %q1 = %p1)
      -> (!wave.simd<!wave.ptr<#wave.global, f16>, 32>,
          !wave.simd<!wave.ptr<#wave.global, f16>, 32>) : i32 {
    %v0, %t0 = wave.load %q0
        : (!wave.simd<!wave.ptr<#wave.global, f16>, 32>)
        -> (!wave.simd<vector<8xi32>, 32>, !wave.mem.token)
    %v1, %t1 = wave.load %q1
        : (!wave.simd<!wave.ptr<#wave.global, f16>, 32>)
        -> (!wave.simd<vector<8xi32>, 32>, !wave.mem.token)
    wave.store %v0 -> %q1
        : (!wave.simd<vector<8xi32>, 32>,
           !wave.simd<!wave.ptr<#wave.global, f16>, 32>) -> !wave.mem.token
    wave.store %v1 -> %q0
        : (!wave.simd<vector<8xi32>, 32>,
           !wave.simd<!wave.ptr<#wave.global, f16>, 32>) -> !wave.mem.token
    %n0 = wave.ptr_add %q0, %delta
        : !wave.simd<!wave.ptr<#wave.global, f16>, 32>, i32
        -> !wave.simd<!wave.ptr<#wave.global, f16>, 32>
    %n1 = wave.ptr_add %q1, %delta
        : !wave.simd<!wave.ptr<#wave.global, f16>, 32>, i32
        -> !wave.simd<!wave.ptr<#wave.global, f16>, 32>
    scf.yield %n0, %n1 : !wave.simd<!wave.ptr<#wave.global, f16>, 32>,
                         !wave.simd<!wave.ptr<#wave.global, f16>, 32>
  }
  return
}
}

// CHECK-LABEL: func.func @strided_factored_uniform_kloop
// CHECK: %[[TWO_X:.*]], %{{.*}} = waveamdmachine.s_lshl_b32
// CHECK: %[[Y_PLUS_Z:.*]], %{{.*}} = waveamdmachine.s_add_i32
// CHECK-NEXT: %[[STRIDE:.*]] = waveamdmachine.s_mul_i32 %[[TWO_X]], %[[Y_PLUS_Z]]
// CHECK: waveamdmachine.uniform_loop
// CHECK: waveamdmachine.s_add_u64_u32 {{.*}}, %[[STRIDE]]
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @strided_factored_uniform_kloop(
    %a: !wave.ptr<#wave.global, f16>, %n: i32, %x_raw: i32, %y_raw: i32,
    %z_raw: i32) attributes {wave.kernel} {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %wi = wave.workitem_id 0 : !wave.simd<i32, 32>
  %off = wave.index_expr <"64*Mod(wi, 16)"> ["wi"](%wi)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %x = wave.assume %x_raw as "x"
      [#wave.pred<"x >= 1">, #wave.pred<"x <= 16">] : i32
  %y = wave.assume %y_raw as "y"
      [#wave.pred<"y >= 1">, #wave.pred<"y <= 16">] : i32
  %z = wave.assume %z_raw as "z"
      [#wave.pred<"z >= 1">, #wave.pred<"z <= 16">] : i32
  %delta = wave.index_expr <"x*(y + z)"> ["x", "y", "z"](%x, %y, %z)
      : (i32, i32, i32) -> index
  %p0 = wave.ptr_add %a, %off
      : !wave.ptr<#wave.global, f16>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#wave.global, f16>, 32>
  scf.for %i = %c0 to %n step %c1 iter_args(%q = %p0)
      -> (!wave.simd<!wave.ptr<#wave.global, f16>, 32>) : i32 {
    %v, %t = wave.load %q
        : (!wave.simd<!wave.ptr<#wave.global, f16>, 32>)
        -> (!wave.simd<vector<8xi32>, 32>, !wave.mem.token)
    wave.store %v -> %q
        : (!wave.simd<vector<8xi32>, 32>,
           !wave.simd<!wave.ptr<#wave.global, f16>, 32>) -> !wave.mem.token
    %nq = wave.ptr_add %q, %delta
        : !wave.simd<!wave.ptr<#wave.global, f16>, 32>, index
        -> !wave.simd<!wave.ptr<#wave.global, f16>, 32>
    scf.yield %nq : !wave.simd<!wave.ptr<#wave.global, f16>, 32>
  }
  return
}
}

// CHECK-LABEL: func.func @strided_live_result
// CHECK: %[[LOOP:.*]]:3 = waveamdmachine.uniform_loop
// CHECK: ^bb0(%{{.*}}: !waveamdmachine.reg<sgpr, 1>, %[[V:.*]]: !waveamdmachine.reg<vgpr, 1>, %[[B:.*]]: !waveamdmachine.reg<sgpr, 2>):
// CHECK: global_load_tuple_b32 %[[V]], %[[B]]
// CHECK: %[[RETAINED:.*]] = waveamdmachine.reg_after %[[B]] after
// CHECK: %[[NB:.*]], %{{.*}} = waveamdmachine.s_add_u64_u32 %[[RETAINED]], %{{.*}} : (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.imm)
// CHECK: %[[BC:.*]] = waveamdmachine.s_cmp_lt_i32
// CHECK-NEXT: waveamdmachine.continue_if %[[BC]]
// CHECK-SAME: %[[NB]]
// CHECK: global_load_tuple_b32 %[[LOOP]]#1, %[[LOOP]]#2
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @strided_live_result(%a: !wave.ptr<#wave.global, f16>, %n: i32)
    attributes {wave.kernel} {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %c16 = arith.constant 16 : i32
  %wi = wave.workitem_id 0 : !wave.simd<i32, 32>
  %off = wave.index_expr <"64*Mod(wi, 16)"> ["wi"](%wi)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %p0 = wave.ptr_add %a, %off
      : !wave.ptr<#wave.global, f16>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#wave.global, f16>, 32>
  %qf = scf.for %i = %c0 to %n step %c1 iter_args(%q = %p0)
      -> (!wave.simd<!wave.ptr<#wave.global, f16>, 32>) : i32 {
    %v, %t = wave.load %q
        : (!wave.simd<!wave.ptr<#wave.global, f16>, 32>)
        -> (!wave.simd<vector<8xi32>, 32>, !wave.mem.token)
    wave.store %v -> %q
        : (!wave.simd<vector<8xi32>, 32>,
           !wave.simd<!wave.ptr<#wave.global, f16>, 32>) -> !wave.mem.token
    %nq = wave.ptr_add %q, %c16
        : !wave.simd<!wave.ptr<#wave.global, f16>, 32>, i32
        -> !wave.simd<!wave.ptr<#wave.global, f16>, 32>
    scf.yield %nq : !wave.simd<!wave.ptr<#wave.global, f16>, 32>
  }
  %vf, %tf = wave.load %qf
      : (!wave.simd<!wave.ptr<#wave.global, f16>, 32>)
      -> (!wave.simd<vector<8xi32>, 32>, !wave.mem.token)
  wave.store %vf -> %qf
      : (!wave.simd<vector<8xi32>, 32>,
         !wave.simd<!wave.ptr<#wave.global, f16>, 32>) -> !wave.mem.token
  return
}
}

// CHECK-LABEL: func.func @buffer_non_normalized_accumulating_carry
// CHECK: waveamdmachine.uniform_loop
// CHECK: waveamdmachine.buffer_load_b32
// CHECK: waveamdmachine.continue_if
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @buffer_non_normalized_accumulating_carry(
    %out: !wave.ptr<#wave.global, i32>) attributes {wave.kernel} {
  %c2 = arith.constant 2 : i32
  %c4 = arith.constant 4 : i32
  %c10 = arith.constant 10 : i32
  %range = arith.constant 4096 : i32
  %buffer = waveamd.make_buffer %out, %range
      : !wave.ptr<#wave.global, i32>, i32
      -> !wave.ptr<#waveamd.buffer, i32>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %initial = wave.ptr_add %buffer, %lane
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
  scf.for %i = %c2 to %c10 step %c2 iter_args(%ptr = %initial)
      -> (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>) : i32 {
    %value, %token = wave.load %ptr
        : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>)
        -> (!wave.simd<i32, 32>, !wave.mem.token)
    wave.store %value -> %ptr
        : (!wave.simd<i32, 32>,
           !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>) -> !wave.mem.token
    %next = wave.ptr_add %ptr, %c4
        : !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>, i32
        -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
    scf.yield %next : !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
  }
  return
}
}
