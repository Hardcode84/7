// RUN: wave-opt --waveamd-to-machine --canonicalize --cse %s | FileCheck %s

// Buffer K-loop: the uniform per-iter advance rides soffset (which
// buffer ops have), so the SRD stays fixed and the per-lane voffset
// carry never sees a v_add. One iv<<5 shared as soffset across tiles.
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @strided_buf(%a: !wave.ptr<#wave.global, f16>, %n: i32, %r: i32)
    attributes {wave.kernel} {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %c16 = arith.constant 16 : i32
  %n_bounded = wave.assume %n as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 1023">] : i32
  %buf = waveamd.make_buffer %a, %r : !wave.ptr<#wave.global, f16>, i32 -> !wave.ptr<#waveamd.buffer, f16>
  %wi = wave.workitem_id 0 : !wave.simd<i32, 32>
  %off = wave.index_expr <"64*Mod(wi, 16)"> ["wi"](%wi)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %p0 = wave.ptr_add %buf, %off : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 32>
  scf.for %i = %c0 to %n_bounded step %c1 iter_args(%q = %p0)
      -> (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 32>) : i32 {
    %v, %t = wave.load %q : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 32>)
        -> (!wave.simd<vector<8xi32>, 32>, !wave.mem.token)
    wave.store %v -> %q : (!wave.simd<vector<8xi32>, 32>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 32>) -> !wave.mem.token
    %nq = wave.ptr_add %q, %c16 : !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 32>, i32
        -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 32>
    scf.yield %nq : !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 32>
  }
  return
}
}

// CHECK-LABEL: func.func @strided_buf
// CHECK: uniform_loop
// CHECK: %[[SO:[^,]+]], %{{.*}} = waveamdmachine.s_lshl_b32 %arg{{.+}}, %{{.+}}
// CHECK: buffer_load_tuple_b32 %{{.+}}, %{{.+}}, %[[SO]]
// CHECK-NOT: waveamdmachine.v_add_u32
// CHECK: continue_if
