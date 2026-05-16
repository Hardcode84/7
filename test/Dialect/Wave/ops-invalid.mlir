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
