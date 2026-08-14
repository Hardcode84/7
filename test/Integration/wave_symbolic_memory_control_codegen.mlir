// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s
// RUN: wave-translate --wave-to-amdgpu-asm %s \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null
// RUN: wave-opt --wave-generate-index-exprs --wave-lower-symbolic-memory %s \
// RUN:   | FileCheck %s --check-prefix=LOWER

// CHECK-LABEL: symbolic_memory_control_codegen:
// CHECK: buffer_load_dwordx2
// CHECK: buffer_store_dwordx2
// CHECK: s_endpgm

// LOWER-LABEL: func.func @symbolic_memory_control_codegen
// LOWER: [[ACTIVE:%.*]] = wave.cmpi
// LOWER-NOT: wave.ptr_cast
// LOWER-NOT: wave.ptr_add
// LOWER: wave.where [[ACTIVE]]
// LOWER: [[SRC_BASE:%.*]] = wave.ptr_cast
// LOWER: [[SRC_OFFSET:%.*]] = wave.index_expr
// LOWER: [[SRC_PTR:%.*]] = wave.ptr_add [[SRC_BASE]], [[SRC_OFFSET]]
// LOWER: wave.load [[SRC_PTR]]
// LOWER: [[DST_BASE:%.*]] = wave.ptr_cast
// LOWER: [[DST_OFFSET:%.*]] = wave.index_expr
// LOWER: [[DST_PTR:%.*]] = wave.ptr_add [[DST_BASE]], [[DST_OFFSET]]
// LOWER: wave.store {{.*}} -> [[DST_PTR]]

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @symbolic_memory_control_codegen(
    %src: !wave.ptr<#wave.global, i32>,
    %dst: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel,
                wave.workgroup_size = array<i32: 64, 1, 1>,
                wave.waves_per_workgroup = 1 : i64} {
  %lane = wave.lane_id : !wave.simd<i32, 64>
  %zero = wave.constant 0 : i32 -> !wave.simd<i32, 64>
  %active = wave.cmpi ugt %lane, %zero
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  wave.where %active {
    %value, %read = wave.gather %src mapping
        <bit_offset = <"32 * (2 * Mod(d, 2*d) + slot)">>
        bindings ["d"](%lane)
        : (!wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>)
        -> (!wave.simd<vector<2xi32>, 64>, !wave.mem.token)
    %written = wave.scatter %value to %dst mapping
        <bit_offset = <"32 * (2 * Mod(d, 2*d) + slot)">>
        bindings ["d"](%lane) after %read
        : (!wave.simd<vector<2xi32>, 64>, !wave.ptr<#wave.global, i32>,
           !wave.simd<i32, 64>, !wave.mem.token)
        -> !wave.mem.token
    wave.yield
  } : !wave.mask<64>
  return
}
}
