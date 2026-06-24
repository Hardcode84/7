// RUN: wave-opt --waveamd-to-machine --verify-diagnostics %s | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @piecewise_index_expr_select
// CHECK: waveamdmachine.v_cmp_lt_i32
// CHECK: waveamdmachine.v_cndmask_b32_tuple
func.func @piecewise_index_expr_select(%a: !wave.simd<i32, 32>,
                                       %b: !wave.simd<i32, 32>)
    -> !wave.simd<index, 32> {
  %idx = wave.index_expr <"Piecewise((raw0, raw0 - raw1 < 0), (raw1, True))">
      assuming [#wave.pred<"raw0 >= 0">, #wave.pred<"-31 + raw0 <= 0">,
                #wave.pred<"raw1 >= 0">, #wave.pred<"-31 + raw1 <= 0">]
      ["raw0", "raw1"](%a, %b)
      : (!wave.simd<i32, 32>, !wave.simd<i32, 32>) -> !wave.simd<index, 32>
  return %idx : !wave.simd<index, 32>
}

}
