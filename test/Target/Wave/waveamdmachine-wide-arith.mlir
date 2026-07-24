// RUN: wave-opt %s | FileCheck %s --check-prefix=PRINT
// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s --check-prefix=ASM
// RUN: wave-translate --wave-to-amdgpu-asm %s | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// PRINT-LABEL: func.func @wide_xor_machine
// PRINT: waveamdmachine.s_and_b64
// PRINT: waveamdmachine.s_or_b64
// PRINT: waveamdmachine.s_xor_b64
// PRINT: waveamdmachine.v_xor_b64
// ASM-LABEL: wide_xor_machine:
// ASM-DAG: s_and_b64
// ASM-DAG: s_or_b64
// ASM-DAG: s_xor_b64
// ASM-DAG: v_xor_b32
// ASM-DAG: v_xor_b32
func.func @wide_xor_machine(%out: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel} {
  %a = waveamdmachine.arg {index = 0 : i64, pointer = true}
      : !waveamdmachine.reg<sgpr, 2>
  %b = waveamdmachine.s_mov_b64_imm 7 : !waveamdmachine.reg<sgpr, 2>
  %sa, %scc0 = waveamdmachine.s_and_b64 %a, %b
      : (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.reg<sgpr, 2>)
        -> (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.reg<scc, 1>)
  %so, %scc1 = waveamdmachine.s_or_b64 %a, %b
      : (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.reg<sgpr, 2>)
        -> (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.reg<scc, 1>)
  %sx, %scc2 = waveamdmachine.s_xor_b64 %sa, %so
      : (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.reg<sgpr, 2>)
        -> (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.reg<scc, 1>)
  %voff = waveamdmachine.v_mbcnt_lo : !waveamdmachine.reg<vgpr, 1>
  %vx = waveamdmachine.tuple_from_elements %voff, %voff
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.reg<vgpr, 2>
  %vy = waveamdmachine.v_xor_b64 %vx, %vx
      : (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>)
        -> !waveamdmachine.reg<vgpr, 2>
  %tok0 = waveamdmachine.global_store_b32 %voff, %voff, %sx
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.mem.token
  %tok1 = waveamdmachine.global_store_b32_addr64 %vy, %voff after %tok0
      : (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm
  return
}

}
