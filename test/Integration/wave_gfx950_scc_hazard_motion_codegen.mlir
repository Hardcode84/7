// RUN: wave-opt %s --pass-pipeline='builtin.module(waveamd-abi-lowering,transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_backend_finish})' \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline \
// RUN:     wave-translate --wave-to-amdgpu-asm - \
// RUN:   | FileCheck %s --check-prefix=ASM
// RUN: wave-opt %s --pass-pipeline='builtin.module(waveamd-abi-lowering,transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_backend_finish})' \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline \
// RUN:     wave-translate --wave-to-amdgpu-asm - \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 \
// RUN:     -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// ASM-LABEL: scc_hazard_motion_codegen:
// ASM: s_cmp_lt_i32
// ASM: s_mov_b32 m0
// ASM: s_cselect_b32
// ASM-NEXT: s_add_i32
// ASM-NEXT: buffer_load_dwordx4
// ASM: s_cmp_lg_u32
// ASM-NEXT: s_cbranch_scc1
// ASM: s_endpgm
func.func @scc_hazard_motion_codegen(
    %a: !waveamdmachine.reg<sgpr, 1>,
    %b: !waveamdmachine.reg<sgpr, 1>,
    %off: !waveamdmachine.reg<vgpr, 1>,
    %desc: !waveamdmachine.reg<sgpr, 4>,
    %soff: !waveamdmachine.reg<sgpr, 1>,
    %dst: !waveamdmachine.reg<sgpr, 1>,
    %x: !waveamdmachine.reg<sgpr, 1>) attributes {
    wave.kernel,
    wave.workgroup_size = array<i32: 64, 1, 1>
  } {
  %root = waveamdmachine.token : !waveamdmachine.mem.token
  %inc = waveamdmachine.imm 256 : !waveamdmachine.imm
  %cond = waveamdmachine.s_cmp_lt_i32 %a, %b
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
        -> !waveamdmachine.reg<scc, 1>
  %m0 = waveamdmachine.s_mov_m0 %dst
      : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.m0
  %tok = waveamdmachine.buffer_load_lds_b128
      %off, %desc, %soff, %m0 after %root
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.m0,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  %fill, %dead_scc = waveamdmachine.s_add_i32 %x, %inc
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
        -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  waveamdmachine.s_cbranch_scc1 %cond
      : !waveamdmachine.reg<scc, 1>, "taken"
  waveamdmachine.label "taken"
  waveamdmachine.s_mov_b32 "s20", %fill
      : (!waveamdmachine.reg<sgpr, 1>) -> ()
  waveamdmachine.s_endpgm
  return
}

}
