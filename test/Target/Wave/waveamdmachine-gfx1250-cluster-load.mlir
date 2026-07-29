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

// ROUNDTRIP-LABEL: func.func @cluster_load_widths
// ROUNDTRIP: [[M0:%.*]] = waveamdmachine.s_mov_m0
// ROUNDTRIP: [[ROOT:%.*]] = waveamdmachine.token
// ROUNDTRIP: [[V32:%.*]], [[T32:%.*]] = waveamdmachine.cluster_load_b32 {{.*}}, [[M0]] after [[ROOT]]
// ROUNDTRIP: [[V64:%.*]], [[T64:%.*]] = waveamdmachine.cluster_load_b64 {{.*}}, [[M0]] after [[T32]]
// ROUNDTRIP: [[V128:%.*]], [[T128:%.*]] = waveamdmachine.cluster_load_b128 {{.*}}, [[M0]] after [[T64]]
// ROUNDTRIP: [[A8:%.*]] = waveamdmachine.cluster_load_async_to_lds_b8 {{.*}}, [[M0]] after [[T128]]
// ROUNDTRIP: [[A32:%.*]] = waveamdmachine.cluster_load_async_to_lds_b32 {{.*}}, [[M0]] after [[A8]]
// ROUNDTRIP: [[A64:%.*]] = waveamdmachine.cluster_load_async_to_lds_b64 {{.*}}, [[M0]] after [[A32]]
// ROUNDTRIP: waveamdmachine.cluster_load_async_to_lds_b128 {{.*}}, [[M0]] after [[A64]]
// ASM-LABEL: cluster_load_widths:
// ASM: s_mov_b32 m0, s2
// ASM-NEXT: cluster_load_b32 v4, v0, s[0:1] offset:-64
// ASM-NEXT: cluster_load_b64 v[6:7], v0, s[0:1] offset:8000000
// ASM-NEXT: cluster_load_b128 v[8:11], v0, s[0:1] offset:128
// ASM-NEXT: cluster_load_async_to_lds_b8 v1, v0, s[0:1] offset:-32
// ASM-NEXT: cluster_load_async_to_lds_b32 v1, v0, s[0:1] offset:32
// ASM-NEXT: cluster_load_async_to_lds_b64 v1, v0, s[0:1] offset:96
// ASM-NEXT: cluster_load_async_to_lds_b128 v1, v0, s[0:1] offset:160
// ASM-NEXT: s_endpgm
// DIS-LABEL: <cluster_load_widths>:
// DIS: s_mov_b32 m0, s2
// DIS-NEXT: cluster_load_b32 v4, v0, s[0:1] offset:-64
// DIS-NEXT: cluster_load_b64 v[6:7], v0, s[0:1] offset:8000000
// DIS-NEXT: cluster_load_b128 v[8:11], v0, s[0:1] offset:128
// DIS-NEXT: cluster_load_async_to_lds_b8 v1, v0, s[0:1] offset:-32
// DIS-NEXT: cluster_load_async_to_lds_b32 v1, v0, s[0:1] offset:32
// DIS-NEXT: cluster_load_async_to_lds_b64 v1, v0, s[0:1] offset:96
// DIS-NEXT: cluster_load_async_to_lds_b128 v1, v0, s[0:1] offset:160
// DIS-NEXT: s_endpgm
func.func @cluster_load_widths() {
  %offset = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 1, 0>
  %lds = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 1, 1>
  %base = waveamdmachine.uninit
      : !waveamdmachine.reg<sgpr, 2, 0>
  %mask = waveamdmachine.uninit
      : !waveamdmachine.reg<sgpr, 1, 2>
  %m0 = waveamdmachine.s_mov_m0 %mask
      : (!waveamdmachine.reg<sgpr, 1, 2>) -> !waveamdmachine.m0
  %root = waveamdmachine.token : !waveamdmachine.mem.token
  %v32, %t32 = waveamdmachine.cluster_load_b32
      %offset, %base, %m0 after %root offset -64
      : (!waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<sgpr, 2, 0>,
         !waveamdmachine.m0,
         !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1, 4>,
            !waveamdmachine.mem.token)
  %v64, %t64 = waveamdmachine.cluster_load_b64
      %offset, %base, %m0 after %t32 offset 8000000
      : (!waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<sgpr, 2, 0>,
         !waveamdmachine.m0,
         !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 2, 6>,
            !waveamdmachine.mem.token)
  %v128, %t128 = waveamdmachine.cluster_load_b128
      %offset, %base, %m0 after %t64 offset 128
      : (!waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<sgpr, 2, 0>,
         !waveamdmachine.m0,
         !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 4, 8>,
            !waveamdmachine.mem.token)
  %a8 = waveamdmachine.cluster_load_async_to_lds_b8
      %lds, %offset, %base, %m0 after %t128 offset -32
      : (!waveamdmachine.reg<vgpr, 1, 1>,
         !waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<sgpr, 2, 0>,
         !waveamdmachine.m0,
         !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  %a32 = waveamdmachine.cluster_load_async_to_lds_b32
      %lds, %offset, %base, %m0 after %a8 offset 32
      : (!waveamdmachine.reg<vgpr, 1, 1>,
         !waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<sgpr, 2, 0>,
         !waveamdmachine.m0,
         !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  %a64 = waveamdmachine.cluster_load_async_to_lds_b64
      %lds, %offset, %base, %m0 after %a32 offset 96
      : (!waveamdmachine.reg<vgpr, 1, 1>,
         !waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<sgpr, 2, 0>,
         !waveamdmachine.m0,
         !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  %a128 = waveamdmachine.cluster_load_async_to_lds_b128
      %lds, %offset, %base, %m0 after %a64 offset 160
      : (!waveamdmachine.reg<vgpr, 1, 1>,
         !waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<sgpr, 2, 0>,
         !waveamdmachine.m0,
         !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm
  return
}

}
