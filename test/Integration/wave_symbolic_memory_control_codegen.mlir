// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s
// RUN: wave-translate --wave-to-amdgpu-asm %s \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

// CHECK-LABEL: symbolic_memory_control_codegen:
// CHECK: buffer_load_dwordx2
// CHECK: buffer_store_dwordx2
// CHECK: s_endpgm

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @symbolic_memory_control_codegen(
    %src: !wave.ptr<#wave.global, i32>,
    %dst: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel,
                wave.workgroup_size = array<i32: 64, 1, 1>,
                wave.waves_per_workgroup = 1 : i64} {
  %lane = wave.lane_id : !wave.simd<i32, 64>
  %limit = wave.constant 16 : i32 -> !wave.simd<i32, 64>
  %active = wave.cmpi ult %lane, %limit
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  wave.where %active {
    %value, %read = wave.gather %src mapping
        <bit_offset = <"Piecewise((32 * (2 * x + slot), x < 16))">>
        bindings ["x"](%lane) packet_bindings []()
        : (!wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>)
        -> (!wave.simd<vector<2xi32>, 64>, !wave.mem.token)
    %written = wave.scatter %value to %dst mapping
        <bit_offset = <"Piecewise((32 * (2 * x + slot), x < 16))">>
        bindings ["x"](%lane) packet_bindings []() after %read
        : (!wave.simd<vector<2xi32>, 64>, !wave.ptr<#wave.global, i32>,
           !wave.simd<i32, 64>, !wave.mem.token)
        -> !wave.mem.token
    wave.yield
  } : !wave.mask<64>
  return
}
}
