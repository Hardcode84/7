// RUN: wave-opt --wave-extract-loop-strides --canonicalize --cse --waveamd-to-machine --canonicalize --cse %s | FileCheck %s

// CHECK-LABEL: func.func @cyclic_scalar_offset_carry_constant_init
// CHECK: %[[INIT_IMM:.*]] = waveamdmachine.imm 16384
// CHECK: %[[INIT:.*]] = waveamdmachine.s_mov_b32_value %[[INIT_IMM]]
// CHECK: waveamdmachine.uniform_loop
// CHECK-SAME: carries(%{{.*}}, %[[INIT]] : !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @cyclic_scalar_offset_carry_constant_init(
    %a: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel} {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %c2 = arith.constant 2 : i32
  %c8 = arith.constant 8 : i32
  scf.for %i = %c0 to %c8 step %c1 : i32 {
    %next = wave.binary addi %i, %c2 : i32, i32 -> i32
    %off = wave.index_expr <"8192*Mod(i, 4)"> ["i"](%next)
        : (i32) -> index
    %p = wave.ptr_add %a, %off
        : !wave.ptr<#wave.global, i32>, index -> !wave.ptr<#wave.global, i32>
    %v, %t = wave.load %p
        : (!wave.ptr<#wave.global, i32>)
        -> (!wave.simd<i32, 32>, !wave.mem.token)
    wave.store %v -> %p after %t
        : (!wave.simd<i32, 32>, !wave.ptr<#wave.global, i32>,
           !wave.mem.token) -> !wave.mem.token
  }
  return
}
}

// CHECK-LABEL: func.func @extracted_strided_kloop
// CHECK: %[[LOOP:.*]]:3 = waveamdmachine.uniform_loop
// CHECK: ^bb0(%{{.*}}: !waveamdmachine.reg<sgpr, 1>, %[[VOFF:.*]]: !waveamdmachine.reg<vgpr, 1>, %[[BASE:.*]]: !waveamdmachine.reg<sgpr, 2>):
// CHECK: global_load_tuple_b32 %[[VOFF]], %[[BASE]]
// CHECK-NOT: waveamdmachine.v_add_u32
// CHECK: %[[NEXT:.*]], %{{.*}} = waveamdmachine.s_add_u64_u32 %[[BASE]], %{{.*}} : (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.imm)
// CHECK-NEXT: %[[COND:.*]] = waveamdmachine.s_cmp_lt_i32
// CHECK-NEXT: waveamdmachine.continue_if %[[COND]]
// CHECK-SAME: %[[NEXT]]
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @extracted_strided_kloop(%a: !wave.ptr<#wave.global, f16>, %n: i32)
    attributes {wave.kernel} {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %wi = wave.workitem_id 0 : !wave.simd<i32, 32>
  scf.for %i = %c0 to %n step %c1 : i32 {
    %off = wave.index_expr <"128*i + 64*Mod(wi, 16)"> ["i", "wi"](%i, %wi)
        : (i32, !wave.simd<i32, 32>) -> !wave.simd<index, 32>
    %p = wave.ptr_add %a, %off
        : !wave.ptr<#wave.global, f16>, !wave.simd<index, 32>
        -> !wave.simd<!wave.ptr<#wave.global, f16>, 32>
    %v, %t = wave.load %p
        : (!wave.simd<!wave.ptr<#wave.global, f16>, 32>)
        -> (!wave.simd<vector<8xi32>, 32>, !wave.mem.token)
    wave.store %v -> %p
        : (!wave.simd<vector<8xi32>, 32>,
           !wave.simd<!wave.ptr<#wave.global, f16>, 32>) -> !wave.mem.token
  }
  return
}
}

// CHECK-LABEL: func.func @extracted_scaled_nested_binding
// CHECK: %[[LOOP:.*]]:3 = waveamdmachine.uniform_loop
// CHECK: ^bb0(%{{.*}}: !waveamdmachine.reg<sgpr, 1>, %[[VOFF:.*]]: !waveamdmachine.reg<vgpr, 1>, %[[BASE:.*]]: !waveamdmachine.reg<sgpr, 2>):
// CHECK: global_load_tuple_b32 %[[VOFF]], %[[BASE]]
// CHECK-NOT: waveamdmachine.v_add_u32
// CHECK: %[[NEXT:.*]], %{{.*}} = waveamdmachine.s_add_u64_u32 %[[BASE]], %{{.*}} : (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.imm)
// CHECK-NEXT: %[[COND:.*]] = waveamdmachine.s_cmp_lt_i32
// CHECK-NEXT: waveamdmachine.continue_if %[[COND]]
// CHECK-SAME: %[[NEXT]]
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @extracted_scaled_nested_binding(
    %a: !wave.ptr<#wave.global, f16>, %base_raw: i32, %n: i32)
    attributes {wave.kernel} {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %base = wave.assume %base_raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 31">] : i32
  %wi = wave.workitem_id 0 : !wave.simd<i32, 32>
  scf.for %i = %c0 to %n step %c1 : i32 {
    %sum = wave.index_expr <"base + i"> ["base", "i"](%base, %i)
        : (i32, i32) -> index
    %off = wave.index_expr <"128*x + 64*Mod(wi, 16)"> ["x", "wi"](%sum, %wi)
        : (index, !wave.simd<i32, 32>) -> !wave.simd<index, 32>
    %p = wave.ptr_add %a, %off
        : !wave.ptr<#wave.global, f16>, !wave.simd<index, 32>
        -> !wave.simd<!wave.ptr<#wave.global, f16>, 32>
    %v, %t = wave.load %p
        : (!wave.simd<!wave.ptr<#wave.global, f16>, 32>)
        -> (!wave.simd<vector<8xi32>, 32>, !wave.mem.token)
    wave.store %v -> %p
        : (!wave.simd<vector<8xi32>, 32>,
           !wave.simd<!wave.ptr<#wave.global, f16>, 32>) -> !wave.mem.token
  }
  return
}
}

// CHECK-LABEL: func.func @extracted_nested_symbolic_stride
// CHECK: %[[STRIDE:.*]], %{{.*}} = waveamdmachine.s_lshl_b32
// CHECK: %[[INNER:.*]]:3 = waveamdmachine.uniform_loop
// CHECK: ^bb0(%{{.*}}: !waveamdmachine.reg<sgpr, 1>, %[[VOFF:.*]]: !waveamdmachine.reg<vgpr, 1>, %[[BASE:.*]]: !waveamdmachine.reg<sgpr, 2>):
// CHECK: global_load_tuple_b32 %[[VOFF]], %[[BASE]]
// CHECK-NOT: waveamdmachine.v_add_u32
// CHECK: %[[NEXT:.*]], %{{.*}} = waveamdmachine.s_add_u64_u32 %[[BASE]], %[[STRIDE]]
// CHECK-NEXT: %[[COND:.*]] = waveamdmachine.s_cmp_lt_i32
// CHECK-NEXT: waveamdmachine.continue_if %[[COND]]
// CHECK-SAME: %[[NEXT]]
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @extracted_nested_symbolic_stride(
    %a: !wave.ptr<#wave.global, f16>, %n_raw: i32, %m: i32)
    attributes {wave.kernel} {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %n = wave.assume %n_raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 31">] : i32
  %wi = wave.workitem_id 0 : !wave.simd<i32, 32>
  scf.for %i = %c0 to %n step %c1 : i32 {
    scf.for %j = %c1 to %m step %c1 : i32 {
      %off = wave.index_expr <"16*i*j + 64*Mod(wi, 16)">
          ["i", "j", "wi"](%i, %j, %wi)
          : (i32, i32, !wave.simd<i32, 32>) -> !wave.simd<index, 32>
      %p = wave.ptr_add %a, %off
          : !wave.ptr<#wave.global, f16>, !wave.simd<index, 32>
          -> !wave.simd<!wave.ptr<#wave.global, f16>, 32>
      %v, %t = wave.load %p
          : (!wave.simd<!wave.ptr<#wave.global, f16>, 32>)
          -> (!wave.simd<vector<8xi32>, 32>, !wave.mem.token)
      wave.store %v -> %p
          : (!wave.simd<vector<8xi32>, 32>,
             !wave.simd<!wave.ptr<#wave.global, f16>, 32>) -> !wave.mem.token
    }
  }
  return
}
}

// CHECK-LABEL: func.func @shared_dma_wide_iv_stride_pow2
// CHECK: %[[LOOP:.*]]:2 = waveamdmachine.uniform_loop
// CHECK: ^bb0(%[[IV:.*]]: !waveamdmachine.reg<sgpr, 2>, %[[CARRY:.*]]: !waveamdmachine.reg<sgpr, 1>):
// CHECK-NOT: waveamdmachine.s_lshl_b32 %[[IV]]
// CHECK: %[[SCALED:.*]], %{{.*}} = waveamdmachine.s_lshl_b64 %[[IV]], {{.*}} : (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.imm) -> (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.reg<scc, 1>)
// CHECK: waveamdmachine.s_mov_m0
// CHECK: waveamdmachine.global_load_lds_b128
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @shared_dma_wide_iv_stride_pow2(
    %in: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel, wave.lds_size = 512 : i64} {
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  %c4 = arith.constant 4 : index
  %ub = arith.constant 2147483648 : index
  %wi_raw = wave.workitem_id 0 : !wave.simd<i32, 64>
  %wi = wave.assume %wi_raw as "w"
      [#wave.pred<"w >= 0">, #wave.pred<"w <= 63">]
      : !wave.simd<i32, 64>
  %src = wave.ptr_add %in, %wi
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %lds = wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
  %res = scf.for %i = %c0 to %ub step %c1
      iter_args(%dst = %lds) -> (!wave.ptr<#wave.shared, i32>) {
    %tok0 = wave.token : !wave.mem.token
    %tok = waveamd.dma_load_lds %src -> %dst after %tok0 {bytes = 16 : i64}
        : (!wave.simd<!wave.ptr<#wave.global, i32>, 64>,
           !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %next = wave.ptr_add %dst, %c4
        : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
    scf.yield %next : !wave.ptr<#wave.shared, i32>
  }
  return
}
}

// CHECK-LABEL: func.func @shared_dma_wide_iv_stride_mul
// CHECK: %[[LOOP:.*]]:2 = waveamdmachine.uniform_loop
// CHECK: ^bb0(%[[IV:.*]]: !waveamdmachine.reg<sgpr, 2>, %[[CARRY:.*]]: !waveamdmachine.reg<sgpr, 1>):
// CHECK-NOT: waveamdmachine.s_mul_i32 %[[IV]]
// CHECK: %[[SCALED:.*]], %{{.*}}, %{{.*}} = waveamdmachine.s_mul_u64 %[[IV]], {{.*}} : (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.reg<sgpr, 2>) -> (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
// CHECK: waveamdmachine.s_mov_m0
// CHECK: waveamdmachine.global_load_lds_b128
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @shared_dma_wide_iv_stride_mul(%in: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel, wave.lds_size = 512 : i64} {
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  %c3 = arith.constant 3 : index
  %ub = arith.constant 2147483648 : index
  %wi_raw = wave.workitem_id 0 : !wave.simd<i32, 64>
  %wi = wave.assume %wi_raw as "w"
      [#wave.pred<"w >= 0">, #wave.pred<"w <= 63">]
      : !wave.simd<i32, 64>
  %src = wave.ptr_add %in, %wi
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %lds = wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
  %res = scf.for %i = %c0 to %ub step %c1
      iter_args(%dst = %lds) -> (!wave.ptr<#wave.shared, i32>) {
    %tok0 = wave.token : !wave.mem.token
    %tok = waveamd.dma_load_lds %src -> %dst after %tok0 {bytes = 16 : i64}
        : (!wave.simd<!wave.ptr<#wave.global, i32>, 64>,
           !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %next = wave.ptr_add %dst, %c3
        : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
    scf.yield %next : !wave.ptr<#wave.shared, i32>
  }
  return
}
}

// CHECK-LABEL: func.func @reject_shared_symbolic_pointer_carry_machine
// CHECK: %[[STRIDE:.*]] = waveamdmachine.arg {index = 0 : i64, pointer = false}
// CHECK: %[[WI:.*]] = waveamdmachine.v_workitem_id_x
// CHECK: waveamdmachine.uniform_loop
// CHECK-SAME: carries(%{{.*}} : !waveamdmachine.reg<sgpr, 1>)
// CHECK: ^bb0(%[[IV:.*]]: !waveamdmachine.reg<sgpr, 1>):
// CHECK: %[[LANE:.*]] = waveamdmachine.v_and_b32 %[[WI]]
// CHECK: %[[LANE_BYTES:.*]] = waveamdmachine.v_lshlrev_b32 %[[LANE]]
// CHECK: %[[SCALED:.*]] = waveamdmachine.s_mul_i32 %[[STRIDE]], %[[IV]]
// CHECK: %[[ADDR:.*]] = waveamdmachine.v_add_u32 %[[SCALED]], %[[LANE_BYTES]]
// CHECK: waveamdmachine.ds_load_tuple_b32 %[[ADDR]]
// CHECK: waveamdmachine.ds_store_tuple_b32 %[[ADDR]]
// CHECK: waveamdmachine.continue_if
// CHECK-SAME: carries(%{{.*}} : !waveamdmachine.reg<sgpr, 1>)
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @reject_shared_symbolic_pointer_carry_machine(
    %stride_raw: i32, %n: i32)
    attributes {wave.kernel, wave.lds_size = 4096 : i64} {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %stride = wave.assume %stride_raw as "s"
      [#wave.pred<"s >= 0">, #wave.pred<"s <= 16">] : i32
  %wi = wave.workitem_id 0 : !wave.simd<i32, 64>
  %lds = wave.shared_memory_base : !wave.ptr<#wave.shared, i8>
  scf.for %i = %c0 to %n step %c1 : i32 {
    %off = wave.index_expr <"s*i + 8*Mod(wi, 64)"> ["s", "i", "wi"](%stride, %i, %wi)
        : (i32, i32, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
    %p = wave.ptr_add %lds, %off
        : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64>
        -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
    %v, %t = wave.load %p
        : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>)
        -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
    wave.store %v -> %p after %t
        : (!wave.simd<vector<4xi32>, 64>,
           !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token)
        -> !wave.mem.token
  }
  return
}
}

// CHECK-LABEL: func.func @drop_dead_simd_offset_carries_machine
// CHECK: %[[LOOP:.*]]:2 = waveamdmachine.uniform_loop
// CHECK-SAME: carries(%{{.*}}, %{{.*}} : !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.mem.token)
// CHECK: ^bb0(%[[IV:.*]]: !waveamdmachine.reg<sgpr, 1>, %[[TOK:.*]]: !waveamdmachine.mem.token):
// CHECK: waveamdmachine.s_lshl_b32 %{{.*}}
// CHECK: waveamdmachine.v_add_u32
// CHECK: waveamdmachine.global_load_b32 {{.*}} after %[[TOK]]
// CHECK: waveamdmachine.global_store_b32
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @drop_dead_simd_offset_carries_machine(
    %a: !wave.ptr<#wave.global, i32>, %n: i32) attributes {wave.kernel} {
  %c1 = arith.constant 1 : i32
  %c64 = arith.constant 64 : i32
  %c128 = arith.constant 128 : i32
  %wi = wave.workitem_id 0 : !wave.simd<i32, 64>
  %s64 = wave.splat %c64 : i32 -> !wave.simd<i32, 64>
  %s128 = wave.splat %c128 : i32 -> !wave.simd<i32, 64>
  %init0 = wave.binary addi %wi, %s64 overflow<nsw>
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %init1 = wave.binary addi %wi, %s128 overflow<nsw>
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %tok0 = wave.token : !wave.mem.token
  %unused:3 = scf.for %i = %c1 to %n step %c1
      iter_args(%off0 = %init0, %off1 = %init1, %tok = %tok0)
      -> (!wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.mem.token) : i32 {
    %bounded = wave.assume %off0 as "x"
        [#wave.pred<"x >= 0">, #wave.pred<"x <= 1023">]
        : !wave.simd<i32, 64>
    %p = wave.ptr_add %a, %bounded
        : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>
        -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
    %v, %t = wave.load %p after %tok
        : (!wave.simd<!wave.ptr<#wave.global, i32>, 64>, !wave.mem.token)
        -> (!wave.simd<i32, 64>, !wave.mem.token)
    %st = wave.store %v -> %p after %t
        : (!wave.simd<i32, 64>, !wave.simd<!wave.ptr<#wave.global, i32>, 64>,
           !wave.mem.token) -> !wave.mem.token
    %next0 = wave.binary addi %off0, %s64 overflow<nsw>
        : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
    %next1 = wave.binary addi %off1, %s64 overflow<nsw>
        : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
    scf.yield %next0, %next1, %st
        : !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.mem.token
  }
  return
}
}
