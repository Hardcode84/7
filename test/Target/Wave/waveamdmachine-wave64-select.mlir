// RUN: wave-opt --waveamd-to-machine --verify-diagnostics --split-input-file %s | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx942"} {

// CHECK-LABEL: func.func @select_whole_simd_wave64
// CHECK-DAG: waveamdmachine.s_mov_b64_imm 0
// CHECK-DAG: waveamdmachine.s_mov_b64_imm -1
// CHECK: [[MASK:%.*]] = waveamdmachine.tuple_from_elements
// CHECK: waveamdmachine.v_cndmask_b32_tuple {{.*}}, {{.*}}, [[MASK]]
func.func @select_whole_simd_wave64(%pred: i1,
                                    %a: !wave.simd<i32, 64>,
                                    %b: !wave.simd<i32, 64>) -> i32 {
  %r = wave.select %pred, %a, %b : !wave.simd<i32, 64>
  %first = wave.read_first %r : !wave.simd<i32, 64> -> i32
  return %first : i32
}

}
