// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s --check-prefix=ASM
// RUN: wave-translate --wave-to-amdgpu-asm %s | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// ASM-LABEL: cmp64:
// ASM: s_cmp_eq_u64 s[0:1], s[2:3]
// ASM: s_cmp_lg_u64 s[0:1], s[2:3]
func.func @cmp64(%lhs: !waveamdmachine.reg<sgpr, 2, 0>,
                 %rhs: !waveamdmachine.reg<sgpr, 2, 2>)
    -> (!waveamdmachine.reg<scc, 1>, !waveamdmachine.reg<scc, 1>) {
  %eq = waveamdmachine.s_cmp_eq_u64 %lhs, %rhs
      : (!waveamdmachine.reg<sgpr, 2, 0>, !waveamdmachine.reg<sgpr, 2, 2>)
        -> !waveamdmachine.reg<scc, 1>
  %ne = waveamdmachine.s_cmp_lg_u64 %lhs, %rhs
      : (!waveamdmachine.reg<sgpr, 2, 0>, !waveamdmachine.reg<sgpr, 2, 2>)
        -> !waveamdmachine.reg<scc, 1>
  return %eq, %ne
      : !waveamdmachine.reg<scc, 1>, !waveamdmachine.reg<scc, 1>
}

// ASM-LABEL: cmp64_vcc:
// ASM: s_cmp_eq_u64 vcc, s[0:1]
// ASM: s_cmp_lg_u64 s[0:1], vcc
func.func @cmp64_vcc(%vcc: !waveamdmachine.reg<vcc, 1>,
                     %rhs: !waveamdmachine.reg<sgpr, 2, 0>)
    -> (!waveamdmachine.reg<scc, 1>, !waveamdmachine.reg<scc, 1>) {
  %eq = waveamdmachine.s_cmp_eq_u64 %vcc, %rhs
      : (!waveamdmachine.reg<vcc, 1>, !waveamdmachine.reg<sgpr, 2, 0>)
        -> !waveamdmachine.reg<scc, 1>
  %ne = waveamdmachine.s_cmp_lg_u64 %rhs, %vcc
      : (!waveamdmachine.reg<sgpr, 2, 0>, !waveamdmachine.reg<vcc, 1>)
        -> !waveamdmachine.reg<scc, 1>
  return %eq, %ne
      : !waveamdmachine.reg<scc, 1>, !waveamdmachine.reg<scc, 1>
}

}
