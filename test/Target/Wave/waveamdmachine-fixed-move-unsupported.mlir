// RUN: env WAVE_PIPELINES_DIR=%S/Inputs/emit-only-pipeline \
// RUN:   wave-translate %s --wave-to-amdgpu-asm --verify-diagnostics

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @sgpr_not_addressable_on_target() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  // expected-error @below {{LLVM MC has no SGPR tuple at base 105 with width 1 on gfx950}}
  waveamdmachine.s_mov_b32 "s105", %zero : (!waveamdmachine.imm) -> ()
  return
}
}
