// RUN: wave-opt %s | FileCheck %s --check-prefix=ROUNDTRIP
// RUN: wave-opt %s | wave-opt | FileCheck %s --check-prefix=ROUNDTRIP
// RUN: env WAVE_PIPELINES_DIR=%S/Inputs/emit-only-pipeline \
// RUN:   wave-translate --wave-to-amdgpu-asm %s \
// RUN:   | FileCheck %s --check-prefix=ASM
// RUN: env WAVE_PIPELINES_DIR=%S/Inputs/emit-only-pipeline \
// RUN:   wave-translate --wave-to-amdgpu-asm %s \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1250 \
// RUN:       -filetype=obj -o %t.o
// RUN: llvm-objdump -d --mcpu=gfx1250 %t.o \
// RUN:   | FileCheck %s --check-prefix=DIS

module attributes {
  waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"
} {

// ROUNDTRIP-LABEL: func.func @global_async_to_lds_widths
// ROUNDTRIP: [[ROOT:%.*]] = waveamdmachine.token
// ROUNDTRIP: [[B8:%.*]] = waveamdmachine.global_load_async_to_lds_b8 {{.*}} after [[ROOT]]
// ROUNDTRIP: [[B32:%.*]] = waveamdmachine.global_load_async_to_lds_b32 {{.*}} after [[B8]] offset 64
// ROUNDTRIP: [[B64:%.*]] = waveamdmachine.global_load_async_to_lds_b64 {{.*}} after [[B32]] offset -64
// ROUNDTRIP: waveamdmachine.global_load_async_to_lds_b128 {{.*}} after [[B64]] offset 128
// ASM-LABEL: global_async_to_lds_widths:
// ASM: global_load_async_to_lds_b8 v0, v1, s[0:1]
// ASM-NEXT: global_load_async_to_lds_b32 v2, v3, s[0:1] offset:64
// ASM-NEXT: global_load_async_to_lds_b64 v4, v5, s[0:1] offset:-64
// ASM-NEXT: global_load_async_to_lds_b128 v6, v7, s[0:1] offset:128
// ASM-NEXT: s_endpgm
// DIS-LABEL: <global_async_to_lds_widths>:
// DIS: global_load_async_to_lds_b8 v0, v1, s[0:1]
// DIS-NEXT: global_load_async_to_lds_b32 v2, v3, s[0:1] offset:64
// DIS-NEXT: global_load_async_to_lds_b64 v4, v5, s[0:1] offset:-64
// DIS-NEXT: global_load_async_to_lds_b128 v6, v7, s[0:1] offset:128
// DIS-NEXT: s_endpgm
func.func @global_async_to_lds_widths() {
  %lds8 = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 1, 0>
  %global8 = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 1, 1>
  %lds32 = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 1, 2>
  %global32 = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 1, 3>
  %lds64 = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 1, 4>
  %global64 = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 1, 5>
  %lds128 = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 1, 6>
  %global128 = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 1, 7>
  %base = waveamdmachine.uninit
      : !waveamdmachine.reg<sgpr, 2, 0>
  %root = waveamdmachine.token : !waveamdmachine.mem.token
  %b8 = waveamdmachine.global_load_async_to_lds_b8
      %lds8, %global8, %base after %root
      : (!waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<vgpr, 1, 1>,
         !waveamdmachine.reg<sgpr, 2, 0>,
         !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  %b32 = waveamdmachine.global_load_async_to_lds_b32
      %lds32, %global32, %base after %b8 offset 64
      : (!waveamdmachine.reg<vgpr, 1, 2>,
         !waveamdmachine.reg<vgpr, 1, 3>,
         !waveamdmachine.reg<sgpr, 2, 0>,
         !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  %b64 = waveamdmachine.global_load_async_to_lds_b64
      %lds64, %global64, %base after %b32 offset -64
      : (!waveamdmachine.reg<vgpr, 1, 4>,
         !waveamdmachine.reg<vgpr, 1, 5>,
         !waveamdmachine.reg<sgpr, 2, 0>,
         !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  %b128 = waveamdmachine.global_load_async_to_lds_b128
      %lds128, %global128, %base after %b64 offset 128
      : (!waveamdmachine.reg<vgpr, 1, 6>,
         !waveamdmachine.reg<vgpr, 1, 7>,
         !waveamdmachine.reg<sgpr, 2, 0>,
         !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm
  return
}

}
