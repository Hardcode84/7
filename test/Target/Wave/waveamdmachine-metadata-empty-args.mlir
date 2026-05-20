// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s --check-prefix=ASM
// RUN: wave-translate --wave-to-amdgpu-asm %s | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 -filetype=obj -o /dev/null

// A kernel with no kernel arguments. The metadata block must emit
// `.args: []` (an explicit empty list) rather than a bare `.args:`,
// otherwise `llvm-mc`'s msgpack YAML reader treats the entry as
// `null` and aborts in `MsgPackDocumentYAML`.

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// ASM-LABEL: argless_kernel:
// ASM: amdgpu_metadata
// ASM: - .args:           []
// ASM: .name:           argless_kernel
// ASM: end_amdgpu_metadata
func.func @argless_kernel() attributes {wave.kernel} {
  waveamdmachine.s_endpgm
  return
}

}
