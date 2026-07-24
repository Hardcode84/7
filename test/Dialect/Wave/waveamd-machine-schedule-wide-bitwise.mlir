// RUN: wave-opt %s --waveamd-machine-schedule-report='print-classes=1 print-score=1' 2>&1 | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

func.func @wide_bitwise_schedule(
    %lhs: !waveamdmachine.reg<sgpr, 2>,
    %rhs: !waveamdmachine.reg<sgpr, 2>) {
  %and, %scc0 = waveamdmachine.s_and_b64 %lhs, %rhs
      : (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.reg<sgpr, 2>)
        -> (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.reg<scc, 1>)
  %or, %scc1 = waveamdmachine.s_or_b64 %and, %rhs
      : (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.reg<sgpr, 2>)
        -> (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.reg<scc, 1>)
  return
}

// CHECK: waveamd-machine-schedule-report op func=wide_bitwise_schedule region=0 index=0 name=waveamdmachine.s_and_b64 class=WriteSALU fu=SALU
// CHECK: waveamd-machine-schedule-report op func=wide_bitwise_schedule region=0 index=1 name=waveamdmachine.s_or_b64 class=WriteSALU fu=SALU
// CHECK: waveamd-machine-schedule-report score func=wide_bitwise_schedule region=0 order=original cycles={{[0-9]+}} issued_ops=2

}
