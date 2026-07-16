// RUN: not wave-translate --wave-to-amdgpu-asm %s 2>&1 | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

func.func @permlane32_swap_without_reuse() {
  %source = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 2, 0>
  // CHECK: regalloc stalled in @permlane32_swap_without_reuse:
  // CHECK-SAME: class=vgpr reason=fixed-conflict set=0 position=0
  // CHECK-SAME: pressure=2 request=2 limit=256
  %result = waveamdmachine.v_permlane32_swap_b32_tuple %source
      : (!waveamdmachine.reg<vgpr, 2, 0>)
      -> !waveamdmachine.reg<vgpr, 2, 2>
  %parts:2 = waveamdmachine.tuple_to_elements %result
      : (!waveamdmachine.reg<vgpr, 2, 2>)
      -> (!waveamdmachine.reg<vgpr, 1, 2>,
          !waveamdmachine.reg<vgpr, 1, 3>)
  %first = waveamdmachine.v_readfirstlane_b32 %parts#0
      : (!waveamdmachine.reg<vgpr, 1, 2>)
      -> !waveamdmachine.reg<sgpr, 1, 20>
  waveamdmachine.s_mov_b32 "s21", %first
      : (!waveamdmachine.reg<sgpr, 1, 20>) -> ()
  waveamdmachine.s_endpgm
  return
}

}
