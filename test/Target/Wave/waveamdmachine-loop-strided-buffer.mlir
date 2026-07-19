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

// CHECK-LABEL: func.func @strided_dma_buf
// CHECK: %[[LOOP:.*]]:3 = waveamdmachine.uniform_loop
// CHECK: ^bb0(%{{.*}}: !waveamdmachine.reg<sgpr, 1>, %{{.*}}: !waveamdmachine.reg<vgpr, 1>, %[[BASE:.*]]: !waveamdmachine.reg<sgpr, 2>):
// CHECK: %[[DESC:.*]] = waveamdmachine.update_buffer_rsrc_base {{%.*}}, %[[BASE]]
// CHECK: %[[ISSUE:.*]] = waveamdmachine.buffer_load_lds_b128 {{%.*}}, %[[DESC]],
// CHECK: %[[RETAINED:.*]] = waveamdmachine.reg_after %[[BASE]] after %[[ISSUE]]
// CHECK: %[[NEXT:.*]], %{{.*}} = waveamdmachine.s_add_u64_u32 %[[RETAINED]],
// CHECK: waveamdmachine.continue_if
// CHECK-SAME: %[[NEXT]]
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @strided_dma_buf(%a: !wave.ptr<#wave.global, i32>, %n: i32,
                           %r: i32)
    attributes {wave.kernel, wave.lds_size = 512 : i64} {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %c4 = arith.constant 4 : i32
  %n_bounded = wave.assume %n as "x"
      [#wave.pred<"x >= 0">, #wave.pred<"x <= 1023">] : i32
  %buf = waveamd.make_buffer %a, %r
      : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %wi_raw = wave.workitem_id 0 : !wave.simd<i32, 64>
  %wi = wave.assume %wi_raw as "w"
      [#wave.pred<"w >= 0">, #wave.pred<"w <= 63">]
      : !wave.simd<i32, 64>
  %p0 = wave.ptr_add %buf, %wi
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
  %lds = wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
  scf.for %i = %c0 to %n_bounded step %c1 iter_args(%q = %p0)
      -> (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>) : i32 {
    %root = wave.token : !wave.mem.token
    %issue = waveamd.dma_load_lds %q -> %lds after %root {bytes = 16 : i64}
        : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
           !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %next = wave.ptr_add %q, %c4
        : !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>, i32
        -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
    scf.yield %next : !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
  }
  return
}
}

// CHECK-LABEL: func.func @nonzero_lower_strided_buf
// CHECK: uniform_loop
// CHECK: buffer_load_tuple_b32
// CHECK: waveamdmachine.v_add_u32
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @nonzero_lower_strided_buf(%a: !wave.ptr<#wave.global, f16>,
                                     %r: i32) attributes {wave.kernel} {
  %c1 = arith.constant 1 : i32
  %c4 = arith.constant 4 : i32
  %c16 = arith.constant 16 : i32
  %buf = waveamd.make_buffer %a, %r
      : !wave.ptr<#wave.global, f16>, i32 -> !wave.ptr<#waveamd.buffer, f16>
  %wi = wave.workitem_id 0 : !wave.simd<i32, 32>
  %off = wave.index_expr <"64*Mod(wi, 16)"> ["wi"](%wi)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %p0 = wave.ptr_add %buf, %off
      : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 32>
  scf.for %i = %c1 to %c4 step %c1 iter_args(%q = %p0)
      -> (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 32>) : i32 {
    %v, %t = wave.load %q : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 32>)
        -> (!wave.simd<vector<8xi32>, 32>, !wave.mem.token)
    wave.store %v -> %q
        : (!wave.simd<vector<8xi32>, 32>,
           !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 32>) -> !wave.mem.token
    %nq = wave.ptr_add %q, %c16
        : !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 32>, i32
        -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 32>
    scf.yield %nq : !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 32>
  }
  return
}
}

// CHECK-LABEL: func.func @strided_buf_i64_bound
// CHECK: waveamdmachine.uniform_loop
// CHECK-SAME: carries(%{{.+}} : !waveamdmachine.reg<sgpr, 1>
// CHECK: ^bb0(%[[IV:.+]]: !waveamdmachine.reg<sgpr, 1>
// CHECK: %[[SO:.+]], %{{.+}} = waveamdmachine.s_lshl_b32 %[[IV]],
// CHECK: buffer_load_tuple_b32 %{{.+}}, %{{.+}}, %[[SO]]
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @strided_buf_i64_bound(%a: !wave.ptr<#wave.global, f16>, %n: i64,
                                 %r: i32) attributes {wave.kernel} {
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  %c16 = arith.constant 16 : i32
  %n_bounded = wave.assume %n as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 1023">] : i64
  %ub = wave.index_expr <"x"> ["x"](%n_bounded) : (i64) -> index
  %buf = waveamd.make_buffer %a, %r
      : !wave.ptr<#wave.global, f16>, i32 -> !wave.ptr<#waveamd.buffer, f16>
  %wi = wave.workitem_id 0 : !wave.simd<i32, 32>
  %off = wave.index_expr <"64*Mod(wi, 16)"> ["wi"](%wi)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %p0 = wave.ptr_add %buf, %off
      : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 32>
  scf.for %i = %c0 to %ub step %c1 iter_args(%q = %p0)
      -> (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 32>) {
    %v, %t = wave.load %q : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 32>)
        -> (!wave.simd<vector<8xi32>, 32>, !wave.mem.token)
    wave.store %v -> %q
        : (!wave.simd<vector<8xi32>, 32>,
           !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 32>) -> !wave.mem.token
    %nq = wave.ptr_add %q, %c16
        : !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 32>, i32
        -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 32>
    scf.yield %nq : !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 32>
  }
  return
}
}
