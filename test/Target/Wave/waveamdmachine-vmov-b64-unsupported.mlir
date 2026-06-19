// RUN: not wave-translate --wave-to-amdgpu-asm %s 2>&1 | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

func.func @unsupported_vmov_b64(%addr: !waveamdmachine.reg<vgpr, 1, 0>,
                                %base: !waveamdmachine.reg<sgpr, 2, 6>) {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  // CHECK: error: v_mov_b64_tuple unsupported on target
  %wide = waveamdmachine.v_mov_b64_tuple %zero
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 2, 2>
  waveamdmachine.global_store_b64 %addr, %wide, %base
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<vgpr, 2, 2>,
         !waveamdmachine.reg<sgpr, 2, 6>) -> ()
  waveamdmachine.s_endpgm
  return
}

}
