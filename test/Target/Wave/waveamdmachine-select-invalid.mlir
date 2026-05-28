// RUN: wave-opt --waveamd-to-machine -split-input-file -verify-diagnostics %s

func.func @unsupported_op(%x: i32, %y: i32) attributes {wave.kernel} {
  // expected-error @below {{unsupported operation in WaveAMDMachine selection}}
  %sum = arith.addi %x, %y : i32
  return
}

// -----

func.func @unsupported_lane_id_width() {
  // expected-error @below {{WaveAMDMachine backend supports only !wave.simd<i32, 32> lane_id}}
  %lane = wave.lane_id : !wave.simd<i32, 64>
  return
}

// -----

func.func @unsupported_binary_kind(%x: i32) {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %vx = wave.splat %x : i32 -> !wave.simd<i32, 32>
  // expected-error @below {{unsupported wave.binary kind}}
  %bad = wave.binary "subi" %lane, %vx : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  return
}

// -----

func.func @unsupported_packed_f16_fadd(%a: !wave.simd<vector<2xf16>, 32>, %b: !wave.simd<vector<2xf16>, 32>) {
  // expected-error @below {{WaveAMDMachine f32 lowering supports only !wave.simd<f32, W>}}
  %sum = wave.fadd %a, %b : !wave.simd<vector<2xf16>, 32>, !wave.simd<vector<2xf16>, 32> -> !wave.simd<vector<2xf16>, 32>
  return
}

// -----

func.func @kernel_return_value(%x: i32) -> i32 attributes {wave.kernel} {
  // expected-error @below {{kernel functions must return void}}
  return %x : i32
}
