// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s --check-prefix=ASM
// RUN: wave-translate --wave-to-amdgpu-asm %s | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// ASM-LABEL: cmpx:
// ASM: v_cmpx_eq_u32_e64 exec, v0, v1
// ASM: v_cmpx_lt_i32_e64 exec, v0, v1
func.func @cmpx(%x: !waveamdmachine.reg<vgpr, 1, 0>,
                %y: !waveamdmachine.reg<vgpr, 1, 1>) {
  waveamdmachine.v_cmpx_eq_u32 %x, %y
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<vgpr, 1, 1>) -> ()
  waveamdmachine.v_cmpx_lt_i32 %x, %y
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<vgpr, 1, 1>) -> ()
  return
}

}
