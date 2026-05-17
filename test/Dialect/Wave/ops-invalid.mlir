// RUN: wave-opt --split-input-file --verify-diagnostics %s

func.func @bad_workgroup_axis() -> i32 {
  // expected-error @+1 {{axis must be 0 (x), 1 (y), or 2 (z)}}
  %x = wave.workgroup_id 3
  return %x : i32
}

// -----

func.func @bad_workitem_axis() {
  // expected-error @+1 {{axis must be 0 (x), 1 (y), or 2 (z)}}
  %x = wave.workitem_id 4 : !wave.simd<i32, 32>
  return
}

// -----

func.func @bad_workitem_element_type() {
  // expected-error @+1 {{result SIMD element type must be i32}}
  %x = wave.workitem_id 0 : !wave.simd<i64, 32>
  return
}

// -----

func.func @load_bad_ptr_simd_width(%p: !wave.simd<!wave.ptr<i32, #wave.global>, 64>) {
  // expected-error @+1 {{pointer SIMD width must match result SIMD width}}
  %v, %t = wave.load %p : (!wave.simd<!wave.ptr<i32, #wave.global>, 64>) -> (!wave.simd<i32, 32>, !wave.mem.token)
  return
}

// -----

func.func @load_bad_scalar_width(%p: !wave.ptr<i32, #wave.global>) {
  // expected-error @+1 {{scalar result element type must be 32 bits wide for now}}
  %v, %t = wave.load %p : (!wave.ptr<i32, #wave.global>) -> (!wave.simd<i16, 32>, !wave.mem.token)
  return
}

// -----

func.func @load_bad_vector_element(%p: !wave.ptr<i32, #wave.global>) {
  // expected-error @+1 {{vector element type must be 32 bits wide}}
  %v, %t = wave.load %p : (!wave.ptr<i32, #wave.global>) -> (!wave.simd<vector<4xi16>, 32>, !wave.mem.token)
  return
}

// -----

func.func @load_bad_ptr_kind(%p: i64) {
  // expected-error @+1 {{expected wave pointer operand}}
  %v, %t = wave.load %p : (i64) -> (!wave.simd<i32, 32>, !wave.mem.token)
  return
}

// -----

func.func @index_expr_count_mismatch(%lane: !wave.simd<i32, 32>) {
  // expected-error @+1 {{expected one name per binding}}
  %v = wave.index_expr #wave.expr<"lid"> ["lid", "x"] (%lane) : (!wave.simd<i32, 32>) -> !wave.index<32>
  return
}

// -----

func.func @index_expr_unbound_symbol(%lane: !wave.simd<i32, 32>) {
  // expected-error @+1 {{free symbol 'K' has no binding}}
  %v = wave.index_expr #wave.expr<"lid + K"> ["lid"] (%lane) : (!wave.simd<i32, 32>) -> !wave.index<32>
  return
}

// -----

func.func @index_expr_stray_binding(%lane: !wave.simd<i32, 32>, %k: index) {
  // expected-error @+1 {{binding name 'K' is not a free symbol of the expression}}
  %v = wave.index_expr #wave.expr<"lid"> ["lid", "K"] (%lane, %k) : (!wave.simd<i32, 32>, index) -> !wave.index<32>
  return
}

// -----

func.func @index_expr_duplicate_name(%lane: !wave.simd<i32, 32>) {
  // expected-error @+1 {{duplicate binding name 'lid'}}
  %v = wave.index_expr #wave.expr<"lid"> ["lid", "lid"] (%lane, %lane) : (!wave.simd<i32, 32>, !wave.simd<i32, 32>) -> !wave.index<32>
  return
}

// -----

func.func @index_expr_width_mismatch(%lane: !wave.simd<i32, 32>) {
  // expected-error @+1 {{result width 0 disagrees with binding lane width 32}}
  %v = wave.index_expr #wave.expr<"lid"> ["lid"] (%lane) : (!wave.simd<i32, 32>) -> !wave.index
  return
}

// -----

func.func @index_expr_conflicting_widths(%lane32: !wave.simd<i32, 32>, %lane64: !wave.simd<i32, 64>) {
  // expected-error @+1 {{conflicting lane-varying binding widths}}
  %v = wave.index_expr #wave.expr<"a + b"> ["a", "b"] (%lane32, %lane64) : (!wave.simd<i32, 32>, !wave.simd<i32, 64>) -> !wave.index<32>
  return
}
