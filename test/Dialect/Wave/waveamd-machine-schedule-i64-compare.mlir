// RUN: wave-opt %s --waveamd-machine-schedule-report='print-classes=1 print-score=1' 2>&1 | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

func.func @scalar_i64_compare_schedule(
    %lhs: !waveamdmachine.reg<sgpr, 2>,
    %rhs: !waveamdmachine.reg<sgpr, 2>,
    %vcc: !waveamdmachine.reg<vcc, 1>) {
  %eq = waveamdmachine.s_cmp_eq_u64 %lhs, %rhs
      : (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.reg<sgpr, 2>)
        -> !waveamdmachine.reg<scc, 1>
  %ne = waveamdmachine.s_cmp_lg_u64 %vcc, %rhs
      : (!waveamdmachine.reg<vcc, 1>, !waveamdmachine.reg<sgpr, 2>)
        -> !waveamdmachine.reg<scc, 1>
  return
}

// CHECK: waveamd-machine-schedule-report op func=scalar_i64_compare_schedule region=0 index=0 name=waveamdmachine.s_cmp_eq_u64 class=WriteSALU fu=SALU
// CHECK: waveamd-machine-schedule-report op func=scalar_i64_compare_schedule region=0 index=1 name=waveamdmachine.s_cmp_lg_u64 class=WriteSALU fu=SALU
// CHECK: waveamd-machine-schedule-report score func=scalar_i64_compare_schedule region=0 order=original cycles={{[0-9]+}} issued_ops=2

}
