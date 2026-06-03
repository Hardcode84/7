// RUN: wave-opt --waveamd-to-machine --verify-diagnostics --split-input-file %s | FileCheck %s --check-prefix=SELECT
// RUN: wave-opt --waveamd-to-machine --verify-diagnostics --split-input-file %s | wave-opt | FileCheck %s --check-prefix=SELECT

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// SELECT-LABEL: func.func @where_yields_value
// SELECT: waveamdmachine.s_and_saveexec_b32
// SELECT: [[SUM:%.*]] = waveamdmachine.v_add_u32
// SELECT: waveamdmachine.label
// SELECT: waveamdmachine.s_mov_exec_lo
// SELECT: waveamdmachine.v_readfirstlane_b32 [[SUM]]
func.func @where_yields_value(%limit: i32) -> i32 {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %vlimit = wave.splat %limit : i32 -> !wave.simd<i32, 32>
  %active = wave.cmpi ult %lane, %vlimit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %chosen = wave.where %active {
    %sum = wave.addi %lane, %vlimit
        : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
    wave.yield %sum : !wave.simd<i32, 32>
  } : !wave.mask<32> -> !wave.simd<i32, 32>
  %first = wave.read_first %chosen : !wave.simd<i32, 32> -> i32
  return %first : i32
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

func.func @where_otherwise_result_rejected(%limit: i32) -> i32 {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %vlimit = wave.splat %limit : i32 -> !wave.simd<i32, 32>
  %active = wave.cmpi ult %lane, %vlimit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  // expected-error @below {{WaveAMDMachine lowering does not support result-bearing wave.where with otherwise}}
  %chosen = wave.where %active {
    wave.yield %lane : !wave.simd<i32, 32>
  } otherwise {
    wave.yield %vlimit : !wave.simd<i32, 32>
  } : !wave.mask<32> -> !wave.simd<i32, 32>
  %first = wave.read_first %chosen : !wave.simd<i32, 32> -> i32
  return %first : i32
}

}
