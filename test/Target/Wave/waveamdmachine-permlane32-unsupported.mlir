// RUN: not wave-translate --wave-to-amdgpu-asm %s 2>&1 | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx942"} {

func.func @unsupported_permlane32_swap() {
  %source = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 2, 0>
  // CHECK: error: v_permlane32_swap_b32_tuple unsupported on target
  %result = waveamdmachine.v_permlane32_swap_b32_tuple %source
      : (!waveamdmachine.reg<vgpr, 2, 0>)
      -> !waveamdmachine.reg<vgpr, 2, 0>
  %parts:2 = waveamdmachine.tuple_to_elements %result
      : (!waveamdmachine.reg<vgpr, 2, 0>)
      -> (!waveamdmachine.reg<vgpr, 1, 0>,
          !waveamdmachine.reg<vgpr, 1, 1>)
  %first = waveamdmachine.v_readfirstlane_b32 %parts#0
      : (!waveamdmachine.reg<vgpr, 1, 0>)
      -> !waveamdmachine.reg<sgpr, 1, 20>
  waveamdmachine.s_mov_b32 "s21", %first
      : (!waveamdmachine.reg<sgpr, 1, 20>) -> ()
  waveamdmachine.s_endpgm
  return
}

}
