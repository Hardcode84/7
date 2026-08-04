// RUN: split-file %s %t
// RUN: wave-opt %t/gfx803.mlir --waveamd-machine-schedule-report='print-classes' 2>&1 | FileCheck %s --check-prefix=GFX803-MODEL
// RUN: wave-translate --wave-to-amdgpu-asm %t/gfx803.mlir | FileCheck %s --check-prefix=GFX803-ASM
// RUN: wave-translate --wave-to-amdgpu-asm %t/gfx803.mlir | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx803 -filetype=obj -o /dev/null
// RUN: wave-opt %t/gfx1100-wave32.mlir --waveamd-machine-schedule-report='print-classes' 2>&1 | FileCheck %s --check-prefix=GFX1100-W32-MODEL
// RUN: wave-translate --wave-to-amdgpu-asm %t/gfx1100-wave32.mlir | FileCheck %s --check-prefix=GFX1100-W32-ASM
// RUN: wave-translate --wave-to-amdgpu-asm %t/gfx1100-wave32.mlir | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 -filetype=obj -o /dev/null
// RUN: wave-opt %t/gfx1100-wave64.mlir --waveamd-machine-schedule-report='print-classes' 2>&1 | FileCheck %s --check-prefix=GFX1100-W64-MODEL
// RUN: wave-translate --wave-to-amdgpu-asm %t/gfx1100-wave64.mlir | FileCheck %s --check-prefix=GFX1100-W64-ASM
// RUN: wave-translate --wave-to-amdgpu-asm %t/gfx1100-wave64.mlir | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 -mattr=-wavefrontsize32,+wavefrontsize64 -filetype=obj -o /dev/null
// RUN: not wave-opt %t/gfx803-wave32.mlir --waveamd-machine-schedule-report='print-classes' 2>&1 | FileCheck %s --check-prefix=GFX803-W32-ERR

// GFX803-MODEL: name=waveamdmachine.s_mov_vcc_b32{{.*}}issues=2
// GFX803-ASM-LABEL: restore_vcc_gfx803:
// GFX803-ASM: s_mov_b32 vcc_lo, s4
// GFX803-ASM-NEXT: s_mov_b32 vcc_hi, 0

// GFX1100-W32-MODEL: name=waveamdmachine.s_mov_vcc_b32{{.*}}issues=1
// GFX1100-W32-ASM-LABEL: restore_vcc_gfx1100_wave32:
// GFX1100-W32-ASM: s_mov_b32 vcc_lo, s4
// GFX1100-W32-ASM-NOT: vcc_hi

// GFX1100-W64-MODEL: name=waveamdmachine.s_mov_vcc_b32{{.*}}issues=2
// GFX1100-W64-ASM-LABEL: restore_vcc_gfx1100_wave64:
// GFX1100-W64-ASM: s_mov_b32 vcc_lo, s4
// GFX1100-W64-ASM-NEXT: s_mov_b32 vcc_hi, 0

// GFX803-W32-ERR: waveamd-machine-schedule-report target gfx803 does not support wave32

//--- gfx803.mlir
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx803"} {
  func.func @restore_vcc_gfx803(
      %flag: !waveamdmachine.reg<sgpr, 1, 4>) {
    %restored = waveamdmachine.s_mov_vcc_b32 %flag
        : (!waveamdmachine.reg<sgpr, 1, 4>) -> !waveamdmachine.reg<vcc, 1>
    return
  }
}

//--- gfx1100-wave32.mlir
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
  func.func @restore_vcc_gfx1100_wave32(
      %flag: !waveamdmachine.reg<sgpr, 1, 4>) {
    %restored = waveamdmachine.s_mov_vcc_b32 %flag
        : (!waveamdmachine.reg<sgpr, 1, 4>) -> !waveamdmachine.reg<vcc, 1>
    return
  }
}

//--- gfx1100-wave64.mlir
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100",
                   waveamdmachine.wavefront_size = 64 : i64} {
  func.func @restore_vcc_gfx1100_wave64(
      %flag: !waveamdmachine.reg<sgpr, 1, 4>) {
    %restored = waveamdmachine.s_mov_vcc_b32 %flag
        : (!waveamdmachine.reg<sgpr, 1, 4>) -> !waveamdmachine.reg<vcc, 1>
    return
  }
}

//--- gfx803-wave32.mlir
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx803",
                   waveamdmachine.wavefront_size = 32 : i64} {
  func.func @reject_gfx803_wave32(
      %flag: !waveamdmachine.reg<sgpr, 1, 4>) {
    %restored = waveamdmachine.s_mov_vcc_b32 %flag
        : (!waveamdmachine.reg<sgpr, 1, 4>) -> !waveamdmachine.reg<vcc, 1>
    return
  }
}
