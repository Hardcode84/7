// RUN: wave-opt %s --wavemeta-specialize='error-on-residual=false' --split-input-file --verify-diagnostics

func.func @orphan_residual_op(%c: i1, %a: i32, %b: i32) -> i32 {
  // expected-error@+1 {{wavemeta-specialize left residual wavemeta operation}}
  %r = wavemeta.static_if %c -> (i32) {
    wavemeta.yield %a : i32
  } else {
    wavemeta.yield %b : i32
  }
  return %r : i32
}

// -----

// expected-error@+1 {{wavemeta-specialize left residual !wavemeta.ptuple type}}
func.func @orphan_ptuple_signature(%t: !wavemeta.ptuple<i32, "n">) {
  return
}
