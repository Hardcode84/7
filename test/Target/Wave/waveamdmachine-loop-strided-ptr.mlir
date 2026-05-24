// RUN: wave-opt --waveamd-to-machine --canonicalize --cse %s | FileCheck %s

// A uniform per-iter pointer advance on a global tile becomes an
// IV-derived scalar base recompute: the K-march rides s_add_u64_u32 on
// the base, the voffset carry is loop-invariant, and the per-lane
// v_add disappears. Two tiles share one base -> cse folds one shift.
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @strided_kloop(%a: !wave.ptr<f16, #wave.global>, %n: i32)
    attributes {wave.kernel} {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %c16 = arith.constant 16 : i32
  %c1024 = arith.constant 1024 : i32
  %wi = wave.workitem_id 0 : !wave.simd<i32, 32>
  %off = wave.index_expr <"64*Mod(wi, 16)"> ["wi"](%wi)
      : (!wave.simd<i32, 32>) -> !wave.index<32>
  %p0 = wave.ptr_add %a, %off : !wave.ptr<f16, #wave.global>, !wave.index<32>
      -> !wave.simd<!wave.ptr<f16, #wave.global>, 32>
  %p1 = wave.ptr_add %p0, %c1024 : !wave.simd<!wave.ptr<f16, #wave.global>, 32>, i32
      -> !wave.simd<!wave.ptr<f16, #wave.global>, 32>
  scf.for %i = %c0 to %n step %c1
      iter_args(%q0 = %p0, %q1 = %p1) -> (!wave.simd<!wave.ptr<f16, #wave.global>, 32>,
                                          !wave.simd<!wave.ptr<f16, #wave.global>, 32>) : i32 {
    %v0, %t0 = wave.load %q0 : (!wave.simd<!wave.ptr<f16, #wave.global>, 32>)
        -> (!wave.simd<vector<8xi32>, 32>, !wave.mem.token)
    %v1, %t1 = wave.load %q1 : (!wave.simd<!wave.ptr<f16, #wave.global>, 32>)
        -> (!wave.simd<vector<8xi32>, 32>, !wave.mem.token)
    %n0 = wave.ptr_add %q0, %c16 : !wave.simd<!wave.ptr<f16, #wave.global>, 32>, i32
        -> !wave.simd<!wave.ptr<f16, #wave.global>, 32>
    %n1 = wave.ptr_add %q1, %c16 : !wave.simd<!wave.ptr<f16, #wave.global>, 32>, i32
        -> !wave.simd<!wave.ptr<f16, #wave.global>, 32>
    scf.yield %n0, %n1 : !wave.simd<!wave.ptr<f16, #wave.global>, 32>,
                         !wave.simd<!wave.ptr<f16, #wave.global>, 32>
  }
  return
}
}

// stride 32B = 16 f16; both tiles share the base, so cse folds the
// recompute to one s_add_u64_u32 feeding both loads, no v_add in body.
// CHECK-LABEL: func.func @strided_kloop
// CHECK: uniform_loop
// CHECK: %[[SH:.+]] = waveamdmachine.s_lshl_b32 %arg{{.+}}, %{{.+}}
// CHECK: %[[B:.+]] = waveamdmachine.s_add_u64_u32 %{{.+}}, %[[SH]]
// CHECK: global_load_tuple_b32 %{{.+}}, %[[B]]
// CHECK: global_load_tuple_b32 %{{.+}}, %[[B]]
// CHECK-NOT: waveamdmachine.v_add_u32
// CHECK: continue_if
