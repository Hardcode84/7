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

// CHECK-LABEL: func.func @strided_dma_buf_many_carries
// CHECK: waveamdmachine.uniform_loop
// CHECK-COUNT-32: waveamdmachine.buffer_load_lds_b128
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @strided_dma_buf_many_carries(
    %a: !wave.ptr<#wave.global, i32>, %r: i32)
    attributes {wave.kernel, wave.lds_size = 512 : i64} {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %c4 = arith.constant 4 : i32
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
  scf.for %i = %c0 to %c4 step %c1
      iter_args(%q0 = %p0, %q1 = %p0, %q2 = %p0, %q3 = %p0,
                %q4 = %p0, %q5 = %p0, %q6 = %p0, %q7 = %p0,
                %q8 = %p0, %q9 = %p0, %q10 = %p0, %q11 = %p0,
                %q12 = %p0, %q13 = %p0, %q14 = %p0, %q15 = %p0,
                %q16 = %p0, %q17 = %p0, %q18 = %p0, %q19 = %p0,
                %q20 = %p0, %q21 = %p0, %q22 = %p0, %q23 = %p0,
                %q24 = %p0, %q25 = %p0, %q26 = %p0, %q27 = %p0,
                %q28 = %p0, %q29 = %p0, %q30 = %p0, %q31 = %p0)
      -> (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
          !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
          !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
          !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
          !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
          !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
          !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
          !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
          !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
          !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
          !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
          !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
          !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
          !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
          !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
          !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
          !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
          !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
          !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
          !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
          !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
          !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
          !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
          !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
          !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
          !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
          !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
          !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
          !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
          !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
          !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
          !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>) : i32 {
    %nq0 = wave.ptr_add %q0, %c4 : !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>, i32 -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
    %nq1 = wave.ptr_add %q1, %c4 : !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>, i32 -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
    %nq2 = wave.ptr_add %q2, %c4 : !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>, i32 -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
    %nq3 = wave.ptr_add %q3, %c4 : !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>, i32 -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
    %nq4 = wave.ptr_add %q4, %c4 : !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>, i32 -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
    %nq5 = wave.ptr_add %q5, %c4 : !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>, i32 -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
    %nq6 = wave.ptr_add %q6, %c4 : !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>, i32 -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
    %nq7 = wave.ptr_add %q7, %c4 : !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>, i32 -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
    %nq8 = wave.ptr_add %q8, %c4 : !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>, i32 -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
    %nq9 = wave.ptr_add %q9, %c4 : !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>, i32 -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
    %nq10 = wave.ptr_add %q10, %c4 : !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>, i32 -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
    %nq11 = wave.ptr_add %q11, %c4 : !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>, i32 -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
    %nq12 = wave.ptr_add %q12, %c4 : !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>, i32 -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
    %nq13 = wave.ptr_add %q13, %c4 : !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>, i32 -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
    %nq14 = wave.ptr_add %q14, %c4 : !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>, i32 -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
    %nq15 = wave.ptr_add %q15, %c4 : !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>, i32 -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
    %nq16 = wave.ptr_add %q16, %c4 : !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>, i32 -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
    %nq17 = wave.ptr_add %q17, %c4 : !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>, i32 -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
    %nq18 = wave.ptr_add %q18, %c4 : !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>, i32 -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
    %nq19 = wave.ptr_add %q19, %c4 : !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>, i32 -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
    %nq20 = wave.ptr_add %q20, %c4 : !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>, i32 -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
    %nq21 = wave.ptr_add %q21, %c4 : !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>, i32 -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
    %nq22 = wave.ptr_add %q22, %c4 : !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>, i32 -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
    %nq23 = wave.ptr_add %q23, %c4 : !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>, i32 -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
    %nq24 = wave.ptr_add %q24, %c4 : !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>, i32 -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
    %nq25 = wave.ptr_add %q25, %c4 : !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>, i32 -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
    %nq26 = wave.ptr_add %q26, %c4 : !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>, i32 -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
    %nq27 = wave.ptr_add %q27, %c4 : !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>, i32 -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
    %nq28 = wave.ptr_add %q28, %c4 : !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>, i32 -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
    %nq29 = wave.ptr_add %q29, %c4 : !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>, i32 -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
    %nq30 = wave.ptr_add %q30, %c4 : !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>, i32 -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
    %nq31 = wave.ptr_add %q31, %c4 : !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>, i32 -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
    %root = wave.token : !wave.mem.token
    %t0 = waveamd.dma_load_lds %nq0 -> %lds after %root {bytes = 16 : i64}
        : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
           !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %t1 = waveamd.dma_load_lds %nq1 -> %lds after %root {bytes = 16 : i64}
        : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
           !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %t2 = waveamd.dma_load_lds %nq2 -> %lds after %root {bytes = 16 : i64}
        : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
           !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %t3 = waveamd.dma_load_lds %nq3 -> %lds after %root {bytes = 16 : i64}
        : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
           !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %t4 = waveamd.dma_load_lds %nq4 -> %lds after %root {bytes = 16 : i64}
        : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
           !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %t5 = waveamd.dma_load_lds %nq5 -> %lds after %root {bytes = 16 : i64}
        : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
           !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %t6 = waveamd.dma_load_lds %nq6 -> %lds after %root {bytes = 16 : i64}
        : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
           !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %t7 = waveamd.dma_load_lds %nq7 -> %lds after %root {bytes = 16 : i64}
        : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
           !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %t8 = waveamd.dma_load_lds %nq8 -> %lds after %root {bytes = 16 : i64}
        : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
           !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %t9 = waveamd.dma_load_lds %nq9 -> %lds after %root {bytes = 16 : i64}
        : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
           !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %t10 = waveamd.dma_load_lds %nq10 -> %lds after %root {bytes = 16 : i64}
        : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
           !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %t11 = waveamd.dma_load_lds %nq11 -> %lds after %root {bytes = 16 : i64}
        : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
           !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %t12 = waveamd.dma_load_lds %nq12 -> %lds after %root {bytes = 16 : i64}
        : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
           !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %t13 = waveamd.dma_load_lds %nq13 -> %lds after %root {bytes = 16 : i64}
        : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
           !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %t14 = waveamd.dma_load_lds %nq14 -> %lds after %root {bytes = 16 : i64}
        : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
           !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %t15 = waveamd.dma_load_lds %nq15 -> %lds after %root {bytes = 16 : i64}
        : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
           !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %t16 = waveamd.dma_load_lds %nq16 -> %lds after %root {bytes = 16 : i64}
        : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
           !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %t17 = waveamd.dma_load_lds %nq17 -> %lds after %root {bytes = 16 : i64}
        : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
           !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %t18 = waveamd.dma_load_lds %nq18 -> %lds after %root {bytes = 16 : i64}
        : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
           !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %t19 = waveamd.dma_load_lds %nq19 -> %lds after %root {bytes = 16 : i64}
        : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
           !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %t20 = waveamd.dma_load_lds %nq20 -> %lds after %root {bytes = 16 : i64}
        : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
           !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %t21 = waveamd.dma_load_lds %nq21 -> %lds after %root {bytes = 16 : i64}
        : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
           !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %t22 = waveamd.dma_load_lds %nq22 -> %lds after %root {bytes = 16 : i64}
        : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
           !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %t23 = waveamd.dma_load_lds %nq23 -> %lds after %root {bytes = 16 : i64}
        : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
           !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %t24 = waveamd.dma_load_lds %nq24 -> %lds after %root {bytes = 16 : i64}
        : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
           !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %t25 = waveamd.dma_load_lds %nq25 -> %lds after %root {bytes = 16 : i64}
        : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
           !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %t26 = waveamd.dma_load_lds %nq26 -> %lds after %root {bytes = 16 : i64}
        : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
           !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %t27 = waveamd.dma_load_lds %nq27 -> %lds after %root {bytes = 16 : i64}
        : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
           !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %t28 = waveamd.dma_load_lds %nq28 -> %lds after %root {bytes = 16 : i64}
        : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
           !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %t29 = waveamd.dma_load_lds %nq29 -> %lds after %root {bytes = 16 : i64}
        : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
           !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %t30 = waveamd.dma_load_lds %nq30 -> %lds after %root {bytes = 16 : i64}
        : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
           !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %t31 = waveamd.dma_load_lds %nq31 -> %lds after %root {bytes = 16 : i64}
        : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
           !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    scf.yield %nq0, %nq1, %nq2, %nq3, %nq4, %nq5, %nq6, %nq7,
              %nq8, %nq9, %nq10, %nq11, %nq12, %nq13, %nq14, %nq15,
              %nq16, %nq17, %nq18, %nq19, %nq20, %nq21, %nq22, %nq23,
              %nq24, %nq25, %nq26, %nq27, %nq28, %nq29, %nq30, %nq31
        : !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
          !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
          !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
          !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
          !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
          !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
          !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
          !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
          !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
          !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
          !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
          !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
          !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
          !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
          !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
          !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
          !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
          !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
          !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
          !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
          !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
          !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
          !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
          !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
          !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
          !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
          !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
          !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
          !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
          !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
          !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>,
          !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
  }
  return
}
}
