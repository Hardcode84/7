// RUN: split-file %s %t
// RUN: cat %t/global.mlir %t/buffer.mlir > %t/both.mlir
// RUN: sed -e "s/@CHIP@/gfx908/g" -e "s/@BITS@/32/g" %t/both.mlir | env WAVE_PIPELINES_DIR=%S/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm --split-input-file - | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx908 -filetype=obj -o /dev/null
// RUN: sed -e "s/@CHIP@/gfx908/g" -e "s/@BITS@/128/g" %t/both.mlir | env WAVE_PIPELINES_DIR=%S/Inputs/emit-only-pipeline not wave-translate --wave-to-amdgpu-asm --split-input-file - 2>&1 | FileCheck %s --check-prefix=REJECT-128
// RUN: sed -e "s/@CHIP@/gfx803/g" -e "s/@BITS@/128/g" %t/both.mlir | env WAVE_PIPELINES_DIR=%S/Inputs/emit-only-pipeline not wave-translate --wave-to-amdgpu-asm --split-input-file - 2>&1 | FileCheck %s --check-prefix=REJECT-128
// RUN: sed -e "s/@CHIP@/gfx900/g" -e "s/@BITS@/32/g" %t/both.mlir | env WAVE_PIPELINES_DIR=%S/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm --split-input-file - | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx900 -filetype=obj -o /dev/null
// RUN: sed -e "s/@CHIP@/gfx90a/g" -e "s/@BITS@/32/g" %t/both.mlir | env WAVE_PIPELINES_DIR=%S/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm --split-input-file - | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx90a -filetype=obj -o /dev/null
// RUN: sed -e "s/@CHIP@/gfx942/g" -e "s/@BITS@/32/g" %t/both.mlir | env WAVE_PIPELINES_DIR=%S/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm --split-input-file - | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx942 -filetype=obj -o /dev/null
// RUN: sed -e "s/@CHIP@/gfx950/g" -e "s/@BITS@/32/g" %t/both.mlir | env WAVE_PIPELINES_DIR=%S/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm --split-input-file - | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null
// RUN: sed -e "s/@CHIP@/gfx950/g" -e "s/@BITS@/128/g" %t/both.mlir | env WAVE_PIPELINES_DIR=%S/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm --split-input-file - | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null
// RUN: sed -e "s/@CHIP@/gfx900/g" -e "s/@BITS@/128/g" %t/both.mlir | env WAVE_PIPELINES_DIR=%S/Inputs/emit-only-pipeline not wave-translate --wave-to-amdgpu-asm --split-input-file - 2>&1 | FileCheck %s --check-prefix=REJECT-128
// RUN: sed -e "s/@CHIP@/gfx90a/g" -e "s/@BITS@/128/g" %t/both.mlir | env WAVE_PIPELINES_DIR=%S/Inputs/emit-only-pipeline not wave-translate --wave-to-amdgpu-asm --split-input-file - 2>&1 | FileCheck %s --check-prefix=REJECT-128
// RUN: sed -e "s/@CHIP@/gfx942/g" -e "s/@BITS@/128/g" %t/both.mlir | env WAVE_PIPELINES_DIR=%S/Inputs/emit-only-pipeline not wave-translate --wave-to-amdgpu-asm --split-input-file - 2>&1 | FileCheck %s --check-prefix=REJECT-128
// RUN: sed -e "s/@CHIP@/gfx1100/g" -e "s/@BITS@/32/g" %t/both.mlir | env WAVE_PIPELINES_DIR=%S/Inputs/emit-only-pipeline not wave-translate --wave-to-amdgpu-asm --split-input-file - 2>&1 | FileCheck %s --check-prefix=REJECT-32
// RUN: sed -e "s/@CHIP@/gfx1100/g" -e "s/@BITS@/128/g" %t/both.mlir | env WAVE_PIPELINES_DIR=%S/Inputs/emit-only-pipeline not wave-translate --wave-to-amdgpu-asm --split-input-file - 2>&1 | FileCheck %s --check-prefix=REJECT-128
// RUN: sed -e "s/@CHIP@/gfx1250/g" -e "s/@BITS@/32/g" %t/both.mlir | env WAVE_PIPELINES_DIR=%S/Inputs/emit-only-pipeline not wave-translate --wave-to-amdgpu-asm --split-input-file - 2>&1 | FileCheck %s --check-prefix=REJECT-32
// RUN: sed -e "s/@CHIP@/gfx1250/g" -e "s/@BITS@/128/g" %t/both.mlir | env WAVE_PIPELINES_DIR=%S/Inputs/emit-only-pipeline not wave-translate --wave-to-amdgpu-asm --split-input-file - 2>&1 | FileCheck %s --check-prefix=REJECT-128
// REJECT-32-DAG: does not support 4-byte global-to-LDS DMA
// REJECT-32-DAG: does not support 4-byte buffer-to-LDS DMA
// REJECT-128-DAG: does not support 16-byte global-to-LDS DMA
// REJECT-128-DAG: does not support 16-byte buffer-to-LDS DMA
// RUN: sed -e "s/@CHIP@/gfx803/g" -e "s/@BITS@/32/g" %t/buffer.mlir | env WAVE_PIPELINES_DIR=%S/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm - | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx803 -filetype=obj -o /dev/null
// RUN: sed -e "s/@CHIP@/gfx803/g" -e "s/@BITS@/32/g" %t/global.mlir | env WAVE_PIPELINES_DIR=%S/Inputs/emit-only-pipeline not wave-translate --wave-to-amdgpu-asm - 2>&1 | FileCheck %s --check-prefix=GFX8
// GFX8: gfx803 does not support 4-byte global-to-LDS DMA

//--- global.mlir
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--@CHIP@"} {
func.func @global_dma() -> !waveamdmachine.mem.token {
  %off = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 0>
  %base = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2, 0>
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %m0_source = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 1, 4>
  %m0 = waveamdmachine.s_mov_m0 %m0_source
      : (!waveamdmachine.reg<sgpr, 1, 4>) -> !waveamdmachine.m0
  %root = waveamdmachine.token : !waveamdmachine.mem.token
  %loaded = waveamdmachine.global_load_lds_b@BITS@ %off, %base, %m0 after %root
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<sgpr, 2, 0>,
         !waveamdmachine.m0, !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  return %loaded : !waveamdmachine.mem.token
}
}

// -----

//--- buffer.mlir
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--@CHIP@"} {
func.func @buffer_dma() -> !waveamdmachine.mem.token {
  %off = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 0>
  %base = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 4, 0>
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %m0_source = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 1, 4>
  %m0 = waveamdmachine.s_mov_m0 %m0_source
      : (!waveamdmachine.reg<sgpr, 1, 4>) -> !waveamdmachine.m0
  %root = waveamdmachine.token : !waveamdmachine.mem.token
  %loaded = waveamdmachine.buffer_load_lds_b@BITS@ %off, %base, %zero, %m0 after %root
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<sgpr, 4, 0>,
         !waveamdmachine.imm, !waveamdmachine.m0, !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  return %loaded : !waveamdmachine.mem.token
}
}
