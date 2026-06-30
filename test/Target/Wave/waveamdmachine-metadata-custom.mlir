// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s --check-prefix=ASM
// RUN: wave-translate --wave-to-amdgpu-asm %s | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
  // ASM: amdgpu_metadata
  // ASM: .name:           custom_metadata_kernel
  // ASM: wave.test: 7
  // ASM: wave.flag: true
  // ASM: wave.str: "ok"
  // ASM: wave.regalloc.iterations: 1
  // ASM: end_amdgpu_metadata
  func.func @custom_metadata_kernel()
      attributes {wave.kernel,
                  waveamdmachine.metadata = [
                    {name = "wave.test", value = 7 : i64},
                    {name = "wave.flag", value = true},
                    {name = "wave.str", value = "ok"}]} {
    waveamdmachine.s_endpgm
    return
  }
}
