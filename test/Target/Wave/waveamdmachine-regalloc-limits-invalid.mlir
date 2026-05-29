// RUN: not wave-opt --waveamd-reg-alloc='vgpr-limit=0' %s 2>&1 | FileCheck %s --check-prefix=VGPR
// RUN: not wave-opt --waveamd-reg-alloc='sgpr-limit=4' %s 2>&1 | FileCheck %s --check-prefix=SGPR

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// VGPR: waveamd-reg-alloc VGPR limit leaves fewer registers than reserved kernel ABI prefix (available=0, reserved=1)
// SGPR: waveamd-reg-alloc SGPR limit leaves fewer registers than reserved kernel ABI prefix (available=4, reserved=5)
func.func @low_register_limit() attributes {wave.kernel} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %reg = waveamdmachine.v_mov_b32_tuple %zero
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  return
}

}
