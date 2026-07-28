// RUN: wave-sim-report --func=wmma_f16 --op-latencies %s | FileCheck %s --check-prefix=F16
// RUN: wave-sim-report --func=wmma_bf16 --op-latencies %s | FileCheck %s --check-prefix=BF16
// RUN: not wave-sim-report --func=wmma_f16 --waves-per-simd=2 %s 2>&1 | FileCheck %s --check-prefix=ARBITRATION
// RUN: not wave-sim-report --func=unsupported_wmma %s 2>&1 | FileCheck %s --check-prefix=BADCLASS

// F16: op=waveamdmachine.wmma_f32_16x16x32_f16 class=WriteXDL2PassWMMA fu=MFMA_XDL latency=8
// BF16: op=waveamdmachine.wmma_f32_16x16x32_bf16 class=WriteXDL2PassWMMA fu=MFMA_XDL latency=8
// ARBITRATION: error: 'waveamdmachine.wmma_f32_16x16x32_f16' op multi-wave arbitration is unavailable for gfx1250
// BADCLASS: error: 'waveamdmachine.wmma_f32_16x16x16_f16' op Write16PassWMMA is unsupported on gfx1250

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"} {
  func.func @wmma_f16(
      %a: !waveamdmachine.reg<vgpr, 8>,
      %b: !waveamdmachine.reg<vgpr, 8>,
      %acc: !waveamdmachine.reg<vgpr, 8>) {
    %result = waveamdmachine.wmma_f32_16x16x32_f16 %a, %b, %acc
        : (!waveamdmachine.reg<vgpr, 8>,
           !waveamdmachine.reg<vgpr, 8>,
           !waveamdmachine.reg<vgpr, 8>)
        -> !waveamdmachine.reg<vgpr, 8>
    return
  }

  func.func @wmma_bf16(
      %a: !waveamdmachine.reg<vgpr, 8>,
      %b: !waveamdmachine.reg<vgpr, 8>,
      %acc: !waveamdmachine.reg<vgpr, 8>) {
    %result = waveamdmachine.wmma_f32_16x16x32_bf16 %a, %b, %acc
        : (!waveamdmachine.reg<vgpr, 8>,
           !waveamdmachine.reg<vgpr, 8>,
           !waveamdmachine.reg<vgpr, 8>)
        -> !waveamdmachine.reg<vgpr, 8>
    return
  }

  func.func @unsupported_wmma(
      %a: !waveamdmachine.reg<vgpr, 8>,
      %b: !waveamdmachine.reg<vgpr, 8>,
      %acc: !waveamdmachine.reg<vgpr, 8>) {
    %result = waveamdmachine.wmma_f32_16x16x16_f16 %a, %b, %acc
        : (!waveamdmachine.reg<vgpr, 8>,
           !waveamdmachine.reg<vgpr, 8>,
           !waveamdmachine.reg<vgpr, 8>)
        -> !waveamdmachine.reg<vgpr, 8>
    return
  }
}
