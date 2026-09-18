// RUN: env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline \
// RUN:   wave-translate %s --wave-to-amdgpu-asm -o %t.s
// RUN: FileCheck %s < %t.s
// RUN: llvm-mc --triple=amdgcn-amd-amdhsa --mcpu=gfx1250 --filetype=obj %t.s -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"} {
// CHECK-LABEL: fixed_sgpr_moves:
// CHECK: s_mov_b32 s8, 17
// CHECK-NEXT: s_mov_b32 s0, s8
// CHECK-NEXT: s_mov_b32 s105, 17
// CHECK-NEXT: s_endpgm
func.func @fixed_sgpr_moves() attributes {wave.kernel} {
  %value = waveamdmachine.imm 17 : !waveamdmachine.imm
  %source = waveamdmachine.s_mov_b32_value %value
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1, 8>
  waveamdmachine.s_mov_b32 "s0", %source
      : (!waveamdmachine.reg<sgpr, 1, 8>) -> ()
  waveamdmachine.s_mov_b32 "s0008", %source
      : (!waveamdmachine.reg<sgpr, 1, 8>) -> ()
  waveamdmachine.s_mov_b32 "s105", %value : (!waveamdmachine.imm) -> ()
  waveamdmachine.s_endpgm
  return
}
}
