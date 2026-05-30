// RUN: wave-opt %s --wavemeta-specialize --split-input-file --verify-diagnostics

func.func @orphan_residual_op(%c: i1, %a: i32, %b: i32) -> i32 {
  // expected-error@+1 {{static_if condition does not fold to a constant}}
  %r = wavemeta.static_if %c -> (i32) {
    wavemeta.yield %a : i32
  } else {
    wavemeta.yield %b : i32
  }
  return %r : i32
}

// -----

// expected-error@+1 {{function signature retains unresolved parametric tuple type}}
func.func @orphan_ptuple_signature(%t: !wavemeta.ptuple<i32, "n">) {
  return
}
