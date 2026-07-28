// RUN: not wave-opt %s --waveamd-machine-schedule='apply-schedule=1' 2>&1 \
// RUN:   | FileCheck %s --check-prefix=UNSUP --implicit-check-not="LLVM ERROR"
// RUN: not wave-opt %s --waveamd-machine-schedule-report='print-classes=1' 2>&1 \
// RUN:   | FileCheck %s --check-prefix=UNSUP --implicit-check-not="LLVM ERROR"
// RUN: not wave-opt %s --waveamd-machine-schedule-report='print-candidates=1' 2>&1 \
// RUN:   | FileCheck %s --check-prefix=UNSUP --implicit-check-not="LLVM ERROR"

// UNSUP: error: 'waveamdmachine.wmma_f32_16x16x16_f16' op Write16PassWMMA is unsupported on gfx1250

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"} {
  func.func @unsupported_class(
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
