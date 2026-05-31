// RUN: wave-opt --waveamd-to-machine %s | FileCheck %s
// RUN: wave-opt --waveamd-to-machine %s | wave-opt | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @i8_pair_uses_b16
// CHECK: waveamdmachine.global_load_b16
// CHECK: waveamdmachine.global_store_b16
func.func @i8_pair_uses_b16(%in: !wave.ptr<i8, #wave.global>,
                            %out: !wave.ptr<i8, #wave.global>)
    attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %ip = wave.ptr_add %in, %lane
      : !wave.ptr<i8, #wave.global>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<i8, #wave.global>, 32>
  %op = wave.ptr_add %out, %lane
      : !wave.ptr<i8, #wave.global>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<i8, #wave.global>, 32>
  %v, %tok = wave.load %ip
      : (!wave.simd<!wave.ptr<i8, #wave.global>, 32>)
      -> (!wave.simd<vector<2xi8>, 32>, !wave.mem.token)
  %st = wave.store %v -> %op after %tok
      : (!wave.simd<vector<2xi8>, 32>,
         !wave.simd<!wave.ptr<i8, #wave.global>, 32>, !wave.mem.token)
      -> !wave.mem.token
  return
}

// CHECK-LABEL: func.func @i8_quad_pack_extract_uses_b32
// CHECK: waveamdmachine.global_load_b32
// CHECK: waveamdmachine.v_lshrrev_b32
// CHECK: waveamdmachine.v_lshlrev_b32
// CHECK: waveamdmachine.global_store_b32
func.func @i8_quad_pack_extract_uses_b32(%in: !wave.ptr<i8, #wave.global>,
                                         %out: !wave.ptr<i8, #wave.global>)
    attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %ip = wave.ptr_add %in, %lane
      : !wave.ptr<i8, #wave.global>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<i8, #wave.global>, 32>
  %op = wave.ptr_add %out, %lane
      : !wave.ptr<i8, #wave.global>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<i8, #wave.global>, 32>
  %v, %tok = wave.load %ip
      : (!wave.simd<!wave.ptr<i8, #wave.global>, 32>)
      -> (!wave.simd<vector<4xi8>, 32>, !wave.mem.token)
  %e0 = wave.extract %v[0]
      : !wave.simd<vector<4xi8>, 32> -> !wave.simd<i8, 32>
  %e1 = wave.extract %v[1]
      : !wave.simd<vector<4xi8>, 32> -> !wave.simd<i8, 32>
  %e2 = wave.extract %v[2]
      : !wave.simd<vector<4xi8>, 32> -> !wave.simd<i8, 32>
  %e3 = wave.extract %v[3]
      : !wave.simd<vector<4xi8>, 32> -> !wave.simd<i8, 32>
  %packed = wave.pack %e0, %e1, %e2, %e3
      : !wave.simd<i8, 32>, !wave.simd<i8, 32>, !wave.simd<i8, 32>,
        !wave.simd<i8, 32> -> !wave.simd<vector<4xi8>, 32>
  %st = wave.store %packed -> %op after %tok
      : (!wave.simd<vector<4xi8>, 32>,
         !wave.simd<!wave.ptr<i8, #wave.global>, 32>, !wave.mem.token)
      -> !wave.mem.token
  return
}

// CHECK-LABEL: func.func @i16_quad_uses_tuple
// CHECK: waveamdmachine.global_load_tuple_b32
// CHECK: waveamdmachine.global_store_tuple_b32
func.func @i16_quad_uses_tuple(%in: !wave.ptr<i16, #wave.global>,
                               %out: !wave.ptr<i16, #wave.global>)
    attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %ip = wave.ptr_add %in, %lane
      : !wave.ptr<i16, #wave.global>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<i16, #wave.global>, 32>
  %op = wave.ptr_add %out, %lane
      : !wave.ptr<i16, #wave.global>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<i16, #wave.global>, 32>
  %v, %tok = wave.load %ip
      : (!wave.simd<!wave.ptr<i16, #wave.global>, 32>)
      -> (!wave.simd<vector<4xi16>, 32>, !wave.mem.token)
  %st = wave.store %v -> %op after %tok
      : (!wave.simd<vector<4xi16>, 32>,
         !wave.simd<!wave.ptr<i16, #wave.global>, 32>, !wave.mem.token)
      -> !wave.mem.token
  return
}

// CHECK-LABEL: func.func @bf16_pair_uses_b32
// CHECK: waveamdmachine.global_load_b32
// CHECK: waveamdmachine.global_store_b32
func.func @bf16_pair_uses_b32(%in: !wave.ptr<bf16, #wave.global>,
                              %out: !wave.ptr<bf16, #wave.global>)
    attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %ip = wave.ptr_add %in, %lane
      : !wave.ptr<bf16, #wave.global>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<bf16, #wave.global>, 32>
  %op = wave.ptr_add %out, %lane
      : !wave.ptr<bf16, #wave.global>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<bf16, #wave.global>, 32>
  %v, %tok = wave.load %ip
      : (!wave.simd<!wave.ptr<bf16, #wave.global>, 32>)
      -> (!wave.simd<vector<2xbf16>, 32>, !wave.mem.token)
  %st = wave.store %v -> %op after %tok
      : (!wave.simd<vector<2xbf16>, 32>,
         !wave.simd<!wave.ptr<bf16, #wave.global>, 32>, !wave.mem.token)
      -> !wave.mem.token
  return
}

// CHECK-LABEL: func.func @f32_pair_uses_tuple
// CHECK: waveamdmachine.global_load_tuple_b32
// CHECK: waveamdmachine.global_store_tuple_b32
func.func @f32_pair_uses_tuple(%in: !wave.ptr<f32, #wave.global>,
                               %out: !wave.ptr<f32, #wave.global>)
    attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %ip = wave.ptr_add %in, %lane
      : !wave.ptr<f32, #wave.global>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<f32, #wave.global>, 32>
  %op = wave.ptr_add %out, %lane
      : !wave.ptr<f32, #wave.global>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<f32, #wave.global>, 32>
  %v, %tok = wave.load %ip
      : (!wave.simd<!wave.ptr<f32, #wave.global>, 32>)
      -> (!wave.simd<vector<2xf32>, 32>, !wave.mem.token)
  %st = wave.store %v -> %op after %tok
      : (!wave.simd<vector<2xf32>, 32>,
         !wave.simd<!wave.ptr<f32, #wave.global>, 32>, !wave.mem.token)
      -> !wave.mem.token
  return
}

}
