// RUN: wave-opt %s --waveamd-machine-schedule-report='score-func=candidate_lower score-region=0 score-order=0,2,1,3' 2>&1 | FileCheck %s --check-prefix=LOWER
// RUN: wave-opt %s --waveamd-machine-schedule-report='score-func=candidate_greater score-region=0 score-order=0,2,1,3' 2>&1 | FileCheck %s --check-prefix=GREATER
// RUN: wave-opt %s --waveamd-machine-schedule-report='score-func=candidate_equal score-region=0 score-order=1,0' 2>&1 | FileCheck %s --check-prefix=EQUAL
// RUN: wave-opt %s --waveamd-machine-schedule-report='score-func=candidate_invalid score-region=0 score-order=1,0' 2>&1 | FileCheck %s --check-prefix=INVALID
// RUN: wave-opt %s --waveamd-machine-schedule-report='score-func=wmma_latency score-region=0 score-order=0,1' 2>&1 | FileCheck %s --check-prefix=WMMA

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @candidate_lower(%off: !waveamdmachine.reg<vgpr, 1>,
                           %base: !waveamdmachine.reg<sgpr, 2>,
                           %a: !waveamdmachine.reg<vgpr, 1>,
                           %b: !waveamdmachine.reg<vgpr, 1>) {
  %tok0 = waveamdmachine.token : !waveamdmachine.mem.token
  %ind = waveamdmachine.v_add_u32 %a, %b : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %loaded, %tok1 = waveamdmachine.global_load_b32 %off, %base after %tok0
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %dep = waveamdmachine.v_add_u32 %loaded, %ind : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  return
}

func.func @candidate_greater(%off: !waveamdmachine.reg<vgpr, 1>,
                             %base: !waveamdmachine.reg<sgpr, 2>,
                             %a: !waveamdmachine.reg<vgpr, 1>,
                             %b: !waveamdmachine.reg<vgpr, 1>) {
  %tok0 = waveamdmachine.token : !waveamdmachine.mem.token
  %loaded, %tok1 = waveamdmachine.global_load_b32 %off, %base after %tok0
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %ind = waveamdmachine.v_add_u32 %a, %b : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %dep = waveamdmachine.v_add_u32 %loaded, %ind : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  return
}

func.func @candidate_equal(%a: !waveamdmachine.reg<vgpr, 1>,
                           %b: !waveamdmachine.reg<vgpr, 1>,
                           %c: !waveamdmachine.reg<vgpr, 1>,
                           %d: !waveamdmachine.reg<vgpr, 1>) {
  %lhs = waveamdmachine.v_add_u32 %a, %b : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %rhs = waveamdmachine.v_add_u32 %c, %d : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  return
}

func.func @candidate_invalid(%a: !waveamdmachine.reg<vgpr, 1>,
                             %b: !waveamdmachine.reg<vgpr, 1>) {
  %lhs = waveamdmachine.v_add_u32 %a, %b : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %rhs = waveamdmachine.v_add_u32 %lhs, %b : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  return
}

func.func @wmma_latency(%a: !waveamdmachine.reg<vgpr, 8>,
                        %b: !waveamdmachine.reg<vgpr, 8>,
                        %acc: !waveamdmachine.reg<vgpr, 8>) {
  %first = waveamdmachine.wmma_f32_16x16x16_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 8>, !waveamdmachine.reg<vgpr, 8>,
         !waveamdmachine.reg<vgpr, 8>) -> !waveamdmachine.reg<vgpr, 8>
  %second = waveamdmachine.wmma_f32_16x16x16_f16 %a, %b, %first
      : (!waveamdmachine.reg<vgpr, 8>, !waveamdmachine.reg<vgpr, 8>,
         !waveamdmachine.reg<vgpr, 8>) -> !waveamdmachine.reg<vgpr, 8>
  return
}

func.func @fixed_pressure() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %fixed = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1, 7>
  %tmp = waveamdmachine.v_add_u32 %fixed, %fixed
      : (!waveamdmachine.reg<vgpr, 1, 7>, !waveamdmachine.reg<vgpr, 1, 7>)
        -> !waveamdmachine.reg<vgpr, 1>
  %use = waveamdmachine.v_add_u32 %fixed, %tmp
      : (!waveamdmachine.reg<vgpr, 1, 7>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 1>
  return
}
}

// LOWER: waveamd-machine-schedule-report score func=candidate_lower region=0 order=original cycles=326 issued_ops=3
// LOWER: waveamd-machine-schedule-report score func=candidate_lower region=0 order=candidate cycles=325 issued_ops=3

// GREATER: waveamd-machine-schedule-report score func=candidate_greater region=0 order=original cycles=325 issued_ops=3
// GREATER: waveamd-machine-schedule-report score func=candidate_greater region=0 order=candidate cycles=326 issued_ops=3

// EQUAL: waveamd-machine-schedule-report score func=candidate_equal region=0 order=original cycles=6 issued_ops=2
// EQUAL: waveamd-machine-schedule-report score func=candidate_equal region=0 order=candidate cycles=6 issued_ops=2

// INVALID: waveamd-machine-schedule-report score func=candidate_invalid region=0 order=original cycles=10 issued_ops=2
// INVALID: waveamd-machine-schedule-report score func=candidate_invalid region=0 order=candidate fallback=original reason=candidate_order_breaks_dependency

// WMMA: waveamd-machine-schedule-report score func=wmma_latency region=0 order=original cycles=128 issued_ops=2
// WMMA: waveamd-machine-schedule-report score func=wmma_latency region=0 order=candidate cycles=128 issued_ops=2
