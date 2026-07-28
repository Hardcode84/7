// RUN: wave-opt --waveamd-insert-ticket-waits %s \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline \
// RUN:       wave-translate --wave-to-amdgpu-asm - > %t.s
// RUN: FileCheck %s --check-prefix=ASM < %t.s
// RUN: not grep -E '(^|[[:space:]])s_waitcnt([[:space:]]|$)|s_waitcnt_vscnt' %t.s
// RUN: llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1250 \
// RUN:   -filetype=obj -o %t.o %t.s 2> %t.mc.err
// RUN: not grep -i warning %t.mc.err
// RUN: llvm-objdump -d --mcpu=gfx1250 %t.o > %t.dis
// RUN: FileCheck %s --check-prefix=DIS < %t.dis
// RUN: not grep -E '(^|[[:space:]])s_waitcnt([[:space:]]|$)|s_waitcnt_vscnt' %t.dis

module attributes {
  waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"
} {

// ASM-LABEL: split_waitcnts:
// ASM: s_wait_loadcnt 0x1
// ASM-NEXT: s_wait_storecnt 0x2
// ASM-NEXT: s_wait_dscnt 0x3
// ASM-NEXT: s_wait_kmcnt 0x4
// ASM-NEXT: s_wait_xcnt 0x5
// ASM-NEXT: s_wait_loadcnt_dscnt 0x607
// ASM-NEXT: s_wait_storecnt_dscnt 0x809
// ASM-NEXT: s_wait_loadcnt_dscnt 0xa0c
// ASM-NEXT: s_wait_storecnt 0xb
// ASM-NEXT: s_endpgm
// DIS-LABEL: <split_waitcnts>:
// DIS: s_wait_loadcnt 0x1
// DIS-NEXT: s_wait_storecnt 0x2
// DIS-NEXT: s_wait_dscnt 0x3
// DIS-NEXT: s_wait_kmcnt 0x4
// DIS-NEXT: s_wait_xcnt 0x5
// DIS-NEXT: s_wait_loadcnt_dscnt 0x607
// DIS-NEXT: s_wait_storecnt_dscnt 0x809
// DIS-NEXT: s_wait_loadcnt_dscnt 0xa0c
// DIS-NEXT: s_wait_storecnt 0xb
// DIS-NEXT: s_endpgm
func.func @split_waitcnts() {
  waveamdmachine.s_waitcnt_split loadcnt(1)
  waveamdmachine.s_waitcnt_split storecnt(2)
  waveamdmachine.s_waitcnt_split dscnt(3)
  waveamdmachine.s_waitcnt_split kmcnt(4)
  waveamdmachine.s_waitcnt_split xcnt(5)
  waveamdmachine.s_waitcnt_split loadcnt(6) dscnt(7)
  waveamdmachine.s_waitcnt_split storecnt(8) dscnt(9)
  waveamdmachine.s_waitcnt_split loadcnt(10) storecnt(11) dscnt(12)
  waveamdmachine.s_endpgm
  return
}

// ASM-LABEL: generated_split_waitcnts:
// ASM: global_load_b32 v3, v0, s[0:1]
// ASM-NEXT: ds_load_b32 v4, v2
// ASM-NEXT: s_wait_loadcnt_dscnt 0x0
// ASM-NEXT: v_add_nc_u32_e32 v5, v3, v4
// ASM-NEXT: s_load_b32 s4, s[0:1], 0x0
// ASM-NEXT: s_wait_kmcnt 0x0
// ASM-NEXT: s_add_co_i32 s5, s4, 1
// ASM-NEXT: global_store_b32 v0, v6, s[0:1]
// ASM-NEXT: s_wait_xcnt 0x0
// ASM-NEXT: v_add_nc_u32_e32 v6, v7, v8
// ASM-NEXT: s_endpgm
// DIS-LABEL: <generated_split_waitcnts>:
// DIS: s_wait_loadcnt_dscnt 0x0
// DIS: s_wait_kmcnt 0x0
// DIS: s_wait_xcnt 0x0
// DIS-NOT: s_waitcnt
func.func @generated_split_waitcnts() {
  %off = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 1, 0>
  %lds_addr = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 1, 2>
  %base = waveamdmachine.uninit
      : !waveamdmachine.reg<sgpr, 2, 0>
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %global = waveamdmachine.global_load_b32 %off, %base
      : (!waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<sgpr, 2, 0>)
        -> !waveamdmachine.reg<vgpr, 1, 3>
  %lds = waveamdmachine.ds_load_b32 %lds_addr
      : (!waveamdmachine.reg<vgpr, 1, 2>)
        -> !waveamdmachine.reg<vgpr, 1, 4>
  %sum = waveamdmachine.v_add_u32 %global, %lds
      : (!waveamdmachine.reg<vgpr, 1, 3>,
         !waveamdmachine.reg<vgpr, 1, 4>)
        -> !waveamdmachine.reg<vgpr, 1, 5>
  %smem = waveamdmachine.s_load_b32 %zero, "s[0:1]"
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1, 4>
  %ssum, %scc = waveamdmachine.s_add_i32 %smem, %one
      : (!waveamdmachine.reg<sgpr, 1, 4>, !waveamdmachine.imm)
        -> (!waveamdmachine.reg<sgpr, 1, 5>,
            !waveamdmachine.reg<scc, 1>)
  %stored = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 1, 6>
  waveamdmachine.global_store_b32 %off, %stored, %base
      : (!waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<vgpr, 1, 6>,
         !waveamdmachine.reg<sgpr, 2, 0>) -> ()
  %lhs = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 1, 7>
  %rhs = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 1, 8>
  %clobber = waveamdmachine.v_add_u32 %lhs, %rhs
      : (!waveamdmachine.reg<vgpr, 1, 7>,
         !waveamdmachine.reg<vgpr, 1, 8>)
        -> !waveamdmachine.reg<vgpr, 1, 6>
  waveamdmachine.s_endpgm
  return
}

}
