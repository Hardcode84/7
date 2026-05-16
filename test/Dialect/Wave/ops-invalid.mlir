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
