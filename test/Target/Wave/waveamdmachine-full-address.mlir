// RUN: wave-opt --waveamd-to-machine %s | FileCheck %s --check-prefix=SELECT
// RUN: wave-opt --wave-simplify-index-exprs --waveamd-to-machine %s | FileCheck %s --check-prefix=SELECT
// RUN: wave-opt --waveamd-to-machine %s | wave-opt | FileCheck %s --check-prefix=SELECT
// RUN: wave-opt --waveamd-to-machine --waveamd-abi-lowering --waveamd-reg-alloc --waveamd-resource-info %s | FileCheck %s --check-prefix=VERIFY
// RUN: wave-opt --waveamd-to-machine %s | wave-translate --wave-to-amdgpu-asm - | FileCheck %s --check-prefix=ASM
// RUN: wave-opt --waveamd-to-machine %s | wave-translate --wave-to-amdgpu-asm - | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// SELECT-LABEL: func.func @global_constant_overflow
// SELECT: waveamdmachine.global_store_b32_addr64
// SELECT-NOT: waveamdmachine.global_store_b32 %
// ASM-LABEL: global_constant_overflow:
// ASM: global_store_b32 v[{{[0-9]+}}:{{[0-9]+}}], v{{[0-9]+}}, off
func.func @global_constant_overflow(%out: !wave.ptr<i32, #wave.global>) attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %off = wave.index_expr <"1073741824 + lid"> ["lid"] (%lane)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %ptrs = wave.ptr_add %out, %off
      : !wave.ptr<i32, #wave.global>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<i32, #wave.global>, 32>
  %tok = wave.store %lane -> %ptrs
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<i32, #wave.global>, 32>)
      -> !wave.mem.token
  return
}

// SELECT-LABEL: func.func @global_raw_constant_overflow
// SELECT: waveamdmachine.s_mov_b64_imm 4294967296
// SELECT: waveamdmachine.global_store_b32_addr64
// ASM-LABEL: global_raw_constant_overflow:
// ASM: global_store_b32 v[{{[0-9]+}}:{{[0-9]+}}], v{{[0-9]+}}, off
func.func @global_raw_constant_overflow(%out: !wave.ptr<i32, #wave.global>) attributes {wave.kernel} {
  %raw = arith.constant 1073741824 : i32
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %ptr = wave.ptr_add %out, %raw
      : !wave.ptr<i32, #wave.global>, i32 -> !wave.ptr<i32, #wave.global>
  %ptrs = wave.ptr_add %ptr, %lane
      : !wave.ptr<i32, #wave.global>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<i32, #wave.global>, 32>
  %tok = wave.store %lane -> %ptrs
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<i32, #wave.global>, 32>)
      -> !wave.mem.token
  return
}

// SELECT-LABEL: func.func @global_raw_unbounded_offset_addr64
// SELECT: waveamdmachine.global_store_b32_addr64
// ASM-LABEL: global_raw_unbounded_offset_addr64:
// ASM: global_store_b32 v[{{[0-9]+}}:{{[0-9]+}}], v{{[0-9]+}}, off
func.func @global_raw_unbounded_offset_addr64(%out: !wave.ptr<i32, #wave.global>, %raw: i32) attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %ptr = wave.ptr_add %out, %raw
      : !wave.ptr<i32, #wave.global>, i32 -> !wave.ptr<i32, #wave.global>
  %ptrs = wave.ptr_add %ptr, %lane
      : !wave.ptr<i32, #wave.global>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<i32, #wave.global>, 32>
  %tok = wave.store %lane -> %ptrs
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<i32, #wave.global>, 32>)
      -> !wave.mem.token
  return
}

// SELECT-LABEL: func.func @global_mixed_index_and_raw_ptr_add
// SELECT: %[[RAW_ID:.*]] = waveamdmachine.v_workitem_id_x
// SELECT: %[[RAW:.*]] = waveamdmachine.v_lshlrev_b32 %[[RAW_ID]],
// SELECT: %[[RAW64:.*]] = waveamdmachine.tuple_from_elements %[[RAW]],
// SELECT: %[[ADDR:.*]], %{{.*}} = waveamdmachine.v_add_u64 {{.*}}, %[[RAW64]]
// SELECT: waveamdmachine.global_store_b32_addr64 %[[ADDR]]
// ASM-LABEL: global_mixed_index_and_raw_ptr_add:
// ASM: global_store_b32 v[{{[0-9]+}}:{{[0-9]+}}], v{{[0-9]+}}, off
func.func @global_mixed_index_and_raw_ptr_add(%out: !wave.ptr<i32, #wave.global>) attributes {wave.kernel} {
  %raw_off = wave.workitem_id 0 : !wave.simd<i32, 32>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %raw = wave.ptr_add %out, %raw_off
      : !wave.ptr<i32, #wave.global>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<i32, #wave.global>, 32>
  %off = wave.index_expr <"1073741824 + lid"> ["lid"] (%lane)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %ptrs = wave.ptr_add %raw, %off
      : !wave.simd<!wave.ptr<i32, #wave.global>, 32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<i32, #wave.global>, 32>
  %tok = wave.store %lane -> %ptrs
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<i32, #wave.global>, 32>)
      -> !wave.mem.token
  return
}

// SELECT-LABEL: func.func @global_loop_carry_mixed_addr64
// SELECT: waveamdmachine.uniform_loop
// SELECT: ^bb0(%{{.*}}: !waveamdmachine.reg<sgpr, 1>, %[[CARRY:.*]]: !waveamdmachine.reg<vgpr, 1>, %{{.*}}: !waveamdmachine.reg<sgpr, 2>):
// SELECT: %[[CARRY64:.*]] = waveamdmachine.tuple_from_elements %[[CARRY]],
// SELECT: waveamdmachine.v_add_u64 {{.*}}, %[[CARRY64]]
// SELECT: waveamdmachine.global_store_b32_addr64
// ASM-LABEL: global_loop_carry_mixed_addr64:
// ASM: global_store_b32 v[{{[0-9]+}}:{{[0-9]+}}], v{{[0-9]+}}, off
func.func @global_loop_carry_mixed_addr64(%out: !wave.ptr<i32, #wave.global>) attributes {wave.kernel} {
  %lo = arith.constant 0 : i32
  %hi = arith.constant 1 : i32
  %step = arith.constant 1 : i32
  %stride = arith.constant 16 : i32
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %raw = wave.ptr_add %out, %lane
      : !wave.ptr<i32, #wave.global>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<i32, #wave.global>, 32>
  scf.for %i = %lo to %hi step %step iter_args(%q = %raw)
      -> (!wave.simd<!wave.ptr<i32, #wave.global>, 32>) : i32 {
    %off = wave.index_expr <"1073741824 + lid"> ["lid"] (%lane)
        : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
    %ptrs = wave.ptr_add %q, %off
        : !wave.simd<!wave.ptr<i32, #wave.global>, 32>, !wave.simd<index, 32>
        -> !wave.simd<!wave.ptr<i32, #wave.global>, 32>
    %tok = wave.store %lane -> %ptrs
        : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<i32, #wave.global>, 32>)
        -> !wave.mem.token
    %next = wave.ptr_add %q, %stride
        : !wave.simd<!wave.ptr<i32, #wave.global>, 32>, i32
        -> !wave.simd<!wave.ptr<i32, #wave.global>, 32>
    scf.yield %next : !wave.simd<!wave.ptr<i32, #wave.global>, 32>
  }
  return
}

// SELECT-LABEL: func.func @global_addr64_two_uniform_products
// SELECT: %[[WGX:.*]] = waveamdmachine.s_workgroup_id_x
// SELECT: %[[WGY:.*]] = waveamdmachine.s_workgroup_id_y
// SELECT: waveamdmachine.s_mov_b64_imm 4294967296
// SELECT: waveamdmachine.v_mul_u64
// SELECT: waveamdmachine.s_mov_b64_imm 8589934592
// SELECT: waveamdmachine.v_mul_u64
// SELECT-NOT: waveamdmachine.s_mul_u64
// SELECT: waveamdmachine.global_store_b32_addr64
// VERIFY-LABEL: func.func @global_addr64_two_uniform_products
// VERIFY: waveamdmachine.global_store_b32_addr64
// ASM-LABEL: global_addr64_two_uniform_products:
// ASM: global_store_b32 v[{{[0-9]+}}:{{[0-9]+}}], v{{[0-9]+}}, off
func.func @global_addr64_two_uniform_products(%out: !wave.ptr<i32, #wave.global>) attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %wgid_x = wave.workgroup_id 0
  %wgid_y = wave.workgroup_id 1
  %off = wave.index_expr <"lid + 1073741824*wgx + 2147483648*wgy">
      ["lid", "wgx", "wgy"] (%lane, %wgid_x, %wgid_y)
      : (!wave.simd<i32, 32>, i32, i32) -> !wave.simd<index, 32>
  %ptrs = wave.ptr_add %out, %off
      : !wave.ptr<i32, #wave.global>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<i32, #wave.global>, 32>
  %tok = wave.store %lane -> %ptrs
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<i32, #wave.global>, 32>)
      -> !wave.mem.token
  return
}

// SELECT-LABEL: func.func @global_load_constant_overflow
// SELECT: waveamdmachine.global_load_b32_addr64
// ASM-LABEL: global_load_constant_overflow:
// ASM: global_load_b32 v{{[0-9]+}}, v[{{[0-9]+}}:{{[0-9]+}}], off
func.func @global_load_constant_overflow(%out: !wave.ptr<i32, #wave.global>) attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %off = wave.index_expr <"1073741824 + lid"> ["lid"] (%lane)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %ptrs = wave.ptr_add %out, %off
      : !wave.ptr<i32, #wave.global>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<i32, #wave.global>, 32>
  %value, %load_token = wave.load %ptrs
      : (!wave.simd<!wave.ptr<i32, #wave.global>, 32>)
      -> (!wave.simd<i32, 32>, !wave.mem.token)
  %tok = wave.store %value -> %ptrs after %load_token
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<i32, #wave.global>, 32>, !wave.mem.token)
      -> !wave.mem.token
  return
}

}
