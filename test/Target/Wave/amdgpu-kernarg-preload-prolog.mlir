// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s
// RUN: wave-translate --wave-to-amdgpu-asm %s | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx942 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx942"} {

// CHECK-LABEL: explicit_preload_chunks:
// CHECK: s_load_dwordx2 s[2:3], s[0:1], 0x18
// CHECK: s_load_dwordx8 s[4:11], s[0:1], 0x20
// CHECK: s_waitcnt lgkmcnt(0)
// CHECK: s_branch [[ENTRY:.*kernarg_preload_entry]]
// CHECK: .p2align 8
// CHECK: [[ENTRY]]:
// CHECK-NOT: s_load_dword
// CHECK: s_endpgm
// CHECK: .amdhsa_user_sgpr_kernarg_preload_length 10
// CHECK: .amdhsa_user_sgpr_kernarg_preload_offset 6
func.func @explicit_preload_chunks(%a: i64, %b: i64, %c: i64, %d: i64,
                                   %e: i64, %f: i64, %g: i64, %h: i64)
    attributes {wave.kernel, waveamdmachine.kernarg_preload_length = 10 : i64,
                waveamdmachine.kernarg_preload_offset = 6 : i64,
                waveamdmachine.sgpr_count = 12 : i64,
                waveamdmachine.vgpr_count = 1 : i64} {
  waveamdmachine.s_endpgm
  return
}

// CHECK-LABEL: misaligned_preload_offset:
// CHECK: s_load_dword s2, s[0:1], 0x4
// CHECK: s_load_dword s3, s[0:1], 0x8
// CHECK: s_load_dword s4, s[0:1], 0xc
// CHECK: s_load_dword s5, s[0:1], 0x10
// CHECK: s_load_dword s6, s[0:1], 0x14
// CHECK: s_load_dword s7, s[0:1], 0x18
// CHECK-NOT: s_load_dwordx
// CHECK: s_waitcnt lgkmcnt(0)
// CHECK: .amdhsa_user_sgpr_kernarg_preload_length 6
// CHECK: .amdhsa_user_sgpr_kernarg_preload_offset 1
func.func @misaligned_preload_offset(%a: i64, %b: i64, %c: i64, %d: i64)
    attributes {wave.kernel, waveamdmachine.kernarg_preload_length = 6 : i64,
                waveamdmachine.kernarg_preload_offset = 1 : i64,
                waveamdmachine.sgpr_count = 10 : i64,
                waveamdmachine.vgpr_count = 1 : i64} {
  waveamdmachine.s_endpgm
  return
}

}
