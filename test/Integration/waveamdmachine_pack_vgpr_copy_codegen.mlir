// RUN: wave-opt --waveamd-pack-vgpr-zero-moves %s \
// RUN:   | wave-translate --wave-to-amdgpu-asm - \
// RUN:   | FileCheck %s --check-prefix=ASM
// RUN: wave-opt --waveamd-pack-vgpr-zero-moves %s \
// RUN:   | wave-translate --wave-to-amdgpu-asm - \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// ASM-LABEL: pack_vgpr_copy_codegen:
// ASM: v_mov_b64_e32 v[8:9], v[100:101]
// ASM: v_mov_b64_e32 v[10:11], v[104:105]
// ASM-NOT: v_mov_b32_e32 v8, v100
// ASM: global_store_dwordx4 v[0:1], v[8:11], off
func.func @pack_vgpr_copy_codegen(
    %addr: !waveamdmachine.reg<vgpr, 2, 0>,
    %src0: !waveamdmachine.reg<vgpr, 4, 100>,
    %src1: !waveamdmachine.reg<vgpr, 4, 104>) {
  %parts0:4 = waveamdmachine.tuple_to_elements %src0
      : (!waveamdmachine.reg<vgpr, 4, 100>) ->
        (!waveamdmachine.reg<vgpr, 1, 100>,
         !waveamdmachine.reg<vgpr, 1, 101>,
         !waveamdmachine.reg<vgpr, 1, 102>,
         !waveamdmachine.reg<vgpr, 1, 103>)
  %parts1:4 = waveamdmachine.tuple_to_elements %src1
      : (!waveamdmachine.reg<vgpr, 4, 104>) ->
        (!waveamdmachine.reg<vgpr, 1, 104>,
         !waveamdmachine.reg<vgpr, 1, 105>,
         !waveamdmachine.reg<vgpr, 1, 106>,
         !waveamdmachine.reg<vgpr, 1, 107>)
  %a = waveamdmachine.v_mov_b32_tuple %parts0#0
      : (!waveamdmachine.reg<vgpr, 1, 100>) -> !waveamdmachine.reg<vgpr, 1, 8>
  %b = waveamdmachine.v_mov_b32_tuple %parts0#1
      : (!waveamdmachine.reg<vgpr, 1, 101>) -> !waveamdmachine.reg<vgpr, 1, 9>
  %c = waveamdmachine.v_mov_b32_tuple %parts1#0
      : (!waveamdmachine.reg<vgpr, 1, 104>) -> !waveamdmachine.reg<vgpr, 1, 10>
  %d = waveamdmachine.v_mov_b32_tuple %parts1#1
      : (!waveamdmachine.reg<vgpr, 1, 105>) -> !waveamdmachine.reg<vgpr, 1, 11>
  %wide = waveamdmachine.tuple_from_elements %a, %b, %c, %d
      : (!waveamdmachine.reg<vgpr, 1, 8>,
         !waveamdmachine.reg<vgpr, 1, 9>,
         !waveamdmachine.reg<vgpr, 1, 10>,
         !waveamdmachine.reg<vgpr, 1, 11>)
      -> !waveamdmachine.reg<vgpr, 4, 8>
  %tok = waveamdmachine.global_store_b128_addr64 %addr, %wide
      : (!waveamdmachine.reg<vgpr, 2, 0>, !waveamdmachine.reg<vgpr, 4, 8>)
        -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm
  return
}

// ASM-LABEL: same_phys_vgpr_copy_codegen:
// ASM-NOT: v_mov_b32_e32 v4, v4
// ASM-NOT: v_mov_b32_e32 v5, v5
// ASM-NOT: v_mov_b32_e32 v6, v6
// ASM-NOT: v_mov_b32_e32 v7, v7
// ASM: v_accvgpr_write_b32 a4, v4
// ASM: v_accvgpr_write_b32 a5, v5
// ASM: v_accvgpr_write_b32 a6, v6
// ASM: v_accvgpr_write_b32 a7, v7
func.func @same_phys_vgpr_copy_codegen(
    %addr: !waveamdmachine.reg<vgpr, 2, 0>,
    %src: !waveamdmachine.reg<vgpr, 4, 4>) {
  %copy = waveamdmachine.v_mov_b32_tuple %src {registers = 4 : i64}
      : (!waveamdmachine.reg<vgpr, 4, 4>) -> !waveamdmachine.reg<vgpr, 4, 4>
  %acc = waveamdmachine.v_accvgpr_write_b32_tuple %copy
      : (!waveamdmachine.reg<vgpr, 4, 4>) -> !waveamdmachine.reg<agpr, 4, 4>
  %read = waveamdmachine.v_accvgpr_read_b32_tuple %acc
      : (!waveamdmachine.reg<agpr, 4, 4>) -> !waveamdmachine.reg<vgpr, 4, 8>
  %tok = waveamdmachine.global_store_b128_addr64 %addr, %read
      : (!waveamdmachine.reg<vgpr, 2, 0>, !waveamdmachine.reg<vgpr, 4, 8>)
        -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm
  return
}

}
