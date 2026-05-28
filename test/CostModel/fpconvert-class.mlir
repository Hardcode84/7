// RUN: wave-sim-report --func=fpconvert_classes --op-latencies %s | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
  func.func @fpconvert_classes(%x: !waveamdmachine.reg<vgpr, 1>) {
    %h = waveamdmachine.v_cvt_f16_f32 %x
        : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
    %f = waveamdmachine.v_cvt_f32_f16 %h
        : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
    return
  }
}

// CHECK: op=waveamdmachine.v_cvt_f16_f32 class=Write32Bit fu=VALU
// CHECK: op=waveamdmachine.v_cvt_f32_f16 class=Write32Bit fu=VALU
