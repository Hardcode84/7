// RUN: wave-sim-report --func=fma_class --op-latencies %s | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
  func.func @fma_class(%a: !waveamdmachine.reg<vgpr, 1>,
                       %b: !waveamdmachine.reg<vgpr, 1>,
                       %c: !waveamdmachine.reg<vgpr, 1>) {
    %fma = waveamdmachine.v_fma_f32 %a, %b, %c
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
           !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
    return
  }
}

// CHECK: op=waveamdmachine.v_fma_f32 class=WriteFloatFMA fu=VALU
