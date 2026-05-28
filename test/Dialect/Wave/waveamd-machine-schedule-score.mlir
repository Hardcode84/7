// RUN: wave-opt %s --waveamd-machine-schedule-report='score-func=candidate_lower score-region=0 score-order=0,2,1,3' 2>&1 | FileCheck %s --check-prefix=LOWER
// RUN: wave-opt %s --waveamd-machine-schedule-report='score-func=candidate_lower score-region=0 score-order=0,2,1,3 model-vmem-value-latency=20' 2>&1 | FileCheck %s --check-prefix=LOWER-VALUE
// RUN: wave-opt %s --waveamd-machine-schedule-report='score-func=candidate_lower score-region=0 score-order=0,2,1,3 model-waves=4 model-simds=4 model-start-delay=0' 2>&1 | FileCheck %s --check-prefix=LOWER-MW
// RUN: wave-opt %s --waveamd-machine-schedule-report='score-func=candidate_greater score-region=0 score-order=0,2,1,3' 2>&1 | FileCheck %s --check-prefix=GREATER
// RUN: wave-opt %s --waveamd-machine-schedule-report='score-func=candidate_equal score-region=0 score-order=1,0' 2>&1 | FileCheck %s --check-prefix=EQUAL
// RUN: wave-opt %s --waveamd-machine-schedule-report='score-func=candidate_invalid score-region=0 score-order=1,0' 2>&1 | FileCheck %s --check-prefix=INVALID
// RUN: wave-opt %s --waveamd-machine-schedule-report='score-func=wmma_latency score-region=0 score-order=0,1' 2>&1 | FileCheck %s --check-prefix=WMMA
// RUN: wave-opt %s --waveamd-machine-schedule-report='score-func=candidate_lower score-region=0 score-order=0,2,1,3 pressure-vgpr-budget=2 pressure-sgpr-budget=0 pressure-critical-vgpr-budget=4 pressure-critical-sgpr-budget=0' 2>&1 | FileCheck %s --check-prefix=BUDGET

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
}

// LOWER: waveamd-machine-schedule-report score func=candidate_lower region=0 order=original cycles=326 issued_ops=3
// LOWER: waveamd-machine-schedule-report score func=candidate_lower region=0 order=candidate cycles=325 issued_ops=3

// BUDGET: waveamd-machine-schedule-report score func=candidate_lower region=0 order=original cycles=326 issued_ops=3 max_vgpr=3 max_sgpr=0 vgpr_hard_excess=1 sgpr_hard_excess=0 vgpr_critical_excess=0 sgpr_critical_excess=0
// BUDGET: waveamd-machine-schedule-report score func=candidate_lower region=0 order=candidate cycles=325 issued_ops=3 max_vgpr=3 max_sgpr=0 vgpr_hard_excess=1 sgpr_hard_excess=0 vgpr_critical_excess=0 sgpr_critical_excess=0

// LOWER-VALUE: waveamd-machine-schedule-report score func=candidate_lower region=0 order=original cycles=26 issued_ops=3
// LOWER-VALUE: waveamd-machine-schedule-report score func=candidate_lower region=0 order=candidate cycles=25 issued_ops=3

// LOWER-MW: waveamd-machine-schedule-report score func=candidate_lower region=0 order=original cycles={{[0-9]+}} issued_ops=12
// LOWER-MW: waveamd-machine-schedule-report score func=candidate_lower region=0 order=candidate cycles={{[0-9]+}} issued_ops=12

// GREATER: waveamd-machine-schedule-report score func=candidate_greater region=0 order=original cycles=325 issued_ops=3
// GREATER: waveamd-machine-schedule-report score func=candidate_greater region=0 order=candidate cycles=326 issued_ops=3

// EQUAL: waveamd-machine-schedule-report score func=candidate_equal region=0 order=original cycles=6 issued_ops=2
// EQUAL: waveamd-machine-schedule-report score func=candidate_equal region=0 order=candidate cycles=6 issued_ops=2

// INVALID: waveamd-machine-schedule-report score func=candidate_invalid region=0 order=original cycles=10 issued_ops=2
// INVALID: waveamd-machine-schedule-report score func=candidate_invalid region=0 order=candidate fallback=original reason=candidate_order_breaks_dependency

// WMMA: waveamd-machine-schedule-report score func=wmma_latency region=0 order=original cycles=10 issued_ops=2
// WMMA: waveamd-machine-schedule-report score func=wmma_latency region=0 order=candidate cycles=10 issued_ops=2
