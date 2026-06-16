// RUN: wave-opt --split-input-file --wave-expand-integer-div-rem --verify-diagnostics %s

func.func @reject_i128_div(%x: i128, %d: i128) -> i128 {
  // expected-error @below {{integer div/rem expansion supports at most 64-bit elements}}
  %q = wave.binary divui %x, %d : i128, i128 -> i128
  return %q : i128
}

// -----

func.func @reject_simd_i128_rem(%x: !wave.simd<i128, 32>, %d: i128)
    -> !wave.simd<i128, 32> {
  // expected-error @below {{integer div/rem expansion supports at most 64-bit elements}}
  %r = wave.binary remsi %x, %d
      : !wave.simd<i128, 32>, i128 -> !wave.simd<i128, 32>
  return %r : !wave.simd<i128, 32>
}
