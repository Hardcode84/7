// RUN: wave-opt --wave-extract-loop-strides --canonicalize --cse --waveamd-to-machine --canonicalize --cse %s | FileCheck %s

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
